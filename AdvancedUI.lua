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

local Utility = {}
local Animation = {}
local ThemeManager = {}
local InputHandler = {}
local EventBus = {}
local StateManager = {}
local ComponentRegistry = {}
local WatermarkSystem = {}
local NotificationSystem = {}
local WindowManager = {}
local DragSystem = {}
local MinimizeSystem = {}
local DropdownSystem = {}
local ColorPickerSystem = {}
local SliderSystem = {}
local ToggleSystem = {}
local ButtonSystem = {}
local InputSystem = {}
local KeybindSystem = {}
local SearchSystem = {}
local TabSystem = {}
local SectionSystem = {}
local LabelSystem = {}
local DividerSystem = {}
local ProgressBarSystem = {}
local SpinnerSystem = {}
local TooltipSystem = {}
local ContextMenuSystem = {}
local ModalSystem = {}
local ScrollSystem = {}
local GridSystem = {}
local TreeViewSystem = {}
local MultiSelectSystem = {}
local DatePickerSystem = {}
local TimePickerSystem = {}
local RichTextSystem = {}
local ImageSystem = {}
local VideoSystem = {}
local AudioSystem = {}
local ChartSystem = {}
local CalendarSystem = {}
local TagSystem = {}
local BadgeSystem = {}
local AvatarSystem = {}
local SkeletonSystem = {}
local ShimmerSystem = {}
local RippleSystem = {}
local ParticleSystem = {}
local GlassmorphismSystem = {}
local NeumorphismSystem = {}
local AcrylicSystem = {}

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
        Utility.Lerp(colorA.R, colorB.R, t),
        Utility.Lerp(colorA.G, colorB.G, t),
        Utility.Lerp(colorA.B, colorB.B, t)
    )
end

Utility.RGBtoHSV = function(color)
    local r, g, b = color.R, color.G, color.B
    local max, min = math.max(r, g, b), math.min(r, g, b)
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
    for property, value in pairs(properties or {}) do
        if property ~= "Parent" then
            instance[property] = value
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

Utility.SetVisible = function(instance, visible)
    if instance then
        instance.Visible = visible
    end
end

Utility.SetZIndex = function(instance, zIndex)
    if instance then
        instance.ZIndex = zIndex
    end
end

Utility.Enable = function(instance)
    if instance and instance:IsA("GuiObject") then
        instance.Active = true
    end
end

Utility.Disable = function(instance)
    if instance and instance:IsA("GuiObject") then
        instance.Active = false
    end
end

Utility.SetTransparency = function(instance, transparency)
    if instance then
        if instance:IsA("GuiObject") then
            instance.BackgroundTransparency = transparency
        elseif instance:IsA("ImageLabel") or instance:IsA("ImageButton") then
            instance.ImageTransparency = transparency
        elseif instance:IsA("TextLabel") or instance:IsA("TextButton") or instance:IsA("TextBox") then
            instance.TextTransparency = transparency
        end
    end
end

Utility.SetPosition = function(instance, position)
    if instance then
        instance.Position = position
    end
end

Utility.SetSize = function(instance, size)
    if instance then
        instance.Size = size
    end
end

Utility.SetAnchorPoint = function(instance, anchorPoint)
    if instance then
        instance.AnchorPoint = anchorPoint
    end
end

Utility.SetRotation = function(instance, rotation)
    if instance then
        instance.Rotation = rotation
    end
end

Utility.SetScale = function(instance, scale)
    if instance then
        instance.Size = UDim2.new(scale.X.Scale, scale.X.Offset, scale.Y.Scale, scale.Y.Offset)
    end
end

Animation.Tween = function(instance, properties, duration, easingStyle, easingDirection, callback)
    local tweenInfo = TweenInfo.new(
        duration or 0.3,
        easingStyle or Enum.EasingStyle.Quad,
        easingDirection or Enum.EasingDirection.Out,
        0,
        false,
        0
    )
    local tween = TweenService:Create(instance, tweenInfo, properties)
    if callback then
        tween.Completed:Connect(callback)
    end
    tween:Play()
    return tween
end

Animation.TweenAsync = function(instance, properties, duration, easingStyle, easingDirection)
    local promise = {}
    promise.Completed = false
    promise.Tween = Animation.Tween(instance, properties, duration, easingStyle, easingDirection, function()
        promise.Completed = true
    end)
    return promise
end

Animation.FadeIn = function(instance, duration)
    return Animation.Tween(instance, {BackgroundTransparency = 0}, duration or 0.3)
end

Animation.FadeOut = function(instance, duration)
    return Animation.Tween(instance, {BackgroundTransparency = 1}, duration or 0.3)
end

Animation.ScaleIn = function(instance, duration)
    local originalSize = instance.Size
    instance.Size = UDim2.new(0, 0, 0, 0)
    return Animation.Tween(instance, {Size = originalSize}, duration or 0.3, Enum.EasingStyle.Back, Enum.EasingDirection.Out)
end

Animation.ScaleOut = function(instance, duration)
    return Animation.Tween(instance, {Size = UDim2.new(0, 0, 0, 0)}, duration or 0.3, Enum.EasingStyle.Back, Enum.EasingDirection.In)
end

Animation.SlideIn = function(instance, direction, duration)
    local originalPosition = instance.Position
    local offset = direction == "Left" and UDim2.new(-1, 0, 0, 0) or
                   direction == "Right" and UDim2.new(1, 0, 0, 0) or
                   direction == "Up" and UDim2.new(0, 0, -1, 0) or
                   direction == "Down" and UDim2.new(0, 0, 1, 0) or UDim2.new(0, 0, 0, 0)
    instance.Position = originalPosition + offset
    return Animation.Tween(instance, {Position = originalPosition}, duration or 0.3)
end

Animation.SlideOut = function(instance, direction, duration)
    local offset = direction == "Left" and UDim2.new(-1, 0, 0, 0) or
                   direction == "Right" and UDim2.new(1, 0, 0, 0) or
                   direction == "Up" and UDim2.new(0, 0, -1, 0) or
                   direction == "Down" and UDim2.new(0, 0, 1, 0) or UDim2.new(0, 0, 0, 0)
    return Animation.Tween(instance, {Position = instance.Position + offset}, duration or 0.3)
end

Animation.Bounce = function(instance, duration)
    return Animation.Tween(instance, {Position = instance.Position}, duration or 0.5, Enum.EasingStyle.Bounce)
end

Animation.Elastic = function(instance, duration)
    return Animation.Tween(instance, {Size = instance.Size}, duration or 0.8, Enum.EasingStyle.Elastic)
end

Animation.Shake = function(instance, intensity, duration)
    local originalPosition = instance.Position
    local startTime = tick()
    local connection
    connection = RunService.RenderStepped:Connect(function()
        local elapsed = tick() - startTime
        if elapsed >= duration then
            instance.Position = originalPosition
            connection:Disconnect()
        else
            local offsetX = math.random(-intensity, intensity)
            local offsetY = math.random(-intensity, intensity)
            instance.Position = originalPosition + UDim2.new(0, offsetX, 0, offsetY)
        end
    end)
    return connection
end

Animation.Pulse = function(instance, minScale, maxScale, duration)
    local connection
    local startTime = tick()
    local originalSize = instance.Size
    connection = RunService.RenderStepped:Connect(function()
        local elapsed = tick() - startTime
        if elapsed >= duration then
            instance.Size = originalSize
            connection:Disconnect()
        else
            local scale = minScale + (maxScale - minScale) * (math.sin(elapsed * 10) + 1) / 2
            instance.Size = UDim2.new(originalSize.X.Scale * scale, originalSize.X.Offset, originalSize.Y.Scale * scale, originalSize.Y.Offset)
        end
    end)
    return connection
end

Animation.Rotate = function(instance, degrees, duration)
    return Animation.Tween(instance, {Rotation = instance.Rotation + degrees}, duration or 0.5)
end

Animation.Flip = function(instance, axis, duration)
    local scale = axis == "X" and "Size.X.Scale" or "Size.Y.Scale"
    return Animation.Tween(instance, {[scale] = -instance.Size[axis == "X" and "X" or "Y"].Scale}, duration or 0.3)
end

ThemeManager.Themes = {
    Dark = {
        Background = Color3.fromRGB(30, 30, 30),
        BackgroundSecondary = Color3.fromRGB(40, 40, 40),
        BackgroundTertiary = Color3.fromRGB(50, 50, 50),
        Text = Color3.fromRGB(255, 255, 255),
        TextSecondary = Color3.fromRGB(180, 180, 180),
        Accent = Color3.fromRGB(0, 120, 255),
        AccentHover = Color3.fromRGB(0, 150, 255),
        Border = Color3.fromRGB(60, 60, 60),
        Success = Color3.fromRGB(0, 255, 100),
        Warning = Color3.fromRGB(255, 200, 0),
        Error = Color3.fromRGB(255, 50, 50),
        Info = Color3.fromRGB(0, 200, 255)
    },
    Light = {
        Background = Color3.fromRGB(245, 245, 245),
        BackgroundSecondary = Color3.fromRGB(230, 230, 230),
        BackgroundTertiary = Color3.fromRGB(215, 215, 215),
        Text = Color3.fromRGB(30, 30, 30),
        TextSecondary = Color3.fromRGB(100, 100, 100),
        Accent = Color3.fromRGB(0, 100, 255),
        AccentHover = Color3.fromRGB(0, 130, 255),
        Border = Color3.fromRGB(200, 200, 200),
        Success = Color3.fromRGB(0, 200, 0),
        Warning = Color3.fromRGB(255, 170, 0),
        Error = Color3.fromRGB(255, 0, 0),
        Info = Color3.fromRGB(0, 150, 255)
    },
    Midnight = {
        Background = Color3.fromRGB(15, 15, 25),
        BackgroundSecondary = Color3.fromRGB(25, 25, 40),
        BackgroundTertiary = Color3.fromRGB(35, 35, 55),
        Text = Color3.fromRGB(220, 220, 255),
        TextSecondary = Color3.fromRGB(150, 150, 200),
        Accent = Color3.fromRGB(100, 50, 255),
        AccentHover = Color3.fromRGB(130, 80, 255),
        Border = Color3.fromRGB(40, 40, 70),
        Success = Color3.fromRGB(50, 255, 150),
        Warning = Color3.fromRGB(255, 180, 50),
        Error = Color3.fromRGB(255, 80, 80),
        Info = Color3.fromRGB(80, 180, 255)
    },
    Ocean = {
        Background = Color3.fromRGB(10, 25, 40),
        BackgroundSecondary = Color3.fromRGB(15, 40, 65),
        BackgroundTertiary = Color3.fromRGB(20, 55, 90),
        Text = Color3.fromRGB(200, 230, 255),
        TextSecondary = Color3.fromRGB(130, 170, 210),
        Accent = Color3.fromRGB(0, 180, 220),
        AccentHover = Color3.fromRGB(0, 210, 255),
        Border = Color3.fromRGB(30, 60, 100),
        Success = Color3.fromRGB(0, 255, 150),
        Warning = Color3.fromRGB(255, 200, 50),
        Error = Color3.fromRGB(255, 100, 100),
        Info = Color3.fromRGB(50, 200, 255)
    },
    Forest = {
        Background = Color3.fromRGB(15, 30, 20),
        BackgroundSecondary = Color3.fromRGB(25, 50, 35),
        BackgroundTertiary = Color3.fromRGB(35, 70, 50),
        Text = Color3.fromRGB(220, 255, 230),
        TextSecondary = Color3.fromRGB(150, 200, 170),
        Accent = Color3.fromRGB(50, 200, 100),
        AccentHover = Color3.fromRGB(80, 230, 130),
        Border = Color3.fromRGB(40, 80, 60),
        Success = Color3.fromRGB(100, 255, 150),
        Warning = Color3.fromRGB(255, 220, 100),
        Error = Color3.fromRGB(255, 120, 120),
        Info = Color3.fromRGB(100, 220, 255)
    },
    Sunset = {
        Background = Color3.fromRGB(40, 20, 30),
        BackgroundSecondary = Color3.fromRGB(60, 30, 45),
        BackgroundTertiary = Color3.fromRGB(80, 40, 60),
        Text = Color3.fromRGB(255, 220, 230),
        TextSecondary = Color3.fromRGB(220, 170, 190),
        Accent = Color3.fromRGB(255, 100, 150),
        AccentHover = Color3.fromRGB(255, 130, 180),
        Border = Color3.fromRGB(90, 50, 70),
        Success = Color3.fromRGB(150, 255, 150),
        Warning = Color3.fromRGB(255, 200, 100),
        Error = Color3.fromRGB(255, 100, 100),
        Info = Color3.fromRGB(255, 150, 200)
    },
    Cyberpunk = {
        Background = Color3.fromRGB(10, 0, 20),
        BackgroundSecondary = Color3.fromRGB(25, 0, 40),
        BackgroundTertiary = Color3.fromRGB(40, 0, 60),
        Text = Color3.fromRGB(255, 0, 255),
        TextSecondary = Color3.fromRGB(200, 0, 200),
        Accent = Color3.fromRGB(0, 255, 255),
        AccentHover = Color3.fromRGB(100, 255, 255),
        Border = Color3.fromRGB(255, 0, 150),
        Success = Color3.fromRGB(0, 255, 100),
        Warning = Color3.fromRGB(255, 255, 0),
        Error = Color3.fromRGB(255, 0, 50),
        Info = Color3.fromRGB(0, 200, 255)
    },
    Monokai = {
        Background = Color3.fromRGB(39, 40, 34),
        BackgroundSecondary = Color3.fromRGB(55, 56, 48),
        BackgroundTertiary = Color3.fromRGB(71, 72, 62),
        Text = Color3.fromRGB(248, 248, 242),
        TextSecondary = Color3.fromRGB(174, 175, 168),
        Accent = Color3.fromRGB(174, 129, 255),
        AccentHover = Color3.fromRGB(200, 160, 255),
        Border = Color3.fromRGB(90, 91, 83),
        Success = Color3.fromRGB(166, 226, 46),
        Warning = Color3.fromRGB(253, 151, 31),
        Error = Color3.fromRGB(249, 38, 114),
        Info = Color3.fromRGB(102, 217, 239)
    },
    Dracula = {
        Background = Color3.fromRGB(40, 42, 54),
        BackgroundSecondary = Color3.fromRGB(68, 71, 90),
        BackgroundTertiary = Color3.fromRGB(98, 114, 164),
        Text = Color3.fromRGB(248, 248, 242),
        TextSecondary = Color3.fromRGB(189, 147, 249),
        Accent = Color3.fromRGB(255, 121, 198),
        AccentHover = Color3.fromRGB(255, 150, 210),
        Border = Color3.fromRGB(68, 71, 90),
        Success = Color3.fromRGB(80, 250, 123),
        Warning = Color3.fromRGB(241, 250, 140),
        Error = Color3.fromRGB(255, 85, 85),
        Info = Color3.fromRGB(139, 233, 253)
    },
    Nord = {
        Background = Color3.fromRGB(46, 52, 64),
        BackgroundSecondary = Color3.fromRGB(59, 66, 82),
        BackgroundTertiary = Color3.fromRGB(67, 76, 94),
        Text = Color3.fromRGB(216, 222, 233),
        TextSecondary = Color3.fromRGB(143, 188, 187),
        Accent = Color3.fromRGB(136, 192, 208),
        AccentHover = Color3.fromRGB(163, 209, 224),
        Border = Color3.fromRGB(76, 86, 106),
        Success = Color3.fromRGB(163, 190, 140),
        Warning = Color3.fromRGB(235, 203, 139),
        Error = Color3.fromRGB(191, 97, 106),
        Info = Color3.fromRGB(129, 161, 193)
    }
}

ThemeManager.CurrentTheme = "Dark"

ThemeManager.SetTheme = function(themeName)
    if ThemeManager.Themes[themeName] then
        ThemeManager.CurrentTheme = themeName
        EventBus.Fire("ThemeChanged", ThemeManager.Themes[themeName])
    end
end

ThemeManager.GetTheme = function()
    return ThemeManager.Themes[ThemeManager.CurrentTheme]
end

ThemeManager.GetColor = function(colorName)
    local theme = ThemeManager.GetTheme()
    return theme[colorName] or theme.Text
end

ThemeManager.CreateGradient = function(color1, color2, rotation)
    local gradient = Instance.new("UIGradient")
    gradient.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, color1),
        ColorSequenceKeypoint.new(1, color2)
    })
    gradient.Rotation = rotation or 0
    return gradient
end

ThemeManager.CreateRainbowGradient = function(rotation, speed)
    local gradient = Instance.new("UIGradient")
    gradient.Rotation = rotation or 0
    local connection
    connection = RunService.RenderStepped:Connect(function()
        local hue = (tick() * (speed or 0.1)) % 1
        gradient.Color = ColorSequence.new({
            ColorSequenceKeypoint.new(0, Utility.HSVtoRGB(hue, 1, 1)),
            ColorSequenceKeypoint.new(0.5, Utility.HSVtoRGB((hue + 0.5) % 1, 1, 1)),
            ColorSequenceKeypoint.new(1, Utility.HSVtoRGB((hue + 1) % 1, 1, 1))
        })
    end)
    return gradient, connection
end

EventBus.Events = {}

EventBus.On = function(eventName, callback)
    if not EventBus.Events[eventName] then
        EventBus.Events[eventName] = {}
    end
    table.insert(EventBus.Events[eventName], callback)
    return #EventBus.Events[eventName]
end

EventBus.Off = function(eventName, index)
    if EventBus.Events[eventName] and EventBus.Events[eventName][index] then
        table.remove(EventBus.Events[eventName], index)
    end
end

EventBus.Fire = function(eventName, ...)
    if EventBus.Events[eventName] then
        for _, callback in ipairs(EventBus.Events[eventName]) do
            pcall(callback, ...)
        end
    end
end

EventBus.Once = function(eventName, callback)
    local index
    index = EventBus.On(eventName, function(...)
        EventBus.Off(eventName, index)
        callback(...)
    end)
end

StateManager.States = {}

StateManager.Create = function(initialValue)
    local state = {
        Value = initialValue,
        Listeners = {},
        Bindings = {}
    }

    state.Get = function()
        return state.Value
    end

    state.Set = function(newValue)
        if state.Value ~= newValue then
            local oldValue = state.Value
            state.Value = newValue
            for _, listener in ipairs(state.Listeners) do
                pcall(listener, newValue, oldValue)
            end
            for _, binding in ipairs(state.Bindings) do
                pcall(binding, newValue)
            end
        end
    end

    state.Subscribe = function(callback)
        table.insert(state.Listeners, callback)
        return #state.Listeners
    end

    state.Unsubscribe = function(index)
        if state.Listeners[index] then
            table.remove(state.Listeners, index)
        end
    end

    state.Bind = function(instance, property)
        local binding = function(value)
            instance[property] = value
        end
        table.insert(state.Bindings, binding)
        binding(state.Value)
        return #state.Bindings
    end

    return state
end

StateManager.CreateComputed = function(dependencies, compute)
    local computed = StateManager.Create(compute())

    local function update()
        local values = {}
        for _, dep in ipairs(dependencies) do
            table.insert(values, dep.Get())
        end
        computed.Set(compute(unpack(values)))
    end

    for _, dep in ipairs(dependencies) do
        dep.Subscribe(update)
    end

    return computed
end

DragSystem.ActiveDrags = {}

DragSystem.MakeDraggable = function(frame, handle)
    handle = handle or frame
    local dragging = false
    local dragStart = nil
    local startPos = nil

    local inputBegan = handle.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragStart = input.Position
            startPos = frame.Position

            if frame.Parent and frame.Parent:IsA("GuiObject") then
                frame.ZIndex = 100
            end
        end
    end)

    local inputChanged = UserInputService.InputChanged:Connect(function(input)
        if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
            local delta = input.Position - dragStart
            frame.Position = UDim2.new(
                startPos.X.Scale,
                startPos.X.Offset + delta.X,
                startPos.Y.Scale,
                startPos.Y.Offset + delta.Y
            )
        end
    end)

    local inputEnded = UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = false
            if frame.Parent and frame.Parent:IsA("GuiObject") then
                frame.ZIndex = 10
            end
        end
    end)

    table.insert(DragSystem.ActiveDrags, {
        Frame = frame,
        InputBegan = inputBegan,
        InputChanged = inputChanged,
        InputEnded = inputEnded
    })

    return {
        Disconnect = function()
            inputBegan:Disconnect()
            inputChanged:Disconnect()
            inputEnded:Disconnect()
        end
    }
end

DragSystem.MakeResizable = function(frame, minSize, maxSize)
    minSize = minSize or Vector2.new(100, 100)
    maxSize = maxSize or Vector2.new(1000, 1000)

    local resizeHandle = Utility.Create("Frame", {
        Name = "ResizeHandle",
        Size = UDim2.new(0, 20, 0, 20),
        Position = UDim2.new(1, -20, 1, -20),
        BackgroundColor3 = ThemeManager.GetColor("Accent"),
        BackgroundTransparency = 0.5,
        BorderSizePixel = 0,
        Parent = frame
    })

    local resizing = false
    local resizeStart = nil
    local startSize = nil

    local inputBegan = resizeHandle.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            resizing = true
            resizeStart = input.Position
            startSize = Vector2.new(frame.AbsoluteSize.X, frame.AbsoluteSize.Y)
        end
    end)

    local inputChanged = UserInputService.InputChanged:Connect(function(input)
        if resizing and input.UserInputType == Enum.UserInputType.MouseMovement then
            local delta = input.Position - resizeStart
            local newSize = Vector2.new(
                math.clamp(startSize.X + delta.X, minSize.X, maxSize.X),
                math.clamp(startSize.Y + delta.Y, minSize.Y, maxSize.Y)
            )
            frame.Size = UDim2.new(0, newSize.X, 0, newSize.Y)
        end
    end)

    local inputEnded = UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            resizing = false
        end
    end)

    return {
        Handle = resizeHandle,
        Disconnect = function()
            inputBegan:Disconnect()
            inputChanged:Disconnect()
            inputEnded:Disconnect()
        end
    }
end

