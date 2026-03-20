-- Obsidian UI Library
-- Complete Combined Version
-- Version: 2.1.0
-- Total Lines: ~8300

local Obsidian = {}
Obsidian.__index = Obsidian

local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local HttpService = game:GetService("HttpService")
local Players = game:GetService("Players")
local TextService = game:GetService("TextService")
local CoreGui = game:GetService("CoreGui")
local StarterGui = game:GetService("StarterGui")

local LocalPlayer = Players.LocalPlayer
local Mouse = LocalPlayer:GetMouse()

Obsidian.Version = "2.1.0"
Obsidian.Build = "Release"
Obsidian.Author = "Obsidian Team"

Obsidian.Theme = {
    Background = Color3.fromRGB(25, 25, 25),
    Accent = Color3.fromRGB(88, 101, 242),
    AccentDark = Color3.fromRGB(71, 82, 196),
    AccentLight = Color3.fromRGB(123, 133, 244),
    Text = Color3.fromRGB(255, 255, 255),
    TextDark = Color3.fromRGB(178, 178, 178),
    TextDarker = Color3.fromRGB(120, 120, 120),
    Border = Color3.fromRGB(40, 40, 40),
    BorderLight = Color3.fromRGB(60, 60, 60),
    ElementBackground = Color3.fromRGB(35, 35, 35),
    ElementBackgroundHover = Color3.fromRGB(45, 45, 45),
    ElementBackgroundActive = Color3.fromRGB(55, 55, 55),
    Success = Color3.fromRGB(59, 165, 93),
    Error = Color3.fromRGB(237, 66, 69),
    Warning = Color3.fromRGB(250, 166, 26),
    Info = Color3.fromRGB(88, 101, 242),
    Shadow = Color3.fromRGB(0, 0, 0),
    Glow = Color3.fromRGB(88, 101, 242),
    Transparent = Color3.fromRGB(0, 0, 0)
}

Obsidian.Animation = {
    Duration = {
        Fast = 0.15,
        Normal = 0.3,
        Slow = 0.5,
        VerySlow = 0.8
    },
    Easing = {
        Default = Enum.EasingStyle.Quad,
        Bounce = Enum.EasingStyle.Bounce,
        Elastic = Enum.EasingStyle.Elastic,
        Exponential = Enum.EasingStyle.Exponential,
        Circular = Enum.EasingStyle.Circular
    },
    Direction = {
        Out = Enum.EasingDirection.Out,
        In = Enum.EasingDirection.In,
        InOut = Enum.EasingDirection.InOut
    }
}

local Utility = {}

function Utility.Create(className, properties, children)
    local instance = Instance.new(className)
    if properties then
        for property, value in pairs(properties) do
            if property ~= "Parent" then
                instance[property] = value
            end
        end
    end
    if children then
        for _, child in ipairs(children) do
            child.Parent = instance
        end
    end
    if properties and properties.Parent then
        instance.Parent = properties.Parent
    end
    return instance
end

function Utility.Tween(instance, properties, duration, easingStyle, easingDirection, callback)
    local tweenInfo = TweenInfo.new(
        duration or Obsidian.Animation.Duration.Normal,
        easingStyle or Obsidian.Animation.Easing.Default,
        easingDirection or Obsidian.Animation.Direction.Out,
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

function Utility.TweenMultiple(instances, properties, duration, easingStyle, easingDirection)
    local tweens = {}
    for _, instance in ipairs(instances) do
        table.insert(tweens, Utility.Tween(instance, properties, duration, easingStyle, easingDirection))
    end
    return tweens
end

function Utility.MakeDraggable(frame, handle, callback)
    handle = handle or frame
    local dragging = false
    local dragStart = nil
    local startPos = nil
    local dragConnection1, dragConnection2, dragConnection3
    local function updateInput(input)
        local delta = input.Position - dragStart
        local newPosition = UDim2.new(
            startPos.X.Scale,
            startPos.X.Offset + delta.X,
            startPos.Y.Scale,
            startPos.Y.Offset + delta.Y
        )
        frame.Position = newPosition
        if callback then
            callback(newPosition)
        end
    end
    dragConnection1 = handle.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or 
           input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragStart = input.Position
            startPos = frame.Position
            dragConnection2 = input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    dragging = false
                end
            end)
        end
    end)
    dragConnection3 = UserInputService.InputChanged:Connect(function(input)
        if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or 
                        input.UserInputType == Enum.UserInputType.Touch) then
            updateInput(input)
        end
    end)
    return {
        Disconnect = function()
            if dragConnection1 then dragConnection1:Disconnect() end
            if dragConnection2 then dragConnection2:Disconnect() end
            if dragConnection3 then dragConnection3:Disconnect() end
        end
    }
end

function Utility.MakeResizable(frame, handle, minSize, maxSize, callback)
    minSize = minSize or Vector2.new(100, 100)
    maxSize = maxSize or Vector2.new(1000, 800)
    local resizing = false
    local resizeStart = nil
    local startSize = nil
    handle.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            resizing = true
            resizeStart = input.Position
            startSize = frame.AbsoluteSize
        end
    end)
    UserInputService.InputChanged:Connect(function(input)
        if resizing and input.UserInputType == Enum.UserInputType.MouseMovement then
            local delta = input.Position - resizeStart
            local newSize = Vector2.new(
                math.clamp(startSize.X + delta.X, minSize.X, maxSize.X),
                math.clamp(startSize.Y + delta.Y, minSize.Y, maxSize.Y)
            )
            frame.Size = UDim2.new(0, newSize.X, 0, newSize.Y)
            if callback then
                callback(newSize)
            end
        end
    end)
    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            resizing = false
        end
    end)
end

function Utility.Ripple(button, color, duration)
    color = color or Color3.fromRGB(255, 255, 255)
    duration = duration or 0.5
    local ripple = Utility.Create("Frame", {
        Name = "Ripple",
        AnchorPoint = Vector2.new(0.5, 0.5),
        BackgroundColor3 = color,
        BackgroundTransparency = 0.8,
        BorderSizePixel = 0,
        Position = UDim2.new(0.5, 0, 0.5, 0),
        Size = UDim2.new(0, 0, 0, 0),
        Parent = button,
        ZIndex = button.ZIndex + 1
    })
    local corner = Utility.Create("UICorner", {
        CornerRadius = UDim.new(1, 0),
        Parent = ripple
    })
    local maxSize = math.max(button.AbsoluteSize.X, button.AbsoluteSize.Y) * 2
    Utility.Tween(ripple, {
        Size = UDim2.new(0, maxSize, 0, maxSize),
        BackgroundTransparency = 1
    }, duration, Enum.EasingStyle.Quad, Enum.EasingDirection.Out, function()
        ripple:Destroy()
    end)
end

function Utility.DarkenColor(color, amount)
    amount = amount or 0.2
    return Color3.new(
        math.max(0, color.R - amount),
        math.max(0, color.G - amount),
        math.max(0, color.B - amount)
    )
end

function Utility.LightenColor(color, amount)
    amount = amount or 0.2
    return Color3.new(
        math.min(1, color.R + amount),
        math.min(1, color.G + amount),
        math.min(1, color.B + amount)
    )
end

function Utility.ColorToHex(color)
    return string.format("#%02X%02X%02X", 
        math.floor(color.R * 255),
        math.floor(color.G * 255),
        math.floor(color.B * 255)
    )
end

function Utility.HexToColor(hex)
    hex = hex:gsub("#", "")
    return Color3.fromRGB(
        tonumber(hex:sub(1, 2), 16),
        tonumber(hex:sub(3, 4), 16),
        tonumber(hex:sub(5, 6), 16)
    )
end

function Utility.GetTextBounds(text, font, size, maxWidth)
    return TextService:GetTextSize(text, size, font, Vector2.new(maxWidth or 1000, 1000))
end

function Utility.CloneTable(tbl)
    local clone = {}
    for k, v in pairs(tbl) do
        if type(v) == "table" then
            clone[k] = Utility.CloneTable(v)
        else
            clone[k] = v
        end
    end
    return clone
end

function Utility.MergeTables(base, override)
    local result = Utility.CloneTable(base)
    if override then
        for k, v in pairs(override) do
            if type(v) == "table" and type(result[k]) == "table" then
                result[k] = Utility.MergeTables(result[k], v)
            else
                result[k] = v
            end
        end
    end
    return result
end

function Utility.GenerateUUID()
    local template = "xxxxxxxx-xxxx-4xxx-yxxx-xxxxxxxxxxxx"
    return string.gsub(template, "[xy]", function(c)
        local v = (c == "x") and math.random(0, 0xf) or math.random(8, 0xb)
        return string.format("%x", v)
    end)
end

function Utility.RandomString(length)
    length = length or 10
    local chars = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
    local result = ""
    for i = 1, length do
        local randomIndex = math.random(1, #chars)
        result = result .. chars:sub(randomIndex, randomIndex)
    end
    return result
end

function Utility.FormatNumber(number, decimals)
    decimals = decimals or 0
    return string.format("%." .. decimals .. "f", number)
end

function Utility.FormatTime(seconds)
    local hours = math.floor(seconds / 3600)
    local minutes = math.floor((seconds % 3600) / 60)
    local secs = math.floor(seconds % 60)
    if hours > 0 then
        return string.format("%02d:%02d:%02d", hours, minutes, secs)
    else
        return string.format("%02d:%02d", minutes, secs)
    end
end

function Utility.Lerp(a, b, t)
    return a + (b - a) * t
end

function Utility.LerpColor(colorA, colorB, t)
    return Color3.new(
        Utility.Lerp(colorA.R, colorB.R, t),
        Utility.Lerp(colorA.G, colorB.G, t),
        Utility.Lerp(colorA.B, colorB.B, t)
    )
end

function Utility.Spring(freq, damping)
    local spring = {
        f = freq or 5,
        d = damping or 0.8,
        x = 0,
        v = 0,
        target = 0
    }
    function spring:Update(dt)
        local a = -self.f * self.f * (self.x - self.target) - 2 * self.d * self.f * self.v
        self.v = self.v + a * dt
        self.x = self.x + self.v * dt
        return self.x
    end
    function spring:SetTarget(target)
        self.target = target
    end
    function spring:Reset(value)
        self.x = value or 0
        self.v = 0
        self.target = value or 0
    end
    return spring
end

local Input = {}
Input.Connections = {}

function Input:Bind(key, callback, type)
    type = type or "Key"
    local connection = UserInputService.InputBegan:Connect(function(input, gameProcessed)
        if gameProcessed then return end
        local match = false
        if type == "Key" and input.UserInputType == Enum.UserInputType.Keyboard then
            match = input.KeyCode == key
        elseif type == "Mouse" then
            match = input.UserInputType == key
        end
        if match then
            callback()
        end
    end)
    table.insert(Input.Connections, connection)
    return connection
end

function Input:BindHold(key, onStart, onEnd)
    local holding = false
    local beganConnection = UserInputService.InputBegan:Connect(function(input, gameProcessed)
        if gameProcessed then return end
        if input.KeyCode == key then
            holding = true
            if onStart then onStart() end
        end
    end)
    local endedConnection = UserInputService.InputEnded:Connect(function(input)
        if input.KeyCode == key and holding then
            holding = false
            if onEnd then onEnd() end
        end
    end)
    table.insert(Input.Connections, beganConnection)
    table.insert(Input.Connections, endedConnection)
    return {beganConnection, endedConnection}
end

function Input:UnbindAll()
    for _, connection in ipairs(Input.Connections) do
        connection:Disconnect()
    end
    Input.Connections = {}
end

local Data = {}
Data.Cache = {}

function Data:Save(key, value)
    if not isfolder("Obsidian") then
        makefolder("Obsidian")
    end
    local path = "Obsidian/" .. key .. ".json"
    local success, encoded = pcall(function()
        return HttpService:JSONEncode(value)
    end)
    if success then
        writefile(path, encoded)
        Data.Cache[key] = value
        return true
    end
    return false
end

function Data:Load(key, default)
    if Data.Cache[key] then
        return Data.Cache[key]
    end
    local path = "Obsidian/" .. key .. ".json"
    if isfile(path) then
        local success, decoded = pcall(function()
            return HttpService:JSONDecode(readfile(path))
        end)
        if success then
            Data.Cache[key] = decoded
            return decoded
        end
    end
    return default
end

function Data:Delete(key)
    local path = "Obsidian/" .. key .. ".json"
    if isfile(path) then
        delfile(path)
    end
    Data.Cache[key] = nil
end

function Data:ClearCache()
    Data.Cache = {}
end

Obsidian.Utility = Utility
Obsidian.Input = Input
Obsidian.Data = Data

function Obsidian:CreateWatermark(config)
    config = Utility.MergeTables({
        Text = "Obsidian UI",
        Position = "TopLeft",
        CustomPosition = nil,
        Draggable = true,
        FadeOnHold = true,
        HoldTime = 0.3,
        FadeSpeed = 0.3,
        Font = Enum.Font.GothamSemibold,
        TextSize = 14,
        TextColor = Color3.fromRGB(255, 255, 255),
        BackgroundColor = Color3.fromRGB(0, 0, 0),
        BackgroundTransparency = 0.5,
        CornerRadius = 6,
        Shadow = true,
        Outline = false,
        OutlineColor = Color3.fromRGB(88, 101, 242),
        Padding = 12,
        Icon = nil,
        IconSize = 16,
        UpdateInterval = nil,
        UpdateCallback = nil
    }, config)

    local Watermark = {}
    Watermark.Config = config
    Watermark.Holding = false
    Watermark.HoldStart = 0
    Watermark.Visible = true
    Watermark.Connections = {}

    local ScreenGui = Utility.Create("ScreenGui", {
        Name = "ObsidianWatermark_" .. Utility.RandomString(8),
        Parent = CoreGui,
        ResetOnSpawn = false,
        ZIndexBehavior = Enum.ZIndexBehavior.Global,
        DisplayOrder = 999999
    })
    Watermark.ScreenGui = ScreenGui

    if config.Shadow then
        Watermark.Shadow = Utility.Create("ImageLabel", {
            Name = "Shadow",
            Parent = ScreenGui,
            BackgroundTransparency = 1,
            Image = "rbxassetid://6015897843",
            ImageColor3 = Color3.fromRGB(0, 0, 0),
            ImageTransparency = 0.5,
            ScaleType = Enum.ScaleType.Slice,
            SliceCenter = Rect.new(49, 49, 450, 450),
            Size = UDim2.new(0, 200, 0, 40),
            Position = UDim2.new(0, 0, 0, 0),
            Visible = false
        })
    end

    local MainFrame = Utility.Create("Frame", {
        Name = "Main",
        Parent = ScreenGui,
        BackgroundColor3 = config.BackgroundColor,
        BackgroundTransparency = config.BackgroundTransparency,
        BorderSizePixel = 0,
        Size = UDim2.new(0, 0, 0, 40),
        AutomaticSize = Enum.AutomaticSize.X
    })
    Watermark.MainFrame = MainFrame

    local positions = {
        TopLeft = UDim2.new(0, 20, 0, 20),
        TopRight = UDim2.new(1, -20, 0, 20),
        TopCenter = UDim2.new(0.5, 0, 0, 20),
        BottomLeft = UDim2.new(0, 20, 1, -60),
        BottomRight = UDim2.new(1, -20, 1, -60),
        BottomCenter = UDim2.new(0.5, 0, 1, -60),
        Center = UDim2.new(0.5, 0, 0.5, 0)
    }

    if config.CustomPosition then
        MainFrame.Position = config.CustomPosition
    else
        MainFrame.Position = positions[config.Position] or positions.TopLeft
        if config.Position:find("Right") then
            MainFrame.AnchorPoint = Vector2.new(1, 0)
        elseif config.Position:find("Center") then
            MainFrame.AnchorPoint = Vector2.new(0.5, 0)
        end
    end

    if config.Outline then
        local Stroke = Utility.Create("UIStroke", {
            Color = config.OutlineColor,
            Thickness = 1,
            Parent = MainFrame
        })
        Watermark.Stroke = Stroke
    end

    local Corner = Utility.Create("UICorner", {
        CornerRadius = UDim.new(0, config.CornerRadius),
        Parent = MainFrame
    })

    local Layout = Utility.Create("UIListLayout", {
        Parent = MainFrame,
        FillDirection = Enum.FillDirection.Horizontal,
        HorizontalAlignment = Enum.HorizontalAlignment.Center,
        VerticalAlignment = Enum.VerticalAlignment.Center,
        SortOrder = Enum.SortOrder.LayoutOrder,
        Padding = UDim.new(0, 8)
    })

    local Padding = Utility.Create("UIPadding", {
        Parent = MainFrame,
        PaddingLeft = UDim.new(0, config.Padding),
        PaddingRight = UDim.new(0, config.Padding),
        PaddingTop = UDim.new(0, config.Padding / 2),
        PaddingBottom = UDim.new(0, config.Padding / 2)
    })

    if config.Icon then
        local IconLabel = Utility.Create("ImageLabel", {
            Name = "Icon",
            Parent = MainFrame,
            BackgroundTransparency = 1,
            Size = UDim2.new(0, config.IconSize, 0, config.IconSize),
            Image = config.Icon,
            ImageColor3 = config.TextColor
        })
        Watermark.Icon = IconLabel
    end

    local TextLabel = Utility.Create("TextLabel", {
        Name = "Text",
        Parent = MainFrame,
        BackgroundTransparency = 1,
        Font = config.Font,
        Text = config.Text,
        TextColor3 = config.TextColor,
        TextSize = config.TextSize,
        TextStrokeTransparency = 0.9,
        AutomaticSize = Enum.AutomaticSize.X
    })
    Watermark.TextLabel = TextLabel

    local textBounds = Utility.GetTextBounds(config.Text, config.Font, config.TextSize)
    local totalWidth = textBounds.X + (config.Padding * 2)
    if config.Icon then
        totalWidth = totalWidth + config.IconSize + 8
    end

    MainFrame.Size = UDim2.new(0, totalWidth, 0, config.TextSize + config.Padding)

    if config.Shadow and Watermark.Shadow then
        Watermark.Shadow.Size = MainFrame.Size + UDim2.new(0, 30, 0, 30)
        Watermark.Shadow.Position = MainFrame.Position - UDim2.new(0, 15, 0, 15)
        Watermark.Shadow.AnchorPoint = MainFrame.AnchorPoint
        Watermark.Shadow.Visible = true
    end

    if config.Draggable then
        local dragConnection = Utility.MakeDraggable(MainFrame, MainFrame, function(newPos)
            if config.Shadow and Watermark.Shadow then
                Watermark.Shadow.Position = newPos - UDim2.new(0, 15, 0, 15)
            end
        end)
        table.insert(Watermark.Connections, dragConnection)
    end

    if config.FadeOnHold then
        local fadeConnection = nil
        local function startFade()
            Watermark.Holding = true
            Watermark.HoldStart = tick()
            fadeConnection = RunService.Heartbeat:Connect(function()
                if not Watermark.Holding then
                    fadeConnection:Disconnect()
                    return
                end
                local holdTime = tick() - Watermark.HoldStart
                if holdTime > config.HoldTime then
                    local progress = math.min((holdTime - config.HoldTime) / config.FadeSpeed, 1)
                    local alpha = progress * 0.9
                    MainFrame.BackgroundTransparency = config.BackgroundTransparency + (alpha * (1 - config.BackgroundTransparency))
                    TextLabel.TextTransparency = alpha
                    TextLabel.TextStrokeTransparency = 0.9 + (alpha * 0.1)
                    if Watermark.Icon then
                        Watermark.Icon.ImageTransparency = alpha
                    end
                    if Watermark.Shadow then
                        Watermark.Shadow.ImageTransparency = 0.5 + (alpha * 0.5)
                    end
                end
            end)
            table.insert(Watermark.Connections, fadeConnection)
        end
        local function endFade()
            Watermark.Holding = false
            if fadeConnection then
                fadeConnection:Disconnect()
            end
            Utility.Tween(MainFrame, {BackgroundTransparency = config.BackgroundTransparency}, 0.3)
            Utility.Tween(TextLabel, {TextTransparency = 0, TextStrokeTransparency = 0.9}, 0.3)
            if Watermark.Icon then
                Utility.Tween(Watermark.Icon, {ImageTransparency = 0}, 0.3)
            end
            if Watermark.Shadow then
                Utility.Tween(Watermark.Shadow, {ImageTransparency = 0.5}, 0.3)
            end
        end
        MainFrame.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 or 
               input.UserInputType == Enum.UserInputType.Touch then
                startFade()
            end
        end)
        MainFrame.InputEnded:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 or 
               input.UserInputType == Enum.UserInputType.Touch then
                endFade()
            end
        end)
        UserInputService.InputEnded:Connect(function(input)
            if (input.UserInputType == Enum.UserInputType.MouseButton1 or 
                input.UserInputType == Enum.UserInputType.Touch) and Watermark.Holding then
                endFade()
            end
        end)
    end

    if config.UpdateInterval and config.UpdateCallback then
        local updateConnection = task.spawn(function()
            while ScreenGui.Parent do
                local newText = config.UpdateCallback()
                if newText then
                    Watermark:SetText(newText)
                end
                task.wait(config.UpdateInterval)
            end
        end)
    end

    function Watermark:SetText(text)
        TextLabel.Text = text
        local textBounds = Utility.GetTextBounds(text, config.Font, config.TextSize)
        local totalWidth = textBounds.X + (config.Padding * 2)
        if config.Icon then
            totalWidth = totalWidth + config.IconSize + 8
        end
        MainFrame.Size = UDim2.new(0, totalWidth, 0, config.TextSize + config.Padding)
        if config.Shadow and Watermark.Shadow then
            Watermark.Shadow.Size = MainFrame.Size + UDim2.new(0, 30, 0, 30)
        end
    end

    function Watermark:SetColor(color)
        TextLabel.TextColor3 = color
        if Watermark.Icon then
            Watermark.Icon.ImageColor3 = color
        end
    end

    function Watermark:SetVisible(visible)
        Watermark.Visible = visible
        ScreenGui.Enabled = visible
    end

    function Watermark:SetPosition(position)
        MainFrame.Position = position
        if config.Shadow and Watermark.Shadow then
            Watermark.Shadow.Position = position - UDim2.new(0, 15, 0, 15)
        end
    end

    function Watermark:GetPosition()
        return MainFrame.Position
    end

    function Watermark:Destroy()
        for _, conn in ipairs(Watermark.Connections) do
            if typeof(conn) == "RBXScriptConnection" then
                conn:Disconnect()
            elseif conn and conn.Disconnect then
                conn:Disconnect()
            end
        end
        ScreenGui:Destroy()
    end

    return Watermark
