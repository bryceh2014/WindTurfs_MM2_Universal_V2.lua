--[[
===============================================================
 WINDTURF'S MM2 / UNIVERSAL SCRIPT V2.0
 Android / Mobile UI
 UI + monitoring framework
===============================================================
]]

local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local Stats = game:GetService("Stats")

local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")

--==============================================================
-- CONFIG
--==============================================================

local CONFIG = {
    Version = "2.0",

    PremiumUsers = {
        windturf = true,
        lvliaqqt = true,
    },

    Settings = {
        Galaxy = true,
        Stars = true,
        Nebula = true,
        Animations = true,
        CompactMode = false,

        FPSCounter = true,
        PingDisplay = true,
        SessionTimer = true,

        Notifications = true,

        RoleHighlight = true,
        MurdererIndicator = true,
        SheriffIndicator = true,
        GunTracker = true,

        SuspiciousMovement = true,
        SuspiciousChat = true,
        RepeatMessageDetection = true,
        HackerAlerts = true,
        MiniAvatarDetection = true,

        AutoLock = false,

        DraggableWindow = true,
        DraggableReopen = true,
        MobileOptimization = true,
    }
}

local sessionStart = os.clock()

--==============================================================
-- COLORS
--==============================================================

local C = {
    Background = Color3.fromRGB(7, 9, 19),
    Background2 = Color3.fromRGB(10, 13, 27),
    Panel = Color3.fromRGB(13, 17, 34),
    Panel2 = Color3.fromRGB(18, 23, 45),
    Panel3 = Color3.fromRGB(23, 29, 56),

    Text = Color3.fromRGB(238, 243, 255),
    Muted = Color3.fromRGB(145, 155, 184),
    Dim = Color3.fromRGB(92, 102, 130),

    Blue = Color3.fromRGB(88, 145, 255),
    Blue2 = Color3.fromRGB(64, 108, 220),
    Purple = Color3.fromRGB(139, 91, 255),
    Cyan = Color3.fromRGB(72, 215, 255),

    Green = Color3.fromRGB(70, 220, 143),
    Yellow = Color3.fromRGB(255, 205, 92),
    Red = Color3.fromRGB(255, 82, 103),

    White = Color3.fromRGB(255, 255, 255),
}

--==============================================================
-- CLEAN PREVIOUS VERSION
--==============================================================

pcall(function()
    local old = PlayerGui:FindFirstChild("WindTurfUniversalV2")
    if old then
        old:Destroy()
    end
end)

--==============================================================
-- HELPERS
--==============================================================

local function corner(object, radius)
    local c = Instance.new("UICorner")
    c.CornerRadius = UDim.new(0, radius or 8)
    c.Parent = object
    return c
end

local function stroke(object, color, transparency, thickness)
    local s = Instance.new("UIStroke")
    s.Color = color or C.Blue
    s.Transparency = transparency or 0
    s.Thickness = thickness or 1
    s.Parent = object
    return s
end

local function gradient(object, colorSequence, rotation)
    local g = Instance.new("UIGradient")
    g.Color = colorSequence
    g.Rotation = rotation or 0
    g.Parent = object
    return g
end

local function label(parent, text, size, position, textSize, color)
    local l = Instance.new("TextLabel")
    l.Name = "Label"
    l.Text = text or ""
    l.Size = size or UDim2.new(1, 0, 0, 30)
    l.Position = position or UDim2.new()
    l.BackgroundTransparency = 1
    l.TextColor3 = color or C.Text
    l.TextSize = textSize or 14
    l.Font = Enum.Font.Gotham
    l.TextXAlignment = Enum.TextXAlignment.Left
    l.TextYAlignment = Enum.TextYAlignment.Center
    l.Parent = parent
    return l
end

local function button(parent, text, size, position)
    local b = Instance.new("TextButton")
    b.Name = "Button"
    b.Text = text or ""
    b.Size = size or UDim2.new(1, 0, 0, 40)
    b.Position = position or UDim2.new()
    b.BackgroundColor3 = C.Panel2
    b.BorderSizePixel = 0
    b.TextColor3 = C.Text
    b.TextSize = 13
    b.Font = Enum.Font.GothamMedium
    b.AutoButtonColor = false
    b.Parent = parent

    corner(b, 9)

    b.MouseEnter:Connect(function()
        TweenService:Create(
            b,
            TweenInfo.new(.15),
            {BackgroundColor3 = C.Panel3}
        ):Play()
    end)

    b.MouseLeave:Connect(function()
        TweenService:Create(
            b,
            TweenInfo.new(.15),
            {BackgroundColor3 = C.Panel2}
        ):Play()
    end)

    return b
end

--==============================================================
-- MAIN GUI
--==============================================================

local Gui = Instance.new("ScreenGui")
Gui.Name = "WindTurfUniversalV2"
Gui.ResetOnSpawn = false
Gui.IgnoreGuiInset = true
Gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
Gui.Parent = PlayerGui

local Main = Instance.new("Frame")
Main.Name = "MainWindow"
Main.AnchorPoint = Vector2.new(.5, .5)
Main.Position = UDim2.fromScale(.5, .5)
Main.Size = UDim2.fromOffset(520, 520)
Main.BackgroundColor3 = C.Background
Main.BorderSizePixel = 0
Main.ClipsDescendants = true
Main.Parent = Gui

corner(Main, 20)
stroke(Main, C.Blue, .38, 1)

gradient(
    Main,
    ColorSequence.new({
        ColorSequenceKeypoint.new(0, C.Background),
        ColorSequenceKeypoint.new(.5, Color3.fromRGB(14, 12, 31)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(7, 19, 32)),
    }),
    35
)

local MainScale = Instance.new("UIScale")
MainScale.Scale = 1
MainScale.Parent = Main

