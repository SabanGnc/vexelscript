import re

file_path = r'c:\Users\saban\OneDrive\Masaüstü\roblox script\vexelbest.lua'
with open(file_path, 'r', encoding='utf-8') as f:
    orig_code = f.read()

# 1. Regex WaitForChild
def replace_wfc(match):
    inner = match.group(1)
    if ',' not in inner:
        return f'WaitForChild({inner}, 5)'
    return match.group(0)

code = re.sub(r'WaitForChild\(([^()]+)\)', replace_wfc, orig_code)

# 2. Modify Theme
theme_old = r"""local Theme = \{
    Background = Color3\.fromRGB\([0-9, ]+\),
    Sidebar = Color3\.fromRGB\([0-9, ]+\),
    Accent = Color3\.fromRGB\([0-9, ]+\), -- Electric Blue
    AccentHover = Color3\.fromRGB\([0-9, ]+\),
    Text = Color3\.fromRGB\([0-9, ]+\),
    TextDark = Color3\.fromRGB\([0-9, ]+\),
    Element = Color3\.fromRGB\([0-9, ]+\),
    ElementHover = Color3\.fromRGB\([0-9, ]+\),
    LogBg = Color3\.fromRGB\([0-9, ]+\)
\}"""

theme_new = """local Theme = {
    Background = Color3.fromRGB(15, 10, 20),
    Sidebar = Color3.fromRGB(20, 15, 25),
    Accent = Color3.fromRGB(160, 32, 240), -- Electric Purple Frost
    AccentHover = Color3.fromRGB(180, 52, 255),
    Text = Color3.fromRGB(240, 240, 240),
    TextDark = Color3.fromRGB(130, 130, 140),
    Element = Color3.fromRGB(25, 20, 30),
    ElementHover = Color3.fromRGB(35, 30, 45),
    LogBg = Color3.fromRGB(12, 10, 16)
}"""

# A more robust regex replacement for the theme
code = re.sub(r'local Theme = \{[\s\S]*?\}', theme_new, code, count=1)


# 3. Add Blur Effect
blur_code = """
local UIBlur = Instance.new("BlurEffect")
UIBlur.Size = 0
UIBlur.Parent = Lighting
local FrostyBlur = UIBlur
"""

code = code.replace('-- Globals & Shared State', blur_code + '\n-- Globals & Shared State', 1)

