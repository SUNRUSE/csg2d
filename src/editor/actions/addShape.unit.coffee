describe "addShape", ->
	rewire = require "rewire"
	addShape = undefined
	
	beforeEach ->
		addShape = rewire "./addShape" 
	
	describe "imports", ->
		it "addShapeElement", ->
			expect(addShape.__get__ "addShapeElement").toBe require "./addShapeElement"
		it "shapeToElement", ->
			expect(addShape.__get__ "shapeToElement").toBe require "./../dom/shapeToElement"
		it "pixelsPerRem", ->
			expect(addShape.__get__ "pixelsPerRem").toBe require "./../dom/pixelsPerRem"
	
	describe "on calling", ->
		shape = addShapeElement = window = undefined
		beforeEach ->
			addShapeElement = jasmine.createSpy "addShapeElement"
			addShape.__set__ "addShapeElement", addShapeElement
			addShape.__set__ "pixelsPerRem", 7
			
			window = 
				innerWidth: 300
				innerHeight: 300
				pageXOffset: 2000
				pageYOffset: 3500
			addShape.__set__ "window", window
			
		describe "when the screen is wider than it is tall", ->
			beforeEach ->
				window.innerWidth = 600
				
			describe "circle", ->
				beforeEach ->
					addShape.__set__ "shapeToElement", (shape) ->
						expect(shape.operator).toEqual "test operator"
						expect(shape.shape.origin.x).toEqual 329
						expect(shape.shape.origin.y).toEqual 521
						expect(shape.shape.radius).toEqual 11
						"created element"
						
					addShape "circle", "test operator"
	
				it "appends the created element to the viewport", ->
					expect(addShapeElement.calls.count()).toEqual 1
					expect(addShapeElement).toHaveBeenCalledWith "created element"
				
			describe "rectangle", ->
				beforeEach ->				
					addShape.__set__ "shapeToElement", (shape) ->
						expect(shape.operator).toEqual "test operator"
						expect(shape.shape.left).toEqual 307
						expect(shape.shape.top).toEqual 511
						expect(shape.shape.width).toEqual 43
						expect(shape.shape.height).toEqual 21
						"created element"
	
					addShape "rectangle", "test operator"
	
				it "appends the created element to the viewport", ->
					expect(addShapeElement.calls.count()).toEqual 1
					expect(addShapeElement).toHaveBeenCalledWith "created element"
				
		describe "when the screen is taller than it is wide", ->
			beforeEach ->
				window.innerHeight = 600
				
			describe "circle", ->
				beforeEach ->
					addShape.__set__ "shapeToElement", (shape) ->
						expect(shape.operator).toEqual "test operator"
						expect(shape.shape.origin.x).toEqual 307
						expect(shape.shape.origin.y).toEqual 543
						expect(shape.shape.radius).toEqual 11
						"created element"
						
					addShape "circle", "test operator"
	
				it "appends the created element to the viewport", ->
					expect(addShapeElement.calls.count()).toEqual 1
					expect(addShapeElement).toHaveBeenCalledWith "created element"
				
			describe "rectangle", ->
				beforeEach ->
					addShape.__set__ "shapeToElement", (shape) ->
						expect(shape.operator).toEqual "test operator"
						expect(shape.shape.left).toEqual 296
						expect(shape.shape.top).toEqual 521
						expect(shape.shape.width).toEqual 21
						expect(shape.shape.height).toEqual 43
						"created element"
						
					addShape "rectangle", "test operator"
	
				it "appends the created element to the viewport", ->
					expect(addShapeElement.calls.count()).toEqual 1
					expect(addShapeElement).toHaveBeenCalledWith "created element"
				
		describe "when the screen is very narrow", ->
			beforeEach ->
				window.innerWidth = 2
				
			describe "circle", ->
				beforeEach ->
					addShape.__set__ "shapeToElement", (shape) ->
						expect(shape.operator).toEqual "test operator"
						expect(shape.shape.origin.x).toEqual 286
						expect(shape.shape.origin.y).toEqual 521
						expect(shape.shape.radius).toEqual 1
						"created element"
	
					addShape "circle", "test operator"
	
				it "appends the created element to the viewport", ->
					expect(addShapeElement.calls.count()).toEqual 1
					expect(addShapeElement).toHaveBeenCalledWith "created element"
				
			describe "rectangle", ->
				beforeEach ->
					addShape.__set__ "shapeToElement", (shape) ->
						expect(shape.operator).toEqual "test operator"
						expect(shape.shape.left).toEqual 286
						expect(shape.shape.top).toEqual 511
						expect(shape.shape.width).toEqual 1
						expect(shape.shape.height).toEqual 21
						"created element"
						
					addShape "rectangle", "test operator"
	
				it "appends the created element to the viewport", ->
					expect(addShapeElement.calls.count()).toEqual 1
					expect(addShapeElement).toHaveBeenCalledWith "created element"
				
		describe "when the screen is very short", ->
			beforeEach ->
				window.innerHeight = 2
				
			describe "circle", ->
				beforeEach ->
					addShape.__set__ "shapeToElement", (shape) ->
						expect(shape.operator).toEqual "test operator"
						expect(shape.shape.origin.x).toEqual 307
						expect(shape.shape.origin.y).toEqual 500
						expect(shape.shape.radius).toEqual 1
						"created element"
	
					addShape "circle", "test operator"
	
				it "appends the created element to the viewport", ->
					expect(addShapeElement.calls.count()).toEqual 1
					expect(addShapeElement).toHaveBeenCalledWith "created element"
					
			describe "rectangle", ->
				beforeEach ->
					addShape.__set__ "shapeToElement", (shape) ->
						expect(shape.operator).toEqual "test operator"
						expect(shape.shape.left).toEqual 296
						expect(shape.shape.top).toEqual 500
						expect(shape.shape.width).toEqual 21
						expect(shape.shape.height).toEqual 1
						"created element"
						
					addShape "rectangle", "test operator"
	
				it "appends the created element to the viewport", ->
					expect(addShapeElement.calls.count()).toEqual 1
					expect(addShapeElement).toHaveBeenCalledWith "created element"