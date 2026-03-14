local TweenService = game:GetService("TweenService")
local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local LocalPlayer = Players.LocalPlayer

local Icons = {
	["activity"] = "rbxassetid://94212016861936",
	["alert-circle"] = "rbxassetid://83898160590116",
	["align-center"] = "rbxassetid://81570549209434",
	["align-left"] = "rbxassetid://130161830325281",
	["align-right"] = "rbxassetid://129167626402283",
	["anchor"] = "rbxassetid://92181172123618",
	["aperture"] = "rbxassetid://83396154449972",
	["archive"] = "rbxassetid://122180020814574",
	["arrow-down"] = "rbxassetid://98764963621439",
	["arrow-left"] = "rbxassetid://102531941843733",
	["arrow-right"] = "rbxassetid://113692007244654",
	["arrow-up"] = "rbxassetid://89282378235317",
	["at-sign"] = "rbxassetid://79059152889146",
	["award"] = "rbxassetid://132740088158419",
	["bar-chart"] = "rbxassetid://105389816384108",
	["bar-chart-2"] = "rbxassetid://72336824986044",
	["battery"] = "rbxassetid://70765800346189",
	["battery-charging"] = "rbxassetid://80139357470047",
	["bell"] = "rbxassetid://97392696311902",
	["bell-off"] = "rbxassetid://78560046118930",
	["bluetooth"] = "rbxassetid://90506573139443",
	["bold"] = "rbxassetid://116141470019166",
	["book"] = "rbxassetid://125383279695672",
	["bookmark"] = "rbxassetid://121093149326239",
	["box"] = "rbxassetid://101768155599700",
	["briefcase"] = "rbxassetid://96754188164225",
	["calendar"] = "rbxassetid://114792700814035",
	["camera"] = "rbxassetid://79950339943067",
	["camera-off"] = "rbxassetid://81057636835256",
	["check"] = "rbxassetid://93898873302694",
	["check-circle"] = "rbxassetid://85262178816537",
	["check-square"] = "rbxassetid://134682053539509",
	["chevron-down"] = "rbxassetid://134243273101015",
	["chevron-left"] = "rbxassetid://73780377692148",
	["chevron-right"] = "rbxassetid://92473583511724",
	["chevron-up"] = "rbxassetid://122444883127455",
	["chrome"] = "rbxassetid://128165143739006",
	["circle"] = "rbxassetid://130359823580534",
	["clipboard"] = "rbxassetid://89601995828423",
	["clock"] = "rbxassetid://121808839832144",
	["cloud"] = "rbxassetid://121226497050352",
	["code"] = "rbxassetid://107380207681249",
	["coffee"] = "rbxassetid://106864403231093",
	["command"] = "rbxassetid://93648221906330",
	["compass"] = "rbxassetid://115123411028382",
	["copy"] = "rbxassetid://78979572434545",
	["corner-down-left"] = "rbxassetid://90473561177832",
	["corner-down-right"] = "rbxassetid://86512767702085",
	["cpu"] = "rbxassetid://77549309870247",
	["credit-card"] = "rbxassetid://99163352872346",
	["crop"] = "rbxassetid://116344601101413",
	["crosshair"] = "rbxassetid://134242818164054",
	["database"] = "rbxassetid://126791525623846",
	["delete"] = "rbxassetid://126279426372342",
	["disc"] = "rbxassetid://101908120120777",
	["dollar-sign"] = "rbxassetid://127320961224019",
	["download"] = "rbxassetid://134814648082393",
	["droplet"] = "rbxassetid://100597455015098",
	["edit"] = "rbxassetid://72037878096321",
	["edit-2"] = "rbxassetid://109108135755303",
	["external-link"] = "rbxassetid://129331830773832",
	["eye"] = "rbxassetid://100033680381365",
	["eye-off"] = "rbxassetid://135928786788378",
	["facebook"] = "rbxassetid://72098528632192",
	["fast-forward"] = "rbxassetid://121615540167909",
	["feather"] = "rbxassetid://91872927606406",
	["figma"] = "rbxassetid://134182122852301",
	["file"] = "rbxassetid://74748492079329",
	["file-minus"] = "rbxassetid://111014798459222",
	["file-plus"] = "rbxassetid://78881710800060",
	["file-text"] = "rbxassetid://90496405707281",
	["film"] = "rbxassetid://120978945609706",
	["filter"] = "rbxassetid://108829540827529",
	["flag"] = "rbxassetid://78183383236196",
	["folder"] = "rbxassetid://80846616596607",
	["folder-minus"] = "rbxassetid://85648718999010",
	["folder-plus"] = "rbxassetid://91865663406119",
	["frown"] = "rbxassetid://124407301067982",
	["gift"] = "rbxassetid://109855212076373",
	["git-branch"] = "rbxassetid://90490195516649",
	["git-commit"] = "rbxassetid://133646041800147",
	["git-merge"] = "rbxassetid://131833355158059",
	["git-pull-request"] = "rbxassetid://138463010991471",
	["github"] = "rbxassetid://120349554354380",
	["gitlab"] = "rbxassetid://114054627192933",
	["globe"] = "rbxassetid://114238209622913",
	["grid"] = "rbxassetid://81344910161871",
	["hard-drive"] = "rbxassetid://88183305858463",
	["hash"] = "rbxassetid://82890331678520",
	["headphones"] = "rbxassetid://118833729589183",
	["heart"] = "rbxassetid://116559368303288",
	["help-circle"] = "rbxassetid://97516698664325",
	["hexagon"] = "rbxassetid://127592089339199",
	["home"] = "rbxassetid://98755624629571",
	["image"] = "rbxassetid://123334057511782",
	["inbox"] = "rbxassetid://112591360302868",
	["info"] = "rbxassetid://124560466474914",
	["instagram"] = "rbxassetid://119864798614855",
	["italic"] = "rbxassetid://96220378864282",
	["key"] = "rbxassetid://96510194465420",
	["layers"] = "rbxassetid://81973586053257",
	["layout"] = "rbxassetid://115564446417985",
	["life-buoy"] = "rbxassetid://81168450671956",
	["link"] = "rbxassetid://131607023382430",
	["link-2"] = "rbxassetid://86072351557466",
	["linkedin"] = "rbxassetid://132842789255788",
	["list"] = "rbxassetid://113179976918783",
	["loader"] = "rbxassetid://78408734580845",
	["lock"] = "rbxassetid://134724289526879",
	["log-in"] = "rbxassetid://103768533135201",
	["log-out"] = "rbxassetid://84895399304975",
	["mail"] = "rbxassetid://103945161245599",
	["map"] = "rbxassetid://95107167260947",
	["map-pin"] = "rbxassetid://84279202219901",
	["maximize"] = "rbxassetid://76045941763188",
	["maximize-2"] = "rbxassetid://73085922906397",
	["meh"] = "rbxassetid://132197867028557",
	["menu"] = "rbxassetid://77021539815611",
	["message-circle"] = "rbxassetid://127255077587058",
	["message-square"] = "rbxassetid://83881670383280",
	["mic"] = "rbxassetid://89640799126523",
	["mic-off"] = "rbxassetid://82123034444822",
	["minimize"] = "rbxassetid://121304296213645",
	["minimize-2"] = "rbxassetid://116269596042539",
	["minus"] = "rbxassetid://118026365011536",
	["minus-circle"] = "rbxassetid://133556159576809",
	["minus-square"] = "rbxassetid://116764432015770",
	["monitor"] = "rbxassetid://72664649203050",
	["moon"] = "rbxassetid://83380517901735",
	["more-horizontal"] = "rbxassetid://140019550645825",
	["more-vertical"] = "rbxassetid://117978708573781",
	["mouse-pointer"] = "rbxassetid://72322454962935",
	["move"] = "rbxassetid://116138709011735",
	["music"] = "rbxassetid://113343203848535",
	["navigation"] = "rbxassetid://79308213542922",
	["navigation-2"] = "rbxassetid://81889066747907",
	["octagon"] = "rbxassetid://120803515514852",
	["package"] = "rbxassetid://97261141732706",
	["paperclip"] = "rbxassetid://92088291163453",
	["pause"] = "rbxassetid://74873705394436",
	["pause-circle"] = "rbxassetid://139337739700879",
	["pen-tool"] = "rbxassetid://106145404953445",
	["percent"] = "rbxassetid://130155041032013",
	["phone"] = "rbxassetid://128804946640049",
	["phone-call"] = "rbxassetid://70555587592860",
	["phone-forwarded"] = "rbxassetid://113269614319737",
	["phone-incoming"] = "rbxassetid://82863576359288",
	["phone-missed"] = "rbxassetid://130156165198376",
	["phone-off"] = "rbxassetid://133318623553383",
	["phone-outgoing"] = "rbxassetid://104576478735825",
	["pie-chart"] = "rbxassetid://113412261630136",
	["play"] = "rbxassetid://135609604299893",
	["play-circle"] = "rbxassetid://120408917249739",
	["plus"] = "rbxassetid://111774323017047",
	["plus-circle"] = "rbxassetid://113157136350384",
	["plus-square"] = "rbxassetid://114713264461873",
	["pocket"] = "rbxassetid://136686762542964",
	["power"] = "rbxassetid://96479131758775",
	["printer"] = "rbxassetid://76080649734247",
	["radio"] = "rbxassetid://85611589536956",
	["refresh-ccw"] = "rbxassetid://117913330389477",
	["refresh-cw"] = "rbxassetid://138133190015277",
	["repeat"] = "rbxassetid://121886242955173",
	["rewind"] = "rbxassetid://95205297521988",
	["rotate-ccw"] = "rbxassetid://110116685948665",
	["rotate-cw"] = "rbxassetid://84183336178654",
	["rss"] = "rbxassetid://131789058984793",
	["save"] = "rbxassetid://126116963775616",
	["scissors"] = "rbxassetid://118665510911274",
	["search"] = "rbxassetid://121018724060431",
	["send"] = "rbxassetid://127751956873796",
	["server"] = "rbxassetid://92188766517878",
	["settings"] = "rbxassetid://80758916183665",
	["share"] = "rbxassetid://87340985053299",
	["share-2"] = "rbxassetid://71210767962065",
	["shield"] = "rbxassetid://110987169760162",
	["shield-off"] = "rbxassetid://133426959132690",
	["shopping-bag"] = "rbxassetid://71885477293226",
	["shopping-cart"] = "rbxassetid://128420521375441",
	["shuffle"] = "rbxassetid://132382786975101",
	["sidebar"] = "rbxassetid://97419752870313",
	["skip-back"] = "rbxassetid://70466132711334",
	["skip-forward"] = "rbxassetid://124844823753990",
	["slack"] = "rbxassetid://96089719516736",
	["slash"] = "rbxassetid://117792185664263",
	["sliders"] = "rbxassetid://85538382643347",
	["smartphone"] = "rbxassetid://96623008834511",
	["smile"] = "rbxassetid://105880397565283",
	["speaker"] = "rbxassetid://96227183003618",
	["square"] = "rbxassetid://86304921356806",
	["star"] = "rbxassetid://136141469398409",
	["stop-circle"] = "rbxassetid://87400503942659",
	["sun"] = "rbxassetid://110150589884127",
	["sunrise"] = "rbxassetid://134705665494098",
	["sunset"] = "rbxassetid://75904872203588",
	["tablet"] = "rbxassetid://128403991264386",
	["tag"] = "rbxassetid://129104970103940",
	["target"] = "rbxassetid://87563802520297",
	["terminal"] = "rbxassetid://106783148545356",
	["thermometer"] = "rbxassetid://106546011492311",
	["thumbs-down"] = "rbxassetid://87794009914015",
	["thumbs-up"] = "rbxassetid://111137070767020",
	["toggle-left"] = "rbxassetid://85887872573050",
	["toggle-right"] = "rbxassetid://90411952142550",
	["tool"] = "rbxassetid://112148279212860",
	["trash"] = "rbxassetid://106723740584310",
	["trash-2"] = "rbxassetid://109843431391323",
	["trello"] = "rbxassetid://130987241149527",
	["trending-down"] = "rbxassetid://139309232226438",
	["trending-up"] = "rbxassetid://81819858538839",
	["triangle"] = "rbxassetid://126330486745540",
	["truck"] = "rbxassetid://86662707764771",
	["tv"] = "rbxassetid://135687724791776",
	["twitch"] = "rbxassetid://71383308134888",
	["twitter"] = "rbxassetid://88791703276842",
	["type"] = "rbxassetid://133543553793564",
	["umbrella"] = "rbxassetid://127502210274589",
	["underline"] = "rbxassetid://123709229216544",
	["unlock"] = "rbxassetid://93597915325122",
	["upload"] = "rbxassetid://138212042425501",
	["upload-cloud"] = "rbxassetid://93307473217005",
	["user"] = "rbxassetid://81589895647169",
	["user-check"] = "rbxassetid://81775205032725",
	["user-minus"] = "rbxassetid://126976941957511",
	["user-plus"] = "rbxassetid://118514469915884",
	["user-x"] = "rbxassetid://139748155894754",
	["users"] = "rbxassetid://115398113982385",
	["video"] = "rbxassetid://107587444636945",
	["video-off"] = "rbxassetid://132239189859305",
	["voicemail"] = "rbxassetid://134313454010227",
	["volume"] = "rbxassetid://103236289817396",
	["volume-1"] = "rbxassetid://98514588731639",
	["volume-2"] = "rbxassetid://89344380902620",
	["volume-x"] = "rbxassetid://139252359189540",
	["watch"] = "rbxassetid://130544621618405",
	["wifi"] = "rbxassetid://104669375183960",
	["wifi-off"] = "rbxassetid://74113634330106",
	["wind"] = "rbxassetid://114551690399915",
	["x"] = "rbxassetid://110786993356448",
	["x-circle"] = "rbxassetid://76821953846248",
	["x-octagon"] = "rbxassetid://90498161006311",
	["x-square"] = "rbxassetid://125136183850190",
	["youtube"] = "rbxassetid://123663668456341",
	["zap"] = "rbxassetid://130551565616516",
	["zap-off"] = "rbxassetid://81385483183652",
	["zoom-in"] = "rbxassetid://127956924984803",
	["zoom-out"] = "rbxassetid://108334162607319",
}

