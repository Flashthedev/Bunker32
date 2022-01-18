local UserInputService = game:GetService("UserInputService")
local ProximityPromptService = game:GetService("ProximityPromptService")
local TweenService = game:GetService("TweenService")
local Players = game:GetService("Players")

local LocalPlayer = Players.LocalPlayer

local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")

local KeyCodeToTextMapping = {
	[Enum.KeyCode.LeftControl] = "Ctrl",
	[Enum.KeyCode.RightControl] = "Ctrl",
	[Enum.KeyCode.LeftAlt] = "Alt",
	[Enum.KeyCode.RightAlt] = "Alt",
	[Enum.KeyCode.F1] = "F1",
	[Enum.KeyCode.F2] = "F2",
	[Enum.KeyCode.F3] = "F3",
	[Enum.KeyCode.F4] = "F4",
	[Enum.KeyCode.F5] = "F5",
	[Enum.KeyCode.F6] = "F6",
	[Enum.KeyCode.F7] = "F7",
	[Enum.KeyCode.F8] = "F8",
	[Enum.KeyCode.F9] = "F9",
	[Enum.KeyCode.F10] = "F10",
	[Enum.KeyCode.F11] = "F11",
	[Enum.KeyCode.F12] = "F12",
}

local function getScreenGui()
	local screenGui = PlayerGui:FindFirstChild("ProximityPrompts")
	if screenGui == nil then
		screenGui = Instance.new("ScreenGui")
		screenGui.Name = "ProximityPrompts"
		screenGui.ResetOnSpawn = false
		screenGui.Parent = PlayerGui
	end
	return screenGui
end

