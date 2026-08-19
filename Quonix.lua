local Players = game:GetService("Players")
local TeleportService = game:GetService("TeleportService")
local player = Players.LocalPlayer
local root = player.Character:WaitForChild("HumanoidRootPart")

-- GUI
local screenGui = Instance.new("ScreenGui", player.PlayerGui)
local statusLabel = Instance.new("TextLabel", screenGui)
statusLabel.Size = UDim2.new(0, 200, 0, 50)
statusLabel.Position = UDim2.new(0.5, -100, 0.1, 0)
statusLabel.Text = "Stell dich auf dein Laufband!"
statusLabel.TextColor3 = Color3.new(1, 1, 1)

local myTreadmill = nil

-- Finde das Teil unter uns
local function findUnderneath()
    local ray = Ray.new(root.Position, Vector3.new(0, -10, 0))
    local hit, pos = workspace:FindPartOnRayWithIgnoreList(ray, {player.Character})
    if hit then return hit end
    return nil
end

-- 1. Automatischer Lock: Warte, bis der Spieler auf seinem Laufband steht
task.spawn(function()
    statusLabel.Text = "Suche Laufband unter dir..."
    while not myTreadmill do
        local part = findUnderneath()
        if part then
            myTreadmill = part
            statusLabel.Text = "Laufband gefunden: " .. myTreadmill.Name
            
            -- ESP hinzufügen
            local box = Instance.new("BoxHandleAdornment", myTreadmill)
            box.Adornee = myTreadmill
            box.AlwaysOnTop = true
            box.Color3 = Color3.fromRGB(0, 255, 0)
            box.Size = myTreadmill.Size + Vector3.new(0.2, 0.2, 0.2)
        end
        task.wait(1)
    end
end)

-- 2. Dauerhaftes Laufen
task.spawn(function()
    while true do
        task.wait(0.2)
        if myTreadmill and myTreadmill.Parent then
            player.Character.Humanoid:MoveTo(myTreadmill.Position)
        end
    end
end)
