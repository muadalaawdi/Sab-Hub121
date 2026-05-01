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
    local s = Instance.new("Sound", game.Workspace)
    s.SoundId = "rbxassetid://"..id
    s:Play()
    task.wait(1)
    s:Destroy()
end

-- // 2. PRIVATE SERVER STABLE REJOIN
local function RejoinPrivateServer()
    Notify("Rejoin", "Attempting Private Server Re-entry...")
    PlaySound("4590662766")

    -- Autoloader Queue
    if queue_on_teleport then 
        queue_on_teleport('repeat task.wait() until game:IsLoaded(); loadstring(game:HttpGet("' .. GITHUB_LINK .. '"))()') 
    end

    -- Execution of teleport
    local success, err = pcall(function()
        -- Specifically handles Private Server IDs and JobIds
        TeleportService:TeleportToPlaceInstance(game.PlaceId, game.JobId, LocalPlayer)
    end)

    if not success then
        -- Attempt secondary Private Server method if first fails
        local success2 = pcall(function()
            TeleportService:Teleport(game.PlaceId, LocalPlayer, {game.JobId})
        end)
        
        if not success2 then
            Notify("Error", "PS Access Denied. Check if link is still valid.")
            PlaySound("556752603")
        end
    end
end

-- // 3. GUI SETUP
if PlayerGui:FindFirstChild("RonaldRealHub") then PlayerGui.RonaldRealHub:Destroy() end
local sg = Instance.new("ScreenGui", PlayerGui); sg.Name = "RonaldRealHub"; sg.ResetOnSpawn = false
local frame = Instance.new("Frame", sg)
frame.Size = UDim2.fromOffset(250, 180); frame.Position = UDim2.fromScale(0.5, 0.4); frame.AnchorPoint = Vector2.new(0.5, 0.5)
frame.BackgroundColor3 = Color3.fromRGB(15, 15, 20); frame.Active, frame.Draggable = true, true
Instance.new("UIStroke", frame).Color = Color3.fromRGB(0, 200, 255); Instance.new("UICorner", frame)

local title = Instance.new("TextLabel", frame)
title.Size = UDim2.new(1, 0, 0, 40); title.Text = "ronaldothegond real sab hub"; title.TextColor3 = Color3.fromRGB(0, 220, 255)
title.BackgroundTransparency = 1; title.Font = Enum.Font.GothamBold; title.TextSize = 11

-- MINIMIZE LOGIC
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

makeBtn("REJOIN SAME PS", 50, RejoinPrivateServer, Color3.fromRGB(0, 150, 100))
makeBtn("ronaldothegond", 100, function() 
    LocalPlayer:Kick("ronaldothegond saved ur brainrots from getting stolen") 
end, Color3.fromRGB(150, 0, 255))

Notify("Ronald Hub", "PS Rejoin System Ready!")
PlaySound("4590662766")
