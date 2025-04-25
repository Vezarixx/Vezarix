-- Импорт сервисов
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local HttpService = game:GetService("HttpService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local StarterGui = game:GetService("StarterGui")

-- Глобальные настройки
local Settings = {
    SpeedBoost = {Enabled = false, Value = 50, Min = 0, Max = 1000000},
    JumpBoost = {Enabled = false, Value = 50, Min = 0, Max = 1000000},
    FOVBoost = {Enabled = false, Value = 90, Min = 30, Max = 120},
    Noclip = {Enabled = false},
    ESP = {Enabled = false, Transparency = 0.5, Color = Color3.fromRGB(255, 255, 255), Mode = "AlwaysOnTop"},
    InfiniteJump = {Enabled = false},
    Doors = {
        GodMode = {Enabled = false},
        AutoInteract = {Enabled = false},
        EntityESP = {Enabled = false},
        SpeedHack = {Enabled = false, Value = 50}
    }
}

-- Основной GUI
local XHubGUI = Instance.new("ScreenGui")
XHubGUI.Name = "XHub"
XHubGUI.Parent = game:GetService("CoreGui")
XHubGUI.IgnoreGuiInset = true
XHubGUI.DisplayOrder = 1000
XHubGUI.Enabled = true

-- Главный фрейм
local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 300, 0, 40)
MainFrame.Position = UDim2.new(0.5, -150, 0.5, -150)
MainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
MainFrame.BackgroundTransparency = 0
MainFrame.BorderSizePixel = 0
MainFrame.Parent = XHubGUI
MainFrame.Active = true
MainFrame.Draggable = true

-- Закругленные углы
local UICorner = Instance.new("UICorner")
UICorner.CornerRadius = UDim.new(0, 12)
UICorner.Parent = MainFrame

-- Тонкая белая обводка
local UIStroke = Instance.new("UIStroke")
UIStroke.Color = Color3.fromRGB(255, 255, 255)
UIStroke.Thickness = 1.5
UIStroke.Parent = MainFrame

-- Заголовок "X Hub"
local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(0.7, 0, 0, 40)
Title.Position = UDim2.new(0, 10, 0, 0)
Title.Text = "X Hub v3.0"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.TextSize = 22
Title.Font = Enum.Font.SourceSans
Title.BackgroundTransparency = 1
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.Parent = MainFrame

-- Кнопка сворачивания/разворачивания
local ToggleButton = Instance.new("TextButton")
ToggleButton.Size = UDim2.new(0, 30, 0, 30)
ToggleButton.Position = UDim2.new(1, -40, 0, 5)
ToggleButton.Text = "▼"
ToggleButton.TextColor3 = Color3.fromRGB(255, 255, 255)
ToggleButton.TextSize = 18
ToggleButton.BackgroundTransparency = 1
ToggleButton.Parent = MainFrame

-- Анимация появления заголовка
local titleFadeIn = TweenService:Create(Title, TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {TextTransparency = 0})
titleFadeIn:Play()

-- Фрейм для прокрутки
local ScrollFrame = Instance.new("ScrollingFrame")
ScrollFrame.Size = UDim2.new(1, 0, 1, -40)
ScrollFrame.Position = UDim2.new(0, 0, 0, 40)
ScrollFrame.BackgroundTransparency = 1
ScrollFrame.ScrollBarThickness = 6
ScrollFrame.ScrollBarImageColor3 = Color3.fromRGB(255, 255, 255)
ScrollFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
ScrollFrame.ScrollingDirection = Enum.ScrollingDirection.Y
ScrollFrame.Visible = false
ScrollFrame.Parent = MainFrame

-- UIListLayout для прокрутки
local UIListLayout = Instance.new("UIListLayout")
UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
UIListLayout.Padding = UDim.new(0, 8)
UIListLayout.Parent = ScrollFrame

-- Функция для обновления CanvasSize
local function UpdateCanvasSize()
    local totalHeight = 0
    for _, child in pairs(ScrollFrame:GetChildren()) do
        if child:IsA("Frame") then
            totalHeight = totalHeight + child.Size.Y.Offset + UIListLayout.Padding.Offset
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
NotificationListLayout.Padding = UDim.new(0, 8)
NotificationListLayout.VerticalAlignment = Enum.VerticalAlignment.Bottom
NotificationListLayout.Parent = NotificationContainer

