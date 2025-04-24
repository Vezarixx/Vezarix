-- Добавление новых функций в категорию DOORS
Categories[4].Functions = {
    {Name = "Entity Notifier", Setting = {Enabled = false}, HasSettings = true}, -- Уведомления о существах
    {Name = "Chat Notifier", Setting = {Enabled = false}}, -- Уведомления в чате
    {Name = "Auto Loot", Setting = {Enabled = false}}, -- Автоматический сбор предметов
    {Name = "Anti-Screech", Setting = {Enabled = false}}, -- Защита от Screech
    {Name = "Anti-A-90", Setting = {Enabled = false}}, -- Защита от A-90
    {Name = "Anti-Snare", Setting = {Enabled = false}}, -- Защита от Snare
    {Name = "Fullbright", Setting = {Enabled = false}}, -- Полная яркость
    {Name = "ESP Items & Entities", Setting = {Enabled = false, Transparency = 0.5, Color = Color3.fromRGB(255, 255, 255), Mode = "AlwaysOnTop"}, HasSettings = true}, -- ESP для предметов и существ
    {Name = "No Key Requirement", Setting = {Enabled = false}}, -- Безключевой доступ
    {Name = "Entity Spawner", Setting = {Enabled = false}, HasSettings = true}, -- Спавн существ
    {Name = "Unlock Achievements", Action = function() -- Разблокировка достижений
        for _, achievement in pairs({"Join", "Escape", "Survive"}) do
            pcall(function()
                require(game.Players.LocalPlayer.PlayerGui.MainUI.Initiator.Main_Game.RemoteListener.Modules.AchievementUnlock)(nil, achievement)
            end)
        end
        CreateNotification("DOORS", "Unlock Achievements", true)
    end},
    {Name = "Skip Level", Action = function() -- Пропуск уровня
        local currentRoom = game:GetService("ReplicatedStorage").GameData.LatestRoom.Value
        local nextRoom = workspace.CurrentRooms[currentRoom + 1]
        if nextRoom then
            local player = Players.LocalPlayer.Character
            if player and player:FindFirstChild("HumanoidRootPart") then
                player.HumanoidRootPart.CFrame = nextRoom:FindFirstChild("Door").CFrame + Vector3.new(0, 5, 0)
                CreateNotification("DOORS", "Skip Level", true)
            end
        end
    end},
    {Name = "Fly", Setting = {Enabled = false}}, -- Полёт
    {Name = "Teleport to Room", Setting = {Enabled = false, Value = 0, Min = 0, Max = 100}, HasInput = true} -- Телепортация в комнату
}

-- Логика новых функций
local function UpdateEntityNotifier()
    if not Categories[4].Functions[1].Setting.Enabled then return end
    local entities = {"Rush", "Ambush", "Screech", "A-90"}
    for _, entity in pairs(workspace:GetChildren()) do
        for _, name in pairs(entities) do
            if entity.Name:find(name) then
                CreateNotification("DOORS", "Detected: " .. name, true)
            end
        end
    end
end

local function UpdateChatNotifier()
    if not Categories[4].Functions[2].Setting.Enabled then return end
    local entities = {"Rush", "Ambush", "Screech", "A-90"}
    for _, entity in pairs(workspace:GetChildren()) do
        for _, name in pairs(entities) do
            if entity.Name:find(name) then
                game:GetService("TextChatService").TextChannels.RBXGeneral:SendAsync("Entity detected: " .. name)
            end
        end
    end
end

local function UpdateAutoLoot()
    if not Categories[4].Functions[3].Setting.Enabled then return end
    for _, item in pairs(workspace:GetDescendants()) do
        if item.Name == "KeyObtain" or item.Name == "BookObtain" or item.Name == "Gold" then
            local player = Players.LocalPlayer.Character
            if player and player:FindFirstChild("HumanoidRootPart") and item:IsA("Model") and item.PrimaryPart then
                player.HumanoidRootPart.CFrame = item.PrimaryPart.CFrame
                wait(0.1)
                fireproximityprompt(item:FindFirstChildOfClass("ProximityPrompt"))
            end
        end
    end
