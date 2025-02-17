-- Define the AutofarmSettings
getgenv().AutofarmSettings = {
    ["Fps"] = 10,
    ["InstaTP"] = true,
    ["Underground"] = true
}

-- List of valid usernames (add your allowed usernames here)
local validUsernames = {
    "Username1",  -- Replace with the first allowed username
    "Username2",  -- Replace with the second allowed username
    "Username3"   -- Replace with the third allowed username, etc.
}

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

-- Function to check if the player's username is valid
local function checkUsername()
    for _, username in ipairs(validUsernames) do
        if game.Players.LocalPlayer.Name == username then
            return true
        end
    end
    return false
end

-- Main script logic
local function startScript()
    if checkUsername() then
        -- Money Counter Display
        displayMoneyCounter()
        -- Cash Aura to automatically pick up money
        cashAura()  -- Start the cash aura
        -- Start the autofarm
        startAutoFarm()  -- Start the autofarm
    else
        displayNotification("Invalid username! Script will not run.")
    end
end

-- Start the script
startScript()

-- Function to display live money counter
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

    -- Update Money Count live
    local previousMoney = 0
    while true do
        wait(1)  -- Update every second
        local currentMoney = game.Players.LocalPlayer.leaderstats.Money.Value
        if currentMoney > previousMoney then
            moneyLabel.Text = "Money Earned: $" .. tostring(currentMoney)
            previousMoney = currentMoney
        end
    end
end