WatermarkSystem.Create = function(config)
    config = config or {}
    local text = config.Text or "AdvancedUI"
    local position = config.Position or "BottomRight"
    local color = config.Color or Color3.fromRGB(0, 0, 0)
    local transparency = config.Transparency or 0.5
    local font = config.Font or Enum.Font.GothamBold
    local size = config.Size or 14

    local screenGui = Utility.Create("ScreenGui", {
        Name = "Watermark_" .. Utility.GenerateUUID(),
        Parent = CoreGui,
        ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
        ResetOnSpawn = false
    })

    local mainFrame = Utility.Create("Frame", {
        Name = "Main",
        Size = UDim2.new(0, 200, 0, 40),
        BackgroundColor3 = color,
        BackgroundTransparency = transparency,
        BorderSizePixel = 0,
        Parent = screenGui
    })

    local corner = Utility.Create("UICorner", {
        CornerRadius = UDim.new(0, 6),
        Parent = mainFrame
    })

    local stroke = Utility.Create("UIStroke", {
        Color = ThemeManager.GetColor("Accent"),
        Thickness = 1,
        Transparency = 0.5,
        Parent = mainFrame
    })

    local label = Utility.Create("TextLabel", {
        Name = "Text",
        Size = UDim2.new(1, 0, 1, 0),
        BackgroundTransparency = 1,
        Text = text,
        TextColor3 = ThemeManager.GetColor("Text"),
        TextSize = size,
        Font = font,
        Parent = mainFrame
    })

    local positions = {
        TopLeft = UDim2.new(0, 10, 0, 10),
        TopRight = UDim2.new(1, -210, 0, 10),
        BottomLeft = UDim2.new(0, 10, 1, -50),
        BottomRight = UDim2.new(1, -210, 1, -50),
        Center = UDim2.new(0.5, -100, 0.5, -20)
    }

    mainFrame.Position = positions[position] or positions.BottomRight

    local isDragging = false
    local isHolding = false
    local holdStartTime = 0
    local originalTransparency = transparency
    local dragConnection
    local holdConnection

    mainFrame.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            isHolding = true
            holdStartTime = tick()

            holdConnection = RunService.RenderStepped:Connect(function()
                if isHolding and tick() - holdStartTime > 0.5 then
                    Animation.Tween(mainFrame, {BackgroundTransparency = 0.9}, 0.3)
                end
            end)

            local dragStart = input.Position
            local startPos = mainFrame.Position

            dragConnection = UserInputService.InputChanged:Connect(function(moveInput)
                if moveInput.UserInputType == Enum.UserInputType.MouseMovement or moveInput.UserInputType == Enum.UserInputType.Touch then
                    isDragging = true
                    local delta = moveInput.Position - dragStart
                    mainFrame.Position = UDim2.new(
                        startPos.X.Scale,
                        startPos.X.Offset + delta.X,
                        startPos.Y.Scale,
                        startPos.Y.Offset + delta.Y
                    )
                end
            end)
        end
    end)

    mainFrame.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            isHolding = false
            isDragging = false

            if holdConnection then
                holdConnection:Disconnect()
            end
            if dragConnection then
                dragConnection:Disconnect()
            end

            Animation.Tween(mainFrame, {BackgroundTransparency = originalTransparency}, 0.3)
        end
    end)

    local watermark = {
        Frame = mainFrame,
        ScreenGui = screenGui,
        SetText = function(newText)
            label.Text = newText
        end,
        SetColor = function(newColor)
            Animation.Tween(mainFrame, {BackgroundColor3 = newColor}, 0.3)
        end,
        SetTransparency = function(newTransparency)
            originalTransparency = newTransparency
            Animation.Tween(mainFrame, {BackgroundTransparency = newTransparency}, 0.3)
        end,
        Destroy = function()
            Animation.ScaleOut(mainFrame, 0.3)
            task.delay(0.3, function()
                screenGui:Destroy()
            end)
        end
    }

    Animation.FadeIn(mainFrame, 0.5)
    return watermark
end

NotificationSystem.Queue = {}
NotificationSystem.Active = {}
NotificationSystem.MaxActive = 5

NotificationSystem.Create = function(config)
    config = config or {}
    local title = config.Title or "Notification"
    local message = config.Message or ""
    local type = config.Type or "Info"
    local duration = config.Duration or 3
    local icon = config.Icon or ""
    local sound = config.Sound or false

    local notification = {
        Title = title,
        Message = message,
        Type = type,
        Duration = duration,
        Icon = icon,
        Sound = sound,
        Id = Utility.GenerateUUID()
    }

    table.insert(NotificationSystem.Queue, notification)
    NotificationSystem.ProcessQueue()

    return notification
end

NotificationSystem.ProcessQueue = function()
    while #NotificationSystem.Queue > 0 and #NotificationSystem.Active < NotificationSystem.MaxActive do
        local notification = table.remove(NotificationSystem.Queue, 1)
        NotificationSystem.Show(notification)
    end
end

NotificationSystem.Show = function(notification)
    local colors = {
        Info = ThemeManager.GetColor("Info"),
        Success = ThemeManager.GetColor("Success"),
        Warning = ThemeManager.GetColor("Warning"),
        Error = ThemeManager.GetColor("Error")
    }

    local screenGui = Utility.Create("ScreenGui", {
        Name = "Notification_" .. notification.Id,
        Parent = CoreGui,
        ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    })

    local mainFrame = Utility.Create("Frame", {
        Name = "Main",
        Size = UDim2.new(0, 350, 0, 100),
        Position = UDim2.new(1, 20, 1, -120 - (#NotificationSystem.Active * 110)),
        BackgroundColor3 = ThemeManager.GetColor("BackgroundSecondary"),
        BorderSizePixel = 0,
        Parent = screenGui
    })

    local corner = Utility.Create("UICorner", {
        CornerRadius = UDim.new(0, 8),
        Parent = mainFrame
    })

    local stroke = Utility.Create("UIStroke", {
        Color = colors[notification.Type] or colors.Info,
        Thickness = 2,
        Parent = mainFrame
    })

    local shadow = Utility.Create("ImageLabel", {
        Name = "Shadow",
        Size = UDim2.new(1, 30, 1, 30),
        Position = UDim2.new(0, -15, 0, -15),
        BackgroundTransparency = 1,
        Image = "rbxassetid://5554236805",
        ImageColor3 = Color3.fromRGB(0, 0, 0),
        ImageTransparency = 0.6,
        ScaleType = Enum.ScaleType.Slice,
        SliceCenter = Rect.new(23, 23, 277, 277),
        Parent = mainFrame
    })

    local iconLabel = Utility.Create("ImageLabel", {
        Name = "Icon",
        Size = UDim2.new(0, 40, 0, 40),
        Position = UDim2.new(0, 15, 0, 30),
        BackgroundTransparency = 1,
        Image = notification.Icon,
        ImageColor3 = colors[notification.Type] or colors.Info,
        Parent = mainFrame
    })

    local titleLabel = Utility.Create("TextLabel", {
        Name = "Title",
        Size = UDim2.new(1, -70, 0, 25),
        Position = UDim2.new(0, 65, 0, 10),
        BackgroundTransparency = 1,
        Text = notification.Title,
        TextColor3 = ThemeManager.GetColor("Text"),
        TextSize = 16,
        Font = Enum.Font.GothamBold,
        TextXAlignment = Enum.TextXAlignment.Left,
        Parent = mainFrame
    })

    local messageLabel = Utility.Create("TextLabel", {
        Name = "Message",
        Size = UDim2.new(1, -70, 0, 50),
        Position = UDim2.new(0, 65, 0, 40),
        BackgroundTransparency = 1,
        Text = notification.Message,
        TextColor3 = ThemeManager.GetColor("TextSecondary"),
        TextSize = 14,
        Font = Enum.Font.Gotham,
        TextXAlignment = Enum.TextXAlignment.Left,
        TextWrapped = true,
        Parent = mainFrame
    })

    local progressBar = Utility.Create("Frame", {
        Name = "ProgressBar",
        Size = UDim2.new(1, 0, 0, 3),
        Position = UDim2.new(0, 0, 1, -3),
        BackgroundColor3 = colors[notification.Type] or colors.Info,
        BorderSizePixel = 0,
        Parent = mainFrame
    })

    local closeButton = Utility.Create("TextButton", {
        Name = "Close",
        Size = UDim2.new(0, 25, 0, 25),
        Position = UDim2.new(1, -30, 0, 5),
        BackgroundTransparency = 1,
        Text = "×",
        TextColor3 = ThemeManager.GetColor("TextSecondary"),
        TextSize = 20,
        Font = Enum.Font.GothamBold,
        Parent = mainFrame
    })

    table.insert(NotificationSystem.Active, notification)

    Animation.SlideIn(mainFrame, "Right", 0.4)
    Animation.Tween(progressBar, {Size = UDim2.new(0, 0, 0, 3)}, notification.Duration)

    if notification.Sound then
        local sound = Utility.Create("Sound", {
            SoundId = notification.Sound,
            Volume = 0.5,
            Parent = screenGui
        })
        sound:Play()
    end

    local closeConnection = closeButton.MouseButton1Click:Connect(function()
        NotificationSystem.Close(notification, screenGui, mainFrame)
    end)

    task.delay(notification.Duration, function()
        NotificationSystem.Close(notification, screenGui, mainFrame)
    end)

    notification.Close = function()
        NotificationSystem.Close(notification, screenGui, mainFrame)
    end
end

NotificationSystem.Close = function(notification, screenGui, mainFrame)
    for i, active in ipairs(NotificationSystem.Active) do
        if active.Id == notification.Id then
            table.remove(NotificationSystem.Active, i)
            break
        end
    end

    Animation.SlideOut(mainFrame, "Right", 0.3)
    task.delay(0.3, function()
        screenGui:Destroy()
        NotificationSystem.ProcessQueue()
        NotificationSystem.Reposition()
    end)
end

NotificationSystem.Reposition = function()
    for i, notification in ipairs(NotificationSystem.Active) do
        local screenGui = CoreGui:FindFirstChild("Notification_" .. notification.Id)
        if screenGui then
            local mainFrame = screenGui:FindFirstChild("Main")
            if mainFrame then
                Animation.Tween(mainFrame, {
                    Position = UDim2.new(1, -370, 1, -120 - ((i - 1) * 110))
                }, 0.3)
            end
        end
    end
end

NotificationSystem.Info = function(title, message, duration)
    return NotificationSystem.Create({
        Title = title,
        Message = message,
        Type = "Info",
        Duration = duration or 3
    })
end

NotificationSystem.Success = function(title, message, duration)
    return NotificationSystem.Create({
        Title = title,
        Message = message,
        Type = "Success",
        Duration = duration or 3
    })
end

NotificationSystem.Warning = function(title, message, duration)
    return NotificationSystem.Create({
        Title = title,
        Message = message,
        Type = "Warning",
        Duration = duration or 4
    })
end

NotificationSystem.Error = function(title, message, duration)
    return NotificationSystem.Create({
        Title = title,
        Message = message,
        Type = "Error",
        Duration = duration or 5
    })
end

MinimizeSystem.MinimizedWindows = {}

MinimizeSystem.CreateMinimizeBar = function()
    local screenGui = Utility.Create("ScreenGui", {
        Name = "MinimizeBar",
        Parent = CoreGui,
        ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    })

    local bar = Utility.Create("Frame", {
        Name = "Bar",
        Size = UDim2.new(0, 400, 0, 50),
        Position = UDim2.new(0.5, -200, 1, -60),
        BackgroundColor3 = ThemeManager.GetColor("BackgroundSecondary"),
        BackgroundTransparency = 0.1,
        BorderSizePixel = 0,
        Parent = screenGui
    })

    local corner = Utility.Create("UICorner", {
        CornerRadius = UDim.new(0, 10),
        Parent = bar
    })

    local stroke = Utility.Create("UIStroke", {
        Color = ThemeManager.GetColor("Border"),
        Thickness = 1,
        Parent = bar
    })

    local layout = Utility.Create("UIListLayout", {
        FillDirection = Enum.FillDirection.Horizontal,
        HorizontalAlignment = Enum.HorizontalAlignment.Center,
        VerticalAlignment = Enum.VerticalAlignment.Center,
        Padding = UDim.new(0, 10),
        Parent = bar
    })

    return bar
end

MinimizeSystem.MinimizeBar = nil

MinimizeSystem.Minimize = function(window)
    if not MinimizeSystem.MinimizeBar then
        MinimizeSystem.MinimizeBar = MinimizeSystem.CreateMinimizeBar()
    end

    local button = Utility.Create("TextButton", {
        Name = window.Title or "Window",
        Size = UDim2.new(0, 120, 0, 35),
        BackgroundColor3 = ThemeManager.GetColor("BackgroundTertiary"),
        Text = window.Title or "Window",
        TextColor3 = ThemeManager.GetColor("Text"),
        TextSize = 12,
        Font = Enum.Font.GothamSemibold,
        Parent = MinimizeSystem.MinimizeBar
    })

    local corner = Utility.Create("UICorner", {
        CornerRadius = UDim.new(0, 6),
        Parent = button
    })

    Animation.ScaleOut(window.MainFrame, 0.3)
    window.IsMinimized = true
    window.MinimizeButton = button

    button.MouseButton1Click:Connect(function()
        MinimizeSystem.Restore(window)
    end)

    table.insert(MinimizeSystem.MinimizedWindows, window)
end

MinimizeSystem.Restore = function(window)
    if window.MinimizeButton then
        window.MinimizeButton:Destroy()
    end

    Animation.ScaleIn(window.MainFrame, 0.3)
    window.IsMinimized = false

    for i, w in ipairs(MinimizeSystem.MinimizedWindows) do
        if w == window then
            table.remove(MinimizeSystem.MinimizedWindows, i)
            break
        end
    end
end

ButtonSystem.Create = function(parent, config)
    config = config or {}
    local text = config.Text or "Button"
    local size = config.Size or UDim2.new(1, 0, 0, 35)
    local position = config.Position or UDim2.new(0, 0, 0, 0)
    local callback = config.Callback or function() end
    local style = config.Style or "Default"
    local icon = config.Icon or nil

    local buttonFrame = Utility.Create("Frame", {
        Name = "Button_" .. Utility.GenerateUUID(),
        Size = size,
        Position = position,
        BackgroundColor3 = style == "Primary" and ThemeManager.GetColor("Accent") or
                          style == "Danger" and ThemeManager.GetColor("Error") or
                          style == "Success" and ThemeManager.GetColor("Success") or
                          ThemeManager.GetColor("BackgroundTertiary"),
        BorderSizePixel = 0,
        Parent = parent
    })

    local corner = Utility.Create("UICorner", {
        CornerRadius = UDim.new(0, 6),
        Parent = buttonFrame
    })

    local stroke = Utility.Create("UIStroke", {
        Color = ThemeManager.GetColor("Border"),
        Thickness = 1,
        Transparency = 0.5,
        Parent = buttonFrame
    })

    local label = Utility.Create("TextLabel", {
        Name = "Label",
        Size = UDim2.new(1, icon and -30 or 0, 1, 0),
        Position = icon and UDim2.new(0, 30, 0, 0) or UDim2.new(0, 0, 0, 0),
        BackgroundTransparency = 1,
        Text = text,
        TextColor3 = ThemeManager.GetColor("Text"),
        TextSize = 14,
        Font = Enum.Font.GothamSemibold,
        Parent = buttonFrame
    })

    if icon then
        local iconImage = Utility.Create("ImageLabel", {
            Name = "Icon",
            Size = UDim2.new(0, 20, 0, 20),
            Position = UDim2.new(0, 8, 0.5, -10),
            BackgroundTransparency = 1,
            Image = icon,
            ImageColor3 = ThemeManager.GetColor("Text"),
            Parent = buttonFrame
        })
    end

    local rippleContainer = Utility.Create("Frame", {
        Name = "Ripples",
        Size = UDim2.new(1, 0, 1, 0),
        BackgroundTransparency = 1,
        ClipsDescendants = true,
        Parent = buttonFrame
    })

    local isHovered = false
    local isPressed = false

    buttonFrame.MouseEnter:Connect(function()
        isHovered = true
        Animation.Tween(buttonFrame, {BackgroundColor3 = style == "Primary" and ThemeManager.GetColor("AccentHover") or
                                      style == "Danger" and Utility.LerpColor(ThemeManager.GetColor("Error"), Color3.fromRGB(255, 100, 100), 0.3) or
                                      style == "Success" and Utility.LerpColor(ThemeManager.GetColor("Success"), Color3.fromRGB(100, 255, 150), 0.3) or
                                      Utility.LerpColor(ThemeManager.GetColor("BackgroundTertiary"), ThemeManager.GetColor("Accent"), 0.1)}, 0.2)
    end)

    buttonFrame.MouseLeave:Connect(function()
        isHovered = false
        isPressed = false
        Animation.Tween(buttonFrame, {BackgroundColor3 = style == "Primary" and ThemeManager.GetColor("Accent") or
                                      style == "Danger" and ThemeManager.GetColor("Error") or
                                      style == "Success" and ThemeManager.GetColor("Success") or
                                      ThemeManager.GetColor("BackgroundTertiary")}, 0.2)
    end)

    buttonFrame.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            isPressed = true
            Animation.Tween(buttonFrame, {Size = UDim2.new(size.X.Scale, size.X.Offset - 4, size.Y.Scale, size.Y.Offset - 4),
                                          Position = UDim2.new(position.X.Scale, position.X.Offset + 2, position.Y.Scale, position.Y.Offset + 2)}, 0.1)

            local ripple = Utility.Create("Frame", {
                Size = UDim2.new(0, 0, 0, 0),
                Position = UDim2.new(0, input.Position.X - buttonFrame.AbsolutePosition.X, 0, input.Position.Y - buttonFrame.AbsolutePosition.Y),
                AnchorPoint = Vector2.new(0.5, 0.5),
                BackgroundColor3 = Color3.fromRGB(255, 255, 255),
                BackgroundTransparency = 0.7,
                BorderSizePixel = 0,
                Parent = rippleContainer
            })

            local rippleCorner = Utility.Create("UICorner", {
                CornerRadius = UDim.new(1, 0),
                Parent = ripple
            })

            local maxSize = math.max(buttonFrame.AbsoluteSize.X, buttonFrame.AbsoluteSize.Y) * 2
            Animation.Tween(ripple, {Size = UDim2.new(0, maxSize, 0, maxSize), BackgroundTransparency = 1}, 0.5, nil, nil, function()
                ripple:Destroy()
            end)
        end
    end)

    buttonFrame.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            isPressed = false
            Animation.Tween(buttonFrame, {Size = size, Position = position}, 0.1)
            if isHovered then
                callback()
            end
        end
    end)

    return {
        Frame = buttonFrame,
        SetText = function(newText)
            label.Text = newText
        end,
        SetCallback = function(newCallback)
            callback = newCallback
        end,
        SetEnabled = function(enabled)
            buttonFrame.Active = enabled
            buttonFrame.BackgroundTransparency = enabled and 0 or 0.5
        end,
        Destroy = function()
            buttonFrame:Destroy()
        end
    }
end

ToggleSystem.Create = function(parent, config)
    config = config or {}
    local text = config.Text or "Toggle"
    local default = config.Default or false
    local callback = config.Callback or function() end

    local toggleFrame = Utility.Create("Frame", {
        Name = "Toggle_" .. Utility.GenerateUUID(),
        Size = UDim2.new(1, 0, 0, 35),
        BackgroundTransparency = 1,
        Parent = parent
    })

    local label = Utility.Create("TextLabel", {
        Name = "Label",
        Size = UDim2.new(1, -60, 1, 0),
        BackgroundTransparency = 1,
        Text = text,
        TextColor3 = ThemeManager.GetColor("Text"),
        TextSize = 14,
        Font = Enum.Font.Gotham,
        TextXAlignment = Enum.TextXAlignment.Left,
        Parent = toggleFrame
    })

    local switchFrame = Utility.Create("Frame", {
        Name = "Switch",
        Size = UDim2.new(0, 50, 0, 26),
        Position = UDim2.new(1, -55, 0.5, -13),
        BackgroundColor3 = default and ThemeManager.GetColor("Accent") or ThemeManager.GetColor("BackgroundTertiary"),
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
        Position = default and UDim2.new(1, -24, 0, 2) or UDim2.new(0, 2, 0, 2),
        BackgroundColor3 = Color3.fromRGB(255, 255, 255),
        BorderSizePixel = 0,
        Parent = switchFrame
    })

    local knobCorner = Utility.Create("UICorner", {
        CornerRadius = UDim.new(1, 0),
        Parent = knob
    })

    local shadow = Utility.Create("ImageLabel", {
        Name = "Shadow",
        Size = UDim2.new(1, 6, 1, 6),
        Position = UDim2.new(0, -3, 0, -3),
        BackgroundTransparency = 1,
        Image = "rbxassetid://1316045217",
        ImageColor3 = Color3.fromRGB(0, 0, 0),
        ImageTransparency = 0.5,
        Parent = knob
    })

    local state = default

    local function updateToggle()
        state = not state
        Animation.Tween(switchFrame, {BackgroundColor3 = state and ThemeManager.GetColor("Accent") or ThemeManager.GetColor("BackgroundTertiary")}, 0.2)
        Animation.Tween(knob, {Position = state and UDim2.new(1, -24, 0, 2) or UDim2.new(0, 2, 0, 2)}, 0.2, Enum.EasingStyle.Back)
        callback(state)
    end

    switchFrame.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            updateToggle()
        end
    end)

    label.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            updateToggle()
        end
    end)

    return {
        Frame = toggleFrame,
        GetValue = function()
            return state
        end,
        SetValue = function(value)
            if state ~= value then
                state = value
                Animation.Tween(switchFrame, {BackgroundColor3 = state and ThemeManager.GetColor("Accent") or ThemeManager.GetColor("BackgroundTertiary")}, 0.2)
                Animation.Tween(knob, {Position = state and UDim2.new(1, -24, 0, 2) or UDim2.new(0, 2, 0, 2)}, 0.2, Enum.EasingStyle.Back)
                callback(state)
            end
        end,
        Destroy = function()
            toggleFrame:Destroy()
        end
    }
end

SliderSystem.Create = function(parent, config)
    config = config or {}
    local text = config.Text or "Slider"
    local min = config.Min or 0
    local max = config.Max or 100
    local default = config.Default or min
    local decimals = config.Decimals or 0
    local suffix = config.Suffix or ""
    local callback = config.Callback or function() end

    local sliderFrame = Utility.Create("Frame", {
        Name = "Slider_" .. Utility.GenerateUUID(),
        Size = UDim2.new(1, 0, 0, 50),
        BackgroundTransparency = 1,
        Parent = parent
    })

    local label = Utility.Create("TextLabel", {
        Name = "Label",
        Size = UDim2.new(0.5, 0, 0, 20),
        BackgroundTransparency = 1,
        Text = text,
        TextColor3 = ThemeManager.GetColor("Text"),
        TextSize = 14,
        Font = Enum.Font.Gotham,
        TextXAlignment = Enum.TextXAlignment.Left,
        Parent = sliderFrame
    })

    local valueLabel = Utility.Create("TextLabel", {
        Name = "Value",
        Size = UDim2.new(0.5, 0, 0, 20),
        Position = UDim2.new(0.5, 0, 0, 0),
        BackgroundTransparency = 1,
        Text = tostring(default) .. suffix,
        TextColor3 = ThemeManager.GetColor("Accent"),
        TextSize = 14,
        Font = Enum.Font.GothamBold,
        TextXAlignment = Enum.TextXAlignment.Right,
        Parent = sliderFrame
    })

    local track = Utility.Create("Frame", {
        Name = "Track",
        Size = UDim2.new(1, 0, 0, 6),
        Position = UDim2.new(0, 0, 0, 32),
        BackgroundColor3 = ThemeManager.GetColor("BackgroundTertiary"),
        BorderSizePixel = 0,
        Parent = sliderFrame
    })

    local trackCorner = Utility.Create("UICorner", {
        CornerRadius = UDim.new(1, 0),
        Parent = track
    })

    local fill = Utility.Create("Frame", {
        Name = "Fill",
        Size = UDim2.new((default - min) / (max - min), 0, 1, 0),
        BackgroundColor3 = ThemeManager.GetColor("Accent"),
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
        Position = UDim2.new((default - min) / (max - min), -8, 0.5, -8),
        BackgroundColor3 = Color3.fromRGB(255, 255, 255),
        BorderSizePixel = 0,
        Parent = track
    })

    local knobCorner = Utility.Create("UICorner", {
        CornerRadius = UDim.new(1, 0),
        Parent = knob
    })

    local knobShadow = Utility.Create("ImageLabel", {
        Name = "Shadow",
        Size = UDim2.new(1, 8, 1, 8),
        Position = UDim2.new(0, -4, 0, -4),
        BackgroundTransparency = 1,
        Image = "rbxassetid://1316045217",
        ImageColor3 = Color3.fromRGB(0, 0, 0),
        ImageTransparency = 0.4,
        Parent = knob
    })

    local value = default
    local dragging = false

    local function updateSlider(input)
        local pos = math.clamp((input.Position.X - track.AbsolutePosition.X) / track.AbsoluteSize.X, 0, 1)
        local newValue = min + (max - min) * pos
        newValue = math.floor(newValue * (10 ^ decimals) + 0.5) / (10 ^ decimals)

        if newValue ~= value then
            value = newValue
            valueLabel.Text = tostring(value) .. suffix
            Animation.Tween(fill, {Size = UDim2.new(pos, 0, 1, 0)}, 0.05)
            Animation.Tween(knob, {Position = UDim2.new(pos, -8, 0.5, -8)}, 0.05)
            callback(value)
        end
    end

    track.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
            updateSlider(input)
        end
    end)

    knob.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
            Animation.Tween(knob, {Size = UDim2.new(0, 20, 0, 20), Position = UDim2.new(knob.Position.X.Scale, -10, 0.5, -10)}, 0.1)
        end
    end)

    UserInputService.InputChanged:Connect(function(input)
        if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
            updateSlider(input)
        end
    end)

    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            if dragging then
                dragging = false
                Animation.Tween(knob, {Size = UDim2.new(0, 16, 0, 16), Position = UDim2.new(knob.Position.X.Scale, -8, 0.5, -8)}, 0.1)
            end
        end
    end)

    return {
        Frame = sliderFrame,
        GetValue = function()
            return value
        end,
        SetValue = function(newValue)
            newValue = math.clamp(newValue, min, max)
            newValue = math.floor(newValue * (10 ^ decimals) + 0.5) / (10 ^ decimals)
            value = newValue
            local pos = (value - min) / (max - min)
            valueLabel.Text = tostring(value) .. suffix
            Animation.Tween(fill, {Size = UDim2.new(pos, 0, 1, 0)}, 0.2)
            Animation.Tween(knob, {Position = UDim2.new(pos, -8, 0.5, -8)}, 0.2)
            callback(value)
        end,
        Destroy = function()
            sliderFrame:Destroy()
        end
    }
