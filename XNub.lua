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
    FOVBoost = {Enabled = false, Value = 90},
    Noclip = {Enabled = false},
    ESP = {Enabled = false, Transparency = 0.5, Color = Color3.fromRGB(255, 255, 255), Mode = "AlwaysOnTop"},
    InfiniteJump = {Enabled = false}
}

-- Сохранение состояния
local SavedState = {
    CategoryScrollPosition = 0,
    FunctionScrollPosition = 0,
    SelectedCategory = nil,
    EnabledFunctions = {}
}

-- Ключевая система
local KeySystemGUI = Instance.new("ScreenGui")
KeySystemGUI.Name = "XHubKeySystem"
KeySystemGUI.Parent = CoreGui
KeySystemGUI.IgnoreGuiInset = true
KeySystemGUI.DisplayOrder = 9999
KeySystemGUI.Enabled = true

local KeySystemFrame = Instance.new("Frame")
KeySystemFrame.Size = UDim2.new(1, 0, 1, 0)
KeySystemFrame.BackgroundColor3 = Color3.fromRGB(31, 31, 31)
KeySystemFrame.BackgroundTransparency = 1
KeySystemFrame.Parent = KeySystemGUI

local KeySystemTitle = Instance.new("TextLabel")
KeySystemTitle.Size = UDim2.new(0, 400, 0, 50)
KeySystemTitle.Position = UDim2.new(0.5, -200, 0.2, -25)
KeySystemTitle.Text = "X Hub • Ключ система"
KeySystemTitle.TextColor3 = Color3.fromRGB(147, 112, 219)
KeySystemTitle.TextSize = 24
KeySystemTitle.Font = Enum.Font.SourceSansBold
KeySystemTitle.BackgroundTransparency = 1
KeySystemTitle.TextTransparency = 1
KeySystemTitle.Parent = KeySystemFrame

local KeyInputFrame = Instance.new("Frame")
KeyInputFrame.Size = UDim2.new(0, 300, 0, 40)
KeyInputFrame.Position = UDim2.new(0.5, -150, 0.4, -20)
KeyInputFrame.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
KeyInputFrame.BackgroundTransparency = 1
KeyInputFrame.Parent = KeySystemFrame

local KeyInputCorner = Instance.new("UICorner")
KeyInputCorner.CornerRadius = UDim.new(0, 10)
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
KeyInput.PlaceholderText = "Ввести ключ"
KeyInput.PlaceholderColor3 = Color3.fromRGB(147, 112, 219)
KeyInput.TextColor3 = Color3.fromRGB(255, 255, 255)
KeyInput.TextSize = 16
KeyInput.Font = Enum.Font.SourceSans
KeyInput.TextTransparency = 1
KeyInput.Parent = KeyInputFrame

local ActivateButton = Instance.new("TextButton")
ActivateButton.Size = UDim2.new(0, 140, 0, 40)
ActivateButton.Position = UDim2.new(0.5, -150, 0.5, 0)
ActivateButton.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
ActivateButton.Text = "Активировать ключ"
ActivateButton.TextColor3 = Color3.fromRGB(147, 112, 219)
ActivateButton.TextSize = 16
ActivateButton.Font = Enum.Font.SourceSansSemibold
ActivateButton.TextTransparency = 1
ActivateButton.BackgroundTransparency = 1
ActivateButton.Parent = KeySystemFrame

local ActivateCorner = Instance.new("UICorner")
ActivateCorner.CornerRadius = UDim.new(0, 10)
ActivateCorner.Parent = ActivateButton

local ActivateStroke = Instance.new("UIStroke")
ActivateStroke.Color = Color3.fromRGB(147, 112, 219)
ActivateStroke.Thickness = 1
ActivateStroke.Transparency = 1
ActivateStroke.Parent = ActivateButton

