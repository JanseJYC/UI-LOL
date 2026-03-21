local AdvancedUI = {}

local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local TextService = game:GetService("TextService")
local CoreGui = game:GetService("CoreGui")
local HttpService = game:GetService("HttpService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local StarterGui = game:GetService("StarterGui")
local GuiService = game:GetService("GuiService")
local ContextActionService = game:GetService("ContextActionService")
local Debris = game:GetService("Debris")
local SoundService = game:GetService("SoundService")
local Lighting = game:GetService("Lighting")
local LocalPlayer = Players.LocalPlayer
local Mouse = LocalPlayer:GetMouse()

local IconMap = {}
local function LoadIcons()
    local success, result = pcall(function()
        return game:HttpGet("https://raw.githubusercontent.com/JanseJYC/UI-LOL/refs/heads/main/Icons.txt")
    end)
    if success and result then
        local func = loadstring(result)
        if func then
            IconMap = func()
        end
    end
end

local function GetIcon(name)
    return IconMap[name] or "rbxassetid://3926305904"
end

LoadIcons()

local Utility = {}

Utility.EasingStyles = {
    Linear = Enum.EasingStyle.Linear,
    Quad = Enum.EasingStyle.Quad,
    Cubic = Enum.EasingStyle.Cubic,
    Quart = Enum.EasingStyle.Quart,
    Quint = Enum.EasingStyle.Quint,
    Sine = Enum.EasingStyle.Sine,
    Back = Enum.EasingStyle.Back,
    Bounce = Enum.EasingStyle.Bounce,
    Elastic = Enum.EasingStyle.Elastic,
    Exponential = Enum.EasingStyle.Exponential,
    Circular = Enum.EasingStyle.Circular
}

Utility.EasingDirections = {
    In = Enum.EasingDirection.In,
    Out = Enum.EasingDirection.Out,
    InOut = Enum.EasingDirection.InOut
}

Utility.Colors = {
    Black = Color3.fromRGB(0, 0, 0),
    White = Color3.fromRGB(255, 255, 255),
    Red = Color3.fromRGB(255, 0, 0),
    Green = Color3.fromRGB(0, 255, 0),
    Blue = Color3.fromRGB(0, 0, 255),
    Yellow = Color3.fromRGB(255, 255, 0),
    Cyan = Color3.fromRGB(0, 255, 255),
    Magenta = Color3.fromRGB(255, 0, 255),
    Orange = Color3.fromRGB(255, 165, 0),
    Purple = Color3.fromRGB(128, 0, 128),
    Pink = Color3.fromRGB(255, 192, 203),
    Gray = Color3.fromRGB(128, 128, 128),
    DarkGray = Color3.fromRGB(64, 64, 64),
    LightGray = Color3.fromRGB(192, 192, 192),
    Transparent = Color3.fromRGB(0, 0, 0)
}

Utility.GenerateUUID = function()
    local template = "xxxxxxxx-xxxx-4xxx-yxxx-xxxxxxxxxxxx"
    return string.gsub(template, "[xy]", function(c)
        local v = (c == "x") and math.random(0, 0xf) or math.random(8, 0xb)
        return string.format("%x", v)
    end)
end

Utility.DeepCopy = function(original)
    local copy = {}
    for k, v in pairs(original) do
        if type(v) == "table" then
            v = Utility.DeepCopy(v)
        end
        copy[k] = v
    end
    return copy
end

Utility.Clamp = function(value, min, max)
    return math.max(min, math.min(max, value))
end

Utility.Lerp = function(a, b, t)
    return a + (b - a) * t
end

Utility.LerpColor = function(colorA, colorB, t)
    return Color3.new(
        colorA.R + (colorB.R - colorA.R) * t,
        colorA.G + (colorB.G - colorA.G) * t,
        colorA.B + (colorB.B - colorA.B) * t
    )
end

Utility.RGBtoHSV = function(color)
    local r, g, b = color.R, color.G, color.B
    local max = math.max(r, g, b)
    local min = math.min(r, g, b)
    local h, s, v
    v = max
    local d = max - min
    s = max == 0 and 0 or d / max
    if max == min then
        h = 0
    elseif max == r then
        h = (g - b) / d + (g < b and 6 or 0)
    elseif max == g then
        h = (b - r) / d + 2
    else
        h = (r - g) / d + 4
    end
    h = h / 6
    return h, s, v
end

Utility.HSVtoRGB = function(h, s, v)
    local r, g, b
    local i = math.floor(h * 6)
    local f = h * 6 - i
    local p = v * (1 - s)
    local q = v * (1 - f * s)
    local t = v * (1 - (1 - f) * s)
    i = i % 6
    if i == 0 then r, g, b = v, t, p
    elseif i == 1 then r, g, b = q, v, p
    elseif i == 2 then r, g, b = p, v, t
    elseif i == 3 then r, g, b = p, q, v
    elseif i == 4 then r, g, b = t, p, v
    elseif i == 5 then r, g, b = v, p, q
    end
    return Color3.new(r, g, b)
end

Utility.GetTextBounds = function(text, font, size)
    return TextService:GetTextSize(text, size, font, Vector2.new(9999, 9999))
end

Utility.Create = function(className, properties)
    local instance = Instance.new(className)
    for prop, value in pairs(properties or {}) do
        if prop ~= "Parent" then
            instance[prop] = value
        end
    end
    if properties and properties.Parent then
        instance.Parent = properties.Parent
    end
    return instance
end

Utility.Connect = function(signal, callback)
    local connection = signal:Connect(callback)
    return connection
end

Utility.Disconnect = function(connection)
    if connection then
        connection:Disconnect()
    end
end

Utility.Destroy = function(instance)
    if instance then
        instance:Destroy()
    end
end

Utility.Tween = function(instance, tweenInfo, properties, callback)
    local tween = TweenService:Create(instance, tweenInfo, properties)
    if callback then
        tween.Completed:Connect(callback)
    end
    tween:Play()
    return tween
end

Utility.Fade = function(instance, targetTransparency, duration)
    duration = duration or 0.3
    local tweenInfo = TweenInfo.new(duration, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
    if instance:IsA("GuiObject") then
        return Utility.Tween(instance, tweenInfo, {BackgroundTransparency = targetTransparency})
    elseif instance:IsA("TextLabel") or instance:IsA("TextButton") or instance:IsA("TextBox") then
        return Utility.Tween(instance, tweenInfo, {TextTransparency = targetTransparency})
    elseif instance:IsA("ImageLabel") or instance:IsA("ImageButton") then
        return Utility.Tween(instance, tweenInfo, {ImageTransparency = targetTransparency})
    end
end

Utility.Scale = function(instance, targetSize, duration, easingStyle, easingDirection)
    duration = duration or 0.3
    easingStyle = easingStyle or Enum.EasingStyle.Back
    easingDirection = easingDirection or Enum.EasingDirection.Out
    local tweenInfo = TweenInfo.new(duration, easingStyle, easingDirection)
    return Utility.Tween(instance, tweenInfo, {Size = targetSize})
end

Utility.Shake = function(instance, intensity, duration)
    intensity = intensity or 5
    duration = duration or 0.5
    local originalPosition = instance.Position
    local startTime = tick()
    local connection
    connection = RunService.RenderStepped:Connect(function()
        local elapsed = tick() - startTime
        if elapsed >= duration then
            instance.Position = originalPosition
            connection:Disconnect()
            return
        end
        local decay = 1 - (elapsed / duration)
        local offsetX = (math.random() - 0.5) * 2 * intensity * decay
        local offsetY = (math.random() - 0.5) * 2 * intensity * decay
        instance.Position = UDim2.new(
            originalPosition.X.Scale, originalPosition.X.Offset + offsetX,
            originalPosition.Y.Scale, originalPosition.Y.Offset + offsetY
        )
    end)
    return connection
end

Utility.Pulse = function(instance, minScale, maxScale, duration)
    minScale = minScale or 0.95
    maxScale = maxScale or 1.05
    duration = duration or 1
    local originalSize = instance.Size
    local expanding = true
    local connection
    connection = RunService.RenderStepped:Connect(function(dt)
        if not instance or not instance.Parent then
            connection:Disconnect()
            return
        end
        local scale = expanding and maxScale or minScale
        local targetSize = UDim2.new(
            originalSize.X.Scale * scale, originalSize.X.Offset * scale,
            originalSize.Y.Scale * scale, originalSize.Y.Offset * scale
        )
        instance.Size = instance.Size:Lerp(targetSize, dt * 5)
        if math.abs(instance.Size.X.Offset - targetSize.X.Offset) < 1 then
            expanding = not expanding
        end
    end)
    return connection
end

Utility.Drag = function(instance, dragHandle)
    dragHandle = dragHandle or instance
    local dragging = false
    local dragStart, startPos

    local inputBegan = dragHandle.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or 
           input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragStart = input.Position
            startPos = instance.Position
        end
    end)

    local inputChanged = UserInputService.InputChanged:Connect(function(input)
        if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or 
                        input.UserInputType == Enum.UserInputType.Touch) then
            local delta = input.Position - dragStart
            instance.Position = UDim2.new(
                startPos.X.Scale, startPos.X.Offset + delta.X,
                startPos.Y.Scale, startPos.Y.Offset + delta.Y
            )
        end
    end)

    local inputEnded = UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or 
           input.UserInputType == Enum.UserInputType.Touch then
            dragging = false
        end
    end)

    return {inputBegan, inputChanged, inputEnded}
end

Utility.ObserveProperty = function(instance, property, callback)
    local oldValue = instance[property]
    local connection = RunService.Heartbeat:Connect(function()
        local newValue = instance[property]
        if newValue ~= oldValue then
            callback(newValue, oldValue)
            oldValue = newValue
        end
    end)
    return connection
end

Utility.Debounce = function(func, delay)
    delay = delay or 0.1
    local running = false
    return function(...)
        if not running then
            running = true
            func(...)
            task.delay(delay, function()
                running = false
            end)
        end
    end
end

Utility.Throttle = function(func, limit)
    limit = limit or 1
    local lastCall = 0
    return function(...)
        local now = tick()
        if now - lastCall >= limit then
            lastCall = now
            func(...)
        end
    end
end

Utility.RandomString = function(length)
    length = length or 10
    local chars = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
    local result = ""
    for i = 1, length do
        local randomIndex = math.random(1, #chars)
        result = result .. chars:sub(randomIndex, randomIndex)
    end
    return result
end

Utility.FormatNumber = function(num, decimals)
    decimals = decimals or 0
    return string.format("%." .. decimals .. "f", num)
end

Utility.TruncateString = function(str, maxLength, suffix)
    suffix = suffix or "..."
    if #str > maxLength then
        return str:sub(1, maxLength - #suffix) .. suffix
    end
    return str
end

Utility.ParseColor = function(colorString)
    if type(colorString) == "string" then
        if colorString:match("^#%x%x%x%x%x%x$") then
            local r = tonumber(colorString:sub(2, 3), 16) / 255
            local g = tonumber(colorString:sub(4, 5), 16) / 255
            local b = tonumber(colorString:sub(6, 7), 16) / 255
            return Color3.new(r, g, b)
        elseif colorString:match("^#%x%x%x$") then
            local r = tonumber(colorString:sub(2, 2), 16) / 15
            local g = tonumber(colorString:sub(3, 3), 16) / 15
            local b = tonumber(colorString:sub(4, 4), 16) / 15
            return Color3.new(r, g, b)
        end
    end
    return colorString
end

Utility.CreateShadow = function(parent, offset, transparency, size)
    offset = offset or 4
    transparency = transparency or 0.6
    size = size or 10

    local shadow = Utility.Create("ImageLabel", {
        Name = "Shadow",
        AnchorPoint = Vector2.new(0.5, 0.5),
        Position = UDim2.new(0.5, 0, 0.5, offset),
        Size = UDim2.new(1, size, 1, size),
        BackgroundTransparency = 1,
        Image = "rbxassetid://1316045217",
        ImageColor3 = Color3.fromRGB(0, 0, 0),
        ImageTransparency = transparency,
        ScaleType = Enum.ScaleType.Slice,
        SliceCenter = Rect.new(10, 10, 118, 118),
        ZIndex = -1,
        Parent = parent
    })

    return shadow
end

Utility.CreateGradient = function(parent, colorSequence, rotation)
    rotation = rotation or 45
    local gradient = Utility.Create("UIGradient", {
        Color = colorSequence or ColorSequence.new({
            ColorSequenceKeypoint.new(0, Color3.fromRGB(99, 102, 241)),
            ColorSequenceKeypoint.new(1, Color3.fromRGB(139, 92, 246))
        }),
        Rotation = rotation,
        Parent = parent
    })
    return gradient
end

Utility.CreateCorner = function(parent, radius)
    radius = radius or 8
    local corner = Utility.Create("UICorner", {
        CornerRadius = UDim.new(0, radius),
        Parent = parent
    })
    return corner
end

Utility.CreateStroke = function(parent, color, thickness, transparency)
    thickness = thickness or 1
    transparency = transparency or 0.5
    local stroke = Utility.Create("UIStroke", {
        Color = color or Color3.fromRGB(99, 102, 241),
        Thickness = thickness,
        Transparency = transparency,
        Parent = parent
    })
    return stroke
end

Utility.CreateHighlight = function(parent, color, thickness, transparency)
    color = color or Color3.fromRGB(255, 255, 255)
    thickness = thickness or 2
    transparency = transparency or 0.3
    local stroke = Utility.Create("UIStroke", {
        Name = "Highlight",
        Color = color,
        Thickness = thickness,
        Transparency = transparency,
        Parent = parent
    })
    local gradient = Utility.Create("UIGradient", {
        Color = ColorSequence.new({
            ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 255, 255)),
            ColorSequenceKeypoint.new(0.5, color),
            ColorSequenceKeypoint.new(1, Color3.fromRGB(255, 255, 255))
        }),
        Rotation = 90,
        Parent = stroke
    })
    return stroke
end

local Animation = {}

Animation.Spring = {}
Animation.Spring.__index = Animation.Spring

function Animation.Spring.new(mass, tension, friction)
    local self = setmetatable({}, Animation.Spring)
    self.mass = mass or 1
    self.tension = tension or 300
    self.friction = friction or 30
    self.position = 0
    self.velocity = 0
    self.target = 0
    return self
end

function Animation.Spring:Update(dt)
    local displacement = self.position - self.target
    local springForce = -self.tension * displacement
    local dampingForce = -self.friction * self.velocity
    local acceleration = (springForce + dampingForce) / self.mass
    self.velocity = self.velocity + acceleration * dt
    self.position = self.position + self.velocity * dt
    return self.position
end

function Animation.Spring:SetTarget(target)
    self.target = target
end

function Animation.Spring:IsSettled(threshold)
    threshold = threshold or 0.01
    return math.abs(self.position - self.target) < threshold and math.abs(self.velocity) < threshold
end

Animation.TweenSequence = {}
Animation.TweenSequence.__index = Animation.TweenSequence

function Animation.TweenSequence.new()
    local self = setmetatable({}, Animation.TweenSequence)
    self.tweens = {}
    self.currentIndex = 0
    self.playing = false
    self.onComplete = nil
    return self
end

function Animation.TweenSequence:Add(tweenInfo, properties, instance)
    table.insert(self.tweens, {
        tweenInfo = tweenInfo,
        properties = properties,
        instance = instance
    })
    return self
end

function Animation.TweenSequence:Play(onComplete)
    if self.playing then return end
    self.playing = true
    self.currentIndex = 0
    self.onComplete = onComplete
    self:PlayNext()
end

function Animation.TweenSequence:PlayNext()
    self.currentIndex = self.currentIndex + 1
    if self.currentIndex > #self.tweens then
        self.playing = false
        if self.onComplete then
            self.onComplete()
        end
        return
    end
    local tweenData = self.tweens[self.currentIndex]
    local tween = TweenService:Create(tweenData.instance, tweenData.tweenInfo, tweenData.properties)
    tween.Completed:Connect(function()
        self:PlayNext()
    end)
    tween:Play()
end

function Animation.TweenSequence:Stop()
    self.playing = false
    self.currentIndex = 0
end

Animation.ParallelTweens = {}
Animation.ParallelTweens.__index = Animation.ParallelTweens

function Animation.ParallelTweens.new()
    local self = setmetatable({}, Animation.ParallelTweens)
    self.tweens = {}
    return self
end

function Animation.ParallelTweens:Add(tweenInfo, properties, instance)
    table.insert(self.tweens, {
        tweenInfo = tweenInfo,
        properties = properties,
        instance = instance
    })
    return self
end

function Animation.ParallelTweens:Play(callback)
    local completedCount = 0
    local totalCount = #self.tweens
    if totalCount == 0 then
        if callback then callback() end
        return
    end
    for _, tweenData in ipairs(self.tweens) do
        local tween = TweenService:Create(tweenData.instance, tweenData.tweenInfo, tweenData.properties)
        tween.Completed:Connect(function()
            completedCount = completedCount + 1
            if completedCount == totalCount and callback then
                callback()
            end
        end)
        tween:Play()
    end
end

Animation.Controller = {}
Animation.Controller.__index = Animation.Controller

function Animation.Controller.new()
    local self = setmetatable({}, Animation.Controller)
    self.animations = {}
    self.running = false
    return self
end

function Animation.Controller:AddAnimation(name, animation)
    self.animations[name] = animation
end

function Animation.Controller:Play(name, ...)
    if self.animations[name] then
        self.animations[name]:Play(...)
    end
end

function Animation.Controller:Stop(name)
    if self.animations[name] then
        self.animations[name]:Stop()
    end
end

local ThemeManager = {}

ThemeManager.Themes = {
    Default = {
        Primary = Color3.fromRGB(99, 102, 241),
        Secondary = Color3.fromRGB(139, 92, 246),
        Background = Color3.fromRGB(0, 0, 0),
        Surface = Color3.fromRGB(20, 20, 20),
        Error = Color3.fromRGB(239, 68, 68),
        Warning = Color3.fromRGB(245, 158, 11),
        Success = Color3.fromRGB(34, 197, 94),
        Info = Color3.fromRGB(59, 130, 246),
        TextPrimary = Color3.fromRGB(255, 255, 255),
        TextSecondary = Color3.fromRGB(156, 163, 175),
        TextDisabled = Color3.fromRGB(107, 114, 128),
        Border = Color3.fromRGB(75, 85, 99),
        Divider = Color3.fromRGB(55, 65, 81),
        Hover = Color3.fromRGB(55, 65, 81),
        Pressed = Color3.fromRGB(75, 85, 99),
        Shadow = Color3.fromRGB(0, 0, 0),
        Accent = Color3.fromRGB(99, 102, 241),
        Highlight = Color3.fromRGB(255, 255, 255)
    },
    Dark = {
        Primary = Color3.fromRGB(139, 92, 246),
        Secondary = Color3.fromRGB(124, 58, 237),
        Background = Color3.fromRGB(0, 0, 0),
        Surface = Color3.fromRGB(17, 24, 39),
        Error = Color3.fromRGB(248, 113, 113),
        Warning = Color3.fromRGB(251, 191, 36),
        Success = Color3.fromRGB(52, 211, 153),
        Info = Color3.fromRGB(96, 165, 250),
        TextPrimary = Color3.fromRGB(255, 255, 255),
        TextSecondary = Color3.fromRGB(156, 163, 175),
        TextDisabled = Color3.fromRGB(75, 85, 99),
        Border = Color3.fromRGB(55, 65, 81),
        Divider = Color3.fromRGB(31, 41, 55),
        Hover = Color3.fromRGB(55, 65, 81),
        Pressed = Color3.fromRGB(75, 85, 99),
        Shadow = Color3.fromRGB(0, 0, 0),
        Accent = Color3.fromRGB(139, 92, 246),
        Highlight = Color3.fromRGB(255, 255, 255)
    },
    Light = {
        Primary = Color3.fromRGB(79, 70, 229),
        Secondary = Color3.fromRGB(147, 51, 234),
        Background = Color3.fromRGB(255, 255, 255),
        Surface = Color3.fromRGB(243, 244, 246),
        Error = Color3.fromRGB(220, 38, 38),
        Warning = Color3.fromRGB(217, 119, 6),
        Success = Color3.fromRGB(22, 163, 74),
        Info = Color3.fromRGB(37, 99, 235),
        TextPrimary = Color3.fromRGB(0, 0, 0),
        TextSecondary = Color3.fromRGB(75, 85, 99),
        TextDisabled = Color3.fromRGB(156, 163, 175),
        Border = Color3.fromRGB(209, 213, 219),
        Divider = Color3.fromRGB(229, 231, 235),
        Hover = Color3.fromRGB(243, 244, 246),
        Pressed = Color3.fromRGB(229, 231, 235),
        Shadow = Color3.fromRGB(0, 0, 0),
        Accent = Color3.fromRGB(79, 70, 229),
        Highlight = Color3.fromRGB(0, 0, 0)
    },
    Midnight = {
        Primary = Color3.fromRGB(59, 130, 246),
        Secondary = Color3.fromRGB(16, 185, 129),
        Background = Color3.fromRGB(0, 0, 0),
        Surface = Color3.fromRGB(15, 23, 42),
        Error = Color3.fromRGB(244, 63, 94),
        Warning = Color3.fromRGB(251, 146, 60),
        Success = Color3.fromRGB(34, 197, 94),
        Info = Color3.fromRGB(56, 189, 248),
        TextPrimary = Color3.fromRGB(255, 255, 255),
        TextSecondary = Color3.fromRGB(148, 163, 184),
        TextDisabled = Color3.fromRGB(100, 116, 139),
        Border = Color3.fromRGB(51, 65, 85),
        Divider = Color3.fromRGB(30, 41, 59),
        Hover = Color3.fromRGB(51, 65, 85),
        Pressed = Color3.fromRGB(71, 85, 105),
        Shadow = Color3.fromRGB(2, 6, 23),
        Accent = Color3.fromRGB(59, 130, 246),
        Highlight = Color3.fromRGB(255, 255, 255)
    },
    Sunset = {
        Primary = Color3.fromRGB(249, 115, 22),
        Secondary = Color3.fromRGB(236, 72, 153),
        Background = Color3.fromRGB(0, 0, 0),
        Surface = Color3.fromRGB(28, 25, 23),
        Error = Color3.fromRGB(239, 68, 68),
        Warning = Color3.fromRGB(245, 158, 11),
        Success = Color3.fromRGB(16, 185, 129),
        Info = Color3.fromRGB(6, 182, 212),
        TextPrimary = Color3.fromRGB(255, 255, 255),
        TextSecondary = Color3.fromRGB(168, 162, 158),
        TextDisabled = Color3.fromRGB(120, 113, 108),
        Border = Color3.fromRGB(68, 64, 60),
        Divider = Color3.fromRGB(41, 37, 36),
        Hover = Color3.fromRGB(68, 64, 60),
        Pressed = Color3.fromRGB(87, 83, 78),
        Shadow = Color3.fromRGB(12, 10, 9),
        Accent = Color3.fromRGB(249, 115, 22),
        Highlight = Color3.fromRGB(255, 255, 255)
    },
    Ocean = {
        Primary = Color3.fromRGB(14, 165, 233),
        Secondary = Color3.fromRGB(99, 102, 241),
        Background = Color3.fromRGB(0, 0, 0),
        Surface = Color3.fromRGB(12, 20, 30),
        Error = Color3.fromRGB(248, 113, 113),
        Warning = Color3.fromRGB(251, 191, 36),
        Success = Color3.fromRGB(52, 211, 153),
        Info = Color3.fromRGB(56, 189, 248),
        TextPrimary = Color3.fromRGB(255, 255, 255),
        TextSecondary = Color3.fromRGB(135, 206, 235),
        TextDisabled = Color3.fromRGB(100, 116, 139),
        Border = Color3.fromRGB(30, 58, 80),
        Divider = Color3.fromRGB(20, 35, 50),
        Hover = Color3.fromRGB(30, 58, 80),
        Pressed = Color3.fromRGB(40, 78, 100),
        Shadow = Color3.fromRGB(5, 10, 15),
        Accent = Color3.fromRGB(14, 165, 233),
        Highlight = Color3.fromRGB(255, 255, 255)
    },
    Forest = {
        Primary = Color3.fromRGB(34, 197, 94),
        Secondary = Color3.fromRGB(16, 185, 129),
        Background = Color3.fromRGB(0, 0, 0),
        Surface = Color3.fromRGB(20, 30, 20),
        Error = Color3.fromRGB(248, 113, 113),
        Warning = Color3.fromRGB(251, 191, 36),
        Success = Color3.fromRGB(74, 222, 128),
        Info = Color3.fromRGB(56, 189, 248),
        TextPrimary = Color3.fromRGB(255, 255, 255),
        TextSecondary = Color3.fromRGB(134, 239, 172),
        TextDisabled = Color3.fromRGB(100, 130, 100),
        Border = Color3.fromRGB(40, 70, 40),
        Divider = Color3.fromRGB(30, 45, 30),
        Hover = Color3.fromRGB(40, 70, 40),
        Pressed = Color3.fromRGB(50, 90, 50),
        Shadow = Color3.fromRGB(10, 20, 10),
        Accent = Color3.fromRGB(34, 197, 94),
        Highlight = Color3.fromRGB(255, 255, 255)
    },
    Cyberpunk = {
        Primary = Color3.fromRGB(255, 0, 255),
        Secondary = Color3.fromRGB(0, 255, 255),
        Background = Color3.fromRGB(0, 0, 0),
        Surface = Color3.fromRGB(10, 0, 20),
        Error = Color3.fromRGB(255, 0, 80),
        Warning = Color3.fromRGB(255, 200, 0),
        Success = Color3.fromRGB(0, 255, 100),
        Info = Color3.fromRGB(0, 150, 255),
        TextPrimary = Color3.fromRGB(255, 255, 255),
        TextSecondary = Color3.fromRGB(200, 200, 255),
        TextDisabled = Color3.fromRGB(100, 100, 150),
        Border = Color3.fromRGB(50, 0, 100),
        Divider = Color3.fromRGB(30, 0, 60),
        Hover = Color3.fromRGB(50, 0, 100),
        Pressed = Color3.fromRGB(70, 0, 140),
        Shadow = Color3.fromRGB(255, 0, 255),
        Accent = Color3.fromRGB(255, 0, 255),
        Highlight = Color3.fromRGB(255, 255, 255)
    },
    Crimson = {
        Primary = Color3.fromRGB(220, 38, 38),
        Secondary = Color3.fromRGB(185, 28, 28),
        Background = Color3.fromRGB(0, 0, 0),
        Surface = Color3.fromRGB(20, 0, 0),
        Error = Color3.fromRGB(239, 68, 68),
        Warning = Color3.fromRGB(245, 158, 11),
        Success = Color3.fromRGB(34, 197, 94),
        Info = Color3.fromRGB(59, 130, 246),
        TextPrimary = Color3.fromRGB(255, 255, 255),
        TextSecondary = Color3.fromRGB(254, 202, 202),
        TextDisabled = Color3.fromRGB(153, 27, 27),
        Border = Color3.fromRGB(100, 0, 0),
        Divider = Color3.fromRGB(60, 0, 0),
        Hover = Color3.fromRGB(80, 0, 0),
        Pressed = Color3.fromRGB(100, 0, 0),
        Shadow = Color3.fromRGB(50, 0, 0),
        Accent = Color3.fromRGB(220, 38, 38),
        Highlight = Color3.fromRGB(255, 255, 255)
    },
    Golden = {
        Primary = Color3.fromRGB(234, 179, 8),
        Secondary = Color3.fromRGB(202, 138, 4),
        Background = Color3.fromRGB(0, 0, 0),
        Surface = Color3.fromRGB(20, 15, 0),
        Error = Color3.fromRGB(239, 68, 68),
        Warning = Color3.fromRGB(245, 158, 11),
        Success = Color3.fromRGB(34, 197, 94),
        Info = Color3.fromRGB(59, 130, 246),
        TextPrimary = Color3.fromRGB(255, 255, 255),
        TextSecondary = Color3.fromRGB(254, 240, 138),
        TextDisabled = Color3.fromRGB(161, 98, 7),
        Border = Color3.fromRGB(100, 80, 0),
        Divider = Color3.fromRGB(60, 50, 0),
        Hover = Color3.fromRGB(80, 60, 0),
        Pressed = Color3.fromRGB(100, 80, 0),
        Shadow = Color3.fromRGB(50, 40, 0),
        Accent = Color3.fromRGB(234, 179, 8),
        Highlight = Color3.fromRGB(255, 255, 255)
    }
}

ThemeManager.CurrentTheme = ThemeManager.Themes.Default
ThemeManager.ThemeChanged = Instance.new("BindableEvent")
ThemeManager.RegisteredInstances = {}

ThemeManager.SetTheme = function(themeName)
    if ThemeManager.Themes[themeName] then
        ThemeManager.CurrentTheme = ThemeManager.Themes[themeName]
        ThemeManager.ThemeChanged:Fire(ThemeManager.CurrentTheme)

        for instance, colorMap in pairs(ThemeManager.RegisteredInstances) do
            if instance and instance.Parent then
                for property, colorKey in pairs(colorMap) do
                    if ThemeManager.CurrentTheme[colorKey] then
                        instance[property] = ThemeManager.CurrentTheme[colorKey]
                    end
                end
            end
        end
    end
end

ThemeManager.GetTheme = function()
    return ThemeManager.CurrentTheme
end

ThemeManager.CreateTheme = function(name, colors)
    ThemeManager.Themes[name] = colors
end

ThemeManager.RegisterInstance = function(instance, property, colorKey)
    if not ThemeManager.RegisteredInstances[instance] then
        ThemeManager.RegisteredInstances[instance] = {}
    end
    ThemeManager.RegisteredInstances[instance][property] = colorKey

    if ThemeManager.CurrentTheme[colorKey] then
        instance[property] = ThemeManager.CurrentTheme[colorKey]
    end
end

ThemeManager.UnregisterInstance = function(instance)
    ThemeManager.RegisteredInstances[instance] = nil
end

ThemeManager.ApplyToInstance = function(instance, colorKey, property)
    property = property or "BackgroundColor3"
    local theme = ThemeManager.CurrentTheme
    if theme[colorKey] then
        instance[property] = theme[colorKey]
    end
end

local EventBus = {}

EventBus.Events = {}
EventBus.GlobalListeners = {}

EventBus.Subscribe = function(eventName, callback)
    if not EventBus.Events[eventName] then
        EventBus.Events[eventName] = {}
    end
    table.insert(EventBus.Events[eventName], callback)

    return {
        Unsubscribe = function()
            for i, cb in ipairs(EventBus.Events[eventName]) do
                if cb == callback then
                    table.remove(EventBus.Events[eventName], i)
                    break
                end
            end
        end,
        Pause = function()
            callback._paused = true
        end,
        Resume = function()
            callback._paused = false
        end
    }
end

EventBus.SubscribeOnce = function(eventName, callback)
    local subscription
    subscription = EventBus.Subscribe(eventName, function(...)
        subscription.Unsubscribe()
        callback(...)
    end)
    return subscription
end

EventBus.Publish = function(eventName, ...)
    if EventBus.Events[eventName] then
        for _, callback in ipairs(EventBus.Events[eventName]) do
            if not callback._paused then
                task.spawn(callback, ...)
            end
        end
    end

    for _, listener in ipairs(EventBus.GlobalListeners) do
        task.spawn(listener, eventName, ...)
    end
end

EventBus.SubscribeGlobal = function(callback)
    table.insert(EventBus.GlobalListeners, callback)
    return {
        Unsubscribe = function()
            for i, cb in ipairs(EventBus.GlobalListeners) do
                if cb == callback then
                    table.remove(EventBus.GlobalListeners, i)
                    break
                end
            end
        end
    }
end

EventBus.Clear = function(eventName)
    if eventName then
        EventBus.Events[eventName] = nil
    else
        EventBus.Events = {}
        EventBus.GlobalListeners = {}
    end
end

EventBus.GetEventNames = function()
    local names = {}
    for name, _ in pairs(EventBus.Events) do
        table.insert(names, name)
    end
    return names
end

local StateManager = {}

StateManager.States = {}
StateManager.StateChanged = Instance.new("BindableEvent")
StateManager.GlobalListeners = {}

StateManager.CreateState = function(key, initialValue, options)
    options = options or {}
    StateManager.States[key] = {
        value = initialValue,
        listeners = {},
        validator = options.validator,
        persist = options.persist or false,
        history = options.history and {initialValue} or nil,
        historyIndex = options.history and 1 or nil
    }

    local stateAPI = {}

    stateAPI.Get = function()
        return StateManager.States[key].value
    end

    stateAPI.Set = function(newValue)
        local state = StateManager.States[key]

        if state.validator and not state.validator(newValue) then
            return false
        end

        local oldValue = state.value
        state.value = newValue

        if state.history then
            table.insert(state.history, newValue)
            state.historyIndex = #state.history
        end

        for _, listener in ipairs(state.listeners) do
            listener(newValue, oldValue)
        end

        StateManager.StateChanged:Fire(key, newValue, oldValue)

        for _, globalListener in ipairs(StateManager.GlobalListeners) do
            globalListener(key, newValue, oldValue)
        end

        return true
    end

    stateAPI.Subscribe = function(callback)
        table.insert(state.listeners, callback)
        return {
            Unsubscribe = function()
                for i, cb in ipairs(state.listeners) do
                    if cb == callback then
                        table.remove(state.listeners, i)
                        break
                    end
                end
            end
        }
    end

    stateAPI.Undo = function()
        if state.history and state.historyIndex > 1 then
            state.historyIndex = state.historyIndex - 1
            state.value = state.history[state.historyIndex]
            return state.value
        end
        return nil
    end

    stateAPI.Redo = function()
        if state.history and state.historyIndex < #state.history then
            state.historyIndex = state.historyIndex + 1
            state.value = state.history[state.historyIndex]
            return state.value
        end
        return nil
    end

    stateAPI.GetHistory = function()
        return state.history
    end

    stateAPI.Reset = function()
        stateAPI.Set(initialValue)
    end

    return stateAPI
end

StateManager.GetState = function(key)
    return StateManager.States[key] and StateManager.States[key].value
end

StateManager.SetState = function(key, value)
    if StateManager.States[key] then
        local state = StateManager.States[key]

        if state.validator and not state.validator(value) then
            return false
        end

        local oldValue = state.value
        state.value = value

        for _, listener in ipairs(state.listeners) do
            listener(value, oldValue)
        end

        StateManager.StateChanged:Fire(key, value, oldValue)
        return true
    end
    return false
end

StateManager.SubscribeGlobal = function(callback)
    table.insert(StateManager.GlobalListeners, callback)
    return {
        Unsubscribe = function()
            for i, cb in ipairs(StateManager.GlobalListeners) do
                if cb == callback then
                    table.remove(StateManager.GlobalListeners, i)
                    break
                end
            end
        end
    }
end

StateManager.GetAllStateKeys = function()
    local keys = {}
    for key, _ in pairs(StateManager.States) do
        table.insert(keys, key)
    end
    return keys
end

StateManager.Clear = function()
    StateManager.States = {}
end

local ComponentRegistry = {}

ComponentRegistry.Components = {}
ComponentRegistry.ComponentFactories = {}

ComponentRegistry.Register = function(name, component)
    ComponentRegistry.Components[name] = component
end

ComponentRegistry.RegisterFactory = function(name, factory)
    ComponentRegistry.ComponentFactories[name] = factory
end

ComponentRegistry.Get = function(name)
    return ComponentRegistry.Components[name]
end

ComponentRegistry.Create = function(name, props)
    local factory = ComponentRegistry.ComponentFactories[name]
    if factory then
        return factory(props)
    end
    return nil
end

ComponentRegistry.GetAllComponentNames = function()
    local names = {}
    for name, _ in pairs(ComponentRegistry.Components) do
        table.insert(names, name)
    end
    return names
end

ComponentRegistry.Unregister = function(name)
    ComponentRegistry.Components[name] = nil
    ComponentRegistry.ComponentFactories[name] = nil
end

ComponentRegistry.Clear = function()
    ComponentRegistry.Components = {}
    ComponentRegistry.ComponentFactories = {}
end

local WatermarkSystem = {}

WatermarkSystem.ActiveWatermarks = {}

