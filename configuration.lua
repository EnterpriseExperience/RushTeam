local HttpService = cloneref and cloneref(game:GetService("HttpService")) or game:GetService("HttpService")
getgenv().HttpService = HttpService
local Players = cloneref and cloneref(game:GetService("Players")) or game:GetService("Players")
getgenv().Players = Players
local LocalPlayer = Players.LocalPlayer
getgenv().LocalPlayer = LocalPlayer
local HttpService = cloneref and cloneref(game:GetService("HttpService")) or game:GetService("HttpService")
getgenv().HttpService = HttpService
local CoreGui = cloneref and cloneref(game:GetService("CoreGui")) or game:GetService("CoreGui")
getgenv().CoreGui = CoreGui
local RunService = cloneref and cloneref(game:GetService("RunService")) or game:GetService("RunService")
getgenv().RunService = RunService
local CoreGui = cloneref and cloneref(game:GetService("CoreGui")) or game:GetService("CoreGui")
getgenv().CoreGui = CoreGui
local RunService = cloneref and cloneref(game:GetService("RunService")) or game:GetService("RunService")
getgenv().RunService = RunService

local NotifyLib = loadstring(game:HttpGet("https://raw.githubusercontent.com/EnterpriseExperience/MicUpSource/refs/heads/main/Notification_Lib.lua"))()

if not getgenv().notify then
    function notify(notif_type, msg, duration)
        NotifyLib:External_Notification(tostring(notif_type), tostring(msg), tonumber(duration))
    end
    wait(0.1)
    getgenv().notify = notify
end

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

local function Get_Char(Player)
    if not Player or not Player.Character then
        local Char = nil
        local conn
        conn = Player.CharacterAdded:Connect(function(c)
            Char = c
        end)

        repeat task.wait() until Char or not Player.Parent
        if conn then conn:Disconnect() end
        return Char
    end
    return Player.Character
end
wait(0.1)
getgenv().Character = getgenv().Character or Get_Char(getgenv().LocalPlayer)

local function SafeGetHumanoid(char)
	local hum = char:FindFirstChildWhichIsA("Humanoid")

	if hum and hum:IsA("Humanoid") then
		return hum
	else
		return char:WaitForChild("Humanoid", 5)
	end
end

local function SafeGetHead(char)
	local head = char:FindFirstChild("Head")
	if head and head:IsA("BasePart") then
		return head
	else
		return char:WaitForChild("Head", 5)
	end
end

local function SafeGetHRP(char)
	local hrp = char:FindFirstChild("HumanoidRootPart")
	if hrp and hrp:IsA("BasePart") then
		return hrp
	else
		return char:WaitForChild("HumanoidRootPart", 5)
	end
end

getgenv().HumanoidRootPart = SafeGetHRP(getgenv().Character)
getgenv().Humanoid = SafeGetHumanoid(getgenv().Character)
getgenv().Head = SafeGetHead(getgenv().Character)
wait(0.5)
local function Dynamic_Character_Updater(character)
    getgenv().Character = character
    wait(0.4)
    if getgenv().Character and getgenv().Character:FindFirstChild("Humanoid") then
        getgenv().HumanoidRootPart = SafeGetHRP(character)
        getgenv().Humanoid = SafeGetHumanoid(character)
        getgenv().Head = SafeGetHead(character)
    elseif not getgenv().Character then
        repeat task.wait() until character
        getgenv().Character = character
    end
end

Dynamic_Character_Updater(getgenv().Character)
task.wait(0.2)
getgenv().LocalPlayer.CharacterAdded:Connect(function(newCharacter)
    task.wait(0.2)
    Dynamic_Character_Updater(newCharacter)
    repeat wait() until newCharacter:FindFirstChildWhichIsA("Humanoid") and newCharacter:FindFirstChild("HumanoidRootPart")
    wait(0.5)
    getgenv().Character = newCharacter
    wait(0.2)
    getgenv().HumanoidRootPart = SafeGetHRP(newCharacter)
    getgenv().Humanoid = SafeGetHumanoid(newCharacter)
    getgenv().Head = SafeGetHead(newCharacter)
    wait(0.3)
    if not getgenv().Humanoid then
        getgenv().Humanoid = getgenv().Character:WaitForChild("Humanoid", 5)
    end
    wait(0.2)
    Dynamic_Character_Updater(newCharacter)
end)

