-- Импорт необходимых сервисов
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local HttpService = game:GetService("HttpService")
local TeleportService = game:GetService("TeleportService")

-- Глобальные настройки
local Settings = {
    ESP = {Enabled = false, Transparency = 0.5, FillColor = Color3.fromRGB(255, 255, 255), OutlineColor = Color3.fromRGB(147, 112, 219), Mode = "AlwaysOnTop"},
    Noclip = {Enabled = false},
    FOV = {Enabled = false, Value = 90},
    InfiniteJump = {Enabled = false},
    Rejoin = {Action = function()
        local servers = HttpService:JSONDecode(game:HttpGet("https://games.roblox.com/v1/games/" .. game.PlaceId .. "/servers/Public?sortOrder=Asc&limit=100"))
        for _, server in pairs(servers.data) do
            if server.playing < server.maxPlayers and server.playing > 0 then
                TeleportService:TeleportToPlaceInstance(game.PlaceId, server.id)
                break
            end
        end
    end}
}

-- Главный GUI
local XHubGUI = Instance.new("ScreenGui")
XHubGUI.Name = "XHub"
XHubGUI.Parent = game:GetService("CoreGui")
XHubGUI.IgnoreGuiInset = true
XHubGUI.DisplayOrder = 1000
XHubGUI.Enabled = true

-- Главный фрейм
local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 250, 0, 40)
MainFrame.Position = UDim2.new(0.5, -125, 0.5, -20)
MainFrame.BackgroundColor3 = Color3.fromRGB(31, 31, 31)
MainFrame.BackgroundTransparency = 0
MainFrame.BorderSizePixel = 0
MainFrame.Active = false
MainFrame.Parent = XHubGUI

local MainCorner = Instance.new("UICorner")
MainCorner.CornerRadius = UDim.new(0, 10)
MainCorner.Parent = MainFrame

local MainStroke = Instance.new("UIStroke")
MainStroke.Color = Color3.fromRGB(147, 112, 219)
MainStroke.Thickness = 1
MainStroke.Parent = MainFrame

-- Заголовок
local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(0.7, 0, 1, 0)
Title.Position = UDim2.new(0, 10, 0, 0)
Title.Text = "X Hub"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.TextSize = 18
Title.Font = Enum.Font.SourceSans
Title.BackgroundTransparency = 1
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.TextTransparency = 0
Title.Parent = MainFrame

-- Кнопка сворачивания/разворачивания
local ToggleButton = Instance.new("TextButton")
ToggleButton.Size = UDim2.new(0, 30, 0, 30)
ToggleButton.Position = UDim2.new(1, -40, 0, 5)
ToggleButton.Text = "▼"
ToggleButton.TextColor3 = Color3.fromRGB(255, 255, 255)
ToggleButton.TextSize = 18
ToggleButton.Font = Enum.Font.SourceSans
ToggleButton.BackgroundTransparency = 1
ToggleButton.Parent = MainFrame

-- Прокручиваемый фрейм
local ScrollFrame = Instance.new("ScrollingFrame")
ScrollFrame.Size = UDim2.new(1, 0, 0, 220)
ScrollFrame.Position = UDim2.new(0, 0, 0, 40)
ScrollFrame.BackgroundTransparency = 1
ScrollFrame.ScrollBarThickness = 4
ScrollFrame.ScrollBarImageColor3 = Color3.fromRGB(147, 112, 219)
ScrollFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
ScrollFrame.ScrollingDirection = Enum.ScrollingDirection.Y
ScrollFrame.Visible = false
ScrollFrame.Parent = MainFrame

local ScrollListLayout = Instance.new("UIListLayout")
ScrollListLayout.SortOrder = Enum.SortOrder.LayoutOrder
ScrollListLayout.Padding = UDim.new(0, 5)
ScrollListLayout.Parent = ScrollFrame

-- Функция обновления размера Canvas
local function UpdateCanvasSize()
    local totalHeight = 0
    for _, child in pairs(ScrollFrame:GetChildren()) do
        if child:IsA("Frame") then
            totalHeight = totalHeight + child.Size.Y.Offset + ScrollListLayout.Padding.Offset
        end
    end
    ScrollFrame.CanvasSize = UDim2.new(0, 0, 0, totalHeight)
end

-- Уведомления
local NotificationGUI = Instance.new("ScreenGui")
NotificationGUI.Name = "XHubNotifications"
NotificationGUI.Parent = game:GetService("CoreGui")
NotificationGUI.IgnoreGuiInset = true

local NotificationContainer = Instance.new("Frame")
NotificationContainer.Size = UDim2.new(0, 250, 0, 300)
NotificationContainer.Position = UDim2.new(1, -260, 1, -310)
NotificationContainer.BackgroundTransparency = 1
NotificationContainer.Parent = NotificationGUI

local NotificationListLayout = Instance.new("UIListLayout")
NotificationListLayout.SortOrder = Enum.SortOrder.LayoutOrder
NotificationListLayout.Padding = UDim.new(0, 5)
NotificationListLayout.VerticalAlignment = Enum.VerticalAlignment.Bottom
NotificationListLayout.Parent = NotificationContainer

