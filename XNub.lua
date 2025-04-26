-- Импорт сервисов
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local HttpService = game:GetService("HttpService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local CoreGui = game:GetService("CoreGui")

-- Глобальные настройки
local Settings = {
    SpeedBoost = {Enabled = false, Value = 50, Min = 0, Max = 1000000},
    JumpBoost = {Enabled = false, Value = 50, Min = 0, Max = 1000000},
    FOVBoost = {Enabled = false, Value = 90, Min = 30, Max = 120},
    Noclip = {Enabled = false},
    ESP = {Enabled = false, FillTransparency = 0.5, OutlineTransparency = 0, FillColor = Color3.fromRGB(255, 255, 255), OutlineColor = Color3.fromRGB(255, 255, 255), Mode = "AlwaysOnTop"},
    InfiniteJump = {Enabled = false}
}

-- Основной GUI
local XHubGUI = Instance.new("ScreenGui")
XHubGUI.Name = "XHub"
XHubGUI.Parent = CoreGui
XHubGUI.IgnoreGuiInset = true
XHubGUI.DisplayOrder = 1000
XHubGUI.Enabled = false -- Изначально скрыт до активации ключа

-- Главный фрейм
local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 250, 0, 50)
MainFrame.Position = UDim2.new(0.5, -125, 0.5, -150)
MainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
MainFrame.BackgroundTransparency = 0.1
MainFrame.BorderSizePixel = 0
MainFrame.Active = true
MainFrame.Parent = XHubGUI

local UICorner = Instance.new("UICorner")
UICorner.CornerRadius = UDim.new(0, 8)
UICorner.Parent = MainFrame

local UIStroke = Instance.new("UIStroke")
UIStroke.Color = Color3.fromRGB(200, 200, 200)
UIStroke.Thickness = 1
UIStroke.Parent = MainFrame

-- Заголовок
local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(0.7, 0, 0, 50)
Title.Position = UDim2.new(0, 10, 0, 0)
Title.Text = "X Hub v3.0"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.TextSize = 20
Title.Font = Enum.Font.GothamBold
Title.BackgroundTransparency = 1
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.Parent = MainFrame

-- Кнопка сворачивания
local ToggleButton = Instance.new("TextButton")
ToggleButton.Size = UDim2.new(0, 40, 0, 40)
ToggleButton.Position = UDim2.new(1, -45, 0, 5)
ToggleButton.Text = "▼"
ToggleButton.TextColor3 = Color3.fromRGB(255, 255, 255)
ToggleButton.TextSize = 18
ToggleButton.BackgroundTransparency = 1
ToggleButton.Parent = MainFrame

-- Контейнер для категорий
local CategoryContainer = Instance.new("ScrollingFrame")
CategoryContainer.Size = UDim2.new(1, 0, 1, -50)
CategoryContainer.Position = UDim2.new(0, 0, 0, 50)
CategoryContainer.BackgroundTransparency = 1
CategoryContainer.ScrollBarThickness = 4
CategoryContainer.ScrollBarImageColor3 = Color3.fromRGB(200, 200, 200)
CategoryContainer.CanvasSize = UDim2.new(0, 0, 0, 0)
CategoryContainer.ScrollingDirection = Enum.ScrollingDirection.Y
CategoryContainer.Visible = false
CategoryContainer.Parent = MainFrame

local CategoryListLayout = Instance.new("UIListLayout")
CategoryListLayout.SortOrder = Enum.SortOrder.LayoutOrder
CategoryListLayout.Padding = UDim.new(0, 8)
CategoryListLayout.Parent = CategoryContainer

-- Уведомления
local NotificationGUI = Instance.new("ScreenGui")
NotificationGUI.Name = "XHubNotifications"
NotificationGUI.Parent = CoreGui
NotificationGUI.IgnoreGuiInset = true

local NotificationContainer = Instance.new("Frame")
NotificationContainer.Size = UDim2.new(0, 300, 0, 400)
NotificationContainer.Position = UDim2.new(1, -310, 1, -410)
NotificationContainer.BackgroundTransparency = 1
NotificationContainer.Parent = NotificationGUI

local NotificationListLayout = Instance.new("UIListLayout")
NotificationListLayout.SortOrder = Enum.SortOrder.LayoutOrder
NotificationListLayout.Padding = UDim.new(0, 8)
NotificationListLayout.VerticalAlignment = Enum.VerticalAlignment.Bottom
NotificationListLayout.Parent = NotificationContainer