local function CreateNotification(category, funcName, enabled)
    local NotificationFrame = Instance.new("Frame")
    NotificationFrame.Size = UDim2.new(1, 0, 0, 60)
    NotificationFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
    NotificationFrame.BackgroundTransparency = 1
    NotificationFrame.Parent = NotificationContainer

    local NotifCorner = Instance.new("UICorner")
    NotifCorner.CornerRadius = UDim.new(0, 12)
    NotifCorner.Parent = NotificationFrame

    local NotifStroke = Instance.new("UIStroke")
    NotifStroke.Color = Color3.fromRGB(255, 255, 255)
    NotifStroke.Thickness = 1.5
    NotifStroke.Transparency = 1
    NotifStroke.Parent = NotificationFrame

    local NotifTitle = Instance.new("TextLabel")
    NotifTitle.Size = UDim2.new(1, -20, 0, 20)
    NotifTitle.Position = UDim2.new(0, 10, 0, 5)
    NotifTitle.Text = "Уведомление"
    NotifTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
    NotifTitle.TextSize = 16
    NotifTitle.Font = Enum.Font.SourceSans
    NotifTitle.BackgroundTransparency = 1
    NotifTitle.TextXAlignment = Enum.TextXAlignment.Left
    NotifTitle.TextTransparency = 1
    NotifTitle.Parent = NotificationFrame

    local NotifText = Instance.new("TextLabel")
    NotifText.Size = UDim2.new(1, -20, 0, 30)
    NotifText.Position = UDim2.new(0, 10, 0, 25)
    NotifText.Text = (enabled and "Включено: " or "Выключено: ") .. category .. " - " .. funcName
    NotifText.TextColor3 = Color3.fromRGB(255, 255, 255)
    NotifText.TextSize = 14
    NotifText.Font = Enum.Font.SourceSans
    NotifText.BackgroundTransparency = 1
    NotifText.TextXAlignment = Enum.TextXAlignment.Left
    NotifText.TextTransparency = 1
    NotifText.Parent = NotificationFrame

    -- Анимация появления
    local fadeInFrame = TweenService:Create(NotificationFrame, TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {BackgroundTransparency = 0})
    local fadeInStroke = TweenService:Create(NotifStroke, TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Transparency = 0})
    local fadeInTitle = TweenService:Create(NotifTitle, TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {TextTransparency = 0})
    local fadeInText = TweenService:Create(NotifText, TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {TextTransparency = 0})
    fadeInFrame:Play()
    fadeInStroke:Play()
    fadeInTitle:Play()
    fadeInText:Play()

    -- Анимация исчезновения
    spawn(function()
        wait(3)
        local fadeOutFrame = TweenService:Create(NotificationFrame, TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {BackgroundTransparency = 1})
        local fadeOutStroke = TweenService:Create(NotifStroke, TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {Transparency = 1})
        local fadeOutTitle = TweenService:Create(NotifTitle, TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {TextTransparency = 1})
        local fadeOutText = TweenService:Create(NotifText, TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {TextTransparency = 1})
        fadeOutFrame:Play()
        fadeOutStroke:Play()
        fadeOutTitle:Play()
        fadeOutText:Play()
        fadeOutFrame.Completed:Connect(function()
            NotificationFrame:Destroy()
        end)
    end)
end

-- Категории
local Categories = {
    {Name = "Движение", Functions = {
        {Name = "Скорость", Setting = Settings.SpeedBoost, HasInput = true},
        {Name = "Прыжок", Setting = Settings.JumpBoost, HasInput = true},
        {Name = "Бесконечный Прыжок", Setting = Settings.InfiniteJump}
    }},
    {Name = "Визуал", Functions = {
        {Name = "ESP", Setting = Settings.ESP, HasSettings = true},
        {Name = "FOV", Setting = Settings.FOVBoost, HasInput = true}
    }},
    {Name = "Другое", Functions = {
        {Name = "Noclip", Setting = Settings.Noclip},
        {Name = "Перезайти", Action = function()
            local success, servers = pcall(HttpService.JSONDecode, HttpService, game:HttpGet("https://games.roblox.com/v1/games/" .. game.PlaceId .. "/servers/Public?sortOrder=Asc&limit=100"))
            if success and servers.data then
                for _, server in pairs(servers.data) do
                    if server.playing < server.maxPlayers and server.playing > 0 then
                        game:GetService("TeleportService"):TeleportToPlaceInstance(game.PlaceId, server.id)
                        break
                    end
                end
            else
                CreateNotification("Другое", "Перезайти", false, "Ошибка при получении серверов")
            end
        end}
    }},
    {Name = "DOORS", Functions = {
        {Name = "God Mode", Setting = Settings.Doors.GodMode},
        {Name = "Auto Interact", Setting = Settings.Doors.AutoInteract},
        {Name = "Entity ESP", Setting = Settings.Doors.EntityESP},
        {Name = "Speed Hack", Setting = Settings.Doors.SpeedHack, HasInput = true}
    }}
}

