 -- Services
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local player = Players.LocalPlayer

-- Anti-AFK
task.spawn(function()
    while true do
        task.wait(50)
        pcall(function()
            local cam = workspace.CurrentCamera
            if cam then
                cam.CFrame = cam.CFrame * CFrame.Angles(0, 0.001, 0)
            end
        end)
    end
end)

-- Global Combat & Farming Variables
local autoHitEnabled = false
local aimbotEnabled = false
local antiKnockbackEnabled = false
local autoEggEnabled = false
local isFarmingActive = false

local saveZonePosition = nil
local conveyorPosition = nil
local nightSaveZonePosition = nil
local savedManualPosition = nil

-- Force ScreenGui into PlayerGui
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "QuonixGui"
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = player:WaitForChild("PlayerGui")

--------------------------------------------------------------------------------
-- MAIN HUB
--------------------------------------------------------------------------------
local MainHub = Instance.new("Frame")
MainHub.Size = UDim2.new(0, 340, 0, 50)
MainHub.Position = UDim2.new(0.2, 0, 0.05, 0)
MainHub.BackgroundColor3 = Color3.fromRGB(25, 20, 35)
MainHub.BorderSizePixel = 0
MainHub.Active = true
MainHub.Draggable = true
MainHub.Parent = ScreenGui
Instance.new("UICorner", MainHub).CornerRadius = UDim.new(0, 14)

local TopBar = Instance.new("Frame", MainHub)
TopBar.Size = UDim2.new(1, 0, 0, 40)
TopBar.BackgroundTransparency = 1
TopBar.ZIndex = 2

local HubTitle = Instance.new("TextLabel", TopBar)
HubTitle.Size = UDim2.new(0, 70, 1, 0)
HubTitle.Position = UDim2.new(0.05, 0, 0, 0)
HubTitle.BackgroundTransparency = 1
HubTitle.Text = "Quonix"
HubTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
HubTitle.TextSize = 16
HubTitle.Font = Enum.Font.GothamBold
HubTitle.TextXAlignment = Enum.TextXAlignment.Left

-- Uhrzeit / Timer direkt neben dem Namen
local ClockLabel = Instance.new("TextLabel", TopBar)
ClockLabel.Size = UDim2.new(0, 140, 1, 0)
ClockLabel.Position = UDim2.new(0.05, 65, 0, 0)
ClockLabel.BackgroundTransparency = 1
ClockLabel.Text = os.date("%H:%M:%S")
ClockLabel.TextColor3 = Color3.fromRGB(180, 120, 255)
ClockLabel.TextSize = 13
ClockLabel.Font = Enum.Font.GothamBold
ClockLabel.TextXAlignment = Enum.TextXAlignment.Left

local CloseButton = Instance.new("TextButton", TopBar)
CloseButton.Size = UDim2.new(0, 30, 0, 30)
CloseButton.Position = UDim2.new(1, -35, 0, 5)
CloseButton.BackgroundColor3 = Color3.fromRGB(180, 50, 50)
CloseButton.TextColor3 = Color3.fromRGB(255, 255, 255)
CloseButton.Text = "X"
CloseButton.TextSize = 14
Instance.new("UICorner", CloseButton).CornerRadius = UDim.new(0, 6)

CloseButton.MouseButton1Click:Connect(function()
    pcall(function() ScreenGui:Destroy() end)
end)

local ContentHolder = Instance.new("ScrollingFrame", MainHub)
ContentHolder.Size = UDim2.new(1, 0, 1, -45)
ContentHolder.Position = UDim2.new(0, 0, 0, 45)
ContentHolder.BackgroundTransparency = 1
ContentHolder.BorderSizePixel = 0
ContentHolder.AutomaticCanvasSize = Enum.AutomaticSize.Y
ContentHolder.CanvasSize = UDim2.new(0, 0, 0, 0)
ContentHolder.ScrollBarThickness = 4

local UIListLayout = Instance.new("UIListLayout", ContentHolder)
UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
UIListLayout.Padding = UDim.new(0, 8)

local function updateMainHubSize()
    task.defer(function()
        local totalHeight = UIListLayout.AbsoluteContentSize.Y + 55
        MainHub.Size = UDim2.new(0, 340, 0, totalHeight)
    end)
