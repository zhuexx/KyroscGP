-- Put this in a LocalScript in StarterPlayerScripts or StarterGui
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera

-- Aim Assist Settings
local AimAssist = {
    Enabled = true,
    Range = 50,
    FOV = math.rad(20),
    Strength = 0.3,
    TeamCheck = true,
    VisibleFOV = true,
    FOVColor = Color3.fromRGB(255, 255, 255),
    TargetPart = "HumanoidRootPart" -- Can be "Head" or other parts
}

-- FOV Circle
local FOVCircle = Instance.new("Part")
FOVCircle.Name = "AimAssistFOVCircle"
FOVCircle.Anchored = true
FOVCircle.CanCollide = false
FOVCircle.Transparency = 0.7
FOVCircle.Color = AimAssist.FOVColor
FOVCircle.Material = Enum.Material.Neon
FOVCircle.Shape = Enum.PartType.Cylinder
FOVCircle.Size = Vector3.new(0.2, AimAssist.Range * 2, AimAssist.Range * 2)
FOVCircle.TopSurface = Enum.SurfaceType.Smooth
FOVCircle.BottomSurface = Enum.SurfaceType.Smooth
FOVCircle.Parent = workspace
FOVCircle.Visible = AimAssist.VisibleFOV

-- Create GUI
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "AimAssistGUI"
ScreenGui.Parent = game.Players.LocalPlayer:WaitForChild("PlayerGui")

local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Size = UDim2.new(0, 250, 0, 300)
MainFrame.Position = UDim2.new(0.5, -125, 0.5, -150)
MainFrame.AnchorPoint = Vector2.new(0.5, 0.5)
MainFrame.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
MainFrame.BorderSizePixel = 0
MainFrame.Visible = false
MainFrame.Parent = ScreenGui

local Title = Instance.new("TextLabel")
Title.Name = "Title"
Title.Size = UDim2.new(1, 0, 0, 30)
Title.Position = UDim2.new(0, 0, 0, 0)
Title.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
Title.Text = "Aim Assist Settings"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.Font = Enum.Font.SourceSansBold
Title.TextSize = 18
Title.Parent = MainFrame

-- Toggle Button
local ToggleButton = Instance.new("TextButton")
ToggleButton.Name = "ToggleButton"
ToggleButton.Size = UDim2.new(0.9, 0, 0, 30)
ToggleButton.Position = UDim2.new(0.05, 0, 0, 40)
ToggleButton.BackgroundColor3 = AimAssist.Enabled and Color3.fromRGB(0, 170, 0) or Color3.fromRGB(170, 0, 0)
ToggleButton.Text = AimAssist.Enabled and "Aim Assist: ON" or "Aim Assist: OFF"
ToggleButton.TextColor3 = Color3.fromRGB(255, 255, 255)
ToggleButton.Font = Enum.Font.SourceSansBold
ToggleButton.TextSize = 16
ToggleButton.Parent = MainFrame

ToggleButton.MouseButton1Click:Connect(function()
    AimAssist.Enabled = not AimAssist.Enabled
    ToggleButton.BackgroundColor3 = AimAssist.Enabled and Color3.fromRGB(0, 170, 0) or Color3.fromRGB(170, 0, 0)
    ToggleButton.Text = AimAssist.Enabled and "Aim Assist: ON" or "Aim Assist: OFF"
    FOVCircle.Visible = AimAssist.Enabled and AimAssist.VisibleFOV
end)

-- Range Slider
local RangeLabel = Instance.new("TextLabel")
RangeLabel.Name = "RangeLabel"
RangeLabel.Size = UDim2.new(0.9, 0, 0, 20)
RangeLabel.Position = UDim2.new(0.05, 0, 0, 80)
RangeLabel.BackgroundTransparency = 1
RangeLabel.Text = "Range: " .. AimAssist.Range
RangeLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
RangeLabel.Font = Enum.Font.SourceSans
RangeLabel.TextSize = 16
RangeLabel.TextXAlignment = Enum.TextXAlignment.Left
RangeLabel.Parent = MainFrame