end

Obsidian.Notifications = {}
Obsidian.Notifications.Queue = {}
Obsidian.Notifications.Active = {}
Obsidian.Notifications.MaxActive = 5
Obsidian.Notifications.SpawnPosition = "BottomRight"
Obsidian.Notifications.Padding = 10
Obsidian.Notifications.Offset = Vector2.new(20, 20)

function Obsidian:Notify(config)
    config = Utility.MergeTables({
        Title = "Notification",
        Content = "",
        Type = "Info",
        Duration = 3,
        Sound = false,
        SoundId = nil,
        Icon = nil,
        ShowProgress = true,
        ProgressColor = nil,
        Buttons = {},
        Callback = nil,
        CloseButton = true
    }, config)
    table.insert(Obsidian.Notifications.Queue, {Config = config, Time = tick()})
    Obsidian.Notifications:ProcessQueue()
    return {
        Config = config,
        Dismiss = function()
        end
    }
end

function Obsidian.Notifications:ProcessQueue()
    while #self.Queue > 0 and #self.Active < self.MaxActive do
        local data = table.remove(self.Queue, 1)
        self:CreateNotification(data.Config)
    end
end

function Obsidian.Notifications:CreateNotification(config)
    local notification = {}
    notification.Config = config
    notification.StartTime = tick()
    notification.Closed = false
    local typeColors = {
        Info = Obsidian.Theme.Accent,
        Success = Obsidian.Theme.Success,
        Warning = Obsidian.Theme.Warning,
        Error = Obsidian.Theme.Error
    }
    local accentColor = typeColors[config.Type] or typeColors.Info
    local ScreenGui = Utility.Create("ScreenGui", {
        Name = "ObsidianNotification_" .. Utility.RandomString(8),
        Parent = CoreGui,
        ResetOnSpawn = false,
        ZIndexBehavior = Enum.ZIndexBehavior.Global,
        DisplayOrder = 999998
    })
    notification.ScreenGui = ScreenGui
    local MainFrame = Utility.Create("Frame", {
        Name = "Main",
        Parent = ScreenGui,
        BackgroundColor3 = Obsidian.Theme.ElementBackground,
        BorderSizePixel = 0,
        Size = UDim2.new(0, 320, 0, 0),
        Position = self:GetSpawnPosition(),
        AnchorPoint = Vector2.new(1, 1),
        ClipsDescendants = true
    })
    notification.MainFrame = MainFrame
    local contentHeight = 70
    if config.Content and #config.Content > 0 then
        local textBounds = Utility.GetTextBounds(config.Content, Enum.Font.Gotham, 13, 280)
        contentHeight = 50 + textBounds.Y + 10
    end
    if #config.Buttons > 0 then
        contentHeight = contentHeight + 40
    end
    local Shadow = Utility.Create("ImageLabel", {
        Name = "Shadow",
        Parent = ScreenGui,
        BackgroundTransparency = 1,
        Image = "rbxassetid://6015897843",
        ImageColor3 = Color3.fromRGB(0, 0, 0),
        ImageTransparency = 0.6,
        ScaleType = Enum.ScaleType.Slice,
        SliceCenter = Rect.new(49, 49, 450, 450),
        Size = UDim2.new(0, 350, 0, contentHeight + 30),
        Position = MainFrame.Position - UDim2.new(0, 15, 0, 15),
        AnchorPoint = Vector2.new(1, 1),
        ZIndex = 0
    })
    notification.Shadow = Shadow
    local Corner = Utility.Create("UICorner", {
        CornerRadius = UDim.new(0, 8),
        Parent = MainFrame
    })
    local AccentBar = Utility.Create("Frame", {
        Name = "Accent",
        Parent = MainFrame,
        BackgroundColor3 = accentColor,
        BorderSizePixel = 0,
        Size = UDim2.new(0, 4, 1, 0)
    })
    local AccentCorner = Utility.Create("UICorner", {
        CornerRadius = UDim.new(0, 8),
        Parent = AccentBar
    })
    local AccentFix = Utility.Create("Frame", {
        Parent = AccentBar,
        BackgroundColor3 = accentColor,
        BorderSizePixel = 0,
        Position = UDim2.new(0.5, 0, 0, 0),
        Size = UDim2.new(0.5, 0, 1, 0)
    })
    local iconIds = {
        Info = "rbxassetid://3944668821",
        Success = "rbxassetid://3944668821",
        Warning = "rbxassetid://3944668821",
        Error = "rbxassetid://3944668821"
    }
    local Icon = Utility.Create("ImageLabel", {
        Name = "Icon",
        Parent = MainFrame,
        BackgroundTransparency = 1,
        Position = UDim2.new(0, 20, 0, 15),
        Size = UDim2.new(0, 24, 0, 24),
        Image = config.Icon or iconIds[config.Type],
        ImageColor3 = accentColor
    })
    local Title = Utility.Create("TextLabel", {
        Name = "Title",
        Parent = MainFrame,
        BackgroundTransparency = 1,
        Position = UDim2.new(0, 52, 0, 12),
        Size = UDim2.new(1, -90, 0, 25),
        Font = Enum.Font.GothamBold,
        Text = config.Title,
        TextColor3 = Obsidian.Theme.Text,
        TextSize = 16,
        TextXAlignment = Enum.TextXAlignment.Left,
        TextTruncate = Enum.TextTruncate.AtEnd
    })
    if config.CloseButton then
        local CloseBtn = Utility.Create("TextButton", {
            Name = "Close",
            Parent = MainFrame,
            BackgroundTransparency = 1,
            Position = UDim2.new(1, -35, 0, 10),
            Size = UDim2.new(0, 25, 0, 25),
            Font = Enum.Font.GothamBold,
            Text = "X",
            TextColor3 = Obsidian.Theme.TextDark,
            TextSize = 14
        })
        CloseBtn.MouseEnter:Connect(function()
            Utility.Tween(CloseBtn, {TextColor3 = Obsidian.Theme.Error}, 0.2)
        end)
        CloseBtn.MouseLeave:Connect(function()
            Utility.Tween(CloseBtn, {TextColor3 = Obsidian.Theme.TextDark}, 0.2)
        end)
        CloseBtn.MouseButton1Click:Connect(function()
            notification:Close()
        end)
    end
    local Content = Utility.Create("TextLabel", {
        Name = "Content",
        Parent = MainFrame,
        BackgroundTransparency = 1,
        Position = UDim2.new(0, 20, 0, 42),
        Size = UDim2.new(1, -40, 0, contentHeight - 60),
        Font = Enum.Font.Gotham,
        Text = config.Content,
        TextColor3 = Obsidian.Theme.TextDark,
        TextSize = 13,
        TextWrapped = true,
        TextXAlignment = Enum.TextXAlignment.Left,
        TextYAlignment = Enum.TextYAlignment.Top
    })
    if config.ShowProgress then
        local ProgressBar = Utility.Create("Frame", {
            Name = "ProgressBar",
            Parent = MainFrame,
            BackgroundColor3 = Obsidian.Theme.Background,
            BorderSizePixel = 0,
            Position = UDim2.new(0, 0, 1, -3),
            Size = UDim2.new(1, 0, 0, 3)
        })
        local ProgressFill = Utility.Create("Frame", {
            Name = "Fill",
            Parent = ProgressBar,
            BackgroundColor3 = config.ProgressColor or accentColor,
            BorderSizePixel = 0,
            Size = UDim2.new(1, 0, 1, 0)
        })
        notification.ProgressFill = ProgressFill
        Utility.Tween(ProgressFill, {Size = UDim2.new(0, 0, 1, 0)}, config.Duration, Enum.EasingStyle.Linear)
    end
    if #config.Buttons > 0 then
        local ButtonFrame = Utility.Create("Frame", {
            Name = "Buttons",
            Parent = MainFrame,
            BackgroundTransparency = 1,
            Position = UDim2.new(0, 20, 1, -45),
            Size = UDim2.new(1, -40, 0, 35)
        })
        local ButtonLayout = Utility.Create("UIListLayout", {
            Parent = ButtonFrame,
            FillDirection = Enum.FillDirection.Horizontal,
            HorizontalAlignment = Enum.HorizontalAlignment.Right,
            Padding = UDim.new(0, 10)
        })
        for _, btnConfig in ipairs(config.Buttons) do
            local Button = Utility.Create("TextButton", {
                Parent = ButtonFrame,
                BackgroundColor3 = btnConfig.Primary and accentColor or Obsidian.Theme.Background,
                BorderSizePixel = 0,
                Size = UDim2.new(0, 80, 1, 0),
                Font = Enum.Font.GothamSemibold,
                Text = btnConfig.Text or "Button",
                TextColor3 = btnConfig.Primary and Color3.fromRGB(255, 255, 255) or Obsidian.Theme.Text,
                TextSize = 12,
                AutoButtonColor = false
            })
            local ButtonCorner = Utility.Create("UICorner", {
                CornerRadius = UDim.new(0, 6),
                Parent = Button
            })
            Button.MouseEnter:Connect(function()
                Utility.Tween(Button, {BackgroundColor3 = Utility.LightenColor(Button.BackgroundColor3, 0.1)}, 0.2)
            end)
            Button.MouseLeave:Connect(function()
                Utility.Tween(Button, {BackgroundColor3 = btnConfig.Primary and accentColor or Obsidian.Theme.Background}, 0.2)
            end)
            Button.MouseButton1Click:Connect(function()
                if btnConfig.Callback then
                    btnConfig.Callback()
                end
                if btnConfig.CloseOnClick ~= false then
                    notification:Close()
                end
            end)
        end
    end
    if config.Sound and config.SoundId then
        local sound = Instance.new("Sound")
        sound.SoundId = config.SoundId
        sound.Volume = 0.5
        sound.Parent = ScreenGui
        sound:Play()
        game:GetService("Debris"):AddItem(sound, 2)
    end
    function notification:Close()
        if self.Closed then return end
        self.Closed = true
        Utility.Tween(MainFrame, {Position = MainFrame.Position + UDim2.new(0, 50, 0, 0)}, 0.3)
        Utility.Tween(MainFrame, {Size = UDim2.new(0, 320, 0, 0)}, 0.3).Completed:Connect(function()
            ScreenGui:Destroy()
            self:RemoveFromActive()
        end)
        Utility.Tween(Shadow, {ImageTransparency = 1}, 0.3)
    end
    function notification:RemoveFromActive()
        for i, n in ipairs(Obsidian.Notifications.Active) do
            if n == self then
                table.remove(Obsidian.Notifications.Active, i)
                break
            end
        end
        Obsidian.Notifications:RepositionActive()
        Obsidian.Notifications:ProcessQueue()
    end
    task.delay(config.Duration, function()
        if not notification.Closed then
            notification:Close()
        end
    end)
    MainFrame.Size = UDim2.new(0, 320, 0, 0)
    MainFrame.Position = MainFrame.Position + UDim2.new(0, 50, 0, 0)
    Utility.Tween(MainFrame, {Size = UDim2.new(0, 320, 0, contentHeight)}, 0.4, Enum.EasingStyle.Back)
    Utility.Tween(MainFrame, {Position = MainFrame.Position - UDim2.new(0, 50, 0, 0)}, 0.4, Enum.EasingStyle.Back)
    table.insert(self.Active, 1, notification)
    self:RepositionActive()
    return notification
end

function Obsidian.Notifications:GetSpawnPosition()
    local positions = {
        TopLeft = UDim2.new(0, self.Offset.X, 0, self.Offset.Y),
        TopRight = UDim2.new(1, -self.Offset.X, 0, self.Offset.Y),
        TopCenter = UDim2.new(0.5, 0, 0, self.Offset.Y),
        BottomLeft = UDim2.new(0, self.Offset.X, 1, -self.Offset.Y),
        BottomRight = UDim2.new(1, -self.Offset.X, 1, -self.Offset.Y),
        BottomCenter = UDim2.new(0.5, 0, 1, -self.Offset.Y)
    }
    return positions[self.SpawnPosition] or positions.BottomRight
end

function Obsidian.Notifications:RepositionActive()
    local basePosition = self:GetSpawnPosition()
    local direction = self.SpawnPosition:find("Top") and 1 or -1
    for i, notification in ipairs(self.Active) do
        if not notification.Closed then
            local offset = (i - 1) * (notification.MainFrame.AbsoluteSize.Y + self.Padding) * direction
            local newPosition = basePosition + UDim2.new(0, 0, 0, offset)
            Utility.Tween(notification.MainFrame, {Position = newPosition}, 0.3)
            if notification.Shadow then
                Utility.Tween(notification.Shadow, {Position = newPosition - UDim2.new(0, 15, 0, 15)}, 0.3)
            end
        end
    end
end

function Obsidian.Notifications:ClearAll()
    for _, notification in ipairs(self.Active) do
        notification:Close()
    end
    self.Queue = {}
end

