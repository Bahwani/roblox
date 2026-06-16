local RS = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UIS = game:GetService("UserInputService")
local Net = require(RS.SharedModules.Networking)
local SeedData = require(RS.SharedModules.SeedData)
local LP = Players.LocalPlayer
 
for _, g in pairs({
    game:GetService("CoreGui"):FindFirstChild("GAG2Mail"),
    LP.PlayerGui:FindFirstChild("GAG2Mail")
}) do
    if g then g:Destroy() end
end
 
local SGui = Instance.new("ScreenGui")
SGui.Name = "GAG2Mail"
SGui.ResetOnSpawn = false
SGui.ZIndexBehavior = Enum.ZIndexBehavior.Global
pcall(function() SGui.Parent = game:GetService("CoreGui") end)
if not SGui.Parent then SGui.Parent = LP.PlayerGui end
 
local WIN_W       = 500
local WIN_H       = 420
local SIDEBAR_W   = 140
local TITLE_H     = 32
local MIN_W       = 380
local MIN_H       = 300
local MAX_W       = 700
local MAX_H       = 600
local RESIZE_SIZE = 10
 
local C = {
    bg          = Color3.fromRGB(18, 18, 22),
    sidebar     = Color3.fromRGB(24, 24, 30),
    panel       = Color3.fromRGB(28, 28, 36),
    titlebar    = Color3.fromRGB(20, 20, 26),
    input       = Color3.fromRGB(22, 22, 30),
    border      = Color3.fromRGB(45, 45, 60),
    accent      = Color3.fromRGB(230, 140, 30),
    accentHover = Color3.fromRGB(255, 165, 50),
    accentDim   = Color3.fromRGB(80, 50, 10),
    text        = Color3.fromRGB(210, 210, 220),
    textMuted   = Color3.fromRGB(110, 110, 140),
    textHint    = Color3.fromRGB(70, 70, 95),
    green       = Color3.fromRGB(50, 200, 110),
    red         = Color3.fromRGB(220, 70, 70),
    blue        = Color3.fromRGB(60, 140, 240),
    sideActive  = Color3.fromRGB(32, 32, 42),
    sideHover   = Color3.fromRGB(28, 28, 38),
    close       = Color3.fromRGB(190, 50, 50),
    minimize    = Color3.fromRGB(50, 50, 70),
    white       = Color3.fromRGB(255, 255, 255),
    darkBg      = Color3.fromRGB(14, 14, 18),
}
 
local Win = Instance.new("Frame")
Win.Name = "Window"
Win.Size = UDim2.new(0, WIN_W, 0, WIN_H)
Win.Position = UDim2.new(0.5, -WIN_W/2, 0.5, -WIN_H/2)
Win.BackgroundColor3 = C.bg
Win.BorderSizePixel = 0
Win.ClipsDescendants = false
Win.ZIndex = 10
Win.Parent = SGui
Instance.new("UICorner", Win).CornerRadius = UDim.new(0, 8)
 
local winStroke = Instance.new("UIStroke")
winStroke.Color = C.border
winStroke.Thickness = 1
winStroke.Parent = Win
 
local TBar = Instance.new("Frame")
TBar.Name = "TitleBar"
TBar.Size = UDim2.new(1, 0, 0, TITLE_H)
TBar.Position = UDim2.new(0, 0, 0, 0)
TBar.BackgroundColor3 = C.titlebar
TBar.BorderSizePixel = 0
TBar.ZIndex = 20
TBar.Parent = Win
Instance.new("UICorner", TBar).CornerRadius = UDim.new(0, 8)
 
local tbarBottomCover = Instance.new("Frame")
tbarBottomCover.Size = UDim2.new(1, 0, 0, 8)
tbarBottomCover.Position = UDim2.new(0, 0, 1, -8)
tbarBottomCover.BackgroundColor3 = C.titlebar
tbarBottomCover.BorderSizePixel = 0
tbarBottomCover.ZIndex = 20
tbarBottomCover.Parent = TBar
 
local accentLine = Instance.new("Frame")
accentLine.Size = UDim2.new(1, 0, 0, 2)
accentLine.Position = UDim2.new(0, 0, 1, -2)
accentLine.BackgroundColor3 = C.accent
accentLine.BorderSizePixel = 0
accentLine.ZIndex = 21
accentLine.Parent = TBar
 
local TIcon = Instance.new("TextLabel")
TIcon.Size = UDim2.new(0, 24, 1, 0)
TIcon.Position = UDim2.new(0, 10, 0, 0)
TIcon.BackgroundTransparency = 1
TIcon.Text = "📬"
TIcon.TextSize = 14
TIcon.Font = Enum.Font.Gotham
TIcon.TextXAlignment = Enum.TextXAlignment.Left
TIcon.ZIndex = 22
TIcon.Parent = TBar
 
local TTitle = Instance.new("TextLabel")
TTitle.Size = UDim2.new(1, -220, 1, 0)
TTitle.Position = UDim2.new(0, 36, 0, 0)
TTitle.BackgroundTransparency = 1
TTitle.Text = "GAG2 Mail"
TTitle.TextColor3 = C.white
TTitle.TextSize = 12
TTitle.Font = Enum.Font.GothamBold
TTitle.TextXAlignment = Enum.TextXAlignment.Left
TTitle.ZIndex = 22
TTitle.Parent = TBar
 
