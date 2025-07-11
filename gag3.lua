local SeedPackController = require(game.ReplicatedStorage.Modules.SeedPackController)
local SeedPackData = require(game.ReplicatedStorage.Data.SeedPackData)
local Players = game:GetService("Players")
local CollectionService = game:GetService("CollectionService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local CalculatePlantValue = require(ReplicatedStorage:WaitForChild("Modules"):WaitForChild("CalculatePlantValue"))
local Comma = require(ReplicatedStorage:WaitForChild("Comma_Module"))

-- Create compact GUI
local gui = Instance.new("ScreenGui")
gui.Name = "AllInOneESP"
gui.ResetOnSpawn = false

-- Main container with smooth edges
local mainFrame = Instance.new("Frame")
mainFrame.Size = UDim2.new(0.35, 0, 0.5, 0)
mainFrame.Position = UDim2.new(0.5, 0, 0.5, 0)
mainFrame.AnchorPoint = Vector2.new(0.5, 0.5)
mainFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
mainFrame.BackgroundTransparency = 0.2
mainFrame.BorderSizePixel = 0

-- Smooth corners
local corner = Instance.new("UICorner")
corner.CornerRadius = UDim.new(0.05, 0)
corner.Parent = mainFrame

-- Make frame draggable
local dragInput, dragStart, startPos
local function updateInput(input)
    local delta = input.Position - dragStart
    mainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
end

mainFrame.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragStart = input.Position
        startPos = mainFrame.Position
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                dragInput = nil
            end
        end)
    end
end)

mainFrame.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
        dragInput = input
    end
end)

game:GetService("UserInputService").InputChanged:Connect(function(input)
    if input == dragInput then
        updateInput(input)
    end
end)

-- Tab system
local tabButtons = {}
local tabFrames = {}

local function createTab(name, position)
    local tabButton = Instance.new("TextButton")
    tabButton.Name = name.."Tab"
    tabButton.Size = UDim2.new(0.25, 0, 0.1, 0)
    tabButton.Position = position
    tabButton.BackgroundColor3 = Color3.fromRGB(40, 40, 60)
    tabButton.Text = name
    tabButton.Font = Enum.Font.SciFi
    tabButton.TextColor3 = Color3.fromRGB(200, 200, 255)
    tabButton.TextSize = 14
    tabButton.ZIndex = 2
    
    local tabCorner = Instance.new("UICorner")
    tabCorner.CornerRadius = UDim.new(0.05, 0)
    tabCorner.Parent = tabButton
    
    local tabFrame = Instance.new("Frame")
    tabFrame.Name = name.."Frame"
    tabFrame.Size = UDim2.new(1, 0, 0.9, 0)
    tabFrame.Position = UDim2.new(0, 0, 0.1, 0)
    tabFrame.BackgroundTransparency = 1
    tabFrame.Visible = false
    
    tabButton.Parent = mainFrame
    tabFrame.Parent = mainFrame
    
    tabButtons[name] = tabButton
    tabFrames[name] = tabFrame
    
    tabButton.MouseButton1Click:Connect(function()
        for _, frame in pairs(tabFrames) do
            frame.Visible = false
        end
        tabFrame.Visible = true
        
        for _, button in pairs(tabButtons) do
            button.BackgroundColor3 = Color3.fromRGB(40, 40, 60)
        end
        tabButton.BackgroundColor3 = Color3.fromRGB(60, 60, 80)
    end)
    
    return tabFrame
end

-- Create tabs
local seedTab = createTab("Seed", UDim2.new(0, 0, 0, 0))
local plantTab = createTab("Plant", UDim2.new(0.25, 0, 0, 0))
local eggTab = createTab("Egg", UDim2.new(0.5, 0, 0, 0))
local dupeTab = createTab("Dupe", UDim2.new(0.75, 0, 0, 0))

-- Activate first tab by default
tabButtons["Seed"].BackgroundColor3 = Color3.fromRGB(60, 60, 80)
tabFrames["Seed"].Visible = true