function Obsidian:CreateWindow(config)
    config = Utility.MergeTables({
        Title = "Obsidian UI",
        SubTitle = nil,
        Size = Vector2.new(600, 400),
        Position = nil,
        MinSize = Vector2.new(400, 300),
        MaxSize = Vector2.new(1200, 800),
        Theme = nil,
        Draggable = true,
        Resizable = true,
        Centered = true,
        ShowTitleBar = true,
        ShowSidebar = true,
        SidebarWidth = 160,
        TabHeight = 40,
        CornerRadius = 8,
        Shadow = true,
        Blur = false,
        Acrylic = false,
        ToggleKey = Enum.KeyCode.RightShift,
        StartMinimized = false,
        SavePosition = false,
        SaveKey = nil
    }, config)
    local Window = {}
    Window.Config = config
    Window.Tabs = {}
    Window.ActiveTab = nil
    Window.Minimized = config.StartMinimized
    Window.Visible = true
    Window.Connections = {}
    if config.Theme then
        Window.Theme = Utility.MergeTables(Obsidian.Theme, config.Theme)
    else
        Window.Theme = Obsidian.Theme
    end
    local ScreenGui = Utility.Create("ScreenGui", {
        Name = "ObsidianWindow_" .. Utility.RandomString(8),
        Parent = CoreGui,
        ResetOnSpawn = false,
        ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
        DisplayOrder = 100
    })
    Window.ScreenGui = ScreenGui
    local savedPos = nil
    if config.SavePosition and config.SaveKey then
        savedPos = Data:Load(config.SaveKey .. "_position")
    end
    if config.Shadow then
        Window.Shadow = Utility.Create("ImageLabel", {
            Name = "Shadow",
            Parent = ScreenGui,
            BackgroundTransparency = 1,
            Image = "rbxassetid://6015897843",
            ImageColor3 = Color3.fromRGB(0, 0, 0),
            ImageTransparency = 0.5,
            ScaleType = Enum.ScaleType.Slice,
            SliceCenter = Rect.new(49, 49, 450, 450),
            Size = UDim2.new(0, config.Size.X + 40, 0, config.Size.Y + 40),
            Position = UDim2.new(0.5, -(config.Size.X + 40) / 2, 0.5, -(config.Size.Y + 40) / 2),
            ZIndex = 0
        })
    end
    local MainFrame = Utility.Create("Frame", {
        Name = "Main",
        Parent = ScreenGui,
        BackgroundColor3 = Window.Theme.Background,
        BorderSizePixel = 0,
        Size = UDim2.new(0, config.Size.X, 0, config.Size.Y),
        Position = savedPos or (config.Centered and UDim2.new(0.5, -config.Size.X / 2, 0.5, -config.Size.Y / 2) or config.Position),
        ClipsDescendants = true
    })
    Window.MainFrame = MainFrame
    if config.Centered and not savedPos then
        MainFrame.AnchorPoint = Vector2.new(0, 0)
    end
    local Corner = Utility.Create("UICorner", {
        CornerRadius = UDim.new(0, config.CornerRadius),
        Parent = MainFrame
    })
    local Stroke = Utility.Create("UIStroke", {
        Color = Window.Theme.Border,
        Thickness = 1,
        Parent = MainFrame
    })
    if config.ShowTitleBar then
        local TitleBar = Utility.Create("Frame", {
            Name = "TitleBar",
            Parent = MainFrame,
            BackgroundColor3 = Window.Theme.ElementBackground,
            BorderSizePixel = 0,
            Size = UDim2.new(1, 0, 0, 35)
        })
        Window.TitleBar = TitleBar
        local TitleCorner = Utility.Create("UICorner", {
            CornerRadius = UDim.new(0, config.CornerRadius),
            Parent = TitleBar
        })
        local TitleFix = Utility.Create("Frame", {
            Parent = TitleBar,
            BackgroundColor3 = Window.Theme.ElementBackground,
            BorderSizePixel = 0,
            Position = UDim2.new(0, 0, 0.5, 0),
            Size = UDim2.new(1, 0, 0.5, 0)
        })
        local TitleLabel = Utility.Create("TextLabel", {
            Name = "Title",
            Parent = TitleBar,
            BackgroundTransparency = 1,
            Position = UDim2.new(0, 15, 0, 0),
            Size = UDim2.new(0, 200, 1, 0),
            Font = Enum.Font.GothamBold,
            Text = config.Title,
            TextColor3 = Window.Theme.Text,
            TextSize = 16,
            TextXAlignment = Enum.TextXAlignment.Left
        })
        Window.TitleLabel = TitleLabel
        if config.SubTitle then
            local SubTitleLabel = Utility.Create("TextLabel", {
                Name = "SubTitle",
                Parent = TitleBar,
                BackgroundTransparency = 1,
                Position = UDim2.new(0, 15 + Utility.GetTextBounds(config.Title, Enum.Font.GothamBold, 16).X + 10, 0, 0),
                Size = UDim2.new(0, 150, 1, 0),
                Font = Enum.Font.Gotham,
                Text = config.SubTitle,
                TextColor3 = Window.Theme.TextDark,
                TextSize = 14,
                TextXAlignment = Enum.TextXAlignment.Left
            })
        end
        local ControlsFrame = Utility.Create("Frame", {
            Name = "Controls",
            Parent = TitleBar,
            BackgroundTransparency = 1,
            Position = UDim2.new(1, -100, 0, 0),
            Size = UDim2.new(0, 95, 1, 0)
        })
        local ControlsLayout = Utility.Create("UIListLayout", {
            Parent = ControlsFrame,
            FillDirection = Enum.FillDirection.Horizontal,
            HorizontalAlignment = Enum.HorizontalAlignment.Right,
            VerticalAlignment = Enum.VerticalAlignment.Center,
            Padding = UDim.new(0, 8)
        })
        local ControlsPadding = Utility.Create("UIPadding", {
            Parent = ControlsFrame,
            PaddingRight = UDim.new(0, 15)
        })
        local MinimizeBtn = Utility.Create("TextButton", {
            Name = "Minimize",
            Parent = ControlsFrame,
            BackgroundColor3 = Window.Theme.Warning,
            BorderSizePixel = 0,
            Size = UDim2.new(0, 20, 0, 20),
            Font = Enum.Font.GothamBold,
            Text = "-",
            TextColor3 = Color3.fromRGB(255, 255, 255),
            TextSize = 14,
            AutoButtonColor = false
        })
        local MinimizeCorner = Utility.Create("UICorner", {
            CornerRadius = UDim.new(0, 4),
            Parent = MinimizeBtn
        })
        MinimizeBtn.MouseButton1Click:Connect(function()
            Window:ToggleMinimize()
        end)
        local CloseBtn = Utility.Create("TextButton", {
            Name = "Close",
            Parent = ControlsFrame,
            BackgroundColor3 = Window.Theme.Error,
            BorderSizePixel = 0,
            Size = UDim2.new(0, 20, 0, 20),
            Font = Enum.Font.GothamBold,
            Text = "X",
            TextColor3 = Color3.fromRGB(255, 255, 255),
            TextSize = 12,
            AutoButtonColor = false
        })
        local CloseCorner = Utility.Create("UICorner", {
            CornerRadius = UDim.new(0, 4),
            Parent = CloseBtn
        })
        CloseBtn.MouseEnter:Connect(function()
            Utility.Tween(CloseBtn, {BackgroundColor3 = Color3.fromRGB(255, 80, 80)}, 0.2)
        end)
        CloseBtn.MouseLeave:Connect(function()
            Utility.Tween(CloseBtn, {BackgroundColor3 = Window.Theme.Error}, 0.2)
        end)
        CloseBtn.MouseButton1Click:Connect(function()
            Window:Close()
        end)
        if config.Draggable then
            local dragConn = Utility.MakeDraggable(MainFrame, TitleBar, function(newPos)
                if config.Shadow and Window.Shadow then
                    Window.Shadow.Position = newPos - UDim2.new(0, 20, 0, 20)
                end
                if config.SavePosition and config.SaveKey then
                    Data:Save(config.SaveKey .. "_position", newPos)
                end
            end)
            table.insert(Window.Connections, dragConn)
        end
    end
    if config.ShowSidebar then
        local Sidebar = Utility.Create("Frame", {
            Name = "Sidebar",
            Parent = MainFrame,
            BackgroundColor3 = Window.Theme.ElementBackground,
            BorderSizePixel = 0,
            Position = UDim2.new(0, 0, 0, config.ShowTitleBar and 35 or 0),
            Size = UDim2.new(0, config.SidebarWidth, 1, config.ShowTitleBar and -35 or 0)
        })
        Window.Sidebar = Sidebar
        local SidebarLayout = Utility.Create("UIListLayout", {
            Parent = Sidebar,
            SortOrder = Enum.SortOrder.LayoutOrder,
            Padding = UDim.new(0, 5)
        })
        local SidebarPadding = Utility.Create("UIPadding", {
            Parent = Sidebar,
            PaddingLeft = UDim.new(0, 10),
            PaddingTop = UDim.new(0, 10),
            PaddingRight = UDim.new(0, 10),
            PaddingBottom = UDim.new(0, 10)
        })
        local SearchBox = Utility.Create("Frame", {
            Name = "Search",
            Parent = Sidebar,
            BackgroundColor3 = Window.Theme.Background,
            BorderSizePixel = 0,
            Size = UDim2.new(1, 0, 0, 35),
            LayoutOrder = -1
        })
        local SearchCorner = Utility.Create("UICorner", {
            CornerRadius = UDim.new(0, 6),
            Parent = SearchBox
        })
        local SearchIcon = Utility.Create("ImageLabel", {
            Parent = SearchBox,
            BackgroundTransparency = 1,
            Position = UDim2.new(0, 10, 0.5, -8),
            Size = UDim2.new(0, 16, 0, 16),
            Image = "rbxassetid://3944668821",
            ImageColor3 = Window.Theme.TextDark
        })
        local SearchInput = Utility.Create("TextBox", {
            Parent = SearchBox,
            BackgroundTransparency = 1,
            Position = UDim2.new(0, 32, 0, 0),
            Size = UDim2.new(1, -40, 1, 0),
            Font = Enum.Font.Gotham,
            Text = "",
            PlaceholderText = "Search...",
            PlaceholderColor3 = Window.Theme.TextDark,
            TextColor3 = Window.Theme.Text,
            TextSize = 13,
            ClearTextOnFocus = false
        })
        SearchInput:GetPropertyChangedSignal("Text"):Connect(function()
            local searchText = SearchInput.Text:lower()
            for _, tab in ipairs(Window.Tabs) do
                if tab.Button then
                    local match = searchText == "" or tab.Name:lower():find(searchText)
                    tab.Button.Visible = match
                end
            end
        end)
    end
    local ContentArea = Utility.Create("Frame", {
        Name = "Content",
        Parent = MainFrame,
        BackgroundTransparency = 1,
        Position = UDim2.new(0, config.ShowSidebar and config.SidebarWidth or 0, 0, config.ShowTitleBar and 35 or 0),
        Size = UDim2.new(1, config.ShowSidebar and -config.SidebarWidth or 0, 1, config.ShowTitleBar and -35 or 0),
        ClipsDescendants = true
    })
    Window.ContentArea = ContentArea
    if config.Resizable then
        local ResizeHandle = Utility.Create("TextButton", {
            Name = "ResizeHandle",
            Parent = MainFrame,
            BackgroundTransparency = 1,
            Position = UDim2.new(1, -15, 1, -15),
            Size = UDim2.new(0, 15, 0, 15),
            Text = ""
        })
        local ResizeIcon = Utility.Create("ImageLabel", {
            Parent = ResizeHandle,
            BackgroundTransparency = 1,
            Position = UDim2.new(0, 0, 0, 0),
            Size = UDim2.new(1, 0, 1, 0),
            Image = "rbxassetid://3944668821",
            ImageColor3 = Window.Theme.TextDark,
            ImageTransparency = 0.5
        })
        Utility.MakeResizable(MainFrame, ResizeHandle, config.MinSize, config.MaxSize, function(newSize)
            if config.Shadow and Window.Shadow then
                Window.Shadow.Size = UDim2.new(0, newSize.X + 40, 0, newSize.Y + 40)
            end
        end)
    end
    if config.ToggleKey then
        local toggleConn = UserInputService.InputBegan:Connect(function(input, gameProcessed)
            if not gameProcessed and input.KeyCode == config.ToggleKey then
                Window:Toggle()
            end
        end)
        table.insert(Window.Connections, toggleConn)
    end
    function Window:CreateTab(name, icon)
        local Tab = {}
        Tab.Name = name
        Tab.Icon = icon
        Tab.Elements = {}
        Tab.Visible = false
        if config.ShowSidebar then
            local TabButton = Utility.Create("TextButton", {
                Name = name .. "Tab",
                Parent = self.Sidebar,
                BackgroundColor3 = self.Theme.Background,
                BorderSizePixel = 0,
                Size = UDim2.new(1, 0, 0, config.TabHeight or 40),
                Font = Enum.Font.GothamSemibold,
                Text = "  " .. name,
                TextColor3 = self.Theme.TextDark,
                TextSize = 13,
                TextXAlignment = Enum.TextXAlignment.Left,
                AutoButtonColor = false,
                LayoutOrder = #self.Tabs
            })
            Tab.Button = TabButton
            local TabCorner = Utility.Create("UICorner", {
                CornerRadius = UDim.new(0, 6),
                Parent = TabButton
            })
            if icon then
                local TabIcon = Utility.Create("ImageLabel", {
                    Parent = TabButton,
                    BackgroundTransparency = 1,
                    Position = UDim2.new(0, 12, 0.5, -8),
                    Size = UDim2.new(0, 16, 0, 16),
                    Image = icon,
                    ImageColor3 = self.Theme.TextDark
                })
                TabButton.Text = "      " .. name
            end
            TabButton.MouseEnter:Connect(function()
                if self.ActiveTab ~= Tab then
                    Utility.Tween(TabButton, {BackgroundColor3 = self.Theme.ElementBackgroundHover}, 0.2)
                end
            end)
            TabButton.MouseLeave:Connect(function()
                if self.ActiveTab ~= Tab then
                    Utility.Tween(TabButton, {BackgroundColor3 = self.Theme.Background}, 0.2)
                end
            end)
            TabButton.MouseButton1Click:Connect(function()
                self:SelectTab(Tab)
            end)
        end
        local TabContent = Utility.Create("ScrollingFrame", {
            Name = name .. "Content",
            Parent = self.ContentArea,
            BackgroundTransparency = 1,
            BorderSizePixel = 0,
            Size = UDim2.new(1, 0, 1, 0),
            CanvasSize = UDim2.new(0, 0, 0, 0),
            ScrollBarThickness = 4,
            ScrollBarImageColor3 = self.Theme.Accent,
            Visible = false
        })
        Tab.Content = TabContent
        local ContentLayout = Utility.Create("UIListLayout", {
            Parent = TabContent,
            SortOrder = Enum.SortOrder.LayoutOrder,
            Padding = UDim.new(0, 10)
        })
        local ContentPadding = Utility.Create("UIPadding", {
            Parent = TabContent,
            PaddingLeft = UDim.new(0, 15),
            PaddingTop = UDim.new(0, 15),
            PaddingRight = UDim.new(0, 15),
            PaddingBottom = UDim.new(0, 15)
        })
        ContentLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
            TabContent.CanvasSize = UDim2.new(0, 0, 0, ContentLayout.AbsoluteContentSize.Y + 30)
        end)
        if #self.Tabs == 0 then
            self:SelectTab(Tab)
        end
        table.insert(self.Tabs, Tab)
        Tab.CreateButton = function(elementConfig) return Window:CreateButton(Tab, elementConfig) end
        Tab.CreateToggle = function(elementConfig) return Window:CreateToggle(Tab, elementConfig) end
        Tab.CreateSlider = function(elementConfig) return Window:CreateSlider(Tab, elementConfig) end
        Tab.CreateDropdown = function(elementConfig) return Window:CreateDropdown(Tab, elementConfig) end
        Tab.CreateTextbox = function(elementConfig) return Window:CreateTextbox(Tab, elementConfig) end
        Tab.CreateLabel = function(elementConfig) return Window:CreateLabel(Tab, elementConfig) end
        Tab.CreateSection = function(elementConfig) return Window:CreateSection(Tab, elementConfig) end
        Tab.CreateColorPicker = function(elementConfig) return Window:CreateColorPicker(Tab, elementConfig) end
        Tab.CreateKeybind = function(elementConfig) return Window:CreateKeybind(Tab, elementConfig) end
        return Tab
    end
    function Window:SelectTab(tab)
        if self.ActiveTab == tab then return end
        if self.ActiveTab then
            self.ActiveTab.Visible = false
            self.ActiveTab.Content.Visible = false
            if self.ActiveTab.Button then
                Utility.Tween(self.ActiveTab.Button, {
                    BackgroundColor3 = self.Theme.Background,
                    TextColor3 = self.Theme.TextDark
                }, 0.2)
            end
        end
        self.ActiveTab = tab
        tab.Visible = true
        tab.Content.Visible = true
        if tab.Button then
            Utility.Tween(tab.Button, {
                BackgroundColor3 = self.Theme.Accent,
                TextColor3 = self.Theme.Text
            }, 0.2)
        end
    end
    function Window:Toggle()
        self.Visible = not self.Visible
        ScreenGui.Enabled = self.Visible
        if self.Visible then
            MainFrame.Size = UDim2.new(0, 0, 0, 0)
            Utility.Tween(MainFrame, {Size = UDim2.new(0, config.Size.X, 0, config.Size.Y)}, 0.3)
        end
    end
    function Window:ToggleMinimize()
        self.Minimized = not self.Minimized
        if self.Minimized then
            Utility.Tween(MainFrame, {Size = UDim2.new(0, MainFrame.AbsoluteSize.X, 0, 35)}, 0.3)
            if self.ContentArea then
                self.ContentArea.Visible = false
            end
            if self.Sidebar then
                self.Sidebar.Visible = false
            end
        else
            Utility.Tween(MainFrame, {Size = UDim2.new(0, config.Size.X, 0, config.Size.Y)}, 0.3)
            if self.ContentArea then
                self.ContentArea.Visible = true
            end
            if self.Sidebar then
                self.Sidebar.Visible = true
            end
        end
    end
    function Window:Close()
        Utility.Tween(MainFrame, {Size = UDim2.new(0, 0, 0, 0)}, 0.3).Completed:Connect(function()
            ScreenGui:Destroy()
            for _, conn in ipairs(self.Connections) do
                if conn.Disconnect then
                    conn:Disconnect()
                end
            end
        end)
        if self.Shadow then
            Utility.Tween(self.Shadow, {ImageTransparency = 1}, 0.3)
        end
    end
    function Window:SetTitle(title)
        if self.TitleLabel then
            self.TitleLabel.Text = title
        end
    end
    function Window:SetVisible(visible)
        self.Visible = visible
        ScreenGui.Enabled = visible
    end
    return Window
end

function Obsidian:CreateButton(tab, config)
    config = Utility.MergeTables({
        Name = "Button",
        Text = nil,
        Description = nil,
        Callback = function() end,
        Confirmation = false,
        ConfirmationText = "Are you sure?",
        Style = "Default",
        Size = "Default",
        Icon = nil,
        Ripple = true,
        Sound = false
    }, config)
    local Button = {}
    Button.Config = config
    Button.Hovering = false
    local height = config.Size == "Small" and 35 or config.Size == "Large" and 50 or 40
    local Frame = Utility.Create("Frame", {
        Name = config.Name,
        Parent = tab.Content,
        BackgroundColor3 = Obsidian.Theme.ElementBackground,
        BorderSizePixel = 0,
        Size = UDim2.new(1, 0, 0, height),
        LayoutOrder = #tab.Elements
    })
    Button.Frame = Frame
    local Corner = Utility.Create("UICorner", {
        CornerRadius = UDim.new(0, 6),
        Parent = Frame
    })
    local iconOffset = 0
    if config.Icon then
        local Icon = Utility.Create("ImageLabel", {
            Parent = Frame,
            BackgroundTransparency = 1,
            Position = UDim2.new(0, 15, 0.5, -8),
            Size = UDim2.new(0, 16, 0, 16),
            Image = config.Icon,
            ImageColor3 = Obsidian.Theme.Text
        })
        iconOffset = 28
    end
    local TextLabel = Utility.Create("TextLabel", {
        Parent = Frame,
        BackgroundTransparency = 1,
        Position = UDim2.new(0, 15 + iconOffset, 0, 0),
        Size = UDim2.new(1, -30 - iconOffset, 1, 0),
        Font = Enum.Font.GothamSemibold,
        Text = config.Text or config.Name,
        TextColor3 = Obsidian.Theme.Text,
        TextSize = 14,
        TextXAlignment = Enum.TextXAlignment.Left
    })
    if config.Description then
        TextLabel.Size = UDim2.new(1, -30 - iconOffset, 0, height / 2)
        TextLabel.Position = UDim2.new(0, 15 + iconOffset, 0, 5)
        local DescLabel = Utility.Create("TextLabel", {
            Parent = Frame,
            BackgroundTransparency = 1,
            Position = UDim2.new(0, 15 + iconOffset, 0, height / 2 + 2),
            Size = UDim2.new(1, -30 - iconOffset, 0, height / 2 - 7),
            Font = Enum.Font.Gotham,
            Text = config.Description,
            TextColor3 = Obsidian.Theme.TextDark,
            TextSize = 12,
            TextXAlignment = Enum.TextXAlignment.Left,
            TextTruncate = Enum.TextTruncate.AtEnd
        })
    end
    local ClickArea = Utility.Create("TextButton", {
        Parent = Frame,
        BackgroundTransparency = 1,
        Size = UDim2.new(1, 0, 1, 0),
        Text = ""
    })
    ClickArea.MouseEnter:Connect(function()
        Button.Hovering = true
        Utility.Tween(Frame, {BackgroundColor3 = Obsidian.Theme.ElementBackgroundHover}, 0.2)
    end)
    ClickArea.MouseLeave:Connect(function()
        Button.Hovering = false
        Utility.Tween(Frame, {BackgroundColor3 = Obsidian.Theme.ElementBackground}, 0.2)
    end)
    ClickArea.MouseButton1Down:Connect(function()
        Utility.Tween(Frame, {BackgroundColor3 = Obsidian.Theme.ElementBackgroundActive}, 0.1)
        if config.Ripple then
            Utility.Ripple(Frame, Obsidian.Theme.Accent, 0.5)
        end
    end)
    ClickArea.MouseButton1Up:Connect(function()
        Utility.Tween(Frame, {BackgroundColor3 = Obsidian.Theme.ElementBackgroundHover}, 0.1)
    end)
    ClickArea.MouseButton1Click:Connect(function()
        if config.Confirmation then
            local confirmed = false
            local dialog = Obsidian:Notify({
                Title = "Confirm",
                Content = config.ConfirmationText,
                Duration = 0,
                Buttons = {
                    {Text = "Cancel", Callback = function() end},
                    {Text = "Confirm", Primary = true, Callback = function() confirmed = true end}
                }
            })
            task.wait(0.1)
            if confirmed then
                config.Callback()
            end
        else
            config.Callback()
        end
    end)
    function Button:SetText(text)
        TextLabel.Text = text
    end
    function Button:SetCallback(callback)
        config.Callback = callback
    end
    function Button:Destroy()
        Frame:Destroy()
    end
    table.insert(tab.Elements, Button)
    return Button
end

function Obsidian:CreateToggle(tab, config)
    config = Utility.MergeTables({
        Name = "Toggle",
        Default = false,
        Callback = function(value) end,
        Description = nil,
        Keybind = nil,
        Save = false,
        SaveKey = nil
    }, config)
    local Toggle = {}
    Toggle.Config = config
    Toggle.Value = config.Default
    Toggle.Hovering = false
    if config.Save and config.SaveKey then
        local saved = Data:Load(config.SaveKey)
        if saved ~= nil then
            Toggle.Value = saved
        end
    end
    local Frame = Utility.Create("Frame", {
        Name = config.Name,
        Parent = tab.Content,
        BackgroundColor3 = Obsidian.Theme.ElementBackground,
        BorderSizePixel = 0,
        Size = UDim2.new(1, 0, 0, config.Description and 55 or 40),
        LayoutOrder = #tab.Elements
    })
    Toggle.Frame = Frame
    local Corner = Utility.Create("UICorner", {
        CornerRadius = UDim.new(0, 6),
        Parent = Frame
    })
    local Label = Utility.Create("TextLabel", {
        Parent = Frame,
        BackgroundTransparency = 1,
        Position = UDim2.new(0, 15, 0, 0),
        Size = UDim2.new(1, -100, config.Description and 0.5 or 1, 0),
        Font = Enum.Font.GothamSemibold,
        Text = config.Name,
        TextColor3 = Obsidian.Theme.Text,
        TextSize = 14,
        TextXAlignment = Enum.TextXAlignment.Left
    })
    if config.Description then
        Label.Position = UDim2.new(0, 15, 0, 5)
        local DescLabel = Utility.Create("TextLabel", {
            Parent = Frame,
            BackgroundTransparency = 1,
            Position = UDim2.new(0, 15, 0, 27),
            Size = UDim2.new(1, -100, 0, 20),
            Font = Enum.Font.Gotham,
            Text = config.Description,
            TextColor3 = Obsidian.Theme.TextDark,
            TextSize = 12,
            TextXAlignment = Enum.TextXAlignment.Left
        })
    end
    local Switch = Utility.Create("Frame", {
        Name = "Switch",
        Parent = Frame,
        BackgroundColor3 = Toggle.Value and Obsidian.Theme.Accent or Obsidian.Theme.Background,
        BorderSizePixel = 0,
        Position = UDim2.new(1, -55, 0.5, -12),
        Size = UDim2.new(0, 44, 0, 24)
    })
    Toggle.Switch = Switch
    local SwitchCorner = Utility.Create("UICorner", {
        CornerRadius = UDim.new(1, 0),
        Parent = Switch
    })
    local Circle = Utility.Create("Frame", {
        Name = "Circle",
        Parent = Switch,
        BackgroundColor3 = Color3.fromRGB(255, 255, 255),
        BorderSizePixel = 0,
        Position = Toggle.Value and UDim2.new(1, -21, 0.5, -9) or UDim2.new(0, 3, 0.5, -9),
        Size = UDim2.new(0, 18, 0, 18)
    })
    Toggle.Circle = Circle
    local CircleCorner = Utility.Create("UICorner", {
        CornerRadius = UDim.new(1, 0),
        Parent = Circle
    })
    local ClickArea = Utility.Create("TextButton", {
        Parent = Frame,
        BackgroundTransparency = 1,
        Size = UDim2.new(1, 0, 1, 0),
        Text = ""
    })
    local function UpdateToggle()
        Toggle.Value = not Toggle.Value
        if Toggle.Value then
            Utility.Tween(Switch, {BackgroundColor3 = Obsidian.Theme.Accent}, 0.2)
            Utility.Tween(Circle, {Position = UDim2.new(1, -21, 0.5, -9)}, 0.2)
        else
            Utility.Tween(Switch, {BackgroundColor3 = Obsidian.Theme.Background}, 0.2)
            Utility.Tween(Circle, {Position = UDim2.new(0, 3, 0.5, -9)}, 0.2)
        end
        if config.Save and config.SaveKey then
            Data:Save(config.SaveKey, Toggle.Value)
        end
        config.Callback(Toggle.Value)
    end
    ClickArea.MouseEnter:Connect(function()
        Toggle.Hovering = true
        Utility.Tween(Frame, {BackgroundColor3 = Obsidian.Theme.ElementBackgroundHover}, 0.2)
    end)
    ClickArea.MouseLeave:Connect(function()
        Toggle.Hovering = false
        Utility.Tween(Frame, {BackgroundColor3 = Obsidian.Theme.ElementBackground}, 0.2)
    end)
    ClickArea.MouseButton1Click:Connect(UpdateToggle)
    if config.Keybind then
        Input:Bind(config.Keybind, UpdateToggle)
    end
    function Toggle:Set(value)
        if Toggle.Value ~= value then
            Toggle.Value = value
            if Toggle.Value then
                Utility.Tween(Switch, {BackgroundColor3 = Obsidian.Theme.Accent}, 0.2)
                Utility.Tween(Circle, {Position = UDim2.new(1, -21, 0.5, -9)}, 0.2)
            else
                Utility.Tween(Switch, {BackgroundColor3 = Obsidian.Theme.Background}, 0.2)
                Utility.Tween(Circle, {Position = UDim2.new(0, 3, 0.5, -9)}, 0.2)
            end
            if config.Save and config.SaveKey then
                Data:Save(config.SaveKey, Toggle.Value)
            end
            config.Callback(Toggle.Value)
        end
    end
    function Toggle:Get()
        return Toggle.Value
    end
    function Toggle:Destroy()
        Frame:Destroy()
    end
    table.insert(tab.Elements, Toggle)
    return Toggle
