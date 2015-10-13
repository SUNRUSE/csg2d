undone = []
done = []

refreshButton = (array, id) ->
	if array.length
		document.getElementById id
			.removeAttribute "disabled"
	else
		document.getElementById id
			.setAttribute "disabled", "disabled"
			
refreshButtons = ->
	refreshButton undone, "redo"
	refreshButton done, "undo"

# A history of actions; implements undo/redo.
# - undo: Call when a history step should be undone.
# - undo: Call when an undone history step should be redone.
# - addStep: Call when a history step needs to be added with three arguments, assuming that the action has already been performed:
#	- A function to call when the step needs to be undone.
#	- A function to call when the step needs to be redone following undo.
#	- A function to call when the step is discarded.  Use this to clean up resources.  The argument is truthy when the step has not been undone or has been redone, and falsy when it has been undone.
module.exports = 
	undo: ->
		done[0].undo()
		undone.unshift done[0]
		done.shift()
		refreshButtons()
	redo: ->
		undone[0].redo()
		done.unshift undone[0]
		undone.shift()
		refreshButtons()
	addStep: (undo, redo, discard) ->
		if undone.length
			if window.confirm "You have undone changes which will be lost if you make this change.  Are you sure you wish to continue, losing your undone changes?"
				step.discard() for step in undone
				undone = []
			else
				undo()
				discard()
				return
		done.unshift 
			undo: undo
			redo: redo
			discard: discard
		refreshButtons()