local GetKeyButton = Instance.new("TextButton")
GetKeyButton.Size = UDim2.new(0, 140, 0, 40)
GetKeyButton.Position = UDim2.new(0.5, 10, 0.5, 0)
GetKeyButton.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
GetKeyButton.Text = "Получить ключ"
GetKeyButton.TextColor3 = Color3.fromRGB(147, 112, 219)
GetKeyButton.TextSize = 16
GetKeyButton.Font = Enum.Font.SourceSansSemibold
GetKeyButton.TextTransparency = 1
GetKeyButton.BackgroundTransparency = 1
GetKeyButton.Parent = KeySystemFrame

local GetKeyCorner = Instance.new("UICorner")
GetKeyCorner.CornerRadius = UDim.new(0, 10)
GetKeyCorner.Parent = GetKeyButton

local GetKeyStroke = Instance.new("UIStroke")
GetKeyStroke.Color = Color3.fromRGB(147, 112, 219)
GetKeyStroke.Thickness = 1
GetKeyStroke.Transparency = 1
GetKeyStroke.Parent = GetKeyButton

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

-- Анимация появления ключевой системы
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

local CorrectKey = "X"
local isKeySystemActive = true

-- Основной GUI
local XHubGUI = Instance.new("ScreenGui")
XHubGUI.Name = "XHub"
XHubGUI.Parent = CoreGui
XHubGUI.IgnoreGuiInset = true
XHubGUI.DisplayOrder = 1000
XHubGUI.Enabled = false

-- Круглая кнопка
local ToggleButton = Instance.new("TextButton")
ToggleButton.Size = UDim2.new(0, 50, 0, 50)
ToggleButton.Position = UDim2.new(0.5, -25, 0.5, -25)
ToggleButton.BackgroundColor3 = Color3.fromRGB(31, 31, 31)
ToggleButton.Text = "X"
ToggleButton.TextColor3 = Color3.fromRGB(255, 255, 255)
ToggleButton.TextSize = 20
ToggleButton.Font = Enum.Font.SourceSansBold
ToggleButton.BackgroundTransparency = 1
ToggleButton.TextTransparency = 1
ToggleButton.Parent = XHubGUI

local ToggleCorner = Instance.new("UICorner")
ToggleCorner.CornerRadius = UDim.new(1, 0)
ToggleCorner.Parent = ToggleButton

local ToggleStroke = Instance.new("UIStroke")
ToggleStroke.Color = Color3.fromRGB(147, 112, 219)
ToggleStroke.Thickness = 1
ToggleStroke.Transparency = 1
ToggleStroke.Parent = ToggleButton

-- Перемещение круглой кнопки
local Dragging = false
local DragStart = nil
local StartPos = nil

ToggleButton.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        Dragging = true
        DragStart = input.Position
        StartPos = ToggleButton.Position
    end
end)

ToggleButton.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        Dragging = false
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if Dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
        local delta = input.Position - DragStart
        local newPosX = StartPos.X.Offset + delta.X
        local newPosY = StartPos.Y.Offset + delta.Y
        ToggleButton.Position = UDim2.new(StartPos.X.Scale, newPosX, StartPos.Y.Scale, newPosY)
    end
end)

-- Основной фрейм
local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 400, 0, 250)
MainFrame.Position = UDim2.new(0.5, -200, 0.5, -125)
MainFrame.BackgroundColor3 = Color3.fromRGB(31, 31, 31)
MainFrame.BackgroundTransparency = 1
MainFrame.Parent = XHubGUI

local MainCorner = Instance.new("UICorner")
MainCorner.CornerRadius = UDim.new(0, 10)
MainCorner.Parent = MainFrame

local MainStroke = Instance.new("UIStroke")
MainStroke.Color = Color3.fromRGB(147, 112, 219)
MainStroke.Thickness = 1
MainStroke.Transparency = 1
MainStroke.Parent = MainFrame

-- Заголовок
local TitleFrame = Instance.new("Frame")
TitleFrame.Size = UDim2.new(1, 0, 0, 40)
TitleFrame.BackgroundColor3 = Color3.fromRGB(31, 31, 31)
TitleFrame.BackgroundTransparency = 1
TitleFrame.Parent = MainFrame

