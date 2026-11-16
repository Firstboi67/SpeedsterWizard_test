--[================================================================]--
--  SpeedsterWizard v31.0 (Advanced Client Suite & Resizable Hub)  --
--[================================================================]--

local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local MarketplaceService = game:GetService("MarketplaceService")
local Stats = game:GetService("Stats")
local RunService = game:GetService("RunService")
local CoreGui = game:GetService("CoreGui")
local Lighting = game:GetService("Lighting")
local Workspace = game:GetService("Workspace")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Camera = Workspace.CurrentCamera

local player = Players.LocalPlayer
while not player do
	player = Players.LocalPlayer
	task.wait(0.1)
end

print("[SpeedsterWizard v31.0] Initializing Advanced Resizable Hub for:", player.Name)

-- Secure GUI Container Selection
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

if guiParent:FindFirstChild("SpeedsterWizardEliteHub") then
	guiParent.SpeedsterWizardEliteHub:Destroy()
end

-- Main ScreenGui
local gui = Instance.new("ScreenGui")
gui.Name = "SpeedsterWizardEliteHub"
gui.ResetOnSpawn = false
gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
gui.DisplayOrder = 999999
gui.Parent = guiParent

-- ================================================================= --
--  TOAST NOTIFICATION SYSTEM                                        --
-- ================================================================= --
local function sendNotification(title, message)
	task.spawn(function()
		local toast = Instance.new("Frame")
		toast.Size = UDim2.fromOffset(240, 50)
		toast.Position = UDim2.new(1, 10, 0, 40)
		toast.BackgroundColor3 = Color3.fromRGB(20, 24, 33)
		toast.BorderSizePixel = 0
		toast.ZIndex = 99999
		toast.Parent = gui
		Instance.new("UICorner", toast).CornerRadius = UDim.new(0, 8)
		local tStroke = Instance.new("UIStroke")
		tStroke.Color = Color3.fromRGB(99, 102, 241)
		tStroke.Thickness = 1.5
		tStroke.Parent = toast

		local tTitle = Instance.new("TextLabel")
		tTitle.Size = UDim2.new(1, -12, 0, 20)
		tTitle.Position = UDim2.fromOffset(8, 4)
		tTitle.BackgroundTransparency = 1
		tTitle.Text = title
		tTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
		tTitle.Font = Enum.Font.GothamBold
		tTitle.TextSize = 11
		tTitle.TextXAlignment = Enum.TextXAlignment.Left
		tTitle.ZIndex = 100000
		tTitle.Parent = toast

		local tMsg = Instance.new("TextLabel")
		tMsg.Size = UDim2.new(1, -12, 0, 20)
		tMsg.Position = UDim2.fromOffset(8, 24)
		tMsg.BackgroundTransparency = 1
		tMsg.Text = message
		tMsg.TextColor3 = Color3.fromRGB(180, 190, 205)
		tMsg.Font = Enum.Font.GothamMedium
		tMsg.TextSize = 10
		tMsg.TextXAlignment = Enum.TextXAlignment.Left
		tMsg.ZIndex = 100000
		tMsg.Parent = toast

		toast:TweenPosition(UDim2.new(1, -255, 0, 40), Enum.EasingDirection.Out, Enum.EasingStyle.Quad, 0.25, true)
		task.wait(2.5)
		toast:TweenPosition(UDim2.new(1, 10, 0, 40), Enum.EasingDirection.In, Enum.EasingStyle.Quad, 0.25, true)
		task.wait(0.3)
		toast:Destroy()
	end)
end

-- ================================================================= --
--  EXPANDED THEME PALETTES                                          --
-- ================================================================= --
local themes = {
	Cyber = {
		Name = "Cyber Minimalist",
		Main = Color3.fromRGB(16, 20, 26),
		Card = Color3.fromRGB(24, 30, 38),
		Stroke = Color3.fromRGB(45, 55, 72),
		Accent = Color3.fromRGB(99, 102, 241),
		Text = Color3.fromRGB(243, 244, 246),
		Sidebar = Color3.fromRGB(11, 15, 20),
		Header = Color3.fromRGB(20, 25, 32)
	},
	Lightning = {
		Name = "Yellow Lightning",
		Main = Color3.fromRGB(20, 20, 12),
		Card = Color3.fromRGB(30, 30, 18),
		Stroke = Color3.fromRGB(60, 60, 30),
		Accent = Color3.fromRGB(234, 179, 8),
		Text = Color3.fromRGB(254, 249, 195),
		Sidebar = Color3.fromRGB(14, 14, 8),
		Header = Color3.fromRGB(25, 25, 14)
	},
	Ice = {
		Name = "Blue Ice",
		Main = Color3.fromRGB(10, 18, 28),
		Card = Color3.fromRGB(15, 26, 40),
		Stroke = Color3.fromRGB(30, 50, 75),
		Accent = Color3.fromRGB(14, 165, 233),
		Text = Color3.fromRGB(224, 242, 254),
		Sidebar = Color3.fromRGB(7, 12, 20),
		Header = Color3.fromRGB(12, 21, 34)
	},
	Crimson = {
		Name = "Crimson Neon",
		Main = Color3.fromRGB(22, 12, 14),
		Card = Color3.fromRGB(34, 18, 22),
		Stroke = Color3.fromRGB(90, 30, 40),
		Accent = Color3.fromRGB(255, 59, 92),
		Text = Color3.fromRGB(255, 240, 243),
		Sidebar = Color3.fromRGB(14, 7, 9),
		Header = Color3.fromRGB(28, 14, 18)
	},
	Emerald = {
		Name = "Emerald Matrix",
		Main = Color3.fromRGB(10, 22, 16),
		Card = Color3.fromRGB(16, 34, 24),
		Stroke = Color3.fromRGB(30, 80, 50),
		Accent = Color3.fromRGB(16, 185, 129),
		Text = Color3.fromRGB(236, 253, 245),
		Sidebar = Color3.fromRGB(7, 15, 11),
		Header = Color3.fromRGB(13, 27, 19)
	},
	Sunset = {
		Name = "Sunset Cyberpunk",
		Main = Color3.fromRGB(26, 14, 24),
		Card = Color3.fromRGB(38, 20, 36),
		Stroke = Color3.fromRGB(90, 45, 80),
		Accent = Color3.fromRGB(236, 72, 153),
		Text = Color3.fromRGB(253, 242, 248),
		Sidebar = Color3.fromRGB(17, 9, 16),
		Header = Color3.fromRGB(31, 16, 29)
	},
	Amethyst = {
		Name = "Deep Amethyst",
		Main = Color3.fromRGB(18, 14, 28),
		Card = Color3.fromRGB(26, 20, 40),
		Stroke = Color3.fromRGB(60, 45, 95),
		Accent = Color3.fromRGB(168, 85, 247),
		Text = Color3.fromRGB(243, 232, 255),
		Sidebar = Color3.fromRGB(12, 9, 19),
		Header = Color3.fromRGB(21, 16, 33)
	}
}

