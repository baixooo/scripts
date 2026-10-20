local plr = game.Players.LocalPlayer
local char = plr.Character or plr.CharacterAdded:Wait()
local hum = char:WaitForChild("Humanoid")

hum.WalkSpeed = 100
hum.JumpPower = 200

print("Super pulo e velocidade ativados!")