local TVersion = Instance.new("TextLabel")
TVersion.Size = UDim2.new(0, 100, 1, 0)
TVersion.Position = UDim2.new(0, 120, 0, 0)
TVersion.BackgroundTransparency = 1
TVersion.Text = "Petss 1.0.0"
TVersion.TextColor3 = C.textMuted
TVersion.TextSize = 10
TVersion.Font = Enum.Font.Gotham
TVersion.TextXAlignment = Enum.TextXAlignment.Left
TVersion.ZIndex = 22
TVersion.Parent = TBar
 
local function mkTitleBtn(xOff, bg, txt)
    local b = Instance.new("TextButton")
    b.Size = UDim2.new(0, 22, 0, 22)
    b.Position = UDim2.new(1, xOff, 0.5, -11)
    b.BackgroundColor3 = bg
    b.Text = txt
    b.TextColor3 = C.white
    b.TextSize = 11
    b.Font = Enum.Font.GothamBold
    b.BorderSizePixel = 0
    b.ZIndex = 23
    b.Parent = TBar
    Instance.new("UICorner", b).CornerRadius = UDim.new(0, 4)
    return b
end
 
local CloseB    = mkTitleBtn(-30, C.close,    "✕")
local MinimizeB = mkTitleBtn(-56, C.minimize, "—")
 
local Body = Instance.new("Frame")
Body.Name = "Body"
Body.Size = UDim2.new(1, 0, 1, -TITLE_H)
Body.Position = UDim2.new(0, 0, 0, TITLE_H)
Body.BackgroundTransparency = 1
Body.BorderSizePixel = 0
Body.ClipsDescendants = true
Body.ZIndex = 11
Body.Parent = Win
 
local Sidebar = Instance.new("Frame")
Sidebar.Name = "Sidebar"
Sidebar.Size = UDim2.new(0, SIDEBAR_W, 1, 0)
Sidebar.Position = UDim2.new(0, 0, 0, 0)
Sidebar.BackgroundColor3 = C.sidebar
Sidebar.BorderSizePixel = 0
Sidebar.ZIndex = 12
Sidebar.Parent = Body
 
local sideCorner = Instance.new("UICorner")
sideCorner.CornerRadius = UDim.new(0, 8)
sideCorner.Parent = Sidebar
 
local sideTopCover = Instance.new("Frame")
sideTopCover.Size = UDim2.new(1, 0, 0, 8)
sideTopCover.Position = UDim2.new(0, 0, 0, 0)
sideTopCover.BackgroundColor3 = C.sidebar
sideTopCover.BorderSizePixel = 0
sideTopCover.ZIndex = 12
sideTopCover.Parent = Sidebar
 
local sideStroke = Instance.new("Frame")
sideStroke.Size = UDim2.new(0, 1, 1, 0)
sideStroke.Position = UDim2.new(1, -1, 0, 0)
sideStroke.BackgroundColor3 = C.border
sideStroke.BorderSizePixel = 0
sideStroke.ZIndex = 13
sideStroke.Parent = Sidebar
 
local sideBottom = Instance.new("TextLabel")
sideBottom.Size = UDim2.new(1, 0, 0, 30)
sideBottom.Position = UDim2.new(0, 0, 1, -30)
sideBottom.BackgroundTransparency = 1
sideBottom.Text = "discord.gg/gag2"
sideBottom.TextColor3 = C.textHint
sideBottom.TextSize = 9
sideBottom.Font = Enum.Font.Gotham
sideBottom.ZIndex = 13
sideBottom.Parent = Sidebar
 
local NavContainer = Instance.new("Frame")
NavContainer.Name = "NavContainer"
NavContainer.Size = UDim2.new(1, 0, 1, -34)
NavContainer.Position = UDim2.new(0, 0, 0, 0)
NavContainer.BackgroundTransparency = 1
NavContainer.BorderSizePixel = 0
NavContainer.ZIndex = 13
NavContainer.Parent = Sidebar
 
local Panel = Instance.new("Frame")
Panel.Name = "Panel"
Panel.Size = UDim2.new(1, -SIDEBAR_W, 1, 0)
Panel.Position = UDim2.new(0, SIDEBAR_W, 0, 0)
Panel.BackgroundColor3 = C.panel
Panel.BorderSizePixel = 0
Panel.ClipsDescendants = true
Panel.ZIndex = 11
Panel.Parent = Body
 
local panelCorner = Instance.new("UICorner")
panelCorner.CornerRadius = UDim.new(0, 8)
panelCorner.Parent = Panel
 
local panelTopCover = Instance.new("Frame")
panelTopCover.Size = UDim2.new(1, 0, 0, 8)
panelTopCover.Position = UDim2.new(0, 0, 0, 0)
panelTopCover.BackgroundColor3 = C.panel
panelTopCover.BorderSizePixel = 0
panelTopCover.ZIndex = 11
panelTopCover.Parent = Panel
 
do
    local dragging, dragStart, startPos
    TBar.InputBegan:Connect(function(inp)
        if inp.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging  = true
            dragStart = inp.Position
            startPos  = Win.Position
        end
    end)
    TBar.InputEnded:Connect(function(inp)
        if inp.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = false
        end
    end)
    UIS.InputChanged:Connect(function(inp)
        if dragging and inp.UserInputType == Enum.UserInputType.MouseMovement then
            local delta = inp.Position - dragStart
            Win.Position = UDim2.new(
                startPos.X.Scale, startPos.X.Offset + delta.X,
                startPos.Y.Scale, startPos.Y.Offset + delta.Y
            )
        end
    end)