local RangeSlider = Instance.new("TextBox")
RangeSlider.Name = "RangeSlider"
RangeSlider.Size = UDim2.new(0.9, 0, 0, 30)
RangeSlider.Position = UDim2.new(0.05, 0, 0, 100)
RangeSlider.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
RangeSlider.Text = tostring(AimAssist.Range)
RangeSlider.TextColor3 = Color3.fromRGB(255, 255, 255)
RangeSlider.Font = Enum.Font.SourceSans
RangeSlider.TextSize = 16
RangeSlider.Parent = MainFrame

RangeSlider.FocusLost:Connect(function(enterPressed)
    local newValue = tonumber(RangeSlider.Text)
    if newValue and newValue >= 10 and newValue <= 200 then
        AimAssist.Range = newValue
        RangeLabel.Text = "Range: " .. AimAssist.Range
        FOVCircle.Size = Vector3.new(0.2, AimAssist.Range * 2, AimAssist.Range * 2)
    else
        RangeSlider.Text = tostring(AimAssist.Range)
    end
end)

-- FOV Slider
local FOVLabel = Instance.new("TextLabel")
FOVLabel.Name = "FOVLabel"
FOVLabel.Size = UDim2.new(0.9, 0, 0, 20)
FOVLabel.Position = UDim2.new(0.05, 0, 0, 140)
FOVLabel.BackgroundTransparency = 1
FOVLabel.Text = "FOV: " .. math.deg(AimAssist.FOV) .. "°"
FOVLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
FOVLabel.Font = Enum.Font.SourceSans
FOVLabel.TextSize = 16
FOVLabel.TextXAlignment = Enum.TextXAlignment.Left
FOVLabel.Parent = MainFrame

local FOVSlider = Instance.new("TextBox")
FOVSlider.Name = "FOVSlider"
FOVSlider.Size = UDim2.new(0.9, 0, 0, 30)
FOVSlider.Position = UDim2.new(0.05, 0, 0, 160)
FOVSlider.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
FOVSlider.Text = tostring(math.deg(AimAssist.FOV))
FOVSlider.TextColor3 = Color3.fromRGB(255, 255, 255)
FOVSlider.Font = Enum.Font.SourceSans
FOVSlider.TextSize = 16
FOVSlider.Parent = MainFrame

FOVSlider.FocusLost:Connect(function(enterPressed)
    local newValue = tonumber(FOVSlider.Text)
    if newValue and newValue >= 5 and newValue <= 60 then
        AimAssist.FOV = math.rad(newValue)
        FOVLabel.Text = "FOV: " .. newValue .. "°"
    else
        FOVSlider.Text = tostring(math.deg(AimAssist.FOV))
    end
end)

-- Strength Slider
local StrengthLabel = Instance.new("TextLabel")
StrengthLabel.Name = "StrengthLabel"
StrengthLabel.Size = UDim2.new(0.9, 0, 0, 20)
StrengthLabel.Position = UDim2.new(0.05, 0, 0, 200)
StrengthLabel.BackgroundTransparency = 1
StrengthLabel.Text = "Strength: " .. AimAssist.Strength
StrengthLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
StrengthLabel.Font = Enum.Font.SourceSans
StrengthLabel.TextSize = 16
StrengthLabel.TextXAlignment = Enum.TextXAlignment.Left
StrengthLabel.Parent = MainFrame

local StrengthSlider = Instance.new("TextBox")
StrengthSlider.Name = "StrengthSlider"
StrengthSlider.Size = UDim2.new(0.9, 0, 0, 30)
StrengthSlider.Position = UDim2.new(0.05, 0, 0, 220)
StrengthSlider.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
StrengthSlider.Text = tostring(AimAssist.Strength)
StrengthSlider.TextColor3 = Color3.fromRGB(255, 255, 255)
StrengthSlider.Font = Enum.Font.SourceSans
StrengthSlider.TextSize = 16
StrengthSlider.Parent = MainFrame

StrengthSlider.FocusLost:Connect(function(enterPressed)
    local newValue = tonumber(StrengthSlider.Text)
    if newValue and newValue >= 0.1 and newValue <= 1 then
        AimAssist.Strength = newValue
        StrengthLabel.Text = "Strength: " .. string.format("%.1f", AimAssist.Strength)
    else
        StrengthSlider.Text = tostring(AimAssist.Strength)
    end
end)