local currentThemeKey = "Cyber"
local t = themes[currentThemeKey]
local isInfJumpEnabled = false
local isPlayerEspEnabled = false
local isRemoteSpyActive = false
local savedTpPosition = nil

-- Character ESP Highlight Logic
local function updateCharacterAura()
	local char = player.Character
	if not char then return end
	local existingHighlight = char:FindFirstChild("SpeedsterClientAura")
	
	if isPlayerEspEnabled then
		if not existingHighlight then
			local highlight = Instance.new("Highlight")
			highlight.Name = "SpeedsterClientAura"
			highlight.Adornee = char
			highlight.FillColor = t.Accent
			highlight.FillTransparency = 0.5
			highlight.OutlineColor = t.Accent
			highlight.OutlineTransparency = 0
			highlight.Parent = char
		else
			existingHighlight.FillColor = t.Accent
			existingHighlight.OutlineColor = t.Accent
		end
	else
		if existingHighlight then
			existingHighlight:Destroy()
		end
	end
end

player.CharacterAdded:Connect(function(newChar)
	task.wait(1)
	updateCharacterAura()
end)

UserInputService.JumpRequest:Connect(function()
	if isInfJumpEnabled then
		local char = player.Character
		if char and char:FindFirstChildOfClass("Humanoid") then
			char:FindFirstChildOfClass("Humanoid"):ChangeState(Enum.HumanoidStateType.Jumping)
		end
	end
end)

-- Floating Toggle Button
local toggleBtn = Instance.new("TextButton")
toggleBtn.Size = UDim2.fromOffset(48, 48)
toggleBtn.Position = UDim2.new(0, 25, 0.5, -24)
toggleBtn.BackgroundColor3 = t.Main
toggleBtn.TextColor3 = t.Accent
toggleBtn.Text = "⚡"
toggleBtn.Font = Enum.Font.GothamBold
toggleBtn.TextSize = 22
toggleBtn.ZIndex = 9999
toggleBtn.Parent = gui

Instance.new("UICorner", toggleBtn).CornerRadius = UDim.new(0, 12)
local toggleStroke = Instance.new("UIStroke")
toggleStroke.Color = t.Stroke
toggleStroke.Thickness = 1.5
toggleStroke.Parent = toggleBtn

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

local TITLE_HEIGHT = 38
local SIDEBAR_WIDTH = 130
local MIN_W, MIN_H = 500, 340
local MAX_W, MAX_H = 950, 700
local isFullyLoaded = false
local joinTick = tick()

-- Loading Screen
local loadFrame = Instance.new("Frame")
loadFrame.Size = UDim2.fromOffset(360, 150)
loadFrame.Position = UDim2.new(0.5, -180, 0.5, -75)
loadFrame.BackgroundColor3 = t.Main
loadFrame.BorderSizePixel = 0
loadFrame.ZIndex = 100
loadFrame.Parent = gui

Instance.new("UICorner", loadFrame).CornerRadius = UDim.new(0, 12)
local loadStroke = Instance.new("UIStroke")
loadStroke.Color = t.Stroke
loadStroke.Thickness = 1.5
loadStroke.Parent = loadFrame

local loadTitle = Instance.new("TextLabel")
loadTitle.Size = UDim2.new(1, 0, 0, 45)
loadTitle.BackgroundTransparency = 1
loadTitle.Text = string.format("⚡ Initializing Suite v31.0, %s...", player.DisplayName or "Wizard")
loadTitle.TextColor3 = t.Text
loadTitle.Font = Enum.Font.GothamBold
loadTitle.TextSize = 13
loadTitle.ZIndex = 101
loadTitle.Parent = loadFrame

local percentLabel = Instance.new("TextLabel")
percentLabel.Size = UDim2.new(1, 0, 0, 25)
percentLabel.Position = UDim2.new(0, 0, 0, 45)
percentLabel.BackgroundTransparency = 1
percentLabel.Text = "0%"
percentLabel.TextColor3 = t.Accent
percentLabel.Font = Enum.Font.GothamBold
percentLabel.TextSize = 18
percentLabel.ZIndex = 101
percentLabel.Parent = loadFrame

local barBg = Instance.new("Frame")
barBg.Size = UDim2.new(1, -60, 0, 6)
barBg.Position = UDim2.new(0, 30, 0, 95)
barBg.BackgroundColor3 = t.Card
barBg.BorderSizePixel = 0
barBg.ZIndex = 101
barBg.Parent = loadFrame
Instance.new("UICorner", barBg).CornerRadius = UDim.new(1, 0)

local barFill = Instance.new("Frame")
barFill.Size = UDim2.new(0, 0, 1, 0)
barFill.BackgroundColor3 = t.Accent
barFill.BorderSizePixel = 0
barFill.ZIndex = 102
barFill.Parent = barBg
Instance.new("UICorner", barFill).CornerRadius = UDim.new(1, 0)

task.spawn(function()
	for i = 1, 100 do
		percentLabel.Text = i .. "%"
		barFill.Size = UDim2.new(i / 100, 0, 1, 0)
		task.wait(0.01)
	end
	loadTitle.Text = "✨ SpeedsterWizard v31.0 Ready!"
	task.wait(0.3)
	loadFrame:Destroy()
	isFullyLoaded = true
end)

-- Main Frame (Resizable)
local frame = Instance.new("Frame")
frame.Size = UDim2.fromOffset(580, 390)
frame.Position = UDim2.new(0.5, -290, 0.5, -195)
frame.BackgroundColor3 = t.Main
frame.BackgroundTransparency = 0.04
frame.BorderSizePixel = 0
frame.Visible = false
frame.Parent = gui

Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 12)

local mainStroke = Instance.new("UIStroke")
mainStroke.Name = "MainStroke"
mainStroke.Color = t.Stroke
mainStroke.Thickness = 1.5
mainStroke.Parent = frame

-- Title Bar
local titleBar = Instance.new("Frame")
titleBar.Size = UDim2.new(1, 0, 0, TITLE_HEIGHT)
titleBar.BackgroundColor3 = t.Header
titleBar.BorderSizePixel = 0
titleBar.Parent = frame

