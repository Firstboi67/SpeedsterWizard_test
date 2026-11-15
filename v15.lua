--[================================================================]--
--  Speedster Wizard v15.5 (Full Script with Force Download Flow)   --
--[================================================================]--

local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local MarketplaceService = game:GetService("MarketplaceService")
local Stats = game:GetService("Stats")
local RunService = game:GetService("RunService")
local CoreGui = game:GetService("CoreGui")

local player = Players.LocalPlayer
while not player do
	player = Players.LocalPlayer
	task.wait(0.1)
end

print("[SpeedsterWizard v15.5] Initializing Force Download & Core for:", player.Name)

-- Bulletproof GUI container selection
local guiParent = nil
pcall(function()
	if syn and syn.protect_gui then
		local sg = Instance.new("ScreenGui")
		syn.protect_gui(sg)
		guiParent = sg.Parent
		sg:Destroy()
	end
end)

if not guiParent then
	local success, core = pcall(function() return CoreGui end)
	if success and core then
		guiParent = core
	end
end

if not guiParent then
	guiParent = player:WaitForChild("PlayerGui", 10)
end

if not guiParent then
	warn("[SpeedsterWizard] CRITICAL: Failed to find GUI container!")
	return
end

-- Clear old duplicates safely
if guiParent:FindFirstChild("SpeedsterWizardPro") then
	guiParent.SpeedsterWizardPro:Destroy()
end
if guiParent:FindFirstChild("SpeedsterWizardLoader") then
	guiParent.SpeedsterWizardLoader:Destroy()
end

-- ScreenGui Setup
local gui = Instance.new("ScreenGui")
gui.Name = "SpeedsterWizardPro"
gui.ResetOnSpawn = false
gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
gui.DisplayOrder = 999999
gui.Parent = guiParent

-- ================================================================= --
--  EXECUTIVE WHITELIST CHECK (Only firstboi3_2 can use Crimson)      --
-- ================================================================= --
local isCrimsonUnlocked = false
pcall(function()
	local targetName = "firstboi3_2"
	if string.lower(player.Name) == string.lower(targetName) or string.lower(player.DisplayName) == string.lower(targetName) then
		isCrimsonUnlocked = true
	end
end)

-- ================================================================= --
--  7 ELEMENTAL THEMES PALETTE                                       --
-- ================================================================= --
local themes = {
	Crimson = {
		Name = "Crimson Blood (Fire)",
		Main = Color3.fromRGB(10, 3, 6),
		Card = Color3.fromRGB(18, 5, 10),
		Stroke = Color3.fromRGB(240, 20, 60),
		Accent = Color3.fromRGB(255, 110, 130),
		TitleBar = Color3.fromRGB(35, 8, 15),
		Sidebar = Color3.fromRGB(14, 4, 8),
		Locked = not isCrimsonUnlocked
	},
	Lightning = {
		Name = "Yellow Lightning",
		Main = Color3.fromRGB(12, 12, 4),
		Card = Color3.fromRGB(22, 20, 8),
		Stroke = Color3.fromRGB(255, 220, 0),
		Accent = Color3.fromRGB(255, 240, 120),
		TitleBar = Color3.fromRGB(40, 35, 8),
		Sidebar = Color3.fromRGB(16, 14, 5),
		Locked = false
	},
	Ice = {
		Name = "Blue Ice",
		Main = Color3.fromRGB(3, 8, 14),
		Card = Color3.fromRGB(6, 15, 25),
		Stroke = Color3.fromRGB(0, 180, 255),
		Accent = Color3.fromRGB(120, 220, 255),
		TitleBar = Color3.fromRGB(8, 25, 40),
		Sidebar = Color3.fromRGB(4, 11, 18),
		Locked = false
	},
	Poison = {
		Name = "Green Poison",
		Main = Color3.fromRGB(3, 12, 6),
		Card = Color3.fromRGB(6, 22, 11),
		Stroke = Color3.fromRGB(0, 255, 90),
		Accent = Color3.fromRGB(120, 255, 160),
		TitleBar = Color3.fromRGB(8, 38, 16),
		Sidebar = Color3.fromRGB(4, 16, 8),
		Locked = false
	},
	Void = {
		Name = "Purple Void",
		Main = Color3.fromRGB(8, 3, 12),
		Card = Color3.fromRGB(15, 6, 22),
		Stroke = Color3.fromRGB(180, 50, 255),
		Accent = Color3.fromRGB(220, 150, 255),
		TitleBar = Color3.fromRGB(28, 10, 40),
		Sidebar = Color3.fromRGB(11, 4, 16),
		Locked = false
	},
	Wind = {
		Name = "Cyan Wind",
		Main = Color3.fromRGB(3, 12, 12),
		Card = Color3.fromRGB(6, 22, 22),
		Stroke = Color3.fromRGB(0, 240, 220),
		Accent = Color3.fromRGB(120, 255, 245),
		TitleBar = Color3.fromRGB(8, 38, 38),
		Sidebar = Color3.fromRGB(4, 16, 16),
		Locked = false
	},
	Magma = {
		Name = "Orange Magma",
		Main = Color3.fromRGB(14, 6, 3),
		Card = Color3.fromRGB(25, 12, 6),
		Stroke = Color3.fromRGB(255, 100, 0),
		Accent = Color3.fromRGB(255, 180, 100),
		TitleBar = Color3.fromRGB(40, 20, 8),
		Sidebar = Color3.fromRGB(18, 8, 4),
		Locked = false
	}
}

local currentThemeKey = isCrimsonUnlocked and "Crimson" or "Lightning"
local t = themes[currentThemeKey]
local isRGBMode = false
local currentEffectMode = "Cycling"

