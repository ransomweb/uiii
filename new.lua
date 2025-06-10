local repo = 'https://raw.githubusercontent.com/violin-suzutsuki/LinoriaLib/main/'

local Library = loadstring(game:HttpGet(repo .. 'Library.lua'))()
local ThemeManager = loadstring(game:HttpGet(repo .. 'addons/ThemeManager.lua'))()

-- Apply custom blue theme
ThemeManager.BuiltInThemes['Azurite'] = {9, {
    FontColor = "ffffff",
    MainColor = "1a1a2e",
    AccentColor = "69a0f0",
    BackgroundColor = "141420",
    OutlineColor = "2a2a3a"
}}

local Window = Library:CreateWindow({
    Title = 'Azurite Lite',
    Center = true,
    AutoShow = true,
    TabPadding = 8,
    MenuFadeTime = 0.2
})

ThemeManager:SetLibrary(Library)
ThemeManager:ApplyTheme('Azurite')

-- Services
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local GuiService = game:GetService("GuiService")
local LocalPlayer = Players.LocalPlayer
local Mouse = LocalPlayer:GetMouse()
local Camera = workspace.CurrentCamera
local UserInputService = game:GetService("UserInputService")

-- ESP Settings
local ESP = {
    Enabled = true,
    Boxes = true,
    Names = true,
    Health = true,
    Tools = true,
    Skeletons = true,
    Tracers = true,
    Highlights = true
}

-- Visual Elements
local circle = Drawing.new("Circle")
circle.Color = Color3.fromRGB(105, 160, 225)
circle.Thickness = 1
circle.NumSides = 64
circle.Radius = 100
circle.Transparency = 0.3
circle.Visible = false
circle.Filled = false

local line = Drawing.new("Line")
line.Visible = false
line.Thickness = 1
line.Color = Color3.fromRGB(105, 160, 225)

local dot = Drawing.new("Circle")
dot.Color = Color3.fromRGB(105, 160, 225)
dot.Thickness = 1
dot.NumSides = 12
dot.Radius = 3
dot.Transparency = 0.1
dot.Visible = false
dot.Filled = true

local highlight = Instance.new("Highlight")
highlight.Adornee = nil
highlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
highlight.FillColor = Color3.fromRGB(105, 160, 225)
highlight.FillTransparency = 0.5
highlight.OutlineColor = Color3.fromRGB(255, 255, 255)
highlight.OutlineTransparency = 0
highlight.Parent = game:GetService("CoreGui")

local placemarker = Instance.new("Part", workspace)
placemarker.Anchored = true
placemarker.CanCollide = false
placemarker.Size = Vector3.new(0.3, 0.3, 0.3)
placemarker.Transparency = 1
placemarker.Material = Enum.Material.Neon

local billboard = Instance.new("BillboardGui", placemarker)
billboard.Size = UDim2.new(2, 0, 2, 0)
billboard.AlwaysOnTop = true
local frame = Instance.new("Frame", billboard)
frame.Size = UDim2.new(1, 0, 1, 0)
frame.BackgroundColor3 = Color3.fromRGB(105, 160, 225)
frame.BackgroundTransparency = 0.1
local corner = Instance.new("UICorner", frame)
corner.CornerRadius = UDim.new(1, 1)

-- Target GUI
local targetFrame = Instance.new("ScreenGui", game:GetService("CoreGui"))
targetFrame.Name = "AzuriteTargetGUI"
targetFrame.Enabled = false

local backgroundPattern = Instance.new("ImageLabel", targetFrame)
backgroundPattern.Size = UDim2.new(0, 250, 0, 80)
backgroundPattern.Position = UDim2.new(0.5, -125, 1, -90)
backgroundPattern.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
backgroundPattern.BackgroundTransparency = 0.3
backgroundPattern.Image = "rbxassetid://13099821442" -- Topographic pattern
backgroundPattern.ImageTransparency = 0.7
backgroundPattern.BorderSizePixel = 0

local mainFrame = Instance.new("Frame", backgroundPattern)
mainFrame.Size = UDim2.new(1, 0, 1, 0)
mainFrame.BackgroundTransparency = 1

local gradient = Instance.new("Frame", mainFrame)
gradient.Size = UDim2.new(1, 0, 0, 3)
gradient.Position = UDim2.new(0, 0, 0, 0)
gradient.BackgroundColor3 = Color3.fromRGB(105, 160, 225)
gradient.BorderSizePixel = 0

