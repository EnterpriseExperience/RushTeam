if not game:IsLoaded() then game.Loaded:Wait() end

getgenv().Game = game

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

getgenv().FlamesLibrary = getgenv().FlamesLibrary or {}
getgenv().FlamesLibrary._connections = getgenv().FlamesLibrary._connections or {}
getgenv().FlamesLibrary.connect = function(name, connection)
	getgenv().FlamesLibrary._connections[name] = getgenv().FlamesLibrary._connections[name] or {}
	table.insert(getgenv().FlamesLibrary._connections[name], connection)
	return connection
end

getgenv().FlamesLibrary.disconnect = function(name)
	local list = getgenv().FlamesLibrary._connections[name]

	if list then
		for _, item in ipairs(list) do
			if typeof(item) == "RBXScriptConnection" then
				item:Disconnect()
			elseif type(item) == "thread" then
				pcall(task.cancel, item)
			end
		end
		getgenv().FlamesLibrary._connections[name] = nil
	end
end

getgenv().FlamesLibrary.spawn = function(name, mode, func, ...)
	if not name or not mode or type(func) ~= "function" then
		return 
	end

	if getgenv().FlamesLibrary._connections[name] then
		getgenv().FlamesLibrary.disconnect(name)
	end

	getgenv().FlamesLibrary._connections[name] = {}

	local thread

	if mode == "spawn" then
		thread = task.spawn(func, ...)
	elseif mode == "defer" then
		thread = task.defer(func, ...)
	elseif mode == "delay" then
		local delay_time = ...
		thread = task.delay(delay_time, func)
	elseif mode == "wrap" then
		thread = coroutine.create(func)
		coroutine.resume(thread, ...)
	else
        -- don't really need a warning --
		-- warn("Invalid spawn mode / argument: "..tostring(mode))
		return
	end

	table.insert(getgenv().FlamesLibrary._connections[name], thread)
	return thread
end

getgenv().FlamesLibrary.is_thread_alive = function(input)
    local lib = getgenv().FlamesLibrary

    if type(input) == "thread" then
        local ok, status = pcall(coroutine.status, input)
        if not ok then
            return false
        end
        return status ~= "dead"
    end

    if type(input) == "string" then
        local list = lib._connections[input]
        if not list then
            return false
        end

        for _, item in ipairs(list) do
            if type(item) == "thread" then
                local ok, status = pcall(coroutine.status, item)
                if ok and status ~= "dead" then
                    return true
                end
            end
        end

        return false
    end

    return false
end

getgenv().FlamesLibrary.is_alive = function(name)
    local lib = getgenv().FlamesLibrary
    local list = lib._connections[name]

    if not list then
        return false
    end

    for _, item in ipairs(list) do
        if typeof(item) == "RBXScriptConnection" then
            if item.Connected then
                return true
            end
        elseif type(item) == "thread" then
            if lib.is_thread_alive(item) then
                return true
            end
        end
    end

    return false
end

-- [[ NEW! always will return a callable function for safe functionality at all times. ]] --
getgenv().FlamesLibrary.safe_func = function(...)
    for i = 1, select("#", ...) do
        local f = select(i, ...)
        local ok, t = pcall(typeof, f)
        if ok and t == "function" then
            return f
        end
    end
    return function() end
end

-- [[ safer wait functionality. ]] --
getgenv().FlamesLibrary.wait = function(t)
    if not t or t <= 0 then
        safe_wrapper("RunService").Heartbeat:Wait()
        return
    end
    local ok = pcall(task.wait, t)
    if not ok then
        safe_wrapper("RunService").Heartbeat:Wait()
    end
end

getgenv().FlamesLibrary.cleanup_all = function()
	for name in pairs(getgenv().FlamesLibrary._connections) do
		getgenv().FlamesLibrary.disconnect(name)
	end
end

local lib = getgenv().FlamesLibrary
local fw = lib.wait
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

if not getgenv().FreePay_Originals then getgenv().FreePay_Originals = {} end
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

        pcall(function()
            local update = debug.getupvalue(Data.initiate, 2)
            local _, original = Data.initiate("is_verified")
            originals["_is_verified"] = original
            update("is_verified", true)
        end)

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

getgenv().set_enrolled_state("enabled")

if not getgenv().FreePayFuncToggle then
    getgenv().FreePayFuncToggle = freepay_func
end

function change_vehicle_color(Color, Vehicle)
   getgenv().Send("vehicle_color", Color, Vehicle)
