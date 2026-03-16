-- AUTOMS BY FLUU - SOUTH BRONX
local ScreenGui = Instance.new("ScreenGui")
local MainFrame = Instance.new("Frame")
local Title = Instance.new("TextLabel")
local ToggleBtn = Instance.new("TextButton")
local StatusLabel = Instance.new("TextLabel")
local StatsFrame = Instance.new("Frame")

-- Dashboard Labels
local WaterCount, SugarCount, GelatinCount, UnfinishedMS, FinishedMS

-- Services
local lp = game.Players.LocalPlayer
local VIM = game:GetService("VirtualInputManager")

-- Setup UI (AUTOMS BY FLUU)
ScreenGui.Name = "AutomsByFluuHub"
ScreenGui.Parent = game:GetService("CoreGui") or lp:WaitForChild("PlayerGui")

MainFrame.Name = "MainFrame"
MainFrame.Parent = ScreenGui
MainFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
MainFrame.Position = UDim2.new(0.5, -115, 0.5, -125)
MainFrame.Size = UDim2.new(0, 230, 0, 250)
MainFrame.Active = true
MainFrame.Draggable = true
Instance.new("UICorner", MainFrame).CornerRadius = UDim.new(0, 12)
local stroke = Instance.new("UIStroke", MainFrame)
stroke.Color = Color3.fromRGB(0, 255, 150)
stroke.Thickness = 2

Title.Parent = MainFrame
Title.Size = UDim2.new(1, 0, 0, 40)
Title.Text = "AUTOMS BY FLUU"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.Font = Enum.Font.GothamBold
Title.TextSize = 14
Title.BackgroundTransparency = 1

StatsFrame.Parent = MainFrame
StatsFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
StatsFrame.Position = UDim2.new(0.05, 0, 0.18, 0)
StatsFrame.Size = UDim2.new(0.9, 0, 0, 110)
Instance.new("UICorner", StatsFrame).CornerRadius = UDim.new(0, 8)

local function createStatLabel(name, pos, color)
    local lbl = Instance.new("TextLabel", StatsFrame)
    lbl.Size = UDim2.new(1, -10, 0, 20)
    lbl.Position = pos
    lbl.BackgroundTransparency = 1
    lbl.TextColor3 = color or Color3.fromRGB(200, 200, 200)
    lbl.TextXAlignment = Enum.TextXAlignment.Left
    lbl.Font = Enum.Font.GothamMedium
    lbl.TextSize = 11
    lbl.Text = name .. " : 0"
    return lbl
end

WaterCount = createStatLabel("Water Stock", UDim2.new(0, 10, 0, 5))
SugarCount = createStatLabel("Sugar Stock", UDim2.new(0, 10, 0, 25))
GelatinCount = createStatLabel("Gelatin Stock", UDim2.new(0, 10, 0, 45))
UnfinishedMS = createStatLabel("⏳ Unfinished MS", UDim2.new(0, 10, 0, 65), Color3.fromRGB(255, 165, 0))
FinishedMS = createStatLabel("✅ Finished MS", UDim2.new(0, 10, 0, 85), Color3.fromRGB(0, 255, 150))

StatusLabel.Parent = MainFrame
StatusLabel.Position = UDim2.new(0, 0, 0.9, 0)
StatusLabel.Size = UDim2.new(1, 0, 0, 20)
StatusLabel.Text = "Status: Idle"
StatusLabel.TextColor3 = Color3.fromRGB(150, 150, 150)
StatusLabel.BackgroundTransparency = 1
StatusLabel.Font = Enum.Font.Gotham
StatusLabel.TextSize = 11

ToggleBtn.Parent = MainFrame
ToggleBtn.Position = UDim2.new(0.1, 0, 0.65, 0)
ToggleBtn.Size = UDim2.new(0.8, 0, 0, 40)
ToggleBtn.Text = "START AFK"
ToggleBtn.BackgroundColor3 = Color3.fromRGB(0, 255, 150)
ToggleBtn.Font = Enum.Font.GothamBold
ToggleBtn.TextSize = 14
Instance.new("UICorner", ToggleBtn)

