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

-- Visual Elements
local circle = Drawing.new("Circle")
circle.Color = Color3.fromRGB(105, 160, 225)
circle.Thickness = 1
circle.NumSides = 64
circle.Radius = 100
circle.Transparency = 0.7
circle.Visible = false
circle.Filled = false

local line = Drawing.new("Line")
line.Visible = false
line.Thickness = 1
line.Color = Color3.fromRGB(105, 160, 225)

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
placemarker.Size = Vector3.new(0.5, 0.5, 0.5)
placemarker.Transparency = 1
placemarker.Material = Enum.Material.Neon

local billboard = Instance.new("BillboardGui", placemarker)
billboard.Size = UDim2.new(2, 0, 2, 0)
billboard.AlwaysOnTop = true
local frame = Instance.new("Frame", billboard)
frame.Size = UDim2.new(1, 0, 1, 0)
frame.BackgroundColor3 = Color3.fromRGB(105, 160, 225)
frame.BackgroundTransparency = 0.7
local corner = Instance.new("UICorner", frame)
corner.CornerRadius = UDim.new(1, 1)

-- Target GUI
local targetFrame = Instance.new("ScreenGui", game:GetService("CoreGui"))
targetFrame.Name = "AzuriteTargetGUI"
targetFrame.Enabled = false

local mainFrame = Instance.new("Frame", targetFrame)
mainFrame.Size = UDim2.new(0, 250, 0, 80)
mainFrame.Position = UDim2.new(0.5, -125, 0, 10)
mainFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
mainFrame.BackgroundTransparency = 0.3
mainFrame.BorderSizePixel = 0

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
    Aimbot = Window:AddTab('Aimbot'),
    Visuals = Window:AddTab('Visuals'),
    Misc = Window:AddTab('Miscellaneous')
}

-- Aimbot Tab Groups
local AimMainGroup = Tabs.Aimbot:AddLeftGroupbox('Main')
local AimPredictionGroup = Tabs.Aimbot:AddRightGroupbox('Prediction')

-- Visuals Tab Groups
local FOVGroup = Tabs.Visuals:AddLeftGroupbox('Field of View')
local IndicatorGroup = Tabs.Visuals:AddRightGroupbox('Indicators')

-- Misc Tab Groups
local ToolGroup = Tabs.Misc:AddLeftGroupbox('Tools')
local UtilityGroup = Tabs.Misc:AddRightGroupbox('Utility')

-- Settings
local Settings = {
    Enabled = true,
    SilentAimKey = "Q",
    ResolverKey = "E",
    Airshot = true,
    Notifications = true,
    AutoPrediction = false,
    FOV = 100,
    ShowFOV = false,
    Resolver = false,
    Dot = true,
    Line = true,
    Highlight = true,
    Prediction = 0.15,
    JumpPrediction = 0.18,
    JumpOffset = 0,
    HighlightFill = Color3.fromRGB(105, 160, 225),
    HighlightOutline = Color3.fromRGB(255, 255, 255),
    HighlightFillTrans = 0.5,
    HighlightOutlineTrans = 0,
    TargetGUI = true
}

local Parts = {
    Default = "HumanoidRootPart",
    Jumping = "HumanoidRootPart"
}

local Target = nil
local TargetLocked = false
local ResolverActive = false

-- Keybind Tools
local silentAimTool = Instance.new("Tool")
silentAimTool.RequiresHandle = false
silentAimTool.Name = "azurite.silent"
silentAimTool.Activated:connect(function()
    local vim = game:GetService("VirtualInputManager")
    vim:SendKeyEvent(true, Settings.SilentAimKey, false, game)
end)
silentAimTool.Parent = LocalPlayer.Backpack

local resolverTool = Instance.new("Tool")
resolverTool.RequiresHandle = false
resolverTool.Name = "azurite.resolver"
resolverTool.Activated:connect(function()
    local vim = game:GetService("VirtualInputManager")
    vim:SendKeyEvent(true, Settings.ResolverKey, false, game)
end)
resolverTool.Parent = LocalPlayer.Backpack

