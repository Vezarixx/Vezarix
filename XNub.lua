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
    FOVBoost = {Enabled = false, Value = 90},
    Noclip = {Enabled = false},
    ESP = {Enabled = false, Transparency = 0.5, Color = Color3.fromRGB(255, 255, 255), Mode = "AlwaysOnTop"},
    InfiniteJump = {Enabled = false},
    Doors = {
        EntityNotifier = {Enabled = false},
        AutoLoot = {Enabled = false},
        FullBright = {Enabled = false},
        AntiScreech = {Enabled = false},
        SkeletonKey = {Enabled = false}
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
MainFrame.BorderSizePixel = 0
MainFrame.Parent = XHubGUI

-- Закругленные углы
local UICorner = Instance.new("UICorner")
UICorner.CornerRadius = UDim.new(0, 10)
UICorner.Parent = MainFrame

-- Обводка
local UIStroke = Instance.new("UIStroke")
UIStroke.Color = Color3.fromRGB(200, 200, 200)
UIStroke.Thickness = 1
UIStroke.Parent = MainFrame

-- Заголовок
local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(0.7, 0, 0, 40)
Title.Position = UDim2.new(0, 10, 0, 0)
Title.Text = "X Hub"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.TextSize = 20
Title.Font = Enum.Font.SourceSans
Title.BackgroundTransparency = 1
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.Parent = MainFrame

-- Кнопка сворачивания
local ToggleButton = Instance.new("TextButton")
ToggleButton.Size = UDim2.new(0, 30, 0, 30)
ToggleButton.Position = UDim2.new(1, -35, 0, 5)
ToggleButton.Text = "▲"
ToggleButton.TextColor3 = Color3.fromRGB(255, 255, 255)
ToggleButton.TextSize = 18
ToggleButton.BackgroundTransparency = 1
ToggleButton.Parent = MainFrame

-- Новая прокрутка
local ScrollFrame = Instance.new("ScrollingFrame")
ScrollFrame.Size = UDim2.new(1, 0, 1, -40)
ScrollFrame.Position = UDim2.new(0, 0, 0, 40)
ScrollFrame.BackgroundTransparency = 1
ScrollFrame.ScrollBarThickness = 4
ScrollFrame.ScrollBarImageColor3 = Color3.fromRGB(200, 200, 200)
ScrollFrame.ScrollingDirection = Enum.ScrollingDirection.Y
ScrollFrame.Visible = false
ScrollFrame.Parent = MainFrame

-- UIListLayout для прокрутки
local UIListLayout = Instance.new("UIListLayout")
UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
UIListLayout.Padding = UDim.new(0, 5)
UIListLayout.Parent = ScrollFrame

-- Обновление CanvasSize
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
NotificationContainer.Size = UDim2.new(0, 300, 0, 300)
NotificationContainer.Position = UDim2.new(1, -310, 1, -310)
NotificationContainer.BackgroundTransparency = 1
NotificationContainer.Parent = NotificationGUI

local NotificationListLayout = Instance.new("UIListLayout")
NotificationListLayout.SortOrder = Enum.SortOrder.LayoutOrder
NotificationListLayout.Padding = UDim.new(0, 5)
NotificationListLayout.VerticalAlignment = Enum.VerticalAlignment.Bottom
NotificationListLayout.Parent = NotificationContainer

local function CreateNotification(category, funcName, enabled)
    local NotificationFrame = Instance.new("Frame")
    NotificationFrame.Size = UDim2.new(1, 0, 0, 80)
    NotificationFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
    NotificationFrame.BackgroundTransparency = 1
    NotificationFrame.Parent = NotificationContainer

    local NotifCorner = Instance.new("UICorner")
    NotifCorner.CornerRadius = UDim.new(0, 10)
    NotifCorner.Parent = NotificationFrame

    local NotifStroke = Instance.new("UIStroke")
    NotifStroke.Color = Color3.fromRGB(200, 200, 200)
    NotifStroke.Thickness = 1
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
    NotifText.Size = UDim2.new(1, -20, 0, 50)
    NotifText.Position = UDim2.new(0, 10, 0, 25)
    NotifText.Text = (enabled and "Включено: " or "Выключено: ") .. category .. " - " .. funcName
    NotifText.TextColor3 = Color3.fromRGB(200, 200, 200)
    NotifText.TextSize = 14
    NotifText.Font = Enum.Font.SourceSans
    NotifText.BackgroundTransparency = 1
    NotifText.TextXAlignment = Enum.TextXAlignment.Left
    NotifText.TextTransparency = 1
    NotifText.Parent = NotificationFrame

    local fadeInFrame = TweenService:Create(NotificationFrame, TweenInfo.new(0.5), {BackgroundTransparency = 0})
    local fadeInStroke = TweenService:Create(NotifStroke, TweenInfo.new(0.5), {Transparency = 0})
    local fadeInTitle = TweenService:Create(NotifTitle, TweenInfo.new(0.5), {TextTransparency = 0})
    local fadeInText = TweenService:Create(NotifText, TweenInfo.new(0.5), {TextTransparency = 0})
    fadeInFrame:Play()
    fadeInStroke:Play()
    fadeInTitle:Play()
    fadeInText:Play()

    spawn(function()
        wait(3)
        local fadeOutFrame = TweenService:Create(NotificationFrame, TweenInfo.new(0.5), {BackgroundTransparency = 1})
        local fadeOutStroke = TweenService:Create(NotifStroke, TweenInfo.new(0.5), {Transparency = 1})
        local fadeOutTitle = TweenService:Create(NotifTitle, TweenInfo.new(0.5), {TextTransparency = 1})
        local fadeOutText = TweenService:Create(NotifText, TweenInfo.new(0.5), {TextTransparency = 1})
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
    {Name = "DOORS", Functions = {
        {Name = "Entity Notifier", Setting = Settings.Doors.EntityNotifier},
        {Name = "Auto Loot", Setting = Settings.Doors.AutoLoot},
        {Name = "Full Bright", Setting = Settings.Doors.FullBright},
        {Name = "Anti-Screech", Setting = Settings.Doors.AntiScreech},
        {Name = "Skeleton Key", Setting = Settings.Doors.SkeletonKey}
    }}
}

-- Создание категорий и функций
for i, category in pairs(Categories) do
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
    CategoryLabel.Font = Enum.Font.SourceSans
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

    for j, func in pairs(category.Functions) do
        local FuncFrame = Instance.new("Frame")
        local height = 30
        if func.HasInput then height = height + 30 end
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
            CircleStroke.Color = Color3.fromRGB(200, 200, 200)
            CircleStroke.Thickness = 1
            CircleStroke.Parent = ToggleCircle

            local function UpdateToggle()
                ToggleCircle.BackgroundColor3 = func.Setting.Enabled and Color3.fromRGB(200, 200, 200) or Color3.fromRGB(255, 255, 255)
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
                InputField.Position = UDim2.new(0, 10, 0, 35)
                InputField.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
                InputField.Text = tostring(func.Setting.Value)
                InputField.TextColor3 = Color3.fromRGB(255, 255, 255)
                InputField.TextSize = 14
                InputField.Font = Enum.Font.SourceSans
                InputField.Parent = FuncFrame

                local InputCorner = Instance.new("UICorner")
                InputCorner.CornerRadius = UDim.new(0, 5)
                InputCorner.Parent = InputField

                local InputStroke = Instance.new("UIStroke")
                InputStroke.Color = Color3.fromRGB(200, 200, 200)
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
            local RejoinButton = Instance.new("TextButton")
            RejoinButton.Size = UDim2.new(0, 24, 0, 24)
            RejoinButton.Position = UDim2.new(1, -34, 0, 3)
            RejoinButton.BackgroundColor3 = Color3.fromRGB(100, 100, 100)
            RejoinButton.Text = "▼"
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
        for _, func in pairs(category.Functions) do
            local height = 30
            if func.HasInput then height = height + 30 end
            funcHeight = funcHeight + height + FunctionsListLayout.Padding.Offset
        end
        local newHeight = IsCategoryExpanded and UDim2.new(1, 0, 0, funcHeight) or UDim2.new(1, 0, 0, 0)
        local tweenInfo = TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
        local tween = TweenService:Create(FunctionsFrame, tweenInfo, {Size = newHeight})
        tween:Play()
        CategoryToggleButton.Text = IsCategoryExpanded and "▲" or "▼"
        CategoryFrame.Size = IsCategoryExpanded and UDim2.new(1, 0, 0, 30 + funcHeight) or UDim2.new(1, 0, 0, 30)
        UpdateCanvasSize()
    end)
