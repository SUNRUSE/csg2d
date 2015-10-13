history = require "./history"

# Call with an element representing a shape to add it to the viewport.
module.exports = (element) ->
	viewport = document.getElementById "viewport"
	viewport.appendChild element
	history.addStep (-> viewport.removeChild element), (-> viewport.appendChild element), (->)