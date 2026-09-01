-- MM2 Delta Ultimate | Full Build | Part 1/10
if not game:IsLoaded() then game.Loaded:Wait() end

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local Workspace = game:GetService("Workspace")
local UserInputService = game:GetService("UserInputService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TweenService = game:GetService("TweenService")
local VirtualUser = game:GetService("VirtualUser")
local Lighting = game:GetService("Lighting")
local HttpService = game:GetService("HttpService")
local LocalPlayer = Players.LocalPlayer
local Camera = Workspace.CurrentCamera

-- State
getgenv().MM2Delta = getgenv().MM2Delta or {
    Combat = {
        Aimbot = false, FOV = 150, Smooth = 0.15, OnlyMurderer = true,
        VisibleCheck = true, SilentAim = false, Wallbang = false,
        AutoShoot = false, AutoStab = false, KillAll = false,
        Spinbot = false, SpinSpeed = 25, SpeedGlitch = false
    },
    Visuals = {
        ESP = true, Boxes = true, Tracers = true, Names = true,
        Distance = true, Roles = true, GunDrop = true, MaxDistance = 2000,
        Shaders = false, ShaderMode = "Bloom", Fullbright = false,
        NoFog = false, CameraFOV = 70, Trail = false, AngelRing = false,
        JumpRipple = false, Cape = false, PinkGlass = false, ChinaHat = false
    },
    Movement = {
        WalkSpeed = 16, JumpPower = 50, NoClip = false,
        BunnyHop = false, AntiFling = false
    },
    Farm = {
        AutoCoins = false, Speed = 22, SafeHeight = 14
    },
    Troll = { Target = "", Mode = "Off" },
    Settings = { Lang = "RU", ShowFloat = false }
}
local State = getgenv().MM2Delta

-- Translations
local T = {
    RU = {
        Title = "MM2 Delta", Combat = "Бой", Visuals = "Визуал", Movement = "Движение",
        Farm = "Фарм", Troll = "Тролл", Settings = "Настройки",
        Aimbot = "Aimbot", FOV = "FOV Радиус", Smooth = "Сглаживание",
        OnlyMurderer = "Только Убийца", VisCheck = "Проверка стен",
        SilentAim = "Silent Aim", Wallbang = "Wallbang", AutoShoot = "Авто-Выстрел",
        AutoStab = "Авто-Удар", KillAll = "Kill All", Spinbot = "Spinbot",
        SpinSpeed = "Скорость Spin", SpeedGlitch = "Спидглич",
        ESPMaster = "ESP Мастер", Boxes = "Коробки", Tracers = "Линии",
        Names = "Имена", Dist = "Дистанция", RoleESP = "ESP Ролей",
        GunESP = "ESP Пистолета", MaxDist = "Макс дистанция",
        Shaders = "Шейдеры", ShaderMode = "Пресет", Fullbright = "Фулбрайт",
        NoFog = "Убрать туман", CamFOV = "FOV Камеры", Trail = "Трейл",
        AngelRing = "Ангельское кольцо", JumpRipple = "Круг прыжка",
        Cape = "Плащ", PinkGlass = "Розовое стекло", ChinaHat = "China Hat",
        WalkSpeed = "Скорость", JumpPower = "Прыжок", NoClip = "Ноуклип",
        BunnyHop = "Bunny Hop", AntiFling = "Анти-Флинг",
        AutoCoins = "Авто монеты", FarmSpeed = "Скорость фарма", SafeHeight = "Высота",
        TrollTarget = "Цель (ник)", TrollMode = "Режим", StopTroll = "Стоп тролл",
        Lang = "Язык", ShowFloat = "Плавающие кнопки", SaveCFG = "Сохранить CFG",
        LoadCFG = "Загрузить CFG", DelCFG = "Удалить CFG", CFGName = "Имя CFG",
        AimBtn = "AIM", FarmBtn = "FARM", KillBtn = "KILL", NoclipBtn = "CLIP"
    },
    EN = {
        Title = "MM2 Delta", Combat = "Combat", Visuals = "Visuals", Movement = "Move",
        Farm = "Farm", Troll = "Troll", Settings = "Settings",
        Aimbot = "Aimbot", FOV = "FOV Radius", Smooth = "Smoothing",
        OnlyMurderer = "Only Murderer", VisCheck = "VisCheck",
        SilentAim = "Silent Aim", Wallbang = "Wallbang", AutoShoot = "Auto Shoot",
        AutoStab = "Auto Stab", KillAll = "Kill All", Spinbot = "Spinbot",
        SpinSpeed = "Spin Speed", SpeedGlitch = "Speed Glitch",
        ESPMaster = "ESP Master", Boxes = "Boxes", Tracers = "Tracers",
        Names = "Names", Dist = "Distance", RoleESP = "Role ESP",
        GunESP = "Gun ESP", MaxDist = "Max Distance",
        Shaders = "Shaders", ShaderMode = "Preset", Fullbright = "Fullbright",
        NoFog = "No Fog", CamFOV = "Camera FOV", Trail = "Trail",
        AngelRing = "Angel Ring", JumpRipple = "Jump Ripple",
        Cape = "Cape", PinkGlass = "Pink Glass", ChinaHat = "China Hat",
        WalkSpeed = "WalkSpeed", JumpPower = "JumpPower", NoClip = "NoClip",
        BunnyHop = "Bunny Hop", AntiFling = "Anti Fling",
        AutoCoins = "Auto Coins", FarmSpeed = "Farm Speed", SafeHeight = "Safe H",
        TrollTarget = "Target name", TrollMode = "Mode", StopTroll = "Stop",
        Lang = "Language", ShowFloat = "Float Buttons", SaveCFG = "Save CFG",
        LoadCFG = "Load CFG", DelCFG = "Delete CFG", CFGName = "CFG Name",
        AimBtn = "AIM", FarmBtn = "FARM", KillBtn = "KILL", NoclipBtn = "CLIP"
    }
}
local function L(k) return T[State.Settings.Lang][k] or k end

-- Role detection
local function GetRole(player)
    if not player then return "Innocent" end
    local char = player.Character
    if not char then return "Innocent" end
    local bp = player:FindFirstChild("Backpack")
    if char:FindFirstChild("Knife") or (bp and bp:FindFirstChild("Knife")) then return "Murderer" end
    if char:FindFirstChild("Gun") or (bp and bp:FindFirstChild("Gun")) then return "Sheriff" end
    return "Innocent"
end

local function IsRoundActive()
    return Workspace:FindFirstChild("CoinContainer") ~= nil
        or Workspace:FindFirstChild("Coins") ~= nil
        or Workspace:FindFirstChild("Map") ~= nil
end
-- Part 2/10 — Notifications & ESP Engine

local NotifGui = Instance.new("ScreenGui")
NotifGui.Name = "DeltaNotifs"
NotifGui.ResetOnSpawn = false
NotifGui.Parent = game:GetService("CoreGui") or LocalPlayer:WaitForChild("PlayerGui")

local NotifContainer = Instance.new("Frame")
NotifContainer.Size = UDim2.new(0, 260, 1, -30)
NotifContainer.Position = UDim2.new(1, -280, 0, 20)
NotifContainer.BackgroundTransparency = 1
NotifContainer.Parent = NotifGui
local nlayout = Instance.new("UIListLayout", NotifContainer)
nlayout.VerticalAlignment = Enum.VerticalAlignment.Bottom
nlayout.Padding = UDim.new(0, 8)

local function Notify(title, text, color)
    task.spawn(function()
        local f = Instance.new("Frame")
        f.Size = UDim2.new(1, 0, 0, 56)
        f.BackgroundColor3 = Color3.fromRGB(40, 20, 30)
        f.BorderSizePixel = 0
        f.Parent = NotifContainer
        Instance.new("UICorner", f).CornerRadius = UDim.new(0, 8)
        local s = Instance.new("UIStroke", f)
        s.Color = color or Color3.fromRGB(255, 105, 180); s.Thickness = 1.5
        local tl = Instance.new("TextLabel", f)
        tl.Size = UDim2.new(1, -16, 0, 18)
        tl.Position = UDim2.new(0, 10, 0, 6)
        tl.BackgroundTransparency = 1; tl.Text = "◆ " .. title
        tl.TextColor3 = Color3.new(1,1,1); tl.Font = Enum.Font.GothamBold; tl.TextSize = 13
        tl.TextXAlignment = Enum.TextXAlignment.Left
        local tx = Instance.new("TextLabel", f)
        tx.Size = UDim2.new(1, -16, 1, -24)
        tx.Position = UDim2.new(0, 10, 0, 22)
        tx.BackgroundTransparency = 1; tx.Text = text
        tx.TextColor3 = Color3.fromRGB(230, 200, 210); tx.Font = Enum.Font.Gotham
        tx.TextSize = 11; tx.TextXAlignment = Enum.TextXAlignment.Left; tx.TextWrapped = true
        f.Position = UDim2.new(1, 60, 0, 0)
        TweenService:Create(f, TweenInfo.new(0.4, Enum.EasingStyle.Quint), {Position = UDim2.new(1, 0, 0, 0)}):Play()
        task.wait(4)
        TweenService:Create(f, TweenInfo.new(0.4, Enum.EasingStyle.Quint, Enum.EasingDirection.In), {Position = UDim2.new(1, 60, 0, 0)}):Play()
        task.wait(0.5); f:Destroy()
    end)
end

-- Drawing ESP
local ESPObjects = {}
local Highlights = {}
local GunHighlights = {}

local function Draw(class, props)
    local d = Drawing.new(class)
    for k, v in pairs(props) do d[k] = v end
    return d
end

local function InitESP(player)
    if player == LocalPlayer or ESPObjects[player] then return end
    ESPObjects[player] = {
        Box = Draw("Square", {Thickness = 1.2, Filled = false, Visible = false}),
        Tracer = Draw("Line", {Thickness = 1, From = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y), Visible = false}),
        Name = Draw("Text", {Size = 12, Center = true, Outline = true, Visible = false}),
        Dist = Draw("Text", {Size = 11, Center = true, Outline = true, Visible = false})
    }
