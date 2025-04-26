-- Импорт сервисов
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local HttpService = game:GetService("HttpService")

-- Глобальные настройки
local Settings = {
    SpeedBoost = {Enabled = false, Value = 50, Min = 0, Max = 1000000},
    JumpBoost = {Enabled = false, Value = 50, Min = 0, Max = 1000000},
    FOVBoost = {Enabled = false, Value = 90},
    Noclip = {Enabled = false},
    ESP = {Enabled = false, Transparency = 0.5, Color = Color3.fromRGB(255, 255, 255), Mode = "AlwaysOnTop"},
    InfiniteJump = {Enabled = false}
}

-- Цвета в черно-белом стиле
local Colors = {
    Background = Color3.fromRGB(30, 30, 30), -- Черный фон
    Text = Color3.fromRGB(255, 255, 255), -- Белый текст
    Accent = Color3.fromRGB(200, 200, 200), -- Серый акцент (для обводки и кнопок)
    ButtonEnabled = Color3.fromRGB(150, 150, 150), -- Серый для включенных кнопок
    ButtonDisabled = Color3.fromRGB(50, 50, 50) -- Темно-серый для выключенных кнопок
}

-- Основной GUI (поверх всех окон)
local XHubGUI = Instance.new("ScreenGui")
XHubGUI.Name = "XHub"
XHubGUI.Parent = game:GetService("CoreGui")
XHubGUI.IgnoreGuiInset = true
XHubGUI.DisplayOrder = 1000
XHubGUI.Enabled = true

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

local function CreateNotification(category, funcName, enabled)
    local NotificationFrame = Instance.new("Frame")
    NotificationFrame.Size = UDim2.new(1, 0, 0, 60)
    NotificationFrame.BackgroundColor3 = Colors.Background
    NotificationFrame.BackgroundTransparency = 1
    NotificationFrame.Parent = NotificationContainer

    local NotifCorner = Instance.new("UICorner")
    NotifCorner.CornerRadius = UDim.new(0, 10)
    NotifCorner.Parent = NotificationFrame

    local NotifStroke = Instance.new("UIStroke")
    NotifStroke.Color = Colors.Accent
    NotifStroke.Thickness = 1
    NotifStroke.Transparency = 1
    NotifStroke.Parent = NotificationFrame

    local NotifTitle = Instance.new("TextLabel")
    NotifTitle.Size = UDim2.new(1, -20, 0, 20)
    NotifTitle.Position = UDim2.new(0, 10, 0, 5)
    NotifTitle.Text = "Уведомление"
    NotifTitle.TextColor3 = Colors.Text
    NotifTitle.TextSize = 16
    NotifTitle.Font = Enum.Font.SourceSansBold
    NotifTitle.BackgroundTransparency = 1
    NotifTitle.TextXAlignment = Enum.TextXAlignment.Left
    NotifTitle.TextTransparency = 1
    NotifTitle.Parent = NotificationFrame

    local NotifText = Instance.new("TextLabel")
    NotifText.Size = UDim2.new(1, -20, 0, 30)
    NotifText.Position = UDim2.new(0, 10, 0, 25)
    NotifText.Text = (enabled and "Включено: " or "Выключено: ") .. category .. " - " .. funcName
    NotifText.TextColor3 = Colors.Accent
    NotifText.TextSize = 14
    NotifText.Font = Enum.Font.SourceSans
    NotifText.BackgroundTransparency = 1
    NotifText.TextXAlignment = Enum.TextXAlignment.Left
    NotifText.TextTransparency = 1
    NotifText.Parent = NotificationFrame

    local fadeInFrame = TweenService:Create(NotificationFrame, TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {BackgroundTransparency = 0})
    local fadeInStroke = TweenService:Create(NotifStroke, TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Transparency = 0})
    local fadeInTitle = TweenService:Create(NotifTitle, TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {TextTransparency = 0})
    local fadeInText = TweenService:Create(NotifText, TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {TextTransparency = 0})
    fadeInFrame:Play()
    fadeInStroke:Play()
    fadeInTitle:Play()
    fadeInText:Play()

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

-- Круглая кнопка для открытия основного меню
local ToggleButton = Instance.new("TextButton")
ToggleButton.Size = UDim2.new(0, 50, 0, 50)
ToggleButton.Position = UDim2.new(0.5, -25, 0.5, -25)
ToggleButton.BackgroundColor3 = Colors.Background
ToggleButton.Text = "X"
ToggleButton.TextColor3 = Colors.Text
ToggleButton.TextSize = 20
ToggleButton.Font = Enum.Font.SourceSansBold
ToggleButton.BackgroundTransparency = 1
ToggleButton.TextTransparency = 1
ToggleButton.Parent = XHubGUI