--==============================================================
-- GALAXY BACKGROUND
--==============================================================

local NebulaObjects = {}
local StarObjects = {}

local Galaxy = Instance.new("Frame")
Galaxy.Name = "GalaxyBackground"
Galaxy.Size = UDim2.fromScale(1, 1)
Galaxy.BackgroundTransparency = 1
Galaxy.ZIndex = 0
Galaxy.Parent = Main

local function createNebula(position, size, color, transparency)
    local n = Instance.new("Frame")
    n.AnchorPoint = Vector2.new(.5, .5)
    n.Position = position
    n.Size = size
    n.BackgroundColor3 = color
    n.BackgroundTransparency = transparency
    n.BorderSizePixel = 0
    n.ZIndex = 0
    n.Parent = Galaxy
    corner(n, 999)
    table.insert(NebulaObjects, n)
    return n
end

if CONFIG.Settings.Galaxy and CONFIG.Settings.Nebula then
    createNebula(
        UDim2.fromScale(.15, .2),
        UDim2.fromScale(.7, .5),
        C.Purple,
        .92
    )

    createNebula(
        UDim2.fromScale(.85, .75),
        UDim2.fromScale(.65, .5),
        C.Blue,
        .93
    )

    createNebula(
        UDim2.fromScale(.5, .5),
        UDim2.fromScale(.5, .35),
        C.Cyan,
        .96
    )
end

if CONFIG.Settings.Stars then
    math.randomseed(21)

    for i = 1, 65 do
        local star = Instance.new("Frame")
        star.Name = "Star"
        star.Size = UDim2.fromOffset(
            math.random(1, 3),
            math.random(1, 3)
        )
        star.Position = UDim2.fromScale(
            math.random(),
            math.random()
        )
        star.BackgroundColor3 = C.White
        star.BackgroundTransparency = math.random(35, 80) / 100
        star.BorderSizePixel = 0
        star.ZIndex = 0
        star.Parent = Galaxy
        corner(star, 10)
        table.insert(StarObjects, star)
    end
end

--==============================================================
-- HEADER
--==============================================================

local Header = Instance.new("Frame")
Header.Name = "Header"
Header.Size = UDim2.new(1, 0, 0, 72)
Header.BackgroundColor3 = C.Panel
Header.BackgroundTransparency = .08
Header.BorderSizePixel = 0
Header.ZIndex = 5
Header.Parent = Main

local Title = label(
    Header,
    "WindTurf's mm2 script/universal script",
    UDim2.new(1, -100, 0, 30),
    UDim2.fromOffset(18, 10),
    17,
    C.Text
)

Title.Font = Enum.Font.GothamBold

local Subtitle = label(
    Header,
    "Android Edition • V2.0",
    UDim2.new(1, -120, 0, 20),
    UDim2.fromOffset(19, 39),
    11,
    C.Muted
)

local PremiumBadge = Instance.new("TextLabel")
PremiumBadge.Size = UDim2.fromOffset(78, 25)
PremiumBadge.Position = UDim2.new(1, -120, 0, 13)
PremiumBadge.BackgroundColor3 = C.Purple
PremiumBadge.BackgroundTransparency = .25
PremiumBadge.Text = "PREMIUM"
PremiumBadge.TextColor3 = C.White
PremiumBadge.TextSize = 10
PremiumBadge.Font = Enum.Font.GothamBold
PremiumBadge.BorderSizePixel = 0
PremiumBadge.Parent = Header
corner(PremiumBadge, 8)

local CloseButton = button(
    Header,
    "X",
    UDim2.fromOffset(36, 36),
    UDim2.new(1, -48, 0, 12)
)

CloseButton.BackgroundColor3 = C.Red
CloseButton.TextSize = 15
CloseButton.Font = Enum.Font.GothamBold

--==============================================================
-- DRAGGING
--==============================================================

local dragging = false
local dragStart
local startPosition

Header.InputBegan:Connect(function(input)
    if not CONFIG.Settings.DraggableWindow then
        return
    end

    if input.UserInputType == Enum.UserInputType.MouseButton1
        or input.UserInputType == Enum.UserInputType.Touch then

        dragging = true
        dragStart = input.Position
        startPosition = Main.Position
    end
end)

Header.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1
        or input.UserInputType == Enum.UserInputType.Touch then

        dragging = false
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if not dragging then
        return
    end

    if input.UserInputType ~= Enum.UserInputType.MouseMovement
        and input.UserInputType ~= Enum.UserInputType.Touch then
        return
    end

    local delta = input.Position - dragStart

    Main.Position = UDim2.new(
        startPosition.X.Scale,
        startPosition.X.Offset + delta.X,
        startPosition.Y.Scale,
        startPosition.Y.Offset + delta.Y
    )
end)

--==============================================================
-- CONTENT CONTAINER
--==============================================================

local Content = Instance.new("Frame")
Content.Name = "Content"
Content.Position = UDim2.fromOffset(10, 82)
Content.Size = UDim2.new(1, -20, 1, -92)
Content.BackgroundTransparency = 1
Content.ZIndex = 3
Content.Parent = Main

--==============================================================
-- SIDEBAR
--==============================================================

local Sidebar = Instance.new("Frame")
Sidebar.Name = "Sidebar"
Sidebar.Size = UDim2.new(0, 120, 1, 0)
Sidebar.Position = UDim2.new(0, 0, 0, 0)
Sidebar.BackgroundColor3 = C.Panel
Sidebar.BackgroundTransparency = .12
Sidebar.BorderSizePixel = 0
Sidebar.Parent = Content

corner(Sidebar, 12)
stroke(Sidebar, C.Blue, .8, 1)

local SidebarLayout = Instance.new("UIListLayout")
SidebarLayout.Padding = UDim.new(0, 5)
SidebarLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
SidebarLayout.SortOrder = Enum.SortOrder.LayoutOrder
SidebarLayout.Parent = Sidebar

