-- Services
local Players = game:GetService("Players")
local TeleportService = game:GetService("TeleportService")
local player = Players.LocalPlayer

local screenGui = Instance.new("ScreenGui", player.PlayerGui)
local frame = Instance.new("Frame", screenGui)
frame.Size = UDim2.new(0, 180, 0, 120)
frame.Position = UDim2.new(0.02, 0, 0.3, 0)
frame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
frame.Active = true
frame.Draggable = true
Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 6)

local statusLabel = Instance.new("TextLabel", frame)
statusLabel.Size = UDim2.new(1, 0, 0, 40)
statusLabel.Text = "Drücke 'Lock' auf dein Band!"
statusLabel.TextColor3 = Color3.fromRGB(255, 165, 0)
statusLabel.BackgroundTransparency = 1

-- Lock Button
local lockButton = Instance.new("TextButton", frame)
lockButton.Size = UDim2.new(0.9, 0, 0, 30)
lockButton.Position = UDim2.new(0.05, 0, 0.35, 0)
lockButton.BackgroundColor3 = Color3.fromRGB(50, 200, 50)
lockButton.Text = "LOCK TREADMILL"

-- Rejoin Button
local rejoinButton = Instance.new("TextButton", frame)
rejoinButton.Size = UDim2.new(0.9, 0, 0, 30)
rejoinButton.Position = UDim2.new(0.05, 0, 0.7, 0)
rejoinButton.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
rejoinButton.Text = "Rejoin Server"

local savedPosition = nil

-- Lock Funktion: Speichert die Position des Laufbands, auf dem du stehst
lockButton.MouseButton1Click:Connect(function()
    local char = player.Character
    if char and char:FindFirstChild("HumanoidRootPart") then
        savedPosition = char.HumanoidRootPart.Position
        statusLabel.Text = "Position gespeichert!"
        statusLabel.TextColor3 = Color3.fromRGB(0, 255, 255)
        
        -- ESP an der gespeicherten Position
        local part = Instance.new("Part", workspace)
        part.Size = Vector3.new(4, 1, 4)
        part.Position = savedPosition
        part.Anchored = true
        part.CanCollide = false
        part.Transparency = 0.5
        part.Color = Color3.fromRGB(0, 255, 0)
    end
end)

rejoinButton.MouseButton1Click:Connect(function()
    TeleportService:Teleport(game.PlaceId, player)
end)

-- Bewegungs-Schleife
task.spawn(function()
    while true do
        task.wait(0.5)
        if savedPosition then
            local char = player.Character
            if char and char:FindFirstChild("Humanoid") then
                char.Humanoid:MoveTo(savedPosition)
            end
        end
    end
end)
