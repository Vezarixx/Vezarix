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
    CategoriesExpanded = {},
    ScrollPositions = {Categories = 0, Functions = 0},
    MainMenuOpen = false
}

-- Основной GUI
local XHubGUI = Instance.new("ScreenGui")
XHubGUI.Name = "XHub"
XHubGUI.Parent = CoreGui
XHubGUI.IgnoreGuiInset = true
XHubGUI.DisplayOrder = 1000
XHubGUI.Enabled = true

-- Круглая кнопка для открытия/закрытия основного меню
local MiniButton = Instance.new("TextButton")
MiniButton.Size = UDim2.new(0, 50, 0, 50)
MiniButton.Position = UDim2.new(0.5, -25, 0.5, -25)
MiniButton.BackgroundColor3 = Color3.fromRGB(31, 31, 31)
MiniButton.Text = "X"
MiniButton.TextColor3 = Color3.fromRGB(255, 255, 255)
MiniButton.TextSize = 24
MiniButton.Font = Enum.Font.SourceSansBold
MiniButton.BackgroundTransparency = 1
MiniButton.TextTransparency = 1
MiniButton.Parent = XHubGUI

local MiniButtonCorner = Instance.new("UICorner")
MiniButtonCorner.CornerRadius = UDim.new(1, 0)
MiniButtonCorner.Parent = MiniButton

local MiniButtonStroke = Instance.new("UIStroke")
MiniButtonStroke.Color = Color3.fromRGB(147, 112, 219)
MiniButtonStroke.Thickness = 1
MiniButtonStroke.Transparency = 1
MiniButtonStroke.Parent = MiniButton

-- Плавное появление круглой кнопки
local function ShowMiniButton()
    local fadeInButton = TweenService:Create(MiniButton, TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {BackgroundTransparency = 0, TextTransparency = 0})
    local fadeInStroke = TweenService:Create(MiniButtonStroke, TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Transparency = 0})
    fadeInButton:Play()
    fadeInStroke:Play()
end

-- Перемещение круглой кнопки
local DraggingMini = false
local DragStartMini = nil
local StartPosMini = nil

MiniButton.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        DraggingMini = true
        DragStartMini = input.Position
        StartPosMini = MiniButton.Position
    end
end)

MiniButton.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        DraggingMini = false
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if DraggingMini and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
        local delta = input.Position - DragStartMini
        local newPosX = StartPosMini.X.Offset + delta.X
        local newPosY = StartPosMini.Y.Offset + delta.Y
        MiniButton.Position = UDim2.new(StartPosMini.X.Scale, newPosX, StartPosMini.Y.Scale, newPosY)
    end
end)

-- Основной фрейм
local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 900, 0, 500)
MainFrame.Position = UDim2.new(0.5, -450, 0.5, -250)
MainFrame.BackgroundColor3 = Color3.fromRGB(31, 31, 31)
MainFrame.BackgroundTransparency = 1
MainFrame.Active = true
MainFrame.Visible = false
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
local TitleBar = Instance.new("Frame")
TitleBar.Size = UDim2.new(1, 0, 0, 50)
TitleBar.BackgroundColor3 = Color3.fromRGB(31, 31, 31)
TitleBar.BackgroundTransparency = 1
TitleBar.Parent = MainFrame

local TitleCorner = Instance.new("UICorner")
TitleCorner.CornerRadius = UDim.new(0, 10)
TitleCorner.Parent = TitleBar

local TitleStroke = Instance.new("UIStroke")
TitleStroke.Color = Color3.fromRGB(147, 112, 219)
TitleStroke.Thickness = 1
TitleStroke.Transparency = 1
TitleStroke.Parent = TitleBar

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(0.7, 0, 1, 0)
Title.Position = UDim2.new(0, 20, 0, 0)
Title.Text = "X Hub"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.TextSize = 24
Title.Font = Enum.Font.SourceSansBold
Title.BackgroundTransparency = 1
Title.TextTransparency = 1
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.Parent = TitleBar

