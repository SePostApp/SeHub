-- Services
local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local player = Players.LocalPlayer
local ReplicatedStorage = game:GetService("ReplicatedStorage")

-- Net folder (buat RemoteEvent / RemoteFunction)
local net = ReplicatedStorage:WaitForChild("Packages")
    :WaitForChild("_Index")
    :WaitForChild("sleitnick_net@0.2.0")
    :WaitForChild("net")

-- ScreenGui
local gui = Instance.new("ScreenGui")
gui.Parent = player:WaitForChild("PlayerGui")

-- Frame utama
local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 500, 0, 300)
MainFrame.Position = UDim2.new(0.5, 0, 0.5, 0)
MainFrame.AnchorPoint = Vector2.new(0.5, 0.5)
MainFrame.BackgroundColor3 = Color3.fromRGB(25,25,25)
MainFrame.BorderSizePixel = 0
MainFrame.Active = true
MainFrame.Draggable = true
MainFrame.Parent = gui

-- Rounded + Stroke
local corner = Instance.new("UICorner", MainFrame)
corner.CornerRadius = UDim.new(0, 8)

local stroke = Instance.new("UIStroke", MainFrame)
stroke.Color = Color3.fromRGB(80,80,80)
stroke.Thickness = 2

-- Title bar
local TitleBar = Instance.new("Frame")
TitleBar.Size = UDim2.new(1, 0, 0, 30)
TitleBar.BackgroundColor3 = Color3.fromRGB(40,40,40)
TitleBar.Parent = MainFrame

-- Judul
local TitleText = Instance.new("TextLabel")
TitleText.Size = UDim2.new(1, -60, 1, 0)
TitleText.Position = UDim2.new(0, 10, 0, 0)
TitleText.BackgroundTransparency = 1
TitleText.TextColor3 = Color3.fromRGB(255,255,255)
TitleText.Text = "SeHub | 1.0.0"
TitleText.Font = Enum.Font.SourceSansBold
TitleText.TextSize = 16
TitleText.TextXAlignment = Enum.TextXAlignment.Left
TitleText.Parent = TitleBar

-- Tombol minimize
local MinimizeBtn = Instance.new("TextButton")
MinimizeBtn.Size = UDim2.new(0, 25, 0, 25)
MinimizeBtn.Position = UDim2.new(1, -55, 0.5, -12)
MinimizeBtn.BackgroundColor3 = Color3.fromRGB(70,70,70)
MinimizeBtn.Text = "-"
MinimizeBtn.TextColor3 = Color3.fromRGB(255,255,255)
MinimizeBtn.Parent = TitleBar

-- Tombol close
local CloseBtn = Instance.new("TextButton")
CloseBtn.Size = UDim2.new(0, 25, 0, 25)
CloseBtn.Position = UDim2.new(1, -28, 0.5, -12)
CloseBtn.BackgroundColor3 = Color3.fromRGB(150,50,50)
CloseBtn.Text = "X"
CloseBtn.TextColor3 = Color3.fromRGB(255,255,255)
CloseBtn.Parent = TitleBar

-- Sidebar kiri
local Sidebar = Instance.new("Frame")
Sidebar.Size = UDim2.new(0, 120, 1, -30)
Sidebar.Position = UDim2.new(0,0,0,30)
Sidebar.BackgroundColor3 = Color3.fromRGB(35,35,35)
Sidebar.Parent = MainFrame

-- Content kanan
local Content = Instance.new("Frame")
Content.Size = UDim2.new(1, -120, 1, -30)
Content.Position = UDim2.new(0, 120, 0, 30)
Content.BackgroundColor3 = Color3.fromRGB(45,45,45)
Content.Parent = MainFrame

-- Judul konten
local ContentTitle = Instance.new("TextLabel")
ContentTitle.Size = UDim2.new(1, 0, 0, 40)
ContentTitle.BackgroundColor3 = Color3.fromRGB(60,60,60)
ContentTitle.TextColor3 = Color3.fromRGB(255,255,255)
ContentTitle.Text = "Welcome to SeHub"
ContentTitle.Font = Enum.Font.SourceSansBold
ContentTitle.TextSize = 18
ContentTitle.Parent = Content

-- Fungsi tombol sidebar
local function CreateButton(name, order)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1, 0, 0, 40)
    btn.Position = UDim2.new(0, 0, 0, (order-1)*45)
    btn.BackgroundColor3 = Color3.fromRGB(40,40,40)
    btn.TextColor3 = Color3.fromRGB(255,255,255)
    btn.Font = Enum.Font.SourceSans
    btn.TextSize = 16
    btn.Text = name
    btn.Parent = Sidebar
    return btn
end

-- Tambah menu
local MainBtn = CreateButton("Main", 1)
local AutoBtn = CreateButton("Automatic", 2)
local FindBtn = CreateButton("FindPath", 3)
local MiscBtn = CreateButton("Misc", 4)
local SettingBtn = CreateButton("Setting", 5)

