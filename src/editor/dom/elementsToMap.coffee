elementToShape = require "./elementToShape"

# On calling, returns the elements in the current viewport converted to a map
# object.
module.exports = () ->
    shapes: (elementToShape element for element in (document.getElementById "shapes").children)