end
 
local ResizeHandle = Instance.new("TextButton")
ResizeHandle.Name = "ResizeHandle"
ResizeHandle.Size = UDim2.new(0, RESIZE_SIZE, 0, RESIZE_SIZE)
ResizeHandle.Position = UDim2.new(1, -RESIZE_SIZE, 1, -RESIZE_SIZE)
ResizeHandle.BackgroundColor3 = C.accent
ResizeHandle.Text = ""
ResizeHandle.BorderSizePixel = 0
ResizeHandle.ZIndex = 30
ResizeHandle.Parent = Win
Instance.new("UICorner", ResizeHandle).CornerRadius = UDim.new(0, 2)
 
do
    local resizing, resizeStart, startSize
    ResizeHandle.InputBegan:Connect(function(inp)
        if inp.UserInputType == Enum.UserInputType.MouseButton1 then
            resizing    = true
            resizeStart = inp.Position
            startSize   = Win.AbsoluteSize
        end
    end)
    ResizeHandle.InputEnded:Connect(function(inp)
        if inp.UserInputType == Enum.UserInputType.MouseButton1 then
            resizing = false
        end
    end)
    UIS.InputChanged:Connect(function(inp)
        if resizing and inp.UserInputType == Enum.UserInputType.MouseMovement then
            local delta = inp.Position - resizeStart
            local newW  = math.clamp(startSize.X + delta.X, MIN_W, MAX_W)
            local newH  = math.clamp(startSize.Y + delta.Y, MIN_H, MAX_H)
            Win.Size = UDim2.new(0, newW, 0, newH)
        end
    end)
end
 
local isMinimized = false
local prevHeight  = WIN_H
 
MinimizeB.MouseButton1Click:Connect(function()
    isMinimized = not isMinimized
    if isMinimized then
        prevHeight = Win.AbsoluteSize.Y
        TweenService:Create(Win, TweenInfo.new(0.2, Enum.EasingStyle.Quad), {
            Size = UDim2.new(0, Win.AbsoluteSize.X, 0, TITLE_H)
        }):Play()
        Body.Visible     = false
        MinimizeB.Text   = "□"
    else
        TweenService:Create(Win, TweenInfo.new(0.2, Enum.EasingStyle.Quad), {
            Size = UDim2.new(0, Win.AbsoluteSize.X, 0, prevHeight)
        }):Play()
        task.delay(0.05, function()
            Body.Visible = true
        end)
        MinimizeB.Text = "—"
    end
end)
 
CloseB.MouseButton1Click:Connect(function() SGui:Destroy() end)
 
local SideLayout = Instance.new("UIListLayout")
SideLayout.SortOrder = Enum.SortOrder.LayoutOrder
SideLayout.Padding   = UDim.new(0, 2)
SideLayout.Parent    = NavContainer
 
local SidePad = Instance.new("UIPadding")
SidePad.PaddingTop   = UDim.new(0, 8)
SidePad.PaddingLeft  = UDim.new(0, 6)
SidePad.PaddingRight = UDim.new(0, 6)
SidePad.Parent       = NavContainer
 
local pages       = {}
local navBtns     = {}
local currentPage = nil
 
local function mkNavBtn(icon, label, pageKey, order)
    local btn = Instance.new("TextButton")
    btn.Name             = pageKey
    btn.Size             = UDim2.new(1, 0, 0, 34)
    btn.BackgroundColor3 = C.sidebar
    btn.Text             = ""
    btn.BorderSizePixel  = 0
    btn.LayoutOrder      = order
    btn.ZIndex           = 14
    btn.Parent           = NavContainer
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 6)
 
    local ico = Instance.new("TextLabel")
    ico.Size               = UDim2.new(0, 22, 1, 0)
    ico.Position           = UDim2.new(0, 8, 0, 0)
    ico.BackgroundTransparency = 1
    ico.Text               = icon
    ico.TextSize           = 14
    ico.Font               = Enum.Font.Gotham
    ico.ZIndex             = 15
    ico.Parent             = btn
 
    local lbl = Instance.new("TextLabel")
    lbl.Size               = UDim2.new(1, -34, 1, 0)
    lbl.Position           = UDim2.new(0, 32, 0, 0)
    lbl.BackgroundTransparency = 1
    lbl.Text               = label
    lbl.TextColor3         = C.textMuted
    lbl.TextSize           = 11
    lbl.Font               = Enum.Font.GothamBold
    lbl.TextXAlignment     = Enum.TextXAlignment.Left
    lbl.ZIndex             = 15
    lbl.Parent             = btn
 
    navBtns[pageKey] = { btn = btn, lbl = lbl, ico = ico }
 
    btn.MouseButton1Click:Connect(function()
        for _, nb in pairs(navBtns) do
            nb.btn.BackgroundColor3 = C.sidebar
            nb.lbl.TextColor3       = C.textMuted
        end
        btn.BackgroundColor3 = C.sideActive
        lbl.TextColor3       = C.white
        if currentPage and pages[currentPage] then
            pages[currentPage].Visible = false
        end
        currentPage = pageKey
        if pages[pageKey] then
            pages[pageKey].Visible = true
        end
    end)
 
    btn.MouseEnter:Connect(function()
        if currentPage ~= pageKey then
            btn.BackgroundColor3 = C.sideHover
        end
    end)
    btn.MouseLeave:Connect(function()
        if currentPage ~= pageKey then
            btn.BackgroundColor3 = C.sidebar
        end
    end)
 
    return btn