end

local function UpdateAntiScreech()
    if not Categories[4].Functions[4].Setting.Enabled then return end
    for _, entity in pairs(workspace:GetChildren()) do
        if entity.Name:find("Screech") then
            entity:Destroy()
            CreateNotification("DOORS", "Screech Removed", true)
        end
    end
end

local function UpdateAntiA90()
    if not Categories[4].Functions[5].Setting.Enabled then return end
    local mainGame = game.Players.LocalPlayer.PlayerGui.MainUI.Initiator.Main_Game
    if mainGame and mainGame:FindFirstChild("A90") then
        local player = Players.LocalPlayer.Character
        if player and player:FindFirstChild("Humanoid") then
            player.Humanoid.WalkSpeed = 0
            wait(2)
            player.Humanoid.WalkSpeed = Settings.SpeedBoost.Enabled and Settings.SpeedBoost.Value or 16
            CreateNotification("DOORS", "A-90 Avoided", true)
        end
    end
end

local function UpdateAntiSnare()
    if not Categories[4].Functions[6].Setting.Enabled then return end
    for _, snare in pairs(workspace:GetDescendants()) do
        if snare.Name == "Snare" and snare:IsA("BasePart") then
            snare:Destroy()
            CreateNotification("DOORS", "Snare Removed", true)
        end
    end
end

local function UpdateFullbright()
    if not Categories[4].Functions[7].Setting.Enabled then
        game:GetService("Lighting").Brightness = 1
        game:GetService("Lighting").FogEnd = 100000
        return
    end
    game:GetService("Lighting").Brightness = 3
    game:GetService("Lighting").FogEnd = 999999
    CreateNotification("DOORS", "Fullbright " .. (Categories[4].Functions[7].Setting.Enabled and "Enabled" or "Disabled"), Categories[4].Functions[7].Setting.Enabled)
end

local function UpdateESPItemsEntities()
    if not Categories[4].Functions[8].Setting.Enabled then
        for _, highlight in pairs(ESPObjects) do
            highlight.Enabled = false
        end
        return
    end
    for _, obj in pairs(workspace:GetDescendants()) do
        if (obj.Name == "KeyObtain" or obj.Name == "BookObtain" or obj.Name:find("Rush") or obj.Name:find("Ambush") or obj.Name:find("Screech")) and not ESPObjects[obj] then
            local highlight = Instance.new("Highlight")
            highlight.FillTransparency = Categories[4].Functions[8].Setting.Transparency
            highlight.FillColor = Categories[4].Functions[8].Setting.Color
            highlight.OutlineTransparency = 0
            highlight.OutlineColor = Color3.fromRGB(147, 112, 219)
            highlight.Adornee = obj:IsA("Model") and obj or obj.Parent
            highlight.DepthMode = Categories[4].Functions[8].Setting.Mode == "AlwaysOnTop" and Enum.HighlightDepthMode.AlwaysOnTop or Enum.HighlightDepthMode.Occluded
            highlight.Parent = game:GetService("CoreGui")
            ESPObjects[obj] = highlight
        end
    end
end

local function UpdateNoKeyRequirement()
    if not Categories[4].Functions[9].Setting.Enabled then return end
    for _, door in pairs(workspace.CurrentRooms:GetDescendants()) do
        if door.Name == "Door" and door:FindFirstChild("Lock") then
            door.Lock:Destroy()
            CreateNotification("DOORS", "Door Unlocked", true)
        end
    end
end

local function UpdateEntitySpawner()
    if not Categories[4].Functions[10].Setting.Enabled then return end
    -- Настройки спавна задаются через GUI
    local entity = {
        CustomName = Categories[4].Functions[10].Setting.EntityName or "CustomEntity",
        Model = 11510871416, -- Пример модели
        Speed = Categories[4].Functions[10].Setting.Speed or 100,
        DelayTime = 2,
        HeightOffset = 0,
        CanKill = true,
        BreakLights = true,
        FlickerLights = {true, 2},
        Cycles = {Min = 1, Max = 4, WaitTime = 2},
        CamShake = {true, {5, 15, 0.1, 1}, 100},
        Jumpscare = {false, {}}
    }
    pcall(function()
        require(game.ReplicatedStorage.ClientModules.EntityModules[entity.CustomName]).new(entity)
        CreateNotification("DOORS", "Spawned " .. entity.CustomName, true)
    end)
