describe "createHandle", ->
	createHandle = undefined
	rewire = document = require "rewire"
	beforeEach ->
		createHandle = rewire "./createHandle"
		
		document = 
			createElement: jasmine.createSpy "createElement"
		
		createHandle.__set__ "document", document
	
	describe "imports", ->
		it "document", -> expect(createHandle.__get__ "document").toBe document
	
	describe "on calling", ->
		result = element = parent = undefined
		beforeEach ->
			element = 
				style: {}
				setAttribute: jasmine.createSpy "setAttribute"
			parent = 
				appendChild: jasmine.createSpy "appendChild"
				
			document.createElement.and.callFake (type) -> element
			
			result = createHandle parent, "test kind"
			
		it "creates exactly one div", ->
			expect(document.createElement.calls.count()).toEqual 1
			expect(document.createElement).toHaveBeenCalledWith "div"
		it "copies the kind to an attribute", ->
			expect(element.setAttribute).toHaveBeenCalledWith "kind", "test kind"
		it "sets the class to \"handle\"", ->
			expect(element.className).toEqual "handle"
		it "appends the new handle to the parent shape", ->
			expect(parent.appendChild).toHaveBeenCalledWith element
		it "returns the element created", ->
			expect(result).toBe element