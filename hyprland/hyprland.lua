require("hyprland-gui")
-- hyprmods forces mouse actions (move, resize) only for mouse buttons, so we must declare this here
hl.bind("SUPER + mouse:276", hl.dsp.window.move({ workspace = "+1" }))
hl.bind("SUPER + mouse:275", hl.dsp.window.move({ workspace = "-1" }))

-- neither does hyprmod allow advanced stuff like this
hl.bind("SUPER + Z", function()
	local active_window = hl.get_active_window()
	if not active_window then
		return
	end
	if string.match(active_window.workspace.name, "special") then
		hl.dispatch(hl.dsp.window.move({ workspace = "+0" }))
	else
		hl.dispatch(hl.dsp.window.move({ workspace = "special", follow = false }))
	end
end)
hl.bind("SUPER_L", function()
	hl.plugin.hyprplasma.toggle_show_desktop()
end, { release = true })

hl.gesture({ fingers = 3, direction = "horizontal", action = "workspace" })
hl.gesture({ fingers = 4, direction = "horizontal", action = "workspace" })

if hl.plugin then
	if hl.plugin.hyprplasma then
		hl.gesture({ fingers = 3, direction = "down", action = hl.plugin.hyprplasma.toggle_show_desktop })
		hl.gesture({ fingers = 4, direction = "down", action = hl.plugin.hyprplasma.toggle_show_desktop })
	end
end

hl.env("HYPRLAND_TRACE", "1")
hl.config({
	debug = {
		disable_logs = false,
		colored_stdout_logs = true,
		enable_stdout_logs = true,
	},
	input = {
		focus_on_close = 1,
		follow_mouse = 1,
		mouse_refocus = true,
		follow_mouse_threshold = 0,
	},
	misc = {
		initial_workspace_tracking = 1,
	},
})

hl.plugin.load(os.getenv("HOME") .. "/.config/hypr/libhyprplasma-plugin.so")

require("hyprplasma")
require("matugen")