end

function change_phone_color(New_Color)
   getgenv().Send("phone_color", New_Color)
end
task.wait(0.2)
getgenv().RGB_Phone = function(Boolean)
    local key = "rgb_phone_loop"
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
            return notify("Warning", "Rainbow Phone is already enabled.", 5)
        end

        getgenv().RGB_Rainbow_Phone = true
        getgenv().notify("Success", "Started RGB/Rainbow Phone.", 5)
        lib.spawn(key, "spawn", function()
            while getgenv().RGB_Rainbow_Phone == true do
                for _, color in ipairs(colors) do
                    if getgenv().RGB_Rainbow_Phone ~= true then
                        lib.disconnect(key)
                        return
                    end
                    change_phone_color(color)
                    fw(0)
                end
            end
            lib.disconnect(key)
        end)
    elseif Boolean == false then
        if not getgenv().RGB_Rainbow_Phone then
            return notify("Warning", "Rainbow Phone is not enabled.", 5)
        end

        getgenv().RGB_Rainbow_Phone = false
        lib.disconnect(key)
        notify("Success", "Stopped RGB/Rainbow Phone.", 5)
        fw(0.1)
        change_phone_color(Color3.fromRGB(255, 255, 255))
    end
end

local NOCLIP_KEY = "noclip_loop"
getgenv().Noclip_Enabled = getgenv().Noclip_Enabled or false
local function ToggleNoclip(toggle)
    if toggle == true then
        if getgenv().Noclip_Enabled then
            return notify("Error", "Noclip already enabled!", 5)
        end

        getgenv().Noclip_Enabled = true
        notify("Success", "Noclip has been enabled.", 5)

        lib.connect(NOCLIP_KEY,
            RunService.Stepped:Connect(function()
                if not getgenv().Noclip_Enabled then return end
                local char = getgenv().Character
                if not char then return end
                for _, part in ipairs(char:GetDescendants()) do
                    if part:IsA("BasePart") and part.CanCollide then
                        part.CanCollide = false
                    end
                end
            end)
        )
    elseif toggle == false then
        if not getgenv().Noclip_Enabled then
            return notify("Error", "Noclip not enabled!", 5)
        end

        getgenv().Noclip_Enabled = false
        lib.disconnect(NOCLIP_KEY)

        local char = getgenv().Character
        if char then
            for _, part in ipairs(char:GetDescendants()) do
                if part and part:IsA("BasePart") then
                    part.CanCollide = true
                end
            end
        end

        notify("Success", "Noclip has been disabled.", 5)
    else
        return notify("Error", "Invalid arg, expected true/false", 5)
    end
end

if not getgenv().Toggleable_Noclip then getgenv().Toggleable_Noclip = ToggleNoclip end

function RGB_Vehicle(Boolean)
    local key = "rgb_vehicle_loop"
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
        if getgenv().Rainbow_Vehicle then
            return notify("Warning", "Rainbow Vehicle is already enabled.", 5)
        end

        getgenv().Rainbow_Vehicle = true
        getgenv().notify("Success", "[Enabled]: Rainbow Vehicle.", 5)
        lib.spawn(key, "spawn", function()
            while getgenv().Rainbow_Vehicle == true do
                for _, color in ipairs(colors) do
                    if getgenv().Rainbow_Vehicle ~= true then
                        lib.disconnect(key)
                        return
                    end
                    change_vehicle_color(color, get_vehicle())
                    fw(0)
                end
            end
            lib.disconnect(key)
        end)
    elseif Boolean == false then
        if not getgenv().Rainbow_Vehicle then
            return notify("Warning", "Rainbow Vehicle is not enabled.", 5)
        end

        getgenv().Rainbow_Vehicle = false
        lib.disconnect(key)
        notify("Success", "[Disabled]: Rainbow Vehicle.", 4)
    end
end

local View_Outfit_State_Toggle = getgenv().LocalPlayer:GetAttribute("hide_view_outfit") or true
fw(0.2)
local function push_stealer_state(state)
    getgenv().ws_main_reactor_connector:Send(HttpService:JSONEncode{
        type = "anti_stealer_state",
        secret = "flames_hub_2026",
        user = tostring(getgenv().LocalPlayer.Name),
        state = state
    })
end

