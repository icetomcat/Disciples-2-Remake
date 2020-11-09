extends Node

var _bindings: Dictionary = {}

class BindingToSyntax:
	var _container
	var _service_identifier
	
	func _init(container, service_identifier):
		_container = container
		_service_identifier = service_identifier
		
	func _to_scope(value, scope):
		if not _container._bindings.has(_service_identifier):
			_container._bindings[_service_identifier] = []
		var binding = {
			"scope": scope,
			"bind": value,
			"tags": {}
		}
		_container._bindings[_service_identifier].push_back(binding)
		return BindingInWhenOnSyntax.new(binding)
		
	func to_constant_value(value):
		return _to_scope(value, "constant")
		
	func to(value) -> BindingInWhenOnSyntax:
		return _to_scope(value, "default")

class Constraint:
	var _target: Object
	var _method: String
	
	func _init(target: Object, method: String):
		if not target.has_method(method):
			push_error("No method")
		_target = target
		_method = method
		
	func _invoke(args: Array = []) -> bool:
		return _target.callv(_method, args)
		
	static func _target_tagged(bind, target) -> bool:
		if not target.has("tagged"):
			return false
		if not bind.tags.has(target["tagged"]["tag"]):
			return false
		return bind.tags[target["tagged"]["tag"]] == target["tagged"]["value"]

class BindingInSyntax:
	var _binding
	
	func _init(binding):
		_binding = binding
		
	func in_singletone_scope() -> BindingWhenSyntax:
		_binding["scope"] = "singletone"
		return BindingWhenSyntax.new(_binding)
		
class BindingWhenSyntax:
	var _binding
	
	func _init(binding):
		_binding = binding
		
	func when(constraint: Constraint):
		_binding["constraint"] = constraint
		
	func when_target_tagged(tag: String, value: String):
		_binding["tags"][tag] = value
		when(Constraint.new(Constraint, "_target_tagged"))
		
	func when_target_named(name: String):
		when_target_tagged("name", name)

class BindingInWhenOnSyntax:
	var _binding
	var _binding_in: BindingInSyntax
	var _binding_when: BindingWhenSyntax
	
	func _init(binding):
		_binding = binding
		_binding_in = BindingInSyntax.new(_binding)
		_binding_when = BindingWhenSyntax.new(_binding)
		
	func in_singletone_scope() -> BindingWhenSyntax:
		return _binding_in.in_singletone_scope()
		
	func when(constraint: Constraint):
		return _binding_when.when(constraint)
		
	func when_target_tagged(tag: String, value: String):
		return _binding_when.when_target_tagged(tag, value)
		
	func when_target_named(name: String):
		return _binding_when.when_target_named(name)

func bind(service_identifier: String) -> BindingToSyntax:
	return BindingToSyntax.new(self, service_identifier)
	
func _get_contsructor_dependencies(bind):
	if not bind.bind.has_method("_get_dependencies"):
		return []
	return [] # ToDo

func _inject_property_dependencies(bind, object: Object):
	if not bind.bind.has_method("_get_dependencies"):
		return
	var dependencies = bind.bind._get_dependencies()
	for dep in dependencies:
		if dep.constructor:
			continue
		if dep.all:
			pass # ToDo
		else:
			var result
			for _bind in _find_bindings(dep.service_identifier):
				result = _resolve(_bind, dep)
				if result:
					break
			if not result:
				push_error("No service with name %s" % dep.service_identifier)
			object.set(dep.to, result)
	
func _resolve(bind, target):
	if bind.has("constraint") and not bind.constraint._invoke([bind, target]):
		return null
	if bind.scope == "default":
		var result
		if bind.bind is PackedScene:
			result = bind.bind.callv("instance", _get_contsructor_dependencies(bind))
		elif bind.bind is Script:
			result = bind.bind.callv("new", _get_contsructor_dependencies(bind))
		if result:
			_inject_property_dependencies(bind, result)
		return result
	elif bind.scope == "singletone":
		var result
		if bind.bind is PackedScene:
			result = bind.bind.callv("instance", _get_contsructor_dependencies(bind))
		elif bind.bind is Script:
			result = bind.bind.callv("new", _get_contsructor_dependencies(bind))
		if result:
			bind.scope = "constant"
			bind.bind = result
			_inject_property_dependencies(bind, result)
		return result
	elif bind.scope == "constant":
		return bind.bind
	
func _find_bindings(service_identifier: String):
	if not _bindings.has(service_identifier):
		push_error("No service with name %s" %service_identifier)
		return []
	return _bindings[service_identifier]
	
func get(service_identifier: String):
	for bind in _find_bindings(service_identifier):
		var result = _resolve(bind, {})
		if result:
			return result
	
func get_tagged(service_identifier: String, tag: String, value):
	for bind in _find_bindings(service_identifier):
		var result = _resolve(bind, {
			"tagged": {
				"tag": tag,
				"value": value
			}
		})
		if result:
			return result

func get_all(service_identifier: String):
	var result = []
	for bind in _find_bindings(service_identifier):
		result.push_back(_resolve(bind, {}))
	return result