end
 
mkNavBtn("🏠", "Home",      "home",     1)
mkNavBtn("📬", "Send Mail", "mail",     2)
mkNavBtn("🎒", "Backpack",  "backpack", 3)
mkNavBtn("⚙️",  "Settings",  "settings", 4)
 
local function mkPage(key)
    local f = Instance.new("ScrollingFrame")
    f.Name                 = key
    f.Size                 = UDim2.new(1, 0, 1, 0)
    f.BackgroundTransparency = 1
    f.BorderSizePixel      = 0
    f.ScrollBarThickness   = 3
    f.ScrollBarImageColor3 = C.accent
    f.CanvasSize           = UDim2.new(0, 0, 0, 0)
    f.Visible              = false
    f.ZIndex               = 12
    f.Parent               = Panel
 
    local layout = Instance.new("UIListLayout")
    layout.SortOrder = Enum.SortOrder.LayoutOrder
    layout.Padding   = UDim.new(0, 6)
    layout.Parent    = f
 
    local pad = Instance.new("UIPadding")
    pad.PaddingTop    = UDim.new(0, 12)
    pad.PaddingLeft   = UDim.new(0, 12)
    pad.PaddingRight  = UDim.new(0, 12)
    pad.PaddingBottom = UDim.new(0, 12)
    pad.Parent        = f
 
    layout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        f.CanvasSize = UDim2.new(0, 0, 0, layout.AbsoluteContentSize.Y + 20)
    end)
 
    pages[key] = f
    return f, layout
end
 
local function addLabel(parent, txt, color, order)
    local l = Instance.new("TextLabel")
    l.Size               = UDim2.new(1, 0, 0, 18)
    l.BackgroundTransparency = 1
    l.Text               = txt
    l.TextColor3         = color or C.textMuted
    l.TextSize           = 10
    l.Font               = Enum.Font.GothamBold
    l.TextXAlignment     = Enum.TextXAlignment.Left
    l.LayoutOrder        = order or 0
    l.ZIndex             = 13
    l.Parent             = parent
    return l
end
 
local function addInput(parent, placeholder, height, order)
    local f = Instance.new("Frame")
    f.Size             = UDim2.new(1, 0, 0, height or 34)
    f.BackgroundColor3 = C.input
    f.BorderSizePixel  = 0
    f.LayoutOrder      = order or 0
    f.ZIndex           = 13
    f.Parent           = parent
    Instance.new("UICorner", f).CornerRadius = UDim.new(0, 6)
    local stroke = Instance.new("UIStroke")
    stroke.Color     = C.border
    stroke.Thickness = 1
    stroke.Parent    = f
 
    local tb = Instance.new("TextBox")
    tb.Size               = UDim2.new(1, -12, 1, 0)
    tb.Position           = UDim2.new(0, 6, 0, 0)
    tb.BackgroundTransparency = 1
    tb.Text               = ""
    tb.PlaceholderText    = placeholder
    tb.PlaceholderColor3  = C.textHint
    tb.TextColor3         = C.text
    tb.TextSize           = 12
    tb.Font               = Enum.Font.Gotham
    tb.TextXAlignment     = Enum.TextXAlignment.Left
    tb.TextYAlignment     = Enum.TextYAlignment.Top
    tb.ClearTextOnFocus   = false
    tb.MultiLine          = (height or 34) > 36
    tb.TextWrapped        = true
    tb.ZIndex             = 14
    tb.Parent             = f
    return f, tb
end
 
local function addButton(parent, txt, color, cb, order)
    local b = Instance.new("TextButton")
    b.Size             = UDim2.new(1, 0, 0, 34)
    b.BackgroundColor3 = color or C.accent
    b.Text             = txt
    b.TextColor3       = C.white
    b.TextSize         = 12
    b.Font             = Enum.Font.GothamBold
    b.BorderSizePixel  = 0
    b.LayoutOrder      = order or 0
    b.ZIndex           = 13
    b.Parent           = parent
    Instance.new("UICorner", b).CornerRadius = UDim.new(0, 6)
    b.MouseButton1Click:Connect(function() if cb then pcall(cb) end end)
    b.MouseEnter:Connect(function()
        TweenService:Create(b, TweenInfo.new(0.1), {
            BackgroundColor3 = color and Color3.new(
                math.min(color.R * 1.15, 1),
                math.min(color.G * 1.15, 1),
                math.min(color.B * 1.15, 1)
            ) or C.accentHover
        }):Play()
    end)
    b.MouseLeave:Connect(function()
        TweenService:Create(b, TweenInfo.new(0.1), {
            BackgroundColor3 = color or C.accent
        }):Play()
    end)
    return b
end
 
local function addStatusBar(parent, txt, color, order)
    local f = Instance.new("Frame")
    f.Size             = UDim2.new(1, 0, 0, 28)
    f.BackgroundColor3 = C.input
    f.BorderSizePixel  = 0
    f.LayoutOrder      = order or 0
    f.ZIndex           = 13
    f.Parent           = parent
    Instance.new("UICorner", f).CornerRadius = UDim.new(0, 6)
 
    local l = Instance.new("TextLabel")
    l.Size             = UDim2.new(1, -10, 1, 0)
    l.Position         = UDim2.new(0, 5, 0, 0)
    l.BackgroundTransparency = 1
    l.Text             = txt
    l.TextColor3       = color or C.textMuted
    l.TextSize         = 11
    l.Font             = Enum.Font.Gotham
    l.TextXAlignment   = Enum.TextXAlignment.Left
    l.ZIndex           = 14
    l.Parent           = f
    return f, l
