-- Interaction Client - Prompt GUI
-- Flashlink
-- March 31, 2021

return function(parent)
    local Prompt = Instance.new("BillboardGui")
    Prompt.Name = "Custom"
    Prompt.ExtentsOffset = Vector3.new(-0.34999999403954, 0, -0.63999998569489)
    Prompt.Size = UDim2.new(0, 1500, 0, 1000)
    Prompt.AlwaysOnTop = true
    Prompt.Active = true
    Prompt.Parent = parent

    local Frame1 = Instance.new("Frame")
    Frame1.Name = "Main"
    Frame1.AnchorPoint = Vector2.new(0.5, 0.5)
    Frame1.Size = UDim2.new(0.5, 0, 0.1, 0)
    Frame1.ClipsDescendants = true
    Frame1.BackgroundTransparency = 1
    Frame1.Position = UDim2.new(0.5, 0, 0.5, 0)
    Frame1.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    Frame1.Parent = Prompt

    local Description1 = Instance.new("TextLabel")
    Description1.Name = "Description"
    Description1.AnchorPoint = Vector2.new(0, 0.5)
    Description1.ZIndex = 2
    Description1.Size = UDim2.new(0, 500, 0, 30)
    Description1.BackgroundTransparency = 1
    Description1.Position = UDim2.new(0.54, 0, 0.5, 0)
    Description1.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    Description1.TextSize = 14
    Description1.TextColor3 = Color3.fromRGB(255, 255, 255)
    Description1.Text = "Open Door"
    Description1.Font = Enum.Font.SourceSans
    Description1.TextWrapped = true
    Description1.TextXAlignment = Enum.TextXAlignment.Left
    Description1.TextScaled = true
    Description1.Parent = Frame1

    local DescriptionBackground1 = Instance.new("TextLabel")
    DescriptionBackground1.Name = "DescriptionBackground"
    DescriptionBackground1.Size = UDim2.new(1, 0, 1, 0)
    DescriptionBackground1.BackgroundTransparency = 1
    DescriptionBackground1.Position = UDim2.new(0, 2, 0, 2)
    DescriptionBackground1.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    DescriptionBackground1.TextSize = 14
    DescriptionBackground1.TextColor3 = Color3.fromRGB(0, 0, 0)
    DescriptionBackground1.Text = "Open Door"
    DescriptionBackground1.Font = Enum.Font.SourceSans
    DescriptionBackground1.TextWrapped = true
    DescriptionBackground1.TextXAlignment = Enum.TextXAlignment.Left
    DescriptionBackground1.TextScaled = true
    DescriptionBackground1.Parent = Description1

    local Letter1 = Instance.new("TextLabel")
    Letter1.Name = "Letter"
    Letter1.AnchorPoint = Vector2.new(0.5, 0.5)
    Letter1.ZIndex = 2
    Letter1.Size = UDim2.new(0, 30, 0, 30)
    Letter1.Position = UDim2.new(0.5, 0, 0.5, 0)
    Letter1.BackgroundColor3 = Color3.fromRGB(200, 200, 200)
    Letter1.TextSize = 14
    Letter1.TextColor3 = Color3.fromRGB(0, 0, 0)
    Letter1.Text = "E"
    Letter1.Font = Enum.Font.SourceSansBold
    Letter1.TextWrapped = true
    Letter1.TextScaled = true
    Letter1.Parent = Frame1

    local UICorner4 = Instance.new("UICorner")
    UICorner4.CornerRadius = UDim.new(0, 5)
    UICorner4.Parent = Letter1

    local LetterBackground1 = Instance.new("Frame")
    LetterBackground1.Name = "LetterBackground"
    LetterBackground1.Size = UDim2.new(0, 30, 0, 30)
    LetterBackground1.Position = UDim2.new(0.075, 0, 0.075, 0)
    LetterBackground1.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    LetterBackground1.Parent = Letter1

    local UICorner5 = Instance.new("UICorner")
    UICorner5.CornerRadius = UDim.new(0, 5)
    UICorner5.Parent = LetterBackground1

    local Timeout1 = Instance.new("Frame")
    Timeout1.Name = "Timeout"
    Timeout1.AnchorPoint = Vector2.new(0.5, 1)
    Timeout1.ZIndex = 3
    Timeout1.Size = UDim2.new(0, 30, 0, 0)
    Timeout1.BorderColor3 = Color3.fromRGB(27, 42, 53)
    Timeout1.BackgroundTransparency = 0.6
    Timeout1.Position = UDim2.new(0.5, 0, 1, 0)
    Timeout1.BackgroundColor3 = Color3.fromRGB(131, 131, 131)
    Timeout1.Parent = Letter1

    local UICorner3 = Instance.new("UICorner")
    UICorner3.CornerRadius = UDim.new(0, 5)
    UICorner3.Parent = Timeout1

    return Prompt
end