local Theme = {
	Background = Color3.fromRGB(15, 15, 20),
	BackgroundSecondary = Color3.fromRGB(25, 25, 30),
	BackgroundTertiary = Color3.fromRGB(35, 35, 40),
	TextPrimary = Color3.fromRGB(255, 255, 255),
	TextSecondary = Color3.fromRGB(180, 180, 190),
	TextMuted = Color3.fromRGB(120, 120, 130),
	Accent = Color3.fromRGB(99, 102, 241),
	AccentHover = Color3.fromRGB(129, 140, 248),
	Success = Color3.fromRGB(34, 197, 94),
	Warning = Color3.fromRGB(251, 191, 36),
	Error = Color3.fromRGB(239, 68, 68),
	Info = Color3.fromRGB(59, 130, 246),
	Border = Color3.fromRGB(50, 50, 60),
	Glow = Color3.fromRGB(99, 102, 241),
}

local function Create(className, properties)
	local instance = Instance.new(className)
	for prop, value in pairs(properties or {}) do
		instance[prop] = value
	end
	return instance
end

local function Tween(instance, properties, duration, easingStyle, easingDirection)
	duration = duration or 0.3
	easingStyle = easingStyle or Enum.EasingStyle.Quart
	easingDirection = easingDirection or Enum.EasingDirection.Out
	local tween = TweenService:Create(instance, TweenInfo.new(duration, easingStyle, easingDirection), properties)
	tween:Play()
	return tween