end

local FlyConnection = nil
local function UpdateFly()
    if not Categories[4].Functions[13].Setting.Enabled then
        if FlyConnection then
            FlyConnection:Disconnect()
            FlyConnection = nil
        end
        local character = Players.LocalPlayer.Character
        if character and character:FindFirstChild("HumanoidRootPart") then
            character.HumanoidRootPart.Anchored = false
        end
        return
    end
    local character = Players.LocalPlayer.Character
    if not character or not character:FindFirstChild("HumanoidRootPart") then return end
    FlyConnection = RunService.RenderStepped:Connect(function()
        local camera = workspace.CurrentCamera
        local moveDirection = Vector3.new()
        if UserInputService:IsKeyDown(Enum.KeyCode.W) then
            moveDirection = moveDirection + camera.CFrame.LookVector
        end
        if UserInputService:IsKeyDown(Enum.KeyCode.S) then
            moveDirection = moveDirection - camera.CFrame.LookVector
        end
        if UserInputService:IsKeyDown(Enum.KeyCode.A) then
            moveDirection = moveDirection - camera.CFrame.RightVector
        end
        if UserInputService:IsKeyDown(Enum.KeyCode.D) then
            moveDirection = moveDirection + camera.CFrame.RightVector
        end
        character.HumanoidRootPart.Velocity = moveDirection * 50
        character.HumanoidRootPart.Anchored = false
    end)
    CreateNotification("DOORS", "Fly " .. (Categories[4].Functions[13].Setting.Enabled and "Enabled" or "Disabled"), Categories[4].Functions[13].Setting.Enabled)
end

local function UpdateTeleportToRoom()
    if not Categories[4].Functions[14].Setting.Enabled then return end
    local roomNumber = Categories[4].Functions[14].Setting.Value
    local room = workspace.CurrentRooms[roomNumber]
    if room then
        local player = Players.LocalPlayer.Character
        if player and player:FindFirstChild("HumanoidRootPart") then
            player.HumanoidRootPart.CFrame = room:FindFirstChild("Door").CFrame + Vector3.new(0, 5, 0)
            CreateNotification("DOORS", "Teleported to Room " .. roomNumber, true)
        end
    end
end

-- Настройки для Entity Notifier
local function CreateEntityNotifierSettings()
    local SettingsFrame = Instance.new("Frame")
    SettingsFrame.Name = "EntityNotifierSettings"
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
    SettingsTitle.Text = "Настройка Entity Notifier"
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
        local fadeOutSettings = TweenService:Create(SettingsFrame, TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {BackgroundTransparency = 1})
        local fadeOutStroke = TweenService:Create(SettingsStroke, TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {Transparency = 1})
        local fadeOutTitle = TweenService:Create(SettingsTitle, TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {TextTransparency = 1})
        local fadeOutCloseButton = TweenService:Create(CloseButton, TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {TextTransparency = 1})
        fadeOutSettings:Play()
        fadeOutStroke:Play()
        fadeOutTitle:Play()
        fadeOutCloseButton:Play()
        fadeOutSettings.Completed:Connect(function()
            SettingsFrame:Destroy()
        end)
    end)

    local fadeInSettings = TweenService:Create(SettingsFrame, TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {BackgroundTransparency = 0})
    local fadeInStroke = TweenService:Create(SettingsStroke, TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Transparency = 0})
    local fadeInTitle = TweenService:Create(SettingsTitle, TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {TextTransparency = 0})
    local fadeInCloseButton = TweenService:Create(CloseButton, TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {TextTransparency = 0})
    fadeInSettings:Play()
    fadeInStroke:Play()
    fadeInTitle:Play()
    fadeInCloseButton:Play()
end

