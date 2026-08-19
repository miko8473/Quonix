-- Services & Spieler
local Players = game:GetService("Players")
local TeleportService = game:GetService("TeleportService")
local player = Players.LocalPlayer

-- GUI für Status und Rejoin-Button erstellen
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
statusLabel.Text = "Warte auf Spawn..."
statusLabel.TextColor3 = Color3.fromRGB(255, 165, 0)
statusLabel.TextSize = 13
statusLabel.Font = Enum.Font.SourceSansBold
statusLabel.BackgroundTransparency = 1
statusLabel.TextWrapped = true

-- Rejoin-Button (nur zum Testen)
local rejoinButton = Instance.new("TextButton", frame)
rejoinButton.Size = UDim2.new(0.9, 0, 0, 30)
rejoinButton.Position = UDim2.new(0.05, 0, 0.65, 0)
rejoinButton.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
rejoinButton.Text = "Rejoin Server Test"
rejoinButton.TextColor3 = Color3.fromRGB(255, 255, 255)
rejoinButton.TextSize = 13
rejoinButton.Font = Enum.Font.SourceSansBold

local btnCorner = Instance.new("UICorner", rejoinButton)
btnCorner.CornerRadius = UDim.new(0, 4)

rejoinButton.MouseButton1Click:Connect(function()
    statusLabel.Text = "Rejoining..."
    TeleportService:Teleport(game.PlaceId, player)
end)

-- VOLLAUTOMATISCHE ERKENNUNG:
local savedPosition = nil

task.spawn(function()
    -- 1. Warte, bis der Charakter nach dem Rejoin da ist
    local char = player.Character or player.CharacterAdded:Wait()
    local rootPart = char:WaitForChild("HumanoidRootPart", 10)
    
    if rootPart then
        -- 2. Sobald du im Spiel spawnst, nimmt das Skript automatisch DIESEN Startpunkt als dein Laufband!
        -- (Man spawnt schließlich direkt bei seinem Plot/Laufband)
        task.wait(1) -- Kurzer Puffer, damit du stabil stehst
        savedPosition = rootPart.Position
        
        statusLabel.Text = "Auto-Target gespeichert!"
        statusLabel.TextColor3 = Color3.fromRGB(0, 255, 128)
        
        -- Visuelles ESP an dieser Position erstellen, damit du siehst, dass es geklappt hat
        local part = Instance.new("Part", workspace)
        part.Size = Vector3.new(4, 1, 4)
        part.Position = savedPosition
        part.Anchored = true
        part.CanCollide = false
        part.Transparency = 0.5
        part.Color = Color3.fromRGB(0, 255, 0)
    end
    
    -- 3. Dauerhafte Bewegungs-Schleife (läuft immer dorthin zurück)
    while true do
        task.wait(0.5)
        if savedPosition then
            local currentCharacter = player.Character
            if currentCharacter and currentCharacter:FindFirstChild("Humanoid") then
                currentCharacter.Humanoid:MoveTo(savedPosition)
            end
        end
    end
end)
