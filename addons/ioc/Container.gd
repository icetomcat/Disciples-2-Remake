extends Resource

var _bindings: Dictionary = {}

class BindingToSyntax:
	var _container
	var _service_identifier
	
	func _init(container, service_identifier):
		_container = container
		_service_identifier = service_identifier
		
	func to_constant_value(value):
		if not _container._bindings.has(_service_identifier):
			_container._bindings[_service_identifier] = []
		var binding = {
			"scope": "constant",
			"bind": value
		}
		_container._bindings[_service_identifier].push_back(binding)
		return BindingWhenOnSyntax.new(_container, binding)
		
	func to(value) -> BindingWhenOnSyntax:
		if not value.has_meta("_dependencies"):
			value.set_meta("_dependencies", {})
		if not _container._bindings.has(_service_identifier):
			_container._bindings[_service_identifier] = []
		var binding = {
			"scope": "default",
			"bind": value
		}
		_container._bindings[_service_identifier].push_back(binding)
		return BindingWhenOnSyntax.new(_container, binding)

class BindingWhenOnSyntax:
	var _container
	var _binding
	
	func _init(container, binding):
		_container = container
		_binding = binding
		
	func when(constraint):
		_binding["constraint"] = constraint
		return self
		
	func in_singletone_scope():
		_binding["scope"] = "singletone"
		return self

func bind(service_identifier: String) -> BindingToSyntax:
	return BindingToSyntax.new(self, service_identifier)
	
func _resolve(bind):
	if bind.scope == "default":
		return bind.bind.callv("new", [])
	elif bind.scope == "singletone":
		var result = bind.bind.callv("new", [])
		bind.scope = "constant"
		bind.bind = result
		return result
	elif bind.scope == "constant":
		return bind.bind
	
func get(service_identifier: String):
	if not _bindings.has(service_identifier):
		push_error("No service with name %s" %service_identifier)
	var binds = _bindings[service_identifier]
	for bind in binds:
		return _resolve(bind)
	
func get_all(service_identifier: String):
	if not _bindings.has(service_identifier):
		push_error("No service with name %s" %service_identifier)
	var binds = _bindings[service_identifier]
	var result = []
	for bind in binds:
		result.push_back(_resolve(bind))
	return result

static func inject(object, property_name: String, service_identifier: String, tags = {}):
	var metadata = object.get_meta("_dependencies") or {}
	metadata[property_name] = {
		"service_identifier": service_identifier,
		"tags": tags,
	}
	object.set_meta("_dependencies")