end

InputSystem.Create = function(parent, config)
    config = config or {}
    local placeholder = config.Placeholder or "Enter text..."
    local default = config.Default or ""
    local callback = config.Callback or function() end
    local numeric = config.Numeric or false
    local maxLength = config.MaxLength or nil
    local clearOnFocus = config.ClearOnFocus or false

    local inputFrame = Utility.Create("Frame", {
        Name = "Input_" .. Utility.GenerateUUID(),
        Size = UDim2.new(1, 0, 0, 35),
        BackgroundColor3 = ThemeManager.GetColor("BackgroundTertiary"),
        BorderSizePixel = 0,
        Parent = parent
    })

    local corner = Utility.Create("UICorner", {
        CornerRadius = UDim.new(0, 6),
        Parent = inputFrame
    })

    local stroke = Utility.Create("UIStroke", {
        Color = ThemeManager.GetColor("Border"),
        Thickness = 1,
        Transparency = 0.5,
        Parent = inputFrame
    })

    local textBox = Utility.Create("TextBox", {
        Name = "TextBox",
        Size = UDim2.new(1, -20, 1, 0),
        Position = UDim2.new(0, 10, 0, 0),
        BackgroundTransparency = 1,
        Text = default,
        PlaceholderText = placeholder,
        TextColor3 = ThemeManager.GetColor("Text"),
        PlaceholderColor3 = ThemeManager.GetColor("TextSecondary"),
        TextSize = 14,
        Font = Enum.Font.Gotham,
        ClearTextOnFocus = clearOnFocus,
        Parent = inputFrame
    })

    local icon = config.Icon and Utility.Create("ImageLabel", {
        Name = "Icon",
        Size = UDim2.new(0, 20, 0, 20),
        Position = UDim2.new(1, -30, 0.5, -10),
        BackgroundTransparency = 1,
        Image = config.Icon,
        ImageColor3 = ThemeManager.GetColor("TextSecondary"),
        Parent = inputFrame
    })

    textBox.Focused:Connect(function()
        Animation.Tween(stroke, {Color = ThemeManager.GetColor("Accent"), Transparency = 0}, 0.2)
        Animation.Tween(inputFrame, {BackgroundColor3 = Utility.LerpColor(ThemeManager.GetColor("BackgroundTertiary"), ThemeManager.GetColor("Accent"), 0.05)}, 0.2)
    end)

    textBox.FocusLost:Connect(function(enterPressed)
        Animation.Tween(stroke, {Color = ThemeManager.GetColor("Border"), Transparency = 0.5}, 0.2)
        Animation.Tween(inputFrame, {BackgroundColor3 = ThemeManager.GetColor("BackgroundTertiary")}, 0.2)
        callback(textBox.Text, enterPressed)
    end)

    textBox:GetPropertyChangedSignal("Text"):Connect(function()
        if numeric then
            textBox.Text = textBox.Text:gsub("[^%d.-]", "")
            local count = 0
            textBox.Text = textBox.Text:gsub("%.", function()
                count = count + 1
                return count > 1 and "" or "."
            end)
        end
        if maxLength and #textBox.Text > maxLength then
            textBox.Text = textBox.Text:sub(1, maxLength)
        end
    end)

    return {
        Frame = inputFrame,
        GetText = function()
            return textBox.Text
        end,
        SetText = function(text)
            textBox.Text = text
        end,
        Focus = function()
            textBox:CaptureFocus()
        end,
        Destroy = function()
            inputFrame:Destroy()
        end
    }
end

KeybindSystem.Create = function(parent, config)
    config = config or {}
    local text = config.Text or "Keybind"
    local default = config.Default or nil
    local callback = config.Callback or function() end
    local onPressed = config.OnPressed or function() end

    local keybindFrame = Utility.Create("Frame", {
        Name = "Keybind_" .. Utility.GenerateUUID(),
        Size = UDim2.new(1, 0, 0, 35),
        BackgroundTransparency = 1,
        Parent = parent
    })

    local label = Utility.Create("TextLabel", {
        Name = "Label",
        Size = UDim2.new(0.6, 0, 1, 0),
        BackgroundTransparency = 1,
        Text = text,
        TextColor3 = ThemeManager.GetColor("Text"),
        TextSize = 14,
        Font = Enum.Font.Gotham,
        TextXAlignment = Enum.TextXAlignment.Left,
        Parent = keybindFrame
    })

    local button = Utility.Create("TextButton", {
        Name = "Button",
        Size = UDim2.new(0.4, 0, 0, 30),
        Position = UDim2.new(0.6, 0, 0.5, -15),
        BackgroundColor3 = ThemeManager.GetColor("BackgroundTertiary"),
        Text = default and default.Name or "None",
        TextColor3 = ThemeManager.GetColor("Text"),
        TextSize = 12,
        Font = Enum.Font.GothamSemibold,
        Parent = keybindFrame
    })

    local corner = Utility.Create("UICorner", {
        CornerRadius = UDim.new(0, 4),
        Parent = button
    })

    local stroke = Utility.Create("UIStroke", {
        Color = ThemeManager.GetColor("Border"),
        Thickness = 1,
        Parent = button
    })

    local currentKey = default
    local listening = false

    button.MouseButton1Click:Connect(function()
        listening = true
        button.Text = "..."
        Animation.Tween(button, {BackgroundColor3 = ThemeManager.GetColor("Accent")}, 0.2)
        Animation.Tween(stroke, {Color = ThemeManager.GetColor("Accent")}, 0.2)
    end)

    local inputConnection = UserInputService.InputBegan:Connect(function(input, gameProcessed)
        if listening and not gameProcessed then
            if input.UserInputType == Enum.UserInputType.Keyboard then
                if input.KeyCode ~= Enum.KeyCode.Escape then
                    currentKey = input.KeyCode
                    button.Text = input.KeyCode.Name
                    callback(currentKey)
                else
                    button.Text = currentKey and currentKey.Name or "None"
                end
                listening = false
                Animation.Tween(button, {BackgroundColor3 = ThemeManager.GetColor("BackgroundTertiary")}, 0.2)
                Animation.Tween(stroke, {Color = ThemeManager.GetColor("Border")}, 0.2)
            end
        elseif currentKey and input.KeyCode == currentKey and not gameProcessed then
            onPressed()
        end
    end)

    return {
        Frame = keybindFrame,
        GetKey = function()
            return currentKey
        end,
        SetKey = function(key)
            currentKey = key
            button.Text = key and key.Name or "None"
        end,
        Destroy = function()
            inputConnection:Disconnect()
            keybindFrame:Destroy()
        end
    }
end

DropdownSystem.Create = function(parent, config)
    config = config or {}
    local text = config.Text or "Dropdown"
    local options = config.Options or {}
    local default = config.Default or nil
    local multiSelect = config.MultiSelect or false
    local maxHeight = config.MaxHeight or 200
    local callback = config.Callback or function() end

    local dropdownFrame = Utility.Create("Frame", {
        Name = "Dropdown_" .. Utility.GenerateUUID(),
        Size = UDim2.new(1, 0, 0, 35),
        BackgroundColor3 = ThemeManager.GetColor("BackgroundTertiary"),
        BorderSizePixel = 0,
        ClipsDescendants = true,
        Parent = parent
    })

    local corner = Utility.Create("UICorner", {
        CornerRadius = UDim.new(0, 6),
        Parent = dropdownFrame
    })

    local stroke = Utility.Create("UIStroke", {
        Color = ThemeManager.GetColor("Border"),
        Thickness = 1,
        Parent = dropdownFrame
    })

    local label = Utility.Create("TextLabel", {
        Name = "Label",
        Size = UDim2.new(1, -40, 0, 35),
        Position = UDim2.new(0, 10, 0, 0),
        BackgroundTransparency = 1,
        Text = default and (multiSelect and table.concat(default, ", ") or default) or text,
        TextColor3 = default and ThemeManager.GetColor("Text") or ThemeManager.GetColor("TextSecondary"),
        TextSize = 14,
        Font = Enum.Font.Gotham,
        TextXAlignment = Enum.TextXAlignment.Left,
        TextTruncate = Enum.TextTruncate.AtEnd,
        Parent = dropdownFrame
    })

    local arrow = Utility.Create("ImageLabel", {
        Name = "Arrow",
        Size = UDim2.new(0, 20, 0, 20),
        Position = UDim2.new(1, -25, 0, 7.5),
        BackgroundTransparency = 1,
        Image = "rbxassetid://3926305904",
        ImageRectOffset = Vector2.new(564, 284),
        ImageRectSize = Vector2.new(36, 36),
        ImageColor3 = ThemeManager.GetColor("TextSecondary"),
        Rotation = 0,
        Parent = dropdownFrame
    })

    local optionsFrame = Utility.Create("Frame", {
        Name = "Options",
        Size = UDim2.new(1, 0, 0, 0),
        Position = UDim2.new(0, 0, 0, 40),
        BackgroundColor3 = ThemeManager.GetColor("BackgroundSecondary"),
        BorderSizePixel = 0,
        Visible = false,
        Parent = dropdownFrame
    })

    local optionsCorner = Utility.Create("UICorner", {
        CornerRadius = UDim.new(0, 6),
        Parent = optionsFrame
    })

    local scrollFrame = Utility.Create("ScrollingFrame", {
        Name = "Scroll",
        Size = UDim2.new(1, -10, 1, -10),
        Position = UDim2.new(0, 5, 0, 5),
        BackgroundTransparency = 1,
        ScrollBarThickness = 4,
        ScrollBarImageColor3 = ThemeManager.GetColor("Accent"),
        CanvasSize = UDim2.new(0, 0, 0, 0),
        Parent = optionsFrame
    })

    local layout = Utility.Create("UIListLayout", {
        Padding = UDim.new(0, 5),
        Parent = scrollFrame
    })

    local selected = multiSelect and (default or {}) or default
    local isOpen = false
    local optionButtons = {}

    local function updateOptions()
        for _, btn in ipairs(optionButtons) do
            btn:Destroy()
        end
        optionButtons = {}

        for i, option in ipairs(options) do
            local optionButton = Utility.Create("TextButton", {
                Name = "Option_" .. tostring(i),
                Size = UDim2.new(1, 0, 0, 30),
                BackgroundColor3 = (multiSelect and table.find(selected, option)) or selected == option 
                    and Utility.LerpColor(ThemeManager.GetColor("BackgroundTertiary"), ThemeManager.GetColor("Accent"), 0.3)
                    or ThemeManager.GetColor("BackgroundTertiary"),
                Text = option,
                TextColor3 = ThemeManager.GetColor("Text"),
                TextSize = 13,
                Font = Enum.Font.Gotham,
                Parent = scrollFrame
            })

            local optionCorner = Utility.Create("UICorner", {
                CornerRadius = UDim.new(0, 4),
                Parent = optionButton
            })

            optionButton.MouseEnter:Connect(function()
                Animation.Tween(optionButton, {BackgroundColor3 = Utility.LerpColor(ThemeManager.GetColor("BackgroundTertiary"), ThemeManager.GetColor("Accent"), 0.2)}, 0.15)
            end)

            optionButton.MouseLeave:Connect(function()
                local isSelected = (multiSelect and table.find(selected, option)) or selected == option
                Animation.Tween(optionButton, {BackgroundColor3 = isSelected 
                    and Utility.LerpColor(ThemeManager.GetColor("BackgroundTertiary"), ThemeManager.GetColor("Accent"), 0.3)
                    or ThemeManager.GetColor("BackgroundTertiary")}, 0.15)
            end)

            optionButton.MouseButton1Click:Connect(function()
                if multiSelect then
                    if table.find(selected, option) then
                        table.remove(selected, table.find(selected, option))
                    else
                        table.insert(selected, option)
                    end
                    label.Text = #selected > 0 and table.concat(selected, ", ") or text
                else
                    selected = option
                    label.Text = option
                    label.TextColor3 = ThemeManager.GetColor("Text")
                    toggleDropdown()
                end
                callback(multiSelect and selected or selected)
                updateOptions()
            end)

            table.insert(optionButtons, optionButton)
        end

        scrollFrame.CanvasSize = UDim2.new(0, 0, 0, layout.AbsoluteContentSize.Y)
    end

    local function toggleDropdown()
        isOpen = not isOpen
        optionsFrame.Visible = true

        if isOpen then
            updateOptions()
            local height = math.min(#options * 35 + 10, maxHeight)
            Animation.Tween(dropdownFrame, {Size = UDim2.new(1, 0, 0, 40 + height)}, 0.3, Enum.EasingStyle.Quart)
            Animation.Tween(optionsFrame, {Size = UDim2.new(1, 0, 0, height)}, 0.3, Enum.EasingStyle.Quart)
            Animation.Tween(arrow, {Rotation = 180}, 0.3)
            Animation.Tween(stroke, {Color = ThemeManager.GetColor("Accent")}, 0.2)
        else
            Animation.Tween(dropdownFrame, {Size = UDim2.new(1, 0, 0, 35)}, 0.3, Enum.EasingStyle.Quart)
            Animation.Tween(optionsFrame, {Size = UDim2.new(1, 0, 0, 0)}, 0.3, Enum.EasingStyle.Quart, nil, function()
                optionsFrame.Visible = false
            end)
            Animation.Tween(arrow, {Rotation = 0}, 0.3)
            Animation.Tween(stroke, {Color = ThemeManager.GetColor("Border")}, 0.2)
        end
    end

    dropdownFrame.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            toggleDropdown()
        end
    end)

    return {
        Frame = dropdownFrame,
        GetSelected = function()
            return selected
        end,
        SetSelected = function(value)
            selected = value
            if multiSelect then
                label.Text = #selected > 0 and table.concat(selected, ", ") or text
            else
                label.Text = value or text
                label.TextColor3 = value and ThemeManager.GetColor("Text") or ThemeManager.GetColor("TextSecondary")
            end
            callback(selected)
        end,
        SetOptions = function(newOptions)
            options = newOptions
            if isOpen then
                updateOptions()
            end
        end,
        Destroy = function()
            dropdownFrame:Destroy()
        end
    }
end

ColorPickerSystem.Create = function(parent, config)
    config = config or {}
    local text = config.Text or "Color"
    local default = config.Default or Color3.fromRGB(255, 0, 0)
    local callback = config.Callback or function() end

    local colorFrame = Utility.Create("Frame", {
        Name = "ColorPicker_" .. Utility.GenerateUUID(),
        Size = UDim2.new(1, 0, 0, 35),
        BackgroundTransparency = 1,
        Parent = parent
    })

    local label = Utility.Create("TextLabel", {
        Name = "Label",
        Size = UDim2.new(0.7, 0, 1, 0),
        BackgroundTransparency = 1,
        Text = text,
        TextColor3 = ThemeManager.GetColor("Text"),
        TextSize = 14,
        Font = Enum.Font.Gotham,
        TextXAlignment = Enum.TextXAlignment.Left,
        Parent = colorFrame
    })

    local preview = Utility.Create("TextButton", {
        Name = "Preview",
        Size = UDim2.new(0, 60, 0, 25),
        Position = UDim2.new(1, -60, 0.5, -12.5),
        BackgroundColor3 = default,
        Text = "",
        Parent = colorFrame
    })

    local previewCorner = Utility.Create("UICorner", {
        CornerRadius = UDim.new(0, 4),
        Parent = preview
    })

    local previewStroke = Utility.Create("UIStroke", {
        Color = ThemeManager.GetColor("Border"),
        Thickness = 2,
        Parent = preview
    })

    local pickerFrame = Utility.Create("Frame", {
        Name = "Picker",
        Size = UDim2.new(0, 250, 0, 0),
        Position = UDim2.new(1, 10, 0, 0),
        BackgroundColor3 = ThemeManager.GetColor("BackgroundSecondary"),
        BorderSizePixel = 0,
        ClipsDescendants = true,
        Visible = false,
        ZIndex = 100,
        Parent = colorFrame
    })

    local pickerCorner = Utility.Create("UICorner", {
        CornerRadius = UDim.new(0, 8),
        Parent = pickerFrame
    })

    local pickerStroke = Utility.Create("UIStroke", {
        Color = ThemeManager.GetColor("Border"),
        Thickness = 1,
        Parent = pickerFrame
    })

    local saturationFrame = Utility.Create("Frame", {
        Name = "Saturation",
        Size = UDim2.new(0, 180, 0, 180),
        Position = UDim2.new(0, 10, 0, 10),
        BackgroundColor3 = Color3.fromRGB(255, 0, 0),
        BorderSizePixel = 0,
        ZIndex = 101,
        Parent = pickerFrame
    })

    local saturationGradient1 = Utility.Create("UIGradient", {
        Color = ColorSequence.new({
            ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 255, 255)),
            ColorSequenceKeypoint.new(1, Color3.fromRGB(255, 255, 255))
        }),
        Transparency = NumberSequence.new({
            NumberSequenceKeypoint.new(0, 0),
            NumberSequenceKeypoint.new(1, 1)
        }),
        Rotation = 0,
        Parent = saturationFrame
    })

    local saturationGradient2 = Utility.Create("UIGradient", {
        Color = ColorSequence.new({
            ColorSequenceKeypoint.new(0, Color3.fromRGB(0, 0, 0)),
            ColorSequenceKeypoint.new(1, Color3.fromRGB(0, 0, 0))
        }),
        Transparency = NumberSequence.new({
            NumberSequenceKeypoint.new(0, 1),
            NumberSequenceKeypoint.new(1, 0)
        }),
        Rotation = 90,
        Parent = saturationFrame
    })

    local saturationKnob = Utility.Create("Frame", {
        Name = "Knob",
        Size = UDim2.new(0, 10, 0, 10),
        BackgroundColor3 = Color3.fromRGB(255, 255, 255),
        BorderSizePixel = 2,
        BorderColor3 = Color3.fromRGB(0, 0, 0),
        ZIndex = 102,
        Parent = saturationFrame
    })

    local saturationKnobCorner = Utility.Create("UICorner", {
        CornerRadius = UDim.new(1, 0),
        Parent = saturationKnob
    })

    local hueFrame = Utility.Create("Frame", {
        Name = "Hue",
        Size = UDim2.new(0, 20, 0, 180),
        Position = UDim2.new(0, 200, 0, 10),
        BackgroundColor3 = Color3.fromRGB(255, 255, 255),
        BorderSizePixel = 0,
        ZIndex = 101,
        Parent = pickerFrame
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
        Rotation = 90,
        Parent = hueFrame
    })

    local hueKnob = Utility.Create("Frame", {
        Name = "Knob",
        Size = UDim2.new(1, 4, 0, 6),
        Position = UDim2.new(0, -2, 0, 0),
        BackgroundColor3 = Color3.fromRGB(255, 255, 255),
        BorderSizePixel = 2,
        BorderColor3 = Color3.fromRGB(0, 0, 0),
        ZIndex = 102,
        Parent = hueFrame
    })

    local rgbInput = Utility.Create("Frame", {
        Name = "RGB",
        Size = UDim2.new(0, 230, 0, 30),
        Position = UDim2.new(0, 10, 0, 200),
        BackgroundTransparency = 1,
        ZIndex = 101,
        Parent = pickerFrame
    })

    local rBox = Utility.Create("TextBox", {
        Name = "R",
        Size = UDim2.new(0, 70, 1, 0),
        BackgroundColor3 = ThemeManager.GetColor("BackgroundTertiary"),
        Text = tostring(math.floor(default.R * 255)),
        TextColor3 = Color3.fromRGB(255, 100, 100),
        TextSize = 12,
        Font = Enum.Font.GothamBold,
        Parent = rgbInput
    })

    local gBox = Utility.Create("TextBox", {
        Name = "G",
        Size = UDim2.new(0, 70, 1, 0),
        Position = UDim2.new(0, 80, 0, 0),
        BackgroundColor3 = ThemeManager.GetColor("BackgroundTertiary"),
        Text = tostring(math.floor(default.G * 255)),
        TextColor3 = Color3.fromRGB(100, 255, 100),
        TextSize = 12,
        Font = Enum.Font.GothamBold,
        Parent = rgbInput
    })

    local bBox = Utility.Create("TextBox", {
        Name = "B",
        Size = UDim2.new(0, 70, 1, 0),
        Position = UDim2.new(0, 160, 0, 0),
        BackgroundColor3 = ThemeManager.GetColor("BackgroundTertiary"),
        Text = tostring(math.floor(default.B * 255)),
        TextColor3 = Color3.fromRGB(100, 100, 255),
        TextSize = 12,
        Font = Enum.Font.GothamBold,
        Parent = rgbInput
    })

    for _, box in ipairs({rBox, gBox, bBox}) do
        local boxCorner = Utility.Create("UICorner", {
            CornerRadius = UDim.new(0, 4),
            Parent = box
        })
    end

    local currentColor = default
    local hue, saturation, value = Utility.RGBtoHSV(default)
    local isOpen = false

    local function updateColor()
        currentColor = Utility.HSVtoRGB(hue, saturation, value)
        preview.BackgroundColor3 = currentColor
        saturationFrame.BackgroundColor3 = Utility.HSVtoRGB(hue, 1, 1)

        rBox.Text = tostring(math.floor(currentColor.R * 255))
        gBox.Text = tostring(math.floor(currentColor.G * 255))
        bBox.Text = tostring(math.floor(currentColor.B * 255))

        callback(currentColor)
    end

    local function updateFromRGB()
        local r = math.clamp(tonumber(rBox.Text) or 0, 0, 255) / 255
        local g = math.clamp(tonumber(gBox.Text) or 0, 0, 255) / 255
        local b = math.clamp(tonumber(bBox.Text) or 0, 0, 255) / 255
        currentColor = Color3.new(r, g, b)
        hue, saturation, value = Utility.RGBtoHSV(currentColor)
        preview.BackgroundColor3 = currentColor
        saturationFrame.BackgroundColor3 = Utility.HSVtoRGB(hue, 1, 1)
        saturationKnob.Position = UDim2.new(saturation, -5, 1 - value, -5)
        hueKnob.Position = UDim2.new(0, -2, 1 - hue, -3)
        callback(currentColor)
    end

    local function togglePicker()
        isOpen = not isOpen
        pickerFrame.Visible = true

        if isOpen then
            Animation.Tween(pickerFrame, {Size = UDim2.new(0, 250, 0, 240)}, 0.3, Enum.EasingStyle.Back)
            Animation.Tween(previewStroke, {Color = ThemeManager.GetColor("Accent")}, 0.2)
        else
            Animation.Tween(pickerFrame, {Size = UDim2.new(0, 250, 0, 0)}, 0.3, Enum.EasingStyle.Back, Enum.EasingDirection.In, function()
                pickerFrame.Visible = false
            end)
            Animation.Tween(previewStroke, {Color = ThemeManager.GetColor("Border")}, 0.2)
        end
    end

    preview.MouseButton1Click:Connect(togglePicker)

    local satDragging = false
    local hueDragging = false

    saturationFrame.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            satDragging = true
            local pos = Vector2.new(
                math.clamp((input.Position.X - saturationFrame.AbsolutePosition.X) / saturationFrame.AbsoluteSize.X, 0, 1),
                math.clamp((input.Position.Y - saturationFrame.AbsolutePosition.Y) / saturationFrame.AbsoluteSize.Y, 0, 1)
            )
            saturation = pos.X
            value = 1 - pos.Y
            saturationKnob.Position = UDim2.new(saturation, -5, 1 - value, -5)
            updateColor()
        end
    end)

    hueFrame.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            hueDragging = true
            hue = math.clamp(1 - (input.Position.Y - hueFrame.AbsolutePosition.Y) / hueFrame.AbsoluteSize.Y, 0, 1)
            hueKnob.Position = UDim2.new(0, -2, 1 - hue, -3)
            updateColor()
        end
    end)

    UserInputService.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement then
            if satDragging then
                local pos = Vector2.new(
                    math.clamp((input.Position.X - saturationFrame.AbsolutePosition.X) / saturationFrame.AbsoluteSize.X, 0, 1),
                    math.clamp((input.Position.Y - saturationFrame.AbsolutePosition.Y) / saturationFrame.AbsoluteSize.Y, 0, 1)
                )
                saturation = pos.X
                value = 1 - pos.Y
                saturationKnob.Position = UDim2.new(saturation, -5, 1 - value, -5)
                updateColor()
            elseif hueDragging then
                hue = math.clamp(1 - (input.Position.Y - hueFrame.AbsolutePosition.Y) / hueFrame.AbsoluteSize.Y, 0, 1)
                hueKnob.Position = UDim2.new(0, -2, 1 - hue, -3)
                updateColor()
            end
        end
    end)

    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            satDragging = false
            hueDragging = false
        end
    end)

    rBox.FocusLost:Connect(updateFromRGB)
    gBox.FocusLost:Connect(updateFromRGB)
    bBox.FocusLost:Connect(updateFromRGB)

    return {
        Frame = colorFrame,
        GetColor = function()
            return currentColor
        end,
        SetColor = function(color)
            currentColor = color
            hue, saturation, value = Utility.RGBtoHSV(color)
            preview.BackgroundColor3 = color
            saturationFrame.BackgroundColor3 = Utility.HSVtoRGB(hue, 1, 1)
            saturationKnob.Position = UDim2.new(saturation, -5, 1 - value, -5)
            hueKnob.Position = UDim2.new(0, -2, 1 - hue, -3)
            rBox.Text = tostring(math.floor(color.R * 255))
            gBox.Text = tostring(math.floor(color.G * 255))
            bBox.Text = tostring(math.floor(color.B * 255))
            callback(color)
        end,
        Destroy = function()
            colorFrame:Destroy()
        end
    }
