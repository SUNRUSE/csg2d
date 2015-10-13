describe "addShapeElement", ->
	rewire = require "rewire"
	addShapeElement = undefined
	beforeEach ->
		addShapeElement = rewire "./addShapeElement"
		
	describe "imports", ->
		it "history", -> expect(addShapeElement.__get__ "history").toBe require "./history"
	
	describe "on calling", ->
		document = history = visible = undefined
		beforeEach ->
			visible = false
			viewport = 
				appendChild: (element) ->
					expect(element).toEqual "test element"
					visible = true
				removeChild: (element) ->
					expect(element).toEqual "test element"
					visible = false
			
			history = 
				addStep: jasmine.createSpy "addStep"
			addShapeElement.__set__ "history", history
			
			document = 
				getElementById: (id) ->
					switch id
						when "viewport" then viewport
						else null
			addShapeElement.__set__ "document", document
			
			addShapeElement "test element"
		
		it "appends the element to the viewport", ->
			expect(visible).toBeTruthy()
		it "adds a history step", ->
			expect(history.addStep).toHaveBeenCalledWith (jasmine.any Function), (jasmine.any Function), (jasmine.any Function)
			expect(history.addStep.calls.count()).toEqual 1
		describe "on discarding", ->
			beforeEach ->
				(history.addStep.calls.argsFor 0)[2]()
			it "does nothing", ->
				expect(visible).toBeTruthy()
			it "does not add another history step", ->
				expect(history.addStep.calls.count()).toEqual 1
		describe "on undoing", ->
			beforeEach ->
				(history.addStep.calls.argsFor 0)[0]()
			it "removes the element from the viewport", ->
				expect(visible).toBeFalsy()
			it "does not add another history step", ->
				expect(history.addStep.calls.count()).toEqual 1
			describe "on discarding", ->
				beforeEach ->
					(history.addStep.calls.argsFor 0)[2]()
				it "does nothing", ->
					expect(visible).toBeFalsy()
				it "does not add another history step", ->
					expect(history.addStep.calls.count()).toEqual 1
			describe "on redoing", ->
				beforeEach ->
					(history.addStep.calls.argsFor 0)[1]()
				it "re-adds the element to the viewport", ->
					expect(visible).toBeTruthy()
				it "does not add another history step", ->
					expect(history.addStep.calls.count()).toEqual 1