end

UIListLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(updateMainHubSize)

--------------------------------------------------------------------------------
-- 1. SECTION: COMBAT & AIMBOT
--------------------------------------------------------------------------------
local CombatContainer = Instance.new("Frame", ContentHolder)
CombatContainer.Size = UDim2.new(1, 0, 0, 150)
CombatContainer.BackgroundTransparency = 1
CombatContainer.LayoutOrder = 1

local CombatHeader = Instance.new("TextButton", CombatContainer)
CombatHeader.Size = UDim2.new(0.9, 0, 0, 35)
CombatHeader.Position = UDim2.new(0.05, 0, 0, 0)
CombatHeader.BackgroundTransparency = 1
CombatHeader.Text = "--- Combat & Aimbot [v] ---"
CombatHeader.TextColor3 = Color3.fromRGB(180, 120, 255)
CombatHeader.TextSize = 16
CombatHeader.Font = Enum.Font.GothamBold
CombatHeader.TextXAlignment = Enum.TextXAlignment.Left

local CombatContent = Instance.new("Frame", CombatContainer)
CombatContent.Size = UDim2.new(1, 0, 0, 110)
CombatContent.Position = UDim2.new(0, 0, 0, 38)
CombatContent.BackgroundTransparency = 1
CombatContent.Visible = true

local AutoHitBtn = Instance.new("TextButton", CombatContent)
AutoHitBtn.Size = UDim2.new(0.9, 0, 0, 32)
AutoHitBtn.Position = UDim2.new(0.05, 0, 0, 0)
AutoHitBtn.BackgroundColor3 = Color3.fromRGB(120, 50, 200)
AutoHitBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
AutoHitBtn.Text = "Auto Hit: OFF"
AutoHitBtn.TextSize = 13
AutoHitBtn.Font = Enum.Font.GothamSemibold
Instance.new("UICorner", AutoHitBtn).CornerRadius = UDim.new(0, 8)

local AimbotBtn = Instance.new("TextButton", CombatContent)
AimbotBtn.Size = UDim2.new(0.9, 0, 0, 32)
AimbotBtn.Position = UDim2.new(0.05, 0, 0, 38)
AimbotBtn.BackgroundColor3 = Color3.fromRGB(120, 50, 200)
AimbotBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
AimbotBtn.Text = "Aimbot (20 Studs): OFF"
AimbotBtn.TextSize = 13
AimbotBtn.Font = Enum.Font.GothamSemibold
Instance.new("UICorner", AimbotBtn).CornerRadius = UDim.new(0, 8)

local KnockbackBtn = Instance.new("TextButton", CombatContent)
KnockbackBtn.Size = UDim2.new(0.9, 0, 0, 32)
KnockbackBtn.Position = UDim2.new(0.05, 0, 0, 76)
KnockbackBtn.BackgroundColor3 = Color3.fromRGB(120, 50, 200)
KnockbackBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
KnockbackBtn.Text = "Anti-Knockback: OFF"
KnockbackBtn.TextSize = 13
KnockbackBtn.Font = Enum.Font.GothamSemibold
Instance.new("UICorner", KnockbackBtn).CornerRadius = UDim.new(0, 8)

CombatHeader.MouseButton1Click:Connect(function()
    CombatContent.Visible = not CombatContent.Visible
    if CombatContent.Visible then
        CombatHeader.Text = "--- Combat & Aimbot [v] ---"
        CombatContainer.Size = UDim2.new(1, 0, 0, 150)
    else
        CombatHeader.Text = "--- Combat & Aimbot [^] ---"
        CombatContainer.Size = UDim2.new(1, 0, 0, 35)
    end
    updateMainHubSize()
end)

--------------------------------------------------------------------------------
-- 2. SECTION: MANUAL TP
--------------------------------------------------------------------------------
local TpContainer = Instance.new("Frame", ContentHolder)
TpContainer.Size = UDim2.new(1, 0, 0, 75)
TpContainer.BackgroundTransparency = 1
TpContainer.LayoutOrder = 2

