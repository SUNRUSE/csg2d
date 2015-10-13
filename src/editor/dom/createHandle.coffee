# Given:
# - An element to add a handle to.
# - A string specifying the kind of handle to add.
# Creates a new div with the "handle" attribute set to the given kind of handle to add, and appends it to the given element.
module.exports = (element, kind) ->
	handle = document.createElement "div"
	handle.className = "handle"
	handle.setAttribute "kind", kind
	element.appendChild handle