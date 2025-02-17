-- Define the AutofarmSettings
getgenv().AutofarmSettings = {
    ["Fps"] = 10,
    ["InstaTP"] = true,
    ["Underground"] = true
}

-- Discord Information
local discordLink = "https://discord.gg/YourDiscordInvite"  -- Your discord invite link here

-- Display Notification
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

-- Money Counter Display
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

-- Cash Aura to automatically pick up money
local function cashAura()
    while true do
        wait(0.5)  -- Checks every 0.5 seconds for nearby money drops
        for i, money in ipairs(game.Workspace.Ignored.Drop:GetChildren()) do
            if money.Name == "MoneyDrop" and (money.Position - game.Players.LocalPlayer.Character.HumanoidRootPart.Position).magnitude <= 20 then
                -- Move the player to the money's position
                game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = money.CFrame
                -- Click the money (trigger the click detector)
                if money:FindFirstChild("ClickDetector") then
                    fireclickdetector(money.ClickDetector)
                end
                wait(0.5)  -- Short wait to prevent overloading the system with click events
            end
        end
    end
end

-- Local variables
local humanoid = game.Players.LocalPlayer.Character.Humanoid
local tool = game.Players.LocalPlayer.Backpack.Combat

-- Function to get money around the player
local function getMoneyAroundMe() 
    wait(0.5)
    for i, money in ipairs(game.Workspace.Ignored.Drop:GetChildren()) do
        if money.Name == "MoneyDrop" and (money.Position - game.Players.LocalPlayer.Character.HumanoidRootPart.Position).magnitude <= 20 then
            game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = money.CFrame
            fireclickdetector(money.ClickDetector)
            wait(0.5)
        end  
    end
end

-- Function to start autofarming
local function startAutoFarm() 
    humanoid:EquipTool(tool)

    for i, v in ipairs(game.Workspace.Cashiers:GetChildren()) do
        game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = v.Open.CFrame * CFrame.new(0, 0, 2)

        for i = 0, 15 do
            wait(0.5)
            tool:Activate()
        end

        getMoneyAroundMe()
    end

    wait(0.5)
end

-- Run the script: display the Discord message, live money counter, and start the cash aura and autofarming
displayNotification("Executing Script...")
displayMoneyCounter()
cashAura()  -- Start the cash aura
startAutoFarm()  -- Start the autofarm
