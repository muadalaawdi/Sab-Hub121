-- [[ ronaldothegond real sab hub ]] --
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")
local TeleportService = game:GetService("TeleportService")
local RunService = game:GetService("RunService")
local Workspace = game:GetService("Workspace")
local UserInputService = game:GetService("UserInputService")
local Lighting = game:GetService("Lighting")

-- // GLOBAL STATE
_G.TimerESP = false
_G.ForceAllow = false
_G.AutoLock = false
_G.WalkSpeed = 16
_G.InfJump = false
_G.FullBright = false

-- // 1. NOTIFICATIONS & SOUND
local function Notify(title, text)
    game:GetService("StarterGui"):SetCore("SendNotification", {
        Title = title; Text = text; Duration = 4;
    })
end

local function PlayDing()
    local s = Instance.new("Sound", Workspace)
    s.SoundId = "rbxassetid://4590662766"
    s:Play() task.wait(1) s:Destroy()
end

-- // 2. TIMER ESP & MOVEMENT LOOP
RunService.RenderStepped:Connect(function()
    if _G.TimerESP then
        for _, v in pairs(Workspace:GetDescendants()) do
            if v:IsA("BillboardGui") then
                v.AlwaysOnTop = true
                v.Enabled = true
                for _, child in pairs(v:GetChildren()) do
                    if child:IsA("TextLabel") and (child.Text:find(":") or child.Text:match("%d")) then
                        child.Visible = true
                        child.TextColor3 = Color3.fromRGB(255, 0, 0)
                        child.TextTransparency = 0
                    end
                end
            end
        end
    end
    
    if _G.FullBright then
        Lighting.Brightness = 2
        Lighting.ClockTime = 14
        Lighting.FogEnd = 100000
        Lighting.GlobalShadows = false
    end

    if LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid") then
        LocalPlayer.Character:FindFirstChildOfClass("Humanoid").WalkSpeed = _G.WalkSpeed
    end
end)

-- // 3. INFINITE JUMP
UserInputService.JumpRequest:Connect(function()
    if _G.InfJump and LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid") then
        LocalPlayer.Character:FindFirstChildOfClass("Humanoid"):ChangeState("Jumping")
    end
end)

-- // 4. BASE AUTOMATION (Lock & Allow)
RunService.Heartbeat:Connect(function()
    for _, v in pairs(Workspace:GetDescendants()) do
        if v:IsA("ClickDetector") then
            local btnName = v.Parent.Name:lower()
            if _G.ForceAllow and (btnName:find("allow") or btnName:find("friends")) then
                fireclickdetector(v)
            end
            if _G.AutoLock and (btnName:find("lock") or btnName:find("close") or btnName:find("door")) then
                fireclickdetector(v)
            end
        end
    end
end)

-- // 5. MASTER GUI SETUP
if PlayerGui:FindFirstChild("RonaldRealHub") then PlayerGui.RonaldRealHub:Destroy() end
local sg = Instance.new("ScreenGui", PlayerGui); sg.Name = "RonaldRealHub"; sg.ResetOnSpawn = false

local frame = Instance.new("Frame", sg)
frame.Size = UDim2.fromOffset(260, 480); frame.Position = UDim2.fromScale(0.5, 0.5); frame.AnchorPoint = Vector2.new(0.5, 0.5)
frame.BackgroundColor3 = Color3.fromRGB(15, 15, 20); frame.Active, frame.Draggable = true, true
Instance.new("UIStroke", frame).Color = Color3.fromRGB(0, 200, 255); Instance.new("UICorner", frame)

local title = Instance.new("TextLabel", frame)
title.Size = UDim2.new(1, 0, 0, 40); title.Text = "ronaldothegond real sab hub (V100)"; title.TextColor3 = Color3.fromRGB(0, 220, 255)
title.BackgroundTransparency = 1; title.Font = Enum.Font.GothamBold; title.TextSize = 11

-- MINIMIZE SYSTEM
local minBtn = Instance.new("TextButton", sg)
minBtn.Size = UDim2.fromOffset(60, 60); minBtn.Position = UDim2.new(0, 10, 0.5, 0)
minBtn.BackgroundColor3 = Color3.fromRGB(0, 200, 255); minBtn.Text = "RH"; minBtn.TextColor3 = Color3.fromRGB(15, 15, 20)
minBtn.Font = Enum.Font.GothamBold; minBtn.TextSize = 25; minBtn.Visible = false; Instance.new("UICorner", minBtn).CornerRadius = UDim.new(0.5, 0)

