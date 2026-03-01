--[[
    VexelHUB PRO - Premium Roblox Exploit Hub (Final V1.0)
    Author: VexelHUB / AI
    Theme: Modern Dark Mode with Neon Purple Accents
]]

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local CoreGui = game:GetService("CoreGui")
local Workspace = game:GetService("Workspace")
local Lighting = game:GetService("Lighting")
local HttpService = game:GetService("HttpService")
local TeleportService = game:GetService("TeleportService")
local VirtualUser = game:GetService("VirtualUser")
local StarterGui = game:GetService("StarterGui")
local LogService = game:GetService("LogService")
local Stats = game:GetService("Stats")

local LocalPlayer = Players.LocalPlayer
local Camera = Workspace.CurrentCamera
local Mouse = LocalPlayer:GetMouse()

-- System Variables
local gethui = gethui or function() return CoreGui end
local success, guiParent = pcall(gethui)
if not success then guiParent = CoreGui end

if guiParent:FindFirstChild("VexelHUB_UI") then guiParent:FindFirstChild("VexelHUB_UI"):Destroy() end
if guiParent:FindFirstChild("VexelHUB_Notifs") then guiParent:FindFirstChild("VexelHUB_Notifs"):Destroy() end
if guiParent:FindFirstChild("VexelHUB_HUD") then guiParent:FindFirstChild("VexelHUB_HUD"):Destroy() end

local VexelGui = Instance.new("ScreenGui")
VexelGui.Name = "VexelHUB_UI"
VexelGui.ResetOnSpawn = false
VexelGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
VexelGui.Parent = guiParent

local NotifGui = Instance.new("ScreenGui", guiParent)
NotifGui.Name = "VexelHUB_Notifs"
local NotifLayout = Instance.new("Frame", NotifGui)
NotifLayout.Size = UDim2.new(0, 250, 1, -50)
NotifLayout.Position = UDim2.new(1, -260, 0, 0)
NotifLayout.BackgroundTransparency = 1
local NList = Instance.new("UIListLayout", NotifLayout)
NList.SortOrder = Enum.SortOrder.LayoutOrder
NList.VerticalAlignment = Enum.VerticalAlignment.Bottom
NList.Padding = UDim.new(0, 5)

-- Color Theme
local Theme = {
    Background = Color3.fromRGB(15, 15, 18),
    Sidebar = Color3.fromRGB(20, 20, 25),
    Accent = Color3.fromRGB(138, 43, 226), -- Neon Purple
    AccentHover = Color3.fromRGB(158, 63, 246),
    Text = Color3.fromRGB(240, 240, 240),
    TextDark = Color3.fromRGB(120, 120, 130),
    Element = Color3.fromRGB(25, 25, 30),
    ElementHover = Color3.fromRGB(35, 35, 42),
    LogBg = Color3.fromRGB(10, 10, 12)
}

-- Globals & Shared State
local SharedState = {
    SelectedTarget = nil,
    WalkSpeed = 16, JumpPower = 50, FlyActive = false, StealthFly = false, FlySpeed = 50, NoStamina = false,
    CFrameSpeedActive = false, CFrameSpeed = 2, AutoBhop = false,
    NoclipActive = false, InfJumpActive = false, Freecam = false, FreecamSpeed = 1,
    ClickTP = false, Spider = false, Btools = false, TweenTP = false, AntiFallDamage = false,
    LoopFollow = false, FollowDistance = 3, FollowHeight = 1, FlingActive = false,
    VehFlyActive = false, VehFlySpeed = 50, VehSpeedActive = false, VehSpeed = 100, VehNoclip = false,
    VehNitroActive = false, VehNitroPower = 50,
    ESP = { Name = false, Health = false, Chams = false }, Tracers = false, TracerOrigin = "Bottom",
    Spinbot = false, SpinSpeed = 20, HitboxExpander = false, HitboxSize = 5, FOV = 70,
    AutoClicker = false, ClickCPS = 10, Invisible = false, ChatSpy = false, Notifications = false, ShowHUD = false,
    Aimbot = false, ShowFOV = false, FOVRadius = 150, AimSmoothness = 5, TargetPart = "Head", AimKey = "Right Click",
    ElementInspector = false, TargetLeaveNotify = false, GlobalChatSpy = false, CinematicWalk = false
}

-- Anti-AFK
LocalPlayer.Idled:Connect(function()
    VirtualUser:Button2Down(Vector2.new(0,0), Camera.CFrame)
    task.wait(1)
    VirtualUser:Button2Up(Vector2.new(0,0), Camera.CFrame)
end)

-- Helpers
local function Create(class, properties)
    local inst = Instance.new(class)
    for k, v in pairs(properties) do
        if k == "AutoButtonColor" and (class == "TextButton" or class == "ImageButton") then continue end
        inst[k] = v
    end
    if class == "TextButton" or class == "ImageButton" then
        inst.AutoButtonColor = false
    end
    return inst
end

local function Tween(obj, props, time, style, direction)
    local info = TweenInfo.new(time or 0.3, style or Enum.EasingStyle.Quad, direction or Enum.EasingDirection.Out)
    local tween = TweenService:Create(obj, info, props)
    tween:Play()
    return tween
end

local function Notify(msg, duration)
    if not SharedState.Notifications then return end
    duration = duration or 3
    local f = Instance.new("Frame", NotifLayout)
    f.Size = UDim2.new(1, 0, 0, 40)
    f.BackgroundColor3 = Theme.Element
    f.BackgroundTransparency = 1
    Instance.new("UICorner", f).CornerRadius = UDim.new(0, 6)
    Instance.new("UIStroke", f).Color = Theme.Accent
    local t = Instance.new("TextLabel", f)
    t.Size = UDim2.new(1, -20, 1, 0)
    t.Position = UDim2.new(0, 10, 0, 0)
    t.BackgroundTransparency = 1
    t.Text = "★ " .. msg
    t.TextColor3 = Theme.Text
    t.TextXAlignment = Enum.TextXAlignment.Left
    t.Font = Enum.Font.GothamSemibold
    t.TextSize = 13
    t.TextTransparency = 1
    
    TweenService:Create(f, TweenInfo.new(0.3), {BackgroundTransparency = 0.1}):Play()
    TweenService:Create(t, TweenInfo.new(0.3), {TextTransparency = 0}):Play()
    
    task.spawn(function()
        task.wait(duration)
        local tw = TweenService:Create(f, TweenInfo.new(0.3), {BackgroundTransparency = 1})
        TweenService:Create(t, TweenInfo.new(0.3), {TextTransparency = 1}):Play()
        tw:Play()
        tw.Completed:Wait()
        f:Destroy()
    end)
end

local function MakeDraggable(topbar, object)
    local dragging, dragInput, mousePos, framePos
    topbar.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true; mousePos = input.Position; framePos = object.Position
            input.Changed:Connect(function() if input.UserInputState == Enum.UserInputState.End then dragging = false end end)
        end
    end)
    topbar.InputChanged:Connect(function(input) if input.UserInputType == Enum.UserInputType.MouseMovement then dragInput = input end end)
    UserInputService.InputChanged:Connect(function(input)
        if input == dragInput and dragging then
            local delta = input.Position - mousePos
            object.Position = UDim2.new(framePos.X.Scale, framePos.X.Offset + delta.X, framePos.Y.Scale, framePos.Y.Offset + delta.Y)
        end
    end)
end

-- Target Leave Notification UI
local TargetLeaveNotifFrame = Create("Frame", {
    Parent = VexelGui, Size = UDim2.new(0, 700, 0, 80), Position = UDim2.new(0.5, -350, 0, -100),
    BackgroundColor3 = Theme.Background, BackgroundTransparency = 0.1, Visible = false, ZIndex = 110
})
Create("UICorner", { CornerRadius = UDim.new(0, 8), Parent = TargetLeaveNotifFrame })
local TargetLeaveNotifStroke = Create("UIStroke", { Parent = TargetLeaveNotifFrame, Color = Theme.Accent, Thickness = 2 })
local TargetLeaveNotifText = Create("TextLabel", {
    Parent = TargetLeaveNotifFrame, Size = UDim2.new(1, -20, 1, -20), Position = UDim2.new(0, 10, 0, 10),
    BackgroundTransparency = 1, Text = "⚠️ HEDEF OYUNDAN ÇIKTI! ⚠️", TextColor3 = Theme.Accent,
    Font = Enum.Font.GothamBold, TextScaled = true, TextWrapped = true, ZIndex = 111
})

-- HUD Watermark
local HUDGui = Instance.new("ScreenGui", guiParent)
HUDGui.Name = "VexelHUB_HUD"
local HUDBar = Create("Frame", { Parent = HUDGui, Size = UDim2.new(0, 300, 0, 25), Position = UDim2.new(0.5, -150, 0, 10), BackgroundColor3 = Color3.fromRGB(10, 10, 10), BackgroundTransparency = 0.3, Visible = SharedState.ShowHUD })
Create("UICorner", {Parent = HUDBar, CornerRadius = UDim.new(0, 6)})
Create("UIStroke", {Parent = HUDBar, Color = Theme.Accent, Thickness = 1, Transparency = 0.5})
local HUDText = Create("TextLabel", { Parent = HUDBar, Size = UDim2.new(1, 0, 1, 0), BackgroundTransparency = 1, Text = "VexelHUB | FPS: 0 | Ping: 0 ms | Time: 00:00", TextColor3 = Theme.Text, Font = Enum.Font.GothamSemibold, TextSize = 12 })

local lastTick, fps = tick(), 60
RunService.RenderStepped:Connect(function()
    fps = math.floor(1 / (tick() - lastTick)); lastTick = tick()
    if SharedState.ShowHUD then
        local ping = "0"
        pcall(function() ping = math.floor(Stats.Network.ServerStatsItem["Data Ping"]:GetValue()) end)
        HUDText.Text = string.format("VexelHUB - PRO | FPS: %d | Ping: %s ms | %s", fps, ping, os.date("%H:%M:%S"))
    end
end)

-- UI Construction

local MainFrame = Create("Frame", { Parent = VexelGui, Size = UDim2.new(0, 700, 0, 480), Position = UDim2.new(0.5, -350, 0.5, -240), BackgroundColor3 = Theme.Background, BorderSizePixel = 0, ClipsDescendants = true, Visible = false })
Create("UICorner", { CornerRadius = UDim.new(0, 8), Parent = MainFrame })
Create("UIStroke", { Parent = MainFrame, Color = Theme.Accent, Thickness = 1.5, Transparency = 0.3 })

local LoginFrame = Create("Frame", { Parent = VexelGui, Size = UDim2.new(0, 350, 0, 200), Position = UDim2.new(0.5, -175, 0.5, -100), BackgroundColor3 = Theme.Background, BorderSizePixel = 0, ClipsDescendants = true })
Create("UICorner", { CornerRadius = UDim.new(0, 8), Parent = LoginFrame })
Create("UIStroke", { Parent = LoginFrame, Color = Theme.Accent, Thickness = 1.5, Transparency = 0.3 })

local LoginTitle = Create("TextLabel", { Parent = LoginFrame, Size = UDim2.new(1, 0, 0, 40), Position = UDim2.new(0, 0, 0, 15), BackgroundTransparency = 1, Text = "VexelHUB PRO", TextColor3 = Theme.Accent, Font = Enum.Font.GothamBold, TextSize = 22 })
local LoginSub = Create("TextLabel", { Parent = LoginFrame, Size = UDim2.new(1, 0, 0, 20), Position = UDim2.new(0, 0, 0, 45), BackgroundTransparency = 1, Text = "Premium Authentication", TextColor3 = Theme.TextDark, Font = Enum.Font.GothamMedium, TextSize = 14 })

local KeyBoxFrame = Create("Frame", { Parent = LoginFrame, Size = UDim2.new(0, 250, 0, 35), Position = UDim2.new(0.5, -125, 0, 85), BackgroundColor3 = Theme.Element })
Create("UICorner", { CornerRadius = UDim.new(0, 6), Parent = KeyBoxFrame })
local KeyBox = Create("TextBox", { Parent = KeyBoxFrame, Size = UDim2.new(1, -20, 1, 0), Position = UDim2.new(0, 10, 0, 0), BackgroundTransparency = 1, Text = "", PlaceholderText = "Enter Premium Key...", TextColor3 = Theme.Text, Font = Enum.Font.Gotham, TextSize = 14, ClearTextOnFocus = false })

local LoginBtn = Create("TextButton", { Parent = LoginFrame, Size = UDim2.new(0, 120, 0, 35), Position = UDim2.new(0.5, -60, 0, 140), BackgroundColor3 = Theme.Accent, Text = "Login", TextColor3 = Theme.Text, Font = Enum.Font.GothamBold, TextSize = 14, AutoButtonColor = false })
Create("UICorner", { CornerRadius = UDim.new(0, 6), Parent = LoginBtn })

LoginBtn.MouseButton1Click:Connect(function()
    local enteredKey = KeyBox.Text
    if enteredKey == "vexelgod" or enteredKey == "vpoyraz" then
        Tween(LoginFrame, {Size = UDim2.new(0, 0, 0, 0), Position = UDim2.new(0.5, 0, 0.5, 0)}, 0.4, Enum.EasingStyle.Back, Enum.EasingDirection.In)
        task.wait(0.4)
        LoginFrame:Destroy()
        MainFrame.Size = UDim2.new(0, 0, 0, 0)
        MainFrame.Position = UDim2.new(0.5, 0, 0.5, 0)
        MainFrame.Visible = true
        Tween(MainFrame, {Size = UDim2.new(0, 700, 0, 480), Position = UDim2.new(0.5, -350, 0.5, -240)}, 0.5, Enum.EasingStyle.Bounce)
    else
        local old = KeyBoxFrame.BackgroundColor3
        Tween(KeyBoxFrame, {BackgroundColor3 = Color3.fromRGB(200, 50, 50)}, 0.2)
        task.wait(1)
        Tween(KeyBoxFrame, {BackgroundColor3 = old}, 0.2)
    end
end)

local Topbar = Create("Frame", { Parent = MainFrame, Size = UDim2.new(1, 0, 0, 45), BackgroundColor3 = Theme.Sidebar, BorderSizePixel = 0, ZIndex = 2 })
Create("UICorner", { CornerRadius = UDim.new(0, 8), Parent = Topbar })
Create("Frame", { Parent = Topbar, Size = UDim2.new(1, 0, 0, 10), Position = UDim2.new(0, 0, 1, -10), BackgroundColor3 = Theme.Sidebar, BorderSizePixel = 0, ZIndex = 2 })
Create("Frame", { Parent = Topbar, Size = UDim2.new(1, 0, 0, 1), Position = UDim2.new(0, 0, 1, 0), BackgroundColor3 = Theme.Background, BorderSizePixel = 0, ZIndex = 3 })