end

function Obsidian:CreateSlider(tab, config)
    config = Utility.MergeTables({
        Name = "Slider",
        Min = 0,
        Max = 100,
        Default = 50,
        Decimals = 0,
        Callback = function(value) end,
        Description = nil,
        DisplayFormat = "{value}",
        Save = false,
        SaveKey = nil,
        ShowValue = true,
        ValuePosition = "Right"
    }, config)
    local Slider = {}
    Slider.Config = config
    Slider.Value = config.Default
    Slider.Dragging = false
    Slider.Hovering = false
    if config.Save and config.SaveKey then
        local saved = Data:Load(config.SaveKey)
        if saved ~= nil then
            Slider.Value = math.clamp(saved, config.Min, config.Max)
        end
    end
    local Frame = Utility.Create("Frame", {
        Name = config.Name,
        Parent = tab.Content,
        BackgroundColor3 = Obsidian.Theme.ElementBackground,
        BorderSizePixel = 0,
        Size = UDim2.new(1, 0, 0, config.Description and 75 or 60),
        LayoutOrder = #tab.Elements
    })
    Slider.Frame = Frame
    local Corner = Utility.Create("UICorner", {
        CornerRadius = UDim.new(0, 6),
        Parent = Frame
    })
    local Label = Utility.Create("TextLabel", {
        Parent = Frame,
        BackgroundTransparency = 1,
        Position = UDim2.new(0, 15, 0, 8),
        Size = UDim2.new(config.ShowValue and 0.6 or 1, -30, 0, 20),
        Font = Enum.Font.GothamSemibold,
        Text = config.Name,
        TextColor3 = Obsidian.Theme.Text,
        TextSize = 14,
        TextXAlignment = Enum.TextXAlignment.Left
    })
    local ValueLabel
    if config.ShowValue then
        ValueLabel = Utility.Create("TextLabel", {
            Parent = Frame,
            BackgroundTransparency = 1,
            Position = UDim2.new(1, -75, 0, 8),
            Size = UDim2.new(0, 60, 0, 20),
            Font = Enum.Font.GothamSemibold,
            Text = string.gsub(config.DisplayFormat, "{value}", Utility.FormatNumber(Slider.Value, config.Decimals)),
            TextColor3 = Obsidian.Theme.Accent,
            TextSize = 14,
            TextXAlignment = Enum.TextXAlignment.Right
        })
        Slider.ValueLabel = ValueLabel
    end
    if config.Description then
        Label.Size = UDim2.new(config.ShowValue and 0.6 or 1, -30, 0, 18)
        local DescLabel = Utility.Create("TextLabel", {
            Parent = Frame,
            BackgroundTransparency = 1,
            Position = UDim2.new(0, 15, 0, 26),
            Size = UDim2.new(1, -30, 0, 16),
            Font = Enum.Font.Gotham,
            Text = config.Description,
            TextColor3 = Obsidian.Theme.TextDark,
            TextSize = 11,
            TextXAlignment = Enum.TextXAlignment.Left
        })
    end
    local SliderBar = Utility.Create("Frame", {
        Parent = Frame,
        BackgroundColor3 = Obsidian.Theme.Background,
        BorderSizePixel = 0,
        Position = UDim2.new(0, 15, 0, config.Description and 48 or 35),
        Size = UDim2.new(1, -30, 0, 8)
    })
    local SliderBarCorner = Utility.Create("UICorner", {
        CornerRadius = UDim.new(0, 4),
        Parent = SliderBar
    })
    local SliderFill = Utility.Create("Frame", {
        Parent = SliderBar,
        BackgroundColor3 = Obsidian.Theme.Accent,
        BorderSizePixel = 0,
        Size = UDim2.new((Slider.Value - config.Min) / (config.Max - config.Min), 0, 1, 0)
    })
    Slider.SliderFill = SliderFill
    local SliderFillCorner = Utility.Create("UICorner", {
        CornerRadius = UDim.new(0, 4),
        Parent = SliderFill
    })
    local Knob = Utility.Create("Frame", {
        Parent = SliderBar,
        BackgroundColor3 = Color3.fromRGB(255, 255, 255),
        BorderSizePixel = 0,
        Position = UDim2.new((Slider.Value - config.Min) / (config.Max - config.Min), -8, 0.5, -8),
        Size = UDim2.new(0, 16, 0, 16),
        ZIndex = 2
    })
    Slider.Knob = Knob
    local KnobCorner = Utility.Create("UICorner", {
        CornerRadius = UDim.new(1, 0),
        Parent = Knob
    })
    local KnobGlow = Utility.Create("Frame", {
        Parent = Knob,
        BackgroundColor3 = Obsidian.Theme.Accent,
        BackgroundTransparency = 0.8,
        BorderSizePixel = 0,
        Position = UDim2.new(0.5, 0, 0.5, 0),
        AnchorPoint = Vector2.new(0.5, 0.5),
        Size = UDim2.new(1, 0, 1, 0),
        ZIndex = 1
    })
    local KnobGlowCorner = Utility.Create("UICorner", {
        CornerRadius = UDim.new(1, 0),
        Parent = KnobGlow
    })
    local ClickArea = Utility.Create("TextButton", {
        Parent = SliderBar,
        BackgroundTransparency = 1,
        Size = UDim2.new(1, 0, 1, 0),
        Text = ""
    })
    local function UpdateValue(input)
        local pos = math.clamp((input.Position.X - SliderBar.AbsolutePosition.X) / SliderBar.AbsoluteSize.X, 0, 1)
        local value = config.Min + (config.Max - config.Min) * pos
        value = math.floor(value * (10 ^ config.Decimals) + 0.5) / (10 ^ config.Decimals)
        value = math.clamp(value, config.Min, config.Max)
        Slider.Value = value
        if ValueLabel then
            ValueLabel.Text = string.gsub(config.DisplayFormat, "{value}", Utility.FormatNumber(value, config.Decimals))
        end
        SliderFill.Size = UDim2.new(pos, 0, 1, 0)
        Knob.Position = UDim2.new(pos, -8, 0.5, -8)
        if config.Save and config.SaveKey then
            Data:Save(config.SaveKey, value)
        end
        config.Callback(value)
    end
    ClickArea.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or 
           input.UserInputType == Enum.UserInputType.Touch then
            Slider.Dragging = true
            UpdateValue(input)
            Utility.Tween(KnobGlow, {Size = UDim2.new(1.5, 0, 1.5, 0)}, 0.2)
        end
    end)
    UserInputService.InputChanged:Connect(function(input)
        if Slider.Dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or 
                               input.UserInputType == Enum.UserInputType.Touch) then
            UpdateValue(input)
        end
    end)
    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or 
           input.UserInputType == Enum.UserInputType.Touch then
            Slider.Dragging = false
            Utility.Tween(KnobGlow, {Size = UDim2.new(1, 0, 1, 0)}, 0.2)
        end
    end)
    ClickArea.MouseEnter:Connect(function()
        Slider.Hovering = true
        Utility.Tween(Frame, {BackgroundColor3 = Obsidian.Theme.ElementBackgroundHover}, 0.2)
    end)
    ClickArea.MouseLeave:Connect(function()
        Slider.Hovering = false
        Utility.Tween(Frame, {BackgroundColor3 = Obsidian.Theme.ElementBackground}, 0.2)
    end)
    function Slider:Set(value)
        value = math.clamp(value, config.Min, config.Max)
        value = math.floor(value * (10 ^ config.Decimals) + 0.5) / (10 ^ config.Decimals)
        Slider.Value = value
        local pos = (value - config.Min) / (config.Max - config.Min)
        if ValueLabel then
            ValueLabel.Text = string.gsub(config.DisplayFormat, "{value}", Utility.FormatNumber(value, config.Decimals))
        end
        Utility.Tween(SliderFill, {Size = UDim2.new(pos, 0, 1, 0)}, 0.2)
        Utility.Tween(Knob, {Position = UDim2.new(pos, -8, 0.5, -8)}, 0.2)
        if config.Save and config.SaveKey then
            Data:Save(config.SaveKey, value)
        end
        config.Callback(value)
    end
    function Slider:Get()
        return Slider.Value
    end
    function Slider:Destroy()
        Frame:Destroy()
    end
    table.insert(tab.Elements, Slider)
    return Slider
end

