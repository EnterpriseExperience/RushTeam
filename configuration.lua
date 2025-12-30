if not game:IsLoaded() then game.Loaded:Wait() end

if not getgenv().Game then
    getgenv().Game = game
end

if getgenv().FlamesConfigManager then
	return 
end
getgenv().FlamesConfigManager = true

local function safe_wrap(service)
    if cloneref then
        return cloneref(game:GetService(service))
    else
        return game:GetService(service)
    end
end

local function get_or_set(global, value)
    local v = rawget and rawget(getgenv(), global) or getgenv()[global]
    if v == nil then
        getgenv()[global] = value
        return value
    end
    return v
end

if not getgenv().All_Services_Initialized then
    local function exec_ls(url)
        local FormattedURL = tostring(url)

        return loadstring(game:HttpGet(FormattedURL))()
    end
    wait(0.1)
    if not getgenv().exec_ls then
        getgenv().exec_ls = exec_ls
    end
    wait(0.1)
    function exec_lib(Name)
        local Formatted_Library = tostring(Name)

        exec_ls("https://raw.githubusercontent.com/EnterpriseExperience/Script_Framework/main/"..Formatted_Library)
    end
    wait(0.3)
    exec_lib("GlobalEnv_Framework.lua")
end
wait(1)
HttpService  = get_or_set("HttpService", safe_wrap("HttpService"))
Players = get_or_set("Players", safe_wrap("Players"))
LocalPlayer = get_or_set("LocalPlayer", Players.LocalPlayer)
CoreGui = get_or_set("CoreGui", safe_wrap("CoreGui"))
RunService = get_or_set("RunService", safe_wrap("RunService"))
local parent_gui = CoreGui
local NotifyLib = loadstring(game:HttpGet("https://raw.githubusercontent.com/EnterpriseExperience/MicUpSource/refs/heads/main/Notification_Lib.lua"))()

local function retrieve_executor()
    local name
    if identifyexecutor then
        name = identifyexecutor()
    end
    return { Name = name or "Unknown Executor" }
end

local function identify_executor()
    local executorDetails = retrieve_executor()
    return tostring(executorDetails.Name)
end

wait(0.1)
local executor_string = identify_executor()

local function executor_contains(substr)
    if type(executor_string) ~= "string" then
        return false
    end

    return string.find(string.lower(executor_string), string.lower(substr), 1, true) ~= nil
end
wait(0.2)
function notify(notif_type, msg, duration)
    NotifyLib:External_Notification(tostring(notif_type), tostring(msg), tonumber(duration))
end

notify = get_or_set("notify", notify)

local config_path = "Flames_Admin_Config.json"
local default_config = {
    Enrolled = "disabled",
    RainbowVehicle = "disabled",
    RainbowPhone = "disabled",
    AntiCarFling = "disabled",
    AntiFling = "disabled",
    AntiVoid = "disabled",
    NoClip = "disabled",
    NoSit = "disabled",
    AntiOutfitStealer = "disabled",
    JobSpammer = "disabled"
}

ReplicatedStorage = get_or_set("ReplicatedStorage", safe_wrap("ReplicatedStorage"))
Workspace = get_or_set("Workspace", safe_wrap("Workspace"))
Modules = get_or_set("Modules", ReplicatedStorage:WaitForChild("Modules"))
Core = get_or_set("Core", Modules:WaitForChild("Core"))
Game_Folder = get_or_set("Game_Folder", Modules:WaitForChild("Game"))

if executor_contains("LX63") then
    local targets = {
        "InvisibleMode",
        "CharacterBillboardGui",
        "PlotMarker",
        "Data",
        "Phone",
        "Privacy",
        "Messages",
        "CCTV",
        "Tween",
        "Seat",
        "Blur"
    }

    for _, target in ipairs(targets) do
        for _, obj in pairs(getgc(true)) do
            if typeof(obj) == "table" then
                local info
                for _, v in pairs(obj) do
                    if typeof(v) == "function" then
                        info = debug.getinfo(v)
                        break
                    end
                end
                if info and info.source and info.source:find(target) then
                    get_or_set(target, obj)
                    break
                end
            end
        end
    end