local ToggleCorner = Instance.new("UICorner")
ToggleCorner.CornerRadius = UDim.new(1, 0)
ToggleCorner.Parent = ToggleButton

local ToggleStroke = Instance.new("UIStroke")
ToggleStroke.Color = Colors.Accent
ToggleStroke.Thickness = 1
ToggleStroke.Parent = ToggleButton

-- Перемещение круглой кнопки
local DraggingToggle = false
local DragStartToggle = nil
local StartPosToggle = nil

ToggleButton.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        DraggingToggle = true
        DragStartToggle = input.Position
        StartPosToggle = ToggleButton.Position
    end
end)

ToggleButton.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        DraggingToggle = false
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if DraggingToggle and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
        local delta = input.Position - DragStartToggle
        local newPosX = StartPosToggle.X.Offset + delta.X
        local newPosY = StartPosToggle.Y.Offset + delta.Y
        ToggleButton.Position = UDim2.new(StartPosToggle.X.Scale, newPosX, StartPosToggle.Y.Scale, newPosY)
    end
end)

-- Основное меню
local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 900, 0, 500)
MainFrame.Position = UDim2.new(0.5, -450, 0.5, -250)
MainFrame.BackgroundColor3 = Colors.Background
MainFrame.BackgroundTransparency = 1
MainFrame.Visible = false
MainFrame.Parent = XHubGUI

local MainCorner = Instance.new("UICorner")
MainCorner.CornerRadius = UDim.new(0, 15)
MainCorner.Parent = MainFrame

local MainStroke = Instance.new("UIStroke")
MainStroke.Color = Colors.Accent
MainStroke.Thickness = 1
MainStroke.Parent = MainFrame

-- Заголовок
local TitleFrame = Instance.new("Frame")
TitleFrame.Size = UDim2.new(1, 0, 0, 50)
TitleFrame.BackgroundColor3 = Colors.Background
TitleFrame.BackgroundTransparency = 1
TitleFrame.Parent = MainFrame

local TitleCorner = Instance.new("UICorner")
TitleCorner.CornerRadius = UDim.new(0, 15)
TitleCorner.Parent = TitleFrame

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(0.7, 0, 1, 0)
Title.Position = UDim2.new(0, 20, 0, 0)
Title.Text = "X Hub"
Title.TextColor3 = Colors.Text
Title.TextSize = 24
Title.Font = Enum.Font.SourceSansBold
Title.BackgroundTransparency = 1
Title.TextTransparency = 1
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.Parent = TitleFrame

-- Крестик для закрытия
local CloseButton = Instance.new("TextButton")
CloseButton.Size = UDim2.new(0, 30, 0, 30)
CloseButton.Position = UDim2.new(1, -40, 0, 10)
CloseButton.Text = "X"
CloseButton.TextColor3 = Colors.Text
CloseButton.TextSize = 18
CloseButton.BackgroundTransparency = 1
CloseButton.TextTransparency = 1
CloseButton.Parent = TitleFrame

-- Перемещение основного меню
local DraggingMain = false
local DragStartMain = nil
local StartPosMain = nil

Title.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        DraggingMain = true
        DragStartMain = input.Position
        StartPosMain = MainFrame.Position
    end
end)

Title.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        DraggingMain = false
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if DraggingMain and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
        local delta = input.Position - DragStartMain
        local newPosX = StartPosMain.X.Offset + delta.X
        local newPosY = StartPosMain.Y.Offset + delta.Y
        MainFrame.Position = UDim2.new(StartPosMain.X.Scale, newPosX, StartPosMain.Y.Scale, newPosY)
    end
end)

-- Разделитель между категориями и функциями
local Divider = Instance.new("Frame")
Divider.Size = UDim2.new(0, 2, 1, -60)
Divider.Position = UDim2.new(0, 250, 0, 50)
Divider.BackgroundColor3 = Colors.Accent
Divider.BackgroundTransparency = 1
Divider.Parent = MainFrame

