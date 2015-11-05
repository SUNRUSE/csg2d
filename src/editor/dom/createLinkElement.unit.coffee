describe "createLinkElement", ->
	rewire = require "rewire"
	createLinkElement = undefined
	beforeEach -> createLinkElement = rewire "./createLinkElement"
	
	describe "on calling", ->
		preview = document = div = scene = link = undefined
		beforeEach ->
			link = 
				from: 
					location: 
						x: 320
						y: 512
				to:
					location:
						x: 112
						y: 640
			
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
			createLinkElement.__set__ "document", document
			
			scene = 
				append: jasmine.createSpy "append"
				
		describe "without a sprite", ->
			beforeEach ->
				createLinkElement scene, link
			it "does not create a div", ->
				expect(document.createElement).not.toHaveBeenCalled()
			it "does not append to the viewport", ->
				expect(preview.appendChild).not.toHaveBeenCalled()
			it "does not register a callback with the scene", ->
				expect(scene.append).not.toHaveBeenCalled()
			it "does not modify the link", ->
				expect(link).toEqual 
					from: 
						location: 
							x: 320
							y: 512
					to:
						location:
							x: 112
							y: 640
							
		describe "with a sprite", ->
			beforeEach ->
				link.sprite = "test sprite"
				createLinkElement scene, link
			it "creates a single div", ->
				expect(document.createElement.calls.count()).toEqual 1
				expect(document.createElement).toHaveBeenCalledWith "div"
			it "appends the div to the viewport", ->
				expect(preview.appendChild.calls.count()).toEqual 1
				expect(preview.appendChild).toHaveBeenCalledWith div
			it "sets the div's class to \"link\"", ->
				expect(div.className).toEqual "link"
			it "copies the div's sprite attribute", ->
				expect(div.setAttribute).toHaveBeenCalledWith "sprite", "test sprite"
			it "copies the link's length to the div's width", ->
				widthRegex = /(\d+\.\d+)rem$/
				expect(div.style.width).toMatch widthRegex
				expect(parseFloat (widthRegex.exec div.style.width)[1]).toBeCloseTo 244.23
			it "copies the link's location to the div's style", ->
				transformRegex = /translate\((\d+(?:\.\d+)?)rem, (\d+(?:\.\d+)?)rem\) rotate\((\d+(?:\.\d+)?)rad\)$/
				expect(div.style.transform).toMatch transformRegex
				expect(parseFloat (transformRegex.exec div.style.transform)[1]).toBeCloseTo 320
				expect(parseFloat (transformRegex.exec div.style.transform)[2]).toBeCloseTo 512
				expect(parseFloat (transformRegex.exec div.style.transform)[3]).toBeCloseTo 2.59
			it "registers a single callback with the scene", ->
				expect(scene.append.calls.count()).toEqual 1
				expect(scene.append).toHaveBeenCalledWith jasmine.any Function
			it "does not modify the link", ->
				expect(link).toEqual 
					from: 
						location: 
							x: 320
							y: 512
					to:
						location:
							x: 112
							y: 640
					sprite: "test sprite"
			describe "when the scene updates", ->
				beforeEach ->
					link.from.location.x = 890
					link.from.location.y = 224
					link.to.location.x = 450
					link.to.location.y = 180
					(scene.append.calls.argsFor 0)[0]()
				it "does not create further elements", ->
					expect(document.createElement.calls.count()).toEqual 1
				it "does not append further elements to the viewport", ->
					expect(preview.appendChild.calls.count()).toEqual 1
				it "does not change the div's class", ->
					expect(div.className).toEqual "link"
				it "copies the link's new length to the div's width", ->
					widthRegex = /(\d+\.\d+)rem$/
					expect(div.style.width).toMatch widthRegex
					expect(parseFloat (widthRegex.exec div.style.width)[1]).toBeCloseTo 442.19
				it "copies the link's new location to the div's style", ->
					transformRegex = /translate\((-?\d+(?:\.\d+)?)rem, (-?\d+(?:\.\d+)?)rem\) rotate\((-?\d+(?:\.\d+)?)rad\)$/
					expect(div.style.transform).toMatch transformRegex
					expect(parseFloat (transformRegex.exec div.style.transform)[1]).toBeCloseTo 890
					expect(parseFloat (transformRegex.exec div.style.transform)[2]).toBeCloseTo 224
					expect(parseFloat (transformRegex.exec div.style.transform)[3]).toBeCloseTo -3.04
				it "does not register further callbacks with the scene", ->
					expect(scene.append.calls.count()).toEqual 1
				it "does not modify the link", ->
					expect(link).toEqual 
						from: 
							location: 
								x: 890
								y: 224
						to:
							location:
								x: 450
								y: 180
						sprite: "test sprite"