function Obsidian:CreateDropdown(tab, config)
    config = Utility.MergeTables({
        Name = "Dropdown",
        Options = {},
        Default = nil,
        Callback = function(option) end,
        Description = nil,
        MultiSelect = false,
        MaxDisplay = 5,
        Searchable = false,
        Save = false,
        SaveKey = nil
    }, config)
    local Dropdown = {}
    Dropdown.Config = config
    Dropdown.Value = config.Default
    Dropdown.Open = false
    Dropdown.Options = Utility.CloneTable(config.Options)
    Dropdown.Hovering = false
    if config.Save and config.SaveKey then
        local saved = Data:Load(config.SaveKey)
        if saved ~= nil then
            Dropdown.Value = saved
        end
    end
    local Frame = Utility.Create("Frame", {
        Name = config.Name,
        Parent = tab.Content,
        BackgroundColor3 = Obsidian.Theme.ElementBackground,
        BorderSizePixel = 0,
        Size = UDim2.new(1, 0, 0, config.Description and 75 or 60),
        ClipsDescendants = true,
        LayoutOrder = #tab.Elements
    })
    Dropdown.Frame = Frame
    local Corner = Utility.Create("UICorner", {
        CornerRadius = UDim.new(0, 6),
        Parent = Frame
    })
    local Label = Utility.Create("TextLabel", {
        Parent = Frame,
        BackgroundTransparency = 1,
        Position = UDim2.new(0, 15, 0, 8),
        Size = UDim2.new(1, -30, 0, 20),
        Font = Enum.Font.GothamSemibold,
        Text = config.Name,
        TextColor3 = Obsidian.Theme.Text,
        TextSize = 14,
        TextXAlignment = Enum.TextXAlignment.Left
    })
    if config.Description then
        local DescLabel = Utility.Create("TextLabel", {
            Parent = Frame,
            BackgroundTransparency = 1,
            Position = UDim2.new(0, 15, 0, 28),
            Size = UDim2.new(1, -30, 0, 16),
            Font = Enum.Font.Gotham,
            Text = config.Description,
            TextColor3 = Obsidian.Theme.TextDark,
            TextSize = 11,
            TextXAlignment = Enum.TextXAlignment.Left
        })
    end
    local DropdownBox = Utility.Create("Frame", {
        Parent = Frame,
        BackgroundColor3 = Obsidian.Theme.Background,
        BorderSizePixel = 0,
        Position = UDim2.new(0, 15, 0, config.Description and 48 or 35),
        Size = UDim2.new(1, -30, 0, 30)
    })
    Dropdown.DropdownBox = DropdownBox
    local DropdownBoxCorner = Utility.Create("UICorner", {
        CornerRadius = UDim.new(0, 6),
        Parent = DropdownBox
    })
    local SelectedText = Utility.Create("TextLabel", {
        Parent = DropdownBox,
        BackgroundTransparency = 1,
        Position = UDim2.new(0, 12, 0, 0),
        Size = UDim2.new(1, -40, 1, 0),
        Font = Enum.Font.Gotham,
        Text = Dropdown.Value or "Select...",
        TextColor3 = Dropdown.Value and Obsidian.Theme.Text or Obsidian.Theme.TextDark,
        TextSize = 13,
        TextXAlignment = Enum.TextXAlignment.Left,
        TextTruncate = Enum.TextTruncate.AtEnd
    })
    Dropdown.SelectedText = SelectedText
    local Arrow = Utility.Create("ImageLabel", {
        Parent = DropdownBox,
        BackgroundTransparency = 1,
        Position = UDim2.new(1, -28, 0.5, -8),
        Size = UDim2.new(0, 16, 0, 16),
        Image = "rbxassetid://3944668821",
        ImageColor3 = Obsidian.Theme.TextDark
    })
    Dropdown.Arrow = Arrow
    local OptionsFrame = Utility.Create("Frame", {
        Parent = Frame,
        BackgroundTransparency = 1,
        Position = UDim2.new(0, 15, 0, config.Description and 83 or 70),
        Size = UDim2.new(1, -30, 0, 0),
        ClipsDescendants = true
    })
    Dropdown.OptionsFrame = OptionsFrame
    local OptionsLayout = Utility.Create("UIListLayout", {
        Parent = OptionsFrame,
        SortOrder = Enum.SortOrder.LayoutOrder,
        Padding = UDim.new(0, 4)
    })
    local OptionsPadding = Utility.Create("UIPadding", {
        Parent = OptionsFrame,
        PaddingTop = UDim.new(0, 5)
    })
    local ClickArea = Utility.Create("TextButton", {
        Parent = DropdownBox,
        BackgroundTransparency = 1,
        Size = UDim2.new(1, 0, 1, 0),
        Text = ""
    })
    local function CreateOptions()
        for _, child in ipairs(OptionsFrame:GetChildren()) do
            if child:IsA("TextButton") then
                child:Destroy()
            end
        end
        for i, option in ipairs(Dropdown.Options) do
            local OptionButton = Utility.Create("TextButton", {
                Parent = OptionsFrame,
                BackgroundColor3 = Obsidian.Theme.Background,
                BorderSizePixel = 0,
                Size = UDim2.new(1, 0, 0, 30),
                Font = Enum.Font.Gotham,
                Text = "  " .. tostring(option),
                TextColor3 = Obsidian.Theme.Text,
                TextSize = 13,
                TextXAlignment = Enum.TextXAlignment.Left,
                LayoutOrder = i,
                AutoButtonColor = false
            })
            local OptionCorner = Utility.Create("UICorner", {
                CornerRadius = UDim.new(0, 4),
                Parent = OptionButton
            })
            if option == Dropdown.Value then
                OptionButton.BackgroundColor3 = Obsidian.Theme.Accent
            end
            OptionButton.MouseEnter:Connect(function()
                if option ~= Dropdown.Value then
                    Utility.Tween(OptionButton, {BackgroundColor3 = Obsidian.Theme.ElementBackgroundHover}, 0.2)
                end
            end)
            OptionButton.MouseLeave:Connect(function()
                if option ~= Dropdown.Value then
                    Utility.Tween(OptionButton, {BackgroundColor3 = Obsidian.Theme.Background}, 0.2)
                end
            end)
            OptionButton.MouseButton1Click:Connect(function()
                Dropdown.Value = option
                SelectedText.Text = tostring(option)
                SelectedText.TextColor3 = Obsidian.Theme.Text
                if config.Save and config.SaveKey then
                    Data:Save(config.SaveKey, option)
                end
                config.Callback(option)
                Dropdown:Toggle()
                CreateOptions()
            end)
        end
    end
    CreateOptions()
    function Dropdown:Toggle()
        Dropdown.Open = not Dropdown.Open
        if Dropdown.Open then
            local optionsHeight = math.min(#Dropdown.Options * 34, config.MaxDisplay * 34)
            Utility.Tween(Frame, {Size = UDim2.new(1, 0, 0, (config.Description and 75 or 60) + optionsHeight + 10)}, 0.3)
            Utility.Tween(Arrow, {Rotation = 180}, 0.3)
            Utility.Tween(OptionsFrame, {Size = UDim2.new(1, -30, 0, optionsHeight)}, 0.3)
        else
            Utility.Tween(Frame, {Size = UDim2.new(1, 0, 0, config.Description and 75 or 60)}, 0.3)
            Utility.Tween(Arrow, {Rotation = 0}, 0.3)
            Utility.Tween(OptionsFrame, {Size = UDim2.new(1, -30, 0, 0)}, 0.3)
        end
    end
    ClickArea.MouseButton1Click:Connect(function()
        Dropdown:Toggle()
    end)
    ClickArea.MouseEnter:Connect(function()
        Dropdown.Hovering = true
        Utility.Tween(Frame, {BackgroundColor3 = Obsidian.Theme.ElementBackgroundHover}, 0.2)
    end)
    ClickArea.MouseLeave:Connect(function()
        Dropdown.Hovering = false
        Utility.Tween(Frame, {BackgroundColor3 = Obsidian.Theme.ElementBackground}, 0.2)
    end)
    function Dropdown:Set(option)
        Dropdown.Value = option
        SelectedText.Text = tostring(option)
        SelectedText.TextColor3 = Obsidian.Theme.Text
        CreateOptions()
        if config.Save and config.SaveKey then
            Data:Save(config.SaveKey, option)
        end
        config.Callback(option)
    end
    function Dropdown:Get()
        return Dropdown.Value
    end
    function Dropdown:SetOptions(options)
        Dropdown.Options = Utility.CloneTable(options)
        CreateOptions()
    end
    function Dropdown:Destroy()
        Frame:Destroy()
    end
    table.insert(tab.Elements, Dropdown)
    return Dropdown
end

function Obsidian:CreateTextbox(tab, config)
    config = Utility.MergeTables({
        Name = "Textbox",
        Default = "",
        Placeholder = "Enter text...",
        Callback = function(text) end,
        Description = nil,
        Numeric = false,
        ClearOnFocus = false,
        Save = false,
        SaveKey = nil,
        MaxLength = nil,
        Font = Enum.Font.Gotham,
        TextSize = 13
    }, config)
    local Textbox = {}
    Textbox.Config = config
    Textbox.Value = config.Default
    Textbox.Hovering = false
    Textbox.Focused = false
    if config.Save and config.SaveKey then
        local saved = Data:Load(config.SaveKey)
        if saved ~= nil then
            Textbox.Value = saved
        end
    end
    local Frame = Utility.Create("Frame", {
        Name = config.Name,
        Parent = tab.Content,
        BackgroundColor3 = Obsidian.Theme.ElementBackground,
        BorderSizePixel = 0,
        Size = UDim2.new(1, 0, 0, config.Description and 85 or 70),
        LayoutOrder = #tab.Elements
    })
    Textbox.Frame = Frame
    local Corner = Utility.Create("UICorner", {
        CornerRadius = UDim.new(0, 6),
        Parent = Frame
    })
    local Label = Utility.Create("TextLabel", {
        Parent = Frame,
        BackgroundTransparency = 1,
        Position = UDim2.new(0, 15, 0, 8),
        Size = UDim2.new(1, -30, 0, 20),
        Font = Enum.Font.GothamSemibold,
        Text = config.Name,
        TextColor3 = Obsidian.Theme.Text,
        TextSize = 14,
        TextXAlignment = Enum.TextXAlignment.Left
    })
    if config.Description then
        local DescLabel = Utility.Create("TextLabel", {
            Parent = Frame,
            BackgroundTransparency = 1,
            Position = UDim2.new(0, 15, 0, 28),
            Size = UDim2.new(1, -30, 0, 16),
            Font = Enum.Font.Gotham,
            Text = config.Description,
            TextColor3 = Obsidian.Theme.TextDark,
            TextSize = 11,
            TextXAlignment = Enum.TextXAlignment.Left
        })
    end
    local InputFrame = Utility.Create("Frame", {
        Parent = Frame,
        BackgroundColor3 = Obsidian.Theme.Background,
        BorderSizePixel = 0,
        Position = UDim2.new(0, 15, 0, config.Description and 50 or 35),
        Size = UDim2.new(1, -30, 0, 30)
    })
    local InputCorner = Utility.Create("UICorner", {
        CornerRadius = UDim.new(0, 6),
        Parent = InputFrame
    })
    local TextBox = Utility.Create("TextBox", {
        Parent = InputFrame,
        BackgroundTransparency = 1,
        Position = UDim2.new(0, 12, 0, 0),
        Size = UDim2.new(1, -24, 1, 0),
        Font = config.Font,
        Text = Textbox.Value,
        TextColor3 = Obsidian.Theme.Text,
        TextSize = config.TextSize,
        ClearTextOnFocus = config.ClearOnFocus,
        PlaceholderText = config.Placeholder,
        PlaceholderColor3 = Obsidian.Theme.TextDark
    })
    Textbox.TextBox = TextBox
    TextBox.Focused:Connect(function()
        Textbox.Focused = true
        Utility.Tween(InputFrame, {BackgroundColor3 = Obsidian.Theme.ElementBackgroundHover}, 0.2)
    end)
    TextBox.FocusLost:Connect(function()
        Textbox.Focused = false
        Utility.Tween(InputFrame, {BackgroundColor3 = Obsidian.Theme.Background}, 0.2)
        local text = TextBox.Text
        if config.Numeric then
            text = tonumber(text) or 0
            TextBox.Text = tostring(text)
        end
        if config.MaxLength and #text > config.MaxLength then
            text = text:sub(1, config.MaxLength)
            TextBox.Text = text
        end
        Textbox.Value = text
        if config.Save and config.SaveKey then
            Data:Save(config.SaveKey, text)
        end
        config.Callback(text)
    end)
    TextBox:GetPropertyChangedSignal("Text"):Connect(function()
        if config.Numeric then
            local text = TextBox.Text
            if text ~= "" and not tonumber(text) then
                TextBox.Text = text:gsub("[^%d.-]", "")
            end
        end
        if config.MaxLength and #TextBox.Text > config.MaxLength then
            TextBox.Text = TextBox.Text:sub(1, config.MaxLength)
        end
    end)
    InputFrame.MouseEnter:Connect(function()
        if not Textbox.Focused then
            Textbox.Hovering = true
            Utility.Tween(Frame, {BackgroundColor3 = Obsidian.Theme.ElementBackgroundHover}, 0.2)
        end
    end)
    InputFrame.MouseLeave:Connect(function()
        if not Textbox.Focused then
            Textbox.Hovering = false
            Utility.Tween(Frame, {BackgroundColor3 = Obsidian.Theme.ElementBackground}, 0.2)
        end
    end)
    function Textbox:Set(text)
        Textbox.Value = text
        TextBox.Text = tostring(text)
        if config.Save and config.SaveKey then
            Data:Save(config.SaveKey, text)
        end
        config.Callback(text)
    end
    function Textbox:Get()
        return Textbox.Value
    end
    function Textbox:Destroy()
        Frame:Destroy()
    end
    table.insert(tab.Elements, Textbox)
    return Textbox
end

function Obsidian:CreateLabel(tab, config)
    config = Utility.MergeTables({
        Text = "Label",
        Color = nil,
        Font = Enum.Font.Gotham,
        TextSize = 13,
        Alignment = Enum.TextXAlignment.Left,
        Wrapped = false,
        RichText = false
    }, config)
    local Label = {}
    Label.Config = config
    local textBounds = Utility.GetTextBounds(config.Text, config.Font, config.TextSize, 560)
    local height = config.Wrapped and math.max(30, textBounds.Y + 10) or 30
    local Frame = Utility.Create("Frame", {
        Name = "Label",
        Parent = tab.Content,
        BackgroundTransparency = 1,
        Size = UDim2.new(1, 0, 0, height),
        LayoutOrder = #tab.Elements
    })
    Label.Frame = Frame
    local TextLabel = Utility.Create("TextLabel", {
        Parent = Frame,
        BackgroundTransparency = 1,
        Size = UDim2.new(1, 0, 1, 0),
        Font = config.Font,
        Text = config.Text,
        TextColor3 = config.Color or Obsidian.Theme.TextDark,
        TextSize = config.TextSize,
        TextWrapped = config.Wrapped,
        TextXAlignment = config.Alignment,
        RichText = config.RichText
    })
    Label.TextLabel = TextLabel
    function Label:Set(text)
        Label.Config.Text = text
        TextLabel.Text = text
        if config.Wrapped then
            local newBounds = Utility.GetTextBounds(text, config.Font, config.TextSize, 560)
            Frame.Size = UDim2.new(1, 0, 0, math.max(30, newBounds.Y + 10))
        end
    end
    function Label:SetColor(color)
        TextLabel.TextColor3 = color
    end
    function Label:Destroy()
        Frame:Destroy()
    end
    table.insert(tab.Elements, Label)
    return Label
end

function Obsidian:CreateSection(tab, config)
    config = Utility.MergeTables({
        Name = "Section",
        TextColor = nil,
        HasLine = true,
        LineColor = nil
    }, config)
    local Section = {}
    Section.Config = config
    local Frame = Utility.Create("Frame", {
        Name = config.Name,
        Parent = tab.Content,
        BackgroundTransparency = 1,
        Size = UDim2.new(1, 0, 0, 35),
        LayoutOrder = #tab.Elements
    })
    Section.Frame = Frame
    local Label = Utility.Create("TextLabel", {
        Parent = Frame,
        BackgroundTransparency = 1,
        Position = UDim2.new(0, 0, 0, 5),
        Size = UDim2.new(1, 0, 0, 25),
        Font = Enum.Font.GothamBold,
        Text = config.Name,
        TextColor3 = config.TextColor or Obsidian.Theme.Accent,
        TextSize = 14,
        TextXAlignment = Enum.TextXAlignment.Left
    })
    if config.HasLine then
        local Line = Utility.Create("Frame", {
            Parent = Frame,
            BackgroundColor3 = config.LineColor or Obsidian.Theme.Border,
            BorderSizePixel = 0,
            Position = UDim2.new(0, 0, 1, -2),
            Size = UDim2.new(1, 0, 0, 1)
        })
    end
    function Section:SetName(name)
        Label.Text = name
    end
    function Section:Destroy()
        Frame:Destroy()
    end
    table.insert(tab.Elements, Section)
    return Section
end

function Obsidian:CreateColorPicker(tab, config)
    config = Utility.MergeTables({
        Name = "ColorPicker",
        Default = Color3.fromRGB(255, 255, 255),
        Callback = function(color) end,
        Description = nil,
        Save = false,
        SaveKey = nil,
        ShowRGB = true,
        ShowHex = true
    }, config)
    local ColorPicker = {}
    ColorPicker.Config = config
    ColorPicker.Value = config.Default
    ColorPicker.Open = false
    ColorPicker.Hovering = false
    if config.Save and config.SaveKey then
        local saved = Data:Load(config.SaveKey)
        if saved and typeof(saved) == "table" and saved.R then
            ColorPicker.Value = Color3.fromRGB(saved.R, saved.G, saved.B)
        end
    end
    local Frame = Utility.Create("Frame", {
        Name = config.Name,
        Parent = tab.Content,
        BackgroundColor3 = Obsidian.Theme.ElementBackground,
        BorderSizePixel = 0,
        Size = UDim2.new(1, 0, 0, config.Description and 75 or 60),
        ClipsDescendants = true,
        LayoutOrder = #tab.Elements
    })
    ColorPicker.Frame = Frame
    local Corner = Utility.Create("UICorner", {
        CornerRadius = UDim.new(0, 6),
        Parent = Frame
    })
    local Label = Utility.Create("TextLabel", {
        Parent = Frame,
        BackgroundTransparency = 1,
        Position = UDim2.new(0, 15, 0, 8),
        Size = UDim2.new(1, -100, 0, 20),
        Font = Enum.Font.GothamSemibold,
        Text = config.Name,
        TextColor3 = Obsidian.Theme.Text,
        TextSize = 14,
        TextXAlignment = Enum.TextXAlignment.Left
    })
    if config.Description then
        local DescLabel = Utility.Create("TextLabel", {
            Parent = Frame,
            BackgroundTransparency = 1,
            Position = UDim2.new(0, 15, 0, 28),
            Size = UDim2.new(1, -100, 0, 16),
            Font = Enum.Font.Gotham,
            Text = config.Description,
            TextColor3 = Obsidian.Theme.TextDark,
            TextSize = 11,
            TextXAlignment = Enum.TextXAlignment.Left
        })
    end
    local ColorDisplay = Utility.Create("Frame", {
        Parent = Frame,
        BackgroundColor3 = ColorPicker.Value,
        BorderSizePixel = 0,
        Position = UDim2.new(1, -55, 0, config.Description and 20 or 15),
        Size = UDim2.new(0, 40, 0, 25)
    })
    ColorPicker.ColorDisplay = ColorDisplay
    local ColorDisplayCorner = Utility.Create("UICorner", {
        CornerRadius = UDim.new(0, 4),
        Parent = ColorDisplay
    })
    local ColorDisplayStroke = Utility.Create("UIStroke", {
        Color = Obsidian.Theme.Border,
        Thickness = 1,
        Parent = ColorDisplay
    })
    local PickerContainer = Utility.Create("Frame", {
        Parent = Frame,
        BackgroundColor3 = Obsidian.Theme.Background,
        BorderSizePixel = 0,
        Position = UDim2.new(0, 15, 0, config.Description and 50 or 50),
        Size = UDim2.new(1, -30, 0, 0),
        ClipsDescendants = true
    })
    ColorPicker.PickerContainer = PickerContainer
    local PickerCorner = Utility.Create("UICorner", {
        CornerRadius = UDim.new(0, 6),
        Parent = PickerContainer
    })
    local SVBox = Utility.Create("Frame", {
        Parent = PickerContainer,
        BackgroundColor3 = Color3.fromRGB(255, 0, 0),
        BorderSizePixel = 0,
        Position = UDim2.new(0, 10, 0, 10),
        Size = UDim2.new(0, 150, 0, 100)
    })
    local SVBoxCorner = Utility.Create("UICorner", {
        CornerRadius = UDim.new(0, 4),
        Parent = SVBox
    })
    local WhiteGradient = Utility.Create("UIGradient", {
        Color = ColorSequence.new({
            ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 255, 255)),
            ColorSequenceKeypoint.new(1, Color3.fromRGB(255, 255, 255))
        }),
        Transparency = NumberSequence.new({
            NumberSequenceKeypoint.new(0, 0),
            NumberSequenceKeypoint.new(1, 1)
        }),
        Parent = SVBox
    })
    local BlackFrame = Utility.Create("Frame", {
        Parent = SVBox,
        BackgroundColor3 = Color3.fromRGB(0, 0, 0),
        BorderSizePixel = 0,
        Size = UDim2.new(1, 0, 1, 0)
    })
    local BlackGradient = Utility.Create("UIGradient", {
        Color = ColorSequence.new({
            ColorSequenceKeypoint.new(0, Color3.fromRGB(0, 0, 0)),
            ColorSequenceKeypoint.new(1, Color3.fromRGB(0, 0, 0))
        }),
        Transparency = NumberSequence.new({
            NumberSequenceKeypoint.new(0, 1),
            NumberSequenceKeypoint.new(1, 0)
        }),
        Rotation = 90,
        Parent = BlackFrame
    })
    local SVCursor = Utility.Create("Frame", {
        Parent = SVBox,
        BackgroundColor3 = Color3.fromRGB(255, 255, 255),
        BorderSizePixel = 0,
        Position = UDim2.new(1, -6, 0, -6),
        Size = UDim2.new(0, 12, 0, 12),
        AnchorPoint = Vector2.new(0.5, 0.5)
    })
    local SVCursorCorner = Utility.Create("UICorner", {
        CornerRadius = UDim.new(1, 0),
        Parent = SVCursor
    })
    local SVCursorStroke = Utility.Create("UIStroke", {
        Color = Color3.fromRGB(0, 0, 0),
        Thickness = 2,
        Parent = SVCursor
    })
    local HueBar = Utility.Create("Frame", {
        Parent = PickerContainer,
        BackgroundColor3 = Color3.fromRGB(255, 255, 255),
        BorderSizePixel = 0,
        Position = UDim2.new(0, 170, 0, 10),
        Size = UDim2.new(0, 20, 0, 100)
    })
    local HueGradient = Utility.Create("UIGradient", {
        Color = ColorSequence.new({
            ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 0, 0)),
            ColorSequenceKeypoint.new(0.167, Color3.fromRGB(255, 255, 0)),
            ColorSequenceKeypoint.new(0.333, Color3.fromRGB(0, 255, 0)),
            ColorSequenceKeypoint.new(0.5, Color3.fromRGB(0, 255, 255)),
            ColorSequenceKeypoint.new(0.667, Color3.fromRGB(0, 0, 255)),
            ColorSequenceKeypoint.new(0.833, Color3.fromRGB(255, 0, 255)),
            ColorSequenceKeypoint.new(1, Color3.fromRGB(255, 0, 0))
        }),
        Parent = HueBar
    })
    local HueBarCorner = Utility.Create("UICorner", {
        CornerRadius = UDim.new(0, 4),
        Parent = HueBar
    })
    local HueCursor = Utility.Create("Frame", {
        Parent = HueBar,
        BackgroundColor3 = Color3.fromRGB(255, 255, 255),
        BorderSizePixel = 0,
        Position = UDim2.new(0.5, 0, 0, 0),
        Size = UDim2.new(1, 4, 0, 4),
        AnchorPoint = Vector2.new(0.5, 0.5)
    })
    local HueCursorCorner = Utility.Create("UICorner", {
        CornerRadius = UDim.new(0, 2),
        Parent = HueCursor
    })
    local HueCursorStroke = Utility.Create("UIStroke", {
        Color = Color3.fromRGB(0, 0, 0),
        Thickness = 1,
        Parent = HueCursor
    })
    if config.ShowRGB then
        local RGBFrame = Utility.Create("Frame", {
            Parent = PickerContainer,
            BackgroundTransparency = 1,
            Position = UDim2.new(0, 10, 0, 120),
            Size = UDim2.new(1, -20, 0, 30)
        })
        local RGBLayout = Utility.Create("UIListLayout", {
            Parent = RGBFrame,
            FillDirection = Enum.FillDirection.Horizontal,
            Padding = UDim.new(0, 10)
        })
        local function CreateRGBBox(name, default)
            local Box = Utility.Create("TextBox", {
                Parent = RGBFrame,
                BackgroundColor3 = Obsidian.Theme.ElementBackground,
                BorderSizePixel = 0,
                Size = UDim2.new(0, 50, 1, 0),
                Font = Enum.Font.Gotham,
                Text = tostring(default),
                TextColor3 = Obsidian.Theme.Text,
                TextSize = 12,
                ClearTextOnFocus = false
            })
            local BoxCorner = Utility.Create("UICorner", {
                CornerRadius = UDim.new(0, 4),
                Parent = Box
            })
            return Box
        end
        ColorPicker.RBox = CreateRGBBox("R", math.floor(ColorPicker.Value.R * 255))
        ColorPicker.GBox = CreateRGBBox("G", math.floor(ColorPicker.Value.G * 255))
        ColorPicker.BBox = CreateRGBBox("B", math.floor(ColorPicker.Value.B * 255))
    end
    if config.ShowHex then
        local HexFrame = Utility.Create("Frame", {
            Parent = PickerContainer,
            BackgroundTransparency = 1,
            Position = UDim2.new(0, 10, 0, 160),
            Size = UDim2.new(1, -20, 0, 30)
        })
        local HexLabel = Utility.Create("TextLabel", {
            Parent = HexFrame,
            BackgroundTransparency = 1,
            Size = UDim2.new(0, 40, 1, 0),
            Font = Enum.Font.Gotham,
            Text = "Hex:",
            TextColor3 = Obsidian.Theme.TextDark,
            TextSize = 12,
            TextXAlignment = Enum.TextXAlignment.Left
        })
        ColorPicker.HexBox = Utility.Create("TextBox", {
            Parent = HexFrame,
            BackgroundColor3 = Obsidian.Theme.ElementBackground,
            BorderSizePixel = 0,
            Position = UDim2.new(0, 40, 0, 0),
            Size = UDim2.new(0, 80, 1, 0),
            Font = Enum.Font.Gotham,
            Text = Utility.ColorToHex(ColorPicker.Value),
            TextColor3 = Obsidian.Theme.Text,
            TextSize = 12,
            ClearTextOnFocus = false
        })
        local HexCorner = Utility.Create("UICorner", {
            CornerRadius = UDim.new(0, 4),
            Parent = ColorPicker.HexBox
        })
    end
    local hue, sat, val = ColorPicker.Value:ToHSV()
    local function UpdateColorFromHSV(h, s, v)
        local color = Color3.fromHSV(h, s, v)
        ColorPicker.Value = color
        ColorDisplay.BackgroundColor3 = color
        SVBox.BackgroundColor3 = Color3.fromHSV(h, 1, 1)
        if ColorPicker.RBox then
            ColorPicker.RBox.Text = tostring(math.floor(color.R * 255))
        end
        if ColorPicker.GBox then
            ColorPicker.GBox.Text = tostring(math.floor(color.G * 255))
        end
        if ColorPicker.BBox then
            ColorPicker.BBox.Text = tostring(math.floor(color.B * 255))
        end
        if ColorPicker.HexBox then
            ColorPicker.HexBox.Text = Utility.ColorToHex(color)
        end
        if config.Save and config.SaveKey then
            Data:Save(config.SaveKey, {R = math.floor(color.R * 255), G = math.floor(color.G * 255), B = math.floor(color.B * 255)})
        end
        config.Callback(color)
    end
    local svDragging = false
    local hueDragging = false
    SVBox.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            svDragging = true
            local x = math.clamp((input.Position.X - SVBox.AbsolutePosition.X) / SVBox.AbsoluteSize.X, 0, 1)
            local y = math.clamp((input.Position.Y - SVBox.AbsolutePosition.Y) / SVBox.AbsoluteSize.Y, 0, 1)
            sat = x
            val = 1 - y
            SVCursor.Position = UDim2.new(x, 0, y, 0)
            UpdateColorFromHSV(hue, sat, val)
        end
    end)
    HueBar.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            hueDragging = true
            local y = math.clamp((input.Position.Y - HueBar.AbsolutePosition.Y) / HueBar.AbsoluteSize.Y, 0, 1)
            hue = 1 - y
            HueCursor.Position = UDim2.new(0.5, 0, y, 0)
            UpdateColorFromHSV(hue, sat, val)
        end
    end)
    UserInputService.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement then
            if svDragging then
                local x = math.clamp((input.Position.X - SVBox.AbsolutePosition.X) / SVBox.AbsoluteSize.X, 0, 1)
                local y = math.clamp((input.Position.Y - SVBox.AbsolutePosition.Y) / SVBox.AbsoluteSize.Y, 0, 1)
                sat = x
                val = 1 - y
                SVCursor.Position = UDim2.new(x, 0, y, 0)
                UpdateColorFromHSV(hue, sat, val)
            elseif hueDragging then
                local y = math.clamp((input.Position.Y - HueBar.AbsolutePosition.Y) / HueBar.AbsoluteSize.Y, 0, 1)
                hue = 1 - y
                HueCursor.Position = UDim2.new(0.5, 0, y, 0)
                UpdateColorFromHSV(hue, sat, val)
            end
        end
    end)
    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            svDragging = false
            hueDragging = false
        end
    end)
    local ClickArea = Utility.Create("TextButton", {
        Parent = Frame,
        BackgroundTransparency = 1,
        Size = UDim2.new(1, 0, 0, config.Description and 75 or 60),
        Text = ""
    })
    ClickArea.MouseButton1Click:Connect(function()
        ColorPicker.Open = not ColorPicker.Open
        if ColorPicker.Open then
            Utility.Tween(Frame, {Size = UDim2.new(1, 0, 0, config.Description and 260 or 245)}, 0.3)
            Utility.Tween(PickerContainer, {Size = UDim2.new(1, -30, 0, 200)}, 0.3)
        else
            Utility.Tween(Frame, {Size = UDim2.new(1, 0, 0, config.Description and 75 or 60)}, 0.3)
            Utility.Tween(PickerContainer, {Size = UDim2.new(1, -30, 0, 0)}, 0.3)
        end
    end)
    ClickArea.MouseEnter:Connect(function()
        ColorPicker.Hovering = true
        Utility.Tween(Frame, {BackgroundColor3 = Obsidian.Theme.ElementBackgroundHover}, 0.2)
    end)
    ClickArea.MouseLeave:Connect(function()
        ColorPicker.Hovering = false
        Utility.Tween(Frame, {BackgroundColor3 = Obsidian.Theme.ElementBackground}, 0.2)
    end)
    function ColorPicker:Set(color)
        ColorPicker.Value = color
        ColorDisplay.BackgroundColor3 = color
        local h, s, v = color:ToHSV()
        hue, sat, val = h, s, v
        SVBox.BackgroundColor3 = Color3.fromHSV(h, 1, 1)
        SVCursor.Position = UDim2.new(s, 0, 1 - v, 0)
        HueCursor.Position = UDim2.new(0.5, 0, 1 - h, 0)
        if ColorPicker.RBox then
            ColorPicker.RBox.Text = tostring(math.floor(color.R * 255))
        end
        if ColorPicker.GBox then
            ColorPicker.GBox.Text = tostring(math.floor(color.G * 255))
        end
        if ColorPicker.BBox then
            ColorPicker.BBox.Text = tostring(math.floor(color.B * 255))
        end
        if ColorPicker.HexBox then
            ColorPicker.HexBox.Text = Utility.ColorToHex(color)
        end
        if config.Save and config.SaveKey then
            Data:Save(config.SaveKey, {R = math.floor(color.R * 255), G = math.floor(color.G * 255), B = math.floor(color.B * 255)})
        end
        config.Callback(color)
    end
    function ColorPicker:Get()
        return ColorPicker.Value
    end
    function ColorPicker:Destroy()
        Frame:Destroy()
    end
    table.insert(tab.Elements, ColorPicker)
    return ColorPicker
