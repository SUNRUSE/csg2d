describe "loadRig", ->
	rewire = require "rewire"
	loadRig = undefined
	beforeEach -> loadRig = rewire "./loadRig"
	
	describe "imports", ->
		it "point", -> expect(loadRig.__get__ "point").toBe require "./point"
		it "link", -> expect(loadRig.__get__ "link").toBe require "./link"
	
	describe "on calling", ->
		scene = point = link = undefined
		pointA = pointB = pointC = undefined
		pointModelA = pointModelB = pointModelC = undefined
		linkA = linkB = undefined
		result = undefined
		beforeEach ->
			point = jasmine.createSpy "point"
			pointA = jasmine.createSpy "pointA"
			pointB = jasmine.createSpy "pointB"
			pointC = jasmine.createSpy "pointC"
			pointModelA = pointModelB = pointModelC = undefined
			point.and.callFake (distanceField, gravity, point) -> switch point.location.x
				when 19
					pointModelA = point
					pointA
				when 37
					pointModelB = point 
					pointB
				when 17
					pointModelC = point 
					pointC
				else null
			loadRig.__set__ "point", point
			
			link = jasmine.createSpy "link"
			linkA = jasmine.createSpy "linkA"
			linkB = jasmine.createSpy "linkB"
			link.and.callFake (from) -> switch from
				when pointModelB then linkA
				when pointModelC then linkB
				else null
			loadRig.__set__ "link", link
			
			scene = 
				append: jasmine.createSpy "append"
				
			rig = 
				pointMaterials:
					materialA: "test point material a"
					materialB: "test point material b"
				points:
					pointA:
						location:
							x: 6
							y: 18
						material: "materialB"
						sprite: "test point sprite 1"
					pointB:
						location:
							x: 24
							y: 12
						material: "materialA"
					pointC:
						location:
							x: 4
							y: 23
						material: "materialB"
						sprite: "test point sprite 2"
				linkMaterials:
					materialA: "test link material a"
					materialB: "test link material b"
					materialC: "test link material c"
				links:
					linkA:
						from: "pointB"
						to: "pointA"
						material: "materialC"
						controls: "test controls a"
						sprite: "test link sprite 1"
					linkB:
						from: "pointC"
						to: "pointB"
						material: "materialB"
						controls: "test controls b"
			offset = 
				x: 13
				y: -4
				
			result = loadRig "test distance field", "test gravity", rig, offset, scene, "test gamepad"
			
		it "creates every point once", ->
			expect(point.calls.count()).toEqual 3
			expect(point).toHaveBeenCalledWith "test distance field", "test gravity",
				location:
					x: 19
					y: 14
				velocity:
					x: 0
					y: 0
				material: "test point material b"
				sprite: "test point sprite 1"
				
			expect(point).toHaveBeenCalledWith "test distance field", "test gravity",
				location:
					x: 37
					y: 8
				velocity:
					x: 0
					y: 0
				material: "test point material a"
				
			expect(point).toHaveBeenCalledWith "test distance field", "test gravity",
				location:
					x: 17
					y: 19
				velocity:
					x: 0
					y: 0
				material: "test point material b"
				sprite: "test point sprite 2"
				
		it "creates distinct point models", ->
			expect(pointModelA).not.toBe pointModelB
			expect(pointModelA).not.toBe pointModelC
			expect(pointModelB).not.toBe pointModelC
			
		it "does not update the points", ->
			expect(pointA).not.toHaveBeenCalled()
			expect(pointB).not.toHaveBeenCalled()
			expect(pointC).not.toHaveBeenCalled()
			
		it "creates every link once", ->
			expect(link.calls.count()).toEqual 2
			
			expect(link).toHaveBeenCalledWith pointModelB, pointModelA, "test link material c", "test gamepad", "test controls a"
			expect(link).toHaveBeenCalledWith pointModelC, pointModelB, "test link material b", "test gamepad", "test controls b"
			
		it "does not update the links", ->
			expect(linkA).not.toHaveBeenCalled()
			expect(linkB).not.toHaveBeenCalled()
			
		it "adds functions to the scene", ->
			expect(scene.append).toHaveBeenCalled()
			expect(args).toEqual [jasmine.any Function] for args in scene.append.calls.allArgs() 
		
		it "returns an object", ->
			expect(result).toEqual jasmine.any Object
			
		it "copies the created points", ->
			expect(result.points.pointA).toBe pointModelA
			expect(result.points.pointB).toBe pointModelB
			expect(result.points.pointC).toBe pointModelC
		
		it "copies the created links", ->
			expect(result.links.linkA.from).toBe pointModelB
			expect(result.links.linkA.to).toBe pointModelA
			expect(result.links.linkA.sprite).toEqual "test link sprite 1"
			expect(result.links.linkB.from).toBe pointModelC
			expect(result.links.linkB.to).toBe pointModelB
			expect(result.links.linkB.sprite).toBeUndefined()
		
		describe "on updating the scene", ->
			before = run = undefined
			beforeEach ->
				before = scene.append.calls.count()
				run = -> callback[0]() for callback in scene.append.calls.allArgs() 
						
			it "does not add any further functions", ->
				run()
				expect(scene.append.calls.count()).toEqual before
				
			it "does not create any new points", ->
				run()
				expect(point.calls.count()).toEqual 3
				
			it "does not create any new links", ->
				run()
				expect(link.calls.count()).toEqual 2
				
			it "updates every point once", ->
				run()
				expect(pointA.calls.count()).toEqual 1
				expect(pointB.calls.count()).toEqual 1
				expect(pointC.calls.count()).toEqual 1
				
			it "updates every link once", ->
				run()
				expect(linkA.calls.count()).toEqual 1
				expect(linkB.calls.count()).toEqual 1
				
			it "updates every link after the points", ->
				check = ->
					expect(pointA).toHaveBeenCalled()
					expect(pointB).toHaveBeenCalled()
					expect(pointC).toHaveBeenCalled()
				
				linkA.and.callFake check
				linkB.and.callFake check
				run()