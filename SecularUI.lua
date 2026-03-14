local WindGlass = {}
WindGlass.__index = WindGlass

-- Services
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")

-- Lucide Icons (Simplified mapping)
local Icons = {
    ["x"] = "rbxassetid://7733658504",
    ["check"] = "rbxassetid://7733715400",
    ["chevron-down"] = "rbxassetid://7733717447",
    ["settings"] = "rbxassetid://7734053495",
    ["search"] = "rbxassetid://7734052921",
    ["plus"] = "rbxassetid://7733710700",
    ["minus"] = "rbxassetid://7733710672",
    ["copy"] = "rbxassetid://7733710700",
    ["trash"] = "rbxassetid://7734053657",
    ["eye"] = "rbxassetid://7733715400",
    ["eye-off"] = "rbxassetid://7734053216",
    ["menu"] = "rbxassetid://7734053246",
    ["home"] = "rbxassetid://7733715400",
    ["user"] = "rbxassetid://7734053657",
    ["bell"] = "rbxassetid://7733710700",
    ["moon"] = "rbxassetid://7734053495",
    ["sun"] = "rbxassetid://7734053657",
    ["palette"] = "rbxassetid://7734053246",
    ["mouse-pointer-click"] = "rbxassetid://7734053216",
    ["maximize"] = "rbxassetid://7734053246",
    ["minimize"] = "rbxassetid://7734053216",
    ["expand"] = "rbxassetid://7734053216",
    ["shrink"] = "rbxassetid://7734053216",
    ["grab"] = "rbxassetid://7734053246",
    ["frown"] = "rbxassetid://7734053216",
    ["info"] = "rbxassetid://7734053495",
    ["alert-circle"] = "rbxassetid://7733710700",
    ["clipboard-copy"] = "rbxassetid://7733710700",
    ["log-out"] = "rbxassetid://7734053657",
    ["key"] = "rbxassetid://7734053495",
    ["arrow-right"] = "rbxassetid://7733717447",
    ["shredder"] = "rbxassetid://7734053657",
    ["square"] = "rbxassetid://7734053246",
    ["lock"] = "rbxassetid://7734053495",
    ["unlock"] = "rbxassetid://7734053216",
    ["zap"] = "rbxassetid://7734053657",
    ["target"] = "rbxassetid://7734053246",
    ["crosshair"] = "rbxassetid://7734053216",
    ["sliders"] = "rbxassetid://7734053246",
    ["toggle-left"] = "rbxassetid://7734053216",
    ["toggle-right"] = "rbxassetid://7734053246",
}

-- Utility Functions
local function Create(instanceType, properties, children)
    local instance = Instance.new(instanceType)
    for prop, value in pairs(properties or {}) do
        instance[prop] = value
    end
    for _, child in pairs(children or {}) do
        child.Parent = instance
    end
    return instance
end

local function Tween(instance, duration, properties, easingStyle, easingDirection)
    easingStyle = easingStyle or Enum.EasingStyle.Quint
    easingDirection = easingDirection or Enum.EasingDirection.Out
    local tween = TweenService:Create(instance, TweenInfo.new(duration, easingStyle, easingDirection), properties)
    tween:Play()
    return tween
end

local function AddGlassEffect(frame, transparency)
    local blur = Create("ImageLabel", {
        Name = "GlassBlur",
        Size = UDim2.new(1, 40, 1, 40),
        Position = UDim2.new(0, -20, 0, -20),
        BackgroundTransparency = 1,
        Image = "rbxassetid://8992230677",
        ImageColor3 = Color3.fromRGB(0, 0, 0),
        ImageTransparency = transparency or 0.85,
        ScaleType = Enum.ScaleType.Slice,
        SliceCenter = Rect.new(99, 99, 99, 99),
        ZIndex = frame.ZIndex - 1,
    })
    blur.Parent = frame
    
    local gradient = Create("UIGradient", {
        Color = ColorSequence.new({
            ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 255, 255)),
            ColorSequenceKeypoint.new(1, Color3.fromRGB(240, 240, 250))
        }),
        Rotation = 135,
        Transparency = NumberSequence.new({
            NumberSequenceKeypoint.new(0, 0.9),
            NumberSequenceKeypoint.new(1, 0.95)
        })
    })
    gradient.Parent = frame
    
    return blur
end

-- Notification System
local NotificationSystem = {}
NotificationSystem.Queue = {}
NotificationSystem.Active = false

function NotificationSystem:New(data)
    local notif = {
        Title = data.Title or "Notification",
        Content = data.Content or "",
        Icon = data.Icon or "info",
        Duration = data.Duration or 5,
        Type = data.Type or "info"
    }
    
    table.insert(self.Queue, notif)
    if not self.Active then
        self:ShowNext()
    end
end

function NotificationSystem:ShowNext()
    if #self.Queue == 0 then
        self.Active = false
        return
    end
    
    self.Active = true
    local data = table.remove(self.Queue, 1)
    
    local screenGui = PlayerGui:FindFirstChild("WindGlassNotifications") or Create("ScreenGui", {
        Name = "WindGlassNotifications",
        Parent = PlayerGui,
        ResetOnSpawn = false,
        ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
    })
    
    -- Compact notification size (scaled down)
    local notifFrame = Create("CanvasGroup", {
        Size = UDim2.new(0, 240, 0, 0),
        Position = UDim2.new(1, -20, 1, -80),
        AnchorPoint = Vector2.new(1, 1),
        BackgroundTransparency = 0.2,
        BackgroundColor3 = Color3.fromRGB(25, 25, 30),
        BorderSizePixel = 0,
        GroupTransparency = 1,
        AutomaticSize = Enum.AutomaticSize.Y,
    })
    
    local corner = Create("UICorner", {CornerRadius = UDim.new(0, 12)})
    corner.Parent = notifFrame
    
    local stroke = Create("UIStroke", {
        Color = Color3.fromRGB(60, 60, 70),
        Thickness = 1,
        Transparency = 0.5,
    })
    stroke.Parent = notifFrame
    
    -- Glass effect
    AddGlassEffect(notifFrame, 0.9)
    
    local layout = Create("UIListLayout", {
        Padding = UDim.new(0, 8),
        FillDirection = Enum.FillDirection.Horizontal,
        VerticalAlignment = Enum.VerticalAlignment.Center,
    })
    layout.Parent = notifFrame
    
    local padding = Create("UIPadding", {
        PaddingTop = UDim.new(0, 12),
        PaddingLeft = UDim.new(0, 12),
        PaddingRight = UDim.new(0, 12),
        PaddingBottom = UDim.new(0, 12),
    })
    padding.Parent = notifFrame
    
    -- Icon
    local icon = Create("ImageLabel", {
        Size = UDim2.new(0, 20, 0, 20),
        BackgroundTransparency = 1,
        Image = Icons[data.Icon] or Icons["info"],
        ImageColor3 = data.Type == "success" and Color3.fromRGB(100, 255, 100) or 
                     data.Type == "error" and Color3.fromRGB(255, 100, 100) or
                     Color3.fromRGB(100, 180, 255),
    })
    icon.Parent = notifFrame
    
    local textContainer = Create("Frame", {
        Size = UDim2.new(1, -28, 0, 0),
        BackgroundTransparency = 1,
        AutomaticSize = Enum.AutomaticSize.Y,
    })
    textContainer.Parent = notifFrame
    
    local textLayout = Create("UIListLayout", {
        Padding = UDim.new(0, 4),
        FillDirection = Enum.FillDirection.Vertical,
    })
    textLayout.Parent = textContainer
    
    local title = Create("TextLabel", {
        Size = UDim2.new(1, 0, 0, 0),
        BackgroundTransparency = 1,
        Text = data.Title,
        TextColor3 = Color3.fromRGB(255, 255, 255),
        TextSize = 13,
        Font = Enum.Font.GothamBold,
        TextXAlignment = Enum.TextXAlignment.Left,
        AutomaticSize = Enum.AutomaticSize.Y,
    })
    title.Parent = textContainer
    
    if data.Content ~= "" then
        local content = Create("TextLabel", {
            Size = UDim2.new(1, 0, 0, 0),
            BackgroundTransparency = 1,
            Text = data.Content,
            TextColor3 = Color3.fromRGB(180, 180, 190),
            TextSize = 11,
            Font = Enum.Font.Gotham,
            TextXAlignment = Enum.TextXAlignment.Left,
            TextWrapped = true,
            AutomaticSize = Enum.AutomaticSize.Y,
        })
        content.Parent = textContainer
    end
    
    -- Progress bar
    local progressBg = Create("Frame", {
        Size = UDim2.new(1, 0, 0, 2),
        Position = UDim2.new(0, 0, 1, -2),
        BackgroundColor3 = Color3.fromRGB(40, 40, 50),
        BorderSizePixel = 0,
    })
    progressBg.Parent = notifFrame
    
    local progress = Create("Frame", {
        Size = UDim2.new(1, 0, 1, 0),
        BackgroundColor3 = data.Type == "success" and Color3.fromRGB(100, 255, 100) or 
                           data.Type == "error" and Color3.fromRGB(255, 100, 100) or
                           Color3.fromRGB(100, 180, 255),
        BorderSizePixel = 0,
    })
    progress.Parent = progressBg
    
    notifFrame.Parent = screenGui
    
    -- Animate in
    Tween(notifFrame, 0.4, {GroupTransparency = 0}, Enum.EasingStyle.Back, Enum.EasingDirection.Out)
    Tween(progress, data.Duration, {Size = UDim2.new(0, 0, 1, 0)}, Enum.EasingStyle.Linear)
    
    task.delay(data.Duration, function()
        Tween(notifFrame, 0.3, {GroupTransparency = 1, Position = UDim2.new(1, 20, 1, -80)})
        task.wait(0.3)
        notifFrame:Destroy()
        self:ShowNext()
    end)