end

function Obsidian:CreateKeybind(tab, config)
    config = Utility.MergeTables({
        Name = "Keybind",
        Default = nil,
        Callback = function(key) end,
        OnPress = function() end,
        Description = nil,
        HoldMode = false,
        Save = false,
        SaveKey = nil
    }, config)
    local Keybind = {}
    Keybind.Config = config
    Keybind.Value = config.Default
    Keybind.Listening = false
    Keybind.Hovering = false
    Keybind.Connection = nil
    if config.Save and config.SaveKey then
        local saved = Data:Load(config.SaveKey)
        if saved then
            Keybind.Value = Enum.KeyCode[saved]
        end
    end
    local Frame = Utility.Create("Frame", {
        Name = config.Name,
        Parent = tab.Content,
        BackgroundColor3 = Obsidian.Theme.ElementBackground,
        BorderSizePixel = 0,
        Size = UDim2.new(1, 0, 0, config.Description and 75 or 50),
        LayoutOrder = #tab.Elements
    })
    Keybind.Frame = Frame
    local Corner = Utility.Create("UICorner", {
        CornerRadius = UDim.new(0, 6),
        Parent = Frame
    })
    local Label = Utility.Create("TextLabel", {
        Parent = Frame,
        BackgroundTransparency = 1,
        Position = UDim2.new(0, 15, 0, 8),
        Size = UDim2.new(1, -120, 0, 20),
        Font = Enum.Font.GothamSemibold,
        Text = config.Name,
        TextColor3 = Obsidian.Theme.Text,
        TextSize = 14,
        TextXAlignment = Enum.TextXAlignment.Left
    })
    if config.Description then
        local DescLabel = Utility.Create("TextLabel", {
            Parent = Frame,
            BackgroundTransparency = 1,
            Position = UDim2.new(0, 15, 0, 28),
            Size = UDim2.new(1, -120, 0, 16),
            Font = Enum.Font.Gotham,
            Text = config.Description,
            TextColor3 = Obsidian.Theme.TextDark,
            TextSize = 11,
            TextXAlignment = Enum.TextXAlignment.Left
        })
    end
    local KeyDisplay = Utility.Create("TextButton", {
        Parent = Frame,
        BackgroundColor3 = Obsidian.Theme.Background,
        BorderSizePixel = 0,
        Position = UDim2.new(1, -100, 0.5, -15),
        Size = UDim2.new(0, 85, 0, 30),
        Font = Enum.Font.GothamSemibold,
        Text = Keybind.Value and Keybind.Value.Name or "None",
        TextColor3 = Keybind.Value and Obsidian.Theme.Accent or Obsidian.Theme.TextDark,
        TextSize = 12,
        AutoButtonColor = false
    })
    Keybind.KeyDisplay = KeyDisplay
    local KeyCorner = Utility.Create("UICorner", {
        CornerRadius = UDim.new(0, 6),
        Parent = KeyDisplay
    })
    local function StartListening()
        Keybind.Listening = true
        KeyDisplay.Text = "..."
        KeyDisplay.TextColor3 = Obsidian.Theme.Accent
        Utility.Tween(KeyDisplay, {BackgroundColor3 = Obsidian.Theme.Accent}, 0.2)
        KeyDisplay.TextColor3 = Color3.fromRGB(255, 255, 255)
    end
    local function StopListening(keyCode)
        Keybind.Listening = false
        if keyCode == Enum.KeyCode.Escape then
            Keybind.Value = nil
            KeyDisplay.Text = "None"
            KeyDisplay.TextColor3 = Obsidian.Theme.TextDark
        else
            Keybind.Value = keyCode
            KeyDisplay.Text = keyCode.Name
            KeyDisplay.TextColor3 = Obsidian.Theme.Accent
            if config.Save and config.SaveKey then
                Data:Save(config.SaveKey, keyCode.Name)
            end
            config.Callback(keyCode)
        end
        Utility.Tween(KeyDisplay, {BackgroundColor3 = Obsidian.Theme.Background}, 0.2)
    end
    KeyDisplay.MouseButton1Click:Connect(StartListening)
    KeyDisplay.MouseEnter:Connect(function()
        Keybind.Hovering = true
        Utility.Tween(Frame, {BackgroundColor3 = Obsidian.Theme.ElementBackgroundHover}, 0.2)
    end)
    KeyDisplay.MouseLeave:Connect(function()
        Keybind.Hovering = false
        Utility.Tween(Frame, {BackgroundColor3 = Obsidian.Theme.ElementBackground}, 0.2)
    end)
    Keybind.Connection = UserInputService.InputBegan:Connect(function(input, gameProcessed)
        if gameProcessed then return end
        if Keybind.Listening then
            if input.UserInputType == Enum.UserInputType.Keyboard then
                StopListening(input.KeyCode)
            end
        elseif Keybind.Value and input.KeyCode == Keybind.Value then
            if config.HoldMode then
                if config.OnPress then
                    config.OnPress(true)
                end
            else
                if config.OnPress then
                    config.OnPress()
                end
            end
        end
    end)
    if config.HoldMode then
        UserInputService.InputEnded:Connect(function(input)
            if Keybind.Value and input.KeyCode == Keybind.Value and config.HoldMode then
                if config.OnPress then
                    config.OnPress(false)
                end
            end
        end)
    end
    function Keybind:Set(keyCode)
        Keybind.Value = keyCode
        KeyDisplay.Text = keyCode and keyCode.Name or "None"
        KeyDisplay.TextColor3 = keyCode and Obsidian.Theme.Accent or Obsidian.Theme.TextDark
        if config.Save and config.SaveKey then
            Data:Save(config.SaveKey, keyCode and keyCode.Name or nil)
        end
        config.Callback(keyCode)
    end
    function Keybind:Get()
        return Keybind.Value
    end
    function Keybind:Destroy()
        if Keybind.Connection then
            Keybind.Connection:Disconnect()
        end
        Frame:Destroy()
    end
    table.insert(tab.Elements, Keybind)
    return Keybind
end

function Obsidian:CreateParagraph(tab, config)
    config = Utility.MergeTables({
        Title = nil,
        Content = "",
        Alignment = Enum.TextXAlignment.Left
    }, config)
    local Paragraph = {}
    local Frame = Utility.Create("Frame", {
        Name = "Paragraph",
        Parent = tab.Content,
        BackgroundColor3 = Obsidian.Theme.ElementBackground,
        BorderSizePixel = 0,
        Size = UDim2.new(1, 0, 0, 100),
        AutomaticSize = Enum.AutomaticSize.Y,
        LayoutOrder = #tab.Elements
    })
    local Corner = Utility.Create("UICorner", {
        CornerRadius = UDim.new(0, 6),
        Parent = Frame
    })
    local Padding = Utility.Create("UIPadding", {
        Parent = Frame,
        PaddingLeft = UDim.new(0, 15),
        PaddingTop = UDim.new(0, 15),
        PaddingRight = UDim.new(0, 15),
        PaddingBottom = UDim.new(0, 15)
    })
    if config.Title then
        local Title = Utility.Create("TextLabel", {
            Parent = Frame,
            BackgroundTransparency = 1,
            Size = UDim2.new(1, 0, 0, 25),
            Font = Enum.Font.GothamBold,
            Text = config.Title,
            TextColor3 = Obsidian.Theme.Text,
            TextSize = 16,
            TextXAlignment = config.Alignment
        })
        local Content = Utility.Create("TextLabel", {
            Parent = Frame,
            BackgroundTransparency = 1,
            Position = UDim2.new(0, 0, 0, 30),
            Size = UDim2.new(1, 0, 0, 0),
            Font = Enum.Font.Gotham,
            Text = config.Content,
            TextColor3 = Obsidian.Theme.TextDark,
            TextSize = 13,
            TextWrapped = true,
            TextXAlignment = config.Alignment,
            AutomaticSize = Enum.AutomaticSize.Y
        })
    else
        local Content = Utility.Create("TextLabel", {
            Parent = Frame,
            BackgroundTransparency = 1,
            Size = UDim2.new(1, 0, 0, 0),
            Font = Enum.Font.Gotham,
            Text = config.Content,
            TextColor3 = Obsidian.Theme.TextDark,
            TextSize = 13,
            TextWrapped = true,
            TextXAlignment = config.Alignment,
            AutomaticSize = Enum.AutomaticSize.Y
        })
    end
    table.insert(tab.Elements, Paragraph)
    return Paragraph
end

function Obsidian:CreateDivider(tab, config)
    config = Utility.MergeTables({
        Thickness = 1,
        Color = nil,
        Padding = 10
    }, config)
    local Divider = {}
    local Frame = Utility.Create("Frame", {
        Name = "Divider",
        Parent = tab.Content,
        BackgroundTransparency = 1,
        Size = UDim2.new(1, 0, 0, config.Thickness + (config.Padding * 2)),
        LayoutOrder = #tab.Elements
    })
    local Line = Utility.Create("Frame", {
        Parent = Frame,
        BackgroundColor3 = config.Color or Obsidian.Theme.Border,
        BorderSizePixel = 0,
        Position = UDim2.new(0, 0, 0.5, -(config.Thickness / 2)),
        Size = UDim2.new(1, 0, 0, config.Thickness)
    })
    table.insert(tab.Elements, Divider)
    return Divider
end

function Obsidian:CreateImage(tab, config)
    config = Utility.MergeTables({
        Name = "Image",
        Image = "",
        ImageColor = Color3.fromRGB(255, 255, 255),
        Size = UDim2.new(1, 0, 0, 200),
        ScaleType = Enum.ScaleType.Stretch,
        CornerRadius = 6
    }, config)
    local Image = {}
    local Frame = Utility.Create("Frame", {
        Name = config.Name,
        Parent = tab.Content,
        BackgroundColor3 = Obsidian.Theme.ElementBackground,
        BorderSizePixel = 0,
        Size = config.Size,
        LayoutOrder = #tab.Elements
    })
    local Corner = Utility.Create("UICorner", {
        CornerRadius = UDim.new(0, config.CornerRadius),
        Parent = Frame
    })
    local ImageLabel = Utility.Create("ImageLabel", {
        Parent = Frame,
        BackgroundTransparency = 1,
        Position = UDim2.new(0, 10, 0, 10),
        Size = UDim2.new(1, -20, 1, -20),
        Image = config.Image,
        ImageColor3 = config.ImageColor,
        ScaleType = config.ScaleType
    })
    function Image:SetImage(imageId)
        ImageLabel.Image = imageId
    end
    function Image:SetColor(color)
        ImageLabel.ImageColor3 = color
    end
    table.insert(tab.Elements, Image)
    return Image
end

function Obsidian:CreateProgressBar(tab, config)
    config = Utility.MergeTables({
        Name = "ProgressBar",
        Progress = 0,
        ShowPercentage = true,
        Animated = true,
        BarColor = nil,
        Height = 8
    }, config)
    local ProgressBar = {}
    ProgressBar.Config = config
    ProgressBar.Value = config.Progress
    local Frame = Utility.Create("Frame", {
        Name = config.Name,
        Parent = tab.Content,
        BackgroundColor3 = Obsidian.Theme.ElementBackground,
        BorderSizePixel = 0,
        Size = UDim2.new(1, 0, 0, config.ShowPercentage and 50 or 35),
        LayoutOrder = #tab.Elements
    })
    local Corner = Utility.Create("UICorner", {
        CornerRadius = UDim.new(0, 6),
        Parent = Frame
    })
    local Label = Utility.Create("TextLabel", {
        Parent = Frame,
        BackgroundTransparency = 1,
        Position = UDim2.new(0, 15, 0, 8),
        Size = UDim2.new(1, -30, 0, 20),
        Font = Enum.Font.GothamSemibold,
        Text = config.Name,
        TextColor3 = Obsidian.Theme.Text,
        TextSize = 14,
        TextXAlignment = Enum.TextXAlignment.Left
    })
    local BarBg = Utility.Create("Frame", {
        Parent = Frame,
        BackgroundColor3 = Obsidian.Theme.Background,
        BorderSizePixel = 0,
        Position = UDim2.new(0, 15, 0, config.ShowPercentage and 35 or 25),
        Size = UDim2.new(1, -30, 0, config.Height)
    })
    local BarBgCorner = Utility.Create("UICorner", {
        CornerRadius = UDim.new(0, config.Height / 2),
        Parent = BarBg
    })
    local BarFill = Utility.Create("Frame", {
        Parent = BarBg,
        BackgroundColor3 = config.BarColor or Obsidian.Theme.Accent,
        BorderSizePixel = 0,
        Size = UDim2.new(config.Progress / 100, 0, 1, 0)
    })
    ProgressBar.BarFill = BarFill
    local BarFillCorner = Utility.Create("UICorner", {
        CornerRadius = UDim.new(0, config.Height / 2),
        Parent = BarFill
    })
    local PercentageLabel
    if config.ShowPercentage then
        PercentageLabel = Utility.Create("TextLabel", {
            Parent = Frame,
            BackgroundTransparency = 1,
            Position = UDim2.new(1, -60, 0, 8),
            Size = UDim2.new(0, 45, 0, 20),
            Font = Enum.Font.GothamSemibold,
            Text = config.Progress .. "%",
            TextColor3 = Obsidian.Theme.Accent,
            TextSize = 14,
            TextXAlignment = Enum.TextXAlignment.Right
        })
    end
    function ProgressBar:SetProgress(value)
        value = math.clamp(value, 0, 100)
        ProgressBar.Value = value
        if config.Animated then
            Utility.Tween(BarFill, {Size = UDim2.new(value / 100, 0, 1, 0)}, 0.3)
        else
            BarFill.Size = UDim2.new(value / 100, 0, 1, 0)
        end
        if PercentageLabel then
            PercentageLabel.Text = math.floor(value) .. "%"
        end
    end
    function ProgressBar:GetProgress()
        return ProgressBar.Value
    end
    table.insert(tab.Elements, ProgressBar)
    return ProgressBar
end

function Obsidian:CreateSpinner(tab, config)
    config = Utility.MergeTables({
        Name = "Spinner",
        Size = 40,
        Speed = 1,
        Color = nil
    }, config)
    local Spinner = {}
    local Frame = Utility.Create("Frame", {
        Name = config.Name,
        Parent = tab.Content,
        BackgroundTransparency = 1,
        Size = UDim2.new(1, 0, 0, config.Size + 20),
        LayoutOrder = #tab.Elements
    })
    local SpinnerImage = Utility.Create("ImageLabel", {
        Parent = Frame,
        BackgroundTransparency = 1,
        Position = UDim2.new(0.5, -config.Size/2, 0.5, -config.Size/2),
        Size = UDim2.new(0, config.Size, 0, config.Size),
        Image = "rbxassetid://3944668821",
        ImageColor3 = config.Color or Obsidian.Theme.Accent
    })
    local rotation = 0
    local connection = RunService.RenderStepped:Connect(function(delta)
        rotation = rotation + (360 * config.Speed * delta)
        SpinnerImage.Rotation = rotation
    end)
    function Spinner:Destroy()
        connection:Disconnect()
        Frame:Destroy()
    end
    table.insert(tab.Elements, Spinner)
    return Spinner
end

function Obsidian:Init(config)
    config = config or {}
    if config.Theme then
        Obsidian.Theme = Utility.MergeTables(Obsidian.Theme, config.Theme)
    end
    if config.Animation then
        Obsidian.Animation = Utility.MergeTables(Obsidian.Animation, config.Animation)
    end
    if config.Intro ~= false then
        local IntroGui = Utility.Create("ScreenGui", {
            Name = "ObsidianIntro",
            Parent = CoreGui,
            ResetOnSpawn = false,
            ZIndexBehavior = Enum.ZIndexBehavior.Global,
            DisplayOrder = 1000000
        })
        local Background = Utility.Create("Frame", {
            Parent = IntroGui,
            BackgroundColor3 = Obsidian.Theme.Background,
            BorderSizePixel = 0,
            Size = UDim2.new(1, 0, 1, 0)
        })
        local Logo = Utility.Create("TextLabel", {
            Parent = Background,
            BackgroundTransparency = 1,
            Size = UDim2.new(0, 400, 0, 100),
            Position = UDim2.new(0.5, -200, 0.5, -50),
            Font = Enum.Font.GothamBlack,
            Text = config.IntroText or "OBSIDIAN",
            TextColor3 = Obsidian.Theme.Accent,
            TextSize = 72,
            TextTransparency = 1
        })
        local Subtitle = Utility.Create("TextLabel", {
            Parent = Background,
            BackgroundTransparency = 1,
            Size = UDim2.new(0, 400, 0, 30),
            Position = UDim2.new(0.5, -200, 0.5, 30),
            Font = Enum.Font.Gotham,
            Text = "v" .. Obsidian.Version,
            TextColor3 = Obsidian.Theme.TextDark,
            TextSize = 18,
            TextTransparency = 1
        })
        Utility.Tween(Logo, {TextTransparency = 0}, 0.5)
        task.wait(0.3)
        Utility.Tween(Subtitle, {TextTransparency = 0}, 0.3)
        task.wait(1.5)
        Utility.Tween(Logo, {TextTransparency = 1}, 0.3)
        Utility.Tween(Subtitle, {TextTransparency = 1}, 0.3)
        Utility.Tween(Background, {BackgroundTransparency = 1}, 0.5).Completed:Connect(function()
            IntroGui:Destroy()
        end)
    end
    return Obsidian
end

_G.Obsidian = Obsidian
getfenv().Obsidian = Obsidian

function Obsidian:CreateListView(tab, config)
    config = Utility.MergeTables({
        Name = "ListView",
        Items = {},
        ItemHeight = 40,
        Selectable = true,
        MultiSelect = false,
        Searchable = false,
        Callback = function(item) end
    }, config)
    local ListView = {}
    ListView.Items = {}
    ListView.Selected = {}
    local Frame = Utility.Create("Frame", {
        Name = config.Name,
        Parent = tab.Content,
        BackgroundColor3 = Obsidian.Theme.ElementBackground,
        BorderSizePixel = 0,
        Size = UDim2.new(1, 0, 0, 200),
        LayoutOrder = #tab.Elements
    })
    local Corner = Utility.Create("UICorner", {
        CornerRadius = UDim.new(0, 6),
        Parent = Frame
    })
    local ScrollFrame = Utility.Create("ScrollingFrame", {
        Parent = Frame,
        BackgroundTransparency = 1,
        BorderSizePixel = 0,
        Position = UDim2.new(0, 10, 0, 10),
        Size = UDim2.new(1, -20, 1, -20),
        CanvasSize = UDim2.new(0, 0, 0, 0),
        ScrollBarThickness = 4,
        ScrollBarImageColor3 = Obsidian.Theme.Accent
    })
    local Layout = Utility.Create("UIListLayout", {
        Parent = ScrollFrame,
        SortOrder = Enum.SortOrder.LayoutOrder,
        Padding = UDim.new(0, 2)
    })
    Layout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        ScrollFrame.CanvasSize = UDim2.new(0, 0, 0, Layout.AbsoluteContentSize.Y)
    end)
    function ListView:AddItem(data)
        local Item = {}
        Item.Data = data
        Item.Selected = false
        local ItemFrame = Utility.Create("TextButton", {
            Parent = ScrollFrame,
            BackgroundColor3 = Obsidian.Theme.Background,
            BorderSizePixel = 0,
            Size = UDim2.new(1, 0, 0, config.ItemHeight),
            Font = Enum.Font.Gotham,
            Text = "  " .. (data.Text or data.Name or "Item"),
            TextColor3 = Obsidian.Theme.Text,
            TextSize = 13,
            TextXAlignment = Enum.TextXAlignment.Left,
            LayoutOrder = #ListView.Items,
            AutoButtonColor = false
        })
        local ItemCorner = Utility.Create("UICorner", {
            CornerRadius = UDim.new(0, 4),
            Parent = ItemFrame
        })
        if data.Icon then
            local Icon = Utility.Create("ImageLabel", {
                Parent = ItemFrame,
                BackgroundTransparency = 1,
                Position = UDim2.new(0, 10, 0.5, -8),
                Size = UDim2.new(0, 16, 0, 16),
                Image = data.Icon,
                ImageColor3 = Obsidian.Theme.Text
            })
            ItemFrame.Text = "      " .. (data.Text or data.Name or "Item")
        end
        ItemFrame.MouseEnter:Connect(function()
            if not Item.Selected then
                Utility.Tween(ItemFrame, {BackgroundColor3 = Obsidian.Theme.ElementBackgroundHover}, 0.2)
            end
        end)
        ItemFrame.MouseLeave:Connect(function()
            if not Item.Selected then
                Utility.Tween(ItemFrame, {BackgroundColor3 = Obsidian.Theme.Background}, 0.2)
            end
        end)
        ItemFrame.MouseButton1Click:Connect(function()
            if config.Selectable then
                if config.MultiSelect then
                    Item.Selected = not Item.Selected
                    if Item.Selected then
                        table.insert(ListView.Selected, Item)
                        Utility.Tween(ItemFrame, {BackgroundColor3 = Obsidian.Theme.Accent}, 0.2)
                    else
                        for i, sel in ipairs(ListView.Selected) do
                            if sel == Item then
                                table.remove(ListView.Selected, i)
                                break
                            end
                        end
                        Utility.Tween(ItemFrame, {BackgroundColor3 = Obsidian.Theme.Background}, 0.2)
                    end
                else
                    for _, item in ipairs(ListView.Items) do
                        item.Selected = false
                        Utility.Tween(item.Frame, {BackgroundColor3 = Obsidian.Theme.Background}, 0.2)
                    end
                    Item.Selected = true
                    ListView.Selected = {Item}
                    Utility.Tween(ItemFrame, {BackgroundColor3 = Obsidian.Theme.Accent}, 0.2)
                end
            end
            config.Callback(Item)
        end)
        Item.Frame = ItemFrame
        table.insert(ListView.Items, Item)
        return Item
    end
    function ListView:RemoveItem(index)
        if ListView.Items[index] then
            ListView.Items[index].Frame:Destroy()
            table.remove(ListView.Items, index)
        end
    end
    function ListView:Clear()
        for _, item in ipairs(ListView.Items) do
            item.Frame:Destroy()
        end
        ListView.Items = {}
        ListView.Selected = {}
    end
    if config.Items then
        for _, item in ipairs(config.Items) do
            ListView:AddItem(item)
        end
    end
    table.insert(tab.Elements, ListView)
    return ListView