-- Seed Spinner Tab Content -----------------------------------------------------
local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, 0, 0.15, 0)
title.Position = UDim2.new(0, 0, 0, 0)
title.BackgroundTransparency = 1
title.Text = "SEED SPINNER"
title.Font = Enum.Font.SciFi
title.TextColor3 = Color3.fromRGB(0, 200, 255)
title.TextSize = 18
title.Parent = seedTab

local packDropdown = Instance.new("TextButton")
packDropdown.Name = "PackDropdown"
packDropdown.Size = UDim2.new(0.8, 0, 0.15, 0)
packDropdown.Position = UDim2.new(0.1, 0, 0.2, 0)
packDropdown.BackgroundColor3 = Color3.fromRGB(40, 40, 60)
packDropdown.Text = "SELECT PACK"
packDropdown.Font = Enum.Font.SciFi
packDropdown.TextColor3 = Color3.fromRGB(200, 200, 255)
packDropdown.TextSize = 14
packDropdown.ZIndex = 2
packDropdown.Parent = seedTab

local packCorner = Instance.new("UICorner")
packCorner.CornerRadius = UDim.new(0.2, 0)
packCorner.Parent = packDropdown

local seedDropdown = packDropdown:Clone()
seedDropdown.Name = "SeedDropdown"
seedDropdown.Position = UDim2.new(0.1, 0, 0.4, 0)
seedDropdown.Text = "SELECT SEED"
seedDropdown.Parent = seedTab

local spinButton = Instance.new("TextButton")
spinButton.Size = UDim2.new(0.6, 0, 0.15, 0)
spinButton.Position = UDim2.new(0.2, 0, 0.65, 0)
spinButton.BackgroundColor3 = Color3.fromRGB(0, 100, 150)
spinButton.Text = "SPIN"
spinButton.Font = Enum.Font.SciFi
spinButton.TextColor3 = Color3.fromRGB(200, 255, 255)
spinButton.TextSize = 16
spinButton.Parent = seedTab

local spinCorner = Instance.new("UICorner")
spinCorner.CornerRadius = UDim.new(0.2, 0)
spinCorner.Parent = spinButton

local statusLabel = Instance.new("TextLabel")
statusLabel.Size = UDim2.new(0.8, 0, 0.1, 0)
statusLabel.Position = UDim2.new(0.1, 0, 0.85, 0)
statusLabel.BackgroundTransparency = 1
statusLabel.Text = ""
statusLabel.Font = Enum.Font.SciFi
statusLabel.TextColor3 = Color3.fromRGB(0, 255, 150)
statusLabel.TextSize = 14
statusLabel.Parent = seedTab

-- Plant ESP Tab Content -------------------------------------------------------
local plantTitle = Instance.new("TextLabel")
plantTitle.Size = UDim2.new(1, 0, 0.15, 0)
plantTitle.Position = UDim2.new(0, 0, 0, 0)
plantTitle.BackgroundTransparency = 1
plantTitle.Text = "PLANT ESP"
plantTitle.Font = Enum.Font.SciFi
plantTitle.TextColor3 = Color3.fromRGB(0, 200, 255)
plantTitle.TextSize = 18
plantTitle.Parent = plantTab

local plantToggle = Instance.new("TextButton")
plantToggle.Name = "PlantToggle"
plantToggle.Size = UDim2.new(0.6, 0, 0.2, 0)
plantToggle.Position = UDim2.new(0.2, 0, 0.2, 0)
plantToggle.BackgroundColor3 = Color3.fromRGB(60, 60, 80)
plantToggle.Text = "PLANT ESP: OFF"
plantToggle.Font = Enum.Font.SciFi
plantToggle.TextColor3 = Color3.fromRGB(255, 100, 100)
plantToggle.TextSize = 16
plantToggle.Parent = plantTab

local plantToggleCorner = Instance.new("UICorner")
plantToggleCorner.CornerRadius = UDim.new(0.2, 0)
plantToggleCorner.Parent = plantToggle