local function CreateNotification(message, isSuccess)
    local NotificationFrame = Instance.new("Frame")
    NotificationFrame.Size = UDim2.new(1, 0, 0, 50)
    NotificationFrame.BackgroundColor3 = Color3.fromRGB(31, 31, 31)
    NotificationFrame.BackgroundTransparency = 1
    NotificationFrame.Parent = NotificationContainer

    local NotifCorner = Instance.new("UICorner")
    NotifCorner.CornerRadius = UDim.new(0, 10)
    NotifCorner.Parent = NotificationFrame

    local NotifStroke = Instance.new("UIStroke")
    NotifStroke.Color = Color3.fromRGB(147, 112, 219)
    NotifStroke.Thickness = 1
    NotifStroke.Transparency = 1
    NotifStroke.Parent = NotificationFrame

    local NotifText = Instance.new("TextLabel")
    NotifText.Size = UDim2.new(1, -20, 1, -10)
    NotifText.Position = UDim2.new(0, 10, 0, 5)
    NotifText.Text = message
    NotifText.TextColor3 = isSuccess and Color3.fromRGB(147, 112, 219) or Color3.fromRGB(255, 0, 0)
    NotifText.TextSize = 14
    NotifText.Font = Enum.Font.SourceSans
    NotifText.BackgroundTransparency = 1
    NotifText.TextXAlignment = Enum.TextXAlignment.Left
    NotifText.TextTransparency = 1
    NotifText.Parent = NotificationFrame

    local fadeInFrame = TweenService:Create(NotificationFrame, TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {BackgroundTransparency = 0})
    local fadeInStroke = TweenService:Create(NotifStroke, TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Transparency = 0})
    local fadeInText = TweenService:Create(NotifText, TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {TextTransparency = 0})
    fadeInFrame:Play()
    fadeInStroke:Play()
    fadeInText:Play()

    spawn(function()
        wait(3)
        local fadeOutFrame = TweenService:Create(NotificationFrame, TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {BackgroundTransparency = 1})
        local fadeOutStroke = TweenService:Create(NotifStroke, TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {Transparency = 1})
        local fadeOutText = TweenService:Create(NotifText, TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {TextTransparency = 1})
        fadeOutFrame:Play()
        fadeOutStroke:Play()
        fadeOutText:Play()
        fadeOutFrame.Completed:Connect(function()
            NotificationFrame:Destroy()
        end)
    end)
end

-- Категория "Общие функции"
local GeneralFrame = Instance.new("Frame")
GeneralFrame.Size = UDim2.new(1, 0, 0, 30)
GeneralFrame.BackgroundTransparency = 1
GeneralFrame.LayoutOrder = 1
GeneralFrame.Parent = ScrollFrame

local GeneralLabel = Instance.new("TextLabel")
GeneralLabel.Size = UDim2.new(0.7, 0, 1, 0)
GeneralLabel.Position = UDim2.new(0, 10, 0, 0)
GeneralLabel.Text = "Общие функции"
GeneralLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
GeneralLabel.TextSize = 16
GeneralLabel.Font = Enum.Font.SourceSans
GeneralLabel.BackgroundTransparency = 1
GeneralLabel.TextXAlignment = Enum.TextXAlignment.Left
GeneralLabel.Parent = GeneralFrame

local GeneralToggleButton = Instance.new("TextButton")
GeneralToggleButton.Size = UDim2.new(0, 20, 0, 20)
GeneralToggleButton.Position = UDim2.new(1, -30, 0, 5)
GeneralToggleButton.Text = "▼"
GeneralToggleButton.TextColor3 = Color3.fromRGB(255, 255, 255)
GeneralToggleButton.TextSize = 14
GeneralToggleButton.Font = Enum.Font.SourceSans
GeneralToggleButton.BackgroundTransparency = 1
GeneralToggleButton.Parent = GeneralFrame

local GeneralFunctionsFrame = Instance.new("Frame")
GeneralFunctionsFrame.Size = UDim2.new(1, 0, 0, 0)
GeneralFunctionsFrame.Position = UDim2.new(0, 0, 0, 30)
GeneralFunctionsFrame.BackgroundTransparency = 1
GeneralFunctionsFrame.ClipsDescendants = true
GeneralFunctionsFrame.Parent = GeneralFrame

local GeneralFunctionsListLayout = Instance.new("UIListLayout")
GeneralFunctionsListLayout.SortOrder = Enum.SortOrder.LayoutOrder
GeneralFunctionsListLayout.Padding = UDim.new(0, 5)
GeneralFunctionsListLayout.Parent = GeneralFunctionsFrame

-- Категория "Blade Ball"
local BladeBallFrame = Instance.new("Frame")
BladeBallFrame.Size = UDim2.new(1, 0, 0, 30)
BladeBallFrame.BackgroundTransparency = 1
BladeBallFrame.LayoutOrder = 2
BladeBallFrame.Parent = ScrollFrame

local BladeBallLabel = Instance.new("TextLabel")
BladeBallLabel.Size = UDim2.new(0.7, 0, 1, 0)
BladeBallLabel.Position = UDim2.new(0, 10, 0, 0)
BladeBallLabel.Text = "Blade Ball"
BladeBallLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
BladeBallLabel.TextSize = 16
BladeBallLabel.Font = Enum.Font.SourceSans
BladeBallLabel.BackgroundTransparency = 1
BladeBallLabel.TextXAlignment = Enum.TextXAlignment.Left
BladeBallLabel.Parent = BladeBallFrame

-- Функции
local Functions = {
    {Name = "ESP", Setting = Settings.ESP, HasSettings = true},
    {Name = "Noclip", Setting = Settings.Noclip},
    {Name = "FOV", Setting = Settings.FOV},
    {Name = "Бесконечный прыжок", Setting = Settings.InfiniteJump},
    {Name = "Перезайти сервер", Action = Settings.Rejoin.Action}
}

