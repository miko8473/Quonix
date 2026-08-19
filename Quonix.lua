-- Services & Spieler
local Players = game:GetService("Players")
local player = Players.LocalPlayer
local runService = game:GetService("RunService")

print("[AutoFarm] Skript gestartet. Suche nach deinem Laufband...")

-- Funktion zum automatischen Finden deines Laufbands
local function findMyTreadmill()
    for _, obj in ipairs(workspace:GetDescendants()) do
        if obj:IsA("BasePart") then
            local name = string.lower(obj.Name)
            if string.find(name, "laufband") or string.find(name, "treadmill") or string.find(name, "speed") then
                -- Prüft, ob das Laufband zu deinem Plot/Bereich gehört
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
                -- Falls sich etwas ändert, neu suchen
                myTreadmill = findMyTreadmill()
            end
        end
    end
end)
