# A container for all "things" in a scene which require an update on a regular interval.
# This currently runs at 30Hz.
# Ticks only occur when the body is in the "play" mode.
# On calling, returns an object containing:
# - append: A function that when given a function, adds it to the list of functions to run.
# - stop: A function which stops the update loop entirely.
module.exports = ->
	toDo = ->
	clearId = setInterval (-> if (document.body.getAttribute "mode") is "play" then toDo()), 1000/60
	unused =
		append: (callback) ->
			toWrap = toDo
			toDo = ->
				toWrap()
				callback()
		stop: -> clearInterval clearId