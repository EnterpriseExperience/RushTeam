local HttpService = cloneref and cloneref(game:GetService("HttpService")) or game:GetService("HttpService")
local config_path = "Flames_Admin_Config.json"
local default_config = {
   RainbowVehicle = "disabled",
   RainbowPhone = "disabled",
   AntiCarFling = "disabled",
   AntiFling = "disabled",
   AntiVoid = "disabled",
   NoClip = "disabled",
   NoSit = "disabled",
   AntiOutfitStealer = "disabled"
}

if not isfile(config_path) then
   writefile(config_path, HttpService:JSONEncode(default_config))
end

local config = HttpService:JSONDecode(readfile(config_path))
local function save_config()
   writefile(config_path, HttpService:JSONEncode(config))
end

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "FlamesAdminGUI"
ScreenGui.Parent = getgenv().CoreGui
ScreenGui.ResetOnSpawn = false

local Frame = Instance.new("Frame")
Frame.Size = UDim2.new(0, 300, 0, 400)
Frame.Position = UDim2.new(0.5, -150, 0.5, -200)
Frame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
Frame.BorderSizePixel = 0
Frame.Parent = ScreenGui
Frame.Active = true
Frame.Draggable = true
Instance.new("UICorner", Frame).CornerRadius = UDim.new(0, 12)

local Title = Instance.new("TextLabel", Frame)
Title.Size = UDim2.new(1, 0, 0, 40)
Title.BackgroundTransparency = 1
Title.Text = "🔥 Flames Admin Configuration 🔥"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.Font = Enum.Font.GothamBold
Title.TextScaled = true

local Close = Instance.new("TextButton", Frame)
Close.Size = UDim2.new(0, 35, 0, 35)
Close.Position = UDim2.new(1, -40, 0, 5)
Close.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
Close.Text = "X"
Close.TextColor3 = Color3.fromRGB(255, 100, 100)
Close.Font = Enum.Font.GothamBold
Close.TextScaled = true
Instance.new("UICorner", Close).CornerRadius = UDim.new(0, 8)
Close.MouseButton1Click:Connect(function()
   ScreenGui:Destroy()
end)

getgenv().Flames_Features = getgenv().Flames_Features or {}

local function handle_toggle(name, state)
   if name == "RainbowVehicle" then
      if state == "enabled" then
         RGB_Phone(true)
      else
         RGB_Phone(false)
      end
   elseif name == "RainbowPhone" then
      if state == "enabled" then
         RGB_Vehicle(true)
      else
         RGB_Vehicle(false)
      end
   elseif name == "AntiCarFling" then
      if state == "enabled" then
         anti_car_fling(true)
      else
         anti_car_fling(false)
      end
   elseif name == "AntiFling" then
      if state == "enabled" then
         getgenv().Toggle_AntiFling_Boolean_Func(true)
      else
         getgenv().Toggle_AntiFling_Boolean_Func(false)
      end
   elseif name == "AntiVoid" then
      if state == "enabled" then
         anti_void(true)
      else
         anti_void(false)
      end
   elseif name == "NoClip" then
      if state == "enabled" then
         getgenv().Toggleable_Noclip(true)
      else
         getgenv().Toggleable_Noclip(false)
      end
   elseif name == "NoSit" then
      if state == "enabled" then
         anti_sit_func(true)
      else
         anti_sit_func(false)
      end
   elseif name == "AntiOutfitStealer" then
      if state == "enabled" then
         anti_outfit_copier(true)
      else
         anti_outfit_copier(false)
      end
   end
end

local function create_toggle(name, order)
   local Button = Instance.new("TextButton", Frame)
   Button.Size = UDim2.new(1, -20, 0, 35)
   Button.Position = UDim2.new(0, 10, 0, 50 + (order - 1) * 40)
   Button.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
   Button.TextColor3 = Color3.fromRGB(255, 255, 255)
   Button.Font = Enum.Font.Gotham
   Button.TextScaled = true
   Button.Text = name .. ": " .. (config[name] == "enabled" and "ON" or "OFF")
   Instance.new("UICorner", Button).CornerRadius = UDim.new(0, 8)

   if config[name] == "enabled" then
      handle_toggle(name, "enabled")
   end

   Button.MouseButton1Click:Connect(function()
      config[name] = (config[name] == "enabled") and "disabled" or "enabled"
      Button.Text = name .. ": " .. (config[name] == "enabled" and "ON" or "OFF")
      save_config()
      handle_toggle(name, config[name])
   end)
end

local toggles = {"RainbowVehicle","RainbowPhone","AntiCarFling","AntiFling","AntiVoid","NoClip","NoSit","AntiOutfitStealer"}
for i, t in ipairs(toggles) do
   create_toggle(t, i)
end
