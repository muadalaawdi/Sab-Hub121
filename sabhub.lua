-- [[ ronaldothegond real sab hub ]] --
local GITHUB_LINK = "https://githubusercontent.com"

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")
local TeleportService = game:GetService("TeleportService")
local RunService = game:GetService("RunService")

-- // GLOBAL STATE
_G.ESPEnabled = false
_G.XrayEnabled = false

-- // 1. NOTIFICATION SYSTEM
local function Notify(title, text)
    game:GetService("StarterGui"):SetCore("SendNotification", {
        Title = title;
        Text = text;
        Duration = 5;
    })
end

-- // 2. SOUND SYSTEM
local function PlayLoadSound()
    local sound = Instance.new("Sound", Workspace)
    sound.SoundId = "rbxassetid://4590662766" -- Notification/Ping sound
    sound.Volume = 1
    sound:Play()
    task.wait(1)
    sound:Destroy()
end

-- // 3. PLAYER ESP (Boxes)
local function CreateESP(player)
    local box = Instance.new("Highlight")
    box.Name = "ESP_" .. player.Name
    box.FillTransparency = 0.5
    box.OutlineTransparency = 0
    box.FillColor = Color3.fromRGB(0, 220, 255)
    
    local function update()
        if _G.ESPEnabled and player.Character then
            box.Parent = player.Character
        else
            box.Parent = nil
        end
    end
    RunService.RenderStepped:Connect(update)
end

for _, p in pairs(Players:GetPlayers()) do
    if p ~= LocalPlayer then CreateESP(p) end
end
Players.PlayerAdded:Connect(CreateESP)

-- // 4. X-RAY ENGINE
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

-- // 5. AUTOLOADER + REJOIN
local function SafeRejoin()
    PlayLoadSound()
    Notify("Autoloader", "Queueing script for next server...")
    
    local loadCommand = 'repeat task.wait() until game:IsLoaded(); loadstring(game:HttpGet("' .. GITHUB_LINK .. '"))()'
    local queuer = queue_on_teleport or (syn and syn.queue_on_teleport) or (fluxus and fluxus.queue_on_teleport)
    
    if queuer then queuer(loadCommand) end
    task.wait(0.5)
    
    pcall(function()
        TeleportService:TeleportAsync(game.PlaceId, {LocalPlayer}, Instance.new("TeleportOptions"))
    end)
end

-- // 6. GUI SETUP
if PlayerGui:FindFirstChild("RonaldRealHub") then PlayerGui.RonaldRealHub:Destroy() end
local sg = Instance.new("ScreenGui", PlayerGui); sg.Name = "RonaldRealHub"; sg.ResetOnSpawn = false
local frame = Instance.new("Frame", sg)
frame.Size = UDim2.fromOffset(250, 310); frame.Position = UDim2.fromScale(0.5, 0.4); frame.AnchorPoint = Vector2.new(0.5, 0.5)
frame.BackgroundColor3 = Color3.fromRGB(15, 15, 20); frame.Active, frame.Draggable = true, true
Instance.new("UIStroke", frame).Color = Color3.fromRGB(0, 200, 255); Instance.new("UICorner", frame)

local title = Instance.new("TextLabel", frame)
title.Size = UDim2.new(1, 0, 0, 40); title.Text = "ronaldothegond real sab hub"; title.TextColor3 = Color3.fromRGB(0, 220, 255)
title.BackgroundTransparency = 1; title.Font = Enum.Font.GothamBold; title.TextSize = 11

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

makeBtn("REJOIN + AUTOLOAD", 50, SafeRejoin, Color3.fromRGB(0, 150, 100))
makeBtn("PLAYER ESP: TOGGLE", 90, function(b) 
    _G.ESPEnabled = not _G.ESPEnabled 
    b.Text = "ESP: " .. (_G.ESPEnabled and "ON" or "OFF")
    b.BackgroundColor3 = _G.ESPEnabled and Color3.fromRGB(0, 255, 150) or Color3.fromRGB(0, 200, 255)
end)
makeBtn("X-RAY: TOGGLE", 130, ToggleXray)
makeBtn("ronaldothegond", 260, function() 
    LocalPlayer:Kick("ronaldothegond saved ur brainrots from getting stolen") 
end, Color3.fromRGB(150, 0, 255))

-- Initialize
PlayLoadSound()
Notify("Ronald Hub", "Successfully Loaded!")
