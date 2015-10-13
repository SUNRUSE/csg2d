history = require "./history"

# Call with an element representing a shape to change the operator of.
# At present, this just alternates between "add" and "subtract".
module.exports = (element) ->
	invert = ->
		element.setAttribute "operator", switch element.getAttribute "operator"
			when "add" then "subtract"
			else "add"
	invert()
	history.addStep invert, invert, (->)