# 4. Rewrite Login & MainFrame Construction
ui_construction_new = """-- UI Construction
local MainFrame = Create("Frame", { Parent = VexelGui, Size = UDim2.new(0, 700, 0, 480), Position = UDim2.new(0.5, -350, 1.5, 0), BackgroundColor3 = Theme.Background, BackgroundTransparency = 0.3, BorderSizePixel = 0, ClipsDescendants = true, Visible = false, ZIndex = 5 })
Create("UICorner", { CornerRadius = UDim.new(0, 8), Parent = MainFrame })
Create("UIStroke", { Parent = MainFrame, Color = Theme.Accent, Thickness = 2, Transparency = 0.3 })

local LoginFrame = Create("Frame", { Parent = VexelGui, Size = UDim2.new(0, 350, 0, 200), Position = UDim2.new(0.5, -175, 0.5, -100), BackgroundColor3 = Theme.Background, BackgroundTransparency = 0.3, BorderSizePixel = 0, ClipsDescendants = true })
Create("UICorner", { CornerRadius = UDim.new(0, 8), Parent = LoginFrame })
Create("UIStroke", { Parent = LoginFrame, Color = Theme.Accent, Thickness = 2, Transparency = 0.3 })

local LoginTitle = Create("TextLabel", { Parent = LoginFrame, Size = UDim2.new(1, 0, 0, 40), Position = UDim2.new(0, 0, 0, 15), BackgroundTransparency = 1, Text = "VexelHUB PRO", TextColor3 = Theme.Accent, Font = Enum.Font.GothamBold, TextSize = 22, TextTransparency = 1 })
local LoginSub = Create("TextLabel", { Parent = LoginFrame, Size = UDim2.new(1, 0, 0, 20), Position = UDim2.new(0, 0, 0, 45), BackgroundTransparency = 1, Text = "Premium Authentication", TextColor3 = Theme.TextDark, Font = Enum.Font.GothamMedium, TextSize = 14, TextTransparency = 1 })

local KeyBoxFrame = Create("Frame", { Parent = LoginFrame, Size = UDim2.new(0, 250, 0, 35), Position = UDim2.new(0.5, -125, 0, 120), BackgroundColor3 = Theme.Element, BackgroundTransparency = 1 })
Create("UICorner", { CornerRadius = UDim.new(0, 6), Parent = KeyBoxFrame })
Create("UIStroke", { Parent = KeyBoxFrame, Color = Theme.Accent, Thickness = 1.5, Transparency = 1 })
local KeyBox = Create("TextBox", { Parent = KeyBoxFrame, Size = UDim2.new(1, -20, 1, 0), Position = UDim2.new(0, 10, 0, 0), BackgroundTransparency = 1, Text = "", PlaceholderText = "Enter Premium Key (009953)...", TextColor3 = Theme.Text, Font = Enum.Font.Gotham, TextSize = 14, ClearTextOnFocus = false, TextTransparency = 1 })

local LoginBtn = Create("TextButton", { Parent = LoginFrame, Size = UDim2.new(0, 120, 0, 35), Position = UDim2.new(0.5, -60, 0, 160), BackgroundColor3 = Theme.Accent, Text = "Login", TextColor3 = Theme.Text, Font = Enum.Font.GothamBold, TextSize = 14, AutoButtonColor = false, BackgroundTransparency = 1, TextTransparency = 1 })
Create("UICorner", { CornerRadius = UDim.new(0, 6), Parent = LoginBtn })

-- Initial Animation Sequence (Fade In + Slide Up)
task.spawn(function()
    Tween(FrostyBlur, {Size = 20}, 1, Enum.EasingStyle.Quart, Enum.EasingDirection.Out)
    Tween(LoginTitle, {TextTransparency = 0}, 1, Enum.EasingStyle.Sine)
    Tween(LoginSub, {TextTransparency = 0}, 1, Enum.EasingStyle.Sine)
    task.wait(0.4)
    Tween(KeyBoxFrame, {Position = UDim2.new(0.5, -125, 0, 85), BackgroundTransparency = 0.3}, 0.8, Enum.EasingStyle.Quart, Enum.EasingDirection.Out)
    local kbStr = KeyBoxFrame:FindFirstChild("UIStroke")
    if kbStr then Tween(kbStr, {Transparency = 0.5}, 0.8) end
    Tween(KeyBox, {TextTransparency = 0}, 0.8)
    task.wait(0.2)
    Tween(LoginBtn, {Position = UDim2.new(0.5, -60, 0, 140), BackgroundTransparency = 0, TextTransparency = 0}, 0.8, Enum.EasingStyle.Quart, Enum.EasingDirection.Out)
end)

LoginBtn.MouseButton1Click:Connect(function()
    local enteredKey = KeyBox.Text
    if enteredKey == "009953" then
        -- 1. Slide Out Login
        Tween(LoginFrame, {Position = UDim2.new(1.5, 0, 0.5, -100), BackgroundTransparency = 1}, 0.7, Enum.EasingStyle.Back, Enum.EasingDirection.In)
        Tween(LoginTitle, {TextTransparency = 1}, 0.5)
        Tween(KeyBoxFrame, {BackgroundTransparency = 1}, 0.5)
        Tween(KeyBox, {TextTransparency = 1}, 0.5)
        Tween(LoginBtn, {BackgroundTransparency = 1, TextTransparency = 1}, 0.5)
        local kbStr = KeyBoxFrame:FindFirstChild("UIStroke")
        if kbStr then Tween(kbStr, {Transparency = 1}, 0.5) end
        task.wait(0.6)
        LoginFrame:Destroy()
        
        -- 2. Slide In Main App
        MainFrame.Visible = true
        Tween(MainFrame, {Position = UDim2.new(0.5, -350, 0.5, -240)}, 0.8, Enum.EasingStyle.Quint, Enum.EasingDirection.Out)
    else
        local old = KeyBoxFrame.BackgroundColor3
        Tween(KeyBoxFrame, {BackgroundColor3 = Color3.fromRGB(200, 50, 50)}, 0.2)
        task.wait(0.1)
        game.Players.LocalPlayer:Kick("Hatalı Anahtar! Erişim Reddedildi.")
    end
end)"""