local plantRangeLabel = Instance.new("TextLabel")
plantRangeLabel.Size = UDim2.new(0.8, 0, 0.1, 0)
plantRangeLabel.Position = UDim2.new(0.1, 0, 0.45, 0)
plantRangeLabel.BackgroundTransparency = 1
plantRangeLabel.Text = "Range: 50"
plantRangeLabel.Font = Enum.Font.SciFi
plantRangeLabel.TextColor3 = Color3.fromRGB(200, 200, 255)
plantRangeLabel.TextSize = 14
plantRangeLabel.TextXAlignment = Enum.TextXAlignment.Left
plantRangeLabel.Parent = plantTab

local plantRangeSlider = Instance.new("TextButton")
plantRangeSlider.Size = UDim2.new(0.8, 0, 0.1, 0)
plantRangeSlider.Position = UDim2.new(0.1, 0, 0.55, 0)
plantRangeSlider.BackgroundColor3 = Color3.fromRGB(60, 60, 80)
plantRangeSlider.Text = ""
plantRangeSlider.Font = Enum.Font.SciFi
plantRangeSlider.TextColor3 = Color3.fromRGB(200, 200, 255)
plantRangeSlider.TextSize = 14
plantRangeSlider.Parent = plantTab

local plantRangeSliderCorner = Instance.new("UICorner")
plantRangeSliderCorner.CornerRadius = UDim.new(0.2, 0)
plantRangeSliderCorner.Parent = plantRangeSlider

local plantRangeFill = Instance.new("Frame")
plantRangeFill.Size = UDim2.new(0.5, 0, 1, 0)
plantRangeFill.Position = UDim2.new(0, 0, 0, 0)
plantRangeFill.BackgroundColor3 = Color3.fromRGB(0, 150, 255)
plantRangeFill.BorderSizePixel = 0
plantRangeFill.Parent = plantRangeSlider

local plantRangeFillCorner = Instance.new("UICorner")
plantRangeFillCorner.CornerRadius = UDim.new(0.2, 0)
plantRangeFillCorner.Parent = plantRangeFill

local plantStatusLabel = Instance.new("TextLabel")
plantStatusLabel.Size = UDim2.new(0.8, 0, 0.1, 0)
plantStatusLabel.Position = UDim2.new(0.1, 0, 0.85, 0)
plantStatusLabel.BackgroundTransparency = 1
plantStatusLabel.Text = ""
plantStatusLabel.Font = Enum.Font.SciFi
plantStatusLabel.TextColor3 = Color3.fromRGB(0, 255, 150)
plantStatusLabel.TextSize = 14
plantStatusLabel.Parent = plantTab

-- Egg ESP Tab Content ---------------------------------------------------------
local eggTitle = Instance.new("TextLabel")
eggTitle.Size = UDim2.new(1, 0, 0.15, 0)
eggTitle.Position = UDim2.new(0, 0, 0, 0)
eggTitle.BackgroundTransparency = 1
eggTitle.Text = "EGG ESP"
eggTitle.Font = Enum.Font.SciFi
eggTitle.TextColor3 = Color3.fromRGB(0, 200, 255)
eggTitle.TextSize = 18
eggTitle.Parent = eggTab

local eggToggle = Instance.new("TextButton")
eggToggle.Name = "EggToggle"
eggToggle.Size = UDim2.new(0.6, 0, 0.2, 0)
eggToggle.Position = UDim2.new(0.2, 0, 0.2, 0)
eggToggle.BackgroundColor3 = Color3.fromRGB(60, 60, 80)
eggToggle.Text = "EGG ESP: OFF"
eggToggle.Font = Enum.Font.SciFi
eggToggle.TextColor3 = Color3.fromRGB(255, 100, 100)
eggToggle.TextSize = 16
eggToggle.Parent = eggTab

local eggToggleCorner = Instance.new("UICorner")
eggToggleCorner.CornerRadius = UDim.new(0.2, 0)
eggToggleCorner.Parent = eggToggle