end

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

local fadeInFrame = TweenService:Create(KeySystemFrame, TweenInfo.new(0.5), {BackgroundTransparency = 0})
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

local fadeInTitle = TweenService:Create(KeySystemTitle, TweenInfo.new(0.5), {TextTransparency = 0})
fadeInTitle:Play()

local KeyInputFrame = Instance.new("Frame")
KeyInputFrame.Size = UDim2.new(0, 350, 0, 50)
KeyInputFrame.Position = UDim2.new(0.5, -175, 0.4, -25)
KeyInputFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
KeyInputFrame.BackgroundTransparency = 1
KeyInputFrame.Parent = KeySystemFrame

local KeyInputCorner = Instance.new("UICorner")
KeyInputCorner.CornerRadius = UDim.new(0, 10)
KeyInputCorner.Parent = KeyInputFrame

local KeyInputStroke = Instance.new("UIStroke")
KeyInputStroke.Color = Color3.fromRGB(200, 200, 200)
KeyInputStroke.Thickness = 1
KeyInputStroke.Transparency = 1
KeyInputStroke.Parent = KeyInputFrame

local KeyInput = Instance.new("TextBox")
KeyInput.Size = UDim2.new(1, -20, 1, -10)
KeyInput.Position = UDim2.new(0, 10, 0, 5)
KeyInput.BackgroundTransparency = 1
KeyInput.Text = ""
KeyInput.PlaceholderText = "Ввести ключ"
KeyInput.PlaceholderColor3 = Color3.fromRGB(200, 200, 200)
KeyInput.TextColor3 = Color3.fromRGB(255, 255, 255)
KeyInput.TextSize = 16
KeyInput.Font = Enum.Font.SourceSans
KeyInput.TextTransparency = 1
KeyInput.Parent = KeyInputFrame

