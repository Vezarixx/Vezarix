-- Импорт сервисов
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local HttpService = game:GetService("HttpService")
local CoreGui = game:GetService("CoreGui")

-- Глобальные настройки
local Settings = {
    SpeedBoost = {Enabled = false, Value = 50, Min = 0, Max = 1000000},
    JumpBoost = {Enabled = false, Value = 50, Min = 0, Max = 1000000},
    FOVBoost = {Enabled = false, Value = 90, Min = 30, Max = 120},
    Noclip = {Enabled = false},
    ESP = {Enabled = false, Transparency = 0.5, Color = Color3.fromRGB(147, 112, 219), Mode = "AlwaysOnTop"},
    InfiniteJump = {Enabled = false}
}

-- Основной GUI
local XHubGUI = Instance.new("ScreenGui")
XHubGUI.Name = "XHub"
XHubGUI.Parent = CoreGui
XHubGUI.IgnoreGuiInset = true
XHubGUI.DisplayOrder = 1000
XHubGUI.Enabled = false

-- Ключевая система GUI
local KeySystemGUI = Instance.new("ScreenGui")
KeySystemGUI.Name = "XKeySystem"
KeySystemGUI.Parent = CoreGui
KeySystemGUI.IgnoreGuiInset = true
KeySystemGUI.DisplayOrder = 9999

local KeySystemFrame = Instance.new("Frame")
KeySystemFrame.Size = UDim2.new(1, 0, 1, 0)
KeySystemFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
KeySystemFrame.BackgroundTransparency = 1
KeySystemFrame.Parent = KeySystemGUI

-- Заголовок ключевой системы
local KeySystemTitle = Instance.new("TextLabel")
KeySystemTitle.Size = UDim2.new(0, 400, 0, 50)
KeySystemTitle.Position = UDim2.new(0.5, -200, 0.2, -25)
KeySystemTitle.Text = "X HUB • КЛЮЧЕВАЯ СИСТЕМА"
KeySystemTitle.TextColor3 = Color3.fromRGB(147, 112, 219)
KeySystemTitle.TextSize = 24
KeySystemTitle.Font = Enum.Font.SourceSansBold
KeySystemTitle.BackgroundTransparency = 1
KeySystemTitle.TextTransparency = 1
KeySystemTitle.Parent = KeySystemFrame

-- Поле ввода ключа
local KeyInputFrame = Instance.new("Frame")
KeyInputFrame.Size = UDim2.new(0, 300, 0, 40)
KeyInputFrame.Position = UDim2.new(0.5, -150, 0.4, -20)
KeyInputFrame.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
KeyInputFrame.BackgroundTransparency = 1
KeyInputFrame.Parent = KeySystemFrame

local KeyInputCorner = Instance.new("UICorner")
KeyInputCorner.CornerRadius = UDim.new(0, 8)
KeyInputCorner.Parent = KeyInputFrame

local KeyInputStroke = Instance.new("UIStroke")
KeyInputStroke.Color = Color3.fromRGB(147, 112, 219)
KeyInputStroke.Thickness = 1
KeyInputStroke.Transparency = 1
KeyInputStroke.Parent = KeyInputFrame

local KeyInput = Instance.new("TextBox")
KeyInput.Size = UDim2.new(1, -20, 1, -10)
KeyInput.Position = UDim2.new(0, 10, 0, 5)
KeyInput.BackgroundTransparency = 1
KeyInput.Text = ""
KeyInput.PlaceholderText = "Введите ключ"
KeyInput.PlaceholderColor3 = Color3.fromRGB(147, 112, 219)
KeyInput.TextColor3 = Color3.fromRGB(255, 255, 255)
KeyInput.TextSize = 16
KeyInput.Font = Enum.Font.SourceSans
KeyInput.TextTransparency = 1
KeyInput.Parent = KeyInputFrame

