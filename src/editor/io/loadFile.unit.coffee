describe "loadFile", ->
    rewire = require "rewire"
    
    loadFile = undefined
    beforeEach ->
        loadFile = rewire "./loadFile"
        
    describe "imports", ->
        it "mapToElements", -> expect(loadFile.__get__ "mapToElements").toBe require "./../dom/mapToElements"
        
    describe "on calling", ->
        mapToElements = openFile = fileReader = fileReaderInstance = alert = undefined
        beforeEach ->
            fileReader = jasmine.createSpy "FileReader"
            fileReader.and.callFake -> 
                fileReaderInstance = this
                this.readAsText = jasmine.createSpy "readAsText"
                this
            loadFile.__set__ "FileReader", fileReader
            
            mapToElements = jasmine.createSpy "mapToElements"
            loadFile.__set__ "mapToElements", mapToElements
            
            openFile = {}
            
            document = 
                getElementById: (id) -> switch id
                    when "openFile" then openFile
                    else null
            loadFile.__set__ "document", document
            
            alert = jasmine.createSpy "alert"
            loadFile.__set__ "alert", alert
            
            loadFile()
        
        it "sets up an event handler for a file upload", ->
            expect(openFile.onchange).toEqual jasmine.any Function
        it "does not yet create a FileReader", ->
            expect(fileReader).not.toHaveBeenCalled()
        it "does not show an alert", ->
            expect(alert).not.toHaveBeenCalled()
        it "does not run mapToElements", ->
            expect(mapToElements).not.toHaveBeenCalled()
            
        describe "on unselecting a file", ->
            beforeEach ->
                openFile.files = []
                openFile.onchange()
            it "does not create a FileReader", ->
                expect(fileReader).not.toHaveBeenCalled()
            it "does not show an alert", ->
                expect(alert).not.toHaveBeenCalled()
            it "does not run mapToElements", ->
                expect(mapToElements).not.toHaveBeenCalled()
            
        describe "on receiving a file", ->
            file = undefined
            beforeEach ->
                file = {}
                openFile.files = [file]
                openFile.onchange()
            it "creates a FileReader", ->
                expect(fileReader.calls.count()).toEqual 1
            it "then begins reading the file as text", ->
                expect(fileReaderInstance.readAsText.calls.count()).toEqual 1
                expect(fileReaderInstance.readAsText).toHaveBeenCalledWith file
            it "does not show an alert", ->
                expect(alert).not.toHaveBeenCalled()
            it "does not run mapToElements", ->
                expect(mapToElements).not.toHaveBeenCalled()
                
            describe "on success", ->
                describe "when valid JSON", ->
                    beforeEach ->
                        fileReaderInstance.result = "[4,5,6]"
                        fileReaderInstance.onload()
                    it "does not create another FileReader", ->
                        expect(fileReader.calls.count()).toEqual 1
                    it "does not begin reading another file", ->
                        expect(fileReaderInstance.readAsText.calls.count()).toEqual 1
                    it "passes the deserialized JSON to mapToElements", ->
                        expect(mapToElements.calls.count()).toEqual 1
                        expect(mapToElements).toHaveBeenCalledWith [4, 5, 6]
                    it "does not show an alert", ->
                        expect(alert).not.toHaveBeenCalled()
            
                describe "when invalid JSON", ->
                    beforeEach ->
                        fileReader.result = "fish"
                        fileReaderInstance.onload()
                    it "does not create another FileReader", ->
                        expect(fileReader.calls.count()).toEqual 1
                    it "does not begin reading another file", ->
                        expect(fileReaderInstance.readAsText.calls.count()).toEqual 1
                    it "does not run mapToElements", ->
                        expect(mapToElements).not.toHaveBeenCalled()
                    it "shows an alert", ->
                        expect(alert.calls.count()).toEqual 1
                        expect(alert).toHaveBeenCalledWith "This file could not be read."
                        
            describe "on abort", ->
                beforeEach -> fileReaderInstance.onabort()
                it "does not create another FileReader", ->
                    expect(fileReader.calls.count()).toEqual 1
                it "does not begin reading another file", ->
                    expect(fileReaderInstance.readAsText.calls.count()).toEqual 1
                it "does not run mapToElements", ->
                    expect(mapToElements).not.toHaveBeenCalled()
                it "shows an alert", ->
                    expect(alert.calls.count()).toEqual 1
                    expect(alert).toHaveBeenCalledWith "Reading this file was aborted."
                        
            describe "on failure", ->
                beforeEach -> fileReaderInstance.onerror()
                it "does not create another FileReader", ->
                    expect(fileReader.calls.count()).toEqual 1
                it "does not begin reading another file", ->
                    expect(fileReaderInstance.readAsText.calls.count()).toEqual 1
                it "does not run mapToElements", ->
                    expect(mapToElements).not.toHaveBeenCalled()
                it "shows an alert", ->
                    expect(alert.calls.count()).toEqual 1
                    expect(alert).toHaveBeenCalledWith "This file could not be read."