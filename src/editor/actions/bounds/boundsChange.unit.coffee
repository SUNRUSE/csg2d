describe "boundsChange", ->
	rewire = require "rewire"
	
	boundsChange = undefined
	beforeEach ->
		boundsChange = rewire "./boundsChange"
		
	describe "imports", ->
		it "history", -> expect(boundsChange.__get__ "history").toBe require "./../history"
		
	describe "on calling", ->
		history = element = result = undefined
		beforeEach ->
			history = 
				addStep: jasmine.createSpy "addStep"
			boundsChange.__set__ "history", history
			
			element = 
				style:
					left: "before left"
					top: "before top"
					height: "before height"
					width: "before width"
					transform: "before transform"
				
			result = boundsChange element
		
		it "does not modify top", ->
			expect(element.style.top).toEqual "before top"
		it "does not modify left", ->
			expect(element.style.left).toEqual "before left"
		it "does not modify width", ->
			expect(element.style.width).toEqual "before width"
		it "does not modify height", ->
			expect(element.style.height).toEqual "before height"
		it "does not modify transform", ->
			expect(element.style.transform).toEqual "before transform"
		it "returns a function", ->
			expect(result).toEqual jasmine.any Function
		it "does not add a history step yet", ->
			expect(history.addStep).not.toHaveBeenCalled()
		describe "on calling the result", ->
			beforeEach ->
				element.style.top = "after top"
				element.style.left = "after left"
				element.style.width = "after width"
				element.style.height = "after height"
				element.style.transform = "after transform"
				
				result()
			it "does not modify top", ->
				expect(element.style.top).toEqual "after top"
			it "does not modify left", ->
				expect(element.style.left).toEqual "after left"
			it "does not modify width", ->
				expect(element.style.width).toEqual "after width"
			it "does not modify height", ->
				expect(element.style.height).toEqual "after height"
			it "does not modify transform", ->
				expect(element.style.transform).toEqual "after transform"
			it "adds a history step", ->
				expect(history.addStep).toHaveBeenCalledWith (jasmine.any Function), (jasmine.any Function), (jasmine.any Function)
				expect(history.addStep.calls.count()).toEqual 1
			describe "on discarding", ->
				beforeEach ->
					(history.addStep.calls.argsFor 0)[2]()
				it "does not modify top", ->
					expect(element.style.top).toEqual "after top"
				it "does not modify left", ->
					expect(element.style.left).toEqual "after left"
				it "does not modify width", ->
					expect(element.style.width).toEqual "after width"
				it "does not modify height", ->
					expect(element.style.height).toEqual "after height"
				it "does not modify transform", ->
					expect(element.style.transform).toEqual "after transform"
				it "does not add another history step", ->
					expect(history.addStep.calls.count()).toEqual 1
			describe "on undoing", ->
				beforeEach ->
					(history.addStep.calls.argsFor 0)[0]()
				it "reverts top", ->
					expect(element.style.top).toEqual "before top"
				it "reverts left", ->
					expect(element.style.left).toEqual "before left"
				it "reverts width", ->
					expect(element.style.width).toEqual "before width"
				it "reverts height", ->
					expect(element.style.height).toEqual "before height"
				it "reverts transform", ->
					expect(element.style.transform).toEqual "before transform"
				it "does not add another history step", ->
					expect(history.addStep.calls.count()).toEqual 1
				describe "on discarding", ->
					beforeEach ->
						(history.addStep.calls.argsFor 0)[2]()
					it "reverts top", ->
						expect(element.style.top).toEqual "before top"
					it "reverts left", ->
						expect(element.style.left).toEqual "before left"
					it "reverts width", ->
						expect(element.style.width).toEqual "before width"
					it "reverts height", ->
						expect(element.style.height).toEqual "before height"
					it "reverts transform", ->
						expect(element.style.transform).toEqual "before transform"
					it "does not add another history step", ->
						expect(history.addStep.calls.count()).toEqual 1
				describe "on redoing", ->
					beforeEach ->
						(history.addStep.calls.argsFor 0)[1]()
					it "restores top", ->
						expect(element.style.top).toEqual "after top"
					it "restores left", ->
						expect(element.style.left).toEqual "after left"
					it "restores width", ->
						expect(element.style.width).toEqual "after width"
					it "restores height", ->
						expect(element.style.height).toEqual "after height"
					it "restores transform", ->
						expect(element.style.transform).toEqual "after transform"
					it "does not add another history step", ->
						expect(history.addStep.calls.count()).toEqual 1