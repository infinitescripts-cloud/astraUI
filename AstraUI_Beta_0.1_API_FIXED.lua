--[[
    AstraUI Beta 0.1
    Liquid Glass Roblox UI Framework
    Standalone Luau library
    ------------------------------------------------------------
    Goals:
      * Liquid-glass visual language
      * Custom spring / tween motion engine
      * Mobile + desktop responsive layouts
      * Runtime themes
      * Searchable navigation
      * Notifications
      * Config serialization
      * Reusable component objects
      * No dependency on Rayfield, WindUI, or other UI libraries
]]

local AstraUI = {}

--// Services
local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local TextService = game:GetService("TextService")
local GuiService = game:GetService("GuiService")
local HttpService = game:GetService("HttpService")

local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")

--// Environment
AstraUI.Version = "0.1.0-beta"
AstraUI.Name = "AstraUI"
AstraUI.Windows = {}
AstraUI.Components = {}
AstraUI.Themes = {}
AstraUI.Motion = {}
AstraUI.Utility = {}
AstraUI.State = {
    ReducedMotion = false,
    Quality = 3,
    SearchText = "",
}

--// Constants
local ZERO = Vector2.zero
local FULL = UDim2.fromScale(1, 1)
local TRANSPARENT = 1

local function clamp(value, minimum, maximum)
    return math.max(minimum, math.min(maximum, value))
end

local function lerp(a, b, t)
    return a + (b - a) * t
end

local function safeCall(callback, ...)
    if typeof(callback) ~= "function" then
        return
    end
    local ok, result = pcall(callback, ...)
    if not ok then
        warn("[AstraUI] Callback error:", result)
    end
end

local function new(className, properties, parent)
    local object = Instance.new(className)
    for key, value in pairs(properties or {}) do
        local ok = pcall(function()
            object[key] = value
        end)
        if not ok then
            warn("[AstraUI] Invalid property:", className, key)
        end
    end
    object.Parent = parent
    return object
end

local function corner(parent, radius)
    return new("UICorner", {
        CornerRadius = UDim.new(0, radius or 12),
    }, parent)
end

local function stroke(parent, color, transparency, thickness)
    return new("UIStroke", {
        Color = color or Color3.new(1, 1, 1),
        Transparency = transparency or 0,
        Thickness = thickness or 1,
        ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
    }, parent)
end

local function padding(parent, left, top, right, bottom)
    return new("UIPadding", {
        PaddingLeft = UDim.new(0, left or 0),
        PaddingTop = UDim.new(0, top or 0),
        PaddingRight = UDim.new(0, right or 0),
        PaddingBottom = UDim.new(0, bottom or 0),
    }, parent)
end

local function list(parent, direction, gap)
    return new("UIListLayout", {
        FillDirection = direction or Enum.FillDirection.Vertical,
        Padding = UDim.new(0, gap or 0),
        SortOrder = Enum.SortOrder.LayoutOrder,
    }, parent)
end

--// Theme engine
AstraUI.Themes.Dark = {
    Background = Color3.fromRGB(10, 12, 18),
    Surface = Color3.fromRGB(20, 23, 32),
    Surface2 = Color3.fromRGB(27, 31, 42),
    Elevated = Color3.fromRGB(34, 39, 52),
    Text = Color3.fromRGB(245, 247, 255),
    Muted = Color3.fromRGB(158, 165, 181),
    Border = Color3.fromRGB(255, 255, 255),
    Accent = Color3.fromRGB(128, 160, 255),
    Accent2 = Color3.fromRGB(177, 132, 255),
    Success = Color3.fromRGB(92, 215, 146),
    Warning = Color3.fromRGB(245, 188, 82),
    Danger = Color3.fromRGB(244, 94, 111),
    GlassTransparency = 0.18,
    CardTransparency = 0.10,
    BorderTransparency = 0.82,
    ShadowTransparency = 0.55,
}

AstraUI.Themes.Light = {
    Background = Color3.fromRGB(232, 236, 245),
    Surface = Color3.fromRGB(250, 252, 255),
    Surface2 = Color3.fromRGB(241, 244, 250),
    Elevated = Color3.fromRGB(255, 255, 255),
    Text = Color3.fromRGB(28, 32, 43),
    Muted = Color3.fromRGB(102, 108, 122),
    Border = Color3.fromRGB(255, 255, 255),
    Accent = Color3.fromRGB(86, 112, 232),
    Accent2 = Color3.fromRGB(147, 91, 225),
    Success = Color3.fromRGB(48, 166, 101),
    Warning = Color3.fromRGB(211, 145, 32),
    Danger = Color3.fromRGB(212, 60, 79),
    GlassTransparency = 0.28,
    CardTransparency = 0.18,
    BorderTransparency = 0.65,
    ShadowTransparency = 0.72,
}

AstraUI.Themes.Midnight = {
    Background = Color3.fromRGB(5, 7, 14),
    Surface = Color3.fromRGB(13, 16, 28),
    Surface2 = Color3.fromRGB(19, 23, 38),
    Elevated = Color3.fromRGB(26, 31, 50),
    Text = Color3.fromRGB(239, 242, 255),
    Muted = Color3.fromRGB(137, 146, 170),
    Border = Color3.fromRGB(191, 210, 255),
    Accent = Color3.fromRGB(98, 152, 255),
    Accent2 = Color3.fromRGB(156, 98, 255),
    Success = Color3.fromRGB(74, 219, 145),
    Warning = Color3.fromRGB(248, 186, 70),
    Danger = Color3.fromRGB(244, 82, 105),
    GlassTransparency = 0.12,
    CardTransparency = 0.07,
    BorderTransparency = 0.84,
    ShadowTransparency = 0.48,
}

AstraUI.Themes.Amber = {
    Background = Color3.fromRGB(14, 12, 9),
    Surface = Color3.fromRGB(27, 22, 14),
    Surface2 = Color3.fromRGB(38, 30, 18),
    Elevated = Color3.fromRGB(49, 38, 20),
    Text = Color3.fromRGB(255, 247, 229),
    Muted = Color3.fromRGB(178, 157, 123),
    Border = Color3.fromRGB(255, 213, 137),
    Accent = Color3.fromRGB(255, 176, 67),
    Accent2 = Color3.fromRGB(255, 121, 76),
    Success = Color3.fromRGB(105, 213, 139),
    Warning = Color3.fromRGB(255, 184, 67),
    Danger = Color3.fromRGB(239, 87, 82),
    GlassTransparency = 0.15,
    CardTransparency = 0.09,
    BorderTransparency = 0.80,
    ShadowTransparency = 0.52,
}

AstraUI.Theme = AstraUI.Themes.Dark

function AstraUI:RegisterTheme(name, theme)
    assert(type(name) == "string", "Theme name must be a string")
    assert(type(theme) == "table", "Theme must be a table")
    local base = {}
    for key, value in pairs(AstraUI.Theme) do
        base[key] = value
    end
    for key, value in pairs(theme) do
        base[key] = value
    end
    AstraUI.Themes[name] = base
    return base
end

function AstraUI:SetTheme(name)
    local theme = AstraUI.Themes[name]
    if not theme then
        warn("[AstraUI] Unknown theme:", name)
        return false
    end
    AstraUI.Theme = theme
    for _, window in ipairs(AstraUI.Windows) do
        window:RefreshTheme()
    end
    return true
end

function AstraUI:SetAccent(color)
    assert(typeof(color) == "Color3", "Accent must be a Color3")
    AstraUI.Theme.Accent = color
    for _, window in ipairs(AstraUI.Windows) do
        window:RefreshTheme()
    end
end

--// Motion engine
AstraUI.Motion.Presets = {
    Liquid = {Frequency = 5.0, Damping = 0.72, Mass = 1},
    Smooth = {Frequency = 3.4, Damping = 0.84, Mass = 1},
    Snappy = {Frequency = 7.0, Damping = 0.70, Mass = 0.8},
    Gentle = {Frequency = 2.4, Damping = 0.90, Mass = 1.2},
}

AstraUI.Motion.Preset = "Liquid"
AstraUI.Motion._springs = {}

function AstraUI.Motion:SetPreset(name)
    if self.Presets[name] then
        self.Preset = name
        return true
    end
    return false
end

function AstraUI.Motion:Cancel(object, property)
    local key = tostring(object) .. ":" .. tostring(property)
    self._springs[key] = nil
end

function AstraUI.Motion:Spring(object, property, target, options)
    options = options or {}
    local preset = self.Presets[options.Preset or self.Preset] or self.Presets.Liquid
    local frequency = options.Frequency or preset.Frequency
    local damping = options.Damping or preset.Damping
    local mass = options.Mass or preset.Mass
    local key = tostring(object) .. ":" .. tostring(property)

    if AstraUI.State.ReducedMotion then
        pcall(function() object[property] = target end)
        return
    end

    local current
    local ok = pcall(function()
        current = object[property]
    end)
    if not ok then
        return
    end

    self._springs[key] = {
        Object = object,
        Property = property,
        Value = current,
        Velocity = options.Velocity or 0,
        Target = target,
        Frequency = frequency,
        Damping = damping,
        Mass = mass,
    }
end