else
    InvisibleMode = get_or_set("InvisibleMode", require(Game_Folder:FindFirstChild("InvisibleMode")))
    CharacterBillboardGui = get_or_set("CharacterBillboardGui", require(Game_Folder:FindFirstChild("CharacterBillboardGui")))
    PlotMarker = get_or_set("PlotMarker", require(Game_Folder:FindFirstChild("PlotMarker")))
    Data = get_or_set("Data", require(Core:FindFirstChild("Data")))
    Phone_Module = get_or_set("Phone_Module", Game_Folder:FindFirstChild("Phone"))
    Phone = get_or_set("Phone", require(Game_Folder:FindFirstChild("Phone")))
    Privacy = get_or_set("Privacy", require(Core:FindFirstChild("Privacy")))
    AppModules = get_or_set("AppModules", Phone_Module:FindFirstChild("AppModules"))
    Messages = get_or_set("Messages", require(AppModules:FindFirstChild("Messages")))
    Network = get_or_set("Network", require(Core:FindFirstChild("Net")))
    CCTV = get_or_set("CCTV", require(Game_Folder:FindFirstChild("CCTV")))
    Tween = get_or_set("Tween", require(Core:FindFirstChild("Tween")))
    Seat = get_or_set("Seat", require(Game_Folder:FindFirstChild("Seat")))
    Blur = get_or_set("Blur", require(Core:FindFirstChild("Blur")))
    RateLimiter = get_or_set("RateLimiter", require(Core:FindFirstChild("RateLimiter")))
    UI = get_or_set("UI", require(Core:FindFirstChild("UI")))
end

function set_enrolled_state(state)
    local valid = (state == "enabled" or state == "disabled")
    if not valid then
        return 
    end

    if not isfile(config_path) then
        writefile(config_path, HttpService:JSONEncode(default_config))
    end

    local config = HttpService:JSONDecode(readfile(config_path))

    config.Enrolled = state
    writefile(config_path, HttpService:JSONEncode(config))
end
wait(0.1)
getgenv().set_enrolled_state = set_enrolled_state
wait(0.1)
function get_enrolled_state()
    if not isfile(config_path) then
        writefile(config_path, HttpService:JSONEncode(default_config))
    end

    local config = HttpService:JSONDecode(readfile(config_path))
    return config.Enrolled
end
wait(0.1)
getgenv().get_enrolled_state = get_enrolled_state

if not getgenv().FreePay_Originals then
    getgenv().FreePay_Originals = {}
end
local originals = getgenv().FreePay_Originals
local function freepay_func(state)
    local Data = getgenv().Data
    local notify = getgenv().notify
    local ReplicatedStorage = getgenv().ReplicatedStorage

    if not Data or not Data.initiate then
        return notify("Error", "Data module missing.", 5)
    end
    if not debug.getupvalue then
        return notify("Error", "Executor does not support getupvalue.", 5)
    end
    if not ReplicatedStorage then
        return notify("Error", "ReplicatedStorage missing.", 5)
    end

    if state == nil then
        state = not getgenv().Has_Free_LifePremium
    end

    if state then
        if getgenv().Has_Free_LifePremium then
            return notify("Error", "FreePay is already enabled.", 5)
        end

        for _, v in ipairs(ReplicatedStorage:GetDescendants()) do
            local val = v:GetAttribute("IsVerifiedOnly")
            if val ~= nil then
                originals[v] = val
                v:SetAttribute("IsVerifiedOnly", false)
            end
        end

        local update = debug.getupvalue(Data.initiate, 2)
        local _, original = Data.initiate("is_verified")
        originals["_is_verified"] = original
        update("is_verified", true)

        getgenv().Has_Free_LifePremium = true
        notify("Success", "FreePay is now enabled.", 5)
    else
        if not getgenv().Has_Free_LifePremium then
            return notify("Error", "FreePay is not enabled.", 5)
        end

        for obj, val in pairs(originals) do
            if obj ~= "_is_verified" and typeof(obj) == "Instance" then
                if obj.Parent and obj:GetAttribute("IsVerifiedOnly") ~= nil then
                    obj:SetAttribute("IsVerifiedOnly", val)
                end
            end
        end

        local update = debug.getupvalue(Data.initiate, 2)
        update("is_verified", originals["_is_verified"] or false)

        table.clear(originals)
        getgenv().Has_Free_LifePremium = false
        notify("Success", "FreePay is now disabled.", 5)
    end
