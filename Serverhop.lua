local Players = game:GetService("Players")
local TeleportService = game:GetService("TeleportService")
local player = Players.LocalPlayer

-- GUI Farbe: ROT (neues Update: Anti-Same-Server-Methode)
local GUI_COLOR = Color3.fromRGB(200, 50, 50)

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
    btn.Text = "Blockiere..."
    
    -- Schnappt sich automatisch den ersten Spieler, der nicht du selbst bist
    local targetPlayer = nil
    for _, p in ipairs(Players:GetPlayers()) do
        if p ~= player then
            targetPlayer = p
            break
        end
    end
    
    -- Wenn jemand auf dem Server ist, blockieren wir ihn per Roblox-Funktion
    if targetPlayer then
        pcall(function()
            StarterGui:SetCore("PromptBlockPlayer", targetPlayer)
        end)
    end
    
    btn.Text = "Hoppe..."
    -- Sofortiger Hop
    TeleportService:Teleport(game.PlaceId, player)
end)
