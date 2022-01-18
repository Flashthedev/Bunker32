-- Interaction Helper
-- Flashlink
-- March 26, 2021
-- This needs to be on the server

local InteractionHelper = {}

--Import
local Checker = require(game:GetService("ServerScriptService").Helpers.AccessHelper) -- check the AccessControl folder or create a module that returns true when the player has the clearance

local Interactions = script.Interactions

--External Functions
function InteractionHelper:Interact(plr, object)
	if object ~= nil then
		--Configurables
		local config = object

		if object.Name == "Reader" then
			config = object.Parent
		end

		local event = config:GetAttribute("Event")
		local clearance

		if event and Interactions:FindFirstChild(event) then			
			if object:GetAttribute("ClearanceToggle") then
				clearance = config:GetAttribute("ClearanceAlternative")	
			else
				clearance = config:GetAttribute("Clearance")
			end

			local clearanceTable = string.split(string.gsub(clearance, " ", ""), ",")

			if Checker:CheckClearance(plr, clearanceTable) == true then
				require(Interactions:FindFirstChild(event)):Run(plr, object)
			else
				local success = pcall(function()
					require(Interactions:FindFirstChild(event)):Denied(plr, object)
				end)
			end
		else
			warn("[Interaction Server]: Object Function " .. (event or "[ERROR]") .. ", is not registered")
		end
	end
end

function InteractionHelper:Setup(object)
	--Configurables
	local config = object
	local los

	if object.Name == "Reader" then
		config = object.Parent
	end

	if config:GetAttribute("VisibilityBypass") then
		los = false
	else
		los = true
	end

	local prompt = object:FindFirstChildOfClass("ProximityPrompt") or Instance.new("ProximityPrompt")
	prompt.Name = "ProximityPrompt"
	prompt.RequiresLineOfSight = los

	prompt.Style = Enum.ProximityPromptStyle.Custom

	prompt.ObjectText = config.Name
	prompt.KeyboardKeyCode = Enum.KeyCode[config:GetAttribute("Keycode")] or "Default"
	prompt.ActionText = config:GetAttribute("Description") or "Default"
	prompt.MaxActivationDistance = config:GetAttribute("Distance") or 5
	prompt.HoldDuration = config:GetAttribute("HoldDuration") or 0
	
	pcall(function()
		require(Interactions:FindFirstChild(config:GetAttribute("Event"))):Setup(object, prompt)
	end)
	
	prompt.Parent = object
end

return InteractionHelper
