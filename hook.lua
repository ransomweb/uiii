loadstring([[
    function LPH_NO_VIRTUALIZE(f) return f end;
]])();

local Players = game:GetService("Players")
local CoreGui = game:GetService("CoreGui")
local RunService = game:GetService("RunService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local UserInputService = game:GetService("UserInputService")
local LocalPlayer = Players.LocalPlayer

-- Default settings
getgenv().Rake = {
    Settings = {
        Prediction = 0.04,
        JumpOffSet = 0.06,
        Keybind = Enum.KeyCode.Q,
        AimPart = "Head",
        HighlightColor = Color3.new(0.411765, 0.501961, 1.000000),
        Misc = {
            ForceHit = true,
            AutoReload = false,
            AutoClicker = false,
            Whitelist = false
        },
        Resolver = false,
        AntiGroundShots = false,
        Enabled = false
    }
}

local Plr, ClosestPart = nil, nil
local whitelist = {"","","",""}

-- UI Library Setup
local m_thread = task
do
    setreadonly(m_thread, false)
    function m_thread.spawn_loop(p_time, p_callback)
        m_thread.spawn(function()
            while true do
                p_callback()
                m_thread.wait(p_time)
            end
        end)
    end
    setreadonly(m_thread, true)
end

local library, pointers = loadstring(game:HttpGet("https://pastebin.com/raw/Q43KL2RS"))()

local window = library:New({
    name = "hook.lua", 
    size = Vector2.new(555, 610), 
    Accent = Color3.fromRGB(192, 118, 227)
})

-- Main Pages
local legit_page = window:Page({name = "Aimbot", size = 80})
local visuals_page = window:Page({name = "Visuals", size = 80})
local settings_page = window:Page({name = "Settings", side = "Left", size = 110})

-- Aimbot Sections
local aimbot_main = legit_page:Section({name = "Main", side = "Left"})
local aimbot_hitpart = legit_page:Section({name = "Hitpart", side = "Right"})

-- Visuals Sections
local highlight_visuals = visuals_page:Section({name = "Highlight", side = "Left"})

-- Settings Sections
local config_section = settings_page:Section({name = "Configuration", side = "Left"})
local menu_section = settings_page:Section({name = "Menu"})
local other_section = settings_page:Section({name = "Other", side = "Right"})
local themes_section = settings_page:Section({name = "Themes", side = "Right"})

-- UI Elements
-- Keybind
aimbot_main:Keybind({
    pointer = "aimbot/keybind",
    name = "Aimbot Keybind",
    default = Enum.KeyCode.Q,
    callback = function(state)
        getgenv().Rake.Settings.Keybind = state
    end
})

-- Prediction
aimbot_main:Textbox({
    pointer = "aimbot/prediction",
    name = "Prediction",
    placeholder = "0.04",
    middle = true,
    reset_on_focus = false,
    callback = function(text)
        getgenv().Rake.Settings.Prediction = tonumber(text) or 0.04
    end
})

-- Jump Offset
aimbot_main:Textbox({
    pointer = "aimbot/jumpoffset",
    name = "Jump Offset",
    placeholder = "0.06",
    middle = true,
    reset_on_focus = false,
    callback = function(text)
        getgenv().Rake.Settings.JumpOffSet = tonumber(text) or 0.06
    end
})

-- Force Hit
aimbot_main:Toggle({
    pointer = "aimbot/forcehit",
    name = "Force Hit",
    default = true,
    callback = function(state)
        getgenv().Rake.Settings.Misc.ForceHit = state
    end
})

-- Hitpart Dropdown
local hitparts = {"Head", "HumanoidRootPart", "UpperTorso", "LowerTorso", "LeftHand", "RightHand", "LeftFoot", "RightFoot"}
aimbot_hitpart:Dropdown({
    pointer = "aimbot/hitpart",
    name = "Hitpart",
    options = hitparts,
    default = "Head",
    callback = function(option)
        getgenv().Rake.Settings.AimPart = option
    end
})

-- Highlight Color
highlight_visuals:Colorpicker({
    pointer = "visuals/highlightcolor",
    name = "Highlight Color",
    default = Color3.new(0.411765, 0.501961, 1.000000),
    callback = function(color)
        getgenv().Rake.Settings.HighlightColor = color
    end
})

-- Anti Ground Shots
aimbot_main:Toggle({
    pointer = "aimbot/antiground",
    name = "Anti Ground Shots",
    default = false,
    callback = function(state)
        getgenv().Rake.Settings.AntiGroundShots = state
    end
})

-- Resolver
aimbot_main:Toggle({
    pointer = "aimbot/resolver",
    name = "Resolver",
    default = false,
    callback = function(state)
        getgenv().Rake.Settings.Resolver = state
    end
})

-- Menu Settings
menu_section:Keybind({
    pointer = "settings/menu/bind",
    name = "Menu Keybind",
    default = Enum.KeyCode.RightControl,
    callback = function(state)
        window.uibind = state
    end
})

menu_section:Toggle({
    pointer = "settings/menu/cursor",
    name = "Cursor",
    default = true,
    callback = function(state)
        UserInputService.MouseIconEnabled = state
    end
})

-- Functions
local function AntiGround(Velocity)
    return math.clamp(Velocity.Y * getgenv().Rake.Settings.Prediction, 0.15, math.huge)
end

local function findNearestEnemy()
    local LocalPlayer = game.Players.LocalPlayer
    local ClosestDistance, ClosestPlayer, ClosestPart = math.huge, nil, nil
    for _, Player in pairs(game.Players:GetPlayers()) do
        if Player ~= LocalPlayer then
            local Character = Player.Character
            if Character and Character:FindFirstChild("Humanoid") and Character.Humanoid.Health > 0 then
                local Part = Character:FindFirstChild(getgenv().Rake.Settings.AimPart)
                if Part then
                    local Position = game:GetService("Workspace").CurrentCamera:WorldToViewportPoint(Part.Position)
                    if Position then
                        local Distance = (LocalPlayer.Character[getgenv().Rake.Settings.AimPart].Position - Part.Position).Magnitude
                        if Distance < ClosestDistance then
                            ClosestPlayer = Player
                            ClosestPart = Part
                            ClosestDistance = Distance
                        end
                    end
                end
            end
        end
    end
    return ClosestPlayer, ClosestPart
end

local function highlight(plr)
    if plr and plr.Character then
        for _, player in pairs(game.Players:GetPlayers()) do
            if player.Character then
                for _, obj in pairs(player.Character:GetChildren()) do
                    if obj:IsA("Highlight") then
                        obj:Destroy()
                    end
                end
            end
        end
        for _, obj in pairs(plr.Character:GetChildren()) do
            if obj:IsA("Highlight") then
                obj:Destroy()
            end
        end
        local highlight = Instance.new("Highlight")
        highlight.Parent = plr.Character
        highlight.FillColor = getgenv().Rake.Settings.HighlightColor
        highlight.OutlineColor = Color3.new(0.031373, 0.031373, 0.031373)
        highlight.FillTransparency = 0.6
        highlight.OutlineTransparency = 0
    end
end

-- Keybind connection
UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if not gameProcessed and input.KeyCode == getgenv().Rake.Settings.Keybind then
        getgenv().Rake.Settings.Enabled = not getgenv().Rake.Settings.Enabled
        if getgenv().Rake.Settings.Enabled then
            Plr, ClosestPart = findNearestEnemy()
            highlight(Plr)
        else
            if Plr and Plr.Character then
                for _, obj in pairs(Plr.Character:GetChildren()) do
                    if obj:IsA("Highlight") then
                        obj:Destroy()
                    end
                end
            end
            Plr, ClosestPart = nil, nil
        end
    end
end)