function AstraUI.Motion:Tween(object, properties, duration, easing, direction)
    if AstraUI.State.ReducedMotion then
        for property, value in pairs(properties) do
            pcall(function() object[property] = value end)
        end
        return nil
    end
    local info = TweenInfo.new(
        duration or 0.25,
        easing or Enum.EasingStyle.Quint,
        direction or Enum.EasingDirection.Out
    )
    local tween = TweenService:Create(object, info, properties)
    tween:Play()
    return tween
end

function AstraUI.Motion:Pulse(object, scale, duration)
    scale = scale or 1.035
    duration = duration or 0.12
    local original = object.Size
    local target = UDim2.new(
        original.X.Scale * scale, original.X.Offset * scale,
        original.Y.Scale * scale, original.Y.Offset * scale
    )
    self:Tween(object, {Size = target}, duration, Enum.EasingStyle.Quad)
    task.delay(duration, function()
        if object.Parent then
            self:Tween(object, {Size = original}, duration, Enum.EasingStyle.Back)
        end
    end)
end

RunService.RenderStepped:Connect(function(dt)
    for key, spring in pairs(AstraUI.Motion._springs) do
        if not spring.Object or not spring.Object.Parent then
            AstraUI.Motion._springs[key] = nil
        else
            local displacement
            local current = spring.Value
            local target = spring.Target

            if typeof(current) == "number" and typeof(target) == "number" then
                displacement = target - current
                local stiffness = (spring.Frequency * spring.Frequency) * 4
                local dampingForce = spring.Damping * spring.Frequency * 4
                local acceleration = (displacement * stiffness - spring.Velocity * dampingForce) / spring.Mass
                spring.Velocity += acceleration * dt
                spring.Value += spring.Velocity * dt
                if math.abs(displacement) < 0.001 and math.abs(spring.Velocity) < 0.001 then
                    spring.Value = target
                    spring.Velocity = 0
                    pcall(function() spring.Object[spring.Property] = target end)
                    AstraUI.Motion._springs[key] = nil
                else
                    pcall(function() spring.Object[spring.Property] = spring.Value end)
                end
            else
                -- For Roblox datatypes we use a stable exponential interpolation.
                local alpha = 1 - math.exp(-spring.Frequency * 7 * dt)
                local nextValue = current:Lerp(target, alpha)
                spring.Value = nextValue
                pcall(function() spring.Object[spring.Property] = nextValue end)
                if (nextValue.Position - target.Position).Magnitude < 0.05 then
                    spring.Value = target
                    pcall(function() spring.Object[spring.Property] = target end)
                    AstraUI.Motion._springs[key] = nil
                end
            end
        end
    end
end)

--// Utility helpers
function AstraUI.Utility:Round(value, decimals)
    local multiplier = 10 ^ (decimals or 0)
    return math.floor(value * multiplier + 0.5) / multiplier
end

function AstraUI.Utility:FormatNumber(value)
    if math.abs(value) >= 1000000000 then
        return string.format("%.1fb", value / 1000000000)
    elseif math.abs(value) >= 1000000 then
        return string.format("%.1fm", value / 1000000)
    elseif math.abs(value) >= 1000 then
        return string.format("%.1fk", value / 1000)
    end
    return tostring(value)
end

function AstraUI.Utility:ClampColor(color)
    return Color3.new(
        clamp(color.R, 0, 1),
        clamp(color.G, 0, 1),
        clamp(color.B, 0, 1)
    )
end

function AstraUI.Utility:Contrast(color)
    local luminance = color.R * 0.2126 + color.G * 0.7152 + color.B * 0.0722
    return luminance > 0.55 and Color3.new(0.04, 0.05, 0.08) or Color3.new(1, 1, 1)
end

function AstraUI.Utility:Encode(data)
    local ok, result = pcall(function()
        return HttpService:JSONEncode(data)
    end)
    return ok and result or nil
end

function AstraUI.Utility:Decode(data)
    local ok, result = pcall(function()
        return HttpService:JSONDecode(data)
    end)
    return ok and result or nil
end

function AstraUI.Utility:GetViewport()
    local camera = workspace.CurrentCamera
    return camera and camera.ViewportSize or Vector2.new(800, 600)
end

function AstraUI.Utility:IsMobile()
    local viewport = self:GetViewport()
    return UserInputService.TouchEnabled and viewport.X < 850
end

--// Component base
local Component = {}
Component.__index = Component

function Component:_new(window, kind, options)
    local self = setmetatable({}, Component)
    self.Window = window
    self.Kind = kind
    self.Options = options or {}
    self.Destroyed = false
    self.Connections = {}
    self.Children = {}
    self.Id = self.Options.Id or (kind .. "_" .. tostring(math.random(10000, 99999)))
    table.insert(window.Components, self)
    AstraUI.Components[self.Id] = self
    return self
end

function Component:Connect(signal, callback)
    if self.Destroyed then return nil end
    local connection = signal:Connect(function(...)
        safeCall(callback, ...)
    end)
    table.insert(self.Connections, connection)
    return connection
end

function Component:AddChild(child)
    if child then
        table.insert(self.Children, child)
    end
    return child
end

function Component:SetVisible(state)
    state = state == true
    if self.Root then
        self.Root.Visible = state
    end
    return self
end

function Component:IsVisible()
    return self.Root and self.Root.Visible or false
end

function Component:SetDisabled(state)
    self.Disabled = state == true
    if self.Root then
        self.Root.Active = not self.Disabled
    end
    return self
end

function Component:SetParent(parent)
    if self.Root then
        self.Root.Parent = parent
    end
    return self
end

function Component:Destroy()
    if self.Destroyed then return end
    self.Destroyed = true
    for _, connection in ipairs(self.Connections) do
        pcall(function() connection:Disconnect() end)
    end
    self.Connections = {}
    for _, child in ipairs(self.Children) do
        pcall(function() child:Destroy() end)
    end
    if self.Root then
        self.Root:Destroy()
    end
    AstraUI.Components[self.Id] = nil
end

--// Glass decoration
local function applyGlass(root, theme, options)
    options = options or {}
    root.BackgroundColor3 = options.Color or theme.Surface
    root.BackgroundTransparency = options.Transparency or theme.GlassTransparency
    corner(root, options.Radius or 14)

    local border = stroke(
        root,
        options.BorderColor or theme.Border,
        options.BorderTransparency or theme.BorderTransparency,
        options.BorderThickness or 1
    )

    local highlight = new("Frame", {
        Name = "GlassHighlight",
        AnchorPoint = Vector2.new(0.5, 0),
        Position = UDim2.fromScale(0.5, 0),
        Size = UDim2.new(0.78, 0, 0, 1),
        BackgroundColor3 = Color3.new(1, 1, 1),
        BackgroundTransparency = options.HighlightTransparency or 0.72,
        BorderSizePixel = 0,
    }, root)
    corner(highlight, 1)

    local gradient = new("UIGradient", {
        Rotation = options.HighlightRotation or 0,
        Transparency = NumberSequence.new({
            NumberSequenceKeypoint.new(0, 1),
            NumberSequenceKeypoint.new(0.45, 0.25),
            NumberSequenceKeypoint.new(0.55, 0.25),
            NumberSequenceKeypoint.new(1, 1),
        }),
    }, highlight)

    if options.Shadow ~= false then
        local shadow = new("ImageLabel", {
            Name = "GlassShadow",
            AnchorPoint = Vector2.new(0.5, 0.5),
            Position = UDim2.fromScale(0.5, 0.5),
            Size = UDim2.new(1, 28, 1, 28),
            BackgroundTransparency = 1,
            Image = "rbxassetid://1316045217",
            ImageColor3 = Color3.new(0, 0, 0),
            ImageTransparency = theme.ShadowTransparency,
            ZIndex = math.max(0, root.ZIndex - 1),
        }, root)
    end

    return border, highlight, gradient
end

local function makeText(parent, text, size, color, font, transparency)
    return new("TextLabel", {
        BackgroundTransparency = 1,
        Text = text or "",
        TextColor3 = color,
        TextSize = size or 14,
        Font = font or Enum.Font.Gotham,
        TextTransparency = transparency or 0,
        TextXAlignment = Enum.TextXAlignment.Left,
        TextYAlignment = Enum.TextYAlignment.Center,
        Size = UDim2.new(1, 0, 1, 0),
    }, parent)
end

--// Notification manager
AstraUI.Notifications = {
    Holder = nil,
    Active = {},
}

function AstraUI.Notifications:_ensure()
    if self.Holder and self.Holder.Parent then
        return
    end
    local gui = new("ScreenGui", {
        Name = "AstraUI_Notifications",
        ResetOnSpawn = false,
        IgnoreGuiInset = true,
        ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
    }, PlayerGui)

    self.Holder = new("Frame", {
        BackgroundTransparency = 1,
        AnchorPoint = Vector2.new(1, 1),
        Position = UDim2.new(1, -18, 1, -18),
        Size = UDim2.new(0, 330, 1, -36),
    }, gui)
    list(self.Holder, Enum.FillDirection.Vertical, 10)
    self.Holder.VerticalAlignment = Enum.VerticalAlignment.Bottom
    self.Holder.HorizontalAlignment = Enum.HorizontalAlignment.Right
end