Instance.new("UICorner", titleBar).CornerRadius = UDim.new(0, 12)
local titleCover = Instance.new("Frame")
titleCover.Size = UDim2.new(1, 0, 0, 8)
titleCover.Position = UDim2.new(0, 0, 1, -8)
titleCover.BackgroundColor3 = t.Header
titleCover.BorderSizePixel = 0
titleCover.Parent = titleBar

local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, -60, 1, 0)
title.Position = UDim2.fromOffset(14, 0)
title.BackgroundTransparency = 1
title.Text = "⚡ SPEEDSTER WIZARD  <font color='#6366f1'>v31.0</font>"
title.RichText = true
title.TextColor3 = t.Text
title.Font = Enum.Font.GothamBold
title.TextSize = 12
title.TextXAlignment = Enum.TextXAlignment.Left
title.Parent = titleBar

local minBtn = Instance.new("TextButton")
minBtn.Size = UDim2.fromOffset(26, 20)
minBtn.Position = UDim2.new(1, -32, 0, 9)
minBtn.Text = "–"
minBtn.BackgroundColor3 = t.Card
minBtn.TextColor3 = t.Text
minBtn.Font = Enum.Font.GothamBold
minBtn.TextSize = 14
minBtn.AutoButtonColor = false
minBtn.Parent = titleBar
Instance.new("UICorner", minBtn).CornerRadius = UDim.new(0, 6)

-- Sidebar Navigation
local sidebar = Instance.new("Frame")
sidebar.Size = UDim2.new(0, SIDEBAR_WIDTH, 1, -TITLE_HEIGHT)
sidebar.Position = UDim2.fromOffset(0, TITLE_HEIGHT)
sidebar.BackgroundColor3 = t.Sidebar
sidebar.BorderSizePixel = 0
sidebar.Parent = frame

local sidebarLayout = Instance.new("UIListLayout")
sidebarLayout.Padding = UDim.new(0, 6)
sidebarLayout.SortOrder = Enum.SortOrder.LayoutOrder
sidebarLayout.Parent = sidebar

local sidebarPadding = Instance.new("UIPadding")
sidebarPadding.PaddingTop = UDim.new(0, 12)
sidebarPadding.PaddingLeft = UDim.new(0, 10)
sidebarPadding.PaddingRight = UDim.new(0, 10)
sidebarPadding.Parent = sidebar

local function createSidebarBtn(name, order)
	local btn = Instance.new("TextButton")
	btn.Size = UDim2.new(1, 0, 0, 36)
	btn.BackgroundColor3 = t.Card
	btn.TextColor3 = t.Text
	btn.Text = name
	btn.Font = Enum.Font.GothamBold
	btn.TextSize = 11
	btn.AutoButtonColor = false
	btn.LayoutOrder = order
	btn.Parent = sidebar
	Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 8)
	return btn
end

local profileTabBtn = createSidebarBtn("👤 Profile", 1)
local scriptTabBtn = createSidebarBtn("📜 Script", 2)
local aiTabBtn = createSidebarBtn("🤖 AI Chatbot", 3)
local visualsTabBtn = createSidebarBtn("👁️ Visuals", 4)
local tpTabBtn = createSidebarBtn("⚡ Teleport", 5)
local remoteTabBtn = createSidebarBtn("🌐 Remote Hub & Spy", 6)
local settingsTabBtn = createSidebarBtn("⚙️ Settings", 7)

-- Content Area
local content = Instance.new("Frame")
content.Size = UDim2.new(1, -SIDEBAR_WIDTH, 1, -TITLE_HEIGHT)
content.Position = UDim2.fromOffset(SIDEBAR_WIDTH, TITLE_HEIGHT)
content.BackgroundTransparency = 1
content.ClipsDescendants = true
content.Parent = frame

local function applyPaddingAndLayout(parent)
	local l = Instance.new("UIListLayout")
	l.Padding = UDim.new(0, 10)
	l.SortOrder = Enum.SortOrder.LayoutOrder
	l.Parent = parent

	local p = Instance.new("UIPadding")
	p.PaddingTop = UDim.new(0, 12)
	p.PaddingBottom = UDim.new(0, 12)
	p.PaddingLeft = UDim.new(0, 12)
	p.PaddingRight = UDim.new(0, 12)
	p.Parent = parent
end

local function createCard(parent, order, height)
	local card = Instance.new("Frame")
	card.Size = UDim2.new(1, 0, 0, height)
	card.BackgroundColor3 = t.Card
	card.BorderSizePixel = 0
	card.LayoutOrder = order
	card.Parent = parent
	Instance.new("UICorner", card).CornerRadius = UDim.new(0, 8)
	local stroke = Instance.new("UIStroke")
	stroke.Color = t.Stroke
	stroke.Thickness = 1
	stroke.Transparency = 0.4
	stroke.Parent = card
	return card, stroke
end

local function createActionButton(parent, text, yPos, color)
	local btn = Instance.new("TextButton")
	btn.Size = UDim2.new(1, -20, 0, 30)
	btn.Position = UDim2.fromOffset(10, yPos)
	btn.BackgroundColor3 = color
	btn.TextColor3 = t.Text
	btn.Text = text
	btn.Font = Enum.Font.GothamBold
	btn.TextSize = 11
	btn.Parent = parent
	Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 6)
	return btn
end

-- Tab 1: Profile
local profilePage = Instance.new("ScrollingFrame")
profilePage.Size = UDim2.new(1, 0, 1, 0)
profilePage.BackgroundTransparency = 1
profilePage.BorderSizePixel = 0
profilePage.CanvasSize = UDim2.new(0, 0, 0, 240)
profilePage.ScrollBarThickness = 3
profilePage.Visible = true
profilePage.Parent = content

applyPaddingAndLayout(profilePage)

local profileCard = createCard(profilePage, 1, 75)
local avatarImg = Instance.new("ImageLabel")
avatarImg.Size = UDim2.fromOffset(56, 56)
avatarImg.Position = UDim2.new(0, 10, 0, 9)
avatarImg.BackgroundTransparency = 1
pcall(function()
	avatarImg.Image = Players:GetUserThumbnailAsync(player.UserId, Enum.ThumbnailType.HeadShot, Enum.ThumbnailSize.Size48x48)
end)
avatarImg.Parent = profileCard
Instance.new("UICorner", avatarImg).CornerRadius = UDim.new(1, 0)

local nameLabel = Instance.new("TextLabel")
nameLabel.Size = UDim2.new(1, -76, 1, 0)
nameLabel.Position = UDim2.fromOffset(74, 0)
nameLabel.BackgroundTransparency = 1
nameLabel.Text = string.format("👤 %s\n🏷️ @%s\n🆔 ID: %d", player.DisplayName, player.Name, player.UserId)
nameLabel.TextColor3 = t.Text
nameLabel.Font = Enum.Font.GothamBold
nameLabel.TextSize = 11
nameLabel.TextXAlignment = Enum.TextXAlignment.Left
nameLabel.Parent = profileCard

