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
        ShowTracer = true
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

SilentAimGroup:AddToggle('SilentAimEnabled', {
    Text = 'Enabled',
    Default = Settings.SilentAim.Enabled,
    Callback = function(Value)
        Settings.SilentAim.Enabled = Value
    end
})

SilentAimGroup:AddLabel('Keybind'):AddKeyPicker('SilentAimKeybind', {
    Default = Settings.SilentAim.Keybind,
    SyncToggleState = false,
    Mode = 'Toggle',
    Text = 'Silent Aim keybind',
    NoUI = false,
})

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
    Min = -100,
    Max = 100,
    Rounding = 2,
    Suffix = '',
    Callback = function(Value)
        Settings.SilentAim.JumpOffset = Value / 100
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

CamLockGroup:AddToggle('CamLockEnabled', {
    Text = 'Enabled',
    Default = Settings.CamLock.Enabled,
    Callback = function(Value)
        Settings.CamLock.Enabled = Value
    end
})

CamLockGroup:AddLabel('Keybind'):AddKeyPicker('CamLockKeybind', {
    Default = Settings.CamLock.Keybind,
    SyncToggleState = false,
    Mode = 'Toggle',
    Text = 'Cam Lock keybind',
    NoUI = false,
})

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
    Min = -100,
    Max = 100,
    Rounding = 2,
    Suffix = '',
    Callback = function(Value)
        Settings.CamLock.JumpOffset = Value / 100
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

FlyGroup:AddToggle('FlyEnabled', {
    Text = 'Enabled',
    Default = Settings.Fly.Enabled,
    Callback = function(Value)
        Settings.Fly.Enabled = Value
        Flying = Value
        if not Value then
            if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
                LocalPlayer.Character.HumanoidRootPart.Velocity = Vector3.new()
            end
        end
    end
})

FlyGroup:AddLabel('Keybind'):AddKeyPicker('FlyKeybind', {
    Default = Settings.Fly.Keybind,
    SyncToggleState = false,
    Mode = 'Toggle',
    Text = 'Fly keybind',
    NoUI = false,
})

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

UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    
    if input.KeyCode == Enum.KeyCode[Settings.SilentAim.Keybind] and Settings.SilentAim.Enabled then
        if TargetLocked then
            TargetLocked = false
        else
            Target = getClosestPlayerToCursor()
            if Target then
                TargetLocked = true
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
            
            placemarker.CFrame = CFrame.new(hitpart.Position + (hitpart.Velocity * predictionValue) + offset)
            
            if Settings.SilentAim.ShowTracer then
                local screenPos = Camera:WorldToViewportPoint(hitpart.Position)
                line.From = Vector2.new(Mouse.X, Mouse.Y + GuiService:GetGuiInset().Y)
                line.To = Vector2.new(screenPos.X, screenPos.Y)
            end
            
            if Settings.SilentAim.ShowDot then
                local screenPos = Camera:WorldToViewportPoint(hitpart.Position)
                dot.Position = Vector2.new(screenPos.X, screenPos.Y)
            end
        end
    else
        placemarker.CFrame = CFrame.new(0, 9999, 0)
        line.Visible = false
        dot.Visible = false
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
