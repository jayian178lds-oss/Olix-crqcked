-- Verify and Re-Extract Scripts with Full Error Handling
-- This script downloads fresh copies and verifies they're valid

local HttpService = game:GetService("HttpService")
local StarterGui = game:GetService("StarterGui")

local ProjectId = "7d45ec1510769529"
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

local function VerifyLuaCode(code)
	-- Check if code looks valid
	if not code or code == "" then
		return false, "Empty file"
	end
	
	if #code < 100 then
		return false, "File too small (probably incomplete)"
	end
	
	if code:find("function") or code:find("local") or code:find("=") then
		return true, "Valid"
	end
	
	return false, "Invalid Lua code"
end

local function VerifyAndExtract()
	CreateFolder("solixhub/Scripts")
	CreateFolder("solixhub/Scripts/Backup")
	
	local results = {}
	local allValid = true
	
	print("\n" .. string.rep("=", 60))
	print("SCRIPT VERIFICATION & EXTRACTION")
	print(string.rep("=", 60) .. "\n")
	
	for GameId, Config in pairs(GameList) do
		local ScriptId = Config.id
		local Name = Config.name
		local LoaderUrl = LoaderBase .. "/" .. ProjectId .. "/" .. ScriptId
		local FilePath = "solixhub/Scripts/" .. Name .. ".lua"
		local BackupPath = "solixhub/Scripts/Backup/" .. Name .. ".lua"
		
		print("[" .. Name .. "]")
		print("  URL: " .. LoaderUrl)
		
		StarterGui:SetCore("SendNotification", {
			Title = "Script Verifier",
			Text = "Fetching " .. Name .. "...",
			Icon = "rbxassetid://103638617992222",
		})
		
		local Success, Response = pcall(function()
			return game:HttpGet(LoaderUrl)
		end)
		
		if not Success then
			print("  Status: ✗ FAILED TO FETCH")
			print("  Error: " .. tostring(Response) .. "\n")
			table.insert(results, {name = Name, status = "✗ Fetch failed", valid = false})
			allValid = false
		else
			local isValid, reason = VerifyLuaCode(Response)
			
			if isValid and Response then
				if writefile then
					-- Delete old if exists
					if isfile(FilePath) then
						delfile(FilePath)
					end
					
					-- Write new
					pcall(writefile, FilePath, Response)
					
					-- Backup
					pcall(writefile, BackupPath, Response)
					
					print("  Status: ✓ SAVED (" .. tostring(#Response) .. " bytes)")
					print("  Path: " .. FilePath)
					print("  Valid: YES\n")
					table.insert(results, {name = Name, status = "✓ Valid & Saved", valid = true})
				else
					print("  Status: ✗ NO WRITEFILE")
					print("  Valid: YES\n")
					table.insert(results, {name = Name, status = "✗ No writefile", valid = true})
					allValid = false
				end
			else
				print("  Status: ✗ INVALID SCRIPT")
				print("  Reason: " .. reason .. "\n")
				table.insert(results, {name = Name, status = "✗ " .. reason, valid = false})
				allValid = false
			end
		end
		
		wait(0.8) -- Rate limit
	end
	
	-- Summary
	print(string.rep("=", 60))
	print("SUMMARY")
	print(string.rep("=", 60) .. "\n")
	
	local validCount = 0
	for _, result in ipairs(results) do
		local status = result.valid and "✓" or "✗"
		print(status .. " " .. result.name .. ": " .. result.status)
		if result.valid then validCount = validCount + 1 end
	end
	
	print("\nTotal Valid: " .. validCount .. "/" .. tostring(#results))
	print("Status: " .. (allValid and "ALL SCRIPTS VALID ✓" or "SOME SCRIPTS FAILED ✗"))
	print("\nBackups saved to: solixhub/Scripts/Backup/\n")
	
	-- Final notification
	if allValid then
		StarterGui:SetCore("SendNotification", {
			Title = "Script Verifier",
			Text = "All scripts verified! Ready to load.",
			Icon = "rbxassetid://103638617992222",
		})
	else
		StarterGui:SetCore("SendNotification", {
			Title = "Script Verifier",
			Text = "Some scripts failed. Check console for details.",
			Icon = "rbxassetid://103638617992222",
		})
	end
	
	print(string.rep("=", 60) .. "\n")
end

-- Run verification
VerifyAndExtract()
