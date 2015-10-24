describe "play", ->
	rewire = require "rewire"
	stop = undefined
	beforeEach -> stop = rewire "./stop"
	
	describe "imports", ->
		it "play", -> expect(stop.__get__ "play").toBe require "./play"
			
	describe "on calling", ->
		document = play = preview = removed = undefined
		beforeEach ->
			removed = 0
			
			preview = 
				firstChild: "test element one"
				removeChild: (child) -> switch removed++
					when 0
						expect(child).toEqual "test element one"
						preview.firstChild = "test element two"
						undefined
					when 1
						expect(child).toEqual "test element two"
						preview.firstChild = "test element three"
						undefined
					when 2
						expect(child).toEqual "test element three"
						preview.firstChild = null
						undefined
					else fail "removed an unexpected element"
			
			document = 
				getElementById: (id) -> switch id
					when "preview" then preview
					else null
				body:
					setAttribute: jasmine.createSpy "setAttribute"
			stop.__set__ "document", document
			
			play =
				stop: jasmine.createSpy "stop" 
			stop.__set__ "play", play
			
			stop()
				
		it "changes the editor mode to \"edit\"", ->
			expect(document.body.setAttribute.calls.count()).toEqual 1
			expect(document.body.setAttribute).toHaveBeenCalledWith "mode", "edit"
			
		it "empties the preview element", ->
			expect(removed).toEqual 3
			
		it "stops the playing scene", ->
			expect(play.stop.calls.count()).toEqual 1