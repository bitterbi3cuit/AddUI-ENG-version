-- Setting.lua: Tab and setting entries for the new AddUI settings interface (already loaded in the toc)
-- This file only handles: left-side tabs + the right-side settings for each tab
-- Page creation / left-right layout / row-building helpers all come from Setting-Core.lua
-- Usage: ns.AddTab("TabName", function()
--     ns.AddSection("Section title")
--     ns.AddCheck("Name", "Tooltip", "DBField"[, callback(checked)])
--     ns.AddSlider("Name", "Tooltip", min, max, step, "%.0f", "DBField")
--     ns.AddDropdown("Name", "Tooltip", {{"Option",value},...}, "DBField"[, callback(value)])
--     ns.AddTexture("Name", "Tooltip", "DBField", textureTable[, callback(value)])
--     ns.AddCVarCheck("Name", "Tooltip", "CVarName"[, bitIndex, callback])
--     ns.AddCVarSlider("Name", "Tooltip", min, max, step, "%.0f", "CVarName"[, callback])
--     ns.AddDep("master DB field", {"dependent DB field 1", "dependent DB field 2", ...})
-- end)
local addonName, ns = ...

-- Slash commands to open the settings interface (registered dynamically by Setting-Core)
ns.opensetting1 = "/ad"
ns.opensetting2 = "/addui"

-- Top title subtitle and bottom contact info (AddUI-specific content, injected into the generic Setting-Core module)
ns.Subtitle = "|cff00ffd2Native UI Enhancement|r"

-- Bottom contact text (no longer built into the core; AddUI creates it directly with ns.SettingsFrame, anchored bottom-left)
local qqun = ns.SettingsFrame:CreateFontString(nil, "ARTWORK", "GameFontNormalLarge")
qqun:SetPoint("BOTTOMLEFT", ns.SettingsFrame, "BOTTOMLEFT", 0, -28)
qqun:SetJustifyH("LEFT")
qqun:SetText("CN/TW:|cff00FFFF32655163@qq.com|r       Reload required after changing settings")


-- ═══════ Interface ═══════
ns.AddTab("Interface", function()
	ns.AddSection("Interface Modules")
	ns.AddCheck("Portrait Module", "Changes the portrait style", "unitf")
	ns.AddCheck("Action Bar Module", "Changes the action bar style", "mmb")
	ns.AddCheck("Disable Extra Action Bar Animation", "Disables the action bar's cast progress + mouseover skill rings + turning red when interrupted", "mmba")
	ns.AddCheck("Character Panel Durability", "Durability percentage below the equipment slots in the C panel", "syd")
	ns.AddCheck("Minimap Module", "Square minimap", "smap")
	ns.AddCheck("Minimap Icons", "Automatically arranges minimap icons, shows them on hover + fades out when the cursor leaves", "smapicon")
	ns.AddCheck("Chat Window Module", "Chat window style; tabs can switch chat channels", "chatm")
	ns.AddCheck("Chat Channel Buttons", "Provides a row of buttons for switching channels", "chatb")
	ns.AddCheck("Log Quick Toggle", "The log button behind the chat buttons", "lotbnt")
	ns.AddDep("chatb", {"lotbnt" })
	ns.AddCheck("Friend List Search", "This feature prevents you from teleporting to housing friends", "Friend")
	ns.AddCheck("Own Character Stats Frame", "Drag its position in edit mode", "stat")
	ns.AddCheck("Bottom-Right Info Bar", "Shows latency and durability in the bottom right", "dimi")

end)