getgenv().AntiFling_Tracked = getgenv().AntiFling_Tracked or setmetatable({}, { __mode = "k" })
getgenv().AntiFling_Signals = getgenv().AntiFling_Signals or setmetatable({}, { __mode = "k" })
getgenv().AntiFling_Enabled = false
getgenv().AntiFling_SteppedConnection = getgenv().AntiFling_SteppedConnection or nil
getgenv().AntiFling_PlayerAddedConn = getgenv().AntiFling_PlayerAddedConn or nil
getgenv().AntiFling_PlayerRemovingConn = getgenv().AntiFling_PlayerRemovingConn or nil
local tracked = getgenv().AntiFling_Tracked
local signals = getgenv().AntiFling_Signals

function change_vehicle_color(Color, Vehicle)
   getgenv().Send("vehicle_color", Color, Vehicle)
end

function change_phone_color(New_Color)
   getgenv().Send("phone_color", New_Color)
end
task.wait(0.2)
function RGB_Phone(Boolean)
    getgenv().RGB_Rainbow_Phone = Boolean

    local colors = {
        Color3.fromRGB(255, 255, 255),
        Color3.fromRGB(128, 128, 128),
        Color3.fromRGB(0, 0, 0),
        Color3.fromRGB(0, 0, 255),
        Color3.fromRGB(0, 255, 0),
        Color3.fromRGB(0, 255, 255),
        Color3.fromRGB(255, 165, 0),
        Color3.fromRGB(139, 69, 19),
        Color3.fromRGB(255, 255, 0),
        Color3.fromRGB(50, 205, 50),
        Color3.fromRGB(255, 0, 0),
        Color3.fromRGB(255, 155, 172),
        Color3.fromRGB(128, 0, 128),
    }

    if Boolean == true then
        if getgenv().RGB_Rainbow_Phone then
            return getgenv().notify("Warning", "Rainbow Phone is already enabled.", 5)
        end
        wait()
        getgenv().notify("Success", "Started RGB/Rainbow Phone.", 5)
        while getgenv().RGB_Rainbow_Phone == true do
        task.wait(0)
            for _, color in ipairs(colors) do
                if getgenv().RGB_Rainbow_Phone ~= true then return end
                task.wait(0)
                change_phone_color(color)
            end
        end
    elseif Boolean == false then
        if not getgenv().RGB_Rainbow_Phone then
            return getgenv().notify("Warning", "Rainbow Phone is not enabled.", 5)
        end
        wait()
        Boolean = false
        getgenv().RGB_Rainbow_Phone = false
        getgenv().notify("Success", "Stopped RGB/Rainbow Phone.", 5)
        task.wait(0.6)
        repeat task.wait() until getgenv().RGB_Rainbow_Phone == false
        if getgenv().RGB_Rainbow_Phone == false then
            change_phone_color(Color3.fromRGB(255, 255, 255))
        end
    end
end

getgenv().AntiFling_SafeSetCanCollide = function(part, value)
    if typeof(part) == "Instance" and part:IsA("BasePart") then
        pcall(function()
            if part.CanCollide ~= value then
                part.CanCollide = value
            end
        end)
    end
end

getgenv().AntiFling_Apply = function(part)
    if not (part and part:IsA("BasePart")) or tracked[part] then return end
    tracked[part] = true
    getgenv().AntiFling_SafeSetCanCollide(part, false)

    signals[part] = part:GetPropertyChangedSignal("CanCollide"):Connect(function()
        if part and part.Parent and part.CanCollide ~= false then
            getgenv().AntiFling_SafeSetCanCollide(part, false)
        end
    end)