-- Функция создания уведомлений
local function CreateNotification(message, isError)
    local NotificationFrame = Instance.new("Frame")
    NotificationFrame.Size = UDim2.new(1, 0, 0, 60)
    NotificationFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
    NotificationFrame.BackgroundTransparency = 1
    NotificationFrame.Parent = NotificationContainer

    local NotifCorner = Instance.new("UICorner")
    NotifCorner.CornerRadius = UDim.new(0, 8)
    NotifCorner.Parent = NotificationFrame

    local NotifStroke = Instance.new("UIStroke")
    NotifStroke.Color = Color3.fromRGB(200, 200, 200)
    NotifStroke.Thickness = 1
    NotifStroke.Transparency = 1
    NotifStroke.Parent = NotificationFrame

    local NotifText = Instance.new("TextLabel")
    NotifText.Size = UDim2.new(1, -20, 1, -10)
    NotifText.Position = UDim2.new(0, 10, 0, 5)
    NotifText.Text = message
    NotifText.TextColor3 = isError and Color3.fromRGB(255, 100, 100) or Color3.fromRGB(255, 255, 255)
    NotifText.TextSize = 14
    NotifText.Font = Enum.Font.Gotham
    NotifText.BackgroundTransparency = 1
    NotifText.TextXAlignment = Enum.TextXAlignment.Left
    NotifText.TextWrapped = true
    NotifText.TextTransparency = 1
    NotifText.Parent = NotificationFrame

    local fadeIn = TweenService:Create(NotificationFrame, TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {BackgroundTransparency = 0})
    local fadeInStroke = TweenService:Create(NotifStroke, TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Transparency = 0})
    local fadeInText = TweenService:Create(NotifText, TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {TextTransparency = 0})
    fadeIn:Play()
    fadeInStroke:Play()
    fadeInText:Play()

    spawn(function()
        wait(3)
        local fadeOut = TweenService:Create(NotificationFrame, TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {BackgroundTransparency = 1})
        local fadeOutStroke = TweenService:Create(NotifStroke, TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {Transparency = 1})
        local fadeOutText = TweenService:Create(NotifText, TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {TextTransparency = 1})
        fadeOut:Play()
        fadeOutStroke:Play()
        fadeOutText:Play()
        fadeOut.Completed:Connect(function()
            NotificationFrame:Destroy()
        end)
    end)
end

-- Категории и функции
local Categories = {
    {
        Name = "Движение",
        Functions = {
            {Name = "Скорость", Setting = Settings.SpeedBoost, HasInput = true, Action = function() UpdateSpeedBoost() end},
            {Name = "Прыжок", Setting = Settings.JumpBoost, HasInput = true, Action = function() UpdateJumpBoost() end},
            {Name = "Бесконечный Прыжок", Setting = Settings.InfiniteJump, Action = function() UpdateInfiniteJump() end}
        }
    },
    {
        Name = "Визуал",
        Functions = {
            {Name = "ESP", Setting = Settings.ESP, HasSettings = true, Action = function() UpdateESP() end},
            {Name = "FOV", Setting = Settings.FOVBoost, HasInput = true, Action = function() UpdateFOVBoost() end}
        }
    },
    {
        Name = "Другое",
        Functions = {
            {Name = "Noclip", Setting = Settings.Noclip, Action = function() UpdateNoclip() end},
            {Name = "Перезайти", Action = function()
                local servers = HttpService:JSONDecode(game:HttpGet("https://games.roblox.com/v1/games/" .. game.PlaceId .. "/servers/Public?sortOrder=Asc&limit=100"))
                for _, server in pairs(servers.data) do
                    if server.playing < server.maxPlayers and server.playing > 0 then
                        game:GetService("TeleportService"):TeleportToPlaceInstance(game.PlaceId, server.id)
                        break
                    end
                end
            end}
        }
    }
}