-- Кнопка закрытия
local CloseButton = Instance.new("TextButton")
CloseButton.Size = UDim2.new(0, 30, 0, 30)
CloseButton.Position = UDim2.new(1, -40, 0, 10)
CloseButton.Text = "X"
CloseButton.TextColor3 = Color3.fromRGB(255, 255, 255)
CloseButton.TextSize = 18
CloseButton.BackgroundTransparency = 1
CloseButton.TextTransparency = 1
CloseButton.Parent = TitleBar

-- Разделитель
local Divider = Instance.new("Frame")
Divider.Size = UDim2.new(0, 2, 0, 450)
Divider.Position = UDim2.new(0, 250, 0, 50)
Divider.BackgroundColor3 = Color3.fromRGB(147, 112, 219)
Divider.BackgroundTransparency = 1
Divider.Parent = MainFrame

-- Левая часть (категории)
local CategoriesFrame = Instance.new("ScrollingFrame")
CategoriesFrame.Size = UDim2.new(0, 250, 0, 450)
CategoriesFrame.Position = UDim2.new(0, 0, 0, 50)
CategoriesFrame.BackgroundTransparency = 1
CategoriesFrame.ScrollBarThickness = 4
CategoriesFrame.ScrollBarImageColor3 = Color3.fromRGB(147, 112, 219)
CategoriesFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
CategoriesFrame.ScrollingDirection = Enum.ScrollingDirection.Y
CategoriesFrame.Parent = MainFrame

local CategoriesListLayout = Instance.new("UIListLayout")
CategoriesListLayout.SortOrder = Enum.SortOrder.LayoutOrder
CategoriesListLayout.Padding = UDim.new(0, 5)
CategoriesListLayout.Parent = CategoriesFrame

-- Правая часть (функции)
local FunctionsFrame = Instance.new("ScrollingFrame")
FunctionsFrame.Size = UDim2.new(0, 648, 0, 450)
FunctionsFrame.Position = UDim2.new(0, 252, 0, 50)
FunctionsFrame.BackgroundTransparency = 1
FunctionsFrame.ScrollBarThickness = 4
FunctionsFrame.ScrollBarImageColor3 = Color3.fromRGB(147, 112, 219)
FunctionsFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
FunctionsFrame.ScrollingDirection = Enum.ScrollingDirection.Y
FunctionsFrame.Parent = MainFrame

local FunctionsListLayout = Instance.new("UIListLayout")
FunctionsListLayout.SortOrder = Enum.SortOrder.LayoutOrder
FunctionsListLayout.Padding = UDim.new(0, 5)
FunctionsListLayout.Parent = FunctionsFrame

-- Функция для обновления CanvasSize
local function UpdateCanvasSize(scrollFrame, layout)
    local totalHeight = 0
    for _, child in pairs(scrollFrame:GetChildren()) do
        if child:IsA("Frame") then
            totalHeight = totalHeight + child.Size.Y.Offset + layout.Padding.Offset
        end
    end
    scrollFrame.CanvasSize = UDim2.new(0, 0, 0, totalHeight)
end

-- Плавное открытие/закрытие главного меню
local function ToggleMainMenu()
    SavedState.MainMenuOpen = not SavedState.MainMenuOpen
    MainFrame.Visible = SavedState.MainMenuOpen
    local transparency = SavedState.MainMenuOpen and 0 or 1
    local tweenInfo = TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
    local fadeMain = TweenService:Create(MainFrame, tweenInfo, {BackgroundTransparency = transparency})
    local fadeStroke = TweenService:Create(MainStroke, tweenInfo, {Transparency = transparency})
    local fadeTitleBar = TweenService:Create(TitleBar, tweenInfo, {BackgroundTransparency = transparency})
    local fadeTitleStroke = TweenService:Create(TitleStroke, tweenInfo, {Transparency = transparency})
    local fadeTitle = TweenService:Create(Title, tweenInfo, {TextTransparency = transparency})
    local fadeClose = TweenService:Create(CloseButton, tweenInfo, {TextTransparency = transparency})
    local fadeDivider = TweenService:Create(Divider, tweenInfo, {BackgroundTransparency = transparency})
    fadeMain:Play()
    fadeStroke:Play()
    fadeTitleBar:Play()
    fadeTitleStroke:Play()
    fadeTitle:Play()
    fadeClose:Play()
    fadeDivider:Play()