end

if not getgenv().FreePayFuncToggle then
    getgenv().FreePayFuncToggle = freepay_func
end

getgenv().AntiFling_Tracked = getgenv().AntiFling_Tracked or setmetatable({}, { __mode = "k" })
getgenv().AntiFling_Signals = getgenv().AntiFling_Signals or setmetatable({}, { __mode = "k" })
getgenv().AntiFling_Enabled = getgenv().AntiFling_Enabled or false
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
        wait(0.1)
        getgenv().notify("Success", "Started RGB/Rainbow Phone.", 5)
        getgenv().RGB_Rainbow_Phone = true
        task.spawn(function()
            while getgenv().RGB_Rainbow_Phone == true do
            task.wait(0)
                for _, color in ipairs(colors) do
                    if getgenv().RGB_Rainbow_Phone ~= true then return end
                    task.wait(0)
                    change_phone_color(color)
                end
            end
        end)
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

if not getgenv().AntiFling_SafeSetCanCollide then
    getgenv().AntiFling_SafeSetCanCollide = function(part, value)
        if typeof(part) == "Instance" and part:IsA("BasePart") then
            pcall(function()
                if part.CanCollide ~= value then
                    part.CanCollide = value
                end
            end)
        end
    end
end

if not getgenv().AntiFling_Apply then
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
end

if not getgenv().AntiFling_ProtectCharacter then
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
end

if not getgenv().AntiFling_HookPlayer then
    getgenv().AntiFling_HookPlayer = function(plr)
        if plr == LocalPlayer then return end
        if plr.Character then
            getgenv().AntiFling_ProtectCharacter(plr.Character)
        end
        plr.CharacterAdded:Connect(getgenv().AntiFling_ProtectCharacter)
    end
end

if not getgenv().EnableAntiFling then
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
end

getgenv().Noclip_Enabled = getgenv().Noclip_Enabled or false
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

        getgenv().Noclip_Connection = getgenv().Noclip_Connection or RunService.Stepped:Connect(NoclipLoop)
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

if not getgenv().Toggleable_Noclip then
    getgenv().Toggleable_Noclip = ToggleNoclip
end

if not getgenv().DisableAntiFling then
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
end

if not getgenv().Toggle_AntiFling_Boolean_Func then
    getgenv().Toggle_AntiFling_Boolean_Func = function(toggled)
        if toggled == true then
            getgenv().EnableAntiFling()
        elseif toggled == false then
            getgenv().DisableAntiFling()
        else
            return getgenv().notify("Warning", "[Invalid arguments]: Expected true/false brocaroni and cheese.", 5)
        end
    end
end

function RGB_Vehicle(Boolean)
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
        getgenv().notify("Success", "[Enabled]: Rainbow Vehicle.", 5)
        getgenv().Rainbow_Vehicle = true
        task.spawn(function()
            while getgenv().Rainbow_Vehicle == true do
                task.wait(0)
                for _, color in ipairs(colors) do
                    task.wait(0)
                    if getgenv().Rainbow_Vehicle ~= true then return end
                    change_vehicle_color(color, get_vehicle())
                end
            end
        end)
    elseif Boolean == false then
        getgenv().Rainbow_Vehicle = false
        Boolean = false
        getgenv().notify("Success", "[Disabled]: Rainbow Vehicle.", 4)
    end