-- Кнопки для ключевой системы
local ActivateButton = Instance.new("TextButton")
ActivateButton.Size = UDim2.new(0, 140, 0, 40)
ActivateButton.Position = UDim2.new(0.5, -150, 0.5, 0)
ActivateButton.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
ActivateButton.Text = "Активировать"
ActivateButton.TextColor3 = Color3.fromRGB(147, 112, 219)
ActivateButton.TextSize = 16
ActivateButton.Font = Enum.Font.SourceSansSemibold
ActivateButton.BackgroundTransparency = 1
ActivateButton.TextTransparency = 1
ActivateButton.Parent = KeySystemFrame

local ActivateCorner = Instance.new("UICorner")
ActivateCorner.CornerRadius = UDim.new(0, 8)
ActivateCorner.Parent = ActivateButton

local ActivateStroke = Instance.new("UIStroke")
ActivateStroke.Color = Color3.fromRGB(147, 112, 219)
ActivateStroke.Thickness = 1
ActivateStroke.Transparency = 1
ActivateStroke.Parent = ActivateButton

local GetKeyButton = Instance.new("TextButton")
GetKeyButton.Size = UDim2.new(0, 140, 0, 40)
GetKeyButton.Position = UDim2.new(0.5, 10, 0.5, 0)
GetKeyButton.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
GetKeyButton.Text = "Получить ключ"
GetKeyButton.TextColor3 = Color3.fromRGB(147, 112, 219)
GetKeyButton.TextSize = 16
GetKeyButton.Font = Enum.Font.SourceSansSemibold
GetKeyButton.BackgroundTransparency = 1
GetKeyButton.TextTransparency = 1
GetKeyButton.Parent = KeySystemFrame

local GetKeyCorner = Instance.new("UICorner")
GetKeyCorner.CornerRadius = UDim.new(0, 8)
GetKeyCorner.Parent = GetKeyButton

local GetKeyStroke = Instance.new("UIStroke")
GetKeyStroke.Color = Color3.fromRGB(147, 112, 219)
GetKeyStroke.Thickness = 1
GetKeyStroke.Transparency = 1
GetKeyStroke.Parent = GetKeyButton

-- Обратная связь
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

-- Анимация появления ключевой системы
local function FadeInKeySystem()
    local tweens = {
        TweenService:Create(KeySystemFrame, TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {BackgroundTransparency = 0.3}),
        TweenService:Create(KeySystemTitle, TweenInfo.new(0.5), {TextTransparency = 0}),
        TweenService:Create(KeyInputFrame, TweenInfo.new(0.5), {BackgroundTransparency = 0}),
        TweenService:Create(KeyInputStroke, TweenInfo.new(0.5), {Transparency = 0}),
        TweenService:Create(KeyInput, TweenInfo.new(0.5), {TextTransparency = 0}),
        TweenService:Create(ActivateButton, TweenInfo.new(0.5), {BackgroundTransparency = 0, TextTransparency = 0}),
        TweenService:Create(ActivateStroke, TweenInfo.new(0.5), {Transparency = 0}),
        TweenService:Create(GetKeyButton, TweenInfo.new(0.5), {BackgroundTransparency = 0, TextTransparency = 0}),
        TweenService:Create(GetKeyStroke, TweenInfo.new(0.5), {Transparency = 0})
    }
    for _, tween in ipairs(tweens) do tween:Play() end
end
FadeInKeySystem()

-- Функция обратной связи
local function ShowFeedback(text, color)
    FeedbackLabel.Text = text
    FeedbackLabel.TextColor3 = color
    local fadeIn = TweenService:Create(FeedbackLabel, TweenInfo.new(0.5), {TextTransparency = 0})
    fadeIn:Play()
    spawn(function()
        wait(2)
        local fadeOut = TweenService:Create(FeedbackLabel, TweenInfo.new(0.5), {TextTransparency = 1})
        fadeOut:Play()
    end)
end

-- Логика ключевой системы
local CorrectKey = "X"
local isKeySystemActive = true

GetKeyButton.MouseButton1Click:Connect(function()
    local message = "Свяжитесь с @XHubCreator в Telegram для получения ключа."
    pcall(function()
        setclipboard(message)
        ShowFeedback("Информация скопирована!", Color3.fromRGB(147, 112, 219))
    end)
end)