function AstraUI:Notify(options)
    options = type(options) == "table" and options or {Title = tostring(options)}
    AstraUI.Notifications:_ensure()

    local theme = AstraUI.Theme
    local item = new("Frame", {
        BackgroundColor3 = theme.Surface,
        BackgroundTransparency = theme.CardTransparency,
        BorderSizePixel = 0,
        Size = UDim2.new(1, 0, 0, 72),
        ClipsDescendants = true,
    }, AstraUI.Notifications.Holder)
    applyGlass(item, theme, {Radius = 16, Transparency = theme.CardTransparency})

    local accent = new("Frame", {
        BackgroundColor3 = options.Color or theme.Accent,
        BorderSizePixel = 0,
        Size = UDim2.new(0, 3, 1, -20),
        Position = UDim2.new(0, 9, 0, 10),
    }, item)
    corner(accent, 2)

    local title = new("TextLabel", {
        BackgroundTransparency = 1,
        Position = UDim2.new(0, 25, 0, 10),
        Size = UDim2.new(1, -42, 0, 22),
        Text = options.Title or "AstraUI",
        TextColor3 = theme.Text,
        TextSize = 14,
        Font = Enum.Font.GothamBold,
        TextXAlignment = Enum.TextXAlignment.Left,
    }, item)

    local content = new("TextLabel", {
        BackgroundTransparency = 1,
        Position = UDim2.new(0, 25, 0, 32),
        Size = UDim2.new(1, -42, 0, 28),
        Text = options.Content or options.Description or "",
        TextColor3 = theme.Muted,
        TextSize = 12,
        Font = Enum.Font.Gotham,
        TextWrapped = true,
        TextXAlignment = Enum.TextXAlignment.Left,
    }, item)

    item.Position = UDim2.new(1, 40, 0, 0)
    AstraUI.Motion:Tween(item, {Position = UDim2.new(0, 0, 0, 0)}, 0.42, Enum.EasingStyle.Back)

    local duration = options.Duration or 4
    task.delay(duration, function()
        if item.Parent then
            local tween = AstraUI.Motion:Tween(
                item,
                {Position = UDim2.new(1, 40, 0, 0), BackgroundTransparency = 1},
                0.28,
                Enum.EasingStyle.Quint
            )
            if tween then tween.Completed:Wait() end
            if item.Parent then item:Destroy() end
        end
    end)

    return item
end

--// Icon system
AstraUI.Icons = {
    home = "rbxassetid://3926305904",
    settings = "rbxassetid://3926305904",
    search = "rbxassetid://3926305904",
    menu = "rbxassetid://3926305904",
    chevron = "rbxassetid://3926305904",
    check = "rbxassetid://3926305904",
    x = "rbxassetid://3926305904",
    info = "rbxassetid://3926305904",
    alert = "rbxassetid://3926305904",
    plus = "rbxassetid://3926305904",
    minus = "rbxassetid://3926305904",
    play = "rbxassetid://3926305904",
    pause = "rbxassetid://3926305904",
    refresh = "rbxassetid://3926305904",
    user = "rbxassetid://3926305904",
    eye = "rbxassetid://3926305904",
    palette = "rbxassetid://3926305904",
    sliders = "rbxassetid://3926305904",
    keyboard = "rbxassetid://3926305904",
}

function AstraUI:RegisterIcon(name, image)
    assert(type(name) == "string", "Icon name must be a string")
    assert(type(image) == "string", "Icon image must be a string")
    self.Icons[name] = image
end

function AstraUI:GetIcon(name)
    return self.Icons[name]
end

--// Window class
local Window = {}
Window.__index = Window

function Window:_isCompact()
    local viewport = AstraUI.Utility:GetViewport()
    return UserInputService.TouchEnabled and viewport.X < 760
end

function Window:_makeGui()
    local gui = new("ScreenGui", {
        Name = "AstraUI_" .. self.Id,
        ResetOnSpawn = false,
        IgnoreGuiInset = true,
        ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
        DisplayOrder = self.Options.DisplayOrder or 20,
    }, PlayerGui)
    self.Gui = gui
    return gui
end

function Window:_makeRoot()
    local theme = AstraUI.Theme
    local gui = self.Gui

    local root = new("Frame", {
        Name = "Window",
        AnchorPoint = Vector2.new(0.5, 0.5),
        Position = UDim2.fromScale(0.5, 0.5),
        Size = self.Options.Size or UDim2.fromOffset(620, 450),
        BackgroundColor3 = theme.Surface,
        BackgroundTransparency = theme.GlassTransparency,
        BorderSizePixel = 0,
        ClipsDescendants = true,
        Active = true,
    }, gui)

    applyGlass(root, theme, {
        Radius = self.Options.Radius or 20,
        Transparency = theme.GlassTransparency,
        HighlightTransparency = 0.78,
    })

    self.Root = root
    return root
end

function Window:_makeHeader()
    local theme = AstraUI.Theme

    local header = new("Frame", {
        Name = "Header",
        BackgroundTransparency = 1,
        Size = UDim2.new(1, -24, 0, 62),
        Position = UDim2.new(0, 12, 0, 8),
    }, self.Root)

    local title = makeText(header, self.Options.Title or "AstraUI", 17, theme.Text, Enum.Font.GothamBold)
    title.Size = UDim2.new(1, -150, 0, 26)
    title.Position = UDim2.new(0, 12, 0, 6)

    local subtitle = makeText(
        header,
        self.Options.Subtitle or "Liquid Glass",
        11,
        theme.Muted,
        Enum.Font.Gotham
    )
    subtitle.Size = UDim2.new(1, -150, 0, 18)
    subtitle.Position = UDim2.new(0, 12, 0, 32)

    self.TitleLabel = title
    self.SubtitleLabel = subtitle

    local close = new("TextButton", {
        Name = "Close",
        AnchorPoint = Vector2.new(1, 0),
        Position = UDim2.new(1, -6, 0, 8),
        Size = UDim2.fromOffset(36, 36),
        BackgroundColor3 = theme.Elevated,
        BackgroundTransparency = theme.CardTransparency,
        Text = "×",
        TextColor3 = theme.Text,
        TextSize = 20,
        Font = Enum.Font.GothamMedium,
        AutoButtonColor = false,
    }, header)
    corner(close, 12)
    stroke(close, theme.Border, 0.88)

    self:Connect(close.MouseButton1Click, function()
        self:Close()
    end)

    local minimize = new("TextButton", {
        Name = "Minimize",
        AnchorPoint = Vector2.new(1, 0),
        Position = UDim2.new(1, -48, 0, 8),
        Size = UDim2.fromOffset(36, 36),
        BackgroundColor3 = theme.Elevated,
        BackgroundTransparency = theme.CardTransparency,
        Text = "−",
        TextColor3 = theme.Text,
        TextSize = 20,
        Font = Enum.Font.GothamMedium,
        AutoButtonColor = false,
    }, header)
    corner(minimize, 12)
    stroke(minimize, theme.Border, 0.88)

    self:Connect(minimize.MouseButton1Click, function()
        self:ToggleMinimize()
    end)

    self.Header = header
end

function Window:_makeBody()
    local theme = AstraUI.Theme

    local body = new("Frame", {
        Name = "Body",
        BackgroundTransparency = 1,
        Position = UDim2.new(0, 12, 0, 76),
        Size = UDim2.new(1, -24, 1, -88),
    }, self.Root)

    local sidebar = new("ScrollingFrame", {
        Name = "Sidebar",
        BackgroundColor3 = theme.Surface2,
        BackgroundTransparency = theme.CardTransparency,
        BorderSizePixel = 0,
        Size = UDim2.new(0, 156, 1, 0),
        CanvasSize = UDim2.new(),
        AutomaticCanvasSize = Enum.AutomaticSize.Y,
        ScrollBarThickness = 2,
        ScrollBarImageTransparency = 0.65,
        ScrollingDirection = Enum.ScrollingDirection.Y,
    }, body)
    corner(sidebar, 15)
    stroke(sidebar, theme.Border, theme.BorderTransparency)

    padding(sidebar, 8, 8, 8, 8)
    list(sidebar, Enum.FillDirection.Vertical, 5)

    local content = new("Frame", {
        Name = "Content",
        BackgroundTransparency = 1,
        Position = UDim2.new(0, 168, 0, 0),
        Size = UDim2.new(1, -168, 1, 0),
        ClipsDescendants = true,
    }, body)

    self.Body = body
    self.Sidebar = sidebar
    self.Content = content

    self:_updateResponsive()
end

function Window:_updateResponsive()
    if not self.Root then return end

    local compact = self:_isCompact()
    self.Compact = compact

    if compact then
        self.Root.Size = self.Options.MobileSize or UDim2.new(1, -18, 1, -30)
        self.Sidebar.Size = UDim2.new(0, 112, 1, 0)
        self.Content.Position = UDim2.new(0, 122, 0, 0)
        self.Content.Size = UDim2.new(1, -122, 1, 0)
    else
        self.Root.Size = self.Options.Size or UDim2.fromOffset(620, 450)
        self.Sidebar.Size = UDim2.new(0, 156, 1, 0)
        self.Content.Position = UDim2.new(0, 168, 0, 0)
        self.Content.Size = UDim2.new(1, -168, 1, 0)
    end
end