local eggStatusLabel = Instance.new("TextLabel")
eggStatusLabel.Size = UDim2.new(0.8, 0, 0.1, 0)
eggStatusLabel.Position = UDim2.new(0.1, 0, 0.85, 0)
eggStatusLabel.BackgroundTransparency = 1
eggStatusLabel.Text = ""
eggStatusLabel.Font = Enum.Font.SciFi
eggStatusLabel.TextColor3 = Color3.fromRGB(0, 255, 150)
eggStatusLabel.TextSize = 14
eggStatusLabel.Parent = eggTab

-- Dupe Tab Content ---------------------------------------------------------
local dupeTitle = Instance.new("TextLabel")
dupeTitle.Size = UDim2.new(1, 0, 0.15, 0)
dupeTitle.Position = UDim2.new(0, 0, 0, 0)
dupeTitle.BackgroundTransparency = 1
dupeTitle.Text = "PET DUPLICATOR"
dupeTitle.Font = Enum.Font.SciFi
dupeTitle.TextColor3 = Color3.fromRGB(0, 200, 255)
dupeTitle.TextSize = 18
dupeTitle.Parent = dupeTab

local dupeButton = Instance.new("TextButton")
dupeButton.Name = "DupeButton"
dupeButton.Size = UDim2.new(0.6, 0, 0.2, 0)
dupeButton.Position = UDim2.new(0.2, 0, 0.3, 0)
dupeButton.BackgroundColor3 = Color3.fromRGB(150, 0, 0)
dupeButton.Text = "DUPLICATE PET"
dupeButton.Font = Enum.Font.SciFi
dupeButton.TextColor3 = Color3.fromRGB(255, 255, 255)
dupeButton.TextSize = 16
dupeButton.Parent = dupeTab

local dupeStatusLabel = Instance.new("TextLabel")
dupeStatusLabel.Size = UDim2.new(0.8, 0, 0.1, 0)
dupeStatusLabel.Position = UDim2.new(0.1, 0, 0.6, 0)
dupeStatusLabel.BackgroundTransparency = 1
dupeStatusLabel.Text = ""
dupeStatusLabel.Font = Enum.Font.SciFi
dupeStatusLabel.TextColor3 = Color3.fromRGB(0, 255, 150)
dupeStatusLabel.TextSize = 14
dupeStatusLabel.Parent = dupeTab

-- Dupe Functions
local LocalPlayer = Players.LocalPlayer
local character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
local backpack = LocalPlayer:WaitForChild("Backpack")

-- Update character reference when character changes
LocalPlayer.CharacterAdded:Connect(function(newChar)
    character = newChar
end)

local function getTool()
    -- Check character first
    if character then
        for _, item in ipairs(character:GetChildren()) do
            if item:IsA("Tool") then
                return item
            end
        end
    end
    
    -- Check backpack if not found on character
    if backpack then
        for _, item in ipairs(backpack:GetChildren()) do
            if item:IsA("Tool") then
                return item
            end
        end
    end
    
    return nil
end

-- Duplication Function
local function duplicatePet()
    local tool = getTool()
    if not tool then 
        dupeStatusLabel.Text = "No pet tool found!"
        task.delay(2, function() dupeStatusLabel.Text = "" end)
        return false 
    end

    -- Create visual clone in workspace
    local root = character:FindFirstChild("HumanoidRootPart")
    if root then
        local visual = tool:Clone()
        visual.Parent = workspace
        
        if visual:IsA("Tool") and visual:FindFirstChild("Handle") then
            visual.Handle.CFrame = root.CFrame * CFrame.new(3, 0, 0)
        elseif visual:IsA("Model") then
            local part = visual:FindFirstChildWhichIsA("BasePart")
            if part then
                part.CFrame = root.CFrame * CFrame.new(3, 0, 0)
            end
        end
        
        game:GetService("Debris"):AddItem(visual, 2)
    end

    -- Create actual clone in backpack
    local clone = tool:Clone()
    clone.Parent = backpack
    
    dupeStatusLabel.Text = "Successfully duplicated pet!"
    task.delay(2, function() dupeStatusLabel.Text = "" end)
    return true
