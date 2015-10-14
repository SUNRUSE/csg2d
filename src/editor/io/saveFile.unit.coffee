describe "saveFile", ->
    rewire = require "rewire"
    
    saveFile = undefined
    beforeEach ->
        saveFile = rewire "./saveFile"
    
    describe "imports", ->
        
    describe "on calling", ->
        window = document = body = undefined
        beforeEach ->
            body = {}
            saveFile.__set__ "body", body
            
            document = 
                body: body
            saveFile.__set__ "document", document
                
            window = 
                navigator: {}
                document: document
            saveFile.__set__ "window", window
            
        describe "on Firefox/Chrome", ->
            anchor = onPage = attributes = undefined
            beforeEach ->
                onPage = false
                attributes = {}
                anchor =
                    click: jasmine.createSpy()
                    setAttribute: (key, value) -> attributes[key] = value
                    
                anchor.click.and.callFake ->
                    expect(onPage).toBeTruthy()
                    expect(attributes.href).toEqual "data:application/json;charset=utf-8,%5B1%2C2%2C3%2C4%5D"
                    expect(attributes.download).toEqual "test filename"
                    
                document.createElement = jasmine.createSpy "createElement"
                document.createElement.and.returnValue anchor
                
                body.appendChild = (el) ->
                    expect(el).toBe anchor
                    onPage = true
                    
                body.removeChild = (el) ->
                    expect(el).toBe anchor
                    onPage = false
                
                saveFile "test filename", [1, 2, 3, 4]
            
            it "creates one anchor tag", ->
                expect(document.createElement.calls.count()).toEqual 1
                expect(document.createElement).toHaveBeenCalledWith "a"
            
            it "is not on the page by the end of the function", ->
                expect(onPage).toBeFalsy()
                
            it "was clicked", ->
                expect(anchor.click.calls.count()).toEqual 1
            
        describe "on IE/Edge", ->
            blob = blobInstance = undefined
            
            beforeEach ->
                window.navigator.msSaveBlob = jasmine.createSpy "msSaveBlob"
                
                blobInstance = undefined
                blob = jasmine.createSpy "Blob"
                blob.and.callFake -> blobInstance = this
                saveFile.__set__ "Blob", blob
                
                saveFile "test filename", [1, 2, 3, 4]
                
            it "creates a Blob", ->
                expect(blob.calls.count()).toEqual 1
                expect(blob).toHaveBeenCalledWith ["[1,2,3,4]"],
                    type: "application/json;charset=utf-8;"
                
            it "calls msSaveBlob", ->
                expect(window.navigator.msSaveBlob.calls.count()).toEqual 1
                expect((window.navigator.msSaveBlob.calls.argsFor 0)[0]).toBe blobInstance
                expect((window.navigator.msSaveBlob.calls.argsFor 0)[1]).toEqual "test filename"