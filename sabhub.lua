-- [[ ronaldothegond real sab hub ]] --
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")
local TeleportService = game:GetService("TeleportService")
local RunService = game:GetService("RunService")
local Workspace = game:GetService("Workspace")

-- // GLOBAL STATE
_G.ESP = false
_G.Xray = false
_G.TimerESP = false
_G.AutoAllow = false
_G.AutoLock = false

-- // 1. UTILITIES
local function Notify(title, text)
    game:GetService("StarterGui"):SetCore("SendNotification", {
        Title = title; Text = text; Duration = 3;
    })
end

-- // 2. TIMER ESP (Fixed Deep Scan)
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
                    end
                end
            end
        end
    end
end)

-- // 3. PLAYER ESP & X-RAY
local function CreateESP(p)
    local h = Instance.new("Highlight")
    h.Name = "ESP_" .. p.Name
    h.FillColor = Color3.fromRGB(0, 220, 255)
    RunService.RenderStepped:Connect(function()
        if _G.ESP and p.Character then h.Parent = p.Character else h.Parent = nil end
    end)
end
for _, p in pairs(Players:GetPlayers()) do if p ~= LocalPlayer then CreateESP(p) end end
Players.PlayerAdded:Connect(CreateESP)

local function ToggleXray()
    _G.Xray = not _G.Xray
    for _, v in pairs(Workspace:GetDescendants()) do
        if v:IsA("BasePart") and not v:IsDescendantOf(LocalPlayer.Character) then
            if _G.Xray then
                if v.Transparency == 0 then v.Transparency = 0.5 v.Name = v.Name .. "_XR" end
            else
                if v.Name:find("_XR") then v.Transparency = 0 v.Name = v.Name:gsub("_XR", "") end
            end
        end
    end
end

-- // 4. BASE AUTOMATION (FORCE OVERRIDE)
RunService.Heartbeat:Connect(function()
    if _G.AutoAllow or _G.AutoLock then
        for _, v in pairs(Workspace:GetDescendants()) do
            -- FORCE ALLOW FRIENDS
            if _G.AutoAllow then
                if v:IsA("BoolValue") and (v.Name:lower():find("allow") or v.Name:lower():find("friend")) then
                    v.Value = true -- Directly force the game setting to true
                elseif v:IsA("ClickDetector") and v.Parent.Name:lower():find("allow") then
                    fireclickdetector(v)
                end
            end
            -- AUTO LOCK
            if _G.AutoLock and v:IsA("ClickDetector") and (v.Parent.Name:lower():find("lock") or v.Parent.Name:lower():find("close")) then
                fireclickdetector(v)
            end
        end
    end
end)

-- // 5. GUI SETUP
if PlayerGui:FindFirstChild("RonaldRealHub") then PlayerGui.RonaldRealHub:Destroy() end
local sg = Instance.new("ScreenGui", PlayerGui); sg.Name = "RonaldRealHub"; sg.ResetOnSpawn = false
local frame = Instance.new("Frame", sg)
frame.Size = UDim2.fromOffset(260, 420); frame.Position = UDim2.fromScale(0.5, 0.5); frame.AnchorPoint = Vector2.new(0.5, 0.5)
frame.BackgroundColor3 = Color3.fromRGB(15, 15, 20); frame.Active, frame.Draggable = true, true
Instance.new("UIStroke", frame).Color = Color3.fromRGB(0, 200, 255); Instance.new("UICorner", frame)

local function makeBtn(txt, y, cb, color)
    local b = Instance.new("TextButton", frame); b.Size = UDim2.new(1, -20, 0, 32); b.Position = UDim2.new(0, 10, 0, y)
    b.BackgroundColor3 = color or Color3.fromRGB(0, 200, 255); b.Text = txt; b.TextColor3 = Color3.new(1,1,1)
    b.Font = Enum.Font.GothamBold; b.TextSize = 10; Instance.new("UICorner", b)
    b.MouseButton1Click:Connect(function() cb(b) end); return b
end

makeBtn("REJOIN SERVER", 50, function() TeleportService:Teleport(game.PlaceId, LocalPlayer) end, Color3.fromRGB(0, 150, 100))
makeBtn("PLAYER ESP: OFF", 95, function(b) _G.ESP = not _G.ESP b.Text = "ESP: " .. (_G.ESP and "ON" or "OFF") end)
makeBtn("X-RAY Walls: OFF", 140, function(b) ToggleXray() b.Text = "X-RAY: " .. (_G.Xray and "ON" or "OFF") end)
makeBtn("TIMER ESP: OFF", 185, function(b) _G.TimerESP = not _G.TimerESP b.Text = "TIMER ESP: " .. (_G.TimerESP and "ON" or "OFF") end)
makeBtn("FORCE ALLOW FRIENDS: OFF", 230, function(b) _G.AutoAllow = not _G.AutoAllow b.Text = "FORCE ALLOW: " .. (_G.AutoAllow and "ON" or "OFF") end)
makeBtn("AUTO-LOCK BASE: OFF", 275, function(b) _G.AutoLock = not _G.AutoLock b.Text = "AUTO-LOCK: " .. (_G.AutoLock and "ON" or "OFF") end)
makeBtn("ronaldothegond", 370, function() LocalPlayer:Kick("ronaldothegond saved ur brainrots from getting stolen") end, Color3.fromRGB(150, 0, 255))

Notify("Ronald Hub", "V102 Fixed & Ready!")