for i, func in pairs(Functions) do
    local FuncFrame = Instance.new("Frame")
    FuncFrame.Size = UDim2.new(1, 0, 0, 30)
    FuncFrame.BackgroundTransparency = 1
    FuncFrame.LayoutOrder = i
    FuncFrame.Parent = GeneralFunctionsFrame

    local FuncLabel = Instance.new("TextLabel")
    FuncLabel.Size = UDim2.new(0.7, 0, 1, 0)
    FuncLabel.Position = UDim2.new(0, 10, 0, 0)
    FuncLabel.Text = func.Name
    FuncLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    FuncLabel.TextSize = 14
    FuncLabel.Font = Enum.Font.SourceSans
    FuncLabel.BackgroundTransparency = 1
    FuncLabel.TextXAlignment = Enum.TextXAlignment.Left
    FuncLabel.Parent = FuncFrame

    if func.Name ~= "Перезайти сервер" then
        local ToggleButton = Instance.new("TextButton")
        ToggleButton.Size = UDim2.new(0, 24, 0, 24)
        ToggleButton.Position = UDim2.new(1, -34, 0, 3)
        ToggleButton.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
        ToggleButton.Text = ""
        ToggleButton.Parent = FuncFrame

        local ToggleCorner = Instance.new("UICorner")
        ToggleCorner.CornerRadius = UDim.new(0, 5)
        ToggleCorner.Parent = ToggleButton

        local ToggleStroke = Instance.new("UIStroke")
        ToggleStroke.Color = Color3.fromRGB(147, 112, 219)
        ToggleStroke.Thickness = 1
        ToggleStroke.Parent = ToggleButton

        local function UpdateToggle()
            local tweenInfo = TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
            local targetColor = func.Setting.Enabled and Color3.fromRGB(147, 112, 219) or Color3.fromRGB(50, 50, 50)
            TweenService:Create(ToggleButton, tweenInfo, {BackgroundColor3 = targetColor}):Play()
        end

        ToggleButton.MouseButton1Click:Connect(function()
            func.Setting.Enabled = not func.Setting.Enabled
            UpdateToggle()
            CreateNotification(func.Name .. (func.Setting.Enabled and " включено" or " выключено"), func.Setting.Enabled)
        end)

        UpdateToggle()

        if func.HasSettings then
            local SettingsButton = Instance.new("TextButton")
            SettingsButton.Size = UDim2.new(0, 24, 0, 24)
            SettingsButton.Position = UDim2.new(1, -64, 0, 3)
            SettingsButton.Text = "⚙"
            SettingsButton.TextColor3 = Color3.fromRGB(255, 255, 255)
            SettingsButton.TextSize = 14
            SettingsButton.BackgroundTransparency = 1
            SettingsButton.Parent = FuncFrame

            local ESPSettingsFrame = nil

            SettingsButton.MouseButton1Click:Connect(function()
                if ESPSettingsFrame then
                    local fadeOutSettings = TweenService:Create(ESPSettingsFrame, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {BackgroundTransparency = 1})
                    local fadeOutStroke = TweenService:Create(ESPSettingsFrame:FindFirstChild("UIStroke"), TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {Transparency = 1})
                    local fadeOutTitle = TweenService:Create(ESPSettingsFrame:FindFirstChild("SettingsTitle"), TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {TextTransparency = 1})
                    local fadeOutClose = TweenService:Create(ESPSettingsFrame:FindFirstChild("CloseButton"), TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {TextTransparency = 1, BackgroundTransparency = 1})
                    local fadeOutFillColor = TweenService:Create(ESPSettingsFrame:FindFirstChild("FillColorButton"), TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {BackgroundTransparency = 1, TextTransparency = 1})
                    local fadeOutOutlineColor = TweenService:Create(ESPSettingsFrame:FindFirstChild("OutlineColorButton"), TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {BackgroundTransparency = 1, TextTransparency = 1})
                    local fadeOutMode = TweenService:Create(ESPSettingsFrame:FindFirstChild("ModeButton"), TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {BackgroundTransparency = 1, TextTransparency = 1})

                    fadeOutSettings:Play()
                    fadeOutStroke:Play()
                    fadeOutTitle:Play()
                    fadeOutClose:Play()
                    fadeOutFillColor:Play()
                    fadeOutOutlineColor:Play()
                    fadeOutMode:Play()

                    fadeOutSettings.Completed:Connect(function()
                        ESPSettingsFrame:Destroy()
                        ESPSettingsFrame = nil
                    end)
                    return
                end

                ESPSettingsFrame = Instance.new("Frame")
                ESPSettingsFrame.Size = UDim2.new(0, 180, 0, 150)
                ESPSettingsFrame.Position = UDim2.new(0.5, -90, 0.5, -75)
                ESPSettingsFrame.BackgroundColor3 = Color3.fromRGB(31, 31, 31)
                ESPSettingsFrame.BackgroundTransparency = 1
                ESPSettingsFrame.Parent = XHubGUI

                local SettingsCorner = Instance.new("UICorner")
                SettingsCorner.CornerRadius = UDim.new(0, 10)
                SettingsCorner.Parent = ESPSettingsFrame

                local SettingsStroke = Instance.new("UIStroke")
                SettingsStroke.Color = Color3.fromRGB(147, 112, 219)
                SettingsStroke.Thickness = 1
                SettingsStroke.Transparency = 1
                SettingsStroke.Parent = ESPSettingsFrame

                local SettingsTitle = Instance.new("TextLabel")
                SettingsTitle.Name = "SettingsTitle"
                SettingsTitle.Size = UDim2.new(1, 0, 0, 30)
                SettingsTitle.Text = "Настройки ESP"
                SettingsTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
                SettingsTitle.TextSize = 16
                SettingsTitle.Font = Enum.Font.SourceSans
                SettingsTitle.BackgroundTransparency = 1
                SettingsTitle.TextXAlignment = Enum.TextXAlignment.Center
                SettingsTitle.TextTransparency = 1
                SettingsTitle.Parent = ESPSettingsFrame

                local CloseButton = Instance.new("TextButton")
                CloseButton.Name = "CloseButton"
                CloseButton.Size = UDim2.new(0, 24, 0, 24)
                CloseButton.Position = UDim2.new(1, -28, 0, 3)
                CloseButton.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
                CloseButton.Text = "X"
                CloseButton.TextColor3 = Color3.fromRGB(255, 255, 255)
                CloseButton.TextSize = 14
                CloseButton.BackgroundTransparency = 1
                CloseButton.TextTransparency = 1
                CloseButton.Parent = ESPSettingsFrame

                local CloseCorner = Instance.new("UICorner")
                CloseCorner.CornerRadius = UDim.new(0, 5)
                CloseCorner.Parent = CloseButton

                CloseButton.MouseButton1Click:Connect(function()
                    local fadeOutSettings = TweenService:Create(ESPSettingsFrame, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {BackgroundTransparency = 1})
                    local fadeOutStroke = TweenService:Create(SettingsStroke, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {Transparency = 1})
                    local fadeOutTitle = TweenService:Create(SettingsTitle, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {TextTransparency = 1})
                    local fadeOutClose = TweenService:Create(CloseButton, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {TextTransparency = 1, BackgroundTransparency = 1})
                    local fadeOutFillColor = TweenService:Create(ESPSettingsFrame:FindFirstChild("FillColorButton"), TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {BackgroundTransparency = 1, TextTransparency = 1})
                    local fadeOutOutlineColor = TweenService:Create(ESPSettingsFrame:FindFirstChild("OutlineColorButton"), TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {BackgroundTransparency = 1, TextTransparency = 1})
                    local fadeOutMode = TweenService:Create(ESPSettingsFrame:FindFirstChild("ModeButton"), TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {BackgroundTransparency = 1, TextTransparency = 1})

                    fadeOutSettings:Play()
                    fadeOutStroke:Play()
                    fadeOutTitle:Play()
                    fadeOutClose:Play()
                    fadeOutFillColor:Play()
                    fadeOutOutlineColor:Play()
                    fadeOutMode:Play()

                    fadeOutSettings.Completed:Connect(function()
                        ESPSettingsFrame:Destroy()
                        ESPSettingsFrame = nil
                    end)
                end)

                local FillColorButton = Instance.new("TextButton")
                FillColorButton.Name = "FillColorButton"
                FillColorButton.Size = UDim2.new(0, 150, 0, 30)
                FillColorButton.Position = UDim2.new(0, 15, 0, 40)
                FillColorButton.BackgroundColor3 = func.Setting.FillColor
                FillColorButton.Text = "Цвет заливки"
                FillColorButton.TextColor3 = Color3.fromRGB(255, 255, 255)
                FillColorButton.TextSize = 14
                FillColorButton.Font = Enum.Font.SourceSans
                FillColorButton.BackgroundTransparency = 1
                FillColorButton.TextTransparency = 1
                FillColorButton.Parent = ESPSettingsFrame

                local FillColorCorner = Instance.new("UICorner")
                FillColorCorner.CornerRadius = UDim.new(0, 5)
                FillColorCorner.Parent = FillColorButton

                FillColorButton.MouseButton1Click:Connect(function()
                    local r = math.random(0, 255)
                    local g = math.random(0, 255)
                    local b = math.random(0, 255)
                    func.Setting.FillColor = Color3.fromRGB(r, g, b)
                    FillColorButton.BackgroundColor3 = func.Setting.FillColor
                end)

                local OutlineColorButton = Instance.new("TextButton")
                OutlineColorButton.Name = "OutlineColorButton"
                OutlineColorButton.Size = UDim2.new(0, 150, 0, 30)
                OutlineColorButton.Position = UDim2.new(0, 15, 0, 80)
                OutlineColorButton.BackgroundColor3 = func.Setting.OutlineColor
                OutlineColorButton.Text = "Цвет обводки"
                OutlineColorButton.TextColor3 = Color3.fromRGB(255, 255, 255)
                OutlineColorButton.TextSize = 14
                OutlineColorButton.Font = Enum.Font.SourceSans
                OutlineColorButton.BackgroundTransparency = 1
                OutlineColorButton.TextTransparency = 1
                OutlineColorButton.Parent = ESPSettingsFrame

                local OutlineColorCorner = Instance.new("UICorner")
                OutlineColorCorner.CornerRadius = UDim.new(0, 5)
                OutlineColorCorner.Parent = OutlineColorButton

                OutlineColorButton.MouseButton1Click:Connect(function()
                    local r = math.random(0, 255)
                    local g = math.random(0, 255)
                    local b = math.random(0, 255)
                    func.Setting.OutlineColor = Color3.fromRGB(r, g, b)
                    OutlineColorButton.BackgroundColor3 = func.Setting.OutlineColor
                end)

                local ModeButton = Instance.new("TextButton")
                ModeButton.Name = "ModeButton"
                ModeButton.Size = UDim2.new(0, 150, 0, 30)
                ModeButton.Position = UDim2.new(0, 15, 0, 120)
                ModeButton.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
                ModeButton.Text = "Режим: " .. (func.Setting.Mode == "AlwaysOnTop" and "AOT" or "TW")
                ModeButton.TextColor3 = Color3.fromRGB(255, 255, 255)
                ModeButton.TextSize = 14
                ModeButton.Font = Enum.Font.SourceSans
                ModeButton.BackgroundTransparency = 1
                ModeButton.TextTransparency = 1
                ModeButton.Parent = ESPSettingsFrame

                local ModeCorner = Instance.new("UICorner")
                ModeCorner.CornerRadius = UDim.new(0, 5)
                ModeCorner.Parent = ModeButton

                ModeButton.MouseButton1Click:Connect(function()
                    func.Setting.Mode = func.Setting.Mode == "AlwaysOnTop" and "ThroughWalls" or "AlwaysOnTop"
                    ModeButton.Text = "Режим: " .. (func.Setting.Mode == "AlwaysOnTop" and "AOT" or "TW")
                end)

                local fadeInSettings = TweenService:Create(ESPSettingsFrame, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {BackgroundTransparency = 0})
                local fadeInStroke = TweenService:Create(SettingsStroke, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Transparency = 0})
                local fadeInTitle = TweenService:Create(SettingsTitle, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {TextTransparency = 0})
                local fadeInClose = TweenService:Create(CloseButton, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {TextTransparency = 0, BackgroundTransparency = 0})
                local fadeInFillColor = TweenService:Create(FillColorButton, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {BackgroundTransparency = 0, TextTransparency = 0})
                local fadeInOutlineColor = TweenService:Create(OutlineColorButton, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {BackgroundTransparency = 0, TextTransparency = 0})
                local fadeInMode = TweenService:Create(ModeButton, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {BackgroundTransparency = 0, TextTransparency = 0})

                fadeInSettings:Play()
                fadeInStroke:Play()
                fadeInTitle:Play()
                fadeInClose:Play()
                fadeInFillColor:Play()
                fadeInOutlineColor:Play()
                fadeInMode:Play()

                local Dragging = false
                local DragStart = nil
                local StartPos = nil

                SettingsTitle.InputBegan:Connect(function(input)
                    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                        Dragging = true
                        DragStart = input.Position
                        StartPos = ESPSettingsFrame.Position
                    end
                end)

                SettingsTitle.InputEnded:Connect(function(input)
                    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                        Dragging = false
                    end
                end)

                UserInputService.InputChanged:Connect(function(input)
                    if Dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
                        local delta = input.Position - DragStart
                        local newPosX = StartPos.X.Offset + delta.X
                        local newPosY = StartPos.Y.Offset + delta.Y
                        ESPSettingsFrame.Position = UDim2.new(StartPos.X.Scale, newPosX, StartPos.Y.Scale, newPosY)
                    end
                end)
            end)
        end
    else
        local RejoinButton = Instance.new("TextButton")
        RejoinButton.Size = UDim2.new(0, 24, 0, 24)
        RejoinButton.Position = UDim2.new(1, -34, 0, 3)
        RejoinButton.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
        RejoinButton.Text = "↻"
        RejoinButton.TextColor3 = Color3.fromRGB(255, 255, 255)
        RejoinButton.TextSize = 14
        RejoinButton.Font = Enum.Font.SourceSans
        RejoinButton.Parent = FuncFrame

        local RejoinCorner = Instance.new("UICorner")
        RejoinCorner.CornerRadius = UDim.new(0, 5)
        RejoinCorner.Parent = RejoinButton

        RejoinButton.MouseButton1Click:Connect(func.Action)
    end
