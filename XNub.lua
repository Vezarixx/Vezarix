-- Подключение необходимых сервисов
local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

-- Создаём фиктивный Fusion, если настоящего нет (для простоты)
local Fusion = {
    New = function(className)
        return function(props)
            local instance = Instance.new(className)
            for prop, value in pairs(props) do
                if prop ~= "Parent" then
                    instance[prop] = value
                end
            end
            if props.Parent then
                instance.Parent = props.Parent
            end
            return instance
        end
    end,
    Value = function(initial)
        local value = { _value = initial }
        local connections = {}
        function value:get()
            return value._value
        end
        function value:set(newValue)
            value._value = newValue
            for _, callback in pairs(connections) do
                callback(newValue)
            end
        end
        function value:onChange(callback)
            table.insert(connections, callback)
        end
        return value
    end,
    Tween = function(value, tweenInfo)
        return function()
            local current = value:get()
            if typeof(current) == "UDim2" then
                return current
            end
            return current
        end
    end
}

-- Инициализация GUI
local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

-- Создаём ScreenGui
local screenGui = Fusion.New "ScreenGui" {
    Parent = playerGui,
    ResetOnSpawn = false,
    IgnoreGuiInset = true,
    Name = "CustomGUI"
}

-- Состояния для управления видимостью
local keySystemVisible = Fusion.Value(true)
local smallMenuVisible = Fusion.Value(false)
local mainMenuVisible = Fusion.Value(false)
local espEnabled = Fusion.Value(false)
local noclipEnabled = Fusion.Value(false)

-- Состояние для текста ошибок
local errorText = Fusion.Value("")
local errorVisible = Fusion.Value(false)

-- Состояние для перетаскивания
local mainMenuDragging = Fusion.Value(false)
local smallMenuDragging = Fusion.Value(false)
local dragStart = Fusion.Value(Vector2.new(0, 0))
local mainMenuPosition = Fusion.Value(UDim2.new(0.5, 0, 0.5, 0))
local smallMenuPosition = Fusion.Value(UDim2.new(0.5, 0, 0.5, 0))

-- Настройки анимации
local tweenInfo = TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut)

-- Ключ для проверки
local correctKey = "X"

-- Создание системы ключей
local keySystemFrame = Fusion.New "Frame" {
    Parent = screenGui,
    Position = UDim2.new(0.5, 0, 0.5, 0),
    AnchorPoint = Vector2.new(0.5, 0.5),
    Size = UDim2.new(0, 300, 0, 400),
    BackgroundColor3 = Color3.new(0, 0, 0),
    BorderSizePixel = 0,
    Name = "KeySystemFrame"
}

-- Добавляем закруглённые углы
local keySystemCorner = Fusion.New "UICorner" {
    Parent = keySystemFrame,
    CornerRadius = UDim.new(0, 10)
}

-- Логотип (простой текст "X")
local logoLabel = Fusion.New "TextLabel" {
    Parent = keySystemFrame,
    Position = UDim2.new(0.5, 0, 0.1, 0),
    AnchorPoint = Vector2.new(0.5, 0.5),
    Size = UDim2.new(0, 100, 0, 50),
    BackgroundTransparency = 1,
    Text = "X",
    TextColor3 = Color3.new(1, 1, 1),
    TextScaled = true,
    Font = Enum.Font.SourceSans
}

-- Поле ввода
local keyInput = Fusion.New "TextBox" {
    Parent = keySystemFrame,
    Position = UDim2.new(0.5, 0, 0.3, 0),
    AnchorPoint = Vector2.new(0.5, 0.5),
    Size = UDim2.new(0.8, 0, 0, 40),
    BackgroundColor3 = Color3.new(0.2, 0.2, 0.2),
    Text = "",
    PlaceholderText = "Ввести ключ",
    TextColor3 = Color3.new(1, 1, 1),
    Font = Enum.Font.SourceSans,
    TextSize = 18
}

-- Обводка для поля ввода
local keyInputStroke = Fusion.New "UIStroke" {
    Parent = keyInput,
    Color = Color3.new(1, 1, 1),
    Thickness = 2
}

