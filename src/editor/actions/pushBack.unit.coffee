describe "pushBack", ->
    rewire = require "rewire"
    pushBack = undefined

    beforeEach ->
        pushBack = rewire "./pushBack"

    describe "imports", ->
        it "history", -> expect(pushBack.__get__ "history").toBe require "./history"

    describe "when the first element in the viewport", ->
        beforeEach ->
            pushBack.__set__ "history",
                addStep: -> expect(false).toBeTruthy()

            pushBack
                nextElementSibling: null
        it "does nothing", ->

    describe "when the last but not the first element in the viewport", ->
        history = element = previousElement = shapes = moved = undefined

        beforeEach ->
            history =
                addStep: jasmine.createSpy "addStep"
            pushBack.__set__ "history", history

            moved = false

            shapes =
                appendChild: (el) ->
                    expect(el).toBe element
                    moved = false
                    element.previousElementSibling = previousElement

                insertBefore: (el, before) ->
                    expect(el).toBe element
                    expect(before).toBe previousElement
                    moved = true
                    element.previousElementSibling = null

            previousElement = {}

            element =
                previousElementSibling: previousElement
                parentNode: shapes

            pushBack element

        it "moves the element to the start of the viewport", ->
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

    describe "when neither the first not last element in the viewport", ->
        history = element = previousElement = nextElement = shapes = moved = undefined

        beforeEach ->
            history =
                addStep: jasmine.createSpy "addStep"
            pushBack.__set__ "history", history

            moved = false

            shapes =
                insertBefore: (el, before) ->
                    expect(el).toBe element
                    switch before
                        when previousElement
                            moved = true
                            element.previousElementSibling = null                        
                        when nextElement
                            moved = false
                            element.previousElementSibling = previousElement                        
                        else expect(false).toBeTruthy()

            previousElement = {}
            nextElement = {}

            element =
                previousElementSibling: previousElement
                nextElementSibling: nextElement
                parentNode: shapes

            pushBack element

        it "moves the element back", ->
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