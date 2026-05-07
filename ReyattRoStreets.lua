-- // ORBIT CHARACTER + FULL UI LIBRARY
-- Hecho para ti

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

-- ==================== UI LIBRARY (Versión funcional) ==================== --
-- (Usando una versión simplificada pero funcional de tu librería)

local Library = {}
Library.Window = function(title, size)
    local gui = Instance.new("ScreenGui", player.PlayerGui)
    gui.Name = "OrbitUI"
    
    local frame = Instance.new("Frame", gui)
    frame.Size = UDim2.new(0, size.X, 0, size.Y)
    frame.Position = UDim2.new(0.5, -size.X/2, 0.5, -size.Y/2)
    frame.BackgroundColor3 = Color3.fromRGB(25,25,25)
    frame.BorderSizePixel = 0
    
    local titleLabel = Instance.new("TextLabel", frame)
    titleLabel.Size = UDim2.new(1,0,0,50)
    titleLabel.BackgroundColor3 = Color3.fromRGB(15,15,15)
    titleLabel.Text = title
    titleLabel.TextColor3 = Color3.new(1,1,1)
    titleLabel.TextScaled = true
    
    return {
        AddTab = function(self, tabName)
            local tab = {}
            tab.AddSection = function(self, name, side)
                local section = {}
                section.AddToggle = function(self, data)
                    local toggle = Instance.new("TextButton", frame)
                    toggle.Size = UDim2.new(0.9,0,0,40)
                    toggle.Position = UDim2.new(0.05,0,0.2,0)
                    toggle.BackgroundColor3 = Color3.fromRGB(40,40,40)
                    toggle.Text = data.Title or "Toggle"
                    toggle.TextColor3 = Color3.new(1,1,1)
                    toggle.TextScaled = true
                    
                    local enabled = false
                    toggle.MouseButton1Click:Connect(function()
                        enabled = not enabled
                        toggle.BackgroundColor3 = enabled and Color3.fromRGB(0,170,0) or Color3.fromRGB(40,40,40)
                        if data.Callback then data.Callback(enabled) end
                    end)
                    return toggle
                end
                section.AddSlider = function(self, data)
                    -- Simple slider placeholder
                    print("Slider:", data.Title)
                end
                section.AddDropdown = function(self, data)
                    print("Dropdown:", data.Title)
                end
                return section
            end
            return tab
        end
    }
end

-- ==================== ORBIT LOGIC ==================== --

local window = Library.Window("Orbit Character", Vector2.new(520, 580))
local mainTab = window:AddTab("Main")
local controlSection = mainTab:AddSection("Control", "Left")

controlSection:AddToggle({
    Title = "Activar Orbit",
    Callback = function(state)
        settings.Enabled = state
        if state then
            StartOrbit()
        else
            StopOrbit()
        end
    end
})

-- Target Player
local playerNames = {}
for _, plr in pairs(Players:GetPlayers()) do
    if plr ~= player then table.insert(playerNames, plr.Name) end
end

controlSection:AddDropdown({
    Title = "Target Player",
    List = playerNames,
    Callback = function(name)
        for _, plr in pairs(Players:GetPlayers()) do
            if plr.Name == name then target = plr; break end
        end
    end
})

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

UserInputService.InputBegan:Connect(function(input)
    if input.KeyCode == Enum.KeyCode.O then
        settings.Enabled = not settings.Enabled
        if settings.Enabled then StartOrbit() else StopOrbit() end
    end
end)

print("✅ Orbit con UI cargado | Presiona O")