end

LabelSystem.Create = function(parent, config)
    config = config or {}
    local text = config.Text or "Label"
    local size = config.Size or 14
    font = config.Font or Enum.Font.Gotham
    local color = config.Color or ThemeManager.GetColor("Text")
    local alignment = config.Alignment or Enum.TextXAlignment.Left

    local label = Utility.Create("TextLabel", {
        Name = "Label_" .. Utility.GenerateUUID(),
        Size = UDim2.new(1, 0, 0, size + 10),
        BackgroundTransparency = 1,
        Text = text,
        TextColor3 = color,
        TextSize = size,
        Font = font,
        TextXAlignment = alignment,
        TextWrapped = config.Wrapped or false,
        Parent = parent
    })

    return {
        Frame = label,
        SetText = function(newText)
            label.Text = newText
        end,
        SetColor = function(newColor)
            Animation.Tween(label, {TextColor3 = newColor}, 0.2)
        end,
        Destroy = function()
            label:Destroy()
        end
    }
end

DividerSystem.Create = function(parent, config)
    config = config or {}
    local text = config.Text or nil

    local dividerFrame = Utility.Create("Frame", {
        Name = "Divider_" .. Utility.GenerateUUID(),
        Size = UDim2.new(1, 0, 0, text and 30 or 10),
        BackgroundTransparency = 1,
        Parent = parent
    })

    local line1 = Utility.Create("Frame", {
        Name = "Line1",
        Size = UDim2.new(text and 0.4 or 1, text and -10 or 0, 0, 1),
        Position = UDim2.new(0, 0, 0.5, -0.5),
        BackgroundColor3 = ThemeManager.GetColor("Border"),
        BorderSizePixel = 0,
        Parent = dividerFrame
    })

    if text then
        local label = Utility.Create("TextLabel", {
            Name = "Text",
            Size = UDim2.new(0.2, 0, 1, 0),
            Position = UDim2.new(0.4, 0, 0, 0),
            BackgroundTransparency = 1,
            Text = text,
            TextColor3 = ThemeManager.GetColor("TextSecondary"),
            TextSize = 12,
            Font = Enum.Font.Gotham,
            Parent = dividerFrame
        })

        local line2 = Utility.Create("Frame", {
            Name = "Line2",
            Size = UDim2.new(0.4, -10, 0, 1),
            Position = UDim2.new(0.6, 10, 0.5, -0.5),
            BackgroundColor3 = ThemeManager.GetColor("Border"),
            BorderSizePixel = 0,
            Parent = dividerFrame
        })
    end

    return {
        Frame = dividerFrame,
        Destroy = function()
            dividerFrame:Destroy()
        end
    }
end

ProgressBarSystem.Create = function(parent, config)
    config = config or {}
    local text = config.Text or "Progress"
    local default = config.Default or 0
    local showPercentage = config.ShowPercentage ~= false

    local progressFrame = Utility.Create("Frame", {
        Name = "ProgressBar_" .. Utility.GenerateUUID(),
        Size = UDim2.new(1, 0, 0, 40),
        BackgroundTransparency = 1,
        Parent = parent
    })

    local label = Utility.Create("TextLabel", {
        Name = "Label",
        Size = UDim2.new(1, 0, 0, 20),
        BackgroundTransparency = 1,
        Text = text,
        TextColor3 = ThemeManager.GetColor("Text"),
        TextSize = 14,
        Font = Enum.Font.Gotham,
        TextXAlignment = Enum.TextXAlignment.Left,
        Parent = progressFrame
    })

    local percentageLabel = showPercentage and Utility.Create("TextLabel", {
        Name = "Percentage",
        Size = UDim2.new(0, 50, 0, 20),
        Position = UDim2.new(1, -50, 0, 0),
        BackgroundTransparency = 1,
        Text = tostring(math.floor(default * 100)) .. "%",
        TextColor3 = ThemeManager.GetColor("Accent"),
        TextSize = 14,
        Font = Enum.Font.GothamBold,
        TextXAlignment = Enum.TextXAlignment.Right,
        Parent = progressFrame
    })

    local track = Utility.Create("Frame", {
        Name = "Track",
        Size = UDim2.new(1, 0, 0, 8),
        Position = UDim2.new(0, 0, 0, 25),
        BackgroundColor3 = ThemeManager.GetColor("BackgroundTertiary"),
        BorderSizePixel = 0,
        Parent = progressFrame
    })

    local trackCorner = Utility.Create("UICorner", {
        CornerRadius = UDim.new(1, 0),
        Parent = track
    })

    local fill = Utility.Create("Frame", {
        Name = "Fill",
        Size = UDim2.new(default, 0, 1, 0),
        BackgroundColor3 = ThemeManager.GetColor("Accent"),
        BorderSizePixel = 0,
        Parent = track
    })

    local fillCorner = Utility.Create("UICorner", {
        CornerRadius = UDim.new(1, 0),
        Parent = fill
    })

    local gradient = Utility.Create("UIGradient", {
        Color = ColorSequence.new({
            ColorSequenceKeypoint.new(0, ThemeManager.GetColor("Accent")),
            ColorSequenceKeypoint.new(1, Utility.LerpColor(ThemeManager.GetColor("Accent"), Color3.fromRGB(255, 255, 255), 0.3))
        }),
        Rotation = 90,
        Parent = fill
    })

    local value = default

    return {
        Frame = progressFrame,
        SetProgress = function(progress)
            value = math.clamp(progress, 0, 1)
            Animation.Tween(fill, {Size = UDim2.new(value, 0, 1, 0)}, 0.3)
            if percentageLabel then
                percentageLabel.Text = tostring(math.floor(value * 100)) .. "%"
            end
        end,
        GetProgress = function()
            return value
        end,
        Destroy = function()
            progressFrame:Destroy()
        end
    }
end

SearchSystem.Create = function(parent, config)
    config = config or {}
    local placeholder = config.Placeholder or "Search..."
    local callback = config.Callback or function() end
    local debounce = config.Debounce or 0.2

    local searchFrame = Utility.Create("Frame", {
        Name = "Search_" .. Utility.GenerateUUID(),
        Size = UDim2.new(1, 0, 0, 35),
        BackgroundColor3 = ThemeManager.GetColor("BackgroundTertiary"),
        BorderSizePixel = 0,
        Parent = parent
    })

    local corner = Utility.Create("UICorner", {
        CornerRadius = UDim.new(0, 6),
        Parent = searchFrame
    })

    local icon = Utility.Create("ImageLabel", {
        Name = "Icon",
        Size = UDim2.new(0, 20, 0, 20),
        Position = UDim2.new(0, 10, 0.5, -10),
        BackgroundTransparency = 1,
        Image = "rbxassetid://3926305904",
        ImageRectOffset = Vector2.new(964, 324),
        ImageRectSize = Vector2.new(36, 36),
        ImageColor3 = ThemeManager.GetColor("TextSecondary"),
        Parent = searchFrame
    })

    local textBox = Utility.Create("TextBox", {
        Name = "Input",
        Size = UDim2.new(1, -80, 1, 0),
        Position = UDim2.new(0, 35, 0, 0),
        BackgroundTransparency = 1,
        Text = "",
        PlaceholderText = placeholder,
        TextColor3 = ThemeManager.GetColor("Text"),
        PlaceholderColor3 = ThemeManager.GetColor("TextSecondary"),
        TextSize = 14,
        Font = Enum.Font.Gotham,
        Parent = searchFrame
    })

    local clearButton = Utility.Create("TextButton", {
        Name = "Clear",
        Size = UDim2.new(0, 25, 0, 25),
        Position = UDim2.new(1, -30, 0.5, -12.5),
        BackgroundTransparency = 1,
        Text = "×",
        TextColor3 = ThemeManager.GetColor("TextSecondary"),
        TextSize = 20,
        Font = Enum.Font.GothamBold,
        Visible = false,
        Parent = searchFrame
    })

    local lastSearch = ""
    local debounceTimer = nil

    textBox:GetPropertyChangedSignal("Text"):Connect(function()
        local text = textBox.Text
        clearButton.Visible = #text > 0

        if debounceTimer then
            debounceTimer:Disconnect()
        end

        debounceTimer = task.delay(debounce, function()
            if text ~= lastSearch then
                lastSearch = text
                callback(text)
            end
        end)
    end)

    clearButton.MouseButton1Click:Connect(function()
        textBox.Text = ""
        textBox:CaptureFocus()
    end)

    return {
        Frame = searchFrame,
        GetText = function()
            return textBox.Text
        end,
        SetText = function(text)
            textBox.Text = text
        end,
        Focus = function()
            textBox:CaptureFocus()
        end,
        Destroy = function()
            searchFrame:Destroy()
        end
    }
end

TabSystem.Create = function(parent, config)
    config = config or {}
    local tabs = config.Tabs or {}
    local default = config.Default or 1

    local tabFrame = Utility.Create("Frame", {
        Name = "TabSystem_" .. Utility.GenerateUUID(),
        Size = UDim2.new(1, 0, 1, 0),
        BackgroundTransparency = 1,
        Parent = parent
    })

    local tabButtonsFrame = Utility.Create("Frame", {
        Name = "TabButtons",
        Size = UDim2.new(1, 0, 0, 40),
        BackgroundColor3 = ThemeManager.GetColor("BackgroundSecondary"),
        BorderSizePixel = 0,
        Parent = tabFrame
    })

    local tabButtonsCorner = Utility.Create("UICorner", {
        CornerRadius = UDim.new(0, 8),
        Parent = tabButtonsFrame
    })

    local tabButtonsLayout = Utility.Create("UIListLayout", {
        FillDirection = Enum.FillDirection.Horizontal,
        HorizontalAlignment = Enum.HorizontalAlignment.Left,
        Padding = UDim.new(0, 5),
        Parent = tabButtonsFrame
    })

    local tabButtonsPadding = Utility.Create("UIPadding", {
        PaddingLeft = UDim.new(0, 10),
        PaddingRight = UDim.new(0, 10),
        PaddingTop = UDim.new(0, 5),
        PaddingBottom = UDim.new(0, 5),
        Parent = tabButtonsFrame
    })

    local contentFrame = Utility.Create("Frame", {
        Name = "Content",
        Size = UDim2.new(1, 0, 1, -50),
        Position = UDim2.new(0, 0, 0, 45),
        BackgroundTransparency = 1,
        Parent = tabFrame
    })

    local tabContents = {}
    local tabButtons = {}
    local currentTab = default

    local indicator = Utility.Create("Frame", {
        Name = "Indicator",
        Size = UDim2.new(0, 0, 0, 3),
        Position = UDim2.new(0, 0, 1, -3),
        BackgroundColor3 = ThemeManager.GetColor("Accent"),
        BorderSizePixel = 0,
        Parent = tabButtonsFrame
    })

    local indicatorCorner = Utility.Create("UICorner", {
        CornerRadius = UDim.new(1, 0),
        Parent = indicator
    })

    for i, tab in ipairs(tabs) do
        local button = Utility.Create("TextButton", {
            Name = "Tab_" .. tostring(i),
            Size = UDim2.new(0, 100, 1, -10),
            BackgroundColor3 = i == default and Utility.LerpColor(ThemeManager.GetColor("BackgroundTertiary"), ThemeManager.GetColor("Accent"), 0.2) or ThemeManager.GetColor("BackgroundTertiary"),
            Text = tab.Name or "Tab " .. tostring(i),
            TextColor3 = i == default and ThemeManager.GetColor("Text") or ThemeManager.GetColor("TextSecondary"),
            TextSize = 13,
            Font = Enum.Font.GothamSemibold,
            Parent = tabButtonsFrame
        })

        local buttonCorner = Utility.Create("UICorner", {
            CornerRadius = UDim.new(0, 6),
            Parent = button
        })

        local content = Utility.Create("ScrollingFrame", {
            Name = "Content_" .. tostring(i),
            Size = UDim2.new(1, 0, 1, 0),
            BackgroundTransparency = 1,
            ScrollBarThickness = 4,
            ScrollBarImageColor3 = ThemeManager.GetColor("Accent"),
            CanvasSize = UDim2.new(0, 0, 0, 0),
            Visible = i == default,
            Parent = contentFrame
        })

        local contentLayout = Utility.Create("UIListLayout", {
            Padding = UDim.new(0, 10),
            Parent = content
        })

        local contentPadding = Utility.Create("UIPadding", {
            PaddingLeft = UDim.new(0, 10),
            PaddingRight = UDim.new(0, 10),
            PaddingTop = UDim.new(0, 10),
            PaddingBottom = UDim.new(0, 10),
            Parent = content
        })

        contentLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
            content.CanvasSize = UDim2.new(0, 0, 0, contentLayout.AbsoluteContentSize.Y + 20)
        end)

        button.MouseButton1Click:Connect(function()
            if currentTab ~= i then
                local oldButton = tabButtons[currentTab]
                local oldContent = tabContents[currentTab]

                Animation.Tween(oldButton, {BackgroundColor3 = ThemeManager.GetColor("BackgroundTertiary"), TextColor3 = ThemeManager.GetColor("TextSecondary")}, 0.2)
                Animation.FadeOut(oldContent, 0.2)
                task.delay(0.2, function()
                    oldContent.Visible = false
                end)

                currentTab = i
                content.Visible = true
                Animation.Tween(button, {BackgroundColor3 = Utility.LerpColor(ThemeManager.GetColor("BackgroundTertiary"), ThemeManager.GetColor("Accent"), 0.2), TextColor3 = ThemeManager.GetColor("Text")}, 0.2)
                Animation.FadeIn(content, 0.2)

                Animation.Tween(indicator, {Position = UDim2.new(0, button.AbsolutePosition.X - tabButtonsFrame.AbsolutePosition.X, 1, -3), Size = UDim2.new(0, button.AbsoluteSize.X, 0, 3)}, 0.3, Enum.EasingStyle.Quart)
            end
        end)

        table.insert(tabButtons, button)
        table.insert(tabContents, content)
    end

    task.delay(0.1, function()
        local firstButton = tabButtons[default]
        if firstButton then
            indicator.Size = UDim2.new(0, firstButton.AbsoluteSize.X, 0, 3)
            indicator.Position = UDim2.new(0, firstButton.AbsolutePosition.X - tabButtonsFrame.AbsolutePosition.X, 1, -3)
        end
    end)

    return {
        Frame = tabFrame,
        GetTabContent = function(index)
            return tabContents[index]
        end,
        SwitchTab = function(index)
            if tabButtons[index] then
                tabButtons[index].MouseButton1Click:Fire()
            end
        end,
        Destroy = function()
            tabFrame:Destroy()
        end
    }
end

SectionSystem.Create = function(parent, config)
    config = config or {}
    local title = config.Title or "Section"
    local collapsible = config.Collapsible or false
    local defaultOpen = config.DefaultOpen ~= false

    local sectionFrame = Utility.Create("Frame", {
        Name = "Section_" .. Utility.GenerateUUID(),
        Size = UDim2.new(1, 0, 0, 40),
        BackgroundColor3 = ThemeManager.GetColor("BackgroundSecondary"),
        BorderSizePixel = 0,
        ClipsDescendants = true,
        Parent = parent
    })

    local corner = Utility.Create("UICorner", {
        CornerRadius = UDim.new(0, 8),
        Parent = sectionFrame
    })

    local stroke = Utility.Create("UIStroke", {
        Color = ThemeManager.GetColor("Border"),
        Thickness = 1,
        Parent = sectionFrame
    })

    local header = Utility.Create("Frame", {
        Name = "Header",
        Size = UDim2.new(1, 0, 0, 40),
        BackgroundTransparency = 1,
        Parent = sectionFrame
    })

    local titleLabel = Utility.Create("TextLabel", {
        Name = "Title",
        Size = UDim2.new(1, collapsible and -40 or -20, 1, 0),
        Position = UDim2.new(0, 15, 0, 0),
        BackgroundTransparency = 1,
        Text = title,
        TextColor3 = ThemeManager.GetColor("Text"),
        TextSize = 14,
        Font = Enum.Font.GothamBold,
        TextXAlignment = Enum.TextXAlignment.Left,
        Parent = header
    })

    local content = Utility.Create("Frame", {
        Name = "Content",
        Size = UDim2.new(1, -20, 0, 0),
        Position = UDim2.new(0, 10, 0, 45),
        BackgroundTransparency = 1,
        Parent = sectionFrame
    })

    local layout = Utility.Create("UIListLayout", {
        Padding = UDim.new(0, 8),
        Parent = content
    })

    layout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        if isOpen then
            Animation.Tween(sectionFrame, {Size = UDim2.new(1, 0, 0, 50 + layout.AbsoluteContentSize.Y)}, 0.2)
        end
    end)

    local isOpen = defaultOpen

    if collapsible then
        local arrow = Utility.Create("ImageLabel", {
            Name = "Arrow",
            Size = UDim2.new(0, 20, 0, 20),
            Position = UDim2.new(1, -30, 0.5, -10),
            BackgroundTransparency = 1,
            Image = "rbxassetid://3926305904",
            ImageRectOffset = Vector2.new(564, 284),
            ImageRectSize = Vector2.new(36, 36),
            ImageColor3 = ThemeManager.GetColor("TextSecondary"),
            Rotation = defaultOpen and 180 or 0,
            Parent = header
        })

        header.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 then
                isOpen = not isOpen
                Animation.Tween(arrow, {Rotation = isOpen and 180 or 0}, 0.3)
                if isOpen then
                    Animation.Tween(sectionFrame, {Size = UDim2.new(1, 0, 0, 50 + layout.AbsoluteContentSize.Y)}, 0.3, Enum.EasingStyle.Quart)
                else
                    Animation.Tween(sectionFrame, {Size = UDim2.new(1, 0, 0, 40)}, 0.3, Enum.EasingStyle.Quart)
                end
            end
        end)
    else
        isOpen = true
    end

    if defaultOpen then
        sectionFrame.Size = UDim2.new(1, 0, 0, 50)
    end

    return {
        Frame = sectionFrame,
        Content = content,
        SetTitle = function(newTitle)
            titleLabel.Text = newTitle
        end,
        Toggle = function()
            if collapsible then
                header.InputBegan:Fire({UserInputType = Enum.UserInputType.MouseButton1})
            end
        end,
        Destroy = function()
            sectionFrame:Destroy()
        end
    }
end

WindowManager.Windows = {}