local TitleCorner = Instance.new("UICorner")
TitleCorner.CornerRadius = UDim.new(0, 10)
TitleCorner.Parent = TitleFrame

local TitleStroke = Instance.new("UIStroke")
TitleStroke.Color = Color3.fromRGB(147, 112, 219)
TitleStroke.Thickness = 1
TitleStroke.Transparency = 1
TitleStroke.Parent = TitleFrame

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(0.7, 0, 1, 0)
Title.Position = UDim2.new(0, 10, 0, 0)
Title.Text = "X Hub"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.TextSize = 20
Title.Font = Enum.Font.SourceSansBold
Title.BackgroundTransparency = 1
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.TextTransparency = 1
Title.Parent = TitleFrame

-- Кнопка закрытия
local CloseButton = Instance.new("TextButton")
CloseButton.Size = UDim2.new(0, 30, 0, 30)
CloseButton.Position = UDim2.new(1, -35, 0, 5)
CloseButton.Text = "X"
CloseButton.TextColor3 = Color3.fromRGB(255, 255, 255)
CloseButton.TextSize = 18
CloseButton.BackgroundTransparency = 1
CloseButton.TextTransparency = 1
CloseButton.Parent = TitleFrame

-- Разделитель
local Divider = Instance.new("Frame")
Divider.Size = UDim2.new(0, 1, 1, -40)
Divider.Position = UDim2.new(0.3, 0, 0, 40)
Divider.BackgroundColor3 = Color3.fromRGB(147, 112, 219)
Divider.BackgroundTransparency = 1
Divider.Parent = MainFrame

-- Категории
local CategoryFrame = Instance.new("ScrollingFrame")
CategoryFrame.Size = UDim2.new(0.3, 0, 1, -40)
CategoryFrame.Position = UDim2.new(0, 0, 0, 40)
CategoryFrame.BackgroundTransparency = 1
CategoryFrame.ScrollBarThickness = 4
CategoryFrame.ScrollBarImageColor3 = Color3.fromRGB(147, 112, 219)
CategoryFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
CategoryFrame.ScrollingDirection = Enum.ScrollingDirection.Y
CategoryFrame.Parent = MainFrame

local CategoryListLayout = Instance.new("UIListLayout")
CategoryListLayout.SortOrder = Enum.SortOrder.LayoutOrder
CategoryListLayout.Padding = UDim.new(0, 5)
CategoryListLayout.Parent = CategoryFrame

-- Функции
local FunctionFrame = Instance.new("ScrollingFrame")
FunctionFrame.Size = UDim2.new(0.7, -1, 1, -40)
FunctionFrame.Position = UDim2.new(0.3, 1, 0, 40)
FunctionFrame.BackgroundTransparency = 1
FunctionFrame.ScrollBarThickness = 4
FunctionFrame.ScrollBarImageColor3 = Color3.fromRGB(147, 112, 219)
FunctionFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
FunctionFrame.ScrollingDirection = Enum.ScrollingDirection.Y
FunctionFrame.Parent = MainFrame

local FunctionListLayout = Instance.new("UIListLayout")
FunctionListLayout.SortOrder = Enum.SortOrder.LayoutOrder
FunctionListLayout.Padding = UDim.new(0, 5)
FunctionListLayout.Parent = FunctionFrame

-- Обновление CanvasSize
local function UpdateCategoryCanvasSize()
    local totalHeight = 0
    for _, child in pairs(CategoryFrame:GetChildren()) do
        if child:IsA("TextButton") then
            totalHeight = totalHeight + child.Size.Y.Offset + CategoryListLayout.Padding.Offset
        end
    end
    CategoryFrame.CanvasSize = UDim2.new(0, 0, 0, totalHeight)
end

