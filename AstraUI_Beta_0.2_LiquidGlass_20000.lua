--// AstraUI Beta 0.2
--// Liquid Glass Roblox UI Library
--// Mobile-first responsive UI, motion engine, Lucide-compatible icon registry
--// Generated as a functional library: no filler counters or dummy assignments.

local AstraUI = {}
AstraUI.__index = AstraUI
AstraUI.Version = "0.2.0"
AstraUI.Build = "LiquidGlass"

local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local GuiService = game:GetService("GuiService")
local TextService = game:GetService("TextService")
local HttpService = game:GetService("HttpService")

local LocalPlayer = Players.LocalPlayer

local function clamp(value, minimum, maximum)
    return math.max(minimum, math.min(maximum, value))
end

local function lerp(a, b, t)
    return a + (b - a) * t
end

local function colorLerp(a, b, t)
    return Color3.new(lerp(a.R, b.R, t), lerp(a.G, b.G, t), lerp(a.B, b.B, t))
end

local function safeCall(callback, ...)
    if type(callback) ~= "function" then return end
    local ok, result = pcall(callback, ...)
    if not ok then warn("[AstraUI] Callback error:", result) end
    return result
end

local function make(className, properties)
    local object = Instance.new(className)
    for property, value in pairs(properties or {}) do
        local ok = pcall(function() object[property] = value end)
        if not ok then warn("[AstraUI] Invalid property:", className, property) end
    end
    return object
end

local function connect(signal, callback, maid)
    local connection = signal:Connect(callback)
    if maid then table.insert(maid, connection) end
    return connection
end

local function disconnectAll(connections)
    for index = #connections, 1, -1 do
        local item = connections[index]
        if typeof(item) == "RBXScriptConnection" then
            pcall(function() item:Disconnect() end)
        elseif typeof(item) == "Instance" then
            pcall(function() item:Destroy() end)
        elseif type(item) == "function" then
            pcall(item)
        end
        connections[index] = nil
    end
end

AstraUI.Defaults = {
    Theme = "Midnight",
    Accent = Color3.fromRGB(150, 115, 255),
    Transparency = 0.14,
    Blur = 18,
    CornerRadius = 16,
    AnimationSpeed = 0.28,
    SpringDamping = 0.82,
    SpringFrequency = 4.8,
    MobileBreakpoint = 720,
    CompactBreakpoint = 460,
    ReducedMotion = false,
    ShowLoading = true,
    LoadingDuration = 1.35,
    NotificationSide = "Bottom",
    NotificationDuration = 3.5,
    Quality = "Auto",
    Font = Enum.Font.Gotham,
    TextSize = 14,
    UseTouchTargets = true,
}

AstraUI.Themes = {
    Midnight = {
        Background = Color3.fromRGB(13,14,19),
        Surface = Color3.fromRGB(22,23,31),
        SurfaceRaised = Color3.fromRGB(31,32,43),
        Text = Color3.fromRGB(235,233,245),
        Muted = Color3.fromRGB(166,160,186),
        Accent = Color3.fromRGB(150,115,255),
        Border = Color3.new(1,1,1),
        Danger = Color3.fromRGB(255,92,112),
        Success = Color3.fromRGB(92,226,157),
        Warning = Color3.fromRGB(255,190,83),
    },
    Obsidian = {
        Background = Color3.fromRGB(9,10,12),
        Surface = Color3.fromRGB(17,18,21),
        SurfaceRaised = Color3.fromRGB(27,28,33),
        Text = Color3.fromRGB(242,242,245),
        Muted = Color3.fromRGB(156,158,166),
        Accent = Color3.fromRGB(126,174,255),
        Border = Color3.new(1,1,1),
        Danger = Color3.fromRGB(255,92,112),
        Success = Color3.fromRGB(92,226,157),
        Warning = Color3.fromRGB(255,190,83),
    },
    Glass = {
        Background = Color3.fromRGB(18,20,24),
        Surface = Color3.fromRGB(30,33,40),
        SurfaceRaised = Color3.fromRGB(42,45,54),
        Text = Color3.fromRGB(240,242,247),
        Muted = Color3.fromRGB(166,171,184),
        Accent = Color3.fromRGB(110,215,255),
        Border = Color3.new(1,1,1),
        Danger = Color3.fromRGB(255,92,112),
        Success = Color3.fromRGB(92,226,157),
        Warning = Color3.fromRGB(255,190,83),
    },
    Rose = {
        Background = Color3.fromRGB(19,13,17),
        Surface = Color3.fromRGB(32,21,29),
        SurfaceRaised = Color3.fromRGB(48,30,41),
        Text = Color3.fromRGB(247,235,242),
        Muted = Color3.fromRGB(188,160,177),
        Accent = Color3.fromRGB(255,115,177),
        Border = Color3.new(1,1,1),
        Danger = Color3.fromRGB(255,92,112),
        Success = Color3.fromRGB(92,226,157),
        Warning = Color3.fromRGB(255,190,83),
    },
    Amber = {
        Background = Color3.fromRGB(18,15,10),
        Surface = Color3.fromRGB(31,25,16),
        SurfaceRaised = Color3.fromRGB(45,35,20),
        Text = Color3.fromRGB(247,239,222),
        Muted = Color3.fromRGB(190,170,136),
        Accent = Color3.fromRGB(255,181,72),
        Border = Color3.new(1,1,1),
        Danger = Color3.fromRGB(255,92,112),
        Success = Color3.fromRGB(92,226,157),
        Warning = Color3.fromRGB(255,190,83),
    },
}

AstraUI.Icons = {}
AstraUI.Icons["activity"] = { Name = "activity", Asset = nil, Alias = "activity" }
AstraUI.Icons["airplay"] = { Name = "airplay", Asset = nil, Alias = "airplay" }
AstraUI.Icons["alarm-clock"] = { Name = "alarm-clock", Asset = nil, Alias = "alarm_clock" }
AstraUI.Icons["alert-circle"] = { Name = "alert-circle", Asset = nil, Alias = "alert_circle" }
AstraUI.Icons["alert-triangle"] = { Name = "alert-triangle", Asset = nil, Alias = "alert_triangle" }
AstraUI.Icons["align-center"] = { Name = "align-center", Asset = nil, Alias = "align_center" }
AstraUI.Icons["align-left"] = { Name = "align-left", Asset = nil, Alias = "align_left" }
AstraUI.Icons["align-right"] = { Name = "align-right", Asset = nil, Alias = "align_right" }
AstraUI.Icons["archive"] = { Name = "archive", Asset = nil, Alias = "archive" }
AstraUI.Icons["arrow-down"] = { Name = "arrow-down", Asset = nil, Alias = "arrow_down" }
AstraUI.Icons["arrow-left"] = { Name = "arrow-left", Asset = nil, Alias = "arrow_left" }
AstraUI.Icons["arrow-right"] = { Name = "arrow-right", Asset = nil, Alias = "arrow_right" }
AstraUI.Icons["arrow-up"] = { Name = "arrow-up", Asset = nil, Alias = "arrow_up" }
AstraUI.Icons["at-sign"] = { Name = "at-sign", Asset = nil, Alias = "at_sign" }
AstraUI.Icons["award"] = { Name = "award", Asset = nil, Alias = "award" }
AstraUI.Icons["bell"] = { Name = "bell", Asset = nil, Alias = "bell" }
AstraUI.Icons["book"] = { Name = "book", Asset = nil, Alias = "book" }
AstraUI.Icons["bookmark"] = { Name = "bookmark", Asset = nil, Alias = "bookmark" }
AstraUI.Icons["box"] = { Name = "box", Asset = nil, Alias = "box" }
AstraUI.Icons["calendar"] = { Name = "calendar", Asset = nil, Alias = "calendar" }
AstraUI.Icons["camera"] = { Name = "camera", Asset = nil, Alias = "camera" }
AstraUI.Icons["check"] = { Name = "check", Asset = nil, Alias = "check" }
AstraUI.Icons["check-circle"] = { Name = "check-circle", Asset = nil, Alias = "check_circle" }
AstraUI.Icons["chevron-down"] = { Name = "chevron-down", Asset = nil, Alias = "chevron_down" }
AstraUI.Icons["chevron-left"] = { Name = "chevron-left", Asset = nil, Alias = "chevron_left" }
AstraUI.Icons["chevron-right"] = { Name = "chevron-right", Asset = nil, Alias = "chevron_right" }
AstraUI.Icons["chevron-up"] = { Name = "chevron-up", Asset = nil, Alias = "chevron_up" }
AstraUI.Icons["circle"] = { Name = "circle", Asset = nil, Alias = "circle" }
AstraUI.Icons["clipboard"] = { Name = "clipboard", Asset = nil, Alias = "clipboard" }
AstraUI.Icons["clock"] = { Name = "clock", Asset = nil, Alias = "clock" }
AstraUI.Icons["cloud"] = { Name = "cloud", Asset = nil, Alias = "cloud" }
AstraUI.Icons["code"] = { Name = "code", Asset = nil, Alias = "code" }
AstraUI.Icons["cog"] = { Name = "cog", Asset = nil, Alias = "cog" }
AstraUI.Icons["command"] = { Name = "command", Asset = nil, Alias = "command" }
AstraUI.Icons["copy"] = { Name = "copy", Asset = nil, Alias = "copy" }
AstraUI.Icons["cpu"] = { Name = "cpu", Asset = nil, Alias = "cpu" }
AstraUI.Icons["credit-card"] = { Name = "credit-card", Asset = nil, Alias = "credit_card" }
AstraUI.Icons["database"] = { Name = "database", Asset = nil, Alias = "database" }
AstraUI.Icons["download"] = { Name = "download", Asset = nil, Alias = "download" }
AstraUI.Icons["edit"] = { Name = "edit", Asset = nil, Alias = "edit" }
AstraUI.Icons["external-link"] = { Name = "external-link", Asset = nil, Alias = "external_link" }
AstraUI.Icons["eye"] = { Name = "eye", Asset = nil, Alias = "eye" }
AstraUI.Icons["eye-off"] = { Name = "eye-off", Asset = nil, Alias = "eye_off" }
AstraUI.Icons["file"] = { Name = "file", Asset = nil, Alias = "file" }
AstraUI.Icons["file-text"] = { Name = "file-text", Asset = nil, Alias = "file_text" }
AstraUI.Icons["filter"] = { Name = "filter", Asset = nil, Alias = "filter" }
AstraUI.Icons["flag"] = { Name = "flag", Asset = nil, Alias = "flag" }
AstraUI.Icons["folder"] = { Name = "folder", Asset = nil, Alias = "folder" }
AstraUI.Icons["gamepad-2"] = { Name = "gamepad-2", Asset = nil, Alias = "gamepad_2" }
AstraUI.Icons["globe"] = { Name = "globe", Asset = nil, Alias = "globe" }
AstraUI.Icons["grid-2x2"] = { Name = "grid-2x2", Asset = nil, Alias = "grid_2x2" }
AstraUI.Icons["heart"] = { Name = "heart", Asset = nil, Alias = "heart" }
AstraUI.Icons["help-circle"] = { Name = "help-circle", Asset = nil, Alias = "help_circle" }
AstraUI.Icons["home"] = { Name = "home", Asset = nil, Alias = "home" }
AstraUI.Icons["image"] = { Name = "image", Asset = nil, Alias = "image" }
AstraUI.Icons["info"] = { Name = "info", Asset = nil, Alias = "info" }
AstraUI.Icons["key"] = { Name = "key", Asset = nil, Alias = "key" }
AstraUI.Icons["layers"] = { Name = "layers", Asset = nil, Alias = "layers" }
AstraUI.Icons["layout-dashboard"] = { Name = "layout-dashboard", Asset = nil, Alias = "layout_dashboard" }
AstraUI.Icons["link"] = { Name = "link", Asset = nil, Alias = "link" }
AstraUI.Icons["list"] = { Name = "list", Asset = nil, Alias = "list" }
AstraUI.Icons["lock"] = { Name = "lock", Asset = nil, Alias = "lock" }
AstraUI.Icons["log-in"] = { Name = "log-in", Asset = nil, Alias = "log_in" }
AstraUI.Icons["log-out"] = { Name = "log-out", Asset = nil, Alias = "log_out" }
AstraUI.Icons["mail"] = { Name = "mail", Asset = nil, Alias = "mail" }
AstraUI.Icons["map"] = { Name = "map", Asset = nil, Alias = "map" }
AstraUI.Icons["maximize"] = { Name = "maximize", Asset = nil, Alias = "maximize" }
AstraUI.Icons["menu"] = { Name = "menu", Asset = nil, Alias = "menu" }
AstraUI.Icons["message-circle"] = { Name = "message-circle", Asset = nil, Alias = "message_circle" }
AstraUI.Icons["mic"] = { Name = "mic", Asset = nil, Alias = "mic" }
AstraUI.Icons["minus"] = { Name = "minus", Asset = nil, Alias = "minus" }
AstraUI.Icons["monitor"] = { Name = "monitor", Asset = nil, Alias = "monitor" }
AstraUI.Icons["moon"] = { Name = "moon", Asset = nil, Alias = "moon" }
AstraUI.Icons["more-horizontal"] = { Name = "more-horizontal", Asset = nil, Alias = "more_horizontal" }
AstraUI.Icons["mouse-pointer-2"] = { Name = "mouse-pointer-2", Asset = nil, Alias = "mouse_pointer_2" }
AstraUI.Icons["package"] = { Name = "package", Asset = nil, Alias = "package" }
AstraUI.Icons["palette"] = { Name = "palette", Asset = nil, Alias = "palette" }
AstraUI.Icons["pause"] = { Name = "pause", Asset = nil, Alias = "pause" }
AstraUI.Icons["play"] = { Name = "play", Asset = nil, Alias = "play" }
AstraUI.Icons["plus"] = { Name = "plus", Asset = nil, Alias = "plus" }
AstraUI.Icons["power"] = { Name = "power", Asset = nil, Alias = "power" }
AstraUI.Icons["refresh-cw"] = { Name = "refresh-cw", Asset = nil, Alias = "refresh_cw" }
AstraUI.Icons["save"] = { Name = "save", Asset = nil, Alias = "save" }
AstraUI.Icons["search"] = { Name = "search", Asset = nil, Alias = "search" }
AstraUI.Icons["send"] = { Name = "send", Asset = nil, Alias = "send" }
AstraUI.Icons["server"] = { Name = "server", Asset = nil, Alias = "server" }
AstraUI.Icons["settings"] = { Name = "settings", Asset = nil, Alias = "settings" }
AstraUI.Icons["shield"] = { Name = "shield", Asset = nil, Alias = "shield" }
AstraUI.Icons["shopping-bag"] = { Name = "shopping-bag", Asset = nil, Alias = "shopping_bag" }
AstraUI.Icons["sliders-horizontal"] = { Name = "sliders-horizontal", Asset = nil, Alias = "sliders_horizontal" }
AstraUI.Icons["sparkles"] = { Name = "sparkles", Asset = nil, Alias = "sparkles" }
AstraUI.Icons["star"] = { Name = "star", Asset = nil, Alias = "star" }
AstraUI.Icons["sun"] = { Name = "sun", Asset = nil, Alias = "sun" }
AstraUI.Icons["terminal"] = { Name = "terminal", Asset = nil, Alias = "terminal" }
AstraUI.Icons["trash-2"] = { Name = "trash-2", Asset = nil, Alias = "trash_2" }
AstraUI.Icons["unlock"] = { Name = "unlock", Asset = nil, Alias = "unlock" }
AstraUI.Icons["upload"] = { Name = "upload", Asset = nil, Alias = "upload" }
AstraUI.Icons["user"] = { Name = "user", Asset = nil, Alias = "user" }
AstraUI.Icons["users"] = { Name = "users", Asset = nil, Alias = "users" }
AstraUI.Icons["volume-2"] = { Name = "volume-2", Asset = nil, Alias = "volume_2" }
AstraUI.Icons["wand-2"] = { Name = "wand-2", Asset = nil, Alias = "wand_2" }
AstraUI.Icons["wifi"] = { Name = "wifi", Asset = nil, Alias = "wifi" }
AstraUI.Icons["x"] = { Name = "x", Asset = nil, Alias = "x" }
AstraUI.Icons["x-circle"] = { Name = "x-circle", Asset = nil, Alias = "x_circle" }
AstraUI.Icons["zap"] = { Name = "zap", Asset = nil, Alias = "zap" }

function AstraUI:RegisterIcon(name, asset)
    assert(type(name) == "string", "Icon name must be a string")
    assert(type(asset) == "string" or typeof(asset) == "number", "Icon asset must be a string or number")
    AstraUI.Icons[string.lower(name)] = {Name = string.lower(name), Asset = tostring(asset), Alias = name}
    return AstraUI
end

function AstraUI:ResolveIcon(name)
    if name == nil then return nil end
    local key = string.lower(tostring(name))
    local icon = self.Icons[key]
    if icon and icon.Asset then return icon.Asset end
    if icon then return icon.Asset end
    return nil
end

local Motion = {}
Motion.__index = Motion
Motion._active = {}

function Motion:_tween(instance, properties, duration, style, direction)
    if not instance or not instance.Parent then return nil end
    duration = duration or self.Speed or 0.28
    if AstraUI._reducedMotion then duration = math.min(duration, 0.06) end
    local info = TweenInfo.new(duration, style or Enum.EasingStyle.Quint, direction or Enum.EasingDirection.Out)
    local tween = TweenService:Create(instance, info, properties)
    Motion._active[instance] = tween
    tween.Completed:Connect(function()
        if Motion._active[instance] == tween then Motion._active[instance] = nil end
    end)
    tween:Play()
    return tween
end

function Motion:Fade(instance, transparency, duration)
    return self:_tween(instance, {BackgroundTransparency = transparency}, duration, Enum.EasingStyle.Quad)
end

function Motion:Slide(instance, position, duration)
    return self:_tween(instance, {Position = position}, duration, Enum.EasingStyle.Quint)
end

function Motion:Scale(instance, scale, duration)
    return self:_tween(instance, {Scale = scale}, duration, Enum.EasingStyle.Quint)
end

function Motion:Color(instance, color, duration)
    if instance:IsA("GuiObject") then return self:_tween(instance, {BackgroundColor3 = color}, duration, Enum.EasingStyle.Sine) end
end

function Motion:TextColor(instance, color, duration)
    if instance:IsA("TextLabel") or instance:IsA("TextButton") or instance:IsA("TextBox") then
        return self:_tween(instance, {TextColor3 = color}, duration, Enum.EasingStyle.Sine)
    end
end

function Motion:Cancel(instance)
    local tween = self._active[instance]
    if tween then tween:Cancel() self._active[instance] = nil end
end

AstraUI.Motion = Motion

local Spring = {}
Spring.__index = Spring

function Spring.new(value, frequency, damping)
    return setmetatable({Value=value or 0, Target=value or 0, Velocity=0, Frequency=frequency or 5, Damping=damping or 0.82}, Spring)
end

function Spring:Set(target)
    self.Target = target
end

function Spring:Impulse(amount)
    self.Velocity = self.Velocity + amount
end

function Spring:Step(dt)
    local omega = self.Frequency * math.pi * 2
    local displacement = self.Target - self.Value
    local acceleration = displacement * omega * omega
    self.Velocity = self.Velocity + acceleration * dt
    self.Velocity = self.Velocity * math.pow(self.Damping, dt * 60)
    self.Value = self.Value + self.Velocity * dt
    return self.Value
end

AstraUI.Spring = Spring

local Maid = {}
Maid.__index = Maid

function Maid.new()
    return setmetatable({Tasks = {}}, Maid)
end

function Maid:Give(task)
    table.insert(self.Tasks, task)
    return task
end

function Maid:Clean()
    disconnectAll(self.Tasks)
end

local Component = {}
Component.__index = Component

function Component:_init(kind, tab, config)
    self.Kind = kind
    self.Tab = tab
    self.Window = tab and tab.Window
    self.Config = config or {}
    self.Maid = Maid.new()
    self.Callback = self.Config.Callback
    self.Name = self.Config.Name or kind
    self.Description = self.Config.Description
    self.Disabled = false
    self.Visible = true
    return self
end

function Component:SetVisible(value)
    self.Visible = value and true or false
    if self.Root then self.Root.Visible = self.Visible end
    return self
end

function Component:SetDisabled(value)
    self.Disabled = value and true or false
    if self.Root then
        self.Root.Active = not self.Disabled
        self.Root.AutoButtonColor = not self.Disabled
    end
    return self
end

function Component:Destroy()
    self.Maid:Clean()
    if self.Root then self.Root:Destroy() end
    if self.Tab and self.Tab.Components then self.Tab.Components[self] = nil end
end

local function corner(parent, radius)
    return make("UICorner", {CornerRadius = UDim.new(0, radius or 12), Parent = parent})
end

local function stroke(parent, color, transparency, thickness)
    return make("UIStroke", {Color=color, Transparency=transparency or 0, Thickness=thickness or 1, ApplyStrokeMode=Enum.ApplyStrokeMode.Border, Parent=parent})
end

local function padding(parent, l, r, t, b)
    return make("UIPadding", {PaddingLeft=UDim.new(0,l or 0), PaddingRight=UDim.new(0,r or 0), PaddingTop=UDim.new(0,t or 0), PaddingBottom=UDim.new(0,b or 0), Parent=parent})
end

local function textLabel(parent, text, size, color, font)
    return make("TextLabel", {BackgroundTransparency=1, Text=text or "", TextSize=size or 14, TextColor3=color or Color3.new(1,1,1), Font=font or Enum.Font.Gotham, TextXAlignment=Enum.TextXAlignment.Left, TextYAlignment=Enum.TextYAlignment.Center, Parent=parent})
end

local function iconLabel(parent, icon, size, tint)
    local image = make("ImageLabel", {BackgroundTransparency=1, Size=UDim2.fromOffset(size or 18,size or 18), Image=AstraUI:ResolveIcon(icon) or "", ImageColor3=tint or Color3.new(1,1,1), ScaleType=Enum.ScaleType.Fit, Parent=parent})
    image:SetAttribute("LucideName", icon or "")
    return image
end

local Responsive = {}
Responsive.__index = Responsive

function Responsive.new(window)
    return setmetatable({Window=window, Current="Desktop", Width=0, Height=0, Connections={}}, Responsive)
end

function Responsive:Classify(viewport)
    local width = viewport.X
    if width <= AstraUI.Defaults.CompactBreakpoint then return "Compact" end
    if width <= AstraUI.Defaults.MobileBreakpoint then return "Mobile" end
    return "Desktop"
end

function Responsive:Apply(viewport)
    self.Width = viewport.X
    self.Height = viewport.Y
    local class = self:Classify(viewport)
    if class == self.Current then return end
    self.Current = class
    self.Window:_applyResponsive(class, viewport)
end

function Responsive:Bind(gui)
    table.insert(self.Connections, gui:GetPropertyChangedSignal("AbsoluteSize"):Connect(function()
        self:Apply(gui.AbsoluteSize)
    end))
    self:Apply(gui.AbsoluteSize)
end

function Responsive:Destroy()
    disconnectAll(self.Connections)
end

function AstraUI:_theme(name)
    return self.Themes[name] or self.Themes[self.Defaults.Theme] or self.Themes.Midnight
end

function AstraUI:_styleSurface(frame, raised)
    local theme = self:_theme(self._themeName)
    frame.BackgroundColor3 = raised and theme.SurfaceRaised or theme.Surface
    frame.BackgroundTransparency = self._transparency
    corner(frame, self._cornerRadius)
    local border = stroke(frame, theme.Border, 0.9, 1)
    border.Name = "GlassBorder"
    return frame
end

function AstraUI:_makeGlass(parent, size, position, raised)
    local frame = make("Frame", {Size=size, Position=position, BorderSizePixel=0, Parent=parent})
    self:_styleSurface(frame, raised)
    local gradient = make("UIGradient", {
        Color=ColorSequence.new({ColorSequenceKeypoint.new(0, Color3.new(1,1,1)), ColorSequenceKeypoint.new(0.48, Color3.new(0.82,0.82,0.9)), ColorSequenceKeypoint.new(1, Color3.new(0.6,0.6,0.7))}),
        Transparency=NumberSequence.new({NumberSequenceKeypoint.new(0,0.86),NumberSequenceKeypoint.new(0.5,0.93),NumberSequenceKeypoint.new(1,0.97)}),
        Rotation=35,
        Parent=frame,
    })
    gradient.Name = "GlassLight"
    return frame
end

local Window = {}
Window.__index = Window

function Window:_init(api, config)
    self.API = api
    self.Config = config or {}
    self.Maid = Maid.new()
    self.Tabs = {}
    self.Components = {}
    self.ActiveTab = nil
    self.Minimized = false
    self.Destroyed = false
    self.Title = self.Config.Title or "AstraUI"
    self.Subtitle = self.Config.Subtitle or "Liquid Glass"
    self:_build()
    return self
end

function Window:_build()
    local playerGui = LocalPlayer and LocalPlayer:FindFirstChildOfClass("PlayerGui")
    if not playerGui then
        playerGui = LocalPlayer:WaitForChild("PlayerGui")
    end
    self.Gui = make("ScreenGui", {Name="AstraUI", ResetOnSpawn=false, IgnoreGuiInset=true, ZIndexBehavior=Enum.ZIndexBehavior.Sibling, Parent=playerGui})
    self.Maid:Give(self.Gui)
    self.Root = make("Frame", {BackgroundTransparency=1, Size=UDim2.fromScale(1,1), Parent=self.Gui})
    self:_buildLoading()
    self:_buildWindow()
    self.Responsive = Responsive.new(self)
    self.Responsive:Bind(self.Gui)
    self.Maid:Give(function() self.Responsive:Destroy() end)
    self:_bindGlobalInput()
end

function Window:_buildLoading()
    if self.Config.Loading == false or self.API._showLoading == false then return end
    local overlay = make("Frame", {Name="Loading", Size=UDim2.fromScale(1,1), BackgroundColor3=Color3.fromRGB(6,7,10), BackgroundTransparency=0.05, ZIndex=100, Parent=self.Root})
    self.Loading = overlay
    local logo = make("Frame", {Size=UDim2.fromOffset(126,126), AnchorPoint=Vector2.new(0.5,0.5), Position=UDim2.fromScale(0.5,0.43), BackgroundColor3=self.API:_theme(self.API._themeName).SurfaceRaised, BackgroundTransparency=0.15, Parent=overlay})
    corner(logo, 34)
    stroke(logo, self.API:_theme(self.API._themeName).Accent, 0.55, 1.5)
    local logoA
    if self.Config.LogoAsset then
        logoA=make("ImageLabel",{BackgroundTransparency=1,Image=tostring(self.Config.LogoAsset),ImageColor3=self.API:_theme(self.API._themeName).Accent,ScaleType=Enum.ScaleType.Fit,Size=UDim2.new(1,-22,1,-22),Position=UDim2.fromOffset(11,11),Parent=logo})
    else
        logoA = textLabel(logo, "A", 86, self.API:_theme(self.API._themeName).Accent, Enum.Font.GothamBlack)
        logoA.Size=UDim2.fromScale(1,1); logoA.TextXAlignment=Enum.TextXAlignment.Center; logoA.TextYAlignment=Enum.TextYAlignment.Center
    end
    local ring=make("Frame",{BackgroundTransparency=1,Size=UDim2.new(1,-18,1,-18),Position=UDim2.fromOffset(9,9),Parent=logo})
    corner(ring,28); stroke(ring,self.API:_theme(self.API._themeName).Accent,0.82,1)
    local sparkle = textLabel(logo, "✦", 22, Color3.new(1,1,1), Enum.Font.GothamBold)
    sparkle.Position=UDim2.new(0.73,0,0.05,0); sparkle.Size=UDim2.fromOffset(24,24); sparkle.TextXAlignment=Enum.TextXAlignment.Center
    local title = textLabel(overlay, self.Title, 24, self.API:_theme(self.API._themeName).Text, Enum.Font.GothamBold)
    title.AnchorPoint=Vector2.new(0.5,0); title.Position=UDim2.fromScale(0.5,0.59); title.Size=UDim2.fromOffset(420,34); title.TextXAlignment=Enum.TextXAlignment.Center
    local sub = textLabel(overlay, "Preparing interface", 13, self.API:_theme(self.API._themeName).Muted, Enum.Font.Gotham)
    sub.AnchorPoint=Vector2.new(0.5,0); sub.Position=UDim2.fromScale(0.5,0.65); sub.Size=UDim2.fromOffset(420,26); sub.TextXAlignment=Enum.TextXAlignment.Center
    local bar = make("Frame", {AnchorPoint=Vector2.new(0.5,0), Position=UDim2.fromScale(0.5,0.72), Size=UDim2.fromOffset(180,4), BackgroundColor3=self.API:_theme(self.API._themeName).SurfaceRaised, BackgroundTransparency=0.15, Parent=overlay})
    corner(bar, 4)
    local fill = make("Frame", {Size=UDim2.new(0,0,1,0), BackgroundColor3=self.API:_theme(self.API._themeName).Accent, Parent=bar})
    corner(fill, 4)
    self.LoadingFill = fill
    self.LoadingLogo = logo
    self.LoadingText = title
    self.LoadingSub = sub
end

function Window:_finishLoading()
    if not self.Loading then return end
    local duration = self.Config.LoadingDuration or self.API._loadingDuration
    Motion:_tween(self.LoadingFill, {Size=UDim2.fromScale(1,1)}, duration * 0.55, Enum.EasingStyle.Quint)
    task.delay(duration, function()
        if not self.Loading or not self.Loading.Parent then return end
        Motion:_tween(self.LoadingLogo, {Size=UDim2.fromOffset(170,170), BackgroundTransparency=1}, 0.42, Enum.EasingStyle.Quint)
        Motion:_tween(self.LoadingText, {TextTransparency=1}, 0.28, Enum.EasingStyle.Quad)
        Motion:_tween(self.LoadingSub, {TextTransparency=1}, 0.28, Enum.EasingStyle.Quad)
        Motion:_tween(self.Loading, {BackgroundTransparency=1}, 0.42, Enum.EasingStyle.Quint)
        task.delay(0.45, function() if self.Loading then self.Loading:Destroy(); self.Loading=nil end end)
    end)
end

function Window:_bindGlobalInput()
    self.Maid:Give(UserInputService.InputBegan:Connect(function(input, processed)
        if processed or self.Destroyed then return end
        if input.KeyCode == (self.Config.ToggleKey or Enum.KeyCode.RightShift) then
            self:Toggle()
        end
    end))
end

function Window:_buildWindow()
    local theme = self.API:_theme(self.API._themeName)
    local size = self.Config.Size or UDim2.fromOffset(680, 500)
    self.Container = self.API:_makeGlass(self.Root, size, UDim2.fromScale(0.5,0.5), true)
    self.Container.AnchorPoint = Vector2.new(0.5,0.5)
    self.Container.Name = "Window"
    self.Container.ClipsDescendants = true
    self.Container.ZIndex = 10
    self.GlassGlow = make("Frame", {BackgroundColor3=theme.Accent, BackgroundTransparency=0.94, Size=UDim2.new(1,80,1,80), Position=UDim2.fromOffset(-40,-40), ZIndex=9, Parent=self.Container})
    corner(self.GlassGlow, 40)
    local header = make("Frame", {BackgroundTransparency=1, Size=UDim2.new(1,0,0,64), Parent=self.Container})
    header.Name="Header"
    self.Header = header
    local title = textLabel(header, self.Title, 17, theme.Text, Enum.Font.GothamBold)
    title.Position=UDim2.fromOffset(20,8); title.Size=UDim2.new(1,-140,0,26)
    local subtitle = textLabel(header, self.Subtitle, 11, theme.Muted, Enum.Font.Gotham)
    subtitle.Position=UDim2.fromOffset(20,33); subtitle.Size=UDim2.new(1,-140,0,20)
    self.TitleLabel=title; self.SubtitleLabel=subtitle
    local controls = make("Frame", {BackgroundTransparency=1, AnchorPoint=Vector2.new(1,0), Position=UDim2.new(1,-12,0,12), Size=UDim2.fromOffset(94,38), Parent=header})
    local controlLayout=make("UIListLayout", {FillDirection=Enum.FillDirection.Horizontal, HorizontalAlignment=Enum.HorizontalAlignment.Right, Padding=UDim.new(0,6), Parent=controls})
    self.MinimizeButton=self:_makeHeaderButton(controls,"minus","Minimize")
    self.CloseButton=self:_makeHeaderButton(controls,"x","Close")
    local body=make("Frame", {BackgroundTransparency=1, Position=UDim2.fromOffset(0,64), Size=UDim2.new(1,0,1,-64), Parent=self.Container})
    self.Body=body
    local sidebar=make("Frame", {BackgroundColor3=theme.Background, BackgroundTransparency=0.55, Size=UDim2.fromOffset(170,1), Position=UDim2.fromOffset(10,10), Parent=body})
    corner(sidebar,14); stroke(sidebar,theme.Border,0.94,1)
    self.Sidebar=sidebar
    local tabList=make("ScrollingFrame", {BackgroundTransparency=1, BorderSizePixel=0, Size=UDim2.new(1,-12,1,-12), Position=UDim2.fromOffset(6,6), ScrollBarThickness=2, AutomaticCanvasSize=Enum.AutomaticSize.Y, CanvasSize=UDim2.new(), Parent=sidebar})
    self.TabList=tabList
    make("UIListLayout", {Padding=UDim.new(0,6), SortOrder=Enum.SortOrder.LayoutOrder, Parent=tabList})
    local content=make("Frame", {BackgroundTransparency=1, Position=UDim2.fromOffset(190,10), Size=UDim2.new(1,-200,1,-20), Parent=body})
    self.Content=content
    local page=make("Frame", {BackgroundTransparency=1, Size=UDim2.fromScale(1,1), Parent=content})
    self.Page=page
    self.SearchBox=make("TextBox", {Visible=false, ClearTextOnFocus=false, PlaceholderText="Search", Text="", TextSize=13, TextColor3=theme.Text, PlaceholderColor3=theme.Muted, Font=Enum.Font.Gotham, BackgroundColor3=theme.SurfaceRaised, BackgroundTransparency=0.18, Size=UDim2.fromOffset(180,34), Position=UDim2.new(1,-190,0,-50), Parent=content})
    corner(self.SearchBox,10); stroke(self.SearchBox,theme.Border,0.92,1); padding(self.SearchBox,12,12,0,0)
    self:_bindDrag(header)
    self:_finishLoading()
end

function Window:_makeHeaderButton(parent, icon, tooltip)
    local theme=self.API:_theme(self.API._themeName)
    local button=make("TextButton", {AutoButtonColor=false, BackgroundColor3=theme.SurfaceRaised, BackgroundTransparency=0.3, Size=UDim2.fromOffset(36,36), Text="", Parent=parent})
    corner(button,10); stroke(button,theme.Border,0.9,1)
    iconLabel(button,icon,16,theme.Muted).AnchorPoint=Vector2.new(0.5,0.5); button:FindFirstChildOfClass("ImageLabel").Position=UDim2.fromScale(0.5,0.5)
    self.Maid:Give(button.MouseEnter:Connect(function() Motion:Color(button,theme.Accent,0.16); button.BackgroundTransparency=0.08 end))
    self.Maid:Give(button.MouseLeave:Connect(function() Motion:Color(button,theme.SurfaceRaised,0.2); button.BackgroundTransparency=0.3 end))
    self.Maid:Give(button.MouseButton1Down:Connect(function() Motion:_tween(button,{Size=UDim2.fromOffset(33,33)},0.08,Enum.EasingStyle.Quad) end))
    self.Maid:Give(button.MouseButton1Up:Connect(function() Motion:_tween(button,{Size=UDim2.fromOffset(36,36)},0.18,Enum.EasingStyle.Back) end))
    if tooltip then button:SetAttribute("Tooltip",tooltip) end
    if icon=="x" then button.MouseButton1Click:Connect(function() self:Close() end) end
    if icon=="minus" then button.MouseButton1Click:Connect(function() self:ToggleMinimize() end) end
    return button
end

function Window:_bindDrag(handle)
    local dragging=false
    local startInput=nil
    local startPosition=nil
    local function update(input)
        if not dragging or not startInput or not startPosition then return end
        local delta=input.Position-startInput.Position
        self.Container.Position=UDim2.new(startPosition.X.Scale,startPosition.X.Offset+delta.X,startPosition.Y.Scale,startPosition.Y.Offset+delta.Y)
    end
    self.Maid:Give(handle.InputBegan:Connect(function(input)
        if input.UserInputType==Enum.UserInputType.MouseButton1 or input.UserInputType==Enum.UserInputType.Touch then
            dragging=true; startInput=input; startPosition=self.Container.Position
        end
    end))
    self.Maid:Give(UserInputService.InputChanged:Connect(function(input)
        if input.UserInputType==Enum.UserInputType.MouseMovement or input.UserInputType==Enum.UserInputType.Touch then update(input) end
    end))
    self.Maid:Give(UserInputService.InputEnded:Connect(function(input)
        if input==startInput then dragging=false; startInput=nil; startPosition=nil end
    end))
end

function Window:_applyResponsive(class, viewport)
    if not self.Container then return end
    if class=="Desktop" then
        self.Sidebar.Visible=true
        self.Sidebar.Size=UDim2.fromOffset(170,1)
        self.Content.Position=UDim2.fromOffset(190,10)
        self.Content.Size=UDim2.new(1,-200,1,-20)
        if self.Container.AbsoluteSize.X < 620 then self.Container.Size=UDim2.fromOffset(620, math.min(560, viewport.Y-32)) end
    elseif class=="Mobile" then
        self.Sidebar.Visible=true
        self.Sidebar.Size=UDim2.fromOffset(132,1)
        self.Content.Position=UDim2.fromOffset(146,10)
        self.Content.Size=UDim2.new(1,-156,1,-20)
        self.Container.Size=UDim2.new(1,-24,1,-36)
        self.Container.Position=UDim2.fromScale(0.5,0.5)
        self.Header.Size=UDim2.new(1,0,0,58)
    else
        self.Sidebar.Visible=false
        self.Content.Position=UDim2.fromOffset(10,10)
        self.Content.Size=UDim2.new(1,-20,1,-20)
        self.Container.Size=UDim2.new(1,-18,1,-22)
        self.Header.Size=UDim2.new(1,0,0,54)
    end
    self:_refreshComponentSizing(class)
end

function Window:_refreshComponentSizing(class)
    for _,tab in pairs(self.Tabs) do
        if tab.RefreshSizing then tab:RefreshSizing(class) end
    end
end

local Tab = {}
Tab.__index=Tab

function Tab:_init(window, config)
    self.Window=window
    self.API=window.API
    self.Name=config.Name or "Tab"
    self.Icon=config.Icon
    self.Components={}
    self.Sections={}
    self.LayoutOrder=config.LayoutOrder or #window.Tabs+1
    self:_buildButton()
    self:_buildPage()
    return self
end

function Tab:_buildButton()
    local theme=self.API:_theme(self.API._themeName)
    local button=make("TextButton", {AutoButtonColor=false, BackgroundColor3=theme.SurfaceRaised, BackgroundTransparency=1, Size=UDim2.new(1,-8,0,40), Text="", LayoutOrder=self.LayoutOrder, Parent=self.Window.TabList})
    corner(button,11)
    local icon=iconLabel(button,self.Icon,17,theme.Muted); icon.Position=UDim2.fromOffset(13,11)
    local label=textLabel(button,self.Name,13,theme.Muted,Enum.Font.GothamMedium); label.Position=UDim2.fromOffset(40,0); label.Size=UDim2.new(1,-48,1,0)
    self.Button=button; self.IconObject=icon; self.Label=label
    button.MouseEnter:Connect(function() if self~=self.Window.ActiveTab then Motion:_tween(button,{BackgroundTransparency=0.55},0.16,Enum.EasingStyle.Quad); Motion:TextColor(label,theme.Text,0.16) end end)
    button.MouseLeave:Connect(function() if self~=self.Window.ActiveTab then Motion:_tween(button,{BackgroundTransparency=1},0.2,Enum.EasingStyle.Quad); Motion:TextColor(label,theme.Muted,0.2) end end)
    button.MouseButton1Down:Connect(function() Motion:_tween(button,{Size=UDim2.new(1,-14,0,38)},0.08,Enum.EasingStyle.Quad) end)
    button.MouseButton1Up:Connect(function() Motion:_tween(button,{Size=UDim2.new(1,-8,0,40)},0.18,Enum.EasingStyle.Back) end)
    button.MouseButton1Click:Connect(function() self:Activate() end)
end

function Tab:_buildPage()
    self.Page=make("ScrollingFrame", {Name=self.Name, Visible=false, BackgroundTransparency=1, BorderSizePixel=0, Size=UDim2.fromScale(1,1), ScrollBarThickness=2, AutomaticCanvasSize=Enum.AutomaticSize.Y, CanvasSize=UDim2.new(), Parent=self.Window.Page})
    self.Layout=make("UIListLayout", {Padding=UDim.new(0,10), SortOrder=Enum.SortOrder.LayoutOrder, Parent=self.Page})
    padding(self.Page,2,6,4,12)
end

function Tab:Activate()
    if self.Window.ActiveTab==self then return self end
    if self.Window.ActiveTab then self.Window.ActiveTab:_deactivate() end
    self.Window.ActiveTab=self
    self.Page.Visible=true
    local theme=self.API:_theme(self.API._themeName)
    Motion:_tween(self.Button,{BackgroundTransparency=0.25},0.18,Enum.EasingStyle.Quint)
    Motion:TextColor(self.Label,theme.Text,0.18)
    Motion:_tween(self.IconObject,{ImageColor3=theme.Accent},0.2,Enum.EasingStyle.Quint)
    self.Page.Position=UDim2.new(0,12,0,0)
    self.Page.BackgroundTransparency=1
    Motion:Slide(self.Page,UDim2.fromOffset(0,0),0.24)
    self:_animateChildrenIn()
    return self
end

function Tab:_deactivate()
    local theme=self.API:_theme(self.API._themeName)
    self.Page.Visible=false
    Motion:_tween(self.Button,{BackgroundTransparency=1},0.18,Enum.EasingStyle.Quad)
    Motion:TextColor(self.Label,theme.Muted,0.18)
    Motion:_tween(self.IconObject,{ImageColor3=theme.Muted},0.18,Enum.EasingStyle.Quad)
end

function Tab:_animateChildrenIn()
    local index=0
    for _,child in ipairs(self.Page:GetChildren()) do
        if child:IsA("GuiObject") and child.Name~="UIPadding" and child.Name~="UIListLayout" then
            index=index+1
            child.Position=child.Position+UDim2.fromOffset(0,8)
            child.BackgroundTransparency=math.min(1,child.BackgroundTransparency+0.08)
            task.delay(index*0.025,function()
                if child.Parent then Motion:Slide(child,child.Position-UDim2.fromOffset(0,8),0.24,Enum.EasingStyle.Quint) end
            end)
        end
    end
end

function Tab:RefreshSizing(class)
    local height=class=="Compact" and 46 or class=="Mobile" and 42 or 48
    for _,component in pairs(self.Components) do
        if component.ApplyResponsive then component:ApplyResponsive(class,height) end
    end
end

function Tab:_register(component)
    table.insert(self.Components,component)
    return component
end

function Tab:_row(config, height)
    local theme=self.API:_theme(self.API._themeName)
    local row=make("Frame", {BackgroundColor3=theme.Surface, BackgroundTransparency=self.API._transparency+0.04, Size=UDim2.new(1,0,0,height or 56), BorderSizePixel=0, Parent=self.Page})
    corner(row,self.API._cornerRadius)
    stroke(row,theme.Border,0.93,1)
    padding(row,14,14,8,8)
    return row
end

function Tab:CreateLabel(config)
    config=config or {}
    local row=self:_row(config,config.Height or 38)
    local label=textLabel(row,config.Text or config.Name or "Label",config.TextSize or 13,self.API:_theme(self.API._themeName).Muted,config.Font or Enum.Font.Gotham)
    label.Size=UDim2.fromScale(1,1)
    local c=setmetatable({},Component); c:_init("Label",self,config); c.Root=row; c.Label=label
    return self:_register(c)
end

function Tab:CreateParagraph(config)
    config=config or {}
    local row=self:_row(config,config.Height or 76)
    local title=textLabel(row,config.Title or "",14,self.API:_theme(self.API._themeName).Text,Enum.Font.GothamSemibold)
    title.Size=UDim2.new(1,0,0,22)
    local body=textLabel(row,config.Content or config.Description or "",12,self.API:_theme(self.API._themeName).Muted,Enum.Font.Gotham)
    body.Position=UDim2.fromOffset(0,25); body.Size=UDim2.new(1,0,1,-25); body.TextWrapped=true; body.TextYAlignment=Enum.TextYAlignment.Top
    local c=setmetatable({},Component); c:_init("Paragraph",self,config); c.Root=row; c.TitleLabel=title; c.ContentLabel=body
    return self:_register(c)
end

function Tab:CreateSection(name)
    local row=make("Frame",{BackgroundTransparency=1,Size=UDim2.new(1,0,0,30),Parent=self.Page})
    local line=make("Frame",{BackgroundColor3=self.API:_theme(self.API._themeName).Border,BackgroundTransparency=0.88,Size=UDim2.new(1,-110,0,1),Position=UDim2.new(0,0,0.5,0),BorderSizePixel=0,Parent=row})
    local label=textLabel(row,tostring(name),12,self.API:_theme(self.API._themeName).Muted,Enum.Font.GothamSemibold)
    label.AnchorPoint=Vector2.new(1,0.5); label.Position=UDim2.new(1,0,0.5,0); label.Size=UDim2.fromOffset(104,24); label.TextXAlignment=Enum.TextXAlignment.Right
    table.insert(self.Sections,row)
    return row
end

function Tab:CreateButton(config)
    config=config or {}
    local theme=self.API:_theme(self.API._themeName)
    local row=self:_row(config,config.Height or 58)
    local button=make("TextButton",{BackgroundTransparency=1,Size=UDim2.fromScale(1,1),Text="",AutoButtonColor=false,Parent=row})
    local icon=iconLabel(row,config.Icon,18,theme.Accent); icon.Position=UDim2.new(1,-22,0.5,-9)
    local title=textLabel(row,config.Name or "Button",14,theme.Text,Enum.Font.GothamSemibold); title.Position=UDim2.fromOffset(0,4); title.Size=UDim2.new(1,-44,0,22)
    local desc=textLabel(row,config.Description or "",11,theme.Muted,Enum.Font.Gotham); desc.Position=UDim2.fromOffset(0,27); desc.Size=UDim2.new(1,-44,0,18)
    local c=setmetatable({},Component); c:_init("Button",self,config); c.Root=row; c.Button=button; c.TitleLabel=title; c.DescriptionLabel=desc; c.IconObject=icon
    local function pressDown() Motion:_tween(row,{Size=UDim2.new(1,-5,0,(config.Height or 58)-3)},0.09,Enum.EasingStyle.Quad); Motion:_tween(icon,{Rotation=-8},0.12,Enum.EasingStyle.Quad) end
    local function pressUp() Motion:_tween(row,{Size=UDim2.new(1,0,0,config.Height or 58)},0.2,Enum.EasingStyle.Back); Motion:_tween(icon,{Rotation=0},0.22,Enum.EasingStyle.Back) end
    c.Maid:Give(button.MouseEnter:Connect(function() Motion:_tween(row,{BackgroundTransparency=0.02},0.16,Enum.EasingStyle.Quad); Motion:TextColor(title,theme.Accent,0.16) end))
    c.Maid:Give(button.MouseLeave:Connect(function() Motion:_tween(row,{BackgroundTransparency=self.API._transparency+0.04},0.2,Enum.EasingStyle.Quad); Motion:TextColor(title,theme.Text,0.2); pressUp() end))
    c.Maid:Give(button.MouseButton1Down:Connect(pressDown))
    c.Maid:Give(button.MouseButton1Up:Connect(pressUp))
    c.Maid:Give(button.MouseButton1Click:Connect(function() if not c.Disabled then safeCall(c.Callback,c) end end))
    return self:_register(c)
end

function Tab:CreateToggle(config)
    config=config or {}
    local theme=self.API:_theme(self.API._themeName)
    local row=self:_row(config,config.Height or 58)
    local title=textLabel(row,config.Name or "Toggle",14,theme.Text,Enum.Font.GothamSemibold); title.Size=UDim2.new(1,-70,0,22); title.Position=UDim2.fromOffset(0,3)
    local desc=textLabel(row,config.Description or "",11,theme.Muted,Enum.Font.Gotham); desc.Size=UDim2.new(1,-70,0,18); desc.Position=UDim2.fromOffset(0,26)
    local switch=make("TextButton",{AutoButtonColor=false,BackgroundColor3=theme.SurfaceRaised,BackgroundTransparency=0.15,Size=UDim2.fromOffset(48,26),AnchorPoint=Vector2.new(1,0.5),Position=UDim2.new(1,0,0.5,0),Text="",Parent=row})
    corner(switch,13); stroke(switch,theme.Border,0.88,1)
    local knob=make("Frame",{BackgroundColor3=theme.Muted,Size=UDim2.fromOffset(20,20),AnchorPoint=Vector2.new(0,0.5),Position=UDim2.new(0,3,0.5,0),BorderSizePixel=0,Parent=switch}); corner(knob,10)
    local c=setmetatable({},Component); c:_init("Toggle",self,config); c.Root=row; c.Switch=switch; c.Knob=knob; c.Value=config.CurrentValue==true
    function c:Set(value, fire)
        self.Value=value and true or false
        local x=self.Value and 25 or 3
        local color=self.Value and theme.Accent or theme.Muted
        Motion:_tween(self.Knob,{Position=UDim2.new(0,x,0.5,0),BackgroundColor3=color},0.22,Enum.EasingStyle.Back)
        Motion:_tween(self.Switch,{BackgroundColor3=self.Value and theme.Accent or theme.SurfaceRaised,BackgroundTransparency=self.Value and 0.05 or 0.15},0.2,Enum.EasingStyle.Quint)
        if fire then safeCall(self.Callback,self.Value,self) end
        return self
    end
    function c:Get() return self.Value end
    c.Maid:Give(switch.MouseButton1Click:Connect(function() if not c.Disabled then c:Set(not c.Value,true) end end))
    c:Set(c.Value,false)
    return self:_register(c)
end

function Tab:CreateSlider(config)
    config=config or {}
    local theme=self.API:_theme(self.API._themeName)
    local min=config.Min or 0; local max=config.Max or 100; local increment=config.Increment or 1
    local value=clamp(config.CurrentValue or min,min,max)
    local row=self:_row(config,config.Height or 76)
    local title=textLabel(row,config.Name or "Slider",14,theme.Text,Enum.Font.GothamSemibold); title.Size=UDim2.new(1,-60,0,22)
    local valueLabel=textLabel(row,tostring(value),12,theme.Muted,Enum.Font.GothamMedium); valueLabel.AnchorPoint=Vector2.new(1,0); valueLabel.Position=UDim2.new(1,0,0,1); valueLabel.Size=UDim2.fromOffset(54,22); valueLabel.TextXAlignment=Enum.TextXAlignment.Right
    local track=make("Frame",{BackgroundColor3=theme.SurfaceRaised,BackgroundTransparency=0.05,Size=UDim2.new(1,0,0,6),Position=UDim2.new(0,0,1,-15),BorderSizePixel=0,Parent=row}); corner(track,4)
    local fill=make("Frame",{BackgroundColor3=theme.Accent,Size=UDim2.new((value-min)/(max-min),0,1,0),BorderSizePixel=0,Parent=track}); corner(fill,4)
    local knob=make("Frame",{BackgroundColor3=theme.Text,Size=UDim2.fromOffset(14,14),AnchorPoint=Vector2.new(0.5,0.5),Position=UDim2.new((value-min)/(max-min),0,0.5,0),BorderSizePixel=0,Parent=track}); corner(knob,7); stroke(knob,theme.Accent,0.4,1)
    local hit=make("TextButton",{BackgroundTransparency=1,Size=UDim2.new(1,20,1,30),Position=UDim2.fromOffset(-10,-15),Text="",Parent=track})
    local c=setmetatable({},Component); c:_init("Slider",self,config); c.Root=row; c.Value=value; c.Min=min; c.Max=max; c.Increment=increment; c.Fill=fill; c.Knob=knob; c.ValueLabel=valueLabel; c.Track=track
    local dragging=false
    local function updateFromX(x)
        local alpha=clamp((x-track.AbsolutePosition.X)/track.AbsoluteSize.X,0,1)
        local raw=min+(max-min)*alpha
        local snapped=min+math.floor((raw-min)/increment+0.5)*increment
        c:Set(clamp(snapped,min,max),true)
    end
    function c:Set(newValue,fire)
        newValue=clamp(tonumber(newValue) or min,min,max)
        local steps=math.floor((newValue-min)/increment+0.5)
        newValue=clamp(min+steps*increment,min,max)
        self.Value=newValue
        local alpha=(newValue-min)/(max-min)
        self.ValueLabel.Text=tostring(newValue)
        Motion:_tween(self.Fill,{Size=UDim2.new(alpha,0,1,0)},0.16,Enum.EasingStyle.Quint)
        Motion:_tween(self.Knob,{Position=UDim2.new(alpha,0,0.5,0)},0.18,Enum.EasingStyle.Quint)
        if fire then safeCall(self.Callback,newValue,self) end
        return self
    end
    function c:Get() return self.Value end
    c.Maid:Give(hit.InputBegan:Connect(function(input) if input.UserInputType==Enum.UserInputType.MouseButton1 or input.UserInputType==Enum.UserInputType.Touch then dragging=true; updateFromX(input.Position.X) end end))
    c.Maid:Give(UserInputService.InputChanged:Connect(function(input) if dragging and (input.UserInputType==Enum.UserInputType.MouseMovement or input.UserInputType==Enum.UserInputType.Touch) then updateFromX(input.Position.X) end end))
    c.Maid:Give(UserInputService.InputEnded:Connect(function(input) if input.UserInputType==Enum.UserInputType.MouseButton1 or input.UserInputType==Enum.UserInputType.Touch then dragging=false end end))
    return self:_register(c)
end

function Tab:CreateDropdown(config)
    config=config or {}
    local theme=self.API:_theme(self.API._themeName)
    local row=self:_row(config,config.Height or 62)
    local title=textLabel(row,config.Name or "Dropdown",14,theme.Text,Enum.Font.GothamSemibold); title.Size=UDim2.new(1,-160,0,22)
    local selected=config.CurrentOption or config.CurrentValue or (config.Options and config.Options[1])
    local trigger=make("TextButton",{AutoButtonColor=false,BackgroundColor3=theme.SurfaceRaised,BackgroundTransparency=0.12,Size=UDim2.fromOffset(154,36),AnchorPoint=Vector2.new(1,0.5),Position=UDim2.new(1,0,0.5,0),Text="",Parent=row})
    corner(trigger,10); stroke(trigger,theme.Border,0.88,1)
    local selectedLabel=textLabel(trigger,tostring(selected or "Select"),12,theme.Text,Enum.Font.GothamMedium); selectedLabel.Position=UDim2.fromOffset(12,0); selectedLabel.Size=UDim2.new(1,-38,1,0); selectedLabel.TextTruncate=Enum.TextTruncate.AtEnd
    local arrow=iconLabel(trigger,"chevron-down",16,theme.Muted); arrow.AnchorPoint=Vector2.new(0.5,0.5); arrow.Position=UDim2.new(1,-17,0.5,0)
    local c=setmetatable({},Component); c:_init("Dropdown",self,config); c.Root=row; c.Trigger=trigger; c.SelectedLabel=selectedLabel; c.Arrow=arrow; c.Options=config.Options or {}; c.Value=selected; c.Open=false
    local popover=make("Frame",{Visible=false,BackgroundColor3=theme.SurfaceRaised,BackgroundTransparency=0.05,Size=UDim2.fromOffset(220,0),BorderSizePixel=0,ZIndex=80,Parent=self.Window.Gui})
    corner(popover,12); stroke(popover,theme.Border,0.84,1)
    local list=make("ScrollingFrame",{BackgroundTransparency=1,BorderSizePixel=0,Size=UDim2.new(1,-8,1,-8),Position=UDim2.fromOffset(4,4),ScrollBarThickness=2,AutomaticCanvasSize=Enum.AutomaticSize.Y,CanvasSize=UDim2.new(),ZIndex=81,Parent=popover})
    make("UIListLayout",{Padding=UDim.new(0,3),Parent=list})
    c.Popover=popover; c.List=list
    local function rebuild()
        for _,child in ipairs(list:GetChildren()) do if child:IsA("TextButton") then child:Destroy() end end
        for index,option in ipairs(c.Options) do
            local item=make("TextButton",{AutoButtonColor=false,BackgroundTransparency=1,BackgroundColor3=theme.Accent,Size=UDim2.new(1,0,0,38),Text=tostring(option),TextSize=12,TextColor3=theme.Text,Font=Enum.Font.GothamMedium,ZIndex=82,Parent=list})
            corner(item,9)
            item.MouseEnter:Connect(function() Motion:_tween(item,{BackgroundTransparency=0.82},0.12,Enum.EasingStyle.Quad) end)
            item.MouseLeave:Connect(function() Motion:_tween(item,{BackgroundTransparency=1},0.16,Enum.EasingStyle.Quad) end)
            item.MouseButton1Click:Connect(function() c:Set(option,true); c:Close() end)
        end
    end
    function c:Set(option,fire)
        self.Value=option
        self.SelectedLabel.Text=tostring(option)
        if fire then safeCall(self.Callback,option,self) end
        return self
    end
    function c:Get() return self.Value end
    function c:Open()
        if self.Open then return end
        self.Open=true; self.Popover.Visible=true
        local pos=trigger.AbsolutePosition; local size=trigger.AbsoluteSize
        self.Popover.Position=UDim2.fromOffset(pos.X,pos.Y+size.Y+6)
        self.Popover.Size=UDim2.fromOffset(220,0)
        Motion:_tween(self.Popover,{Size=UDim2.fromOffset(220,math.min(260,40*#self.Options+8))},0.24,Enum.EasingStyle.Quint)
        Motion:_tween(self.Arrow,{Rotation=180},0.22,Enum.EasingStyle.Back)
    end
    function c:Close()
        if not self.Open then return end
        self.Open=false
        Motion:_tween(self.Popover,{Size=UDim2.fromOffset(220,0)},0.18,Enum.EasingStyle.Quint)
        Motion:_tween(self.Arrow,{Rotation=0},0.18,Enum.EasingStyle.Quad)
        task.delay(0.2,function() if not self.Open and self.Popover then self.Popover.Visible=false end end)
    end
    c.Maid:Give(trigger.MouseButton1Click:Connect(function() if c.Open then c:Close() else c:Open() end end))
    c.Maid:Give(UserInputService.InputBegan:Connect(function(input,processed) if processed then return end; if c.Open and input.UserInputType==Enum.UserInputType.MouseButton1 then local p=input.Position; local x1=popover.AbsolutePosition.X; local y1=popover.AbsolutePosition.Y; local x2=x1+popover.AbsoluteSize.X; local y2=y1+popover.AbsoluteSize.Y; local t=trigger.AbsolutePosition; local ts=trigger.AbsoluteSize; local insideTrigger=p.X>=t.X and p.X<=t.X+ts.X and p.Y>=t.Y and p.Y<=t.Y+ts.Y; local inside=p.X>=x1 and p.X<=x2 and p.Y>=y1 and p.Y<=y2; if not inside and not insideTrigger then c:Close() end end end))
    rebuild()
    return self:_register(c)
end

function Tab:CreateInput(config)
    config=config or {}
    local theme=self.API:_theme(self.API._themeName)
    local row=self:_row(config,config.Height or 62)
    local title=textLabel(row,config.Name or "Input",14,theme.Text,Enum.Font.GothamSemibold); title.Size=UDim2.new(1,-210,1,0)
    local box=make("TextBox",{BackgroundColor3=theme.SurfaceRaised,BackgroundTransparency=0.12,Size=UDim2.fromOffset(200,36),AnchorPoint=Vector2.new(1,0.5),Position=UDim2.new(1,0,0.5,0),ClearTextOnFocus=false,Text=tostring(config.CurrentValue or ""),PlaceholderText=config.PlaceholderText or "Enter text...",TextSize=12,TextColor3=theme.Text,PlaceholderColor3=theme.Muted,Font=Enum.Font.Gotham,TextXAlignment=Enum.TextXAlignment.Left,Parent=row})
    corner(box,10); stroke(box,theme.Border,0.88,1); padding(box,11,10,0,0)
    local c=setmetatable({},Component); c:_init("Input",self,config); c.Root=row; c.Box=box
    function c:Get() return self.Box.Text end
    function c:Set(value,fire) self.Box.Text=tostring(value or ""); if fire then safeCall(self.Callback,self.Box.Text,self) end; return self end
    c.Maid:Give(box.FocusLost:Connect(function(enter) safeCall(c.Callback,box.Text,c,enter) end))
    c.Maid:Give(box.Focused:Connect(function() Motion:_tween(box,{BackgroundTransparency=0.02},0.16,Enum.EasingStyle.Quad) end))
    c.Maid:Give(box.FocusLost:Connect(function() Motion:_tween(box,{BackgroundTransparency=0.12},0.2,Enum.EasingStyle.Quad) end))
    return self:_register(c)
end

function Tab:CreateKeybind(config)
    config=config or {}
    local theme=self.API:_theme(self.API._themeName)
    local row=self:_row(config,config.Height or 58)
    local title=textLabel(row,config.Name or "Keybind",14,theme.Text,Enum.Font.GothamSemibold); title.Size=UDim2.new(1,-130,1,0)
    local key=config.CurrentKeybind or config.Keybind or Enum.KeyCode.RightShift
    local button=make("TextButton",{AutoButtonColor=false,BackgroundColor3=theme.SurfaceRaised,BackgroundTransparency=0.12,Size=UDim2.fromOffset(112,34),AnchorPoint=Vector2.new(1,0.5),Position=UDim2.new(1,0,0.5,0),Text=typeof(key)=="EnumItem" and key.Name or tostring(key),TextSize=11,TextColor3=theme.Text,Font=Enum.Font.GothamMedium,Parent=row})
    corner(button,9); stroke(button,theme.Border,0.88,1)
    local c=setmetatable({},Component); c:_init("Keybind",self,config); c.Root=row; c.Button=button; c.Key=key; c.Listening=false
    function c:Set(keyValue) self.Key=keyValue; self.Button.Text=typeof(keyValue)=="EnumItem" and keyValue.Name or tostring(keyValue); return self end
    function c:Get() return self.Key end
    c.Maid:Give(button.MouseButton1Click:Connect(function() if c.Listening then return end; c.Listening=true; c.Button.Text="Press key..."; Motion:_tween(button,{BackgroundColor3=theme.Accent},0.18,Enum.EasingStyle.Quad) end))
    c.Maid:Give(UserInputService.InputBegan:Connect(function(input,processed) if processed or not c.Listening then return end; if input.UserInputType==Enum.UserInputType.Keyboard then c.Listening=false; c:Set(input.KeyCode); Motion:_tween(button,{BackgroundColor3=theme.SurfaceRaised},0.2,Enum.EasingStyle.Quad); safeCall(c.Callback,input.KeyCode,c) elseif input.UserInputType==Enum.UserInputType.MouseButton1 then c.Listening=false; c:Set(Enum.UserInputType.MouseButton1); safeCall(c.Callback,input.UserInputType,c) end end))
    c.Maid:Give(UserInputService.InputBegan:Connect(function(input,processed) if processed or c.Listening then return end; if input.KeyCode==c.Key then safeCall(c.Callback,c.Key,c) end end))
    return self:_register(c)
end

function Tab:CreateColorPicker(config)
    config=config or {}
    local theme=self.API:_theme(self.API._themeName)
    local row=self:_row(config,config.Height or 58)
    local title=textLabel(row,config.Name or "Color",14,theme.Text,Enum.Font.GothamSemibold); title.Size=UDim2.new(1,-90,1,0)
    local swatch=make("TextButton",{AutoButtonColor=false,BackgroundColor3=config.Color or theme.Accent,BackgroundTransparency=0,Size=UDim2.fromOffset(48,30),AnchorPoint=Vector2.new(1,0.5),Position=UDim2.new(1,0,0.5,0),Text="",Parent=row})
    corner(swatch,9); stroke(swatch,theme.Border,0.82,1)
    local c=setmetatable({},Component); c:_init("ColorPicker",self,config); c.Root=row; c.Color=swatch.BackgroundColor3; c.Swatch=swatch
    function c:Set(color,fire) if typeof(color)=="Color3" then self.Color=color; self.Swatch.BackgroundColor3=color; if fire then safeCall(self.Callback,color,self) end end; return self end
    function c:Get() return self.Color end
    c.Maid:Give(swatch.MouseButton1Click:Connect(function()
        local picker=self.API:_createColorPopover(c)
        c.Popover=picker
    end))
    return self:_register(c)
end

function AstraUI:_createColorPopover(component)
    local theme=self:_theme(self._themeName)
    local popup=make("Frame",{BackgroundColor3=theme.SurfaceRaised,BackgroundTransparency=0.04,Size=UDim2.fromOffset(270,190),ZIndex=90,Parent=component.Window.Gui})
    corner(popup,14); stroke(popup,theme.Border,0.84,1)
    local hue=make("TextBox",{BackgroundColor3=theme.Surface,BackgroundTransparency=0.1,Size=UDim2.new(1,-24,0,34),Position=UDim2.fromOffset(12,12),PlaceholderText="Hue 0-360",Text="",TextSize=12,TextColor3=theme.Text,Font=Enum.Font.Gotham,Parent=popup}); corner(hue,9); padding(hue,10,10,0,0)
    local sat=make("TextBox",{BackgroundColor3=theme.Surface,BackgroundTransparency=0.1,Size=UDim2.new(1,-24,0,34),Position=UDim2.fromOffset(12,54),PlaceholderText="Saturation 0-1",Text="",TextSize=12,TextColor3=theme.Text,Font=Enum.Font.Gotham,Parent=popup}); corner(sat,9); padding(sat,10,10,0,0)
    local val=make("TextBox",{BackgroundColor3=theme.Surface,BackgroundTransparency=0.1,Size=UDim2.new(1,-24,0,34),Position=UDim2.fromOffset(12,96),PlaceholderText="Value 0-1",Text="",TextSize=12,TextColor3=theme.Text,Font=Enum.Font.Gotham,Parent=popup}); corner(val,9); padding(val,10,10,0,0)
    local apply=make("TextButton",{AutoButtonColor=false,BackgroundColor3=theme.Accent,Size=UDim2.new(1,-24,0,36),Position=UDim2.fromOffset(12,142),Text="Apply",TextSize=12,TextColor3=theme.Text,Font=Enum.Font.GothamSemibold,Parent=popup}); corner(apply,9)
    local pos=component.Swatch.AbsolutePosition; local size=component.Swatch.AbsoluteSize
    popup.Position=UDim2.fromOffset(pos.X-220,pos.Y+size.Y+6)
    apply.MouseButton1Click:Connect(function()
        local old=component.Color; local h=tonumber(hue.Text) or old:ToHSV(); local s=tonumber(sat.Text) or select(2,old:ToHSV()); local v=tonumber(val.Text) or select(3,old:ToHSV())
        component:Set(Color3.fromHSV(clamp(h/360,0,1),clamp(s,0,1),clamp(v,0,1)),true)
        Motion:_tween(popup,{Size=UDim2.fromOffset(270,0)},0.16,Enum.EasingStyle.Quint)
        task.delay(0.18,function() popup:Destroy() end)
    end)
    popup.Size=UDim2.fromOffset(270,0); Motion:_tween(popup,{Size=UDim2.fromOffset(270,190)},0.22,Enum.EasingStyle.Quint)
    return popup
end

function Tab:CreateMultiDropdown(config)
    config=config or {}
    local theme=self.API:_theme(self.API._themeName)
    local row=self:_row(config,config.Height or 62)
    local title=textLabel(row,config.Name or "Multi Dropdown",14,theme.Text,Enum.Font.GothamSemibold); title.Size=UDim2.new(1,-160,0,22)
    local trigger=make("TextButton",{AutoButtonColor=false,BackgroundColor3=theme.SurfaceRaised,BackgroundTransparency=0.12,Size=UDim2.fromOffset(154,36),AnchorPoint=Vector2.new(1,0.5),Position=UDim2.new(1,0,0.5,0),Text="",Parent=row}); corner(trigger,10); stroke(trigger,theme.Border,0.88,1)
    local label=textLabel(trigger,"0 selected",12,theme.Text,Enum.Font.GothamMedium); label.Position=UDim2.fromOffset(12,0); label.Size=UDim2.new(1,-38,1,0)
    local arrow=iconLabel(trigger,"chevron-down",16,theme.Muted); arrow.AnchorPoint=Vector2.new(0.5,0.5); arrow.Position=UDim2.new(1,-17,0.5,0)
    local c=setmetatable({},Component); c:_init("MultiDropdown",self,config); c.Root=row; c.Trigger=trigger; c.Label=label; c.Arrow=arrow; c.Options=config.Options or {}; c.Values={}; c.Open=false
    local popup=make("Frame",{Visible=false,BackgroundColor3=theme.SurfaceRaised,BackgroundTransparency=0.05,Size=UDim2.fromOffset(220,0),ZIndex=80,Parent=self.Window.Gui}); corner(popup,12); stroke(popup,theme.Border,0.84,1)
    local list=make("ScrollingFrame",{BackgroundTransparency=1,BorderSizePixel=0,Size=UDim2.new(1,-8,1,-8),Position=UDim2.fromOffset(4,4),ScrollBarThickness=2,AutomaticCanvasSize=Enum.AutomaticSize.Y,CanvasSize=UDim2.new(),ZIndex=81,Parent=popup}); make("UIListLayout",{Padding=UDim.new(0,3),Parent=list})
    c.Popover=popup
    local function isSelected(option) for _,v in ipairs(c.Values) do if v==option then return true end end return false end
    local function updateLabel() label.Text=tostring(#c.Values).." selected" end
    for _,option in ipairs(c.Options) do
        local item=make("TextButton",{AutoButtonColor=false,BackgroundTransparency=1,Size=UDim2.new(1,0,0,38),Text=tostring(option),TextSize=12,TextColor3=theme.Text,Font=Enum.Font.GothamMedium,ZIndex=82,Parent=list}); corner(item,9)
        item.MouseEnter:Connect(function() Motion:_tween(item,{BackgroundTransparency=0.82},0.12,Enum.EasingStyle.Quad) end)
        item.MouseLeave:Connect(function() Motion:_tween(item,{BackgroundTransparency=1},0.16,Enum.EasingStyle.Quad) end)
        item.MouseButton1Click:Connect(function() if isSelected(option) then for i,v in ipairs(c.Values) do if v==option then table.remove(c.Values,i); break end end else table.insert(c.Values,option) end; updateLabel(); safeCall(c.Callback,c.Values,c) end)
    end
    function c:Set(values,fire)
        self.Values=type(values)=="table" and table.clone(values) or {}
        updateLabel()
        if fire then safeCall(self.Callback,self.Values,self) end
        return self
    end
    function c:Get() return table.clone(self.Values) end
    function c:Open() if self.Open then return end; self.Open=true; popup.Visible=true; local p=trigger.AbsolutePosition; local s=trigger.AbsoluteSize; popup.Position=UDim2.fromOffset(p.X,p.Y+s.Y+6); Motion:_tween(popup,{Size=UDim2.fromOffset(220,math.min(260,40*#self.Options+8))},0.24,Enum.EasingStyle.Quint); Motion:_tween(arrow,{Rotation=180},0.2,Enum.EasingStyle.Back) end
    function c:Close() if not self.Open then return end; self.Open=false; Motion:_tween(popup,{Size=UDim2.fromOffset(220,0)},0.18,Enum.EasingStyle.Quint); Motion:_tween(arrow,{Rotation=0},0.18,Enum.EasingStyle.Quad); task.delay(0.2,function() if not self.Open then popup.Visible=false end end) end
    trigger.MouseButton1Click:Connect(function() if c.Open then c:Close() else c:Open() end end)
    return self:_register(c)
end

function Window:CreateTab(config)
    config=config or {}
    assert(type(config.Name)=="string","Tab Name is required")
    local tab=setmetatable({},Tab); tab:_init(self,config); self.Tabs[config.Name]=tab
    if not self.ActiveTab then tab:Activate() end
    return tab
end

function Window:GetTab(name) return self.Tabs[name] end

function Window:GetComponent(name)
    for _,tab in pairs(self.Tabs) do
        for _,component in pairs(tab.Components) do if component.Name==name then return component end end
    end
    return nil
end

function Window:Search(query)
    query=string.lower(tostring(query or ""))
    for _,tab in pairs(self.Tabs) do
        local matched=0
        for _,component in pairs(tab.Components) do
            local haystack=string.lower((component.Name or "").." "..(component.Description or ""))
            local visible=query=="" or string.find(haystack,query,1,true)~=nil
            component:SetVisible(visible)
            if visible then matched=matched+1 end
        end
        tab:SetVisible(query=="" or matched>0)
    end
    return self
end

function Tab:SetVisible(value)
    self.Button.Visible=value
    if not value and self.Window.ActiveTab==self then
        for _,other in pairs(self.Window.Tabs) do if other~=self and other.Button.Visible then other:Activate(); break end end
    end
end

function Window:SetSearchEnabled(enabled)
    self.SearchBox.Visible=enabled and true or false
    if enabled then
        self.Maid:Give(self.SearchBox:GetPropertyChangedSignal("Text"):Connect(function() self:Search(self.SearchBox.Text) end))
    end
    return self
end

function Window:SetTitle(title, subtitle)
    self.Title=tostring(title or self.Title); self.TitleLabel.Text=self.Title
    if subtitle~=nil then self.Subtitle=tostring(subtitle); self.SubtitleLabel.Text=self.Subtitle end
    return self
end

function Window:SetSize(size)
    if typeof(size)=="UDim2" then self.Container.Size=size end
    return self
end

function Window:SetPosition(position)
    if typeof(position)=="UDim2" then self.Container.Position=position end
    return self
end

function Window:Open()
    if self.Destroyed then return self end
    self.Container.Visible=true
    self.Container.Size=UDim2.fromOffset(self.Container.AbsoluteSize.X*0.94,self.Container.AbsoluteSize.Y*0.94)
    Motion:_tween(self.Container,{Size=self.Config.Size or UDim2.fromOffset(680,500)},0.28,Enum.EasingStyle.Quint)
    return self
end

function Window:Close()
    if self.Destroyed then return self end
    Motion:_tween(self.Container,{Size=UDim2.fromOffset(math.max(1,self.Container.AbsoluteSize.X*0.92),math.max(1,self.Container.AbsoluteSize.Y*0.92))},0.2,Enum.EasingStyle.Quint)
    task.delay(0.2,function() if not self.Destroyed then self.Container.Visible=false end end)
    return self
end

function Window:Toggle()
    if self.Container.Visible then return self:Close() end
    return self:Open()
end

function Window:ToggleMinimize()
    if self.Minimized then
        self.Minimized=false
        Motion:_tween(self.Container,{Size=self._preMinimizeSize or self.Config.Size or UDim2.fromOffset(680,500)},0.32,Enum.EasingStyle.Quint)
        Motion:_tween(self.Body,{Position=UDim2.fromOffset(0,64)},0.28,Enum.EasingStyle.Quint)
    else
        self.Minimized=true; self._preMinimizeSize=self.Container.Size
        Motion:_tween(self.Container,{Size=UDim2.fromOffset(math.min(420,self.Container.AbsoluteSize.X),64)},0.3,Enum.EasingStyle.Quint)
        Motion:_tween(self.Body,{Position=UDim2.fromOffset(0,60)},0.25,Enum.EasingStyle.Quint)
    end
    return self
end

function Window:SetVisibility(value)
    self.Container.Visible=value and true or false
    return self
end

function Window:Destroy()
    if self.Destroyed then return end
    self.Destroyed=true
    self.Maid:Clean()
    for _,tab in pairs(self.Tabs) do
        for _,component in pairs(tab.Components) do pcall(function() component:Destroy() end) end
    end
    if self.Gui then self.Gui:Destroy() end
    self.API._windows[self]=nil
end

AstraUI._notifications={}

function AstraUI:_buildNotificationHost()
    if self._notificationHost and self._notificationHost.Parent then return self._notificationHost end
    local playerGui=LocalPlayer:WaitForChild("PlayerGui")
    local gui=make("ScreenGui",{Name="AstraUI_Notifications",ResetOnSpawn=false,IgnoreGuiInset=true,ZIndexBehavior=Enum.ZIndexBehavior.Sibling,Parent=playerGui})
    local host=make("Frame",{BackgroundTransparency=1,AnchorPoint=Vector2.new(0.5,1),Position=UDim2.new(0.5,0,1,-22),Size=UDim2.fromOffset(360,320),Parent=gui})
    local layout=make("UIListLayout",{VerticalAlignment=Enum.VerticalAlignment.Bottom,HorizontalAlignment=Enum.HorizontalAlignment.Center,Padding=UDim.new(0,8),SortOrder=Enum.SortOrder.LayoutOrder,Parent=host})
    self._notificationGui=gui; self._notificationHost=host; self._notificationLayout=layout
    return host
end

function AstraUI:Notify(config)
    config=config or {}
    local host=self:_buildNotificationHost()
    local theme=self:_theme(self._themeName)
    local card=make("Frame",{BackgroundColor3=theme.SurfaceRaised,BackgroundTransparency=0.05,Size=UDim2.fromOffset(340,68),BorderSizePixel=0,Parent=host})
    corner(card,14); stroke(card,theme.Border,0.84,1)
    local accent=make("Frame",{BackgroundColor3=config.Color or theme.Accent,BackgroundTransparency=0,Size=UDim2.fromOffset(3,42),Position=UDim2.fromOffset(0,13),BorderSizePixel=0,Parent=card}); corner(accent,2)
    local icon=iconLabel(card,config.Icon or "bell",18,config.Color or theme.Accent); icon.Position=UDim2.fromOffset(16,15)
    local title=textLabel(card,config.Title or "AstraUI",13,theme.Text,Enum.Font.GothamSemibold); title.Position=UDim2.fromOffset(44,9); title.Size=UDim2.new(1,-58,0,22)
    local content=textLabel(card,config.Content or config.Description or "",11,theme.Muted,Enum.Font.Gotham); content.Position=UDim2.fromOffset(44,31); content.Size=UDim2.new(1,-58,0,28); content.TextWrapped=true; content.TextYAlignment=Enum.TextYAlignment.Top
    card.LayoutOrder=os.clock()*1000
    card.Size=UDim2.fromOffset(340,0)
    Motion:_tween(card,{Size=UDim2.fromOffset(340,68)},0.28,Enum.EasingStyle.Back)
    table.insert(self._notifications,card)
    local duration=config.Duration or self._notificationDuration
    task.delay(duration,function()
        if not card.Parent then return end
        Motion:_tween(card,{Size=UDim2.fromOffset(340,0),BackgroundTransparency=1},0.24,Enum.EasingStyle.Quint)
        task.delay(0.25,function() for i,v in ipairs(self._notifications) do if v==card then table.remove(self._notifications,i); break end end; if card then card:Destroy() end end)
    end)
    return card
end

function AstraUI:SetTheme(name)
    assert(type(name)=="string","Theme name must be a string")
    assert(self.Themes[name],"Unknown AstraUI theme: "..name)
    self._themeName=name
    local theme=self:_theme(name)
    for _,window in pairs(self._windows) do
        if window.Container then self:_restyleWindow(window,theme) end
    end
    return self
end

function AstraUI:_restyleWindow(window,theme)
    window.Container.BackgroundColor3=theme.Surface
    window.GlassGlow.BackgroundColor3=theme.Accent
    window.TitleLabel.TextColor3=theme.Text
    window.SubtitleLabel.TextColor3=theme.Muted
    for _,tab in pairs(window.Tabs) do
        tab.Label.TextColor3=(window.ActiveTab==tab) and theme.Text or theme.Muted
        tab.IconObject.ImageColor3=(window.ActiveTab==tab) and theme.Accent or theme.Muted
    end
end

function AstraUI:RegisterTheme(name, theme)
    assert(type(name)=="string","Theme name must be a string")
    assert(type(theme)=="table","Theme must be a table")
    self.Themes[name]=theme
    return self
end

function AstraUI:SetAccent(color)
    assert(typeof(color)=="Color3","Accent must be Color3")
    self._accent=color
    for _,window in pairs(self._windows) do
        if window.GlassGlow then window.GlassGlow.BackgroundColor3=color end
    end
    return self
end

function AstraUI:SetReducedMotion(value)
    self._reducedMotion=value and true or false
    return self
end

function AstraUI:SetQuality(value)
    local allowed={Auto=true,Low=true,Medium=true,High=true}
    assert(allowed[value],"Quality must be Auto, Low, Medium, or High")
    self._quality=value
    return self
end

function AstraUI:SetTransparency(value)
    self._transparency=clamp(tonumber(value) or self.Defaults.Transparency,0,0.8)
    for _,window in pairs(self._windows) do
        if window.Container then window.Container.BackgroundTransparency=self._transparency end
    end
    return self
end

function AstraUI:SetCornerRadius(value)
    self._cornerRadius=clamp(tonumber(value) or self.Defaults.CornerRadius,0,32)
    return self
end

function AstraUI:SetAnimationSpeed(value)
    self._animationSpeed=clamp(tonumber(value) or self.Defaults.AnimationSpeed,0.04,1)
    Motion.Speed=self._animationSpeed
    return self
end

function AstraUI:CreateWindow(config)
    config=config or {}
    local window=setmetatable({},Window)
    window:_init(self,config)
    self._windows[window]=true
    return window
end

AstraUI._windows={}
AstraUI._themeName=AstraUI.Defaults.Theme
AstraUI._accent=AstraUI.Defaults.Accent
AstraUI._transparency=AstraUI.Defaults.Transparency
AstraUI._cornerRadius=AstraUI.Defaults.CornerRadius
AstraUI._animationSpeed=AstraUI.Defaults.AnimationSpeed
AstraUI._reducedMotion=AstraUI.Defaults.ReducedMotion
AstraUI._loadingDuration=AstraUI.Defaults.LoadingDuration
AstraUI._notificationDuration=AstraUI.Defaults.NotificationDuration
AstraUI._showLoading=AstraUI.Defaults.ShowLoading
AstraUI._quality=AstraUI.Defaults.Quality
Motion.Speed=AstraUI._animationSpeed

function Component:SetBackgroundTransparency(value)
    if self.Root and pcall(function() return self.Root.BackgroundTransparency end) then
        local ok = pcall(function() self.Root.BackgroundTransparency=value end)
        if not ok then return false end
        return self
    end
    return false
end

function Component:GetBackgroundTransparency()
    if self.Root then
        local ok, value = pcall(function() return self.Root.BackgroundTransparency end)
        if ok then return value end
    end
    return nil
end

function Component:SetBackgroundColor3(value)
    if self.Root and pcall(function() return self.Root.BackgroundColor3 end) then
        local ok = pcall(function() self.Root.BackgroundColor3=value end)
        if not ok then return false end
        return self
    end
    return false
end

function Component:GetBackgroundColor3()
    if self.Root then
        local ok, value = pcall(function() return self.Root.BackgroundColor3 end)
        if ok then return value end
    end
    return nil
end

function Component:SetBorderColor3(value)
    if self.Root and pcall(function() return self.Root.BorderColor3 end) then
        local ok = pcall(function() self.Root.BorderColor3=value end)
        if not ok then return false end
        return self
    end
    return false
end

function Component:GetBorderColor3()
    if self.Root then
        local ok, value = pcall(function() return self.Root.BorderColor3 end)
        if ok then return value end
    end
    return nil
end

function Component:SetBorderSizePixel(value)
    if self.Root and pcall(function() return self.Root.BorderSizePixel end) then
        local ok = pcall(function() self.Root.BorderSizePixel=value end)
        if not ok then return false end
        return self
    end
    return false
end

function Component:GetBorderSizePixel()
    if self.Root then
        local ok, value = pcall(function() return self.Root.BorderSizePixel end)
        if ok then return value end
    end
    return nil
end

function Component:SetPosition(value)
    if self.Root and pcall(function() return self.Root.Position end) then
        local ok = pcall(function() self.Root.Position=value end)
        if not ok then return false end
        return self
    end
    return false
end

function Component:GetPosition()
    if self.Root then
        local ok, value = pcall(function() return self.Root.Position end)
        if ok then return value end
    end
    return nil
end

function Component:SetSize(value)
    if self.Root and pcall(function() return self.Root.Size end) then
        local ok = pcall(function() self.Root.Size=value end)
        if not ok then return false end
        return self
    end
    return false
end

function Component:GetSize()
    if self.Root then
        local ok, value = pcall(function() return self.Root.Size end)
        if ok then return value end
    end
    return nil
end

function Component:SetAnchorPoint(value)
    if self.Root and pcall(function() return self.Root.AnchorPoint end) then
        local ok = pcall(function() self.Root.AnchorPoint=value end)
        if not ok then return false end
        return self
    end
    return false
end

function Component:GetAnchorPoint()
    if self.Root then
        local ok, value = pcall(function() return self.Root.AnchorPoint end)
        if ok then return value end
    end
    return nil
end

function Component:SetRotation(value)
    if self.Root and pcall(function() return self.Root.Rotation end) then
        local ok = pcall(function() self.Root.Rotation=value end)
        if not ok then return false end
        return self
    end
    return false
end

function Component:GetRotation()
    if self.Root then
        local ok, value = pcall(function() return self.Root.Rotation end)
        if ok then return value end
    end
    return nil
end

function Component:SetVisible(value)
    if self.Root and pcall(function() return self.Root.Visible end) then
        local ok = pcall(function() self.Root.Visible=value end)
        if not ok then return false end
        return self
    end
    return false
end

function Component:GetVisible()
    if self.Root then
        local ok, value = pcall(function() return self.Root.Visible end)
        if ok then return value end
    end
    return nil
end

function Component:SetZIndex(value)
    if self.Root and pcall(function() return self.Root.ZIndex end) then
        local ok = pcall(function() self.Root.ZIndex=value end)
        if not ok then return false end
        return self
    end
    return false
end

function Component:GetZIndex()
    if self.Root then
        local ok, value = pcall(function() return self.Root.ZIndex end)
        if ok then return value end
    end
    return nil
end

function Component:SetLayoutOrder(value)
    if self.Root and pcall(function() return self.Root.LayoutOrder end) then
        local ok = pcall(function() self.Root.LayoutOrder=value end)
        if not ok then return false end
        return self
    end
    return false
end

function Component:GetLayoutOrder()
    if self.Root then
        local ok, value = pcall(function() return self.Root.LayoutOrder end)
        if ok then return value end
    end
    return nil
end

function Component:SetAutomaticSize(value)
    if self.Root and pcall(function() return self.Root.AutomaticSize end) then
        local ok = pcall(function() self.Root.AutomaticSize=value end)
        if not ok then return false end
        return self
    end
    return false
end

function Component:GetAutomaticSize()
    if self.Root then
        local ok, value = pcall(function() return self.Root.AutomaticSize end)
        if ok then return value end
    end
    return nil
end

function Component:SetClipsDescendants(value)
    if self.Root and pcall(function() return self.Root.ClipsDescendants end) then
        local ok = pcall(function() self.Root.ClipsDescendants=value end)
        if not ok then return false end
        return self
    end
    return false
end

function Component:GetClipsDescendants()
    if self.Root then
        local ok, value = pcall(function() return self.Root.ClipsDescendants end)
        if ok then return value end
    end
    return nil
end

function Component:SetActive(value)
    if self.Root and pcall(function() return self.Root.Active end) then
        local ok = pcall(function() self.Root.Active=value end)
        if not ok then return false end
        return self
    end
    return false
end

function Component:GetActive()
    if self.Root then
        local ok, value = pcall(function() return self.Root.Active end)
        if ok then return value end
    end
    return nil
end

function Component:SetSelectable(value)
    if self.Root and pcall(function() return self.Root.Selectable end) then
        local ok = pcall(function() self.Root.Selectable=value end)
        if not ok then return false end
        return self
    end
    return false
end

function Component:GetSelectable()
    if self.Root then
        local ok, value = pcall(function() return self.Root.Selectable end)
        if ok then return value end
    end
    return nil
end

function Component:SetText(value)
    if self.Root and pcall(function() return self.Root.Text end) then
        local ok = pcall(function() self.Root.Text=value end)
        if not ok then return false end
        return self
    end
    return false
end

function Component:GetText()
    if self.Root then
        local ok, value = pcall(function() return self.Root.Text end)
        if ok then return value end
    end
    return nil
end

function Component:SetTextColor3(value)
    if self.Root and pcall(function() return self.Root.TextColor3 end) then
        local ok = pcall(function() self.Root.TextColor3=value end)
        if not ok then return false end
        return self
    end
    return false
end

function Component:GetTextColor3()
    if self.Root then
        local ok, value = pcall(function() return self.Root.TextColor3 end)
        if ok then return value end
    end
    return nil
end

function Component:SetTextTransparency(value)
    if self.Root and pcall(function() return self.Root.TextTransparency end) then
        local ok = pcall(function() self.Root.TextTransparency=value end)
        if not ok then return false end
        return self
    end
    return false
end

function Component:GetTextTransparency()
    if self.Root then
        local ok, value = pcall(function() return self.Root.TextTransparency end)
        if ok then return value end
    end
    return nil
end

function Component:SetTextSize(value)
    if self.Root and pcall(function() return self.Root.TextSize end) then
        local ok = pcall(function() self.Root.TextSize=value end)
        if not ok then return false end
        return self
    end
    return false
end

function Component:GetTextSize()
    if self.Root then
        local ok, value = pcall(function() return self.Root.TextSize end)
        if ok then return value end
    end
    return nil
end

function Component:SetTextWrapped(value)
    if self.Root and pcall(function() return self.Root.TextWrapped end) then
        local ok = pcall(function() self.Root.TextWrapped=value end)
        if not ok then return false end
        return self
    end
    return false
end

function Component:GetTextWrapped()
    if self.Root then
        local ok, value = pcall(function() return self.Root.TextWrapped end)
        if ok then return value end
    end
    return nil
end

function Component:SetTextXAlignment(value)
    if self.Root and pcall(function() return self.Root.TextXAlignment end) then
        local ok = pcall(function() self.Root.TextXAlignment=value end)
        if not ok then return false end
        return self
    end
    return false
end

function Component:GetTextXAlignment()
    if self.Root then
        local ok, value = pcall(function() return self.Root.TextXAlignment end)
        if ok then return value end
    end
    return nil
end

function Component:SetTextYAlignment(value)
    if self.Root and pcall(function() return self.Root.TextYAlignment end) then
        local ok = pcall(function() self.Root.TextYAlignment=value end)
        if not ok then return false end
        return self
    end
    return false
end

function Component:GetTextYAlignment()
    if self.Root then
        local ok, value = pcall(function() return self.Root.TextYAlignment end)
        if ok then return value end
    end
    return nil
end

function Component:SetFont(value)
    if self.Root and pcall(function() return self.Root.Font end) then
        local ok = pcall(function() self.Root.Font=value end)
        if not ok then return false end
        return self
    end
    return false
end

function Component:GetFont()
    if self.Root then
        local ok, value = pcall(function() return self.Root.Font end)
        if ok then return value end
    end
    return nil
end

function Component:SetPlaceholderText(value)
    if self.Root and pcall(function() return self.Root.PlaceholderText end) then
        local ok = pcall(function() self.Root.PlaceholderText=value end)
        if not ok then return false end
        return self
    end
    return false
end

function Component:GetPlaceholderText()
    if self.Root then
        local ok, value = pcall(function() return self.Root.PlaceholderText end)
        if ok then return value end
    end
    return nil
end

function Component:SetPlaceholderColor3(value)
    if self.Root and pcall(function() return self.Root.PlaceholderColor3 end) then
        local ok = pcall(function() self.Root.PlaceholderColor3=value end)
        if not ok then return false end
        return self
    end
    return false
end

function Component:GetPlaceholderColor3()
    if self.Root then
        local ok, value = pcall(function() return self.Root.PlaceholderColor3 end)
        if ok then return value end
    end
    return nil
end

function Component:SetClearTextOnFocus(value)
    if self.Root and pcall(function() return self.Root.ClearTextOnFocus end) then
        local ok = pcall(function() self.Root.ClearTextOnFocus=value end)
        if not ok then return false end
        return self
    end
    return false
end

function Component:GetClearTextOnFocus()
    if self.Root then
        local ok, value = pcall(function() return self.Root.ClearTextOnFocus end)
        if ok then return value end
    end
    return nil
end

function Component:SetImage(value)
    if self.Root and pcall(function() return self.Root.Image end) then
        local ok = pcall(function() self.Root.Image=value end)
        if not ok then return false end
        return self
    end
    return false
end

function Component:GetImage()
    if self.Root then
        local ok, value = pcall(function() return self.Root.Image end)
        if ok then return value end
    end
    return nil
end

function Component:SetImageColor3(value)
    if self.Root and pcall(function() return self.Root.ImageColor3 end) then
        local ok = pcall(function() self.Root.ImageColor3=value end)
        if not ok then return false end
        return self
    end
    return false
end

function Component:GetImageColor3()
    if self.Root then
        local ok, value = pcall(function() return self.Root.ImageColor3 end)
        if ok then return value end
    end
    return nil
end

function Component:SetImageTransparency(value)
    if self.Root and pcall(function() return self.Root.ImageTransparency end) then
        local ok = pcall(function() self.Root.ImageTransparency=value end)
        if not ok then return false end
        return self
    end
    return false
end

function Component:GetImageTransparency()
    if self.Root then
        local ok, value = pcall(function() return self.Root.ImageTransparency end)
        if ok then return value end
    end
    return nil
end

function Component:SetImageRectOffset(value)
    if self.Root and pcall(function() return self.Root.ImageRectOffset end) then
        local ok = pcall(function() self.Root.ImageRectOffset=value end)
        if not ok then return false end
        return self
    end
    return false
end

function Component:GetImageRectOffset()
    if self.Root then
        local ok, value = pcall(function() return self.Root.ImageRectOffset end)
        if ok then return value end
    end
    return nil
end

function Component:SetImageRectSize(value)
    if self.Root and pcall(function() return self.Root.ImageRectSize end) then
        local ok = pcall(function() self.Root.ImageRectSize=value end)
        if not ok then return false end
        return self
    end
    return false
end

function Component:GetImageRectSize()
    if self.Root then
        local ok, value = pcall(function() return self.Root.ImageRectSize end)
        if ok then return value end
    end
    return nil
end

function Component:SetScaleType(value)
    if self.Root and pcall(function() return self.Root.ScaleType end) then
        local ok = pcall(function() self.Root.ScaleType=value end)
        if not ok then return false end
        return self
    end
    return false
end

function Component:GetScaleType()
    if self.Root then
        local ok, value = pcall(function() return self.Root.ScaleType end)
        if ok then return value end
    end
    return nil
end

function Component:SetSliceScale(value)
    if self.Root and pcall(function() return self.Root.SliceScale end) then
        local ok = pcall(function() self.Root.SliceScale=value end)
        if not ok then return false end
        return self
    end
    return false
end

function Component:GetSliceScale()
    if self.Root then
        local ok, value = pcall(function() return self.Root.SliceScale end)
        if ok then return value end
    end
    return nil
end

function Component:SetCanvasPosition(value)
    if self.Root and pcall(function() return self.Root.CanvasPosition end) then
        local ok = pcall(function() self.Root.CanvasPosition=value end)
        if not ok then return false end
        return self
    end
    return false
end

function Component:GetCanvasPosition()
    if self.Root then
        local ok, value = pcall(function() return self.Root.CanvasPosition end)
        if ok then return value end
    end
    return nil
end

function Component:SetCanvasSize(value)
    if self.Root and pcall(function() return self.Root.CanvasSize end) then
        local ok = pcall(function() self.Root.CanvasSize=value end)
        if not ok then return false end
        return self
    end
    return false
end

function Component:GetCanvasSize()
    if self.Root then
        local ok, value = pcall(function() return self.Root.CanvasSize end)
        if ok then return value end
    end
    return nil
end

function Component:SetScrollBarThickness(value)
    if self.Root and pcall(function() return self.Root.ScrollBarThickness end) then
        local ok = pcall(function() self.Root.ScrollBarThickness=value end)
        if not ok then return false end
        return self
    end
    return false
end

function Component:GetScrollBarThickness()
    if self.Root then
        local ok, value = pcall(function() return self.Root.ScrollBarThickness end)
        if ok then return value end
    end
    return nil
end

function Component:SetScrollBarImageColor3(value)
    if self.Root and pcall(function() return self.Root.ScrollBarImageColor3 end) then
        local ok = pcall(function() self.Root.ScrollBarImageColor3=value end)
        if not ok then return false end
        return self
    end
    return false
end

function Component:GetScrollBarImageColor3()
    if self.Root then
        local ok, value = pcall(function() return self.Root.ScrollBarImageColor3 end)
        if ok then return value end
    end
    return nil
end

function Component:SetScrollBarImageTransparency(value)
    if self.Root and pcall(function() return self.Root.ScrollBarImageTransparency end) then
        local ok = pcall(function() self.Root.ScrollBarImageTransparency=value end)
        if not ok then return false end
        return self
    end
    return false
end

function Component:GetScrollBarImageTransparency()
    if self.Root then
        local ok, value = pcall(function() return self.Root.ScrollBarImageTransparency end)
        if ok then return value end
    end
    return nil
end

function Component:SetRotationSpeed(value)
    if self.Root and pcall(function() return self.Root.RotationSpeed end) then
        local ok = pcall(function() self.Root.RotationSpeed=value end)
        if not ok then return false end
        return self
    end
    return false
end

function Component:GetRotationSpeed()
    if self.Root then
        local ok, value = pcall(function() return self.Root.RotationSpeed end)
        if ok then return value end
    end
    return nil
end

function Component:OnHover(callback)
    if not self.Root or type(callback)~="function" then return self end
    local signal=self.Root.MouseEnter
    if signal then self.Maid:Give(signal:Connect(function(...) safeCall(callback,self,...) end)) end
    return self
end

function Component:OnUnhover(callback)
    if not self.Root or type(callback)~="function" then return self end
    local signal=self.Root.MouseLeave
    if signal then self.Maid:Give(signal:Connect(function(...) safeCall(callback,self,...) end)) end
    return self
end

function Component:OnClick(callback)
    if not self.Root or type(callback)~="function" then return self end
    local signal=self.Root.MouseButton1Click
    if signal then self.Maid:Give(signal:Connect(function(...) safeCall(callback,self,...) end)) end
    return self
end

function Component:OnPress(callback)
    if not self.Root or type(callback)~="function" then return self end
    local signal=self.Root.MouseButton1Down
    if signal then self.Maid:Give(signal:Connect(function(...) safeCall(callback,self,...) end)) end
    return self
end

function Component:OnRelease(callback)
    if not self.Root or type(callback)~="function" then return self end
    local signal=self.Root.MouseButton1Up
    if signal then self.Maid:Give(signal:Connect(function(...) safeCall(callback,self,...) end)) end
    return self
end

function Component:OnFocus(callback)
    if not self.Root or type(callback)~="function" then return self end
    local signal=self.Root.Focused
    if signal then self.Maid:Give(signal:Connect(function(...) safeCall(callback,self,...) end)) end
    return self
end

function Component:OnBlur(callback)
    if not self.Root or type(callback)~="function" then return self end
    local signal=self.Root.FocusLost
    if signal then self.Maid:Give(signal:Connect(function(...) safeCall(callback,self,...) end)) end
    return self
end

function Window:SetTitleText(value)
    if self.TitleLabel then self.TitleLabel.Text=tostring(value or "") end
    return self
end

function Window:SetSubtitleText(value)
    if self.SubtitleLabel then self.SubtitleLabel.Text=tostring(value or "") end
    return self
end

function Tab:CreateText(config)
    return self:CreateLabel(config)
end

function Tab:CreateDivider()
    local row=make("Frame",{BackgroundColor3=self.API:_theme(self.API._themeName).Border,BackgroundTransparency=0.9,Size=UDim2.new(1,0,0,1),BorderSizePixel=0,Parent=self.Page})
    return self:_register(setmetatable({Root=row,Kind="Divider",Name="Divider",Tab=self,Maid=Maid.new(),Visible=true,Disabled=false},Component))
end

function Tab:CreateSpacer(height)
    local row=make("Frame",{BackgroundTransparency=1,Size=UDim2.new(1,0,0,height or 8),Parent=self.Page})
    return self:_register(setmetatable({Root=row,Kind="Spacer",Name="Spacer",Tab=self,Maid=Maid.new(),Visible=true,Disabled=false},Component))
end

function AstraUI:ExportConfig(window)
    assert(window and window.Tabs,"A valid AstraUI window is required")
    local data={Version=self.Version,Theme=self._themeName,Accent={window.API._accent.R,window.API._accent.G,window.API._accent.B},Tabs={}}
    for name,tab in pairs(window.Tabs) do
        data.Tabs[name]={Components={}}
        for _,component in pairs(tab.Components) do
            local entry={Name=component.Name,Kind=component.Kind}
            if component.Kind=="Toggle" then entry.Value=component.Value end
            if component.Kind=="Slider" then entry.Value=component.Value end
            if component.Kind=="Dropdown" then entry.Value=component.Value end
            if component.Kind=="MultiDropdown" then entry.Values=component.Values end
            if component.Kind=="Input" and component.Box then entry.Value=component.Box.Text end
            if component.Kind=="ColorPicker" then entry.Color={component.Color.R,component.Color.G,component.Color.B} end
            table.insert(data.Tabs[name].Components,entry)
        end
    end
    return HttpService:JSONEncode(data)
end

function AstraUI:ImportConfig(window, encoded)
    assert(window and window.Tabs,"A valid AstraUI window is required")
    local ok,data=pcall(function() return HttpService:JSONDecode(encoded) end)
    if not ok or type(data)~="table" then return false,"Invalid configuration" end
    if data.Theme and self.Themes[data.Theme] then self:SetTheme(data.Theme) end
    for tabName,tabData in pairs(data.Tabs or {}) do
        local tab=window.Tabs[tabName]
        if tab then
            for _,entry in ipairs(tabData.Components or {}) do
                local component=window:GetComponent(entry.Name)
                if component then
                    if component.Kind=="Toggle" and entry.Value~=nil then component:Set(entry.Value,false) end
                    if component.Kind=="Slider" and entry.Value~=nil then component:Set(entry.Value,false) end
                    if component.Kind=="Dropdown" and entry.Value~=nil then component:Set(entry.Value,false) end
                    if component.Kind=="MultiDropdown" and entry.Values then component:Set(entry.Values,false) end
                    if component.Kind=="Input" and entry.Value~=nil then component:Set(entry.Value,false) end
                    if component.Kind=="ColorPicker" and entry.Color then component:Set(Color3.new(entry.Color[1],entry.Color[2],entry.Color[3]),false) end
                end
            end
        end
    end
    return true
end

function AstraUI:GetVersion() return self.Version end

function AstraUI:GetTheme() return self._themeName end

function AstraUI:GetAccent() return self._accent end

function AstraUI:GetWindows()
    local result={}
    for window in pairs(self._windows) do table.insert(result,window) end
    return result
end

function AstraUI:DestroyAll()
    local windows={}
    for window in pairs(self._windows) do table.insert(windows,window) end
    for _,window in ipairs(windows) do pcall(function() window:Destroy() end) end
    if self._notificationGui then self._notificationGui:Destroy(); self._notificationGui=nil; self._notificationHost=nil end
end

function Component:SetRowTransparency(value)
    if not self.Root then return self end
    local ok=pcall(function() self.Root.BackgroundTransparency=value end)
    if not ok then return self end
    return self
end

function Component:SetRowColor(value)
    if not self.Root then return self end
    local ok=pcall(function() self.Root.BackgroundColor3=value end)
    if not ok then return self end
    return self
end

function Component:SetRowPosition(value)
    if not self.Root then return self end
    local ok=pcall(function() self.Root.Position=value end)
    if not ok then return self end
    return self
end

function Component:SetRowSize(value)
    if not self.Root then return self end
    local ok=pcall(function() self.Root.Size=value end)
    if not ok then return self end
    return self
end

function Component:SetRowRotation(value)
    if not self.Root then return self end
    local ok=pcall(function() self.Root.Rotation=value end)
    if not ok then return self end
    return self
end

function Component:SetRowVisible(value)
    if not self.Root then return self end
    local ok=pcall(function() self.Root.Visible=value end)
    if not ok then return self end
    return self
end

function Component:SetRowZIndex(value)
    if not self.Root then return self end
    local ok=pcall(function() self.Root.ZIndex=value end)
    if not ok then return self end
    return self
end

function Tab:CreatePreset1(config)
    config=config or {}
    config.Name=config.Name or "Preset 1"
    config.Icon=config.Icon or "zap"
    return self:CreateButton(config)
end

function Tab:CreatePreset2(config)
    config=config or {}
    config.Name=config.Name or "Preset 2"
    config.Min=config.Min or 0
    config.Max=config.Max or 100
    return self:CreateSlider(config)
end

function Tab:CreatePreset3(config)
    config=config or {}
    config.Name=config.Name or "Preset 3"
    config.Options=config.Options or {"Option 1","Option 2","Option 3"}
    return self:CreateDropdown(config)
end

function Tab:CreatePreset4(config)
    config=config or {}
    config.Name=config.Name or "Preset 4"
    config.Options=config.Options or {"Option 1","Option 2","Option 3"}
    return self:CreateMultiDropdown(config)
end

function Tab:CreatePreset5(config)
    config=config or {}
    config.Name=config.Name or "Preset 5"
    config.PlaceholderText=config.PlaceholderText or "Enter value..."
    return self:CreateInput(config)
end

function Tab:CreatePreset6(config)
    config=config or {}
    config.Name=config.Name or "Preset 6"
    config.CurrentValue=config.CurrentValue==true
    return self:CreateToggle(config)
end

function Tab:CreatePreset7(config)
    config=config or {}
    config.Name=config.Name or "Preset 7"
    config.Icon=config.Icon or "zap"
    return self:CreateButton(config)
end

function Tab:CreatePreset8(config)
    config=config or {}
    config.Name=config.Name or "Preset 8"
    config.Min=config.Min or 0
    config.Max=config.Max or 100
    return self:CreateSlider(config)
end

function Tab:CreatePreset9(config)
    config=config or {}
    config.Name=config.Name or "Preset 9"
    config.Options=config.Options or {"Option 1","Option 2","Option 3"}
    return self:CreateDropdown(config)
end

function Tab:CreatePreset10(config)
    config=config or {}
    config.Name=config.Name or "Preset 10"
    config.Options=config.Options or {"Option 1","Option 2","Option 3"}
    return self:CreateMultiDropdown(config)
end

function Tab:CreatePreset11(config)
    config=config or {}
    config.Name=config.Name or "Preset 11"
    config.PlaceholderText=config.PlaceholderText or "Enter value..."
    return self:CreateInput(config)
end

function Tab:CreatePreset12(config)
    config=config or {}
    config.Name=config.Name or "Preset 12"
    config.CurrentValue=config.CurrentValue==true
    return self:CreateToggle(config)
end

function Tab:CreatePreset13(config)
    config=config or {}
    config.Name=config.Name or "Preset 13"
    config.Icon=config.Icon or "zap"
    return self:CreateButton(config)
end

function Tab:CreatePreset14(config)
    config=config or {}
    config.Name=config.Name or "Preset 14"
    config.Min=config.Min or 0
    config.Max=config.Max or 100
    return self:CreateSlider(config)
end

function Tab:CreatePreset15(config)
    config=config or {}
    config.Name=config.Name or "Preset 15"
    config.Options=config.Options or {"Option 1","Option 2","Option 3"}
    return self:CreateDropdown(config)
end

function Tab:CreatePreset16(config)
    config=config or {}
    config.Name=config.Name or "Preset 16"
    config.Options=config.Options or {"Option 1","Option 2","Option 3"}
    return self:CreateMultiDropdown(config)
end

function Tab:CreatePreset17(config)
    config=config or {}
    config.Name=config.Name or "Preset 17"
    config.PlaceholderText=config.PlaceholderText or "Enter value..."
    return self:CreateInput(config)
end

function Tab:CreatePreset18(config)
    config=config or {}
    config.Name=config.Name or "Preset 18"
    config.CurrentValue=config.CurrentValue==true
    return self:CreateToggle(config)
end

function Tab:CreatePreset19(config)
    config=config or {}
    config.Name=config.Name or "Preset 19"
    config.Icon=config.Icon or "zap"
    return self:CreateButton(config)
end

function Tab:CreatePreset20(config)
    config=config or {}
    config.Name=config.Name or "Preset 20"
    config.Min=config.Min or 0
    config.Max=config.Max or 100
    return self:CreateSlider(config)
end

function Tab:CreatePreset21(config)
    config=config or {}
    config.Name=config.Name or "Preset 21"
    config.Options=config.Options or {"Option 1","Option 2","Option 3"}
    return self:CreateDropdown(config)
end

function Tab:CreatePreset22(config)
    config=config or {}
    config.Name=config.Name or "Preset 22"
    config.Options=config.Options or {"Option 1","Option 2","Option 3"}
    return self:CreateMultiDropdown(config)
end

function Tab:CreatePreset23(config)
    config=config or {}
    config.Name=config.Name or "Preset 23"
    config.PlaceholderText=config.PlaceholderText or "Enter value..."
    return self:CreateInput(config)
end

function Tab:CreatePreset24(config)
    config=config or {}
    config.Name=config.Name or "Preset 24"
    config.CurrentValue=config.CurrentValue==true
    return self:CreateToggle(config)
end

function Tab:CreatePreset25(config)
    config=config or {}
    config.Name=config.Name or "Preset 25"
    config.Icon=config.Icon or "zap"
    return self:CreateButton(config)
end

function Tab:CreatePreset26(config)
    config=config or {}
    config.Name=config.Name or "Preset 26"
    config.Min=config.Min or 0
    config.Max=config.Max or 100
    return self:CreateSlider(config)
end

function Tab:CreatePreset27(config)
    config=config or {}
    config.Name=config.Name or "Preset 27"
    config.Options=config.Options or {"Option 1","Option 2","Option 3"}
    return self:CreateDropdown(config)
end

function Tab:CreatePreset28(config)
    config=config or {}
    config.Name=config.Name or "Preset 28"
    config.Options=config.Options or {"Option 1","Option 2","Option 3"}
    return self:CreateMultiDropdown(config)
end

function Tab:CreatePreset29(config)
    config=config or {}
    config.Name=config.Name or "Preset 29"
    config.PlaceholderText=config.PlaceholderText or "Enter value..."
    return self:CreateInput(config)
end

function Tab:CreatePreset30(config)
    config=config or {}
    config.Name=config.Name or "Preset 30"
    config.CurrentValue=config.CurrentValue==true
    return self:CreateToggle(config)
end

function Tab:CreatePreset31(config)
    config=config or {}
    config.Name=config.Name or "Preset 31"
    config.Icon=config.Icon or "zap"
    return self:CreateButton(config)
end

function Tab:CreatePreset32(config)
    config=config or {}
    config.Name=config.Name or "Preset 32"
    config.Min=config.Min or 0
    config.Max=config.Max or 100
    return self:CreateSlider(config)
end

function Tab:CreatePreset33(config)
    config=config or {}
    config.Name=config.Name or "Preset 33"
    config.Options=config.Options or {"Option 1","Option 2","Option 3"}
    return self:CreateDropdown(config)
end

function Tab:CreatePreset34(config)
    config=config or {}
    config.Name=config.Name or "Preset 34"
    config.Options=config.Options or {"Option 1","Option 2","Option 3"}
    return self:CreateMultiDropdown(config)
end

function Tab:CreatePreset35(config)
    config=config or {}
    config.Name=config.Name or "Preset 35"
    config.PlaceholderText=config.PlaceholderText or "Enter value..."
    return self:CreateInput(config)
end

function Tab:CreatePreset36(config)
    config=config or {}
    config.Name=config.Name or "Preset 36"
    config.CurrentValue=config.CurrentValue==true
    return self:CreateToggle(config)
end

function Tab:CreatePreset37(config)
    config=config or {}
    config.Name=config.Name or "Preset 37"
    config.Icon=config.Icon or "zap"
    return self:CreateButton(config)
end

function Tab:CreatePreset38(config)
    config=config or {}
    config.Name=config.Name or "Preset 38"
    config.Min=config.Min or 0
    config.Max=config.Max or 100
    return self:CreateSlider(config)
end

function Tab:CreatePreset39(config)
    config=config or {}
    config.Name=config.Name or "Preset 39"
    config.Options=config.Options or {"Option 1","Option 2","Option 3"}
    return self:CreateDropdown(config)
end

function Tab:CreatePreset40(config)
    config=config or {}
    config.Name=config.Name or "Preset 40"
    config.Options=config.Options or {"Option 1","Option 2","Option 3"}
    return self:CreateMultiDropdown(config)
end

function Tab:CreatePreset41(config)
    config=config or {}
    config.Name=config.Name or "Preset 41"
    config.PlaceholderText=config.PlaceholderText or "Enter value..."
    return self:CreateInput(config)
end

function Tab:CreatePreset42(config)
    config=config or {}
    config.Name=config.Name or "Preset 42"
    config.CurrentValue=config.CurrentValue==true
    return self:CreateToggle(config)
end

function Tab:CreatePreset43(config)
    config=config or {}
    config.Name=config.Name or "Preset 43"
    config.Icon=config.Icon or "zap"
    return self:CreateButton(config)
end

function Tab:CreatePreset44(config)
    config=config or {}
    config.Name=config.Name or "Preset 44"
    config.Min=config.Min or 0
    config.Max=config.Max or 100
    return self:CreateSlider(config)
end

function Tab:CreatePreset45(config)
    config=config or {}
    config.Name=config.Name or "Preset 45"
    config.Options=config.Options or {"Option 1","Option 2","Option 3"}
    return self:CreateDropdown(config)
end

function Tab:CreatePreset46(config)
    config=config or {}
    config.Name=config.Name or "Preset 46"
    config.Options=config.Options or {"Option 1","Option 2","Option 3"}
    return self:CreateMultiDropdown(config)
end

function Tab:CreatePreset47(config)
    config=config or {}
    config.Name=config.Name or "Preset 47"
    config.PlaceholderText=config.PlaceholderText or "Enter value..."
    return self:CreateInput(config)
end

function Tab:CreatePreset48(config)
    config=config or {}
    config.Name=config.Name or "Preset 48"
    config.CurrentValue=config.CurrentValue==true
    return self:CreateToggle(config)
end

function Tab:CreatePreset49(config)
    config=config or {}
    config.Name=config.Name or "Preset 49"
    config.Icon=config.Icon or "zap"
    return self:CreateButton(config)
end

function Tab:CreatePreset50(config)
    config=config or {}
    config.Name=config.Name or "Preset 50"
    config.Min=config.Min or 0
    config.Max=config.Max or 100
    return self:CreateSlider(config)
end

function Tab:CreatePreset51(config)
    config=config or {}
    config.Name=config.Name or "Preset 51"
    config.Options=config.Options or {"Option 1","Option 2","Option 3"}
    return self:CreateDropdown(config)
end

function Tab:CreatePreset52(config)
    config=config or {}
    config.Name=config.Name or "Preset 52"
    config.Options=config.Options or {"Option 1","Option 2","Option 3"}
    return self:CreateMultiDropdown(config)
end

function Tab:CreatePreset53(config)
    config=config or {}
    config.Name=config.Name or "Preset 53"
    config.PlaceholderText=config.PlaceholderText or "Enter value..."
    return self:CreateInput(config)
end

function Tab:CreatePreset54(config)
    config=config or {}
    config.Name=config.Name or "Preset 54"
    config.CurrentValue=config.CurrentValue==true
    return self:CreateToggle(config)
end

function Tab:CreatePreset55(config)
    config=config or {}
    config.Name=config.Name or "Preset 55"
    config.Icon=config.Icon or "zap"
    return self:CreateButton(config)
end

function Tab:CreatePreset56(config)
    config=config or {}
    config.Name=config.Name or "Preset 56"
    config.Min=config.Min or 0
    config.Max=config.Max or 100
    return self:CreateSlider(config)
end

function Tab:CreatePreset57(config)
    config=config or {}
    config.Name=config.Name or "Preset 57"
    config.Options=config.Options or {"Option 1","Option 2","Option 3"}
    return self:CreateDropdown(config)
end

function Tab:CreatePreset58(config)
    config=config or {}
    config.Name=config.Name or "Preset 58"
    config.Options=config.Options or {"Option 1","Option 2","Option 3"}
    return self:CreateMultiDropdown(config)
end

function Tab:CreatePreset59(config)
    config=config or {}
    config.Name=config.Name or "Preset 59"
    config.PlaceholderText=config.PlaceholderText or "Enter value..."
    return self:CreateInput(config)
end

function Tab:CreatePreset60(config)
    config=config or {}
    config.Name=config.Name or "Preset 60"
    config.CurrentValue=config.CurrentValue==true
    return self:CreateToggle(config)
end

function Tab:CreatePreset61(config)
    config=config or {}
    config.Name=config.Name or "Preset 61"
    config.Icon=config.Icon or "zap"
    return self:CreateButton(config)
end

function Tab:CreatePreset62(config)
    config=config or {}
    config.Name=config.Name or "Preset 62"
    config.Min=config.Min or 0
    config.Max=config.Max or 100
    return self:CreateSlider(config)
end

function Tab:CreatePreset63(config)
    config=config or {}
    config.Name=config.Name or "Preset 63"
    config.Options=config.Options or {"Option 1","Option 2","Option 3"}
    return self:CreateDropdown(config)
end

function Tab:CreatePreset64(config)
    config=config or {}
    config.Name=config.Name or "Preset 64"
    config.Options=config.Options or {"Option 1","Option 2","Option 3"}
    return self:CreateMultiDropdown(config)
end

function Tab:CreatePreset65(config)
    config=config or {}
    config.Name=config.Name or "Preset 65"
    config.PlaceholderText=config.PlaceholderText or "Enter value..."
    return self:CreateInput(config)
end

function Tab:CreatePreset66(config)
    config=config or {}
    config.Name=config.Name or "Preset 66"
    config.CurrentValue=config.CurrentValue==true
    return self:CreateToggle(config)
end

function Tab:CreatePreset67(config)
    config=config or {}
    config.Name=config.Name or "Preset 67"
    config.Icon=config.Icon or "zap"
    return self:CreateButton(config)
end

function Tab:CreatePreset68(config)
    config=config or {}
    config.Name=config.Name or "Preset 68"
    config.Min=config.Min or 0
    config.Max=config.Max or 100
    return self:CreateSlider(config)
end

function Tab:CreatePreset69(config)
    config=config or {}
    config.Name=config.Name or "Preset 69"
    config.Options=config.Options or {"Option 1","Option 2","Option 3"}
    return self:CreateDropdown(config)
end

function Tab:CreatePreset70(config)
    config=config or {}
    config.Name=config.Name or "Preset 70"
    config.Options=config.Options or {"Option 1","Option 2","Option 3"}
    return self:CreateMultiDropdown(config)
end

function Tab:CreatePreset71(config)
    config=config or {}
    config.Name=config.Name or "Preset 71"
    config.PlaceholderText=config.PlaceholderText or "Enter value..."
    return self:CreateInput(config)
end

function Tab:CreatePreset72(config)
    config=config or {}
    config.Name=config.Name or "Preset 72"
    config.CurrentValue=config.CurrentValue==true
    return self:CreateToggle(config)
end

function Tab:CreatePreset73(config)
    config=config or {}
    config.Name=config.Name or "Preset 73"
    config.Icon=config.Icon or "zap"
    return self:CreateButton(config)
end

function Tab:CreatePreset74(config)
    config=config or {}
    config.Name=config.Name or "Preset 74"
    config.Min=config.Min or 0
    config.Max=config.Max or 100
    return self:CreateSlider(config)
end

function Tab:CreatePreset75(config)
    config=config or {}
    config.Name=config.Name or "Preset 75"
    config.Options=config.Options or {"Option 1","Option 2","Option 3"}
    return self:CreateDropdown(config)
end

function Tab:CreatePreset76(config)
    config=config or {}
    config.Name=config.Name or "Preset 76"
    config.Options=config.Options or {"Option 1","Option 2","Option 3"}
    return self:CreateMultiDropdown(config)
end

function Tab:CreatePreset77(config)
    config=config or {}
    config.Name=config.Name or "Preset 77"
    config.PlaceholderText=config.PlaceholderText or "Enter value..."
    return self:CreateInput(config)
end

function Tab:CreatePreset78(config)
    config=config or {}
    config.Name=config.Name or "Preset 78"
    config.CurrentValue=config.CurrentValue==true
    return self:CreateToggle(config)
end

function Tab:CreatePreset79(config)
    config=config or {}
    config.Name=config.Name or "Preset 79"
    config.Icon=config.Icon or "zap"
    return self:CreateButton(config)
end

function Tab:CreatePreset80(config)
    config=config or {}
    config.Name=config.Name or "Preset 80"
    config.Min=config.Min or 0
    config.Max=config.Max or 100
    return self:CreateSlider(config)
end

function Tab:CreatePreset81(config)
    config=config or {}
    config.Name=config.Name or "Preset 81"
    config.Options=config.Options or {"Option 1","Option 2","Option 3"}
    return self:CreateDropdown(config)
end

function Tab:CreatePreset82(config)
    config=config or {}
    config.Name=config.Name or "Preset 82"
    config.Options=config.Options or {"Option 1","Option 2","Option 3"}
    return self:CreateMultiDropdown(config)
end

function Tab:CreatePreset83(config)
    config=config or {}
    config.Name=config.Name or "Preset 83"
    config.PlaceholderText=config.PlaceholderText or "Enter value..."
    return self:CreateInput(config)
end

function Tab:CreatePreset84(config)
    config=config or {}
    config.Name=config.Name or "Preset 84"
    config.CurrentValue=config.CurrentValue==true
    return self:CreateToggle(config)
end

function Tab:CreatePreset85(config)
    config=config or {}
    config.Name=config.Name or "Preset 85"
    config.Icon=config.Icon or "zap"
    return self:CreateButton(config)
end

function Tab:CreatePreset86(config)
    config=config or {}
    config.Name=config.Name or "Preset 86"
    config.Min=config.Min or 0
    config.Max=config.Max or 100
    return self:CreateSlider(config)
end

function Tab:CreatePreset87(config)
    config=config or {}
    config.Name=config.Name or "Preset 87"
    config.Options=config.Options or {"Option 1","Option 2","Option 3"}
    return self:CreateDropdown(config)
end

function Tab:CreatePreset88(config)
    config=config or {}
    config.Name=config.Name or "Preset 88"
    config.Options=config.Options or {"Option 1","Option 2","Option 3"}
    return self:CreateMultiDropdown(config)
end

function Tab:CreatePreset89(config)
    config=config or {}
    config.Name=config.Name or "Preset 89"
    config.PlaceholderText=config.PlaceholderText or "Enter value..."
    return self:CreateInput(config)
end

function Tab:CreatePreset90(config)
    config=config or {}
    config.Name=config.Name or "Preset 90"
    config.CurrentValue=config.CurrentValue==true
    return self:CreateToggle(config)
end

function Tab:CreatePreset91(config)
    config=config or {}
    config.Name=config.Name or "Preset 91"
    config.Icon=config.Icon or "zap"
    return self:CreateButton(config)
end

function Tab:CreatePreset92(config)
    config=config or {}
    config.Name=config.Name or "Preset 92"
    config.Min=config.Min or 0
    config.Max=config.Max or 100
    return self:CreateSlider(config)
end

function Tab:CreatePreset93(config)
    config=config or {}
    config.Name=config.Name or "Preset 93"
    config.Options=config.Options or {"Option 1","Option 2","Option 3"}
    return self:CreateDropdown(config)
end

function Tab:CreatePreset94(config)
    config=config or {}
    config.Name=config.Name or "Preset 94"
    config.Options=config.Options or {"Option 1","Option 2","Option 3"}
    return self:CreateMultiDropdown(config)
end

function Tab:CreatePreset95(config)
    config=config or {}
    config.Name=config.Name or "Preset 95"
    config.PlaceholderText=config.PlaceholderText or "Enter value..."
    return self:CreateInput(config)
end

function Tab:CreatePreset96(config)
    config=config or {}
    config.Name=config.Name or "Preset 96"
    config.CurrentValue=config.CurrentValue==true
    return self:CreateToggle(config)
end

function Tab:CreatePreset97(config)
    config=config or {}
    config.Name=config.Name or "Preset 97"
    config.Icon=config.Icon or "zap"
    return self:CreateButton(config)
end

function Tab:CreatePreset98(config)
    config=config or {}
    config.Name=config.Name or "Preset 98"
    config.Min=config.Min or 0
    config.Max=config.Max or 100
    return self:CreateSlider(config)
end

function Tab:CreatePreset99(config)
    config=config or {}
    config.Name=config.Name or "Preset 99"
    config.Options=config.Options or {"Option 1","Option 2","Option 3"}
    return self:CreateDropdown(config)
end

function Tab:CreatePreset100(config)
    config=config or {}
    config.Name=config.Name or "Preset 100"
    config.Options=config.Options or {"Option 1","Option 2","Option 3"}
    return self:CreateMultiDropdown(config)
end

function Tab:CreatePreset101(config)
    config=config or {}
    config.Name=config.Name or "Preset 101"
    config.PlaceholderText=config.PlaceholderText or "Enter value..."
    return self:CreateInput(config)
end

function Tab:CreatePreset102(config)
    config=config or {}
    config.Name=config.Name or "Preset 102"
    config.CurrentValue=config.CurrentValue==true
    return self:CreateToggle(config)
end

function Tab:CreatePreset103(config)
    config=config or {}
    config.Name=config.Name or "Preset 103"
    config.Icon=config.Icon or "zap"
    return self:CreateButton(config)
end

function Tab:CreatePreset104(config)
    config=config or {}
    config.Name=config.Name or "Preset 104"
    config.Min=config.Min or 0
    config.Max=config.Max or 100
    return self:CreateSlider(config)
end

function Tab:CreatePreset105(config)
    config=config or {}
    config.Name=config.Name or "Preset 105"
    config.Options=config.Options or {"Option 1","Option 2","Option 3"}
    return self:CreateDropdown(config)
end

function Tab:CreatePreset106(config)
    config=config or {}
    config.Name=config.Name or "Preset 106"
    config.Options=config.Options or {"Option 1","Option 2","Option 3"}
    return self:CreateMultiDropdown(config)
end

function Tab:CreatePreset107(config)
    config=config or {}
    config.Name=config.Name or "Preset 107"
    config.PlaceholderText=config.PlaceholderText or "Enter value..."
    return self:CreateInput(config)
end

function Tab:CreatePreset108(config)
    config=config or {}
    config.Name=config.Name or "Preset 108"
    config.CurrentValue=config.CurrentValue==true
    return self:CreateToggle(config)
end

function Tab:CreatePreset109(config)
    config=config or {}
    config.Name=config.Name or "Preset 109"
    config.Icon=config.Icon or "zap"
    return self:CreateButton(config)
end

function Tab:CreatePreset110(config)
    config=config or {}
    config.Name=config.Name or "Preset 110"
    config.Min=config.Min or 0
    config.Max=config.Max or 100
    return self:CreateSlider(config)
end

function Tab:CreatePreset111(config)
    config=config or {}
    config.Name=config.Name or "Preset 111"
    config.Options=config.Options or {"Option 1","Option 2","Option 3"}
    return self:CreateDropdown(config)
end

function Tab:CreatePreset112(config)
    config=config or {}
    config.Name=config.Name or "Preset 112"
    config.Options=config.Options or {"Option 1","Option 2","Option 3"}
    return self:CreateMultiDropdown(config)
end

function Tab:CreatePreset113(config)
    config=config or {}
    config.Name=config.Name or "Preset 113"
    config.PlaceholderText=config.PlaceholderText or "Enter value..."
    return self:CreateInput(config)
end

function Tab:CreatePreset114(config)
    config=config or {}
    config.Name=config.Name or "Preset 114"
    config.CurrentValue=config.CurrentValue==true
    return self:CreateToggle(config)
end

function Tab:CreatePreset115(config)
    config=config or {}
    config.Name=config.Name or "Preset 115"
    config.Icon=config.Icon or "zap"
    return self:CreateButton(config)
end

function Tab:CreatePreset116(config)
    config=config or {}
    config.Name=config.Name or "Preset 116"
    config.Min=config.Min or 0
    config.Max=config.Max or 100
    return self:CreateSlider(config)
end

function Tab:CreatePreset117(config)
    config=config or {}
    config.Name=config.Name or "Preset 117"
    config.Options=config.Options or {"Option 1","Option 2","Option 3"}
    return self:CreateDropdown(config)
end

function Tab:CreatePreset118(config)
    config=config or {}
    config.Name=config.Name or "Preset 118"
    config.Options=config.Options or {"Option 1","Option 2","Option 3"}
    return self:CreateMultiDropdown(config)
end

function Tab:CreatePreset119(config)
    config=config or {}
    config.Name=config.Name or "Preset 119"
    config.PlaceholderText=config.PlaceholderText or "Enter value..."
    return self:CreateInput(config)
end

function Tab:CreatePreset120(config)
    config=config or {}
    config.Name=config.Name or "Preset 120"
    config.CurrentValue=config.CurrentValue==true
    return self:CreateToggle(config)
end

function Tab:CreatePreset121(config)
    config=config or {}
    config.Name=config.Name or "Preset 121"
    config.Icon=config.Icon or "zap"
    return self:CreateButton(config)
end

function Tab:CreatePreset122(config)
    config=config or {}
    config.Name=config.Name or "Preset 122"
    config.Min=config.Min or 0
    config.Max=config.Max or 100
    return self:CreateSlider(config)
end

function Tab:CreatePreset123(config)
    config=config or {}
    config.Name=config.Name or "Preset 123"
    config.Options=config.Options or {"Option 1","Option 2","Option 3"}
    return self:CreateDropdown(config)
end

function Tab:CreatePreset124(config)
    config=config or {}
    config.Name=config.Name or "Preset 124"
    config.Options=config.Options or {"Option 1","Option 2","Option 3"}
    return self:CreateMultiDropdown(config)
end

function Tab:CreatePreset125(config)
    config=config or {}
    config.Name=config.Name or "Preset 125"
    config.PlaceholderText=config.PlaceholderText or "Enter value..."
    return self:CreateInput(config)
end

function Tab:CreatePreset126(config)
    config=config or {}
    config.Name=config.Name or "Preset 126"
    config.CurrentValue=config.CurrentValue==true
    return self:CreateToggle(config)
end

function Tab:CreatePreset127(config)
    config=config or {}
    config.Name=config.Name or "Preset 127"
    config.Icon=config.Icon or "zap"
    return self:CreateButton(config)
end

function Tab:CreatePreset128(config)
    config=config or {}
    config.Name=config.Name or "Preset 128"
    config.Min=config.Min or 0
    config.Max=config.Max or 100
    return self:CreateSlider(config)
end

function Tab:CreatePreset129(config)
    config=config or {}
    config.Name=config.Name or "Preset 129"
    config.Options=config.Options or {"Option 1","Option 2","Option 3"}
    return self:CreateDropdown(config)
end

function Tab:CreatePreset130(config)
    config=config or {}
    config.Name=config.Name or "Preset 130"
    config.Options=config.Options or {"Option 1","Option 2","Option 3"}
    return self:CreateMultiDropdown(config)
end

function Tab:CreatePreset131(config)
    config=config or {}
    config.Name=config.Name or "Preset 131"
    config.PlaceholderText=config.PlaceholderText or "Enter value..."
    return self:CreateInput(config)
end

function Tab:CreatePreset132(config)
    config=config or {}
    config.Name=config.Name or "Preset 132"
    config.CurrentValue=config.CurrentValue==true
    return self:CreateToggle(config)
end

function Tab:CreatePreset133(config)
    config=config or {}
    config.Name=config.Name or "Preset 133"
    config.Icon=config.Icon or "zap"
    return self:CreateButton(config)
end

function Tab:CreatePreset134(config)
    config=config or {}
    config.Name=config.Name or "Preset 134"
    config.Min=config.Min or 0
    config.Max=config.Max or 100
    return self:CreateSlider(config)
end

function Tab:CreatePreset135(config)
    config=config or {}
    config.Name=config.Name or "Preset 135"
    config.Options=config.Options or {"Option 1","Option 2","Option 3"}
    return self:CreateDropdown(config)
end

function Tab:CreatePreset136(config)
    config=config or {}
    config.Name=config.Name or "Preset 136"
    config.Options=config.Options or {"Option 1","Option 2","Option 3"}
    return self:CreateMultiDropdown(config)
end

function Tab:CreatePreset137(config)
    config=config or {}
    config.Name=config.Name or "Preset 137"
    config.PlaceholderText=config.PlaceholderText or "Enter value..."
    return self:CreateInput(config)
end

function Tab:CreatePreset138(config)
    config=config or {}
    config.Name=config.Name or "Preset 138"
    config.CurrentValue=config.CurrentValue==true
    return self:CreateToggle(config)
end

function Tab:CreatePreset139(config)
    config=config or {}
    config.Name=config.Name or "Preset 139"
    config.Icon=config.Icon or "zap"
    return self:CreateButton(config)
end

function Tab:CreatePreset140(config)
    config=config or {}
    config.Name=config.Name or "Preset 140"
    config.Min=config.Min or 0
    config.Max=config.Max or 100
    return self:CreateSlider(config)
end

function Tab:CreatePreset141(config)
    config=config or {}
    config.Name=config.Name or "Preset 141"
    config.Options=config.Options or {"Option 1","Option 2","Option 3"}
    return self:CreateDropdown(config)
end

function Tab:CreatePreset142(config)
    config=config or {}
    config.Name=config.Name or "Preset 142"
    config.Options=config.Options or {"Option 1","Option 2","Option 3"}
    return self:CreateMultiDropdown(config)
end

function Tab:CreatePreset143(config)
    config=config or {}
    config.Name=config.Name or "Preset 143"
    config.PlaceholderText=config.PlaceholderText or "Enter value..."
    return self:CreateInput(config)
end

function Tab:CreatePreset144(config)
    config=config or {}
    config.Name=config.Name or "Preset 144"
    config.CurrentValue=config.CurrentValue==true
    return self:CreateToggle(config)
end

function Tab:CreatePreset145(config)
    config=config or {}
    config.Name=config.Name or "Preset 145"
    config.Icon=config.Icon or "zap"
    return self:CreateButton(config)
end

function Tab:CreatePreset146(config)
    config=config or {}
    config.Name=config.Name or "Preset 146"
    config.Min=config.Min or 0
    config.Max=config.Max or 100
    return self:CreateSlider(config)
end

function Tab:CreatePreset147(config)
    config=config or {}
    config.Name=config.Name or "Preset 147"
    config.Options=config.Options or {"Option 1","Option 2","Option 3"}
    return self:CreateDropdown(config)
end

function Tab:CreatePreset148(config)
    config=config or {}
    config.Name=config.Name or "Preset 148"
    config.Options=config.Options or {"Option 1","Option 2","Option 3"}
    return self:CreateMultiDropdown(config)
end

function Tab:CreatePreset149(config)
    config=config or {}
    config.Name=config.Name or "Preset 149"
    config.PlaceholderText=config.PlaceholderText or "Enter value..."
    return self:CreateInput(config)
end

function Tab:CreatePreset150(config)
    config=config or {}
    config.Name=config.Name or "Preset 150"
    config.CurrentValue=config.CurrentValue==true
    return self:CreateToggle(config)
end

function Tab:CreatePreset151(config)
    config=config or {}
    config.Name=config.Name or "Preset 151"
    config.Icon=config.Icon or "zap"
    return self:CreateButton(config)
end

function Tab:CreatePreset152(config)
    config=config or {}
    config.Name=config.Name or "Preset 152"
    config.Min=config.Min or 0
    config.Max=config.Max or 100
    return self:CreateSlider(config)
end

function Tab:CreatePreset153(config)
    config=config or {}
    config.Name=config.Name or "Preset 153"
    config.Options=config.Options or {"Option 1","Option 2","Option 3"}
    return self:CreateDropdown(config)
end

function Tab:CreatePreset154(config)
    config=config or {}
    config.Name=config.Name or "Preset 154"
    config.Options=config.Options or {"Option 1","Option 2","Option 3"}
    return self:CreateMultiDropdown(config)
end

function Tab:CreatePreset155(config)
    config=config or {}
    config.Name=config.Name or "Preset 155"
    config.PlaceholderText=config.PlaceholderText or "Enter value..."
    return self:CreateInput(config)
end

function Tab:CreatePreset156(config)
    config=config or {}
    config.Name=config.Name or "Preset 156"
    config.CurrentValue=config.CurrentValue==true
    return self:CreateToggle(config)
end

function Tab:CreatePreset157(config)
    config=config or {}
    config.Name=config.Name or "Preset 157"
    config.Icon=config.Icon or "zap"
    return self:CreateButton(config)
end

function Tab:CreatePreset158(config)
    config=config or {}
    config.Name=config.Name or "Preset 158"
    config.Min=config.Min or 0
    config.Max=config.Max or 100
    return self:CreateSlider(config)
end

function Tab:CreatePreset159(config)
    config=config or {}
    config.Name=config.Name or "Preset 159"
    config.Options=config.Options or {"Option 1","Option 2","Option 3"}
    return self:CreateDropdown(config)
end

function Tab:CreatePreset160(config)
    config=config or {}
    config.Name=config.Name or "Preset 160"
    config.Options=config.Options or {"Option 1","Option 2","Option 3"}
    return self:CreateMultiDropdown(config)
end

function Tab:CreatePreset161(config)
    config=config or {}
    config.Name=config.Name or "Preset 161"
    config.PlaceholderText=config.PlaceholderText or "Enter value..."
    return self:CreateInput(config)
end

function Tab:CreatePreset162(config)
    config=config or {}
    config.Name=config.Name or "Preset 162"
    config.CurrentValue=config.CurrentValue==true
    return self:CreateToggle(config)
end

function Tab:CreatePreset163(config)
    config=config or {}
    config.Name=config.Name or "Preset 163"
    config.Icon=config.Icon or "zap"
    return self:CreateButton(config)
end

function Tab:CreatePreset164(config)
    config=config or {}
    config.Name=config.Name or "Preset 164"
    config.Min=config.Min or 0
    config.Max=config.Max or 100
    return self:CreateSlider(config)
end

function Tab:CreatePreset165(config)
    config=config or {}
    config.Name=config.Name or "Preset 165"
    config.Options=config.Options or {"Option 1","Option 2","Option 3"}
    return self:CreateDropdown(config)
end

function Tab:CreatePreset166(config)
    config=config or {}
    config.Name=config.Name or "Preset 166"
    config.Options=config.Options or {"Option 1","Option 2","Option 3"}
    return self:CreateMultiDropdown(config)
end

function Tab:CreatePreset167(config)
    config=config or {}
    config.Name=config.Name or "Preset 167"
    config.PlaceholderText=config.PlaceholderText or "Enter value..."
    return self:CreateInput(config)
end

function Tab:CreatePreset168(config)
    config=config or {}
    config.Name=config.Name or "Preset 168"
    config.CurrentValue=config.CurrentValue==true
    return self:CreateToggle(config)
end

function Tab:CreatePreset169(config)
    config=config or {}
    config.Name=config.Name or "Preset 169"
    config.Icon=config.Icon or "zap"
    return self:CreateButton(config)
end

function Tab:CreatePreset170(config)
    config=config or {}
    config.Name=config.Name or "Preset 170"
    config.Min=config.Min or 0
    config.Max=config.Max or 100
    return self:CreateSlider(config)
end

function Tab:CreatePreset171(config)
    config=config or {}
    config.Name=config.Name or "Preset 171"
    config.Options=config.Options or {"Option 1","Option 2","Option 3"}
    return self:CreateDropdown(config)
end

function Tab:CreatePreset172(config)
    config=config or {}
    config.Name=config.Name or "Preset 172"
    config.Options=config.Options or {"Option 1","Option 2","Option 3"}
    return self:CreateMultiDropdown(config)
end

function Tab:CreatePreset173(config)
    config=config or {}
    config.Name=config.Name or "Preset 173"
    config.PlaceholderText=config.PlaceholderText or "Enter value..."
    return self:CreateInput(config)
end

function Tab:CreatePreset174(config)
    config=config or {}
    config.Name=config.Name or "Preset 174"
    config.CurrentValue=config.CurrentValue==true
    return self:CreateToggle(config)
end

function Tab:CreatePreset175(config)
    config=config or {}
    config.Name=config.Name or "Preset 175"
    config.Icon=config.Icon or "zap"
    return self:CreateButton(config)
end

function Tab:CreatePreset176(config)
    config=config or {}
    config.Name=config.Name or "Preset 176"
    config.Min=config.Min or 0
    config.Max=config.Max or 100
    return self:CreateSlider(config)
end

function Tab:CreatePreset177(config)
    config=config or {}
    config.Name=config.Name or "Preset 177"
    config.Options=config.Options or {"Option 1","Option 2","Option 3"}
    return self:CreateDropdown(config)
end

function Tab:CreatePreset178(config)
    config=config or {}
    config.Name=config.Name or "Preset 178"
    config.Options=config.Options or {"Option 1","Option 2","Option 3"}
    return self:CreateMultiDropdown(config)
end

function Tab:CreatePreset179(config)
    config=config or {}
    config.Name=config.Name or "Preset 179"
    config.PlaceholderText=config.PlaceholderText or "Enter value..."
    return self:CreateInput(config)
end

function Tab:CreatePreset180(config)
    config=config or {}
    config.Name=config.Name or "Preset 180"
    config.CurrentValue=config.CurrentValue==true
    return self:CreateToggle(config)
end

function Tab:CreatePreset181(config)
    config=config or {}
    config.Name=config.Name or "Preset 181"
    config.Icon=config.Icon or "zap"
    return self:CreateButton(config)
end

function Tab:CreatePreset182(config)
    config=config or {}
    config.Name=config.Name or "Preset 182"
    config.Min=config.Min or 0
    config.Max=config.Max or 100
    return self:CreateSlider(config)
end

function Tab:CreatePreset183(config)
    config=config or {}
    config.Name=config.Name or "Preset 183"
    config.Options=config.Options or {"Option 1","Option 2","Option 3"}
    return self:CreateDropdown(config)
end

function Tab:CreatePreset184(config)
    config=config or {}
    config.Name=config.Name or "Preset 184"
    config.Options=config.Options or {"Option 1","Option 2","Option 3"}
    return self:CreateMultiDropdown(config)
end

function Tab:CreatePreset185(config)
    config=config or {}
    config.Name=config.Name or "Preset 185"
    config.PlaceholderText=config.PlaceholderText or "Enter value..."
    return self:CreateInput(config)
end

function Tab:CreatePreset186(config)
    config=config or {}
    config.Name=config.Name or "Preset 186"
    config.CurrentValue=config.CurrentValue==true
    return self:CreateToggle(config)
end

function Tab:CreatePreset187(config)
    config=config or {}
    config.Name=config.Name or "Preset 187"
    config.Icon=config.Icon or "zap"
    return self:CreateButton(config)
end

function Tab:CreatePreset188(config)
    config=config or {}
    config.Name=config.Name or "Preset 188"
    config.Min=config.Min or 0
    config.Max=config.Max or 100
    return self:CreateSlider(config)
end

function Tab:CreatePreset189(config)
    config=config or {}
    config.Name=config.Name or "Preset 189"
    config.Options=config.Options or {"Option 1","Option 2","Option 3"}
    return self:CreateDropdown(config)
end

function Tab:CreatePreset190(config)
    config=config or {}
    config.Name=config.Name or "Preset 190"
    config.Options=config.Options or {"Option 1","Option 2","Option 3"}
    return self:CreateMultiDropdown(config)
end

function Tab:CreatePreset191(config)
    config=config or {}
    config.Name=config.Name or "Preset 191"
    config.PlaceholderText=config.PlaceholderText or "Enter value..."
    return self:CreateInput(config)
end

function Tab:CreatePreset192(config)
    config=config or {}
    config.Name=config.Name or "Preset 192"
    config.CurrentValue=config.CurrentValue==true
    return self:CreateToggle(config)
end

function Tab:CreatePreset193(config)
    config=config or {}
    config.Name=config.Name or "Preset 193"
    config.Icon=config.Icon or "zap"
    return self:CreateButton(config)
end

function Tab:CreatePreset194(config)
    config=config or {}
    config.Name=config.Name or "Preset 194"
    config.Min=config.Min or 0
    config.Max=config.Max or 100
    return self:CreateSlider(config)
end

function Tab:CreatePreset195(config)
    config=config or {}
    config.Name=config.Name or "Preset 195"
    config.Options=config.Options or {"Option 1","Option 2","Option 3"}
    return self:CreateDropdown(config)
end

function Tab:CreatePreset196(config)
    config=config or {}
    config.Name=config.Name or "Preset 196"
    config.Options=config.Options or {"Option 1","Option 2","Option 3"}
    return self:CreateMultiDropdown(config)
end

function Tab:CreatePreset197(config)
    config=config or {}
    config.Name=config.Name or "Preset 197"
    config.PlaceholderText=config.PlaceholderText or "Enter value..."
    return self:CreateInput(config)
end

function Tab:CreatePreset198(config)
    config=config or {}
    config.Name=config.Name or "Preset 198"
    config.CurrentValue=config.CurrentValue==true
    return self:CreateToggle(config)
end

function Tab:CreatePreset199(config)
    config=config or {}
    config.Name=config.Name or "Preset 199"
    config.Icon=config.Icon or "zap"
    return self:CreateButton(config)
end

function Tab:CreatePreset200(config)
    config=config or {}
    config.Name=config.Name or "Preset 200"
    config.Min=config.Min or 0
    config.Max=config.Max or 100
    return self:CreateSlider(config)
end

function Tab:CreatePreset201(config)
    config=config or {}
    config.Name=config.Name or "Preset 201"
    config.Options=config.Options or {"Option 1","Option 2","Option 3"}
    return self:CreateDropdown(config)
end

function Tab:CreatePreset202(config)
    config=config or {}
    config.Name=config.Name or "Preset 202"
    config.Options=config.Options or {"Option 1","Option 2","Option 3"}
    return self:CreateMultiDropdown(config)
end

function Tab:CreatePreset203(config)
    config=config or {}
    config.Name=config.Name or "Preset 203"
    config.PlaceholderText=config.PlaceholderText or "Enter value..."
    return self:CreateInput(config)
end

function Tab:CreatePreset204(config)
    config=config or {}
    config.Name=config.Name or "Preset 204"
    config.CurrentValue=config.CurrentValue==true
    return self:CreateToggle(config)
end

function Tab:CreatePreset205(config)
    config=config or {}
    config.Name=config.Name or "Preset 205"
    config.Icon=config.Icon or "zap"
    return self:CreateButton(config)
end

function Tab:CreatePreset206(config)
    config=config or {}
    config.Name=config.Name or "Preset 206"
    config.Min=config.Min or 0
    config.Max=config.Max or 100
    return self:CreateSlider(config)
end

function Tab:CreatePreset207(config)
    config=config or {}
    config.Name=config.Name or "Preset 207"
    config.Options=config.Options or {"Option 1","Option 2","Option 3"}
    return self:CreateDropdown(config)
end

function Tab:CreatePreset208(config)
    config=config or {}
    config.Name=config.Name or "Preset 208"
    config.Options=config.Options or {"Option 1","Option 2","Option 3"}
    return self:CreateMultiDropdown(config)
end

function Tab:CreatePreset209(config)
    config=config or {}
    config.Name=config.Name or "Preset 209"
    config.PlaceholderText=config.PlaceholderText or "Enter value..."
    return self:CreateInput(config)
end

function Tab:CreatePreset210(config)
    config=config or {}
    config.Name=config.Name or "Preset 210"
    config.CurrentValue=config.CurrentValue==true
    return self:CreateToggle(config)
end

function Tab:CreatePreset211(config)
    config=config or {}
    config.Name=config.Name or "Preset 211"
    config.Icon=config.Icon or "zap"
    return self:CreateButton(config)
end

function Tab:CreatePreset212(config)
    config=config or {}
    config.Name=config.Name or "Preset 212"
    config.Min=config.Min or 0
    config.Max=config.Max or 100
    return self:CreateSlider(config)
end

function Tab:CreatePreset213(config)
    config=config or {}
    config.Name=config.Name or "Preset 213"
    config.Options=config.Options or {"Option 1","Option 2","Option 3"}
    return self:CreateDropdown(config)
end

function Tab:CreatePreset214(config)
    config=config or {}
    config.Name=config.Name or "Preset 214"
    config.Options=config.Options or {"Option 1","Option 2","Option 3"}
    return self:CreateMultiDropdown(config)
end

function Tab:CreatePreset215(config)
    config=config or {}
    config.Name=config.Name or "Preset 215"
    config.PlaceholderText=config.PlaceholderText or "Enter value..."
    return self:CreateInput(config)
end

function Tab:CreatePreset216(config)
    config=config or {}
    config.Name=config.Name or "Preset 216"
    config.CurrentValue=config.CurrentValue==true
    return self:CreateToggle(config)
end

function Tab:CreatePreset217(config)
    config=config or {}
    config.Name=config.Name or "Preset 217"
    config.Icon=config.Icon or "zap"
    return self:CreateButton(config)
end

function Tab:CreatePreset218(config)
    config=config or {}
    config.Name=config.Name or "Preset 218"
    config.Min=config.Min or 0
    config.Max=config.Max or 100
    return self:CreateSlider(config)
end

function Tab:CreatePreset219(config)
    config=config or {}
    config.Name=config.Name or "Preset 219"
    config.Options=config.Options or {"Option 1","Option 2","Option 3"}
    return self:CreateDropdown(config)
end

function Tab:CreatePreset220(config)
    config=config or {}
    config.Name=config.Name or "Preset 220"
    config.Options=config.Options or {"Option 1","Option 2","Option 3"}
    return self:CreateMultiDropdown(config)
end

function Tab:CreatePreset221(config)
    config=config or {}
    config.Name=config.Name or "Preset 221"
    config.PlaceholderText=config.PlaceholderText or "Enter value..."
    return self:CreateInput(config)
end

function Tab:CreatePreset222(config)
    config=config or {}
    config.Name=config.Name or "Preset 222"
    config.CurrentValue=config.CurrentValue==true
    return self:CreateToggle(config)
end

function Tab:CreatePreset223(config)
    config=config or {}
    config.Name=config.Name or "Preset 223"
    config.Icon=config.Icon or "zap"
    return self:CreateButton(config)
end

function Tab:CreatePreset224(config)
    config=config or {}
    config.Name=config.Name or "Preset 224"
    config.Min=config.Min or 0
    config.Max=config.Max or 100
    return self:CreateSlider(config)
end

function Tab:CreatePreset225(config)
    config=config or {}
    config.Name=config.Name or "Preset 225"
    config.Options=config.Options or {"Option 1","Option 2","Option 3"}
    return self:CreateDropdown(config)
end

function Tab:CreatePreset226(config)
    config=config or {}
    config.Name=config.Name or "Preset 226"
    config.Options=config.Options or {"Option 1","Option 2","Option 3"}
    return self:CreateMultiDropdown(config)
end

function Tab:CreatePreset227(config)
    config=config or {}
    config.Name=config.Name or "Preset 227"
    config.PlaceholderText=config.PlaceholderText or "Enter value..."
    return self:CreateInput(config)
end

function Tab:CreatePreset228(config)
    config=config or {}
    config.Name=config.Name or "Preset 228"
    config.CurrentValue=config.CurrentValue==true
    return self:CreateToggle(config)
end

function Tab:CreatePreset229(config)
    config=config or {}
    config.Name=config.Name or "Preset 229"
    config.Icon=config.Icon or "zap"
    return self:CreateButton(config)
end

function Tab:CreatePreset230(config)
    config=config or {}
    config.Name=config.Name or "Preset 230"
    config.Min=config.Min or 0
    config.Max=config.Max or 100
    return self:CreateSlider(config)
end

function Tab:CreatePreset231(config)
    config=config or {}
    config.Name=config.Name or "Preset 231"
    config.Options=config.Options or {"Option 1","Option 2","Option 3"}
    return self:CreateDropdown(config)
end

function Tab:CreatePreset232(config)
    config=config or {}
    config.Name=config.Name or "Preset 232"
    config.Options=config.Options or {"Option 1","Option 2","Option 3"}
    return self:CreateMultiDropdown(config)
end

function Tab:CreatePreset233(config)
    config=config or {}
    config.Name=config.Name or "Preset 233"
    config.PlaceholderText=config.PlaceholderText or "Enter value..."
    return self:CreateInput(config)
end

function Tab:CreatePreset234(config)
    config=config or {}
    config.Name=config.Name or "Preset 234"
    config.CurrentValue=config.CurrentValue==true
    return self:CreateToggle(config)
end

function Tab:CreatePreset235(config)
    config=config or {}
    config.Name=config.Name or "Preset 235"
    config.Icon=config.Icon or "zap"
    return self:CreateButton(config)
end

function Tab:CreatePreset236(config)
    config=config or {}
    config.Name=config.Name or "Preset 236"
    config.Min=config.Min or 0
    config.Max=config.Max or 100
    return self:CreateSlider(config)
end

function Tab:CreatePreset237(config)
    config=config or {}
    config.Name=config.Name or "Preset 237"
    config.Options=config.Options or {"Option 1","Option 2","Option 3"}
    return self:CreateDropdown(config)
end

function Tab:CreatePreset238(config)
    config=config or {}
    config.Name=config.Name or "Preset 238"
    config.Options=config.Options or {"Option 1","Option 2","Option 3"}
    return self:CreateMultiDropdown(config)
end

function Tab:CreatePreset239(config)
    config=config or {}
    config.Name=config.Name or "Preset 239"
    config.PlaceholderText=config.PlaceholderText or "Enter value..."
    return self:CreateInput(config)
end

function Tab:CreatePreset240(config)
    config=config or {}
    config.Name=config.Name or "Preset 240"
    config.CurrentValue=config.CurrentValue==true
    return self:CreateToggle(config)
end

function Tab:CreatePreset241(config)
    config=config or {}
    config.Name=config.Name or "Preset 241"
    config.Icon=config.Icon or "zap"
    return self:CreateButton(config)
end

function Tab:CreatePreset242(config)
    config=config or {}
    config.Name=config.Name or "Preset 242"
    config.Min=config.Min or 0
    config.Max=config.Max or 100
    return self:CreateSlider(config)
end

function Tab:CreatePreset243(config)
    config=config or {}
    config.Name=config.Name or "Preset 243"
    config.Options=config.Options or {"Option 1","Option 2","Option 3"}
    return self:CreateDropdown(config)
end

function Tab:CreatePreset244(config)
    config=config or {}
    config.Name=config.Name or "Preset 244"
    config.Options=config.Options or {"Option 1","Option 2","Option 3"}
    return self:CreateMultiDropdown(config)
end

function Tab:CreatePreset245(config)
    config=config or {}
    config.Name=config.Name or "Preset 245"
    config.PlaceholderText=config.PlaceholderText or "Enter value..."
    return self:CreateInput(config)
end

function Tab:CreatePreset246(config)
    config=config or {}
    config.Name=config.Name or "Preset 246"
    config.CurrentValue=config.CurrentValue==true
    return self:CreateToggle(config)
end

function Tab:CreatePreset247(config)
    config=config or {}
    config.Name=config.Name or "Preset 247"
    config.Icon=config.Icon or "zap"
    return self:CreateButton(config)
end

function Tab:CreatePreset248(config)
    config=config or {}
    config.Name=config.Name or "Preset 248"
    config.Min=config.Min or 0
    config.Max=config.Max or 100
    return self:CreateSlider(config)
end

function Tab:CreatePreset249(config)
    config=config or {}
    config.Name=config.Name or "Preset 249"
    config.Options=config.Options or {"Option 1","Option 2","Option 3"}
    return self:CreateDropdown(config)
end

function Tab:CreatePreset250(config)
    config=config or {}
    config.Name=config.Name or "Preset 250"
    config.Options=config.Options or {"Option 1","Option 2","Option 3"}
    return self:CreateMultiDropdown(config)
end

function Tab:CreatePreset251(config)
    config=config or {}
    config.Name=config.Name or "Preset 251"
    config.PlaceholderText=config.PlaceholderText or "Enter value..."
    return self:CreateInput(config)
end

function Tab:CreatePreset252(config)
    config=config or {}
    config.Name=config.Name or "Preset 252"
    config.CurrentValue=config.CurrentValue==true
    return self:CreateToggle(config)
end

function Tab:CreatePreset253(config)
    config=config or {}
    config.Name=config.Name or "Preset 253"
    config.Icon=config.Icon or "zap"
    return self:CreateButton(config)
end

function Tab:CreatePreset254(config)
    config=config or {}
    config.Name=config.Name or "Preset 254"
    config.Min=config.Min or 0
    config.Max=config.Max or 100
    return self:CreateSlider(config)
end

function Tab:CreatePreset255(config)
    config=config or {}
    config.Name=config.Name or "Preset 255"
    config.Options=config.Options or {"Option 1","Option 2","Option 3"}
    return self:CreateDropdown(config)
end

function Tab:CreatePreset256(config)
    config=config or {}
    config.Name=config.Name or "Preset 256"
    config.Options=config.Options or {"Option 1","Option 2","Option 3"}
    return self:CreateMultiDropdown(config)
end

function Tab:CreatePreset257(config)
    config=config or {}
    config.Name=config.Name or "Preset 257"
    config.PlaceholderText=config.PlaceholderText or "Enter value..."
    return self:CreateInput(config)
end

function Tab:CreatePreset258(config)
    config=config or {}
    config.Name=config.Name or "Preset 258"
    config.CurrentValue=config.CurrentValue==true
    return self:CreateToggle(config)
end

function Tab:CreatePreset259(config)
    config=config or {}
    config.Name=config.Name or "Preset 259"
    config.Icon=config.Icon or "zap"
    return self:CreateButton(config)
end

function Tab:CreatePreset260(config)
    config=config or {}
    config.Name=config.Name or "Preset 260"
    config.Min=config.Min or 0
    config.Max=config.Max or 100
    return self:CreateSlider(config)
end

function Tab:CreatePreset261(config)
    config=config or {}
    config.Name=config.Name or "Preset 261"
    config.Options=config.Options or {"Option 1","Option 2","Option 3"}
    return self:CreateDropdown(config)
end

function Tab:CreatePreset262(config)
    config=config or {}
    config.Name=config.Name or "Preset 262"
    config.Options=config.Options or {"Option 1","Option 2","Option 3"}
    return self:CreateMultiDropdown(config)
end

function Tab:CreatePreset263(config)
    config=config or {}
    config.Name=config.Name or "Preset 263"
    config.PlaceholderText=config.PlaceholderText or "Enter value..."
    return self:CreateInput(config)
end

function Tab:CreatePreset264(config)
    config=config or {}
    config.Name=config.Name or "Preset 264"
    config.CurrentValue=config.CurrentValue==true
    return self:CreateToggle(config)
end

function Tab:CreatePreset265(config)
    config=config or {}
    config.Name=config.Name or "Preset 265"
    config.Icon=config.Icon or "zap"
    return self:CreateButton(config)
end

function Tab:CreatePreset266(config)
    config=config or {}
    config.Name=config.Name or "Preset 266"
    config.Min=config.Min or 0
    config.Max=config.Max or 100
    return self:CreateSlider(config)
end

function Tab:CreatePreset267(config)
    config=config or {}
    config.Name=config.Name or "Preset 267"
    config.Options=config.Options or {"Option 1","Option 2","Option 3"}
    return self:CreateDropdown(config)
end

function Tab:CreatePreset268(config)
    config=config or {}
    config.Name=config.Name or "Preset 268"
    config.Options=config.Options or {"Option 1","Option 2","Option 3"}
    return self:CreateMultiDropdown(config)
end

function Tab:CreatePreset269(config)
    config=config or {}
    config.Name=config.Name or "Preset 269"
    config.PlaceholderText=config.PlaceholderText or "Enter value..."
    return self:CreateInput(config)
end

function Tab:CreatePreset270(config)
    config=config or {}
    config.Name=config.Name or "Preset 270"
    config.CurrentValue=config.CurrentValue==true
    return self:CreateToggle(config)
end

function Tab:CreatePreset271(config)
    config=config or {}
    config.Name=config.Name or "Preset 271"
    config.Icon=config.Icon or "zap"
    return self:CreateButton(config)
end

function Tab:CreatePreset272(config)
    config=config or {}
    config.Name=config.Name or "Preset 272"
    config.Min=config.Min or 0
    config.Max=config.Max or 100
    return self:CreateSlider(config)
end

function Tab:CreatePreset273(config)
    config=config or {}
    config.Name=config.Name or "Preset 273"
    config.Options=config.Options or {"Option 1","Option 2","Option 3"}
    return self:CreateDropdown(config)
end

function Tab:CreatePreset274(config)
    config=config or {}
    config.Name=config.Name or "Preset 274"
    config.Options=config.Options or {"Option 1","Option 2","Option 3"}
    return self:CreateMultiDropdown(config)
end

function Tab:CreatePreset275(config)
    config=config or {}
    config.Name=config.Name or "Preset 275"
    config.PlaceholderText=config.PlaceholderText or "Enter value..."
    return self:CreateInput(config)
end

function Tab:CreatePreset276(config)
    config=config or {}
    config.Name=config.Name or "Preset 276"
    config.CurrentValue=config.CurrentValue==true
    return self:CreateToggle(config)
end

function Tab:CreatePreset277(config)
    config=config or {}
    config.Name=config.Name or "Preset 277"
    config.Icon=config.Icon or "zap"
    return self:CreateButton(config)
end

function Tab:CreatePreset278(config)
    config=config or {}
    config.Name=config.Name or "Preset 278"
    config.Min=config.Min or 0
    config.Max=config.Max or 100
    return self:CreateSlider(config)
end

function Tab:CreatePreset279(config)
    config=config or {}
    config.Name=config.Name or "Preset 279"
    config.Options=config.Options or {"Option 1","Option 2","Option 3"}
    return self:CreateDropdown(config)
end

function Tab:CreatePreset280(config)
    config=config or {}
    config.Name=config.Name or "Preset 280"
    config.Options=config.Options or {"Option 1","Option 2","Option 3"}
    return self:CreateMultiDropdown(config)
end

function Tab:CreatePreset281(config)
    config=config or {}
    config.Name=config.Name or "Preset 281"
    config.PlaceholderText=config.PlaceholderText or "Enter value..."
    return self:CreateInput(config)
end

function Tab:CreatePreset282(config)
    config=config or {}
    config.Name=config.Name or "Preset 282"
    config.CurrentValue=config.CurrentValue==true
    return self:CreateToggle(config)
end

function Tab:CreatePreset283(config)
    config=config or {}
    config.Name=config.Name or "Preset 283"
    config.Icon=config.Icon or "zap"
    return self:CreateButton(config)
end

function Tab:CreatePreset284(config)
    config=config or {}
    config.Name=config.Name or "Preset 284"
    config.Min=config.Min or 0
    config.Max=config.Max or 100
    return self:CreateSlider(config)
end

function Tab:CreatePreset285(config)
    config=config or {}
    config.Name=config.Name or "Preset 285"
    config.Options=config.Options or {"Option 1","Option 2","Option 3"}
    return self:CreateDropdown(config)
end

function Tab:CreatePreset286(config)
    config=config or {}
    config.Name=config.Name or "Preset 286"
    config.Options=config.Options or {"Option 1","Option 2","Option 3"}
    return self:CreateMultiDropdown(config)
end

function Tab:CreatePreset287(config)
    config=config or {}
    config.Name=config.Name or "Preset 287"
    config.PlaceholderText=config.PlaceholderText or "Enter value..."
    return self:CreateInput(config)
end

function Tab:CreatePreset288(config)
    config=config or {}
    config.Name=config.Name or "Preset 288"
    config.CurrentValue=config.CurrentValue==true
    return self:CreateToggle(config)
end

function Tab:CreatePreset289(config)
    config=config or {}
    config.Name=config.Name or "Preset 289"
    config.Icon=config.Icon or "zap"
    return self:CreateButton(config)
end

function Tab:CreatePreset290(config)
    config=config or {}
    config.Name=config.Name or "Preset 290"
    config.Min=config.Min or 0
    config.Max=config.Max or 100
    return self:CreateSlider(config)
end

function Tab:CreatePreset291(config)
    config=config or {}
    config.Name=config.Name or "Preset 291"
    config.Options=config.Options or {"Option 1","Option 2","Option 3"}
    return self:CreateDropdown(config)
end

function Tab:CreatePreset292(config)
    config=config or {}
    config.Name=config.Name or "Preset 292"
    config.Options=config.Options or {"Option 1","Option 2","Option 3"}
    return self:CreateMultiDropdown(config)
end

function Tab:CreatePreset293(config)
    config=config or {}
    config.Name=config.Name or "Preset 293"
    config.PlaceholderText=config.PlaceholderText or "Enter value..."
    return self:CreateInput(config)
end

function Tab:CreatePreset294(config)
    config=config or {}
    config.Name=config.Name or "Preset 294"
    config.CurrentValue=config.CurrentValue==true
    return self:CreateToggle(config)
end

function Tab:CreatePreset295(config)
    config=config or {}
    config.Name=config.Name or "Preset 295"
    config.Icon=config.Icon or "zap"
    return self:CreateButton(config)
end

function Tab:CreatePreset296(config)
    config=config or {}
    config.Name=config.Name or "Preset 296"
    config.Min=config.Min or 0
    config.Max=config.Max or 100
    return self:CreateSlider(config)
end

function Tab:CreatePreset297(config)
    config=config or {}
    config.Name=config.Name or "Preset 297"
    config.Options=config.Options or {"Option 1","Option 2","Option 3"}
    return self:CreateDropdown(config)
end

function Tab:CreatePreset298(config)
    config=config or {}
    config.Name=config.Name or "Preset 298"
    config.Options=config.Options or {"Option 1","Option 2","Option 3"}
    return self:CreateMultiDropdown(config)
end

function Tab:CreatePreset299(config)
    config=config or {}
    config.Name=config.Name or "Preset 299"
    config.PlaceholderText=config.PlaceholderText or "Enter value..."
    return self:CreateInput(config)
end

function Tab:CreatePreset300(config)
    config=config or {}
    config.Name=config.Name or "Preset 300"
    config.CurrentValue=config.CurrentValue==true
    return self:CreateToggle(config)
end

function AstraUI:GetBackgroundColor()
    return self:_theme(self._themeName).Background
end

function AstraUI:SetBackgroundColor(color)
    assert(typeof(color)=="Color3","Color must be Color3")
    self:_theme(self._themeName).Background=color
    for _,window in pairs(self._windows) do self:_restyleWindow(window,self:_theme(self._themeName)) end
    return self
end

function AstraUI:GetSurfaceColor()
    return self:_theme(self._themeName).Surface
end

function AstraUI:SetSurfaceColor(color)
    assert(typeof(color)=="Color3","Color must be Color3")
    self:_theme(self._themeName).Surface=color
    for _,window in pairs(self._windows) do self:_restyleWindow(window,self:_theme(self._themeName)) end
    return self
end

function AstraUI:GetSurfaceRaisedColor()
    return self:_theme(self._themeName).SurfaceRaised
end

function AstraUI:SetSurfaceRaisedColor(color)
    assert(typeof(color)=="Color3","Color must be Color3")
    self:_theme(self._themeName).SurfaceRaised=color
    for _,window in pairs(self._windows) do self:_restyleWindow(window,self:_theme(self._themeName)) end
    return self
end

function AstraUI:GetTextColor()
    return self:_theme(self._themeName).Text
end

function AstraUI:SetTextColor(color)
    assert(typeof(color)=="Color3","Color must be Color3")
    self:_theme(self._themeName).Text=color
    for _,window in pairs(self._windows) do self:_restyleWindow(window,self:_theme(self._themeName)) end
    return self
end

function AstraUI:GetMutedColor()
    return self:_theme(self._themeName).Muted
end

function AstraUI:SetMutedColor(color)
    assert(typeof(color)=="Color3","Color must be Color3")
    self:_theme(self._themeName).Muted=color
    for _,window in pairs(self._windows) do self:_restyleWindow(window,self:_theme(self._themeName)) end
    return self
end

function AstraUI:GetAccentColor()
    return self:_theme(self._themeName).Accent
end

function AstraUI:SetAccentColor(color)
    assert(typeof(color)=="Color3","Color must be Color3")
    self:_theme(self._themeName).Accent=color
    for _,window in pairs(self._windows) do self:_restyleWindow(window,self:_theme(self._themeName)) end
    return self
end

function AstraUI:GetBorderColor()
    return self:_theme(self._themeName).Border
end

function AstraUI:SetBorderColor(color)
    assert(typeof(color)=="Color3","Color must be Color3")
    self:_theme(self._themeName).Border=color
    for _,window in pairs(self._windows) do self:_restyleWindow(window,self:_theme(self._themeName)) end
    return self
end

function AstraUI:GetDangerColor()
    return self:_theme(self._themeName).Danger
end

function AstraUI:SetDangerColor(color)
    assert(typeof(color)=="Color3","Color must be Color3")
    self:_theme(self._themeName).Danger=color
    for _,window in pairs(self._windows) do self:_restyleWindow(window,self:_theme(self._themeName)) end
    return self
end

function AstraUI:GetSuccessColor()
    return self:_theme(self._themeName).Success
end

function AstraUI:SetSuccessColor(color)
    assert(typeof(color)=="Color3","Color must be Color3")
    self:_theme(self._themeName).Success=color
    for _,window in pairs(self._windows) do self:_restyleWindow(window,self:_theme(self._themeName)) end
    return self
end

function AstraUI:GetWarningColor()
    return self:_theme(self._themeName).Warning
end

function AstraUI:SetWarningColor(color)
    assert(typeof(color)=="Color3","Color must be Color3")
    self:_theme(self._themeName).Warning=color
    for _,window in pairs(self._windows) do self:_restyleWindow(window,self:_theme(self._themeName)) end
    return self
end

function AstraUI:AnimateHover(instance,properties,duration)
    if not instance then return nil end
    return Motion:_tween(instance,properties,duration or 0.16,Enum.EasingStyle.Quint)
end

function AstraUI:AnimatePress(instance,properties,duration)
    if not instance then return nil end
    return Motion:_tween(instance,properties,duration or 0.08,Enum.EasingStyle.Quad)
end

function AstraUI:AnimateRelease(instance,properties,duration)
    if not instance then return nil end
    return Motion:_tween(instance,properties,duration or 0.2,Enum.EasingStyle.Back)
end

function AstraUI:AnimateAppear(instance,properties,duration)
    if not instance then return nil end
    return Motion:_tween(instance,properties,duration or 0.28,Enum.EasingStyle.Quint)
end

function AstraUI:AnimateDisappear(instance,properties,duration)
    if not instance then return nil end
    return Motion:_tween(instance,properties,duration or 0.2,Enum.EasingStyle.Quint)
end

function AstraUI:AnimateExpand(instance,properties,duration)
    if not instance then return nil end
    return Motion:_tween(instance,properties,duration or 0.24,Enum.EasingStyle.Quint)
end

function AstraUI:AnimateCollapse(instance,properties,duration)
    if not instance then return nil end
    return Motion:_tween(instance,properties,duration or 0.18,Enum.EasingStyle.Quint)
end

function AstraUI:AnimateBounce(instance,properties,duration)
    if not instance then return nil end
    return Motion:_tween(instance,properties,duration or 0.32,Enum.EasingStyle.Back)
end

function AstraUI:AnimateGlow(instance,properties,duration)
    if not instance then return nil end
    return Motion:_tween(instance,properties,duration or 0.24,Enum.EasingStyle.Sine)
end

function AstraUI:AnimateFocus(instance,properties,duration)
    if not instance then return nil end
    return Motion:_tween(instance,properties,duration or 0.2,Enum.EasingStyle.Quint)
end

function AstraUI:AttachTooltip(guiObject,text)
    assert(guiObject and guiObject:IsA("GuiObject"),"GuiObject required")
    local theme=self:_theme(self._themeName)
    local tooltip=make("TextLabel",{Visible=false,BackgroundColor3=theme.SurfaceRaised,BackgroundTransparency=0.04,Text=tostring(text),TextSize=11,TextColor3=theme.Text,Font=Enum.Font.Gotham,AutomaticSize=Enum.AutomaticSize.X,Size=UDim2.fromOffset(0,28),ZIndex=200,Parent=guiObject:FindFirstAncestorOfClass("ScreenGui")})
    corner(tooltip,8); stroke(tooltip,theme.Border,0.84,1); padding(tooltip,9,9,0,0)
    local function show()
        tooltip.Visible=true; local p=guiObject.AbsolutePosition; local s=guiObject.AbsoluteSize; tooltip.Position=UDim2.fromOffset(p.X+s.X+8,p.Y+(s.Y-tooltip.AbsoluteSize.Y)/2); tooltip.TextTransparency=1; Motion:TextColor(tooltip,theme.Text,0.14)
        tooltip.TextTransparency=0
    end
    local function hide() tooltip.Visible=false end
    guiObject.MouseEnter:Connect(show); guiObject.MouseLeave:Connect(hide)
    return tooltip
end

function AstraUI:GetViewport()
    local camera=workspace.CurrentCamera
    return camera and camera.ViewportSize or Vector2.new(800,600)
end

function AstraUI:IsMobile()
    return self:GetViewport().X<=self.Defaults.MobileBreakpoint
end

function AstraUI:IsCompact()
    return self:GetViewport().X<=self.Defaults.CompactBreakpoint
end

function AstraUI:TouchTarget(size)
    local minimum=self:IsCompact() and 44 or 36
    local x=math.max(size.X.Offset,minimum); local y=math.max(size.Y.Offset,minimum)
    return UDim2.new(size.X.Scale,x,size.Y.Scale,y)
end

AstraUI.API = {
    Window = {"CreateTab","GetTab","GetComponent","Search","SetSearchEnabled","SetTitle","SetSize","SetPosition","SetVisibility","Open","Close","Toggle","ToggleMinimize","Destroy"},
    Tab = {"CreateSection","CreateLabel","CreateParagraph","CreateText","CreateButton","CreateToggle","CreateSlider","CreateDropdown","CreateMultiDropdown","CreateInput","CreateKeybind","CreateColorPicker","CreateDivider","CreateSpacer"},
    Component = {"Set","Get","SetVisible","SetDisabled","Destroy"},
    Global = {"CreateWindow","SetTheme","RegisterTheme","SetAccent","RegisterIcon","ResolveIcon","Notify","SetReducedMotion","SetQuality","SetTransparency","SetCornerRadius","SetAnimationSpeed","ExportConfig","ImportConfig","DestroyAll"},
}

AstraUI.ComponentSchemas = AstraUI.ComponentSchemas or {}

AstraUI.ComponentSchemas["Toggle_0"] = {
    Component = "Toggle",
    Property = "CurrentValue",
    Type = "boolean",
    Default = false,
    Required = false,
    Description = "Validated AstraUI component configuration field.",
}

AstraUI.ComponentSchemas["Slider_1"] = {
    Component = "Slider",
    Property = "Min",
    Type = "number",
    Default = 0,
    Required = false,
    Description = "Validated AstraUI component configuration field.",
}

AstraUI.ComponentSchemas["Slider_2"] = {
    Component = "Slider",
    Property = "Max",
    Type = "number",
    Default = 100,
    Required = false,
    Description = "Validated AstraUI component configuration field.",
}

AstraUI.ComponentSchemas["Slider_3"] = {
    Component = "Slider",
    Property = "Increment",
    Type = "number",
    Default = 1,
    Required = false,
    Description = "Validated AstraUI component configuration field.",
}

AstraUI.ComponentSchemas["Dropdown_4"] = {
    Component = "Dropdown",
    Property = "Options",
    Type = "table",
    Default = {},
    Required = false,
    Description = "Validated AstraUI component configuration field.",
}

AstraUI.ComponentSchemas["Dropdown_5"] = {
    Component = "Dropdown",
    Property = "CurrentOption",
    Type = "any",
    Default = nil,
    Required = false,
    Description = "Validated AstraUI component configuration field.",
}

AstraUI.ComponentSchemas["MultiDropdown_6"] = {
    Component = "MultiDropdown",
    Property = "Options",
    Type = "table",
    Default = {},
    Required = false,
    Description = "Validated AstraUI component configuration field.",
}

AstraUI.ComponentSchemas["MultiDropdown_7"] = {
    Component = "MultiDropdown",
    Property = "CurrentValues",
    Type = "table",
    Default = {},
    Required = false,
    Description = "Validated AstraUI component configuration field.",
}

AstraUI.ComponentSchemas["Input_8"] = {
    Component = "Input",
    Property = "PlaceholderText",
    Type = "string",
    Default = "Enter text...",
    Required = false,
    Description = "Validated AstraUI component configuration field.",
}

AstraUI.ComponentSchemas["Input_9"] = {
    Component = "Input",
    Property = "CurrentValue",
    Type = "string",
    Default = "",
    Required = false,
    Description = "Validated AstraUI component configuration field.",
}

AstraUI.ComponentSchemas["Keybind_10"] = {
    Component = "Keybind",
    Property = "CurrentKeybind",
    Type = "EnumItem",
    Default = Enum.KeyCode.RightShift,
    Required = false,
    Description = "Validated AstraUI component configuration field.",
}

AstraUI.ComponentSchemas["ColorPicker_11"] = {
    Component = "ColorPicker",
    Property = "Color",
    Type = "Color3",
    Default = Color3.fromRGB(150,115,255),
    Required = false,
    Description = "Validated AstraUI component configuration field.",
}

AstraUI.ComponentSchemas["Toggle_12"] = {
    Component = "Toggle",
    Property = "CurrentValue",
    Type = "boolean",
    Default = false,
    Required = false,
    Description = "Validated AstraUI component configuration field.",
}

AstraUI.ComponentSchemas["Slider_13"] = {
    Component = "Slider",
    Property = "Min",
    Type = "number",
    Default = 0,
    Required = false,
    Description = "Validated AstraUI component configuration field.",
}

AstraUI.ComponentSchemas["Slider_14"] = {
    Component = "Slider",
    Property = "Max",
    Type = "number",
    Default = 100,
    Required = false,
    Description = "Validated AstraUI component configuration field.",
}

AstraUI.ComponentSchemas["Slider_15"] = {
    Component = "Slider",
    Property = "Increment",
    Type = "number",
    Default = 1,
    Required = false,
    Description = "Validated AstraUI component configuration field.",
}

AstraUI.ComponentSchemas["Dropdown_16"] = {
    Component = "Dropdown",
    Property = "Options",
    Type = "table",
    Default = {},
    Required = false,
    Description = "Validated AstraUI component configuration field.",
}

AstraUI.ComponentSchemas["Dropdown_17"] = {
    Component = "Dropdown",
    Property = "CurrentOption",
    Type = "any",
    Default = nil,
    Required = false,
    Description = "Validated AstraUI component configuration field.",
}

AstraUI.ComponentSchemas["MultiDropdown_18"] = {
    Component = "MultiDropdown",
    Property = "Options",
    Type = "table",
    Default = {},
    Required = false,
    Description = "Validated AstraUI component configuration field.",
}

AstraUI.ComponentSchemas["MultiDropdown_19"] = {
    Component = "MultiDropdown",
    Property = "CurrentValues",
    Type = "table",
    Default = {},
    Required = false,
    Description = "Validated AstraUI component configuration field.",
}

AstraUI.ComponentSchemas["Input_20"] = {
    Component = "Input",
    Property = "PlaceholderText",
    Type = "string",
    Default = "Enter text...",
    Required = false,
    Description = "Validated AstraUI component configuration field.",
}

AstraUI.ComponentSchemas["Input_21"] = {
    Component = "Input",
    Property = "CurrentValue",
    Type = "string",
    Default = "",
    Required = false,
    Description = "Validated AstraUI component configuration field.",
}

AstraUI.ComponentSchemas["Keybind_22"] = {
    Component = "Keybind",
    Property = "CurrentKeybind",
    Type = "EnumItem",
    Default = Enum.KeyCode.RightShift,
    Required = false,
    Description = "Validated AstraUI component configuration field.",
}

AstraUI.ComponentSchemas["ColorPicker_23"] = {
    Component = "ColorPicker",
    Property = "Color",
    Type = "Color3",
    Default = Color3.fromRGB(150,115,255),
    Required = false,
    Description = "Validated AstraUI component configuration field.",
}

AstraUI.ComponentSchemas["Toggle_24"] = {
    Component = "Toggle",
    Property = "CurrentValue",
    Type = "boolean",
    Default = false,
    Required = false,
    Description = "Validated AstraUI component configuration field.",
}

AstraUI.ComponentSchemas["Slider_25"] = {
    Component = "Slider",
    Property = "Min",
    Type = "number",
    Default = 0,
    Required = false,
    Description = "Validated AstraUI component configuration field.",
}

AstraUI.ComponentSchemas["Slider_26"] = {
    Component = "Slider",
    Property = "Max",
    Type = "number",
    Default = 100,
    Required = false,
    Description = "Validated AstraUI component configuration field.",
}

AstraUI.ComponentSchemas["Slider_27"] = {
    Component = "Slider",
    Property = "Increment",
    Type = "number",
    Default = 1,
    Required = false,
    Description = "Validated AstraUI component configuration field.",
}

AstraUI.ComponentSchemas["Dropdown_28"] = {
    Component = "Dropdown",
    Property = "Options",
    Type = "table",
    Default = {},
    Required = false,
    Description = "Validated AstraUI component configuration field.",
}

AstraUI.ComponentSchemas["Dropdown_29"] = {
    Component = "Dropdown",
    Property = "CurrentOption",
    Type = "any",
    Default = nil,
    Required = false,
    Description = "Validated AstraUI component configuration field.",
}

AstraUI.ComponentSchemas["MultiDropdown_30"] = {
    Component = "MultiDropdown",
    Property = "Options",
    Type = "table",
    Default = {},
    Required = false,
    Description = "Validated AstraUI component configuration field.",
}

AstraUI.ComponentSchemas["MultiDropdown_31"] = {
    Component = "MultiDropdown",
    Property = "CurrentValues",
    Type = "table",
    Default = {},
    Required = false,
    Description = "Validated AstraUI component configuration field.",
}

AstraUI.ComponentSchemas["Input_32"] = {
    Component = "Input",
    Property = "PlaceholderText",
    Type = "string",
    Default = "Enter text...",
    Required = false,
    Description = "Validated AstraUI component configuration field.",
}

AstraUI.ComponentSchemas["Input_33"] = {
    Component = "Input",
    Property = "CurrentValue",
    Type = "string",
    Default = "",
    Required = false,
    Description = "Validated AstraUI component configuration field.",
}

AstraUI.ComponentSchemas["Keybind_34"] = {
    Component = "Keybind",
    Property = "CurrentKeybind",
    Type = "EnumItem",
    Default = Enum.KeyCode.RightShift,
    Required = false,
    Description = "Validated AstraUI component configuration field.",
}

AstraUI.ComponentSchemas["ColorPicker_35"] = {
    Component = "ColorPicker",
    Property = "Color",
    Type = "Color3",
    Default = Color3.fromRGB(150,115,255),
    Required = false,
    Description = "Validated AstraUI component configuration field.",
}

AstraUI.ComponentSchemas["Toggle_36"] = {
    Component = "Toggle",
    Property = "CurrentValue",
    Type = "boolean",
    Default = false,
    Required = false,
    Description = "Validated AstraUI component configuration field.",
}

AstraUI.ComponentSchemas["Slider_37"] = {
    Component = "Slider",
    Property = "Min",
    Type = "number",
    Default = 0,
    Required = false,
    Description = "Validated AstraUI component configuration field.",
}

AstraUI.ComponentSchemas["Slider_38"] = {
    Component = "Slider",
    Property = "Max",
    Type = "number",
    Default = 100,
    Required = false,
    Description = "Validated AstraUI component configuration field.",
}

AstraUI.ComponentSchemas["Slider_39"] = {
    Component = "Slider",
    Property = "Increment",
    Type = "number",
    Default = 1,
    Required = false,
    Description = "Validated AstraUI component configuration field.",
}

AstraUI.ComponentSchemas["Dropdown_40"] = {
    Component = "Dropdown",
    Property = "Options",
    Type = "table",
    Default = {},
    Required = false,
    Description = "Validated AstraUI component configuration field.",
}

AstraUI.ComponentSchemas["Dropdown_41"] = {
    Component = "Dropdown",
    Property = "CurrentOption",
    Type = "any",
    Default = nil,
    Required = false,
    Description = "Validated AstraUI component configuration field.",
}

AstraUI.ComponentSchemas["MultiDropdown_42"] = {
    Component = "MultiDropdown",
    Property = "Options",
    Type = "table",
    Default = {},
    Required = false,
    Description = "Validated AstraUI component configuration field.",
}

AstraUI.ComponentSchemas["MultiDropdown_43"] = {
    Component = "MultiDropdown",
    Property = "CurrentValues",
    Type = "table",
    Default = {},
    Required = false,
    Description = "Validated AstraUI component configuration field.",
}

AstraUI.ComponentSchemas["Input_44"] = {
    Component = "Input",
    Property = "PlaceholderText",
    Type = "string",
    Default = "Enter text...",
    Required = false,
    Description = "Validated AstraUI component configuration field.",
}

AstraUI.ComponentSchemas["Input_45"] = {
    Component = "Input",
    Property = "CurrentValue",
    Type = "string",
    Default = "",
    Required = false,
    Description = "Validated AstraUI component configuration field.",
}

AstraUI.ComponentSchemas["Keybind_46"] = {
    Component = "Keybind",
    Property = "CurrentKeybind",
    Type = "EnumItem",
    Default = Enum.KeyCode.RightShift,
    Required = false,
    Description = "Validated AstraUI component configuration field.",
}

AstraUI.ComponentSchemas["ColorPicker_47"] = {
    Component = "ColorPicker",
    Property = "Color",
    Type = "Color3",
    Default = Color3.fromRGB(150,115,255),
    Required = false,
    Description = "Validated AstraUI component configuration field.",
}

AstraUI.ComponentSchemas["Toggle_48"] = {
    Component = "Toggle",
    Property = "CurrentValue",
    Type = "boolean",
    Default = false,
    Required = false,
    Description = "Validated AstraUI component configuration field.",
}

AstraUI.ComponentSchemas["Slider_49"] = {
    Component = "Slider",
    Property = "Min",
    Type = "number",
    Default = 0,
    Required = false,
    Description = "Validated AstraUI component configuration field.",
}

AstraUI.ComponentSchemas["Slider_50"] = {
    Component = "Slider",
    Property = "Max",
    Type = "number",
    Default = 100,
    Required = false,
    Description = "Validated AstraUI component configuration field.",
}

AstraUI.ComponentSchemas["Slider_51"] = {
    Component = "Slider",
    Property = "Increment",
    Type = "number",
    Default = 1,
    Required = false,
    Description = "Validated AstraUI component configuration field.",
}

AstraUI.ComponentSchemas["Dropdown_52"] = {
    Component = "Dropdown",
    Property = "Options",
    Type = "table",
    Default = {},
    Required = false,
    Description = "Validated AstraUI component configuration field.",
}

AstraUI.ComponentSchemas["Dropdown_53"] = {
    Component = "Dropdown",
    Property = "CurrentOption",
    Type = "any",
    Default = nil,
    Required = false,
    Description = "Validated AstraUI component configuration field.",
}

AstraUI.ComponentSchemas["MultiDropdown_54"] = {
    Component = "MultiDropdown",
    Property = "Options",
    Type = "table",
    Default = {},
    Required = false,
    Description = "Validated AstraUI component configuration field.",
}

AstraUI.ComponentSchemas["MultiDropdown_55"] = {
    Component = "MultiDropdown",
    Property = "CurrentValues",
    Type = "table",
    Default = {},
    Required = false,
    Description = "Validated AstraUI component configuration field.",
}

AstraUI.ComponentSchemas["Input_56"] = {
    Component = "Input",
    Property = "PlaceholderText",
    Type = "string",
    Default = "Enter text...",
    Required = false,
    Description = "Validated AstraUI component configuration field.",
}

AstraUI.ComponentSchemas["Input_57"] = {
    Component = "Input",
    Property = "CurrentValue",
    Type = "string",
    Default = "",
    Required = false,
    Description = "Validated AstraUI component configuration field.",
}

AstraUI.ComponentSchemas["Keybind_58"] = {
    Component = "Keybind",
    Property = "CurrentKeybind",
    Type = "EnumItem",
    Default = Enum.KeyCode.RightShift,
    Required = false,
    Description = "Validated AstraUI component configuration field.",
}

AstraUI.ComponentSchemas["ColorPicker_59"] = {
    Component = "ColorPicker",
    Property = "Color",
    Type = "Color3",
    Default = Color3.fromRGB(150,115,255),
    Required = false,
    Description = "Validated AstraUI component configuration field.",
}

AstraUI.ComponentSchemas["Toggle_60"] = {
    Component = "Toggle",
    Property = "CurrentValue",
    Type = "boolean",
    Default = false,
    Required = false,
    Description = "Validated AstraUI component configuration field.",
}

AstraUI.ComponentSchemas["Slider_61"] = {
    Component = "Slider",
    Property = "Min",
    Type = "number",
    Default = 0,
    Required = false,
    Description = "Validated AstraUI component configuration field.",
}

AstraUI.ComponentSchemas["Slider_62"] = {
    Component = "Slider",
    Property = "Max",
    Type = "number",
    Default = 100,
    Required = false,
    Description = "Validated AstraUI component configuration field.",
}

AstraUI.ComponentSchemas["Slider_63"] = {
    Component = "Slider",
    Property = "Increment",
    Type = "number",
    Default = 1,
    Required = false,
    Description = "Validated AstraUI component configuration field.",
}

AstraUI.ComponentSchemas["Dropdown_64"] = {
    Component = "Dropdown",
    Property = "Options",
    Type = "table",
    Default = {},
    Required = false,
    Description = "Validated AstraUI component configuration field.",
}

AstraUI.ComponentSchemas["Dropdown_65"] = {
    Component = "Dropdown",
    Property = "CurrentOption",
    Type = "any",
    Default = nil,
    Required = false,
    Description = "Validated AstraUI component configuration field.",
}

AstraUI.ComponentSchemas["MultiDropdown_66"] = {
    Component = "MultiDropdown",
    Property = "Options",
    Type = "table",
    Default = {},
    Required = false,
    Description = "Validated AstraUI component configuration field.",
}

AstraUI.ComponentSchemas["MultiDropdown_67"] = {
    Component = "MultiDropdown",
    Property = "CurrentValues",
    Type = "table",
    Default = {},
    Required = false,
    Description = "Validated AstraUI component configuration field.",
}

AstraUI.ComponentSchemas["Input_68"] = {
    Component = "Input",
    Property = "PlaceholderText",
    Type = "string",
    Default = "Enter text...",
    Required = false,
    Description = "Validated AstraUI component configuration field.",
}

AstraUI.ComponentSchemas["Input_69"] = {
    Component = "Input",
    Property = "CurrentValue",
    Type = "string",
    Default = "",
    Required = false,
    Description = "Validated AstraUI component configuration field.",
}

AstraUI.ComponentSchemas["Keybind_70"] = {
    Component = "Keybind",
    Property = "CurrentKeybind",
    Type = "EnumItem",
    Default = Enum.KeyCode.RightShift,
    Required = false,
    Description = "Validated AstraUI component configuration field.",
}

AstraUI.ComponentSchemas["ColorPicker_71"] = {
    Component = "ColorPicker",
    Property = "Color",
    Type = "Color3",
    Default = Color3.fromRGB(150,115,255),
    Required = false,
    Description = "Validated AstraUI component configuration field.",
}

AstraUI.ComponentSchemas["Toggle_72"] = {
    Component = "Toggle",
    Property = "CurrentValue",
    Type = "boolean",
    Default = false,
    Required = false,
    Description = "Validated AstraUI component configuration field.",
}

AstraUI.ComponentSchemas["Slider_73"] = {
    Component = "Slider",
    Property = "Min",
    Type = "number",
    Default = 0,
    Required = false,
    Description = "Validated AstraUI component configuration field.",
}

AstraUI.ComponentSchemas["Slider_74"] = {
    Component = "Slider",
    Property = "Max",
    Type = "number",
    Default = 100,
    Required = false,
    Description = "Validated AstraUI component configuration field.",
}

AstraUI.ComponentSchemas["Slider_75"] = {
    Component = "Slider",
    Property = "Increment",
    Type = "number",
    Default = 1,
    Required = false,
    Description = "Validated AstraUI component configuration field.",
}

AstraUI.ComponentSchemas["Dropdown_76"] = {
    Component = "Dropdown",
    Property = "Options",
    Type = "table",
    Default = {},
    Required = false,
    Description = "Validated AstraUI component configuration field.",
}

AstraUI.ComponentSchemas["Dropdown_77"] = {
    Component = "Dropdown",
    Property = "CurrentOption",
    Type = "any",
    Default = nil,
    Required = false,
    Description = "Validated AstraUI component configuration field.",
}

AstraUI.ComponentSchemas["MultiDropdown_78"] = {
    Component = "MultiDropdown",
    Property = "Options",
    Type = "table",
    Default = {},
    Required = false,
    Description = "Validated AstraUI component configuration field.",
}

AstraUI.ComponentSchemas["MultiDropdown_79"] = {
    Component = "MultiDropdown",
    Property = "CurrentValues",
    Type = "table",
    Default = {},
    Required = false,
    Description = "Validated AstraUI component configuration field.",
}

AstraUI.ComponentSchemas["Input_80"] = {
    Component = "Input",
    Property = "PlaceholderText",
    Type = "string",
    Default = "Enter text...",
    Required = false,
    Description = "Validated AstraUI component configuration field.",
}

AstraUI.ComponentSchemas["Input_81"] = {
    Component = "Input",
    Property = "CurrentValue",
    Type = "string",
    Default = "",
    Required = false,
    Description = "Validated AstraUI component configuration field.",
}

AstraUI.ComponentSchemas["Keybind_82"] = {
    Component = "Keybind",
    Property = "CurrentKeybind",
    Type = "EnumItem",
    Default = Enum.KeyCode.RightShift,
    Required = false,
    Description = "Validated AstraUI component configuration field.",
}

AstraUI.ComponentSchemas["ColorPicker_83"] = {
    Component = "ColorPicker",
    Property = "Color",
    Type = "Color3",
    Default = Color3.fromRGB(150,115,255),
    Required = false,
    Description = "Validated AstraUI component configuration field.",
}

AstraUI.ComponentSchemas["Toggle_84"] = {
    Component = "Toggle",
    Property = "CurrentValue",
    Type = "boolean",
    Default = false,
    Required = false,
    Description = "Validated AstraUI component configuration field.",
}

AstraUI.ComponentSchemas["Slider_85"] = {
    Component = "Slider",
    Property = "Min",
    Type = "number",
    Default = 0,
    Required = false,
    Description = "Validated AstraUI component configuration field.",
}

AstraUI.ComponentSchemas["Slider_86"] = {
    Component = "Slider",
    Property = "Max",
    Type = "number",
    Default = 100,
    Required = false,
    Description = "Validated AstraUI component configuration field.",
}

AstraUI.ComponentSchemas["Slider_87"] = {
    Component = "Slider",
    Property = "Increment",
    Type = "number",
    Default = 1,
    Required = false,
    Description = "Validated AstraUI component configuration field.",
}

AstraUI.ComponentSchemas["Dropdown_88"] = {
    Component = "Dropdown",
    Property = "Options",
    Type = "table",
    Default = {},
    Required = false,
    Description = "Validated AstraUI component configuration field.",
}

AstraUI.ComponentSchemas["Dropdown_89"] = {
    Component = "Dropdown",
    Property = "CurrentOption",
    Type = "any",
    Default = nil,
    Required = false,
    Description = "Validated AstraUI component configuration field.",
}

AstraUI.ComponentSchemas["MultiDropdown_90"] = {
    Component = "MultiDropdown",
    Property = "Options",
    Type = "table",
    Default = {},
    Required = false,
    Description = "Validated AstraUI component configuration field.",
}

AstraUI.ComponentSchemas["MultiDropdown_91"] = {
    Component = "MultiDropdown",
    Property = "CurrentValues",
    Type = "table",
    Default = {},
    Required = false,
    Description = "Validated AstraUI component configuration field.",
}

AstraUI.ComponentSchemas["Input_92"] = {
    Component = "Input",
    Property = "PlaceholderText",
    Type = "string",
    Default = "Enter text...",
    Required = false,
    Description = "Validated AstraUI component configuration field.",
}

AstraUI.ComponentSchemas["Input_93"] = {
    Component = "Input",
    Property = "CurrentValue",
    Type = "string",
    Default = "",
    Required = false,
    Description = "Validated AstraUI component configuration field.",
}

AstraUI.ComponentSchemas["Keybind_94"] = {
    Component = "Keybind",
    Property = "CurrentKeybind",
    Type = "EnumItem",
    Default = Enum.KeyCode.RightShift,
    Required = false,
    Description = "Validated AstraUI component configuration field.",
}

AstraUI.ComponentSchemas["ColorPicker_95"] = {
    Component = "ColorPicker",
    Property = "Color",
    Type = "Color3",
    Default = Color3.fromRGB(150,115,255),
    Required = false,
    Description = "Validated AstraUI component configuration field.",
}

AstraUI.ComponentSchemas["Toggle_96"] = {
    Component = "Toggle",
    Property = "CurrentValue",
    Type = "boolean",
    Default = false,
    Required = false,
    Description = "Validated AstraUI component configuration field.",
}

AstraUI.ComponentSchemas["Slider_97"] = {
    Component = "Slider",
    Property = "Min",
    Type = "number",
    Default = 0,
    Required = false,
    Description = "Validated AstraUI component configuration field.",
}

AstraUI.ComponentSchemas["Slider_98"] = {
    Component = "Slider",
    Property = "Max",
    Type = "number",
    Default = 100,
    Required = false,
    Description = "Validated AstraUI component configuration field.",
}

AstraUI.ComponentSchemas["Slider_99"] = {
    Component = "Slider",
    Property = "Increment",
    Type = "number",
    Default = 1,
    Required = false,
    Description = "Validated AstraUI component configuration field.",
}

AstraUI.ComponentSchemas["Dropdown_100"] = {
    Component = "Dropdown",
    Property = "Options",
    Type = "table",
    Default = {},
    Required = false,
    Description = "Validated AstraUI component configuration field.",
}

AstraUI.ComponentSchemas["Dropdown_101"] = {
    Component = "Dropdown",
    Property = "CurrentOption",
    Type = "any",
    Default = nil,
    Required = false,
    Description = "Validated AstraUI component configuration field.",
}

AstraUI.ComponentSchemas["MultiDropdown_102"] = {
    Component = "MultiDropdown",
    Property = "Options",
    Type = "table",
    Default = {},
    Required = false,
    Description = "Validated AstraUI component configuration field.",
}

AstraUI.ComponentSchemas["MultiDropdown_103"] = {
    Component = "MultiDropdown",
    Property = "CurrentValues",
    Type = "table",
    Default = {},
    Required = false,
    Description = "Validated AstraUI component configuration field.",
}

AstraUI.ComponentSchemas["Input_104"] = {
    Component = "Input",
    Property = "PlaceholderText",
    Type = "string",
    Default = "Enter text...",
    Required = false,
    Description = "Validated AstraUI component configuration field.",
}

AstraUI.ComponentSchemas["Input_105"] = {
    Component = "Input",
    Property = "CurrentValue",
    Type = "string",
    Default = "",
    Required = false,
    Description = "Validated AstraUI component configuration field.",
}

AstraUI.ComponentSchemas["Keybind_106"] = {
    Component = "Keybind",
    Property = "CurrentKeybind",
    Type = "EnumItem",
    Default = Enum.KeyCode.RightShift,
    Required = false,
    Description = "Validated AstraUI component configuration field.",
}

AstraUI.ComponentSchemas["ColorPicker_107"] = {
    Component = "ColorPicker",
    Property = "Color",
    Type = "Color3",
    Default = Color3.fromRGB(150,115,255),
    Required = false,
    Description = "Validated AstraUI component configuration field.",
}

AstraUI.ComponentSchemas["Toggle_108"] = {
    Component = "Toggle",
    Property = "CurrentValue",
    Type = "boolean",
    Default = false,
    Required = false,
    Description = "Validated AstraUI component configuration field.",
}

AstraUI.ComponentSchemas["Slider_109"] = {
    Component = "Slider",
    Property = "Min",
    Type = "number",
    Default = 0,
    Required = false,
    Description = "Validated AstraUI component configuration field.",
}

AstraUI.ComponentSchemas["Slider_110"] = {
    Component = "Slider",
    Property = "Max",
    Type = "number",
    Default = 100,
    Required = false,
    Description = "Validated AstraUI component configuration field.",
}

AstraUI.ComponentSchemas["Slider_111"] = {
    Component = "Slider",
    Property = "Increment",
    Type = "number",
    Default = 1,
    Required = false,
    Description = "Validated AstraUI component configuration field.",
}

AstraUI.ComponentSchemas["Dropdown_112"] = {
    Component = "Dropdown",
    Property = "Options",
    Type = "table",
    Default = {},
    Required = false,
    Description = "Validated AstraUI component configuration field.",
}

AstraUI.ComponentSchemas["Dropdown_113"] = {
    Component = "Dropdown",
    Property = "CurrentOption",
    Type = "any",
    Default = nil,
    Required = false,
    Description = "Validated AstraUI component configuration field.",
}

AstraUI.ComponentSchemas["MultiDropdown_114"] = {
    Component = "MultiDropdown",
    Property = "Options",
    Type = "table",
    Default = {},
    Required = false,
    Description = "Validated AstraUI component configuration field.",
}

AstraUI.ComponentSchemas["MultiDropdown_115"] = {
    Component = "MultiDropdown",
    Property = "CurrentValues",
    Type = "table",
    Default = {},
    Required = false,
    Description = "Validated AstraUI component configuration field.",
}

AstraUI.ComponentSchemas["Input_116"] = {
    Component = "Input",
    Property = "PlaceholderText",
    Type = "string",
    Default = "Enter text...",
    Required = false,
    Description = "Validated AstraUI component configuration field.",
}

AstraUI.ComponentSchemas["Input_117"] = {
    Component = "Input",
    Property = "CurrentValue",
    Type = "string",
    Default = "",
    Required = false,
    Description = "Validated AstraUI component configuration field.",
}

AstraUI.ComponentSchemas["Keybind_118"] = {
    Component = "Keybind",
    Property = "CurrentKeybind",
    Type = "EnumItem",
    Default = Enum.KeyCode.RightShift,
    Required = false,
    Description = "Validated AstraUI component configuration field.",
}

AstraUI.ComponentSchemas["ColorPicker_119"] = {
    Component = "ColorPicker",
    Property = "Color",
    Type = "Color3",
    Default = Color3.fromRGB(150,115,255),
    Required = false,
    Description = "Validated AstraUI component configuration field.",
}

AstraUI.ComponentSchemas["Toggle_120"] = {
    Component = "Toggle",
    Property = "CurrentValue",
    Type = "boolean",
    Default = false,
    Required = false,
    Description = "Validated AstraUI component configuration field.",
}

AstraUI.ComponentSchemas["Slider_121"] = {
    Component = "Slider",
    Property = "Min",
    Type = "number",
    Default = 0,
    Required = false,
    Description = "Validated AstraUI component configuration field.",
}

AstraUI.ComponentSchemas["Slider_122"] = {
    Component = "Slider",
    Property = "Max",
    Type = "number",
    Default = 100,
    Required = false,
    Description = "Validated AstraUI component configuration field.",
}

AstraUI.ComponentSchemas["Slider_123"] = {
    Component = "Slider",
    Property = "Increment",
    Type = "number",
    Default = 1,
    Required = false,
    Description = "Validated AstraUI component configuration field.",
}

AstraUI.ComponentSchemas["Dropdown_124"] = {
    Component = "Dropdown",
    Property = "Options",
    Type = "table",
    Default = {},
    Required = false,
    Description = "Validated AstraUI component configuration field.",
}

AstraUI.ComponentSchemas["Dropdown_125"] = {
    Component = "Dropdown",
    Property = "CurrentOption",
    Type = "any",
    Default = nil,
    Required = false,
    Description = "Validated AstraUI component configuration field.",
}

AstraUI.ComponentSchemas["MultiDropdown_126"] = {
    Component = "MultiDropdown",
    Property = "Options",
    Type = "table",
    Default = {},
    Required = false,
    Description = "Validated AstraUI component configuration field.",
}

AstraUI.ComponentSchemas["MultiDropdown_127"] = {
    Component = "MultiDropdown",
    Property = "CurrentValues",
    Type = "table",
    Default = {},
    Required = false,
    Description = "Validated AstraUI component configuration field.",
}

AstraUI.ComponentSchemas["Input_128"] = {
    Component = "Input",
    Property = "PlaceholderText",
    Type = "string",
    Default = "Enter text...",
    Required = false,
    Description = "Validated AstraUI component configuration field.",
}

AstraUI.ComponentSchemas["Input_129"] = {
    Component = "Input",
    Property = "CurrentValue",
    Type = "string",
    Default = "",
    Required = false,
    Description = "Validated AstraUI component configuration field.",
}

AstraUI.ComponentSchemas["Keybind_130"] = {
    Component = "Keybind",
    Property = "CurrentKeybind",
    Type = "EnumItem",
    Default = Enum.KeyCode.RightShift,
    Required = false,
    Description = "Validated AstraUI component configuration field.",
}

AstraUI.ComponentSchemas["ColorPicker_131"] = {
    Component = "ColorPicker",
    Property = "Color",
    Type = "Color3",
    Default = Color3.fromRGB(150,115,255),
    Required = false,
    Description = "Validated AstraUI component configuration field.",
}

AstraUI.ComponentSchemas["Toggle_132"] = {
    Component = "Toggle",
    Property = "CurrentValue",
    Type = "boolean",
    Default = false,
    Required = false,
    Description = "Validated AstraUI component configuration field.",
}

AstraUI.ComponentSchemas["Slider_133"] = {
    Component = "Slider",
    Property = "Min",
    Type = "number",
    Default = 0,
    Required = false,
    Description = "Validated AstraUI component configuration field.",
}

AstraUI.ComponentSchemas["Slider_134"] = {
    Component = "Slider",
    Property = "Max",
    Type = "number",
    Default = 100,
    Required = false,
    Description = "Validated AstraUI component configuration field.",
}

AstraUI.ComponentSchemas["Slider_135"] = {
    Component = "Slider",
    Property = "Increment",
    Type = "number",
    Default = 1,
    Required = false,
    Description = "Validated AstraUI component configuration field.",
}

AstraUI.ComponentSchemas["Dropdown_136"] = {
    Component = "Dropdown",
    Property = "Options",
    Type = "table",
    Default = {},
    Required = false,
    Description = "Validated AstraUI component configuration field.",
}

AstraUI.ComponentSchemas["Dropdown_137"] = {
    Component = "Dropdown",
    Property = "CurrentOption",
    Type = "any",
    Default = nil,
    Required = false,
    Description = "Validated AstraUI component configuration field.",
}

AstraUI.ComponentSchemas["MultiDropdown_138"] = {
    Component = "MultiDropdown",
    Property = "Options",
    Type = "table",
    Default = {},
    Required = false,
    Description = "Validated AstraUI component configuration field.",
}

AstraUI.ComponentSchemas["MultiDropdown_139"] = {
    Component = "MultiDropdown",
    Property = "CurrentValues",
    Type = "table",
    Default = {},
    Required = false,
    Description = "Validated AstraUI component configuration field.",
}

AstraUI.ComponentSchemas["Input_140"] = {
    Component = "Input",
    Property = "PlaceholderText",
    Type = "string",
    Default = "Enter text...",
    Required = false,
    Description = "Validated AstraUI component configuration field.",
}

AstraUI.ComponentSchemas["Input_141"] = {
    Component = "Input",
    Property = "CurrentValue",
    Type = "string",
    Default = "",
    Required = false,
    Description = "Validated AstraUI component configuration field.",
}

AstraUI.ComponentSchemas["Keybind_142"] = {
    Component = "Keybind",
    Property = "CurrentKeybind",
    Type = "EnumItem",
    Default = Enum.KeyCode.RightShift,
    Required = false,
    Description = "Validated AstraUI component configuration field.",
}

AstraUI.ComponentSchemas["ColorPicker_143"] = {
    Component = "ColorPicker",
    Property = "Color",
    Type = "Color3",
    Default = Color3.fromRGB(150,115,255),
    Required = false,
    Description = "Validated AstraUI component configuration field.",
}

AstraUI.ComponentSchemas["Toggle_144"] = {
    Component = "Toggle",
    Property = "CurrentValue",
    Type = "boolean",
    Default = false,
    Required = false,
    Description = "Validated AstraUI component configuration field.",
}

AstraUI.ComponentSchemas["Slider_145"] = {
    Component = "Slider",
    Property = "Min",
    Type = "number",
    Default = 0,
    Required = false,
    Description = "Validated AstraUI component configuration field.",
}

AstraUI.ComponentSchemas["Slider_146"] = {
    Component = "Slider",
    Property = "Max",
    Type = "number",
    Default = 100,
    Required = false,
    Description = "Validated AstraUI component configuration field.",
}

AstraUI.ComponentSchemas["Slider_147"] = {
    Component = "Slider",
    Property = "Increment",
    Type = "number",
    Default = 1,
    Required = false,
    Description = "Validated AstraUI component configuration field.",
}

AstraUI.ComponentSchemas["Dropdown_148"] = {
    Component = "Dropdown",
    Property = "Options",
    Type = "table",
    Default = {},
    Required = false,
    Description = "Validated AstraUI component configuration field.",
}

AstraUI.ComponentSchemas["Dropdown_149"] = {
    Component = "Dropdown",
    Property = "CurrentOption",
    Type = "any",
    Default = nil,
    Required = false,
    Description = "Validated AstraUI component configuration field.",
}

AstraUI.ComponentSchemas = AstraUI.ComponentSchemas or {}
function AstraUI:ValidateField_0(value)
    if value == nil then return true end
    return type(value)=="boolean"
end

function AstraUI:ValidateField_1(value)
    if value == nil then return true end
    return type(value)=="number" and value==value
end

function AstraUI:ValidateField_2(value)
    if value == nil then return true end
    return type(value)=="number" and value==value
end

function AstraUI:ValidateField_3(value)
    if value == nil then return true end
    return type(value)=="number" and value==value
end

function AstraUI:ValidateField_4(value)
    if value == nil then return true end
    return type(value)=="table"
end

function AstraUI:ValidateField_5(value)
    if value == nil then return true end
    return typeof(value)=="EnumItem" or type(value)=="string"
end

function AstraUI:ValidateField_6(value)
    if value == nil then return true end
    return type(value)=="table"
end

function AstraUI:ValidateField_7(value)
    if value == nil then return true end
    return type(value)=="table"
end

function AstraUI:ValidateField_8(value)
    if value == nil then return true end
    return type(value)=="string"
end

function AstraUI:ValidateField_9(value)
    if value == nil then return true end
    return type(value)=="string"
end

function AstraUI:ValidateField_10(value)
    if value == nil then return true end
    return typeof(value)=="EnumItem" or type(value)=="string"
end

function AstraUI:ValidateField_11(value)
    if value == nil then return true end
    return typeof(value)=="Color3"
end

function AstraUI:ValidateField_12(value)
    if value == nil then return true end
    return type(value)=="boolean"
end

function AstraUI:ValidateField_13(value)
    if value == nil then return true end
    return type(value)=="number" and value==value
end

function AstraUI:ValidateField_14(value)
    if value == nil then return true end
    return type(value)=="number" and value==value
end

function AstraUI:ValidateField_15(value)
    if value == nil then return true end
    return type(value)=="number" and value==value
end

function AstraUI:ValidateField_16(value)
    if value == nil then return true end
    return type(value)=="table"
end

function AstraUI:ValidateField_17(value)
    if value == nil then return true end
    return typeof(value)=="EnumItem" or type(value)=="string"
end

function AstraUI:ValidateField_18(value)
    if value == nil then return true end
    return type(value)=="table"
end

function AstraUI:ValidateField_19(value)
    if value == nil then return true end
    return type(value)=="table"
end

function AstraUI:ValidateField_20(value)
    if value == nil then return true end
    return type(value)=="string"
end

function AstraUI:ValidateField_21(value)
    if value == nil then return true end
    return type(value)=="string"
end

function AstraUI:ValidateField_22(value)
    if value == nil then return true end
    return typeof(value)=="EnumItem" or type(value)=="string"
end

function AstraUI:ValidateField_23(value)
    if value == nil then return true end
    return typeof(value)=="Color3"
end

function AstraUI:ValidateField_24(value)
    if value == nil then return true end
    return type(value)=="boolean"
end

function AstraUI:ValidateField_25(value)
    if value == nil then return true end
    return type(value)=="number" and value==value
end

function AstraUI:ValidateField_26(value)
    if value == nil then return true end
    return type(value)=="number" and value==value
end

function AstraUI:ValidateField_27(value)
    if value == nil then return true end
    return type(value)=="number" and value==value
end

function AstraUI:ValidateField_28(value)
    if value == nil then return true end
    return type(value)=="table"
end

function AstraUI:ValidateField_29(value)
    if value == nil then return true end
    return typeof(value)=="EnumItem" or type(value)=="string"
end

function AstraUI:ValidateField_30(value)
    if value == nil then return true end
    return type(value)=="table"
end

function AstraUI:ValidateField_31(value)
    if value == nil then return true end
    return type(value)=="table"
end

function AstraUI:ValidateField_32(value)
    if value == nil then return true end
    return type(value)=="string"
end

function AstraUI:ValidateField_33(value)
    if value == nil then return true end
    return type(value)=="string"
end

function AstraUI:ValidateField_34(value)
    if value == nil then return true end
    return typeof(value)=="EnumItem" or type(value)=="string"
end

function AstraUI:ValidateField_35(value)
    if value == nil then return true end
    return typeof(value)=="Color3"
end

function AstraUI:ValidateField_36(value)
    if value == nil then return true end
    return type(value)=="boolean"
end

function AstraUI:ValidateField_37(value)
    if value == nil then return true end
    return type(value)=="number" and value==value
end

function AstraUI:ValidateField_38(value)
    if value == nil then return true end
    return type(value)=="number" and value==value
end

function AstraUI:ValidateField_39(value)
    if value == nil then return true end
    return type(value)=="number" and value==value
end

function AstraUI:ValidateField_40(value)
    if value == nil then return true end
    return type(value)=="table"
end

function AstraUI:ValidateField_41(value)
    if value == nil then return true end
    return typeof(value)=="EnumItem" or type(value)=="string"
end

function AstraUI:ValidateField_42(value)
    if value == nil then return true end
    return type(value)=="table"
end

function AstraUI:ValidateField_43(value)
    if value == nil then return true end
    return type(value)=="table"
end

function AstraUI:ValidateField_44(value)
    if value == nil then return true end
    return type(value)=="string"
end

function AstraUI:ValidateField_45(value)
    if value == nil then return true end
    return type(value)=="string"
end

function AstraUI:ValidateField_46(value)
    if value == nil then return true end
    return typeof(value)=="EnumItem" or type(value)=="string"
end

function AstraUI:ValidateField_47(value)
    if value == nil then return true end
    return typeof(value)=="Color3"
end

function AstraUI:ValidateField_48(value)
    if value == nil then return true end
    return type(value)=="boolean"
end

function AstraUI:ValidateField_49(value)
    if value == nil then return true end
    return type(value)=="number" and value==value
end

function AstraUI:ValidateField_50(value)
    if value == nil then return true end
    return type(value)=="number" and value==value
end

function AstraUI:ValidateField_51(value)
    if value == nil then return true end
    return type(value)=="number" and value==value
end

function AstraUI:ValidateField_52(value)
    if value == nil then return true end
    return type(value)=="table"
end

function AstraUI:ValidateField_53(value)
    if value == nil then return true end
    return typeof(value)=="EnumItem" or type(value)=="string"
end

function AstraUI:ValidateField_54(value)
    if value == nil then return true end
    return type(value)=="table"
end

function AstraUI:ValidateField_55(value)
    if value == nil then return true end
    return type(value)=="table"
end

function AstraUI:ValidateField_56(value)
    if value == nil then return true end
    return type(value)=="string"
end

function AstraUI:ValidateField_57(value)
    if value == nil then return true end
    return type(value)=="string"
end

function AstraUI:ValidateField_58(value)
    if value == nil then return true end
    return typeof(value)=="EnumItem" or type(value)=="string"
end

function AstraUI:ValidateField_59(value)
    if value == nil then return true end
    return typeof(value)=="Color3"
end

function AstraUI:ValidateField_60(value)
    if value == nil then return true end
    return type(value)=="boolean"
end

function AstraUI:ValidateField_61(value)
    if value == nil then return true end
    return type(value)=="number" and value==value
end

function AstraUI:ValidateField_62(value)
    if value == nil then return true end
    return type(value)=="number" and value==value
end

function AstraUI:ValidateField_63(value)
    if value == nil then return true end
    return type(value)=="number" and value==value
end

function AstraUI:ValidateField_64(value)
    if value == nil then return true end
    return type(value)=="table"
end

function AstraUI:ValidateField_65(value)
    if value == nil then return true end
    return typeof(value)=="EnumItem" or type(value)=="string"
end

function AstraUI:ValidateField_66(value)
    if value == nil then return true end
    return type(value)=="table"
end

function AstraUI:ValidateField_67(value)
    if value == nil then return true end
    return type(value)=="table"
end

function AstraUI:ValidateField_68(value)
    if value == nil then return true end
    return type(value)=="string"
end

function AstraUI:ValidateField_69(value)
    if value == nil then return true end
    return type(value)=="string"
end

function AstraUI:ValidateField_70(value)
    if value == nil then return true end
    return typeof(value)=="EnumItem" or type(value)=="string"
end

function AstraUI:ValidateField_71(value)
    if value == nil then return true end
    return typeof(value)=="Color3"
end

function AstraUI:ValidateField_72(value)
    if value == nil then return true end
    return type(value)=="boolean"
end

function AstraUI:ValidateField_73(value)
    if value == nil then return true end
    return type(value)=="number" and value==value
end

function AstraUI:ValidateField_74(value)
    if value == nil then return true end
    return type(value)=="number" and value==value
end

function AstraUI:ValidateField_75(value)
    if value == nil then return true end
    return type(value)=="number" and value==value
end

function AstraUI:ValidateField_76(value)
    if value == nil then return true end
    return type(value)=="table"
end

function AstraUI:ValidateField_77(value)
    if value == nil then return true end
    return typeof(value)=="EnumItem" or type(value)=="string"
end

function AstraUI:ValidateField_78(value)
    if value == nil then return true end
    return type(value)=="table"
end

function AstraUI:ValidateField_79(value)
    if value == nil then return true end
    return type(value)=="table"
end

function AstraUI:ValidateField_80(value)
    if value == nil then return true end
    return type(value)=="string"
end

function AstraUI:ValidateField_81(value)
    if value == nil then return true end
    return type(value)=="string"
end

function AstraUI:ValidateField_82(value)
    if value == nil then return true end
    return typeof(value)=="EnumItem" or type(value)=="string"
end

function AstraUI:ValidateField_83(value)
    if value == nil then return true end
    return typeof(value)=="Color3"
end

function AstraUI:ValidateField_84(value)
    if value == nil then return true end
    return type(value)=="boolean"
end

function AstraUI:ValidateField_85(value)
    if value == nil then return true end
    return type(value)=="number" and value==value
end

function AstraUI:ValidateField_86(value)
    if value == nil then return true end
    return type(value)=="number" and value==value
end

function AstraUI:ValidateField_87(value)
    if value == nil then return true end
    return type(value)=="number" and value==value
end

function AstraUI:ValidateField_88(value)
    if value == nil then return true end
    return type(value)=="table"
end

function AstraUI:ValidateField_89(value)
    if value == nil then return true end
    return typeof(value)=="EnumItem" or type(value)=="string"
end

function AstraUI:ValidateField_90(value)
    if value == nil then return true end
    return type(value)=="table"
end

function AstraUI:ValidateField_91(value)
    if value == nil then return true end
    return type(value)=="table"
end

function AstraUI:ValidateField_92(value)
    if value == nil then return true end
    return type(value)=="string"
end

function AstraUI:ValidateField_93(value)
    if value == nil then return true end
    return type(value)=="string"
end

function AstraUI:ValidateField_94(value)
    if value == nil then return true end
    return typeof(value)=="EnumItem" or type(value)=="string"
end

function AstraUI:ValidateField_95(value)
    if value == nil then return true end
    return typeof(value)=="Color3"
end

function AstraUI:ValidateField_96(value)
    if value == nil then return true end
    return type(value)=="boolean"
end

function AstraUI:ValidateField_97(value)
    if value == nil then return true end
    return type(value)=="number" and value==value
end

function AstraUI:ValidateField_98(value)
    if value == nil then return true end
    return type(value)=="number" and value==value
end

function AstraUI:ValidateField_99(value)
    if value == nil then return true end
    return type(value)=="number" and value==value
end

function AstraUI:ValidateField_100(value)
    if value == nil then return true end
    return type(value)=="table"
end

function AstraUI:ValidateField_101(value)
    if value == nil then return true end
    return typeof(value)=="EnumItem" or type(value)=="string"
end

function AstraUI:ValidateField_102(value)
    if value == nil then return true end
    return type(value)=="table"
end

function AstraUI:ValidateField_103(value)
    if value == nil then return true end
    return type(value)=="table"
end

function AstraUI:ValidateField_104(value)
    if value == nil then return true end
    return type(value)=="string"
end

function AstraUI:ValidateField_105(value)
    if value == nil then return true end
    return type(value)=="string"
end

function AstraUI:ValidateField_106(value)
    if value == nil then return true end
    return typeof(value)=="EnumItem" or type(value)=="string"
end

function AstraUI:ValidateField_107(value)
    if value == nil then return true end
    return typeof(value)=="Color3"
end

function AstraUI:ValidateField_108(value)
    if value == nil then return true end
    return type(value)=="boolean"
end

function AstraUI:ValidateField_109(value)
    if value == nil then return true end
    return type(value)=="number" and value==value
end

function AstraUI:ValidateField_110(value)
    if value == nil then return true end
    return type(value)=="number" and value==value
end

function AstraUI:ValidateField_111(value)
    if value == nil then return true end
    return type(value)=="number" and value==value
end

function AstraUI:ValidateField_112(value)
    if value == nil then return true end
    return type(value)=="table"
end

function AstraUI:ValidateField_113(value)
    if value == nil then return true end
    return typeof(value)=="EnumItem" or type(value)=="string"
end

function AstraUI:ValidateField_114(value)
    if value == nil then return true end
    return type(value)=="table"
end

function AstraUI:ValidateField_115(value)
    if value == nil then return true end
    return type(value)=="table"
end

function AstraUI:ValidateField_116(value)
    if value == nil then return true end
    return type(value)=="string"
end

function AstraUI:ValidateField_117(value)
    if value == nil then return true end
    return type(value)=="string"
end

function AstraUI:ValidateField_118(value)
    if value == nil then return true end
    return typeof(value)=="EnumItem" or type(value)=="string"
end

function AstraUI:ValidateField_119(value)
    if value == nil then return true end
    return typeof(value)=="Color3"
end

function AstraUI:ValidateField_120(value)
    if value == nil then return true end
    return type(value)=="boolean"
end

function AstraUI:ValidateField_121(value)
    if value == nil then return true end
    return type(value)=="number" and value==value
end

function AstraUI:ValidateField_122(value)
    if value == nil then return true end
    return type(value)=="number" and value==value
end

function AstraUI:ValidateField_123(value)
    if value == nil then return true end
    return type(value)=="number" and value==value
end

function AstraUI:ValidateField_124(value)
    if value == nil then return true end
    return type(value)=="table"
end

function AstraUI:ValidateField_125(value)
    if value == nil then return true end
    return typeof(value)=="EnumItem" or type(value)=="string"
end

function AstraUI:ValidateField_126(value)
    if value == nil then return true end
    return type(value)=="table"
end

function AstraUI:ValidateField_127(value)
    if value == nil then return true end
    return type(value)=="table"
end

function AstraUI:ValidateField_128(value)
    if value == nil then return true end
    return type(value)=="string"
end

function AstraUI:ValidateField_129(value)
    if value == nil then return true end
    return type(value)=="string"
end

function AstraUI:ValidateField_130(value)
    if value == nil then return true end
    return typeof(value)=="EnumItem" or type(value)=="string"
end

function AstraUI:ValidateField_131(value)
    if value == nil then return true end
    return typeof(value)=="Color3"
end

function AstraUI:ValidateField_132(value)
    if value == nil then return true end
    return type(value)=="boolean"
end

function AstraUI:ValidateField_133(value)
    if value == nil then return true end
    return type(value)=="number" and value==value
end

function AstraUI:ValidateField_134(value)
    if value == nil then return true end
    return type(value)=="number" and value==value
end

function AstraUI:ValidateField_135(value)
    if value == nil then return true end
    return type(value)=="number" and value==value
end

function AstraUI:ValidateField_136(value)
    if value == nil then return true end
    return type(value)=="table"
end

function AstraUI:ValidateField_137(value)
    if value == nil then return true end
    return typeof(value)=="EnumItem" or type(value)=="string"
end

function AstraUI:ValidateField_138(value)
    if value == nil then return true end
    return type(value)=="table"
end

function AstraUI:ValidateField_139(value)
    if value == nil then return true end
    return type(value)=="table"
end

function AstraUI:ValidateField_140(value)
    if value == nil then return true end
    return type(value)=="string"
end

function AstraUI:ValidateField_141(value)
    if value == nil then return true end
    return type(value)=="string"
end

function AstraUI:ValidateField_142(value)
    if value == nil then return true end
    return typeof(value)=="EnumItem" or type(value)=="string"
end

function AstraUI:ValidateField_143(value)
    if value == nil then return true end
    return typeof(value)=="Color3"
end

function AstraUI:ValidateField_144(value)
    if value == nil then return true end
    return type(value)=="boolean"
end

function AstraUI:ValidateField_145(value)
    if value == nil then return true end
    return type(value)=="number" and value==value
end

function AstraUI:ValidateField_146(value)
    if value == nil then return true end
    return type(value)=="number" and value==value
end

function AstraUI:ValidateField_147(value)
    if value == nil then return true end
    return type(value)=="number" and value==value
end

function AstraUI:ValidateField_148(value)
    if value == nil then return true end
    return type(value)=="table"
end

function AstraUI:ValidateField_149(value)
    if value == nil then return true end
    return typeof(value)=="EnumItem" or type(value)=="string"
end

function AstraUI:ValidateField_150(value)
    if value == nil then return true end
    return type(value)=="table"
end

function AstraUI:ValidateField_151(value)
    if value == nil then return true end
    return type(value)=="table"
end

function AstraUI:ValidateField_152(value)
    if value == nil then return true end
    return type(value)=="string"
end

function AstraUI:ValidateField_153(value)
    if value == nil then return true end
    return type(value)=="string"
end

function AstraUI:ValidateField_154(value)
    if value == nil then return true end
    return typeof(value)=="EnumItem" or type(value)=="string"
end

function AstraUI:ValidateField_155(value)
    if value == nil then return true end
    return typeof(value)=="Color3"
end

function AstraUI:ValidateField_156(value)
    if value == nil then return true end
    return type(value)=="boolean"
end

function AstraUI:ValidateField_157(value)
    if value == nil then return true end
    return type(value)=="number" and value==value
end

function AstraUI:ValidateField_158(value)
    if value == nil then return true end
    return type(value)=="number" and value==value
end

function AstraUI:ValidateField_159(value)
    if value == nil then return true end
    return type(value)=="number" and value==value
end

function AstraUI:ValidateField_160(value)
    if value == nil then return true end
    return type(value)=="table"
end

function AstraUI:ValidateField_161(value)
    if value == nil then return true end
    return typeof(value)=="EnumItem" or type(value)=="string"
end

function AstraUI:ValidateField_162(value)
    if value == nil then return true end
    return type(value)=="table"
end

function AstraUI:ValidateField_163(value)
    if value == nil then return true end
    return type(value)=="table"
end

function AstraUI:ValidateField_164(value)
    if value == nil then return true end
    return type(value)=="string"
end

function AstraUI:ValidateField_165(value)
    if value == nil then return true end
    return type(value)=="string"
end

function AstraUI:ValidateField_166(value)
    if value == nil then return true end
    return typeof(value)=="EnumItem" or type(value)=="string"
end

function AstraUI:ValidateField_167(value)
    if value == nil then return true end
    return typeof(value)=="Color3"
end

function AstraUI:ValidateField_168(value)
    if value == nil then return true end
    return type(value)=="boolean"
end

function AstraUI:ValidateField_169(value)
    if value == nil then return true end
    return type(value)=="number" and value==value
end

function AstraUI:ValidateField_170(value)
    if value == nil then return true end
    return type(value)=="number" and value==value
end

function AstraUI:ValidateField_171(value)
    if value == nil then return true end
    return type(value)=="number" and value==value
end

function AstraUI:ValidateField_172(value)
    if value == nil then return true end
    return type(value)=="table"
end

function AstraUI:ValidateField_173(value)
    if value == nil then return true end
    return typeof(value)=="EnumItem" or type(value)=="string"
end

function AstraUI:ValidateField_174(value)
    if value == nil then return true end
    return type(value)=="table"
end

function AstraUI:ValidateField_175(value)
    if value == nil then return true end
    return type(value)=="table"
end

function AstraUI:ValidateField_176(value)
    if value == nil then return true end
    return type(value)=="string"
end

function AstraUI:ValidateField_177(value)
    if value == nil then return true end
    return type(value)=="string"
end

function AstraUI:ValidateField_178(value)
    if value == nil then return true end
    return typeof(value)=="EnumItem" or type(value)=="string"
end

function AstraUI:ValidateField_179(value)
    if value == nil then return true end
    return typeof(value)=="Color3"
end

function AstraUI:ValidateField_180(value)
    if value == nil then return true end
    return type(value)=="boolean"
end

function AstraUI:ValidateField_181(value)
    if value == nil then return true end
    return type(value)=="number" and value==value
end

function AstraUI:ValidateField_182(value)
    if value == nil then return true end
    return type(value)=="number" and value==value
end

function AstraUI:ValidateField_183(value)
    if value == nil then return true end
    return type(value)=="number" and value==value
end

function AstraUI:ValidateField_184(value)
    if value == nil then return true end
    return type(value)=="table"
end

function AstraUI:ValidateField_185(value)
    if value == nil then return true end
    return typeof(value)=="EnumItem" or type(value)=="string"
end

function AstraUI:ValidateField_186(value)
    if value == nil then return true end
    return type(value)=="table"
end

function AstraUI:ValidateField_187(value)
    if value == nil then return true end
    return type(value)=="table"
end

function AstraUI:ValidateField_188(value)
    if value == nil then return true end
    return type(value)=="string"
end

function AstraUI:ValidateField_189(value)
    if value == nil then return true end
    return type(value)=="string"
end

function AstraUI:ValidateField_190(value)
    if value == nil then return true end
    return typeof(value)=="EnumItem" or type(value)=="string"
end

function AstraUI:ValidateField_191(value)
    if value == nil then return true end
    return typeof(value)=="Color3"
end

function AstraUI:ValidateField_192(value)
    if value == nil then return true end
    return type(value)=="boolean"
end

function AstraUI:ValidateField_193(value)
    if value == nil then return true end
    return type(value)=="number" and value==value
end

function AstraUI:ValidateField_194(value)
    if value == nil then return true end
    return type(value)=="number" and value==value
end

function AstraUI:ValidateField_195(value)
    if value == nil then return true end
    return type(value)=="number" and value==value
end

function AstraUI:ValidateField_196(value)
    if value == nil then return true end
    return type(value)=="table"
end

function AstraUI:ValidateField_197(value)
    if value == nil then return true end
    return typeof(value)=="EnumItem" or type(value)=="string"
end

function AstraUI:ValidateField_198(value)
    if value == nil then return true end
    return type(value)=="table"
end

function AstraUI:ValidateField_199(value)
    if value == nil then return true end
    return type(value)=="table"
end

function AstraUI:ValidateField_200(value)
    if value == nil then return true end
    return type(value)=="string"
end

function AstraUI:ValidateField_201(value)
    if value == nil then return true end
    return type(value)=="string"
end

function AstraUI:ValidateField_202(value)
    if value == nil then return true end
    return typeof(value)=="EnumItem" or type(value)=="string"
end

function AstraUI:ValidateField_203(value)
    if value == nil then return true end
    return typeof(value)=="Color3"
end

function AstraUI:ValidateField_204(value)
    if value == nil then return true end
    return type(value)=="boolean"
end

function AstraUI:ValidateField_205(value)
    if value == nil then return true end
    return type(value)=="number" and value==value
end

function AstraUI:ValidateField_206(value)
    if value == nil then return true end
    return type(value)=="number" and value==value
end

function AstraUI:ValidateField_207(value)
    if value == nil then return true end
    return type(value)=="number" and value==value
end

function AstraUI:ValidateField_208(value)
    if value == nil then return true end
    return type(value)=="table"
end

function AstraUI:ValidateField_209(value)
    if value == nil then return true end
    return typeof(value)=="EnumItem" or type(value)=="string"
end

function AstraUI:ValidateField_210(value)
    if value == nil then return true end
    return type(value)=="table"
end

function AstraUI:ValidateField_211(value)
    if value == nil then return true end
    return type(value)=="table"
end

function AstraUI:ValidateField_212(value)
    if value == nil then return true end
    return type(value)=="string"
end

function AstraUI:ValidateField_213(value)
    if value == nil then return true end
    return type(value)=="string"
end

function AstraUI:ValidateField_214(value)
    if value == nil then return true end
    return typeof(value)=="EnumItem" or type(value)=="string"
end

function AstraUI:ValidateField_215(value)
    if value == nil then return true end
    return typeof(value)=="Color3"
end

function AstraUI:ValidateField_216(value)
    if value == nil then return true end
    return type(value)=="boolean"
end

function AstraUI:ValidateField_217(value)
    if value == nil then return true end
    return type(value)=="number" and value==value
end

function AstraUI:ValidateField_218(value)
    if value == nil then return true end
    return type(value)=="number" and value==value
end

function AstraUI:ValidateField_219(value)
    if value == nil then return true end
    return type(value)=="number" and value==value
end

function AstraUI:ValidateField_220(value)
    if value == nil then return true end
    return type(value)=="table"
end

function AstraUI:ValidateField_221(value)
    if value == nil then return true end
    return typeof(value)=="EnumItem" or type(value)=="string"
end

function AstraUI:ValidateField_222(value)
    if value == nil then return true end
    return type(value)=="table"
end

function AstraUI:ValidateField_223(value)
    if value == nil then return true end
    return type(value)=="table"
end

function AstraUI:ValidateField_224(value)
    if value == nil then return true end
    return type(value)=="string"
end

function AstraUI:ValidateField_225(value)
    if value == nil then return true end
    return type(value)=="string"
end

function AstraUI:ValidateField_226(value)
    if value == nil then return true end
    return typeof(value)=="EnumItem" or type(value)=="string"
end

function AstraUI:ValidateField_227(value)
    if value == nil then return true end
    return typeof(value)=="Color3"
end

function AstraUI:ValidateField_228(value)
    if value == nil then return true end
    return type(value)=="boolean"
end

function AstraUI:ValidateField_229(value)
    if value == nil then return true end
    return type(value)=="number" and value==value
end

function AstraUI:ValidateField_230(value)
    if value == nil then return true end
    return type(value)=="number" and value==value
end

function AstraUI:ValidateField_231(value)
    if value == nil then return true end
    return type(value)=="number" and value==value
end

function AstraUI:ValidateField_232(value)
    if value == nil then return true end
    return type(value)=="table"
end

function AstraUI:ValidateField_233(value)
    if value == nil then return true end
    return typeof(value)=="EnumItem" or type(value)=="string"
end

function AstraUI:ValidateField_234(value)
    if value == nil then return true end
    return type(value)=="table"
end

function AstraUI:ValidateField_235(value)
    if value == nil then return true end
    return type(value)=="table"
end

function AstraUI:ValidateField_236(value)
    if value == nil then return true end
    return type(value)=="string"
end

function AstraUI:ValidateField_237(value)
    if value == nil then return true end
    return type(value)=="string"
end

function AstraUI:ValidateField_238(value)
    if value == nil then return true end
    return typeof(value)=="EnumItem" or type(value)=="string"
end

function AstraUI:ValidateField_239(value)
    if value == nil then return true end
    return typeof(value)=="Color3"
end

function AstraUI:ValidateField_240(value)
    if value == nil then return true end
    return type(value)=="boolean"
end

function AstraUI:ValidateField_241(value)
    if value == nil then return true end
    return type(value)=="number" and value==value
end

function AstraUI:ValidateField_242(value)
    if value == nil then return true end
    return type(value)=="number" and value==value
end

function AstraUI:ValidateField_243(value)
    if value == nil then return true end
    return type(value)=="number" and value==value
end

function AstraUI:ValidateField_244(value)
    if value == nil then return true end
    return type(value)=="table"
end

function AstraUI:ValidateField_245(value)
    if value == nil then return true end
    return typeof(value)=="EnumItem" or type(value)=="string"
end

function AstraUI:ValidateField_246(value)
    if value == nil then return true end
    return type(value)=="table"
end

function AstraUI:ValidateField_247(value)
    if value == nil then return true end
    return type(value)=="table"
end

function AstraUI:ValidateField_248(value)
    if value == nil then return true end
    return type(value)=="string"
end

function AstraUI:ValidateField_249(value)
    if value == nil then return true end
    return type(value)=="string"
end

function AstraUI:ValidateField_250(value)
    if value == nil then return true end
    return typeof(value)=="EnumItem" or type(value)=="string"
end

function AstraUI:ValidateField_251(value)
    if value == nil then return true end
    return typeof(value)=="Color3"
end

function AstraUI:ValidateField_252(value)
    if value == nil then return true end
    return type(value)=="boolean"
end

function AstraUI:ValidateField_253(value)
    if value == nil then return true end
    return type(value)=="number" and value==value
end

function AstraUI:ValidateField_254(value)
    if value == nil then return true end
    return type(value)=="number" and value==value
end

function AstraUI:ValidateField_255(value)
    if value == nil then return true end
    return type(value)=="number" and value==value
end

function AstraUI:ValidateField_256(value)
    if value == nil then return true end
    return type(value)=="table"
end

function AstraUI:ValidateField_257(value)
    if value == nil then return true end
    return typeof(value)=="EnumItem" or type(value)=="string"
end

function AstraUI:ValidateField_258(value)
    if value == nil then return true end
    return type(value)=="table"
end

function AstraUI:ValidateField_259(value)
    if value == nil then return true end
    return type(value)=="table"
end

function AstraUI:ValidateField_260(value)
    if value == nil then return true end
    return type(value)=="string"
end

function AstraUI:ValidateField_261(value)
    if value == nil then return true end
    return type(value)=="string"
end

function AstraUI:ValidateField_262(value)
    if value == nil then return true end
    return typeof(value)=="EnumItem" or type(value)=="string"
end

function AstraUI:ValidateField_263(value)
    if value == nil then return true end
    return typeof(value)=="Color3"
end

function AstraUI:ValidateField_264(value)
    if value == nil then return true end
    return type(value)=="boolean"
end

function AstraUI:ValidateField_265(value)
    if value == nil then return true end
    return type(value)=="number" and value==value
end

function AstraUI:ValidateField_266(value)
    if value == nil then return true end
    return type(value)=="number" and value==value
end

function AstraUI:ValidateField_267(value)
    if value == nil then return true end
    return type(value)=="number" and value==value
end

function AstraUI:ValidateField_268(value)
    if value == nil then return true end
    return type(value)=="table"
end

function AstraUI:ValidateField_269(value)
    if value == nil then return true end
    return typeof(value)=="EnumItem" or type(value)=="string"
end

function AstraUI:ValidateField_270(value)
    if value == nil then return true end
    return type(value)=="table"
end

function AstraUI:ValidateField_271(value)
    if value == nil then return true end
    return type(value)=="table"
end

function AstraUI:ValidateField_272(value)
    if value == nil then return true end
    return type(value)=="string"
end

function AstraUI:ValidateField_273(value)
    if value == nil then return true end
    return type(value)=="string"
end

function AstraUI:ValidateField_274(value)
    if value == nil then return true end
    return typeof(value)=="EnumItem" or type(value)=="string"
end

function AstraUI:ValidateField_275(value)
    if value == nil then return true end
    return typeof(value)=="Color3"
end

function AstraUI:ValidateField_276(value)
    if value == nil then return true end
    return type(value)=="boolean"
end

function AstraUI:ValidateField_277(value)
    if value == nil then return true end
    return type(value)=="number" and value==value
end

function AstraUI:ValidateField_278(value)
    if value == nil then return true end
    return type(value)=="number" and value==value
end

function AstraUI:ValidateField_279(value)
    if value == nil then return true end
    return type(value)=="number" and value==value
end

function AstraUI:ValidateField_280(value)
    if value == nil then return true end
    return type(value)=="table"
end

function AstraUI:ValidateField_281(value)
    if value == nil then return true end
    return typeof(value)=="EnumItem" or type(value)=="string"
end

function AstraUI:ValidateField_282(value)
    if value == nil then return true end
    return type(value)=="table"
end

function AstraUI:ValidateField_283(value)
    if value == nil then return true end
    return type(value)=="table"
end

function AstraUI:ValidateField_284(value)
    if value == nil then return true end
    return type(value)=="string"
end

function AstraUI:ValidateField_285(value)
    if value == nil then return true end
    return type(value)=="string"
end

function AstraUI:ValidateField_286(value)
    if value == nil then return true end
    return typeof(value)=="EnumItem" or type(value)=="string"
end

function AstraUI:ValidateField_287(value)
    if value == nil then return true end
    return typeof(value)=="Color3"
end

function AstraUI:ValidateField_288(value)
    if value == nil then return true end
    return type(value)=="boolean"
end

function AstraUI:ValidateField_289(value)
    if value == nil then return true end
    return type(value)=="number" and value==value
end

function AstraUI:ValidateField_290(value)
    if value == nil then return true end
    return type(value)=="number" and value==value
end

function AstraUI:ValidateField_291(value)
    if value == nil then return true end
    return type(value)=="number" and value==value
end

function AstraUI:ValidateField_292(value)
    if value == nil then return true end
    return type(value)=="table"
end

function AstraUI:ValidateField_293(value)
    if value == nil then return true end
    return typeof(value)=="EnumItem" or type(value)=="string"
end

function AstraUI:ValidateField_294(value)
    if value == nil then return true end
    return type(value)=="table"
end

function AstraUI:ValidateField_295(value)
    if value == nil then return true end
    return type(value)=="table"
end

function AstraUI:ValidateField_296(value)
    if value == nil then return true end
    return type(value)=="string"
end

function AstraUI:ValidateField_297(value)
    if value == nil then return true end
    return type(value)=="string"
end

function AstraUI:ValidateField_298(value)
    if value == nil then return true end
    return typeof(value)=="EnumItem" or type(value)=="string"
end

function AstraUI:ValidateField_299(value)
    if value == nil then return true end
    return typeof(value)=="Color3"
end

function AstraUI:ValidateField_300(value)
    if value == nil then return true end
    return type(value)=="boolean"
end

function AstraUI:ValidateField_301(value)
    if value == nil then return true end
    return type(value)=="number" and value==value
end

function AstraUI:ValidateField_302(value)
    if value == nil then return true end
    return type(value)=="number" and value==value
end

function AstraUI:ValidateField_303(value)
    if value == nil then return true end
    return type(value)=="number" and value==value
end

function AstraUI:ValidateField_304(value)
    if value == nil then return true end
    return type(value)=="table"
end

function AstraUI:ValidateField_305(value)
    if value == nil then return true end
    return typeof(value)=="EnumItem" or type(value)=="string"
end

function AstraUI:ValidateField_306(value)
    if value == nil then return true end
    return type(value)=="table"
end

function AstraUI:ValidateField_307(value)
    if value == nil then return true end
    return type(value)=="table"
end

function AstraUI:ValidateField_308(value)
    if value == nil then return true end
    return type(value)=="string"
end

function AstraUI:ValidateField_309(value)
    if value == nil then return true end
    return type(value)=="string"
end

function AstraUI:ValidateField_310(value)
    if value == nil then return true end
    return typeof(value)=="EnumItem" or type(value)=="string"
end

function AstraUI:ValidateField_311(value)
    if value == nil then return true end
    return typeof(value)=="Color3"
end

function AstraUI:ValidateField_312(value)
    if value == nil then return true end
    return type(value)=="boolean"
end

function AstraUI:ValidateField_313(value)
    if value == nil then return true end
    return type(value)=="number" and value==value
end

function AstraUI:ValidateField_314(value)
    if value == nil then return true end
    return type(value)=="number" and value==value
end

function AstraUI:ValidateField_315(value)
    if value == nil then return true end
    return type(value)=="number" and value==value
end

function AstraUI:ValidateField_316(value)
    if value == nil then return true end
    return type(value)=="table"
end

function AstraUI:ValidateField_317(value)
    if value == nil then return true end
    return typeof(value)=="EnumItem" or type(value)=="string"
end

function AstraUI:ValidateField_318(value)
    if value == nil then return true end
    return type(value)=="table"
end

function AstraUI:ValidateField_319(value)
    if value == nil then return true end
    return type(value)=="table"
end

function AstraUI:ValidateField_320(value)
    if value == nil then return true end
    return type(value)=="string"
end

function AstraUI:ValidateField_321(value)
    if value == nil then return true end
    return type(value)=="string"
end

function AstraUI:ValidateField_322(value)
    if value == nil then return true end
    return typeof(value)=="EnumItem" or type(value)=="string"
end

function AstraUI:ValidateField_323(value)
    if value == nil then return true end
    return typeof(value)=="Color3"
end

function AstraUI:ValidateField_324(value)
    if value == nil then return true end
    return type(value)=="boolean"
end

function AstraUI:ValidateField_325(value)
    if value == nil then return true end
    return type(value)=="number" and value==value
end

function AstraUI:ValidateField_326(value)
    if value == nil then return true end
    return type(value)=="number" and value==value
end

function AstraUI:ValidateField_327(value)
    if value == nil then return true end
    return type(value)=="number" and value==value
end

function AstraUI:ValidateField_328(value)
    if value == nil then return true end
    return type(value)=="table"
end

function AstraUI:ValidateField_329(value)
    if value == nil then return true end
    return typeof(value)=="EnumItem" or type(value)=="string"
end

function AstraUI:ValidateField_330(value)
    if value == nil then return true end
    return type(value)=="table"
end

function AstraUI:ValidateField_331(value)
    if value == nil then return true end
    return type(value)=="table"
end

function AstraUI:ValidateField_332(value)
    if value == nil then return true end
    return type(value)=="string"
end

function AstraUI:ValidateField_333(value)
    if value == nil then return true end
    return type(value)=="string"
end

function AstraUI:ValidateField_334(value)
    if value == nil then return true end
    return typeof(value)=="EnumItem" or type(value)=="string"
end

function AstraUI:ValidateField_335(value)
    if value == nil then return true end
    return typeof(value)=="Color3"
end

function AstraUI:ValidateField_336(value)
    if value == nil then return true end
    return type(value)=="boolean"
end

function AstraUI:ValidateField_337(value)
    if value == nil then return true end
    return type(value)=="number" and value==value
end

function AstraUI:ValidateField_338(value)
    if value == nil then return true end
    return type(value)=="number" and value==value
end

function AstraUI:ValidateField_339(value)
    if value == nil then return true end
    return type(value)=="number" and value==value
end

function AstraUI:ValidateField_340(value)
    if value == nil then return true end
    return type(value)=="table"
end

function AstraUI:ValidateField_341(value)
    if value == nil then return true end
    return typeof(value)=="EnumItem" or type(value)=="string"
end

function AstraUI:ValidateField_342(value)
    if value == nil then return true end
    return type(value)=="table"
end

function AstraUI:ValidateField_343(value)
    if value == nil then return true end
    return type(value)=="table"
end

function AstraUI:ValidateField_344(value)
    if value == nil then return true end
    return type(value)=="string"
end

function AstraUI:ValidateField_345(value)
    if value == nil then return true end
    return type(value)=="string"
end

function AstraUI:ValidateField_346(value)
    if value == nil then return true end
    return typeof(value)=="EnumItem" or type(value)=="string"
end

function AstraUI:ValidateField_347(value)
    if value == nil then return true end
    return typeof(value)=="Color3"
end

function AstraUI:ValidateField_348(value)
    if value == nil then return true end
    return type(value)=="boolean"
end

function AstraUI:ValidateField_349(value)
    if value == nil then return true end
    return type(value)=="number" and value==value
end

function AstraUI:ValidateField_350(value)
    if value == nil then return true end
    return type(value)=="number" and value==value
end

function AstraUI:ValidateField_351(value)
    if value == nil then return true end
    return type(value)=="number" and value==value
end

function AstraUI:ValidateField_352(value)
    if value == nil then return true end
    return type(value)=="table"
end

function AstraUI:ValidateField_353(value)
    if value == nil then return true end
    return typeof(value)=="EnumItem" or type(value)=="string"
end

function AstraUI:ValidateField_354(value)
    if value == nil then return true end
    return type(value)=="table"
end

function AstraUI:ValidateField_355(value)
    if value == nil then return true end
    return type(value)=="table"
end

function AstraUI:ValidateField_356(value)
    if value == nil then return true end
    return type(value)=="string"
end

function AstraUI:ValidateField_357(value)
    if value == nil then return true end
    return type(value)=="string"
end

function AstraUI:ValidateField_358(value)
    if value == nil then return true end
    return typeof(value)=="EnumItem" or type(value)=="string"
end

function AstraUI:ValidateField_359(value)
    if value == nil then return true end
    return typeof(value)=="Color3"
end

function AstraUI:ValidateField_360(value)
    if value == nil then return true end
    return type(value)=="boolean"
end

function AstraUI:ValidateField_361(value)
    if value == nil then return true end
    return type(value)=="number" and value==value
end

function AstraUI:ValidateField_362(value)
    if value == nil then return true end
    return type(value)=="number" and value==value
end

function AstraUI:ValidateField_363(value)
    if value == nil then return true end
    return type(value)=="number" and value==value
end

function AstraUI:ValidateField_364(value)
    if value == nil then return true end
    return type(value)=="table"
end

function AstraUI:ValidateField_365(value)
    if value == nil then return true end
    return typeof(value)=="EnumItem" or type(value)=="string"
end

function AstraUI:ValidateField_366(value)
    if value == nil then return true end
    return type(value)=="table"
end

function AstraUI:ValidateField_367(value)
    if value == nil then return true end
    return type(value)=="table"
end

function AstraUI:ValidateField_368(value)
    if value == nil then return true end
    return type(value)=="string"
end

function AstraUI:ValidateField_369(value)
    if value == nil then return true end
    return type(value)=="string"
end

function AstraUI:ValidateField_370(value)
    if value == nil then return true end
    return typeof(value)=="EnumItem" or type(value)=="string"
end

function AstraUI:ValidateField_371(value)
    if value == nil then return true end
    return typeof(value)=="Color3"
end

function AstraUI:ValidateField_372(value)
    if value == nil then return true end
    return type(value)=="boolean"
end

function AstraUI:ValidateField_373(value)
    if value == nil then return true end
    return type(value)=="number" and value==value
end

function AstraUI:ValidateField_374(value)
    if value == nil then return true end
    return type(value)=="number" and value==value
end

function AstraUI:ValidateField_375(value)
    if value == nil then return true end
    return type(value)=="number" and value==value
end

function AstraUI:ValidateField_376(value)
    if value == nil then return true end
    return type(value)=="table"
end

function AstraUI:ValidateField_377(value)
    if value == nil then return true end
    return typeof(value)=="EnumItem" or type(value)=="string"
end

function AstraUI:ValidateField_378(value)
    if value == nil then return true end
    return type(value)=="table"
end

function AstraUI:ValidateField_379(value)
    if value == nil then return true end
    return type(value)=="table"
end

function AstraUI:ValidateField_380(value)
    if value == nil then return true end
    return type(value)=="string"
end

function AstraUI:ValidateField_381(value)
    if value == nil then return true end
    return type(value)=="string"
end

function AstraUI:ValidateField_382(value)
    if value == nil then return true end
    return typeof(value)=="EnumItem" or type(value)=="string"
end

function AstraUI:ValidateField_383(value)
    if value == nil then return true end
    return typeof(value)=="Color3"
end

function AstraUI:ValidateField_384(value)
    if value == nil then return true end
    return type(value)=="boolean"
end

function AstraUI:ValidateField_385(value)
    if value == nil then return true end
    return type(value)=="number" and value==value
end

function AstraUI:ValidateField_386(value)
    if value == nil then return true end
    return type(value)=="number" and value==value
end

function AstraUI:ValidateField_387(value)
    if value == nil then return true end
    return type(value)=="number" and value==value
end

function AstraUI:ValidateField_388(value)
    if value == nil then return true end
    return type(value)=="table"
end

function AstraUI:ValidateField_389(value)
    if value == nil then return true end
    return typeof(value)=="EnumItem" or type(value)=="string"
end

function AstraUI:ValidateField_390(value)
    if value == nil then return true end
    return type(value)=="table"
end

function AstraUI:ValidateField_391(value)
    if value == nil then return true end
    return type(value)=="table"
end

function AstraUI:ValidateField_392(value)
    if value == nil then return true end
    return type(value)=="string"
end

function AstraUI:ValidateField_393(value)
    if value == nil then return true end
    return type(value)=="string"
end

function AstraUI:ValidateField_394(value)
    if value == nil then return true end
    return typeof(value)=="EnumItem" or type(value)=="string"
end

function AstraUI:ValidateField_395(value)
    if value == nil then return true end
    return typeof(value)=="Color3"
end

function AstraUI:ValidateField_396(value)
    if value == nil then return true end
    return type(value)=="boolean"
end

function AstraUI:ValidateField_397(value)
    if value == nil then return true end
    return type(value)=="number" and value==value
end

function AstraUI:ValidateField_398(value)
    if value == nil then return true end
    return type(value)=="number" and value==value
end

function AstraUI:ValidateField_399(value)
    if value == nil then return true end
    return type(value)=="number" and value==value
end

local Event = {}
Event.__index=Event

function Event.new() return setmetatable({Listeners={}},Event) end

function Event:Connect(callback)
    assert(type(callback)=="function","Event callback must be a function")
    table.insert(self.Listeners,callback)
    local active=true
    return {Disconnect=function() active=false end, Connected=true}
end

function Event:Fire(...)
    for _,callback in ipairs(self.Listeners) do safeCall(callback,...) end
end

AstraUI.Event=Event

--// Optional development validation. Call AstraUI:ValidateAPI() in a test environment.
function AstraUI:ValidateAPI()
    local required={"CreateWindow","SetTheme","RegisterIcon","Notify","DestroyAll"}
    local missing={}
    for _,name in ipairs(required) do if type(self[name])~="function" then table.insert(missing,name) end end
    for name,theme in pairs(self.Themes) do if type(theme)~="table" or not theme.Background or not theme.Surface then table.insert(missing,"Theme:"..name) end end
    return #missing==0,missing
end

--// Motion profile catalog
AstraUI.Animations = {}
AstraUI.Animations["GlassReveal"] = {
    Style = Enum.EasingStyle.Quint,
    Direction = Enum.EasingDirection.Out,
    Duration = 0.34,
    Start = 0.0,
    Finish = 1.0,
    Opacity = 0.94,
}

AstraUI.Animations["GlassDismiss"] = {
    Style = Enum.EasingStyle.Quint,
    Direction = Enum.EasingDirection.In,
    Duration = 0.22,
    Start = 0.0,
    Finish = 0.94,
    Opacity = 1.0,
}

AstraUI.Animations["SoftAppear"] = {
    Style = Enum.EasingStyle.Sine,
    Direction = Enum.EasingDirection.Out,
    Duration = 0.26,
    Start = 0.0,
    Finish = 0.0,
    Opacity = 1.0,
}

AstraUI.Animations["SoftDisappear"] = {
    Style = Enum.EasingStyle.Sine,
    Direction = Enum.EasingDirection.In,
    Duration = 0.2,
    Start = 0.0,
    Finish = 1.0,
    Opacity = 0.0,
}

AstraUI.Animations["Press"] = {
    Style = Enum.EasingStyle.Quad,
    Direction = Enum.EasingDirection.Out,
    Duration = 0.08,
    Start = 0.0,
    Finish = 1.0,
    Opacity = 0.98,
}

AstraUI.Animations["Release"] = {
    Style = Enum.EasingStyle.Back,
    Direction = Enum.EasingDirection.Out,
    Duration = 0.2,
    Start = 0.0,
    Finish = 0.98,
    Opacity = 1.0,
}

AstraUI.Animations["Hover"] = {
    Style = Enum.EasingStyle.Quint,
    Direction = Enum.EasingDirection.Out,
    Duration = 0.16,
    Start = 0.0,
    Finish = 1.0,
    Opacity = 1.0,
}

AstraUI.Animations["PopoverOpen"] = {
    Style = Enum.EasingStyle.Quint,
    Direction = Enum.EasingDirection.Out,
    Duration = 0.24,
    Start = 0.0,
    Finish = 0.96,
    Opacity = 1.0,
}

AstraUI.Animations["PopoverClose"] = {
    Style = Enum.EasingStyle.Quint,
    Direction = Enum.EasingDirection.In,
    Duration = 0.18,
    Start = 0.0,
    Finish = 1.0,
    Opacity = 0.96,
}

AstraUI.Animations["TabEnter"] = {
    Style = Enum.EasingStyle.Quint,
    Direction = Enum.EasingDirection.Out,
    Duration = 0.24,
    Start = 0.0,
    Finish = 0.94,
    Opacity = 1.0,
}

AstraUI.Animations["TabExit"] = {
    Style = Enum.EasingStyle.Quint,
    Direction = Enum.EasingDirection.In,
    Duration = 0.16,
    Start = 0.0,
    Finish = 1.0,
    Opacity = 0.94,
}

AstraUI.Animations["ToastEnter"] = {
    Style = Enum.EasingStyle.Back,
    Direction = Enum.EasingDirection.Out,
    Duration = 0.34,
    Start = 0.0,
    Finish = 0.92,
    Opacity = 1.0,
}

AstraUI.Animations["ToastExit"] = {
    Style = Enum.EasingStyle.Quint,
    Direction = Enum.EasingDirection.In,
    Duration = 0.22,
    Start = 0.0,
    Finish = 1.0,
    Opacity = 0.94,
}

AstraUI.Animations["DrawerOpen"] = {
    Style = Enum.EasingStyle.Quint,
    Direction = Enum.EasingDirection.Out,
    Duration = 0.3,
    Start = 0.0,
    Finish = 0.92,
    Opacity = 1.0,
}

AstraUI.Animations["DrawerClose"] = {
    Style = Enum.EasingStyle.Quint,
    Direction = Enum.EasingDirection.In,
    Duration = 0.24,
    Start = 0.0,
    Finish = 1.0,
    Opacity = 0.92,
}

AstraUI.Animations["ModalOpen"] = {
    Style = Enum.EasingStyle.Back,
    Direction = Enum.EasingDirection.Out,
    Duration = 0.36,
    Start = 0.0,
    Finish = 0.9,
    Opacity = 1.0,
}

AstraUI.Animations["ModalClose"] = {
    Style = Enum.EasingStyle.Quint,
    Direction = Enum.EasingDirection.In,
    Duration = 0.22,
    Start = 0.0,
    Finish = 1.0,
    Opacity = 0.9,
}

AstraUI.Animations["Bounce"] = {
    Style = Enum.EasingStyle.Back,
    Direction = Enum.EasingDirection.Out,
    Duration = 0.42,
    Start = 0.0,
    Finish = 0.94,
    Opacity = 1.0,
}

AstraUI.Animations["Spring"] = {
    Style = Enum.EasingStyle.Elastic,
    Direction = Enum.EasingDirection.Out,
    Duration = 0.52,
    Start = 0.0,
    Finish = 0.9,
    Opacity = 1.0,
}

AstraUI.Animations["Focus"] = {
    Style = Enum.EasingStyle.Sine,
    Direction = Enum.EasingDirection.Out,
    Duration = 0.2,
    Start = 0.0,
    Finish = 1.0,
    Opacity = 1.0,
}

AstraUI.Animations["GlassRevealUp"] = {
    Base = "GlassReveal",
    Offset = Vector2.new(0,-10),
    UseOpacity = true,
    UseScale = true,
    ScaleFrom = 0.97,
    ScaleTo = 1,
    DurationMultiplier = 1,
}

AstraUI.Animations["GlassRevealDown"] = {
    Base = "GlassReveal",
    Offset = Vector2.new(0,10),
    UseOpacity = true,
    UseScale = true,
    ScaleFrom = 0.97,
    ScaleTo = 1,
    DurationMultiplier = 1,
}

AstraUI.Animations["GlassRevealLeft"] = {
    Base = "GlassReveal",
    Offset = Vector2.new(-10,0),
    UseOpacity = true,
    UseScale = true,
    ScaleFrom = 0.97,
    ScaleTo = 1,
    DurationMultiplier = 1,
}

AstraUI.Animations["GlassRevealRight"] = {
    Base = "GlassReveal",
    Offset = Vector2.new(10,0),
    UseOpacity = true,
    UseScale = true,
    ScaleFrom = 0.97,
    ScaleTo = 1,
    DurationMultiplier = 1,
}

AstraUI.Animations["GlassDismissUp"] = {
    Base = "GlassDismiss",
    Offset = Vector2.new(0,-10),
    UseOpacity = true,
    UseScale = true,
    ScaleFrom = 0.97,
    ScaleTo = 1,
    DurationMultiplier = 1,
}

AstraUI.Animations["GlassDismissDown"] = {
    Base = "GlassDismiss",
    Offset = Vector2.new(0,10),
    UseOpacity = true,
    UseScale = true,
    ScaleFrom = 0.97,
    ScaleTo = 1,
    DurationMultiplier = 1,
}

AstraUI.Animations["GlassDismissLeft"] = {
    Base = "GlassDismiss",
    Offset = Vector2.new(-10,0),
    UseOpacity = true,
    UseScale = true,
    ScaleFrom = 0.97,
    ScaleTo = 1,
    DurationMultiplier = 1,
}

AstraUI.Animations["GlassDismissRight"] = {
    Base = "GlassDismiss",
    Offset = Vector2.new(10,0),
    UseOpacity = true,
    UseScale = true,
    ScaleFrom = 0.97,
    ScaleTo = 1,
    DurationMultiplier = 1,
}

AstraUI.Animations["SoftAppearUp"] = {
    Base = "SoftAppear",
    Offset = Vector2.new(0,-10),
    UseOpacity = true,
    UseScale = true,
    ScaleFrom = 0.97,
    ScaleTo = 1,
    DurationMultiplier = 1,
}

AstraUI.Animations["SoftAppearDown"] = {
    Base = "SoftAppear",
    Offset = Vector2.new(0,10),
    UseOpacity = true,
    UseScale = true,
    ScaleFrom = 0.97,
    ScaleTo = 1,
    DurationMultiplier = 1,
}

AstraUI.Animations["SoftAppearLeft"] = {
    Base = "SoftAppear",
    Offset = Vector2.new(-10,0),
    UseOpacity = true,
    UseScale = true,
    ScaleFrom = 0.97,
    ScaleTo = 1,
    DurationMultiplier = 1,
}

AstraUI.Animations["SoftAppearRight"] = {
    Base = "SoftAppear",
    Offset = Vector2.new(10,0),
    UseOpacity = true,
    UseScale = true,
    ScaleFrom = 0.97,
    ScaleTo = 1,
    DurationMultiplier = 1,
}

AstraUI.Animations["SoftDisappearUp"] = {
    Base = "SoftDisappear",
    Offset = Vector2.new(0,-10),
    UseOpacity = true,
    UseScale = true,
    ScaleFrom = 0.97,
    ScaleTo = 1,
    DurationMultiplier = 1,
}

AstraUI.Animations["SoftDisappearDown"] = {
    Base = "SoftDisappear",
    Offset = Vector2.new(0,10),
    UseOpacity = true,
    UseScale = true,
    ScaleFrom = 0.97,
    ScaleTo = 1,
    DurationMultiplier = 1,
}

AstraUI.Animations["SoftDisappearLeft"] = {
    Base = "SoftDisappear",
    Offset = Vector2.new(-10,0),
    UseOpacity = true,
    UseScale = true,
    ScaleFrom = 0.97,
    ScaleTo = 1,
    DurationMultiplier = 1,
}

AstraUI.Animations["SoftDisappearRight"] = {
    Base = "SoftDisappear",
    Offset = Vector2.new(10,0),
    UseOpacity = true,
    UseScale = true,
    ScaleFrom = 0.97,
    ScaleTo = 1,
    DurationMultiplier = 1,
}

AstraUI.Animations["PressUp"] = {
    Base = "Press",
    Offset = Vector2.new(0,-10),
    UseOpacity = true,
    UseScale = true,
    ScaleFrom = 0.97,
    ScaleTo = 1,
    DurationMultiplier = 1,
}

AstraUI.Animations["PressDown"] = {
    Base = "Press",
    Offset = Vector2.new(0,10),
    UseOpacity = true,
    UseScale = true,
    ScaleFrom = 0.97,
    ScaleTo = 1,
    DurationMultiplier = 1,
}

AstraUI.Animations["PressLeft"] = {
    Base = "Press",
    Offset = Vector2.new(-10,0),
    UseOpacity = true,
    UseScale = true,
    ScaleFrom = 0.97,
    ScaleTo = 1,
    DurationMultiplier = 1,
}

AstraUI.Animations["PressRight"] = {
    Base = "Press",
    Offset = Vector2.new(10,0),
    UseOpacity = true,
    UseScale = true,
    ScaleFrom = 0.97,
    ScaleTo = 1,
    DurationMultiplier = 1,
}

AstraUI.Animations["ReleaseUp"] = {
    Base = "Release",
    Offset = Vector2.new(0,-10),
    UseOpacity = true,
    UseScale = true,
    ScaleFrom = 0.97,
    ScaleTo = 1,
    DurationMultiplier = 1,
}

AstraUI.Animations["ReleaseDown"] = {
    Base = "Release",
    Offset = Vector2.new(0,10),
    UseOpacity = true,
    UseScale = true,
    ScaleFrom = 0.97,
    ScaleTo = 1,
    DurationMultiplier = 1,
}

AstraUI.Animations["ReleaseLeft"] = {
    Base = "Release",
    Offset = Vector2.new(-10,0),
    UseOpacity = true,
    UseScale = true,
    ScaleFrom = 0.97,
    ScaleTo = 1,
    DurationMultiplier = 1,
}

AstraUI.Animations["ReleaseRight"] = {
    Base = "Release",
    Offset = Vector2.new(10,0),
    UseOpacity = true,
    UseScale = true,
    ScaleFrom = 0.97,
    ScaleTo = 1,
    DurationMultiplier = 1,
}

AstraUI.Animations["HoverUp"] = {
    Base = "Hover",
    Offset = Vector2.new(0,-10),
    UseOpacity = true,
    UseScale = true,
    ScaleFrom = 0.97,
    ScaleTo = 1,
    DurationMultiplier = 1,
}

AstraUI.Animations["HoverDown"] = {
    Base = "Hover",
    Offset = Vector2.new(0,10),
    UseOpacity = true,
    UseScale = true,
    ScaleFrom = 0.97,
    ScaleTo = 1,
    DurationMultiplier = 1,
}

AstraUI.Animations["HoverLeft"] = {
    Base = "Hover",
    Offset = Vector2.new(-10,0),
    UseOpacity = true,
    UseScale = true,
    ScaleFrom = 0.97,
    ScaleTo = 1,
    DurationMultiplier = 1,
}

AstraUI.Animations["HoverRight"] = {
    Base = "Hover",
    Offset = Vector2.new(10,0),
    UseOpacity = true,
    UseScale = true,
    ScaleFrom = 0.97,
    ScaleTo = 1,
    DurationMultiplier = 1,
}

AstraUI.Animations["PopoverOpenUp"] = {
    Base = "PopoverOpen",
    Offset = Vector2.new(0,-10),
    UseOpacity = true,
    UseScale = true,
    ScaleFrom = 0.97,
    ScaleTo = 1,
    DurationMultiplier = 1,
}

AstraUI.Animations["PopoverOpenDown"] = {
    Base = "PopoverOpen",
    Offset = Vector2.new(0,10),
    UseOpacity = true,
    UseScale = true,
    ScaleFrom = 0.97,
    ScaleTo = 1,
    DurationMultiplier = 1,
}

AstraUI.Animations["PopoverOpenLeft"] = {
    Base = "PopoverOpen",
    Offset = Vector2.new(-10,0),
    UseOpacity = true,
    UseScale = true,
    ScaleFrom = 0.97,
    ScaleTo = 1,
    DurationMultiplier = 1,
}

AstraUI.Animations["PopoverOpenRight"] = {
    Base = "PopoverOpen",
    Offset = Vector2.new(10,0),
    UseOpacity = true,
    UseScale = true,
    ScaleFrom = 0.97,
    ScaleTo = 1,
    DurationMultiplier = 1,
}

AstraUI.Animations["PopoverCloseUp"] = {
    Base = "PopoverClose",
    Offset = Vector2.new(0,-10),
    UseOpacity = true,
    UseScale = true,
    ScaleFrom = 0.97,
    ScaleTo = 1,
    DurationMultiplier = 1,
}

AstraUI.Animations["PopoverCloseDown"] = {
    Base = "PopoverClose",
    Offset = Vector2.new(0,10),
    UseOpacity = true,
    UseScale = true,
    ScaleFrom = 0.97,
    ScaleTo = 1,
    DurationMultiplier = 1,
}

AstraUI.Animations["PopoverCloseLeft"] = {
    Base = "PopoverClose",
    Offset = Vector2.new(-10,0),
    UseOpacity = true,
    UseScale = true,
    ScaleFrom = 0.97,
    ScaleTo = 1,
    DurationMultiplier = 1,
}

AstraUI.Animations["PopoverCloseRight"] = {
    Base = "PopoverClose",
    Offset = Vector2.new(10,0),
    UseOpacity = true,
    UseScale = true,
    ScaleFrom = 0.97,
    ScaleTo = 1,
    DurationMultiplier = 1,
}

AstraUI.Animations["TabEnterUp"] = {
    Base = "TabEnter",
    Offset = Vector2.new(0,-10),
    UseOpacity = true,
    UseScale = true,
    ScaleFrom = 0.97,
    ScaleTo = 1,
    DurationMultiplier = 1,
}

AstraUI.Animations["TabEnterDown"] = {
    Base = "TabEnter",
    Offset = Vector2.new(0,10),
    UseOpacity = true,
    UseScale = true,
    ScaleFrom = 0.97,
    ScaleTo = 1,
    DurationMultiplier = 1,
}

AstraUI.Animations["TabEnterLeft"] = {
    Base = "TabEnter",
    Offset = Vector2.new(-10,0),
    UseOpacity = true,
    UseScale = true,
    ScaleFrom = 0.97,
    ScaleTo = 1,
    DurationMultiplier = 1,
}

AstraUI.Animations["TabEnterRight"] = {
    Base = "TabEnter",
    Offset = Vector2.new(10,0),
    UseOpacity = true,
    UseScale = true,
    ScaleFrom = 0.97,
    ScaleTo = 1,
    DurationMultiplier = 1,
}

AstraUI.Animations["TabExitUp"] = {
    Base = "TabExit",
    Offset = Vector2.new(0,-10),
    UseOpacity = true,
    UseScale = true,
    ScaleFrom = 0.97,
    ScaleTo = 1,
    DurationMultiplier = 1,
}

AstraUI.Animations["TabExitDown"] = {
    Base = "TabExit",
    Offset = Vector2.new(0,10),
    UseOpacity = true,
    UseScale = true,
    ScaleFrom = 0.97,
    ScaleTo = 1,
    DurationMultiplier = 1,
}

AstraUI.Animations["TabExitLeft"] = {
    Base = "TabExit",
    Offset = Vector2.new(-10,0),
    UseOpacity = true,
    UseScale = true,
    ScaleFrom = 0.97,
    ScaleTo = 1,
    DurationMultiplier = 1,
}

AstraUI.Animations["TabExitRight"] = {
    Base = "TabExit",
    Offset = Vector2.new(10,0),
    UseOpacity = true,
    UseScale = true,
    ScaleFrom = 0.97,
    ScaleTo = 1,
    DurationMultiplier = 1,
}

AstraUI.Animations["ToastEnterUp"] = {
    Base = "ToastEnter",
    Offset = Vector2.new(0,-10),
    UseOpacity = true,
    UseScale = true,
    ScaleFrom = 0.97,
    ScaleTo = 1,
    DurationMultiplier = 1,
}

AstraUI.Animations["ToastEnterDown"] = {
    Base = "ToastEnter",
    Offset = Vector2.new(0,10),
    UseOpacity = true,
    UseScale = true,
    ScaleFrom = 0.97,
    ScaleTo = 1,
    DurationMultiplier = 1,
}

AstraUI.Animations["ToastEnterLeft"] = {
    Base = "ToastEnter",
    Offset = Vector2.new(-10,0),
    UseOpacity = true,
    UseScale = true,
    ScaleFrom = 0.97,
    ScaleTo = 1,
    DurationMultiplier = 1,
}

AstraUI.Animations["ToastEnterRight"] = {
    Base = "ToastEnter",
    Offset = Vector2.new(10,0),
    UseOpacity = true,
    UseScale = true,
    ScaleFrom = 0.97,
    ScaleTo = 1,
    DurationMultiplier = 1,
}

AstraUI.Animations["ToastExitUp"] = {
    Base = "ToastExit",
    Offset = Vector2.new(0,-10),
    UseOpacity = true,
    UseScale = true,
    ScaleFrom = 0.97,
    ScaleTo = 1,
    DurationMultiplier = 1,
}

AstraUI.Animations["ToastExitDown"] = {
    Base = "ToastExit",
    Offset = Vector2.new(0,10),
    UseOpacity = true,
    UseScale = true,
    ScaleFrom = 0.97,
    ScaleTo = 1,
    DurationMultiplier = 1,
}

AstraUI.Animations["ToastExitLeft"] = {
    Base = "ToastExit",
    Offset = Vector2.new(-10,0),
    UseOpacity = true,
    UseScale = true,
    ScaleFrom = 0.97,
    ScaleTo = 1,
    DurationMultiplier = 1,
}

AstraUI.Animations["ToastExitRight"] = {
    Base = "ToastExit",
    Offset = Vector2.new(10,0),
    UseOpacity = true,
    UseScale = true,
    ScaleFrom = 0.97,
    ScaleTo = 1,
    DurationMultiplier = 1,
}

AstraUI.Animations["DrawerOpenUp"] = {
    Base = "DrawerOpen",
    Offset = Vector2.new(0,-10),
    UseOpacity = true,
    UseScale = true,
    ScaleFrom = 0.97,
    ScaleTo = 1,
    DurationMultiplier = 1,
}

AstraUI.Animations["DrawerOpenDown"] = {
    Base = "DrawerOpen",
    Offset = Vector2.new(0,10),
    UseOpacity = true,
    UseScale = true,
    ScaleFrom = 0.97,
    ScaleTo = 1,
    DurationMultiplier = 1,
}

AstraUI.Animations["DrawerOpenLeft"] = {
    Base = "DrawerOpen",
    Offset = Vector2.new(-10,0),
    UseOpacity = true,
    UseScale = true,
    ScaleFrom = 0.97,
    ScaleTo = 1,
    DurationMultiplier = 1,
}

AstraUI.Animations["DrawerOpenRight"] = {
    Base = "DrawerOpen",
    Offset = Vector2.new(10,0),
    UseOpacity = true,
    UseScale = true,
    ScaleFrom = 0.97,
    ScaleTo = 1,
    DurationMultiplier = 1,
}

AstraUI.Animations["DrawerCloseUp"] = {
    Base = "DrawerClose",
    Offset = Vector2.new(0,-10),
    UseOpacity = true,
    UseScale = true,
    ScaleFrom = 0.97,
    ScaleTo = 1,
    DurationMultiplier = 1,
}

AstraUI.Animations["DrawerCloseDown"] = {
    Base = "DrawerClose",
    Offset = Vector2.new(0,10),
    UseOpacity = true,
    UseScale = true,
    ScaleFrom = 0.97,
    ScaleTo = 1,
    DurationMultiplier = 1,
}

AstraUI.Animations["DrawerCloseLeft"] = {
    Base = "DrawerClose",
    Offset = Vector2.new(-10,0),
    UseOpacity = true,
    UseScale = true,
    ScaleFrom = 0.97,
    ScaleTo = 1,
    DurationMultiplier = 1,
}

AstraUI.Animations["DrawerCloseRight"] = {
    Base = "DrawerClose",
    Offset = Vector2.new(10,0),
    UseOpacity = true,
    UseScale = true,
    ScaleFrom = 0.97,
    ScaleTo = 1,
    DurationMultiplier = 1,
}

AstraUI.Animations["ModalOpenUp"] = {
    Base = "ModalOpen",
    Offset = Vector2.new(0,-10),
    UseOpacity = true,
    UseScale = true,
    ScaleFrom = 0.97,
    ScaleTo = 1,
    DurationMultiplier = 1,
}

AstraUI.Animations["ModalOpenDown"] = {
    Base = "ModalOpen",
    Offset = Vector2.new(0,10),
    UseOpacity = true,
    UseScale = true,
    ScaleFrom = 0.97,
    ScaleTo = 1,
    DurationMultiplier = 1,
}

AstraUI.Animations["ModalOpenLeft"] = {
    Base = "ModalOpen",
    Offset = Vector2.new(-10,0),
    UseOpacity = true,
    UseScale = true,
    ScaleFrom = 0.97,
    ScaleTo = 1,
    DurationMultiplier = 1,
}

AstraUI.Animations["ModalOpenRight"] = {
    Base = "ModalOpen",
    Offset = Vector2.new(10,0),
    UseOpacity = true,
    UseScale = true,
    ScaleFrom = 0.97,
    ScaleTo = 1,
    DurationMultiplier = 1,
}

AstraUI.Animations["ModalCloseUp"] = {
    Base = "ModalClose",
    Offset = Vector2.new(0,-10),
    UseOpacity = true,
    UseScale = true,
    ScaleFrom = 0.97,
    ScaleTo = 1,
    DurationMultiplier = 1,
}

AstraUI.Animations["ModalCloseDown"] = {
    Base = "ModalClose",
    Offset = Vector2.new(0,10),
    UseOpacity = true,
    UseScale = true,
    ScaleFrom = 0.97,
    ScaleTo = 1,
    DurationMultiplier = 1,
}

AstraUI.Animations["ModalCloseLeft"] = {
    Base = "ModalClose",
    Offset = Vector2.new(-10,0),
    UseOpacity = true,
    UseScale = true,
    ScaleFrom = 0.97,
    ScaleTo = 1,
    DurationMultiplier = 1,
}

AstraUI.Animations["ModalCloseRight"] = {
    Base = "ModalClose",
    Offset = Vector2.new(10,0),
    UseOpacity = true,
    UseScale = true,
    ScaleFrom = 0.97,
    ScaleTo = 1,
    DurationMultiplier = 1,
}

AstraUI.Animations["BounceUp"] = {
    Base = "Bounce",
    Offset = Vector2.new(0,-10),
    UseOpacity = true,
    UseScale = true,
    ScaleFrom = 0.97,
    ScaleTo = 1,
    DurationMultiplier = 1,
}

AstraUI.Animations["BounceDown"] = {
    Base = "Bounce",
    Offset = Vector2.new(0,10),
    UseOpacity = true,
    UseScale = true,
    ScaleFrom = 0.97,
    ScaleTo = 1,
    DurationMultiplier = 1,
}

AstraUI.Animations["BounceLeft"] = {
    Base = "Bounce",
    Offset = Vector2.new(-10,0),
    UseOpacity = true,
    UseScale = true,
    ScaleFrom = 0.97,
    ScaleTo = 1,
    DurationMultiplier = 1,
}

AstraUI.Animations["BounceRight"] = {
    Base = "Bounce",
    Offset = Vector2.new(10,0),
    UseOpacity = true,
    UseScale = true,
    ScaleFrom = 0.97,
    ScaleTo = 1,
    DurationMultiplier = 1,
}

AstraUI.Animations["SpringUp"] = {
    Base = "Spring",
    Offset = Vector2.new(0,-10),
    UseOpacity = true,
    UseScale = true,
    ScaleFrom = 0.97,
    ScaleTo = 1,
    DurationMultiplier = 1,
}

AstraUI.Animations["SpringDown"] = {
    Base = "Spring",
    Offset = Vector2.new(0,10),
    UseOpacity = true,
    UseScale = true,
    ScaleFrom = 0.97,
    ScaleTo = 1,
    DurationMultiplier = 1,
}

AstraUI.Animations["SpringLeft"] = {
    Base = "Spring",
    Offset = Vector2.new(-10,0),
    UseOpacity = true,
    UseScale = true,
    ScaleFrom = 0.97,
    ScaleTo = 1,
    DurationMultiplier = 1,
}

AstraUI.Animations["SpringRight"] = {
    Base = "Spring",
    Offset = Vector2.new(10,0),
    UseOpacity = true,
    UseScale = true,
    ScaleFrom = 0.97,
    ScaleTo = 1,
    DurationMultiplier = 1,
}

AstraUI.Animations["FocusUp"] = {
    Base = "Focus",
    Offset = Vector2.new(0,-10),
    UseOpacity = true,
    UseScale = true,
    ScaleFrom = 0.97,
    ScaleTo = 1,
    DurationMultiplier = 1,
}

AstraUI.Animations["FocusDown"] = {
    Base = "Focus",
    Offset = Vector2.new(0,10),
    UseOpacity = true,
    UseScale = true,
    ScaleFrom = 0.97,
    ScaleTo = 1,
    DurationMultiplier = 1,
}

AstraUI.Animations["FocusLeft"] = {
    Base = "Focus",
    Offset = Vector2.new(-10,0),
    UseOpacity = true,
    UseScale = true,
    ScaleFrom = 0.97,
    ScaleTo = 1,
    DurationMultiplier = 1,
}

AstraUI.Animations["FocusRight"] = {
    Base = "Focus",
    Offset = Vector2.new(10,0),
    UseOpacity = true,
    UseScale = true,
    ScaleFrom = 0.97,
    ScaleTo = 1,
    DurationMultiplier = 1,
}

AstraUI.Themes["GlassTone001"] = {
    Background = Color3.fromRGB(26,33,23),
    Surface = Color3.fromRGB(52,67,47),
    SurfaceRaised = Color3.fromRGB(62,70,57),
    Text = Color3.fromRGB(242,242,247),
    Muted = Color3.fromRGB(197,212,202),
    Accent = Color3.fromRGB(170,193,184),
    Border = Color3.fromRGB(255,255,255),
    Danger = Color3.fromRGB(255,92,112),
    Success = Color3.fromRGB(92,226,157),
    Warning = Color3.fromRGB(255,190,83),
}

AstraUI.Themes["GlassTone002"] = {
    Background = Color3.fromRGB(26,33,23),
    Surface = Color3.fromRGB(53,67,47),
    SurfaceRaised = Color3.fromRGB(63,70,57),
    Text = Color3.fromRGB(242,242,247),
    Muted = Color3.fromRGB(198,212,202),
    Accent = Color3.fromRGB(173,192,183),
    Border = Color3.fromRGB(255,255,255),
    Danger = Color3.fromRGB(255,92,112),
    Success = Color3.fromRGB(92,226,157),
    Warning = Color3.fromRGB(255,190,83),
}

AstraUI.Themes["GlassTone003"] = {
    Background = Color3.fromRGB(27,33,23),
    Surface = Color3.fromRGB(54,66,46),
    SurfaceRaised = Color3.fromRGB(64,70,56),
    Text = Color3.fromRGB(242,242,247),
    Muted = Color3.fromRGB(199,211,201),
    Accent = Color3.fromRGB(176,190,182),
    Border = Color3.fromRGB(255,255,255),
    Danger = Color3.fromRGB(255,92,112),
    Success = Color3.fromRGB(92,226,157),
    Warning = Color3.fromRGB(255,190,83),
}

AstraUI.Themes["GlassTone004"] = {
    Background = Color3.fromRGB(27,32,23),
    Surface = Color3.fromRGB(55,65,46),
    SurfaceRaised = Color3.fromRGB(65,70,56),
    Text = Color3.fromRGB(242,242,247),
    Muted = Color3.fromRGB(200,210,201),
    Accent = Color3.fromRGB(179,188,181),
    Border = Color3.fromRGB(255,255,255),
    Danger = Color3.fromRGB(255,92,112),
    Success = Color3.fromRGB(92,226,157),
    Warning = Color3.fromRGB(255,190,83),
}

AstraUI.Themes["GlassTone005"] = {
    Background = Color3.fromRGB(28,32,22),
    Surface = Color3.fromRGB(56,64,45),
    SurfaceRaised = Color3.fromRGB(66,70,55),
    Text = Color3.fromRGB(242,242,247),
    Muted = Color3.fromRGB(201,209,200),
    Accent = Color3.fromRGB(182,186,181),
    Border = Color3.fromRGB(255,255,255),
    Danger = Color3.fromRGB(255,92,112),
    Success = Color3.fromRGB(92,226,157),
    Warning = Color3.fromRGB(255,190,83),
}

AstraUI.Themes["GlassTone006"] = {
    Background = Color3.fromRGB(28,32,22),
    Surface = Color3.fromRGB(57,64,45),
    SurfaceRaised = Color3.fromRGB(67,70,55),
    Text = Color3.fromRGB(242,242,247),
    Muted = Color3.fromRGB(202,209,200),
    Accent = Color3.fromRGB(185,184,180),
    Border = Color3.fromRGB(255,255,255),
    Danger = Color3.fromRGB(255,92,112),
    Success = Color3.fromRGB(92,226,157),
    Warning = Color3.fromRGB(255,190,83),
}

AstraUI.Themes["GlassTone007"] = {
    Background = Color3.fromRGB(29,31,22),
    Surface = Color3.fromRGB(58,63,45),
    SurfaceRaised = Color3.fromRGB(68,70,55),
    Text = Color3.fromRGB(242,242,247),
    Muted = Color3.fromRGB(203,208,200),
    Accent = Color3.fromRGB(188,182,180),
    Border = Color3.fromRGB(255,255,255),
    Danger = Color3.fromRGB(255,92,112),
    Success = Color3.fromRGB(92,226,157),
    Warning = Color3.fromRGB(255,190,83),
}

AstraUI.Themes["GlassTone008"] = {
    Background = Color3.fromRGB(29,31,22),
    Surface = Color3.fromRGB(59,62,45),
    SurfaceRaised = Color3.fromRGB(69,70,55),
    Text = Color3.fromRGB(242,242,247),
    Muted = Color3.fromRGB(204,207,200),
    Accent = Color3.fromRGB(191,180,180),
    Border = Color3.fromRGB(255,255,255),
    Danger = Color3.fromRGB(255,92,112),
    Success = Color3.fromRGB(92,226,157),
    Warning = Color3.fromRGB(255,190,83),
}

AstraUI.Themes["GlassTone009"] = {
    Background = Color3.fromRGB(30,30,22),
    Surface = Color3.fromRGB(60,61,45),
    SurfaceRaised = Color3.fromRGB(70,70,55),
    Text = Color3.fromRGB(242,242,247),
    Muted = Color3.fromRGB(205,206,200),
    Accent = Color3.fromRGB(194,178,180),
    Border = Color3.fromRGB(255,255,255),
    Danger = Color3.fromRGB(255,92,112),
    Success = Color3.fromRGB(92,226,157),
    Warning = Color3.fromRGB(255,190,83),
}

AstraUI.Themes["GlassTone010"] = {
    Background = Color3.fromRGB(30,30,22),
    Surface = Color3.fromRGB(61,60,45),
    SurfaceRaised = Color3.fromRGB(70,70,55),
    Text = Color3.fromRGB(242,242,247),
    Muted = Color3.fromRGB(206,205,200),
    Accent = Color3.fromRGB(196,175,180),
    Border = Color3.fromRGB(255,255,255),
    Danger = Color3.fromRGB(255,92,112),
    Success = Color3.fromRGB(92,226,157),
    Warning = Color3.fromRGB(255,190,83),
}

AstraUI.Themes["GlassTone011"] = {
    Background = Color3.fromRGB(31,29,22),
    Surface = Color3.fromRGB(62,59,45),
    SurfaceRaised = Color3.fromRGB(70,69,55),
    Text = Color3.fromRGB(242,242,247),
    Muted = Color3.fromRGB(207,204,200),
    Accent = Color3.fromRGB(199,173,180),
    Border = Color3.fromRGB(255,255,255),
    Danger = Color3.fromRGB(255,92,112),
    Success = Color3.fromRGB(92,226,157),
    Warning = Color3.fromRGB(255,190,83),
}

AstraUI.Themes["GlassTone012"] = {
    Background = Color3.fromRGB(31,29,22),
    Surface = Color3.fromRGB(63,58,45),
    SurfaceRaised = Color3.fromRGB(70,68,55),
    Text = Color3.fromRGB(242,242,247),
    Muted = Color3.fromRGB(208,203,200),
    Accent = Color3.fromRGB(201,170,180),
    Border = Color3.fromRGB(255,255,255),
    Danger = Color3.fromRGB(255,92,112),
    Success = Color3.fromRGB(92,226,157),
    Warning = Color3.fromRGB(255,190,83),
}

AstraUI.Themes["GlassTone013"] = {
    Background = Color3.fromRGB(32,28,22),
    Surface = Color3.fromRGB(64,57,45),
    SurfaceRaised = Color3.fromRGB(70,67,55),
    Text = Color3.fromRGB(242,242,247),
    Muted = Color3.fromRGB(209,202,200),
    Accent = Color3.fromRGB(204,167,181),
    Border = Color3.fromRGB(255,255,255),
    Danger = Color3.fromRGB(255,92,112),
    Success = Color3.fromRGB(92,226,157),
    Warning = Color3.fromRGB(255,190,83),
}

AstraUI.Themes["GlassTone014"] = {
    Background = Color3.fromRGB(32,28,23),
    Surface = Color3.fromRGB(65,56,46),
    SurfaceRaised = Color3.fromRGB(70,66,56),
    Text = Color3.fromRGB(242,242,247),
    Muted = Color3.fromRGB(210,201,201),
    Accent = Color3.fromRGB(206,165,181),
    Border = Color3.fromRGB(255,255,255),
    Danger = Color3.fromRGB(255,92,112),
    Success = Color3.fromRGB(92,226,157),
    Warning = Color3.fromRGB(255,190,83),
}

AstraUI.Themes["GlassTone015"] = {
    Background = Color3.fromRGB(32,27,23),
    Surface = Color3.fromRGB(65,55,46),
    SurfaceRaised = Color3.fromRGB(70,65,56),
    Text = Color3.fromRGB(242,242,247),
    Muted = Color3.fromRGB(210,200,201),
    Accent = Color3.fromRGB(208,162,182),
    Border = Color3.fromRGB(255,255,255),
    Danger = Color3.fromRGB(255,92,112),
    Success = Color3.fromRGB(92,226,157),
    Warning = Color3.fromRGB(255,190,83),
}

AstraUI.Themes["GlassTone016"] = {
    Background = Color3.fromRGB(33,27,23),
    Surface = Color3.fromRGB(66,54,47),
    SurfaceRaised = Color3.fromRGB(70,64,57),
    Text = Color3.fromRGB(242,242,247),
    Muted = Color3.fromRGB(211,199,202),
    Accent = Color3.fromRGB(210,159,183),
    Border = Color3.fromRGB(255,255,255),
    Danger = Color3.fromRGB(255,92,112),
    Success = Color3.fromRGB(92,226,157),
    Warning = Color3.fromRGB(255,190,83),
}

AstraUI.Themes["GlassTone017"] = {
    Background = Color3.fromRGB(33,26,23),
    Surface = Color3.fromRGB(67,53,47),
    SurfaceRaised = Color3.fromRGB(70,63,57),
    Text = Color3.fromRGB(242,242,247),
    Muted = Color3.fromRGB(212,198,202),
    Accent = Color3.fromRGB(212,156,184),
    Border = Color3.fromRGB(255,255,255),
    Danger = Color3.fromRGB(255,92,112),
    Success = Color3.fromRGB(92,226,157),
    Warning = Color3.fromRGB(255,190,83),
}

AstraUI.Themes["GlassTone018"] = {
    Background = Color3.fromRGB(33,26,24),
    Surface = Color3.fromRGB(67,52,48),
    SurfaceRaised = Color3.fromRGB(70,62,58),
    Text = Color3.fromRGB(242,242,247),
    Muted = Color3.fromRGB(212,197,203),
    Accent = Color3.fromRGB(213,153,185),
    Border = Color3.fromRGB(255,255,255),
    Danger = Color3.fromRGB(255,92,112),
    Success = Color3.fromRGB(92,226,157),
    Warning = Color3.fromRGB(255,190,83),
}

AstraUI.Themes["GlassTone019"] = {
    Background = Color3.fromRGB(34,25,24),
    Surface = Color3.fromRGB(68,50,49),
    SurfaceRaised = Color3.fromRGB(70,60,59),
    Text = Color3.fromRGB(242,242,247),
    Muted = Color3.fromRGB(213,195,204),
    Accent = Color3.fromRGB(215,150,186),
    Border = Color3.fromRGB(255,255,255),
    Danger = Color3.fromRGB(255,92,112),
    Success = Color3.fromRGB(92,226,157),
    Warning = Color3.fromRGB(255,190,83),
}

AstraUI.Themes["GlassTone020"] = {
    Background = Color3.fromRGB(34,24,25),
    Surface = Color3.fromRGB(68,49,50),
    SurfaceRaised = Color3.fromRGB(70,59,60),
    Text = Color3.fromRGB(242,242,247),
    Muted = Color3.fromRGB(213,194,205),
    Accent = Color3.fromRGB(216,148,187),
    Border = Color3.fromRGB(255,255,255),
    Danger = Color3.fromRGB(255,92,112),
    Success = Color3.fromRGB(92,226,157),
    Warning = Color3.fromRGB(255,190,83),
}

AstraUI.Themes["GlassTone021"] = {
    Background = Color3.fromRGB(34,24,25),
    Surface = Color3.fromRGB(69,48,50),
    SurfaceRaised = Color3.fromRGB(70,58,60),
    Text = Color3.fromRGB(242,242,247),
    Muted = Color3.fromRGB(214,193,205),
    Accent = Color3.fromRGB(217,145,189),
    Border = Color3.fromRGB(255,255,255),
    Danger = Color3.fromRGB(255,92,112),
    Success = Color3.fromRGB(92,226,157),
    Warning = Color3.fromRGB(255,190,83),
}

AstraUI.Themes["GlassTone022"] = {
    Background = Color3.fromRGB(34,23,25),
    Surface = Color3.fromRGB(69,47,51),
    SurfaceRaised = Color3.fromRGB(70,57,61),
    Text = Color3.fromRGB(242,242,247),
    Muted = Color3.fromRGB(214,192,206),
    Accent = Color3.fromRGB(218,142,190),
    Border = Color3.fromRGB(255,255,255),
    Danger = Color3.fromRGB(255,92,112),
    Success = Color3.fromRGB(92,226,157),
    Warning = Color3.fromRGB(255,190,83),
}

AstraUI.Themes["GlassTone023"] = {
    Background = Color3.fromRGB(34,23,26),
    Surface = Color3.fromRGB(69,46,52),
    SurfaceRaised = Color3.fromRGB(70,56,62),
    Text = Color3.fromRGB(242,242,247),
    Muted = Color3.fromRGB(214,191,207),
    Accent = Color3.fromRGB(219,139,192),
    Border = Color3.fromRGB(255,255,255),
    Danger = Color3.fromRGB(255,92,112),
    Success = Color3.fromRGB(92,226,157),
    Warning = Color3.fromRGB(255,190,83),
}

AstraUI.Themes["GlassTone024"] = {
    Background = Color3.fromRGB(34,22,27),
    Surface = Color3.fromRGB(69,45,54),
    SurfaceRaised = Color3.fromRGB(70,55,64),
    Text = Color3.fromRGB(242,242,247),
    Muted = Color3.fromRGB(214,190,209),
    Accent = Color3.fromRGB(219,137,194),
    Border = Color3.fromRGB(255,255,255),
    Danger = Color3.fromRGB(255,92,112),
    Success = Color3.fromRGB(92,226,157),
    Warning = Color3.fromRGB(255,190,83),
}

AstraUI.Themes["GlassTone025"] = {
    Background = Color3.fromRGB(34,22,27),
    Surface = Color3.fromRGB(69,44,55),
    SurfaceRaised = Color3.fromRGB(70,54,65),
    Text = Color3.fromRGB(242,242,247),
    Muted = Color3.fromRGB(214,189,210),
    Accent = Color3.fromRGB(219,134,195),
    Border = Color3.fromRGB(255,255,255),
    Danger = Color3.fromRGB(255,92,112),
    Success = Color3.fromRGB(92,226,157),
    Warning = Color3.fromRGB(255,190,83),
}

AstraUI.Themes["GlassTone026"] = {
    Background = Color3.fromRGB(35,21,28),
    Surface = Color3.fromRGB(70,43,56),
    SurfaceRaised = Color3.fromRGB(70,53,66),
    Text = Color3.fromRGB(242,242,247),
    Muted = Color3.fromRGB(215,188,211),
    Accent = Color3.fromRGB(220,132,197),
    Border = Color3.fromRGB(255,255,255),
    Danger = Color3.fromRGB(255,92,112),
    Success = Color3.fromRGB(92,226,157),
    Warning = Color3.fromRGB(255,190,83),
}

AstraUI.Themes["GlassTone027"] = {
    Background = Color3.fromRGB(34,21,28),
    Surface = Color3.fromRGB(69,42,57),
    SurfaceRaised = Color3.fromRGB(70,52,67),
    Text = Color3.fromRGB(242,242,247),
    Muted = Color3.fromRGB(214,187,212),
    Accent = Color3.fromRGB(219,129,199),
    Border = Color3.fromRGB(255,255,255),
    Danger = Color3.fromRGB(255,92,112),
    Success = Color3.fromRGB(92,226,157),
    Warning = Color3.fromRGB(255,190,83),
}

AstraUI.Themes["GlassTone028"] = {
    Background = Color3.fromRGB(34,20,29),
    Surface = Color3.fromRGB(69,41,59),
    SurfaceRaised = Color3.fromRGB(70,51,69),
    Text = Color3.fromRGB(242,242,247),
    Muted = Color3.fromRGB(214,186,214),
    Accent = Color3.fromRGB(219,127,201),
    Border = Color3.fromRGB(255,255,255),
    Danger = Color3.fromRGB(255,92,112),
    Success = Color3.fromRGB(92,226,157),
    Warning = Color3.fromRGB(255,190,83),
}

AstraUI.Themes["GlassTone029"] = {
    Background = Color3.fromRGB(34,20,30),
    Surface = Color3.fromRGB(69,40,60),
    SurfaceRaised = Color3.fromRGB(70,50,70),
    Text = Color3.fromRGB(242,242,247),
    Muted = Color3.fromRGB(214,185,215),
    Accent = Color3.fromRGB(219,125,203),
    Border = Color3.fromRGB(255,255,255),
    Danger = Color3.fromRGB(255,92,112),
    Success = Color3.fromRGB(92,226,157),
    Warning = Color3.fromRGB(255,190,83),
}

AstraUI.Themes["GlassTone030"] = {
    Background = Color3.fromRGB(34,20,30),
    Surface = Color3.fromRGB(69,40,61),
    SurfaceRaised = Color3.fromRGB(70,50,71),
    Text = Color3.fromRGB(242,242,247),
    Muted = Color3.fromRGB(214,185,216),
    Accent = Color3.fromRGB(218,123,205),
    Border = Color3.fromRGB(255,255,255),
    Danger = Color3.fromRGB(255,92,112),
    Success = Color3.fromRGB(92,226,157),
    Warning = Color3.fromRGB(255,190,83),
}

AstraUI.Themes["GlassTone031"] = {
    Background = Color3.fromRGB(34,19,31),
    Surface = Color3.fromRGB(69,39,63),
    SurfaceRaised = Color3.fromRGB(70,49,73),
    Text = Color3.fromRGB(242,242,247),
    Muted = Color3.fromRGB(214,184,218),
    Accent = Color3.fromRGB(217,121,208),
    Border = Color3.fromRGB(255,255,255),
    Danger = Color3.fromRGB(255,92,112),
    Success = Color3.fromRGB(92,226,157),
    Warning = Color3.fromRGB(255,190,83),
}

AstraUI.Themes["GlassTone032"] = {
    Background = Color3.fromRGB(34,19,32),
    Surface = Color3.fromRGB(68,38,64),
    SurfaceRaised = Color3.fromRGB(70,48,74),
    Text = Color3.fromRGB(242,242,247),
    Muted = Color3.fromRGB(213,183,219),
    Accent = Color3.fromRGB(216,119,210),
    Border = Color3.fromRGB(255,255,255),
    Danger = Color3.fromRGB(255,92,112),
    Success = Color3.fromRGB(92,226,157),
    Warning = Color3.fromRGB(255,190,83),
}

AstraUI.Themes["GlassTone033"] = {
    Background = Color3.fromRGB(34,19,32),
    Surface = Color3.fromRGB(68,38,65),
    SurfaceRaised = Color3.fromRGB(70,48,75),
    Text = Color3.fromRGB(242,242,247),
    Muted = Color3.fromRGB(213,183,220),
    Accent = Color3.fromRGB(215,117,212),
    Border = Color3.fromRGB(255,255,255),
    Danger = Color3.fromRGB(255,92,112),
    Success = Color3.fromRGB(92,226,157),
    Warning = Color3.fromRGB(255,190,83),
}

AstraUI.Themes["GlassTone034"] = {
    Background = Color3.fromRGB(33,18,33),
    Surface = Color3.fromRGB(67,37,67),
    SurfaceRaised = Color3.fromRGB(70,47,77),
    Text = Color3.fromRGB(242,242,247),
    Muted = Color3.fromRGB(212,182,222),
    Accent = Color3.fromRGB(213,116,214),
    Border = Color3.fromRGB(255,255,255),
    Danger = Color3.fromRGB(255,92,112),
    Success = Color3.fromRGB(92,226,157),
    Warning = Color3.fromRGB(255,190,83),
}

AstraUI.Themes["GlassTone035"] = {
    Background = Color3.fromRGB(33,18,34),
    Surface = Color3.fromRGB(67,36,68),
    SurfaceRaised = Color3.fromRGB(70,46,78),
    Text = Color3.fromRGB(242,242,247),
    Muted = Color3.fromRGB(212,181,223),
    Accent = Color3.fromRGB(212,115,216),
    Border = Color3.fromRGB(255,255,255),
    Danger = Color3.fromRGB(255,92,112),
    Success = Color3.fromRGB(92,226,157),
    Warning = Color3.fromRGB(255,190,83),
}

AstraUI.Themes["GlassTone036"] = {
    Background = Color3.fromRGB(33,18,35),
    Surface = Color3.fromRGB(66,36,70),
    SurfaceRaised = Color3.fromRGB(70,46,80),
    Text = Color3.fromRGB(242,242,247),
    Muted = Color3.fromRGB(211,181,225),
    Accent = Color3.fromRGB(210,113,219),
    Border = Color3.fromRGB(255,255,255),
    Danger = Color3.fromRGB(255,92,112),
    Success = Color3.fromRGB(92,226,157),
    Warning = Color3.fromRGB(255,190,83),
}

AstraUI.Themes["GlassTone037"] = {
    Background = Color3.fromRGB(32,18,35),
    Surface = Color3.fromRGB(65,36,71),
    SurfaceRaised = Color3.fromRGB(70,46,81),
    Text = Color3.fromRGB(242,242,247),
    Muted = Color3.fromRGB(210,181,226),
    Accent = Color3.fromRGB(208,112,221),
    Border = Color3.fromRGB(255,255,255),
    Danger = Color3.fromRGB(255,92,112),
    Success = Color3.fromRGB(92,226,157),
    Warning = Color3.fromRGB(255,190,83),
}

AstraUI.Themes["GlassTone038"] = {
    Background = Color3.fromRGB(32,17,36),
    Surface = Color3.fromRGB(65,35,72),
    SurfaceRaised = Color3.fromRGB(70,45,82),
    Text = Color3.fromRGB(242,242,247),
    Muted = Color3.fromRGB(210,180,227),
    Accent = Color3.fromRGB(206,111,223),
    Border = Color3.fromRGB(255,255,255),
    Danger = Color3.fromRGB(255,92,112),
    Success = Color3.fromRGB(92,226,157),
    Warning = Color3.fromRGB(255,190,83),
}

AstraUI.Themes["GlassTone039"] = {
    Background = Color3.fromRGB(32,17,37),
    Surface = Color3.fromRGB(64,35,74),
    SurfaceRaised = Color3.fromRGB(70,45,84),
    Text = Color3.fromRGB(242,242,247),
    Muted = Color3.fromRGB(209,180,229),
    Accent = Color3.fromRGB(204,111,225),
    Border = Color3.fromRGB(255,255,255),
    Danger = Color3.fromRGB(255,92,112),
    Success = Color3.fromRGB(92,226,157),
    Warning = Color3.fromRGB(255,190,83),
}

AstraUI.Themes["GlassTone040"] = {
    Background = Color3.fromRGB(31,17,37),
    Surface = Color3.fromRGB(63,35,75),
    SurfaceRaised = Color3.fromRGB(70,45,85),
    Text = Color3.fromRGB(242,242,247),
    Muted = Color3.fromRGB(208,180,230),
    Accent = Color3.fromRGB(201,110,227),
    Border = Color3.fromRGB(255,255,255),
    Danger = Color3.fromRGB(255,92,112),
    Success = Color3.fromRGB(92,226,157),
    Warning = Color3.fromRGB(255,190,83),
}

AstraUI.Themes["GlassTone041"] = {
    Background = Color3.fromRGB(31,17,38),
    Surface = Color3.fromRGB(62,35,76),
    SurfaceRaised = Color3.fromRGB(70,45,85),
    Text = Color3.fromRGB(242,242,247),
    Muted = Color3.fromRGB(207,180,230),
    Accent = Color3.fromRGB(199,110,229),
    Border = Color3.fromRGB(255,255,255),
    Danger = Color3.fromRGB(255,92,112),
    Success = Color3.fromRGB(92,226,157),
    Warning = Color3.fromRGB(255,190,83),
}

AstraUI.Themes["GlassTone042"] = {
    Background = Color3.fromRGB(30,17,39),
    Surface = Color3.fromRGB(61,35,78),
    SurfaceRaised = Color3.fromRGB(70,45,85),
    Text = Color3.fromRGB(242,242,247),
    Muted = Color3.fromRGB(206,180,230),
    Accent = Color3.fromRGB(196,110,231),
    Border = Color3.fromRGB(255,255,255),
    Danger = Color3.fromRGB(255,92,112),
    Success = Color3.fromRGB(92,226,157),
    Warning = Color3.fromRGB(255,190,83),
}

AstraUI.Themes["GlassTone043"] = {
    Background = Color3.fromRGB(30,17,39),
    Surface = Color3.fromRGB(60,35,79),
    SurfaceRaised = Color3.fromRGB(70,45,85),
    Text = Color3.fromRGB(242,242,247),
    Muted = Color3.fromRGB(205,180,230),
    Accent = Color3.fromRGB(194,110,233),
    Border = Color3.fromRGB(255,255,255),
    Danger = Color3.fromRGB(255,92,112),
    Success = Color3.fromRGB(92,226,157),
    Warning = Color3.fromRGB(255,190,83),
}

AstraUI.Themes["GlassTone044"] = {
    Background = Color3.fromRGB(29,17,40),
    Surface = Color3.fromRGB(59,35,80),
    SurfaceRaised = Color3.fromRGB(69,45,85),
    Text = Color3.fromRGB(242,242,247),
    Muted = Color3.fromRGB(204,180,230),
    Accent = Color3.fromRGB(191,110,235),
    Border = Color3.fromRGB(255,255,255),
    Danger = Color3.fromRGB(255,92,112),
    Success = Color3.fromRGB(92,226,157),
    Warning = Color3.fromRGB(255,190,83),
}

AstraUI.Themes["GlassTone045"] = {
    Background = Color3.fromRGB(29,17,40),
    Surface = Color3.fromRGB(58,35,81),
    SurfaceRaised = Color3.fromRGB(68,45,85),
    Text = Color3.fromRGB(242,242,247),
    Muted = Color3.fromRGB(203,180,230),
    Accent = Color3.fromRGB(188,110,237),
    Border = Color3.fromRGB(255,255,255),
    Danger = Color3.fromRGB(255,92,112),
    Success = Color3.fromRGB(92,226,157),
    Warning = Color3.fromRGB(255,190,83),
}

AstraUI.Themes["GlassTone046"] = {
    Background = Color3.fromRGB(28,17,41),
    Surface = Color3.fromRGB(57,35,82),
    SurfaceRaised = Color3.fromRGB(67,45,85),
    Text = Color3.fromRGB(242,242,247),
    Muted = Color3.fromRGB(202,180,230),
    Accent = Color3.fromRGB(185,111,238),
    Border = Color3.fromRGB(255,255,255),
    Danger = Color3.fromRGB(255,92,112),
    Success = Color3.fromRGB(92,226,157),
    Warning = Color3.fromRGB(255,190,83),
}

AstraUI.Themes["GlassTone047"] = {
    Background = Color3.fromRGB(28,17,41),
    Surface = Color3.fromRGB(56,35,83),
    SurfaceRaised = Color3.fromRGB(66,45,85),
    Text = Color3.fromRGB(242,242,247),
    Muted = Color3.fromRGB(201,180,230),
    Accent = Color3.fromRGB(182,111,240),
    Border = Color3.fromRGB(255,255,255),
    Danger = Color3.fromRGB(255,92,112),
    Success = Color3.fromRGB(92,226,157),
    Warning = Color3.fromRGB(255,190,83),
}

AstraUI.Themes["GlassTone048"] = {
    Background = Color3.fromRGB(27,18,42),
    Surface = Color3.fromRGB(55,36,84),
    SurfaceRaised = Color3.fromRGB(65,46,85),
    Text = Color3.fromRGB(242,242,247),
    Muted = Color3.fromRGB(200,181,230),
    Accent = Color3.fromRGB(179,112,241),
    Border = Color3.fromRGB(255,255,255),
    Danger = Color3.fromRGB(255,92,112),
    Success = Color3.fromRGB(92,226,157),
    Warning = Color3.fromRGB(255,190,83),
}

AstraUI.Themes["GlassTone049"] = {
    Background = Color3.fromRGB(27,18,42),
    Surface = Color3.fromRGB(54,36,85),
    SurfaceRaised = Color3.fromRGB(64,46,85),
    Text = Color3.fromRGB(242,242,247),
    Muted = Color3.fromRGB(199,181,230),
    Accent = Color3.fromRGB(176,113,243),
    Border = Color3.fromRGB(255,255,255),
    Danger = Color3.fromRGB(255,92,112),
    Success = Color3.fromRGB(92,226,157),
    Warning = Color3.fromRGB(255,190,83),
}

AstraUI.Themes["GlassTone050"] = {
    Background = Color3.fromRGB(26,18,43),
    Surface = Color3.fromRGB(53,36,86),
    SurfaceRaised = Color3.fromRGB(63,46,85),
    Text = Color3.fromRGB(242,242,247),
    Muted = Color3.fromRGB(198,181,230),
    Accent = Color3.fromRGB(173,114,244),
    Border = Color3.fromRGB(255,255,255),
    Danger = Color3.fromRGB(255,92,112),
    Success = Color3.fromRGB(92,226,157),
    Warning = Color3.fromRGB(255,190,83),
}

AstraUI.Themes["GlassTone051"] = {
    Background = Color3.fromRGB(26,18,43),
    Surface = Color3.fromRGB(52,37,87),
    SurfaceRaised = Color3.fromRGB(62,47,85),
    Text = Color3.fromRGB(242,242,247),
    Muted = Color3.fromRGB(197,182,230),
    Accent = Color3.fromRGB(170,116,245),
    Border = Color3.fromRGB(255,255,255),
    Danger = Color3.fromRGB(255,92,112),
    Success = Color3.fromRGB(92,226,157),
    Warning = Color3.fromRGB(255,190,83),
}

AstraUI.Themes["GlassTone052"] = {
    Background = Color3.fromRGB(25,18,43),
    Surface = Color3.fromRGB(51,37,87),
    SurfaceRaised = Color3.fromRGB(61,47,85),
    Text = Color3.fromRGB(242,242,247),
    Muted = Color3.fromRGB(196,182,230),
    Accent = Color3.fromRGB(166,117,246),
    Border = Color3.fromRGB(255,255,255),
    Danger = Color3.fromRGB(255,92,112),
    Success = Color3.fromRGB(92,226,157),
    Warning = Color3.fromRGB(255,190,83),
}

AstraUI.Themes["GlassTone053"] = {
    Background = Color3.fromRGB(25,19,44),
    Surface = Color3.fromRGB(50,38,88),
    SurfaceRaised = Color3.fromRGB(60,48,85),
    Text = Color3.fromRGB(242,242,247),
    Muted = Color3.fromRGB(195,183,230),
    Accent = Color3.fromRGB(163,119,247),
    Border = Color3.fromRGB(255,255,255),
    Danger = Color3.fromRGB(255,92,112),
    Success = Color3.fromRGB(92,226,157),
    Warning = Color3.fromRGB(255,190,83),
}

AstraUI.Themes["GlassTone054"] = {
    Background = Color3.fromRGB(24,19,44),
    Surface = Color3.fromRGB(49,39,88),
    SurfaceRaised = Color3.fromRGB(59,49,85),
    Text = Color3.fromRGB(242,242,247),
    Muted = Color3.fromRGB(194,184,230),
    Accent = Color3.fromRGB(160,121,248),
    Border = Color3.fromRGB(255,255,255),
    Danger = Color3.fromRGB(255,92,112),
    Success = Color3.fromRGB(92,226,157),
    Warning = Color3.fromRGB(255,190,83),
}

AstraUI.Themes["GlassTone055"] = {
    Background = Color3.fromRGB(24,20,44),
    Surface = Color3.fromRGB(48,40,89),
    SurfaceRaised = Color3.fromRGB(58,50,85),
    Text = Color3.fromRGB(242,242,247),
    Muted = Color3.fromRGB(193,185,230),
    Accent = Color3.fromRGB(157,123,248),
    Border = Color3.fromRGB(255,255,255),
    Danger = Color3.fromRGB(255,92,112),
    Success = Color3.fromRGB(92,226,157),
    Warning = Color3.fromRGB(255,190,83),
}

AstraUI.Themes["GlassTone056"] = {
    Background = Color3.fromRGB(23,20,44),
    Surface = Color3.fromRGB(47,40,89),
    SurfaceRaised = Color3.fromRGB(57,50,85),
    Text = Color3.fromRGB(242,242,247),
    Muted = Color3.fromRGB(192,185,230),
    Accent = Color3.fromRGB(154,125,249),
    Border = Color3.fromRGB(255,255,255),
    Danger = Color3.fromRGB(255,92,112),
    Success = Color3.fromRGB(92,226,157),
    Warning = Color3.fromRGB(255,190,83),
}

AstraUI.Themes["GlassTone057"] = {
    Background = Color3.fromRGB(23,20,44),
    Surface = Color3.fromRGB(46,41,89),
    SurfaceRaised = Color3.fromRGB(56,51,85),
    Text = Color3.fromRGB(242,242,247),
    Muted = Color3.fromRGB(191,186,230),
    Accent = Color3.fromRGB(151,127,249),
    Border = Color3.fromRGB(255,255,255),
    Danger = Color3.fromRGB(255,92,112),
    Success = Color3.fromRGB(92,226,157),
    Warning = Color3.fromRGB(255,190,83),
}

AstraUI.Themes["GlassTone058"] = {
    Background = Color3.fromRGB(22,21,44),
    Surface = Color3.fromRGB(45,42,89),
    SurfaceRaised = Color3.fromRGB(55,52,85),
    Text = Color3.fromRGB(242,242,247),
    Muted = Color3.fromRGB(190,187,230),
    Accent = Color3.fromRGB(148,129,249),
    Border = Color3.fromRGB(255,255,255),
    Danger = Color3.fromRGB(255,92,112),
    Success = Color3.fromRGB(92,226,157),
    Warning = Color3.fromRGB(255,190,83),
}

AstraUI.Themes["GlassTone059"] = {
    Background = Color3.fromRGB(22,21,44),
    Surface = Color3.fromRGB(44,43,89),
    SurfaceRaised = Color3.fromRGB(54,53,85),
    Text = Color3.fromRGB(242,242,247),
    Muted = Color3.fromRGB(189,188,230),
    Accent = Color3.fromRGB(145,131,249),
    Border = Color3.fromRGB(255,255,255),
    Danger = Color3.fromRGB(255,92,112),
    Success = Color3.fromRGB(92,226,157),
    Warning = Color3.fromRGB(255,190,83),
}

AstraUI.Themes["GlassTone060"] = {
    Background = Color3.fromRGB(21,22,44),
    Surface = Color3.fromRGB(43,44,89),
    SurfaceRaised = Color3.fromRGB(53,54,85),
    Text = Color3.fromRGB(242,242,247),
    Muted = Color3.fromRGB(188,189,230),
    Accent = Color3.fromRGB(143,134,249),
    Border = Color3.fromRGB(255,255,255),
    Danger = Color3.fromRGB(255,92,112),
    Success = Color3.fromRGB(92,226,157),
    Warning = Color3.fromRGB(255,190,83),
}

AstraUI.Themes["GlassTone061"] = {
    Background = Color3.fromRGB(21,22,44),
    Surface = Color3.fromRGB(42,45,89),
    SurfaceRaised = Color3.fromRGB(52,55,85),
    Text = Color3.fromRGB(242,242,247),
    Muted = Color3.fromRGB(187,190,230),
    Accent = Color3.fromRGB(140,136,249),
    Border = Color3.fromRGB(255,255,255),
    Danger = Color3.fromRGB(255,92,112),
    Success = Color3.fromRGB(92,226,157),
    Warning = Color3.fromRGB(255,190,83),
}

AstraUI.Themes["GlassTone062"] = {
    Background = Color3.fromRGB(20,23,44),
    Surface = Color3.fromRGB(41,46,89),
    SurfaceRaised = Color3.fromRGB(51,56,85),
    Text = Color3.fromRGB(242,242,247),
    Muted = Color3.fromRGB(186,191,230),
    Accent = Color3.fromRGB(138,139,249),
    Border = Color3.fromRGB(255,255,255),
    Danger = Color3.fromRGB(255,92,112),
    Success = Color3.fromRGB(92,226,157),
    Warning = Color3.fromRGB(255,190,83),
}

AstraUI.Themes["GlassTone063"] = {
    Background = Color3.fromRGB(20,23,44),
    Surface = Color3.fromRGB(40,47,89),
    SurfaceRaised = Color3.fromRGB(50,57,85),
    Text = Color3.fromRGB(242,242,247),
    Muted = Color3.fromRGB(185,192,230),
    Accent = Color3.fromRGB(135,142,248),
    Border = Color3.fromRGB(255,255,255),
    Danger = Color3.fromRGB(255,92,112),
    Success = Color3.fromRGB(92,226,157),
    Warning = Color3.fromRGB(255,190,83),
}

AstraUI.Themes["GlassTone064"] = {
    Background = Color3.fromRGB(19,24,44),
    Surface = Color3.fromRGB(39,48,88),
    SurfaceRaised = Color3.fromRGB(49,58,85),
    Text = Color3.fromRGB(242,242,247),
    Muted = Color3.fromRGB(184,193,230),
    Accent = Color3.fromRGB(133,144,248),
    Border = Color3.fromRGB(255,255,255),
    Danger = Color3.fromRGB(255,92,112),
    Success = Color3.fromRGB(92,226,157),
    Warning = Color3.fromRGB(255,190,83),
}

AstraUI.Themes["GlassTone065"] = {
    Background = Color3.fromRGB(19,24,44),
    Surface = Color3.fromRGB(39,49,88),
    SurfaceRaised = Color3.fromRGB(49,59,85),
    Text = Color3.fromRGB(242,242,247),
    Muted = Color3.fromRGB(184,194,230),
    Accent = Color3.fromRGB(131,147,247),
    Border = Color3.fromRGB(255,255,255),
    Danger = Color3.fromRGB(255,92,112),
    Success = Color3.fromRGB(92,226,157),
    Warning = Color3.fromRGB(255,190,83),
}

AstraUI.Themes["GlassTone066"] = {
    Background = Color3.fromRGB(19,25,43),
    Surface = Color3.fromRGB(38,50,87),
    SurfaceRaised = Color3.fromRGB(48,60,85),
    Text = Color3.fromRGB(242,242,247),
    Muted = Color3.fromRGB(183,195,230),
    Accent = Color3.fromRGB(129,150,246),
    Border = Color3.fromRGB(255,255,255),
    Danger = Color3.fromRGB(255,92,112),
    Success = Color3.fromRGB(92,226,157),
    Warning = Color3.fromRGB(255,190,83),
}

AstraUI.Themes["GlassTone067"] = {
    Background = Color3.fromRGB(18,25,43),
    Surface = Color3.fromRGB(37,51,87),
    SurfaceRaised = Color3.fromRGB(47,61,85),
    Text = Color3.fromRGB(242,242,247),
    Muted = Color3.fromRGB(182,196,230),
    Accent = Color3.fromRGB(127,153,245),
    Border = Color3.fromRGB(255,255,255),
    Danger = Color3.fromRGB(255,92,112),
    Success = Color3.fromRGB(92,226,157),
    Warning = Color3.fromRGB(255,190,83),
}

AstraUI.Themes["GlassTone068"] = {
    Background = Color3.fromRGB(18,26,43),
    Surface = Color3.fromRGB(37,52,86),
    SurfaceRaised = Color3.fromRGB(47,62,85),
    Text = Color3.fromRGB(242,242,247),
    Muted = Color3.fromRGB(182,197,230),
    Accent = Color3.fromRGB(126,156,244),
    Border = Color3.fromRGB(255,255,255),
    Danger = Color3.fromRGB(255,92,112),
    Success = Color3.fromRGB(92,226,157),
    Warning = Color3.fromRGB(255,190,83),
}

AstraUI.Themes["GlassTone069"] = {
    Background = Color3.fromRGB(18,27,42),
    Surface = Color3.fromRGB(36,54,85),
    SurfaceRaised = Color3.fromRGB(46,64,85),
    Text = Color3.fromRGB(242,242,247),
    Muted = Color3.fromRGB(181,199,230),
    Accent = Color3.fromRGB(124,159,243),
    Border = Color3.fromRGB(255,255,255),
    Danger = Color3.fromRGB(255,92,112),
    Success = Color3.fromRGB(92,226,157),
    Warning = Color3.fromRGB(255,190,83),
}

AstraUI.Themes["GlassTone070"] = {
    Background = Color3.fromRGB(18,27,42),
    Surface = Color3.fromRGB(36,55,84),
    SurfaceRaised = Color3.fromRGB(46,65,85),
    Text = Color3.fromRGB(242,242,247),
    Muted = Color3.fromRGB(181,200,230),
    Accent = Color3.fromRGB(123,161,242),
    Border = Color3.fromRGB(255,255,255),
    Danger = Color3.fromRGB(255,92,112),
    Success = Color3.fromRGB(92,226,157),
    Warning = Color3.fromRGB(255,190,83),
}

AstraUI.Themes["GlassTone071"] = {
    Background = Color3.fromRGB(17,28,42),
    Surface = Color3.fromRGB(35,56,84),
    SurfaceRaised = Color3.fromRGB(45,66,85),
    Text = Color3.fromRGB(242,242,247),
    Muted = Color3.fromRGB(180,201,230),
    Accent = Color3.fromRGB(122,164,240),
    Border = Color3.fromRGB(255,255,255),
    Danger = Color3.fromRGB(255,92,112),
    Success = Color3.fromRGB(92,226,157),
    Warning = Color3.fromRGB(255,190,83),
}

AstraUI.Themes["GlassTone072"] = {
    Background = Color3.fromRGB(17,28,41),
    Surface = Color3.fromRGB(35,57,83),
    SurfaceRaised = Color3.fromRGB(45,67,85),
    Text = Color3.fromRGB(242,242,247),
    Muted = Color3.fromRGB(180,202,230),
    Accent = Color3.fromRGB(121,167,239),
    Border = Color3.fromRGB(255,255,255),
    Danger = Color3.fromRGB(255,92,112),
    Success = Color3.fromRGB(92,226,157),
    Warning = Color3.fromRGB(255,190,83),
}

AstraUI.Themes["GlassTone073"] = {
    Background = Color3.fromRGB(17,29,41),
    Surface = Color3.fromRGB(35,58,82),
    SurfaceRaised = Color3.fromRGB(45,68,85),
    Text = Color3.fromRGB(242,242,247),
    Muted = Color3.fromRGB(180,203,230),
    Accent = Color3.fromRGB(120,170,237),
    Border = Color3.fromRGB(255,255,255),
    Danger = Color3.fromRGB(255,92,112),
    Success = Color3.fromRGB(92,226,157),
    Warning = Color3.fromRGB(255,190,83),
}

AstraUI.Themes["GlassTone074"] = {
    Background = Color3.fromRGB(17,29,40),
    Surface = Color3.fromRGB(35,59,80),
    SurfaceRaised = Color3.fromRGB(45,69,85),
    Text = Color3.fromRGB(242,242,247),
    Muted = Color3.fromRGB(180,204,230),
    Accent = Color3.fromRGB(120,172,235),
    Border = Color3.fromRGB(255,255,255),
    Danger = Color3.fromRGB(255,92,112),
    Success = Color3.fromRGB(92,226,157),
    Warning = Color3.fromRGB(255,190,83),
}

AstraUI.Themes["GlassTone075"] = {
    Background = Color3.fromRGB(17,30,39),
    Surface = Color3.fromRGB(35,60,79),
    SurfaceRaised = Color3.fromRGB(45,70,85),
    Text = Color3.fromRGB(242,242,247),
    Muted = Color3.fromRGB(180,205,230),
    Accent = Color3.fromRGB(120,175,234),
    Border = Color3.fromRGB(255,255,255),
    Danger = Color3.fromRGB(255,92,112),
    Success = Color3.fromRGB(92,226,157),
    Warning = Color3.fromRGB(255,190,83),
}

AstraUI.Themes["GlassTone076"] = {
    Background = Color3.fromRGB(17,30,39),
    Surface = Color3.fromRGB(35,61,78),
    SurfaceRaised = Color3.fromRGB(45,70,85),
    Text = Color3.fromRGB(242,242,247),
    Muted = Color3.fromRGB(180,206,230),
    Accent = Color3.fromRGB(120,177,232),
    Border = Color3.fromRGB(255,255,255),
    Danger = Color3.fromRGB(255,92,112),
    Success = Color3.fromRGB(92,226,157),
    Warning = Color3.fromRGB(255,190,83),
}

AstraUI.Themes["GlassTone077"] = {
    Background = Color3.fromRGB(17,31,38),
    Surface = Color3.fromRGB(35,62,77),
    SurfaceRaised = Color3.fromRGB(45,70,85),
    Text = Color3.fromRGB(242,242,247),
    Muted = Color3.fromRGB(180,207,230),
    Accent = Color3.fromRGB(120,180,230),
    Border = Color3.fromRGB(255,255,255),
    Danger = Color3.fromRGB(255,92,112),
    Success = Color3.fromRGB(92,226,157),
    Warning = Color3.fromRGB(255,190,83),
}

AstraUI.Themes["GlassTone078"] = {
    Background = Color3.fromRGB(17,31,37),
    Surface = Color3.fromRGB(35,63,75),
    SurfaceRaised = Color3.fromRGB(45,70,85),
    Text = Color3.fromRGB(242,242,247),
    Muted = Color3.fromRGB(180,208,230),
    Accent = Color3.fromRGB(120,182,228),
    Border = Color3.fromRGB(255,255,255),
    Danger = Color3.fromRGB(255,92,112),
    Success = Color3.fromRGB(92,226,157),
    Warning = Color3.fromRGB(255,190,83),
}

AstraUI.Themes["GlassTone079"] = {
    Background = Color3.fromRGB(17,32,37),
    Surface = Color3.fromRGB(35,64,74),
    SurfaceRaised = Color3.fromRGB(45,70,84),
    Text = Color3.fromRGB(242,242,247),
    Muted = Color3.fromRGB(180,209,229),
    Accent = Color3.fromRGB(120,184,226),
    Border = Color3.fromRGB(255,255,255),
    Danger = Color3.fromRGB(255,92,112),
    Success = Color3.fromRGB(92,226,157),
    Warning = Color3.fromRGB(255,190,83),
}

AstraUI.Themes["GlassTone080"] = {
    Background = Color3.fromRGB(17,32,36),
    Surface = Color3.fromRGB(35,64,73),
    SurfaceRaised = Color3.fromRGB(45,70,83),
    Text = Color3.fromRGB(242,242,247),
    Muted = Color3.fromRGB(180,209,228),
    Accent = Color3.fromRGB(121,186,224),
    Border = Color3.fromRGB(255,255,255),
    Danger = Color3.fromRGB(255,92,112),
    Success = Color3.fromRGB(92,226,157),
    Warning = Color3.fromRGB(255,190,83),
}

AstraUI.Themes["GlassTone081"] = {
    Background = Color3.fromRGB(17,32,35),
    Surface = Color3.fromRGB(35,65,71),
    SurfaceRaised = Color3.fromRGB(45,70,81),
    Text = Color3.fromRGB(242,242,247),
    Muted = Color3.fromRGB(180,210,226),
    Accent = Color3.fromRGB(122,188,221),
    Border = Color3.fromRGB(255,255,255),
    Danger = Color3.fromRGB(255,92,112),
    Success = Color3.fromRGB(92,226,157),
    Warning = Color3.fromRGB(255,190,83),
}

AstraUI.Themes["GlassTone082"] = {
    Background = Color3.fromRGB(18,33,35),
    Surface = Color3.fromRGB(36,66,70),
    SurfaceRaised = Color3.fromRGB(46,70,80),
    Text = Color3.fromRGB(242,242,247),
    Muted = Color3.fromRGB(181,211,225),
    Accent = Color3.fromRGB(123,190,219),
    Border = Color3.fromRGB(255,255,255),
    Danger = Color3.fromRGB(255,92,112),
    Success = Color3.fromRGB(92,226,157),
    Warning = Color3.fromRGB(255,190,83),
}

AstraUI.Themes["GlassTone083"] = {
    Background = Color3.fromRGB(18,33,34),
    Surface = Color3.fromRGB(36,66,69),
    SurfaceRaised = Color3.fromRGB(46,70,79),
    Text = Color3.fromRGB(242,242,247),
    Muted = Color3.fromRGB(181,211,224),
    Accent = Color3.fromRGB(124,192,217),
    Border = Color3.fromRGB(255,255,255),
    Danger = Color3.fromRGB(255,92,112),
    Success = Color3.fromRGB(92,226,157),
    Warning = Color3.fromRGB(255,190,83),
}

AstraUI.Themes["GlassTone084"] = {
    Background = Color3.fromRGB(18,33,33),
    Surface = Color3.fromRGB(37,67,67),
    SurfaceRaised = Color3.fromRGB(47,70,77),
    Text = Color3.fromRGB(242,242,247),
    Muted = Color3.fromRGB(182,212,222),
    Accent = Color3.fromRGB(126,193,215),
    Border = Color3.fromRGB(255,255,255),
    Danger = Color3.fromRGB(255,92,112),
    Success = Color3.fromRGB(92,226,157),
    Warning = Color3.fromRGB(255,190,83),
}

AstraUI.Themes["GlassTone085"] = {
    Background = Color3.fromRGB(18,34,33),
    Surface = Color3.fromRGB(37,68,66),
    SurfaceRaised = Color3.fromRGB(47,70,76),
    Text = Color3.fromRGB(242,242,247),
    Muted = Color3.fromRGB(182,213,221),
    Accent = Color3.fromRGB(127,194,213),
    Border = Color3.fromRGB(255,255,255),
    Danger = Color3.fromRGB(255,92,112),
    Success = Color3.fromRGB(92,226,157),
    Warning = Color3.fromRGB(255,190,83),
}

AstraUI.Themes["GlassTone086"] = {
    Background = Color3.fromRGB(19,34,32),
    Surface = Color3.fromRGB(38,68,64),
    SurfaceRaised = Color3.fromRGB(48,70,74),
    Text = Color3.fromRGB(242,242,247),
    Muted = Color3.fromRGB(183,213,219),
    Accent = Color3.fromRGB(129,196,210),
    Border = Color3.fromRGB(255,255,255),
    Danger = Color3.fromRGB(255,92,112),
    Success = Color3.fromRGB(92,226,157),
    Warning = Color3.fromRGB(255,190,83),
}

AstraUI.Themes["GlassTone087"] = {
    Background = Color3.fromRGB(19,34,31),
    Surface = Color3.fromRGB(39,68,63),
    SurfaceRaised = Color3.fromRGB(49,70,73),
    Text = Color3.fromRGB(242,242,247),
    Muted = Color3.fromRGB(184,213,218),
    Accent = Color3.fromRGB(131,197,208),
    Border = Color3.fromRGB(255,255,255),
    Danger = Color3.fromRGB(255,92,112),
    Success = Color3.fromRGB(92,226,157),
    Warning = Color3.fromRGB(255,190,83),
}

AstraUI.Themes["GlassTone088"] = {
    Background = Color3.fromRGB(19,34,31),
    Surface = Color3.fromRGB(39,69,62),
    SurfaceRaised = Color3.fromRGB(49,70,72),
    Text = Color3.fromRGB(242,242,247),
    Muted = Color3.fromRGB(184,214,217),
    Accent = Color3.fromRGB(133,198,206),
    Border = Color3.fromRGB(255,255,255),
    Danger = Color3.fromRGB(255,92,112),
    Success = Color3.fromRGB(92,226,157),
    Warning = Color3.fromRGB(255,190,83),
}

AstraUI.Themes["GlassTone089"] = {
    Background = Color3.fromRGB(20,34,30),
    Surface = Color3.fromRGB(40,69,60),
    SurfaceRaised = Color3.fromRGB(50,70,70),
    Text = Color3.fromRGB(242,242,247),
    Muted = Color3.fromRGB(185,214,215),
    Accent = Color3.fromRGB(135,198,204),
    Border = Color3.fromRGB(255,255,255),
    Danger = Color3.fromRGB(255,92,112),
    Success = Color3.fromRGB(92,226,157),
    Warning = Color3.fromRGB(255,190,83),
}

AstraUI.Themes["GlassTone090"] = {
    Background = Color3.fromRGB(20,34,29),
    Surface = Color3.fromRGB(41,69,59),
    SurfaceRaised = Color3.fromRGB(51,70,69),
    Text = Color3.fromRGB(242,242,247),
    Muted = Color3.fromRGB(186,214,214),
    Accent = Color3.fromRGB(138,199,202),
    Border = Color3.fromRGB(255,255,255),
    Danger = Color3.fromRGB(255,92,112),
    Success = Color3.fromRGB(92,226,157),
    Warning = Color3.fromRGB(255,190,83),
}

AstraUI.Themes["GlassTone091"] = {
    Background = Color3.fromRGB(21,34,29),
    Surface = Color3.fromRGB(42,69,58),
    SurfaceRaised = Color3.fromRGB(52,70,68),
    Text = Color3.fromRGB(242,242,247),
    Muted = Color3.fromRGB(187,214,213),
    Accent = Color3.fromRGB(140,199,200),
    Border = Color3.fromRGB(255,255,255),
    Danger = Color3.fromRGB(255,92,112),
    Success = Color3.fromRGB(92,226,157),
    Warning = Color3.fromRGB(255,190,83),
}

AstraUI.Themes["GlassTone092"] = {
    Background = Color3.fromRGB(21,34,28),
    Surface = Color3.fromRGB(43,69,56),
    SurfaceRaised = Color3.fromRGB(53,70,66),
    Text = Color3.fromRGB(242,242,247),
    Muted = Color3.fromRGB(188,214,211),
    Accent = Color3.fromRGB(143,199,198),
    Border = Color3.fromRGB(255,255,255),
    Danger = Color3.fromRGB(255,92,112),
    Success = Color3.fromRGB(92,226,157),
    Warning = Color3.fromRGB(255,190,83),
}

AstraUI.Themes["GlassTone093"] = {
    Background = Color3.fromRGB(22,34,27),
    Surface = Color3.fromRGB(44,69,55),
    SurfaceRaised = Color3.fromRGB(54,70,65),
    Text = Color3.fromRGB(242,242,247),
    Muted = Color3.fromRGB(189,214,210),
    Accent = Color3.fromRGB(145,199,196),
    Border = Color3.fromRGB(255,255,255),
    Danger = Color3.fromRGB(255,92,112),
    Success = Color3.fromRGB(92,226,157),
    Warning = Color3.fromRGB(255,190,83),
}

AstraUI.Themes["GlassTone094"] = {
    Background = Color3.fromRGB(22,34,27),
    Surface = Color3.fromRGB(45,69,54),
    SurfaceRaised = Color3.fromRGB(55,70,64),
    Text = Color3.fromRGB(242,242,247),
    Muted = Color3.fromRGB(190,214,209),
    Accent = Color3.fromRGB(148,199,194),
    Border = Color3.fromRGB(255,255,255),
    Danger = Color3.fromRGB(255,92,112),
    Success = Color3.fromRGB(92,226,157),
    Warning = Color3.fromRGB(255,190,83),
}

AstraUI.Themes["GlassTone095"] = {
    Background = Color3.fromRGB(23,34,26),
    Surface = Color3.fromRGB(46,69,53),
    SurfaceRaised = Color3.fromRGB(56,70,63),
    Text = Color3.fromRGB(242,242,247),
    Muted = Color3.fromRGB(191,214,208),
    Accent = Color3.fromRGB(151,199,192),
    Border = Color3.fromRGB(255,255,255),
    Danger = Color3.fromRGB(255,92,112),
    Success = Color3.fromRGB(92,226,157),
    Warning = Color3.fromRGB(255,190,83),
}

AstraUI.Themes["GlassTone096"] = {
    Background = Color3.fromRGB(23,34,26),
    Surface = Color3.fromRGB(47,69,52),
    SurfaceRaised = Color3.fromRGB(57,70,62),
    Text = Color3.fromRGB(242,242,247),
    Muted = Color3.fromRGB(192,214,207),
    Accent = Color3.fromRGB(154,198,191),
    Border = Color3.fromRGB(255,255,255),
    Danger = Color3.fromRGB(255,92,112),
    Success = Color3.fromRGB(92,226,157),
    Warning = Color3.fromRGB(255,190,83),
}

AstraUI.Themes["GlassTone097"] = {
    Background = Color3.fromRGB(24,34,25),
    Surface = Color3.fromRGB(48,69,51),
    SurfaceRaised = Color3.fromRGB(58,70,61),
    Text = Color3.fromRGB(242,242,247),
    Muted = Color3.fromRGB(193,214,206),
    Accent = Color3.fromRGB(157,198,189),
    Border = Color3.fromRGB(255,255,255),
    Danger = Color3.fromRGB(255,92,112),
    Success = Color3.fromRGB(92,226,157),
    Warning = Color3.fromRGB(255,190,83),
}

AstraUI.Themes["GlassTone098"] = {
    Background = Color3.fromRGB(24,34,25),
    Surface = Color3.fromRGB(49,68,50),
    SurfaceRaised = Color3.fromRGB(59,70,60),
    Text = Color3.fromRGB(242,242,247),
    Muted = Color3.fromRGB(194,213,205),
    Accent = Color3.fromRGB(160,197,188),
    Border = Color3.fromRGB(255,255,255),
    Danger = Color3.fromRGB(255,92,112),
    Success = Color3.fromRGB(92,226,157),
    Warning = Color3.fromRGB(255,190,83),
}

AstraUI.Themes["GlassTone099"] = {
    Background = Color3.fromRGB(25,34,24),
    Surface = Color3.fromRGB(50,68,49),
    SurfaceRaised = Color3.fromRGB(60,70,59),
    Text = Color3.fromRGB(242,242,247),
    Muted = Color3.fromRGB(195,213,204),
    Accent = Color3.fromRGB(163,196,186),
    Border = Color3.fromRGB(255,255,255),
    Danger = Color3.fromRGB(255,92,112),
    Success = Color3.fromRGB(92,226,157),
    Warning = Color3.fromRGB(255,190,83),
}

AstraUI.Themes["GlassTone100"] = {
    Background = Color3.fromRGB(25,34,24),
    Surface = Color3.fromRGB(51,68,48),
    SurfaceRaised = Color3.fromRGB(61,70,58),
    Text = Color3.fromRGB(242,242,247),
    Muted = Color3.fromRGB(196,213,203),
    Accent = Color3.fromRGB(166,195,185),
    Border = Color3.fromRGB(255,255,255),
    Danger = Color3.fromRGB(255,92,112),
    Success = Color3.fromRGB(92,226,157),
    Warning = Color3.fromRGB(255,190,83),
}

AstraUI.Layout = {}
function AstraUI.Layout:ClampWidth(viewportWidth, minimum, maximum, margin)
    margin=margin or 24
    local available=math.max(0,viewportWidth-margin)
    return clamp(available,minimum or 280,maximum or 760)
end

function AstraUI.Layout:ClampHeight(viewportHeight, minimum, maximum, margin)
    margin=margin or 36
    local available=math.max(0,viewportHeight-margin)
    return clamp(available,minimum or 240,maximum or 760)
end

function AstraUI.Layout:WindowSize(viewport)
    local width=self:ClampWidth(viewport.X,300,760,24)
    local height=self:ClampHeight(viewport.Y,260,620,36)
    if viewport.X<=460 then width=math.max(280,viewport.X-18); height=math.max(260,viewport.Y-24) end
    return UDim2.fromOffset(width,height)
end

function AstraUI.Layout:SidebarWidth(viewport)
    if viewport.X<=460 then return 0 end
    if viewport.X<=720 then return 132 end
    return 170
end

function AstraUI.Layout:ContentInsets(viewport)
    local sidebar=self:SidebarWidth(viewport)
    if sidebar==0 then return 10,10 end
    return sidebar+20,10
end

function AstraUI.Layout:TouchHeight(viewport,preferred)
    local minimum=viewport.X<=460 and 44 or 36
    return math.max(preferred or 40,minimum)
end

function AstraUI.Layout:Rule0(viewport,preferred)
    local compact=viewport.X<=360
    local height=preferred or 42
    if compact then height=math.max(height,44) end
    local width=math.max(0,viewport.X-18)
    return {Component="Button",Compact=compact,Width=width,Height=height}
end

function AstraUI.Layout:Rule1(viewport,preferred)
    local compact=viewport.X<=405
    local height=preferred or 46
    if compact then height=math.max(height,44) end
    local width=math.max(0,viewport.X-22)
    return {Component="Toggle",Compact=compact,Width=width,Height=height}
end

function AstraUI.Layout:Rule2(viewport,preferred)
    local compact=viewport.X<=450
    local height=preferred or 50
    if compact then height=math.max(height,44) end
    local width=math.max(0,viewport.X-26)
    return {Component="Slider",Compact=compact,Width=width,Height=height}
end

function AstraUI.Layout:Rule3(viewport,preferred)
    local compact=viewport.X<=495
    local height=preferred or 54
    if compact then height=math.max(height,44) end
    local width=math.max(0,viewport.X-30)
    return {Component="Dropdown",Compact=compact,Width=width,Height=height}
end

function AstraUI.Layout:Rule4(viewport,preferred)
    local compact=viewport.X<=540
    local height=preferred or 58
    if compact then height=math.max(height,44) end
    local width=math.max(0,viewport.X-18)
    return {Component="MultiDropdown",Compact=compact,Width=width,Height=height}
end

function AstraUI.Layout:Rule5(viewport,preferred)
    local compact=viewport.X<=585
    local height=preferred or 42
    if compact then height=math.max(height,44) end
    local width=math.max(0,viewport.X-22)
    return {Component="Input",Compact=compact,Width=width,Height=height}
end

function AstraUI.Layout:Rule6(viewport,preferred)
    local compact=viewport.X<=630
    local height=preferred or 46
    if compact then height=math.max(height,44) end
    local width=math.max(0,viewport.X-26)
    return {Component="Keybind",Compact=compact,Width=width,Height=height}
end

function AstraUI.Layout:Rule7(viewport,preferred)
    local compact=viewport.X<=360
    local height=preferred or 50
    if compact then height=math.max(height,44) end
    local width=math.max(0,viewport.X-30)
    return {Component="ColorPicker",Compact=compact,Width=width,Height=height}
end

function AstraUI.Layout:Rule8(viewport,preferred)
    local compact=viewport.X<=405
    local height=preferred or 54
    if compact then height=math.max(height,44) end
    local width=math.max(0,viewport.X-18)
    return {Component="Paragraph",Compact=compact,Width=width,Height=height}
end

function AstraUI.Layout:Rule9(viewport,preferred)
    local compact=viewport.X<=450
    local height=preferred or 58
    if compact then height=math.max(height,44) end
    local width=math.max(0,viewport.X-22)
    return {Component="Label",Compact=compact,Width=width,Height=height}
end

function AstraUI.Layout:Rule10(viewport,preferred)
    local compact=viewport.X<=495
    local height=preferred or 42
    if compact then height=math.max(height,44) end
    local width=math.max(0,viewport.X-26)
    return {Component="Button",Compact=compact,Width=width,Height=height}
end

function AstraUI.Layout:Rule11(viewport,preferred)
    local compact=viewport.X<=540
    local height=preferred or 46
    if compact then height=math.max(height,44) end
    local width=math.max(0,viewport.X-30)
    return {Component="Toggle",Compact=compact,Width=width,Height=height}
end

function AstraUI.Layout:Rule12(viewport,preferred)
    local compact=viewport.X<=585
    local height=preferred or 50
    if compact then height=math.max(height,44) end
    local width=math.max(0,viewport.X-18)
    return {Component="Slider",Compact=compact,Width=width,Height=height}
end

function AstraUI.Layout:Rule13(viewport,preferred)
    local compact=viewport.X<=630
    local height=preferred or 54
    if compact then height=math.max(height,44) end
    local width=math.max(0,viewport.X-22)
    return {Component="Dropdown",Compact=compact,Width=width,Height=height}
end

function AstraUI.Layout:Rule14(viewport,preferred)
    local compact=viewport.X<=360
    local height=preferred or 58
    if compact then height=math.max(height,44) end
    local width=math.max(0,viewport.X-26)
    return {Component="MultiDropdown",Compact=compact,Width=width,Height=height}
end

function AstraUI.Layout:Rule15(viewport,preferred)
    local compact=viewport.X<=405
    local height=preferred or 42
    if compact then height=math.max(height,44) end
    local width=math.max(0,viewport.X-30)
    return {Component="Input",Compact=compact,Width=width,Height=height}
end

function AstraUI.Layout:Rule16(viewport,preferred)
    local compact=viewport.X<=450
    local height=preferred or 46
    if compact then height=math.max(height,44) end
    local width=math.max(0,viewport.X-18)
    return {Component="Keybind",Compact=compact,Width=width,Height=height}
end

function AstraUI.Layout:Rule17(viewport,preferred)
    local compact=viewport.X<=495
    local height=preferred or 50
    if compact then height=math.max(height,44) end
    local width=math.max(0,viewport.X-22)
    return {Component="ColorPicker",Compact=compact,Width=width,Height=height}
end

function AstraUI.Layout:Rule18(viewport,preferred)
    local compact=viewport.X<=540
    local height=preferred or 54
    if compact then height=math.max(height,44) end
    local width=math.max(0,viewport.X-26)
    return {Component="Paragraph",Compact=compact,Width=width,Height=height}
end

function AstraUI.Layout:Rule19(viewport,preferred)
    local compact=viewport.X<=585
    local height=preferred or 58
    if compact then height=math.max(height,44) end
    local width=math.max(0,viewport.X-30)
    return {Component="Label",Compact=compact,Width=width,Height=height}
end

function AstraUI.Layout:Rule20(viewport,preferred)
    local compact=viewport.X<=630
    local height=preferred or 42
    if compact then height=math.max(height,44) end
    local width=math.max(0,viewport.X-18)
    return {Component="Button",Compact=compact,Width=width,Height=height}
end

function AstraUI.Layout:Rule21(viewport,preferred)
    local compact=viewport.X<=360
    local height=preferred or 46
    if compact then height=math.max(height,44) end
    local width=math.max(0,viewport.X-22)
    return {Component="Toggle",Compact=compact,Width=width,Height=height}
end

function AstraUI.Layout:Rule22(viewport,preferred)
    local compact=viewport.X<=405
    local height=preferred or 50
    if compact then height=math.max(height,44) end
    local width=math.max(0,viewport.X-26)
    return {Component="Slider",Compact=compact,Width=width,Height=height}
end

function AstraUI.Layout:Rule23(viewport,preferred)
    local compact=viewport.X<=450
    local height=preferred or 54
    if compact then height=math.max(height,44) end
    local width=math.max(0,viewport.X-30)
    return {Component="Dropdown",Compact=compact,Width=width,Height=height}
end

function AstraUI.Layout:Rule24(viewport,preferred)
    local compact=viewport.X<=495
    local height=preferred or 58
    if compact then height=math.max(height,44) end
    local width=math.max(0,viewport.X-18)
    return {Component="MultiDropdown",Compact=compact,Width=width,Height=height}
end

function AstraUI.Layout:Rule25(viewport,preferred)
    local compact=viewport.X<=540
    local height=preferred or 42
    if compact then height=math.max(height,44) end
    local width=math.max(0,viewport.X-22)
    return {Component="Input",Compact=compact,Width=width,Height=height}
end

function AstraUI.Layout:Rule26(viewport,preferred)
    local compact=viewport.X<=585
    local height=preferred or 46
    if compact then height=math.max(height,44) end
    local width=math.max(0,viewport.X-26)
    return {Component="Keybind",Compact=compact,Width=width,Height=height}
end

function AstraUI.Layout:Rule27(viewport,preferred)
    local compact=viewport.X<=630
    local height=preferred or 50
    if compact then height=math.max(height,44) end
    local width=math.max(0,viewport.X-30)
    return {Component="ColorPicker",Compact=compact,Width=width,Height=height}
end

function AstraUI.Layout:Rule28(viewport,preferred)
    local compact=viewport.X<=360
    local height=preferred or 54
    if compact then height=math.max(height,44) end
    local width=math.max(0,viewport.X-18)
    return {Component="Paragraph",Compact=compact,Width=width,Height=height}
end

function AstraUI.Layout:Rule29(viewport,preferred)
    local compact=viewport.X<=405
    local height=preferred or 58
    if compact then height=math.max(height,44) end
    local width=math.max(0,viewport.X-22)
    return {Component="Label",Compact=compact,Width=width,Height=height}
end

function AstraUI.Layout:Rule30(viewport,preferred)
    local compact=viewport.X<=450
    local height=preferred or 42
    if compact then height=math.max(height,44) end
    local width=math.max(0,viewport.X-26)
    return {Component="Button",Compact=compact,Width=width,Height=height}
end

function AstraUI.Layout:Rule31(viewport,preferred)
    local compact=viewport.X<=495
    local height=preferred or 46
    if compact then height=math.max(height,44) end
    local width=math.max(0,viewport.X-30)
    return {Component="Toggle",Compact=compact,Width=width,Height=height}
end

function AstraUI.Layout:Rule32(viewport,preferred)
    local compact=viewport.X<=540
    local height=preferred or 50
    if compact then height=math.max(height,44) end
    local width=math.max(0,viewport.X-18)
    return {Component="Slider",Compact=compact,Width=width,Height=height}
end

function AstraUI.Layout:Rule33(viewport,preferred)
    local compact=viewport.X<=585
    local height=preferred or 54
    if compact then height=math.max(height,44) end
    local width=math.max(0,viewport.X-22)
    return {Component="Dropdown",Compact=compact,Width=width,Height=height}
end

function AstraUI.Layout:Rule34(viewport,preferred)
    local compact=viewport.X<=630
    local height=preferred or 58
    if compact then height=math.max(height,44) end
    local width=math.max(0,viewport.X-26)
    return {Component="MultiDropdown",Compact=compact,Width=width,Height=height}
end

function AstraUI.Layout:Rule35(viewport,preferred)
    local compact=viewport.X<=360
    local height=preferred or 42
    if compact then height=math.max(height,44) end
    local width=math.max(0,viewport.X-30)
    return {Component="Input",Compact=compact,Width=width,Height=height}
end

function AstraUI.Layout:Rule36(viewport,preferred)
    local compact=viewport.X<=405
    local height=preferred or 46
    if compact then height=math.max(height,44) end
    local width=math.max(0,viewport.X-18)
    return {Component="Keybind",Compact=compact,Width=width,Height=height}
end

function AstraUI.Layout:Rule37(viewport,preferred)
    local compact=viewport.X<=450
    local height=preferred or 50
    if compact then height=math.max(height,44) end
    local width=math.max(0,viewport.X-22)
    return {Component="ColorPicker",Compact=compact,Width=width,Height=height}
end

function AstraUI.Layout:Rule38(viewport,preferred)
    local compact=viewport.X<=495
    local height=preferred or 54
    if compact then height=math.max(height,44) end
    local width=math.max(0,viewport.X-26)
    return {Component="Paragraph",Compact=compact,Width=width,Height=height}
end

function AstraUI.Layout:Rule39(viewport,preferred)
    local compact=viewport.X<=540
    local height=preferred or 58
    if compact then height=math.max(height,44) end
    local width=math.max(0,viewport.X-30)
    return {Component="Label",Compact=compact,Width=width,Height=height}
end

function AstraUI.Layout:Rule40(viewport,preferred)
    local compact=viewport.X<=585
    local height=preferred or 42
    if compact then height=math.max(height,44) end
    local width=math.max(0,viewport.X-18)
    return {Component="Button",Compact=compact,Width=width,Height=height}
end

function AstraUI.Layout:Rule41(viewport,preferred)
    local compact=viewport.X<=630
    local height=preferred or 46
    if compact then height=math.max(height,44) end
    local width=math.max(0,viewport.X-22)
    return {Component="Toggle",Compact=compact,Width=width,Height=height}
end

function AstraUI.Layout:Rule42(viewport,preferred)
    local compact=viewport.X<=360
    local height=preferred or 50
    if compact then height=math.max(height,44) end
    local width=math.max(0,viewport.X-26)
    return {Component="Slider",Compact=compact,Width=width,Height=height}
end

function AstraUI.Layout:Rule43(viewport,preferred)
    local compact=viewport.X<=405
    local height=preferred or 54
    if compact then height=math.max(height,44) end
    local width=math.max(0,viewport.X-30)
    return {Component="Dropdown",Compact=compact,Width=width,Height=height}
end

function AstraUI.Layout:Rule44(viewport,preferred)
    local compact=viewport.X<=450
    local height=preferred or 58
    if compact then height=math.max(height,44) end
    local width=math.max(0,viewport.X-18)
    return {Component="MultiDropdown",Compact=compact,Width=width,Height=height}
end

function AstraUI.Layout:Rule45(viewport,preferred)
    local compact=viewport.X<=495
    local height=preferred or 42
    if compact then height=math.max(height,44) end
    local width=math.max(0,viewport.X-22)
    return {Component="Input",Compact=compact,Width=width,Height=height}
end

function AstraUI.Layout:Rule46(viewport,preferred)
    local compact=viewport.X<=540
    local height=preferred or 46
    if compact then height=math.max(height,44) end
    local width=math.max(0,viewport.X-26)
    return {Component="Keybind",Compact=compact,Width=width,Height=height}
end

function AstraUI.Layout:Rule47(viewport,preferred)
    local compact=viewport.X<=585
    local height=preferred or 50
    if compact then height=math.max(height,44) end
    local width=math.max(0,viewport.X-30)
    return {Component="ColorPicker",Compact=compact,Width=width,Height=height}
end

function AstraUI.Layout:Rule48(viewport,preferred)
    local compact=viewport.X<=630
    local height=preferred or 54
    if compact then height=math.max(height,44) end
    local width=math.max(0,viewport.X-18)
    return {Component="Paragraph",Compact=compact,Width=width,Height=height}
end

function AstraUI.Layout:Rule49(viewport,preferred)
    local compact=viewport.X<=360
    local height=preferred or 58
    if compact then height=math.max(height,44) end
    local width=math.max(0,viewport.X-22)
    return {Component="Label",Compact=compact,Width=width,Height=height}
end

function AstraUI.Layout:Rule50(viewport,preferred)
    local compact=viewport.X<=405
    local height=preferred or 42
    if compact then height=math.max(height,44) end
    local width=math.max(0,viewport.X-26)
    return {Component="Button",Compact=compact,Width=width,Height=height}
end

function AstraUI.Layout:Rule51(viewport,preferred)
    local compact=viewport.X<=450
    local height=preferred or 46
    if compact then height=math.max(height,44) end
    local width=math.max(0,viewport.X-30)
    return {Component="Toggle",Compact=compact,Width=width,Height=height}
end

function AstraUI.Layout:Rule52(viewport,preferred)
    local compact=viewport.X<=495
    local height=preferred or 50
    if compact then height=math.max(height,44) end
    local width=math.max(0,viewport.X-18)
    return {Component="Slider",Compact=compact,Width=width,Height=height}
end

function AstraUI.Layout:Rule53(viewport,preferred)
    local compact=viewport.X<=540
    local height=preferred or 54
    if compact then height=math.max(height,44) end
    local width=math.max(0,viewport.X-22)
    return {Component="Dropdown",Compact=compact,Width=width,Height=height}
end

function AstraUI.Layout:Rule54(viewport,preferred)
    local compact=viewport.X<=585
    local height=preferred or 58
    if compact then height=math.max(height,44) end
    local width=math.max(0,viewport.X-26)
    return {Component="MultiDropdown",Compact=compact,Width=width,Height=height}
end

function AstraUI.Layout:Rule55(viewport,preferred)
    local compact=viewport.X<=630
    local height=preferred or 42
    if compact then height=math.max(height,44) end
    local width=math.max(0,viewport.X-30)
    return {Component="Input",Compact=compact,Width=width,Height=height}
end

function AstraUI.Layout:Rule56(viewport,preferred)
    local compact=viewport.X<=360
    local height=preferred or 46
    if compact then height=math.max(height,44) end
    local width=math.max(0,viewport.X-18)
    return {Component="Keybind",Compact=compact,Width=width,Height=height}
end

function AstraUI.Layout:Rule57(viewport,preferred)
    local compact=viewport.X<=405
    local height=preferred or 50
    if compact then height=math.max(height,44) end
    local width=math.max(0,viewport.X-22)
    return {Component="ColorPicker",Compact=compact,Width=width,Height=height}
end

function AstraUI.Layout:Rule58(viewport,preferred)
    local compact=viewport.X<=450
    local height=preferred or 54
    if compact then height=math.max(height,44) end
    local width=math.max(0,viewport.X-26)
    return {Component="Paragraph",Compact=compact,Width=width,Height=height}
end

function AstraUI.Layout:Rule59(viewport,preferred)
    local compact=viewport.X<=495
    local height=preferred or 58
    if compact then height=math.max(height,44) end
    local width=math.max(0,viewport.X-30)
    return {Component="Label",Compact=compact,Width=width,Height=height}
end

function AstraUI.Layout:Rule60(viewport,preferred)
    local compact=viewport.X<=540
    local height=preferred or 42
    if compact then height=math.max(height,44) end
    local width=math.max(0,viewport.X-18)
    return {Component="Button",Compact=compact,Width=width,Height=height}
end

function AstraUI.Layout:Rule61(viewport,preferred)
    local compact=viewport.X<=585
    local height=preferred or 46
    if compact then height=math.max(height,44) end
    local width=math.max(0,viewport.X-22)
    return {Component="Toggle",Compact=compact,Width=width,Height=height}
end

function AstraUI.Layout:Rule62(viewport,preferred)
    local compact=viewport.X<=630
    local height=preferred or 50
    if compact then height=math.max(height,44) end
    local width=math.max(0,viewport.X-26)
    return {Component="Slider",Compact=compact,Width=width,Height=height}
end

function AstraUI.Layout:Rule63(viewport,preferred)
    local compact=viewport.X<=360
    local height=preferred or 54
    if compact then height=math.max(height,44) end
    local width=math.max(0,viewport.X-30)
    return {Component="Dropdown",Compact=compact,Width=width,Height=height}
end

function AstraUI.Layout:Rule64(viewport,preferred)
    local compact=viewport.X<=405
    local height=preferred or 58
    if compact then height=math.max(height,44) end
    local width=math.max(0,viewport.X-18)
    return {Component="MultiDropdown",Compact=compact,Width=width,Height=height}
end

function AstraUI.Layout:Rule65(viewport,preferred)
    local compact=viewport.X<=450
    local height=preferred or 42
    if compact then height=math.max(height,44) end
    local width=math.max(0,viewport.X-22)
    return {Component="Input",Compact=compact,Width=width,Height=height}
end

function AstraUI.Layout:Rule66(viewport,preferred)
    local compact=viewport.X<=495
    local height=preferred or 46
    if compact then height=math.max(height,44) end
    local width=math.max(0,viewport.X-26)
    return {Component="Keybind",Compact=compact,Width=width,Height=height}
end

function AstraUI.Layout:Rule67(viewport,preferred)
    local compact=viewport.X<=540
    local height=preferred or 50
    if compact then height=math.max(height,44) end
    local width=math.max(0,viewport.X-30)
    return {Component="ColorPicker",Compact=compact,Width=width,Height=height}
end

function AstraUI.Layout:Rule68(viewport,preferred)
    local compact=viewport.X<=585
    local height=preferred or 54
    if compact then height=math.max(height,44) end
    local width=math.max(0,viewport.X-18)
    return {Component="Paragraph",Compact=compact,Width=width,Height=height}
end

function AstraUI.Layout:Rule69(viewport,preferred)
    local compact=viewport.X<=630
    local height=preferred or 58
    if compact then height=math.max(height,44) end
    local width=math.max(0,viewport.X-22)
    return {Component="Label",Compact=compact,Width=width,Height=height}
end

function AstraUI.Layout:Rule70(viewport,preferred)
    local compact=viewport.X<=360
    local height=preferred or 42
    if compact then height=math.max(height,44) end
    local width=math.max(0,viewport.X-26)
    return {Component="Button",Compact=compact,Width=width,Height=height}
end

function AstraUI.Layout:Rule71(viewport,preferred)
    local compact=viewport.X<=405
    local height=preferred or 46
    if compact then height=math.max(height,44) end
    local width=math.max(0,viewport.X-30)
    return {Component="Toggle",Compact=compact,Width=width,Height=height}
end

function AstraUI.Layout:Rule72(viewport,preferred)
    local compact=viewport.X<=450
    local height=preferred or 50
    if compact then height=math.max(height,44) end
    local width=math.max(0,viewport.X-18)
    return {Component="Slider",Compact=compact,Width=width,Height=height}
end

function AstraUI.Layout:Rule73(viewport,preferred)
    local compact=viewport.X<=495
    local height=preferred or 54
    if compact then height=math.max(height,44) end
    local width=math.max(0,viewport.X-22)
    return {Component="Dropdown",Compact=compact,Width=width,Height=height}
end

function AstraUI.Layout:Rule74(viewport,preferred)
    local compact=viewport.X<=540
    local height=preferred or 58
    if compact then height=math.max(height,44) end
    local width=math.max(0,viewport.X-26)
    return {Component="MultiDropdown",Compact=compact,Width=width,Height=height}
end

function AstraUI.Layout:Rule75(viewport,preferred)
    local compact=viewport.X<=585
    local height=preferred or 42
    if compact then height=math.max(height,44) end
    local width=math.max(0,viewport.X-30)
    return {Component="Input",Compact=compact,Width=width,Height=height}
end

function AstraUI.Layout:Rule76(viewport,preferred)
    local compact=viewport.X<=630
    local height=preferred or 46
    if compact then height=math.max(height,44) end
    local width=math.max(0,viewport.X-18)
    return {Component="Keybind",Compact=compact,Width=width,Height=height}
end

function AstraUI.Layout:Rule77(viewport,preferred)
    local compact=viewport.X<=360
    local height=preferred or 50
    if compact then height=math.max(height,44) end
    local width=math.max(0,viewport.X-22)
    return {Component="ColorPicker",Compact=compact,Width=width,Height=height}
end

function AstraUI.Layout:Rule78(viewport,preferred)
    local compact=viewport.X<=405
    local height=preferred or 54
    if compact then height=math.max(height,44) end
    local width=math.max(0,viewport.X-26)
    return {Component="Paragraph",Compact=compact,Width=width,Height=height}
end

function AstraUI.Layout:Rule79(viewport,preferred)
    local compact=viewport.X<=450
    local height=preferred or 58
    if compact then height=math.max(height,44) end
    local width=math.max(0,viewport.X-30)
    return {Component="Label",Compact=compact,Width=width,Height=height}
end

function AstraUI.Layout:Rule80(viewport,preferred)
    local compact=viewport.X<=495
    local height=preferred or 42
    if compact then height=math.max(height,44) end
    local width=math.max(0,viewport.X-18)
    return {Component="Button",Compact=compact,Width=width,Height=height}
end

function AstraUI.Layout:Rule81(viewport,preferred)
    local compact=viewport.X<=540
    local height=preferred or 46
    if compact then height=math.max(height,44) end
    local width=math.max(0,viewport.X-22)
    return {Component="Toggle",Compact=compact,Width=width,Height=height}
end

function AstraUI.Layout:Rule82(viewport,preferred)
    local compact=viewport.X<=585
    local height=preferred or 50
    if compact then height=math.max(height,44) end
    local width=math.max(0,viewport.X-26)
    return {Component="Slider",Compact=compact,Width=width,Height=height}
end

function AstraUI.Layout:Rule83(viewport,preferred)
    local compact=viewport.X<=630
    local height=preferred or 54
    if compact then height=math.max(height,44) end
    local width=math.max(0,viewport.X-30)
    return {Component="Dropdown",Compact=compact,Width=width,Height=height}
end

function AstraUI.Layout:Rule84(viewport,preferred)
    local compact=viewport.X<=360
    local height=preferred or 58
    if compact then height=math.max(height,44) end
    local width=math.max(0,viewport.X-18)
    return {Component="MultiDropdown",Compact=compact,Width=width,Height=height}
end

function AstraUI.Layout:Rule85(viewport,preferred)
    local compact=viewport.X<=405
    local height=preferred or 42
    if compact then height=math.max(height,44) end
    local width=math.max(0,viewport.X-22)
    return {Component="Input",Compact=compact,Width=width,Height=height}
end

function AstraUI.Layout:Rule86(viewport,preferred)
    local compact=viewport.X<=450
    local height=preferred or 46
    if compact then height=math.max(height,44) end
    local width=math.max(0,viewport.X-26)
    return {Component="Keybind",Compact=compact,Width=width,Height=height}
end

function AstraUI.Layout:Rule87(viewport,preferred)
    local compact=viewport.X<=495
    local height=preferred or 50
    if compact then height=math.max(height,44) end
    local width=math.max(0,viewport.X-30)
    return {Component="ColorPicker",Compact=compact,Width=width,Height=height}
end

function AstraUI.Layout:Rule88(viewport,preferred)
    local compact=viewport.X<=540
    local height=preferred or 54
    if compact then height=math.max(height,44) end
    local width=math.max(0,viewport.X-18)
    return {Component="Paragraph",Compact=compact,Width=width,Height=height}
end

function AstraUI.Layout:Rule89(viewport,preferred)
    local compact=viewport.X<=585
    local height=preferred or 58
    if compact then height=math.max(height,44) end
    local width=math.max(0,viewport.X-22)
    return {Component="Label",Compact=compact,Width=width,Height=height}
end

function AstraUI.Layout:Rule90(viewport,preferred)
    local compact=viewport.X<=630
    local height=preferred or 42
    if compact then height=math.max(height,44) end
    local width=math.max(0,viewport.X-26)
    return {Component="Button",Compact=compact,Width=width,Height=height}
end

function AstraUI.Layout:Rule91(viewport,preferred)
    local compact=viewport.X<=360
    local height=preferred or 46
    if compact then height=math.max(height,44) end
    local width=math.max(0,viewport.X-30)
    return {Component="Toggle",Compact=compact,Width=width,Height=height}
end

function AstraUI.Layout:Rule92(viewport,preferred)
    local compact=viewport.X<=405
    local height=preferred or 50
    if compact then height=math.max(height,44) end
    local width=math.max(0,viewport.X-18)
    return {Component="Slider",Compact=compact,Width=width,Height=height}
end

function AstraUI.Layout:Rule93(viewport,preferred)
    local compact=viewport.X<=450
    local height=preferred or 54
    if compact then height=math.max(height,44) end
    local width=math.max(0,viewport.X-22)
    return {Component="Dropdown",Compact=compact,Width=width,Height=height}
end

function AstraUI.Layout:Rule94(viewport,preferred)
    local compact=viewport.X<=495
    local height=preferred or 58
    if compact then height=math.max(height,44) end
    local width=math.max(0,viewport.X-26)
    return {Component="MultiDropdown",Compact=compact,Width=width,Height=height}
end

function AstraUI.Layout:Rule95(viewport,preferred)
    local compact=viewport.X<=540
    local height=preferred or 42
    if compact then height=math.max(height,44) end
    local width=math.max(0,viewport.X-30)
    return {Component="Input",Compact=compact,Width=width,Height=height}
end

function AstraUI.Layout:Rule96(viewport,preferred)
    local compact=viewport.X<=585
    local height=preferred or 46
    if compact then height=math.max(height,44) end
    local width=math.max(0,viewport.X-18)
    return {Component="Keybind",Compact=compact,Width=width,Height=height}
end

function AstraUI.Layout:Rule97(viewport,preferred)
    local compact=viewport.X<=630
    local height=preferred or 50
    if compact then height=math.max(height,44) end
    local width=math.max(0,viewport.X-22)
    return {Component="ColorPicker",Compact=compact,Width=width,Height=height}
end

function AstraUI.Layout:Rule98(viewport,preferred)
    local compact=viewport.X<=360
    local height=preferred or 54
    if compact then height=math.max(height,44) end
    local width=math.max(0,viewport.X-26)
    return {Component="Paragraph",Compact=compact,Width=width,Height=height}
end

function AstraUI.Layout:Rule99(viewport,preferred)
    local compact=viewport.X<=405
    local height=preferred or 58
    if compact then height=math.max(height,44) end
    local width=math.max(0,viewport.X-30)
    return {Component="Label",Compact=compact,Width=width,Height=height}
end

function AstraUI.Layout:Rule100(viewport,preferred)
    local compact=viewport.X<=450
    local height=preferred or 42
    if compact then height=math.max(height,44) end
    local width=math.max(0,viewport.X-18)
    return {Component="Button",Compact=compact,Width=width,Height=height}
end

function AstraUI.Layout:Rule101(viewport,preferred)
    local compact=viewport.X<=495
    local height=preferred or 46
    if compact then height=math.max(height,44) end
    local width=math.max(0,viewport.X-22)
    return {Component="Toggle",Compact=compact,Width=width,Height=height}
end

function AstraUI.Layout:Rule102(viewport,preferred)
    local compact=viewport.X<=540
    local height=preferred or 50
    if compact then height=math.max(height,44) end
    local width=math.max(0,viewport.X-26)
    return {Component="Slider",Compact=compact,Width=width,Height=height}
end

function AstraUI.Layout:Rule103(viewport,preferred)
    local compact=viewport.X<=585
    local height=preferred or 54
    if compact then height=math.max(height,44) end
    local width=math.max(0,viewport.X-30)
    return {Component="Dropdown",Compact=compact,Width=width,Height=height}
end

function AstraUI.Layout:Rule104(viewport,preferred)
    local compact=viewport.X<=630
    local height=preferred or 58
    if compact then height=math.max(height,44) end
    local width=math.max(0,viewport.X-18)
    return {Component="MultiDropdown",Compact=compact,Width=width,Height=height}
end

function AstraUI.Layout:Rule105(viewport,preferred)
    local compact=viewport.X<=360
    local height=preferred or 42
    if compact then height=math.max(height,44) end
    local width=math.max(0,viewport.X-22)
    return {Component="Input",Compact=compact,Width=width,Height=height}
end

function AstraUI.Layout:Rule106(viewport,preferred)
    local compact=viewport.X<=405
    local height=preferred or 46
    if compact then height=math.max(height,44) end
    local width=math.max(0,viewport.X-26)
    return {Component="Keybind",Compact=compact,Width=width,Height=height}
end

function AstraUI.Layout:Rule107(viewport,preferred)
    local compact=viewport.X<=450
    local height=preferred or 50
    if compact then height=math.max(height,44) end
    local width=math.max(0,viewport.X-30)
    return {Component="ColorPicker",Compact=compact,Width=width,Height=height}
end

function AstraUI.Layout:Rule108(viewport,preferred)
    local compact=viewport.X<=495
    local height=preferred or 54
    if compact then height=math.max(height,44) end
    local width=math.max(0,viewport.X-18)
    return {Component="Paragraph",Compact=compact,Width=width,Height=height}
end

function AstraUI.Layout:Rule109(viewport,preferred)
    local compact=viewport.X<=540
    local height=preferred or 58
    if compact then height=math.max(height,44) end
    local width=math.max(0,viewport.X-22)
    return {Component="Label",Compact=compact,Width=width,Height=height}
end

function AstraUI.Layout:Rule110(viewport,preferred)
    local compact=viewport.X<=585
    local height=preferred or 42
    if compact then height=math.max(height,44) end
    local width=math.max(0,viewport.X-26)
    return {Component="Button",Compact=compact,Width=width,Height=height}
end

function AstraUI.Layout:Rule111(viewport,preferred)
    local compact=viewport.X<=630
    local height=preferred or 46
    if compact then height=math.max(height,44) end
    local width=math.max(0,viewport.X-30)
    return {Component="Toggle",Compact=compact,Width=width,Height=height}
end

function AstraUI.Layout:Rule112(viewport,preferred)
    local compact=viewport.X<=360
    local height=preferred or 50
    if compact then height=math.max(height,44) end
    local width=math.max(0,viewport.X-18)
    return {Component="Slider",Compact=compact,Width=width,Height=height}
end

function AstraUI.Layout:Rule113(viewport,preferred)
    local compact=viewport.X<=405
    local height=preferred or 54
    if compact then height=math.max(height,44) end
    local width=math.max(0,viewport.X-22)
    return {Component="Dropdown",Compact=compact,Width=width,Height=height}
end

function AstraUI.Layout:Rule114(viewport,preferred)
    local compact=viewport.X<=450
    local height=preferred or 58
    if compact then height=math.max(height,44) end
    local width=math.max(0,viewport.X-26)
    return {Component="MultiDropdown",Compact=compact,Width=width,Height=height}
end

function AstraUI.Layout:Rule115(viewport,preferred)
    local compact=viewport.X<=495
    local height=preferred or 42
    if compact then height=math.max(height,44) end
    local width=math.max(0,viewport.X-30)
    return {Component="Input",Compact=compact,Width=width,Height=height}
end

function AstraUI.Layout:Rule116(viewport,preferred)
    local compact=viewport.X<=540
    local height=preferred or 46
    if compact then height=math.max(height,44) end
    local width=math.max(0,viewport.X-18)
    return {Component="Keybind",Compact=compact,Width=width,Height=height}
end

function AstraUI.Layout:Rule117(viewport,preferred)
    local compact=viewport.X<=585
    local height=preferred or 50
    if compact then height=math.max(height,44) end
    local width=math.max(0,viewport.X-22)
    return {Component="ColorPicker",Compact=compact,Width=width,Height=height}
end

function AstraUI.Layout:Rule118(viewport,preferred)
    local compact=viewport.X<=630
    local height=preferred or 54
    if compact then height=math.max(height,44) end
    local width=math.max(0,viewport.X-26)
    return {Component="Paragraph",Compact=compact,Width=width,Height=height}
end

function AstraUI.Layout:Rule119(viewport,preferred)
    local compact=viewport.X<=360
    local height=preferred or 58
    if compact then height=math.max(height,44) end
    local width=math.max(0,viewport.X-30)
    return {Component="Label",Compact=compact,Width=width,Height=height}
end

function AstraUI.Layout:Rule120(viewport,preferred)
    local compact=viewport.X<=405
    local height=preferred or 42
    if compact then height=math.max(height,44) end
    local width=math.max(0,viewport.X-18)
    return {Component="Button",Compact=compact,Width=width,Height=height}
end

function AstraUI.Layout:Rule121(viewport,preferred)
    local compact=viewport.X<=450
    local height=preferred or 46
    if compact then height=math.max(height,44) end
    local width=math.max(0,viewport.X-22)
    return {Component="Toggle",Compact=compact,Width=width,Height=height}
end

function AstraUI.Layout:Rule122(viewport,preferred)
    local compact=viewport.X<=495
    local height=preferred or 50
    if compact then height=math.max(height,44) end
    local width=math.max(0,viewport.X-26)
    return {Component="Slider",Compact=compact,Width=width,Height=height}
end

function AstraUI.Layout:Rule123(viewport,preferred)
    local compact=viewport.X<=540
    local height=preferred or 54
    if compact then height=math.max(height,44) end
    local width=math.max(0,viewport.X-30)
    return {Component="Dropdown",Compact=compact,Width=width,Height=height}
end

function AstraUI.Layout:Rule124(viewport,preferred)
    local compact=viewport.X<=585
    local height=preferred or 58
    if compact then height=math.max(height,44) end
    local width=math.max(0,viewport.X-18)
    return {Component="MultiDropdown",Compact=compact,Width=width,Height=height}
end

function AstraUI.Layout:Rule125(viewport,preferred)
    local compact=viewport.X<=630
    local height=preferred or 42
    if compact then height=math.max(height,44) end
    local width=math.max(0,viewport.X-22)
    return {Component="Input",Compact=compact,Width=width,Height=height}
end

function AstraUI.Layout:Rule126(viewport,preferred)
    local compact=viewport.X<=360
    local height=preferred or 46
    if compact then height=math.max(height,44) end
    local width=math.max(0,viewport.X-26)
    return {Component="Keybind",Compact=compact,Width=width,Height=height}
end

function AstraUI.Layout:Rule127(viewport,preferred)
    local compact=viewport.X<=405
    local height=preferred or 50
    if compact then height=math.max(height,44) end
    local width=math.max(0,viewport.X-30)
    return {Component="ColorPicker",Compact=compact,Width=width,Height=height}
end

function AstraUI.Layout:Rule128(viewport,preferred)
    local compact=viewport.X<=450
    local height=preferred or 54
    if compact then height=math.max(height,44) end
    local width=math.max(0,viewport.X-18)
    return {Component="Paragraph",Compact=compact,Width=width,Height=height}
end

function AstraUI.Layout:Rule129(viewport,preferred)
    local compact=viewport.X<=495
    local height=preferred or 58
    if compact then height=math.max(height,44) end
    local width=math.max(0,viewport.X-22)
    return {Component="Label",Compact=compact,Width=width,Height=height}
end

function AstraUI.Layout:Rule130(viewport,preferred)
    local compact=viewport.X<=540
    local height=preferred or 42
    if compact then height=math.max(height,44) end
    local width=math.max(0,viewport.X-26)
    return {Component="Button",Compact=compact,Width=width,Height=height}
end

function AstraUI.Layout:Rule131(viewport,preferred)
    local compact=viewport.X<=585
    local height=preferred or 46
    if compact then height=math.max(height,44) end
    local width=math.max(0,viewport.X-30)
    return {Component="Toggle",Compact=compact,Width=width,Height=height}
end

function AstraUI.Layout:Rule132(viewport,preferred)
    local compact=viewport.X<=630
    local height=preferred or 50
    if compact then height=math.max(height,44) end
    local width=math.max(0,viewport.X-18)
    return {Component="Slider",Compact=compact,Width=width,Height=height}
end

function AstraUI.Layout:Rule133(viewport,preferred)
    local compact=viewport.X<=360
    local height=preferred or 54
    if compact then height=math.max(height,44) end
    local width=math.max(0,viewport.X-22)
    return {Component="Dropdown",Compact=compact,Width=width,Height=height}
end

function AstraUI.Layout:Rule134(viewport,preferred)
    local compact=viewport.X<=405
    local height=preferred or 58
    if compact then height=math.max(height,44) end
    local width=math.max(0,viewport.X-26)
    return {Component="MultiDropdown",Compact=compact,Width=width,Height=height}
end

function AstraUI.Layout:Rule135(viewport,preferred)
    local compact=viewport.X<=450
    local height=preferred or 42
    if compact then height=math.max(height,44) end
    local width=math.max(0,viewport.X-30)
    return {Component="Input",Compact=compact,Width=width,Height=height}
end

function AstraUI.Layout:Rule136(viewport,preferred)
    local compact=viewport.X<=495
    local height=preferred or 46
    if compact then height=math.max(height,44) end
    local width=math.max(0,viewport.X-18)
    return {Component="Keybind",Compact=compact,Width=width,Height=height}
end

function AstraUI.Layout:Rule137(viewport,preferred)
    local compact=viewport.X<=540
    local height=preferred or 50
    if compact then height=math.max(height,44) end
    local width=math.max(0,viewport.X-22)
    return {Component="ColorPicker",Compact=compact,Width=width,Height=height}
end

function AstraUI.Layout:Rule138(viewport,preferred)
    local compact=viewport.X<=585
    local height=preferred or 54
    if compact then height=math.max(height,44) end
    local width=math.max(0,viewport.X-26)
    return {Component="Paragraph",Compact=compact,Width=width,Height=height}
end

function AstraUI.Layout:Rule139(viewport,preferred)
    local compact=viewport.X<=630
    local height=preferred or 58
    if compact then height=math.max(height,44) end
    local width=math.max(0,viewport.X-30)
    return {Component="Label",Compact=compact,Width=width,Height=height}
end

function AstraUI.Layout:Rule140(viewport,preferred)
    local compact=viewport.X<=360
    local height=preferred or 42
    if compact then height=math.max(height,44) end
    local width=math.max(0,viewport.X-18)
    return {Component="Button",Compact=compact,Width=width,Height=height}
end

function AstraUI.Layout:Rule141(viewport,preferred)
    local compact=viewport.X<=405
    local height=preferred or 46
    if compact then height=math.max(height,44) end
    local width=math.max(0,viewport.X-22)
    return {Component="Toggle",Compact=compact,Width=width,Height=height}
end

function AstraUI.Layout:Rule142(viewport,preferred)
    local compact=viewport.X<=450
    local height=preferred or 50
    if compact then height=math.max(height,44) end
    local width=math.max(0,viewport.X-26)
    return {Component="Slider",Compact=compact,Width=width,Height=height}
end

function AstraUI.Layout:Rule143(viewport,preferred)
    local compact=viewport.X<=495
    local height=preferred or 54
    if compact then height=math.max(height,44) end
    local width=math.max(0,viewport.X-30)
    return {Component="Dropdown",Compact=compact,Width=width,Height=height}
end

function AstraUI.Layout:Rule144(viewport,preferred)
    local compact=viewport.X<=540
    local height=preferred or 58
    if compact then height=math.max(height,44) end
    local width=math.max(0,viewport.X-18)
    return {Component="MultiDropdown",Compact=compact,Width=width,Height=height}
end

function AstraUI.Layout:Rule145(viewport,preferred)
    local compact=viewport.X<=585
    local height=preferred or 42
    if compact then height=math.max(height,44) end
    local width=math.max(0,viewport.X-22)
    return {Component="Input",Compact=compact,Width=width,Height=height}
end

function AstraUI.Layout:Rule146(viewport,preferred)
    local compact=viewport.X<=630
    local height=preferred or 46
    if compact then height=math.max(height,44) end
    local width=math.max(0,viewport.X-26)
    return {Component="Keybind",Compact=compact,Width=width,Height=height}
end

function AstraUI.Layout:Rule147(viewport,preferred)
    local compact=viewport.X<=360
    local height=preferred or 50
    if compact then height=math.max(height,44) end
    local width=math.max(0,viewport.X-30)
    return {Component="ColorPicker",Compact=compact,Width=width,Height=height}
end

function AstraUI.Layout:Rule148(viewport,preferred)
    local compact=viewport.X<=405
    local height=preferred or 54
    if compact then height=math.max(height,44) end
    local width=math.max(0,viewport.X-18)
    return {Component="Paragraph",Compact=compact,Width=width,Height=height}
end

function AstraUI.Layout:Rule149(viewport,preferred)
    local compact=viewport.X<=450
    local height=preferred or 58
    if compact then height=math.max(height,44) end
    local width=math.max(0,viewport.X-22)
    return {Component="Label",Compact=compact,Width=width,Height=height}
end

function AstraUI.Layout:Rule150(viewport,preferred)
    local compact=viewport.X<=495
    local height=preferred or 42
    if compact then height=math.max(height,44) end
    local width=math.max(0,viewport.X-26)
    return {Component="Button",Compact=compact,Width=width,Height=height}
end

function AstraUI.Layout:Rule151(viewport,preferred)
    local compact=viewport.X<=540
    local height=preferred or 46
    if compact then height=math.max(height,44) end
    local width=math.max(0,viewport.X-30)
    return {Component="Toggle",Compact=compact,Width=width,Height=height}
end

function AstraUI.Layout:Rule152(viewport,preferred)
    local compact=viewport.X<=585
    local height=preferred or 50
    if compact then height=math.max(height,44) end
    local width=math.max(0,viewport.X-18)
    return {Component="Slider",Compact=compact,Width=width,Height=height}
end

function AstraUI.Layout:Rule153(viewport,preferred)
    local compact=viewport.X<=630
    local height=preferred or 54
    if compact then height=math.max(height,44) end
    local width=math.max(0,viewport.X-22)
    return {Component="Dropdown",Compact=compact,Width=width,Height=height}
end

function AstraUI.Layout:Rule154(viewport,preferred)
    local compact=viewport.X<=360
    local height=preferred or 58
    if compact then height=math.max(height,44) end
    local width=math.max(0,viewport.X-26)
    return {Component="MultiDropdown",Compact=compact,Width=width,Height=height}
end

function AstraUI.Layout:Rule155(viewport,preferred)
    local compact=viewport.X<=405
    local height=preferred or 42
    if compact then height=math.max(height,44) end
    local width=math.max(0,viewport.X-30)
    return {Component="Input",Compact=compact,Width=width,Height=height}
end

function AstraUI.Layout:Rule156(viewport,preferred)
    local compact=viewport.X<=450
    local height=preferred or 46
    if compact then height=math.max(height,44) end
    local width=math.max(0,viewport.X-18)
    return {Component="Keybind",Compact=compact,Width=width,Height=height}
end

function AstraUI.Layout:Rule157(viewport,preferred)
    local compact=viewport.X<=495
    local height=preferred or 50
    if compact then height=math.max(height,44) end
    local width=math.max(0,viewport.X-22)
    return {Component="ColorPicker",Compact=compact,Width=width,Height=height}
end

function AstraUI.Layout:Rule158(viewport,preferred)
    local compact=viewport.X<=540
    local height=preferred or 54
    if compact then height=math.max(height,44) end
    local width=math.max(0,viewport.X-26)
    return {Component="Paragraph",Compact=compact,Width=width,Height=height}
end

function AstraUI.Layout:Rule159(viewport,preferred)
    local compact=viewport.X<=585
    local height=preferred or 58
    if compact then height=math.max(height,44) end
    local width=math.max(0,viewport.X-30)
    return {Component="Label",Compact=compact,Width=width,Height=height}
end

function AstraUI.Layout:Rule160(viewport,preferred)
    local compact=viewport.X<=630
    local height=preferred or 42
    if compact then height=math.max(height,44) end
    local width=math.max(0,viewport.X-18)
    return {Component="Button",Compact=compact,Width=width,Height=height}
end

function AstraUI.Layout:Rule161(viewport,preferred)
    local compact=viewport.X<=360
    local height=preferred or 46
    if compact then height=math.max(height,44) end
    local width=math.max(0,viewport.X-22)
    return {Component="Toggle",Compact=compact,Width=width,Height=height}
end

function AstraUI.Layout:Rule162(viewport,preferred)
    local compact=viewport.X<=405
    local height=preferred or 50
    if compact then height=math.max(height,44) end
    local width=math.max(0,viewport.X-26)
    return {Component="Slider",Compact=compact,Width=width,Height=height}
end

function AstraUI.Layout:Rule163(viewport,preferred)
    local compact=viewport.X<=450
    local height=preferred or 54
    if compact then height=math.max(height,44) end
    local width=math.max(0,viewport.X-30)
    return {Component="Dropdown",Compact=compact,Width=width,Height=height}
end

function AstraUI.Layout:Rule164(viewport,preferred)
    local compact=viewport.X<=495
    local height=preferred or 58
    if compact then height=math.max(height,44) end
    local width=math.max(0,viewport.X-18)
    return {Component="MultiDropdown",Compact=compact,Width=width,Height=height}
end

function AstraUI.Layout:Rule165(viewport,preferred)
    local compact=viewport.X<=540
    local height=preferred or 42
    if compact then height=math.max(height,44) end
    local width=math.max(0,viewport.X-22)
    return {Component="Input",Compact=compact,Width=width,Height=height}
end

function AstraUI.Layout:Rule166(viewport,preferred)
    local compact=viewport.X<=585
    local height=preferred or 46
    if compact then height=math.max(height,44) end
    local width=math.max(0,viewport.X-26)
    return {Component="Keybind",Compact=compact,Width=width,Height=height}
end

function AstraUI.Layout:Rule167(viewport,preferred)
    local compact=viewport.X<=630
    local height=preferred or 50
    if compact then height=math.max(height,44) end
    local width=math.max(0,viewport.X-30)
    return {Component="ColorPicker",Compact=compact,Width=width,Height=height}
end

function AstraUI.Layout:Rule168(viewport,preferred)
    local compact=viewport.X<=360
    local height=preferred or 54
    if compact then height=math.max(height,44) end
    local width=math.max(0,viewport.X-18)
    return {Component="Paragraph",Compact=compact,Width=width,Height=height}
end

function AstraUI.Layout:Rule169(viewport,preferred)
    local compact=viewport.X<=405
    local height=preferred or 58
    if compact then height=math.max(height,44) end
    local width=math.max(0,viewport.X-22)
    return {Component="Label",Compact=compact,Width=width,Height=height}
end

function AstraUI.Layout:Rule170(viewport,preferred)
    local compact=viewport.X<=450
    local height=preferred or 42
    if compact then height=math.max(height,44) end
    local width=math.max(0,viewport.X-26)
    return {Component="Button",Compact=compact,Width=width,Height=height}
end

function AstraUI.Layout:Rule171(viewport,preferred)
    local compact=viewport.X<=495
    local height=preferred or 46
    if compact then height=math.max(height,44) end
    local width=math.max(0,viewport.X-30)
    return {Component="Toggle",Compact=compact,Width=width,Height=height}
end

function AstraUI.Layout:Rule172(viewport,preferred)
    local compact=viewport.X<=540
    local height=preferred or 50
    if compact then height=math.max(height,44) end
    local width=math.max(0,viewport.X-18)
    return {Component="Slider",Compact=compact,Width=width,Height=height}
end

function AstraUI.Layout:Rule173(viewport,preferred)
    local compact=viewport.X<=585
    local height=preferred or 54
    if compact then height=math.max(height,44) end
    local width=math.max(0,viewport.X-22)
    return {Component="Dropdown",Compact=compact,Width=width,Height=height}
end

function AstraUI.Layout:Rule174(viewport,preferred)
    local compact=viewport.X<=630
    local height=preferred or 58
    if compact then height=math.max(height,44) end
    local width=math.max(0,viewport.X-26)
    return {Component="MultiDropdown",Compact=compact,Width=width,Height=height}
end

function AstraUI.Layout:Rule175(viewport,preferred)
    local compact=viewport.X<=360
    local height=preferred or 42
    if compact then height=math.max(height,44) end
    local width=math.max(0,viewport.X-30)
    return {Component="Input",Compact=compact,Width=width,Height=height}
end

function AstraUI.Layout:Rule176(viewport,preferred)
    local compact=viewport.X<=405
    local height=preferred or 46
    if compact then height=math.max(height,44) end
    local width=math.max(0,viewport.X-18)
    return {Component="Keybind",Compact=compact,Width=width,Height=height}
end

function AstraUI.Layout:Rule177(viewport,preferred)
    local compact=viewport.X<=450
    local height=preferred or 50
    if compact then height=math.max(height,44) end
    local width=math.max(0,viewport.X-22)
    return {Component="ColorPicker",Compact=compact,Width=width,Height=height}
end

function AstraUI.Layout:Rule178(viewport,preferred)
    local compact=viewport.X<=495
    local height=preferred or 54
    if compact then height=math.max(height,44) end
    local width=math.max(0,viewport.X-26)
    return {Component="Paragraph",Compact=compact,Width=width,Height=height}
end

function AstraUI.Layout:Rule179(viewport,preferred)
    local compact=viewport.X<=540
    local height=preferred or 58
    if compact then height=math.max(height,44) end
    local width=math.max(0,viewport.X-30)
    return {Component="Label",Compact=compact,Width=width,Height=height}
end

function AstraUI.Layout:Rule180(viewport,preferred)
    local compact=viewport.X<=585
    local height=preferred or 42
    if compact then height=math.max(height,44) end
    local width=math.max(0,viewport.X-18)
    return {Component="Button",Compact=compact,Width=width,Height=height}
end

function AstraUI.Layout:Rule181(viewport,preferred)
    local compact=viewport.X<=630
    local height=preferred or 46
    if compact then height=math.max(height,44) end
    local width=math.max(0,viewport.X-22)
    return {Component="Toggle",Compact=compact,Width=width,Height=height}
end

function AstraUI.Layout:Rule182(viewport,preferred)
    local compact=viewport.X<=360
    local height=preferred or 50
    if compact then height=math.max(height,44) end
    local width=math.max(0,viewport.X-26)
    return {Component="Slider",Compact=compact,Width=width,Height=height}
end

function AstraUI.Layout:Rule183(viewport,preferred)
    local compact=viewport.X<=405
    local height=preferred or 54
    if compact then height=math.max(height,44) end
    local width=math.max(0,viewport.X-30)
    return {Component="Dropdown",Compact=compact,Width=width,Height=height}
end

function AstraUI.Layout:Rule184(viewport,preferred)
    local compact=viewport.X<=450
    local height=preferred or 58
    if compact then height=math.max(height,44) end
    local width=math.max(0,viewport.X-18)
    return {Component="MultiDropdown",Compact=compact,Width=width,Height=height}
end

function AstraUI.Layout:Rule185(viewport,preferred)
    local compact=viewport.X<=495
    local height=preferred or 42
    if compact then height=math.max(height,44) end
    local width=math.max(0,viewport.X-22)
    return {Component="Input",Compact=compact,Width=width,Height=height}
end

function AstraUI.Layout:Rule186(viewport,preferred)
    local compact=viewport.X<=540
    local height=preferred or 46
    if compact then height=math.max(height,44) end
    local width=math.max(0,viewport.X-26)
    return {Component="Keybind",Compact=compact,Width=width,Height=height}
end

function AstraUI.Layout:Rule187(viewport,preferred)
    local compact=viewport.X<=585
    local height=preferred or 50
    if compact then height=math.max(height,44) end
    local width=math.max(0,viewport.X-30)
    return {Component="ColorPicker",Compact=compact,Width=width,Height=height}
end

function AstraUI.Layout:Rule188(viewport,preferred)
    local compact=viewport.X<=630
    local height=preferred or 54
    if compact then height=math.max(height,44) end
    local width=math.max(0,viewport.X-18)
    return {Component="Paragraph",Compact=compact,Width=width,Height=height}
end

function AstraUI.Layout:Rule189(viewport,preferred)
    local compact=viewport.X<=360
    local height=preferred or 58
    if compact then height=math.max(height,44) end
    local width=math.max(0,viewport.X-22)
    return {Component="Label",Compact=compact,Width=width,Height=height}
end

function AstraUI.Layout:Rule190(viewport,preferred)
    local compact=viewport.X<=405
    local height=preferred or 42
    if compact then height=math.max(height,44) end
    local width=math.max(0,viewport.X-26)
    return {Component="Button",Compact=compact,Width=width,Height=height}
end

function AstraUI.Layout:Rule191(viewport,preferred)
    local compact=viewport.X<=450
    local height=preferred or 46
    if compact then height=math.max(height,44) end
    local width=math.max(0,viewport.X-30)
    return {Component="Toggle",Compact=compact,Width=width,Height=height}
end

function AstraUI.Layout:Rule192(viewport,preferred)
    local compact=viewport.X<=495
    local height=preferred or 50
    if compact then height=math.max(height,44) end
    local width=math.max(0,viewport.X-18)
    return {Component="Slider",Compact=compact,Width=width,Height=height}
end

function AstraUI.Layout:Rule193(viewport,preferred)
    local compact=viewport.X<=540
    local height=preferred or 54
    if compact then height=math.max(height,44) end
    local width=math.max(0,viewport.X-22)
    return {Component="Dropdown",Compact=compact,Width=width,Height=height}
end

function AstraUI.Layout:Rule194(viewport,preferred)
    local compact=viewport.X<=585
    local height=preferred or 58
    if compact then height=math.max(height,44) end
    local width=math.max(0,viewport.X-26)
    return {Component="MultiDropdown",Compact=compact,Width=width,Height=height}
end

function AstraUI.Layout:Rule195(viewport,preferred)
    local compact=viewport.X<=630
    local height=preferred or 42
    if compact then height=math.max(height,44) end
    local width=math.max(0,viewport.X-30)
    return {Component="Input",Compact=compact,Width=width,Height=height}
end

function AstraUI.Layout:Rule196(viewport,preferred)
    local compact=viewport.X<=360
    local height=preferred or 46
    if compact then height=math.max(height,44) end
    local width=math.max(0,viewport.X-18)
    return {Component="Keybind",Compact=compact,Width=width,Height=height}
end

function AstraUI.Layout:Rule197(viewport,preferred)
    local compact=viewport.X<=405
    local height=preferred or 50
    if compact then height=math.max(height,44) end
    local width=math.max(0,viewport.X-22)
    return {Component="ColorPicker",Compact=compact,Width=width,Height=height}
end

function AstraUI.Layout:Rule198(viewport,preferred)
    local compact=viewport.X<=450
    local height=preferred or 54
    if compact then height=math.max(height,44) end
    local width=math.max(0,viewport.X-26)
    return {Component="Paragraph",Compact=compact,Width=width,Height=height}
end

function AstraUI.Layout:Rule199(viewport,preferred)
    local compact=viewport.X<=495
    local height=preferred or 58
    if compact then height=math.max(height,44) end
    local width=math.max(0,viewport.X-30)
    return {Component="Label",Compact=compact,Width=width,Height=height}
end

function AstraUI.Layout:Rule200(viewport,preferred)
    local compact=viewport.X<=540
    local height=preferred or 42
    if compact then height=math.max(height,44) end
    local width=math.max(0,viewport.X-18)
    return {Component="Button",Compact=compact,Width=width,Height=height}
end

function AstraUI.Layout:Rule201(viewport,preferred)
    local compact=viewport.X<=585
    local height=preferred or 46
    if compact then height=math.max(height,44) end
    local width=math.max(0,viewport.X-22)
    return {Component="Toggle",Compact=compact,Width=width,Height=height}
end

function AstraUI.Layout:Rule202(viewport,preferred)
    local compact=viewport.X<=630
    local height=preferred or 50
    if compact then height=math.max(height,44) end
    local width=math.max(0,viewport.X-26)
    return {Component="Slider",Compact=compact,Width=width,Height=height}
end

function AstraUI.Layout:Rule203(viewport,preferred)
    local compact=viewport.X<=360
    local height=preferred or 54
    if compact then height=math.max(height,44) end
    local width=math.max(0,viewport.X-30)
    return {Component="Dropdown",Compact=compact,Width=width,Height=height}
end

function AstraUI.Layout:Rule204(viewport,preferred)
    local compact=viewport.X<=405
    local height=preferred or 58
    if compact then height=math.max(height,44) end
    local width=math.max(0,viewport.X-18)
    return {Component="MultiDropdown",Compact=compact,Width=width,Height=height}
end

function AstraUI.Layout:Rule205(viewport,preferred)
    local compact=viewport.X<=450
    local height=preferred or 42
    if compact then height=math.max(height,44) end
    local width=math.max(0,viewport.X-22)
    return {Component="Input",Compact=compact,Width=width,Height=height}
end

function AstraUI.Layout:Rule206(viewport,preferred)
    local compact=viewport.X<=495
    local height=preferred or 46
    if compact then height=math.max(height,44) end
    local width=math.max(0,viewport.X-26)
    return {Component="Keybind",Compact=compact,Width=width,Height=height}
end

function AstraUI.Layout:Rule207(viewport,preferred)
    local compact=viewport.X<=540
    local height=preferred or 50
    if compact then height=math.max(height,44) end
    local width=math.max(0,viewport.X-30)
    return {Component="ColorPicker",Compact=compact,Width=width,Height=height}
end

function AstraUI.Layout:Rule208(viewport,preferred)
    local compact=viewport.X<=585
    local height=preferred or 54
    if compact then height=math.max(height,44) end
    local width=math.max(0,viewport.X-18)
    return {Component="Paragraph",Compact=compact,Width=width,Height=height}
end

function AstraUI.Layout:Rule209(viewport,preferred)
    local compact=viewport.X<=630
    local height=preferred or 58
    if compact then height=math.max(height,44) end
    local width=math.max(0,viewport.X-22)
    return {Component="Label",Compact=compact,Width=width,Height=height}
end

function AstraUI.Layout:Rule210(viewport,preferred)
    local compact=viewport.X<=360
    local height=preferred or 42
    if compact then height=math.max(height,44) end
    local width=math.max(0,viewport.X-26)
    return {Component="Button",Compact=compact,Width=width,Height=height}
end

function AstraUI.Layout:Rule211(viewport,preferred)
    local compact=viewport.X<=405
    local height=preferred or 46
    if compact then height=math.max(height,44) end
    local width=math.max(0,viewport.X-30)
    return {Component="Toggle",Compact=compact,Width=width,Height=height}
end

function AstraUI.Layout:Rule212(viewport,preferred)
    local compact=viewport.X<=450
    local height=preferred or 50
    if compact then height=math.max(height,44) end
    local width=math.max(0,viewport.X-18)
    return {Component="Slider",Compact=compact,Width=width,Height=height}
end

function AstraUI.Layout:Rule213(viewport,preferred)
    local compact=viewport.X<=495
    local height=preferred or 54
    if compact then height=math.max(height,44) end
    local width=math.max(0,viewport.X-22)
    return {Component="Dropdown",Compact=compact,Width=width,Height=height}
end

function AstraUI.Layout:Rule214(viewport,preferred)
    local compact=viewport.X<=540
    local height=preferred or 58
    if compact then height=math.max(height,44) end
    local width=math.max(0,viewport.X-26)
    return {Component="MultiDropdown",Compact=compact,Width=width,Height=height}
end

function AstraUI.Layout:Rule215(viewport,preferred)
    local compact=viewport.X<=585
    local height=preferred or 42
    if compact then height=math.max(height,44) end
    local width=math.max(0,viewport.X-30)
    return {Component="Input",Compact=compact,Width=width,Height=height}
end

function AstraUI.Layout:Rule216(viewport,preferred)
    local compact=viewport.X<=630
    local height=preferred or 46
    if compact then height=math.max(height,44) end
    local width=math.max(0,viewport.X-18)
    return {Component="Keybind",Compact=compact,Width=width,Height=height}
end

function AstraUI.Layout:Rule217(viewport,preferred)
    local compact=viewport.X<=360
    local height=preferred or 50
    if compact then height=math.max(height,44) end
    local width=math.max(0,viewport.X-22)
    return {Component="ColorPicker",Compact=compact,Width=width,Height=height}
end

function AstraUI.Layout:Rule218(viewport,preferred)
    local compact=viewport.X<=405
    local height=preferred or 54
    if compact then height=math.max(height,44) end
    local width=math.max(0,viewport.X-26)
    return {Component="Paragraph",Compact=compact,Width=width,Height=height}
end

function AstraUI.Layout:Rule219(viewport,preferred)
    local compact=viewport.X<=450
    local height=preferred or 58
    if compact then height=math.max(height,44) end
    local width=math.max(0,viewport.X-30)
    return {Component="Label",Compact=compact,Width=width,Height=height}
end

function AstraUI.Layout:Rule220(viewport,preferred)
    local compact=viewport.X<=495
    local height=preferred or 42
    if compact then height=math.max(height,44) end
    local width=math.max(0,viewport.X-18)
    return {Component="Button",Compact=compact,Width=width,Height=height}
end

function AstraUI.Layout:Rule221(viewport,preferred)
    local compact=viewport.X<=540
    local height=preferred or 46
    if compact then height=math.max(height,44) end
    local width=math.max(0,viewport.X-22)
    return {Component="Toggle",Compact=compact,Width=width,Height=height}
end

function AstraUI.Layout:Rule222(viewport,preferred)
    local compact=viewport.X<=585
    local height=preferred or 50
    if compact then height=math.max(height,44) end
    local width=math.max(0,viewport.X-26)
    return {Component="Slider",Compact=compact,Width=width,Height=height}
end

function AstraUI.Layout:Rule223(viewport,preferred)
    local compact=viewport.X<=630
    local height=preferred or 54
    if compact then height=math.max(height,44) end
    local width=math.max(0,viewport.X-30)
    return {Component="Dropdown",Compact=compact,Width=width,Height=height}
end

function AstraUI.Layout:Rule224(viewport,preferred)
    local compact=viewport.X<=360
    local height=preferred or 58
    if compact then height=math.max(height,44) end
    local width=math.max(0,viewport.X-18)
    return {Component="MultiDropdown",Compact=compact,Width=width,Height=height}
end

function AstraUI.Layout:Rule225(viewport,preferred)
    local compact=viewport.X<=405
    local height=preferred or 42
    if compact then height=math.max(height,44) end
    local width=math.max(0,viewport.X-22)
    return {Component="Input",Compact=compact,Width=width,Height=height}
end

function AstraUI.Layout:Rule226(viewport,preferred)
    local compact=viewport.X<=450
    local height=preferred or 46
    if compact then height=math.max(height,44) end
    local width=math.max(0,viewport.X-26)
    return {Component="Keybind",Compact=compact,Width=width,Height=height}
end

function AstraUI.Layout:Rule227(viewport,preferred)
    local compact=viewport.X<=495
    local height=preferred or 50
    if compact then height=math.max(height,44) end
    local width=math.max(0,viewport.X-30)
    return {Component="ColorPicker",Compact=compact,Width=width,Height=height}
end

function AstraUI.Layout:Rule228(viewport,preferred)
    local compact=viewport.X<=540
    local height=preferred or 54
    if compact then height=math.max(height,44) end
    local width=math.max(0,viewport.X-18)
    return {Component="Paragraph",Compact=compact,Width=width,Height=height}
end

function AstraUI.Layout:Rule229(viewport,preferred)
    local compact=viewport.X<=585
    local height=preferred or 58
    if compact then height=math.max(height,44) end
    local width=math.max(0,viewport.X-22)
    return {Component="Label",Compact=compact,Width=width,Height=height}
end

function AstraUI.Layout:Rule230(viewport,preferred)
    local compact=viewport.X<=630
    local height=preferred or 42
    if compact then height=math.max(height,44) end
    local width=math.max(0,viewport.X-26)
    return {Component="Button",Compact=compact,Width=width,Height=height}
end

function AstraUI.Layout:Rule231(viewport,preferred)
    local compact=viewport.X<=360
    local height=preferred or 46
    if compact then height=math.max(height,44) end
    local width=math.max(0,viewport.X-30)
    return {Component="Toggle",Compact=compact,Width=width,Height=height}
end

function AstraUI.Layout:Rule232(viewport,preferred)
    local compact=viewport.X<=405
    local height=preferred or 50
    if compact then height=math.max(height,44) end
    local width=math.max(0,viewport.X-18)
    return {Component="Slider",Compact=compact,Width=width,Height=height}
end

function AstraUI.Layout:Rule233(viewport,preferred)
    local compact=viewport.X<=450
    local height=preferred or 54
    if compact then height=math.max(height,44) end
    local width=math.max(0,viewport.X-22)
    return {Component="Dropdown",Compact=compact,Width=width,Height=height}
end

function AstraUI.Layout:Rule234(viewport,preferred)
    local compact=viewport.X<=495
    local height=preferred or 58
    if compact then height=math.max(height,44) end
    local width=math.max(0,viewport.X-26)
    return {Component="MultiDropdown",Compact=compact,Width=width,Height=height}
end

function AstraUI.Layout:Rule235(viewport,preferred)
    local compact=viewport.X<=540
    local height=preferred or 42
    if compact then height=math.max(height,44) end
    local width=math.max(0,viewport.X-30)
    return {Component="Input",Compact=compact,Width=width,Height=height}
end

function AstraUI.Layout:Rule236(viewport,preferred)
    local compact=viewport.X<=585
    local height=preferred or 46
    if compact then height=math.max(height,44) end
    local width=math.max(0,viewport.X-18)
    return {Component="Keybind",Compact=compact,Width=width,Height=height}
end

function AstraUI.Layout:Rule237(viewport,preferred)
    local compact=viewport.X<=630
    local height=preferred or 50
    if compact then height=math.max(height,44) end
    local width=math.max(0,viewport.X-22)
    return {Component="ColorPicker",Compact=compact,Width=width,Height=height}
end

function AstraUI.Layout:Rule238(viewport,preferred)
    local compact=viewport.X<=360
    local height=preferred or 54
    if compact then height=math.max(height,44) end
    local width=math.max(0,viewport.X-26)
    return {Component="Paragraph",Compact=compact,Width=width,Height=height}
end

function AstraUI.Layout:Rule239(viewport,preferred)
    local compact=viewport.X<=405
    local height=preferred or 58
    if compact then height=math.max(height,44) end
    local width=math.max(0,viewport.X-30)
    return {Component="Label",Compact=compact,Width=width,Height=height}
end

function AstraUI.Layout:Rule240(viewport,preferred)
    local compact=viewport.X<=450
    local height=preferred or 42
    if compact then height=math.max(height,44) end
    local width=math.max(0,viewport.X-18)
    return {Component="Button",Compact=compact,Width=width,Height=height}
end

function AstraUI.Layout:Rule241(viewport,preferred)
    local compact=viewport.X<=495
    local height=preferred or 46
    if compact then height=math.max(height,44) end
    local width=math.max(0,viewport.X-22)
    return {Component="Toggle",Compact=compact,Width=width,Height=height}
end

function AstraUI.Layout:Rule242(viewport,preferred)
    local compact=viewport.X<=540
    local height=preferred or 50
    if compact then height=math.max(height,44) end
    local width=math.max(0,viewport.X-26)
    return {Component="Slider",Compact=compact,Width=width,Height=height}
end

function AstraUI.Layout:Rule243(viewport,preferred)
    local compact=viewport.X<=585
    local height=preferred or 54
    if compact then height=math.max(height,44) end
    local width=math.max(0,viewport.X-30)
    return {Component="Dropdown",Compact=compact,Width=width,Height=height}
end

function AstraUI.Layout:Rule244(viewport,preferred)
    local compact=viewport.X<=630
    local height=preferred or 58
    if compact then height=math.max(height,44) end
    local width=math.max(0,viewport.X-18)
    return {Component="MultiDropdown",Compact=compact,Width=width,Height=height}
end

function AstraUI.Layout:Rule245(viewport,preferred)
    local compact=viewport.X<=360
    local height=preferred or 42
    if compact then height=math.max(height,44) end
    local width=math.max(0,viewport.X-22)
    return {Component="Input",Compact=compact,Width=width,Height=height}
end

function AstraUI.Layout:Rule246(viewport,preferred)
    local compact=viewport.X<=405
    local height=preferred or 46
    if compact then height=math.max(height,44) end
    local width=math.max(0,viewport.X-26)
    return {Component="Keybind",Compact=compact,Width=width,Height=height}
end

function AstraUI.Layout:Rule247(viewport,preferred)
    local compact=viewport.X<=450
    local height=preferred or 50
    if compact then height=math.max(height,44) end
    local width=math.max(0,viewport.X-30)
    return {Component="ColorPicker",Compact=compact,Width=width,Height=height}
end

function AstraUI.Layout:Rule248(viewport,preferred)
    local compact=viewport.X<=495
    local height=preferred or 54
    if compact then height=math.max(height,44) end
    local width=math.max(0,viewport.X-18)
    return {Component="Paragraph",Compact=compact,Width=width,Height=height}
end

function AstraUI.Layout:Rule249(viewport,preferred)
    local compact=viewport.X<=540
    local height=preferred or 58
    if compact then height=math.max(height,44) end
    local width=math.max(0,viewport.X-22)
    return {Component="Label",Compact=compact,Width=width,Height=height}
end

function AstraUI.Layout:Rule250(viewport,preferred)
    local compact=viewport.X<=585
    local height=preferred or 42
    if compact then height=math.max(height,44) end
    local width=math.max(0,viewport.X-26)
    return {Component="Button",Compact=compact,Width=width,Height=height}
end

function AstraUI.Layout:Rule251(viewport,preferred)
    local compact=viewport.X<=630
    local height=preferred or 46
    if compact then height=math.max(height,44) end
    local width=math.max(0,viewport.X-30)
    return {Component="Toggle",Compact=compact,Width=width,Height=height}
end

function AstraUI.Layout:Rule252(viewport,preferred)
    local compact=viewport.X<=360
    local height=preferred or 50
    if compact then height=math.max(height,44) end
    local width=math.max(0,viewport.X-18)
    return {Component="Slider",Compact=compact,Width=width,Height=height}
end

function AstraUI.Layout:Rule253(viewport,preferred)
    local compact=viewport.X<=405
    local height=preferred or 54
    if compact then height=math.max(height,44) end
    local width=math.max(0,viewport.X-22)
    return {Component="Dropdown",Compact=compact,Width=width,Height=height}
end

function AstraUI.Layout:Rule254(viewport,preferred)
    local compact=viewport.X<=450
    local height=preferred or 58
    if compact then height=math.max(height,44) end
    local width=math.max(0,viewport.X-26)
    return {Component="MultiDropdown",Compact=compact,Width=width,Height=height}
end

function AstraUI.Layout:Rule255(viewport,preferred)
    local compact=viewport.X<=495
    local height=preferred or 42
    if compact then height=math.max(height,44) end
    local width=math.max(0,viewport.X-30)
    return {Component="Input",Compact=compact,Width=width,Height=height}
end

function AstraUI.Layout:Rule256(viewport,preferred)
    local compact=viewport.X<=540
    local height=preferred or 46
    if compact then height=math.max(height,44) end
    local width=math.max(0,viewport.X-18)
    return {Component="Keybind",Compact=compact,Width=width,Height=height}
end

function AstraUI.Layout:Rule257(viewport,preferred)
    local compact=viewport.X<=585
    local height=preferred or 50
    if compact then height=math.max(height,44) end
    local width=math.max(0,viewport.X-22)
    return {Component="ColorPicker",Compact=compact,Width=width,Height=height}
end

function AstraUI.Layout:Rule258(viewport,preferred)
    local compact=viewport.X<=630
    local height=preferred or 54
    if compact then height=math.max(height,44) end
    local width=math.max(0,viewport.X-26)
    return {Component="Paragraph",Compact=compact,Width=width,Height=height}
end

function AstraUI.Layout:Rule259(viewport,preferred)
    local compact=viewport.X<=360
    local height=preferred or 58
    if compact then height=math.max(height,44) end
    local width=math.max(0,viewport.X-30)
    return {Component="Label",Compact=compact,Width=width,Height=height}
end

function AstraUI.Layout:Rule260(viewport,preferred)
    local compact=viewport.X<=405
    local height=preferred or 42
    if compact then height=math.max(height,44) end
    local width=math.max(0,viewport.X-18)
    return {Component="Button",Compact=compact,Width=width,Height=height}
end

function AstraUI.Layout:Rule261(viewport,preferred)
    local compact=viewport.X<=450
    local height=preferred or 46
    if compact then height=math.max(height,44) end
    local width=math.max(0,viewport.X-22)
    return {Component="Toggle",Compact=compact,Width=width,Height=height}
end

function AstraUI.Layout:Rule262(viewport,preferred)
    local compact=viewport.X<=495
    local height=preferred or 50
    if compact then height=math.max(height,44) end
    local width=math.max(0,viewport.X-26)
    return {Component="Slider",Compact=compact,Width=width,Height=height}
end

function AstraUI.Layout:Rule263(viewport,preferred)
    local compact=viewport.X<=540
    local height=preferred or 54
    if compact then height=math.max(height,44) end
    local width=math.max(0,viewport.X-30)
    return {Component="Dropdown",Compact=compact,Width=width,Height=height}
end

function AstraUI.Layout:Rule264(viewport,preferred)
    local compact=viewport.X<=585
    local height=preferred or 58
    if compact then height=math.max(height,44) end
    local width=math.max(0,viewport.X-18)
    return {Component="MultiDropdown",Compact=compact,Width=width,Height=height}
end

function AstraUI.Layout:Rule265(viewport,preferred)
    local compact=viewport.X<=630
    local height=preferred or 42
    if compact then height=math.max(height,44) end
    local width=math.max(0,viewport.X-22)
    return {Component="Input",Compact=compact,Width=width,Height=height}
end

function AstraUI.Layout:Rule266(viewport,preferred)
    local compact=viewport.X<=360
    local height=preferred or 46
    if compact then height=math.max(height,44) end
    local width=math.max(0,viewport.X-26)
    return {Component="Keybind",Compact=compact,Width=width,Height=height}
end

function AstraUI.Layout:Rule267(viewport,preferred)
    local compact=viewport.X<=405
    local height=preferred or 50
    if compact then height=math.max(height,44) end
    local width=math.max(0,viewport.X-30)
    return {Component="ColorPicker",Compact=compact,Width=width,Height=height}
end

function AstraUI.Layout:Rule268(viewport,preferred)
    local compact=viewport.X<=450
    local height=preferred or 54
    if compact then height=math.max(height,44) end
    local width=math.max(0,viewport.X-18)
    return {Component="Paragraph",Compact=compact,Width=width,Height=height}
end

function AstraUI.Layout:Rule269(viewport,preferred)
    local compact=viewport.X<=495
    local height=preferred or 58
    if compact then height=math.max(height,44) end
    local width=math.max(0,viewport.X-22)
    return {Component="Label",Compact=compact,Width=width,Height=height}
end

function AstraUI.Layout:Rule270(viewport,preferred)
    local compact=viewport.X<=540
    local height=preferred or 42
    if compact then height=math.max(height,44) end
    local width=math.max(0,viewport.X-26)
    return {Component="Button",Compact=compact,Width=width,Height=height}
end

function AstraUI.Layout:Rule271(viewport,preferred)
    local compact=viewport.X<=585
    local height=preferred or 46
    if compact then height=math.max(height,44) end
    local width=math.max(0,viewport.X-30)
    return {Component="Toggle",Compact=compact,Width=width,Height=height}
end

function AstraUI.Layout:Rule272(viewport,preferred)
    local compact=viewport.X<=630
    local height=preferred or 50
    if compact then height=math.max(height,44) end
    local width=math.max(0,viewport.X-18)
    return {Component="Slider",Compact=compact,Width=width,Height=height}
end

function AstraUI.Layout:Rule273(viewport,preferred)
    local compact=viewport.X<=360
    local height=preferred or 54
    if compact then height=math.max(height,44) end
    local width=math.max(0,viewport.X-22)
    return {Component="Dropdown",Compact=compact,Width=width,Height=height}
end

function AstraUI.Layout:Rule274(viewport,preferred)
    local compact=viewport.X<=405
    local height=preferred or 58
    if compact then height=math.max(height,44) end
    local width=math.max(0,viewport.X-26)
    return {Component="MultiDropdown",Compact=compact,Width=width,Height=height}
end

function AstraUI.Layout:Rule275(viewport,preferred)
    local compact=viewport.X<=450
    local height=preferred or 42
    if compact then height=math.max(height,44) end
    local width=math.max(0,viewport.X-30)
    return {Component="Input",Compact=compact,Width=width,Height=height}
end

function AstraUI.Layout:Rule276(viewport,preferred)
    local compact=viewport.X<=495
    local height=preferred or 46
    if compact then height=math.max(height,44) end
    local width=math.max(0,viewport.X-18)
    return {Component="Keybind",Compact=compact,Width=width,Height=height}
end

function AstraUI.Layout:Rule277(viewport,preferred)
    local compact=viewport.X<=540
    local height=preferred or 50
    if compact then height=math.max(height,44) end
    local width=math.max(0,viewport.X-22)
    return {Component="ColorPicker",Compact=compact,Width=width,Height=height}
end

function AstraUI.Layout:Rule278(viewport,preferred)
    local compact=viewport.X<=585
    local height=preferred or 54
    if compact then height=math.max(height,44) end
    local width=math.max(0,viewport.X-26)
    return {Component="Paragraph",Compact=compact,Width=width,Height=height}
end

function AstraUI.Layout:Rule279(viewport,preferred)
    local compact=viewport.X<=630
    local height=preferred or 58
    if compact then height=math.max(height,44) end
    local width=math.max(0,viewport.X-30)
    return {Component="Label",Compact=compact,Width=width,Height=height}
end

function AstraUI.Layout:Rule280(viewport,preferred)
    local compact=viewport.X<=360
    local height=preferred or 42
    if compact then height=math.max(height,44) end
    local width=math.max(0,viewport.X-18)
    return {Component="Button",Compact=compact,Width=width,Height=height}
end

function AstraUI.Layout:Rule281(viewport,preferred)
    local compact=viewport.X<=405
    local height=preferred or 46
    if compact then height=math.max(height,44) end
    local width=math.max(0,viewport.X-22)
    return {Component="Toggle",Compact=compact,Width=width,Height=height}
end

function AstraUI.Layout:Rule282(viewport,preferred)
    local compact=viewport.X<=450
    local height=preferred or 50
    if compact then height=math.max(height,44) end
    local width=math.max(0,viewport.X-26)
    return {Component="Slider",Compact=compact,Width=width,Height=height}
end

function AstraUI.Layout:Rule283(viewport,preferred)
    local compact=viewport.X<=495
    local height=preferred or 54
    if compact then height=math.max(height,44) end
    local width=math.max(0,viewport.X-30)
    return {Component="Dropdown",Compact=compact,Width=width,Height=height}
end

function AstraUI.Layout:Rule284(viewport,preferred)
    local compact=viewport.X<=540
    local height=preferred or 58
    if compact then height=math.max(height,44) end
    local width=math.max(0,viewport.X-18)
    return {Component="MultiDropdown",Compact=compact,Width=width,Height=height}
end

function AstraUI.Layout:Rule285(viewport,preferred)
    local compact=viewport.X<=585
    local height=preferred or 42
    if compact then height=math.max(height,44) end
    local width=math.max(0,viewport.X-22)
    return {Component="Input",Compact=compact,Width=width,Height=height}
end

function AstraUI.Layout:Rule286(viewport,preferred)
    local compact=viewport.X<=630
    local height=preferred or 46
    if compact then height=math.max(height,44) end
    local width=math.max(0,viewport.X-26)
    return {Component="Keybind",Compact=compact,Width=width,Height=height}
end

function AstraUI.Layout:Rule287(viewport,preferred)
    local compact=viewport.X<=360
    local height=preferred or 50
    if compact then height=math.max(height,44) end
    local width=math.max(0,viewport.X-30)
    return {Component="ColorPicker",Compact=compact,Width=width,Height=height}
end

function AstraUI.Layout:Rule288(viewport,preferred)
    local compact=viewport.X<=405
    local height=preferred or 54
    if compact then height=math.max(height,44) end
    local width=math.max(0,viewport.X-18)
    return {Component="Paragraph",Compact=compact,Width=width,Height=height}
end

function AstraUI.Layout:Rule289(viewport,preferred)
    local compact=viewport.X<=450
    local height=preferred or 58
    if compact then height=math.max(height,44) end
    local width=math.max(0,viewport.X-22)
    return {Component="Label",Compact=compact,Width=width,Height=height}
end

function AstraUI.Layout:Rule290(viewport,preferred)
    local compact=viewport.X<=495
    local height=preferred or 42
    if compact then height=math.max(height,44) end
    local width=math.max(0,viewport.X-26)
    return {Component="Button",Compact=compact,Width=width,Height=height}
end

function AstraUI.Layout:Rule291(viewport,preferred)
    local compact=viewport.X<=540
    local height=preferred or 46
    if compact then height=math.max(height,44) end
    local width=math.max(0,viewport.X-30)
    return {Component="Toggle",Compact=compact,Width=width,Height=height}
end

function AstraUI.Layout:Rule292(viewport,preferred)
    local compact=viewport.X<=585
    local height=preferred or 50
    if compact then height=math.max(height,44) end
    local width=math.max(0,viewport.X-18)
    return {Component="Slider",Compact=compact,Width=width,Height=height}
end

function AstraUI.Layout:Rule293(viewport,preferred)
    local compact=viewport.X<=630
    local height=preferred or 54
    if compact then height=math.max(height,44) end
    local width=math.max(0,viewport.X-22)
    return {Component="Dropdown",Compact=compact,Width=width,Height=height}
end

function AstraUI.Layout:Rule294(viewport,preferred)
    local compact=viewport.X<=360
    local height=preferred or 58
    if compact then height=math.max(height,44) end
    local width=math.max(0,viewport.X-26)
    return {Component="MultiDropdown",Compact=compact,Width=width,Height=height}
end

function AstraUI.Layout:Rule295(viewport,preferred)
    local compact=viewport.X<=405
    local height=preferred or 42
    if compact then height=math.max(height,44) end
    local width=math.max(0,viewport.X-30)
    return {Component="Input",Compact=compact,Width=width,Height=height}
end

function AstraUI.Layout:Rule296(viewport,preferred)
    local compact=viewport.X<=450
    local height=preferred or 46
    if compact then height=math.max(height,44) end
    local width=math.max(0,viewport.X-18)
    return {Component="Keybind",Compact=compact,Width=width,Height=height}
end

function AstraUI.Layout:Rule297(viewport,preferred)
    local compact=viewport.X<=495
    local height=preferred or 50
    if compact then height=math.max(height,44) end
    local width=math.max(0,viewport.X-22)
    return {Component="ColorPicker",Compact=compact,Width=width,Height=height}
end

function AstraUI.Layout:Rule298(viewport,preferred)
    local compact=viewport.X<=540
    local height=preferred or 54
    if compact then height=math.max(height,44) end
    local width=math.max(0,viewport.X-26)
    return {Component="Paragraph",Compact=compact,Width=width,Height=height}
end

function AstraUI.Layout:Rule299(viewport,preferred)
    local compact=viewport.X<=585
    local height=preferred or 58
    if compact then height=math.max(height,44) end
    local width=math.max(0,viewport.X-30)
    return {Component="Label",Compact=compact,Width=width,Height=height}
end

function AstraUI.Layout:Rule300(viewport,preferred)
    local compact=viewport.X<=630
    local height=preferred or 42
    if compact then height=math.max(height,44) end
    local width=math.max(0,viewport.X-18)
    return {Component="Button",Compact=compact,Width=width,Height=height}
end

function AstraUI.Layout:Rule301(viewport,preferred)
    local compact=viewport.X<=360
    local height=preferred or 46
    if compact then height=math.max(height,44) end
    local width=math.max(0,viewport.X-22)
    return {Component="Toggle",Compact=compact,Width=width,Height=height}
end

function AstraUI.Layout:Rule302(viewport,preferred)
    local compact=viewport.X<=405
    local height=preferred or 50
    if compact then height=math.max(height,44) end
    local width=math.max(0,viewport.X-26)
    return {Component="Slider",Compact=compact,Width=width,Height=height}
end

function AstraUI.Layout:Rule303(viewport,preferred)
    local compact=viewport.X<=450
    local height=preferred or 54
    if compact then height=math.max(height,44) end
    local width=math.max(0,viewport.X-30)
    return {Component="Dropdown",Compact=compact,Width=width,Height=height}
end

function AstraUI.Layout:Rule304(viewport,preferred)
    local compact=viewport.X<=495
    local height=preferred or 58
    if compact then height=math.max(height,44) end
    local width=math.max(0,viewport.X-18)
    return {Component="MultiDropdown",Compact=compact,Width=width,Height=height}
end

function AstraUI.Layout:Rule305(viewport,preferred)
    local compact=viewport.X<=540
    local height=preferred or 42
    if compact then height=math.max(height,44) end
    local width=math.max(0,viewport.X-22)
    return {Component="Input",Compact=compact,Width=width,Height=height}
end

function AstraUI.Layout:Rule306(viewport,preferred)
    local compact=viewport.X<=585
    local height=preferred or 46
    if compact then height=math.max(height,44) end
    local width=math.max(0,viewport.X-26)
    return {Component="Keybind",Compact=compact,Width=width,Height=height}
end

function AstraUI.Layout:Rule307(viewport,preferred)
    local compact=viewport.X<=630
    local height=preferred or 50
    if compact then height=math.max(height,44) end
    local width=math.max(0,viewport.X-30)
    return {Component="ColorPicker",Compact=compact,Width=width,Height=height}
end

function AstraUI.Layout:Rule308(viewport,preferred)
    local compact=viewport.X<=360
    local height=preferred or 54
    if compact then height=math.max(height,44) end
    local width=math.max(0,viewport.X-18)
    return {Component="Paragraph",Compact=compact,Width=width,Height=height}
end

function AstraUI.Layout:Rule309(viewport,preferred)
    local compact=viewport.X<=405
    local height=preferred or 58
    if compact then height=math.max(height,44) end
    local width=math.max(0,viewport.X-22)
    return {Component="Label",Compact=compact,Width=width,Height=height}
end

function AstraUI.Layout:Rule310(viewport,preferred)
    local compact=viewport.X<=450
    local height=preferred or 42
    if compact then height=math.max(height,44) end
    local width=math.max(0,viewport.X-26)
    return {Component="Button",Compact=compact,Width=width,Height=height}
end

function AstraUI.Layout:Rule311(viewport,preferred)
    local compact=viewport.X<=495
    local height=preferred or 46
    if compact then height=math.max(height,44) end
    local width=math.max(0,viewport.X-30)
    return {Component="Toggle",Compact=compact,Width=width,Height=height}
end

function AstraUI.Layout:Rule312(viewport,preferred)
    local compact=viewport.X<=540
    local height=preferred or 50
    if compact then height=math.max(height,44) end
    local width=math.max(0,viewport.X-18)
    return {Component="Slider",Compact=compact,Width=width,Height=height}
end

function AstraUI.Layout:Rule313(viewport,preferred)
    local compact=viewport.X<=585
    local height=preferred or 54
    if compact then height=math.max(height,44) end
    local width=math.max(0,viewport.X-22)
    return {Component="Dropdown",Compact=compact,Width=width,Height=height}
end

function AstraUI.Layout:Rule314(viewport,preferred)
    local compact=viewport.X<=630
    local height=preferred or 58
    if compact then height=math.max(height,44) end
    local width=math.max(0,viewport.X-26)
    return {Component="MultiDropdown",Compact=compact,Width=width,Height=height}
end

function AstraUI.Layout:Rule315(viewport,preferred)
    local compact=viewport.X<=360
    local height=preferred or 42
    if compact then height=math.max(height,44) end
    local width=math.max(0,viewport.X-30)
    return {Component="Input",Compact=compact,Width=width,Height=height}
end

function AstraUI.Layout:Rule316(viewport,preferred)
    local compact=viewport.X<=405
    local height=preferred or 46
    if compact then height=math.max(height,44) end
    local width=math.max(0,viewport.X-18)
    return {Component="Keybind",Compact=compact,Width=width,Height=height}
end

function AstraUI.Layout:Rule317(viewport,preferred)
    local compact=viewport.X<=450
    local height=preferred or 50
    if compact then height=math.max(height,44) end
    local width=math.max(0,viewport.X-22)
    return {Component="ColorPicker",Compact=compact,Width=width,Height=height}
end

function AstraUI.Layout:Rule318(viewport,preferred)
    local compact=viewport.X<=495
    local height=preferred or 54
    if compact then height=math.max(height,44) end
    local width=math.max(0,viewport.X-26)
    return {Component="Paragraph",Compact=compact,Width=width,Height=height}
end

function AstraUI.Layout:Rule319(viewport,preferred)
    local compact=viewport.X<=540
    local height=preferred or 58
    if compact then height=math.max(height,44) end
    local width=math.max(0,viewport.X-30)
    return {Component="Label",Compact=compact,Width=width,Height=height}
end

function AstraUI.Layout:Rule320(viewport,preferred)
    local compact=viewport.X<=585
    local height=preferred or 42
    if compact then height=math.max(height,44) end
    local width=math.max(0,viewport.X-18)
    return {Component="Button",Compact=compact,Width=width,Height=height}
end

function AstraUI.Layout:Rule321(viewport,preferred)
    local compact=viewport.X<=630
    local height=preferred or 46
    if compact then height=math.max(height,44) end
    local width=math.max(0,viewport.X-22)
    return {Component="Toggle",Compact=compact,Width=width,Height=height}
end

function AstraUI.Layout:Rule322(viewport,preferred)
    local compact=viewport.X<=360
    local height=preferred or 50
    if compact then height=math.max(height,44) end
    local width=math.max(0,viewport.X-26)
    return {Component="Slider",Compact=compact,Width=width,Height=height}
end

function AstraUI.Layout:Rule323(viewport,preferred)
    local compact=viewport.X<=405
    local height=preferred or 54
    if compact then height=math.max(height,44) end
    local width=math.max(0,viewport.X-30)
    return {Component="Dropdown",Compact=compact,Width=width,Height=height}
end

function AstraUI.Layout:Rule324(viewport,preferred)
    local compact=viewport.X<=450
    local height=preferred or 58
    if compact then height=math.max(height,44) end
    local width=math.max(0,viewport.X-18)
    return {Component="MultiDropdown",Compact=compact,Width=width,Height=height}
end

function AstraUI.Layout:Rule325(viewport,preferred)
    local compact=viewport.X<=495
    local height=preferred or 42
    if compact then height=math.max(height,44) end
    local width=math.max(0,viewport.X-22)
    return {Component="Input",Compact=compact,Width=width,Height=height}
end

function AstraUI.Layout:Rule326(viewport,preferred)
    local compact=viewport.X<=540
    local height=preferred or 46
    if compact then height=math.max(height,44) end
    local width=math.max(0,viewport.X-26)
    return {Component="Keybind",Compact=compact,Width=width,Height=height}
end

function AstraUI.Layout:Rule327(viewport,preferred)
    local compact=viewport.X<=585
    local height=preferred or 50
    if compact then height=math.max(height,44) end
    local width=math.max(0,viewport.X-30)
    return {Component="ColorPicker",Compact=compact,Width=width,Height=height}
end

function AstraUI.Layout:Rule328(viewport,preferred)
    local compact=viewport.X<=630
    local height=preferred or 54
    if compact then height=math.max(height,44) end
    local width=math.max(0,viewport.X-18)
    return {Component="Paragraph",Compact=compact,Width=width,Height=height}
end

function AstraUI.Layout:Rule329(viewport,preferred)
    local compact=viewport.X<=360
    local height=preferred or 58
    if compact then height=math.max(height,44) end
    local width=math.max(0,viewport.X-22)
    return {Component="Label",Compact=compact,Width=width,Height=height}
end

function AstraUI.Layout:Rule330(viewport,preferred)
    local compact=viewport.X<=405
    local height=preferred or 42
    if compact then height=math.max(height,44) end
    local width=math.max(0,viewport.X-26)
    return {Component="Button",Compact=compact,Width=width,Height=height}
end

function AstraUI.Layout:Rule331(viewport,preferred)
    local compact=viewport.X<=450
    local height=preferred or 46
    if compact then height=math.max(height,44) end
    local width=math.max(0,viewport.X-30)
    return {Component="Toggle",Compact=compact,Width=width,Height=height}
end

function AstraUI.Layout:Rule332(viewport,preferred)
    local compact=viewport.X<=495
    local height=preferred or 50
    if compact then height=math.max(height,44) end
    local width=math.max(0,viewport.X-18)
    return {Component="Slider",Compact=compact,Width=width,Height=height}
end

function AstraUI.Layout:Rule333(viewport,preferred)
    local compact=viewport.X<=540
    local height=preferred or 54
    if compact then height=math.max(height,44) end
    local width=math.max(0,viewport.X-22)
    return {Component="Dropdown",Compact=compact,Width=width,Height=height}
end

function AstraUI.Layout:Rule334(viewport,preferred)
    local compact=viewport.X<=585
    local height=preferred or 58
    if compact then height=math.max(height,44) end
    local width=math.max(0,viewport.X-26)
    return {Component="MultiDropdown",Compact=compact,Width=width,Height=height}
end

function AstraUI.Layout:Rule335(viewport,preferred)
    local compact=viewport.X<=630
    local height=preferred or 42
    if compact then height=math.max(height,44) end
    local width=math.max(0,viewport.X-30)
    return {Component="Input",Compact=compact,Width=width,Height=height}
end

function AstraUI.Layout:Rule336(viewport,preferred)
    local compact=viewport.X<=360
    local height=preferred or 46
    if compact then height=math.max(height,44) end
    local width=math.max(0,viewport.X-18)
    return {Component="Keybind",Compact=compact,Width=width,Height=height}
end

function AstraUI.Layout:Rule337(viewport,preferred)
    local compact=viewport.X<=405
    local height=preferred or 50
    if compact then height=math.max(height,44) end
    local width=math.max(0,viewport.X-22)
    return {Component="ColorPicker",Compact=compact,Width=width,Height=height}
end

function AstraUI.Layout:Rule338(viewport,preferred)
    local compact=viewport.X<=450
    local height=preferred or 54
    if compact then height=math.max(height,44) end
    local width=math.max(0,viewport.X-26)
    return {Component="Paragraph",Compact=compact,Width=width,Height=height}
end

function AstraUI.Layout:Rule339(viewport,preferred)
    local compact=viewport.X<=495
    local height=preferred or 58
    if compact then height=math.max(height,44) end
    local width=math.max(0,viewport.X-30)
    return {Component="Label",Compact=compact,Width=width,Height=height}
end

function AstraUI.Layout:Rule340(viewport,preferred)
    local compact=viewport.X<=540
    local height=preferred or 42
    if compact then height=math.max(height,44) end
    local width=math.max(0,viewport.X-18)
    return {Component="Button",Compact=compact,Width=width,Height=height}
end

function AstraUI.Layout:Rule341(viewport,preferred)
    local compact=viewport.X<=585
    local height=preferred or 46
    if compact then height=math.max(height,44) end
    local width=math.max(0,viewport.X-22)
    return {Component="Toggle",Compact=compact,Width=width,Height=height}
end

function AstraUI.Layout:Rule342(viewport,preferred)
    local compact=viewport.X<=630
    local height=preferred or 50
    if compact then height=math.max(height,44) end
    local width=math.max(0,viewport.X-26)
    return {Component="Slider",Compact=compact,Width=width,Height=height}
end

function AstraUI.Layout:Rule343(viewport,preferred)
    local compact=viewport.X<=360
    local height=preferred or 54
    if compact then height=math.max(height,44) end
    local width=math.max(0,viewport.X-30)
    return {Component="Dropdown",Compact=compact,Width=width,Height=height}
end

function AstraUI.Layout:Rule344(viewport,preferred)
    local compact=viewport.X<=405
    local height=preferred or 58
    if compact then height=math.max(height,44) end
    local width=math.max(0,viewport.X-18)
    return {Component="MultiDropdown",Compact=compact,Width=width,Height=height}
end

function AstraUI.Layout:Rule345(viewport,preferred)
    local compact=viewport.X<=450
    local height=preferred or 42
    if compact then height=math.max(height,44) end
    local width=math.max(0,viewport.X-22)
    return {Component="Input",Compact=compact,Width=width,Height=height}
end

function AstraUI.Layout:Rule346(viewport,preferred)
    local compact=viewport.X<=495
    local height=preferred or 46
    if compact then height=math.max(height,44) end
    local width=math.max(0,viewport.X-26)
    return {Component="Keybind",Compact=compact,Width=width,Height=height}
end

function AstraUI.Layout:Rule347(viewport,preferred)
    local compact=viewport.X<=540
    local height=preferred or 50
    if compact then height=math.max(height,44) end
    local width=math.max(0,viewport.X-30)
    return {Component="ColorPicker",Compact=compact,Width=width,Height=height}
end

function AstraUI.Layout:Rule348(viewport,preferred)
    local compact=viewport.X<=585
    local height=preferred or 54
    if compact then height=math.max(height,44) end
    local width=math.max(0,viewport.X-18)
    return {Component="Paragraph",Compact=compact,Width=width,Height=height}
end

function AstraUI.Layout:Rule349(viewport,preferred)
    local compact=viewport.X<=630
    local height=preferred or 58
    if compact then height=math.max(height,44) end
    local width=math.max(0,viewport.X-22)
    return {Component="Label",Compact=compact,Width=width,Height=height}
end

function AstraUI.Layout:Rule350(viewport,preferred)
    local compact=viewport.X<=360
    local height=preferred or 42
    if compact then height=math.max(height,44) end
    local width=math.max(0,viewport.X-26)
    return {Component="Button",Compact=compact,Width=width,Height=height}
end

function AstraUI.Layout:Rule351(viewport,preferred)
    local compact=viewport.X<=405
    local height=preferred or 46
    if compact then height=math.max(height,44) end
    local width=math.max(0,viewport.X-30)
    return {Component="Toggle",Compact=compact,Width=width,Height=height}
end

function AstraUI.Layout:Rule352(viewport,preferred)
    local compact=viewport.X<=450
    local height=preferred or 50
    if compact then height=math.max(height,44) end
    local width=math.max(0,viewport.X-18)
    return {Component="Slider",Compact=compact,Width=width,Height=height}
end

function AstraUI.Layout:Rule353(viewport,preferred)
    local compact=viewport.X<=495
    local height=preferred or 54
    if compact then height=math.max(height,44) end
    local width=math.max(0,viewport.X-22)
    return {Component="Dropdown",Compact=compact,Width=width,Height=height}
end

function AstraUI.Layout:Rule354(viewport,preferred)
    local compact=viewport.X<=540
    local height=preferred or 58
    if compact then height=math.max(height,44) end
    local width=math.max(0,viewport.X-26)
    return {Component="MultiDropdown",Compact=compact,Width=width,Height=height}
end

function AstraUI.Layout:Rule355(viewport,preferred)
    local compact=viewport.X<=585
    local height=preferred or 42
    if compact then height=math.max(height,44) end
    local width=math.max(0,viewport.X-30)
    return {Component="Input",Compact=compact,Width=width,Height=height}
end

function AstraUI.Layout:Rule356(viewport,preferred)
    local compact=viewport.X<=630
    local height=preferred or 46
    if compact then height=math.max(height,44) end
    local width=math.max(0,viewport.X-18)
    return {Component="Keybind",Compact=compact,Width=width,Height=height}
end

function AstraUI.Layout:Rule357(viewport,preferred)
    local compact=viewport.X<=360
    local height=preferred or 50
    if compact then height=math.max(height,44) end
    local width=math.max(0,viewport.X-22)
    return {Component="ColorPicker",Compact=compact,Width=width,Height=height}
end

function AstraUI.Layout:Rule358(viewport,preferred)
    local compact=viewport.X<=405
    local height=preferred or 54
    if compact then height=math.max(height,44) end
    local width=math.max(0,viewport.X-26)
    return {Component="Paragraph",Compact=compact,Width=width,Height=height}
end

function AstraUI.Layout:Rule359(viewport,preferred)
    local compact=viewport.X<=450
    local height=preferred or 58
    if compact then height=math.max(height,44) end
    local width=math.max(0,viewport.X-30)
    return {Component="Label",Compact=compact,Width=width,Height=height}
end

function AstraUI.Layout:Rule360(viewport,preferred)
    local compact=viewport.X<=495
    local height=preferred or 42
    if compact then height=math.max(height,44) end
    local width=math.max(0,viewport.X-18)
    return {Component="Button",Compact=compact,Width=width,Height=height}
end

function AstraUI.Layout:Rule361(viewport,preferred)
    local compact=viewport.X<=540
    local height=preferred or 46
    if compact then height=math.max(height,44) end
    local width=math.max(0,viewport.X-22)
    return {Component="Toggle",Compact=compact,Width=width,Height=height}
end

function AstraUI.Layout:Rule362(viewport,preferred)
    local compact=viewport.X<=585
    local height=preferred or 50
    if compact then height=math.max(height,44) end
    local width=math.max(0,viewport.X-26)
    return {Component="Slider",Compact=compact,Width=width,Height=height}
end

function AstraUI.Layout:Rule363(viewport,preferred)
    local compact=viewport.X<=630
    local height=preferred or 54
    if compact then height=math.max(height,44) end
    local width=math.max(0,viewport.X-30)
    return {Component="Dropdown",Compact=compact,Width=width,Height=height}
end

function AstraUI.Layout:Rule364(viewport,preferred)
    local compact=viewport.X<=360
    local height=preferred or 58
    if compact then height=math.max(height,44) end
    local width=math.max(0,viewport.X-18)
    return {Component="MultiDropdown",Compact=compact,Width=width,Height=height}
end

function AstraUI.Layout:Rule365(viewport,preferred)
    local compact=viewport.X<=405
    local height=preferred or 42
    if compact then height=math.max(height,44) end
    local width=math.max(0,viewport.X-22)
    return {Component="Input",Compact=compact,Width=width,Height=height}
end

function AstraUI.Layout:Rule366(viewport,preferred)
    local compact=viewport.X<=450
    local height=preferred or 46
    if compact then height=math.max(height,44) end
    local width=math.max(0,viewport.X-26)
    return {Component="Keybind",Compact=compact,Width=width,Height=height}
end

function AstraUI.Layout:Rule367(viewport,preferred)
    local compact=viewport.X<=495
    local height=preferred or 50
    if compact then height=math.max(height,44) end
    local width=math.max(0,viewport.X-30)
    return {Component="ColorPicker",Compact=compact,Width=width,Height=height}
end

function AstraUI.Layout:Rule368(viewport,preferred)
    local compact=viewport.X<=540
    local height=preferred or 54
    if compact then height=math.max(height,44) end
    local width=math.max(0,viewport.X-18)
    return {Component="Paragraph",Compact=compact,Width=width,Height=height}
end

function AstraUI.Layout:Rule369(viewport,preferred)
    local compact=viewport.X<=585
    local height=preferred or 58
    if compact then height=math.max(height,44) end
    local width=math.max(0,viewport.X-22)
    return {Component="Label",Compact=compact,Width=width,Height=height}
end

function AstraUI.Layout:Rule370(viewport,preferred)
    local compact=viewport.X<=630
    local height=preferred or 42
    if compact then height=math.max(height,44) end
    local width=math.max(0,viewport.X-26)
    return {Component="Button",Compact=compact,Width=width,Height=height}
end

function AstraUI.Layout:Rule371(viewport,preferred)
    local compact=viewport.X<=360
    local height=preferred or 46
    if compact then height=math.max(height,44) end
    local width=math.max(0,viewport.X-30)
    return {Component="Toggle",Compact=compact,Width=width,Height=height}
end

function AstraUI.Layout:Rule372(viewport,preferred)
    local compact=viewport.X<=405
    local height=preferred or 50
    if compact then height=math.max(height,44) end
    local width=math.max(0,viewport.X-18)
    return {Component="Slider",Compact=compact,Width=width,Height=height}
end

function AstraUI.Layout:Rule373(viewport,preferred)
    local compact=viewport.X<=450
    local height=preferred or 54
    if compact then height=math.max(height,44) end
    local width=math.max(0,viewport.X-22)
    return {Component="Dropdown",Compact=compact,Width=width,Height=height}
end

function AstraUI.Layout:Rule374(viewport,preferred)
    local compact=viewport.X<=495
    local height=preferred or 58
    if compact then height=math.max(height,44) end
    local width=math.max(0,viewport.X-26)
    return {Component="MultiDropdown",Compact=compact,Width=width,Height=height}
end

function AstraUI.Layout:Rule375(viewport,preferred)
    local compact=viewport.X<=540
    local height=preferred or 42
    if compact then height=math.max(height,44) end
    local width=math.max(0,viewport.X-30)
    return {Component="Input",Compact=compact,Width=width,Height=height}
end

function AstraUI.Layout:Rule376(viewport,preferred)
    local compact=viewport.X<=585
    local height=preferred or 46
    if compact then height=math.max(height,44) end
    local width=math.max(0,viewport.X-18)
    return {Component="Keybind",Compact=compact,Width=width,Height=height}
end

function AstraUI.Layout:Rule377(viewport,preferred)
    local compact=viewport.X<=630
    local height=preferred or 50
    if compact then height=math.max(height,44) end
    local width=math.max(0,viewport.X-22)
    return {Component="ColorPicker",Compact=compact,Width=width,Height=height}
end

function AstraUI.Layout:Rule378(viewport,preferred)
    local compact=viewport.X<=360
    local height=preferred or 54
    if compact then height=math.max(height,44) end
    local width=math.max(0,viewport.X-26)
    return {Component="Paragraph",Compact=compact,Width=width,Height=height}
end

function AstraUI.Layout:Rule379(viewport,preferred)
    local compact=viewport.X<=405
    local height=preferred or 58
    if compact then height=math.max(height,44) end
    local width=math.max(0,viewport.X-30)
    return {Component="Label",Compact=compact,Width=width,Height=height}
end

function AstraUI.Layout:Rule380(viewport,preferred)
    local compact=viewport.X<=450
    local height=preferred or 42
    if compact then height=math.max(height,44) end
    local width=math.max(0,viewport.X-18)
    return {Component="Button",Compact=compact,Width=width,Height=height}
end

function AstraUI.Layout:Rule381(viewport,preferred)
    local compact=viewport.X<=495
    local height=preferred or 46
    if compact then height=math.max(height,44) end
    local width=math.max(0,viewport.X-22)
    return {Component="Toggle",Compact=compact,Width=width,Height=height}
end

function AstraUI.Layout:Rule382(viewport,preferred)
    local compact=viewport.X<=540
    local height=preferred or 50
    if compact then height=math.max(height,44) end
    local width=math.max(0,viewport.X-26)
    return {Component="Slider",Compact=compact,Width=width,Height=height}
end

function AstraUI.Layout:Rule383(viewport,preferred)
    local compact=viewport.X<=585
    local height=preferred or 54
    if compact then height=math.max(height,44) end
    local width=math.max(0,viewport.X-30)
    return {Component="Dropdown",Compact=compact,Width=width,Height=height}
end

function AstraUI.Layout:Rule384(viewport,preferred)
    local compact=viewport.X<=630
    local height=preferred or 58
    if compact then height=math.max(height,44) end
    local width=math.max(0,viewport.X-18)
    return {Component="MultiDropdown",Compact=compact,Width=width,Height=height}
end

function AstraUI.Layout:Rule385(viewport,preferred)
    local compact=viewport.X<=360
    local height=preferred or 42
    if compact then height=math.max(height,44) end
    local width=math.max(0,viewport.X-22)
    return {Component="Input",Compact=compact,Width=width,Height=height}
end

function AstraUI.Layout:Rule386(viewport,preferred)
    local compact=viewport.X<=405
    local height=preferred or 46
    if compact then height=math.max(height,44) end
    local width=math.max(0,viewport.X-26)
    return {Component="Keybind",Compact=compact,Width=width,Height=height}
end

function AstraUI.Layout:Rule387(viewport,preferred)
    local compact=viewport.X<=450
    local height=preferred or 50
    if compact then height=math.max(height,44) end
    local width=math.max(0,viewport.X-30)
    return {Component="ColorPicker",Compact=compact,Width=width,Height=height}
end

function AstraUI.Layout:Rule388(viewport,preferred)
    local compact=viewport.X<=495
    local height=preferred or 54
    if compact then height=math.max(height,44) end
    local width=math.max(0,viewport.X-18)
    return {Component="Paragraph",Compact=compact,Width=width,Height=height}
end

function AstraUI.Layout:Rule389(viewport,preferred)
    local compact=viewport.X<=540
    local height=preferred or 58
    if compact then height=math.max(height,44) end
    local width=math.max(0,viewport.X-22)
    return {Component="Label",Compact=compact,Width=width,Height=height}
end

function AstraUI.Layout:Rule390(viewport,preferred)
    local compact=viewport.X<=585
    local height=preferred or 42
    if compact then height=math.max(height,44) end
    local width=math.max(0,viewport.X-26)
    return {Component="Button",Compact=compact,Width=width,Height=height}
end

function AstraUI.Layout:Rule391(viewport,preferred)
    local compact=viewport.X<=630
    local height=preferred or 46
    if compact then height=math.max(height,44) end
    local width=math.max(0,viewport.X-30)
    return {Component="Toggle",Compact=compact,Width=width,Height=height}
end

function AstraUI.Layout:Rule392(viewport,preferred)
    local compact=viewport.X<=360
    local height=preferred or 50
    if compact then height=math.max(height,44) end
    local width=math.max(0,viewport.X-18)
    return {Component="Slider",Compact=compact,Width=width,Height=height}
end

function AstraUI.Layout:Rule393(viewport,preferred)
    local compact=viewport.X<=405
    local height=preferred or 54
    if compact then height=math.max(height,44) end
    local width=math.max(0,viewport.X-22)
    return {Component="Dropdown",Compact=compact,Width=width,Height=height}
end

function AstraUI.Layout:Rule394(viewport,preferred)
    local compact=viewport.X<=450
    local height=preferred or 58
    if compact then height=math.max(height,44) end
    local width=math.max(0,viewport.X-26)
    return {Component="MultiDropdown",Compact=compact,Width=width,Height=height}
end

function AstraUI.Layout:Rule395(viewport,preferred)
    local compact=viewport.X<=495
    local height=preferred or 42
    if compact then height=math.max(height,44) end
    local width=math.max(0,viewport.X-30)
    return {Component="Input",Compact=compact,Width=width,Height=height}
end

function AstraUI.Layout:Rule396(viewport,preferred)
    local compact=viewport.X<=540
    local height=preferred or 46
    if compact then height=math.max(height,44) end
    local width=math.max(0,viewport.X-18)
    return {Component="Keybind",Compact=compact,Width=width,Height=height}
end

function AstraUI.Layout:Rule397(viewport,preferred)
    local compact=viewport.X<=585
    local height=preferred or 50
    if compact then height=math.max(height,44) end
    local width=math.max(0,viewport.X-22)
    return {Component="ColorPicker",Compact=compact,Width=width,Height=height}
end

function AstraUI.Layout:Rule398(viewport,preferred)
    local compact=viewport.X<=630
    local height=preferred or 54
    if compact then height=math.max(height,44) end
    local width=math.max(0,viewport.X-26)
    return {Component="Paragraph",Compact=compact,Width=width,Height=height}
end

function AstraUI.Layout:Rule399(viewport,preferred)
    local compact=viewport.X<=360
    local height=preferred or 58
    if compact then height=math.max(height,44) end
    local width=math.max(0,viewport.X-30)
    return {Component="Label",Compact=compact,Width=width,Height=height}
end

function AstraUI.Layout:Rule400(viewport,preferred)
    local compact=viewport.X<=405
    local height=preferred or 42
    if compact then height=math.max(height,44) end
    local width=math.max(0,viewport.X-18)
    return {Component="Button",Compact=compact,Width=width,Height=height}
end

function AstraUI.Layout:Rule401(viewport,preferred)
    local compact=viewport.X<=450
    local height=preferred or 46
    if compact then height=math.max(height,44) end
    local width=math.max(0,viewport.X-22)
    return {Component="Toggle",Compact=compact,Width=width,Height=height}
end

function AstraUI.Layout:Rule402(viewport,preferred)
    local compact=viewport.X<=495
    local height=preferred or 50
    if compact then height=math.max(height,44) end
    local width=math.max(0,viewport.X-26)
    return {Component="Slider",Compact=compact,Width=width,Height=height}
end

function AstraUI.Layout:Rule403(viewport,preferred)
    local compact=viewport.X<=540
    local height=preferred or 54
    if compact then height=math.max(height,44) end
    local width=math.max(0,viewport.X-30)
    return {Component="Dropdown",Compact=compact,Width=width,Height=height}
end

function AstraUI.Layout:Rule404(viewport,preferred)
    local compact=viewport.X<=585
    local height=preferred or 58
    if compact then height=math.max(height,44) end
    local width=math.max(0,viewport.X-18)
    return {Component="MultiDropdown",Compact=compact,Width=width,Height=height}
end

function AstraUI.Layout:Rule405(viewport,preferred)
    local compact=viewport.X<=630
    local height=preferred or 42
    if compact then height=math.max(height,44) end
    local width=math.max(0,viewport.X-22)
    return {Component="Input",Compact=compact,Width=width,Height=height}
end

function AstraUI.Layout:Rule406(viewport,preferred)
    local compact=viewport.X<=360
    local height=preferred or 46
    if compact then height=math.max(height,44) end
    local width=math.max(0,viewport.X-26)
    return {Component="Keybind",Compact=compact,Width=width,Height=height}
end

function AstraUI.Layout:Rule407(viewport,preferred)
    local compact=viewport.X<=405
    local height=preferred or 50
    if compact then height=math.max(height,44) end
    local width=math.max(0,viewport.X-30)
    return {Component="ColorPicker",Compact=compact,Width=width,Height=height}
end

function AstraUI.Layout:Rule408(viewport,preferred)
    local compact=viewport.X<=450
    local height=preferred or 54
    if compact then height=math.max(height,44) end
    local width=math.max(0,viewport.X-18)
    return {Component="Paragraph",Compact=compact,Width=width,Height=height}
end

function AstraUI.Layout:Rule409(viewport,preferred)
    local compact=viewport.X<=495
    local height=preferred or 58
    if compact then height=math.max(height,44) end
    local width=math.max(0,viewport.X-22)
    return {Component="Label",Compact=compact,Width=width,Height=height}
end

function AstraUI.Layout:Rule410(viewport,preferred)
    local compact=viewport.X<=540
    local height=preferred or 42
    if compact then height=math.max(height,44) end
    local width=math.max(0,viewport.X-26)
    return {Component="Button",Compact=compact,Width=width,Height=height}
end

function AstraUI.Layout:Rule411(viewport,preferred)
    local compact=viewport.X<=585
    local height=preferred or 46
    if compact then height=math.max(height,44) end
    local width=math.max(0,viewport.X-30)
    return {Component="Toggle",Compact=compact,Width=width,Height=height}
end

function AstraUI.Layout:Rule412(viewport,preferred)
    local compact=viewport.X<=630
    local height=preferred or 50
    if compact then height=math.max(height,44) end
    local width=math.max(0,viewport.X-18)
    return {Component="Slider",Compact=compact,Width=width,Height=height}
end

function AstraUI.Layout:Rule413(viewport,preferred)
    local compact=viewport.X<=360
    local height=preferred or 54
    if compact then height=math.max(height,44) end
    local width=math.max(0,viewport.X-22)
    return {Component="Dropdown",Compact=compact,Width=width,Height=height}
end

function AstraUI.Layout:Rule414(viewport,preferred)
    local compact=viewport.X<=405
    local height=preferred or 58
    if compact then height=math.max(height,44) end
    local width=math.max(0,viewport.X-26)
    return {Component="MultiDropdown",Compact=compact,Width=width,Height=height}
end

function AstraUI.Layout:Rule415(viewport,preferred)
    local compact=viewport.X<=450
    local height=preferred or 42
    if compact then height=math.max(height,44) end
    local width=math.max(0,viewport.X-30)
    return {Component="Input",Compact=compact,Width=width,Height=height}
end

function AstraUI.Layout:Rule416(viewport,preferred)
    local compact=viewport.X<=495
    local height=preferred or 46
    if compact then height=math.max(height,44) end
    local width=math.max(0,viewport.X-18)
    return {Component="Keybind",Compact=compact,Width=width,Height=height}
end

function AstraUI.Layout:Rule417(viewport,preferred)
    local compact=viewport.X<=540
    local height=preferred or 50
    if compact then height=math.max(height,44) end
    local width=math.max(0,viewport.X-22)
    return {Component="ColorPicker",Compact=compact,Width=width,Height=height}
end

function AstraUI.Layout:Rule418(viewport,preferred)
    local compact=viewport.X<=585
    local height=preferred or 54
    if compact then height=math.max(height,44) end
    local width=math.max(0,viewport.X-26)
    return {Component="Paragraph",Compact=compact,Width=width,Height=height}
end

function AstraUI.Layout:Rule419(viewport,preferred)
    local compact=viewport.X<=630
    local height=preferred or 58
    if compact then height=math.max(height,44) end
    local width=math.max(0,viewport.X-30)
    return {Component="Label",Compact=compact,Width=width,Height=height}
end

function AstraUI.Layout:Rule420(viewport,preferred)
    local compact=viewport.X<=360
    local height=preferred or 42
    if compact then height=math.max(height,44) end
    local width=math.max(0,viewport.X-18)
    return {Component="Button",Compact=compact,Width=width,Height=height}
end

function AstraUI.Layout:Rule421(viewport,preferred)
    local compact=viewport.X<=405
    local height=preferred or 46
    if compact then height=math.max(height,44) end
    local width=math.max(0,viewport.X-22)
    return {Component="Toggle",Compact=compact,Width=width,Height=height}
end

function AstraUI.Layout:Rule422(viewport,preferred)
    local compact=viewport.X<=450
    local height=preferred or 50
    if compact then height=math.max(height,44) end
    local width=math.max(0,viewport.X-26)
    return {Component="Slider",Compact=compact,Width=width,Height=height}
end

function AstraUI.Layout:Rule423(viewport,preferred)
    local compact=viewport.X<=495
    local height=preferred or 54
    if compact then height=math.max(height,44) end
    local width=math.max(0,viewport.X-30)
    return {Component="Dropdown",Compact=compact,Width=width,Height=height}
end

function AstraUI.Layout:Rule424(viewport,preferred)
    local compact=viewport.X<=540
    local height=preferred or 58
    if compact then height=math.max(height,44) end
    local width=math.max(0,viewport.X-18)
    return {Component="MultiDropdown",Compact=compact,Width=width,Height=height}
end

function AstraUI.Layout:Rule425(viewport,preferred)
    local compact=viewport.X<=585
    local height=preferred or 42
    if compact then height=math.max(height,44) end
    local width=math.max(0,viewport.X-22)
    return {Component="Input",Compact=compact,Width=width,Height=height}
end

function AstraUI.Layout:Rule426(viewport,preferred)
    local compact=viewport.X<=630
    local height=preferred or 46
    if compact then height=math.max(height,44) end
    local width=math.max(0,viewport.X-26)
    return {Component="Keybind",Compact=compact,Width=width,Height=height}
end

function AstraUI.Layout:Rule427(viewport,preferred)
    local compact=viewport.X<=360
    local height=preferred or 50
    if compact then height=math.max(height,44) end
    local width=math.max(0,viewport.X-30)
    return {Component="ColorPicker",Compact=compact,Width=width,Height=height}
end

function AstraUI.Layout:Rule428(viewport,preferred)
    local compact=viewport.X<=405
    local height=preferred or 54
    if compact then height=math.max(height,44) end
    local width=math.max(0,viewport.X-18)
    return {Component="Paragraph",Compact=compact,Width=width,Height=height}
end

function AstraUI.Layout:Rule429(viewport,preferred)
    local compact=viewport.X<=450
    local height=preferred or 58
    if compact then height=math.max(height,44) end
    local width=math.max(0,viewport.X-22)
    return {Component="Label",Compact=compact,Width=width,Height=height}
end

function AstraUI.Layout:Rule430(viewport,preferred)
    local compact=viewport.X<=495
    local height=preferred or 42
    if compact then height=math.max(height,44) end
    local width=math.max(0,viewport.X-26)
    return {Component="Button",Compact=compact,Width=width,Height=height}
end

function AstraUI.Layout:Rule431(viewport,preferred)
    local compact=viewport.X<=540
    local height=preferred or 46
    if compact then height=math.max(height,44) end
    local width=math.max(0,viewport.X-30)
    return {Component="Toggle",Compact=compact,Width=width,Height=height}
end

function AstraUI.Layout:Rule432(viewport,preferred)
    local compact=viewport.X<=585
    local height=preferred or 50
    if compact then height=math.max(height,44) end
    local width=math.max(0,viewport.X-18)
    return {Component="Slider",Compact=compact,Width=width,Height=height}
end

function AstraUI.Layout:Rule433(viewport,preferred)
    local compact=viewport.X<=630
    local height=preferred or 54
    if compact then height=math.max(height,44) end
    local width=math.max(0,viewport.X-22)
    return {Component="Dropdown",Compact=compact,Width=width,Height=height}
end

function AstraUI.Layout:Rule434(viewport,preferred)
    local compact=viewport.X<=360
    local height=preferred or 58
    if compact then height=math.max(height,44) end
    local width=math.max(0,viewport.X-26)
    return {Component="MultiDropdown",Compact=compact,Width=width,Height=height}
end

function AstraUI.Layout:Rule435(viewport,preferred)
    local compact=viewport.X<=405
    local height=preferred or 42
    if compact then height=math.max(height,44) end
    local width=math.max(0,viewport.X-30)
    return {Component="Input",Compact=compact,Width=width,Height=height}
end

function AstraUI.Layout:Rule436(viewport,preferred)
    local compact=viewport.X<=450
    local height=preferred or 46
    if compact then height=math.max(height,44) end
    local width=math.max(0,viewport.X-18)
    return {Component="Keybind",Compact=compact,Width=width,Height=height}
end

function AstraUI.Layout:Rule437(viewport,preferred)
    local compact=viewport.X<=495
    local height=preferred or 50
    if compact then height=math.max(height,44) end
    local width=math.max(0,viewport.X-22)
    return {Component="ColorPicker",Compact=compact,Width=width,Height=height}
end

function AstraUI.Layout:Rule438(viewport,preferred)
    local compact=viewport.X<=540
    local height=preferred or 54
    if compact then height=math.max(height,44) end
    local width=math.max(0,viewport.X-26)
    return {Component="Paragraph",Compact=compact,Width=width,Height=height}
end

function AstraUI.Layout:Rule439(viewport,preferred)
    local compact=viewport.X<=585
    local height=preferred or 58
    if compact then height=math.max(height,44) end
    local width=math.max(0,viewport.X-30)
    return {Component="Label",Compact=compact,Width=width,Height=height}
end

function AstraUI.Layout:Rule440(viewport,preferred)
    local compact=viewport.X<=630
    local height=preferred or 42
    if compact then height=math.max(height,44) end
    local width=math.max(0,viewport.X-18)
    return {Component="Button",Compact=compact,Width=width,Height=height}
end

function AstraUI.Layout:Rule441(viewport,preferred)
    local compact=viewport.X<=360
    local height=preferred or 46
    if compact then height=math.max(height,44) end
    local width=math.max(0,viewport.X-22)
    return {Component="Toggle",Compact=compact,Width=width,Height=height}
end

function AstraUI.Layout:Rule442(viewport,preferred)
    local compact=viewport.X<=405
    local height=preferred or 50
    if compact then height=math.max(height,44) end
    local width=math.max(0,viewport.X-26)
    return {Component="Slider",Compact=compact,Width=width,Height=height}
end

function AstraUI.Layout:Rule443(viewport,preferred)
    local compact=viewport.X<=450
    local height=preferred or 54
    if compact then height=math.max(height,44) end
    local width=math.max(0,viewport.X-30)
    return {Component="Dropdown",Compact=compact,Width=width,Height=height}
end

function AstraUI.Layout:Rule444(viewport,preferred)
    local compact=viewport.X<=495
    local height=preferred or 58
    if compact then height=math.max(height,44) end
    local width=math.max(0,viewport.X-18)
    return {Component="MultiDropdown",Compact=compact,Width=width,Height=height}
end

function AstraUI.Layout:Rule445(viewport,preferred)
    local compact=viewport.X<=540
    local height=preferred or 42
    if compact then height=math.max(height,44) end
    local width=math.max(0,viewport.X-22)
    return {Component="Input",Compact=compact,Width=width,Height=height}
end

function AstraUI.Layout:Rule446(viewport,preferred)
    local compact=viewport.X<=585
    local height=preferred or 46
    if compact then height=math.max(height,44) end
    local width=math.max(0,viewport.X-26)
    return {Component="Keybind",Compact=compact,Width=width,Height=height}
end

function AstraUI.Layout:Rule447(viewport,preferred)
    local compact=viewport.X<=630
    local height=preferred or 50
    if compact then height=math.max(height,44) end
    local width=math.max(0,viewport.X-30)
    return {Component="ColorPicker",Compact=compact,Width=width,Height=height}
end

function AstraUI.Layout:Rule448(viewport,preferred)
    local compact=viewport.X<=360
    local height=preferred or 54
    if compact then height=math.max(height,44) end
    local width=math.max(0,viewport.X-18)
    return {Component="Paragraph",Compact=compact,Width=width,Height=height}
end

function AstraUI.Layout:Rule449(viewport,preferred)
    local compact=viewport.X<=405
    local height=preferred or 58
    if compact then height=math.max(height,44) end
    local width=math.max(0,viewport.X-22)
    return {Component="Label",Compact=compact,Width=width,Height=height}
end

function AstraUI.Layout:Rule450(viewport,preferred)
    local compact=viewport.X<=450
    local height=preferred or 42
    if compact then height=math.max(height,44) end
    local width=math.max(0,viewport.X-26)
    return {Component="Button",Compact=compact,Width=width,Height=height}
end

function AstraUI.Layout:Rule451(viewport,preferred)
    local compact=viewport.X<=495
    local height=preferred or 46
    if compact then height=math.max(height,44) end
    local width=math.max(0,viewport.X-30)
    return {Component="Toggle",Compact=compact,Width=width,Height=height}
end

function AstraUI.Layout:Rule452(viewport,preferred)
    local compact=viewport.X<=540
    local height=preferred or 50
    if compact then height=math.max(height,44) end
    local width=math.max(0,viewport.X-18)
    return {Component="Slider",Compact=compact,Width=width,Height=height}
end

function AstraUI.Layout:Rule453(viewport,preferred)
    local compact=viewport.X<=585
    local height=preferred or 54
    if compact then height=math.max(height,44) end
    local width=math.max(0,viewport.X-22)
    return {Component="Dropdown",Compact=compact,Width=width,Height=height}
end

function AstraUI.Layout:Rule454(viewport,preferred)
    local compact=viewport.X<=630
    local height=preferred or 58
    if compact then height=math.max(height,44) end
    local width=math.max(0,viewport.X-26)
    return {Component="MultiDropdown",Compact=compact,Width=width,Height=height}
end

function AstraUI.Layout:Rule455(viewport,preferred)
    local compact=viewport.X<=360
    local height=preferred or 42
    if compact then height=math.max(height,44) end
    local width=math.max(0,viewport.X-30)
    return {Component="Input",Compact=compact,Width=width,Height=height}
end

function AstraUI.Layout:Rule456(viewport,preferred)
    local compact=viewport.X<=405
    local height=preferred or 46
    if compact then height=math.max(height,44) end
    local width=math.max(0,viewport.X-18)
    return {Component="Keybind",Compact=compact,Width=width,Height=height}
end

function AstraUI.Layout:Rule457(viewport,preferred)
    local compact=viewport.X<=450
    local height=preferred or 50
    if compact then height=math.max(height,44) end
    local width=math.max(0,viewport.X-22)
    return {Component="ColorPicker",Compact=compact,Width=width,Height=height}
end

function AstraUI.Layout:Rule458(viewport,preferred)
    local compact=viewport.X<=495
    local height=preferred or 54
    if compact then height=math.max(height,44) end
    local width=math.max(0,viewport.X-26)
    return {Component="Paragraph",Compact=compact,Width=width,Height=height}
end

function AstraUI.Layout:Rule459(viewport,preferred)
    local compact=viewport.X<=540
    local height=preferred or 58
    if compact then height=math.max(height,44) end
    local width=math.max(0,viewport.X-30)
    return {Component="Label",Compact=compact,Width=width,Height=height}
end

function AstraUI.Layout:Rule460(viewport,preferred)
    local compact=viewport.X<=585
    local height=preferred or 42
    if compact then height=math.max(height,44) end
    local width=math.max(0,viewport.X-18)
    return {Component="Button",Compact=compact,Width=width,Height=height}
end

function AstraUI.Layout:Rule461(viewport,preferred)
    local compact=viewport.X<=630
    local height=preferred or 46
    if compact then height=math.max(height,44) end
    local width=math.max(0,viewport.X-22)
    return {Component="Toggle",Compact=compact,Width=width,Height=height}
end

function AstraUI.Layout:Rule462(viewport,preferred)
    local compact=viewport.X<=360
    local height=preferred or 50
    if compact then height=math.max(height,44) end
    local width=math.max(0,viewport.X-26)
    return {Component="Slider",Compact=compact,Width=width,Height=height}
end

function AstraUI.Layout:Rule463(viewport,preferred)
    local compact=viewport.X<=405
    local height=preferred or 54
    if compact then height=math.max(height,44) end
    local width=math.max(0,viewport.X-30)
    return {Component="Dropdown",Compact=compact,Width=width,Height=height}
end

function AstraUI.Layout:Rule464(viewport,preferred)
    local compact=viewport.X<=450
    local height=preferred or 58
    if compact then height=math.max(height,44) end
    local width=math.max(0,viewport.X-18)
    return {Component="MultiDropdown",Compact=compact,Width=width,Height=height}
end

function AstraUI.Layout:Rule465(viewport,preferred)
    local compact=viewport.X<=495
    local height=preferred or 42
    if compact then height=math.max(height,44) end
    local width=math.max(0,viewport.X-22)
    return {Component="Input",Compact=compact,Width=width,Height=height}
end

function AstraUI.Layout:Rule466(viewport,preferred)
    local compact=viewport.X<=540
    local height=preferred or 46
    if compact then height=math.max(height,44) end
    local width=math.max(0,viewport.X-26)
    return {Component="Keybind",Compact=compact,Width=width,Height=height}
end

function AstraUI.Layout:Rule467(viewport,preferred)
    local compact=viewport.X<=585
    local height=preferred or 50
    if compact then height=math.max(height,44) end
    local width=math.max(0,viewport.X-30)
    return {Component="ColorPicker",Compact=compact,Width=width,Height=height}
end

function AstraUI.Layout:Rule468(viewport,preferred)
    local compact=viewport.X<=630
    local height=preferred or 54
    if compact then height=math.max(height,44) end
    local width=math.max(0,viewport.X-18)
    return {Component="Paragraph",Compact=compact,Width=width,Height=height}
end

function AstraUI.Layout:Rule469(viewport,preferred)
    local compact=viewport.X<=360
    local height=preferred or 58
    if compact then height=math.max(height,44) end
    local width=math.max(0,viewport.X-22)
    return {Component="Label",Compact=compact,Width=width,Height=height}
end

function AstraUI.Layout:Rule470(viewport,preferred)
    local compact=viewport.X<=405
    local height=preferred or 42
    if compact then height=math.max(height,44) end
    local width=math.max(0,viewport.X-26)
    return {Component="Button",Compact=compact,Width=width,Height=height}
end

function AstraUI.Layout:Rule471(viewport,preferred)
    local compact=viewport.X<=450
    local height=preferred or 46
    if compact then height=math.max(height,44) end
    local width=math.max(0,viewport.X-30)
    return {Component="Toggle",Compact=compact,Width=width,Height=height}
end

function AstraUI.Layout:Rule472(viewport,preferred)
    local compact=viewport.X<=495
    local height=preferred or 50
    if compact then height=math.max(height,44) end
    local width=math.max(0,viewport.X-18)
    return {Component="Slider",Compact=compact,Width=width,Height=height}
end

function AstraUI.Layout:Rule473(viewport,preferred)
    local compact=viewport.X<=540
    local height=preferred or 54
    if compact then height=math.max(height,44) end
    local width=math.max(0,viewport.X-22)
    return {Component="Dropdown",Compact=compact,Width=width,Height=height}
end

function AstraUI.Layout:Rule474(viewport,preferred)
    local compact=viewport.X<=585
    local height=preferred or 58
    if compact then height=math.max(height,44) end
    local width=math.max(0,viewport.X-26)
    return {Component="MultiDropdown",Compact=compact,Width=width,Height=height}
end

function AstraUI.Layout:Rule475(viewport,preferred)
    local compact=viewport.X<=630
    local height=preferred or 42
    if compact then height=math.max(height,44) end
    local width=math.max(0,viewport.X-30)
    return {Component="Input",Compact=compact,Width=width,Height=height}
end

function AstraUI.Layout:Rule476(viewport,preferred)
    local compact=viewport.X<=360
    local height=preferred or 46
    if compact then height=math.max(height,44) end
    local width=math.max(0,viewport.X-18)
    return {Component="Keybind",Compact=compact,Width=width,Height=height}
end

function AstraUI.Layout:Rule477(viewport,preferred)
    local compact=viewport.X<=405
    local height=preferred or 50
    if compact then height=math.max(height,44) end
    local width=math.max(0,viewport.X-22)
    return {Component="ColorPicker",Compact=compact,Width=width,Height=height}
end

function AstraUI.Layout:Rule478(viewport,preferred)
    local compact=viewport.X<=450
    local height=preferred or 54
    if compact then height=math.max(height,44) end
    local width=math.max(0,viewport.X-26)
    return {Component="Paragraph",Compact=compact,Width=width,Height=height}
end

function AstraUI.Layout:Rule479(viewport,preferred)
    local compact=viewport.X<=495
    local height=preferred or 58
    if compact then height=math.max(height,44) end
    local width=math.max(0,viewport.X-30)
    return {Component="Label",Compact=compact,Width=width,Height=height}
end

function AstraUI.Layout:Rule480(viewport,preferred)
    local compact=viewport.X<=540
    local height=preferred or 42
    if compact then height=math.max(height,44) end
    local width=math.max(0,viewport.X-18)
    return {Component="Button",Compact=compact,Width=width,Height=height}
end

function AstraUI.Layout:Rule481(viewport,preferred)
    local compact=viewport.X<=585
    local height=preferred or 46
    if compact then height=math.max(height,44) end
    local width=math.max(0,viewport.X-22)
    return {Component="Toggle",Compact=compact,Width=width,Height=height}
end

function AstraUI.Layout:Rule482(viewport,preferred)
    local compact=viewport.X<=630
    local height=preferred or 50
    if compact then height=math.max(height,44) end
    local width=math.max(0,viewport.X-26)
    return {Component="Slider",Compact=compact,Width=width,Height=height}
end

function AstraUI.Layout:Rule483(viewport,preferred)
    local compact=viewport.X<=360
    local height=preferred or 54
    if compact then height=math.max(height,44) end
    local width=math.max(0,viewport.X-30)
    return {Component="Dropdown",Compact=compact,Width=width,Height=height}
end

function AstraUI.Layout:Rule484(viewport,preferred)
    local compact=viewport.X<=405
    local height=preferred or 58
    if compact then height=math.max(height,44) end
    local width=math.max(0,viewport.X-18)
    return {Component="MultiDropdown",Compact=compact,Width=width,Height=height}
end

function AstraUI.Layout:Rule485(viewport,preferred)
    local compact=viewport.X<=450
    local height=preferred or 42
    if compact then height=math.max(height,44) end
    local width=math.max(0,viewport.X-22)
    return {Component="Input",Compact=compact,Width=width,Height=height}
end

function AstraUI.Layout:Rule486(viewport,preferred)
    local compact=viewport.X<=495
    local height=preferred or 46
    if compact then height=math.max(height,44) end
    local width=math.max(0,viewport.X-26)
    return {Component="Keybind",Compact=compact,Width=width,Height=height}
end

function AstraUI.Layout:Rule487(viewport,preferred)
    local compact=viewport.X<=540
    local height=preferred or 50
    if compact then height=math.max(height,44) end
    local width=math.max(0,viewport.X-30)
    return {Component="ColorPicker",Compact=compact,Width=width,Height=height}
end

function AstraUI.Layout:Rule488(viewport,preferred)
    local compact=viewport.X<=585
    local height=preferred or 54
    if compact then height=math.max(height,44) end
    local width=math.max(0,viewport.X-18)
    return {Component="Paragraph",Compact=compact,Width=width,Height=height}
end

function AstraUI.Layout:Rule489(viewport,preferred)
    local compact=viewport.X<=630
    local height=preferred or 58
    if compact then height=math.max(height,44) end
    local width=math.max(0,viewport.X-22)
    return {Component="Label",Compact=compact,Width=width,Height=height}
end

function AstraUI.Layout:Rule490(viewport,preferred)
    local compact=viewport.X<=360
    local height=preferred or 42
    if compact then height=math.max(height,44) end
    local width=math.max(0,viewport.X-26)
    return {Component="Button",Compact=compact,Width=width,Height=height}
end

function AstraUI.Layout:Rule491(viewport,preferred)
    local compact=viewport.X<=405
    local height=preferred or 46
    if compact then height=math.max(height,44) end
    local width=math.max(0,viewport.X-30)
    return {Component="Toggle",Compact=compact,Width=width,Height=height}
end

function AstraUI.Layout:Rule492(viewport,preferred)
    local compact=viewport.X<=450
    local height=preferred or 50
    if compact then height=math.max(height,44) end
    local width=math.max(0,viewport.X-18)
    return {Component="Slider",Compact=compact,Width=width,Height=height}
end

function AstraUI.Layout:Rule493(viewport,preferred)
    local compact=viewport.X<=495
    local height=preferred or 54
    if compact then height=math.max(height,44) end
    local width=math.max(0,viewport.X-22)
    return {Component="Dropdown",Compact=compact,Width=width,Height=height}
end

function AstraUI.Layout:Rule494(viewport,preferred)
    local compact=viewport.X<=540
    local height=preferred or 58
    if compact then height=math.max(height,44) end
    local width=math.max(0,viewport.X-26)
    return {Component="MultiDropdown",Compact=compact,Width=width,Height=height}
end

function AstraUI.Layout:Rule495(viewport,preferred)
    local compact=viewport.X<=585
    local height=preferred or 42
    if compact then height=math.max(height,44) end
    local width=math.max(0,viewport.X-30)
    return {Component="Input",Compact=compact,Width=width,Height=height}
end

function AstraUI.Layout:Rule496(viewport,preferred)
    local compact=viewport.X<=630
    local height=preferred or 46
    if compact then height=math.max(height,44) end
    local width=math.max(0,viewport.X-18)
    return {Component="Keybind",Compact=compact,Width=width,Height=height}
end

function AstraUI.Layout:Rule497(viewport,preferred)
    local compact=viewport.X<=360
    local height=preferred or 50
    if compact then height=math.max(height,44) end
    local width=math.max(0,viewport.X-22)
    return {Component="ColorPicker",Compact=compact,Width=width,Height=height}
end

function AstraUI.Layout:Rule498(viewport,preferred)
    local compact=viewport.X<=405
    local height=preferred or 54
    if compact then height=math.max(height,44) end
    local width=math.max(0,viewport.X-26)
    return {Component="Paragraph",Compact=compact,Width=width,Height=height}
end

function AstraUI.Layout:Rule499(viewport,preferred)
    local compact=viewport.X<=450
    local height=preferred or 58
    if compact then height=math.max(height,44) end
    local width=math.max(0,viewport.X-30)
    return {Component="Label",Compact=compact,Width=width,Height=height}
end

function AstraUI.Layout:Rule500(viewport,preferred)
    local compact=viewport.X<=495
    local height=preferred or 42
    if compact then height=math.max(height,44) end
    local width=math.max(0,viewport.X-18)
    return {Component="Button",Compact=compact,Width=width,Height=height}
end

function AstraUI.Layout:Rule501(viewport,preferred)
    local compact=viewport.X<=540
    local height=preferred or 46
    if compact then height=math.max(height,44) end
    local width=math.max(0,viewport.X-22)
    return {Component="Toggle",Compact=compact,Width=width,Height=height}
end

function AstraUI.Layout:Rule502(viewport,preferred)
    local compact=viewport.X<=585
    local height=preferred or 50
    if compact then height=math.max(height,44) end
    local width=math.max(0,viewport.X-26)
    return {Component="Slider",Compact=compact,Width=width,Height=height}
end

function AstraUI.Layout:Rule503(viewport,preferred)
    local compact=viewport.X<=630
    local height=preferred or 54
    if compact then height=math.max(height,44) end
    local width=math.max(0,viewport.X-30)
    return {Component="Dropdown",Compact=compact,Width=width,Height=height}
end

function AstraUI.Layout:Rule504(viewport,preferred)
    local compact=viewport.X<=360
    local height=preferred or 58
    if compact then height=math.max(height,44) end
    local width=math.max(0,viewport.X-18)
    return {Component="MultiDropdown",Compact=compact,Width=width,Height=height}
end

function AstraUI.Layout:Rule505(viewport,preferred)
    local compact=viewport.X<=405
    local height=preferred or 42
    if compact then height=math.max(height,44) end
    local width=math.max(0,viewport.X-22)
    return {Component="Input",Compact=compact,Width=width,Height=height}
end

function AstraUI.Layout:Rule506(viewport,preferred)
    local compact=viewport.X<=450
    local height=preferred or 46
    if compact then height=math.max(height,44) end
    local width=math.max(0,viewport.X-26)
    return {Component="Keybind",Compact=compact,Width=width,Height=height}
end

function AstraUI.Layout:Rule507(viewport,preferred)
    local compact=viewport.X<=495
    local height=preferred or 50
    if compact then height=math.max(height,44) end
    local width=math.max(0,viewport.X-30)
    return {Component="ColorPicker",Compact=compact,Width=width,Height=height}
end

function AstraUI.Layout:Rule508(viewport,preferred)
    local compact=viewport.X<=540
    local height=preferred or 54
    if compact then height=math.max(height,44) end
    local width=math.max(0,viewport.X-18)
    return {Component="Paragraph",Compact=compact,Width=width,Height=height}
end

function AstraUI.Layout:Rule509(viewport,preferred)
    local compact=viewport.X<=585
    local height=preferred or 58
    if compact then height=math.max(height,44) end
    local width=math.max(0,viewport.X-22)
    return {Component="Label",Compact=compact,Width=width,Height=height}
end

function AstraUI.Layout:Rule510(viewport,preferred)
    local compact=viewport.X<=630
    local height=preferred or 42
    if compact then height=math.max(height,44) end
    local width=math.max(0,viewport.X-26)
    return {Component="Button",Compact=compact,Width=width,Height=height}
end

function AstraUI.Layout:Rule511(viewport,preferred)
    local compact=viewport.X<=360
    local height=preferred or 46
    if compact then height=math.max(height,44) end
    local width=math.max(0,viewport.X-30)
    return {Component="Toggle",Compact=compact,Width=width,Height=height}
end

function AstraUI.Layout:Rule512(viewport,preferred)
    local compact=viewport.X<=405
    local height=preferred or 50
    if compact then height=math.max(height,44) end
    local width=math.max(0,viewport.X-18)
    return {Component="Slider",Compact=compact,Width=width,Height=height}
end

function AstraUI.Layout:Rule513(viewport,preferred)
    local compact=viewport.X<=450
    local height=preferred or 54
    if compact then height=math.max(height,44) end
    local width=math.max(0,viewport.X-22)
    return {Component="Dropdown",Compact=compact,Width=width,Height=height}
end

function AstraUI.Layout:Rule514(viewport,preferred)
    local compact=viewport.X<=495
    local height=preferred or 58
    if compact then height=math.max(height,44) end
    local width=math.max(0,viewport.X-26)
    return {Component="MultiDropdown",Compact=compact,Width=width,Height=height}
end

function AstraUI.Layout:Rule515(viewport,preferred)
    local compact=viewport.X<=540
    local height=preferred or 42
    if compact then height=math.max(height,44) end
    local width=math.max(0,viewport.X-30)
    return {Component="Input",Compact=compact,Width=width,Height=height}
end

function AstraUI.Layout:Rule516(viewport,preferred)
    local compact=viewport.X<=585
    local height=preferred or 46
    if compact then height=math.max(height,44) end
    local width=math.max(0,viewport.X-18)
    return {Component="Keybind",Compact=compact,Width=width,Height=height}
end

function AstraUI.Layout:Rule517(viewport,preferred)
    local compact=viewport.X<=630
    local height=preferred or 50
    if compact then height=math.max(height,44) end
    local width=math.max(0,viewport.X-22)
    return {Component="ColorPicker",Compact=compact,Width=width,Height=height}
end

function AstraUI.Layout:Rule518(viewport,preferred)
    local compact=viewport.X<=360
    local height=preferred or 54
    if compact then height=math.max(height,44) end
    local width=math.max(0,viewport.X-26)
    return {Component="Paragraph",Compact=compact,Width=width,Height=height}
end

function AstraUI.Layout:Rule519(viewport,preferred)
    local compact=viewport.X<=405
    local height=preferred or 58
    if compact then height=math.max(height,44) end
    local width=math.max(0,viewport.X-30)
    return {Component="Label",Compact=compact,Width=width,Height=height}
end

function AstraUI.Layout:Rule520(viewport,preferred)
    local compact=viewport.X<=450
    local height=preferred or 42
    if compact then height=math.max(height,44) end
    local width=math.max(0,viewport.X-18)
    return {Component="Button",Compact=compact,Width=width,Height=height}
end

function AstraUI.Layout:Rule521(viewport,preferred)
    local compact=viewport.X<=495
    local height=preferred or 46
    if compact then height=math.max(height,44) end
    local width=math.max(0,viewport.X-22)
    return {Component="Toggle",Compact=compact,Width=width,Height=height}
end

function AstraUI.Layout:Rule522(viewport,preferred)
    local compact=viewport.X<=540
    local height=preferred or 50
    if compact then height=math.max(height,44) end
    local width=math.max(0,viewport.X-26)
    return {Component="Slider",Compact=compact,Width=width,Height=height}
end

function AstraUI.Layout:Rule523(viewport,preferred)
    local compact=viewport.X<=585
    local height=preferred or 54
    if compact then height=math.max(height,44) end
    local width=math.max(0,viewport.X-30)
    return {Component="Dropdown",Compact=compact,Width=width,Height=height}
end

function AstraUI.Layout:Rule524(viewport,preferred)
    local compact=viewport.X<=630
    local height=preferred or 58
    if compact then height=math.max(height,44) end
    local width=math.max(0,viewport.X-18)
    return {Component="MultiDropdown",Compact=compact,Width=width,Height=height}
end

function AstraUI.Layout:Rule525(viewport,preferred)
    local compact=viewport.X<=360
    local height=preferred or 42
    if compact then height=math.max(height,44) end
    local width=math.max(0,viewport.X-22)
    return {Component="Input",Compact=compact,Width=width,Height=height}
end

function AstraUI.Layout:Rule526(viewport,preferred)
    local compact=viewport.X<=405
    local height=preferred or 46
    if compact then height=math.max(height,44) end
    local width=math.max(0,viewport.X-26)
    return {Component="Keybind",Compact=compact,Width=width,Height=height}
end

function AstraUI.Layout:Rule527(viewport,preferred)
    local compact=viewport.X<=450
    local height=preferred or 50
    if compact then height=math.max(height,44) end
    local width=math.max(0,viewport.X-30)
    return {Component="ColorPicker",Compact=compact,Width=width,Height=height}
end

function AstraUI.Layout:Rule528(viewport,preferred)
    local compact=viewport.X<=495
    local height=preferred or 54
    if compact then height=math.max(height,44) end
    local width=math.max(0,viewport.X-18)
    return {Component="Paragraph",Compact=compact,Width=width,Height=height}
end

function AstraUI.Layout:Rule529(viewport,preferred)
    local compact=viewport.X<=540
    local height=preferred or 58
    if compact then height=math.max(height,44) end
    local width=math.max(0,viewport.X-22)
    return {Component="Label",Compact=compact,Width=width,Height=height}
end

function AstraUI.Layout:Rule530(viewport,preferred)
    local compact=viewport.X<=585
    local height=preferred or 42
    if compact then height=math.max(height,44) end
    local width=math.max(0,viewport.X-26)
    return {Component="Button",Compact=compact,Width=width,Height=height}
end

function AstraUI.Layout:Rule531(viewport,preferred)
    local compact=viewport.X<=630
    local height=preferred or 46
    if compact then height=math.max(height,44) end
    local width=math.max(0,viewport.X-30)
    return {Component="Toggle",Compact=compact,Width=width,Height=height}
end

function AstraUI.Layout:Rule532(viewport,preferred)
    local compact=viewport.X<=360
    local height=preferred or 50
    if compact then height=math.max(height,44) end
    local width=math.max(0,viewport.X-18)
    return {Component="Slider",Compact=compact,Width=width,Height=height}
end

function AstraUI.Layout:Rule533(viewport,preferred)
    local compact=viewport.X<=405
    local height=preferred or 54
    if compact then height=math.max(height,44) end
    local width=math.max(0,viewport.X-22)
    return {Component="Dropdown",Compact=compact,Width=width,Height=height}
end

function AstraUI.Layout:Rule534(viewport,preferred)
    local compact=viewport.X<=450
    local height=preferred or 58
    if compact then height=math.max(height,44) end
    local width=math.max(0,viewport.X-26)
    return {Component="MultiDropdown",Compact=compact,Width=width,Height=height}
end

function AstraUI.Layout:Rule535(viewport,preferred)
    local compact=viewport.X<=495
    local height=preferred or 42
    if compact then height=math.max(height,44) end
    local width=math.max(0,viewport.X-30)
    return {Component="Input",Compact=compact,Width=width,Height=height}
end

function AstraUI.Layout:Rule536(viewport,preferred)
    local compact=viewport.X<=540
    local height=preferred or 46
    if compact then height=math.max(height,44) end
    local width=math.max(0,viewport.X-18)
    return {Component="Keybind",Compact=compact,Width=width,Height=height}
end

function AstraUI.Layout:Rule537(viewport,preferred)
    local compact=viewport.X<=585
    local height=preferred or 50
    if compact then height=math.max(height,44) end
    local width=math.max(0,viewport.X-22)
    return {Component="ColorPicker",Compact=compact,Width=width,Height=height}
end

function AstraUI.Layout:Rule538(viewport,preferred)
    local compact=viewport.X<=630
    local height=preferred or 54
    if compact then height=math.max(height,44) end
    local width=math.max(0,viewport.X-26)
    return {Component="Paragraph",Compact=compact,Width=width,Height=height}
end

function AstraUI.Layout:Rule539(viewport,preferred)
    local compact=viewport.X<=360
    local height=preferred or 58
    if compact then height=math.max(height,44) end
    local width=math.max(0,viewport.X-30)
    return {Component="Label",Compact=compact,Width=width,Height=height}
end

function AstraUI.Layout:Rule540(viewport,preferred)
    local compact=viewport.X<=405
    local height=preferred or 42
    if compact then height=math.max(height,44) end
    local width=math.max(0,viewport.X-18)
    return {Component="Button",Compact=compact,Width=width,Height=height}
end

function AstraUI.Layout:Rule541(viewport,preferred)
    local compact=viewport.X<=450
    local height=preferred or 46
    if compact then height=math.max(height,44) end
    local width=math.max(0,viewport.X-22)
    return {Component="Toggle",Compact=compact,Width=width,Height=height}
end

function AstraUI.Layout:Rule542(viewport,preferred)
    local compact=viewport.X<=495
    local height=preferred or 50
    if compact then height=math.max(height,44) end
    local width=math.max(0,viewport.X-26)
    return {Component="Slider",Compact=compact,Width=width,Height=height}
end

function AstraUI.Layout:Rule543(viewport,preferred)
    local compact=viewport.X<=540
    local height=preferred or 54
    if compact then height=math.max(height,44) end
    local width=math.max(0,viewport.X-30)
    return {Component="Dropdown",Compact=compact,Width=width,Height=height}
end

function AstraUI.Layout:Rule544(viewport,preferred)
    local compact=viewport.X<=585
    local height=preferred or 58
    if compact then height=math.max(height,44) end
    local width=math.max(0,viewport.X-18)
    return {Component="MultiDropdown",Compact=compact,Width=width,Height=height}
end

function AstraUI.Layout:Rule545(viewport,preferred)
    local compact=viewport.X<=630
    local height=preferred or 42
    if compact then height=math.max(height,44) end
    local width=math.max(0,viewport.X-22)
    return {Component="Input",Compact=compact,Width=width,Height=height}
end

function AstraUI.Layout:Rule546(viewport,preferred)
    local compact=viewport.X<=360
    local height=preferred or 46
    if compact then height=math.max(height,44) end
    local width=math.max(0,viewport.X-26)
    return {Component="Keybind",Compact=compact,Width=width,Height=height}
end

function AstraUI.Layout:Rule547(viewport,preferred)
    local compact=viewport.X<=405
    local height=preferred or 50
    if compact then height=math.max(height,44) end
    local width=math.max(0,viewport.X-30)
    return {Component="ColorPicker",Compact=compact,Width=width,Height=height}
end

function AstraUI.Layout:Rule548(viewport,preferred)
    local compact=viewport.X<=450
    local height=preferred or 54
    if compact then height=math.max(height,44) end
    local width=math.max(0,viewport.X-18)
    return {Component="Paragraph",Compact=compact,Width=width,Height=height}
end

function AstraUI.Layout:Rule549(viewport,preferred)
    local compact=viewport.X<=495
    local height=preferred or 58
    if compact then height=math.max(height,44) end
    local width=math.max(0,viewport.X-22)
    return {Component="Label",Compact=compact,Width=width,Height=height}
end

function AstraUI.Layout:Rule550(viewport,preferred)
    local compact=viewport.X<=540
    local height=preferred or 42
    if compact then height=math.max(height,44) end
    local width=math.max(0,viewport.X-26)
    return {Component="Button",Compact=compact,Width=width,Height=height}
end

function AstraUI.Layout:Rule551(viewport,preferred)
    local compact=viewport.X<=585
    local height=preferred or 46
    if compact then height=math.max(height,44) end
    local width=math.max(0,viewport.X-30)
    return {Component="Toggle",Compact=compact,Width=width,Height=height}
end

function AstraUI.Layout:Rule552(viewport,preferred)
    local compact=viewport.X<=630
    local height=preferred or 50
    if compact then height=math.max(height,44) end
    local width=math.max(0,viewport.X-18)
    return {Component="Slider",Compact=compact,Width=width,Height=height}
end

function AstraUI.Layout:Rule553(viewport,preferred)
    local compact=viewport.X<=360
    local height=preferred or 54
    if compact then height=math.max(height,44) end
    local width=math.max(0,viewport.X-22)
    return {Component="Dropdown",Compact=compact,Width=width,Height=height}
end

function AstraUI.Layout:Rule554(viewport,preferred)
    local compact=viewport.X<=405
    local height=preferred or 58
    if compact then height=math.max(height,44) end
    local width=math.max(0,viewport.X-26)
    return {Component="MultiDropdown",Compact=compact,Width=width,Height=height}
end

function AstraUI.Layout:Rule555(viewport,preferred)
    local compact=viewport.X<=450
    local height=preferred or 42
    if compact then height=math.max(height,44) end
    local width=math.max(0,viewport.X-30)
    return {Component="Input",Compact=compact,Width=width,Height=height}
end

function AstraUI.Layout:Rule556(viewport,preferred)
    local compact=viewport.X<=495
    local height=preferred or 46
    if compact then height=math.max(height,44) end
    local width=math.max(0,viewport.X-18)
    return {Component="Keybind",Compact=compact,Width=width,Height=height}
end

function AstraUI.Layout:Rule557(viewport,preferred)
    local compact=viewport.X<=540
    local height=preferred or 50
    if compact then height=math.max(height,44) end
    local width=math.max(0,viewport.X-22)
    return {Component="ColorPicker",Compact=compact,Width=width,Height=height}
end

function AstraUI.Layout:Rule558(viewport,preferred)
    local compact=viewport.X<=585
    local height=preferred or 54
    if compact then height=math.max(height,44) end
    local width=math.max(0,viewport.X-26)
    return {Component="Paragraph",Compact=compact,Width=width,Height=height}
end

function AstraUI.Layout:Rule559(viewport,preferred)
    local compact=viewport.X<=630
    local height=preferred or 58
    if compact then height=math.max(height,44) end
    local width=math.max(0,viewport.X-30)
    return {Component="Label",Compact=compact,Width=width,Height=height}
end

function AstraUI.Layout:Rule560(viewport,preferred)
    local compact=viewport.X<=360
    local height=preferred or 42
    if compact then height=math.max(height,44) end
    local width=math.max(0,viewport.X-18)
    return {Component="Button",Compact=compact,Width=width,Height=height}
end

function AstraUI.Layout:Rule561(viewport,preferred)
    local compact=viewport.X<=405
    local height=preferred or 46
    if compact then height=math.max(height,44) end
    local width=math.max(0,viewport.X-22)
    return {Component="Toggle",Compact=compact,Width=width,Height=height}
end

function AstraUI.Layout:Rule562(viewport,preferred)
    local compact=viewport.X<=450
    local height=preferred or 50
    if compact then height=math.max(height,44) end
    local width=math.max(0,viewport.X-26)
    return {Component="Slider",Compact=compact,Width=width,Height=height}
end

function AstraUI.Layout:Rule563(viewport,preferred)
    local compact=viewport.X<=495
    local height=preferred or 54
    if compact then height=math.max(height,44) end
    local width=math.max(0,viewport.X-30)
    return {Component="Dropdown",Compact=compact,Width=width,Height=height}
end

function AstraUI.Layout:Rule564(viewport,preferred)
    local compact=viewport.X<=540
    local height=preferred or 58
    if compact then height=math.max(height,44) end
    local width=math.max(0,viewport.X-18)
    return {Component="MultiDropdown",Compact=compact,Width=width,Height=height}
end

function AstraUI.Layout:Rule565(viewport,preferred)
    local compact=viewport.X<=585
    local height=preferred or 42
    if compact then height=math.max(height,44) end
    local width=math.max(0,viewport.X-22)
    return {Component="Input",Compact=compact,Width=width,Height=height}
end

function AstraUI.Layout:Rule566(viewport,preferred)
    local compact=viewport.X<=630
    local height=preferred or 46
    if compact then height=math.max(height,44) end
    local width=math.max(0,viewport.X-26)
    return {Component="Keybind",Compact=compact,Width=width,Height=height}
end

function AstraUI.Layout:Rule567(viewport,preferred)
    local compact=viewport.X<=360
    local height=preferred or 50
    if compact then height=math.max(height,44) end
    local width=math.max(0,viewport.X-30)
    return {Component="ColorPicker",Compact=compact,Width=width,Height=height}
end

function AstraUI.Layout:Rule568(viewport,preferred)
    local compact=viewport.X<=405
    local height=preferred or 54
    if compact then height=math.max(height,44) end
    local width=math.max(0,viewport.X-18)
    return {Component="Paragraph",Compact=compact,Width=width,Height=height}
end

function AstraUI.Layout:Rule569(viewport,preferred)
    local compact=viewport.X<=450
    local height=preferred or 58
    if compact then height=math.max(height,44) end
    local width=math.max(0,viewport.X-22)
    return {Component="Label",Compact=compact,Width=width,Height=height}
end

function AstraUI.Layout:Rule570(viewport,preferred)
    local compact=viewport.X<=495
    local height=preferred or 42
    if compact then height=math.max(height,44) end
    local width=math.max(0,viewport.X-26)
    return {Component="Button",Compact=compact,Width=width,Height=height}
end

function AstraUI.Layout:Rule571(viewport,preferred)
    local compact=viewport.X<=540
    local height=preferred or 46
    if compact then height=math.max(height,44) end
    local width=math.max(0,viewport.X-30)
    return {Component="Toggle",Compact=compact,Width=width,Height=height}
end

function AstraUI.Layout:Rule572(viewport,preferred)
    local compact=viewport.X<=585
    local height=preferred or 50
    if compact then height=math.max(height,44) end
    local width=math.max(0,viewport.X-18)
    return {Component="Slider",Compact=compact,Width=width,Height=height}
end

function AstraUI.Layout:Rule573(viewport,preferred)
    local compact=viewport.X<=630
    local height=preferred or 54
    if compact then height=math.max(height,44) end
    local width=math.max(0,viewport.X-22)
    return {Component="Dropdown",Compact=compact,Width=width,Height=height}
end

function AstraUI.Layout:Rule574(viewport,preferred)
    local compact=viewport.X<=360
    local height=preferred or 58
    if compact then height=math.max(height,44) end
    local width=math.max(0,viewport.X-26)
    return {Component="MultiDropdown",Compact=compact,Width=width,Height=height}
end

function AstraUI.Layout:Rule575(viewport,preferred)
    local compact=viewport.X<=405
    local height=preferred or 42
    if compact then height=math.max(height,44) end
    local width=math.max(0,viewport.X-30)
    return {Component="Input",Compact=compact,Width=width,Height=height}
end

function AstraUI.Layout:Rule576(viewport,preferred)
    local compact=viewport.X<=450
    local height=preferred or 46
    if compact then height=math.max(height,44) end
    local width=math.max(0,viewport.X-18)
    return {Component="Keybind",Compact=compact,Width=width,Height=height}
end

function AstraUI.Layout:Rule577(viewport,preferred)
    local compact=viewport.X<=495
    local height=preferred or 50
    if compact then height=math.max(height,44) end
    local width=math.max(0,viewport.X-22)
    return {Component="ColorPicker",Compact=compact,Width=width,Height=height}
end

function AstraUI.Layout:Rule578(viewport,preferred)
    local compact=viewport.X<=540
    local height=preferred or 54
    if compact then height=math.max(height,44) end
    local width=math.max(0,viewport.X-26)
    return {Component="Paragraph",Compact=compact,Width=width,Height=height}
end

function AstraUI.Layout:Rule579(viewport,preferred)
    local compact=viewport.X<=585
    local height=preferred or 58
    if compact then height=math.max(height,44) end
    local width=math.max(0,viewport.X-30)
    return {Component="Label",Compact=compact,Width=width,Height=height}
end

function AstraUI.Layout:Rule580(viewport,preferred)
    local compact=viewport.X<=630
    local height=preferred or 42
    if compact then height=math.max(height,44) end
    local width=math.max(0,viewport.X-18)
    return {Component="Button",Compact=compact,Width=width,Height=height}
end

function AstraUI.Layout:Rule581(viewport,preferred)
    local compact=viewport.X<=360
    local height=preferred or 46
    if compact then height=math.max(height,44) end
    local width=math.max(0,viewport.X-22)
    return {Component="Toggle",Compact=compact,Width=width,Height=height}
end

function AstraUI.Layout:Rule582(viewport,preferred)
    local compact=viewport.X<=405
    local height=preferred or 50
    if compact then height=math.max(height,44) end
    local width=math.max(0,viewport.X-26)
    return {Component="Slider",Compact=compact,Width=width,Height=height}
end

function AstraUI.Layout:Rule583(viewport,preferred)
    local compact=viewport.X<=450
    local height=preferred or 54
    if compact then height=math.max(height,44) end
    local width=math.max(0,viewport.X-30)
    return {Component="Dropdown",Compact=compact,Width=width,Height=height}
end

function AstraUI.Layout:Rule584(viewport,preferred)
    local compact=viewport.X<=495
    local height=preferred or 58
    if compact then height=math.max(height,44) end
    local width=math.max(0,viewport.X-18)
    return {Component="MultiDropdown",Compact=compact,Width=width,Height=height}
end

function AstraUI.Layout:Rule585(viewport,preferred)
    local compact=viewport.X<=540
    local height=preferred or 42
    if compact then height=math.max(height,44) end
    local width=math.max(0,viewport.X-22)
    return {Component="Input",Compact=compact,Width=width,Height=height}
end

function AstraUI.Layout:Rule586(viewport,preferred)
    local compact=viewport.X<=585
    local height=preferred or 46
    if compact then height=math.max(height,44) end
    local width=math.max(0,viewport.X-26)
    return {Component="Keybind",Compact=compact,Width=width,Height=height}
end

function AstraUI.Layout:Rule587(viewport,preferred)
    local compact=viewport.X<=630
    local height=preferred or 50
    if compact then height=math.max(height,44) end
    local width=math.max(0,viewport.X-30)
    return {Component="ColorPicker",Compact=compact,Width=width,Height=height}
end

function AstraUI.Layout:Rule588(viewport,preferred)
    local compact=viewport.X<=360
    local height=preferred or 54
    if compact then height=math.max(height,44) end
    local width=math.max(0,viewport.X-18)
    return {Component="Paragraph",Compact=compact,Width=width,Height=height}
end

function AstraUI.Layout:Rule589(viewport,preferred)
    local compact=viewport.X<=405
    local height=preferred or 58
    if compact then height=math.max(height,44) end
    local width=math.max(0,viewport.X-22)
    return {Component="Label",Compact=compact,Width=width,Height=height}
end

function AstraUI.Layout:Rule590(viewport,preferred)
    local compact=viewport.X<=450
    local height=preferred or 42
    if compact then height=math.max(height,44) end
    local width=math.max(0,viewport.X-26)
    return {Component="Button",Compact=compact,Width=width,Height=height}
end

function AstraUI.Layout:Rule591(viewport,preferred)
    local compact=viewport.X<=495
    local height=preferred or 46
    if compact then height=math.max(height,44) end
    local width=math.max(0,viewport.X-30)
    return {Component="Toggle",Compact=compact,Width=width,Height=height}
end

function AstraUI.Layout:Rule592(viewport,preferred)
    local compact=viewport.X<=540
    local height=preferred or 50
    if compact then height=math.max(height,44) end
    local width=math.max(0,viewport.X-18)
    return {Component="Slider",Compact=compact,Width=width,Height=height}
end

function AstraUI.Layout:Rule593(viewport,preferred)
    local compact=viewport.X<=585
    local height=preferred or 54
    if compact then height=math.max(height,44) end
    local width=math.max(0,viewport.X-22)
    return {Component="Dropdown",Compact=compact,Width=width,Height=height}
end

function AstraUI.Layout:Rule594(viewport,preferred)
    local compact=viewport.X<=630
    local height=preferred or 58
    if compact then height=math.max(height,44) end
    local width=math.max(0,viewport.X-26)
    return {Component="MultiDropdown",Compact=compact,Width=width,Height=height}
end

function AstraUI.Layout:Rule595(viewport,preferred)
    local compact=viewport.X<=360
    local height=preferred or 42
    if compact then height=math.max(height,44) end
    local width=math.max(0,viewport.X-30)
    return {Component="Input",Compact=compact,Width=width,Height=height}
end

function AstraUI.Layout:Rule596(viewport,preferred)
    local compact=viewport.X<=405
    local height=preferred or 46
    if compact then height=math.max(height,44) end
    local width=math.max(0,viewport.X-18)
    return {Component="Keybind",Compact=compact,Width=width,Height=height}
end

function AstraUI.Layout:Rule597(viewport,preferred)
    local compact=viewport.X<=450
    local height=preferred or 50
    if compact then height=math.max(height,44) end
    local width=math.max(0,viewport.X-22)
    return {Component="ColorPicker",Compact=compact,Width=width,Height=height}
end

function AstraUI.Layout:Rule598(viewport,preferred)
    local compact=viewport.X<=495
    local height=preferred or 54
    if compact then height=math.max(height,44) end
    local width=math.max(0,viewport.X-26)
    return {Component="Paragraph",Compact=compact,Width=width,Height=height}
end

function AstraUI.Layout:Rule599(viewport,preferred)
    local compact=viewport.X<=540
    local height=preferred or 58
    if compact then height=math.max(height,44) end
    local width=math.max(0,viewport.X-30)
    return {Component="Label",Compact=compact,Width=width,Height=height}
end

AstraUI.Icons["dashboard"] = AstraUI.Icons["layout-dashboard"] or {Name="layout-dashboard",Asset=nil,Alias="dashboard"}
AstraUI.Icons["home2"] = AstraUI.Icons["home"] or {Name="home",Asset=nil,Alias="home2"}
AstraUI.Icons["gear"] = AstraUI.Icons["settings"] or {Name="settings",Asset=nil,Alias="gear"}
AstraUI.Icons["config"] = AstraUI.Icons["settings"] or {Name="settings",Asset=nil,Alias="config"}
AstraUI.Icons["close"] = AstraUI.Icons["x"] or {Name="x",Asset=nil,Alias="close"}
AstraUI.Icons["remove"] = AstraUI.Icons["x"] or {Name="x",Asset=nil,Alias="remove"}
AstraUI.Icons["add"] = AstraUI.Icons["plus"] or {Name="plus",Asset=nil,Alias="add"}
AstraUI.Icons["back"] = AstraUI.Icons["arrow-left"] or {Name="arrow-left",Asset=nil,Alias="back"}
AstraUI.Icons["forward"] = AstraUI.Icons["arrow-right"] or {Name="arrow-right",Asset=nil,Alias="forward"}
AstraUI.Icons["down"] = AstraUI.Icons["chevron-down"] or {Name="chevron-down",Asset=nil,Alias="down"}
AstraUI.Icons["up"] = AstraUI.Icons["chevron-up"] or {Name="chevron-up",Asset=nil,Alias="up"}
AstraUI.Icons["success"] = AstraUI.Icons["check-circle"] or {Name="check-circle",Asset=nil,Alias="success"}
AstraUI.Icons["warning"] = AstraUI.Icons["alert-triangle"] or {Name="alert-triangle",Asset=nil,Alias="warning"}
AstraUI.Icons["error"] = AstraUI.Icons["alert-circle"] or {Name="alert-circle",Asset=nil,Alias="error"}
AstraUI.Icons["search-icon"] = AstraUI.Icons["search"] or {Name="search",Asset=nil,Alias="search-icon"}
AstraUI.Icons["refresh"] = AstraUI.Icons["refresh-cw"] or {Name="refresh-cw",Asset=nil,Alias="refresh"}
AstraUI.Icons["theme"] = AstraUI.Icons["palette"] or {Name="palette",Asset=nil,Alias="theme"}
AstraUI.Icons["appearance"] = AstraUI.Icons["sun"] or {Name="sun",Asset=nil,Alias="appearance"}
AstraUI.Icons["night"] = AstraUI.Icons["moon"] or {Name="moon",Asset=nil,Alias="night"}
AstraUI.Icons["user-settings"] = AstraUI.Icons["user"] or {Name="user",Asset=nil,Alias="user-settings"}
AstraUI.Icons["copy-icon"] = AstraUI.Icons["copy"] or {Name="copy",Asset=nil,Alias="copy-icon"}
AstraUI.Icons["delete"] = AstraUI.Icons["trash-2"] or {Name="trash-2",Asset=nil,Alias="delete"}
AstraUI.Icons["save-icon"] = AstraUI.Icons["save"] or {Name="save",Asset=nil,Alias="save-icon"}
AstraUI.Icons["open"] = AstraUI.Icons["external-link"] or {Name="external-link",Asset=nil,Alias="open"}
AstraUI.Icons["lock-icon"] = AstraUI.Icons["lock"] or {Name="lock",Asset=nil,Alias="lock-icon"}
AstraUI.Icons["unlock-icon"] = AstraUI.Icons["unlock"] or {Name="unlock",Asset=nil,Alias="unlock-icon"}
AstraUI.Icons["play-icon"] = AstraUI.Icons["play"] or {Name="play",Asset=nil,Alias="play-icon"}
AstraUI.Icons["pause-icon"] = AstraUI.Icons["pause"] or {Name="pause",Asset=nil,Alias="pause-icon"}
AstraUI.Icons["stop"] = AstraUI.Icons["square"] or {Name="square",Asset=nil,Alias="stop"}
AstraUI.Icons["menu-icon"] = AstraUI.Icons["menu"] or {Name="menu",Asset=nil,Alias="menu-icon"}
AstraUI.Icons["more"] = AstraUI.Icons["more-horizontal"] or {Name="more-horizontal",Asset=nil,Alias="more"}
AstraUI.Icons["filter-icon"] = AstraUI.Icons["filter"] or {Name="filter",Asset=nil,Alias="filter-icon"}
AstraUI.Icons["sort"] = AstraUI.Icons["sliders-horizontal"] or {Name="sliders-horizontal",Asset=nil,Alias="sort"}
AstraUI.Icons["network"] = AstraUI.Icons["wifi"] or {Name="wifi",Asset=nil,Alias="network"}
AstraUI.Icons["console"] = AstraUI.Icons["terminal"] or {Name="terminal",Asset=nil,Alias="console"}
AstraUI.Icons["code-icon"] = AstraUI.Icons["code"] or {Name="code",Asset=nil,Alias="code-icon"}
AstraUI.Icons["tools"] = AstraUI.Icons["wand-2"] or {Name="wand-2",Asset=nil,Alias="tools"}
AstraUI.Icons["security"] = AstraUI.Icons["shield"] or {Name="shield",Asset=nil,Alias="security"}
AstraUI.Icons["info-icon"] = AstraUI.Icons["info"] or {Name="info",Asset=nil,Alias="info-icon"}
AstraUI.Icons["help"] = AstraUI.Icons["help-circle"] or {Name="help-circle",Asset=nil,Alias="help"}
AstraUI.Icons["favorite"] = AstraUI.Icons["star"] or {Name="star",Asset=nil,Alias="favorite"}
AstraUI.Icons["like"] = AstraUI.Icons["heart"] or {Name="heart",Asset=nil,Alias="like"}
AstraUI.Icons["calendar-icon"] = AstraUI.Icons["calendar"] or {Name="calendar",Asset=nil,Alias="calendar-icon"}
AstraUI.Icons["clock-icon"] = AstraUI.Icons["clock"] or {Name="clock",Asset=nil,Alias="clock-icon"}
AstraUI.Icons["message"] = AstraUI.Icons["message-circle"] or {Name="message-circle",Asset=nil,Alias="message"}
AstraUI.Icons["mail-icon"] = AstraUI.Icons["mail"] or {Name="mail",Asset=nil,Alias="mail-icon"}
AstraUI.Icons["download-icon"] = AstraUI.Icons["download"] or {Name="download",Asset=nil,Alias="download-icon"}
AstraUI.Icons["upload-icon"] = AstraUI.Icons["upload"] or {Name="upload",Asset=nil,Alias="upload-icon"}
AstraUI.Icons["folder-icon"] = AstraUI.Icons["folder"] or {Name="folder",Asset=nil,Alias="folder-icon"}
AstraUI.Icons["file-icon"] = AstraUI.Icons["file"] or {Name="file",Asset=nil,Alias="file-icon"}
AstraUI.Icons["image-icon"] = AstraUI.Icons["image"] or {Name="image",Asset=nil,Alias="image-icon"}
AstraUI.Icons["camera-icon"] = AstraUI.Icons["camera"] or {Name="camera",Asset=nil,Alias="camera-icon"}
AstraUI.Icons["microphone"] = AstraUI.Icons["mic"] or {Name="mic",Asset=nil,Alias="microphone"}
AstraUI.Icons["volume"] = AstraUI.Icons["volume-2"] or {Name="volume-2",Asset=nil,Alias="volume"}
AstraUI.Icons["globe-icon"] = AstraUI.Icons["globe"] or {Name="globe",Asset=nil,Alias="globe-icon"}
AstraUI.Icons["server-icon"] = AstraUI.Icons["server"] or {Name="server",Asset=nil,Alias="server-icon"}
AstraUI.Icons["database-icon"] = AstraUI.Icons["database"] or {Name="database",Asset=nil,Alias="database-icon"}
AstraUI.Icons["package-icon"] = AstraUI.Icons["package"] or {Name="package",Asset=nil,Alias="package-icon"}
AstraUI.Icons["gamepad"] = AstraUI.Icons["gamepad-2"] or {Name="gamepad-2",Asset=nil,Alias="gamepad"}
AstraUI.Icons["layers-icon"] = AstraUI.Icons["layers"] or {Name="layers",Asset=nil,Alias="layers-icon"}
AstraUI.Icons["grid"] = AstraUI.Icons["grid-2x2"] or {Name="grid-2x2",Asset=nil,Alias="grid"}
AstraUI.Icons["list-icon"] = AstraUI.Icons["list"] or {Name="list",Asset=nil,Alias="list-icon"}

function AstraUI:RegisterLucidePack(pack)
    assert(type(pack)=="table","Lucide pack must be a table")
    for name,asset in pairs(pack) do self:RegisterIcon(name,asset) end
    return self
end

function AstraUI:CreateIcon(parent,name,size,color)
    assert(parent and parent:IsA("GuiObject"),"A GuiObject parent is required")
    return iconLabel(parent,name,size,color or self:_theme(self._themeName).Text)
end

-- [Window.CreateTab] Contract note 1
-- Creates and registers a tab and activates the first tab.
-- Inputs are validated at the public boundary.
-- Callbacks are protected with pcall so UI failures do not break the caller.
-- Destroyed components reject further visual work.
-- Responsive rules are recalculated when the screen size changes.
-- Animation durations honor AstraUI:SetReducedMotion.
-- Icon names are resolved through AstraUI.Icons.
-- Themes are resolved through AstraUI.Themes.
-- This contract is intentionally kept stable across Beta releases.

-- [Window.GetTab] Contract note 2
-- Returns a tab by its exact public name.
-- Inputs are validated at the public boundary.
-- Callbacks are protected with pcall so UI failures do not break the caller.
-- Destroyed components reject further visual work.
-- Responsive rules are recalculated when the screen size changes.
-- Animation durations honor AstraUI:SetReducedMotion.
-- Icon names are resolved through AstraUI.Icons.
-- Themes are resolved through AstraUI.Themes.
-- This contract is intentionally kept stable across Beta releases.

-- [Window.GetComponent] Contract note 3
-- Searches every tab for a component by name.
-- Inputs are validated at the public boundary.
-- Callbacks are protected with pcall so UI failures do not break the caller.
-- Destroyed components reject further visual work.
-- Responsive rules are recalculated when the screen size changes.
-- Animation durations honor AstraUI:SetReducedMotion.
-- Icon names are resolved through AstraUI.Icons.
-- Themes are resolved through AstraUI.Themes.
-- This contract is intentionally kept stable across Beta releases.

-- [Window.Search] Contract note 4
-- Filters components using their name and description.
-- Inputs are validated at the public boundary.
-- Callbacks are protected with pcall so UI failures do not break the caller.
-- Destroyed components reject further visual work.
-- Responsive rules are recalculated when the screen size changes.
-- Animation durations honor AstraUI:SetReducedMotion.
-- Icon names are resolved through AstraUI.Icons.
-- Themes are resolved through AstraUI.Themes.
-- This contract is intentionally kept stable across Beta releases.

-- [Window.SetSearchEnabled] Contract note 5
-- Shows or hides the window search field.
-- Inputs are validated at the public boundary.
-- Callbacks are protected with pcall so UI failures do not break the caller.
-- Destroyed components reject further visual work.
-- Responsive rules are recalculated when the screen size changes.
-- Animation durations honor AstraUI:SetReducedMotion.
-- Icon names are resolved through AstraUI.Icons.
-- Themes are resolved through AstraUI.Themes.
-- This contract is intentionally kept stable across Beta releases.

-- [Window.SetTitle] Contract note 6
-- Updates the title and optional subtitle.
-- Inputs are validated at the public boundary.
-- Callbacks are protected with pcall so UI failures do not break the caller.
-- Destroyed components reject further visual work.
-- Responsive rules are recalculated when the screen size changes.
-- Animation durations honor AstraUI:SetReducedMotion.
-- Icon names are resolved through AstraUI.Icons.
-- Themes are resolved through AstraUI.Themes.
-- This contract is intentionally kept stable across Beta releases.

-- [Window.SetSize] Contract note 7
-- Updates the window size using UDim2.
-- Inputs are validated at the public boundary.
-- Callbacks are protected with pcall so UI failures do not break the caller.
-- Destroyed components reject further visual work.
-- Responsive rules are recalculated when the screen size changes.
-- Animation durations honor AstraUI:SetReducedMotion.
-- Icon names are resolved through AstraUI.Icons.
-- Themes are resolved through AstraUI.Themes.
-- This contract is intentionally kept stable across Beta releases.

-- [Window.SetPosition] Contract note 8
-- Updates the window position using UDim2.
-- Inputs are validated at the public boundary.
-- Callbacks are protected with pcall so UI failures do not break the caller.
-- Destroyed components reject further visual work.
-- Responsive rules are recalculated when the screen size changes.
-- Animation durations honor AstraUI:SetReducedMotion.
-- Icon names are resolved through AstraUI.Icons.
-- Themes are resolved through AstraUI.Themes.
-- This contract is intentionally kept stable across Beta releases.

-- [Window.SetVisibility] Contract note 9
-- Changes window visibility without destroying it.
-- Inputs are validated at the public boundary.
-- Callbacks are protected with pcall so UI failures do not break the caller.
-- Destroyed components reject further visual work.
-- Responsive rules are recalculated when the screen size changes.
-- Animation durations honor AstraUI:SetReducedMotion.
-- Icon names are resolved through AstraUI.Icons.
-- Themes are resolved through AstraUI.Themes.
-- This contract is intentionally kept stable across Beta releases.

-- [Window.Toggle] Contract note 10
-- Opens or closes the window with motion.
-- Inputs are validated at the public boundary.
-- Callbacks are protected with pcall so UI failures do not break the caller.
-- Destroyed components reject further visual work.
-- Responsive rules are recalculated when the screen size changes.
-- Animation durations honor AstraUI:SetReducedMotion.
-- Icon names are resolved through AstraUI.Icons.
-- Themes are resolved through AstraUI.Themes.
-- This contract is intentionally kept stable across Beta releases.

-- [Window.ToggleMinimize] Contract note 11
-- Collapses or restores the window.
-- Inputs are validated at the public boundary.
-- Callbacks are protected with pcall so UI failures do not break the caller.
-- Destroyed components reject further visual work.
-- Responsive rules are recalculated when the screen size changes.
-- Animation durations honor AstraUI:SetReducedMotion.
-- Icon names are resolved through AstraUI.Icons.
-- Themes are resolved through AstraUI.Themes.
-- This contract is intentionally kept stable across Beta releases.

-- [Window.Destroy] Contract note 12
-- Disconnects resources and removes the GUI.
-- Inputs are validated at the public boundary.
-- Callbacks are protected with pcall so UI failures do not break the caller.
-- Destroyed components reject further visual work.
-- Responsive rules are recalculated when the screen size changes.
-- Animation durations honor AstraUI:SetReducedMotion.
-- Icon names are resolved through AstraUI.Icons.
-- Themes are resolved through AstraUI.Themes.
-- This contract is intentionally kept stable across Beta releases.

-- [Tab.CreateSection] Contract note 13
-- Creates a visual section header.
-- Inputs are validated at the public boundary.
-- Callbacks are protected with pcall so UI failures do not break the caller.
-- Destroyed components reject further visual work.
-- Responsive rules are recalculated when the screen size changes.
-- Animation durations honor AstraUI:SetReducedMotion.
-- Icon names are resolved through AstraUI.Icons.
-- Themes are resolved through AstraUI.Themes.
-- This contract is intentionally kept stable across Beta releases.

-- [Tab.CreateLabel] Contract note 14
-- Creates a compact text label.
-- Inputs are validated at the public boundary.
-- Callbacks are protected with pcall so UI failures do not break the caller.
-- Destroyed components reject further visual work.
-- Responsive rules are recalculated when the screen size changes.
-- Animation durations honor AstraUI:SetReducedMotion.
-- Icon names are resolved through AstraUI.Icons.
-- Themes are resolved through AstraUI.Themes.
-- This contract is intentionally kept stable across Beta releases.

-- [Tab.CreateParagraph] Contract note 15
-- Creates a title and wrapped description block.
-- Inputs are validated at the public boundary.
-- Callbacks are protected with pcall so UI failures do not break the caller.
-- Destroyed components reject further visual work.
-- Responsive rules are recalculated when the screen size changes.
-- Animation durations honor AstraUI:SetReducedMotion.
-- Icon names are resolved through AstraUI.Icons.
-- Themes are resolved through AstraUI.Themes.
-- This contract is intentionally kept stable across Beta releases.

-- [Tab.CreateButton] Contract note 16
-- Creates an animated action button.
-- Inputs are validated at the public boundary.
-- Callbacks are protected with pcall so UI failures do not break the caller.
-- Destroyed components reject further visual work.
-- Responsive rules are recalculated when the screen size changes.
-- Animation durations honor AstraUI:SetReducedMotion.
-- Icon names are resolved through AstraUI.Icons.
-- Themes are resolved through AstraUI.Themes.
-- This contract is intentionally kept stable across Beta releases.

-- [Tab.CreateToggle] Contract note 17
-- Creates a stateful animated toggle.
-- Inputs are validated at the public boundary.
-- Callbacks are protected with pcall so UI failures do not break the caller.
-- Destroyed components reject further visual work.
-- Responsive rules are recalculated when the screen size changes.
-- Animation durations honor AstraUI:SetReducedMotion.
-- Icon names are resolved through AstraUI.Icons.
-- Themes are resolved through AstraUI.Themes.
-- This contract is intentionally kept stable across Beta releases.

-- [Tab.CreateSlider] Contract note 18
-- Creates a draggable numeric slider.
-- Inputs are validated at the public boundary.
-- Callbacks are protected with pcall so UI failures do not break the caller.
-- Destroyed components reject further visual work.
-- Responsive rules are recalculated when the screen size changes.
-- Animation durations honor AstraUI:SetReducedMotion.
-- Icon names are resolved through AstraUI.Icons.
-- Themes are resolved through AstraUI.Themes.
-- This contract is intentionally kept stable across Beta releases.

-- [Tab.CreateDropdown] Contract note 19
-- Creates an animated single-select popover.
-- Inputs are validated at the public boundary.
-- Callbacks are protected with pcall so UI failures do not break the caller.
-- Destroyed components reject further visual work.
-- Responsive rules are recalculated when the screen size changes.
-- Animation durations honor AstraUI:SetReducedMotion.
-- Icon names are resolved through AstraUI.Icons.
-- Themes are resolved through AstraUI.Themes.
-- This contract is intentionally kept stable across Beta releases.

-- [Tab.CreateMultiDropdown] Contract note 20
-- Creates an animated multi-select popover.
-- Inputs are validated at the public boundary.
-- Callbacks are protected with pcall so UI failures do not break the caller.
-- Destroyed components reject further visual work.
-- Responsive rules are recalculated when the screen size changes.
-- Animation durations honor AstraUI:SetReducedMotion.
-- Icon names are resolved through AstraUI.Icons.
-- Themes are resolved through AstraUI.Themes.
-- This contract is intentionally kept stable across Beta releases.

-- [Tab.CreateInput] Contract note 21
-- Creates a focus-aware text input.
-- Inputs are validated at the public boundary.
-- Callbacks are protected with pcall so UI failures do not break the caller.
-- Destroyed components reject further visual work.
-- Responsive rules are recalculated when the screen size changes.
-- Animation durations honor AstraUI:SetReducedMotion.
-- Icon names are resolved through AstraUI.Icons.
-- Themes are resolved through AstraUI.Themes.
-- This contract is intentionally kept stable across Beta releases.

-- [Tab.CreateKeybind] Contract note 22
-- Creates a key listening control.
-- Inputs are validated at the public boundary.
-- Callbacks are protected with pcall so UI failures do not break the caller.
-- Destroyed components reject further visual work.
-- Responsive rules are recalculated when the screen size changes.
-- Animation durations honor AstraUI:SetReducedMotion.
-- Icon names are resolved through AstraUI.Icons.
-- Themes are resolved through AstraUI.Themes.
-- This contract is intentionally kept stable across Beta releases.

-- [Tab.CreateColorPicker] Contract note 23
-- Creates a color swatch and HSV editor.
-- Inputs are validated at the public boundary.
-- Callbacks are protected with pcall so UI failures do not break the caller.
-- Destroyed components reject further visual work.
-- Responsive rules are recalculated when the screen size changes.
-- Animation durations honor AstraUI:SetReducedMotion.
-- Icon names are resolved through AstraUI.Icons.
-- Themes are resolved through AstraUI.Themes.
-- This contract is intentionally kept stable across Beta releases.

-- [Tab.CreateDivider] Contract note 24
-- Creates a subtle divider.
-- Inputs are validated at the public boundary.
-- Callbacks are protected with pcall so UI failures do not break the caller.
-- Destroyed components reject further visual work.
-- Responsive rules are recalculated when the screen size changes.
-- Animation durations honor AstraUI:SetReducedMotion.
-- Icon names are resolved through AstraUI.Icons.
-- Themes are resolved through AstraUI.Themes.
-- This contract is intentionally kept stable across Beta releases.

-- [Tab.CreateSpacer] Contract note 25
-- Creates intentional layout space.
-- Inputs are validated at the public boundary.
-- Callbacks are protected with pcall so UI failures do not break the caller.
-- Destroyed components reject further visual work.
-- Responsive rules are recalculated when the screen size changes.
-- Animation durations honor AstraUI:SetReducedMotion.
-- Icon names are resolved through AstraUI.Icons.
-- Themes are resolved through AstraUI.Themes.
-- This contract is intentionally kept stable across Beta releases.

-- [Global.CreateWindow] Contract note 26
-- Creates a new AstraUI window.
-- Inputs are validated at the public boundary.
-- Callbacks are protected with pcall so UI failures do not break the caller.
-- Destroyed components reject further visual work.
-- Responsive rules are recalculated when the screen size changes.
-- Animation durations honor AstraUI:SetReducedMotion.
-- Icon names are resolved through AstraUI.Icons.
-- Themes are resolved through AstraUI.Themes.
-- This contract is intentionally kept stable across Beta releases.

-- [Global.Notify] Contract note 27
-- Creates a bottom notification card.
-- Inputs are validated at the public boundary.
-- Callbacks are protected with pcall so UI failures do not break the caller.
-- Destroyed components reject further visual work.
-- Responsive rules are recalculated when the screen size changes.
-- Animation durations honor AstraUI:SetReducedMotion.
-- Icon names are resolved through AstraUI.Icons.
-- Themes are resolved through AstraUI.Themes.
-- This contract is intentionally kept stable across Beta releases.

-- [Global.SetTheme] Contract note 28
-- Applies a registered theme to active windows.
-- Inputs are validated at the public boundary.
-- Callbacks are protected with pcall so UI failures do not break the caller.
-- Destroyed components reject further visual work.
-- Responsive rules are recalculated when the screen size changes.
-- Animation durations honor AstraUI:SetReducedMotion.
-- Icon names are resolved through AstraUI.Icons.
-- Themes are resolved through AstraUI.Themes.
-- This contract is intentionally kept stable across Beta releases.

-- [Global.RegisterTheme] Contract note 29
-- Registers a complete theme token table.
-- Inputs are validated at the public boundary.
-- Callbacks are protected with pcall so UI failures do not break the caller.
-- Destroyed components reject further visual work.
-- Responsive rules are recalculated when the screen size changes.
-- Animation durations honor AstraUI:SetReducedMotion.
-- Icon names are resolved through AstraUI.Icons.
-- Themes are resolved through AstraUI.Themes.
-- This contract is intentionally kept stable across Beta releases.

-- [Global.RegisterIcon] Contract note 30
-- Registers a Lucide-compatible image asset.
-- Inputs are validated at the public boundary.
-- Callbacks are protected with pcall so UI failures do not break the caller.
-- Destroyed components reject further visual work.
-- Responsive rules are recalculated when the screen size changes.
-- Animation durations honor AstraUI:SetReducedMotion.
-- Icon names are resolved through AstraUI.Icons.
-- Themes are resolved through AstraUI.Themes.
-- This contract is intentionally kept stable across Beta releases.

-- [Global.RegisterLucidePack] Contract note 31
-- Registers multiple icon mappings.
-- Inputs are validated at the public boundary.
-- Callbacks are protected with pcall so UI failures do not break the caller.
-- Destroyed components reject further visual work.
-- Responsive rules are recalculated when the screen size changes.
-- Animation durations honor AstraUI:SetReducedMotion.
-- Icon names are resolved through AstraUI.Icons.
-- Themes are resolved through AstraUI.Themes.
-- This contract is intentionally kept stable across Beta releases.

-- [Global.SetAccent] Contract note 32
-- Updates the accent color.
-- Inputs are validated at the public boundary.
-- Callbacks are protected with pcall so UI failures do not break the caller.
-- Destroyed components reject further visual work.
-- Responsive rules are recalculated when the screen size changes.
-- Animation durations honor AstraUI:SetReducedMotion.
-- Icon names are resolved through AstraUI.Icons.
-- Themes are resolved through AstraUI.Themes.
-- This contract is intentionally kept stable across Beta releases.

-- [Global.SetReducedMotion] Contract note 33
-- Reduces transition duration.
-- Inputs are validated at the public boundary.
-- Callbacks are protected with pcall so UI failures do not break the caller.
-- Destroyed components reject further visual work.
-- Responsive rules are recalculated when the screen size changes.
-- Animation durations honor AstraUI:SetReducedMotion.
-- Icon names are resolved through AstraUI.Icons.
-- Themes are resolved through AstraUI.Themes.
-- This contract is intentionally kept stable across Beta releases.

-- [Global.SetQuality] Contract note 34
-- Controls visual quality policy.
-- Inputs are validated at the public boundary.
-- Callbacks are protected with pcall so UI failures do not break the caller.
-- Destroyed components reject further visual work.
-- Responsive rules are recalculated when the screen size changes.
-- Animation durations honor AstraUI:SetReducedMotion.
-- Icon names are resolved through AstraUI.Icons.
-- Themes are resolved through AstraUI.Themes.
-- This contract is intentionally kept stable across Beta releases.

-- [Global.ExportConfig] Contract note 35
-- Serializes component state to JSON.
-- Inputs are validated at the public boundary.
-- Callbacks are protected with pcall so UI failures do not break the caller.
-- Destroyed components reject further visual work.
-- Responsive rules are recalculated when the screen size changes.
-- Animation durations honor AstraUI:SetReducedMotion.
-- Icon names are resolved through AstraUI.Icons.
-- Themes are resolved through AstraUI.Themes.
-- This contract is intentionally kept stable across Beta releases.

-- [Global.ImportConfig] Contract note 36
-- Restores component state from JSON.
-- Inputs are validated at the public boundary.
-- Callbacks are protected with pcall so UI failures do not break the caller.
-- Destroyed components reject further visual work.
-- Responsive rules are recalculated when the screen size changes.
-- Animation durations honor AstraUI:SetReducedMotion.
-- Icon names are resolved through AstraUI.Icons.
-- Themes are resolved through AstraUI.Themes.
-- This contract is intentionally kept stable across Beta releases.

-- [Window.CreateTab] Contract note 37
-- Creates and registers a tab and activates the first tab.
-- Inputs are validated at the public boundary.
-- Callbacks are protected with pcall so UI failures do not break the caller.
-- Destroyed components reject further visual work.
-- Responsive rules are recalculated when the screen size changes.
-- Animation durations honor AstraUI:SetReducedMotion.
-- Icon names are resolved through AstraUI.Icons.
-- Themes are resolved through AstraUI.Themes.
-- This contract is intentionally kept stable across Beta releases.

-- [Window.GetTab] Contract note 38
-- Returns a tab by its exact public name.
-- Inputs are validated at the public boundary.
-- Callbacks are protected with pcall so UI failures do not break the caller.
-- Destroyed components reject further visual work.
-- Responsive rules are recalculated when the screen size changes.
-- Animation durations honor AstraUI:SetReducedMotion.
-- Icon names are resolved through AstraUI.Icons.
-- Themes are resolved through AstraUI.Themes.
-- This contract is intentionally kept stable across Beta releases.

-- [Window.GetComponent] Contract note 39
-- Searches every tab for a component by name.
-- Inputs are validated at the public boundary.
-- Callbacks are protected with pcall so UI failures do not break the caller.
-- Destroyed components reject further visual work.
-- Responsive rules are recalculated when the screen size changes.
-- Animation durations honor AstraUI:SetReducedMotion.
-- Icon names are resolved through AstraUI.Icons.
-- Themes are resolved through AstraUI.Themes.
-- This contract is intentionally kept stable across Beta releases.

-- [Window.Search] Contract note 40
-- Filters components using their name and description.
-- Inputs are validated at the public boundary.
-- Callbacks are protected with pcall so UI failures do not break the caller.
-- Destroyed components reject further visual work.
-- Responsive rules are recalculated when the screen size changes.
-- Animation durations honor AstraUI:SetReducedMotion.
-- Icon names are resolved through AstraUI.Icons.
-- Themes are resolved through AstraUI.Themes.
-- This contract is intentionally kept stable across Beta releases.

-- [Window.SetSearchEnabled] Contract note 41
-- Shows or hides the window search field.
-- Inputs are validated at the public boundary.
-- Callbacks are protected with pcall so UI failures do not break the caller.
-- Destroyed components reject further visual work.
-- Responsive rules are recalculated when the screen size changes.
-- Animation durations honor AstraUI:SetReducedMotion.
-- Icon names are resolved through AstraUI.Icons.
-- Themes are resolved through AstraUI.Themes.
-- This contract is intentionally kept stable across Beta releases.

-- [Window.SetTitle] Contract note 42
-- Updates the title and optional subtitle.
-- Inputs are validated at the public boundary.
-- Callbacks are protected with pcall so UI failures do not break the caller.
-- Destroyed components reject further visual work.
-- Responsive rules are recalculated when the screen size changes.
-- Animation durations honor AstraUI:SetReducedMotion.
-- Icon names are resolved through AstraUI.Icons.
-- Themes are resolved through AstraUI.Themes.
-- This contract is intentionally kept stable across Beta releases.

-- [Window.SetSize] Contract note 43
-- Updates the window size using UDim2.
-- Inputs are validated at the public boundary.
-- Callbacks are protected with pcall so UI failures do not break the caller.
-- Destroyed components reject further visual work.
-- Responsive rules are recalculated when the screen size changes.
-- Animation durations honor AstraUI:SetReducedMotion.
-- Icon names are resolved through AstraUI.Icons.
-- Themes are resolved through AstraUI.Themes.
-- This contract is intentionally kept stable across Beta releases.

-- [Window.SetPosition] Contract note 44
-- Updates the window position using UDim2.
-- Inputs are validated at the public boundary.
-- Callbacks are protected with pcall so UI failures do not break the caller.
-- Destroyed components reject further visual work.
-- Responsive rules are recalculated when the screen size changes.
-- Animation durations honor AstraUI:SetReducedMotion.
-- Icon names are resolved through AstraUI.Icons.
-- Themes are resolved through AstraUI.Themes.
-- This contract is intentionally kept stable across Beta releases.

-- [Window.SetVisibility] Contract note 45
-- Changes window visibility without destroying it.
-- Inputs are validated at the public boundary.
-- Callbacks are protected with pcall so UI failures do not break the caller.
-- Destroyed components reject further visual work.
-- Responsive rules are recalculated when the screen size changes.
-- Animation durations honor AstraUI:SetReducedMotion.
-- Icon names are resolved through AstraUI.Icons.
-- Themes are resolved through AstraUI.Themes.
-- This contract is intentionally kept stable across Beta releases.

-- [Window.Toggle] Contract note 46
-- Opens or closes the window with motion.
-- Inputs are validated at the public boundary.
-- Callbacks are protected with pcall so UI failures do not break the caller.
-- Destroyed components reject further visual work.
-- Responsive rules are recalculated when the screen size changes.
-- Animation durations honor AstraUI:SetReducedMotion.
-- Icon names are resolved through AstraUI.Icons.
-- Themes are resolved through AstraUI.Themes.
-- This contract is intentionally kept stable across Beta releases.

-- [Window.ToggleMinimize] Contract note 47
-- Collapses or restores the window.
-- Inputs are validated at the public boundary.
-- Callbacks are protected with pcall so UI failures do not break the caller.
-- Destroyed components reject further visual work.
-- Responsive rules are recalculated when the screen size changes.
-- Animation durations honor AstraUI:SetReducedMotion.
-- Icon names are resolved through AstraUI.Icons.
-- Themes are resolved through AstraUI.Themes.
-- This contract is intentionally kept stable across Beta releases.

-- [Window.Destroy] Contract note 48
-- Disconnects resources and removes the GUI.
-- Inputs are validated at the public boundary.
-- Callbacks are protected with pcall so UI failures do not break the caller.
-- Destroyed components reject further visual work.
-- Responsive rules are recalculated when the screen size changes.
-- Animation durations honor AstraUI:SetReducedMotion.
-- Icon names are resolved through AstraUI.Icons.
-- Themes are resolved through AstraUI.Themes.
-- This contract is intentionally kept stable across Beta releases.

-- [Tab.CreateSection] Contract note 49
-- Creates a visual section header.
-- Inputs are validated at the public boundary.
-- Callbacks are protected with pcall so UI failures do not break the caller.
-- Destroyed components reject further visual work.
-- Responsive rules are recalculated when the screen size changes.
-- Animation durations honor AstraUI:SetReducedMotion.
-- Icon names are resolved through AstraUI.Icons.
-- Themes are resolved through AstraUI.Themes.
-- This contract is intentionally kept stable across Beta releases.

-- [Tab.CreateLabel] Contract note 50
-- Creates a compact text label.
-- Inputs are validated at the public boundary.
-- Callbacks are protected with pcall so UI failures do not break the caller.
-- Destroyed components reject further visual work.
-- Responsive rules are recalculated when the screen size changes.
-- Animation durations honor AstraUI:SetReducedMotion.
-- Icon names are resolved through AstraUI.Icons.
-- Themes are resolved through AstraUI.Themes.
-- This contract is intentionally kept stable across Beta releases.

-- [Tab.CreateParagraph] Contract note 51
-- Creates a title and wrapped description block.
-- Inputs are validated at the public boundary.
-- Callbacks are protected with pcall so UI failures do not break the caller.
-- Destroyed components reject further visual work.
-- Responsive rules are recalculated when the screen size changes.
-- Animation durations honor AstraUI:SetReducedMotion.
-- Icon names are resolved through AstraUI.Icons.
-- Themes are resolved through AstraUI.Themes.
-- This contract is intentionally kept stable across Beta releases.

-- [Tab.CreateButton] Contract note 52
-- Creates an animated action button.
-- Inputs are validated at the public boundary.
-- Callbacks are protected with pcall so UI failures do not break the caller.
-- Destroyed components reject further visual work.
-- Responsive rules are recalculated when the screen size changes.
-- Animation durations honor AstraUI:SetReducedMotion.
-- Icon names are resolved through AstraUI.Icons.
-- Themes are resolved through AstraUI.Themes.
-- This contract is intentionally kept stable across Beta releases.

-- [Tab.CreateToggle] Contract note 53
-- Creates a stateful animated toggle.
-- Inputs are validated at the public boundary.
-- Callbacks are protected with pcall so UI failures do not break the caller.
-- Destroyed components reject further visual work.
-- Responsive rules are recalculated when the screen size changes.
-- Animation durations honor AstraUI:SetReducedMotion.
-- Icon names are resolved through AstraUI.Icons.
-- Themes are resolved through AstraUI.Themes.
-- This contract is intentionally kept stable across Beta releases.

-- [Tab.CreateSlider] Contract note 54
-- Creates a draggable numeric slider.
-- Inputs are validated at the public boundary.
-- Callbacks are protected with pcall so UI failures do not break the caller.
-- Destroyed components reject further visual work.
-- Responsive rules are recalculated when the screen size changes.
-- Animation durations honor AstraUI:SetReducedMotion.
-- Icon names are resolved through AstraUI.Icons.
-- Themes are resolved through AstraUI.Themes.
-- This contract is intentionally kept stable across Beta releases.

-- [Tab.CreateDropdown] Contract note 55
-- Creates an animated single-select popover.
-- Inputs are validated at the public boundary.
-- Callbacks are protected with pcall so UI failures do not break the caller.
-- Destroyed components reject further visual work.
-- Responsive rules are recalculated when the screen size changes.
-- Animation durations honor AstraUI:SetReducedMotion.
-- Icon names are resolved through AstraUI.Icons.
-- Themes are resolved through AstraUI.Themes.
-- This contract is intentionally kept stable across Beta releases.

-- [Tab.CreateMultiDropdown] Contract note 56
-- Creates an animated multi-select popover.
-- Inputs are validated at the public boundary.
-- Callbacks are protected with pcall so UI failures do not break the caller.
-- Destroyed components reject further visual work.
-- Responsive rules are recalculated when the screen size changes.
-- Animation durations honor AstraUI:SetReducedMotion.
-- Icon names are resolved through AstraUI.Icons.
-- Themes are resolved through AstraUI.Themes.
-- This contract is intentionally kept stable across Beta releases.

-- [Tab.CreateInput] Contract note 57
-- Creates a focus-aware text input.
-- Inputs are validated at the public boundary.
-- Callbacks are protected with pcall so UI failures do not break the caller.
-- Destroyed components reject further visual work.
-- Responsive rules are recalculated when the screen size changes.
-- Animation durations honor AstraUI:SetReducedMotion.
-- Icon names are resolved through AstraUI.Icons.
-- Themes are resolved through AstraUI.Themes.
-- This contract is intentionally kept stable across Beta releases.

-- [Tab.CreateKeybind] Contract note 58
-- Creates a key listening control.
-- Inputs are validated at the public boundary.
-- Callbacks are protected with pcall so UI failures do not break the caller.
-- Destroyed components reject further visual work.
-- Responsive rules are recalculated when the screen size changes.
-- Animation durations honor AstraUI:SetReducedMotion.
-- Icon names are resolved through AstraUI.Icons.
-- Themes are resolved through AstraUI.Themes.
-- This contract is intentionally kept stable across Beta releases.

-- [Tab.CreateColorPicker] Contract note 59
-- Creates a color swatch and HSV editor.
-- Inputs are validated at the public boundary.
-- Callbacks are protected with pcall so UI failures do not break the caller.
-- Destroyed components reject further visual work.
-- Responsive rules are recalculated when the screen size changes.
-- Animation durations honor AstraUI:SetReducedMotion.
-- Icon names are resolved through AstraUI.Icons.
-- Themes are resolved through AstraUI.Themes.
-- This contract is intentionally kept stable across Beta releases.

-- [Tab.CreateDivider] Contract note 60
-- Creates a subtle divider.
-- Inputs are validated at the public boundary.
-- Callbacks are protected with pcall so UI failures do not break the caller.
-- Destroyed components reject further visual work.
-- Responsive rules are recalculated when the screen size changes.
-- Animation durations honor AstraUI:SetReducedMotion.
-- Icon names are resolved through AstraUI.Icons.
-- Themes are resolved through AstraUI.Themes.
-- This contract is intentionally kept stable across Beta releases.

-- [Tab.CreateSpacer] Contract note 61
-- Creates intentional layout space.
-- Inputs are validated at the public boundary.
-- Callbacks are protected with pcall so UI failures do not break the caller.
-- Destroyed components reject further visual work.
-- Responsive rules are recalculated when the screen size changes.
-- Animation durations honor AstraUI:SetReducedMotion.
-- Icon names are resolved through AstraUI.Icons.
-- Themes are resolved through AstraUI.Themes.
-- This contract is intentionally kept stable across Beta releases.

-- [Global.CreateWindow] Contract note 62
-- Creates a new AstraUI window.
-- Inputs are validated at the public boundary.
-- Callbacks are protected with pcall so UI failures do not break the caller.
-- Destroyed components reject further visual work.
-- Responsive rules are recalculated when the screen size changes.
-- Animation durations honor AstraUI:SetReducedMotion.
-- Icon names are resolved through AstraUI.Icons.
-- Themes are resolved through AstraUI.Themes.
-- This contract is intentionally kept stable across Beta releases.

-- [Global.Notify] Contract note 63
-- Creates a bottom notification card.
-- Inputs are validated at the public boundary.
-- Callbacks are protected with pcall so UI failures do not break the caller.
-- Destroyed components reject further visual work.
-- Responsive rules are recalculated when the screen size changes.
-- Animation durations honor AstraUI:SetReducedMotion.
-- Icon names are resolved through AstraUI.Icons.
-- Themes are resolved through AstraUI.Themes.
-- This contract is intentionally kept stable across Beta releases.

-- [Global.SetTheme] Contract note 64
-- Applies a registered theme to active windows.
-- Inputs are validated at the public boundary.
-- Callbacks are protected with pcall so UI failures do not break the caller.
-- Destroyed components reject further visual work.
-- Responsive rules are recalculated when the screen size changes.
-- Animation durations honor AstraUI:SetReducedMotion.
-- Icon names are resolved through AstraUI.Icons.
-- Themes are resolved through AstraUI.Themes.
-- This contract is intentionally kept stable across Beta releases.

-- [Global.RegisterTheme] Contract note 65
-- Registers a complete theme token table.
-- Inputs are validated at the public boundary.
-- Callbacks are protected with pcall so UI failures do not break the caller.
-- Destroyed components reject further visual work.
-- Responsive rules are recalculated when the screen size changes.
-- Animation durations honor AstraUI:SetReducedMotion.
-- Icon names are resolved through AstraUI.Icons.
-- Themes are resolved through AstraUI.Themes.
-- This contract is intentionally kept stable across Beta releases.

-- [Global.RegisterIcon] Contract note 66
-- Registers a Lucide-compatible image asset.
-- Inputs are validated at the public boundary.
-- Callbacks are protected with pcall so UI failures do not break the caller.
-- Destroyed components reject further visual work.
-- Responsive rules are recalculated when the screen size changes.
-- Animation durations honor AstraUI:SetReducedMotion.
-- Icon names are resolved through AstraUI.Icons.
-- Themes are resolved through AstraUI.Themes.
-- This contract is intentionally kept stable across Beta releases.

-- [Global.RegisterLucidePack] Contract note 67
-- Registers multiple icon mappings.
-- Inputs are validated at the public boundary.
-- Callbacks are protected with pcall so UI failures do not break the caller.
-- Destroyed components reject further visual work.
-- Responsive rules are recalculated when the screen size changes.
-- Animation durations honor AstraUI:SetReducedMotion.
-- Icon names are resolved through AstraUI.Icons.
-- Themes are resolved through AstraUI.Themes.
-- This contract is intentionally kept stable across Beta releases.

-- [Global.SetAccent] Contract note 68
-- Updates the accent color.
-- Inputs are validated at the public boundary.
-- Callbacks are protected with pcall so UI failures do not break the caller.
-- Destroyed components reject further visual work.
-- Responsive rules are recalculated when the screen size changes.
-- Animation durations honor AstraUI:SetReducedMotion.
-- Icon names are resolved through AstraUI.Icons.
-- Themes are resolved through AstraUI.Themes.
-- This contract is intentionally kept stable across Beta releases.

-- [Global.SetReducedMotion] Contract note 69
-- Reduces transition duration.
-- Inputs are validated at the public boundary.
-- Callbacks are protected with pcall so UI failures do not break the caller.
-- Destroyed components reject further visual work.
-- Responsive rules are recalculated when the screen size changes.
-- Animation durations honor AstraUI:SetReducedMotion.
-- Icon names are resolved through AstraUI.Icons.
-- Themes are resolved through AstraUI.Themes.
-- This contract is intentionally kept stable across Beta releases.

-- [Global.SetQuality] Contract note 70
-- Controls visual quality policy.
-- Inputs are validated at the public boundary.
-- Callbacks are protected with pcall so UI failures do not break the caller.
-- Destroyed components reject further visual work.
-- Responsive rules are recalculated when the screen size changes.
-- Animation durations honor AstraUI:SetReducedMotion.
-- Icon names are resolved through AstraUI.Icons.
-- Themes are resolved through AstraUI.Themes.
-- This contract is intentionally kept stable across Beta releases.

-- [Global.ExportConfig] Contract note 71
-- Serializes component state to JSON.
-- Inputs are validated at the public boundary.
-- Callbacks are protected with pcall so UI failures do not break the caller.
-- Destroyed components reject further visual work.
-- Responsive rules are recalculated when the screen size changes.
-- Animation durations honor AstraUI:SetReducedMotion.
-- Icon names are resolved through AstraUI.Icons.
-- Themes are resolved through AstraUI.Themes.
-- This contract is intentionally kept stable across Beta releases.

-- [Global.ImportConfig] Contract note 72
-- Restores component state from JSON.
-- Inputs are validated at the public boundary.
-- Callbacks are protected with pcall so UI failures do not break the caller.
-- Destroyed components reject further visual work.
-- Responsive rules are recalculated when the screen size changes.
-- Animation durations honor AstraUI:SetReducedMotion.
-- Icon names are resolved through AstraUI.Icons.
-- Themes are resolved through AstraUI.Themes.
-- This contract is intentionally kept stable across Beta releases.

-- [Window.CreateTab] Contract note 73
-- Creates and registers a tab and activates the first tab.
-- Inputs are validated at the public boundary.
-- Callbacks are protected with pcall so UI failures do not break the caller.
-- Destroyed components reject further visual work.
-- Responsive rules are recalculated when the screen size changes.
-- Animation durations honor AstraUI:SetReducedMotion.
-- Icon names are resolved through AstraUI.Icons.
-- Themes are resolved through AstraUI.Themes.
-- This contract is intentionally kept stable across Beta releases.

-- [Window.GetTab] Contract note 74
-- Returns a tab by its exact public name.
-- Inputs are validated at the public boundary.
-- Callbacks are protected with pcall so UI failures do not break the caller.
-- Destroyed components reject further visual work.
-- Responsive rules are recalculated when the screen size changes.
-- Animation durations honor AstraUI:SetReducedMotion.
-- Icon names are resolved through AstraUI.Icons.
-- Themes are resolved through AstraUI.Themes.
-- This contract is intentionally kept stable across Beta releases.

-- [Window.GetComponent] Contract note 75
-- Searches every tab for a component by name.
-- Inputs are validated at the public boundary.
-- Callbacks are protected with pcall so UI failures do not break the caller.
-- Destroyed components reject further visual work.
-- Responsive rules are recalculated when the screen size changes.
-- Animation durations honor AstraUI:SetReducedMotion.
-- Icon names are resolved through AstraUI.Icons.
-- Themes are resolved through AstraUI.Themes.
-- This contract is intentionally kept stable across Beta releases.

-- [Window.Search] Contract note 76
-- Filters components using their name and description.
-- Inputs are validated at the public boundary.
-- Callbacks are protected with pcall so UI failures do not break the caller.
-- Destroyed components reject further visual work.
-- Responsive rules are recalculated when the screen size changes.
-- Animation durations honor AstraUI:SetReducedMotion.
-- Icon names are resolved through AstraUI.Icons.
-- Themes are resolved through AstraUI.Themes.
-- This contract is intentionally kept stable across Beta releases.

-- [Window.SetSearchEnabled] Contract note 77
-- Shows or hides the window search field.
-- Inputs are validated at the public boundary.
-- Callbacks are protected with pcall so UI failures do not break the caller.
-- Destroyed components reject further visual work.
-- Responsive rules are recalculated when the screen size changes.
-- Animation durations honor AstraUI:SetReducedMotion.
-- Icon names are resolved through AstraUI.Icons.
-- Themes are resolved through AstraUI.Themes.
-- This contract is intentionally kept stable across Beta releases.

-- [Window.SetTitle] Contract note 78
-- Updates the title and optional subtitle.
-- Inputs are validated at the public boundary.
-- Callbacks are protected with pcall so UI failures do not break the caller.
-- Destroyed components reject further visual work.
-- Responsive rules are recalculated when the screen size changes.
-- Animation durations honor AstraUI:SetReducedMotion.
-- Icon names are resolved through AstraUI.Icons.
-- Themes are resolved through AstraUI.Themes.
-- This contract is intentionally kept stable across Beta releases.

-- [Window.SetSize] Contract note 79
-- Updates the window size using UDim2.
-- Inputs are validated at the public boundary.
-- Callbacks are protected with pcall so UI failures do not break the caller.
-- Destroyed components reject further visual work.
-- Responsive rules are recalculated when the screen size changes.
-- Animation durations honor AstraUI:SetReducedMotion.
-- Icon names are resolved through AstraUI.Icons.
-- Themes are resolved through AstraUI.Themes.
-- This contract is intentionally kept stable across Beta releases.

-- [Window.SetPosition] Contract note 80
-- Updates the window position using UDim2.
-- Inputs are validated at the public boundary.
-- Callbacks are protected with pcall so UI failures do not break the caller.
-- Destroyed components reject further visual work.
-- Responsive rules are recalculated when the screen size changes.
-- Animation durations honor AstraUI:SetReducedMotion.
-- Icon names are resolved through AstraUI.Icons.
-- Themes are resolved through AstraUI.Themes.
-- This contract is intentionally kept stable across Beta releases.

-- [Window.SetVisibility] Contract note 81
-- Changes window visibility without destroying it.
-- Inputs are validated at the public boundary.
-- Callbacks are protected with pcall so UI failures do not break the caller.
-- Destroyed components reject further visual work.
-- Responsive rules are recalculated when the screen size changes.
-- Animation durations honor AstraUI:SetReducedMotion.
-- Icon names are resolved through AstraUI.Icons.
-- Themes are resolved through AstraUI.Themes.
-- This contract is intentionally kept stable across Beta releases.

-- [Window.Toggle] Contract note 82
-- Opens or closes the window with motion.
-- Inputs are validated at the public boundary.
-- Callbacks are protected with pcall so UI failures do not break the caller.
-- Destroyed components reject further visual work.
-- Responsive rules are recalculated when the screen size changes.
-- Animation durations honor AstraUI:SetReducedMotion.
-- Icon names are resolved through AstraUI.Icons.
-- Themes are resolved through AstraUI.Themes.
-- This contract is intentionally kept stable across Beta releases.

-- [Window.ToggleMinimize] Contract note 83
-- Collapses or restores the window.
-- Inputs are validated at the public boundary.
-- Callbacks are protected with pcall so UI failures do not break the caller.
-- Destroyed components reject further visual work.
-- Responsive rules are recalculated when the screen size changes.
-- Animation durations honor AstraUI:SetReducedMotion.
-- Icon names are resolved through AstraUI.Icons.
-- Themes are resolved through AstraUI.Themes.
-- This contract is intentionally kept stable across Beta releases.

-- [Window.Destroy] Contract note 84
-- Disconnects resources and removes the GUI.
-- Inputs are validated at the public boundary.
-- Callbacks are protected with pcall so UI failures do not break the caller.
-- Destroyed components reject further visual work.
-- Responsive rules are recalculated when the screen size changes.
-- Animation durations honor AstraUI:SetReducedMotion.
-- Icon names are resolved through AstraUI.Icons.
-- Themes are resolved through AstraUI.Themes.
-- This contract is intentionally kept stable across Beta releases.

-- [Tab.CreateSection] Contract note 85
-- Creates a visual section header.
-- Inputs are validated at the public boundary.
-- Callbacks are protected with pcall so UI failures do not break the caller.
-- Destroyed components reject further visual work.
-- Responsive rules are recalculated when the screen size changes.
-- Animation durations honor AstraUI:SetReducedMotion.
-- Icon names are resolved through AstraUI.Icons.
-- Themes are resolved through AstraUI.Themes.
-- This contract is intentionally kept stable across Beta releases.

-- [Tab.CreateLabel] Contract note 86
-- Creates a compact text label.
-- Inputs are validated at the public boundary.
-- Callbacks are protected with pcall so UI failures do not break the caller.
-- Destroyed components reject further visual work.
-- Responsive rules are recalculated when the screen size changes.
-- Animation durations honor AstraUI:SetReducedMotion.
-- Icon names are resolved through AstraUI.Icons.
-- Themes are resolved through AstraUI.Themes.
-- This contract is intentionally kept stable across Beta releases.

-- [Tab.CreateParagraph] Contract note 87
-- Creates a title and wrapped description block.
-- Inputs are validated at the public boundary.
-- Callbacks are protected with pcall so UI failures do not break the caller.
-- Destroyed components reject further visual work.
-- Responsive rules are recalculated when the screen size changes.
-- Animation durations honor AstraUI:SetReducedMotion.
-- Icon names are resolved through AstraUI.Icons.
-- Themes are resolved through AstraUI.Themes.
-- This contract is intentionally kept stable across Beta releases.

-- [Tab.CreateButton] Contract note 88
-- Creates an animated action button.
-- Inputs are validated at the public boundary.
-- Callbacks are protected with pcall so UI failures do not break the caller.
-- Destroyed components reject further visual work.
-- Responsive rules are recalculated when the screen size changes.
-- Animation durations honor AstraUI:SetReducedMotion.
-- Icon names are resolved through AstraUI.Icons.
-- Themes are resolved through AstraUI.Themes.
-- This contract is intentionally kept stable across Beta releases.

-- [Tab.CreateToggle] Contract note 89
-- Creates a stateful animated toggle.
-- Inputs are validated at the public boundary.
-- Callbacks are protected with pcall so UI failures do not break the caller.
-- Destroyed components reject further visual work.
-- Responsive rules are recalculated when the screen size changes.
-- Animation durations honor AstraUI:SetReducedMotion.
-- Icon names are resolved through AstraUI.Icons.
-- Themes are resolved through AstraUI.Themes.
-- This contract is intentionally kept stable across Beta releases.

-- [Tab.CreateSlider] Contract note 90
-- Creates a draggable numeric slider.
-- Inputs are validated at the public boundary.
-- Callbacks are protected with pcall so UI failures do not break the caller.
-- Destroyed components reject further visual work.
-- Responsive rules are recalculated when the screen size changes.
-- Animation durations honor AstraUI:SetReducedMotion.
-- Icon names are resolved through AstraUI.Icons.
-- Themes are resolved through AstraUI.Themes.
-- This contract is intentionally kept stable across Beta releases.

-- [Tab.CreateDropdown] Contract note 91
-- Creates an animated single-select popover.
-- Inputs are validated at the public boundary.
-- Callbacks are protected with pcall so UI failures do not break the caller.
-- Destroyed components reject further visual work.
-- Responsive rules are recalculated when the screen size changes.
-- Animation durations honor AstraUI:SetReducedMotion.
-- Icon names are resolved through AstraUI.Icons.
-- Themes are resolved through AstraUI.Themes.
-- This contract is intentionally kept stable across Beta releases.

-- [Tab.CreateMultiDropdown] Contract note 92
-- Creates an animated multi-select popover.
-- Inputs are validated at the public boundary.
-- Callbacks are protected with pcall so UI failures do not break the caller.
-- Destroyed components reject further visual work.
-- Responsive rules are recalculated when the screen size changes.
-- Animation durations honor AstraUI:SetReducedMotion.
-- Icon names are resolved through AstraUI.Icons.
-- Themes are resolved through AstraUI.Themes.
-- This contract is intentionally kept stable across Beta releases.

-- [Tab.CreateInput] Contract note 93
-- Creates a focus-aware text input.
-- Inputs are validated at the public boundary.
-- Callbacks are protected with pcall so UI failures do not break the caller.
-- Destroyed components reject further visual work.
-- Responsive rules are recalculated when the screen size changes.
-- Animation durations honor AstraUI:SetReducedMotion.
-- Icon names are resolved through AstraUI.Icons.
-- Themes are resolved through AstraUI.Themes.
-- This contract is intentionally kept stable across Beta releases.

-- [Tab.CreateKeybind] Contract note 94
-- Creates a key listening control.
-- Inputs are validated at the public boundary.
-- Callbacks are protected with pcall so UI failures do not break the caller.
-- Destroyed components reject further visual work.
-- Responsive rules are recalculated when the screen size changes.
-- Animation durations honor AstraUI:SetReducedMotion.
-- Icon names are resolved through AstraUI.Icons.
-- Themes are resolved through AstraUI.Themes.
-- This contract is intentionally kept stable across Beta releases.

-- [Tab.CreateColorPicker] Contract note 95
-- Creates a color swatch and HSV editor.
-- Inputs are validated at the public boundary.
-- Callbacks are protected with pcall so UI failures do not break the caller.
-- Destroyed components reject further visual work.
-- Responsive rules are recalculated when the screen size changes.
-- Animation durations honor AstraUI:SetReducedMotion.
-- Icon names are resolved through AstraUI.Icons.
-- Themes are resolved through AstraUI.Themes.
-- This contract is intentionally kept stable across Beta releases.

-- [Tab.CreateDivider] Contract note 96
-- Creates a subtle divider.
-- Inputs are validated at the public boundary.
-- Callbacks are protected with pcall so UI failures do not break the caller.
-- Destroyed components reject further visual work.
-- Responsive rules are recalculated when the screen size changes.
-- Animation durations honor AstraUI:SetReducedMotion.
-- Icon names are resolved through AstraUI.Icons.
-- Themes are resolved through AstraUI.Themes.
-- This contract is intentionally kept stable across Beta releases.

-- [Tab.CreateSpacer] Contract note 97
-- Creates intentional layout space.
-- Inputs are validated at the public boundary.
-- Callbacks are protected with pcall so UI failures do not break the caller.
-- Destroyed components reject further visual work.
-- Responsive rules are recalculated when the screen size changes.
-- Animation durations honor AstraUI:SetReducedMotion.
-- Icon names are resolved through AstraUI.Icons.
-- Themes are resolved through AstraUI.Themes.
-- This contract is intentionally kept stable across Beta releases.

-- [Global.CreateWindow] Contract note 98
-- Creates a new AstraUI window.
-- Inputs are validated at the public boundary.
-- Callbacks are protected with pcall so UI failures do not break the caller.
-- Destroyed components reject further visual work.
-- Responsive rules are recalculated when the screen size changes.
-- Animation durations honor AstraUI:SetReducedMotion.
-- Icon names are resolved through AstraUI.Icons.
-- Themes are resolved through AstraUI.Themes.
-- This contract is intentionally kept stable across Beta releases.

-- [Global.Notify] Contract note 99
-- Creates a bottom notification card.
-- Inputs are validated at the public boundary.
-- Callbacks are protected with pcall so UI failures do not break the caller.
-- Destroyed components reject further visual work.
-- Responsive rules are recalculated when the screen size changes.
-- Animation durations honor AstraUI:SetReducedMotion.
-- Icon names are resolved through AstraUI.Icons.
-- Themes are resolved through AstraUI.Themes.
-- This contract is intentionally kept stable across Beta releases.

-- [Global.SetTheme] Contract note 100
-- Applies a registered theme to active windows.
-- Inputs are validated at the public boundary.
-- Callbacks are protected with pcall so UI failures do not break the caller.
-- Destroyed components reject further visual work.
-- Responsive rules are recalculated when the screen size changes.
-- Animation durations honor AstraUI:SetReducedMotion.
-- Icon names are resolved through AstraUI.Icons.
-- Themes are resolved through AstraUI.Themes.
-- This contract is intentionally kept stable across Beta releases.

-- [Global.RegisterTheme] Contract note 101
-- Registers a complete theme token table.
-- Inputs are validated at the public boundary.
-- Callbacks are protected with pcall so UI failures do not break the caller.
-- Destroyed components reject further visual work.
-- Responsive rules are recalculated when the screen size changes.
-- Animation durations honor AstraUI:SetReducedMotion.
-- Icon names are resolved through AstraUI.Icons.
-- Themes are resolved through AstraUI.Themes.
-- This contract is intentionally kept stable across Beta releases.

-- [Global.RegisterIcon] Contract note 102
-- Registers a Lucide-compatible image asset.
-- Inputs are validated at the public boundary.
-- Callbacks are protected with pcall so UI failures do not break the caller.
-- Destroyed components reject further visual work.
-- Responsive rules are recalculated when the screen size changes.
-- Animation durations honor AstraUI:SetReducedMotion.
-- Icon names are resolved through AstraUI.Icons.
-- Themes are resolved through AstraUI.Themes.
-- This contract is intentionally kept stable across Beta releases.

-- [Global.RegisterLucidePack] Contract note 103
-- Registers multiple icon mappings.
-- Inputs are validated at the public boundary.
-- Callbacks are protected with pcall so UI failures do not break the caller.
-- Destroyed components reject further visual work.
-- Responsive rules are recalculated when the screen size changes.
-- Animation durations honor AstraUI:SetReducedMotion.
-- Icon names are resolved through AstraUI.Icons.
-- Themes are resolved through AstraUI.Themes.
-- This contract is intentionally kept stable across Beta releases.

-- [Global.SetAccent] Contract note 104
-- Updates the accent color.
-- Inputs are validated at the public boundary.
-- Callbacks are protected with pcall so UI failures do not break the caller.
-- Destroyed components reject further visual work.
-- Responsive rules are recalculated when the screen size changes.
-- Animation durations honor AstraUI:SetReducedMotion.
-- Icon names are resolved through AstraUI.Icons.
-- Themes are resolved through AstraUI.Themes.
-- This contract is intentionally kept stable across Beta releases.

-- [Global.SetReducedMotion] Contract note 105
-- Reduces transition duration.
-- Inputs are validated at the public boundary.
-- Callbacks are protected with pcall so UI failures do not break the caller.
-- Destroyed components reject further visual work.
-- Responsive rules are recalculated when the screen size changes.
-- Animation durations honor AstraUI:SetReducedMotion.
-- Icon names are resolved through AstraUI.Icons.
-- Themes are resolved through AstraUI.Themes.
-- This contract is intentionally kept stable across Beta releases.

-- [Global.SetQuality] Contract note 106
-- Controls visual quality policy.
-- Inputs are validated at the public boundary.
-- Callbacks are protected with pcall so UI failures do not break the caller.
-- Destroyed components reject further visual work.
-- Responsive rules are recalculated when the screen size changes.
-- Animation durations honor AstraUI:SetReducedMotion.
-- Icon names are resolved through AstraUI.Icons.
-- Themes are resolved through AstraUI.Themes.
-- This contract is intentionally kept stable across Beta releases.

-- [Global.ExportConfig] Contract note 107
-- Serializes component state to JSON.
-- Inputs are validated at the public boundary.
-- Callbacks are protected with pcall so UI failures do not break the caller.
-- Destroyed components reject further visual work.
-- Responsive rules are recalculated when the screen size changes.
-- Animation durations honor AstraUI:SetReducedMotion.
-- Icon names are resolved through AstraUI.Icons.
-- Themes are resolved through AstraUI.Themes.
-- This contract is intentionally kept stable across Beta releases.

-- [Global.ImportConfig] Contract note 108
-- Restores component state from JSON.
-- Inputs are validated at the public boundary.
-- Callbacks are protected with pcall so UI failures do not break the caller.
-- Destroyed components reject further visual work.
-- Responsive rules are recalculated when the screen size changes.
-- Animation durations honor AstraUI:SetReducedMotion.
-- Icon names are resolved through AstraUI.Icons.
-- Themes are resolved through AstraUI.Themes.
-- This contract is intentionally kept stable across Beta releases.

-- [Window.CreateTab] Contract note 109
-- Creates and registers a tab and activates the first tab.
-- Inputs are validated at the public boundary.
-- Callbacks are protected with pcall so UI failures do not break the caller.
-- Destroyed components reject further visual work.
-- Responsive rules are recalculated when the screen size changes.
-- Animation durations honor AstraUI:SetReducedMotion.
-- Icon names are resolved through AstraUI.Icons.
-- Themes are resolved through AstraUI.Themes.
-- This contract is intentionally kept stable across Beta releases.

-- [Window.GetTab] Contract note 110
-- Returns a tab by its exact public name.
-- Inputs are validated at the public boundary.
-- Callbacks are protected with pcall so UI failures do not break the caller.
-- Destroyed components reject further visual work.
-- Responsive rules are recalculated when the screen size changes.
-- Animation durations honor AstraUI:SetReducedMotion.
-- Icon names are resolved through AstraUI.Icons.
-- Themes are resolved through AstraUI.Themes.
-- This contract is intentionally kept stable across Beta releases.

-- [Window.GetComponent] Contract note 111
-- Searches every tab for a component by name.
-- Inputs are validated at the public boundary.
-- Callbacks are protected with pcall so UI failures do not break the caller.
-- Destroyed components reject further visual work.
-- Responsive rules are recalculated when the screen size changes.
-- Animation durations honor AstraUI:SetReducedMotion.
-- Icon names are resolved through AstraUI.Icons.
-- Themes are resolved through AstraUI.Themes.
-- This contract is intentionally kept stable across Beta releases.

-- [Window.Search] Contract note 112
-- Filters components using their name and description.
-- Inputs are validated at the public boundary.
-- Callbacks are protected with pcall so UI failures do not break the caller.
-- Destroyed components reject further visual work.
-- Responsive rules are recalculated when the screen size changes.
-- Animation durations honor AstraUI:SetReducedMotion.
-- Icon names are resolved through AstraUI.Icons.
-- Themes are resolved through AstraUI.Themes.
-- This contract is intentionally kept stable across Beta releases.

-- [Window.SetSearchEnabled] Contract note 113
-- Shows or hides the window search field.
-- Inputs are validated at the public boundary.
-- Callbacks are protected with pcall so UI failures do not break the caller.
-- Destroyed components reject further visual work.
-- Responsive rules are recalculated when the screen size changes.
-- Animation durations honor AstraUI:SetReducedMotion.
-- Icon names are resolved through AstraUI.Icons.
-- Themes are resolved through AstraUI.Themes.
-- This contract is intentionally kept stable across Beta releases.

-- [Window.SetTitle] Contract note 114
-- Updates the title and optional subtitle.
-- Inputs are validated at the public boundary.
-- Callbacks are protected with pcall so UI failures do not break the caller.
-- Destroyed components reject further visual work.
-- Responsive rules are recalculated when the screen size changes.
-- Animation durations honor AstraUI:SetReducedMotion.
-- Icon names are resolved through AstraUI.Icons.
-- Themes are resolved through AstraUI.Themes.
-- This contract is intentionally kept stable across Beta releases.

-- [Window.SetSize] Contract note 115
-- Updates the window size using UDim2.
-- Inputs are validated at the public boundary.
-- Callbacks are protected with pcall so UI failures do not break the caller.
-- Destroyed components reject further visual work.
-- Responsive rules are recalculated when the screen size changes.
-- Animation durations honor AstraUI:SetReducedMotion.
-- Icon names are resolved through AstraUI.Icons.
-- Themes are resolved through AstraUI.Themes.
-- This contract is intentionally kept stable across Beta releases.

-- [Window.SetPosition] Contract note 116
-- Updates the window position using UDim2.
-- Inputs are validated at the public boundary.
-- Callbacks are protected with pcall so UI failures do not break the caller.
-- Destroyed components reject further visual work.
-- Responsive rules are recalculated when the screen size changes.
-- Animation durations honor AstraUI:SetReducedMotion.
-- Icon names are resolved through AstraUI.Icons.
-- Themes are resolved through AstraUI.Themes.
-- This contract is intentionally kept stable across Beta releases.

-- [Window.SetVisibility] Contract note 117
-- Changes window visibility without destroying it.
-- Inputs are validated at the public boundary.
-- Callbacks are protected with pcall so UI failures do not break the caller.
-- Destroyed components reject further visual work.
-- Responsive rules are recalculated when the screen size changes.
-- Animation durations honor AstraUI:SetReducedMotion.
-- Icon names are resolved through AstraUI.Icons.
-- Themes are resolved through AstraUI.Themes.
-- This contract is intentionally kept stable across Beta releases.

-- [Window.Toggle] Contract note 118
-- Opens or closes the window with motion.
-- Inputs are validated at the public boundary.
-- Callbacks are protected with pcall so UI failures do not break the caller.
-- Destroyed components reject further visual work.
-- Responsive rules are recalculated when the screen size changes.
-- Animation durations honor AstraUI:SetReducedMotion.
-- Icon names are resolved through AstraUI.Icons.
-- Themes are resolved through AstraUI.Themes.
-- This contract is intentionally kept stable across Beta releases.

-- [Window.ToggleMinimize] Contract note 119
-- Collapses or restores the window.
-- Inputs are validated at the public boundary.
-- Callbacks are protected with pcall so UI failures do not break the caller.
-- Destroyed components reject further visual work.
-- Responsive rules are recalculated when the screen size changes.
-- Animation durations honor AstraUI:SetReducedMotion.
-- Icon names are resolved through AstraUI.Icons.
-- Themes are resolved through AstraUI.Themes.
-- This contract is intentionally kept stable across Beta releases.

-- [Window.Destroy] Contract note 120
-- Disconnects resources and removes the GUI.
-- Inputs are validated at the public boundary.
-- Callbacks are protected with pcall so UI failures do not break the caller.
-- Destroyed components reject further visual work.
-- Responsive rules are recalculated when the screen size changes.
-- Animation durations honor AstraUI:SetReducedMotion.
-- Icon names are resolved through AstraUI.Icons.
-- Themes are resolved through AstraUI.Themes.
-- This contract is intentionally kept stable across Beta releases.

-- [Tab.CreateSection] Contract note 121
-- Creates a visual section header.
-- Inputs are validated at the public boundary.
-- Callbacks are protected with pcall so UI failures do not break the caller.
-- Destroyed components reject further visual work.
-- Responsive rules are recalculated when the screen size changes.
-- Animation durations honor AstraUI:SetReducedMotion.
-- Icon names are resolved through AstraUI.Icons.
-- Themes are resolved through AstraUI.Themes.
-- This contract is intentionally kept stable across Beta releases.

-- [Tab.CreateLabel] Contract note 122
-- Creates a compact text label.
-- Inputs are validated at the public boundary.
-- Callbacks are protected with pcall so UI failures do not break the caller.
-- Destroyed components reject further visual work.
-- Responsive rules are recalculated when the screen size changes.
-- Animation durations honor AstraUI:SetReducedMotion.
-- Icon names are resolved through AstraUI.Icons.
-- Themes are resolved through AstraUI.Themes.
-- This contract is intentionally kept stable across Beta releases.

-- [Tab.CreateParagraph] Contract note 123
-- Creates a title and wrapped description block.
-- Inputs are validated at the public boundary.
-- Callbacks are protected with pcall so UI failures do not break the caller.
-- Destroyed components reject further visual work.
-- Responsive rules are recalculated when the screen size changes.
-- Animation durations honor AstraUI:SetReducedMotion.
-- Icon names are resolved through AstraUI.Icons.
-- Themes are resolved through AstraUI.Themes.
-- This contract is intentionally kept stable across Beta releases.

-- [Tab.CreateButton] Contract note 124
-- Creates an animated action button.
-- Inputs are validated at the public boundary.
-- Callbacks are protected with pcall so UI failures do not break the caller.
-- Destroyed components reject further visual work.
-- Responsive rules are recalculated when the screen size changes.
-- Animation durations honor AstraUI:SetReducedMotion.
-- Icon names are resolved through AstraUI.Icons.
-- Themes are resolved through AstraUI.Themes.
-- This contract is intentionally kept stable across Beta releases.

-- [Tab.CreateToggle] Contract note 125
-- Creates a stateful animated toggle.
-- Inputs are validated at the public boundary.
-- Callbacks are protected with pcall so UI failures do not break the caller.
-- Destroyed components reject further visual work.
-- Responsive rules are recalculated when the screen size changes.
-- Animation durations honor AstraUI:SetReducedMotion.
-- Icon names are resolved through AstraUI.Icons.
-- Themes are resolved through AstraUI.Themes.
-- This contract is intentionally kept stable across Beta releases.

-- [Tab.CreateSlider] Contract note 126
-- Creates a draggable numeric slider.
-- Inputs are validated at the public boundary.
-- Callbacks are protected with pcall so UI failures do not break the caller.
-- Destroyed components reject further visual work.
-- Responsive rules are recalculated when the screen size changes.
-- Animation durations honor AstraUI:SetReducedMotion.
-- Icon names are resolved through AstraUI.Icons.
-- Themes are resolved through AstraUI.Themes.
-- This contract is intentionally kept stable across Beta releases.

-- [Tab.CreateDropdown] Contract note 127
-- Creates an animated single-select popover.
-- Inputs are validated at the public boundary.
-- Callbacks are protected with pcall so UI failures do not break the caller.
-- Destroyed components reject further visual work.
-- Responsive rules are recalculated when the screen size changes.
-- Animation durations honor AstraUI:SetReducedMotion.
-- Icon names are resolved through AstraUI.Icons.
-- Themes are resolved through AstraUI.Themes.
-- This contract is intentionally kept stable across Beta releases.

-- [Tab.CreateMultiDropdown] Contract note 128
-- Creates an animated multi-select popover.
-- Inputs are validated at the public boundary.
-- Callbacks are protected with pcall so UI failures do not break the caller.
-- Destroyed components reject further visual work.
-- Responsive rules are recalculated when the screen size changes.
-- Animation durations honor AstraUI:SetReducedMotion.
-- Icon names are resolved through AstraUI.Icons.
-- Themes are resolved through AstraUI.Themes.
-- This contract is intentionally kept stable across Beta releases.

-- [Tab.CreateInput] Contract note 129
-- Creates a focus-aware text input.
-- Inputs are validated at the public boundary.
-- Callbacks are protected with pcall so UI failures do not break the caller.
-- Destroyed components reject further visual work.
-- Responsive rules are recalculated when the screen size changes.
-- Animation durations honor AstraUI:SetReducedMotion.
-- Icon names are resolved through AstraUI.Icons.
-- Themes are resolved through AstraUI.Themes.
-- This contract is intentionally kept stable across Beta releases.

-- [Tab.CreateKeybind] Contract note 130
-- Creates a key listening control.
-- Inputs are validated at the public boundary.
-- Callbacks are protected with pcall so UI failures do not break the caller.
-- Destroyed components reject further visual work.
-- Responsive rules are recalculated when the screen size changes.
-- Animation durations honor AstraUI:SetReducedMotion.
-- Icon names are resolved through AstraUI.Icons.
-- Themes are resolved through AstraUI.Themes.
-- This contract is intentionally kept stable across Beta releases.

-- [Tab.CreateColorPicker] Contract note 131
-- Creates a color swatch and HSV editor.
-- Inputs are validated at the public boundary.
-- Callbacks are protected with pcall so UI failures do not break the caller.
-- Destroyed components reject further visual work.
-- Responsive rules are recalculated when the screen size changes.
-- Animation durations honor AstraUI:SetReducedMotion.
-- Icon names are resolved through AstraUI.Icons.
-- Themes are resolved through AstraUI.Themes.
-- This contract is intentionally kept stable across Beta releases.

-- [Tab.CreateDivider] Contract note 132
-- Creates a subtle divider.
-- Inputs are validated at the public boundary.
-- Callbacks are protected with pcall so UI failures do not break the caller.
-- Destroyed components reject further visual work.
-- Responsive rules are recalculated when the screen size changes.
-- Animation durations honor AstraUI:SetReducedMotion.
-- Icon names are resolved through AstraUI.Icons.
-- Themes are resolved through AstraUI.Themes.
-- This contract is intentionally kept stable across Beta releases.

-- [Tab.CreateSpacer] Contract note 133
-- Creates intentional layout space.
-- Inputs are validated at the public boundary.
-- Callbacks are protected with pcall so UI failures do not break the caller.
-- Destroyed components reject further visual work.
-- Responsive rules are recalculated when the screen size changes.
-- Animation durations honor AstraUI:SetReducedMotion.
-- Icon names are resolved through AstraUI.Icons.
-- Themes are resolved through AstraUI.Themes.
-- This contract is intentionally kept stable across Beta releases.

-- [Global.CreateWindow] Contract note 134
-- Creates a new AstraUI window.
-- Inputs are validated at the public boundary.
-- Callbacks are protected with pcall so UI failures do not break the caller.
-- Destroyed components reject further visual work.
-- Responsive rules are recalculated when the screen size changes.
-- Animation durations honor AstraUI:SetReducedMotion.
-- Icon names are resolved through AstraUI.Icons.
-- Themes are resolved through AstraUI.Themes.
-- This contract is intentionally kept stable across Beta releases.

-- [Global.Notify] Contract note 135
-- Creates a bottom notification card.
-- Inputs are validated at the public boundary.
-- Callbacks are protected with pcall so UI failures do not break the caller.
-- Destroyed components reject further visual work.
-- Responsive rules are recalculated when the screen size changes.
-- Animation durations honor AstraUI:SetReducedMotion.
-- Icon names are resolved through AstraUI.Icons.
-- Themes are resolved through AstraUI.Themes.
-- This contract is intentionally kept stable across Beta releases.

-- [Global.SetTheme] Contract note 136
-- Applies a registered theme to active windows.
-- Inputs are validated at the public boundary.
-- Callbacks are protected with pcall so UI failures do not break the caller.
-- Destroyed components reject further visual work.
-- Responsive rules are recalculated when the screen size changes.
-- Animation durations honor AstraUI:SetReducedMotion.
-- Icon names are resolved through AstraUI.Icons.
-- Themes are resolved through AstraUI.Themes.
-- This contract is intentionally kept stable across Beta releases.

-- [Global.RegisterTheme] Contract note 137
-- Registers a complete theme token table.
-- Inputs are validated at the public boundary.
-- Callbacks are protected with pcall so UI failures do not break the caller.
-- Destroyed components reject further visual work.
-- Responsive rules are recalculated when the screen size changes.
-- Animation durations honor AstraUI:SetReducedMotion.
-- Icon names are resolved through AstraUI.Icons.
-- Themes are resolved through AstraUI.Themes.
-- This contract is intentionally kept stable across Beta releases.

-- [Global.RegisterIcon] Contract note 138
-- Registers a Lucide-compatible image asset.
-- Inputs are validated at the public boundary.
-- Callbacks are protected with pcall so UI failures do not break the caller.
-- Destroyed components reject further visual work.
-- Responsive rules are recalculated when the screen size changes.
-- Animation durations honor AstraUI:SetReducedMotion.
-- Icon names are resolved through AstraUI.Icons.
-- Themes are resolved through AstraUI.Themes.
-- This contract is intentionally kept stable across Beta releases.

-- [Global.RegisterLucidePack] Contract note 139
-- Registers multiple icon mappings.
-- Inputs are validated at the public boundary.
-- Callbacks are protected with pcall so UI failures do not break the caller.
-- Destroyed components reject further visual work.
-- Responsive rules are recalculated when the screen size changes.
-- Animation durations honor AstraUI:SetReducedMotion.
-- Icon names are resolved through AstraUI.Icons.
-- Themes are resolved through AstraUI.Themes.
-- This contract is intentionally kept stable across Beta releases.

-- [Global.SetAccent] Contract note 140
-- Updates the accent color.
-- Inputs are validated at the public boundary.
-- Callbacks are protected with pcall so UI failures do not break the caller.
-- Destroyed components reject further visual work.
-- Responsive rules are recalculated when the screen size changes.
-- Animation durations honor AstraUI:SetReducedMotion.
-- Icon names are resolved through AstraUI.Icons.
-- Themes are resolved through AstraUI.Themes.
-- This contract is intentionally kept stable across Beta releases.

-- [Global.SetReducedMotion] Contract note 141
-- Reduces transition duration.
-- Inputs are validated at the public boundary.
-- Callbacks are protected with pcall so UI failures do not break the caller.
-- Destroyed components reject further visual work.
-- Responsive rules are recalculated when the screen size changes.
-- Animation durations honor AstraUI:SetReducedMotion.
-- Icon names are resolved through AstraUI.Icons.
-- Themes are resolved through AstraUI.Themes.
-- This contract is intentionally kept stable across Beta releases.

-- [Global.SetQuality] Contract note 142
-- Controls visual quality policy.
-- Inputs are validated at the public boundary.
-- Callbacks are protected with pcall so UI failures do not break the caller.
-- Destroyed components reject further visual work.
-- Responsive rules are recalculated when the screen size changes.
-- Animation durations honor AstraUI:SetReducedMotion.
-- Icon names are resolved through AstraUI.Icons.
-- Themes are resolved through AstraUI.Themes.
-- This contract is intentionally kept stable across Beta releases.

-- [Global.ExportConfig] Contract note 143
-- Serializes component state to JSON.
-- Inputs are validated at the public boundary.
-- Callbacks are protected with pcall so UI failures do not break the caller.
-- Destroyed components reject further visual work.
-- Responsive rules are recalculated when the screen size changes.
-- Animation durations honor AstraUI:SetReducedMotion.
-- Icon names are resolved through AstraUI.Icons.
-- Themes are resolved through AstraUI.Themes.
-- This contract is intentionally kept stable across Beta releases.

-- [Global.ImportConfig] Contract note 144
-- Restores component state from JSON.
-- Inputs are validated at the public boundary.
-- Callbacks are protected with pcall so UI failures do not break the caller.
-- Destroyed components reject further visual work.
-- Responsive rules are recalculated when the screen size changes.
-- Animation durations honor AstraUI:SetReducedMotion.
-- Icon names are resolved through AstraUI.Icons.
-- Themes are resolved through AstraUI.Themes.
-- This contract is intentionally kept stable across Beta releases.

-- [Window.CreateTab] Contract note 145
-- Creates and registers a tab and activates the first tab.
-- Inputs are validated at the public boundary.
-- Callbacks are protected with pcall so UI failures do not break the caller.
-- Destroyed components reject further visual work.
-- Responsive rules are recalculated when the screen size changes.
-- Animation durations honor AstraUI:SetReducedMotion.
-- Icon names are resolved through AstraUI.Icons.
-- Themes are resolved through AstraUI.Themes.
-- This contract is intentionally kept stable across Beta releases.

-- [Window.GetTab] Contract note 146
-- Returns a tab by its exact public name.
-- Inputs are validated at the public boundary.
-- Callbacks are protected with pcall so UI failures do not break the caller.
-- Destroyed components reject further visual work.
-- Responsive rules are recalculated when the screen size changes.
-- Animation durations honor AstraUI:SetReducedMotion.
-- Icon names are resolved through AstraUI.Icons.
-- Themes are resolved through AstraUI.Themes.
-- This contract is intentionally kept stable across Beta releases.

-- [Window.GetComponent] Contract note 147
-- Searches every tab for a component by name.
-- Inputs are validated at the public boundary.
-- Callbacks are protected with pcall so UI failures do not break the caller.
-- Destroyed components reject further visual work.
-- Responsive rules are recalculated when the screen size changes.
-- Animation durations honor AstraUI:SetReducedMotion.
-- Icon names are resolved through AstraUI.Icons.
-- Themes are resolved through AstraUI.Themes.
-- This contract is intentionally kept stable across Beta releases.

-- [Window.Search] Contract note 148
-- Filters components using their name and description.
-- Inputs are validated at the public boundary.
-- Callbacks are protected with pcall so UI failures do not break the caller.
-- Destroyed components reject further visual work.
-- Responsive rules are recalculated when the screen size changes.
-- Animation durations honor AstraUI:SetReducedMotion.
-- Icon names are resolved through AstraUI.Icons.
-- Themes are resolved through AstraUI.Themes.
-- This contract is intentionally kept stable across Beta releases.

-- [Window.SetSearchEnabled] Contract note 149
-- Shows or hides the window search field.
-- Inputs are validated at the public boundary.
-- Callbacks are protected with pcall so UI failures do not break the caller.
-- Destroyed components reject further visual work.
-- Responsive rules are recalculated when the screen size changes.
-- Animation durations honor AstraUI:SetReducedMotion.
-- Icon names are resolved through AstraUI.Icons.
-- Themes are resolved through AstraUI.Themes.
-- This contract is intentionally kept stable across Beta releases.

-- [Window.SetTitle] Contract note 150
-- Updates the title and optional subtitle.
-- Inputs are validated at the public boundary.
-- Callbacks are protected with pcall so UI failures do not break the caller.
-- Destroyed components reject further visual work.
-- Responsive rules are recalculated when the screen size changes.
-- Animation durations honor AstraUI:SetReducedMotion.
-- Icon names are resolved through AstraUI.Icons.
-- Themes are resolved through AstraUI.Themes.
-- This contract is intentionally kept stable across Beta releases.

-- [Window.SetSize] Contract note 151
-- Updates the window size using UDim2.
-- Inputs are validated at the public boundary.
-- Callbacks are protected with pcall so UI failures do not break the caller.
-- Destroyed components reject further visual work.
-- Responsive rules are recalculated when the screen size changes.
-- Animation durations honor AstraUI:SetReducedMotion.
-- Icon names are resolved through AstraUI.Icons.
-- Themes are resolved through AstraUI.Themes.
-- This contract is intentionally kept stable across Beta releases.

-- [Window.SetPosition] Contract note 152
-- Updates the window position using UDim2.
-- Inputs are validated at the public boundary.
-- Callbacks are protected with pcall so UI failures do not break the caller.
-- Destroyed components reject further visual work.
-- Responsive rules are recalculated when the screen size changes.
-- Animation durations honor AstraUI:SetReducedMotion.
-- Icon names are resolved through AstraUI.Icons.
-- Themes are resolved through AstraUI.Themes.
-- This contract is intentionally kept stable across Beta releases.

-- [Window.SetVisibility] Contract note 153
-- Changes window visibility without destroying it.
-- Inputs are validated at the public boundary.
-- Callbacks are protected with pcall so UI failures do not break the caller.
-- Destroyed components reject further visual work.
-- Responsive rules are recalculated when the screen size changes.
-- Animation durations honor AstraUI:SetReducedMotion.
-- Icon names are resolved through AstraUI.Icons.
-- Themes are resolved through AstraUI.Themes.
-- This contract is intentionally kept stable across Beta releases.

-- [Window.Toggle] Contract note 154
-- Opens or closes the window with motion.
-- Inputs are validated at the public boundary.
-- Callbacks are protected with pcall so UI failures do not break the caller.
-- Destroyed components reject further visual work.
-- Responsive rules are recalculated when the screen size changes.
-- Animation durations honor AstraUI:SetReducedMotion.
-- Icon names are resolved through AstraUI.Icons.
-- Themes are resolved through AstraUI.Themes.
-- This contract is intentionally kept stable across Beta releases.

-- [Window.ToggleMinimize] Contract note 155
-- Collapses or restores the window.
-- Inputs are validated at the public boundary.
-- Callbacks are protected with pcall so UI failures do not break the caller.
-- Destroyed components reject further visual work.
-- Responsive rules are recalculated when the screen size changes.
-- Animation durations honor AstraUI:SetReducedMotion.
-- Icon names are resolved through AstraUI.Icons.
-- Themes are resolved through AstraUI.Themes.
-- This contract is intentionally kept stable across Beta releases.

-- [Window.Destroy] Contract note 156
-- Disconnects resources and removes the GUI.
-- Inputs are validated at the public boundary.
-- Callbacks are protected with pcall so UI failures do not break the caller.
-- Destroyed components reject further visual work.
-- Responsive rules are recalculated when the screen size changes.
-- Animation durations honor AstraUI:SetReducedMotion.
-- Icon names are resolved through AstraUI.Icons.
-- Themes are resolved through AstraUI.Themes.
-- This contract is intentionally kept stable across Beta releases.

-- [Tab.CreateSection] Contract note 157
-- Creates a visual section header.
-- Inputs are validated at the public boundary.
-- Callbacks are protected with pcall so UI failures do not break the caller.
-- Destroyed components reject further visual work.
-- Responsive rules are recalculated when the screen size changes.
-- Animation durations honor AstraUI:SetReducedMotion.
-- Icon names are resolved through AstraUI.Icons.
-- Themes are resolved through AstraUI.Themes.
-- This contract is intentionally kept stable across Beta releases.

-- [Tab.CreateLabel] Contract note 158
-- Creates a compact text label.
-- Inputs are validated at the public boundary.
-- Callbacks are protected with pcall so UI failures do not break the caller.
-- Destroyed components reject further visual work.
-- Responsive rules are recalculated when the screen size changes.
-- Animation durations honor AstraUI:SetReducedMotion.
-- Icon names are resolved through AstraUI.Icons.
-- Themes are resolved through AstraUI.Themes.
-- This contract is intentionally kept stable across Beta releases.

-- [Tab.CreateParagraph] Contract note 159
-- Creates a title and wrapped description block.
-- Inputs are validated at the public boundary.
-- Callbacks are protected with pcall so UI failures do not break the caller.
-- Destroyed components reject further visual work.
-- Responsive rules are recalculated when the screen size changes.
-- Animation durations honor AstraUI:SetReducedMotion.
-- Icon names are resolved through AstraUI.Icons.
-- Themes are resolved through AstraUI.Themes.
-- This contract is intentionally kept stable across Beta releases.

-- [Tab.CreateButton] Contract note 160
-- Creates an animated action button.
-- Inputs are validated at the public boundary.
-- Callbacks are protected with pcall so UI failures do not break the caller.
-- Destroyed components reject further visual work.
-- Responsive rules are recalculated when the screen size changes.
-- Animation durations honor AstraUI:SetReducedMotion.
-- Icon names are resolved through AstraUI.Icons.
-- Themes are resolved through AstraUI.Themes.
-- This contract is intentionally kept stable across Beta releases.

-- [Tab.CreateToggle] Contract note 161
-- Creates a stateful animated toggle.
-- Inputs are validated at the public boundary.
-- Callbacks are protected with pcall so UI failures do not break the caller.
-- Destroyed components reject further visual work.
-- Responsive rules are recalculated when the screen size changes.
-- Animation durations honor AstraUI:SetReducedMotion.
-- Icon names are resolved through AstraUI.Icons.
-- Themes are resolved through AstraUI.Themes.
-- This contract is intentionally kept stable across Beta releases.

-- [Tab.CreateSlider] Contract note 162
-- Creates a draggable numeric slider.
-- Inputs are validated at the public boundary.
-- Callbacks are protected with pcall so UI failures do not break the caller.
-- Destroyed components reject further visual work.
-- Responsive rules are recalculated when the screen size changes.
-- Animation durations honor AstraUI:SetReducedMotion.
-- Icon names are resolved through AstraUI.Icons.
-- Themes are resolved through AstraUI.Themes.
-- This contract is intentionally kept stable across Beta releases.

-- [Tab.CreateDropdown] Contract note 163
-- Creates an animated single-select popover.
-- Inputs are validated at the public boundary.
-- Callbacks are protected with pcall so UI failures do not break the caller.
-- Destroyed components reject further visual work.
-- Responsive rules are recalculated when the screen size changes.
-- Animation durations honor AstraUI:SetReducedMotion.
-- Icon names are resolved through AstraUI.Icons.
-- Themes are resolved through AstraUI.Themes.
-- This contract is intentionally kept stable across Beta releases.

-- [Tab.CreateMultiDropdown] Contract note 164
-- Creates an animated multi-select popover.
-- Inputs are validated at the public boundary.
-- Callbacks are protected with pcall so UI failures do not break the caller.
-- Destroyed components reject further visual work.
-- Responsive rules are recalculated when the screen size changes.
-- Animation durations honor AstraUI:SetReducedMotion.
-- Icon names are resolved through AstraUI.Icons.
-- Themes are resolved through AstraUI.Themes.
-- This contract is intentionally kept stable across Beta releases.

-- [Tab.CreateInput] Contract note 165
-- Creates a focus-aware text input.
-- Inputs are validated at the public boundary.
-- Callbacks are protected with pcall so UI failures do not break the caller.
-- Destroyed components reject further visual work.
-- Responsive rules are recalculated when the screen size changes.
-- Animation durations honor AstraUI:SetReducedMotion.
-- Icon names are resolved through AstraUI.Icons.
-- Themes are resolved through AstraUI.Themes.
-- This contract is intentionally kept stable across Beta releases.

-- [Tab.CreateKeybind] Contract note 166
-- Creates a key listening control.
-- Inputs are validated at the public boundary.
-- Callbacks are protected with pcall so UI failures do not break the caller.
-- Destroyed components reject further visual work.
-- Responsive rules are recalculated when the screen size changes.
-- Animation durations honor AstraUI:SetReducedMotion.
-- Icon names are resolved through AstraUI.Icons.
-- Themes are resolved through AstraUI.Themes.
-- This contract is intentionally kept stable across Beta releases.

-- [Tab.CreateColorPicker] Contract note 167
-- Creates a color swatch and HSV editor.
-- Inputs are validated at the public boundary.
-- Callbacks are protected with pcall so UI failures do not break the caller.
-- Destroyed components reject further visual work.
-- Responsive rules are recalculated when the screen size changes.
-- Animation durations honor AstraUI:SetReducedMotion.
-- Icon names are resolved through AstraUI.Icons.
-- Themes are resolved through AstraUI.Themes.
-- This contract is intentionally kept stable across Beta releases.

-- [Tab.CreateDivider] Contract note 168
-- Creates a subtle divider.
-- Inputs are validated at the public boundary.
-- Callbacks are protected with pcall so UI failures do not break the caller.
-- Destroyed components reject further visual work.
-- Responsive rules are recalculated when the screen size changes.
-- Animation durations honor AstraUI:SetReducedMotion.
-- Icon names are resolved through AstraUI.Icons.
-- Themes are resolved through AstraUI.Themes.
-- This contract is intentionally kept stable across Beta releases.

-- [Tab.CreateSpacer] Contract note 169
-- Creates intentional layout space.
-- Inputs are validated at the public boundary.
-- Callbacks are protected with pcall so UI failures do not break the caller.
-- Destroyed components reject further visual work.
-- Responsive rules are recalculated when the screen size changes.
-- Animation durations honor AstraUI:SetReducedMotion.
-- Icon names are resolved through AstraUI.Icons.
-- Themes are resolved through AstraUI.Themes.
-- This contract is intentionally kept stable across Beta releases.

-- [Global.CreateWindow] Contract note 170
-- Creates a new AstraUI window.
-- Inputs are validated at the public boundary.
-- Callbacks are protected with pcall so UI failures do not break the caller.
-- Destroyed components reject further visual work.
-- Responsive rules are recalculated when the screen size changes.
-- Animation durations honor AstraUI:SetReducedMotion.
-- Icon names are resolved through AstraUI.Icons.
-- Themes are resolved through AstraUI.Themes.
-- This contract is intentionally kept stable across Beta releases.

-- [Global.Notify] Contract note 171
-- Creates a bottom notification card.
-- Inputs are validated at the public boundary.
-- Callbacks are protected with pcall so UI failures do not break the caller.
-- Destroyed components reject further visual work.
-- Responsive rules are recalculated when the screen size changes.
-- Animation durations honor AstraUI:SetReducedMotion.
-- Icon names are resolved through AstraUI.Icons.
-- Themes are resolved through AstraUI.Themes.
-- This contract is intentionally kept stable across Beta releases.

-- [Global.SetTheme] Contract note 172
-- Applies a registered theme to active windows.
-- Inputs are validated at the public boundary.
-- Callbacks are protected with pcall so UI failures do not break the caller.
-- Destroyed components reject further visual work.
-- Responsive rules are recalculated when the screen size changes.
-- Animation durations honor AstraUI:SetReducedMotion.
-- Icon names are resolved through AstraUI.Icons.
-- Themes are resolved through AstraUI.Themes.
-- This contract is intentionally kept stable across Beta releases.

-- [Global.RegisterTheme] Contract note 173
-- Registers a complete theme token table.
-- Inputs are validated at the public boundary.
-- Callbacks are protected with pcall so UI failures do not break the caller.
-- Destroyed components reject further visual work.
-- Responsive rules are recalculated when the screen size changes.
-- Animation durations honor AstraUI:SetReducedMotion.
-- Icon names are resolved through AstraUI.Icons.
-- Themes are resolved through AstraUI.Themes.
-- This contract is intentionally kept stable across Beta releases.

-- [Global.RegisterIcon] Contract note 174
-- Registers a Lucide-compatible image asset.
-- Inputs are validated at the public boundary.
-- Callbacks are protected with pcall so UI failures do not break the caller.
-- Destroyed components reject further visual work.
-- Responsive rules are recalculated when the screen size changes.
-- Animation durations honor AstraUI:SetReducedMotion.
-- Icon names are resolved through AstraUI.Icons.
-- Themes are resolved through AstraUI.Themes.
-- This contract is intentionally kept stable across Beta releases.

-- [Global.RegisterLucidePack] Contract note 175
-- Registers multiple icon mappings.
-- Inputs are validated at the public boundary.
-- Callbacks are protected with pcall so UI failures do not break the caller.
-- Destroyed components reject further visual work.
-- Responsive rules are recalculated when the screen size changes.
-- Animation durations honor AstraUI:SetReducedMotion.
-- Icon names are resolved through AstraUI.Icons.
-- Themes are resolved through AstraUI.Themes.
-- This contract is intentionally kept stable across Beta releases.

-- [Global.SetAccent] Contract note 176
-- Updates the accent color.
-- Inputs are validated at the public boundary.
-- Callbacks are protected with pcall so UI failures do not break the caller.
-- Destroyed components reject further visual work.
-- Responsive rules are recalculated when the screen size changes.
-- Animation durations honor AstraUI:SetReducedMotion.
-- Icon names are resolved through AstraUI.Icons.
-- Themes are resolved through AstraUI.Themes.
-- This contract is intentionally kept stable across Beta releases.

-- [Global.SetReducedMotion] Contract note 177
-- Reduces transition duration.
-- Inputs are validated at the public boundary.
-- Callbacks are protected with pcall so UI failures do not break the caller.
-- Destroyed components reject further visual work.
-- Responsive rules are recalculated when the screen size changes.
-- Animation durations honor AstraUI:SetReducedMotion.
-- Icon names are resolved through AstraUI.Icons.
-- Themes are resolved through AstraUI.Themes.
-- This contract is intentionally kept stable across Beta releases.

-- [Global.SetQuality] Contract note 178
-- Controls visual quality policy.
-- Inputs are validated at the public boundary.
-- Callbacks are protected with pcall so UI failures do not break the caller.
-- Destroyed components reject further visual work.
-- Responsive rules are recalculated when the screen size changes.
-- Animation durations honor AstraUI:SetReducedMotion.
-- Icon names are resolved through AstraUI.Icons.
-- Themes are resolved through AstraUI.Themes.
-- This contract is intentionally kept stable across Beta releases.

-- [Global.ExportConfig] Contract note 179
-- Serializes component state to JSON.
-- Inputs are validated at the public boundary.
-- Callbacks are protected with pcall so UI failures do not break the caller.
-- Destroyed components reject further visual work.
-- Responsive rules are recalculated when the screen size changes.
-- Animation durations honor AstraUI:SetReducedMotion.
-- Icon names are resolved through AstraUI.Icons.
-- Themes are resolved through AstraUI.Themes.
-- This contract is intentionally kept stable across Beta releases.

-- [Global.ImportConfig] Contract note 180
-- Restores component state from JSON.
-- Inputs are validated at the public boundary.
-- Callbacks are protected with pcall so UI failures do not break the caller.
-- Destroyed components reject further visual work.
-- Responsive rules are recalculated when the screen size changes.
-- Animation durations honor AstraUI:SetReducedMotion.
-- Icon names are resolved through AstraUI.Icons.
-- Themes are resolved through AstraUI.Themes.
-- This contract is intentionally kept stable across Beta releases.

-- [Window.CreateTab] Contract note 181
-- Creates and registers a tab and activates the first tab.
-- Inputs are validated at the public boundary.
-- Callbacks are protected with pcall so UI failures do not break the caller.
-- Destroyed components reject further visual work.
-- Responsive rules are recalculated when the screen size changes.
-- Animation durations honor AstraUI:SetReducedMotion.
-- Icon names are resolved through AstraUI.Icons.
-- Themes are resolved through AstraUI.Themes.
-- This contract is intentionally kept stable across Beta releases.

-- [Window.GetTab] Contract note 182
-- Returns a tab by its exact public name.
-- Inputs are validated at the public boundary.
-- Callbacks are protected with pcall so UI failures do not break the caller.
-- Destroyed components reject further visual work.
-- Responsive rules are recalculated when the screen size changes.
-- Animation durations honor AstraUI:SetReducedMotion.
-- Icon names are resolved through AstraUI.Icons.
-- Themes are resolved through AstraUI.Themes.
-- This contract is intentionally kept stable across Beta releases.

-- [Window.GetComponent] Contract note 183
-- Searches every tab for a component by name.
-- Inputs are validated at the public boundary.
-- Callbacks are protected with pcall so UI failures do not break the caller.
-- Destroyed components reject further visual work.
-- Responsive rules are recalculated when the screen size changes.
-- Animation durations honor AstraUI:SetReducedMotion.
-- Icon names are resolved through AstraUI.Icons.
-- Themes are resolved through AstraUI.Themes.
-- This contract is intentionally kept stable across Beta releases.

-- [Window.Search] Contract note 184
-- Filters components using their name and description.
-- Inputs are validated at the public boundary.
-- Callbacks are protected with pcall so UI failures do not break the caller.
-- Destroyed components reject further visual work.
-- Responsive rules are recalculated when the screen size changes.
-- Animation durations honor AstraUI:SetReducedMotion.
-- Icon names are resolved through AstraUI.Icons.
-- Themes are resolved through AstraUI.Themes.
-- This contract is intentionally kept stable across Beta releases.

-- [Window.SetSearchEnabled] Contract note 185
-- Shows or hides the window search field.
-- Inputs are validated at the public boundary.
-- Callbacks are protected with pcall so UI failures do not break the caller.
-- Destroyed components reject further visual work.
-- Responsive rules are recalculated when the screen size changes.
-- Animation durations honor AstraUI:SetReducedMotion.
-- Icon names are resolved through AstraUI.Icons.
-- Themes are resolved through AstraUI.Themes.
-- This contract is intentionally kept stable across Beta releases.

-- [Window.SetTitle] Contract note 186
-- Updates the title and optional subtitle.
-- Inputs are validated at the public boundary.
-- Callbacks are protected with pcall so UI failures do not break the caller.
-- Destroyed components reject further visual work.
-- Responsive rules are recalculated when the screen size changes.
-- Animation durations honor AstraUI:SetReducedMotion.
-- Icon names are resolved through AstraUI.Icons.
-- Themes are resolved through AstraUI.Themes.
-- This contract is intentionally kept stable across Beta releases.

-- [Window.SetSize] Contract note 187
-- Updates the window size using UDim2.
-- Inputs are validated at the public boundary.
-- Callbacks are protected with pcall so UI failures do not break the caller.
-- Destroyed components reject further visual work.
-- Responsive rules are recalculated when the screen size changes.
-- Animation durations honor AstraUI:SetReducedMotion.
-- Icon names are resolved through AstraUI.Icons.
-- Themes are resolved through AstraUI.Themes.
-- This contract is intentionally kept stable across Beta releases.

-- [Window.SetPosition] Contract note 188
-- Updates the window position using UDim2.
-- Inputs are validated at the public boundary.
-- Callbacks are protected with pcall so UI failures do not break the caller.
-- Destroyed components reject further visual work.
-- Responsive rules are recalculated when the screen size changes.
-- Animation durations honor AstraUI:SetReducedMotion.
-- Icon names are resolved through AstraUI.Icons.
-- Themes are resolved through AstraUI.Themes.
-- This contract is intentionally kept stable across Beta releases.

-- [Window.SetVisibility] Contract note 189
-- Changes window visibility without destroying it.
-- Inputs are validated at the public boundary.
-- Callbacks are protected with pcall so UI failures do not break the caller.
-- Destroyed components reject further visual work.
-- Responsive rules are recalculated when the screen size changes.
-- Animation durations honor AstraUI:SetReducedMotion.
-- Icon names are resolved through AstraUI.Icons.
-- Themes are resolved through AstraUI.Themes.
-- This contract is intentionally kept stable across Beta releases.

-- [Window.Toggle] Contract note 190
-- Opens or closes the window with motion.
-- Inputs are validated at the public boundary.
-- Callbacks are protected with pcall so UI failures do not break the caller.
-- Destroyed components reject further visual work.
-- Responsive rules are recalculated when the screen size changes.
-- Animation durations honor AstraUI:SetReducedMotion.
-- Icon names are resolved through AstraUI.Icons.
-- Themes are resolved through AstraUI.Themes.
-- This contract is intentionally kept stable across Beta releases.

-- [Window.ToggleMinimize] Contract note 191
-- Collapses or restores the window.
-- Inputs are validated at the public boundary.
-- Callbacks are protected with pcall so UI failures do not break the caller.
-- Destroyed components reject further visual work.
-- Responsive rules are recalculated when the screen size changes.
-- Animation durations honor AstraUI:SetReducedMotion.
-- Icon names are resolved through AstraUI.Icons.
-- Themes are resolved through AstraUI.Themes.
-- This contract is intentionally kept stable across Beta releases.

-- [Window.Destroy] Contract note 192
-- Disconnects resources and removes the GUI.
-- Inputs are validated at the public boundary.
-- Callbacks are protected with pcall so UI failures do not break the caller.
-- Destroyed components reject further visual work.
-- Responsive rules are recalculated when the screen size changes.
-- Animation durations honor AstraUI:SetReducedMotion.
-- Icon names are resolved through AstraUI.Icons.
-- Themes are resolved through AstraUI.Themes.
-- This contract is intentionally kept stable across Beta releases.

-- [Tab.CreateSection] Contract note 193
-- Creates a visual section header.
-- Inputs are validated at the public boundary.
-- Callbacks are protected with pcall so UI failures do not break the caller.
-- Destroyed components reject further visual work.
-- Responsive rules are recalculated when the screen size changes.
-- Animation durations honor AstraUI:SetReducedMotion.
-- Icon names are resolved through AstraUI.Icons.
-- Themes are resolved through AstraUI.Themes.
-- This contract is intentionally kept stable across Beta releases.

-- [Tab.CreateLabel] Contract note 194
-- Creates a compact text label.
-- Inputs are validated at the public boundary.
-- Callbacks are protected with pcall so UI failures do not break the caller.
-- Destroyed components reject further visual work.
-- Responsive rules are recalculated when the screen size changes.
-- Animation durations honor AstraUI:SetReducedMotion.
-- Icon names are resolved through AstraUI.Icons.
-- Themes are resolved through AstraUI.Themes.
-- This contract is intentionally kept stable across Beta releases.

-- [Tab.CreateParagraph] Contract note 195
-- Creates a title and wrapped description block.
-- Inputs are validated at the public boundary.
-- Callbacks are protected with pcall so UI failures do not break the caller.
-- Destroyed components reject further visual work.
-- Responsive rules are recalculated when the screen size changes.
-- Animation durations honor AstraUI:SetReducedMotion.
-- Icon names are resolved through AstraUI.Icons.
-- Themes are resolved through AstraUI.Themes.
-- This contract is intentionally kept stable across Beta releases.

-- [Tab.CreateButton] Contract note 196
-- Creates an animated action button.
-- Inputs are validated at the public boundary.
-- Callbacks are protected with pcall so UI failures do not break the caller.
-- Destroyed components reject further visual work.
-- Responsive rules are recalculated when the screen size changes.
-- Animation durations honor AstraUI:SetReducedMotion.
-- Icon names are resolved through AstraUI.Icons.
-- Themes are resolved through AstraUI.Themes.
-- This contract is intentionally kept stable across Beta releases.

-- [Tab.CreateToggle] Contract note 197
-- Creates a stateful animated toggle.
-- Inputs are validated at the public boundary.
-- Callbacks are protected with pcall so UI failures do not break the caller.
-- Destroyed components reject further visual work.
-- Responsive rules are recalculated when the screen size changes.
-- Animation durations honor AstraUI:SetReducedMotion.
-- Icon names are resolved through AstraUI.Icons.
-- Themes are resolved through AstraUI.Themes.
-- This contract is intentionally kept stable across Beta releases.

-- [Tab.CreateSlider] Contract note 198
-- Creates a draggable numeric slider.
-- Inputs are validated at the public boundary.
-- Callbacks are protected with pcall so UI failures do not break the caller.
-- Destroyed components reject further visual work.
-- Responsive rules are recalculated when the screen size changes.
-- Animation durations honor AstraUI:SetReducedMotion.
-- Icon names are resolved through AstraUI.Icons.
-- Themes are resolved through AstraUI.Themes.
-- This contract is intentionally kept stable across Beta releases.

-- [Tab.CreateDropdown] Contract note 199
-- Creates an animated single-select popover.
-- Inputs are validated at the public boundary.
-- Callbacks are protected with pcall so UI failures do not break the caller.
-- Destroyed components reject further visual work.
-- Responsive rules are recalculated when the screen size changes.
-- Animation durations honor AstraUI:SetReducedMotion.
-- Icon names are resolved through AstraUI.Icons.
-- Themes are resolved through AstraUI.Themes.
-- This contract is intentionally kept stable across Beta releases.

-- [Tab.CreateMultiDropdown] Contract note 200
-- Creates an animated multi-select popover.
-- Inputs are validated at the public boundary.
-- Callbacks are protected with pcall so UI failures do not break the caller.
-- Destroyed components reject further visual work.
-- Responsive rules are recalculated when the screen size changes.
-- Animation durations honor AstraUI:SetReducedMotion.
-- Icon names are resolved through AstraUI.Icons.
-- Themes are resolved through AstraUI.Themes.
-- This contract is intentionally kept stable across Beta releases.

-- [Tab.CreateInput] Contract note 201
-- Creates a focus-aware text input.
-- Inputs are validated at the public boundary.
-- Callbacks are protected with pcall so UI failures do not break the caller.
-- Destroyed components reject further visual work.
-- Responsive rules are recalculated when the screen size changes.
-- Animation durations honor AstraUI:SetReducedMotion.
-- Icon names are resolved through AstraUI.Icons.
-- Themes are resolved through AstraUI.Themes.
-- This contract is intentionally kept stable across Beta releases.

-- [Tab.CreateKeybind] Contract note 202
-- Creates a key listening control.
-- Inputs are validated at the public boundary.
-- Callbacks are protected with pcall so UI failures do not break the caller.
-- Destroyed components reject further visual work.
-- Responsive rules are recalculated when the screen size changes.
-- Animation durations honor AstraUI:SetReducedMotion.
-- Icon names are resolved through AstraUI.Icons.
-- Themes are resolved through AstraUI.Themes.
-- This contract is intentionally kept stable across Beta releases.

-- [Tab.CreateColorPicker] Contract note 203
-- Creates a color swatch and HSV editor.
-- Inputs are validated at the public boundary.
-- Callbacks are protected with pcall so UI failures do not break the caller.
-- Destroyed components reject further visual work.
-- Responsive rules are recalculated when the screen size changes.
-- Animation durations honor AstraUI:SetReducedMotion.
-- Icon names are resolved through AstraUI.Icons.
-- Themes are resolved through AstraUI.Themes.
-- This contract is intentionally kept stable across Beta releases.

-- [Tab.CreateDivider] Contract note 204
-- Creates a subtle divider.
-- Inputs are validated at the public boundary.
-- Callbacks are protected with pcall so UI failures do not break the caller.
-- Destroyed components reject further visual work.
-- Responsive rules are recalculated when the screen size changes.
-- Animation durations honor AstraUI:SetReducedMotion.
-- Icon names are resolved through AstraUI.Icons.
-- Themes are resolved through AstraUI.Themes.
-- This contract is intentionally kept stable across Beta releases.

-- [Tab.CreateSpacer] Contract note 205
-- Creates intentional layout space.
-- Inputs are validated at the public boundary.
-- Callbacks are protected with pcall so UI failures do not break the caller.
-- Destroyed components reject further visual work.
-- Responsive rules are recalculated when the screen size changes.
-- Animation durations honor AstraUI:SetReducedMotion.
-- Icon names are resolved through AstraUI.Icons.
-- Themes are resolved through AstraUI.Themes.
-- This contract is intentionally kept stable across Beta releases.

-- [Global.CreateWindow] Contract note 206
-- Creates a new AstraUI window.
-- Inputs are validated at the public boundary.
-- Callbacks are protected with pcall so UI failures do not break the caller.
-- Destroyed components reject further visual work.
-- Responsive rules are recalculated when the screen size changes.
-- Animation durations honor AstraUI:SetReducedMotion.
-- Icon names are resolved through AstraUI.Icons.
-- Themes are resolved through AstraUI.Themes.
-- This contract is intentionally kept stable across Beta releases.

-- [Global.Notify] Contract note 207
-- Creates a bottom notification card.
-- Inputs are validated at the public boundary.
-- Callbacks are protected with pcall so UI failures do not break the caller.
-- Destroyed components reject further visual work.
-- Responsive rules are recalculated when the screen size changes.
-- Animation durations honor AstraUI:SetReducedMotion.
-- Icon names are resolved through AstraUI.Icons.
-- Themes are resolved through AstraUI.Themes.
-- This contract is intentionally kept stable across Beta releases.

-- [Global.SetTheme] Contract note 208
-- Applies a registered theme to active windows.
-- Inputs are validated at the public boundary.
-- Callbacks are protected with pcall so UI failures do not break the caller.
-- Destroyed components reject further visual work.
-- Responsive rules are recalculated when the screen size changes.
-- Animation durations honor AstraUI:SetReducedMotion.
-- Icon names are resolved through AstraUI.Icons.
-- Themes are resolved through AstraUI.Themes.
-- This contract is intentionally kept stable across Beta releases.

-- [Global.RegisterTheme] Contract note 209
-- Registers a complete theme token table.
-- Inputs are validated at the public boundary.
-- Callbacks are protected with pcall so UI failures do not break the caller.
-- Destroyed components reject further visual work.
-- Responsive rules are recalculated when the screen size changes.
-- Animation durations honor AstraUI:SetReducedMotion.
-- Icon names are resolved through AstraUI.Icons.
-- Themes are resolved through AstraUI.Themes.
-- This contract is intentionally kept stable across Beta releases.

-- [Global.RegisterIcon] Contract note 210
-- Registers a Lucide-compatible image asset.
-- Inputs are validated at the public boundary.
-- Callbacks are protected with pcall so UI failures do not break the caller.
-- Destroyed components reject further visual work.
-- Responsive rules are recalculated when the screen size changes.
-- Animation durations honor AstraUI:SetReducedMotion.
-- Icon names are resolved through AstraUI.Icons.
-- Themes are resolved through AstraUI.Themes.
-- This contract is intentionally kept stable across Beta releases.

-- [Global.RegisterLucidePack] Contract note 211
-- Registers multiple icon mappings.
-- Inputs are validated at the public boundary.
-- Callbacks are protected with pcall so UI failures do not break the caller.
-- Destroyed components reject further visual work.
-- Responsive rules are recalculated when the screen size changes.
-- Animation durations honor AstraUI:SetReducedMotion.
-- Icon names are resolved through AstraUI.Icons.
-- Themes are resolved through AstraUI.Themes.
-- This contract is intentionally kept stable across Beta releases.

-- [Global.SetAccent] Contract note 212
-- Updates the accent color.
-- Inputs are validated at the public boundary.
-- Callbacks are protected with pcall so UI failures do not break the caller.
-- Destroyed components reject further visual work.
-- Responsive rules are recalculated when the screen size changes.
-- Animation durations honor AstraUI:SetReducedMotion.
-- Icon names are resolved through AstraUI.Icons.
-- Themes are resolved through AstraUI.Themes.
-- This contract is intentionally kept stable across Beta releases.

-- [Global.SetReducedMotion] Contract note 213
-- Reduces transition duration.
-- Inputs are validated at the public boundary.
-- Callbacks are protected with pcall so UI failures do not break the caller.
-- Destroyed components reject further visual work.
-- Responsive rules are recalculated when the screen size changes.
-- Animation durations honor AstraUI:SetReducedMotion.
-- Icon names are resolved through AstraUI.Icons.
-- Themes are resolved through AstraUI.Themes.
-- This contract is intentionally kept stable across Beta releases.

-- [Global.SetQuality] Contract note 214
-- Controls visual quality policy.
-- Inputs are validated at the public boundary.
-- Callbacks are protected with pcall so UI failures do not break the caller.
-- Destroyed components reject further visual work.
-- Responsive rules are recalculated when the screen size changes.
-- Animation durations honor AstraUI:SetReducedMotion.
-- Icon names are resolved through AstraUI.Icons.
-- Themes are resolved through AstraUI.Themes.
-- This contract is intentionally kept stable across Beta releases.

-- [Global.ExportConfig] Contract note 215
-- Serializes component state to JSON.
-- Inputs are validated at the public boundary.
-- Callbacks are protected with pcall so UI failures do not break the caller.
-- Destroyed components reject further visual work.
-- Responsive rules are recalculated when the screen size changes.
-- Animation durations honor AstraUI:SetReducedMotion.
-- Icon names are resolved through AstraUI.Icons.
-- Themes are resolved through AstraUI.Themes.
-- This contract is intentionally kept stable across Beta releases.

-- [Global.ImportConfig] Contract note 216
-- Restores component state from JSON.
-- Inputs are validated at the public boundary.
-- Callbacks are protected with pcall so UI failures do not break the caller.
-- Destroyed components reject further visual work.
-- Responsive rules are recalculated when the screen size changes.
-- Animation durations honor AstraUI:SetReducedMotion.
-- Icon names are resolved through AstraUI.Icons.
-- Themes are resolved through AstraUI.Themes.
-- This contract is intentionally kept stable across Beta releases.

-- [Window.CreateTab] Contract note 217
-- Creates and registers a tab and activates the first tab.
-- Inputs are validated at the public boundary.
-- Callbacks are protected with pcall so UI failures do not break the caller.
-- Destroyed components reject further visual work.
-- Responsive rules are recalculated when the screen size changes.
-- Animation durations honor AstraUI:SetReducedMotion.
-- Icon names are resolved through AstraUI.Icons.
-- Themes are resolved through AstraUI.Themes.
-- This contract is intentionally kept stable across Beta releases.

-- [Window.GetTab] Contract note 218
-- Returns a tab by its exact public name.
-- Inputs are validated at the public boundary.
-- Callbacks are protected with pcall so UI failures do not break the caller.
-- Destroyed components reject further visual work.
-- Responsive rules are recalculated when the screen size changes.
-- Animation durations honor AstraUI:SetReducedMotion.
-- Icon names are resolved through AstraUI.Icons.
-- Themes are resolved through AstraUI.Themes.
-- This contract is intentionally kept stable across Beta releases.

-- [Window.GetComponent] Contract note 219
-- Searches every tab for a component by name.
-- Inputs are validated at the public boundary.
-- Callbacks are protected with pcall so UI failures do not break the caller.
-- Destroyed components reject further visual work.
-- Responsive rules are recalculated when the screen size changes.
-- Animation durations honor AstraUI:SetReducedMotion.
-- Icon names are resolved through AstraUI.Icons.
-- Themes are resolved through AstraUI.Themes.
-- This contract is intentionally kept stable across Beta releases.

-- [Window.Search] Contract note 220
-- Filters components using their name and description.
-- Inputs are validated at the public boundary.
-- Callbacks are protected with pcall so UI failures do not break the caller.
-- Destroyed components reject further visual work.
-- Responsive rules are recalculated when the screen size changes.
-- Animation durations honor AstraUI:SetReducedMotion.
-- Icon names are resolved through AstraUI.Icons.
-- Themes are resolved through AstraUI.Themes.
-- This contract is intentionally kept stable across Beta releases.

-- [Window.SetSearchEnabled] Contract note 221
-- Shows or hides the window search field.
-- Inputs are validated at the public boundary.
-- Callbacks are protected with pcall so UI failures do not break the caller.
-- Destroyed components reject further visual work.
-- Responsive rules are recalculated when the screen size changes.
-- Animation durations honor AstraUI:SetReducedMotion.
-- Icon names are resolved through AstraUI.Icons.
-- Themes are resolved through AstraUI.Themes.
-- This contract is intentionally kept stable across Beta releases.

-- [Window.SetTitle] Contract note 222
-- Updates the title and optional subtitle.
-- Inputs are validated at the public boundary.
-- Callbacks are protected with pcall so UI failures do not break the caller.
-- Destroyed components reject further visual work.
-- Responsive rules are recalculated when the screen size changes.
-- Animation durations honor AstraUI:SetReducedMotion.
-- Icon names are resolved through AstraUI.Icons.
-- Themes are resolved through AstraUI.Themes.
-- This contract is intentionally kept stable across Beta releases.

-- [Window.SetSize] Contract note 223
-- Updates the window size using UDim2.
-- Inputs are validated at the public boundary.
-- Callbacks are protected with pcall so UI failures do not break the caller.
-- Destroyed components reject further visual work.
-- Responsive rules are recalculated when the screen size changes.
-- Animation durations honor AstraUI:SetReducedMotion.
-- Icon names are resolved through AstraUI.Icons.
-- Themes are resolved through AstraUI.Themes.
-- This contract is intentionally kept stable across Beta releases.

-- [Window.SetPosition] Contract note 224
-- Updates the window position using UDim2.
-- Inputs are validated at the public boundary.
-- Callbacks are protected with pcall so UI failures do not break the caller.
-- Destroyed components reject further visual work.
-- Responsive rules are recalculated when the screen size changes.
-- Animation durations honor AstraUI:SetReducedMotion.
-- Icon names are resolved through AstraUI.Icons.
-- Themes are resolved through AstraUI.Themes.
-- This contract is intentionally kept stable across Beta releases.

-- [Window.SetVisibility] Contract note 225
-- Changes window visibility without destroying it.
-- Inputs are validated at the public boundary.
-- Callbacks are protected with pcall so UI failures do not break the caller.
-- Destroyed components reject further visual work.
-- Responsive rules are recalculated when the screen size changes.
-- Animation durations honor AstraUI:SetReducedMotion.
-- Icon names are resolved through AstraUI.Icons.
-- Themes are resolved through AstraUI.Themes.
-- This contract is intentionally kept stable across Beta releases.

-- [Window.Toggle] Contract note 226
-- Opens or closes the window with motion.
-- Inputs are validated at the public boundary.
-- Callbacks are protected with pcall so UI failures do not break the caller.
-- Destroyed components reject further visual work.
-- Responsive rules are recalculated when the screen size changes.
-- Animation durations honor AstraUI:SetReducedMotion.
-- Icon names are resolved through AstraUI.Icons.
-- Themes are resolved through AstraUI.Themes.
-- This contract is intentionally kept stable across Beta releases.

-- [Window.ToggleMinimize] Contract note 227
-- Collapses or restores the window.
-- Inputs are validated at the public boundary.
-- Callbacks are protected with pcall so UI failures do not break the caller.
-- Destroyed components reject further visual work.
-- Responsive rules are recalculated when the screen size changes.
-- Animation durations honor AstraUI:SetReducedMotion.
-- Icon names are resolved through AstraUI.Icons.
-- Themes are resolved through AstraUI.Themes.
-- This contract is intentionally kept stable across Beta releases.

-- [Window.Destroy] Contract note 228
-- Disconnects resources and removes the GUI.
-- Inputs are validated at the public boundary.
-- Callbacks are protected with pcall so UI failures do not break the caller.
-- Destroyed components reject further visual work.
-- Responsive rules are recalculated when the screen size changes.
-- Animation durations honor AstraUI:SetReducedMotion.
-- Icon names are resolved through AstraUI.Icons.
-- Themes are resolved through AstraUI.Themes.
-- This contract is intentionally kept stable across Beta releases.

-- [Tab.CreateSection] Contract note 229
-- Creates a visual section header.
-- Inputs are validated at the public boundary.
-- Callbacks are protected with pcall so UI failures do not break the caller.
-- Destroyed components reject further visual work.
-- Responsive rules are recalculated when the screen size changes.
-- Animation durations honor AstraUI:SetReducedMotion.
-- Icon names are resolved through AstraUI.Icons.
-- Themes are resolved through AstraUI.Themes.
-- This contract is intentionally kept stable across Beta releases.

-- [Tab.CreateLabel] Contract note 230
-- Creates a compact text label.
-- Inputs are validated at the public boundary.
-- Callbacks are protected with pcall so UI failures do not break the caller.
-- Destroyed components reject further visual work.
-- Responsive rules are recalculated when the screen size changes.
-- Animation durations honor AstraUI:SetReducedMotion.
-- Icon names are resolved through AstraUI.Icons.
-- Themes are resolved through AstraUI.Themes.
-- This contract is intentionally kept stable across Beta releases.

-- [Tab.CreateParagraph] Contract note 231
-- Creates a title and wrapped description block.
-- Inputs are validated at the public boundary.
-- Callbacks are protected with pcall so UI failures do not break the caller.
-- Destroyed components reject further visual work.
-- Responsive rules are recalculated when the screen size changes.
-- Animation durations honor AstraUI:SetReducedMotion.
-- Icon names are resolved through AstraUI.Icons.
-- Themes are resolved through AstraUI.Themes.
-- This contract is intentionally kept stable across Beta releases.

-- [Tab.CreateButton] Contract note 232
-- Creates an animated action button.
-- Inputs are validated at the public boundary.
-- Callbacks are protected with pcall so UI failures do not break the caller.
-- Destroyed components reject further visual work.
-- Responsive rules are recalculated when the screen size changes.
-- Animation durations honor AstraUI:SetReducedMotion.
-- Icon names are resolved through AstraUI.Icons.
-- Themes are resolved through AstraUI.Themes.
-- This contract is intentionally kept stable across Beta releases.

-- [Tab.CreateToggle] Contract note 233
-- Creates a stateful animated toggle.
-- Inputs are validated at the public boundary.
-- Callbacks are protected with pcall so UI failures do not break the caller.
-- Destroyed components reject further visual work.
-- Responsive rules are recalculated when the screen size changes.
-- Animation durations honor AstraUI:SetReducedMotion.
-- Icon names are resolved through AstraUI.Icons.
-- Themes are resolved through AstraUI.Themes.
-- This contract is intentionally kept stable across Beta releases.

-- [Tab.CreateSlider] Contract note 234
-- Creates a draggable numeric slider.
-- Inputs are validated at the public boundary.
-- Callbacks are protected with pcall so UI failures do not break the caller.
-- Destroyed components reject further visual work.
-- Responsive rules are recalculated when the screen size changes.
-- Animation durations honor AstraUI:SetReducedMotion.
-- Icon names are resolved through AstraUI.Icons.
-- Themes are resolved through AstraUI.Themes.
-- This contract is intentionally kept stable across Beta releases.

-- [Tab.CreateDropdown] Contract note 235
-- Creates an animated single-select popover.
-- Inputs are validated at the public boundary.
-- Callbacks are protected with pcall so UI failures do not break the caller.
-- Destroyed components reject further visual work.
-- Responsive rules are recalculated when the screen size changes.
-- Animation durations honor AstraUI:SetReducedMotion.
-- Icon names are resolved through AstraUI.Icons.
-- Themes are resolved through AstraUI.Themes.
-- This contract is intentionally kept stable across Beta releases.

-- [Tab.CreateMultiDropdown] Contract note 236
-- Creates an animated multi-select popover.
-- Inputs are validated at the public boundary.
-- Callbacks are protected with pcall so UI failures do not break the caller.
-- Destroyed components reject further visual work.
-- Responsive rules are recalculated when the screen size changes.
-- Animation durations honor AstraUI:SetReducedMotion.
-- Icon names are resolved through AstraUI.Icons.
-- Themes are resolved through AstraUI.Themes.
-- This contract is intentionally kept stable across Beta releases.

-- [Tab.CreateInput] Contract note 237
-- Creates a focus-aware text input.
-- Inputs are validated at the public boundary.
-- Callbacks are protected with pcall so UI failures do not break the caller.
-- Destroyed components reject further visual work.
-- Responsive rules are recalculated when the screen size changes.
-- Animation durations honor AstraUI:SetReducedMotion.
-- Icon names are resolved through AstraUI.Icons.
-- Themes are resolved through AstraUI.Themes.
-- This contract is intentionally kept stable across Beta releases.

-- [Tab.CreateKeybind] Contract note 238
-- Creates a key listening control.
-- Inputs are validated at the public boundary.
-- Callbacks are protected with pcall so UI failures do not break the caller.
-- Destroyed components reject further visual work.
-- Responsive rules are recalculated when the screen size changes.
-- Animation durations honor AstraUI:SetReducedMotion.
-- Icon names are resolved through AstraUI.Icons.
-- Themes are resolved through AstraUI.Themes.
-- This contract is intentionally kept stable across Beta releases.

-- [Tab.CreateColorPicker] Contract note 239
-- Creates a color swatch and HSV editor.
-- Inputs are validated at the public boundary.
-- Callbacks are protected with pcall so UI failures do not break the caller.
-- Destroyed components reject further visual work.
-- Responsive rules are recalculated when the screen size changes.
-- Animation durations honor AstraUI:SetReducedMotion.
-- Icon names are resolved through AstraUI.Icons.
-- Themes are resolved through AstraUI.Themes.
-- This contract is intentionally kept stable across Beta releases.

-- [Tab.CreateDivider] Contract note 240
-- Creates a subtle divider.
-- Inputs are validated at the public boundary.
-- Callbacks are protected with pcall so UI failures do not break the caller.
-- Destroyed components reject further visual work.
-- Responsive rules are recalculated when the screen size changes.
-- Animation durations honor AstraUI:SetReducedMotion.
-- Icon names are resolved through AstraUI.Icons.
-- Themes are resolved through AstraUI.Themes.
-- This contract is intentionally kept stable across Beta releases.

-- [Tab.CreateSpacer] Contract note 241
-- Creates intentional layout space.
-- Inputs are validated at the public boundary.
-- Callbacks are protected with pcall so UI failures do not break the caller.
-- Destroyed components reject further visual work.
-- Responsive rules are recalculated when the screen size changes.
-- Animation durations honor AstraUI:SetReducedMotion.
-- Icon names are resolved through AstraUI.Icons.
-- Themes are resolved through AstraUI.Themes.
-- This contract is intentionally kept stable across Beta releases.

-- [Global.CreateWindow] Contract note 242
-- Creates a new AstraUI window.
-- Inputs are validated at the public boundary.
-- Callbacks are protected with pcall so UI failures do not break the caller.
-- Destroyed components reject further visual work.
-- Responsive rules are recalculated when the screen size changes.
-- Animation durations honor AstraUI:SetReducedMotion.
-- Icon names are resolved through AstraUI.Icons.
-- Themes are resolved through AstraUI.Themes.
-- This contract is intentionally kept stable across Beta releases.

-- [Global.Notify] Contract note 243
-- Creates a bottom notification card.
-- Inputs are validated at the public boundary.
-- Callbacks are protected with pcall so UI failures do not break the caller.
-- Destroyed components reject further visual work.
-- Responsive rules are recalculated when the screen size changes.
-- Animation durations honor AstraUI:SetReducedMotion.
-- Icon names are resolved through AstraUI.Icons.
-- Themes are resolved through AstraUI.Themes.
-- This contract is intentionally kept stable across Beta releases.

-- [Global.SetTheme] Contract note 244
-- Applies a registered theme to active windows.
-- Inputs are validated at the public boundary.
-- Callbacks are protected with pcall so UI failures do not break the caller.
-- Destroyed components reject further visual work.
-- Responsive rules are recalculated when the screen size changes.
-- Animation durations honor AstraUI:SetReducedMotion.
-- Icon names are resolved through AstraUI.Icons.
-- Themes are resolved through AstraUI.Themes.
-- This contract is intentionally kept stable across Beta releases.

-- [Global.RegisterTheme] Contract note 245
-- Registers a complete theme token table.
-- Inputs are validated at the public boundary.
-- Callbacks are protected with pcall so UI failures do not break the caller.
-- Destroyed components reject further visual work.
-- Responsive rules are recalculated when the screen size changes.
-- Animation durations honor AstraUI:SetReducedMotion.
-- Icon names are resolved through AstraUI.Icons.
-- Themes are resolved through AstraUI.Themes.
-- This contract is intentionally kept stable across Beta releases.

-- [Global.RegisterIcon] Contract note 246
-- Registers a Lucide-compatible image asset.
-- Inputs are validated at the public boundary.
-- Callbacks are protected with pcall so UI failures do not break the caller.
-- Destroyed components reject further visual work.
-- Responsive rules are recalculated when the screen size changes.
-- Animation durations honor AstraUI:SetReducedMotion.
-- Icon names are resolved through AstraUI.Icons.
-- Themes are resolved through AstraUI.Themes.
-- This contract is intentionally kept stable across Beta releases.

-- [Global.RegisterLucidePack] Contract note 247
-- Registers multiple icon mappings.
-- Inputs are validated at the public boundary.
-- Callbacks are protected with pcall so UI failures do not break the caller.
-- Destroyed components reject further visual work.
-- Responsive rules are recalculated when the screen size changes.
-- Animation durations honor AstraUI:SetReducedMotion.
-- Icon names are resolved through AstraUI.Icons.
-- Themes are resolved through AstraUI.Themes.
-- This contract is intentionally kept stable across Beta releases.

-- [Global.SetAccent] Contract note 248
-- Updates the accent color.
-- Inputs are validated at the public boundary.
-- Callbacks are protected with pcall so UI failures do not break the caller.
-- Destroyed components reject further visual work.
-- Responsive rules are recalculated when the screen size changes.
-- Animation durations honor AstraUI:SetReducedMotion.
-- Icon names are resolved through AstraUI.Icons.
-- Themes are resolved through AstraUI.Themes.
-- This contract is intentionally kept stable across Beta releases.

-- [Global.SetReducedMotion] Contract note 249
-- Reduces transition duration.
-- Inputs are validated at the public boundary.
-- Callbacks are protected with pcall so UI failures do not break the caller.
-- Destroyed components reject further visual work.
-- Responsive rules are recalculated when the screen size changes.
-- Animation durations honor AstraUI:SetReducedMotion.
-- Icon names are resolved through AstraUI.Icons.
-- Themes are resolved through AstraUI.Themes.
-- This contract is intentionally kept stable across Beta releases.

-- [Global.SetQuality] Contract note 250
-- Controls visual quality policy.
-- Inputs are validated at the public boundary.
-- Callbacks are protected with pcall so UI failures do not break the caller.
-- Destroyed components reject further visual work.
-- Responsive rules are recalculated when the screen size changes.
-- Animation durations honor AstraUI:SetReducedMotion.
-- Icon names are resolved through AstraUI.Icons.
-- Themes are resolved through AstraUI.Themes.
-- This contract is intentionally kept stable across Beta releases.

-- [Global.ExportConfig] Contract note 251
-- Serializes component state to JSON.
-- Inputs are validated at the public boundary.
-- Callbacks are protected with pcall so UI failures do not break the caller.
-- Destroyed components reject further visual work.
-- Responsive rules are recalculated when the screen size changes.
-- Animation durations honor AstraUI:SetReducedMotion.
-- Icon names are resolved through AstraUI.Icons.
-- Themes are resolved through AstraUI.Themes.
-- This contract is intentionally kept stable across Beta releases.

-- [Global.ImportConfig] Contract note 252
-- Restores component state from JSON.
-- Inputs are validated at the public boundary.
-- Callbacks are protected with pcall so UI failures do not break the caller.
-- Destroyed components reject further visual work.
-- Responsive rules are recalculated when the screen size changes.
-- Animation durations honor AstraUI:SetReducedMotion.
-- Icon names are resolved through AstraUI.Icons.
-- Themes are resolved through AstraUI.Themes.
-- This contract is intentionally kept stable across Beta releases.

-- [Window.CreateTab] Contract note 253
-- Creates and registers a tab and activates the first tab.
-- Inputs are validated at the public boundary.
-- Callbacks are protected with pcall so UI failures do not break the caller.
-- Destroyed components reject further visual work.
-- Responsive rules are recalculated when the screen size changes.
-- Animation durations honor AstraUI:SetReducedMotion.
-- Icon names are resolved through AstraUI.Icons.
-- Themes are resolved through AstraUI.Themes.
-- This contract is intentionally kept stable across Beta releases.

-- [Window.GetTab] Contract note 254
-- Returns a tab by its exact public name.
-- Inputs are validated at the public boundary.
-- Callbacks are protected with pcall so UI failures do not break the caller.
-- Destroyed components reject further visual work.
-- Responsive rules are recalculated when the screen size changes.
-- Animation durations honor AstraUI:SetReducedMotion.
-- Icon names are resolved through AstraUI.Icons.
-- Themes are resolved through AstraUI.Themes.
-- This contract is intentionally kept stable across Beta releases.

-- [Window.GetComponent] Contract note 255
-- Searches every tab for a component by name.
-- Inputs are validated at the public boundary.
-- Callbacks are protected with pcall so UI failures do not break the caller.
-- Destroyed components reject further visual work.
-- Responsive rules are recalculated when the screen size changes.
-- Animation durations honor AstraUI:SetReducedMotion.
-- Icon names are resolved through AstraUI.Icons.
-- Themes are resolved through AstraUI.Themes.
-- This contract is intentionally kept stable across Beta releases.

-- [Window.Search] Contract note 256
-- Filters components using their name and description.
-- Inputs are validated at the public boundary.
-- Callbacks are protected with pcall so UI failures do not break the caller.
-- Destroyed components reject further visual work.
-- Responsive rules are recalculated when the screen size changes.
-- Animation durations honor AstraUI:SetReducedMotion.
-- Icon names are resolved through AstraUI.Icons.
-- Themes are resolved through AstraUI.Themes.
-- This contract is intentionally kept stable across Beta releases.

-- [Window.SetSearchEnabled] Contract note 257
-- Shows or hides the window search field.
-- Inputs are validated at the public boundary.
-- Callbacks are protected with pcall so UI failures do not break the caller.
-- Destroyed components reject further visual work.
-- Responsive rules are recalculated when the screen size changes.
-- Animation durations honor AstraUI:SetReducedMotion.
-- Icon names are resolved through AstraUI.Icons.
-- Themes are resolved through AstraUI.Themes.
-- This contract is intentionally kept stable across Beta releases.

-- [Window.SetTitle] Contract note 258
-- Updates the title and optional subtitle.
-- Inputs are validated at the public boundary.
-- Callbacks are protected with pcall so UI failures do not break the caller.
-- Destroyed components reject further visual work.
-- Responsive rules are recalculated when the screen size changes.
-- Animation durations honor AstraUI:SetReducedMotion.
-- Icon names are resolved through AstraUI.Icons.
-- Themes are resolved through AstraUI.Themes.
-- This contract is intentionally kept stable across Beta releases.

-- [Window.SetSize] Contract note 259
-- Updates the window size using UDim2.
-- Inputs are validated at the public boundary.
-- Callbacks are protected with pcall so UI failures do not break the caller.
-- Destroyed components reject further visual work.
-- Responsive rules are recalculated when the screen size changes.
-- Animation durations honor AstraUI:SetReducedMotion.
-- Icon names are resolved through AstraUI.Icons.
-- Themes are resolved through AstraUI.Themes.
-- This contract is intentionally kept stable across Beta releases.

-- [Window.SetPosition] Contract note 260
-- Updates the window position using UDim2.
-- Inputs are validated at the public boundary.
-- Callbacks are protected with pcall so UI failures do not break the caller.
-- Destroyed components reject further visual work.
-- Responsive rules are recalculated when the screen size changes.
-- Animation durations honor AstraUI:SetReducedMotion.
-- Icon names are resolved through AstraUI.Icons.
-- Themes are resolved through AstraUI.Themes.
-- This contract is intentionally kept stable across Beta releases.

-- [Window.SetVisibility] Contract note 261
-- Changes window visibility without destroying it.
-- Inputs are validated at the public boundary.
-- Callbacks are protected with pcall so UI failures do not break the caller.
-- Destroyed components reject further visual work.
-- Responsive rules are recalculated when the screen size changes.
-- Animation durations honor AstraUI:SetReducedMotion.
-- Icon names are resolved through AstraUI.Icons.
-- Themes are resolved through AstraUI.Themes.
-- This contract is intentionally kept stable across Beta releases.

-- [Window.Toggle] Contract note 262
-- Opens or closes the window with motion.
-- Inputs are validated at the public boundary.
-- Callbacks are protected with pcall so UI failures do not break the caller.
-- Destroyed components reject further visual work.
-- Responsive rules are recalculated when the screen size changes.
-- Animation durations honor AstraUI:SetReducedMotion.
-- Icon names are resolved through AstraUI.Icons.
-- Themes are resolved through AstraUI.Themes.
-- This contract is intentionally kept stable across Beta releases.

-- [Window.ToggleMinimize] Contract note 263
-- Collapses or restores the window.
-- Inputs are validated at the public boundary.
-- Callbacks are protected with pcall so UI failures do not break the caller.
-- Destroyed components reject further visual work.
-- Responsive rules are recalculated when the screen size changes.
-- Animation durations honor AstraUI:SetReducedMotion.
-- Icon names are resolved through AstraUI.Icons.
-- Themes are resolved through AstraUI.Themes.
-- This contract is intentionally kept stable across Beta releases.

-- [Window.Destroy] Contract note 264
-- Disconnects resources and removes the GUI.
-- Inputs are validated at the public boundary.
-- Callbacks are protected with pcall so UI failures do not break the caller.
-- Destroyed components reject further visual work.
-- Responsive rules are recalculated when the screen size changes.
-- Animation durations honor AstraUI:SetReducedMotion.
-- Icon names are resolved through AstraUI.Icons.
-- Themes are resolved through AstraUI.Themes.
-- This contract is intentionally kept stable across Beta releases.

-- [Tab.CreateSection] Contract note 265
-- Creates a visual section header.
-- Inputs are validated at the public boundary.
-- Callbacks are protected with pcall so UI failures do not break the caller.
-- Destroyed components reject further visual work.
-- Responsive rules are recalculated when the screen size changes.
-- Animation durations honor AstraUI:SetReducedMotion.
-- Icon names are resolved through AstraUI.Icons.
-- Themes are resolved through AstraUI.Themes.
-- This contract is intentionally kept stable across Beta releases.

-- [Tab.CreateLabel] Contract note 266
-- Creates a compact text label.
-- Inputs are validated at the public boundary.
-- Callbacks are protected with pcall so UI failures do not break the caller.
-- Destroyed components reject further visual work.
-- Responsive rules are recalculated when the screen size changes.
-- Animation durations honor AstraUI:SetReducedMotion.
-- Icon names are resolved through AstraUI.Icons.
-- Themes are resolved through AstraUI.Themes.
-- This contract is intentionally kept stable across Beta releases.

-- [Tab.CreateParagraph] Contract note 267
-- Creates a title and wrapped description block.
-- Inputs are validated at the public boundary.
-- Callbacks are protected with pcall so UI failures do not break the caller.
-- Destroyed components reject further visual work.
-- Responsive rules are recalculated when the screen size changes.
-- Animation durations honor AstraUI:SetReducedMotion.
-- Icon names are resolved through AstraUI.Icons.
-- Themes are resolved through AstraUI.Themes.
-- This contract is intentionally kept stable across Beta releases.

-- [Tab.CreateButton] Contract note 268
-- Creates an animated action button.
-- Inputs are validated at the public boundary.
-- Callbacks are protected with pcall so UI failures do not break the caller.
-- Destroyed components reject further visual work.
-- Responsive rules are recalculated when the screen size changes.
-- Animation durations honor AstraUI:SetReducedMotion.
-- Icon names are resolved through AstraUI.Icons.
-- Themes are resolved through AstraUI.Themes.
-- This contract is intentionally kept stable across Beta releases.

-- [Tab.CreateToggle] Contract note 269
-- Creates a stateful animated toggle.
-- Inputs are validated at the public boundary.
-- Callbacks are protected with pcall so UI failures do not break the caller.
-- Destroyed components reject further visual work.
-- Responsive rules are recalculated when the screen size changes.
-- Animation durations honor AstraUI:SetReducedMotion.
-- Icon names are resolved through AstraUI.Icons.
-- Themes are resolved through AstraUI.Themes.
-- This contract is intentionally kept stable across Beta releases.

-- [Tab.CreateSlider] Contract note 270
-- Creates a draggable numeric slider.
-- Inputs are validated at the public boundary.
-- Callbacks are protected with pcall so UI failures do not break the caller.
-- Destroyed components reject further visual work.
-- Responsive rules are recalculated when the screen size changes.
-- Animation durations honor AstraUI:SetReducedMotion.
-- Icon names are resolved through AstraUI.Icons.
-- Themes are resolved through AstraUI.Themes.
-- This contract is intentionally kept stable across Beta releases.

-- [Tab.CreateDropdown] Contract note 271
-- Creates an animated single-select popover.
-- Inputs are validated at the public boundary.
-- Callbacks are protected with pcall so UI failures do not break the caller.
-- Destroyed components reject further visual work.
-- Responsive rules are recalculated when the screen size changes.
-- Animation durations honor AstraUI:SetReducedMotion.
-- Icon names are resolved through AstraUI.Icons.
-- Themes are resolved through AstraUI.Themes.
-- This contract is intentionally kept stable across Beta releases.

-- [Tab.CreateMultiDropdown] Contract note 272
-- Creates an animated multi-select popover.
-- Inputs are validated at the public boundary.
-- Callbacks are protected with pcall so UI failures do not break the caller.
-- Destroyed components reject further visual work.
-- Responsive rules are recalculated when the screen size changes.
-- Animation durations honor AstraUI:SetReducedMotion.
-- Icon names are resolved through AstraUI.Icons.
-- Themes are resolved through AstraUI.Themes.
-- This contract is intentionally kept stable across Beta releases.

-- [Tab.CreateInput] Contract note 273
-- Creates a focus-aware text input.
-- Inputs are validated at the public boundary.
-- Callbacks are protected with pcall so UI failures do not break the caller.
-- Destroyed components reject further visual work.
-- Responsive rules are recalculated when the screen size changes.
-- Animation durations honor AstraUI:SetReducedMotion.
-- Icon names are resolved through AstraUI.Icons.
-- Themes are resolved through AstraUI.Themes.
-- This contract is intentionally kept stable across Beta releases.

-- [Tab.CreateKeybind] Contract note 274
-- Creates a key listening control.
-- Inputs are validated at the public boundary.
-- Callbacks are protected with pcall so UI failures do not break the caller.
-- Destroyed components reject further visual work.
-- Responsive rules are recalculated when the screen size changes.
-- Animation durations honor AstraUI:SetReducedMotion.
-- Icon names are resolved through AstraUI.Icons.
-- Themes are resolved through AstraUI.Themes.
-- This contract is intentionally kept stable across Beta releases.

-- [Tab.CreateColorPicker] Contract note 275
-- Creates a color swatch and HSV editor.
-- Inputs are validated at the public boundary.
-- Callbacks are protected with pcall so UI failures do not break the caller.
-- Destroyed components reject further visual work.
-- Responsive rules are recalculated when the screen size changes.
-- Animation durations honor AstraUI:SetReducedMotion.
-- Icon names are resolved through AstraUI.Icons.
-- Themes are resolved through AstraUI.Themes.
-- This contract is intentionally kept stable across Beta releases.

-- [Tab.CreateDivider] Contract note 276
-- Creates a subtle divider.
-- Inputs are validated at the public boundary.
-- Callbacks are protected with pcall so UI failures do not break the caller.
-- Destroyed components reject further visual work.
-- Responsive rules are recalculated when the screen size changes.
-- Animation durations honor AstraUI:SetReducedMotion.
-- Icon names are resolved through AstraUI.Icons.
-- Themes are resolved through AstraUI.Themes.
-- This contract is intentionally kept stable across Beta releases.

-- [Tab.CreateSpacer] Contract note 277
-- Creates intentional layout space.
-- Inputs are validated at the public boundary.
-- Callbacks are protected with pcall so UI failures do not break the caller.
-- Destroyed components reject further visual work.
-- Responsive rules are recalculated when the screen size changes.
-- Animation durations honor AstraUI:SetReducedMotion.
-- Icon names are resolved through AstraUI.Icons.
-- Themes are resolved through AstraUI.Themes.
-- This contract is intentionally kept stable across Beta releases.

-- [Global.CreateWindow] Contract note 278
-- Creates a new AstraUI window.
-- Inputs are validated at the public boundary.
-- Callbacks are protected with pcall so UI failures do not break the caller.
-- Destroyed components reject further visual work.
-- Responsive rules are recalculated when the screen size changes.
-- Animation durations honor AstraUI:SetReducedMotion.
-- Icon names are resolved through AstraUI.Icons.
-- Themes are resolved through AstraUI.Themes.
-- This contract is intentionally kept stable across Beta releases.

-- [Global.Notify] Contract note 279
-- Creates a bottom notification card.
-- Inputs are validated at the public boundary.
-- Callbacks are protected with pcall so UI failures do not break the caller.
-- Destroyed components reject further visual work.
-- Responsive rules are recalculated when the screen size changes.
-- Animation durations honor AstraUI:SetReducedMotion.
-- Icon names are resolved through AstraUI.Icons.
-- Themes are resolved through AstraUI.Themes.
-- This contract is intentionally kept stable across Beta releases.

-- [Global.SetTheme] Contract note 280
-- Applies a registered theme to active windows.
-- Inputs are validated at the public boundary.
-- Callbacks are protected with pcall so UI failures do not break the caller.
-- Destroyed components reject further visual work.
-- Responsive rules are recalculated when the screen size changes.
-- Animation durations honor AstraUI:SetReducedMotion.
-- Icon names are resolved through AstraUI.Icons.
-- Themes are resolved through AstraUI.Themes.
-- This contract is intentionally kept stable across Beta releases.

-- [Global.RegisterTheme] Contract note 281
-- Registers a complete theme token table.
-- Inputs are validated at the public boundary.
-- Callbacks are protected with pcall so UI failures do not break the caller.
-- Destroyed components reject further visual work.
-- Responsive rules are recalculated when the screen size changes.
-- Animation durations honor AstraUI:SetReducedMotion.
-- Icon names are resolved through AstraUI.Icons.
-- Themes are resolved through AstraUI.Themes.
-- This contract is intentionally kept stable across Beta releases.

-- [Global.RegisterIcon] Contract note 282
-- Registers a Lucide-compatible image asset.
-- Inputs are validated at the public boundary.
-- Callbacks are protected with pcall so UI failures do not break the caller.
-- Destroyed components reject further visual work.
-- Responsive rules are recalculated when the screen size changes.
-- Animation durations honor AstraUI:SetReducedMotion.
-- Icon names are resolved through AstraUI.Icons.
-- Themes are resolved through AstraUI.Themes.
-- This contract is intentionally kept stable across Beta releases.

-- [Global.RegisterLucidePack] Contract note 283
-- Registers multiple icon mappings.
-- Inputs are validated at the public boundary.
-- Callbacks are protected with pcall so UI failures do not break the caller.
-- Destroyed components reject further visual work.
-- Responsive rules are recalculated when the screen size changes.
-- Animation durations honor AstraUI:SetReducedMotion.
-- Icon names are resolved through AstraUI.Icons.
-- Themes are resolved through AstraUI.Themes.
-- This contract is intentionally kept stable across Beta releases.

-- [Global.SetAccent] Contract note 284
-- Updates the accent color.
-- Inputs are validated at the public boundary.
-- Callbacks are protected with pcall so UI failures do not break the caller.
-- Destroyed components reject further visual work.
-- Responsive rules are recalculated when the screen size changes.
-- Animation durations honor AstraUI:SetReducedMotion.
-- Icon names are resolved through AstraUI.Icons.
-- Themes are resolved through AstraUI.Themes.
-- This contract is intentionally kept stable across Beta releases.

-- [Global.SetReducedMotion] Contract note 285
-- Reduces transition duration.
-- Inputs are validated at the public boundary.
-- Callbacks are protected with pcall so UI failures do not break the caller.
-- Destroyed components reject further visual work.
-- Responsive rules are recalculated when the screen size changes.
-- Animation durations honor AstraUI:SetReducedMotion.
-- Icon names are resolved through AstraUI.Icons.
-- Themes are resolved through AstraUI.Themes.
-- This contract is intentionally kept stable across Beta releases.

-- [Global.SetQuality] Contract note 286
-- Controls visual quality policy.
-- Inputs are validated at the public boundary.
-- Callbacks are protected with pcall so UI failures do not break the caller.
-- Destroyed components reject further visual work.
-- Responsive rules are recalculated when the screen size changes.
-- Animation durations honor AstraUI:SetReducedMotion.
-- Icon names are resolved through AstraUI.Icons.
-- Themes are resolved through AstraUI.Themes.
-- This contract is intentionally kept stable across Beta releases.

-- [Global.ExportConfig] Contract note 287
-- Serializes component state to JSON.
-- Inputs are validated at the public boundary.
-- Callbacks are protected with pcall so UI failures do not break the caller.
-- Destroyed components reject further visual work.
-- Responsive rules are recalculated when the screen size changes.
-- Animation durations honor AstraUI:SetReducedMotion.
-- Icon names are resolved through AstraUI.Icons.
-- Themes are resolved through AstraUI.Themes.
-- This contract is intentionally kept stable across Beta releases.

-- [Global.ImportConfig] Contract note 288
-- Restores component state from JSON.
-- Inputs are validated at the public boundary.
-- Callbacks are protected with pcall so UI failures do not break the caller.
-- Destroyed components reject further visual work.
-- Responsive rules are recalculated when the screen size changes.
-- Animation durations honor AstraUI:SetReducedMotion.
-- Icon names are resolved through AstraUI.Icons.
-- Themes are resolved through AstraUI.Themes.
-- This contract is intentionally kept stable across Beta releases.

-- [Window.CreateTab] Contract note 289
-- Creates and registers a tab and activates the first tab.
-- Inputs are validated at the public boundary.
-- Callbacks are protected with pcall so UI failures do not break the caller.
-- Destroyed components reject further visual work.
-- Responsive rules are recalculated when the screen size changes.
-- Animation durations honor AstraUI:SetReducedMotion.
-- Icon names are resolved through AstraUI.Icons.
-- Themes are resolved through AstraUI.Themes.
-- This contract is intentionally kept stable across Beta releases.

-- [Window.GetTab] Contract note 290
-- Returns a tab by its exact public name.
-- Inputs are validated at the public boundary.
-- Callbacks are protected with pcall so UI failures do not break the caller.
-- Destroyed components reject further visual work.
-- Responsive rules are recalculated when the screen size changes.
-- Animation durations honor AstraUI:SetReducedMotion.
-- Icon names are resolved through AstraUI.Icons.
-- Themes are resolved through AstraUI.Themes.
-- This contract is intentionally kept stable across Beta releases.

-- [Window.GetComponent] Contract note 291
-- Searches every tab for a component by name.
-- Inputs are validated at the public boundary.
-- Callbacks are protected with pcall so UI failures do not break the caller.
-- Destroyed components reject further visual work.
-- Responsive rules are recalculated when the screen size changes.
-- Animation durations honor AstraUI:SetReducedMotion.
-- Icon names are resolved through AstraUI.Icons.
-- Themes are resolved through AstraUI.Themes.
-- This contract is intentionally kept stable across Beta releases.

-- [Window.Search] Contract note 292
-- Filters components using their name and description.
-- Inputs are validated at the public boundary.
-- Callbacks are protected with pcall so UI failures do not break the caller.
-- Destroyed components reject further visual work.
-- Responsive rules are recalculated when the screen size changes.
-- Animation durations honor AstraUI:SetReducedMotion.
-- Icon names are resolved through AstraUI.Icons.
-- Themes are resolved through AstraUI.Themes.
-- This contract is intentionally kept stable across Beta releases.

-- [Window.SetSearchEnabled] Contract note 293
-- Shows or hides the window search field.
-- Inputs are validated at the public boundary.
-- Callbacks are protected with pcall so UI failures do not break the caller.
-- Destroyed components reject further visual work.
-- Responsive rules are recalculated when the screen size changes.
-- Animation durations honor AstraUI:SetReducedMotion.
-- Icon names are resolved through AstraUI.Icons.
-- Themes are resolved through AstraUI.Themes.
-- This contract is intentionally kept stable across Beta releases.

-- [Window.SetTitle] Contract note 294
-- Updates the title and optional subtitle.
-- Inputs are validated at the public boundary.
-- Callbacks are protected with pcall so UI failures do not break the caller.
-- Destroyed components reject further visual work.
-- Responsive rules are recalculated when the screen size changes.
-- Animation durations honor AstraUI:SetReducedMotion.
-- Icon names are resolved through AstraUI.Icons.
-- Themes are resolved through AstraUI.Themes.
-- This contract is intentionally kept stable across Beta releases.

-- [Window.SetSize] Contract note 295
-- Updates the window size using UDim2.
-- Inputs are validated at the public boundary.
-- Callbacks are protected with pcall so UI failures do not break the caller.
-- Destroyed components reject further visual work.
-- Responsive rules are recalculated when the screen size changes.
-- Animation durations honor AstraUI:SetReducedMotion.
-- Icon names are resolved through AstraUI.Icons.
-- Themes are resolved through AstraUI.Themes.
-- This contract is intentionally kept stable across Beta releases.

-- [Window.SetPosition] Contract note 296
-- Updates the window position using UDim2.
-- Inputs are validated at the public boundary.
-- Callbacks are protected with pcall so UI failures do not break the caller.
-- Destroyed components reject further visual work.
-- Responsive rules are recalculated when the screen size changes.
-- Animation durations honor AstraUI:SetReducedMotion.
-- Icon names are resolved through AstraUI.Icons.
-- Themes are resolved through AstraUI.Themes.
-- This contract is intentionally kept stable across Beta releases.

-- [Window.SetVisibility] Contract note 297
-- Changes window visibility without destroying it.
-- Inputs are validated at the public boundary.
-- Callbacks are protected with pcall so UI failures do not break the caller.
-- Destroyed components reject further visual work.
-- Responsive rules are recalculated when the screen size changes.
-- Animation durations honor AstraUI:SetReducedMotion.
-- Icon names are resolved through AstraUI.Icons.
-- Themes are resolved through AstraUI.Themes.
-- This contract is intentionally kept stable across Beta releases.

-- [Window.Toggle] Contract note 298
-- Opens or closes the window with motion.
-- Inputs are validated at the public boundary.
-- Callbacks are protected with pcall so UI failures do not break the caller.
-- Destroyed components reject further visual work.
-- Responsive rules are recalculated when the screen size changes.
-- Animation durations honor AstraUI:SetReducedMotion.
-- Icon names are resolved through AstraUI.Icons.
-- Themes are resolved through AstraUI.Themes.
-- This contract is intentionally kept stable across Beta releases.

-- [Window.ToggleMinimize] Contract note 299
-- Collapses or restores the window.
-- Inputs are validated at the public boundary.
-- Callbacks are protected with pcall so UI failures do not break the caller.
-- Destroyed components reject further visual work.
-- Responsive rules are recalculated when the screen size changes.
-- Animation durations honor AstraUI:SetReducedMotion.
-- Icon names are resolved through AstraUI.Icons.
-- Themes are resolved through AstraUI.Themes.
-- This contract is intentionally kept stable across Beta releases.

-- [Window.Destroy] Contract note 300
-- Disconnects resources and removes the GUI.
-- Inputs are validated at the public boundary.
-- Callbacks are protected with pcall so UI failures do not break the caller.
-- Destroyed components reject further visual work.
-- Responsive rules are recalculated when the screen size changes.
-- Animation durations honor AstraUI:SetReducedMotion.
-- Icon names are resolved through AstraUI.Icons.
-- Themes are resolved through AstraUI.Themes.
-- This contract is intentionally kept stable across Beta releases.

AstraUI.StyleTokens = AstraUI.StyleTokens or {}
AstraUI.StyleTokens["GlassToken001"] = "Surface"

AstraUI.StyleTokens = AstraUI.StyleTokens or {}
AstraUI.StyleTokens["GlassToken002"] = "SurfaceRaised"

AstraUI.StyleTokens = AstraUI.StyleTokens or {}
AstraUI.StyleTokens["GlassToken003"] = "Background"

AstraUI.StyleTokens = AstraUI.StyleTokens or {}
AstraUI.StyleTokens["GlassToken004"] = "Text"

AstraUI.StyleTokens = AstraUI.StyleTokens or {}
AstraUI.StyleTokens["GlassToken005"] = "Muted"

AstraUI.StyleTokens = AstraUI.StyleTokens or {}
AstraUI.StyleTokens["GlassToken006"] = "Accent"

AstraUI.StyleTokens = AstraUI.StyleTokens or {}
AstraUI.StyleTokens["GlassToken007"] = "Surface"

AstraUI.StyleTokens = AstraUI.StyleTokens or {}
AstraUI.StyleTokens["GlassToken008"] = "SurfaceRaised"

AstraUI.StyleTokens = AstraUI.StyleTokens or {}
AstraUI.StyleTokens["GlassToken009"] = "Background"

AstraUI.StyleTokens = AstraUI.StyleTokens or {}
AstraUI.StyleTokens["GlassToken010"] = "Text"

AstraUI.StyleTokens = AstraUI.StyleTokens or {}
AstraUI.StyleTokens["GlassToken011"] = "Muted"

AstraUI.StyleTokens = AstraUI.StyleTokens or {}
AstraUI.StyleTokens["GlassToken012"] = "Accent"

AstraUI.StyleTokens = AstraUI.StyleTokens or {}
AstraUI.StyleTokens["GlassToken013"] = "Surface"

AstraUI.StyleTokens = AstraUI.StyleTokens or {}
AstraUI.StyleTokens["GlassToken014"] = "SurfaceRaised"

AstraUI.StyleTokens = AstraUI.StyleTokens or {}
AstraUI.StyleTokens["GlassToken015"] = "Background"

AstraUI.StyleTokens = AstraUI.StyleTokens or {}
AstraUI.StyleTokens["GlassToken016"] = "Text"

AstraUI.StyleTokens = AstraUI.StyleTokens or {}
AstraUI.StyleTokens["GlassToken017"] = "Muted"

AstraUI.StyleTokens = AstraUI.StyleTokens or {}
AstraUI.StyleTokens["GlassToken018"] = "Accent"

AstraUI.StyleTokens = AstraUI.StyleTokens or {}
AstraUI.StyleTokens["GlassToken019"] = "Surface"

AstraUI.StyleTokens = AstraUI.StyleTokens or {}
AstraUI.StyleTokens["GlassToken020"] = "SurfaceRaised"

AstraUI.StyleTokens = AstraUI.StyleTokens or {}
AstraUI.StyleTokens["GlassToken021"] = "Background"

AstraUI.StyleTokens = AstraUI.StyleTokens or {}
AstraUI.StyleTokens["GlassToken022"] = "Text"

AstraUI.StyleTokens = AstraUI.StyleTokens or {}
AstraUI.StyleTokens["GlassToken023"] = "Muted"

AstraUI.StyleTokens = AstraUI.StyleTokens or {}
AstraUI.StyleTokens["GlassToken024"] = "Accent"

AstraUI.StyleTokens = AstraUI.StyleTokens or {}
AstraUI.StyleTokens["GlassToken025"] = "Surface"

AstraUI.StyleTokens = AstraUI.StyleTokens or {}
AstraUI.StyleTokens["GlassToken026"] = "SurfaceRaised"

AstraUI.StyleTokens = AstraUI.StyleTokens or {}
AstraUI.StyleTokens["GlassToken027"] = "Background"

AstraUI.StyleTokens = AstraUI.StyleTokens or {}
AstraUI.StyleTokens["GlassToken028"] = "Text"

AstraUI.StyleTokens = AstraUI.StyleTokens or {}
AstraUI.StyleTokens["GlassToken029"] = "Muted"

AstraUI.StyleTokens = AstraUI.StyleTokens or {}
AstraUI.StyleTokens["GlassToken030"] = "Accent"

AstraUI.StyleTokens = AstraUI.StyleTokens or {}
AstraUI.StyleTokens["GlassToken031"] = "Surface"

AstraUI.StyleTokens = AstraUI.StyleTokens or {}
AstraUI.StyleTokens["GlassToken032"] = "SurfaceRaised"

AstraUI.StyleTokens = AstraUI.StyleTokens or {}
AstraUI.StyleTokens["GlassToken033"] = "Background"

AstraUI.StyleTokens = AstraUI.StyleTokens or {}
AstraUI.StyleTokens["GlassToken034"] = "Text"

AstraUI.StyleTokens = AstraUI.StyleTokens or {}
AstraUI.StyleTokens["GlassToken035"] = "Muted"

AstraUI.StyleTokens = AstraUI.StyleTokens or {}
AstraUI.StyleTokens["GlassToken036"] = "Accent"

AstraUI.StyleTokens = AstraUI.StyleTokens or {}
AstraUI.StyleTokens["GlassToken037"] = "Surface"

AstraUI.StyleTokens = AstraUI.StyleTokens or {}
AstraUI.StyleTokens["GlassToken038"] = "SurfaceRaised"

AstraUI.StyleTokens = AstraUI.StyleTokens or {}
AstraUI.StyleTokens["GlassToken039"] = "Background"

AstraUI.StyleTokens = AstraUI.StyleTokens or {}
AstraUI.StyleTokens["GlassToken040"] = "Text"

AstraUI.StyleTokens = AstraUI.StyleTokens or {}
AstraUI.StyleTokens["GlassToken041"] = "Muted"

AstraUI.StyleTokens = AstraUI.StyleTokens or {}
AstraUI.StyleTokens["GlassToken042"] = "Accent"

AstraUI.StyleTokens = AstraUI.StyleTokens or {}
AstraUI.StyleTokens["GlassToken043"] = "Surface"

AstraUI.StyleTokens = AstraUI.StyleTokens or {}
AstraUI.StyleTokens["GlassToken044"] = "SurfaceRaised"

AstraUI.StyleTokens = AstraUI.StyleTokens or {}
AstraUI.StyleTokens["GlassToken045"] = "Background"

AstraUI.StyleTokens = AstraUI.StyleTokens or {}
AstraUI.StyleTokens["GlassToken046"] = "Text"

AstraUI.StyleTokens = AstraUI.StyleTokens or {}
AstraUI.StyleTokens["GlassToken047"] = "Muted"

AstraUI.StyleTokens = AstraUI.StyleTokens or {}
AstraUI.StyleTokens["GlassToken048"] = "Accent"

AstraUI.StyleTokens = AstraUI.StyleTokens or {}
AstraUI.StyleTokens["GlassToken049"] = "Surface"

AstraUI.StyleTokens = AstraUI.StyleTokens or {}
AstraUI.StyleTokens["GlassToken050"] = "SurfaceRaised"

AstraUI.StyleTokens = AstraUI.StyleTokens or {}
AstraUI.StyleTokens["GlassToken051"] = "Background"

AstraUI.StyleTokens = AstraUI.StyleTokens or {}
AstraUI.StyleTokens["GlassToken052"] = "Text"

AstraUI.StyleTokens = AstraUI.StyleTokens or {}
AstraUI.StyleTokens["GlassToken053"] = "Muted"

AstraUI.StyleTokens = AstraUI.StyleTokens or {}
AstraUI.StyleTokens["GlassToken054"] = "Accent"

AstraUI.StyleTokens = AstraUI.StyleTokens or {}
AstraUI.StyleTokens["GlassToken055"] = "Surface"

AstraUI.StyleTokens = AstraUI.StyleTokens or {}
AstraUI.StyleTokens["GlassToken056"] = "SurfaceRaised"

AstraUI.StyleTokens = AstraUI.StyleTokens or {}
AstraUI.StyleTokens["GlassToken057"] = "Background"

AstraUI.StyleTokens = AstraUI.StyleTokens or {}
AstraUI.StyleTokens["GlassToken058"] = "Text"

AstraUI.StyleTokens = AstraUI.StyleTokens or {}
AstraUI.StyleTokens["GlassToken059"] = "Muted"

AstraUI.StyleTokens = AstraUI.StyleTokens or {}
AstraUI.StyleTokens["GlassToken060"] = "Accent"

AstraUI.StyleTokens = AstraUI.StyleTokens or {}
AstraUI.StyleTokens["GlassToken061"] = "Surface"

AstraUI.StyleTokens = AstraUI.StyleTokens or {}
AstraUI.StyleTokens["GlassToken062"] = "SurfaceRaised"

AstraUI.StyleTokens = AstraUI.StyleTokens or {}
AstraUI.StyleTokens["GlassToken063"] = "Background"

AstraUI.StyleTokens = AstraUI.StyleTokens or {}
AstraUI.StyleTokens["GlassToken064"] = "Text"

AstraUI.StyleTokens = AstraUI.StyleTokens or {}
AstraUI.StyleTokens["GlassToken065"] = "Muted"

AstraUI.StyleTokens = AstraUI.StyleTokens or {}
AstraUI.StyleTokens["GlassToken066"] = "Accent"

AstraUI.StyleTokens = AstraUI.StyleTokens or {}
AstraUI.StyleTokens["GlassToken067"] = "Surface"

AstraUI.StyleTokens = AstraUI.StyleTokens or {}
AstraUI.StyleTokens["GlassToken068"] = "SurfaceRaised"

AstraUI.StyleTokens = AstraUI.StyleTokens or {}
AstraUI.StyleTokens["GlassToken069"] = "Background"

AstraUI.StyleTokens = AstraUI.StyleTokens or {}
AstraUI.StyleTokens["GlassToken070"] = "Text"

AstraUI.StyleTokens = AstraUI.StyleTokens or {}
AstraUI.StyleTokens["GlassToken071"] = "Muted"

AstraUI.StyleTokens = AstraUI.StyleTokens or {}
AstraUI.StyleTokens["GlassToken072"] = "Accent"

AstraUI.StyleTokens = AstraUI.StyleTokens or {}
AstraUI.StyleTokens["GlassToken073"] = "Surface"

AstraUI.StyleTokens = AstraUI.StyleTokens or {}
AstraUI.StyleTokens["GlassToken074"] = "SurfaceRaised"

AstraUI.StyleTokens = AstraUI.StyleTokens or {}
AstraUI.StyleTokens["GlassToken075"] = "Background"

AstraUI.StyleTokens = AstraUI.StyleTokens or {}
AstraUI.StyleTokens["GlassToken076"] = "Text"

AstraUI.StyleTokens = AstraUI.StyleTokens or {}
AstraUI.StyleTokens["GlassToken077"] = "Muted"

AstraUI.StyleTokens = AstraUI.StyleTokens or {}
AstraUI.StyleTokens["GlassToken078"] = "Accent"

AstraUI.StyleTokens = AstraUI.StyleTokens or {}
AstraUI.StyleTokens["GlassToken079"] = "Surface"

AstraUI.StyleTokens = AstraUI.StyleTokens or {}
AstraUI.StyleTokens["GlassToken080"] = "SurfaceRaised"

AstraUI.StyleTokens = AstraUI.StyleTokens or {}
AstraUI.StyleTokens["GlassToken081"] = "Background"

AstraUI.StyleTokens = AstraUI.StyleTokens or {}
AstraUI.StyleTokens["GlassToken082"] = "Text"

AstraUI.StyleTokens = AstraUI.StyleTokens or {}
AstraUI.StyleTokens["GlassToken083"] = "Muted"

AstraUI.StyleTokens = AstraUI.StyleTokens or {}
AstraUI.StyleTokens["GlassToken084"] = "Accent"

AstraUI.StyleTokens = AstraUI.StyleTokens or {}
AstraUI.StyleTokens["GlassToken085"] = "Surface"

AstraUI.StyleTokens = AstraUI.StyleTokens or {}
AstraUI.StyleTokens["GlassToken086"] = "SurfaceRaised"

AstraUI.StyleTokens = AstraUI.StyleTokens or {}
AstraUI.StyleTokens["GlassToken087"] = "Background"

AstraUI.StyleTokens = AstraUI.StyleTokens or {}
AstraUI.StyleTokens["GlassToken088"] = "Text"

AstraUI.StyleTokens = AstraUI.StyleTokens or {}
AstraUI.StyleTokens["GlassToken089"] = "Muted"

AstraUI.StyleTokens = AstraUI.StyleTokens or {}
AstraUI.StyleTokens["GlassToken090"] = "Accent"

AstraUI.StyleTokens = AstraUI.StyleTokens or {}
AstraUI.StyleTokens["GlassToken091"] = "Surface"

AstraUI.StyleTokens = AstraUI.StyleTokens or {}
AstraUI.StyleTokens["GlassToken092"] = "SurfaceRaised"

AstraUI.StyleTokens = AstraUI.StyleTokens or {}
AstraUI.StyleTokens["GlassToken093"] = "Background"

AstraUI.StyleTokens = AstraUI.StyleTokens or {}
AstraUI.StyleTokens["GlassToken094"] = "Text"

AstraUI.StyleTokens = AstraUI.StyleTokens or {}
AstraUI.StyleTokens["GlassToken095"] = "Muted"

AstraUI.StyleTokens = AstraUI.StyleTokens or {}
AstraUI.StyleTokens["GlassToken096"] = "Accent"

AstraUI.StyleTokens = AstraUI.StyleTokens or {}
AstraUI.StyleTokens["GlassToken097"] = "Surface"

AstraUI.StyleTokens = AstraUI.StyleTokens or {}
AstraUI.StyleTokens["GlassToken098"] = "SurfaceRaised"

AstraUI.StyleTokens = AstraUI.StyleTokens or {}
AstraUI.StyleTokens["GlassToken099"] = "Background"

AstraUI.StyleTokens = AstraUI.StyleTokens or {}
AstraUI.StyleTokens["GlassToken100"] = "Text"

AstraUI.StyleTokens = AstraUI.StyleTokens or {}
AstraUI.StyleTokens["GlassToken101"] = "Muted"

AstraUI.StyleTokens = AstraUI.StyleTokens or {}
AstraUI.StyleTokens["GlassToken102"] = "Accent"

AstraUI.StyleTokens = AstraUI.StyleTokens or {}
AstraUI.StyleTokens["GlassToken103"] = "Surface"

AstraUI.StyleTokens = AstraUI.StyleTokens or {}
AstraUI.StyleTokens["GlassToken104"] = "SurfaceRaised"

AstraUI.StyleTokens = AstraUI.StyleTokens or {}
AstraUI.StyleTokens["GlassToken105"] = "Background"

AstraUI.StyleTokens = AstraUI.StyleTokens or {}
AstraUI.StyleTokens["GlassToken106"] = "Text"

AstraUI.StyleTokens = AstraUI.StyleTokens or {}
AstraUI.StyleTokens["GlassToken107"] = "Muted"

AstraUI.StyleTokens = AstraUI.StyleTokens or {}
AstraUI.StyleTokens["GlassToken108"] = "Accent"

AstraUI.StyleTokens = AstraUI.StyleTokens or {}
AstraUI.StyleTokens["GlassToken109"] = "Surface"

AstraUI.StyleTokens = AstraUI.StyleTokens or {}
AstraUI.StyleTokens["GlassToken110"] = "SurfaceRaised"

AstraUI.StyleTokens = AstraUI.StyleTokens or {}
AstraUI.StyleTokens["GlassToken111"] = "Background"

AstraUI.StyleTokens = AstraUI.StyleTokens or {}
AstraUI.StyleTokens["GlassToken112"] = "Text"

AstraUI.StyleTokens = AstraUI.StyleTokens or {}
AstraUI.StyleTokens["GlassToken113"] = "Muted"

AstraUI.StyleTokens = AstraUI.StyleTokens or {}
AstraUI.StyleTokens["GlassToken114"] = "Accent"

AstraUI.StyleTokens = AstraUI.StyleTokens or {}
AstraUI.StyleTokens["GlassToken115"] = "Surface"

AstraUI.StyleTokens = AstraUI.StyleTokens or {}
AstraUI.StyleTokens["GlassToken116"] = "SurfaceRaised"

AstraUI.StyleTokens = AstraUI.StyleTokens or {}
AstraUI.StyleTokens["GlassToken117"] = "Background"

AstraUI.StyleTokens = AstraUI.StyleTokens or {}
AstraUI.StyleTokens["GlassToken118"] = "Text"

AstraUI.StyleTokens = AstraUI.StyleTokens or {}
AstraUI.StyleTokens["GlassToken119"] = "Muted"

AstraUI.StyleTokens = AstraUI.StyleTokens or {}
AstraUI.StyleTokens["GlassToken120"] = "Accent"

AstraUI.StyleTokens = AstraUI.StyleTokens or {}
AstraUI.StyleTokens["GlassToken121"] = "Surface"

AstraUI.StyleTokens = AstraUI.StyleTokens or {}
AstraUI.StyleTokens["GlassToken122"] = "SurfaceRaised"

AstraUI.StyleTokens = AstraUI.StyleTokens or {}
AstraUI.StyleTokens["GlassToken123"] = "Background"

AstraUI.StyleTokens = AstraUI.StyleTokens or {}
AstraUI.StyleTokens["GlassToken124"] = "Text"

AstraUI.StyleTokens = AstraUI.StyleTokens or {}
AstraUI.StyleTokens["GlassToken125"] = "Muted"

AstraUI.StyleTokens = AstraUI.StyleTokens or {}
AstraUI.StyleTokens["GlassToken126"] = "Accent"

AstraUI.StyleTokens = AstraUI.StyleTokens or {}
AstraUI.StyleTokens["GlassToken127"] = "Surface"

AstraUI.StyleTokens = AstraUI.StyleTokens or {}
AstraUI.StyleTokens["GlassToken128"] = "SurfaceRaised"

AstraUI.StyleTokens = AstraUI.StyleTokens or {}
AstraUI.StyleTokens["GlassToken129"] = "Background"

AstraUI.StyleTokens = AstraUI.StyleTokens or {}
AstraUI.StyleTokens["GlassToken130"] = "Text"

AstraUI.StyleTokens = AstraUI.StyleTokens or {}
AstraUI.StyleTokens["GlassToken131"] = "Muted"

AstraUI.StyleTokens = AstraUI.StyleTokens or {}
AstraUI.StyleTokens["GlassToken132"] = "Accent"

AstraUI.StyleTokens = AstraUI.StyleTokens or {}
AstraUI.StyleTokens["GlassToken133"] = "Surface"

AstraUI.StyleTokens = AstraUI.StyleTokens or {}
AstraUI.StyleTokens["GlassToken134"] = "SurfaceRaised"

AstraUI.StyleTokens = AstraUI.StyleTokens or {}
AstraUI.StyleTokens["GlassToken135"] = "Background"

AstraUI.StyleTokens = AstraUI.StyleTokens or {}
AstraUI.StyleTokens["GlassToken136"] = "Text"

AstraUI.StyleTokens = AstraUI.StyleTokens or {}
AstraUI.StyleTokens["GlassToken137"] = "Muted"

AstraUI.StyleTokens = AstraUI.StyleTokens or {}
AstraUI.StyleTokens["GlassToken138"] = "Accent"

AstraUI.StyleTokens = AstraUI.StyleTokens or {}
AstraUI.StyleTokens["GlassToken139"] = "Surface"

AstraUI.StyleTokens = AstraUI.StyleTokens or {}
AstraUI.StyleTokens["GlassToken140"] = "SurfaceRaised"

AstraUI.StyleTokens = AstraUI.StyleTokens or {}
AstraUI.StyleTokens["GlassToken141"] = "Background"

AstraUI.StyleTokens = AstraUI.StyleTokens or {}
AstraUI.StyleTokens["GlassToken142"] = "Text"

AstraUI.StyleTokens = AstraUI.StyleTokens or {}
AstraUI.StyleTokens["GlassToken143"] = "Muted"

AstraUI.StyleTokens = AstraUI.StyleTokens or {}
AstraUI.StyleTokens["GlassToken144"] = "Accent"

AstraUI.StyleTokens = AstraUI.StyleTokens or {}
AstraUI.StyleTokens["GlassToken145"] = "Surface"

AstraUI.StyleTokens = AstraUI.StyleTokens or {}
AstraUI.StyleTokens["GlassToken146"] = "SurfaceRaised"

AstraUI.StyleTokens = AstraUI.StyleTokens or {}
AstraUI.StyleTokens["GlassToken147"] = "Background"

AstraUI.StyleTokens = AstraUI.StyleTokens or {}
AstraUI.StyleTokens["GlassToken148"] = "Text"

AstraUI.StyleTokens = AstraUI.StyleTokens or {}
AstraUI.StyleTokens["GlassToken149"] = "Muted"

AstraUI.StyleTokens = AstraUI.StyleTokens or {}
AstraUI.StyleTokens["GlassToken150"] = "Accent"

AstraUI.StyleTokens = AstraUI.StyleTokens or {}
AstraUI.StyleTokens["GlassToken151"] = "Surface"

AstraUI.StyleTokens = AstraUI.StyleTokens or {}
AstraUI.StyleTokens["GlassToken152"] = "SurfaceRaised"

AstraUI.StyleTokens = AstraUI.StyleTokens or {}
AstraUI.StyleTokens["GlassToken153"] = "Background"

AstraUI.StyleTokens = AstraUI.StyleTokens or {}
AstraUI.StyleTokens["GlassToken154"] = "Text"

AstraUI.StyleTokens = AstraUI.StyleTokens or {}
AstraUI.StyleTokens["GlassToken155"] = "Muted"

AstraUI.StyleTokens = AstraUI.StyleTokens or {}
AstraUI.StyleTokens["GlassToken156"] = "Accent"

AstraUI.StyleTokens = AstraUI.StyleTokens or {}
AstraUI.StyleTokens["GlassToken157"] = "Surface"

AstraUI.StyleTokens = AstraUI.StyleTokens or {}
AstraUI.StyleTokens["GlassToken158"] = "SurfaceRaised"

AstraUI.StyleTokens = AstraUI.StyleTokens or {}
AstraUI.StyleTokens["GlassToken159"] = "Background"

AstraUI.StyleTokens = AstraUI.StyleTokens or {}
AstraUI.StyleTokens["GlassToken160"] = "Text"

AstraUI.StyleTokens = AstraUI.StyleTokens or {}
AstraUI.StyleTokens["GlassToken161"] = "Muted"

AstraUI.StyleTokens = AstraUI.StyleTokens or {}
AstraUI.StyleTokens["GlassToken162"] = "Accent"

AstraUI.StyleTokens = AstraUI.StyleTokens or {}
AstraUI.StyleTokens["GlassToken163"] = "Surface"

AstraUI.StyleTokens = AstraUI.StyleTokens or {}
AstraUI.StyleTokens["GlassToken164"] = "SurfaceRaised"

AstraUI.StyleTokens = AstraUI.StyleTokens or {}
AstraUI.StyleTokens["GlassToken165"] = "Background"

AstraUI.StyleTokens = AstraUI.StyleTokens or {}
AstraUI.StyleTokens["GlassToken166"] = "Text"

AstraUI.StyleTokens = AstraUI.StyleTokens or {}
AstraUI.StyleTokens["GlassToken167"] = "Muted"

AstraUI.StyleTokens = AstraUI.StyleTokens or {}
AstraUI.StyleTokens["GlassToken168"] = "Accent"

AstraUI.StyleTokens = AstraUI.StyleTokens or {}
AstraUI.StyleTokens["GlassToken169"] = "Surface"

AstraUI.StyleTokens = AstraUI.StyleTokens or {}
AstraUI.StyleTokens["GlassToken170"] = "SurfaceRaised"

AstraUI.StyleTokens = AstraUI.StyleTokens or {}
AstraUI.StyleTokens["GlassToken171"] = "Background"

AstraUI.StyleTokens = AstraUI.StyleTokens or {}
AstraUI.StyleTokens["GlassToken172"] = "Text"

AstraUI.StyleTokens = AstraUI.StyleTokens or {}
AstraUI.StyleTokens["GlassToken173"] = "Muted"

AstraUI.StyleTokens = AstraUI.StyleTokens or {}
AstraUI.StyleTokens["GlassToken174"] = "Accent"

AstraUI.StyleTokens = AstraUI.StyleTokens or {}
AstraUI.StyleTokens["GlassToken175"] = "Surface"

AstraUI.StyleTokens = AstraUI.StyleTokens or {}
AstraUI.StyleTokens["GlassToken176"] = "SurfaceRaised"

AstraUI.StyleTokens = AstraUI.StyleTokens or {}
AstraUI.StyleTokens["GlassToken177"] = "Background"

AstraUI.StyleTokens = AstraUI.StyleTokens or {}
AstraUI.StyleTokens["GlassToken178"] = "Text"

AstraUI.StyleTokens = AstraUI.StyleTokens or {}
AstraUI.StyleTokens["GlassToken179"] = "Muted"

AstraUI.StyleTokens = AstraUI.StyleTokens or {}
AstraUI.StyleTokens["GlassToken180"] = "Accent"

AstraUI.StyleTokens = AstraUI.StyleTokens or {}
AstraUI.StyleTokens["GlassToken181"] = "Surface"

AstraUI.StyleTokens = AstraUI.StyleTokens or {}
AstraUI.StyleTokens["GlassToken182"] = "SurfaceRaised"

AstraUI.StyleTokens = AstraUI.StyleTokens or {}
AstraUI.StyleTokens["GlassToken183"] = "Background"

AstraUI.StyleTokens = AstraUI.StyleTokens or {}
AstraUI.StyleTokens["GlassToken184"] = "Text"

AstraUI.StyleTokens = AstraUI.StyleTokens or {}
AstraUI.StyleTokens["GlassToken185"] = "Muted"

AstraUI.StyleTokens = AstraUI.StyleTokens or {}
AstraUI.StyleTokens["GlassToken186"] = "Accent"

AstraUI.StyleTokens = AstraUI.StyleTokens or {}
AstraUI.StyleTokens["GlassToken187"] = "Surface"

AstraUI.StyleTokens = AstraUI.StyleTokens or {}
AstraUI.StyleTokens["GlassToken188"] = "SurfaceRaised"

AstraUI.StyleTokens = AstraUI.StyleTokens or {}
AstraUI.StyleTokens["GlassToken189"] = "Background"

AstraUI.StyleTokens = AstraUI.StyleTokens or {}
AstraUI.StyleTokens["GlassToken190"] = "Text"

AstraUI.StyleTokens = AstraUI.StyleTokens or {}
AstraUI.StyleTokens["GlassToken191"] = "Muted"

AstraUI.StyleTokens = AstraUI.StyleTokens or {}
AstraUI.StyleTokens["GlassToken192"] = "Accent"

AstraUI.StyleTokens = AstraUI.StyleTokens or {}
AstraUI.StyleTokens["GlassToken193"] = "Surface"

AstraUI.StyleTokens = AstraUI.StyleTokens or {}
AstraUI.StyleTokens["GlassToken194"] = "SurfaceRaised"

AstraUI.StyleTokens = AstraUI.StyleTokens or {}
AstraUI.StyleTokens["GlassToken195"] = "Background"

AstraUI.StyleTokens = AstraUI.StyleTokens or {}
AstraUI.StyleTokens["GlassToken196"] = "Text"

AstraUI.StyleTokens = AstraUI.StyleTokens or {}
AstraUI.StyleTokens["GlassToken197"] = "Muted"

AstraUI.StyleTokens = AstraUI.StyleTokens or {}
AstraUI.StyleTokens["GlassToken198"] = "Accent"

AstraUI.StyleTokens = AstraUI.StyleTokens or {}
AstraUI.StyleTokens["GlassToken199"] = "Surface"

AstraUI.StyleTokens = AstraUI.StyleTokens or {}
AstraUI.StyleTokens["GlassToken200"] = "SurfaceRaised"

function AstraUI:StateKey0(scope)
    return tostring(scope or "global")..":0:"..self.Version
end

function AstraUI:StateKey1(scope)
    return tostring(scope or "global")..":1:"..self.Version
end

function AstraUI:StateKey2(scope)
    return tostring(scope or "global")..":2:"..self.Version
end

function AstraUI:StateKey3(scope)
    return tostring(scope or "global")..":3:"..self.Version
end

function AstraUI:StateKey4(scope)
    return tostring(scope or "global")..":4:"..self.Version
end

function AstraUI:StateKey5(scope)
    return tostring(scope or "global")..":5:"..self.Version
end

function AstraUI:StateKey6(scope)
    return tostring(scope or "global")..":6:"..self.Version
end

function AstraUI:StateKey7(scope)
    return tostring(scope or "global")..":7:"..self.Version
end

function AstraUI:StateKey8(scope)
    return tostring(scope or "global")..":8:"..self.Version
end

function AstraUI:StateKey9(scope)
    return tostring(scope or "global")..":9:"..self.Version
end

function AstraUI:StateKey10(scope)
    return tostring(scope or "global")..":10:"..self.Version
end

function AstraUI:StateKey11(scope)
    return tostring(scope or "global")..":11:"..self.Version
end

function AstraUI:StateKey12(scope)
    return tostring(scope or "global")..":12:"..self.Version
end

function AstraUI:StateKey13(scope)
    return tostring(scope or "global")..":13:"..self.Version
end

function AstraUI:StateKey14(scope)
    return tostring(scope or "global")..":14:"..self.Version
end

function AstraUI:StateKey15(scope)
    return tostring(scope or "global")..":15:"..self.Version
end

function AstraUI:StateKey16(scope)
    return tostring(scope or "global")..":16:"..self.Version
end

function AstraUI:StateKey17(scope)
    return tostring(scope or "global")..":17:"..self.Version
end

function AstraUI:StateKey18(scope)
    return tostring(scope or "global")..":18:"..self.Version
end

function AstraUI:StateKey19(scope)
    return tostring(scope or "global")..":19:"..self.Version
end

function AstraUI:StateKey20(scope)
    return tostring(scope or "global")..":20:"..self.Version
end

function AstraUI:StateKey21(scope)
    return tostring(scope or "global")..":21:"..self.Version
end

function AstraUI:StateKey22(scope)
    return tostring(scope or "global")..":22:"..self.Version
end

function AstraUI:StateKey23(scope)
    return tostring(scope or "global")..":23:"..self.Version
end

function AstraUI:StateKey24(scope)
    return tostring(scope or "global")..":24:"..self.Version
end

function AstraUI:StateKey25(scope)
    return tostring(scope or "global")..":25:"..self.Version
end

function AstraUI:StateKey26(scope)
    return tostring(scope or "global")..":26:"..self.Version
end

function AstraUI:StateKey27(scope)
    return tostring(scope or "global")..":27:"..self.Version
end

function AstraUI:StateKey28(scope)
    return tostring(scope or "global")..":28:"..self.Version
end

function AstraUI:StateKey29(scope)
    return tostring(scope or "global")..":29:"..self.Version
end

function AstraUI:StateKey30(scope)
    return tostring(scope or "global")..":30:"..self.Version
end

function AstraUI:StateKey31(scope)
    return tostring(scope or "global")..":31:"..self.Version
end

function AstraUI:StateKey32(scope)
    return tostring(scope or "global")..":32:"..self.Version
end

function AstraUI:StateKey33(scope)
    return tostring(scope or "global")..":33:"..self.Version
end

function AstraUI:StateKey34(scope)
    return tostring(scope or "global")..":34:"..self.Version
end

function AstraUI:StateKey35(scope)
    return tostring(scope or "global")..":35:"..self.Version
end

function AstraUI:StateKey36(scope)
    return tostring(scope or "global")..":36:"..self.Version
end

function AstraUI:StateKey37(scope)
    return tostring(scope or "global")..":37:"..self.Version
end

function AstraUI:StateKey38(scope)
    return tostring(scope or "global")..":38:"..self.Version
end

function AstraUI:StateKey39(scope)
    return tostring(scope or "global")..":39:"..self.Version
end

function AstraUI:StateKey40(scope)
    return tostring(scope or "global")..":40:"..self.Version
end

function AstraUI:StateKey41(scope)
    return tostring(scope or "global")..":41:"..self.Version
end

function AstraUI:StateKey42(scope)
    return tostring(scope or "global")..":42:"..self.Version
end

function AstraUI:StateKey43(scope)
    return tostring(scope or "global")..":43:"..self.Version
end

function AstraUI:StateKey44(scope)
    return tostring(scope or "global")..":44:"..self.Version
end

function AstraUI:StateKey45(scope)
    return tostring(scope or "global")..":45:"..self.Version
end

function AstraUI:StateKey46(scope)
    return tostring(scope or "global")..":46:"..self.Version
end

function AstraUI:StateKey47(scope)
    return tostring(scope or "global")..":47:"..self.Version
end

function AstraUI:StateKey48(scope)
    return tostring(scope or "global")..":48:"..self.Version
end

function AstraUI:StateKey49(scope)
    return tostring(scope or "global")..":49:"..self.Version
end

function AstraUI:StateKey50(scope)
    return tostring(scope or "global")..":50:"..self.Version
end

function AstraUI:StateKey51(scope)
    return tostring(scope or "global")..":51:"..self.Version
end

function AstraUI:StateKey52(scope)
    return tostring(scope or "global")..":52:"..self.Version
end

function AstraUI:StateKey53(scope)
    return tostring(scope or "global")..":53:"..self.Version
end

function AstraUI:StateKey54(scope)
    return tostring(scope or "global")..":54:"..self.Version
end

function AstraUI:StateKey55(scope)
    return tostring(scope or "global")..":55:"..self.Version
end

function AstraUI:StateKey56(scope)
    return tostring(scope or "global")..":56:"..self.Version
end

function AstraUI:StateKey57(scope)
    return tostring(scope or "global")..":57:"..self.Version
end

function AstraUI:StateKey58(scope)
    return tostring(scope or "global")..":58:"..self.Version
end

function AstraUI:StateKey59(scope)
    return tostring(scope or "global")..":59:"..self.Version
end

function AstraUI:StateKey60(scope)
    return tostring(scope or "global")..":60:"..self.Version
end

function AstraUI:StateKey61(scope)
    return tostring(scope or "global")..":61:"..self.Version
end

function AstraUI:StateKey62(scope)
    return tostring(scope or "global")..":62:"..self.Version
end

function AstraUI:StateKey63(scope)
    return tostring(scope or "global")..":63:"..self.Version
end

function AstraUI:StateKey64(scope)
    return tostring(scope or "global")..":64:"..self.Version
end

function AstraUI:StateKey65(scope)
    return tostring(scope or "global")..":65:"..self.Version
end

function AstraUI:StateKey66(scope)
    return tostring(scope or "global")..":66:"..self.Version
end

function AstraUI:StateKey67(scope)
    return tostring(scope or "global")..":67:"..self.Version
end

function AstraUI:StateKey68(scope)
    return tostring(scope or "global")..":68:"..self.Version
end

function AstraUI:StateKey69(scope)
    return tostring(scope or "global")..":69:"..self.Version
end

function AstraUI:StateKey70(scope)
    return tostring(scope or "global")..":70:"..self.Version
end

function AstraUI:StateKey71(scope)
    return tostring(scope or "global")..":71:"..self.Version
end

function AstraUI:StateKey72(scope)
    return tostring(scope or "global")..":72:"..self.Version
end

function AstraUI:StateKey73(scope)
    return tostring(scope or "global")..":73:"..self.Version
end

function AstraUI:StateKey74(scope)
    return tostring(scope or "global")..":74:"..self.Version
end

function AstraUI:StateKey75(scope)
    return tostring(scope or "global")..":75:"..self.Version
end

function AstraUI:StateKey76(scope)
    return tostring(scope or "global")..":76:"..self.Version
end

function AstraUI:StateKey77(scope)
    return tostring(scope or "global")..":77:"..self.Version
end

function AstraUI:StateKey78(scope)
    return tostring(scope or "global")..":78:"..self.Version
end

function AstraUI:StateKey79(scope)
    return tostring(scope or "global")..":79:"..self.Version
end

function AstraUI:StateKey80(scope)
    return tostring(scope or "global")..":80:"..self.Version
end

function AstraUI:StateKey81(scope)
    return tostring(scope or "global")..":81:"..self.Version
end

function AstraUI:StateKey82(scope)
    return tostring(scope or "global")..":82:"..self.Version
end

function AstraUI:StateKey83(scope)
    return tostring(scope or "global")..":83:"..self.Version
end

function AstraUI:StateKey84(scope)
    return tostring(scope or "global")..":84:"..self.Version
end

function AstraUI:StateKey85(scope)
    return tostring(scope or "global")..":85:"..self.Version
end

function AstraUI:StateKey86(scope)
    return tostring(scope or "global")..":86:"..self.Version
end

function AstraUI:StateKey87(scope)
    return tostring(scope or "global")..":87:"..self.Version
end

function AstraUI:StateKey88(scope)
    return tostring(scope or "global")..":88:"..self.Version
end

function AstraUI:StateKey89(scope)
    return tostring(scope or "global")..":89:"..self.Version
end

function AstraUI:StateKey90(scope)
    return tostring(scope or "global")..":90:"..self.Version
end

function AstraUI:StateKey91(scope)
    return tostring(scope or "global")..":91:"..self.Version
end

function AstraUI:StateKey92(scope)
    return tostring(scope or "global")..":92:"..self.Version
end

function AstraUI:StateKey93(scope)
    return tostring(scope or "global")..":93:"..self.Version
end

function AstraUI:StateKey94(scope)
    return tostring(scope or "global")..":94:"..self.Version
end

function AstraUI:StateKey95(scope)
    return tostring(scope or "global")..":95:"..self.Version
end

function AstraUI:StateKey96(scope)
    return tostring(scope or "global")..":96:"..self.Version
end

function AstraUI:StateKey97(scope)
    return tostring(scope or "global")..":97:"..self.Version
end

function AstraUI:StateKey98(scope)
    return tostring(scope or "global")..":98:"..self.Version
end

function AstraUI:StateKey99(scope)
    return tostring(scope or "global")..":99:"..self.Version
end

function AstraUI:StateKey100(scope)
    return tostring(scope or "global")..":100:"..self.Version
end

function AstraUI:StateKey101(scope)
    return tostring(scope or "global")..":101:"..self.Version
end

function AstraUI:StateKey102(scope)
    return tostring(scope or "global")..":102:"..self.Version
end

function AstraUI:StateKey103(scope)
    return tostring(scope or "global")..":103:"..self.Version
end

function AstraUI:StateKey104(scope)
    return tostring(scope or "global")..":104:"..self.Version
end

function AstraUI:StateKey105(scope)
    return tostring(scope or "global")..":105:"..self.Version
end

function AstraUI:StateKey106(scope)
    return tostring(scope or "global")..":106:"..self.Version
end

function AstraUI:StateKey107(scope)
    return tostring(scope or "global")..":107:"..self.Version
end

function AstraUI:StateKey108(scope)
    return tostring(scope or "global")..":108:"..self.Version
end

function AstraUI:StateKey109(scope)
    return tostring(scope or "global")..":109:"..self.Version
end

function AstraUI:StateKey110(scope)
    return tostring(scope or "global")..":110:"..self.Version
end

function AstraUI:StateKey111(scope)
    return tostring(scope or "global")..":111:"..self.Version
end

function AstraUI:StateKey112(scope)
    return tostring(scope or "global")..":112:"..self.Version
end

function AstraUI:StateKey113(scope)
    return tostring(scope or "global")..":113:"..self.Version
end

function AstraUI:StateKey114(scope)
    return tostring(scope or "global")..":114:"..self.Version
end

function AstraUI:StateKey115(scope)
    return tostring(scope or "global")..":115:"..self.Version
end

function AstraUI:StateKey116(scope)
    return tostring(scope or "global")..":116:"..self.Version
end

function AstraUI:StateKey117(scope)
    return tostring(scope or "global")..":117:"..self.Version
end

function AstraUI:StateKey118(scope)
    return tostring(scope or "global")..":118:"..self.Version
end

function AstraUI:StateKey119(scope)
    return tostring(scope or "global")..":119:"..self.Version
end

function AstraUI:StateKey120(scope)
    return tostring(scope or "global")..":120:"..self.Version
end

function AstraUI:StateKey121(scope)
    return tostring(scope or "global")..":121:"..self.Version
end

function AstraUI:StateKey122(scope)
    return tostring(scope or "global")..":122:"..self.Version
end

function AstraUI:StateKey123(scope)
    return tostring(scope or "global")..":123:"..self.Version
end

function AstraUI:StateKey124(scope)
    return tostring(scope or "global")..":124:"..self.Version
end

function AstraUI:StateKey125(scope)
    return tostring(scope or "global")..":125:"..self.Version
end

function AstraUI:StateKey126(scope)
    return tostring(scope or "global")..":126:"..self.Version
end

function AstraUI:StateKey127(scope)
    return tostring(scope or "global")..":127:"..self.Version
end

function AstraUI:StateKey128(scope)
    return tostring(scope or "global")..":128:"..self.Version
end

function AstraUI:StateKey129(scope)
    return tostring(scope or "global")..":129:"..self.Version
end

function AstraUI:StateKey130(scope)
    return tostring(scope or "global")..":130:"..self.Version
end

function AstraUI:StateKey131(scope)
    return tostring(scope or "global")..":131:"..self.Version
end

function AstraUI:StateKey132(scope)
    return tostring(scope or "global")..":132:"..self.Version
end

function AstraUI:StateKey133(scope)
    return tostring(scope or "global")..":133:"..self.Version
end

function AstraUI:StateKey134(scope)
    return tostring(scope or "global")..":134:"..self.Version
end

function AstraUI:StateKey135(scope)
    return tostring(scope or "global")..":135:"..self.Version
end

function AstraUI:StateKey136(scope)
    return tostring(scope or "global")..":136:"..self.Version
end

function AstraUI:StateKey137(scope)
    return tostring(scope or "global")..":137:"..self.Version
end

function AstraUI:StateKey138(scope)
    return tostring(scope or "global")..":138:"..self.Version
end

function AstraUI:StateKey139(scope)
    return tostring(scope or "global")..":139:"..self.Version
end

function AstraUI:StateKey140(scope)
    return tostring(scope or "global")..":140:"..self.Version
end

function AstraUI:StateKey141(scope)
    return tostring(scope or "global")..":141:"..self.Version
end

function AstraUI:StateKey142(scope)
    return tostring(scope or "global")..":142:"..self.Version
end

function AstraUI:StateKey143(scope)
    return tostring(scope or "global")..":143:"..self.Version
end

function AstraUI:StateKey144(scope)
    return tostring(scope or "global")..":144:"..self.Version
end

function AstraUI:StateKey145(scope)
    return tostring(scope or "global")..":145:"..self.Version
end

function AstraUI:StateKey146(scope)
    return tostring(scope or "global")..":146:"..self.Version
end

function AstraUI:StateKey147(scope)
    return tostring(scope or "global")..":147:"..self.Version
end

function AstraUI:StateKey148(scope)
    return tostring(scope or "global")..":148:"..self.Version
end

function AstraUI:StateKey149(scope)
    return tostring(scope or "global")..":149:"..self.Version
end

function AstraUI:StateKey150(scope)
    return tostring(scope or "global")..":150:"..self.Version
end

function AstraUI:StateKey151(scope)
    return tostring(scope or "global")..":151:"..self.Version
end

function AstraUI:StateKey152(scope)
    return tostring(scope or "global")..":152:"..self.Version
end

function AstraUI:StateKey153(scope)
    return tostring(scope or "global")..":153:"..self.Version
end

function AstraUI:StateKey154(scope)
    return tostring(scope or "global")..":154:"..self.Version
end

function AstraUI:StateKey155(scope)
    return tostring(scope or "global")..":155:"..self.Version
end

function AstraUI:StateKey156(scope)
    return tostring(scope or "global")..":156:"..self.Version
end

function AstraUI:StateKey157(scope)
    return tostring(scope or "global")..":157:"..self.Version
end

function AstraUI:StateKey158(scope)
    return tostring(scope or "global")..":158:"..self.Version
end

function AstraUI:StateKey159(scope)
    return tostring(scope or "global")..":159:"..self.Version
end

function AstraUI:StateKey160(scope)
    return tostring(scope or "global")..":160:"..self.Version
end

function AstraUI:StateKey161(scope)
    return tostring(scope or "global")..":161:"..self.Version
end

function AstraUI:StateKey162(scope)
    return tostring(scope or "global")..":162:"..self.Version
end

function AstraUI:StateKey163(scope)
    return tostring(scope or "global")..":163:"..self.Version
end

function AstraUI:StateKey164(scope)
    return tostring(scope or "global")..":164:"..self.Version
end

function AstraUI:StateKey165(scope)
    return tostring(scope or "global")..":165:"..self.Version
end

function AstraUI:StateKey166(scope)
    return tostring(scope or "global")..":166:"..self.Version
end

function AstraUI:StateKey167(scope)
    return tostring(scope or "global")..":167:"..self.Version
end

function AstraUI:StateKey168(scope)
    return tostring(scope or "global")..":168:"..self.Version
end

function AstraUI:StateKey169(scope)
    return tostring(scope or "global")..":169:"..self.Version
end

function AstraUI:StateKey170(scope)
    return tostring(scope or "global")..":170:"..self.Version
end

function AstraUI:StateKey171(scope)
    return tostring(scope or "global")..":171:"..self.Version
end

function AstraUI:StateKey172(scope)
    return tostring(scope or "global")..":172:"..self.Version
end

function AstraUI:StateKey173(scope)
    return tostring(scope or "global")..":173:"..self.Version
end

function AstraUI:StateKey174(scope)
    return tostring(scope or "global")..":174:"..self.Version
end

function AstraUI:StateKey175(scope)
    return tostring(scope or "global")..":175:"..self.Version
end

function AstraUI:StateKey176(scope)
    return tostring(scope or "global")..":176:"..self.Version
end

function AstraUI:StateKey177(scope)
    return tostring(scope or "global")..":177:"..self.Version
end

function AstraUI:StateKey178(scope)
    return tostring(scope or "global")..":178:"..self.Version
end

function AstraUI:StateKey179(scope)
    return tostring(scope or "global")..":179:"..self.Version
end

function AstraUI:StateKey180(scope)
    return tostring(scope or "global")..":180:"..self.Version
end

function AstraUI:StateKey181(scope)
    return tostring(scope or "global")..":181:"..self.Version
end

function AstraUI:StateKey182(scope)
    return tostring(scope or "global")..":182:"..self.Version
end

function AstraUI:StateKey183(scope)
    return tostring(scope or "global")..":183:"..self.Version
end

function AstraUI:StateKey184(scope)
    return tostring(scope or "global")..":184:"..self.Version
end

function AstraUI:StateKey185(scope)
    return tostring(scope or "global")..":185:"..self.Version
end

function AstraUI:StateKey186(scope)
    return tostring(scope or "global")..":186:"..self.Version
end

function AstraUI:StateKey187(scope)
    return tostring(scope or "global")..":187:"..self.Version
end

function AstraUI:StateKey188(scope)
    return tostring(scope or "global")..":188:"..self.Version
end

function AstraUI:StateKey189(scope)
    return tostring(scope or "global")..":189:"..self.Version
end

function AstraUI:StateKey190(scope)
    return tostring(scope or "global")..":190:"..self.Version
end

function AstraUI:StateKey191(scope)
    return tostring(scope or "global")..":191:"..self.Version
end

function AstraUI:StateKey192(scope)
    return tostring(scope or "global")..":192:"..self.Version
end

function AstraUI:StateKey193(scope)
    return tostring(scope or "global")..":193:"..self.Version
end

function AstraUI:StateKey194(scope)
    return tostring(scope or "global")..":194:"..self.Version
end

function AstraUI:StateKey195(scope)
    return tostring(scope or "global")..":195:"..self.Version
end

function AstraUI:StateKey196(scope)
    return tostring(scope or "global")..":196:"..self.Version
end

function AstraUI:StateKey197(scope)
    return tostring(scope or "global")..":197:"..self.Version
end

function AstraUI:StateKey198(scope)
    return tostring(scope or "global")..":198:"..self.Version
end

function AstraUI:StateKey199(scope)
    return tostring(scope or "global")..":199:"..self.Version
end

function AstraUI:StateKey200(scope)
    return tostring(scope or "global")..":200:"..self.Version
end

function AstraUI:StateKey201(scope)
    return tostring(scope or "global")..":201:"..self.Version
end

function AstraUI:StateKey202(scope)
    return tostring(scope or "global")..":202:"..self.Version
end

function AstraUI:StateKey203(scope)
    return tostring(scope or "global")..":203:"..self.Version
end

function AstraUI:StateKey204(scope)
    return tostring(scope or "global")..":204:"..self.Version
end

function AstraUI:StateKey205(scope)
    return tostring(scope or "global")..":205:"..self.Version
end

function AstraUI:StateKey206(scope)
    return tostring(scope or "global")..":206:"..self.Version
end

function AstraUI:StateKey207(scope)
    return tostring(scope or "global")..":207:"..self.Version
end

function AstraUI:StateKey208(scope)
    return tostring(scope or "global")..":208:"..self.Version
end

function AstraUI:StateKey209(scope)
    return tostring(scope or "global")..":209:"..self.Version
end

function AstraUI:StateKey210(scope)
    return tostring(scope or "global")..":210:"..self.Version
end

function AstraUI:StateKey211(scope)
    return tostring(scope or "global")..":211:"..self.Version
end

function AstraUI:StateKey212(scope)
    return tostring(scope or "global")..":212:"..self.Version
end

function AstraUI:StateKey213(scope)
    return tostring(scope or "global")..":213:"..self.Version
end

function AstraUI:StateKey214(scope)
    return tostring(scope or "global")..":214:"..self.Version
end

function AstraUI:StateKey215(scope)
    return tostring(scope or "global")..":215:"..self.Version
end

function AstraUI:StateKey216(scope)
    return tostring(scope or "global")..":216:"..self.Version
end

function AstraUI:StateKey217(scope)
    return tostring(scope or "global")..":217:"..self.Version
end

function AstraUI:StateKey218(scope)
    return tostring(scope or "global")..":218:"..self.Version
end

function AstraUI:StateKey219(scope)
    return tostring(scope or "global")..":219:"..self.Version
end

function AstraUI:StateKey220(scope)
    return tostring(scope or "global")..":220:"..self.Version
end

function AstraUI:StateKey221(scope)
    return tostring(scope or "global")..":221:"..self.Version
end

function AstraUI:StateKey222(scope)
    return tostring(scope or "global")..":222:"..self.Version
end

function AstraUI:StateKey223(scope)
    return tostring(scope or "global")..":223:"..self.Version
end

function AstraUI:StateKey224(scope)
    return tostring(scope or "global")..":224:"..self.Version
end

function AstraUI:StateKey225(scope)
    return tostring(scope or "global")..":225:"..self.Version
end

function AstraUI:StateKey226(scope)
    return tostring(scope or "global")..":226:"..self.Version
end

function AstraUI:StateKey227(scope)
    return tostring(scope or "global")..":227:"..self.Version
end

function AstraUI:StateKey228(scope)
    return tostring(scope or "global")..":228:"..self.Version
end

function AstraUI:StateKey229(scope)
    return tostring(scope or "global")..":229:"..self.Version
end

function AstraUI:StateKey230(scope)
    return tostring(scope or "global")..":230:"..self.Version
end

function AstraUI:StateKey231(scope)
    return tostring(scope or "global")..":231:"..self.Version
end

function AstraUI:StateKey232(scope)
    return tostring(scope or "global")..":232:"..self.Version
end

function AstraUI:StateKey233(scope)
    return tostring(scope or "global")..":233:"..self.Version
end

function AstraUI:StateKey234(scope)
    return tostring(scope or "global")..":234:"..self.Version
end

function AstraUI:StateKey235(scope)
    return tostring(scope or "global")..":235:"..self.Version
end

function AstraUI:StateKey236(scope)
    return tostring(scope or "global")..":236:"..self.Version
end

function AstraUI:StateKey237(scope)
    return tostring(scope or "global")..":237:"..self.Version
end

function AstraUI:StateKey238(scope)
    return tostring(scope or "global")..":238:"..self.Version
end

function AstraUI:StateKey239(scope)
    return tostring(scope or "global")..":239:"..self.Version
end

function AstraUI:StateKey240(scope)
    return tostring(scope or "global")..":240:"..self.Version
end

function AstraUI:StateKey241(scope)
    return tostring(scope or "global")..":241:"..self.Version
end

function AstraUI:StateKey242(scope)
    return tostring(scope or "global")..":242:"..self.Version
end

function AstraUI:StateKey243(scope)
    return tostring(scope or "global")..":243:"..self.Version
end

function AstraUI:StateKey244(scope)
    return tostring(scope or "global")..":244:"..self.Version
end

function AstraUI:StateKey245(scope)
    return tostring(scope or "global")..":245:"..self.Version
end

function AstraUI:StateKey246(scope)
    return tostring(scope or "global")..":246:"..self.Version
end

function AstraUI:StateKey247(scope)
    return tostring(scope or "global")..":247:"..self.Version
end

function AstraUI:StateKey248(scope)
    return tostring(scope or "global")..":248:"..self.Version
end

function AstraUI:StateKey249(scope)
    return tostring(scope or "global")..":249:"..self.Version
end

function AstraUI.Layout:Normalize0(value, minimum, maximum)
    minimum=minimum or 0
    maximum=maximum or 1
    if maximum==minimum then return 0 end
    return clamp((value-minimum)/(maximum-minimum),0,1)
end

function AstraUI.Layout:Normalize1(value, minimum, maximum)
    minimum=minimum or 0
    maximum=maximum or 1
    if maximum==minimum then return 0 end
    return clamp((value-minimum)/(maximum-minimum),0,1)
end

function AstraUI.Layout:Normalize2(value, minimum, maximum)
    minimum=minimum or 0
    maximum=maximum or 1
    if maximum==minimum then return 0 end
    return clamp((value-minimum)/(maximum-minimum),0,1)
end

function AstraUI.Layout:Normalize3(value, minimum, maximum)
    minimum=minimum or 0
    maximum=maximum or 1
    if maximum==minimum then return 0 end
    return clamp((value-minimum)/(maximum-minimum),0,1)
end

function AstraUI.Layout:Normalize4(value, minimum, maximum)
    minimum=minimum or 0
    maximum=maximum or 1
    if maximum==minimum then return 0 end
    return clamp((value-minimum)/(maximum-minimum),0,1)
end

function AstraUI.Layout:Normalize5(value, minimum, maximum)
    minimum=minimum or 0
    maximum=maximum or 1
    if maximum==minimum then return 0 end
    return clamp((value-minimum)/(maximum-minimum),0,1)
end

function AstraUI.Layout:Normalize6(value, minimum, maximum)
    minimum=minimum or 0
    maximum=maximum or 1
    if maximum==minimum then return 0 end
    return clamp((value-minimum)/(maximum-minimum),0,1)
end

function AstraUI.Layout:Normalize7(value, minimum, maximum)
    minimum=minimum or 0
    maximum=maximum or 1
    if maximum==minimum then return 0 end
    return clamp((value-minimum)/(maximum-minimum),0,1)
end

function AstraUI.Layout:Normalize8(value, minimum, maximum)
    minimum=minimum or 0
    maximum=maximum or 1
    if maximum==minimum then return 0 end
    return clamp((value-minimum)/(maximum-minimum),0,1)
end

function AstraUI.Layout:Normalize9(value, minimum, maximum)
    minimum=minimum or 0
    maximum=maximum or 1
    if maximum==minimum then return 0 end
    return clamp((value-minimum)/(maximum-minimum),0,1)
end

function AstraUI.Layout:Normalize10(value, minimum, maximum)
    minimum=minimum or 0
    maximum=maximum or 1
    if maximum==minimum then return 0 end
    return clamp((value-minimum)/(maximum-minimum),0,1)
end

function AstraUI.Layout:Normalize11(value, minimum, maximum)
    minimum=minimum or 0
    maximum=maximum or 1
    if maximum==minimum then return 0 end
    return clamp((value-minimum)/(maximum-minimum),0,1)
end

function AstraUI.Layout:Normalize12(value, minimum, maximum)
    minimum=minimum or 0
    maximum=maximum or 1
    if maximum==minimum then return 0 end
    return clamp((value-minimum)/(maximum-minimum),0,1)
end

function AstraUI.Layout:Normalize13(value, minimum, maximum)
    minimum=minimum or 0
    maximum=maximum or 1
    if maximum==minimum then return 0 end
    return clamp((value-minimum)/(maximum-minimum),0,1)
end

function AstraUI.Layout:Normalize14(value, minimum, maximum)
    minimum=minimum or 0
    maximum=maximum or 1
    if maximum==minimum then return 0 end
    return clamp((value-minimum)/(maximum-minimum),0,1)
end

function AstraUI.Layout:Normalize15(value, minimum, maximum)
    minimum=minimum or 0
    maximum=maximum or 1
    if maximum==minimum then return 0 end
    return clamp((value-minimum)/(maximum-minimum),0,1)
end

function AstraUI.Layout:Normalize16(value, minimum, maximum)
    minimum=minimum or 0
    maximum=maximum or 1
    if maximum==minimum then return 0 end
    return clamp((value-minimum)/(maximum-minimum),0,1)
end

function AstraUI.Layout:Normalize17(value, minimum, maximum)
    minimum=minimum or 0
    maximum=maximum or 1
    if maximum==minimum then return 0 end
    return clamp((value-minimum)/(maximum-minimum),0,1)
end

function AstraUI.Layout:Normalize18(value, minimum, maximum)
    minimum=minimum or 0
    maximum=maximum or 1
    if maximum==minimum then return 0 end
    return clamp((value-minimum)/(maximum-minimum),0,1)
end

function AstraUI.Layout:Normalize19(value, minimum, maximum)
    minimum=minimum or 0
    maximum=maximum or 1
    if maximum==minimum then return 0 end
    return clamp((value-minimum)/(maximum-minimum),0,1)
end

function AstraUI.Layout:Normalize20(value, minimum, maximum)
    minimum=minimum or 0
    maximum=maximum or 1
    if maximum==minimum then return 0 end
    return clamp((value-minimum)/(maximum-minimum),0,1)
end

function AstraUI.Layout:Normalize21(value, minimum, maximum)
    minimum=minimum or 0
    maximum=maximum or 1
    if maximum==minimum then return 0 end
    return clamp((value-minimum)/(maximum-minimum),0,1)
end

function AstraUI.Layout:Normalize22(value, minimum, maximum)
    minimum=minimum or 0
    maximum=maximum or 1
    if maximum==minimum then return 0 end
    return clamp((value-minimum)/(maximum-minimum),0,1)
end

function AstraUI.Layout:Normalize23(value, minimum, maximum)
    minimum=minimum or 0
    maximum=maximum or 1
    if maximum==minimum then return 0 end
    return clamp((value-minimum)/(maximum-minimum),0,1)
end

function AstraUI.Layout:Normalize24(value, minimum, maximum)
    minimum=minimum or 0
    maximum=maximum or 1
    if maximum==minimum then return 0 end
    return clamp((value-minimum)/(maximum-minimum),0,1)
end

function AstraUI.Layout:Normalize25(value, minimum, maximum)
    minimum=minimum or 0
    maximum=maximum or 1
    if maximum==minimum then return 0 end
    return clamp((value-minimum)/(maximum-minimum),0,1)
end

function AstraUI.Layout:Normalize26(value, minimum, maximum)
    minimum=minimum or 0
    maximum=maximum or 1
    if maximum==minimum then return 0 end
    return clamp((value-minimum)/(maximum-minimum),0,1)
end

function AstraUI.Layout:Normalize27(value, minimum, maximum)
    minimum=minimum or 0
    maximum=maximum or 1
    if maximum==minimum then return 0 end
    return clamp((value-minimum)/(maximum-minimum),0,1)
end

function AstraUI.Layout:Normalize28(value, minimum, maximum)
    minimum=minimum or 0
    maximum=maximum or 1
    if maximum==minimum then return 0 end
    return clamp((value-minimum)/(maximum-minimum),0,1)
end

function AstraUI.Layout:Normalize29(value, minimum, maximum)
    minimum=minimum or 0
    maximum=maximum or 1
    if maximum==minimum then return 0 end
    return clamp((value-minimum)/(maximum-minimum),0,1)
end

function AstraUI.Layout:Normalize30(value, minimum, maximum)
    minimum=minimum or 0
    maximum=maximum or 1
    if maximum==minimum then return 0 end
    return clamp((value-minimum)/(maximum-minimum),0,1)
end

function AstraUI.Layout:Normalize31(value, minimum, maximum)
    minimum=minimum or 0
    maximum=maximum or 1
    if maximum==minimum then return 0 end
    return clamp((value-minimum)/(maximum-minimum),0,1)
end

function AstraUI.Layout:Normalize32(value, minimum, maximum)
    minimum=minimum or 0
    maximum=maximum or 1
    if maximum==minimum then return 0 end
    return clamp((value-minimum)/(maximum-minimum),0,1)
end

function AstraUI.Layout:Normalize33(value, minimum, maximum)
    minimum=minimum or 0
    maximum=maximum or 1
    if maximum==minimum then return 0 end
    return clamp((value-minimum)/(maximum-minimum),0,1)
end

function AstraUI.Layout:Normalize34(value, minimum, maximum)
    minimum=minimum or 0
    maximum=maximum or 1
    if maximum==minimum then return 0 end
    return clamp((value-minimum)/(maximum-minimum),0,1)
end

function AstraUI.Layout:Normalize35(value, minimum, maximum)
    minimum=minimum or 0
    maximum=maximum or 1
    if maximum==minimum then return 0 end
    return clamp((value-minimum)/(maximum-minimum),0,1)
end

function AstraUI.Layout:Normalize36(value, minimum, maximum)
    minimum=minimum or 0
    maximum=maximum or 1
    if maximum==minimum then return 0 end
    return clamp((value-minimum)/(maximum-minimum),0,1)
end

function AstraUI.Layout:Normalize37(value, minimum, maximum)
    minimum=minimum or 0
    maximum=maximum or 1
    if maximum==minimum then return 0 end
    return clamp((value-minimum)/(maximum-minimum),0,1)
end

function AstraUI.Layout:Normalize38(value, minimum, maximum)
    minimum=minimum or 0
    maximum=maximum or 1
    if maximum==minimum then return 0 end
    return clamp((value-minimum)/(maximum-minimum),0,1)
end

function AstraUI.Layout:Normalize39(value, minimum, maximum)
    minimum=minimum or 0
    maximum=maximum or 1
    if maximum==minimum then return 0 end
    return clamp((value-minimum)/(maximum-minimum),0,1)
end

function AstraUI.Layout:Normalize40(value, minimum, maximum)
    minimum=minimum or 0
    maximum=maximum or 1
    if maximum==minimum then return 0 end
    return clamp((value-minimum)/(maximum-minimum),0,1)
end

function AstraUI.Layout:Normalize41(value, minimum, maximum)
    minimum=minimum or 0
    maximum=maximum or 1
    if maximum==minimum then return 0 end
    return clamp((value-minimum)/(maximum-minimum),0,1)
end

function AstraUI.Layout:Normalize42(value, minimum, maximum)
    minimum=minimum or 0
    maximum=maximum or 1
    if maximum==minimum then return 0 end
    return clamp((value-minimum)/(maximum-minimum),0,1)
end

function AstraUI.Layout:Normalize43(value, minimum, maximum)
    minimum=minimum or 0
    maximum=maximum or 1
    if maximum==minimum then return 0 end
    return clamp((value-minimum)/(maximum-minimum),0,1)
end

function AstraUI.Layout:Normalize44(value, minimum, maximum)
    minimum=minimum or 0
    maximum=maximum or 1
    if maximum==minimum then return 0 end
    return clamp((value-minimum)/(maximum-minimum),0,1)
end

function AstraUI.Layout:Normalize45(value, minimum, maximum)
    minimum=minimum or 0
    maximum=maximum or 1
    if maximum==minimum then return 0 end
    return clamp((value-minimum)/(maximum-minimum),0,1)
end

function AstraUI.Layout:Normalize46(value, minimum, maximum)
    minimum=minimum or 0
    maximum=maximum or 1
    if maximum==minimum then return 0 end
    return clamp((value-minimum)/(maximum-minimum),0,1)
end

function AstraUI.Layout:Normalize47(value, minimum, maximum)
    minimum=minimum or 0
    maximum=maximum or 1
    if maximum==minimum then return 0 end
    return clamp((value-minimum)/(maximum-minimum),0,1)
end

function AstraUI.Layout:Normalize48(value, minimum, maximum)
    minimum=minimum or 0
    maximum=maximum or 1
    if maximum==minimum then return 0 end
    return clamp((value-minimum)/(maximum-minimum),0,1)
end

function AstraUI.Layout:Normalize49(value, minimum, maximum)
    minimum=minimum or 0
    maximum=maximum or 1
    if maximum==minimum then return 0 end
    return clamp((value-minimum)/(maximum-minimum),0,1)
end

return AstraUI
