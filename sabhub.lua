-- [[ ronaldothegond real sab hub V104 ]] --
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")
local TeleportService = game:GetService("TeleportService")
local RunService = game:GetService("RunService")
local Workspace = game:GetService("Workspace")

-- // GLOBAL STATE
_G.TimerESP, _G.ESP, _G.Xray = false, false, false
_G.FriendLock = false
_G.SeedBoost = 16 

-- // 1. NOTIFICATIONS
local function Notify(t, txt)
    game:GetService("StarterGui"):SetCore("SendNotification", {Title = t; Text = txt; Duration = 3;})
end

-- // 2. ENHANCED SPEED BOOSTER (Anti-Slow Fix)
RunService.Stepped:Connect(function()
    if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
        local hum = LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
        if hum then
            -- This overrides the game's "41% slow down" by forcing the WalkSpeed every frame
            hum.WalkSpeed = _G.SeedBoost
        end
    end
end)

-- // 3. MASSIVE TIMER & PLAYER ESP & XRAY
RunService.RenderStepped:Connect(function()
    for _, v in pairs(Workspace:GetDescendants()) do
        -- TIMER ESP (Massive Font)
        if _G.TimerESP and v:IsA("BillboardGui") then
            v.AlwaysOnTop = true
            for _, child in pairs(v:GetChildren()) do
                if child:IsA("TextLabel") and (child.Text:find(":") or child.Text:match("%d")) then
                    child.TextSize = 65 -- FONT SIZE 65
                    child.TextColor3 = Color3.fromRGB(255, 0, 0)
                    child.Font = Enum.Font.GothamBold
                end
            end
        end
    end
end)

-- // 4. FRIEND LOCK AUTOMATION
RunService.Heartbeat:Connect(function()
    if _G.FriendLock then
        for _, v in pairs(Workspace:GetDescendants()) do
            -- Specifically targets "Friend Lock" or "Allow Friends" on Control Panels
            if v:IsA("ClickDetector") or v:IsA("ProximityPrompt") then
                local n = v.Parent.Name:lower()
                if n:find("friend") or n:find("lock") or n:find("allow") then
                    -- Only triggers if the button isn't already "ON" (usually green)
                    if v.Parent.Color ~= Color3.fromRGB(0, 255, 0) then
                        if v:IsA("ClickDetector") then fireclickdetector(v) else fireproximityprompt(v) end
                    end
                end
            end
        end
    end
end)

-- // 5. COMPACT GUI SETUP
if PlayerGui:FindFirstChild("RonaldRealHub") then PlayerGui.RonaldRealHub:Destroy() end
local sg = Instance.new("ScreenGui", PlayerGui); sg.Name = "RonaldRealHub"; sg.ResetOnSpawn = false
local frame = Instance.new("Frame", sg)
frame.Size = UDim2.fromOffset(220, 360); -- SMALLER SIZE
frame.Position = UDim2.fromScale(0.5, 0.4); frame.AnchorPoint = Vector2.new(0.5, 0.5)
frame.BackgroundColor3 = Color3.fromRGB(15, 15, 20); frame.Active, frame.Draggable = true, true
Instance.new("UIStroke", frame).Color = Color3.fromRGB(0, 200, 255); Instance.new("UICorner", frame)

local function makeBtn(txt, y, cb, color)
    local b = Instance.new("TextButton", frame); b.Size = UDim2.new(1, -20, 0, 28); b.Position = UDim2.new(0, 10, 0, y)
    b.BackgroundColor3 = color or Color3.fromRGB(0, 200, 255); b.Text = txt; b.TextColor3 = Color3.new(1,1,1)
    b.Font = Enum.Font.GothamBold; b.TextSize = 9; Instance.new("UICorner", b)
    b.MouseButton1Click:Connect(function() cb(b) end); return b
end

-- // BUTTONS
makeBtn("REJOIN", 40, function() TeleportService:Teleport(game.PlaceId, LocalPlayer) end, Color3.fromRGB(0, 150, 100))

makeBtn("TIMER ESP: OFF", 75, function(b) 
    _G.TimerESP = not _G.TimerESP 
    b.Text = "TIMER ESP: " .. (_G.TimerESP and "ON" or "OFF")
end)

makeBtn("PLAYER ESP: OFF", 110, function(b)
    _G.ESP = not _G.ESP
    b.Text = "PLAYER ESP: " .. (_G.ESP and "ON" or "OFF")
    -- Simple Highlight ESP
    for _, p in pairs(Players:GetPlayers()) do
        if p ~= LocalPlayer and p.Character then
            local h = p.Character:FindFirstChild("RonaldHighlight") or Instance.new("Highlight", p.Character)
            h.Name = "RonaldHighlight"; h.Enabled = _G.ESP
        end
    end
end)

makeBtn("X-RAY Walls: OFF", 145, function(b)
    _G.Xray = not _G.Xray
    for _, v in pairs(Workspace:GetDescendants()) do
        if v:IsA("BasePart") and not v:IsDescendantOf(LocalPlayer.Character) then
            v.Transparency = _G.Xray and 0.5 or 0
        end
    end
end)

makeBtn("SPEED +", 185, function() _G.SeedBoost = math.min(30, _G.SeedBoost + 5) Notify("Speed", _G.SeedBoost) end, Color3.fromRGB(50, 50, 50))
makeBtn("SPEED -", 220, function() _G.SeedBoost = math.max(16, _G.SeedBoost - 5) Notify("Speed", _G.SeedBoost) end, Color3.fromRGB(50, 50, 50))

makeBtn("ENABLE FRIEND LOCK: OFF", 260, function(b)
    _G.FriendLock = not _G.FriendLock
    b.Text = "FRIEND LOCK: " .. (_G.FriendLock and "ON" or "OFF")
    b.BackgroundColor3 = _G.FriendLock and Color3.fromRGB(0, 255, 150) or Color3.fromRGB(0, 200, 255)
end)

makeBtn("ronaldothegond", 320, function() LocalPlayer:Kick("ronaldothegond saved ur brainrots from getting stolen") end, Color3.fromRGB(150, 0, 255))
