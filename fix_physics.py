import os

filepath = r"c:\Users\saban\OneDrive\Masaüstü\roblox script\vexelbest.lua"

with open(filepath, 'r', encoding='utf-8') as f:
    text = f.read()

# 1. Noclip Fix
old_noclip = """local noclipConnection
local noclipBodyVel
local ToggleNoclip = Library:AddToggle(PagePlayer, "Noclip", function(state) 
    SharedState.NoclipActive = state 
    local char = LocalPlayer.Character
    local hrp = char and char:FindFirstChild("HumanoidRootPart")
    
    if state then
        if hrp then hrp.Velocity = Vector3.new(0,0,0) end
        if hrp and not noclipBodyVel then
            noclipBodyVel = Instance.new("BodyVelocity")
            noclipBodyVel.MaxForce = Vector3.new(0, 9e4, 0)
            noclipBodyVel.Velocity = Vector3.new(0, 0, 0)
            noclipBodyVel.Parent = hrp
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
        if noclipBodyVel then noclipBodyVel:Destroy(); noclipBodyVel = nil end
        if hrp then hrp.Velocity = Vector3.new(0,0,0) end
        
        if LocalPlayer.Character then
            if hrp then
                local ray = Ray.new(hrp.Position, Vector3.new(0, -5, 0))
                local hit, pos = Workspace:FindPartOnRay(ray, LocalPlayer.Character)
                if hit then hrp.CFrame = CFrame.new(hrp.Position.X, pos.Y + (hrp.Size.Y/2) + 0.5, hrp.Position.Z) end
            end
            for _, p in pairs(LocalPlayer.Character:GetDescendants()) do if p:IsA("BasePart") then p.CanCollide = true end end
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

if old_noclip in text:
    text = text.replace(old_noclip, new_noclip)
else:
    print("Warning: old_noclip not explicitly found")

# 2. Freecam Mouse Fix
old_freecam = """local ToggleFreecam = Library:AddToggle(PagePlayer, "Freecam 3D", function(state)
    SharedState.Freecam = state
    local char = LocalPlayer.Character
    if state then
        if char and char:FindFirstChild("HumanoidRootPart") then char.HumanoidRootPart.Anchored = true end
        Camera.CameraType = Enum.CameraType.Scriptable
        local x, y, z = Camera.CFrame:ToOrientation()
        fcYaw, fcPitch = y, x
    else
        if char and char:FindFirstChild("HumanoidRootPart") then char.HumanoidRootPart.Anchored = false end
        Camera.CameraType = Enum.CameraType.Custom; Camera.CameraSubject = char and char:FindFirstChildOfClass("Humanoid")
    end
end)"""

new_freecam = """local ToggleFreecam = Library:AddToggle(PagePlayer, "Freecam 3D", function(state)
    SharedState.Freecam = state
    local char = LocalPlayer.Character
    if state then
        if char and char:FindFirstChild("HumanoidRootPart") then char.HumanoidRootPart.Anchored = true end
        Camera.CameraType = Enum.CameraType.Scriptable
        local x, y, z = Camera.CFrame:ToOrientation()
        fcYaw, fcPitch = y, x
    else
        if char and char:FindFirstChild("HumanoidRootPart") then char.HumanoidRootPart.Anchored = false end
        Camera.CameraType = Enum.CameraType.Custom; Camera.CameraSubject = char and char:FindFirstChildOfClass("Humanoid")
        UserInputService.MouseBehavior = Enum.MouseBehavior.Default
    end
end)"""

if old_freecam in text:
    text = text.replace(old_freecam, new_freecam)
else:
    print("Warning: old_freecam not found exactly.")

# 3. Anti-Fall Damage
old_anti_fall = """    -- Anti-Fall Damage
    if SharedState.AntiFallDamage and hrp and hrp.Velocity.Y < -40 then
        hrp.Velocity = Vector3.new(hrp.Velocity.X, -20, hrp.Velocity.Z)
    end"""

new_anti_fall = """    -- Smart Anti-Fall Damage (Gradual Slowdown)
    if SharedState.AntiFallDamage and hrp and hrp.Velocity.Y < -20 then
        local ray = Ray.new(hrp.Position, Vector3.new(0, -10, 0))
        local hit, pos = Workspace:FindPartOnRay(ray, char)
        if hit then
            -- Close to ground, decelerate
            hrp.Velocity = Vector3.new(hrp.Velocity.X, -5, hrp.Velocity.Z)
        end
    end"""

if old_anti_fall in text:
    text = text.replace(old_anti_fall, new_anti_fall)
else:
    print("Warning: old_anti_fall not found exactly.")


with open(filepath, 'w', encoding='utf-8') as f:
    f.write(text)

print("Updated modifications done.")
