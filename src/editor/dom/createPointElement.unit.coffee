describe "createPointElement", ->
	rewire = require "rewire"
	createPointElement = undefined
	beforeEach -> createPointElement = rewire "./createPointElement"
	
	describe "on calling", ->
		preview = document = div = scene = point = undefined
		beforeEach ->
			point = 
				location: 
					x: 320
					y: 512
			
			div = 
				style: {}
				setAttribute: jasmine.createSpy "setAttribute"
				
			preview = 
				appendChild: jasmine.createSpy "appendChild"
				
			document = 
				createElement: jasmine.createSpy "createElement"
				getElementById: (id) -> switch id
					when "preview" then preview
					else null
			document.createElement.and.returnValue div
			createPointElement.__set__ "document", document
			
			scene = 
				append: jasmine.createSpy "append"
			
		describe "without a sprite", ->
			beforeEach ->
				createPointElement scene, point
			it "does not create a div", ->
				expect(document.createElement).not.toHaveBeenCalled()
			it "does not append to the viewport", ->
				expect(preview.appendChild).not.toHaveBeenCalled()
			it "does not register a callback with the scene", ->
				expect(scene.append).not.toHaveBeenCalled()
			it "does not modify the point", ->
				expect(point).toEqual 
					location: 
						x: 320
						y: 512
		describe "with a sprite", ->
			beforeEach ->
				point.sprite = "test sprite"
				createPointElement scene, point
			it "creates a single div", ->
				expect(document.createElement.calls.count()).toEqual 1
				expect(document.createElement).toHaveBeenCalledWith "div"
			it "appends the div to the viewport", ->
				expect(preview.appendChild.calls.count()).toEqual 1
				expect(preview.appendChild).toHaveBeenCalledWith div
			it "sets the div's class to \"point\"", ->
				expect(div.className).toEqual "point"
			it "copies the div's sprite attribute", ->
				expect(div.setAttribute).toHaveBeenCalledWith "sprite", "test sprite"
			it "copies the point's location to the div's style", ->
				expect(div.style.transform).toEqual "translate(320rem, 512rem)"
			it "registers a single callback with the scene", ->
				expect(scene.append.calls.count()).toEqual 1
				expect(scene.append).toHaveBeenCalledWith jasmine.any Function
			it "does not modify the point", ->
				expect(point).toEqual 
					location: 
						x: 320
						y: 512
					sprite: "test sprite"
			describe "when the scene updates", ->
				beforeEach ->
					point.location.x = 890
					point.location.y = 224
					(scene.append.calls.argsFor 0)[0]()
				it "does not create further elements", ->
					expect(document.createElement.calls.count()).toEqual 1
				it "does not append further elements to the viewport", ->
					expect(preview.appendChild.calls.count()).toEqual 1
				it "does not change the div's class", ->
					expect(div.className).toEqual "point"
				it "copies the point's new location to the div's style", ->
					expect(div.style.transform).toEqual "translate(890rem, 224rem)"
				it "does not register further callbacks with the scene", ->
					expect(scene.append.calls.count()).toEqual 1
				it "does not modify the point", ->
					expect(point).toEqual 
						location: 
							x: 890
							y: 224
						sprite: "test sprite"