WatermarkSystem.Create = function(config)
    config = config or {}
    local watermark = {}
    local id = Utility.GenerateUUID()

    local screenGui = Utility.Create("ScreenGui", {
        Name = "AdvancedUI_Watermark_" .. id,
        Parent = CoreGui,
        ResetOnSpawn = false,
        ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
        DisplayOrder = 1000
    })

    local mainFrame = Utility.Create("Frame", {
        Name = "MainFrame",
        Size = config.Size or UDim2.new(0, 200, 0, 40),
        Position = config.Position or UDim2.new(0, 20, 0, 20),
        BackgroundColor3 = config.BackgroundColor or Color3.fromRGB(0, 0, 0),
        BackgroundTransparency = config.BackgroundTransparency or 0.2,
        BorderSizePixel = 0,
        Active = true,
        Draggable = false,
        Parent = screenGui
    })

    if config.BackgroundImage then
        local bgImage = Utility.Create("ImageLabel", {
            Name = "BackgroundImage",
            Size = UDim2.new(1, 0, 1, 0),
            BackgroundTransparency = 1,
            Image = config.BackgroundImage,
            ImageColor3 = Color3.fromRGB(255, 255, 255),
            ImageTransparency = 0.5,
            ScaleType = Enum.ScaleType.Crop,
            Parent = mainFrame
        })
    end

    local corner = Utility.Create("UICorner", {
        CornerRadius = UDim.new(0, 8),
        Parent = mainFrame
    })

    local stroke = Utility.Create("UIStroke", {
        Color = config.BorderColor or ThemeManager.CurrentTheme.Primary,
        Thickness = 1,
        Transparency = 0.5,
        Parent = mainFrame
    })

    local highlight = Utility.CreateHighlight(mainFrame, Color3.fromRGB(255, 255, 255), 2, 0.3)

    local gradient = Utility.Create("UIGradient", {
        Color = ColorSequence.new({
            ColorSequenceKeypoint.new(0, ThemeManager.CurrentTheme.Primary),
            ColorSequenceKeypoint.new(1, ThemeManager.CurrentTheme.Secondary)
        }),
        Rotation = 45,
        Parent = stroke
    })

    local shadow = Utility.Create("ImageLabel", {
        Name = "Shadow",
        AnchorPoint = Vector2.new(0.5, 0.5),
        Position = UDim2.new(0.5, 0, 0.5, 4),
        Size = UDim2.new(1, 10, 1, 10),
        BackgroundTransparency = 1,
        Image = "rbxassetid://1316045217",
        ImageColor3 = Color3.fromRGB(0, 0, 0),
        ImageTransparency = 0.6,
        ScaleType = Enum.ScaleType.Slice,
        SliceCenter = Rect.new(10, 10, 118, 118),
        ZIndex = -1,
        Parent = mainFrame
    })

    local textLabel = Utility.Create("TextLabel", {
        Name = "Text",
        Size = UDim2.new(1, -40, 1, 0),
        Position = UDim2.new(0, 10, 0, 0),
        BackgroundTransparency = 1,
        Text = config.Text or "AdvancedUI",
        TextColor3 = config.TextColor or Color3.fromRGB(255, 255, 255),
        TextSize = config.TextSize or 14,
        Font = config.Font or Enum.Font.Code,
        TextXAlignment = Enum.TextXAlignment.Left,
        TextYAlignment = Enum.TextYAlignment.Center,
        Parent = mainFrame
    })

    local icon = Utility.Create("ImageLabel", {
        Name = "Icon",
        Size = UDim2.new(0, 20, 0, 20),
        Position = UDim2.new(1, -30, 0.5, -10),
        BackgroundTransparency = 1,
        Image = config.Icon or GetIcon("shield"),
        ImageColor3 = config.IconColor or Color3.fromRGB(255, 255, 255),
        Parent = mainFrame
    })

    local isDragging = false
    local isHolding = false
    local holdStartTime = 0
    local originalTransparency = mainFrame.BackgroundTransparency
    local originalTextTransparency = textLabel.TextTransparency
    local originalIconTransparency = icon.ImageTransparency
    local originalStrokeTransparency = stroke.Transparency
    local dragStart, startPos
    local connections = {}

    local function fadeOut()
        Utility.Tween(mainFrame, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
            BackgroundTransparency = 1
        })
        Utility.Tween(textLabel, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
            TextTransparency = 1
        })
        Utility.Tween(icon, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
            ImageTransparency = 1
        })
        Utility.Tween(stroke, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
            Transparency = 1
        })
        shadow.ImageTransparency = 1
    end

    local function fadeIn()
        Utility.Tween(mainFrame, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
            BackgroundTransparency = originalTransparency
        })
        Utility.Tween(textLabel, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
            TextTransparency = originalTextTransparency
        })
        Utility.Tween(icon, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
            ImageTransparency = originalIconTransparency
        })
        Utility.Tween(stroke, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
            Transparency = originalStrokeTransparency
        })
        shadow.ImageTransparency = 0.6
    end

    local function onInputBegan(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or 
           input.UserInputType == Enum.UserInputType.Touch then
            isDragging = true
            isHolding = true
            holdStartTime = tick()
            dragStart = input.Position
            startPos = mainFrame.Position

            task.spawn(function()
                while isHolding and mainFrame and mainFrame.Parent do
                    local elapsed = tick() - holdStartTime
                    if elapsed >= 0.5 then
                        fadeOut()
                        break
                    end
                    task.wait(0.05)
                end
            end)
        end
    end

    local function onInputChanged(input)
        if isDragging and (input.UserInputType == Enum.UserInputType.MouseMovement or 
                          input.UserInputType == Enum.UserInputType.Touch) then
            local delta = input.Position - dragStart
            mainFrame.Position = UDim2.new(
                startPos.X.Scale, startPos.X.Offset + delta.X,
                startPos.Y.Scale, startPos.Y.Offset + delta.Y
            )
        end
    end

    local function onInputEnded(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or 
           input.UserInputType == Enum.UserInputType.Touch then
            isDragging = false
            isHolding = false
            fadeIn()
        end
    end

    table.insert(connections, mainFrame.InputBegan:Connect(onInputBegan))
    table.insert(connections, UserInputService.InputChanged:Connect(onInputChanged))
    table.insert(connections, UserInputService.InputEnded:Connect(onInputEnded))

    watermark.ID = id
    watermark.Instance = screenGui
    watermark.MainFrame = mainFrame
    watermark.TextLabel = textLabel
    watermark.Icon = icon
    watermark.Stroke = stroke
    watermark.Shadow = shadow

    watermark.SetText = function(text)
        textLabel.Text = text
    end

    watermark.GetText = function()
        return textLabel.Text
    end

    watermark.SetPosition = function(position)
        mainFrame.Position = position
    end

    watermark.GetPosition = function()
        return mainFrame.Position
    end

    watermark.SetSize = function(size)
        mainFrame.Size = size
    end

    watermark.SetVisible = function(visible)
        screenGui.Enabled = visible
    end

    watermark.IsVisible = function()
        return screenGui.Enabled
    end

    watermark.SetTransparency = function(transparency)
        originalTransparency = transparency
        mainFrame.BackgroundTransparency = transparency
    end

    watermark.SetTextColor = function(color)
        textLabel.TextColor3 = color
    end

    watermark.SetIcon = function(iconId)
        icon.Image = iconId
    end

    watermark.SetIconColor = function(color)
        icon.ImageColor3 = color
    end

    watermark.SetBorderColor = function(color)
        stroke.Color = color
        gradient.Color = ColorSequence.new({
            ColorSequenceKeypoint.new(0, color),
            ColorSequenceKeypoint.new(1, color)
        })
    end

    watermark.FadeOut = fadeOut
    watermark.FadeIn = fadeIn

    watermark.Destroy = function()
        for _, conn in ipairs(connections) do
            conn:Disconnect()
        end
        screenGui:Destroy()
        WatermarkSystem.ActiveWatermarks[id] = nil
    end

    WatermarkSystem.ActiveWatermarks[id] = watermark
    return watermark
end

WatermarkSystem.GetAllWatermarks = function()
    return WatermarkSystem.ActiveWatermarks
end

WatermarkSystem.DestroyAll = function()
    for _, watermark in pairs(WatermarkSystem.ActiveWatermarks) do
        watermark.Destroy()
    end
    WatermarkSystem.ActiveWatermarks = {}
end

WatermarkSystem.SetAllVisible = function(visible)
    for _, watermark in pairs(WatermarkSystem.ActiveWatermarks) do
        watermark.SetVisible(visible)
    end
end

local NotificationSystem = {}

NotificationSystem.Queue = {}
NotificationSystem.MaxNotifications = 5
NotificationSystem.Spacing = 10
NotificationSystem.DefaultPosition = UDim2.new(1, -320, 0, 20)
NotificationSystem.ActiveNotifications = {}

NotificationSystem.Create = function(config)
    config = config or {}
    local notification = {}
    local id = Utility.GenerateUUID()

    local screenGui = Utility.Create("ScreenGui", {
        Name = "AdvancedUI_Notification_" .. id,
        Parent = CoreGui,
        ResetOnSpawn = false,
        ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
        DisplayOrder = 999
    })

    local mainFrame = Utility.Create("Frame", {
        Name = "MainFrame",
        Size = UDim2.new(0, 300, 0, config.Height or 80),
        Position = UDim2.new(1, 20, 0, 0),
        BackgroundColor3 = config.BackgroundColor or Color3.fromRGB(0, 0, 0),
        BackgroundTransparency = 0.1,
        BorderSizePixel = 0,
        Parent = screenGui
    })

    if config.BackgroundImage then
        local bgImage = Utility.Create("ImageLabel", {
            Name = "BackgroundImage",
            Size = UDim2.new(1, 0, 1, 0),
            BackgroundTransparency = 1,
            Image = config.BackgroundImage,
            ImageTransparency = 0.7,
            ScaleType = Enum.ScaleType.Crop,
            Parent = mainFrame
        })
    end

    local corner = Utility.Create("UICorner", {
        CornerRadius = UDim.new(0, 12),
        Parent = mainFrame
    })

    local stroke = Utility.Create("UIStroke", {
        Color = config.BorderColor or ThemeManager.CurrentTheme.Primary,
        Thickness = 1,
        Transparency = 0.3,
        Parent = mainFrame
    })

    local highlight = Utility.CreateHighlight(mainFrame, Color3.fromRGB(255, 255, 255), 2, 0.2)

    local shadow = Utility.CreateShadow(mainFrame, 4, 0.5, 15)

    local iconFrame = Utility.Create("Frame", {
        Name = "IconFrame",
        Size = UDim2.new(0, 50, 1, 0),
        BackgroundColor3 = config.IconBackground or ThemeManager.CurrentTheme.Primary,
        BackgroundTransparency = 0.3,
        BorderSizePixel = 0,
        Parent = mainFrame
    })

    local iconCorner = Utility.Create("UICorner", {
        CornerRadius = UDim.new(0, 12),
        Parent = iconFrame
    })

    local iconFix = Utility.Create("Frame", {
        Name = "IconFix",
        Size = UDim2.new(0.5, 0, 1, 0),
        Position = UDim2.new(0.5, 0, 0, 0),
        BackgroundColor3 = iconFrame.BackgroundColor3,
        BackgroundTransparency = iconFrame.BackgroundTransparency,
        BorderSizePixel = 0,
        Parent = iconFrame
    })

    local icon = Utility.Create("ImageLabel", {
        Name = "Icon",
        Size = UDim2.new(0, 30, 0, 30),
        Position = UDim2.new(0.5, 0, 0.5, 0),
        AnchorPoint = Vector2.new(0.5, 0.5),
        BackgroundTransparency = 1,
        Image = config.Icon or GetIcon("bell"),
        ImageColor3 = Color3.fromRGB(255, 255, 255),
        Parent = iconFrame
    })

    local titleLabel = Utility.Create("TextLabel", {
        Name = "Title",
        Size = UDim2.new(1, -70, 0, 25),
        Position = UDim2.new(0, 60, 0, 10),
        BackgroundTransparency = 1,
        Text = config.Title or "Notification",
        TextColor3 = config.TitleColor or Color3.fromRGB(255, 255, 255),
        TextSize = 16,
        Font = Enum.Font.Code,
        TextXAlignment = Enum.TextXAlignment.Left,
        TextTruncate = Enum.TextTruncate.AtEnd,
        Parent = mainFrame
    })

    local messageLabel = Utility.Create("TextLabel", {
        Name = "Message",
        Size = UDim2.new(1, -70, 1, -45),
        Position = UDim2.new(0, 60, 0, 35),
        BackgroundTransparency = 1,
        Text = config.Message or "",
        TextColor3 = config.MessageColor or Color3.fromRGB(200, 200, 200),
        TextSize = 14,
        Font = Enum.Font.Code,
        TextXAlignment = Enum.TextXAlignment.Left,
        TextYAlignment = Enum.TextYAlignment.Top,
        TextWrapped = true,
        Parent = mainFrame
    })

    local closeButton = Utility.Create("ImageButton", {
        Name = "CloseButton",
        Size = UDim2.new(0, 24, 0, 24),
        Position = UDim2.new(1, -32, 0, 8),
        BackgroundTransparency = 1,
        Image = GetIcon("x"),
        ImageColor3 = Color3.fromRGB(150, 150, 150),
        Parent = mainFrame
    })

    local progressBar = Utility.Create("Frame", {
        Name = "ProgressBar",
        Size = UDim2.new(1, 0, 0, 3),
        Position = UDim2.new(0, 0, 1, -3),
        BackgroundColor3 = config.ProgressColor or ThemeManager.CurrentTheme.Primary,
        BorderSizePixel = 0,
        Parent = mainFrame
    })

    local progressCorner = Utility.Create("UICorner", {
        CornerRadius = UDim.new(0, 3),
        Parent = progressBar
    })

    local duration = config.Duration or 5
    local startTime = tick()
    local isPaused = false
    local connection
    local connections = {}

    local function updatePosition()
        local index = table.find(NotificationSystem.Queue, notification)
        if index then
            local targetY = 20 + (index - 1) * ((config.Height or 80) + NotificationSystem.Spacing)
            Utility.Tween(mainFrame, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
                Position = UDim2.new(1, -320, 0, targetY)
            })
        end
    end

    local function close()
        if connection then
            connection:Disconnect()
        end
        for _, conn in ipairs(connections) do
            conn:Disconnect()
        end

        local index = table.find(NotificationSystem.Queue, notification)
        if index then
            table.remove(NotificationSystem.Queue, index)
        end
        NotificationSystem.ActiveNotifications[id] = nil

        Utility.Tween(mainFrame, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {
            Position = UDim2.new(1, 20, mainFrame.Position.Y.Scale, mainFrame.Position.Y.Offset),
            Size = UDim2.new(0, 0, 0, config.Height or 80)
        }).Completed:Connect(function()
            screenGui:Destroy()
            for _, notif in ipairs(NotificationSystem.Queue) do
                notif.UpdatePosition()
            end
        end)
    end

    notification.ID = id
    notification.UpdatePosition = updatePosition
    notification.Close = close
    notification.Pause = function()
        isPaused = true
    end
    notification.Resume = function()
        isPaused = false
    end

    table.insert(connections, closeButton.MouseButton1Click:Connect(close))
    table.insert(connections, mainFrame.MouseEnter:Connect(function()
        isPaused = true
    end))
    table.insert(connections, mainFrame.MouseLeave:Connect(function()
        isPaused = false
    end))

    connection = RunService.Heartbeat:Connect(function()
        if not isPaused then
            local elapsed = tick() - startTime
            local progress = math.max(0, 1 - (elapsed / duration))
            progressBar.Size = UDim2.new(progress, 0, 0, 3)
            if elapsed >= duration then
                close()
            end
        else
            startTime = tick() - (duration * (1 - (progressBar.Size.X.Scale)))
        end
    end)

    table.insert(NotificationSystem.Queue, 1, notification)
    NotificationSystem.ActiveNotifications[id] = notification

    if #NotificationSystem.Queue > NotificationSystem.MaxNotifications then
        NotificationSystem.Queue[#NotificationSystem.Queue].Close()
    end

    for _, notif in ipairs(NotificationSystem.Queue) do
        notif.UpdatePosition()
    end

    Utility.Tween(mainFrame, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
        Position = UDim2.new(1, -320, 0, 20)
    })

    return notification
end

NotificationSystem.Success = function(title, message, duration)
    return NotificationSystem.Create({
        Title = title,
        Message = message,
        Duration = duration,
        Icon = GetIcon("check"),
        BorderColor = Color3.fromRGB(34, 197, 94),
        IconBackground = Color3.fromRGB(34, 197, 94),
        ProgressColor = Color3.fromRGB(34, 197, 94)
    })
end

NotificationSystem.Error = function(title, message, duration)
    return NotificationSystem.Create({
        Title = title,
        Message = message,
        Duration = duration,
        Icon = GetIcon("x"),
        BorderColor = Color3.fromRGB(239, 68, 68),
        IconBackground = Color3.fromRGB(239, 68, 68),
        ProgressColor = Color3.fromRGB(239, 68, 68)
    })
end

NotificationSystem.Warning = function(title, message, duration)
    return NotificationSystem.Create({
        Title = title,
        Message = message,
        Duration = duration,
        Icon = GetIcon("alert-triangle"),
        BorderColor = Color3.fromRGB(245, 158, 11),
        IconBackground = Color3.fromRGB(245, 158, 11),
        ProgressColor = Color3.fromRGB(245, 158, 11)
    })
end

NotificationSystem.Info = function(title, message, duration)
    return NotificationSystem.Create({
        Title = title,
        Message = message,
        Duration = duration,
        Icon = GetIcon("info"),
        BorderColor = Color3.fromRGB(59, 130, 246),
        IconBackground = Color3.fromRGB(59, 130, 246),
        ProgressColor = Color3.fromRGB(59, 130, 246)
    })
end

NotificationSystem.ClearAll = function()
    for _, notif in ipairs(NotificationSystem.Queue) do
        notif.Close()
    end
end

NotificationSystem.GetActiveCount = function()
    return #NotificationSystem.Queue
end

local WindowManager = {}

WindowManager.Windows = {}
WindowManager.ActiveWindow = nil
WindowManager.ZIndexBase = 100
WindowManager.MinimizedWindows = {}

WindowManager.Create = function(config)
    config = config or {}
    local window = {}
    local id = Utility.GenerateUUID()

    local screenGui = Utility.Create("ScreenGui", {
        Name = "AdvancedUI_Window_" .. id,
        Parent = CoreGui,
        ResetOnSpawn = false,
        ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
        DisplayOrder = WindowManager.ZIndexBase + #WindowManager.Windows
    })

    local mainFrame = Utility.Create("Frame", {
        Name = "MainFrame",
        Size = config.Size or UDim2.new(0, 800, 0, 500),
        Position = config.Position or UDim2.new(0.5, -400, 0.5, -250),
        BackgroundColor3 = config.BackgroundColor or ThemeManager.CurrentTheme.Background,
        BackgroundTransparency = config.BackgroundTransparency or 0.1,
        BorderSizePixel = 0,
        Active = true,
        Parent = screenGui
    })

    if config.BackgroundImage then
        local bgImage = Utility.Create("ImageLabel", {
            Name = "BackgroundImage",
            Size = UDim2.new(1, 0, 1, 0),
            BackgroundTransparency = 1,
            Image = config.BackgroundImage,
            ImageColor3 = Color3.fromRGB(255, 255, 255),
            ImageTransparency = 0.3,
            ScaleType = Enum.ScaleType.Crop,
            Parent = mainFrame
        })
    end

    local corner = Utility.Create("UICorner", {
        CornerRadius = UDim.new(0, 12),
        Parent = mainFrame
    })

    local stroke = Utility.Create("UIStroke", {
        Color = config.BorderColor or ThemeManager.CurrentTheme.Border,
        Thickness = 1,
        Transparency = 0.3,
        Parent = mainFrame
    })

    local highlight = Utility.CreateHighlight(mainFrame, Color3.fromRGB(255, 255, 255), 2, 0.2)

    local shadow = Utility.CreateShadow(mainFrame, 8, 0.7, 20)

    local titleBar = Utility.Create("Frame", {
        Name = "TitleBar",
        Size = UDim2.new(1, 0, 0, 40),
        BackgroundColor3 = config.TitleBarColor or ThemeManager.CurrentTheme.Surface,
        BackgroundTransparency = 0.5,
        BorderSizePixel = 0,
        Parent = mainFrame
    })

    local titleCorner = Utility.Create("UICorner", {
        CornerRadius = UDim.new(0, 12),
        Parent = titleBar
    })

    local titleFix = Utility.Create("Frame", {
        Name = "TitleFix",
        Size = UDim2.new(1, 0, 0.5, 0),
        Position = UDim2.new(0, 0, 0.5, 0),
        BackgroundColor3 = titleBar.BackgroundColor3,
        BackgroundTransparency = titleBar.BackgroundTransparency,
        BorderSizePixel = 0,
        Parent = titleBar
    })

    local icon = Utility.Create("ImageLabel", {
        Name = "Icon",
        Size = UDim2.new(0, 24, 0, 24),
        Position = UDim2.new(0, 12, 0.5, -12),
        BackgroundTransparency = 1,
        Image = config.Icon or GetIcon("layout"),
        ImageColor3 = ThemeManager.CurrentTheme.Primary,
        Parent = titleBar
    })

    local titleLabel = Utility.Create("TextLabel", {
        Name = "Title",
        Size = UDim2.new(1, -200, 1, 0),
        Position = UDim2.new(0, 44, 0, 0),
        BackgroundTransparency = 1,
        Text = config.Title or "AdvancedUI Window",
        TextColor3 = ThemeManager.CurrentTheme.TextPrimary,
        TextSize = 16,
        Font = Enum.Font.Code,
        TextXAlignment = Enum.TextXAlignment.Left,
        TextTruncate = Enum.TextTruncate.AtEnd,
        Parent = titleBar
    })

    local buttonContainer = Utility.Create("Frame", {
        Name = "ButtonContainer",
        Size = UDim2.new(0, 100, 1, 0),
        Position = UDim2.new(1, -110, 0, 0),
        BackgroundTransparency = 1,
        Parent = titleBar
    })

    local minimizeButton = Utility.Create("ImageButton", {
        Name = "MinimizeButton",
        Size = UDim2.new(0, 30, 0, 30),
        Position = UDim2.new(0, 5, 0.5, -15),
        BackgroundColor3 = Color3.fromRGB(255, 193, 7),
        Image = GetIcon("minus"),
        ImageColor3 = Color3.fromRGB(0, 0, 0),
        AutoButtonColor = false,
        Parent = buttonContainer
    })

    local minimizeCorner = Utility.Create("UICorner", {
        CornerRadius = UDim.new(1, 0),
        Parent = minimizeButton
    })

    local maximizeButton = Utility.Create("ImageButton", {
        Name = "MaximizeButton",
        Size = UDim2.new(0, 30, 0, 30),
        Position = UDim2.new(0, 40, 0.5, -15),
        BackgroundColor3 = Color3.fromRGB(76, 175, 80),
        Image = GetIcon("maximize"),
        ImageColor3 = Color3.fromRGB(0, 0, 0),
        AutoButtonColor = false,
        Parent = buttonContainer
    })

    local maximizeCorner = Utility.Create("UICorner", {
        CornerRadius = UDim.new(1, 0),
        Parent = maximizeButton
    })

    local closeButton = Utility.Create("ImageButton", {
        Name = "CloseButton",
        Size = UDim2.new(0, 30, 0, 30),
        Position = UDim2.new(0, 75, 0.5, -15),
        BackgroundColor3 = Color3.fromRGB(244, 67, 54),
        Image = GetIcon("x"),
        ImageColor3 = Color3.fromRGB(0, 0, 0),
        AutoButtonColor = false,
        Parent = buttonContainer
    })

    local closeCorner = Utility.Create("UICorner", {
        CornerRadius = UDim.new(1, 0),
        Parent = closeButton
    })

    local contentFrame = Utility.Create("Frame", {
        Name = "Content",
        Size = UDim2.new(1, -20, 1, -60),
        Position = UDim2.new(0, 10, 0, 50),
        BackgroundTransparency = 1,
        Parent = mainFrame
    })

    local isMinimized = false
    local isMaximized = false
    local originalSize = mainFrame.Size
    local originalPosition = mainFrame.Position
    local connections = {}

    local function bringToFront()
        WindowManager.ActiveWindow = window
        for _, win in ipairs(WindowManager.Windows) do
            if win ~= window then
                win.ScreenGui.DisplayOrder = WindowManager.ZIndexBase
            end
        end
        screenGui.DisplayOrder = WindowManager.ZIndexBase + 100
    end

    local function minimize()
        if isMaximized then return end
        isMinimized = not isMinimized
        if isMinimized then
            WindowManager.MinimizedWindows[id] = window
            Utility.Tween(contentFrame, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
                Size = UDim2.new(1, -20, 0, 0)
            })
            Utility.Tween(mainFrame, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
                Size = UDim2.new(0, mainFrame.Size.X.Offset, 0, 40)
            })
        else
            WindowManager.MinimizedWindows[id] = nil
            Utility.Tween(contentFrame, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
                Size = UDim2.new(1, -20, 1, -60)
            })
            Utility.Tween(mainFrame, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
                Size = originalSize
            })
        end
    end

    local function maximize()
        if isMinimized then return end
        isMaximized = not isMaximized
        if isMaximized then
            originalSize = mainFrame.Size
            originalPosition = mainFrame.Position
            Utility.Tween(mainFrame, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
                Size = UDim2.new(1, 0, 1, 0),
                Position = UDim2.new(0, 0, 0, 0)
            })
        else
            Utility.Tween(mainFrame, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
                Size = originalSize,
                Position = originalPosition
            })
        end
    end

    local function close()
        Utility.Tween(mainFrame, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {
            Size = UDim2.new(0, 0, 0, 0)
        }).Completed:Connect(function()
            screenGui:Destroy()
            for i, win in ipairs(WindowManager.Windows) do
                if win == window then
                    table.remove(WindowManager.Windows, i)
                    break
                end
            end
            WindowManager.MinimizedWindows[id] = nil
            for _, conn in ipairs(connections) do
                conn:Disconnect()
            end
        end)
    end

    table.insert(connections, minimizeButton.MouseButton1Click:Connect(minimize))
    table.insert(connections, maximizeButton.MouseButton1Click:Connect(maximize))
    table.insert(connections, closeButton.MouseButton1Click:Connect(close))
    table.insert(connections, mainFrame.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            bringToFront()
        end
    end))

    local dragConnections = Utility.Drag(mainFrame, titleBar)
    for _, conn in ipairs(dragConnections) do
        table.insert(connections, conn)
    end

    table.insert(WindowManager.Windows, window)

    window.ID = id
    window.ScreenGui = screenGui
    window.MainFrame = mainFrame
    window.ContentFrame = contentFrame
    window.TitleBar = titleBar
    window.TitleLabel = titleLabel
    window.Icon = icon
    window.Minimize = minimize
    window.Maximize = maximize
    window.Close = close
    window.BringToFront = bringToFront
    window.IsMinimized = function() return isMinimized end
    window.IsMaximized = function() return isMaximized end

    window.AddTab = function(tabConfig)
        return TabSystem.Create(tabConfig, contentFrame, window)
    end

    window.Show = function()
        screenGui.Enabled = true
        Utility.Tween(mainFrame, TweenInfo.new(0.3, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
            Size = isMinimized and UDim2.new(0, mainFrame.Size.X.Offset, 0, 40) or originalSize
        })
    end

    window.Hide = function()
        Utility.Tween(mainFrame, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {
            Size = UDim2.new(0, 0, 0, 0)
        }).Completed:Connect(function()
            screenGui.Enabled = false
        end)
    end

    window.SetTitle = function(title)
        titleLabel.Text = title
    end

    window.SetIcon = function(iconName)
        icon.Image = GetIcon(iconName)
    end

    window.SetSize = function(size)
        originalSize = size
        if not isMinimized and not isMaximized then
            mainFrame.Size = size
        end
    end

    window.SetPosition = function(position)
        originalPosition = position
        if not isMaximized then
            mainFrame.Position = position
        end
    end

    window.SetVisible = function(visible)
        screenGui.Enabled = visible
    end

    window.Destroy = function()
        close()
    end

    bringToFront()
    return window
end

WindowManager.GetActiveWindow = function()
    return WindowManager.ActiveWindow
end

WindowManager.GetAllWindows = function()
    return WindowManager.Windows
end

WindowManager.CloseAll = function()
    for _, window in ipairs(WindowManager.Windows) do
        window.Close()
    end
end

WindowManager.MinimizeAll = function()
    for _, window in ipairs(WindowManager.Windows) do
        if not window.IsMinimized() then
            window.Minimize()
        end
    end
end

WindowManager.RestoreAll = function()
    for _, window in pairs(WindowManager.MinimizedWindows) do
        if window.IsMinimized() then
            window.Minimize()
        end
    end
end

WindowManager.BringAllToFront = function()
    for i, window in ipairs(WindowManager.Windows) do
        window.ScreenGui.DisplayOrder = WindowManager.ZIndexBase + i
    end
end

local TabSystem = {}

TabSystem.Tabs = {}

TabSystem.Create = function(config, parent, window)
    config = config or {}
    local tab = {}
    local id = Utility.GenerateUUID()

    if not parent:FindFirstChild("TabContainer") then
        local tabContainer = Utility.Create("Frame", {
            Name = "TabContainer",
            Size = UDim2.new(0, 150, 1, 0),
            BackgroundColor3 = ThemeManager.CurrentTheme.Surface,
            BackgroundTransparency = 0.5,
            BorderSizePixel = 0,
            Parent = parent
        })

        local tabCorner = Utility.Create("UICorner", {
            CornerRadius = UDim.new(0, 8),
            Parent = tabContainer
        })

        local tabList = Utility.Create("ScrollingFrame", {
            Name = "TabList",
            Size = UDim2.new(1, -10, 1, -10),
            Position = UDim2.new(0, 5, 0, 5),
            BackgroundTransparency = 1,
            ScrollBarThickness = 2,
            ScrollBarImageColor3 = ThemeManager.CurrentTheme.Primary,
            CanvasSize = UDim2.new(0, 0, 0, 0),
            AutomaticCanvasSize = Enum.AutomaticSize.Y,
            Parent = tabContainer
        })

        local listLayout = Utility.Create("UIListLayout", {
            Padding = UDim.new(0, 5),
            SortOrder = Enum.SortOrder.LayoutOrder,
            Parent = tabList
        })

        local contentContainer = Utility.Create("Frame", {
            Name = "ContentContainer",
            Size = UDim2.new(1, -160, 1, 0),
            Position = UDim2.new(0, 160, 0, 0),
            BackgroundTransparency = 1,
            Parent = parent
        })

        parent.Parent.TabContainer = tabContainer
        parent.Parent.ContentContainer = contentContainer
    end

    local tabContainer = parent:FindFirstChild("TabContainer")
    local tabList = tabContainer:FindFirstChild("TabList")
    local contentContainer = parent:FindFirstChild("ContentContainer")

    local tabButton = Utility.Create("TextButton", {
        Name = "TabButton_" .. config.Name,
        Size = UDim2.new(1, 0, 0, 40),
        BackgroundColor3 = ThemeManager.CurrentTheme.Surface,
        BackgroundTransparency = 0.8,
        Text = "",
        AutoButtonColor = false,
        LayoutOrder = #tabList:GetChildren(),
        Parent = tabList
    })

    local buttonCorner = Utility.Create("UICorner", {
        CornerRadius = UDim.new(0, 6),
        Parent = tabButton
    })

    local tabIcon = Utility.Create("ImageLabel", {
        Name = "Icon",
        Size = UDim2.new(0, 20, 0, 20),
        Position = UDim2.new(0, 10, 0.5, -10),
        BackgroundTransparency = 1,
        Image = config.Icon and GetIcon(config.Icon) or GetIcon("circle"),
        ImageColor3 = ThemeManager.CurrentTheme.TextSecondary,
        Parent = tabButton
    })

    local tabLabel = Utility.Create("TextLabel", {
        Name = "Label",
        Size = UDim2.new(1, -40, 1, 0),
        Position = UDim2.new(0, 35, 0, 0),
        BackgroundTransparency = 1,
        Text = config.Name or "Tab",
        TextColor3 = ThemeManager.CurrentTheme.TextSecondary,
        TextSize = 14,
        Font = Enum.Font.Code,
        TextXAlignment = Enum.TextXAlignment.Left,
        TextTruncate = Enum.TextTruncate.AtEnd,
        Parent = tabButton
    })

    local contentFrame = Utility.Create("ScrollingFrame", {
        Name = "Content_" .. config.Name,
        Size = UDim2.new(1, 0, 1, 0),
        BackgroundTransparency = 1,
        ScrollBarThickness = 4,
        ScrollBarImageColor3 = ThemeManager.CurrentTheme.Primary,
        CanvasSize = UDim2.new(0, 0, 0, 0),
        AutomaticCanvasSize = Enum.AutomaticSize.Y,
        Visible = false,
        Parent = contentContainer
    })

    local contentLayout = Utility.Create("UIListLayout", {
        Padding = UDim.new(0, 10),
        SortOrder = Enum.SortOrder.LayoutOrder,
        Parent = contentFrame
    })

    local contentPadding = Utility.Create("UIPadding", {
        PaddingLeft = UDim.new(0, 10),
        PaddingRight = UDim.new(0, 10),
        PaddingTop = UDim.new(0, 10),
        PaddingBottom = UDim.new(0, 10),
        Parent = contentFrame
    })

    local isActive = false
    local connections = {}

    local function activate()
        if isActive then return end

        for _, child in ipairs(contentContainer:GetChildren()) do
            if child:IsA("ScrollingFrame") then
                child.Visible = false
            end
        end

        for _, child in ipairs(tabList:GetChildren()) do
            if child:IsA("TextButton") then
                Utility.Tween(child, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
                    BackgroundTransparency = 0.8
                })
                local label = child:FindFirstChild("Label")
                local icon = child:FindFirstChild("Icon")
                if label then
                    label.TextColor3 = ThemeManager.CurrentTheme.TextSecondary
                end
                if icon then
                    icon.ImageColor3 = ThemeManager.CurrentTheme.TextSecondary
                end
            end
        end

        contentFrame.Visible = true
        Utility.Tween(tabButton, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
            BackgroundTransparency = 0.3
        })
        tabLabel.TextColor3 = ThemeManager.CurrentTheme.TextPrimary
        tabIcon.ImageColor3 = ThemeManager.CurrentTheme.Primary

        isActive = true
        tab.Active = true

        if config.OnActivate then
            config.OnActivate()
        end
    end

    local function deactivate()
        isActive = false
        tab.Active = false
        if config.OnDeactivate then
            config.OnDeactivate()
        end
    end

    table.insert(connections, tabButton.MouseButton1Click:Connect(activate))

    table.insert(connections, tabButton.MouseEnter:Connect(function()
        if not isActive then
            Utility.Tween(tabButton, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
                BackgroundTransparency = 0.6
            })
        end
    end))

    table.insert(connections, tabButton.MouseLeave:Connect(function()
        if not isActive then
            Utility.Tween(tabButton, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
                BackgroundTransparency = 0.8
            })
        end
    end))

    tab.ID = id
    tab.Button = tabButton
    tab.Content = contentFrame
    tab.Activate = activate
    tab.Deactivate = deactivate
    tab.IsActive = function() return isActive end

    tab.AddSection = function(sectionConfig)
        return SectionSystem.Create(sectionConfig, contentFrame)
    end

    tab.Destroy = function()
        for _, conn in ipairs(connections) do
            conn:Disconnect()
        end
        tabButton:Destroy()
        contentFrame:Destroy()
    end

    if #tabList:GetChildren() == 2 then
        activate()
    end

    TabSystem.Tabs[id] = tab
    return tab
end

TabSystem.GetAllTabs = function()
    return TabSystem.Tabs
end

TabSystem.ClearAllTabs = function()
    for _, tab in pairs(TabSystem.Tabs) do
        tab.Destroy()
    end
    TabSystem.Tabs = {}
end

local SectionSystem = {}

SectionSystem.Sections = {}

SectionSystem.Create = function(config, parent)
    config = config or {}
    local section = {}
    local id = Utility.GenerateUUID()

    local sectionFrame = Utility.Create("Frame", {
        Name = "Section_" .. (config.Name or "Unnamed"),
        Size = UDim2.new(1, 0, 0, 0),
        AutomaticSize = Enum.AutomaticSize.Y,
        BackgroundColor3 = ThemeManager.CurrentTheme.Surface,
        BackgroundTransparency = 0.5,
        BorderSizePixel = 0,
        LayoutOrder = #parent:GetChildren(),
        Parent = parent
    })

    local sectionCorner = Utility.Create("UICorner", {
        CornerRadius = UDim.new(0, 8),
        Parent = sectionFrame
    })

    local sectionStroke = Utility.Create("UIStroke", {
        Color = ThemeManager.CurrentTheme.Border,
        Thickness = 1,
        Transparency = 0.2,
        Parent = sectionFrame
    })

    local highlight = Utility.CreateHighlight(sectionFrame, Color3.fromRGB(255, 255, 255), 1, 0.15)

    local headerFrame = Utility.Create("Frame", {
        Name = "Header",
        Size = UDim2.new(1, 0, 0, 35),
        BackgroundColor3 = ThemeManager.CurrentTheme.Primary,
        BackgroundTransparency = 0.9,
        BorderSizePixel = 0,
        Parent = sectionFrame
    })

    local headerCorner = Utility.Create("UICorner", {
        CornerRadius = UDim.new(0, 8),
        Parent = headerFrame
    })

    local headerFix = Utility.Create("Frame", {
        Name = "HeaderFix",
        Size = UDim2.new(1, 0, 0.5, 0),
        Position = UDim2.new(0, 0, 0.5, 0),
        BackgroundColor3 = headerFrame.BackgroundColor3,
        BackgroundTransparency = headerFrame.BackgroundTransparency,
        BorderSizePixel = 0,
        Parent = headerFrame
    })

    local sectionIcon = Utility.Create("ImageLabel", {
        Name = "Icon",
        Size = UDim2.new(0, 18, 0, 18),
        Position = UDim2.new(0, 10, 0.5, -9),
        BackgroundTransparency = 1,
        Image = config.Icon and GetIcon(config.Icon) or GetIcon("box"),
        ImageColor3 = ThemeManager.CurrentTheme.Primary,
        Parent = headerFrame
    })

    local sectionTitle = Utility.Create("TextLabel", {
        Name = "Title",
        Size = UDim2.new(1, -40, 1, 0),
        Position = UDim2.new(0, 35, 0, 0),
        BackgroundTransparency = 1,
        Text = config.Name or "Section",
        TextColor3 = ThemeManager.CurrentTheme.TextPrimary,
        TextSize = 14,
        Font = Enum.Font.Code,
        TextXAlignment = Enum.TextXAlignment.Left,
        TextTruncate = Enum.TextTruncate.AtEnd,
        Parent = headerFrame
    })

    local collapseButton = Utility.Create("ImageButton", {
        Name = "CollapseButton",
        Size = UDim2.new(0, 24, 0, 24),
        Position = UDim2.new(1, -30, 0.5, -12),
        BackgroundTransparency = 1,
        Image = GetIcon("chevron-down"),
        ImageColor3 = ThemeManager.CurrentTheme.TextSecondary,
        Parent = headerFrame
    })

    local contentFrame = Utility.Create("Frame", {
        Name = "Content",
        Size = UDim2.new(1, -20, 0, 0),
        Position = UDim2.new(0, 10, 0, 45),
        AutomaticSize = Enum.AutomaticSize.Y,
        BackgroundTransparency = 1,
        Parent = sectionFrame
    })

    local contentList = Utility.Create("UIListLayout", {
        Padding = UDim.new(0, 8),
        SortOrder = Enum.SortOrder.LayoutOrder,
        Parent = contentFrame
    })

    local contentPadding = Utility.Create("UIPadding", {
        PaddingBottom = UDim.new(0, 10),
        Parent = contentFrame
    })

    local isCollapsed = false
    local connections = {}

    local function toggleCollapse()
        isCollapsed = not isCollapsed
        if isCollapsed then
            collapseButton.Image = GetIcon("chevron-right")
            contentFrame.Visible = false
            Utility.Tween(sectionFrame, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
                Size = UDim2.new(1, 0, 0, 35)
            })
        else
            collapseButton.Image = GetIcon("chevron-down")
            contentFrame.Visible = true
            Utility.Tween(sectionFrame, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
                Size = UDim2.new(1, 0, 0, 0)
            })
        end

        if config.OnCollapse then
            config.OnCollapse(isCollapsed)
        end
    end

    table.insert(connections, collapseButton.MouseButton1Click:Connect(toggleCollapse))

    section.ID = id
    section.Frame = sectionFrame
    section.Content = contentFrame
    section.Header = headerFrame
    section.Collapse = function() if not isCollapsed then toggleCollapse() end end
    section.Expand = function() if isCollapsed then toggleCollapse() end end
    section.Toggle = toggleCollapse
    section.IsCollapsed = function() return isCollapsed end

    section.SetTitle = function(title)
        sectionTitle.Text = title
    end

    section.SetIcon = function(iconName)
        sectionIcon.Image = GetIcon(iconName)
    end

    section.AddButton = function(buttonConfig)
        return ButtonSystem.Create(buttonConfig, contentFrame)
    end

    section.AddToggle = function(toggleConfig)
        return ToggleSystem.Create(toggleConfig, contentFrame)
    end

    section.AddSlider = function(sliderConfig)
        return SliderSystem.Create(sliderConfig, contentFrame)
    end

    section.AddDropdown = function(dropdownConfig)
        return DropdownSystem.Create(dropdownConfig, contentFrame)
    end

    section.AddInput = function(inputConfig)
        return InputSystem.Create(inputConfig, contentFrame)
    end

    section.AddKeybind = function(keybindConfig)
        return KeybindSystem.Create(keybindConfig, contentFrame)
    end

    section.AddLabel = function(labelConfig)
        return LabelSystem.Create(labelConfig, contentFrame)
    end

    section.AddDivider = function()
        return DividerSystem.Create(contentFrame)
    end

    section.AddColorPicker = function(colorPickerConfig)
        return ColorPickerSystem.Create(colorPickerConfig, contentFrame)
    end

    section.AddProgressBar = function(progressBarConfig)
        return ProgressBarSystem.Create(progressBarConfig, contentFrame)
    end

    section.AddSearch = function(searchConfig)
        return SearchSystem.Create(searchConfig, contentFrame)
    end

    section.AddBadge = function(badgeConfig)
        return BadgeSystem.Create(badgeConfig, contentFrame)
    end

    section.AddImage = function(imageConfig)
        return ImageSystem.Create(imageConfig, contentFrame)
    end

    section.AddContainer = function(containerConfig)
        return ContainerSystem.Create(containerConfig, contentFrame)
    end

    section.AddRadioButton = function(radioConfig)
        return RadioButtonSystem.Create(radioConfig, contentFrame)
    end

    section.AddCheckbox = function(checkboxConfig)
        return CheckboxSystem.Create(checkboxConfig, contentFrame)
    end

    section.AddSpinner = function(spinnerConfig)
        return SpinnerSystem.Create(spinnerConfig, contentFrame)
    end

    section.AddStepper = function(stepperConfig)
        return StepperSystem.Create(stepperConfig, contentFrame)
    end

    section.AddSegmentedControl = function(segmentedConfig)
        return SegmentedControlSystem.Create(segmentedConfig, contentFrame)
    end

    section.AddDatePicker = function(datePickerConfig)
        return DatePickerSystem.Create(datePickerConfig, contentFrame)
    end

    section.AddTimePicker = function(timePickerConfig)
        return TimePickerSystem.Create(timePickerConfig, contentFrame)
    end

    section.AddFilePicker = function(filePickerConfig)
        return FilePickerSystem.Create(filePickerConfig, contentFrame)
    end

    section.AddRichText = function(richTextConfig)
        return RichTextSystem.Create(richTextConfig, contentFrame)
    end

    section.AddCodeBlock = function(codeBlockConfig)
        return CodeBlockSystem.Create(codeBlockConfig, contentFrame)
    end

    section.AddTerminal = function(terminalConfig)
        return TerminalSystem.Create(terminalConfig, contentFrame)
    end

    section.AddChart = function(chartConfig)
        return ChartSystem.Create(chartConfig, contentFrame)
    end

    section.AddDataGrid = function(dataGridConfig)
        return DataGridSystem.Create(dataGridConfig, contentFrame)
    end

    section.AddTreeView = function(treeViewConfig)
        return TreeViewSystem.Create(treeViewConfig, contentFrame)
    end

    section.AddMenuBar = function(menuBarConfig)
        return MenuBarSystem.Create(menuBarConfig, contentFrame)
    end

    section.AddToolbar = function(toolbarConfig)
        return ToolbarSystem.Create(toolbarConfig, contentFrame)
    end

    section.AddStatusBar = function(statusBarConfig)
        return StatusBarSystem.Create(statusBarConfig, contentFrame)
    end

    section.Destroy = function()
        for _, conn in ipairs(connections) do
            conn:Disconnect()
        end
        sectionFrame:Destroy()
        SectionSystem.Sections[id] = nil
    end

    SectionSystem.Sections[id] = section
    return section