ActivateButton.MouseButton1Click:Connect(function()
    if not isKeySystemActive then return end
    local inputKey = KeyInput.Text
    if inputKey == "" then
        ShowFeedback("Введите ключ!", Color3.fromRGB(255, 0, 0))
    elseif inputKey == CorrectKey then
        ShowFeedback("Ключ активирован!", Color3.fromRGB(147, 112, 219))
        isKeySystemActive = false
        local tweens = {
            TweenService:Create(KeySystemFrame, TweenInfo.new(0.5), {BackgroundTransparency = 1}),
            TweenService:Create(KeySystemTitle, TweenInfo.new(0.5), {TextTransparency = 1}),
            TweenService:Create(KeyInputFrame, TweenInfo.new(0.5), {BackgroundTransparency = 1}),
            TweenService:Create(KeyInputStroke, TweenInfo.new(0.5), {Transparency = 1}),
            TweenService:Create(KeyInput, TweenInfo.new(0.5), {TextTransparency = 1}),
            TweenService:Create(ActivateButton, TweenInfo.new(0.5), {BackgroundTransparency = 1, TextTransparency = 1}),
            TweenService:Create(ActivateStroke, TweenInfo.new(0.5), {Transparency = 1}),
            TweenService:Create(GetKeyButton, TweenInfo.new(0.5), {BackgroundTransparency = 1, TextTransparency = 1}),
            TweenService:Create(GetKeyStroke, TweenInfo.new(0.5), {Transparency = 1})
        }
        for _, tween in ipairs(tweens) do tween:Play() end
        tweens[1].Completed:Connect(function()
            KeySystemGUI:Destroy()
            XHubGUI.Enabled = true
        end)
    else
        ShowFeedback("Неверный ключ!", Color3.fromRGB(255, 0, 0))
    end
end)

-- Главный фрейм
local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 220, 0, 40)
MainFrame.Position = UDim2.new(0.5, -110, 0.5, -100)
MainFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
MainFrame.BackgroundTransparency = 1
MainFrame.Active = true
MainFrame.Parent = XHubGUI

local UICorner = Instance.new("UICorner")
UICorner.CornerRadius = UDim.new(0, 8)
UICorner.Parent = MainFrame

local UIStroke = Instance.new("UIStroke")
UIStroke.Color = Color3.fromRGB(147, 112, 219)
UIStroke.Thickness = 1
UIStroke.Transparency = 1
UIStroke.Parent = MainFrame

-- Заголовок
local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(0.7, 0, 0, 40)
Title.Position = UDim2.new(0, 10, 0, 0)
Title.Text = "X Hub"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.TextSize = 20
Title.Font = Enum.Font.SourceSansBold
Title.BackgroundTransparency = 1
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.TextTransparency = 1
Title.Parent = MainFrame

-- Кнопка сворачивания
local ToggleButton = Instance.new("TextButton")
ToggleButton.Size = UDim2.new(0, 30, 0, 30)
ToggleButton.Position = UDim2.new(1, -35, 0, 5)
ToggleButton.Text = "▲"
ToggleButton.TextColor3 = Color3.fromRGB(255, 255, 255)
ToggleButton.TextSize = 18
ToggleButton.BackgroundTransparency = 1
ToggleButton.TextTransparency = 1
ToggleButton.Parent = MainFrame

-- Прокрутка
local ScrollFrame = Instance.new("ScrollingFrame")
ScrollFrame.Size = UDim2.new(1, 0, 1, -40)
ScrollFrame.Position = UDim2.new(0, 0, 0, 40)
ScrollFrame.BackgroundTransparency = 1
ScrollFrame.ScrollBarThickness = 4
ScrollFrame.ScrollBarImageColor3 = Color3.fromRGB(147, 112, 219)
ScrollFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
ScrollFrame.ScrollingDirection = Enum.ScrollingDirection.Y
ScrollFrame.Visible = false
ScrollFrame.Parent = MainFrame

local UIListLayout = Instance.new("UIListLayout")
UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
UIListLayout.Padding = UDim.new(0, 5)
UIListLayout.Parent = ScrollFrame

-- Уведомления
local NotificationGUI = Instance.new("ScreenGui")
NotificationGUI.Name = "XHubNotifications"
NotificationGUI.Parent = CoreGui
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