-- ═══════ Combat ═══════
ns.AddTab("Combat", function()
	ns.AddSection("Combat Modules")
	ns.AddCheck("Entering Combat Alert", "Shows an entering/leaving combat alert in the middle of the screen", "comb")
	ns.AddCheck("Death damage alert", "Display damage and health information of the fatal event upon death", "deathRecapAlert", function(enabled)
	if not enabled and ns.HideDeathRecapAlert then ns.HideDeathRecapAlert() end
	end)
	ns.AddCheck("LFG Enhancements", "Double-click to apply to premade groups, auto-invite, auto-join group. If you use Premade Group Finder, this option is automatically disabled", "lfgkg")
	
	ns.AddCheck("Cooldown Manager Skinning", "Cooldown manager skinning", "cdset")
	ns.AddCheck("Cooldown Manager Center Alignment", "Centers the cooldown manager and merges trinkets, potions and buffs", "cdcenter")
	ns.AddCheck("Reset Damage Meter in Mythic+", "Resets the damage meter when a Mythic+ run starts", "MDRedamage")
	ns.AddCheck("Damage Meter Skinning", "Damage meter skinning", "setdama")
	ns.AddCheck("Damage Meter Auto Alignment", "Auto alignment for the damage meter", "poidama")
	ns.AddCheck("Damage Meter Value Shortening", "Shortens values in the damage meter", "valueda")
end)
ns.AddTab("Raid Frames", function()
	ns.AddSection("Raid Frames")
	ns.AddCheck("Raid Frame Role Icons", "Replaces raid frame role icons with a custom texture", "raidRoleIcon")
	ns.AddCheck("Raid Frame Mouseover Border", "Shows a border when hovering over raid/party frames", "raidMouseHighlight")
	ns.AddCheck("Raid Frame Absorbs", "Shows healing absorbs and regular absorbs on raid frames", "raidabsorb")
	ns.AddCheck("Raid Frame Defensive Tracker", "Uses a custom implementation for defensives in the middle of raid frames, with customizable IDs (preset by the addon), and can show several at once.\nTo turn this off and use the built-in one, you need to enable ESC - Interface - Important Defensive Abilities in the Center", "raidframeDefense")
end)

-- ═══════ Classes ═══════
ns.AddTab("Classes", function()
	ns.AddSection("Mage")
	ns.AddCheck("Arcane Surge Countdown", "Plays a sound alert 4 seconds before Arcane Surge ends", "mageCountdown")
	ns.AddCheck("Cancel Manipulation Button", "Button to the left of the buff bar for canceling Manipulation", "cancelAuraBtn")
	ns.AddSection("Shaman")
	ns.AddCheck("Ascendance Countdown", "Plays a sound alert 4 seconds before Ascendance ends", "shamanCountdown")
	ns.AddCheck("Nature's Guardian Cooldown", "Party: next to the party frames; Raid: adjust the position in edit mode", "shamanGuardianCountdown")
	ns.AddCheck("Thunder Claw Cooldown", "Shows the Thunder Claw icon and cooldown to the left of Nature's Guardian", "shamanThunderClaw")
	ns.AddDep("shamanGuardianCountdown", {"shamanThunderClaw"})
	ns.AddCheck("Action Bar Icon Swap", "Replaces the Lava Burst icon with Purifying Flame when casting Tempest", "shamanIconSwap")

	ns.AddSection("Rogue")
	local function rogueLive()
		if ns.RogueDotGridRefresh then ns.RogueDotGridRefresh() end
	end
	ns.AddCheck("Assassination DOT Grid", "Tracks nearby enemy nameplates; turns red when both Garrote + Rupture DOTs are applied; drag the position in edit mode.\nOnly works for Assassination spec; the master toggle requires /reload", "rogueDotGrid")
	ns.AddCheck("Track Threat List Only", "Only shows nameplates on the threat list (that have been pulled)", "rogueDotGridThreatOnly", rogueLive)
	ns.AddCheck("Show Earliest Expiry Countdown", "Shows the remaining time of whichever of the two DOTs expires first in each cell", "rogueDotGridTimer", rogueLive)
	ns.AddSlider("Cell Size", "Side length of the grid squares", 8, 30, 1, "%d", "rogueDotGridCell", rogueLive)
	ns.AddDep("rogueDotGrid", {"rogueDotGridThreatOnly", "rogueDotGridTimer", "rogueDotGridCell"})
end)

