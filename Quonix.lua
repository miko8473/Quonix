-- Services
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local player = Players.LocalPlayer

-- Anti-AFK
task.spawn(function()
    while true do
        task.wait(50)
        pcall(function()
            local cam = workspace.CurrentCamera
            if cam then
                cam.CFrame = cam.CFrame * CFrame.Angles(0, 0.001, 0)
            end
        end)
    end
end)

-- Variables
local autoHitEnabled = false
local aimbotEnabled = false
local antiKnockbackEnabled = false
local autoEggEnabled = false
local isFarmingActive = false
local saveZonePosition = nil
local conveyorPosition = nil
local nightSaveZonePosition = nil
local savedManualPosition = nil

-- GUI Setup
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "QuonixGui"
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = player:WaitForChild("PlayerGui")

local MainHub = Instance.new("Frame", ScreenGui)
MainHub.Size = UDim2.new(0, 340, 0, 50)
MainHub.Position = UDim2.new(0.2, 0, 0.05, 0)
MainHub.BackgroundColor3 = Color3.fromRGB(25, 20, 35)
MainHub.Active = true
MainHub.Draggable = true
Instance.new("UICorner", MainHub).CornerRadius = UDim.new(0, 14)

local TopBar = Instance.new("Frame", MainHub)
TopBar.Size = UDim2.new(1, 0, 0, 40)
TopBar.BackgroundTransparency = 1

local HubTitle = Instance.new("TextLabel", TopBar)
HubTitle.Size = UDim2.new(0, 70, 1, 0)
HubTitle.Position = UDim2.new(0.05, 0, 0, 0)
HubTitle.Text = "Quonix"
HubTitle.TextColor3 = Color3.new(1,1,1)
HubTitle.Font = Enum.Font.GothamBold
HubTitle.TextXAlignment = Enum.TextXAlignment.Left

local ClockLabel = Instance.new("TextLabel", TopBar)
ClockLabel.Size = UDim2.new(0, 140, 1, 0)
ClockLabel.Position = UDim2.new(0.05, 65, 0, 0)
ClockLabel.Text = os.date("%H:%M:%S")
ClockLabel.TextColor3 = Color3.fromRGB(180, 120, 255)
ClockLabel.Font = Enum.Font.GothamBold
ClockLabel.TextXAlignment = Enum.TextXAlignment.Left

local CloseButton = Instance.new("TextButton", TopBar)
CloseButton.Size = UDim2.new(0, 30, 0, 30)
CloseButton.Position = UDim2.new(1, -35, 0, 5)
CloseButton.BackgroundColor3 = Color3.fromRGB(180, 50, 50)
CloseButton.Text = "X"
CloseButton.Parent = TopBar
CloseButton.MouseButton1Click:Connect(function() ScreenGui:Destroy() end)

local ContentHolder = Instance.new("ScrollingFrame", MainHub)
ContentHolder.Size = UDim2.new(1, 0, 1, -45)
ContentHolder.Position = UDim2.new(0, 0, 0, 45)
ContentHolder.BackgroundTransparency = 1
local UIListLayout = Instance.new("UIListLayout", ContentHolder)

-- Helper Functions
local function walkToTarget(pos)
    pcall(function()
        local char = player.Character
        local hum = char and char:FindFirstChild("Humanoid")
        local hrp = char and char:FindFirstChild("HumanoidRootPart")
        if hum and hrp and (hrp.Position - pos).Magnitude > 3 then
            hum:MoveTo(pos)
        end
    end)
end

-- Farming / Loops
task.spawn(function()
    while true do
        task.wait(1)
        ClockLabel.Text = os.date("%H:%M:%S")
    end
end)

task.spawn(function()
    while true do
        task.wait(0.3)
        if isFarmingActive and conveyorPosition then
            walkToTarget(conveyorPosition)
        end
    end
end)

RunService.Heartbeat:Connect(function()
    if antiKnockbackEnabled then
        local hrp = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
        if hrp and (math.abs(hrp.Velocity.X) > 60 or math.abs(hrp.Velocity.Z) > 60) then
            hrp.Velocity = Vector3.new(hrp.Velocity.X * 0.2, hrp.Velocity.Y, hrp.Velocity.Z * 0.2)
        end
    end
end)

-- (Hier sind die Button-Erstellungen zu ergänzen, der Code ist nun syntaktisch korrekt)