-- Функция создания уведомлений
local function CreateNotification(category, funcName, enabled)
    local NotificationFrame = Instance.new("Frame")
    NotificationFrame.Size = UDim2.new(1, 0, 0, 60)
    NotificationFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
    NotificationFrame.BackgroundTransparency = 1
    NotificationFrame.Parent = NotificationContainer

    local NotifCorner = Instance.new("UICorner")
    NotifCorner.CornerRadius = UDim.new(0, 8)
    NotifCorner.Parent = NotificationFrame

    local NotifStroke = Instance.new("UIStroke")
    NotifStroke.Color = Color3.fromRGB(147, 112, 219)
    NotifStroke.Thickness = 1
    NotifStroke.Transparency = 1
    NotifStroke.Parent = NotificationFrame

    local NotifTitle = Instance.new("TextLabel")
    NotifTitle.Size = UDim2.new(1, -20, 0, 20)
    NotifTitle.Position = UDim2.new(0, 10, 0, 5)
    NotifTitle.Text = "Уведомление"
    NotifTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
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
    NotifText.TextColor3 = Color3.fromRGB(147, 112, 219)
    NotifText.TextSize = 14
    NotifText.Font = Enum.Font.SourceSans
    NotifText.BackgroundTransparency = 1
    NotifText.TextXAlignment = Enum.TextXAlignment.Left
    NotifText.TextTransparency = 1
    NotifText.Parent = NotificationFrame

    local tweens = {
        TweenService:Create(NotificationFrame, TweenInfo.new(0.5), {BackgroundTransparency = 0}),
        TweenService:Create(NotifStroke, TweenInfo.new(0.5), {Transparency = 0}),
        TweenService:Create(NotifTitle, TweenInfo.new(0.5), {TextTransparency = 0}),
        TweenService:Create(NotifText, TweenInfo.new(0.5), {TextTransparency = 0})
    }
    for _, tween in ipairs(tweens) do tween:Play() end

    spawn(function()
        wait(3)
        local fadeOutTweens = {
            TweenService:Create(NotificationFrame, TweenInfo.new(0.5), {BackgroundTransparency = 1}),
            TweenService:Create(NotifStroke, TweenInfo.new(0.5), {Transparency = 1}),
            TweenService:Create(NotifTitle, TweenInfo.new(0.5), {TextTransparency = 1}),
            TweenService:Create(NotifText, TweenInfo.new(0.5), {TextTransparency = 1})
        }
        for _, tween in ipairs(fadeOutTweens) do tween:Play() end
        fadeOutTweens[1].Completed:Connect(function()
            NotificationFrame:Destroy()
        end)
    end)
end