end

-- Анимация сворачивания/разворачивания категории
local IsGeneralExpanded = false
GeneralToggleButton.MouseButton1Click:Connect(function()
    IsGeneralExpanded = not IsGeneralExpanded
    local newHeight = IsGeneralExpanded and UDim2.new(1, 0, 0, 150) or UDim2.new(1, 0, 0, 0)
    local tweenInfo = TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
    local tween = TweenService:Create(GeneralFunctionsFrame, tweenInfo, {Size = newHeight})
    tween:Play()
    GeneralToggleButton.Text = IsGeneralExpanded and "▲" or "▼"
    GeneralFrame.Size = IsGeneralExpanded and UDim2.new(1, 0, 0, 180) or UDim2.new(1, 0, 0, 30)
    UpdateCanvasSize()
end)

-- Анимация сворачивания/разворачивания главного меню
local IsMainExpanded = false
ToggleButton.MouseButton1Click:Connect(function()
    IsMainExpanded = not IsMainExpanded
    local newSize = IsMainExpanded and UDim2.new(0, 250, 0, 260) or UDim2.new(0, 250, 0, 40)
    local newPos = IsMainExpanded and UDim2.new(0.5, -125, 0.5, -130) or UDim2.new(0.5, -125, 0.5, -20)
    local tweenInfo = TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
    local sizeTween = TweenService:Create(MainFrame, tweenInfo, {Size = newSize, Position = newPos})
    sizeTween:Play()
    ToggleButton.Text = IsMainExpanded and "▲" or "▼"
    ScrollFrame.Visible = IsMainExpanded
end)