-- Создание категорий и функций
local function CreateCategoryUI(category, index)
    local CategoryFrame = Instance.new("Frame")
    CategoryFrame.Size = UDim2.new(1, 0, 0, 40)
    CategoryFrame.BackgroundTransparency = 1
    CategoryFrame.LayoutOrder = index
    CategoryFrame.Parent = CategoryContainer

    local CategoryLabel = Instance.new("TextLabel")
    CategoryLabel.Size = UDim2.new(0.7, 0, 1, 0)
    CategoryLabel.Position = UDim2.new(0, 10, 0, 0)
    CategoryLabel.Text = category.Name
    CategoryLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    CategoryLabel.TextSize = 16
    CategoryLabel.Font = Enum.Font.GothamBold
    CategoryLabel.BackgroundTransparency = 1
    CategoryLabel.TextXAlignment = Enum.TextXAlignment.Left
    CategoryLabel.Parent = CategoryFrame

    local CategoryToggleButton = Instance.new("TextButton")
    CategoryToggleButton.Size = UDim2.new(0, 30, 0, 30)
    CategoryToggleButton.Position = UDim2.new(1, -40, 0, 5)
    CategoryToggleButton.Text = "▼"
    CategoryToggleButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    CategoryToggleButton.TextSize = 14
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

    local function UpdateCanvasSize()
        local totalHeight = 0
        for _, child in pairs(CategoryContainer:GetChildren()) do
            if child:IsA("Frame") then
                totalHeight = totalHeight + child.Size.Y.Offset + CategoryListLayout.Padding.Offset
            end
        end
        CategoryContainer.CanvasSize = UDim2.new(0, 0, 0, totalHeight)
    end

    for j, func in pairs(category.Functions) do
        local FuncFrame = Instance.new("Frame")
        local height = func.HasInput and 80 or 40
        FuncFrame.Size = UDim2.new(1, 0, 0, height)
        FuncFrame.BackgroundTransparency = 1
        FuncFrame.LayoutOrder = j
        FuncFrame.Parent = FunctionsFrame

        local FuncLabel = Instance.new("TextLabel")
        FuncLabel.Size = UDim2.new(0.7, 0, 0, 40)
        FuncLabel.Position = UDim2.new(0, 10, 0, 0)
        FuncLabel.Text = func.Name
        FuncLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
        FuncLabel.TextSize = 14
        FuncLabel.Font = Enum.Font.Gotham
        FuncLabel.BackgroundTransparency = 1
        FuncLabel.TextXAlignment = Enum.TextXAlignment.Left
        FuncLabel.Parent = FuncFrame

        if func.Name ~= "Перезайти" then
            local ToggleButton = Instance.new("TextButton")
            ToggleButton.Size = UDim2.new(0, 24, 0, 24)
            ToggleButton.Position = UDim2.new(1, -34, 0, 8)
            ToggleButton.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
            ToggleButton.Text = ""
            ToggleButton.Parent = FuncFrame

            local ToggleCorner = Instance.new("UICorner")
            ToggleCorner.CornerRadius = UDim.new(0, 6)
            ToggleCorner.Parent = ToggleButton

            local ToggleStroke = Instance.new("UIStroke")
            ToggleStroke.Color = Color3.fromRGB(200, 200, 200)
            ToggleStroke.Thickness = 1
            ToggleStroke.Parent = ToggleButton

            local function UpdateToggleVisual()
                local tween = TweenService:Create(ToggleButton, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
                    BackgroundColor3 = func.Setting.Enabled and Color3.fromRGB(200, 200, 200) or Color3.fromRGB(50, 50, 50)
                })
                tween:Play()
            end

            ToggleButton.MouseButton1Click:Connect(function()
                func.Setting.Enabled = not func.Setting.Enabled
                UpdateToggleVisual()
                CreateNotification((func.Setting.Enabled and "Включено: " or "Выключено: ") .. func.Name, false)
                if func.Action then
                    func.Action()
                end
            end)

            UpdateToggleVisual()

            if func.HasInput then
                local InputFrame = Instance.new("Frame")
                InputFrame.Size = UDim2.new(0.8, 0, 0, 30)
                InputFrame.Position = UDim2.new(0, 10, 0, 45)
                InputFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
                InputFrame.Parent = FuncFrame

                local InputCorner = Instance.new("UICorner")
                InputCorner.CornerRadius = UDim.new(0, 6)
                InputCorner.Parent = InputFrame

                local InputStroke = Instance.new("UIStroke")
                InputStroke.Color = Color3.fromRGB(200, 200, 200)
                InputStroke.Thickness = 1
                InputStroke.Parent = InputFrame

                local InputField = Instance.new("TextBox")
                InputField.Size = UDim2.new(1, -10, 1, -10)
                InputField.Position = UDim2.new(0, 5, 0, 5)
                InputField.BackgroundTransparency = 1
                InputField.Text = tostring(func.Setting.Value)
                InputField.TextColor3 = Color3.fromRGB(255, 255, 255)
                InputField.TextSize = 14
                InputField.Font = Enum.Font.Gotham
                InputField.Parent = InputFrame

                InputField.FocusLost:Connect(function(enterPressed)
                    if enterPressed then
                        local value = tonumber(InputField.Text)
                        if value then
                            func.Setting.Value = math.clamp(value, func.Setting.Min, func.Setting.Max)
                            InputField.Text = tostring(func.Setting.Value)
                            if func.Action then
                                func.Action()
                            end
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
                SettingsButton.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
                SettingsButton.Text = "⚙"
                SettingsButton.TextColor3 = Color3.fromRGB(255, 255, 255)
                SettingsButton.TextSize = 14
                SettingsButton.Parent = FuncFrame

                local SettingsCorner = Instance.new("UICorner")
                SettingsCorner.CornerRadius = UDim.new(0, 6)
                SettingsCorner.Parent = SettingsButton

                local SettingsFrame = nil

                SettingsButton.MouseButton1Click:Connect(function()
                    if SettingsFrame then
                        local fadeOut = TweenService:Create(SettingsFrame, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {BackgroundTransparency = 1})
                        for _, child in pairs(SettingsFrame:GetDescendants()) do
                            if child:IsA("TextLabel") or child:IsA("TextButton") then
                                TweenService:Create(child, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {TextTransparency = 1, BackgroundTransparency = 1}):Play()
                            elseif child:IsA("UIStroke") then
                                TweenService:Create(child, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {Transparency = 1}):Play()
                            end
                        end
                        fadeOut:Play()
                        fadeOut.Completed:Connect(function()
                            SettingsFrame:Destroy()
                            SettingsFrame = nil
                        end)
                        return
                    end

                    SettingsFrame = Instance.new("Frame")
                    SettingsFrame.Size = UDim2.new(0, 200, 0, 180)
                    SettingsFrame.Position = UDim2.new(0.5, -100, 0.5, -90)
                    SettingsFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
                    SettingsFrame.BackgroundTransparency = 1
                    SettingsFrame.Parent = XHubGUI

                    local SettingsCorner = Instance.new("UICorner")
                    SettingsCorner.CornerRadius = UDim.new(0, 8)
                    SettingsCorner.Parent = SettingsFrame

                    local SettingsStroke = Instance.new("UIStroke")
                    SettingsStroke.Color = Color3.fromRGB(200, 200, 200)
                    SettingsStroke.Thickness = 1
                    SettingsStroke.Transparency = 1
                    SettingsStroke.Parent = SettingsFrame

                    local SettingsTitle = Instance.new("TextLabel")
                    SettingsTitle.Size = UDim2.new(1, 0, 0, 40)
                    SettingsTitle.Text = "Настройки ESP"
                    SettingsTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
                    SettingsTitle.TextSize = 16
                    SettingsTitle.Font = Enum.Font.GothamBold
                    SettingsTitle.BackgroundTransparency = 1
                    SettingsTitle.TextTransparency = 1
                    SettingsTitle.Parent = SettingsFrame

                    local CloseButton = Instance.new("TextButton")
                    CloseButton.Size = UDim2.new(0, 30, 0, 30)
                    CloseButton.Position = UDim2.new(1, -35, 0, 5)
                    CloseButton.Text = "X"
                    CloseButton.TextColor3 = Color3.fromRGB(255, 255, 255)
                    CloseButton.TextSize = 18
                    CloseButton.BackgroundTransparency = 1
                    CloseButton.TextTransparency = 1
                    CloseButton.Parent = SettingsFrame

                    CloseButton.MouseButton1Click:Connect(function()
                        local fadeOut = TweenService:Create(SettingsFrame, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {BackgroundTransparency = 1})
                        for _, child in pairs(SettingsFrame:GetDescendants()) do
                            if child:IsA("TextLabel") or child:IsA("TextButton") then
                                TweenService:Create(child, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {TextTransparency = 1, BackgroundTransparency = 1}):Play()
                            elseif child:IsA("UIStroke") then
                                TweenService:Create(child, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {Transparency = 1}):Play()
                            end
                        end
                        fadeOut:Play()
                        fadeOut.Completed:Connect(function()
                            SettingsFrame:Destroy()
                            SettingsFrame = nil
                        end)
                    end)

                    local FillColorButton = Instance.new("TextButton")
                    FillColorButton.Size = UDim2.new(0, 160, 0, 30)
                    FillColorButton.Position = UDim2.new(0, 20, 0, 50)
                    FillColorButton.BackgroundColor3 = func.Setting.FillColor
                    FillColorButton.Text = "Цвет заливки"
                    FillColorButton.TextColor3 = Color3.fromRGB(255, 255, 255)
                    FillColorButton.TextSize = 14
                    FillColorButton.BackgroundTransparency = 1
                    FillColorButton.TextTransparency = 1
                    FillColorButton.Parent = SettingsFrame

                    local FillColorCorner = Instance.new("UICorner")
                    FillColorCorner.CornerRadius = UDim.new(0, 6)
                    FillColorCorner.Parent = FillColorButton

                    FillColorButton.MouseButton1Click:Connect(function()
                        local r = math.random(0, 255)
                        local g = math.random(0, 255)
                        local b = math.random(0, 255)
                        func.Setting.FillColor = Color3.fromRGB(r, g, b)
                        FillColorButton.BackgroundColor3 = func.Setting.FillColor
                        UpdateESP()
                    end)

                    local OutlineColorButton = Instance.new("TextButton")
                    OutlineColorButton.Size = UDim2.new(0, 160, 0, 30)
                    OutlineColorButton.Position = UDim2.new(0, 20, 0, 90)
                    OutlineColorButton.BackgroundColor3 = func.Setting.OutlineColor
                    OutlineColorButton.Text = "Цвет обводки"
                    OutlineColorButton.TextColor3 = Color3.fromRGB(255, 255, 255)
                    OutlineColorButton.TextSize = 14
                    OutlineColorButton.BackgroundTransparency = 1
                    OutlineColorButton.TextTransparency = 1
                    OutlineColorButton.Parent = SettingsFrame

                    local OutlineColorCorner = Instance.new("UICorner")
                    OutlineColorCorner.CornerRadius = UDim.new(0, 6)
                    OutlineColorCorner.Parent = OutlineColorButton

                    OutlineColorButton.MouseButton1Click:Connect(function()
                        local r = math.random(0, 255)
                        local g = math.random(0, 255)
                        local b = math.random(0, 255)
                        func.Setting.OutlineColor = Color3.fromRGB(r, g, b)
                        OutlineColorButton.BackgroundColor3 = func.Setting.OutlineColor
                        UpdateESP()
                    end)

                    local ModeButton = Instance.new("TextButton")
                    ModeButton.Size = UDim2.new(0, 160, 0, 30)
                    ModeButton.Position = UDim2.new(0, 20, 0, 130)
                    ModeButton.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
                    ModeButton.Text = "Режим: " .. (func.Setting.Mode == "AlwaysOnTop" and "AOT" or "TW")
                    ModeButton.TextColor3 = Color3.fromRGB(255, 255, 255)
                    ModeButton.TextSize = 14
                    ModeButton.BackgroundTransparency = 1
                    ModeButton.TextTransparency = 1
                    ModeButton.Parent = SettingsFrame

                    local ModeCorner = Instance.new("UICorner")
                    ModeCorner.CornerRadius = UDim.new(0, 6)
                    ModeCorner.Parent = ModeButton

                    ModeButton.MouseButton1Click:Connect(function()
                        func.Setting.Mode = func.Setting.Mode == "AlwaysOnTop" and "ThroughWalls" or "AlwaysOnTop"
                        ModeButton.Text = "Режим: " .. (func.Setting.Mode == "AlwaysOnTop" and "AOT" or "TW")
                        UpdateESP()
                    end)

                    local fadeIn = TweenService:Create(SettingsFrame, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {BackgroundTransparency = 0})
                    for _, child in pairs(SettingsFrame:GetDescendants()) do
                        if child:IsA("TextLabel") or child:IsA("TextButton") then
                            TweenService:Create(child, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {TextTransparency = 0, BackgroundTransparency = 0}):Play()
                        elseif child:IsA("UIStroke") then
                            TweenService:Create(child, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Transparency = 0}):Play()
                        end
                    end
                    fadeIn:Play()
                end)
            end
        else
            local ActionButton = Instance.new("TextButton")
            ActionButton.Size = UDim2.new(0, 24, 0, 24)
            ActionButton.Position = UDim2.new(1, -34, 0, 8)
            ActionButton.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
            ActionButton.Text = "▶"
            ActionButton.TextColor3 = Color3.fromRGB(255, 255, 255)
            ActionButton.TextSize = 14
            ActionButton.Parent = FuncFrame

            local ActionCorner = Instance.new("UICorner")
            ActionCorner.CornerRadius = UDim.new(0, 6)
            ActionCorner.Parent = ActionButton

            ActionButton.MouseButton1Click:Connect(function()
                func.Action()
                CreateNotification("Выполнено: " .. func.Name, false)
            end)
        end
    end

    local IsExpanded = false
    CategoryToggleButton.MouseButton1Click:Connect(function()
        IsExpanded = not IsExpanded
        local funcHeight = 0
        for _, func in pairs(category.Functions) do
            local height = func.HasInput and 80 or 40
            funcHeight = funcHeight + height + FunctionsListLayout.Padding.Offset
        end
        local newHeight = IsExpanded and UDim2.new(1, 0, 0, funcHeight) or UDim2.new(1, 0, 0, 0)
        local tween = TweenService:Create(FunctionsFrame, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Size = newHeight})
        tween:Play()
        CategoryToggleButton.Text = IsExpanded and "▲" or "▼"
        CategoryFrame.Size = IsExpanded and UDim2.new(1, 0, 0, 40 + funcHeight) or UDim2.new(1, 0, 0, 40)
        UpdateCanvasSize()
    end)
    UpdateCanvasSize()
