-- Services & Spieler
local Players = game:GetService("Players")
local TeleportService = game:GetService("TeleportService")
local player = Players.LocalPlayer

-- GUI Farbe: BLAU (neues Update signalisiert)
local GUI_COLOR = Color3.fromRGB(50, 100, 200)

local screenGui = Instance.new("ScreenGui", player.PlayerGui)
screenGui.Name = "QuonixServerHop"
screenGui.ResetOnSpawn = false

local btn = Instance.new("TextButton", screenGui)
btn.Size = UDim2.new(0, 130, 0, 40)
btn.Position = UDim2.new(0.02, 0, 0.3, 0)
btn.BackgroundColor3 = GUI_COLOR
btn.Text = "Server Hop"
btn.TextColor3 = Color3.fromRGB(255, 255, 255)
btn.TextSize = 14
btn.Font = Enum.Font.SourceSansBold
btn.Active = true
btn.Draggable = true

Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 6)

btn.MouseButton1Click:Connect(function()
    btn.Text = "Hoppe..."
    -- Aggressiverer Ansatz: Teleportiert zum gleichen Ort, aber zwingt einen neuen Sitzplatz
    local options = Instance.new("TeleportOptions")
    options.ShouldSkipWaitingForServer = true
    TeleportService:TeleportAsync(game.PlaceId, {player}, options)
end)
