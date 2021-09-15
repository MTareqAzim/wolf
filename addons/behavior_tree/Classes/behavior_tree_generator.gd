extends Reference
class_name BehaviorTreeGenerator

enum Type {Root, Selector, Sequence, Parallel, Monitor, Inverter, Failer, Succeeder, Repeater, Action, Condition}

static func generate_tree(data: Array):
	if not data:
		return null
	
	var refs = _generate_refs(data)
	refs = _attach_children(refs, data)

	return refs["Root"]


static func _generate_refs(data: Array) -> Dictionary:
	var refs : Dictionary
	
	for ref_data in data:
		var ref = _generate_ref(ref_data)
		refs[ref_data["name"]] = ref
	
	return refs


static func _generate_ref(ref_data: Dictionary):
	var ref : BTBehavior
	match ref_data["type"]:
		Type.Root:
			ref = BTRoot.new()
		Type.Selector:
			ref = BTSelector.new()
		Type.Sequence:
			ref = BTSequence.new()
		Type.Parallel:
			var success_policy = ref_data["bdata"]["success_policy"]
			var failure_policy = ref_data["bdata"]["failure_policy"]
			ref = BTParallel.new(success_policy, failure_policy)
		Type.Monitor:
			ref = BTMonitor.new()
		Type.Inverter:
			ref = BTInverter.new()
		Type.Failer:
			ref = BTFailer.new()
		Type.Succeeder:
			ref = BTSucceeder.new()
		Type.Repeater:
			ref = BTRepeater.new()
			ref.set_count(ref_data["bdata"]["limit"])
		Type.Action:
			ref = BTAction.new()
			if ref_data.has("bdata"):
				ref.set_script(load(ref_data["bdata"]["script_path"]))
				for variable in ref_data["bdata"]["script_data"]:
					ref.set(variable, ref_data["bdata"]["script_data"][variable])
		Type.Condition:
			ref = BTCondition.new()
			if ref_data.has("bdata"):
				ref.set_script(load(ref_data["bdata"]["script_path"]))
				for variable in ref_data["bdata"]["script_data"]:
					ref.set(variable, ref_data["bdata"]["script_data"][variable])
	
	return ref


static func _attach_children(refs: Dictionary, data) -> Dictionary:
	for ref_data in data:
		if ref_data.has("children"):
			for child in ref_data["children"]:
				refs[ref_data["name"]].add_child(refs[child])
	
	return refs