end

for i, category in pairs(Categories) do
    CreateCategoryUI(category, i)
end

-- Перемещение GUI
local Dragging, DragStart, StartPos
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

-- Анимация сворачивания/разворачивания
local IsMainExpanded = false
ToggleButton.MouseButton1Click:Connect(function()
    IsMainExpanded = not IsMainExpanded
    local newSize = IsMainExpanded and UDim2.new(0, 250, 0, 300) or UDim2.new(0, 250, 0, 50)
    local tween = TweenService:Create(MainFrame, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Size = newSize})
    tween:Play()
    ToggleButton.Text = IsMainExpanded and "▲" or "▼"
    CategoryContainer.Visible = IsMainExpanded
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
local NoclipConnection
local function UpdateNoclip()
    if NoclipConnection then
        NoclipConnection:Disconnect()
        NoclipConnection = nil
    end
    if Settings.Noclip.Enabled then
        NoclipConnection = RunService.Stepped:Connect(function()
            local character = Players.LocalPlayer.Character
            if not character then return end
            for _, part in pairs(character:GetDescendants()) do
                if part:IsA("BasePart") then
                    part.CanCollide = false
                end
            end
        end)
    else
        local character = Players.LocalPlayer.Character
        if not character then return end
        for _, part in pairs(character:GetDescendants()) do
            if part:IsA("BasePart") then
                part.CanCollide = true
            end
        end
    end
