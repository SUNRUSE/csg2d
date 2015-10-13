history = require "./history"

# Call with an element representing a shape to reduce its CSG priority.
# Does not add a history step if already at the bottom of the stack.
module.exports = (element) ->
    behind = element.previousElementSibling
    if behind
        inFront = element.nextElementSibling
        undo = ->
            if inFront
                element.parentNode.insertBefore element, inFront
            else
                element.parentNode.appendChild element
        redo = ->
            element.parentNode.insertBefore element, behind
        redo()
        history.addStep undo, redo, (->)