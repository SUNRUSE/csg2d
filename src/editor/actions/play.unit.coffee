describe "play", ->
	rewire = require "rewire"
	play = undefined
	beforeEach -> play = rewire "./play"
	
	describe "imports", ->
		it "elementsToMap", -> expect(play.__get__ "elementsToMap").toBe require "./../dom/elementsToMap"
		it "mapToDistanceField", -> expect(play.__get__ "mapToDistanceField").toBe require "./../../physics/distanceFields/mapToDistanceField"
		it "valueOfObject", -> expect(play.__get__ "valueOfObject").toBe require "./../../utilities/random/valueOfObject"
		
		it "scene", -> expect(play.__get__ "scene").toBe require "./../../physics/points/scene"
		it "loadRig", -> expect(play.__get__ "loadRig").toBe require "./../../physics/points/loadRig"
		
		it "player", -> expect(play.__get__ "player").toBe require "./../../physics/points/rigs/player"
			
	describe "on calling", ->
		map = scene = loadRig = valueOfObject = alert = document = preview = undefined
		beforeEach ->
			valueOfObject = jasmine.createSpy "valueOfObject"
			play.__set__ "valueOfObject", valueOfObject
			
			alert = jasmine.createSpy "alert"
			play.__set__ "alert", alert
			
			scene = jasmine.createSpy "scene"
			play.__set__ "scene", scene
			
			loadRig = jasmine.createSpy "loadRig"
			play.__set__ "loadRig", loadRig
			
			play.__set__ "elementsToMap", -> map
			
			play.__set__ "player", "test player rig"
			
			play.__set__ "mapToDistanceField", (_map) ->
				expect(_map).toBe map
				"test distance field"
			
			preview = 
				appendChild: jasmine.createSpy "appendChild"
			
			document = 
				createElement: jasmine.createSpy "createElement"
				getElementById: (id) -> switch id
					when "preview" then preview
					else null
				body:
					setAttribute: jasmine.createSpy "setAttribute"
			play.__set__ "document", document
					
		describe "when no spawn points exist", ->
			beforeEach ->
				map = 
					entities: 
						otherEntities: "test other entitites"
				play()
			
			it "does not attempt to determine a random spawn point", ->
				expect(valueOfObject).not.toHaveBeenCalled()
			
			it "does not create any elements", ->
				expect(document.createElement).not.toHaveBeenCalled()
			
			it "does not append any elements to the viewport", ->
				expect(preview.appendChild).not.toHaveBeenCalled()
				
			it "does not create a scene", ->
				expect(scene).not.toHaveBeenCalled()
				
			it "does not load a rig", ->
				expect(loadRig).not.toHaveBeenCalled()
				
			it "shows an alert", ->
				expect(alert.calls.count()).toEqual 1
				expect(alert).toHaveBeenCalledWith "Please add a player spawn point."
				
			it "does not change the editor mode", ->
				expect(document.body.setAttribute).not.toHaveBeenCalled()
				
		describe "when spawn points exist", ->
			sceneInstance = undefined
			beforeEach ->
				sceneInstance = 
					stop: jasmine.createSpy "stop"
				scene.and.returnValue sceneInstance
				
				map = 
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
			
			it "does not create any elements", ->
				expect(document.createElement).not.toHaveBeenCalled()
			
			it "does not append any elements to the viewport", ->
				expect(preview.appendChild).not.toHaveBeenCalled()
				
			it "does not show an alert", ->
				expect(alert).not.toHaveBeenCalled()
				
			it "changes the editor mode to \"play\"", ->
				expect(document.body.setAttribute.calls.count()).toEqual 1
				expect(document.body.setAttribute).toHaveBeenCalledWith "mode", "play"
				
			it "makes one scene", ->
				expect(scene.calls.count()).toEqual 1
				
			it "loads the player rig into that scene", ->
				expect(loadRig.calls.count()).toEqual 1
				offset = 
					x: 80
					y: 33
				expect(loadRig).toHaveBeenCalledWith "test distance field", "test player rig", offset, sceneInstance, jasmine.any Function
				
			it "does not end the scene", ->
				expect(sceneInstance.stop).not.toHaveBeenCalled()
				
			it "makes the function to end the scene available", ->
				expect(play.stop).toBe sceneInstance.stop
				
			describe "on calling the creation callback", ->
				pointModel = result = element = undefined
				beforeEach ->
					pointModel = 
						location:
							x: 14
							y: 27
					element = 
						style: {}
					document.createElement.and.returnValue element
					result = (loadRig.calls.argsFor 0)[4] pointModel
				
				it "creates one new div", ->
					expect(document.createElement.calls.count()).toEqual 1
					expect(document.createElement).toHaveBeenCalledWith "div"
					
				it "sets the div's class to \"point\"", ->
					expect(element.className).toEqual "point"
					
				it "applies a transform style to position the point", ->
					expect(element.style.transform).toEqual "translate(14rem,27rem)"
				
				it "appends the div to the viewport", ->
					expect(preview.appendChild.calls.count()).toEqual 1
					expect(preview.appendChild).toHaveBeenCalledWith element
				
				it "does not end the scene", ->
					expect(sceneInstance.stop).not.toHaveBeenCalled()
				it "does not load any further player rigs", ->
					expect(loadRig.calls.count()).toEqual 1
				it "does not create further scenes", ->
					expect(scene.calls.count()).toEqual 1
				it "does not change the editor mode", ->
					expect(document.body.setAttribute.calls.count()).toEqual 1
				it "does not show an alert", ->
					expect(alert).not.toHaveBeenCalled()
				it "returns a function", ->
					expect(result).toEqual jasmine.any Function
					
				describe "on calling the returned function", ->
					beforeEach ->
						pointModel.location.x = 30
						pointModel.location.y = 11
						result()
						
					it "does not create new divs", ->
					it "does not append further divs to the viewport", ->
					it "does not end the scene", ->
					it "does not load any further player rigs", ->
					it "does not create further scenes", ->
					it "does not change the editor mode", ->
					it "does not show an alert", ->
					it "updates the style to match the point's updated location", ->
						expect(element.style.transform).toEqual "translate(30rem,11rem)"