end

getgenv().AntiOutfitStealerConn = getgenv().AntiOutfitStealerConn or nil
local Old_Bio = getgenv().LocalPlayer:GetAttribute("bio") or "DEFAULT"
wait(0.2)
function anti_outfit_copier(toggle)
    if toggle == true then
        if getgenv().anti_outfit_stealer then
            return getgenv().notify("Error", "Anti Outfit Stealer is already enabled!", 5)
        end
        if getgenv().AntiFitStealerConn then
            return getgenv().notify("Error", "Anti Outfit Stealer is already enabled! [connection]", 5)
        end

        getgenv().notify("Success", "Anti Outfit Stealer is now active.", 5)
        getgenv().notify("Info", "NOTE: UNHIDE YOUR NAME AND do NOT change your Bio, this will not work otherwise (it'll auto-change back for you though incase you do)", 15)
        wait()
        local RunService = getgenv().RunService
        getgenv().AntiFitStealerConn = nil

        getgenv().ToggleAntiFit_Stealer = function(state)
            if not state then
                getgenv().anti_outfit_stealer = false

                if getgenv().AntiFitStealerConn then
                    getgenv().AntiFitStealerConn:Disconnect()
                    getgenv().AntiFitStealerConn = nil
                end

                local bio = getgenv().LocalPlayer:GetAttribute("bio")

                if bio and bio ~= "Flames Hub | Anti Stealer is: ON." then
                    getgenv().Send("bio", "Flames Hub | Anti Stealer is: ON.")
                    getgenv().notify("Success", "Bio changed, reverted change.", 2)
                end
                return 
            else
                getgenv().anti_outfit_stealer = true
            end

            getgenv().AntiFitStealerConn = getgenv().RunService.Heartbeat:Connect(function()
                task.wait(0.4)
                local bio = getgenv().LocalPlayer:GetAttribute("bio")

                if bio and bio ~= "Flames Hub | Anti Stealer is: ON." then
                getgenv().Send("bio", "Flames Hub | Anti Stealer is: ON.")
                getgenv().notify("Success", "Bio changed, reverted change.", 3)
                end
            end)
        end
        wait(0.1)
        getgenv().ToggleAntiFit_Stealer(true)
    elseif toggle == false then
        if not getgenv().anti_outfit_stealer then
            return getgenv().notify("Error", "Anti Outfit Copier is not enabled!", 5)
        end

        if getgenv().anti_outfit_stealer then
            getgenv().anti_outfit_stealer = false
        end
        if getgenv().AntiFitStealerConn then
            getgenv().AntiFitStealerConn:Disconnect()
            getgenv().AntiFitStealerConn = nil
        end
        getgenv().ToggleAntiFit_Stealer(false)
        getgenv().notify("Success", "Disabled Anti Outfit Stealer.", 5)
        getgenv().Send("bio", tostring(Old_Bio))
    else
        return 
    end
end

local is_enabled

local function find_seat_module()
    for _, obj in pairs(getgc(true)) do
        if typeof(obj) == "table" then
            for _, v in pairs(obj) do
                if typeof(v) == "function" then
                    local ok, info = pcall(debug.getinfo, v)
                    if ok and info and info.source and info.source:find("Seat", 1, true) then
                        getgenv().Seat = obj
                        return obj
                    end
                end
            end
        end
    end
end