end

-- Connect button to function
dupeButton.MouseButton1Click:Connect(duplicatePet)

-- Plant ESP Functionality -----------------------------------------------------
local plantESPEnabled = false
local PLANT_RANGE = 50
local LocalPlayer = Players.LocalPlayer
local Character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
local RootPart = Character:WaitForChild("HumanoidRootPart")
local PlantESPs = {}
local PlantUpdateQueue = {}

local function createPlantBillboard(model)
    local billboard = Instance.new("BillboardGui")
    billboard.Name = "esp"
    billboard.Size = UDim2.new(0, 100, 0, 20)
    billboard.StudsOffset = Vector3.new(0, 3, 0)
    billboard.AlwaysOnTop = true
    billboard.LightInfluence = 0
    billboard.ResetOnSpawn = false
    billboard.Parent = model

    local label = Instance.new("TextLabel")
    label.Name = "money"
    label.Size = UDim2.new(1, 0, 1, 0)
    label.BackgroundTransparency = 1
    label.TextColor3 = Color3.fromRGB(255, 255, 0)
    label.TextStrokeTransparency = 0.5
    label.TextStrokeColor3 = Color3.new(0, 0, 0)
    label.Font = Enum.Font.GothamBold
    label.TextScaled = true
    label.Text = "..."
    label.Parent = billboard

    return billboard
end

local function updatePlantESP(model)
    if not plantESPEnabled then return end
    local esp = PlantESPs[model]
    if not esp or not model:IsDescendantOf(workspace) then return end
    local label = esp:FindFirstChild("money")
    if label then
        local success, value = pcall(CalculatePlantValue, model)
        if success and typeof(value) == "number" then
            label.Text = Comma.Comma(value) .. "Â¢"
        end
    end
end

local function trackPlant(model)
    if PlantESPs[model] then return end
    PlantUpdateQueue[model] = tick() + math.random()
end

local function untrackPlant(model)
    if PlantESPs[model] then
        PlantESPs[model]:Destroy()
        PlantESPs[model] = nil
    end
    PlantUpdateQueue[model] = nil
end

local function createPlantESP(model)
    if not plantESPEnabled then return end
    if PlantESPs[model] then return end
    if not model:IsDescendantOf(workspace) then return end
    local part = model:FindFirstChildWhichIsA("BasePart")
    if not part then return end
    if (part.Position - RootPart.Position).Magnitude <= PLANT_RANGE then
        local esp = createPlantBillboard(model)
        PlantESPs[model] = esp
        updatePlantESP(model)
    end
end

local function removePlantESP(model)
    local esp = PlantESPs[model]
    if esp and model:IsDescendantOf(workspace) then
        local part = model:FindFirstChildWhichIsA("BasePart")
        if part and (part.Position - RootPart.Position).Magnitude > PLANT_RANGE + 10 then
            esp:Destroy()
            PlantESPs[model] = nil
        end
    end
end

local function clearAllPlantESP()
    for model, esp in pairs(PlantESPs) do
        esp:Destroy()
        PlantESPs[model] = nil
    end
    PlantUpdateQueue = {}
end

local function scanPlants()
    for _, obj in ipairs(workspace:GetDescendants()) do
        if obj:IsA("Model") and CollectionService:HasTag(obj, "Harvestable") then
            trackPlant(obj)
        end
    end
end

-- FIXED Plant ESP Toggle
plantToggle.MouseButton1Click:Connect(function()
    plantESPEnabled = not plantESPEnabled
    if plantESPEnabled then
        plantToggle.Text = "PLANT ESP: ON"
        plantToggle.TextColor3 = Color3.fromRGB(100, 255, 100)
        plantStatusLabel.Text = "Plant ESP enabled!"
        scanPlants()
    else
        plantToggle.Text = "PLANT ESP: OFF"
        plantToggle.TextColor3 = Color3.fromRGB(255, 100, 100)
        plantStatusLabel.Text = "Plant ESP disabled!"
        clearAllPlantESP()
    end
    task.delay(2, function() plantStatusLabel.Text = "" end)
end)

