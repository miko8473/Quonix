-- Services & Spieler
local Players = game:GetService("Players")
local TeleportService = game:GetService("TeleportService")
local player = Players.LocalPlayer

print("[AutoFarm] Skript gestartet. Suche nach deinem Laufband...")

-- GUI für Status und Rejoin-Button erstellen
local screenGui = Instance.new("ScreenGui", player.PlayerGui)
screenGui.Name = "QuonixAutoFarmGui"
screenGui.ResetOnSpawn = false

local frame = Instance.new("Frame", screenGui)
frame.Size = UDim2.new(0, 160, 0, 80)
frame.Position = UDim2.new(0.02, 0, 0.3, 0)
frame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
frame.BorderSizePixel = 0
frame.Active = true
frame.Draggable = true

local corner = Instance.new("UICorner", frame)
corner.CornerRadius = UDim.new(0, 6)

local statusLabel = Instance.new("TextLabel", frame)
statusLabel.Size = UDim2.new(1, 0, 0, 40)
statusLabel.Text = "Suche Laufband..."
statusLabel.TextColor3 = Color3.fromRGB(0, 255, 128)
statusLabel.TextSize = 14
statusLabel.Font = Enum.Font.SourceSansBold
statusLabel.BackgroundTransparency = 1

-- Rejoin-Button hinzufügen
local rejoinButton = Instance.new("TextButton", frame)
rejoinButton.Size = UDim2.new(0.9, 0, 0, 30)
rejoinButton.Position = UDim2.new(0.05, 0, 0.5, 5)
rejoinButton.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
rejoinButton.Text = "Rejoin Server"
rejoinButton.TextColor3 = Color3.fromRGB(255, 255, 255)
rejoinButton.TextSize = 13
rejoinButton.Font = Enum.Font.SourceSansBold

local btnCorner = Instance.new("UICorner", rejoinButton)
btnCorner.CornerRadius = UDim.new(0, 4)

-- Funktion beim Klick auf den Rejoin-Button
rejoinButton.MouseButton1Click:Connect(function()
    statusLabel.Text = "Rejoining..."
    if #Players:GetPlayers() <= 1 then
        TeleportService:Teleport(game.PlaceId, player)
    else
        TeleportService:TeleportToPlaceInstance(game.PlaceId, game.JobId, player)
    end
end)

-- Funktion zum automatischen Finden deines Laufbands
local function findMyTreadmill()
    for _, obj in ipairs(workspace:GetDescendants()) do
        if obj:IsA("BasePart") then
            local name = string.lower(obj.Name)
            if string.find(name, "laufband") or string.find(name, "treadmill") or string.find(name, "speed") then
                if obj:FindFirstAncestor(player.Name) then
                    return obj
                end
            end
        end
    end
    return nil
end

-- Suchen, bis das Laufband geladen ist
local myTreadmill = nil
while not myTreadmill do
    myTreadmill = findMyTreadmill()
    if not myTreadmill then 
        task.wait(1) 
    end
end

statusLabel.Text = "Laufband gefunden!"
print("[AutoFarm] Laufband erfolgreich gefunden!")

-- Grünes ESP auf dem Laufband erstellen
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
task.spawn(function()
    while true do
        task.wait(0.5)
        local char = player.Character
        if char and char:FindFirstChild("Humanoid") and char:FindFirstChild("HumanoidRootPart") then
            if myTreadmill and myTreadmill.Parent then
                char.Humanoid:MoveTo(myTreadmill.Position)
            else
                myTreadmill = findMyTreadmill()
            end
        end
    end
end)
