local Players = game:GetService("Players")
local TeleportService = game:GetService("TeleportService")
local player = Players.LocalPlayer

local screenGui = Instance.new("ScreenGui", player.PlayerGui)
screenGui.Name = "QuonixServerHop"
screenGui.ResetOnSpawn = false

local btn = Instance.new("TextButton", screenGui)
btn.Size = UDim2.new(0, 130, 0, 40)
btn.Position = UDim2.new(0.02, 0, 0.3, 0)
btn.BackgroundColor3 = Color3.fromRGB(50, 200, 50) -- Grün für "Hop"
btn.Text = "Server Hop"
btn.TextColor3 = Color3.fromRGB(255, 255, 255)
btn.TextSize = 14
btn.Font = Enum.Font.SourceSansBold
btn.Active = true
btn.Draggable = true

Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 6)

btn.MouseButton1Click:Connect(function()
    btn.Text = "Suche Server..."
    
    -- Teleportiert den Spieler in ein neues, zufälliges Server-Matchmaking
    -- Wir nutzen keinen spezifischen Instance-Key, daher sucht Roblox automatisch einen neuen Server
    TeleportService:Teleport(game.PlaceId, player)
end)