local TpHeader = Instance.new("TextButton", TpContainer)
TpHeader.Size = UDim2.new(0.9, 0, 0, 35)
TpHeader.Position = UDim2.new(0.05, 0, 0, 0)
TpHeader.BackgroundTransparency = 1
TpHeader.Text = "--- Manual TP [v] ---"
TpHeader.TextColor3 = Color3.fromRGB(180, 120, 255)
TpHeader.TextSize = 16
TpHeader.Font = Enum.Font.GothamBold
TpHeader.TextXAlignment = Enum.TextXAlignment.Left

local TpContent = Instance.new("Frame", TpContainer)
TpContent.Size = UDim2.new(1, 0, 0, 40)
TpContent.Position = UDim2.new(0, 0, 0, 38)
TpContent.BackgroundTransparency = 1
TpContent.Visible = true

local SavePosBtn = Instance.new("TextButton", TpContent)
SavePosBtn.Size = UDim2.new(0.42, 0, 0, 32)
SavePosBtn.Position = UDim2.new(0.05, 0, 0, 0)
SavePosBtn.BackgroundColor3 = Color3.fromRGB(50, 40, 75)
SavePosBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
SavePosBtn.Text = "Save Position"
SavePosBtn.TextSize = 13
SavePosBtn.Font = Enum.Font.GothamSemibold
Instance.new("UICorner", SavePosBtn).CornerRadius = UDim.new(0, 8)

local WalkBtn = Instance.new("TextButton", TpContent)
WalkBtn.Size = UDim2.new(0.42, 0, 0, 32)
WalkBtn.Position = UDim2.new(0.53, 0, 0, 0)
WalkBtn.BackgroundColor3 = Color3.fromRGB(120, 50, 200)
WalkBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
WalkBtn.Text = "Go to Position"
WalkBtn.TextSize = 13
WalkBtn.Font = Enum.Font.GothamBold
Instance.new("UICorner", WalkBtn).CornerRadius = UDim.new(0, 8)

TpHeader.MouseButton1Click:Connect(function()
    TpContent.Visible = not TpContent.Visible
    if TpContent.Visible then
        TpHeader.Text = "--- Manual TP [v] ---"
        TpContainer.Size = UDim2.new(1, 0, 0, 75)
    else
        TpHeader.Text = "--- Manual TP [^] ---"
        TpContainer.Size = UDim2.new(1, 0, 0, 35)
    end
    updateMainHubSize()
end)

--------------------------------------------------------------------------------
-- 3. SECTION: AUTO FARMING LOGIC
--------------------------------------------------------------------------------
local FarmContainer = Instance.new("Frame", ContentHolder)
FarmContainer.Size = UDim2.new(1, 0, 0, 230)
FarmContainer.BackgroundTransparency = 1
FarmContainer.LayoutOrder = 3

local FarmHeader = Instance.new("TextButton", FarmContainer)
FarmHeader.Size = UDim2.new(0.9, 0, 0, 35)
FarmHeader.Position = UDim2.new(0.05, 0, 0, 0)
FarmHeader.BackgroundTransparency = 1
FarmHeader.Text = "--- Auto Farming Logic [v] ---"
FarmHeader.TextColor3 = Color3.fromRGB(180, 120, 255)
FarmHeader.TextSize = 16
FarmHeader.Font = Enum.Font.GothamBold
FarmHeader.TextXAlignment = Enum.TextXAlignment.Left

local FarmContent = Instance.new("Frame", FarmContainer)
FarmContent.Size = UDim2.new(1, 0, 0, 190)
FarmContent.Position = UDim2.new(0, 0, 0, 38)
FarmContent.BackgroundTransparency = 1
FarmContent.Visible = true

local StartStopBtn = Instance.new("TextButton", FarmContent)
StartStopBtn.Size = UDim2.new(0.9, 0, 0, 35)
StartStopBtn.Position = UDim2.new(0.05, 0, 0, 0)
StartStopBtn.BackgroundColor3 = Color3.fromRGB(0, 170, 80)
StartStopBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
StartStopBtn.Text = "Start Farming"
StartStopBtn.TextSize = 14
StartStopBtn.Font = Enum.Font.GothamBold
Instance.new("UICorner", StartStopBtn).CornerRadius = UDim.new(0, 8)

