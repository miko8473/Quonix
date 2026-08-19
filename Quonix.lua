-- Services & Spieler
local Players = game:GetService("Players")
local TeleportService = game:GetService("TeleportService")
local player = Players.LocalPlayer

print("[AutoFarm] Schneller Such-Modus (15 Studs) gestartet...")

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
statusLabel.Text = "Flüssiger Lauf (15 Studs)"
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

-- Schnelles und flüssiges Ablaufen im 15-Studs-Radius
task.spawn(function()
    local char = player.Character or player.CharacterAdded:Wait()
    local rootPart = char:WaitForChild("HumanoidRootPart", 15)
    local humanoid = char:WaitForChild("Humanoid", 15)
    
    task.wait(1)
    local startPos = rootPart.Position

    -- Grünes Markierungs-Quadrat (30x30 Studs)
    pcall(function()
        local marker = Instance.new("Part")
        marker.Name = "AreaMarker15Studs"
        marker.Size = Vector3.new(30, 0.2, 30)
        marker.Position = Vector3.new(startPos.X, startPos.Y - 2.5, startPos.Z)
        marker.Anchored = true
        marker.CanCollide = false
        marker.Transparency = 0.5
        marker.Color = Color3.fromRGB(0, 255, 0)
        marker.Material = Enum.Material.Neon
        marker.Parent = workspace
    end)

    local targetVector = startPos

    -- Flüssige Loop ohne Pausen
    while true do
        local currentCharacter = player.Character
        if currentCharacter and currentCharacter:FindFirstChild("Humanoid") and currentCharacter:FindFirstChild("HumanoidRootPart") then
            local currentPos = currentCharacter.HumanoidRootPart.Position
            local hum = currentCharacter.Humanoid
            
            -- Berechne Abstand zum aktuellen Ziel oder zum Startpunkt, wenn zu weit weg
            local distToTarget = (Vector3.new(currentPos.X, startPos.Y, currentPos.Z) - targetVector).Magnitude
            local distanceFromStart = (Vector3.new(currentPos.X, startPos.Y, currentPos.Z) - startPos).Magnitude
            
            if distanceFromStart > 15 or distToTarget < 3 then
                -- Neues Ziel direkt im 15-Studs-Bereich generieren
                local randomX = startPos.X + math.random(-14, 14)
                local randomZ = startPos.Z + math.random(-14, 14)
                targetVector = Vector3.new(randomX, startPos.Y, randomZ)
                hum:MoveTo(targetVector)
            end
        end
        -- Extrem kurzer Takt für flüssige Bewegung ohne Stocken
        task.wait(0.2)
    end
end)
