createHandle = require "./createHandle"

# Given a shape from map JSON, returns an element which will represent it in the editor.
module.exports = (shape) ->
	element = document.createElement "div"
	element.setAttribute "operator", shape.operator
	element.className = "shape"
	element.tabIndex = 0
	createHandle element, "move"
	createHandle element, "delete"
	createHandle element, "operator"
	createHandle element, "clone"
	createHandle element, "pullForward"
	createHandle element, "pushBack"
	if shape.shape.radius
		element.setAttribute "shape", "circle"
		element.style.left = (shape.shape.origin.x - shape.shape.radius) + "rem"
		element.style.top = (shape.shape.origin.y - shape.shape.radius) + "rem"
		element.style.width = element.style.height = shape.shape.radius * 2 + "rem"
		createHandle element, "radiusTop"
		createHandle element, "radiusBottom"
		createHandle element, "radiusLeft"
		createHandle element, "radiusRight"
	else 
		element.setAttribute "shape", "rectangle"
		element.style.left = shape.shape.left + "rem"
		element.style.top = shape.shape.top + "rem"
		element.style.width = shape.shape.width + "rem"
		element.style.height = shape.shape.height + "rem"
		createHandle element, "left"
		createHandle element, "top"
		createHandle element, "bottom"
		createHandle element, "right"
	element