-- Прокрутка категорий (левая часть)
local CategoryScroll = Instance.new("ScrollingFrame")
CategoryScroll.Size = UDim2.new(0, 250, 1, -60)
CategoryScroll.Position = UDim2.new(0, 0, 0, 50)
CategoryScroll.BackgroundTransparency = 1
CategoryScroll.ScrollBarThickness = 4
CategoryScroll.ScrollBarImageColor3 = Colors.Accent
CategoryScroll.CanvasSize = UDim2.new(0, 0, 0, 0)
CategoryScroll.ScrollingDirection = Enum.ScrollingDirection.Y
CategoryScroll.Parent = MainFrame

local CategoryListLayout = Instance.new("UIListLayout")
CategoryListLayout.SortOrder = Enum.SortOrder.LayoutOrder
CategoryListLayout.Padding = UDim.new(0, 10)
CategoryListLayout.Parent = CategoryScroll

-- Прокрутка функций (правая часть)
local FunctionScroll = Instance.new("ScrollingFrame")
FunctionScroll.Size = UDim2.new(0, 648, 1, -60)
FunctionScroll.Position = UDim2.new(0, 252, 0, 50)
FunctionScroll.BackgroundTransparency = 1
FunctionScroll.ScrollBarThickness = 4
FunctionScroll.ScrollBarImageColor3 = Colors.Accent
FunctionScroll.CanvasSize = UDim2.new(0, 0, 0, 0)
FunctionScroll.ScrollingDirection = Enum.ScrollingDirection.Y
FunctionScroll.Parent = MainFrame

local FunctionListLayout = Instance.new("UIListLayout")
FunctionListLayout.SortOrder = Enum.SortOrder.LayoutOrder
FunctionListLayout.Padding = UDim.new(0, 10)
FunctionListLayout.Parent = FunctionScroll

-- Функция для обновления CanvasSize
local function UpdateCanvasSize(scrollFrame, listLayout)
    local totalHeight = 0
    for _, child in pairs(scrollFrame:GetChildren()) do
        if child:IsA("Frame") then
            totalHeight = totalHeight + child.Size.Y.Offset + listLayout.Padding.Offset
        end
    end
    scrollFrame.CanvasSize = UDim2.new(0, 0, 0, totalHeight)
end

-- Сохранение состояния (например, включенные функции, прокрутка)
local SavedState = {
    Categories = {},
    Functions = {},
    ScrollPositions = {Category = 0, Function = 0}
}

-- Категории и функции
local Categories = {
    {Name = "Основные функции", Functions = {
        {Name = "ESP", Setting = Settings.ESP, HasSettings = true}
    }},
    {Name = "Движение", Functions = {
        {Name = "Скорость", Setting = Settings.SpeedBoost, HasInput = true},
        {Name = "Прыжок", Setting = Settings.JumpBoost, HasInput = true},
        {Name = "Бесконечный Прыжок", Setting = Settings.InfiniteJump}
    }},
    {Name = "Визуал", Functions = {
        {Name = "FOV", Setting = Settings.FOVBoost}
    }},
    {Name = "Другое", Functions = {
        {Name = "Noclip", Setting = Settings.Noclip},
        {Name = "Перезайти", Action = function()
            local servers = HttpService:JSONDecode(game:HttpGet("https://games.roblox.com/v1/games/" .. game.PlaceId .. "/servers/Public?sortOrder=Asc&limit=100"))
            for _, server in pairs(servers.data) do
                if server.playing < server.maxPlayers and server.playing > 0 then
                    game:GetService("TeleportService"):TeleportToPlaceInstance(game.PlaceId, server.id)
                    break
                end
            end
        end}
    }},
    {Name = "DOORS", Functions = {}}
}