end

local function KillESP(player)
    local set = ESPObjects[player]
    if not set then return end
    for _, obj in pairs(set) do obj:Remove() end
    ESPObjects[player] = nil
end

local function RoleColor(role)
    if role == "Murderer" then return Color3.fromRGB(255, 0, 0) end
    if role == "Sheriff" then return Color3.fromRGB(0, 100, 255) end
    return Color3.fromRGB(0, 255, 100)
end

local function RenderESP()
    for player, set in pairs(ESPObjects) do
        local render = false
        if player.Parent and player.Character and State.Visuals.ESP then
            local char = player.Character
            local hrp = char:FindFirstChild("HumanoidRootPart")
            local hum = char:FindFirstChildOfClass("Humanoid")
            local head = char:FindFirstChild("Head")
            if hrp and hum and hum.Health > 0 and head then
                local pos, onScreen = Camera:WorldToViewportPoint(hrp.Position)
                if onScreen then
                    local dist = (Camera.CFrame.Position - hrp.Position).Magnitude
                    if dist <= State.Visuals.MaxDistance then
                        render = true
                        local role = GetRole(player)
                        local color = RoleColor(role)
                        local top = Camera:WorldToViewportPoint((hrp.CFrame * CFrame.new(0, 3, 0)).Position)
                        local bottom = Camera:WorldToViewportPoint((hrp.CFrame * CFrame.new(0, -3, 0)).Position)
                        local h = math.abs(top.Y - bottom.Y)
                        local w = h * 0.55
                        set.Box.Visible = State.Visuals.Boxes
                        set.Box.Size = Vector2.new(w, h)
                        set.Box.Position = Vector2.new(pos.X - w / 2, pos.Y - h / 2)
                        set.Box.Color = color
                        set.Tracer.Visible = State.Visuals.Tracers
                        set.Tracer.To = Vector2.new(pos.X, pos.Y)
                        set.Tracer.Color = color
                        set.Name.Visible = State.Visuals.Names
                        set.Name.Text = player.Name .. " [" .. role .. "]"
                        set.Name.Position = Vector2.new(pos.X, top.Y - 16)
                        set.Name.Color = color
                        set.Dist.Visible = State.Visuals.Distance
                        set.Dist.Text = string.format("[%dm]", math.floor(dist))
                        set.Dist.Position = Vector2.new(pos.X, bottom.Y + 4)
                        set.Dist.Color = Color3.new(1, 1, 1)
                    end
                end
            end
        end
        if not render then for _, obj in pairs(set) do obj.Visible = false end end
    end
end

-- Highlight ESP
local function UpdateHighlights()
    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= LocalPlayer then
            local char = player.Character
            if char then
                local hl = Highlights[player]
                if State.Visuals.Roles and char:FindFirstChild("HumanoidRootPart") and char:FindFirstChildOfClass("Humanoid") and char:FindFirstChildOfClass("Humanoid").Health > 0 then
                    if not hl then
                        hl = Instance.new("Highlight")
                        hl.Name = "DeltaHL"; hl.Adornee = char
                        hl.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
                        hl.Parent = char; Highlights[player] = hl
                    end
                    local role = GetRole(player)
                    if role == "Murderer" then hl.FillColor = Color3.fromRGB(255, 0, 0)
                    elseif role == "Sheriff" then hl.FillColor = Color3.fromRGB(0, 100, 255)
                    else hl.FillColor = Color3.fromRGB(0, 255, 0) end
                    hl.FillTransparency = 0.4; hl.OutlineTransparency = 0; hl.Enabled = true
                else
                    if hl then hl:Destroy(); Highlights[player] = nil end
                end
            end
        end
    end
    if State.Visuals.GunDrop then
        for _, obj in ipairs(Workspace:GetChildren()) do
            if obj.Name == "GunDrop" and obj:IsA("BasePart") then
                if not GunHighlights[obj] then
                    local hl = Instance.new("Highlight")
                    hl.Adornee = obj; hl.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
                    hl.FillColor = Color3.fromRGB(255, 255, 0); hl.FillTransparency = 0.3
                    hl.Parent = obj; GunHighlights[obj] = hl
                end
            end
        end
    end
    for obj, hl in pairs(GunHighlights) do
        if not obj.Parent or not State.Visuals.GunDrop then hl:Destroy(); GunHighlights[obj] = nil end
    end
end
-- Part 3/10 — Aimbot & Hooks (FIXED: single hook, no continue)

local FOVCircle = Drawing.new("Circle")
FOVCircle.Visible = false; FOVCircle.Filled = false; FOVCircle.Thickness = 1.5
FOVCircle.Color = Color3.fromRGB(255, 105, 180); FOVCircle.NumSides = 64; FOVCircle.Transparency = 0.8
FOVCircle.Radius = State.Combat.FOV

local function GetAimTarget()
    local best = nil
    local shortest = State.Combat.FOV
    local center = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y / 2)
    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild("Head") then
            local hum = player.Character:FindFirstChildOfClass("Humanoid")
            if hum and hum.Health > 0 then
                local role = GetRole(player)
                if not (State.Combat.OnlyMurderer and role ~= "Murderer") then
                    local head = player.Character.Head
                    local pos, onScreen = Camera:WorldToViewportPoint(head.Position)
                    if onScreen then
                        local valid = true
                        if State.Combat.VisibleCheck then
                            local rp = RaycastParams.new()
                            rp.FilterDescendantsInstances = {LocalPlayer.Character}
                            rp.FilterType = Enum.RaycastFilterType.Blacklist
                            local res = Workspace:Raycast(Camera.CFrame.Position, head.Position - Camera.CFrame.Position, rp)
                            if res and not res.Instance:IsDescendantOf(player.Character) then valid = false end
                        end
                        if valid then
                            local d = (Vector2.new(pos.X, pos.Y) - center).Magnitude
                            if d < shortest then shortest = d; best = head end
                        end
                    end
                end
            end
        end
    end
    return best