local uigradient = Instance.new("UIGradient", gradient)
uigradient.Rotation = 90
uigradient.Transparency = NumberSequence.new({
    NumberSequenceKeypoint.new(0, 0),
    NumberSequenceKeypoint.new(1, 1)
})

local avatar = Instance.new("ImageLabel", mainFrame)
avatar.Size = UDim2.new(0, 60, 0, 60)
avatar.Position = UDim2.new(0, 10, 0, 15)
avatar.BackgroundColor3 = Color3.fromRGB(20, 20, 30)
avatar.BorderSizePixel = 0
avatar.BackgroundTransparency = 0.5

local healthBar = Instance.new("Frame", mainFrame)
healthBar.Size = UDim2.new(0, 150, 0, 10)
healthBar.Position = UDim2.new(0, 80, 0, 25)
healthBar.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
healthBar.BorderSizePixel = 0

local healthFill = Instance.new("Frame", healthBar)
healthFill.Size = UDim2.new(1, 0, 1, 0)
healthFill.BackgroundColor3 = Color3.fromRGB(105, 160, 225)
healthFill.BorderSizePixel = 0

local healthText = Instance.new("TextLabel", mainFrame)
healthText.Size = UDim2.new(0, 150, 0, 20)
healthText.Position = UDim2.new(0, 80, 0, 40)
healthText.BackgroundTransparency = 1
healthText.TextColor3 = Color3.fromRGB(255, 255, 255)
healthText.Text = "100% Health"
healthText.Font = Enum.Font.Gotham
healthText.TextSize = 14
healthText.TextXAlignment = Enum.TextXAlignment.Left

local toolText = Instance.new("TextLabel", mainFrame)
toolText.Size = UDim2.new(0, 150, 0, 20)
toolText.Position = UDim2.new(0, 80, 0, 60)
toolText.BackgroundTransparency = 1
toolText.TextColor3 = Color3.fromRGB(200, 200, 200)
toolText.Text = "[Fist]"
toolText.Font = Enum.Font.Gotham
toolText.TextSize = 12
toolText.TextXAlignment = Enum.TextXAlignment.Left

-- Tabs
local Tabs = {
    SilentAim = Window:AddTab('Silent Aim'),
    CamLock = Window:AddTab('Cam Lock'),
    Visuals = Window:AddTab('Visuals'),
    ESP = Window:AddTab('ESP')
}

-- Silent Aim Tab Groups
local SilentAimMain = Tabs.SilentAim:AddLeftGroupbox('Main')
local SilentAimSettings = Tabs.SilentAim:AddRightGroupbox('Settings')

-- Cam Lock Tab Groups
local CamLockMain = Tabs.CamLock:AddLeftGroupbox('Main')
local CamLockSettings = Tabs.CamLock:AddRightGroupbox('Settings')

-- Visuals Tab Groups
local VisualsMain = Tabs.Visuals:AddLeftGroupbox('Main')
local VisualsSettings = Tabs.Visuals:AddRightGroupbox('Settings')

-- ESP Tab Groups
local ESPMain = Tabs.ESP:AddLeftGroupbox('Main')
local ESPSettings = Tabs.ESP:AddRightGroupbox('Settings')

-- Settings
local Settings = {
    SilentAim = {
        Enabled = true,
        Keybind = "Q",
        Prediction = 0.15,
        JumpOffset = 0,
        Hitpart = "HumanoidRootPart",
        JumpHitpart = "HumanoidRootPart",
        AutoAir = false,
        AutoShoot = false,
        ShowStats = true,
        ShowStatsOnTarget = true
    },
    CamLock = {
        Enabled = false,
        Keybind = "E",
        Prediction = 0.15,
        JumpOffset = 0,
        Hitpart = "HumanoidRootPart"
    },
    Visuals = {
        ShowFOV = false,
        FOVFilled = false,
        SpinFOV = false,
        SpinSpeed = 1,
        Dot = true,
        Tracer = true
    }
}

local Target = nil
local TargetLocked = false
local CamLockTarget = nil
local CamLockActive = false