end

-- Функционал ESP
local ESPObjects = {}
local function CreateESP(player)
    if player == Players.LocalPlayer or ESPObjects[player] then return end
    local character = player.Character
    if not character then return end
    local highlight = Instance.new("Highlight")
    highlight.FillTransparency = Settings.ESP.FillTransparency
    highlight.FillColor = Settings.ESP.FillColor
    highlight.OutlineTransparency = Settings.ESP.OutlineTransparency
    highlight.OutlineColor = Settings.ESP.OutlineColor
    highlight.Adornee = character
    highlight.DepthMode = Settings.ESP.Mode == "AlwaysOnTop" and Enum.HighlightDepthMode.AlwaysOnTop or Enum.HighlightDepthMode.Occluded
    highlight.Parent = character
    ESPObjects[player] = highlight
end

local function UpdateESP()
    for player, highlight in pairs(ESPObjects) do
        if player.Character and highlight.Adornee then
            highlight.Enabled = Settings.ESP.Enabled
            highlight.FillColor = Settings.ESP.FillColor
            highlight.OutlineColor = Settings.ESP.OutlineColor
            highlight.FillTransparency = Settings.ESP.FillTransparency
            highlight.OutlineTransparency = Settings.ESP.OutlineTransparency
            highlight.DepthMode = Settings.ESP.Mode == "AlwaysOnTop" and Enum.HighlightDepthMode.AlwaysOnTop or Enum.HighlightDepthMode.Occluded
        else
            highlight:Destroy()
            ESPObjects[player] = nil
        end
    end
    if Settings.ESP.Enabled then
        for _, player in pairs(Players:GetPlayers()) do
            if player ~= Players.LocalPlayer and player.Character and not ESPObjects[player] then
                CreateESP(player)
            end
        end
    end