local SaveZoneBtn = Instance.new("TextButton", FarmContent)
SaveZoneBtn.Size = UDim2.new(0.9, 0, 0, 32)
SaveZoneBtn.Position = UDim2.new(0.05, 0, 0, 40)
SaveZoneBtn.BackgroundColor3 = Color3.fromRGB(50, 40, 75)
SaveZoneBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
SaveZoneBtn.Text = "Save Safe Zone"
SaveZoneBtn.TextSize = 13
SaveZoneBtn.Font = Enum.Font.GothamSemibold
Instance.new("UICorner", SaveZoneBtn).CornerRadius = UDim.new(0, 8)

local SaveConveyorBtn = Instance.new("TextButton", FarmContent)
SaveConveyorBtn.Size = UDim2.new(0.9, 0, 0, 32)
SaveConveyorBtn.Position = UDim2.new(0.05, 0, 0, 76)
SaveConveyorBtn.BackgroundColor3 = Color3.fromRGB(50, 40, 75)
SaveConveyorBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
SaveConveyorBtn.Text = "Save Conveyor"
SaveConveyorBtn.TextSize = 13
SaveConveyorBtn.Font = Enum.Font.GothamSemibold
Instance.new("UICorner", SaveConveyorBtn).CornerRadius = UDim.new(0, 8)

local SaveNightZoneBtn = Instance.new("TextButton", FarmContent)
SaveNightZoneBtn.Size = UDim2.new(0.9, 0, 0, 32)
SaveNightZoneBtn.Position = UDim2.new(0.05, 0, 0, 112)
SaveNightZoneBtn.BackgroundColor3 = Color3.fromRGB(50, 40, 75)
SaveNightZoneBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
SaveNightZoneBtn.Text = "Save Night Zone"
SaveNightZoneBtn.TextSize = 13
SaveNightZoneBtn.Font = Enum.Font.GothamSemibold
Instance.new("UICorner", SaveNightZoneBtn).CornerRadius = UDim.new(0, 8)

local AutoEggBtn = Instance.new("TextButton", FarmContent)
AutoEggBtn.Size = UDim2.new(0.9, 0, 0, 32)
AutoEggBtn.Position = UDim2.new(0.05, 0, 0, 148)
AutoEggBtn.BackgroundColor3 = Color3.fromRGB(120, 50, 200)
AutoEggBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
AutoEggBtn.Text = "Auto Secret Eternal Farm: OFF"
AutoEggBtn.TextSize = 13
AutoEggBtn.Font = Enum.Font.GothamBold
Instance.new("UICorner", AutoEggBtn).CornerRadius = UDim.new(0, 8)

FarmHeader.MouseButton1Click:Connect(function()
    FarmContent.Visible = not FarmContent.Visible
    if FarmContent.Visible then
        FarmHeader.Text = "--- Auto Farming Logic [v] ---"
        FarmContainer.Size = UDim2.new(1, 0, 0, 230)
    else
        FarmHeader.Text = "--- Auto Farming Logic [^] ---"
        FarmContainer.Size = UDim2.new(1, 0, 0, 35)
    end
    updateMainHubSize()
end)

AutoHitBtn.MouseButton1Click:Connect(function()
    autoHitEnabled = not autoHitEnabled
    if autoHitEnabled then
        AutoHitBtn.BackgroundColor3 = Color3.fromRGB(40, 120, 200)
        AutoHitBtn.Text = "Auto Hit: ON"
    else
        AutoHitBtn.BackgroundColor3 = Color3.fromRGB(120, 50, 200)
        AutoHitBtn.Text = "Auto Hit: OFF"
    end
end)

AimbotBtn.MouseButton1Click:Connect(function()
    aimbotEnabled = not aimbotEnabled
    if aimbotEnabled then
        AimbotBtn.BackgroundColor3 = Color3.fromRGB(40, 120, 200)
        AimbotBtn.Text = "Aimbot (20 Studs): ON"
    else
        AimbotBtn.BackgroundColor3 = Color3.fromRGB(120, 50, 200)
        AimbotBtn.Text = "Aimbot (20 Studs): OFF"
    end
end)