end

SectionSystem.GetAllSections = function()
    return SectionSystem.Sections
end

local ButtonSystem = {}

ButtonSystem.Buttons = {}

ButtonSystem.Create = function(config, parent)
    config = config or {}
    local button = {}
    local id = Utility.GenerateUUID()

    local buttonFrame = Utility.Create("TextButton", {
        Name = "Button_" .. (config.Name or "Unnamed"),
        Size = config.Size or UDim2.new(1, 0, 0, 40),
        BackgroundColor3 = config.BackgroundColor or ThemeManager.CurrentTheme.Primary,
        BackgroundTransparency = 0.2,
        Text = "",
        AutoButtonColor = false,
        LayoutOrder = #parent:GetChildren(),
        Parent = parent
    })

    local corner = Utility.Create("UICorner", {
        CornerRadius = UDim.new(0, 8),
        Parent = buttonFrame
    })

    local stroke = Utility.Create("UIStroke", {
        Color = config.BorderColor or ThemeManager.CurrentTheme.Primary,
        Thickness = 1,
        Transparency = 0.5,
        Parent = buttonFrame
    })

    local highlight = Utility.CreateHighlight(buttonFrame, Color3.fromRGB(255, 255, 255), 2, 0.3)

    local icon = Utility.Create("ImageLabel", {
        Name = "Icon",
        Size = UDim2.new(0, 20, 0, 20),
        Position = UDim2.new(0, 10, 0.5, -10),
        BackgroundTransparency = 1,
        Image = config.Icon and GetIcon(config.Icon) or GetIcon("circle"),
        ImageColor3 = Color3.fromRGB(255, 255, 255),
        Parent = buttonFrame
    })

    local label = Utility.Create("TextLabel", {
        Name = "Label",
        Size = UDim2.new(1, -40, 1, 0),
        Position = UDim2.new(0, 35, 0, 0),
        BackgroundTransparency = 1,
        Text = config.Name or "Button",
        TextColor3 = config.TextColor or Color3.fromRGB(255, 255, 255),
        TextSize = 14,
        Font = Enum.Font.Code,
        TextXAlignment = Enum.TextXAlignment.Left,
        TextTruncate = Enum.TextTruncate.AtEnd,
        Parent = buttonFrame
    })

    local ripple = Utility.Create("Frame", {
        Name = "Ripple",
        AnchorPoint = Vector2.new(0.5, 0.5),
        Position = UDim2.new(0.5, 0, 0.5, 0),
        Size = UDim2.new(0, 0, 0, 0),
        BackgroundColor3 = Color3.fromRGB(255, 255, 255),
        BackgroundTransparency = 0.7,
        BorderSizePixel = 0,
        ZIndex = 10,
        Parent = buttonFrame
    })

    local rippleCorner = Utility.Create("UICorner", {
        CornerRadius = UDim.new(1, 0),
        Parent = ripple
    })

    local isPressed = false
    local isHovered = false
    local connections = {}

    local function createRipple(position)
        local relativePos = Vector2.new(
            position.X - buttonFrame.AbsolutePosition.X,
            position.Y - buttonFrame.AbsolutePosition.Y
        )

        ripple.Position = UDim2.new(0, relativePos.X, 0, relativePos.Y)
        ripple.Size = UDim2.new(0, 0, 0, 0)
        ripple.BackgroundTransparency = 0.7

        local maxSize = math.max(buttonFrame.AbsoluteSize.X, buttonFrame.AbsoluteSize.Y) * 2
        Utility.Tween(ripple, TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
            Size = UDim2.new(0, maxSize, 0, maxSize),
            BackgroundTransparency = 1
        })
    end

    table.insert(connections, buttonFrame.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or 
           input.UserInputType == Enum.UserInputType.Touch then
            isPressed = true
            Utility.Tween(buttonFrame, TweenInfo.new(0.1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
                BackgroundTransparency = 0.4
            })
            createRipple(input.Position)
        end
    end))

    table.insert(connections, buttonFrame.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or 
           input.UserInputType == Enum.UserInputType.Touch then
            isPressed = false
            Utility.Tween(buttonFrame, TweenInfo.new(0.1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
                BackgroundTransparency = isHovered and 0.1 or 0.2
            })

            if config.Callback then
                task.spawn(config.Callback)
            end

            EventBus.Publish("ButtonClicked", id, config.Name)
        end
    end))

    table.insert(connections, buttonFrame.MouseEnter:Connect(function()
        isHovered = true
        if not isPressed then
            Utility.Tween(buttonFrame, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
                BackgroundTransparency = 0.1
            })
            Utility.Tween(stroke, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
                Transparency = 0.2
            })
        end
    end))

    table.insert(connections, buttonFrame.MouseLeave:Connect(function()
        isHovered = false
        if not isPressed then
            Utility.Tween(buttonFrame, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
                BackgroundTransparency = 0.2
            })
            Utility.Tween(stroke, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
                Transparency = 0.5
            })
        end
    end))

    button.ID = id
    button.Instance = buttonFrame
    button.SetText = function(text)
        label.Text = text
    end
    button.GetText = function()
        return label.Text
    end
    button.SetCallback = function(callback)
        config.Callback = callback
    end
    button.SetIcon = function(iconName)
        icon.Image = GetIcon(iconName)
    end
    button.SetVisible = function(visible)
        buttonFrame.Visible = visible
    end
    button.Destroy = function()
        for _, conn in ipairs(connections) do
            conn:Disconnect()
        end
        buttonFrame:Destroy()
        ButtonSystem.Buttons[id] = nil
    end

    ButtonSystem.Buttons[id] = button
    return button
end

ButtonSystem.GetAllButtons = function()
    return ButtonSystem.Buttons
end

local ToggleSystem = {}

ToggleSystem.Toggles = {}

ToggleSystem.Create = function(config, parent)
    config = config or {}
    local toggle = {}
    local id = Utility.GenerateUUID()
    local isOn = config.Default or false
    local connections = {}

    local toggleFrame = Utility.Create("Frame", {
        Name = "Toggle_" .. (config.Name or "Unnamed"),
        Size = UDim2.new(1, 0, 0, 40),
        BackgroundColor3 = ThemeManager.CurrentTheme.Surface,
        BackgroundTransparency = 0.8,
        BorderSizePixel = 0,
        LayoutOrder = #parent:GetChildren(),
        Parent = parent
    })

    local corner = Utility.Create("UICorner", {
        CornerRadius = UDim.new(0, 8),
        Parent = toggleFrame
    })

    local highlight = Utility.CreateHighlight(toggleFrame, Color3.fromRGB(255, 255, 255), 1, 0.15)

    local label = Utility.Create("TextLabel", {
        Name = "Label",
        Size = UDim2.new(1, -80, 1, 0),
        Position = UDim2.new(0, 10, 0, 0),
        BackgroundTransparency = 1,
        Text = config.Name or "Toggle",
        TextColor3 = ThemeManager.CurrentTheme.TextPrimary,
        TextSize = 14,
        Font = Enum.Font.Code,
        TextXAlignment = Enum.TextXAlignment.Left,
        TextTruncate = Enum.TextTruncate.AtEnd,
        Parent = toggleFrame
    })

    local switchFrame = Utility.Create("Frame", {
        Name = "Switch",
        Size = UDim2.new(0, 50, 0, 26),
        Position = UDim2.new(1, -60, 0.5, -13),
        BackgroundColor3 = isOn and ThemeManager.CurrentTheme.Primary or Color3.fromRGB(100, 100, 100),
        BorderSizePixel = 0,
        Parent = toggleFrame
    })

    local switchCorner = Utility.Create("UICorner", {
        CornerRadius = UDim.new(1, 0),
        Parent = switchFrame
    })

    local knob = Utility.Create("Frame", {
        Name = "Knob",
        Size = UDim2.new(0, 22, 0, 22),
        Position = isOn and UDim2.new(1, -24, 0.5, -11) or UDim2.new(0, 2, 0.5, -11),
        BackgroundColor3 = Color3.fromRGB(255, 255, 255),
        BorderSizePixel = 0,
        Parent = switchFrame
    })

    local knobCorner = Utility.Create("UICorner", {
        CornerRadius = UDim.new(1, 0),
        Parent = knob
    })

    local clickArea = Utility.Create("TextButton", {
        Name = "ClickArea",
        Size = UDim2.new(1, 0, 1, 0),
        BackgroundTransparency = 1,
        Text = "",
        Parent = toggleFrame
    })

    local function update(animate)
        animate = animate ~= false
        local tweenInfo = animate and TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out) or nil

        if isOn then
            if animate then
                Utility.Tween(switchFrame, tweenInfo, {BackgroundColor3 = ThemeManager.CurrentTheme.Primary})
                Utility.Tween(knob, tweenInfo, {Position = UDim2.new(1, -24, 0.5, -11)})
            else
                switchFrame.BackgroundColor3 = ThemeManager.CurrentTheme.Primary
                knob.Position = UDim2.new(1, -24, 0.5, -11)
            end
        else
            if animate then
                Utility.Tween(switchFrame, tweenInfo, {BackgroundColor3 = Color3.fromRGB(100, 100, 100)})
                Utility.Tween(knob, tweenInfo, {Position = UDim2.new(0, 2, 0.5, -11)})
            else
                switchFrame.BackgroundColor3 = Color3.fromRGB(100, 100, 100)
                knob.Position = UDim2.new(0, 2, 0.5, -11)
            end
        end

        if config.Callback then
            config.Callback(isOn)
        end

        EventBus.Publish("ToggleChanged", id, config.Name, isOn)
    end

    table.insert(connections, clickArea.MouseButton1Click:Connect(function()
        isOn = not isOn
        update()
    end))

    table.insert(connections, toggleFrame.MouseEnter:Connect(function()
        Utility.Tween(toggleFrame, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
            BackgroundTransparency = 0.6
        })
    end))

    table.insert(connections, toggleFrame.MouseLeave:Connect(function()
        Utility.Tween(toggleFrame, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
            BackgroundTransparency = 0.8
        })
    end))

    toggle.ID = id
    toggle.Instance = toggleFrame
    toggle.GetValue = function() return isOn end
    toggle.SetValue = function(value, animate)
        isOn = value
        update(animate)
    end
    toggle.Toggle = function()
        isOn = not isOn
        update()
        return isOn
    end
    toggle.SetVisible = function(visible)
        toggleFrame.Visible = visible
    end
    toggle.Destroy = function()
        for _, conn in ipairs(connections) do
            conn:Disconnect()
        end
        toggleFrame:Destroy()
        ToggleSystem.Toggles[id] = nil
    end

    update(false)
    ToggleSystem.Toggles[id] = toggle
    return toggle
end

ToggleSystem.GetAllToggles = function()
    return ToggleSystem.Toggles
end

local SliderSystem = {}

SliderSystem.Sliders = {}

SliderSystem.Create = function(config, parent)
    config = config or {}
    local slider = {}
    local id = Utility.GenerateUUID()
    local min = config.Min or 0
    local max = config.Max or 100
    local value = config.Default or min
    local decimals = config.Decimals or 0
    local connections = {}

    local sliderFrame = Utility.Create("Frame", {
        Name = "Slider_" .. (config.Name or "Unnamed"),
        Size = UDim2.new(1, 0, 0, 60),
        BackgroundColor3 = ThemeManager.CurrentTheme.Surface,
        BackgroundTransparency = 0.8,
        BorderSizePixel = 0,
        LayoutOrder = #parent:GetChildren(),
        Parent = parent
    })

    local corner = Utility.Create("UICorner", {
        CornerRadius = UDim.new(0, 8),
        Parent = sliderFrame
    })

    local highlight = Utility.CreateHighlight(sliderFrame, Color3.fromRGB(255, 255, 255), 1, 0.15)

    local label = Utility.Create("TextLabel", {
        Name = "Label",
        Size = UDim2.new(1, -100, 0, 20),
        Position = UDim2.new(0, 10, 0, 5),
        BackgroundTransparency = 1,
        Text = config.Name or "Slider",
        TextColor3 = ThemeManager.CurrentTheme.TextPrimary,
        TextSize = 14,
        Font = Enum.Font.Code,
        TextXAlignment = Enum.TextXAlignment.Left,
        TextTruncate = Enum.TextTruncate.AtEnd,
        Parent = sliderFrame
    })

    local valueLabel = Utility.Create("TextLabel", {
        Name = "ValueLabel",
        Size = UDim2.new(0, 80, 0, 20),
        Position = UDim2.new(1, -90, 0, 5),
        BackgroundTransparency = 1,
        Text = tostring(value),
        TextColor3 = ThemeManager.CurrentTheme.Primary,
        TextSize = 14,
        Font = Enum.Font.Code,
        TextXAlignment = Enum.TextXAlignment.Right,
        Parent = sliderFrame
    })

    local track = Utility.Create("Frame", {
        Name = "Track",
        Size = UDim2.new(1, -20, 0, 6),
        Position = UDim2.new(0, 10, 0, 35),
        BackgroundColor3 = Color3.fromRGB(60, 60, 60),
        BorderSizePixel = 0,
        Parent = sliderFrame
    })

    local trackCorner = Utility.Create("UICorner", {
        CornerRadius = UDim.new(1, 0),
        Parent = track
    })

    local fill = Utility.Create("Frame", {
        Name = "Fill",
        Size = UDim2.new((value - min) / (max - min), 0, 1, 0),
        BackgroundColor3 = ThemeManager.CurrentTheme.Primary,
        BorderSizePixel = 0,
        Parent = track
    })

    local fillCorner = Utility.Create("UICorner", {
        CornerRadius = UDim.new(1, 0),
        Parent = fill
    })

    local knob = Utility.Create("Frame", {
        Name = "Knob",
        Size = UDim2.new(0, 16, 0, 16),
        Position = UDim2.new((value - min) / (max - min), -8, 0.5, -8),
        BackgroundColor3 = Color3.fromRGB(255, 255, 255),
        BorderSizePixel = 0,
        Parent = track
    })

    local knobCorner = Utility.Create("UICorner", {
        CornerRadius = UDim.new(1, 0),
        Parent = knob
    })

    local knobStroke = Utility.Create("UIStroke", {
        Color = ThemeManager.CurrentTheme.Primary,
        Thickness = 2,
        Parent = knob
    })

    local isDragging = false

    local function update(input, fireCallback)
        fireCallback = fireCallback ~= false
        local pos = input.Position.X
        local relativePos = pos - track.AbsolutePosition.X
        local percentage = math.clamp(relativePos / track.AbsoluteSize.X, 0, 1)
        value = min + (max - min) * percentage

        if decimals == 0 then
            value = math.floor(value + 0.5)
        else
            value = math.floor(value * (10 ^ decimals) + 0.5) / (10 ^ decimals)
        end

        fill.Size = UDim2.new(percentage, 0, 1, 0)
        knob.Position = UDim2.new(percentage, -8, 0.5, -8)
        valueLabel.Text = tostring(value)

        if fireCallback and config.Callback then
            config.Callback(value)
        end

        if fireCallback then
            EventBus.Publish("SliderChanged", id, config.Name, value)
        end
    end

    table.insert(connections, track.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or 
           input.UserInputType == Enum.UserInputType.Touch then
            isDragging = true
            update(input)
        end
    end))

    table.insert(connections, UserInputService.InputChanged:Connect(function(input)
        if isDragging and (input.UserInputType == Enum.UserInputType.MouseMovement or 
                          input.UserInputType == Enum.UserInputType.Touch) then
            update(input, config.Continuous ~= false)
        end
    end))

    table.insert(connections, UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or 
           input.UserInputType == Enum.UserInputType.Touch then
            if isDragging then
                isDragging = false
                if config.Callback then
                    config.Callback(value)
                end
            end
        end
    end))

    table.insert(connections, sliderFrame.MouseEnter:Connect(function()
        Utility.Tween(sliderFrame, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
            BackgroundTransparency = 0.6
        })
    end))

    table.insert(connections, sliderFrame.MouseLeave:Connect(function()
        Utility.Tween(sliderFrame, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
            BackgroundTransparency = 0.8
        })
    end))

    slider.ID = id
    slider.Instance = sliderFrame
    slider.GetValue = function() return value end
    slider.SetValue = function(newValue, fireCallback)
        fireCallback = fireCallback ~= false
        value = math.clamp(newValue, min, max)
        local percentage = (value - min) / (max - min)
        fill.Size = UDim2.new(percentage, 0, 1, 0)
        knob.Position = UDim2.new(percentage, -8, 0.5, -8)
        valueLabel.Text = tostring(value)

        if fireCallback and config.Callback then
            config.Callback(value)
        end
    end
    slider.SetMin = function(newMin)
        min = newMin
        slider.SetValue(value)
    end
    slider.SetMax = function(newMax)
        max = newMax
        slider.SetValue(value)
    end
    slider.SetVisible = function(visible)
        sliderFrame.Visible = visible
    end
    slider.Destroy = function()
        for _, conn in ipairs(connections) do
            conn:Disconnect()
        end
        sliderFrame:Destroy()
        SliderSystem.Sliders[id] = nil
    end

    SliderSystem.Sliders[id] = slider
    return slider
end

SliderSystem.GetAllSliders = function()
    return SliderSystem.Sliders
end

local DropdownSystem = {}

DropdownSystem.Dropdowns = {}

DropdownSystem.Create = function(config, parent)
    config = config or {}
    local dropdown = {}
    local id = Utility.GenerateUUID()
    local isOpen = false
    local selected = config.Default or nil
    local options = config.Options or {}
    local connections = {}
    local optionButtons = {}

    local dropdownFrame = Utility.Create("Frame", {
        Name = "Dropdown_" .. (config.Name or "Unnamed"),
        Size = UDim2.new(1, 0, 0, 40),
        BackgroundColor3 = ThemeManager.CurrentTheme.Surface,
        BackgroundTransparency = 0.8,
        BorderSizePixel = 0,
        ClipsDescendants = true,
        LayoutOrder = #parent:GetChildren(),
        Parent = parent
    })

    local corner = Utility.Create("UICorner", {
        CornerRadius = UDim.new(0, 8),
        Parent = dropdownFrame
    })

    local highlight = Utility.CreateHighlight(dropdownFrame, Color3.fromRGB(255, 255, 255), 1, 0.15)

    local label = Utility.Create("TextLabel", {
        Name = "Label",
        Size = UDim2.new(1, -50, 0, 40),
        Position = UDim2.new(0, 10, 0, 0),
        BackgroundTransparency = 1,
        Text = config.Name or "Dropdown",
        TextColor3 = ThemeManager.CurrentTheme.TextPrimary,
        TextSize = 14,
        Font = Enum.Font.Code,
        TextXAlignment = Enum.TextXAlignment.Left,
        TextTruncate = Enum.TextTruncate.AtEnd,
        Parent = dropdownFrame
    })

    local selectedLabel = Utility.Create("TextLabel", {
        Name = "Selected",
        Size = UDim2.new(1, -50, 0, 40),
        Position = UDim2.new(0, 10, 0, 0),
        BackgroundTransparency = 1,
        Text = selected or "Select...",
        TextColor3 = ThemeManager.CurrentTheme.Primary,
        TextSize = 14,
        Font = Enum.Font.Code,
        TextXAlignment = Enum.TextXAlignment.Right,
        TextTruncate = Enum.TextTruncate.AtEnd,
        Parent = dropdownFrame
    })

    local arrow = Utility.Create("ImageLabel", {
        Name = "Arrow",
        Size = UDim2.new(0, 20, 0, 20),
        Position = UDim2.new(1, -30, 0.5, -10),
        BackgroundTransparency = 1,
        Image = GetIcon("chevron-down"),
        ImageColor3 = ThemeManager.CurrentTheme.TextSecondary,
        Rotation = 0,
        Parent = dropdownFrame
    })

    local clickArea = Utility.Create("TextButton", {
        Name = "ClickArea",
        Size = UDim2.new(1, 0, 0, 40),
        BackgroundTransparency = 1,
        Text = "",
        Parent = dropdownFrame
    })

    local optionsFrame = Utility.Create("Frame", {
        Name = "Options",
        Size = UDim2.new(1, -20, 0, 0),
        Position = UDim2.new(0, 10, 0, 45),
        BackgroundColor3 = ThemeManager.CurrentTheme.Surface,
        BackgroundTransparency = 0.5,
        BorderSizePixel = 0,
        Visible = false,
        Parent = dropdownFrame
    })

    local optionsCorner = Utility.Create("UICorner", {
        CornerRadius = UDim.new(0, 6),
        Parent = optionsFrame
    })

    local optionsList = Utility.Create("ScrollingFrame", {
        Name = "OptionsList",
        Size = UDim2.new(1, -10, 1, -10),
        Position = UDim2.new(0, 5, 0, 5),
        BackgroundTransparency = 1,
        ScrollBarThickness = 4,
        ScrollBarImageColor3 = ThemeManager.CurrentTheme.Primary,
        CanvasSize = UDim2.new(0, 0, 0, 0),
        AutomaticCanvasSize = Enum.AutomaticSize.Y,
        Parent = optionsFrame
    })

    local listLayout = Utility.Create("UIListLayout", {
        Padding = UDim.new(0, 2),
        SortOrder = Enum.SortOrder.LayoutOrder,
        Parent = optionsList
    })

    local function createOptions()
        for _, btn in ipairs(optionButtons) do
            btn:Destroy()
        end
        optionButtons = {}

        for i, option in ipairs(options) do
            local btn = Utility.Create("TextButton", {
                Name = "Option_" .. tostring(i),
                Size = UDim2.new(1, 0, 0, 30),
                BackgroundColor3 = option == selected and ThemeManager.CurrentTheme.Primary or Color3.fromRGB(50, 50, 50),
                BackgroundTransparency = option == selected and 0.7 or 0.9,
                Text = option,
                TextColor3 = option == selected and Color3.fromRGB(255, 255, 255) or ThemeManager.CurrentTheme.TextSecondary,
                TextSize = 13,
                Font = Enum.Font.Code,
                Parent = optionsList
            })

            local btnCorner = Utility.Create("UICorner", {
                CornerRadius = UDim.new(0, 4),
                Parent = btn
            })

            btn.MouseButton1Click:Connect(function()
                selected = option
                selectedLabel.Text = selected

                for _, b in ipairs(optionButtons) do
                    b.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
                    b.BackgroundTransparency = 0.9
                    b.TextColor3 = ThemeManager.CurrentTheme.TextSecondary
                end

                btn.BackgroundColor3 = ThemeManager.CurrentTheme.Primary
                btn.BackgroundTransparency = 0.7
                btn.TextColor3 = Color3.fromRGB(255, 255, 255)

                if config.Callback then
                    config.Callback(selected)
                end

                EventBus.Publish("DropdownSelected", id, config.Name, selected)

                toggle()
            end)

            table.insert(optionButtons, btn)
        end
    end

    local function toggle()
        isOpen = not isOpen
        if isOpen then
            createOptions()
            optionsFrame.Visible = true
            local height = math.min(#options * 32 + 10, 200)
            Utility.Tween(dropdownFrame, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
                Size = UDim2.new(1, 0, 0, 50 + height)
            })
            Utility.Tween(arrow, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
                Rotation = 180
            })
        else
            Utility.Tween(dropdownFrame, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
                Size = UDim2.new(1, 0, 0, 40)
            })
            Utility.Tween(arrow, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
                Rotation = 0
            }).Completed:Connect(function()
                optionsFrame.Visible = false
            end)
        end
    end

    table.insert(connections, clickArea.MouseButton1Click:Connect(toggle))

    table.insert(connections, dropdownFrame.MouseEnter:Connect(function()
        Utility.Tween(dropdownFrame, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
            BackgroundTransparency = 0.6
        })
    end))

    table.insert(connections, dropdownFrame.MouseLeave:Connect(function()
        if not isOpen then
            Utility.Tween(dropdownFrame, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
                BackgroundTransparency = 0.8
            })
        end
    end))

    dropdown.ID = id
    dropdown.Instance = dropdownFrame
    dropdown.GetSelected = function() return selected end
    dropdown.SetOptions = function(newOptions)
        options = newOptions
        if isOpen then
            createOptions()
        end
    end
    dropdown.GetOptions = function() return options end
    dropdown.SetSelected = function(value, fireCallback)
        fireCallback = fireCallback ~= false
        selected = value
        selectedLabel.Text = selected or "Select..."

        if fireCallback and config.Callback then
            config.Callback(selected)
        end

        if isOpen then
            createOptions()
        end
    end
    dropdown.Open = function() if not isOpen then toggle() end end
    dropdown.Close = function() if isOpen then toggle() end end
    dropdown.IsOpen = function() return isOpen end
    dropdown.SetVisible = function(visible)
        dropdownFrame.Visible = visible
    end
    dropdown.Destroy = function()
        for _, conn in ipairs(connections) do
            conn:Disconnect()
        end
        dropdownFrame:Destroy()
        DropdownSystem.Dropdowns[id] = nil
    end

    DropdownSystem.Dropdowns[id] = dropdown
    return dropdown
end

DropdownSystem.GetAllDropdowns = function()
    return DropdownSystem.Dropdowns
end

local InputSystem = {}

InputSystem.Inputs = {}

InputSystem.Create = function(config, parent)
    config = config or {}
    local input = {}
    local id = Utility.GenerateUUID()
    local text = config.Default or ""
    local placeholder = config.Placeholder or "Enter text..."
    local isMultiline = config.Multiline or false
    local isPassword = config.Password or false
    local connections = {}

    local inputFrame = Utility.Create("Frame", {
        Name = "Input_" .. (config.Name or "Unnamed"),
        Size = UDim2.new(1, 0, 0, isMultiline and 80 or 40),
        BackgroundColor3 = ThemeManager.CurrentTheme.Surface,
        BackgroundTransparency = 0.8,
        BorderSizePixel = 0,
        LayoutOrder = #parent:GetChildren(),
        Parent = parent
    })

    local corner = Utility.Create("UICorner", {
        CornerRadius = UDim.new(0, 8),
        Parent = inputFrame
    })

    local highlight = Utility.CreateHighlight(inputFrame, Color3.fromRGB(255, 255, 255), 1, 0.15)

    local label = Utility.Create("TextLabel", {
        Name = "Label",
        Size = UDim2.new(1, -20, 0, 20),
        Position = UDim2.new(0, 10, 0, 5),
        BackgroundTransparency = 1,
        Text = config.Name or "Input",
        TextColor3 = ThemeManager.CurrentTheme.TextSecondary,
        TextSize = 12,
        Font = Enum.Font.Code,
        TextXAlignment = Enum.TextXAlignment.Left,
        TextTruncate = Enum.TextTruncate.AtEnd,
        Parent = inputFrame
    })

    local textBox = Utility.Create("TextBox", {
        Name = "TextBox",
        Size = UDim2.new(1, -20, 0, isMultiline and 50 or 25),
        Position = UDim2.new(0, 10, 0, isMultiline and 25 or 25),
        BackgroundColor3 = Color3.fromRGB(40, 40, 40),
        BackgroundTransparency = 0.5,
        Text = text,
        PlaceholderText = placeholder,
        TextColor3 = ThemeManager.CurrentTheme.TextPrimary,
        PlaceholderColor3 = ThemeManager.CurrentTheme.TextDisabled,
        TextSize = 14,
        Font = Enum.Font.Code,
        ClearTextOnFocus = false,
        MultiLine = isMultiline,
        TextWrapped = isMultiline,
        TextXAlignment = Enum.TextXAlignment.Left,
        TextYAlignment = isMultiline and Enum.TextYAlignment.Top or Enum.TextYAlignment.Center,
        Parent = inputFrame
    })

    local boxCorner = Utility.Create("UICorner", {
        CornerRadius = UDim.new(0, 6),
        Parent = textBox
    })

    local boxStroke = Utility.Create("UIStroke", {
        Color = ThemeManager.CurrentTheme.Border,
        Thickness = 1,
        Transparency = 0.5,
        Parent = textBox
    })

    local actualText = text

    if isPassword then
        textBox.Text = string.rep("•", #text)

        table.insert(connections, textBox:GetPropertyChangedSignal("Text"):Connect(function()
            local newText = textBox.Text
            if newText:match("•") then
                return
            end
            actualText = newText
            textBox.Text = string.rep("•", #actualText)
        end))
    end

    table.insert(connections, textBox.Focused:Connect(function()
        Utility.Tween(boxStroke, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
            Color = ThemeManager.CurrentTheme.Primary,
            Transparency = 0.2
        })
    end))

    table.insert(connections, textBox.FocusLost:Connect(function(enterPressed)
        Utility.Tween(boxStroke, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
            Color = ThemeManager.CurrentTheme.Border,
            Transparency = 0.5
        })
        text = isPassword and actualText or textBox.Text
        if config.Callback then
            config.Callback(text, enterPressed)
        end
        EventBus.Publish("InputChanged", id, config.Name, text)
    end))

    table.insert(connections, textBox:GetPropertyChangedSignal("Text"):Connect(function()
        if config.OnChanged then
            config.OnChanged(isPassword and actualText or textBox.Text)
        end
    end))

    table.insert(connections, inputFrame.MouseEnter:Connect(function()
        Utility.Tween(inputFrame, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
            BackgroundTransparency = 0.6
        })
    end))

    table.insert(connections, inputFrame.MouseLeave:Connect(function()
        Utility.Tween(inputFrame, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
            BackgroundTransparency = 0.8
        })
    end))

    input.ID = id
    input.Instance = inputFrame
    input.TextBox = textBox
    input.GetText = function()
        return isPassword and actualText or textBox.Text
    end
    input.SetText = function(newText)
        text = newText
        actualText = newText
        if isPassword then
            textBox.Text = string.rep("•", #newText)
        else
            textBox.Text = newText
        end
    end
    input.Focus = function()
        textBox:CaptureFocus()
    end
    input.Clear = function()
        text = ""
        actualText = ""
        textBox.Text = ""
    end
    input.SetPlaceholder = function(newPlaceholder)
        textBox.PlaceholderText = newPlaceholder
    end
    input.SetVisible = function(visible)
        inputFrame.Visible = visible
    end
    input.Destroy = function()
        for _, conn in ipairs(connections) do
            conn:Disconnect()
        end
        inputFrame:Destroy()
        InputSystem.Inputs[id] = nil
    end

    InputSystem.Inputs[id] = input
    return input
end

InputSystem.GetAllInputs = function()
    return InputSystem.Inputs
end

local KeybindSystem = {}

KeybindSystem.Keybinds = {}

KeybindSystem.Create = function(config, parent)
    config = config or {}
    local keybind = {}
    local id = Utility.GenerateUUID()
    local key = config.Default or nil
    local isListening = false
    local connections = {}

    local keybindFrame = Utility.Create("Frame", {
        Name = "Keybind_" .. (config.Name or "Unnamed"),
        Size = UDim2.new(1, 0, 0, 40),
        BackgroundColor3 = ThemeManager.CurrentTheme.Surface,
        BackgroundTransparency = 0.8,
        BorderSizePixel = 0,
        LayoutOrder = #parent:GetChildren(),
        Parent = parent
    })

    local corner = Utility.Create("UICorner", {
        CornerRadius = UDim.new(0, 8),
        Parent = keybindFrame
    })

    local highlight = Utility.CreateHighlight(keybindFrame, Color3.fromRGB(255, 255, 255), 1, 0.15)

    local label = Utility.Create("TextLabel", {
        Name = "Label",
        Size = UDim2.new(1, -100, 1, 0),
        Position = UDim2.new(0, 10, 0, 0),
        BackgroundTransparency = 1,
        Text = config.Name or "Keybind",
        TextColor3 = ThemeManager.CurrentTheme.TextPrimary,
        TextSize = 14,
        Font = Enum.Font.Code,
        TextXAlignment = Enum.TextXAlignment.Left,
        TextTruncate = Enum.TextTruncate.AtEnd,
        Parent = keybindFrame
    })

    local keyButton = Utility.Create("TextButton", {
        Name = "KeyButton",
        Size = UDim2.new(0, 80, 0, 30),
        Position = UDim2.new(1, -90, 0.5, -15),
        BackgroundColor3 = ThemeManager.CurrentTheme.Primary,
        BackgroundTransparency = 0.7,
        Text = key and key.Name or "None",
        TextColor3 = Color3.fromRGB(255, 255, 255),
        TextSize = 12,
        Font = Enum.Font.Code,
        AutoButtonColor = false,
        Parent = keybindFrame
    })

    local keyCorner = Utility.Create("UICorner", {
        CornerRadius = UDim.new(0, 6),
        Parent = keyButton
    })

    local function setKey(newKey)
        key = newKey
        keyButton.Text = key and key.Name or "None"
        if config.Callback then
            config.Callback(key)
        end
        EventBus.Publish("KeybindChanged", id, config.Name, key)
    end

    table.insert(connections, keyButton.MouseButton1Click:Connect(function()
        isListening = true
        keyButton.Text = "..."
        Utility.Tween(keyButton, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
            BackgroundTransparency = 0.3
        })
    end))

    table.insert(connections, UserInputService.InputBegan:Connect(function(input, gameProcessed)
        if isListening and not gameProcessed then
            if input.UserInputType == Enum.UserInputType.Keyboard then
                setKey(input.KeyCode)
                isListening = false
                Utility.Tween(keyButton, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
                    BackgroundTransparency = 0.7
                })
            elseif input.UserInputType == Enum.UserInputType.MouseButton1 then
                setKey(Enum.UserInputType.MouseButton1)
                isListening = false
                Utility.Tween(keyButton, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
                    BackgroundTransparency = 0.7
                })
            elseif input.UserInputType == Enum.UserInputType.MouseButton2 then
                setKey(Enum.UserInputType.MouseButton2)
                isListening = false
                Utility.Tween(keyButton, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
                    BackgroundTransparency = 0.7
                })
            end
        elseif key and not gameProcessed then
            if input.KeyCode == key or input.UserInputType == key then
                if config.OnPressed then
                    config.OnPressed()
                end
                EventBus.Publish("KeybindPressed", id, config.Name)
            end
        end
    end))

    table.insert(connections, keybindFrame.MouseEnter:Connect(function()
        Utility.Tween(keybindFrame, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
            BackgroundTransparency = 0.6
        })
    end))

    table.insert(connections, keybindFrame.MouseLeave:Connect(function()
        Utility.Tween(keybindFrame, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
            BackgroundTransparency = 0.8
        })
    end))

    keybind.ID = id
    keybind.Instance = keybindFrame
    keybind.GetKey = function() return key end
    keybind.SetKey = setKey
    keybind.SetVisible = function(visible)
        keybindFrame.Visible = visible
    end
    keybind.Destroy = function()
        for _, conn in ipairs(connections) do
            conn:Disconnect()
        end
        keybindFrame:Destroy()
        KeybindSystem.Keybinds[id] = nil
    end

    KeybindSystem.Keybinds[id] = keybind
    return keybind