local SidebarPadding = Instance.new("UIPadding")
SidebarPadding.PaddingTop = UDim.new(0, 8)
SidebarPadding.PaddingBottom = UDim.new(0, 8)
SidebarPadding.PaddingLeft = UDim.new(0, 7)
SidebarPadding.PaddingRight = UDim.new(0, 7)
SidebarPadding.Parent = Sidebar

--==============================================================
-- PAGE CONTAINER
--==============================================================

local PageContainer = Instance.new("Frame")
PageContainer.Name = "PageContainer"
PageContainer.Position = UDim2.new(0, 130, 0, 0)
PageContainer.Size = UDim2.new(1, -130, 1, 0)
PageContainer.BackgroundTransparency = 1
PageContainer.ClipsDescendants = true
PageContainer.Parent = Content

local Pages = {}
local Tabs = {}
local CurrentPage = nil

local function createPage(name)
    local page = Instance.new("ScrollingFrame")
    page.Name = name
    page.Size = UDim2.fromScale(1, 1)
    page.BackgroundTransparency = 1
    page.BorderSizePixel = 0
    page.ScrollBarThickness = 3
    page.ScrollBarImageColor3 = C.Blue
    page.CanvasSize = UDim2.new()
    page.Visible = false
    page.Parent = PageContainer

    local padding = Instance.new("UIPadding")
    padding.PaddingTop = UDim.new(0, 4)
    padding.PaddingBottom = UDim.new(0, 10)
    padding.PaddingLeft = UDim.new(0, 4)
    padding.PaddingRight = UDim.new(0, 4)
    padding.Parent = page

    local layout = Instance.new("UIListLayout")
    layout.Padding = UDim.new(0, 8)
    layout.SortOrder = Enum.SortOrder.LayoutOrder
    layout.Parent = page

    layout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        page.CanvasSize = UDim2.fromOffset(
            0,
            layout.AbsoluteContentSize.Y + 20
        )
    end)

    Pages[name] = page
    return page
end

local function selectPage(name)
    for pageName, page in pairs(Pages) do
        page.Visible = pageName == name
    end

    for tabName, tab in pairs(Tabs) do
        if tabName == name then
            tab.BackgroundColor3 = C.Blue2
        else
            tab.BackgroundColor3 = C.Panel2
        end
    end

    CurrentPage = name
end

local function createTab(name, text, order)
    local tab = button(
        Sidebar,
        text,
        UDim2.new(1, 0, 0, 42),
        UDim2.new()
    )

    tab.LayoutOrder = order
    tab.TextSize = 11

    tab.MouseButton1Click:Connect(function()
        selectPage(name)
    end)

    Tabs[name] = tab
    return tab
end

--==============================================================
-- PAGES
--==============================================================

local Dashboard = createPage("Dashboard")
local Combat = createPage("Combat")
local AutoFarm = createPage("AutoFarm")
local Premium = createPage("Premium")
local Settings = createPage("Settings")
local Misc = createPage("Misc")

createTab("Dashboard", "Dashboard", 1)
createTab("Combat", "Combat", 2)
createTab("AutoFarm", "AutoFarm", 3)
createTab("Premium", "Premium", 4)
createTab("Settings", "Settings", 5)
createTab("Misc", "Misc", 6)

--==============================================================
-- PAGE HELPERS
--==============================================================

local function pageTitle(parent, titleText, subtitleText)
    local holder = Instance.new("Frame")
    holder.Size = UDim2.new(1, -8, 0, 54)
    holder.BackgroundTransparency = 1
    holder.Parent = parent

    local title = label(
        holder,
        titleText,
        UDim2.new(1, 0, 0, 28),
        UDim2.new(),
        18,
        C.Text
    )

    title.Font = Enum.Font.GothamBold

    label(
        holder,
        subtitleText or "",
        UDim2.new(1, 0, 0, 20),
        UDim2.fromOffset(0, 29),
        10,
        C.Muted
    )

    return holder
end

local function section(parent, text)
    local s = label(
        parent,
        text,
        UDim2.new(1, -8, 0, 24),
        UDim2.new(),
        12,
        C.Cyan
    )

    s.Font = Enum.Font.GothamBold
    s.Parent = parent
    return s
end

local function infoCard(parent, titleText, valueText)
    local card = Instance.new("Frame")
    card.Size = UDim2.new(1, -8, 0, 58)
    card.BackgroundColor3 = C.Panel2
    card.BorderSizePixel = 0
    card.Parent = parent

    corner(card, 10)

    label(
        card,
        titleText,
        UDim2.new(1, -20, 0, 20),
        UDim2.fromOffset(10, 7),
        10,
        C.Muted
    )

    local value = label(
        card,
        valueText,
        UDim2.new(1, -20, 0, 24),
        UDim2.fromOffset(10, 27),
        14,
        C.Text
    )

    value.Font = Enum.Font.GothamBold

    return card, value
end

local function toggle(parent, textValue, defaultValue, callback)
    local holder = Instance.new("Frame")
    holder.Size = UDim2.new(1, -8, 0, 44)
    holder.BackgroundColor3 = C.Panel2
    holder.BorderSizePixel = 0
    holder.Parent = parent

    corner(holder, 9)

    label(
        holder,
        textValue,
        UDim2.new(1, -70, 1, 0),
        UDim2.fromOffset(12, 0),
        11,
        C.Text
    )

    local switch = Instance.new("TextButton")
    switch.Size = UDim2.fromOffset(42, 22)
    switch.Position = UDim2.new(1, -52, .5, -11)
    switch.Text = ""
    switch.BorderSizePixel = 0
    switch.AutoButtonColor = false
    switch.Parent = holder

    corner(switch, 20)

    local knob = Instance.new("Frame")
    knob.Size = UDim2.fromOffset(16, 16)
    knob.BorderSizePixel = 0
    knob.Parent = switch
    corner(knob, 20)

    local enabled = defaultValue == true

    local function render()
        if enabled then
            switch.BackgroundColor3 = C.Blue
            knob.BackgroundColor3 = C.White
            knob.Position = UDim2.new(1, -19, .5, -8)
        else
            switch.BackgroundColor3 = C.Dim
            knob.BackgroundColor3 = C.Muted
            knob.Position = UDim2.fromOffset(3, 3)
        end
    end

    render()

    switch.MouseButton1Click:Connect(function()
        enabled = not enabled
        render()

        if callback then
            callback(enabled)
        end
    end)

    return holder, function()
        return enabled
    end
