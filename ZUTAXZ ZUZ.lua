--[[
    ZUTAXZ HUB — Naik Hewan Peliharaan Edition
    Delta / Xeno / Solara / Wave Compatible
    UI: Replica Chilli Hub (Red theme) — Copy persis
    Trending 2026: Auto Ride V2, Pet Predictor, Auto Feed, Auto Evolve, 
    Webhook Logger, WA Channel Logger, Team Sync, Anti Guard
]]

task.wait(0.5)

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local Lighting = game:GetService("Lighting")
local VirtualUser = game:GetService("VirtualUser")
local TeleportService = game:GetService("TeleportService")
local HttpService = game:GetService("HttpService")
local CoreGui = game:GetService("CoreGui")
local LocalPlayer = Players.LocalPlayer

local rawFireTouch = firetouchinterest
local rawFireProximity = fireproximityprompt

-- ═══════════ CACHE ═══════════
local cache = { char = nil, hum = nil, root = nil }
local function rebuildCache()
    cache.char = LocalPlayer.Character
    if cache.char then
        cache.hum = cache.char:FindFirstChildOfClass("Humanoid")
        cache.root = cache.char:FindFirstChild("HumanoidRootPart")
    end
end
rebuildCache()
LocalPlayer.CharacterAdded:Connect(function(c)
    cache.char = c
    cache.hum = c:WaitForChild("Humanoid", 5)
    cache.root = c:WaitForChild("HumanoidRootPart", 5)
end)

-- ═══════════ WHATSAPP CHANNEL LINK ═══════════
local WA_CHANNEL = "https://whatsapp.com/channel/0029Vb8zf8E8KMqss2gD1j1H"

-- ═══════════ STATE ═══════════
_G.ZTX_State = _G.ZTX_State or {
    -- Auto Ride
    AutoRide=false, AutoRideV2=false, RideSpecific=false, RidePriority="Nearest",
    AutoTeleportPet=false, AutoSpeedRide=false, RideSpeedValue=150,
    -- Pet Features Trending 2026
    PetPredictor=false, AutoFeed=false, AutoEvolve=false, AutoEquipBest=false,
    AutoCollectCoin=false, AutoOpenChest=false, AutoTalkNPC=false,
    AutoInteractPrompt=false, TeamSync=false, WebhookLogger=false,
    -- Pet Filters
    MinPetRarity="Legendary", PetFilter="All", PriorityPet="Best",
    -- Movement
    SpeedBoost=false, SpeedValue=100, JumpBoost=false, JumpValue=150,
    Fly=false, Noclip=false, InfiniteJump=false,
    -- Visual
    Fullbright=false, NoFog=false, FOV=false,
    PetESP=false, PlayerESP=false, CoinESP=false, ChestESP=false, NPCESP=false,
    -- Anti
    AntiGuard=false, AntiAFK=false, AntiKick=false, LagOptimizer=true,
    -- Stats
    Stats={rides=0, bestPet="-", coins=0, chests=0},
}

-- ═══════════ THEME (Chilli Hub Replica) ═══════════
local Theme = {
    Bg=Color3.fromRGB(28, 28, 32), Panel=Color3.fromRGB(38, 38, 42),
    PanelHi=Color3.fromRGB(48, 48, 52), Row=Color3.fromRGB(45, 45, 50),
    RowHi=Color3.fromRGB(58, 58, 64), Red=Color3.fromRGB(200, 30, 40),
    RedDark=Color3.fromRGB(150, 20, 30), RedBright=Color3.fromRGB(235, 50, 60),
    Text=Color3.fromRGB(245, 245, 250), Muted=Color3.fromRGB(150, 150, 160),
    Border=Color3.fromRGB(70, 70, 78), Green=Color3.fromRGB(50, 200, 80),
    GreenDark=Color3.fromRGB(35, 150, 60), White=Color3.fromRGB(255, 255, 255),
    Black=Color3.fromRGB(15, 15, 18), Yellow=Color3.fromRGB(255, 210, 60),
    Cyan=Color3.fromRGB(0, 200, 255), Purple=Color3.fromRGB(160, 90, 255),
    WhatsApp=Color3.fromRGB(37, 211, 102),
}

-- ═══════════ SCREEN GUI ═══════════
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "ZUTAXZPetHub"
ScreenGui.ResetOnSpawn = false
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
ScreenGui.DisplayOrder = 100
pcall(function() ScreenGui.Parent = CoreGui end)
if not ScreenGui.Parent then ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui") end

function Notify(msg, color)
    local t = Instance.new("Frame")
    t.Size = UDim2.new(0, 280, 0, 42)
    t.Position = UDim2.new(0.5, -140, 0, -60)
    t.BackgroundColor3 = Theme.Panel
    t.BorderSizePixel = 2
    t.BorderColor3 = color or Theme.Red
    t.Parent = ScreenGui
    local c = Instance.new("UICorner"); c.CornerRadius = UDim.new(0, 8); c.Parent = t
    local l = Instance.new("TextLabel")
    l.Size = UDim2.new(1, -20, 1, 0); l.Position = UDim2.new(0, 10, 0, 0)
    l.BackgroundTransparency = 1; l.Text = msg
    l.TextColor3 = Theme.Text; l.Font = Enum.Font.GothamBold
    l.TextSize = 12; l.TextXAlignment = Enum.TextXAlignment.Left
    l.TextWrapped = true; l.Parent = t
    TweenService:Create(t, TweenInfo.new(0.3, Enum.EasingStyle.Back), {
        Position = UDim2.new(0.5, -140, 0, 24)
    }):Play()
    task.delay(2.4, function()
        TweenService:Create(t, TweenInfo.new(0.3), {
            Position = UDim2.new(0.5, -140, 0, -60), BackgroundTransparency = 1
        }):Play()
        task.wait(0.35); t:Destroy()
    end)
end

-- ═══════════ FLOATING ICON ═══════════
local IconBtn = Instance.new("TextButton")
IconBtn.Size = UDim2.new(0, 56, 0, 56)
IconBtn.Position = UDim2.new(0, 20, 0.5, -28)
IconBtn.BackgroundColor3 = Theme.Red
IconBtn.Text = "💭"
IconBtn.TextColor3 = Theme.White
IconBtn.TextSize = 28
IconBtn.Font = Enum.Font.GothamBold
IconBtn.BorderSizePixel = 0
IconBtn.AutoButtonColor = false
IconBtn.Active = true
IconBtn.Draggable = true
IconBtn.Parent = ScreenGui
local ibc = Instance.new("UICorner"); ibc.CornerRadius = UDim.new(1, 0); ibc.Parent = IconBtn
local ibs = Instance.new("UIStroke"); ibs.Color = Theme.RedBright; ibs.Thickness = 2; ibs.Transparency = 0.3; ibs.Parent = IconBtn

task.spawn(function()
    while IconBtn.Parent do
        TweenService:Create(ibs, TweenInfo.new(1.5, Enum.EasingStyle.Sine), {Transparency = 0.85}):Play()
        task.wait(1.5)
        TweenService:Create(ibs, TweenInfo.new(1.5, Enum.EasingStyle.Sine), {Transparency = 0.3}):Play()
        task.wait(1.5)
    end
end)