end

-- Функционал Infinite Jump
local InfiniteJumpConnection
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
    if Settings.ESP.Enabled then
        for _, player in pairs(Players:GetPlayers()) do
            if player ~= Players.LocalPlayer then
                CreateESP(player)
            end
        end
    end
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

local KeySystemFrame = Instance.new("Frame")
KeySystemFrame.Size = UDim2.new(0, 400, 0, 300)
KeySystemFrame.Position = UDim2.new(0.5, -200, 0.5, -150)
KeySystemFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
KeySystemFrame.BackgroundTransparency = 1
KeySystemFrame.Parent = KeySystemGUI

local KeySystemCorner = Instance.new("UICorner")
KeySystemCorner.CornerRadius = UDim.new(0, 8)
KeySystemCorner.Parent = KeySystemFrame

local KeySystemStroke = Instance.new("UIStroke")
KeySystemStroke.Color = Color3.fromRGB(200, 200, 200)
KeySystemStroke.Thickness = 1
KeySystemStroke.Transparency = 1
KeySystemStroke.Parent = KeySystemFrame

local KeySystemTitle = Instance.new("TextLabel")
KeySystemTitle.Size = UDim2.new(1, 0, 0, 50)
KeySystemTitle.Text = "X Hub • Ключ-система"
KeySystemTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
KeySystemTitle.TextSize = 20
KeySystemTitle.Font = Enum.Font.GothamBold
KeySystemTitle.BackgroundTransparency = 1
KeySystemTitle.TextTransparency = 1
KeySystemTitle.Parent = KeySystemFrame