end
 
local function addDivider(parent, order)
    local f = Instance.new("Frame")
    f.Size             = UDim2.new(1, 0, 0, 1)
    f.BackgroundColor3 = C.border
    f.BorderSizePixel  = 0
    f.LayoutOrder      = order or 0
    f.ZIndex           = 13
    f.Parent           = parent
end

do
    local page = mkPage("home")
 
    local hero = Instance.new("Frame")
    hero.Size             = UDim2.new(1, 0, 0, 70)
    hero.BackgroundColor3 = C.accentDim
    hero.BorderSizePixel  = 0
    hero.LayoutOrder      = 1
    hero.ZIndex           = 13
    hero.Parent           = page
    Instance.new("UICorner", hero).CornerRadius = UDim.new(0, 8)
 
    local heroTitle = Instance.new("TextLabel")
    heroTitle.Size               = UDim2.new(1, -10, 0, 28)
    heroTitle.Position           = UDim2.new(0, 10, 0, 10)
    heroTitle.BackgroundTransparency = 1
    heroTitle.Text               = "📬  GAG2 Mail Sender"
    heroTitle.TextColor3         = C.accent
    heroTitle.TextSize           = 15
    heroTitle.Font               = Enum.Font.GothamBold
    heroTitle.TextXAlignment     = Enum.TextXAlignment.Left
    heroTitle.ZIndex             = 14
    heroTitle.Parent             = hero
 
    local heroSub = Instance.new("TextLabel")
    heroSub.Size               = UDim2.new(1, -10, 0, 20)
    heroSub.Position           = UDim2.new(0, 10, 0, 38)
    heroSub.BackgroundTransparency = 1
    heroSub.Text               = "Send seeds, pets, fruit & gear to anyone"
    heroSub.TextColor3         = C.textMuted
    heroSub.TextSize           = 11
    heroSub.Font               = Enum.Font.Gotham
    heroSub.TextXAlignment     = Enum.TextXAlignment.Left
    heroSub.ZIndex             = 14
    heroSub.Parent             = hero
 
    addDivider(page, 2)
 
    local infoItems = {
        { "Discord",        "Join our community", "▶" },
        { "Discord Invite", "Copy invite link",   "+" },
        { "LocalPlayer",    LP.Name,              "▶" },
    }
 
    for i, item in ipairs(infoItems) do
        local row = Instance.new("Frame")
        row.Size             = UDim2.new(1, 0, 0, 42)
        row.BackgroundColor3 = C.sidebar
        row.BorderSizePixel  = 0
        row.LayoutOrder      = i + 2
        row.ZIndex           = 13
        row.Parent           = page
        Instance.new("UICorner", row).CornerRadius = UDim.new(0, 6)
        local stroke = Instance.new("UIStroke")
        stroke.Color = C.border; stroke.Thickness = 1; stroke.Parent = row
 
        local title = Instance.new("TextLabel")
        title.Size           = UDim2.new(1, -40, 0, 20)
        title.Position       = UDim2.new(0, 12, 0, 6)
        title.BackgroundTransparency = 1
        title.Text           = item[1]
        title.TextColor3     = C.text
        title.TextSize       = 12
        title.Font           = Enum.Font.GothamBold
        title.TextXAlignment = Enum.TextXAlignment.Left
        title.ZIndex         = 14
        title.Parent         = row
 
        local sub = Instance.new("TextLabel")
        sub.Size             = UDim2.new(1, -40, 0, 16)
        sub.Position         = UDim2.new(0, 12, 0, 24)
        sub.BackgroundTransparency = 1
        sub.Text             = item[2]
        sub.TextColor3       = C.textMuted
        sub.TextSize         = 10
        sub.Font             = Enum.Font.Gotham
        sub.TextXAlignment   = Enum.TextXAlignment.Left
        sub.ZIndex           = 14
        sub.Parent           = row
 
        local chev = Instance.new("TextLabel")
        chev.Size            = UDim2.new(0, 30, 1, 0)
        chev.Position        = UDim2.new(1, -34, 0, 0)
        chev.BackgroundTransparency = 1
        chev.Text            = item[3]
        chev.TextColor3      = C.accent
        chev.TextSize        = 14
        chev.Font            = Enum.Font.GothamBold
        chev.ZIndex          = 14
        chev.Parent          = row
    end
end
 
local lookupResult = nil
local selectedItem = nil
local statusLabel  = nil
 
local function lookupPlayer(username, callback)
    lookupResult = nil
    task.spawn(function()
        local ok, uid = pcall(function()
            return Players:GetUserIdFromNameAsync(username)
        end)
        if ok and uid then
            lookupResult = { userId = uid, username = username }
            if callback then callback(lookupResult) end
        else
            pcall(function() Net.Mailbox.LookupPlayer:Fire(username) end)
            if callback then callback(nil) end
        end
    end)
end
 