function Window:_bindDragging()
    local header = self.Header
    local dragging = false
    local dragStart
    local startPosition

    self:Connect(header.InputBegan, function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1
            or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragStart = input.Position
            startPosition = self.Root.Position
        end
    end)

    self:Connect(UserInputService.InputChanged, function(input)
        if not dragging then return end
        if input.UserInputType ~= Enum.UserInputType.MouseMovement
            and input.UserInputType ~= Enum.UserInputType.Touch then
            return
        end

        local delta = input.Position - dragStart
        local viewport = AstraUI.Utility:GetViewport()

        local x = startPosition.X.Offset + delta.X
        local y = startPosition.Y.Offset + delta.Y

        if math.abs(startPosition.X.Scale - 0.5) < 0.01 then
            x = viewport.X * 0.5 + delta.X
        end
        if math.abs(startPosition.Y.Scale - 0.5) < 0.01 then
            y = viewport.Y * 0.5 + delta.Y
        end

        self.Root.Position = UDim2.fromOffset(x, y)
    end)

    self:Connect(UserInputService.InputEnded, function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1
            or input.UserInputType == Enum.UserInputType.Touch then
            dragging = false
        end
    end)
end

function Window:Connect(signal, callback)
    local connection = signal:Connect(function(...)
        safeCall(callback, ...)
    end)
    table.insert(self.Connections, connection)
    return connection
end

function Window:RefreshTheme()
    if not self.Root or not self.Root.Parent then return end
    local theme = AstraUI.Theme

    self.Root.BackgroundColor3 = theme.Surface
    self.Root.BackgroundTransparency = theme.GlassTransparency

    if self.Sidebar then
        self.Sidebar.BackgroundColor3 = theme.Surface2
        for _, child in ipairs(self.Sidebar:GetChildren()) do
            if child:IsA("TextButton") then
                child.TextColor3 = theme.Text
            end
        end
    end

    for _, component in ipairs(self.Components) do
        if component.RefreshTheme then
            component:RefreshTheme(theme)
        end
    end

    if self.TitleLabel then
        self.TitleLabel.TextColor3 = theme.Text
        self.SubtitleLabel.TextColor3 = theme.Muted
    end
end

function Window:ToggleMinimize()
    if self.Destroyed then return end

    if self.Minimized then
        self.Minimized = false
        self.Body.Visible = true
        self.Root.Size = self.SavedSize or self.Options.Size or UDim2.fromOffset(620, 450)
        AstraUI.Motion:Tween(self.Root, {
            Size = self.Root.Size,
        }, 0.38, Enum.EasingStyle.Back)
    else
        self.Minimized = true
        self.SavedSize = self.Root.Size
        self.Body.Visible = false
        AstraUI.Motion:Tween(self.Root, {
            Size = UDim2.new(self.Root.Size.X.Scale, self.Root.Size.X.Offset, 0, 76),
        }, 0.30, Enum.EasingStyle.Quint)
    end
end

function Window:Open()
    if not self.Root then return end
    self.Root.Visible = true
    self.Root.Size = UDim2.fromOffset(
        math.max(40, self.Root.AbsoluteSize.X * 0.88),
        math.max(40, self.Root.AbsoluteSize.Y * 0.88)
    )
    self.Root.BackgroundTransparency = 1
    AstraUI.Motion:Tween(self.Root, {
        Size = self.Options.Size or UDim2.fromOffset(620, 450),
        BackgroundTransparency = AstraUI.Theme.GlassTransparency,
    }, 0.48, Enum.EasingStyle.Back)
    self.Opened = true
end

function Window:Close()
    if self.Destroyed or self.Closing then return end
    self.Closing = true
    local target = UDim2.fromOffset(
        math.max(40, self.Root.AbsoluteSize.X * 0.84),
        math.max(40, self.Root.AbsoluteSize.Y * 0.84)
    )
    local tween = AstraUI.Motion:Tween(self.Root, {
        Size = target,
        BackgroundTransparency = 1,
    }, 0.30, Enum.EasingStyle.Quint)
    if tween then tween.Completed:Wait() end
    if self.Root then self.Root.Visible = false end
    self.Opened = false
    self.Closing = false
end

function Window:Toggle()
    if self.Opened then self:Close() else self:Open() end
end

--// Tab
local Tab = {}
Tab.__index = Tab

function Tab:_createButton()
    local theme = AstraUI.Theme
    local button = new("TextButton", {
        Name = self.Name .. "_Tab",
        BackgroundColor3 = theme.Elevated,
        BackgroundTransparency = 1,
        BorderSizePixel = 0,
        Size = UDim2.new(1, 0, 0, 40),
        Text = "",
        AutoButtonColor = false,
    }, self.Window.Sidebar)
    corner(button, 12)

    local icon = new("ImageLabel", {
        BackgroundTransparency = 1,
        Position = UDim2.new(0, 10, 0.5, -9),
        Size = UDim2.fromOffset(18, 18),
        Image = AstraUI:GetIcon(self.Options.Icon or "menu") or "",
        ImageColor3 = theme.Muted,
        ImageTransparency = 0.05,
    }, button)

    local label = new("TextLabel", {
        BackgroundTransparency = 1,
        Position = UDim2.new(0, 38, 0, 0),
        Size = UDim2.new(1, -44, 1, 0),
        Text = self.Name,
        TextColor3 = theme.Muted,
        TextSize = 12,
        Font = Enum.Font.GothamMedium,
        TextXAlignment = Enum.TextXAlignment.Left,
    }, button)

    self.Button = button
    self.Icon = icon
    self.Label = label

    self:Connect(button.MouseButton1Click, function()
        self:Select()
    end)
end

function Tab:Connect(signal, callback)
    local connection = signal:Connect(function(...)
        safeCall(callback, ...)
    end)
    table.insert(self.Connections, connection)
    return connection
end

function Tab:Select()
    if self.Window.ActiveTab == self then
        return
    end

    local theme = AstraUI.Theme

    if self.Window.ActiveTab then
        local previous = self.Window.ActiveTab
        previous.Button.BackgroundTransparency = 1
        previous.Label.TextColor3 = theme.Muted
        previous.Icon.ImageColor3 = theme.Muted
        previous.Page.Visible = false
    end

    self.Window.ActiveTab = self
    self.Button.BackgroundColor3 = theme.Accent
    self.Button.BackgroundTransparency = 0.78
    self.Label.TextColor3 = theme.Text
    self.Icon.ImageColor3 = theme.Accent
    self.Page.Visible = true

    self.Page.Position = UDim2.new(0, 10, 0, 0)

    AstraUI.Motion:Tween(self.Page, {
        Position = UDim2.new(0, 0, 0, 0),
    }, 0.28, Enum.EasingStyle.Quint)

    safeCall(self.Options.OnSelected, self)
end

function Tab:CreateSection(title)
    local section = new("TextLabel", {
        BackgroundTransparency = 1,
        Size = UDim2.new(1, -4, 0, 26),
        Text = string.upper(title or "SECTION"),
        TextColor3 = AstraUI.Theme.Muted,
        TextSize = 10,
        Font = Enum.Font.GothamBold,
        TextXAlignment = Enum.TextXAlignment.Left,
    }, self.Page)

    return section
end

function Tab:_baseComponent(options, height)
    options = options or {}
    local component = Component:_new(self.Window, options.Type or "Component", options)

    local root = new("Frame", {
        Name = options.Id or options.Name or "Component",
        BackgroundColor3 = AstraUI.Theme.Surface2,
        BackgroundTransparency = options.Transparency or AstraUI.Theme.CardTransparency,
        BorderSizePixel = 0,
        Size = UDim2.new(1, -4, 0, height or 54),
    }, self.Page)

    applyGlass(root, AstraUI.Theme, {
        Radius = options.Radius or 14,
        Transparency = options.Transparency or AstraUI.Theme.CardTransparency,
        Shadow = false,
    })

    component.Root = root
    component.Name = options.Name
    component.Description = options.Description
    return component
end

function Tab:CreateLabel(text, options)
    options = options or {}
    local component = self:_baseComponent({
        Type = "Label",
        Name = options.Name or "Label",
    }, options.Height or 42)

    local label = makeText(component.Root, text or "", options.TextSize or 13, AstraUI.Theme.Text, Enum.Font.GothamMedium)
    label.Position = UDim2.new(0, 14, 0, 0)
    label.Size = UDim2.new(1, -28, 1, 0)
    component.Label = label

    function component:Set(textValue)
        label.Text = tostring(textValue)
        return component
    end

    function component:Get()
        return label.Text
    end

    function component:RefreshTheme(theme)
        label.TextColor3 = theme.Text
        component.Root.BackgroundColor3 = theme.Surface2
    end

    return component
end

function Tab:CreateParagraph(options)
    options = options or {}
    local component = self:_baseComponent({
        Type = "Paragraph",
        Name = options.Name or options.Title or "Paragraph",
    }, options.Height or 72)

    local title = makeText(component.Root, options.Title or "", 13, AstraUI.Theme.Text, Enum.Font.GothamBold)
    title.Position = UDim2.new(0, 14, 0, 7)
    title.Size = UDim2.new(1, -28, 0, 22)

    local body = new("TextLabel", {
        BackgroundTransparency = 1,
        Position = UDim2.new(0, 14, 0, 29),
        Size = UDim2.new(1, -28, 1, -35),
        Text = options.Content or options.Description or "",
        TextColor3 = AstraUI.Theme.Muted,
        TextSize = 11,
        Font = Enum.Font.Gotham,
        TextWrapped = true,
        TextXAlignment = Enum.TextXAlignment.Left,
        TextYAlignment = Enum.TextYAlignment.Top,
    }, component.Root)

    component.TitleLabel = title
    component.ContentLabel = body

    function component:SetContent(value)
        body.Text = tostring(value)
        return component
    end

    function component:RefreshTheme(theme)
        title.TextColor3 = theme.Text
        body.TextColor3 = theme.Muted
    end

    return component
