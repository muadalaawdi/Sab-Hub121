-- [[ ronaldothegond real sab hub ]] --
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")
local TeleportService = game:GetService("TeleportService")
local RunService = game:GetService("RunService")
local Workspace = game:GetService("Workspace")

-- // GLOBAL STATE
_G.TimerESP = false
_G.AutoAllow = false
_G.SeedBoost = 16 -- Default walkspeed

-- // 1. NOTIFICATIONS
local function Notify(title, text)
    game:GetService("StarterGui"):SetCore("SendNotification", {
        Title = title; Text = text; Duration = 4;
    })
end

-- // 2. BIG TIMER ESP (Enhanced Visibility)
RunService.RenderStepped:Connect(function()
    if _G.TimerESP then
        for _, v in pairs(Workspace:GetDescendants()) do
            if v:IsA("BillboardGui") then
                v.AlwaysOnTop = true
                v.Size = UDim2.new(0, 100, 0, 50) -- Bigger box
                v.ExtentsOffset = Vector3.new(0, 3, 0) -- Higher up
                for _, child in pairs(v:GetChildren()) do
                    if child:IsA("TextLabel") and (child.Text:find(":") or child.Text:match("%d")) then
                        child.Visible = true
                        child.TextColor3 = Color3.fromRGB(255, 0, 0) -- Neon Red
                        child.TextStrokeTransparency = 0 -- Black outline
                        child.TextSize = 25 -- Massive font
                        child.Font = Enum.Font.GothamBold
                    end
                end
            end
        end
    end
    -- Apply Speed Boost
    if LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid") then
        LocalPlayer.Character:FindFirstChildOfClass("Humanoid").WalkSpeed = _G.SeedBoost
    end
end)

-- // 3. SMART ALLOW BUTTON (Base Settings Bypass)
RunService.Heartbeat:Connect(function()
    if _G.AutoAllow then
        for _, v in pairs(Workspace:GetDescendants()) do
            if v:IsA("ClickDetector") or v:IsA("ProximityPrompt") then
                local n = v.Parent.Name:lower()
                -- Targets "Allow", "Whitelist", or "Access" buttons
                if n:find("allow") or n:find("friend") or n:find("access") then
                    if v:IsA("ClickDetector") then fireclickdetector(v) else fireproximityprompt(v) end
                end
            end
        end
    end
end)

-- // 4. GUI SETUP
if PlayerGui:FindFirstChild("RonaldRealHub") then PlayerGui.RonaldRealHub:Destroy() end
local sg = Instance.new("ScreenGui", PlayerGui); sg.Name = "RonaldRealHub"; sg.ResetOnSpawn = false
local frame = Instance.new("Frame", sg)
frame.Size = UDim2.fromOffset(260, 380); frame.Position = UDim2.fromScale(0.5, 0.4); frame.AnchorPoint = Vector2.new(0.5, 0.5)
frame.BackgroundColor3 = Color3.fromRGB(15, 15, 20); frame.Active, frame.Draggable = true, true
Instance.new("UIStroke", frame).Color = Color3.fromRGB(0, 200, 255); Instance.new("UICorner", frame)

local title = Instance.new("TextLabel", frame)
title.Size = UDim2.new(1, 0, 0, 40); title.Text = "ronaldothegond real sab hub V103"; title.TextColor3 = Color3.fromRGB(0, 220, 255)
title.BackgroundTransparency = 1; title.Font = Enum.Font.GothamBold; title.TextSize = 11

local function makeBtn(txt, y, cb, color)
    local b = Instance.new("TextButton", frame); b.Size = UDim2.new(1, -20, 0, 35); b.Position = UDim2.new(0, 10, 0, y)
    b.BackgroundColor3 = color or Color3.fromRGB(0, 200, 255); b.Text = txt; b.TextColor3 = Color3.new(1,1,1)
    b.Font = Enum.Font.GothamBold; b.TextSize = 10; Instance.new("UICorner", b)
    b.MouseButton1Click:Connect(function() cb(b) end); return b
end

-- // FEATURES
makeBtn("REJOIN SERVER", 45, function() TeleportService:Teleport(game.PlaceId, LocalPlayer) end, Color3.fromRGB(0, 150, 100))

makeBtn("BIG TIMER ESP: OFF", 90, function(b) 
    _G.TimerESP = not _G.TimerESP 
    b.Text = "TIMER ESP: " .. (_G.TimerESP and "ON" or "OFF")
    b.BackgroundColor3 = _G.TimerESP and Color3.fromRGB(0, 255, 150) or Color3.fromRGB(0, 200, 255)
end)

-- Seed Booster (Speed) Slider replacements
local speedLabel = Instance.new("TextLabel", frame)
speedLabel.Size = UDim2.new(1, 0, 0, 20); speedLabel.Position = UDim2.new(0, 0, 0, 135)
speedLabel.Text = "SEED BOOSTER: 16"; speedLabel.TextColor3 = Color3.new(1,1,1); speedLabel.BackgroundTransparency = 1; speedLabel.Font = Enum.Font.Gotham; speedLabel.TextSize = 10

makeBtn("BOOST SPEED (+)", 160, function() _G.SeedBoost = math.min(30, _G.SeedBoost + 2) speedLabel.Text = "SEED BOOSTER: ".._G.SeedBoost end, Color3.fromRGB(50, 50, 50))
makeBtn("LOWER SPEED (-)", 200, function() _G.SeedBoost = math.max(0, _G.SeedBoost - 2) speedLabel.Text = "SEED BOOSTER: ".._G.SeedBoost end, Color3.fromRGB(50, 50, 50))

makeBtn("AUTO-ALLOW FRIENDS: OFF", 245, function(b)
    _G.AutoAllow = not _G.AutoAllow
    b.Text = "AUTO-ALLOW: " .. (_G.AutoAllow and "ON" or "OFF")
    b.BackgroundColor3 = _G.AutoAllow and Color3.fromRGB(255, 150, 0) or Color3.fromRGB(0, 200, 255)
end)

makeBtn("ronaldothegond", 330, function() 
    LocalPlayer:Kick("ronaldothegond saved ur brainrots from getting stolen") 
end, Color3.fromRGB(150, 0, 255))

Notify("Ronald Hub", "V103 - Speed & Timer Loaded!")