local function UpdateFunctionCanvasSize()
    local totalHeight = 0
    for _, child in pairs(FunctionFrame:GetChildren()) do
        if child:IsA("Frame") then
            totalHeight = totalHeight + child.Size.Y.Offset + FunctionListLayout.Padding.Offset
        end
    end
    FunctionFrame.CanvasSize = UDim2.new(0, 0, 0, totalHeight)
end

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
    }}
}

-- Создание категорий
for i, category in pairs(Categories) do
    local CategoryButton = Instance.new("TextButton")
    CategoryButton.Size = UDim2.new(1, -10, 0, 30)
    CategoryButton.Position = UDim2.new(0, 5, 0, 0)
    CategoryButton.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    CategoryButton.Text = category.Name
    CategoryButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    CategoryButton.TextSize = 14
    CategoryButton.Font = Enum.Font.SourceSans
    CategoryButton.BackgroundTransparency = 1
    CategoryButton.TextTransparency = 1
    CategoryButton.LayoutOrder = i
    CategoryButton.Parent = CategoryFrame

    local CategoryCorner = Instance.new("UICorner")
    CategoryCorner.CornerRadius = UDim.new(0, 5)
    CategoryCorner.Parent = CategoryButton

    local CategoryStroke = Instance.new("UIStroke")
    CategoryStroke.Color = Color3.fromRGB(147, 112, 219)
    CategoryStroke.Thickness = 1
    CategoryStroke.Transparency = 1
    CategoryStroke.Parent = CategoryButton

    local fadeInCategory = TweenService:Create(CategoryButton, TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {BackgroundTransparency = 0, TextTransparency = 0})
    local fadeInCategoryStroke = TweenService:Create(CategoryStroke, TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Transparency = 0})
    fadeInCategory:Play()
    fadeInCategoryStroke:Play()

    CategoryButton.MouseButton1Click:Connect(function()
        SavedState.SelectedCategory = category.Name
        FunctionFrame:ClearAllChildren()
        FunctionFrame.CanvasPosition = Vector2.new(0, 0)
        FunctionListLayout.Parent = FunctionFrame

        for j, func in pairs(category.Functions) do
            local FuncFrame = Instance.new("Frame")
            local height = 30
            if func.HasInput then height = height + 30 end
            FuncFrame.Size = UDim2.new(1, -10, 0, height)
            FuncFrame.Position = UDim2.new(0, 5, 0, 0)
            FuncFrame.BackgroundTransparency = 1
            FuncFrame.LayoutOrder = j
            FuncFrame.Parent = FunctionFrame

            local FuncLabel = Instance.new("TextLabel")
            FuncLabel.Size = UDim2.new(0.7, 0, 0, 30)
            FuncLabel.Position = UDim2.new(0, 10, 0, 0)
            FuncLabel.Text = func.Name
            FuncLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
            FuncLabel.TextSize = 14
            FuncLabel.Font = Enum.Font.SourceSans
            FuncLabel.BackgroundTransparency = 1
            FuncLabel.TextXAlignment = Enum.TextXAlignment.Left
            FuncLabel.TextTransparency = 1
            FuncLabel.Parent = FuncFrame

            if func.Name ~= "Перезайти" then
                local ToggleButton = Instance.new("TextButton")
                ToggleButton.Size = UDim2.new(0, 24, 0, 24)
                ToggleButton.Position = UDim2.new(1, -34, 0, 3)
                ToggleButton.BackgroundColor3 = func.Setting and (func.Setting.Enabled and Color3.fromRGB(147, 112, 219) or Color3.fromRGB(255, 255, 255)) or Color3.fromRGB(100, 100, 100)
                ToggleButton.Text = ""
                ToggleButton.BackgroundTransparency = 1
                ToggleButton.Parent = FuncFrame

                local ToggleCorner = Instance.new("UICorner")
                ToggleCorner.CornerRadius = UDim.new(0, 5)
                ToggleCorner.Parent = ToggleButton

                local ToggleStroke = Instance.new("UIStroke")
                ToggleStroke.Color = Color3.fromRGB(147, 112, 219)
                ToggleStroke.Thickness = 1
                ToggleStroke.Transparency = 1
                ToggleStroke.Parent = ToggleButton

                local fadeInToggle = TweenService:Create(ToggleButton, TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {BackgroundTransparency = 0})
                local fadeInToggleStroke = TweenService:Create(ToggleStroke, TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Transparency = 0})
                local fadeInLabel = TweenService:Create(FuncLabel, TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {TextTransparency = 0})
                fadeInToggle:Play()
                fadeInToggleStroke:Play()
                fadeInLabel:Play()

                if func.Setting then
                    ToggleButton.MouseButton1Click:Connect(function()
                        func.Setting.Enabled = not func.Setting.Enabled
                        SavedState.EnabledFunctions[func.Name] = func.Setting.Enabled
                        local newColor = func.Setting.Enabled and Color3.fromRGB(147, 112, 219) or Color3.fromRGB(255, 255, 255)
                        local tween = TweenService:Create(ToggleButton, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {BackgroundColor3 = newColor})
                        tween:Play()
                    end)
                else
                    ToggleButton.MouseButton1Click:Connect(func.Action)
                end

                if func.HasInput then
                    local InputField = Instance.new("TextBox")
                    InputField.Size = UDim2.new(0.8, 0, 0, 25)
                    InputField.Position = UDim2.new(0, 10, 0, 35)
                    InputField.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
                    InputField.Text = tostring(func.Setting.Value)
                    InputField.TextColor3 = Color3.fromRGB(255, 255, 255)
                    InputField.TextSize = 14
                    InputField.Font = Enum.Font.SourceSans
                    InputField.BackgroundTransparency = 1
                    InputField.TextTransparency = 1
                    InputField.Parent = FuncFrame

                    local InputCorner = Instance.new("UICorner")
                    InputCorner.CornerRadius = UDim.new(0, 5)
                    InputCorner.Parent = InputField

                    local InputStroke = Instance.new("UIStroke")
                    InputStroke.Color = Color3.fromRGB(147, 112, 219)
                    InputStroke.Thickness = 1
                    InputStroke.Transparency = 1
                    InputStroke.Parent = InputField

                    local fadeInInput = TweenService:Create(InputField, TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {BackgroundTransparency = 0, TextTransparency = 0})
                    local fadeInInputStroke = TweenService:Create(InputStroke, TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Transparency = 0})
                    fadeInInput:Play()
                    fadeInInputStroke:Play()

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
                    SettingsButton.Size = UDim2.new(0, 24, 0, 24)
                    SettingsButton.Position = UDim2.new(1, -64, 0, 3)
                    SettingsButton.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
                    SettingsButton.Text = "⚙"
                    SettingsButton.TextColor3 = Color3.fromRGB(255, 255, 255)
                    SettingsButton.TextSize = 14
                    SettingsButton.BackgroundTransparency = 1
                    SettingsButton.TextTransparency = 1
                    SettingsButton.Parent = FuncFrame

                    local SettingsCorner = Instance.new("UICorner")
                    SettingsCorner.CornerRadius = UDim.new(0, 5)
                    SettingsCorner.Parent = SettingsButton

                    local SettingsStroke = Instance.new("UIStroke")
                    SettingsStroke.Color = Color3.fromRGB(147, 112, 219)
                    SettingsStroke.Thickness = 1
                    SettingsStroke.Transparency = 1
                    SettingsStroke.Parent = SettingsButton

                    local fadeInSettingsButton = TweenService:Create(SettingsButton, TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {BackgroundTransparency = 0, TextTransparency = 0})
                    local fadeInSettingsStroke = TweenService:Create(SettingsStroke, TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Transparency = 0})
                    fadeInSettingsButton:Play()
                    fadeInSettingsStroke:Play()

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
                        SettingsFrame.BackgroundColor3 = Color3.fromRGB(31, 31, 31)
                        SettingsFrame.BackgroundTransparency = 1
                        SettingsFrame.Parent = XHubGUI

                        local SettingsCorner = Instance.new("UICorner")
                        SettingsCorner.CornerRadius = UDim.new(0, 10)
                        SettingsCorner.Parent = SettingsFrame

                        local SettingsStroke = Instance.new("UIStroke")
                        SettingsStroke.Color = Color3.fromRGB(147, 112, 219)
                        SettingsStroke.Thickness = 1
                        SettingsStroke.Transparency = 1
                        SettingsStroke.Parent = SettingsFrame

                        local SettingsTitle = Instance.new("TextLabel")
                        SettingsTitle.Name = "SettingsTitle"
                        SettingsTitle.Size = UDim2.new(1, 0, 0, 30)
                        SettingsTitle.Position = UDim2.new(0, 0, 0, 0)
                        SettingsTitle.Text = "Настройка ESP"
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

                        local ColorButton = Instance.new("TextButton")
                        ColorButton.Name = "ColorButton"
                        ColorButton.Size = UDim2.new(0, 150, 0, 30)
                        ColorButton.Position = UDim2.new(0, 15, 0, 40)
                        ColorButton.BackgroundColor3 = func.Setting.Color
                        ColorButton.Text = "Цвет ESP"
                        ColorButton.TextColor3 = Color3.fromRGB(255, 255, 255)
                        ColorButton.TextSize = 14
                        ColorButton.BackgroundTransparency = 1
                        ColorButton.TextTransparency = 1
                        ColorButton.Parent = SettingsFrame

                        local ColorCorner = Instance.new("UICorner")
                        ColorCorner.CornerRadius = UDim.new(0, 5)
                        ColorCorner.Parent = ColorButton

                        local ModeButton = Instance.new("TextButton")
                        ModeButton.Name = "ModeButton"
                        ModeButton.Size = UDim2.new(0, 150, 0, 30)
                        ModeButton.Position = UDim2.new(0, 15, 0, 80)
                        ModeButton.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
                        ModeButton.Text = "Режим: " .. (func.Setting.Mode == "AlwaysOnTop" and "Показывать" or "Не показывать")
                        ModeButton.TextColor3 = Color3.fromRGB(255, 255, 255)
                        ModeButton.TextSize = 14
                        ModeButton.BackgroundTransparency = 1
                        ModeButton.TextTransparency = 1
                        ModeButton.Parent = SettingsFrame

                        local ModeCorner = Instance.new("UICorner")
                        ModeCorner.CornerRadius = UDim.new(0, 5)
                        ModeCorner.Parent = ModeButton

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

                        CloseButton.MouseButton1Click:Connect(function()
                            local fadeOutSettings = TweenService:Create(SettingsFrame, TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {BackgroundTransparency = 1})
                            local fadeOutStroke = TweenService:Create(SettingsStroke, TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {Transparency = 1})
                            local fadeOutTitle = TweenService:Create(SettingsTitle, TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {TextTransparency = 1})
                            local fadeOutCloseButton = TweenService:Create(CloseButton, TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {TextTransparency = 1})
                            local fadeOutColorButton = TweenService:Create(ColorButton, TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {BackgroundTransparency = 1, TextTransparency = 1})
                            local fadeOutModeButton = TweenService:Create(ModeButton, TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {BackgroundTransparency = 1, TextTransparency = 1})

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

                        ColorButton.MouseButton1Click:Connect(function()
                            local r = math.random(0, 255)
                            local g = math.random(0, 255)
                            local b = math.random(0, 255)
                            func.Setting.Color = Color3.fromRGB(r, g, b)
                            ColorButton.BackgroundColor3 = func.Setting.Color
                        end)

                        ModeButton.MouseButton1Click:Connect(function()
                            func.Setting.Mode = func.Setting.Mode == "AlwaysOnTop" and "ThroughWalls" or "AlwaysOnTop"
                            ModeButton.Text = "Режим: " .. (func.Setting.Mode == "AlwaysOnTop" and "Показывать" or "Не показывать")
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
                    end)
                end
            end
        end
        UpdateFunctionCanvasSize()
    end)