end

function Tab:CreateButton(options)
    options = options or {}
    local component = self:_baseComponent({
        Type = "Button",
        Name = options.Name or "Button",
        Id = options.Id,
    }, options.Height or 54)

    local button = new("TextButton", {
        BackgroundTransparency = 1,
        Size = FULL,
        Text = "",
        AutoButtonColor = false,
    }, component.Root)

    local title = makeText(button, options.Name or "Button", 13, AstraUI.Theme.Text, Enum.Font.GothamMedium)
    title.Position = UDim2.new(0, 14, 0, options.Description and 7 or 0)
    title.Size = UDim2.new(1, -80, 0, options.Description and 22 or 54)

    local description
    if options.Description then
        description = makeText(button, options.Description, 10, AstraUI.Theme.Muted, Enum.Font.Gotham)
        description.Position = UDim2.new(0, 14, 0, 29)
        description.Size = UDim2.new(1, -80, 0, 17)
    end

    local arrow = makeText(button, "›", 22, AstraUI.Theme.Muted, Enum.Font.Gotham)
    arrow.TextXAlignment = Enum.TextXAlignment.Center
    arrow.Position = UDim2.new(1, -54, 0, 0)
    arrow.Size = UDim2.fromOffset(40, 54)

    component.Button = button
    component.TitleLabel = title

    component:Connect(button.MouseEnter, function()
        if component.Disabled then return end
        AstraUI.Motion:Tween(component.Root, {
            BackgroundTransparency = math.max(0, AstraUI.Theme.CardTransparency - 0.05),
        }, 0.16, Enum.EasingStyle.Quad)
        AstraUI.Motion:Tween(arrow, {TextColor3 = AstraUI.Theme.Accent}, 0.16)
    end)

    component:Connect(button.MouseLeave, function()
        AstraUI.Motion:Tween(component.Root, {
            BackgroundTransparency = AstraUI.Theme.CardTransparency,
        }, 0.20, Enum.EasingStyle.Quad)
        AstraUI.Motion:Tween(arrow, {TextColor3 = AstraUI.Theme.Muted}, 0.20)
    end)

    component:Connect(button.MouseButton1Down, function()
        if component.Disabled then return end
        AstraUI.Motion:Pulse(component.Root, 0.985, 0.08)
    end)

    component:Connect(button.MouseButton1Click, function()
        if component.Disabled then return end
        safeCall(options.Callback, component)
    end)

    function component:Fire()
        if not component.Disabled then
            safeCall(options.Callback, component)
        end
    end

    function component:SetText(value)
        title.Text = tostring(value)
        return component
    end

    function component:RefreshTheme(theme)
        title.TextColor3 = theme.Text
        if description then description.TextColor3 = theme.Muted end
        arrow.TextColor3 = theme.Muted
    end

    return component
end

function Tab:CreateToggle(options)
    options = options or {}
    local component = self:_baseComponent({
        Type = "Toggle",
        Name = options.Name or "Toggle",
        Id = options.Id,
    }, options.Height or 54)

    local button = new("TextButton", {
        BackgroundTransparency = 1,
        Size = FULL,
        Text = "",
        AutoButtonColor = false,
    }, component.Root)

    local title = makeText(button, options.Name or "Toggle", 13, AstraUI.Theme.Text, Enum.Font.GothamMedium)
    title.Position = UDim2.new(0, 14, 0, options.Description and 7 or 0)
    title.Size = UDim2.new(1, -92, 0, options.Description and 22 or 54)

    local description
    if options.Description then
        description = makeText(button, options.Description, 10, AstraUI.Theme.Muted, Enum.Font.Gotham)
        description.Position = UDim2.new(0, 14, 0, 29)
        description.Size = UDim2.new(1, -92, 0, 17)
    end

    local track = new("Frame", {
        AnchorPoint = Vector2.new(1, 0.5),
        Position = UDim2.new(1, -14, 0.5, 0),
        Size = UDim2.fromOffset(44, 24),
        BackgroundColor3 = AstraUI.Theme.Elevated,
        BorderSizePixel = 0,
    }, button)
    corner(track, 12)

    local knob = new("Frame", {
        AnchorPoint = Vector2.new(0, 0.5),
        Position = UDim2.new(0, 3, 0.5, 0),
        Size = UDim2.fromOffset(18, 18),
        BackgroundColor3 = AstraUI.Theme.Muted,
        BorderSizePixel = 0,
    }, track)
    corner(knob, 9)

    component.Value = options.CurrentValue == true
    component.Track = track
    component.Knob = knob
    component.TitleLabel = title

    local function render(animated)
        local on = component.Value
        local targetTrack = on and AstraUI.Theme.Accent or AstraUI.Theme.Elevated
        local targetKnob = on and Color3.new(1, 1, 1) or AstraUI.Theme.Muted
        local targetPosition = on and UDim2.new(1, -21, 0.5, 0) or UDim2.new(0, 3, 0.5, 0)

        if animated then
            AstraUI.Motion:Tween(track, {BackgroundColor3 = targetTrack}, 0.22, Enum.EasingStyle.Quint)
            AstraUI.Motion:Spring(knob, "Position", targetPosition, {Preset = "Snappy"})
            AstraUI.Motion:Tween(knob, {BackgroundColor3 = targetKnob}, 0.18)
        else
            track.BackgroundColor3 = targetTrack
            knob.Position = targetPosition
            knob.BackgroundColor3 = targetKnob
        end
    end

    function component:Set(value, fire)
        component.Value = value == true
        render(true)
        if fire ~= false then
            safeCall(options.Callback, component.Value)
        end
        return component
    end

    function component:Get()
        return component.Value
    end

    component:Connect(button.MouseButton1Click, function()
        if not component.Disabled then
            component:Set(not component.Value)
        end
    end)

    render(false)

    function component:RefreshTheme(theme)
        title.TextColor3 = theme.Text
        if description then description.TextColor3 = theme.Muted end
        render(false)
    end

    return component
end

function Tab:CreateSlider(options)
    options = options or {}
    local minimum = options.Min or options.Minimum or 0
    local maximum = options.Max or options.Maximum or 100
    local value = clamp(options.CurrentValue or options.Default or minimum, minimum, maximum)

    local component = self:_baseComponent({
        Type = "Slider",
        Name = options.Name or "Slider",
        Id = options.Id,
    }, options.Height or 72)

    local title = makeText(component.Root, options.Name or "Slider", 12, AstraUI.Theme.Text, Enum.Font.GothamMedium)
    title.Position = UDim2.new(0, 14, 0, 7)
    title.Size = UDim2.new(1, -90, 0, 20)

    local valueLabel = makeText(component.Root, tostring(value), 11, AstraUI.Theme.Muted, Enum.Font.GothamMedium)
    valueLabel.TextXAlignment = Enum.TextXAlignment.Right
    valueLabel.Position = UDim2.new(1, -76, 0, 7)
    valueLabel.Size = UDim2.fromOffset(62, 20)

    local rail = new("Frame", {
        Position = UDim2.new(0, 14, 0, 40),
        Size = UDim2.new(1, -28, 0, 6),
        BackgroundColor3 = AstraUI.Theme.Elevated,
        BorderSizePixel = 0,
    }, component.Root)
    corner(rail, 3)

    local fill = new("Frame", {
        Size = UDim2.fromScale((value - minimum) / math.max(1, maximum - minimum), 1),
        BackgroundColor3 = AstraUI.Theme.Accent,
        BorderSizePixel = 0,
    }, rail)
    corner(fill, 3)

    local knob = new("Frame", {
        AnchorPoint = Vector2.new(0.5, 0.5),
        Position = UDim2.fromScale((value - minimum) / math.max(1, maximum - minimum), 0.5),
        Size = UDim2.fromOffset(16, 16),
        BackgroundColor3 = AstraUI.Theme.Text,
        BorderSizePixel = 0,
    }, rail)
    corner(knob, 8)

    local hitbox = new("TextButton", {
        BackgroundTransparency = 1,
        Size = UDim2.new(1, 0, 1, 16),
        Position = UDim2.new(0, 0, 0, -8),
        Text = "",
        AutoButtonColor = false,
    }, rail)

    component.Value = value
    component.Minimum = minimum
    component.Maximum = maximum
    component.Fill = fill
    component.Knob = knob
    component.ValueLabel = valueLabel
    component.Rail = rail

    local function updateFromX(x, fire)
        local percent = clamp((x - rail.AbsolutePosition.X) / math.max(1, rail.AbsoluteSize.X), 0, 1)
        local raw = minimum + (maximum - minimum) * percent
        local increment = options.Increment or options.Step
        if increment and increment > 0 then
            raw = math.floor(raw / increment + 0.5) * increment
        end
        component.Value = clamp(raw, minimum, maximum)

        local ratio = (component.Value - minimum) / math.max(1, maximum - minimum)
        fill.Size = UDim2.fromScale(ratio, 1)
        knob.Position = UDim2.fromScale(ratio, 0.5)
        valueLabel.Text = tostring(component.Value)

        if fire ~= false then
            safeCall(options.Callback, component.Value)
        end
    end

    local dragging = false
    component:Connect(hitbox.InputBegan, function(input)
        if component.Disabled then return end
        if input.UserInputType == Enum.UserInputType.MouseButton1
            or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            updateFromX(input.Position.X)
        end
    end)

    component:Connect(UserInputService.InputChanged, function(input)
        if not dragging then return end
        if input.UserInputType == Enum.UserInputType.MouseMovement
            or input.UserInputType == Enum.UserInputType.Touch then
            updateFromX(input.Position.X)
        end
    end)

    component:Connect(UserInputService.InputEnded, function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1
            or input.UserInputType == Enum.UserInputType.Touch then
            dragging = false
        end
    end)

    function component:Set(newValue, fire)
        newValue = clamp(newValue, minimum, maximum)
        component.Value = newValue
        local ratio = (newValue - minimum) / math.max(1, maximum - minimum)
        fill.Size = UDim2.fromScale(ratio, 1)
        AstraUI.Motion:Spring(knob, "Position", UDim2.fromScale(ratio, 0.5), {Preset = "Liquid"})
        valueLabel.Text = tostring(newValue)
        if fire ~= false then
            safeCall(options.Callback, newValue)
        end
        return component
    end

    function component:Get()
        return component.Value
    end

    function component:RefreshTheme(theme)
        title.TextColor3 = theme.Text
        valueLabel.TextColor3 = theme.Muted
        rail.BackgroundColor3 = theme.Elevated
        fill.BackgroundColor3 = theme.Accent
        knob.BackgroundColor3 = theme.Text
    end

    return component