end

KeybindSystem.GetAllKeybinds = function()
    return KeybindSystem.Keybinds
end

local LabelSystem = {}

LabelSystem.Labels = {}

LabelSystem.Create = function(config, parent)
    config = config or {}
    local label = {}
    local id = Utility.GenerateUUID()

    local labelFrame = Utility.Create("Frame", {
        Name = "Label_" .. (config.Name or "Unnamed"),
        Size = UDim2.new(1, 0, 0, config.Height or 30),
        BackgroundTransparency = 1,
        LayoutOrder = #parent:GetChildren(),
        Parent = parent
    })

    local textLabel = Utility.Create("TextLabel", {
        Name = "Text",
        Size = UDim2.new(1, -20, 1, 0),
        Position = UDim2.new(0, 10, 0, 0),
        BackgroundTransparency = 1,
        Text = config.Text or config.Name or "Label",
        TextColor3 = config.Color or ThemeManager.CurrentTheme.TextPrimary,
        TextSize = config.Size or 14,
        Font = config.Font or Enum.Font.Code,
        TextXAlignment = config.Alignment or Enum.TextXAlignment.Left,
        TextYAlignment = config.VAlignment or Enum.TextYAlignment.Center,
        TextWrapped = config.Wrapped or false,
        TextTruncate = config.Truncate or Enum.TextTruncate.None,
        RichText = config.RichText or false,
        Parent = labelFrame
    })

    if config.RichText then
        textLabel.RichText = true
    end

    label.ID = id
    label.Instance = labelFrame
    label.SetText = function(text)
        textLabel.Text = text
    end
    label.GetText = function()
        return textLabel.Text
    end
    label.SetColor = function(color)
        textLabel.TextColor3 = color
    end
    label.SetFont = function(font)
        textLabel.Font = font
    end
    label.SetSize = function(size)
        textLabel.TextSize = size
    end
    label.SetAlignment = function(alignment)
        textLabel.TextXAlignment = alignment
    end
    label.SetVisible = function(visible)
        labelFrame.Visible = visible
    end
    label.Destroy = function()
        labelFrame:Destroy()
        LabelSystem.Labels[id] = nil
    end

    LabelSystem.Labels[id] = label
    return label
end

LabelSystem.GetAllLabels = function()
    return LabelSystem.Labels
end

local DividerSystem = {}

DividerSystem.Dividers = {}

DividerSystem.Create = function(parent, config)
    config = config or {}
    local divider = {}
    local id = Utility.GenerateUUID()

    local dividerFrame = Utility.Create("Frame", {
        Name = "Divider",
        Size = UDim2.new(1, -20, 0, config.Thickness or 1),
        Position = UDim2.new(0, 10, 0, 0),
        BackgroundColor3 = config.Color or ThemeManager.CurrentTheme.Divider,
        BackgroundTransparency = config.Transparency or 0.5,
        BorderSizePixel = 0,
        LayoutOrder = #parent:GetChildren(),
        Parent = parent
    })

    if config.Style == "gradient" then
        local gradient = Utility.Create("UIGradient", {
            Color = ColorSequence.new({
                ColorSequenceKeypoint.new(0, dividerFrame.BackgroundColor3),
                ColorSequenceKeypoint.new(0.5, dividerFrame.BackgroundColor3),
                ColorSequenceKeypoint.new(1, dividerFrame.BackgroundColor3)
            }),
            Transparency = NumberSequence.new({
                NumberSequenceKeypoint.new(0, 1),
                NumberSequenceKeypoint.new(0.5, 0),
                NumberSequenceKeypoint.new(1, 1)
            }),
            Parent = dividerFrame
        })
    end

    divider.ID = id
    divider.Instance = dividerFrame
    divider.SetColor = function(color)
        dividerFrame.BackgroundColor3 = color
    end
    divider.SetThickness = function(thickness)
        dividerFrame.Size = UDim2.new(1, -20, 0, thickness)
    end
    divider.SetVisible = function(visible)
        dividerFrame.Visible = visible
    end
    divider.Destroy = function()
        dividerFrame:Destroy()
        DividerSystem.Dividers[id] = nil
    end

    DividerSystem.Dividers[id] = divider
    return divider
end

DividerSystem.GetAllDividers = function()
    return DividerSystem.Dividers
end

local ColorPickerSystem = {}

ColorPickerSystem.ColorPickers = {}

ColorPickerSystem.Create = function(config, parent)
    config = config or {}
    local colorPicker = {}
    local id = Utility.GenerateUUID()
    local color = config.Default or Color3.fromRGB(255, 255, 255)
    local isOpen = false
    local connections = {}
    local h, s, v = Utility.RGBtoHSV(color)

    local pickerFrame = Utility.Create("Frame", {
        Name = "ColorPicker_" .. (config.Name or "Unnamed"),
        Size = UDim2.new(1, 0, 0, 40),
        BackgroundColor3 = ThemeManager.CurrentTheme.Surface,
        BackgroundTransparency = 0.8,
        BorderSizePixel = 0,
        ClipsDescendants = true,
        LayoutOrder = #parent:GetChildren(),
        Parent = parent
    })

    local corner = Utility.Create("UICorner", {
        CornerRadius = UDim.new(0, 8),
        Parent = pickerFrame
    })

    local highlight = Utility.CreateHighlight(pickerFrame, Color3.fromRGB(255, 255, 255), 1, 0.15)

    local label = Utility.Create("TextLabel", {
        Name = "Label",
        Size = UDim2.new(1, -60, 1, 0),
        Position = UDim2.new(0, 10, 0, 0),
        BackgroundTransparency = 1,
        Text = config.Name or "Color Picker",
        TextColor3 = ThemeManager.CurrentTheme.TextPrimary,
        TextSize = 14,
        Font = Enum.Font.Code,
        TextXAlignment = Enum.TextXAlignment.Left,
        TextTruncate = Enum.TextTruncate.AtEnd,
        Parent = pickerFrame
    })

    local preview = Utility.Create("Frame", {
        Name = "Preview",
        Size = UDim2.new(0, 30, 0, 30),
        Position = UDim2.new(1, -45, 0.5, -15),
        BackgroundColor3 = color,
        BorderSizePixel = 0,
        Parent = pickerFrame
    })

    local previewCorner = Utility.Create("UICorner", {
        CornerRadius = UDim.new(0, 6),
        Parent = preview
    })

    local previewStroke = Utility.Create("UIStroke", {
        Color = ThemeManager.CurrentTheme.Border,
        Thickness = 2,
        Parent = preview
    })

    local clickArea = Utility.Create("TextButton", {
        Name = "ClickArea",
        Size = UDim2.new(1, 0, 0, 40),
        BackgroundTransparency = 1,
        Text = "",
        Parent = pickerFrame
    })

    local pickerPanel = Utility.Create("Frame", {
        Name = "PickerPanel",
        Size = UDim2.new(1, -20, 0, 200),
        Position = UDim2.new(0, 10, 0, 50),
        BackgroundColor3 = ThemeManager.CurrentTheme.Surface,
        BackgroundTransparency = 0.5,
        BorderSizePixel = 0,
        Visible = false,
        Parent = pickerFrame
    })

    local panelCorner = Utility.Create("UICorner", {
        CornerRadius = UDim.new(0, 8),
        Parent = pickerPanel
    })

    local hueFrame = Utility.Create("Frame", {
        Name = "Hue",
        Size = UDim2.new(1, -20, 0, 20),
        Position = UDim2.new(0, 10, 0, 10),
        BackgroundColor3 = Color3.fromRGB(255, 255, 255),
        BorderSizePixel = 0,
        Parent = pickerPanel
    })

    local hueGradient = Utility.Create("UIGradient", {
        Color = ColorSequence.new({
            ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 0, 0)),
            ColorSequenceKeypoint.new(0.17, Color3.fromRGB(255, 255, 0)),
            ColorSequenceKeypoint.new(0.33, Color3.fromRGB(0, 255, 0)),
            ColorSequenceKeypoint.new(0.5, Color3.fromRGB(0, 255, 255)),
            ColorSequenceKeypoint.new(0.67, Color3.fromRGB(0, 0, 255)),
            ColorSequenceKeypoint.new(0.83, Color3.fromRGB(255, 0, 255)),
            ColorSequenceKeypoint.new(1, Color3.fromRGB(255, 0, 0))
        }),
        Parent = hueFrame
    })

    local hueCorner = Utility.Create("UICorner", {
        CornerRadius = UDim.new(0, 4),
        Parent = hueFrame
    })

    local hueKnob = Utility.Create("Frame", {
        Name = "HueKnob",
        Size = UDim2.new(0, 10, 1, 4),
        Position = UDim2.new(h, 0, 0, -2),
        BackgroundColor3 = Color3.fromRGB(255, 255, 255),
        BorderSizePixel = 0,
        Parent = hueFrame
    })

    local hueKnobCorner = Utility.Create("UICorner", {
        CornerRadius = UDim.new(0, 2),
        Parent = hueKnob
    })

    local svFrame = Utility.Create("Frame", {
        Name = "SV",
        Size = UDim2.new(1, -20, 0, 120),
        Position = UDim2.new(0, 10, 0, 40),
        BackgroundColor3 = Utility.HSVtoRGB(h, 1, 1),
        BorderSizePixel = 0,
        Parent = pickerPanel
    })

    local svCorner = Utility.Create("UICorner", {
        CornerRadius = UDim.new(0, 4),
        Parent = svFrame
    })

    local svGradientS = Utility.Create("UIGradient", {
        Color = ColorSequence.new({
            ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 255, 255)),
            ColorSequenceKeypoint.new(1, Color3.fromRGB(255, 255, 255))
        }),
        Transparency = NumberSequence.new({
            NumberSequenceKeypoint.new(0, 1),
            NumberSequenceKeypoint.new(1, 0)
        }),
        Parent = svFrame
    })

    local svGradientV = Utility.Create("Frame", {
        Name = "SVGradientV",
        Size = UDim2.new(1, 0, 1, 0),
        BackgroundColor3 = Color3.fromRGB(0, 0, 0),
        BorderSizePixel = 0,
        Parent = svFrame
    })

    local svGradientVGradient = Utility.Create("UIGradient", {
        Color = ColorSequence.new({
            ColorSequenceKeypoint.new(0, Color3.fromRGB(0, 0, 0)),
            ColorSequenceKeypoint.new(1, Color3.fromRGB(0, 0, 0))
        }),
        Transparency = NumberSequence.new({
            NumberSequenceKeypoint.new(0, 0),
            NumberSequenceKeypoint.new(1, 1)
        }),
        Rotation = 90,
        Parent = svGradientV
    })

    local svKnob = Utility.Create("Frame", {
        Name = "SVKnob",
        Size = UDim2.new(0, 12, 0, 12),
        Position = UDim2.new(s, -6, 1 - v, -6),
        BackgroundColor3 = Color3.fromRGB(255, 255, 255),
        BorderSizePixel = 0,
        Parent = svFrame
    })

    local svKnobCorner = Utility.Create("UICorner", {
        CornerRadius = UDim.new(1, 0),
        Parent = svKnob
    })

    local svKnobStroke = Utility.Create("UIStroke", {
        Color = Color3.fromRGB(0, 0, 0),
        Thickness = 1,
        Parent = svKnob
    })

    local valueLabel = Utility.Create("TextLabel", {
        Name = "ValueLabel",
        Size = UDim2.new(1, -20, 0, 20),
        Position = UDim2.new(0, 10, 0, 170),
        BackgroundTransparency = 1,
        Text = string.format("RGB: %d, %d, %d", math.floor(color.R * 255), math.floor(color.G * 255), math.floor(color.B * 255)),
        TextColor3 = ThemeManager.CurrentTheme.TextSecondary,
        TextSize = 12,
        Font = Enum.Font.Code,
        TextXAlignment = Enum.TextXAlignment.Center,
        Parent = pickerPanel
    })

    local function updateColor()
        color = Utility.HSVtoRGB(h, s, v)
        preview.BackgroundColor3 = color
        valueLabel.Text = string.format("RGB: %d, %d, %d", math.floor(color.R * 255), math.floor(color.G * 255), math.floor(color.B * 255))

        if config.Callback then
            config.Callback(color)
        end

        EventBus.Publish("ColorChanged", id, config.Name, color)
    end

    local hueDragging = false
    local svDragging = false

    table.insert(connections, hueFrame.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            hueDragging = true
            local relativeX = input.Position.X - hueFrame.AbsolutePosition.X
            h = math.clamp(relativeX / hueFrame.AbsoluteSize.X, 0, 1)
            hueKnob.Position = UDim2.new(h, 0, 0, -2)
            svFrame.BackgroundColor3 = Utility.HSVtoRGB(h, 1, 1)
            updateColor()
        end
    end))

    table.insert(connections, svFrame.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            svDragging = true
            local relativePos = Vector2.new(
                input.Position.X - svFrame.AbsolutePosition.X,
                input.Position.Y - svFrame.AbsolutePosition.Y
            )
            s = math.clamp(relativePos.X / svFrame.AbsoluteSize.X, 0, 1)
            v = 1 - math.clamp(relativePos.Y / svFrame.AbsoluteSize.Y, 0, 1)
            svKnob.Position = UDim2.new(s, -6, 1 - v, -6)
            updateColor()
        end
    end))

    table.insert(connections, UserInputService.InputChanged:Connect(function(input)
        if hueDragging and input.UserInputType == Enum.UserInputType.MouseMovement then
            local relativeX = input.Position.X - hueFrame.AbsolutePosition.X
            h = math.clamp(relativeX / hueFrame.AbsoluteSize.X, 0, 1)
            hueKnob.Position = UDim2.new(h, 0, 0, -2)
            svFrame.BackgroundColor3 = Utility.HSVtoRGB(h, 1, 1)
            updateColor()
        elseif svDragging and input.UserInputType == Enum.UserInputType.MouseMovement then
            local relativePos = Vector2.new(
                input.Position.X - svFrame.AbsolutePosition.X,
                input.Position.Y - svFrame.AbsolutePosition.Y
            )
            s = math.clamp(relativePos.X / svFrame.AbsoluteSize.X, 0, 1)
            v = 1 - math.clamp(relativePos.Y / svFrame.AbsoluteSize.Y, 0, 1)
            svKnob.Position = UDim2.new(s, -6, 1 - v, -6)
            updateColor()
        end
    end))

    table.insert(connections, UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            hueDragging = false
            svDragging = false
        end
    end))

    local function toggle()
        isOpen = not isOpen
        if isOpen then
            pickerPanel.Visible = true
            Utility.Tween(pickerFrame, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
                Size = UDim2.new(1, 0, 0, 260)
            })
        else
            Utility.Tween(pickerFrame, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
                Size = UDim2.new(1, 0, 0, 40)
            }).Completed:Connect(function()
                pickerPanel.Visible = false
            end)
        end
    end

    table.insert(connections, clickArea.MouseButton1Click:Connect(toggle))

    table.insert(connections, pickerFrame.MouseEnter:Connect(function()
        Utility.Tween(pickerFrame, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
            BackgroundTransparency = 0.6
        })
    end))

    table.insert(connections, pickerFrame.MouseLeave:Connect(function()
        Utility.Tween(pickerFrame, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
            BackgroundTransparency = 0.8
        })
    end))

    colorPicker.ID = id
    colorPicker.Instance = pickerFrame
    colorPicker.GetColor = function() return color end
    colorPicker.SetColor = function(newColor, fireCallback)
        fireCallback = fireCallback ~= false
        color = newColor
        preview.BackgroundColor3 = color
        h, s, v = Utility.RGBtoHSV(color)
        hueKnob.Position = UDim2.new(h, 0, 0, -2)
        svFrame.BackgroundColor3 = Utility.HSVtoRGB(h, 1, 1)
        svKnob.Position = UDim2.new(s, -6, 1 - v, -6)
        valueLabel.Text = string.format("RGB: %d, %d, %d", math.floor(color.R * 255), math.floor(color.G * 255), math.floor(color.B * 255))

        if fireCallback and config.Callback then
            config.Callback(color)
        end
    end
    colorPicker.Open = function() if not isOpen then toggle() end end
    colorPicker.Close = function() if isOpen then toggle() end end
    colorPicker.IsOpen = function() return isOpen end
    colorPicker.SetVisible = function(visible)
        pickerFrame.Visible = visible
    end
    colorPicker.Destroy = function()
        for _, conn in ipairs(connections) do
            conn:Disconnect()
        end
        pickerFrame:Destroy()
        ColorPickerSystem.ColorPickers[id] = nil
    end

    ColorPickerSystem.ColorPickers[id] = colorPicker
    return colorPicker
end

ColorPickerSystem.GetAllColorPickers = function()
    return ColorPickerSystem.ColorPickers
end

local ProgressBarSystem = {}

ProgressBarSystem.ProgressBars = {}

ProgressBarSystem.Create = function(config, parent)
    config = config or {}
    local progressBar = {}
    local id = Utility.GenerateUUID()
    local progress = config.Default or 0
    local connections = {}

    local barFrame = Utility.Create("Frame", {
        Name = "ProgressBar_" .. (config.Name or "Unnamed"),
        Size = UDim2.new(1, 0, 0, config.Height or 20),
        BackgroundColor3 = config.BackgroundColor or Color3.fromRGB(40, 40, 40),
        BackgroundTransparency = 0.5,
        BorderSizePixel = 0,
        LayoutOrder = #parent:GetChildren(),
        Parent = parent
    })

    local corner = Utility.Create("UICorner", {
        CornerRadius = UDim.new(0, config.Height and config.Height / 2 or 10),
        Parent = barFrame
    })

    local highlight = Utility.CreateHighlight(barFrame, Color3.fromRGB(255, 255, 255), 1, 0.1)

    local fill = Utility.Create("Frame", {
        Name = "Fill",
        Size = UDim2.new(progress / 100, 0, 1, 0),
        BackgroundColor3 = config.FillColor or ThemeManager.CurrentTheme.Primary,
        BorderSizePixel = 0,
        Parent = barFrame
    })

    local fillCorner = Utility.Create("UICorner", {
        CornerRadius = UDim.new(0, config.Height and config.Height / 2 or 10),
        Parent = fill
    })

    local gradient = nil
    if config.Gradient then
        gradient = Utility.Create("UIGradient", {
            Color = ColorSequence.new({
                ColorSequenceKeypoint.new(0, config.Gradient[1] or fill.BackgroundColor3),
                ColorSequenceKeypoint.new(1, config.Gradient[2] or fill.BackgroundColor3)
            }),
            Parent = fill
        })
    end

    local label = Utility.Create("TextLabel", {
        Name = "Label",
        Size = UDim2.new(1, 0, 1, 0),
        BackgroundTransparency = 1,
        Text = config.ShowPercentage and tostring(progress) .. "%" or "",
        TextColor3 = config.TextColor or Color3.fromRGB(255, 255, 255),
        TextSize = 12,
        Font = Enum.Font.Code,
        Parent = barFrame
    })

    progressBar.ID = id
    progressBar.Instance = barFrame
    progressBar.GetProgress = function() return progress end
    progressBar.SetProgress = function(value, animate)
        animate = animate ~= false
        progress = math.clamp(value, 0, 100)

        if animate then
            Utility.Tween(fill, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
                Size = UDim2.new(progress / 100, 0, 1, 0)
            })
        else
            fill.Size = UDim2.new(progress / 100, 0, 1, 0)
        end

        if config.ShowPercentage then
            label.Text = tostring(math.floor(progress)) .. "%"
        end

        if config.Callback then
            config.Callback(progress)
        end

        EventBus.Publish("ProgressChanged", id, config.Name, progress)
    end
    progressBar.Increment = function(amount)
        progressBar.SetProgress(progress + amount)
    end
    progressBar.Decrement = function(amount)
        progressBar.SetProgress(progress - amount)
    end
    progressBar.SetVisible = function(visible)
        barFrame.Visible = visible
    end
    progressBar.Destroy = function()
        for _, conn in ipairs(connections) do
            conn:Disconnect()
        end
        barFrame:Destroy()
        ProgressBarSystem.ProgressBars[id] = nil
    end

    ProgressBarSystem.ProgressBars[id] = progressBar
    return progressBar
end

ProgressBarSystem.GetAllProgressBars = function()
    return ProgressBarSystem.ProgressBars
end

local SpinnerSystem = {}

SpinnerSystem.Spinners = {}

SpinnerSystem.Create = function(config, parent)
    config = config or {}
    local spinner = {}
    local id = Utility.GenerateUUID()

    local spinnerFrame = Utility.Create("Frame", {
        Name = "Spinner_" .. (config.Name or "Unnamed"),
        Size = UDim2.new(0, config.Size or 40, 0, config.Size or 40),
        BackgroundTransparency = 1,
        LayoutOrder = #parent:GetChildren(),
        Parent = parent
    })

    local circle = Utility.Create("ImageLabel", {
        Name = "Circle",
        Size = UDim2.new(1, 0, 1, 0),
        BackgroundTransparency = 1,
        Image = GetIcon("loader"),
        ImageColor3 = config.Color or ThemeManager.CurrentTheme.Primary,
        Parent = spinnerFrame
    })

    local rotation = 0
    local speed = config.Speed or 360
    local running = true

    local connection = RunService.RenderStepped:Connect(function(dt)
        if running then
            rotation = rotation + speed * dt
            circle.Rotation = rotation
        end
    end)

    spinner.ID = id
    spinner.Instance = spinnerFrame
    spinner.Start = function()
        running = true
    end
    spinner.Stop = function()
        running = false
    end
    spinner.SetSpeed = function(newSpeed)
        speed = newSpeed
    end
    spinner.SetColor = function(color)
        circle.ImageColor3 = color
    end
    spinner.SetVisible = function(visible)
        spinnerFrame.Visible = visible
    end
    spinner.Destroy = function()
        connection:Disconnect()
        spinnerFrame:Destroy()
        SpinnerSystem.Spinners[id] = nil
    end

    SpinnerSystem.Spinners[id] = spinner
    return spinner
end

SpinnerSystem.GetAllSpinners = function()
    return SpinnerSystem.Spinners
end

local SearchSystem = {}

SearchSystem.Create = function(config, parent)
    config = config or {}
    local search = {}
    local id = Utility.GenerateUUID()
    local connections = {}

    local searchFrame = Utility.Create("Frame", {
        Name = "Search_" .. (config.Name or "Unnamed"),
        Size = UDim2.new(1, 0, 0, 40),
        BackgroundColor3 = ThemeManager.CurrentTheme.Surface,
        BackgroundTransparency = 0.8,
        BorderSizePixel = 0,
        LayoutOrder = #parent:GetChildren(),
        Parent = parent
    })

    local corner = Utility.Create("UICorner", {
        CornerRadius = UDim.new(0, 8),
        Parent = searchFrame
    })

    local highlight = Utility.CreateHighlight(searchFrame, Color3.fromRGB(255, 255, 255), 1, 0.15)

    local icon = Utility.Create("ImageLabel", {
        Name = "Icon",
        Size = UDim2.new(0, 20, 0, 20),
        Position = UDim2.new(0, 10, 0.5, -10),
        BackgroundTransparency = 1,
        Image = GetIcon("search"),
        ImageColor3 = ThemeManager.CurrentTheme.TextSecondary,
        Parent = searchFrame
    })

    local textBox = Utility.Create("TextBox", {
        Name = "TextBox",
        Size = UDim2.new(1, -50, 0, 30),
        Position = UDim2.new(0, 35, 0.5, -15),
        BackgroundTransparency = 1,
        Text = "",
        PlaceholderText = config.Placeholder or "Search...",
        TextColor3 = ThemeManager.CurrentTheme.TextPrimary,
        PlaceholderColor3 = ThemeManager.CurrentTheme.TextDisabled,
        TextSize = 14,
        Font = Enum.Font.Code,
        ClearTextOnFocus = false,
        Parent = searchFrame
    })

    local clearButton = Utility.Create("ImageButton", {
        Name = "ClearButton",
        Size = UDim2.new(0, 20, 0, 20),
        Position = UDim2.new(1, -30, 0.5, -10),
        BackgroundTransparency = 1,
        Image = GetIcon("x"),
        ImageColor3 = ThemeManager.CurrentTheme.TextSecondary,
        Visible = false,
        Parent = searchFrame
    })

    local function updateSearch()
        local text = textBox.Text
        clearButton.Visible = #text > 0

        if config.Callback then
            config.Callback(text)
        end

        EventBus.Publish("SearchChanged", id, config.Name, text)
    end

    table.insert(connections, textBox:GetPropertyChangedSignal("Text"):Connect(updateSearch))

    table.insert(connections, clearButton.MouseButton1Click:Connect(function()
        textBox.Text = ""
        updateSearch()
    end))

    table.insert(connections, searchFrame.MouseEnter:Connect(function()
        Utility.Tween(searchFrame, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
            BackgroundTransparency = 0.6
        })
    end))

    table.insert(connections, searchFrame.MouseLeave:Connect(function()
        Utility.Tween(searchFrame, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
            BackgroundTransparency = 0.8
        })
    end))

    search.ID = id
    search.Instance = searchFrame
    search.TextBox = textBox
    search.GetText = function() return textBox.Text end
    search.SetText = function(text)
        textBox.Text = text
        updateSearch()
    end
    search.Clear = function()
        textBox.Text = ""
        updateSearch()
    end
    search.Focus = function()
        textBox:CaptureFocus()
    end
    search.SetVisible = function(visible)
        searchFrame.Visible = visible
    end
    search.Destroy = function()
        for _, conn in ipairs(connections) do
            conn:Disconnect()
        end
        searchFrame:Destroy()
    end

    return search
end

local BadgeSystem = {}

BadgeSystem.Create = function(config, parent)
    config = config or {}
    local badge = {}
    local id = Utility.GenerateUUID()

    local badgeFrame = Utility.Create("Frame", {
        Name = "Badge_" .. (config.Name or "Unnamed"),
        Size = config.Size or UDim2.new(0, 20, 0, 20),
        Position = config.Position or UDim2.new(1, -10, 0, -10),
        BackgroundColor3 = config.Color or ThemeManager.CurrentTheme.Error,
        BorderSizePixel = 0,
        Parent = parent
    })

    local corner = Utility.Create("UICorner", {
        CornerRadius = UDim.new(1, 0),
        Parent = badgeFrame
    })

    local highlight = Utility.CreateHighlight(badgeFrame, Color3.fromRGB(255, 255, 255), 1, 0.2)

    local label = Utility.Create("TextLabel", {
        Name = "Label",
        Size = UDim2.new(1, 0, 1, 0),
        BackgroundTransparency = 1,
        Text = config.Text or "",
        TextColor3 = Color3.fromRGB(255, 255, 255),
        TextSize = 10,
        Font = Enum.Font.Code,
        Parent = badgeFrame
    })

    badge.ID = id
    badge.Instance = badgeFrame
    badge.SetText = function(text)
        label.Text = text
        badgeFrame.Visible = #tostring(text) > 0
    end
    badge.SetColor = function(color)
        badgeFrame.BackgroundColor3 = color
    end
    badge.SetVisible = function(visible)
        badgeFrame.Visible = visible
    end
    badge.Destroy = function()
        badgeFrame:Destroy()
    end

    return badge
end

local ImageSystem = {}

ImageSystem.Create = function(config, parent)
    config = config or {}
    local image = {}
    local id = Utility.GenerateUUID()

    local imageFrame = Utility.Create("ImageLabel", {
        Name = "Image_" .. (config.Name or "Unnamed"),
        Size = config.Size or UDim2.new(0, 100, 0, 100),
        Position = config.Position or UDim2.new(0, 0, 0, 0),
        BackgroundColor3 = config.BackgroundColor or ThemeManager.CurrentTheme.Surface,
        BackgroundTransparency = config.BackgroundTransparency or 0.5,
        Image = config.Image or "",
        ImageColor3 = config.ImageColor or Color3.fromRGB(255, 255, 255),
        ScaleType = config.ScaleType or Enum.ScaleType.Stretch,
        BorderSizePixel = 0,
        LayoutOrder = #parent:GetChildren(),
        Parent = parent
    })

    if config.CornerRadius then
        local corner = Utility.Create("UICorner", {
            CornerRadius = UDim.new(0, config.CornerRadius),
            Parent = imageFrame
        })
    end

    if config.Border then
        local stroke = Utility.Create("UIStroke", {
            Color = config.BorderColor or ThemeManager.CurrentTheme.Border,
            Thickness = config.BorderThickness or 1,
            Parent = imageFrame
        })
    end

    if config.Highlight then
        local highlight = Utility.CreateHighlight(imageFrame, Color3.fromRGB(255, 255, 255), 2, 0.2)
    end

    image.ID = id
    image.Instance = imageFrame
    image.SetImage = function(imageId)
        imageFrame.Image = imageId
    end
    image.SetColor = function(color)
        imageFrame.ImageColor3 = color
    end
    image.SetScaleType = function(scaleType)
        imageFrame.ScaleType = scaleType
    end
    image.SetVisible = function(visible)
        imageFrame.Visible = visible
    end
    image.Destroy = function()
        imageFrame:Destroy()
    end

    return image
end

local ContainerSystem = {}

ContainerSystem.Create = function(config, parent)
    config = config or {}
    local container = {}
    local id = Utility.GenerateUUID()

    local containerFrame = Utility.Create("Frame", {
        Name = "Container_" .. (config.Name or "Unnamed"),
        Size = config.Size or UDim2.new(1, 0, 0, 0),
        Position = config.Position or UDim2.new(0, 0, 0, 0),
        AutomaticSize = config.AutomaticSize or Enum.AutomaticSize.Y,
        BackgroundColor3 = config.BackgroundColor or ThemeManager.CurrentTheme.Surface,
        BackgroundTransparency = config.BackgroundTransparency or 0.5,
        BorderSizePixel = 0,
        LayoutOrder = #parent:GetChildren(),
        Parent = parent
    })

    if config.CornerRadius then
        local corner = Utility.Create("UICorner", {
            CornerRadius = UDim.new(0, config.CornerRadius),
            Parent = containerFrame
        })
    end

    if config.Highlight then
        local highlight = Utility.CreateHighlight(containerFrame, Color3.fromRGB(255, 255, 255), 1, 0.15)
    end

    if config.Padding then
        local padding = Utility.Create("UIPadding", {
            PaddingLeft = UDim.new(0, config.Padding.Left or 0),
            PaddingRight = UDim.new(0, config.Padding.Right or 0),
            PaddingTop = UDim.new(0, config.Padding.Top or 0),
            PaddingBottom = UDim.new(0, config.Padding.Bottom or 0),
            Parent = containerFrame
        })
    end

    if config.Layout then
        local layout = Utility.Create("UIListLayout", {
            Padding = UDim.new(0, config.Layout.Padding or 10),
            SortOrder = Enum.SortOrder.LayoutOrder,
            Parent = containerFrame
        })
        container.Layout = layout
    end

    container.ID = id
    container.Instance = containerFrame
    container.SetVisible = function(visible)
        containerFrame.Visible = visible
    end
    container.Destroy = function()
        containerFrame:Destroy()
    end

    return container
end

local RadioButtonSystem = {}

RadioButtonSystem.RadioGroups = {}

RadioButtonSystem.Create = function(config, parent)
    config = config or {}
    local radio = {}
    local id = Utility.GenerateUUID()
    local isSelected = config.Selected or false
    local connections = {}
    local group = config.Group

    if group then
        if not RadioButtonSystem.RadioGroups[group] then
            RadioButtonSystem.RadioGroups[group] = {}
        end
        table.insert(RadioButtonSystem.RadioGroups[group], radio)
    end

    local radioFrame = Utility.Create("Frame", {
        Name = "Radio_" .. (config.Name or "Unnamed"),
        Size = UDim2.new(1, 0, 0, 40),
        BackgroundColor3 = ThemeManager.CurrentTheme.Surface,
        BackgroundTransparency = 0.8,
        BorderSizePixel = 0,
        LayoutOrder = #parent:GetChildren(),
        Parent = parent
    })

    local corner = Utility.Create("UICorner", {
        CornerRadius = UDim.new(0, 8),
        Parent = radioFrame
    })

    local highlight = Utility.CreateHighlight(radioFrame, Color3.fromRGB(255, 255, 255), 1, 0.15)

    local label = Utility.Create("TextLabel", {
        Name = "Label",
        Size = UDim2.new(1, -50, 1, 0),
        Position = UDim2.new(0, 10, 0, 0),
        BackgroundTransparency = 1,
        Text = config.Name or "Radio",
        TextColor3 = ThemeManager.CurrentTheme.TextPrimary,
        TextSize = 14,
        Font = Enum.Font.Code,
        TextXAlignment = Enum.TextXAlignment.Left,
        Parent = radioFrame
    })

    local radioCircle = Utility.Create("Frame", {
        Name = "Circle",
        Size = UDim2.new(0, 20, 0, 20),
        Position = UDim2.new(1, -35, 0.5, -10),
        BackgroundColor3 = Color3.fromRGB(255, 255, 255),
        BorderSizePixel = 0,
        Parent = radioFrame
    })

    local circleCorner = Utility.Create("UICorner", {
        CornerRadius = UDim.new(1, 0),
        Parent = radioCircle
    })

    local circleStroke = Utility.Create("UIStroke", {
        Color = isSelected and ThemeManager.CurrentTheme.Primary or Color3.fromRGB(150, 150, 150),
        Thickness = 2,
        Parent = radioCircle
    })

    local innerCircle = Utility.Create("Frame", {
        Name = "Inner",
        Size = isSelected and UDim2.new(0, 10, 0, 10) or UDim2.new(0, 0, 0, 0),
        Position = UDim2.new(0.5, 0, 0.5, 0),
        AnchorPoint = Vector2.new(0.5, 0.5),
        BackgroundColor3 = ThemeManager.CurrentTheme.Primary,
        BorderSizePixel = 0,
        Parent = radioCircle
    })

    local innerCorner = Utility.Create("UICorner", {
        CornerRadius = UDim.new(1, 0),
        Parent = innerCircle
    })

    local clickArea = Utility.Create("TextButton", {
        Name = "ClickArea",
        Size = UDim2.new(1, 0, 1, 0),
        BackgroundTransparency = 1,
        Text = "",
        Parent = radioFrame
    })

    local function select()
        if group then
            for _, otherRadio in ipairs(RadioButtonSystem.RadioGroups[group]) do
                if otherRadio ~= radio then
                    otherRadio.Deselect()
                end
            end
        end

        isSelected = true
        Utility.Tween(circleStroke, TweenInfo.new(0.2), {Color = ThemeManager.CurrentTheme.Primary})
        Utility.Tween(innerCircle, TweenInfo.new(0.2), {Size = UDim2.new(0, 10, 0, 10)})

        if config.Callback then
            config.Callback(true)
        end

        EventBus.Publish("RadioSelected", id, config.Name, group)
    end

    local function deselect()
        isSelected = false
        Utility.Tween(circleStroke, TweenInfo.new(0.2), {Color = Color3.fromRGB(150, 150, 150)})
        Utility.Tween(innerCircle, TweenInfo.new(0.2), {Size = UDim2.new(0, 0, 0, 0)})

        if config.Callback then
            config.Callback(false)
        end
    end

    table.insert(connections, clickArea.MouseButton1Click:Connect(select))

    table.insert(connections, radioFrame.MouseEnter:Connect(function()
        Utility.Tween(radioFrame, TweenInfo.new(0.2), {BackgroundTransparency = 0.6})
    end))

    table.insert(connections, radioFrame.MouseLeave:Connect(function()
        Utility.Tween(radioFrame, TweenInfo.new(0.2), {BackgroundTransparency = 0.8})
    end))

    radio.ID = id
    radio.Instance = radioFrame
    radio.Select = select
    radio.Deselect = deselect
    radio.IsSelected = function() return isSelected end
    radio.SetVisible = function(visible)
        radioFrame.Visible = visible
    end
    radio.Destroy = function()
        for _, conn in ipairs(connections) do
            conn:Disconnect()
        end
        if group and RadioButtonSystem.RadioGroups[group] then
            for i, r in ipairs(RadioButtonSystem.RadioGroups[group]) do
                if r == radio then
                    table.remove(RadioButtonSystem.RadioGroups[group], i)
                    break
                end
            end
        end
        radioFrame:Destroy()
    end

    if isSelected then
        select()
    end

    return radio
end

local CheckboxSystem = {}

CheckboxSystem.Checkboxes = {}

CheckboxSystem.Create = function(config, parent)
    config = config or {}
    local checkbox = {}
    local id = Utility.GenerateUUID()
    local isChecked = config.Checked or false
    local connections = {}

    local checkboxFrame = Utility.Create("Frame", {
        Name = "Checkbox_" .. (config.Name or "Unnamed"),
        Size = UDim2.new(1, 0, 0, 40),
        BackgroundColor3 = ThemeManager.CurrentTheme.Surface,
        BackgroundTransparency = 0.8,
        BorderSizePixel = 0,
        LayoutOrder = #parent:GetChildren(),
        Parent = parent
    })

    local corner = Utility.Create("UICorner", {
        CornerRadius = UDim.new(0, 8),
        Parent = checkboxFrame
    })

    local highlight = Utility.CreateHighlight(checkboxFrame, Color3.fromRGB(255, 255, 255), 1, 0.15)

    local label = Utility.Create("TextLabel", {
        Name = "Label",
        Size = UDim2.new(1, -50, 1, 0),
        Position = UDim2.new(0, 10, 0, 0),
        BackgroundTransparency = 1,
        Text = config.Name or "Checkbox",
        TextColor3 = ThemeManager.CurrentTheme.TextPrimary,
        TextSize = 14,
        Font = Enum.Font.Code,
        TextXAlignment = Enum.TextXAlignment.Left,
        Parent = checkboxFrame
    })

    local checkBox = Utility.Create("Frame", {
        Name = "Box",
        Size = UDim2.new(0, 20, 0, 20),
        Position = UDim2.new(1, -35, 0.5, -10),
        BackgroundColor3 = isChecked and ThemeManager.CurrentTheme.Primary or Color3.fromRGB(60, 60, 60),
        BorderSizePixel = 0,
        Parent = checkboxFrame
    })

    local boxCorner = Utility.Create("UICorner", {
        CornerRadius = UDim.new(0, 4),
        Parent = checkBox
    })

    local checkMark = Utility.Create("ImageLabel", {
        Name = "Check",
        Size = isChecked and UDim2.new(0, 16, 0, 16) or UDim2.new(0, 0, 0, 0),
        Position = UDim2.new(0.5, 0, 0.5, 0),
        AnchorPoint = Vector2.new(0.5, 0.5),
        BackgroundTransparency = 1,
        Image = GetIcon("check"),
        ImageColor3 = Color3.fromRGB(255, 255, 255),
        Parent = checkBox
    })

    local clickArea = Utility.Create("TextButton", {
        Name = "ClickArea",
        Size = UDim2.new(1, 0, 1, 0),
        BackgroundTransparency = 1,
        Text = "",
        Parent = checkboxFrame
    })

    local function toggle()
        isChecked = not isChecked

        if isChecked then
            Utility.Tween(checkBox, TweenInfo.new(0.2), {BackgroundColor3 = ThemeManager.CurrentTheme.Primary})
            Utility.Tween(checkMark, TweenInfo.new(0.2), {Size = UDim2.new(0, 16, 0, 16)})
        else
            Utility.Tween(checkBox, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(60, 60, 60)})
            Utility.Tween(checkMark, TweenInfo.new(0.2), {Size = UDim2.new(0, 0, 0, 0)})
        end

        if config.Callback then
            config.Callback(isChecked)
        end

        EventBus.Publish("CheckboxChanged", id, config.Name, isChecked)
    end

    table.insert(connections, clickArea.MouseButton1Click:Connect(toggle))

    table.insert(connections, checkboxFrame.MouseEnter:Connect(function()
        Utility.Tween(checkboxFrame, TweenInfo.new(0.2), {BackgroundTransparency = 0.6})
    end))

    table.insert(connections, checkboxFrame.MouseLeave:Connect(function()
        Utility.Tween(checkboxFrame, TweenInfo.new(0.2), {BackgroundTransparency = 0.8})
    end))

    checkbox.ID = id
    checkbox.Instance = checkboxFrame
    checkbox.Toggle = toggle
    checkbox.SetChecked = function(checked)
        if isChecked ~= checked then
            toggle()
        end
    end
    checkbox.IsChecked = function() return isChecked end
    checkbox.SetVisible = function(visible)
        checkboxFrame.Visible = visible
    end
    checkbox.Destroy = function()
        for _, conn in ipairs(connections) do
            conn:Disconnect()
        end
        checkboxFrame:Destroy()
        CheckboxSystem.Checkboxes[id] = nil
    end

    CheckboxSystem.Checkboxes[id] = checkbox
    return checkbox
