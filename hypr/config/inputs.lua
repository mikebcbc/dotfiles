-- Input configuration

hl.config({
	input = {
		sensitivity = 0.1,
		accel_profile = "flat",
		follow_mouse = 0,
	},
})

-- Faster touchpad only
hl.device({
	name = "elan0678:00-04f3:3195-touchpad",
	sensitivity = 0.25,
	scroll_factor = 0.2,
	accel_profile = "adaptive",
})

-- Touchpad gestures
hl.gesture({ fingers = 4, direction = "horizontal", action = "workspace" })
hl.gesture({ fingers = 3, direction = "up", action = "fullscreen" })
-- hl.gesture({ fingers = 3, direction = "down", action = "close" })
-- hl.gesture({ fingers = 3, direction = "left",       action = "float" })