end

-- SINGLE HOOK: AntiKick + SilentAim + Wallbang
local oldNamecall
oldNamecall = hookmetamethod(game, "__namecall", function(self, ...)
    local method = getnamecallmethod()
    local args = {...}
    
    if method == "Kick" or method == "kick" then
        return warn("[Delta] Kick blocked")
    end
    
    if State.Combat.SilentAim and method == "FireServer" then
        local name = tostring(self.Name):lower()
        if name:find("shoot") or name:find("fire") or name:find("gun") then
            local target = nil
            for _, p in ipairs(Players:GetPlayers()) do
                if p ~= LocalPlayer and GetRole(p) == "Murderer" and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
                    target = p.Character.HumanoidRootPart; break
                end
            end
            if target then
                for i = 1, #args do
                    local t = typeof(args[i])
                    if t == "Vector3" then args[i] = target.Position
                    elseif t == "CFrame" then args[i] = CFrame.new(target.Position) end
                end
                return oldNamecall(self, unpack(args))
            end
        end
    end
    
    if State.Combat.Wallbang and (method == "FindPartOnRay" or method == "FindPartOnRayWithIgnoreList" or method == "FindPartOnRayWithWhitelist") then
        return nil, nil, nil, nil
    end
    if State.Combat.Wallbang and method == "Raycast" then
        local res = oldNamecall(self, ...)
        if res and res.Instance then
            local p = res.Instance
            if p.Parent and Players:GetPlayerFromCharacter(p.Parent) then return res end
        end
        return nil
    end
    
    return oldNamecall(self, ...)
end)
-- Part 4/10 — Combat Loops

task.spawn(function()
    while true do
        task.wait(0.3)
        if State.Combat.AutoShoot and GetRole(LocalPlayer) == "Sheriff" then
            for _, p in ipairs(Players:GetPlayers()) do
                if p ~= LocalPlayer and GetRole(p) == "Murderer" and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
                    local gun = LocalPlayer.Character and (LocalPlayer.Character:FindFirstChild("Gun") or LocalPlayer.Backpack:FindFirstChild("Gun"))
                    if gun then
                        local rem = ReplicatedStorage:FindFirstChild("Remotes") or ReplicatedStorage
                        local shoot = rem:FindFirstChild("ShootGun") or rem:FindFirstChild("Shoot") or rem:FindFirstChild("Fire")
                        if shoot and shoot:IsA("RemoteEvent") then
                            shoot:FireServer(p.Character.HumanoidRootPart.Position, gun)
                        end
                    end
                    break
                end
            end
        end
    end
end)

task.spawn(function()
    while true do
        task.wait(0.1)
        if State.Combat.AutoStab and GetRole(LocalPlayer) == "Murderer" then
            local myChar = LocalPlayer.Character
            if myChar and myChar:FindFirstChild("HumanoidRootPart") then
                for _, p in ipairs(Players:GetPlayers()) do
                    if p ~= LocalPlayer and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
                        local tRoot = p.Character.HumanoidRootPart
                        local tHum = p.Character:FindFirstChildOfClass("Humanoid")
                        if tHum and tHum.Health > 0 and (myChar.HumanoidRootPart.Position - tRoot.Position).Magnitude < 20 then
                            myChar.HumanoidRootPart.CFrame = tRoot.CFrame * CFrame.new(0, 0, 2)
                            local knife = myChar:FindFirstChild("Knife")
                            if knife then
                                for _, v in ipairs(knife:GetDescendants()) do
                                    if v:IsA("RemoteEvent") then v:FireServer("Stab", tRoot.Position) end
                                end
                            end
                            task.wait(0.2)
                        end
                    end
                end
            end
        end
    end
end)

task.spawn(function()
    while true do
        task.wait(0.1)
        if State.Combat.KillAll and GetRole(LocalPlayer) == "Murderer" then
            local myChar = LocalPlayer.Character
            if myChar and myChar:FindFirstChild("HumanoidRootPart") then
                local knife = myChar:FindFirstChild("Knife") or LocalPlayer.Backpack:FindFirstChild("Knife")
                if knife then
                    if knife.Parent == LocalPlayer.Backpack then
                        myChar:FindFirstChildOfClass("Humanoid"):EquipTool(knife)
                    end
                    for _, p in ipairs(Players:GetPlayers()) do
                        if p ~= LocalPlayer and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
                            local tHum = p.Character:FindFirstChildOfClass("Humanoid")
                            local tRoot = p.Character.HumanoidRootPart
                            if tHum and tHum.Health > 0 then
                                local attempts = 0
                                while tHum.Health > 0 and attempts < 15 and State.Combat.KillAll do
                                    attempts = attempts + 1
                                    myChar.HumanoidRootPart.CFrame = tRoot.CFrame * CFrame.new(0, 0, 1.5)
                                    knife:Activate()
                                    for _, v in ipairs(knife:GetDescendants()) do
                                        if v:IsA("RemoteEvent") then v:FireServer() end
                                    end
                                    task.wait(0.05)
                                end
                            end
                        end
                    end
                end
            end
        end
    end
end)

-- Spinbot
task.spawn(function()
    while true do
        task.wait(0.1)
        if State.Combat.Spinbot and LocalPlayer.Character then
            local root = LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
            local hum = LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
            if root then
                if hum then hum.AutoRotate = false end
                local bav = root:FindFirstChild("DeltaSpin")
                if not bav then
                    bav = Instance.new("BodyAngularVelocity")
                    bav.Name = "DeltaSpin"
                    bav.MaxTorque = Vector3.new(0, 500000, 0)
                    bav.Parent = root
                end
                bav.AngularVelocity = Vector3.new(0, State.Combat.SpinSpeed, 0)
            end
        else
            if LocalPlayer.Character then
                local root = LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
                local hum = LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
                if hum then hum.AutoRotate = true end
                if root and root:FindFirstChild("DeltaSpin") then root.DeltaSpin:Destroy() end
            end
        end
    end
end)
-- Part 5/10 — Movement & AutoFarm

local NoClipConnection = nil
local function SetNoClip(enabled)
    State.Movement.NoClip = enabled
    if NoClipConnection then NoClipConnection:Disconnect() end
    if enabled then
        NoClipConnection = RunService.Stepped:Connect(function()
            local char = LocalPlayer.Character
            if not char then return end
            for _, part in ipairs(char:GetDescendants()) do
                if part:IsA("BasePart") then part.CanCollide = false end
            end
        end)
    else
        local char = LocalPlayer.Character
        if char then
            for _, part in ipairs(char:GetDescendants()) do
                if part:IsA("BasePart") then part.CanCollide = true end
            end
        end
    end
end

local function ApplyHumanoid()
    local char = LocalPlayer.Character
    if not char then return end
    local hum = char:FindFirstChildOfClass("Humanoid")
    if hum then
        hum.WalkSpeed = State.Movement.WalkSpeed
        hum.JumpPower = State.Movement.JumpPower
    end
end

-- AutoFarm
local function GetCoins()
    local t = {}
    local cc = Workspace:FindFirstChild("CoinContainer") or Workspace:FindFirstChild("Coins")
    if cc then
        for _, c in ipairs(cc:GetChildren()) do
            local p = c:IsA("BasePart") and c or c:FindFirstChild("CoinVisual") or c:FindFirstChildOfClass("BasePart")
            if p then table.insert(t, p) end
        end
    else
        for _, d in ipairs(Workspace:GetDescendants()) do
            if (d.Name == "CoinVisual" or d.Name == "Coin_Server" or d.Name == "Coin") and d:IsA("BasePart") then
                table.insert(t, d)
            end
        end
    end
    return t
end

