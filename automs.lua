-- AUTOMS BY FLUU
local lp = game.Players.LocalPlayer
local VIM = game:GetService("VirtualInputManager")

-- Hapus UI
local oldUI = game:GetService("CoreGui"):FindFirstChild("AutomsByFluuFinal") or lp.PlayerGui:FindFirstChild("AutomsByFluuFinal")
if oldUI then oldUI:Destroy() end

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "AutomsByFluuFinal"
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Global
local success, _ = pcall(function() ScreenGui.Parent = game:GetService("CoreGui") end)
if not success then ScreenGui.Parent = lp:WaitForChild("PlayerGui") end

-- FRAME UTAMA
local MainFrame = Instance.new("Frame", ScreenGui)
MainFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
MainFrame.Position = UDim2.new(0.5, -125, 0.5, -175)
MainFrame.Size = UDim2.new(0, 250, 350) -- Ukuran kotak proporsional
MainFrame.Active = true
MainFrame.Draggable = true
MainFrame.ZIndex = 1
Instance.new("UICorner", MainFrame)
local Stroke = Instance.new("UIStroke", MainFrame)
Stroke.Color = Color3.fromRGB(0, 255, 150)
Stroke.Thickness = 2

-- TITLE
local Title = Instance.new("TextLabel", MainFrame)
Title.Size = UDim2.new(1, 0, 0, 40)
Title.Text = "AUTOMS BY FLUU"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.Font = Enum.Font.GothamBold
Title.TextSize = 14
Title.BackgroundTransparency = 1
Title.ZIndex = 5

-- DASHBOARD STATS
local StatsFrame = Instance.new("Frame", MainFrame)
StatsFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
StatsFrame.Position = UDim2.new(0.05, 0, 0.15, 0)
StatsFrame.Size = UDim2.new(0.9, 0, 0, 100)
StatsFrame.ZIndex = 2
Instance.new("UICorner", StatsFrame)

local function createStatLabel(name, pos, color)
    local lbl = Instance.new("TextLabel", StatsFrame)
    lbl.Size = UDim2.new(1, -10, 0, 18)
    lbl.Position = pos
    lbl.BackgroundTransparency = 1
    lbl.TextColor3 = color or Color3.fromRGB(200, 200, 200)
    lbl.TextXAlignment = Enum.TextXAlignment.Left
    lbl.Font = Enum.Font.GothamMedium
    lbl.TextSize = 10
    lbl.Text = name .. " : 0"
    lbl.ZIndex = 5
    return lbl
end

local WaterCount = createStatLabel("Water", UDim2.new(0, 8, 0, 5))
local SugarCount = createStatLabel("Sugar", UDim2.new(0, 8, 0, 23))
local GelatinCount = createStatLabel("Gelatin", UDim2.new(0, 8, 0, 41))
local UnfinishedMS = createStatLabel("⏳ Unfinished MS", UDim2.new(0, 8, 0, 59), Color3.fromRGB(255, 165, 0))
local FinishedMS = createStatLabel("✅ Finished MS", UDim2.new(0, 8, 0, 77), Color3.fromRGB(0, 255, 150))

-- INPUT JUMLAH
local QtyInput = Instance.new("TextBox", MainFrame)
QtyInput.Size = UDim2.new(0.9, 0, 0, 30)
QtyInput.Position = UDim2.new(0.05, 0, 0.46, 0)
QtyInput.PlaceholderText = "Isi Jumlah (Contoh: 100)"
QtyInput.Text = "100"
QtyInput.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
QtyInput.TextColor3 = Color3.fromRGB(255, 255, 255)
QtyInput.ZIndex = 5
Instance.new("UICorner", QtyInput)

-- TOMBOL AUTO BUY
local ExecuteBuy = Instance.new("TextButton", MainFrame)
ExecuteBuy.Size = UDim2.new(0.9, 0, 0, 35)
ExecuteBuy.Position = UDim2.new(0.05, 0, 0.58, 0)
ExecuteBuy.Text = "AUTO BUY"
ExecuteBuy.BackgroundColor3 = Color3.fromRGB(0, 120, 215)
ExecuteBuy.TextColor3 = Color3.fromRGB(255, 255, 255)
ExecuteBuy.Font = Enum.Font.GothamBold
ExecuteBuy.ZIndex = 5
Instance.new("UICorner", ExecuteBuy)