end

UpdateCategoryCanvasSize()

-- Перемещение главного меню
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

-- Открытие/закрытие меню
local IsMainMenuOpen = false

local function ToggleMainMenu()
    IsMainMenuOpen = not IsMainMenuOpen
    local transparency = IsMainMenuOpen and 0 or 1
    local tweenInfo = TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
    local tweenMainFrame = TweenService:Create(MainFrame, tweenInfo, {BackgroundTransparency = transparency})
    local tweenMainStroke = TweenService:Create(MainStroke, tweenInfo, {Transparency = transparency})
    local tweenTitleFrame = TweenService:Create(TitleFrame, tweenInfo, {BackgroundTransparency = transparency})
    local tweenTitleStroke = TweenService:Create(TitleStroke, tweenInfo, {Transparency = transparency})
    local tweenTitle = TweenService:Create(Title, tweenInfo, {TextTransparency = transparency})
    local tweenCloseButton = TweenService:Create(CloseButton, tweenInfo, {TextTransparency = transparency})
    local tweenDivider = TweenService:Create(Divider, tweenInfo, {BackgroundTransparency = transparency})

    tweenMainFrame:Play()
    tweenMainStroke:Play()
    tweenTitleFrame:Play()
    tweenTitleStroke:Play()
    tweenTitle:Play()
    tweenCloseButton:Play()
    tweenDivider:Play()

    MainFrame.Visible = IsMainMenuOpen