-- Создание категорий
for i, category in pairs(Categories) do
    local CategoryButtonFrame = Instance.new("Frame")
    CategoryButtonFrame.Size = UDim2.new(1, -10, 0, 40)
    CategoryButtonFrame.BackgroundTransparency = 1
    CategoryButtonFrame.LayoutOrder = i
    CategoryButtonFrame.Parent = CategoryScroll

    local CategoryButton = Instance.new("TextButton")
    CategoryButton.Size = UDim2.new(1, 0, 1, 0)
    CategoryButton.BackgroundColor3 = Colors.ButtonDisabled
    CategoryButton.Text = category.Name
    CategoryButton.TextColor3 = Colors.Text
    CategoryButton.TextSize = 16
    CategoryButton.Font = Enum.Font.SourceSansBold
    CategoryButton.Parent = CategoryButtonFrame

    local CatCorner = Instance.new("UICorner")
    CatCorner.CornerRadius = UDim.new(0, 10)
    CatCorner.Parent = CategoryButton

    local CatStroke = Instance.new("UIStroke")
    CatStroke.Color = Colors.Accent
    CatStroke.Thickness = 1
    CatStroke.Parent = CategoryButton

    CategoryButton.MouseButton1Click:Connect(function()
        -- Очистка предыдущих функций
        for _, child in pairs(FunctionScroll:GetChildren()) do
            if child:IsA("Frame") then
                child:Destroy()
            end
        end

        -- Создание функций для выбранной категории
        for j, func in pairs(category.Functions) do
            local FuncFrame = Instance.new("Frame")
            local height = 40
            if func.HasInput then height = height + 30 end
            FuncFrame.Size = UDim2.new(1, -10, 0, height)
            FuncFrame.BackgroundTransparency = 1
            FuncFrame.LayoutOrder = j
            FuncFrame.Parent = FunctionScroll

            local FuncButton = Instance.new("TextButton")
            FuncButton.Size = UDim2.new(0.7, 0, 0, 40)
            FuncButton.Position = UDim2.new(0, 10, 0, 0)
            FuncButton.BackgroundColor3 = Colors.ButtonDisabled
            FuncButton.Text = func.Name
            FuncButton.TextColor3 = Colors.Text
            FuncButton.TextSize = 14
            FuncButton.Font = Enum.Font.SourceSans
            FuncButton.TextXAlignment = Enum.TextXAlignment.Left
            FuncButton.Parent = FuncFrame

            local FuncCorner = Instance.new("UICorner")
            FuncCorner.CornerRadius = UDim.new(0, 10)
            FuncCorner.Parent = FuncButton

            local FuncStroke = Instance.new("UIStroke")
            FuncStroke.Color = Colors.Accent
            FuncStroke.Thickness = 1
            FuncStroke.Parent = FuncButton

            if func.Name ~= "Перезайти" then
                local ToggleButton = Instance.new("TextButton")
                ToggleButton.Size = UDim2.new(0, 30, 0, 30)
                ToggleButton.Position = UDim2.new(1, -40, 0, 5)
                ToggleButton.BackgroundColor3 = func.Setting.Enabled and Colors.ButtonEnabled or Colors.ButtonDisabled
                ToggleButton.Text = ""
                ToggleButton.Parent = FuncFrame

                local ToggleCorner = Instance.new("UICorner")
                ToggleCorner.CornerRadius = UDim.new(0, 5)
                ToggleCorner.Parent = ToggleButton

                local ToggleStroke = Instance.new("UIStroke")
                ToggleStroke.Color = Colors.Accent
                ToggleStroke.Thickness = 1
                ToggleStroke.Parent = ToggleButton

                local function UpdateToggle()
                    local tweenInfo = TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
                    local tween = TweenService:Create(ToggleButton, tweenInfo, {BackgroundColor3 = func.Setting.Enabled and Colors.ButtonEnabled or Colors.ButtonDisabled})
                    tween:Play()
                end

                ToggleButton.MouseButton1Click:Connect(function()
                    func.Setting.Enabled = not func.Setting.Enabled
                    UpdateToggle()
                    CreateNotification(category.Name, func.Name, func.Setting.Enabled)
                    SavedState.Functions[category.Name .. func.Name] = func.Setting.Enabled
                end)

                if func.HasSettings then
                    local SettingsButton = Instance.new("TextButton")
                    SettingsButton.Size = UDim2.new(0, 30, 0, 30)
                    SettingsButton.Position = UDim2.new(1, -80, 0, 5)
                    SettingsButton.BackgroundColor3 = Colors.ButtonDisabled
                    SettingsButton.Text = "⚙"
                    SettingsButton.TextColor3 = Colors.Text
                    SettingsButton.TextSize = 14
                    SettingsButton.Parent = FuncFrame

                    local SettingsCorner = Instance.new("UICorner")
                    SettingsCorner.CornerRadius = UDim.new(0, 5)
                    SettingsCorner.Parent = SettingsButton

                    local SettingsStroke = Instance.new("UIStroke")
                    SettingsStroke.Color = Colors.Accent
                    SettingsStroke.Thickness = 1
                    SettingsStroke.Parent = SettingsButton

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
                        SettingsFrame.Size = UDim2.new(0, 180, 0, 120)
                        SettingsFrame.Position = UDim2.new(0.5, -90, 0.5, -60)
                        SettingsFrame.BackgroundColor3 = Colors.Background
                        SettingsFrame.BackgroundTransparency = 1
                        SettingsFrame.Parent = XHubGUI

                        local SettingsCorner = Instance.new("UICorner")
                        SettingsCorner.CornerRadius = UDim.new(0, 10)
                        SettingsCorner.Parent = SettingsFrame

                        local SettingsStroke = Instance.new("UIStroke")
                        SettingsStroke.Color = Colors.Accent
                        SettingsStroke.Thickness = 1
                        SettingsStroke.Transparency = 1
                        SettingsStroke.Parent = SettingsFrame

                        local SettingsTitle = Instance.new("TextLabel")
                        SettingsTitle.Name = "SettingsTitle"
                        SettingsTitle.Size = UDim2.new(1, 0, 0, 30)
                        SettingsTitle.Position = UDim2.new(0, 0, 0, 0)
                        SettingsTitle.Text = "Настройка ESP"
                        SettingsTitle.TextColor3 = Colors.Text
                        SettingsTitle.TextSize = 16
                        SettingsTitle.Font = Enum.Font.SourceSansBold
                        SettingsTitle.BackgroundTransparency = 1
                        SettingsTitle.TextTransparency = 1
                        SettingsTitle.TextXAlignment = Enum.TextXAlignment.Center
                        SettingsTitle.Parent = SettingsFrame

                        local CloseButton = Instance.new("TextButton")
                        CloseButton.Name = "CloseButton"
                        CloseButton.Size = UDim2.new(0, 30, 0, 30)
                        CloseButton.Position = UDim2.new(1, -35, 0, 0)
                        CloseButton.Text = "X"
                        CloseButton.TextColor3 = Colors.Text
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

                        local DraggingSettings = false
                        local DragStartSettings = nil
                        local StartPosSettings = nil

                        SettingsTitle.InputBegan:Connect(function(input)
                            if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                                DraggingSettings = true
                                DragStartSettings = input.Position
                                StartPosSettings = SettingsFrame.Position
                            end
                        end)

                        SettingsTitle.InputEnded:Connect(function(input)
                            if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                                DraggingSettings = false
                            end
                        end)

                        UserInputService.InputChanged:Connect(function(input)
                            if DraggingSettings and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
                                local delta = input.Position - DragStartSettings
                                local newPosX = StartPosSettings.X.Offset + delta.X
                                local newPosY = StartPosSettings.Y.Offset + delta.Y
                                SettingsFrame.Position = UDim2.new(StartPosSettings.X.Scale, newPosX, StartPosSettings.Y.Scale, newPosY)
                            end
                        end)

                        local ColorButton = Instance.new("TextButton")
                        ColorButton.Name = "ColorButton"
                        ColorButton.Size = UDim2.new(0, 150, 0, 30)
                        ColorButton.Position = UDim2.new(0, 15, 0, 40)
                        ColorButton.BackgroundColor3 = func.Setting.Color
                        ColorButton.Text = "Цвет ESP"
                        ColorButton.TextColor3 = Colors.Text
                        ColorButton.TextSize = 14
                        ColorButton.BackgroundTransparency = 1
                        ColorButton.TextTransparency = 1
                        ColorButton.Parent = SettingsFrame

                        local ColorCorner = Instance.new("UICorner")
                        ColorCorner.CornerRadius = UDim.new(0, 5)
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
                        ModeButton.Size = UDim2.new(0, 150, 0, 30)
                        ModeButton.Position = UDim2.new(0, 15, 0, 80)
                        ModeButton.BackgroundColor3 = Colors.ButtonDisabled
                        ModeButton.Text = func.Setting.Mode == "AlwaysOnTop" and "Показывать" or "Не показывать"
                        ModeButton.TextColor3 = Colors.Text
                        ModeButton.TextSize = 14
                        ModeButton.BackgroundTransparency = 1
                        ModeButton.TextTransparency = 1
                        ModeButton.Parent = SettingsFrame

                        local ModeCorner = Instance.new("UICorner")
                        ModeCorner.CornerRadius = UDim.new(0, 5)
                        ModeCorner.Parent = ModeButton

                        ModeButton.MouseButton1Click:Connect(function()
                            func.Setting.Mode = func.Setting.Mode == "AlwaysOnTop" and "ThroughWalls" or "AlwaysOnTop"
                            ModeButton.Text = func.Setting.Mode == "AlwaysOnTop" and "Показывать" or "Не показывать"
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

                if func.HasInput then
                    local InputField = Instance.new("TextBox")
                    InputField.Size = UDim2.new(0.8, 0, 0, 25)
                    InputField.Position = UDim2.new(0, 10, 0, 45)
                    InputField.BackgroundColor3 = Colors.ButtonDisabled
                    InputField.Text = tostring(func.Setting.Value)
                    InputField.TextColor3 = Colors.Text
                    InputField.TextSize = 14
                    InputField.Font = Enum.Font.SourceSans
                    InputField.Parent = FuncFrame

                    local InputCorner = Instance.new("UICorner")
                    InputCorner.CornerRadius = UDim.new(0, 5)
                    InputCorner.Parent = InputField

                    local InputStroke = Instance.new("UIStroke")
                    InputStroke.Color = Colors.Accent
                    InputStroke.Thickness = 1
                    InputStroke.Parent = InputField

                    InputField.FocusLost:Connect(function(enterPressed)
                        if enterPressed then
                            local value = tonumber(InputField.Text)
                            if value then
                                func.Setting.Value = math.clamp(value, func.Setting.Min, func.Setting.Max)
                                InputField.Text = tostring(func.Setting.Value)
                            else
                                InputField.Text = tostring(func.Setting.Value)
                            end
                        end
                    end)
                end
            else
                FuncButton.MouseButton1Click:Connect(func.Action)
            end

            local fadeInFunc = TweenService:Create(FuncButton, TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {BackgroundTransparency = 0})
            fadeInFunc:Play()
        end

        UpdateCanvasSize(FunctionScroll, FunctionListLayout)
        FunctionScroll.CanvasPosition = Vector2.new(0, SavedState.ScrollPositions.Function or 0)
    end)

    local fadeInCat = TweenService:Create(CategoryButton, TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {BackgroundTransparency = 0})
    fadeInCat:Play()
end

UpdateCanvasSize(CategoryScroll, CategoryListLayout)

-- Логика открытия/закрытия основного меню
local IsMainMenuOpen = false

local function ToggleMainMenu()
    IsMainMenuOpen = not IsMainMenuOpen
    MainFrame.Visible = true
    local tweenInfo = TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
    if IsMainMenuOpen then
        local fadeInMain = TweenService:Create(MainFrame, tweenInfo, {BackgroundTransparency = 0})
        local fadeInTitleFrame = TweenService:Create(TitleFrame, tweenInfo, {BackgroundTransparency = 0})
        local fadeInTitle = TweenService:Create(Title, tweenInfo, {TextTransparency = 0})
        local fadeInClose = TweenService:Create(CloseButton, tweenInfo, {TextTransparency = 0})
        local fadeInDivider = TweenService:Create(Divider, tweenInfo, {BackgroundTransparency = 0})
        fadeInMain:Play()
        fadeInTitleFrame:Play()
        fadeInTitle:Play()
        fadeInClose:Play()
        fadeInDivider:Play()
        CategoryScroll.CanvasPosition = Vector2.new(0, SavedState.ScrollPositions.Category or 0)
        FunctionScroll.CanvasPosition = Vector2.new(0, SavedState.ScrollPositions.Function or 0)
    else
        local fadeOutMain = TweenService:Create(MainFrame, tweenInfo, {BackgroundTransparency = 1})
        local fadeOutTitleFrame = TweenService:Create(TitleFrame, tweenInfo, {BackgroundTransparency = 1})
        local fadeOutTitle = TweenService:Create(Title, tweenInfo, {TextTransparency = 1})
        local fadeOutClose = TweenService:Create(CloseButton, tweenInfo, {TextTransparency = 1})
        local fadeOutDivider = TweenService:Create(Divider, tweenInfo, {BackgroundTransparency = 1})
        SavedState.ScrollPositions.Category = CategoryScroll.CanvasPosition.Y
        SavedState.ScrollPositions.Function = FunctionScroll.CanvasPosition.Y
        fadeOutMain:Play()
        fadeOutTitleFrame:Play()
        fadeOutTitle:Play()
        fadeOutClose:Play()
        fadeOutDivider:Play()
        fadeOutMain.Completed:Connect(function()
            MainFrame.Visible = false
        end)
    end
end

ToggleButton.MouseButton1Click:Connect(ToggleMainMenu)
CloseButton.MouseButton1Click:Connect(ToggleMainMenu)

-- Функционал Speed Boost
local function UpdateSpeedBoost()
    local character = Players.LocalPlayer.Character
    if not character then return end
    local humanoid = character:FindFirstChildOfClass("Humanoid")
    if not humanoid then return end
    humanoid.WalkSpeed = Settings.SpeedBoost.Enabled and Settings.SpeedBoost.Value or 16
end

-- Функционал Jump Boost
local function UpdateJumpBoost()
    local character = Players.LocalPlayer.Character
    if not character then return end
    local humanoid = character:FindFirstChildOfClass("Humanoid")
    if not humanoid then return end
    humanoid.JumpPower = Settings.JumpBoost.Enabled and Settings.JumpBoost.Value or 50
end

-- Функционал FOV Boost
local function UpdateFOVBoost()
    local camera = workspace.CurrentCamera
    if not camera then return end
    camera.FieldOfView = Settings.FOVBoost.Enabled and Settings.FOVBoost.Value or 70
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
    highlight.OutlineColor = Colors.Accent
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
    UpdateSpeedBoost()
    UpdateJumpBoost()
    UpdateFOVBoost()
    UpdateNoclip()
    UpdateESP()
    UpdateInfiniteJump()
end)