end

local StepperSystem = {}

StepperSystem.Create = function(config, parent)
    config = config or {}
    local stepper = {}
    local id = Utility.GenerateUUID()
    local value = config.Default or config.Min or 0
    local min = config.Min or 0
    local max = config.Max or 100
    local step = config.Step or 1
    local connections = {}

    local stepperFrame = Utility.Create("Frame", {
        Name = "Stepper_" .. (config.Name or "Unnamed"),
        Size = UDim2.new(1, 0, 0, 40),
        BackgroundColor3 = ThemeManager.CurrentTheme.Surface,
        BackgroundTransparency = 0.8,
        BorderSizePixel = 0,
        LayoutOrder = #parent:GetChildren(),
        Parent = parent
    })

    local corner = Utility.Create("UICorner", {
        CornerRadius = UDim.new(0, 8),
        Parent = stepperFrame
    })

    local highlight = Utility.CreateHighlight(stepperFrame, Color3.fromRGB(255, 255, 255), 1, 0.15)

    local label = Utility.Create("TextLabel", {
        Name = "Label",
        Size = UDim2.new(1, -120, 1, 0),
        Position = UDim2.new(0, 10, 0, 0),
        BackgroundTransparency = 1,
        Text = config.Name or "Stepper",
        TextColor3 = ThemeManager.CurrentTheme.TextPrimary,
        TextSize = 14,
        Font = Enum.Font.Code,
        TextXAlignment = Enum.TextXAlignment.Left,
        Parent = stepperFrame
    })

    local minusButton = Utility.Create("ImageButton", {
        Name = "MinusButton",
        Size = UDim2.new(0, 30, 0, 30),
        Position = UDim2.new(1, -100, 0.5, -15),
        BackgroundColor3 = ThemeManager.CurrentTheme.Primary,
        Image = GetIcon("minus"),
        ImageColor3 = Color3.fromRGB(255, 255, 255),
        AutoButtonColor = false,
        Parent = stepperFrame
    })

    local minusCorner = Utility.Create("UICorner", {
        CornerRadius = UDim.new(0, 6),
        Parent = minusButton
    })

    local valueLabel = Utility.Create("TextLabel", {
        Name = "ValueLabel",
        Size = UDim2.new(0, 40, 1, 0),
        Position = UDim2.new(1, -65, 0, 0),
        BackgroundTransparency = 1,
        Text = tostring(value),
        TextColor3 = ThemeManager.CurrentTheme.TextPrimary,
        TextSize = 14,
        Font = Enum.Font.Code,
        TextXAlignment = Enum.TextXAlignment.Center,
        Parent = stepperFrame
    })

    local plusButton = Utility.Create("ImageButton", {
        Name = "PlusButton",
        Size = UDim2.new(0, 30, 0, 30),
        Position = UDim2.new(1, -35, 0.5, -15),
        BackgroundColor3 = ThemeManager.CurrentTheme.Primary,
        Image = GetIcon("plus"),
        ImageColor3 = Color3.fromRGB(255, 255, 255),
        AutoButtonColor = false,
        Parent = stepperFrame
    })

    local plusCorner = Utility.Create("UICorner", {
        CornerRadius = UDim.new(0, 6),
        Parent = plusButton
    })

    local function update()
        value = math.clamp(value, min, max)
        valueLabel.Text = tostring(value)
        if config.Callback then
            config.Callback(value)
        end
        EventBus.Publish("StepperChanged", id, config.Name, value)
    end

    table.insert(connections, minusButton.MouseButton1Click:Connect(function()
        value = value - step
        update()
    end))

    table.insert(connections, plusButton.MouseButton1Click:Connect(function()
        value = value + step
        update()
    end))

    table.insert(connections, stepperFrame.MouseEnter:Connect(function()
        Utility.Tween(stepperFrame, TweenInfo.new(0.2), {BackgroundTransparency = 0.6})
    end))

    table.insert(connections, stepperFrame.MouseLeave:Connect(function()
        Utility.Tween(stepperFrame, TweenInfo.new(0.2), {BackgroundTransparency = 0.8})
    end))

    stepper.ID = id
    stepper.Instance = stepperFrame
    stepper.GetValue = function() return value end
    stepper.SetValue = function(newValue)
        value = newValue
        update()
    end
    stepper.SetMin = function(newMin) min = newMin end
    stepper.SetMax = function(newMax) max = newMax end
    stepper.SetStep = function(newStep) step = newStep end
    stepper.SetVisible = function(visible)
        stepperFrame.Visible = visible
    end
    stepper.Destroy = function()
        for _, conn in ipairs(connections) do
            conn:Disconnect()
        end
        stepperFrame:Destroy()
    end

    return stepper
end

local SegmentedControlSystem = {}

