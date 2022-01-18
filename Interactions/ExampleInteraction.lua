-- All interactions must go on a folder called Interactions located inside the Helper module
local Interaction = {}

local function findFrame(object)
	if object.Frame:FindFirstChild("Right") then return object.Frame.Right end
	
    for _, part in ipairs(object.Frame:GetChildren()) do
		if math.round((part.Position - object.Door:FindFirstChild("Base").Position).Magnitude) == 4 then
            return part
        end
    end
end

local function findPlayer(plr, t)
	if not t then
		for _, v in ipairs(plr) do
			if v:FindFirstAncestorOfClass("Model") and game.Players:FindFirstChild(v:FindFirstAncestorOfClass("Model").Name) then
				return true
			end
		end
	else
		local char = plr.Character

		for _, v in ipairs(t) do
			if v:IsA("BasePart") and v:IsDescendantOf(char) then
				return true
			end
		end
	end
end

local function setDoor(object, angle)
	local motor = object.Frame.Main.Motor
	
	if motor.DesiredAngle == angle then
		return true
	end
	
	motor.DesiredAngle = angle
	
	if object:FindFirstChild("Door2") then
		local motor2 = object.Frame.Main2.Motor
		
		if angle == 0 then
			motor2.DesiredAngle = angle
		else
			motor2.DesiredAngle = -angle
		end
	end
end

function Interaction:Setup(object)
    local door = object.Door.ActualDoor
	local frame = object.Frame.Main
	
	if not frame:FindFirstChild("Motor") then
		-- Weld
		for _, part in ipairs(object.Door:GetChildren()) do
			if part ~= door then
				local weld = Instance.new("WeldConstraint")
				weld.Name = part.Name
				weld.Parent = door

				weld.Part0 = part
				weld.Part1 = door

				part.Anchored = false
			end
		end

		-- Create
		local motor = Instance.new("Motor6D")
		
		motor.Name = "Motor"

		motor.Parent = frame
		motor.MaxVelocity = 0.1

		motor.Part0 = frame
		motor.Part1 = door

		-- Orientate
		local center = object.Frame.Right

		local newCFrame = CFrame.new(center.Position,center.Position+center.CFrame.upVector)
		local CJ = CFrame.new(center.Position)

		motor.C0 = (frame.CFrame:inverse() * CJ) * CFrame.Angles(newCFrame:ToEulerAnglesXYZ()) 
		motor.C1 = (door.CFrame:inverse() * CJ) * CFrame.Angles(newCFrame:ToEulerAnglesXYZ())

		door.Anchored = false
		
		--# Secondary
		if object:FindFirstChild("Door2") then
			local door2 = object.Door2.ActualDoor
			local frame2 = object.Frame.Main2
			
			-- Weld
			for _, part2 in ipairs(object.Door2:GetChildren()) do
				if part2 ~= door2 then
					local weld2 = Instance.new("WeldConstraint")
					weld2.Name = part2.Name
					weld2.Parent = door2

					weld2.Part0 = part2
					weld2.Part1 = door2

					part2.Anchored = false
				end
			end

			-- Create
			local motor2 = Instance.new("Motor6D")

			motor2.Name = "Motor"

			motor2.Parent = frame2
			motor2.MaxVelocity = 0.1

			motor2.Part0 = frame2
			motor2.Part1 = door2

			-- Orientate
			local center2 = object.Frame.Right2

			local newCFrame2 = CFrame.new(center2.Position,center2.Position+center2.CFrame.upVector)
			local CJ2 = CFrame.new(center2.Position)

			motor2.C0 = (frame2.CFrame:inverse() * CJ2) * CFrame.Angles(newCFrame2:ToEulerAnglesXYZ()) 
			motor2.C1 = (door2.CFrame:inverse() * CJ2) * CFrame.Angles(newCFrame2:ToEulerAnglesXYZ())

			door2.Anchored = false
		end
	end
end

function Interaction:Run(plr, object)
	local motor = object.Frame.Main.Motor
	local angle
	
	local side1 = object.Sensors.Side1
	local side2 = object.Sensors.Side2
	
	local conn1 = side1.Touched:Connect(function()

	end)

	local conn2 = side2.Touched:Connect(function()

	end)
	
	local toClose = motor.DesiredAngle == 2 or motor.DesiredAngle == -2
	
	if findPlayer(plr, side1:GetTouchingParts()) and not toClose then
		angle = 2
	elseif findPlayer(plr, side2:GetTouchingParts()) and not toClose then
		angle = -2
	elseif toClose then
		angle = 0
	else
		angle = 2
	end

	local p = setDoor(object, angle)
	if object.Frame.Main:FindFirstChild("OpenSound") and not p then object.Frame.Main.OpenSound:Play() end
	wait(3)
	
	local detector = object.Sensors.Detector
	
	local conn3 = detector.Touched:Connect(function()
		
	end)
	
	local conn4
	
	if angle ~= 0 and findPlayer(detector:GetTouchingParts()) then
		conn4 = detector.TouchEnded:Connect(function()
			wait(2)
			if not findPlayer(detector:GetTouchingParts()) then
				local p = setDoor(object, 0)
				wait(0.2)
				if object.Frame.Main:FindFirstChild("CloseSound") and not p then object.Frame.Main.CloseSound:Play() end
			end
		end)
				
	else
		local p = setDoor(object, 0)
		wait(0.2)
		if object.Frame.Main:FindFirstChild("CloseSound") and not p then object.Frame.Main.CloseSound:Play() end
	end
	
	spawn(function()
		while motor.DesiredAngle ~= 0 do
			wait()
		end
		conn1:Disconnect()
		conn2:Disconnect()
		conn3:Disconnect()
		pcall(function()
			conn4:Disconnect()
		end)
	end)
	
	spawn(function()
		wait(20)
		if conn1.Connected then
			local p = setDoor(object, 0)
			wait(0.2)
			if object.Frame.Main:FindFirstChild("CloseSound") and not p then object.Frame.Main.CloseSound:Play() end
		end
	end)
end

return Interaction