local Title = Create("TextLabel", { Parent = Topbar, Size = UDim2.new(1, -100, 1, 0), Position = UDim2.new(0, 20, 0, 0), BackgroundTransparency = 1, ZIndex = 3, Text = "VexelHUB", TextColor3 = Theme.Accent, TextSize = 22, Font = Enum.Font.GothamBold, TextXAlignment = Enum.TextXAlignment.Left })

-- Removed Visual Effects

local TitleSub = Create("TextLabel", { Parent = Title, Size = UDim2.new(1, 0, 1, 0), Position = UDim2.new(0, 110, 0, 0), BackgroundTransparency = 1, ZIndex = 3, Text = "| PRO  v1", TextColor3 = Theme.TextDark, TextSize = 16, Font = Enum.Font.GothamMedium, TextXAlignment = Enum.TextXAlignment.Left })
local MinimizeBtn = Create("TextButton", { Parent = Topbar, Size = UDim2.new(0, 30, 0, 30), Position = UDim2.new(1, -40, 0.5, -15), BackgroundColor3 = Theme.Element, Text = "-", TextColor3 = Theme.Text, Font = Enum.Font.GothamBold, TextSize = 20, ZIndex = 4, AutoButtonColor = false })
Create("UICorner", { CornerRadius = UDim.new(0, 6), Parent = MinimizeBtn })

local SearchBoxFrame = Create("Frame", { Parent = Topbar, Size = UDim2.new(0, 150, 0, 26), Position = UDim2.new(1, -200, 0.5, -13), BackgroundColor3 = Theme.Background, BorderSizePixel = 0, ZIndex = 4 })
Create("UICorner", { CornerRadius = UDim.new(0, 6), Parent = SearchBoxFrame })
Create("UIStroke", { Parent = SearchBoxFrame, Color = Theme.Accent, Thickness = 1, Transparency = 0.5 })
local SearchBox = Create("TextBox", { Parent = SearchBoxFrame, Size = UDim2.new(1, -10, 1, 0), Position = UDim2.new(0, 10, 0, 0), BackgroundTransparency = 1, Text = "", PlaceholderText = "🔍 Ara / Search...", TextColor3 = Theme.Text, Font = Enum.Font.Gotham, TextSize = 12, TextXAlignment = Enum.TextXAlignment.Left, ClearTextOnFocus = false, ZIndex = 4 })

MakeDraggable(Topbar, MainFrame)

local Sidebar = Create("ScrollingFrame", { Parent = MainFrame, Size = UDim2.new(0, 180, 1, -45), Position = UDim2.new(0, 0, 0, 45), BackgroundColor3 = Theme.Sidebar, BorderSizePixel = 0, ZIndex = 1, ScrollBarThickness = 2 })
Create("UICorner", { CornerRadius = UDim.new(0, 8), Parent = Sidebar })
local ContentContainer = Create("Frame", { Parent = MainFrame, Size = UDim2.new(1, -180, 1, -45), Position = UDim2.new(0, 180, 0, 45), BackgroundTransparency = 1, ZIndex = 1 })
Create("UICorner", { CornerRadius = UDim.new(0, 8), Parent = ContentContainer })
local TabList = Create("UIListLayout", { Parent = Sidebar, SortOrder = Enum.SortOrder.LayoutOrder, Padding = UDim.new(0, 6) })
Create("UIPadding", { Parent = Sidebar, PaddingTop = UDim.new(0, 15), PaddingLeft = UDim.new(0, 15), PaddingRight = UDim.new(0, 15), PaddingBottom = UDim.new(0, 15) })
TabList:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function() Sidebar.CanvasSize = UDim2.new(0,0,0, TabList.AbsoluteContentSize.Y + 30) end)

local Tabs, CurrentTab = {}, nil
local Minimized = false
MinimizeBtn.MouseButton1Click:Connect(function()
    Minimized = not Minimized
    if Minimized then
        Tween(MainFrame, {Size = UDim2.new(0, 200, 0, 45)}, 0.4, Enum.EasingStyle.Bounce); Sidebar.Visible = false; ContentContainer.Visible = false; TitleSub.Visible = false; MinimizeBtn.Text = "+"
    else
        TitleSub.Visible = true; Tween(MainFrame, {Size = UDim2.new(0, 700, 0, 480)}, 0.4, Enum.EasingStyle.Bounce).Completed:Connect(function() if not Minimized then Sidebar.Visible = true; ContentContainer.Visible = true end end); MinimizeBtn.Text = "-"
    end
end)

-- Library Engine
local Library = { Keybinds = {} }

UserInputService.InputBegan:Connect(function(input, gpe)
    if gpe then return end
    for name, bind in pairs(Library.Keybinds) do if input.KeyCode == bind.Key then bind.Callback() end end
end)

function Library:AddTab(icon, name)
    local btn = Create("TextButton", { Parent = Sidebar, Size = UDim2.new(1, 0, 0, 36), BackgroundColor3 = Theme.Background, Text = string.format(" %s  %s", icon, name), TextColor3 = Theme.TextDark, Font = Enum.Font.GothamSemibold, TextSize = 13, AutoButtonColor = false, TextXAlignment = Enum.TextXAlignment.Left, ZIndex = 2 })
    Create("UICorner", { CornerRadius = UDim.new(0, 6), Parent = btn })
    local page = Create("ScrollingFrame", { Parent = ContentContainer, Size = UDim2.new(1, 0, 1, 0), BackgroundTransparency = 1, ScrollBarThickness = 3, ScrollBarImageColor3 = Theme.Accent, Visible = false, ZIndex = 1, BorderSizePixel = 0 })
    Create("UICorner", { CornerRadius = UDim.new(0, 8), Parent = page })
    local pageLayout = Create("UIListLayout", { Parent = page, SortOrder = Enum.SortOrder.LayoutOrder, Padding = UDim.new(0, 10) })
    Create("UIPadding", { Parent = page, PaddingTop = UDim.new(0, 15), PaddingLeft = UDim.new(0, 15), PaddingRight = UDim.new(0, 15), PaddingBottom = UDim.new(0, 15) })
    pageLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function() page.CanvasSize = UDim2.new(0, 0, 0, pageLayout.AbsoluteContentSize.Y + 30) end)
    
    btn.MouseEnter:Connect(function() if CurrentTab ~= btn then Tween(btn, {BackgroundColor3 = Theme.ElementHover}, 0.2) end end)
    btn.MouseLeave:Connect(function() if CurrentTab ~= btn then Tween(btn, {BackgroundColor3 = Theme.Background}, 0.2) end end)
    btn.MouseButton1Click:Connect(function()
        for _, t in pairs(Tabs) do t.Page.Visible = false; Tween(t.Button, {TextColor3 = Theme.TextDark, BackgroundColor3 = Theme.Background}, 0.2) end
        page.Visible = true; CurrentTab = btn; Tween(btn, {TextColor3 = Theme.Text, BackgroundColor3 = Theme.Accent}, 0.3, Enum.EasingStyle.Quart)
    end)
    if not CurrentTab then CurrentTab = btn; page.Visible = true; btn.TextColor3 = Theme.Text; btn.BackgroundColor3 = Theme.Accent end
    table.insert(Tabs, {Page = page, Button = btn})
    return page
end

local SearchPage = Create("ScrollingFrame", { Parent = ContentContainer, Size = UDim2.new(1, 0, 1, 0), BackgroundTransparency = 1, ScrollBarThickness = 3, ScrollBarImageColor3 = Theme.Accent, Visible = false, ZIndex = 3, BorderSizePixel = 0 })
Create("UICorner", { CornerRadius = UDim.new(0, 8), Parent = SearchPage })
local searchLayout = Create("UIListLayout", { Parent = SearchPage, SortOrder = Enum.SortOrder.LayoutOrder, Padding = UDim.new(0, 10) })
Create("UIPadding", { Parent = SearchPage, PaddingTop = UDim.new(0, 15), PaddingLeft = UDim.new(0, 15), PaddingRight = UDim.new(0, 15), PaddingBottom = UDim.new(0, 15) })
searchLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function() SearchPage.CanvasSize = UDim2.new(0, 0, 0, searchLayout.AbsoluteContentSize.Y + 30) end)

local OriginalParents = {}
local OrderAssigned = false

SearchBox:GetPropertyChangedSignal("Text"):Connect(function()
    if not OrderAssigned then
        local orderCounter = 0
        for _, t in pairs(Tabs) do
            for _, child in pairs(t.Page:GetChildren()) do
                if child:IsA("GuiObject") and not child:IsA("UIListLayout") and not child:IsA("UIPadding") then
                    orderCounter = orderCounter + 1
                    child.LayoutOrder = orderCounter
                end
            end
        end
        OrderAssigned = true
    end

    local q = SearchBox.Text:lower()
    
    if q == "" then
        for child, parent in pairs(OriginalParents) do
            pcall(function()
                child.Parent = parent
                child.Visible = true
            end)
        end
        table.clear(OriginalParents)
        SearchPage.Visible = false
        for _, t in pairs(Tabs) do
            t.Page.Visible = (t.Button == CurrentTab)
        end
    else
        for _, t in pairs(Tabs) do t.Page.Visible = false end
        SearchPage.Visible = true
        
        local function checkMatch(child)
            local txtObj = child:FindFirstChildWhichIsA("TextLabel", true) or child:FindFirstChildWhichIsA("TextButton", true) or child:FindFirstChildWhichIsA("TextBox", true)
            if child:IsA("TextLabel") or child:IsA("TextButton") or child:IsA("TextBox") then txtObj = child end
            return txtObj and txtObj.Text and string.find(txtObj.Text:lower(), q)
        end
        
        for _, t in pairs(Tabs) do
            for _, child in pairs(t.Page:GetChildren()) do
                if child:IsA("GuiObject") and not child:IsA("UIListLayout") and not child:IsA("UIPadding") then
                    if checkMatch(child) then
                        OriginalParents[child] = t.Page
                        child.Parent = SearchPage
                        child.Visible = true
                    end
                end
            end
        end
        
        for child, parent in pairs(OriginalParents) do
            if child.Parent == SearchPage then
                if checkMatch(child) then
                    child.Visible = true
                else
                    child.Parent = parent
                    child.Visible = false
                    OriginalParents[child] = nil
                end
            end
        end
    end
end)

function Library:AddSection(page, text)
    Create("TextLabel", { Parent = page, Size = UDim2.new(1, 0, 0, 20), BackgroundTransparency = 1, Text = text, TextColor3 = Theme.Accent, Font = Enum.Font.GothamBold, TextSize = 13, TextXAlignment = Enum.TextXAlignment.Left })
end

function Library:AddButton(page, text, callback)
    local btn = Create("TextButton", { Parent = page, Size = UDim2.new(1, 0, 0, 42), BackgroundColor3 = Theme.Element, Text = text, TextColor3 = Theme.Text, Font = Enum.Font.Gotham, TextSize = 14, AutoButtonColor = false, ClipsDescendants = true })
    Create("UICorner", { CornerRadius = UDim.new(0, 6), Parent = btn })
    btn.MouseEnter:Connect(function() Tween(btn, {BackgroundColor3 = Theme.ElementHover}, 0.2) end)
    btn.MouseLeave:Connect(function() Tween(btn, {BackgroundColor3 = Theme.Element}, 0.2) end)
    btn.MouseButton1Click:Connect(function() callback(); Notify(text .. " Executed!") end)
end

function Library:AddToggle(page, text, callback)
    local state = false
    local toggleFrame = Create("Frame", { Parent = page, Size = UDim2.new(1, 0, 0, 42), BackgroundColor3 = Theme.Element })
    Create("UICorner", { CornerRadius = UDim.new(0, 6), Parent = toggleFrame })
    Create("TextLabel", { Parent = toggleFrame, Size = UDim2.new(1, -60, 1, 0), Position = UDim2.new(0, 15, 0, 0), BackgroundTransparency = 1, Text = text, TextColor3 = Theme.Text, Font = Enum.Font.Gotham, TextSize = 14, TextXAlignment = Enum.TextXAlignment.Left })
    local switchBtn = Create("TextButton", { Parent = toggleFrame, Size = UDim2.new(0, 44, 0, 22), Position = UDim2.new(1, -55, 0.5, -11), BackgroundColor3 = Theme.Background, Text = "", AutoButtonColor = false })
    Create("UICorner", { CornerRadius = UDim.new(1, 0), Parent = switchBtn })
    local indicator = Create("Frame", { Parent = switchBtn, Size = UDim2.new(0, 18, 0, 18), Position = UDim2.new(0, 2, 0.5, -9), BackgroundColor3 = Theme.TextDark })
    Create("UICorner", { CornerRadius = UDim.new(1, 0), Parent = indicator })
    local btnOverlay = Create("TextButton", { Parent = toggleFrame, Size = UDim2.new(1,0,1,0), BackgroundTransparency = 1, Text = "" })
    
    btnOverlay.MouseEnter:Connect(function() Tween(toggleFrame, {BackgroundColor3 = Theme.ElementHover}, 0.2) end)
    btnOverlay.MouseLeave:Connect(function() Tween(toggleFrame, {BackgroundColor3 = Theme.Element}, 0.2) end)
    
    btnOverlay.MouseButton1Click:Connect(function()
        state = not state; callback(state)
        if state then
            Tween(switchBtn, {BackgroundColor3 = Theme.Accent}, 0.3, Enum.EasingStyle.Elastic); Tween(indicator, {Position = UDim2.new(1, -20, 0.5, -9), BackgroundColor3 = Theme.Text}, 0.3, Enum.EasingStyle.Bounce)
            Notify(text .. " Enabled")
        else
            Tween(switchBtn, {BackgroundColor3 = Theme.Background}, 0.3, Enum.EasingStyle.Quad); Tween(indicator, {Position = UDim2.new(0, 2, 0.5, -9), BackgroundColor3 = Theme.TextDark}, 0.3, Enum.EasingStyle.Bounce)
            Notify(text .. " Disabled")
        end
    end)
    return {
        SetActive = function(new_state)
            if state ~= new_state then state = new_state; callback(state)
                if state then Tween(switchBtn, {BackgroundColor3 = Theme.Accent}, 0.3); Tween(indicator, {Position = UDim2.new(1, -20, 0.5, -9), BackgroundColor3 = Theme.Text}, 0.3)
                else Tween(switchBtn, {BackgroundColor3 = Theme.Background}, 0.3); Tween(indicator, {Position = UDim2.new(0, 2, 0.5, -9), BackgroundColor3 = Theme.TextDark}, 0.3) end
            end
        end,
        GetState = function() return state end
    }
end

