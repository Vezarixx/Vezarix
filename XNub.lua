-- Загрузка GUI библиотеки
loadstring(game:HttpGet("https://sirius.menu/rayfield"))()

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera
local RunService = game:GetService("RunService")
local ESP_Enabled = false
local Aimbot_Enabled = false
local Aimbot_FOV = 100
local Aimbot_Key = Enum.KeyCode.E

-- GUI
local Window = Rayfield:CreateWindow({
   Name = "Лучший чит - ESP & AIMBOT",
   LoadingTitle = "Загрузка худа",
   ConfigurationSaving = {
      Enabled = true,
      FolderName = "TopCheatHub",
      FileName = "settings"
   }
})

local Tab = Window:CreateTab("Функции", 4483362458)

Tab:CreateToggle({
   Name = "ESP",
   CurrentValue = false,
   Callback = function(Value)
      ESP_Enabled = Value
   end,
})

Tab:CreateToggle({
   Name = "Aimbot",
   CurrentValue = false,
   Callback = function(Value)
      Aimbot_Enabled = Value
   end,
})

Tab:CreateSlider({
   Name = "FOV Aimbot'a",
   Range = {10, 300},
   Increment = 10,
   CurrentValue = 100,
   Callback = function(Value)
      Aimbot_FOV = Value
   end,
})

Tab:CreateKeybind({
   Name = "Клавиша Aimbot'a",
   CurrentKeybind = "E",
   HoldToInteract = false,
   Callback = function(Key)
      Aimbot_Key = Key
   end,
})

-- ESP функция
function CreateESP(player)
   local Box = Drawing.new("Text")
   Box.Size = 14
   Box.Color = Color3.fromRGB(255, 50, 50)
   Box.Center = true
   Box.Outline = true
   Box.Font = 2
   Box.Visible = false

   RunService.RenderStepped:Connect(function()
      if ESP_Enabled and player and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
         local pos, onScreen = Camera:WorldToViewportPoint(player.Character.HumanoidRootPart.Position)
         Box.Visible = onScreen
         if onScreen then
            Box.Position = Vector2.new(pos.X, pos.Y)
            Box.Text = player.Name
         end
      else
         Box.Visible = false
      end
   end)
end

for _, player in pairs(Players:GetPlayers()) do
   if player ~= LocalPlayer then
      CreateESP(player)
   end
end

Players.PlayerAdded:Connect(function(player)
   if player ~= LocalPlayer then
      CreateESP(player)
   end
end)

-- Aimbot функция
function GetClosestPlayer()
   local closestPlayer = nil
   local shortestDistance = Aimbot_FOV

   for _, player in pairs(Players:GetPlayers()) do
      if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild("Head") then
         local pos, onScreen = Camera:WorldToViewportPoint(player.Character.Head.Position)
         if onScreen then
            local distance = (Vector2.new(pos.X, pos.Y) - Vector2.new(Camera.ViewportSize.X/2, Camera.ViewportSize.Y/2)).Magnitude
            if distance < shortestDistance then
               shortestDistance = distance
               closestPlayer = player
            end
         end
      end
   end

   return closestPlayer
end

-- Aimbot при зажатии клавиши
RunService.RenderStepped:Connect(function()
   if Aimbot_Enabled and game:GetService("UserInputService"):IsKeyDown(Aimbot_Key) then
      local target = GetClosestPlayer()
      if target and target.Character and target.Character:FindFirstChild("Head") then
         Camera.CFrame = CFrame.new(Camera.CFrame.Position, target.Character.Head.Position)
      end
   end
end)