local KeyInputFrame = Instance.new("Frame")
KeyInputFrame.Size = UDim2.new(0, 300, 0, 40)
KeyInputFrame.Position = UDim2.new(0.5, -150, 0.4, 0)
KeyInputFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
KeyInputFrame.BackgroundTransparency = 1
KeyInputFrame.Parent = KeySystemFrame

local KeyInputCorner = Instance.new("UICorner")
KeyInputCorner.CornerRadius = UDim.new(0, 6)
KeyInputCorner.Parent = KeyInputFrame

local KeyInputStroke = Instance.new("UIStroke")
KeyInputStroke.Color = Color3.fromRGB(200, 200, 200)
KeyInputStroke.Thickness = 1
KeyInputStroke.Transparency = 1
KeyInputStroke.Parent = KeyInputFrame

local KeyInput = Instance.new("TextBox")
KeyInput.Size = UDim2.new(1, -10, 1, -10)
KeyInput.Position = UDim2.new(0, 5, 0, 5)
KeyInput.BackgroundTransparency = 1
KeyInput.Text = ""
KeyInput.PlaceholderText = "Введите ключ"
KeyInput.PlaceholderColor3 = Color3.fromRGB(150, 150, 150)
KeyInput.TextColor3 = Color3.fromRGB(255, 255, 255)
KeyInput.TextSize = 16
KeyInput.Font = Enum.Font.Gotham
KeyInput.TextTransparency = 1
KeyInput.Parent = KeyInputFrame

local ActivateButton = Instance.new("TextButton")
ActivateButton.Size = UDim2.new(0, 140, 0, 40)
ActivateButton.Position = UDim2.new(0.5, -150, 0.6, 0)
ActivateButton.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
ActivateButton.Text = "Активировать"
ActivateButton.TextColor3 = Color3.fromRGB(255, 255, 255)
ActivateButton.TextSize = 16
ActivateButton.Font = Enum.Font.GothamSemibold
ActivateButton.BackgroundTransparency = 1
ActivateButton.TextTransparency = 1
ActivateButton.Parent = KeySystemFrame

local ActivateCorner = Instance.new("UICorner")
ActivateCorner.CornerRadius = UDim.new(0, 6)
ActivateCorner.Parent = ActivateButton