function Library:AddSlider(page, text, min, max, default, callback)
    local val = default
    local sliderFrame = Create("Frame", { Parent = page, Size = UDim2.new(1, 0, 0, 55), BackgroundColor3 = Theme.Element })
    Create("UICorner", { CornerRadius = UDim.new(0, 6), Parent = sliderFrame })
    Create("TextLabel", { Parent = sliderFrame, Size = UDim2.new(1, -30, 0, 25), Position = UDim2.new(0, 15, 0, 5), BackgroundTransparency = 1, Text = text, TextColor3 = Theme.Text, Font = Enum.Font.Gotham, TextSize = 14, TextXAlignment = Enum.TextXAlignment.Left })
    local valLabel = Create("TextLabel", { Parent = sliderFrame, Size = UDim2.new(0, 50, 0, 25), Position = UDim2.new(1, -65, 0, 5), BackgroundTransparency = 1, Text = tostring(default), TextColor3 = Theme.Accent, Font = Enum.Font.GothamBold, TextSize = 14, TextXAlignment = Enum.TextXAlignment.Right })
    local track = Create("TextButton", { Parent = sliderFrame, Size = UDim2.new(1, -30, 0, 6), Position = UDim2.new(0, 15, 1, -18), BackgroundColor3 = Theme.Background, Text = "", AutoButtonColor = false })
    Create("UICorner", { CornerRadius = UDim.new(1, 0), Parent = track })
    local fill = Create("Frame", { Parent = track, Size = UDim2.new((default - min)/(max - min), 0, 1, 0), BackgroundColor3 = Theme.Accent })
    Create("UICorner", { CornerRadius = UDim.new(1, 0), Parent = fill })
    
    local dragging = false
    track.MouseButton1Down:Connect(function() dragging = true end)
    UserInputService.InputEnded:Connect(function(input) if input.UserInputType == Enum.UserInputType.MouseButton1 then dragging = false end end)
    UserInputService.InputChanged:Connect(function(input)
        if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
            local pos = math.clamp((input.Position.X - track.AbsolutePosition.X) / track.AbsoluteSize.X, 0, 1)
            val = math.floor(min + ((max - min) * pos)); valLabel.Text = tostring(val)
            Tween(fill, {Size = UDim2.new(pos, 0, 1, 0)}, 0.1); callback(val)
        end
    end)
end

function Library:AddKeybind(page, text, default, targetToggle, callback)
    local key = default
    local bindFrame = Create("Frame", { Parent = page, Size = UDim2.new(1, 0, 0, 42), BackgroundColor3 = Theme.Element })
    Create("UICorner", { CornerRadius = UDim.new(0, 6), Parent = bindFrame })
    Create("TextLabel", { Parent = bindFrame, Size = UDim2.new(1, -90, 1, 0), Position = UDim2.new(0, 15, 0, 0), BackgroundTransparency = 1, Text = text, TextColor3 = Theme.Text, Font = Enum.Font.Gotham, TextSize = 14, TextXAlignment = Enum.TextXAlignment.Left })
    local btn = Create("TextButton", { Parent = bindFrame, Size = UDim2.new(0, 65, 0, 26), Position = UDim2.new(1, -80, 0.5, -13), BackgroundColor3 = Theme.Background, Text = key and key.Name or "None", TextColor3 = Theme.Accent, Font = Enum.Font.GothamBold, TextSize = 12 })
    Create("UICorner", { CornerRadius = UDim.new(0, 4), Parent = btn })
    Create("UIStroke", { Parent = btn, Color = Theme.Accent, Thickness = 1, Transparency = 0.5 })
    
    local listening = false
    local function setKey(newKey)
        key = newKey; btn.Text = key and key.Name or "None"
        Library.Keybinds[text] = { Key = key, Callback = function() if targetToggle then targetToggle.SetActive(not targetToggle.GetState()) end; if callback then callback() end end, Button = btn, SetKey = setKey }
    end
    setKey(default)
    
    btn.MouseButton1Click:Connect(function() listening = true; btn.Text = "..."; Tween(btn, {BackgroundColor3 = Theme.ElementHover}, 0.2) end)
    UserInputService.InputBegan:Connect(function(input)
        if listening and input.UserInputType == Enum.UserInputType.Keyboard then
            listening = false; setKey(input.KeyCode)
            Tween(btn, {BackgroundColor3 = Theme.Background}, 0.2)
        end
    end)
end