task.spawn(function()
    while true do
        task.wait(0.4)
        if State.Farm.AutoCoins and IsRoundActive() and LocalPlayer.Character then
            local char = LocalPlayer.Character
            local hrp = char:FindFirstChild("HumanoidRootPart")
            local hum = char:FindFirstChildOfClass("Humanoid")
            if hrp and hum then
                local bv = hrp:FindFirstChild("FarmVel") or Instance.new("BodyVelocity")
                bv.Name = "FarmVel"
                bv.MaxForce = Vector3.new(1e9, 1e9, 1e9)
                bv.Velocity = Vector3.new(0, 0, 0)
                bv.Parent = hrp
                hum.PlatformStand = true
                
                for _, coin in ipairs(GetCoins()) do
                    if not State.Farm.AutoCoins then break end
                    if coin and coin.Parent then
                        local target = coin.Position
                        local hover = target + Vector3.new(0, State.Farm.SafeHeight, 0)
                        local dist = (hrp.Position - hover).Magnitude
                        local tm = math.clamp(dist / State.Farm.Speed, 0.2, 2.0)
                        local tw = TweenService:Create(hrp, TweenInfo.new(tm, Enum.EasingStyle.Sine, Enum.EasingDirection.Out), {CFrame = CFrame.new(hover)})
                        tw:Play()
                        tw.Completed:Wait()
                        if not State.Farm.AutoCoins then break end
                        hrp.CFrame = CFrame.new(target)
                        task.wait(0.1)
                        tw = TweenService:Create(hrp, TweenInfo.new(0.2), {CFrame = CFrame.new(hover)})
                        tw:Play()
                        tw.Completed:Wait()
                    end
                end
                
                if bv then bv:Destroy() end
                hum.PlatformStand = false
            end
        end
    end
end)
-- Part 6/10 — Visual Effects

local BloomEffect, CCEffect, SunRaysEffect, DOFEffect, BlurEffect, GlowEffect

local function ClearShaders()
    if BloomEffect then BloomEffect:Destroy(); BloomEffect = nil end
    if CCEffect then CCEffect:Destroy(); CCEffect = nil end
    if SunRaysEffect then SunRaysEffect:Destroy(); SunRaysEffect = nil end
    if DOFEffect then DOFEffect:Destroy(); DOFEffect = nil end
    if BlurEffect then BlurEffect:Destroy(); BlurEffect = nil end
    if GlowEffect then GlowEffect:Destroy(); GlowEffect = nil end
end

local function SetupShaders(mode)
    ClearShaders()
    if not State.Visuals.Shaders then return end
    local function mkBloom(i, s, th)
        local b = Instance.new("BloomEffect")
        b.Intensity = i; b.Size = s; b.Threshold = th; b.Parent = Lighting
        return b
    end
    local function mkCC()
        local c = Instance.new("ColorCorrectionEffect"); c.Parent = Lighting; return c
    end
    if mode == "Bloom" then BloomEffect = mkBloom(0.5, 16, 0.8)
    elseif mode == "Vibrant" then
        BloomEffect = mkBloom(0.3, 10, 0.8)
        CCEffect = mkCC(); CCEffect.Saturation = 0.3; CCEffect.Contrast = 0.15; CCEffect.Brightness = 0.1
    elseif mode == "Dreamy" then
        BloomEffect = mkBloom(0.7, 24, 0.8)
        CCEffect = mkCC(); CCEffect.TintColor = Color3.fromRGB(255, 200, 220); CCEffect.Saturation = -0.2
        SunRaysEffect = Instance.new("SunRaysEffect"); SunRaysEffect.Intensity = 0.3; SunRaysEffect.Spread = 0.5; SunRaysEffect.Parent = Lighting
    elseif mode == "Cinematic" then
        DOFEffect = Instance.new("DepthOfFieldEffect"); DOFEffect.FarIntensity = 0.8; DOFEffect.FocusDistance = 15; DOFEffect.InFocusRadius = 5; DOFEffect.NearIntensity = 0.2; DOFEffect.Parent = Lighting
        CCEffect = mkCC(); CCEffect.Contrast = 0.3; CCEffect.Saturation = 0.2; CCEffect.Brightness = -0.1
        BloomEffect = mkBloom(0.2, 8, 0.8)
    elseif mode == "Neon" then
        GlowEffect = Instance.new("BloomEffect"); GlowEffect.Intensity = 1.0; GlowEffect.Size = 40; GlowEffect.Threshold = 0.1; GlowEffect.Parent = Lighting
        CCEffect = mkCC(); CCEffect.Saturation = 0.5; CCEffect.Contrast = 0.2; CCEffect.TintColor = Color3.fromRGB(255, 100, 150)
    elseif mode == "VHS" then
        CCEffect = mkCC(); CCEffect.Saturation = -0.5; CCEffect.Contrast = 0.3; CCEffect.Brightness = -0.1
        BloomEffect = mkBloom(0.1, 4, 0.8)
        SunRaysEffect = Instance.new("SunRaysEffect"); SunRaysEffect.Intensity = 0.2; SunRaysEffect.Spread = 0.4; SunRaysEffect.Parent = Lighting
    elseif mode == "Soft Pink" then
        BloomEffect = mkBloom(0.6, 20, 0.8)
        CCEffect = mkCC(); CCEffect.TintColor = Color3.fromRGB(255, 182, 193); CCEffect.Saturation = -0.1; CCEffect.Brightness = 0.1
    elseif mode == "Retro" then
        CCEffect = mkCC(); CCEffect.Saturation = 0.1; CCEffect.Contrast = 0.2; CCEffect.Brightness = 0.05
        BloomEffect = mkBloom(0.4, 12, 0.8)
        BlurEffect = Instance.new("BlurEffect"); BlurEffect.Size = 4; BlurEffect.Parent = Lighting
    elseif mode == "Sunset" then
        CCEffect = mkCC(); CCEffect.TintColor = Color3.fromRGB(255, 150, 100); CCEffect.Saturation = 0.2
        BloomEffect = mkBloom(0.5, 16, 0.8)
        SunRaysEffect = Instance.new("SunRaysEffect"); SunRaysEffect.Intensity = 0.5; SunRaysEffect.Spread = 0.8; SunRaysEffect.Parent = Lighting
    end
end

-- Trail
local TrailFolder = nil
local function ToggleTrail(enabled)
    State.Visuals.Trail = enabled
    if not enabled then if TrailFolder then TrailFolder:Destroy(); TrailFolder = nil end return end
    local char = LocalPlayer.Character
    if not char then return end
    local hrp = char:FindFirstChild("HumanoidRootPart")
    if not hrp then return end
    TrailFolder = Instance.new("Folder", char); TrailFolder.Name = "DeltaTrail"
    local parts = {}
    for i = 1, 20 do
        local p = Instance.new("Part")
        p.Size = Vector3.new(0.6, 0.6, 0.6); p.Shape = Enum.PartType.Ball; p.Material = Enum.Material.Neon
        p.Color = Color3.fromRGB(255, 105, 180); p.Transparency = 1 - (i / 20)
        p.CanCollide = false; p.Anchored = true; p.Parent = TrailFolder
        table.insert(parts, {Part = p, Pos = hrp.Position})
    end
    task.spawn(function()
        local idx = 1
        while State.Visuals.Trail and TrailFolder and TrailFolder.Parent do
            if char:FindFirstChild("HumanoidRootPart") then
                local pos = char.HumanoidRootPart.Position
                local pd = parts[idx]
                if pd and pd.Part then pd.Part.Position = pos; pd.Pos = pos end
                idx = idx % #parts + 1
            end
            task.wait(0.05)
        end
    end)
end

