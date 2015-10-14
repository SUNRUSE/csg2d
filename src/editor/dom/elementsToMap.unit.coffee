describe "elementsToMap", ->
    rewire = require "rewire"
    
    elementsToMap = undefined
    
    beforeEach ->
        elementsToMap = rewire "./elementsToMap"
    
    describe "imports", ->
        it "elementToShape", -> expect(elementsToMap.__get__ "elementToShape").toBe require "./elementToShape"
        
    describe "on calling", ->
        result = document = undefined
        beforeEach ->
            document = 
                getElementById: (id) ->
                    switch id
                        when "shapes"
                            children: [
                                    "test element a"
                                    "test element b"
                                    "test element c"
                                ]
                        else null
            elementsToMap.__set__ "document", document

            elementsToMap.__set__ "elementToShape", (element) ->
                switch element
                    when "test element a" then "test shape a"
                    when "test element b" then "test shape b"
                    when "test element c" then "test shape c"
                    else fail "unexpected element"
            
            result = elementsToMap()
        
        it "returns the map generated", ->
            expect(result).toEqual
                shapes: [
                        "test shape a"
                        "test shape b"
                        "test shape c"
                    ]