local fadeInInputFrame = TweenService:Create(KeyInputFrame, TweenInfo.new(0.5), {BackgroundTransparency = 0})
local fadeInInputStroke = TweenService:Create(KeyInputStroke, TweenInfo.new(0.5), {Transparency = 0})
local fadeInInput = TweenService:Create(KeyInput, TweenInfo.new(0.5), {TextTransparency = 0})
fadeInInputFrame:Play()
fadeInInputStroke:Play()
fadeInInput:Play()

local ActivateButton = Instance.new("TextButton")
ActivateButton.Size = UDim2.new(0, 140, 0, 40)
ActivateButton.Position = UDim2.new(0.5, -150, 0.5, 0)
ActivateButton.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
ActivateButton.Text = "Активировать ключ"
ActivateButton.TextColor3 = Color3.fromRGB(255, 255, 255)
ActivateButton.TextSize = 16
ActivateButton.Font = Enum.Font.SourceSans
ActivateButton.TextTransparency = 1
ActivateButton.BackgroundTransparency = 1
ActivateButton.Parent = KeySystemFrame

local ActivateCorner = Instance.new("UICorner")
ActivateCorner.CornerRadius = UDim.new(0, 10)
ActivateCorner.Parent = ActivateButton

local ActivateStroke = Instance.new("UIStroke")
ActivateStroke.Color = Color3.fromRGB(200, 200, 200)
ActivateStroke.Thickness = 1
ActivateStroke.Transparency = 1
ActivateStroke.Parent = ActivateButton