-- Создание категорий
for i, category in pairs(Categories) do
    local CategoryFrame = Instance.new("Frame")
    CategoryFrame.Size = UDim2.new(1, 0, 0, 40)
    CategoryFrame.BackgroundTransparency = 1
    CategoryFrame.LayoutOrder = i
    CategoryFrame.Parent = ScrollFrame

    local CategoryLabel = Instance.new("TextLabel")
    CategoryLabel.Size = UDim2.new(0.7, 0, 1, 0)
    CategoryLabel.Position = UDim2.new(0, 10, 0, 0)
    CategoryLabel.Text = category.Name
    CategoryLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    CategoryLabel.TextSize = 18
    CategoryLabel.Font = Enum.Font.SourceSans
    CategoryLabel.BackgroundTransparency = 1
    CategoryLabel.TextXAlignment = Enum.TextXAlignment.Left
    CategoryLabel.Parent = CategoryFrame

    local CategoryToggleButton = Instance.new("TextButton")
    CategoryToggleButton.Size = UDim2.new(0, 30, 0, 30)
    CategoryToggleButton.Position = UDim2.new(1, -40, 0, 5)
    CategoryToggleButton.Text = "▼"
    CategoryToggleButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    CategoryToggleButton.TextSize = 16
    CategoryToggleButton.BackgroundTransparency = 1
    CategoryToggleButton.Parent = CategoryFrame

    local FunctionsFrame = Instance.new("Frame")
    FunctionsFrame.Size = UDim2.new(1, 0, 0, 0)
    FunctionsFrame.Position = UDim2.new(0, 0, 0, 40)
    FunctionsFrame.BackgroundTransparency = 1
    FunctionsFrame.ClipsDescendants = true
    FunctionsFrame.Parent = CategoryFrame

    local FunctionsListLayout = Instance.new("UIListLayout")
    FunctionsListLayout.SortOrder = Enum.SortOrder.LayoutOrder
    FunctionsListLayout.Padding = UDim.new(0, 8)
    FunctionsListLayout.Parent = FunctionsFrame

    -- Создание функций в категории
    for j, func in pairs(category.Functions) do
        local FuncFrame = Instance.new("Frame")
        local height = 40
        if func.HasInput then height = height + 35 end
        FuncFrame.Size = UDim2.new(1, -10, 0, height)
        FuncFrame.BackgroundTransparency = 1
        FuncFrame.LayoutOrder = j
        FuncFrame.Parent = FunctionsFrame

        local FuncLabel = Instance.new("TextLabel")
        FuncLabel.Size = UDim2.new(0.7, 0, 0, 40)
        FuncLabel.Position = UDim2.new(0, 10, 0, 0)
        FuncLabel.Text = func.Name
        FuncLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
        FuncLabel.TextSize = 16
        FuncLabel.Font = Enum.Font.SourceSans
        FuncLabel.BackgroundTransparency = 1
        FuncLabel.TextXAlignment = Enum.TextXAlignment.Left
        FuncLabel.Parent = FuncFrame

        if func.Name ~= "Перезайти" then
            local ToggleCircle = Instance.new("TextButton")
            ToggleCircle.Size = UDim2.new(0, 24, 0, 24)
            ToggleCircle.Position = UDim2.new(1, -34, 0, 8)
            ToggleCircle.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
            ToggleCircle.Text = ""
            ToggleCircle.Parent = FuncFrame

            local CircleCorner = Instance.new("UICorner")
            CircleCorner.CornerRadius = UDim.new(1, 0)
            CircleCorner.Parent = ToggleCircle

            local CircleStroke = Instance.new("UIStroke")
            CircleStroke.Color = Color3.fromRGB(255, 255, 255)
            CircleStroke.Thickness = 1.5
            CircleStroke.Parent = ToggleCircle

            local function UpdateToggle()
                ToggleCircle.BackgroundColor3 = func.Setting.Enabled and Color3.fromRGB(150, 150, 150) or Color3.fromRGB(255, 255, 255)
            end

            ToggleCircle.MouseButton1Click:Connect(function()
                func.Setting.Enabled = not func.Setting.Enabled
                UpdateToggle()
                CreateNotification(category.Name, func.Name, func.Setting.Enabled)
            end)

            UpdateToggle()

            if func.HasInput then
                local InputField = Instance.new("TextBox")
                InputField.Size = UDim2.new(0.8, -20, 0, 30)
                InputField.Position = UDim2.new(0, 10, 0, 45)
                InputField.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
                InputField.Text = tostring(func.Setting.Value)
                InputField.TextColor3 = Color3.fromRGB(255, 255, 255)
                InputField.TextSize = 14
                InputField.Font = Enum.Font.SourceSans
                InputField.Parent = FuncFrame

                local InputCorner = Instance.new("UICorner")
                InputCorner.CornerRadius = UDim.new(0, 8)
                InputCorner.Parent = InputField

                local InputStroke = Instance.new("UIStroke")
                InputStroke.Color = Color3.fromRGB(255, 255, 255)
                InputStroke.Thickness = 1.5
                InputStroke.Parent = InputField

                InputField.FocusLost:Connect(function(enterPressed)
                    if enterPressed then
                        local value = tonumber(InputField.Text)
                        if value then
                            func.Setting.Value = math.clamp(value, func.Setting.Min or 0, func.Setting.Max or 1000)
                            InputField.Text = tostring(func.Setting.Value)
                        else
                            InputField.Text = tostring(func.Setting.Value)
                        end
                    end
                end)
            end

            if func.HasSettings then
                local SettingsButton = Instance.new("TextButton")
                SettingsButton.Size = UDim2.new(0, 24, 0, 24)
                SettingsButton.Position = UDim2.new(1, -64, 0, 8)
                SettingsButton.Text = "⚙"
                SettingsButton.TextColor3 = Color3.fromRGB(255, 255, 255)
                SettingsButton.BackgroundTransparency = 1
                SettingsButton.Parent = FuncFrame

                local SettingsFrame = nil

                SettingsButton.MouseButton1Click:Connect(function()
                    if SettingsFrame then
                        local fadeOutSettings = TweenService:Create(SettingsFrame, TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {BackgroundTransparency = 1})
                        local fadeOutStroke = TweenService:Create(SettingsFrame:FindFirstChild("UIStroke"), TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {Transparency = 1})
                        local fadeOutTitle = TweenService:Create(SettingsFrame:FindFirstChild("SettingsTitle"), TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {TextTransparency = 1})
                        local fadeOutCloseButton = TweenService:Create(SettingsFrame:FindFirstChild("CloseButton"), TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {TextTransparency = 1})
                        local fadeOutColorButton = TweenService:Create(SettingsFrame:FindFirstChild("ColorButton"), TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {BackgroundTransparency = 1, TextTransparency = 1})
                        local fadeOutModeButton = TweenService:Create(SettingsFrame:FindFirstChild("ModeButton"), TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {BackgroundTransparency = 1, TextTransparency = 1})

                        fadeOutSettings:Play()
                        fadeOutStroke:Play()
                        fadeOutTitle:Play()
                        fadeOutCloseButton:Play()
                        fadeOutColorButton:Play()
                        fadeOutModeButton:Play()

                        fadeOutSettings.Completed:Connect(function()
                            SettingsFrame:Destroy()
                            SettingsFrame = nil
                        end)
                        return
                    end

                    SettingsFrame = Instance.new("Frame")
                    SettingsFrame.Name = "ESPSettings"
                    SettingsFrame.Size = UDim2.new(0, 200, 0, 140)
                    SettingsFrame.Position = UDim2.new(0.5, -100, 0.5, -70)
                    SettingsFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
                    SettingsFrame.BackgroundTransparency = 1
                    SettingsFrame.Parent = XHubGUI
                    SettingsFrame.Active = true
                    SettingsFrame.Draggable = true

                    local SettingsCorner = Instance.new("UICorner")
                    SettingsCorner.CornerRadius = UDim.new(0, 12)
                    SettingsCorner.Parent = SettingsFrame

                    local SettingsStroke = Instance.new("UIStroke")
                    SettingsStroke.Color = Color3.fromRGB(255, 255, 255)
                    SettingsStroke.Thickness = 1.5
                    SettingsStroke.Transparency = 1
                    SettingsStroke.Parent = SettingsFrame

                    local SettingsTitle = Instance.new("TextLabel")
                    SettingsTitle.Name = "SettingsTitle"
                    SettingsTitle.Size = UDim2.new(1, 0, 0, 30)
                    SettingsTitle.Position = UDim2.new(0, 0, 0, 0)
                    SettingsTitle.Text = "Настройка ESP"
                    SettingsTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
                    SettingsTitle.TextSize = 18
                    SettingsTitle.Font = Enum.Font.SourceSans
                    SettingsTitle.BackgroundTransparency = 1
                    SettingsTitle.TextXAlignment = Enum.TextXAlignment.Center
                    SettingsTitle.TextTransparency = 1
                    SettingsTitle.Parent = SettingsFrame

                    local CloseButton = Instance.new("TextButton")
                    CloseButton.Name = "CloseButton"
                    CloseButton.Size = UDim2.new(0, 30, 0, 30)
                    CloseButton.Position = UDim2.new(1, -40, 0, 0)
                    CloseButton.Text = "X"
                    CloseButton.TextColor3 = Color3.fromRGB(255, 255, 255)
                    CloseButton.TextSize = 18
                    CloseButton.BackgroundTransparency = 1
                    CloseButton.TextTransparency = 1
                    CloseButton.Parent = SettingsFrame

                    CloseButton.MouseButton1Click:Connect(function()
                        local fadeOutSettings = TweenService:Create(SettingsFrame, TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {BackgroundTransparency = 1})
                        local fadeOutStroke = TweenService:Create(SettingsStroke, TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {Transparency = 1})
                        local fadeOutTitle = TweenService:Create(SettingsTitle, TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {TextTransparency = 1})
                        local fadeOutCloseButton = TweenService:Create(CloseButton, TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {TextTransparency = 1})
                        local fadeOutColorButton = TweenService:Create(SettingsFrame:FindFirstChild("ColorButton"), TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {BackgroundTransparency = 1, TextTransparency = 1})
                        local fadeOutModeButton = TweenService:Create(SettingsFrame:FindFirstChild("ModeButton"), TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {BackgroundTransparency = 1, TextTransparency = 1})

                        fadeOutSettings:Play()
                        fadeOutStroke:Play()
                        fadeOutTitle:Play()
                        fadeOutCloseButton:Play()
                        fadeOutColorButton:Play()
                        fadeOutModeButton:Play()

                        fadeOutSettings.Completed:Connect(function()
                            SettingsFrame:Destroy()
                            SettingsFrame = nil
                        end)
                    end)

                    local ColorButton = Instance.new("TextButton")
                    ColorButton.Name = "ColorButton"
                    ColorButton.Size = UDim2.new(0, 160, 0, 30)
                    ColorButton.Position = UDim2.new(0, 20, 0, 40)
                    ColorButton.BackgroundColor3 = func.Setting.Color
                    ColorButton.Text = "Цвет ESP"
                    ColorButton.TextColor3 = Color3.fromRGB(255, 255, 255)
                    ColorButton.TextSize = 14
                    ColorButton.Font = Enum.Font.SourceSans
                    ColorButton.BackgroundTransparency = 1
                    ColorButton.TextTransparency = 1
                    ColorButton.Parent = SettingsFrame

                    local ColorCorner = Instance.new("UICorner")
                    ColorCorner.CornerRadius = UDim.new(0, 8)
                    ColorCorner.Parent = ColorButton

                    ColorButton.MouseButton1Click:Connect(function()
                        local r = math.random(0, 255)
                        local g = math.random(0, 255)
                        local b = math.random(0, 255)
                        func.Setting.Color = Color3.fromRGB(r, g, b)
                        ColorButton.BackgroundColor3 = func.Setting.Color
                    end)

                    local ModeButton = Instance.new("TextButton")
                    ModeButton.Name = "ModeButton"
                    ModeButton.Size = UDim2.new(0, 160, 0, 30)
                    ModeButton.Position = UDim2.new(0, 20, 0, 80)
                    ModeButton.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
                    ModeButton.Text = "Режим: " .. (func.Setting.Mode == "AlwaysOnTop" and "AOT" or "TW")
                    ModeButton.TextColor3 = Color3.fromRGB(255, 255, 255)
                    ModeButton.TextSize = 14
                    ModeButton.Font = Enum.Font.SourceSans
                    ModeButton.BackgroundTransparency = 1
                    ModeButton.TextTransparency = 1
                    ModeButton.Parent = SettingsFrame

                    local ModeCorner = Instance.new("UICorner")
                    ModeCorner.CornerRadius = UDim.new(0, 8)
                    ModeCorner.Parent = ModeButton

                    ModeButton.MouseButton1Click:Connect(function()
                        func.Setting.Mode = func.Setting.Mode == "AlwaysOnTop" and "ThroughWalls" or "AlwaysOnTop"
                        ModeButton.Text = "Режим: " .. (func.Setting.Mode == "AlwaysOnTop" and "AOT" or "TW")
                    end)

                    local fadeInSettings = TweenService:Create(SettingsFrame, TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {BackgroundTransparency = 0})
                    local fadeInStroke = TweenService:Create(SettingsStroke, TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Transparency = 0})
                    local fadeInTitle = TweenService:Create(SettingsTitle, TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {TextTransparency = 0})
                    local fadeInCloseButton = TweenService:Create(CloseButton, TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {TextTransparency = 0})
                    local fadeInColorButton = TweenService:Create(ColorButton, TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {BackgroundTransparency = 0, TextTransparency = 0})
                    local fadeInModeButton = TweenService:Create(ModeButton, TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {BackgroundTransparency = 0, TextTransparency = 0})

                    fadeInSettings:Play()
                    fadeInStroke:Play()
                    fadeInTitle:Play()
                    fadeInCloseButton:Play()
                    fadeInColorButton:Play()
                    fadeInModeButton:Play()
                end)
            end
        else
            local RejoinButton = Instance.new("TextButton")
            RejoinButton.Size = UDim2.new(0, 30, 0, 30)
            RejoinButton.Position = UDim2.new(1, -40, 0, 5)
            RejoinButton.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
            RejoinButton.Text = "↻"
            RejoinButton.TextColor3 = Color3.fromRGB(255, 255, 255)
            RejoinButton.TextSize = 16
            RejoinButton.Font = Enum.Font.SourceSans
            RejoinButton.Parent = FuncFrame

            local RejoinCorner = Instance.new("UICorner")
            RejoinCorner.CornerRadius = UDim.new(1, 0)
            RejoinCorner.Parent = RejoinButton

            RejoinButton.MouseButton1Click:Connect(func.Action)
        end
    end

    local IsCategoryExpanded = false
    CategoryToggleButton.MouseButton1Click:Connect(function()
        IsCategoryExpanded = not IsCategoryExpanded
        local funcHeight = 0
        for _, func in pairs(category.Functions) do
            local height = 40
            if func.HasInput then height = height + 35 end
            funcHeight = funcHeight + height + FunctionsListLayout.Padding.Offset
        end
        local newHeight = IsCategoryExpanded and UDim2.new(1, 0, 0, funcHeight) or UDim2.new(1, 0, 0, 0)
        local tweenInfo = TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
        local tween = TweenService:Create(FunctionsFrame, tweenInfo, {Size = newHeight})
        tween:Play()
        CategoryToggleButton.Text = IsCategoryExpanded and "▲" or "▼"
        CategoryFrame.Size = IsCategoryExpanded and UDim2.new(1, 0, 0, 40 + funcHeight) or UDim2.new(1, 0, 0, 40)
        UpdateCanvasSize()
        if category.Name == "DOORS" and IsCategoryExpanded then
            CreateNotification(category.Name, "Открыто", false)
        end
    end)
