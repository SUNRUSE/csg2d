entityNameIsUnique = require "./entityNameIsUnique"

# Given a string specifying an entity type, returns a name which is unique to that type.
module.exports = (type) ->
	for name in [1...Infinity]
		if entityNameIsUnique type, name.toString() then return name.toString() 