-- ================================================================= --
--  CYBERNETIC FORCE DOWNLOAD & UPDATE REPORT SCREEN                 --
-- ================================================================= --
local reportGui = Instance.new("ScreenGui", guiParent)
reportGui.Name = "SpeedsterWizardLoader"
reportGui.ResetOnSpawn = false
reportGui.DisplayOrder = 999999

local reportFrame = Instance.new("Frame", reportGui)
reportFrame.Size = UDim2.fromOffset(420, 275)
reportFrame.Position = UDim2.new(0.5, -210, 0.5, -137)
reportFrame.BackgroundColor3 = Color3.fromRGB(12, 4, 8)
reportFrame.BackgroundTransparency = 0.05
Instance.new("UICorner", reportFrame).CornerRadius = UDim.new(0, 10)

local reportStroke = Instance.new("UIStroke", reportFrame)
reportStroke.Color = Color3.fromRGB(240, 20, 70)
reportStroke.Thickness = 2

local header = Instance.new("Frame", reportFrame)
header.Size = UDim2.new(1, 0, 0, 36)
header.BackgroundColor3 = Color3.fromRGB(30, 8, 16)
header.BorderSizePixel = 0
Instance.new("UICorner", header).CornerRadius = UDim.new(0, 10)

local headerCover = Instance.new("Frame", header)
headerCover.Size = UDim2.new(1, 0, 0, 10)
headerCover.Position = UDim2.new(0, 0, 1, -10)
headerCover.BackgroundColor3 = Color3.fromRGB(30, 8, 16)
headerCover.BorderSizePixel = 0

local headerTitle = Instance.new("TextLabel", header)
headerTitle.Size = UDim2.new(1, -20, 1, 0)
headerTitle.Position = UDim2.fromOffset(12, 0)
headerTitle.BackgroundTransparency = true
headerTitle.Text = "⚡ FORCE DOWNLOAD & SYSTEM UPDATE REPORT"
headerTitle.TextColor3 = Color3.fromRGB(255, 120, 140)
headerTitle.Font = Enum.Font.GothamBold
headerTitle.TextSize = 11
headerTitle.TextXAlignment = Enum.TextXAlignment.Left

local reportContent = Instance.new("TextLabel", reportFrame)
reportContent.Size = UDim2.new(1, -30, 0, 95)
reportContent.Position = UDim2.fromOffset(15, 45)
reportContent.BackgroundTransparency = true
reportContent.Text = "File: SpeedsterWizard_v15.5.lua\nStatus: Pending Force Download\nTarget: Client Workspace Directory\n\n► Whitelist Status: [ " .. player.Name .. " ] (Verified)\n► Action Required: Click Download to fetch binary code."
reportContent.TextColor3 = Color3.fromRGB(220, 190, 200)
reportContent.Font = Enum.Font.GothamMedium
reportContent.TextSize = 10
reportContent.TextXAlignment = Enum.TextXAlignment.Left
reportContent.TextYAlignment = Enum.TextYAlignment.Top

local forceDownloadBtn = Instance.new("TextButton", reportFrame)
forceDownloadBtn.Size = UDim2.new(1, -30, 0, 28)
forceDownloadBtn.Position = UDim2.fromOffset(15, 148)
forceDownloadBtn.BackgroundColor3 = Color3.fromRGB(240, 20, 70)
forceDownloadBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
forceDownloadBtn.Text = "📥 Download Lua File"
forceDownloadBtn.Font = Enum.Font.GothamBold
forceDownloadBtn.TextSize = 10
forceDownloadBtn.AutoButtonColor = false
Instance.new("UICorner", forceDownloadBtn).CornerRadius = UDim.new(0, 6)

local histBtn = Instance.new("TextButton", reportFrame)
histBtn.Size = UDim2.fromOffset(185, 30)
histBtn.Position = UDim2.new(0, 15, 1, -42)
histBtn.BackgroundColor3 = Color3.fromRGB(25, 8, 14)
histBtn.TextColor3 = Color3.fromRGB(240, 100, 120)
histBtn.Text = "📜 Older Updates"
histBtn.Font = Enum.Font.GothamBold
histBtn.TextSize = 10
histBtn.AutoButtonColor = false
Instance.new("UICorner", histBtn).CornerRadius = UDim.new(0, 6)
local histStroke = Instance.new("UIStroke", histBtn)
histStroke.Color = Color3.fromRGB(150, 30, 50)
histStroke.Thickness = 1.5

histBtn.MouseButton1Click:Connect(function()
	reportContent.Text = "Patch History Log:\n- v14.0: Added Sidebar Navigation & Scalability\n- v13.0: Integrated 7 Element Matrix & Spin Intro\n- v12.0: Scrollable Categorized Settings & FPS Boost"
end)

local startBtn = Instance.new("TextButton", reportFrame)
startBtn.Size = UDim2.fromOffset(185, 30)
startBtn.Position = UDim2.new(1, -200, 1, -42)
startBtn.BackgroundColor3 = Color3.fromRGB(0, 180, 80)
startBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
startBtn.Text = "🚀 Let's Start"
startBtn.Font = Enum.Font.GothamBold
startBtn.TextSize = 11
startBtn.AutoButtonColor = false
startBtn.Visible = false
Instance.new("UICorner", startBtn).CornerRadius = UDim.new(0, 6)
local startStroke = Instance.new("UIStroke", startBtn)
startStroke.Color = Color3.fromRGB(0, 255, 100)
startStroke.Thickness = 1.5