-- Toggle FOV Circle
local ToggleFOVButton = Instance.new("TextButton")
ToggleFOVButton.Name = "ToggleFOVButton"
ToggleFOVButton.Size = UDim2.new(0.9, 0, 0, 30)
ToggleFOVButton.Position = UDim2.new(0.05, 0, 0, 260)
ToggleFOVButton.BackgroundColor3 = AimAssist.VisibleFOV and Color3.fromRGB(0, 120, 255) or Color3.fromRGB(60, 60, 60)
ToggleFOVButton.Text = AimAssist.VisibleFOV and "FOV Circle: ON" or "FOV Circle: OFF"
ToggleFOVButton.TextColor3 = Color3.fromRGB(255, 255, 255)
ToggleFOVButton.Font = Enum.Font.SourceSansBold
ToggleFOVButton.TextSize = 16
ToggleFOVButton.Parent = MainFrame

ToggleFOVButton.MouseButton1Click:Connect(function()
    AimAssist.VisibleFOV = not AimAssist.VisibleFOV
    FOVCircle.Visible = AimAssist.Enabled and AimAssist.VisibleFOV
    ToggleFOVButton.BackgroundColor3 = AimAssist.VisibleFOV and Color3.fromRGB(0, 120, 255) or Color3.fromRGB(60, 60, 60)
    ToggleFOVButton.Text = AimAssist.VisibleFOV and "FOV Circle: ON" or "FOV Circle: OFF"
end)

-- Toggle GUI visibility
UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if input.KeyCode == Enum.KeyCode.RightShift and not gameProcessed then
        MainFrame.Visible = not MainFrame.Visible
    end
end)

-- Aim Assist Functions
function FindNearestTarget()
    if not AimAssist.Enabled or not LocalPlayer.Character then return nil end
    
    local rootPart = LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
    if not rootPart then return nil end
    
    local nearestTarget = nil
    local nearestAngle = AimAssist.FOV
    
    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character then
            -- Team check (if enabled)
            if AimAssist.TeamCheck and player.Team == LocalPlayer.Team then
                continue
            end
            
            local targetPart = player.Character:FindFirstChild(AimAssist.TargetPart)
            if targetPart then
                -- Check if target is within range
                local distance = (targetPart.Position - rootPart.Position).Magnitude
                if distance <= AimAssist.Range then
                    -- Calculate angle from camera look vector
                    local direction = (targetPart.Position - Camera.CFrame.Position).Unit
                    local angle = math.acos(Camera.CFrame.LookVector:Dot(direction))
                    
                    if angle < nearestAngle then
                        nearestAngle = angle
                        nearestTarget = targetPart
                    end
                end
            end
        end
    end
    
    return nearestTarget
end

function ApplyAimAssist()
    if not AimAssist.Enabled then return end
    
    local target = FindNearestTarget()
    if target then
        local currentCFrame = Camera.CFrame
        local targetDirection = (target.Position - currentCFrame.Position).Unit
        
        -- Interpolate between current look direction and target direction
        local newLookVector = currentCFrame.LookVector:Lerp(targetDirection, AimAssist.Strength)
        
        -- Create new CFrame with interpolated look direction
        Camera.CFrame = CFrame.new(currentCFrame.Position, currentCFrame.Position + newLookVector)
    end
end

-- Update FOV Circle position and orientation
RunService.RenderStepped:Connect(function()
    if LocalPlayer.Character then
        local rootPart = LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
        if rootPart then
            -- Update FOV Circle position and orientation
            FOVCircle.CFrame = CFrame.new(rootPart.Position) * CFrame.Angles(0, 0, math.pi/2)
            FOVCircle.Color = AimAssist.FOVColor
            FOVCircle.Visible = AimAssist.Enabled and AimAssist.VisibleFOV
        end
    end
    
    -- Apply aim assist
    ApplyAimAssist()
end)

-- Initial setup
FOVCircle.Visible = AimAssist.Enabled and AimAssist.VisibleFOV
