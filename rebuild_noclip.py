import os

filepath = r"c:\Users\saban\OneDrive\Masaüstü\roblox script\vexelbest.lua"

with open(filepath, 'r', encoding='utf-8') as f:
    text = f.read()

# Replace Noclip logic
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

new_noclip = """local noclipConnection
local noclipVelocity
local ToggleNoclip = Library:AddToggle(PagePlayer, "Noclip", function(state) 
    SharedState.NoclipActive = state 
    local char = LocalPlayer.Character
    local hrp = char and char:FindFirstChild("HumanoidRootPart")
    local hum = char and char:FindFirstChildOfClass("Humanoid")
    
    if state then
        if hrp then 
            hrp.Velocity = Vector3.new(0,0,0) 
            hrp.RotVelocity = Vector3.new(0,0,0)
            
            -- Anti-Fall (Gravity Bypass) during Noclip
            if not noclipVelocity then
                noclipVelocity = Instance.new("BodyVelocity")
                noclipVelocity.MaxForce = Vector3.new(0, 9e9, 0)
                noclipVelocity.Velocity = Vector3.new(0, 0, 0)
                noclipVelocity.Parent = hrp
            end
        end
        
        if hum then 
            hum:SetStateEnabled(Enum.HumanoidStateType.FallingDown, false)
            hum:ChangeState(Enum.HumanoidStateType.Physics)
        end

        -- Smooth Collision Bypass
        if not noclipConnection then
            noclipConnection = RunService.Stepped:Connect(function()
                if LocalPlayer.Character then
                    for _, p in pairs(LocalPlayer.Character:GetChildren()) do
                        if p:IsA("BasePart") then
                            p.CanCollide = false
                        end
                    end
                end
            end)
        end
    else
        -- Clean Disconnect
        if noclipConnection then noclipConnection:Disconnect(); noclipConnection = nil end
        if noclipVelocity then noclipVelocity:Destroy(); noclipVelocity = nil end
        
        local lookVector = nil
        if hrp then 
            lookVector = hrp.CFrame.lookVector
            hrp.Velocity = Vector3.new(0,0,0) 
            hrp.RotVelocity = Vector3.new(0,0,0)
        end
        
        -- Animation Restore
        if hum then
            hum:SetStateEnabled(Enum.HumanoidStateType.FallingDown, true)
            hum:ChangeState(Enum.HumanoidStateType.Landing)
            task.delay(0.05, function()
                if hum then hum:ChangeState(Enum.HumanoidStateType.Running) end
            end)
        end
        
        -- Safe Placement
        if char then
            if hrp and lookVector then
                local ray = Ray.new(hrp.Position, Vector3.new(0, -999, 0))
                local hit, pos = Workspace:FindPartOnRay(ray, char)
                if hit then 
                    -- Prevent getting stuck in ground if we were deeply underground
                    local distance = (hrp.Position.Y - pos.Y)
                    if distance < (hrp.Size.Y / 2) + 0.5 then
                        local targetPos = Vector3.new(hrp.Position.X, pos.Y + (hrp.Size.Y/2) + 0.5, hrp.Position.Z)
                        hrp.CFrame = CFrame.new(targetPos, targetPos + lookVector) 
                    end
                end
            end
            for _, p in pairs(char:GetChildren()) do if p:IsA("BasePart") then p.CanCollide = true end end
        end
    end
end)"""

if old_noclip in text:
    text = text.replace(old_noclip, new_noclip)
else:
    print("Error: Could not find exactly old_noclip. Script has fallen out of sync or had minor changes.")

with open(filepath, 'w', encoding='utf-8') as f:
    f.write(text)

print("Noclip rebuilt")
