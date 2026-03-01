import os

filepath = r"c:\Users\saban\OneDrive\Masaüstü\roblox script\vexelbest.lua"

with open(filepath, 'r', encoding='utf-8') as f:
    text = f.read()

# 1. Noclip State Fix and Rotation Lock
old_noclip = """local noclipConnection
local ToggleNoclip = Library:AddToggle(PagePlayer, "Noclip", function(state) 
    SharedState.NoclipActive = state 
    local char = LocalPlayer.Character
    local hrp = char and char:FindFirstChild("HumanoidRootPart")
    local hum = char and char:FindFirstChildOfClass("Humanoid")
    
    if state then
        if hrp then 
            hrp.Velocity = Vector3.new(0,0,0) 
            hrp.RotVelocity = Vector3.new(0,0,0)
        end
        if hum then 
            hum:SetStateEnabled(Enum.HumanoidStateType.FallingDown, false)
            hum:ChangeState(11) -- Noclip
        end

        if not noclipConnection then
            noclipConnection = RunService.Stepped:Connect(function()
                if LocalPlayer.Character then
                    for _, p in pairs(LocalPlayer.Character:GetDescendants()) do
                        if p:IsA("BasePart") and p.CanCollide then
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
            hum:SetStateEnabled(Enum.HumanoidStateType.FallingDown, true)
            hum:ChangeState(8) -- Running/GettingUp
        end
        
        if char then
            if hrp then
                local ray = Ray.new(hrp.Position, Vector3.new(0, -5, 0))
                local hit, pos = Workspace:FindPartOnRay(ray, char)
                if hit then hrp.CFrame = CFrame.new(hrp.Position.X, pos.Y + (hrp.Size.Y/2) + 0.5, hrp.Position.Z) end
            end
            for _, p in pairs(char:GetDescendants()) do if p:IsA("BasePart") then p.CanCollide = true end end
        end
    end
end)"""

new_noclip = """local noclipConnection
local ToggleNoclip = Library:AddToggle(PagePlayer, "Noclip", function(state) 
    SharedState.NoclipActive = state 
    local char = LocalPlayer.Character
    local hrp = char and char:FindFirstChild("HumanoidRootPart")
    local hum = char and char:FindFirstChildOfClass("Humanoid")
    
    if state then
        if hrp then 
            hrp.Velocity = Vector3.new(0,0,0) 
            hrp.RotVelocity = Vector3.new(0,0,0)
        end
        if hum then 
            hum:SetStateEnabled(Enum.HumanoidStateType.FallingDown, false)
            hum:ChangeState(Enum.HumanoidStateType.Physics)
        end

        if not noclipConnection then
            noclipConnection = RunService.Stepped:Connect(function()
                if LocalPlayer.Character then
                    for _, p in pairs(LocalPlayer.Character:GetDescendants()) do
                        if p:IsA("BasePart") and p.CanCollide then
                            p.CanCollide = false
                        end
                    end
                end
            end)
        end
    else
        if noclipConnection then noclipConnection:Disconnect(); noclipConnection = nil end
        local lookVector = nil
        if hrp then 
            lookVector = hrp.CFrame.lookVector
            hrp.Velocity = Vector3.new(0,0,0) 
            hrp.RotVelocity = Vector3.new(0,0,0)
        end
        
        if hum then
            hum:SetStateEnabled(Enum.HumanoidStateType.FallingDown, true)
            hum:ChangeState(Enum.HumanoidStateType.Landing)
            task.delay(0.05, function()
                if hum then hum:ChangeState(Enum.HumanoidStateType.Running) end
            end)
        end
        
        if char then
            if hrp and lookVector then
                local ray = Ray.new(hrp.Position, Vector3.new(0, -5, 0))
                local hit, pos = Workspace:FindPartOnRay(ray, char)
                if hit then 
                    local targetPos = Vector3.new(hrp.Position.X, pos.Y + (hrp.Size.Y/2) + 0.5, hrp.Position.Z)
                    hrp.CFrame = CFrame.new(targetPos, targetPos + lookVector) 
                else
                    hrp.CFrame = CFrame.new(hrp.Position, hrp.Position + lookVector)
                end
            end
            for _, p in pairs(char:GetDescendants()) do if p:IsA("BasePart") then p.CanCollide = true end end
        end
    end
end)"""

if old_noclip in text:
    text = text.replace(old_noclip, new_noclip)
else:
    print("Warning: old_noclip not explicitly found")

with open(filepath, 'w', encoding='utf-8') as f:
    f.write(text)

print("Updated script.")