-- Перетаскивание главного меню
local Dragging = false
local DragStart = nil
local StartPos = nil

Title.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        Dragging = true
        DragStart = input.Position
        StartPos = MainFrame.Position
    end
end)

Title.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        Dragging = false
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if Dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
        local delta = input.Position - DragStart
        local newPosX = StartPos.X.Offset + delta.X
        local newPosY = StartPos.Y.Offset + delta.Y
        MainFrame.Position = UDim2.new(StartPos.X.Scale, newPosX, StartPos.Y.Scale, newPosY)
    end
end)

-- Функционал ESP
local ESPObjects = {}
local function CreateESP(player)
    if player == Players.LocalPlayer or ESPObjects[player] then return end
    local character = player.Character
    if not character then return end
    local highlight = Instance.new("Highlight")
    highlight.FillTransparency = Settings.ESP.Transparency
    highlight.FillColor = Settings.ESP.FillColor
    highlight.OutlineColor = Settings.ESP.OutlineColor
    highlight.OutlineTransparency = 0
    highlight.Adornee = character
    highlight.DepthMode = Settings.ESP.Mode == "AlwaysOnTop" and Enum.HighlightDepthMode.AlwaysOnTop or Enum.HighlightDepthMode.Occluded
    highlight.Parent = character
    ESPObjects[player] = highlight
