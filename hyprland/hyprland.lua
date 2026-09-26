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

require("hyprland-gui")

-- For Noctalia Color templates
require("noctalia").apply_theme()