end

-- Инициализация CanvasSize
UpdateCanvasSize()

-- Анимация сворачивания/разворачивания меню
local IsExpanded = false
ToggleButton.MouseButton1Click:Connect(function()
    IsExpanded = not IsExpanded
    local newSize = IsExpanded and UDim2.new(0, 300, 0, 400) or UDim2.new(0, 300, 0, 40)
    local tweenInfo = TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
    local tween = TweenService:Create(MainFrame, tweenInfo, {Size = newSize})
    tween:Play()
    ToggleButton.Text = IsExpanded and "▲" or "▼"
    ScrollFrame.Visible = IsExpanded
end)

-- Функционал Speed Boost
local function UpdateSpeedBoost()
    local character = Players.LocalPlayer.Character
    local humanoid = character and character:FindFirstChildOfClass("Humanoid")
    if humanoid then
        humanoid.WalkSpeed = Settings.SpeedBoost.Enabled and Settings.SpeedBoost.Value or 16
    end
end

-- Функционал Jump Boost
local function UpdateJumpBoost()
    local character = Players.LocalPlayer.Character
    local humanoid = character and character:FindFirstChildOfClass("Humanoid")
    if humanoid then
        humanoid.JumpPower = Settings.JumpBoost.Enabled and Settings.JumpBoost.Value or 50
    end