local function toggleUI() frame.Visible = not frame.Visible; minBtn.Visible = not frame.Visible end
local closeBtn = Instance.new("TextButton", frame)
closeBtn.Size = UDim2.fromOffset(30, 30); closeBtn.Position = UDim2.new(1, -35, 0, 5); closeBtn.Text = "_"
closeBtn.BackgroundColor3 = Color3.fromRGB(200, 50, 50); closeBtn.TextColor3 = Color3.new(1,1,1); Instance.new("UICorner", closeBtn)
closeBtn.MouseButton1Click:Connect(toggleUI); minBtn.MouseButton1Click:Connect(toggleUI)

local function makeBtn(txt, y, cb, color)
    local b = Instance.new("TextButton", frame); b.Size = UDim2.new(1, -20, 0, 32); b.Position = UDim2.new(0, 10, 0, y)
    b.BackgroundColor3 = color or Color3.fromRGB(0, 200, 255); b.Text = txt; b.TextColor3 = Color3.new(1,1,1)
    b.Font = Enum.Font.GothamBold; b.TextSize = 10; Instance.new("UICorner", b)
    b.MouseButton1Click:Connect(function() cb(b) end); return b
end

-- // BUTTON LIST
makeBtn("REJOIN SERVER", 45, function() TeleportService:Teleport(game.PlaceId, LocalPlayer) end, Color3.fromRGB(0, 150, 100))

makeBtn("TIMER ESP: OFF", 85, function(b) 
    _G.TimerESP = not _G.TimerESP 
    b.Text = "TIMER ESP: " .. (_G.TimerESP and "ON" or "OFF")
    b.BackgroundColor3 = _G.TimerESP and Color3.fromRGB(0, 255, 150) or Color3.fromRGB(0, 200, 255)
end)

makeBtn("INF JUMP: OFF", 125, function(b)
    _G.InfJump = not _G.InfJump
    b.Text = "INF JUMP: " .. (_G.InfJump and "ON" or "OFF")
    b.BackgroundColor3 = _G.InfJump and Color3.fromRGB(0, 255, 150) or Color3.fromRGB(0, 200, 255)
end)

makeBtn("FULL BRIGHT: OFF", 165, function(b)
    _G.FullBright = not _G.FullBright
    b.Text = "FULL BRIGHT: " .. (_G.FullBright and "ON" or "OFF")
    b.BackgroundColor3 = _G.FullBright and Color3.fromRGB(0, 255, 150) or Color3.fromRGB(0, 200, 255)
end)

makeBtn("SPEED +", 205, function() _G.WalkSpeed = _G.WalkSpeed + 10 end, Color3.fromRGB(50, 50, 50))
makeBtn("SPEED -", 240, function() _G.WalkSpeed = math.max(16, _G.WalkSpeed - 10) end, Color3.fromRGB(50, 50, 50))

makeBtn("AUTO-ALLOW FRIENDS: OFF", 280, function(b)
    _G.ForceAllow = not _G.ForceAllow
    b.Text = "AUTO-ALLOW: " .. (_G.ForceAllow and "ON" or "OFF")
    b.BackgroundColor3 = _G.ForceAllow and Color3.fromRGB(255, 150, 0) or Color3.fromRGB(0, 200, 255)
end)

makeBtn("AUTO-LOCK BASE: OFF", 320, function(b)
    _G.AutoLock = not _G.AutoLock
    b.Text = "AUTO-LOCK: " .. (_G.AutoLock and "ON" or "OFF")
    b.BackgroundColor3 = _G.AutoLock and Color3.fromRGB(255, 150, 0) or Color3.fromRGB(0, 200, 255)
end)

makeBtn("ronaldothegond", 430, function() 
    LocalPlayer:Kick("ronaldothegond saved ur brainrots from getting stolen") 
end, Color3.fromRGB(150, 0, 255))

-- Initialize
PlayDing()
Notify("Master Hub", "All systems consolidated!")
