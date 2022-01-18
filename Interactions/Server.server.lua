-- Interaction Server
-- Flashlink
-- March 20, 2021

--Import
local helper = game.ServerScriptService.InteractionHelper -- or wherever you interaction module is

--Services
local ProximityService = game:GetService("ProximityPromptService")
local CollectionService = game:GetService("CollectionService")

--Variables
local objects = CollectionService:GetTagged("Interactable")

function create(prompt, plr)

	--Information
	local object = prompt.Parent

	if prompt.Parent.Name == "Reader" then
		object = prompt.Parent.Parent
	end

	--Debounce
	local cooldown = object:GetAttribute("Cooldown")
	if not cooldown then cooldown = 0 end
	if cooldown >= 1 then
		spawn(
			function()
				prompt.Enabled = false
				wait(cooldown)
				prompt.Enabled = true
			end
		)
	end



	--Trigger
	helper:Interact(plr, prompt.Parent)
end

--Intialize
for _, object in ipairs(objects) do
	helper:Setup(object)
end

--Prompt Triggered Event
ProximityService.PromptTriggered:Connect(create)
