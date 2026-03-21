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

-- ============================================================================
-- UTILITY MODULE
-- ============================================================================
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

-- ============================================================================
-- ANIMATION MODULE
-- ============================================================================
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

-- ============================================================================
-- THEME MANAGER MODULE
-- ============================================================================
local ThemeManager = {}

ThemeManager.Themes = {
    Default = {
        Primary = Color3.fromRGB(99, 102, 241),
        Secondary = Color3.fromRGB(139, 92, 246),
        Background = Color3.fromRGB(30, 30, 30),
        Surface = Color3.fromRGB(40, 40, 40),
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
        Accent = Color3.fromRGB(99, 102, 241)
    },
    Dark = {
        Primary = Color3.fromRGB(139, 92, 246),
        Secondary = Color3.fromRGB(124, 58, 237),
        Background = Color3.fromRGB(17, 24, 39),
        Surface = Color3.fromRGB(31, 41, 55),
        Error = Color3.fromRGB(248, 113, 113),
        Warning = Color3.fromRGB(251, 191, 36),
        Success = Color3.fromRGB(52, 211, 153),
        Info = Color3.fromRGB(96, 165, 250),
        TextPrimary = Color3.fromRGB(249, 250, 251),
        TextSecondary = Color3.fromRGB(156, 163, 175),
        TextDisabled = Color3.fromRGB(75, 85, 99),
        Border = Color3.fromRGB(55, 65, 81),
        Divider = Color3.fromRGB(31, 41, 55),
        Hover = Color3.fromRGB(55, 65, 81),
        Pressed = Color3.fromRGB(75, 85, 99),
        Shadow = Color3.fromRGB(0, 0, 0),
        Accent = Color3.fromRGB(139, 92, 246)
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
        TextPrimary = Color3.fromRGB(17, 24, 39),
        TextSecondary = Color3.fromRGB(75, 85, 99),
        TextDisabled = Color3.fromRGB(156, 163, 175),
        Border = Color3.fromRGB(209, 213, 219),
        Divider = Color3.fromRGB(229, 231, 235),
        Hover = Color3.fromRGB(243, 244, 246),
        Pressed = Color3.fromRGB(229, 231, 235),
        Shadow = Color3.fromRGB(0, 0, 0),
        Accent = Color3.fromRGB(79, 70, 229)
    },
    Midnight = {
        Primary = Color3.fromRGB(59, 130, 246),
        Secondary = Color3.fromRGB(16, 185, 129),
        Background = Color3.fromRGB(15, 23, 42),
        Surface = Color3.fromRGB(30, 41, 59),
        Error = Color3.fromRGB(244, 63, 94),
        Warning = Color3.fromRGB(251, 146, 60),
        Success = Color3.fromRGB(34, 197, 94),
        Info = Color3.fromRGB(56, 189, 248),
        TextPrimary = Color3.fromRGB(248, 250, 252),
        TextSecondary = Color3.fromRGB(148, 163, 184),
        TextDisabled = Color3.fromRGB(100, 116, 139),
        Border = Color3.fromRGB(51, 65, 85),
        Divider = Color3.fromRGB(30, 41, 59),
        Hover = Color3.fromRGB(51, 65, 85),
        Pressed = Color3.fromRGB(71, 85, 105),
        Shadow = Color3.fromRGB(2, 6, 23),
        Accent = Color3.fromRGB(59, 130, 246)
    },
    Sunset = {
        Primary = Color3.fromRGB(249, 115, 22),
        Secondary = Color3.fromRGB(236, 72, 153),
        Background = Color3.fromRGB(28, 25, 23),
        Surface = Color3.fromRGB(41, 37, 36),
        Error = Color3.fromRGB(239, 68, 68),
        Warning = Color3.fromRGB(245, 158, 11),
        Success = Color3.fromRGB(16, 185, 129),
        Info = Color3.fromRGB(6, 182, 212),
        TextPrimary = Color3.fromRGB(250, 250, 249),
        TextSecondary = Color3.fromRGB(168, 162, 158),
        TextDisabled = Color3.fromRGB(120, 113, 108),
        Border = Color3.fromRGB(68, 64, 60),
        Divider = Color3.fromRGB(41, 37, 36),
        Hover = Color3.fromRGB(68, 64, 60),
        Pressed = Color3.fromRGB(87, 83, 78),
        Shadow = Color3.fromRGB(12, 10, 9),
        Accent = Color3.fromRGB(249, 115, 22)
    },
    Ocean = {
        Primary = Color3.fromRGB(14, 165, 233),
        Secondary = Color3.fromRGB(99, 102, 241),
        Background = Color3.fromRGB(12, 20, 30),
        Surface = Color3.fromRGB(20, 35, 50),
        Error = Color3.fromRGB(248, 113, 113),
        Warning = Color3.fromRGB(251, 191, 36),
        Success = Color3.fromRGB(52, 211, 153),
        Info = Color3.fromRGB(56, 189, 248),
        TextPrimary = Color3.fromRGB(240, 249, 255),
        TextSecondary = Color3.fromRGB(135, 206, 235),
        TextDisabled = Color3.fromRGB(100, 116, 139),
        Border = Color3.fromRGB(30, 58, 80),
        Divider = Color3.fromRGB(20, 35, 50),
        Hover = Color3.fromRGB(30, 58, 80),
        Pressed = Color3.fromRGB(40, 78, 100),
        Shadow = Color3.fromRGB(5, 10, 15),
        Accent = Color3.fromRGB(14, 165, 233)
    },
    Forest = {
        Primary = Color3.fromRGB(34, 197, 94),
        Secondary = Color3.fromRGB(16, 185, 129),
        Background = Color3.fromRGB(20, 30, 20),
        Surface = Color3.fromRGB(30, 45, 30),
        Error = Color3.fromRGB(248, 113, 113),
        Warning = Color3.fromRGB(251, 191, 36),
        Success = Color3.fromRGB(74, 222, 128),
        Info = Color3.fromRGB(56, 189, 248),
        TextPrimary = Color3.fromRGB(240, 253, 244),
        TextSecondary = Color3.fromRGB(134, 239, 172),
        TextDisabled = Color3.fromRGB(100, 130, 100),
        Border = Color3.fromRGB(40, 70, 40),
        Divider = Color3.fromRGB(30, 45, 30),
        Hover = Color3.fromRGB(40, 70, 40),
        Pressed = Color3.fromRGB(50, 90, 50),
        Shadow = Color3.fromRGB(10, 20, 10),
        Accent = Color3.fromRGB(34, 197, 94)
    },
    Cyberpunk = {
        Primary = Color3.fromRGB(255, 0, 255),
        Secondary = Color3.fromRGB(0, 255, 255),
        Background = Color3.fromRGB(10, 0, 20),
        Surface = Color3.fromRGB(20, 0, 40),
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
        Accent = Color3.fromRGB(255, 0, 255)
    },
    Crimson = {
        Primary = Color3.fromRGB(220, 38, 38),
        Secondary = Color3.fromRGB(185, 28, 28),
        Background = Color3.fromRGB(20, 0, 0),
        Surface = Color3.fromRGB(40, 0, 0),
        Error = Color3.fromRGB(239, 68, 68),
        Warning = Color3.fromRGB(245, 158, 11),
        Success = Color3.fromRGB(34, 197, 94),
        Info = Color3.fromRGB(59, 130, 246),
        TextPrimary = Color3.fromRGB(255, 240, 240),
        TextSecondary = Color3.fromRGB(254, 202, 202),
        TextDisabled = Color3.fromRGB(153, 27, 27),
        Border = Color3.fromRGB(100, 0, 0),
        Divider = Color3.fromRGB(60, 0, 0),
        Hover = Color3.fromRGB(80, 0, 0),
        Pressed = Color3.fromRGB(100, 0, 0),
        Shadow = Color3.fromRGB(50, 0, 0),
        Accent = Color3.fromRGB(220, 38, 38)
    },
    Golden = {
        Primary = Color3.fromRGB(234, 179, 8),
        Secondary = Color3.fromRGB(202, 138, 4),
        Background = Color3.fromRGB(20, 15, 0),
        Surface = Color3.fromRGB(40, 30, 0),
        Error = Color3.fromRGB(239, 68, 68),
        Warning = Color3.fromRGB(245, 158, 11),
        Success = Color3.fromRGB(34, 197, 94),
        Info = Color3.fromRGB(59, 130, 246),
        TextPrimary = Color3.fromRGB(255, 250, 240),
        TextSecondary = Color3.fromRGB(254, 240, 138),
        TextDisabled = Color3.fromRGB(161, 98, 7),
        Border = Color3.fromRGB(100, 80, 0),
        Divider = Color3.fromRGB(60, 50, 0),
        Hover = Color3.fromRGB(80, 60, 0),
        Pressed = Color3.fromRGB(100, 80, 0),
        Shadow = Color3.fromRGB(50, 40, 0),
        Accent = Color3.fromRGB(234, 179, 8)
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

-- ============================================================================
-- EVENT BUS MODULE
-- ============================================================================
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

-- ============================================================================
-- STATE MANAGER MODULE
-- ============================================================================
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

-- ============================================================================
-- COMPONENT REGISTRY MODULE
-- ============================================================================
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


-- ============================================================================
-- WATERMARK SYSTEM MODULE
-- ============================================================================
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
        BackgroundColor3 = config.BackgroundColor or Color3.fromRGB(30, 30, 30),
        BackgroundTransparency = config.BackgroundTransparency or 0.2,
        BorderSizePixel = 0,
        Active = true,
        Draggable = false,
        Parent = screenGui
    })

    local corner = Utility.Create("UICorner", {
        CornerRadius = UDim.new(0, 8),
        Parent = mainFrame
    })

    local stroke = Utility.Create("UIStroke", {
        Color = config.BorderColor or Color3.fromRGB(99, 102, 241),
        Thickness = 1,
        Transparency = 0.5,
        Parent = mainFrame
    })

    local gradient = Utility.Create("UIGradient", {
        Color = ColorSequence.new({
            ColorSequenceKeypoint.new(0, Color3.fromRGB(99, 102, 241)),
            ColorSequenceKeypoint.new(1, Color3.fromRGB(139, 92, 246))
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
        Font = config.Font or Enum.Font.GothamBold,
        TextXAlignment = Enum.TextXAlignment.Left,
        TextYAlignment = Enum.TextYAlignment.Center,
        Parent = mainFrame
    })

    local icon = Utility.Create("ImageLabel", {
        Name = "Icon",
        Size = UDim2.new(0, 20, 0, 20),
        Position = UDim2.new(1, -30, 0.5, -10),
        BackgroundTransparency = 1,
        Image = config.Icon or "rbxassetid://3926305904",
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

-- ============================================================================
-- NOTIFICATION SYSTEM MODULE
-- ============================================================================
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
        BackgroundColor3 = config.BackgroundColor or Color3.fromRGB(40, 40, 40),
        BackgroundTransparency = 0.1,
        BorderSizePixel = 0,
        Parent = screenGui
    })

    local corner = Utility.Create("UICorner", {
        CornerRadius = UDim.new(0, 12),
        Parent = mainFrame
    })

    local stroke = Utility.Create("UIStroke", {
        Color = config.BorderColor or Color3.fromRGB(99, 102, 241),
        Thickness = 1,
        Transparency = 0.3,
        Parent = mainFrame
    })

    local shadow = Utility.CreateShadow(mainFrame, 4, 0.5, 15)

    local iconFrame = Utility.Create("Frame", {
        Name = "IconFrame",
        Size = UDim2.new(0, 50, 1, 0),
        BackgroundColor3 = config.IconBackground or Color3.fromRGB(99, 102, 241),
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
        BorderSizePixel = 0,
        Parent = iconFrame
    })

    local icon = Utility.Create("ImageLabel", {
        Name = "Icon",
        Size = UDim2.new(0, 30, 0, 30),
        Position = UDim2.new(0.5, 0, 0.5, 0),
        AnchorPoint = Vector2.new(0.5, 0.5),
        BackgroundTransparency = 1,
        Image = config.Icon or "rbxassetid://3926305904",
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
        Font = Enum.Font.GothamBold,
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
        Font = Enum.Font.Gotham,
        TextXAlignment = Enum.TextXAlignment.Left,
        TextYAlignment = Enum.TextYAlignment.Top,
        TextWrapped = true,
        Parent = mainFrame
    })

    local closeButton = Utility.Create("TextButton", {
        Name = "CloseButton",
        Size = UDim2.new(0, 24, 0, 24),
        Position = UDim2.new(1, -32, 0, 8),
        BackgroundTransparency = 1,
        Text = "×",
        TextColor3 = Color3.fromRGB(150, 150, 150),
        TextSize = 24,
        Font = Enum.Font.GothamBold,
        Parent = mainFrame
    })

    local progressBar = Utility.Create("Frame", {
        Name = "ProgressBar",
        Size = UDim2.new(1, 0, 0, 3),
        Position = UDim2.new(0, 0, 1, -3),
        BackgroundColor3 = config.ProgressColor or Color3.fromRGB(99, 102, 241),
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
        Icon = "rbxassetid://3926305904",
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
        Icon = "rbxassetid://3926305904",
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
        Icon = "rbxassetid://3926305904",
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
        Icon = "rbxassetid://3926305904",
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

-- ============================================================================
-- WINDOW MANAGER MODULE
-- ============================================================================
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
        Image = config.Icon or "rbxassetid://3926305904",
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
        Font = Enum.Font.GothamBold,
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

    local minimizeButton = Utility.Create("TextButton", {
        Name = "MinimizeButton",
        Size = UDim2.new(0, 30, 0, 30),
        Position = UDim2.new(0, 5, 0.5, -15),
        BackgroundColor3 = Color3.fromRGB(255, 193, 7),
        Text = "",
        AutoButtonColor = false,
        Parent = buttonContainer
    })

    local minimizeCorner = Utility.Create("UICorner", {
        CornerRadius = UDim.new(1, 0),
        Parent = minimizeButton
    })

    local maximizeButton = Utility.Create("TextButton", {
        Name = "MaximizeButton",
        Size = UDim2.new(0, 30, 0, 30),
        Position = UDim2.new(0, 40, 0.5, -15),
        BackgroundColor3 = Color3.fromRGB(76, 175, 80),
        Text = "",
        AutoButtonColor = false,
        Parent = buttonContainer
    })

    local maximizeCorner = Utility.Create("UICorner", {
        CornerRadius = UDim.new(1, 0),
        Parent = maximizeButton
    })

    local closeButton = Utility.Create("TextButton", {
        Name = "CloseButton",
        Size = UDim2.new(0, 30, 0, 30),
        Position = UDim2.new(0, 75, 0.5, -15),
        BackgroundColor3 = Color3.fromRGB(244, 67, 54),
        Text = "",
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

    window.SetIcon = function(iconId)
        icon.Image = iconId
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


-- ============================================================================
-- TAB SYSTEM MODULE
-- ============================================================================
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
        Image = config.Icon or "rbxassetid://3926305904",
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
        Font = Enum.Font.Gotham,
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

-- ============================================================================
-- SECTION SYSTEM MODULE
-- ============================================================================
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
        Image = config.Icon or "rbxassetid://3926305904",
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
        Font = Enum.Font.GothamBold,
        TextXAlignment = Enum.TextXAlignment.Left,
        TextTruncate = Enum.TextTruncate.AtEnd,
        Parent = headerFrame
    })

    local collapseButton = Utility.Create("TextButton", {
        Name = "CollapseButton",
        Size = UDim2.new(0, 24, 0, 24),
        Position = UDim2.new(1, -30, 0.5, -12),
        BackgroundTransparency = 1,
        Text = "▼",
        TextColor3 = ThemeManager.CurrentTheme.TextSecondary,
        TextSize = 12,
        Font = Enum.Font.GothamBold,
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
            collapseButton.Text = "▶"
            contentFrame.Visible = false
            Utility.Tween(sectionFrame, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
                Size = UDim2.new(1, 0, 0, 35)
            })
        else
            collapseButton.Text = "▼"
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

    section.SetIcon = function(iconId)
        sectionIcon.Image = iconId
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

-- ============================================================================
-- BUTTON SYSTEM MODULE
-- ============================================================================
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

    local icon = Utility.Create("ImageLabel", {
        Name = "Icon",
        Size = UDim2.new(0, 20, 0, 20),
        Position = UDim2.new(0, 10, 0.5, -10),
        BackgroundTransparency = 1,
        Image = config.Icon or "rbxassetid://3926305904",
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
        Font = Enum.Font.Gotham,
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
    button.SetIcon = function(iconId)
        icon.Image = iconId
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

-- ============================================================================
-- TOGGLE SYSTEM MODULE
-- ============================================================================
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

    local label = Utility.Create("TextLabel", {
        Name = "Label",
        Size = UDim2.new(1, -80, 1, 0),
        Position = UDim2.new(0, 10, 0, 0),
        BackgroundTransparency = 1,
        Text = config.Name or "Toggle",
        TextColor3 = ThemeManager.CurrentTheme.TextPrimary,
        TextSize = 14,
        Font = Enum.Font.Gotham,
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

-- ============================================================================
-- SLIDER SYSTEM MODULE
-- ============================================================================
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

    local label = Utility.Create("TextLabel", {
        Name = "Label",
        Size = UDim2.new(1, -100, 0, 20),
        Position = UDim2.new(0, 10, 0, 5),
        BackgroundTransparency = 1,
        Text = config.Name or "Slider",
        TextColor3 = ThemeManager.CurrentTheme.TextPrimary,
        TextSize = 14,
        Font = Enum.Font.Gotham,
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
        Font = Enum.Font.GothamBold,
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


-- ============================================================================
-- DROPDOWN SYSTEM MODULE
-- ============================================================================
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

    local label = Utility.Create("TextLabel", {
        Name = "Label",
        Size = UDim2.new(1, -50, 0, 40),
        Position = UDim2.new(0, 10, 0, 0),
        BackgroundTransparency = 1,
        Text = config.Name or "Dropdown",
        TextColor3 = ThemeManager.CurrentTheme.TextPrimary,
        TextSize = 14,
        Font = Enum.Font.Gotham,
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
        Font = Enum.Font.GothamBold,
        TextXAlignment = Enum.TextXAlignment.Right,
        TextTruncate = Enum.TextTruncate.AtEnd,
        Parent = dropdownFrame
    })

    local arrow = Utility.Create("ImageLabel", {
        Name = "Arrow",
        Size = UDim2.new(0, 20, 0, 20),
        Position = UDim2.new(1, -30, 0.5, -10),
        BackgroundTransparency = 1,
        Image = "rbxassetid://3926305904",
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
                Font = Enum.Font.Gotham,
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

-- ============================================================================
-- INPUT SYSTEM MODULE
-- ============================================================================
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

    local label = Utility.Create("TextLabel", {
        Name = "Label",
        Size = UDim2.new(1, -20, 0, 20),
        Position = UDim2.new(0, 10, 0, 5),
        BackgroundTransparency = 1,
        Text = config.Name or "Input",
        TextColor3 = ThemeManager.CurrentTheme.TextSecondary,
        TextSize = 12,
        Font = Enum.Font.Gotham,
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
        Font = Enum.Font.Gotham,
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

-- ============================================================================
-- KEYBIND SYSTEM MODULE
-- ============================================================================
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

    local label = Utility.Create("TextLabel", {
        Name = "Label",
        Size = UDim2.new(1, -100, 1, 0),
        Position = UDim2.new(0, 10, 0, 0),
        BackgroundTransparency = 1,
        Text = config.Name or "Keybind",
        TextColor3 = ThemeManager.CurrentTheme.TextPrimary,
        TextSize = 14,
        Font = Enum.Font.Gotham,
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
        Font = Enum.Font.GothamBold,
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

-- ============================================================================
-- LABEL SYSTEM MODULE
-- ============================================================================
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
        Font = config.Font or Enum.Font.Gotham,
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

-- ============================================================================
-- DIVIDER SYSTEM MODULE
-- ============================================================================
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


-- ============================================================================
-- COLOR PICKER SYSTEM MODULE
-- ============================================================================
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

    local label = Utility.Create("TextLabel", {
        Name = "Label",
        Size = UDim2.new(1, -60, 1, 0),
        Position = UDim2.new(0, 10, 0, 0),
        BackgroundTransparency = 1,
        Text = config.Name or "Color Picker",
        TextColor3 = ThemeManager.CurrentTheme.TextPrimary,
        TextSize = 14,
        Font = Enum.Font.Gotham,
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
        Font = Enum.Font.Gotham,
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

-- ============================================================================
-- SCROLL SYSTEM MODULE
-- ============================================================================
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

-- ============================================================================
-- GRID SYSTEM MODULE
-- ============================================================================
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
        CellPadding = config.CellPadding or UDim.new(0, 10, 0, 10),
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

-- ============================================================================
-- TOOLTIP SYSTEM MODULE
-- ============================================================================
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
        BackgroundColor3 = config.BackgroundColor or Color3.fromRGB(30, 30, 30),
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

    local textLabel = Utility.Create("TextLabel", {
        Name = "Text",
        Size = UDim2.new(1, -16, 1, -12),
        Position = UDim2.new(0, 8, 0, 6),
        BackgroundTransparency = 1,
        Text = config.Text or "",
        TextColor3 = config.TextColor or Color3.fromRGB(255, 255, 255),
        TextSize = 12,
        Font = Enum.Font.Gotham,
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

        local bounds = TextService:GetTextSize(textLabel.Text, 12, Enum.Font.Gotham, Vector2.new(300, 9999))
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

-- ============================================================================
-- MODAL SYSTEM MODULE
-- ============================================================================
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

    local shadow = Utility.CreateShadow(mainFrame, 8, 0.5, 20)

    local titleLabel = Utility.Create("TextLabel", {
        Name = "Title",
        Size = UDim2.new(1, -40, 0, 40),
        Position = UDim2.new(0, 20, 0, 10),
        BackgroundTransparency = 1,
        Text = config.Title or "Modal",
        TextColor3 = ThemeManager.CurrentTheme.TextPrimary,
        TextSize = 18,
        Font = Enum.Font.GothamBold,
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
        Font = Enum.Font.Gotham,
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
            Font = Enum.Font.Gotham,
            AutoButtonColor = false,
            Parent = buttonContainer
        })

        local btnCorner = Utility.Create("UICorner", {
            CornerRadius = UDim.new(0, 8),
            Parent = btn
        })

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

-- ============================================================================
-- PROGRESS BAR SYSTEM MODULE
-- ============================================================================
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
        Font = Enum.Font.Gotham,
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

-- ============================================================================
-- SPINNER SYSTEM MODULE
-- ============================================================================
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
        Image = "rbxassetid://3926305904",
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

-- ============================================================================
-- RIPPLE SYSTEM MODULE
-- ============================================================================
local RippleSystem = {}

RippleSystem.Ripples = {}

RippleSystem.Create = function(config, parent)
    config = config or {}
    local ripple = {}
    local id = Utility.GenerateUUID()
    local connections = {}

    local rippleFrame = Utility.Create("Frame", {
        Name = "Ripple_" .. (config.Name or "Unnamed"),
        Size = config.Size or UDim2.new(1, 0, 1, 0),
        BackgroundTransparency = 1,
        Parent = parent
    })

    local function createRipple(position)
        local circle = Utility.Create("Frame", {
            AnchorPoint = Vector2.new(0.5, 0.5),
            Position = UDim2.new(0, position.X, 0, position.Y),
            Size = UDim2.new(0, 0, 0, 0),
            BackgroundColor3 = config.Color or Color3.fromRGB(255, 255, 255),
            BackgroundTransparency = 0.7,
            BorderSizePixel = 0,
            Parent = rippleFrame
        })

        local corner = Utility.Create("UICorner", {
            CornerRadius = UDim.new(1, 0),
            Parent = circle
        })

        local maxSize = math.max(rippleFrame.AbsoluteSize.X, rippleFrame.AbsoluteSize.Y) * 2
        Utility.Tween(circle, TweenInfo.new(config.Duration or 0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
            Size = UDim2.new(0, maxSize, 0, maxSize),
            BackgroundTransparency = 1
        }).Completed:Connect(function()
            circle:Destroy()
        end)
    end

    table.insert(connections, rippleFrame.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or 
           input.UserInputType == Enum.UserInputType.Touch then
            local pos = Vector2.new(
                input.Position.X - rippleFrame.AbsolutePosition.X,
                input.Position.Y - rippleFrame.AbsolutePosition.Y
            )
            createRipple(pos)
        end
    end))

    ripple.ID = id
    ripple.Instance = rippleFrame
    ripple.SetColor = function(color)
        config.Color = color
    end
    ripple.SetDuration = function(duration)
        config.Duration = duration
    end
    ripple.SetVisible = function(visible)
        rippleFrame.Visible = visible
    end
    ripple.Destroy = function()
        for _, conn in ipairs(connections) do
            conn:Disconnect()
        end
        rippleFrame:Destroy()
        RippleSystem.Ripples[id] = nil
    end

    RippleSystem.Ripples[id] = ripple
    return ripple
end

RippleSystem.GetAllRipples = function()
    return RippleSystem.Ripples
end


-- ============================================================================
-- ADVANCED UI EXPORT AND SHORTCUTS
-- ============================================================================

-- Export all modules to AdvancedUI table
AdvancedUI.Utility = Utility
AdvancedUI.Animation = Animation
AdvancedUI.ThemeManager = ThemeManager
AdvancedUI.EventBus = EventBus
AdvancedUI.StateManager = StateManager
AdvancedUI.ComponentRegistry = ComponentRegistry
AdvancedUI.WatermarkSystem = WatermarkSystem
AdvancedUI.NotificationSystem = NotificationSystem
AdvancedUI.WindowManager = WindowManager
AdvancedUI.TabSystem = TabSystem
AdvancedUI.SectionSystem = SectionSystem
AdvancedUI.ButtonSystem = ButtonSystem
AdvancedUI.ToggleSystem = ToggleSystem
AdvancedUI.SliderSystem = SliderSystem
AdvancedUI.DropdownSystem = DropdownSystem
AdvancedUI.InputSystem = InputSystem
AdvancedUI.KeybindSystem = KeybindSystem
AdvancedUI.LabelSystem = LabelSystem
AdvancedUI.DividerSystem = DividerSystem
AdvancedUI.ColorPickerSystem = ColorPickerSystem
AdvancedUI.ScrollSystem = ScrollSystem
AdvancedUI.GridSystem = GridSystem
AdvancedUI.TooltipSystem = TooltipSystem
AdvancedUI.ModalSystem = ModalSystem
AdvancedUI.ProgressBarSystem = ProgressBarSystem
AdvancedUI.SpinnerSystem = SpinnerSystem
AdvancedUI.RippleSystem = RippleSystem

-- Shortcut methods for common operations
AdvancedUI.CreateWindow = WindowManager.Create
AdvancedUI.CreateWatermark = WatermarkSystem.Create
AdvancedUI.Notify = NotificationSystem.Create
AdvancedUI.NotifySuccess = NotificationSystem.Success
AdvancedUI.NotifyError = NotificationSystem.Error
AdvancedUI.NotifyWarning = NotificationSystem.Warning
AdvancedUI.NotifyInfo = NotificationSystem.Info
AdvancedUI.SetTheme = ThemeManager.SetTheme
AdvancedUI.GetTheme = ThemeManager.GetTheme
AdvancedUI.CreateTheme = ThemeManager.CreateTheme
AdvancedUI.CreateModal = ModalSystem.Create
AdvancedUI.CreateTooltip = TooltipSystem.Create
AdvancedUI.ShowModal = function(config)
    local modal = ModalSystem.Create(config)
    modal.Show()
    return modal
end
AdvancedUI.ShowTooltip = function(config)
    local tooltip = TooltipSystem.Create(config)
    tooltip.Show()
    return tooltip
end

-- Version info
AdvancedUI.Version = "2.0.0"
AdvancedUI.Author = "AdvancedUI Team"
AdvancedUI.Description = "A comprehensive UI library for Roblox with modern design and extensive features"

-- Utility shortcuts
AdvancedUI.Create = Utility.Create
AdvancedUI.Tween = Utility.Tween
AdvancedUI.Fade = Utility.Fade
AdvancedUI.Drag = Utility.Drag
AdvancedUI.Shake = Utility.Shake
AdvancedUI.Pulse = Utility.Pulse
AdvancedUI.GenerateUUID = Utility.GenerateUUID
AdvancedUI.DeepCopy = Utility.DeepCopy
AdvancedUI.Lerp = Utility.Lerp
AdvancedUI.LerpColor = Utility.LerpColor
AdvancedUI.RGBtoHSV = Utility.RGBtoHSV
AdvancedUI.HSVtoRGB = Utility.HSVtoRGB
AdvancedUI.GetTextBounds = Utility.GetTextBounds
AdvancedUI.Clamp = Utility.Clamp
AdvancedUI.Debounce = Utility.Debounce
AdvancedUI.Throttle = Utility.Throttle
AdvancedUI.RandomString = Utility.RandomString
AdvancedUI.FormatNumber = Utility.FormatNumber
AdvancedUI.TruncateString = Utility.TruncateString
AdvancedUI.ParseColor = Utility.ParseColor
AdvancedUI.CreateShadow = Utility.CreateShadow
AdvancedUI.CreateGradient = Utility.CreateGradient
AdvancedUI.CreateCorner = Utility.CreateCorner
AdvancedUI.CreateStroke = Utility.CreateStroke

-- Event shortcuts
AdvancedUI.Subscribe = EventBus.Subscribe
AdvancedUI.SubscribeOnce = EventBus.SubscribeOnce
AdvancedUI.Publish = EventBus.Publish
AdvancedUI.SubscribeGlobal = EventBus.SubscribeGlobal
AdvancedUI.ClearEvents = EventBus.Clear

-- State shortcuts
AdvancedUI.CreateState = StateManager.CreateState
AdvancedUI.GetState = StateManager.GetState
AdvancedUI.SetState = StateManager.SetState
AdvancedUI.SubscribeState = StateManager.SubscribeGlobal
AdvancedUI.ClearStates = StateManager.Clear

-- Component shortcuts
AdvancedUI.RegisterComponent = ComponentRegistry.Register
AdvancedUI.RegisterFactory = ComponentRegistry.RegisterFactory
AdvancedUI.GetComponent = ComponentRegistry.Get
AdvancedUI.CreateComponent = ComponentRegistry.Create

-- Global cleanup function
AdvancedUI.DestroyAll = function()
    WatermarkSystem.DestroyAll()
    NotificationSystem.ClearAll()
    WindowManager.CloseAll()

    for _, tab in pairs(TabSystem.Tabs) do
        tab.Destroy()
    end
    TabSystem.Tabs = {}

    for _, section in pairs(SectionSystem.Sections) do
        section.Destroy()
    end
    SectionSystem.Sections = {}

    for _, button in pairs(ButtonSystem.Buttons) do
        button.Destroy()
    end
    ButtonSystem.Buttons = {}

    for _, toggle in pairs(ToggleSystem.Toggles) do
        toggle.Destroy()
    end
    ToggleSystem.Toggles = {}

    for _, slider in pairs(SliderSystem.Sliders) do
        slider.Destroy()
    end
    SliderSystem.Sliders = {}

    for _, dropdown in pairs(DropdownSystem.Dropdowns) do
        dropdown.Destroy()
    end
    DropdownSystem.Dropdowns = {}

    for _, input in pairs(InputSystem.Inputs) do
        input.Destroy()
    end
    InputSystem.Inputs = {}

    for _, keybind in pairs(KeybindSystem.Keybinds) do
        keybind.Destroy()
    end
    KeybindSystem.Keybinds = {}

    for _, label in pairs(LabelSystem.Labels) do
        label.Destroy()
    end
    LabelSystem.Labels = {}

    for _, divider in pairs(DividerSystem.Dividers) do
        divider.Destroy()
    end
    DividerSystem.Dividers = {}

    for _, colorPicker in pairs(ColorPickerSystem.ColorPickers) do
        colorPicker.Destroy()
    end
    ColorPickerSystem.ColorPickers = {}

    for _, progressBar in pairs(ProgressBarSystem.ProgressBars) do
        progressBar.Destroy()
    end
    ProgressBarSystem.ProgressBars = {}

    for _, spinner in pairs(SpinnerSystem.Spinners) do
        spinner.Destroy()
    end
    SpinnerSystem.Spinners = {}

    for _, ripple in pairs(RippleSystem.Ripples) do
        ripple.Destroy()
    end
    RippleSystem.Ripples = {}

    for _, tooltip in pairs(TooltipSystem.Tooltips) do
        tooltip.Destroy()
    end
    TooltipSystem.Tooltips = {}

    for _, modal in pairs(ModalSystem.Modals) do
        modal.Destroy()
    end
    ModalSystem.Modals = {}

    EventBus.Clear()
    StateManager.Clear()
    ComponentRegistry.Clear()
end

-- Hide/Show all UI
AdvancedUI.HideAll = function()
    for _, watermark in pairs(WatermarkSystem.ActiveWatermarks) do
        watermark.SetVisible(false)
    end
    for _, window in ipairs(WindowManager.Windows) do
        window.Hide()
    end
    for _, modal in pairs(ModalSystem.Modals) do
        modal.Hide()
    end
    for _, tooltip in pairs(TooltipSystem.Tooltips) do
        tooltip.Hide()
    end
end

AdvancedUI.ShowAll = function()
    for _, watermark in pairs(WatermarkSystem.ActiveWatermarks) do
        watermark.SetVisible(true)
    end
    for _, window in ipairs(WindowManager.Windows) do
        window.Show()
    end
end

-- Statistics
AdvancedUI.GetStats = function()
    return {
        Windows = #WindowManager.Windows,
        Watermarks = 0,
        Notifications = NotificationSystem.GetActiveCount(),
        Tabs = 0,
        Sections = 0,
        Buttons = 0,
        Toggles = 0,
        Sliders = 0,
        Dropdowns = 0,
        Inputs = 0,
        Keybinds = 0,
        Labels = 0,
        Dividers = 0,
        ColorPickers = 0,
        ProgressBars = 0,
        Spinners = 0,
        Ripples = 0,
        Tooltips = 0,
        Modals = 0,
        States = 0,
        Events = 0
    }
end

-- Initialize with default theme
ThemeManager.SetTheme("Default")

-- Return the library
return AdvancedUI


-- ============================================================================
-- SEARCH SYSTEM MODULE
-- ============================================================================
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

    local icon = Utility.Create("ImageLabel", {
        Name = "Icon",
        Size = UDim2.new(0, 20, 0, 20),
        Position = UDim2.new(0, 10, 0.5, -10),
        BackgroundTransparency = 1,
        Image = "rbxassetid://3926305904",
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
        Font = Enum.Font.Gotham,
        ClearTextOnFocus = false,
        Parent = searchFrame
    })

    local clearButton = Utility.Create("TextButton", {
        Name = "ClearButton",
        Size = UDim2.new(0, 20, 0, 20),
        Position = UDim2.new(1, -30, 0.5, -10),
        BackgroundTransparency = 1,
        Text = "×",
        TextColor3 = ThemeManager.CurrentTheme.TextSecondary,
        TextSize = 20,
        Font = Enum.Font.GothamBold,
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

-- ============================================================================
-- BADGE SYSTEM MODULE
-- ============================================================================
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
        Font = Enum.Font.GothamBold,
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

-- ============================================================================
-- IMAGE SYSTEM MODULE
-- ============================================================================
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

-- ============================================================================
-- CONTAINER SYSTEM MODULE
-- ============================================================================
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

-- ============================================================================
-- RADIO BUTTON SYSTEM MODULE
-- ============================================================================
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

    local label = Utility.Create("TextLabel", {
        Name = "Label",
        Size = UDim2.new(1, -50, 1, 0),
        Position = UDim2.new(0, 10, 0, 0),
        BackgroundTransparency = 1,
        Text = config.Name or "Radio",
        TextColor3 = ThemeManager.CurrentTheme.TextPrimary,
        TextSize = 14,
        Font = Enum.Font.Gotham,
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

-- ============================================================================
-- CHECKBOX SYSTEM MODULE
-- ============================================================================
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

    local label = Utility.Create("TextLabel", {
        Name = "Label",
        Size = UDim2.new(1, -50, 1, 0),
        Position = UDim2.new(0, 10, 0, 0),
        BackgroundTransparency = 1,
        Text = config.Name or "Checkbox",
        TextColor3 = ThemeManager.CurrentTheme.TextPrimary,
        TextSize = 14,
        Font = Enum.Font.Gotham,
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
        Image = "rbxassetid://3926305904",
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

-- Export additional systems
AdvancedUI.SearchSystem = SearchSystem
AdvancedUI.BadgeSystem = BadgeSystem
AdvancedUI.ImageSystem = ImageSystem
AdvancedUI.ContainerSystem = ContainerSystem
AdvancedUI.RadioButtonSystem = RadioButtonSystem
AdvancedUI.CheckboxSystem = CheckboxSystem

-- Additional shortcuts
AdvancedUI.CreateSearch = SearchSystem.Create
AdvancedUI.CreateBadge = BadgeSystem.Create
AdvancedUI.CreateImage = ImageSystem.Create
AdvancedUI.CreateContainer = ContainerSystem.Create
AdvancedUI.CreateRadioButton = RadioButtonSystem.Create
AdvancedUI.CreateCheckbox = CheckboxSystem.Create

return AdvancedUI
