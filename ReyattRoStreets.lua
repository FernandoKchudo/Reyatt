print("✅ SCRIPT DE PRUEBA CARGADO CORRECTAMENTE")

local msg = Instance.new("Message")
msg.Text = "¡El script se cargó! Presiona O para probar orbit"
msg.Parent = workspace
task.wait(5)
msg:Destroy()