-- Keybind Tools
local silentAimTool = Instance.new("Tool")
silentAimTool.RequiresHandle = false
silentAimTool.Name = "azurite.silent"
silentAimTool.Activated:connect(function()
    local vim = game:GetService("VirtualInputManager")
    vim:SendKeyEvent(true, Settings.SilentAim.Keybind, false, game)
end)
silentAimTool.Parent = LocalPlayer.Backpack

local camLockTool = Instance.new("Tool")
camLockTool.RequiresHandle = false
camLockTool.Name = "azurite.camlock"
camLockTool.Activated:connect(function()
    local vim = game:GetService("VirtualInputManager")
    vim:SendKeyEvent(true, Settings.CamLock.Keybind, false, game)
end)
camLockTool.Parent = LocalPlayer.Backpack

-- Silent Aim UI
SilentAimMain:AddToggle('SilentAimEnabled', {
    Text = 'Enable Silent Aim',
    Default = Settings.SilentAim.Enabled,
    Callback = function(Value)
        Settings.SilentAim.Enabled = Value
    end
})

SilentAimMain:AddLabel('Silent Aim Key'):AddKeyPicker('SilentAimKeybind', {
    Default = Settings.SilentAim.Keybind,
    SyncToggleState = false,
    Mode = 'Toggle',
    Text = 'Silent Aim keybind',
    NoUI = false,
})

Options.SilentAimKeybind:OnChanged(function()
    Settings.SilentAim.Keybind = Options.SilentAimKeybind.Value
    silentAimTool.Name = "azurite."..string.lower(Settings.SilentAim.Keybind)
end)

SilentAimMain:AddInput('PredictionInput', {
    Default = tostring(Settings.SilentAim.Prediction),
    Numeric = true,
    Finished = true,
    Text = 'Prediction',
    Tooltip = 'Prediction value for silent aim',
    Callback = function(Value)
        Settings.SilentAim.Prediction = tonumber(Value) or 0.15
    end
})

SilentAimMain:AddToggle('AutoAirToggle', {
    Text = 'Auto Air',
    Default = Settings.SilentAim.AutoAir,
    Tooltip = 'Automatically activates tool when target jumps',
    Callback = function(Value)
        Settings.SilentAim.AutoAir = Value
    end
})

SilentAimMain:AddToggle('AutoShootToggle', {
    Text = 'Auto Shoot',
    Default = Settings.SilentAim.AutoShoot,
    Tooltip = 'Automatically activates tool when locked',
    Callback = function(Value)
        Settings.SilentAim.AutoShoot = Value
    end
})

SilentAimSettings:AddSlider('JumpOffsetSlider', {
    Text = 'Jump Offset',
    Default = Settings.SilentAim.JumpOffset * 100,
    Min = -100,
    Max = 100,
    Rounding = 2,
    Suffix = '',
    Callback = function(Value)
        Settings.SilentAim.JumpOffset = Value / 100
    end
})

SilentAimSettings:AddDropdown('HitpartDropdown', {
    Values = {'HumanoidRootPart', 'Head', 'UpperTorso', 'LowerTorso', 'LeftFoot', 'RightFoot'},
    Default = 1,
    Multi = false,
    Text = 'Target Hitpart',
    Callback = function(Value)
        Settings.SilentAim.Hitpart = Value
    end
})

SilentAimSettings:AddDropdown('JumpHitpartDropdown', {
    Values = {'HumanoidRootPart', 'Head', 'UpperTorso', 'LowerTorso', 'LeftFoot', 'RightFoot'},
    Default = 1,
    Multi = false,
    Text = 'Jump Hitpart',
    Callback = function(Value)
        Settings.SilentAim.JumpHitpart = Value
    end
})

SilentAimSettings:AddToggle('ShowStatsToggle', {
    Text = 'Show Stats',
    Default = Settings.SilentAim.ShowStats,
    Callback = function(Value)
        Settings.SilentAim.ShowStats = Value
    end
})

SilentAimSettings:AddToggle('ShowStatsOnTargetToggle', {
    Text = 'Stats On Target',
    Default = Settings.SilentAim.ShowStatsOnTarget,
    Callback = function(Value)
        Settings.SilentAim.ShowStatsOnTarget = Value
        targetFrame.Enabled = Value and TargetLocked
    end
})

