history = require "./history"

# Call with an element representing a shape to add it to the viewport.
module.exports = (element) ->
	shapes = document.getElementById "shapes"
	shapes.appendChild element
	history.addStep (-> shapes.removeChild element), (-> shapes.appendChild element), (->)