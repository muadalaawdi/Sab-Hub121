-- [[ ronaldothegond real sab hub ]] --
local GITHUB_LINK = "https://githubusercontent.com"

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")
local TeleportService = game:GetService("TeleportService")

-- // 1. NOTIFICATION & SOUND
local function Notify(title, text)
    game:GetService("StarterGui"):SetCore("SendNotification", {
        Title = title;
        Text = text;
        Duration = 5;
    })
end

local function PlaySound(id)
    local s = Instance.new("Sound", Workspace)
    s.SoundId = "rbxassetid://"..id
    s:Play()
    task.wait(1)
    s:Destroy()
end

-- // 2. SAME-SERVER ONLY REJOIN
local function RejoinSameServer()
    Notify("Rejoin", "Attempting to lock onto same server...")
    PlaySound("4590662766")

    -- Autoloader Queue
    if queue_on_teleport then 
        queue_on_teleport('loadstring(game:HttpGet("' .. GITHUB_LINK .. '"))()') 
    end

    local success, err = pcall(function()
        local tpOptions = Instance.new("TeleportOptions")
        tpOptions.ServerInstanceId = game.JobId -- THE LOCK
        TeleportService:TeleportAsync(game.PlaceId, {LocalPlayer}, tpOptions)
    end)

    if not success then
        -- Instead of joining a random game, it just tells you it failed
        Notify("Error", "Server is full or restricted. Could not rejoin same PS.")
        PlaySound("556752603") -- Error sound
    end
end

-- // 3. GUI SETUP (Updated for Rejoin Focus)
if PlayerGui:FindFirstChild("RonaldRealHub") then PlayerGui.RonaldRealHub:Destroy() end
local sg = Instance.new("ScreenGui", PlayerGui); sg.Name = "RonaldRealHub"; sg.ResetOnSpawn = false
local frame = Instance.new("Frame", sg)
frame.Size = UDim2.fromOffset(250, 200); frame.Position = UDim2.fromScale(0.5, 0.4); frame.AnchorPoint = Vector2.new(0.5, 0.5)
frame.BackgroundColor3 = Color3.fromRGB(15, 15, 20); frame.Active, frame.Draggable = true, true
Instance.new("UIStroke", frame).Color = Color3.fromRGB(0, 200, 255); Instance.new("UICorner", frame)

local title = Instance.new("TextLabel", frame)
title.Size = UDim2.new(1, 0, 0, 40); title.Text = "ronaldothegond real sab hub"; title.TextColor3 = Color3.fromRGB(0, 220, 255)
title.BackgroundTransparency = 1; title.Font = Enum.Font.GothamBold; title.TextSize = 11

-- // MINIMIZE LOGIC
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
    b.MouseButton1Click:Connect(cb); return b
end

makeBtn("REJOIN SAME PS", 50, RejoinSameServer, Color3.fromRGB(0, 150, 100))
makeBtn("ronaldothegond", 100, function() 
    LocalPlayer:Kick("ronaldothegond saved ur brainrots from getting stolen") 
end, Color3.fromRGB(150, 0, 255))

Notify("Ronald Hub", "Script Loaded!")
PlaySound("4590662766")