end--==============================================================
-- DASHBOARD
--==============================================================

pageTitle(
    Dashboard,
    "Dashboard",
    "WindTurf MM2 / Universal control center"
)

local StatusCard, StatusValue = infoCard(
    Dashboard,
    "Status",
    "Framework loaded"
)

local PlayerCard, PlayerValue = infoCard(
    Dashboard,
    "Player",
    LocalPlayer.DisplayName
)

local FPSCard, FPSValue = infoCard(
    Dashboard,
    "FPS",
    "Calculating..."
)

local PingCard, PingValue = infoCard(
    Dashboard,
    "Ping",
    "Calculating..."
)

local SessionCard, SessionValue = infoCard(
    Dashboard,
    "Session",
    "00:00:00"
)

section(Dashboard, "MONITORING")

toggle(
    Dashboard,
    "Suspicious chat monitoring",
    CONFIG.Settings.SuspiciousChat,
    function(value)
        CONFIG.Settings.SuspiciousChat = value
    end
)

toggle(
    Dashboard,
    "Repeat message detection",
    CONFIG.Settings.RepeatMessageDetection,
    function(value)
        CONFIG.Settings.RepeatMessageDetection = value
    end
)

toggle(
    Dashboard,
    "Suspicious movement monitoring",
    CONFIG.Settings.SuspiciousMovement,
    function(value)
        CONFIG.Settings.SuspiciousMovement = value
    end
)

toggle(
    Dashboard,
    "Hacker alerts",
    CONFIG.Settings.HackerAlerts,
    function(value)
        CONFIG.Settings.HackerAlerts = value
    end
)

toggle(
    Dashboard,
    "Mini-avatar detection",
    CONFIG.Settings.MiniAvatarDetection,
    function(value)
        CONFIG.Settings.MiniAvatarDetection = value
    end
)

--==============================================================
-- COMBAT PAGE
--==============================================================

pageTitle(
    Combat,
    "Combat",
    "Role and round information"
)

section(Combat, "ROUND STATUS")

local RoleCard, RoleValue = infoCard(
    Combat,
    "Detected Role",
    "Unknown"
)

local MurdererCard, MurdererValue = infoCard(
    Combat,
    "Murderer",
    "Unknown"
)

local SheriffCard, SheriffValue = infoCard(
    Combat,
    "Sheriff",
    "Unknown"
)

local GunCard, GunValue = infoCard(
    Combat,
    "Gun",
    "Unknown"
)

section(Combat, "OPTIONS")

toggle(
    Combat,
    "Role highlighting",
    CONFIG.Settings.RoleHighlight,
    function(value)
        CONFIG.Settings.RoleHighlight = value
    end
)

toggle(
    Combat,
    "Murderer indicator",
    CONFIG.Settings.MurdererIndicator,
    function(value)
        CONFIG.Settings.MurdererIndicator = value
    end
)

toggle(
    Combat,
    "Sheriff indicator",
    CONFIG.Settings.SheriffIndicator,
    function(value)
        CONFIG.Settings.SheriffIndicator = value
    end
)

toggle(
    Combat,
    "Gun tracker",
    CONFIG.Settings.GunTracker,
    function(value)
        CONFIG.Settings.GunTracker = value
    end
)

--==============================================================
-- AUTOFARM PAGE
--==============================================================

pageTitle(
    AutoFarm,
    "AutoFarm",
    "Safe framework controls"
)

section(AutoFarm, "STATUS")

local FarmStatusCard, FarmStatusValue = infoCard(
    AutoFarm,
    "AutoFarm Status",
    "Disabled"
)

toggle(
    AutoFarm,
    "Enable AutoFarm framework",
    false,
    function(value)
        if value then
            FarmStatusValue.Text = "Framework enabled"
        else
            FarmStatusValue.Text = "Disabled"
        end
    end
)

local FarmInfo = Instance.new("TextLabel")
FarmInfo.Size = UDim2.new(1, -8, 0, 70)
FarmInfo.BackgroundColor3 = C.Panel2
FarmInfo.BorderSizePixel = 0
FarmInfo.TextColor3 = C.Muted
FarmInfo.TextSize = 10
FarmInfo.Font = Enum.Font.Gotham
FarmInfo.TextWrapped = true
FarmInfo.TextXAlignment = Enum.TextXAlignment.Left
FarmInfo.TextYAlignment = Enum.TextYAlignment.Top
FarmInfo.Text = "AutoFarm controls are provided as a framework only. Game-specific automation should only be used in experiences you own or have permission to modify."
FarmInfo.Parent = AutoFarm

corner(FarmInfo, 9)

local FarmPadding = Instance.new("UIPadding")
FarmPadding.PaddingTop = UDim.new(0, 10)
FarmPadding.PaddingBottom = UDim.new(0, 10)
FarmPadding.PaddingLeft = UDim.new(0, 10)
FarmPadding.PaddingRight = UDim.new(0, 10)
FarmPadding.Parent = FarmInfo

