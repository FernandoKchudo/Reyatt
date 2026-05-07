-- // ORBIT CHARACTER - Versión Potente con Debug

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")

local player = Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local root = character:WaitForChild("HumanoidRootPart")
local humanoid = character:WaitForChild("Humanoid")

local target = nil
local enabled = false
local angle = 0
local connection

local settings = {
    Distance = 15,
    Height = 6,
    Speed = 3.5
}

-- ==================== MENÚ ==================== --
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "OrbitMenu"
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = player:WaitForChild("PlayerGui")

local Frame = Instance.new("Frame")
Frame.Size = UDim2.new(0, 380, 0, 340)
Frame.Position = UDim2.new(0.5, -190, 0.5, -170)
Frame.BackgroundColor3 = Color3.fromRGB(20, 20, 30)
Frame.BorderSizePixel = 0
Frame.Parent = ScreenGui

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1,0,0,50)
Title.BackgroundColor3 = Color3.fromRGB(10,10,25)
Title.Text = "🔄 Orbit Character"
Title.TextColor3 = Color3.new(1,1,1)
Title.TextScaled = true
Title.Font = Enum.Font.GothamBold
Title.Parent = Frame

local ToggleBtn = Instance.new("TextButton")
ToggleBtn.Size = UDim2.new(0.85,0,0,65)
ToggleBtn.Position = UDim2.new(0.075,0,0,70)
ToggleBtn.BackgroundColor3 = Color3.fromRGB(0,170,0)
ToggleBtn.Text = "ACTIVAR ORBIT"
ToggleBtn.TextColor3 = Color3.new(1,1,1)
ToggleBtn.TextScaled = true
ToggleBtn.Font = Enum.Font.GothamBold
ToggleBtn.Parent = Frame

local DebugText = Instance.new("TextLabel")
DebugText.Size = UDim2.new(0.85,0,0,100)
DebugText.Position = UDim2.new(0.075,0,0,160)
DebugText.BackgroundTransparency = 1
DebugText.Text = "Debug:\nEsperando..."
DebugText.TextColor3 = Color3.new(1,1,1)
DebugText.TextScaled = true
DebugText.TextXAlignment = Enum.TextXAlignment.Left
DebugText.Parent = Frame

-- Seleccionar target
for _, plr in pairs(Players:GetPlayers()) do
    if plr ~= player and plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") then
        target = plr
        DebugText.Text = "Debug:\nTarget: " .. plr.Name
        break
    end
end

-- Funciones Orbit Mejoradas
function StartOrbit()
    if connection then connection:Disconnect() end
    
    connection = RunService.Heartbeat:Connect(function(dt)
        if not enabled then return end
        if not target or not target.Character then 
            DebugText.Text = "Debug:\nTarget perdido"
            return 
        end
        
        local tRoot = target.Character:FindFirstChild("HumanoidRootPart")
        if not tRoot then return end

        angle += settings.Speed * 55 * dt

        local x = math.sin(math.rad(angle)) * settings.Distance
        local z = math.cos(math.rad(angle)) * settings.Distance

        local newPos = tRoot.Position + Vector3.new(x, settings.Height, z)
        
        -- Movimiento más directo
        root.CFrame = CFrame.lookAt(newPos, tRoot.Position)
        
        DebugText.Text = "Debug:\nOrbitando a: " .. target.Name .. "\nDistancia: " .. settings.Distance
    end)
end

function StopOrbit()
    if connection then connection:Disconnect() end
    angle = 0
    DebugText.Text = "Debug:\nOrbit detenido"
end

-- Controles
ToggleBtn.MouseButton1Click:Connect(function()
    enabled = not enabled
    ToggleBtn.Text = enabled and "DESACTIVAR ORBIT" or "ACTIVAR ORBIT"
    ToggleBtn.BackgroundColor3 = enabled and Color3.fromRGB(170,0,0) or Color3.fromRGB(0,170,0)
    
    if enabled then
        StartOrbit()
    else
        StopOrbit()
    end
end)

UserInputService.InputBegan:Connect(function(input)
    if input.KeyCode == Enum.KeyCode.O then
        enabled = not enabled
        ToggleBtn.Text = enabled and "DESACTIVAR ORBIT" or "ACTIVAR ORBIT"
        ToggleBtn.BackgroundColor3 = enabled and Color3.fromRGB(170,0,0) or Color3.fromRGB(0,170,0)
        
        if enabled then
            StartOrbit()
        else
            StopOrbit()
        end
    end
end)

print("✅ Orbit Mejorado cargado")
print("Presiona O o usa el botón")