end

local function AddCorner(instance, radius)
	local corner = Create("UICorner", {
		CornerRadius = UDim.new(0, radius or 8),
		Parent = instance,
	})
	return corner
end

local function AddStroke(instance, color, thickness)
	local stroke = Create("UIStroke", {
		Color = color or Theme.Border,
		Thickness = thickness or 1,
		ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
		Parent = instance,
	})
	return stroke
end

local function AddShadow(instance, transparency)
	local shadow = Create("ImageLabel", {
		Name = "Shadow",
		BackgroundTransparency = 1,
		Image = "rbxassetid://131296754360830",
		ImageColor3 = Color3.fromRGB(0, 0, 0),
		ImageTransparency = transparency or 0.6,
		ScaleType = Enum.ScaleType.Slice,
		SliceCenter = Rect.new(50, 50, 50, 50),
		SliceScale = 1,
		Size = UDim2.new(1, 20, 1, 20),
		Position = UDim2.new(0, -10, 0, -10),
		ZIndex = instance.ZIndex - 1,
		Parent = instance,
	})
	return shadow
end

local NotificationSystem = {}
NotificationSystem.Queue = {}
NotificationSystem.Active = {}

function NotificationSystem:Init()
	local screenGui = Create("ScreenGui", {
		Name = "NotificationSystem",
		Parent = LocalPlayer:WaitForChild("PlayerGui"),
		ResetOnSpawn = false,
		ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
	})
	
	local container = Create("Frame", {
		Name = "Container",
		Size = UDim2.new(0, 380, 1, -20),
		Position = UDim2.new(1, -400, 0, 10),
		BackgroundTransparency = 1,
		Parent = screenGui,
	})
	
	local layout = Create("UIListLayout", {
		Padding = UDim.new(0, 10),
		HorizontalAlignment = Enum.HorizontalAlignment.Right,
		VerticalAlignment = Enum.VerticalAlignment.Top,
		SortOrder = Enum.SortOrder.LayoutOrder,
		Parent = container,
	})
	
	self.Container = container
	self.ScreenGui = screenGui
end

function NotificationSystem:Show(options)
	options = options or {}
	local title = options.Title or "Notification"
	local message = options.Message or ""
	local type = options.Type or "info"
	local duration = options.Duration or 5
	
	local colors = {
		info = Theme.Info,
		success = Theme.Success,
		warning = Theme.Warning,
		error = Theme.Error,
	}
	local icons = {
		info = Icons["info"],
		success = Icons["check-circle"],
		warning = Icons["alert-circle"],
		error = Icons["x-circle"],
	}
	
	local color = colors[type] or Theme.Info
	local icon = icons[type] or Icons["info"]
	
	local notification = Create("Frame", {
		Name = "Notification",
		Size = UDim2.new(0, 360, 0, 0),
		BackgroundColor3 = Theme.BackgroundSecondary,
		BackgroundTransparency = 0.1,
		BorderSizePixel = 0,
		ClipsDescendants = true,
		Parent = self.Container,
	})
	
	AddCorner(notification, 12)
	AddStroke(notification, Theme.Border, 1)
	
	local glow = Create("Frame", {
		Name = "Glow",
		Size = UDim2.new(0, 4, 1, 0),
		BackgroundColor3 = color,
		BorderSizePixel = 0,
		Parent = notification,
	})
	AddCorner(glow, 12)
	
	local iconFrame = Create("ImageLabel", {
		Name = "Icon",
		Size = UDim2.new(0, 24, 0, 24),
		Position = UDim2.new(0, 16, 0, 16),
		BackgroundTransparency = 1,
		Image = icon,
		ImageColor3 = color,
		Parent = notification,
	})
	
	local titleLabel = Create("TextLabel", {
		Name = "Title",
		Size = UDim2.new(1, -80, 0, 20),
		Position = UDim2.new(0, 52, 0, 16),
		BackgroundTransparency = 1,
		Text = title,
		TextColor3 = Theme.TextPrimary,
		TextSize = 16,
		Font = Enum.Font.GothamBold,
		TextXAlignment = Enum.TextXAlignment.Left,
		Parent = notification,
	})
	
	local closeBtn = Create("ImageButton", {
		Name = "Close",
		Size = UDim2.new(0, 20, 0, 20),
		Position = UDim2.new(1, -28, 0, 16),
		BackgroundTransparency = 1,
		Image = Icons["x"],
		ImageColor3 = Theme.TextMuted,
		Parent = notification,
	})
	
	local messageLabel = Create("TextLabel", {
		Name = "Message",
		Size = UDim2.new(1, -68, 0, 0),
		Position = UDim2.new(0, 52, 0, 42),
		BackgroundTransparency = 1,
		Text = message,
		TextColor3 = Theme.TextSecondary,
		TextSize = 14,
		Font = Enum.Font.Gotham,
		TextXAlignment = Enum.TextXAlignment.Left,
		TextWrapped = true,
		Parent = notification,
	})
	
	local textHeight = math.max(40, messageLabel.TextBounds.Y + 10)
	local totalHeight = textHeight + 60
	
	local progressBar = Create("Frame", {
		Name = "Progress",
		Size = UDim2.new(1, 0, 0, 3),
		Position = UDim2.new(0, 0, 1, -3),
		BackgroundColor3 = color,
		BorderSizePixel = 0,
		Parent = notification,
	})
	AddCorner(progressBar, 2)
	
	Tween(notification, {Size = UDim2.new(0, 360, 0, totalHeight)}, 0.4, Enum.EasingStyle.Back, Enum.EasingDirection.Out)
	
	local progressTween = Tween(progressBar, {Size = UDim2.new(0, 0, 0, 3)}, duration, Enum.EasingStyle.Linear)
	
	local function dismiss()
		progressTween:Cancel()
		Tween(notification, {Size = UDim2.new(0, 360, 0, 0), BackgroundTransparency = 1}, 0.3)
		Tween(iconFrame, {ImageTransparency = 1}, 0.3)
		Tween(titleLabel, {TextTransparency = 1}, 0.3)
		Tween(messageLabel, {TextTransparency = 1}, 0.3)
		Tween(glow, {BackgroundTransparency = 1}, 0.3)
		task.delay(0.3, function()
			notification:Destroy()
		end)
	end
	
	closeBtn.MouseButton1Click:Connect(dismiss)
	
	task.delay(duration, dismiss)