local statsCard = createCard(profilePage, 2, 65)
local statsInfoLabel = Instance.new("TextLabel")
statsInfoLabel.Size = UDim2.new(1, -16, 1, 0)
statsInfoLabel.Position = UDim2.fromOffset(8, 0)
statsInfoLabel.BackgroundTransparency = 1
statsInfoLabel.Text = "🎮 Game: Loading...\n⏳ Playtime: 00:00:00"
statsInfoLabel.TextColor3 = t.Text
statsInfoLabel.Font = Enum.Font.GothamMedium
statsInfoLabel.TextSize = 11
statsInfoLabel.TextXAlignment = Enum.TextXAlignment.Left
statsInfoLabel.Parent = statsCard

local perfCard = createCard(profilePage, 3, 60)
local perfLabel = Instance.new("TextLabel")
perfLabel.Size = UDim2.new(1, -16, 1, 0)
perfLabel.Position = UDim2.fromOffset(8, 0)
perfLabel.BackgroundTransparency = 1
perfLabel.Text = "⚡ FPS: -- | Ping: -- ms\n🟢 Suite v31.0: Active"
perfLabel.TextColor3 = t.Text
perfLabel.Font = Enum.Font.GothamMedium
perfLabel.TextSize = 11
perfLabel.TextXAlignment = Enum.TextXAlignment.Left
perfLabel.Parent = perfCard

-- Tab 2: Script / Movement
local scriptPage = Instance.new("ScrollingFrame")
scriptPage.Size = UDim2.new(1, 0, 1, 0)
scriptPage.BackgroundTransparency = 1
scriptPage.BorderSizePixel = 0
scriptPage.CanvasSize = UDim2.new(0, 0, 0, 420)
scriptPage.ScrollBarThickness = 3
scriptPage.Visible = false
scriptPage.Parent = content

applyPaddingAndLayout(scriptPage)

local syncCard = createCard(scriptPage, 1, 160)
local syncTitle = Instance.new("TextLabel")
syncTitle.Size = UDim2.new(1, -20, 0, 22)
syncTitle.Position = UDim2.fromOffset(10, 8)
syncTitle.BackgroundTransparency = 1
syncTitle.Text = "📊 Real-Time Leaderstats Sync"
syncTitle.TextColor3 = t.Text
syncTitle.Font = Enum.Font.GothamBold
syncTitle.TextSize = 11
syncTitle.TextXAlignment = Enum.TextXAlignment.Left
syncTitle.Parent = syncCard

local syncInfo = Instance.new("TextLabel")
syncInfo.Size = UDim2.new(1, -20, 0, 80)
syncInfo.Position = UDim2.fromOffset(10, 34)
syncInfo.BackgroundTransparency = 1
syncInfo.Text = "Scanning leaderstats...\n[Waiting for game connection...]"
syncInfo.TextColor3 = t.Accent
syncInfo.Font = Enum.Font.GothamMedium
syncInfo.TextSize = 10
syncInfo.TextXAlignment = Enum.TextXAlignment.Left
syncInfo.TextYAlignment = Enum.TextYAlignment.Top
syncInfo.Parent = syncCard

local movementCard = createCard(scriptPage, 2, 175)
local movTitle = Instance.new("TextLabel")
movTitle.Size = UDim2.new(1, -20, 0, 22)
movTitle.Position = UDim2.fromOffset(10, 8)
movTitle.BackgroundTransparency = 1
movTitle.Text = "⚡ Custom Movement Controls"
movTitle.TextColor3 = t.Text
movTitle.Font = Enum.Font.GothamBold
movTitle.TextSize = 11
movTitle.TextXAlignment = Enum.TextXAlignment.Left
movTitle.Parent = movementCard

local speedLbl = Instance.new("TextLabel")
speedLbl.Size = UDim2.new(1, -20, 0, 18)
speedLbl.Position = UDim2.fromOffset(10, 34)
speedLbl.BackgroundTransparency = 1
speedLbl.Text = "WalkSpeed Modifier:"
speedLbl.TextColor3 = t.Text
speedLbl.Font = Enum.Font.GothamMedium
speedLbl.TextSize = 10
speedLbl.TextXAlignment = Enum.TextXAlignment.Left
speedLbl.Parent = movementCard

local speedBox = Instance.new("TextBox")
speedBox.Size = UDim2.new(1, -20, 0, 26)
speedBox.Position = UDim2.fromOffset(10, 54)
speedBox.BackgroundColor3 = t.Header
speedBox.TextColor3 = t.Text
speedBox.Text = "16"
speedBox.Font = Enum.Font.GothamBold
speedBox.TextSize = 11
speedBox.Parent = movementCard
Instance.new("UICorner", speedBox).CornerRadius = UDim.new(0, 6)

speedBox.FocusLost:Connect(function(enter)
	if enter then
		local val = tonumber(speedBox.Text)
		if val then
			local char = player.Character
			if char and char:FindFirstChildOfClass("Humanoid") then
				char:FindFirstChildOfClass("Humanoid").WalkSpeed = val
				sendNotification("Movement", "WalkSpeed set to " .. val)
			end
		end
	end
end)

local jumpLbl = Instance.new("TextLabel")
jumpLbl.Size = UDim2.new(1, -20, 0, 18)
jumpLbl.Position = UDim2.fromOffset(10, 88)
jumpLbl.BackgroundTransparency = 1
jumpLbl.Text = "JumpPower Modifier:"
jumpLbl.TextColor3 = t.Text
jumpLbl.Font = Enum.Font.GothamMedium
jumpLbl.TextSize = 10
jumpLbl.TextXAlignment = Enum.TextXAlignment.Left
jumpLbl.Parent = movementCard

local jumpBox = Instance.new("TextBox")
jumpBox.Size = UDim2.new(1, -20, 0, 26)
jumpBox.Position = UDim2.fromOffset(10, 108)
jumpBox.BackgroundColor3 = t.Header
jumpBox.TextColor3 = t.Text
jumpBox.Text = "50"
jumpBox.Font = Enum.Font.GothamBold
jumpBox.TextSize = 11
jumpBox.Parent = movementCard
Instance.new("UICorner", jumpBox).CornerRadius = UDim.new(0, 6)

jumpBox.FocusLost:Connect(function(enter)
	if enter then
		local val = tonumber(jumpBox.Text)
		if val then
			local char = player.Character
			if char and char:FindFirstChildOfClass("Humanoid") then
				local hum = char:FindFirstChildOfClass("Humanoid")
				pcall(function() hum.UseJumpPower = true end)
				hum.JumpPower = val
				sendNotification("Movement", "JumpPower set to " .. val)
			end
		end
	end
end)

