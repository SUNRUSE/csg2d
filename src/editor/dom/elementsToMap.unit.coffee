describe "elementsToMap", ->
    rewire = require "rewire"
    
    elementsToMap = undefined
    
    beforeEach ->
        elementsToMap = rewire "./elementsToMap"
    
    describe "imports", ->
        it "elementToShape", -> expect(elementsToMap.__get__ "elementToShape").toBe require "./elementToShape"
        it "elementToEntity", -> expect(elementsToMap.__get__ "elementToEntity").toBe require "./elementToEntity"
        
    describe "on calling", ->
        result = document = undefined
        beforeEach ->
            document = 
                getElementById: (id) ->
                    switch id
                        when "shapes"
                            children: [
                                    "test shape element a"
                                    "test shape element b"
                                    "test shape element c"
                                ]
                        when "entities"
                            children: [
                                    "test entity element aa"
                                    "test entity element bb"
                                    "test entity element ab"
                                    "test entity element ba"
                                    "test entity element bc"
                                ]
                        else null
            elementsToMap.__set__ "document", document

            elementsToMap.__set__ "elementToShape", (element) ->
                switch element
                    when "test shape element a" then "test shape a"
                    when "test shape element b" then "test shape b"
                    when "test shape element c" then "test shape c"
                    else fail "unexpected shape element"
                    
            elementsToMap.__set__ "elementToEntity", (element) ->
                switch element
                    when "test entity element aa"
                        type: "entityTypeA"
                        name: "entityNameAA"
                        value: "test entity aa"
                    when "test entity element ab"
                        type: "entityTypeA"
                        name: "entityNameAB"
                        value: "test entity ab"
                    when "test entity element ba"
                        type: "entityTypeB"
                        name: "entityNameBA"
                        value: "test entity ba"
                    when "test entity element bb"
                        type: "entityTypeB"
                        name: "entityNameBB"
                        value: "test entity bb"
                    when "test entity element bc"
                        type: "entityTypeB"
                        name: "entityNameBC"
                        value: "test entity bc"
                    else fail "unexpected entity element"
            
            result = elementsToMap()
        
        it "returns the map generated", ->
            expect(result).toEqual
                shapes: [
                        "test shape a"
                        "test shape b"
                        "test shape c"
                    ]
                entities:
                    entityTypeA:
                        entityNameAA: "test entity aa"
                        entityNameAB: "test entity ab"
                    entityTypeB:
                        entityNameBA: "test entity ba"
                        entityNameBB: "test entity bb"
                        entityNameBC: "test entity bc"