-- Aimbot Main Settings
AimMainGroup:AddToggle('AimbotEnabled', {
    Text = 'Enable Aimbot',
    Default = Settings.Enabled,
    Callback = function(Value)
        Settings.Enabled = Value
    end
})

AimMainGroup:AddToggle('AirshotToggle', {
    Text = 'Airshot Prediction',
    Default = Settings.Airshot,
    Callback = function(Value)
        Settings.Airshot = Value
    end
})

AimMainGroup:AddLabel('Silent Aim Key'):AddKeyPicker('SilentAimKeybind', {
    Default = Settings.SilentAimKey,
    SyncToggleState = false,
    Mode = 'Toggle',
    Text = 'Silent Aim keybind',
    NoUI = false,
})

Options.SilentAimKeybind:OnChanged(function()
    Settings.SilentAimKey = Options.SilentAimKeybind.Value
    silentAimTool.Name = "azurite."..string.lower(Settings.SilentAimKey)
end)

AimMainGroup:AddLabel('Resolver Key'):AddKeyPicker('ResolverKeybind', {
    Default = Settings.ResolverKey,
    SyncToggleState = false,
    Mode = 'Toggle',
    Text = 'Resolver keybind',
    NoUI = false,
})

Options.ResolverKeybind:OnChanged(function()
    Settings.ResolverKey = Options.ResolverKeybind.Value
    resolverTool.Name = "azurite."..string.lower(Settings.ResolverKey)
end)

-- Prediction Settings
AimPredictionGroup:AddSlider('PredictionSlider', {
    Text = 'Prediction',
    Default = Settings.Prediction * 100,
    Min = 0,
    Max = 30,
    Rounding = 1,
    Suffix = '%',
    Callback = function(Value)
        Settings.Prediction = Value / 100
    end
})

AimPredictionGroup:AddSlider('JumpPredictionSlider', {
    Text = 'Jump Prediction',
    Default = Settings.JumpPrediction * 100,
    Min = 0,
    Max = 30,
    Rounding = 1,
    Suffix = '%',
    Callback = function(Value)
        Settings.JumpPrediction = Value / 100
    end
})

AimPredictionGroup:AddSlider('JumpOffsetSlider', {
    Text = 'Jump Offset',
    Default = Settings.JumpOffset * 100,
    Min = -100,
    Max = 100,
    Rounding = 2,
    Suffix = '',
    Callback = function(Value)
        Settings.JumpOffset = Value / 100
    end
})

AimPredictionGroup:AddDropdown('HitpartDropdown', {
    Values = {'HumanoidRootPart', 'Head', 'UpperTorso', 'LowerTorso', 'LeftFoot', 'RightFoot'},
    Default = 1,
    Multi = false,
    Text = 'Default Hitpart',
    Callback = function(Value)
        Parts.Default = Value
    end
})

AimPredictionGroup:AddDropdown('JumpHitpartDropdown', {
    Values = {'HumanoidRootPart', 'Head', 'UpperTorso', 'LowerTorso', 'LeftFoot', 'RightFoot'},
    Default = 1,
    Multi = false,
    Text = 'Jumping Hitpart',
    Callback = function(Value)
        Parts.Jumping = Value
    end
})

-- FOV Settings
FOVGroup:AddToggle('ShowFOVToggle', {
    Text = 'Show FOV Circle',
    Default = Settings.ShowFOV,
    Callback = function(Value)
        Settings.ShowFOV = Value
        circle.Visible = Value
    end
})

FOVGroup:AddSlider('FOVSlider', {
    Text = 'FOV Size',
    Default = Settings.FOV,
    Min = 10,
    Max = 1000,
    Rounding = 0,
    Suffix = 'px',
    Callback = function(Value)
        Settings.FOV = Value
        circle.Radius = Value
    end
})

FOVGroup:AddLabel('FOV Color'):AddColorPicker('FOVColorPicker', {
    Default = Color3.fromRGB(105, 160, 225),
    Callback = function(Value)
        circle.Color = Value
    end
})