--==============================================================
-- PREMIUM PAGE
--==============================================================

local showAlert

pageTitle(
    Premium,
    "Premium",
    "WindTurf premium monitoring tools"
)

local PremiumStatusCard, PremiumStatusValue = infoCard(
    Premium,
    "Premium Access",
    "Checking..."
)

section(Premium, "PREMIUM MONITORING")

local premiumToggle

premiumToggle = toggle(
    Premium,
    "Suspicious target auto-lock",
    CONFIG.Settings.AutoLock,
    function(value)
        if CONFIG.Premium then
            CONFIG.Settings.AutoLock = value
        else
            CONFIG.Settings.AutoLock = false
            showAlert("Premium", "Premium access required")
        end
    end
)

toggle(
    Premium,
    "Advanced suspicious movement",
    CONFIG.Settings.SuspiciousMovement,
    function(value)
        if CONFIG.Premium then
            CONFIG.Settings.SuspiciousMovement = value
        end
    end
)

toggle(
    Premium,
    "Advanced chat detection",
    CONFIG.Settings.SuspiciousChat,
    function(value)
        if CONFIG.Premium then
            CONFIG.Settings.SuspiciousChat = value
        end
    end
)

toggle(
    Premium,
    "Repeat-message alerts",
    CONFIG.Settings.RepeatMessageDetection,
    function(value)
        if CONFIG.Premium then
            CONFIG.Settings.RepeatMessageDetection = value
        end
    end
)

toggle(
    Premium,
    "Mini-avatar detection",
    CONFIG.Settings.MiniAvatarDetection,
    function(value)
        if CONFIG.Premium then
            CONFIG.Settings.MiniAvatarDetection = value
        end
    end
)

section(Premium, "PREMIUM USERS")

local PremiumUsersText = Instance.new("TextLabel")
PremiumUsersText.Size = UDim2.new(1, -8, 0, 52)
PremiumUsersText.BackgroundColor3 = C.Panel2
PremiumUsersText.BorderSizePixel = 0
PremiumUsersText.TextColor3 = C.Text
PremiumUsersText.TextSize = 11
PremiumUsersText.Font = Enum.Font.Gotham
PremiumUsersText.TextWrapped = true
PremiumUsersText.Text = "Current premium users:\nWindTurf • lvliaqqt"
PremiumUsersText.Parent = Premium

corner(PremiumUsersText, 9)

local PremiumPadding = Instance.new("UIPadding")
PremiumPadding.PaddingTop = UDim.new(0, 8)
PremiumPadding.PaddingBottom = UDim.new(0, 8)
PremiumPadding.PaddingLeft = UDim.new(0, 10)
PremiumPadding.PaddingRight = UDim.new(0, 10)
PremiumPadding.Parent = PremiumUsersText--==============================================================
-- SETTINGS PAGE
--==============================================================

pageTitle(
    Settings,
    "Settings",
    "Customize the WindTurf interface"
)

section(Settings, "DISPLAY")

toggle(
    Settings,
    "Galaxy background",
    CONFIG.Settings.Galaxy,
    function(value)
        CONFIG.Settings.Galaxy = value
        Galaxy.Visible = value
    end
)

toggle(
    Settings,
    "Stars",
    CONFIG.Settings.Stars,
    function(value)
        CONFIG.Settings.Stars = value

        for _, object in ipairs(StarObjects) do
            object.Visible = value
        end
    end
)

toggle(
    Settings,
    "Nebula",
    CONFIG.Settings.Nebula,
    function(value)
        CONFIG.Settings.Nebula = value

        for _, object in ipairs(NebulaObjects) do
            object.Visible = value
        end
    end
)

toggle(
    Settings,
    "Animations",
    CONFIG.Settings.Animations,
    function(value)
        CONFIG.Settings.Animations = value
    end
)

toggle(
    Settings,
    "Compact mode",
    CONFIG.Settings.CompactMode,
    function(value)
        CONFIG.Settings.CompactMode = value
    end
)

section(Settings, "PERFORMANCE")

toggle(
    Settings,
    "FPS counter",
    CONFIG.Settings.FPSCounter,
    function(value)
        CONFIG.Settings.FPSCounter = value
        FPSCard.Visible = value
    end
)

toggle(
    Settings,
    "Ping display",
    CONFIG.Settings.PingDisplay,
    function(value)
        CONFIG.Settings.PingDisplay = value
        PingCard.Visible = value
    end
)

toggle(
    Settings,
    "Session timer",
    CONFIG.Settings.SessionTimer,
    function(value)
        CONFIG.Settings.SessionTimer = value
        SessionCard.Visible = value
    end
)

toggle(
    Settings,
    "Notifications",
    CONFIG.Settings.Notifications,
    function(value)
        CONFIG.Settings.Notifications = value
    end
)

section(Settings, "MOBILE")

toggle(
    Settings,
    "Mobile optimization",
    CONFIG.Settings.MobileOptimization,
    function(value)
        CONFIG.Settings.MobileOptimization = value
    end
)

toggle(
    Settings,
    "Draggable window",
    CONFIG.Settings.DraggableWindow,
    function(value)
        CONFIG.Settings.DraggableWindow = value
    end
)

toggle(
    Settings,
    "Draggable reopen button",
    CONFIG.Settings.DraggableReopen,
    function(value)
        CONFIG.Settings.DraggableReopen = value
    end
)

--==============================================================
-- MISC PAGE
--==============================================================

pageTitle(
    Misc,
    "Misc",
    "Utility and information"
)

section(Misc, "UTILITY")

local MiscStatusCard, MiscStatusValue = infoCard(
    Misc,
    "Script Version",
    CONFIG.Version
)

local UserCard, UserValue = infoCard(
    Misc,
    "Username",
    "@" .. LocalPlayer.Name
)

