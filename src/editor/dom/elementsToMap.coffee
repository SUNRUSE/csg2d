elementToShape = require "./elementToShape"
elementToEntity = require "./elementToEntity"

# On calling, returns the elements in the current viewport converted to a map
# object.
module.exports = () ->
    output = 
        shapes: (elementToShape element for element in (document.getElementById "shapes").children)
        entities: {}
        
    for element in (document.getElementById "entities").children
        entity = elementToEntity element
        type = output.entities[entity.type] = output.entities[entity.type] or {}
        type[entity.name] = entity.value
        
    output