-- Angel Ring
local AngelRingParts = {}
local function ToggleAngelRing(enabled)
    State.Visuals.AngelRing = enabled
    for _, p in ipairs(AngelRingParts) do if p then p:Destroy() end end
    AngelRingParts = {}
    if not enabled then return end
    local char = LocalPlayer.Character
    if not char then return end
    local head = char:FindFirstChild("Head")
    if not head then return end
    local folder = Instance.new("Folder", char); folder.Name = "DeltaAngel"
    local segs = 24; local rad = 1.2
    for i = 1, segs do
        local p = Instance.new("Part"); p.Size = Vector3.new(0.25, 0.08, 0.25); p.Shape = Enum.PartType.Ball
        p.Material = Enum.Material.Neon; p.Color = Color3.fromRGB(255, 105, 180); p.Transparency = 0.2
        p.CanCollide = false; p.Anchored = true; p.Parent = folder
        table.insert(AngelRingParts, p)
    end
    for i = 1, 10 do
        local p = Instance.new("Part"); p.Size = Vector3.new(0.12, 0.12, 0.12); p.Shape = Enum.PartType.Ball
        p.Material = Enum.Material.Neon; p.Color = Color3.fromRGB(255, 182, 193); p.Transparency = 0.3
        p.CanCollide = false; p.Anchored = true; p.Parent = folder
        table.insert(AngelRingParts, p)
    end
    task.spawn(function()
        local tick = 0
        while State.Visuals.AngelRing and folder.Parent == char do
            tick = tick + 0.03
            if char:FindFirstChild("Head") then
                local hpos = char.Head.CFrame
                for i, p in ipairs(AngelRingParts) do
                    if p.Parent then
                        if i <= segs then
                            local a = (i / segs) * math.pi * 2 + tick * 2
                            p.CFrame = hpos * CFrame.new(math.cos(a) * rad, 0.8 + math.sin(tick * 3 + i) * 0.1, math.sin(a) * rad)
                            p.Transparency = 0.2 + math.sin(tick * 2 + i * 0.5) * 0.1
                        else
                            local a = ((i - segs) / 10) * math.pi * 2 + tick * 1.5
                            local r2 = 0.4 + math.sin(tick * 2 + i) * 0.1
                            p.CFrame = hpos * CFrame.new(math.cos(a) * r2, 1.2 + math.sin(tick * 2.5 + (i - segs) * 0.7) * 0.1, math.sin(a) * r2)
                        end
                    end
                end
            end
            task.wait(0.03)
        end
        if folder and folder.Parent then folder:Destroy() end
    end)
end

-- Cape
local CapeModel = nil
local function SetupCape(char)
    if CapeModel then CapeModel:Destroy(); CapeModel = nil end
    if not State.Visuals.Cape then return end
    local torso = char:FindFirstChild("UpperTorso") or char:FindFirstChild("Torso")
    if not torso then return end
    local model = Instance.new("Model", char); model.Name = "DeltaCape"; CapeModel = model
    local base = Instance.new("Part", model); base.Name = "CapeRoot"; base.Size = Vector3.new(1.8, 0.2, 0.2)
    base.Transparency = 1; base.CanCollide = false
    local weld = Instance.new("WeldConstraint", base); weld.Part0 = torso; weld.Part1 = base
    base.CFrame = torso.CFrame * CFrame.new(0, 0.8, 0.6) * CFrame.Angles(math.rad(15), 0, 0)
    local prev = base; local capeSegs = 12; local capeParts = {}
    for i = 1, capeSegs do
        local s = Instance.new("Part", model); s.Name = "Cape" .. i; s.Size = Vector3.new(1.6, 0.12, 0.06)
        s.Color = Color3.fromRGB(255, 105, 180); s.Material = Enum.Material.SmoothPlastic; s.CanCollide = false
        local w = Instance.new("Weld", s); w.Part0 = prev; w.Part1 = s; w.C0 = CFrame.new(0, -0.1, 0.02); w.C1 = CFrame.new(0, 0.1, -0.02)
        table.insert(capeParts, s); prev = s
    end
    task.spawn(function()
        local tc = 0
        while CapeModel == model and model.Parent == char and State.Visuals.Cape do
            tc = tc + 0.15
            local vel = char:FindFirstChild("HumanoidRootPart") and char.HumanoidRootPart.AssemblyLinearVelocity.Magnitude or 0
            local wave = math.sin(tc * 4) * (0.05 + vel * 0.002)
            for idx, part in ipairs(capeParts) do
                local w = part:FindFirstChildOfClass("Weld")
                if w then w.C0 = CFrame.new(0, -0.1, 0.02) * CFrame.Angles(wave * (idx / capeSegs), 0, 0) end
            end
            task.wait(0.03)
        end
    end)
end

-- Pink Glass
local function TogglePinkGlass(enabled)
    State.Visuals.PinkGlass = enabled
    local char = LocalPlayer.Character
    if not char then return end
    for _, part in ipairs(char:GetDescendants()) do
        if part:IsA("BasePart") and part.Name ~= "HumanoidRootPart" then
            if enabled then part.Material = Enum.Material.Glass; part.Color = Color3.fromRGB(255, 105, 180); part.Transparency = 0.4
            else part.Material = Enum.Material.SmoothPlastic; part.Transparency = 0 end
        end
    end
end

-- China Hat
local ChinaHatObj = nil
local function CreateChinaHat(char)
    if ChinaHatObj then ChinaHatObj:Destroy(); ChinaHatObj = nil end
    if not State.Visuals.ChinaHat then return end
    local head = char:FindFirstChild("Head")
    if not head then return end
    local cone = Instance.new("Part"); cone.Size = Vector3.new(1, 1, 1); cone.Material = Enum.Material.Neon
    cone.Transparency = 0.2; cone.CanCollide = false; cone.Anchored = false; cone.Color = Color3.fromRGB(255, 105, 180)
    local mesh = Instance.new("SpecialMesh", cone); mesh.MeshType = Enum.MeshType.FileMesh; mesh.MeshId = "rbxassetid://1033714"; mesh.Scale = Vector3.new(1.7, 1.1, 1.7)
    local weld = Instance.new("Weld", cone); weld.Part0 = head; weld.Part1 = cone; weld.C0 = CFrame.new(0, 0.9, 0)
    local light = Instance.new("PointLight", cone); light.Color = Color3.fromRGB(255, 105, 180); light.Brightness = 0; light.Range = 12; light.Shadows = true
    cone.Parent = char; ChinaHatObj = cone
end

-- Jump Ripple
local function SetupJumpEffect(char)
    local hum = char:WaitForChild("Humanoid", 5)
    local hrp = char:WaitForChild("HumanoidRootPart", 5)
    if not hum or not hrp then return end
    local last = hum:GetState()
    hum.StateChanged:Connect(function(_, new)
        if not State.Visuals.JumpRipple then return end
        if new == Enum.HumanoidStateType.Jumping or (last == Enum.HumanoidStateType.Freefall and new == Enum.HumanoidStateType.Running) then
            local p = Instance.new("Part"); p.Anchored = true; p.CanCollide = false; p.Transparency = 0.3
            p.Size = Vector3.new(0.5, 0.1, 0.5); p.CFrame = CFrame.new(hrp.Position - Vector3.new(0, 3, 0)) * CFrame.Angles(math.rad(90), 0, 0)
            p.Color = Color3.fromRGB(255, 105, 180); p.Material = Enum.Material.Neon; p.Parent = Workspace
            Instance.new("CylinderMesh", p)
            TweenService:Create(p, TweenInfo.new(0.6, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Size = Vector3.new(0.5, 14, 14), Transparency = 1}):Play()
            task.delay(0.7, function() if p then p:Destroy() end end)
        end
        last = new
    end)
end
-- Part 7/10 — Trolling Engine

local TrollThread = nil
local TrollActive = false

local function StopTrolling()
    TrollActive = false
    if TrollThread then task.cancel(TrollThread); TrollThread = nil end
    local char = LocalPlayer.Character
    if char then
        local track = char:FindFirstChild("DeltaDanceAnim")
        if track then pcall(function() track:Stop() end); track:Destroy() end
    end
end

