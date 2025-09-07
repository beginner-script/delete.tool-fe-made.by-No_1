
local Players = game:GetService("Players")
local player = Players.LocalPlayer
local backpack = player:WaitForChild("Backpack")
local mouse = player:GetMouse()
local character = player.Character or player.CharacterAdded:Wait()

local tool = Instance.new("Tool")
tool.Name = "지우개"
tool.RequiresHandle = false
tool.Parent = backpack

local maxDistance = 10 
local highlight = Instance.new("Highlight")
highlight.FillTransparency = 1 
highlight.OutlineColor = Color3.fromRGB(0, 162, 255) 
highlight.OutlineTransparency = 0 
local function isHoldingRequiredTool()
    local toolEquipped = character:FindFirstChildOfClass("Tool")
    return toolEquipped and toolEquipped.Name == "지우개"
end

mouse.Button1Down:Connect(function()
    if isHoldingRequiredTool() and mouse.Target then
        local target = mouse.Target
        local hrp = character:FindFirstChild("HumanoidRootPart")
        if not hrp then return end

        local distance = (hrp.Position - target.Position).Magnitude
        if distance <= maxDistance and target:IsA("BasePart") then
            target:Destroy() 
            highlight.Adornee = nil 
        end
    end
end)

local lastTarget = nil
mouse.Move:Connect(function()
    if not isHoldingRequiredTool() then
        highlight.Adornee = nil
        lastTarget = nil
        return
    end

    local target = mouse.Target
    local hrp = character:FindFirstChild("HumanoidRootPart")
    if target and hrp and target:IsA("BasePart") then
        local distance = (hrp.Position - target.Position).Magnitude
        if distance <= maxDistance then
            if lastTarget ~= target then
                highlight.Adornee = target
                lastTarget = target
            end
            return
        end
    end
    highlight.Adornee = nil
    lastTarget = nil
end)

player.CharacterAdded:Connect(function(newChar)
    character = newChar
end)
