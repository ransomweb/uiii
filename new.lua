local repo = 'https://raw.githubusercontent.com/violin-suzutsuki/LinoriaLib/main/'

local Library = loadstring(game:HttpGet(repo .. 'Library.lua'))()
local ThemeManager = loadstring(game:HttpGet(repo .. 'addons/ThemeManager.lua'))()

ThemeManager.BuiltInThemes['Azurite'] = {9, {
    FontColor = "ffffff",
    MainColor = "1a1a2e",
    AccentColor = "69a0f0",
    BackgroundColor = "141420",
    OutlineColor = "2a2a3a"
}}

local Window = Library:CreateWindow({
    Title = 'Azurite Lite [BETA] [YUFI]',
    Center = true,
    AutoShow = true,
    TabPadding = 8,
    MenuFadeTime = 0.2
})

ThemeManager:SetLibrary(Library)
ThemeManager:ApplyTheme('Azurite')

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
dot.Radius = 2
dot.Transparency = 0
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

-- Target GUI
local targetFrame = Instance.new("ScreenGui", game:GetService("CoreGui"))
targetFrame.Name = "AzuriteTargetGUI"
targetFrame.Enabled = false

local mainFrame = Instance.new("Frame", targetFrame)
mainFrame.Size = UDim2.new(0, 250, 0, 80)
mainFrame.Position = UDim2.new(0.5, -125, 1, -90)
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

local Tabs = {
    Main = Window:AddTab('Main'),
    Player = Window:AddTab('Player')
}

local SilentAimGroup = Tabs.Main:AddLeftGroupbox('Silent Aim')
local CamLockGroup = Tabs.Main:AddRightGroupbox('Cam Lock')
local FlyGroup = Tabs.Player:AddLeftGroupbox('CFrame Fly')

local Settings = {
    SilentAim = {
        Enabled = true,
        Keybind = "Q",
        Prediction = 0.15,
        JumpOffset = 0,
        Hitpart = "HumanoidRootPart",
        JumpHitpart = "HumanoidRootPart",
        ShowFOV = false,
        ShowDot = true,
        ShowTracer = true,
        ShowStats = true,
        ShowHighlight = true
    },
    CamLock = {
        Enabled = false,
        Keybind = "E",
        Prediction = 0.15,
        JumpOffset = 0,
        Hitpart = "HumanoidRootPart"
    },
    Fly = {
        Enabled = false,
        Keybind = "F",
        Speed = 1
    }
}

local Target = nil
local TargetLocked = false
local CamLockTarget = nil
local CamLockActive = false
local Flying = false
local FlyVelocity = Vector3.new()

-- Silent Aim UI
SilentAimGroup:AddToggle('SilentAimEnabled', {
    Text = 'Enabled',
    Default = Settings.SilentAim.Enabled,
    Callback = function(Value)
        Settings.SilentAim.Enabled = Value
    end
})

local SilentAimKeybind = SilentAimGroup:AddLabel('Keybind'):AddKeyPicker('SilentAimKeybind', {
    Default = Settings.SilentAim.Keybind,
    SyncToggleState = false,
    Mode = 'Toggle',
    Text = 'Silent Aim keybind',
    NoUI = false,
})

SilentAimKeybind:OnChanged(function()
    Settings.SilentAim.Keybind = Options.SilentAimKeybind.Value
end)

SilentAimGroup:AddInput('PredictionInput', {
    Default = tostring(Settings.SilentAim.Prediction),
    Numeric = true,
    Finished = true,
    Text = 'Prediction',
    Callback = function(Value)
        Settings.SilentAim.Prediction = tonumber(Value) or 0.15
    end
})

SilentAimGroup:AddSlider('JumpOffsetSlider', {
    Text = 'Jump Offset',
    Default = 0,
    Min = -1,
    Max = 1,
    Rounding = 2,
    Suffix = '',
    Callback = function(Value)
        Settings.SilentAim.JumpOffset = Value
    end
})

SilentAimGroup:AddDropdown('HitpartDropdown', {
    Values = {'HumanoidRootPart', 'Head', 'UpperTorso', 'LowerTorso', 'LeftFoot', 'RightFoot'},
    Default = 1,
    Multi = false,
    Text = 'Hitpart',
    Callback = function(Value)
        Settings.SilentAim.Hitpart = Value
    end
})