end

-- Color Picker Component
local ColorPicker = {}
ColorPicker.__index = ColorPicker

function ColorPicker:New(parent, defaultColor, callback)
    local self = setmetatable({}, ColorPicker)
    self.Color = defaultColor or Color3.fromRGB(255, 255, 255)
    self.Callback = callback or function() end
    self.Opened = false
    
    -- Compact trigger button
    self.Trigger = Create("TextButton", {
        Size = UDim2.new(0, 32, 0, 32),
        BackgroundColor3 = self.Color,
        Text = "",
        Parent = parent,
    })
    
    local corner = Create("UICorner", {CornerRadius = UDim.new(0, 8)})
    corner.Parent = self.Trigger
    
    local stroke = Create("UIStroke", {
        Color = Color3.fromRGB(80, 80, 90),
        Thickness = 2,
    })
    stroke.Parent = self.Trigger
    
    -- Picker Frame (hidden initially)
    self.PickerFrame = Create("CanvasGroup", {
        Size = UDim2.new(0, 220, 0, 0),
        Position = UDim2.new(0, 0, 1, 10),
        BackgroundColor3 = Color3.fromRGB(30, 30, 35),
        GroupTransparency = 1,
        Visible = false,
        AutomaticSize = Enum.AutomaticSize.Y,
        ZIndex = 100,
    })
    self.PickerFrame.Parent = self.Trigger
    
    local pickerCorner = Create("UICorner", {CornerRadius = UDim.new(0, 16)})
    pickerCorner.Parent = self.PickerFrame
    
    AddGlassEffect(self.PickerFrame, 0.88)
    
    local pickerPadding = Create("UIPadding", {
        PaddingTop = UDim.new(0, 16),
        PaddingLeft = UDim.new(0, 16),
        PaddingRight = UDim.new(0, 16),
        PaddingBottom = UDim.new(0, 16),
    })
    pickerPadding.Parent = self.PickerFrame
    
    -- Saturation/Value Box
    self.SVMap = Create("ImageLabel", {
        Size = UDim2.new(0, 140, 0, 140),
        BackgroundColor3 = Color3.fromHSV(0, 1, 1),
        Image = "rbxassetid://4155801252",
    })
    self.SVMap.Parent = self.PickerFrame
    
    local svCorner = Create("UICorner", {CornerRadius = UDim.new(0, 12)})
    svCorner.Parent = self.SVMap
    
    -- SV Cursor
    self.SVCursor = Create("Frame", {
        Size = UDim2.new(0, 12, 0, 12),
        Position = UDim2.new(1, -6, 0, -6),
        AnchorPoint = Vector2.new(0.5, 0.5),
        BackgroundColor3 = Color3.fromRGB(255, 255, 255),
        BorderSizePixel = 0,
    })
    local cursorCorner = Create("UICorner", {CornerRadius = UDim.new(1, 0)})
    cursorCorner.Parent = self.SVCursor
    self.SVCursor.Parent = self.SVMap
    
    -- Hue Slider
    self.HueSlider = Create("Frame", {
        Size = UDim2.new(0, 20, 0, 140),
        Position = UDim2.new(1, -20, 0, 0),
        BackgroundColor3 = Color3.fromRGB(255, 255, 255),
    })
    self.HueSlider.Parent = self.SVMap
    
    local hueGradient = Create("UIGradient", {
        Color = ColorSequence.new({
            ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 0, 0)),
            ColorSequenceKeypoint.new(0.17, Color3.fromRGB(255, 255, 0)),
            ColorSequenceKeypoint.new(0.33, Color3.fromRGB(0, 255, 0)),
            ColorSequenceKeypoint.new(0.5, Color3.fromRGB(0, 255, 255)),
            ColorSequenceKeypoint.new(0.67, Color3.fromRGB(0, 0, 255)),
            ColorSequenceKeypoint.new(0.83, Color3.fromRGB(255, 0, 255)),
            ColorSequenceKeypoint.new(1, Color3.fromRGB(255, 0, 0)),
        }),
        Rotation = 90,
    })
    hueGradient.Parent = self.HueSlider
    
    local hueCorner = Create("UICorner", {CornerRadius = UDim.new(0, 10)})
    hueCorner.Parent = self.HueSlider
    
    -- Hue Cursor
    self.HueCursor = Create("Frame", {
        Size = UDim2.new(1, 4, 0, 4),
        Position = UDim2.new(0, -2, 0, 0),
        AnchorPoint = Vector2.new(0, 0.5),
        BackgroundColor3 = Color3.fromRGB(255, 255, 255),
        BorderSizePixel = 0,
    })
    self.HueCursor.Parent = self.HueSlider
    
    -- RGB Inputs
    local inputContainer = Create("Frame", {
        Size = UDim2.new(1, 0, 0, 28),
        Position = UDim2.new(0, 0, 0, 156),
        BackgroundTransparency = 1,
    })
    inputContainer.Parent = self.PickerFrame
    
    local inputLayout = Create("UIListLayout", {
        Padding = UDim.new(0, 6),
        FillDirection = Enum.FillDirection.Horizontal,
    })
    inputLayout.Parent = inputContainer
    
    local inputs = {}
    for i, label in ipairs({"R", "G", "B"}) do
        local inputFrame = Create("Frame", {
            Size = UDim2.new(0.33, -4, 1, 0),
            BackgroundColor3 = Color3.fromRGB(40, 40, 50),
        })
        local inputCorner = Create("UICorner", {CornerRadius = UDim.new(0, 6)})
        inputCorner.Parent = inputFrame
        
        local inputLabel = Create("TextLabel", {
            Size = UDim2.new(0, 20, 1, 0),
            BackgroundTransparency = 1,
            Text = label,
            TextColor3 = Color3.fromRGB(150, 150, 160),
            TextSize = 11,
            Font = Enum.Font.GothamBold,
        })
        inputLabel.Parent = inputFrame
        
        local inputBox = Create("TextBox", {
            Size = UDim2.new(1, -24, 1, 0),
            Position = UDim2.new(0, 20, 0, 0),
            BackgroundTransparency = 1,
            Text = "255",
            TextColor3 = Color3.fromRGB(255, 255, 255),
            TextSize = 12,
            Font = Enum.Font.Gotham,
            ClearTextOnFocus = false,
        })
        inputBox.Parent = inputFrame
        
        inputFrame.Parent = inputContainer
        inputs[label] = inputBox
    end
    
    self.RGBInputs = inputs
    
    -- Preview
    self.Preview = Create("Frame", {
        Size = UDim2.new(0, 40, 0, 28),
        Position = UDim2.new(1, -40, 0, 156),
        BackgroundColor3 = self.Color,
    })
    local previewCorner = Create("UICorner", {CornerRadius = UDim.new(0, 6)})
    previewCorner.Parent = self.Preview
    self.Preview.Parent = self.PickerFrame
    
    -- Interactions
    self.Trigger.MouseButton1Click:Connect(function()
        self:Toggle()
    end)
    
    self:SetupInteractions()
    self:UpdateFromColor(self.Color)
    
    return self
