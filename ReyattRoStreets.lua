-- // ORBIT CHARACTER - Versión Estable

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

-- Seleccionar primer jugador como objetivo
for _, plr in pairs(Players:GetPlayers()) do
    if plr ~= player then
        target = plr
        break
    end
end

function StartOrbit()
    if connection then connection:Disconnect() end
    
    connection = RunService.Heartbeat:Connect(function(dt)
        if not settings.Enabled then return end
        if not target or not target.Character or not target.Character:FindFirstChild("HumanoidRootPart") then return end

        local tRoot = target.Character.HumanoidRootPart
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

-- Atajo de teclado
UserInputService.InputBegan:Connect(function(input, gp)
    if gp then return end
    if input.KeyCode == Enum.KeyCode.O then
        settings.Enabled = not settings.Enabled
        if settings.Enabled then
            StartOrbit()
            print("✅ Orbit ACTIVADO")
        else
            StopOrbit()
            print("❌ Orbit DESACTIVADO")
        end
    end
end)

print("✅ Orbit Character cargado correctamente")
print("Presiona la tecla 'O' para activar/desactivar")