local infJumpBtn = createActionButton(movementCard, "🦘 Infinite Jump: OFF", 140, Color3.fromRGB(50, 50, 60))
infJumpBtn.MouseButton1Click:Connect(function()
	isInfJumpEnabled = not isInfJumpEnabled
	if isInfJumpEnabled then
		infJumpBtn.Text = "🦘 Infinite Jump: ON"
		infJumpBtn.BackgroundColor3 = Color3.fromRGB(34, 197, 94)
		sendNotification("Ability Active", "Infinite Jump Enabled")
	else
		infJumpBtn.Text = "🦘 Infinite Jump: OFF"
		infJumpBtn.BackgroundColor3 = Color3.fromRGB(50, 50, 60)
		sendNotification("Ability Off", "Infinite Jump Disabled")
	end
end)

-- Tab 3: AI Chatbot
local aiPage = Instance.new("ScrollingFrame")
aiPage.Size = UDim2.new(1, 0, 1, 0)
aiPage.BackgroundTransparency = 1
aiPage.BorderSizePixel = 0
aiPage.CanvasSize = UDim2.new(0, 0, 0, 340)
aiPage.ScrollBarThickness = 3
aiPage.Visible = false
aiPage.Parent = content

applyPaddingAndLayout(aiPage)

local aiCard = createCard(aiPage, 1, 310)
local aiHeader = Instance.new("TextLabel")
aiHeader.Size = UDim2.new(1, -20, 0, 24)
aiHeader.Position = UDim2.fromOffset(10, 8)
aiHeader.BackgroundTransparency = 1
aiHeader.Text = "🤖 Advanced AI Companion"
aiHeader.TextColor3 = t.Text
aiHeader.Font = Enum.Font.GothamBold
aiHeader.TextSize = 11
aiHeader.TextXAlignment = Enum.TextXAlignment.Left
aiHeader.Parent = aiCard

local aiOutput = Instance.new("TextLabel")
aiOutput.Size = UDim2.new(1, -20, 0, 160)
aiOutput.Position = UDim2.fromOffset(10, 36)
aiOutput.BackgroundColor3 = t.Main
aiOutput.TextColor3 = t.Accent
aiOutput.Text = "AI: Greetings " .. player.DisplayName .. "! Ready for inspection and resizable hub tools."
aiOutput.Font = Enum.Font.GothamMedium
aiOutput.TextSize = 10
aiOutput.TextXAlignment = Enum.TextXAlignment.Left
aiOutput.TextYAlignment = Enum.TextYAlignment.Top
aiOutput.TextWrapped = true
aiOutput.Parent = aiCard
Instance.new("UICorner", aiOutput).CornerRadius = UDim.new(0, 6)

local aiInput = Instance.new("TextBox")
aiInput.Size = UDim2.new(1, -20, 0, 30)
aiInput.Position = UDim2.fromOffset(10, 204)
aiInput.BackgroundColor3 = t.Header
aiInput.TextColor3 = t.Text
aiInput.PlaceholderText = "Talk to AI..."
aiInput.Text = ""
aiInput.Font = Enum.Font.GothamMedium
aiInput.TextSize = 11
aiInput.Parent = aiCard
Instance.new("UICorner", aiInput).CornerRadius = UDim.new(0, 6)

local aiSendBtn = createActionButton(aiCard, "💬 Send Message", 244, t.Header)
aiSendBtn.MouseButton1Click:Connect(function()
	local msg = aiInput.Text
	if msg == "" then return end
	aiOutput.Text = string.format("You: %s\n\nAI: Systems nominal. Window is fully resizable from the bottom-right corner!", msg)
	sendNotification("AI Chat", "AI replied to your message!")
	aiInput.Text = ""
end)

-- Tab 4: Visuals
local visualsPage = Instance.new("ScrollingFrame")
visualsPage.Size = UDim2.new(1, 0, 1, 0)
visualsPage.BackgroundTransparency = 1
visualsPage.BorderSizePixel = 0
visualsPage.CanvasSize = UDim2.new(0, 0, 0, 300)
visualsPage.ScrollBarThickness = 3
visualsPage.Visible = false
visualsPage.Parent = content

applyPaddingAndLayout(visualsPage)

local espCard = createCard(visualsPage, 1, 90)
local espTitle = Instance.new("TextLabel")
espTitle.Size = UDim2.new(1, -20, 0, 24)
espTitle.Position = UDim2.fromOffset(10, 8)
espTitle.BackgroundTransparency = 1
espTitle.Text = "👥 Player ESP & Target Glow"
espTitle.TextColor3 = t.Text
espTitle.Font = Enum.Font.GothamBold
espTitle.TextSize = 11
espTitle.TextXAlignment = Enum.TextXAlignment.Left
espTitle.Parent = espCard

local espToggleBtn = createActionButton(espCard, "👁️ Player ESP: OFF", 36, Color3.fromRGB(50, 50, 60))
espToggleBtn.MouseButton1Click:Connect(function()
	isPlayerEspEnabled = not isPlayerEspEnabled
	if isPlayerEspEnabled then
		espToggleBtn.Text = "👁️ Player ESP: ON"
		espToggleBtn.BackgroundColor3 = t.Accent
		sendNotification("ESP Active", "Player ESP Enabled!")
	else
		espToggleBtn.Text = "👁️ Player ESP: OFF"
		espToggleBtn.BackgroundColor3 = Color3.fromRGB(50, 50, 60)
		sendNotification("ESP Off", "Player ESP Disabled")
	end
	updateCharacterAura()
end)

local nightCard = createCard(visualsPage, 2, 90)
local nightTitle = Instance.new("TextLabel")
nightTitle.Size = UDim2.new(1, -20, 0, 24)
nightTitle.Position = UDim2.fromOffset(10, 8)
nightTitle.BackgroundTransparency = 1
nightTitle.Text = "🌙 Full Bright / Night Vision"
nightTitle.TextColor3 = t.Text
nightTitle.Font = Enum.Font.GothamBold
nightTitle.TextSize = 11
nightTitle.TextXAlignment = Enum.TextXAlignment.Left
nightTitle.Parent = nightCard

local nightToggleBtn = createActionButton(nightCard, "💡 Full Bright Mode: OFF", 36, Color3.fromRGB(50, 50, 60))
nightToggleBtn.MouseButton1Click:Connect(function()
	Lighting.Brightness = 2
	Lighting.ClockTime = 14
	Lighting.GlobalShadows = false
	sendNotification("Visuals", "Full Bright Enabled")
end)

