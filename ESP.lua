local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

-- ESP settings
local espEnabled = true  -- ESP is on by default
local ringThickness = 2  -- Thickness of the ring frame
local ringSize = 2  -- Size of the ring

-- Function to detect if a player is a teammate
local function isFriendly(player)
    local myTeam = LocalPlayer.Team
    return player.Team == myTeam
end

-- Function to create the ESP ring and name label
local function createESP(player)
    if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
        local character = player.Character
        local humanoidRootPart = character.HumanoidRootPart
        
        -- Determine ring color based on team
        local ringColor = isFriendly(player) and Color3.fromRGB(0, 0, 255) or Color3.fromRGB(255, 0, 0)

        -- Create BillboardGui
        local billboard = Instance.new("BillboardGui")
        billboard.Name = "ESP"
        billboard.Adornee = humanoidRootPart
        billboard.Size = UDim2.new(ringSize, 0, ringSize, 0)
        billboard.StudsOffset = Vector3.new(0, 2, 0)
        billboard.AlwaysOnTop = true

        -- Create a frame for the ESP ring
        local ring = Instance.new("Frame", billboard)
        ring.Name = "ESP_Ring"
        ring.Size = UDim2.new(1, 0, 1, 0)
        ring.BackgroundTransparency = 1
        ring.BorderSizePixel = ringThickness
        ring.BorderColor3 = ringColor
        ring.ZIndex = 2

        -- Create a label for the player's name
        local nameLabel = Instance.new("TextLabel", billboard)
        nameLabel.Name = "ESP_Name"
        nameLabel.Size = UDim2.new(1, 0, 0.2, 0)
        nameLabel.Position = UDim2.new(0, 0, -0.2, 0)
        nameLabel.BackgroundTransparency = 1
        nameLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
        nameLabel.Text = player.Name
        nameLabel.TextScaled = true
        nameLabel.Font = Enum.Font.SourceSansBold
        nameLabel.ZIndex = 3

        billboard.Parent = humanoidRootPart
    end
end


local function removeESP(player)
    if player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
        local humanoidRootPart = player.Character.HumanoidRootPart
        if humanoidRootPart:FindFirstChild("ESP") then
            humanoidRootPart:FindFirstChild("ESP"):Destroy()
        end
    end
end

-- Ensure ESP is added to all current and future players
local function initializeESP()
    for _, player in pairs(Players:GetPlayers()) do
        if espEnabled then
            if player.Character and not player.Character:FindFirstChild("ESP") then
                createESP(player)
            end
            player.CharacterAdded:Connect(function()
                wait(1) -- Wait until character is fully loaded
                if not player.Character:FindFirstChild("ESP") then
                    createESP(player)
                end
            end)
        end
    end

    Players.PlayerAdded:Connect(function(player)
        player.CharacterAdded:Connect(function()
            wait(1) -- Wait until character is fully loaded
            if espEnabled then
                createESP(player)
            end
        end)
    end)
end

-- Start ESP
initializeESP()


[[ 
game:GetService("RunService").RenderStepped:Connect(function()
    for _, player in pairs(Players:GetPlayers()) do
        if player.Character and not player.Character:FindFirstChild("ESP") then
            createESP(player)
        end
    end
end)
]]