-- // ORBIT SIMPLE - Versión de Prueba

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInput = game:GetService("UserInputService")

local player = Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local root = character:WaitForChild("HumanoidRootPart")
local humanoid = character:WaitForChild("Humanoid")

local target = nil
local orbiting = false
local angle = 0
local conn

local settings = {Distance = 12, Height = 6, Speed = 3, Enabled = false}

-- Seleccionar primer jugador
for _, plr in pairs(Players:GetPlayers()) do
    if plr ~= player then target = plr; break end
end

function StartOrbit()
    if conn then conn:Disconnect() end
    conn = RunService.Heartbeat:Connect(function(dt)
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
    if conn then conn:Disconnect() end
    angle = 0
    if humanoid then humanoid:MoveTo(root.Position) end
end

-- Atajo
UserInput.InputBegan:Connect(function(input)
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

print("✅ Script Orbit cargado | Presiona la tecla O")
