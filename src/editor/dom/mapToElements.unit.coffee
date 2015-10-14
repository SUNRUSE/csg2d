describe "mapToElements", ->
    rewire = require "rewire"
    
    mapToElements = undefined
    beforeEach ->
        mapToElements = rewire "./mapToElements"
        
    describe "imports", ->
        it "shapeToElement", -> expect(mapToElements.__get__ "shapeToElement").toBe require "./shapeToElement"
        it "entityToElement", -> expect(mapToElements.__get__ "entityToElement").toBe require "./entityToElement"
        
    describe "on calling", ->
        shapes = removedShapes = entities = removedEntities = undefined
        
        beforeEach ->
            mapToElements.__set__ "shapeToElement", (shape) -> switch shape
                when "test shape a" then "test shape element a"
                when "test shape b" then "test shape element b"
                when "test shape c" then "test shape element c"
                when "test shape d" then "test shape element d"
                else expect(false).toBeTruthy()
                
            removedShapes = 0
                
            shapes = 
                firstChild: "test shape to remove a"
                removeChild: (child) -> 
                    switch removedShapes
                        when 0
                            expect(child).toEqual "test shape to remove a"
                            shapes.firstChild = "test shape to remove b"
                            removedShapes++
                        when 1
                            expect(child).toEqual "test shape to remove b"
                            shapes.firstChild = "test shape to remove c"
                            removedShapes++
                        when 2
                            expect(child).toEqual "test shape to remove c"
                            shapes.firstChild = null
                            removedShapes++
                        else fail "removed unexpected item"
                appendChild: jasmine.createSpy "appendChild"
                
            shapes.appendChild.and.callFake (child) ->
                expect(removedShapes).toEqual 3
                    
            mapToElements.__set__ "entityToElement", (type, name, entity) -> switch entity
                when "test entity aa"
                    expect(type).toEqual "entityTypeA"
                    expect(name).toEqual "entityNameAA"
                    "test entity element aa"
                when "test entity ab"
                    expect(type).toEqual "entityTypeA"
                    expect(name).toEqual "entityNameAB" 
                    "test entity element ab"
                when "test entity ba"
                    expect(type).toEqual "entityTypeB"
                    expect(name).toEqual "entityNameBA" 
                    "test entity element ba"
                when "test entity bb" 
                    expect(type).toEqual "entityTypeB"
                    expect(name).toEqual "entityNameBB"
                    "test entity element bb"
                when "test entity bc"
                    expect(type).toEqual "entityTypeB"
                    expect(name).toEqual "entityNameBC" 
                    "test entity element bc"
                else fail "unexpected entity"
                    
            removedEntities = 0
                
            entities = 
                firstChild: "test entity to remove a"
                removeChild: (child) -> 
                    switch removedEntities
                        when 0
                            expect(child).toEqual "test entity to remove a"
                            entities.firstChild = "test entity to remove b"
                            removedEntities++
                        when 1
                            expect(child).toEqual "test entity to remove b"
                            entities.firstChild = null
                            removedEntities++
                        else fail "removed unexpected item"
                appendChild: jasmine.createSpy "appendChild"
                
            entities.appendChild.and.callFake (child) ->
                expect(removedEntities).toEqual 2
                
            document = 
                getElementById: (id) -> switch id
                    when "shapes" then shapes
                    when "entities" then entities
                    else expect(false).toBeTruthy()
            mapToElements.__set__ "document", document
                
            mapToElements
                shapes: [
                        "test shape a"
                        "test shape b"
                        "test shape c"
                        "test shape d"
                    ]
                entities:
                    entityTypeA:
                        entityNameAA: "test entity aa"
                        entityNameAB: "test entity ab"     
                    entityTypeB:
                        entityNameBA: "test entity ba"
                        entityNameBB: "test entity bb"
                        entityNameBC: "test entity bc"
        
        it "removes every shape element from the viewport", ->
            expect(removedShapes).toEqual 3
        
        it "appends a single element for each shape to the viewport in order", ->
            expect(shapes.appendChild.calls.allArgs()).toEqual [
                    ["test shape element a"],
                    ["test shape element b"],
                    ["test shape element c"],
                    ["test shape element d"]
                ]
                
        it "removes every entity element from the viewport", ->
            expect(removedEntities).toEqual 2
            
        it "appends a single element for each entity to the viewport", ->
            expect(entities.appendChild.calls.count()).toEqual 5
            expect(entities.appendChild).toHaveBeenCalledWith "test entity element aa"
            expect(entities.appendChild).toHaveBeenCalledWith "test entity element ab"
            expect(entities.appendChild).toHaveBeenCalledWith "test entity element ba"
            expect(entities.appendChild).toHaveBeenCalledWith "test entity element bb"
            expect(entities.appendChild).toHaveBeenCalledWith "test entity element bc"