local function getBackpackItems()
    local items = {}
    for _, tool in pairs(LP.Backpack:GetChildren()) do
        if not tool:IsA("Tool") then continue end
        local name        = tool.Name
        local category    = "Gear"
        local itemKey     = name
        local displayName = name
 
        for _, sd in pairs(SeedData) do
            if type(sd) == "table" and sd.SeedName == name then
                category = "Seeds"; itemKey = name; break
            end
        end
 
        if name:find("%[") then
            local fruitName = name:match("^(.-)%s*%[")
            local weight    = name:match("%[(.-)%]")
            local weightNum = weight and tonumber(weight:match("([%d%.]+)")) or 0
            local valueNum  = math.floor(weightNum * 1000)
            if fruitName then
                category = "Fruit"; itemKey = fruitName .. ":" .. valueNum; displayName = name
            end
        end
 
        local ok, PetData = pcall(function() return require(RS.SharedData.PetData) end)
        if ok and PetData then
            for _, pd in pairs(PetData) do
                if type(pd) == "table" and pd.DisplayName == name then
                    category = "Pets"
                    local uuid = tool:GetAttribute("PetId") or tool:GetAttribute("Id") or tool:GetAttribute("UUID")
                    if uuid then itemKey = uuid end
                    break
                end
            end
        end
 
        table.insert(items, {
            display  = displayName .. " [" .. category .. "]",
            itemKey  = itemKey,
            category = category,
            name     = name,
            tool     = tool
        })
    end
    return items
end
 
