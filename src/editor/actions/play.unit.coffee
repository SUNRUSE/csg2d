describe "play", ->
	rewire = require "rewire"
	play = undefined
	beforeEach -> play = rewire "./play"
	
	describe "imports", ->
		it "elementsToMap", -> expect(play.__get__ "elementsToMap").toBe require "./../dom/elementsToMap"
		it "gravity", -> expect(play.__get__ "gravity").toBe require "./../../physics/falloff/gravity"
		it "mapToDistanceField", -> expect(play.__get__ "mapToDistanceField").toBe require "./../../physics/distanceFields/mapToDistanceField"
		it "valueOfObject", -> expect(play.__get__ "valueOfObject").toBe require "./../../utilities/random/valueOfObject"
		
		it "scene", -> expect(play.__get__ "scene").toBe require "./../../physics/points/scene"
		it "loadRig", -> expect(play.__get__ "loadRig").toBe require "./../../physics/points/loadRig"
		
		it "player", -> expect(play.__get__ "player").toBe require "./../../physics/points/rigs/player"
		it "gamepad", -> expect(play.__get__ "gamepad").toBe require "./../../input/gamepad"
		
		it "createPointElement", -> expect(play.__get__ "createPointElement").toBe require "./../dom/createPointElement"
		it "createLinkElement", -> expect(play.__get__ "createLinkElement").toBe require "./../dom/createLinkElement"
			
	describe "on calling", ->
		map = scene = loadRig = valueOfObject = alert = document = preview = createPointElement = createLinkElement = undefined
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
			
			play.__set__ "gamepad", "test gamepad"
			
			play.__set__ "mapToDistanceField", (_map) ->
				expect(_map).toBe map
				"test distance field"
				
			play.__set__ "gravity", (_map) ->
				expect(_map).toBe map
				"test gravity field"
				
			createPointElement = jasmine.createSpy "createPointElement"
			play.__set__ "createPointElement", createPointElement
			
			createLinkElement = jasmine.createSpy "createLinkElement"
			play.__set__ "createLinkElement", createLinkElement
			
			document = 
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
				
			it "does not create a scene", ->
				expect(scene).not.toHaveBeenCalled()
				
			it "does not load a rig", ->
				expect(loadRig).not.toHaveBeenCalled()
				
			it "shows an alert", ->
				expect(alert.calls.count()).toEqual 1
				expect(alert).toHaveBeenCalledWith "Please add a player spawn point."
				
			it "does not change the editor mode", ->
				expect(document.body.setAttribute).not.toHaveBeenCalled()
				
			it "does not create any elements for any points", ->
				expect(createPointElement).not.toHaveBeenCalled()
				
			it "does not create any elements for any links", ->
				expect(createLinkElement).not.toHaveBeenCalled()
				
		describe "when spawn points exist", ->
			sceneInstance = rigInstance = undefined
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
					
				rigInstance = 
					points:
						pointA: "test point a"
						pointB: "test point b"
						pointC: "test point c"
					links:
						linkA: "test link a"
						linkB: "test link b"
					
				loadRig.and.returnValue rigInstance
			
				play()
			
			it "determines a random spawn point", ->
				expect(valueOfObject.calls.count()).toEqual 1
				expect(valueOfObject).toHaveBeenCalledWith "test player entities"
				
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
				expect(loadRig).toHaveBeenCalledWith "test distance field", "test gravity field", "test player rig", offset, sceneInstance, "test gamepad"
				
			it "does not end the scene", ->
				expect(sceneInstance.stop).not.toHaveBeenCalled()
				
			it "makes the function to end the scene available", ->
				expect(play.stop).toBe sceneInstance.stop
				
			it "creates an element for every returned point", ->
				expect(createPointElement).toHaveBeenCalledWith sceneInstance, "test point a"
				expect(createPointElement).toHaveBeenCalledWith sceneInstance, "test point b"
				expect(createPointElement).toHaveBeenCalledWith sceneInstance, "test point c"
				
			it "creates an element for every returned link", ->
				expect(createLinkElement).toHaveBeenCalledWith sceneInstance, "test link a"
				expect(createLinkElement).toHaveBeenCalledWith sceneInstance, "test link b"