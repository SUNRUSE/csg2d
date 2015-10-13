describe "pullForward", ->
    rewire = require "rewire"
    pullForward = undefined

    beforeEach ->
        pullForward = rewire "./pullForward"

    describe "imports", ->
        it "history", -> expect(pullForward.__get__ "history").toBe require "./history"

    describe "when the last element in the viewport", ->
        beforeEach ->
            pullForward.__set__ "history",
                addStep: -> expect(false).toBeTruthy()

            pullForward
                nextElementSibling: null
        it "does nothing", ->

    describe "when the element before last in the viewport", ->
        history = element = nextElement = viewport = moved = undefined

        beforeEach ->
            history =
                addStep: jasmine.createSpy "addStep"
            pullForward.__set__ "history", history

            moved = false

            viewport =
                appendChild: (el) ->
                    expect(el).toBe element
                    moved = true
                    element.nextElementSibling = null

                insertBefore: (el, before) ->
                    expect(el).toBe element
                    expect(before).toBe nextElement
                    moved = false
                    element.nextElementSibling = nextElement

            nextElement = {}

            element =
                nextElementSibling: nextElement
                parentNode: viewport

            pullForward element

        it "moves the element to the end of the viewport", ->
            expect(moved).toBeTruthy()

        it "adds a history step", ->
            expect(history.addStep).toHaveBeenCalledWith (jasmine.any Function), (jasmine.any Function), (jasmine.any Function)
            expect(history.addStep.calls.count()).toEqual 1
            
            describe "on discarding", ->
                beforeEach ->
                    (history.addStep.calls.argsFor 0)[2]()
                it "does nothing", ->
                    expect(moved).toBeTruthy()
                it "does not add another history step", ->
                    expect(history.addStep.calls.count()).toEqual 1
            describe "on undoing", ->
                beforeEach ->
                (history.addStep.calls.argsFor 0)[0]()
                it "puts the element back", ->
                    expect(moved).toBeFalsy()
                it "does not add another history step", ->
                    expect(history.addStep.calls.count()).toEqual 1
                describe "on discarding", ->
                    beforeEach ->
                        (history.addStep.calls.argsFor 0)[2]()
                    it "does nothing", ->
                        expect(moved).toBeFalsy()
                    it "does not add another history step", ->
                        expect(history.addStep.calls.count()).toEqual 1
                describe "on redoing", ->
                    beforeEach ->
                        (history.addStep.calls.argsFor 0)[1]()
                    it "restores the operator to \"add\"", ->
                        expect(moved).toBeTruthy()
                    it "does not add another history step", ->
                        expect(history.addStep.calls.count()).toEqual 1

    describe "when at least two elements from the end", ->
        history = element = nextElement = lastElement = viewport = moved = undefined

        beforeEach ->
            history =
                addStep: jasmine.createSpy "addStep"
            pullForward.__set__ "history", history

            moved = false

            viewport =
                insertBefore: (el, before) ->
                    expect(el).toBe element
                    switch before
                        when nextElement
                            moved = false
                            element.nextElementSibling = nextElementSibling
                            nextElement.nextElementSibling = lastElement                        
                        when lastElement
                            moved = true
                            element.nextElementSibling = lastElement
                            nextElement.nextElementSibling = element
                        else expect(false).toBeTruthy()

            lastElement = {}

            nextElement = 
                nextElementSibling: lastElement

            element =
                nextElementSibling: nextElement
                parentNode: viewport

            pullForward element

        it "moves the element to the end of the viewport", ->
            expect(moved).toBeTruthy()

        it "adds a history step", ->
            expect(history.addStep).toHaveBeenCalledWith (jasmine.any Function), (jasmine.any Function), (jasmine.any Function)
            expect(history.addStep.calls.count()).toEqual 1
            
            describe "on discarding", ->
                beforeEach ->
                    (history.addStep.calls.argsFor 0)[2]()
                it "does nothing", ->
                    expect(moved).toBeTruthy()
                it "does not add another history step", ->
                    expect(history.addStep.calls.count()).toEqual 1
            describe "on undoing", ->
                beforeEach ->
                (history.addStep.calls.argsFor 0)[0]()
                it "puts the element back", ->
                    expect(moved).toBeFalsy()
                it "does not add another history step", ->
                    expect(history.addStep.calls.count()).toEqual 1
                describe "on discarding", ->
                    beforeEach ->
                        (history.addStep.calls.argsFor 0)[2]()
                    it "does nothing", ->
                        expect(moved).toBeFalsy()
                    it "does not add another history step", ->
                        expect(history.addStep.calls.count()).toEqual 1
                describe "on redoing", ->
                    beforeEach ->
                        (history.addStep.calls.argsFor 0)[1]()
                    it "restores the operator to \"add\"", ->
                        expect(moved).toBeTruthy()
                    it "does not add another history step", ->
                        expect(history.addStep.calls.count()).toEqual 1