SilentAimGroup:AddDropdown('JumpHitpartDropdown', {
    Values = {'HumanoidRootPart', 'Head', 'UpperTorso', 'LowerTorso', 'LeftFoot', 'RightFoot'},
    Default = 1,
    Multi = false,
    Text = 'Jump Hitpart',
    Callback = function(Value)
        Settings.SilentAim.JumpHitpart = Value
    end
})

SilentAimGroup:AddToggle('ShowFOVToggle', {
    Text = 'Show FOV',
    Default = Settings.SilentAim.ShowFOV,
    Callback = function(Value)
        Settings.SilentAim.ShowFOV = Value
        circle.Visible = Value
    end
})

SilentAimGroup:AddToggle('ShowDotToggle', {
    Text = 'Show Dot',
    Default = Settings.SilentAim.ShowDot,
    Callback = function(Value)
        Settings.SilentAim.ShowDot = Value
        dot.Visible = Value
    end
})

SilentAimGroup:AddToggle('ShowTracerToggle', {
    Text = 'Show Tracer',
    Default = Settings.SilentAim.ShowTracer,
    Callback = function(Value)
        Settings.SilentAim.ShowTracer = Value
        line.Visible = Value
    end
})

SilentAimGroup:AddToggle('ShowStatsToggle', {
    Text = 'Show Stats',
    Default = Settings.SilentAim.ShowStats,
    Callback = function(Value)
        Settings.SilentAim.ShowStats = Value
        targetFrame.Enabled = Value and TargetLocked
    end
})

SilentAimGroup:AddToggle('ShowHighlightToggle', {
    Text = 'Show Highlight',
    Default = Settings.SilentAim.ShowHighlight,
    Callback = function(Value)
        Settings.SilentAim.ShowHighlight = Value
        highlight.Enabled = Value
    end
})

-- Cam Lock UI
CamLockGroup:AddToggle('CamLockEnabled', {
    Text = 'Enabled',
    Default = Settings.CamLock.Enabled,
    Callback = function(Value)
        Settings.CamLock.Enabled = Value
    end
})

local CamLockKeybind = CamLockGroup:AddLabel('Keybind'):AddKeyPicker('CamLockKeybind', {
    Default = Settings.CamLock.Keybind,
    SyncToggleState = false,
    Mode = 'Toggle',
    Text = 'Cam Lock keybind',
    NoUI = false,
})

CamLockKeybind:OnChanged(function()
    Settings.CamLock.Keybind = Options.CamLockKeybind.Value
end)

CamLockGroup:AddInput('CamPredictionInput', {
    Default = tostring(Settings.CamLock.Prediction),
    Numeric = true,
    Finished = true,
    Text = 'Prediction',
    Callback = function(Value)
        Settings.CamLock.Prediction = tonumber(Value) or 0.15
    end
})

CamLockGroup:AddSlider('CamJumpOffsetSlider', {
    Text = 'Jump Offset',
    Default = 0,
    Min = -1,
    Max = 1,
    Rounding = 2,
    Suffix = '',
    Callback = function(Value)
        Settings.CamLock.JumpOffset = Value
    end
})

CamLockGroup:AddDropdown('CamHitpartDropdown', {
    Values = {'HumanoidRootPart', 'Head', 'UpperTorso', 'LowerTorso', 'LeftFoot', 'RightFoot'},
    Default = 1,
    Multi = false,
    Text = 'Hitpart',
    Callback = function(Value)
        Settings.CamLock.Hitpart = Value
    end
})

-- Fly UI
FlyGroup:AddToggle('FlyEnabled', {
    Text = 'Enabled',
    Default = Settings.Fly.Enabled,
    Callback = function(Value)
        Settings.Fly.Enabled = Value
        Flying = Value
        if not Value and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
            LocalPlayer.Character.HumanoidRootPart.Velocity = Vector3.new()
        end
    end
})

local FlyKeybind = FlyGroup:AddLabel('Keybind'):AddKeyPicker('FlyKeybind', {
    Default = Settings.Fly.Keybind,
    SyncToggleState = false,
    Mode = 'Toggle',
    Text = 'Fly keybind',
    NoUI = false,
})

FlyKeybind:OnChanged(function()
    Settings.Fly.Keybind = Options.FlyKeybind.Value
end)

FlyGroup:AddSlider('FlySpeedSlider', {
    Text = 'Speed',
    Default = Settings.Fly.Speed * 100,
    Min = 1,
    Max = 500,
    Rounding = 0,
    Suffix = '%',
    Callback = function(Value)
        Settings.Fly.Speed = Value / 100
    end
})