-- Настройки для Entity Spawner
local function CreateEntitySpawnerSettings()
    local SettingsFrame = Instance.new("Frame")
    SettingsFrame.Name = "EntitySpawnerSettings"
    SettingsFrame.Size = UDim2.new(0, 180, 0, 180)
    SettingsFrame.Position = UDim2.new(0.5, -90, 0.5, -90)
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
    SettingsTitle.Text = "Настройка Entity Spawner"
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
        local fadeOutSettings = TweenService:Create(SettingsFrame, TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {BackgroundTransparency = 1})
        local fadeOutStroke = TweenService:Create(SettingsStroke, TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {Transparency = 1})
        local fadeOutTitle = TweenService:Create(SettingsTitle, TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {TextTransparency = 1})
        local fadeOutCloseButton = TweenService:Create(CloseButton, TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {TextTransparency = 1})
        local fadeOutEntityInput = TweenService:Create(SettingsFrame:FindFirstChild("EntityInput"), TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {BackgroundTransparency = 1, TextTransparency = 1})
        local fadeOutSpeedInput = TweenService:Create(SettingsFrame:FindFirstChild("SpeedInput"), TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {BackgroundTransparency = 1, TextTransparency = 1})
        fadeOutSettings:Play()
        fadeOutStroke:Play()
        fadeOutTitle:Play()
        fadeOutCloseButton:Play()
        fadeOutEntityInput:Play()
        fadeOutSpeedInput:Play()
        fadeOutSettings.Completed:Connect(function()
            SettingsFrame:Destroy()
        end)
    end)

    local EntityInput = Instance.new("TextBox")
    EntityInput.Name = "EntityInput"
    EntityInput.Size = UDim2.new(0, 150, 0, 30)
    EntityInput.Position = UDim2.new(0, 15, 0, 40)
    EntityInput.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    EntityInput.Text = Categories[4].Functions[10].Setting.EntityName or "Rush"
    EntityInput.TextColor3 = Color3.fromRGB(255, 255, 255)
    EntityInput.TextSize = 14
    EntityInput.Font = Enum.Font.SourceSans
    EntityInput.BackgroundTransparency = 1
    EntityInput.TextTransparency = 1
    EntityInput.Parent = SettingsFrame

    local EntityCorner = Instance.new("UICorner")
    EntityCorner.CornerRadius = UDim.new(0, 5)
    EntityCorner.Parent = EntityInput

    local EntityStroke = Instance.new("UIStroke")
    EntityStroke.Color = Color3.fromRGB(147, 112, 219)
    EntityStroke.Thickness = 1
    EntityStroke.Transparency = 1
    EntityStroke.Parent = EntityInput

    EntityInput.FocusLost:Connect(function(enterPressed)
        if enterPressed then
            Categories[4].Functions[10].Setting.EntityName = EntityInput.Text
        end
    end)

    local SpeedInput = Instance.new("TextBox")
    SpeedInput.Name = "SpeedInput"
    SpeedInput.Size = UDim2.new(0, 150, 0, 30)
    SpeedInput.Position = UDim2.new(0, 15, 0, 80)
    SpeedInput.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    SpeedInput.Text = tostring(Categories[4].Functions[10].Setting.Speed or 100)
    SpeedInput.TextColor3 = Color3.fromRGB(255, 255, 255)
    SpeedInput.TextSize = 14
    SpeedInput.Font = Enum.Font.SourceSans
    SpeedInput.BackgroundTransparency = 1
    SpeedInput.TextTransparency = 1
    SpeedInput.Parent = SettingsFrame

    local SpeedCorner = Instance.new("UICorner")
    SpeedCorner.CornerRadius = UDim.new(0, 5)
    SpeedCorner.Parent = SpeedInput

    local SpeedStroke = Instance.new("UIStroke")
    SpeedStroke.Color = Color3.fromRGB(147, 112, 219)
    SpeedStroke.Thickness = 1
    SpeedStroke.Transparency = 1
    SpeedStroke.Parent = SpeedInput

    SpeedInput.FocusLost:Connect(function(enterPressed)
        if enterPressed then
            local value = tonumber(SpeedInput.Text)
            if value then
                Categories[4].Functions[10].Setting.Speed = math.clamp(value, 50, 500)
                SpeedInput.Text = tostring(Categories[4].Functions[10].Setting.Speed)
            else
                SpeedInput.Text = tostring(Categories[4].Functions[10].Setting.Speed or 100)
            end
        end
    end)

    local fadeInSettings = TweenService:Create(SettingsFrame, TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {BackgroundTransparency = 0})
    local fadeInStroke = TweenService:Create(SettingsStroke, TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Transparency = 0})
    local fadeInTitle = TweenService:Create(SettingsTitle, TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {TextTransparency = 0})
    local fadeInCloseButton = TweenService:Create(CloseButton, TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {TextTransparency = 0})
    local fadeInEntityInput = TweenService:Create(EntityInput, TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {BackgroundTransparency = 0, TextTransparency = 0})
    local fadeInSpeedInput = TweenService:Create(SpeedInput, TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {BackgroundTransparency = 0, TextTransparency = 0})
    fadeInSettings:Play()
    fadeInStroke:Play()
    fadeInTitle:Play()
    fadeInCloseButton:Play()
    fadeInEntityInput:Play()
    fadeInSpeedInput:Play()