end

local function UpdateESP()
    if not Settings.ESP.Enabled then
        for _, highlight in pairs(ESPObjects) do
            highlight.Enabled = false
        end
        return
    end
    for player, highlight in pairs(ESPObjects) do
        if player.Character and highlight.Adornee then
            highlight.Enabled = true
            highlight.FillColor = Settings.ESP.FillColor
            highlight.OutlineColor = Settings.ESP.OutlineColor
            highlight.FillTransparency = Settings.ESP.Transparency
            highlight.DepthMode = Settings.ESP.Mode == "AlwaysOnTop" and Enum.HighlightDepthMode.AlwaysOnTop or Enum.HighlightDepthMode.Occluded
        else
            highlight:Destroy()
            ESPObjects[player] = nil
        end
    end
    for _, player in pairs(Players:GetPlayers()) do
        if player ~= Players.LocalPlayer and player.Character and not ESPObjects[player] then
            CreateESP(player)
        end
    end
end

-- Функционал Noclip
local NoclipEnabled = false
local NoclipConnection = nil

local function EnableNoclip()
    if NoclipEnabled then return end
    NoclipEnabled = true
    NoclipConnection = RunService.Stepped:Connect(function()
        local character = Players.LocalPlayer.Character
        if not character then return end
        for _, part in pairs(character:GetDescendants()) do
            if part:IsA("BasePart") and part.CanCollide then
                part.CanCollide = false
            end
        end
    end)
end

local function DisableNoclip()
    if not NoclipEnabled then return end
    NoclipEnabled = false
    if NoclipConnection then
        NoclipConnection:Disconnect()
        NoclipConnection = nil
    end
    local character = Players.LocalPlayer.Character
    if not character then return end
    for _, part in pairs(character:GetDescendants()) do
        if part:IsA("BasePart") then
            part.CanCollide = true
        end
    end
end

local function UpdateNoclip()
    if Settings.Noclip.Enabled then
        EnableNoclip()
    else
        DisableNoclip()
    end
end

-- Функционал FOV
local function UpdateFOV()
    local camera = workspace.CurrentCamera
    if not camera then return end
    camera.FieldOfView = Settings.FOV.Enabled and Settings.FOV.Value or 70
end

-- Функционал Infinite Jump
local InfiniteJumpConnection = nil
local function UpdateInfiniteJump()
    if InfiniteJumpConnection then
        InfiniteJumpConnection:Disconnect()
        InfiniteJumpConnection = nil
    end
    if Settings.InfiniteJump.Enabled then
        InfiniteJumpConnection = UserInputService.JumpRequest:Connect(function()
            local character = Players.LocalPlayer.Character
            if not character then return end
            local humanoid = character:FindFirstChildOfClass("Humanoid")
            if humanoid then
                humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
            end
        end)
    end
end

-- Обновление функций
RunService.Heartbeat:Connect(function()
    UpdateESP()
    UpdateNoclip()
    UpdateFOV()
    UpdateInfiniteJump()
end)

Players.LocalPlayer.CharacterAdded:Connect(function()
    UpdateNoclip()
    UpdateFOV()
end)

Players.PlayerAdded:Connect(function(player)
    player.CharacterAdded:Connect(function()
        if Settings.ESP.Enabled then
            CreateESP(player)
        end
    end)
end)

Players.PlayerRemoving:Connect(function(player)
    if ESPObjects[player] then
        ESPObjects[player]:Destroy()
        ESPObjects[player] = nil
    end
end)

-- Система ключа
local KeySystemGUI = Instance.new("ScreenGui")
KeySystemGUI.Name = "XKeySystem"
KeySystemGUI.Parent = game:GetService("CoreGui")
KeySystemGUI.IgnoreGuiInset = true
KeySystemGUI.DisplayOrder = 9999
KeySystemGUI.Enabled = true

local KeySystemFrame = Instance.new("Frame")
KeySystemFrame.Size = UDim2.new(1, 0, 1, 0)
KeySystemFrame.BackgroundColor3 = Color3.fromRGB(31, 31, 31)
KeySystemFrame.BackgroundTransparency = 0.5
KeySystemFrame.Parent = KeySystemGUI

