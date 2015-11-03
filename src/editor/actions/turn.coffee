history = require "./history"

# Call with an element representing a shape to change the "position" of.
# Cycles through "topLeft", "topRight", "bottomRight" and "bottomLeft".
module.exports = (element) ->
	from = element.getAttribute "position"
	to = switch from 
		when "bottomLeft" then "topLeft"
		when "topLeft" then "topRight"
		when "topRight" then "bottomRight"
		when "bottomRight" then "bottomLeft"
	element.setAttribute "position", to
	history.addStep (-> element.setAttribute "position", from), (-> element.setAttribute "position", to), (->)