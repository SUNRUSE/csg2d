xdescribe "player", ->
	describe "on calling", ->
		it "does not modify the rig", ->
		it "does not modify the gamepad", ->
		it "creates a single scene event", ->
		describe "when the scene event occurs", ->
			describe "when the left wheel is on the ground", ->
				describe "when the right wheel is on the ground", ->
					describe "when no keys are pressed", ->
						it "does not modify the rig", ->
						it "does not modify the gamepad", ->
						it "creates a single scene event", ->
					describe "when the leanLeft key is pressed", ->
						it "pulls the right wheel up", ->
						it "does not modify the gamepad", ->
						it "creates a single scene event", ->
					describe "when the leanRight key is pressed", ->
						it "pulls the left wheel up", ->
						it "does not modify the gamepad", ->
						it "creates a single scene event", ->
					describe "when the leanLeft and leanRight keys are pressed", ->
						it "does not modify the rig", ->
						it "does not modify the gamepad", ->
						it "creates a single scene event", ->
				describe "when the right wheel is not on the ground", ->
					describe "when no keys are pressed", ->
						it "does not modify the rig", ->
						it "does not modify the gamepad", ->
						it "creates a single scene event", ->
					describe "when the leanLeft key is pressed", ->
						it "pulls the right wheel up", ->
						it "does not modify the gamepad", ->
						it "creates a single scene event", ->
					describe "when the leanRight key is pressed", ->
						it "does not modify the rig", ->
						it "does not modify the gamepad", ->
						it "creates a single scene event", ->
					describe "when the leanLeft and leanRight keys are pressed", ->
						it "does not modify the rig", ->
						it "does not modify the gamepad", ->
						it "creates a single scene event", ->
			describe "when the left wheel is not on the ground", ->
				describe "when the right wheel is on the ground", ->
					describe "when no keys are pressed", ->
						it "does not modify the rig", ->
						it "does not modify the gamepad", ->
						it "creates a single scene event", ->
					describe "when the leanLeft key is pressed", ->
						it "does not modify the rig", ->
						it "does not modify the gamepad", ->
						it "creates a single scene event", ->
					describe "when the leanRight key is pressed", ->
						it "pulls the left wheel up", ->
						it "does not modify the gamepad", ->
						it "creates a single scene event", ->
					describe "when the leanLeft and leanRight keys are pressed", ->
						it "does not modify the rig", ->
						it "does not modify the gamepad", ->
						it "creates a single scene event", ->
				describe "when the right wheel is not on the ground", ->
					describe "when no keys are pressed", ->
						it "does not modify the rig", ->
						it "does not modify the gamepad", ->
						it "creates a single scene event", ->
					describe "when the leanLeft key is pressed", ->
						it "does not modify the rig", ->
						it "does not modify the gamepad", ->
						it "creates a single scene event", ->
					describe "when the leanRight key is pressed", ->
						it "does not modify the rig", ->
						it "does not modify the gamepad", ->
						it "creates a single scene event", ->
					describe "when the leanLeft and leanRight keys are pressed", ->
						it "does not modify the rig", ->
						it "does not modify the gamepad", ->
						it "creates a single scene event", ->