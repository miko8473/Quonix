-- Services & Spieler
local Players = game:GetService("Players")
local TeleportService = game:GetService("TeleportService")
local player = Players.LocalPlayer

print("[AutoFarm] Bereichs-Modus gestartet...")

-- GUI für Status und Rejoin-Button
local screenGui = Instance.new("ScreenGui", player.PlayerGui)
screenGui.Name = "QuonixAutoFarmGui"
screenGui.ResetOnSpawn = false

local frame = Instance.new("Frame", screenGui)
frame.Size = UDim2.new(0, 180, 0, 95)
frame.Position = UDim2.new(0.02, 0, 0.3, 0)
frame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
frame.BorderSizePixel = 0
frame.Active = true
frame.Draggable = true

local corner = Instance.new("UICorner", frame)
corner.CornerRadius = UDim.new(0, 6)

local statusLabel = Instance.new("TextLabel", frame)
statusLabel.Size = UDim2.new(1, 0, 0, 45)
statusLabel.Text = "Bereich markiert (10 Studs)"
statusLabel.TextColor3 = Color3.fromRGB(0, 255, 128)
statusLabel.TextSize = 13
statusLabel.Font = Enum.Font.SourceSansBold
statusLabel.BackgroundTransparency = 1
statusLabel.TextWrapped = true

-- Rejoin-Button
local rejoinButton = Instance.new("TextButton", frame)
rejoinButton.Size = UDim2.new(0.9, 0, 0, 30)
rejoinButton.Position = UDim2.new(0.05, 0, 0.65, 0)
rejoinButton.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
rejoinButton.Text = "Rejoin Server"
rejoinButton.TextColor3 = Color3.fromRGB(255, 255, 255)
rejoinButton.TextSize = 13
rejoinButton.Font = Enum.Font.SourceSansBold

local btnCorner = Instance.new("UICorner", rejoinButton)
btnCorner.CornerRadius = UDim.new(0, 4)

rejoinButton.MouseButton1Click:Connect(function()
    statusLabel.Text = "Rejoining..."
    if #Players:GetPlayers() <= 1 then
        TeleportService:Teleport(game.PlaceId, player)
    else
        TeleportService:TeleportToPlaceInstance(game.PlaceId, game.JobId, player)
    end
end)

-- Hauptlogik für den Startpunkt und den 10-Studs-Bereich
task.spawn(function()
    -- Warten, bis der Charakter da ist und stabil steht
    local char = player.Character or player.CharacterAdded:Wait()
    local rootPart = char:WaitForChild("HumanoidRootPart", 15)
    
    task.wait(2) -- Puffer für den Ladebildschirm
    
    local startPos = rootPart.Position
    print("[AutoFarm] Startposition gespeichert: ", startPos)

    -- Visuelle Markierung des 10-Studs-Bereichs auf dem Boden (Grünes transparentes Quadrat)
    pcall(function()
        local marker = Instance.new("Part")
        marker.Name = "AreaMarker10Studs"
        marker.Size = Vector3.new(20, 0.5, 20) -- 20x20 Studs = 10 Studs Radius in alle Richtungen
        marker.Position = Vector3.new(startPos.X, startPos.Y - 2, startPos.Z) -- Knapp unter den Füßen
        marker.Anchored = true
        marker.CanCollide = false
        marker.Transparency = 0.6
        marker.Color = Color3.fromRGB(0, 255, 0)
        marker.Material = Enum.Material.Neon
        marker.Parent = workspace
    end)

    -- Zufällige Bewegung im Bereich (10 Studs Radius), damit du automatisch farmst/läufst
    while true do
        task.wait(1.5)
        local currentCharacter = player.Character
        if currentCharacter and currentCharacter:FindFirstChild("Humanoid") and currentCharacter:FindFirstChild("HumanoidRootPart") then
            -- Generiert zufällige Punkte im 10-Studs-Radius um den Startpunkt
            local randomX = startPos.X + math.random(-10, 10)
            local randomZ = startPos.Z + math.random(-10, 10)
            local targetVector = Vector3.new(randomX, startPos.Y, randomZ)
            
            currentCharacter.Humanoid:MoveTo(targetVector)
        end
    end
end)