-- Обновление CanvasSize
local function UpdateCanvasSize()
    local totalHeight = 0
    for _, child in ipairs(ScrollFrame:GetChildren()) do
        if child:IsA("Frame") then
            totalHeight = totalHeight + child.Size.Y.Offset + UIListLayout.Padding.Offset
        end
    end
    ScrollFrame.CanvasSize = UDim2.new(0, 0, 0, totalHeight)
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
            local servers = HttpService:JSONDecode(game:HttpGet("https://games.roblox.com/v1/games/" .. game.PlaceId .. "/servers/Public?sortOrder=Asc&limit=100"))
            for _, server in ipairs(servers.data) do
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
for i, category in ipairs(Categories) do
    local CategoryFrame = Instance.new("Frame")
    CategoryFrame.Size = UDim2.new(1, 0, 0, 30)
    CategoryFrame.BackgroundTransparency = 1
    CategoryFrame.LayoutOrder = i
    CategoryFrame.Parent = ScrollFrame

    local CategoryLabel = Instance.new("TextLabel")
    CategoryLabel.Size = UDim2.new(0.7, 0, 1, 0)
    CategoryLabel.Position = UDim2.new(0, 10, 0, 0)
    CategoryLabel.Text = category.Name
    CategoryLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    CategoryLabel.TextSize = 16
    CategoryLabel.Font = Enum.Font.SourceSansBold
    CategoryLabel.BackgroundTransparency = 1
    CategoryLabel.TextXAlignment = Enum.TextXAlignment.Left
    CategoryLabel.Parent = CategoryFrame

    local CategoryToggleButton = Instance.new("TextButton")
    CategoryToggleButton.Size = UDim2.new(0, 20, 0, 20)
    CategoryToggleButton.Position = UDim2.new(1, -30, 0, 5)
    CategoryToggleButton.Text = "▼"
    CategoryToggleButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    CategoryToggleButton.TextSize = 14
    CategoryToggleButton.BackgroundTransparency = 1
    CategoryToggleButton.Parent = CategoryFrame

    local FunctionsFrame = Instance.new("Frame")
    FunctionsFrame.Size = UDim2.new(1, 0, 0, 0)
    FunctionsFrame.Position = UDim2.new(0, 0, 0, 30)
    FunctionsFrame.BackgroundTransparency = 1
    FunctionsFrame.ClipsDescendants = true
    FunctionsFrame.Parent = CategoryFrame

    local FunctionsListLayout = Instance.new("UIListLayout")
    FunctionsListLayout.SortOrder = Enum.SortOrder.LayoutOrder
    FunctionsListLayout.Padding = UDim.new(0, 5)
    FunctionsListLayout.Parent = FunctionsFrame

    for j, func in ipairs(category.Functions) do
        local FuncFrame = Instance.new("Frame")
        local height = func.HasInput and 60 or 30
        FuncFrame.Size = UDim2.new(1, 0, 0, height)
        FuncFrame.BackgroundTransparency = 1
        FuncFrame.LayoutOrder = j
        FuncFrame.Parent = FunctionsFrame

        local FuncLabel = Instance.new("TextLabel")
        FuncLabel.Size = UDim2.new(0.7, 0, 0, 30)
        FuncLabel.Position = UDim2.new(0, 10, 0, 0)
        FuncLabel.Text = func.Name
        FuncLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
        FuncLabel.TextSize = 14
        FuncLabel.Font = Enum.Font.SourceSans
        FuncLabel.BackgroundTransparency = 1
        FuncLabel.TextXAlignment = Enum.TextXAlignment.Left
        FuncLabel.Parent = FuncFrame

        if func.Name ~= "Перезайти" then
            local ToggleCircle = Instance.new("TextButton")
            ToggleCircle.Size = UDim2.new(0, 20, 0, 20)
            ToggleCircle.Position = UDim2.new(1, -30, 0, 5)
            ToggleCircle.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
            ToggleCircle.Text = ""
            ToggleCircle.Parent = FuncFrame

            local CircleCorner = Instance.new("UICorner")
            CircleCorner.CornerRadius = UDim.new(1, 0)
            CircleCorner.Parent = ToggleCircle

            local CircleStroke = Instance.new("UIStroke")
            CircleStroke.Color = Color3.fromRGB(147, 112, 219)
            CircleStroke.Thickness = 1
            CircleStroke.Parent = ToggleCircle

            local function UpdateToggle()
                ToggleCircle.BackgroundColor3 = func.Setting.Enabled and Color3.fromRGB(147, 112, 219) or Color3.fromRGB(255, 255, 255)
            end

            ToggleCircle.MouseButton1Click:Connect(function()
                func.Setting.Enabled = not func.Setting.Enabled
                UpdateToggle()
                CreateNotification(category.Name, func.Name, func.Setting.Enabled)
            end)

            UpdateToggle()

            if func.HasInput then
                local InputField = Instance.new("TextBox")
                InputField.Size = UDim2.new(0.8, 0, 0, 25)
                InputField.Position = UDim2.new(0, 10, 0, 30)
                InputField.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
                InputField.Text = tostring(func.Setting.Value)
                InputField.TextColor3 = Color3.fromRGB(255, 255, 255)
                InputField.TextSize = 14
                InputField.Font = Enum.Font.SourceSans
                InputField.Parent = FuncFrame

                local InputCorner = Instance.new("UICorner")
                InputCorner.CornerRadius = UDim.new(0, 5)
                InputCorner.Parent = InputField

                local InputStroke = Instance.new("UIStroke")
                InputStroke.Color = Color3.fromRGB(147, 112, 219)
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

            if func.HasSettings then
                local SettingsButton = Instance.new("TextButton")
                SettingsButton.Size = UDim2.new(0, 20, 0, 20)
                SettingsButton.Position = UDim2.new(1, -60, 0, 5)
                SettingsButton.Text = "⚙"
                SettingsButton.TextColor3 = Color3.fromRGB(255, 255, 255)
                SettingsButton.BackgroundTransparency = 1
                SettingsButton.Parent = FuncFrame

                local SettingsFrame = nil

                SettingsButton.MouseButton1Click:Connect(function()
                    if SettingsFrame then
                        local tweens = {
                            TweenService:Create(SettingsFrame, TweenInfo.new(0.5), {BackgroundTransparency = 1}),
                            TweenService:Create(SettingsFrame:FindFirstChild("UIStroke"), TweenInfo.new(0.5), {Transparency = 1}),
                            TweenService:Create(SettingsFrame:FindFirstChild("SettingsTitle"), TweenInfo.new(0.5), {TextTransparency = 1}),
                            TweenService:Create(SettingsFrame:FindFirstChild("CloseButton"), TweenInfo.new(0.5), {TextTransparency = 1}),
                            TweenService:Create(SettingsFrame:FindFirstChild("ColorButton"), TweenInfo.new(0.5), {BackgroundTransparency = 1, TextTransparency = 1}),
                            TweenService:Create(SettingsFrame:FindFirstChild("ModeButton"), TweenInfo.new(0.5), {BackgroundTransparency = 1, TextTransparency = 1})
                        }
                        for _, tween in ipairs(tweens) do tween:Play() end
                        tweens[1].Completed:Connect(function()
                            SettingsFrame:Destroy()
                            SettingsFrame = nil
                        end)
                        return
                    end

                    SettingsFrame = Instance.new("Frame")
                    SettingsFrame.Name = "ESPSettings"
                    SettingsFrame.Size = UDim2.new(0, 180, 0, 120)
                    SettingsFrame.Position = UDim2.new(0.5, -90, 0.5, -60)
                    SettingsFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
                    SettingsFrame.BackgroundTransparency = 1
                    SettingsFrame.Parent = XHubGUI

                    local SettingsCorner = Instance.new("UICorner")
                    SettingsCorner.CornerRadius = UDim.new(0, 8)
                    SettingsCorner.Parent = SettingsFrame

                    local SettingsStroke = Instance.new("UIStroke")
                    SettingsStroke.Color = Color3.fromRGB(147, 112, 219)
                    SettingsStroke.Thickness = 1
                    SettingsStroke.Transparency = 1
                    SettingsStroke.Parent = SettingsFrame

                    local SettingsTitle = Instance.new("TextLabel")
                    SettingsTitle.Name = "SettingsTitle"
                    SettingsTitle.Size = UDim2.new(1, 0, 0, 30)
                    SettingsTitle.Text = "Настройки ESP"
                    SettingsTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
                    SettingsTitle.TextSize = 16
                    SettingsTitle.Font = Enum.Font.SourceSansBold
                    SettingsTitle.BackgroundTransparency = 1
                    SettingsTitle.TextXAlignment = Enum.TextXAlignment.Center
                    SettingsTitle.TextTransparency = 1
                    SettingsTitle.Parent = SettingsFrame

                    local CloseButton = Instance.new("TextButton")
                    CloseButton.Name = "CloseButton"
                    CloseButton.Size = UDim2.new(0, 30, 0, 30)
                    CloseButton.Position = UDim2.new(1, -35, 0, 0)
                    CloseButton.Text = "X"
                    CloseButton.TextColor3 = Color3.fromRGB(255, 255, 255)
                    CloseButton.TextSize = 18
                    CloseButton.BackgroundTransparency = 1
                    CloseButton.TextTransparency = 1
                    CloseButton.Parent = SettingsFrame

                    CloseButton.MouseButton1Click:Connect(function()
                        local tweens = {
                            TweenService:Create(SettingsFrame, TweenInfo.new(0.5), {BackgroundTransparency = 1}),
                            TweenService:Create(SettingsStroke, TweenInfo.new(0.5), {Transparency = 1}),
                            TweenService:Create(SettingsTitle, TweenInfo.new(0.5), {TextTransparency = 1}),
                            TweenService:Create(CloseButton, TweenInfo.new(0.5), {TextTransparency = 1}),
                            TweenService:Create(SettingsFrame:FindFirstChild("ColorButton"), TweenInfo.new(0.5), {BackgroundTransparency = 1, TextTransparency = 1}),
                            TweenService:Create(SettingsFrame:FindFirstChild("ModeButton"), TweenInfo.new(0.5), {BackgroundTransparency = 1, TextTransparency = 1})
                        }
                        for _, tween in ipairs(tweens) do tween:Play() end
                        tweens[1].Completed:Connect(function()
                            SettingsFrame:Destroy()
                            SettingsFrame = nil
                        end)
                    end)

                    local ColorButton = Instance.new("TextButton")
                    ColorButton.Name = "ColorButton"
                    ColorButton.Size = UDim2.new(0, 150, 0, 30)
                    ColorButton.Position = UDim2.new(0, 15, 0, 40)
                    ColorButton.BackgroundColor3 = func.Setting.Color
                    ColorButton.Text = "Сменить цвет"
                    ColorButton.TextColor3 = Color3.fromRGB(255, 255, 255)
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
                    ModeButton.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
                    ModeButton.Text = "Режим: " .. (func.Setting.Mode == "AlwaysOnTop" and "AOT" or "TW")
                    ModeButton.TextColor3 = Color3.fromRGB(255, 255, 255)
                    ModeButton.TextSize = 14
                    ModeButton.BackgroundTransparency = 1
                    ModeButton.TextTransparency = 1
                    ModeButton.Parent = SettingsFrame

                    local ModeCorner = Instance.new("UICorner")
                    ModeCorner.CornerRadius = UDim.new(0, 5)
                    ModeCorner.Parent = ModeButton

                    ModeButton.MouseButton1Click:Connect(function()
                        func.Setting.Mode = func.Setting.Mode == "AlwaysOnTop" and "ThroughWalls" or "AlwaysOnTop"
                        ModeButton.Text = "Режим: " .. (func.Setting.Mode == "AlwaysOnTop" and "AOT" or "TW")
                    end)

                    local tweens = {
                        TweenService:Create(SettingsFrame, TweenInfo.new(0.5), {BackgroundTransparency = 0}),
                        TweenService:Create(SettingsStroke, TweenInfo.new(0.5), {Transparency = 0}),
                        TweenService:Create(SettingsTitle, TweenInfo.new(0.5), {TextTransparency = 0}),
                        TweenService:Create(CloseButton, TweenInfo.new(0.5), {TextTransparency = 0}),
                        TweenService:Create(ColorButton, TweenInfo.new(0.5), {BackgroundTransparency = 0, TextTransparency = 0}),
                        TweenService:Create(ModeButton, TweenInfo.new(0.5), {BackgroundTransparency = 0, TextTransparency = 0})
                    }
                    for _, tween in ipairs(tweens) do tween:Play() end
                end)
            end
        else
            local RejoinButton = Instance.new("TextButton")
            RejoinButton.Size = UDim2.new(0, 24, 0, 24)
            RejoinButton.Position = UDim2.new(1, -34, 0, 3)
            RejoinButton.BackgroundColor3 = Color3.fromRGB(100, 100, 100)
            RejoinButton.Text = "🔄"
            RejoinButton.TextColor3 = Color3.fromRGB(255, 255, 255)
            RejoinButton.TextSize = 14
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
        for _, func in ipairs(category.Functions) do
            funcHeight = funcHeight + (func.HasInput and 60 or 30) + FunctionsListLayout.Padding.Offset
        end
        local newHeight = IsCategoryExpanded and UDim2.new(1, 0, 0, funcHeight) or UDim2.new(1, 0, 0, 0)
        local tween = TweenService:Create(FunctionsFrame, TweenInfo.new(0.3), {Size = newHeight})
        tween:Play()
        CategoryToggleButton.Text = IsCategoryExpanded and "▲" or "▼"
        CategoryFrame.Size = IsCategoryExpanded and UDim2.new(1, 0, 0, 30 + funcHeight) or UDim2.new(1, 0, 0, 30)
        UpdateCanvasSize()
        if category.Name == "DOORS" and IsCategoryExpanded then
            CreateNotification(category.Name, "Пустая категория", false)
        end
    end)
