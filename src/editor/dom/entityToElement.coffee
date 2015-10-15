createHandle = require "./createHandle"

# Given:
# - A string identifying the type of entity.
# - A string identifying the name of the entity.
# - An object from map JSON defining that entity.
# Returns an element to represent it.
module.exports = (type, name, details) ->
	element = document.createElement "div"
	createHandle element, "delete"
	createHandle element, "clone"
	createHandle element, "moveMiddle"
	element.className = "entity"
	element.setAttribute "type", type
	element.setAttribute "name", name
	element.tabIndex = 0
	switch type
		when "player"
			element.style.left = details.origin.x + "rem"
			element.style.top = details.origin.y + "rem"
			element.setAttribute "facing", details.facing
	element