local function StartTrolling()
    StopTrolling()
    if State.Troll.Mode == "Off" or State.Troll.Target == "" then return end
    TrollActive = true
    TrollThread = task.spawn(function()
        while TrollActive do
            task.wait()
            pcall(function()
                local myChar = LocalPlayer.Character
                if not myChar then return end
                local myRoot = myChar:FindFirstChild("HumanoidRootPart")
                local hum = myChar:FindFirstChildOfClass("Humanoid")
                if not myRoot or not hum then return end
                local target = nil
                for _, p in ipairs(Players:GetPlayers()) do
                    if p.Name:lower() == State.Troll.Target:lower() or p.DisplayName:lower() == State.Troll.Target:lower() then
                        target = p; break
                    end
                end
                if not target or not target.Character then StopTrolling(); return end
                local tRoot = target.Character:FindFirstChild("HumanoidRootPart")
                local tHead = target.Character:FindFirstChild("Head")
                if not tRoot then return end
                for _, part in ipairs(myChar:GetDescendants()) do if part:IsA("BasePart") then part.CanCollide = false end end
                local mode = State.Troll.Mode
                if mode == "Jerk" then myRoot.CFrame = tRoot.CFrame * CFrame.new(0, -1, 1.2) * CFrame.Angles(math.rad(45), 0, 0)
                elseif mode == "Sit" and tHead then myRoot.CFrame = CFrame.new(tHead.Position + Vector3.new(0, 1.5, 0))
                elseif mode == "Stand" then myRoot.CFrame = CFrame.new(tRoot.Position + Vector3.new(2, 0, 2))
                elseif mode == "Dance" then
                    myRoot.CFrame = CFrame.new(tRoot.Position + Vector3.new(2, 0, 2))
                    if not myChar:FindFirstChild("DeltaDanceAnim") then
                        local anim = Instance.new("Animation"); anim.AnimationId = "rbxassetid://507771019"; anim.Name = "DeltaDanceAnim"
                        local track = hum:FindFirstChildOfClass("Animator"):LoadAnimation(anim); track:Play(); myChar.DeltaDanceAnim = track
                    end
                elseif mode == "Follow" then
                    if (myRoot.Position - tRoot.Position).Magnitude > 3 then myRoot.CFrame = CFrame.new(tRoot.Position + Vector3.new(0, 0, 3)) end
                elseif mode == "Climb" then myRoot.CFrame = CFrame.new(tRoot.Position + Vector3.new(0, 3, 0)) end
            end)
            task.wait(0.05)
        end
    end)
end
-- Part 8/10 — UI Construction

local Gui = Instance.new("ScreenGui")
Gui.Name = "MM2DeltaUltimate"
Gui.ResetOnSpawn = false
Gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
Gui.Parent = game:GetService("CoreGui") or LocalPlayer:WaitForChild("PlayerGui")

local MainFrame = Instance.new("Frame", Gui)
MainFrame.Size = UDim2.new(0, 540, 0, 400)
MainFrame.Position = UDim2.new(0.5, -270, 0.5, -200)
MainFrame.BackgroundColor3 = Color3.fromRGB(35, 15, 25)
MainFrame.BorderSizePixel = 0
MainFrame.Active = true
Instance.new("UICorner", MainFrame).CornerRadius = UDim.new(0, 10)
local MainStroke = Instance.new("UIStroke", MainFrame)
MainStroke.Color = Color3.fromRGB(255, 105, 180); MainStroke.Thickness = 1.5

local TopBar = Instance.new("Frame", MainFrame)
TopBar.Size = UDim2.new(1, 0, 0, 38)
TopBar.BackgroundColor3 = Color3.fromRGB(25, 10, 20)
TopBar.BorderSizePixel = 0
Instance.new("UICorner", TopBar).CornerRadius = UDim.new(0, 10)

local TitleLbl = Instance.new("TextLabel", TopBar)
TitleLbl.Size = UDim2.new(1, -70, 1, 0); TitleLbl.Position = UDim2.new(0, 14, 0, 0)
TitleLbl.BackgroundTransparency = 1; TitleLbl.Text = L("Title")
TitleLbl.TextColor3 = Color3.fromRGB(255, 182, 193); TitleLbl.Font = Enum.Font.GothamBold
TitleLbl.TextSize = 15; TitleLbl.TextXAlignment = Enum.TextXAlignment.Left

local CloseBtn = Instance.new("TextButton", TopBar)
CloseBtn.Size = UDim2.new(0, 28, 0, 28); CloseBtn.Position = UDim2.new(1, -33, 0, 5)
CloseBtn.BackgroundColor3 = Color3.fromRGB(200, 50, 80); CloseBtn.Text = "✕"
CloseBtn.TextColor3 = Color3.new(1,1,1); CloseBtn.Font = Enum.Font.GothamBold; CloseBtn.TextSize = 13
Instance.new("UICorner", CloseBtn).CornerRadius = UDim.new(0, 6)

local MinBtn = Instance.new("TextButton", TopBar)
MinBtn.Size = UDim2.new(0, 28, 0, 28); MinBtn.Position = UDim2.new(1, -66, 0, 5)
MinBtn.BackgroundColor3 = Color3.fromRGB(80, 80, 80); MinBtn.Text = "−"
MinBtn.TextColor3 = Color3.new(1,1,1); MinBtn.Font = Enum.Font.GothamBold; MinBtn.TextSize = 16
Instance.new("UICorner", MinBtn).CornerRadius = UDim.new(0, 6)

local Sidebar = Instance.new("Frame", MainFrame)
Sidebar.Size = UDim2.new(0, 120, 1, -38); Sidebar.Position = UDim2.new(0, 0, 0, 38)
Sidebar.BackgroundColor3 = Color3.fromRGB(20, 10, 30); Sidebar.BorderSizePixel = 0

local Content = Instance.new("Frame", MainFrame)
Content.Size = UDim2.new(1, -120, 1, -38); Content.Position = UDim2.new(0, 120, 0, 38)
Content.BackgroundTransparency = 1

-- Draggable
local drag, dInput, mPos, fPos
TopBar.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        drag = true; mPos = input.Position; fPos = MainFrame.Position
        input.Changed:Connect(function() if input.UserInputState == Enum.UserInputState.End then drag = false end end)
    end
end)
TopBar.InputChanged:Connect(function(input) if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then dInput = input end end)
UserInputService.InputChanged:Connect(function(input)
    if input == dInput and drag then
        local d = input.Position - mPos
        MainFrame.Position = UDim2.new(fPos.X.Scale, fPos.X.Offset + d.X, fPos.Y.Scale, fPos.Y.Offset + d.Y)
    end
end)

-- Floating buttons frame
local FloatFrame = Instance.new("Frame", Gui)
FloatFrame.Name = "DeltaFloat"; FloatFrame.Size = UDim2.new(0, 220, 0, 60)
FloatFrame.Position = UDim2.new(0.5, -110, 0.85, 0); FloatFrame.BackgroundTransparency = 1
FloatFrame.Visible = false

local function MakeFloatBtn(name, text, pos, callback)
    local b = Instance.new("TextButton", FloatFrame)
    b.Size = UDim2.new(0, 50, 0, 50); b.Position = pos
    b.BackgroundColor3 = Color3.fromRGB(255, 105, 180); b.Text = text
    b.TextColor3 = Color3.new(1,1,1); b.Font = Enum.Font.GothamBold; b.TextSize = 10
    Instance.new("UICorner", b).CornerRadius = UDim.new(1, 0)
    b.MouseButton1Click:Connect(callback); return b
end