end

-- Функционал FOV Boost
local function UpdateFOVBoost()
    local camera = workspace.CurrentCamera
    if camera then
        camera.FieldOfView = Settings.FOVBoost.Enabled and Settings.FOVBoost.Value or 70
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
        if character then
            for _, part in pairs(character:GetDescendants()) do
                if part:IsA("BasePart") then
                    part.CanCollide = false
                end
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
    if character then
        for _, part in pairs(character:GetDescendants()) do
            if part:IsA("BasePart") then
                part.CanCollide = true
            end
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

-- Функционал ESP
local ESPObjects = {}
local function CreateESP(player)
    if player == Players.LocalPlayer or ESPObjects[player] then return end
    local character = player.Character
    if not character then return end
    local highlight = Instance.new("Highlight")
    highlight.FillTransparency = Settings.ESP.Transparency
    highlight.FillColor = Settings.ESP.Color
    highlight.OutlineTransparency = 0
    highlight.OutlineColor = Color3.fromRGB(255, 255, 255)
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
            highlight.FillColor = Settings.ESP.Color
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
            local humanoid = character and character:FindFirstChildOfClass("Humanoid")
            if humanoid then
                humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
            end
        end)
    end
end

-- Функции для DOORS
local function UpdateDoorsGodMode()
    if Settings.Doors.GodMode.Enabled then
        local character = Players.LocalPlayer.Character
        local humanoid = character and character:FindFirstChildOfClass("Humanoid")
        if humanoid then
            humanoid.MaxHealth = math.huge
            humanoid.Health = math.huge
        end
    end