getgenv().anti_outfit_copier = function(toggle)
    if toggle == true then
        if getgenv().anti_outfit_stealer then
            return notify("Error", "Anti Outfit Stealer is already enabled!", 5)
        end
        if getgenv().AntiFitStealerConn then
            return notify("Error", "Anti Outfit Stealer is already enabled! [connection]", 5)
        end

        notify("Success", "Flames Hub | Anti Outfit Stealer is now active.", 7)

        local lib = getgenv().FlamesLibrary
        getgenv().AntiFitStealerConn = nil
        getgenv().ToggleAntiFit_Stealer = function(state)
            if not state then
                getgenv().anti_outfit_stealer = false
                if getgenv().AntiFitStealerConn then
                    getgenv().AntiFitStealerConn:Disconnect()
                    getgenv().AntiFitStealerConn = nil
                end

                local hide_outfit_toggle = getgenv().LocalPlayer:GetAttribute("hide_view_outfit")
                if hide_outfit_toggle and hide_outfit_toggle == false then
                    getgenv().Send("hide_view_outfit", true)
                    notify("Success", "hide_view_outfit setting changed, reverted change (keep it on).", 3)
                end

                push_stealer_state(false)
                return
            else
                getgenv().anti_outfit_stealer = true
                push_stealer_state(true)
            end

            local last_check = 0
            getgenv().AntiFitStealerConn = getgenv().RunService.Heartbeat:Connect(function()
               local now = tick()
               if now - last_check < 0.4 then return end
               last_check = now
               
               local hide_outfit_toggle = getgenv().LocalPlayer:GetAttribute("hide_view_outfit")
               if hide_outfit_toggle and hide_outfit_toggle == false then
                  getgenv().Send("hide_view_outfit", true)
                  notify("Success", "hide_view_outfit setting changed, reverted change (keep it on).", 3)
               end
            end)
        end

        fw(0.1)
        getgenv().ToggleAntiFit_Stealer(true)
    elseif toggle == false then
        if not getgenv().anti_outfit_stealer then
            return notify("Error", "Anti Outfit Copier is not enabled!", 5)
        end

        getgenv().anti_outfit_stealer = false
        if getgenv().AntiFitStealerConn then
            getgenv().AntiFitStealerConn:Disconnect()
            getgenv().AntiFitStealerConn = nil
        end

        getgenv().ToggleAntiFit_Stealer(false)
        notify("Success", "Disabled Anti Outfit Stealer.", 5)
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
fw(0.2)
function anti_sit_func(toggle)
    local lib = getgenv().FlamesLibrary
    local key = "anti_sit_loop"

    getgenv().Seat = require(getgenv().Game_Folder:FindFirstChild("Seat"))

    if toggle == true then
        if getgenv().Not_Ever_Sitting then
            return notify("Warning", "AntiSit is already enabled!", 5)
        end

        getgenv().Not_Ever_Sitting = true
        getgenv().notify("Success", "Anti-Sit is now enabled!", 5)
        show_notification("Success:", "Anti-Sit is now enabled!", "Normal")
        lib.spawn(key, "spawn", function()
            while getgenv().Not_Ever_Sitting == true do
                getgenv().Seat.enabled.set(false)
                getgenv().Humanoid:SetStateEnabled(Enum.HumanoidStateType.Seated, false)
                fw(0)
            end
            lib.disconnect(key)
        end)
    elseif toggle == false then
        if not getgenv().Not_Ever_Sitting then
            return notify("Warning", "AntiSit is not enabled!", 5)
        end

        getgenv().Not_Ever_Sitting = false
        lib.disconnect(key)
        fw(0.2)
        getgenv().Humanoid:SetStateEnabled(Enum.HumanoidStateType.Seated, true)
        getgenv().Seat.enabled.set(true)
        notify("Success", "Sitting is now enabled!", 5)
        Phone.show_notification("Success:", "Sitting is now enabled!", "Normal")
    end
end

function anti_void(toggle)
    if toggle == true then
        if getgenv().Anti_Void_Enabled_Bool then
            return notify("Warning", "Anti-Void is already enabled!", 5)
        end
        if not getgenv().originalFPDH then
            getgenv().originalFPDH = getgenv().Workspace.FallenPartsDestroyHeight
        end

        getgenv().Workspace.FallenPartsDestroyHeight = -9e9
        getgenv().Anti_Void_Enabled_Bool = true
        notify("Success", "Enabled anti-void.", 5)
    elseif toggle == false then
        if not getgenv().Anti_Void_Enabled_Bool then
            return notify("Warning", "Anti-Void has not been enabled!", 5)
        end
        if not getgenv().originalFPDH then
            getgenv().originalFPDH = -500
            return notify("Error", "Original FPDH didn't exist at runtime, try this command again!", 6)
        end

        getgenv().Workspace.FallenPartsDestroyHeight = getgenv().originalFPDH
        getgenv().Anti_Void_Enabled_Bool = false
        notify("Success", "Disabled anti-void.", 5)
    end
