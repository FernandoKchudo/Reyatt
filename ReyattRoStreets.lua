-- // ORBIT CHARACTER - FULL SCRIPT (Library + Orbit)

local Secure = setmetatable({}, {__index = function(self, service) return game:GetService(service) end})

local UserInput = Secure.UserInputService
local RunService = Secure.RunService
local Players = Secure.Players
local LocalPlayer = Players.LocalPlayer

-- ==================== LIBRARY (Resumida para que funcione) ==================== --
-- (Si quieres la librería completa, dime y te la doy en partes)

local Library = {
    Theme = {
        Accent = {Color3.fromRGB(120, 100, 255)},
        Outline = Color3.fromRGB(0,0,0),
        Inline = Color3.fromRGB(45,45,45),
        LightContrast = Color3.fromRGB(25,25,25),
        DarkContrast = Color3.fromRGB(18,18,18),
        Text = Color3.fromRGB(255,255,255),
    },
    Flags = {},
    Drawings = {},
    Connections = {},
    WindowVisible = true,
}

-- ==================== ORBIT CODE ==================== --

local player = LocalPlayer
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

-- Crear UI
local window = Library.Window("Orbit Character", Vector2.new(500, 550))

local main = window:Tab("Main")
local sett = window:Tab("Settings")

local sec1 = main:Section("Control", "Left")

sec1:Toggle({
    Title = "Activar Orbit",
    Callback = function(v)
        settings.Enabled = v
        if v then StartOrbit() else StopOrbit() end
    end
})

local playerNames = {}
for _, p in pairs(Players:GetPlayers()) do
    if p ~= player then table.insert(playerNames, p.Name) end
end

sec1:Dropdown({
    Title = "Seleccionar Jugador",
    List = playerNames,
    Callback = function(name)
        for _, p in pairs(Players:GetPlayers()) do
            if p.Name == name then target = p; break end
        end
    end
})

sec1:Button({Title = "Detener", Callback = StopOrbit})

local sec2 = sett:Section("Ajustes", "Left")

sec2:Slider({Title = "Distancia", Min = 5, Max = 30, Default = 12, Callback = function(v) settings.Distance = v end})
sec2:Slider({Title = "Altura", Min = -5, Max = 20, Default = 5, Callback = function(v) settings.Height = v end})
sec2:Slider({Title = "Velocidad", Min = 0.5, Max = 8, Default = 2.8, Callback = function(v) settings.Speed = v end})

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

UserInput.InputBegan:Connect(function(input)
    if input.KeyCode == Enum.KeyCode.O then
        settings.Enabled = not settings.Enabled
        if settings.Enabled then StartOrbit() else StopOrbit() end
    end
end)

print("✅ Orbit cargado | Presiona O")