local KeySystemTitle = Instance.new("TextLabel")
KeySystemTitle.Size = UDim2.new(0, 400, 0, 50)
KeySystemTitle.Position = UDim2.new(0.5, -200, 0.2, -25)
KeySystemTitle.Text = "КЛЮЧ СИСТЕМА X HUB • 4.0.0"
KeySystemTitle.TextColor3 = Color3.fromRGB(147, 112, 219)
KeySystemTitle.TextSize = 24
KeySystemTitle.Font = Enum.Font.SourceSans
KeySystemTitle.BackgroundTransparency = 1
KeySystemTitle.TextTransparency = 0
KeySystemTitle.Parent = KeySystemFrame

local KeyInputFrame = Instance.new("Frame")
KeyInputFrame.Size = UDim2.new(0, 300, 0, 40)
KeyInputFrame.Position = UDim2.new(0.5, -150, 0.4, -20)
KeyInputFrame.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
KeyInputFrame.BackgroundTransparency = 0
KeyInputFrame.Parent = KeySystemFrame

local KeyInputCorner = Instance.new("UICorner")
KeyInputCorner.CornerRadius = UDim.new(0, 10)
KeyInputCorner.Parent = KeyInputFrame

local KeyInputStroke = Instance.new("UIStroke")
KeyInputStroke.Color = Color3.fromRGB(147, 112, 219)
KeyInputStroke.Thickness = 1
KeyInputStroke.Parent = KeyInputFrame

local KeyInput = Instance.new("TextBox")
KeyInput.Size = UDim2.new(1, -20, 1, -10)
KeyInput.Position = UDim2.new(0, 10, 0, 5)
KeyInput.BackgroundTransparency = 1
KeyInput.Text = ""
KeyInput.PlaceholderText = "Ввести ключ"
KeyInput.PlaceholderColor3 = Color3.fromRGB(147, 112, 219)
KeyInput.TextColor3 = Color3.fromRGB(255, 255, 255)
KeyInput.TextSize = 16
KeyInput.Font = Enum.Font.SourceSans
KeyInput.TextTransparency = 0
KeyInput.Parent = KeyInputFrame

local ActivateButton = Instance.new("TextButton")
ActivateButton.Size = UDim2.new(0, 140, 0, 40)
ActivateButton.Position = UDim2.new(0.5, -150, 0.5, 0)
ActivateButton.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
ActivateButton.Text = "Активировать ключ"
ActivateButton.TextColor3 = Color3.fromRGB(147, 112, 219)
ActivateButton.TextSize = 16
ActivateButton.Font = Enum.Font.SourceSans
ActivateButton.BackgroundTransparency = 0
ActivateButton.TextTransparency = 0
ActivateButton.Parent = KeySystemFrame

local ActivateCorner = Instance.new("UICorner")
ActivateCorner.CornerRadius = UDim.new(0, 10)
ActivateCorner.Parent = ActivateButton

local ActivateStroke = Instance.new("UIStroke")
ActivateStroke.Color = Color3.fromRGB(147, 112, 219)
ActivateStroke.Thickness = 1
ActivateStroke.Parent = ActivateButton

local GetKeyButton = Instance.new("TextButton")
GetKeyButton.Size = UDim2.new(0, 140, 0, 40)
GetKeyButton.Position = UDim2.new(0.5, 10, 0.5, 0)
GetKeyButton.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
GetKeyButton.Text = "Получить ключ"
GetKeyButton.TextColor3 = Color3.fromRGB(147, 112, 219)
GetKeyButton.TextSize = 16
GetKeyButton.Font = Enum.Font.SourceSans
GetKeyButton.BackgroundTransparency = 0
GetKeyButton.TextTransparency = 0
GetKeyButton.Parent = KeySystemFrame

local GetKeyCorner = Instance.new("UICorner")
GetKeyCorner.CornerRadius = UDim.new(0, 10)
GetKeyCorner.Parent = GetKeyButton

local GetKeyStroke = Instance.new("UIStroke")
GetKeyStroke.Color = Color3.fromRGB(147, 112, 219)
GetKeyStroke.Thickness = 1
GetKeyStroke.Parent = GetKeyButton

local CloseKeyButton = Instance.new("TextButton")
CloseKeyButton.Size = UDim2.new(0, 24, 0, 24)
CloseKeyButton.Position = UDim2.new(1, -34, 0, 10)
CloseKeyButton.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
CloseKeyButton.Text = "X"
CloseKeyButton.TextColor3 = Color3.fromRGB(255, 255, 255)
CloseKeyButton.TextSize = 14
CloseKeyButton.Font = Enum.Font.SourceSans
CloseKeyButton.BackgroundTransparency = 0
CloseKeyButton.TextTransparency = 0
CloseKeyButton.Parent = KeySystemFrame

local CloseKeyCorner = Instance.new("UICorner")
CloseKeyCorner.CornerRadius = UDim.new(0, 5)
CloseKeyCorner.Parent = CloseKeyButton

local FeedbackLabel = Instance.new("TextLabel")
FeedbackLabel.Size = UDim2.new(0, 300, 0, 30)
FeedbackLabel.Position = UDim2.new(0.5, -150, 0.6, 0)
FeedbackLabel.BackgroundTransparency = 1
FeedbackLabel.Text = ""
FeedbackLabel.TextColor3 = Color3.fromRGB(147, 112, 219)
FeedbackLabel.TextSize = 14
FeedbackLabel.Font = Enum.Font.SourceSans
FeedbackLabel.TextTransparency = 1
FeedbackLabel.Parent = KeySystemFrame