SegmentedControlSystem.Create = function(config, parent)
    config = config or {}
    local segmented = {}
    local id = Utility.GenerateUUID()
    local segments = config.Segments or {}
    local selectedIndex = config.Default or 1
    local connections = {}
    local segmentButtons = {}

    local segmentedFrame = Utility.Create("Frame", {
        Name = "Segmented_" .. (config.Name or "Unnamed"),
        Size = UDim2.new(1, 0, 0, 40),
        BackgroundColor3 = ThemeManager.CurrentTheme.Surface,
        BackgroundTransparency = 0.8,
        BorderSizePixel = 0,
        LayoutOrder = #parent:GetChildren(),
        Parent = parent
    })

    local corner = Utility.Create("UICorner", {
        CornerRadius = UDim.new(0, 8),
        Parent = segmentedFrame
    })

    local highlight = Utility.CreateHighlight(segmentedFrame, Color3.fromRGB(255, 255, 255), 1, 0.15)

    local segmentsContainer = Utility.Create("Frame", {
        Name = "Segments",
        Size = UDim2.new(1, -20, 0, 30),
        Position = UDim2.new(0, 10, 0.5, -15),
        BackgroundColor3 = Color3.fromRGB(40, 40, 40),
        BackgroundTransparency = 0.5,
        BorderSizePixel = 0,
        Parent = segmentedFrame
    })

    local segmentsCorner = Utility.Create("UICorner", {
        CornerRadius = UDim.new(0, 6),
        Parent = segmentsContainer
    })

    local function updateSelection()
        for i, btn in ipairs(segmentButtons) do
            if i == selectedIndex then
                btn.BackgroundColor3 = ThemeManager.CurrentTheme.Primary
                btn.TextColor3 = Color3.fromRGB(255, 255, 255)
            else
                btn.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
                btn.TextColor3 = ThemeManager.CurrentTheme.TextSecondary
            end
        end
    end

    for i, segment in ipairs(segments) do
        local btn = Utility.Create("TextButton", {
            Name = "Segment_" .. tostring(i),
            Size = UDim2.new(1 / #segments, 0, 1, 0),
            Position = UDim2.new((i - 1) / #segments, 0, 0, 0),
            BackgroundColor3 = i == selectedIndex and ThemeManager.CurrentTheme.Primary or Color3.fromRGB(40, 40, 40),
            Text = segment,
            TextColor3 = i == selectedIndex and Color3.fromRGB(255, 255, 255) or ThemeManager.CurrentTheme.TextSecondary,
            TextSize = 12,
            Font = Enum.Font.Code,
            AutoButtonColor = false,
            Parent = segmentsContainer
        })

        local btnCorner = Utility.Create("UICorner", {
            CornerRadius = UDim.new(0, 4),
            Parent = btn
        })

        btn.MouseButton1Click:Connect(function()
            selectedIndex = i
            updateSelection()
            if config.Callback then
                config.Callback(segments[i], i)
            end
            EventBus.Publish("SegmentSelected", id, config.Name, segments[i], i)
        end)

        table.insert(segmentButtons, btn)
    end

    table.insert(connections, segmentedFrame.MouseEnter:Connect(function()
        Utility.Tween(segmentedFrame, TweenInfo.new(0.2), {BackgroundTransparency = 0.6})
    end))

    table.insert(connections, segmentedFrame.MouseLeave:Connect(function()
        Utility.Tween(segmentedFrame, TweenInfo.new(0.2), {BackgroundTransparency = 0.8})
    end))

    segmented.ID = id
    segmented.Instance = segmentedFrame
    segmented.GetSelected = function() return segments[selectedIndex], selectedIndex end
    segmented.SetSelected = function(index)
        selectedIndex = index
        updateSelection()
    end
    segmented.SetVisible = function(visible)
        segmentedFrame.Visible = visible
    end
    segmented.Destroy = function()
        for _, conn in ipairs(connections) do
            conn:Disconnect()
        end
        segmentedFrame:Destroy()
    end

    return segmented
end

local DatePickerSystem = {}

DatePickerSystem.Create = function(config, parent)
    config = config or {}
    local datePicker = {}
    local id = Utility.GenerateUUID()
    local selectedDate = config.Default or os.date("*t")
    local isOpen = false
    local connections = {}

    local pickerFrame = Utility.Create("Frame", {
        Name = "DatePicker_" .. (config.Name or "Unnamed"),
        Size = UDim2.new(1, 0, 0, 40),
        BackgroundColor3 = ThemeManager.CurrentTheme.Surface,
        BackgroundTransparency = 0.8,
        BorderSizePixel = 0,
        ClipsDescendants = true,
        LayoutOrder = #parent:GetChildren(),
        Parent = parent
    })

    local corner = Utility.Create("UICorner", {
        CornerRadius = UDim.new(0, 8),
        Parent = pickerFrame
    })

    local highlight = Utility.CreateHighlight(pickerFrame, Color3.fromRGB(255, 255, 255), 1, 0.15)

    local label = Utility.Create("TextLabel", {
        Name = "Label",
        Size = UDim2.new(1, -50, 0, 40),
        Position = UDim2.new(0, 10, 0, 0),
        BackgroundTransparency = 1,
        Text = config.Name or "Date",
        TextColor3 = ThemeManager.CurrentTheme.TextPrimary,
        TextSize = 14,
        Font = Enum.Font.Code,
        TextXAlignment = Enum.TextXAlignment.Left,
        Parent = pickerFrame
    })

    local dateLabel = Utility.Create("TextLabel", {
        Name = "DateLabel",
        Size = UDim2.new(1, -50, 0, 40),
        Position = UDim2.new(0, 10, 0, 0),
        BackgroundTransparency = 1,
        Text = string.format("%04d-%02d-%02d", selectedDate.year, selectedDate.month, selectedDate.day),
        TextColor3 = ThemeManager.CurrentTheme.Primary,
        TextSize = 14,
        Font = Enum.Font.Code,
        TextXAlignment = Enum.TextXAlignment.Right,
        Parent = pickerFrame
    })

    local arrow = Utility.Create("ImageLabel", {
        Name = "Arrow",
        Size = UDim2.new(0, 20, 0, 20),
        Position = UDim2.new(1, -30, 0.5, -10),
        BackgroundTransparency = 1,
        Image = GetIcon("calendar"),
        ImageColor3 = ThemeManager.CurrentTheme.TextSecondary,
        Parent = pickerFrame
    })

    local clickArea = Utility.Create("TextButton", {
        Name = "ClickArea",
        Size = UDim2.new(1, 0, 0, 40),
        BackgroundTransparency = 1,
        Text = "",
        Parent = pickerFrame
    })

    local calendarFrame = Utility.Create("Frame", {
        Name = "Calendar",
        Size = UDim2.new(1, -20, 0, 200),
        Position = UDim2.new(0, 10, 0, 50),
        BackgroundColor3 = ThemeManager.CurrentTheme.Surface,
        BackgroundTransparency = 0.5,
        BorderSizePixel = 0,
        Visible = false,
        Parent = pickerFrame
    })

    local calendarCorner = Utility.Create("UICorner", {
        CornerRadius = UDim.new(0, 8),
        Parent = calendarFrame
    })

    local function toggle()
        isOpen = not isOpen
        if isOpen then
            calendarFrame.Visible = true
            Utility.Tween(pickerFrame, TweenInfo.new(0.2), {Size = UDim2.new(1, 0, 0, 260)})
        else
            Utility.Tween(pickerFrame, TweenInfo.new(0.2), {Size = UDim2.new(1, 0, 0, 40)}).Completed:Connect(function()
                calendarFrame.Visible = false
            end)
        end
    end

    table.insert(connections, clickArea.MouseButton1Click:Connect(toggle))

    table.insert(connections, pickerFrame.MouseEnter:Connect(function()
        Utility.Tween(pickerFrame, TweenInfo.new(0.2), {BackgroundTransparency = 0.6})
    end))

    table.insert(connections, pickerFrame.MouseLeave:Connect(function()
        Utility.Tween(pickerFrame, TweenInfo.new(0.2), {BackgroundTransparency = 0.8})
    end))

    datePicker.ID = id
    datePicker.Instance = pickerFrame
    datePicker.GetDate = function() return selectedDate end
    datePicker.SetDate = function(date)
        selectedDate = date
        dateLabel.Text = string.format("%04d-%02d-%02d", date.year, date.month, date.day)
        if config.Callback then
            config.Callback(date)
        end
    end
    datePicker.SetVisible = function(visible)
        pickerFrame.Visible = visible
    end
    datePicker.Destroy = function()
        for _, conn in ipairs(connections) do
            conn:Disconnect()
        end
        pickerFrame:Destroy()
    end

    return datePicker
end

local TimePickerSystem = {}

TimePickerSystem.Create = function(config, parent)
    config = config or {}
    local timePicker = {}
    local id = Utility.GenerateUUID()
    local hour = config.DefaultHour or 12
    local minute = config.DefaultMinute or 0
    local connections = {}

    local pickerFrame = Utility.Create("Frame", {
        Name = "TimePicker_" .. (config.Name or "Unnamed"),
        Size = UDim2.new(1, 0, 0, 40),
        BackgroundColor3 = ThemeManager.CurrentTheme.Surface,
        BackgroundTransparency = 0.8,
        BorderSizePixel = 0,
        LayoutOrder = #parent:GetChildren(),
        Parent = parent
    })

    local corner = Utility.Create("UICorner", {
        CornerRadius = UDim.new(0, 8),
        Parent = pickerFrame
    })

    local highlight = Utility.CreateHighlight(pickerFrame, Color3.fromRGB(255, 255, 255), 1, 0.15)

    local label = Utility.Create("TextLabel", {
        Name = "Label",
        Size = UDim2.new(1, -100, 1, 0),
        Position = UDim2.new(0, 10, 0, 0),
        BackgroundTransparency = 1,
        Text = config.Name or "Time",
        TextColor3 = ThemeManager.CurrentTheme.TextPrimary,
        TextSize = 14,
        Font = Enum.Font.Code,
        TextXAlignment = Enum.TextXAlignment.Left,
        Parent = pickerFrame
    })

    local hourBox = Utility.Create("TextBox", {
        Name = "HourBox",
        Size = UDim2.new(0, 40, 0, 30),
        Position = UDim2.new(1, -95, 0.5, -15),
        BackgroundColor3 = Color3.fromRGB(40, 40, 40),
        Text = string.format("%02d", hour),
        TextColor3 = ThemeManager.CurrentTheme.TextPrimary,
        TextSize = 14,
        Font = Enum.Font.Code,
        Parent = pickerFrame
    })

    local hourCorner = Utility.Create("UICorner", {
        CornerRadius = UDim.new(0, 4),
        Parent = hourBox
    })

    local colonLabel = Utility.Create("TextLabel", {
        Name = "Colon",
        Size = UDim2.new(0, 10, 1, 0),
        Position = UDim2.new(1, -52, 0, 0),
        BackgroundTransparency = 1,
        Text = ":",
        TextColor3 = ThemeManager.CurrentTheme.TextPrimary,
        TextSize = 14,
        Font = Enum.Font.Code,
        Parent = pickerFrame
    })

    local minuteBox = Utility.Create("TextBox", {
        Name = "MinuteBox",
        Size = UDim2.new(0, 40, 0, 30),
        Position = UDim2.new(1, -45, 0.5, -15),
        BackgroundColor3 = Color3.fromRGB(40, 40, 40),
        Text = string.format("%02d", minute),
        TextColor3 = ThemeManager.CurrentTheme.TextPrimary,
        TextSize = 14,
        Font = Enum.Font.Code,
        Parent = pickerFrame
    })

    local minuteCorner = Utility.Create("UICorner", {
        CornerRadius = UDim.new(0, 4),
        Parent = minuteBox
    })

    local function updateTime()
        hour = math.clamp(tonumber(hourBox.Text) or 0, 0, 23)
        minute = math.clamp(tonumber(minuteBox.Text) or 0, 0, 59)
        hourBox.Text = string.format("%02d", hour)
        minuteBox.Text = string.format("%02d", minute)
        if config.Callback then
            config.Callback(hour, minute)
        end
        EventBus.Publish("TimeChanged", id, config.Name, hour, minute)
    end

    table.insert(connections, hourBox.FocusLost:Connect(updateTime))
    table.insert(connections, minuteBox.FocusLost:Connect(updateTime))

    table.insert(connections, pickerFrame.MouseEnter:Connect(function()
        Utility.Tween(pickerFrame, TweenInfo.new(0.2), {BackgroundTransparency = 0.6})
    end))

    table.insert(connections, pickerFrame.MouseLeave:Connect(function()
        Utility.Tween(pickerFrame, TweenInfo.new(0.2), {BackgroundTransparency = 0.8})
    end))

    timePicker.ID = id
    timePicker.Instance = pickerFrame
    timePicker.GetTime = function() return hour, minute end
    timePicker.SetTime = function(h, m)
        hour = h
        minute = m
        hourBox.Text = string.format("%02d", hour)
        minuteBox.Text = string.format("%02d", minute)
    end
    timePicker.SetVisible = function(visible)
        pickerFrame.Visible = visible
    end
    timePicker.Destroy = function()
        for _, conn in ipairs(connections) do
            conn:Disconnect()
        end
        pickerFrame:Destroy()
    end

    return timePicker
end

local FilePickerSystem = {}

FilePickerSystem.Create = function(config, parent)
    config = config or {}
    local filePicker = {}
    local id = Utility.GenerateUUID()
    local selectedFile = config.Default or ""
    local connections = {}

    local pickerFrame = Utility.Create("Frame", {
        Name = "FilePicker_" .. (config.Name or "Unnamed"),
        Size = UDim2.new(1, 0, 0, 40),
        BackgroundColor3 = ThemeManager.CurrentTheme.Surface,
        BackgroundTransparency = 0.8,
        BorderSizePixel = 0,
        LayoutOrder = #parent:GetChildren(),
        Parent = parent
    })

    local corner = Utility.Create("UICorner", {
        CornerRadius = UDim.new(0, 8),
        Parent = pickerFrame
    })

    local highlight = Utility.CreateHighlight(pickerFrame, Color3.fromRGB(255, 255, 255), 1, 0.15)

    local label = Utility.Create("TextLabel", {
        Name = "Label",
        Size = UDim2.new(1, -50, 0, 40),
        Position = UDim2.new(0, 10, 0, 0),
        BackgroundTransparency = 1,
        Text = config.Name or "File",
        TextColor3 = ThemeManager.CurrentTheme.TextPrimary,
        TextSize = 14,
        Font = Enum.Font.Code,
        TextXAlignment = Enum.TextXAlignment.Left,
        Parent = pickerFrame
    })

    local fileLabel = Utility.Create("TextLabel", {
        Name = "FileLabel",
        Size = UDim2.new(1, -100, 0, 40),
        Position = UDim2.new(0, 10, 0, 0),
        BackgroundTransparency = 1,
        Text = selectedFile ~= "" and selectedFile or "No file selected",
        TextColor3 = ThemeManager.CurrentTheme.TextSecondary,
        TextSize = 12,
        Font = Enum.Font.Code,
        TextXAlignment = Enum.TextXAlignment.Right,
        TextTruncate = Enum.TextTruncate.AtEnd,
        Parent = pickerFrame
    })

    local browseButton = Utility.Create("ImageButton", {
        Name = "BrowseButton",
        Size = UDim2.new(0, 30, 0, 30),
        Position = UDim2.new(1, -35, 0.5, -15),
        BackgroundColor3 = ThemeManager.CurrentTheme.Primary,
        Image = GetIcon("folder"),
        ImageColor3 = Color3.fromRGB(255, 255, 255),
        AutoButtonColor = false,
        Parent = pickerFrame
    })

    local browseCorner = Utility.Create("UICorner", {
        CornerRadius = UDim.new(0, 6),
        Parent = browseButton
    })

    table.insert(connections, browseButton.MouseButton1Click:Connect(function()
        if config.OnBrowse then
            local file = config.OnBrowse()
            if file then
                selectedFile = file
                fileLabel.Text = selectedFile
                fileLabel.TextColor3 = ThemeManager.CurrentTheme.TextPrimary
                if config.Callback then
                    config.Callback(selectedFile)
                end
                EventBus.Publish("FileSelected", id, config.Name, selectedFile)
            end
        end
    end))

    table.insert(connections, pickerFrame.MouseEnter:Connect(function()
        Utility.Tween(pickerFrame, TweenInfo.new(0.2), {BackgroundTransparency = 0.6})
    end))

    table.insert(connections, pickerFrame.MouseLeave:Connect(function()
        Utility.Tween(pickerFrame, TweenInfo.new(0.2), {BackgroundTransparency = 0.8})
    end))

    filePicker.ID = id
    filePicker.Instance = pickerFrame
    filePicker.GetFile = function() return selectedFile end
    filePicker.SetFile = function(file)
        selectedFile = file
        fileLabel.Text = selectedFile ~= "" and selectedFile or "No file selected"
    end
    filePicker.SetVisible = function(visible)
        pickerFrame.Visible = visible
    end
    filePicker.Destroy = function()
        for _, conn in ipairs(connections) do
            conn:Disconnect()
        end
        pickerFrame:Destroy()
    end

    return filePicker
end

local RichTextSystem = {}

RichTextSystem.Create = function(config, parent)
    config = config or {}
    local richText = {}
    local id = Utility.GenerateUUID()

    local textFrame = Utility.Create("Frame", {
        Name = "RichText_" .. (config.Name or "Unnamed"),
        Size = UDim2.new(1, 0, 0, config.Height or 100),
        BackgroundColor3 = config.BackgroundColor or ThemeManager.CurrentTheme.Surface,
        BackgroundTransparency = 0.5,
        BorderSizePixel = 0,
        LayoutOrder = #parent:GetChildren(),
        Parent = parent
    })

    local corner = Utility.Create("UICorner", {
        CornerRadius = UDim.new(0, 8),
        Parent = textFrame
    })

    local highlight = Utility.CreateHighlight(textFrame, Color3.fromRGB(255, 255, 255), 1, 0.15)

    local scrollFrame = Utility.Create("ScrollingFrame", {
        Name = "Scroll",
        Size = UDim2.new(1, -20, 1, -20),
        Position = UDim2.new(0, 10, 0, 10),
        BackgroundTransparency = 1,
        ScrollBarThickness = 4,
        ScrollBarImageColor3 = ThemeManager.CurrentTheme.Primary,
        CanvasSize = UDim2.new(0, 0, 0, 0),
        AutomaticCanvasSize = Enum.AutomaticSize.Y,
        Parent = textFrame
    })

    local textLabel = Utility.Create("TextLabel", {
        Name = "Text",
        Size = UDim2.new(1, 0, 0, 0),
        AutomaticSize = Enum.AutomaticSize.Y,
        BackgroundTransparency = 1,
        Text = config.Text or "",
        TextColor3 = config.Color or ThemeManager.CurrentTheme.TextPrimary,
        TextSize = config.Size or 14,
        Font = config.Font or Enum.Font.Code,
        TextXAlignment = Enum.TextXAlignment.Left,
        TextYAlignment = Enum.TextYAlignment.Top,
        TextWrapped = true,
        RichText = true,
        Parent = scrollFrame
    })

    richText.ID = id
    richText.Instance = textFrame
    richText.SetText = function(text)
        textLabel.Text = text
    end
    richText.GetText = function()
        return textLabel.Text
    end
    richText.Append = function(text)
        textLabel.Text = textLabel.Text .. text
    end
    richText.SetVisible = function(visible)
        textFrame.Visible = visible
    end
    richText.Destroy = function()
        textFrame:Destroy()
    end

    return richText
end

local CodeBlockSystem = {}

CodeBlockSystem.Create = function(config, parent)
    config = config or {}
    local codeBlock = {}
    local id = Utility.GenerateUUID()

    local codeFrame = Utility.Create("Frame", {
        Name = "CodeBlock_" .. (config.Name or "Unnamed"),
        Size = UDim2.new(1, 0, 0, config.Height or 150),
        BackgroundColor3 = Color3.fromRGB(30, 30, 30),
        BackgroundTransparency = 0.2,
        BorderSizePixel = 0,
        LayoutOrder = #parent:GetChildren(),
        Parent = parent
    })

    local corner = Utility.Create("UICorner", {
        CornerRadius = UDim.new(0, 8),
        Parent = codeFrame
    })

    local highlight = Utility.CreateHighlight(codeFrame, Color3.fromRGB(255, 255, 255), 1, 0.15)

    local header = Utility.Create("Frame", {
        Name = "Header",
        Size = UDim2.new(1, 0, 0, 30),
        BackgroundColor3 = Color3.fromRGB(40, 40, 40),
        BackgroundTransparency = 0.5,
        BorderSizePixel = 0,
        Parent = codeFrame
    })

    local headerCorner = Utility.Create("UICorner", {
        CornerRadius = UDim.new(0, 8),
        Parent = header
    })

    local headerFix = Utility.Create("Frame", {
        Name = "HeaderFix",
        Size = UDim2.new(1, 0, 0.5, 0),
        Position = UDim2.new(0, 0, 0.5, 0),
        BackgroundColor3 = header.BackgroundColor3,
        BackgroundTransparency = header.BackgroundTransparency,
        BorderSizePixel = 0,
        Parent = header
    })

    local langLabel = Utility.Create("TextLabel", {
        Name = "Lang",
        Size = UDim2.new(0, 100, 1, 0),
        Position = UDim2.new(0, 10, 0, 0),
        BackgroundTransparency = 1,
        Text = config.Language or "lua",
        TextColor3 = ThemeManager.CurrentTheme.TextSecondary,
        TextSize = 12,
        Font = Enum.Font.Code,
        TextXAlignment = Enum.TextXAlignment.Left,
        Parent = header
    })

    local copyButton = Utility.Create("ImageButton", {
        Name = "CopyButton",
        Size = UDim2.new(0, 24, 0, 24),
        Position = UDim2.new(1, -34, 0.5, -12),
        BackgroundTransparency = 1,
        Image = GetIcon("copy"),
        ImageColor3 = ThemeManager.CurrentTheme.TextSecondary,
        Parent = header
    })

    local scrollFrame = Utility.Create("ScrollingFrame", {
        Name = "Scroll",
        Size = UDim2.new(1, -20, 1, -50),
        Position = UDim2.new(0, 10, 0, 40),
        BackgroundTransparency = 1,
        ScrollBarThickness = 4,
        ScrollBarImageColor3 = ThemeManager.CurrentTheme.Primary,
        CanvasSize = UDim2.new(0, 0, 0, 0),
        AutomaticCanvasSize = Enum.AutomaticSize.Y,
        Parent = codeFrame
    })

    local codeLabel = Utility.Create("TextLabel", {
        Name = "Code",
        Size = UDim2.new(1, 0, 0, 0),
        AutomaticSize = Enum.AutomaticSize.Y,
        BackgroundTransparency = 1,
        Text = config.Code or "",
        TextColor3 = Color3.fromRGB(200, 200, 200),
        TextSize = 13,
        Font = Enum.Font.Code,
        TextXAlignment = Enum.TextXAlignment.Left,
        TextYAlignment = Enum.TextYAlignment.Top,
        TextWrapped = false,
        Parent = scrollFrame
    })

    copyButton.MouseButton1Click:Connect(function()
        if config.OnCopy then
            config.OnCopy(codeLabel.Text)
        end
    end)

    codeBlock.ID = id
    codeBlock.Instance = codeFrame
    codeBlock.SetCode = function(code)
        codeLabel.Text = code
    end
    codeBlock.GetCode = function()
        return codeLabel.Text
    end
    codeBlock.SetLanguage = function(lang)
        langLabel.Text = lang
    end
    codeBlock.SetVisible = function(visible)
        codeFrame.Visible = visible
    end
    codeBlock.Destroy = function()
        codeFrame:Destroy()
    end

    return codeBlock
end

local TerminalSystem = {}

TerminalSystem.Create = function(config, parent)
    config = config or {}
    local terminal = {}
    local id = Utility.GenerateUUID()
    local lines = {}
    local maxLines = config.MaxLines or 100

    local terminalFrame = Utility.Create("Frame", {
        Name = "Terminal_" .. (config.Name or "Unnamed"),
        Size = UDim2.new(1, 0, 0, config.Height or 200),
        BackgroundColor3 = Color3.fromRGB(0, 0, 0),
        BackgroundTransparency = 0.1,
        BorderSizePixel = 0,
        LayoutOrder = #parent:GetChildren(),
        Parent = parent
    })

    local corner = Utility.Create("UICorner", {
        CornerRadius = UDim.new(0, 8),
        Parent = terminalFrame
    })

    local highlight = Utility.CreateHighlight(terminalFrame, Color3.fromRGB(255, 255, 255), 1, 0.15)

    local scrollFrame = Utility.Create("ScrollingFrame", {
        Name = "Scroll",
        Size = UDim2.new(1, -20, 1, -20),
        Position = UDim2.new(0, 10, 0, 10),
        BackgroundTransparency = 1,
        ScrollBarThickness = 4,
        ScrollBarImageColor3 = ThemeManager.CurrentTheme.Primary,
        CanvasSize = UDim2.new(0, 0, 0, 0),
        AutomaticCanvasSize = Enum.AutomaticSize.Y,
        Parent = terminalFrame
    })

    local contentFrame = Utility.Create("Frame", {
        Name = "Content",
        Size = UDim2.new(1, 0, 0, 0),
        AutomaticSize = Enum.AutomaticSize.Y,
        BackgroundTransparency = 1,
        Parent = scrollFrame
    })

    local listLayout = Utility.Create("UIListLayout", {
        Padding = UDim.new(0, 2),
        SortOrder = Enum.SortOrder.LayoutOrder,
        Parent = contentFrame
    })

    local function addLine(text, color)
        color = color or Color3.fromRGB(200, 200, 200)
        
        local lineLabel = Utility.Create("TextLabel", {
            Name = "Line_" .. tostring(#lines),
            Size = UDim2.new(1, 0, 0, 18),
            BackgroundTransparency = 1,
            Text = text,
            TextColor3 = color,
            TextSize = 12,
            Font = Enum.Font.Code,
            TextXAlignment = Enum.TextXAlignment.Left,
            TextWrapped = true,
            LayoutOrder = #lines,
            Parent = contentFrame
        })

        table.insert(lines, lineLabel)

        if #lines > maxLines then
            lines[1]:Destroy()
            table.remove(lines, 1)
            for i, line in ipairs(lines) do
                line.LayoutOrder = i - 1
                line.Name = "Line_" .. tostring(i - 1)
            end
        end

        task.wait()
        scrollFrame.CanvasPosition = Vector2.new(0, scrollFrame.AbsoluteCanvasSize.Y)
    end

    terminal.ID = id
    terminal.Instance = terminalFrame
    terminal.Print = function(text, color)
        addLine(text, color)
    end
    terminal.Clear = function()
        for _, line in ipairs(lines) do
            line:Destroy()
        end
        lines = {}
    end
    terminal.SetVisible = function(visible)
        terminalFrame.Visible = visible
    end
    terminal.Destroy = function()
        terminalFrame:Destroy()
    end

    return terminal
end

local ChartSystem = {}

ChartSystem.Create = function(config, parent)
    config = config or {}
    local chart = {}
    local id = Utility.GenerateUUID()
    local data = config.Data or {}
    local chartType = config.Type or "line"

    local chartFrame = Utility.Create("Frame", {
        Name = "Chart_" .. (config.Name or "Unnamed"),
        Size = UDim2.new(1, 0, 0, config.Height or 200),
        BackgroundColor3 = ThemeManager.CurrentTheme.Surface,
        BackgroundTransparency = 0.5,
        BorderSizePixel = 0,
        LayoutOrder = #parent:GetChildren(),
        Parent = parent
    })

    local corner = Utility.Create("UICorner", {
        CornerRadius = UDim.new(0, 8),
        Parent = chartFrame
    })

    local highlight = Utility.CreateHighlight(chartFrame, Color3.fromRGB(255, 255, 255), 1, 0.15)

    local titleLabel = Utility.Create("TextLabel", {
        Name = "Title",
        Size = UDim2.new(1, -20, 0, 30),
        Position = UDim2.new(0, 10, 0, 5),
        BackgroundTransparency = 1,
        Text = config.Title or "Chart",
        TextColor3 = ThemeManager.CurrentTheme.TextPrimary,
        TextSize = 16,
        Font = Enum.Font.Code,
        TextXAlignment = Enum.TextXAlignment.Left,
        Parent = chartFrame
    })

    local canvas = Utility.Create("Frame", {
        Name = "Canvas",
        Size = UDim2.new(1, -40, 1, -50),
        Position = UDim2.new(0, 20, 0, 40),
        BackgroundColor3 = Color3.fromRGB(30, 30, 30),
        BackgroundTransparency = 0.5,
        BorderSizePixel = 0,
        Parent = chartFrame
    })

    local canvasCorner = Utility.Create("UICorner", {
        CornerRadius = UDim.new(0, 4),
        Parent = canvas
    })

    chart.ID = id
    chart.Instance = chartFrame
    chart.SetData = function(newData)
        data = newData
    end
    chart.SetTitle = function(title)
        titleLabel.Text = title
    end
    chart.SetVisible = function(visible)
        chartFrame.Visible = visible
    end
    chart.Destroy = function()
        chartFrame:Destroy()
    end

    return chart
end

local DataGridSystem = {}

DataGridSystem.Create = function(config, parent)
    config = config or {}
    local dataGrid = {}
    local id = Utility.GenerateUUID()
    local columns = config.Columns or {}
    local rows = config.Rows or {}

    local gridFrame = Utility.Create("Frame", {
        Name = "DataGrid_" .. (config.Name or "Unnamed"),
        Size = UDim2.new(1, 0, 0, config.Height or 200),
        BackgroundColor3 = ThemeManager.CurrentTheme.Surface,
        BackgroundTransparency = 0.5,
        BorderSizePixel = 0,
        LayoutOrder = #parent:GetChildren(),
        Parent = parent
    })

    local corner = Utility.Create("UICorner", {
        CornerRadius = UDim.new(0, 8),
        Parent = gridFrame
    })

    local highlight = Utility.CreateHighlight(gridFrame, Color3.fromRGB(255, 255, 255), 1, 0.15)

    local scrollFrame = Utility.Create("ScrollingFrame", {
        Name = "Scroll",
        Size = UDim2.new(1, -20, 1, -20),
        Position = UDim2.new(0, 10, 0, 10),
        BackgroundTransparency = 1,
        ScrollBarThickness = 4,
        ScrollBarImageColor3 = ThemeManager.CurrentTheme.Primary,
        CanvasSize = UDim2.new(0, 0, 0, 0),
        AutomaticCanvasSize = Enum.AutomaticSize.Y,
        Parent = gridFrame
    })

    local headerFrame = Utility.Create("Frame", {
        Name = "Header",
        Size = UDim2.new(1, 0, 0, 30),
        BackgroundColor3 = ThemeManager.CurrentTheme.Primary,
        BackgroundTransparency = 0.7,
        BorderSizePixel = 0,
        Parent = scrollFrame
    })

    for i, col in ipairs(columns) do
        local colLabel = Utility.Create("TextLabel", {
            Name = "Col_" .. tostring(i),
            Size = UDim2.new(1 / #columns, 0, 1, 0),
            Position = UDim2.new((i - 1) / #columns, 0, 0, 0),
            BackgroundTransparency = 1,
            Text = col,
            TextColor3 = Color3.fromRGB(255, 255, 255),
            TextSize = 12,
            Font = Enum.Font.Code,
            TextXAlignment = Enum.TextXAlignment.Center,
            Parent = headerFrame
        })
    end

    local contentFrame = Utility.Create("Frame", {
        Name = "Content",
        Size = UDim2.new(1, 0, 0, 0),
        Position = UDim2.new(0, 0, 0, 35),
        AutomaticSize = Enum.AutomaticSize.Y,
        BackgroundTransparency = 1,
        Parent = scrollFrame
    })

    local listLayout = Utility.Create("UIListLayout", {
        Padding = UDim.new(0, 2),
        SortOrder = Enum.SortOrder.LayoutOrder,
        Parent = contentFrame
    })

    local function refreshRows()
        for _, child in ipairs(contentFrame:GetChildren()) do
            if child:IsA("Frame") then
                child:Destroy()
            end
        end

        for rowIndex, row in ipairs(rows) do
            local rowFrame = Utility.Create("Frame", {
                Name = "Row_" .. tostring(rowIndex),
                Size = UDim2.new(1, 0, 0, 25),
                BackgroundColor3 = rowIndex % 2 == 0 and Color3.fromRGB(40, 40, 40) or Color3.fromRGB(50, 50, 50),
                BackgroundTransparency = 0.5,
                BorderSizePixel = 0,
                LayoutOrder = rowIndex,
                Parent = contentFrame
            })

            for colIndex, value in ipairs(row) do
                local cellLabel = Utility.Create("TextLabel", {
                    Name = "Cell_" .. tostring(colIndex),
                    Size = UDim2.new(1 / #columns, 0, 1, 0),
                    Position = UDim2.new((colIndex - 1) / #columns, 0, 0, 0),
                    BackgroundTransparency = 1,
                    Text = tostring(value),
                    TextColor3 = ThemeManager.CurrentTheme.TextPrimary,
                    TextSize = 11,
                    Font = Enum.Font.Code,
                    TextXAlignment = Enum.TextXAlignment.Center,
                    Parent = rowFrame
                })
            end
        end
    end

    refreshRows()

    dataGrid.ID = id
    dataGrid.Instance = gridFrame
    dataGrid.SetRows = function(newRows)
        rows = newRows
        refreshRows()
    end
    dataGrid.AddRow = function(row)
        table.insert(rows, row)
        refreshRows()
    end
    dataGrid.Clear = function()
        rows = {}
        refreshRows()
    end
    dataGrid.SetVisible = function(visible)
        gridFrame.Visible = visible
    end
    dataGrid.Destroy = function()
        gridFrame:Destroy()
    end

    return dataGrid
end

local TreeViewSystem = {}

TreeViewSystem.Create = function(config, parent)
    config = config or {}
    local treeView = {}
    local id = Utility.GenerateUUID()
    local items = config.Items or {}

    local treeFrame = Utility.Create("Frame", {
        Name = "TreeView_" .. (config.Name or "Unnamed"),
        Size = UDim2.new(1, 0, 0, config.Height or 200),
        BackgroundColor3 = ThemeManager.CurrentTheme.Surface,
        BackgroundTransparency = 0.5,
        BorderSizePixel = 0,
        LayoutOrder = #parent:GetChildren(),
        Parent = parent
    })

    local corner = Utility.Create("UICorner", {
        CornerRadius = UDim.new(0, 8),
        Parent = treeFrame
    })

    local highlight = Utility.CreateHighlight(treeFrame, Color3.fromRGB(255, 255, 255), 1, 0.15)

    local scrollFrame = Utility.Create("ScrollingFrame", {
        Name = "Scroll",
        Size = UDim2.new(1, -20, 1, -20),
        Position = UDim2.new(0, 10, 0, 10),
        BackgroundTransparency = 1,
        ScrollBarThickness = 4,
        ScrollBarImageColor3 = ThemeManager.CurrentTheme.Primary,
        CanvasSize = UDim2.new(0, 0, 0, 0),
        AutomaticCanvasSize = Enum.AutomaticSize.Y,
        Parent = treeFrame
    })

    local contentFrame = Utility.Create("Frame", {
        Name = "Content",
        Size = UDim2.new(1, 0, 0, 0),
        AutomaticSize = Enum.AutomaticSize.Y,
        BackgroundTransparency = 1,
        Parent = scrollFrame
    })

    local listLayout = Utility.Create("UIListLayout", {
        Padding = UDim.new(0, 2),
        SortOrder = Enum.SortOrder.LayoutOrder,
        Parent = contentFrame
    })

    local function createTreeItem(item, depth)
        depth = depth or 0
        
        local itemFrame = Utility.Create("Frame", {
            Name = "Item_" .. item.Name,
            Size = UDim2.new(1, 0, 0, 25),
            BackgroundColor3 = Color3.fromRGB(40, 40, 40),
            BackgroundTransparency = 0.5,
            BorderSizePixel = 0,
            LayoutOrder = #contentFrame:GetChildren(),
            Parent = contentFrame
        })

        local expandButton = nil
        if item.Children and #item.Children > 0 then
            expandButton = Utility.Create("ImageButton", {
                Name = "Expand",
                Size = UDim2.new(0, 20, 0, 20),
                Position = UDim2.new(0, 5 + depth * 20, 0.5, -10),
                BackgroundTransparency = 1,
                Image = GetIcon("chevron-right"),
                ImageColor3 = ThemeManager.CurrentTheme.TextSecondary,
                Parent = itemFrame
            })
        end

        local icon = Utility.Create("ImageLabel", {
            Name = "Icon",
            Size = UDim2.new(0, 16, 0, 16),
            Position = UDim2.new(0, (expandButton and 30 or 10) + depth * 20, 0.5, -8),
            BackgroundTransparency = 1,
            Image = item.Icon and GetIcon(item.Icon) or GetIcon("file"),
            ImageColor3 = ThemeManager.CurrentTheme.Primary,
            Parent = itemFrame
        })

        local label = Utility.Create("TextLabel", {
            Name = "Label",
            Size = UDim2.new(1, -50 - depth * 20, 1, 0),
            Position = UDim2.new(0, (expandButton and 50 or 30) + depth * 20, 0, 0),
            BackgroundTransparency = 1,
            Text = item.Name,
            TextColor3 = ThemeManager.CurrentTheme.TextPrimary,
            TextSize = 12,
            Font = Enum.Font.Code,
            TextXAlignment = Enum.TextXAlignment.Left,
            Parent = itemFrame
        })

        if item.Children and #item.Children > 0 then
            local expanded = false
            local childFrames = {}

            expandButton.MouseButton1Click:Connect(function()
                expanded = not expanded
                expandButton.Image = expanded and GetIcon("chevron-down") or GetIcon("chevron-right")
                
                if expanded then
                    for _, child in ipairs(item.Children) do
                        local childFrame = createTreeItem(child, depth + 1)
                        table.insert(childFrames, childFrame)
                    end
                else
                    for _, childFrame in ipairs(childFrames) do
                        childFrame:Destroy()
                    end
                    childFrames = {}
                end
            end)
        end

        itemFrame.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 then
                if config.OnSelect then
                    config.OnSelect(item)
                end
            end
        end)

        return itemFrame
    end

    for _, item in ipairs(items) do
        createTreeItem(item, 0)
    end

    treeView.ID = id
    treeView.Instance = treeFrame
    treeView.SetItems = function(newItems)
        items = newItems
        for _, child in ipairs(contentFrame:GetChildren()) do
            if child:IsA("Frame") then
                child:Destroy()
            end
        end
        for _, item in ipairs(items) do
            createTreeItem(item, 0)
        end
    end
    treeView.SetVisible = function(visible)
        treeFrame.Visible = visible
    end
    treeView.Destroy = function()
        treeFrame:Destroy()
    end

    return treeView
end

local MenuBarSystem = {}

MenuBarSystem.Create = function(config, parent)
    config = config or {}
    local menuBar = {}
    local id = Utility.GenerateUUID()
    local menus = config.Menus or {}
    local connections = {}

    local menuBarFrame = Utility.Create("Frame", {
        Name = "MenuBar_" .. (config.Name or "Unnamed"),
        Size = UDim2.new(1, 0, 0, 35),
        BackgroundColor3 = ThemeManager.CurrentTheme.Surface,
        BackgroundTransparency = 0.5,
        BorderSizePixel = 0,
        LayoutOrder = #parent:GetChildren(),
        Parent = parent
    })

    local corner = Utility.Create("UICorner", {
        CornerRadius = UDim.new(0, 8),
        Parent = menuBarFrame
    })

    local highlight = Utility.CreateHighlight(menuBarFrame, Color3.fromRGB(255, 255, 255), 1, 0.15)

    local menusContainer = Utility.Create("Frame", {
        Name = "Menus",
        Size = UDim2.new(1, -20, 1, 0),
        Position = UDim2.new(0, 10, 0, 0),
        BackgroundTransparency = 1,
        Parent = menuBarFrame
    })

    local listLayout = Utility.Create("UIListLayout", {
        Padding = UDim.new(0, 5),
        FillDirection = Enum.FillDirection.Horizontal,
        SortOrder = Enum.SortOrder.LayoutOrder,
        Parent = menusContainer
    })

    local openMenu = nil

    for menuIndex, menu in ipairs(menus) do
        local menuButton = Utility.Create("TextButton", {
            Name = "Menu_" .. menu.Name,
            Size = UDim2.new(0, 80, 0, 30),
            Position = UDim2.new(0, (menuIndex - 1) * 85, 0.5, -15),
            BackgroundColor3 = ThemeManager.CurrentTheme.Primary,
            BackgroundTransparency = 0.8,
            Text = menu.Name,
            TextColor3 = ThemeManager.CurrentTheme.TextPrimary,
            TextSize = 12,
            Font = Enum.Font.Code,
            AutoButtonColor = false,
            LayoutOrder = menuIndex,
            Parent = menusContainer
        })

        local buttonCorner = Utility.Create("UICorner", {
            CornerRadius = UDim.new(0, 4),
            Parent = menuButton
        })

        local dropdownFrame = Utility.Create("Frame", {
            Name = "Dropdown",
            Size = UDim2.new(0, 150, 0, 0),
            Position = UDim2.new(0, 0, 1, 5),
            BackgroundColor3 = ThemeManager.CurrentTheme.Surface,
            BackgroundTransparency = 0.1,
            BorderSizePixel = 0,
            Visible = false,
            ZIndex = 10,
            Parent = menuButton
        })

        local dropdownCorner = Utility.Create("UICorner", {
            CornerRadius = UDim.new(0, 6),
            Parent = dropdownFrame
        })

        local dropdownStroke = Utility.Create("UIStroke", {
            Color = ThemeManager.CurrentTheme.Border,
            Thickness = 1,
            Parent = dropdownFrame
        })

        local itemsList = Utility.Create("UIListLayout", {
            Padding = UDim.new(0, 2),
            SortOrder = Enum.SortOrder.LayoutOrder,
            Parent = dropdownFrame
        })

        for itemIndex, item in ipairs(menu.Items or {}) do
            local itemButton = Utility.Create("TextButton", {
                Name = "Item_" .. tostring(itemIndex),
                Size = UDim2.new(1, -10, 0, 28),
                Position = UDim2.new(0, 5, 0, 0),
                BackgroundColor3 = Color3.fromRGB(50, 50, 50),
                BackgroundTransparency = 0.9,
                Text = item.Name,
                TextColor3 = ThemeManager.CurrentTheme.TextPrimary,
                TextSize = 11,
                Font = Enum.Font.Code,
                AutoButtonColor = false,
                LayoutOrder = itemIndex,
                Parent = dropdownFrame
            })

            local itemCorner = Utility.Create("UICorner", {
                CornerRadius = UDim.new(0, 4),
                Parent = itemButton
            })

            itemButton.MouseButton1Click:Connect(function()
                if item.Callback then
                    item.Callback()
                end
                dropdownFrame.Visible = false
                openMenu = nil
            end)

            itemButton.MouseEnter:Connect(function()
                Utility.Tween(itemButton, TweenInfo.new(0.1), {BackgroundTransparency = 0.5})
            end)

            itemButton.MouseLeave:Connect(function()
                Utility.Tween(itemButton, TweenInfo.new(0.1), {BackgroundTransparency = 0.9})
            end)
        end

        menuButton.MouseButton1Click:Connect(function()
            if openMenu and openMenu ~= dropdownFrame then
                openMenu.Visible = false
            end
            dropdownFrame.Visible = not dropdownFrame.Visible
            openMenu = dropdownFrame.Visible and dropdownFrame or nil
            
            if dropdownFrame.Visible then
                local itemCount = #(menu.Items or {})
                dropdownFrame.Size = UDim2.new(0, 150, 0, itemCount * 30 + 10)
            end
        end)

        menuButton.MouseEnter:Connect(function()
            Utility.Tween(menuButton, TweenInfo.new(0.2), {BackgroundTransparency = 0.5})
        end)

        menuButton.MouseLeave:Connect(function()
            Utility.Tween(menuButton, TweenInfo.new(0.2), {BackgroundTransparency = 0.8})
        end)
    end

    menuBar.ID = id
    menuBar.Instance = menuBarFrame
    menuBar.SetVisible = function(visible)
        menuBarFrame.Visible = visible
    end
    menuBar.Destroy = function()
        for _, conn in ipairs(connections) do
            conn:Disconnect()
        end
        menuBarFrame:Destroy()
    end

    return menuBar
end

local ToolbarSystem = {}

ToolbarSystem.Create = function(config, parent)
    config = config or {}
    local toolbar = {}
    local id = Utility.GenerateUUID()
    local tools = config.Tools or {}

    local toolbarFrame = Utility.Create("Frame", {
        Name = "Toolbar_" .. (config.Name or "Unnamed"),
        Size = UDim2.new(1, 0, 0, 45),
        BackgroundColor3 = ThemeManager.CurrentTheme.Surface,
        BackgroundTransparency = 0.5,
        BorderSizePixel = 0,
        LayoutOrder = #parent:GetChildren(),
        Parent = parent
    })

    local corner = Utility.Create("UICorner", {
        CornerRadius = UDim.new(0, 8),
        Parent = toolbarFrame
    })

    local highlight = Utility.CreateHighlight(toolbarFrame, Color3.fromRGB(255, 255, 255), 1, 0.15)

    local toolsContainer = Utility.Create("Frame", {
        Name = "Tools",
        Size = UDim2.new(1, -20, 1, 0),
        Position = UDim2.new(0, 10, 0, 0),
        BackgroundTransparency = 1,
        Parent = toolbarFrame
    })

    local listLayout = Utility.Create("UIListLayout", {
        Padding = UDim.new(0, 10),
        FillDirection = Enum.FillDirection.Horizontal,
        SortOrder = Enum.SortOrder.LayoutOrder,
        Parent = toolsContainer
    })

    for toolIndex, tool in ipairs(tools) do
        local toolButton = Utility.Create("ImageButton", {
            Name = "Tool_" .. tool.Name,
            Size = UDim2.new(0, 35, 0, 35),
            BackgroundColor3 = tool.Selected and ThemeManager.CurrentTheme.Primary or Color3.fromRGB(50, 50, 50),
            BackgroundTransparency = 0.5,
            Image = tool.Icon and GetIcon(tool.Icon) or GetIcon("tool"),
            ImageColor3 = Color3.fromRGB(255, 255, 255),
            AutoButtonColor = false,
            LayoutOrder = toolIndex,
            Parent = toolsContainer
        })

        local toolCorner = Utility.Create("UICorner", {
            CornerRadius = UDim.new(0, 6),
            Parent = toolButton
        })

        local tooltip = nil
        toolButton.MouseEnter:Connect(function()
            Utility.Tween(toolButton, TweenInfo.new(0.2), {BackgroundTransparency = 0.2})
            if tool.Tooltip then
                tooltip = Utility.Create("Frame", {
                    Name = "Tooltip",
                    Size = UDim2.new(0, 100, 0, 25),
                    Position = UDim2.new(0.5, -50, 1, 5),
                    BackgroundColor3 = Color3.fromRGB(30, 30, 30),
                    BackgroundTransparency = 0.1,
                    BorderSizePixel = 0,
                    ZIndex = 100,
                    Parent = toolButton
                })
                
                local tooltipCorner = Utility.Create("UICorner", {
                    CornerRadius = UDim.new(0, 4),
                    Parent = tooltip
                })

                local tooltipLabel = Utility.Create("TextLabel", {
                    Name = "Label",
                    Size = UDim2.new(1, -10, 1, 0),
                    Position = UDim2.new(0, 5, 0, 0),
                    BackgroundTransparency = 1,
                    Text = tool.Tooltip,
                    TextColor3 = Color3.fromRGB(255, 255, 255),
                    TextSize = 10,
                    Font = Enum.Font.Code,
                    ZIndex = 100,
                    Parent = tooltip
                })
            end
        end)

        toolButton.MouseLeave:Connect(function()
            Utility.Tween(toolButton, TweenInfo.new(0.2), {BackgroundTransparency = 0.5})
            if tooltip then
                tooltip:Destroy()
                tooltip = nil
            end
        end)

        toolButton.MouseButton1Click:Connect(function()
            if tool.Callback then
                tool.Callback()
            end
        end)
    end

    toolbar.ID = id
    toolbar.Instance = toolbarFrame
    toolbar.SetVisible = function(visible)
        toolbarFrame.Visible = visible
    end
    toolbar.Destroy = function()
        toolbarFrame:Destroy()
    end

    return toolbar
end

local StatusBarSystem = {}

StatusBarSystem.Create = function(config, parent)
    config = config or {}
    local statusBar = {}
    local id = Utility.GenerateUUID()

    local statusFrame = Utility.Create("Frame", {
        Name = "StatusBar_" .. (config.Name or "Unnamed"),
        Size = UDim2.new(1, 0, 0, 25),
        BackgroundColor3 = ThemeManager.CurrentTheme.Surface,
        BackgroundTransparency = 0.3,
        BorderSizePixel = 0,
        LayoutOrder = #parent:GetChildren(),
        Parent = parent
    })

    local corner = Utility.Create("UICorner", {
        CornerRadius = UDim.new(0, 4),
        Parent = statusFrame
    })

    local highlight = Utility.CreateHighlight(statusFrame, Color3.fromRGB(255, 255, 255), 1, 0.1)

    local leftSection = Utility.Create("Frame", {
        Name = "Left",
        Size = UDim2.new(0.5, -10, 1, 0),
        Position = UDim2.new(0, 10, 0, 0),
        BackgroundTransparency = 1,
        Parent = statusFrame
    })

    local leftList = Utility.Create("UIListLayout", {
        Padding = UDim.new(0, 10),
        FillDirection = Enum.FillDirection.Horizontal,
        SortOrder = Enum.SortOrder.LayoutOrder,
        Parent = leftSection
    })

    local rightSection = Utility.Create("Frame", {
        Name = "Right",
        Size = UDim2.new(0.5, -10, 1, 0),
        Position = UDim2.new(0.5, 0, 0, 0),
        BackgroundTransparency = 1,
        Parent = statusFrame
    })

    local rightList = Utility.Create("UIListLayout", {
        Padding = UDim.new(0, 10),
        FillDirection = Enum.FillDirection.Horizontal,
        HorizontalAlignment = Enum.HorizontalAlignment.Right,
        SortOrder = Enum.SortOrder.LayoutOrder,
        Parent = rightSection
    })

    local statusItems = {}

    local function addStatusItem(section, itemConfig)
        local itemFrame = Utility.Create("Frame", {
            Name = itemConfig.Name or "Item",
            Size = UDim2.new(0, itemConfig.Width or 80, 1, -4),
            Position = UDim2.new(0, 0, 0, 2),
            BackgroundColor3 = Color3.fromRGB(40, 40, 40),
            BackgroundTransparency = 0.5,
            LayoutOrder = #section:GetChildren(),
            Parent = section
        })

        local itemCorner = Utility.Create("UICorner", {
            CornerRadius = UDim.new(0, 3),
            Parent = itemFrame
        })

        local icon = nil
        if itemConfig.Icon then
            icon = Utility.Create("ImageLabel", {
                Name = "Icon",
                Size = UDim2.new(0, 14, 0, 14),
                Position = UDim2.new(0, 5, 0.5, -7),
                BackgroundTransparency = 1,
                Image = GetIcon(itemConfig.Icon),
                ImageColor3 = itemConfig.IconColor or ThemeManager.CurrentTheme.Primary,
                Parent = itemFrame
            })
        end

        local label = Utility.Create("TextLabel", {
            Name = "Label",
            Size = UDim2.new(1, icon and -25 or -10, 1, 0),
            Position = UDim2.new(0, icon and 22 or 5, 0, 0),
            BackgroundTransparency = 1,
            Text = itemConfig.Text or "",
            TextColor3 = itemConfig.Color or ThemeManager.CurrentTheme.TextPrimary,
            TextSize = 10,
            Font = Enum.Font.Code,
            TextXAlignment = Enum.TextXAlignment.Left,
            Parent = itemFrame
        })

        table.insert(statusItems, {
            Frame = itemFrame,
            Label = label,
            Icon = icon,
            SetText = function(text)
                label.Text = text
            end,
            SetIcon = function(iconName)
                if icon then
                    icon.Image = GetIcon(iconName)
                end
            end
        })

        return statusItems[#statusItems]
    end

    if config.LeftItems then
        for _, item in ipairs(config.LeftItems) do
            addStatusItem(leftSection, item)
        end
    end

    if config.RightItems then
        for _, item in ipairs(config.RightItems) do
            addStatusItem(rightSection, item)
        end
    end

    statusBar.ID = id
    statusBar.Instance = statusFrame
    statusBar.AddLeftItem = function(itemConfig)
        return addStatusItem(leftSection, itemConfig)
    end
    statusBar.AddRightItem = function(itemConfig)
        return addStatusItem(rightSection, itemConfig)
    end
    statusBar.SetVisible = function(visible)
        statusFrame.Visible = visible
    end
    statusBar.Destroy = function()
        statusFrame:Destroy()
    end

    return statusBar
end

local TooltipSystem = {}

TooltipSystem.Tooltips = {}
TooltipSystem.ActiveTooltip = nil

TooltipSystem.Create = function(config)
    config = config or {}
    local tooltip = {}
    local id = Utility.GenerateUUID()

    local screenGui = Utility.Create("ScreenGui", {
        Name = "AdvancedUI_Tooltip_" .. id,
        Parent = CoreGui,
        ResetOnSpawn = false,
        ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
        DisplayOrder = 1000
    })

    local mainFrame = Utility.Create("Frame", {
        Name = "MainFrame",
        Size = UDim2.new(0, 0, 0, 0),
        Position = UDim2.new(0, 0, 0, 0),
        BackgroundColor3 = config.BackgroundColor or Color3.fromRGB(0, 0, 0),
        BackgroundTransparency = 0.1,
        BorderSizePixel = 0,
        Visible = false,
        Parent = screenGui
    })

    local corner = Utility.Create("UICorner", {
        CornerRadius = UDim.new(0, 6),
        Parent = mainFrame
    })

    local stroke = Utility.Create("UIStroke", {
        Color = config.BorderColor or ThemeManager.CurrentTheme.Primary,
        Thickness = 1,
        Transparency = 0.5,
        Parent = mainFrame
    })

    local highlight = Utility.CreateHighlight(mainFrame, Color3.fromRGB(255, 255, 255), 1, 0.2)

    local textLabel = Utility.Create("TextLabel", {
        Name = "Text",
        Size = UDim2.new(1, -16, 1, -12),
        Position = UDim2.new(0, 8, 0, 6),
        BackgroundTransparency = 1,
        Text = config.Text or "",
        TextColor3 = config.TextColor or Color3.fromRGB(255, 255, 255),
        TextSize = 12,
        Font = Enum.Font.Code,
        TextWrapped = true,
        Parent = mainFrame
    })

    local target = config.Target
    local offset = config.Offset or Vector2.new(10, 10)
    local delay = config.Delay or 0.5
    local showTimer = nil

    local function show()
        if TooltipSystem.ActiveTooltip and TooltipSystem.ActiveTooltip ~= tooltip then
            TooltipSystem.ActiveTooltip.Hide()
        end

        local bounds = TextService:GetTextSize(textLabel.Text, 12, Enum.Font.Code, Vector2.new(300, 9999))
        mainFrame.Size = UDim2.new(0, math.min(bounds.X + 16, 316), 0, bounds.Y + 12)

        if target then
            local targetPos = target.AbsolutePosition
            local targetSize = target.AbsoluteSize
            mainFrame.Position = UDim2.new(0, targetPos.X + targetSize.X / 2 + offset.X, 0, targetPos.Y + offset.Y)
        end

        mainFrame.Visible = true
        TooltipSystem.ActiveTooltip = tooltip
        Utility.Tween(mainFrame, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
            BackgroundTransparency = 0.1
        })
    end

    local function hide()
        Utility.Tween(mainFrame, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
            BackgroundTransparency = 1
        }).Completed:Connect(function()
            mainFrame.Visible = false
            if TooltipSystem.ActiveTooltip == tooltip then
                TooltipSystem.ActiveTooltip = nil
            end
        end)

        if showTimer then
            showTimer:Disconnect()
            showTimer = nil
        end
    end

    local function scheduleShow()
        if showTimer then
            showTimer:Disconnect()
        end
        showTimer = task.delay(delay, show)
    end

    if target then
        target.MouseEnter:Connect(scheduleShow)
        target.MouseLeave:Connect(hide)
    end

    tooltip.ID = id
    tooltip.Instance = screenGui
    tooltip.Show = show
    tooltip.Hide = hide
    tooltip.SetText = function(text)
        textLabel.Text = text
    end
    tooltip.SetTarget = function(newTarget)
        target = newTarget
    end
    tooltip.SetOffset = function(newOffset)
        offset = newOffset
    end
    tooltip.Destroy = function()
        if showTimer then
            showTimer:Disconnect()
        end
        screenGui:Destroy()
        TooltipSystem.Tooltips[id] = nil
    end

    TooltipSystem.Tooltips[id] = tooltip
    return tooltip
end

TooltipSystem.HideAll = function()
    for _, tooltip in pairs(TooltipSystem.Tooltips) do
        tooltip.Hide()
    end
end

local ModalSystem = {}

ModalSystem.Modals = {}
ModalSystem.ActiveModal = nil

ModalSystem.Create = function(config)
    config = config or {}
    local modal = {}
    local id = Utility.GenerateUUID()
    local connections = {}

    local screenGui = Utility.Create("ScreenGui", {
        Name = "AdvancedUI_Modal_" .. id,
        Parent = CoreGui,
        ResetOnSpawn = false,
        ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
        DisplayOrder = 999
    })

    local overlay = Utility.Create("Frame", {
        Name = "Overlay",
        Size = UDim2.new(1, 0, 1, 0),
        BackgroundColor3 = Color3.fromRGB(0, 0, 0),
        BackgroundTransparency = 1,
        Parent = screenGui
    })

    local mainFrame = Utility.Create("Frame", {
        Name = "MainFrame",
        Size = config.Size or UDim2.new(0, 400, 0, 200),
        Position = UDim2.new(0.5, -200, 0.5, -100),
        BackgroundColor3 = config.BackgroundColor or ThemeManager.CurrentTheme.Background,
        BackgroundTransparency = 0.1,
        BorderSizePixel = 0,
        Parent = overlay
    })

    if config.BackgroundImage then
        local bgImage = Utility.Create("ImageLabel", {
            Name = "BackgroundImage",
            Size = UDim2.new(1, 0, 1, 0),
            BackgroundTransparency = 1,
            Image = config.BackgroundImage,
            ImageTransparency = 0.5,
            ScaleType = Enum.ScaleType.Crop,
            Parent = mainFrame
        })
    end

    local corner = Utility.Create("UICorner", {
        CornerRadius = UDim.new(0, 12),
        Parent = mainFrame
    })

    local stroke = Utility.Create("UIStroke", {
        Color = config.BorderColor or ThemeManager.CurrentTheme.Primary,
        Thickness = 1,
        Transparency = 0.3,
        Parent = mainFrame
    })

    local highlight = Utility.CreateHighlight(mainFrame, Color3.fromRGB(255, 255, 255), 2, 0.2)

    local shadow = Utility.CreateShadow(mainFrame, 8, 0.5, 20)

    local titleLabel = Utility.Create("TextLabel", {
        Name = "Title",
        Size = UDim2.new(1, -40, 0, 40),
        Position = UDim2.new(0, 20, 0, 10),
        BackgroundTransparency = 1,
        Text = config.Title or "Modal",
        TextColor3 = ThemeManager.CurrentTheme.TextPrimary,
        TextSize = 18,
        Font = Enum.Font.Code,
        TextXAlignment = Enum.TextXAlignment.Left,
        TextTruncate = Enum.TextTruncate.AtEnd,
        Parent = mainFrame
    })

    local messageLabel = Utility.Create("TextLabel", {
        Name = "Message",
        Size = UDim2.new(1, -40, 0, 80),
        Position = UDim2.new(0, 20, 0, 55),
        BackgroundTransparency = 1,
        Text = config.Message or "",
        TextColor3 = ThemeManager.CurrentTheme.TextSecondary,
        TextSize = 14,
        Font = Enum.Font.Code,
        TextWrapped = true,
        Parent = mainFrame
    })

    local buttonContainer = Utility.Create("Frame", {
        Name = "ButtonContainer",
        Size = UDim2.new(1, -40, 0, 40),
        Position = UDim2.new(0, 20, 1, -50),
        BackgroundTransparency = 1,
        Parent = mainFrame
    })

    local function show()
        if ModalSystem.ActiveModal and ModalSystem.ActiveModal ~= modal then
            ModalSystem.ActiveModal.Hide()
        end

        screenGui.Enabled = true
        ModalSystem.ActiveModal = modal
        Utility.Tween(overlay, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
            BackgroundTransparency = 0.5
        })
        Utility.Tween(mainFrame, TweenInfo.new(0.3, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
            Size = mainFrame.Size
        })

        if config.OnShow then
            config.OnShow()
        end
    end

    local function hide()
        Utility.Tween(overlay, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
            BackgroundTransparency = 1
        })
        Utility.Tween(mainFrame, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
            Size = UDim2.new(0, 0, 0, 0)
        }).Completed:Connect(function()
            screenGui.Enabled = false
            if ModalSystem.ActiveModal == modal then
                ModalSystem.ActiveModal = nil
            end
        end)

        if config.OnHide then
            config.OnHide()
        end
    end

    table.insert(connections, overlay.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 and config.CloseOnClickOutside ~= false then
            hide()
        end
    end))

    modal.ID = id
    modal.Instance = screenGui
    modal.MainFrame = mainFrame
    modal.ButtonContainer = buttonContainer
    modal.Show = show
    modal.Hide = hide
    modal.IsVisible = function()
        return screenGui.Enabled
    end

    modal.AddButton = function(btnConfig)
        local btn = Utility.Create("TextButton", {
            Size = btnConfig.Size or UDim2.new(0, 100, 1, 0),
            Position = btnConfig.Position or UDim2.new(0, 0, 0, 0),
            BackgroundColor3 = btnConfig.Color or ThemeManager.CurrentTheme.Primary,
            Text = btnConfig.Text or "Button",
            TextColor3 = Color3.fromRGB(255, 255, 255),
            TextSize = 14,
            Font = Enum.Font.Code,
            AutoButtonColor = false,
            Parent = buttonContainer
        })

        local btnCorner = Utility.Create("UICorner", {
            CornerRadius = UDim.new(0, 8),
            Parent = btn
        })

        local btnHighlight = Utility.CreateHighlight(btn, Color3.fromRGB(255, 255, 255), 1, 0.2)

        btn.MouseButton1Click:Connect(function()
            if btnConfig.Callback then
                btnConfig.Callback()
            end
            if btnConfig.CloseOnClick ~= false then
                hide()
            end
        end)

        return btn
    end

    modal.Destroy = function()
        for _, conn in ipairs(connections) do
            conn:Disconnect()
        end
        screenGui:Destroy()
        ModalSystem.Modals[id] = nil
    end

    screenGui.Enabled = false
    ModalSystem.Modals[id] = modal
    return modal
end

ModalSystem.HideAll = function()
    for _, modal in pairs(ModalSystem.Modals) do
        modal.Hide()
    end
end

local ScrollSystem = {}

ScrollSystem.Create = function(config, parent)
    config = config or {}
    local scroll = {}

    local scrollFrame = Utility.Create("ScrollingFrame", {
        Name = "Scroll_" .. (config.Name or "Unnamed"),
        Size = config.Size or UDim2.new(1, 0, 1, 0),
        Position = config.Position or UDim2.new(0, 0, 0, 0),
        BackgroundTransparency = 1,
        ScrollBarThickness = config.ScrollBarThickness or 4,
        ScrollBarImageColor3 = config.ScrollBarColor or ThemeManager.CurrentTheme.Primary,
        CanvasSize = UDim2.new(0, 0, 0, 0),
        AutomaticCanvasSize = Enum.AutomaticSize.Y,
        Parent = parent
    })

    local layout = Utility.Create("UIListLayout", {
        Padding = UDim.new(0, config.Padding or 10),
        SortOrder = Enum.SortOrder.LayoutOrder,
        Parent = scrollFrame
    })

    local padding = Utility.Create("UIPadding", {
        PaddingLeft = UDim.new(0, config.PaddingLeft or 10),
        PaddingRight = UDim.new(0, config.PaddingRight or 10),
        PaddingTop = UDim.new(0, config.PaddingTop or 10),
        PaddingBottom = UDim.new(0, config.PaddingBottom or 10),
        Parent = scrollFrame
    })

    scroll.Instance = scrollFrame
    scroll.Layout = layout
    scroll.Padding = padding
    scroll.ScrollToTop = function()
        scrollFrame.CanvasPosition = Vector2.new(0, 0)
    end
    scroll.ScrollToBottom = function()
        scrollFrame.CanvasPosition = Vector2.new(0, scrollFrame.AbsoluteCanvasSize.Y)
    end
    scroll.GetCanvasPosition = function()
        return scrollFrame.CanvasPosition
    end
    scroll.SetCanvasPosition = function(position)
        scrollFrame.CanvasPosition = position
    end
    scroll.Destroy = function()
        scrollFrame:Destroy()
    end

    return scroll
end

local GridSystem = {}

GridSystem.Create = function(config, parent)
    config = config or {}
    local grid = {}

    local gridFrame = Utility.Create("Frame", {
        Name = "Grid_" .. (config.Name or "Unnamed"),
        Size = config.Size or UDim2.new(1, 0, 0, 0),
        AutomaticSize = Enum.AutomaticSize.Y,
        BackgroundTransparency = 1,
        Parent = parent
    })

    local layout = Utility.Create("UIGridLayout", {
        CellSize = config.CellSize or UDim2.new(0, 100, 0, 100),
        CellPadding = config.CellPadding or UDim2.new(0, 10, 0, 10),
        FillDirection = config.FillDirection or Enum.FillDirection.Horizontal,
        SortOrder = Enum.SortOrder.LayoutOrder,
        Parent = gridFrame
    })

    grid.Instance = gridFrame
    grid.Layout = layout
    grid.Destroy = function()
        gridFrame:Destroy()
    end

    return grid
end

local CalendarSystem = {}

CalendarSystem.Create = function(config, parent)
    config = config or {}
    local calendar = {}
    local id = Utility.GenerateUUID()
    local currentDate = config.Default or os.date("*t")
    local selectedDate = nil
    local connections = {}

    local calendarFrame = Utility.Create("Frame", {
        Name = "Calendar_" .. (config.Name or "Unnamed"),
        Size = UDim2.new(1, 0, 0, config.Height or 280),
        BackgroundColor3 = ThemeManager.CurrentTheme.Surface,
        BackgroundTransparency = 0.5,
        BorderSizePixel = 0,
        LayoutOrder = #parent:GetChildren(),
        Parent = parent
    })

    local corner = Utility.Create("UICorner", {
        CornerRadius = UDim.new(0, 8),
        Parent = calendarFrame
    })

    local highlight = Utility.CreateHighlight(calendarFrame, Color3.fromRGB(255, 255, 255), 1, 0.15)

    local headerFrame = Utility.Create("Frame", {
        Name = "Header",
        Size = UDim2.new(1, 0, 0, 40),
        BackgroundColor3 = ThemeManager.CurrentTheme.Primary,
        BackgroundTransparency = 0.7,
        BorderSizePixel = 0,
        Parent = calendarFrame
    })

    local headerCorner = Utility.Create("UICorner", {
        CornerRadius = UDim.new(0, 8),
        Parent = headerFrame
    })

    local prevButton = Utility.Create("ImageButton", {
        Name = "Prev",
        Size = UDim2.new(0, 30, 0, 30),
        Position = UDim2.new(0, 10, 0.5, -15),
        BackgroundTransparency = 1,
        Image = GetIcon("chevron-left"),
        ImageColor3 = Color3.fromRGB(255, 255, 255),
        Parent = headerFrame
    })

    local nextButton = Utility.Create("ImageButton", {
        Name = "Next",
        Size = UDim2.new(0, 30, 0, 30),
        Position = UDim2.new(1, -40, 0.5, -15),
        BackgroundTransparency = 1,
        Image = GetIcon("chevron-right"),
        ImageColor3 = Color3.fromRGB(255, 255, 255),
        Parent = headerFrame
    })

    local monthLabel = Utility.Create("TextLabel", {
        Name = "Month",
        Size = UDim2.new(1, -100, 1, 0),
        Position = UDim2.new(0, 50, 0, 0),
        BackgroundTransparency = 1,
        Text = "",
        TextColor3 = Color3.fromRGB(255, 255, 255),
        TextSize = 16,
        Font = Enum.Font.Code,
        TextXAlignment = Enum.TextXAlignment.Center,
        Parent = headerFrame
    })

    local daysFrame = Utility.Create("Frame", {
        Name = "Days",
        Size = UDim2.new(1, -20, 1, -60),
        Position = UDim2.new(0, 10, 0, 50),
        BackgroundTransparency = 1,
        Parent = calendarFrame
    })

    local daysGrid = Utility.Create("UIGridLayout", {
        CellSize = UDim2.new(1/7, -5, 0, 30),
        CellPadding = UDim2.new(0, 5, 0, 5),
        Parent = daysFrame
    })

    local monthNames = {"January", "February", "March", "April", "May", "June",
                        "July", "August", "September", "October", "November", "December"}
    local dayNames = {"Sun", "Mon", "Tue", "Wed", "Thu", "Fri", "Sat"}

    local dayButtons = {}

    local function updateCalendar()
        for _, btn in ipairs(dayButtons) do
            btn:Destroy()
        end
        dayButtons = {}

        monthLabel.Text = monthNames[currentDate.month] .. " " .. currentDate.year

        for _, dayName in ipairs(dayNames) do
            local dayHeader = Utility.Create("TextLabel", {
                Name = "Header_" .. dayName,
                Size = UDim2.new(1, 0, 0, 20),
                BackgroundTransparency = 1,
                Text = dayName,
                TextColor3 = ThemeManager.CurrentTheme.TextSecondary,
                TextSize = 10,
                Font = Enum.Font.Code,
                Parent = daysFrame
            })
            table.insert(dayButtons, dayHeader)
        end

        local firstDay = os.date("*t", os.time({year = currentDate.year, month = currentDate.month, day = 1}))
        local daysInMonth = os.date("*t", os.time({year = currentDate.year, month = currentDate.month + 1, day = 0})).day

        for i = 1, firstDay.wday - 1 do
            local empty = Utility.Create("Frame", {
                Name = "Empty_" .. tostring(i),
                Size = UDim2.new(1, 0, 0, 30),
                BackgroundTransparency = 1,
                Parent = daysFrame
            })
            table.insert(dayButtons, empty)
        end

        for day = 1, daysInMonth do
            local dayButton = Utility.Create("TextButton", {
                Name = "Day_" .. tostring(day),
                Size = UDim2.new(1, 0, 0, 30),
                BackgroundColor3 = (selectedDate and selectedDate.day == day and 
                                   selectedDate.month == currentDate.month and 
                                   selectedDate.year == currentDate.year) and 
                                   ThemeManager.CurrentTheme.Primary or Color3.fromRGB(40, 40, 40),
                BackgroundTransparency = 0.5,
                Text = tostring(day),
                TextColor3 = Color3.fromRGB(255, 255, 255),
                TextSize = 12,
                Font = Enum.Font.Code,
                AutoButtonColor = false,
                Parent = daysFrame
            })

            local dayCorner = Utility.Create("UICorner", {
                CornerRadius = UDim.new(0, 4),
                Parent = dayButton
            })

            dayButton.MouseButton1Click:Connect(function()
                selectedDate = {year = currentDate.year, month = currentDate.month, day = day}
                updateCalendar()
                if config.Callback then
                    config.Callback(selectedDate)
                end
                EventBus.Publish("DateSelected", id, config.Name, selectedDate)
            end)

            table.insert(dayButtons, dayButton)
        end
    end

    table.insert(connections, prevButton.MouseButton1Click:Connect(function()
        currentDate.month = currentDate.month - 1
        if currentDate.month < 1 then
            currentDate.month = 12
            currentDate.year = currentDate.year - 1
        end
        updateCalendar()
    end))

    table.insert(connections, nextButton.MouseButton1Click:Connect(function()
        currentDate.month = currentDate.month + 1
        if currentDate.month > 12 then
            currentDate.month = 1
            currentDate.year = currentDate.year + 1
        end
        updateCalendar()
    end))

    updateCalendar()

    calendar.ID = id
    calendar.Instance = calendarFrame
    calendar.GetSelectedDate = function() return selectedDate end
    calendar.SetDate = function(date)
        currentDate = date
        updateCalendar()
    end
    calendar.SetVisible = function(visible)
        calendarFrame.Visible = visible
    end
    calendar.Destroy = function()
        for _, conn in ipairs(connections) do
            conn:Disconnect()
        end
        calendarFrame:Destroy()
    end

    return calendar
end

local AccordionSystem = {}

AccordionSystem.Create = function(config, parent)
    config = config or {}
    local accordion = {}
    local id = Utility.GenerateUUID()
    local items = config.Items or {}
    local allowMultiple = config.AllowMultiple or false
    local openItems = {}

    local accordionFrame = Utility.Create("Frame", {
        Name = "Accordion_" .. (config.Name or "Unnamed"),
        Size = UDim2.new(1, 0, 0, 0),
        AutomaticSize = Enum.AutomaticSize.Y,
        BackgroundTransparency = 1,
        LayoutOrder = #parent:GetChildren(),
        Parent = parent
    })

    local listLayout = Utility.Create("UIListLayout", {
        Padding = UDim.new(0, 5),
        SortOrder = Enum.SortOrder.LayoutOrder,
        Parent = accordionFrame
    })

    for itemIndex, item in ipairs(items) do
        local itemFrame = Utility.Create("Frame", {
            Name = "Item_" .. tostring(itemIndex),
            Size = UDim2.new(1, 0, 0, 0),
            AutomaticSize = Enum.AutomaticSize.Y,
            BackgroundColor3 = ThemeManager.CurrentTheme.Surface,
            BackgroundTransparency = 0.5,
            BorderSizePixel = 0,
            LayoutOrder = itemIndex,
            Parent = accordionFrame
        })

        local itemCorner = Utility.Create("UICorner", {
            CornerRadius = UDim.new(0, 8),
            Parent = itemFrame
        })

        local headerButton = Utility.Create("TextButton", {
            Name = "Header",
            Size = UDim2.new(1, 0, 0, 35),
            BackgroundColor3 = ThemeManager.CurrentTheme.Primary,
            BackgroundTransparency = 0.8,
            Text = "",
            AutoButtonColor = false,
            Parent = itemFrame
        })

        local headerCorner = Utility.Create("UICorner", {
            CornerRadius = UDim.new(0, 8),
            Parent = headerButton
        })

        local icon = Utility.Create("ImageLabel", {
            Name = "Icon",
            Size = UDim2.new(0, 18, 0, 18),
            Position = UDim2.new(0, 10, 0.5, -9),
            BackgroundTransparency = 1,
            Image = item.Icon and GetIcon(item.Icon) or GetIcon("circle"),
            ImageColor3 = Color3.fromRGB(255, 255, 255),
            Parent = headerButton
        })

        local label = Utility.Create("TextLabel", {
            Name = "Label",
            Size = UDim2.new(1, -50, 1, 0),
            Position = UDim2.new(0, 35, 0, 0),
            BackgroundTransparency = 1,
            Text = item.Title or "Item",
            TextColor3 = Color3.fromRGB(255, 255, 255),
            TextSize = 14,
            Font = Enum.Font.Code,
            TextXAlignment = Enum.TextXAlignment.Left,
            Parent = headerButton
        })

        local arrow = Utility.Create("ImageLabel", {
            Name = "Arrow",
            Size = UDim2.new(0, 16, 0, 16),
            Position = UDim2.new(1, -26, 0.5, -8),
            BackgroundTransparency = 1,
            Image = GetIcon("chevron-down"),
            ImageColor3 = Color3.fromRGB(255, 255, 255),
            Rotation = 0,
            Parent = headerButton
        })

        local contentFrame = Utility.Create("Frame", {
            Name = "Content",
            Size = UDim2.new(1, -20, 0, 0),
            Position = UDim2.new(0, 10, 0, 40),
            AutomaticSize = Enum.AutomaticSize.Y,
            BackgroundTransparency = 1,
            Visible = false,
            Parent = itemFrame
        })

        local contentList = Utility.Create("UIListLayout", {
            Padding = UDim.new(0, 5),
            SortOrder = Enum.SortOrder.LayoutOrder,
            Parent = contentFrame
        })

        if item.Content then
            for _, contentItem in ipairs(item.Content) do
                if type(contentItem) == "string" then
                    local contentLabel = Utility.Create("TextLabel", {
                        Name = "Content",
                        Size = UDim2.new(1, 0, 0, 25),
                        BackgroundTransparency = 1,
                        Text = contentItem,
                        TextColor3 = ThemeManager.CurrentTheme.TextPrimary,
                        TextSize = 12,
                        Font = Enum.Font.Code,
                        TextXAlignment = Enum.TextXAlignment.Left,
                        Parent = contentFrame
                    })
                end
            end
        end

        headerButton.MouseButton1Click:Connect(function()
            local isOpen = contentFrame.Visible
            
            if not allowMultiple and not isOpen then
                for _, otherItem in ipairs(accordionFrame:GetChildren()) do
                    if otherItem:IsA("Frame") and otherItem ~= itemFrame then
                        local otherContent = otherItem:FindFirstChild("Content")
                        local otherArrow = otherItem:FindFirstChild("Header"):FindFirstChild("Arrow")
                        if otherContent then
                            otherContent.Visible = false
                        end
                        if otherArrow then
                            otherArrow.Rotation = 0
                        end
                    end
                end
            end

            contentFrame.Visible = not isOpen
            arrow.Rotation = isOpen and 0 or 180

            if item.Callback then
                item.Callback(not isOpen)
            end
        end)
    end

    accordion.ID = id
    accordion.Instance = accordionFrame
    accordion.SetVisible = function(visible)
        accordionFrame.Visible = visible
    end
    accordion.Destroy = function()
        accordionFrame:Destroy()
    end

    return accordion
end

local BreadcrumbSystem = {}

BreadcrumbSystem.Create = function(config, parent)
    config = config or {}
    local breadcrumb = {}
    local id = Utility.GenerateUUID()
    local items = config.Items or {}
    local connections = {}

    local breadcrumbFrame = Utility.Create("Frame", {
        Name = "Breadcrumb_" .. (config.Name or "Unnamed"),
        Size = UDim2.new(1, 0, 0, 30),
        BackgroundTransparency = 1,
        LayoutOrder = #parent:GetChildren(),
        Parent = parent
    })

    local listLayout = Utility.Create("UIListLayout", {
        Padding = UDim.new(0, 5),
        FillDirection = Enum.FillDirection.Horizontal,
        SortOrder = Enum.SortOrder.LayoutOrder,
        Parent = breadcrumbFrame
    })

    local function refresh()
        for _, child in ipairs(breadcrumbFrame:GetChildren()) do
            if child:IsA("TextButton") or child:IsA("TextLabel") then
                child:Destroy()
            end
        end

        for i, item in ipairs(items) do
            if i > 1 then
                local separator = Utility.Create("TextLabel", {
                    Name = "Separator_" .. tostring(i),
                    Size = UDim2.new(0, 20, 1, 0),
                    BackgroundTransparency = 1,
                    Text = ">",
                    TextColor3 = ThemeManager.CurrentTheme.TextSecondary,
                    TextSize = 14,
                    Font = Enum.Font.Code,
                    LayoutOrder = (i - 1) * 2,
                    Parent = breadcrumbFrame
                })
            end

            if i == #items then
                local itemLabel = Utility.Create("TextLabel", {
                    Name = "Item_" .. tostring(i),
                    Size = UDim2.new(0, 0, 1, 0),
                    AutomaticSize = Enum.AutomaticSize.X,
                    BackgroundTransparency = 1,
                    Text = item.Name,
                    TextColor3 = ThemeManager.CurrentTheme.TextPrimary,
                    TextSize = 12,
                    Font = Enum.Font.Code,
                    LayoutOrder = (i - 1) * 2 + 1,
                    Parent = breadcrumbFrame
                })
            else
                local itemButton = Utility.Create("TextButton", {
                    Name = "Item_" .. tostring(i),
                    Size = UDim2.new(0, 0, 1, 0),
                    AutomaticSize = Enum.AutomaticSize.X,
                    BackgroundTransparency = 1,
                    Text = item.Name,
                    TextColor3 = ThemeManager.CurrentTheme.Primary,
                    TextSize = 12,
                    Font = Enum.Font.Code,
                    LayoutOrder = (i - 1) * 2 + 1,
                    Parent = breadcrumbFrame
                })

                itemButton.MouseButton1Click:Connect(function()
                    if item.Callback then
                        item.Callback()
                    end
                end)
            end
        end
    end

    refresh()

    breadcrumb.ID = id
    breadcrumb.Instance = breadcrumbFrame
    breadcrumb.SetItems = function(newItems)
        items = newItems
        refresh()
    end
    breadcrumb.AddItem = function(item)
        table.insert(items, item)
        refresh()
    end
    breadcrumb.SetVisible = function(visible)
        breadcrumbFrame.Visible = visible
    end
    breadcrumb.Destroy = function()
        for _, conn in ipairs(connections) do
            conn:Disconnect()
        end
        breadcrumbFrame:Destroy()
    end

    return breadcrumb
end

local PaginationSystem = {}

PaginationSystem.Create = function(config, parent)
    config = config or {}
    local pagination = {}
    local id = Utility.GenerateUUID()
    local currentPage = config.CurrentPage or 1
    local totalPages = config.TotalPages or 1
    local connections = {}

    local paginationFrame = Utility.Create("Frame", {
        Name = "Pagination_" .. (config.Name or "Unnamed"),
        Size = UDim2.new(1, 0, 0, 40),
        BackgroundTransparency = 1,
        LayoutOrder = #parent:GetChildren(),
        Parent = parent
    })

    local prevButton = Utility.Create("ImageButton", {
        Name = "Prev",
        Size = UDim2.new(0, 35, 0, 35),
        Position = UDim2.new(0.5, -100, 0.5, -17),
        BackgroundColor3 = ThemeManager.CurrentTheme.Primary,
        BackgroundTransparency = 0.7,
        Image = GetIcon("chevron-left"),
        ImageColor3 = Color3.fromRGB(255, 255, 255),
        AutoButtonColor = false,
        Parent = paginationFrame
    })

    local prevCorner = Utility.Create("UICorner", {
        CornerRadius = UDim.new(0, 6),
        Parent = prevButton
    })

    local pageLabel = Utility.Create("TextLabel", {
        Name = "Page",
        Size = UDim2.new(0, 80, 1, 0),
        Position = UDim2.new(0.5, -40, 0, 0),
        BackgroundTransparency = 1,
        Text = currentPage .. " / " .. totalPages,
        TextColor3 = ThemeManager.CurrentTheme.TextPrimary,
        TextSize = 14,
        Font = Enum.Font.Code,
        TextXAlignment = Enum.TextXAlignment.Center,
        Parent = paginationFrame
    })

    local nextButton = Utility.Create("ImageButton", {
        Name = "Next",
        Size = UDim2.new(0, 35, 0, 35),
        Position = UDim2.new(0.5, 65, 0.5, -17),
        BackgroundColor3 = ThemeManager.CurrentTheme.Primary,
        BackgroundTransparency = 0.7,
        Image = GetIcon("chevron-right"),
        ImageColor3 = Color3.fromRGB(255, 255, 255),
        AutoButtonColor = false,
        Parent = paginationFrame
    })

    local nextCorner = Utility.Create("UICorner", {
        CornerRadius = UDim.new(0, 6),
        Parent = nextButton
    })

    local function update()
        pageLabel.Text = currentPage .. " / " .. totalPages
        prevButton.BackgroundTransparency = currentPage <= 1 and 0.9 or 0.7
        nextButton.BackgroundTransparency = currentPage >= totalPages and 0.9 or 0.7
    end

    table.insert(connections, prevButton.MouseButton1Click:Connect(function()
        if currentPage > 1 then
            currentPage = currentPage - 1
            update()
            if config.Callback then
                config.Callback(currentPage)
            end
            EventBus.Publish("PageChanged", id, config.Name, currentPage)
        end
    end))

    table.insert(connections, nextButton.MouseButton1Click:Connect(function()
        if currentPage < totalPages then
            currentPage = currentPage + 1
            update()
            if config.Callback then
                config.Callback(currentPage)
            end
            EventBus.Publish("PageChanged", id, config.Name, currentPage)
        end
    end))

    pagination.ID = id
    pagination.Instance = paginationFrame
    pagination.GetCurrentPage = function() return currentPage end
    pagination.SetPage = function(page)
        currentPage = math.clamp(page, 1, totalPages)
        update()
    end
    pagination.SetTotalPages = function(total)
        totalPages = total
        currentPage = math.min(currentPage, totalPages)
        update()
    end
    pagination.SetVisible = function(visible)
        paginationFrame.Visible = visible
    end
    pagination.Destroy = function()
        for _, conn in ipairs(connections) do
            conn:Disconnect()
        end
        paginationFrame:Destroy()
    end

    return pagination
end

local ProgressSystem = {}

ProgressSystem.Create = function(config, parent)
    config = config or {}
    local progress = {}
    local id = Utility.GenerateUUID()
    local currentValue = config.Value or 0
    local maxValue = config.Max or 100
    local isIndeterminate = config.Indeterminate or false

    local progressFrame = Utility.Create("Frame", {
        Name = "Progress_" .. (config.Name or "Unnamed"),
        Size = config.Size or UDim2.new(1, 0, 0, 8),
        BackgroundColor3 = ThemeManager.CurrentTheme.Surface,
        BackgroundTransparency = 0.3,
        BorderSizePixel = 0,
        LayoutOrder = #parent:GetChildren(),
        Parent = parent
    })

    local corner = Utility.Create("UICorner", {
        CornerRadius = UDim.new(0, 4),
        Parent = progressFrame
    })

    local fillBar = Utility.Create("Frame", {
        Name = "Fill",
        Size = UDim2.new(0, 0, 1, 0),
        BackgroundColor3 = config.Color or ThemeManager.CurrentTheme.Primary,
        BorderSizePixel = 0,
        Parent = progressFrame
    })

    local fillCorner = Utility.Create("UICorner", {
        CornerRadius = UDim.new(0, 4),
        Parent = fillBar
    })

    local indeterminateBar = Utility.Create("Frame", {
        Name = "Indeterminate",
        Size = UDim2.new(0.3, 0, 1, 0),
        Position = UDim2.new(-0.3, 0, 0, 0),
        BackgroundColor3 = config.Color or ThemeManager.CurrentTheme.Primary,
        BorderSizePixel = 0,
        Visible = isIndeterminate,
        Parent = progressFrame
    })

    local indeterminateCorner = Utility.Create("UICorner", {
        CornerRadius = UDim.new(0, 4),
        Parent = indeterminateBar
    })

    local indeterminateTween = nil
    if isIndeterminate then
        local function animateIndeterminate()
            indeterminateBar.Position = UDim2.new(-0.3, 0, 0, 0)
            indeterminateTween = TweenService:Create(indeterminateBar, TweenInfo.new(1.5, Enum.EasingStyle.Linear, Enum.EasingDirection.InOut, -1), {
                Position = UDim2.new(1, 0, 0, 0)
            })
            indeterminateTween:Play()
        end
        animateIndeterminate()
    end

    local function updateProgress()
        if not isIndeterminate then
            local percentage = math.clamp(currentValue / maxValue, 0, 1)
            fillBar.Size = UDim2.new(percentage, 0, 1, 0)
        end
    end

    updateProgress()

    progress.ID = id
    progress.Instance = progressFrame
    progress.SetValue = function(value)
        currentValue = value
        updateProgress()
    end
    progress.SetMax = function(max)
        maxValue = max
        updateProgress()
    end
    progress.SetIndeterminate = function(indeterminate)
        isIndeterminate = indeterminate
        fillBar.Visible = not isIndeterminate
        indeterminateBar.Visible = isIndeterminate
        if isIndeterminate then
            local function animateIndeterminate()
                indeterminateBar.Position = UDim2.new(-0.3, 0, 0, 0)
                indeterminateTween = TweenService:Create(indeterminateBar, TweenInfo.new(1.5, Enum.EasingStyle.Linear, Enum.EasingDirection.InOut, -1), {
                    Position = UDim2.new(1, 0, 0, 0)
                })
                indeterminateTween:Play()
            end
            animateIndeterminate()
        elseif indeterminateTween then
            indeterminateTween:Cancel()
        end
    end
    progress.SetVisible = function(visible)
        progressFrame.Visible = visible
    end
    progress.Destroy = function()
        if indeterminateTween then
            indeterminateTween:Cancel()
        end
        progressFrame:Destroy()
    end

    return progress
end

local SkeletonSystem = {}

SkeletonSystem.Create = function(config, parent)
    config = config or {}
    local skeleton = {}
    local id = Utility.GenerateUUID()

    local skeletonFrame = Utility.Create("Frame", {
        Name = "Skeleton_" .. (config.Name or "Unnamed"),
        Size = config.Size or UDim2.new(1, 0, 0, 60),
        BackgroundTransparency = 1,
        LayoutOrder = #parent:GetChildren(),
        Parent = parent
    })

    local elements = config.Elements or {
        {Type = "Rect", Size = UDim2.new(1, 0, 0, 20)},
        {Type = "Rect", Size = UDim2.new(0.7, 0, 0, 15), Position = UDim2.new(0, 0, 0, 30)},
        {Type = "Circle", Size = UDim2.new(0, 40, 0, 40), Position = UDim2.new(0, 0, 0, 0)}
    }

    local createdElements = {}

    for _, elem in ipairs(elements) do
        local element
        if elem.Type == "Rect" then
            element = Utility.Create("Frame", {
                Name = "SkeletonElement",
                Size = elem.Size or UDim2.new(1, 0, 0, 20),
                Position = elem.Position or UDim2.new(0, 0, 0, 0),
                BackgroundColor3 = ThemeManager.CurrentTheme.Surface,
                BackgroundTransparency = 0.2,
                BorderSizePixel = 0,
                Parent = skeletonFrame
            })
            
            local corner = Utility.Create("UICorner", {
                CornerRadius = UDim.new(0, 4),
                Parent = element
            })
        elseif elem.Type == "Circle" then
            element = Utility.Create("Frame", {
                Name = "SkeletonElement",
                Size = elem.Size or UDim2.new(0, 40, 0, 40),
                Position = elem.Position or UDim2.new(0, 0, 0, 0),
                BackgroundColor3 = ThemeManager.CurrentTheme.Surface,
                BackgroundTransparency = 0.2,
                BorderSizePixel = 0,
                Parent = skeletonFrame
            })
            
            local corner = Utility.Create("UICorner", {
                CornerRadius = UDim.new(1, 0),
                Parent = element
            })
        end

        if element then
            local shimmer = Utility.Create("Frame", {
                Name = "Shimmer",
                Size = UDim2.new(0.3, 0, 1, 0),
                Position = UDim2.new(-0.3, 0, 0, 0),
                BackgroundColor3 = Color3.fromRGB(255, 255, 255),
                BackgroundTransparency = 0.7,
                BorderSizePixel = 0,
                Parent = element
            })

            local shimmerCorner = Utility.Create("UICorner", {
                CornerRadius = element:FindFirstChildOfClass("UICorner") and element:FindFirstChildOfClass("UICorner").CornerRadius or UDim.new(0, 4),
                Parent = shimmer
            })

            local shimmerTween = TweenService:Create(shimmer, TweenInfo.new(1.5, Enum.EasingStyle.Linear, Enum.EasingDirection.InOut, -1), {
                Position = UDim2.new(1, 0, 0, 0)
            })
            shimmerTween:Play()

            table.insert(createdElements, {Element = element, Tween = shimmerTween})
        end
    end

    skeleton.ID = id
    skeleton.Instance = skeletonFrame
    skeleton.SetVisible = function(visible)
        skeletonFrame.Visible = visible
    end
    skeleton.Destroy = function()
        for _, elemData in ipairs(createdElements) do
            if elemData.Tween then
                elemData.Tween:Cancel()
            end
        end
        skeletonFrame:Destroy()
    end

    return skeleton
end

local EmptyStateSystem = {}

EmptyStateSystem.Create = function(config, parent)
    config = config or {}
    local emptyState = {}
    local id = Utility.GenerateUUID()

    local emptyFrame = Utility.Create("Frame", {
        Name = "EmptyState_" .. (config.Name or "Unnamed"),
        Size = config.Size or UDim2.new(1, 0, 0, 200),
        BackgroundTransparency = 1,
        LayoutOrder = #parent:GetChildren(),
        Parent = parent
    })

    local icon = Utility.Create("ImageLabel", {
        Name = "Icon",
        Size = config.IconSize or UDim2.new(0, 64, 0, 64),
        Position = UDim2.new(0.5, -32, 0, 20),
        BackgroundTransparency = 1,
        Image = config.Icon and GetIcon(config.Icon) or GetIcon("inbox"),
        ImageColor3 = ThemeManager.CurrentTheme.TextSecondary,
        ImageTransparency = 0.5,
        Parent = emptyFrame
    })

    local title = Utility.Create("TextLabel", {
        Name = "Title",
        Size = UDim2.new(1, 0, 0, 30),
        Position = UDim2.new(0, 0, 0, 100),
        BackgroundTransparency = 1,
        Text = config.Title or "No Data",
        TextColor3 = ThemeManager.CurrentTheme.TextPrimary,
        TextSize = 16,
        Font = Enum.Font.Code,
        Parent = emptyFrame
    })

    local description = Utility.Create("TextLabel", {
        Name = "Description",
        Size = UDim2.new(1, -40, 0, 40),
        Position = UDim2.new(0, 20, 0, 135),
        BackgroundTransparency = 1,
        Text = config.Description or "There's nothing here yet.",
        TextColor3 = ThemeManager.CurrentTheme.TextSecondary,
        TextSize = 12,
        Font = Enum.Font.Code,
        TextWrapped = true,
        Parent = emptyFrame
    })

    if config.Action then
        local actionButton = Utility.Create("TextButton", {
            Name = "Action",
            Size = UDim2.new(0, 120, 0, 32),
            Position = UDim2.new(0.5, -60, 0, 180),
            BackgroundColor3 = ThemeManager.CurrentTheme.Primary,
            BackgroundTransparency = 0.2,
            Text = config.Action.Text or "Action",
            TextColor3 = Color3.fromRGB(255, 255, 255),
            TextSize = 12,
            Font = Enum.Font.Code,
            AutoButtonColor = false,
            Parent = emptyFrame
        })

        local actionCorner = Utility.Create("UICorner", {
            CornerRadius = UDim.new(0, 6),
            Parent = actionButton
        })

        actionButton.MouseButton1Click:Connect(function()
            if config.Action.Callback then
                config.Action.Callback()
            end
        end)
    end

    emptyState.ID = id
    emptyState.Instance = emptyFrame
    emptyState.SetVisible = function(visible)
        emptyFrame.Visible = visible
    end
    emptyState.Destroy = function()
        emptyFrame:Destroy()
    end

    return emptyState
end

local BadgeSystem = {}

BadgeSystem.Create = function(config, parent)
    config = config or {}
    local badge = {}
    local id = Utility.GenerateUUID()

    local badgeFrame = Utility.Create("Frame", {
        Name = "Badge_" .. (config.Name or "Unnamed"),
        Size = config.Size or UDim2.new(0, 20, 0, 20),
        Position = config.Position or UDim2.new(1, -10, 0, -10),
        BackgroundColor3 = config.Color or ThemeManager.CurrentTheme.Error,
        BorderSizePixel = 0,
        Parent = parent
    })

    local corner = Utility.Create("UICorner", {
        CornerRadius = UDim.new(1, 0),
        Parent = badgeFrame
    })

    local label = Utility.Create("TextLabel", {
        Name = "Label",
        Size = UDim2.new(1, 0, 1, 0),
        BackgroundTransparency = 1,
        Text = config.Text or "",
        TextColor3 = Color3.fromRGB(255, 255, 255),
        TextSize = 10,
        Font = Enum.Font.Code,
        Parent = badgeFrame
    })

    badge.ID = id
    badge.Instance = badgeFrame
    badge.SetText = function(text)
        label.Text = text
        if text == "" or text == "0" then
            badgeFrame.Visible = false
        else
            badgeFrame.Visible = true
        end
    end
    badge.SetColor = function(color)
        badgeFrame.BackgroundColor3 = color
    end
    badge.SetVisible = function(visible)
        badgeFrame.Visible = visible
    end
    badge.Destroy = function()
        badgeFrame:Destroy()
    end

    return badge
end

local ChipSystem = {}

ChipSystem.Create = function(config, parent)
    config = config or {}
    local chip = {}
    local id = Utility.GenerateUUID()
    local isSelected = config.Selected or false
    local isRemovable = config.Removable or false

    local chipFrame = Utility.Create("TextButton", {
        Name = "Chip_" .. (config.Name or "Unnamed"),
        Size = config.Size or UDim2.new(0, 0, 0, 32),
        AutomaticSize = Enum.AutomaticSize.X,
        BackgroundColor3 = isSelected and (config.SelectedColor or ThemeManager.CurrentTheme.Primary) or ThemeManager.CurrentTheme.Surface,
        BackgroundTransparency = isSelected and 0.2 or 0.5,
        Text = "",
        AutoButtonColor = false,
        LayoutOrder = #parent:GetChildren(),
        Parent = parent
    })

    local corner = Utility.Create("UICorner", {
        CornerRadius = UDim.new(0, 16),
        Parent = chipFrame
    })

    local padding = Utility.Create("UIPadding", {
        PaddingLeft = UDim.new(0, 12),
        PaddingRight = UDim.new(0, isRemovable and 32 or 12),
        Parent = chipFrame
    })

    local icon
    if config.Icon then
        icon = Utility.Create("ImageLabel", {
            Name = "Icon",
            Size = UDim2.new(0, 16, 0, 16),
            Position = UDim2.new(0, 0, 0.5, -8),
            BackgroundTransparency = 1,
            Image = GetIcon(config.Icon),
            ImageColor3 = isSelected and Color3.fromRGB(255, 255, 255) or ThemeManager.CurrentTheme.TextPrimary,
            Parent = chipFrame
        })
    end

    local label = Utility.Create("TextLabel", {
        Name = "Label",
        Size = UDim2.new(0, 0, 1, 0),
        AutomaticSize = Enum.AutomaticSize.X,
        Position = config.Icon and UDim2.new(0, 22, 0, 0) or UDim2.new(0, 0, 0, 0),
        BackgroundTransparency = 1,
        Text = config.Text or "Chip",
        TextColor3 = isSelected and Color3.fromRGB(255, 255, 255) or ThemeManager.CurrentTheme.TextPrimary,
        TextSize = 12,
        Font = Enum.Font.Code,
        Parent = chipFrame
    })

    local removeButton
    if isRemovable then
        removeButton = Utility.Create("ImageButton", {
            Name = "Remove",
            Size = UDim2.new(0, 16, 0, 16),
            Position = UDim2.new(1, -24, 0.5, -8),
            BackgroundTransparency = 1,
            Image = GetIcon("x"),
            ImageColor3 = isSelected and Color3.fromRGB(255, 255, 255) or ThemeManager.CurrentTheme.TextSecondary,
            Parent = chipFrame
        })

        removeButton.MouseButton1Click:Connect(function()
            if config.OnRemove then
                config.OnRemove()
            end
            chip.Destroy()
        end)
    end

    chipFrame.MouseButton1Click:Connect(function()
        if config.Selectable ~= false then
            isSelected = not isSelected
            chipFrame.BackgroundColor3 = isSelected and (config.SelectedColor or ThemeManager.CurrentTheme.Primary) or ThemeManager.CurrentTheme.Surface
            chipFrame.BackgroundTransparency = isSelected and 0.2 or 0.5
            label.TextColor3 = isSelected and Color3.fromRGB(255, 255, 255) or ThemeManager.CurrentTheme.TextPrimary
            if icon then
                icon.ImageColor3 = isSelected and Color3.fromRGB(255, 255, 255) or ThemeManager.CurrentTheme.TextPrimary
            end
            if removeButton then
                removeButton.ImageColor3 = isSelected and Color3.fromRGB(255, 255, 255) or ThemeManager.CurrentTheme.TextSecondary
            end
            if config.OnSelect then
                config.OnSelect(isSelected)
            end
        end
        if config.OnClick then
            config.OnClick()
        end
    end)

    chip.ID = id
    chip.Instance = chipFrame
    chip.SetSelected = function(selected)
        isSelected = selected
        chipFrame.BackgroundColor3 = isSelected and (config.SelectedColor or ThemeManager.CurrentTheme.Primary) or ThemeManager.CurrentTheme.Surface
        chipFrame.BackgroundTransparency = isSelected and 0.2 or 0.5
        label.TextColor3 = isSelected and Color3.fromRGB(255, 255, 255) or ThemeManager.CurrentTheme.TextPrimary
        if icon then
            icon.ImageColor3 = isSelected and Color3.fromRGB(255, 255, 255) or ThemeManager.CurrentTheme.TextPrimary
        end
    end
    chip.SetText = function(text)
        label.Text = text
    end
    chip.SetVisible = function(visible)
        chipFrame.Visible = visible
    end
    chip.Destroy = function()
        chipFrame:Destroy()
    end

    return chip
end

local DividerSystem = {}

DividerSystem.Create = function(config, parent)
    config = config or {}
    local divider = {}

    local dividerFrame = Utility.Create("Frame", {
        Name = "Divider_" .. (config.Name or "Unnamed"),
        Size = config.Size or UDim2.new(1, 0, 0, 1),
        BackgroundColor3 = config.Color or ThemeManager.CurrentTheme.Surface,
        BackgroundTransparency = config.Transparency or 0.5,
        BorderSizePixel = 0,
        LayoutOrder = #parent:GetChildren(),
        Parent = parent
    })

    if config.Text then
        dividerFrame.Size = UDim2.new(1, 0, 0, 30)
        dividerFrame.BackgroundTransparency = 1

        local leftLine = Utility.Create("Frame", {
            Name = "LeftLine",
            Size = UDim2.new(0.5, -50, 0, 1),
            Position = UDim2.new(0, 0, 0.5, 0),
            BackgroundColor3 = config.Color or ThemeManager.CurrentTheme.Surface,
            BackgroundTransparency = config.Transparency or 0.5,
            BorderSizePixel = 0,
            Parent = dividerFrame
        })

        local label = Utility.Create("TextLabel", {
            Name = "Label",
            Size = UDim2.new(0, 100, 1, 0),
            Position = UDim2.new(0.5, -50, 0, 0),
            BackgroundTransparency = 1,
            Text = config.Text,
            TextColor3 = ThemeManager.CurrentTheme.TextSecondary,
            TextSize = 12,
            Font = Enum.Font.Code,
            TextXAlignment = Enum.TextXAlignment.Center,
            Parent = dividerFrame
        })

        local rightLine = Utility.Create("Frame", {
            Name = "RightLine",
            Size = UDim2.new(0.5, -50, 0, 1),
            Position = UDim2.new(0.5, 50, 0.5, 0),
            BackgroundColor3 = config.Color or ThemeManager.CurrentTheme.Surface,
            BackgroundTransparency = config.Transparency or 0.5,
            BorderSizePixel = 0,
            Parent = dividerFrame
        })
    end

    divider.Instance = dividerFrame
    divider.SetVisible = function(visible)
        dividerFrame.Visible = visible
    end
    divider.Destroy = function()
        dividerFrame:Destroy()
    end

    return divider
end

local SpacerSystem = {}

SpacerSystem.Create = function(config, parent)
    config = config or {}
    local spacer = {}

    local spacerFrame = Utility.Create("Frame", {
        Name = "Spacer_" .. (config.Name or "Unnamed"),
        Size = config.Size or UDim2.new(1, 0, 0, 20),
        BackgroundTransparency = 1,
        LayoutOrder = #parent:GetChildren(),
        Parent = parent
    })

    spacer.Instance = spacerFrame
    spacer.SetSize = function(size)
        spacerFrame.Size = size
    end
    spacer.SetVisible = function(visible)
        spacerFrame.Visible = visible
    end
    spacer.Destroy = function()
        spacerFrame:Destroy()
    end

    return spacer
end

local WatermarkSystem = {}

WatermarkSystem.Create = function(config)
    config = config or {}
    local watermark = {}
    local id = Utility.GenerateUUID()
    local isDragging = false
    local dragStart = nil
    local startPos = nil
    local fadeTween = nil
    local isFading = false

    local watermarkGui = Utility.Create("ScreenGui", {
        Name = "Watermark_" .. id,
        DisplayOrder = 999999,
        ResetOnSpawn = false,
        Parent = CoreGui
    })

    local watermarkFrame = Utility.Create("Frame", {
        Name = "WatermarkFrame",
        Size = config.Size or UDim2.new(0, 200, 0, 40),
        Position = config.Position or UDim2.new(0, 20, 0, 20),
        BackgroundColor3 = ThemeManager.CurrentTheme.Background,
        BackgroundTransparency = 0.2,
        BorderSizePixel = 0,
        Active = true,
        Draggable = false,
        Parent = watermarkGui
    })

    local corner = Utility.Create("UICorner", {
        CornerRadius = UDim.new(0, 8),
        Parent = watermarkFrame
    })

    local stroke = Utility.Create("UIStroke", {
        Color = ThemeManager.CurrentTheme.Primary,
        Thickness = 1,
        Transparency = 0.5,
        Parent = watermarkFrame
    })

    local icon = Utility.Create("ImageLabel", {
        Name = "Icon",
        Size = UDim2.new(0, 24, 0, 24),
        Position = UDim2.new(0, 10, 0.5, -12),
        BackgroundTransparency = 1,
        Image = config.Icon and GetIcon(config.Icon) or GetIcon("shield"),
        ImageColor3 = ThemeManager.CurrentTheme.Primary,
        Parent = watermarkFrame
    })

    local label = Utility.Create("TextLabel", {
        Name = "Label",
        Size = UDim2.new(1, -44, 1, 0),
        Position = UDim2.new(0, 38, 0, 0),
        BackgroundTransparency = 1,
        Text = config.Text or "AdvancedUI",
        TextColor3 = Color3.fromRGB(255, 255, 255),
        TextSize = 14,
        Font = Enum.Font.Code,
        TextXAlignment = Enum.TextXAlignment.Left,
        Parent = watermarkFrame
    })

    local dragConnection1 = watermarkFrame.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            isDragging = true
            dragStart = input.Position
            startPos = watermarkFrame.Position
            
            if fadeTween then
                fadeTween:Cancel()
            end
            fadeTween = TweenService:Create(watermarkFrame, TweenInfo.new(0.3), {
                BackgroundTransparency = 0.8,
                ImageTransparency = 0.8
            })
            fadeTween:Play()
            icon.ImageTransparency = 0.8
            label.TextTransparency = 0.8
            stroke.Transparency = 0.8
            isFading = true
        end
    end)

    local dragConnection2 = UserInputService.InputChanged:Connect(function(input)
        if isDragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
            local delta = input.Position - dragStart
            watermarkFrame.Position = UDim2.new(
                startPos.X.Scale, startPos.X.Offset + delta.X,
                startPos.Y.Scale, startPos.Y.Offset + delta.Y
            )
        end
    end)

    local dragConnection3 = UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            isDragging = false
            
            if fadeTween then
                fadeTween:Cancel()
            end
            fadeTween = TweenService:Create(watermarkFrame, TweenInfo.new(0.3), {
                BackgroundTransparency = 0.2
            })
            fadeTween:Play()
            icon.ImageTransparency = 0
            label.TextTransparency = 0
            stroke.Transparency = 0.5
            isFading = false
        end
    end)

    watermark.ID = id
    watermark.Instance = watermarkGui
    watermark.SetText = function(text)
        label.Text = text
    end
    watermark.SetPosition = function(position)
        watermarkFrame.Position = position
    end
    watermark.SetVisible = function(visible)
        watermarkGui.Enabled = visible
    end
    watermark.Destroy = function()
        dragConnection1:Disconnect()
        dragConnection2:Disconnect()
        dragConnection3:Disconnect()
        if fadeTween then
            fadeTween:Cancel()
        end
        watermarkGui:Destroy()
    end

    return watermark
