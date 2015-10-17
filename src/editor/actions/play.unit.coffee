describe "play", ->
	rewire = require "rewire"
	play = undefined
	beforeEach -> play = rewire "./play"
	
	describe "imports", ->
		it "elementsToMap", -> expect(play.__get__ "elementsToMap").toBe require "./../dom/elementsToMap"
		it "valueOfObject", -> expect(play.__get__ "valueOfObject").toBe require "./../../utilities/random/valueOfObject"
			
	describe "on calling", ->
		valueOfObject = alert = document = undefined
		beforeEach ->
			valueOfObject = jasmine.createSpy "valueOfObject"
			play.__set__ "valueOfObject", valueOfObject
			
			alert = jasmine.createSpy "alert"
			play.__set__ "alert", alert
			
			document = 
				body:
					setAttribute: jasmine.createSpy "setAttribute"
			play.__set__ "document", document
					
		describe "when no spawn points exist", ->
			beforeEach ->
				play.__set__ "elementsToMap", ->
					entities: 
						otherEntities: "test other entitites"
				play()
			
			it "does not attempt to determine a random spawn point", ->
				expect(valueOfObject).not.toHaveBeenCalled()
			
			xit "does not create a player element", ->
			
			xit "does not append an element to the viewport", ->
				
			it "shows an alert", ->
				expect(alert.calls.count()).toEqual 1
				expect(alert).toHaveBeenCalledWith "Please add a player spawn point."
				
			it "does not change the editor mode", ->
				expect(document.body.setAttribute).not.toHaveBeenCalled()
				
		describe "when spawn points exist", ->
			beforeEach ->
				play.__set__ "elementsToMap", ->
					entities: 
						otherEntities: "test other entitites"
						player: "test player entities"
			
				valueOfObject.and.returnValue 
					origin: 
						x: 80
						y: 33
					facing: "right"
			
				play()
			
			it "determines a random spawn point", ->
				expect(valueOfObject.calls.count()).toEqual 1
				expect(valueOfObject).toHaveBeenCalledWith "test player entities"
			
			it "creates a player element at the specified position", ->
				
			it "appends the player element to the viewport", ->
				
			it "does not show an alert", ->
				expect(alert).not.toHaveBeenCalled()
				
			it "changes the editor mode to \"play\"", ->
				expect(document.body.setAttribute.calls.count()).toEqual 1
				expect(document.body.setAttribute).toHaveBeenCalledWith "mode", "play"