-- Tab 5: Teleport
local tpPage = Instance.new("ScrollingFrame")
tpPage.Size = UDim2.new(1, 0, 1, 0)
tpPage.BackgroundTransparency = 1
tpPage.BorderSizePixel = 0
tpPage.CanvasSize = UDim2.new(0, 0, 0, 200)
tpPage.ScrollBarThickness = 3
tpPage.Visible = false
tpPage.Parent = content

applyPaddingAndLayout(tpPage)

local tpCard = createCard(tpPage, 1, 150)
local tpTitle = Instance.new("TextLabel")
tpTitle.Size = UDim2.new(1, -20, 0, 25)
tpTitle.Position = UDim2.fromOffset(10, 8)
tpTitle.BackgroundTransparency = 1
tpTitle.Text = "⚡ Client Teleport Tools"
tpTitle.TextColor3 = t.Text
tpTitle.Font = Enum.Font.GothamBold
tpTitle.TextSize = 12
tpTitle.TextXAlignment = Enum.TextXAlignment.Left
tpTitle.Parent = tpCard

local savePosBtn = createActionButton(tpCard, "📍 Save Current Position", 38, t.Header)
savePosBtn.MouseButton1Click:Connect(function()
	local char = player.Character
	if char and char:FindFirstChild("HumanoidRootPart") then
		savedTpPosition = char.HumanoidRootPart.CFrame
		sendNotification("Teleport", "Position Saved Successfully!")
	end
end)

local loadPosBtn = createActionButton(tpCard, "🚀 Teleport to Saved Position", 74, t.Accent)
loadPosBtn.MouseButton1Click:Connect(function()
	local char = player.Character
	if char and char:FindFirstChild("HumanoidRootPart") and savedTpPosition then
		char.HumanoidRootPart.CFrame = savedTpPosition
		sendNotification("Teleport", "Teleported to Saved Position!")
	else
		sendNotification("Teleport Error", "No position saved yet!")
	end
end)

-- Tab 6: Remote Hub & Spy
local remotePage = Instance.new("ScrollingFrame")
remotePage.Size = UDim2.new(1, 0, 1, 0)
remotePage.BackgroundTransparency = 1
remotePage.BorderSizePixel = 0
remotePage.CanvasSize = UDim2.new(0, 0, 0, 420)
remotePage.ScrollBarThickness = 3
remotePage.Visible = false
remotePage.Parent = content

applyPaddingAndLayout(remotePage)

local remoteCard = createCard(remotePage, 1, 395)
local remoteTitle = Instance.new("TextLabel")
remoteTitle.Size = UDim2.new(1, -20, 0, 24)
remoteTitle.Position = UDim2.fromOffset(10, 8)
remoteTitle.BackgroundTransparency = 1
remoteTitle.Text = "🌐 Remote Spy & Packet Logger"
remoteTitle.TextColor3 = t.Text
remoteTitle.Font = Enum.Font.GothamBold
remoteTitle.TextSize = 11
remoteTitle.TextXAlignment = Enum.TextXAlignment.Left
remoteTitle.Parent = remoteCard

local selectedRemoteLabel = Instance.new("TextLabel")
selectedRemoteLabel.Size = UDim2.new(1, -20, 0, 20)
selectedRemoteLabel.Position = UDim2.fromOffset(10, 34)
selectedRemoteLabel.BackgroundTransparency = 1
selectedRemoteLabel.Text = "Spy Status: Inactive"
selectedRemoteLabel.TextColor3 = t.Accent
selectedRemoteLabel.Font = Enum.Font.GothamMedium
selectedRemoteLabel.TextSize = 10
selectedRemoteLabel.TextXAlignment = Enum.TextXAlignment.Left
selectedRemoteLabel.Parent = remoteCard

local spyLogList = Instance.new("ScrollingFrame")
spyLogList.Size = UDim2.new(1, -20, 0, 140)
spyLogList.Position = UDim2.fromOffset(10, 58)
spyLogList.BackgroundColor3 = t.Main
spyLogList.BorderSizePixel = 0
spyLogList.ScrollBarThickness = 3
spyLogList.Parent = remoteCard
Instance.new("UICorner", spyLogList).CornerRadius = UDim.new(0, 6)

local spyListLayout = Instance.new("UIListLayout")
spyListLayout.Padding = UDim.new(0, 4)
spyListLayout.Parent = spyLogList

local remoteInput = Instance.new("TextBox")
remoteInput.Size = UDim2.new(1, -20, 0, 26)
remoteInput.Position = UDim2.fromOffset(10, 206)
remoteInput.BackgroundColor3 = t.Header
remoteInput.TextColor3 = t.Text
remoteInput.PlaceholderText = "Custom payload data..."
remoteInput.Text = '{"message": "Hello from Remote Spy!"}'
remoteInput.Font = Enum.Font.GothamMedium
remoteInput.TextSize = 10
remoteInput.Parent = remoteCard
Instance.new("UICorner", remoteInput).CornerRadius = UDim.new(0, 6)

local remoteOutput = Instance.new("TextLabel")
remoteOutput.Size = UDim2.new(1, -20, 0, 80)
remoteOutput.Position = UDim2.fromOffset(10, 238)
remoteOutput.BackgroundColor3 = t.Main
remoteOutput.TextColor3 = t.Accent
remoteOutput.Text = "Captured packet details will appear here..."
remoteOutput.Font = Enum.Font.GothamMedium
remoteOutput.TextSize = 10
remoteOutput.TextXAlignment = Enum.TextXAlignment.Left
remoteOutput.TextYAlignment = Enum.TextYAlignment.Top
remoteOutput.TextWrapped = true
remoteOutput.Parent = remoteCard
Instance.new("UICorner", remoteOutput).CornerRadius = UDim.new(0, 6)

local activeSpyTarget = nil

local function addSpyLog(remoteObj, callType, argsSummary)
	local btn = Instance.new("TextButton")
	btn.Size = UDim2.new(1, -6, 0, 26)
	btn.BackgroundColor3 = t.Header
	btn.TextColor3 = t.Text
	btn.Text = string.format(" [%s] %s -> %s", callType, remoteObj.Name, argsSummary)
	btn.Font = Enum.Font.GothamMedium
	btn.TextSize = 10
	btn.TextXAlignment = Enum.TextXAlignment.Left
	btn.Parent = spyLogList
	Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 4)
	
	btn.MouseButton1Click:Connect(function()
		activeSpyTarget = remoteObj
		selectedRemoteLabel.Text = "Locked Target: " .. remoteObj.Name
		remoteOutput.Text = string.format("Target Selected: %s\nPath: %s\nType: %s", remoteObj.Name, remoteObj:GetFullName(), remoteObj.ClassName)
		sendNotification("Spy Locked", "Target set to " .. remoteObj.Name)
	end)
	
	local count = #spyLogList:GetChildren() - 1
	spyLogList.CanvasSize = UDim2.new(0, 0, 0, count * 30)