-- Cam Lock UI
CamLockMain:AddToggle('CamLockEnabled', {
    Text = 'Enable Cam Lock',
    Default = Settings.CamLock.Enabled,
    Callback = function(Value)
        Settings.CamLock.Enabled = Value
    end
})

CamLockMain:AddLabel('Cam Lock Key'):AddKeyPicker('CamLockKeybind', {
    Default = Settings.CamLock.Keybind,
    SyncToggleState = false,
    Mode = 'Toggle',
    Text = 'Cam Lock keybind',
    NoUI = false,
})

Options.CamLockKeybind:OnChanged(function()
    Settings.CamLock.Keybind = Options.CamLockKeybind.Value
    camLockTool.Name = "azurite."..string.lower(Settings.CamLock.Keybind)
end)

CamLockMain:AddInput('CamPredictionInput', {
    Default = tostring(Settings.CamLock.Prediction),
    Numeric = true,
    Finished = true,
    Text = 'Prediction',
    Tooltip = 'Prediction value for cam lock',
    Callback = function(Value)
        Settings.CamLock.Prediction = tonumber(Value) or 0.15
    end
})

CamLockSettings:AddSlider('CamJumpOffsetSlider', {
    Text = 'Jump Offset',
    Default = Settings.CamLock.JumpOffset * 100,
    Min = -100,
    Max = 100,
    Rounding = 2,
    Suffix = '',
    Callback = function(Value)
        Settings.CamLock.JumpOffset = Value / 100
    end
})

CamLockSettings:AddDropdown('CamHitpartDropdown', {
    Values = {'HumanoidRootPart', 'Head', 'UpperTorso', 'LowerTorso', 'LeftFoot', 'RightFoot'},
    Default = 1,
    Multi = false,
    Text = 'Target Hitpart',
    Callback = function(Value)
        Settings.CamLock.Hitpart = Value
    end
})

-- Visuals UI
VisualsMain:AddToggle('ShowFOVToggle', {
    Text = 'Show FOV',
    Default = Settings.Visuals.ShowFOV,
    Callback = function(Value)
        Settings.Visuals.ShowFOV = Value
        circle.Visible = Value
    end
})

VisualsMain:AddToggle('FOVFilledToggle', {
    Text = 'FOV Filled',
    Default = Settings.Visuals.FOVFilled,
    Callback = function(Value)
        Settings.Visuals.FOVFilled = Value
        circle.Filled = Value
    end
})

VisualsMain:AddToggle('SpinFOVToggle', {
    Text = 'Spin FOV',
    Default = Settings.Visuals.SpinFOV,
    Callback = function(Value)
        Settings.Visuals.SpinFOV = Value
    end
})

VisualsMain:AddToggle('DotToggle', {
    Text = 'Show Dot',
    Default = Settings.Visuals.Dot,
    Callback = function(Value)
        Settings.Visuals.Dot = Value
        dot.Visible = Value
    end
})

VisualsMain:AddToggle('TracerToggle', {
    Text = 'Show Tracer',
    Default = Settings.Visuals.Tracer,
    Callback = function(Value)
        Settings.Visuals.Tracer = Value
        line.Visible = Value
    end
})

VisualsSettings:AddSlider('SpinSpeedSlider', {
    Text = 'Spin Speed',
    Default = Settings.Visuals.SpinSpeed * 100,
    Min = 1,
    Max = 500,
    Rounding = 0,
    Suffix = '%',
    Callback = function(Value)
        Settings.Visuals.SpinSpeed = Value / 100
    end
})

VisualsSettings:AddLabel('FOV Color'):AddColorPicker('FOVColorPicker', {
    Default = Color3.fromRGB(105, 160, 225),
    Callback = function(Value)
        circle.Color = Value
    end
})

VisualsSettings:AddLabel('Dot Color'):AddColorPicker('DotColorPicker', {
    Default = Color3.fromRGB(105, 160, 225),
    Callback = function(Value)
        dot.Color = Value
    end
})

VisualsSettings:AddLabel('Tracer Color'):AddColorPicker('TracerColorPicker', {
    Default = Color3.fromRGB(105, 160, 225),
    Callback = function(Value)
        line.Color = Value
    end
})

-- ESP UI
ESPMain:AddToggle('ESPEnabled', {
    Text = 'Enable ESP',
    Default = ESP.Enabled,
    Callback = function(Value)
        ESP.Enabled = Value
    end
})

