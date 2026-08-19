-- Services & Spieler
local Players = game:GetService("Players")
local TeleportService = game:GetService("TeleportService")
local player = Players.LocalPlayer

-- GUI für Status, Debug und Rejoin-Button erstellen
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
statusLabel.Text = "Stell dich auf dein Laufband!"
statusLabel.TextColor3 = Color3.fromRGB(255, 165, 0)
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

-- Intelligente Erkennung: Nimmt das Bauteil, auf dem du stehst oder das dir am nächsten ist!
local function findMyTreadmill()
    local char = player.Character
    if not char or not char:FindFirstChild("HumanoidRootPart") then return nil end
    
    local rootPart = char.HumanoidRootPart
    local closestPart = nil
    local minDist = math.huge
    
    -- Wir suchen nach allen BaseParts im Workspace
    for _, obj in ipairs(workspace:GetDescendants()) do
        if obj:IsA("BasePart") then
            -- Ignoriere den Spieler selbst
            if not obj:IsDescendantOf(char) then
                local dist = (obj.Position - rootPart.Position).Magnitude
                -- Das Teil, das am allernächsten zu dir ist (innerhalb von 10 Studs), wird als Laufband gewählt
                if dist < 10 and dist < minDist then
                    minDist = dist
                    closestPart = obj
                end
            end
        end
    end
    
    return closestPart
end

-- Hauptschleife
task.spawn(function()
    local myTreadmill = nil
    
    statusLabel.Text = "Bitte stell dich auf dein Laufband..."
    
    -- Warte, bis du nah genug an einem Teil stehst (also auf deinem Laufband bist)
    while not myTreadmill do
        task.wait(0.5)
        myTreadmill = findMyTreadmill()
    end
    
    -- Zeige den echten Namen des Teils im UI an, damit du weißt, was erkannt wurde!
    statusLabel.Text = "Gefunden: " .. myTreadmill.Name
    statusLabel.TextColor3 = Color3.fromRGB(0, 255, 128)
    
    -- Grünes ESP auf das gefundene Laufband setzen
    pcall(function()
        if not myTreadmill:FindFirstChild("TreadmillESP") then
            local box = Instance.new("BoxHandleAdornment")
            box.Name = "TreadmillESP"
            box.Adornee = myTreadmill
            box.AlwaysOnTop = true
            box.Size = myTreadmill.Size + Vector3.new(0.5, 0.5, 0.5)
            box.Color3 = Color3.fromRGB(0, 255, 0)
            box.Transparency = 0.5
            box.Parent = myTreadmill
        end
    end)

    -- Dauerhafte Bewegungs-Schleife
    while true do
        task.wait(0.5)
        local char = player.Character
        if char and char:FindFirstChild("Humanoid") and char:FindFirstChild("HumanoidRootPart") then
            if myTreadmill and myTreadmill.Parent then
                char.Humanoid:MoveTo(myTreadmill.Position)
            else
                -- Falls es gelöscht wird, neu suchen
                myTreadmill = findMyTreadmill()
            end
        end
    end
end)