end

MiniButton.MouseButton1Click:Connect(ToggleMainMenu)
CloseButton.MouseButton1Click:Connect(ToggleMainMenu)

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

-- Категории
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
    CategoryButtonFrame.Position = UDim2.new(0, 5, 0, 0)
    CategoryButtonFrame.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    CategoryButtonFrame.BackgroundTransparency = 1
    CategoryButtonFrame.LayoutOrder = i
    CategoryButtonFrame.Parent = CategoriesFrame

    local CategoryCorner = Instance.new("UICorner")
    CategoryCorner.CornerRadius = UDim.new(0, 8)
    CategoryCorner.Parent = CategoryButtonFrame

    local CategoryStroke = Instance.new("UIStroke")
    CategoryStroke.Color = Color3.fromRGB(147, 112, 219)
    CategoryStroke.Thickness = 1
    CategoryStroke.Transparency = 1
    CategoryStroke.Parent = CategoryButtonFrame

    local CategoryButton = Instance.new("TextButton")
    CategoryButton.Size = UDim2.new(1, -10, 1, -10)
    CategoryButton.Position = UDim2.new(0, 5, 0, 5)
    CategoryButton.BackgroundTransparency = 1
    CategoryButton.Text = category.Name
    CategoryButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    CategoryButton.TextSize = 16
    CategoryButton.Font = Enum.Font.SourceSansBold
    CategoryButton.TextTransparency = 1
    CategoryButton.Parent = CategoryButtonFrame

    local function UpdateCategoryButton()
        CategoryButtonFrame.BackgroundTransparency = SavedState.CategoriesExpanded[category.Name] and 0 or 0.5
    end

    -- Плавное появление категории
    local fadeInCategory = TweenService:Create(CategoryButtonFrame, TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {BackgroundTransparency = 0.5})
    local fadeInStroke = TweenService:Create(CategoryStroke, TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Transparency = 0})
    local fadeInText = TweenService:Create(CategoryButton, TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {TextTransparency = 0})
    fadeInCategory:Play()
    fadeInStroke:Play()
    fadeInText:Play()

    CategoryButton.MouseButton1Click:Connect(function()
        -- Очистка функций
        for _, child in pairs(FunctionsFrame:GetChildren()) do
            if child:IsA("Frame") then
                child:Destroy()
            end
        end

        SavedState.CategoriesExpanded[category.Name] = true
        for _, cat in pairs(Categories) do
            if cat.Name ~= category.Name then
                SavedState.CategoriesExpanded[cat.Name] = false
            end
        end

        -- Обновление визуала категорий
        for _, child in pairs(CategoriesFrame:GetChildren()) do
            if child:IsA("Frame") then
                local button = child:FindFirstChildWhichIsA("TextButton")
                if button then
                    local catName = button.Text
                    child.BackgroundTransparency = SavedState.CategoriesExpanded[catName] and 0 or 0.5
                end
            end
        end

        -- Создание функций
        for j, func in pairs(category.Functions) do
            local FuncFrame = Instance.new("Frame")
            local height = func.HasInput and 70 or 40
            FuncFrame.Size = UDim2.new(1, -10, 0, height)
            FuncFrame.Position = UDim2.new(0, 5, 0, 0)
            FuncFrame.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
            FuncFrame.BackgroundTransparency = 1
            FuncFrame.LayoutOrder = j
            FuncFrame.Parent = FunctionsFrame

            local FuncCorner = Instance.new("UICorner")
            FuncCorner.CornerRadius = UDim.new(0, 8)
            FuncCorner.Parent = FuncFrame

            local FuncStroke = Instance.new("UIStroke")
            FuncStroke.Color = Color3.fromRGB(147, 112, 219)
            FuncStroke.Thickness = 1
            FuncStroke.Transparency = 1
            FuncStroke.Parent = FuncFrame

            local FuncLabel = Instance.new("TextLabel")
            FuncLabel.Size = UDim2.new(0.7, 0, 0, 40)
            FuncLabel.Position = UDim2.new(0, 10, 0, 0)
            FuncLabel.Text = func.Name
            FuncLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
            FuncLabel.TextSize = 14
            FuncLabel.Font = Enum.Font.SourceSans
            FuncLabel.BackgroundTransparency = 1
            FuncLabel.TextTransparency = 1
            FuncLabel.TextXAlignment = Enum.TextXAlignment.Left
            FuncLabel.Parent = FuncFrame

            -- Плавное появление функции
            local fadeInFunc = TweenService:Create(FuncFrame, TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {BackgroundTransparency = 0})
            local fadeInFuncStroke = TweenService:Create(FuncStroke, TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Transparency = 0})
            local fadeInFuncText = TweenService:Create(FuncLabel, TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {TextTransparency = 0})
            fadeInFunc:Play()
            fadeInFuncStroke:Play()
            fadeInFuncText:Play()

            if func.Name ~= "Перезайти" then
                local ToggleButton = Instance.new("TextButton")
                ToggleButton.Size = UDim2.new(0, 30, 0, 30)
                ToggleButton.Position = UDim2.new(1, -40, 0, 5)
                ToggleButton.BackgroundColor3 = func.Setting.Enabled and Color3.fromRGB(147, 112, 219) or Color3.fromRGB(255, 255, 255)
                ToggleButton.Text = ""
                ToggleButton.BackgroundTransparency = 1
                ToggleButton.Parent = FuncFrame

                local ToggleCorner = Instance.new("UICorner")
                ToggleCorner.CornerRadius = UDim.new(0, 8)
                ToggleCorner.Parent = ToggleButton

                local ToggleStroke = Instance.new("UIStroke")
                ToggleStroke.Color = Color3.fromRGB(147, 112, 219)
                ToggleStroke.Thickness = 1
                ToggleStroke.Transparency = 1
                ToggleStroke.Parent = ToggleButton

                local fadeInToggle = TweenService:Create(ToggleButton, TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {BackgroundTransparency = 0})
                local fadeInToggleStroke = TweenService:Create(ToggleStroke, TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Transparency = 0})
                fadeInToggle:Play()
                fadeInToggleStroke:Play()

                local function UpdateToggle()
                    local tweenInfo = TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
                    local color = func.Setting.Enabled and Color3.fromRGB(147, 112, 219) or Color3.fromRGB(255, 255, 255)
                    local tween = TweenService:Create(ToggleButton, tweenInfo, {BackgroundColor3 = color})
                    tween:Play()
                end

                ToggleButton.MouseButton1Click:Connect(function()
                    func.Setting.Enabled = not func.Setting.Enabled
                    UpdateToggle()
                end)

                if func.HasInput then
                    local InputField = Instance.new("TextBox")
                    InputField.Size = UDim2.new(0.8, 0, 0, 25)
                    InputField.Position = UDim2.new(0, 10, 0, 40)
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
                    SettingsButton.Size = UDim2.new(0, 30, 0, 30)
                    SettingsButton.Position = UDim2.new(1, -80, 0, 5)
                    SettingsButton.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
                    SettingsButton.Text = "⚙"
                    SettingsButton.TextColor3 = Color3.fromRGB(255, 255, 255)
                    SettingsButton.TextSize = 14
                    SettingsButton.BackgroundTransparency = 1
                    SettingsButton.TextTransparency = 1
                    SettingsButton.Parent = FuncFrame

                    local SettingsCorner = Instance.new("UICorner")
                    SettingsCorner.CornerRadius = UDim.new(0, 8)
                    SettingsCorner.Parent = SettingsButton

                    local SettingsStroke = Instance.new("UIStroke")
                    SettingsStroke.Color = Color3.fromRGB(147, 112, 219)
                    SettingsStroke.Thickness = 1
                    SettingsStroke.Transparency = 1
                    SettingsStroke.Parent = SettingsButton

                    local fadeInSettings = TweenService:Create(SettingsButton, TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {BackgroundTransparency = 0, TextTransparency = 0})
                    local fadeInSettingsStroke = TweenService:Create(SettingsStroke, TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Transparency = 0})
                    fadeInSettings:Play()
                    fadeInSettingsStroke:Play()

                    local SettingsFrame = nil

                    SettingsButton.MouseButton1Click:Connect(function()
                        if SettingsFrame then
                            local fadeOutSettings = TweenService:Create(SettingsFrame, TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {BackgroundTransparency = 1})
                            local fadeOutStroke = TweenService:Create(SettingsFrame:FindFirstChild("UIStroke"), TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {Transparency = 1})
                            local fadeOutTitle = TweenService:Create(SettingsFrame:FindFirstChild("SettingsTitle"), TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {TextTransparency = 1})
                            local fadeOutClose = TweenService:Create(SettingsFrame:FindFirstChild("CloseButton"), TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {TextTransparency = 1})
                            local fadeOutColor = TweenService:Create(SettingsFrame:FindFirstChild("ColorButton"), TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {BackgroundTransparency = 1, TextTransparency = 1})
                            local fadeOutMode = TweenService:Create(SettingsFrame:FindFirstChild("ModeButton"), TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {BackgroundTransparency = 1, TextTransparency = 1})

                            fadeOutSettings:Play()
                            fadeOutStroke:Play()
                            fadeOutTitle:Play()
                            fadeOutClose:Play()
                            fadeOutColor:Play()
                            fadeOutMode:Play()

                            fadeOutSettings.Completed:Connect(function()
                                SettingsFrame:Destroy()
                                SettingsFrame = nil
                            end)
                            return
                        end

                        SettingsFrame = Instance.new("Frame")
                        SettingsFrame.Name = "ESPSettings"
                        SettingsFrame.Size = UDim2.new(0, 200, 0, 150)
                        SettingsFrame.Position = UDim2.new(0.5, -100, 0.5, -75)
                        SettingsFrame.BackgroundColor3 = Color3.fromRGB(31, 31, 31)
                        SettingsFrame.BackgroundTransparency = 1
                        SettingsFrame.Parent = XHubGUI

                        local SettingsCorner = Instance.new("UICorner")
                        SettingsCorner.CornerRadius = UDim.new(0, 10)
                        SettingsCorner.Parent = SettingsFrame

                        local SettingsStroke = Instance.new("UIStroke")
                        SettingsStroke.Name = "UIStroke"
                        SettingsStroke.Color = Color3.fromRGB(147, 112, 219)
                        SettingsStroke.Thickness = 1
                        SettingsStroke.Transparency = 1
                        SettingsStroke.Parent = SettingsFrame

                        local SettingsTitle = Instance.new("TextLabel")
                        SettingsTitle.Name = "SettingsTitle"
                        SettingsTitle.Size = UDim2.new(1, 0, 0, 30)
                        SettingsTitle.Text = "Настройка ESP"
                        SettingsTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
                        SettingsTitle.TextSize = 16
                        SettingsTitle.Font = Enum.Font.SourceSansBold
                        SettingsTitle.BackgroundTransparency = 1
                        SettingsTitle.TextTransparency = 1
                        SettingsTitle.TextXAlignment = Enum.TextXAlignment.Center
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
                            local fadeOutClose = TweenService:Create(CloseButton, TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {TextTransparency = 1})
                            local fadeOutColor = TweenService:Create(SettingsFrame:FindFirstChild("ColorButton"), TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {BackgroundTransparency = 1, TextTransparency = 1})
                            local fadeOutMode = TweenService:Create(SettingsFrame:FindFirstChild("ModeButton"), TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {BackgroundTransparency = 1, TextTransparency = 1})

                            fadeOutSettings:Play()
                            fadeOutStroke:Play()
                            fadeOutTitle:Play()
                            fadeOutClose:Play()
                            fadeOutColor:Play()
                            fadeOutMode:Play()

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
                        ModeButton.Size = UDim2.new(0, 160, 0, 30)
                        ModeButton.Position = UDim2.new(0, 20, 0, 80)
                        ModeButton.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
                        ModeButton.Text = func.Setting.Mode == "AlwaysOnTop" and "Показывать" or "Не показывать"
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
                            ModeButton.Text = func.Setting.Mode == "AlwaysOnTop" and "Показывать" or "Не показывать"
                        end)

                        local fadeInSettingsFrame = TweenService:Create(SettingsFrame, TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {BackgroundTransparency = 0})
                        local fadeInSettingsStroke = TweenService:Create(SettingsStroke, TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Transparency = 0})
                        local fadeInSettingsTitle = TweenService:Create(SettingsTitle, TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {TextTransparency = 0})
                        local fadeInSettingsClose = TweenService:Create(CloseButton, TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {TextTransparency = 0})
                        local fadeInColorButton = TweenService:Create(ColorButton, TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {BackgroundTransparency = 0, TextTransparency = 0})
                        local fadeInModeButton = TweenService:Create(ModeButton, TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {BackgroundTransparency = 0, TextTransparency = 0})

                        fadeInSettingsFrame:Play()
                        fadeInSettingsStroke:Play()
                        fadeInSettingsTitle:Play()
                        fadeInSettingsClose:Play()
                        fadeInColorButton:Play()
                        fadeInModeButton:Play()

                        -- Перемещение меню настроек
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
            else
                local RejoinButton = Instance.new("TextButton")
                RejoinButton.Size = UDim2.new(0, 30, 0, 30)
                RejoinButton.Position = UDim2.new(1, -40, 0, 5)
                RejoinButton.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
                RejoinButton.Text = "▼"
                RejoinButton.TextColor3 = Color3.fromRGB(255, 255, 255)
                RejoinButton.TextSize = 14
                RejoinButton.BackgroundTransparency = 1
                RejoinButton.TextTransparency = 1
                RejoinButton.Parent = FuncFrame

                local RejoinCorner = Instance.new("UICorner")
                RejoinCorner.CornerRadius = UDim.new(0, 8)
                RejoinCorner.Parent = RejoinButton

                local RejoinStroke = Instance.new("UIStroke")
                RejoinStroke.Color = Color3.fromRGB(147, 112, 219)
                RejoinStroke.Thickness = 1
                RejoinStroke.Transparency = 1
                RejoinStroke.Parent = RejoinButton

                local fadeInRejoin = TweenService:Create(RejoinButton, TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {BackgroundTransparency = 0, TextTransparency = 0})
                local fadeInRejoinStroke = TweenService:Create(RejoinStroke, TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Transparency = 0})
                fadeInRejoin:Play()
                fadeInRejoinStroke:Play()

                RejoinButton.MouseButton1Click:Connect(func.Action)
            end
        end

        UpdateCanvasSize(FunctionsFrame, FunctionsListLayout)
    end)

    UpdateCanvasSize(CategoriesFrame, CategoriesListLayout)