do
    local page, layout = mkPage("mail")
 
    local _, sLbl = addStatusBar(page, "● Ready  —  search a player first", C.textMuted, 1)
    statusLabel = sLbl
 
    local function setStatus(txt, color)
        statusLabel.Text       = txt
        statusLabel.TextColor3 = color or C.textMuted
    end
 
    addDivider(page, 2)
 
    addLabel(page, "RECIPIENT", C.accent, 3)
    local _, usernameInput = addInput(page, "Enter username (e.g. Roblox)", 34, 4)
    local _, recipInfo     = addStatusBar(page, "⚠  Username not searched yet", C.textHint, 5)
 
    addButton(page, "Search Player", C.blue, function()
        local uname = usernameInput.Text
        if uname == "" then setStatus("⚠  Enter a username first!", C.accent); return end
        setStatus("🔍  Searching " .. uname .. "...", C.blue)
        recipInfo.Text       = "Searching..."
        recipInfo.TextColor3 = C.blue
        lookupPlayer(uname, function(res)
            if res then
                recipInfo.Text       = "✓  " .. res.username .. "  (ID: " .. res.userId .. ")"
                recipInfo.TextColor3 = C.green
                setStatus("✓  Player found!", C.green)
            else
                recipInfo.Text       = "✗  Player not found"
                recipInfo.TextColor3 = C.red
                setStatus("✗  Player not found", C.red)
            end
        end)
    end, 6)
 
    addDivider(page, 7)
 
    addLabel(page, "ITEM  (from backpack)", C.accent, 8)
 
    local itemContainer = Instance.new("Frame")
    itemContainer.Size             = UDim2.new(1, 0, 0, 34)
    itemContainer.BackgroundColor3 = C.input
    itemContainer.BorderSizePixel  = 0
    itemContainer.ClipsDescendants = true
    itemContainer.LayoutOrder      = 9
    itemContainer.ZIndex           = 13
    itemContainer.Parent           = page
    Instance.new("UICorner", itemContainer).CornerRadius = UDim.new(0, 6)
    local icStroke = Instance.new("UIStroke")
    icStroke.Color = C.border; icStroke.Thickness = 1; icStroke.Parent = itemContainer
 
    local itemHeader = Instance.new("TextButton")
    itemHeader.Size               = UDim2.new(1, 0, 0, 34)
    itemHeader.BackgroundTransparency = 1
    itemHeader.Text               = ""
    itemHeader.ZIndex             = 14
    itemHeader.Parent             = itemContainer
 
    local itemLabel = Instance.new("TextLabel")
    itemLabel.Size             = UDim2.new(1, -36, 0, 34)
    itemLabel.Position         = UDim2.new(0, 10, 0, 0)
    itemLabel.BackgroundTransparency = 1
    itemLabel.Text             = "Select item..."
    itemLabel.TextColor3       = C.textHint
    itemLabel.TextSize         = 12
    itemLabel.Font             = Enum.Font.Gotham
    itemLabel.TextXAlignment   = Enum.TextXAlignment.Left
    itemLabel.TextTruncate     = Enum.TextTruncate.AtEnd
    itemLabel.ZIndex           = 15
    itemLabel.Parent           = itemContainer
 
    local itemArrow = Instance.new("TextLabel")
    itemArrow.Size             = UDim2.new(0, 28, 0, 34)
    itemArrow.Position         = UDim2.new(1, -30, 0, 0)
    itemArrow.BackgroundTransparency = 1
    itemArrow.Text             = "▼"
    itemArrow.TextColor3       = C.accent
    itemArrow.TextSize         = 11
    itemArrow.Font             = Enum.Font.GothamBold
    itemArrow.ZIndex           = 15
    itemArrow.Parent           = itemContainer
 
    local itemOptList = Instance.new("Frame")
    itemOptList.Position         = UDim2.new(0, 0, 0, 35)
    itemOptList.BackgroundTransparency = 1
    itemOptList.ZIndex           = 15
    itemOptList.Parent           = itemContainer
 
    local itemOptLayout = Instance.new("UIListLayout")
    itemOptLayout.Padding = UDim.new(0, 2)
    itemOptLayout.Parent  = itemOptList
 
    local itemOptPad = Instance.new("UIPadding")
    itemOptPad.PaddingLeft   = UDim.new(0, 4)
    itemOptPad.PaddingRight  = UDim.new(0, 4)
    itemOptPad.PaddingBottom = UDim.new(0, 4)
    itemOptPad.Parent        = itemOptList
 
    itemOptLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        itemOptList.Size = UDim2.new(1, 0, 0, itemOptLayout.AbsoluteContentSize.Y + 6)
    end)
 
    local isItemOpen = false
    local itemBtns   = {}
 
    local function refreshItemList()
        for _, c in pairs(itemOptList:GetChildren()) do
            if c:IsA("TextButton") or c:IsA("TextLabel") then c:Destroy() end
        end
        itemBtns     = {}
        selectedItem = nil
        itemLabel.Text       = "Select item..."
        itemLabel.TextColor3 = C.textHint
 
        local items = getBackpackItems()
 
        if #items == 0 then
            local empty = Instance.new("TextLabel")
            empty.Size             = UDim2.new(1, 0, 0, 28)
            empty.BackgroundTransparency = 1
            empty.Text             = "  (Backpack is empty)"
            empty.TextColor3       = C.textHint
            empty.TextSize         = 11
            empty.Font             = Enum.Font.Gotham
            empty.TextXAlignment   = Enum.TextXAlignment.Left
            empty.ZIndex           = 16
            empty.Parent           = itemOptList
            return
        end
 
        for i, item in ipairs(items) do
            local ob = Instance.new("TextButton")
            ob.Size             = UDim2.new(1, 0, 0, 28)
            ob.BackgroundColor3 = C.sidebar
            ob.Text             = "  " .. item.display
            ob.TextColor3       = C.text
            ob.TextSize         = 11
            ob.Font             = Enum.Font.Gotham
            ob.TextXAlignment   = Enum.TextXAlignment.Left
            ob.BorderSizePixel  = 0
            ob.LayoutOrder      = i
            ob.ZIndex           = 16
            ob.Parent           = itemOptList
            Instance.new("UICorner", ob).CornerRadius = UDim.new(0, 5)
            itemBtns[i] = { btn = ob, item = item }
 
            ob.MouseButton1Click:Connect(function()
                selectedItem         = item
                itemLabel.Text       = item.display
                itemLabel.TextColor3 = C.green
 
                for _, b in pairs(itemBtns) do
                    b.btn.BackgroundColor3 = C.sidebar
                    b.btn.TextColor3       = C.text
                end
                ob.BackgroundColor3 = C.accentDim
                ob.TextColor3       = C.accent
 
                isItemOpen = false
                TweenService:Create(itemContainer, TweenInfo.new(0.15), {
                    Size = UDim2.new(1, 0, 0, 34)
                }):Play()
                itemArrow.Text = "▼"
                setStatus("Item selected: " .. item.name, C.green)
            end)
        end
    end
 
    itemHeader.MouseButton1Click:Connect(function()
        isItemOpen = not isItemOpen
        local targetH = isItemOpen and (35 + itemOptLayout.AbsoluteContentSize.Y + 10) or 34
        TweenService:Create(itemContainer, TweenInfo.new(0.2), {
            Size = UDim2.new(1, 0, 0, targetH)
        }):Play()
        itemArrow.Text = isItemOpen and "▲" or "▼"
        if isItemOpen then refreshItemList() end
    end)
 
    addButton(page, "↻  Refresh Backpack", C.sidebar, function()
        refreshItemList()
        setStatus("Backpack refreshed!", C.green)
    end, 10)
 
    addDivider(page, 11)
 
    -- Quantity + Message
    addLabel(page, "QUANTITY", C.accent, 12)
    local _, countInput = addInput(page, "Amount (default: 1)", 34, 13)
 
    addLabel(page, "MESSAGE  (optional)", C.accent, 14)
    local _, messageInput = addInput(page, "Write a message...", 56, 15)
 
    addDivider(page, 16)
 
    addButton(page, "📬  Send Mail", C.accent, function()
        if not lookupResult then setStatus("⚠  Search a player first!", C.accent); return end
        if not selectedItem  then setStatus("⚠  Select an item first!",  C.accent); return end
 
        local count   = math.max(tonumber(countInput.Text) or 1, 1)
        local message = messageInput.Text or ""
        local items   = {{ ItemKey = selectedItem.itemKey, Count = count, Category = selectedItem.category }}
 
        setStatus("📬  Sending...", C.blue)
        local ok, err = pcall(function()
            Net.Mailbox.SendBatch:Fire(lookupResult.userId, items, message)
        end)
        if ok then
            setStatus("✓  Mail sent to " .. lookupResult.username .. "!", C.green)
        else
            setStatus("✗  Failed: " .. tostring(err), C.red)
        end
    end, 17)
 
    addButton(page, "🧪  Send to Myself (Test)", Color3.fromRGB(70, 50, 130), function()
        if not selectedItem then setStatus("⚠  Select an item first!", C.accent); return end
 
        local count   = math.max(tonumber(countInput.Text) or 1, 1)
        local message = messageInput.Text or "Test from hub!"
        local items   = {{ ItemKey = selectedItem.itemKey, Count = count, Category = selectedItem.category }}
 
        local ok = pcall(function()
            Net.Mailbox.SendBatch:Fire(LP.UserId, items, message)
        end)
        setStatus(
            ok and "✓  Test mail sent!" or "✗  Failed!",
            ok and C.green or C.red
        )
    end, 18)
 
    refreshItemList()