local function createPrompt(prompt, inputType, gui)
	local tweensForButtonHoldBegin = {}
	local tweensForButtonHoldEnd = {}
	local tweensForFadeOut = {}
	local tweensForFadeIn = {}
	local tweenInfoInFullDuration = TweenInfo.new(prompt.HoldDuration, Enum.EasingStyle.Linear, Enum.EasingDirection.Out)
	local tweenInfoOutHalfSecond = TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
	local tweenInfoFast = TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
	local _tweenInfoQuick = TweenInfo.new(0.06, Enum.EasingStyle.Linear, Enum.EasingDirection.Out)

	local promptUI = require(script.Parent.Prompt)(gui)

	local frame = promptUI.Main

	local roundedCorner = Instance.new("UICorner")
	roundedCorner.Parent = frame

	local actionText = frame.Description
	local actionText2 = frame.Description.DescriptionBackground

	table.insert(tweensForButtonHoldBegin, TweenService:Create(actionText, tweenInfoFast, { TextTransparency = 1 }))
	table.insert(tweensForButtonHoldEnd, TweenService:Create(actionText, tweenInfoFast, { TextTransparency = 0 }))
	table.insert(tweensForFadeOut, TweenService:Create(actionText, tweenInfoFast, { TextTransparency = 1 }))
	table.insert(tweensForFadeIn, TweenService:Create(actionText, tweenInfoFast, { TextTransparency = 0 }))
	table.insert(tweensForButtonHoldBegin, TweenService:Create(actionText2, tweenInfoFast, { TextTransparency = 1 }))
	table.insert(tweensForButtonHoldEnd, TweenService:Create(actionText2, tweenInfoFast, { TextTransparency = 0 }))
	table.insert(tweensForFadeOut, TweenService:Create(actionText2, tweenInfoFast, { TextTransparency = 1 }))
	table.insert(tweensForFadeIn, TweenService:Create(actionText2, tweenInfoFast, { TextTransparency = 0 }))

	local buttonTextString = UserInputService:GetStringForKeyCode(prompt.KeyboardKeyCode)
	local keyCodeMappedText = KeyCodeToTextMapping[prompt.KeyboardKeyCode]
	if keyCodeMappedText then
		buttonTextString = keyCodeMappedText
	end
	if buttonTextString ~= nil and buttonTextString ~= "" then
		frame.Letter.Text = buttonTextString
	else
		error("ProximityPrompt '" .. prompt.Name .. "' has an unsupported keycode for rendering UI: " .. tostring(prompt.KeyboardKeyCode))
	end

	if inputType == Enum.ProximityPromptInputType.Touch or prompt.ClickablePrompt then
		local button = Instance.new("TextButton")
		button.BackgroundTransparency = 1
		button.TextTransparency = 1
		button.Size = UDim2.fromScale(1, 1)
		button.Parent = frame.Letter

		local buttonDown = false

		button.InputBegan:Connect(function(input)
			if (input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.MouseButton1) and
				input.UserInputState ~= Enum.UserInputState.Change then
				prompt:InputHoldBegin()
				buttonDown = true
			end
		end)
		button.InputEnded:Connect(function(input)
			if input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.MouseButton1 then
				if buttonDown then
					buttonDown = false
					prompt:InputHoldEnd()
				end
			end
		end)

		promptUI.Active = true
	end

	if prompt.HoldDuration > 0 then
		local circleBar = frame.Letter.Timeout
		table.insert(
			tweensForButtonHoldBegin,
			TweenService:Create(circleBar, tweenInfoInFullDuration, { Size = UDim2.fromOffset(30, 30) })
		)
		table.insert(
			tweensForButtonHoldEnd,
			TweenService:Create(circleBar, tweenInfoOutHalfSecond, { Size = UDim2.fromOffset(30, 0) })
		)
	end

	local holdBeganConnection
	local holdEndedConnection
	local triggeredConnection
	local triggerEndedConnection

	if prompt.HoldDuration > 0 then
		holdBeganConnection = prompt.PromptButtonHoldBegan:Connect(function()
			for _, tween in ipairs(tweensForButtonHoldBegin) do
				tween:Play()
			end
		end)

		holdEndedConnection = prompt.PromptButtonHoldEnded:Connect(function()
			for _, tween in ipairs(tweensForButtonHoldEnd) do
				tween:Play()
			end
		end)
	end

	triggeredConnection = prompt.Triggered:Connect(function()
		for _, tween in ipairs(tweensForFadeOut) do
			tween:Play()
		end
	end)

	triggerEndedConnection = prompt.TriggerEnded:Connect(function()
		for _, tween in ipairs(tweensForFadeIn) do
			tween:Play()
		end
	end)

	local function updateUIFromPrompt()
		actionText.Text = prompt.ActionText
		actionText.AutoLocalize = prompt.AutoLocalize
		actionText.RootLocalizationTable = prompt.RootLocalizationTable

		actionText2.Text = prompt.ActionText
		actionText2.AutoLocalize = prompt.AutoLocalize
		actionText2.RootLocalizationTable = prompt.RootLocalizationTable
	end

	local changedConnection = prompt.Changed:Connect(updateUIFromPrompt)
	updateUIFromPrompt()
	
	if prompt.Parent:IsA("Model") and prompt.Parent.PrimaryPart then
		promptUI.Adornee = prompt.Parent.PrimaryPart
	else
		promptUI.Adornee = prompt.Parent
	end
	promptUI.Parent = gui

	for _, tween in ipairs(tweensForFadeIn) do
		tween:Play()
	end

	local function cleanup()
		if holdBeganConnection then
			holdBeganConnection:Disconnect()
		end

		if holdEndedConnection then
			holdEndedConnection:Disconnect()
		end

		triggeredConnection:Disconnect()
		triggerEndedConnection:Disconnect()
		changedConnection:Disconnect()

		for _, tween in ipairs(tweensForFadeOut) do
			tween:Play()
		end

		wait(0.2)

		promptUI.Parent = nil
	end

	return cleanup
end

local function onLoad()
	ProximityPromptService.PromptShown:Connect(function(prompt, inputType)
		if prompt.Style == Enum.ProximityPromptStyle.Default then
			return
		end

		if LocalPlayer:HasAppearanceLoaded() and LocalPlayer.Character.Humanoid.Sit == true and not prompt:GetAttribute("SitBypass") then
			LocalPlayer.Character.Humanoid:GetPropertyChangedSignal("Sit"):Wait()
		else
			local gui = getScreenGui()

			local cleanupFunction = createPrompt(prompt, inputType, gui)

			prompt.PromptHidden:Wait()

			cleanupFunction()
		end
	end)
end

onLoad()