end

local function UpdateDoorsAutoInteract()
    if Settings.Doors.AutoInteract.Enabled then
        local character = Players.LocalPlayer.Character
        local rootPart = character and character:FindFirstChild("HumanoidRootPart")
        if rootPart then
            for _, obj in pairs(workspace:GetDescendants()) do
                if obj:IsA("ProximityPrompt") then
                    local distance = (obj.Parent.Position - rootPart.Position).Magnitude
                    if distance < 10 then
                        fireproximityprompt(obj)
                    end
                end
            end
        end
    end
end

local DoorsESPObjects = {}
local function CreateDoorsESP()
    for _, obj in pairs(workspace:GetDescendants()) do
        if obj:IsA("Model") and obj.Name:match("Rush") or obj.Name:match("Ambush") or obj.Name:match("Seek") or obj.Name:match("Screech") then
            if not DoorsESPObjects[obj] then
                local highlight = Instance.new("Highlight")
                highlight.FillTransparency = 0.5
                highlight.FillColor = Color3.fromRGB(255, 0, 0)
                highlight.OutlineTransparency = 0
                highlight.OutlineColor = Color3.fromRGB(255, 255, 255)
                highlight.Adornee = obj
                highlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
                highlight.Parent = obj
                DoorsESPObjects[obj] = highlight
            end
        end
    end
end

local function UpdateDoorsESP()
    if not Settings.Doors.EntityESP.Enabled then
        for _, highlight in pairs(DoorsESPObjects) do
            highlight.Enabled = false
        end
        return
    end
    for obj, highlight in pairs(DoorsESPObjects) do
        if obj.Parent then
            highlight.Enabled = true
        else
            highlight:Destroy()
            DoorsESPObjects[obj] = nil
        end
    end
    CreateDoorsESP()
end

local function UpdateDoorsSpeedHack()
    local character = Players.LocalPlayer.Character
    local humanoid = character and character:FindFirstChildOfClass("Humanoid")
    if humanoid then
        humanoid.WalkSpeed = Settings.Doors.SpeedHack.Enabled and Settings.Doors.SpeedHack.Value or 15
    end
end

-- Обновление функций
RunService.Heartbeat:Connect(function()
    pcall(UpdateSpeedBoost)
    pcall(UpdateJumpBoost)
    pcall(UpdateFOVBoost)
    pcall(UpdateNoclip)
    pcall(UpdateESP)
    pcall(UpdateInfiniteJump)
    pcall(UpdateDoorsGodMode)
    pcall(UpdateDoorsAutoInteract)
    pcall(UpdateDoorsESP)
    pcall(UpdateDoorsSpeedHack)
end)

Players.LocalPlayer.CharacterAdded:Connect(function()
    pcall(UpdateSpeedBoost)
    pcall(UpdateJumpBoost)
    pcall(UpdateNoclip)
    pcall(UpdateDoorsGodMode)
    pcall(UpdateDoorsSpeedHack)
end)

