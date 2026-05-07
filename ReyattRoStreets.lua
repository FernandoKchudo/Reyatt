-- // ORBIT CHARACTER - Versión Corregida

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

-- Crear Menú Simple (sin librería pesada)
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "OrbitMenu"
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = player:WaitForChild("PlayerGui")

local Frame = Instance.new("Frame")
Frame.Size = UDim2.new(0, 300, 0, 400)
Frame.Position = UDim2.new(0.5, -150, 0.5, -200)
Frame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
Frame.BorderSizePixel = 0
Frame.Parent = ScreenGui

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, 0, 0, 50)
Title.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
Title.Text = "🔄 Orbit Character"
Title.TextColor3 = Color3.new(1,1,1)
Title.TextScaled = true
Title.Parent = Frame

-- Botones simples
local ToggleBtn = Instance.new("TextButton")
ToggleBtn.Size = UDim2.new(0.9, 0, 0, 50)
ToggleBtn.Position = UDim2.new(0.05, 0, 0, 70)
ToggleBtn.BackgroundColor3 = Color3.fromRGB(0, 170, 0)
ToggleBtn.Text = "Activar Orbit"
ToggleBtn.TextColor3 = Color3.new(1,1,1)
ToggleBtn.TextScaled = true
ToggleBtn.Parent = Frame

local StopBtn = Instance.new("TextButton")
StopBtn.Size = UDim2.new(0.9, 0, 0, 50)
StopBtn.Position = UDim2.new(0.05, 0, 0, 130)
StopBtn.BackgroundColor3 = Color3.fromRGB(170, 0, 0)
StopBtn.Text = "Detener Orbit"
StopBtn.TextColor3 = Color3.new(1,1,1)
StopBtn.TextScaled = true
StopBtn.Parent = Frame

-- Funciones
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
    ToggleBtn.Text = settings.Enabled and "Desactivar Orbit" or "Activar Orbit"
    ToggleBtn.BackgroundColor3 = settings.Enabled and Color3.fromRGB(170,0,0) or Color3.fromRGB(0,170,0)
    if settings.Enabled then StartOrbit() else StopOrbit() end
end)

StopBtn.MouseButton1Click:Connect(StopOrbit)

-- Seleccionar primer jugador como target
for _, plr in pairs(Players:GetPlayers()) do
    if plr ~= player then
        target = plr
        break
    end
end

UserInputService.InputBegan:Connect(function(input)
    if input.KeyCode == Enum.KeyCode.O then
        settings.Enabled = not settings.Enabled
        ToggleBtn.Text = settings.Enabled and "Desactivar Orbit" or "Activar Orbit"
        ToggleBtn.BackgroundColor3 = settings.Enabled and Color3.fromRGB(170,0,0) or Color3.fromRGB(0,170,0)
        if settings.Enabled then StartOrbit() else StopOrbit() end
    end
end)

print("✅ Orbit cargado correctamente | Presiona O")
