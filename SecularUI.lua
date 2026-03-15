local S = game:GetService("Players")
local R = game:GetService("RunService")
local T = game:GetService("TweenService")
local U = game:GetService("UserInputService")
local P = S.LocalPlayer
local G = P:WaitForChild("PlayerGui")

local I = {
    x = "rbxassetid://7733658504",
    check = "rbxassetid://7733715400",
    ["chevron-down"] = "rbxassetid://7733717447",
    settings = "rbxassetid://7734053495",
    search = "rbxassetid://7734052921",
    plus = "rbxassetid://7733710700",
    minus = "rbxassetid://7733710672",
    trash = "rbxassetid://7734053657",
    eye = "rbxassetid://7733715400",
    ["eye-off"] = "rbxassetid://7734053216",
    home = "rbxassetid://7733715400",
    user = "rbxassetid://7734053657",
    bell = "rbxassetid://7733710700",
    moon = "rbxassetid://7734053495",
    sun = "rbxassetid://7734053657",
    zap = "rbxassetid://7734053657",
    target = "rbxassetid://7734053246",
    sliders = "rbxassetid://7734053246",
    info = "rbxassetid://7734053495",
    lock = "rbxassetid://7734053495",
    unlock = "rbxassetid://7734053216",
    key = "rbxassetid://7734053495",
    copy = "rbxassetid://7733710700",
    clipboard = "rbxassetid://7733710700",
}

local function C(t, p, ch)
    local i = Instance.new(t)
    for k, v in pairs(p or {}) do i[k] = v end
    for _, c in pairs(ch or {}) do c.Parent = i end
    return i
end

local function Tw(i, d, p, s, dir)
    s = s or Enum.EasingStyle.Quint
    dir = dir or Enum.EasingDirection.Out
    local tw = T:Create(i, TweenInfo.new(d, s, dir), p)
    tw:Play()
    return tw
end

local function Gl(f, a)
    a = a or 0.5
    local b = C("ImageLabel", {
        Name = "B",
        Size = UDim2.new(1, 40, 1, 40),
        Position = UDim2.new(0, -20, 0, -20),
        BackgroundTransparency = 1,
        Image = "rbxassetid://8992230677",
        ImageColor3 = Color3.fromRGB(0, 0, 0),
        ImageTransparency = a,
        ScaleType = Enum.ScaleType.Slice,
        SliceCenter = Rect.new(99, 99, 99, 99),
        ZIndex = f.ZIndex - 1,
    })
    b.Parent = f
    
    local g = C("UIGradient", {
        Color = ColorSequence.new({
            ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 255, 255)),
            ColorSequenceKeypoint.new(1, Color3.fromRGB(240, 240, 250))
        }),
        Rotation = 135,
        Transparency = NumberSequence.new({
            NumberSequenceKeypoint.new(0, 0.8),
            NumberSequenceKeypoint.new(1, 0.85)
        })
    })
    g.Parent = f
    return b
end

local N = {}
N.Q = {}
N.A = false

function N:New(d)
    table.insert(N.Q, {
        T = d.Title or "Notification",
        C = d.Content or "",
        I = d.Icon or "info",
        D = d.Duration or 3,
        Y = d.Type or "info"
    })
    if not N.A then N:Show() end
end

function N:Show()
    if #N.Q == 0 then N.A = false return end
    N.A = true
    local d = table.remove(N.Q, 1)
    
    local sg = G:FindFirstChild("SN") or C("ScreenGui", {Name = "SN", Parent = G, ResetOnSpawn = false, ZIndexBehavior = Enum.ZIndexBehavior.Sibling, DisplayOrder = 999})
    
    local f = C("CanvasGroup", {
        Size = UDim2.new(0, 0, 0, 0),
        Position = UDim2.new(0.5, 0, 0, -100),
        AnchorPoint = Vector2.new(0.5, 0),
        BackgroundColor3 = Color3.fromRGB(28, 28, 35),
        GroupTransparency = 0,
        AutomaticSize = Enum.AutomaticSize.None,
        ClipsDescendants = true,
    })
    
    C("UICorner", {CornerRadius = UDim.new(0, 32)}).Parent = f
    C("UIStroke", {Color = Color3.fromRGB(100, 100, 110), Thickness = 1.5, Transparency = 0.2}).Parent = f
    Gl(f, 0.4)
    
    local pd = C("UIPadding", {PaddingTop = UDim.new(0, 14), PaddingLeft = UDim.new(0, 20), PaddingRight = UDim.new(0, 20), PaddingBottom = UDim.new(0, 14)})
    pd.Parent = f
    
    local ly = C("UIListLayout", {Padding = UDim.new(0, 12), FillDirection = Enum.FillDirection.Horizontal, VerticalAlignment = Enum.VerticalAlignment.Center})
    ly.Parent = f
    
    local ic = C("ImageLabel", {Size = UDim2.new(0, 24, 0, 24), BackgroundTransparency = 1, Image = I[d.I] or I.info, ImageColor3 = d.Y == "success" and Color3.fromRGB(80, 220, 120) or d.Y == "error" and Color3.fromRGB(240, 100, 100) or Color3.fromRGB(100, 180, 255)})
    ic.Parent = f
    
    local tx = C("Frame", {Size = UDim2.new(0, 0, 0, 0), BackgroundTransparency = 1, AutomaticSize = Enum.AutomaticSize.X})
    tx.Parent = f
    
    local tly = C("UIListLayout", {Padding = UDim.new(0, 2), FillDirection = Enum.FillDirection.Vertical})
    tly.Parent = tx
    
    local title = C("TextLabel", {Size = UDim2.new(0, 0, 0, 20), BackgroundTransparency = 1, Text = d.T, TextColor3 = Color3.fromRGB(255, 255, 255), TextSize = 15, Font = Enum.Font.GothamBold, TextXAlignment = Enum.TextXAlignment.Left, AutomaticSize = Enum.AutomaticSize.X})
    title.Parent = tx
    
    if d.C ~= "" then
        local content = C("TextLabel", {Size = UDim2.new(0, 0, 0, 18), BackgroundTransparency = 1, Text = d.C, TextColor3 = Color3.fromRGB(180, 180, 190), TextSize = 13, Font = Enum.Font.Gotham, TextXAlignment = Enum.TextXAlignment.Left, TextWrapped = true, AutomaticSize = Enum.AutomaticSize.X})
        content.Parent = tx
    end
    
    f.Parent = sg
    f.Size = UDim2.new(0, 0, 0, 0)
    f.AutomaticSize = Enum.AutomaticSize.XY
    
    R.Heartbeat:Wait()
    
    local targetSize = f.AbsoluteSize
    f.Size = UDim2.new(0, 0, 0, 0)
    f.AutomaticSize = Enum.AutomaticSize.None
    
    Tw(f, 0.35, {Size = UDim2.new(0, targetSize.X, 0, targetSize.Y), Position = UDim2.new(0.5, 0, 0, 24)}, Enum.EasingStyle.Back)
    
    task.delay(d.D, function()
        Tw(f, 0.3, {Size = UDim2.new(0, 0, 0, 0), GroupTransparency = 1, Position = UDim2.new(0.5, 0, 0, -100)})
        task.wait(0.3)
        f:Destroy()
        N:Show()
    end)
end

local CP = {}
CP.__index = CP