end

local NotificationSystem = {}

NotificationSystem.Create = function(config)
    config = config or {}
    local notification = {}
    local id = Utility.GenerateUUID()
    local connections = {}

    local notifGui = Utility.Create("ScreenGui", {
        Name = "Notification_" .. id,
        DisplayOrder = 999998,
        ResetOnSpawn = false,
        Parent = CoreGui
    })

    local notifFrame = Utility.Create("Frame", {
        Name = "NotificationFrame",
        Size = UDim2.new(0, 320, 0, 0),
        Position = UDim2.new(1, -340, 1, -100),
        BackgroundColor3 = ThemeManager.CurrentTheme.Background,
        BackgroundTransparency = 0.1,
        BorderSizePixel = 0,
        ClipsDescendants = true,
        Parent = notifGui
    })

    local corner = Utility.Create("UICorner", {
        CornerRadius = UDim.new(0, 12),
        Parent = notifFrame
    })

    local stroke = Utility.Create("UIStroke", {
        Color = config.Type == "Error" and ThemeManager.CurrentTheme.Error or 
                config.Type == "Warning" and ThemeManager.CurrentTheme.Warning or 
                config.Type == "Success" and ThemeManager.CurrentTheme.Success or 
                ThemeManager.CurrentTheme.Primary,
        Thickness = 2,
        Parent = notifFrame
    })

    local icon = Utility.Create("ImageLabel", {
        Name = "Icon",
        Size = UDim2.new(0, 32, 0, 32),
        Position = UDim2.new(0, 15, 0, 15),
        BackgroundTransparency = 1,
        Image = config.Type == "Error" and GetIcon("alert-circle") or 
                config.Type == "Warning" and GetIcon("alert-triangle") or 
                config.Type == "Success" and GetIcon("check-circle") or 
                GetIcon("info"),
        ImageColor3 = config.Type == "Error" and ThemeManager.CurrentTheme.Error or 
                      config.Type == "Warning" and ThemeManager.CurrentTheme.Warning or 
                      config.Type == "Success" and ThemeManager.CurrentTheme.Success or 
                      ThemeManager.CurrentTheme.Primary,
        Parent = notifFrame
    })

    local title = Utility.Create("TextLabel", {
        Name = "Title",
        Size = UDim2.new(1, -70, 0, 25),
        Position = UDim2.new(0, 55, 0, 10),
        BackgroundTransparency = 1,
        Text = config.Title or "Notification",
        TextColor3 = Color3.fromRGB(255, 255, 255),
        TextSize = 16,
        Font = Enum.Font.Code,
        TextXAlignment = Enum.TextXAlignment.Left,
        Parent = notifFrame
    })

    local message = Utility.Create("TextLabel", {
        Name = "Message",
        Size = UDim2.new(1, -70, 0, 0),
        Position = UDim2.new(0, 55, 0, 35),
        AutomaticSize = Enum.AutomaticSize.Y,
        BackgroundTransparency = 1,
        Text = config.Message or "",
        TextColor3 = ThemeManager.CurrentTheme.TextPrimary,
        TextSize = 13,
        Font = Enum.Font.Code,
        TextXAlignment = Enum.TextXAlignment.Left,
        TextWrapped = true,
        Parent = notifFrame
    })

    local closeButton = Utility.Create("ImageButton", {
        Name = "Close",
        Size = UDim2.new(0, 20, 0, 20),
        Position = UDim2.new(1, -30, 0, 10),
        BackgroundTransparency = 1,
        Image = GetIcon("x"),
        ImageColor3 = ThemeManager.CurrentTheme.TextSecondary,
        Parent = notifFrame
    })

    local progressBar = Utility.Create("Frame", {
        Name = "ProgressBar",
        Size = UDim2.new(1, 0, 0, 3),
        Position = UDim2.new(0, 0, 1, -3),
        BackgroundColor3 = stroke.Color,
        BorderSizePixel = 0,
        Parent = notifFrame
    })

    local function closeNotification()
        local closeTween = TweenService:Create(notifFrame, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {
            Position = UDim2.new(1, 20, notifFrame.Position.Y.Scale, notifFrame.Position.Y.Offset),
            BackgroundTransparency = 1
        })
        closeTween:Play()
        closeTween.Completed:Wait()
        notifGui:Destroy()
    end

    table.insert(connections, closeButton.MouseButton1Click:Connect(closeNotification))

    task.delay(0.1, function()
        local contentHeight = math.max(80, 45 + message.AbsoluteSize.Y)
        notifFrame.Size = UDim2.new(0, 320, 0, contentHeight)
        
        local showTween = TweenService:Create(notifFrame, TweenInfo.new(0.4, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
            Position = UDim2.new(1, -340, 1, -contentHeight - 20)
        })
        showTween:Play()

        if config.Duration ~= 0 then
            local duration = config.Duration or 5
            local progressTween = TweenService:Create(progressBar, TweenInfo.new(duration, Enum.EasingStyle.Linear), {
                Size = UDim2.new(0, 0, 0, 3)
            })
            progressTween:Play()
            
            task.delay(duration, function()
                if notifGui and notifGui.Parent then
                    closeNotification()
                end
            end)
        end
    end)

    notification.ID = id
    notification.Instance = notifGui
    notification.Close = closeNotification
    notification.Destroy = function()
        for _, conn in ipairs(connections) do
            conn:Disconnect()
        end
        notifGui:Destroy()
    end

    return notification