-- Кнопка "Активировать ключ"
local activateButton = Fusion.New "TextButton" {
    Parent = keySystemFrame,
    Position = UDim2.new(0.5, 0, 0.45, 0),
    AnchorPoint = Vector2.new(0.5, 0.5),
    Size = UDim2.new(0.6, 0, 0, 40),
    BackgroundColor3 = Color3.new(0.3, 0.3, 0.3),
    Text = "Активировать ключ",
    TextColor3 = Color3.new(1, 1, 1),
    Font = Enum.Font.SourceSans,
    TextSize = 18
}

-- Обводка для кнопки
local activateButtonStroke = Fusion.New "UIStroke" {
    Parent = activateButton,
    Color = Color3.new(1, 1, 1),
    Thickness = 2
}

-- Кнопка "Получить ключ"
local getKeyButton = Fusion.New "TextButton" {
    Parent = keySystemFrame,
    Position = UDim2.new(0.5, 0, 0.55, 0),
    AnchorPoint = Vector2.new(0.5, 0.5),
    Size = UDim2.new(0.6, 0, 0, 40),
    BackgroundColor3 = Color3.new(0.3, 0.3, 0.3),
    Text = "Получить ключ",
    TextColor3 = Color3.new(1, 1, 1),
    Font = Enum.Font.SourceSans,
    TextSize = 18
}

-- Обводка для кнопки
local getKeyButtonStroke = Fusion.New "UIStroke" {
    Parent = getKeyButton,
    Color = Color3.new(1, 1, 1),
    Thickness = 2
}

-- Текст ошибки
local errorLabel = Fusion.New "TextLabel" {
    Parent = keySystemFrame,
    Position = UDim2.new(0.5, 0, 0.65, 0),
    AnchorPoint = Vector2.new(0.5, 0.5),
    Size = UDim2.new(0.8, 0, 0, 30),
    BackgroundTransparency = 1,
    Text = "",
    TextColor3 = Color3.new(1, 0, 0),
    TextSize = 16,
    Font = Enum.Font.SourceSans
}

-- Анимация появления системы ключей
local keySystemTweenIn = TweenService:Create(keySystemFrame, tweenInfo, { Position = UDim2.new(0.5, 0, 0.5, 0) })
keySystemFrame.Position = UDim2.new(0.5, 0, -1, 0)
keySystemTweenIn:Play()

-- Обработка кнопки "Получить ключ"
getKeyButton.MouseButton1Click:Connect(function()
    setclipboard("Ваш ключ: X")
    errorText:set("Ключ скопирован в буфер обмена!")
    errorVisible:set(true)
    errorLabel.Text = errorText:get()
    task.delay(2, function()
        errorVisible:set(false)
        errorLabel.Text = ""
    end)
end)

-- Обработка кнопки "Активировать ключ"
activateButton.MouseButton1Click:Connect(function()
    local input = keyInput.Text
    if input == "" then
        errorText:set("Пожалуйста, введите ключ.")
        errorVisible:set(true)
        errorLabel.Text = errorText:get()
        task.delay(2, function()
            errorVisible:set(false)
            errorLabel.Text = ""
        end)
    elseif input ~= correctKey then
        errorText:set("Неверный ключ, пожалуйста, получите его!")
        errorVisible:set(true)
        errorLabel.Text = errorText:get()
        task.delay(2, function()
            errorVisible:set(false)
            errorLabel.Text = ""
        end)
    else
        errorText:set("Ключ успешно активирован!")
        errorVisible:set(true)
        errorLabel.Text = errorText:get()
        task.delay(2, function()
            local keySystemTweenOut = TweenService:Create(keySystemFrame, tweenInfo, { Position = UDim2.new(0.5, 0, -1, 0) })
            keySystemTweenOut:Play()
            keySystemTweenOut.Completed:Connect(function()
                keySystemVisible:set(false)
                smallMenuVisible:set(true)
            end)
        end)
    end)
end)

-- Создание маленького меню
local smallMenuFrame = Fusion.New "Frame" {
    Parent = screenGui,
    Position = smallMenuPosition:get(),
    AnchorPoint = Vector2.new(0.5, 0.5),
    Size = UDim2.new(0, 50, 0, 50),
    BackgroundColor3 = Color3.new(0, 0, 0),
    BorderSizePixel = 0,
    Visible = false,
    Name = "SmallMenuFrame"
}

-- Закруглённые углы
local smallMenuCorner = Fusion.New "UICorner" {
    Parent = smallMenuFrame,
    CornerRadius = UDim.new(0, 10)
}