local AccountCard, AccountValue = infoCard(
    Misc,
    "Account Age",
    tostring(LocalPlayer.AccountAge) .. " days"
)

section(Misc, "INFORMATION")

local InfoBox = Instance.new("TextLabel")
InfoBox.Size = UDim2.new(1, -8, 0, 110)
InfoBox.BackgroundColor3 = C.Panel2
InfoBox.BorderSizePixel = 0
InfoBox.TextColor3 = C.Muted
InfoBox.TextSize = 10
InfoBox.Font = Enum.Font.Gotham
InfoBox.TextWrapped = true
InfoBox.TextXAlignment = Enum.TextXAlignment.Left
InfoBox.TextYAlignment = Enum.TextYAlignment.Top
InfoBox.Text = "WindTurf's MM2 / Universal Script\n\nUI and monitoring framework designed for Android and PC.\n\nMonitoring features are observation tools and do not modify other players."
InfoBox.Parent = Misc

corner(InfoBox, 9)

local InfoPadding = Instance.new("UIPadding")
InfoPadding.PaddingTop = UDim.new(0, 10)
InfoPadding.PaddingBottom = UDim.new(0, 10)
InfoPadding.PaddingLeft = UDim.new(0, 10)
InfoPadding.PaddingRight = UDim.new(0, 10)
InfoPadding.Parent = InfoBox

--==============================================================
-- PREMIUM ACCESS CHECK
--==============================================================

local UsernameLower = string.lower(LocalPlayer.Name)

CONFIG.Premium = CONFIG.PremiumUsers[UsernameLower] == true

if CONFIG.Premium then
    PremiumStatusValue.Text = "Premium unlocked"
    PremiumStatusValue.TextColor3 = C.Cyan
else
    PremiumStatusValue.Text = "Standard access"
    PremiumStatusValue.TextColor3 = C.Muted
end

--==============================================================
-- INITIAL PAGE
--==============================================================

selectPage("Dashboard")

--==============================================================
-- REOPEN BUTTON
--==============================================================

local ReopenButton = Instance.new("TextButton")
ReopenButton.Name = "ReopenButton"
ReopenButton.Size = UDim2.fromOffset(48, 48)
ReopenButton.Position = UDim2.new(1, -65, 1, -75)
ReopenButton.BackgroundColor3 = C.Panel
ReopenButton.BorderSizePixel = 0
ReopenButton.Text = "🌪️"
ReopenButton.TextSize = 23
ReopenButton.AutoButtonColor = false
ReopenButton.Visible = false
ReopenButton.Parent = Gui

corner(ReopenButton, 24)
stroke(ReopenButton, C.Blue, .8, 1)

ReopenButton.MouseButton1Click:Connect(function()
    Main.Visible = true
    ReopenButton.Visible = false
end)

--==============================================================
-- CLOSE BUTTON
--==============================================================

CloseButton.MouseButton1Click:Connect(function()
    Main.Visible = false
    ReopenButton.Visible = true
end)

--==============================================================
-- ALERT SYSTEM
--==============================================================

local AlertCooldowns = {}

local AlertHolder = Instance.new("Frame")
AlertHolder.Name = "AlertHolder"
AlertHolder.Size = UDim2.fromOffset(280, 300)
AlertHolder.Position = UDim2.new(1, -295, 0, 85)
AlertHolder.BackgroundTransparency = 1
AlertHolder.ZIndex = 50
AlertHolder.Parent = Gui

local AlertLayout = Instance.new("UIListLayout")
AlertLayout.Padding = UDim.new(0, 7)
AlertLayout.HorizontalAlignment = Enum.HorizontalAlignment.Right
AlertLayout.VerticalAlignment = Enum.VerticalAlignment.Top
AlertLayout.Parent = AlertHolder

showAlert = function(titleText, messageText)
    if not CONFIG.Settings.Notifications then
        return
    end

    local alert = Instance.new("Frame")
    alert.Size = UDim2.fromOffset(270, 58)
    alert.BackgroundColor3 = C.Panel
    alert.BackgroundTransparency = .05
    alert.BorderSizePixel = 0
    alert.ZIndex = 51
    alert.Parent = AlertHolder

    corner(alert, 10)
    stroke(alert, C.Blue, .7, 1)

    local title = label(
        alert,
        titleText,
        UDim2.new(1, -20, 0, 21),
        UDim2.fromOffset(10, 5),
        11,
        C.Cyan
    )

    title.Font = Enum.Font.GothamBold
    title.ZIndex = 52

    local message = label(
        alert,
        messageText,
        UDim2.new(1, -20, 0, 25),
        UDim2.fromOffset(10, 27),
        9,
        C.Text
    )

    message.TextWrapped = true
    message.ZIndex = 52

    task.delay(4, function()
        if alert and alert.Parent then
            local tween = TweenService:Create(
                alert,
                TweenInfo.new(.25),
                {
                    BackgroundTransparency = 1
                }
            )

            tween:Play()
            tween.Completed:Wait()

            if alert then
                alert:Destroy()
            end
        end
    end)
end

--==============================================================
-- SESSION / FPS TRACKING
--==============================================================

local SessionStart = os.clock()
local FrameCount = 0
local FPS = 0
local FPSTimer = os.clock()

RunService.RenderStepped:Connect(function()
    FrameCount += 1

    local now = os.clock()

    if now - FPSTimer >= 1 then
        FPS = FrameCount
        FrameCount = 0
        FPSTimer = now

        if CONFIG.Settings.FPSCounter then
            FPSValue.Text = tostring(FPS)
        end
    end
end)

task.spawn(function()
    while Gui.Parent do
        task.wait(1)

        if CONFIG.Settings.SessionTimer then
            local elapsed = math.floor(os.clock() - SessionStart)

            local hours = math.floor(elapsed / 3600)
            local minutes = math.floor((elapsed % 3600) / 60)
            local seconds = elapsed % 60

            SessionValue.Text = string.format(
                "%02d:%02d:%02d",
                hours,
                minutes,
                seconds
            )
        end
    end
end)

