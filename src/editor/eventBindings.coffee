# Binds to on-mouse/touch-down/up/move and defers to "events" to actually deal with those events.
events = require "./events"


window.onload = ->
	window.scrollTo (document.body.scrollWidth - window.innerWidth) / 2, (document.body.scrollHeight - window.innerHeight) / 2
	document.onmousedown = (e) -> 
		events.tap e.target
		events.start e.target
	document.onmousemove = (e) -> events.move e.pageX, e.pageY
	document.onmouseup = (e) -> events.end()
	document.ontouchstart = (e) ->events.start e.target
	document.ontouchmove = (e) -> events.move e.touches[0].pageX, e.touches[0].pageY
	document.ontouchend = (e) -> events.end()