end

local spyToggleBtn = createActionButton(remoteCard, "👁️ Toggle Remote Spy: OFF", 324, Color3.fromRGB(50, 50, 60))
spyToggleBtn.MouseButton1Click:Connect(function()
	isRemoteSpyActive = not isRemoteSpyActive
	if isRemoteSpyActive then
		spyToggleBtn.Text = "👁️ Toggle Remote Spy: ON"
		spyToggleBtn.BackgroundColor3 = t.Accent
		sendNotification("Remote Spy", "Spy activated!")
		for _, obj in ipairs(ReplicatedStorage:GetDescendants()) do
			if obj:IsA("RemoteEvent") or obj:IsA("RemoteFunction") then
				addSpyLog(obj, "Ready", "Ready to fire")
			end
		end
	else
		spyToggleBtn.Text = "👁️ Toggle Remote Spy: OFF"
		spyToggleBtn.BackgroundColor3 = Color3.fromRGB(50, 50, 60)
		sendNotification("Remote Spy", "Spy deactivated.")
	end
end)

local fireSpyBtn = createActionButton(remoteCard, "📤 Fire Locked Target", 360, t.Accent)
fireSpyBtn.MouseButton1Click:Connect(function()
	if not activeSpyTarget then
		sendNotification("Error", "No remote target locked!")
		return
	end
	local val = remoteInput.Text
	local payload = { message = val }
	if activeSpyTarget:IsA("RemoteEvent") then
		activeSpyTarget:FireServer(payload)
		remoteOutput.Text = "[Fired RemoteEvent]: " .. activeSpyTarget.Name
	elseif activeSpyTarget:IsA("RemoteFunction") then
		task.spawn(function()
			local success, response = pcall(function()
				return activeSpyTarget:InvokeServer(payload)
			end)
			if success then
				remoteOutput.Text = "[Server Response]: " .. tostring(response)
			else
				remoteOutput.Text = "[Error]: " .. tostring(response)
			end
		end)
	end
end)

-- Tab 7: Expanded Settings & Theme Customizer
local settingsPage = Instance.new("ScrollingFrame")
settingsPage.Size = UDim2.new(1, 0, 1, 0)
settingsPage.BackgroundTransparency = 1
settingsPage.BorderSizePixel = 0
settingsPage.CanvasSize = UDim2.new(0, 0, 0, 480)
settingsPage.ScrollBarThickness = 3
settingsPage.Visible = false
settingsPage.Parent = content

applyPaddingAndLayout(settingsPage)

local themeCard = createCard(settingsPage, 1, 330)
local themeTitle = Instance.new("TextLabel")
themeTitle.Size = UDim2.new(1, -20, 0, 24)
themeTitle.Position = UDim2.fromOffset(10, 8)
themeTitle.BackgroundTransparency = 1
themeTitle.Text = "🎨 Expanded Theme Customizer"
themeTitle.TextColor3 = t.Text
themeTitle.Font = Enum.Font.GothamBold
themeTitle.TextSize = 11
themeTitle.TextXAlignment = Enum.TextXAlignment.Left
themeTitle.Parent = themeCard

-- Theme apply function across all GUI elements
local profileCardRef, statsCardRef, perfCardRef, syncCardRef, movementCardRef, aiCardRef, espCardRef, nightCardRef, tpCardRef, remoteCardRef
profileCardRef = profileCard
statsCardRef = statsCard
perfCardRef = perfCard
syncCardRef = syncCard
movementCardRef = movementCard
aiCardRef = aiCard
espCardRef = espCard
nightCardRef = nightCard
tpCardRef = tpCard
remoteCardRef = remoteCard

local function applyTheme(key)
	local th = themes[key]
	currentThemeKey = key
	t = th
	
	frame.BackgroundColor3 = t.Main
	mainStroke.Color = t.Stroke
	titleBar.BackgroundColor3 = t.Header
	titleCover.BackgroundColor3 = t.Header
	title.TextColor3 = t.Text
	minBtn.BackgroundColor3 = t.Card
	minBtn.TextColor3 = t.Text
	sidebar.BackgroundColor3 = t.Sidebar
	toggleBtn.BackgroundColor3 = t.Main
	toggleBtn.TextColor3 = t.Accent
	toggleStroke.Color = t.Stroke
	
	for _, btn in ipairs({profileTabBtn, scriptTabBtn, aiTabBtn, visualsTabBtn, tpTabBtn, remoteTabBtn, settingsTabBtn}) do
		btn.BackgroundColor3 = t.Card
		btn.TextColor3 = t.Text
	end
	
	for _, card in ipairs({profileCardRef, statsCardRef, perfCardRef, syncCardRef, movementCardRef, aiCardRef, espCardRef, nightCardRef, tpCardRef, remoteCardRef, themeCard}) do
		card.BackgroundColor3 = t.Card
		for _, child in ipairs(card:GetChildren()) do
			if child:IsA("UIStroke") then child.Color = t.Stroke end
			if child:IsA("TextLabel") then child.TextColor3 = t.Text end
		end
	end
	
	loadPosBtn.BackgroundColor3 = t.Accent
	fireSpyBtn.BackgroundColor3 = t.Accent
	updateCharacterAura()
	sendNotification("Theme Updated", "Applied " .. th.Name)
end

local btnCyber = createActionButton(themeCard, "💻 Cyber Minimalist", 36, Color3.fromRGB(60, 70, 90))
btnCyber.Size = UDim2.new(0.48, -4, 0, 26)
btnCyber.Position = UDim2.fromOffset(10, 36)
btnCyber.MouseButton1Click:Connect(function() applyTheme("Cyber") end)

local btnYellow = createActionButton(themeCard, "⚡ Lightning", 36, Color3.fromRGB(150, 130, 10))
btnYellow.Size = UDim2.new(0.48, -4, 0, 26)
btnYellow.Position = UDim2.new(0.5, 6, 0, 36)
btnYellow.MouseButton1Click:Connect(function() applyTheme("Lightning") end)

local btnBlue = createActionButton(themeCard, "❄️ Ice", 68, Color3.fromRGB(14, 110, 160))
btnBlue.Size = UDim2.new(0.48, -4, 0, 26)
btnBlue.Position = UDim2.fromOffset(10, 68)
btnBlue.MouseButton1Click:Connect(function() applyTheme("Ice") end)

