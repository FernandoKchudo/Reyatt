-- // ORBIT - MENÚ SIMPLE (Versión que SÍ debe aparecer)

local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")

local player = Players.LocalPlayer

-- Crear Menú
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "OrbitMenu"
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = player:WaitForChild("PlayerGui")

local Frame = Instance.new("Frame")
Frame.Size = UDim2.new(0, 350, 0, 250)
Frame.Position = UDim2.new(0.5, -175, 0.5, -125)
Frame.BackgroundColor3 = Color3.fromRGB(20, 20, 30)
Frame.BorderSizePixel = 0
Frame.Parent = ScreenGui

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, 0, 0, 50)
Title.BackgroundColor3 = Color3.fromRGB(10, 10, 20)
Title.Text = "🔄 Orbit Character"
Title.TextColor3 = Color3.new(1, 1, 1)
Title.TextScaled = true
Title.Font = Enum.Font.GothamBold
Title.Parent = Frame

local Toggle = Instance.new("TextButton")
Toggle.Size = UDim2.new(0.8, 0, 0, 60)
Toggle.Position = UDim2.new(0.1, 0, 0, 70)
Toggle.BackgroundColor3 = Color3.fromRGB(0, 170, 0)
Toggle.Text = "ACTIVAR ORBIT"
Toggle.TextColor3 = Color3.new(1,1,1)
Toggle.TextScaled = true
Toggle.Font = Enum.Font.GothamBold
Toggle.Parent = Frame

local Status = Instance.new("TextLabel")
Status.Size = UDim2.new(1, 0, 0, 30)
Status.Position = UDim2.new(0, 0, 0, 150)
Status.BackgroundTransparency = 1
Status.Text = "Presiona 'O' o haz click"
Status.TextColor3 = Color3.new(1,1,1)
Status.TextScaled = true
Status.Parent = Frame

print("✅ Menú creado correctamente")

-- Variables
local enabled = false

Toggle.MouseButton1Click:Connect(function()
    enabled = not enabled
    Toggle.Text = enabled and "DESACTIVAR ORBIT" or "ACTIVAR ORBIT"
    Toggle.BackgroundColor3 = enabled and Color3.fromRGB(170, 0, 0) or Color3.fromRGB(0, 170, 0)
    print(enabled and "Orbit ACTIVADO" or "Orbit DESACTIVADO")
end)

UserInputService.InputBegan:Connect(function(input)
    if input.KeyCode == Enum.KeyCode.O then
        enabled = not enabled
        Toggle.Text = enabled and "DESACTIVAR ORBIT" or "ACTIVAR ORBIT"
        Toggle.BackgroundColor3 = enabled and Color3.fromRGB(170, 0, 0) or Color3.fromRGB(0, 170, 0)
        print(enabled and "Orbit ACTIVADO" or "Orbit DESACTIVADO")
    end
end)