end

ToggleButton.MouseButton1Click:Connect(ToggleMainMenu)
CloseButton.MouseButton1Click:Connect(ToggleMainMenu)

-- Логика ключевой системы
GetKeyButton.MouseButton1Click:Connect(function()
    local message = "Ваш ключ: X"
    pcall(function()
        setclipboard(message)
        ShowFeedback("Текст скопирован в ваш буфер обмена", Color3.fromRGB(147, 112, 219))
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

        fadeOutFrame.Completed:Connect(function()
            KeySystemGUI:Destroy()
            XHubGUI.Enabled = true
            local fadeInToggle = TweenService:Create(ToggleButton, TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {BackgroundTransparency = 0, TextTransparency = 0})
            local fadeInToggleStroke = TweenService:Create(ToggleStroke, TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Transparency = 0})
            fadeInToggle:Play()
            fadeInToggleStroke:Play()
        end)
    else
        ShowFeedback("Неверный ключ, пожалуйста, получите его.", Color3.fromRGB(255, 0, 0))
    end
end)

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

-- Сохранение состояния прокрутки
CategoryFrame:GetPropertyChangedSignal("CanvasPosition"):Connect(function()
    SavedState.CategoryScrollPosition = CategoryFrame.CanvasPosition.Y
end)

FunctionFrame:GetPropertyChangedSignal("CanvasPosition"):Connect(function()
    SavedState.FunctionScrollPosition = FunctionFrame.CanvasPosition.Y
end)

-- Восстановление состояния
local function RestoreState()
    if SavedState.SelectedCategory then
        for _, category in pairs(Categories) do
            if category.Name == SavedState.SelectedCategory then
                for _, child in pairs(CategoryFrame:GetChildren()) do
                    if child:IsA("TextButton") and child.Text == category.Name then
                        child:Activate()
                        break
                    end
                end
                break
            end
        end
    end
    for funcName, enabled in pairs(SavedState.EnabledFunctions) do
        for _, category in pairs(Categories) do
            for _, func in pairs(category.Functions) do
                if func.Name == funcName and func.Setting then
                    func.Setting.Enabled = enabled
                end
            end
        end
    end
    CategoryFrame.CanvasPosition = Vector2.new(0, SavedState.CategoryScrollPosition)
    FunctionFrame.CanvasPosition = Vector2.new(0, SavedState.FunctionScrollPosition)
end

-- Инициализация
RestoreState()