end

local VEHICLE_KEY = "vehicle_destroyer"
getgenv().VehicleDestroyer_Enabled = getgenv().VehicleDestroyer_Enabled or false
local function disableCollisionIn(folder)
    local plrsvehicle = get_vehicle()
    for _, obj in ipairs(folder:GetDescendants()) do
        if obj:IsA("BasePart") and obj.CanCollide then
            if not plrsvehicle or not obj:IsDescendantOf(plrsvehicle) then
                obj.CanCollide = false
            end
        end
    end
end

local function setupFolder(folder)
    disableCollisionIn(folder)
    notify("Success", "Anti Vehicle Fling has been enabled.", 5)

    lib.connect(VEHICLE_KEY,
        folder.ChildAdded:Connect(function(child)
            if not getgenv().VehicleDestroyer_Enabled then return end

            if child:IsA("BasePart") then
                child.CanCollide = false
            elseif child:IsA("Model") then
                local plrsvehicle = get_vehicle()

                lib.connect(VEHICLE_KEY,
                    child.DescendantAdded:Connect(function(desc)
                        if desc:IsA("BasePart") then
                            if not plrsvehicle or not desc:IsDescendantOf(plrsvehicle) then
                                desc.CanCollide = false
                            end
                        end
                    end)
                )

                disableCollisionIn(child)
            end
        end)
    )
end

if not getgenv().DisableVehicleDestroyer then
    getgenv().DisableVehicleDestroyer = function()
        if not getgenv().VehicleDestroyer_Enabled then
            return notify("Warning", "Anti Vehicle Fling is not enabled!", 5)
        end
        fw(0.1)
        getgenv().VehicleDestroyer_Enabled = false
        lib.disconnect(VEHICLE_KEY)
        notify("Success", "Anti Vehicle Fling has been disabled.", 5)
    end
end

getgenv().job_spammer = getgenv().job_spammer or function(toggle)
    local lib = getgenv().FlamesLibrary
    local key = "job_spammer_loop"

    if toggle == true then
        if getgenv().Every_Job then
            return notify("Warning", "Job spammer is already enabled! disable it first.", 5)
        end

        getgenv().Every_Job = true
        notify("Success", "Job Spammer has been enabled.", 5)

        lib.spawn(key, "spawn", function()
            while getgenv().Every_Job == true do
            fw(0)
                getgenv().Send("job", "Police")
                fw(0)
                getgenv().Send("job", "Firefighter")
                fw(0)
                getgenv().Send("job", "Baker")
                fw(0)
                getgenv().Send("job", "Pizza Worker")
                fw(0)
                getgenv().Send("job", "Barista")
                fw(0)
                getgenv().Send("job", "Doctor")
                fw(0)
            end
            lib.disconnect(key)
        end)
    elseif toggle == false then
        if not getgenv().Every_Job then
            return notify("Warning", "Job spammer is not enabled! enable it first.", 5)
        end

        getgenv().Every_Job = false
        lib.disconnect(key)
        notify("Success", "Job Spammer has been disabled.", 5)
    end
end