-- Visual Indicators
IndicatorGroup:AddToggle('DotToggle', {
    Text = 'Show Target Dot',
    Default = Settings.Dot,
    Callback = function(Value)
        Settings.Dot = Value
        billboard.Enabled = Value
    end
})

IndicatorGroup:AddToggle('LineToggle', {
    Text = 'Show Target Line',
    Default = Settings.Line,
    Callback = function(Value)
        Settings.Line = Value
        line.Visible = Value
    end
})

IndicatorGroup:AddLabel('Line Color'):AddColorPicker('LineColorPicker', {
    Default = Color3.fromRGB(105, 160, 225),
    Callback = function(Value)
        line.Color = Value
    end
})

IndicatorGroup:AddToggle('HighlightToggle', {
    Text = 'Show Highlight',
    Default = Settings.Highlight,
    Callback = function(Value)
        Settings.Highlight = Value
        highlight.Enabled = Value
    end
})

IndicatorGroup:AddLabel('Highlight Fill'):AddColorPicker('HighlightFillPicker', {
    Default = Settings.HighlightFill,
    Callback = function(Value)
        Settings.HighlightFill = Value
        highlight.FillColor = Value
    end
})

IndicatorGroup:AddLabel('Highlight Outline'):AddColorPicker('HighlightOutlinePicker', {
    Default = Settings.HighlightOutline,
    Callback = function(Value)
        Settings.HighlightOutline = Value
        highlight.OutlineColor = Value
    end
})

IndicatorGroup:AddSlider('HighlightFillTransSlider', {
    Text = 'Fill Transparency',
    Default = Settings.HighlightFillTrans * 100,
    Min = 0,
    Max = 100,
    Rounding = 0,
    Suffix = '%',
    Callback = function(Value)
        Settings.HighlightFillTrans = Value / 100
        highlight.FillTransparency = Value / 100
    end
})

IndicatorGroup:AddSlider('HighlightOutlineTransSlider', {
    Text = 'Outline Transparency',
    Default = Settings.HighlightOutlineTrans * 100,
    Min = 0,
    Max = 100,
    Rounding = 0,
    Suffix = '%',
    Callback = function(Value)
        Settings.HighlightOutlineTrans = Value / 100
        highlight.OutlineTransparency = Value / 100
    end
})

IndicatorGroup:AddToggle('TargetGUIToggle', {
    Text = 'Show Target GUI',
    Default = Settings.TargetGUI,
    Callback = function(Value)
        Settings.TargetGUI = Value
    end
})

-- Tools
ToolGroup:AddButton('Give Silent Aim Tool', function()
    silentAimTool:Clone().Parent = LocalPlayer.Backpack
    Library:Notify("Silent Aim Tool Given", "Bound to: "..Settings.SilentAimKey)
end)

ToolGroup:AddButton('Give Resolver Tool', function()
    resolverTool:Clone().Parent = LocalPlayer.Backpack
    Library:Notify("Resolver Tool Given", "Bound to: "..Settings.ResolverKey)
end)

