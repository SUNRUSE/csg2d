# Given:
# - A string specifying the type of entity.
# - A string specifying the name for that entity.
# Returns truthy if no other entity exists with that type/name combination, else, falsy.
module.exports = (type, name) ->
	for el in document.getElementsByName name
		if el.className isnt "entity" then continue
		if (el.getAttribute "type") isnt type then continue
		return false
	true