KnockbackBtn.MouseButton1Click:Connect(function()
    antiKnockbackEnabled = not antiKnockbackEnabled
    if antiKnockbackEnabled then
        KnockbackBtn.BackgroundColor3 = Color3.fromRGB(40, 120, 200)
        KnockbackBtn.Text = "Anti-Knockback: ON"
    else
        KnockbackBtn.BackgroundColor3 = Color3.fromRGB(120, 50, 200)
        KnockbackBtn.Text = "Anti-Knockback: OFF"
    end
end)

SavePosBtn.MouseButton1Click:Connect(function()
    pcall(function()
        local char = player.Character
        if char and char:FindFirstChild("HumanoidRootPart") then
            savedManualPosition = char.HumanoidRootPart.Position
            SavePosBtn.Text = "Saved!"
            task.wait(1)
            SavePosBtn.Text = "Save Position"
        end
    end)
end)

WalkBtn.MouseButton1Click:Connect(function()
    pcall(function()
        local char = player.Character
        local humanoid = char and char:FindFirstChild("Humanoid")
        if humanoid and savedManualPosition then
            humanoid:MoveTo(savedManualPosition)
        end
    end)
end)

SaveZoneBtn.MouseButton1Click:Connect(function()
    pcall(function()
        local char = player.Character
        if char and char:FindFirstChild("HumanoidRootPart") then
            saveZonePosition = char.HumanoidRootPart.Position
            SaveZoneBtn.BackgroundColor3 = Color3.fromRGB(40, 120, 200)
            SaveZoneBtn.Text = "Safe Zone: SAVED"
        end
    end)
end)

SaveConveyorBtn.MouseButton1Click:Connect(function()
    pcall(function()
        local char = player.Character
        if char and char:FindFirstChild("HumanoidRootPart") then
            conveyorPosition = char.HumanoidRootPart.Position
            SaveConveyorBtn.BackgroundColor3 = Color3.fromRGB(40, 120, 200)
            SaveConveyorBtn.Text = "Conveyor: SAVED"
        end
    end)
end)

SaveNightZoneBtn.MouseButton1Click:Connect(function()
    pcall(function()
        local char = player.Character
        if char and char:FindFirstChild("HumanoidRootPart") then
            nightSaveZonePosition = char.HumanoidRootPart.Position
            SaveNightZoneBtn.BackgroundColor3 = Color3.fromRGB(40, 120, 200)
            SaveNightZoneBtn.Text = "Night Safe Zone: SAVED"
        end
    end)
end)

AutoEggBtn.MouseButton1Click:Connect(function()
    autoEggEnabled = not autoEggEnabled
    if autoEggEnabled then
        AutoEggBtn.BackgroundColor3 = Color3.fromRGB(40, 120, 200)
        AutoEggBtn.Text = "Auto Secret Eternal Farm: ON"
    else
        AutoEggBtn.BackgroundColor3 = Color3.fromRGB(120, 50, 200)
        AutoEggBtn.Text = "Auto Secret Eternal Farm: OFF"
        if isFarmingActive then
            isFarmingActive = false
            StartStopBtn.BackgroundColor3 = Color3.fromRGB(0, 170, 80)
            StartStopBtn.Text = "Start Farming"
        end
    end
end)

StartStopBtn.MouseButton1Click:Connect(function()
    if isFarmingActive then
        isFarmingActive = false
        StartStopBtn.BackgroundColor3 = Color3.fromRGB(0, 170, 80)
        StartStopBtn.Text = "Start Farming"
    else
        if saveZonePosition and conveyorPosition and nightSaveZonePosition and autoEggEnabled then
            isFarmingActive = true
            antiKnockbackEnabled = true
            KnockbackBtn.BackgroundColor3 = Color3.fromRGB(40, 120, 200)
            KnockbackBtn.Text = "Anti-Knockback: ON"

            autoHitEnabled = true
            AutoHitBtn.BackgroundColor3 = Color3.fromRGB(40, 120, 200)
            AutoHitBtn.Text = "Auto Hit: ON"

            StartStopBtn.BackgroundColor3 = Color3.fromRGB(180, 50, 50)
            StartStopBtn.Text = "Stop"
        else
            StartStopBtn.Text = "Set all 3 positions & enable first!"
            task.wait(1.8)
            StartStopBtn.Text = "Start Farming"
        end
    end
end)