-- Tabs
local Pages = {}
local TabBtns = {}
local function AddTab(name, idx)
    local btn = Instance.new("TextButton", Sidebar)
    btn.Size = UDim2.new(0, 108, 0, 32); btn.Position = UDim2.new(0, 6, 0, 8 + (idx - 1) * 40)
    btn.BackgroundColor3 = Color3.fromRGB(35, 20, 45); btn.Text = name
    btn.TextColor3 = Color3.fromRGB(200, 190, 220); btn.Font = Enum.Font.Gotham; btn.TextSize = 12
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 6)
    local page = Instance.new("ScrollingFrame", Content)
    page.Size = UDim2.new(1, 0, 1, 0); page.BackgroundTransparency = 1; page.BorderSizePixel = 0
    page.ScrollBarThickness = 4; page.Visible = false; page.AutomaticCanvasSize = Enum.AutomaticSize.Y
    local layout = Instance.new("UIListLayout", page)
    layout.Padding = UDim.new(0, 8); layout.HorizontalAlignment = Enum.HorizontalAlignment.Center
    Instance.new("UIPadding", page).PaddingTop = UDim.new(0, 8)
    Pages[name] = page; TabBtns[name] = btn
    btn.MouseButton1Click:Connect(function()
        for _, p in pairs(Pages) do p.Visible = false end
        for _, b in pairs(TabBtns) do b.BackgroundColor3 = Color3.fromRGB(35, 20, 45); b.TextColor3 = Color3.fromRGB(200, 190, 220) end
        page.Visible = true; btn.BackgroundColor3 = Color3.fromRGB(255, 105, 180); btn.TextColor3 = Color3.new(1,1,1)
    end)
    return page
end

local PCombat = AddTab(L("Combat"), 1)
local PVisuals = AddTab(L("Visuals"), 2)
local PMove = AddTab(L("Movement"), 3)
local PFarm = AddTab(L("Farm"), 4)
local PTroll = AddTab(L("Troll"), 5)
local PSettings = AddTab(L("Settings"), 6)

-- UI Helpers
local function MakeToggle(parent, text, state, callback)
    local f = Instance.new("Frame", parent); f.Size = UDim2.new(0, 360, 0, 36); f.BackgroundColor3 = Color3.fromRGB(45, 20, 35)
    Instance.new("UICorner", f).CornerRadius = UDim.new(0, 8)
    local lbl = Instance.new("TextLabel", f); lbl.Size = UDim2.new(1, -60, 1, 0); lbl.Position = UDim2.new(0, 12, 0, 0)
    lbl.BackgroundTransparency = 1; lbl.Text = text; lbl.TextColor3 = Color3.new(1,1,1); lbl.Font = Enum.Font.Gotham; lbl.TextSize = 13; lbl.TextXAlignment = Enum.TextXAlignment.Left
    local btn = Instance.new("TextButton", f); btn.Size = UDim2.new(0, 46, 0, 22); btn.Position = UDim2.new(1, -54, 0.5, -11)
    btn.BackgroundColor3 = state and Color3.fromRGB(0, 180, 0) or Color3.fromRGB(180, 0, 0); btn.Text = state and "ON" or "OFF"
    btn.TextColor3 = Color3.new(1,1,1); btn.Font = Enum.Font.GothamBold; btn.TextSize = 11
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 6)
    btn.MouseButton1Click:Connect(function()
        state = not state
        btn.BackgroundColor3 = state and Color3.fromRGB(0, 180, 0) or Color3.fromRGB(180, 0, 0)
        btn.Text = state and "ON" or "OFF"; callback(state)
    end)
    return f, btn
end

local function MakeSlider(parent, text, min, max, val, callback)
    local f = Instance.new("Frame", parent); f.Size = UDim2.new(0, 360, 0, 40); f.BackgroundColor3 = Color3.fromRGB(45, 20, 35)
    Instance.new("UICorner", f).CornerRadius = UDim.new(0, 8)
    local lbl = Instance.new("TextLabel", f); lbl.Size = UDim2.new(1, -20, 1, 0); lbl.Position = UDim2.new(0, 12, 0, 0)
    lbl.BackgroundTransparency = 1; lbl.Text = text .. ": " .. val; lbl.TextColor3 = Color3.new(1,1,1)
    lbl.Font = Enum.Font.Gotham; lbl.TextSize = 13; lbl.TextXAlignment = Enum.TextXAlignment.Left
    local track = Instance.new("Frame", f); track.Size = UDim2.new(0, 200, 0, 4); track.Position = UDim2.new(1, -220, 0.5, -2)
    track.BackgroundColor3 = Color3.fromRGB(80, 40, 60); Instance.new("UICorner", track).CornerRadius = UDim.new(1, 0)
    local fill = Instance.new("Frame", track); fill.Size = UDim2.new((val - min) / (max - min), 0, 1, 0)
    fill.BackgroundColor3 = Color3.fromRGB(255, 105, 180); fill.BorderSizePixel = 0; Instance.new("UICorner", fill).CornerRadius = UDim.new(1, 0)
    local knob = Instance.new("TextButton", track); knob.Size = UDim2.new(0, 14, 0, 14); knob.Position = UDim2.new((val - min) / (max - min), -7, 0.5, -7)
    knob.BackgroundColor3 = Color3.fromRGB(255, 182, 193); knob.Text = ""; Instance.new("UICorner", knob).CornerRadius = UDim.new(1, 0)
    local dragging = false
    knob.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            input.Changed:Connect(function() if input.UserInputState == Enum.UserInputState.End then dragging = false end end)
        end
    end)
    UserInputService.InputChanged:Connect(function(input)
        if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
            local abs = track.AbsolutePosition.X; local size = track.AbsoluteSize.X
            local x = math.clamp(input.Position.X - abs, 0, size); local ratio = x / size
            local newVal = math.floor(min + ratio * (max - min))
            knob.Position = UDim2.new(ratio, -7, 0.5, -7); fill.Size = UDim2.new(ratio, 0, 1, 0)
            lbl.Text = text .. ": " .. newVal; callback(newVal)
        end
    end)
    return f
end

local function MakeInput(parent, text, placeholder, callback)
    local f = Instance.new("Frame", parent); f.Size = UDim2.new(0, 360, 0, 36); f.BackgroundColor3 = Color3.fromRGB(45, 20, 35)
    Instance.new("UICorner", f).CornerRadius = UDim.new(0, 8)
    local lbl = Instance.new("TextLabel", f); lbl.Size = UDim2.new(0.5, -8, 1, 0); lbl.Position = UDim2.new(0, 12, 0, 0)
    lbl.BackgroundTransparency = 1; lbl.Text = text; lbl.TextColor3 = Color3.new(1,1,1); lbl.Font = Enum.Font.Gotham; lbl.TextSize = 13; lbl.TextXAlignment = Enum.TextXAlignment.Left
    local box = Instance.new("TextBox", f); box.Size = UDim2.new(0.5, -16, 0, 24); box.Position = UDim2.new(0.5, 4, 0.5, -12)
    box.BackgroundColor3 = Color3.fromRGB(20, 10, 20); box.Text = ""; box.PlaceholderText = placeholder
    box.TextColor3 = Color3.new(1,1,1); box.Font = Enum.Font.Gotham; box.TextSize = 12
    Instance.new("UICorner", box).CornerRadius = UDim.new(0, 6); box.FocusLost:Connect(function() callback(box.Text) end)
    return f
end

local function MakeButton(parent, text, callback)
    local btn = Instance.new("TextButton", parent); btn.Size = UDim2.new(0, 360, 0, 36)
    btn.BackgroundColor3 = Color3.fromRGB(255, 105, 180); btn.Text = text
    btn.TextColor3 = Color3.new(1,1,1); btn.Font = Enum.Font.GothamBold; btn.TextSize = 13
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 8); btn.MouseButton1Click:Connect(callback)
    return btn
end
    FloatFrame.Visible = v
end)

-- Config system
local CFGFolder = "MM2DeltaCFG"
if not isfolder(CFGFolder) then makefolder(CFGFolder) end

MakeInput(PSettings, L("CFGName"), "cfg-name", function(txt)
    State._cfgName = txt
end)

MakeButton(PSettings, L("SaveCFG"), function()
    local name = State._cfgName or "default"
    local data = {
        Combat = State.Combat,
        Visuals = State.Visuals,
        Movement = State.Movement,
        Farm = State.Farm,
        Troll = {Target = State.Troll.Target, Mode = State.Troll.Mode},
        Settings = {Lang = State.Settings.Lang, ShowFloat = State.Settings.ShowFloat}
    }
    local succ = pcall(function()
        writefile(CFGFolder .. "/" .. name .. ".json", HttpService:JSONEncode(data))
    end)
    if succ then Notify("Config", "Saved: " .. name, Color3.fromRGB(0, 255, 100))
    else Notify("Config", "Save failed", Color3.fromRGB(255, 0, 0)) end
end)