end

local ToastSystem = {}

ToastSystem.Create = function(config)
    config = config or {}
    local toast = {}
    local id = Utility.GenerateUUID()

    local toastGui = Utility.Create("ScreenGui", {
        Name = "Toast_" .. id,
        DisplayOrder = 999997,
        ResetOnSpawn = false,
        Parent = CoreGui
    })

    local toastFrame = Utility.Create("Frame", {
        Name = "ToastFrame",
        Size = UDim2.new(0, 0, 0, 48),
        Position = UDim2.new(0.5, 0, 0, -60),
        BackgroundColor3 = config.Type == "Error" and ThemeManager.CurrentTheme.Error or 
                           config.Type == "Success" and ThemeManager.CurrentTheme.Success or 
                           ThemeManager.CurrentTheme.Background,
        BackgroundTransparency = 0.1,
        BorderSizePixel = 0,
        AutomaticSize = Enum.AutomaticSize.X,
        Parent = toastGui
    })

    local corner = Utility.Create("UICorner", {
        CornerRadius = UDim.new(0, 8),
        Parent = toastFrame
    })

    local shadow = Utility.CreateShadow(toastFrame, 20, 0.3)

    local padding = Utility.Create("UIPadding", {
        PaddingLeft = UDim.new(0, 16),
        PaddingRight = UDim.new(0, 16),
        Parent = toastFrame
    })

    local icon = Utility.Create("ImageLabel", {
        Name = "Icon",
        Size = UDim2.new(0, 20, 0, 20),
        Position = UDim2.new(0, 0, 0.5, -10),
        BackgroundTransparency = 1,
        Image = config.Type == "Error" and GetIcon("alert-circle") or 
                config.Type == "Success" and GetIcon("check") or 
                GetIcon("info"),
        ImageColor3 = Color3.fromRGB(255, 255, 255),
        Parent = toastFrame
    })

    local label = Utility.Create("TextLabel", {
        Name = "Label",
        Size = UDim2.new(0, 0, 1, 0),
        AutomaticSize = Enum.AutomaticSize.X,
        Position = UDim2.new(0, 28, 0, 0),
        BackgroundTransparency = 1,
        Text = config.Message or "Toast message",
        TextColor3 = Color3.fromRGB(255, 255, 255),
        TextSize = 14,
        Font = Enum.Font.Code,
        Parent = toastFrame
    })

    local showTween = TweenService:Create(toastFrame, TweenInfo.new(0.4, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
        Position = UDim2.new(0.5, -toastFrame.AbsoluteSize.X / 2, 0, 80)
    })
    showTween:Play()

    task.delay(config.Duration or 3, function()
        local hideTween = TweenService:Create(toastFrame, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {
            Position = UDim2.new(0.5, -toastFrame.AbsoluteSize.X / 2, 0, -60),
            BackgroundTransparency = 1
        })
        hideTween:Play()
        hideTween.Completed:Wait()
        toastGui:Destroy()
    end)

    toast.ID = id
    toast.Instance = toastGui
    toast.Destroy = function()
        toastGui:Destroy()
    end

    return toast
end

local DialogSystem = {}

DialogSystem.Create = function(config)
    config = config or {}
    local dialog = {}
    local id = Utility.GenerateUUID()
    local connections = {}

    local dialogGui = Utility.Create("ScreenGui", {
        Name = "Dialog_" .. id,
        DisplayOrder = 999996,
        ResetOnSpawn = false,
        Parent = CoreGui
    })

    local overlay = Utility.Create("Frame", {
        Name = "Overlay",
        Size = UDim2.new(1, 0, 1, 0),
        BackgroundColor3 = Color3.fromRGB(0, 0, 0),
        BackgroundTransparency = 1,
        Parent = dialogGui
    })

    local dialogFrame = Utility.Create("Frame", {
        Name = "DialogFrame",
        Size = config.Size or UDim2.new(0, 400, 0, 0),
        Position = UDim2.new(0.5, -200, 0.5, 0),
        BackgroundColor3 = ThemeManager.CurrentTheme.Background,
        BackgroundTransparency = 0.1,
        BorderSizePixel = 0,
        AutomaticSize = Enum.AutomaticSize.Y,
        Parent = overlay
    })

    local corner = Utility.Create("UICorner", {
        CornerRadius = UDim.new(0, 16),
        Parent = dialogFrame
    })

    local shadow = Utility.CreateShadow(dialogFrame, 30, 0.4)

    local title = Utility.Create("TextLabel", {
        Name = "Title",
        Size = UDim2.new(1, -40, 0, 50),
        Position = UDim2.new(0, 20, 0, 0),
        BackgroundTransparency = 1,
        Text = config.Title or "Dialog",
        TextColor3 = Color3.fromRGB(255, 255, 255),
        TextSize = 20,
        Font = Enum.Font.Code,
        TextXAlignment = Enum.TextXAlignment.Left,
        Parent = dialogFrame
    })

    local closeButton = Utility.Create("ImageButton", {
        Name = "Close",
        Size = UDim2.new(0, 24, 0, 24),
        Position = UDim2.new(1, -36, 0, 13),
        BackgroundTransparency = 1,
        Image = GetIcon("x"),
        ImageColor3 = ThemeManager.CurrentTheme.TextSecondary,
        Parent = dialogFrame
    })

    local content = Utility.Create("TextLabel", {
        Name = "Content",
        Size = UDim2.new(1, -40, 0, 0),
        Position = UDim2.new(0, 20, 0, 50),
        AutomaticSize = Enum.AutomaticSize.Y,
        BackgroundTransparency = 1,
        Text = config.Content or "",
        TextColor3 = ThemeManager.CurrentTheme.TextPrimary,
        TextSize = 14,
        Font = Enum.Font.Code,
        TextWrapped = true,
        Parent = dialogFrame
    })

    local buttonFrame = Utility.Create("Frame", {
        Name = "Buttons",
        Size = UDim2.new(1, -40, 0, 50),
        Position = UDim2.new(0, 20, 0, 50 + content.AbsoluteSize.Y + 20),
        BackgroundTransparency = 1,
        Parent = dialogFrame
    })

    local buttonList = Utility.Create("UIListLayout", {
        Padding = UDim.new(0, 10),
        FillDirection = Enum.FillDirection.Horizontal,
        HorizontalAlignment = Enum.HorizontalAlignment.Right,
        Parent = buttonFrame
    })

    local function closeDialog()
        local closeTween = TweenService:Create(dialogFrame, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {
            Position = UDim2.new(0.5, -200, 0.5, 50),
            BackgroundTransparency = 1
        })
        local overlayTween = TweenService:Create(overlay, TweenInfo.new(0.3), {
            BackgroundTransparency = 1
        })
        closeTween:Play()
        overlayTween:Play()
        closeTween.Completed:Wait()
        dialogGui:Destroy()
    end

    table.insert(connections, closeButton.MouseButton1Click:Connect(function()
        if config.OnCancel then
            config.OnCancel()
        end
        closeDialog()
    end))

    if config.Buttons then
        for _, btnConfig in ipairs(config.Buttons) do
            local btn = Utility.Create("TextButton", {
                Name = btnConfig.Name or "Button",
                Size = UDim2.new(0, 100, 0, 36),
                BackgroundColor3 = btnConfig.Primary and ThemeManager.CurrentTheme.Primary or ThemeManager.CurrentTheme.Surface,
                BackgroundTransparency = 0.2,
                Text = btnConfig.Text or "Button",
                TextColor3 = Color3.fromRGB(255, 255, 255),
                TextSize = 14,
                Font = Enum.Font.Code,
                AutoButtonColor = false,
                Parent = buttonFrame
            })

            local btnCorner = Utility.Create("UICorner", {
                CornerRadius = UDim.new(0, 8),
                Parent = btn
            })

            btn.MouseButton1Click:Connect(function()
                if btnConfig.Callback then
                    btnConfig.Callback()
                end
                closeDialog()
            end)
        end
    end

    local showOverlayTween = TweenService:Create(overlay, TweenInfo.new(0.3), {
        BackgroundTransparency = 0.5
    })
    local showDialogTween = TweenService:Create(dialogFrame, TweenInfo.new(0.4, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
        Position = UDim2.new(0.5, -200, 0.5, -dialogFrame.AbsoluteSize.Y / 2)
    })
    showOverlayTween:Play()
    showDialogTween:Play()

    dialog.ID = id
    dialog.Instance = dialogGui
    dialog.Close = closeDialog
    dialog.Destroy = function()
        for _, conn in ipairs(connections) do
            conn:Disconnect()
        end
        dialogGui:Destroy()
    end

    return dialog
end

local MenuSystem = {}

MenuSystem.Create = function(config, parent)
    config = config or {}
    local menu = {}
    local id = Utility.GenerateUUID()
    local isOpen = false
    local connections = {}

    local menuButton = Utility.Create("ImageButton", {
        Name = "MenuButton_" .. (config.Name or "Unnamed"),
        Size = config.Size or UDim2.new(0, 40, 0, 40),
        Position = config.Position or UDim2.new(1, -50, 0, 10),
        BackgroundColor3 = ThemeManager.CurrentTheme.Primary,
        BackgroundTransparency = 0.3,
        Image = GetIcon("menu"),
        ImageColor3 = Color3.fromRGB(255, 255, 255),
        AutoButtonColor = false,
        Parent = parent
    })

    local buttonCorner = Utility.Create("UICorner", {
        CornerRadius = UDim.new(0, 8),
        Parent = menuButton
    })

    local menuFrame = Utility.Create("Frame", {
        Name = "MenuFrame",
        Size = UDim2.new(0, 200, 0, 0),
        Position = UDim2.new(1, -210, 0, 60),
        BackgroundColor3 = ThemeManager.CurrentTheme.Background,
        BackgroundTransparency = 0.1,
        BorderSizePixel = 0,
        ClipsDescendants = true,
        Visible = false,
        Parent = parent
    })

    local menuCorner = Utility.Create("UICorner", {
        CornerRadius = UDim.new(0, 12),
        Parent = menuFrame
    })

    local shadow = Utility.CreateShadow(menuFrame, 20, 0.3)

    local listLayout = Utility.Create("UIListLayout", {
        Padding = UDim.new(0, 5),
        SortOrder = Enum.SortOrder.LayoutOrder,
        Parent = menuFrame
    })

    local padding = Utility.Create("UIPadding", {
        PaddingTop = UDim.new(0, 10),
        PaddingBottom = UDim.new(0, 10),
        PaddingLeft = UDim.new(0, 10),
        PaddingRight = UDim.new(0, 10),
        Parent = menuFrame
    })

    local menuItems = {}

    local function updateMenuHeight()
        local height = 25
        for _, item in ipairs(menuItems) do
            height = height + 40 + 5
        end
        return math.min(height, 300)
    end

    local function toggleMenu()
        isOpen = not isOpen
        menuFrame.Visible = true
        
        local targetSize = isOpen and UDim2.new(0, 200, 0, updateMenuHeight()) or UDim2.new(0, 200, 0, 0)
        local tween = TweenService:Create(menuFrame, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
            Size = targetSize
        })
        tween:Play()
        
        if not isOpen then
            tween.Completed:Connect(function()
                menuFrame.Visible = false
            end)
        end
    end

    table.insert(connections, menuButton.MouseButton1Click:Connect(toggleMenu))

    menu.ID = id
    menu.Instance = menuButton
    menu.MenuFrame = menuFrame
    menu.AddItem = function(itemConfig)
        local itemButton = Utility.Create("TextButton", {
            Name = itemConfig.Name or "MenuItem",
            Size = UDim2.new(1, 0, 0, 40),
            BackgroundColor3 = ThemeManager.CurrentTheme.Surface,
            BackgroundTransparency = 0.5,
            Text = "",
            AutoButtonColor = false,
            LayoutOrder = #menuItems,
            Parent = menuFrame
        })

        local itemCorner = Utility.Create("UICorner", {
            CornerRadius = UDim.new(0, 6),
            Parent = itemButton
        })

        if itemConfig.Icon then
            local icon = Utility.Create("ImageLabel", {
                Name = "Icon",
                Size = UDim2.new(0, 20, 0, 20),
                Position = UDim2.new(0, 10, 0.5, -10),
                BackgroundTransparency = 1,
                Image = GetIcon(itemConfig.Icon),
                ImageColor3 = ThemeManager.CurrentTheme.TextPrimary,
                Parent = itemButton
            })
        end

        local label = Utility.Create("TextLabel", {
            Name = "Label",
            Size = UDim2.new(1, -50, 1, 0),
            Position = UDim2.new(0, itemConfig.Icon and 40 or 15, 0, 0),
            BackgroundTransparency = 1,
            Text = itemConfig.Text or "Item",
            TextColor3 = ThemeManager.CurrentTheme.TextPrimary,
            TextSize = 14,
            Font = Enum.Font.Code,
            TextXAlignment = Enum.TextXAlignment.Left,
            Parent = itemButton
        })

        itemButton.MouseButton1Click:Connect(function()
            if itemConfig.Callback then
                itemConfig.Callback()
            end
            toggleMenu()
        end)

        table.insert(menuItems, itemButton)
        return itemButton
    end
    menu.Open = function()
        if not isOpen then
            toggleMenu()
        end
    end
    menu.Close = function()
        if isOpen then
            toggleMenu()
        end
    end
    menu.SetVisible = function(visible)
        menuButton.Visible = visible
        if not visible then
            menuFrame.Visible = false
            isOpen = false
        end
    end
    menu.Destroy = function()
        for _, conn in ipairs(connections) do
            conn:Disconnect()
        end
        menuButton:Destroy()
        menuFrame:Destroy()
    end

    return menu
end

local ContextMenuSystem = {}

ContextMenuSystem.Create = function(config)
    config = config or {}
    local contextMenu = {}
    local id = Utility.GenerateUUID()
    local connections = {}

    local menuGui = Utility.Create("ScreenGui", {
        Name = "ContextMenu_" .. id,
        DisplayOrder = 999995,
        ResetOnSpawn = false,
        Parent = CoreGui
    })

    local menuFrame = Utility.Create("Frame", {
        Name = "MenuFrame",
        Size = UDim2.new(0, 180, 0, 0),
        Position = UDim2.new(0, config.Position and config.Position.X or 0, 0, config.Position and config.Position.Y or 0),
        BackgroundColor3 = ThemeManager.CurrentTheme.Background,
        BackgroundTransparency = 0.1,
        BorderSizePixel = 0,
        ClipsDescendants = true,
        Parent = menuGui
    })

    local menuCorner = Utility.Create("UICorner", {
        CornerRadius = UDim.new(0, 8),
        Parent = menuFrame
    })

    local shadow = Utility.CreateShadow(menuFrame, 15, 0.3)

    local listLayout = Utility.Create("UIListLayout", {
        Padding = UDim.new(0, 2),
        SortOrder = Enum.SortOrder.LayoutOrder,
        Parent = menuFrame
    })

    local padding = Utility.Create("UIPadding", {
        PaddingTop = UDim.new(0, 5),
        PaddingBottom = UDim.new(0, 5),
        Parent = menuFrame
    })

    local menuItems = {}

    local function closeMenu()
        menuGui:Destroy()
    end

    table.insert(connections, UserInputService.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.MouseButton2 then
            local pos = input.Position
            local menuPos = menuFrame.AbsolutePosition
            local menuSize = menuFrame.AbsoluteSize
            
            if pos.X < menuPos.X or pos.X > menuPos.X + menuSize.X or
               pos.Y < menuPos.Y or pos.Y > menuPos.Y + menuSize.Y then
                closeMenu()
            end
        end
    end))

    contextMenu.ID = id
    contextMenu.Instance = menuGui
    contextMenu.AddItem = function(itemConfig)
        local itemButton = Utility.Create("TextButton", {
            Name = itemConfig.Name or "MenuItem",
            Size = UDim2.new(1, -10, 0, 32),
            Position = UDim2.new(0, 5, 0, 0),
            BackgroundColor3 = ThemeManager.CurrentTheme.Surface,
            BackgroundTransparency = 1,
            Text = "",
            AutoButtonColor = false,
            LayoutOrder = #menuItems,
            Parent = menuFrame
        })

        local itemCorner = Utility.Create("UICorner", {
            CornerRadius = UDim.new(0, 4),
            Parent = itemButton
        })

        if itemConfig.Icon then
            local icon = Utility.Create("ImageLabel", {
                Name = "Icon",
                Size = UDim2.new(0, 16, 0, 16),
                Position = UDim2.new(0, 8, 0.5, -8),
                BackgroundTransparency = 1,
                Image = GetIcon(itemConfig.Icon),
                ImageColor3 = ThemeManager.CurrentTheme.TextPrimary,
                Parent = itemButton
            })
        end

        local label = Utility.Create("TextLabel", {
            Name = "Label",
            Size = UDim2.new(1, -40, 1, 0),
            Position = UDim2.new(0, itemConfig.Icon and 32 or 12, 0, 0),
            BackgroundTransparency = 1,
            Text = itemConfig.Text or "Item",
            TextColor3 = ThemeManager.CurrentTheme.TextPrimary,
            TextSize = 13,
            Font = Enum.Font.Code,
            TextXAlignment = Enum.TextXAlignment.Left,
            Parent = itemButton
        })

        if itemConfig.Shortcut then
            local shortcut = Utility.Create("TextLabel", {
                Name = "Shortcut",
                Size = UDim2.new(0, 50, 1, 0),
                Position = UDim2.new(1, -55, 0, 0),
                BackgroundTransparency = 1,
                Text = itemConfig.Shortcut,
                TextColor3 = ThemeManager.CurrentTheme.TextSecondary,
                TextSize = 11,
                Font = Enum.Font.Code,
                TextXAlignment = Enum.TextXAlignment.Right,
                Parent = itemButton
            })
        end

        itemButton.MouseEnter:Connect(function()
            TweenService:Create(itemButton, TweenInfo.new(0.2), {BackgroundTransparency = 0.5}):Play()
        end)

        itemButton.MouseLeave:Connect(function()
            TweenService:Create(itemButton, TweenInfo.new(0.2), {BackgroundTransparency = 1}):Play()
        end)

        itemButton.MouseButton1Click:Connect(function()
            if itemConfig.Callback then
                itemConfig.Callback()
            end
            closeMenu()
        end)

        table.insert(menuItems, itemButton)
        
        menuFrame.Size = UDim2.new(0, 180, 0, #menuItems * 34 + 10)
        
        return itemButton
    end
    contextMenu.AddSeparator = function()
        local separator = Utility.Create("Frame", {
            Name = "Separator",
            Size = UDim2.new(1, -20, 0, 1),
            Position = UDim2.new(0, 10, 0, 0),
            BackgroundColor3 = ThemeManager.CurrentTheme.Surface,
            BackgroundTransparency = 0.5,
            BorderSizePixel = 0,
            LayoutOrder = #menuItems,
            Parent = menuFrame
        })
        table.insert(menuItems, separator)
        menuFrame.Size = UDim2.new(0, 180, 0, #menuItems * 34 + 10)
    end
    contextMenu.Close = closeMenu
    contextMenu.Destroy = function()
        for _, conn in ipairs(connections) do
            conn:Disconnect()
        end
        menuGui:Destroy()
    end

    return contextMenu
end

local TooltipSystem = {}

TooltipSystem.Create = function(config)
    config = config or {}
    local tooltip = {}
    local id = Utility.GenerateUUID()
    local connections = {}

    local tooltipGui = Utility.Create("ScreenGui", {
        Name = "Tooltip_" .. id,
        DisplayOrder = 999994,
        ResetOnSpawn = false,
        Parent = CoreGui
    })

    local tooltipFrame = Utility.Create("Frame", {
        Name = "TooltipFrame",
        Size = UDim2.new(0, 0, 0, 0),
        AutomaticSize = Enum.AutomaticSize.XY,
        BackgroundColor3 = ThemeManager.CurrentTheme.Background,
        BackgroundTransparency = 0.1,
        BorderSizePixel = 0,
        Visible = false,
        Parent = tooltipGui
    })

    local corner = Utility.Create("UICorner", {
        CornerRadius = UDim.new(0, 6),
        Parent = tooltipFrame
    })

    local shadow = Utility.CreateShadow(tooltipFrame, 10, 0.3)

    local padding = Utility.Create("UIPadding", {
        PaddingTop = UDim.new(0, 8),
        PaddingBottom = UDim.new(0, 8),
        PaddingLeft = UDim.new(0, 12),
        PaddingRight = UDim.new(0, 12),
        Parent = tooltipFrame
    })

    local label = Utility.Create("TextLabel", {
        Name = "Label",
        Size = UDim2.new(0, 0, 0, 0),
        AutomaticSize = Enum.AutomaticSize.XY,
        BackgroundTransparency = 1,
        Text = config.Text or "Tooltip",
        TextColor3 = ThemeManager.CurrentTheme.TextPrimary,
        TextSize = 12,
        Font = Enum.Font.Code,
        Parent = tooltipFrame
    })

    local targetElement = config.Target
    local showDelay = config.Delay or 0.5
    local hideDelay = config.HideDelay or 0.1
    local showTask = nil
    local isVisible = false

    local function showTooltip()
        if showTask then
            task.cancel(showTask)
        end
        
        showTask = task.delay(showDelay, function()
            if targetElement and targetElement.Parent then
                local targetPos = targetElement.AbsolutePosition
                local targetSize = targetElement.AbsoluteSize
                
                tooltipFrame.Position = UDim2.new(0, targetPos.X + targetSize.X / 2 - tooltipFrame.AbsoluteSize.X / 2, 0, targetPos.Y - tooltipFrame.AbsoluteSize.Y - 8)
                tooltipFrame.Visible = true
                isVisible = true
                
                TweenService:Create(tooltipFrame, TweenInfo.new(0.2), {BackgroundTransparency = 0.1}):Play()
            end
        end)
    end

    local function hideTooltip()
        if showTask then
            task.cancel(showTask)
            showTask = nil
        end
        
        if isVisible then
            local hideTween = TweenService:Create(tooltipFrame, TweenInfo.new(0.2), {BackgroundTransparency = 1})
            hideTween:Play()
            hideTween.Completed:Connect(function()
                tooltipFrame.Visible = false
                isVisible = false
            end)
        end
    end

    if targetElement then
        table.insert(connections, targetElement.MouseEnter:Connect(showTooltip))
        table.insert(connections, targetElement.MouseLeave:Connect(hideTooltip))
    end

    tooltip.ID = id
    tooltip.Instance = tooltipGui
    tooltip.SetText = function(text)
        label.Text = text
    end
    tooltip.SetTarget = function(newTarget)
        for _, conn in ipairs(connections) do
            conn:Disconnect()
        end
        connections = {}
        
        targetElement = newTarget
        if targetElement then
            table.insert(connections, targetElement.MouseEnter:Connect(showTooltip))
            table.insert(connections, targetElement.MouseLeave:Connect(hideTooltip))
        end
    end
    tooltip.Show = showTooltip
    tooltip.Hide = hideTooltip
    tooltip.Destroy = function()
        for _, conn in ipairs(connections) do
            conn:Disconnect()
        end
        if showTask then
            task.cancel(showTask)
        end
        tooltipGui:Destroy()
    end

    return tooltip
end

local AdvancedUI = {}

AdvancedUI.Version = "2.0.0"
AdvancedUI.ThemeManager = ThemeManager
AdvancedUI.EventBus = EventBus
AdvancedUI.Utility = Utility

-- 修复: WindowSystem -> WindowManager
AdvancedUI.CreateWindow = function(config)
    return WindowManager.Create(config)
end

AdvancedUI.CreateButton = function(config, parent)
    return ButtonSystem.Create(config, parent)
end

AdvancedUI.CreateToggle = function(config, parent)
    return ToggleSystem.Create(config, parent)
end

AdvancedUI.CreateSlider = function(config, parent)
    return SliderSystem.Create(config, parent)
end

AdvancedUI.CreateDropdown = function(config, parent)
    return DropdownSystem.Create(config, parent)
end

-- 修复: TextboxSystem -> InputSystem
AdvancedUI.CreateTextbox = function(config, parent)
    return InputSystem.Create(config, parent)
end

-- 修复: 添加 CreateInput 作为别名
AdvancedUI.CreateInput = function(config, parent)
    return InputSystem.Create(config, parent)
end

AdvancedUI.CreateLabel = function(config, parent)
    return LabelSystem.Create(config, parent)
end

AdvancedUI.CreateKeybind = function(config, parent)
    return KeybindSystem.Create(config, parent)
end

-- 修复: ColorPickerSystem -> ColorpickerSystem
AdvancedUI.CreateColorPicker = function(config, parent)
    return ColorpickerSystem.Create(config, parent)
end

AdvancedUI.CreateSection = function(config, parent)
    return SectionSystem.Create(config, parent)
end

AdvancedUI.CreateTab = function(config, parent)
    return TabSystem.Create(config, parent)
end

-- 修复: GroupboxSystem 不存在，使用 SectionSystem 代替
AdvancedUI.CreateGroupbox = function(config, parent)
    return SectionSystem.Create(config, parent)
end

AdvancedUI.CreateSearch = function(config, parent)
    return SearchSystem.Create(config, parent)
end

-- 修复: ListSystem 不存在，使用 DropdownSystem 代替
AdvancedUI.CreateList = function(config, parent)
    return DropdownSystem.Create(config, parent)
end

-- 修复: MultiSelectSystem 不存在，使用 DropdownSystem 代替 (Multi = true)
AdvancedUI.CreateMultiSelect = function(config, parent)
    config.Multi = true
    return DropdownSystem.Create(config, parent)
end

-- 修复: NumberSpinnerSystem 不存在，使用 StepperSystem 代替
AdvancedUI.CreateNumberSpinner = function(config, parent)
    return StepperSystem.Create(config, parent)
end

AdvancedUI.CreateTreeView = function(config, parent)
    return TreeViewSystem.Create(config, parent)
end

-- 修复: DataTableSystem 不存在，使用 DataGridSystem 代替
AdvancedUI.CreateDataTable = function(config, parent)
    return DataGridSystem.Create(config, parent)
end

-- 修复: CodeEditorSystem 不存在，使用 CodeBlockSystem 代替
AdvancedUI.CreateCodeEditor = function(config, parent)
    return CodeBlockSystem.Create(config, parent)
end

AdvancedUI.CreateTerminal = function(config, parent)
    return TerminalSystem.Create(config, parent)
end

-- 修复: ImageViewerSystem 不存在，使用 ImageSystem 代替
AdvancedUI.CreateImageViewer = function(config, parent)
    return ImageSystem.Create(config, parent)
end

-- 修复: AudioPlayerSystem 不存在，返回 nil 并打印警告
AdvancedUI.CreateAudioPlayer = function(config, parent)
    warn("AudioPlayer is not implemented yet")
    return nil
end

-- 修复: VideoPlayerSystem 不存在，返回 nil 并打印警告
AdvancedUI.CreateVideoPlayer = function(config, parent)
    warn("VideoPlayer is not implemented yet")
    return nil
end

-- 修复: CarouselSystem 不存在，返回 nil 并打印警告
AdvancedUI.CreateCarousel = function(config, parent)
    warn("Carousel is not implemented yet")
    return nil
end

-- 修复: TimelineSystem 不存在，返回 nil 并打印警告
AdvancedUI.CreateTimeline = function(config, parent)
    warn("Timeline is not implemented yet")
    return nil
end

AdvancedUI.CreateChart = function(config, parent)
    return ChartSystem.Create(config, parent)
end

AdvancedUI.CreateStepper = function(config, parent)
    return StepperSystem.Create(config, parent)
end

-- 修复: RatingSystem 不存在，返回 nil 并打印警告
AdvancedUI.CreateRating = function(config, parent)
    warn("Rating is not implemented yet")
    return nil
end

-- 修复: AvatarSystem 不存在，返回 nil 并打印警告
AdvancedUI.CreateAvatar = function(config, parent)
    warn("Avatar is not implemented yet")
    return nil
end

AdvancedUI.CreateScroll = function(config, parent)
    return ScrollSystem.Create(config, parent)
end

AdvancedUI.CreateGrid = function(config, parent)
    return GridSystem.Create(config, parent)
end

AdvancedUI.CreateCalendar = function(config, parent)
    return CalendarSystem.Create(config, parent)
end

AdvancedUI.CreateAccordion = function(config, parent)
    return AccordionSystem.Create(config, parent)
end

AdvancedUI.CreateBreadcrumb = function(config, parent)
    return BreadcrumbSystem.Create(config, parent)
end

AdvancedUI.CreatePagination = function(config, parent)
    return PaginationSystem.Create(config, parent)
end

-- 修复: ProgressSystem -> ProgressBarSystem
AdvancedUI.CreateProgress = function(config, parent)
    return ProgressBarSystem.Create(config, parent)
end

-- 修复: 添加 CreateProgressBar 作为别名
AdvancedUI.CreateProgressBar = function(config, parent)
    return ProgressBarSystem.Create(config, parent)
end

AdvancedUI.CreateSkeleton = function(config, parent)
    return SkeletonSystem.Create(config, parent)
end

AdvancedUI.CreateEmptyState = function(config, parent)
    return EmptyStateSystem.Create(config, parent)
end

AdvancedUI.CreateBadge = function(config, parent)
    return BadgeSystem.Create(config, parent)
end

AdvancedUI.CreateChip = function(config, parent)
    return ChipSystem.Create(config, parent)
end

AdvancedUI.CreateDivider = function(config, parent)
    return DividerSystem.Create(config, parent)
end

AdvancedUI.CreateSpacer = function(config, parent)
    return SpacerSystem.Create(config, parent)
end

-- 修复: WatermarkSystem -> WatermarkSystem (存在)
AdvancedUI.CreateWatermark = function(config)
    return WatermarkSystem.Create(config)
end

-- 修复: NotificationSystem -> NotificationSystem (存在)
AdvancedUI.CreateNotification = function(config)
    return NotificationSystem.Create(config)
end

-- 修复: ToastSystem 不存在，使用 NotificationSystem 代替
AdvancedUI.CreateToast = function(config)
    return NotificationSystem.Create(config)
end

-- 修复: DialogSystem 不存在，使用 ModalSystem 代替
AdvancedUI.CreateDialog = function(config)
    return ModalSystem.Create(config)
end

AdvancedUI.CreateMenu = function(config, parent)
    return MenuSystem.Create(config, parent)
end

AdvancedUI.CreateContextMenu = function(config)
    return ContextMenuSystem.Create(config)
end

AdvancedUI.CreateTooltip = function(config)
    return TooltipSystem.Create(config)
end

-- 添加: CheckboxSystem
AdvancedUI.CreateCheckbox = function(config, parent)
    return CheckboxSystem.Create(config, parent)
end

-- 添加: RadioButtonSystem
AdvancedUI.CreateRadioButton = function(config, parent)
    return RadioButtonSystem.Create(config, parent)
end

-- 添加: SpinnerSystem
AdvancedUI.CreateSpinner = function(config, parent)
    return SpinnerSystem.Create(config, parent)
end

-- 添加: SegmentedControlSystem
AdvancedUI.CreateSegmentedControl = function(config, parent)
    return SegmentedControlSystem.Create(config, parent)
end

-- 添加: DatePickerSystem
AdvancedUI.CreateDatePicker = function(config, parent)
    return DatePickerSystem.Create(config, parent)
end

-- 添加: TimePickerSystem
AdvancedUI.CreateTimePicker = function(config, parent)
    return TimePickerSystem.Create(config, parent)
end

-- 添加: FilePickerSystem
AdvancedUI.CreateFilePicker = function(config, parent)
    return FilePickerSystem.Create(config, parent)
end

-- 添加: RichTextSystem
AdvancedUI.CreateRichText = function(config, parent)
    return RichTextSystem.Create(config, parent)
end

-- 添加: CodeBlockSystem
AdvancedUI.CreateCodeBlock = function(config, parent)
    return CodeBlockSystem.Create(config, parent)
end

-- 添加: DataGridSystem
AdvancedUI.CreateDataGrid = function(config, parent)
    return DataGridSystem.Create(config, parent)
end

-- 添加: MenuBarSystem
AdvancedUI.CreateMenuBar = function(config, parent)
    return MenuBarSystem.Create(config, parent)
end

-- 添加: ToolbarSystem
AdvancedUI.CreateToolbar = function(config, parent)
    return ToolbarSystem.Create(config, parent)
end

-- 添加: StatusBarSystem
AdvancedUI.CreateStatusBar = function(config, parent)
    return StatusBarSystem.Create(config, parent)
end

-- 添加: ImageSystem
AdvancedUI.CreateImage = function(config, parent)
    return ImageSystem.Create(config, parent)
end

-- 添加: ContainerSystem
AdvancedUI.CreateContainer = function(config, parent)
    return ContainerSystem.Create(config, parent)
end

AdvancedUI.SetTheme = function(theme)
    ThemeManager.SetTheme(theme)
end

AdvancedUI.GetCurrentTheme = function()
    return ThemeManager.CurrentTheme
end

AdvancedUI.PublishEvent = function(eventName, ...)
    EventBus.Publish(eventName, ...)
end

AdvancedUI.SubscribeEvent = function(eventName, callback)
    return EventBus.Subscribe(eventName, callback)
end

AdvancedUI.GenerateUUID = function()
    return Utility.GenerateUUID()
end

AdvancedUI.GetIcon = function(iconName)
    return GetIcon(iconName)
end

AdvancedUI.CreateShadow = function(parent, size, transparency)
    return Utility.CreateShadow(parent, size, transparency)
end

AdvancedUI.CreateHighlight = function(parent, color, speed, size)
    return Utility.CreateHighlight(parent, color, speed, size)
end

AdvancedUI.Tween = function(object, properties, duration, easingStyle, easingDirection, callback)
    return Utility.Tween(object, properties, duration, easingStyle, easingDirection, callback)
end

AdvancedUI.Drag = function(frame, dragArea)
    return Utility.Drag(frame, dragArea)
end

AdvancedUI.Resize = function(frame, handle, minSize, maxSize)
    return Utility.Resize(frame, handle, minSize, maxSize)
end

return AdvancedUI