end

-- Сохранение позиции прокрутки
CategoriesFrame:GetPropertyChangedSignal("CanvasPosition"):Connect(function()
    SavedState.ScrollPositions.Categories = CategoriesFrame.CanvasPosition.Y
end)

FunctionsFrame:GetPropertyChangedSignal("CanvasPosition"):Connect(function()
    SavedState.ScrollPositions.Functions = FunctionsFrame.CanvasPosition.Y
end)

-- Восстановление позиции прокрутки
local function RestoreScrollPositions()
    CategoriesFrame.CanvasPosition = Vector2.new(0, SavedState.ScrollPositions.Categories)
    FunctionsFrame.CanvasPosition = Vector2.new(0, SavedState.ScrollPositions.Functions)
end

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

-- Ключ-система
local KeySystemGUI = Instance.new("ScreenGui")
KeySystemGUI.Name = "XKeySystem"
KeySystemGUI.Parent = CoreGui
KeySystemGUI.IgnoreGuiInset = true
KeySystemGUI.DisplayOrder = 9999
KeySystemGUI.Enabled = true

local KeySystemFrame = Instance.new("Frame")
KeySystemFrame.Size = UDim2.new(1, 0, 1, 0)
KeySystemFrame.BackgroundColor3 = Color3.fromRGB(31, 31, 31)
KeySystemFrame.BackgroundTransparency = 1
KeySystemFrame.Active = true
KeySystemFrame.Parent = KeySystemGUI