local fadeInActivateButton = TweenService:Create(ActivateButton, TweenInfo.new(0.5), {BackgroundTransparency = 0, TextTransparency = 0})
local fadeInActivateStroke = TweenService:Create(ActivateStroke, TweenInfo.new(0.5), {Transparency = 0})
fadeInActivateButton:Play()
fadeInActivateStroke:Play()

local GetKeyButton = Instance.new("TextButton")
GetKeyButton.Size = UDim2.new(0, 140, 0, 40)
GetKeyButton.Position = UDim2.new(0.5, 10, 0.5, 0)
GetKeyButton.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
GetKeyButton.Text = "Получить ключ"
GetKeyButton.TextColor3 = Color3.fromRGB(255, 255, 255)
GetKeyButton.TextSize = 16
GetKeyButton.Font = Enum.Font.SourceSans
GetKeyButton.TextTransparency = 1
GetKeyButton.BackgroundTransparency = 1
GetKeyButton.Parent = KeySystemFrame

local GetKeyCorner = Instance.new("UICorner")
GetKeyCorner.CornerRadius = UDim.new(0, 10)
GetKeyCorner.Parent = GetKeyButton

local GetKeyStroke = Instance.new("UIStroke")
GetKeyStroke.Color = Color3.fromRGB(200, 200, 200)
GetKeyStroke.Thickness = 1
GetKeyStroke.Transparency = 1
GetKeyStroke.Parent = GetKeyButton