end

-- Обновление всех функций в RunService.Heartbeat
RunService.Heartbeat:Connect(function()
    UpdateSpeedBoost()
    UpdateJumpBoost()
    UpdateFOVBoost()
    UpdateNoclip()
    UpdateESP()
    UpdateInfiniteJump()
    UpdateEntityNotifier()
    UpdateChatNotifier()
    UpdateAutoLoot()
    UpdateAntiScreech()
    UpdateAntiA90()
    UpdateAntiSnare()
    UpdateFullbright()
    UpdateESPItemsEntities()
    UpdateNoKeyRequirement()
    UpdateEntitySpawner()
    UpdateFly()
    UpdateTeleportToRoom()
end)

-- Обновление настроек для ESP Items & Entities
for _, func in pairs(Categories[4].Functions) do
    if func.Name == "ESP Items & Entities" and func.HasSettings then
        local SettingsButton = Instance.new("TextButton")
        SettingsButton.Size = UDim2.new(0, 20, 0, 20)
        SettingsButton.Position = UDim2.new(1, -60, 0, 5)
        SettingsButton.Text = "⚙"
        SettingsButton.TextColor3 = Color3.fromRGB(255, 255, 255)
        SettingsButton.BackgroundTransparency = 1
        SettingsButton.Parent = func.FuncFrame -- Предполагается, что FuncFrame создаётся в цикле создания функций

        SettingsButton.MouseButton1Click:Connect(function()
            local SettingsFrame = Instance.new("Frame")
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
                end)
            end)

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
            ModeButton.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
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
    elseif func.Name == "Entity Notifier" and func.HasSettings then
        local SettingsButton = Instance.new("TextButton")
        SettingsButton.Size = UDim2.new(0, 20, 0, 20)
        SettingsButton.Position = UDim2.new(1, -60, 0, 5)
        SettingsButton.Text = "⚙"
        SettingsButton.TextColor3 = Color3.fromRGB(255, 255, 255)
        SettingsButton.BackgroundTransparency = 1
        SettingsButton.Parent = func.FuncFrame -- Предполагается, что FuncFrame создаётся в цикле создания функций

        SettingsButton.MouseButton1Click:Connect(CreateEntityNotifierSettings)
    elseif func.Name == "Entity Spawner" and func.HasSettings then
        local SettingsButton = Instance.new("TextButton")
        SettingsButton.Size = UDim2.new(0, 20, 0, 20)
        SettingsButton.Position = UDim2.new(1, -60, 0, 5)
        SettingsButton.Text = "⚙"
        SettingsButton.TextColor3 = Color3.fromRGB(255, 255, 255)
        SettingsButton.BackgroundTransparency = 1
        SettingsButton.Parent = func.FuncFrame -- Предполагается, что FuncFrame создаётся в цикле создания функций

        SettingsButton.MouseButton1Click:Connect(CreateEntitySpawnerSettings)
    end
end