function CP:New(pa, dc, cb)
    local s = setmetatable({}, CP)
    s.C = dc or Color3.fromRGB(100, 180, 255)
    s.CB = cb or function() end
    s.O = false
    
    s.Tr = C("TextButton", {Size = UDim2.new(0, 36, 0, 36), BackgroundColor3 = s.C, Text = "", Parent = pa})
    C("UICorner", {CornerRadius = UDim.new(0, 12)}).Parent = s.Tr
    C("UIStroke", {Color = Color3.fromRGB(110, 110, 120), Thickness = 1.5}).Parent = s.Tr
    
    s.PF = C("CanvasGroup", {Size = UDim2.new(0, 260, 0, 0), Position = UDim2.new(0, 0, 1, 12), BackgroundColor3 = Color3.fromRGB(30, 30, 38), GroupTransparency = 1, Visible = false, AutomaticSize = Enum.AutomaticSize.Y, ZIndex = 100})
    s.PF.Parent = s.Tr
    C("UICorner", {CornerRadius = UDim.new(0, 20)}).Parent = s.PF
    Gl(s.PF, 0.4)
    
    C("UIPadding", {PaddingTop = UDim.new(0, 20), PaddingLeft = UDim.new(0, 20), PaddingRight = UDim.new(0, 20), PaddingBottom = UDim.new(0, 20)}).Parent = s.PF
    
    s.SV = C("ImageLabel", {Size = UDim2.new(0, 160, 0, 160), BackgroundColor3 = Color3.fromHSV(0, 1, 1), Image = "rbxassetid://4155801252"})
    s.SV.Parent = s.PF
    C("UICorner", {CornerRadius = UDim.new(0, 14)}).Parent = s.SV
    
    s.SC = C("Frame", {Size = UDim2.new(0, 16, 0, 16), Position = UDim2.new(1, -8, 0, -8), AnchorPoint = Vector2.new(0.5, 0.5), BackgroundColor3 = Color3.fromRGB(255, 255, 255), BorderSizePixel = 0})
    C("UICorner", {CornerRadius = UDim.new(1, 0)}).Parent = s.SC
    s.SC.Parent = s.SV
    
    s.HU = C("Frame", {Size = UDim2.new(0, 24, 0, 160), Position = UDim2.new(1, 12, 0, 0), BackgroundColor3 = Color3.fromRGB(255, 255, 255)})
    s.HU.Parent = s.SV
    
    C("UIGradient", {Color = ColorSequence.new({ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 0, 0)), ColorSequenceKeypoint.new(0.17, Color3.fromRGB(255, 255, 0)), ColorSequenceKeypoint.new(0.33, Color3.fromRGB(0, 255, 0)), ColorSequenceKeypoint.new(0.5, Color3.fromRGB(0, 255, 255)), ColorSequenceKeypoint.new(0.67, Color3.fromRGB(0, 0, 255)), ColorSequenceKeypoint.new(0.83, Color3.fromRGB(255, 0, 255)), ColorSequenceKeypoint.new(1, Color3.fromRGB(255, 0, 0))}), Rotation = 90}).Parent = s.HU
    C("UICorner", {CornerRadius = UDim.new(0, 12)}).Parent = s.HU
    
    s.HC = C("Frame", {Size = UDim2.new(1, 8, 0, 6), Position = UDim2.new(0, -4, 0, 0), AnchorPoint = Vector2.new(0, 0.5), BackgroundColor3 = Color3.fromRGB(255, 255, 255), BorderSizePixel = 0})
    C("UICorner", {CornerRadius = UDim.new(0, 3)}).Parent = s.HC
    s.HC.Parent = s.HU
    
    local ic = C("Frame", {Size = UDim2.new(1, 0, 0, 40), Position = UDim2.new(0, 0, 0, 180), BackgroundTransparency = 1})
    ic.Parent = s.PF
    
    local ily = C("UIListLayout", {Padding = UDim.new(0, 10), FillDirection = Enum.FillDirection.Horizontal})
    ily.Parent = ic
    
    s.IN = {}
    for _, lb in ipairs({"R", "G", "B"}) do
        local ifr = C("Frame", {Size = UDim2.new(0.33, -7, 1, 0), BackgroundColor3 = Color3.fromRGB(45, 45, 55)})
        C("UICorner", {CornerRadius = UDim.new(0, 10)}).Parent = ifr
        C("TextLabel", {Size = UDim2.new(0, 24, 1, 0), BackgroundTransparency = 1, Text = lb, TextColor3 = Color3.fromRGB(150, 150, 160), TextSize = 13, Font = Enum.Font.GothamBold}).Parent = ifr
        local ib = C("TextBox", {Size = UDim2.new(1, -28, 1, 0), Position = UDim2.new(0, 24, 0, 0), BackgroundTransparency = 1, Text = "255", TextColor3 = Color3.fromRGB(255, 255, 255), TextSize = 13, Font = Enum.Font.Gotham, ClearTextOnFocus = false})
        ib.Parent = ifr
        ifr.Parent = ic
        s.IN[lb] = ib
    end
    
    s.PV = C("Frame", {Size = UDim2.new(0, 48, 0, 40), Position = UDim2.new(1, 0, 0, 180), BackgroundColor3 = s.C})
    C("UICorner", {CornerRadius = UDim.new(0, 12)}).Parent = s.PV
    C("UIStroke", {Color = Color3.fromRGB(120, 120, 130), Thickness = 1}).Parent = s.PV
    s.PV.Parent = s.PF
    
    s.Tr.MouseButton1Click:Connect(function() s:Toggle() end)
    s:Setup()
    s:UpC(s.C)
    
    return s
end

function CP:Toggle()
    self.O = not self.O
    self.PF.Visible = true
    if self.O then
        Tw(self.PF, 0.25, {GroupTransparency = 0}, Enum.EasingStyle.Back)
    else
        Tw(self.PF, 0.2, {GroupTransparency = 1})
        task.delay(0.2, function() if not self.O then self.PF.Visible = false end end)
    end
end

function CP:Setup()
    local d = false
    
    self.SV.InputBegan:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then d = true self:UpSV(i) end end)
    self.HU.InputBegan:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then d = true self:UpHU(i) end end)
    
    U.InputChanged:Connect(function(i)
        if d and (i.UserInputType == Enum.UserInputType.MouseMovement or i.UserInputType == Enum.UserInputType.Touch) then
            local p = i.Position
            local sp = self.SV.AbsolutePosition
            local ss = self.SV.AbsoluteSize
            local hp = self.HU.AbsolutePosition
            local hs = self.HU.AbsoluteSize
            
            if p.X >= sp.X and p.X <= sp.X + ss.X and p.Y >= sp.Y and p.Y <= sp.Y + ss.Y then
                self:UpSV(i)
            elseif p.X >= hp.X and p.X <= hp.X + hs.X and p.Y >= hp.Y and p.Y <= hp.Y + hs.Y then
                self:UpHU(i)
            end
        end
    end)
    
    U.InputEnded:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then d = false end end)
    
    for _, ip in pairs(self.IN) do
        ip.FocusLost:Connect(function()
            local v = tonumber(ip.Text) or 0
            v = math.clamp(v, 0, 255)
            ip.Text = tostring(v)
            self:UpC(Color3.fromRGB(tonumber(self.IN.R.Text) or 255, tonumber(self.IN.G.Text) or 255, tonumber(self.IN.B.Text) or 255))
        end)
    end