--==============================================================
-- PING TRACKING
--==============================================================

task.spawn(function()
    while Gui.Parent do
        task.wait(2)

        if CONFIG.Settings.PingDisplay then
            local success, ping = pcall(function()
                return Stats.Network.ServerStatsItem["Data Ping"]:GetValueString()
            end)

            if success and ping then
                PingValue.Text = tostring(ping)
            else
                PingValue.Text = "Unavailable"
            end
        end
    end
end)

--==============================================================
-- PLAYER / CHARACTER MONITORING
--==============================================================

local ChatHistory = {}
local MovementHistory = {}

local function getPlayerDisplayName(player)
    if not player then
        return "Unknown"
    end

    return player.DisplayName or player.Name
end

local function recordChat(player, message)
    if not player or not message then
        return
    end

    local userId = player.UserId

    ChatHistory[userId] = ChatHistory[userId] or {}

    table.insert(
        ChatHistory[userId],
        {
            Message = string.lower(tostring(message)),
            Time = os.clock()
        }
    )

    while #ChatHistory[userId] > 5 do
        table.remove(ChatHistory[userId], 1)
    end
end

local function detectRepeatedMessage(player, message)
    if not CONFIG.Settings.RepeatMessageDetection then
        return false
    end

    local history = ChatHistory[player.UserId]

    if not history or #history < 3 then
        return false
    end

    local target = string.lower(tostring(message))

    local count = 0

    for index = #history, 1, -1 do
        if history[index].Message == target then
            count += 1
        else
            break
        end
    end

    return count >= 3
end

--==============================================================
-- SUSPICIOUS CHAT MONITOR
--==============================================================

local SuspiciousWords = {
    "exploit",
    "executor",
    "script",
    "hack",
    "hacker",
    "cheat",
    "dupe",
    "scam",
    "steal"
}

local function containsSuspiciousText(message)
    local text = string.lower(tostring(message))

    for _, word in ipairs(SuspiciousWords) do
        if string.find(text, word, 1, true) then
            return true, word
        end
    end

    return false, nil
end

local function monitorChat(player, message)
    if not CONFIG.Settings.SuspiciousChat
        and not CONFIG.Settings.RepeatMessageDetection then
        return
    end

    local repeated = detectRepeatedMessage(player, message)

    local suspicious, keyword = containsSuspiciousText(message)

    recordChat(player, message)

    if repeated and CONFIG.Settings.HackerAlerts then
        showAlert(
            "Repeat Message",
            getPlayerDisplayName(player) .. " repeated a message 3+ times"
        )
    elseif suspicious and CONFIG.Settings.HackerAlerts then
        showAlert(
            "Suspicious Chat",
            getPlayerDisplayName(player) .. " mentioned: " .. keyword
        )
    end
end

--==============================================================
-- CHAT CONNECTIONS
--==============================================================

local function connectPlayerChat(player)
    if not player then
        return
    end

    player.Chatted:Connect(function(message)
        monitorChat(player, message)
    end)
end

for _, player in ipairs(Players:GetPlayers()) do
    connectPlayerChat(player)
end

Players.PlayerAdded:Connect(function(player)
    connectPlayerChat(player)

    if CONFIG.Settings.Notifications then
        showAlert(
            "Player Joined",
            getPlayerDisplayName(player) .. " joined the server"
        )
    end
end)

Players.PlayerRemoving:Connect(function(player)
    ChatHistory[player.UserId] = nil
    MovementHistory[player.UserId] = nil
end)

local function showPlayerAlert(key, titleText, messageText, cooldown)
    local now = os.clock()
    local last = AlertCooldowns[key] or 0

    if now - last < (cooldown or 5) then
        return
    end

    AlertCooldowns[key] = now
    showAlert(titleText, messageText)
end

--==============================================================
-- SUSPICIOUS MOVEMENT MONITOR
--==============================================================

local function monitorMovement(player)
    if not CONFIG.Settings.SuspiciousMovement then
        return
    end

    if not player.Character then
        return
    end

    local root = player.Character:FindFirstChild("HumanoidRootPart")

    if not root then
        return
    end

    local position = root.Position
    local previous = MovementHistory[player.UserId]

    MovementHistory[player.UserId] = {
        Position = position,
        Time = os.clock()
    }

    if not previous then
        return
    end

    local elapsed = os.clock() - previous.Time

    if elapsed <= 0 then
        return
    end

    local distance = (position - previous.Position).Magnitude
    local speed = distance / elapsed

    -- Observation only.
    -- This does not modify or control the player.
    if speed > 100 and CONFIG.Settings.HackerAlerts then
        showPlayerAlert(
            "movement_" .. player.UserId,
            "Movement Alert",
            getPlayerDisplayName(player) .. " showed unusual movement",
            5
        )
    end
end

task.spawn(function()
    while Gui.Parent do
        task.wait(.5)

        if CONFIG.Settings.SuspiciousMovement then
            for _, player in ipairs(Players:GetPlayers()) do
                if player ~= LocalPlayer then
                    pcall(function()
                        monitorMovement(player)
                    end)
                end
            end
        end
    end
end)

--==============================================================
-- MINI-AVATAR DETECTION
--==============================================================