ESPMain:AddToggle('BoxesToggle', {
    Text = 'Show Boxes',
    Default = ESP.Boxes,
    Callback = function(Value)
        ESP.Boxes = Value
    end
})

ESPMain:AddToggle('NamesToggle', {
    Text = 'Show Names',
    Default = ESP.Names,
    Callback = function(Value)
        ESP.Names = Value
    end
})

ESPMain:AddToggle('HealthToggle', {
    Text = 'Show Health',
    Default = ESP.Health,
    Callback = function(Value)
        ESP.Health = Value
    end
})

ESPSettings:AddToggle('ToolsToggle', {
    Text = 'Show Tools',
    Default = ESP.Tools,
    Callback = function(Value)
        ESP.Tools = Value
    end
})

ESPSettings:AddToggle('SkeletonsToggle', {
    Text = 'Show Skeletons',
    Default = ESP.Skeletons,
    Callback = function(Value)
        ESP.Skeletons = Value
    end
})

ESPSettings:AddToggle('TracersToggle', {
    Text = 'Show Tracers',
    Default = ESP.Tracers,
    Callback = function(Value)
        ESP.Tracers = Value
    end
})

ESPSettings:AddToggle('HighlightsToggle', {
    Text = 'Show Highlights',
    Default = ESP.Highlights,
    Callback = function(Value)
        ESP.Highlights = Value
    end
})

-- Utility
local UtilityGroup = Tabs.Misc:AddLeftGroupbox('Utility')
UtilityGroup:AddButton('Give Silent Aim Tool', function()
    silentAimTool:Clone().Parent = LocalPlayer.Backpack
    Library:Notify("Silent Aim Tool Given", "Bound to: "..Settings.SilentAim.Keybind)
end)

UtilityGroup:AddButton('Give Cam Lock Tool', function()
    camLockTool:Clone().Parent = LocalPlayer.Backpack
    Library:Notify("Cam Lock Tool Given", "Bound to: "..Settings.CamLock.Keybind)
end)

UtilityGroup:AddButton('Unlock All', function()
    Target = nil
    TargetLocked = false
    CamLockTarget = nil
    CamLockActive = false
    highlight.Adornee = nil
    targetFrame.Enabled = false
    Library:Notify("Unlocked All Targets", "")
end)

UtilityGroup:AddLabel('Menu Keybind'):AddKeyPicker('MenuKeybind', { 
    Default = 'RightShift', 
    NoUI = true,
    Text = 'Menu keybind' 
})

Library.ToggleKeybind = Options.MenuKeybind

Library:SetWatermarkVisibility(true)
Library:SetWatermark('Azurite Lite | v1.0.0 | Rewrite by Yufi')