end

function CP:UpSV(i)
    local p = i.Position
    local sp = self.SV.AbsolutePosition
    local ss = self.SV.AbsoluteSize
    local x = math.clamp((p.X - sp.X) / ss.X, 0, 1)
    local y = math.clamp((p.Y - sp.Y) / ss.Y, 0, 1)
    self.S = x
    self.V = 1 - y
    self.SC.Position = UDim2.new(x, 0, y, 0)
    self:UpCl()
end

function CP:UpHU(i)
    local p = i.Position
    local hp = self.HU.AbsolutePosition
    local hs = self.HU.AbsoluteSize
    local y = math.clamp((p.Y - hp.Y) / hs.Y, 0, 1)
    self.H = y
    self.HC.Position = UDim2.new(0, 0, y, 0)
    self.SV.BackgroundColor3 = Color3.fromHSV(self.H, 1, 1)
    self:UpCl()
end

function CP:UpCl()
    local c = Color3.fromHSV(self.H or 0, self.S or 1, self.V or 1)
    self.C = c
    self.Tr.BackgroundColor3 = c
    self.PV.BackgroundColor3 = c
    self.IN.R.Text = tostring(math.floor(c.R * 255))
    self.IN.G.Text = tostring(math.floor(c.G * 255))
    self.IN.B.Text = tostring(math.floor(c.B * 255))
    self.CB(c)
end

function CP:UpC(c)
    local h, s, v = Color3.toHSV(c)
    self.H, self.S, self.V = h, s, v
    self.HC.Position = UDim2.new(0, 0, h, 0)
    self.SC.Position = UDim2.new(s, 0, 1 - v, 0)
    self.SV.BackgroundColor3 = Color3.fromHSV(h, 1, 1)
    self.IN.R.Text = tostring(math.floor(c.R * 255))
    self.IN.G.Text = tostring(math.floor(c.G * 255))
    self.IN.B.Text = tostring(math.floor(c.B * 255))
    self.Tr.BackgroundColor3 = c
    self.PV.BackgroundColor3 = c
end

local Solar = {}
Solar.__index = Solar