WindowManager.Create = function(config)
    config = config or {}
    local title = config.Title or "AdvancedUI"
    local size = config.Size or UDim2.new(0, 600, 0, 400)
    local position = config.Position or UDim2.new(0.5, -300, 0.5, -200)
    local minSize = config.MinSize or Vector2.new(400, 300)
    local maxSize = config.MaxSize or Vector2.new(1200, 800)
    local theme = config.Theme or "Dark"

    ThemeManager.SetTheme(theme)

    local screenGui = Utility.Create("ScreenGui", {
        Name = "AdvancedUI_" .. Utility.GenerateUUID(),
        Parent = CoreGui,
        ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
        ResetOnSpawn = false
    })

    local mainFrame = Utility.Create("Frame", {
        Name = "Main",
        Size = size,
        Position = position,
        BackgroundColor3 = ThemeManager.GetColor("Background"),
        BorderSizePixel = 0,
        Parent = screenGui
    })

    local mainCorner = Utility.Create("UICorner", {
        CornerRadius = UDim.new(0, 12),
        Parent = mainFrame
    })

    local mainStroke = Utility.Create("UIStroke", {
        Color = ThemeManager.GetColor("Border"),
        Thickness = 1,
        Parent = mainFrame
    })

    local shadow = Utility.Create("ImageLabel", {
        Name = "Shadow",
        Size = UDim2.new(1, 60, 1, 60),
        Position = UDim2.new(0, -30, 0, -30),
        BackgroundTransparency = 1,
        Image = "rbxassetid://5554236805",
        ImageColor3 = Color3.fromRGB(0, 0, 0),
        ImageTransparency = 0.4,
        ScaleType = Enum.ScaleType.Slice,
        SliceCenter = Rect.new(23, 23, 277, 277),
        Parent = mainFrame
    })

    local titleBar = Utility.Create("Frame", {
        Name = "TitleBar",
        Size = UDim2.new(1, 0, 0, 45),
        BackgroundColor3 = ThemeManager.GetColor("BackgroundSecondary"),
        BorderSizePixel = 0,
        Parent = mainFrame
    })

    local titleBarCorner = Utility.Create("UICorner", {
        CornerRadius = UDim.new(0, 12),
        Parent = titleBar
    })

    local titleBarFix = Utility.Create("Frame", {
        Name = "Fix",
        Size = UDim2.new(1, 0, 0, 10),
        Position = UDim2.new(0, 0, 1, -10),
        BackgroundColor3 = ThemeManager.GetColor("BackgroundSecondary"),
        BorderSizePixel = 0,
        Parent = titleBar
    })

    local titleLabel = Utility.Create("TextLabel", {
        Name = "Title",
        Size = UDim2.new(1, -150, 1, 0),
        Position = UDim2.new(0, 15, 0, 0),
        BackgroundTransparency = 1,
        Text = title,
        TextColor3 = ThemeManager.GetColor("Text"),
        TextSize = 16,
        Font = Enum.Font.GothamBold,
        TextXAlignment = Enum.TextXAlignment.Left,
        Parent = titleBar
    })

    local buttonContainer = Utility.Create("Frame", {
        Name = "Buttons",
        Size = UDim2.new(0, 120, 0, 30),
        Position = UDim2.new(1, -125, 0, 7.5),
        BackgroundTransparency = 1,
        Parent = titleBar
    })

    local minimizeButton = Utility.Create("TextButton", {
        Name = "Minimize",
        Size = UDim2.new(0, 30, 0, 30),
        BackgroundColor3 = ThemeManager.GetColor("BackgroundTertiary"),
        Text = "−",
        TextColor3 = ThemeManager.GetColor("Text"),
        TextSize = 18,
        Font = Enum.Font.GothamBold,
        Parent = buttonContainer
    })

    local maximizeButton = Utility.Create("TextButton", {
        Name = "Maximize",
        Size = UDim2.new(0, 30, 0, 30),
        Position = UDim2.new(0, 35, 0, 0),
        BackgroundColor3 = ThemeManager.GetColor("BackgroundTertiary"),
        Text = "□",
        TextColor3 = ThemeManager.GetColor("Text"),
        TextSize = 14,
        Font = Enum.Font.GothamBold,
        Parent = buttonContainer
    })

    local closeButton = Utility.Create("TextButton", {
        Name = "Close",
        Size = UDim2.new(0, 30, 0, 30),
        Position = UDim2.new(0, 70, 0, 0),
        BackgroundColor3 = ThemeManager.GetColor("Error"),
        Text = "×",
        TextColor3 = Color3.fromRGB(255, 255, 255),
        TextSize = 18,
        Font = Enum.Font.GothamBold,
        Parent = buttonContainer
    })

    for _, btn in ipairs({minimizeButton, maximizeButton, closeButton}) do
        local btnCorner = Utility.Create("UICorner", {
            CornerRadius = UDim.new(0, 6),
            Parent = btn
        })
    end

    local contentFrame = Utility.Create("Frame", {
        Name = "Content",
        Size = UDim2.new(1, -20, 1, -65),
        Position = UDim2.new(0, 10, 0, 55),
        BackgroundTransparency = 1,
        Parent = mainFrame
    })

    local isMinimized = false
    local isMaximized = false
    local originalSize = size
    local originalPosition = position

    DragSystem.MakeDraggable(mainFrame, titleBar)
    DragSystem.MakeResizable(mainFrame, minSize, maxSize)

    minimizeButton.MouseButton1Click:Connect(function()
        if not isMinimized then
            MinimizeSystem.Minimize(window)
        else
            MinimizeSystem.Restore(window)
        end
        isMinimized = not isMinimized
    end)

    maximizeButton.MouseButton1Click:Connect(function()
        if not isMaximized then
            originalSize = mainFrame.Size
            originalPosition = mainFrame.Position
            Animation.Tween(mainFrame, {
                Size = UDim2.new(1, -40, 1, -40),
                Position = UDim2.new(0, 20, 0, 20)
            }, 0.3, Enum.EasingStyle.Quart)
        else
            Animation.Tween(mainFrame, {Size = originalSize, Position = originalPosition}, 0.3, Enum.EasingStyle.Quart)
        end
        isMaximized = not isMaximized
    end)

    closeButton.MouseButton1Click:Connect(function()
        Animation.ScaleOut(mainFrame, 0.3)
        task.delay(0.3, function()
            screenGui:Destroy()
        end)
    end)

    local window = {
        MainFrame = mainFrame,
        Content = contentFrame,
        Title = title,
        IsMinimized = false,
        ScreenGui = screenGui,
        Destroy = function()
            screenGui:Destroy()
        end
    }

    table.insert(WindowManager.Windows, window)
    Animation.ScaleIn(mainFrame, 0.4)

    return window
end

TooltipSystem.Create = function()
    local tooltipGui = Utility.Create("ScreenGui", {
        Name = "TooltipSystem",
        Parent = CoreGui,
        ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
        Enabled = false
    })

    local tooltipFrame = Utility.Create("Frame", {
        Name = "Tooltip",
        Size = UDim2.new(0, 200, 0, 40),
        BackgroundColor3 = ThemeManager.GetColor("BackgroundSecondary"),
        BorderSizePixel = 0,
        Parent = tooltipGui
    })

    local corner = Utility.Create("UICorner", {
        CornerRadius = UDim.new(0, 6),
        Parent = tooltipFrame
    })

    local stroke = Utility.Create("UIStroke", {
        Color = ThemeManager.GetColor("Border"),
        Thickness = 1,
        Parent = tooltipFrame
    })

    local label = Utility.Create("TextLabel", {
        Name = "Text",
        Size = UDim2.new(1, -20, 1, 0),
        Position = UDim2.new(0, 10, 0, 0),
        BackgroundTransparency = 1,
        Text = "",
        TextColor3 = ThemeManager.GetColor("Text"),
        TextSize = 13,
        Font = Enum.Font.Gotham,
        TextWrapped = true,
        Parent = tooltipFrame
    })

    local currentTarget = nil
    local showDelay = 0.5
    local hideDelay = 0.1
    local showTimer = nil
    local hideTimer = nil

    local function showTooltip(target, text)
        if showTimer then
            task.cancel(showTimer)
        end

        showTimer = task.delay(showDelay, function()
            label.Text = text
            tooltipGui.Enabled = true
            currentTarget = target

            local bounds = Utility.GetTextBounds(text, Enum.Font.Gotham, 13)
            tooltipFrame.Size = UDim2.new(0, math.min(bounds.X + 20, 300), 0, math.max(bounds.Y + 20, 40))

            local pos = UserInputService:GetMouseLocation()
            tooltipFrame.Position = UDim2.new(0, pos.X + 15, 0, pos.Y + 15)
        end)
    end

    local function hideTooltip()
        if showTimer then
            task.cancel(showTimer)
        end

        hideTimer = task.delay(hideDelay, function()
            tooltipGui.Enabled = false
            currentTarget = nil
        end)
    end

    RunService.RenderStepped:Connect(function()
        if tooltipGui.Enabled then
            local pos = UserInputService:GetMouseLocation()
            tooltipFrame.Position = UDim2.new(0, pos.X + 15, 0, pos.Y + 15)
        end
    end)

    return {
        Show = showTooltip,
        Hide = hideTooltip,
        Attach = function(instance, text)
            instance.MouseEnter:Connect(function()
                showTooltip(instance, text)
            end)
            instance.MouseLeave:Connect(function()
                hideTooltip()
            end)
        end
    }
end

SpinnerSystem.Create = function(parent, config)
    config = config or {}
    local size = config.Size or 50
    local color = config.Color or ThemeManager.GetColor("Accent")

    local spinnerFrame = Utility.Create("Frame", {
        Name = "Spinner_" .. Utility.GenerateUUID(),
        Size = UDim2.new(0, size, 0, size),
        BackgroundTransparency = 1,
        Parent = parent
    })

    local spinner = Utility.Create("ImageLabel", {
        Name = "Spinner",
        Size = UDim2.new(1, 0, 1, 0),
        BackgroundTransparency = 1,
        Image = "rbxassetid://3926305904",
        ImageRectOffset = Vector2.new(564, 284),
        ImageRectSize = Vector2.new(36, 36),
        ImageColor3 = color,
        Parent = spinnerFrame
    })

    local rotation = 0
    local connection

    local function start()
        if connection then return end
        connection = RunService.RenderStepped:Connect(function()
            rotation = rotation + 10
            spinner.Rotation = rotation
        end)
    end

    local function stop()
        if connection then
            connection:Disconnect()
            connection = nil
        end
    end

    start()

    return {
        Frame = spinnerFrame,
        Start = start,
        Stop = stop,
        SetColor = function(newColor)
            spinner.ImageColor3 = newColor
        end,
        Destroy = function()
            stop()
            spinnerFrame:Destroy()
        end
    }
end

ContextMenuSystem.Create = function()
    local menuGui = Utility.Create("ScreenGui", {
        Name = "ContextMenu",
        Parent = CoreGui,
        ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
        Enabled = false
    })

    local menuFrame = Utility.Create("Frame", {
        Name = "Menu",
        Size = UDim2.new(0, 200, 0, 0),
        BackgroundColor3 = ThemeManager.GetColor("BackgroundSecondary"),
        BorderSizePixel = 0,
        Parent = menuGui
    })

    local corner = Utility.Create("UICorner", {
        CornerRadius = UDim.new(0, 8),
        Parent = menuFrame
    })

    local stroke = Utility.Create("UIStroke", {
        Color = ThemeManager.GetColor("Border"),
        Thickness = 1,
        Parent = menuFrame
    })

    local layout = Utility.Create("UIListLayout", {
        Padding = UDim.new(0, 2),
        Parent = menuFrame
    })

    local padding = Utility.Create("UIPadding", {
        PaddingTop = UDim.new(0, 5),
        PaddingBottom = UDim.new(0, 5),
        Parent = menuFrame
    })

    local items = {}

    local function close()
        Animation.Tween(menuFrame, {Size = UDim2.new(0, 200, 0, 0)}, 0.2, nil, nil, function()
            menuGui.Enabled = false
            for _, item in ipairs(items) do
                item:Destroy()
            end
            items = {}
        end)
    end

    UserInputService.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.MouseButton2 then
            if menuGui.Enabled then
                local pos = UserInputService:GetMouseLocation()
                local menuPos = menuFrame.AbsolutePosition
                local menuSize = menuFrame.AbsoluteSize
                if pos.X < menuPos.X or pos.X > menuPos.X + menuSize.X or pos.Y < menuPos.Y or pos.Y > menuPos.Y + menuSize.Y then
                    close()
                end
            end
        end
    end)

    return {
        Show = function(position, options)
            for _, item in ipairs(items) do
                item:Destroy()
            end
            items = {}

            for _, option in ipairs(options) do
                local item = Utility.Create("TextButton", {
                    Name = "Item",
                    Size = UDim2.new(1, -10, 0, 30),
                    Position = UDim2.new(0, 5, 0, 0),
                    BackgroundColor3 = ThemeManager.GetColor("BackgroundTertiary"),
                    Text = option.Text or "",
                    TextColor3 = option.Color or ThemeManager.GetColor("Text"),
                    TextSize = 13,
                    Font = Enum.Font.Gotham,
                    Parent = menuFrame
                })

                local itemCorner = Utility.Create("UICorner", {
                    CornerRadius = UDim.new(0, 4),
                    Parent = item
                })

                item.MouseEnter:Connect(function()
                    Animation.Tween(item, {BackgroundColor3 = Utility.LerpColor(ThemeManager.GetColor("BackgroundTertiary"), ThemeManager.GetColor("Accent"), 0.3)}, 0.15)
                end)

                item.MouseLeave:Connect(function()
                    Animation.Tween(item, {BackgroundColor3 = ThemeManager.GetColor("BackgroundTertiary")}, 0.15)
                end)

                item.MouseButton1Click:Connect(function()
                    if option.Callback then
                        option.Callback()
                    end
                    close()
                end)

                table.insert(items, item)
            end

            menuFrame.Position = UDim2.new(0, position.X, 0, position.Y)
            menuGui.Enabled = true

            local height = #options * 32 + 10
            Animation.Tween(menuFrame, {Size = UDim2.new(0, 200, 0, height)}, 0.2, Enum.EasingStyle.Back)
        end,
        Close = close
    }
end

ModalSystem.Create = function(config)
    config = config or {}
    local title = config.Title or "Modal"
    local message = config.Message or ""
    local buttons = config.Buttons or {{Text = "OK", Callback = function() end}}
    local closeOnClickOutside = config.CloseOnClickOutside ~= false

    local modalGui = Utility.Create("ScreenGui", {
        Name = "Modal_" .. Utility.GenerateUUID(),
        Parent = CoreGui,
        ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
        DisplayOrder = 100
    })

    local overlay = Utility.Create("Frame", {
        Name = "Overlay",
        Size = UDim2.new(1, 0, 1, 0),
        BackgroundColor3 = Color3.fromRGB(0, 0, 0),
        BackgroundTransparency = 1,
        Parent = modalGui
    })

    local modalFrame = Utility.Create("Frame", {
        Name = "Modal",
        Size = UDim2.new(0, 400, 0, 200),
        Position = UDim2.new(0.5, -200, 0.5, -100),
        BackgroundColor3 = ThemeManager.GetColor("Background"),
        BorderSizePixel = 0,
        Parent = modalGui
    })

    local corner = Utility.Create("UICorner", {
        CornerRadius = UDim.new(0, 12),
        Parent = modalFrame
    })

    local stroke = Utility.Create("UIStroke", {
        Color = ThemeManager.GetColor("Border"),
        Thickness = 1,
        Parent = modalFrame
    })

    local shadow = Utility.Create("ImageLabel", {
        Name = "Shadow",
        Size = UDim2.new(1, 40, 1, 40),
        Position = UDim2.new(0, -20, 0, -20),
        BackgroundTransparency = 1,
        Image = "rbxassetid://5554236805",
        ImageColor3 = Color3.fromRGB(0, 0, 0),
        ImageTransparency = 0.3,
        ScaleType = Enum.ScaleType.Slice,
        SliceCenter = Rect.new(23, 23, 277, 277),
        Parent = modalFrame
    })

    local titleLabel = Utility.Create("TextLabel", {
        Name = "Title",
        Size = UDim2.new(1, -40, 0, 40),
        Position = UDim2.new(0, 20, 0, 15),
        BackgroundTransparency = 1,
        Text = title,
        TextColor3 = ThemeManager.GetColor("Text"),
        TextSize = 18,
        Font = Enum.Font.GothamBold,
        TextXAlignment = Enum.TextXAlignment.Left,
        Parent = modalFrame
    })

    local messageLabel = Utility.Create("TextLabel", {
        Name = "Message",
        Size = UDim2.new(1, -40, 0, 80),
        Position = UDim2.new(0, 20, 0, 60),
        BackgroundTransparency = 1,
        Text = message,
        TextColor3 = ThemeManager.GetColor("TextSecondary"),
        TextSize = 14,
        Font = Enum.Font.Gotham,
        TextWrapped = true,
        Parent = modalFrame
    })

    local buttonContainer = Utility.Create("Frame", {
        Name = "Buttons",
        Size = UDim2.new(1, -40, 0, 40),
        Position = UDim2.new(0, 20, 1, -55),
        BackgroundTransparency = 1,
        Parent = modalFrame
    })

    local buttonLayout = Utility.Create("UIListLayout", {
        FillDirection = Enum.FillDirection.Horizontal,
        HorizontalAlignment = Enum.HorizontalAlignment.Right,
        Padding = UDim.new(0, 10),
        Parent = buttonContainer
    })

    for _, btnConfig in ipairs(buttons) do
        local btn = ButtonSystem.Create(buttonContainer, {
            Text = btnConfig.Text,
            Size = UDim2.new(0, 100, 0, 35),
            Style = btnConfig.Primary and "Primary" or "Default",
            Callback = function()
                btnConfig.Callback()
                close()
            end
        })
    end

    local function close()
        Animation.Tween(overlay, {BackgroundTransparency = 1}, 0.3)
        Animation.ScaleOut(modalFrame, 0.3)
        task.delay(0.3, function()
            modalGui:Destroy()
        end)
    end

    if closeOnClickOutside then
        overlay.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 then
                close()
            end
        end)
    end

    Animation.Tween(overlay, {BackgroundTransparency = 0.5}, 0.3)
    Animation.ScaleIn(modalFrame, 0.4)

    return {
        Close = close,
        Destroy = function()
            modalGui:Destroy()
        end
    }
end

ModalSystem.Alert = function(title, message, callback)
    return ModalSystem.Create({
        Title = title,
        Message = message,
        Buttons = {
            {Text = "OK", Primary = true, Callback = callback or function() end}
        }
    })
end

ModalSystem.Confirm = function(title, message, onConfirm, onCancel)
    return ModalSystem.Create({
        Title = title,
        Message = message,
        Buttons = {
            {Text = "Cancel", Callback = onCancel or function() end},
            {Text = "Confirm", Primary = true, Callback = onConfirm or function() end}
        }
    })
end

ScrollSystem.Create = function(parent, config)
    config = config or {}
    local size = config.Size or UDim2.new(1, 0, 1, 0)
    local position = config.Position or UDim2.new(0, 0, 0, 0)

    local scrollFrame = Utility.Create("ScrollingFrame", {
        Name = "Scroll_" .. Utility.GenerateUUID(),
        Size = size,
        Position = position,
        BackgroundTransparency = 1,
        ScrollBarThickness = 6,
        ScrollBarImageColor3 = ThemeManager.GetColor("Accent"),
        ScrollBarImageTransparency = 0.5,
        BorderSizePixel = 0,
        CanvasSize = UDim2.new(0, 0, 0, 0),
        Parent = parent
    })

    local layout = Utility.Create("UIListLayout", {
        Padding = UDim.new(0, 10),
        Parent = scrollFrame
    })

    local padding = Utility.Create("UIPadding", {
        PaddingLeft = UDim.new(0, 10),
        PaddingRight = UDim.new(0, 10),
        PaddingTop = UDim.new(0, 10),
        PaddingBottom = UDim.new(0, 10),
        Parent = scrollFrame
    })

    layout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        scrollFrame.CanvasSize = UDim2.new(0, 0, 0, layout.AbsoluteContentSize.Y + 20)
    end)

    return {
        Frame = scrollFrame,
        ScrollToBottom = function()
            scrollFrame.CanvasPosition = Vector2.new(0, scrollFrame.CanvasSize.Y.Offset)
        end,
        ScrollToTop = function()
            scrollFrame.CanvasPosition = Vector2.new(0, 0)
        end,
        Destroy = function()
            scrollFrame:Destroy()
        end
    }
end

GridSystem.Create = function(parent, config)
    config = config or {}
    local columns = config.Columns or 3
    local cellSize = config.CellSize or UDim2.new(0, 100, 0, 100)
    local cellPadding = config.CellPadding or UDim.new(0, 10)

    local gridFrame = Utility.Create("Frame", {
        Name = "Grid_" .. Utility.GenerateUUID(),
        Size = UDim2.new(1, 0, 1, 0),
        BackgroundTransparency = 1,
        Parent = parent
    })

    local gridLayout = Utility.Create("UIGridLayout", {
        CellSize = cellSize,
        CellPadding = cellPadding,
        FillDirection = Enum.FillDirection.Horizontal,
        HorizontalAlignment = Enum.HorizontalAlignment.Left,
        VerticalAlignment = Enum.VerticalAlignment.Top,
        Parent = gridFrame
    })

    return {
        Frame = gridFrame,
        AddItem = function(item)
            item.Parent = gridFrame
        end,
        RemoveItem = function(item)
            item:Destroy()
        end,
        Clear = function()
            for _, child in ipairs(gridFrame:GetChildren()) do
                if child:IsA("GuiObject") then
                    child:Destroy()
                end
            end
        end,
        Destroy = function()
            gridFrame:Destroy()
        end
    }
end

TreeViewSystem.Create = function(parent, config)
    config = config or {}
    local items = config.Items or {}

    local treeFrame = Utility.Create("Frame", {
        Name = "TreeView_" .. Utility.GenerateUUID(),
        Size = UDim2.new(1, 0, 1, 0),
        BackgroundTransparency = 1,
        Parent = parent
    })

    local scrollFrame = Utility.Create("ScrollingFrame", {
        Name = "Scroll",
        Size = UDim2.new(1, 0, 1, 0),
        BackgroundTransparency = 1,
        ScrollBarThickness = 4,
        ScrollBarImageColor3 = ThemeManager.GetColor("Accent"),
        CanvasSize = UDim2.new(0, 0, 0, 0),
        Parent = treeFrame
    })

    local layout = Utility.Create("UIListLayout", {
        Padding = UDim.new(0, 2),
        Parent = scrollFrame
    })

    local treeItems = {}

    local function createTreeItem(item, depth)
        local itemFrame = Utility.Create("Frame", {
            Name = "Item_" .. item.Name,
            Size = UDim2.new(1, -20 * depth, 0, 30),
            Position = UDim2.new(0, 20 * depth, 0, 0),
            BackgroundColor3 = ThemeManager.GetColor("BackgroundTertiary"),
            BorderSizePixel = 0,
            Parent = scrollFrame
        })

        local corner = Utility.Create("UICorner", {
            CornerRadius = UDim.new(0, 4),
            Parent = itemFrame
        })

        local expandButton = item.Children and Utility.Create("TextButton", {
            Name = "Expand",
            Size = UDim2.new(0, 20, 0, 20),
            Position = UDim2.new(0, 5, 0.5, -10),
            BackgroundTransparency = 1,
            Text = item.Expanded and "▼" or "▶",
            TextColor3 = ThemeManager.GetColor("TextSecondary"),
            TextSize = 12,
            Font = Enum.Font.Gotham,
            Parent = itemFrame
        })

        local label = Utility.Create("TextLabel", {
            Name = "Label",
            Size = UDim2.new(1, item.Children and -35 or -15, 1, 0),
            Position = UDim2.new(0, item.Children and 25 or 10, 0, 0),
            BackgroundTransparency = 1,
            Text = item.Name,
            TextColor3 = ThemeManager.GetColor("Text"),
            TextSize = 13,
            Font = Enum.Font.Gotham,
            TextXAlignment = Enum.TextXAlignment.Left,
            Parent = itemFrame
        })

        if item.Children and item.Expanded then
            for _, child in ipairs(item.Children) do
                createTreeItem(child, depth + 1)
            end
        end

        if expandButton then
            expandButton.MouseButton1Click:Connect(function()
                item.Expanded = not item.Expanded
                expandButton.Text = item.Expanded and "▼" or "▶"
            end)
        end

        table.insert(treeItems, itemFrame)
    end

    for _, item in ipairs(items) do
        createTreeItem(item, 0)
    end

    layout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        scrollFrame.CanvasSize = UDim2.new(0, 0, 0, layout.AbsoluteContentSize.Y)
    end)

    return {
        Frame = treeFrame,
        Refresh = function(newItems)
            for _, item in ipairs(treeItems) do
                item:Destroy()
            end
            treeItems = {}
            items = newItems
            for _, item in ipairs(items) do
                createTreeItem(item, 0)
            end
        end,
        Destroy = function()
            treeFrame:Destroy()
        end
    }
end

