import re

file_path = r'c:\Users\saban\OneDrive\Masaüstü\roblox script\vexelbest.lua'
with open(file_path, 'r', encoding='utf-8') as f:
    code = f.read()

# 1. WaitForChild timeouts
def replace_wfc(match):
    inner = match.group(1)
    if ',' not in inner:
        return f'WaitForChild({inner}, 5)'
    return match.group(0)

code = re.sub(r'WaitForChild\(([^)]+)\)', replace_wfc, code)

# 2. Key Check and Login
login_logic = """LoginBtn.MouseButton1Click:Connect(function()
    local enteredKey = KeyBox.Text
    if enteredKey == "009953" then
        Tween(LoginFrame, {Size = UDim2.new(0, 0, 0, 0), Position = UDim2.new(0.5, 0, 0.5, 0)}, 0.4, Enum.EasingStyle.Back, Enum.EasingDirection.In)
        task.wait(0.4)
        LoginFrame:Destroy()
        MainFrame.Size = UDim2.new(0, 0, 0, 0)
        MainFrame.Position = UDim2.new(0.5, 0, 0.5, 0)
        MainFrame.Visible = true
        
        -- Fade & Scale Animation
        MainFrame:TweenSizeAndPosition(UDim2.new(0, 700, 0, 480), UDim2.new(0.5, -350, 0.5, -240), Enum.EasingDirection.Out, Enum.EasingStyle.Bounce, 0.5, true)
        
        local uiStroke = MainFrame:FindFirstChild("UIStroke")
        if uiStroke then
            uiStroke.Transparency = 1
            Tween(uiStroke, {Transparency = 0.2}, 1)
        end
    else
        local old = KeyBoxFrame.BackgroundColor3
        Tween(KeyBoxFrame, {BackgroundColor3 = Color3.fromRGB(200, 50, 50)}, 0.2)
        task.wait(0.1)
        game.Players.LocalPlayer:Kick("Hatalı Anahtar! Erişim Reddedildi.")
    end
end)"""

# Replace the old login logic
code = re.sub(r'LoginBtn\.MouseButton1Click:Connect\(function\(\).*?end\)', login_logic, code, flags=re.DOTALL)

# 3. Theme update (Matte Dark Gray and Electric Blue)
code = re.sub(r'Accent = Color3\.fromRGB\([0-9]+,\s*[0-9]+,\s*[0-9]+\),.*?', 'Accent = Color3.fromRGB(0, 150, 255), -- Electric Blue', code)
code = re.sub(r'Background = Color3\.fromRGB\([0-9]+,\s*[0-9]+,\s*[0-9]+\),', 'Background = Color3.fromRGB(20, 20, 20),', code)
code = re.sub(r'Sidebar = Color3\.fromRGB\([0-9]+,\s*[0-9]+,\s*[0-9]+\),', 'Sidebar = Color3.fromRGB(25, 25, 25),', code)

# 4. ClipsDescendants and ZIndex for Topbar
code = re.sub(r'local Topbar = Create\("Frame", \{ Parent = MainFrame, Size = UDim2.new\(1, 0, 0, 45\), BackgroundColor3 = Theme\.Sidebar, BorderSizePixel = 0, ZIndex = \d+ \}\)',
              'local Topbar = Create("Frame", { Parent = MainFrame, Size = UDim2.new(1, 0, 0, 45), BackgroundColor3 = Theme.Sidebar, BorderSizePixel = 0, ZIndex = 10, ClipsDescendants = true })', code)

# 5. while wait() -> while task.wait() 
code = code.replace('while wait(', 'while task.wait(')

with open(file_path, 'w', encoding='utf-8') as f:
    f.write(code)

print('Modifications applied successfully.')