-- Functions
local function getClosestPlayerToCursor()
    local closestPlayer
    local shortestDistance = Settings.Visuals.ShowFOV and circle.Radius or math.huge

    for _, player in pairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild("Humanoid") and 
           player.Character.Humanoid.Health > 0 and player.Character:FindFirstChild("HumanoidRootPart") then
            local pos = Camera:WorldToViewportPoint(player.Character.PrimaryPart.Position)
            local magnitude = (Vector2.new(pos.X, pos.Y) - Vector2.new(Mouse.X, Mouse.Y + GuiService:GetGuiInset().Y).magnitude
            
            if magnitude < shortestDistance then
                closestPlayer = player
                shortestDistance = magnitude
            end
        end
    end
    return closestPlayer
end

local function getHitPart(character, isJumping)
    if isJumping then
        return character:FindFirstChild(Settings.SilentAim.JumpHitpart) or character.PrimaryPart
    else
        return character:FindFirstChild(Settings.SilentAim.Hitpart) or character.PrimaryPart
    end
end

local function updateTargetGUI()
    if Target and Target.Character and Settings.SilentAim.ShowStatsOnTarget and TargetLocked then
        targetFrame.Enabled = true
        
        local humanoid = Target.Character:FindFirstChildOfClass("Humanoid")
        if humanoid then
            local health = math.floor((humanoid.Health / humanoid.MaxHealth) * 100)
            healthFill.Size = UDim2.new(humanoid.Health / humanoid.MaxHealth, 0, 1, 0)
            healthText.Text = health.."% Health"
        end
        
        local tool = Target.Character:FindFirstChildOfClass("Tool")
        toolText.Text = tool and "["..tool.Name.."]" or "[Fist]"
        
        pcall(function()
            avatar.Image = game:GetService("Players"):GetUserThumbnailAsync(Target.UserId, Enum.ThumbnailType.HeadShot, Enum.ThumbnailSize.Size420x420)
        end)
    else
        targetFrame.Enabled = false
    end
end

local spinAngle = 0
local function updateVisuals()
    -- Update FOV circle position
    if Settings.Visuals.SpinFOV then
        spinAngle = spinAngle + (0.01 * Settings.Visuals.SpinSpeed)
        local offset = Vector2.new(math.cos(spinAngle) * 50, math.sin(spinAngle) * 50)
        circle.Position = Vector2.new(Mouse.X, Mouse.Y + GuiService:GetGuiInset().Y) + offset
    else
        circle.Position = Vector2.new(Mouse.X, Mouse.Y + GuiService:GetGuiInset().Y)
    end
    
    -- Update target visuals
    if TargetLocked and Target and Target.Character then
        local hitpart = getHitPart(Target.Character, Target.Character.Humanoid:GetState() == Enum.HumanoidStateType.Jumping)
        if hitpart then
            local predictionValue = Settings.SilentAim.Prediction
            local offset = Vector3.new(0, 0, 0)
            
            if Target.Character.Humanoid:GetState() == Enum.HumanoidStateType.Jumping then
                offset = Vector3.new(0, Settings.SilentAim.JumpOffset, 0)
                
                -- Auto air activation
                if Settings.SilentAim.AutoAir then
                    silentAimTool:Activate()
                end
            end
            
            placemarker.CFrame = CFrame.new(hitpart.Position + (hitpart.Velocity * predictionValue) + offset)
            
            if Settings.Visuals.Tracer then
                local screenPos = Camera:WorldToViewportPoint(hitpart.Position)
                line.From = Vector2.new(Mouse.X, Mouse.Y + GuiService:GetGuiInset().Y)
                line.To = Vector2.new(screenPos.X, screenPos.Y)
            end
            
            if Settings.Visuals.Dot then
                local screenPos = Camera:WorldToViewportPoint(hitpart.Position)
                dot.Position = Vector2.new(screenPos.X, screenPos.Y)
            end
            
            if ESP.Highlights then
                highlight.Adornee = Target.Character
            end
            
            updateTargetGUI()
            
            -- Auto shoot activation
            if Settings.SilentAim.AutoShoot then
                silentAimTool:Activate()
            end
        end
    else
        placemarker.CFrame = CFrame.new(0, 9999, 0)
        line.Visible = false
        dot.Visible = false
        highlight.Adornee = nil
        targetFrame.Enabled = false
    end
    
    -- Update cam lock visuals
    if CamLockActive and CamLockTarget and CamLockTarget.Character then
        local hitpart = CamLockTarget.Character:FindFirstChild(Settings.CamLock.Hitpart) or CamLockTarget.Character.PrimaryPart
        if hitpart then
            local predictionValue = Settings.CamLock.Prediction
            local offset = Vector3.new(0, 0, 0)
            
            if CamLockTarget.Character.Humanoid:GetState() == Enum.HumanoidStateType.Jumping then
                offset = Vector3.new(0, Settings.CamLock.JumpOffset, 0)
            end
            
            Camera.CFrame = CFrame.new(Camera.CFrame.Position, hitpart.Position + (hitpart.Velocity * predictionValue) + offset)
        end
    end
end

-- Keybind handling
UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    
    -- Silent Aim
    if input.KeyCode == Enum.KeyCode[Settings.SilentAim.Keybind] and Settings.SilentAim.Enabled then
        if TargetLocked then
            TargetLocked = false
            Library:Notify("Target Unlocked", "")
        else
            Target = getClosestPlayerToCursor()
            if Target then
                TargetLocked = true
                Library:Notify("Target Locked", "Now targeting: "..Target.Name)
            end
        end
    end
    
    -- Cam Lock
    if input.KeyCode == Enum.KeyCode[Settings.CamLock.Keybind] and Settings.CamLock.Enabled then
        if CamLockActive then
            CamLockActive = false
            Library:Notify("Cam Lock Disabled", "")
        else
            CamLockTarget = getClosestPlayerToCursor()
            if CamLockTarget then
                CamLockActive = true
                Library:Notify("Cam Lock Enabled", "Now locking: "..CamLockTarget.Name)
            end
        end
    end
end)

