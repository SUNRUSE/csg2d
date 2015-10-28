describe "loadRig", ->
	rewire = require "rewire"
	loadRig = undefined
	beforeEach -> loadRig = rewire "./loadRig"
	
	describe "imports", ->
		it "point", -> expect(loadRig.__get__ "point").toBe require "./point"
		it "link", -> expect(loadRig.__get__ "link").toBe require "./link"
	
	describe "on calling", ->
		scene = point = link = create = undefined
		pointA = pointB = pointC = undefined
		updateA = updateB = updateC = undefined
		pointModelA = pointModelB = pointModelC = undefined
		linkA = linkB = undefined
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
				materials:
					materialA: "test material a"
					materialB: "test material b"
				points:
					pointA:
						location:
							x: 6
							y: 18
						material: "materialB"
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
				links:
					linkA:
						from: "pointB"
						to: "pointA"
						strength: "linkAStrength"
						linearityScale: "linkALinearityScale"
						linearityShape: "linkALinearityShape"
					linkB:
						from: "pointC"
						to: "pointB"
						strength: "linkBStrength"
						linearityScale: "linkBLinearityScale"
						linearityShape: "linkBLinearityShape"
				
			offset = 
				x: 13
				y: -4
				
			updateA = jasmine.createSpy "updateA"
			updateB = jasmine.createSpy "updateB"
			updateC = jasmine.createSpy "updateC"
			create = jasmine.createSpy "create"
			create.and.callFake (model) -> switch model
				when pointModelA then updateA
				when pointModelB then updateB
				when pointModelC then updateC
				else null
				
			loadRig "test distance field", "test gravity", rig, offset, scene, create
			
		it "creates every point once", ->
			expect(point.calls.count()).toEqual 3
			expect(point).toHaveBeenCalledWith "test distance field", "test gravity",
				location:
					x: 19
					y: 14
				velocity:
					x: 0
					y: 0
				material: "test material b"
				
			expect(point).toHaveBeenCalledWith "test distance field", "test gravity",
				location:
					x: 37
					y: 8
				velocity:
					x: 0
					y: 0
				material: "test material a"
				
			expect(point).toHaveBeenCalledWith "test distance field", "test gravity",
				location:
					x: 17
					y: 19
				velocity:
					x: 0
					y: 0
				material: "test material b"
				
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
			
			expect(link).toHaveBeenCalledWith pointModelB, pointModelA, "linkALinearityScale", "linkALinearityShape", "linkAStrength"
			expect(link).toHaveBeenCalledWith pointModelC, pointModelB, "linkBLinearityScale", "linkBLinearityShape", "linkBStrength"
			
		it "does not update the links", ->
			expect(linkA).not.toHaveBeenCalled()
			expect(linkB).not.toHaveBeenCalled()
			
		it "executes the creation callback for every point", ->
			expect(create.calls.count()).toEqual 3
			
			expect(create).toHaveBeenCalledWith pointModelA
			expect(create).toHaveBeenCalledWith pointModelB
			expect(create).toHaveBeenCalledWith pointModelC
			
		it "does not execute the update callbacks returned", ->
			expect(updateA).not.toHaveBeenCalled()
			expect(updateB).not.toHaveBeenCalled()
			expect(updateC).not.toHaveBeenCalled()
			
		it "adds functions to the scene", ->
			expect(scene.append).toHaveBeenCalled()
			expect(args).toEqual [jasmine.any Function] for args in scene.append.calls.allArgs() 
		
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
				
			it "does not execute the creation callback again", ->
				run()
				expect(create.calls.count()).toEqual 3
				
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
				
			it "executes the update callbacks returned once", ->
				run()
				expect(updateA.calls.count()).toEqual 1
				expect(updateB.calls.count()).toEqual 1
				expect(updateC.calls.count()).toEqual 1
				
			it "executes the update callbacks after the points", ->
				updateA.and.callFake -> expect(pointA).toHaveBeenCalled()
				updateB.and.callFake -> expect(pointB).toHaveBeenCalled()
				updateC.and.callFake -> expect(pointC).toHaveBeenCalled()
				run()