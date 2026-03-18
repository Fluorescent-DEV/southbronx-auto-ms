-- [[ AUTOMS BY FLUU - SOUTH BRONX EDITION ]]
local lp = game.Players.LocalPlayer
local VIM = game:GetService("VirtualInputManager")

-- CLEANUP UI
local uiName = "AutomsByFluuFinal"
pcall(function()
    if game:GetService("CoreGui"):FindFirstChild(uiName) then game:GetService("CoreGui")[uiName]:Destroy() end
    if lp.PlayerGui:FindFirstChild(uiName) then lp.PlayerGui[uiName]:Destroy() end
end)

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = uiName
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Global
local successUI, _ = pcall(function() ScreenGui.Parent = game:GetService("CoreGui") end)
if not successUI then ScreenGui.Parent = lp:WaitForChild("PlayerGui") end

-- [[ UI DESIGN ]]
local MainFrame = Instance.new("Frame", ScreenGui)
MainFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
MainFrame.Position = UDim2.new(0.5, -115, 0.5, -190)
MainFrame.Size = UDim2.new(0, 230, 0, 400)
MainFrame.Active = true
MainFrame.Draggable = true
Instance.new("UICorner", MainFrame)
Instance.new("UIStroke", MainFrame).Color = Color3.fromRGB(0, 255, 150)

local Title = Instance.new("TextLabel", MainFrame)
Title.Size = UDim2.new(1, 0, 0, 40)
Title.Text = "AUTOMS BY FLUU"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.Font = Enum.Font.GothamBold
Title.BackgroundTransparency = 1
Title.TextSize = 14

-- [[ CORE FUNCTIONS ]]

local function forceInterract(target, holdTime)
    if not target then return end
    local prompt = target:FindFirstChildOfClass("ProximityPrompt") or target:FindFirstChild("ProximityPrompt", true)
    
    if prompt then
        fireproximityprompt(prompt) 
        VIM:SendKeyEvent(true, Enum.KeyCode.E, false, game) 
        task.wait(holdTime or 0.4)
        VIM:SendKeyEvent(false, Enum.KeyCode.E, false, game)
        return true
    end
    return false
end

local function clickText(txt)
    local pGui = lp:WaitForChild("PlayerGui")
    for _, v in pairs(pGui:GetDescendants()) do
        if (v:IsA("TextButton") or v:IsA("TextLabel")) and v.Visible then
            if string.find(string.lower(v.Text), string.lower(txt)) then
                local target = v
                if v:IsA("TextLabel") and v.Parent:IsA("TextButton") then target = v.Parent end
                local pos = target.AbsolutePosition
                local size = target.AbsoluteSize
                VIM:SendMouseButtonEvent(pos.X + size.X/2, pos.Y + size.Y/2 + 58, 0, true, game, 1)
                task.wait(0.1)
                VIM:SendMouseButtonEvent(pos.X + size.X/2, pos.Y + size.Y/2 + 58, 0, false, game, 1)
                return true
            end
        end
    end
    return false
end

-- [[ UI ELEMENTS ]]
local QtyInput = Instance.new("TextBox", MainFrame)
QtyInput.Size = UDim2.new(0.85, 0, 0, 30); QtyInput.Position = UDim2.new(0.075, 0, 0.15, 0)
QtyInput.PlaceholderText = "Jumlah Beli"; QtyInput.Text = "100"
QtyInput.BackgroundColor3 = Color3.fromRGB(35, 35, 35); QtyInput.TextColor3 = Color3.fromRGB(255, 255, 255)
Instance.new("UICorner", QtyInput)

local BuyBtn = Instance.new("TextButton", MainFrame)
BuyBtn.Size = UDim2.new(0.85, 0, 0, 35); BuyBtn.Position = UDim2.new(0.075, 0, 0.25, 0)
BuyBtn.Text = "AUTO BUY DEALER"; BuyBtn.BackgroundColor3 = Color3.fromRGB(0, 120, 255)
BuyBtn.TextColor3 = Color3.fromRGB(255, 255, 255); BuyBtn.Font = Enum.Font.GothamBold
Instance.new("UICorner", BuyBtn)

local CookBtn = Instance.new("TextButton", MainFrame)
CookBtn.Size = UDim2.new(0.85, 0, 0, 45); CookBtn.Position = UDim2.new(0.075, 0, 0.45, 0)
CookBtn.Text = "START AUTO COOKING"; CookBtn.BackgroundColor3 = Color3.fromRGB(200, 0, 0)
CookBtn.TextColor3 = Color3.fromRGB(255, 255, 255); CookBtn.Font = Enum.Font.GothamBold
Instance.new("UICorner", CookBtn)

local Status = Instance.new("TextLabel", MainFrame)
Status.Size = UDim2.new(1, 0, 0, 25); Status.Position = UDim2.new(0, 0,
