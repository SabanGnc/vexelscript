import os
import re

filepath = r"c:\Users\saban\OneDrive\Masaüstü\roblox script\vexelbest.lua"

with open(filepath, 'r', encoding='utf-8') as f:
    text = f.read()

# Pattern to locate the Noclip Toggle.
pattern = re.compile(r'local noclipConnection\n.*?local ToggleNoclip = Library:AddToggle\(PagePlayer, "Noclip".*?end\)', re.DOTALL)

new_noclip = """local noclipConnection
local initialY = 0
local ToggleNoclip = Library:AddToggle(PagePlayer, "Noclip", function(state) 
    print("Noclip Durumu: ", state)
    SharedState.NoclipActive = state 
    local char = LocalPlayer.Character
    local hrp = char and char:FindFirstChild("HumanoidRootPart")
    local hum = char and char:FindFirstChildOfClass("Humanoid")
    
    if state then
        if hrp then initialY = hrp.Position.Y end
        if hum then 
            hum:ChangeState(11)
        end

        if not noclipConnection then
            noclipConnection = RunService.Stepped:Connect(function()
                if LocalPlayer.Character then
                    local currentHrp = LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
                    local currentHum = LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
                    if currentHrp and currentHum then
                        if currentHum.MoveDirection.Magnitude > 0 then
                            currentHrp.Velocity = Vector3.new(currentHrp.Velocity.X, 0, currentHrp.Velocity.Z)
                            currentHrp.CFrame = CFrame.new(currentHrp.Position.X, initialY, currentHrp.Position.Z) * currentHrp.CFrame.Rotation
                        else
                            initialY = currentHrp.Position.Y
                        end
                    end
                    for _, p in pairs(LocalPlayer.Character:GetChildren()) do
                        if p:IsA("BasePart") then
                            p.CanCollide = false
                        end
                    end
                end
            end)
        end
    else
        if noclipConnection then noclipConnection:Disconnect(); noclipConnection = nil end
        
        if hrp then 
            hrp.Velocity = Vector3.new(0,0,0) 
            hrp.RotVelocity = Vector3.new(0,0,0)
        end
        
        if hum then
            hum:ChangeState(8)
        end
    end
end)"""

if pattern.search(text):
    text = pattern.sub(new_noclip, text)
    with open(filepath, 'w', encoding='utf-8') as f:
        f.write(text)
    print("Noclip V4 rebuilt")
else:
    print("Error: Could not find noclip block")