end

function Tab:CreateInput(options)
    options = options or {}
    local component = self:_baseComponent({
        Type = "Input",
        Name = options.Name or "Input",
        Id = options.Id,
    }, options.Height or 72)

    local title = makeText(component.Root, options.Name or "Input", 12, AstraUI.Theme.Text, Enum.Font.GothamMedium)
    title.Position = UDim2.new(0, 14, 0, 7)
    title.Size = UDim2.new(0.35, 0, 0, 20)

    local box = new("TextBox", {
        Position = UDim2.new(0.34, 0, 0, 10),
        Size = UDim2.new(0.66, -14, 0, 40),
        BackgroundColor3 = AstraUI.Theme.Elevated,
        BackgroundTransparency = 0.2,
        BorderSizePixel = 0,
        Text = options.Default or options.CurrentValue or "",
        PlaceholderText = options.PlaceholderText or "Enter text...",
        PlaceholderColor3 = AstraUI.Theme.Muted,
        TextColor3 = AstraUI.Theme.Text,
        TextSize = 12,
        Font = Enum.Font.Gotham,
        ClearTextOnFocus = options.ClearTextOnFocus == true,
    }, component.Root)
    corner(box, 12)
    padding(box, 12, 0, 12, 0)

    component.Input = box

    component:Connect(box.FocusLost, function(enterPressed)
        if component.Disabled then return end
        safeCall(options.Callback, box.Text, enterPressed)
    end)

    function component:Set(value, fire)
        box.Text = tostring(value or "")
        if fire ~= false then
            safeCall(options.Callback, box.Text, false)
        end
        return component
    end

    function component:Get()
        return box.Text
    end

    function component:Focus()
        box:CaptureFocus()
    end

    function component:RefreshTheme(theme)
        title.TextColor3 = theme.Text
        box.BackgroundColor3 = theme.Elevated
        box.TextColor3 = theme.Text
        box.PlaceholderColor3 = theme.Muted
    end

    return component
end