local function ShowFeedback(text, color)
    FeedbackLabel.Text = text
    FeedbackLabel.TextColor3 = color
    local fadeIn = TweenService:Create(FeedbackLabel, TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {TextTransparency = 0})
    fadeIn:Play()
    fadeIn.Completed:Connect(function()
        wait(2)
        local fadeOut = TweenService:Create(FeedbackLabel, TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {TextTransparency = 1})
        fadeOut:Play()
    end)
end

local CorrectKey = "X"
local isKeySystemActive = true

MainFrame.BackgroundTransparency = 1
Title.TextTransparency = 1
ToggleButton.TextTransparency = 1

GetKeyButton.MouseButton1Click:Connect(function()
    local message = "Свяжитесь с @XHubCreator в Telegram для получения ключа."
    pcall(function()
        setclipboard(message)
        ShowFeedback("Сообщение скопировано!", Color3.fromRGB(147, 112, 219))
    end)
end)

ActivateButton.MouseButton1Click:Connect(function()
    if not isKeySystemActive then return end
    local inputKey = KeyInput.Text
    if inputKey == "" then
        ShowFeedback("Введите ключ.", Color3.fromRGB(255, 0, 0))
    elseif inputKey == CorrectKey then
        ShowFeedback("Ключ активирован!", Color3.fromRGB(147, 112, 219))
        wait(1)
        isKeySystemActive = false

        local fadeOutFrame = TweenService:Create(KeySystemFrame, TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {BackgroundTransparency = 1})
        local fadeOutTitle = TweenService:Create(KeySystemTitle, TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {TextTransparency = 1})
        local fadeOutInputFrame = TweenService:Create(KeyInputFrame, TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {BackgroundTransparency = 1})
        local fadeOutInputStroke = TweenService:Create(KeyInputStroke, TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {Transparency = 1})
        local fadeOutInput = TweenService:Create(KeyInput, TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {TextTransparency = 1})
        local fadeOutActivate = TweenService:Create(ActivateButton, TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {BackgroundTransparency = 1, TextTransparency = 1})
        local fadeOutActivateStroke = TweenService:Create(ActivateStroke, TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {Transparency = 1})
        local fadeOutGetKey = TweenService:Create(GetKeyButton, TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {BackgroundTransparency = 1, TextTransparency = 1})
        local fadeOutGetKeyStroke = TweenService:Create(GetKeyStroke, TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {Transparency = 1})
        local fadeOutCloseKey = TweenService:Create(CloseKeyButton, TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {BackgroundTransparency = 1, TextTransparency = 1})

        fadeOutFrame:Play()
        fadeOutTitle:Play()
        fadeOutInputFrame:Play()
        fadeOutInputStroke:Play()
        fadeOutInput:Play()
        fadeOutActivate:Play()
        fadeOutActivateStroke:Play()
        fadeOutGetKey:Play()
        fadeOutGetKeyStroke:Play()
        fadeOutCloseKey:Play()

        local fadeInMainFrame = TweenService:Create(MainFrame, TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {BackgroundTransparency = 0})
        local fadeInTitle = TweenService:Create(Title, TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {TextTransparency = 0})
        local fadeInToggleButton = TweenService:Create(ToggleButton, TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {TextTransparency = 0})

        fadeOutFrame.Completed:Connect(function()
            KeySystemGUI:Destroy()
            MainFrame.Active = true
            fadeInMainFrame:Play()
            fadeInTitle:Play()
            fadeInToggleButton:Play()
            UpdateCanvasSize()
        end)
    else
        ShowFeedback("Неверный ключ.", Color3.fromRGB(255, 0, 0))
    end
end)

CloseKeyButton.MouseButton1Click:Connect(function()
    local fadeOutFrame = TweenService:Create(KeySystemFrame, TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {BackgroundTransparency = 1})
    local fadeOutTitle = TweenService:Create(KeySystemTitle, TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {TextTransparency = 1})
    local fadeOutInputFrame = TweenService:Create(KeyInputFrame, TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {BackgroundTransparency = 1})
    local fadeOutInputStroke = TweenService:Create(KeyInputStroke, TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {Transparency = 1})
    local fadeOutInput = TweenService:Create(KeyInput, TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {TextTransparency = 1})
    local fadeOutActivate = TweenService:Create(ActivateButton, TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {BackgroundTransparency = 1, TextTransparency = 1})
    local fadeOutActivateStroke = TweenService:Create(ActivateStroke, TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {Transparency = 1})
    local fadeOutGetKey = TweenService:Create(GetKeyButton, TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {BackgroundTransparency = 1, TextTransparency = 1})
    local fadeOutGetKeyStroke = TweenService:Create(GetKeyStroke, TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {Transparency = 1})
    local fadeOutCloseKey = TweenService:Create(CloseKeyButton, TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {BackgroundTransparency = 1, TextTransparency = 1})

    fadeOutFrame:Play()
    fadeOutTitle:Play()
    fadeOutInputFrame:Play()
    fadeOutInputStroke:Play()
    fadeOutInput:Play()
    fadeOutActivate:Play()
    fadeOutActivateStroke:Play()
    fadeOutGetKey:Play()
    fadeOutGetKeyStroke:Play()
    fadeOutCloseKey:Play()

    fadeOutFrame.Completed:Connect(function()
        KeySystemGUI:Destroy()
        XHubGUI:Destroy()
    end)
end)