MakeButton(PSettings, L("LoadCFG"), function()
    local name = State._cfgName or "default"
    local path = CFGFolder .. "/" .. name .. ".json"
    if isfile(path) then
        local succ, data = pcall(function() return HttpService:JSONDecode(readfile(path)) end)
        if succ and data then
            for k, v in pairs(data.Combat or {}) do State.Combat[k] = v end
            for k, v in pairs(data.Visuals or {}) do State.Visuals[k] = v end
            for k, v in pairs(data.Movement or {}) do State.Movement[k] = v end
            for k, v in pairs(data.Farm or {}) do State.Farm[k] = v end
            Notify("Config", "Loaded: " .. name, Color3.fromRGB(0, 255, 100))
        else
            Notify("Config", "Load failed", Color3.fromRGB(255, 0, 0))
        end
    else
        Notify("Config", "Not found", Color3.fromRGB(255, 0, 0))
    end
end)

MakeButton(PSettings, L("DelCFG"), function()
    local name = State._cfgName or "default"
    local path = CFGFolder .. "/" .. name .. ".json"
    if isfile(path) then
        delfile(path)
        Notify("Config", "Deleted: " .. name, Color3.fromRGB(255, 100, 100))
    end
end)

-- Floating buttons
local FloatAim = MakeFloatBtn("Aim", L("AimBtn"), UDim2.new(0, 0, 0, 0), function()
    State.Combat.Aimbot = not State.Combat.Aimbot
    FOVCircle.Visible = State.Combat.Aimbot
    Notify("Aimbot", State.Combat.Aimbot and "ON" or "OFF")
end)
local FloatFarm = MakeFloatBtn("Farm", L("FarmBtn"), UDim2.new(0, 55, 0, 0), function()
    State.Farm.AutoCoins = not State.Farm.AutoCoins
    Notify("Farm", State.Farm.AutoCoins and "ON" or "OFF")
end)
local FloatKill = MakeFloatBtn("Kill", L("KillBtn"), UDim2.new(0, 110, 0, 0), function()
    State.Combat.KillAll = not State.Combat.KillAll
    Notify("KillAll", State.Combat.KillAll and "ON" or "OFF")
end)
local FloatClip = MakeFloatBtn("Clip", L("NoclipBtn"), UDim2.new(0, 165, 0, 0), function()
    SetNoClip(not State.Movement.NoClip)
    Notify("NoClip", State.Movement.NoClip and "ON" or "OFF")
end)

-- Minimize / Close
local isMinimized = false
MinBtn.MouseButton1Click:Connect(function()
    isMinimized = not isMinimized
    Content.Visible = not isMinimized
    Sidebar.Visible = not isMinimized
    MainFrame.Size = isMinimized and UDim2.new(0, 540, 0, 38) or UDim2.new(0, 540, 0, 400)
end)

CloseBtn.MouseButton1Click:Connect(function()
    Gui:Destroy()
    for _, set in pairs(ESPObjects) do for _, obj in pairs(set) do obj:Remove() end end
    for _, hl in pairs(Highlights) do if hl then hl:Destroy() end end
    for _, hl in pairs(GunHighlights) do if hl then hl:Destroy() end end
    FOVCircle:Remove()
    if NoClipConnection then NoClipConnection:Disconnect() end
    StopTrolling()
    getgenv().MM2Delta = nil
end)

-- Select first tab
TabBtns[L("Combat")].BackgroundColor3 = Color3.fromRGB(255, 105, 180)
TabBtns[L("Combat")].TextColor3 = Color3.new(1,1,1)
Pages[L("Combat")].Visible = true
-- Part 10/10 — Main Loops, Connections, Character Handler, Init

-- ESP init for all players
for _, p in ipairs(Players:GetPlayers()) do InitESP(p) end
Players.PlayerAdded:Connect(InitESP)
Players.PlayerRemoving:Connect(function(p)
    KillESP(p)
    if Highlights[p] then Highlights[p]:Destroy(); Highlights[p] = nil end
end)

-- CharacterAdded handler
LocalPlayer.CharacterAdded:Connect(function(char)
    task.wait(0.6)
    ApplyHumanoid()
    if State.Visuals.Cape then SetupCape(char) end
    if State.Visuals.ChinaHat then CreateChinaHat(char) end
    if State.Visuals.Trail then ToggleTrail(true) end
    if State.Visuals.AngelRing then ToggleAngelRing(true) end
    if State.Visuals.JumpRipple then SetupJumpEffect(char) end
    if State.Visuals.PinkGlass then TogglePinkGlass(true) end
end)
if LocalPlayer.Character then
    task.spawn(function()
        task.wait(0.6)
        ApplyHumanoid()
        if State.Visuals.Cape then SetupCape(LocalPlayer.Character) end
        if State.Visuals.ChinaHat then CreateChinaHat(LocalPlayer.Character) end
        if State.Visuals.Trail then ToggleTrail(true) end
        if State.Visuals.AngelRing then ToggleAngelRing(true) end
        if State.Visuals.JumpRipple then SetupJumpEffect(LocalPlayer.Character) end
        if State.Visuals.PinkGlass then TogglePinkGlass(true) end
    end)
end

-- BunnyHop
UserInputService.JumpRequest:Connect(function()
    if State.Movement.BunnyHop then
        local char = LocalPlayer.Character
        if char and char:FindFirstChildOfClass("Humanoid") then
            char:FindFirstChildOfClass("Humanoid"):ChangeState(Enum.HumanoidStateType.Jumping)
        end
    end
end)

-- Main RenderStepped loop
RunService.RenderStepped:Connect(function()
    -- FOV Circle update
    FOVCircle.Position = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y / 2)
    FOVCircle.Radius = State.Combat.FOV
    FOVCircle.Visible = State.Combat.Aimbot
    
    -- Aimbot
    if State.Combat.Aimbot then
        local target = GetAimTarget()
        if target then
            if State.Combat.Smooth > 0 then
                Camera.CFrame = Camera.CFrame:Lerp(CFrame.new(Camera.CFrame.Position, target.Position), State.Combat.Smooth)
            else
                Camera.CFrame = CFrame.new(Camera.CFrame.Position, target.Position)
            end
        end
    end
    
    -- ESP
    RenderESP()
    UpdateHighlights()
    
    -- SpeedGlitch
    if State.Combat.SpeedGlitch then
        local char = LocalPlayer.Character
        if char then
            local hum = char:FindFirstChildOfClass("Humanoid")
            if hum and (hum:GetState() == Enum.HumanoidStateType.Freefall or hum.Jump) then
                hum.WalkSpeed = 120
            elseif hum and hum.WalkSpeed == 120 then
                hum.WalkSpeed = State.Movement.WalkSpeed
            end
        end
    end
    
    -- AntiFling
    if State.Movement.AntiFling then
        local char = LocalPlayer.Character
        if char then
            local hrp = char:FindFirstChild("HumanoidRootPart")
            if hrp then
                local vel = hrp.AssemblyLinearVelocity
                if math.abs(vel.X) > 100 or math.abs(vel.Y) > 100 or math.abs(vel.Z) > 100 then
                    hrp.AssemblyLinearVelocity = Vector3.new(0, 0, 0)
                    hrp.AssemblyAngularVelocity = Vector3.new(0, 0, 0)
                end
            end
        end
    end
    
    -- Fullbright maintain
    if State.Visuals.Fullbright then
        Lighting.Brightness = 2
        Lighting.ClockTime = 14
        Lighting.GlobalShadows = false
        Lighting.OutdoorAmbient = Color3.new(1,1,1)
    end
end)

Notify("Delta", "MM2 Delta Ultimate loaded!", Color3.fromRGB(255, 105, 180))
print("MM2 Delta Ultimate | 10/10 Loaded")
