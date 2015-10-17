describe "play", ->
	rewire = require "rewire"
	stop = undefined
	beforeEach -> stop = rewire "./stop"
	
	describe "imports", ->
			
	describe "on calling", ->
		document = undefined
		beforeEach ->
			document = 
				body:
					setAttribute: jasmine.createSpy "setAttribute"
			stop.__set__ "document", document
			
			stop()
				
		it "changes the editor mode to \"edit\"", ->
			expect(document.body.setAttribute.calls.count()).toEqual 1
			expect(document.body.setAttribute).toHaveBeenCalledWith "mode", "edit"
			
		xit "removes the player", ->