end
 
do
    local page = mkPage("backpack")
 
    addLabel(page, "BACKPACK CONTENTS", C.accent, 1)
 
    local bpList = Instance.new("Frame")
    bpList.Size                   = UDim2.new(1, 0, 0, 10)
    bpList.BackgroundTransparency = 1
    bpList.BorderSizePixel        = 0
    bpList.LayoutOrder            = 2
    bpList.ZIndex                 = 13
    bpList.Parent                 = page
 
    local bpLayout = Instance.new("UIListLayout")
    bpLayout.Padding = UDim.new(0, 4)
    bpLayout.Parent  = bpList
 
    bpLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        bpList.Size = UDim2.new(1, 0, 0, bpLayout.AbsoluteContentSize.Y)
    end)
 
    local function refreshBP()
        for _, c in pairs(bpList:GetChildren()) do
            if not c:IsA("UIListLayout") then c:Destroy() end
        end
 
        local items = {}
        for _, tool in pairs(LP.Backpack:GetChildren()) do
            if tool:IsA("Tool") then table.insert(items, tool.Name) end
        end
 
        if #items == 0 then
            local e = Instance.new("TextLabel")
            e.Size               = UDim2.new(1, 0, 0, 28)
            e.BackgroundTransparency = 1
            e.Text               = "Backpack is empty"
            e.TextColor3         = C.textHint
            e.TextSize           = 12
            e.Font               = Enum.Font.Gotham
            e.ZIndex             = 14
            e.Parent             = bpList
            return
        end
 
        for i, name in ipairs(items) do
            local row = Instance.new("Frame")
            row.Size             = UDim2.new(1, 0, 0, 30)
            row.BackgroundColor3 = C.input
            row.BorderSizePixel  = 0
            row.LayoutOrder      = i
            row.ZIndex           = 13
            row.Parent           = bpList
            Instance.new("UICorner", row).CornerRadius = UDim.new(0, 5)
 
            local idx = Instance.new("TextLabel")
            idx.Size             = UDim2.new(0, 24, 1, 0)
            idx.Position         = UDim2.new(0, 6, 0, 0)
            idx.BackgroundTransparency = 1
            idx.Text             = tostring(i)
            idx.TextColor3       = C.accent
            idx.TextSize         = 10
            idx.Font             = Enum.Font.GothamBold
            idx.ZIndex           = 14
            idx.Parent           = row
 
            local lbl = Instance.new("TextLabel")
            lbl.Size             = UDim2.new(1, -34, 1, 0)
            lbl.Position         = UDim2.new(0, 28, 0, 0)
            lbl.BackgroundTransparency = 1
            lbl.Text             = name
            lbl.TextColor3       = C.text
            lbl.TextSize         = 11
            lbl.Font             = Enum.Font.Gotham
            lbl.TextXAlignment   = Enum.TextXAlignment.Left
            lbl.TextTruncate     = Enum.TextTruncate.AtEnd
            lbl.ZIndex           = 14
            lbl.Parent           = row
        end
    end
 
    addButton(page, "↻  Refresh List", C.sidebar, refreshBP, 3)
    refreshBP()
end
 
do
    local page = mkPage("settings")
 
    addLabel(page, "ABOUT", C.accent, 1)
 
    local aboutItems = {
        { "Script",  "GAG2 Mail GUI" },
        { "Version", "1.0.0" },
        { "Author",  "Petss" },
        { "Player",  LP.Name },
        { "User ID", tostring(LP.UserId) },
    }
 
    for i, item in ipairs(aboutItems) do
        local row = Instance.new("Frame")
        row.Size             = UDim2.new(1, 0, 0, 30)
        row.BackgroundColor3 = C.input
        row.BorderSizePixel  = 0
        row.LayoutOrder      = i + 1
        row.ZIndex           = 13
        row.Parent           = page
        Instance.new("UICorner", row).CornerRadius = UDim.new(0, 5)
 
        local key = Instance.new("TextLabel")
        key.Size             = UDim2.new(0.45, 0, 1, 0)
        key.Position         = UDim2.new(0, 10, 0, 0)
        key.BackgroundTransparency = 1
        key.Text             = item[1]
        key.TextColor3       = C.textMuted
        key.TextSize         = 11
        key.Font             = Enum.Font.GothamBold
        key.TextXAlignment   = Enum.TextXAlignment.Left
        key.ZIndex           = 14
        key.Parent           = row
 
        local val = Instance.new("TextLabel")
        val.Size             = UDim2.new(0.55, -10, 1, 0)
        val.Position         = UDim2.new(0.45, 0, 0, 0)
        val.BackgroundTransparency = 1
        val.Text             = item[2]
        val.TextColor3       = C.text
        val.TextSize         = 11
        val.Font             = Enum.Font.Gotham
        val.TextXAlignment   = Enum.TextXAlignment.Right
        val.TextTruncate     = Enum.TextTruncate.AtEnd
        val.ZIndex           = 14
        val.Parent           = row
    end
 
    addDivider(page, 10)
    addButton(page, "✕  Close GUI", C.close, function() SGui:Destroy() end, 11)
end
 
navBtns["home"].btn.BackgroundColor3 = C.sideActive
navBtns["home"].lbl.TextColor3       = C.white
currentPage = "home"
pages["home"].Visible = true
 
print("GAG2 Mail by Petss loaded!")