end

getgenv().AntiFling_ProtectCharacter = function(char)
    if not char then return end

    for _, inst in ipairs(char:GetDescendants()) do
        if inst:IsA("BasePart") then
            getgenv().AntiFling_Apply(inst)
        end
    end

    char.DescendantAdded:Connect(function(inst)
        if inst:IsA("BasePart") then
            getgenv().AntiFling_Apply(inst)
        end
    end)

    char.DescendantRemoving:Connect(function(inst)
        if tracked[inst] then
            if signals[inst] then
                signals[inst]:Disconnect()
                signals[inst] = nil
            end
            tracked[inst] = nil
        end
    end)
end

getgenv().AntiFling_HookPlayer = function(plr)
    if plr == LocalPlayer then return end
    if plr.Character then
        getgenv().AntiFling_ProtectCharacter(plr.Character)
    end
    plr.CharacterAdded:Connect(getgenv().AntiFling_ProtectCharacter)
end

getgenv().EnableAntiFling = function()
    if getgenv().AntiFling_Enabled then
        return getgenv().notify("Error", "Anti Fling is already enabled!", 5)
    end
    getgenv().AntiFling_Enabled = true

    for _, plr in ipairs(Players:GetPlayers()) do
        getgenv().AntiFling_HookPlayer(plr)
    end

    getgenv().AntiFling_PlayerAddedConn = Players.PlayerAdded:Connect(getgenv().AntiFling_HookPlayer)
    getgenv().AntiFling_PlayerRemovingConn = Players.PlayerRemoving:Connect(function(plr)
        if plr == LocalPlayer then return end
        local char = plr.Character
        if not char then return end

        for _, part in ipairs(char:GetDescendants()) do
            if tracked[part] then
                if signals[part] then
                    signals[part]:Disconnect()
                    signals[part] = nil
                end
                tracked[part] = nil
            end
        end
    end)

    getgenv().AntiFling_SteppedConnection = RunService.Stepped:Connect(function()
        for part in pairs(tracked) do
            if typeof(part) == "Instance" and part:IsA("BasePart") and part.Parent then
                if part.CanCollide ~= false then
                    getgenv().AntiFling_SafeSetCanCollide(part, false)
                end
            end
        end
    end)

    getgenv().notify("Success", "Anti Fling has been enabled.", 5)
end

getgenv().Noclip_Enabled = false
getgenv().Noclip_Connection = getgenv().Noclip_Connection or nil
local RunService = getgenv().RunService or game:GetService("RunService")

local function ToggleNoclip(toggle)
    if toggle == true then
        if getgenv().Noclip_Enabled then
            return getgenv().notify("Error", "Noclip already enabled!", 5)
        end

        local function NoclipLoop()
            if getgenv().Character then
                for _, part in ipairs(getgenv().Character:GetDescendants()) do
                    if part:IsA("BasePart") and part.CanCollide then
                        part.CanCollide = false
                    end
                end
            end
        end

        getgenv().Noclip_Connection = RunService.Stepped:Connect(NoclipLoop)
        getgenv().Noclip_Enabled = true
        getgenv().notify("Success", "Noclip has been enabled.", 5)
    elseif toggle == false then
        if not getgenv().Noclip_Enabled then
            return getgenv().notify("Error", "Noclip not enabled!", 5)
        end
        if getgenv().Noclip_Connection then
            getgenv().Noclip_Connection:Disconnect()
            getgenv().Noclip_Connection = nil
        end

        for _, part in pairs(getgenv().Character:GetDescendants()) do
            if part and part:IsA("BasePart") then
                part.CanCollide = true
            end
        end
        getgenv().Noclip_Enabled = false
        getgenv().notify("Success", "Noclip has been disabled.", 5)
    else
        return getgenv().notify("Error", "Invalid arg, expected true/false", 5)
    end
end

getgenv().Toggleable_Noclip = ToggleNoclip