-- ═══════ Other ═══════
ns.AddTab("Other", function()
	ns.AddSection("Other Features")
	ns.AddCheck("Automatic CVAR Setup", "Automatically configures some CVARs; most have been moved to the /sd command", "cvar")
	ns.AddCheck("Auto Sell Grey", "Automatically sells junk", "mh")
	ns.AddCheck("Fast Loot", "Increases looting speed", "sq")
	ns.AddCheck("Whisper Auto-Invite", "Automatically invites when someone whispers you 123 or .group., supports Battle.net whispers", "zu")
	ns.AddCheck("One-Click Equipment Selector", "One-click Need/Greed/Pass for all equipment", "autoloot")
	
	ns.AddCheck("Chat Frame Combat Res Timer", "Combat res timer in the top-right of the chat frame; drag the combat res in edit mode", "chatCombatTimer")
	ns.AddCheck("Interrupt Log", "Party interrupt log; only records successful interrupts, lasts 20 seconds, drag the position in edit mode", "interrupt")
	ns.AddCheck("Interrupted Falsely Sound Alert", "Plays an alert sound when you use an interrupt ability but don't interrupt the target", "interruptAlert")
	ns.AddCheck("Character Panel Movement Speed", "Shows movement speed in the bottom right of the C character panel; hover to show run/fly/swim speed", "movspeed")
	ns.AddButton("Own Buff List", "Opens the list of spells monitored for your own buffs.\nCan also be opened by right-clicking your own buff frame on the cooldown manager title bar or in edit mode", function()
		ns.OpenSelfBuffAuraList()
	end)

	ns.AddSection("Right-Click Menu")
	ns.AddCheck("Warcraft Logs", "Shows a WCL link in the player right-click menu; hidden when disabled", "wcl")
	ns.AddCheck("Raider.IO", "Shows a Raider.IO link in the player right-click menu; hidden when disabled", "rio")

end)

-- ═══════ Cast Bar ═══════
ns.AddTab("Cast Bar", function()
	ns.AddSection("Cast Bar")
	ns.AddCheck("Cast Bar Module", "Changes the cast bar style", "cast")
	ns.AddCheck("Custom Cast Bar Texture", "Requires the cast bar module to be enabled", "SCastTexture")
	ns.AddTexture("Cast Bar Texture", "Cast bar texture selection", "CastTexture", ns.CastBarTextrue)
	ns.AddSlider("Cast Bar Width", "Cast bar width", 200, 400, 1, "%d", "castWidth")
	ns.AddSlider("Cast Bar Height", "Cast bar height", 10, 40, 1, "%d", "castHeight")
	ns.AddSlider("Spell Queue Delay", "Spell queue delay", 0, 400, 1, "%d", "SpellQ", function(v)
		SetCVar("SpellQueueWindow", v)
	end)
	-- When the cast bar module is off, the following dependent options are disabled
	ns.AddDep("cast", { "SCastTexture", "CastTexture", "castWidth", "castHeight", "SpellQ" })
	ns.AddDep("SCastTexture", { "CastTexture" })
end)

-- ═══════ Tooltips and Values ═══════
ns.AddTab("Tooltip Values", function()
	ns.AddSection("Tooltips and Values")
	local fopts = { { "Tooltip: Follow", 1 }, { "Tooltip: Don't Follow", 0 }, { "Tooltip: Follow Out of Combat", 2 }, { "Tooltip: Disabled", 3 } }
	ns.AddDropdown("Tooltip Follow Mode", "Tooltip follow mode", fopts, "ftip")
	local vopts = { { "Chinese Units", 1 }, { "English Units", 2 }, { "Blizzard Default", 3 } }
	ns.AddDropdown("Value Units", "Value units", vopts, "value")
end)

-- ═══════ Other ═══════
ns.AddTab("Misc", function()
-- List of features without toggles (the original "Other Features" notice from Options.lua)
	if ns.TIPTEXTS and #ns.TIPTEXTS > 0 then
		ns.AddLog(table.concat(ns.TIPTEXTS, "\n"))
	end
end)