local ActivateStroke = Instance.new("UIStroke")
ActivateStroke.Color = Color3.fromRGB(200, 200, 200)
ActivateStroke.Thickness = 1
ActivateStroke.Transparency = 1
ActivateStroke.Parent = ActivateButton

local GetKeyButton = Instance.new("TextButton")
GetKeyButton.Size = UDim2.new(0, 140, 0, 40)
GetKeyButton.Position = UDim2.new(0.5, 10, 0.6, 0)
GetKeyButton.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
GetKeyButton.Text = "Получить ключ"
GetKeyButton.TextColor3 = Color3.fromRGB(255, 255, 255)
GetKeyButton.TextSize = 16
GetKeyButton.Font = Enum.Font.GothamSemibold
GetKeyButton.BackgroundTransparency = 1
GetKeyButton.TextTransparency = 1
GetKeyButton.Parent = KeySystemFrame

local GetKeyCorner = Instance.new("UICorner")
GetKeyCorner.CornerRadius = UDim.new(0, 6)
GetKeyCorner.Parent = GetKeyButton

local GetKeyStroke = Instance.new("UIStroke")
GetKeyStroke.Color = Color3.fromRGB(200, 200, 200)
GetKeyStroke.Thickness = 1
GetKeyStroke.Transparency = 1
GetKeyStroke.Parent = GetKeyButton

local FeedbackLabel = Instance.new("TextLabel")
FeedbackLabel.Size = UDim2.new(1, 0, 0, 30)
FeedbackLabel.Position = UDim2.new(0, 0, 0.8, 0)
FeedbackLabel.BackgroundTransparency = 1
FeedbackLabel.Text = ""
FeedbackLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
FeedbackLabel.TextSize = 14
FeedbackLabel.Font = Enum.Font.Gotham
FeedbackLabel.TextTransparency = 1
FeedbackLabel.Parent = KeySystemFrame

-- Анимация появления ключ-системы
local function ShowKeySystem()
    local fadeIn = TweenService:Create(KeySystemFrame, TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {BackgroundTransparency = 0})
    for _, child in pairs(KeySystemFrame:GetDescendants()) do
        if child:IsA("TextLabel") or child:IsA("TextButton") then
            TweenService:Create(child, TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {TextTransparency = 0, BackgroundTransparency = 0}):Play()
        elseif child:IsA("UIStroke") then
            TweenService:Create(child, TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Transparency = 0}):Play()
        end
    end
    fadeIn:Play()
end

ShowKeySystem()

local CorrectKey = "X"
GetKeyButton.MouseButton1Click:Connect(function()
    local message = "Свяжитесь с @XHubCreator в Telegram для получения ключа."
    pcall(function()
        setclipboard(message)
        CreateNotification("Ссылка скопирована в буфер обмена!", false)
    end)
end)

ActivateButton.MouseButton1Click:Connect(function()
    if KeyInput.Text == "" then
        CreateNotification("Введите ключ!", true)
    elseif KeyInput.Text == CorrectKey then
        CreateNotification("Ключ активирован!", false)
        local fadeOut = TweenService:Create(KeySystemFrame, TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {BackgroundTransparency = 1})
        for _, child in pairs(KeySystemFrame:GetDescendants()) do
            if child:IsA("TextLabel") or child:IsA("TextButton") then
                TweenService:Create(child, TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {TextTransparency = 1, BackgroundTransparency = 1}):Play()
            elseif child:IsA("UIStroke") then
                TweenService:Create(child, TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {Transparency = 1}):Play()
            end
        end
        fadeOut:Play()
        fadeOut.Completed:Connect(function()
            KeySystemGUI:Destroy()
            XHubGUI.Enabled = true
            local fadeIn = TweenService:Create(MainFrame, TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {BackgroundTransparency = 0})
            for _, child in pairs(MainFrame:GetDescendants()) do
                if child:IsA("TextLabel") or child:IsA("TextButton") then
                    TweenService:Create(child, TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {TextTransparency = 0, BackgroundTransparency = 0}):Play()
                elseif child:IsA("UIStroke") then
                    TweenService:Create(child, TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Transparency = 0}):Play()
                end
            end
            fadeIn:Play()
        end)
    else
        CreateNotification("Неверный ключ!", true)
    end)
end)