-- Plant Range Slider Functionality
local plantSliderDragging = false
plantRangeSlider.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        plantSliderDragging = true
    end
end)

plantRangeSlider.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        plantSliderDragging = false
    end
end)

game:GetService("UserInputService").InputChanged:Connect(function(input)
    if plantSliderDragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
        local mousePos = input.Position.X
        local sliderPos = plantRangeSlider.AbsolutePosition.X
        local sliderSize = plantRangeSlider.AbsoluteSize.X
        local relativePos = math.clamp((mousePos - sliderPos) / sliderSize, 0, 1)
        
        PLANT_RANGE = math.floor(10 + relativePos * 190) -- Range from 10 to 200
        plantRangeFill.Size = UDim2.new(relativePos, 0, 1, 0)
        plantRangeLabel.Text = "Range: "..PLANT_RANGE
        
        -- Update ESPs with new range
        if plantESPEnabled then
            clearAllPlantESP()
            scanPlants()
        end
    end
end)

-- Egg ESP Functionality -------------------------------------------------------
local eggESPEnabled = false
local ESPCache = {}
local ActiveEggs = {}
local Camera = workspace.CurrentCamera
local EggPets = {}

local function GetPetName(Egg)
    local EggID = Egg:GetAttribute("OBJECT_UUID")
    return EggPets[EggID] or "?"
end

local function AddESP(Egg)
    if not eggESPEnabled then return end
    if Egg:GetAttribute("OWNER") ~= LocalPlayer.Name then return end

    local EggID = Egg:GetAttribute("OBJECT_UUID")
    if not EggID then return end

    local PetName = GetPetName(Egg)

    local Label = Drawing.new("Text")
    Label.Text = PetName
    Label.Size = 18
    Label.Color = Color3.new(1, 1, 1)
    Label.Outline = true
    Label.OutlineColor = Color3.new(0, 0, 0)
    Label.Center = true
    Label.Visible = false

    ESPCache[EggID] = Label
    ActiveEggs[EggID] = Egg
end

local function RemoveESP(Egg)
    local EggID = Egg:GetAttribute("OBJECT_UUID")
    if ESPCache[EggID] then
        ESPCache[EggID]:Remove()
        ESPCache[EggID] = nil
    end
    ActiveEggs[EggID] = nil
end

local function UpdateESP()
    if not eggESPEnabled then return end
    for EggID, Egg in pairs(ActiveEggs) do
        if not Egg or not Egg:IsDescendantOf(workspace) then
            RemoveESP(Egg)
            continue
        end

        local Label = ESPCache[EggID]
        if Label then
            Label.Text = GetPetName(Egg)

            local Position, OnScreen = Camera:WorldToViewportPoint(Egg:GetPivot().Position)
            if OnScreen then
                Label.Position = Vector2.new(Position.X, Position.Y)
                Label.Visible = true
            else
                Label.Visible = false
            end
        end
    end
end

local function clearAllEggESP()
    for EggID, Label in pairs(ESPCache) do
        Label:Remove()
        ESPCache[EggID] = nil
    end
    ActiveEggs = {}
end

local function scanEggs()
    for _, Egg in pairs(CollectionService:GetTagged("PetEggServer")) do
        task.spawn(AddESP, Egg)
    end
end

local function setupEggData()
    local success, result = pcall(function()
        -- Get egg data from the game
        local HatchFunction = debug.getupvalue(debug.getupvalue(getconnections(ReplicatedStorage.GameEvents.PetEggService.OnClientEvent)[1].Function, 1), 2)
        EggPets = debug.getupvalue(HatchFunction, 2)
        
        -- Hook the hatch function to update ESP labels
        local OriginalHatchFunction = getconnections(ReplicatedStorage.GameEvents.EggReadyToHatch_RE.OnClientEvent)[1].Function
        hookfunction(OriginalHatchFunction, function(EggID, PetName)
            if ESPCache[EggID] then
                ESPCache[EggID].Text = PetName
            end
            return OriginalHatchFunction(EggID, PetName)
        end)
    end)
    
    if not success then
        eggStatusLabel.Text = "Failed to setup Egg ESP"
        task.delay(2, function() eggStatusLabel.Text = "" end)
        return false
    end
    return true