function Library:AddDropdown(page, text, options, callback)
    local open = false
    local ddFrame = Create("Frame", { Parent = page, Size = UDim2.new(1, 0, 0, 42), BackgroundColor3 = Theme.Element, ClipsDescendants = true })
    Create("UICorner", { CornerRadius = UDim.new(0, 6), Parent = ddFrame })
    local btn = Create("TextButton", { Parent = ddFrame, Size = UDim2.new(1, 0, 0, 42), BackgroundTransparency = 1, Text = "  " .. text .. " : " .. options[1], TextColor3 = Theme.Text, Font = Enum.Font.Gotham, TextSize = 14, TextXAlignment = Enum.TextXAlignment.Left })
    local list = Create("ScrollingFrame", { Parent = ddFrame, Size = UDim2.new(1, 0, 1, -42), Position = UDim2.new(0, 0, 0, 42), BackgroundTransparency = 1, ScrollBarThickness = 2, BorderSizePixel = 0 })
    local lLayout = Create("UIListLayout", { Parent = list, SortOrder = Enum.SortOrder.LayoutOrder })
    local targetSize = 42 + (math.clamp(#options, 1, 4) * 30)
    
    btn.MouseButton1Click:Connect(function() open = not open; Tween(ddFrame, {Size = UDim2.new(1, 0, 0, open and targetSize or 42)}, 0.3, Enum.EasingStyle.Quad) end)
    for i, v in ipairs(options) do
        local optBtn = Create("TextButton", { Parent = list, Size = UDim2.new(1, 0, 0, 30), BackgroundColor3 = Theme.ElementHover, Text = v, TextColor3 = Theme.TextDark, Font = Enum.Font.Gotham, TextSize = 13 })
        optBtn.MouseEnter:Connect(function() optBtn.TextColor3 = Theme.Accent end); optBtn.MouseLeave:Connect(function() optBtn.TextColor3 = Theme.TextDark end)
        optBtn.MouseButton1Click:Connect(function() open = false; Tween(ddFrame, {Size = UDim2.new(1, 0, 0, 42)}, 0.3); btn.Text = "  " .. text .. " : " .. v; callback(v) end)
    end
    list.CanvasSize = UDim2.new(0, 0, 0, #options * 30)
end

function Library:AddTextBox(page, text, placeholder, callback)
    local boxFrame = Create("Frame", { Parent = page, Size = UDim2.new(1, 0, 0, 65), BackgroundColor3 = Theme.Element })
    Create("UICorner", { CornerRadius = UDim.new(0, 6), Parent = boxFrame })
    Create("TextLabel", { Parent = boxFrame, Size = UDim2.new(1, -30, 0, 25), Position = UDim2.new(0, 15, 0, 5), BackgroundTransparency = 1, Text = text, TextColor3 = Theme.Text, Font = Enum.Font.Gotham, TextSize = 14, TextXAlignment = Enum.TextXAlignment.Left })
    local box = Create("TextBox", { Parent = boxFrame, Size = UDim2.new(1, -30, 0, 28), Position = UDim2.new(0, 15, 0, 30), BackgroundColor3 = Theme.Background, Text = "", PlaceholderText = placeholder, TextColor3 = Theme.Text, Font = Enum.Font.Gotham, TextSize = 13 })
    Create("UICorner", { CornerRadius = UDim.new(0, 4), Parent = box })
    box.FocusLost:Connect(function(enterMsg) callback(box.Text, enterMsg) end)
end

function Library:AddPlayerSelect(page)
    local frame = Create("Frame", { Parent = page, Size = UDim2.new(1, 0, 0, 70), BackgroundColor3 = Theme.Element, ZIndex = 5 })
    Create("UICorner", { CornerRadius = UDim.new(0, 6), Parent = frame })
    Create("TextLabel", { Parent = frame, Size = UDim2.new(1, -30, 0, 25), Position = UDim2.new(0, 15, 0, 5), BackgroundTransparency = 1, Text = "Select Target (Auto-complete):", TextColor3 = Theme.Text, Font = Enum.Font.Gotham, TextSize = 14, TextXAlignment = Enum.TextXAlignment.Left, ZIndex = 5 })
    local box = Create("TextBox", { Parent = frame, Size = UDim2.new(1, -30, 0, 28), Position = UDim2.new(0, 15, 0, 32), BackgroundColor3 = Theme.Background, Text = "", PlaceholderText = "Type player name...", TextColor3 = Theme.Accent, Font = Enum.Font.GothamBold, TextSize = 13, ZIndex = 5 })
    Create("UICorner", { CornerRadius = UDim.new(0, 4), Parent = box })
    Create("UIStroke", { Parent = box, Color = Theme.Accent, Thickness = 1, Transparency = 0.5 })
    local listFrame = Create("ScrollingFrame", { Parent = frame, Size = UDim2.new(1, -30, 0, 120), Position = UDim2.new(0, 15, 0, 65), BackgroundColor3 = Theme.ElementHover, Visible = false, ZIndex = 10, ScrollBarThickness = 3, BorderSizePixel = 0 })
    Create("UIListLayout", {Parent = listFrame, SortOrder = Enum.SortOrder.LayoutOrder})
    
    box.Changed:Connect(function(prop)
        if prop == "Text" then
            local text = box.Text:lower()
            if text == "" then listFrame.Visible = false return end
            for _, child in pairs(listFrame:GetChildren()) do if child:IsA("TextButton") then child:Destroy() end end
            
            local matches = {}
            for _, p in pairs(Players:GetPlayers()) do if p ~= LocalPlayer and p.Name:lower():sub(1, #text) == text then table.insert(matches, p) end end
            
            if #matches > 0 then
                listFrame.Visible = true; listFrame.Size = UDim2.new(1, -30, 0, math.clamp(#matches * 30, 30, 120))
                for _, p in pairs(matches) do
                    local btn = Create("TextButton", { Parent = listFrame, Size = UDim2.new(1, 0, 0, 30), BackgroundTransparency = 1, Text = "  " .. p.Name, TextColor3 = Theme.Text, Font = Enum.Font.Gotham, TextSize = 14, TextXAlignment = Enum.TextXAlignment.Left, ZIndex = 11 })
                    btn.MouseEnter:Connect(function() btn.TextColor3 = Theme.Accent end); btn.MouseLeave:Connect(function() btn.TextColor3 = Theme.Text end)
                    btn.MouseButton1Click:Connect(function() box.Text = p.Name; SharedState.SelectedTarget = p; listFrame.Visible = false end)
                end
                listFrame.CanvasSize = UDim2.new(0, 0, 0, #matches * 30)
            else listFrame.Visible = false end
        end
    end)
end

-- ==========================================
-- ** Pages Initialization **
-- ==========================================
local PagePlayer = Library:AddTab("🏃", "LocalPlayer")
local PageAim    = Library:AddTab("🔫", "Aimbot")
local PageTarget = Library:AddTab("🎯", "Target")
local PageVeh    = Library:AddTab("🚗", "Vehicle")
local PageTroll  = Library:AddTab("🤡", "Troll")
local PageVis    = Library:AddTab("👁️", "Visuals")
local PageSpy    = Library:AddTab("📊", "Spy & Scanner")
local PageLogs   = Library:AddTab("📜", "Console Logs")
local PageUtil   = Library:AddTab("🧰", "Utility")
local PageServer = Library:AddTab("🌐", "Server")
local PageSet    = Library:AddTab("⚙️", "Settings")
local PageDev    = Library:AddTab("🛠️", "Developer")

-- ==========================================
-- ** 🔫 Aimbot Page **
-- ==========================================
Library:AddSection(PageAim, "Combat Aiming")
Library:AddToggle(PageAim, "Enable Aimbot", function(s) SharedState.Aimbot = s end)
Library:AddToggle(PageAim, "Show FOV Circle", function(s) SharedState.ShowFOV = s end)
Library:AddSlider(PageAim, "FOV Radius", 50, 500, 150, function(v) SharedState.FOVRadius = v end)
Library:AddSlider(PageAim, "Smoothness", 1, 10, 5, function(v) SharedState.AimSmoothness = v end)
Library:AddDropdown(PageAim, "Target Part", {"Head", "Torso", "HumanoidRootPart"}, function(v) SharedState.TargetPart = v end)
Library:AddDropdown(PageAim, "Aim Key", {"Right Click", "Left Click", "E", "Q", "C", "LeftShift", "LeftAlt"}, function(v) SharedState.AimKey = v end)

-- ==========================================
-- ** 🏃‍♂️ LocalPlayer Page ** 
-- ==========================================
Library:AddSection(PagePlayer, "Movement Settings")
Library:AddToggle(PagePlayer, "Sınırsız Stamina (No Stamina)", function(state) SharedState.NoStamina = state end)
Library:AddSlider(PagePlayer, "WalkSpeed", 16, 300, 16, function(val) SharedState.WalkSpeed = val end)
Library:AddSlider(PagePlayer, "JumpPower", 50, 400, 50, function(val) SharedState.JumpPower = val end)
Library:AddToggle(PagePlayer, "CFrame WalkSpeed (Bypass)", function(state) SharedState.CFrameSpeedActive = state end)
Library:AddSlider(PagePlayer, "CFrame Speed", 1, 10, 2, function(val) SharedState.CFrameSpeed = val end)
Library:AddToggle(PagePlayer, "Auto-Bhop", function(state) SharedState.AutoBhop = state end)

local oldWalkSpeed = 16
local oldFOV = 70
local ToggleCinematic = Library:AddToggle(PagePlayer, "Cinematic Walk", function(state)
    SharedState.CinematicWalk = state
    if state then
        oldWalkSpeed = SharedState.WalkSpeed
        oldFOV = Camera.FieldOfView
        SharedState.WalkSpeed = 7
        Tween(Camera, {FieldOfView = 60}, 1, Enum.EasingStyle.Sine)
    else
        SharedState.WalkSpeed = oldWalkSpeed
        Tween(Camera, {FieldOfView = oldFOV}, 1, Enum.EasingStyle.Sine)
    end
end)
Library:AddKeybind(PagePlayer, "Cinematic Walk Bind", nil, ToggleCinematic)

Library:AddSection(PagePlayer, "Flight Mechanics")
local bgFly, bvFly
local ToggleFly = Library:AddToggle(PagePlayer, "Standard Fly (BodyMover)", function(state) 
    SharedState.FlyActive = state
    local char = LocalPlayer.Character
    if not char then return end
    local hrp = char.PrimaryPart or char:FindFirstChild("HumanoidRootPart")
    local hum = char:FindFirstChildWhichIsA("Humanoid")
    if not hrp then return end
    
    if state then
        bgFly = Instance.new("BodyGyro", hrp)
        bgFly.P = 9e4; bgFly.maxTorque = Vector3.new(9e9, 9e9, 9e9); bgFly.cframe = hrp.CFrame
        bvFly = Instance.new("BodyVelocity", hrp)
        bvFly.velocity = Vector3.new(0,0,0); bvFly.maxForce = Vector3.new(9e9, 9e9, 9e9)
        if hum then hum.PlatformStand = true end
    else
        if bgFly then bgFly:Destroy() end
        if bvFly then bvFly:Destroy() end
        if hum then hum.PlatformStand = false; hum:ChangeState(Enum.HumanoidStateType.GettingUp) end
    end
end)
Library:AddKeybind(PagePlayer, "Fly Keybind", nil, ToggleFly)
Library:AddToggle(PagePlayer, "Stealth (CFrame) Fly [BYPASS]", function(state) 
    SharedState.StealthFly = state
    local char = LocalPlayer.Character
    if char and char:FindFirstChildWhichIsA("Humanoid") then
        local hum = char:FindFirstChildWhichIsA("Humanoid")
        hum.PlatformStand = state
        if not state then hum:ChangeState(Enum.HumanoidStateType.GettingUp) end
        local hrp = char.PrimaryPart or char:FindFirstChild("HumanoidRootPart")
        if state and hrp then
            hrp.Velocity = Vector3.new(0,0,0)
        end
    end
end)
Library:AddSlider(PagePlayer, "Fly Speed", 10, 300, 50, function(val) SharedState.FlySpeed = val end)

Library:AddSection(PagePlayer, "Abilities")
local noclipConnection
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
end)
Library:AddKeybind(PagePlayer, "Noclip Keybind", nil, ToggleNoclip)
Library:AddToggle(PagePlayer, "Infinite Jump (Bypass Mode)", function(state) SharedState.InfJumpActive = state end)
Library:AddKeybind(PagePlayer, "Manual Platform", nil, nil, function()
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
end)
Library:AddToggle(PagePlayer, "Spider (Wall Climb)", function(state) SharedState.Spider = state end)
Library:AddToggle(PagePlayer, "Anti-Fall Damage", function(state) SharedState.AntiFallDamage = state end)

Library:AddSection(PagePlayer, "Quick Teleport Bypass")
SharedState.QuickTPDistance = 10
Library:AddSlider(PagePlayer, "Teleport Distance", 5, 50, 10, function(v) SharedState.QuickTPDistance = v end)

local function QuickStepTeleport(direction)
    local char = LocalPlayer.Character
    if char and char:FindFirstChild("HumanoidRootPart") then
        local hrp = char.HumanoidRootPart
        local offset = hrp.CFrame.lookVector * SharedState.QuickTPDistance * direction
        -- Instantly shift CFrame, ignoring collision temporarily
        local oldCollide = hrp.CanCollide
        hrp.CanCollide = false
        hrp.CFrame = hrp.CFrame + offset
        hrp.CanCollide = oldCollide
    end
end

Library:AddKeybind(PagePlayer, "Forward Step TP", nil, nil, function()
    QuickStepTeleport(1)
end)
Library:AddKeybind(PagePlayer, "Backward Step TP", nil, nil, function()
    QuickStepTeleport(-1)
end)


local fcYaw, fcPitch = 0, 0
local ToggleFreecam = Library:AddToggle(PagePlayer, "Freecam 3D", function(state)
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
Library:AddSlider(PagePlayer, "Freecam Speed", 1, 10, 1, function(val) SharedState.FreecamSpeed = val end)

local flyCtrl = {f = 0, b = 0, l = 0, r = 0, u = 0, d = 0}
UserInputService.InputBegan:Connect(function(input, gpe)
    if gpe then return end
    if input.KeyCode == Enum.KeyCode.W then flyCtrl.f = 1 elseif input.KeyCode == Enum.KeyCode.S then flyCtrl.b = 1
    elseif input.KeyCode == Enum.KeyCode.A then flyCtrl.l = 1 elseif input.KeyCode == Enum.KeyCode.D then flyCtrl.r = 1
    elseif input.KeyCode == Enum.KeyCode.Space then flyCtrl.u = 1 
    elseif input.KeyCode == Enum.KeyCode.LeftShift or input.KeyCode == Enum.KeyCode.LeftControl then flyCtrl.d = 1 end
end)
UserInputService.InputEnded:Connect(function(input, gpe)
    if gpe then return end
    if input.KeyCode == Enum.KeyCode.W then flyCtrl.f = 0 elseif input.KeyCode == Enum.KeyCode.S then flyCtrl.b = 0
    elseif input.KeyCode == Enum.KeyCode.A then flyCtrl.l = 0 elseif input.KeyCode == Enum.KeyCode.D then flyCtrl.r = 0
    elseif input.KeyCode == Enum.KeyCode.Space then flyCtrl.u = 0
    elseif input.KeyCode == Enum.KeyCode.LeftShift or input.KeyCode == Enum.KeyCode.LeftControl then flyCtrl.d = 0 end
end)

-- ==========================================
-- ** 🎯 Target Page **
-- ==========================================
Library:AddPlayerSelect(PageTarget)
Library:AddToggle(PageTarget, "Notify on Target Leave", function(s) SharedState.TargetLeaveNotify = s end)
Library:AddSection(PageTarget, "Interactions")
Library:AddButton(PageTarget, "Instant Teleport (Goto)", function()
    local tChar = SharedState.SelectedTarget and SharedState.SelectedTarget.Character
    if tChar and tChar:FindFirstChild("HumanoidRootPart") and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
        LocalPlayer.Character.HumanoidRootPart.CFrame = tChar.HumanoidRootPart.CFrame * CFrame.new(0, 0, 3)
    end
end)
Library:AddButton(PageTarget, "Tween Teleport [BYPASS]", function()
    local tChar = SharedState.SelectedTarget and SharedState.SelectedTarget.Character
    local myHrp = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
    if tChar and tChar:FindFirstChild("HumanoidRootPart") and myHrp then
        local targetPos = tChar.HumanoidRootPart.CFrame * CFrame.new(0,0,3)
        local dist = (myHrp.Position - targetPos.Position).Magnitude
        Tween(myHrp, {CFrame = targetPos}, dist / 150, Enum.EasingStyle.Linear)
    end
end)
Library:AddToggle(PageTarget, "Spectate Target", function(state)
    if state and SharedState.SelectedTarget and SharedState.SelectedTarget.Character then
        Camera.CameraSubject = SharedState.SelectedTarget.Character:FindFirstChildOfClass("Humanoid")
    elseif LocalPlayer.Character then Camera.CameraSubject = LocalPlayer.Character:FindFirstChildOfClass("Humanoid") end
end)

Library:AddSection(PageTarget, "Advanced Loop Follow")
Library:AddToggle(PageTarget, "Loop Follow Target", function(state) 
    SharedState.LoopFollow = state 
    if not state and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
        LocalPlayer.Character.Humanoid.Sit = false
    end
end)
Library:AddSlider(PageTarget, "Follow Distance", 0, 20, 3, function(val) SharedState.FollowDistance = val end)
Library:AddSlider(PageTarget, "Height Offset", -10, 20, 1, function(val) SharedState.FollowHeight = val end)

-- ==========================================
-- ** 🚗 Vehicle Page **
-- ==========================================
Library:AddSection(PageVeh, "Vehicle Nitro Boost")
Library:AddToggle(PageVeh, "Enable Nitro Boost", function(v) SharedState.VehNitroActive = v end)
Library:AddKeybind(PageVeh, "Nitro Key", nil, nil, function() end)
Library:AddSlider(PageVeh, "Nitro Power", 10, 150, 50, function(v) SharedState.VehNitroPower = v end)

Library:AddSection(PageVeh, "Vehicle Flight")
local vBg, vBv
Library:AddToggle(PageVeh, "Vehicle Fly", function(state)
    SharedState.VehFlyActive = state
    local seat = LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid") and LocalPlayer.Character.Humanoid.SeatPart
    if seat then
        if state then
            vBg = Instance.new("BodyGyro", seat)
            vBg.P = 90000; vBg.MaxTorque = Vector3.new(math.huge, math.huge, math.huge); vBg.CFrame = seat.CFrame
            vBv = Instance.new("BodyVelocity", seat)
            vBv.Velocity = Vector3.new(0,0,0); vBv.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
        else
            if vBg then vBg:Destroy() end
            if vBv then vBv:Destroy() end
        end
    end
end)
Library:AddSlider(PageVeh, "Vehicle Fly Speed", 10, 500, 50, function(v) SharedState.VehFlySpeed = v end)

Library:AddSection(PageVeh, "Vehicle Modifiers")
Library:AddToggle(PageVeh, "Vehicle Speed Boost", function(v) SharedState.VehSpeedActive = v end)
Library:AddSlider(PageVeh, "Speed Modifier", 50, 500, 100, function(v) SharedState.VehSpeed = v end)
Library:AddToggle(PageVeh, "Vehicle Noclip", function(v) SharedState.VehNoclip = v end)
Library:AddButton(PageVeh, "Vehicle Brake (Stop)", function()
    local seat = LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid") and LocalPlayer.Character.Humanoid.SeatPart
    if seat and seat.Parent and seat.Parent.PrimaryPart then
        seat.Parent.PrimaryPart.AssemblyLinearVelocity = Vector3.new(0,0,0)
        seat.Parent.PrimaryPart.AssemblyAngularVelocity = Vector3.new(0,0,0)
    end
end)
Library:AddKeybind(PageVeh, "Quick Brake Bind", nil, nil, function()
    local seat = LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid") and LocalPlayer.Character.Humanoid.SeatPart
    if seat and seat.Parent and seat.Parent.PrimaryPart then
        seat.Parent.PrimaryPart.AssemblyLinearVelocity = Vector3.new(0,0,0)
        seat.Parent.PrimaryPart.AssemblyAngularVelocity = Vector3.new(0,0,0)
    end
end)
Library:AddButton(PageVeh, "Auto-Flip Vehicle", function()
    local seat = LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid") and LocalPlayer.Character.Humanoid.SeatPart
    if seat then seat.CFrame = CFrame.new(seat.Position) * CFrame.Angles(0, math.rad(seat.Rotation.Y), 0) + Vector3.new(0, 3, 0) end
end)

-- ==========================================
-- ** 🤡 Troll Page **
-- ==========================================
Library:AddSection(PageTroll, "Fake Chat (Spoof Message)")

local fakeChatTarget = ""
Library:AddTextBox(PageTroll, "Fake Chat Target", "Hedef Oyuncu Adı...", function(text) fakeChatTarget = text end)

local fakeChatMessage = ""
Library:AddTextBox(PageTroll, "Fake Chat Message", "Sahte Mesajı Yaz...", function(text) fakeChatMessage = text end)

Library:AddButton(PageTroll, "Send Fake Message", function()
    if fakeChatTarget == "" or fakeChatMessage == "" then
        Notify("Lütfen hedef oyuncu ve mesaj girin!")
        return
    end

    local targetName = fakeChatTarget
    local targetPlayer = nil
    
    -- Hedef oyuncuyu bulmaya çalış
    for _, p in pairs(Players:GetPlayers()) do
        if string.lower(p.Name) == string.lower(fakeChatTarget) or string.lower(p.DisplayName) == string.lower(fakeChatTarget) then
            targetPlayer = p
            break
        end
    end
    
    -- Bulunduysa DisplayName (Görünen Ad) kullan, yoksa yazılan ismi kullan
    if targetPlayer then
        targetName = targetPlayer.DisplayName
    end

    local formattedMessage = "[" .. targetName .. "]: " .. fakeChatMessage

    -- Yeni Nesil TextChatService Desteği
    local TextChatService = game:GetService("TextChatService")
    if TextChatService.ChatVersion == Enum.ChatVersion.TextChatService then
        local systemChannel = TextChatService.TextChannels:FindFirstChild("RBXSystem")
        if systemChannel then
            systemChannel:DisplaySystemMessage(formattedMessage)
        end
    else
        -- Eski Nesil Legacy Chat Desteği
        game:GetService("StarterGui"):SetCore("ChatMakeSystemMessage", {
            Text = formattedMessage,
            Color = Color3.fromRGB(255, 255, 255),
            Font = Enum.Font.SourceSansBold,
            TextSize = 18
        })
    end
    Notify("Sahte mesaj gönderildi!")
end)

Library:AddSection(PageTroll, "Fun & Ragdoll")
local RagdollStorage = {}
local ToggleRagdoll = Library:AddToggle(PageTroll, "Ragdoll / Play Dead", function(state)
    local char = LocalPlayer.Character
    if not char then return end
    local hum = char:FindFirstChildOfClass("Humanoid")
    if state then
        if hum then hum.PlatformStand = true; hum:ChangeState(Enum.HumanoidStateType.Physics) end
        if not RagdollStorage[char] then
            RagdollStorage[char] = {}
            for _, motor in pairs(char:GetDescendants()) do
                if motor:IsA("Motor6D") and motor.Name ~= "RootPart" then
                    local p0, p1 = motor.Part0, motor.Part1
                    if p0 and p1 then
                        local a0, a1 = Instance.new("Attachment", p0), Instance.new("Attachment", p1)
                        a0.CFrame = motor.C0; a1.CFrame = motor.C1
                        local soc = Instance.new("BallSocketConstraint", p0)
                        soc.Attachment0 = a0; soc.Attachment1 = a1
                        soc.TwistLimitsEnabled = true; soc.LimitsEnabled = true
                        soc.Parent = p0
                        table.insert(RagdollStorage[char], {m = motor, a0 = a0, a1 = a1, s = soc})
                        motor.Enabled = false
                    end
                end
            end
        end
    else
        if RagdollStorage[char] then
            for _, d in pairs(RagdollStorage[char]) do
                if d.m then d.m.Enabled = true end
                if d.s then d.s:Destroy() end
                if d.a0 then d.a0:Destroy() end
                if d.a1 then d.a1:Destroy() end
            end
            RagdollStorage[char] = nil
        end
        if hum then hum.PlatformStand = false; hum:ChangeState(Enum.HumanoidStateType.GettingUp) end
    end
end)
Library:AddKeybind(PageTroll, "Ragdoll Bind", nil, ToggleRagdoll)

Library:AddSection(PageTroll, "Combat / Disruption")
Library:AddToggle(PageTroll, "Fling Target", function(state)
    SharedState.FlingActive = state
    local bg
    if state then
        if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
            local hrp = LocalPlayer.Character.HumanoidRootPart
            bg = Instance.new("BodyAngularVelocity", hrp)
            bg.Name = "VexelFling"; bg.AngularVelocity = Vector3.new(99999, 99999, 99999)
            bg.MaxTorque = Vector3.new(99999, 99999, 99999); bg.P = math.huge
        end
    else
        if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
            local f = LocalPlayer.Character.HumanoidRootPart:FindFirstChild("VexelFling")
            if f then f:Destroy() end
            LocalPlayer.Character.HumanoidRootPart.RotVelocity = Vector3.new(0,0,0)
        end
    end
end)

Library:AddToggle(PageTroll, "Perfect Invisibility", function(state)
    SharedState.Invisible = state
    if state then
        if LocalPlayer.Character then
            for _, v in pairs(LocalPlayer.Character:GetDescendants()) do
                if (v:IsA("BasePart") and v.Name ~= "HumanoidRootPart") or v:IsA("Decal") then v.Transparency = 1 end
                if v:IsA("Accessory") and v:FindFirstChild("Handle") then v.Handle.Transparency = 1 end
            end
        end
    else
        if LocalPlayer.Character then
            for _, v in pairs(LocalPlayer.Character:GetDescendants()) do
                if (v:IsA("BasePart") and v.Name ~= "HumanoidRootPart") or v:IsA("Decal") then v.Transparency = 0 end
                if v:IsA("Accessory") and v:FindFirstChild("Handle") then v.Handle.Transparency = 0 end
            end
        end
    end
end)

Library:AddSection(PageTroll, "Annoyance")
Library:AddToggle(PageTroll, "Spinbot", function(s) SharedState.Spinbot = s end)
Library:AddSlider(PageTroll, "Spin Speed", 5, 100, 20, function(v) SharedState.SpinSpeed = v end)

-- ==========================================
-- ** 👁️ Visuals Page **
-- ==========================================
Library:AddSection(PageVis, "ESP Settings")
Library:AddToggle(PageVis, "Name ESP", function(s) SharedState.ESP.Name = s end)
Library:AddToggle(PageVis, "Health ESP", function(s) SharedState.ESP.Health = s end)
Library:AddToggle(PageVis, "Chams ESP", function(s) SharedState.ESP.Chams = s end)

Library:AddSection(PageVis, "Tracers & Camera")
Library:AddToggle(PageVis, "Player Tracers", function(s) SharedState.Tracers = s end)
Library:AddDropdown(PageVis, "Tracer Origin", {"Bottom", "Center"}, function(val) SharedState.TracerOrigin = val end)
Library:AddSlider(PageVis, "Camera FOV", 70, 120, 70, function(val) Camera.FieldOfView = val end)
Library:AddToggle(PageVis, "Infinity Zoom", function(state)
    if state then
        LocalPlayer.CameraMaxZoomDistance = math.huge
        Notify("Infinity Zoom Enabled!")
    else
        LocalPlayer.CameraMaxZoomDistance = 400
        Notify("Infinity Zoom Disabled")
    end
end)

Library:AddSection(PageVis, "Combat Tools")
Library:AddToggle(PageVis, "Hitbox & Reach Expander (Player+NPC)", function(s) SharedState.HitboxExpander = s end)
Library:AddSlider(PageVis, "Hitbox Size", 2, 50, 5, function(v) SharedState.HitboxSize = v end)

-- ==========================================
-- ** 📊 Spy & Scanner Page **
-- ==========================================
Library:AddSection(PageSpy, "Intelligence Gathering")
Library:AddToggle(PageSpy, "Enable Chat Spy (All Channels)", function(state) SharedState.ChatSpy = state end)

local scannerResult = Create("TextLabel", {
    Parent = PageSpy, Size = UDim2.new(1, 0, 0, 120), BackgroundColor3 = Theme.LogBg, TextColor3 = Theme.Accent, TextWrapped = true, TextYAlignment = Enum.TextYAlignment.Top, TextXAlignment = Enum.TextXAlignment.Left, Font = Enum.Font.Code, TextSize = 13, Text = "Select a player from Target tab to scan."
})
Create("UICorner", { CornerRadius = UDim.new(0, 6), Parent = scannerResult })
Create("UIPadding", { Parent = scannerResult, PaddingTop = UDim.new(0,5), PaddingLeft = UDim.new(0,5) })

Library:AddButton(PageSpy, "Scan Selected Target", function()
    local t = SharedState.SelectedTarget
    if t then
        local hp = t.Character and t.Character:FindFirstChild("Humanoid") and t.Character.Humanoid.Health or 0
        local maxHp = t.Character and t.Character:FindFirstChild("Humanoid") and t.Character.Humanoid.MaxHealth or 0
        local tools = {}
        if t.Character then for _,v in pairs(t.Character:GetChildren()) do if v:IsA("Tool") then table.insert(tools, v.Name) end end end
        if t:FindFirstChild("Backpack") then for _,v in pairs(t.Backpack:GetChildren()) do if v:IsA("Tool") then table.insert(tools, v.Name) end end end
        scannerResult.Text = string.format("TARGET SCAN: %s\n--------------------\nHealth: %d / %d\nTools / Inventory:\n%s", t.Name, hp, maxHp, table.concat(tools, "\n- "))
    else scannerResult.Text = "No target selected." end
end)

-- ==========================================
-- ** 📜 Console Logs Page **
-- ==========================================
local filterBoxFrame = Create("Frame", { Parent = PageLogs, Size = UDim2.new(1, 0, 0, 35), BackgroundColor3 = Theme.Element })
Create("UICorner", { CornerRadius = UDim.new(0, 6), Parent = filterBoxFrame })
local filterBox = Create("TextBox", { Parent = filterBoxFrame, Size = UDim2.new(1, -20, 1, 0), Position = UDim2.new(0, 10, 0, 0), BackgroundTransparency = 1, Text = "", PlaceholderText = "🔍 Filter Logs by Player...", TextColor3 = Theme.Text, Font = Enum.Font.Gotham, TextSize = 13, TextXAlignment = Enum.TextXAlignment.Left })

local LogConsole = Create("ScrollingFrame", { Parent = PageLogs, Size = UDim2.new(1, 0, 0, 260), BackgroundColor3 = Theme.LogBg, ScrollBarThickness = 4, BorderSizePixel = 0, CanvasSize = UDim2.new(0,0,0,0) })
Create("UICorner", { CornerRadius = UDim.new(0, 6), Parent = LogConsole })
local logLayout = Create("UIListLayout", { Parent = LogConsole, SortOrder = Enum.SortOrder.LayoutOrder, Padding = UDim.new(0, 2) })
logLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function() LogConsole.CanvasSize = UDim2.new(0,0,0, logLayout.AbsoluteContentSize.Y) end)

filterBox:GetPropertyChangedSignal("Text"):Connect(function()
    local q = filterBox.Text:lower()
    for _, child in pairs(LogConsole:GetChildren()) do
        if child:IsA("TextLabel") then
            if q == "" then child.Visible = true else child.Visible = string.find(child.Text:lower(), q) ~= nil end
        end
    end
end)

local function WriteLog(text, color)
    Create("TextLabel", { Parent = LogConsole, Size = UDim2.new(1, -10, 0, 18), BackgroundTransparency = 1, Text = " " .. text, TextColor3 = color, Font = Enum.Font.Code, TextSize = 13, TextXAlignment = Enum.TextXAlignment.Left, TextWrapped = true })
    if #LogConsole:GetChildren() > 100 then LogConsole:GetChildren()[2]:Destroy() end
    LogConsole.CanvasPosition = Vector2.new(0, 99999)
end

Players.PlayerAdded:Connect(function(p) WriteLog(string.format("[JOIN] %s", p.Name), Color3.fromRGB(50, 255, 50)) end)
Players.PlayerRemoving:Connect(function(p) 
    WriteLog(string.format("[LEAVE] %s", p.Name), Color3.fromRGB(255, 50, 50))
    if SharedState.SelectedTarget and p.Name == SharedState.SelectedTarget.Name then
        SharedState.SelectedTarget = nil
        if SharedState.TargetLeaveNotify then
            TargetLeaveNotifText.Text = string.format("⚠️ %s OYUNDAN ÇIKTI! ⚠️", string.upper(p.Name))
            TargetLeaveNotifFrame.Visible = true
            Tween(TargetLeaveNotifFrame, {Position = UDim2.new(0.5, -350, 0, 50)}, 0.5, Enum.EasingStyle.Bounce)
            task.spawn(function()
                task.wait(4.5)
                local twOut = Tween(TargetLeaveNotifFrame, {Position = UDim2.new(0.5, -350, 0, -100)}, 0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.In)
                twOut.Completed:Wait()
                TargetLeaveNotifFrame.Visible = false
            end)
        end
    end
end)

local function hookChat()
    local success, err = pcall(function()
        StarterGui:SetCore("ChatMakeSystemMessage", {
            Text = "[Vexel System]: Chat Spy Hooked!",
            Color = Color3.fromRGB(138, 43, 226),
            Font = Enum.Font.SourceSansBold,
            TextSize = 18
        })
    end)
    for _, p in pairs(Players:GetPlayers()) do
        p.Chatted:Connect(function(msg)
            if SharedState.ChatSpy then WriteLog(string.format("[CHAT] %s: %s", p.Name, msg), Color3.fromRGB(50, 150, 255)) end
        end)
    end
    Players.PlayerAdded:Connect(function(p)
        p.Chatted:Connect(function(msg)
            if SharedState.ChatSpy then WriteLog(string.format("[CHAT] %s: %s", p.Name, msg), Color3.fromRGB(50, 150, 255)) end
        end)
    end)
end
task.spawn(hookChat)

-- Global Chat Spy Logic
local function DisplaySpyMessage(name, msg)
    if not SharedState.GlobalChatSpy then return end
    pcall(function()
        StarterGui:SetCore("ChatMakeSystemMessage", {
            Text = string.format("[SPY] [%s]: %s", tostring(name), tostring(msg)),
            Color = Color3.fromRGB(255, 0, 0),
            Font = Enum.Font.SourceSansBold,
            TextSize = 18
        })
    end)
end

local TextChatService = game:GetService("TextChatService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

-- TextChatService Spy
pcall(function()
    TextChatService.MessageReceived:Connect(function(textChatMessage)
        if SharedState.GlobalChatSpy then
            local sender = textChatMessage.TextSource
            if sender and sender.UserId ~= LocalPlayer.UserId then
                -- Try to determine if message is hidden/whisper/team etc. via TextChannel
                -- If it's not the general channel or if we want to spy everything
                local channel = textChatMessage.TextChannel
                if channel and channel.Name ~= "RBXGeneral" then
                    DisplaySpyMessage(sender.Name, textChatMessage.Text)
                end
            end
        end
    end)
end)

-- LegacyChatService Spy
pcall(function()
    local chatEvents = ReplicatedStorage:WaitForChild("DefaultChatSystemChatEvents", 3)
    if chatEvents then
        local onMessageDoneFiltering = chatEvents:WaitForChild("OnMessageDoneFiltering", 3)
        if onMessageDoneFiltering then
            onMessageDoneFiltering.OnClientEvent:Connect(function(messageData)
                if SharedState.GlobalChatSpy then
                    if messageData and messageData.FromSpeaker and messageData.Message then
                        local speaker = messageData.FromSpeaker
                        -- Prevent self feedback
                        if speaker ~= LocalPlayer.Name then
                            local channel = messageData.OriginalChannel
                            if channel ~= "All" then
                                DisplaySpyMessage(speaker, messageData.Message)
                            end
                        end
                    end
                end
            end)
        end
    end
end)

-- ==========================================
-- ** 🧰 Utility Page **
-- ==========================================
Library:AddSection(PageUtil, "Key Spammer / Macro")
local spamKey = "E"
local spamDelay = 100
local spamming = false

Library:AddTextBox(PageUtil, "Key to Spam", "E...", function(text)
    spamKey = string.upper(text)
end)

Library:AddSlider(PageUtil, "Spam Delay (ms)", 10, 1000, 100, function(v)
    spamDelay = v
end)

Library:AddToggle(PageUtil, "Enable Key Spammer", function(state)
    spamming = state
    if state then
        task.spawn(function()
            local vim = game:GetService("VirtualInputManager")
            while spamming do
                local success, keycode = pcall(function() return Enum.KeyCode[spamKey] end)
                if success and keycode then
                    pcall(function()
                        vim:SendKeyEvent(true, keycode, false, game)
                        task.wait(0.01)
                        vim:SendKeyEvent(false, keycode, false, game)
                    end)
                end
                task.wait(spamDelay / 1000)
            end
        end)
    end
end)

Library:AddSection(PageUtil, "Chat Manipulations")
Library:AddToggle(PageUtil, "Enable Chat Spy", function(s) SharedState.GlobalChatSpy = s end)

Library:AddSection(PageUtil, "Instant Interact")
Library:AddToggle(PageUtil, "Enable Instant", function(s) SharedState.InstantInteract = s end)
Library:AddDropdown(PageUtil, "Select Key", {"E", "Q", "F", "V", "LeftClick"}, function(v) SharedState.InstantInteractKey = v end)

Library:AddSection(PageUtil, "Automation")
local clickCon
local ToggleClicker = Library:AddToggle(PageUtil, "Auto-Clicker", function(s) SharedState.AutoClicker = s end)
Library:AddKeybind(PageUtil, "Auto-Clicker Bind", nil, ToggleClicker)
Library:AddSlider(PageUtil, "Clicks Per Second", 1, 100, 10, function(v) SharedState.ClickCPS = v end)

Library:AddSection(PageUtil, "World Interactions")

local btoolEnabled = false
local ToggleBtools = Library:AddToggle(PageUtil, "Client Btools (Delete Parts)", function(s) btoolEnabled = s end)
UserInputService.InputBegan:Connect(function(input, gpe)
    if gpe then return end
    if input.UserInputType == Enum.UserInputType.MouseButton1 and btoolEnabled then
        local target = Mouse.Target
        if target and not target:IsDescendantOf(LocalPlayer.Character) then
            target:Destroy()
            Notify("Part Deleted Locally!")
        end
    end
end)

Library:AddSection(PageUtil, "Environment")
Library:AddSlider(PageUtil, "Time Changer", 0, 24, 14, function(v) Lighting.ClockTime = v end)

-- ==========================================
-- ** � Auto-Piano **
-- ==========================================
Library:AddSection(PageUtil, "Auto-Piano")
local pFrame = Create("Frame", { Parent = PageUtil, Size = UDim2.new(1, 0, 0, 110), BackgroundColor3 = Theme.Element })
Create("UICorner", { CornerRadius = UDim.new(0, 6), Parent = pFrame })
Create("TextLabel", { Parent = pFrame, Size = UDim2.new(1, -30, 0, 25), Position = UDim2.new(0, 15, 0, 5), BackgroundTransparency = 1, Text = "Piano Sheet (Notes):", TextColor3 = Theme.Text, Font = Enum.Font.Gotham, TextSize = 14, TextXAlignment = Enum.TextXAlignment.Left })
local sheetBox = Create("TextBox", { Parent = pFrame, Size = UDim2.new(1, -30, 0, 65), Position = UDim2.new(0, 15, 0, 35), BackgroundColor3 = Theme.Background, Text = "", PlaceholderText = "Paste notes here (A-Z, 0-9)...", TextColor3 = Theme.Text, Font = Enum.Font.Gotham, TextSize = 13, MultiLine = true, TextWrapped = true, TextYAlignment = Enum.TextYAlignment.Top, ClearTextOnFocus = false })
Create("UICorner", { CornerRadius = UDim.new(0, 4), Parent = sheetBox })

local pSpeed, pPlaying = 0.5, false
Library:AddSlider(PageUtil, "Tempo (Delay: 0.01 - 1s)", 1, 100, 50, function(v) pSpeed = v / 100 end)
Library:AddButton(PageUtil, "Play Piano", function()
    if pPlaying then return end
    pPlaying = true
    task.spawn(function()
        local VIM = game:GetService("VirtualInputManager")
        local text = sheetBox.Text:upper()
        for i = 1, #text do
            if not pPlaying then break end
            local char = string.sub(text, i, i)
            if string.match(char, "[A-Z0-9]") then
                pcall(function()
                    VIM:SendKeyEvent(true, Enum.KeyCode[char], false, game)
                    task.wait(0.01)
                    VIM:SendKeyEvent(false, Enum.KeyCode[char], false, game)
                end)
                task.wait(pSpeed)
            end
        end
        pPlaying = false
    end)
end)
Library:AddButton(PageUtil, "Stop Piano", function() pPlaying = false end)

-- ==========================================
-- ** 🌐 Server Page **
-- ==========================================
Library:AddSection(PageServer, "Player Sniper (Join by Username)")

local snipeUser = ""
Library:AddTextBox(PageServer, "Target Username", "Enter username...", function(text) snipeUser = text end)

local sniperStatusFrame = Create("Frame", { Parent = PageServer, Size = UDim2.new(1, 0, 0, 30), BackgroundColor3 = Theme.Background, BorderSizePixel = 0 })
local sniperStatusLabel = Create("TextLabel", { Parent = sniperStatusFrame, Size = UDim2.new(1, -30, 1, 0), Position = UDim2.new(0, 15, 0, 0), BackgroundTransparency = 1, Text = "Status: Idle", TextColor3 = Theme.TextDark, Font = Enum.Font.GothamMedium, TextSize = 13, TextXAlignment = Enum.TextXAlignment.Left })

Library:AddButton(PageServer, "Snipe & Join", function()
    if snipeUser == "" then
        sniperStatusLabel.Text = "Status: Please enter a username"
        return
    end

    task.spawn(function()
        sniperStatusLabel.Text = "Status: Fetching User ID..."
        local success, userId = pcall(function() return Players:GetUserIdFromNameAsync(snipeUser) end)
        
        if not success or not userId then
            sniperStatusLabel.Text = "Status: Invalid User"
            return
        end
        
        sniperStatusLabel.Text = "Status: Fetching Avatar..."
        
        local reqFunc = (syn and syn.request) or (http and http.request) or http_request or request or Fluxus and Fluxus.request
        local thumbUrl = "https://thumbnails.roblox.com/v1/users/avatar-headshot?userIds=" .. userId .. "&size=150x150&format=Png&isCircular=false"
        local thumbSuccess, thumbData = pcall(function()
            if reqFunc then
                local res = reqFunc({Url = thumbUrl, Method = "GET", Headers = {["User-Agent"] = "Mozilla/5.0"}})
                return HttpService:JSONDecode(res.Body).data[1].imageUrl
            else
                return HttpService:JSONDecode(game:HttpGet(thumbUrl)).data[1].imageUrl
            end
        end)

        if not thumbSuccess or not thumbData then
            sniperStatusLabel.Text = "Status: Failed to fetch Avatar"
            return
        end
        
        sniperStatusLabel.Text = "Status: Scanning Servers..."
        local cursor = ""
        local serversScanned = 0
        local found = false
        
        local apiUrl = "https://games.roblox-api.deno.dev/v1/games/" .. tostring(game.PlaceId) .. "/servers/Public?sortOrder=Asc&limit=100"
        
        while not found do
            local currentUrl = apiUrl
            if cursor ~= "" then currentUrl = apiUrl .. "&cursor=" .. cursor end
            
            local resSuccess, serverRes = pcall(function()
                if reqFunc then
                    return HttpService:JSONDecode(reqFunc({Url = currentUrl, Method = "GET", Headers = {["User-Agent"] = "Mozilla/5.0"}}).Body)
                else
                    return HttpService:JSONDecode(game:HttpGet(currentUrl))
                end
            end)
            
            if not resSuccess or not serverRes or not serverRes.data then
                sniperStatusLabel.Text = "Status: API Error (Blocked?)"
                break
            end
            
            serversScanned = serversScanned + #serverRes.data
            sniperStatusLabel.Text = "Status: Scanning Servers (" .. serversScanned .. ")..."
            
            for _, server in pairs(serverRes.data) do
                if type(server) == "table" and server.id and server.playerTokens and #server.playerTokens > 0 then
                    local tokens = server.playerTokens
                    -- Convert tokens to body for batch API
                    local body = {}
                    for _, token in ipairs(tokens) do
                        table.insert(body, {
                            requestId = token,
                            type = "AvatarHeadshot",
                            targetId = 0,
                            size = "150x150",
                            format = "Png",
                            isCircular = false,
                            token = token
                        })
                    end
                    
                    if reqFunc then
                        local batchSuccess, batchRes = pcall(function()
                            local postReq = reqFunc({
                                Url = "https://thumbnails.roblox.com/v1/batch",
                                Method = "POST",
                                Headers = {
                                    ["Content-Type"] = "application/json",
                                    ["Accept"] = "application/json"
                                },
                                Body = HttpService:JSONEncode(body)
                            })
                            return HttpService:JSONDecode(postReq.Body).data
                        end)
                        
                        if batchSuccess and batchRes then
                            for _, av in pairs(batchRes) do
                                if av.imageUrl == thumbData then
                                    sniperStatusLabel.Text = "Status: Found! Joining..."
                                    found = true
                                    TeleportService:TeleportToPlaceInstance(game.PlaceId, server.id, LocalPlayer)
                                    return
                                end
                            end
                        end
                    end
                end
            end
            
            if serverRes.nextPageCursor and serverRes.nextPageCursor ~= "null" then
                cursor = serverRes.nextPageCursor
                task.wait(0.1)
            else
                sniperStatusLabel.Text = "Status: Not Found/Private"
                break
            end
        end
    end)
end)

Library:AddSection(PageServer, "Server Navigation")
Library:AddButton(PageServer, "Copy Current JobID", function()
    local s = pcall(function() setclipboard(tostring(game.JobId)) end)
    if s then Notify("JobID Copied!") end
end)
local joinJobId = ""
Library:AddTextBox(PageServer, "Target JobID", "Paste JobID here...", function(text) joinJobId = text end)
Library:AddButton(PageServer, "Join target JobID", function()
    if joinJobId ~= "" then TeleportService:TeleportToPlaceInstance(game.PlaceId, joinJobId, LocalPlayer) end
end)
Library:AddButton(PageServer, "Rejoin Server", function()
    TeleportService:TeleportToPlaceInstance(game.PlaceId, game.JobId, LocalPlayer)
end)

-- ==========================================
-- ** 📍 Waypoint Manager **
-- ==========================================
Library:AddSection(PageUtil, "Waypoint Manager")

local Waypoints = {}
local waypointName = ""

Library:AddTextBox(PageUtil, "Waypoint Name", "Enter name...", function(text)
    waypointName = text
end)

local wpFrame = Create("Frame", { Parent = PageUtil, Size = UDim2.new(1, 0, 0, 150), BackgroundColor3 = Theme.Element, ClipsDescendants = true })
Create("UICorner", { CornerRadius = UDim.new(0, 6), Parent = wpFrame })
Create("TextLabel", { Parent = wpFrame, Size = UDim2.new(1, -30, 0, 25), Position = UDim2.new(0, 15, 0, 5), BackgroundTransparency = 1, Text = "Saved Locations:", TextColor3 = Theme.Text, Font = Enum.Font.GothamBold, TextSize = 13, TextXAlignment = Enum.TextXAlignment.Left })

local wpList = Create("ScrollingFrame", { Parent = wpFrame, Size = UDim2.new(1, -20, 1, -40), Position = UDim2.new(0, 10, 0, 30), BackgroundTransparency = 1, ScrollBarThickness = 3, BorderSizePixel = 0 })
local wpLayout = Create("UIListLayout", { Parent = wpList, SortOrder = Enum.SortOrder.LayoutOrder, Padding = UDim.new(0, 5) })
wpLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function() wpList.CanvasSize = UDim2.new(0, 0, 0, wpLayout.AbsoluteContentSize.Y) end)

Library:AddButton(PageUtil, "Save Waypoint", function()
    if waypointName == "" then Notify("Please enter a name first!"); return end
    if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
        local cf = LocalPlayer.Character.HumanoidRootPart.CFrame
        Waypoints[waypointName] = cf
        
        local btn = Create("TextButton", { Parent = wpList, Size = UDim2.new(1, -10, 0, 30), BackgroundColor3 = Theme.Background, Text = waypointName, TextColor3 = Theme.Text, Font = Enum.Font.Gotham, TextSize = 13 })
        Create("UICorner", { CornerRadius = UDim.new(0, 4), Parent = btn })
        Create("UIStroke", { Parent = btn, Color = Theme.Accent, Thickness = 1, Transparency = 0.5 })
        
        btn.MouseEnter:Connect(function() Tween(btn, {BackgroundColor3 = Theme.ElementHover}, 0.2) end)
        btn.MouseLeave:Connect(function() Tween(btn, {BackgroundColor3 = Theme.Background}, 0.2) end)
        
        btn.MouseButton1Click:Connect(function()
            if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
                LocalPlayer.Character.HumanoidRootPart.CFrame = Waypoints[btn.Text]
                Notify("Teleported to: " .. btn.Text)
            end
        end)
        
        Notify("Waypoint Saved: " .. waypointName)
    end
end)

-- ==========================================
-- ** 🛠️ Developer Page **
-- ==========================================
Library:AddSection(PageDev, "Script Executor")

local execFrame = Create("Frame", { Parent = PageDev, Size = UDim2.new(1, 0, 0, 160), BackgroundColor3 = Theme.Element })
Create("UICorner", { CornerRadius = UDim.new(0, 6), Parent = execFrame })
Create("TextLabel", { Parent = execFrame, Size = UDim2.new(1, -30, 0, 25), Position = UDim2.new(0, 15, 0, 5), BackgroundTransparency = 1, Text = "Lua Code:", TextColor3 = Theme.Text, Font = Enum.Font.Gotham, TextSize = 14, TextXAlignment = Enum.TextXAlignment.Left })
local execBox = Create("TextBox", { Parent = execFrame, Size = UDim2.new(1, -30, 0, 115), Position = UDim2.new(0, 15, 0, 35), BackgroundColor3 = Theme.Background, Text = "", PlaceholderText = "-- Buraya Lua kodunu yapıştı...", TextColor3 = Theme.Text, Font = Enum.Font.Code, TextSize = 13, MultiLine = true, TextWrapped = true, TextYAlignment = Enum.TextYAlignment.Top, TextXAlignment = Enum.TextXAlignment.Left, ClearTextOnFocus = false })
Create("UICorner", { CornerRadius = UDim.new(0, 4), Parent = execBox })

Library:AddButton(PageDev, "Execute Script", function()
    local code = execBox.Text
    if code ~= "" then
        local success, funcOrErr = pcall(function() return loadstring(code) end)
        if success and type(funcOrErr) == "function" then
            task.spawn(funcOrErr)
            Notify("Script executed successfully!")
        else
            warn("[VexelHUB] Executor Error: " .. tostring(funcOrErr))
            Notify("Execution Error! (Check Console)", 5)
        end
    end
end)

Library:AddButton(PageDev, "Clear Text", function()
    execBox.Text = ""
end)

Library:AddSection(PageDev, "Environment Analysis")
Library:AddToggle(PageDev, "Remote Event Sniffer", function(s) SharedState.RemoteSniffer = s end)
Library:AddToggle(PageDev, "Element Inspector (Hover)", function(s) 
    SharedState.ElementInspector = s 
end)
Library:AddToggle(PageDev, "Mob UI Inspector (Click)", function(s) 
    SharedState.MobUIInspector = s 
end)

UserInputService.InputBegan:Connect(function(input, gpe)
    if gpe then return end
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        -- Element Inspector
        if SharedState.ElementInspector then
            local target = Mouse.Target
            if target then
                local path = target:GetFullName()
                pcall(function() setclipboard(path) end)
                if WriteLog then WriteLog("[INFO] Copied: " .. path, Color3.fromRGB(150, 150, 255)) end
                Notify("Copied path to clipboard!")
            end
        end
        -- Mob UI Inspector
        if SharedState.MobUIInspector then
            local target = Mouse.Target
            if target then
                local function checkGUI(obj)
                    if obj:IsA("BillboardGui") or obj:IsA("SurfaceGui") or obj:IsA("ProximityPrompt") then
                        local path = obj:GetFullName()
                        pcall(function() setclipboard(path) end)
                        print("[VexelHUB] UI Found: " .. path)
                        if WriteLog then WriteLog("[VexelHUB] UI Found: " .. path, Color3.fromRGB(150, 150, 255)) end
                        
                        local txt = obj:FindFirstChildWhichIsA("TextLabel", true)
                        if txt then
                            print("[VexelHUB] UI Text Value: " .. txt.Text)
                            if WriteLog then WriteLog("[VexelHUB] UI Text Value: " .. txt.Text, Color3.fromRGB(150, 150, 255)) end
                        end
                    end
                end
                
                local searchRoots = {target}
                if target.Parent and target.Parent ~= Workspace then
                    table.insert(searchRoots, target.Parent)
                end
                
                for _, root in ipairs(searchRoots) do
                    for _, obj in pairs(root:GetDescendants()) do
                        checkGUI(obj)
                    end
                    checkGUI(root)
                end
            end
        end
    end
end)

local invPartsObjs = {}
Library:AddToggle(PageDev, "Show Invisible Parts", function(state)
    if state then
        for _, part in pairs(Workspace:GetDescendants()) do
            if part:IsA("BasePart") and part.Transparency == 1 and part.CanCollide == true then
                local success, obj = pcall(function()
                    local b = Instance.new("BoxHandleAdornment")
                    b.Adornee = part
                    b.Size = part.Size
                    b.Color3 = Color3.fromRGB(150, 0, 255)
                    b.Transparency = 0.5
                    b.AlwaysOnTop = true
                    b.ZIndex = 5
                    b.Parent = part
                    return b
                end)
                if success and obj then table.insert(invPartsObjs, obj) end
            end
        end
        Notify("Showing " .. #invPartsObjs .. " invisible parts")
    else
        for _, obj in ipairs(invPartsObjs) do
            if obj and obj.Parent then obj:Destroy() end
        end
        table.clear(invPartsObjs)
        Notify("Invisible parts hidden")
    end
end)

Library:AddSection(PageDev, "External Tools")
Library:AddButton(PageDev, "Load Dex Explorer", function()
    loadstring(game:HttpGet("https://raw.githubusercontent.com/infyiff/backup/main/dex.lua"))()
end)
Library:AddButton(PageDev, "Load Infinite Yield", function()
    loadstring(game:HttpGet('https://raw.githubusercontent.com/EdgeIY/infiniteyield/master/source'))()
end)
Library:AddButton(PageDev, "Load SimpleSpy (Remote Logger)", function()
    loadstring(game:HttpGet("https://raw.githubusercontent.com/78n/SimpleSpy/main/SimpleSpySource.lua"))()
end)

Library:AddSection(PageDev, "Game Intelligence")
Library:AddButton(PageDev, "Scan Hidden GUIs", function()
    local pg = LocalPlayer:FindFirstChild("PlayerGui")
    if pg then
        local count = 0
        if WriteLog then WriteLog("--- HIDDEN GUIs ---", Color3.fromRGB(138, 43, 226)) end
        for _, gui in pairs(pg:GetDescendants()) do
            if gui:IsA("ScreenGui") and not gui.Enabled then
               if WriteLog then WriteLog("[GUI] " .. gui:GetFullName(), Color3.fromRGB(200, 150, 255)) end
               count = count + 1
            end
        end
        if WriteLog then WriteLog("Total Hidden GUIs: " .. count, Color3.fromRGB(138, 43, 226)) end
        Notify("Scanned " .. count .. " hidden GUIs (Check Console Logs)")
    end
end)


Library:AddButton(PageDev, "Dump Game Info to Console", function()
    local wsCount = #Workspace:GetDescendants()
    local rs = game:GetService("ReplicatedStorage")
    local rsFolders = {}
    for _, v in pairs(rs:GetChildren()) do if v:IsA("Folder") then table.insert(rsFolders, v.Name) end end
    
    local dumpStr = string.format("--- VEXEL DUMP ---\nPlace ID: %s\nJob ID: %s\nWorkspace Objects: %d\nReplicatedStorage Folders: %s", tostring(game.PlaceId), tostring(game.JobId), wsCount, table.concat(rsFolders, ", "))
    print(dumpStr)
    if WriteLog then WriteLog("[INFO] Dumped Game Info to F9 Console", Color3.fromRGB(200, 200, 200)) end
    Notify("Game Info dumped to F9 Console (F9)!")
end)

Library:AddButton(PageDev, "Staff / Mod Detector", function()
    local susp = {"btools", "hammer", "ban", "kick", "admin", "mod"}
    for _, p in pairs(Players:GetPlayers()) do
        if p ~= LocalPlayer then
            local isStaff = false
            -- Check Group
            pcall(function()
                if game.CreatorType == Enum.CreatorType.Group then
                    if p:GetRankInGroup(game.CreatorId) > 0 then isStaff = true end
                end
            end)
            -- Check Items
            local function checkItems(parent)
                if not parent then return end
                for _, v in pairs(parent:GetChildren()) do
                    if v:IsA("Tool") or v:IsA("HopperBin") or v:IsA("BindableEvent") then
                        local n = v.Name:lower()
                        for _, s in ipairs(susp) do
                            if string.find(n, s) then isStaff = true; break end
                        end
                    end
                end
            end
            checkItems(p:FindFirstChild("Backpack"))
            checkItems(p.Character)
            
            if isStaff then
                local msg = "POTENTIAL ADMIN DETECTED: " .. p.Name
                warn(msg)
                if WriteLog then WriteLog(msg, Color3.fromRGB(255, 50, 50)) end
                Notify(msg, 5)
            end
        end
    end
    Notify("Staff Scan Complete!")
end)

-- ==========================================
-- ** ⚙️ Settings Page **
-- ==========================================
-- Aimbot FOV Circle Setup
local FOVCircle = Drawing.new("Circle")
FOVCircle.Thickness = 1.5
FOVCircle.Color = Theme.Accent
FOVCircle.Transparency = 0.5
FOVCircle.NumSides = 60
FOVCircle.Filled = false
FOVCircle.Visible = false

local InspectorGui, InspectorLabel

local function UpdateTheme(newColor)
    local oldColor = Theme.Accent
    Theme.Accent = newColor
    
    -- Visuals
    FOVCircle.Color = newColor
    if InspectorGui then
        local frame = InspectorGui:FindFirstChildOfClass("Frame")
        if frame then
            local stroke = frame:FindFirstChildOfClass("UIStroke")
            if stroke then stroke.Color = newColor end
        end
    end
    
    -- Main GUI
    for _, obj in pairs(VexelGui:GetDescendants()) do
        if obj:IsA("GuiObject") then
            pcall(function() if obj.BackgroundColor3 == oldColor then obj.BackgroundColor3 = newColor end end)
            pcall(function() if (obj:IsA("TextLabel") or obj:IsA("TextButton") or obj:IsA("TextBox")) and obj.TextColor3 == oldColor then obj.TextColor3 = newColor end end)
            pcall(function() if (obj:IsA("ImageLabel") or obj:IsA("ImageButton")) and obj.ImageColor3 == oldColor then obj.ImageColor3 = newColor end end)
            pcall(function() if obj:IsA("ScrollingFrame") and obj.ScrollBarImageColor3 == oldColor then obj.ScrollBarImageColor3 = newColor end end)
        elseif obj:IsA("UIStroke") then
            pcall(function() if obj.Color == oldColor then obj.Color = newColor end end)
        end
    end
    
    -- Notif Gui
    if NotifGui then
        for _, obj in pairs(NotifGui:GetDescendants()) do
            if obj:IsA("UIStroke") and obj.Color == oldColor then obj.Color = newColor end
            if obj:IsA("TextLabel") and obj.TextColor3 == oldColor then obj.TextColor3 = newColor end
        end
    end
    
    -- HUD Gui
    if HUDGui then
        for _, obj in pairs(HUDGui:GetDescendants()) do
            if obj:IsA("UIStroke") then obj.Color = newColor end
            if obj:IsA("TextLabel") then obj.TextColor3 = newColor end
        end
    end
    
    -- ESP & Chams
    for _, p in pairs(Players:GetPlayers()) do
        if p.Character then
            local hl = p.Character:FindFirstChild("VESPBox")
            if hl then hl.FillColor = newColor end
            
            local hrp = p.Character:FindFirstChild("HumanoidRootPart")
            if hrp then
                local bg = hrp:FindFirstChild("VESPText")
                if bg and bg:FindFirstChild("Label") then
                    bg.Label.TextColor3 = newColor
                end
            end
        end
    end
end

Library:AddSection(PageSet, "Theme Color (RGB)")
local tr, tg, tb = Theme.Accent.R * 255, Theme.Accent.G * 255, Theme.Accent.B * 255
Library:AddSlider(PageSet, "Red", 0, 255, math.floor(tr), function(v) tr = v; UpdateTheme(Color3.fromRGB(tr, tg, tb)) end)
Library:AddSlider(PageSet, "Green", 0, 255, math.floor(tg), function(v) tg = v; UpdateTheme(Color3.fromRGB(tr, tg, tb)) end)
Library:AddSlider(PageSet, "Blue", 0, 255, math.floor(tb), function(v) tb = v; UpdateTheme(Color3.fromRGB(tr, tg, tb)) end)


Library:AddSection(PageSet, "Hub Settings")
Library:AddKeybind(PageSet, "Toggle UI Visibility", Enum.KeyCode.F1, nil, function()
    MainFrame.Visible = not MainFrame.Visible; MinimizeBtn.Visible = MainFrame.Visible; Topbar.Visible = MainFrame.Visible
end)
Library:AddToggle(PageSet, "Show Watermark HUD", function(s) SharedState.ShowHUD = s; HUDBar.Visible = s end).SetActive(false)
Library:AddToggle(PageSet, "Enable Custom Notifications", function(s) SharedState.Notifications = s end)
Library:AddButton(PageSet, "Unload VexelHUB", function()
    VexelGui:Destroy(); NotifGui:Destroy(); HUDGui:Destroy()
end)


-- ==========================================
-- ** Core Processing & RunService Loops **
-- ==========================================
local Tracers = {}

local function GetInspectorText()
    if not InspectorGui then
        InspectorGui = Instance.new("ScreenGui", guiParent)
        InspectorGui.Name = "VexelHUB_Inspector"
        local frame = Instance.new("Frame", InspectorGui)
        frame.BackgroundColor3 = Theme.LogBg
        frame.Size = UDim2.new(0, 300, 0, 40)
        frame.Position = UDim2.new(0, 0, 0, 0)
        Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 6)
        Instance.new("UIStroke", frame).Color = Theme.Accent
        InspectorLabel = Instance.new("TextLabel", frame)
        InspectorLabel.Size = UDim2.new(1, -10, 1, -10)
        InspectorLabel.Position = UDim2.new(0, 5, 0, 5)
        InspectorLabel.BackgroundTransparency = 1
        InspectorLabel.TextColor3 = Theme.Text
        InspectorLabel.Font = Enum.Font.Code
        InspectorLabel.TextSize = 12
        InspectorLabel.TextWrapped = true
        InspectorLabel.TextXAlignment = Enum.TextXAlignment.Left
        InspectorLabel.TextYAlignment = Enum.TextYAlignment.Top
    end
    return InspectorGui:FindFirstChildOfClass("Frame"), InspectorLabel
end

local CachedNPCs = {}
task.spawn(function()
    while true do
        task.wait(2)
        if SharedState.HitboxExpander then
            local npcs = {}
            for _, v in pairs(Workspace:GetDescendants()) do
                if v:IsA("Model") and v ~= LocalPlayer.Character and v:FindFirstChild("Humanoid") and v:FindFirstChild("HumanoidRootPart") and v.Humanoid.Health > 0 and not Players:GetPlayerFromCharacter(v) then
                    table.insert(npcs, v)
                end
            end
            CachedNPCs = npcs
        else
            CachedNPCs = {}
        end
    end
end)

local CurrentAimTarget = nil

local function IsTargetValid(t)
    if not t or not t.Parent then return false end
    local c = t.Character
    if not c or not c.Parent then return false end
    local hrp = c.PrimaryPart or c:FindFirstChild("HumanoidRootPart")
    local hum = c:FindFirstChildWhichIsA("Humanoid")
    local tp = c:FindFirstChild(SharedState.TargetPart)
    if not hrp or not hum or not tp or hum.Health <= 0 then return false end
    return true
end

local function GetClosestTargetInFOV()
    local closest, maxDist = nil, SharedState.FOVRadius
    local mPos = UserInputService:GetMouseLocation()
    for _, p in pairs(Players:GetPlayers()) do
        if p ~= LocalPlayer and IsTargetValid(p) then
            if p.Team ~= LocalPlayer.Team or not p.Team then
                local pos, onScreen = Camera:WorldToViewportPoint(p.Character[SharedState.TargetPart].Position)
                if onScreen then
                    local dist = (Vector2.new(pos.X, pos.Y) - mPos).Magnitude
                    if dist < maxDist then maxDist, closest = dist, p end
                end
            end
        end
    end
    return closest
end

local function IsAimKeyDown()
    if SharedState.AimKey == "Right Click" then
        return UserInputService:IsMouseButtonPressed(Enum.UserInputType.MouseButton2)
    elseif SharedState.AimKey == "Left Click" then
        return UserInputService:IsMouseButtonPressed(Enum.UserInputType.MouseButton1)
    elseif SharedState.AimKey then
        local st, res = pcall(function() return UserInputService:IsKeyDown(Enum.KeyCode[SharedState.AimKey]) end)
        return st and res
    end
    return false
end

RunService.RenderStepped:Connect(function(dt)
    local char = LocalPlayer.Character
    if not char then return end
    local hrp = char.PrimaryPart or char:FindFirstChild("HumanoidRootPart")
    local hum = char:FindFirstChildWhichIsA("Humanoid")
    
    -- Instant Interact
    if SharedState.InstantInteract then
        local key = SharedState.InstantInteractKey or "E"
        for _, v in pairs(Workspace:GetDescendants()) do
            if v:IsA("ProximityPrompt") then
                if key == "LeftClick" then
                    if v.ClickablePrompt then v.HoldDuration = 0 end
                else
                    pcall(function()
                        if v.KeyboardKeyCode == Enum.KeyCode[key] then v.HoldDuration = 0 end
                    end)
                end
            end
        end
    end
    
    -- No Stamina (Infinite Stamina Bypass) - Keeps local stamina values at maximum
    if SharedState.NoStamina and hum then
        local function checkStamina(obj)
            if obj:IsA("ValueBase") and (string.find(string.lower(obj.Name), "stamina") or string.find(string.lower(obj.Name), "energy")) then
                if obj:IsA("NumberValue") or obj:IsA("IntValue") then
                    pcall(function() obj.Value = 9e9 end)
                end
            end
        end
        if char then
            for _, v in pairs(char:GetDescendants()) do checkStamina(v) end
        end
        local humAttributes = hum:GetAttributes()
        for k, _ in pairs(humAttributes) do
            if string.find(string.lower(k), "stamina") or string.find(string.lower(k), "energy") then pcall(function() hum:SetAttribute(k, 100) end) end
        end
    end

    -- Aimbot FOV Circle Update
    if SharedState.ShowFOV then
        FOVCircle.Position = UserInputService:GetMouseLocation()
        FOVCircle.Radius = SharedState.FOVRadius
        FOVCircle.Visible = true
    else
        FOVCircle.Visible = false
    end
    
    -- Element Inspector
    if SharedState.ElementInspector then
        local target = Mouse.Target
        if target then
            local frame, label = GetInspectorText()
            label.Text = string.format("Path: %s\nClass: %s", target:GetFullName(), target.ClassName)
            local mPos = UserInputService:GetMouseLocation()
            frame.Position = UDim2.new(0, mPos.X + 15, 0, mPos.Y + 15)
            InspectorGui.Enabled = true
        elseif InspectorGui then
            InspectorGui.Enabled = false
        end
    elseif InspectorGui then
        InspectorGui.Enabled = false
    end
    
    -- Aimbot & Universe ESP Core Loop
    local closest, maxDist = nil, SharedState.FOVRadius
    local mPos = UserInputService:GetMouseLocation()
    
    for _, p in pairs(Players:GetPlayers()) do
        if p ~= LocalPlayer and p.Character and p.Character:FindFirstChild("HumanoidRootPart") and p.Character:FindFirstChild("Humanoid") and p.Character.Humanoid.Health > 0 then
            local tChar = p.Character
            local tHrp = tChar.HumanoidRootPart
            local tHum = tChar.Humanoid
            
            -- Aimbot Check
            if SharedState.Aimbot and (not CurrentAimTarget or not IsTargetValid(CurrentAimTarget)) then
                if p.Team ~= LocalPlayer.Team or not p.Team then
                    local tPart = tChar:FindFirstChild(SharedState.TargetPart)
                    if tPart then
                        local pos, onScreen = Camera:WorldToViewportPoint(tPart.Position)
                        if onScreen then
                            local dist = (Vector2.new(pos.X, pos.Y) - mPos).Magnitude
                            if dist < maxDist then maxDist, closest = dist, p end
                        end
                    end
                end
            end
            
            -- ESP Setup/Update Loop
            if SharedState.ESP.Chams then
                local hl = tChar:FindFirstChild("VESPBox")
                if not hl then
                    hl = Instance.new("Highlight", tChar); hl.Name = "VESPBox"; hl.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
                end
                hl.FillColor = Theme.Accent; hl.OutlineColor = Color3.new(1,1,1); hl.FillTransparency = 0.5
            else
                local hl = tChar:FindFirstChild("VESPBox"); if hl then hl:Destroy() end
            end
            
            if SharedState.ESP.Name or SharedState.ESP.Health then
                local bg = tHrp:FindFirstChild("VESPText")
                if not bg then
                    bg = Instance.new("BillboardGui", tHrp); bg.Name = "VESPText"; bg.Size = UDim2.new(0, 200, 0, 50); bg.StudsOffset = Vector3.new(0, 3, 0); bg.AlwaysOnTop = true
                    local txt = Instance.new("TextLabel", bg); txt.Name = "Label"; txt.Size = UDim2.new(1,0,1,0); txt.BackgroundTransparency = 1; txt.TextColor3 = Theme.Accent; txt.TextStrokeTransparency = 0; txt.Font = Enum.Font.GothamBold; txt.TextSize = 14
                end
                local distStr = ""
                if hrp then distStr = string.format(" [%dm]", math.floor((hrp.Position - tHrp.Position).Magnitude)) end
                local nm = SharedState.ESP.Name and (p.Name .. distStr) or ""
                local hp = SharedState.ESP.Health and string.format("[%d HP]", math.floor(tHum.Health)) or ""
                bg.Label.Text = nm .. "\n" .. hp
            else
                local bg = tHrp:FindFirstChild("VESPText"); if bg then bg:Destroy() end
            end
            
            if SharedState.HitboxExpander then
                tHrp.Size = Vector3.new(SharedState.HitboxSize, SharedState.HitboxSize, SharedState.HitboxSize)
                tHrp.Transparency = 0.8
                tHrp.BrickColor = BrickColor.new("Really red")
                tHrp.Material = Enum.Material.Neon
                tHrp.CanCollide = false
                tHrp.Massless = true
                tHrp.RootPriority = 0
            elseif tHrp.Size.X ~= 2 then
                tHrp.Size = Vector3.new(2,2,1)
                tHrp.Transparency = 1
                tHrp.CanCollide = false
                tHrp.Massless = true
                tHrp.RootPriority = 0
            end
        else
            -- Target Invalid, Clean ESP
            if p.Character then
                local hl = p.Character:FindFirstChild("VESPBox"); if hl then hl:Destroy() end
                local tHrp = p.Character:FindFirstChild("HumanoidRootPart")
                if tHrp then local bg = tHrp:FindFirstChild("VESPText"); if bg then bg:Destroy() end end
            end
        end
    end
    
    -- Hitbox & Reach Expander loop for NPCs
    if SharedState.HitboxExpander then
        for _, npc in ipairs(CachedNPCs) do
            if npc and npc.Parent and npc:FindFirstChild("HumanoidRootPart") and npc:FindFirstChild("Humanoid") and npc.Humanoid.Health > 0 then
                local nHrp = npc.HumanoidRootPart
                nHrp.Size = Vector3.new(SharedState.HitboxSize, SharedState.HitboxSize, SharedState.HitboxSize)
                nHrp.Transparency = 0.8
                nHrp.BrickColor = BrickColor.new("Really red")
                nHrp.Material = Enum.Material.Neon
                nHrp.CanCollide = false
                nHrp.Massless = true
                nHrp.RootPriority = 0
            end
        end
    else
        for _, npc in ipairs(CachedNPCs) do
            if npc and npc.Parent and npc:FindFirstChild("HumanoidRootPart") then
                local nHrp = npc.HumanoidRootPart
                if nHrp.Size.X ~= 2 then
                    nHrp.Size = Vector3.new(2,2,1)
                    nHrp.Transparency = 1
                    nHrp.CanCollide = false
                    nHrp.Massless = true
                    nHrp.RootPriority = 0
                end
            end
        end
    end

    if SharedState.Aimbot then
        if IsAimKeyDown() then
            if not CurrentAimTarget or not IsTargetValid(CurrentAimTarget) then CurrentAimTarget = closest end
            if CurrentAimTarget and CurrentAimTarget.Character and CurrentAimTarget.Character:FindFirstChild(SharedState.TargetPart) then
                local targetPos = CurrentAimTarget.Character[SharedState.TargetPart].Position
                Camera.CFrame = Camera.CFrame:Lerp(CFrame.new(Camera.CFrame.Position, targetPos), SharedState.AimSmoothness / 10)
            end
        else
            CurrentAimTarget = nil
        end
    else
        CurrentAimTarget = nil
    end

    if hum then
        hum.WalkSpeed = SharedState.WalkSpeed
        if hum.UseJumpPower then hum.JumpPower = SharedState.JumpPower end
    end
    
    -- CFrame WalkSpeed (Bypass)
    if SharedState.CFrameSpeedActive and hum.MoveDirection.Magnitude > 0 and hrp then
        hrp.CFrame = hrp.CFrame + (hum.MoveDirection * (SharedState.CFrameSpeed / 10))
    end
    
    -- Auto-Bhop
    if SharedState.AutoBhop and not SharedState.FlyActive and not SharedState.StealthFly and UserInputService:IsKeyDown(Enum.KeyCode.Space) and hum then
        if hum.FloorMaterial ~= Enum.Material.Air or hum:GetState() ~= Enum.HumanoidStateType.Freefall then
            hum:ChangeState(Enum.HumanoidStateType.Jumping)
        end
    end
    
    -- Stealth Fly [BYPASS]
    if SharedState.StealthFly and hrp then
        if hum then hum.PlatformStand = true end
        local move = Vector3.new(0,0,0)
        if flyCtrl.f > 0 then move = move + Camera.CFrame.lookVector end
        if flyCtrl.b > 0 then move = move - Camera.CFrame.lookVector end
        if flyCtrl.l > 0 then move = move - Camera.CFrame.rightVector end
        if flyCtrl.r > 0 then move = move + Camera.CFrame.rightVector end
        if flyCtrl.u > 0 then move = move + Vector3.new(0, 1, 0) end
        if flyCtrl.d > 0 then move = move - Vector3.new(0, 1, 0) end
        hrp.Velocity = Vector3.new(0,0,0)
        hrp.CFrame = hrp.CFrame + (move * (SharedState.FlySpeed * dt))
    end
    
    -- Standard Fly Update
    if SharedState.FlyActive and bgFly and bvFly and hrp then
        if hum then hum.PlatformStand = true end
        bgFly.cframe = Camera.CFrame
        local move = Vector3.new(0,0,0)
        if flyCtrl.f > 0 then move = move + Camera.CFrame.lookVector end
        if flyCtrl.b > 0 then move = move - Camera.CFrame.lookVector end
        if flyCtrl.l > 0 then move = move - Camera.CFrame.rightVector end
        if flyCtrl.r > 0 then move = move + Camera.CFrame.rightVector end
        if flyCtrl.u > 0 then move = move + Vector3.new(0, 1, 0) end
        if flyCtrl.d > 0 then move = move - Vector3.new(0, 1, 0) end
        hrp.Velocity = Vector3.new(0,0,0)
        bvFly.velocity = move * SharedState.FlySpeed
    end
    
    -- Freecam True Rotation Fix
    if SharedState.Freecam then
        if UserInputService:IsMouseButtonPressed(Enum.UserInputType.MouseButton2) then
            UserInputService.MouseBehavior = Enum.MouseBehavior.LockCurrentPosition
            local d = UserInputService:GetMouseDelta()
            fcYaw = fcYaw - math.rad(d.X * 0.5)
            fcPitch = math.clamp(fcPitch - math.rad(d.Y * 0.5), -math.rad(89), math.rad(89))
        else
            UserInputService.MouseBehavior = Enum.MouseBehavior.Default
        end
        Camera.CFrame = CFrame.new(Camera.CFrame.Position) * CFrame.Angles(0, fcYaw, 0) * CFrame.Angles(fcPitch, 0, 0)
        local move = Vector3.new(0,0,0)
        if flyCtrl.f > 0 then move = move + Camera.CFrame.lookVector end
        if flyCtrl.b > 0 then move = move - Camera.CFrame.lookVector end
        if flyCtrl.l > 0 then move = move - Camera.CFrame.rightVector end
        if flyCtrl.r > 0 then move = move + Camera.CFrame.rightVector end
        Camera.CFrame = Camera.CFrame + (move * SharedState.FreecamSpeed)
    end
    
    -- Spider Climb
    if SharedState.Spider and hrp then
        local ray = Ray.new(hrp.Position, hrp.CFrame.lookVector * 3)
        local hit, pos = Workspace:FindPartOnRay(ray, char)
        if hit and flyCtrl.f > 0 then hrp.Velocity = Vector3.new(0, SharedState.WalkSpeed, 0) end
    end
    
    -- Anti-Fall Damage
    if SharedState.AntiFallDamage and hrp and hrp.Velocity.Y < -40 then
        hrp.Velocity = Vector3.new(hrp.Velocity.X, -20, hrp.Velocity.Z)
    end
    
    -- Interactions (Follow/Fling)
    if SharedState.SelectedTarget and SharedState.SelectedTarget.Character and SharedState.SelectedTarget.Character:FindFirstChild("HumanoidRootPart") and hrp then
        local tHrp = SharedState.SelectedTarget.Character.HumanoidRootPart
        if SharedState.LoopFollow then
            hrp.CFrame = tHrp.CFrame * CFrame.new(0, SharedState.FollowHeight, SharedState.FollowDistance)
            hrp.Velocity = Vector3.new(0, 0, 0)
            hrp.RotVelocity = Vector3.new(0, 0, 0)
        elseif SharedState.FlingActive then
            hrp.CFrame = tHrp.CFrame
        end
    end
    
    -- Spinbot
    if SharedState.Spinbot and hrp then
        hrp.CFrame = hrp.CFrame * CFrame.Angles(0, math.rad(SharedState.SpinSpeed), 0)
    end
    
    -- Vehicle Logic
    local seat = hum and hum.SeatPart
    if seat then
        local veh = seat.Parent or seat
        if SharedState.VehNitroActive then
            local pcallSuccess, isDown = pcall(function() 
                local bind = Library.Keybinds["Nitro Key"]
                if bind and bind.Key then return UserInputService:IsKeyDown(bind.Key) end
                return false
            end)
            if pcallSuccess and isDown then
                local rootPart = veh.PrimaryPart or seat
                rootPart.AssemblyLinearVelocity = rootPart.AssemblyLinearVelocity + (seat.CFrame.lookVector * SharedState.VehNitroPower * dt)
            end
        end
        if SharedState.VehFlyActive and vBg and vBv then
            vBg.CFrame = Camera.CFrame
            local move = Vector3.new()
            if flyCtrl.f > 0 then move = move + Camera.CFrame.lookVector end
            if flyCtrl.b > 0 then move = move - Camera.CFrame.lookVector end
            if flyCtrl.l > 0 then move = move - Camera.CFrame.rightVector end
            if flyCtrl.r > 0 then move = move + Camera.CFrame.rightVector end
            vBv.Velocity = move * SharedState.VehFlySpeed
        end
        if SharedState.VehSpeedActive and veh.PrimaryPart then
            if seat:IsA("VehicleSeat") then seat.MaxSpeed = SharedState.VehSpeed end
            if flyCtrl.f > 0 then veh.PrimaryPart.Velocity = veh.PrimaryPart.CFrame.lookVector * SharedState.VehSpeed end
        end
        if SharedState.VehNoclip then
            for _,p in pairs(veh:GetDescendants()) do
                if p:IsA("BasePart") and not string.match(p.Name:lower(), "wheel") then p.CanCollide = false end
            end
        end
    end
    
    -- Tracers
    if SharedState.Tracers then
        for _, p in pairs(Players:GetPlayers()) do
            if p ~= LocalPlayer and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
                local v, onS = Camera:WorldToViewportPoint(p.Character.HumanoidRootPart.Position)
                if onS then
                    if not Tracers[p] then Tracers[p] = Drawing.new("Line"); Tracers[p].Thickness=1.5; Tracers[p].Color=Theme.Accent end
                    Tracers[p].Visible = true
                    Tracers[p].From = SharedState.TracerOrigin == "Bottom" and Vector2.new(Camera.ViewportSize.X/2, Camera.ViewportSize.Y) or Vector2.new(Camera.ViewportSize.X/2, Camera.ViewportSize.Y/2)
                    Tracers[p].To = Vector2.new(v.X, v.Y)
                elseif Tracers[p] then Tracers[p].Visible = false end
            elseif Tracers[p] then Tracers[p].Visible = false end
        end
    else
        for _,t in pairs(Tracers) do t.Visible = false end
    end
end)

-- Clicker Loop
task.spawn(function()
    while task.wait(0.1) do
        if SharedState.AutoClicker then
            task.wait(1 / SharedState.ClickCPS)
            pcall(mouse1click)
        end
    end
end)

-- Jump Request
UserInputService.JumpRequest:Connect(function()
    if SharedState.InfJumpActive and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
        local hrp = LocalPlayer.Character.HumanoidRootPart
        local hum = LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
        
        local p = Instance.new("Part")
        p.Size = Vector3.new(5, 1, 5)
        p.Position = hrp.Position - Vector3.new(0, 3.2, 0)
        p.Anchored = true
        p.CanCollide = true
        p.Transparency = 1
        p.Parent = Workspace
        task.delay(0.1, function() p:Destroy() end)
        
        if hum then hum:ChangeState(Enum.HumanoidStateType.Jumping) end
    end
end)

-- Remote Event Sniffer Hook
local function setupSniffer()
    local oldNamecall
    oldNamecall = hookmetamethod(game, "__namecall", function(self, ...)
        local method = getnamecallmethod()
        local args = {...}
        
        if not checkcaller() then
            -- Bypass for No Stamina (Prevent stamina draining remotes from firing)
            if SharedState.NoStamina and (method == "FireServer" or method == "fireServer") then
                if self.Name:lower():find("stamina") or self.Name:lower():find("energy") or self.Name:lower():find("dash") then
                    return -- Drop the request, protecting stamina
                end
            end

            -- Remote Sniffer Logic
            if SharedState.RemoteSniffer then
                if method == "FireServer" or method == "fireServer" or method == "InvokeServer" or method == "invokeServer" then
                    local strArgs = {}
                    for i, v in pairs(args) do 
                        local s, r = pcall(function() return typeof(v) == "Instance" and v:GetFullName() or tostring(v) end)
                        table.insert(strArgs, s and r or "Unknown")
                    end
                    print(string.format("[SNIFFER] %s | Method: %s | Args: %s", self.Name, method, table.concat(strArgs, ", ")))
                end
            end
        end
        return oldNamecall(self, unpack(args))
    end)
end
pcall(setupSniffer)

Notify("VexelHUB PRO Final Loaded!", 5)