--------------------------------------------------------------------------------
-- CLOCK LOOP (Aktualisiert die Uhrzeit sekündlich)
--------------------------------------------------------------------------------
task.spawn(function()
    while true do
        task.wait(1)
        pcall(function()
            ClockLabel.Text = os.date("%H:%M:%S")
        end)
    end
end)

--------------------------------------------------------------------------------
-- COMBAT & FARMING LOOPS
--------------------------------------------------------------------------------
local function equipBat()
    pcall(function()
        local char = player.Character
        if not char then return end
        if char:FindFirstChildOfClass("Tool") then return end
        local backpack = player:FindFirstChildOfClass("Backpack")
        if backpack then
            for _, item in ipairs(backpack:GetChildren()) do
                if item:IsA("Tool") then
                    item.Parent = char
                    break
                end
            end
        end
    end)
end

RunService.Heartbeat:Connect(function()
    pcall(function()
        if antiKnockbackEnabled then
            local char = player.Character
            local hrp = char and char:FindFirstChild("HumanoidRootPart")
            if hrp then
                local vel = hrp.Velocity
                if math.abs(vel.X) > 60 or math.abs(vel.Z) > 60 then
                    hrp.Velocity = Vector3.new(vel.X * 0.2, vel.Y, vel.Z * 0.2)
                end
            end
        end
    end)
end)

task.spawn(function()
    while true do
        task.wait(0.1)
        pcall(function()
            if autoHitEnabled or aimbotEnabled then
                equipBat()
                local char = player.Character
                local hrp = char and char:FindFirstChild("HumanoidRootPart")
                if hrp then
                    local targetPos = nil
                    if aimbotEnabled then
                        local closestDist = 20
                        local closestPlayer = nil
                        for _, otherPlayer in ipairs(Players:GetPlayers()) do
                            if otherPlayer ~= player and otherPlayer.Character then
                                local otherHrp = otherPlayer.Character:FindFirstChild("HumanoidRootPart")
                                local otherHum = otherPlayer.Character:FindFirstChildOfClass("Humanoid")
                                if otherHrp and otherHum and otherHum.Health > 0 then
                                    local dist = (hrp.Position - otherHrp.Position).Magnitude
                                    if dist < closestDist then
                                        closestDist = dist
                                        closestPlayer = otherPlayer
                                    end
                                end
                            end
                        end
                        if closestPlayer and closestPlayer.Character then
                            local otherHrp = closestPlayer.Character:FindFirstChild("HumanoidRootPart")
                            if otherHrp then
                                targetPos = otherHrp.Position
                                hrp.CFrame = CFrame.new(hrp.Position, Vector3.new(targetPos.X, hrp.Position.Y, targetPos.Z))
                            end
                        end
                    end
                    local tool = char:FindFirstChildOfClass("Tool")
                    if tool and (autoHitEnabled or targetPos) then
                        tool:Activate()
                    end
                end
            end
        end)
    end
end)

local function walkToTarget(pos, shouldJump)
    pcall(function()
        local char = player.Character
        local humanoid = char and char:FindFirstChild("Humanoid")
        local hrp = char and char:FindFirstChild("HumanoidRootPart")
        if humanoid and hrp and humanoid.Health > 0 then
            if shouldJump then
                humanoid.Jump = true
                task.wait(0.05)
            end
            if (hrp.Position - pos).Magnitude > 3 then
                humanoid:MoveUpTo and humanoid:MoveTo(pos) or humanoid:MoveTo(pos)
            end
        end
    end)
end

task.spawn(function()
    while true do
        task.wait(0.3)
        pcall(function()
            if isFarmingActive and saveZonePosition and conveyorPosition and nightSaveZonePosition then
                local char = player.Character
                local hrp = char and char:FindFirstChild("HumanoidRootPart")
                if hrp then
                    walkToTarget(conveyorPosition, false)
                end
            end
        end)
    end
end)