-- Silent aim hook
local mt = getrawmetatable(game)
local oldNamecall = mt.__namecall
setreadonly(mt, false)

local function modifyArg(arg)
    if typeof(arg) == "table" then
        for key, value in pairs(arg) do
            if typeof(value) == "table" then
                modifyArg(value)
            elseif typeof(value) == "Vector3" then
                if TargetLocked and Target and Target.Character then
                    local hitpart = getHitPart(Target.Character, Target.Character.Humanoid:GetState() == Enum.HumanoidStateType.Jumping)
                    if hitpart then
                        local predictionValue = Settings.SilentAim.Prediction
                        local offset = Vector3.new(0, 0, 0)
                        
                        if Target.Character.Humanoid:GetState() == Enum.HumanoidStateType.Jumping then
                            offset = Vector3.new(0, Settings.SilentAim.JumpOffset, 0)
                        end
                        
                        arg[key] = hitpart.Position + (hitpart.Velocity * predictionValue) + offset
                    end
                end
            end
        end
    elseif typeof(arg) == "Vector3" then
        if TargetLocked and Target and Target.Character then
            local hitpart = getHitPart(Target.Character, Target.Character.Humanoid:GetState() == Enum.HumanoidStateType.Jumping)
            if hitpart then
                local predictionValue = Settings.SilentAim.Prediction
                local offset = Vector3.new(0, 0, 0)
                
                if Target.Character.Humanoid:GetState() == Enum.HumanoidStateType.Jumping then
                    offset = Vector3.new(0, Settings.SilentAim.JumpOffset, 0)
                end
                
                return hitpart.Position + (hitpart.Velocity * predictionValue) + offset
            end
        end
    end
    return arg
end

mt.__namecall = newcclosure(function(self, ...)
    local args = {...}
    local method = getnamecallmethod()

    if TargetLocked and method == "FireServer" then
        for i, arg in ipairs(args) do
            args[i] = modifyArg(arg)
        end
    end

    return oldNamecall(self, unpack(args))
end)

setreadonly(mt, true)

-- ESP Implementation
local espCache = {}