end

local UILibrary = {}

function UILibrary:CreateWindow(title)
	NotificationSystem:Init()
	
	local screenGui = Create("ScreenGui", {
		Name = "AdvancedUI",
		Parent = LocalPlayer:WaitForChild("PlayerGui"),
		ResetOnSpawn = false,
		ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
	})
	
	local mainFrame = Create("Frame", {
		Name = "Main",
		Size = UDim2.new(0, 700, 0, 500),
		Position = UDim2.new(0.5, -350, 0.5, -250),
		BackgroundColor3 = Theme.Background,
		BorderSizePixel = 0,
		Parent = screenGui,
	})
	AddCorner(mainFrame, 16)
	AddStroke(mainFrame, Theme.Border, 1)
	AddShadow(mainFrame, 0.7)
	
	local topBar = Create("Frame", {
		Name = "TopBar",
		Size = UDim2.new(1, 0, 0, 50),
		BackgroundColor3 = Theme.BackgroundSecondary,
		BackgroundTransparency = 0.5,
		BorderSizePixel = 0,
		Parent = mainFrame,
	})
	AddCorner(topBar, 16)
	
	local topBarCornerFix = Create("Frame", {
		Name = "CornerFix",
		Size = UDim2.new(1, 0, 0, 16),
		Position = UDim2.new(0, 0, 1, -16),
		BackgroundColor3 = Theme.BackgroundSecondary,
		BackgroundTransparency = 0.5,
		BorderSizePixel = 0,
		Parent = topBar,
	})
	
	local titleLabel = Create("TextLabel", {
		Name = "Title",
		Size = UDim2.new(1, -120, 1, 0),
		Position = UDim2.new(0, 20, 0, 0),
		BackgroundTransparency = 1,
		Text = title or "UI Library",
		TextColor3 = Theme.TextPrimary,
		TextSize = 18,
		Font = Enum.Font.GothamBold,
		TextXAlignment = Enum.TextXAlignment.Left,
		Parent = topBar,
	})
	
	local minimizeBtn = Create("ImageButton", {
		Name = "Minimize",
		Size = UDim2.new(0, 30, 0, 30),
		Position = UDim2.new(1, -80, 0.5, -15),
		BackgroundColor3 = Theme.BackgroundTertiary,
		Image = Icons["minus"],
		ImageColor3 = Theme.TextSecondary,
		Parent = topBar,
	})
	AddCorner(minimizeBtn, 8)
	
	local maximizeBtn = Create("ImageButton", {
		Name = "Maximize",
		Size = UDim2.new(0, 30, 0, 30),
		Position = UDim2.new(1, -45, 0.5, -15),
		BackgroundColor3 = Theme.BackgroundTertiary,
		Image = Icons["maximize-2"],
		ImageColor3 = Theme.TextSecondary,
		Parent = topBar,
	})
	AddCorner(maximizeBtn, 8)
	
	local closeBtn = Create("ImageButton", {
		Name = "Close",
		Size = UDim2.new(0, 30, 0, 30),
		Position = UDim2.new(1, -10, 0.5, -15),
		BackgroundColor3 = Theme.Error,
		BackgroundTransparency = 0.8,
		Image = Icons["x"],
		ImageColor3 = Theme.TextPrimary,
		Parent = topBar,
	})
	AddCorner(closeBtn, 8)
	
	local contentFrame = Create("Frame", {
		Name = "Content",
		Size = UDim2.new(1, 0, 1, -50),
		Position = UDim2.new(0, 0, 0, 50),
		BackgroundTransparency = 1,
		Parent = mainFrame,
	})
	
	local sidebar = Create("Frame", {
		Name = "Sidebar",
		Size = UDim2.new(0, 200, 1, 0),
		BackgroundColor3 = Theme.BackgroundSecondary,
		BackgroundTransparency = 0.3,
		BorderSizePixel = 0,
		Parent = contentFrame,
	})
	AddCorner(sidebar, 16)
	
	local sidebarCornerFix = Create("Frame", {
		Name = "CornerFix",
		Size = UDim2.new(0, 16, 1, 0),
		Position = UDim2.new(1, -16, 0, 0),
		BackgroundColor3 = Theme.BackgroundSecondary,
		BackgroundTransparency = 0.3,
		BorderSizePixel = 0,
		Parent = sidebar,
	})
	
	local tabContainer = Create("ScrollingFrame", {
		Name = "TabContainer",
		Size = UDim2.new(1, 0, 1, -20),
		Position = UDim2.new(0, 0, 0, 10),
		BackgroundTransparency = 1,
		BorderSizePixel = 0,
		ScrollBarThickness = 2,
		ScrollBarImageColor3 = Theme.Accent,
		CanvasSize = UDim2.new(0, 0, 0, 0),
		AutomaticCanvasSize = Enum.AutomaticSize.Y,
		Parent = sidebar,
	})
	
	local tabLayout = Create("UIListLayout", {
		Padding = UDim.new(0, 8),
		HorizontalAlignment = Enum.HorizontalAlignment.Center,
		SortOrder = Enum.SortOrder.LayoutOrder,
		Parent = tabContainer,
	})
	
	local tabPadding = Create("UIPadding", {
		PaddingLeft = UDim.new(0, 10),
		PaddingRight = UDim.new(0, 10),
		PaddingTop = UDim.new(0, 10),
		PaddingBottom = UDim.new(0, 10),
		Parent = tabContainer,
	})
	
	local pageContainer = Create("Frame", {
		Name = "PageContainer",
		Size = UDim2.new(1, -210, 1, -20),
		Position = UDim2.new(0, 205, 0, 10),
		BackgroundTransparency = 1,
		Parent = contentFrame,
	})
	
	local window = {
		ScreenGui = screenGui,
		MainFrame = mainFrame,
		TabContainer = tabContainer,
		PageContainer = pageContainer,
		Tabs = {},
		CurrentTab = nil,
	}
	
	local isMinimized = false
	local originalSize = mainFrame.Size
	local originalPos = mainFrame.Position
	
	minimizeBtn.MouseButton1Click:Connect(function()
		isMinimized = not isMinimized
		if isMinimized then
			Tween(mainFrame, {Size = UDim2.new(0, 700, 0, 50)}, 0.3)
			contentFrame.Visible = false
			minimizeBtn.Image = Icons["maximize-2"]
		else
			Tween(mainFrame, {Size = originalSize}, 0.3)
			contentFrame.Visible = true
			minimizeBtn.Image = Icons["minus"]
		end
	end)
	
	local isMaximized = false
	maximizeBtn.MouseButton1Click:Connect(function()
		isMaximized = not isMaximized
		if isMaximized then
			originalSize = mainFrame.Size
			originalPos = mainFrame.Position
			Tween(mainFrame, {Size = UDim2.new(1, -40, 1, -40), Position = UDim2.new(0, 20, 0, 20)}, 0.3)
			maximizeBtn.Image = Icons["minimize-2"]
		else
			Tween(mainFrame, {Size = originalSize, Position = originalPos}, 0.3)
			maximizeBtn.Image = Icons["maximize-2"]
		end
	end)
	
	closeBtn.MouseButton1Click:Connect(function()
		Tween(mainFrame, {Size = UDim2.new(0, 0, 0, 0), Position = UDim2.new(0.5, 0, 0.5, 0)}, 0.3)
		task.delay(0.3, function()
			screenGui:Destroy()
		end)
	end)
	
	local dragging = false
	local dragStart = nil
	local startPos = nil
	
	topBar.InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
			dragging = true
			dragStart = input.Position
			startPos = mainFrame.Position
		end
	end)
	
	UserInputService.InputChanged:Connect(function(input)
		if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
			local delta = input.Position - dragStart
			mainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
		end
	end)
	
	UserInputService.InputEnded:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
			dragging = false
		end
	end)
		function window:AddTab(name, icon)
		local tabBtn = Create("Frame", {
			Name = name .. "Tab",
			Size = UDim2.new(1, 0, 0, 40),
			BackgroundColor3 = Theme.BackgroundTertiary,
			BackgroundTransparency = 0.5,
			BorderSizePixel = 0,
			Parent = self.TabContainer,
		})
		AddCorner(tabBtn, 10)
		
		local iconImg = Create("ImageLabel", {
			Name = "Icon",
			Size = UDim2.new(0, 20, 0, 20),
			Position = UDim2.new(0, 12, 0.5, -10),
			BackgroundTransparency = 1,
			Image = icon or Icons["circle"],
			ImageColor3 = Theme.TextMuted,
			Parent = tabBtn,
		})
		
		local textLabel = Create("TextLabel", {
			Name = "Text",
			Size = UDim2.new(1, -50, 1, 0),
			Position = UDim2.new(0, 42, 0, 0),
			BackgroundTransparency = 1,
			Text = name,
			TextColor3 = Theme.TextMuted,
			TextSize = 14,
			Font = Enum.Font.GothamSemibold,
			TextXAlignment = Enum.TextXAlignment.Left,
			Parent = tabBtn,
		})
		
		local indicator = Create("Frame", {
			Name = "Indicator",
			Size = UDim2.new(0, 3, 0.6, 0),
			Position = UDim2.new(0, 0, 0.2, 0),
			BackgroundColor3 = Theme.Accent,
			BackgroundTransparency = 1,
			BorderSizePixel = 0,
			Parent = tabBtn,
		})
		AddCorner(indicator, 2)
		
		local page = Create("ScrollingFrame", {
			Name = name .. "Page",
			Size = UDim2.new(1, 0, 1, 0),
			BackgroundTransparency = 1,
			BorderSizePixel = 0,
			ScrollBarThickness = 2,
			ScrollBarImageColor3 = Theme.Accent,
			CanvasSize = UDim2.new(0, 0, 0, 0),
			AutomaticCanvasSize = Enum.AutomaticSize.Y,
			Visible = false,
			Parent = self.PageContainer,
		})
		
		local pageLayout = Create("UIListLayout", {
			Padding = UDim.new(0, 12),
			HorizontalAlignment = Enum.HorizontalAlignment.Center,
			SortOrder = Enum.SortOrder.LayoutOrder,
			Parent = page,
		})
		
		local pagePadding = Create("UIPadding", {
			PaddingLeft = UDim.new(0, 10),
			PaddingRight = UDim.new(0, 10),
			PaddingTop = UDim.new(0, 10),
			PaddingBottom = UDim.new(0, 10),
			Parent = page,
		})
		
		local tab = {
			Button = tabBtn,
			Page = page,
			Icon = iconImg,
			Text = textLabel,
			Indicator = indicator,
			Sections = {},
		}
		
		function tab:Select()
			if window.CurrentTab then
				window.CurrentTab.Page.Visible = false
				Tween(window.CurrentTab.Indicator, {BackgroundTransparency = 1}, 0.2)
				Tween(window.CurrentTab.Button, {BackgroundTransparency = 0.5}, 0.2)
				Tween(window.CurrentTab.Icon, {ImageColor3 = Theme.TextMuted}, 0.2)
				Tween(window.CurrentTab.Text, {TextColor3 = Theme.TextMuted}, 0.2)
			end
			
			window.CurrentTab = self
			self.Page.Visible = true
			Tween(self.Indicator, {BackgroundTransparency = 0}, 0.2)
			Tween(self.Button, {BackgroundTransparency = 0}, 0.2)
			Tween(self.Icon, {ImageColor3 = Theme.Accent}, 0.2)
			Tween(self.Text, {TextColor3 = Theme.TextPrimary}, 0.2)
		end
		
		tabBtn.InputBegan:Connect(function(input)
			if input.UserInputType == Enum.UserInputType.MouseButton1 then
				tab:Select()
			end
		end)
		
		tabBtn.MouseEnter:Connect(function()
			if window.CurrentTab ~= tab then
				Tween(tabBtn, {BackgroundTransparency = 0.3}, 0.2)
			end
		end)
		
		tabBtn.MouseLeave:Connect(function()
			if window.CurrentTab ~= tab then
				Tween(tabBtn, {BackgroundTransparency = 0.5}, 0.2)
			end
		end)
		
		function tab:AddSection(title)
			local section = Create("Frame", {
				Name = title .. "Section",
				Size = UDim2.new(1, 0, 0, 0),
				BackgroundColor3 = Theme.BackgroundSecondary,
				BackgroundTransparency = 0.3,
				BorderSizePixel = 0,
				AutomaticSize = Enum.AutomaticSize.Y,
				Parent = self.Page,
			})
			AddCorner(section, 12)
			
			local sectionTitle = Create("TextLabel", {
				Name = "Title",
				Size = UDim2.new(1, -20, 0, 30),
				Position = UDim2.new(0, 10, 0, 10),
				BackgroundTransparency = 1,
				Text = title,
				TextColor3 = Theme.TextPrimary,
				TextSize = 14,
				Font = Enum.Font.GothamBold,
				TextXAlignment = Enum.TextXAlignment.Left,
				Parent = section,
			})
			
			local content = Create("Frame", {
				Name = "Content",
				Size = UDim2.new(1, -20, 0, 0),
				Position = UDim2.new(0, 10, 0, 45),
				BackgroundTransparency = 1,
				AutomaticSize = Enum.AutomaticSize.Y,
				Parent = section,
			})
			
			local contentLayout = Create("UIListLayout", {
				Padding = UDim.new(0, 10),
				SortOrder = Enum.SortOrder.LayoutOrder,
				Parent = content,
			})
			
			local contentPadding = Create("UIPadding", {
				PaddingBottom = UDim.new(0, 15),
				Parent = content,
			})
			
			local sectionObj = {
				Frame = section,
				Content = content,
			}
			
			function sectionObj:AddButton(text, callback, icon)
				local btn = Create("TextButton", {
					Name = text .. "Button",
					Size = UDim2.new(1, 0, 0, 40),
					BackgroundColor3 = Theme.BackgroundTertiary,
					Text = "",
					AutoButtonColor = false,
					Parent = content,
				})
				AddCorner(btn, 8)
				
				local btnIcon = Create("ImageLabel", {
					Name = "Icon",
					Size = UDim2.new(0, 18, 0, 18),
					Position = UDim2.new(0, 12, 0.5, -9),
					BackgroundTransparency = 1,
					Image = icon or Icons["circle"],
					ImageColor3 = Theme.Accent,
					Parent = btn,
				})
				
				local btnText = Create("TextLabel", {
					Name = "Text",
					Size = UDim2.new(1, -50, 1, 0),
					Position = UDim2.new(0, 40, 0, 0),
					BackgroundTransparency = 1,
					Text = text,
					TextColor3 = Theme.TextPrimary,
					TextSize = 14,
					Font = Enum.Font.Gotham,
					TextXAlignment = Enum.TextXAlignment.Left,
					Parent = btn,
				})
				
				btn.MouseEnter:Connect(function()
					Tween(btn, {BackgroundColor3 = Theme.Accent}, 0.2)
					Tween(btnText, {TextColor3 = Color3.fromRGB(255, 255, 255)}, 0.2)
				end)
				
				btn.MouseLeave:Connect(function()
					Tween(btn, {BackgroundColor3 = Theme.BackgroundTertiary}, 0.2)
					Tween(btnText, {TextColor3 = Theme.TextPrimary}, 0.2)
				end)
				
				btn.MouseButton1Click:Connect(function()
					Tween(btn, {Size = UDim2.new(0.98, 0, 0, 40)}, 0.1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
					task.delay(0.1, function()
						Tween(btn, {Size = UDim2.new(1, 0, 0, 40)}, 0.1)
					end)
					if callback then callback() end
				end)
				
				return btn
			end
			
			function sectionObj:AddToggle(text, default, callback)
				local toggle = Create("Frame", {
					Name = text .. "Toggle",
					Size = UDim2.new(1, 0, 0, 40),
					BackgroundTransparency = 1,
					Parent = content,
				})
				
				local label = Create("TextLabel", {
					Name = "Label",
					Size = UDim2.new(1, -60, 1, 0),
					BackgroundTransparency = 1,
					Text = text,
					TextColor3 = Theme.TextPrimary,
					TextSize = 14,
					Font = Enum.Font.Gotham,
					TextXAlignment = Enum.TextXAlignment.Left,
					Parent = toggle,
				})
				
				local switch = Create("Frame", {
					Name = "Switch",
					Size = UDim2.new(0, 50, 0, 26),
					Position = UDim2.new(1, -50, 0.5, -13),
					BackgroundColor3 = Theme.BackgroundTertiary,
					BorderSizePixel = 0,
					Parent = toggle,
				})
				AddCorner(switch, 13)
				
				local knob = Create("Frame", {
					Name = "Knob",
					Size = UDim2.new(0, 20, 0, 20),
					Position = UDim2.new(0, 3, 0.5, -10),
					BackgroundColor3 = Color3.fromRGB(255, 255, 255),
					BorderSizePixel = 0,
					Parent = switch,
				})
				AddCorner(knob, 10)
				
				local enabled = default or false
				
				local function update()
					if enabled then
						Tween(switch, {BackgroundColor3 = Theme.Accent}, 0.2)
						Tween(knob, {Position = UDim2.new(0, 27, 0.5, -10)}, 0.2, Enum.EasingStyle.Back)
					else
						Tween(switch, {BackgroundColor3 = Theme.BackgroundTertiary}, 0.2)
						Tween(knob, {Position = UDim2.new(0, 3, 0.5, -10)}, 0.2, Enum.EasingStyle.Back)
					end
					if callback then callback(enabled) end
				end
				
				if enabled then
					switch.BackgroundColor3 = Theme.Accent
					knob.Position = UDim2.new(0, 27, 0.5, -10)
				end
				
				toggle.InputBegan:Connect(function(input)
					if input.UserInputType == Enum.UserInputType.MouseButton1 then
						enabled = not enabled
						update()
					end
				end)
				
				return {
					Set = function(v) enabled = v update() end,
					Get = function() return enabled end,
				}
			end
			
			function sectionObj:AddSlider(text, min, max, default, callback, suffix)
				local slider = Create("Frame", {
					Name = text .. "Slider",
					Size = UDim2.new(1, 0, 0, 60),
					BackgroundTransparency = 1,
					Parent = content,
				})
				
				local label = Create("TextLabel", {
					Name = "Label",
					Size = UDim2.new(0.7, 0, 0, 20),
					BackgroundTransparency = 1,
					Text = text,
					TextColor3 = Theme.TextPrimary,
					TextSize = 14,
					Font = Enum.Font.Gotham,
					TextXAlignment = Enum.TextXAlignment.Left,
					Parent = slider,
				})
				
				local valueLabel = Create("TextLabel", {
					Name = "Value",
					Size = UDim2.new(0.3, 0, 0, 20),
					Position = UDim2.new(0.7, 0, 0, 0),
					BackgroundTransparency = 1,
					Text = tostring(default or min) .. (suffix or ""),
					TextColor3 = Theme.Accent,
					TextSize = 14,
					Font = Enum.Font.GothamBold,
					TextXAlignment = Enum.TextXAlignment.Right,
					Parent = slider,
				})
				
				local track = Create("Frame", {
					Name = "Track",
					Size = UDim2.new(1, 0, 0, 6),
					Position = UDim2.new(0, 0, 0, 38),
					BackgroundColor3 = Theme.BackgroundTertiary,
					BorderSizePixel = 0,
					Parent = slider,
				})
				AddCorner(track, 3)
				
				local fill = Create("Frame", {
					Name = "Fill",
					Size = UDim2.new(0, 0, 1, 0),
					BackgroundColor3 = Theme.Accent,
					BorderSizePixel = 0,
					Parent = track,
				})
				AddCorner(fill, 3)
				
				local knob = Create("Frame", {
					Name = "Knob",
					Size = UDim2.new(0, 16, 0, 16),
					Position = UDim2.new(0, -8, 0.5, -8),
					BackgroundColor3 = Color3.fromRGB(255, 255, 255),
					BorderSizePixel = 0,
					Parent = fill,
				})
				AddCorner(knob, 8)
				
				local value = default or min
				local dragging = false
				
				local function update(input)
					local pos = math.clamp((input.Position.X - track.AbsolutePosition.X) / track.AbsoluteSize.X, 0, 1)
					value = math.floor(min + (max - min) * pos)
					valueLabel.Text = tostring(value) .. (suffix or "")
					fill.Size = UDim2.new(pos, 0, 1, 0)
					if callback then callback(value) end
				end
				
				local initialPos = (value - min) / (max - min)
				fill.Size = UDim2.new(initialPos, 0, 1, 0)
				
				track.InputBegan:Connect(function(input)
					if input.UserInputType == Enum.UserInputType.MouseButton1 then
						dragging = true
						update(input)
						Tween(knob, {Size = UDim2.new(0, 20, 0, 20), Position = UDim2.new(0, -10, 0.5, -10)}, 0.1)
					end
				end)
				
				UserInputService.InputChanged:Connect(function(input)
					if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
						update(input)
					end
				end)
				
				UserInputService.InputEnded:Connect(function(input)
					if input.UserInputType == Enum.UserInputType.MouseButton1 then
						dragging = false
						Tween(knob, {Size = UDim2.new(0, 16, 0, 16), Position = UDim2.new(0, -8, 0.5, -8)}, 0.1)
					end
				end)
				
				return {
					Set = function(v) 
						value = math.clamp(v, min, max)
						valueLabel.Text = tostring(value) .. (suffix or "")
						fill.Size = UDim2.new((value - min) / (max - min), 0, 1, 0)
						if callback then callback(value) end
					end,
					Get = function() return value end,
				}
			end
			
			function sectionObj:AddDropdown(text, options, default, callback)
				local dropdown = Create("Frame", {
					Name = text .. "Dropdown",
					Size = UDim2.new(1, 0, 0, 40),
					BackgroundTransparency = 1,
					Parent = content,
				})
				
				local label = Create("TextLabel", {
					Name = "Label",
					Size = UDim2.new(1, 0, 0, 20),
					BackgroundTransparency = 1,
					Text = text,
					TextColor3 = Theme.TextPrimary,
					TextSize = 14,
					Font = Enum.Font.Gotham,
					TextXAlignment = Enum.TextXAlignment.Left,
					Parent = dropdown,
				})
				
				local btn = Create("TextButton", {
					Name = "Button",
					Size = UDim2.new(1, 0, 0, 36),
					Position = UDim2.new(0, 0, 0, 24),
					BackgroundColor3 = Theme.BackgroundTertiary,
					Text = default or "Select...",
					TextColor3 = Theme.TextSecondary,
					TextSize = 13,
					Font = Enum.Font.Gotham,
					AutoButtonColor = false,
					Parent = dropdown,
				})
				AddCorner(btn, 8)
				
				local arrow = Create("ImageLabel", {
					Name = "Arrow",
					Size = UDim2.new(0, 16, 0, 16),
					Position = UDim2.new(1, -26, 0.5, -8),
					BackgroundTransparency = 1,
					Image = Icons["chevron-down"],
					ImageColor3 = Theme.TextMuted,
					Parent = btn,
				})
				
				local menu = Create("Frame", {
					Name = "Menu",
					Size = UDim2.new(1, 0, 0, 0),
					Position = UDim2.new(0, 0, 1, 5),
					BackgroundColor3 = Theme.BackgroundTertiary,
					BorderSizePixel = 0,
					ClipsDescendants = true,
					Visible = false,
					ZIndex = 100,
					Parent = btn,
				})
				AddCorner(menu, 8)
				AddStroke(menu, Theme.Border, 1)
				
				local menuScroll = Create("ScrollingFrame", {
					Name = "Scroll",
					Size = UDim2.new(1, -8, 1, -8),
					Position = UDim2.new(0, 4, 0, 4),
					BackgroundTransparency = 1,
					BorderSizePixel = 0,
					ScrollBarThickness = 2,
					ScrollBarImageColor3 = Theme.Accent,
					CanvasSize = UDim2.new(0, 0, 0, 0),
					AutomaticCanvasSize = Enum.AutomaticSize.Y,
					Parent = menu,
				})
				
				local menuLayout = Create("UIListLayout", {
					Padding = UDim.new(0, 4),
					SortOrder = Enum.SortOrder.LayoutOrder,
					Parent = menuScroll,
				})
				
				local selected = default
				local open = false
				
				for _, opt in ipairs(options or {}) do
					local optBtn = Create("TextButton", {
						Name = opt,
						Size = UDim2.new(1, 0, 0, 32),
						BackgroundColor3 = Theme.BackgroundSecondary,
						Text = opt,
						TextColor3 = Theme.TextPrimary,
						TextSize = 13,
						Font = Enum.Font.Gotham,
						AutoButtonColor = false,
						Parent = menuScroll,
					})
					AddCorner(optBtn, 6)
					
					optBtn.MouseEnter:Connect(function()
						Tween(optBtn, {BackgroundColor3 = Theme.Accent}, 0.2)
						Tween(optBtn, {TextColor3 = Color3.fromRGB(255, 255, 255)}, 0.2)
					end)
					
					optBtn.MouseLeave:Connect(function()
						Tween(optBtn, {BackgroundColor3 = Theme.BackgroundSecondary}, 0.2)
						Tween(optBtn, {TextColor3 = Theme.TextPrimary}, 0.2)
					end)
					
					optBtn.MouseButton1Click:Connect(function()
						selected = opt
						btn.Text = opt
						open = false
						Tween(menu, {Size = UDim2.new(1, 0, 0, 0)}, 0.2)
						Tween(arrow, {Rotation = 0}, 0.2)
						task.delay(0.2, function()
							menu.Visible = false
						end)
						if callback then callback(opt) end
					end)
				end
				
				btn.MouseButton1Click:Connect(function()
					open = not open
					if open then
						menu.Visible = true
						local count = math.min(#options * 36, 200)
						Tween(menu, {Size = UDim2.new(1, 0, 0, count)}, 0.2)
						Tween(arrow, {Rotation = 180}, 0.2)
					else
						Tween(menu, {Size = UDim2.new(1, 0, 0, 0)}, 0.2)
						Tween(arrow, {Rotation = 0}, 0.2)
						task.delay(0.2, function()
							menu.Visible = false
						end)
					end
				end)
				
				return {
					Set = function(v) 
						selected = v
						btn.Text = v
						if callback then callback(v) end
					end,
					Get = function() return selected end,
				}
			end
			
			function sectionObj:AddInput(text, placeholder, callback)
				local input = Create("Frame", {
					Name = text .. "Input",
					Size = UDim2.new(1, 0, 0, 70),
					BackgroundTransparency = 1,
					Parent = content,
				})
				
				local label = Create("TextLabel", {
					Name = "Label",
					Size = UDim2.new(1, 0, 0, 20),
					BackgroundTransparency = 1,
					Text = text,
					TextColor3 = Theme.TextPrimary,
					TextSize = 14,
					Font = Enum.Font.Gotham,
					TextXAlignment = Enum.TextXAlignment.Left,
					Parent = input,
				})
				
				local box = Create("TextBox", {
					Name = "Box",
					Size = UDim2.new(1, 0, 0, 40),
					Position = UDim2.new(0, 0, 0, 24),
					BackgroundColor3 = Theme.BackgroundTertiary,
					PlaceholderText = placeholder or "",
					PlaceholderColor3 = Theme.TextMuted,
					Text = "",
					TextColor3 = Theme.TextPrimary,
					TextSize = 14,
					Font = Enum.Font.Gotham,
					ClearTextOnFocus = false,
					Parent = input,
				})
				AddCorner(box, 8)
				
				box.Focused:Connect(function()
					Tween(box, {BackgroundColor3 = Theme.BackgroundSecondary}, 0.2)
				end)
				
				box.FocusLost:Connect(function()
					Tween(box, {BackgroundColor3 = Theme.BackgroundTertiary}, 0.2)
					if callback then callback(box.Text) end
				end)
				
				return {
					Set = function(v) box.Text = v end,
					Get = function() return box.Text end,
				}
			end
			
			function sectionObj:AddColorPicker(text, default, callback)
				local picker = Create("Frame", {
					Name = text .. "ColorPicker",
					Size = UDim2.new(1, 0, 0, 40),
					BackgroundTransparency = 1,
					Parent = content,
				})
				
				local label = Create("TextLabel", {
					Name = "Label",
					Size = UDim2.new(1, -60, 1, 0),
					BackgroundTransparency = 1,
					Text = text,
					TextColor3 = Theme.TextPrimary,
					TextSize = 14,
					Font = Enum.Font.Gotham,
					TextXAlignment = Enum.TextXAlignment.Left,
					Parent = picker,
				})
				
				local preview = Create("TextButton", {
					Name = "Preview",
					Size = UDim2.new(0, 40, 0, 26),
					Position = UDim2.new(1, -40, 0.5, -13),
					BackgroundColor3 = default or Color3.fromRGB(255, 255, 255),
					Text = "",
					AutoButtonColor = false,
					Parent = picker,
				})
				AddCorner(preview, 6)
				AddStroke(preview, Theme.Border, 1)
				
				local currentColor = default or Color3.fromRGB(255, 255, 255)
				local pickerOpen = false
				
				local pickerFrame = Create("Frame", {
					Name = "PickerFrame",
					Size = UDim2.new(0, 200, 0, 0),
					Position = UDim2.new(1, -200, 1, 10),
					BackgroundColor3 = Theme.BackgroundSecondary,
					BorderSizePixel = 0,
					ClipsDescendants = true,
					Visible = false,
					ZIndex = 100,
					Parent = preview,
				})
				AddCorner(pickerFrame, 12)
				AddStroke(pickerFrame, Theme.Border, 1)
				AddShadow(pickerFrame, 0.5)
				
				local h, s, v = 0, 0, 1
				local function updateColor()
					currentColor = Color3.fromHSV(h, s, v)
					preview.BackgroundColor3 = currentColor
					if callback then callback(currentColor) end
				end
				
				preview.MouseButton1Click:Connect(function()
					pickerOpen = not pickerOpen
					if pickerOpen then
						pickerFrame.Visible = true
						Tween(pickerFrame, {Size = UDim2.new(0, 200, 0, 150)}, 0.2)
					else
						Tween(pickerFrame, {Size = UDim2.new(0, 200, 0, 0)}, 0.2)
						task.delay(0.2, function()
							pickerFrame.Visible = false
						end)
					end
				end)
				
				return {
					Set = function(color) 
						currentColor = color
						preview.BackgroundColor3 = color
					end,
					Get = function() return currentColor end,
				}
			end
			
			function sectionObj:AddKeybind(text, default, callback)
				local keybind = Create("Frame", {
					Name = text .. "Keybind",
					Size = UDim2.new(1, 0, 0, 40),
					BackgroundTransparency = 1,
					Parent = content,
				})
				
				local label = Create("TextLabel", {
					Name = "Label",
					Size = UDim2.new(1, -80, 1, 0),
					BackgroundTransparency = 1,
					Text = text,
					TextColor3 = Theme.TextPrimary,
					TextSize = 14,
					Font = Enum.Font.Gotham,
					TextXAlignment = Enum.TextXAlignment.Left,
					Parent = keybind,
				})
				
				local btn = Create("TextButton", {
					Name = "Button",
					Size = UDim2.new(0, 70, 0, 30),
					Position = UDim2.new(1, -70, 0.5, -15),
					BackgroundColor3 = Theme.BackgroundTertiary,
					Text = default and default.Name or "None",
					TextColor3 = Theme.TextSecondary,
					TextSize = 12,
					Font = Enum.Font.GothamBold,
					AutoButtonColor = false,
					Parent = keybind,
				})
				AddCorner(btn, 6)
				
				local listening = false
				local currentKey = default
				
				btn.MouseButton1Click:Connect(function()
					listening = true
					btn.Text = "..."
					Tween(btn, {BackgroundColor3 = Theme.Accent}, 0.2)
				end)
				
				UserInputService.InputBegan:Connect(function(input)
					if listening and input.UserInputType == Enum.UserInputType.Keyboard then
						listening = false
						currentKey = input.KeyCode
						btn.Text = input.KeyCode.Name
						Tween(btn, {BackgroundColor3 = Theme.BackgroundTertiary}, 0.2)
						if callback then callback(input.KeyCode) end
					end
				end)
				
				return {
					Set = function(key) 
						currentKey = key
						btn.Text = key and key.Name or "None"
					end,
					Get = function() return currentKey end,
				}
			end
			
			function sectionObj:AddLabel(text)
				local label = Create("TextLabel", {
					Name = "Label",
					Size = UDim2.new(1, 0, 0, 20),
					BackgroundTransparency = 1,
					Text = text,
					TextColor3 = Theme.TextSecondary,
					TextSize = 13,
					Font = Enum.Font.Gotham,
					TextXAlignment = Enum.TextXAlignment.Left,
					TextWrapped = true,
					Parent = content,
				})
				return label
			end
			
			function sectionObj:AddDivider()
				local divider = Create("Frame", {
					Name = "Divider",
					Size = UDim2.new(1, 0, 0, 1),
					BackgroundColor3 = Theme.Border,
					BorderSizePixel = 0,
					Parent = content,
				})
				return divider
			end
			
			return sectionObj
		end
		
		table.insert(self.Tabs, tab)
		
		if #self.Tabs == 1 then
			tab:Select()
		end
		
		return tab
	end
	
	function window:Notify(options)
		NotificationSystem:Show(options)
	end
	
	return window
end

return UILibrary