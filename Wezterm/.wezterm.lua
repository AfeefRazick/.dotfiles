local wezterm = require("wezterm")
local act = wezterm.action
local config = wezterm.config_builder()

if wezterm.target_triple == "x86_64-pc-windows-msvc" then
	-- font_dirs = {
	--     'C:\\Users\\whoami\\.dotfiles\\.fonts'
	-- }
	config.default_prog = { "powershell.exe" }
end
--
-- if wezterm.target_triple == "x86_64-apple-darwin" then
-- 	-- font_dirs    = { '$HOME/.dotfiles/.fonts' }
-- end
--
-- if wezterm.target_triple == "x86_65-unknown-linux-gnu" then
-- 	-- font_dirs    = { '$HOME/.dotfiles/.fonts' }
-- end
--

-------------
-- Options --
-------------
config.check_for_updates = true
config.term = "xterm-256color"
config.use_ime = true

-----------
-- Keys  --
-----------
-- Rather than emitting fancy composed characters when alt is pressed, treat the
-- input more like old school ascii with ALT held down
config.send_composed_key_when_left_alt_is_pressed = false
config.send_composed_key_when_right_alt_is_pressed = false

config.leader = { key = "b", mods = "CTRL", timeout_milliseconds = 2000 }

config.keys = {
	----------------
	-- Navigation --
	----------------

	-- Window/Tab management
	{ key = "c", mods = "LEADER", action = act.SpawnTab("CurrentPaneDomain") },
	{ key = "&", mods = "LEADER|SHIFT", action = act.CloseCurrentTab({ confirm = true }) },

	{ key = "n", mods = "LEADER", action = act.ActivateTabRelative(1) },
	{ key = "p", mods = "LEADER", action = act.ActivateTabRelative(-1) },
	{ key = "1", mods = "LEADER", action = act.ActivateTab(0) },
	{ key = "2", mods = "LEADER", action = act.ActivateTab(1) },
	{ key = "3", mods = "LEADER", action = act.ActivateTab(2) },
	{ key = "4", mods = "LEADER", action = act.ActivateTab(3) },
	{ key = "5", mods = "LEADER", action = act.ActivateTab(4) },
	{ key = "6", mods = "LEADER", action = act.ActivateTab(5) },
	{ key = "7", mods = "LEADER", action = act.ActivateTab(6) },
	{ key = "8", mods = "LEADER", action = act.ActivateTab(7) },
	{ key = "9", mods = "LEADER", action = act.ActivateTab(8) },

	-- Pane management
	{ key = '"', mods = "LEADER|SHIFT", action = act.SplitVertical({ domain = "CurrentPaneDomain" }) },
	{ key = "%", mods = "LEADER|SHIFT", action = act.SplitHorizontal({ domain = "CurrentPaneDomain" }) },
	{ key = "x", mods = "LEADER", action = act.CloseCurrentPane({ confirm = true }) },

	{ key = "o", mods = "LEADER", action = act.ActivatePaneDirection("Next") },

	{ key = "h", mods = "LEADER", action = act.ActivatePaneDirection("Left") },
	{ key = "j", mods = "LEADER", action = act.ActivatePaneDirection("Down") },
	{ key = "k", mods = "LEADER", action = act.ActivatePaneDirection("Up") },
	{ key = "l", mods = "LEADER", action = act.ActivatePaneDirection("Right") },

	{ key = "LeftArrow", mods = "LEADER", action = act.ActivatePaneDirection("Left") },
	{ key = "DownArrow", mods = "LEADER", action = act.ActivatePaneDirection("Down") },
	{ key = "UpArrow", mods = "LEADER", action = act.ActivatePaneDirection("Up") },
	{ key = "RightArrow", mods = "LEADER", action = act.ActivatePaneDirection("Right") },

	{ key = "z", mods = "LEADER", action = "TogglePaneZoomState" },

	-- Switch active pane by id (the numbers displayed are not the true pane id's)
	{
		key = "q",
		mods = "LEADER",
		action = act.PaneSelect({
			alphabet = "1234567890",
		}),
	},

	-- Swap active pane (unable to mimic tmux exactly - but provides an argueably better solution)
	{
		key = "{",
		mods = "LEADER|SHIFT",
		action = act.PaneSelect({
			alphabet = "1234567890",
			mode = "SwapWithActive",
		}),
	},
	{
		key = "}",
		mods = "LEADER|SHIFT",
		action = act.PaneSelect({
			alphabet = "1234567890",
			mode = "SwapWithActive",
		}),
	},

	-- Rotate panes clockwise
	{
		key = "o",
		mods = "LEADER|ALT",
		action = act.RotatePanes("Clockwise"),
	},

	-- To resize panes press LEADER, then 'r' and enter resize mode
	-- (could not achieve tmux like experience, where we hold CTRL to repeat movement)
	{
		key = "r",
		mods = "LEADER",
		action = act.ActivateKeyTable({
			name = "resize_pane",
			one_shot = false,
		}),
	},

	-- Activate Copy Mode
	{ key = "[", mods = "LEADER", action = act.ActivateCopyMode },
	-- Paste from Copy Mode
	{ key = "]", mods = "LEADER", action = act.PasteFrom("PrimarySelection") },
}

config.key_tables = {
	resize_pane = {
		-- Cancel the mode by pressing escape
		{ key = "Escape", action = "PopKeyTable" },

		{ key = "h", action = act.AdjustPaneSize({ "Left", 1 }) },
		{ key = "j", action = act.AdjustPaneSize({ "Down", 1 }) },
		{ key = "k", action = act.AdjustPaneSize({ "Up", 1 }) },
		{ key = "l", action = act.AdjustPaneSize({ "Right", 1 }) },
		{ key = "LeftArrow", action = act.AdjustPaneSize({ "Left", 1 }) },
		{ key = "DownArrow", action = act.AdjustPaneSize({ "Down", 1 }) },
		{ key = "UpArrow", action = act.AdjustPaneSize({ "Up", 1 }) },
		{ key = "RightArrow", action = act.AdjustPaneSize({ "Right", 1 }) },
	},

	copy_mode = {
		{ key = "Escape", mods = "NONE", action = act.CopyMode("Close") },

		-- Enter y to copy and quit the copy mode.
		{
			key = "y",
			mods = "NONE",
			action = act.Multiple({
				act.CopyTo("ClipboardAndPrimarySelection"),
				act.CopyMode("Close"),
			}),
		},

		{ key = "h", mods = "NONE", action = act.CopyMode("MoveLeft") },
		{ key = "j", mods = "NONE", action = act.CopyMode("MoveDown") },
		{ key = "k", mods = "NONE", action = act.CopyMode("MoveUp") },
		{ key = "l", mods = "NONE", action = act.CopyMode("MoveRight") },
		{ key = "LeftArrow", mods = "NONE", action = act.CopyMode("MoveLeft") },
		{ key = "DownArrow", mods = "NONE", action = act.CopyMode("MoveDown") },
		{ key = "UpArrow", mods = "NONE", action = act.CopyMode("MoveUp") },
		{ key = "RightArrow", mods = "NONE", action = act.CopyMode("MoveRight") },

		{ key = "w", mods = "NONE", action = act.CopyMode("MoveForwardWord") },
		{ key = "e", mods = "NONE", action = act.CopyMode("MoveForwardWordEnd") },
		{ key = "b", mods = "NONE", action = act.CopyMode("MoveBackwardWord") },

		{ key = "0", mods = "NONE", action = act.CopyMode("MoveToStartOfLine") },

		{ key = "$", mods = "SHIFT", action = act.CopyMode("MoveToEndOfLineContent") },

		{ key = "G", mods = "NONE", action = act.CopyMode("MoveToScrollbackBottom") },
		{ key = "G", mods = "SHIFT", action = act.CopyMode("MoveToScrollbackBottom") },
		{ key = "g", mods = "NONE", action = act.CopyMode("MoveToScrollbackTop") },

		{ key = "PageUp", mods = "NONE", action = act.CopyMode("PageUp") },
		{ key = "PageDown", mods = "NONE", action = act.CopyMode("PageDown") },
		{ key = "u", mods = "CTRL", action = act.CopyMode("PageUp") },
		{ key = "d", mods = "CTRL", action = act.CopyMode("PageDown") },

		{ key = " ", mods = "NONE", action = act.CopyMode({ SetSelectionMode = "Cell" }) },
		{ key = "v", mods = "NONE", action = act.CopyMode({ SetSelectionMode = "Cell" }) },
		{ key = "V", mods = "NONE", action = act.CopyMode({ SetSelectionMode = "Line" }) },
		{ key = "V", mods = "SHIFT", action = act.CopyMode({ SetSelectionMode = "Line" }) },
		{ key = "v", mods = "CTRL", action = act.CopyMode({ SetSelectionMode = "Block" }) },

		-- Enter search mode to edit the pattern.
		-- When the search pattern is an empty string the existing pattern is preserved
		{ key = "/", mods = "NONE", action = act.Search({ CaseSensitiveString = "" }) },
		{ key = "?", mods = "NONE", action = act.Search({ CaseInSensitiveString = "" }) },
		{ key = "n", mods = "CTRL", action = act.CopyMode("NextMatch") },
		{ key = "p", mods = "CTRL", action = act.CopyMode("PriorMatch") },
	},

	search_mode = {
		{ key = "Escape", mods = "NONE", action = act.CopyMode("Close") },
		-- Go back to copy mode when pressing enter, so that we can use unmodified keys like "n"
		-- to navigate search results without conflicting with typing into the search area.
		{ key = "Enter", mods = "NONE", action = "ActivateCopyMode" },
		{ key = "c", mods = "CTRL", action = "ActivateCopyMode" },
		{ key = "n", mods = "CTRL", action = act.CopyMode("NextMatch") },
		{ key = "p", mods = "CTRL", action = act.CopyMode("PriorMatch") },
		{ key = "r", mods = "CTRL", action = act.CopyMode("CycleMatchType") },
		{ key = "u", mods = "CTRL", action = act.CopyMode("ClearPattern") },
	},
}

local enable_random_tab_title_icons = false
local enable_random_tab_quote = true
local chars = { "🍓", "🍇", "🍙", "🍟", "🥡" }
local quotes = {
	"I Will Piledrive You If You Say AI Again",
	"Premature Optimization is the Route of All Evil",
	"There are only two hard things in Computer Science: cache invalidation and naming things.",
}

local BACKGROUND_OPACITY = 0.8
local TRANSPARENT = "rgba(0,0,0," .. BACKGROUND_OPACITY .. ")"
local LIGHT_GREY = "rgba(255,210,255,0.7)"
local PASTEL_BLUE = "#a2bffe"
local PASTEL_GREEN = "#80ef80"
local PASTEL_PINK = "#ffc5d3"

----------------
-- Appearance --
----------------
config.window_padding = {
	left = 2,
	right = 2,
	top = 0,
	bottom = 0,
}

config.inactive_pane_hsb = {
	saturation = 0.9,
	brightness = 0.7,
}

config.initial_rows = 30
config.initial_cols = 130

config.scrollback_lines = 3500

config.window_decorations = "INTEGRATED_BUTTONS|RESIZE"
config.use_fancy_tab_bar = false
config.tab_bar_at_bottom = false
config.show_tab_index_in_tab_bar = true
config.show_new_tab_button_in_tab_bar = false

-----------
-- Fonts --
-----------
config.font = wezterm.font("JetBrains Mono", { weight = "Bold", italic = false })
config.font_size = 10.0

-----------
-- Theme --
-----------
config.window_background_opacity = BACKGROUND_OPACITY

config.colors = {
	tab_bar = {
		background = TRANSPARENT,
		new_tab = {
			bg_color = TRANSPARENT,
			fg_color = TRANSPARENT,
			intensity = "Half",
		},
		active_tab = {
			bg_color = TRANSPARENT,
			fg_color = PASTEL_GREEN,
		},
		inactive_tab = {
			bg_color = TRANSPARENT,
			fg_color = "#909090",
		},
		inactive_tab_hover = {
			bg_color = TRANSPARENT,
			fg_color = "#aaaaaa",
		},
	},
}

local WINDOW_HIDE_ICON = " 🍙 "
local WINDOW_MAXIMIZE_ICON = " 💣 "
local WINDOW_CLOSE_ICON = " 💀"

config.tab_bar_style = {
	window_hide = wezterm.format({
		{ Background = { Color = TRANSPARENT } },
		{ Text = WINDOW_HIDE_ICON },
	}),
	window_hide_hover = wezterm.format({
		{ Background = { Color = LIGHT_GREY } },
		{ Text = WINDOW_HIDE_ICON },
	}),
	window_maximize = wezterm.format({
		{ Background = { Color = TRANSPARENT } },
		{ Text = WINDOW_MAXIMIZE_ICON },
	}),
	window_maximize_hover = wezterm.format({
		{ Background = { Color = LIGHT_GREY } },
		{ Text = WINDOW_MAXIMIZE_ICON },
	}),
	window_close = wezterm.format({
		{ Background = { Color = TRANSPARENT } },
		{ Text = WINDOW_CLOSE_ICON },
	}),
	window_close_hover = wezterm.format({
		{ Background = { Color = "#d41e2d" } },
		{ Text = WINDOW_CLOSE_ICON },
	}),
}

-- utility method
local function getRandomElement(array)
	if #array == 0 then
		return nil -- Return nil if the array is empty
	end
	local index = math.random(1, #array)
	return array[index]
end

local function tab_title(tab_info)
	local title = tab_info.tab_title -- if the tab title is explicitly set, take that

	if title == nil or title == "" then
		title = tab_info.active_pane.title
	end
	return title
end

wezterm.on("format-tab-title", function(tab_info, tabs, panes, conf, hover, max_width)
	local title = ""
	if #tabs > 1 then
		title = " " .. tab_title(tab_info) .. " "
	end

	-- strip copy mode text from title if exists
	title = title:gsub("Copy mode: ", "")

	title = wezterm.truncate_right(title, max_width - 2)

	local randomElement = ""

	if enable_random_tab_title_icons then
		randomElement = getRandomElement(chars) .. ""
	end

	if #title < 3 then -- Wezterm defaults to original title if the title text set by this function is too short
		title = title .. "  "
	end

	return {
		{ Text = title },
		{ Text = randomElement },
	}
end)

local key_tables = {
	resize_pane = { symbol = "R", color = PASTEL_BLUE },
	copy_mode = { symbol = "C", color = PASTEL_GREEN },
	search_mode = { symbol = "S", color = PASTEL_PINK },
}

local function getConsistentElement(array)
	if #array == 0 then
		return nil -- Return nil if the array is empty
	end

	-- Get the current hour (from 0 to 23)
	local hour = os.date("*t").hour

	-- Use the hour to pick a consistent index in the array
	local index = (hour % #array) + 1

	return array[index]
end

-- tmux status
wezterm.on("update-right-status", function(window, _)
	local STATUS_FOREGROUND = { Foreground = { Color = TRANSPARENT } }
	local STATUS_BACKGROUND = { Background = { Color = TRANSPARENT } }

	local prefix = " "
	local suffix = "  "
	local left_status = prefix .. suffix

	local active_key_table_name = window:active_key_table()

	if window:leader_is_active() then
		left_status = prefix .. utf8.char(0x1f30a) -- ocean wave
	elseif active_key_table_name then
		STATUS_FOREGROUND = { Foreground = { Color = "black" } }

		local mode_symbol = key_tables[active_key_table_name].symbol
		STATUS_BACKGROUND = { Background = { Color = key_tables[active_key_table_name].color } }
		left_status = prefix .. mode_symbol .. " "
	end

	window:set_left_status(wezterm.format({
		STATUS_BACKGROUND,
		STATUS_FOREGROUND,
		{ Text = left_status },
	}))

	local randomQuote = ""
	if enable_random_tab_quote then
		randomQuote = getConsistentElement(quotes) .. "   "
	end

	window:set_right_status(wezterm.format({
		{ Background = { Color = TRANSPARENT } },
		{ Foreground = { Color = PASTEL_BLUE } },
		{ Text = randomQuote },
	}))
end)

return config