_G.AutoCook = false

local function pressE()
    
    for i = 1, 5 do 
        task.spawn(function()
            for _, v in pairs(workspace:GetDescendants()) do
                if v:IsA("ProximityPrompt") then
                    local dist = (lp.Character.HumanoidRootPart.Position - v.Parent.Position).Magnitude
                    if dist < 15 then
                        fireproximityprompt(v)
                    end
                end
            end
        end)
        VIM:SendKeyEvent(true, Enum.KeyCode.E, false, game)
        task.wait(0.01)
        VIM:SendKeyEvent(false, Enum.KeyCode.E, false, game)
    end
end

local function autoEquip(name)
    local bp = lp:FindFirstChild("Backpack")
    local char = lp.Character
    if not bp or not char then return false end
    
    char.Humanoid:UnequipTools()
    task.wait(0.2)

    for _, tool in pairs(bp:GetChildren()) do
        if string.find(string.lower(tool.Name), string.lower(name)) then
            char.Humanoid:EquipTool(tool)
            task.wait(0.5)
            return true
        end
    end
    return false
end

spawn(function()
    while true do
        pcall(function()
            local items = lp.Backpack:GetChildren()
            if lp.Character then for _, v in pairs(lp.Character:GetChildren()) do if v:IsA("Tool") then table.insert(items, v) end end end
            local w, s, g, un, fi = 0, 0, 0, 0, 0
            for _, item in pairs(items) do
                local n = item.Name:lower()
                if n:find("water") then w = w + 1
                elseif n:find("sugar") and not n:find("empty") then s = s + 1
                elseif n:find("gelatin") then g = g + 1
                elseif n:find("marshmallow") then
                    if n:find("unfinish") or n:find("raw") then un = un + 1 else fi = fi + 1 end
                end
            end
            WaterCount.Text = "Water Stock : "..w
            SugarCount.Text = "Sugar Stock : "..s
            GelatinCount.Text = "Gelatin Stock : "..g
            UnfinishedMS.Text = "⏳ Unfinished MS : "..un
            FinishedMS.Text = "✅ Finished MS : "..fi
        end)
        task.wait(2)
    end
end)

ToggleBtn.MouseButton1Click:Connect(function()
    _G.AutoCook = not _G.AutoCook
    ToggleBtn.Text = _G.AutoCook and "STOP AFK" or "START AFK"
    ToggleBtn.BackgroundColor3 = _G.AutoCook and Color3.fromRGB(255, 50, 50) or Color3.fromRGB(0, 255, 150)
end)

spawn(function()
    while true do
        task.wait(0.5)
        if _G.AutoCook then
            -- 1. WATER (CD 20s)
            if autoEquip("Water") then
                StatusLabel.Text = "Status: Inputting Water"
                pressE()
                for i = 21, 1, -1 do
                    if not _G.AutoCook then break end
                    StatusLabel.Text = "Status: Water CD ("..i.."s)"
                    task.wait(1)
                end
            end

            -- 2. SUGAR
            if _G.AutoCook and autoEquip("Sugar") then
                StatusLabel.Text = "Status: Inputting Sugar"
                pressE()
                task.wait(2)
            end

            -- 3. GELATIN
            if _G.AutoCook and autoEquip("Gelatin") then
                StatusLabel.Text = "Status: Inputting Gelatin"
                pressE()
                task.wait(2)
            end

            -- 4. COOKING (45s)
            if _G.AutoCook then
                for i = 46, 1, -1 do
                    if not _G.AutoCook then break end
                    StatusLabel.Text = "Status: Cooking ("..i.."s)"
                    task.wait(1)
                end
            end

            -- 5. COLLECT
            if _G.AutoCook and autoEquip("Empty") then
                StatusLabel.Text = "Status: Collecting Marshmallow"
                task.wait(0.5)
                pressE()
                task.wait(4)
            end
        else
            StatusLabel.Text = "Status: Idle"
        end
    end
end)