getgenv().DisableAntiFling = function()
    if not getgenv().AntiFling_Enabled then
        return getgenv().notify("Error", "Anti Fling is not enabled!", 5)
    end
    getgenv().AntiFling_Enabled = false

    if getgenv().AntiFling_SteppedConnection then
        getgenv().AntiFling_SteppedConnection:Disconnect()
        getgenv().AntiFling_SteppedConnection = nil
    end
    if getgenv().AntiFling_PlayerAddedConn then
        getgenv().AntiFling_PlayerAddedConn:Disconnect()
        getgenv().AntiFling_PlayerAddedConn = nil
    end
    if getgenv().AntiFling_PlayerRemovingConn then
        getgenv().AntiFling_PlayerRemovingConn:Disconnect()
        getgenv().AntiFling_PlayerRemovingConn = nil
    end

    for part, conn in pairs(signals) do
        if conn.Disconnect then
            pcall(conn.Disconnect, conn)
        end
    end

    table.clear(signals)
    table.clear(tracked)

    getgenv().notify("Success", "Anti Fling has been disabled.", 5)
end

getgenv().Toggle_AntiFling_Boolean_Func = function(toggled)
    if toggled == true then
        getgenv().EnableAntiFling()
    elseif toggled == false then
        getgenv().DisableAntiFling()
    else
        return getgenv().notify("Warning", "[Invalid arguments]: Expected true/false brocaroni and cheese.", 5)
    end
end

function RGB_Vehicle(Boolean)
    getgenv().Rainbow_Vehicle = Boolean

    local colors = {
        Color3.fromRGB(255, 255, 255),
        Color3.fromRGB(128, 128, 128),
        Color3.fromRGB(0, 0, 0),
        Color3.fromRGB(0, 0, 255),
        Color3.fromRGB(0, 255, 0),
        Color3.fromRGB(0, 255, 255),
        Color3.fromRGB(255, 165, 0),
        Color3.fromRGB(139, 69, 19),
        Color3.fromRGB(255, 255, 0),
        Color3.fromRGB(50, 205, 50),
        Color3.fromRGB(255, 0, 0),
        Color3.fromRGB(255, 155, 172),
        Color3.fromRGB(128, 0, 128),
    }

    if Boolean == true then
        getgenv().notify("Success", "[Enabled]: Rainbow Vehicle.", 4)
        while getgenv().Rainbow_Vehicle == true do
            task.wait(0)
            for _, color in ipairs(colors) do
                task.wait(0)
                if getgenv().Rainbow_Vehicle ~= true then return end
                change_vehicle_color(color, get_vehicle())
            end
        end
    elseif Boolean == false then
        getgenv().Rainbow_Vehicle = false
        Boolean = false
        getgenv().notify("Success", "[Disabled]: Rainbow Vehicle.", 4)
    end
end

getgenv().AntiOutfitStealerConn = getgenv().AntiOutfitStealerConn or nil
wait()
getgenv().ToggleAntiFit_Stealer = function(state)
    local RunService = getgenv().RunService

    if not state then
        getgenv().anti_outfit_stealer = false

        if getgenv().AntiOutfitStealerConn then
            getgenv().AntiOutfitStealerConn:Disconnect()
            getgenv().AntiOutfitStealerConn = nil
        end

        local bio = getgenv().LocalPlayer:GetAttribute("bio")

        if bio and bio ~= "ANTI COPIER ENABLED HERE - THANKS!" then
            getgenv().Send("bio", "ANTI COPIER ENABLED HERE - THANKS!")
            getgenv().notify("Success", "Bio changed, reverted change.", 2)
        else
            getgenv().notify("Warning", "Bio not found, cannot unlock, disabled loop.", 5)
        end
        return 
    else
        getgenv().AutoLockOn = true
    end

    getgenv().AutoLockConnection = getgenv().RunService.Heartbeat:Connect(function()
        local bio = getgenv().LocalPlayer:GetAttribute("bio")

        if bio and bio ~= "ANTI COPIER ENABLED HERE - THANKS!" then
            getgenv().Send("bio", "ANTI COPIER ENABLED HERE - THANKS!")
            getgenv().notify("Success", "Bio changed, reverted change.", 2)
        end
    end)
