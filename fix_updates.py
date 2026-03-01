import os

filepath = r"c:\Users\saban\OneDrive\Masaüstü\roblox script\vexelbest.lua"

with open(filepath, 'r', encoding='utf-8') as f:
    text = f.read()

# 1. Cinematic Walk Keybind Removal
text = text.replace('Library:AddKeybind(PagePlayer, "Cinematic Walk Bind", nil, ToggleCinematic)\n', '')
text = text.replace('Library:AddKeybind(PagePlayer, "Cinematic Walk Bind", nil, ToggleCinematic)', '')

# 2. Freecam Default Keybind "P"
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
end)
Library:AddSlider(PagePlayer, "Freecam Speed", 1, 10, 1, function(val) SharedState.FreecamSpeed = val end)"""

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
    end
end)
Library:AddKeybind(PagePlayer, "Freecam Toggle", Enum.KeyCode.P, ToggleFreecam)
Library:AddSlider(PagePlayer, "Freecam Speed", 1, 10, 1, function(val) SharedState.FreecamSpeed = val end)"""

if old_freecam in text:
    text = text.replace(old_freecam, new_freecam)
else:
    print("Warning: old_freecam not found exactly.")

# 3. Manual Platform Keybind Removal and Button Addition
old_platform = """Library:AddKeybind(PagePlayer, "Manual Platform", nil, nil, function()
    local char = LocalPlayer.Character
    if char and char:FindFirstChild("HumanoidRootPart") then
        local p = Instance.new("Part")
        p.Size = Vector3.new(10, 1, 10)
        p.Position = char.HumanoidRootPart.Position - Vector3.new(0, 3.5, 0)
        p.Anchored = true
        p.Color = Theme.Accent
        p.Material = Enum.Material.SmoothPlastic
        p.Parent = Workspace
    end
end)"""

new_platform = """Library:AddButton(PagePlayer, "Spawn Platform", function()
    local char = LocalPlayer.Character
    if char and char:FindFirstChild("HumanoidRootPart") then
        local hrp = char.HumanoidRootPart
        hrp.Velocity = Vector3.new(0, 0, 0)
        local p = Instance.new("Part")
        p.Size = Vector3.new(10, 1, 10)
        p.Position = hrp.Position - Vector3.new(0, 3.5, 0)
        p.Anchored = true
        p.Color = Theme.Accent
        p.Material = Enum.Material.SmoothPlastic
        p.Parent = Workspace
    end
end)"""

if old_platform in text:
    text = text.replace(old_platform, new_platform)
else:
    print("Warning: old_platform not found exactly.")

# 4. Noclip Fix
old_noclip = """local noclipConnection
local ToggleNoclip = Library:AddToggle(PagePlayer, "Noclip", function(state) 
    SharedState.NoclipActive = state 
    if state then
        if not noclipConnection then
            noclipConnection = RunService.Stepped:Connect(function()
                if LocalPlayer.Character then
                    for _, p in pairs(LocalPlayer.Character:GetDescendants()) do if p:IsA("BasePart") then p.CanCollide = false end end
                end
            end)
        end
    else
        if noclipConnection then noclipConnection:Disconnect(); noclipConnection = nil end
        if LocalPlayer.Character then
            local hrp = LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
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

if old_noclip in text:
    text = text.replace(old_noclip, new_noclip)
else:
    print("Warning: old_noclip not found exactly.")

# 5. Placeholder Text
text = text.replace('PlaceholderText = "Anahtarı Buraya Girin..."', 'PlaceholderText = "Anahtarı Giriniz..."')
text = text.replace('PlaceholderText = "Enter Premium Key (009953)..."', 'PlaceholderText = "Anahtarı Giriniz..."')

with open(filepath, 'w', encoding='utf-8') as f:
    f.write(text)

print("Updated modifications done.")
