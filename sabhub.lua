-- [[ ronaldothegond real sab hub ]] --
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")
local TeleportService = game:GetService("TeleportService")
local RunService = game:GetService("RunService")
local Workspace = game:GetService("Workspace")

-- // GLOBAL STATE
_G.TimerESP = false
_G.ForceAllow = false
_G.AutoLock = false

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

-- // 2. TIMER ESP LOGIC
RunService.RenderStepped:Connect(function()
    if _G.TimerESP then
        for _, v in pairs(Workspace:GetDescendants()) do
            if v:IsA("TextLabel") and v.Parent:IsA("BillboardGui") then
                if v.Text:find(":") then
                    v.AlwaysOnTop = true -- See through walls
                    v.TextColor3 = Color3.fromRGB(255, 0, 0)
                end
            end
        end
    end
end)

-- // 3. BASE ACCESS & AUTO-LOCK
RunService.Heartbeat:Connect(function()
    for _, v in pairs(Workspace:GetDescendants()) do
        if v:IsA("ClickDetector") then
            -- AUTO ALLOW LOGIC
            if _G.ForceAllow and (v.Parent.Name:lower():find("allow") or v.Parent.Name:lower():find("friend")) then
                fireclickdetector(v)
            end
            -- AUTO LOCK LOGIC
            if _G.AutoLock and (v.Parent.Name:lower():find("lock") or v.Parent.Name:lower():find("close")) then
                fireclickdetector(v)
            end
        end
    end
end)

-- // 4. REJOIN
local function Rejoin()
    PlayDing()
    Notify("Rejoining", "Connecting...")
    TeleportService:Teleport(game.PlaceId, LocalPlayer)
end

-- // 5. GUI SETUP
if PlayerGui:FindFirstChild("RonaldRealHub") then PlayerGui.RonaldRealHub:Destroy() end
local sg = Instance.new("ScreenGui", PlayerGui); sg.Name = "RonaldRealHub"; sg.ResetOnSpawn = false
local frame = Instance.new("Frame", sg)
frame.Size = UDim2.fromOffset(250, 360); frame.Position = UDim2.fromScale(0.5, 0.4); frame.AnchorPoint = Vector2.new(0.5, 0.5)
frame.BackgroundColor3 = Color3.fromRGB(15, 15, 20); frame.Active, frame.Draggable = true, true
Instance.new("UIStroke", frame).Color = Color3.fromRGB(0, 200, 255); Instance.new("UICorner", frame)

local title = Instance.new("TextLabel", frame)
title.Size = UDim2.new(1, 0, 0, 40); title.Text = "ronaldothegond real sab hub"; title.TextColor3 = Color3.fromRGB(0, 220, 255)
title.BackgroundTransparency = 1; title.Font = Enum.Font.GothamBold; title.TextSize = 11

local function makeBtn(txt, y, cb, color)
    local b = Instance.new("TextButton", frame); b.Size = UDim2.new(1, -20, 0, 35); b.Position = UDim2.new(0, 10, 0, y)
    b.BackgroundColor3 = color or Color3.fromRGB(0, 200, 255); b.Text = txt; b.TextColor3 = Color3.new(1,1,1)
    b.Font = Enum.Font.GothamBold; b.TextSize = 10; Instance.new("UICorner", b)
    b.MouseButton1Click:Connect(function() cb(b) end); return b
end

makeBtn("REJOIN SERVER", 45, Rejoin, Color3.fromRGB(0, 150, 100))
makeBtn("TIMER ESP: OFF", 85, function(b) 
    _G.TimerESP = not _G.TimerESP 
    b.Text = "TIMER ESP: " .. (_G.TimerESP and "ON" or "OFF")
end)
makeBtn("FORCE ALLOW FRIENDS: OFF", 125, function(b)
    _G.ForceAllow = not _G.ForceAllow
    b.Text = "FORCE ALLOW: " .. (_G.ForceAllow and "ON" or "OFF")
end)
makeBtn("BASE AUTO-LOCK: OFF", 165, function(b)
    _G.AutoLock = not _G.AutoLock
    b.Text = "AUTO-LOCK: " .. (_G.AutoLock and "ON" or "OFF")
    b.BackgroundColor3 = _G.AutoLock and Color3.fromRGB(200, 0, 50) or Color3.fromRGB(0, 200, 255)
end)

makeBtn("ronaldothegond", 310, function() 
    LocalPlayer:Kick("ronaldothegond saved ur brainrots from getting stolen") 
end, Color3.fromRGB(150, 0, 255))

PlayDing()
Notify("Ronald Hub", "Auto-Lock Enabled!")