--// Generic dropdown factory
local function createDropdown(tab, options, multiple)
    options = options or {}
    local component = tab:_baseComponent({
        Type = multiple and "MultiDropdown" or "Dropdown",
        Name = options.Name or "Dropdown",
        Id = options.Id,
    }, options.Height or 62)

    local title = makeText(component.Root, options.Name or "Dropdown", 12, AstraUI.Theme.Text, Enum.Font.GothamMedium)
    title.Position = UDim2.new(0, 14, 0, 6)
    title.Size = UDim2.new(1, -30, 0, 18)

    local selected = makeText(component.Root, "", 10, AstraUI.Theme.Muted, Enum.Font.Gotham)
    selected.Position = UDim2.new(0, 14, 0, 28)
    selected.Size = UDim2.new(1, -50, 0, 22)

    local chevron = makeText(component.Root, "⌄", 17, AstraUI.Theme.Muted, Enum.Font.GothamBold)
    chevron.TextXAlignment = Enum.TextXAlignment.Center
    chevron.Position = UDim2.new(1, -42, 0, 17)
    chevron.Size = UDim2.fromOffset(28, 28)

    local trigger = new("TextButton", {
        BackgroundTransparency = 1,
        Size = FULL,
        Text = "",
        AutoButtonColor = false,
    }, component.Root)

    local popup
    local open = false
    local values = options.Options or options.Values or {}
    local current = options.CurrentOption or options.CurrentValue

    if multiple then
        current = type(current) == "table" and current or {}
    end

    local function display()
        if multiple then
            local names = {}
            for name, enabled in pairs(current) do
                if enabled then table.insert(names, tostring(name)) end
            end
            table.sort(names)
            selected.Text = #names > 0 and table.concat(names, ", ") or (options.Placeholder or "Nothing selected")
        else
            selected.Text = current ~= nil and tostring(current) or (options.Placeholder or "Select an option")
        end
    end

    local function close()
        if not popup or not open then return end
        open = false
        local target = UDim2.new(1, 0, 0, 0)
        local tween = AstraUI.Motion:Tween(popup, {Size = target}, 0.20, Enum.EasingStyle.Quint)
        if tween then tween.Completed:Wait() end
        if popup then popup.Visible = false end
    end

    local function makePopup()
        if popup then return end

        popup = new("Frame", {
            Name = "DropdownPopup",
            BackgroundColor3 = AstraUI.Theme.Surface,
            BackgroundTransparency = AstraUI.Theme.CardTransparency,
            BorderSizePixel = 0,
            Position = UDim2.new(0, 0, 1, 6),
            Size = UDim2.new(1, 0, 0, 0),
            ZIndex = 50,
            ClipsDescendants = true,
        }, component.Root)
        corner(popup, 13)
        stroke(popup, AstraUI.Theme.Border, AstraUI.Theme.BorderTransparency)

        local scroll = new("ScrollingFrame", {
            BackgroundTransparency = 1,
            BorderSizePixel = 0,
            Position = UDim2.fromOffset(5, 5),
            Size = UDim2.new(1, -10, 1, -10),
            CanvasSize = UDim2.new(),
            AutomaticCanvasSize = Enum.AutomaticSize.Y,
            ScrollBarThickness = 2,
            ScrollBarImageTransparency = 0.7,
            ZIndex = 51,
        }, popup)
        padding(scroll, 4, 4, 4, 4)
        list(scroll, Enum.FillDirection.Vertical, 4)

        for index, option in ipairs(values) do
            local name = tostring(option)
            local item = new("TextButton", {
                BackgroundColor3 = AstraUI.Theme.Elevated,
                BackgroundTransparency = 1,
                BorderSizePixel = 0,
                Size = UDim2.new(1, 0, 0, 34),
                Text = name,
                TextColor3 = AstraUI.Theme.Muted,
                TextSize = 11,
                Font = Enum.Font.GothamMedium,
                AutoButtonColor = false,
                LayoutOrder = index,
                ZIndex = 52,
            }, scroll)
            corner(item, 9)

            item.MouseEnter:Connect(function()
                AstraUI.Motion:Tween(item, {
                    BackgroundTransparency = 0.55,
                    TextColor3 = AstraUI.Theme.Text,
                }, 0.12)
            end)

            item.MouseLeave:Connect(function()
                AstraUI.Motion:Tween(item, {
                    BackgroundTransparency = 1,
                    TextColor3 = AstraUI.Theme.Muted,
                }, 0.12)
            end)

            item.MouseButton1Click:Connect(function()
                if multiple then
                    current[name] = not current[name]
                    safeCall(options.Callback, current)
                    display()
                else
                    current = option
                    display()
                    safeCall(options.Callback, current)
                    close()
                end
            end)
        end
    end

    trigger.MouseButton1Click:Connect(function()
        if component.Disabled then return end
        makePopup()
        if open then
            close()
            return
        end
        open = true
        popup.Visible = true
        local height = math.min(220, math.max(40, #values * 38 + 18))
        popup.Size = UDim2.new(1, 0, 0, 0)
        AstraUI.Motion:Tween(
            popup,
            {Size = UDim2.new(1, 0, 0, height)},
            0.30,
            Enum.EasingStyle.Back
        )
    end)

    component.Value = current

    function component:Set(value, fire)
        if multiple then
            current = type(value) == "table" and value or {}
        else
            current = value
        end
        component.Value = current
        display()
        if fire ~= false then
            safeCall(options.Callback, current)
        end
        return component
    end

    function component:Get()
        return component.Value
    end

    function component:RefreshTheme(theme)
        title.TextColor3 = theme.Text
        selected.TextColor3 = theme.Muted
        chevron.TextColor3 = theme.Muted
        component.Root.BackgroundColor3 = theme.Surface2
        if popup then
            popup.BackgroundColor3 = theme.Surface
            for _, child in ipairs(popup:GetDescendants()) do
                if child:IsA("TextButton") then
                    child.TextColor3 = theme.Muted
                end
            end
        end
    end

    display()
    return component
end

function Tab:CreateDropdown(options)
    return createDropdown(self, options, false)
end

function Tab:CreateMultiDropdown(options)
    return createDropdown(self, options, true)
end

function Tab:CreateKeybind(options)
    options = options or {}
    local component = self:_baseComponent({
        Type = "Keybind",
        Name = options.Name or "Keybind",
        Id = options.Id,
    }, options.Height or 54)

    local title = makeText(component.Root, options.Name or "Keybind", 12, AstraUI.Theme.Text, Enum.Font.GothamMedium)
    title.Position = UDim2.new(0, 14, 0, 0)
    title.Size = UDim2.new(1, -130, 1, 0)

    local bind = new("TextButton", {
        AnchorPoint = Vector2.new(1, 0.5),
        Position = UDim2.new(1, -12, 0.5, 0),
        Size = UDim2.fromOffset(100, 32),
        BackgroundColor3 = AstraUI.Theme.Elevated,
        BackgroundTransparency = 0.15,
        BorderSizePixel = 0,
        Text = tostring(options.CurrentKeybind or options.Default or "None"),
        TextColor3 = AstraUI.Theme.Text,
        TextSize = 10,
        Font = Enum.Font.GothamMedium,
        AutoButtonColor = false,
    }, component.Root)
    corner(bind, 10)

    local key = options.CurrentKeybind or options.Default
    local listening = false

    bind.MouseButton1Click:Connect(function()
        if component.Disabled then return end
        listening = true
        bind.Text = "Press key..."
    end)

    component:Connect(UserInputService.InputBegan, function(input, processed)
        if processed then return end

        if listening then
            if input.UserInputType == Enum.UserInputType.Keyboard then
                key = input.KeyCode
                bind.Text = key.Name
                listening = false
                safeCall(options.Callback, key)
            end
            return
        end

        if key and input.KeyCode == key then
            safeCall(options.HoldToInteract and options.Callback or options.Callback, key)
        end
    end)

    component.Value = key

    function component:Set(newKey, fire)
        key = newKey
        component.Value = newKey
        bind.Text = typeof(newKey) == "EnumItem" and newKey.Name or tostring(newKey or "None")
        if fire ~= false then safeCall(options.Callback, key) end
        return component
    end

    function component:Get()
        return key
    end

    function component:RefreshTheme(theme)
        title.TextColor3 = theme.Text
        bind.BackgroundColor3 = theme.Elevated
        bind.TextColor3 = theme.Text
    end

    return component
end

function Tab:CreateColorPicker(options)
    options = options or {}
    local component = self:_baseComponent({
        Type = "ColorPicker",
        Name = options.Name or "Color",
        Id = options.Id,
    }, options.Height or 54)

    local title = makeText(component.Root, options.Name or "Color", 12, AstraUI.Theme.Text, Enum.Font.GothamMedium)
    title.Position = UDim2.new(0, 14, 0, 0)
    title.Size = UDim2.new(1, -80, 1, 0)

    local preview = new("TextButton", {
        AnchorPoint = Vector2.new(1, 0.5),
        Position = UDim2.new(1, -14, 0.5, 0),
        Size = UDim2.fromOffset(42, 28),
        BackgroundColor3 = options.Color or Color3.new(1, 1, 1),
        BorderSizePixel = 0,
        Text = "",
        AutoButtonColor = false,
    }, component.Root)
    corner(preview, 10)

    local picker
    local color = options.Color or options.CurrentColor or Color3.fromRGB(128, 160, 255)

    local function createPicker()
        if picker then
            picker.Visible = not picker.Visible
            return
        end

        picker = new("Frame", {
            BackgroundColor3 = AstraUI.Theme.Surface,
            BackgroundTransparency = AstraUI.Theme.CardTransparency,
            BorderSizePixel = 0,
            Position = UDim2.new(0, 0, 1, 6),
            Size = UDim2.new(1, 0, 0, 190),
            ZIndex = 70,
        }, component.Root)
        corner(picker, 14)
        stroke(picker, AstraUI.Theme.Border, AstraUI.Theme.BorderTransparency)

        local hue = new("Frame", {
            Position = UDim2.new(0, 12, 0, 12),
            Size = UDim2.new(1, -24, 0, 22),
            BackgroundColor3 = Color3.new(1, 1, 1),
            BorderSizePixel = 0,
            ZIndex = 71,
        }, picker)
        corner(hue, 8)

        local hueGradient = new("UIGradient", {
            Color = ColorSequence.new({
                ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 0, 0)),
                ColorSequenceKeypoint.new(0.17, Color3.fromRGB(255, 255, 0)),
                ColorSequenceKeypoint.new(0.33, Color3.fromRGB(0, 255, 0)),
                ColorSequenceKeypoint.new(0.5, Color3.fromRGB(0, 255, 255)),
                ColorSequenceKeypoint.new(0.67, Color3.fromRGB(0, 0, 255)),
                ColorSequenceKeypoint.new(0.83, Color3.fromRGB(255, 0, 255)),
                ColorSequenceKeypoint.new(1, Color3.fromRGB(255, 0, 0)),
            }),
            Rotation = 0,
        }, hue)

        local field = new("Frame", {
            Position = UDim2.new(0, 12, 0, 46),
            Size = UDim2.new(1, -24, 0, 110),
            BackgroundColor3 = color,
            BorderSizePixel = 0,
            ZIndex = 71,
        }, picker)
        corner(field, 10)

        local white = new("Frame", {
            BackgroundColor3 = Color3.new(1, 1, 1),
            BackgroundTransparency = 0,
            Size = FULL,
            BorderSizePixel = 0,
            ZIndex = 72,
        }, field)
        corner(white, 10)
        local whiteGradient = new("UIGradient", {
            Transparency = NumberSequence.new({
                NumberSequenceKeypoint.new(0, 0),
                NumberSequenceKeypoint.new(1, 1),
            }),
            Rotation = 0,
        }, white)

        local black = new("Frame", {
            BackgroundColor3 = Color3.new(0, 0, 0),
            BackgroundTransparency = 0,
            Size = FULL,
            BorderSizePixel = 0,
            ZIndex = 73,
        }, field)
        corner(black, 10)
        local blackGradient = new("UIGradient", {
            Transparency = NumberSequence.new({
                NumberSequenceKeypoint.new(0, 1),
                NumberSequenceKeypoint.new(1, 0),
            }),
            Rotation = 90,
        }, black)

        local function setColor(newColor)
            color = AstraUI.Utility:ClampColor(newColor)
            component.Value = color
            preview.BackgroundColor3 = color
            field.BackgroundColor3 = color
            safeCall(options.Callback, color)
        end

        local hueConnection = hue.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1
                or input.UserInputType == Enum.UserInputType.Touch then
                local x = clamp(
                    (input.Position.X - hue.AbsolutePosition.X) / math.max(1, hue.AbsoluteSize.X),
                    0, 1
                )
                local hsvH = x
                local _, saturation, value = Color3.toHSV(color)
                setColor(Color3.fromHSV(hsvH, saturation, value))
            end
        end)

        table.insert(component.Connections, hueConnection)

        local fieldConnection = field.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1
                or input.UserInputType == Enum.UserInputType.Touch then
                local x = clamp(
                    (input.Position.X - field.AbsolutePosition.X) / math.max(1, field.AbsoluteSize.X),
                    0, 1
                )
                local y = clamp(
                    (input.Position.Y - field.AbsolutePosition.Y) / math.max(1, field.AbsoluteSize.Y),
                    0, 1
                )
                local hueValue = select(1, Color3.toHSV(color))
                setColor(Color3.fromHSV(hueValue, 1 - x, 1 - y))
            end
        end)

        table.insert(component.Connections, fieldConnection)
    end

    preview.MouseButton1Click:Connect(createPicker)

    component.Value = color

    function component:Set(newColor, fire)
        assert(typeof(newColor) == "Color3", "ColorPicker value must be Color3")
        color = newColor
        component.Value = color
        preview.BackgroundColor3 = color
        if picker then
            local field = picker:FindFirstChild("Frame", true)
            if field then field.BackgroundColor3 = color end
        end
        if fire ~= false then safeCall(options.Callback, color) end
        return component
    end

    function component:Get()
        return component.Value
    end

    function component:RefreshTheme(theme)
        title.TextColor3 = theme.Text
        preview.BackgroundColor3 = color
        if picker then picker.BackgroundColor3 = theme.Surface end
    end

    return component
end

--// Search
function Window:Search(query)
    query = string.lower(tostring(query or ""))
    self.SearchQuery = query

    for _, component in ipairs(self.Components) do
        if component.Root then
            local name = string.lower(tostring(component.Name or ""))
            local description = string.lower(tostring(component.Description or ""))
            component.Root.Visible =
                query == ""
                or string.find(name, query, 1, true) ~= nil
                or string.find(description, query, 1, true) ~= nil
        end
    end
end