-- Обводка
local smallMenuStroke = Fusion.New "UIStroke" {
    Parent = smallMenuFrame,
    Color = Color3.new(1, 1, 1),
    Thickness = 2
}

-- Текст "X"
local smallMenuLabel = Fusion.New "TextLabel" {
    Parent = smallMenuFrame,
    Position = UDim2.new(0.5, 0, 0.5, 0),
    AnchorPoint = Vector2.new(0.5, 0.5),
    Size = UDim2.new(0.8, 0, 0.8, 0),
    BackgroundTransparency = 1,
    Text = "X",
    TextColor3 = Color3.new(1, 1, 1),
    TextScaled = true,
    Font = Enum.Font.SourceSans
}

-- Анимация появления маленького меню
smallMenuVisible.onChange(function(visible)
    if visible then
        smallMenuFrame.Visible = true
        local smallMenuTweenIn = TweenService:Create(smallMenuFrame, tweenInfo, { Position = UDim2.new(0.5, 0, 0.5, 0) })
        smallMenuFrame.Position = UDim2.new(0.5, 0, -1, 0)
        smallMenuTweenIn:Play()
    end
end)

-- Обработка клика по маленькому меню
smallMenuFrame.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        local smallMenuTweenOut = TweenService:Create(smallMenuFrame, tweenInfo, { Position = UDim2.new(0.5, 0, -1, 0) })
        smallMenuTweenOut:Play()
        smallMenuTweenOut.Completed:Connect(function()
            smallMenuFrame.Visible = false
            mainMenuVisible:set(true)
        end)
    end
end)

-- Перетаскивание маленького меню
smallMenuFrame.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        smallMenuDragging:set(true)
        dragStart:set(input.Position)
    end
end)

smallMenuFrame.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        smallMenuDragging:set(false)
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if smallMenuDragging:get() and input.UserInputType == Enum.UserInputType.MouseMovement then
        local delta = input.Position - dragStart:get()
        local newPos = smallMenuPosition:get() + UDim2.new(0, delta.X, 0, delta.Y)
        smallMenuPosition:set(newPos)
        smallMenuFrame.Position = newPos
        dragStart:set(input.Position)
    end
end)

-- Создание основного меню
local mainMenuFrame = Fusion.New "Frame" {
    Parent = screenGui,
    Position = mainMenuPosition:get(),
    AnchorPoint = Vector2.new(0.5, 0.5),
    Size = UDim2.new(0, 400, 0, 300),
    BackgroundColor3 = Color3.new(0, 0, 0),
    BorderSizePixel = 0,
    Visible = false,
    Name = "MainMenuFrame"
}

-- Закруглённые углы
local mainMenuCorner = Fusion.New "UICorner" {
    Parent = mainMenuFrame,
    CornerRadius = UDim.new(0, 10)
}

-- Обводка
local mainMenuStroke = Fusion.New "UIStroke" {
    Parent = mainMenuFrame,
    Color = Color3.new(1, 1, 1),
    Thickness = 2
}

-- Логотип для перетаскивания
local logoDrag = Fusion.New "TextLabel" {
    Parent = mainMenuFrame,
    Position = UDim2.new(0, 10, 0, 10),
    Size = UDim2.new(0, 30, 0, 30),
    BackgroundTransparency = 1,
    Text = "X",
    TextColor3 = Color3.new(1, 1, 1),
    TextScaled = true,
    Font = Enum.Font.SourceSans
}

-- Кнопка закрытия
local closeButton = Fusion.New "TextButton" {
    Parent = mainMenuFrame,
    Position = UDim2.new(1, -40, 0, 10),
    Size = UDim2.new(0, 30, 0, 30),
    BackgroundTransparency = 1,
    Text = "X",
    TextColor3 = Color3.new(1, 0, 0),
    TextScaled = true,
    Font = Enum.Font.SourceSans
}

-- Левая панель (категории)
local leftPanel = Fusion.New "Frame" {
    Parent = mainMenuFrame,
    Position = UDim2.new(0, 10, 0, 50),
    Size = UDim2.new(0.45, -15, 1, -60),
    BackgroundTransparency = 1
}

-- Правая панель (функции)
local rightPanel = Fusion.New "Frame" {
    Parent = mainMenuFrame,
    Position = UDim2.new(0.55, 5, 0, 50),
    Size = UDim2.new(0.45, -15, 1, -60),
    BackgroundTransparency = 1
}