local fadeInFrame = TweenService:Create(KeySystemFrame, TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {BackgroundTransparency = 0})
fadeInFrame:Play()

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

local fadeInTitle = TweenService:Create(KeySystemTitle, TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {TextTransparency = 0})
fadeInTitle:Play()

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

local fadeInInputFrame = TweenService:Create(KeyInputFrame, TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {BackgroundTransparency = 0})
local fadeInInputStroke = TweenService:Create(KeyInputStroke, TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Transparency = 0})
local fadeInInput = TweenService:Create(KeyInput, TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {TextTransparency = 0})
fadeInInputFrame:Play()
fadeInInputStroke:Play()
fadeInInput:Play()

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

local fadeInActivate = TweenService:Create(ActivateButton, TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {BackgroundTransparency = 0, TextTransparency = 0})
local fadeInActivateStroke = TweenService:Create(ActivateStroke, TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Transparency = 0})
fadeInActivate:Play()
fadeInActivateStroke:Play()

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

local fadeInGetKey = TweenService:Create(GetKeyButton, TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {BackgroundTransparency = 0, TextTransparency = 0})
local fadeInGetKeyStroke = TweenService:Create(GetKeyStroke, TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Transparency = 0})
fadeInGetKey:Play()
fadeInGetKeyStroke:Play()

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