-- TOMBOL COOKING
local CookBtn = Instance.new("TextButton", MainFrame)
CookBtn.Size = UDim2.new(0.9, 0, 0, 40)
CookBtn.Position = UDim2.new(0.05, 0, 0.72, 0)
CookBtn.Text = "START COOKING"
CookBtn.BackgroundColor3 = Color3.fromRGB(200, 0, 0)
CookBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
CookBtn.Font = Enum.Font.GothamBold
CookBtn.ZIndex = 5
Instance.new("UICorner", CookBtn)

-- STATUS BAR
local Status = Instance.new("TextLabel", MainFrame)
Status.Size = UDim2.new(1, 0, 0, 20)
Status.Position = UDim2.new(0, 0, 0.9, 0)
Status.Text = "Status: Idle"
Status.TextColor3 = Color3.fromRGB(150, 150, 150)
Status.BackgroundTransparency = 1
Status.Font = Enum.Font.Gotham
Status.TextSize = 10
Status.ZIndex = 5

-- [ LOGIC SECTION ]
_G.AutoCook = false

-- Monitor Stats Loop
task.spawn(function()
    while task.wait(1.5) do
        pcall(function()
            local w, s, g, un, fi = 0, 0, 0, 0, 0
            local items = lp.Backpack:GetChildren()
            if lp.Character then for _, v in pairs(lp.Character:GetChildren()) do if v:IsA("Tool") then table.insert(items, v) end end end
            for _, item in pairs(items) do
                local n = item.Name:lower()
                if n:find("water") then w = w + 1
                elseif n:find("sugar") then s = s + 1
                elseif n:find("gelatin") then g = g + 1
                elseif n:find("marshmallow") then
                    if n:find("unfinish") or n:find("raw") then un = un + 1 else fi = fi + 1 end
                end
            end
            WaterCount.Text = "Water : "..w
            SugarCount.Text = "Sugar : "..s
            GelatinCount.Text = "Gelatin : "..g
            UnfinishedMS.Text = "⏳ Unfinished MS : "..un
            FinishedMS.Text = "✅ Finished MS : "..fi
        end)
    end
end)

-- Auto Buy Event
ExecuteBuy.MouseButton1Click:Connect(function()
    local amt = tonumber(QtyInput.Text) or 100
    for _, v in pairs(workspace:GetDescendants()) do
        if v:IsA("ProximityPrompt") and (v.Parent.Name:find("Lamont") or v.Parent.Name:find("Bell")) then
            fireproximityprompt(v)
            task.wait(1)
            -- Dialog click
            pcall(function()
                local pg = lp:WaitForChild("PlayerGui")
                for _, btn in pairs(pg:GetDescendants()) do
                    if btn:IsA("TextButton") and (btn.Text:find("Yea") or btn.Text:find("guy")) then
                        local x, y = btn.AbsolutePosition.X + btn.AbsoluteSize.X/2, btn.AbsolutePosition.Y + btn.AbsoluteSize.Y/2
                        VIM:SendMouseButtonEvent(x, y + 36, 0, true, game, 1)
                        VIM:SendMouseButtonEvent(x, y + 36, 0, false, game, 1)
                    end
                end
            end)
            task.wait(1)
            local remote = game:GetService("ReplicatedStorage"):FindFirstChild("BuyItem", true) or game:GetService("ReplicatedStorage"):FindFirstChild("Purchase", true)
            if remote then
                task.spawn(function()
                    Status.Text = "Status: Buying Items..."
                    for i = 1, amt do remote:FireServer("Water") task.wait(0.1) end
                    for i = 1, amt do remote:FireServer("Sugar Block Bag") task.wait(0.1) end
                    for i = 1, amt do remote:FireServer("Gelatin") task.wait(0.1) end
                    Status.Text = "Status: Done!"
                end)
            end
            break
        end
    end
end)

CookBtn.MouseButton1Click:Connect(function()
    _G.AutoCook = not _G.AutoCook
    CookBtn.Text = _G.AutoCook and "STOP COOKING" or "START COOKING"
    CookBtn.BackgroundColor3 = _G.AutoCook and Color3.fromRGB(0, 180, 0) or Color3.fromRGB(200, 0, 0)
end)

-- Loop Cook Workflow
task.spawn(function()
    while task.wait(1) do
        if _G.AutoCook then Status.Text = "Status: Cooker Active" end
    end
end)