Library:SetWatermarkVisibility(true)
Library:SetWatermark('Azurite Lite [BETA] | YUFI')

local function getClosestPlayerToCursor()
    local closestPlayer
    local shortestDistance = Settings.SilentAim.ShowFOV and circle.Radius or math.huge

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

local function getHitPart(character, isJumping)
    if isJumping then
        return character:FindFirstChild(Settings.SilentAim.JumpHitpart) or character.PrimaryPart
    else
        return character:FindFirstChild(Settings.SilentAim.Hitpart) or character.PrimaryPart
    end
end

local function updateTargetGUI()
    if Target and Target.Character and Settings.SilentAim.ShowStats and TargetLocked then
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

UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    
    if input.KeyCode == Enum.KeyCode[Settings.SilentAim.Keybind] and Settings.SilentAim.Enabled then
        if TargetLocked then
            TargetLocked = false
            highlight.Adornee = nil
        else
            Target = getClosestPlayerToCursor()
            if Target then
                TargetLocked = true
                if Settings.SilentAim.ShowHighlight then
                    highlight.Adornee = Target.Character
                end
            end
        end
    end
    
    if input.KeyCode == Enum.KeyCode[Settings.CamLock.Keybind] and Settings.CamLock.Enabled then
        if CamLockActive then
            CamLockActive = false
        else
            CamLockTarget = getClosestPlayerToCursor()
            if CamLockTarget then
                CamLockActive = true
            end
        end
    end
    
    if input.KeyCode == Enum.KeyCode[Settings.Fly.Keybind] then
        Flying = not Flying
        if not Flying and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
            LocalPlayer.Character.HumanoidRootPart.Velocity = Vector3.new()
        end
    end
end)

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

RunService.RenderStepped:Connect(function()
    circle.Position = Vector2.new(Mouse.X, Mouse.Y + GuiService:GetGuiInset().Y)
    
    if TargetLocked and Target and Target.Character then
        local hitpart = getHitPart(Target.Character, Target.Character.Humanoid:GetState() == Enum.HumanoidStateType.Jumping)
        if hitpart then
            local predictionValue = Settings.SilentAim.Prediction
            local offset = Vector3.new(0, 0, 0)
            
            if Target.Character.Humanoid:GetState() == Enum.HumanoidStateType.Jumping then
                offset = Vector3.new(0, Settings.SilentAim.JumpOffset, 0)
            end
            
            if Settings.SilentAim.ShowTracer then
                local screenPos = Camera:WorldToViewportPoint(hitpart.Position)
                line.From = Vector2.new(Mouse.X, Mouse.Y + GuiService:GetGuiInset().Y)
                line.To = Vector2.new(screenPos.X, screenPos.Y)
            end
            
            if Settings.SilentAim.ShowDot then
                local screenPos = Camera:WorldToViewportPoint(hitpart.Position)
                dot.Position = Vector2.new(screenPos.X, screenPos.Y)
            end
            
            updateTargetGUI()
        end
    else
        line.Visible = false
        dot.Visible = false
        targetFrame.Enabled = false
    end
    
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
    
    if Flying and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
        local root = LocalPlayer.Character.HumanoidRootPart
        local camCF = Camera.CFrame
        local direction = Vector3.new()
        
        if UserInputService:IsKeyDown(Enum.KeyCode.W) then
            direction = direction + camCF.LookVector
        end
        if UserInputService:IsKeyDown(Enum.KeyCode.S) then
            direction = direction - camCF.LookVector
        end
        if UserInputService:IsKeyDown(Enum.KeyCode.D) then
            direction = direction + camCF.RightVector
        end
        if UserInputService:IsKeyDown(Enum.KeyCode.A) then
            direction = direction - camCF.RightVector
        end
        if UserInputService:IsKeyDown(Enum.KeyCode.Space) then
            direction = direction + Vector3.new(0, 1, 0)
        end
        if UserInputService:IsKeyDown(Enum.KeyCode.LeftShift) then
            direction = direction - Vector3.new(0, 1, 0)
        end
        
        if direction.Magnitude > 0 then
            FlyVelocity = direction.Unit * Settings.Fly.Speed * 50
        else
            FlyVelocity = Vector3.new()
        end
        
        root.Velocity = FlyVelocity
    end
end)

loadstring(game:HttpGet("https://raw.githubusercontent.com/Pixeluted/adoniscries/main/Source.lua",true))()