GetKeyButton.MouseButton1Click:Connect(function()
    pcall(function()
        setclipboard("Ваш ключ: X")
        ShowFeedback("Текст скопирован в ваш буфер обмена!", Color3.fromRGB(147, 112, 219))
    end)
end)

ActivateButton.MouseButton1Click:Connect(function()
    local inputKey = KeyInput.Text
    if inputKey == "" then
        ShowFeedback("Введите ключ!", Color3.fromRGB(255, 0, 0))
    elseif inputKey == CorrectKey then
        ShowFeedback("Ключ активирован!", Color3.fromRGB(147, 112, 219))
        wait(1)
        local fadeOutFrame = TweenService:Create(KeySystemFrame, TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {BackgroundTransparency = 1})
        local fadeOutTitle = TweenService:Create(KeySystemTitle, TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {TextTransparency = 1})
        local fadeOutInputFrame = TweenService:Create(KeyInputFrame, TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {BackgroundTransparency = 1})
        local fadeOutInputStroke = TweenService:Create(KeyInputStroke, TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {Transparency = 1})
        local fadeOutInput = TweenService:Create(KeyInput, TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {TextTransparency = 1})
        local fadeOutActivate = TweenService:Create(ActivateButton, TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {BackgroundTransparency = 1, TextTransparency = 1})
        local fadeOutActivateStroke = TweenService:Create(ActivateStroke, TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {Transparency = 1})
        local fadeOutGetKey = TweenService:Create(GetKeyButton, TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {BackgroundTransparency = 1, TextTransparency = 1})
        local fadeOutGetKeyStroke = TweenService:Create(GetKeyStroke, TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {Transparency = 1})

        fadeOutFrame:Play()
        fadeOutTitle:Play()
        fadeOutInputFrame:Play()
        fadeOutInputStroke:Play()
        fadeOutInput:Play()
        fadeOutActivate:Play()
        fadeOutActivateStroke:Play()
        fadeOutGetKey:Play()
        fadeOutGetKeyStroke:Play()

        fadeOutFrame.Completed:Connect(function()
            KeySystemGUI:Destroy()
            ShowMiniButton()
            if SavedState.MainMenuOpen then
                ToggleMainMenu()
                RestoreScrollPositions()
            end
        end)
    else
        ShowFeedback("Неверный ключ, пожалуйста, получите его.", Color3.fromRGB(255, 0, 0))
    end
end)
