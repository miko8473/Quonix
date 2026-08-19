-- Services & Spieler
local Players = game:GetService("Players")
local player = Players.LocalPlayer

print("[AutoFarm] Skript gestartet...")

-- Funktion: Findet dein Laufband über dein Plot / deinen Namen im Workspace
local function findMyTreadmill()
    for _, obj in ipairs(workspace:GetDescendants()) do
        -- Wir suchen nach Modellen oder Teilen, die zu deinem Plot gehören
        if obj:IsA("Model") or obj:IsA("BasePart") then
            local name = string.lower(obj.Name)
            if string.find(name, "laufband") or string.find(name, "treadmill") or string.find(name, "speed") then
                -- Muss zu deinem Spielernamen (deinem Plot) gehören
                if obj:FindFirstAncestor(player.Name) then
                    return obj
                end
            end
        end
    end
    return nil
end

-- Laufband suchen bis es geladen ist
local myTreadmill = nil
while not myTreadmill do
    myTreadmill = findMyTreadmill()
    if not myTreadmill then 
        task.wait(1) 
    end
end

print("[AutoFarm] Laufband gefunden!")

-- Die exakte Position des Laufbands ermitteln (egal ob Model oder Part)
local function getTargetPosition(target)
    if target:IsA("Model") then
        local p, sz = target:GetBoundingBox()
        return p.Position
    elseif target:IsA("BasePart") then
        return target.Position
    end
    return target.Position
end

-- Grünes ESP auf das Laufband setzen
pcall(function()
    local targetPart = myTreadmill
    if myTreadmill:IsA("Model") then
        targetPart = myTreadmill.PrimaryPart or myTreadmill:FindFirstChildWhichIsA("BasePart")
    end
    
    if targetPart and not targetPart:FindFirstChild("TreadmillESP") then
        local box = Instance.new("BoxHandleAdornment")
        box.Name = "TreadmillESP"
        box.Adornee = targetPart
        box.AlwaysOnTop = true
        box.Size = targetPart.Size + Vector3.new(0.5, 0.5, 0.5)
        box.Color3 = Color3.fromRGB(0, 255, 0)
        box.Transparency = 0.5
        box.Parent = targetPart
    end
end)

-- Dauerhafte Bewegungs-Schleife (läuft nach jedem Rejoin automatisch weiter)
task.spawn(function()
    while true do
        task.wait(0.3)
        local char = player.Character
        if char and char:FindFirstChild("Humanoid") and char:FindFirstChild("HumanoidRootPart") then
            if myTreadmill and myTreadmill.Parent then
                local pos = getTargetPosition(myTreadmill)
                char.Humanoid:MoveTo(pos)
            else
                -- Falls sich nach einem Rejoin etwas ändert, wird neu gesucht
                myTreadmill = findMyTreadmill()
            end
        end
    end
end)