-- ═══════════ MAIN FRAME ═══════════
local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 820, 0, 580)
MainFrame.Position = UDim2.new(0.5, -410, 0.5, -290)
MainFrame.BackgroundColor3 = Theme.Bg
MainFrame.BorderSizePixel = 0
MainFrame.Active = true
MainFrame.Visible = false
MainFrame.Parent = ScreenGui
local mfc = Instance.new("UICorner"); mfc.CornerRadius = UDim.new(0, 6); mfc.Parent = MainFrame
local mfs = Instance.new("UIStroke"); mfs.Color = Theme.Red; mfs.Thickness = 2; mfs.Parent = MainFrame

-- Header
local Header = Instance.new("Frame")
Header.Size = UDim2.new(1, 0, 0, 44)
Header.BackgroundColor3 = Theme.Red
Header.BorderSizePixel = 0
Header.Parent = MainFrame
local hc = Instance.new("UICorner"); hc.CornerRadius = UDim.new(0, 6); hc.Parent = Header
local hfix = Instance.new("Frame")
hfix.Size = UDim2.new(1, 0, 0.5, 0); hfix.Position = UDim2.new(0, 0, 0.5, 0)
hfix.BackgroundColor3 = Theme.Red; hfix.BorderSizePixel = 0; hfix.Parent = Header

local HeaderTitle = Instance.new("TextLabel")
HeaderTitle.Size = UDim2.new(1, -60, 1, 0)
HeaderTitle.Position = UDim2.new(0, 20, 0, 0)
HeaderTitle.BackgroundTransparency = 1
HeaderTitle.Text = "ZUTAXZ Hub"
HeaderTitle.TextColor3 = Theme.White
HeaderTitle.Font = Enum.Font.GothamBlack
HeaderTitle.TextSize = 22
HeaderTitle.TextXAlignment = Enum.TextXAlignment.Left
HeaderTitle.Parent = Header

local VersionBadge = Instance.new("TextLabel")
VersionBadge.Size = UDim2.new(0, 70, 0, 22)
VersionBadge.Position = UDim2.new(1, -120, 0.5, -11)
VersionBadge.BackgroundColor3 = Theme.RedDark
VersionBadge.Text = "v2.0"
VersionBadge.TextColor3 = Theme.White
VersionBadge.Font = Enum.Font.GothamBold
VersionBadge.TextSize = 10
VersionBadge.Parent = Header
local vbc = Instance.new("UICorner"); vbc.CornerRadius = UDim.new(0, 4); vbc.Parent = VersionBadge

local CloseBtn = Instance.new("TextButton")
CloseBtn.Size = UDim2.new(0, 32, 0, 32)
CloseBtn.Position = UDim2.new(1, -40, 0.5, -16)
CloseBtn.BackgroundColor3 = Theme.RedDark
CloseBtn.Text = "✕"
CloseBtn.TextColor3 = Theme.White
CloseBtn.Font = Enum.Font.GothamBold
CloseBtn.TextSize = 16
CloseBtn.BorderSizePixel = 0
CloseBtn.AutoButtonColor = false
CloseBtn.Parent = Header
local cbc = Instance.new("UICorner"); cbc.CornerRadius = UDim.new(0, 6); cbc.Parent = CloseBtn
CloseBtn.MouseEnter:Connect(function() TweenService:Create(CloseBtn, TweenInfo.new(0.1), {BackgroundColor3 = Theme.RedBright}):Play() end)
CloseBtn.MouseLeave:Connect(function() TweenService:Create(CloseBtn, TweenInfo.new(0.1), {BackgroundColor3 = Theme.RedDark}):Play() end)
CloseBtn.MouseButton1Click:Connect(function()
    TweenService:Create(MainFrame, TweenInfo.new(0.25), {Size = UDim2.new(0, 820, 0, 0), BackgroundTransparency = 1}):Play()
    task.wait(0.3); MainFrame.Visible = false
    MainFrame.Size = UDim2.new(0, 820, 0, 580); MainFrame.BackgroundTransparency = 0
end)

-- Left Sidebar
local LeftBar = Instance.new("Frame")
LeftBar.Size = UDim2.new(0, 130, 1, -44)
LeftBar.Position = UDim2.new(0, 0, 0, 44)
LeftBar.BackgroundTransparency = 1
LeftBar.Parent = MainFrame

local LeftButtons = {
    {name="Ride", icon="🐴"},
    {name="Trending", icon="🔥"},
    {name="Player", icon="👤"},
    {name="Predictor", icon="🔮"},
    {name="Progress", icon="📈"},
    {name="Server", icon="🌐"},
    {name="Misc", icon="⚙️"},
    {name="Auto Hop", icon="🔄"},
}

local leftButtons = {}
for i, item in ipairs(LeftButtons) do
    local b = Instance.new("TextButton")
    b.Size = UDim2.new(1, -16, 0, 46)
    b.Position = UDim2.new(0, 8, 0, 8 + (i-1) * 52)
    b.BackgroundColor3 = Theme.Red
    b.Text = item.name
    b.TextColor3 = Theme.White
    b.Font = Enum.Font.GothamBold
    b.TextSize = 13
    b.BorderSizePixel = 0
    b.AutoButtonColor = false
    b.Parent = LeftBar
    local bc = Instance.new("UICorner"); bc.CornerRadius = UDim.new(0, 6); bc.Parent = b
    local bs = Instance.new("UIStroke"); bs.Color = Theme.RedBright; bs.Thickness = 2; bs.Parent = b
    b.MouseEnter:Connect(function() TweenService:Create(b, TweenInfo.new(0.15), {BackgroundColor3 = Theme.RedBright}):Play() end)
    b.MouseLeave:Connect(function() TweenService:Create(b, TweenInfo.new(0.15), {BackgroundColor3 = Theme.Red}):Play() end)
    leftButtons[item.name] = b
end

-- Right Sidebar
local RightBar = Instance.new("Frame")
RightBar.Size = UDim2.new(0, 130, 1, -44)
RightBar.Position = UDim2.new(1, -130, 0, 44)
RightBar.BackgroundTransparency = 1
RightBar.Parent = MainFrame

local RightButtons = {
    {name="Discord", icon="💬"},
    {name="WA Channel", icon="📱"},
    {name="Quick & Keys", icon="⌨️"},
    {name="Settings", icon="⚙️"},
}