local fadeInGetKeyButton = TweenService:Create(GetKeyButton, TweenInfo.new(0.5), {BackgroundTransparency = 0, TextTransparency = 0})
local fadeInGetKeyStroke = TweenService:Create(GetKeyStroke, TweenInfo.new(0.5), {Transparency = 0})
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
    local fadeIn = TweenService:Create(FeedbackLabel, TweenInfo.new(0.5), {TextTransparency = 0})
    fadeIn:Play()
    fadeIn.Completed:Connect(function()
        wait(2)
        local fadeOut = TweenService:Create(FeedbackLabel, TweenInfo.new(0.5), {TextTransparency = 1})
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

        local fadeOutFrame = TweenService:Create(KeySystemFrame, TweenInfo.new(0.5), {BackgroundTransparency = 1})
        local fadeOutTitle = TweenService:Create(KeySystemTitle, TweenInfo.new(0.5), {TextTransparency = 1})
        local fadeOutInputFrame = TweenService:Create(KeyInputFrame, TweenInfo.new(0.5), {BackgroundTransparency = 1})
        local fadeOutInputStroke = TweenService:Create(KeyInputStroke, TweenInfo.new(0.5), {Transparency = 1})
        local fadeOutInput = TweenService:Create(KeyInput, TweenInfo.new(0.5), {TextTransparency = 1})
        local fadeOutActivateButton = TweenService:Create(ActivateButton, TweenInfo.new(0.5), {BackgroundTransparency = 1, TextTransparency = 1})
        local fadeOutActivateStroke = TweenService:Create(ActivateStroke, TweenInfo.new(0.5), {Transparency = 1})
        local fadeOutGetKeyButton = TweenService:Create(GetKeyButton, TweenInfo.new(0.5), {BackgroundTransparency = 1, TextTransparency = 1})
        local fadeOutGetKeyStroke = TweenService:Create(GetKeyStroke, TweenInfo.new(0.5), {Transparency = 1})

        fadeOutFrame:Play()
        fadeOutTitle:Play()
        fadeOutInputFrame:Play()
        fadeOutInputStroke:Play()
        fadeOutInput:Play()
        fadeOutActivateButton:Play()
        fadeOutActivateStroke:Play()
        fadeOutGetKeyButton:Play()
        fadeOutGetKeyStroke:Play()

        local fadeInMainFrame = TweenService:Create(MainFrame, TweenInfo.new(0.5), {BackgroundTransparency = 0})
        local fadeInTitle = TweenService:Create(Title, TweenInfo.new(0.5), {TextTransparency = 0})
        local fadeInToggleButton = TweenService:Create(ToggleButton, TweenInfo.new(0.5), {TextTransparency = 0})

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

-- Функционал DOORS
local function UpdateEntityNotifier()
    if not Settings.Doors.EntityNotifier.Enabled then return end
    for _, entity in pairs(workspace.CurrentRooms:GetDescendants()) do
        if entity.Name == "Screech" or entity.Name == "A-90" then
            CreateNotification("DOORS", "Обнаружено существо: " .. entity.Name, true)
        end
    end
end

local function UpdateAutoLoot()
    if not Settings.Doors.AutoLoot.Enabled then return end
    for _, item in pairs(workspace.CurrentRooms:GetDescendants()) do
        if item.Name == "KeyObtain" or item.Name == "Book" then
            local player = Players.LocalPlayer
            local humanoidRootPart = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
            if humanoidRootPart and (item.Position - humanoidRootPart.Position).Magnitude < 10 then
                fireproximityprompt(item:FindFirstChildOfClass("ProximityPrompt"))
            end
        end
    end
end

local function UpdateFullBright()
    if not Settings.Doors.FullBright.Enabled then
        game:GetService("Lighting").Brightness = 1
        game:GetService("Lighting").GlobalShadows = true
        return
    end
    game:GetService("Lighting").Brightness = 10
    game:GetService("Lighting").GlobalShadows = false
end

local function UpdateAntiScreech()
    if not Settings.Doors.AntiScreech.Enabled then return end
    for _, entity in pairs(workspace.CurrentRooms:GetDescendants()) do
        if entity.Name == "Screech" then
            entity:Destroy()
        end
    end
end

local function UpdateSkeletonKey()
    if not Settings.Doors.SkeletonKey.Enabled then return end
    local DoorReplication = loadstring(game:HttpGet("https://raw.githubusercontent.com/RegularVynixu/Utilities/main/Doors/Door%20Replication/Source.lua"))()
    local room = workspace.CurrentRooms[ReplicatedStorage.GameData.LatestRoom.Value]
    DoorReplication.ReplicateDoor(room, {CustomKeyName = "Skeleton Key", DestroyKey = false})
end

-- Обновление функций
RunService.Heartbeat:Connect(function()
    pcall(UpdateSpeedBoost)
    pcall(UpdateJumpBoost)
    pcall(UpdateFOVBoost)
    pcall(UpdateNoclip)
    pcall(UpdateESP)
    pcall(UpdateInfiniteJump)
    pcall(UpdateEntityNotifier)
    pcall(UpdateAutoLoot)
    pcall(UpdateFullBright)
    pcall(UpdateAntiScreech)
    pcall(UpdateSkeletonKey)
end)

-- Остальные функции (SpeedBoost, JumpBoost, FOVBoost, Noclip, ESP, InfiniteJump) остаются без изменений, но с добавленными проверками
local function UpdateSpeedBoost()
    local character = Players.LocalPlayer.Character
    if not character then return end
    local humanoid = character:FindFirstChildOfClass("Humanoid")
    if not humanoid then return end
    humanoid.WalkSpeed = Settings.SpeedBoost.Enabled and Settings.SpeedBoost.Value or 16
end

local function UpdateJumpBoost()
    local character = Players.LocalPlayer.Character
    if not character then return end
    local humanoid = character:FindFirstChildOfClass("Humanoid")
    if not humanoid then return end
    humanoid.JumpPower = Settings.JumpBoost.Enabled and Settings.JumpBoost.Value or 50
end

local function UpdateFOVBoost()
    local camera = workspace.CurrentCamera
    if not camera then return end
    camera.FieldOfView = Settings.FOVBoost.Enabled and Settings.FOVBoost.Value or 70
end

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

local ESPObjects = {}
local function CreateESP(player)
    if player == Players.LocalPlayer or ESPObjects[player] then return end
    local character = player.Character
    if not character then return end
    local highlight = Instance.new("Highlight")
    highlight.FillTransparency = Settings.ESP.Transparency
    highlight.FillColor = Settings.ESP.Color
    highlight.OutlineTransparency = 0
    highlight.OutlineColor = Color3.fromRGB(200, 200, 200)
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