-- Utility
UtilityGroup:AddButton('Unlock All', function()
    Target = nil
    TargetLocked = false
    ResolverActive = false
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
    local shortestDistance = Settings.FOV

    for _, player in pairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild("Humanoid") and 
           player.Character.Humanoid.Health > 0 and player.Character:FindFirstChild("HumanoidRootPart") then
            local pos = Camera:WorldToViewportPoint(player.Character.PrimaryPart.Position)
            local magnitude = (Vector2.new(pos.X, pos.Y) - Vector2.new(Mouse.X, Mouse.Y + GuiService:GetGuiInset().Y)).magnitude
            
            if magnitude < shortestDistance then
                closestPlayer = player
                shortestDistance = magnitude
            end
        end
    end
    return closestPlayer
end

local function getHitPart(character)
    local humanoid = character:FindFirstChildOfClass("Humanoid")
    
    if humanoid:GetState() == Enum.HumanoidStateType.Jumping then
        return character:FindFirstChild(Parts.Jumping) or character.PrimaryPart
    else
        return character:FindFirstChild(Parts.Default) or character.PrimaryPart
    end
end

local function updatePrediction()
    if Settings.AutoPrediction then
        local ping = game:GetService("Stats").Network.ServerStatsItem["Data Ping"]:GetValue()
        
        if ping < 50 then
            Settings.Prediction = 0.1225
        elseif ping < 70 then
            Settings.Prediction = 0.131
        elseif ping < 90 then
            Settings.Prediction = 0.134
        elseif ping < 110 then
            Settings.Prediction = 0.136
        elseif ping < 130 then
            Settings.Prediction = 0.138
        elseif ping < 150 then
            Settings.Prediction = 0.146
        else
            Settings.Prediction = 0.151
        end
    end
end

local function updateTargetGUI()
    if Target and Target.Character and Settings.TargetGUI and TargetLocked then
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

-- Main loops
RunService.RenderStepped:Connect(function()
    circle.Position = Vector2.new(Mouse.X, Mouse.Y + GuiService:GetGuiInset().Y)
    
    if TargetLocked and Target and Target.Character then
        local hitpart = getHitPart(Target.Character)
        if hitpart then
            local predictionValue = Settings.Prediction
            local offset = Vector3.new(0, 0, 0)
            
            if Target.Character.Humanoid:GetState() == Enum.HumanoidStateType.Jumping then
                predictionValue = Settings.JumpPrediction
                offset = Vector3.new(0, Settings.JumpOffset, 0)
            end
            
            placemarker.CFrame = CFrame.new(hitpart.Position + (hitpart.Velocity * predictionValue) + offset)
            
            if Settings.Line then
                local screenPos = Camera:WorldToViewportPoint(hitpart.Position)
                line.From = Vector2.new(Mouse.X, Mouse.Y + GuiService:GetGuiInset().Y)
                line.To = Vector2.new(screenPos.X, screenPos.Y)
            end
            
            if Settings.Highlight then
                highlight.Adornee = Target.Character
            end
            
            updateTargetGUI()
        end
    else
        placemarker.CFrame = CFrame.new(0, 9999, 0)
        line.Visible = false
        highlight.Adornee = nil
        targetFrame.Enabled = false
    end
    
    updatePrediction()
end)

-- Keybind handling
UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    
    if input.KeyCode == Enum.KeyCode[Settings.SilentAimKey] and Settings.Enabled then
        if TargetLocked then
            TargetLocked = false
            if Settings.Notifications then
                Library:Notify("Target Unlocked", "")
            end
        else
            Target = getClosestPlayerToCursor()
            if Target then
                TargetLocked = true
                if Settings.Notifications then
                    Library:Notify("Target Locked", "Now targeting: "..Target.Name)
                end
            end
        end
    end
    
    if input.KeyCode == Enum.KeyCode[Settings.ResolverKey] then
        ResolverActive = not ResolverActive
        if Settings.Notifications then
            Library:Notify("Resolver "..(ResolverActive and "Enabled" or "Disabled"), "")
        end
    end
end)

-- Silent aim hook
local mt = getrawmetatable(game)
local old = mt.__namecall
setreadonly(mt, false)

mt.__namecall = newcclosure(function(...)
    local args = {...}
    if TargetLocked and getnamecallmethod() == "FireServer" and args[2] == "UpdateMousePos" and Settings.Enabled and Target.Character then
        local hitpart = getHitPart(Target.Character)
        if hitpart then
            local predictionValue = Settings.Prediction
            local offset = Vector3.new(0, 0, 0)
            
            if Target.Character.Humanoid:GetState() == Enum.HumanoidStateType.Jumping then
                predictionValue = Settings.JumpPrediction
                offset = Vector3.new(0, Settings.JumpOffset, 0)
            end
            
            if ResolverActive and Settings.Resolver then
                args[3] = hitpart.Position + offset
            else
                args[3] = hitpart.Position + (hitpart.Velocity * predictionValue) + offset
            end
            
            return old(unpack(args))
        end
    end
    return old(...)
end)

Library:Notify("Azurite Lite Loaded", "Press "..Settings.SilentAimKey.." to lock targets | "..Settings.ResolverKey.." for resolver")
