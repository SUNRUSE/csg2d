history = require "./history"

# Given:
# - An element.
# - A string specifying the id of a containing element.
# Creates a new history step adding the given element to the specified container.
module.exports = (element, container) ->
	containerEl = document.getElementById container
	containerEl.appendChild element
	history.addStep (-> containerEl.removeChild element), (-> containerEl.appendChild element), (->)