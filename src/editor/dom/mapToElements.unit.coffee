describe "mapToElements", ->
    rewire = require "rewire"
    
    mapToElements = undefined
    beforeEach ->
        mapToElements = rewire "./mapToElements"
        
    describe "imports", ->
        it "shapeToElement", -> expect(mapToElements.__get__ "shapeToElement").toBe require "./shapeToElement"
        
    describe "on calling", ->
        viewport = removed = undefined
        
        beforeEach ->
            mapToElements.__set__ "shapeToElement", (shape) -> switch shape
                when "test shape a" then "test element a"
                when "test shape b" then "test element b"
                when "test shape c" then "test element c"
                when "test shape d" then "test element d"
                else expect(false).toBeTruthy()
                
            removed = 0
                
            viewport = 
                firstChild: "test to remove a"
                removeChild: (child) -> 
                    switch removed
                        when 0
                            expect(child).toEqual "test to remove a"
                            viewport.firstChild = "test to remove b"
                            removed++
                        when 1
                            expect(child).toEqual "test to remove b"
                            viewport.firstChild = "test to remove c"
                            removed++
                        when 2
                            expect(child).toEqual "test to remove c"
                            viewport.firstChild = null
                            removed++
                        else fail "removed unexpected item"
                appendChild: jasmine.createSpy "appendChild"
                
            viewport.appendChild.and.callFake (child) ->
                expect(removed).toEqual 3
                    
                
            document = 
                getElementById: (id) -> switch id
                    when "viewport" then viewport
                    else expect(false).toBeTruthy()
            mapToElements.__set__ "document", document
                
            mapToElements
                shapes: [
                        "test shape a"
                        "test shape b"
                        "test shape c"
                        "test shape d"
                    ]
        
        it "removes every child element from the viewport", ->
            expect(removed).toEqual 3
        
        it "appends a single element for each shape to the viewport in order", ->
            expect(viewport.appendChild.calls.allArgs()).toEqual [
                    ["test element a"],
                    ["test element b"],
                    ["test element c"],
                    ["test element d"]
                ]