TagSystem.Create = function(parent, config)
    config = config or {}
    local text = config.Text or "Tag"
    local color = config.Color or ThemeManager.GetColor("Accent")
    local removable = config.Removable or false
    local onRemove = config.OnRemove or function() end

    local tagFrame = Utility.Create("Frame", {
        Name = "Tag_" .. Utility.GenerateUUID(),
        Size = UDim2.new(0, 0, 0, 25),
        BackgroundColor3 = color,
        BorderSizePixel = 0,
        AutomaticSize = Enum.AutomaticSize.X,
        Parent = parent
    })

    local corner = Utility.Create("UICorner", {
        CornerRadius = UDim.new(0, 12),
        Parent = tagFrame
    })

    local padding = Utility.Create("UIPadding", {
        PaddingLeft = UDim.new(0, 10),
        PaddingRight = UDim.new(0, removable and 25 or 10),
        Parent = tagFrame
    })

    local label = Utility.Create("TextLabel", {
        Name = "Text",
        Size = UDim2.new(0, 0, 1, 0),
        BackgroundTransparency = 1,
        Text = text,
        TextColor3 = Color3.fromRGB(255, 255, 255),
        TextSize = 12,
        Font = Enum.Font.GothamSemibold,
        AutomaticSize = Enum.AutomaticSize.X,
        Parent = tagFrame
    })

    if removable then
        local removeButton = Utility.Create("TextButton", {
            Name = "Remove",
            Size = UDim2.new(0, 20, 0, 20),
            Position = UDim2.new(1, -22, 0.5, -10),
            BackgroundTransparency = 1,
            Text = "×",
            TextColor3 = Color3.fromRGB(255, 255, 255),
            TextSize = 16,
            Font = Enum.Font.GothamBold,
            Parent = tagFrame
        })

        removeButton.MouseButton1Click:Connect(function()
            Animation.ScaleOut(tagFrame, 0.2)
            task.delay(0.2, function()
                tagFrame:Destroy()
                onRemove()
            end)
        end)
    end

    return {
        Frame = tagFrame,
        SetText = function(newText)
            label.Text = newText
        end,
        SetColor = function(newColor)
            Animation.Tween(tagFrame, {BackgroundColor3 = newColor}, 0.2)
        end,
        Destroy = function()
            tagFrame:Destroy()
        end
    }
end

BadgeSystem.Create = function(parent, config)
    config = config or {}
    local count = config.Count or 0
    local maxCount = config.MaxCount or 99
    local color = config.Color or ThemeManager.GetColor("Error")

    local badgeFrame = Utility.Create("Frame", {
        Name = "Badge_" .. Utility.GenerateUUID(),
        Size = UDim2.new(0, 0, 0, 18),
        Position = config.Position or UDim2.new(1, -10, 0, -5),
        BackgroundColor3 = color,
        BorderSizePixel = 0,
        AutomaticSize = Enum.AutomaticSize.X,
        Parent = parent
    })

    local corner = Utility.Create("UICorner", {
        CornerRadius = UDim.new(1, 0),
        Parent = badgeFrame
    })

    local padding = Utility.Create("UIPadding", {
        PaddingLeft = UDim.new(0, 6),
        PaddingRight = UDim.new(0, 6),
        Parent = badgeFrame
    })

    local label = Utility.Create("TextLabel", {
        Name = "Count",
        Size = UDim2.new(0, 0, 1, 0),
        BackgroundTransparency = 1,
        Text = count > maxCount and maxCount .. "+" or tostring(count),
        TextColor3 = Color3.fromRGB(255, 255, 255),
        TextSize = 11,
        Font = Enum.Font.GothamBold,
        AutomaticSize = Enum.AutomaticSize.X,
        Parent = badgeFrame
    })

    badgeFrame.Visible = count > 0

    return {
        Frame = badgeFrame,
        SetCount = function(newCount)
            count = newCount
            label.Text = count > maxCount and maxCount .. "+" or tostring(count)
            badgeFrame.Visible = count > 0
            if count > 0 then
                Animation.Bounce(badgeFrame, 0.3)
            end
        end,
        Increment = function()
            count = count + 1
            label.Text = count > maxCount and maxCount .. "+" or tostring(count)
            badgeFrame.Visible = true
            Animation.Bounce(badgeFrame, 0.3)
        end,
        Destroy = function()
            badgeFrame:Destroy()
        end
    }
end

GlassmorphismSystem.Create = function(parent, config)
    config = config or {}
    local blur = config.Blur or 20
    local opacity = config.Opacity or 0.7
    local tint = config.Tint or Color3.fromRGB(255, 255, 255)

    local glassFrame = Utility.Create("Frame", {
        Name = "Glass_" .. Utility.GenerateUUID(),
        Size = config.Size or UDim2.new(1, 0, 1, 0),
        Position = config.Position or UDim2.new(0, 0, 0, 0),
        BackgroundColor3 = tint,
        BackgroundTransparency = 1 - opacity,
        BorderSizePixel = 0,
        Parent = parent
    })

    local corner = Utility.Create("UICorner", {
        CornerRadius = config.CornerRadius or UDim.new(0, 12),
        Parent = glassFrame
    })

    local blurEffect = Utility.Create("ImageLabel", {
        Name = "Blur",
        Size = UDim2.new(1, 0, 1, 0),
        BackgroundTransparency = 1,
        Image = "rbxassetid://4483345998",
        ImageColor3 = tint,
        ImageTransparency = 0.5,
        ScaleType = Enum.ScaleType.Stretch,
        Parent = glassFrame
    })

    local stroke = Utility.Create("UIStroke", {
        Color = Color3.fromRGB(255, 255, 255),
        Thickness = 1,
        Transparency = 0.8,
        Parent = glassFrame
    })

    return {
        Frame = glassFrame,
        SetBlur = function(newBlur)
            blur = newBlur
        end,
        SetOpacity = function(newOpacity)
            opacity = newOpacity
            glassFrame.BackgroundTransparency = 1 - opacity
        end,
        Destroy = function()
            glassFrame:Destroy()
        end
    }
end

SkeletonSystem.Create = function(parent, config)
    config = config or {}
    local count = config.Count or 3
    local height = config.Height or 20
    local gap = config.Gap or 10

    local skeletonFrame = Utility.Create("Frame", {
        Name = "Skeleton_" .. Utility.GenerateUUID(),
        Size = UDim2.new(1, 0, 0, count * (height + gap)),
        BackgroundTransparency = 1,
        Parent = parent
    })

    local skeletons = {}

    for i = 1, count do
        local skeleton = Utility.Create("Frame", {
            Name = "Skeleton_" .. tostring(i),
            Size = UDim2.new(math.random(60, 100) / 100, 0, 0, height),
            Position = UDim2.new(0, 0, 0, (i - 1) * (height + gap)),
            BackgroundColor3 = ThemeManager.GetColor("BackgroundTertiary"),
            BorderSizePixel = 0,
            Parent = skeletonFrame
        })

        local corner = Utility.Create("UICorner", {
            CornerRadius = UDim.new(0, 4),
            Parent = skeleton
        })

        local gradient = Utility.Create("UIGradient", {
            Color = ColorSequence.new({
                ColorSequenceKeypoint.new(0, ThemeManager.GetColor("BackgroundTertiary")),
                ColorSequenceKeypoint.new(0.5, Utility.LerpColor(ThemeManager.GetColor("BackgroundTertiary"), Color3.fromRGB(255, 255, 255), 0.1)),
                ColorSequenceKeypoint.new(1, ThemeManager.GetColor("BackgroundTertiary"))
            }),
            Rotation = -45,
            Parent = skeleton
        })

        local offset = 0
        local connection = RunService.RenderStepped:Connect(function()
            offset = offset + 0.02
            if offset > 1 then offset = 0 end
            gradient.Offset = Vector2.new(offset, 0)
        end)

        table.insert(skeletons, {Frame = skeleton, Connection = connection})
    end

    return {
        Frame = skeletonFrame,
        Stop = function()
            for _, skel in ipairs(skeletons) do
                if skel.Connection then
                    skel.Connection:Disconnect()
                end
            end
        end,
        Destroy = function()
            for _, skel in ipairs(skeletons) do
                if skel.Connection then
                    skel.Connection:Disconnect()
                end
            end
            skeletonFrame:Destroy()
        end
    }
end

ShimmerSystem.Create = function(parent, config)
    config = config or {}
    local color = config.Color or ThemeManager.GetColor("BackgroundTertiary")
    local shimmerColor = config.ShimmerColor or Color3.fromRGB(255, 255, 255)

    local shimmerFrame = Utility.Create("Frame", {
        Name = "Shimmer_" .. Utility.GenerateUUID(),
        Size = config.Size or UDim2.new(1, 0, 0, 100),
        BackgroundColor3 = color,
        BorderSizePixel = 0,
        Parent = parent
    })

    local corner = Utility.Create("UICorner", {
        CornerRadius = UDim.new(0, 8),
        Parent = shimmerFrame
    })

    local shimmer = Utility.Create("Frame", {
        Name = "Shimmer",
        Size = UDim2.new(0.3, 0, 1, 0),
        Position = UDim2.new(-0.3, 0, 0, 0),
        BackgroundColor3 = shimmerColor,
        BackgroundTransparency = 0.8,
        BorderSizePixel = 0,
        Parent = shimmerFrame
    })

    local shimmerGradient = Utility.Create("UIGradient", {
        Transparency = NumberSequence.new({
            NumberSequenceKeypoint.new(0, 1),
            NumberSequenceKeypoint.new(0.5, 0.5),
            NumberSequenceKeypoint.new(1, 1)
        }),
        Parent = shimmer
    })

    local running = true
    local function animate()
        while running do
            Animation.Tween(shimmer, {Position = UDim2.new(1, 0, 0, 0)}, 1.5, Enum.EasingStyle.Quart)
            task.wait(1.5)
            shimmer.Position = UDim2.new(-0.3, 0, 0, 0)
            task.wait(0.5)
        end
    end

    task.spawn(animate)

    return {
        Frame = shimmerFrame,
        Stop = function()
            running = false
        end,
        Destroy = function()
            running = false
            shimmerFrame:Destroy()
        end
    }
end

RippleSystem.CreateRipple = function(parent, position, config)
    config = config or {}
    local color = config.Color or Color3.fromRGB(255, 255, 255)
    local duration = config.Duration or 0.6

    local ripple = Utility.Create("Frame", {
        Name = "Ripple",
        Size = UDim2.new(0, 0, 0, 0),
        Position = UDim2.new(0, position.X, 0, position.Y),
        AnchorPoint = Vector2.new(0.5, 0.5),
        BackgroundColor3 = color,
        BackgroundTransparency = 0.7,
        BorderSizePixel = 0,
        Parent = parent
    })

    local corner = Utility.Create("UICorner", {
        CornerRadius = UDim.new(1, 0),
        Parent = ripple
    })

    local maxSize = math.max(parent.AbsoluteSize.X, parent.AbsoluteSize.Y) * 2
    Animation.Tween(ripple, {
        Size = UDim2.new(0, maxSize, 0, maxSize),
        BackgroundTransparency = 1
    }, duration, nil, nil, function()
        ripple:Destroy()
    end)
end

ParticleSystem.Create = function(parent, config)
    config = config or {}
    local particleCount = config.ParticleCount or 20
    local colors = config.Colors or {ThemeManager.GetColor("Accent")}
    local speed = config.Speed or 1
    local size = config.Size or {Min = 2, Max = 6}

    local particleFrame = Utility.Create("Frame", {
        Name = "Particles_" .. Utility.GenerateUUID(),
        Size = UDim2.new(1, 0, 1, 0),
        BackgroundTransparency = 1,
        ClipsDescendants = true,
        Parent = parent
    })

    local particles = {}
    local running = true

    for i = 1, particleCount do
        local particle = Utility.Create("Frame", {
            Name = "Particle_" .. tostring(i),
            Size = UDim2.new(0, math.random(size.Min, size.Max), 0, math.random(size.Min, size.Max)),
            Position = UDim2.new(math.random(), 0, math.random(), 0),
            BackgroundColor3 = colors[math.random(1, #colors)],
            BackgroundTransparency = math.random() * 0.5 + 0.2,
            BorderSizePixel = 0,
            Parent = particleFrame
        })

        local corner = Utility.Create("UICorner", {
            CornerRadius = UDim.new(1, 0),
            Parent = particle
        })

        local velocity = Vector2.new(
            (math.random() - 0.5) * speed,
            (math.random() - 0.5) * speed
        )

        table.insert(particles, {
            Instance = particle,
            Velocity = velocity,
            Position = Vector2.new(particle.Position.X.Scale, particle.Position.Y.Scale)
        })
    end

    local connection = RunService.RenderStepped:Connect(function()
        if not running then return end

        for _, particle in ipairs(particles) do
            local pos = particle.Position
            local vel = particle.Velocity

            pos = pos + vel * 0.016

            if pos.X < 0 or pos.X > 1 then
                vel = Vector2.new(-vel.X, vel.Y)
            end
            if pos.Y < 0 or pos.Y > 1 then
                vel = Vector2.new(vel.X, -vel.Y)
            end

            pos = Vector2.new(
                math.clamp(pos.X, 0, 1),
                math.clamp(pos.Y, 0, 1)
            )

            particle.Position = pos
            particle.Velocity = vel
            particle.Instance.Position = UDim2.new(pos.X, 0, pos.Y, 0)
        end
    end)

    return {
        Frame = particleFrame,
        Stop = function()
            running = false
            connection:Disconnect()
        end,
        Destroy = function()
            running = false
            connection:Disconnect()
            particleFrame:Destroy()
        end
    }
end

AcrylicSystem.Create = function(parent, config)
    config = config or {}
    local noiseIntensity = config.NoiseIntensity or 0.5
    local tint = config.Tint or Color3.fromRGB(200, 200, 200)

    local acrylicFrame = Utility.Create("Frame", {
        Name = "Acrylic_" .. Utility.GenerateUUID(),
        Size = config.Size or UDim2.new(1, 0, 1, 0),
        Position = config.Position or UDim2.new(0, 0, 0, 0),
        BackgroundColor3 = tint,
        BackgroundTransparency = 0.3,
        BorderSizePixel = 0,
        Parent = parent
    })

    local corner = Utility.Create("UICorner", {
        CornerRadius = config.CornerRadius or UDim.new(0, 8),
        Parent = acrylicFrame
    })

    local noise = Utility.Create("ImageLabel", {
        Name = "Noise",
        Size = UDim2.new(1, 0, 1, 0),
        BackgroundTransparency = 1,
        Image = "rbxassetid://301464986",
        ImageColor3 = Color3.fromRGB(255, 255, 255),
        ImageTransparency = 1 - noiseIntensity,
        ScaleType = Enum.ScaleType.Tile,
        TileSize = UDim2.new(0, 50, 0, 50),
        Parent = acrylicFrame
    })

    local stroke = Utility.Create("UIStroke", {
        Color = Color3.fromRGB(255, 255, 255),
        Thickness = 0.5,
        Transparency = 0.7,
        Parent = acrylicFrame
    })

    return {
        Frame = acrylicFrame,
        SetTint = function(newTint)
            Animation.Tween(acrylicFrame, {BackgroundColor3 = newTint}, 0.3)
        end,
        Destroy = function()
            acrylicFrame:Destroy()
        end
    }
end

NeumorphismSystem.Create = function(parent, config)
    config = config or {}
    local size = config.Size or UDim2.new(0, 100, 0, 100)
    local position = config.Position or UDim2.new(0, 0, 0, 0)
    local color = config.Color or ThemeManager.GetColor("BackgroundSecondary")

    local neumorphicFrame = Utility.Create("Frame", {
        Name = "Neumorphic_" .. Utility.GenerateUUID(),
        Size = size,
        Position = position,
        BackgroundColor3 = color,
        BorderSizePixel = 0,
        Parent = parent
    })

    local corner = Utility.Create("UICorner", {
        CornerRadius = UDim.new(0, 20),
        Parent = neumorphicFrame
    })

    local lightShadow = Utility.Create("ImageLabel", {
        Name = "LightShadow",
        Size = UDim2.new(1, 10, 1, 10),
        Position = UDim2.new(0, -5, 0, -5),
        BackgroundTransparency = 1,
        Image = "rbxassetid://5554236805",
        ImageColor3 = Utility.LerpColor(color, Color3.fromRGB(255, 255, 255), 0.3),
        ImageTransparency = 0.7,
        ScaleType = Enum.ScaleType.Slice,
        SliceCenter = Rect.new(23, 23, 277, 277),
        ZIndex = -1,
        Parent = neumorphicFrame
    })

    local darkShadow = Utility.Create("ImageLabel", {
        Name = "DarkShadow",
        Size = UDim2.new(1, 10, 1, 10),
        Position = UDim2.new(0, 5, 0, 5),
        BackgroundTransparency = 1,
        Image = "rbxassetid://5554236805",
        ImageColor3 = Color3.fromRGB(0, 0, 0),
        ImageTransparency = 0.7,
        ScaleType = Enum.ScaleType.Slice,
        SliceCenter = Rect.new(23, 23, 277, 277),
        ZIndex = -2,
        Parent = neumorphicFrame
    })

    local isPressed = false

    neumorphicFrame.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            isPressed = true
            Animation.Tween(lightShadow, {Position = UDim2.new(0, 2, 0, 2)}, 0.2)
            Animation.Tween(darkShadow, {Position = UDim2.new(0, -2, 0, -2)}, 0.2)
        end
    end)

    neumorphicFrame.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            isPressed = false
            Animation.Tween(lightShadow, {Position = UDim2.new(0, -5, 0, -5)}, 0.2)
            Animation.Tween(darkShadow, {Position = UDim2.new(0, 5, 0, 5)}, 0.2)
        end
    end)

    return {
        Frame = neumorphicFrame,
        SetPressed = function(pressed)
            isPressed = pressed
            if pressed then
                lightShadow.Position = UDim2.new(0, 2, 0, 2)
                darkShadow.Position = UDim2.new(0, -2, 0, -2)
            else
                lightShadow.Position = UDim2.new(0, -5, 0, -5)
                darkShadow.Position = UDim2.new(0, 5, 0, 5)
            end
        end,
        Destroy = function()
            neumorphicFrame:Destroy()
        end
    }
end

CalendarSystem.Create = function(parent, config)
    config = config or {}
    local selectedDate = config.SelectedDate or os.date("*t")
    local onSelect = config.OnSelect or function() end

    local calendarFrame = Utility.Create("Frame", {
        Name = "Calendar_" .. Utility.GenerateUUID(),
        Size = UDim2.new(0, 280, 0, 320),
        BackgroundColor3 = ThemeManager.GetColor("BackgroundSecondary"),
        BorderSizePixel = 0,
        Parent = parent
    })

    local corner = Utility.Create("UICorner", {
        CornerRadius = UDim.new(0, 12),
        Parent = calendarFrame
    })

    local stroke = Utility.Create("UIStroke", {
        Color = ThemeManager.GetColor("Border"),
        Thickness = 1,
        Parent = calendarFrame
    })

    local header = Utility.Create("Frame", {
        Name = "Header",
        Size = UDim2.new(1, 0, 0, 50),
        BackgroundColor3 = ThemeManager.GetColor("BackgroundTertiary"),
        BorderSizePixel = 0,
        Parent = calendarFrame
    })

    local headerCorner = Utility.Create("UICorner", {
        CornerRadius = UDim.new(0, 12),
        Parent = header
    })

    local headerFix = Utility.Create("Frame", {
        Size = UDim2.new(1, 0, 0, 10),
        Position = UDim2.new(0, 0, 1, -10),
        BackgroundColor3 = ThemeManager.GetColor("BackgroundTertiary"),
        BorderSizePixel = 0,
        Parent = header
    })

    local prevButton = Utility.Create("TextButton", {
        Name = "Prev",
        Size = UDim2.new(0, 30, 0, 30),
        Position = UDim2.new(0, 10, 0.5, -15),
        BackgroundColor3 = ThemeManager.GetColor("BackgroundSecondary"),
        Text = "<",
        TextColor3 = ThemeManager.GetColor("Text"),
        TextSize = 16,
        Font = Enum.Font.GothamBold,
        Parent = header
    })

    local nextButton = Utility.Create("TextButton", {
        Name = "Next",
        Size = UDim2.new(0, 30, 0, 30),
        Position = UDim2.new(1, -40, 0.5, -15),
        BackgroundColor3 = ThemeManager.GetColor("BackgroundSecondary"),
        Text = ">",
        TextColor3 = ThemeManager.GetColor("Text"),
        TextSize = 16,
        Font = Enum.Font.GothamBold,
        Parent = header
    })

    local monthLabel = Utility.Create("TextLabel", {
        Name = "Month",
        Size = UDim2.new(1, -100, 1, 0),
        Position = UDim2.new(0, 50, 0, 0),
        BackgroundTransparency = 1,
        Text = os.date("%B %Y", os.time(selectedDate)),
        TextColor3 = ThemeManager.GetColor("Text"),
        TextSize = 16,
        Font = Enum.Font.GothamBold,
        Parent = header
    })

    local daysFrame = Utility.Create("Frame", {
        Name = "Days",
        Size = UDim2.new(1, -20, 0, 240),
        Position = UDim2.new(0, 10, 0, 60),
        BackgroundTransparency = 1,
        Parent = calendarFrame
    })

    local daysLayout = Utility.Create("UIGridLayout", {
        CellSize = UDim2.new(0, 35, 0, 30),
        CellPadding = UDim.new(0, 5),
        Parent = daysFrame
    })

    local weekDays = {"Su", "Mo", "Tu", "We", "Th", "Fr", "Sa"}
    for _, day in ipairs(weekDays) do
        local dayLabel = Utility.Create("TextLabel", {
            Size = UDim2.new(0, 35, 0, 25),
            BackgroundTransparency = 1,
            Text = day,
            TextColor3 = ThemeManager.GetColor("TextSecondary"),
            TextSize = 12,
            Font = Enum.Font.GothamBold,
            Parent = daysFrame
        })
    end

    local currentMonth = selectedDate.month
    local currentYear = selectedDate.year
    local dayButtons = {}

    local function renderCalendar()
        for _, btn in ipairs(dayButtons) do
            btn:Destroy()
        end
        dayButtons = {}

        local firstDay = os.time({year = currentYear, month = currentMonth, day = 1})
        local startWeekDay = tonumber(os.date("%w", firstDay))
        local daysInMonth = tonumber(os.date("%d", os.time({year = currentYear, month = currentMonth + 1, day = 0})))

        for i = 1, startWeekDay do
            local empty = Utility.Create("Frame", {
                Size = UDim2.new(0, 35, 0, 30),
                BackgroundTransparency = 1,
                Parent = daysFrame
            })
            table.insert(dayButtons, empty)
        end

        for day = 1, daysInMonth do
            local dayButton = Utility.Create("TextButton", {
                Size = UDim2.new(0, 35, 0, 30),
                BackgroundColor3 = (day == selectedDate.day and currentMonth == selectedDate.month and currentYear == selectedDate.year) 
                    and ThemeManager.GetColor("Accent") 
                    or ThemeManager.GetColor("BackgroundTertiary"),
                Text = tostring(day),
                TextColor3 = (day == selectedDate.day and currentMonth == selectedDate.month and currentYear == selectedDate.year) 
                    and Color3.fromRGB(255, 255, 255) 
                    or ThemeManager.GetColor("Text"),
                TextSize = 13,
                Font = Enum.Font.Gotham,
                Parent = daysFrame
            })

            local dayCorner = Utility.Create("UICorner", {
                CornerRadius = UDim.new(0, 6),
                Parent = dayButton
            })

            dayButton.MouseEnter:Connect(function()
                if day ~= selectedDate.day or currentMonth ~= selectedDate.month or currentYear ~= selectedDate.year then
                    Animation.Tween(dayButton, {BackgroundColor3 = Utility.LerpColor(ThemeManager.GetColor("BackgroundTertiary"), ThemeManager.GetColor("Accent"), 0.3)}, 0.15)
                end
            end)

            dayButton.MouseLeave:Connect(function()
                if day ~= selectedDate.day or currentMonth ~= selectedDate.month or currentYear ~= selectedDate.year then
                    Animation.Tween(dayButton, {BackgroundColor3 = ThemeManager.GetColor("BackgroundTertiary")}, 0.15)
                end
            end)

            dayButton.MouseButton1Click:Connect(function()
                selectedDate = {year = currentYear, month = currentMonth, day = day}
                onSelect(selectedDate)
                renderCalendar()
            end)

            table.insert(dayButtons, dayButton)
        end

        monthLabel.Text = os.date("%B %Y", os.time({year = currentYear, month = currentMonth, day = 1}))
    end

    prevButton.MouseButton1Click:Connect(function()
        currentMonth = currentMonth - 1
        if currentMonth < 1 then
            currentMonth = 12
            currentYear = currentYear - 1
        end
        renderCalendar()
    end)

    nextButton.MouseButton1Click:Connect(function()
        currentMonth = currentMonth + 1
        if currentMonth > 12 then
            currentMonth = 1
            currentYear = currentYear + 1
        end
        renderCalendar()
    end)

    renderCalendar()

    return {
        Frame = calendarFrame,
        GetSelectedDate = function()
            return selectedDate
        end,
        SetDate = function(date)
            selectedDate = date
            currentMonth = date.month
            currentYear = date.year
            renderCalendar()
        end,
        Destroy = function()
            calendarFrame:Destroy()
        end
    }