-- Разделитель
local divider = Fusion.New "Frame" {
    Parent = mainMenuFrame,
    Position = UDim2.new(0.5, 0, 0, 50),
    Size = UDim2.new(0, 2, 1, -60),
    BackgroundColor3 = Color3.new(1, 1, 1),
    BorderSizePixel = 0
}

-- ScrollingFrame для левой панели
local leftScroll = Fusion.New "ScrollingFrame" {
    Parent = leftPanel,
    Position = UDim2.new(0, 0, 0, 50),
    Size = UDim2.new(1, 0, 1, -50),
    BackgroundTransparency = 1,
    ScrollBarThickness = 4,
    Visible = false
}

-- ScrollingFrame для правой панели
local rightScroll = Fusion.New "ScrollingFrame" {
    Parent = rightPanel,
    Position = UDim2.new(0, 0, 0, 0),
    Size = UDim2.new(1, 0, 1, 0),
    BackgroundTransparency = 1,
    ScrollBarThickness = 4,
    Visible = false
}

-- Кнопка категории "Esp • X"
local categoryButton = Fusion.New "TextButton" {
    Parent = leftPanel,
    Position = UDim2.new(0, 0, 0, 0),
    Size = UDim2.new(1, 0, 0, 40),
    BackgroundColor3 = Color3.new(0.2, 0.2, 0.2),
    Text = "Esp • X",
    TextColor3 = Color3.new(1, 1, 1),
    Font = Enum.Font.SourceSans,
    TextSize = 18
}

-- Иконка домика (простой текст для примера)
local categoryIcon = Fusion.New "TextLabel" {
    Parent = categoryButton,
    Position = UDim2.new(0, 5, 0.5, 0),
    AnchorPoint = Vector2.new(0, 0.5),
    Size = UDim2.new(0, 20, 0, 20),
    BackgroundTransparency = 1,
    Text = "🏠",
    TextColor3 = Color3.new(1, 1, 1),
    TextScaled = true
}

-- Обработка выбора категории
categoryButton.MouseButton1Click:Connect(function()
    leftScroll.Visible = true
    rightScroll.Visible = true
end)

-- Функция ESP
local espButtonFrame = Fusion.New "Frame" {
    Parent = leftScroll,
    Position = UDim2.new(0, 0, 0, 0),
    Size = UDim2.new(1, 0, 0, 60),
    BackgroundTransparency = 1
}

local espLabel = Fusion.New "TextLabel" {
    Parent = espButtonFrame,
    Position = UDim2.new(0, 5, 0, 5),
    Size = UDim2.new(0.7, 0, 0, 20),
    BackgroundTransparency = 1,
    Text = "Esp",
    TextColor3 = Color3.new(1, 1, 1),
    Font = Enum.Font.SourceSans,
    TextSize = 16
}

local espSubLabel = Fusion.New "TextLabel" {
    Parent = espButtonFrame,
    Position = UDim2.new(0, 5, 0, 25),
    Size = UDim2.new(0.7, 0, 0, 20),
    BackgroundTransparency = 1,
    Text = "Orig",
    TextColor3 = Color3.new(0.7, 0.7, 0.7),
    Font = Enum.Font.SourceSans,
    TextSize = 14
}

local espToggle = Fusion.New "TextButton" {
    Parent = espButtonFrame,
    Position = UDim2.new(0.8, 0, 0.5, 0),
    AnchorPoint = Vector2.new(0.5, 0.5),
    Size = UDim2.new(0, 40, 0, 20),
    BackgroundColor3 = Color3.new(1, 0, 0),
    Text = "OFF",
    TextColor3 = Color3.new(1, 1, 1),
    Font = Enum.Font.SourceSans,
    TextSize = 14
}

-- Функция Noclip
local noclipButtonFrame = Fusion.New "Frame" {
    Parent = rightScroll,
    Position = UDim2.new(0, 0, 0, 0),
    Size = UDim2.new(1, 0, 0, 60),
    BackgroundTransparency = 1
}

local noclipLabel = Fusion.New "TextLabel" {
    Parent = noclipButtonFrame,
    Position = UDim2.new(0, 5, 0, 5),
    Size = UDim2.new(0.7, 0, 0, 20),
    BackgroundTransparency = 1,
    Text = "Noclip",
    TextColor3 = Color3.new(1, 1, 1),
    Font = Enum.Font.SourceSans,
    TextSize = 16
}