local function createESP(player)
    if espCache[player] then return end
    
    local drawings = {
        Box = Drawing.new("Square"),
        BoxOutline = Drawing.new("Square"),
        Name = Drawing.new("Text"),
        Health = Drawing.new("Text"),
        Tool = Drawing.new("Text"),
        Tracer = Drawing.new("Line")
    }
    
    for _, drawing in pairs(drawings) do
        drawing.Visible = false
        drawing.Color = Color3.new(1, 1, 1)
        drawing.Outline = true
        if drawing:IsA("Text") then
            drawing.Size = 13
            drawing.Font = 2
        elseif drawing:IsA("Square") then
            drawing.Thickness = 1
            drawing.Filled = false
        elseif drawing:IsA("Line") then
            drawing.Thickness = 1
        end
    end
    
    drawings.BoxOutline.Color = Color3.new(0, 0, 0)
    drawings.BoxOutline.Thickness = 3
    
    espCache[player] = {
        Drawings = drawings,
        Highlight = Instance.new("Highlight"),
        Connections = {}
    }
    
    espCache[player].Highlight.FillColor = Color3.fromRGB(105, 160, 225)
    espCache[player].Highlight.OutlineColor = Color3.new(1, 1, 1)
    espCache[player].Highlight.FillTransparency = 0.5
    espCache[player].Highlight.OutlineTransparency = 0
    espCache[player].Highlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
    espCache[player].Highlight.Enabled = ESP.Highlights
    
    local function characterAdded(character)
        if character then
            espCache[player].Highlight.Adornee = character
            
            local humanoid = character:WaitForChild("Humanoid")
            local rootPart = character:WaitForChild("HumanoidRootPart")
            
            espCache[player].Connections["HumanoidDied"] = humanoid.Died:Connect(function()
                for _, drawing in pairs(espCache[player].Drawings) do
                    drawing.Visible = false
                end
                espCache[player].Highlight.Enabled = false
            end)
            
            espCache[player].Connections["RenderStepped"] = RunService.RenderStepped:Connect(function()
                if not character or not character.Parent or not rootPart or not humanoid or humanoid.Health <= 0 then
                    for _, drawing in pairs(espCache[player].Drawings) do
                        drawing.Visible = false
                    end
                    espCache[player].Highlight.Enabled = false
                    return
                end
                
                local head = character:FindFirstChild("Head")
                if not head then return end
                
                local headPos, headVis = Camera:WorldToViewportPoint(head.Position)
                local rootPos, rootVis = Camera:WorldToViewportPoint(rootPart.Position)
                
                if headVis and rootVis then
                    local size = (headPos - rootPos).Magnitude
                    local boxPos = Vector2.new(rootPos.X - size/2, rootPos.Y - size/2)
                    local boxSize = Vector2.new(size, size * 1.5)
                    
                    -- Box
                    espCache[player].Drawings.Box.Size = boxSize
                    espCache[player].Drawings.Box.Position = boxPos
                    espCache[player].Drawings.Box.Visible = ESP.Boxes
                    
                    -- Box Outline
                    espCache[player].Drawings.BoxOutline.Size = boxSize
                    espCache[player].Drawings.BoxOutline.Position = boxPos
                    espCache[player].Drawings.BoxOutline.Visible = ESP.Boxes
                    
                    -- Name
                    espCache[player].Drawings.Name.Text = player.Name
                    espCache[player].Drawings.Name.Position = Vector2.new(boxPos.X + boxSize.X/2, boxPos.Y - 20)
                    espCache[player].Drawings.Name.Visible = ESP.Names
                    
                    -- Health
                    espCache[player].Drawings.Health.Text = math.floor(humanoid.Health).."/"..math.floor(humanoid.MaxHealth)
                    espCache[player].Drawings.Health.Position = Vector2.new(boxPos.X + boxSize.X/2, boxPos.Y + boxSize.Y + 5)
                    espCache[player].Drawings.Health.Visible = ESP.Health
                    
                    -- Tool
                    local tool = character:FindFirstChildOfClass("Tool")
                    espCache[player].Drawings.Tool.Text = tool and "["..tool.Name.."]" or "[Fist]"
                    espCache[player].Drawings.Tool.Position = Vector2.new(boxPos.X + boxSize.X/2, boxPos.Y + boxSize.Y + 20)
                    espCache[player].Drawings.Tool.Visible = ESP.Tools
                    
                    -- Tracer
                    espCache[player].Drawings.Tracer.From = Vector2.new(Camera.ViewportSize.X/2, Camera.ViewportSize.Y)
                    espCache[player].Drawings.Tracer.To = Vector2.new(rootPos.X, rootPos.Y)
                    espCache[player].Drawings.Tracer.Visible = ESP.Tracers
                    
                    -- Highlight
                    espCache[player].Highlight.Enabled = ESP.Highlights
                else
                    for _, drawing in pairs(espCache[player].Drawings) do
                        drawing.Visible = false
                    end
                    espCache[player].Highlight.Enabled = false
                end
            end)
        end
    end
    
    if player.Character then
        characterAdded(player.Character)
    end
    
    espCache[player].Connections["CharacterAdded"] = player.CharacterAdded:Connect(characterAdded)
end

local function removeESP(player)
    if not espCache[player] then return end
    
    for _, conn in pairs(espCache[player].Connections) do
        conn:Disconnect()
    end
    
    for _, drawing in pairs(espCache[player].Drawings) do
        drawing:Remove()
    end
    
    espCache[player].Highlight:Destroy()
    espCache[player] = nil
end

-- Initialize ESP for existing players
for _, player in ipairs(Players:GetPlayers()) do
    if player ~= LocalPlayer then
        createESP(player)
    end
end

-- Connect player events
Players.PlayerAdded:Connect(function(player)
    if player ~= LocalPlayer then
        createESP(player)
    end
end)

Players.PlayerRemoving:Connect(function(player)
    removeESP(player)
end)

-- Main loop
RunService.RenderStepped:Connect(updateVisuals)

Library:Notify("Azurite Lite Loaded", "Press "..Settings.SilentAim.Keybind.." for Silent Aim | "..Settings.CamLock.Keybind.." for Cam Lock")

-- Adonis bypass
loadstring(game:HttpGet("https://raw.githubusercontent.com/Pixeluted/adoniscries/main/Source.lua",true))()