end

AdvancedUI.CreateWindow = WindowManager.Create
AdvancedUI.CreateButton = ButtonSystem.Create
AdvancedUI.CreateToggle = ToggleSystem.Create
AdvancedUI.CreateSlider = SliderSystem.Create
AdvancedUI.CreateInput = InputSystem.Create
AdvancedUI.CreateKeybind = KeybindSystem.Create
AdvancedUI.CreateDropdown = DropdownSystem.Create
AdvancedUI.CreateColorPicker = ColorPickerSystem.Create
AdvancedUI.CreateLabel = LabelSystem.Create
AdvancedUI.CreateDivider = DividerSystem.Create
AdvancedUI.CreateProgressBar = ProgressBarSystem.Create
AdvancedUI.CreateSearch = SearchSystem.Create
AdvancedUI.CreateTab = TabSystem.Create
AdvancedUI.CreateSection = SectionSystem.Create
AdvancedUI.CreateSpinner = SpinnerSystem.Create
AdvancedUI.CreateTooltip = TooltipSystem.Create
AdvancedUI.CreateContextMenu = ContextMenuSystem.Create
AdvancedUI.CreateModal = ModalSystem.Create
AdvancedUI.CreateScroll = ScrollSystem.Create
AdvancedUI.CreateGrid = GridSystem.Create
AdvancedUI.CreateTreeView = TreeViewSystem.Create
AdvancedUI.CreateTag = TagSystem.Create
AdvancedUI.CreateBadge = BadgeSystem.Create
AdvancedUI.CreateGlassmorphism = GlassmorphismSystem.Create
AdvancedUI.CreateSkeleton = SkeletonSystem.Create
AdvancedUI.CreateShimmer = ShimmerSystem.Create
AdvancedUI.CreateParticle = ParticleSystem.Create
AdvancedUI.CreateAcrylic = AcrylicSystem.Create
AdvancedUI.CreateNeumorphism = NeumorphismSystem.Create
AdvancedUI.CreateCalendar = CalendarSystem.Create
AdvancedUI.CreateWatermark = WatermarkSystem.Create
AdvancedUI.CreateNotification = NotificationSystem.Create
AdvancedUI.Notify = NotificationSystem.Create
AdvancedUI.Alert = ModalSystem.Alert
AdvancedUI.Confirm = ModalSystem.Confirm
AdvancedUI.SetTheme = ThemeManager.SetTheme
AdvancedUI.GetTheme = ThemeManager.GetTheme
AdvancedUI.Tween = Animation.Tween
AdvancedUI.FadeIn = Animation.FadeIn
AdvancedUI.FadeOut = Animation.FadeOut
AdvancedUI.Shake = Animation.Shake
AdvancedUI.GenerateUUID = Utility.GenerateUUID
AdvancedUI.Lerp = Utility.Lerp
AdvancedUI.LerpColor = Utility.LerpColor
AdvancedUI.RGBtoHSV = Utility.RGBtoHSV
AdvancedUI.HSVtoRGB = Utility.HSVtoRGB