Players.PlayerAdded:Connect(function(player)
    player.CharacterAdded:Connect(function()
        if Settings.ESP.Enabled then
            pcall(CreateESP, player)
        end
    end)
end)

Players.PlayerRemoving:Connect(function(player)
    if ESPObjects[player] then
        ESPObjects[player]:Destroy()
        ESPObjects[player] = nil
    end
end)

-- Ключ-система
local KeySystemGUI = Instance.new("ScreenGui")
KeySystemGUI.Name = "XKeySystem"
KeySystemGUI.Parent = game:GetService("CoreGui")
KeySystemGUI.IgnoreGuiInset = true
KeySystemGUI.DisplayOrder = 9999

local KeySystemFrame = Instance.new("Frame")
KeySystemFrame.Size = UDim2.new(1, 0, 1, 0)
KeySystemFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
KeySystemFrame.BackgroundTransparency = 1
KeySystemFrame.Parent = KeySystemGUI

local fadeInFrame = TweenService:Create(KeySystemFrame, TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {BackgroundTransparency = 0})
fadeInFrame:Play()

local KeySystemTitle = Instance.new("TextLabel")
KeySystemTitle.Size = UDim2.new(0, 400, 0, 50)
KeySystemTitle.Position = UDim2.new(0.5, -200, 0.2, -25)
KeySystemTitle.Text = "КЛЮЧ СИСТЕМА X HUB • 3.0.0"
KeySystemTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
KeySystemTitle.TextSize = 24
KeySystemTitle.Font = Enum.Font.SourceSans
KeySystemTitle.BackgroundTransparency = 1
KeySystemTitle.TextTransparency = 1
KeySystemTitle.Parent = KeySystemFrame

local fadeInTitle = TweenService:Create(KeySystemTitle, TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {TextTransparency = 0})
fadeInTitle:Play()

local KeyInputFrame = Instance.new("Frame")
KeyInputFrame.Size = UDim2.new(0, 300, 0, 40)
KeyInputFrame.Position = UDim2.new(0.5, -150, 0.4, -20)
KeyInputFrame.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
KeyInputFrame.BackgroundTransparency = 1
KeyInputFrame.Parent = KeySystemFrame

local KeyInputCorner = Instance.new("UICorner")
KeyInputCorner.CornerRadius = UDim.new(0, 12)
KeyInputCorner.Parent = KeyInputFrame

local KeyInputStroke = Instance.new("UIStroke")
KeyInputStroke.Color = Color3.fromRGB(255, 255, 255)
KeyInputStroke.Thickness = 1.5
KeyInputStroke.Transparency = 1
KeyInputStroke.Parent = KeyInputFrame

local KeyInput = Instance.new("TextBox")
KeyInput.Size = UDim2.new(1, -20, 1, -10)
KeyInput.Position = UDim2.new(0, 10, 0, 5)
KeyInput.BackgroundTransparency = 1
KeyInput.Text = ""
KeyInput.PlaceholderText = "Ввести ключ"
KeyInput.PlaceholderColor3 = Color3.fromRGB(255, 255, 255)
KeyInput.TextColor3 = Color3.fromRGB(255, 255, 255)
KeyInput.TextSize = 16
KeyInput.Font = Enum.Font.SourceSans
KeyInput.TextTransparency = 1
KeyInput.Parent = KeyInputFrame

local fadeInInputFrame = TweenService:Create(KeyInputFrame, TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {BackgroundTransparency = 0})
local fadeInInputStroke = TweenService:Create(KeyInputStroke, TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Transparency = 0})
local fadeInInput = TweenService:Create(KeyInput, TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {TextTransparency = 0})
fadeInInputFrame:Play()
fadeInInputStroke:Play()
fadeInInput:Play()

local ActivateButton = Instance.new("TextButton")
ActivateButton.Size = UDim2.new(0, 140, 0, 40)
ActivateButton.Position = UDim2.new(0.5, -150, 0.5, 0)
ActivateButton.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
ActivateButton.Text = "Активировать ключ"
ActivateButton.TextColor3 = Color3.fromRGB(255, 255, 255)
ActivateButton.TextSize = 16
ActivateButton.Font = Enum.Font.SourceSans
ActivateButton.TextTransparency = 1
ActivateButton.BackgroundTransparency = 1
ActivateButton.Parent = KeySystemFrame

local ActivateCorner = Instance.new("UICorner")
ActivateCorner.CornerRadius = UDim.new(0, 12)
ActivateCorner.Parent = ActivateButton

local ActivateStroke = Instance.new("UIStroke")
ActivateStroke.Color = Color3.fromRGB(255, 255, 255)
ActivateStroke.Thickness = 1.5
ActivateStroke.Transparency = 1
ActivateStroke.Parent = ActivateButton

local fadeInActivateButton = TweenService:Create(ActivateButton, TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {BackgroundTransparency = 0, TextTransparency = 0})
local fadeInActivateStroke = TweenService:Create(ActivateStroke, TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Transparency = 0})
fadeInActivateButton:Play()
fadeInActivateStroke:Play()

