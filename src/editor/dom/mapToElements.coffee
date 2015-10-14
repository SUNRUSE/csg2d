shapeToElement = require "./shapeToElement"
entityToElement = require "./entityToElement"

# On calling with a map object, replaces the contents of the viewport with
# elements based on the map object.
module.exports = (map) ->
    shapes = document.getElementById "shapes"
    shapes.removeChild shapes.firstChild while shapes.firstChild
    shapes.appendChild shapeToElement shape for shape in map.shapes
    
    entities = document.getElementById "entities"
    entities.removeChild entities.firstChild while entities.firstChild
    for type, names of map.entities
        for name, value of names
            entities.appendChild (entityToElement type, name, value)