if not getgenv().anti_car_fling then
    local VEHICLE_KEY = "anti_car_fling"
    local FOLDER_KEY = "anti_car_fling_folder"
    getgenv().VehicleDestroyer_Enabled = getgenv().VehicleDestroyer_Enabled or false
    getgenv().vehicle_parts_cache = getgenv().vehicle_parts_cache or {}
    local function is_in_vehicle(obj, vehicle) return vehicle and obj and obj:IsDescendantOf(vehicle) end
    local function processPart(part)
        if not part:IsA("BasePart") then return end
        if getgenv().vehicle_parts_cache[part] then return end

        local my_vehicle = get_vehicle and get_vehicle()
        if my_vehicle and is_in_vehicle(part, my_vehicle) then return end

        pcall(function()
            part.CanCollide = false
            getgenv().vehicle_parts_cache[part] = true
        end)
    end

    local function processModel(model)
        for _, inst in ipairs(model:GetDescendants()) do
            processPart(inst)
        end

        local model_key = VEHICLE_KEY .. "_model_" .. tostring(model)
        lib.connect(model_key,
            model.DescendantAdded:Connect(function(desc)
                if not getgenv().VehicleDestroyer_Enabled then return end
                processPart(desc)
            end)
        )

        lib.connect(model_key,
            model.AncestryChanged:Connect(function(_, parent)
                if not parent then
                    lib.disconnect(model_key)
                end
            end)
        )
    end

    local function setupVehiclesFolder(folder)
        for _, inst in ipairs(folder:GetChildren()) do
            if inst:IsA("Model") then
                processModel(inst)
            elseif inst:IsA("BasePart") then
                processPart(inst)
            end
        end

        lib.connect(VEHICLE_KEY,
            folder.ChildAdded:Connect(function(child)
                if not getgenv().VehicleDestroyer_Enabled then return end
                if child:IsA("Model") then
                    processModel(child)
                elseif child:IsA("BasePart") then
                    processPart(child)
                end
            end)
        )

        notify("Success", "Anti Vehicle Fling enabled.", 5)
    end

    function anti_car_fling(state)
        if state == true then
            if getgenv().VehicleDestroyer_Enabled then
                return notify("Warning", "Anti Vehicle Fling already enabled.", 5)
            end

            getgenv().VehicleDestroyer_Enabled = true
            table.clear(getgenv().vehicle_parts_cache)

            local vehiclesFolder = Workspace:FindFirstChild("Vehicles")
            if vehiclesFolder then
                setupVehiclesFolder(vehiclesFolder)
            end

            lib.connect(FOLDER_KEY,
                Workspace.ChildAdded:Connect(function(child)
                    if not getgenv().VehicleDestroyer_Enabled then return end
                    if child.Name == "Vehicles" and child:IsA("Folder") then
                        setupVehiclesFolder(child)
                    end
                end)
            )
        elseif state == false then
            if not getgenv().VehicleDestroyer_Enabled then
                return notify("Warning", "Anti Vehicle Fling not enabled.", 5)
            end

            getgenv().VehicleDestroyer_Enabled = false
            table.clear(getgenv().vehicle_parts_cache)
            lib.disconnect(VEHICLE_KEY)
            lib.disconnect(FOLDER_KEY)
            notify("Success", "Anti Vehicle Fling disabled.", 5)
        end
    end
end

if not isfile(config_path) then
   writefile(config_path, HttpService:JSONEncode(default_config))
end

local config = HttpService:JSONDecode(readfile(config_path))
local function save_config() writefile(config_path, HttpService:JSONEncode(config)) end
if config.Enrolled ~= "enabled" then return  end
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "FlamesAdminGUI"
ScreenGui.Parent = parent_gui
ScreenGui.Enabled = false
ScreenGui.ResetOnSpawn = false

local Frame = Instance.new("Frame")
Frame.Size = UDim2.new(0, 300, 0, 400)
Frame.Position = UDim2.new(0.5, -150, 0.5, -200)
Frame.BackgroundColor3 = Color3.fromRGB(200, 0, 0)
Frame.BorderSizePixel = 0
Frame.Parent = ScreenGui
Frame.Active = true
Frame.Draggable = true
Instance.new("UICorner", Frame).CornerRadius = UDim.new(0, 12)

local Title = Instance.new("TextLabel", Frame)
Title.Size = UDim2.new(0.850000024, 0, 0, 45)
Title.Position = UDim2.new(0, 0, 0, 0)
Title.BackgroundTransparency = 1
Title.Text = "✅ Flames Admin | Config 👑"
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
    if config[name] == "enabled" then handle_toggle(name, "enabled") end

    task.defer(function()
        local Button = Instance.new("TextButton", Frame)
        Button.Size = UDim2.new(1, -20, 0, 35)
        Button.Position = UDim2.new(0, 10, 0, 50 + (order - 1) * 40)
        Button.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
        Button.TextColor3 = Color3.fromRGB(255, 255, 255)
        Button.Font = Enum.Font.Gotham
        Button.TextScaled = true
        Button.Text = name .. ": " .. (config[name] == "enabled" and "ON" or "OFF")
        Instance.new("UICorner", Button).CornerRadius = UDim.new(0, 8)
        while not Button do fw() end
        Button.MouseButton1Click:Connect(function()
            config[name] = (config[name] == "enabled") and "disabled" or "enabled"
            Button.Text = name .. ": " .. (config[name] == "enabled" and "ON" or "OFF")
            save_config()
            handle_toggle(name, config[name])
        end)
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
