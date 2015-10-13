history = require "./history"

# Call with an element representing a shape to increase its CSG priority.
# Does not add a history step if already at the top of the stack.
module.exports = (element) ->
    behind = element.nextElementSibling
    if behind
        inFront = behind.nextElementSibling
        undo = ->
            element.parentNode.insertBefore element, behind
        redo = ->
            if inFront
                element.parentNode.insertBefore element, inFront
            else
                element.parentNode.appendChild element
        redo()
        history.addStep undo, redo, (->)