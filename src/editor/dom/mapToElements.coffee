shapeToElement = require "./shapeToElement"

# On calling with a map object, replaces the contents of the viewport with
# elements based on the map object.
module.exports = (map) ->
    viewport = document.getElementById "viewport"
    viewport.removeChild viewport.firstChild while viewport.firstChild
    
    viewport.appendChild shapeToElement shape for shape in map.shapes