-- Logo kecil
local LogoButton = Instance.new("ImageButton")
LogoButton.Size = UDim2.new(0, 40, 0, 40)
LogoButton.Position = UDim2.new(0, 10, 0, 10)
LogoButton.BackgroundTransparency = 1
LogoButton.Image = "rbxassetid://7072717697"
LogoButton.Visible = false
LogoButton.Parent = gui

-- Fungsi close
CloseBtn.MouseButton1Click:Connect(function()
    gui:Destroy()
end)

-- Fungsi minimize -> animasi ke pojok kiri atas
MinimizeBtn.MouseButton1Click:Connect(function()
    local tween = TweenService:Create(MainFrame, TweenInfo.new(0.4, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
        Size = UDim2.new(0, 0, 0, 0),
        Position = UDim2.new(0, 30, 0, 30)
    })
    tween:Play()
    tween.Completed:Connect(function()
        MainFrame.Visible = false
        LogoButton.Visible = true
    end)
end)

-- Klik logo -> restore UI
LogoButton.MouseButton1Click:Connect(function()
    MainFrame.Visible = true
    MainFrame.Size = UDim2.new(0, 0, 0, 0)
    MainFrame.Position = UDim2.new(0, 30, 0, 30)
    LogoButton.Visible = false

    local tween = TweenService:Create(MainFrame, TweenInfo.new(0.4, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
        Size = UDim2.new(0, 500, 0, 300),
        Position = UDim2.new(0.5, 0, 0.5, 0)
    })
    tween:Play()
end)

-- Automatic

local autoFishing = false
local fishingLoop

-- Tombol Auto Equip Rod
local AutoEquipBtn = Instance.new("TextButton")
AutoEquipBtn.Size = UDim2.new(0, 150, 0, 40)
AutoEquipBtn.Position = UDim2.new(0, 20, 0, 60) -- posisi di bawah AutoFishingBtn
AutoEquipBtn.BackgroundColor3 = Color3.fromRGB(70,70,70)
AutoEquipBtn.TextColor3 = Color3.fromRGB(255,255,255)
AutoEquipBtn.Text = "Equip Rod"
AutoEquipBtn.Parent = Content
AutoEquipBtn.Visible = false -- default hidden

-- Tombol di menu Automatic
local AutoFishingBtn = Instance.new("TextButton")
AutoFishingBtn.Size = UDim2.new(0, 150, 0, 40)
AutoFishingBtn.Position = UDim2.new(0, 20, 0, 110)
AutoFishingBtn.BackgroundColor3 = Color3.fromRGB(70,70,70)
AutoFishingBtn.TextColor3 = Color3.fromRGB(255,255,255)
AutoFishingBtn.Text = "Auto Fishing: OFF"
AutoFishingBtn.Parent = Content
AutoFishingBtn.Visible = false -- default hidden

-- Saat klik menu Automatic â†’ tampilkan tombol
AutoBtn.MouseButton1Click:Connect(function()
    ContentTitle.Text = "Automatic Menu"
    AutoEquipBtn.Visible = true
    AutoFishingBtn.Visible = true
end)

-- Fungsi loop Auto Fishing
local function startFishing()
    fishingLoop = task.spawn(function()
        while autoFishing do
            -- 1. ChargeFishingRod
            local args1 = { tick() }
            net:WaitForChild("RF/ChargeFishingRod"):InvokeServer(unpack(args1))
            

            -- 2. RequestFishingMinigameStarted
            local args = {
              math.random(-200,200)/100,
              math.random(-200,200)/100
              
            }
            net:WaitForChild("RF/RequestFishingMinigameStarted"):InvokeServer(unpack(args))
            task.wait(3) -- durasi minigame

            -- 3. FishingCompleted
            net:WaitForChild("RE/FishingCompleted"):FireServer()
            
        end
    end)
end

-- Klik Auto Equip Rod â†’ eksekusi equip via
AutoEquipBtn.MouseButton1Click:Connect(function()
    local args = { 1 } -- ganti 1 sesuai slot hotbar rod
    game:GetService("ReplicatedStorage")
        :WaitForChild("Packages")
        :WaitForChild("_Index")
        :WaitForChild("sleitnick_net@0.2.0")
        :WaitForChild("net")
        :WaitForChild("RE/EquipToolFromHotbar")
        :FireServer(unpack(args))
end)

-- Toggle ON/OFF
AutoFishingBtn.MouseButton1Click:Connect(function()
    autoFishing = not autoFishing
    if autoFishing then
        AutoFishingBtn.Text = "Auto Fishing: ON"
        AutoFishingBtn.TextColor3 = Color3.fromRGB(0,255,0)
        startFishing()
    else
        AutoFishingBtn.Text = "Auto Fishing: OFF"
        AutoFishingBtn.TextColor3 = Color3.fromRGB(255,255,255)
        if fishingLoop then
            task.cancel(fishingLoop)
        end
    end
end)