function Solar:CreateWindow(cfg)
    cfg = cfg or {}
    local W = {}
    W.T = cfg.Title or "Solar"
    W.ST = cfg.SubTitle or ""
    W.I = cfg.Icon or "zap"
    W.S = cfg.Size or UDim2.new(0, 620, 0, 420)
    W.P = cfg.Position or UDim2.new(0.5, 0, 0.5, 0)
    W.SC = cfg.Scale or 1
    W.TB = {}
    W.CT = nil
    
    W.SG = C("ScreenGui", {Name = "Solar", Parent = G, ResetOnSpawn = false, ZIndexBehavior = Enum.ZIndexBehavior.Sibling})
    W.SF = C("Frame", {Size = UDim2.new(1, 0, 1, 0), BackgroundTransparency = 1, Parent = W.SG})
    W.US = C("UIScale", {Scale = W.SC})
    W.US.Parent = W.SF
    
    W.MF = C("CanvasGroup", {Size = W.S, Position = W.P, AnchorPoint = Vector2.new(0.5, 0.5), BackgroundColor3 = Color3.fromRGB(22, 22, 28), GroupTransparency = 1, Parent = W.SF})
    Gl(W.MF, 0.45)
    C("UICorner", {CornerRadius = UDim.new(0, 24)}).Parent = W.MF
    C("UIStroke", {Color = Color3.fromRGB(90, 90, 100), Thickness = 1.5, Transparency = 0.15}).Parent = W.MF
    
    W.TB = C("Frame", {Size = UDim2.new(1, 0, 0, 56), BackgroundTransparency = 1, Parent = W.MF})
    C("UIPadding", {PaddingTop = UDim.new(0, 16), PaddingLeft = UDim.new(0, 20), PaddingRight = UDim.new(0, 20), PaddingBottom = UDim.new(0, 10)}).Parent = W.TB
    
    local TC = C("Frame", {Size = UDim2.new(0, 0, 1, 0), BackgroundTransparency = 1, AutomaticSize = Enum.AutomaticSize.X})
    TC.Parent = W.TB
    
    local TL = C("UIListLayout", {Padding = UDim.new(0, 12), FillDirection = Enum.FillDirection.Horizontal, VerticalAlignment = Enum.VerticalAlignment.Center})
    TL.Parent = TC
    
    C("ImageLabel", {Size = UDim2.new(0, 26, 0, 26), BackgroundTransparency = 1, Image = I[W.I] or I.zap, ImageColor3 = Color3.fromRGB(100, 180, 255)}).Parent = TC
    C("TextLabel", {Size = UDim2.new(0, 0, 1, 0), BackgroundTransparency = 1, Text = W.T, TextColor3 = Color3.fromRGB(255, 255, 255), TextSize = 18, Font = Enum.Font.GothamBold, AutomaticSize = Enum.AutomaticSize.X}).Parent = TC
    
    if W.ST ~= "" then
        C("TextLabel", {Size = UDim2.new(0, 0, 0, 20), Position = UDim2.new(0, 36, 0, 30), BackgroundTransparency = 1, Text = W.ST, TextColor3 = Color3.fromRGB(150, 150, 160), TextSize = 13, Font = Enum.Font.Gotham}).Parent = W.TB
    end
    
    local CT = C("Frame", {Size = UDim2.new(0, 0, 1, 0), Position = UDim2.new(1, 0, 0, 0), AnchorPoint = Vector2.new(1, 0), BackgroundTransparency = 1, AutomaticSize = Enum.AutomaticSize.X})
    CT.Parent = W.TB
    
    local CTL = C("UIListLayout", {Padding = UDim.new(0, 10), FillDirection = Enum.FillDirection.Horizontal, VerticalAlignment = Enum.VerticalAlignment.Center})
    CTL.Parent = CT
    
    local SB = C("ImageButton", {Size = UDim2.new(0, 36, 0, 36), BackgroundTransparency = 0.85, BackgroundColor3 = Color3.fromRGB(55, 55, 65), Image = I.search, ImageColor3 = Color3.fromRGB(180, 180, 190)})
    C("UICorner", {CornerRadius = UDim.new(0, 12)}).Parent = SB
    SB.Parent = CT
    
    local MB = C("ImageButton", {Size = UDim2.new(0, 36, 0, 36), BackgroundTransparency = 0.85, BackgroundColor3 = Color3.fromRGB(55, 55, 65), Image = I.minus, ImageColor3 = Color3.fromRGB(180, 180, 190)})
    C("UICorner", {CornerRadius = UDim.new(0, 12)}).Parent = MB
    MB.Parent = CT
    
    local XB = C("ImageButton", {Size = UDim2.new(0, 36, 0, 36), BackgroundTransparency = 0.85, BackgroundColor3 = Color3.fromRGB(55, 55, 65), Image = I.x, ImageColor3 = Color3.fromRGB(240, 120, 120)})
    C("UICorner", {CornerRadius = UDim.new(0, 12)}).Parent = XB
    XB.Parent = CT
    
    W.SB = C("ScrollingFrame", {Size = UDim2.new(0, 180, 1, -56), Position = UDim2.new(0, 0, 0, 56), BackgroundTransparency = 1, ScrollBarThickness = 0, CanvasSize = UDim2.new(0, 0, 0, 0), AutomaticCanvasSize = Enum.AutomaticSize.Y})
    C("UIPadding", {PaddingTop = UDim.new(0, 14), PaddingLeft = UDim.new(0, 16), PaddingRight = UDim.new(0, 10), PaddingBottom = UDim.new(0, 14)}).Parent = W.SB
    C("UIListLayout", {Padding = UDim.new(0, 8), FillDirection = Enum.FillDirection.Vertical}).Parent = W.SB
    W.SB.Parent = W.MF
    
    W.TH = C("Frame", {Size = UDim2.new(0, 4, 0, 36), Position = UDim2.new(0, 0, 0, 0), BackgroundColor3 = Color3.fromRGB(100, 180, 255), BorderSizePixel = 0})
    C("UICorner", {CornerRadius = UDim.new(0, 2)}).Parent = W.TH
    W.TH.Parent = W.SB
    
    W.CN = C("Frame", {Size = UDim2.new(1, -188, 1, -64), Position = UDim2.new(0, 184, 0, 60), BackgroundTransparency = 0.92, BackgroundColor3 = Color3.fromRGB(45, 45, 55)})
    C("UICorner", {CornerRadius = UDim.new(0, 20)}).Parent = W.CN
    W.CN.Parent = W.MF
    
    W.CS = C("ScrollingFrame", {Size = UDim2.new(1, 0, 1, 0), BackgroundTransparency = 1, ScrollBarThickness = 4, ScrollBarImageColor3 = Color3.fromRGB(100, 100, 110), CanvasSize = UDim2.new(0, 0, 0, 0), AutomaticCanvasSize = Enum.AutomaticSize.Y})
    C("UIPadding", {PaddingTop = UDim.new(0, 20), PaddingLeft = UDim.new(0, 20), PaddingRight = UDim.new(0, 20), PaddingBottom = UDim.new(0, 20)}).Parent = W.CS
    C("UIListLayout", {Padding = UDim.new(0, 16), FillDirection = Enum.FillDirection.Vertical}).Parent = W.CS
    W.CS.Parent = W.CN
    
    W.RH = C("ImageButton", {Size = UDim2.new(0, 24, 0, 24), Position = UDim2.new(1, -10, 1, -10), AnchorPoint = Vector2.new(1, 1), BackgroundTransparency = 1, Image = I.plus, ImageColor3 = Color3.fromRGB(140, 140, 150), ImageTransparency = 0.4, ZIndex = 100})
    W.RH.Parent = W.MF
    
    W.SL = C("TextLabel", {Size = UDim2.new(0, 60, 0, 26), Position = UDim2.new(1, -20, 1, -30), AnchorPoint = Vector2.new(1, 1), BackgroundTransparency = 0.2, BackgroundColor3 = Color3.fromRGB(30, 30, 38), Text = "100%", TextColor3 = Color3.fromRGB(190, 190, 200), TextSize = 12, Font = Enum.Font.Gotham, ZIndex = 101, Visible = false})
    C("UICorner", {CornerRadius = UDim.new(0, 10)}).Parent = W.SL
    Gl(W.SL, 0.5)
    W.SL.Parent = W.MF
    
    local D = false
    local DS = nil
    local DP = nil
    
    W.TB.InputBegan:Connect(function(i)
        if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then
            D = true
            DS = i.Position
            DP = W.MF.Position
            Tw(W.MF, 0.15, {Size = UDim2.new(W.MF.Size.X.Scale, W.MF.Size.X.Offset * 0.98, W.MF.Size.Y.Scale, W.MF.Size.Y.Offset * 0.98)})
        end
    end)
    
    U.InputChanged:Connect(function(i)
        if D and (i.UserInputType == Enum.UserInputType.MouseMovement or i.UserInputType == Enum.UserInputType.Touch) then
            local delta = i.Position - DS
            W.MF.Position = UDim2.new(DP.X.Scale, DP.X.Offset + delta.X, DP.Y.Scale, DP.Y.Offset + delta.Y)
        end
    end)
    
    U.InputEnded:Connect(function(i)
        if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then
            if D then
                D = false
                Tw(W.MF, 0.2, {Size = UDim2.new(W.MF.Size.X.Scale, W.MF.Size.X.Offset / 0.98, W.MF.Size.Y.Scale, W.MF.Size.Y.Offset / 0.98)}, Enum.EasingStyle.Back)
            end
        end
    end)
    
    local RZ = false
    local RS = nil
    local RSize = nil
    
    W.RH.InputBegan:Connect(function(i)
        if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then
            RZ = true
            RS = i.Position
            RSize = W.MF.Size
            W.SL.Visible = true
        end
    end)
    
    U.InputChanged:Connect(function(i)
        if RZ and (i.UserInputType == Enum.UserInputType.MouseMovement or i.UserInputType == Enum.UserInputType.Touch) then
            local delta = i.Position - RS
            local nw = math.clamp(RSize.X.Offset + delta.X, 480, 900)
            local nh = math.clamp(RSize.Y.Offset + delta.Y, 360, 700)
            W.MF.Size = UDim2.new(0, nw, 0, nh)
            W.SL.Text = math.floor((nw / W.S.X.Offset) * 100) .. "%"
        end
    end)
    
    U.InputEnded:Connect(function(i)
        if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then
            RZ = false
            W.SL.Visible = false
        end
    end)
    
    local function HE(b, hc, dc)
        b.MouseEnter:Connect(function() Tw(b, 0.15, {BackgroundTransparency = 0.6, ImageColor3 = hc}) end)
        b.MouseLeave:Connect(function() Tw(b, 0.15, {BackgroundTransparency = 0.85, ImageColor3 = dc}) end)
    end
    
    HE(SB, Color3.fromRGB(255, 255, 255), Color3.fromRGB(180, 180, 190))
    HE(MB, Color3.fromRGB(255, 255, 255), Color3.fromRGB(180, 180, 190))
    HE(XB, Color3.fromRGB(255, 160, 160), Color3.fromRGB(240, 120, 120))
    
    XB.MouseButton1Click:Connect(function()
        Tw(W.MF, 0.3, {GroupTransparency = 1, Size = UDim2.new(W.MF.Size.X.Scale, W.MF.Size.X.Offset * 0.9, W.MF.Size.Y.Scale, W.MF.Size.Y.Offset * 0.9)})
        task.delay(0.3, function() W.SG.Enabled = false end)
    end)
    
    local MN = false
    MB.MouseButton1Click:Connect(function()
        MN = not MN
        if MN then
            Tw(W.CN, 0.25, {GroupTransparency = 1})
            Tw(W.SB, 0.25, {GroupTransparency = 1})
            Tw(W.MF, 0.25, {Size = UDim2.new(0, W.MF.Size.X.Offset, 0, 56)})
        else
            Tw(W.CN, 0.25, {GroupTransparency = 0})
            Tw(W.SB, 0.25, {GroupTransparency = 0})
            Tw(W.MF, 0.25, {Size = W.S})
        end
    end)
    
    task.spawn(function() Tw(W.MF, 0.4, {GroupTransparency = 0}, Enum.EasingStyle.Back) end)
    
    function W:CreateTab(cfg)
        cfg = cfg or {}
        local T = {}
        T.N = cfg.Name or "Tab"
        T.I = cfg.Icon or "home"
        
        T.BT = C("TextButton", {Size = UDim2.new(1, 0, 0, 42), BackgroundTransparency = 1, Text = "", Parent = self.SB})
        
        local L = C("UIListLayout", {Padding = UDim.new(0, 12), FillDirection = Enum.FillDirection.Horizontal, VerticalAlignment = Enum.VerticalAlignment.Center})
        L.Parent = T.BT
        
        C("UIPadding", {PaddingLeft = UDim.new(0, 16)}).Parent = T.BT
        
        local IC = C("ImageLabel", {Size = UDim2.new(0, 20, 0, 20), BackgroundTransparency = 1, Image = I[T.I] or I.home, ImageColor3 = Color3.fromRGB(150, 150, 160)})
        IC.Parent = T.BT
        
        local TX = C("TextLabel", {Size = UDim2.new(1, -28, 1, 0), BackgroundTransparency = 1, Text = T.N, TextColor3 = Color3.fromRGB(150, 150, 160), TextSize = 14, Font = Enum.Font.GothamMedium, TextXAlignment = Enum.TextXAlignment.Left})
        TX.Parent = T.BT
        
        T.CN = C("Frame", {Size = UDim2.new(1, 0, 0, 0), BackgroundTransparency = 1, Visible = false, AutomaticSize = Enum.AutomaticSize.Y})
        C("UIListLayout", {Padding = UDim.new(0, 16), FillDirection = Enum.FillDirection.Vertical}).Parent = T.CN
        T.CN.Parent = self.CS
        
        T.BT.MouseButton1Click:Connect(function() self:SelectTab(T) end)
        
        T.BT.MouseEnter:Connect(function() if self.CT ~= T then Tw(T.BT, 0.15, {BackgroundTransparency = 0.92}) end end)
        T.BT.MouseLeave:Connect(function() if self.CT ~= T then Tw(T.BT, 0.15, {BackgroundTransparency = 1}) end end)
        
        table.insert(self.TB, T)
        if #self.TB == 1 then self:SelectTab(T) end
        
        return T
    end
    
    function W:SelectTab(T)
        if self.CT == T then return end
        
        if self.CT then
            Tw(self.CT.BT, 0.2, {BackgroundTransparency = 1})
            local L = self.CT.BT:FindFirstChildOfClass("UIListLayout")
            if L then
                local P = L.Parent
                local IM = P:FindFirstChildOfClass("ImageLabel")
                local TX = P:FindFirstChildOfClass("TextLabel")
                if IM then Tw(IM, 0.2, {ImageColor3 = Color3.fromRGB(150, 150, 160)}) end
                if TX then Tw(TX, 0.2, {TextColor3 = Color3.fromRGB(150, 150, 160)}) end
            end
            self.CT.CN.Visible = false
        end
        
        self.CT = T
        Tw(T.BT, 0.2, {BackgroundTransparency = 0.88, BackgroundColor3 = Color3.fromRGB(55, 55, 65)})
        
        local L = T.BT:FindFirstChildOfClass("UIListLayout")
        if L then
            local P = L.Parent
            local IM = P:FindFirstChildOfClass("ImageLabel")
            local TX = P:FindFirstChildOfClass("TextLabel")
            if IM then Tw(IM, 0.2, {ImageColor3 = Color3.fromRGB(100, 180, 255)}) end
            if TX then Tw(TX, 0.2, {TextColor3 = Color3.fromRGB(255, 255, 255)}) end
        end
        
        local P = T.BT.AbsolutePosition.Y - self.SB.AbsolutePosition.Y
        Tw(self.TH, 0.3, {Position = UDim2.new(0, 0, 0, P + 2), Size = UDim2.new(0, 4, 0, T.BT.AbsoluteSize.Y - 4)}, Enum.EasingStyle.Quint)
        
        T.CN.Visible = true
        
        for _, C in pairs(T.CN:GetChildren()) do
            if C:IsA("Frame") or C:IsA("TextButton") then
                C.Position = UDim2.new(0, 20, C.Position.Y.Scale, C.Position.Y.Offset)
                Tw(C, 0.3, {Position = UDim2.new(0, 0, C.Position.Y.Scale, C.Position.Y.Offset)})
            end
        end
    end
    
    function W:CreateSection(T, t)
        local S = C("Frame", {Size = UDim2.new(1, 0, 0, 0), BackgroundTransparency = 0.92, BackgroundColor3 = Color3.fromRGB(50, 50, 60), AutomaticSize = Enum.AutomaticSize.Y, Parent = T.CN})
        C("UICorner", {CornerRadius = UDim.new(0, 18)}).Parent = S
        C("UIPadding", {PaddingTop = UDim.new(0, 18), PaddingLeft = UDim.new(0, 18), PaddingRight = UDim.new(0, 18), PaddingBottom = UDim.new(0, 18)}).Parent = S
        
        if t then
            C("TextLabel", {Size = UDim2.new(1, 0, 0, 24), BackgroundTransparency = 1, Text = t, TextColor3 = Color3.fromRGB(220, 220, 230), TextSize = 15, Font = Enum.Font.GothamBold, TextXAlignment = Enum.TextXAlignment.Left}).Parent = S
            C("Frame", {Size = UDim2.new(1, 0, 0, 1), Position = UDim2.new(0, 0, 0, 32), BackgroundColor3 = Color3.fromRGB(80, 80, 90), BackgroundTransparency = 0.4}).Parent = S
            
            local F = C("Frame", {Size = UDim2.new(1, 0, 0, 0), Position = UDim2.new(0, 0, 0, 44), BackgroundTransparency = 1, AutomaticSize = Enum.AutomaticSize.Y})
            C("UIListLayout", {Padding = UDim.new(0, 12), FillDirection = Enum.FillDirection.Vertical}).Parent = F
            F.Parent = S
            return F
        else
            C("UIListLayout", {Padding = UDim.new(0, 12), FillDirection = Enum.FillDirection.Vertical}).Parent = S
            return S
        end
    end
    
    function W:CreateToggle(P, cfg)
        cfg = cfg or {}
        local TG = {}
        TG.T = cfg.Title or "Toggle"
        TG.D = cfg.Description
        TG.V = cfg.Default or false
        TG.CB = cfg.Callback or function() end
        
        local F = C("Frame", {Size = UDim2.new(1, 0, 0, TG.D and 60 or 44), BackgroundTransparency = 1, Parent = P})
        
        local TX = C("Frame", {Size = UDim2.new(1, -64, 1, 0), BackgroundTransparency = 1})
        TX.Parent = F
        
        C("UIListLayout", {Padding = UDim.new(0, 4), FillDirection = Enum.FillDirection.Vertical, VerticalAlignment = Enum.VerticalAlignment.Center}).Parent = TX
        
        C("TextLabel", {Size = UDim2.new(1, 0, 0, 20), BackgroundTransparency = 1, Text = TG.T, TextColor3 = Color3.fromRGB(240, 240, 250), TextSize = 15, Font = Enum.Font.GothamMedium, TextXAlignment = Enum.TextXAlignment.Left}).Parent = TX
        
        if TG.D then
            C("TextLabel", {Size = UDim2.new(1, 0, 0, 18), BackgroundTransparency = 1, Text = TG.D, TextColor3 = Color3.fromRGB(150, 150, 160), TextSize = 13, Font = Enum.Font.Gotham, TextXAlignment = Enum.TextXAlignment.Left}).Parent = TX
        end
        
        local SW = C("TextButton", {Size = UDim2.new(0, 52, 0, 28), Position = UDim2.new(1, 0, 0.5, 0), AnchorPoint = Vector2.new(1, 0.5), BackgroundColor3 = Color3.fromRGB(65, 65, 75), Text = ""})
        C("UICorner", {CornerRadius = UDim.new(1, 0)}).Parent = SW
        SW.Parent = F
        
        local K = C("Frame", {Size = UDim2.new(0, 22, 0, 22), Position = UDim2.new(0, 3, 0.5, 0), AnchorPoint = Vector2.new(0, 0.5), BackgroundColor3 = Color3.fromRGB(255, 255, 255)})
        C("UICorner", {CornerRadius = UDim.new(1, 0)}).Parent = K
        K.Parent = SW
        
        local GL = C("ImageLabel", {Size = UDim2.new(1, 24, 1, 24), Position = UDim2.new(0.5, 0, 0.5, 0), AnchorPoint = Vector2.new(0.5, 0.5), BackgroundTransparency = 1, Image = "rbxassetid://8992230677", ImageColor3 = Color3.fromRGB(100, 180, 255), ImageTransparency = 1, ScaleType = Enum.ScaleType.Slice, SliceCenter = Rect.new(99, 99, 99, 99)})
        GL.Parent = SW
        
        function TG:Set(V)
            TG.V = V
            if V then
                Tw(SW, 0.25, {BackgroundColor3 = Color3.fromRGB(100, 180, 255)})
                Tw(K, 0.25, {Position = UDim2.new(0, 27, 0.5, 0)}, Enum.EasingStyle.Back)
                Tw(GL, 0.25, {ImageTransparency = 0.5})
            else
                Tw(SW, 0.25, {BackgroundColor3 = Color3.fromRGB(65, 65, 75)})
                Tw(K, 0.25, {Position = UDim2.new(0, 3, 0.5, 0)}, Enum.EasingStyle.Back)
                Tw(GL, 0.25, {ImageTransparency = 1})
            end
            TG.CB(V)
        end
        
        SW.MouseButton1Click:Connect(function() TG:Set(not TG.V) end)
        TG:Set(TG.V)
        
        return TG
    end
    
    function W:CreateSlider(P, cfg)
        cfg = cfg or {}
        local SL = {}
        SL.T = cfg.Title or "Slider"
        SL.MN = cfg.Min or 0
        SL.MX = cfg.Max or 100
        SL.V = cfg.Default or SL.MN
        SL.SP = cfg.Step or 1
        SL.SF = cfg.Suffix or ""
        SL.CB = cfg.Callback or function() end
        
        local F = C("Frame", {Size = UDim2.new(1, 0, 0, 68), BackgroundTransparency = 1, Parent = P})
        
        C("TextLabel", {Size = UDim2.new(0.5, 0, 0, 22), BackgroundTransparency = 1, Text = SL.T, TextColor3 = Color3.fromRGB(240, 240, 250), TextSize = 15, Font = Enum.Font.GothamMedium, TextXAlignment = Enum.TextXAlignment.Left}).Parent = F
        
        local VB = C("TextBox", {Size = UDim2.new(0, 72, 0, 28), Position = UDim2.new(1, 0, 0, 0), AnchorPoint = Vector2.new(1, 0), BackgroundColor3 = Color3.fromRGB(50, 50, 60), Text = tostring(SL.V) .. SL.SF, TextColor3 = Color3.fromRGB(200, 200, 210), TextSize = 14, Font = Enum.Font.Gotham, ClearTextOnFocus = false})
        C("UICorner", {CornerRadius = UDim.new(0, 10)}).Parent = VB
        VB.Parent = F
        
        local TR = C("Frame", {Size = UDim2.new(1, 0, 0, 8), Position = UDim2.new(0, 0, 0, 44), BackgroundColor3 = Color3.fromRGB(55, 55, 65), BorderSizePixel = 0})
        C("UICorner", {CornerRadius = UDim.new(1, 0)}).Parent = TR
        TR.Parent = F
        
        local FL = C("Frame", {Size = UDim2.new(0, 0, 1, 0), BackgroundColor3 = Color3.fromRGB(100, 180, 255), BorderSizePixel = 0})
        C("UICorner", {CornerRadius = UDim.new(1, 0)}).Parent = FL
        FL.Parent = TR
        
        local HD = C("Frame", {Size = UDim2.new(0, 20, 0, 20), Position = UDim2.new(0, 0, 0.5, 0), AnchorPoint = Vector2.new(0.5, 0.5), BackgroundColor3 = Color3.fromRGB(255, 255, 255), BorderSizePixel = 0})
        C("UICorner", {CornerRadius = UDim.new(1, 0)}).Parent = HD
        HD.Parent = TR
        
        C("ImageLabel", {Size = UDim2.new(1, 12, 1, 12), Position = UDim2.new(0.5, 0, 0.5, 0), AnchorPoint = Vector2.new(0.5, 0.5), BackgroundTransparency = 1, Image = "rbxassetid://8992230677", ImageColor3 = Color3.fromRGB(100, 180, 255), ImageTransparency = 0.5, ScaleType = Enum.ScaleType.Slice, SliceCenter = Rect.new(99, 99, 99, 99)}).Parent = HD
        
        function SL:Set(V)
            V = math.clamp(V, SL.MN, SL.MX)
            V = math.floor(V / SL.SP + 0.5) * SL.SP
            SL.V = V
            local PCT = (V - SL.MN) / (SL.MX - SL.MN)
            Tw(FL, 0.15, {Size = UDim2.new(PCT, 0, 1, 0)})
            Tw(HD, 0.15, {Position = UDim2.new(PCT, 0, 0.5, 0)})
            VB.Text = tostring(V) .. SL.SF
            SL.CB(V)
        end
        
        local DG = false
        
        TR.InputBegan:Connect(function(i)
            if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then
                DG = true
                local PCT = math.clamp((i.Position.X - TR.AbsolutePosition.X) / TR.AbsoluteSize.X, 0, 1)
                SL:Set(SL.MN + PCT * (SL.MX - SL.MN))
            end
        end)
        
        U.InputChanged:Connect(function(i)
            if DG and (i.UserInputType == Enum.UserInputType.MouseMovement or i.UserInputType == Enum.UserInputType.Touch) then
                local PCT = math.clamp((i.Position.X - TR.AbsolutePosition.X) / TR.AbsoluteSize.X, 0, 1)
                SL:Set(SL.MN + PCT * (SL.MX - SL.MN))
            end
        end)
        
        U.InputEnded:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then DG = false end end)
        
        VB.FocusLost:Connect(function()
            local V = tonumber(VB.Text:gsub(SL.SF, "")) or SL.MN
            SL:Set(V)
        end)
        
        SL:Set(SL.V)
        return SL
    end
    
    function W:CreateButton(P, cfg)
        cfg = cfg or {}
        local BT = {}
        BT.T = cfg.Title or "Button"
        BT.I = cfg.Icon
        BT.V = cfg.Variant or "Secondary"
        BT.CB = cfg.Callback or function() end
        
        local F = C("TextButton", {Size = UDim2.new(1, 0, 0, 44), BackgroundColor3 = BT.V == "Primary" and Color3.fromRGB(100, 180, 255) or Color3.fromRGB(55, 55, 65), Text = "", Parent = P})
        C("UICorner", {CornerRadius = UDim.new(0, 14)}).Parent = F
        C("UIStroke", {Color = BT.V == "Primary" and Color3.fromRGB(80, 160, 235) or Color3.fromRGB(75, 75, 85), Thickness = 1}).Parent = F
        
        local L = C("UIListLayout", {Padding = UDim.new(0, 10), FillDirection = Enum.FillDirection.Horizontal, VerticalAlignment = Enum.VerticalAlignment.Center, HorizontalAlignment = Enum.HorizontalAlignment.Center})
        L.Parent = F
        
        if BT.I then
            C("ImageLabel", {Size = UDim2.new(0, 20, 0, 20), BackgroundTransparency = 1, Image = I[BT.I] or I.zap, ImageColor3 = BT.V == "Primary" and Color3.fromRGB(255, 255, 255) or Color3.fromRGB(220, 220, 230)}).Parent = F
        end
        
        C("TextLabel", {Size = UDim2.new(0, 0, 1, 0), BackgroundTransparency = 1, Text = BT.T, TextColor3 = BT.V == "Primary" and Color3.fromRGB(255, 255, 255) or Color3.fromRGB(240, 240, 250), TextSize = 15, Font = Enum.Font.GothamMedium, AutomaticSize = Enum.AutomaticSize.X}).Parent = F
        
        F.MouseEnter:Connect(function() Tw(F, 0.15, {BackgroundColor3 = BT.V == "Primary" and Color3.fromRGB(120, 200, 255) or Color3.fromRGB(70, 70, 80)}) end)
        F.MouseLeave:Connect(function() Tw(F, 0.15, {BackgroundColor3 = BT.V == "Primary" and Color3.fromRGB(100, 180, 255) or Color3.fromRGB(55, 55, 65)}) end)
        F.MouseButton1Down:Connect(function() Tw(F, 0.1, {Size = UDim2.new(0.98, 0, 0, 44)}) end)
        F.MouseButton1Up:Connect(function() Tw(F, 0.15, {Size = UDim2.new(1, 0, 0, 44)}, Enum.EasingStyle.Back) end)
        F.MouseButton1Click:Connect(function() BT.CB() end)
        
        return BT
    end
    
    function W:CreateDropdown(P, cfg)
        cfg = cfg or {}
        local DD = {}
        DD.T = cfg.Title or "Dropdown"
        DD.O = cfg.Options or {}
        DD.V = cfg.Default or DD.O[1]
        DD.CB = cfg.Callback or function() end
        
        local F = C("Frame", {Size = UDim2.new(1, 0, 0, 76), BackgroundTransparency = 1, Parent = P})
        
        C("TextLabel", {Size = UDim2.new(1, 0, 0, 22), BackgroundTransparency = 1, Text = DD.T, TextColor3 = Color3.fromRGB(240, 240, 250), TextSize = 15, Font = Enum.Font.GothamMedium, TextXAlignment = Enum.TextXAlignment.Left}).Parent = F
        
        local TR = C("TextButton", {Size = UDim2.new(1, 0, 0, 44), Position = UDim2.new(0, 0, 0, 30), BackgroundColor3 = Color3.fromRGB(50, 50, 60), Text = ""})
        C("UICorner", {CornerRadius = UDim.new(0, 14)}).Parent = TR
        TR.Parent = F
        
        C("UIListLayout", {Padding = UDim.new(0, 12), FillDirection = Enum.FillDirection.Horizontal, VerticalAlignment = Enum.VerticalAlignment.Center}).Parent = TR
        C("UIPadding", {PaddingLeft = UDim.new(0, 16), PaddingRight = UDim.new(0, 16)}).Parent = TR
        
        local VL = C("TextLabel", {Size = UDim2.new(1, -30, 1, 0), BackgroundTransparency = 1, Text = DD.V or "Select...", TextColor3 = Color3.fromRGB(220, 220, 230), TextSize = 14, Font = Enum.Font.Gotham, TextXAlignment = Enum.TextXAlignment.Left})
        VL.Parent = TR
        
        local AR = C("ImageLabel", {Size = UDim2.new(0, 20, 0, 20), BackgroundTransparency = 1, Image = I["chevron-down"], ImageColor3 = Color3.fromRGB(160, 160, 170)})
        AR.Parent = TR
        
        local MN = C("CanvasGroup", {Size = UDim2.new(1, 0, 0, 0), Position = UDim2.new(0, 0, 1, 10), BackgroundColor3 = Color3.fromRGB(35, 35, 42), GroupTransparency = 1, Visible = false, AutomaticSize = Enum.AutomaticSize.Y, ZIndex = 50})
        Gl(MN, 0.4)
        C("UICorner", {CornerRadius = UDim.new(0, 16)}).Parent = MN
        MN.Parent = TR
        
        C("UIPadding", {PaddingTop = UDim.new(0, 12), PaddingLeft = UDim.new(0, 12), PaddingRight = UDim.new(0, 12), PaddingBottom = UDim.new(0, 12)}).Parent = MN
        C("UIListLayout", {Padding = UDim.new(0, 6), FillDirection = Enum.FillDirection.Vertical}).Parent = MN
        
        DD.OP = false
        
        function DD:Refresh(O)
            for _, C in pairs(MN:GetChildren()) do if C:IsA("TextButton") then C:Destroy() end end
            for _, O in pairs(O) do
                local B = C("TextButton", {Size = UDim2.new(1, 0, 0, 40), BackgroundTransparency = 1, Text = ""})
                C("UIListLayout", {Padding = UDim.new(0, 12), FillDirection = Enum.FillDirection.Horizontal, VerticalAlignment = Enum.VerticalAlignment.Center}).Parent = B
                C("UIPadding", {PaddingLeft = UDim.new(0, 14)}).Parent = B
                
                local CK = C("ImageLabel", {Size = UDim2.new(0, 20, 0, 20), BackgroundTransparency = 1, Image = I.check, ImageColor3 = Color3.fromRGB(100, 180, 255), ImageTransparency = DD.V == O and 0 or 1})
                CK.Parent = B
                
                C("TextLabel", {Size = UDim2.new(1, -28, 1, 0), BackgroundTransparency = 1, Text = O, TextColor3 = Color3.fromRGB(220, 220, 230), TextSize = 14, Font = Enum.Font.Gotham, TextXAlignment = Enum.TextXAlignment.Left}).Parent = B
                
                B.MouseEnter:Connect(function() Tw(B, 0.15, {BackgroundTransparency = 0.88, BackgroundColor3 = Color3.fromRGB(55, 55, 65)}) end)
                B.MouseLeave:Connect(function() Tw(B, 0.15, {BackgroundTransparency = 1}) end)
                B.MouseButton1Click:Connect(function() DD:Set(O) DD:Close() end)
                B.Parent = MN
            end
        end
        
        function DD:Set(V)
            DD.V = V
            VL.Text = V
            DD.CB(V)
            self:Refresh(DD.O)
        end
        
        function DD:Open()
            DD.OP = true
            MN.Visible = true
            Tw(MN, 0.2, {GroupTransparency = 0})
            Tw(AR, 0.2, {Rotation = 180})
        end
        
        function DD:Close()
            DD.OP = false
            Tw(MN, 0.2, {GroupTransparency = 1})
            Tw(AR, 0.2, {Rotation = 0})
            task.delay(0.2, function() if not DD.OP then MN.Visible = false end end)
        end
        
        TR.MouseButton1Click:Connect(function() if DD.OP then DD:Close() else DD:Open() end end)
        DD:Refresh(DD.O)
        
        return DD
    end
    
    function W:CreateInput(P, cfg)
        cfg = cfg or {}
        local IN = {}
        IN.T = cfg.Title or "Input"
        IN.PH = cfg.Placeholder or "Enter text..."
        IN.V = cfg.Default or ""
        IN.CB = cfg.Callback or function() end
        
        local F = C("Frame", {Size = UDim2.new(1, 0, 0, 76), BackgroundTransparency = 1, Parent = P})
        
        C("TextLabel", {Size = UDim2.new(1, 0, 0, 22), BackgroundTransparency = 1, Text = IN.T, TextColor3 = Color3.fromRGB(240, 240, 250), TextSize = 15, Font = Enum.Font.GothamMedium, TextXAlignment = Enum.TextXAlignment.Left}).Parent = F
        
        local IB = C("TextBox", {Size = UDim2.new(1, 0, 0, 44), Position = UDim2.new(0, 0, 0, 30), BackgroundColor3 = Color3.fromRGB(50, 50, 60), Text = IN.V, PlaceholderText = IN.PH, TextColor3 = Color3.fromRGB(240, 240, 250), PlaceholderColor3 = Color3.fromRGB(120, 120, 130), TextSize = 14, Font = Enum.Font.Gotham, ClearTextOnFocus = false})
        C("UICorner", {CornerRadius = UDim.new(0, 14)}).Parent = IB
        C("UIPadding", {PaddingLeft = UDim.new(0, 16), PaddingRight = UDim.new(0, 16)}).Parent = IB
        IB.Parent = F
        
        IB.Focused:Connect(function() Tw(IB, 0.2, {BackgroundColor3 = Color3.fromRGB(60, 60, 70)}) end)
        IB.FocusLost:Connect(function() Tw(IB, 0.2, {BackgroundColor3 = Color3.fromRGB(50, 50, 60)}) IN.V = IB.Text IN.CB(IB.Text) end)
        
        return IN
    end
    
    function W:CreateColorPicker(P, cfg)
        cfg = cfg or {}
        local CPO = {}
        CPO.T = cfg.Title or "Color"
        CPO.V = cfg.Default or Color3.fromRGB(100, 180, 255)
        CPO.CB = cfg.Callback or function() end
        
        local F = C("Frame", {Size = UDim2.new(1, 0, 0, 48), BackgroundTransparency = 1, Parent = P})
        
        C("TextLabel", {Size = UDim2.new(1, -48, 1, 0), BackgroundTransparency = 1, Text = CPO.T, TextColor3 = Color3.fromRGB(240, 240, 250), TextSize = 15, Font = Enum.Font.GothamMedium, TextXAlignment = Enum.TextXAlignment.Left}).Parent = F
        
        local PK = CP:New(F, CPO.V, function(C) CPO.V = C CPO.CB(C) end)
        PK.Tr.Position = UDim2.new(1, 0, 0.5, 0)
        PK.Tr.AnchorPoint = Vector2.new(1, 0.5)
        
        return CPO
    end
    
    function W:CreateKeybind(P, cfg)
        cfg = cfg or {}
        local KB = {}
        KB.T = cfg.Title or "Keybind"
        KB.V = cfg.Default or Enum.KeyCode.Unknown
        KB.CB = cfg.Callback or function() end
        
        local F = C("Frame", {Size = UDim2.new(1, 0, 0, 44), BackgroundTransparency = 1, Parent = P})
        
        C("TextLabel", {Size = UDim2.new(1, -90, 1, 0), BackgroundTransparency = 1, Text = KB.T, TextColor3 = Color3.fromRGB(240, 240, 250), TextSize = 15, Font = Enum.Font.GothamMedium, TextXAlignment = Enum.TextXAlignment.Left}).Parent = F
        
        local BT = C("TextButton", {Size = UDim2.new(0, 80, 0, 36), Position = UDim2.new(1, 0, 0.5, 0), AnchorPoint = Vector2.new(1, 0.5), BackgroundColor3 = Color3.fromRGB(50, 50, 60), Text = KB.V.Name == "Unknown" and "None" or KB.V.Name, TextColor3 = Color3.fromRGB(200, 200, 210), TextSize = 13, Font = Enum.Font.Gotham})
        C("UICorner", {CornerRadius = UDim.new(0, 10)}).Parent = BT
        BT.Parent = F
        
        local LI = false
        
        BT.MouseButton1Click:Connect(function()
            LI = true
            BT.Text = "..."
            BT.BackgroundColor3 = Color3.fromRGB(100, 180, 255)
            BT.TextColor3 = Color3.fromRGB(255, 255, 255)
        end)
        
        U.InputBegan:Connect(function(I, G)
            if LI and not G then
                if I.UserInputType == Enum.UserInputType.Keyboard then
                    LI = false
                    KB.V = I.KeyCode
                    BT.Text = I.KeyCode.Name
                    BT.BackgroundColor3 = Color3.fromRGB(50, 50, 60)
                    BT.TextColor3 = Color3.fromRGB(200, 200, 210)
                    KB.CB(I.KeyCode)
                end
            end
        end)
        
        return KB
    end
    
    function W:CreateLabel(P, cfg)
        cfg = cfg or {}
        local LB = {}
        LB.T = cfg.Text or "Label"
        LB.C = cfg.Color or Color3.fromRGB(240, 240, 250)
        
        local F = C("Frame", {Size = UDim2.new(1, 0, 0, 0), BackgroundTransparency = 1, AutomaticSize = Enum.AutomaticSize.Y, Parent = P})
        
        local TX = C("TextLabel", {Size = UDim2.new(1, 0, 0, 0), BackgroundTransparency = 1, Text = LB.T, TextColor3 = LB.C, TextSize = 14, Font = Enum.Font.Gotham, TextWrapped = true, AutomaticSize = Enum.AutomaticSize.Y, TextXAlignment = cfg.Alignment or Enum.TextXAlignment.Left})
        TX.Parent = F
        
        function LB:Set(T) LB.T = T TX.Text = T end
        function LB:SetColor(C) LB.C = C TX.TextColor3 = C end
        
        return LB
    end
    
    function W:CreateDivider(P)
        local F = C("Frame", {Size = UDim2.new(1, 0, 0, 20), BackgroundTransparency = 1, Parent = P})
        
        local LN = C("Frame", {Size = UDim2.new(1, 0, 0, 1), Position = UDim2.new(0, 0, 0.5, 0), AnchorPoint = Vector2.new(0, 0.5), BackgroundColor3 = Color3.fromRGB(80, 80, 90), BackgroundTransparency = 0.5, BorderSizePixel = 0})
        LN.Parent = F
        
        return F
    end
    
    function W:Notify(D)
        N:New(D)
    end
    
    return W
end

return Solar<