end

function ColorPicker:Toggle()
    self.Opened = not self.Opened
    self.PickerFrame.Visible = true
    
    if self.Opened then
        Tween(self.PickerFrame, 0.25, {GroupTransparency = 0}, Enum.EasingStyle.Back)
    else
        Tween(self.PickerFrame, 0.2, {GroupTransparency = 1})
        task.delay(0.2, function()
            if not self.Opened then
                self.PickerFrame.Visible = false
            end
        end)
    end
end

function ColorPicker:SetupInteractions()
    local dragging = false
    
    self.SVMap.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            self:UpdateSV(input)
        end
    end)
    
    self.HueSlider.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            self:UpdateHue(input)
        end
    end)
    
    UserInputService.InputChanged:Connect(function(input)
        if dragging then
            if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
                local pos = input.Position
                local svPos = self.SVMap.AbsolutePosition
                local svSize = self.SVMap.AbsoluteSize
                local huePos = self.HueSlider.AbsolutePosition
                local hueSize = self.HueSlider.AbsoluteSize
                
                if pos.X >= svPos.X and pos.X <= svPos.X + svSize.X and
                   pos.Y >= svPos.Y and pos.Y <= svPos.Y + svSize.Y then
                    self:UpdateSV(input)
                elseif pos.X >= huePos.X and pos.X <= huePos.X + hueSize.X and
                       pos.Y >= huePos.Y and pos.Y <= huePos.Y + hueSize.Y then
                    self:UpdateHue(input)
                end
            end
        end
    end)
    
    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = false
        end
    end)
    
    -- RGB inputs
    for label, input in pairs(self.RGBInputs) do
        input.FocusLost:Connect(function()
            local val = tonumber(input.Text) or 0
            val = math.clamp(val, 0, 255)
            input.Text = tostring(val)
            
            local r = tonumber(self.RGBInputs.R.Text) or 255
            local g = tonumber(self.RGBInputs.G.Text) or 255
            local b = tonumber(self.RGBInputs.B.Text) or 255
            self:UpdateFromColor(Color3.fromRGB(r, g, b))
        end)
    end
end

function ColorPicker:UpdateSV(input)
    local pos = input.Position
    local svPos = self.SVMap.AbsolutePosition
    local svSize = self.SVMap.AbsoluteSize
    
    local x = math.clamp((pos.X - svPos.X) / svSize.X, 0, 1)
    local y = math.clamp((pos.Y - svPos.Y) / svSize.Y, 0, 1)
    
    self.Sat = x
    self.Val = 1 - y
    
    self.SVCursor.Position = UDim2.new(x, 0, y, 0)
    self:UpdateColor()
end

function ColorPicker:UpdateHue(input)
    local pos = input.Position
    local huePos = self.HueSlider.AbsolutePosition
    local hueSize = self.HueSlider.AbsoluteSize
    
    local y = math.clamp((pos.Y - huePos.Y) / hueSize.Y, 0, 1)
    self.Hue = y
    
    self.HueCursor.Position = UDim2.new(0, 0, y, 0)
    self.SVMap.BackgroundColor3 = Color3.fromHSV(self.Hue, 1, 1)
    self:UpdateColor()
end

function ColorPicker:UpdateColor()
    local color = Color3.fromHSV(self.Hue or 0, self.Sat or 1, self.Val or 1)
    self.Color = color
    self.Trigger.BackgroundColor3 = color
    self.Preview.BackgroundColor3 = color
    
    -- Update RGB inputs
    local r = math.floor(color.R * 255)
    local g = math.floor(color.G * 255)
    local b = math.floor(color.B * 255)
    self.RGBInputs.R.Text = tostring(r)
    self.RGBInputs.G.Text = tostring(g)
    self.RGBInputs.B.Text = tostring(b)
    
    self.Callback(color)
end

function ColorPicker:UpdateFromColor(color)
    local h, s, v = Color3.toHSV(color)
    self.Hue = h
    self.Sat = s
    self.Val = v
    
    self.HueCursor.Position = UDim2.new(0, 0, h, 0)
    self.SVCursor.Position = UDim2.new(s, 0, 1 - v, 0)
    self.SVMap.BackgroundColor3 = Color3.fromHSV(h, 1, 1)
    
    local r = math.floor(color.R * 255)
    local g = math.floor(color.G * 255)
    local b = math.floor(color.B * 255)
    self.RGBInputs.R.Text = tostring(r)
    self.RGBInputs.G.Text = tostring(g)
    self.RGBInputs.B.Text = tostring(b)
    
    self.Trigger.BackgroundColor3 = color
    self.Preview.BackgroundColor3 = color
end