end

function Obsidian:CreateConsole(tab, config)
    config = Utility.MergeTables({
        Name = "Console",
        Height = 200,
        ReadOnly = true,
        ShowTimestamp = true
    }, config)
    local Console = {}
    Console.Logs = {}
    local Frame = Utility.Create("Frame", {
        Name = config.Name,
        Parent = tab.Content,
        BackgroundColor3 = Color3.fromRGB(10, 10, 10),
        BorderSizePixel = 0,
        Size = UDim2.new(1, 0, 0, config.Height),
        LayoutOrder = #tab.Elements
    })
    local Corner = Utility.Create("UICorner", {
        CornerRadius = UDim.new(0, 6),
        Parent = Frame
    })
    local ScrollFrame = Utility.Create("ScrollingFrame", {
        Parent = Frame,
        BackgroundTransparency = 1,
        BorderSizePixel = 0,
        Position = UDim2.new(0, 10, 0, 10),
        Size = UDim2.new(1, -20, 1, -20),
        CanvasSize = UDim2.new(0, 0, 0, 0),
        ScrollBarThickness = 4,
        ScrollBarImageColor3 = Obsidian.Theme.Accent,
        AutomaticCanvasSize = Enum.AutomaticSize.Y
    })
    local Layout = Utility.Create("UIListLayout", {
        Parent = ScrollFrame,
        SortOrder = Enum.SortOrder.LayoutOrder,
        Padding = UDim.new(0, 2)
    })
    function Console:Log(message, type)
        type = type or "Info"
        local colors = {
            Info = Color3.fromRGB(200, 200, 200),
            Success = Color3.fromRGB(100, 255, 100),
            Warning = Color3.fromRGB(255, 200, 100),
            Error = Color3.fromRGB(255, 100, 100)
        }
        local timestamp = config.ShowTimestamp and os.date("[%H:%M:%S] ") or ""
        local LogLabel = Utility.Create("TextLabel", {
            Parent = ScrollFrame,
            BackgroundTransparency = 1,
            Size = UDim2.new(1, 0, 0, 20),
            Font = Enum.Font.Code,
            Text = timestamp .. message,
            TextColor3 = colors[type] or colors.Info,
            TextSize = 12,
            TextXAlignment = Enum.TextXAlignment.Left,
            TextWrapped = true,
            AutomaticSize = Enum.AutomaticSize.Y,
            LayoutOrder = #Console.Logs
        })
        table.insert(Console.Logs, LogLabel)
        task.wait()
        ScrollFrame.CanvasPosition = Vector2.new(0, ScrollFrame.AbsoluteCanvasSize.Y)
    end
    function Console:Clear()
        for _, log in ipairs(Console.Logs) do
            log:Destroy()
        end
        Console.Logs = {}
    end
    table.insert(tab.Elements, Console)
    return Console
end

function Obsidian:CreateAccordion(tab, config)
    config = Utility.MergeTables({
        Name = "Accordion",
        Title = "Section",
        DefaultExpanded = false,
        ContentHeight = 200
    }, config)
    local Accordion = {}
    Accordion.Expanded = config.DefaultExpanded
    local Frame = Utility.Create("Frame", {
        Name = config.Name,
        Parent = tab.Content,
        BackgroundColor3 = Obsidian.Theme.ElementBackground,
        BorderSizePixel = 0,
        Size = UDim2.new(1, 0, 0, 40),
        ClipsDescendants = true,
        LayoutOrder = #tab.Elements
    })
    Accordion.Frame = Frame
    local Corner = Utility.Create("UICorner", {
        CornerRadius = UDim.new(0, 6),
        Parent = Frame
    })
    local Header = Utility.Create("TextButton", {
        Parent = Frame,
        BackgroundTransparency = 1,
        Size = UDim2.new(1, 0, 0, 40),
        Font = Enum.Font.GothamSemibold,
        Text = "  " .. config.Title,
        TextColor3 = Obsidian.Theme.Text,
        TextSize = 14,
        TextXAlignment = Enum.TextXAlignment.Left,
        AutoButtonColor = false
    })
    local Arrow = Utility.Create("ImageLabel", {
        Parent = Header,
        BackgroundTransparency = 1,
        Position = UDim2.new(1, -35, 0.5, -8),
        Size = UDim2.new(0, 16, 0, 16),
        Image = "rbxassetid://3944668821",
        ImageColor3 = Obsidian.Theme.TextDark,
        Rotation = Accordion.Expanded and 180 or 0
    })
    local Content = Utility.Create("Frame", {
        Parent = Frame,
        BackgroundTransparency = 1,
        Position = UDim2.new(0, 0, 0, 45),
        Size = UDim2.new(1, 0, 0, config.ContentHeight)
    })
    Accordion.Content = Content
    local ContentLayout = Utility.Create("UIListLayout", {
        Parent = Content,
        SortOrder = Enum.SortOrder.LayoutOrder,
        Padding = UDim.new(0, 5)
    })
    local ContentPadding = Utility.Create("UIPadding", {
        Parent = Content,
        PaddingLeft = UDim.new(0, 10),
        PaddingRight = UDim.new(0, 10)
    })
    function Accordion:Toggle()
        Accordion.Expanded = not Accordion.Expanded
        if Accordion.Expanded then
            Utility.Tween(Frame, {Size = UDim2.new(1, 0, 0, 45 + config.ContentHeight)}, 0.3)
            Utility.Tween(Arrow, {Rotation = 180}, 0.3)
        else
            Utility.Tween(Frame, {Size = UDim2.new(1, 0, 0, 40)}, 0.3)
            Utility.Tween(Arrow, {Rotation = 0}, 0.3)
        end
    end
    Header.MouseButton1Click:Connect(function()
        Accordion:Toggle()
    end)
    if config.DefaultExpanded then
        Frame.Size = UDim2.new(1, 0, 0, 45 + config.ContentHeight)
    end
    table.insert(tab.Elements, Accordion)
    return Accordion
end

function Obsidian:CreateRating(tab, config)
    config = Utility.MergeTables({
        Name = "Rating",
        MaxStars = 5,
        Default = 0,
        AllowHalf = false,
        Callback = function(rating) end
    }, config)
    local Rating = {}
    Rating.Value = config.Default
    Rating.Stars = {}
    local Frame = Utility.Create("Frame", {
        Name = config.Name,
        Parent = tab.Content,
        BackgroundColor3 = Obsidian.Theme.ElementBackground,
        BorderSizePixel = 0,
        Size = UDim2.new(1, 0, 0, 50),
        LayoutOrder = #tab.Elements
    })
    local Corner = Utility.Create("UICorner", {
        CornerRadius = UDim.new(0, 6),
        Parent = Frame
    })
    local Label = Utility.Create("TextLabel", {
        Parent = Frame,
        BackgroundTransparency = 1,
        Position = UDim2.new(0, 15, 0, 0),
        Size = UDim2.new(0, 100, 1, 0),
        Font = Enum.Font.GothamSemibold,
        Text = config.Name,
        TextColor3 = Obsidian.Theme.Text,
        TextSize = 14,
        TextXAlignment = Enum.TextXAlignment.Left
    })
    local StarsFrame = Utility.Create("Frame", {
        Parent = Frame,
        BackgroundTransparency = 1,
        Position = UDim2.new(1, -config.MaxStars * 30 - 15, 0.5, -12),
        Size = UDim2.new(0, config.MaxStars * 30, 0, 24)
    })
    for i = 1, config.MaxStars do
        local Star = Utility.Create("TextButton", {
            Parent = StarsFrame,
            BackgroundTransparency = 1,
            Position = UDim2.new(0, (i - 1) * 30, 0, 0),
            Size = UDim2.new(0, 24, 0, 24),
            Font = Enum.Font.GothamBold,
            Text = "★",
            TextColor3 = i <= Rating.Value and Obsidian.Theme.Accent or Obsidian.Theme.TextDark,
            TextSize = 24,
            AutoButtonColor = false
        })
        Star.MouseEnter:Connect(function()
            for j = 1, config.MaxStars do
                Rating.Stars[j].TextColor3 = j <= i and Obsidian.Theme.Accent or Obsidian.Theme.TextDark
            end
        end)
        Star.MouseLeave:Connect(function()
            for j = 1, config.MaxStars do
                Rating.Stars[j].TextColor3 = j <= Rating.Value and Obsidian.Theme.Accent or Obsidian.Theme.TextDark
            end
        end)
        Star.MouseButton1Click:Connect(function()
            Rating.Value = i
            for j = 1, config.MaxStars do
                Rating.Stars[j].TextColor3 = j <= i and Obsidian.Theme.Accent or Obsidian.Theme.TextDark
            end
            config.Callback(i)
        end)
        table.insert(Rating.Stars, Star)
    end
    function Rating:Set(value)
        Rating.Value = math.clamp(value, 0, config.MaxStars)
        for i = 1, config.MaxStars do
            Rating.Stars[i].TextColor3 = i <= Rating.Value and Obsidian.Theme.Accent or Obsidian.Theme.TextDark
        end
    end
    table.insert(tab.Elements, Rating)
    return Rating
end

function Obsidian:CreateBadge(parent, config)
    config = Utility.MergeTables({
        Text = "NEW",
        Color = Obsidian.Theme.Accent,
        TextColor = Color3.fromRGB(255, 255, 255),
        Size = "Default"
    }, config)
    local sizes = {
        Small = UDim2.new(0, 30, 0, 16),
        Default = UDim2.new(0, 40, 0, 20),
        Large = UDim2.new(0, 50, 0, 24)
    }
    local Badge = Utility.Create("Frame", {
        Name = "Badge",
        Parent = parent,
        BackgroundColor3 = config.Color,
        BorderSizePixel = 0,
        Position = UDim2.new(1, -10, 0, -5),
        Size = sizes[config.Size] or sizes.Default,
        AnchorPoint = Vector2.new(1, 0),
        ZIndex = 10
    })
    local Corner = Utility.Create("UICorner", {
        CornerRadius = UDim.new(0, 4),
        Parent = Badge
    })
    local Label = Utility.Create("TextLabel", {
        Parent = Badge,
        BackgroundTransparency = 1,
        Size = UDim2.new(1, 0, 1, 0),
        Font = Enum.Font.GothamBold,
        Text = config.Text,
        TextColor3 = config.TextColor,
        TextSize = config.Size == "Small" and 9 or config.Size == "Large" and 12 or 10
    })
    return Badge
end

function Obsidian:CreateTooltip(parent, text, position)
    position = position or "Bottom"
    local Tooltip = Utility.Create("Frame", {
        Name = "Tooltip",
        Parent = parent,
        BackgroundColor3 = Obsidian.Theme.ElementBackground,
        BorderSizePixel = 0,
        Position = position == "Bottom" and UDim2.new(0, 0, 1, 5) or UDim2.new(0, 0, 0, -35),
        Size = UDim2.new(0, 200, 0, 30),
        AutomaticSize = Enum.AutomaticSize.X,
        ZIndex = 1000
    })
    local Corner = Utility.Create("UICorner", {
        CornerRadius = UDim.new(0, 4),
        Parent = Tooltip
    })
    local Label = Utility.Create("TextLabel", {
        Parent = Tooltip,
        BackgroundTransparency = 1,
        Position = UDim2.new(0, 10, 0, 0),
        Size = UDim2.new(0, 0, 1, 0),
        AutomaticSize = Enum.AutomaticSize.X,
        Font = Enum.Font.Gotham,
        Text = text,
        TextColor3 = Obsidian.Theme.Text,
        TextSize = 12
    })
    Tooltip.Size = UDim2.new(0, Label.AbsoluteSize.X + 20, 0, 30)
    Tooltip.BackgroundTransparency = 1
    Label.TextTransparency = 1
    Utility.Tween(Tooltip, {BackgroundTransparency = 0}, 0.2)
    Utility.Tween(Label, {TextTransparency = 0}, 0.2)
    return Tooltip
end

function Obsidian:CreateChipInput(tab, config)
    config = Utility.MergeTables({
        Name = "ChipInput",
        Placeholder = "Add tag...",
        MaxChips = 10,
        Callback = function(chips) end
    }, config)
    local ChipInput = {}
    ChipInput.Chips = {}
    local Frame = Utility.Create("Frame", {
        Name = config.Name,
        Parent = tab.Content,
        BackgroundColor3 = Obsidian.Theme.ElementBackground,
        BorderSizePixel = 0,
        Size = UDim2.new(1, 0, 0, 100),
        LayoutOrder = #tab.Elements
    })
    local Corner = Utility.Create("UICorner", {
        CornerRadius = UDim.new(0, 6),
        Parent = Frame
    })
    local InputFrame = Utility.Create("Frame", {
        Parent = Frame,
        BackgroundColor3 = Obsidian.Theme.Background,
        BorderSizePixel = 0,
        Position = UDim2.new(0, 15, 0, 10),
        Size = UDim2.new(1, -30, 0, 35)
    })
    local InputCorner = Utility.Create("UICorner", {
        CornerRadius = UDim.new(0, 4),
        Parent = InputFrame
    })
    local Input = Utility.Create("TextBox", {
        Parent = InputFrame,
        BackgroundTransparency = 1,
        Position = UDim2.new(0, 10, 0, 0),
        Size = UDim2.new(1, -20, 1, 0),
        Font = Enum.Font.Gotham,
        Text = "",
        PlaceholderText = config.Placeholder,
        PlaceholderColor3 = Obsidian.Theme.TextDark,
        TextColor3 = Obsidian.Theme.Text,
        TextSize = 13,
        ClearTextOnFocus = false
    })
    local ChipsFrame = Utility.Create("Frame", {
        Parent = Frame,
        BackgroundTransparency = 1,
        Position = UDim2.new(0, 15, 0, 55),
        Size = UDim2.new(1, -30, 0, 40)
    })
    local ChipsLayout = Utility.Create("UIListLayout", {
        Parent = ChipsFrame,
        FillDirection = Enum.FillDirection.Horizontal,
        Wraps = true,
        Padding = UDim.new(0, 5)
    })
    function ChipInput:AddChip(text)
        if #ChipInput.Chips >= config.MaxChips then return end
        if text == "" then return end
        local Chip = Utility.Create("Frame", {
            Parent = ChipsFrame,
            BackgroundColor3 = Obsidian.Theme.Accent,
            BorderSizePixel = 0,
            Size = UDim2.new(0, 0, 0, 25),
            AutomaticSize = Enum.AutomaticSize.X
        })
        local ChipCorner = Utility.Create("UICorner", {
            CornerRadius = UDim.new(0, 12),
            Parent = Chip
        })
        local ChipPadding = Utility.Create("UIPadding", {
            Parent = Chip,
            PaddingLeft = UDim.new(0, 10),
            PaddingRight = UDim.new(0, 10)
        })
        local ChipLabel = Utility.Create("TextLabel", {
            Parent = Chip,
            BackgroundTransparency = 1,
            Size = UDim2.new(0, 0, 1, 0),
            AutomaticSize = Enum.AutomaticSize.X,
            Font = Enum.Font.GothamSemibold,
            Text = text,
            TextColor3 = Color3.fromRGB(255, 255, 255),
            TextSize = 12
        })
        local RemoveBtn = Utility.Create("TextButton", {
            Parent = Chip,
            BackgroundTransparency = 1,
            Position = UDim2.new(1, -20, 0, 0),
            Size = UDim2.new(0, 20, 1, 0),
            Font = Enum.Font.GothamBold,
            Text = "×",
            TextColor3 = Color3.fromRGB(255, 255, 255),
            TextSize = 14
        })
        RemoveBtn.MouseButton1Click:Connect(function()
            Chip:Destroy()
            for i, c in ipairs(ChipInput.Chips) do
                if c.Text == text then
                    table.remove(ChipInput.Chips, i)
                    break
                end
            end
            config.Callback(ChipInput.Chips)
        end)
        table.insert(ChipInput.Chips, {Text = text, Frame = Chip})
        config.Callback(ChipInput.Chips)
    end
    Input.FocusLost:Connect(function(enterPressed)
        if enterPressed then
            ChipInput:AddChip(Input.Text)
            Input.Text = ""
        end
    end)
    table.insert(tab.Elements, ChipInput)
    return ChipInput
end