local GetKeyButton = Instance.new("TextButton")
GetKeyButton.Size = UDim2.new(0, 140, 0, 40)
GetKeyButton.Position = UDim2.new(0.5, 10, 0.5, 0)
GetKeyButton.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
GetKeyButton.Text = "Получить ключ"
GetKeyButton.TextColor3 = Color3.fromRGB(255, 255, 255)
GetKeyButton.TextSize = 16
GetKeyButton.Font = Enum.Font.SourceSans
GetKeyButton.TextTransparency = 1
GetKeyButton.BackgroundTransparency = 1
GetKeyButton.Parent = KeySystemFrame

local GetKeyCorner = Instance.new("UICorner")
GetKeyCorner.CornerRadius = UDim.new(0, 12)
GetKeyCorner.Parent = GetKeyButton

local GetKeyStroke = Instance.new("UIStroke")
GetKeyStroke.Color = Color3.fromRGB(255, 255, 255)
GetKeyStroke.Thickness = 1.5
GetKeyStroke.Transparency = 1
GetKeyStroke.Parent = GetKeyButton

local fadeInGetKeyButton = TweenService:Create(GetKeyButton, TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {BackgroundTransparency = 0, TextTransparency = 0})
local fadeInGetKeyStroke = TweenService:Create(GetKeyStroke, TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Transparency = 0})
fadeInGetKeyButton:Play()
fadeInGetKeyStroke:Play()

local FeedbackLabel = Instance.new("TextLabel")
FeedbackLabel.Size = UDim2.new(0, 300, 0, 30)
FeedbackLabel.Position = UDim2.new(0.5, -150, 0.6, 0)
FeedbackLabel.BackgroundTransparency = 1
FeedbackLabel.Text = ""
FeedbackLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
FeedbackLabel.TextSize = 14
FeedbackLabel.Font = Enum.Font.SourceSans
FeedbackLabel.TextTransparency = 1
FeedbackLabel.Parent = KeySystemFrame

local function ShowFeedback(text, color)
    FeedbackLabel.Text = text
    FeedbackLabel.TextColor3 = color
    FeedbackLabel.TextTransparency = 1
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

MainFrame.Active = false
MainFrame.BackgroundTransparency = 1
Title.TextTransparency = 1
ToggleButton.TextTransparency = 1

GetKeyButton.MouseButton1Click:Connect(function()
    local message = "Вбейте юзернейм в телеграмм и напишите данному человеку чтобы он вам выдал данный ключ, вот юзернейм создателя скрипта: @XHubCreator."
    pcall(function()
        setclipboard(message)
        ShowFeedback("Текст скопирован в буфер обмена!", Color3.fromRGB(255, 255, 255))
    end)
end)

ActivateButton.MouseButton1Click:Connect(function()
    if not isKeySystemActive then return end
    local inputKey = KeyInput.Text
    if inputKey == "" then
        ShowFeedback("Пожалуйста, введите ключ.", Color3.fromRGB(255, 0, 0))
    elseif inputKey == CorrectKey then
        ShowFeedback("Ключ успешно активирован!", Color3.fromRGB(255, 255, 255))
        wait(1)
        isKeySystemActive = false

        local fadeOutFrame = TweenService:Create(KeySystemFrame, TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {BackgroundTransparency = 1})
        local fadeOutTitle = TweenService:Create(KeySystemTitle, TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {TextTransparency = 1})
        local fadeOutInputFrame = TweenService:Create(KeyInputFrame, TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {BackgroundTransparency = 1})
        local fadeOutInputStroke = TweenService:Create(KeyInputStroke, TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {Transparency = 1})
        local fadeOutInput = TweenService:Create(KeyInput, TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {TextTransparency = 1})
        local fadeOutActivateButton = TweenService:Create(ActivateButton, TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {BackgroundTransparency = 1, TextTransparency = 1})
        local fadeOutActivateStroke = TweenService:Create(ActivateStroke, TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {Transparency = 1})
        local fadeOutGetKeyButton = TweenService:Create(GetKeyButton, TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {BackgroundTransparency = 1, TextTransparency = 1})
        local fadeOutGetKeyStroke = TweenService:Create(GetKeyStroke, TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {Transparency = 1})

        fadeOutFrame:Play()
        fadeOutTitle:Play()
        fadeOutInputFrame:Play()
        fadeOutInputStroke:Play()
        fadeOutInput:Play()
        fadeOutActivateButton:Play()
        fadeOutActivateStroke:Play()
        fadeOutGetKeyButton:Play()
        fadeOutGetKeyStroke:Play()

        local fadeInMainFrame = TweenService:Create(MainFrame, TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {BackgroundTransparency = 0})
        local fadeInTitle = TweenService:Create(Title, TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {TextTransparency = 0})
        local fadeInToggleButton = TweenService:Create(ToggleButton, TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {TextTransparency = 0})

        fadeOutFrame.Completed:Connect(function()
            KeySystemGUI:Destroy()
            MainFrame.Active = true
            fadeInMainFrame:Play()
            fadeInTitle:Play()
            fadeInToggleButton:Play()
        end)
    else
        ShowFeedback("Неверный ключ, пожалуйста, получите его.", Color3.fromRGB(255, 0, 0))
    end
end)