ChartSystem.Create = function(parent, config)
    config = config or {}
    local chartType = config.Type or "Line"
    local data = config.Data or {}
    local labels = config.Labels or {}
    local colors = config.Colors or {ThemeManager.GetColor("Accent")}

    local chartFrame = Utility.Create("Frame", {
        Name = "Chart_" .. Utility.GenerateUUID(),
        Size = config.Size or UDim2.new(1, 0, 0, 200),
        BackgroundColor3 = ThemeManager.GetColor("BackgroundSecondary"),
        BorderSizePixel = 0,
        Parent = parent
    })

    local corner = Utility.Create("UICorner", {
        CornerRadius = UDim.new(0, 8),
        Parent = chartFrame
    })

    local stroke = Utility.Create("UIStroke", {
        Color = ThemeManager.GetColor("Border"),
        Thickness = 1,
        Parent = chartFrame
    })

    local plotArea = Utility.Create("Frame", {
        Name = "Plot",
        Size = UDim2.new(1, -40, 1, -50),
        Position = UDim2.new(0, 20, 0, 30),
        BackgroundColor3 = ThemeManager.GetColor("Background"),
        BorderSizePixel = 0,
        Parent = chartFrame
    })

    local plotCorner = Utility.Create("UICorner", {
        CornerRadius = UDim.new(0, 6),
        Parent = plotArea
    })

    local titleLabel = Utility.Create("TextLabel", {
        Name = "Title",
        Size = UDim2.new(1, -20, 0, 25),
        Position = UDim2.new(0, 10, 0, 5),
        BackgroundTransparency = 1,
        Text = config.Title or "Chart",
        TextColor3 = ThemeManager.GetColor("Text"),
        TextSize = 14,
        Font = Enum.Font.GothamBold,
        TextXAlignment = Enum.TextXAlignment.Left,
        Parent = chartFrame
    })

    if chartType == "Line" then
        local maxValue = 0
        for _, v in ipairs(data) do
            if v > maxValue then maxValue = v end
        end
        maxValue = math.max(maxValue * 1.1, 1)

        local points = {}
        for i, value in ipairs(data) do
            local x = (i - 1) / (#data - 1)
            local y = 1 - (value / maxValue)
            table.insert(points, UDim2.new(x, 0, y, 0))
        end

        for i = 1, #points - 1 do
            local line = Utility.Create("Frame", {
                Name = "Line_" .. tostring(i),
                Size = UDim2.new(0, 2, (points[i + 1].Y.Scale - points[i].Y.Scale), 0),
                Position = points[i],
                BackgroundColor3 = colors[1],
                BorderSizePixel = 0,
                Parent = plotArea
            })
        end

        for i, point in ipairs(points) do
            local dot = Utility.Create("Frame", {
                Name = "Dot_" .. tostring(i),
                Size = UDim2.new(0, 8, 0, 8),
                Position = point,
                AnchorPoint = Vector2.new(0.5, 0.5),
                BackgroundColor3 = colors[1],
                BorderSizePixel = 0,
                Parent = plotArea
            })

            local dotCorner = Utility.Create("UICorner", {
                CornerRadius = UDim.new(1, 0),
                Parent = dot
            })
        end
    elseif chartType == "Bar" then
        local maxValue = 0
        for _, v in ipairs(data) do
            if v > maxValue then maxValue = v end
        end
        maxValue = math.max(maxValue * 1.1, 1)

        local barWidth = 1 / #data * 0.8
        for i, value in ipairs(data) do
            local bar = Utility.Create("Frame", {
                Name = "Bar_" .. tostring(i),
                Size = UDim2.new(barWidth, 0, value / maxValue, 0),
                Position = UDim2.new((i - 1) / #data + 0.1, 0, 1 - value / maxValue, 0),
                BackgroundColor3 = colors[(i - 1) % #colors + 1],
                BorderSizePixel = 0,
                Parent = plotArea
            })

            local barCorner = Utility.Create("UICorner", {
                CornerRadius = UDim.new(0, 4),
                Parent = bar
            })

            Animation.Tween(bar, {Size = UDim2.new(barWidth, 0, value / maxValue, 0)}, 0.5 + i * 0.1, Enum.EasingStyle.Back)
        end
    elseif chartType == "Pie" then
        local total = 0
        for _, v in ipairs(data) do
            total = total + v
        end

        local startAngle = 0
        local center = UDim2.new(0.5, 0, 0.5, 0)
        local radius = 0.4

        for i, value in ipairs(data) do
            local angle = (value / total) * 360
            local slice = Utility.Create("Frame", {
                Name = "Slice_" .. tostring(i),
                Size = UDim2.new(radius * 2, 0, radius * 2, 0),
                Position = center,
                AnchorPoint = Vector2.new(0.5, 0.5),
                BackgroundColor3 = colors[(i - 1) % #colors + 1],
                BorderSizePixel = 0,
                Rotation = startAngle,
                Parent = plotArea
            })

            local sliceCorner = Utility.Create("UICorner", {
                CornerRadius = UDim.new(1, 0),
                Parent = slice
            })

            startAngle = startAngle + angle
        end
    end

    return {
        Frame = chartFrame,
        UpdateData = function(newData)
            data = newData
            for _, child in ipairs(plotArea:GetChildren()) do
                if child:IsA("Frame") then
                    child:Destroy()
                end
            end
        end,
        Destroy = function()
            chartFrame:Destroy()
        end
    }
end

AvatarSystem.Create = function(parent, config)
    config = config or {}
    local userId = config.UserId or LocalPlayer.UserId
    local size = config.Size or 100
    local showStatus = config.ShowStatus or false
    local status = config.Status or "Online"

    local avatarFrame = Utility.Create("Frame", {
        Name = "Avatar_" .. Utility.GenerateUUID(),
        Size = UDim2.new(0, size, 0, size),
        BackgroundColor3 = ThemeManager.GetColor("BackgroundTertiary"),
        BorderSizePixel = 0,
        Parent = parent
    })

    local corner = Utility.Create("UICorner", {
        CornerRadius = UDim.new(1, 0),
        Parent = avatarFrame
    })

    local stroke = Utility.Create("UIStroke", {
        Color = ThemeManager.GetColor("Border"),
        Thickness = 2,
        Parent = avatarFrame
    })

    local image = Utility.Create("ImageLabel", {
        Name = "Image",
        Size = UDim2.new(1, 0, 1, 0),
        BackgroundTransparency = 1,
        Image = "rbxthumb://type=AvatarHeadShot&id=" .. userId .. "&w=150&h=150",
        Parent = avatarFrame
    })

    local imageCorner = Utility.Create("UICorner", {
        CornerRadius = UDim.new(1, 0),
        Parent = image
    })

    if showStatus then
        local statusColors = {
            Online = Color3.fromRGB(0, 255, 100),
            Away = Color3.fromRGB(255, 200, 0),
            Busy = Color3.fromRGB(255, 50, 50),
            Offline = Color3.fromRGB(150, 150, 150)
        }

        local statusIndicator = Utility.Create("Frame", {
            Name = "Status",
            Size = UDim2.new(0, size * 0.25, 0, size * 0.25),
            Position = UDim2.new(1, -size * 0.2, 1, -size * 0.2),
            BackgroundColor3 = statusColors[status] or statusColors.Online,
            BorderSizePixel = 0,
            Parent = avatarFrame
        })

        local statusCorner = Utility.Create("UICorner", {
            CornerRadius = UDim.new(1, 0),
            Parent = statusIndicator
        })

        local statusStroke = Utility.Create("UIStroke", {
            Color = ThemeManager.GetColor("Background"),
            Thickness = 2,
            Parent = statusIndicator
        })
    end

    return {
        Frame = avatarFrame,
        SetUser = function(newUserId)
            userId = newUserId
            image.Image = "rbxthumb://type=AvatarHeadShot&id=" .. userId .. "&w=150&h=150"
        end,
        SetStatus = function(newStatus)
            status = newStatus
            local statusIndicator = avatarFrame:FindFirstChild("Status")
            if statusIndicator then
                local statusColors = {
                    Online = Color3.fromRGB(0, 255, 100),
                    Away = Color3.fromRGB(255, 200, 0),
                    Busy = Color3.fromRGB(255, 50, 50),
                    Offline = Color3.fromRGB(150, 150, 150)
                }
                Animation.Tween(statusIndicator, {BackgroundColor3 = statusColors[newStatus] or statusColors.Online}, 0.3)
            end
        end,
        Destroy = function()
            avatarFrame:Destroy()
        end
    }
end

MultiSelectSystem.Create = function(parent, config)
    config = config or {}
    local options = config.Options or {}
    local selected = config.Selected or {}
    local maxSelection = config.MaxSelection or nil
    local callback = config.Callback or function() end

    local multiFrame = Utility.Create("Frame", {
        Name = "MultiSelect_" .. Utility.GenerateUUID(),
        Size = UDim2.new(1, 0, 0, 150),
        BackgroundColor3 = ThemeManager.GetColor("BackgroundSecondary"),
        BorderSizePixel = 0,
        Parent = parent
    })

    local corner = Utility.Create("UICorner", {
        CornerRadius = UDim.new(0, 8),
        Parent = multiFrame
    })

    local scrollFrame = Utility.Create("ScrollingFrame", {
        Name = "Scroll",
        Size = UDim2.new(1, -10, 1, -10),
        Position = UDim2.new(0, 5, 0, 5),
        BackgroundTransparency = 1,
        ScrollBarThickness = 4,
        ScrollBarImageColor3 = ThemeManager.GetColor("Accent"),
        CanvasSize = UDim2.new(0, 0, 0, 0),
        Parent = multiFrame
    })

    local layout = Utility.Create("UIListLayout", {
        Padding = UDim.new(0, 5),
        Parent = scrollFrame
    })

    local checkboxes = {}

    for _, option in ipairs(options) do
        local isSelected = table.find(selected, option) ~= nil

        local optionFrame = Utility.Create("Frame", {
            Name = "Option_" .. option,
            Size = UDim2.new(1, 0, 0, 30),
            BackgroundColor3 = isSelected and Utility.LerpColor(ThemeManager.GetColor("BackgroundTertiary"), ThemeManager.GetColor("Accent"), 0.3) or ThemeManager.GetColor("BackgroundTertiary"),
            BorderSizePixel = 0,
            Parent = scrollFrame
        })

        local optionCorner = Utility.Create("UICorner", {
            CornerRadius = UDim.new(0, 4),
            Parent = optionFrame
        })

        local checkbox = Utility.Create("Frame", {
            Name = "Checkbox",
            Size = UDim2.new(0, 18, 0, 18),
            Position = UDim2.new(0, 8, 0.5, -9),
            BackgroundColor3 = isSelected and ThemeManager.GetColor("Accent") or ThemeManager.GetColor("Background"),
            BorderSizePixel = 0,
            Parent = optionFrame
        })

        local checkboxCorner = Utility.Create("UICorner", {
            CornerRadius = UDim.new(0, 4),
            Parent = checkbox
        })

        local checkmark = Utility.Create("ImageLabel", {
            Name = "Checkmark",
            Size = UDim2.new(0.7, 0, 0.7, 0),
            Position = UDim2.new(0.15, 0, 0.15, 0),
            BackgroundTransparency = 1,
            Image = "rbxassetid://3926305904",
            ImageRectOffset = Vector2.new(312, 4),
            ImageRectSize = Vector2.new(24, 24),
            ImageColor3 = Color3.fromRGB(255, 255, 255),
            ImageTransparency = isSelected and 0 or 1,
            Parent = checkbox
        })

        local label = Utility.Create("TextLabel", {
            Name = "Label",
            Size = UDim2.new(1, -40, 1, 0),
            Position = UDim2.new(0, 35, 0, 0),
            BackgroundTransparency = 1,
            Text = option,
            TextColor3 = ThemeManager.GetColor("Text"),
            TextSize = 13,
            Font = Enum.Font.Gotham,
            TextXAlignment = Enum.TextXAlignment.Left,
            Parent = optionFrame
        })

        optionFrame.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 then
                local index = table.find(selected, option)
                if index then
                    table.remove(selected, index)
                    Animation.Tween(optionFrame, {BackgroundColor3 = ThemeManager.GetColor("BackgroundTertiary")}, 0.2)
                    Animation.Tween(checkbox, {BackgroundColor3 = ThemeManager.GetColor("Background")}, 0.2)
                    Animation.Tween(checkmark, {ImageTransparency = 1}, 0.2)
                else
                    if not maxSelection or #selected < maxSelection then
                        table.insert(selected, option)
                        Animation.Tween(optionFrame, {BackgroundColor3 = Utility.LerpColor(ThemeManager.GetColor("BackgroundTertiary"), ThemeManager.GetColor("Accent"), 0.3)}, 0.2)
                        Animation.Tween(checkbox, {BackgroundColor3 = ThemeManager.GetColor("Accent")}, 0.2)
                        Animation.Tween(checkmark, {ImageTransparency = 0}, 0.2)
                    end
                end
                callback(selected)
            end
        end)

        table.insert(checkboxes, optionFrame)
    end

    layout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        scrollFrame.CanvasSize = UDim2.new(0, 0, 0, layout.AbsoluteContentSize.Y)
    end)

    return {
        Frame = multiFrame,
        GetSelected = function()
            return selected
        end,
        SetSelected = function(newSelected)
            selected = newSelected
            for i, optionFrame in ipairs(checkboxes) do
                local isSelected = table.find(selected, options[i]) ~= nil
                local checkbox = optionFrame:FindFirstChild("Checkbox")
                local checkmark = checkbox and checkbox:FindFirstChild("Checkmark")

                Animation.Tween(optionFrame, {BackgroundColor3 = isSelected and Utility.LerpColor(ThemeManager.GetColor("BackgroundTertiary"), ThemeManager.GetColor("Accent"), 0.3) or ThemeManager.GetColor("BackgroundTertiary")}, 0.2)
                if checkbox then
                    Animation.Tween(checkbox, {BackgroundColor3 = isSelected and ThemeManager.GetColor("Accent") or ThemeManager.GetColor("Background")}, 0.2)
                end
                if checkmark then
                    Animation.Tween(checkmark, {ImageTransparency = isSelected and 0 or 1}, 0.2)
                end
            end
            callback(selected)
        end,
        Destroy = function()
            multiFrame:Destroy()
        end
    }
end

TimePickerSystem.Create = function(parent, config)
    config = config or {}
    local defaultHour = config.Hour or 12
    local defaultMinute = config.Minute or 0
    local use24Hour = config.Use24Hour or false
    local callback = config.Callback or function() end

    local timeFrame = Utility.Create("Frame", {
        Name = "TimePicker_" .. Utility.GenerateUUID(),
        Size = UDim2.new(0, 250, 0, 80),
        BackgroundColor3 = ThemeManager.GetColor("BackgroundSecondary"),
        BorderSizePixel = 0,
        Parent = parent
    })

    local corner = Utility.Create("UICorner", {
        CornerRadius = UDim.new(0, 8),
        Parent = timeFrame
    })

    local hour = defaultHour
    local minute = defaultMinute

    local hourBox = Utility.Create("TextBox", {
        Name = "Hour",
        Size = UDim2.new(0, 60, 0, 50),
        Position = UDim2.new(0, 20, 0.5, -25),
        BackgroundColor3 = ThemeManager.GetColor("BackgroundTertiary"),
        Text = string.format("%02d", hour),
        TextColor3 = ThemeManager.GetColor("Text"),
        TextSize = 24,
        Font = Enum.Font.GothamBold,
        Parent = timeFrame
    })

    local separator = Utility.Create("TextLabel", {
        Name = "Separator",
        Size = UDim2.new(0, 20, 0, 50),
        Position = UDim2.new(0, 85, 0.5, -25),
        BackgroundTransparency = 1,
        Text = ":",
        TextColor3 = ThemeManager.GetColor("Text"),
        TextSize = 24,
        Font = Enum.Font.GothamBold,
        Parent = timeFrame
    })

    local minuteBox = Utility.Create("TextBox", {
        Name = "Minute",
        Size = UDim2.new(0, 60, 0, 50),
        Position = UDim2.new(0, 110, 0.5, -25),
        BackgroundColor3 = ThemeManager.GetColor("BackgroundTertiary"),
        Text = string.format("%02d", minute),
        TextColor3 = ThemeManager.GetColor("Text"),
        TextSize = 24,
        Font = Enum.Font.GothamBold,
        Parent = timeFrame
    })

    for _, box in ipairs({hourBox, minuteBox}) do
        local boxCorner = Utility.Create("UICorner", {
            CornerRadius = UDim.new(0, 6),
            Parent = box
        })
    end

    if not use24Hour then
        local ampmButton = Utility.Create("TextButton", {
            Name = "AMPM",
            Size = UDim2.new(0, 50, 0, 30),
            Position = UDim2.new(0, 180, 0.5, -15),
            BackgroundColor3 = ThemeManager.GetColor("Accent"),
            Text = hour >= 12 and "PM" or "AM",
            TextColor3 = Color3.fromRGB(255, 255, 255),
            TextSize = 14,
            Font = Enum.Font.GothamBold,
            Parent = timeFrame
        })

        local ampmCorner = Utility.Create("UICorner", {
            CornerRadius = UDim.new(0, 6),
            Parent = ampmButton
        })

        ampmButton.MouseButton1Click:Connect(function()
            if hour >= 12 then
                hour = hour - 12
                ampmButton.Text = "AM"
            else
                hour = hour + 12
                ampmButton.Text = "PM"
            end
            callback(hour, minute)
        end)
    end

    local function validateTime()
        local h = tonumber(hourBox.Text) or 0
        local m = tonumber(minuteBox.Text) or 0

        if use24Hour then
            h = math.clamp(h, 0, 23)
        else
            h = math.clamp(h, 1, 12)
        end
        m = math.clamp(m, 0, 59)

        hour = h
        minute = m

        hourBox.Text = string.format("%02d", hour)
        minuteBox.Text = string.format("%02d", minute)

        callback(hour, minute)
    end

    hourBox.FocusLost:Connect(validateTime)
    minuteBox.FocusLost:Connect(validateTime)

    return {
        Frame = timeFrame,
        GetTime = function()
            return hour, minute
        end,
        SetTime = function(h, m)
            hour = math.clamp(h, 0, 23)
            minute = math.clamp(m, 0, 59)
            hourBox.Text = string.format("%02d", hour)
            minuteBox.Text = string.format("%02d", minute)
        end,
        Destroy = function()
            timeFrame:Destroy()
        end
    }
end

RichTextSystem.Create = function(parent, config)
    config = config or {}
    local text = config.Text or ""
    local size = config.Size or UDim2.new(1, 0, 0, 100)

    local richFrame = Utility.Create("Frame", {
        Name = "RichText_" .. Utility.GenerateUUID(),
        Size = size,
        BackgroundColor3 = ThemeManager.GetColor("BackgroundSecondary"),
        BorderSizePixel = 0,
        Parent = parent
    })

    local corner = Utility.Create("UICorner", {
        CornerRadius = UDim.new(0, 8),
        Parent = richFrame
    })

    local scrollFrame = Utility.Create("ScrollingFrame", {
        Name = "Scroll",
        Size = UDim2.new(1, -20, 1, -20),
        Position = UDim2.new(0, 10, 0, 10),
        BackgroundTransparency = 1,
        ScrollBarThickness = 4,
        CanvasSize = UDim2.new(0, 0, 0, 0),
        Parent = richFrame
    })

    local label = Utility.Create("TextLabel", {
        Name = "Content",
        Size = UDim2.new(1, 0, 0, 0),
        BackgroundTransparency = 1,
        Text = text,
        TextColor3 = ThemeManager.GetColor("Text"),
        TextSize = 14,
        Font = Enum.Font.Gotham,
        TextWrapped = true,
        TextXAlignment = Enum.TextXAlignment.Left,
        TextYAlignment = Enum.TextYAlignment.Top,
        AutomaticSize = Enum.AutomaticSize.Y,
        RichText = true,
        Parent = scrollFrame
    })

    label:GetPropertyChangedSignal("AbsoluteSize"):Connect(function()
        scrollFrame.CanvasSize = UDim2.new(0, 0, 0, label.AbsoluteSize.Y + 20)
    end)

    return {
        Frame = richFrame,
        SetText = function(newText)
            label.Text = newText
        end,
        Append = function(moreText)
            label.Text = label.Text .. moreText
        end,
        Clear = function()
            label.Text = ""
        end,
        Destroy = function()
            richFrame:Destroy()
        end
    }
end


-- Additional AdvancedUI Functions
AdvancedUI.CreateGradientText = function(parent, config)
    config = config or {}
    local text = config.Text or "Gradient Text"
    local colors = config.Colors or {Color3.fromRGB(255, 0, 0), Color3.fromRGB(0, 0, 255)}
    local size = config.Size or 18

    local textFrame = Utility.Create("Frame", {
        Name = "GradientText_" .. Utility.GenerateUUID(),
        Size = UDim2.new(1, 0, 0, size + 10),
        BackgroundTransparency = 1,
        Parent = parent
    })

    local label = Utility.Create("TextLabel", {
        Size = UDim2.new(1, 0, 1, 0),
        BackgroundTransparency = 1,
        Text = text,
        TextSize = size,
        Font = Enum.Font.GothamBold,
        TextXAlignment = config.Alignment or Enum.TextXAlignment.Center,
        Parent = textFrame
    })

    local gradient = Utility.Create("UIGradient", {
        Color = ColorSequence.new(colors),
        Rotation = config.Rotation or 0,
        Parent = label
    })

    if config.Animated then
        local rotation = 0
        local connection
        connection = RunService.RenderStepped:Connect(function()
            rotation = rotation + 1
            gradient.Rotation = rotation
        end)

        return {
            Frame = textFrame,
            StopAnimation = function()
                if connection then
                    connection:Disconnect()
                end
            end,
            Destroy = function()
                if connection then
                    connection:Disconnect()
                end
                textFrame:Destroy()
            end
        }
    end

    return {
        Frame = textFrame,
        SetText = function(newText)
            label.Text = newText
        end,
        Destroy = function()
            textFrame:Destroy()
        end
    }
end

AdvancedUI.CreateTypingEffect = function(parent, config)
    config = config or {}
    local text = config.Text or ""
    local speed = config.Speed or 0.05
    local callback = config.OnComplete or function() end

    local typeFrame = Utility.Create("Frame", {
        Name = "Typing_" .. Utility.GenerateUUID(),
        Size = UDim2.new(1, 0, 0, 30),
        BackgroundTransparency = 1,
        Parent = parent
    })

    local label = Utility.Create("TextLabel", {
        Size = UDim2.new(1, 0, 1, 0),
        BackgroundTransparency = 1,
        Text = "",
        TextColor3 = ThemeManager.GetColor("Text"),
        TextSize = 14,
        Font = Enum.Font.Gotham,
        TextXAlignment = Enum.TextXAlignment.Left,
        Parent = typeFrame
    })

    local cursor = Utility.Create("Frame", {
        Name = "Cursor",
        Size = UDim2.new(0, 2, 0, 16),
        BackgroundColor3 = ThemeManager.GetColor("Accent"),
        BorderSizePixel = 0,
        Parent = label
    })

    local cursorBlink = true
    task.spawn(function()
        while typeFrame and typeFrame.Parent do
            cursor.BackgroundTransparency = cursorBlink and 0 or 1
            cursorBlink = not cursorBlink
            task.wait(0.5)
        end
    end)

    local currentIndex = 0
    local function typeNext()
        if currentIndex < #text then
            currentIndex = currentIndex + 1
            label.Text = string.sub(text, 1, currentIndex)
            task.delay(speed, typeNext)
        else
            callback()
        end
    end

    typeNext()

    return {
        Frame = typeFrame,
        Skip = function()
            currentIndex = #text
            label.Text = text
        end,
        Destroy = function()
            typeFrame:Destroy()
        end
    }
end

AdvancedUI.CreateCountUp = function(parent, config)
    config = config or {}
    local start = config.Start or 0
    local finish = config.Finish or 100
    local duration = config.Duration or 2
    local prefix = config.Prefix or ""
    local suffix = config.Suffix or ""

    local countFrame = Utility.Create("Frame", {
        Name = "CountUp_" .. Utility.GenerateUUID(),
        Size = UDim2.new(1, 0, 0, 40),
        BackgroundTransparency = 1,
        Parent = parent
    })

    local label = Utility.Create("TextLabel", {
        Size = UDim2.new(1, 0, 1, 0),
        BackgroundTransparency = 1,
        Text = prefix .. tostring(start) .. suffix,
        TextColor3 = ThemeManager.GetColor("Text"),
        TextSize = 24,
        Font = Enum.Font.GothamBold,
        Parent = countFrame
    })

    local startTime = tick()
    local connection
    connection = RunService.RenderStepped:Connect(function()
        local elapsed = tick() - startTime
        local progress = math.min(elapsed / duration, 1)
        local easeProgress = 1 - math.pow(1 - progress, 3)
        local current = start + (finish - start) * easeProgress

        label.Text = prefix .. string.format("%.0f", current) .. suffix

        if progress >= 1 then
            connection:Disconnect()
        end
    end)

    return {
        Frame = countFrame,
        Stop = function()
            if connection then
                connection:Disconnect()
            end
        end,
        Destroy = function()
            if connection then
                connection:Disconnect()
            end
            countFrame:Destroy()
        end
    }
end

AdvancedUI.CreateFlipCard = function(parent, config)
    config = config or {}
    local frontContent = config.Front or "Front"
    local backContent = config.Back or "Back"
    local size = config.Size or UDim2.new(0, 200, 0, 300)

    local cardFrame = Utility.Create("Frame", {
        Name = "FlipCard_" .. Utility.GenerateUUID(),
        Size = size,
        BackgroundTransparency = 1,
        Parent = parent
    })

    local frontFrame = Utility.Create("Frame", {
        Name = "Front",
        Size = UDim2.new(1, 0, 1, 0),
        BackgroundColor3 = ThemeManager.GetColor("BackgroundSecondary"),
        BorderSizePixel = 0,
        Parent = cardFrame
    })

    local frontCorner = Utility.Create("UICorner", {
        CornerRadius = UDim.new(0, 12),
        Parent = frontFrame
    })

    local frontLabel = Utility.Create("TextLabel", {
        Size = UDim2.new(1, 0, 1, 0),
        BackgroundTransparency = 1,
        Text = frontContent,
        TextColor3 = ThemeManager.GetColor("Text"),
        TextSize = 18,
        Font = Enum.Font.GothamBold,
        Parent = frontFrame
    })

    local backFrame = Utility.Create("Frame", {
        Name = "Back",
        Size = UDim2.new(1, 0, 1, 0),
        BackgroundColor3 = ThemeManager.GetColor("Accent"),
        BorderSizePixel = 0,
        Visible = false,
        Parent = cardFrame
    })

    local backCorner = Utility.Create("UICorner", {
        CornerRadius = UDim.new(0, 12),
        Parent = backFrame
    })

    local backLabel = Utility.Create("TextLabel", {
        Size = UDim2.new(1, 0, 1, 0),
        BackgroundTransparency = 1,
        Text = backContent,
        TextColor3 = Color3.fromRGB(255, 255, 255),
        TextSize = 18,
        Font = Enum.Font.GothamBold,
        Parent = backFrame
    })

    local isFlipped = false

    cardFrame.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            isFlipped = not isFlipped

            Animation.Tween(cardFrame, {Rotation = 90}, 0.2, nil, nil, function()
                frontFrame.Visible = not isFlipped
                backFrame.Visible = isFlipped
                cardFrame.Rotation = -90
                Animation.Tween(cardFrame, {Rotation = 0}, 0.2)
            end)
        end
    end)

    return {
        Frame = cardFrame,
        Flip = function()
            isFlipped = not isFlipped
            frontFrame.Visible = not isFlipped
            backFrame.Visible = isFlipped
        end,
        Destroy = function()
            cardFrame:Destroy()
        end
    }
end

AdvancedUI.CreateCarousel = function(parent, config)
    config = config or {}
    local items = config.Items or {}
    local autoPlay = config.AutoPlay or false
    local interval = config.Interval or 3

    local carouselFrame = Utility.Create("Frame", {
        Name = "Carousel_" .. Utility.GenerateUUID(),
        Size = config.Size or UDim2.new(1, 0, 0, 200),
        BackgroundColor3 = ThemeManager.GetColor("BackgroundSecondary"),
        BorderSizePixel = 0,
        ClipsDescendants = true,
        Parent = parent
    })

    local corner = Utility.Create("UICorner", {
        CornerRadius = UDim.new(0, 12),
        Parent = carouselFrame
    })

    local container = Utility.Create("Frame", {
        Name = "Container",
        Size = UDim2.new(#items, 0, 1, 0),
        BackgroundTransparency = 1,
        Parent = carouselFrame
    })

    for i, item in ipairs(items) do
        local itemFrame = Utility.Create("Frame", {
            Name = "Item_" .. tostring(i),
            Size = UDim2.new(1 / #items, 0, 1, 0),
            Position = UDim2.new((i - 1) / #items, 0, 0, 0),
            BackgroundColor3 = item.Color or ThemeManager.GetColor("BackgroundTertiary"),
            BorderSizePixel = 0,
            Parent = container
        })

        local label = Utility.Create("TextLabel", {
            Size = UDim2.new(1, 0, 1, 0),
            BackgroundTransparency = 1,
            Text = item.Text or tostring(i),
            TextColor3 = ThemeManager.GetColor("Text"),
            TextSize = 24,
            Font = Enum.Font.GothamBold,
            Parent = itemFrame
        })
    end

    local currentIndex = 1
    local dots = {}

    local dotsFrame = Utility.Create("Frame", {
        Name = "Dots",
        Size = UDim2.new(1, 0, 0, 30),
        Position = UDim2.new(0, 0, 1, -35),
        BackgroundTransparency = 1,
        Parent = carouselFrame
    })

    for i = 1, #items do
        local dot = Utility.Create("Frame", {
            Name = "Dot_" .. tostring(i),
            Size = UDim2.new(0, 10, 0, 10),
            Position = UDim2.new(0.5, -(#items * 15) + (i - 1) * 25, 0.5, -5),
            BackgroundColor3 = i == 1 and ThemeManager.GetColor("Accent") or ThemeManager.GetColor("BackgroundTertiary"),
            BorderSizePixel = 0,
            Parent = dotsFrame
        })

        local dotCorner = Utility.Create("UICorner", {
            CornerRadius = UDim.new(1, 0),
            Parent = dot
        })

        table.insert(dots, dot)
    end

    local function goTo(index)
        currentIndex = index
        Animation.Tween(container, {Position = UDim2.new(-(index - 1), 0, 0, 0)}, 0.5, Enum.EasingStyle.Quart)

        for i, dot in ipairs(dots) do
            Animation.Tween(dot, {BackgroundColor3 = i == index and ThemeManager.GetColor("Accent") or ThemeManager.GetColor("BackgroundTertiary")}, 0.3)
        end
    end

    local nextButton = Utility.Create("TextButton", {
        Name = "Next",
        Size = UDim2.new(0, 40, 0, 40),
        Position = UDim2.new(1, -50, 0.5, -20),
        BackgroundColor3 = ThemeManager.GetColor("BackgroundTertiary"),
        Text = ">",
        TextColor3 = ThemeManager.GetColor("Text"),
        TextSize = 20,
        Font = Enum.Font.GothamBold,
        Parent = carouselFrame
    })

    local prevButton = Utility.Create("TextButton", {
        Name = "Prev",
        Size = UDim2.new(0, 40, 0, 40),
        Position = UDim2.new(0, 10, 0.5, -20),
        BackgroundColor3 = ThemeManager.GetColor("BackgroundTertiary"),
        Text = "<",
        TextColor3 = ThemeManager.GetColor("Text"),
        TextSize = 20,
        Font = Enum.Font.GothamBold,
        Parent = carouselFrame
    })

    for _, btn in ipairs({nextButton, prevButton}) do
        local btnCorner = Utility.Create("UICorner", {
            CornerRadius = UDim.new(1, 0),
            Parent = btn
        })
    end

    nextButton.MouseButton1Click:Connect(function()
        local nextIndex = currentIndex + 1
        if nextIndex > #items then nextIndex = 1 end
        goTo(nextIndex)
    end)

    prevButton.MouseButton1Click:Connect(function()
        local prevIndex = currentIndex - 1
        if prevIndex < 1 then prevIndex = #items end
        goTo(prevIndex)
    end)

    if autoPlay then
        task.spawn(function()
            while carouselFrame and carouselFrame.Parent do
                task.wait(interval)
                if carouselFrame and carouselFrame.Parent then
                    local nextIndex = currentIndex + 1
                    if nextIndex > #items then nextIndex = 1 end
                    goTo(nextIndex)
                end
            end
        end)
    end

    return {
        Frame = carouselFrame,
        GoTo = goTo,
        Next = function()
            local nextIndex = currentIndex + 1
            if nextIndex > #items then nextIndex = 1 end
            goTo(nextIndex)
        end,
        Previous = function()
            local prevIndex = currentIndex - 1
            if prevIndex < 1 then prevIndex = #items end
            goTo(prevIndex)
        end,
        Destroy = function()
            carouselFrame:Destroy()
        end
    }
end

AdvancedUI.CreateImageGallery = function(parent, config)
    config = config or {}
    local images = config.Images or {}
    local columns = config.Columns or 3

    local galleryFrame = Utility.Create("Frame", {
        Name = "Gallery_" .. Utility.GenerateUUID(),
        Size = UDim2.new(1, 0, 0, 300),
        BackgroundColor3 = ThemeManager.GetColor("BackgroundSecondary"),
        BorderSizePixel = 0,
        Parent = parent
    })

    local corner = Utility.Create("UICorner", {
        CornerRadius = UDim.new(0, 8),
        Parent = galleryFrame
    })

    local scrollFrame = Utility.Create("ScrollingFrame", {
        Name = "Scroll",
        Size = UDim2.new(1, -10, 1, -10),
        Position = UDim2.new(0, 5, 0, 5),
        BackgroundTransparency = 1,
        ScrollBarThickness = 4,
        CanvasSize = UDim2.new(0, 0, 0, 0),
        Parent = galleryFrame
    })

    local grid = Utility.Create("UIGridLayout", {
        CellSize = UDim2.new(1 / columns, -10, 0, 100),
        CellPadding = UDim.new(0, 10),
        Parent = scrollFrame
    })

    for i, imageUrl in ipairs(images) do
        local imageButton = Utility.Create("ImageButton", {
            Name = "Image_" .. tostring(i),
            BackgroundColor3 = ThemeManager.GetColor("BackgroundTertiary"),
            Image = imageUrl,
            ScaleType = Enum.ScaleType.Crop,
            Parent = scrollFrame
        })

        local imageCorner = Utility.Create("UICorner", {
            CornerRadius = UDim.new(0, 6),
            Parent = imageButton
        })

        imageButton.MouseEnter:Connect(function()
            Animation.Tween(imageButton, {Size = UDim2.new(imageButton.Size.X.Scale, 0, 0, 105)}, 0.2)
        end)

        imageButton.MouseLeave:Connect(function()
            Animation.Tween(imageButton, {Size = grid.CellSize}, 0.2)
        end)
    end

    grid:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        scrollFrame.CanvasSize = UDim2.new(0, 0, 0, grid.AbsoluteContentSize.Y + 20)
    end)

    return {
        Frame = galleryFrame,
        AddImage = function(url)
            table.insert(images, url)
            local imageButton = Utility.Create("ImageButton", {
                Name = "Image_" .. tostring(#images),
                BackgroundColor3 = ThemeManager.GetColor("BackgroundTertiary"),
                Image = url,
                ScaleType = Enum.ScaleType.Crop,
                Parent = scrollFrame
            })

            local imageCorner = Utility.Create("UICorner", {
                CornerRadius = UDim.new(0, 6),
                Parent = imageButton
            })
        end,
        Destroy = function()
            galleryFrame:Destroy()
        end
    }
end

AdvancedUI.CreateLoadingScreen = function(config)
    config = config or {}
    local text = config.Text or "Loading..."
    local duration = config.Duration or 3

    local screenGui = Utility.Create("ScreenGui", {
        Name = "LoadingScreen",
        Parent = CoreGui,
        ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
        DisplayOrder = 999
    })

    local overlay = Utility.Create("Frame", {
        Name = "Overlay",
        Size = UDim2.new(1, 0, 1, 0),
        BackgroundColor3 = Color3.fromRGB(0, 0, 0),
        BackgroundTransparency = 0,
        Parent = screenGui
    })

    local spinner = SpinnerSystem.Create(overlay, {
        Size = 60,
        Color = ThemeManager.GetColor("Accent")
    })
    spinner.Frame.Position = UDim2.new(0.5, -30, 0.5, -50)
    spinner.Frame.Parent = overlay

    local label = Utility.Create("TextLabel", {
        Name = "Text",
        Size = UDim2.new(1, 0, 0, 30),
        Position = UDim2.new(0, 0, 0.5, 20),
        BackgroundTransparency = 1,
        Text = text,
        TextColor3 = Color3.fromRGB(255, 255, 255),
        TextSize = 18,
        Font = Enum.Font.Gotham,
        Parent = overlay
    })

    local progressBar = Utility.Create("Frame", {
        Name = "Progress",
        Size = UDim2.new(0, 200, 0, 4),
        Position = UDim2.new(0.5, -100, 0.5, 60),
        BackgroundColor3 = ThemeManager.GetColor("BackgroundTertiary"),
        BorderSizePixel = 0,
        Parent = overlay
    })

    local progressCorner = Utility.Create("UICorner", {
        CornerRadius = UDim.new(1, 0),
        Parent = progressBar
    })

    local progressFill = Utility.Create("Frame", {
        Name = "Fill",
        Size = UDim2.new(0, 0, 1, 0),
        BackgroundColor3 = ThemeManager.GetColor("Accent"),
        BorderSizePixel = 0,
        Parent = progressBar
    })

    local fillCorner = Utility.Create("UICorner", {
        CornerRadius = UDim.new(1, 0),
        Parent = progressFill
    })

    Animation.Tween(progressFill, {Size = UDim2.new(1, 0, 1, 0)}, duration)

    task.delay(duration, function()
        Animation.FadeOut(overlay, 0.5)
        task.delay(0.5, function()
            screenGui:Destroy()
        end)
    end)

    return {
        ScreenGui = screenGui,
        SetProgress = function(progress)
            progressFill.Size = UDim2.new(progress, 0, 1, 0)
        end,
        SetText = function(newText)
            label.Text = newText
        end,
        Destroy = function()
            screenGui:Destroy()
        end
    }
end

AdvancedUI.CreateDock = function(config)
    config = config or {}
    local items = config.Items or {}
    local position = config.Position or "Bottom"

    local screenGui = Utility.Create("ScreenGui", {
        Name = "Dock",
        Parent = CoreGui,
        ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    })

    local dockFrame = Utility.Create("Frame", {
        Name = "Dock",
        Size = UDim2.new(0, #items * 70 + 20, 0, 70),
        Position = position == "Bottom" and UDim2.new(0.5, -(#items * 35 + 10), 1, -80) or
                   position == "Top" and UDim2.new(0.5, -(#items * 35 + 10), 0, 10) or
                   position == "Left" and UDim2.new(0, 10, 0.5, -(#items * 35 + 10)) or
                   UDim2.new(1, -80, 0.5, -(#items * 35 + 10)),
        BackgroundColor3 = ThemeManager.GetColor("BackgroundSecondary"),
        BackgroundTransparency = 0.1,
        BorderSizePixel = 0,
        Parent = screenGui
    })

    if position == "Left" or position == "Right" then
        dockFrame.Size = UDim2.new(0, 70, 0, #items * 70 + 20)
    end

    local corner = Utility.Create("UICorner", {
        CornerRadius = UDim.new(0, 20),
        Parent = dockFrame
    })

    local stroke = Utility.Create("UIStroke", {
        Color = ThemeManager.GetColor("Border"),
        Thickness = 1,
        Transparency = 0.5,
        Parent = dockFrame
    })

    local layout = Utility.Create("UIListLayout", {
        FillDirection = position == "Left" or position == "Right" and Enum.FillDirection.Vertical or Enum.FillDirection.Horizontal,
        HorizontalAlignment = Enum.HorizontalAlignment.Center,
        VerticalAlignment = Enum.VerticalAlignment.Center,
        Padding = UDim.new(0, 10),
        Parent = dockFrame
    })

    local padding = Utility.Create("UIPadding", {
        PaddingTop = UDim.new(0, 10),
        PaddingBottom = UDim.new(0, 10),
        PaddingLeft = UDim.new(0, 10),
        PaddingRight = UDim.new(0, 10),
        Parent = dockFrame
    })

    for i, item in ipairs(items) do
        local button = Utility.Create("ImageButton", {
            Name = "Item_" .. tostring(i),
            Size = UDim2.new(0, 50, 0, 50),
            BackgroundColor3 = ThemeManager.GetColor("BackgroundTertiary"),
            Image = item.Icon or "",
            Parent = dockFrame
        })

        local buttonCorner = Utility.Create("UICorner", {
            CornerRadius = UDim.new(0, 12),
            Parent = button
        })

        button.MouseEnter:Connect(function()
            Animation.Tween(button, {Size = UDim2.new(0, 55, 0, 55)}, 0.2, Enum.EasingStyle.Back)
        end)

        button.MouseLeave:Connect(function()
            Animation.Tween(button, {Size = UDim2.new(0, 50, 0, 50)}, 0.2, Enum.EasingStyle.Back)
        end)

        button.MouseButton1Click:Connect(function()
            if item.Callback then
                item.Callback()
            end
        end)
    end

    return {
        Frame = dockFrame,
        ScreenGui = screenGui,
        Destroy = function()
            screenGui:Destroy()
        end
    }
end

AdvancedUI.InitWatermark = function(config)
    return WatermarkSystem.Create(config)
end

AdvancedUI.InitNotifications = function()
    return true
end

AdvancedUI.ShowNotification = function(title, message, type, duration)
    return NotificationSystem.Create({
        Title = title,
        Message = message,
        Type = type or "Info",
        Duration = duration or 3
    })
end


-- AdvancedUI API Exports
AdvancedUI.CreateChart = ChartSystem.Create
AdvancedUI.CreateAvatar = AvatarSystem.Create
AdvancedUI.CreateMultiSelect = MultiSelectSystem.Create
AdvancedUI.CreateTimePicker = TimePickerSystem.Create
AdvancedUI.CreateRichText = RichTextSystem.Create
AdvancedUI.Utils = Utility
AdvancedUI.Anim = Animation
AdvancedUI.Theme = ThemeManager
AdvancedUI.Version = "2.0.0"
AdvancedUI.Author = "AdvancedUI"
AdvancedUI.Created = os.date("%Y-%m-%d")

print("[AdvancedUI] Library loaded successfully. Version: " .. AdvancedUI.Version)

return AdvancedUI
