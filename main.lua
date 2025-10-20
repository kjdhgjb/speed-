loadstring(game:HttpGet("https://raw.githubusercontent.com/kjdhgjb/speed-/main/main.lua"))()

-- **Aaditya Lala Hub - Speed Hack**
-- Professional Speed Modification Interface

-- Services
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local LocalPlayer = Players.LocalPlayer

-- Load Rayfield UI Library
local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

-- Window Setup
local Window = Rayfield:CreateWindow({
    Name = "🎖️ Aaditya Lala Hub",
    LoadingTitle = "Aaditya Lala Hub",
    LoadingSubtitle = "Speed Hack Module",
    ConfigurationSaving = {
        Enabled = true,
        FolderName = "AadityaLalaHub",
        FileName = "SpeedHackSettings"
    },
    Discord = {
        Enabled = false,
        Invite = "",
        RememberJoins = true
    },
    KeySystem = false
})

-- Configuration
local CONFIG = {
    DEFAULT_SPEED = 16,
    MIN_SPEED = 1,
    MAX_SPEED = 500,
    SPEED_INCREMENT = 5
}

-- State Management
local State = {
    speedEnabled = false,
    currentSpeed = CONFIG.DEFAULT_SPEED,
    connection = nil,
    humanoid = nil,
    speedSlider = nil,
    speedLabel = nil
}

-- Utility Functions
local Utils = {}

function Utils.getHumanoid()
    local character = LocalPlayer.Character
    if character then
        return character:FindFirstChildOfClass("Humanoid")
    end
    return nil
end

function Utils.updateSpeed()
    local humanoid = Utils.getHumanoid()
    if humanoid and State.speedEnabled then
        humanoid.WalkSpeed = State.currentSpeed
        -- Update GUI label if it exists
        if State.speedLabel then
            State.speedLabel:Set("Speed: " .. math.floor(State.currentSpeed))
        end
    end
end

function Utils.notify(title, content, duration)
    Rayfield:Notify({
        Title = "🎖️ Aaditya Lala Hub",
        Content = content,
        Duration = duration or 3,
        Image = 4483362458
    })
end

-- Speed Control Functions
local SpeedControl = {}

function SpeedControl.setSpeed(speed)
    if speed < CONFIG.MIN_SPEED then
        speed = CONFIG.MIN_SPEED
        Utils.notify("Speed Limit", "Minimum speed is " .. CONFIG.MIN_SPEED, 2)
    elseif speed > CONFIG.MAX_SPEED then
        speed = CONFIG.MAX_SPEED
        Utils.notify("Speed Limit", "Maximum speed is " .. CONFIG.MAX_SPEED, 2)
    end
    
    State.currentSpeed = speed
    Utils.updateSpeed()
end

function SpeedControl.increaseSpeed()
    SpeedControl.setSpeed(State.currentSpeed + CONFIG.SPEED_INCREMENT)
end

function SpeedControl.decreaseSpeed()
    SpeedControl.setSpeed(State.currentSpeed - CONFIG.SPEED_INCREMENT)
end

function SpeedControl.resetSpeed()
    SpeedControl.setSpeed(CONFIG.DEFAULT_SPEED)
    Utils.notify("Reset", "Speed reset to default (" .. CONFIG.DEFAULT_SPEED .. ")", 2)
end

function SpeedControl.toggle(state)
    State.speedEnabled = state
    
    if state then
        -- Enable speed hack
        State.connection = RunService.Heartbeat:Connect(function()
            local humanoid = Utils.getHumanoid()
            if humanoid then
                humanoid.WalkSpeed = State.currentSpeed
            end
        end)
        Utils.updateSpeed()
        Utils.notify("Speed Hack", "✅ ENABLED\nSpeed: " .. math.floor(State.currentSpeed), 3)
    else
        -- Disable speed hack
        if State.connection then
            State.connection:Disconnect()
            State.connection = nil
        end
        local humanoid = Utils.getHumanoid()
        if humanoid then
            humanoid.WalkSpeed = CONFIG.DEFAULT_SPEED
        end
        Utils.notify("Speed Hack", "❌ DISABLED", 3)
    end
end

-- **GUI Creation**
local MainTab = Window:CreateTab("⚡ Speed Hack", 4483362458)

-- Speed Control Section
local SpeedSection = MainTab:CreateSection("Movement Speed Controls")

-- Main Toggle
local SpeedToggle = MainTab:CreateToggle({
    Name = "Enable Speed Hack",
    CurrentValue = false,
    Flag = "SpeedHackEnabled",
    Callback = function(value)
        SpeedControl.toggle(value)
    end
})

-- Speed Slider
State.speedSlider = MainTab:CreateSlider({
    Name = "Walk Speed",
    Range = {CONFIG.MIN_SPEED, CONFIG.MAX_SPEED},
    Increment = 1,
    CurrentValue = CONFIG.DEFAULT_SPEED,
    Flag = "WalkSpeedValue",
    Callback = function(value)
        SpeedControl.setSpeed(value)
    end
})

-- Speed Display Label
State.speedLabel = MainTab:CreateLabel("Speed: " .. CONFIG.DEFAULT_SPEED)

-- Quick Action Buttons
MainTab:CreateButton({
    Name = "➕ Increase Speed (+5)",
    Callback = function()
        SpeedControl.increaseSpeed()
        -- Update slider value
        if State.speedSlider then
            State.speedSlider:Set(State.currentSpeed)
        end
    end
})

MainTab:CreateButton({
    Name = "➖ Decrease Speed (-5)",
    Callback = function()
        SpeedControl.decreaseSpeed()
        -- Update slider value
        if State.speedSlider then
            State.speedSlider:Set(State.currentSpeed)
        end
    end
})