end

local Old_Bio = getgenv().LocalPlayer:GetAttribute("bio") or "DEFAULT"
wait(0.2)
function anti_outfit_copier(toggle)
    if toggle == true then
        if getgenv().anti_outfit_stealer then
            return getgenv().notify("Error", "Anti Outfit Stealer is already enabled!", 5)
        end

        getgenv().notify("Info", "NOTE: UNHIDE YOUR NAME! AND do NOT change your Bio, this will not work otherwise (it'll auto-change back for you though incase you do)", 15)
        wait()
        local RunService = getgenv().RunService
        wait(0.1)
        getgenv().ToggleAntiFit_Stealer(true)
    elseif toggle == false then
        getgenv().anti_outfit_stealer = false
        getgenv().ToggleAntiFit_Stealer(false)
        getgenv().Send("bio", tostring(Old_Bio))
    else
        return 
    end
end

function anti_sit_func(toggle)
    local is_enabled = require(getgenv().Game_Folder:FindFirstChild("Seat")).enabled.get()
    
    if toggle == true then
        if getgenv().Not_Ever_Sitting then
            return getgenv().notify("Warning", "AntiSit is already enabled!", 5)
        end

        getgenv().notify("Success", "Anti-Sit is now enabled!", 5)
        show_notification("Success:", "Anti-Sit is now enabled!", "Normal")
        wait(0.2)
        getgenv().Not_Ever_Sitting = true

        while getgenv().Not_Ever_Sitting == true do
        task.wait()
            getgenv().Humanoid:SetStateEnabled(Enum.HumanoidStateType.Seated, false)
            require(getgenv().Game_Folder:FindFirstChild("Seat")).enabled.set(false)
        end
    elseif toggle == false then
        if not getgenv().Not_Ever_Sitting then
            return getgenv().notify("Warning", "AntiSit is not enabled!", 5)
        end

        getgenv().Not_Ever_Sitting = false
        wait(0.2)
        getgenv().Humanoid:SetStateEnabled(Enum.HumanoidStateType.Seated, true)
        require(getgenv().Game_Folder:FindFirstChild("Seat")).enabled.set(true)
        wait(0.1)
        getgenv().notify("Success", "Sitting is now enabled!", 5)
        Phone.show_notification("Success:", "Sitting is now enabled!", "Normal")
    end
end

function anti_void(toggle)
    if toggle == true then
        if not getgenv().originalFPDH then
            getgenv().originalFPDH = getgenv().Workspace.FallenPartsDestroyHeight
        end
        if getgenv().Anti_Void_Enabled_Bool then
            return getgenv().notify("Warning", "Anti-Void is already enabled!", 5)
        end

        getgenv().Workspace.FallenPartsDestroyHeight = -9e9
        getgenv().notify("Success", "Enabled anti-void.", 5)
        getgenv().Anti_Void_Enabled_Bool = true
    elseif toggle == false then
        if not getgenv().originalFPDH then
            getgenv().originalFPDH = -500
            return getgenv().notify("Error", "Original destroy height doesn't exist!", 5)
        end
        if not getgenv().Anti_Void_Enabled_Bool then
            return getgenv().notify("Warning", "Anti-Void has not been enabled!", 5)
        end

        getgenv().Workspace.FallenPartsDestroyHeight = getgenv().originalFPDH or -500
        getgenv().notify("Success", "Disabled anti-void.", 5)
    else
        return 
    end
end

getgenv().VehicleDestroyer_Enabled = getgenv().VehicleDestroyer_Enabled or false
getgenv().VehicleDestroyer_Connections = getgenv().VehicleDestroyer_Connections or {}

