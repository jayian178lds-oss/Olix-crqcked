-- Script Extractor for PolSec Loader Scripts
-- This fetches the actual game scripts and saves them

local HttpService = game:GetService("HttpService")
local StarterGui = game:GetService("StarterGui")

local ProjectId = "7d45ec1510769529"
local Key = "4575a1c81417636c0e4568311f435198"
local LoaderBase = "https://api.polsec.net/loader"

local GameList = {
    ["10512942223"] = { id = "578395010f8c4716", name = "Anime_Zero" },
	["994732206"] = { id = "ce2e40f0bc2b1720", name = "Blox_Fruits" },
	["648454481"] = { id = "a873ec9f40a25c5c", name = "Grand_Piece_Online" },
	["66654135"] = { id = "e45bba6c0dc08fad", name = "Murder_Mystery_2" },
    ["7219654364"] = { id = "40ae7ebdcf5a8d40", name = "Sheriff_VS_Murderer" },
	["5595353122"] = { id = "d7305ba1bbb3bd7b", name = "Slayers_2" },
	["1511883870"] = { id = "5ac16739ff2ef735", name = "Shindo_Life" },
	["10563114921"] = { id = "d3b0a2eaf4a1522a", name = "Steal_An_Egg" },
    ["6035872082"] = { id = "9d318b57c43ebd9d", name = "Rivals" },
   	["10035204815"] = { id = "85a577643f806078", name = "Ride_A_Pet" }
}

local function CreateFolder(path)
	if not isfolder(path) then
		makefolder(path)
	end
end

local function ExtractScripts()
	CreateFolder("solixhub/Scripts")
	
	local results = {}
	
	for GameId, Config in pairs(GameList) do
		local ScriptId = Config.id
		local Name = Config.name
		local LoaderUrl = LoaderBase .. "/" .. ProjectId .. "/" .. ScriptId
		
		StarterGui:SetCore("SendNotification", {
			Title = "Solix Script Extractor",
			Text = "Fetching " .. Name .. "...",
			Icon = "rbxassetid://103638617992222",
		})
		
		local Success, Response = pcall(function()
			return game:HttpGet(LoaderUrl)
		end)
		
		if Success and Response then
			local FilePath = "solixhub/Scripts/" .. Name .. ".lua"
			if writefile then
				pcall(writefile, FilePath, Response)
				table.insert(results, {name = Name, status = "✓ Saved", path = FilePath})
			else
				table.insert(results, {name = Name, status = "✗ No writefile"})
			end
		else
			table.insert(results, {name = Name, status = "✗ Failed to fetch"})
		end
		
		wait(0.5) -- Rate limit
	end
	
	-- Display results
	local message = "Script Extraction Results:\n"
	for _, result in ipairs(results) do
		message = message .. "\n" .. result.name .. ": " .. result.status
		if result.path then
			message = message .. " (" .. result.path .. ")"
		end
	end
	
	StarterGui:SetCore("SendNotification", {
		Title = "Solix Script Extractor",
		Text = "Extraction complete! Check your console.",
		Icon = "rbxassetid://103638617992222",
	})
	
	print(message)
end

-- Run extraction
ExtractScripts()