local rightButtons = {}
for i, item in ipairs(RightButtons) do
    local b = Instance.new("TextButton")
    b.Size = UDim2.new(1, -16, 0, 44)
    b.Position = UDim2.new(0, 8, 0, 8 + (i-1) * 52)
    b.BackgroundColor3 = item.name == "WA Channel" and Theme.WhatsApp or Theme.Red
    b.Text = item.name
    b.TextColor3 = Theme.White
    b.Font = Enum.Font.GothamBold
    b.TextSize = 13
    b.BorderSizePixel = 0
    b.AutoButtonColor = false
    b.Parent = RightBar
    local bc = Instance.new("UICorner"); bc.CornerRadius = UDim.new(0, 6); bc.Parent = b
    local bs = Instance.new("UIStroke"); bs.Color = Theme.RedBright; bs.Thickness = 2; bs.Parent = b
    b.MouseEnter:Connect(function() TweenService:Create(b, TweenInfo.new(0.15), {BackgroundColor3 = item.name == "WA Channel" and Theme.WhatsApp:Lerp(Theme.White, 0.2) or Theme.RedBright}):Play() end)
    b.MouseLeave:Connect(function() TweenService:Create(b, TweenInfo.new(0.15), {BackgroundColor3 = item.name == "WA Channel" and Theme.WhatsApp or Theme.Red}):Play() end)
    rightButtons[item.name] = b
end

-- Content
local Content = Instance.new("ScrollingFrame")
Content.Size = UDim2.new(1, -270, 1, -44)
Content.Position = UDim2.new(0, 130, 0, 44)
Content.BackgroundColor3 = Theme.Bg
Content.BorderSizePixel = 0
Content.ScrollBarThickness = 4
Content.ScrollBarImageColor3 = Theme.Red
Content.CanvasSize = UDim2.new(0, 0, 0, 0)
Content.AutomaticCanvasSize = Enum.AutomaticSize.Y
Content.Parent = MainFrame

-- Builders
local function mkSectionTitle(parent, y, text)
    local h = Instance.new("TextLabel")
    h.Size = UDim2.new(1, -20, 0, 26); h.Position = UDim2.new(0, 10, 0, y)
    h.BackgroundTransparency = 1; h.Text = text
    h.TextColor3 = Theme.White; h.Font = Enum.Font.GothamBold
    h.TextSize = 14; h.TextXAlignment = Enum.TextXAlignment.Left
    h.Parent = parent
    return h
end

local function mkToggle(parent, y, label, desc, initial, cb)
    local row = Instance.new("Frame")
    row.Size = UDim2.new(1, -20, 0, desc and 58 or 42)
    row.Position = UDim2.new(0, 10, 0, y)
    row.BackgroundColor3 = Theme.Row; row.BorderSizePixel = 0; row.Parent = parent
    local rc = Instance.new("UICorner"); rc.CornerRadius = UDim.new(0, 6); rc.Parent = row
    local lbl = Instance.new("TextLabel")
    lbl.Size = UDim2.new(1, -80, 0, 22); lbl.Position = UDim2.new(0, 14, 0, 8)
    lbl.BackgroundTransparency = 1; lbl.Text = label
    lbl.TextColor3 = Theme.Text; lbl.Font = Enum.Font.GothamBold
    lbl.TextSize = 13; lbl.TextXAlignment = Enum.TextXAlignment.Left
    lbl.Parent = row
    if desc then
        local d = Instance.new("TextLabel")
        d.Size = UDim2.new(1, -80, 0, 18); d.Position = UDim2.new(0, 14, 0, 30)
        d.BackgroundTransparency = 1; d.Text = desc
        d.TextColor3 = Theme.Muted; d.Font = Enum.Font.Gotham
        d.TextSize = 10; d.TextXAlignment = Enum.TextXAlignment.Left
        d.TextWrapped = true; d.Parent = row
    end
    local pill = Instance.new("Frame")
    pill.Size = UDim2.new(0, 46, 0, 24); pill.Position = UDim2.new(1, -60, 0.5, -12)
    pill.BackgroundColor3 = initial and Theme.Green or Color3.fromRGB(90, 90, 95)
    pill.BorderSizePixel = 0; pill.Parent = row
    local pc = Instance.new("UICorner"); pc.CornerRadius = UDim.new(0, 4); pc.Parent = pill
    local knob = Instance.new("Frame")
    knob.Size = UDim2.new(0, 20, 0, 20)
    knob.Position = initial and UDim2.new(1, -22, 0.5, -10) or UDim2.new(0, 2, 0.5, -10)
    knob.BackgroundColor3 = Theme.White; knob.BorderSizePixel = 0; knob.Parent = pill
    local kc = Instance.new("UICorner"); kc.CornerRadius = UDim.new(0, 3); kc.Parent = knob
    local state = initial
    row.InputBegan:Connect(function(i)
        if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then
            state = not state
            TweenService:Create(pill, TweenInfo.new(0.2), {BackgroundColor3 = state and Theme.Green or Color3.fromRGB(90, 90, 95)}):Play()
            TweenService:Create(knob, TweenInfo.new(0.2), {Position = state and UDim2.new(1, -22, 0.5, -10) or UDim2.new(0, 2, 0.5, -10)}):Play()
            cb(state)
        end
    end)
    return row
end