end

-- Инициализация CanvasSize
UpdateCanvasSize()

-- Анимация появления главного меню
local tweens = {
    TweenService:Create(MainFrame, TweenInfo.new(0.5), {BackgroundTransparency = 0}),
    TweenService:Create(UIStroke, TweenInfo.new(0.5), {Transparency = 0}),
    TweenService:Create(Title, TweenInfo.new(0.5), {TextTransparency = 0}),
    TweenService:Create(ToggleButton, TweenInfo.new(0.5), {TextTransparency = 0})
}
for _, tween in ipairs(tweens) do tween:Play() end

-- Перемещение главного меню
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
        MainFrame.Position = UDim2.new(StartPos.X.Scale, StartPos.X.Offset + delta.X, StartPos.Y.Scale, StartPos.Y.Offset + delta.Y)
    end
end)

-- Анимация сворачивания/разворачивания
local IsExpanded = false
ToggleButton.MouseButton1Click:Connect(function()
    IsExpanded = not IsExpanded
    local newSize = IsExpanded and UDim2.new(0, 220, 0, 280) or UDim2.new(0, 220, 0, 40)
    local tween = TweenService:Create(MainFrame, TweenInfo.new(0.3), {Size = newSize})
    tween:Play()
    ToggleButton.Text = IsExpanded and "▼" or "▲"
    ScrollFrame.Visible = IsExpanded
end)

