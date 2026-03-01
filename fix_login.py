import os

filepath = r"c:\Users\saban\OneDrive\Masaüstü\roblox script\vexelbest.lua"

with open(filepath, 'r', encoding='utf-8') as f:
    content = f.read()

content = content.replace(
    'PlaceholderText = "Enter Premium Key (009953)..."',
    'PlaceholderText = "Anahtarı Buraya Girin..."'
)

old_login_block = """LoginBtn.MouseButton1Click:Connect(function()
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
        Tween(MainFrame, {Position = UDim2.new(0.5, -350, 0.5, -240)}, 0.8, Enum.EasingStyle.Quint, Enum.EasingDirection.Out)"""

new_login_block = """LoginBtn.MouseButton1Click:Connect(function()
    local enteredKey = KeyBox.Text
    if enteredKey == "009953" then
        -- Blur Disable Sequence
        if FrostyBlur then
            local tw = TweenService:Create(FrostyBlur, TweenInfo.new(0.5), {Size = 0})
            tw:Play()
            task.delay(0.5, function()
                if FrostyBlur then FrostyBlur:Destroy() end
            end)
        end
        
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
        Tween(MainFrame, {Position = UDim2.new(0.5, -350, 0.5, -240)}, 0.8, Enum.EasingStyle.Quint, Enum.EasingDirection.Out)"""

content = content.replace(old_login_block, new_login_block)

content = content.replace("Tween(FrostyBlur, {Size = Minimized and 0 or 20}, 0.5)", "if FrostyBlur and FrostyBlur.Parent then Tween(FrostyBlur, {Size = Minimized and 0 or 20}, 0.5) end")
content = content.replace("Tween(FrostyBlur, {Size = 0}, 0.5)", "if FrostyBlur and FrostyBlur.Parent then Tween(FrostyBlur, {Size = 0}, 0.5) end")
content = content.replace("Tween(FrostyBlur, {Size = 20}, 0.5)", "if FrostyBlur and FrostyBlur.Parent then Tween(FrostyBlur, {Size = 20}, 0.5) end")

with open(filepath, 'w', encoding='utf-8') as f:
    f.write(content)

print("Updated")