end

-- Egg ESP Toggle
eggToggle.MouseButton1Click:Connect(function()
    eggESPEnabled = not eggESPEnabled
    if eggESPEnabled then
        if setupEggData() then
            eggToggle.Text = "EGG ESP: ON"
            eggToggle.TextColor3 = Color3.fromRGB(100, 255, 100)
            eggStatusLabel.Text = "Egg ESP enabled!"
            scanEggs()
        else
            eggESPEnabled = false
            eggToggle.Text = "EGG ESP: OFF"
            eggToggle.TextColor3 = Color3.fromRGB(255, 100, 100)
        end
    else
        eggToggle.Text = "EGG ESP: OFF"
        eggToggle.TextColor3 = Color3.fromRGB(255, 100, 100)
        eggStatusLabel.Text = "Egg ESP disabled!"
        clearAllEggESP()
    end
    task.delay(2, function() eggStatusLabel.Text = "" end)
end)

-- CollectionService events
CollectionService:GetInstanceAddedSignal("Harvestable"):Connect(function(obj)
    if obj:IsA("Model") and plantESPEnabled then
        trackPlant(obj)
    end
end)

CollectionService:GetInstanceRemovedSignal("Harvestable"):Connect(function(obj)
    if obj:IsA("Model") then
        untrackPlant(obj)
    end
end)

CollectionService:GetInstanceAddedSignal("PetEggServer"):Connect(function(Egg)
    if eggESPEnabled then
        AddESP(Egg)
    end
end)

CollectionService:GetInstanceRemovedSignal("PetEggServer"):Connect(function(Egg)
    RemoveESP(Egg)
end)

-- Character handling
LocalPlayer.CharacterAdded:Connect(function(char)
    Character = char
    RootPart = char:WaitForChild("HumanoidRootPart")
end)

-- Plant ESP update loop
task.spawn(function()
    while true do
        if plantESPEnabled then
            local now = tick()
            for model, _ in pairs(PlantUpdateQueue) do
                if not model:IsDescendantOf(workspace) then
                    untrackPlant(model)
                else
                    createPlantESP(model)
                    removePlantESP(model)
                    if PlantESPs[model] and now >= PlantUpdateQueue[model] then
                        updatePlantESP(model)
                        PlantUpdateQueue[model] = now + 3 + math.random()
                    end
                end
            end
        end
        task.wait(0.3)
    end
end)

-- Egg ESP update loop
RunService.PreRender:Connect(UpdateESP)

-- Seed Spinner Functionality ---------------------------------------------------
local selectedPack = ""
local selectedSeed = ""

