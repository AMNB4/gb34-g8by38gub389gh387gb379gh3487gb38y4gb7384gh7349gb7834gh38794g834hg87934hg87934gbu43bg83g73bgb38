-- Define the AutofarmSettings
getgenv().AutofarmSettings = {
    ["Fps"] = 10,
    ["InstaTP"] = true,
    ["Underground"] = true
}

-- New Pastebin URL to the keys (use the raw Pastebin link)
local pastebinLink = "https://pastebin.com/raw/7B5kPt5p"  -- Updated Pastebin link for keys

-- Discord Information
local discordLink = "https://discord.gg/JfmmMsy4zE"  -- Your discord invite link here

-- Function to display notifications
local function displayNotification(message)
    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Parent = game.Players.LocalPlayer:WaitForChild("PlayerGui")
    
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(0, 300, 0, 100)
    frame.Position = UDim2.new(0.5, -150, 0.5, -50)
    frame.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    frame.Parent = ScreenGui
    
    local textLabel = Instance.new("TextLabel")
    textLabel.Size = UDim2.new(1, 0, 1, 0)
    textLabel.Position = UDim2.new(0, 0, 0, 0)
    textLabel.Text = message
    textLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    textLabel.TextScaled = true
    textLabel.Parent = frame
end

-- Function to fetch keys from the Pastebin link
local function fetchKeysFromPastebin()
    local HttpService = game:GetService("HttpService")
    local success, response = pcall(function()
        return HttpService:GetAsync(pastebinLink)  -- Fetch raw Pastebin data
    end)

    if success then
        local keys = {}
        for key in string.gmatch(response, "[^\r\n]+") do  -- Split by newlines
            table.insert(keys, key)
        end
        return keys
    else
        displayNotification("Failed to fetch keys from Pastebin.")
        return {}
    end
end

-- List of valid keys from Pastebin
local validKeys = fetchKeysFromPastebin()

-- Key system
local usedKeys = {}  -- To track which keys have been used
local playerData = {}  -- Table to store player-specific data

-- Function to check if the entered key is valid and not already used
local function isKeyValid(key)
    for _, validKey in ipairs(validKeys) do
        if key == validKey then
            -- Check if the key has already been used
            if not usedKeys[key] then
                usedKeys[key] = true  -- Mark the key as used
                return true
            else
                displayNotification("This key has already been used.")
                return false
            end
        end
    end
    return false
end

-- Function to automatically collect DHC when ATMs are nearby or broken
local function autoCollectDHC()
    local player = game.Players.LocalPlayer
    local character = player.Character or player.CharacterAdded:Wait()
    local hrp = character:WaitForChild("HumanoidRootPart")  -- Get the player's position
    
    -- Define a detection radius (how far away the player should detect ATMs and DHC)
    local detectionRadius = 10  -- You can adjust the distance as needed
    
    -- Function to check if an object is within the detection range
    local function isWithinRange(object, position, range)
        return (object.Position - position).Magnitude <= range
    end
    
    -- Function to scan for ATMs and DHC
    local function scanForATMAndDHC()
        local playerPosition = hrp.Position

        -- Scan all parts in the game workspace
        for _, object in pairs(workspace:GetChildren()) do
            -- Check if the object is within the detection radius
            if isWithinRange(object, playerPosition, detectionRadius) then
                -- If it's an ATM or a DHC (based on criteria), auto-collect DHC
                -- Example condition: If it's a part that has a DHC object as a child
                if object:IsA("Part") and object:FindFirstChild("DHC") then
                    local dhc = object:FindFirstChild("DHC")
                    if dhc then
                        dhc.Parent = player.Backpack  -- Automatically collect DHC
                    end
                end
            end
        end
    end
    
    -- Continuously scan every 1 second to detect ATMs and DHC objects
    while true do
        wait(1)
        scanForATMAndDHC()
    end
end

-- Function to save player data based on the entered key
local function savePlayerData(key)
    playerData[key] = playerData[key] or {}
    -- Example: Store player progress, such as cash or items
    -- playerData[key].money = game.Players.LocalPlayer.leaderstats.Money.Value
end

-- Main script logic
local function startScript()
    -- Money Counter Display
    displayMoneyCounter()
    -- Cash Aura to automatically pick up money
    cashAura()  -- Start the cash aura
    -- Start the autofarm
    startAutoFarm()  -- Start the autofarm
    
    -- Start auto-collecting DHC when ATMs are detected
    autoCollectDHC()

    -- Save the player data after starting the script
    local key = game.Players.LocalPlayer.PlayerGui:WaitForChild("TextBox") -- Input box where player enters the key
    savePlayerData(key.Text)  -- Save data associated with the entered key
end

-- Listen for key input and automatically start script if key is valid
local function promptForKey()
    local player = game.Players.LocalPlayer
    local keyBox = Instance.new("TextBox")
    keyBox.Size = UDim2.new(0, 200, 0, 50)
    keyBox.Position = UDim2.new(0.5, -100, 0.5, -25)
    keyBox.PlaceholderText = "Enter your key"
    keyBox.Parent = player.PlayerGui

    keyBox.FocusLost:Connect(function(enterPressed)
        if enterPressed then
            local enteredKey = keyBox.Text
            if isKeyValid(enteredKey) then
                displayNotification("Key is valid, starting the script...")
                startScript()  -- Start script if key is valid
            else
                displayNotification("Invalid key! Please enter a valid key.")
            end
        end
    end)
end

-- Start the key prompt
promptForKey()

-- Function to display live money counter and running time
local function displayMoneyCounter()
    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Parent = game.Players.LocalPlayer:WaitForChild("PlayerGui")

    -- Black screen background
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(1, 0, 1, 0)
    frame.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    frame.Parent = ScreenGui

    -- Discord Text
    local discordLabel = Instance.new("TextLabel")
    discordLabel.Size = UDim2.new(1, 0, 0.2, 0)
    discordLabel.Position = UDim2.new(0, 0, 0.4, 0)
    discordLabel.Text = "Join Our Discord: " .. discordLink
    discordLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    discordLabel.TextScaled = true
    discordLabel.Parent = frame

    -- Money count label
    local moneyLabel = Instance.new("TextLabel")
    moneyLabel.Size = UDim2.new(1, 0, 0.2, 0)
    moneyLabel.Position = UDim2.new(0, 0, 0.6, 0)
    moneyLabel.Text = "Money Earned: $0"
    moneyLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    moneyLabel.TextScaled = true
    moneyLabel.Parent = frame

    -- Running time label
    local timeLabel = Instance.new("TextLabel")
    timeLabel.Size = UDim2.new(1, 0, 0.2, 0)
    timeLabel.Position = UDim2.new(0, 0, 0.8, 0)
    timeLabel.Text = "Running Time: 0s"
    timeLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    timeLabel.TextScaled = true
    timeLabel.Parent = frame

    -- Update Money Count live
    local previousMoney = 0
    local startTime = tick()  -- Get the start time of the script

    while true do
        wait(1)  -- Update every second
        local currentMoney = game.Players.LocalPlayer.leaderstats.Money.Value
        if currentMoney > previousMoney then
            moneyLabel.Text = "Money Earned: $" .. tostring(currentMoney)
            previousMoney = currentMoney
        end

        -- Update Running Time
        local runningTime = math.floor(tick() - startTime)  -- Calculate the running time in seconds
        timeLabel.Text = "Running Time: " .. runningTime .. "s"
    end
end