local noclipSubLabel = Fusion.New "TextLabel" {
    Parent = noclipButtonFrame,
    Position = UDim2.new(0, 5, 0, 25),
    Size = UDim2.new(0.7, 0, 0, 20),
    BackgroundTransparency = 1,
    Text = "Orig",
    TextColor3 = Color3.new(0.7, 0.7, 0.7),
    Font = Enum.Font.SourceSans,
    TextSize = 14
}

local noclipToggle = Fusion.New "TextButton" {
    Parent = noclipButtonFrame,
    Position = UDim2.new(0.8, 0, 0.5, 0),
    AnchorPoint = Vector2.new(0.5, 0.5),
    Size = UDim2.new(0, 40, 0, 20),
    BackgroundColor3 = Color3.new(1, 0, 0),
    Text = "OFF",
    TextColor3 = Color3.new(1, 1, 1),
    Font = Enum.Font.SourceSans,
    TextSize = 14
}

-- Анимация появления основного меню
mainMenuVisible.onChange(function(visible)
    if visible then
        mainMenuFrame.Visible = true
        local mainMenuTweenIn = TweenService:Create(mainMenuFrame, tweenInfo, { Position = UDim2.new(0.5, 0, 0.5, 0) })
        mainMenuFrame.Position = UDim2.new(0.5, 0, -1, 0)
        mainMenuTweenIn:Play()
    end
end)

-- Обработка кнопки закрытия
closeButton.MouseButton1Click:Connect(function()
    local mainMenuTweenOut = TweenService:Create(mainMenuFrame, tweenInfo, { Position = UDim2.new(0.5, 0, -1, 0) })
    mainMenuTweenOut:Play()
    mainMenuTweenOut.Completed:Connect(function()
        mainMenuFrame.Visible = false
        smallMenuVisible:set(true)
    end)
end)

-- Перетаскивание основного меню
logoDrag.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        mainMenuDragging:set(true)
        dragStart:set(input.Position)
    end
end)

logoDrag.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        mainMenuDragging:set(false)
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if mainMenuDragging:get() and input.UserInputType == Enum.UserInputType.MouseMovement then
        local delta = input.Position - dragStart:get()
        local newPos = mainMenuPosition:get() + UDim2.new(0, delta.X, 0, delta.Y)
        mainMenuPosition:set(newPos)
        mainMenuFrame.Position = newPos
        dragStart:set(input.Position)
    end
end)

-- Реализация ESP
local function createESP(player)
    if player.Character then
        local highlight = Instance.new("Highlight")
        highlight.Parent = player.Character
        highlight.FillColor = Color3.new(1, 0, 0)
        highlight.OutlineColor = Color3.new(1, 1, 1)
        highlight.FillTransparency = 0.5
        highlight.OutlineTransparency = 0
    end
end

espToggle.MouseButton1Click:Connect(function()
    espEnabled:set(not espEnabled:get())
    espToggle.Text = espEnabled:get() and "ON" or "OFF"
    espToggle.BackgroundColor3 = espEnabled:get() and Color3.new(0, 1, 0) or Color3.new(1, 0, 0)
    
    if espEnabled:get() then
        for _, p in pairs(Players:GetPlayers()) do
            if p ~= player then
                createESP(p)
            end
        end
        Players.PlayerAdded:Connect(function(p)
            if espEnabled:get() then
                p.CharacterAdded:Connect(function()
                    createESP(p)
                end)
            end
        end)
    else
        for _, p in pairs(Players:GetPlayers()) do
            if p.Character then
                local highlight = p.Character:FindFirstChildOfClass("Highlight")
                if highlight then
                    highlight:Destroy()
                end
            end
        end
    end
end)

-- Реализация Noclip
local function noclip()
    while noclipEnabled:get() do
        if player.Character then
            for _, part in pairs(player.Character:GetDescendants()) do
                if part:IsA("BasePart") then
                    part.CanCollide = false
                end
            end
        end
        RunService.Stepped:Wait()
    end
end

noclipToggle.MouseButton1Click:Connect(function()
    noclipEnabled:set(not noclipEnabled:get())
    noclipToggle.Text = noclipEnabled:get() and "ON" or "OFF"
    noclipToggle.BackgroundColor3 = noclipEnabled:get() and Color3.new(0, 1, 0) or Color3.new(1, 0, 0)
    
    if noclipEnabled:get() then
        spawn(noclip)
    end
end)