wait(0.2)
function anti_sit_func(toggle)
    getgenv().Seat = require(getgenv().Game_Folder:FindFirstChild("Seat"))
    wait(0.1)
    if toggle == true then
        if getgenv().Not_Ever_Sitting then
            return getgenv().notify("Warning", "AntiSit is already enabled!", 5)
        end

        getgenv().notify("Success", "Anti-Sit is now enabled!", 5)
        show_notification("Success:", "Anti-Sit is now enabled!", "Normal")
        wait(0.2)
        getgenv().Not_Ever_Sitting = true

        task.spawn(function()
            while getgenv().Not_Ever_Sitting == true do
            task.wait()
                getgenv().Humanoid:SetStateEnabled(Enum.HumanoidStateType.Seated, false)
                getgenv().Seat.enabled.set(false)
            end
        end)
    elseif toggle == false then
        if not getgenv().Not_Ever_Sitting then
            return getgenv().notify("Warning", "AntiSit is not enabled!", 5)
        end

        getgenv().Not_Ever_Sitting = false
        wait(0.2)
        getgenv().Humanoid:SetStateEnabled(Enum.HumanoidStateType.Seated, true)
        getgenv().Seat.enabled.set(true)
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
            return getgenv().notify("Error", "Original FPDH didn't exist at runtime, try this command again!", 6)
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
    local plrsvehicle = get_vehicle()

    for _, obj in ipairs(folder:GetDescendants()) do
        if plrsvehicle and obj:IsDescendantOf(plrsvehicle) then
        elseif obj:IsA("BasePart") and obj.CanCollide then
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
            local plrsvehicle = get_vehicle()

            child.DescendantAdded:Connect(function(desc)
                if plrsvehicle and desc:IsDescendantOf(plrsvehicle) then
                    return
                end
                if desc:IsA("BasePart") then
                    desc.CanCollide = false
                end
            end)

            disableCollisionIn(child)
		end
	end)
	table.insert(getgenv().VehicleDestroyer_Connections, getgenv().vehiclesChildAddedConn)
end

if not getgenv().DisableVehicleDestroyer then
    getgenv().DisableVehicleDestroyer = function()
        if not getgenv().VehicleDestroyer_Enabled then
            return getgenv().notify("Warning", "Anti Vehicle Fling is not enabled!", 5)
        end
        wait(0.1)
        getgenv().VehicleDestroyer_Enabled = false
        clearConnections()
    end
end

function job_spammer(toggle)
    if toggle == true then
        if getgenv().Every_Job then
            return getgenv().notify("Warning", "Job spammer is already enabled! disable it first.", 5)
        end
        wait()
        getgenv().Every_Job = true
        task.spawn(function()
            while getgenv().Every_Job == true do
            task.wait(0)
                getgenv().Send("job", "Police")
                task.wait(0)
                getgenv().Send("job", "Firefighter")
                task.wait(0)
                getgenv().Send("job", "Baker")
                task.wait(0)
                getgenv().Send("job", "Pizza Worker")
                task.wait(0)
                getgenv().Send("job", "Barista")
                task.wait(0)
                getgenv().Send("job", "Doctor")
                task.wait(0)
            end
        end)
    elseif toggle == false then
        if not getgenv().Every_Job then
            return getgenv().notify("Warning", "Job spammer is not enabled! enable it first.", 5)
        end

        getgenv().Every_Job = false
    else
        return 
    end
end

