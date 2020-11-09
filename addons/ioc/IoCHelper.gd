extends Resource

class_name IoC

static func inject(to: String, service_identifier: String):
	return {
		"to": to,
		"service_identifier": service_identifier,
		"all": false,
		"constructor": false
	}

static func constructor(target: Dictionary):
	target["constructor"] = true
	return target
	
static func all(target: Dictionary):
	target["all"] = true
	return target
	
static func tagged(target: Dictionary, tag: String, value):
	target["tagged"] = {
		"tag": tag,
		"value": value
	}
	return target
	
	
static func named(target: Dictionary, name: String):
	return tagged(target, "name", name)
