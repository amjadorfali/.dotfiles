-- Pull in the wezterm API
local wezterm = require("wezterm")

-- This will hold the configuration.
local config = wezterm.config_builder()

-- This is where you actually apply your config choices

-- For example, changing the color scheme:
-- config.color_scheme = 'AdventureTime'

config.macos_window_background_blur = 10
local withBg = 1
local bgImages = { "aegis-pointing.png", "cyber_girl.jpg", "city-scape.gif" }
if withBg == 1 then
	config.background = {
		{
			source = {
				File = "/Users/" .. os.getenv("USER") .. "/files/wallpapers/" .. bgImages[3],
			},

			hsb = {
				hue = 1,
				saturation = 1.1,
				brightness = 0.2, --1
			},
			-- attachment = { Parallax = 0.3 },
			-- width = "100%",
			-- height = "100%",
		},
		{
			source = {
				Color = "#011423", --"#000000"
			},
			width = "100%",
			height = "100%",
			opacity = 0.75, --0.45
		},
	}
else
	config.window_background_opacity = 0.9
end
-- this is how officially they recommend handing imgs https://wezfurlong.org/wezterm/config/appearance.html#window-background-image

--config.window_background_image = "/Users/" .. os.getenv("USER") ..  "/wallpapers/1.jpg"
--config.window_background_image_hsb = {
--  -- Darken the background image by reducing it to 1/3rd
--  brightness = 0.3,
--
--  -- You can adjust the hue by scaling its value.
--  -- a multiplier of 1.0 leaves the value unchanged.
--  hue = 1.0,
--
--  -- You can adjust the saturation also.
--  saturation = 1.0,
--}
-- official img handling ends

-- my coolnight colorscheme
config.colors = {
	foreground = "#CBE0F0",
	background = "#011423",
	cursor_bg = "#47FF9C",
	cursor_border = "#47FF9C",
	cursor_fg = "#011423",
	selection_bg = "#033259",
	selection_fg = "#CBE0F0",
	ansi = { "#214969", "#E52E2E", "#44FFB1", "#FFE073", "#0FC5ED", "#a277ff", "#24EAF7", "#24EAF7" },
	brights = { "#214969", "#E52E2E", "#44FFB1", "#FFE073", "#A277FF", "#a277ff", "#24EAF7", "#24EAF7" },
	tab_bar = {
		-- The color of the inactive tab bar edge/divider
		inactive_tab_edge = "#575757",
	},
}

--config = {
--  check_for_updates = false,
--  adjust_window_size_when_changing_font_size = false,
--  use_fancy_tab_bar = false,
--  tab_bar_at_bottom = false,
--  font = wezterm.font("JetBrains Mono", { weight = "Bold" }),
--  enable_tab_bar = false,
--}

config.adjust_window_size_when_changing_font_size = false
config.automatically_reload_config = true
config.window_close_confirmation = "NeverPrompt"
config.window_padding = {
	left = 3,
	right = 3,
	top = 0,
	bottom = 0,
}
config.font = wezterm.font("MesloLGS NF")
config.font_size = 19
config.window_decorations = "RESIZE"
config.hide_tab_bar_if_only_one_tab = true
config.window_frame = {
	-- The font used in the tab bar.
	-- Roboto Bold is the default; this font is bundled
	-- with wezterm.
	-- Whatever font is selected here, it will have the
	-- main font setting appended to it to pick up any
	-- fallback fonts you may have used there.
	font = wezterm.font({ family = "Roboto", weight = "Bold" }),

	-- The size of the font in the tab bar.
	-- Default to 10.0 on Windows but 12.0 on other systems
	font_size = 16.0,

	-- The overall background color of the tab bar when
	-- the window is focused
	active_titlebar_bg = "#333333",

	-- The overall background color of the tab bar when
	-- the window is not focused
	inactive_titlebar_bg = "#333333",
}

-- Support for Nvim ZEN_MODE
wezterm.on("user-var-changed", function(window, pane, name, value)
	local overrides = window:get_config_overrides() or {}
	if name == "ZEN_MODE" then
		local incremental = value:find("+")
		local number_value = tonumber(value)
		if incremental ~= nil then
			while number_value > 0 do
				window:perform_action(wezterm.action.IncreaseFontSize, pane)
				number_value = number_value - 1
			end
			overrides.enable_tab_bar = false
		elseif number_value < 0 then
			window:perform_action(wezterm.action.ResetFontSize, pane)
			overrides.font_size = nil
			overrides.enable_tab_bar = true
		else
			overrides.font_size = number_value
			overrides.enable_tab_bar = false
		end
	end
	window:set_config_overrides(overrides)
end)

-- and finally, return the configuration to wezterm
return config