if not getgenv().anti_car_fling then
    getgenv().VehicleDestroyer_Enabled = getgenv().VehicleDestroyer_Enabled or false
    getgenv().VehicleDestroyer_Connections = getgenv().VehicleDestroyer_Connections or {}
    getgenv().vehicle_parts_cache = getgenv().vehicle_parts_cache or {}

    local function safe_disconnect(conn)
        if typeof(conn) == "RBXScriptConnection" then
            pcall(function() conn:Disconnect() end)
        end
    end

    local function clearConnections()
        for _, conn in ipairs(getgenv().VehicleDestroyer_Connections) do
            safe_disconnect(conn)
        end
        table.clear(getgenv().VehicleDestroyer_Connections)
        table.clear(getgenv().vehicle_parts_cache)
    end

    local function is_in_vehicle(obj, vehicle)
        return vehicle and obj and obj:IsDescendantOf(vehicle)
    end

    local function processPart(part)
        if not part:IsA("BasePart") then return end
        if getgenv().vehicle_parts_cache[part] then return end

        local my_vehicle = get_vehicle and get_vehicle()
        if my_vehicle and is_in_vehicle(part, my_vehicle) then return end

        part.CanCollide = false
        getgenv().vehicle_parts_cache[part] = true
    end

    local function processModel(model)
        for _, inst in ipairs(model:GetDescendants()) do
            if inst:IsA("BasePart") then
                processPart(inst)
            end
        end

        local conn = model.DescendantAdded:Connect(function(desc)
            if not getgenv().VehicleDestroyer_Enabled then return end
            processPart(desc)
        end)

        table.insert(getgenv().VehicleDestroyer_Connections, conn)
    end

    local function setupVehiclesFolder(folder)
        for _, inst in ipairs(folder:GetChildren()) do
            if inst:IsA("Model") then
                processModel(inst)
            elseif inst:IsA("BasePart") then
                processPart(inst)
            end
        end

        local addConn = folder.ChildAdded:Connect(function(child)
            if not getgenv().VehicleDestroyer_Enabled then return end
            if child:IsA("Model") then
                processModel(child)
            elseif child:IsA("BasePart") then
                processPart(child)
            end
        end)

        table.insert(getgenv().VehicleDestroyer_Connections, addConn)

        if getgenv().notify then
            getgenv().notify("Success", "Anti Vehicle Fling enabled.", 5)
        end
    end
    wait(0.2)
    function anti_car_fling(state)
        if state == true then
            if getgenv().VehicleDestroyer_Enabled then
                if getgenv().notify then
                    return getgenv().notify("Warning", "Anti Vehicle Fling already enabled.", 5)
                end
                return
            end

            getgenv().VehicleDestroyer_Enabled = true
            clearConnections()

            local vehiclesFolder = Workspace:FindFirstChild("Vehicles")
            if vehiclesFolder then
                setupVehiclesFolder(vehiclesFolder)
            end

            local folderConn = Workspace.ChildAdded:Connect(function(child)
                if not getgenv().VehicleDestroyer_Enabled then return end
                if child.Name == "Vehicles" and child:IsA("Folder") then
                    setupVehiclesFolder(child)
                end
            end)

            table.insert(getgenv().VehicleDestroyer_Connections, folderConn)
        elseif state == false then
            if not getgenv().VehicleDestroyer_Enabled then
                if getgenv().notify then
                    return getgenv().notify("Warning", "Anti Vehicle Fling not enabled.", 5)
                end
                return
            end

            getgenv().VehicleDestroyer_Enabled = false
            clearConnections()

            if getgenv().notify then
                getgenv().notify("Success", "Anti Vehicle Fling disabled.", 5)
            end
        end
    end
end

if not isfile(config_path) then
   writefile(config_path, HttpService:JSONEncode(default_config))
end

local config = HttpService:JSONDecode(readfile(config_path))
local function save_config()
   writefile(config_path, HttpService:JSONEncode(config))
end

if config.Enrolled ~= "enabled" then
    return 
end

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "FlamesAdminGUI"
ScreenGui.Parent = parent_gui
ScreenGui.Enabled = false
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
Title.Text = "🔥 Flames Admin | Config 🔥"
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
   ScreenGui.Enabled = false
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
    elseif name == "JobSpammer" then
        if state == "enabled" then
            job_spammer(true)
        else
            job_spammer(false)
        end
    elseif name == "FreePremium" then
        if state == "enabled" then
            freepay_func(true)
        else
            freepay_func(false)
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

local toggles = {"RainbowVehicle", "RainbowPhone", "AntiCarFling", "AntiFling", "AntiVoid", "NoClip", "NoSit", "AntiOutfitStealer", "JobSpammer", "FreePremium"}

local function update_frame_size()
   local total_height = 50 + (#toggles * 40) + 10
   Frame.Size = UDim2.new(0, 300, 0, total_height)
end

for i, t in ipairs(toggles) do
   create_toggle(t, i)
end

update_frame_size()
