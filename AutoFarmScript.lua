-- Define the AutofarmSettings
getgenv().AutofarmSettings = {
    ["Fps"] = 10,
    ["InstaTP"] = true,
    ["Underground"] = true
}

-- Discord Information
local discordLink = "https://discord.gg/JfmmMsy4zE"  -- Your discord invite link here

-- List of valid keys (this is a placeholder; you could load them from an external source)
local validKeys = {
    "12345",
    "ABCDE",
    "MYSECRETKEY"
}

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

-- Key Check Function
local function checkKey(inputKey)
    for _, key in ipairs(validKeys) do
        if inputKey == key then
            return true
        end
    end
    return false
end

-- Create a UI to prompt for the key input
local function promptForKey()
    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Parent = game.Players.LocalPlayer:WaitForChild("PlayerGui")
    
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(0, 400, 0, 200)
    frame.Position = UDim2.new(0.5, -200, 0.5, -100)
    frame.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    frame.Parent = ScreenGui
    
    local textLabel = Instance.new("TextLabel")
    textLabel.Size = UDim2.new(1, 0, 0.2, 0)
    textLabel.Position = UDim2.new(0, 0, 0, 0)
    textLabel.Text = "Enter Key to Continue:"
    textLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    textLabel.TextScaled = true
    textLabel.Parent = frame
    
    -- Key input box
    local textBox = Instance.new("TextBox")
    textBox.Size = UDim2.new(0.8, 0, 0.2, 0)
    textBox.Position = UDim2.new(0.1, 0, 0.3, 0)
    textBox.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    textBox.TextColor3 = Color3.fromRGB(0, 0, 0)
    textBox.ClearTextOnFocus = true
    textBox.TextScaled = true
    textBox.PlaceholderText = "Enter your key"
    textBox.Parent = frame
    
    -- Submit button
    local submitButton = Instance.new("TextButton")
    submitButton.Size = UDim2.new(0.6, 0, 0.2, 0)
    submitButton.Position = UDim2.new(0.2, 0, 0.6, 0)
    submitButton.Text = "Submit"
    submitButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    submitButton.BackgroundColor3 = Color3.fromRGB(0, 128, 0)
    submitButton.TextScaled = true
    submitButton.Parent = frame
    
    -- Function to handle key submission
    submitButton.MouseButton1Click:Connect(function()
        local inputKey = textBox.Text
        if checkKey(inputKey) then
            displayNotification("Key is valid! Executing Script...")
            wait(2)
            ScreenGui:Destroy()
            startScript()
        else
            displayNotification("Invalid key! Closing...")
            wait(2)
            ScreenGui:Destroy()
        end
    end)
end

-- Start the main script after the key is validated
local function startScript()
    -- Money Counter Display
    displayMoneyCounter()
    -- Cash Aura to automatically pick up money
    cashAura()  -- Start the cash aura
    -- Start the autofarm
    startAutoFarm()  -- Start the autofarm
end

-- Start the key validation process
promptForKey()

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