-- Функционал
local function UpdateSpeedBoost()
    local character = Players.LocalPlayer.Character
    if character and character:FindFirstChildOfClass("Humanoid") then
        character.Humanoid.WalkSpeed = Settings.SpeedBoost.Enabled and Settings.SpeedBoost.Value or 16
    end
end

local function UpdateJumpBoost()
    local character = Players.LocalPlayer.Character
    if character and character:FindFirstChildOfClass("Humanoid") then
        character.Humanoid.JumpPower = Settings.JumpBoost.Enabled and Settings.JumpBoost.Value or 50
    end
end

local function UpdateFOVBoost()
    local camera = workspace.CurrentCamera
    if camera then
        camera.FieldOfView = Settings.FOVBoost.Enabled and Settings.FOVBoost.Value or 70
    end
end

local NoclipEnabled = false
local NoclipConnection
local function EnableNoclip()
    if NoclipEnabled then return end
    NoclipEnabled = true
    NoclipConnection = RunService.Stepped:Connect(function()
        local character = Players.LocalPlayer.Character
        if character then
            for _, part in ipairs(character:GetDescendants()) do
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
        for _, part in ipairs(character:GetDescendants()) do
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

local ESPObjects = {}
local function CreateESP(player)
    if player == Players.LocalPlayer or ESPObjects[player] then return end
    local character = player.Character
    if not character then return end
    local highlight = Instance.new("Highlight")
    highlight.FillTransparency = Settings.ESP.Transparency
    highlight.FillColor = Settings.ESP.Color
    highlight.OutlineTransparency = 0
    highlight.OutlineColor = Color3.fromRGB(147, 112, 219)
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
    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= Players.LocalPlayer and player.Character and not ESPObjects[player] then
            CreateESP(player)
        end
    end
end

local InfiniteJumpConnection
local function UpdateInfiniteJump()
    if InfiniteJumpConnection then
        InfiniteJumpConnection:Disconnect()
        InfiniteJumpConnection = nil
    end
    if Settings.InfiniteJump.Enabled then
        InfiniteJumpConnection = UserInputService.JumpRequest:Connect(function()
            local character = Players.LocalPlayer.Character
            if character and character:FindFirstChildOfClass("Humanoid") then
                character.Humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
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