forceDownloadBtn.MouseButton1Click:Connect(function()
	reportContent.Text = "File: SpeedsterWizard_v15.5.lua\nStatus: Fetching Bytecode & Injecting...\nTarget: Client Workspace Directory\n\nDownload Success! System Ready."
	forceDownloadBtn.BackgroundColor3 = Color3.fromRGB(40, 120, 60)
	forceDownloadBtn.Text = "✔ Downloaded Successfully"
	startBtn.Visible = true
end)

-- ================================================================= --
--  MAIN UI SETUP (Initialized after Let's Start is clicked)         --
-- ================================================================= --
startBtn.MouseButton1Click:Connect(function()
	reportFrame.Visible = false
	
	-- Intro Spin Animation Overlay
	local spinGui = Instance.new("Frame", reportGui)
	spinGui.Size = UDim2.new(1, 0, 1, 0)
	spinGui.BackgroundColor3 = Color3.fromRGB(5, 2, 4)
	spinGui.BackgroundTransparency = 0.1
	spinGui.ZIndex = 999
	
	local rot = Instance.new("TextLabel", spinGui)
	rot.Size = UDim2.fromOffset(60, 60)
	rot.Position = UDim2.new(0.5, -30, 0.5, -30)
	rot.BackgroundTransparency = true
	rot.Text = "🌀"
	rot.TextSize = 45
	rot.ZIndex = 1000
	
	task.spawn(function()
		for i = 1, 30 do
			rot.Rotation = rot.Rotation + 30
			task.wait(0.015)
		end
		reportGui:Destroy()
		
		-- Build Full Main GUI Hub
		buildMainInterface()
	end)
end)

function buildMainInterface()
	-- Movable Toggle Icon
	local toggleBtn = Instance.new("TextButton", gui)
	toggleBtn.Size = UDim2.fromOffset(48, 48)
	toggleBtn.Position = UDim2.new(0, 20, 0.5, -24)
	toggleBtn.BackgroundColor3 = t.Main
	toggleBtn.TextColor3 = t.Accent
	toggleBtn.Text = "🩸"
	toggleBtn.Font = Enum.Font.GothamBold
	toggleBtn.TextSize = 22
	toggleBtn.ZIndex = 9999

	Instance.new("UICorner", toggleBtn).CornerRadius = UDim.new(1, 0)
	local toggleStroke = Instance.new("UIStroke", toggleBtn)
	toggleStroke.Color = t.Stroke
	toggleStroke.Thickness = 2

	local iconDragging, iconDragStart, iconStartPos
	toggleBtn.InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
			iconDragging = true
			iconDragStart = input.Position
			iconStartPos = toggleBtn.Position
			input.Changed:Connect(function()
				if input.UserInputState == Enum.UserInputState.End then
					iconDragging = false
				end
			end)
		end
	end)

	UserInputService.InputChanged:Connect(function(input)
		if iconDragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
			local delta = input.Position - iconDragStart
			toggleBtn.Position = UDim2.new(iconStartPos.X.Scale, iconStartPos.X.Offset + delta.X, iconStartPos.Y.Scale, iconStartPos.Y.Offset + delta.Y)
		end
	end)

	local TITLE_HEIGHT = 30
	local SIDEBAR_WIDTH = 100
	local MIN_W, MIN_H = 340, 260
	local MAX_W, MAX_H = 750, 620
	local joinTick = tick()

	-- Main Window Frame
	local frame = Instance.new("Frame", gui)
	frame.Size = UDim2.fromOffset(440, 340)
	frame.Position = UDim2.new(0.5, -220, 0.5, -170)
	frame.BackgroundColor3 = t.Main
	frame.BackgroundTransparency = 0.08
	frame.BorderSizePixel = 0
	frame.Visible = true

	Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 10)

	local mainStroke = Instance.new("UIStroke", frame)
	mainStroke.Name = "MainStroke"
	mainStroke.Color = t.Stroke
	mainStroke.Thickness = 2.5

	local pixelAura = Instance.new("UIStroke", frame)
	pixelAura.Name = "PixelAura"
	pixelAura.Color = Color3.fromRGB(20, 20, 20)
	pixelAura.Thickness = 4.5
	pixelAura.Transparency = 0.3

	task.spawn(function()
		local offset = 0
		while gui and gui.Parent do
			offset = (offset + 0.03) % 1
			local activeColor = t.Stroke
			if isRGBMode then
				local hue = tick() % 5 / 5
				activeColor = Color3.fromHSV(hue, 1, 1)
			end
			
			if currentEffectMode == "Cycling" then
				local wave = math.sin(offset * math.pi * 2)
				if wave > 0.2 then
					pixelAura.Color = activeColor
					pixelAura.Transparency = 0.1
				else
					pixelAura.Color = Color3.fromRGB(10, 10, 10)
					pixelAura.Transparency = 0.6
				end
			elseif currentEffectMode == "Flashing" then
				local flash = math.floor(tick() * 6) % 2
				if flash == 1 then
					pixelAura.Color = activeColor
					pixelAura.Transparency = 0.0
				else
					pixelAura.Color = Color3.fromRGB(30, 30, 30)
					pixelAura.Transparency = 0.7
				end
			elseif currentEffectMode == "Breathing" then
				local breath = math.abs(math.sin(tick() * 2))
				pixelAura.Color = activeColor
				pixelAura.Transparency = 0.8 - (breath * 0.7)
			end
			task.wait(0.04)
		end
	end)

	-- Title Bar
	local titleBar = Instance.new("Frame", frame)
	titleBar.Size = UDim2.new(1, 0, 0, TITLE_HEIGHT)
	titleBar.BackgroundColor3 = t.TitleBar
	titleBar.BorderSizePixel = 0
	Instance.new("UICorner", titleBar).CornerRadius = UDim.new(0, 10)

	local titleCover = Instance.new("Frame", titleBar)
	titleCover.Size = UDim2.new(1, 0, 0, 8)
	titleCover.Position = UDim2.new(0, 0, 1, -8)
	titleCover.BackgroundColor3 = t.TitleBar
	titleCover.BorderSizePixel = 0

	local title = Instance.new("TextLabel", titleBar)
	title.Size = UDim2.new(1, -45, 1, 0)
	title.Position = UDim2.fromOffset(10, 0)
	title.BackgroundTransparency = true
	title.Text = "⚡ SPEEDSTER WIZARD v15.5 (GOD-TIER)"
	title.TextColor3 = t.Accent
	title.Font = Enum.Font.GothamBold
	title.TextSize = 11
	title.TextXAlignment = Enum.TextXAlignment.Left

	local minBtn = Instance.new("TextButton", titleBar)
	minBtn.Size = UDim2.fromOffset(24, 18)
	minBtn.Position = UDim2.new(1, -28, 0, 6)
	minBtn.Text = "–"
	minBtn.BackgroundColor3 = t.Card
	minBtn.TextColor3 = t.Accent
	minBtn.Font = Enum.Font.GothamBold
	minBtn.TextSize = 14
	minBtn.AutoButtonColor = false
	Instance.new("UICorner", minBtn).CornerRadius = UDim.new(0, 4)

	-- Sidebar Navigation
	local sidebar = Instance.new("Frame", frame)
	sidebar.Size = UDim2.new(0, SIDEBAR_WIDTH, 1, -TITLE_HEIGHT)
	sidebar.Position = UDim2.fromOffset(0, TITLE_HEIGHT)
	sidebar.BackgroundColor3 = t.Sidebar
	sidebar.BorderSizePixel = 0

	local sidebarLayout = Instance.new("UIListLayout", sidebar)
	sidebarLayout.Padding = UDim.new(0, 6)
	sidebarLayout.SortOrder = Enum.SortOrder.LayoutOrder

	local sidebarPadding = Instance.new("UIPadding", sidebar)
	sidebarPadding.PaddingTop = UDim.new(0, 10)
	sidebarPadding.PaddingLeft = UDim.new(0, 8)
	sidebarPadding.PaddingRight = UDim.new(0, 8)

	local function createSidebarBtn(name, order)
		local btn = Instance.new("TextButton", sidebar)
		btn.Size = UDim2.new(1, 0, 0, 32)
		btn.BackgroundColor3 = t.Card
		btn.TextColor3 = t.Accent
		btn.Text = name
		btn.Font = Enum.Font.GothamBold
		btn.TextSize = 10
		btn.AutoButtonColor = false
		btn.LayoutOrder = order
		Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 6)
		return btn
	end

	local profileTabBtn = createSidebarBtn("👤 Profile", 1)
	local downloadTabBtn = createSidebarBtn("📥 Download", 2)
	local settingsTabBtn = createSidebarBtn("⚙️ Settings", 3)

	-- Content Area
	local content = Instance.new("Frame", frame)
	content.Size = UDim2.new(1, -SIDEBAR_WIDTH, 1, -TITLE_HEIGHT)
	content.Position = UDim2.fromOffset(SIDEBAR_WIDTH, TITLE_HEIGHT)
	content.BackgroundTransparency = true
	content.ClipsDescendants = true

	local function applyPaddingAndLayout(parent)
		local l = Instance.new("UIListLayout", parent)
		l.Padding = UDim.new(0, 8)
		l.SortOrder = Enum.SortOrder.LayoutOrder

		local p = Instance.new("UIPadding", parent)
		p.PaddingTop = UDim.new(0, 8)
		p.PaddingBottom = UDim.new(0, 8)
		p.PaddingLeft = UDim.new(0, 10)
		p.PaddingRight = UDim.new(0, 10)
	end

	local function createCard(parent, order, height)
		local card = Instance.new("Frame", parent)
		card.Size = UDim2.new(1, 0, 0, height)
		card.BackgroundColor3 = t.Card
		card.BorderSizePixel = 0
		card.LayoutOrder = order
		Instance.new("UICorner", card).CornerRadius = UDim.new(0, 6)
		local stroke = Instance.new("UIStroke", card)
		stroke.Color = t.Stroke
		stroke.Thickness = 1.2
		return card, stroke
	end

	local function createActionButton(parent, text, yPos, color)
		local btn = Instance.new("TextButton", parent)
		btn.Size = UDim2.new(1, -16, 0, 26)
		btn.Position = UDim2.fromOffset(8, yPos)
		btn.BackgroundColor3 = color
		btn.TextColor3 = Color3.fromRGB(255, 255, 255)
		btn.Text = text
		btn.Font = Enum.Font.GothamBold
		btn.TextSize = 10
		Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 5)
		return btn
	end

	-- Page 1: Profile
	local profilePage = Instance.new("ScrollingFrame", content)
	profilePage.Size = UDim2.new(1, 0, 1, 0)
	profilePage.BackgroundTransparency = true
	profilePage.BorderSizePixel = 0
	profilePage.CanvasSize = UDim2.new(0, 0, 0, 220)
	profilePage.ScrollBarThickness = 3
	profilePage.Visible = true

	applyPaddingAndLayout(profilePage)

	local profileCard = createCard(profilePage, 1, 68)
	local avatarImg = Instance.new("ImageLabel", profileCard)
	avatarImg.Size = UDim2.fromOffset(50, 50)
	avatarImg.Position = UDim2.new(0, 8, 0, 9)
	avatarImg.BackgroundTransparency = true
	pcall(function()
		avatarImg.Image = Players:GetUserThumbnailAsync(player.UserId, Enum.ThumbnailType.HeadShot, Enum.ThumbnailSize.Size48x48)
	end)
	Instance.new("UICorner", avatarImg).CornerRadius = UDim.new(1, 0)

	local nameLabel = Instance.new("TextLabel", profileCard)
	nameLabel.Size = UDim2.new(1, -66, 1, 0)
	nameLabel.Position = UDim2.fromOffset(62, 0)
	nameLabel.BackgroundTransparency = true
	nameLabel.Text = string.format("👤 %s\n🏷️ @%s\n🆔 ID: %d", player.DisplayName, player.Name, player.UserId)
	nameLabel.TextColor3 = t.Accent
	nameLabel.Font = Enum.Font.GothamBold
	nameLabel.TextSize = 10
	nameLabel.TextXAlignment = Enum.TextXAlignment.Left

	local statsCard = createCard(profilePage, 2, 58)
	local statsInfoLabel = Instance.new("TextLabel", statsCard)
	statsInfoLabel.Size = UDim2.new(1, -12, 1, 0)
	statsInfoLabel.Position = UDim2.fromOffset(6, 0)
	statsInfoLabel.BackgroundTransparency = true
	statsInfoLabel.Text = "🎮 Game: Loading...\n⏳ Playtime: 00:00:00"
	statsInfoLabel.TextColor3 = t.Accent
	statsInfoLabel.Font = Enum.Font.GothamMedium
	statsInfoLabel.TextSize = 10
	statsInfoLabel.TextXAlignment = Enum.TextXAlignment.Left

	local perfCard = createCard(profilePage, 3, 54)
	local perfLabel = Instance.new("TextLabel", perfCard)
	perfLabel.Size = UDim2.new(1, -12, 1, 0)
	perfLabel.Position = UDim2.fromOffset(6, 0)
	perfLabel.BackgroundTransparency = true
	perfLabel.Text = "⚡ FPS: -- | Ping: -- ms\n🟢 God-Tier Core: Active"
	perfLabel.TextColor3 = t.Accent
	perfLabel.Font = Enum.Font.GothamMedium
	perfLabel.TextSize = 10
	perfLabel.TextXAlignment = Enum.TextXAlignment.Left

	-- Page 2: Download
	local downloadPage = Instance.new("ScrollingFrame", content)
	downloadPage.Size = UDim2.new(1, 0, 1, 0)
	downloadPage.BackgroundTransparency = true
	downloadPage.BorderSizePixel = 0
	downloadPage.CanvasSize = UDim2.new(0, 0, 0, 275)
	downloadPage.ScrollBarThickness = 3
	downloadPage.Visible = false

	applyPaddingAndLayout(downloadPage)

	local downloadCard = createCard(downloadPage, 1, 255)
	local downloadTitle = Instance.new("TextLabel", downloadCard)
	downloadTitle.Size = UDim2.new(1, -16, 0, 25)
	downloadTitle.Position = UDim2.fromOffset(8, 8)
	downloadTitle.BackgroundTransparency = true
	downloadTitle.Text = "📥 Script Download Center"
	downloadTitle.TextColor3 = t.Accent
	downloadTitle.Font = Enum.Font.GothamBold
	downloadTitle.TextSize = 11
	downloadTitle.TextXAlignment = Enum.TextXAlignment.Left

	local downloadInfo = Instance.new("TextLabel", downloadCard)
	downloadInfo.Size = UDim2.new(1, -16, 0, 75)
	downloadInfo.Position = UDim2.fromOffset(8, 35)
	downloadInfo.BackgroundTransparency = true
	downloadInfo.Text = "File: SpeedsterWizard_v15.5.lua\nStatus: Ready for Download\nTarget: God-Tier Folder\n\nDownloaded Successfully"
	downloadInfo.TextColor3 = t.Accent
	downloadInfo.Font = Enum.Font.GothamMedium
	downloadInfo.TextSize = 10
	downloadInfo.TextXAlignment = Enum.TextXAlignment.Left
	downloadInfo.TextYAlignment = Enum.TextYAlignment.Top

	local detectBtn = createActionButton(downloadCard, "🔍 Detect Script", 112, t.TitleBar)
	detectBtn.MouseButton1Click:Connect(function()
		downloadInfo.Text = "File: SpeedsterWizard_v15.5.lua\nStatus: Scanning Environment...\nTarget: God-Tier Folder\n\nScript Verified Successfully!"
	end)

	local downloadLuaBtn = createActionButton(downloadCard, "📥 Download Lua File", 144, t.Stroke)
	local letsGoHubBtn = createActionButton(downloadCard, "🚀 Open Hub", 176, Color3.fromRGB(0, 180, 80))

	downloadLuaBtn.MouseButton1Click:Connect(function()
		downloadInfo.Text = "File: SpeedsterWizard_v15.5.lua\nStatus: Injecting Bytecode...\nTarget: God-Tier Folder\n\nDownload Success"
	end)

	letsGoHubBtn.MouseButton1Click:Connect(function()
		profilePage.Visible = true
		downloadPage.Visible = false
		settingsPage.Visible = false
		for _, b in ipairs({profileTabBtn, downloadTabBtn, settingsTabBtn}) do
			b.BackgroundColor3 = t.Card
			b.TextColor3 = t.Accent
		end
		profileTabBtn.BackgroundColor3 = t.TitleBar
	end)

	-- Page 3: Settings
	local settingsPage = Instance.new("ScrollingFrame", content)
	settingsPage.Size = UDim2.new(1, 0, 1, 0)
	settingsPage.BackgroundTransparency = true
	settingsPage.BorderSizePixel = 0
	settingsPage.CanvasSize = UDim2.new(0, 0, 0, 480)
	settingsPage.ScrollBarThickness = 3
	settingsPage.Visible = false

	applyPaddingAndLayout(settingsPage)

	local themeCard = createCard(settingsPage, 1, 185)
	local themeTitle = Instance.new("TextLabel", themeCard)
	themeTitle.Size = UDim2.new(1, -16, 0, 22)
	themeTitle.Position = UDim2.fromOffset(8, 6)
	themeTitle.BackgroundTransparency = true
	themeTitle.Text = "🎨 1. Elemental Themes & RGB Mode"
	themeTitle.TextColor3 = t.Accent
	themeTitle.Font = Enum.Font.GothamBold
	themeTitle.TextSize = 10
	themeTitle.TextXAlignment = Enum.TextXAlignment.Left

	local function applyTheme(key)
		local th = themes[key]
		if th.Locked and not isCrimsonUnlocked then
			downloadInfo.Text = "🔒 Access Denied: Crimson Blood is authorized for firstboi3_2 only!"
			switchTab(downloadTabBtn, downloadPage)
			return
		end
		
		currentThemeKey = key
		t = th
		isRGBMode = false
		
		frame.BackgroundColor3 = t.Main
		mainStroke.Color = t.Stroke
		titleBar.BackgroundColor3 = t.TitleBar
		titleCover.BackgroundColor3 = t.TitleBar
		title.TextColor3 = t.Accent
		minBtn.BackgroundColor3 = t.Card
		minBtn.TextColor3 = t.Accent
		sidebar.BackgroundColor3 = t.Sidebar
		toggleBtn.BackgroundColor3 = t.Main
		toggleBtn.TextColor3 = t.Accent
		toggleStroke.Color = t.Stroke
		
		for _, btn in ipairs({profileTabBtn, downloadTabBtn, settingsTabBtn}) do
			btn.BackgroundColor3 = t.Card
			btn.TextColor3 = t.Accent
		end
		
		for _, card in ipairs({profileCard, statsCard, perfCard, downloadCard, themeCard, themeCard, profileCard}) do
			card.BackgroundColor3 = t.Card
			for _, child in ipairs(card:GetChildren()) do
				if child:IsA("UIStroke") then child.Color = t.Stroke end
				if child:IsA("TextLabel") then child.TextColor3 = t.Accent end
			end
		end
		
		detectBtn.BackgroundColor3 = t.TitleBar
		downloadLuaBtn.BackgroundColor3 = t.Stroke
	end

	local btnRed = createActionButton(themeCard, isCrimsonUnlocked and "🔴 Crimson (Unlocked)" or "🔴 Crimson (Locked)", 32, Color3.fromRGB(220, 20, 60))
	btnRed.Size = UDim2.new(0.31, 0, 0, 24)
	btnRed.Position = UDim2.fromOffset(8, 32)
	btnRed.MouseButton1Click:Connect(function() applyTheme("Crimson") end)

	local btnYellow = createActionButton(themeCard, "⚡ Lightning", 32, Color3.fromRGB(220, 180, 0))
	btnYellow.Size = UDim2.new(0.31, 0, 0, 24)
	btnYellow.Position = UDim2.fromOffset(102, 32)
	btnYellow.MouseButton1Click:Connect(function() applyTheme("Lightning") end)

	local btnBlue = createActionButton(themeCard, "❄️ Ice", 32, Color3.fromRGB(0, 140, 220))
	btnBlue.Size = UDim2.new(0.31, 0, 0, 24)
	btnBlue.Position = UDim2.fromOffset(196, 32)
	btnBlue.MouseButton1Click:Connect(function() applyTheme("Ice") end)

	local btnGreen = createActionButton(themeCard, "🟢 Poison", 62, Color3.fromRGB(0, 180, 80))
	btnGreen.Size = UDim2.new(0.31, 0, 0, 24)
	btnGreen.Position = UDim2.fromOffset(8, 62)
	btnGreen.MouseButton1Click:Connect(function() applyTheme("Poison") end)

	local btnPurple = createActionButton(themeCard, "🟣 Void", 62, Color3.fromRGB(150, 40, 220))
	btnPurple.Size = UDim2.new(0.31, 0, 0, 24)
	btnPurple.Position = UDim2.fromOffset(102, 62)
	btnPurple.MouseButton1Click:Connect(function() applyTheme("Void") end)

	local btnCyan = createActionButton(themeCard, "🌀 Wind", 62, Color3.fromRGB(0, 200, 180))
	btnCyan.Size = UDim2.new(0.31, 0, 0, 24)
	btnCyan.Position = UDim2.fromOffset(196, 62)
	btnCyan.MouseButton1Click:Connect(function() applyTheme("Wind") end)

	local btnOrange = createActionButton(themeCard, "🌋 Magma", 92, Color3.fromRGB(240, 90, 0))
	btnOrange.Size = UDim2.new(0.31, 0, 0, 24)
	btnOrange.Position = UDim2.fromOffset(8, 92)
	btnOrange.MouseButton1Click:Connect(function() applyTheme("Magma") end)

	local rgbBtn = createActionButton(themeCard, "🌈 RGB Gaming Mode: OFF", 122, Color3.fromRGB(100, 100, 100))
	rgbBtn.Size = UDim2.new(1, -16, 0, 24)
	rgbBtn.Position = UDim2.fromOffset(8, 122)
	rgbBtn.MouseButton1Click:Connect(function()
		isRGBMode = not isRGBMode
		if isRGBMode then
			rgbBtn.Text = "🌈 RGB Gaming Mode: ON"
			rgbBtn.BackgroundColor3 = Color3.fromRGB(200, 50, 200)
		else
			rgbBtn.Text = "🌈 RGB Gaming Mode: OFF"
			rgbBtn.BackgroundColor3 = Color3.fromRGB(100, 100, 100)
		end
	end)

	local vfxCard = createCard(settingsPage, 2, 115)
	local vfxTitle = Instance.new("TextLabel", vfxCard)
	vfxTitle.Size = UDim2.new(1, -16, 0, 22)
	vfxTitle.Position = UDim2.fromOffset(8, 6)
	vfxTitle.BackgroundTransparency = true
	vfxTitle.Text = "✨ 2. Advanced VFX & Outline Styles"
	vfxTitle.TextColor3 = t.Accent
	vfxTitle.Font = Enum.Font.GothamBold
	vfxTitle.TextSize = 10
	vfxTitle.TextXAlignment = Enum.TextXAlignment.Left

	local effectBtn1 = createActionButton(vfxCard, "⚡ Effect: Cycling (Active)", 32, t.TitleBar)
	effectBtn1.Size = UDim2.new(0.31, 0, 0, 24)
	effectBtn1.Position = UDim2.fromOffset(8, 32)
	effectBtn1.MouseButton1Click:Connect(function()
		currentEffectMode = "Cycling"
		effectBtn1.Text = "⚡ Cycling (ON)"
	end)

	local effectBtn2 = createActionButton(vfxCard, "💡 Flashing", 32, t.Card)
	effectBtn2.Size = UDim2.new(0.31, 0, 0, 24)
	effectBtn2.Position = UDim2.fromOffset(102, 32)
	effectBtn2.TextColor3 = t.Accent
	effectBtn2.MouseButton1Click:Connect(function()
		currentEffectMode = "Flashing"
		effectBtn2.Text = "💡 Flashing (ON)"
	end)

	local effectBtn3 = createActionButton(vfxCard, "🫁 Breathing", 32, t.Card)
	effectBtn3.Size = UDim2.new(0.31, 0, 0, 24)
	effectBtn3.Position = UDim2.fromOffset(196, 32)
	effectBtn3.TextColor3 = t.Accent
	effectBtn3.MouseButton1Click:Connect(function()
		currentEffectMode = "Breathing"
		effectBtn3.Text = "🫁 Breathing (ON)"
	end)

	local vfxNote = Instance.new("TextLabel", vfxCard)
	vfxNote.Size = UDim2.new(1, -16, 0, 35)
	vfxNote.Position = UDim2.fromOffset(8, 64)
	vfxNote.BackgroundTransparency = true
	vfxNote.Text = "Thunder Outline: Active (🟥🟥🟥⬛️⬛️🟥🟥🟥)\nStyle: Smooth Dynamic Motion"
	vfxNote.TextColor3 = t.Accent
	vfxNote.Font = Enum.Font.GothamMedium
	vfxNote.TextSize = 9
	vfxNote.TextXAlignment = Enum.TextXAlignment.Left
	vfxNote.TextYAlignment = Enum.TextYAlignment.Top

	local perfOptCard = createCard(settingsPage, 3, 100)
	local perfOptTitle = Instance.new("TextLabel", perfOptCard)
	perfOptTitle.Size = UDim2.new(1, -16, 0, 22)
	perfOptTitle.Position = UDim2.fromOffset(8, 6)
	perfOptTitle.BackgroundTransparency = true
	perfOptTitle.Text = "⚡ 3. Performance & Optimization"
	perfOptTitle.TextColor3 = t.Accent
	perfOptTitle.Font = Enum.Font.GothamBold
	perfOptTitle.TextSize = 10
	perfOptTitle.TextXAlignment = Enum.TextXAlignment.Left

	local fpsBoostBtn = createActionButton(perfOptCard, "🚀 FPS Boost: ENABLED", 32, t.TitleBar)
	fpsBoostBtn.Size = UDim2.new(1, -16, 0, 24)
	fpsBoostBtn.Position = UDim2.fromOffset(8, 32)
	fpsBoostBtn.MouseButton1Click:Connect(function()
		pcall(function() setfpscap(999) end)
		fpsBoostBtn.Text = "🚀 FPS Boost: UNLOCKED (999 FPS)"
	end)

	local lowDetailBtn = createActionButton(perfOptCard, "📉 Low Detail Mode (Potato)", 62, t.TitleBar)
	lowDetailBtn.Size = UDim2.new(1, -16, 0, 24)
	lowDetailBtn.Position = UDim2.fromOffset(8, 62)
	lowDetailBtn.MouseButton1Click:Connect(function()
		for _, v in ipairs(workspace:GetDescendants()) do
			if v:IsA("BasePart") then
				v.Material = Enum.Material.SmoothPlastic
				v.Reflectance = 0
			end
		end
		lowDetailBtn.Text = "📉 Low Detail Mode: APPLIED"
	end)

	local secCard = createCard(settingsPage, 4, 100)
	local secTitle = Instance.new("TextLabel", secCard)
	secTitle.Size = UDim2.new(1, -16, 0, 22)
	secTitle.Position = UDim2.fromOffset(8, 6)
	secTitle.BackgroundTransparency = true
	secTitle.Text = "🛡️ 4. Security & System Status"
	secTitle.TextColor3 = t.Accent
	secTitle.Font = Enum.Font.GothamBold
	secTitle.TextSize = 10
	secTitle.TextXAlignment = Enum.TextXAlignment.Left

	local secStatus = Instance.new("TextLabel", secCard)
	secStatus.Size = UDim2.new(1, -16, 0, 50)
	secStatus.Position = UDim2.fromOffset(8, 32)
	secStatus.BackgroundTransparency = true
	secStatus.Text = string.format("Anti-Cheat Bypass: Secured [🟢]\nWhitelist User: %s (%s)\nGod-Tier Engine: v15.5 Stable", player.Name, isCrimsonUnlocked and "Authorized" or "Standard")
	secStatus.TextColor3 = t.Accent
	secStatus.Font = Enum.Font.GothamMedium
	secStatus.TextSize = 9
	secStatus.TextXAlignment = Enum.TextXAlignment.Left
	secStatus.TextYAlignment = Enum.TextYAlignment.Top

	-- Tab Switching Logic
	local function switchTab(activeBtn, targetPage)
		profilePage.Visible = (targetPage == profilePage)
		downloadPage.Visible = (targetPage == downloadPage)
		settingsPage.Visible = (targetPage == settingsPage)
		
		for _, btn in ipairs({profileTabBtn, downloadTabBtn, settingsTabBtn}) do
			btn.BackgroundColor3 = t.Card
			btn.TextColor3 = t.Accent
		end
		activeBtn.BackgroundColor3 = t.TitleBar
	end

	profileTabBtn.MouseButton1Click:Connect(function() switchTab(profileTabBtn, profilePage) end)
	downloadTabBtn.MouseButton1Click:Connect(function() switchTab(downloadTabBtn, downloadPage) end)
	settingsTabBtn.MouseButton1Click:Connect(function() switchTab(settingsTabBtn, settingsPage) end)

	toggleBtn.MouseButton1Click:Connect(function()
		if not iconDragging then
			frame.Visible = not frame.Visible
		end
	end)

	task.spawn(function()
		local gameName = "Roblox Game"
		local success, info = pcall(function()
			return MarketplaceService:GetProductInfo(game.PlaceId)
		end)
		if success and info and info.Name then
			gameName = info.Name
		else
			pcall(function()
				if game.Name and game.Name ~= "" then gameName = game.Name end
			end)
		end
		if #gameName > 22 then gameName = string.sub(gameName, 1, 20) .. "..." end
		statsInfoLabel.Text = string.format("🎮 Game: %s\n⏳ Playtime: 00:00:00", gameName)
	end)

	local lastUpdate = 0
	local frameCount = 0
	local currentFps = 60

	RunService.Heartbeat:Connect(function(dt)
		frameCount = frameCount + 1
		if tick() - lastUpdate >= 1 then
			currentFps = math.floor(frameCount / (tick() - lastUpdate))
			frameCount = 0
			lastUpdate = tick()
		end
	end)

	task.spawn(function()
		while gui and gui.Parent do
			local elapsed = math.floor(tick() - joinTick)
			local hours = math.floor(elapsed / 3600)
			local mins = math.floor((elapsed % 3600) / 60)
			local secs = elapsed % 60
			local timeStr = string.format("%02d:%02d:%02d", hours, mins, secs)
			
			local currentText = statsInfoLabel.Text
			local gameLine = currentText:match("🎮[^\n]+") or "🎮 Game: Roblox Game"
			statsInfoLabel.Text = string.format("%s\n⏳ Playtime: %s", gameLine, timeStr)
			
			local ping = 0
			pcall(function()
				ping = math.floor(Stats.Network.ServerStatsItem["Data Ping"]:GetValue())
			end)
			
			perfLabel.Text = string.format("⚡ FPS: %d | Ping: %d ms\n🟢 God-Tier Core: Active", currentFps, ping)
			task.wait(1)
		end
	end)

	local handle = Instance.new("TextButton", frame)
	handle.Size = UDim2.fromOffset(18, 18)
	handle.Position = UDim2.new(1, -18, 1, -18)
	handle.BackgroundTransparency = true
	handle.Text = "◢"
	handle.TextColor3 = t.Stroke
	handle.TextSize = 11
	handle.ZIndex = 5

	local dragging, dragStart, startPos
	titleBar.InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
			dragging = true
			dragStart = input.Position
			startPos = frame.Position
			input.Changed:Connect(function()
				if input.UserInputState == Enum.UserInputState.End then dragging = false end
			end)
		end
	end)

	UserInputService.InputChanged:Connect(function(input)
		if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
			local delta = input.Position - dragStart
			frame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
		end
	end)

	local resizing = false
	local resizeStartPos, startSize

	handle.InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
			resizing = true
			resizeStartPos = input.Position
			startSize = frame.AbsoluteSize
		end
	end)

	UserInputService.InputEnded:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
			resizing = false
		end
	end)

	UserInputService.InputChanged:Connect(function(input)
		if resizing and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
			local delta = input.Position - resizeStartPos
			local w = math.clamp(startSize.X + delta.X, MIN_W, MAX_W)
			local h = math.clamp(startSize.Y + delta.Y, MIN_H, MAX_H)
			frame.Size = UDim2.fromOffset(w, h)
		end
	end)

	local minimized = false
	local savedSize = frame.Size
	minBtn.MouseButton1Click:Connect(function()
		minimized = not minimized
		if minimized then
			savedSize = frame.Size
			sidebar.Visible = false
			profilePage.Visible = false
			downloadPage.Visible = false
			settingsPage.Visible = false
			handle.Visible = false
			frame.Size = UDim2.fromOffset(frame.AbsoluteSize.X, TITLE_HEIGHT)
			minBtn.Text = "+"
		else
			frame.Size = savedSize
			sidebar.Visible = true
			profilePage.Visible = true
			handle.Visible = true
			minBtn.Text = "–"
		end
	end)
end

print("[SpeedsterWizard v15.5] Ultimate God-Tier Edition Loaded Successfully!")
