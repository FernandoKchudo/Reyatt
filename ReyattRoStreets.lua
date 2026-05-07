-- // ORBIT CHARACTER - Menú Simple y Funcional

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")

local player = Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local root = character:WaitForChild("HumanoidRootPart")
local humanoid = character:WaitForChild("Humanoid")

local target = nil
local orbiting = false
local angle = 0
local connection

local settings = {
    Distance = 12,
    Height = 5,
    Speed = 2.8,
    Enabled = false
}

-- ==================== MENÚ ==================== --
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "OrbitMenu"
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = player:WaitForChild("PlayerGui")

local Frame = Instance.new("Frame")
Frame.Size = UDim2.new(0, 320, 0, 420)
Frame.Position = UDim2.new(0.5, -160, 0.5, -210)
Frame.BackgroundColor3 = Color3.fromRGB(25, 25, 35)
Frame.BorderSizePixel = 0
Frame.Parent = ScreenGui

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, 0, 0, 50)
Title.BackgroundColor3 = Color3.fromRGB(15, 15, 25)
Title.Text = "🔄 Orbit Character"
Title.TextColor3 = Color3.new(1,1,1)
Title.TextScaled = true
Title.Font = Enum.Font.GothamBold
Title.Parent = Frame

-- Toggle
local ToggleBtn = Instance.new("TextButton")
ToggleBtn.Size = UDim2.new(0.9, 0, 0, 50)
ToggleBtn.Position = UDim2.new(0.05, 0, 0, 70)
ToggleBtn.BackgroundColor3 = Color3.fromRGB(0, 170, 0)
ToggleBtn.Text = "ACTIVAR ORBIT"
ToggleBtn.TextColor3 = Color3.new(1,1,1)
ToggleBtn.TextScaled = true
ToggleBtn.Font = Enum.Font.GothamBold
ToggleBtn.Parent = Frame

-- Target
local TargetLabel = Instance.new("TextLabel")
TargetLabel.Size = UDim2.new(0.9, 0, 0, 30)
TargetLabel.Position = UDim2.new(0.05, 0, 0, 130)
TargetLabel.BackgroundTransparency = 1
TargetLabel.Text = "Target: Ninguno"
TargetLabel.TextColor3 = Color3.new(1,1,1)
TargetLabel.TextScaled = true
TargetLabel.Parent = Frame

-- Sliders
local function createSlider(name, min, max, default, pos, callback)
    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(0.9,0,0,20)
    label.Position = UDim2.new(0.05,0,0,pos)
    label.BackgroundTransparency = 1
    label.Text = name .. ": " .. default
    label.TextColor3 = Color3.new(1,1,1)
    label.TextScaled = true
    label.Parent = Frame

    local slider = Instance.new("Frame")
    slider.Size = UDim2.new(0.9,0,0,10)
    slider.Position = UDim2.new(0.05,0,0,pos+25)
    slider.BackgroundColor3 = Color3.fromRGB(50,50,50)
    slider.Parent = Frame

    local fill = Instance.new("Frame")
    fill.Size = UDim2.new(0.5,0,1,0)
    fill.BackgroundColor3 = Color3.fromRGB(0, 170, 255)
    fill.Parent = slider

    local value = default
    callback(value)

    slider.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            local mouseMove = UserInputService.InputChanged:Connect(function(move)
                if move.UserInputType == Enum.UserInputType.MouseMovement then
                    local percent = math.clamp((mouse.X - slider.AbsolutePosition.X) / slider.AbsoluteSize.X, 0, 1)
                    value = math.floor(min + (max - min) * percent)
                    fill.Size = UDim2.new(percent, 0, 1, 0)
                    label.Text = name .. ": " .. value
                    callback(value)
                end
            end)
            local release
            release = UserInputService.InputEnded:Connect(function()
                mouseMove:Disconnect()
                release:Disconnect()
            end)
        end
    end)
end

-- Sliders
createSlider("Distancia", 5, 30, 12, 170, function(v) settings.Distance = v end)
createSlider("Altura", -5, 20, 5, 220, function(v) settings.Height = v end)
createSlider("Velocidad", 0.5, 8, 2.8, 270, function(v) settings.Speed = v end)

-- Funciones Orbit
function StartOrbit()
    if connection then connection:Disconnect() end
    connection = RunService.Heartbeat:Connect(function(dt)
        if not settings.Enabled or not target or not target.Character then return end
        local tRoot = target.Character:FindFirstChild("HumanoidRootPart")
        if not tRoot then return end

        angle += settings.Speed * 50 * dt
        local x = math.sin(math.rad(angle)) * settings.Distance
        local z = math.cos(math.rad(angle)) * settings.Distance

        local newPos = tRoot.Position + Vector3.new(x, settings.Height, z)
        root.CFrame = CFrame.lookAt(newPos, tRoot.Position)
        humanoid:MoveTo(newPos)
    end)
end

function StopOrbit()
    if connection then connection:Disconnect() end
    angle = 0
    if humanoid then humanoid:MoveTo(root.Position) end
end

ToggleBtn.MouseButton1Click:Connect(function()
    settings.Enabled = not settings.Enabled
    ToggleBtn.Text = settings.Enabled and "DESACTIVAR ORBIT" or "ACTIVAR ORBIT"
    ToggleBtn.BackgroundColor3 = settings.Enabled and Color3.fromRGB(170,0,0) or Color3.fromRGB(0,170,0)
    
    if settings.Enabled then
        StartOrbit()
    else
        StopOrbit()
    end
end)

-- Atajo O
UserInputService.InputBegan:Connect(function(input)
    if input.KeyCode == Enum.KeyCode.O then
        settings.Enabled = not settings.Enabled
        ToggleBtn.Text = settings.Enabled and "DESACTIVAR ORBIT" or "ACTIVAR ORBIT"
        ToggleBtn.BackgroundColor3 = settings.Enabled and Color3.fromRGB(170,0,0) or Color3.fromRGB(0,170,0)
        if settings.Enabled then StartOrbit() else StopOrbit() end
    end
end)

-- Seleccionar primer target
for _, plr in pairs(Players:GetPlayers()) do
    if plr ~= player then
        target = plr
        TargetLabel.Text = "Target: " .. plr.Name
        break
    end
end

print("✅ Menú de Orbit cargado correctamente")
print("Presiona 'O' para activar/desactivar")