-- Main loop
RunService.Heartbeat:Connect(function()
    if getgenv().Rake.Settings.Enabled and Plr and Plr.Character and Plr.Character:FindFirstChild(getgenv().Rake.Settings.AimPart) then
        if getgenv().Rake.Settings.Misc.ForceHit then
            local target = Plr.Character[getgenv().Rake.Settings.AimPart]
            local LocalPlayer = Players.LocalPlayer
            local CurrentPosition = LocalPlayer.Character.HumanoidRootPart.Position
            local ShootDirection = LocalPlayer.Character.HumanoidRootPart.CFrame.LookVector
            local ShootPosition = CurrentPosition + ShootDirection * 10
            local Normal = ShootDirection.unit
            local Offset = Normal * 0.5

            local Args = {
                [1] = "Shoot",
                [2] = {
                    [1] = {
                        [1] = {
                            ["Instance"] = target,
                            ["Normal"] = Normal,
                            ["Position"] = CurrentPosition
                        }
                    },
                    [2] = {
                        [1] = {
                            ["thePart"] = target,
                            ["theOffset"] = CFrame.new(Offset)
                        }
                    },
                    [3] = ShootPosition,
                    [4] = CurrentPosition,
                    [5] = tick()
                }
            }

            ReplicatedStorage.MainEvent:FireServer(unpack(Args))
        end
    end
end)

-- Mouse hook
local mt = getrawmetatable(game)
local old = mt.__index
setreadonly(mt, false)

mt.__index = newcclosure(function(self, key)
    if not checkcaller() and getgenv().Rake.Settings.Enabled and typeof(self) == "Instance" and self:IsA("Mouse") and key == "Hit" then
        if Plr and Plr.Character and Plr.Character:FindFirstChild(getgenv().Rake.Settings.AimPart) then
            local target = Plr.Character[getgenv().Rake.Settings.AimPart]
            local Position = target.Position + (Plr.Character.Head.Velocity * getgenv().Rake.Settings.Prediction)
            if getgenv().Rake.Settings.AntiGroundShots then
                Position = Position + Vector3.new(0, AntiGround(Plr.Character.Head.Velocity), 0)
            end
            return CFrame.new(Position)
        end
    end
    return old(self, key)
end)

-- Initialize UI
window.uibind = Enum.KeyCode.RightControl
window:Initialize()