local btnCrimson = createActionButton(themeCard, "🔥 Crimson Neon", 68, Color3.fromRGB(180, 30, 50))
btnCrimson.Size = UDim2.new(0.48, -4, 0, 26)
btnCrimson.Position = UDim2.new(0.5, 6, 0, 68)
btnCrimson.MouseButton1Click:Connect(function() applyTheme("Crimson") end)

local btnEmerald = createActionButton(themeCard, "🟢 Emerald Matrix", 100, Color3.fromRGB(20, 120, 70))
btnEmerald.Size = UDim2.new(0.48, -4, 0, 26)
btnEmerald.Position = UDim2.fromOffset(10, 100)
btnEmerald.MouseButton1Click:Connect(function() applyTheme("Emerald") end)

local btnSunset = createActionButton(themeCard, "🌇 Sunset Cyber", 100, Color3.fromRGB(180, 50, 120))
btnSunset.Size = UDim2.new(0.48, -4, 0, 26)
btnSunset.Position = UDim2.new(0.5, 6, 0, 100)
btnSunset.MouseButton1Click:Connect(function() applyTheme("Sunset") end)

local btnAmethyst = createActionButton(themeCard, "🟣 Deep Amethyst", 132, Color3.fromRGB(100, 50, 160))
btnAmethyst.Size = UDim2.new(1, -20, 0, 26)
btnAmethyst.Position = UDim2.fromOffset(10, 132)
btnAmethyst.MouseButton1Click:Connect(function() applyTheme("Amethyst") end)

local transparencyLabel = Instance.new("TextLabel")
transparencyLabel.Size = UDim2.new(1, -20, 0, 18)
transparencyLabel.Position = UDim2.fromOffset(10, 170)
transparencyLabel.BackgroundTransparency = 1
transparencyLabel.Text = "Glass Transparency Level:"
transparencyLabel.TextColor3 = t.Text
transparencyLabel.Font = Enum.Font.GothamMedium
transparencyLabel.TextSize = 10
transparencyLabel.TextXAlignment = Enum.TextXAlignment.Left
transparencyLabel.Parent = themeCard

local transBtn = createActionButton(themeCard, "✨ Toggle Glassmorphism Transparency", 192, Color3.fromRGB(50, 50, 60))
transBtn.MouseButton1Click:Connect(function()
	if frame.BackgroundTransparency > 0.05 then
		frame.BackgroundTransparency = 0.04
		sendNotification("Visuals", "Glassmorphism set to solid standard.")
	else
		frame.BackgroundTransparency = 0.35
		sendNotification("Visuals", "Glassmorphism transparency enabled!")
	end
end)

-- Navigation Controller
local function switchTab(activeBtn, targetPage)
	profilePage.Visible = (targetPage == profilePage)
	scriptPage.Visible = (targetPage == scriptPage)
	aiPage.Visible = (targetPage == aiPage)
	visualsPage.Visible = (targetPage == visualsPage)
	tpPage.Visible = (targetPage == tpPage)
	remotePage.Visible = (targetPage == remotePage)
	settingsPage.Visible = (targetPage == settingsPage)
	
	for _, btn in ipairs({profileTabBtn, scriptTabBtn, aiTabBtn, visualsTabBtn, tpTabBtn, remoteTabBtn, settingsTabBtn}) do
		btn.BackgroundColor3 = t.Card
		btn.TextColor3 = t.Text
	end
	activeBtn.BackgroundColor3 = t.Header
end

profileTabBtn.MouseButton1Click:Connect(function() switchTab(profileTabBtn, profilePage) end)
scriptTabBtn.MouseButton1Click:Connect(function() switchTab(scriptTabBtn, scriptPage) end)
aiTabBtn.MouseButton1Click:Connect(function() switchTab(aiTabBtn, aiPage) end)
visualsTabBtn.MouseButton1Click:Connect(function() switchTab(visualsTabBtn, visualsPage) end)
tpTabBtn.MouseButton1Click:Connect(function() switchTab(tpTabBtn, tpPage) end)
remoteTabBtn.MouseButton1Click:Connect(function() switchTab(remoteTabBtn, remotePage) end)
settingsTabBtn.MouseButton1Click:Connect(function() switchTab(settingsTabBtn, settingsPage) end)

toggleBtn.MouseButton1Click:Connect(function()
	if not iconDragging then
		frame.Visible = not frame.Visible
	end
end)

-- Background Loops & Telemetry
task.spawn(function()
	local gameName = "Roblox Game"
	local success, info = pcall(function()
		return MarketplaceService:GetProductInfo(game.PlaceId)
	end)
	if success and info and info.Name then
		gameName = info.Name
	end

	while gui and gui.Parent do
		local leaderstats = player:FindFirstChild("leaderstats")
		if leaderstats then
			local statLines = {}
			table.insert(statLines, "Game: " .. gameName)
			for _, stat in ipairs(leaderstats:GetChildren()) do
				table.insert(statLines, string.format("• %s: %s", stat.Name, tostring(stat.Value)))
			end
			syncInfo.Text = table.concat(statLines, "\n")
		else
			syncInfo.Text = "Game: " .. gameName .. "\n⚠️ No 'leaderstats' folder found."
		end
		task.wait(1)
	end
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
		
		local ping = 0
		pcall(function()
			ping = math.floor(Stats.Network.ServerStatsItem["Data Ping"]:GetValue())
		end)
		
		perfLabel.Text = string.format("⚡ FPS: %d | Ping: %d ms\n🟢 Suite v31.0: Active", currentFps, ping)
		task.wait(1)
	end
end)

-- Window Dragging & Free Resizing Handler
local handle = Instance.new("TextButton")
handle.Size = UDim2.fromOffset(20, 20)
handle.Position = UDim2.new(1, -20, 1, -20)
handle.BackgroundTransparency = 1
handle.Text = "◢"
handle.TextColor3 = t.Stroke
handle.TextSize = 12
handle.ZIndex = 5
handle.Parent = frame

task.spawn(function()
	while not isFullyLoaded do task.wait(0.1) end
	frame.Visible = true
end)

local dragging, dragStart, startPos
titleBar.InputBegan:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
		dragging = true
		dragStart = input.Position
		startPos = frame.Position
		input.Changed:Connect(function()
			if input.UserInputState == Enum.UserInputState.End then
				dragging = false
			end
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
		scriptPage.Visible = false
		aiPage.Visible = false
		visualsPage.Visible = false
		tpPage.Visible = false
		remotePage.Visible = false
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

print("[SpeedsterWizard v31.0] Loaded Successfully with Resizable UI & 7 Themes!")