local function clearConnections()
	for _, conn in ipairs(getgenv().VehicleDestroyer_Connections) do
		if typeof(conn) == "RBXScriptConnection" then
			pcall(function() conn:Disconnect() end)
		end
	end
	table.clear(getgenv().VehicleDestroyer_Connections)
	getgenv().folderAddedConn = nil
	getgenv().vehiclesChildAddedConn = nil
	getgenv().vehiclesHeartBeatConnection = nil
end

local function disableCollisionIn(folder)
	for _, obj in ipairs(folder:GetDescendants()) do
		if obj:IsA("BasePart") and obj.CanCollide then
			obj.CanCollide = false
		end
	end
end

local function setupFolder(folder)
	disableCollisionIn(folder)

   getgenv().notify("Success", "Anti Vehicle Fling has been enabled.", 5)
	getgenv().vehiclesChildAddedConn = folder.ChildAdded:Connect(function(child)
		if not getgenv().VehicleDestroyer_Enabled then return end

		if child:IsA("BasePart") then
			child.CanCollide = false
		elseif child:IsA("Model") then
			child.DescendantAdded:Connect(function(desc)
				if desc:IsA("BasePart") then
					desc.CanCollide = false
				end
			end)
			disableCollisionIn(child)
		end
	end)
	table.insert(getgenv().VehicleDestroyer_Connections, getgenv().vehiclesChildAddedConn)
end

getgenv().DisableVehicleDestroyer = function()
    if not getgenv().VehicleDestroyer_Enabled then
        return getgenv().notify("Warning", "Anti Vehicle Fling is not enabled!", 5)
    end
    wait(0.1)
	getgenv().VehicleDestroyer_Enabled = false
	clearConnections()
end

function anti_car_fling(toggle)
    if toggle == true then
        if getgenv().VehicleDestroyer_Enabled then
            return getgenv().notify("Warning", "Anti Vehicle Fling is already enabled!", 5)
        end
        wait(0.1)
            getgenv().VehicleDestroyer_Enabled = true
            clearConnections()

            local vehiclesFolder = getgenv().Workspace:FindFirstChild("Vehicles") or getgenv().Workspace:WaitForChild("Vehicles", 5)
            if vehiclesFolder then
                setupFolder(vehiclesFolder)
            end

            getgenv().folderAddedConn = getgenv().Workspace.ChildAdded:Connect(function(child)
                if child.Name == "Vehicles" and child:IsA("Folder") then
                    setupFolder(child)
                    vehiclesFolder = child
                end
            end)
            table.insert(getgenv().VehicleDestroyer_Connections, getgenv().folderAddedConn)

            getgenv().vehiclesHeartBeatConnection = getgenv().RunService.Heartbeat:Connect(function()
                if not getgenv().VehicleDestroyer_Enabled then return end
                if vehiclesFolder and vehiclesFolder.Parent then
                    disableCollisionIn(vehiclesFolder)
                else
                    vehiclesFolder = getgenv().Workspace:FindFirstChild("Vehicles")
                end
            end)
            table.insert(getgenv().VehicleDestroyer_Connections, getgenv().vehiclesHeartBeatConnection)
        elseif toggle == false then
            getgenv().DisableVehicleDestroyer()
        getgenv().notify("Success", "Anti Vehicle Fling has been disabled.", 5)
    else
        return 
	end
end

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
Title.Size = UDim2.new(0.850000024, 0, 0, 45)
Title.Position = UDim2.new(0, 0, 0, 0)
Title.BackgroundTransparency = 1
Title.Text = "🔥 Flames Admin Config 🔥"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.Font = Enum.Font.GothamBold
Title.TextSize = 14
Title.TextScaled = false

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
            RGB_Vehicle(true)
        else
            RGB_Vehicle(false)
        end
    elseif name == "RainbowPhone" then
        if state == "enabled" then
            RGB_Phone(true)
        else
            RGB_Phone(false)
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

local toggles = {"RainbowVehicle", "RainbowPhone", "AntiCarFling", "AntiFling", "AntiVoid", "NoClip", "NoSit", "AntiOutfitStealer"}

for i, t in ipairs(toggles) do
    create_toggle(t, i)
end