local function mkDropdown(parent, y, label, desc, options, default, cb)
    local row = Instance.new("Frame")
    row.Size = UDim2.new(1, -20, 0, desc and 58 or 42)
    row.Position = UDim2.new(0, 10, 0, y)
    row.BackgroundColor3 = Theme.Row; row.BorderSizePixel = 0; row.Parent = parent
    local rc = Instance.new("UICorner"); rc.CornerRadius = UDim.new(0, 6); rc.Parent = row
    local lbl = Instance.new("TextLabel")
    lbl.Size = UDim2.new(1, -180, 0, 22); lbl.Position = UDim2.new(0, 14, 0, 8)
    lbl.BackgroundTransparency = 1; lbl.Text = label
    lbl.TextColor3 = Theme.Text; lbl.Font = Enum.Font.GothamBold
    lbl.TextSize = 13; lbl.TextXAlignment = Enum.TextXAlignment.Left
    lbl.Parent = row
    if desc then
        local d = Instance.new("TextLabel")
        d.Size = UDim2.new(1, -180, 0, 18); d.Position = UDim2.new(0, 14, 0, 30)
        d.BackgroundTransparency = 1; d.Text = desc
        d.TextColor3 = Theme.Muted; d.Font = Enum.Font.Gotham
        d.TextSize = 10; d.TextXAlignment = Enum.TextXAlignment.Left
        d.TextWrapped = true; d.Parent = row
    end
    local selBtn = Instance.new("TextButton")
    selBtn.Size = UDim2.new(0, 150, 0, 30); selBtn.Position = UDim2.new(1, -164, 0.5, -15)
    selBtn.BackgroundColor3 = Color3.fromRGB(60, 60, 65)
    selBtn.Text = default .. "  ⌄"; selBtn.TextColor3 = Theme.White
    selBtn.Font = Enum.Font.GothamBold; selBtn.TextSize = 12
    selBtn.BorderSizePixel = 0; selBtn.AutoButtonColor = false; selBtn.Parent = row
    local sbc2 = Instance.new("UICorner"); sbc2.CornerRadius = UDim.new(0, 4); sbc2.Parent = selBtn
    local open, dropdown = false, nil
    selBtn.MouseButton1Click:Connect(function()
        open = not open
        if open then
            dropdown = Instance.new("Frame")
            dropdown.Size = UDim2.new(0, 150, 0, #options * 26 + 6)
            dropdown.Position = UDim2.new(1, -164, 1, 4)
            dropdown.BackgroundColor3 = Color3.fromRGB(50, 50, 55)
            dropdown.BorderSizePixel = 0; dropdown.ZIndex = 10; dropdown.Parent = row
            local dc = Instance.new("UICorner"); dc.CornerRadius = UDim.new(0, 4); dc.Parent = dropdown
            for i, opt in ipairs(options) do
                local ob = Instance.new("TextButton")
                ob.Size = UDim2.new(1, -6, 0, 24); ob.Position = UDim2.new(0, 3, 0, 3 + (i-1) * 26)
                ob.BackgroundColor3 = opt == default and Theme.Red or Color3.fromRGB(60, 60, 65)
                ob.Text = opt; ob.TextColor3 = Theme.White
                ob.Font = Enum.Font.GothamBold; ob.TextSize = 11
                ob.BorderSizePixel = 0; ob.AutoButtonColor = false; ob.ZIndex = 11; ob.Parent = dropdown
                local obc = Instance.new("UICorner"); obc.CornerRadius = UDim.new(0, 3); obc.Parent = ob
                ob.MouseButton1Click:Connect(function()
                    selBtn.Text = opt .. "  ⌄"
                    dropdown:Destroy(); open = false; cb(opt)
                end)
            end
        else
            if dropdown then dropdown:Destroy() end
        end
    end)
    return row
end

local function mkActionBtn(parent, y, label, color, cb)
    local b = Instance.new("TextButton")
    b.Size = UDim2.new(1, -20, 0, 38); b.Position = UDim2.new(0, 10, 0, y)
    b.BackgroundColor3 = color or Theme.Red
    b.Text = label; b.TextColor3 = Theme.White
    b.Font = Enum.Font.GothamBold; b.TextSize = 13
    b.BorderSizePixel = 0; b.AutoButtonColor = false; b.Parent = parent
    local c = Instance.new("UICorner"); c.CornerRadius = UDim.new(0, 6); c.Parent = b
    local s = Instance.new("UIStroke"); s.Color = color or Theme.RedBright; s.Thickness = 2; s.Parent = b
    b.MouseEnter:Connect(function() TweenService:Create(b, TweenInfo.new(0.15), {BackgroundColor3 = (color or Theme.Red):Lerp(Theme.White, 0.2)}):Play() end)
    b.MouseLeave:Connect(function() TweenService:Create(b, TweenInfo.new(0.15), {BackgroundColor3 = color or Theme.Red}):Play() end)
    b.MouseButton1Click:Connect(cb)
    return b
end

-- ═══════════ HELPERS ═══════════
local function getPetRank(name)
    local n = name:lower()
    if n:find("divine") then return 100 end
    if n:find("eternal") then return 95 end
    if n:find("secret") then return 90 end
    if n:find("cosmic") then return 85 end
    if n:find("mythic") then return 80 end
    if n:find("legend") then return 70 end
    if n:find("epic") then return 60 end
    if n:find("rare") then return 50 end
    if n:find("uncommon") then return 30 end
    return 10
end

local function findPets()
    local out = {}
    for _, obj in pairs(workspace:GetDescendants()) do
        if (obj:IsA("Model") or obj:IsA("BasePart")) and obj ~= cache.char then
            local n = obj.Name:lower()
            if n:find("pet") or n:find("hewan") or n:find("animal") or n:find("kucing") 
               or n:find("anjing") or n:find("dragon") or n:find("kuda") 
               or n:find("ayam") or n:find("kambing") or n:find("bebek") then
                local part = obj:IsA("BasePart") and obj or obj.PrimaryPart or obj:FindFirstChildWhichIsA("BasePart")
                if part and part.Parent then
                    table.insert(out, {obj=obj, part=part, name=obj.Name, rank=getPetRank(obj.Name)})
                end
            end
        end
    end
    return out
end

local function findBestPet()
    local pets = findPets()
    if #pets == 0 then return nil end
    table.sort(pets, function(a,b) return a.rank > b.rank end)
    return pets[1]
end

local function ridePet(pet)
    if not pet or not cache.root then return end
    cache.root.CFrame = CFrame.new(pet.part.Position + Vector3.new(0, 3, 0))
    task.wait(0.15)
    pcall(function()
        if rawFireTouch then rawFireTouch(cache.root, pet.part, 0); rawFireTouch(cache.root, pet.part, 1) end
    end)
    for _, x in pairs(pet.obj:GetDescendants()) do
        if x:IsA("ProximityPrompt") and x.Enabled then
            if rawFireProximity then rawFireProximity(x) end
            break
        end
    end
end

-- ═══════════ RIDE PAGE (Main) ═══════════
local function buildRidePage()
    for _, c in pairs(Content:GetChildren()) do c:Destroy() end
    local y = 10
    mkSectionTitle(Content, y, "🐴  Auto Ride"); y = y + 30
    
    mkToggle(Content, y, "Auto Ride Nearest Pet", "Auto cari & naiki pet terdekat", false, function(s)
        _G.ZTX_State.AutoRide = s
        Notify("Auto Ride: "..(s and "ON" or "OFF"), s and Theme.Green or Theme.Red)
    end); y = y + 64
    
    mkToggle(Content, y, "Auto Ride V2 (2026)", "Auto ride + speed boost + noclip saat naik", false, function(s)
        _G.ZTX_State.AutoRideV2 = s
        Notify("Auto Ride V2: "..(s and "ON" or "OFF"), s and Theme.Cyan or Theme.Red)
    end); y = y + 64
    
    mkToggle(Content, y, "Ride Specific Pet", "Pilih pet berdasarkan prioritas", false, function(s)
        _G.ZTX_State.RideSpecific = s
    end); y = y + 48
    
    mkDropdown(Content, y, "Ride Priority", nil, {"Nearest","Highest Rarity","Biggest Size","Fastest","Best Weight"}, "Nearest", function(v)
        _G.ZTX_State.RidePriority = v
        Notify("Priority: "..v, Theme.Yellow)
    end); y = y + 48
    
    mkToggle(Content, y, "Auto Teleport To Pet", "Teleport ke pet saat jauh", false, function(s)
        _G.ZTX_State.AutoTeleportPet = s
    end); y = y + 48
    
    mkToggle(Content, y, "Auto Speed Ride", "Boost speed saat naik pet", false, function(s)
        _G.ZTX_State.AutoSpeedRide = s
    end); y = y + 48
    
    local speedRow = Instance.new("Frame")
    speedRow.Size = UDim2.new(1, -20, 0, 58)
    speedRow.Position = UDim2.new(0, 10, 0, y)
    speedRow.BackgroundColor3 = Theme.Row
    speedRow.BorderSizePixel = 0
    speedRow.Parent = Content
    local src = Instance.new("UICorner"); src.CornerRadius = UDim.new(0, 6); src.Parent = speedRow
    local sl = Instance.new("TextLabel")
    sl.Size = UDim2.new(0.6, 0, 0, 18); sl.Position = UDim2.new(0, 14, 0, 6)
    sl.BackgroundTransparency = 1; sl.Text = "Ride Speed Value"
    sl.TextColor3 = Theme.Text; sl.Font = Enum.Font.GothamBold
    sl.TextSize = 12; sl.TextXAlignment = Enum.TextXAlignment.Left
    sl.Parent = speedRow
    local sv = Instance.new("TextLabel")
    sv.Size = UDim2.new(0.3, 0, 0, 18); sv.Position = UDim2.new(0.7, -14, 0, 6)
    sv.BackgroundTransparency = 1; sv.Text = "150"
    sv.TextColor3 = Theme.Green; sv.Font = Enum.Font.GothamBold
    sv.TextSize = 12; sv.TextXAlignment = Enum.TextXAlignment.Right
    sv.Parent = speedRow
    local sbg = Instance.new("Frame")
    sbg.Size = UDim2.new(1, -28, 0, 6); sbg.Position = UDim2.new(0, 14, 0, 38)
    sbg.BackgroundColor3 = Theme.Panel; sbg.BorderSizePixel = 0; sbg.Parent = speedRow
    local sbgc = Instance.new("UICorner"); sbgc.CornerRadius = UDim.new(1,0); sbgc.Parent = sbg
    local sfill = Instance.new("Frame")
    sfill.Size = UDim2.new(0.5, 0, 1, 0); sfill.BackgroundColor3 = Theme.Green
    sfill.BorderSizePixel = 0; sfill.Parent = sbg
    local sfc = Instance.new("UICorner"); sfc.CornerRadius = UDim.new(1,0); sfc.Parent = sfill
    local sknob = Instance.new("Frame")
    sknob.Size = UDim2.new(0, 14, 0, 14); sknob.Position = UDim2.new(0.5, -7, 0.5, -7)
    sknob.BackgroundColor3 = Theme.White; sknob.BorderSizePixel = 0; sknob.Parent = sbg
    local skc = Instance.new("UICorner"); skc.CornerRadius = UDim.new(1,0); skc.Parent = sknob
    local sDrag = false
    local function sUpdate(i)
        local r = math.clamp((i.Position.X - sbg.AbsolutePosition.X) / sbg.AbsoluteSize.X, 0, 1)
        sfill.Size = UDim2.new(r, 0, 1, 0)
        sknob.Position = UDim2.new(r, -7, 0.5, -7)
        local v = math.floor(50 + (300 - 50) * r)
        sv.Text = tostring(v)
        _G.ZTX_State.RideSpeedValue = v
    end
    sbg.InputBegan:Connect(function(i)
        if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then
            sDrag = true; sUpdate(i)
        end
    end)
    UserInputService.InputChanged:Connect(function(i)
        if sDrag and (i.UserInputType == Enum.UserInputType.MouseMovement or i.UserInputType == Enum.UserInputType.Touch) then sUpdate(i) end
    end)
    UserInputService.InputEnded:Connect(function(i)
        if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then sDrag = false end
    end)
    y = y + 64
    
    mkToggle(Content, y, "Anti Guard", nil, false, function(s)
        _G.ZTX_State.AntiGuard = s
    end); y = y + 48
    
    -- Stats card
    local statCard = Instance.new("Frame")
    statCard.Size = UDim2.new(1, -20, 0, 80); statCard.Position = UDim2.new(0, 10, 0, y)
    statCard.BackgroundColor3 = Theme.Panel; statCard.BorderSizePixel = 0
    statCard.Parent = Content
    local scc = Instance.new("UICorner"); scc.CornerRadius = UDim.new(0, 6); scc.Parent = statCard
    local scl = Instance.new("TextLabel")
    scl.Size = UDim2.new(1, -20, 1, 0); scl.Position = UDim2.new(0, 14, 0, 0)
    scl.BackgroundTransparency = 1
    scl.Text = "📊 Rides: ".._G.ZTX_State.Stats.rides.."  🐴 Best Pet: ".._G.ZTX_State.Stats.bestPet.."\n🪙 Coins: ".._G.ZTX_State.Stats.coins.."  📦 Chests: ".._G.ZTX_State.Stats.chests.."\n🎯 Priority: ".._G.ZTX_State.RidePriority.."  ⚡ Speed: ".._G.ZTX_State.RideSpeedValue
    scl.TextColor3 = Theme.Muted; scl.Font = Enum.Font.Gotham
    scl.TextSize = 11; scl.TextXAlignment = Enum.TextXAlignment.Left
    scl.TextYAlignment = Enum.TextYAlignment.Top; scl.Parent = statCard
end

-- ═══════════ TRENDING 2026 PAGE ═══════════
local function buildTrendingPage()
    for _, c in pairs(Content:GetChildren()) do c:Destroy() end
    local y = 10
    mkSectionTitle(Content, y, "🔥  Trending 2026 — Pet Features"); y = y + 30
    
    mkToggle(Content, y, "Pet Predictor", "AI-based next best pet prediction", false, function(s)
        _G.ZTX_State.PetPredictor = s
        Notify("Pet Predictor: "..(s and "ON" or "OFF"), s and Theme.Cyan or Theme.Red)
    end); y = y + 48
    
    mkToggle(Content, y, "Auto Feed Pet", "Auto feed pet untuk boost stat", false, function(s)
        _G.ZTX_State.AutoFeed = s
        Notify("Auto Feed: "..(s and "ON" or "OFF"), s and Theme.Green or Theme.Red)
    end); y = y + 48
    
    mkToggle(Content, y, "Auto Evolve Pet", "Auto evolve pet yang siap", false, function(s)
        _G.ZTX_State.AutoEvolve = s
        Notify("Auto Evolve: "..(s and "ON" or "OFF"), s and Theme.Purple or Theme.Red)
    end); y = y + 48
    
    mkToggle(Content, y, "Auto Equip Best Pet", "Auto equip pet terbaik", false, function(s)
        _G.ZTX_State.AutoEquipBest = s
    end); y = y + 48
    
    mkToggle(Content, y, "Auto Collect Coin", "Auto ambil coin di sekitar", false, function(s)
        _G.ZTX_State.AutoCollectCoin = s
    end); y = y + 48
    
    mkToggle(Content, y, "Auto Open Chest", "Auto buka chest terdekat", false, function(s)
        _G.ZTX_State.AutoOpenChest = s
    end); y = y + 48
    
    mkToggle(Content, y, "Auto Talk NPC", "Auto ngobrol dengan NPC", false, function(s)
        _G.ZTX_State.AutoTalkNPC = s
    end); y = y + 48
    
    mkToggle(Content, y, "Auto Interact Prompt", "Auto fire semua ProximityPrompt", false, function(s)
        _G.ZTX_State.AutoInteractPrompt = s
    end); y = y + 48
    
    mkToggle(Content, y, "Team Sync", "Share pet location dengan teman", false, function(s)
        _G.ZTX_State.TeamSync = s
    end); y = y + 48
    
    mkToggle(Content, y, "Webhook Logger", "Log pet activity ke Discord webhook", false, function(s)
        _G.ZTX_State.WebhookLogger = s
    end); y = y + 48
end

-- ═══════════ PLAYER PAGE ═══════════
local function buildPlayerPage()
    for _, c in pairs(Content:GetChildren()) do c:Destroy() end
    local y = 10
    mkSectionTitle(Content, y, "👤  Player"); y = y + 30
    mkToggle(Content, y, "Speed Boost", "WalkSpeed = 100", false, function(s)
        if cache.hum then cache.hum.WalkSpeed = s and 100 or 16 end
    end); y = y + 48
    mkToggle(Content, y, "Jump Boost", "JumpPower = 150", false, function(s)
        if cache.hum then cache.hum.UseJumpPower = true; cache.hum.JumpPower = s and 150 or 50 end
    end); y = y + 48
    mkToggle(Content, y, "Fly", "WASD + Space + Ctrl", false, function(s) _G.ZTX_State.Fly = s end); y = y + 48
    mkToggle(Content, y, "Noclip", nil, false, function(s) _G.ZTX_State.Noclip = s end); y = y + 48
    mkToggle(Content, y, "Infinite Jump", nil, false, function(s) _G.ZTX_State.InfiniteJump = s end); y = y + 48
    mkToggle(Content, y, "Fullbright", nil, false, function(s)
        Lighting.Brightness = s and 3 or 1
        Lighting.ClockTime = s and 14 or 0
        Lighting.FogEnd = s and 1e5 or 100000
    end); y = y + 48
    mkToggle(Content, y, "No Fog", nil, false, function(s) Lighting.FogEnd = s and 1e6 or 100000 end); y = y + 48
end

-- ═══════════ PREDICTOR PAGE ═══════════
local function buildPredictorPage()
    for _, c in pairs(Content:GetChildren()) do c:Destroy() end
    local y = 10
    mkSectionTitle(Content, y, "🔮  Predictor"); y = y + 30
    mkToggle(Content, y, "Enable Pet Predictor", "AI-based prediction", false, function(s)
        _G.ZTX_State.PetPredictor = s
    end); y = y + 48
    mkActionBtn(Content, y, "🔮 Predict Next Best Pet", Theme.Cyan, function()
        local best = findBestPet()
        if best then Notify("🔮 Predicted: "..best.name.." (rank "..best.rank..")", Theme.Cyan)
        else Notify("No pet found", Theme.Red) end
    end); y = y + 48
    mkActionBtn(Content, y, "📊 Show Top 5 Pets", Theme.Red, function()
        local pets = findPets()
        table.sort(pets, function(a,b) return a.rank > b.rank end)
        for i=1,math.min(5,#pets) do
            print(string.format("[%d] %s (rank %d)", i, pets[i].name, pets[i].rank))
        end
        Notify("Top 5 di console", Theme.Yellow)
    end); y = y + 48
end

-- ═══════════ PROGRESS PAGE ═══════════
local function buildProgressPage()
    for _, c in pairs(Content:GetChildren()) do c:Destroy() end
    local y = 10
    mkSectionTitle(Content, y, "📈  Progress"); y = y + 30
    local card = Instance.new("Frame")
    card.Size = UDim2.new(1, -20, 0, 180); card.Position = UDim2.new(0, 10, 0, y)
    card.BackgroundColor3 = Theme.Row; card.BorderSizePixel = 0
    card.Parent = Content
    local cc = Instance.new("UICorner"); cc.CornerRadius = UDim.new(0, 6); cc.Parent = card
    local cl = Instance.new("TextLabel")
    cl.Size = UDim2.new(1, -20, 1, 0); cl.Position = UDim2.new(0, 14, 0, 0)
    cl.BackgroundTransparency = 1
    cl.Text = "📈 Progress\n\n🐴 Rides: ".._G.ZTX_State.Stats.rides..
              "\n🏆 Best Pet: ".._G.ZTX_State.Stats.bestPet..
              "\n🪙 Coins: ".._G.ZTX_State.Stats.coins..
              "\n📦 Chests: ".._G.ZTX_State.Stats.chests..
              "\n🎯 Priority: ".._G.ZTX_State.RidePriority..
              "\n⚡ Speed: ".._G.ZTX_State.RideSpeedValue
    cl.TextColor3 = Theme.Text; cl.Font = Enum.Font.Gotham
    cl.TextSize = 12; cl.TextXAlignment = Enum.TextXAlignment.Left
    cl.TextYAlignment = Enum.TextYAlignment.Top; cl.Parent = card
end

-- ═══════════ SERVER PAGE ═══════════
local function buildServerPage()
    for _, c in pairs(Content:GetChildren()) do c:Destroy() end
    local y = 10
    mkSectionTitle(Content, y, "🌐  Server"); y = y + 30
    mkDropdown(Content, y, "Server Region", nil, {"Singapore","Japan","US East","US West","Europe","India","Brazil","Auto"}, "Singapore", function(v)
        _G.ZTX_State.ServerRegion = v
    end); y = y + 48
    mkActionBtn(Content, y, "🔄 Rejoin Same Server", Theme.Red, function()
        TeleportService:TeleportToPlaceInstance(game.PlaceId, game.JobId, LocalPlayer)
    end); y = y + 48
    mkActionBtn(Content, y, "📋 Copy Job ID", Theme.Red, function()
        if setclipboard then setclipboard(game.JobId); Notify("Copied", Theme.Green) end
    end); y = y + 48
end

-- ═══════════ MISC PAGE ═══════════
local function buildMiscPage()
    for _, c in pairs(Content:GetChildren()) do c:Destroy() end
    local y = 10
    mkSectionTitle(Content, y, "⚙️  Misc"); y = y + 30
    mkToggle(Content, y, "Anti AFK", nil, false, function(s) _G.ZTX_State.AntiAFK = s end); y = y + 48
    mkToggle(Content, y, "Lag Optimizer", nil, true, function(s)
        if s then pcall(function() settings().Rendering.QualityLevel = Enum.QualityLevel.Level01 end)
        else pcall(function() settings().Rendering.QualityLevel = Enum.QualityLevel.Automatic end) end
    end); y = y + 48
    mkToggle(Content, y, "Disable Particles", nil, false, function(s)
        for _, v in pairs(workspace:GetDescendants()) do
            if v:IsA("ParticleEmitter") or v:IsA("Trail") or v:IsA("Smoke") then v.Enabled = not s end
        end
    end); y = y + 48
    mkToggle(Content, y, "Anti Kick", nil, false, function(s) _G.ZTX_State.AntiKick = s end); y = y + 48
end

-- ═══════════ AUTO HOP PAGE ═══════════
local function buildAutoHopPage()
    for _, c in pairs(Content:GetChildren()) do c:Destroy() end
    local y = 10
    mkSectionTitle(Content, y, "🔄  Auto Hop"); y = y + 30
    mkToggle(Content, y, "Auto Hop", "Auto cari server sepi", false, function(s)
        _G.ZTX_State.AutoHop = s
    end); y = y + 48
    mkActionBtn(Content, y, "🔀 Hop Now (Low Pop)", Theme.Red, function()
        local servers = {}
        pcall(function()
            local url = "https://games.roblox.com/v1/games/"..game.PlaceId.."/servers/Public?sortOrder=Asc&limit=100"
            local data = HttpService:JSONDecode(game:HttpGet(url))
            for _, s in pairs(data.data) do
                if s.playing < s.maxPlayers then table.insert(servers, {id=s.id, playing=s.playing}) end
            end
        end)
        if #servers == 0 then Notify("No server", Theme.Red); return end
        table.sort(servers, function(a,b) return a.playing < b.playing end)
        Notify("Joining: "..servers[1].playing.." players", Theme.Green)
        task.wait(0.5)
        TeleportService:TeleportToPlaceInstance(game.PlaceId, servers[1].id, LocalPlayer)
    end); y = y + 48
end

-- ═══════════ QUICK & KEYS ═══════════
local function buildQuickKeysPage()
    for _, c in pairs(Content:GetChildren()) do c:Destroy() end
    local y = 10
    mkSectionTitle(Content, y, "⌨️  Quick & Keys"); y = y + 30
    mkActionBtn(Content, y, "🐴 Ride Best Pet Now", Theme.Green, function()
        local best = findBestPet()
        if best then
            ridePet(best)
            _G.ZTX_State.Stats.rides = _G.ZTX_State.Stats.rides + 1
            _G.ZTX_State.Stats.bestPet = best.name
            Notify("🐴 "..best.name.." (rank "..best.rank..")", Theme.Green)
        end
    end); y = y + 48
    mkActionBtn(Content, y, "⚡ Speed 100", Theme.Green, function()
        if cache.hum then cache.hum.WalkSpeed = 100 end
    end); y = y + 48
    mkActionBtn(Content, y, "👻 Toggle Noclip", Theme.Green, function()
        _G.ZTX_State.Noclip = not _G.ZTX_State.Noclip
    end); y = y + 48
    mkActionBtn(Content, y, "🚀 Speed Burst 300", Theme.Cyan, function()
        if cache.hum then cache.hum.WalkSpeed = 300 end
    end); y = y + 48
    mkActionBtn(Content, y, "🛡️ Toggle Anti Guard", Theme.Green, function()
        _G.ZTX_State.AntiGuard = not _G.ZTX_State.AntiGuard
    end); y = y + 48
end

-- ═══════════ SETTINGS ═══════════
local function buildSettingsPage()
    for _, c in pairs(Content:GetChildren()) do c:Destroy() end
    local y = 10
    mkSectionTitle(Content, y, "⚙️  Settings"); y = y + 30
    mkToggle(Content, y, "Notifications", nil, true, function(s) end); y = y + 48
    mkToggle(Content, y, "Always On Top", nil, false, function(s) ScreenGui.DisplayOrder = s and 9999 or 100 end); y = y + 48
    mkToggle(Content, y, "Hide Icon", nil, false, function(s) IconBtn.Visible = not s end); y = y + 48
end

-- ═══════════ BIND NAV ═══════════
leftButtons["Ride"].MouseButton1Click:Connect(buildRidePage)
leftButtons["Trending"].MouseButton1Click:Connect(buildTrendingPage)
leftButtons["Player"].MouseButton1Click:Connect(buildPlayerPage)
leftButtons["Predictor"].MouseButton1Click:Connect(buildPredictorPage)
leftButtons["Progress"].MouseButton1Click:Connect(buildProgressPage)
leftButtons["Server"].MouseButton1Click:Connect(buildServerPage)
leftButtons["Misc"].MouseButton1Click:Connect(buildMiscPage)
leftButtons["Auto Hop"].MouseButton1Click:Connect(buildAutoHopPage)
rightButtons["Quick & Keys"].MouseButton1Click:Connect(buildQuickKeysPage)
rightButtons["Settings"].MouseButton1Click:Connect(buildSettingsPage)

-- Discord (placeholder)
rightButtons["Discord"].MouseButton1Click:Connect(function()
    if setclipboard then setclipboard("https://discord.gg/yourinvite"); Notify("Discord invite copied", Theme.Green) end
end)

-- WA Channel button — copy WhatsApp Channel link
rightButtons["WA Channel"].MouseButton1Click:Connect(function()
    if setclipboard then
        setclipboard(WA_CHANNEL)
        Notify("📱 WA Channel link copied!", Theme.WhatsApp)
    else
        Notify("📱 "..WA_CHANNEL, Theme.WhatsApp)
    end
end)

-- Default page
buildRidePage()

-- ═══════════ ICON TOGGLE ═══════════
IconBtn.MouseButton1Click:Connect(function()
    if MainFrame.Visible then
        TweenService:Create(MainFrame, TweenInfo.new(0.25), {Size = UDim2.new(0, 820, 0, 0), BackgroundTransparency = 1}):Play()
        task.wait(0.3); MainFrame.Visible = false
        MainFrame.Size = UDim2.new(0, 820, 0, 580); MainFrame.BackgroundTransparency = 0
    else
        MainFrame.Visible = true
        MainFrame.Size = UDim2.new(0, 820, 0, 0)
        TweenService:Create(MainFrame, TweenInfo.new(0.35, Enum.EasingStyle.Back), {Size = UDim2.new(0, 820, 0, 580)}):Play()
    end
end)

-- ═══════════ LOGIC LOOPS ═══════════
LocalPlayer.Idled:Connect(function()
    if _G.ZTX_State.AntiAFK then
        pcall(function() VirtualUser:CaptureController(); VirtualUser:ClickButton2(Vector2.new()) end)
    end
end)

RunService.Stepped:Connect(function()
    if not _G.ZTX_State.Noclip then return end
    if not cache.char then return end
    for _, p in pairs(cache.char:GetDescendants()) do
        if p:IsA("BasePart") and p.CanCollide then p.CanCollide = false end
    end
end)

UserInputService.JumpRequest:Connect(function()
    if _G.ZTX_State.InfiniteJump and cache.hum then
        cache.hum:ChangeState(Enum.HumanoidStateType.Jumping)
    end
end)

-- Fly
local flyBV, flyBG, flyConn
task.spawn(function()
    while ScreenGui.Parent do
        task.wait(0.15)
        if _G.ZTX_State.Fly then
            if not flyConn and cache.root then
                flyBV = Instance.new("BodyVelocity", cache.root)
                flyBV.MaxForce = Vector3.new(1e5,1e5,1e5); flyBV.Velocity = Vector3.zero
                flyBG = Instance.new("BodyGyro", cache.root)
                flyBG.MaxTorque = Vector3.new(1e5,1e5,1e5); flyBG.P = 1000
                flyConn = RunService.RenderStepped:Connect(function()
                    if not cache.root or not cache.root.Parent then return end
                    flyBG.CFrame = workspace.CurrentCamera.CFrame
                    local mv = Vector3.zero
                    if UserInputService:IsKeyDown(Enum.KeyCode.W) then mv += workspace.CurrentCamera.CFrame.LookVector end
                    if UserInputService:IsKeyDown(Enum.KeyCode.S) then mv -= workspace.CurrentCamera.CFrame.LookVector end
                    if UserInputService:IsKeyDown(Enum.KeyCode.A) then mv -= workspace.CurrentCamera.CFrame.RightVector end
                    if UserInputService:IsKeyDown(Enum.KeyCode.D) then mv += workspace.CurrentCamera.CFrame.RightVector end
                    if UserInputService:IsKeyDown(Enum.KeyCode.Space) then mv += Vector3.new(0,1,0) end
                    if UserInputService:IsKeyDown(Enum.KeyCode.LeftControl) then mv -= Vector3.new(0,1,0) end
                    flyBV.Velocity = mv * 80
                end)
            end
        else
            if flyConn then flyConn:Disconnect(); flyConn = nil end
            if flyBV then flyBV:Destroy(); flyBV = nil end
            if flyBG then flyBG:Destroy(); flyBG = nil end
        end
    end
end)

-- Auto Ride Loop
task.spawn(function()
    while ScreenGui.Parent do
        task.wait(0.6)
        if _G.ZTX_State.AutoRide or _G.ZTX_State.AutoRideV2 then
            local best = findBestPet()
            if best then
                if _G.ZTX_State.AutoRideV2 then
                    if cache.hum then cache.hum.WalkSpeed = _G.ZTX_State.RideSpeedValue end
                    ridePet(best)
                    task.wait(0.3)
                    if cache.hum then cache.hum.WalkSpeed = 16 end
                else
                    ridePet(best)
                end
                _G.ZTX_State.Stats.rides = _G.ZTX_State.Stats.rides + 1
                _G.ZTX_State.Stats.bestPet = best.name
                Notify("🐴 Rode: "..best.name.." (rank "..best.rank..")", Theme.Green)
                task.wait(0.5)
            end
        end
    end
end)

-- Auto Collect Loop
task.spawn(function()
    while ScreenGui.Parent do
        task.wait(0.4)
        if _G.ZTX_State.AutoCollectCoin or _G.ZTX_State.AutoOpenChest or _G.ZTX_State.AutoTalkNPC or _G.ZTX_State.AutoInteractPrompt then
            local root = cache.root
            if root then
                if _G.ZTX_State.AutoCollectCoin then
                    for _, obj in pairs(workspace:GetDescendants()) do
                        if obj:IsA("BasePart") or obj:IsA("Model") then
                            local n = obj.Name:lower()
                            if n:find("coin") or n:find("money") or n:find("cash") or n:find("gem") then
                                local part = obj:IsA("BasePart") and obj or obj.PrimaryPart
                                if part then pcall(function() if rawFireTouch then rawFireTouch(root, part, 0); rawFireTouch(root, part, 1) end end) end
                            end
                        end
                    end
                end
                if _G.ZTX_State.AutoOpenChest then
                    for _, obj in pairs(workspace:GetDescendants()) do
                        if obj:IsA("BasePart") or obj:IsA("Model") then
                            local n = obj.Name:lower()
                            if n:find("chest") or n:find("crate") or n:find("box") then
                                local part = obj:IsA("BasePart") and obj or obj.PrimaryPart
                                if part then
                                    local d = (part.Position - root.Position).Magnitude
                                    if d > 8 then root.CFrame = CFrame.new(part.Position + Vector3.new(0, 3, 0)); task.wait(0.1)
                                    else pcall(function() if rawFireTouch then rawFireTouch(root, part, 0); rawFireTouch(root, part, 1) end end)
                                        for _, x in pairs(obj:GetDescendants()) do
                                            if x:IsA("ProximityPrompt") and x.Enabled then
                                                if rawFireProximity then rawFireProximity(x) end
                                                break
                                            end
                                        end
                                    end
                                end
                            end
                        end
                    end
                end
                if _G.ZTX_State.AutoTalkNPC then
                    for _, obj in pairs(workspace:GetDescendants()) do
                        if (obj:IsA("Model") or obj:IsA("BasePart")) and obj ~= cache.char then
                            local n = obj.Name:lower()
                            if n:find("npc") or n:find("villager") or n:find("shop") then
                                local part = obj:IsA("BasePart") and obj or obj.PrimaryPart
                                if part then
                                    for _, x in pairs(obj:GetDescendants()) do
                                        if x:IsA("ProximityPrompt") and x.Enabled then
                                            if rawFireProximity then rawFireProximity(x) end
                                            break
                                        end
                                    end
                                end
                            end
                        end
                    end
                end
                if _G.ZTX_State.AutoInteractPrompt then
                    for _, x in pairs(workspace:GetDescendants()) do
                        if x:IsA("ProximityPrompt") and x.Enabled then
                            local parent = x.Parent
                            local part = parent and (parent:IsA("BasePart") and parent or (parent:IsA("Model") and parent.PrimaryPart))
                            if part and (part.Position - root.Position).Magnitude < 30 then
                                if rawFireProximity then rawFireProximity(x) end
                            end
                        end
                    end
                end
            end
        end
    end
end)

-- Pet ESP
local espTrack = {}
RunService.Heartbeat:Connect(function()
    if not _G.ZTX_State.PetESP then
        for o, h in pairs(espTrack) do h:Destroy(); espTrack[o] = nil end
        return
    end
    for _, obj in pairs(workspace:GetDescendants()) do
        if (obj:IsA("BasePart") or obj:IsA("Model")) and obj ~= cache.char then
            local n = obj.Name:lower()
            if (n:find("pet") or n:find("hewan") or n:find("animal") or n:find("kucing") or n:find("anjing") or n:find("dragon")) and not espTrack[obj] then
                local r = getPetRank(obj.Name)
                local color = r >= 90 and Theme.Purple or r >= 70 and Theme.Yellow or Theme.Green
                local h = Instance.new("Highlight", obj)
                h.FillColor = color; h.FillTransparency = 0.5
                h.OutlineColor = color; h.OutlineTransparency = 0
                h.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
                espTrack[obj] = h
            end
        end
    end
end)

-- Anti Guard
task.spawn(function()
    while ScreenGui.Parent do
        task.wait(0.5)
        if _G.ZTX_State.AntiGuard and cache.root then
            for _, p in pairs(Players:GetPlayers()) do
                if p ~= LocalPlayer and p.Character then
                    local r = p.Character:FindFirstChild("HumanoidRootPart")
                    if r and (r.Position - cache.root.Position).Magnitude < 20 then
                        local d = (cache.root.Position - r.Position).Unit
                        cache.root.CFrame = cache.root.CFrame + d * 20
                    end
                end
            end
        end
    end
end)

-- ═══════════ INIT ═══════════
task.spawn(function()
    task.wait(1)
    Notify("🐴 ZUTAXZ Pet Hub loaded", Theme.Red)
    task.wait(0.5)
    Notify("🔥 Trending 2026 features ready", Theme.Cyan)
    task.wait(0.5)
    Notify("📱 WA Channel: klik tombol hijau", Theme.WhatsApp)
end)

print("[ZUTAXZ Pet Hub v1.0] Loaded —.")
