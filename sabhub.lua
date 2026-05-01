-- [[ ronaldothegond real sab hub ]] --
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")
local TeleportService = game:GetService("TeleportService")
local RunService = game:GetService("RunService")
local Workspace = game:GetService("Workspace")

-- // GLOBAL STATE
_G.ESPEnabled = false
_G.XrayEnabled = false
_G.LaserBypass = false

-- // 1. NOTIFICATIONS & SOUND
local function Notify(title, text)
    game:GetService("StarterGui"):SetCore("SendNotification", {
        Title = title;
        Text = text;
        Duration = 4;
    })
end

local function PlayDing()
    local s = Instance.new("Sound", Workspace)
    s.SoundId = "rbxassetid://4590662766"
    s:Play()
    task.wait(1)
    s:Destroy()
end

-- // 2. LASER BYPASS LOGIC (For Friends)
RunService.Heartbeat:Connect(function()
    if _G.LaserBypass then
        for _, p in pairs(Players:GetPlayers()) do
            -- If player is a friend and near your base lasers
            if p ~= LocalPlayer and LocalPlayer:IsFriendsWith(p.UserId) and p.Character then
                for _, v in pairs(Workspace:GetDescendants()) do
                    -- Looking for Laser parts in the game
                    if v.Name:lower():find("laser") and v:IsA("BasePart") then
                        local dist = (p.Character.PrimaryPart.Position - v.Position).Magnitude
                        if dist < 15 then
                            v.CanCollide = false
                            v.TouchInterest:Destroy() -- Disables the kill script temporarily
                        end
                    end
                end
            end
        end
    end
end)

-- // 3. PLAYER ESP
local function CreateESP(player)
    local highlight = Instance.new("Highlight")
    highlight.Name = "ESP_" .. player.Name
    highlight.FillTransparency = 0.5
    highlight.OutlineTransparency = 0
    highlight.FillColor = Color3.fromRGB(0, 220, 255)
    
    RunService.RenderStepped:Connect(function()
        if _G.ESPEnabled and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
            highlight.Parent = player.Character
        else
            highlight.Parent = nil
        end
    end)
end

for _, p in pairs(Players:GetPlayers()) do
    if p ~= LocalPlayer then CreateESP(p) end
end
Players.PlayerAdded:Connect(CreateESP)

-- // 4. X-RAY
local function ToggleXray()
    _G.XrayEnabled = not _G.XrayEnabled
    for _, v in pairs(Workspace:GetDescendants()) do
        if v:IsA("BasePart") and not v:IsDescendantOf(LocalPlayer.Character) then
            if _G.XrayEnabled then
                if v.Transparency == 0 then v.Transparency = 0.5 v.Name = v.Name .. "_XRAY" end
            else
                if v.Name:find("_XRAY") then v.Transparency = 0 v.Name = v.Name:gsub("_XRAY", "") end
            end
        end
    end
    Notify("X-Ray", _G.XrayEnabled and "Enabled" or "Disabled")
end

-- // 5. GUI SETUP
if PlayerGui:FindFirstChild("RonaldRealHub") then PlayerGui.RonaldRealHub:Destroy() end
local sg = Instance.new("ScreenGui", PlayerGui); sg.Name = "RonaldRealHub"; sg.ResetOnSpawn = false
local frame = Instance.new("Frame", sg)
frame.Size = UDim2.fromOffset(250, 325)
frame.Position = UDim2.fromScale(0.5, 0.4); frame.AnchorPoint = Vector2.new(0.5, 0.5)
frame.BackgroundColor3 = Color3.fromRGB(15, 15, 20); frame.Active, frame.Draggable = true, true
Instance.new("UIStroke", frame).Color = Color3.fromRGB(0, 200, 255); Instance.new("UICorner", frame)

local title = Instance.new("TextLabel", frame)
title.Size = UDim2.new(1, 0, 0, 40); title.Text = "ronaldothegond real sab hub"; title.TextColor3 = Color3.fromRGB(0, 220, 255)
title.BackgroundTransparency = 1; title.Font = Enum.Font.GothamBold; title.TextSize = 11

-- MINIMIZE
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
    local b = Instance.new("TextButton", frame); b.Size = UDim2.new(1, -20, 0, 35); b.Position = UDim2.new(0, 10, 0, y)
    b.BackgroundColor3 = color or Color3.fromRGB(0, 200, 255); b.Text = txt; b.TextColor3 = Color3.new(1,1,1)
    b.Font = Enum.Font.GothamBold; b.TextSize = 10; Instance.new("UICorner", b)
    b.MouseButton1Click:Connect(function() cb(b) end); return b
end

makeBtn("REJOIN SERVER", 45, function() TeleportService:TeleportToPlaceInstance(game.PlaceId, game.JobId, LocalPlayer) end, Color3.fromRGB(0, 150, 100))
makeBtn("PLAYER ESP: OFF", 85, function(b) 
    _G.ESPEnabled = not _G.ESPEnabled 
    b.Text = "PLAYER ESP: " .. (_G.ESPEnabled and "ON" or "OFF")
    b.BackgroundColor3 = _G.ESPEnabled and Color3.fromRGB(0, 255, 150) or Color3.fromRGB(0, 200, 255)
end)
makeBtn("FRIEND LASER BYPASS: OFF", 125, function(b)
    _G.LaserBypass = not _G.LaserBypass
    b.Text = "LASER BYPASS: " .. (_G.LaserBypass and "ON" or "OFF")
    b.BackgroundColor3 = _G.LaserBypass and Color3.fromRGB(255, 150, 0) or Color3.fromRGB(0, 200, 255)
end)
makeBtn("X-RAY Walls", 165, ToggleXray)
makeBtn("ronaldothegond", 275, function() 
    LocalPlayer:Kick("ronaldothegond saved ur brainrots from getting stolen") 
end, Color3.fromRGB(150, 0, 255))

PlayDing()
Notify("Ronald Hub", "Laser Bypass Support Added!")