--// Window tab creation
function Window:CreateTab(options)
    options = type(options) == "table" and options or {Name = tostring(options)}
    local tab = setmetatable({
        Window = self,
        Name = options.Name or "Tab",
        Options = options,
        Components = {},
        Connections = {},
        Id = options.Id or options.Name or ("Tab_" .. tostring(#self.Tabs + 1)),
    }, Tab)

    tab.Page = new("ScrollingFrame", {
        Name = tab.Id .. "_Page",
        BackgroundTransparency = 1,
        Size = FULL,
        BorderSizePixel = 0,
        CanvasSize = UDim2.new(),
        AutomaticCanvasSize = Enum.AutomaticSize.Y,
        ScrollBarThickness = 2,
        ScrollBarImageTransparency = 0.72,
        Visible = false,
    }, self.Content)

    padding(tab.Page, 2, 2, 6, 10)
    list(tab.Page, Enum.FillDirection.Vertical, 8)

    tab:_createButton()
    table.insert(self.Tabs, tab)

    if not self.ActiveTab then
        self.ActiveTab = nil
        tab:Select()
    end

    return tab
end

function Window:GetTab(name)
    for _, tab in ipairs(self.Tabs) do
        if tab.Name == name or tab.Id == name then
            return tab
        end
    end
end

function Window:GetComponent(id)
    return AstraUI.Components[id]
end

function Window:SetSearchEnabled(enabled)
    self.SearchEnabled = enabled == true
    return self
end

function Window:Destroy()
    if self.Destroyed then return end
    self.Destroyed = true

    for _, connection in ipairs(self.Connections) do
        pcall(function() connection:Disconnect() end)
    end

    for _, component in ipairs(self.Components) do
        pcall(function() component:Destroy() end)
    end

    if self.Gui then
        self.Gui:Destroy()
    end

    for i, item in ipairs(AstraUI.Windows) do
        if item == self then
            table.remove(AstraUI.Windows, i)
            break
        end
    end
end

--// CreateWindow
function AstraUI:CreateWindow(options)
    options = type(options) == "table" and options or {}

    local window = setmetatable({
        Id = options.Id or ("Window_" .. tostring(math.random(10000, 99999))),
        Options = options,
        Tabs = {},
        Components = {},
        Connections = {},
        Opened = false,
        Minimized = false,
        Destroyed = false,
        Compact = false,
    }, Window)

    window:_makeGui()
    window:_makeRoot()
    window:_makeHeader()
    window:_makeBody()
    window:_bindDragging()

    table.insert(AstraUI.Windows, window)

    window:Connect(workspace.CurrentCamera:GetPropertyChangedSignal("ViewportSize"), function()
        window:_updateResponsive()
    end)

    -- Entrance animation
    window.Root.Visible = true
    window.Root.BackgroundTransparency = 1
    window.Root.Size = UDim2.fromOffset(80, 60)
    AstraUI.Motion:Tween(window.Root, {
        Size = options.Size or UDim2.fromOffset(620, 450),
        BackgroundTransparency = AstraUI.Theme.GlassTransparency,
    }, options.OpenDuration or 0.52, Enum.EasingStyle.Back)

    window.Opened = true

    return window
end

function AstraUI:SetReducedMotion(enabled)
    self.State.ReducedMotion = enabled == true
    return self.State.ReducedMotion
end

function AstraUI:SetQuality(level)
    level = clamp(tonumber(level) or 3, 0, 3)
    self.State.Quality = level

    if level == 0 then
        self:SetReducedMotion(true)
    end

    return level
end

function AstraUI:DestroyAll()
    for i = #self.Windows, 1, -1 do
        self.Windows[i]:Destroy()
    end
end

--// Compatibility aliases
AstraUI.Create = AstraUI.CreateWindow
AstraUI.SetThemeName = AstraUI.SetTheme
AstraUI.Notification = AstraUI.Notify


function AstraUI.Utility:DeepCopy(value, seen)
    if type(value) ~= "table" then
        return value
    end
    seen = seen or {}
    if seen[value] then
        return seen[value]
    end
    local result = {}
    seen[value] = result
    for key, item in pairs(value) do
        result[self:DeepCopy(key, seen)] = self:DeepCopy(item, seen)
    end
    return result
end


function AstraUI.Utility:Merge(base, override)
    local result = self:DeepCopy(base or {})
    for key, value in pairs(override or {}) do
        if type(value) == "table" and type(result[key]) == "table" then
            result[key] = self:Merge(result[key], value)
        else
            result[key] = value
        end
    end
    return result
end


function AstraUI.Utility:NormalizeOptions(options)
    options = type(options) == "table" and options or {}
    local result = self:DeepCopy(options)
    result.Name = tostring(result.Name or result.Title or "Component")
    if result.Description ~= nil then
        result.Description = tostring(result.Description)
    end
    return result
end


function AstraUI.Utility:MakeSignal()
    local listeners = {}
    local signal = {}
    function signal:Connect(callback)
        assert(type(callback) == "function", "Signal callback must be a function")
        local active = true
        local connection = {}
        function connection:Disconnect()
            active = false
        end
        table.insert(listeners, function(...)
            if active then safeCall(callback, ...) end
        end)
        return connection
    end
    function signal:Fire(...)
        for _, listener in ipairs(listeners) do
            listener(...)
        end
    end
    return signal
end


function AstraUI.Utility:ColorFromHex(hex)
    hex = tostring(hex):gsub("#", "")
    if #hex ~= 6 then return Color3.new(1, 1, 1) end
    local r = tonumber(hex:sub(1, 2), 16) or 255
    local g = tonumber(hex:sub(3, 4), 16) or 255
    local b = tonumber(hex:sub(5, 6), 16) or 255
    return Color3.fromRGB(r, g, b)
end


function AstraUI.Utility:ColorToHex(color)
    assert(typeof(color) == "Color3", "Color must be Color3")
    return string.format("#%02X%02X%02X",
        math.floor(color.R * 255 + 0.5),
        math.floor(color.G * 255 + 0.5),
        math.floor(color.B * 255 + 0.5)
    )
end


function AstraUI.Utility:FormatTime(seconds)
    seconds = math.max(0, math.floor(tonumber(seconds) or 0))
    local minutes = math.floor(seconds / 60)
    local remaining = seconds % 60
    return string.format("%02d:%02d", minutes, remaining)
end


function AstraUI.Motion:Ease(alpha, style)
    alpha = clamp(alpha, 0, 1)
    style = style or "Smooth"
    if style == "Linear" then return alpha end
    if style == "QuadIn" then return alpha * alpha end
    if style == "QuadOut" then return 1 - (1 - alpha) * (1 - alpha) end
    if style == "CubicIn" then return alpha ^ 3 end
    if style == "CubicOut" then return 1 - (1 - alpha) ^ 3 end
    if style == "Smooth" then return alpha * alpha * (3 - 2 * alpha) end
    if style == "Sine" then return 1 - math.cos(alpha * math.pi * 0.5) end
    if style == "Back" then
        local c1 = 1.70158
        local c3 = c1 + 1
        return 1 + c3 * (alpha - 1)^3 + c1 * (alpha - 1)^2
    end
    return alpha
end



--// Convenience component aliases
function Tab:CreateText(options)
    options = options or {}
    return self:CreateLabel(options.Text or options.Name or "", options)
end

function Tab:CreateDivider(options)
    options = options or {}
    local component = self:_baseComponent({
        Type = "Divider",
        Name = options.Name or "Divider",
    }, options.Height or 14)

    component.Root.BackgroundTransparency = 1
    local line = new("Frame", {
        AnchorPoint = Vector2.new(0.5, 0.5),
        Position = UDim2.fromScale(0.5, 0.5),
        Size = UDim2.new(1, -12, 0, 1),
        BackgroundColor3 = AstraUI.Theme.Border,
        BackgroundTransparency = 0.88,
        BorderSizePixel = 0,
    }, component.Root)

    function component:RefreshTheme(theme)
        line.BackgroundColor3 = theme.Border
    end
    return component
end

function Tab:CreateSpacer(height)
    local component = self:_baseComponent({
        Type = "Spacer",
        Name = "Spacer",
    }, height or 10)
    component.Root.BackgroundTransparency = 1
    return component
end

function Window:SetPosition(position)
    assert(typeof(position) == "UDim2", "Position must be UDim2")
    self.Root.Position = position
    return self
end

function Window:SetSize(size, animated)
    assert(typeof(size) == "UDim2", "Size must be UDim2")
    self.Options.Size = size
    if animated then
        AstraUI.Motion:Spring(self.Root, "Size", size, {Preset = "Liquid"})
    else
        self.Root.Size = size
    end
    return self
end

function Window:SetTitle(title, subtitle)
    if self.TitleLabel then self.TitleLabel.Text = tostring(title or "") end
    if subtitle ~= nil and self.SubtitleLabel then
        self.SubtitleLabel.Text = tostring(subtitle)
    end
    return self
end

function Window:SetVisibility(visible)
    self.Root.Visible = visible == true
    self.Opened = self.Root.Visible
    return self
end

function Window:SetSearch(query)
    self:Search(query)
    return self
end

function AstraUI:CreateNotification(options)
    return self:Notify(options)
end

--// Public API metadata
AstraUI.API = {
    CreateWindow = "Creates a Liquid Glass window",
    Create = "Alias for CreateWindow",
    Themes = "Built-in and custom themes",
    Motion = "Tween, Spring, Pulse, presets and easing",
    Notifications = "Liquid Glass toast notifications",
    Components = {
        "Label", "Paragraph", "Button", "Toggle", "Slider",
        "Input", "Dropdown", "MultiDropdown", "Keybind",
        "ColorPicker", "Text", "Divider", "Spacer",
    },
}

return AstraUI