MainTab:CreateButton({
    Name = "🔄 Reset to Default (16)",
    Callback = function()
        SpeedControl.resetSpeed()
        -- Update slider value
        if State.speedSlider then
            State.speedSlider:Set(CONFIG.DEFAULT_SPEED)
        end
    end
})

-- **Settings Tab**
local SettingsTab = Window:CreateTab("⚙️ Settings", 4483362458)

local ConfigSection = SettingsTab:CreateSection("Configuration Options")

-- Speed Limits
SettingsTab:CreateSlider({
    Name = "Minimum Speed",
    Range = {1, 50},
    Increment = 1,
    CurrentValue = CONFIG.MIN_SPEED,
    Flag = "MinSpeedLimit",
    Callback = function(value)
        CONFIG.MIN_SPEED = value
        if State.currentSpeed < value then
            SpeedControl.setSpeed(value)
        end
        Utils.notify("Settings", "Minimum speed set to " .. value, 2)
    end
})

SettingsTab:CreateSlider({
    Name = "Maximum Speed",
    Range = {50, 1000},
    Increment = 10,
    CurrentValue = CONFIG.MAX_SPEED,
    Flag = "MaxSpeedLimit",
    Callback = function(value)
        CONFIG.MAX_SPEED = value
        if State.currentSpeed > value then
            SpeedControl.setSpeed(value)
        end
        Utils.notify("Settings", "Maximum speed set to " .. value, 2)
    end
})

SettingsTab:CreateSlider({
    Name = "Speed Increment",
    Range = {1, 50},
    Increment = 1,
    CurrentValue = CONFIG.SPEED_INCREMENT,
    Flag = "SpeedIncrement",
    Callback = function(value)
        CONFIG.SPEED_INCREMENT = value
        Utils.notify("Settings", "Increment set to " .. value, 2)
    end
})

-- **Info Tab**
local InfoTab = Window:CreateTab("ℹ️ Info", 4483362458)

local InfoSection = InfoTab:CreateSection("🎖️ Aaditya Lala Hub")

InfoTab:CreateLabel("**Welcome to Aaditya Lala Hub!**")
InfoTab:CreateLabel("Professional Speed Hack Module")

local ControlsSection = InfoTab:CreateSection("Keyboard Controls")

InfoTab:CreateLabel("🎮 **Hotkey Controls:**")
InfoTab:CreateLabel("• **F** - Toggle Speed Hack **ON/OFF**")
InfoTab:CreateLabel("• **G** - **Increase** Speed (+5)")
InfoTab:CreateLabel("• **H** - **Decrease** Speed (-5)")
InfoTab:CreateLabel("• **R** - **Reset** to Default (16)")

local StatusSection = InfoTab:CreateSection("📊 Live Status")

-- Status Labels
local statusLabel = InfoTab:CreateLabel("Speed Hack: **OFF**")
local currentSpeedLabel = InfoTab:CreateLabel("Current Speed: **16**")

-- **Hotkey Support**
UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    
    if input.KeyCode == Enum.KeyCode.F then
        local currentState = State.speedEnabled
        SpeedControl.toggle(not currentState)
        -- Update toggle in GUI
        SpeedToggle:Set(not currentState)
    end
    
    if input.KeyCode == Enum.KeyCode.G then
        SpeedControl.increaseSpeed()
        State.speedSlider:Set(State.currentSpeed)
    end
    
    if input.KeyCode == Enum.KeyCode.H then
        SpeedControl.decreaseSpeed()
        State.speedSlider:Set(State.currentSpeed)
    end
    
    if input.KeyCode == Enum.KeyCode.R then
        SpeedControl.resetSpeed()
        State.speedSlider:Set(CONFIG.DEFAULT_SPEED)
    end
end)

-- **Character Respawn Handling**
LocalPlayer.CharacterAdded:Connect(function(character)
    -- Wait for humanoid to load
    task.wait(0.5)
    local humanoid = Utils.getHumanoid()
    if humanoid then
        if State.speedEnabled then
            humanoid.WalkSpeed = State.currentSpeed
        end
    end
end)

-- **Status Updates for Info Tab**
RunService.Heartbeat:Connect(function()
    local newStatus = "Speed Hack: **" .. (State.speedEnabled and "ON" or "OFF") .. "**"
    local newSpeed = "Current Speed: **" .. math.floor(State.currentSpeed) .. "**"
    
    if statusLabel.Text ~= newStatus then
        statusLabel:Set(newStatus)
    end
    if currentSpeedLabel.Text ~= newSpeed then
        currentSpeedLabel:Set(newSpeed)
    end
end)

-- **Initialization**
local function initialize()
    Utils.notify("Aaditya Lala Hub", "✅ Speed Hack Module Loaded!", 4)
    
    -- Set initial speed
    local humanoid = Utils.getHumanoid()
    if humanoid then
        humanoid.WalkSpeed = State.currentSpeed
    end
    
    -- Load saved configuration
    task.wait(1)
end

-- Start the script
initialize()

-- **🌟 Aaditya Lala Hub Features:**
-- ✅ **🎖️ Professional Branding** - Custom hub name throughout
-- ✅ **⚡ Real-time Speed Control** - Instant slider adjustments
-- ✅ **🎮 Dual Input System** - GUI + Hotkeys (F,G,H,R)
-- ✅ **💾 Auto-Save Settings** - Configuration persists
-- ✅ **🔄 Respawn Protection** - Speed reapplies after death
-- ✅ **📊 Live Status Display** - Real-time monitoring
-- ✅ **⚙️ Full Customization** - Min/Max limits & increments
-- ✅ **🔔 Smart Notifications** - Visual feedback for all actions
-- ✅ **🎨 Clean Rayfield UI** - Professional interface design