-- Main Window
function WindGlass:CreateWindow(config)
    config = config or {}
    local window = {}
    window.Title = config.Title or "WindGlass"
    window.SubTitle = config.SubTitle or ""
    window.Icon = config.Icon or "zap"
    window.Size = config.Size or UDim2.new(0, 520, 0, 340)
    window.Position = config.Position or UDim2.new(0.5, 0, 0.5, 0)
    window.Theme = config.Theme or "Dark"
    window.Scale = config.Scale or 1
    window.Tabs = {}
    window.CurrentTab = nil
    
    -- Main ScreenGui
    window.ScreenGui = Create("ScreenGui", {
        Name = "WindGlass",
        Parent = PlayerGui,
        ResetOnSpawn = false,
        ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
    })
    
    -- Scale container
    window.ScaleFrame = Create("Frame", {
        Size = UDim2.new(1, 0, 1, 0),
        BackgroundTransparency = 1,
        Parent = window.ScreenGui,
    })
    
    window.ScaleUI = Create("UIScale", {
        Scale = window.Scale,
    })
    window.ScaleUI.Parent = window.ScaleFrame
    
    -- Main container
    window.MainFrame = Create("CanvasGroup", {
        Size = window.Size,
        Position = window.Position,
        AnchorPoint = Vector2.new(0.5, 0.5),
        BackgroundColor3 = Color3.fromRGB(22, 22, 26),
        GroupTransparency = 1,
        Parent = window.ScaleFrame,
    })
    
    -- Glass effect
    AddGlassEffect(window.MainFrame, 0.82)
    
    -- Corner radius
    local mainCorner = Create("UICorner", {CornerRadius = UDim.new(0, 20)})
    mainCorner.Parent = window.MainFrame
    
    -- Stroke
    local mainStroke = Create("UIStroke", {
        Color = Color3.fromRGB(60, 60, 70),
        Thickness = 1.5,
        Transparency = 0.3,
    })
    mainStroke.Parent = window.MainFrame
    
    -- Top bar
    window.TopBar = Create("Frame", {
        Size = UDim2.new(1, 0, 0, 44),
        BackgroundTransparency = 1,
        Parent = window.MainFrame,
    })
    
    local topPadding = Create("UIPadding", {
        PaddingTop = UDim.new(0, 12),
        PaddingLeft = UDim.new(0, 16),
        PaddingRight = UDim.new(0, 16),
        PaddingBottom = UDim.new(0, 8),
    })
    topPadding.Parent = window.TopBar
    
    -- Title section
    local titleContainer = Create("Frame", {
        Size = UDim2.new(0, 0, 1, 0),
        BackgroundTransparency = 1,
        AutomaticSize = Enum.AutomaticSize.X,
    })
    titleContainer.Parent = window.TopBar
    
    local titleLayout = Create("UIListLayout", {
        Padding = UDim.new(0, 8),
        FillDirection = Enum.FillDirection.Horizontal,
        VerticalAlignment = Enum.VerticalAlignment.Center,
    })
    titleLayout.Parent = titleContainer
    
    -- Icon
    local titleIcon = Create("ImageLabel", {
        Size = UDim2.new(0, 20, 0, 20),
        BackgroundTransparency = 1,
        Image = Icons[window.Icon] or Icons["zap"],
        ImageColor3 = Color3.fromRGB(100, 180, 255),
    })
    titleIcon.Parent = titleContainer
    
    -- Title text
    local titleText = Create("TextLabel", {
        Size = UDim2.new(0, 0, 1, 0),
        BackgroundTransparency = 1,
        Text = window.Title,
        TextColor3 = Color3.fromRGB(255, 255, 255),
        TextSize = 15,
        Font = Enum.Font.GothamBold,
        AutomaticSize = Enum.AutomaticSize.X,
    })
    titleText.Parent = titleContainer
    
    if window.SubTitle ~= "" then
        local subTitle = Create("TextLabel", {
            Size = UDim2.new(0, 0, 0, 14),
            Position = UDim2.new(0, 28, 0, 22),
            BackgroundTransparency = 1,
            Text = window.SubTitle,
            TextColor3 = Color3.fromRGB(140, 140, 150),
            TextSize = 11,
            Font = Enum.Font.Gotham,
        })
        subTitle.Parent = window.TopBar
    end
    
    -- Control buttons
    local controls = Create("Frame", {
        Size = UDim2.new(0, 0, 1, 0),
        Position = UDim2.new(1, 0, 0, 0),
        AnchorPoint = Vector2.new(1, 0),
        BackgroundTransparency = 1,
        AutomaticSize = Enum.AutomaticSize.X,
    })
    controls.Parent = window.TopBar
    
    local controlsLayout = Create("UIListLayout", {
        Padding = UDim.new(0, 6),
        FillDirection = Enum.FillDirection.Horizontal,
        VerticalAlignment = Enum.VerticalAlignment.Center,
    })
    controlsLayout.Parent = controls
    
    -- Search button
    local searchBtn = Create("ImageButton", {
        Size = UDim2.new(0, 28, 0, 28),
        BackgroundTransparency = 0.9,
        BackgroundColor3 = Color3.fromRGB(50, 50, 60),
        Image = Icons["search"],
        ImageColor3 = Color3.fromRGB(180, 180, 190),
    })
    local searchCorner = Create("UICorner", {CornerRadius = UDim.new(0, 8)})
    searchCorner.Parent = searchBtn
    searchBtn.Parent = controls
    
    -- Minimize button
    local minBtn = Create("ImageButton", {
        Size = UDim2.new(0, 28, 0, 28),
        BackgroundTransparency = 0.9,
        BackgroundColor3 = Color3.fromRGB(50, 50, 60),
        Image = Icons["minus"],
        ImageColor3 = Color3.fromRGB(180, 180, 190),
    })
    local minCorner = Create("UICorner", {CornerRadius = UDim.new(0, 8)})
    minCorner.Parent = minBtn
    minBtn.Parent = controls
    
    -- Close button
    local closeBtn = Create("ImageButton", {
        Size = UDim2.new(0, 28, 0, 28),
        BackgroundTransparency = 0.9,
        BackgroundColor3 = Color3.fromRGB(50, 50, 60),
        Image = Icons["x"],
        ImageColor3 = Color3.fromRGB(255, 100, 100),
    })
    local closeCorner = Create("UICorner", {CornerRadius = UDim.new(0, 8)})
    closeCorner.Parent = closeBtn
    closeBtn.Parent = controls
    
    -- Sidebar
    window.SideBar = Create("ScrollingFrame", {
        Size = UDim2.new(0, 140, 1, -44),
        Position = UDim2.new(0, 0, 0, 44),
        BackgroundTransparency = 1,
        ScrollBarThickness = 0,
        ScrollBarImageTransparency = 1,
        CanvasSize = UDim2.new(0, 0, 0, 0),
        AutomaticCanvasSize = Enum.AutomaticSize.Y,
    })
    window.SideBar.Parent = window.MainFrame
    
    local sidePadding = Create("UIPadding", {
        PaddingTop = UDim2.new(0, 8),
        PaddingLeft = UDim.new(0, 12),
        PaddingRight = UDim.new(0, 8),
        PaddingBottom = UDim.new(0, 12),
    })
    sidePadding.Parent = window.SideBar
    
    local sideLayout = Create("UIListLayout", {
        Padding = UDim.new(0, 4),
        FillDirection = Enum.FillDirection.Vertical,
    })
    sideLayout.Parent = window.SideBar
    
    -- Tab highlight
    window.TabHighlight = Create("Frame", {
        Size = UDim2.new(0, 3, 0, 28),
        Position = UDim2.new(0, 0, 0, 0),
        BackgroundColor3 = Color3.fromRGB(100, 180, 255),
        BorderSizePixel = 0,
    })
    local highlightCorner = Create("UICorner", {CornerRadius = UDim.new(0, 2)})
    highlightCorner.Parent = window.TabHighlight
    window.TabHighlight.Parent = window.SideBar
    
    -- Content area
    window.Content = Create("Frame", {
        Size = UDim2.new(1, -148, 1, -52),
        Position = UDim2.new(0, 144, 0, 48),
        BackgroundTransparency = 0.95,
        BackgroundColor3 = Color3.fromRGB(40, 40, 50),
    })
    local contentCorner = Create("UICorner", {CornerRadius = UDim.new(0, 16)})
    contentCorner.Parent = window.Content
    window.Content.Parent = window.MainFrame
    
    -- Content scrolling
    window.ContentScroll = Create("ScrollingFrame", {
        Size = UDim2.new(1, 0, 1, 0),
        BackgroundTransparency = 1,
        ScrollBarThickness = 2,
        ScrollBarImageColor3 = Color3.fromRGB(80, 80, 90),
        CanvasSize = UDim2.new(0, 0, 0, 0),
        AutomaticCanvasSize = Enum.AutomaticSize.Y,
    })
    local contentPadding = Create("UIPadding", {
        PaddingTop = UDim.new(0, 16),
        PaddingLeft = UDim.new(0, 16),
        PaddingRight = UDim.new(0, 16),
        PaddingBottom = UDim.new(0, 16),
    })
    contentPadding.Parent = window.ContentScroll
    
    local contentLayout = Create("UIListLayout", {
        Padding = UDim.new(0, 10),
        FillDirection = Enum.FillDirection.Vertical,
    })
    contentLayout.Parent = window.ContentScroll
    window.ContentScroll.Parent = window.Content
    
    -- Resize handle (bottom-right)
    window.ResizeHandle = Create("ImageButton", {
        Size = UDim2.new(0, 24, 0, 24),
        Position = UDim2.new(1, -4, 1, -4),
        AnchorPoint = Vector2.new(1, 1),
        BackgroundTransparency = 1,
        Image = Icons["expand"],
        ImageColor3 = Color3.fromRGB(100, 100, 110),
        ImageTransparency = 0.5,
        ZIndex = 100,
    })
    window.ResizeHandle.Parent = window.MainFrame
    
    -- Scale indicator
    window.ScaleLabel = Create("TextLabel", {
        Size = UDim2.new(0, 50, 0, 20),
        Position = UDim2.new(1, -30, 1, -30),
        AnchorPoint = Vector2.new(1, 1),
        BackgroundTransparency = 0.3,
        BackgroundColor3 = Color3.fromRGB(30, 30, 35),
        Text = "100%",
        TextColor3 = Color3.fromRGB(180, 180, 190),
        TextSize = 10,
        Font = Enum.Font.Gotham,
        ZIndex = 101,
        Visible = false,
    })
    local scaleCorner = Create("UICorner", {CornerRadius = UDim.new(0, 6)})
    scaleCorner.Parent = window.ScaleLabel
    window.ScaleLabel.Parent = window.MainFrame
    
    -- Dragging
    local dragging = false
    local dragStart = nil
    local startPos = nil
    
    window.TopBar.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragStart = input.Position
            startPos = window.MainFrame.Position
            
            Tween(window.MainFrame, 0.15, {Size = UDim2.new(window.MainFrame.Size.X.Scale, window.MainFrame.Size.X.Offset * 0.98, window.MainFrame.Size.Y.Scale, window.MainFrame.Size.Y.Offset * 0.98)})
        end
    end)
    
    UserInputService.InputChanged:Connect(function(input)
        if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
            local delta = input.Position - dragStart
            window.MainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end
    end)
    
    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            if dragging then
                dragging = false
                Tween(window.MainFrame, 0.2, {Size = UDim2.new(window.MainFrame.Size.X.Scale, window.MainFrame.Size.X.Offset / 0.98, window.MainFrame.Size.Y.Scale, window.MainFrame.Size.Y.Offset / 0.98)}, Enum.EasingStyle.Back)
            end
        end
    end)
    
    -- Resizing
    local resizing = false
    local resizeStart = nil
    local startSize = nil
    
    window.ResizeHandle.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            resizing = true
            resizeStart = input.Position
            startSize = window.MainFrame.Size
            window.ScaleLabel.Visible = true
        end
    end)
    
    UserInputService.InputChanged:Connect(function(input)
        if resizing and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
            local delta = input.Position - resizeStart
            local newWidth = math.clamp(startSize.X.Offset + delta.X, 400, 800)
            local newHeight = math.clamp(startSize.Y.Offset + delta.Y, 280, 600)
            
            window.MainFrame.Size = UDim2.new(0, newWidth, 0, newHeight)
            
            local scale = math.floor((newWidth / window.Size.X.Offset) * 100)
            window.ScaleLabel.Text = scale .. "%"
        end
    end)
    
    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            resizing = false
            window.ScaleLabel.Visible = false
        end
    end)
    
    -- Hover effects for buttons
    local function AddHoverEffect(btn, hoverColor, defaultColor)
        btn.MouseEnter:Connect(function()
            Tween(btn, 0.15, {BackgroundTransparency = 0.7, ImageColor3 = hoverColor})
        end)
        btn.MouseLeave:Connect(function()
            Tween(btn, 0.15, {BackgroundTransparency = 0.9, ImageColor3 = defaultColor})
        end)
    end
    
    AddHoverEffect(searchBtn, Color3.fromRGB(255, 255, 255), Color3.fromRGB(180, 180, 190))
    AddHoverEffect(minBtn, Color3.fromRGB(255, 255, 255), Color3.fromRGB(180, 180, 190))
    AddHoverEffect(closeBtn, Color3.fromRGB(255, 150, 150), Color3.fromRGB(255, 100, 100))
    
    -- Close animation
    closeBtn.MouseButton1Click:Connect(function()
        Tween(window.MainFrame, 0.3, {GroupTransparency = 1, Size = UDim2.new(window.MainFrame.Size.X.Scale, window.MainFrame.Size.X.Offset * 0.9, window.MainFrame.Size.Y.Scale, window.MainFrame.Size.Y.Offset * 0.9)})
        task.delay(0.3, function()
            window.ScreenGui.Enabled = false
        end)
    end)
    
    -- Minimize
    local minimized = false
    minBtn.MouseButton1Click:Connect(function()
        minimized = not minimized
        if minimized then
            Tween(window.Content, 0.25, {GroupTransparency = 1})
            Tween(window.SideBar, 0.25, {GroupTransparency = 1})
            Tween(window.MainFrame, 0.25, {Size = UDim2.new(0, window.MainFrame.Size.X.Offset, 0, 44)})
        else
            Tween(window.Content, 0.25, {GroupTransparency = 0})
            Tween(window.SideBar, 0.25, {GroupTransparency = 0})
            Tween(window.MainFrame, 0.25, {Size = window.Size})
        end
    end)
    
    -- Open animation
    task.spawn(function()
        Tween(window.MainFrame, 0.4, {GroupTransparency = 0}, Enum.EasingStyle.Back)
    end)
    
    -- Tab creation function
    function window:CreateTab(tabConfig)
        tabConfig = tabConfig or {}
        local tab = {}
        tab.Name = tabConfig.Name or "Tab"
        tab.Icon = tabConfig.Icon or "home"
        tab.Content = {}
        
        -- Tab button
        tab.Button = Create("TextButton", {
            Size = UDim2.new(1, 0, 0, 32),
            BackgroundTransparency = 1,
            Text = "",
            Parent = self.SideBar,
        })
        
        local tabLayout = Create("UIListLayout", {
            Padding = UDim.new(0, 8),
            FillDirection = Enum.FillDirection.Horizontal,
            VerticalAlignment = Enum.VerticalAlignment.Center,
        })
        tabLayout.Parent = tab.Button
        
        local tabPadding = Create("UIPadding", {
            PaddingLeft = UDim.new(0, 12),
        })
        tabPadding.Parent = tab.Button
        
        local tabIcon = Create("ImageLabel", {
            Size = UDim2.new(0, 16, 0, 16),
            BackgroundTransparency = 1,
            Image = Icons[tab.Icon] or Icons["home"],
            ImageColor3 = Color3.fromRGB(140, 140, 150),
        })
        tabIcon.Parent = tab.Button
        
        local tabLabel = Create("TextLabel", {
            Size = UDim2.new(1, -24, 1, 0),
            BackgroundTransparency = 1,
            Text = tab.Name,
            TextColor3 = Color3.fromRGB(140, 140, 150),
            TextSize = 12,
            Font = Enum.Font.GothamMedium,
            TextXAlignment = Enum.TextXAlignment.Left,
        })
        tabLabel.Parent = tab.Button
        
        -- Tab content container
        tab.Container = Create("Frame", {
            Size = UDim2.new(1, 0, 0, 0),
            BackgroundTransparency = 1,
            Visible = false,
            AutomaticSize = Enum.AutomaticSize.Y,
        })
        local containerLayout = Create("UIListLayout", {
            Padding = UDim.new(0, 10),
            FillDirection = Enum.FillDirection.Vertical,
        })
        containerLayout.Parent = tab.Container
        tab.Container.Parent = self.ContentScroll
        
        -- Selection
        tab.Button.MouseButton1Click:Connect(function()
            self:SelectTab(tab)
        end)
        
        -- Hover
        tab.Button.MouseEnter:Connect(function()
            if self.CurrentTab ~= tab then
                Tween(tab.Button, 0.15, {BackgroundTransparency = 0.95})
            end
        end)
        tab.Button.MouseLeave:Connect(function()
            if self.CurrentTab ~= tab then
                Tween(tab.Button, 0.15, {BackgroundTransparency = 1})
            end
        end)
        
        table.insert(self.Tabs, tab)
        
        -- Auto select first tab
        if #self.Tabs == 1 then
            self:SelectTab(tab)
        end
        
        return tab
    end
    
    -- Tab selection
    function window:SelectTab(tab)
        if self.CurrentTab == tab then return end
        
        -- Deselect current
        if self.CurrentTab then
            Tween(self.CurrentTab.Button, 0.2, {BackgroundTransparency = 1})
            Tween(self.CurrentTab.Button:FindFirstChildOfClass("UIListLayout").Parent:FindFirstChild("ImageLabel"), 0.2, {ImageColor3 = Color3.fromRGB(140, 140, 150)})
            Tween(self.CurrentTab.Button:FindFirstChildOfClass("UIListLayout").Parent:FindFirstChild("TextLabel"), 0.2, {TextColor3 = Color3.fromRGB(140, 140, 150)})
            self.CurrentTab.Container.Visible = false
        end
        
        -- Select new
        self.CurrentTab = tab
        Tween(tab.Button, 0.2, {BackgroundTransparency = 0.9, BackgroundColor3 = Color3.fromRGB(50, 50, 60)})
        Tween(tabIcon, 0.2, {ImageColor3 = Color3.fromRGB(100, 180, 255)})
        Tween(tabLabel, 0.2, {TextColor3 = Color3.fromRGB(255, 255, 255)})
        
        -- Move highlight
        local btnPos = tab.Button.AbsolutePosition.Y - self.SideBar.AbsolutePosition.Y
        Tween(self.TabHighlight, 0.3, {Position = UDim2.new(0, 0, 0, btnPos + 2), Size = UDim2.new(0, 3, 0, tab.Button.AbsoluteSize.Y - 4)}, Enum.EasingStyle.Quint)
        
        tab.Container.Visible = true
        
        -- Animate content
        for _, child in pairs(tab.Container:GetChildren()) do
            if child:IsA("Frame") or child:IsA("TextButton") then
                child.Position = UDim2.new(0, 20, child.Position.Y.Scale, child.Position.Y.Offset)
                Tween(child, 0.3, {Position = UDim2.new(0, 0, child.Position.Y.Scale, child.Position.Y.Offset)})
            end
        end
    end
    
    -- Section creation
    function window:CreateSection(tab, title)
        local section = Create("Frame", {
            Size = UDim2.new(1, 0, 0, 0),
            BackgroundTransparency = 0.95,
            BackgroundColor3 = Color3.fromRGB(45, 45, 55),
            AutomaticSize = Enum.AutomaticSize.Y,
            Parent = tab.Container,
        })
        
        local sectionCorner = Create("UICorner", {CornerRadius = UDim.new(0, 12)})
        sectionCorner.Parent = section
        
        local sectionPadding = Create("UIPadding", {
            PaddingTop = UDim.new(0, 14),
            PaddingLeft = UDim.new(0, 14),
            PaddingRight = UDim.new(0, 14),
            PaddingBottom = UDim.new(0, 14),
        })
        sectionPadding.Parent = section
        
        if title then
            local sectionTitle = Create("TextLabel", {
                Size = UDim2.new(1, 0, 0, 18),
                BackgroundTransparency = 1,
                Text = title,
                TextColor3 = Color3.fromRGB(200, 200, 210),
                TextSize = 13,
                Font = Enum.Font.GothamBold,
                TextXAlignment = Enum.TextXAlignment.Left,
            })
            sectionTitle.Parent = section
            
            local divider = Create("Frame", {
                Size = UDim2.new(1, 0, 0, 1),
                Position = UDim2.new(0, 0, 0, 26),
                BackgroundColor3 = Color3.fromRGB(60, 60, 70),
                BackgroundTransparency = 0.5,
            })
            divider.Parent = section
            
            local contentFrame = Create("Frame", {
                Size = UDim2.new(1, 0, 0, 0),
                Position = UDim2.new(0, 0, 0, 36),
                BackgroundTransparency = 1,
                AutomaticSize = Enum.AutomaticSize.Y,
            })
            local contentLayout = Create("UIListLayout", {
                Padding = UDim.new(0, 8),
                FillDirection = Enum.FillDirection.Vertical,
            })
            contentLayout.Parent = contentFrame
            contentFrame.Parent = section
            
            return contentFrame
        else
            local contentLayout = Create("UIListLayout", {
                Padding = UDim.new(0, 8),
                FillDirection = Enum.FillDirection.Vertical,
            })
            contentLayout.Parent = section
            
            return section
        end
    end
    
    -- Toggle component
    function window:CreateToggle(parent, config)
        config = config or {}
        local toggle = {}
        toggle.Title = config.Title or "Toggle"
        toggle.Description = config.Description
        toggle.Value = config.Default or false
        toggle.Callback = config.Callback or function() end
        
        local frame = Create("Frame", {
            Size = UDim2.new(1, 0, 0, toggle.Description and 50 or 36),
            BackgroundTransparency = 1,
            Parent = parent,
        })
        
        local textContainer = Create("Frame", {
            Size = UDim2.new(1, -56, 1, 0),
            BackgroundTransparency = 1,
        })
        textContainer.Parent = frame
        
        local textLayout = Create("UIListLayout", {
            Padding = UDim.new(0, 2),
            FillDirection = Enum.FillDirection.Vertical,
            VerticalAlignment = Enum.VerticalAlignment.Center,
        })
        textLayout.Parent = textContainer
        
        local title = Create("TextLabel", {
            Size = UDim2.new(1, 0, 0, 16),
            BackgroundTransparency = 1,
            Text = toggle.Title,
            TextColor3 = Color3.fromRGB(230, 230, 240),
            TextSize = 13,
            Font = Enum.Font.GothamMedium,
            TextXAlignment = Enum.TextXAlignment.Left,
        })
        title.Parent = textContainer
        
        if toggle.Description then
            local desc = Create("TextLabel", {
                Size = UDim2.new(1, 0, 0, 14),
                BackgroundTransparency = 1,
                Text = toggle.Description,
                TextColor3 = Color3.fromRGB(140, 140, 150),
                TextSize = 11,
                Font = Enum.Font.Gotham,
                TextXAlignment = Enum.TextXAlignment.Left,
            })
            desc.Parent = textContainer
        end
        
        -- Toggle switch
        local switch = Create("TextButton", {
            Size = UDim2.new(0, 44, 0, 24),
            Position = UDim2.new(1, 0, 0.5, 0),
            AnchorPoint = Vector2.new(1, 0.5),
            BackgroundColor3 = Color3.fromRGB(60, 60, 70),
            Text = "",
        })
        local switchCorner = Create("UICorner", {CornerRadius = UDim.new(1, 0)})
        switchCorner.Parent = switch
        switch.Parent = frame
        
        local knob = Create("Frame", {
            Size = UDim2.new(0, 18, 0, 18),
            Position = UDim2.new(0, 3, 0.5, 0),
            AnchorPoint = Vector2.new(0, 0.5),
            BackgroundColor3 = Color3.fromRGB(255, 255, 255),
        })
        local knobCorner = Create("UICorner", {CornerRadius = UDim.new(1, 0)})
        knobCorner.Parent = knob
        knob.Parent = switch
        
        -- Glow effect when on
        local glow = Create("ImageLabel", {
            Size = UDim2.new(1, 20, 1, 20),
            Position = UDim2.new(0.5, 0, 0.5, 0),
            AnchorPoint = Vector2.new(0.5, 0.5),
            BackgroundTransparency = 1,
            Image = "rbxassetid://8992230677",
            ImageColor3 = Color3.fromRGB(100, 180, 255),
            ImageTransparency = 1,
            ScaleType = Enum.ScaleType.Slice,
            SliceCenter = Rect.new(99, 99, 99, 99),
            ZIndex = 0,
        })
        glow.Parent = switch
        
        function toggle:Set(value)
            toggle.Value = value
            if value then
                Tween(switch, 0.25, {BackgroundColor3 = Color3.fromRGB(100, 180, 255)})
                Tween(knob, 0.25, {Position = UDim2.new(0, 23, 0.5, 0)}, Enum.EasingStyle.Back)
                Tween(glow, 0.25, {ImageTransparency = 0.7})
            else
                Tween(switch, 0.25, {BackgroundColor3 = Color3.fromRGB(60, 60, 70)})
                Tween(knob, 0.25, {Position = UDim2.new(0, 3, 0.5, 0)}, Enum.EasingStyle.Back)
                Tween(glow, 0.25, {ImageTransparency = 1})
            end
            toggle.Callback(value)
        end
        
        switch.MouseButton1Click:Connect(function()
            toggle:Set(not toggle.Value)
        end)
        
        toggle:Set(toggle.Value)
        
        return toggle
    end
    
    -- Slider component
    function window:CreateSlider(parent, config)
        config = config or {}
        local slider = {}
        slider.Title = config.Title or "Slider"
        slider.Min = config.Min or 0
        slider.Max = config.Max or 100
        slider.Value = config.Default or slider.Min
        slider.Step = config.Step or 1
        slider.Suffix = config.Suffix or ""
        slider.Callback = config.Callback or function() end
        
        local frame = Create("Frame", {
            Size = UDim2.new(1, 0, 0, 56),
            BackgroundTransparency = 1,
            Parent = parent,
        })
        
        local title = Create("TextLabel", {
            Size = UDim2.new(0.5, 0, 0, 18),
            BackgroundTransparency = 1,
            Text = slider.Title,
            TextColor3 = Color3.fromRGB(230, 230, 240),
            TextSize = 13,
            Font = Enum.Font.GothamMedium,
            TextXAlignment = Enum.TextXAlignment.Left,
        })
        title.Parent = frame
        
        local valueBox = Create("TextBox", {
            Size = UDim2.new(0, 60, 0, 22),
            Position = UDim2.new(1, 0, 0, 0),
            AnchorPoint = Vector2.new(1, 0),
            BackgroundColor3 = Color3.fromRGB(45, 45, 55),
            Text = tostring(slider.Value) .. slider.Suffix,
            TextColor3 = Color3.fromRGB(180, 180, 190),
            TextSize = 12,
            Font = Enum.Font.Gotham,
            ClearTextOnFocus = false,
        })
        local valueCorner = Create("UICorner", {CornerRadius = UDim.new(0, 6)})
        valueCorner.Parent = valueBox
        valueBox.Parent = frame
        
        -- Slider track
        local track = Create("Frame", {
            Size = UDim2.new(1, 0, 0, 6),
            Position = UDim2.new(0, 0, 0, 36),
            BackgroundColor3 = Color3.fromRGB(50, 50, 60),
            BorderSizePixel = 0,
        })
        local trackCorner = Create("UICorner", {CornerRadius = UDim.new(1, 0)})
        trackCorner.Parent = track
        track.Parent = frame
        
        -- Fill
        local fill = Create("Frame", {
            Size = UDim2.new(0, 0, 1, 0),
            BackgroundColor3 = Color3.fromRGB(100, 180, 255),
            BorderSizePixel = 0,
        })
        local fillCorner = Create("UICorner", {CornerRadius = UDim.new(1, 0)})
        fillCorner.Parent = fill
        fill.Parent = track
        
        -- Handle
        local handle = Create("Frame", {
            Size = UDim2.new(0, 16, 0, 16),
            Position = UDim2.new(0, 0, 0.5, 0),
            AnchorPoint = Vector2.new(0.5, 0.5),
            BackgroundColor3 = Color3.fromRGB(255, 255, 255),
            BorderSizePixel = 0,
        })
        local handleCorner = Create("UICorner", {CornerRadius = UDim.new(1, 0)})
        handleCorner.Parent = handle
        handle.Parent = track
        
        -- Handle glow
        local handleGlow = Create("ImageLabel", {
            Size = UDim2.new(1, 10, 1, 10),
            Position = UDim2.new(0.5, 0, 0.5, 0),
            AnchorPoint = Vector2.new(0.5, 0.5),
            BackgroundTransparency = 1,
            Image = "rbxassetid://8992230677",
            ImageColor3 = Color3.fromRGB(100, 180, 255),
            ImageTransparency = 0.5,
            ScaleType = Enum.ScaleType.Slice,
            SliceCenter = Rect.new(99, 99, 99, 99),
            ZIndex = 0,
        })
        handleGlow.Parent = handle
        
        function slider:Set(value)
            value = math.clamp(value, slider.Min, slider.Max)
            value = math.floor(value / slider.Step + 0.5) * slider.Step
            slider.Value = value
            
            local percent = (value - slider.Min) / (slider.Max - slider.Min)
            Tween(fill, 0.15, {Size = UDim2.new(percent, 0, 1, 0)})
            Tween(handle, 0.15, {Position = UDim2.new(percent, 0, 0.5, 0)})
            
            valueBox.Text = tostring(value) .. slider.Suffix
            slider.Callback(value)
        end
        
        -- Dragging
        local dragging = false
        
        track.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                dragging = true
                local pos = input.Position.X
                local trackPos = track.AbsolutePosition.X
                local trackSize = track.AbsoluteSize.X
                local percent = math.clamp((pos - trackPos) / trackSize, 0, 1)
                slider:Set(slider.Min + percent * (slider.Max - slider.Min))
            end
        end)
        
        UserInputService.InputChanged:Connect(function(input)
            if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
                local pos = input.Position.X
                local trackPos = track.AbsolutePosition.X
                local trackSize = track.AbsoluteSize.X
                local percent = math.clamp((pos - trackPos) / trackSize, 0, 1)
                slider:Set(slider.Min + percent * (slider.Max - slider.Min))
            end
        end)
        
        UserInputService.InputEnded:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                dragging = false
            end
        end)
        
        valueBox.FocusLost:Connect(function()
            local val = tonumber(valueBox.Text:gsub(slider.Suffix, "")) or slider.Min
            slider:Set(val)
        end)
        
        slider:Set(slider.Value)
        
        return slider
    end
    
    -- Button component
    function window:CreateButton(parent, config)
        config = config or {}
        local btn = {}
        btn.Title = config.Title or "Button"
        btn.Icon = config.Icon
        btn.Variant = config.Variant or "Secondary"
        btn.Callback = config.Callback or function() end
        
        local frame = Create("TextButton", {
            Size = UDim2.new(1, 0, 0, 36),
            BackgroundColor3 = btn.Variant == "Primary" and Color3.fromRGB(100, 180, 255) or Color3.fromRGB(50, 50, 60),
            Text = "",
            Parent = parent,
        })
        
        local corner = Create("UICorner", {CornerRadius = UDim.new(0, 10)})
        corner.Parent = frame
        
        local layout = Create("UIListLayout", {
            Padding = UDim.new(0, 8),
            FillDirection = Enum.FillDirection.Horizontal,
            VerticalAlignment = Enum.VerticalAlignment.Center,
            HorizontalAlignment = Enum.HorizontalAlignment.Center,
        })
        layout.Parent = frame
        
        if btn.Icon then
            local icon = Create("ImageLabel", {
                Size = UDim2.new(0, 16, 0, 16),
                BackgroundTransparency = 1,
                Image = Icons[btn.Icon] or Icons["zap"],
                ImageColor3 = btn.Variant == "Primary" and Color3.fromRGB(255, 255, 255) or Color3.fromRGB(200, 200, 210),
            })
            icon.Parent = frame
        end
        
        local label = Create("TextLabel", {
            Size = UDim2.new(0, 0, 1, 0),
            BackgroundTransparency = 1,
            Text = btn.Title,
            TextColor3 = btn.Variant == "Primary" and Color3.fromRGB(255, 255, 255) or Color3.fromRGB(230, 230, 240),
            TextSize = 13,
            Font = Enum.Font.GothamMedium,
            AutomaticSize = Enum.AutomaticSize.X,
        })
        label.Parent = frame
        
        -- Effects
        frame.MouseEnter:Connect(function()
            Tween(frame, 0.15, {BackgroundColor3 = btn.Variant == "Primary" and Color3.fromRGB(120, 200, 255) or Color3.fromRGB(65, 65, 75)})
        end)
        
        frame.MouseLeave:Connect(function()
            Tween(frame, 0.15, {BackgroundColor3 = btn.Variant == "Primary" and Color3.fromRGB(100, 180, 255) or Color3.fromRGB(50, 50, 60)})
        end)
        
        frame.MouseButton1Down:Connect(function()
            Tween(frame, 0.1, {Size = UDim2.new(0.98, 0, 0, 36)})
        end)
        
        frame.MouseButton1Up:Connect(function()
            Tween(frame, 0.15, {Size = UDim2.new(1, 0, 0, 36)}, Enum.EasingStyle.Back)
        end)
        
        frame.MouseButton1Click:Connect(function()
            btn.Callback()
        end)
        
        return btn
    end
    
    -- Dropdown component
    function window:CreateDropdown(parent, config)
        config = config or {}
        local dropdown = {}
        dropdown.Title = config.Title or "Dropdown"
        dropdown.Options = config.Options or {}
        dropdown.Value = config.Default or dropdown.Options[1]
        dropdown.Callback = config.Callback or function() end
        
        local frame = Create("Frame", {
            Size = UDim2.new(1, 0, 0, 64),
            BackgroundTransparency = 1,
            Parent = parent,
        })
        
        local title = Create("TextLabel", {
            Size = UDim2.new(1, 0, 0, 18),
            BackgroundTransparency = 1,
            Text = dropdown.Title,
            TextColor3 = Color3.fromRGB(230, 230, 240),
            TextSize = 13,
            Font = Enum.Font.GothamMedium,
            TextXAlignment = Enum.TextXAlignment.Left,
        })
        title.Parent = frame
        
        local trigger = Create("TextButton", {
            Size = UDim2.new(1, 0, 0, 36),
            Position = UDim2.new(0, 0, 0, 26),
            BackgroundColor3 = Color3.fromRGB(45, 45, 55),
            Text = "",
        })
        local triggerCorner = Create("UICorner", {CornerRadius = UDim.new(0, 10)})
        triggerCorner.Parent = trigger
        trigger.Parent = frame
        
        local triggerLayout = Create("UIListLayout", {
            Padding = UDim.new(0, 8),
            FillDirection = Enum.FillDirection.Horizontal,
            VerticalAlignment = Enum.VerticalAlignment.Center,
        })
        triggerLayout.Parent = trigger
        
        local triggerPadding = Create("UIPadding", {
            PaddingLeft = UDim.new(0, 12),
            PaddingRight = UDim.new(0, 12),
        })
        triggerPadding.Parent = trigger
        
        local valueLabel = Create("TextLabel", {
            Size = UDim2.new(1, -28, 1, 0),
            BackgroundTransparency = 1,
            Text = dropdown.Value or "Select...",
            TextColor3 = Color3.fromRGB(200, 200, 210),
            TextSize = 13,
            Font = Enum.Font.Gotham,
            TextXAlignment = Enum.TextXAlignment.Left,
        })
        valueLabel.Parent = trigger
        
        local arrow = Create("ImageLabel", {
            Size = UDim2.new(0, 16, 0, 16),
            BackgroundTransparency = 1,
            Image = Icons["chevron-down"],
            ImageColor3 = Color3.fromRGB(140, 140, 150),
        })
        arrow.Parent = trigger
        
        -- Dropdown menu
        local menu = Create("CanvasGroup", {
            Size = UDim2.new(1, 0, 0, 0),
            Position = UDim2.new(0, 0, 1, 8),
            BackgroundColor3 = Color3.fromRGB(35, 35, 42),
            GroupTransparency = 1,
            Visible = false,
            AutomaticSize = Enum.AutomaticSize.Y,
            ZIndex = 50,
        })
        AddGlassEffect(menu, 0.9)
        local menuCorner = Create("UICorner", {CornerRadius = UDim.new(0, 12)})
        menuCorner.Parent = menu
        menu.Parent = trigger
        
        local menuPadding = Create("UIPadding", {
            PaddingTop = UDim.new(0, 8),
            PaddingLeft = UDim.new(0, 8),
            PaddingRight = UDim.new(0, 8),
            PaddingBottom = UDim.new(0, 8),
        })
        menuPadding.Parent = menu
        
        local menuLayout = Create("UIListLayout", {
            Padding = UDim.new(0, 4),
            FillDirection = Enum.FillDirection.Vertical,
        })
        menuLayout.Parent = menu
        
        dropdown.Opened = false
        
        function dropdown:Refresh(options)
            for _, child in pairs(menu:GetChildren()) do
                if child:IsA("TextButton") then
                    child:Destroy()
                end
            end
            
            for _, option in pairs(options) do
                local optBtn = Create("TextButton", {
                    Size = UDim2.new(1, 0, 0, 32),
                    BackgroundTransparency = 1,
                    Text = "",
                })
                
                local optLayout = Create("UIListLayout", {
                    Padding = UDim.new(0, 8),
                    FillDirection = Enum.FillDirection.Horizontal,
                    VerticalAlignment = Enum.VerticalAlignment.Center,
                })
                optLayout.Parent = optBtn
                
                local optPadding = Create("UIPadding", {
                    PaddingLeft = UDim.new(0, 10),
                })
                optPadding.Parent = optBtn
                
                local checkIcon = Create("ImageLabel", {
                    Size = UDim2.new(0, 16, 0, 16),
                    BackgroundTransparency = 1,
                    Image = Icons["check"],
                    ImageColor3 = Color3.fromRGB(100, 180, 255),
                    ImageTransparency = dropdown.Value == option and 0 or 1,
                })
                checkIcon.Parent = optBtn
                
                local optLabel = Create("TextLabel", {
                    Size = UDim2.new(1, -24, 1, 0),
                    BackgroundTransparency = 1,
                    Text = option,
                    TextColor3 = Color3.fromRGB(200, 200, 210),
                    TextSize = 12,
                    Font = Enum.Font.Gotham,
                    TextXAlignment = Enum.TextXAlignment.Left,
                })
                optLabel.Parent = optBtn
                
                optBtn.MouseEnter:Connect(function()
                    Tween(optBtn, 0.15, {BackgroundTransparency = 0.9, BackgroundColor3 = Color3.fromRGB(50, 50, 60)})
                end)
                
                optBtn.MouseLeave:Connect(function()
                    Tween(optBtn, 0.15, {BackgroundTransparency = 1})
                end)
                
                optBtn.MouseButton1Click:Connect(function()
                    dropdown:Set(option)
                    dropdown:Close()
                end)
                
                optBtn.Parent = menu
            end
        end
        
        function dropdown:Set(value)
            dropdown.Value = value
            valueLabel.Text = value
            dropdown.Callback(value)
            self:Refresh(dropdown.Options)
        end
        
        function dropdown:Open()
            dropdown.Opened = true
            menu.Visible = true
            Tween(menu, 0.2, {GroupTransparency = 0})
            Tween(arrow, 0.2, {Rotation = 180})
        end
        
        function dropdown:Close()
            dropdown.Opened = false
            Tween(menu, 0.2, {GroupTransparency = 1})
            Tween(arrow, 0.2, {Rotation = 0})
            task.delay(0.2, function()
                if not dropdown.Opened then
                    menu.Visible = false
                end
            end)
        end
        
        trigger.MouseButton1Click:Connect(function()
            if dropdown.Opened then
                dropdown:Close()
            else
                dropdown:Open()
            end
        end)
        
        dropdown:Refresh(dropdown.Options)
        
        return dropdown
    end
    
    -- Input component
    function window:CreateInput(parent, config)
        config = config or {}
        local input = {}
        input.Title = config.Title or "Input"
        input.Placeholder = config.Placeholder or "Enter text..."
        input.Value = config.Default or ""
        input.Callback = config.Callback or function() end
        
        local frame = Create("Frame", {
            Size = UDim2.new(1, 0, 0, 64),
            BackgroundTransparency = 1,
            Parent = parent,
        })
        
        local title = Create("TextLabel", {
            Size = UDim2.new(1, 0, 0, 18),
            BackgroundTransparency = 1,
            Text = input.Title,
            TextColor3 = Color3.fromRGB(230, 230, 240),
            TextSize = 13,
            Font = Enum.Font.GothamMedium,
            TextXAlignment = Enum.TextXAlignment.Left,
        })
        title.Parent = frame
        
        local inputBox = Create("TextBox", {
            Size = UDim2.new(1, 0, 0, 36),
            Position = UDim2.new(0, 0, 0, 26),
            BackgroundColor3 = Color3.fromRGB(45, 45, 55),
            Text = input.Value,
            PlaceholderText = input.Placeholder,
            TextColor3 = Color3.fromRGB(230, 230, 240),
            PlaceholderColor3 = Color3.fromRGB(100, 100, 110),
            TextSize = 13,
            Font = Enum.Font.Gotham,
            ClearTextOnFocus = false,
        })
        local inputCorner = Create("UICorner", {CornerRadius = UDim.new(0, 10)})
        inputCorner.Parent = inputBox
        
        local inputPadding = Create("UIPadding", {
            PaddingLeft = UDim.new(0, 12),
            PaddingRight = UDim.new(0, 12),
        })
        inputPadding.Parent = inputBox
        inputBox.Parent = frame
        
        -- Focus effects
        inputBox.Focused:Connect(function()
            Tween(inputBox, 0.2, {BackgroundColor3 = Color3.fromRGB(55, 55, 65)})
        end)
        
        inputBox.FocusLost:Connect(function()
            Tween(inputBox, 0.2, {BackgroundColor3 = Color3.fromRGB(45, 45, 55)})
            input.Value = inputBox.Text
            input.Callback(inputBox.Text)
        end)
        
        return input
    end
    
    -- Color picker wrapper
    function window:CreateColorPicker(parent, config)
        config = config or {}
        local picker = {}
        picker.Title = config.Title or "Color"
        picker.Value = config.Default or Color3.fromRGB(100, 180, 255)
        picker.Callback = config.Callback or function() end
        
        local frame = Create("Frame", {
            Size = UDim2.new(1, 0, 0, 40),
            BackgroundTransparency = 1,
            Parent = parent,
        })
        
        local title = Create("TextLabel", {
            Size = UDim2.new(1, -40, 1, 0),
            BackgroundTransparency = 1,
            Text = picker.Title,
            TextColor3 = Color3.fromRGB(230, 230, 240),
            TextSize = 13,
            Font = Enum.Font.GothamMedium,
            TextXAlignment = Enum.TextXAlignment.Left,
        })
        title.Parent = frame
        
        local colorPicker = ColorPicker:New(frame, picker.Value, function(color)
            picker.Value = color
            picker.Callback(color)
        end)
        
        colorPicker.Trigger.Position = UDim2.new(1, 0, 0.5, 0)
        colorPicker.Trigger.AnchorPoint = Vector2.new(1, 0.5)
        
        return picker
    end
    
    -- Notification wrapper
    function window:Notify(data)
        NotificationSystem:New(data)
    end
    
    return window
end

-- Return library
return WindGlass