local function checkMiniAvatar(player)
    if not CONFIG.Settings.MiniAvatarDetection then
        return
    end

    if not player.Character then
        return
    end

    local humanoid = player.Character:FindFirstChildOfClass("Humanoid")

    if not humanoid then
        return
    end

    local scaleNames = {
        "BodyDepthScale",
        "BodyHeightScale",
        "BodyWidthScale",
        "HeadScale"
    }

    local unusuallySmall = false

    for _, scaleName in ipairs(scaleNames) do
        local scale = humanoid:FindFirstChild(scaleName)

        if scale and scale:IsA("NumberValue") then
            if scale.Value < .5 then
                unusuallySmall = true
                break
            end
        end
    end

    if unusuallySmall and CONFIG.Settings.HackerAlerts then
        showPlayerAlert(
            "mini_" .. player.UserId,
            "Mini Avatar",
            getPlayerDisplayName(player) .. " has an unusually small avatar",
            8
        )
    end
end

task.spawn(function()
    while Gui.Parent do
        task.wait(3)

        if CONFIG.Settings.MiniAvatarDetection then
            for _, player in ipairs(Players:GetPlayers()) do
                if player ~= LocalPlayer then
                    pcall(function()
                        checkMiniAvatar(player)
                    end)
                end
            end
        end
    end
end)

--==============================================================
-- BASIC ROLE OBSERVATION
--==============================================================

local function findStringValue(character, names)
    if not character then
        return nil
    end

    for _, name in ipairs(names) do
        local object = character:FindFirstChild(name)

        if object and object:IsA("StringValue") then
            return object.Value
        end
    end

    return nil
end

local function updateRoleInformation()
    local detectedRole = findStringValue(
        LocalPlayer.Character,
        {"Role", "PlayerRole"}
    )

    if detectedRole and detectedRole ~= "" then
        RoleValue.Text = detectedRole
    else
        RoleValue.Text = "Unknown"
    end
end

local function updatePlayerRoleCards()
    MurdererValue.Text = "Unknown"
    SheriffValue.Text = "Unknown"
    GunValue.Text = "Unknown"

    for _, player in ipairs(Players:GetPlayers()) do
        if player.Character then
            local role = findStringValue(
                player.Character,
                {"Role", "PlayerRole"}
            )

            if role then
                local lowered = string.lower(role)

                if lowered == "murderer" then
                    MurdererValue.Text = getPlayerDisplayName(player)
                elseif lowered == "sheriff" then
                    SheriffValue.Text = getPlayerDisplayName(player)
                end
            end

            local backpack = player:FindFirstChild("Backpack")

            if backpack and backpack:FindFirstChild("Gun") then
                GunValue.Text = getPlayerDisplayName(player)
            end

            if player.Character:FindFirstChild("Gun") then
                GunValue.Text = getPlayerDisplayName(player)
            end
        end
    end
end

task.spawn(function()
    while Gui.Parent do
        task.wait(2)

        pcall(updateRoleInformation)
        pcall(updatePlayerRoleCards)
    end
end)

--==============================================================
-- MOBILE SCALE
--==============================================================

local function updateScale()
    if not CONFIG.Settings.MobileOptimization then
        MainScale.Scale = 1
        return
    end

    local camera = workspace.CurrentCamera

    if not camera then
        return
    end

    local viewport = camera.ViewportSize

    if viewport.X <= 700 then
        MainScale.Scale = .86
    elseif viewport.X <= 900 then
        MainScale.Scale = .94
    else
        MainScale.Scale = 1
    end
end

updateScale()

if workspace.CurrentCamera then
    workspace.CurrentCamera:GetPropertyChangedSignal("ViewportSize"):Connect(
        updateScale
    )
end

--==============================================================
-- REOPEN BUTTON DRAGGING
--==============================================================

local reopenDragging = false
local reopenDragStart
local reopenStartPosition

ReopenButton.InputBegan:Connect(function(input)
    if not CONFIG.Settings.DraggableReopen then
        return
    end

    if input.UserInputType == Enum.UserInputType.MouseButton1
        or input.UserInputType == Enum.UserInputType.Touch then

        reopenDragging = true
        reopenDragStart = input.Position
        reopenStartPosition = ReopenButton.Position
    end
end)

UserInputService.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1
        or input.UserInputType == Enum.UserInputType.Touch then

        reopenDragging = false
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if not reopenDragging then
        return
    end

    if input.UserInputType ~= Enum.UserInputType.MouseMovement
        and input.UserInputType ~= Enum.UserInputType.Touch then
        return
    end

    local delta = input.Position - reopenDragStart

    ReopenButton.Position = UDim2.new(
        reopenStartPosition.X.Scale,
        reopenStartPosition.X.Offset + delta.X,
        reopenStartPosition.Y.Scale,
        reopenStartPosition.Y.Offset + delta.Y
    )
end)

--==============================================================
-- ANIMATION
--==============================================================

task.spawn(function()
    while Gui.Parent do
        task.wait(.05)

        if CONFIG.Settings.Animations
            and CONFIG.Settings.Galaxy
            and CONFIG.Settings.Nebula then

            for _, object in ipairs(NebulaObjects) do
                object.Rotation = (object.Rotation + .08) % 360
            end
        end
    end
end)

--==============================================================
-- CHARACTER RESPAWN SUPPORT
--==============================================================

LocalPlayer.CharacterAdded:Connect(function()
    task.wait(1)

    pcall(updateRoleInformation)

    if CONFIG.Settings.Notifications then
        showAlert(
            "Character",
            "Character loaded successfully"
        )
    end
end)

--==============================================================
-- FINAL STATUS
--==============================================================

StatusValue.Text = "Ready"
StatusValue.TextColor3 = C.Cyan

showAlert(
    "WindTurf",
    "MM2 / Universal framework loaded"
)

--==============================================================
-- FINAL SAFETY CLEANUP
--==============================================================

Gui.AncestryChanged:Connect(function(_, parent)
    if parent == nil then
        return
    end
end)

--==============================================================
-- SCRIPT READY
--==============================================================

print("WindTurf's MM2 / Universal Script V" .. CONFIG.Version .. " loaded.")