function Obsidian:CreateTimeline(tab, config)
    config = Utility.MergeTables({
        Name = "Timeline",
        Events = {},
        Orientation = "Vertical"
    }, config)
    local Timeline = {}
    local Frame = Utility.Create("Frame", {
        Name = config.Name,
        Parent = tab.Content,
        BackgroundColor3 = Obsidian.Theme.ElementBackground,
        BorderSizePixel = 0,
        Size = UDim2.new(1, 0, 0, #config.Events * 80 + 20),
        LayoutOrder = #tab.Elements
    })
    local Corner = Utility.Create("UICorner", {
        CornerRadius = UDim.new(0, 6),
        Parent = Frame
    })
    for i, event in ipairs(config.Events) do
        local EventFrame = Utility.Create("Frame", {
            Parent = Frame,
            BackgroundTransparency = 1,
            Position = UDim2.new(0, 20, 0, (i - 1) * 80 + 10),
            Size = UDim2.new(1, -40, 0, 70)
        })
        local Dot = Utility.Create("Frame", {
            Parent = EventFrame,
            BackgroundColor3 = event.Completed and Obsidian.Theme.Success or Obsidian.Theme.Accent,
            BorderSizePixel = 0,
            Position = UDim2.new(0, 0, 0, 5),
            Size = UDim2.new(0, 16, 0, 16)
        })
        local DotCorner = Utility.Create("UICorner", {
            CornerRadius = UDim.new(1, 0),
            Parent = Dot
        })
        if i < #config.Events then
            local Line = Utility.Create("Frame", {
                Parent = EventFrame,
                BackgroundColor3 = Obsidian.Theme.Border,
                BorderSizePixel = 0,
                Position = UDim2.new(0, 7, 0, 25),
                Size = UDim2.new(0, 2, 1, 0)
            })
        end
        local Title = Utility.Create("TextLabel", {
            Parent = EventFrame,
            BackgroundTransparency = 1,
            Position = UDim2.new(0, 30, 0, 0),
            Size = UDim2.new(1, -30, 0, 20),
            Font = Enum.Font.GothamBold,
            Text = event.Title,
            TextColor3 = Obsidian.Theme.Text,
            TextSize = 14,
            TextXAlignment = Enum.TextXAlignment.Left
        })
        local Description = Utility.Create("TextLabel", {
            Parent = EventFrame,
            BackgroundTransparency = 1,
            Position = UDim2.new(0, 30, 0, 25),
            Size = UDim2.new(1, -30, 0, 20),
            Font = Enum.Font.Gotham,
            Text = event.Description or "",
            TextColor3 = Obsidian.Theme.TextDark,
            TextSize = 12,
            TextXAlignment = Enum.TextXAlignment.Left
        })
        local Time = Utility.Create("TextLabel", {
            Parent = EventFrame,
            BackgroundTransparency = 1,
            Position = UDim2.new(0, 30, 0, 45),
            Size = UDim2.new(1, -30, 0, 20),
            Font = Enum.Font.Gotham,
            Text = event.Time or "",
            TextColor3 = Obsidian.Theme.TextDark,
            TextSize = 11,
            TextXAlignment = Enum.TextXAlignment.Left
        })
    end
    table.insert(tab.Elements, Timeline)
    return Timeline
end

function Obsidian:CreateEmptyState(tab, config)
    config = Utility.MergeTables({
        Name = "EmptyState",
        Icon = "",
        Title = "No Data",
        Message = "There's nothing here yet.",
        ActionText = nil,
        ActionCallback = function() end
    }, config)
    local Frame = Utility.Create("Frame", {
        Name = config.Name,
        Parent = tab.Content,
        BackgroundColor3 = Obsidian.Theme.ElementBackground,
        BorderSizePixel = 0,
        Size = UDim2.new(1, 0, 0, 200),
        LayoutOrder = #tab.Elements
    })
    local Corner = Utility.Create("UICorner", {
        CornerRadius = UDim.new(0, 6),
        Parent = Frame
    })
    if config.Icon ~= "" then
        local Icon = Utility.Create("ImageLabel", {
            Parent = Frame,
            BackgroundTransparency = 1,
            Position = UDim2.new(0.5, -32, 0, 30),
            Size = UDim2.new(0, 64, 0, 64),
            Image = config.Icon,
            ImageColor3 = Obsidian.Theme.TextDark,
            ImageTransparency = 0.5
        })
    end
    local Title = Utility.Create("TextLabel", {
        Parent = Frame,
        BackgroundTransparency = 1,
        Position = UDim2.new(0, 0, 0, 100),
        Size = UDim2.new(1, 0, 0, 25),
        Font = Enum.Font.GothamBold,
        Text = config.Title,
        TextColor3 = Obsidian.Theme.Text,
        TextSize = 18
    })
    local Message = Utility.Create("TextLabel", {
        Parent = Frame,
        BackgroundTransparency = 1,
        Position = UDim2.new(0, 0, 0, 130),
        Size = UDim2.new(1, 0, 0, 20),
        Font = Enum.Font.Gotham,
        Text = config.Message,
        TextColor3 = Obsidian.Theme.TextDark,
        TextSize = 13
    })
    if config.ActionText then
        local ActionBtn = Utility.Create("TextButton", {
            Parent = Frame,
            BackgroundColor3 = Obsidian.Theme.Accent,
            BorderSizePixel = 0,
            Position = UDim2.new(0.5, -60, 0, 160),
            Size = UDim2.new(0, 120, 0, 35),
            Font = Enum.Font.GothamSemibold,
            Text = config.ActionText,
            TextColor3 = Color3.fromRGB(255, 255, 255),
            TextSize = 14,
            AutoButtonColor = false
        })
        local BtnCorner = Utility.Create("UICorner", {
            CornerRadius = UDim.new(0, 6),
            Parent = ActionBtn
        })
        ActionBtn.MouseButton1Click:Connect(config.ActionCallback)
    end
    return Frame
end

function Obsidian:CreateSkeleton(tab, config)
    config = Utility.MergeTables({
        Name = "Skeleton",
        Lines = 3,
        LineHeight = 20,
        Animated = true
    }, config)
    local Skeleton = {}
    local Frame = Utility.Create("Frame", {
        Name = config.Name,
        Parent = tab.Content,
        BackgroundColor3 = Obsidian.Theme.ElementBackground,
        BorderSizePixel = 0,
        Size = UDim2.new(1, 0, 0, config.Lines * (config.LineHeight + 10) + 20),
        LayoutOrder = #tab.Elements
    })
    local Corner = Utility.Create("UICorner", {
        CornerRadius = UDim.new(0, 6),
        Parent = Frame
    })
    local Lines = {}
    for i = 1, config.Lines do
        local Line = Utility.Create("Frame", {
            Parent = Frame,
            BackgroundColor3 = Obsidian.Theme.Background,
            BorderSizePixel = 0,
            Position = UDim2.new(0, 15, 0, 15 + (i - 1) * (config.LineHeight + 10)),
            Size = UDim2.new(math.random(60, 90) / 100, 0, 0, config.LineHeight)
        })
        local LineCorner = Utility.Create("UICorner", {
            CornerRadius = UDim.new(0, 4),
            Parent = Line
        })
        table.insert(Lines, Line)
    end
    if config.Animated then
        local gradient = Utility.Create("UIGradient", {
            Parent = Frame,
            Color = ColorSequence.new({
                ColorSequenceKeypoint.new(0, Obsidian.Theme.ElementBackground),
                ColorSequenceKeypoint.new(0.5, Obsidian.Theme.ElementBackgroundHover),
                ColorSequenceKeypoint.new(1, Obsidian.Theme.ElementBackground)
            }),
            Rotation = -45
        })
        local offset = 0
        RunService.RenderStepped:Connect(function()
            offset = offset + 0.02
            if offset > 1 then offset = 0 end
            gradient.Offset = Vector2.new(offset, 0)
        end)
    end
    function Skeleton:Destroy()
        Frame:Destroy()
    end
    table.insert(tab.Elements, Skeleton)
    return Skeleton
end

function Obsidian:CreateNumberInput(tab, config)
    config = Utility.MergeTables({
        Name = "NumberInput",
        Min = 0,
        Max = 100,
        Default = 0,
        Step = 1,
        Callback = function(value) end
    }, config)
    local NumberInput = {}
    NumberInput.Value = config.Default
    local Frame = Utility.Create("Frame", {
        Name = config.Name,
        Parent = tab.Content,
        BackgroundColor3 = Obsidian.Theme.ElementBackground,
        BorderSizePixel = 0,
        Size = UDim2.new(1, 0, 0, 50),
        LayoutOrder = #tab.Elements
    })
    local Corner = Utility.Create("UICorner", {
        CornerRadius = UDim.new(0, 6),
        Parent = Frame
    })
    local Label = Utility.Create("TextLabel", {
        Parent = Frame,
        BackgroundTransparency = 1,
        Position = UDim2.new(0, 15, 0, 0),
        Size = UDim2.new(0.5, -15, 1, 0),
        Font = Enum.Font.GothamSemibold,
        Text = config.Name,
        TextColor3 = Obsidian.Theme.Text,
        TextSize = 14,
        TextXAlignment = Enum.TextXAlignment.Left
    })
    local InputFrame = Utility.Create("Frame", {
        Parent = Frame,
        BackgroundColor3 = Obsidian.Theme.Background,
        BorderSizePixel = 0,
        Position = UDim2.new(1, -130, 0.5, -15),
        Size = UDim2.new(0, 120, 0, 30)
    })
    local InputCorner = Utility.Create("UICorner", {
        CornerRadius = UDim.new(0, 4),
        Parent = InputFrame
    })
    local MinusBtn = Utility.Create("TextButton", {
        Parent = InputFrame,
        BackgroundTransparency = 1,
        Size = UDim2.new(0, 30, 1, 0),
        Font = Enum.Font.GothamBold,
        Text = "-",
        TextColor3 = Obsidian.Theme.Text,
        TextSize = 18
    })
    local ValueBox = Utility.Create("TextBox", {
        Parent = InputFrame,
        BackgroundTransparency = 1,
        Position = UDim2.new(0, 30, 0, 0),
        Size = UDim2.new(0, 60, 1, 0),
        Font = Enum.Font.Gotham,
        Text = tostring(NumberInput.Value),
        TextColor3 = Obsidian.Theme.Text,
        TextSize = 14,
        ClearTextOnFocus = false
    })
    local PlusBtn = Utility.Create("TextButton", {
        Parent = InputFrame,
        BackgroundTransparency = 1,
        Position = UDim2.new(1, -30, 0, 0),
        Size = UDim2.new(0, 30, 1, 0),
        Font = Enum.Font.GothamBold,
        Text = "+",
        TextColor3 = Obsidian.Theme.Text,
        TextSize = 18
    })
    local function UpdateValue(newValue)
        NumberInput.Value = math.clamp(newValue, config.Min, config.Max)
        ValueBox.Text = tostring(NumberInput.Value)
        config.Callback(NumberInput.Value)
    end
    MinusBtn.MouseButton1Click:Connect(function()
        UpdateValue(NumberInput.Value - config.Step)
    end)
    PlusBtn.MouseButton1Click:Connect(function()
        UpdateValue(NumberInput.Value + config.Step)
    end)
    ValueBox.FocusLost:Connect(function()
        local num = tonumber(ValueBox.Text)
        if num then
            UpdateValue(num)
        else
            ValueBox.Text = tostring(NumberInput.Value)
        end
    end)
    function NumberInput:Set(value)
        UpdateValue(value)
    end
    function NumberInput:Get()
        return NumberInput.Value
    end
    table.insert(tab.Elements, NumberInput)
    return NumberInput
end

Obsidian.TotalComponents = 35
Obsidian.BuildDate = "2026-03-21"
Obsidian.IsComplete = true

function Obsidian:CreateAdvancedWindow(config)
    config = Utility.MergeTables({
        Acrylic = false,
        Blur = false,
        AnimateIntro = true,
        TabAnimation = true,
        ParticleBackground = false,
        StatsOverlay = false
    }, config)
    local Window = self:CreateWindow(config)
    if config.Acrylic then
        local AcrylicFrame = Utility.Create("Frame", {
            Name = "Acrylic",
            Parent = Window.MainFrame,
            BackgroundColor3 = Color3.fromRGB(255, 255, 255),
            BackgroundTransparency = 0.9,
            BorderSizePixel = 0,
            Size = UDim2.new(1, 0, 1, 0),
            ZIndex = 0
        })
        local AcrylicCorner = Utility.Create("UICorner", {
            CornerRadius = UDim.new(0, config.CornerRadius or 8),
            Parent = AcrylicFrame
        })
        local AcrylicGradient = Utility.Create("UIGradient", {
            Parent = AcrylicFrame,
            Color = ColorSequence.new({
                ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 255, 255)),
                ColorSequenceKeypoint.new(1, Color3.fromRGB(200, 200, 220))
            }),
            Transparency = NumberSequence.new({
                NumberSequenceKeypoint.new(0, 0.8),
                NumberSequenceKeypoint.new(1, 0.9)
            })
        })
    end
    if config.ParticleBackground then
        local ParticleFrame = Utility.Create("Frame", {
            Name = "Particles",
            Parent = Window.ContentArea,
            BackgroundTransparency = 1,
            Size = UDim2.new(1, 0, 1, 0),
            ZIndex = 0
        })
        local particles = {}
        for i = 1, 20 do
            local particle = Utility.Create("Frame", {
                Parent = ParticleFrame,
                BackgroundColor3 = Obsidian.Theme.Accent,
                BackgroundTransparency = 0.8,
                BorderSizePixel = 0,
                Position = UDim2.new(math.random(), 0, math.random(), 0),
                Size = UDim2.new(0, math.random(2, 6), 0, math.random(2, 6))
            })
            local corner = Utility.Create("UICorner", {
                CornerRadius = UDim.new(1, 0),
                Parent = particle
            })
            table.insert(particles, {
                Instance = particle,
                Speed = math.random(10, 50) / 100,
                Direction = Vector2.new(math.random(-1, 1), math.random(-1, 1))
            })
        end
        RunService.RenderStepped:Connect(function()
            for _, p in ipairs(particles) do
                local currentPos = p.Instance.Position
                local newX = currentPos.X.Scale + (p.Direction.X * p.Speed * 0.01)
                local newY = currentPos.Y.Scale + (p.Direction.Y * p.Speed * 0.01)
                if newX < 0 or newX > 1 then p.Direction = Vector2.new(-p.Direction.X, p.Direction.Y) end
                if newY < 0 or newY > 1 then p.Direction = Vector2.new(p.Direction.X, -p.Direction.Y) end
                p.Instance.Position = UDim2.new(math.clamp(newX, 0, 1), 0, math.clamp(newY, 0, 1), 0)
            end
        end)
    end
    if config.StatsOverlay then
        local StatsFrame = Utility.Create("Frame", {
            Name = "Stats",
            Parent = Window.MainFrame,
            BackgroundColor3 = Obsidian.Theme.ElementBackground,
            BackgroundTransparency = 0.5,
            BorderSizePixel = 0,
            Position = UDim2.new(0, 10, 1, -40),
            Size = UDim2.new(0, 200, 0, 30),
            ZIndex = 100
        })
        local StatsCorner = Utility.Create("UICorner", {
            CornerRadius = UDim.new(0, 6),
            Parent = StatsFrame
        })
        local FPSLabel = Utility.Create("TextLabel", {
            Parent = StatsFrame,
            BackgroundTransparency = 1,
            Position = UDim2.new(0, 10, 0, 0),
            Size = UDim2.new(0.5, -10, 1, 0),
            Font = Enum.Font.Gotham,
            Text = "FPS: 60",
            TextColor3 = Obsidian.Theme.Text,
            TextSize = 12
        })
        local PingLabel = Utility.Create("TextLabel", {
            Parent = StatsFrame,
            BackgroundTransparency = 1,
            Position = UDim2.new(0.5, 0, 0, 0),
            Size = UDim2.new(0.5, -10, 1, 0),
            Font = Enum.Font.Gotham,
            Text = "Ping: 0ms",
            TextColor3 = Obsidian.Theme.Text,
            TextSize = 12
        })
        local lastUpdate = 0
        local fps = 60
        RunService.RenderStepped:Connect(function(delta)
            fps = math.floor(1 / delta)
            if tick() - lastUpdate > 0.5 then
                lastUpdate = tick()
                FPSLabel.Text = "FPS: " .. fps
            end
        end)
    end
    return Window
end

Obsidian.Themes = {
    Default = {
        Background = Color3.fromRGB(25, 25, 25),
        Accent = Color3.fromRGB(88, 101, 242),
        Text = Color3.fromRGB(255, 255, 255)
    },
    Dark = {
        Background = Color3.fromRGB(15, 15, 15),
        Accent = Color3.fromRGB(114, 137, 218),
        Text = Color3.fromRGB(220, 220, 220)
    },
    Light = {
        Background = Color3.fromRGB(240, 240, 240),
        Accent = Color3.fromRGB(88, 101, 242),
        Text = Color3.fromRGB(30, 30, 30),
        ElementBackground = Color3.fromRGB(220, 220, 220),
        Border = Color3.fromRGB(200, 200, 200)
    },
    Red = {
        Background = Color3.fromRGB(25, 15, 15),
        Accent = Color3.fromRGB(237, 66, 69),
        Text = Color3.fromRGB(255, 255, 255)
    },
    Green = {
        Background = Color3.fromRGB(15, 25, 15),
        Accent = Color3.fromRGB(59, 165, 93),
        Text = Color3.fromRGB(255, 255, 255)
    },
    Blue = {
        Background = Color3.fromRGB(15, 20, 30),
        Accent = Color3.fromRGB(0, 150, 255),
        Text = Color3.fromRGB(255, 255, 255)
    },
    Purple = {
        Background = Color3.fromRGB(20, 15, 25),
        Accent = Color3.fromRGB(147, 112, 219),
        Text = Color3.fromRGB(255, 255, 255)
    },
    Orange = {
        Background = Color3.fromRGB(25, 20, 15),
        Accent = Color3.fromRGB(255, 165, 0),
        Text = Color3.fromRGB(255, 255, 255)
    },
    Midnight = {
        Background = Color3.fromRGB(10, 10, 20),
        Accent = Color3.fromRGB(75, 0, 130),
        Text = Color3.fromRGB(200, 200, 255),
        ElementBackground = Color3.fromRGB(20, 20, 35),
        Border = Color3.fromRGB(30, 30, 50)
    },
    Cyberpunk = {
        Background = Color3.fromRGB(10, 0, 20),
        Accent = Color3.fromRGB(255, 0, 255),
        AccentDark = Color3.fromRGB(0, 255, 255),
        Text = Color3.fromRGB(0, 255, 65),
        ElementBackground = Color3.fromRGB(20, 0, 30),
        Border = Color3.fromRGB(255, 0, 255)
    }
}

function Obsidian:SetTheme(themeName)
    if self.Themes[themeName] then
        self.Theme = Utility.MergeTables(self.Theme, self.Themes[themeName])
        return true
    end
    return false
end

function Obsidian:CreateCustomTheme(config)
    return Utility.MergeTables(self.Theme, config)
end

Obsidian.Animations = {
    FadeIn = function(element, duration)
        element.BackgroundTransparency = 1
        Utility.Tween(element, {BackgroundTransparency = 0}, duration or 0.3)
    end,
    FadeOut = function(element, duration, callback)
        Utility.Tween(element, {BackgroundTransparency = 1}, duration or 0.3).Completed:Connect(function()
            if callback then callback() end
        end)
    end,
    SlideIn = function(element, direction, duration)
        direction = direction or "Left"
        duration = duration or 0.3
        local startPos = element.Position
        if direction == "Left" then
            element.Position = startPos - UDim2.new(0, 50, 0, 0)
        elseif direction == "Right" then
            element.Position = startPos + UDim2.new(0, 50, 0, 0)
        elseif direction == "Top" then
            element.Position = startPos - UDim2.new(0, 0, 0, 50)
        elseif direction == "Bottom" then
            element.Position = startPos + UDim2.new(0, 0, 0, 50)
        end
        Utility.Tween(element, {Position = startPos}, duration, Enum.EasingStyle.Back)
    end,
    ScaleIn = function(element, duration)
        element.Size = UDim2.new(0, 0, 0, 0)
        Utility.Tween(element, {Size = UDim2.new(1, 0, 1, 0)}, duration or 0.3, Enum.EasingStyle.Back)
    end,
    Pulse = function(element, intensity, duration)
        intensity = intensity or 1.1
        duration = duration or 0.5
        local originalSize = element.Size
        local targetSize = UDim2.new(
            originalSize.X.Scale * intensity,
            originalSize.X.Offset * intensity,
            originalSize.Y.Scale * intensity,
            originalSize.Y.Offset * intensity
        )
        Utility.Tween(element, {Size = targetSize}, duration / 2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out, function()
            Utility.Tween(element, {Size = originalSize}, duration / 2, Enum.EasingStyle.Quad, Enum.EasingDirection.In)
        end)
    end,
    Shake = function(element, intensity, duration)
        intensity = intensity or 10
        duration = duration or 0.5
        local originalPos = element.Position
        local startTime = tick()
        local connection
        connection = RunService.RenderStepped:Connect(function()
            local elapsed = tick() - startTime
            if elapsed >= duration then
                element.Position = originalPos
                connection:Disconnect()
                return
            end
            local offset = math.sin(elapsed * 50) * intensity * (1 - elapsed / duration)
            element.Position = originalPos + UDim2.new(0, offset, 0, 0)
        end)
    end,
    Bounce = function(element, height, duration)
        height = height or 20
        duration = duration or 0.5
        local originalPos = element.Position
        Utility.Tween(element, {Position = originalPos - UDim2.new(0, 0, 0, height)}, duration / 2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out, function()
            Utility.Tween(element, {Position = originalPos}, duration / 2, Enum.EasingStyle.Bounce, Enum.EasingDirection.Out)
        end)
    end,
    Rotate = function(element, degrees, duration)
        Utility.Tween(element, {Rotation = degrees}, duration or 0.5, Enum.EasingStyle.Quad)
    end
}

function Utility.CreateShadow(parent, intensity, size)
    intensity = intensity or 0.5
    size = size or 20
    return Utility.Create("ImageLabel", {
        Name = "Shadow",
        Parent = parent,
        BackgroundTransparency = 1,
        Image = "rbxassetid://6015897843",
        ImageColor3 = Color3.fromRGB(0, 0, 0),
        ImageTransparency = 1 - intensity,
        ScaleType = Enum.ScaleType.Slice,
        SliceCenter = Rect.new(49, 49, 450, 450),
        Position = UDim2.new(0, -size, 0, -size),
        Size = UDim2.new(1, size * 2, 1, size * 2),
        ZIndex = parent.ZIndex - 1
    })
end

function Utility.CreateGlow(parent, color, size)
    color = color or Obsidian.Theme.Accent
    size = size or 10
    return Utility.Create("ImageLabel", {
        Name = "Glow",
        Parent = parent,
        BackgroundTransparency = 1,
        Image = "rbxassetid://6015897843",
        ImageColor3 = color,
        ImageTransparency = 0.8,
        ScaleType = Enum.ScaleType.Slice,
        SliceCenter = Rect.new(49, 49, 450, 450),
        Position = UDim2.new(0, -size, 0, -size),
        Size = UDim2.new(1, size * 2, 1, size * 2),
        ZIndex = parent.ZIndex - 1
    })
end

function Utility.CreateStroke(parent, color, thickness, transparency)
    return Utility.Create("UIStroke", {
        Parent = parent,
        Color = color or Obsidian.Theme.Border,
        Thickness = thickness or 1,
        Transparency = transparency or 0
    })
end

function Utility.CreateGradient(parent, color1, color2, rotation)
    return Utility.Create("UIGradient", {
        Parent = parent,
        Color = ColorSequence.new({
            ColorSequenceKeypoint.new(0, color1 or Obsidian.Theme.Accent),
            ColorSequenceKeypoint.new(1, color2 or Obsidian.Theme.AccentDark)
        }),
        Rotation = rotation or 0
    })
end

Obsidian.TotalComponents = 40
Obsidian.BuildDate = "2026-03-21"
Obsidian.IsComplete = true

return Obsidian