code = re.sub(r'-- UI Construction.*?LoginBtn\.MouseButton1Click:Connect\(function\(\).*?end\)', ui_construction_new, code, flags=re.DOTALL)

# 5. Connect Minimize Blur
min_logic = """MinimizeBtn.MouseButton1Click:Connect(function()
    Minimized = not Minimized
    if Minimized then
        Tween(MainFrame, {Size = UDim2.new(0, 200, 0, 45)}, 0.4, Enum.EasingStyle.Bounce); Sidebar.Visible = false; ContentContainer.Visible = false; TitleSub.Visible = false; MinimizeBtn.Text = "+"
        Tween(FrostyBlur, {Size = 0}, 0.5)
    else
        TitleSub.Visible = true; Tween(MainFrame, {Size = UDim2.new(0, 700, 0, 480)}, 0.4, Enum.EasingStyle.Bounce).Completed:Connect(function() if not Minimized then Sidebar.Visible = true; ContentContainer.Visible = true end end); MinimizeBtn.Text = "-"
        Tween(FrostyBlur, {Size = 20}, 0.5)
    end
end)"""

code = re.sub(r'MinimizeBtn\.MouseButton1Click:Connect\(function\(\).*?end\)', min_logic, code, flags=re.DOTALL)

F1_bind_old = r'Library:AddKeybind\(PageSet, "Toggle UI Visibility", Enum\.KeyCode\.F1, nil, function\(\).*?end\)'
F1_bind_new = """Library:AddKeybind(PageSet, "Toggle UI Visibility", Enum.KeyCode.F1, nil, function()
    MainFrame.Visible = not MainFrame.Visible; MinimizeBtn.Visible = MainFrame.Visible; Topbar.Visible = MainFrame.Visible
    if MainFrame.Visible then
        Tween(FrostyBlur, {Size = Minimized and 0 or 20}, 0.5)
    else
        Tween(FrostyBlur, {Size = 0}, 0.5)
    end
end)"""

code = re.sub(F1_bind_old, F1_bind_new, code, flags=re.DOTALL)

# 6. Streamproof Mode
settings_insert = """Library:AddSection(PageSet, "Hub Settings")

Library:AddToggle(PageSet, "Streamproof Mode", function(state)
    if state then
        -- Move to hidden CoreGui layer
        VexelGui.Parent = CoreGui:FindFirstChild("RobloxGui") or gethui() or CoreGui
        NotifGui.Parent = CoreGui:FindFirstChild("RobloxGui") or gethui() or CoreGui
        HUDGui.Parent = CoreGui:FindFirstChild("RobloxGui") or gethui() or CoreGui
        Notify("Streamproof Enabled! Hidden from recording apps.")
    else
        VexelGui.Parent = gethui() or CoreGui
        NotifGui.Parent = gethui() or CoreGui
        HUDGui.Parent = gethui() or CoreGui
        Notify("Streamproof Disabled.")
    end
end)"""

code = code.replace('Library:AddSection(PageSet, "Hub Settings")', settings_insert)

with open(file_path, 'w', encoding='utf-8') as f:
    f.write(code)

print("Modifications done via apply_v3.py")