local function showDropdown(options, position, callback)
    for _, child in ipairs(mainFrame:GetChildren()) do
        if child.Name == "DropdownFrame" then
            child:Destroy()
        end
    end
    
    local frame = Instance.new("Frame")
    frame.Name = "DropdownFrame"
    frame.Size = UDim2.new(0.8, 0, 0.6, 0)
    frame.Position = position
    frame.BackgroundColor3 = Color3.fromRGB(50, 50, 70)
    frame.BorderSizePixel = 0
    frame.ZIndex = 5
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0.05, 0)
    corner.Parent = frame
    
    local scroll = Instance.new("ScrollingFrame")
    scroll.Size = UDim2.new(1, 0, 1, 0)
    scroll.BackgroundTransparency = 1
    scroll.ScrollBarThickness = 6
    scroll.CanvasSize = UDim2.new(0, 0, 0, 0)
    scroll.ZIndex = 5
    
    local layout = Instance.new("UIListLayout")
    layout.Parent = scroll
    
    for _, option in ipairs(options) do
        local button = Instance.new("TextButton")
        button.Size = UDim2.new(1, 0, 0, 30)
        button.BackgroundColor3 = Color3.fromRGB(60, 60, 80)
        button.Text = option.text
        button.Font = Enum.Font.SciFi
        button.TextColor3 = Color3.fromRGB(200, 200, 255)
        button.TextSize = 14
        button.ZIndex = 6
        
        button.MouseButton1Click:Connect(function()
            callback(option.value, option.text)
            frame:Destroy()
        end)
        
        button.Parent = scroll
    end
    
    layout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        scroll.CanvasSize = UDim2.new(0, 0, 0, layout.AbsoluteContentSize.Y)
    end)
    
    scroll.Parent = frame
    frame.Parent = mainFrame
    
    local connection
    connection = game:GetService("UserInputService").InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            local pos = input.Position
            local absPos = frame.AbsolutePosition
            local absSize = frame.AbsoluteSize
            
            if pos.X < absPos.X or pos.X > absPos.X + absSize.X or
               pos.Y < absPos.Y or pos.Y > absPos.Y + absSize.Y then
                frame:Destroy()
                connection:Disconnect()
            end
        end
    end)
end

packDropdown.MouseButton1Click:Connect(function()
    local packOptions = {}
    for packName, _ in pairs(SeedPackData.Packs) do
        table.insert(packOptions, {text = packName, value = packName})
    end
    table.sort(packOptions, function(a, b) return a.text < b.text end)
    
    showDropdown(packOptions, UDim2.new(0.1, 0, 0.2, 0), function(value, text)
        selectedPack = value
        packDropdown.Text = text
        seedDropdown.Text = "SELECT SEED"
        selectedSeed = ""
    end)
end)

seedDropdown.MouseButton1Click:Connect(function()
    if selectedPack == "" or not SeedPackData.Packs[selectedPack] then
        statusLabel.Text = "Select a pack first!"
        task.delay(2, function() statusLabel.Text = "" end)
        return
    end
    
    local seedOptions = {}
    for _, seedData in ipairs(SeedPackData.Packs[selectedPack].Items) do
        local seedName = seedData.Name or seedData.RewardId or "Unknown"
        table.insert(seedOptions, {text = seedName, value = seedName})
    end
    
    showDropdown(seedOptions, UDim2.new(0.1, 0, 0.4, 0), function(value, text)
        selectedSeed = value
        seedDropdown.Text = text
    end)
end)

spinButton.MouseButton1Click:Connect(function()
    if selectedPack == "" or selectedSeed == "" then
        statusLabel.Text = "Select both pack and seed!"
        task.delay(2, function() statusLabel.Text = "" end)
        return
    end
    
    if not SeedPackData.Packs[selectedPack] then
        statusLabel.Text = "Invalid pack selected!"
        task.delay(2, function() statusLabel.Text = "" end)
        return
    end
    
    local items = SeedPackData.Packs[selectedPack].Items
    local index = 1
    local seedData = nil
    
    for i, item in ipairs(items) do
        if (item.Name and item.Name == selectedSeed) or (item.RewardId and item.RewardId == selectedSeed) then
            index = i
            seedData = item
            break
        end
    end
    
    if not seedData then
        statusLabel.Text = "Seed not found in pack!"
        task.delay(2, function() statusLabel.Text = "" end)
        return
    end
    
    local success, err = pcall(function()
        SeedPackController:Spin({
            seedPackType = selectedPack,
            resultIndex = index
        })
        
        statusLabel.Text = "Obtained: "..selectedSeed
        task.delay(2, function() statusLabel.Text = "" end)
    end)
    
    if not success then
        statusLabel.Text = "Error: "..tostring(err)
        task.delay(2, function() statusLabel.Text = "" end)
    end
end)

-- Final assembly
mainFrame.Parent = gui
gui.Parent = game.Players.LocalPlayer:WaitForChild("PlayerGui")