Players.LocalPlayer.CharacterAdded:Connect(function()
    UpdateSpeedBoost()
    UpdateJumpBoost()
    UpdateNoclip()
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

-- Ключ-система
local KeySystemGUI = Instance.new("ScreenGui")
KeySystemGUI.Name = "XKeySystem"
KeySystemGUI.Parent = game:GetService("CoreGui")
KeySystemGUI.IgnoreGuiInset = true
KeySystemGUI.DisplayOrder = 9999

local KeySystemFrame = Instance.new("Frame")
KeySystemFrame.Size = UDim2.new(1, 0, 1, 0)
KeySystemFrame.BackgroundColor3 = Colors.Background
KeySystemFrame.BackgroundTransparency = 1
KeySystemFrame.Parent = KeySystemGUI

local KeySystemTitle = Instance.new("TextLabel")
KeySystemTitle.Size = UDim2.new(0, 400, 0, 50)
KeySystemTitle.Position = UDim2.new(0.5, -200, 0.2, -25)
KeySystemTitle.Text = "X Hub • Ключ система"
KeySystemTitle.TextColor3 = Colors.Accent
KeySystemTitle.TextSize = 24
KeySystemTitle.Font = Enum.Font.SourceSansBold
KeySystemTitle.BackgroundTransparency = 1
KeySystemTitle.TextTransparency = 1
KeySystemTitle.Parent = KeySystemFrame

local KeyInputFrame = Instance.new("Frame")
KeyInputFrame.Size = UDim2.new(0, 300, 0, 40)
KeyInputFrame.Position = UDim2.new(0.5, -150, 0.4, -20)
KeyInputFrame.BackgroundColor3 = Colors.ButtonDisabled
KeyInputFrame.BackgroundTransparency = 1
KeyInputFrame.Parent = KeySystemFrame

local KeyInputCorner = Instance.new("UICorner")
KeyInputCorner.CornerRadius = UDim.new(0, 10)
KeyInputCorner.Parent = KeyInputFrame

local KeyInputStroke = Instance.new("UIStroke")
KeyInputStroke.Color = Colors.Accent
KeyInputStroke.Thickness = 1
KeyInputStroke.Transparency = 1
KeyInputStroke.Parent = KeyInputFrame

local KeyInput = Instance.new("TextBox")
KeyInput.Size = UDim2.new(1, -20, 1, -10)
KeyInput.Position = UDim2.new(0, 10, 0, 5)
KeyInput.BackgroundTransparency = 1
KeyInput.Text = ""
KeyInput.PlaceholderText = "Ввести ключ"
KeyInput.PlaceholderColor3 = Colors.Accent
KeyInput.TextColor3 = Colors.Text
KeyInput.TextSize = 16
KeyInput.Font = Enum.Font.SourceSans
KeyInput.TextTransparency = 1
KeyInput.Parent = KeyInputFrame

local ActivateButton = Instance.new("TextButton")
ActivateButton.Size = UDim2.new(0, 140, 0, 40)
ActivateButton.Position = UDim2.new(0.5, -150, 0.5, 0)
ActivateButton.BackgroundColor3 = Colors.ButtonDisabled
ActivateButton.Text = "Активировать ключ"
ActivateButton.TextColor3 = Colors.Accent
ActivateButton.TextSize = 16
ActivateButton.Font = Enum.Font.SourceSansSemibold
ActivateButton.TextTransparency = 1
ActivateButton.BackgroundTransparency = 1
ActivateButton.Parent = KeySystemFrame

local ActivateCorner = Instance.new("UICorner")
ActivateCorner.CornerRadius = UDim.new(0, 10)
ActivateCorner.Parent = ActivateButton

local ActivateStroke = Instance.new("UIStroke")
ActivateStroke.Color = Colors.Accent
ActivateStroke.Thickness = 1
ActivateStroke.Transparency = 1
ActivateStroke.Parent = ActivateButton

local GetKeyButton = Instance.new("TextButton")
GetKeyButton.Size = UDim2.new(0, 140, 0, 40)
GetKeyButton.Position = UDim2.new(0.5, 10, 0.5, 0)
GetKeyButton.BackgroundColor3 = Colors.ButtonDisabled
GetKeyButton.Text = "Получить ключ"
GetKeyButton.TextColor3 = Colors.Accent
GetKeyButton.TextSize = 16
GetKeyButton.Font = Enum.Font.SourceSansSemibold
GetKeyButton.TextTransparency = 1
GetKeyButton.BackgroundTransparency = 1
GetKeyButton.Parent = KeySystemFrame

local GetKeyCorner = Instance.new("UICorner")
GetKeyCorner.CornerRadius = UDim.new(0, 10)
GetKeyCorner.Parent = GetKeyButton

local GetKeyStroke = Instance.new("UIStroke")
GetKeyStroke.Color = Colors.Accent
GetKeyStroke.Thickness = 1
GetKeyStroke.Transparency = 1
GetKeyStroke.Parent = GetKeyButton

local FeedbackLabel = Instance.new("TextLabel")
FeedbackLabel.Size = UDim2.new(0, 300, 0, 30)
FeedbackLabel.Position = UDim2.new(0.5, -150, 0.6, 0)
FeedbackLabel.BackgroundTransparency = 1
FeedbackLabel.Text = ""
FeedbackLabel.TextColor3 = Colors.Accent
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
ToggleButton.BackgroundTransparency = 1
ToggleButton.TextTransparency = 1

GetKeyButton.MouseButton1Click:Connect(function()
    local message = "Ваш ключ: X"
    pcall(function()
        setclipboard(message)
        ShowFeedback("Текст скопирован в ваш буфер обмена", Colors.Accent)
    end)
end)

ActivateButton.MouseButton1Click:Connect(function()
    if not isKeySystemActive then return end
    local inputKey = KeyInput.Text
    if inputKey == "" then
        ShowFeedback("Введите ключ!", Color3.fromRGB(255, 0, 0))
    elseif inputKey == CorrectKey then
        ShowFeedback("Ключ активирован!", Colors.Acc  Colors.Accent)
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

        local fadeInToggle = TweenService:Create(ToggleButton, TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {BackgroundTransparency = 0, TextTransparency = 0})
        fadeOutFrame.Completed:Connect(function()
            KeySystemGUI:Destroy()
            MainFrame.Active = true
            fadeInToggle:Play()
        end)
    else
        ShowFeedback("Неверный ключ, пожалуйста, получите его.", Color3.fromRGB(255, 0, 0))
    end
end)

-- Плавное появление ключ-системы при запуске
local fadeInFrame = TweenService:Create(KeySystemFrame, TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {BackgroundTransparency = 0})
local fadeInTitle = TweenService:Create(KeySystemTitle, TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {TextTransparency = 0})
local fadeInInputFrame = TweenService:Create(KeyInputFrame, TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {BackgroundTransparency = 0})
local fadeInInputStroke = TweenService:Create(KeyInputStroke, TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Transparency = 0})
local fadeInInput = TweenService:Create(KeyInput, TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {TextTransparency = 0})
local fadeInActivateButton = TweenService:Create(ActivateButton, TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {BackgroundTransparency = 0, TextTransparency = 0})
local fadeInActivateStroke = TweenService:Create(ActivateStroke, TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Transparency = 0})
local fadeInGetKeyButton = TweenService:Create(GetKeyButton, TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {BackgroundTransparency = 0, TextTransparency = 0})
local fadeInGetKeyStroke = TweenService:Create(GetKeyStroke, TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Transparency = 0})

fadeInFrame:Play()
fadeInTitle:Play()
fadeInInputFrame:Play()
fadeInInputStroke:Play()
fadeInInput:Play()
fadeInActivateButton:Play()
fadeInActivateStroke:Play()
fadeInGetKeyButton:Play()
fadeInGetKeyStroke:Play()
