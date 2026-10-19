repeat wait() until game:IsLoaded()

if LPH_OBFUSCATED == nil then
	LPH_NO_VIRTUALIZE = function(...) return (...) end
	LPH_ENCSTR = function(...) return (...) end
	LRM_SANITIZE = function(...) return ... end
end

local cloneref = cloneref or function(o) return o end
local StarterGui = cloneref(game:GetService("StarterGui"))
local HttpService = cloneref(game:GetService("HttpService"))

local GameId = tostring(game.GameId)

local GameList = {
    ["10512942223"] = "Anime_Zero",
	["994732206"] = "Blox_Fruits",
	["648454481"] = "Grand_Piece_Online",
	["66654135"] = "Murder_Mystery_2",
    ["7219654364"] = "Sheriff_VS_Murderer",
	["5595353122"] = "Slayers_2",
	["1511883870"] = "Shindo_Life",
	["10563114921"] = "Steal_An_Egg",
    ["6035872082"] = "Rivals",
   	["10035204815"] = "Ride_A_Pet"
}

local ScriptName = GameList[GameId]

if not ScriptName then
	StarterGui:SetCore("SendNotification", {
		Title = "Solix Hub",
		Text = "Game not supported.",
		Icon = "rbxassetid://103638617992222",
	})
	return
end

-- Try to load from local file first, then from backup
local ScriptPath = "solixhub/Scripts/" .. ScriptName .. ".lua"
local BackupPath = "solixhub/Scripts/Backup/" .. ScriptName .. ".lua"

local ScriptContent = nil

-- Try primary location
if isfile and isfile(ScriptPath) then
	local Ok, Content = pcall(readfile, ScriptPath)
	if Ok and Content and Content ~= "" then
		ScriptContent = Content
	end
end

-- Try backup if primary failed
if not ScriptContent and isfile and isfile(BackupPath) then
	local Ok, Content = pcall(readfile, BackupPath)
	if Ok and Content and Content ~= "" then
		ScriptContent = Content
	end
end

if not ScriptContent then
	StarterGui:SetCore("SendNotification", {
		Title = "Solix Hub",
		Text = "Script not found. Run verify_and_extract.lua",
		Icon = "rbxassetid://103638617992222",
	})
	print("ERROR: Could not find script at:")
	print("  " .. ScriptPath)
	print("  " .. BackupPath)
	return
end

-- Set up environment
local Env = getfenv()
Env.game = game
Env.script = script
Env.print = print
Env.warn = warn
Env.HttpService = HttpService

StarterGui:SetCore("SendNotification", {
	Title = "Solix Hub",
	Text = "Loading " .. ScriptName .. "...",
	Icon = "rbxassetid://103638617992222",
})

wait(0.2)

-- Execute with error handling
local Success, Error = pcall(function()
	local ScriptFunction = loadstring(ScriptContent)
	if ScriptFunction then
		ScriptFunction()
	else
		error("Failed to parse script")
	end
end)

if not Success then
	print("\n" .. string.rep("=", 60))
	print("ERROR LOADING SCRIPT")
	print(string.rep("=", 60))
	print("Game: " .. ScriptName)
	print("Error: " .. tostring(Error))
	print("\nScript path: " .. ScriptPath)
	print("Backup path: " .. BackupPath)
	print("\nSolution: Run verify_and_extract.lua to re-download")
	print(string.rep("=", 60) .. "\n")
	
	StarterGui:SetCore("SendNotification", {
		Title = "Solix Hub - Error",
		Text = "Script failed. Check console.",
		Icon = "rbxassetid://103638617992222",
	})
else
	print("\n✓ Script loaded successfully for: " .. ScriptName .. "\n")
	StarterGui:SetCore("SendNotification", {
		Title = "Solix Hub",
		Text = "Loaded!",
		Icon = "rbxassetid://103638617992222",
	})
end
