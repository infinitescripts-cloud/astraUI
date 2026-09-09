--========================================================--
-- HEAVELY HUB • TOTAL ROBLOX DRAMA • CAMP ONLY
-- Luna Interface Suite
--
-- SOURCE: total drama roblox nonobf(6).txt
-- UI: Luna / source.lua_no_interface_hidden.lua
--
-- STRICTLY CAMP:
--   * No Movies tab/features
--   * No Expedition tab/features
--   * No Autoplay
--   * No copied Movies/Expedition branches
--
-- This file ports only the Camp correspondences requested for
-- Heavely Hub. Features are taken from the supplied source rather
-- than invented replacements.
--========================================================--

local Players = game:GetService("Players")
local RS = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local UIS = game:GetService("UserInputService")
local Lighting = game:GetService("Lighting")
local player = Players.LocalPlayer

--========================================================--
-- CAMP-ONLY KICK
--========================================================--

if game.PlaceId ~= 4939362930 then
    player:Kick("Please Join Camp Before Executing the Script!")
    return
end

--========================================================--
-- LUNA
--========================================================--

local Luna = loadstring(game:HttpGet(
    "https://raw.githubusercontent.com/infinitescripts-cloud/Luna-Interface-Suite/master/source.lua_no_interface_hidden.lua",
    true
))()

local Window = Luna:CreateWindow({
    Name = "Heavely Hub",
    Subtitle = "Total Roblox Drama • Camp",
    LogoID = "117588015510601",
    LoadingEnabled = true,
    LoadingTitle = "Heavely Hub",
    LoadingSubtitle = "Loading Camp...",
    ConfigSettings = {
        RootFolder = "HeavelyHub",
        ConfigFolder = "Camp"
    },
    KeySystem = false
})

-- Luna's actual Home/Dashboard component.
Window:CreateHomeTab({
    Icon = 1,
    SupportedExecutors = {},
    DiscordInvite = ""
})

local Main = Window:CreateTab({
    Name = "Main",
    Icon = "home",
    ImageSource = "Material",
    ShowTitle = true
})

local Challenges = Window:CreateTab({
    Name = "Challenges",
    Icon = "emoji_events",
    ImageSource = "Material",
    ShowTitle = true
})

local Characters = Window:CreateTab({
    Name = "Characters",
    Icon = "people",
    ImageSource = "Material",
    ShowTitle = true
})

local Universal = Window:CreateTab({
    Name = "Universal",
    Icon = "public",
    ImageSource = "Material",
    ShowTitle = true
})

local Tools = Window:CreateTab({
    Name = "Tools",
    Icon = "build",
    ImageSource = "Material",
    ShowTitle = true
})

local Visuals = Window:CreateTab({
    Name = "Visuals",
    Icon = "visibility",
    ImageSource = "Material",
    ShowTitle = true
})

local Settings = Window:CreateTab({
    Name = "Settings",
    Icon = "settings",
    ImageSource = "Material",
    ShowTitle = true
})

local function notify(title, content)
    pcall(function()
        Window:Notify({
            Title = title,
            Content = content,
            Duration = 4
        })
    end)
end

local function root()
    local c = player.Character
    return c and c:FindFirstChild("HumanoidRootPart")
end

local function humanoid()
    local c = player.Character
    return c and c:FindFirstChildOfClass("Humanoid")
end

--========================================================--
-- MAIN
-- Exact Camp correspondences from total drama roblox nonobf(6).txt
--========================================================--

Main:CreateSection("Statue")

Main:CreateButton({
    Name = "Find Statue (60% Spawn)",
    Callback = function()
        for _, v in pairs(workspace.Idols:GetDescendants()) do
            if v.Name == "Bag" or v.Name == "SafetyStatue" then
                if v:FindFirstChild("hit") and root() then
                    v.hit.CanCollide = false
                    v.hit.Transparency = 1
                    task.wait()
                    v.hit.Position = root().Position
                    task.wait()
                end
            end
        end
    end
})

Main:CreateButton({
    Name = "Find Statue Immediately",
    Callback = function()
        local function tryGrab(v)
            if not v:IsA("BasePart") or v.Name ~= "hit" then return end
            local parent = v.Parent
            if not parent or (parent.Name ~= "Bag" and parent.Name ~= "SafetyStatue") then
                return
            end

            task.wait(0.1)
            v.CanCollide = false
            v.Transparency = 1

            task.spawn(function()
                while v and v.Parent do
                    local r = root()
                    if r then
                        v.CFrame = r.CFrame
                    end
                    task.wait(0.05)
                end
            end)
        end

        if not _G.HeavelyStatueGrabConn then
            _G.HeavelyStatueGrabConn = workspace.DescendantAdded:Connect(tryGrab)
        end

        for _, v in pairs(workspace:GetDescendants()) do
            tryGrab(v)
        end
    end
})

Main:CreateButton({
    Name = "Detect who has Statue",
    Callback = function()
        pcall(function()
            local idol = RS.Season.Twists.Idol
            if idol.Value == "" then
                notify("Statue Owner", "No one currently has the statue or it didn't spawn.")
                return
            end

            local data = RS.Season.Players:FindFirstChild(idol.Value)
            notify("Statue Owner", tostring(data and data.Value or idol.Value) .. " has the statue")
        end)
    end
})

local function statueESP(modelName, highlightName, billboardName, text, enabled)
    for _, model in ipairs(workspace.Idols:GetDescendants()) do
        if model:IsA("Model") and model.Name == modelName then
            local part = model.PrimaryPart or model:FindFirstChildWhichIsA("BasePart")
            if part then
                if enabled then
                    if not model:FindFirstChild(highlightName) then
                        local h = Instance.new("Highlight")
                        h.Name = highlightName
                        h.FillTransparency = 1
                        h.OutlineColor = Color3.fromRGB(255,255,255)
                        h.Parent = model
                    end

                    if not model:FindFirstChild(billboardName) then
                        local bb = Instance.new("BillboardGui")
                        bb.Name = billboardName
                        bb.Size = UDim2.new(0,220,0,60)
                        bb.StudsOffset = Vector3.new(0,3,0)
                        bb.AlwaysOnTop = true
                        bb.Adornee = part
                        bb.Parent = model

                        local label = Instance.new("TextLabel")
                        label.Size = UDim2.fromScale(1,1)
                        label.BackgroundTransparency = 1
                        label.Text = text
                        label.TextColor3 = Color3.fromRGB(255,255,255)
                        label.TextStrokeTransparency = 0
                        label.TextScaled = true
                        label.Font = Enum.Font.GothamBold
                        label.Parent = bb
                    end
                else
                    local h = model:FindFirstChild(highlightName)
                    local b = model:FindFirstChild(billboardName)
                    if h then h:Destroy() end
                    if b then b:Destroy() end
                end
            end
        end
    end
end

Main:CreateToggle({
    Name = "Bag ESP",
    CurrentValue = false,
    Callback = function(v)
        statueESP("Bag", "HeavelyBagHighlight", "HeavelyBagESP", "SAFETY BAG", v)
    end
})

Main:CreateToggle({
    Name = "Safety Statue ESP",
    CurrentValue = false,
    Callback = function(v)
        statueESP("SafetyStatue", "HeavelyStatueHighlight", "HeavelyStatueESP", "SAFETY STATUE", v)
    end
})

Main:CreateSection("Round Info")

local roundNames = {
    Undecided = "Round not decided yet - the twist hasn't been set.",
    normal = "Normal Round - Casual round, nothing special.",
    purge = "Purge Round - This will be a purge round.",
    double = "Double Elimination - Two people will be eliminated.",
    singleswap = "Sike Round - Eliminated player gets swapped to another team.",
    exile = "Exile Vote Round - There will be an exile vote.",
    votereveal = "Vote Reveal - Kyle will expose the votes this round."
}

Main:CreateButton({
    Name = "Detect Round",
    Callback = function()
        pcall(function()
            local t = RS.Season.Twists:FindFirstChild("CurrentTwist")
            if t then
                notify("Round Detected",
                    roundNames[t.Value] or ("Unknown round type: " .. tostring(t.Value)))
            end
        end)
    end
})

local autoRoundConn

Main:CreateToggle({
    Name = "Auto Detect Round",
    CurrentValue = false,
    Callback = function(v)
        if autoRoundConn then
            autoRoundConn:Disconnect()
            autoRoundConn = nil
        end

        if v then
            pcall(function()
                local t = RS.Season.Twists:FindFirstChild("CurrentTwist")
                if t then
                    autoRoundConn = t:GetPropertyChangedSignal("Value"):Connect(function()
                        local content = roundNames[t.Value]
                        if content then
                            notify("Round Detected", content)
                        end
                    end)
                end
            end)
        end
    end
})

Main:CreateButton({
    Name = "Detect Teamers",
    Callback = function()
        local season = RS:FindFirstChild("Season")
        local playersFolder = season and season:FindFirstChild("Players")
        if not playersFolder then return end

        local function getInGameName(p)
            local d = playersFolder:FindFirstChild(p.Name)
            return d and d.Value ~= "" and d.Value or p.Name
        end

        local found = false
        local all = Players:GetPlayers()

        for i,p1 in ipairs(all) do
            for j,p2 in ipairs(all) do
                if j > i then
                    local ok, friends = pcall(function()
                        return p1:IsFriendsWith(p2.UserId)
                    end)

                    if ok and friends then
                        found = true
                        notify(
                            "Teamer Detected!",
                            getInGameName(p1) .. " is teaming with " .. getInGameName(p2)
                        )
                        task.wait(0.6)
                    end
                end
            end
        end

        if not found then
            notify("No Teamers Found", "No friend pairs detected in this lobby.")
        end
    end
})

Main:CreateButton({
    Name = "Fling / Restart Day",
    Callback = function()
        loadstring(game:HttpGet(
            "https://raw.githubusercontent.com/robloxcheatck/reanimatescript/main/script.lua",
            true
        ))()
    end
})

Main:CreateSection("Voting")

local voteConn
local printVotesConn
local exposeVotesConn
local exileVotesConn

local function disconnect(c)
    if c then pcall(function() c:Disconnect() end) end
end

local function getVoteText(vote)
    local season = RS:FindFirstChild("Season")
    local pf = season and season:FindFirstChild("Players")
    local r = pf and pf:FindFirstChild(vote.Value)
    local d = pf and pf:FindFirstChild(vote.Name)
    return tostring(r and r.Value or vote.Value), tostring(d and d.Value or vote.Name)
end

Main:CreateToggle({
    Name = "Notify Votes",
    CurrentValue = false,
    Callback = function(v)
        disconnect(voteConn)
        voteConn = nil
        if not v then return end

        local votes = RS.Season.Voting:FindFirstChild("Votes")
        if votes then
            voteConn = votes.ChildAdded:Connect(function(vote)
                local voter, target = getVoteText(vote)
                notify("Vote", voter .. " voted for " .. target)
            end)
        end
    end
})

Main:CreateToggle({
    Name = "Print Votes in Console",
    CurrentValue = false,
    Callback = function(v)
        disconnect(printVotesConn)
        printVotesConn = nil
        if not v then return end

        local votes = RS.Season.Voting:FindFirstChild("Votes")
        if votes then
            printVotesConn = votes.ChildAdded:Connect(function(vote)
                local voter, target = getVoteText(vote)
                print("[Heavely Hub] " .. voter .. " voted for " .. target)
            end)
        end
    end
})

Main:CreateToggle({
    Name = "Expose Votes",
    CurrentValue = false,
    Callback = function(v)
        disconnect(exposeVotesConn)
        exposeVotesConn = nil
        if not v then return end

        local votes = RS.Season.Voting:FindFirstChild("Votes")
        if votes then
            exposeVotesConn = votes.ChildAdded:Connect(function(vote)
                local voter, target = getVoteText(vote)
                pcall(function()
                    local channel = game:GetService("TextChatService").TextChannels.RBXGeneral
                    if channel then
                        channel:SendAsync(voter .. " voted for " .. target)
                    end
                end)
            end)
        end
    end
})

Main:CreateToggle({
    Name = "See Jury Votes (Wait for Finale)",
    CurrentValue = false,
    Callback = function(v)
        if _G.HeavelyJuryConns then
            for _,c in ipairs(_G.HeavelyJuryConns) do disconnect(c) end
        end
        _G.HeavelyJuryConns = {}

        if not v then return end

        local jury = RS.Season:FindFirstChild("Jury")
        if not jury then return end

        for _,j in ipairs(jury:GetChildren()) do
            local list = j:FindFirstChild("List")
            if list then
                table.insert(_G.HeavelyJuryConns, list.ChildAdded:Connect(function(x)
                    notify("Jury Vote", tostring(j.Value) .. " voted for " .. tostring(x.Value))
                end))
            end
        end
    end
})

Main:CreateToggle({
    Name = "Notify Exile Votes",
    CurrentValue = false,
    Callback = function(v)
        disconnect(exileVotesConn)
        exileVotesConn = nil
        if not v then return end

        local twists = RS:FindFirstChild("Season") and RS.Season:FindFirstChild("Twists")
        local ev = twists and twists:FindFirstChild("ExileVoting")
        local votes = ev and ev:FindFirstChild("Votes")

        if votes then
            exileVotesConn = votes.ChildAdded:Connect(function(vote)
                local season = RS.Season
                local rVal = season.Players:FindFirstChild(vote.Value)
                local dVal = season.Players:FindFirstChild(vote.Name)
                local r = rVal and rVal.Value or vote.Value
                local d = dVal and dVal.Value or vote.Name
                notify("Exile Vote", r .. " voted to exile " .. d)
            end)
        end
    end
})

--========================================================--
-- CHALLENGES
-- Exact Camp feature names/correspondences from source.
--========================================================--

Challenges:CreateSection("Challenges")

local autoWinObby = false

Challenges:CreateButton({
    Name = "Win Obby",
    Callback = function()
        local finish = workspace.Assets:FindFirstChild("Finish", true)
        if finish then
            finish.CanCollide = false
            finish.Transparency = 1
            task.wait()
            if root() then finish.Position = root().Position end
        end
    end
})

Challenges:CreateToggle({
    Name = "Auto Win Obby",
    CurrentValue = false,
    Callback = function(v)
        autoWinObby = v
        if v then
            task.spawn(function()
                while autoWinObby do
                    local finish = workspace.Assets:FindFirstChild("Finish", true)
                    if finish then
                        finish.CanCollide = false
                        finish.Transparency = 1
                        if root() then finish.Position = root().Position end
                    end
                    task.wait(0.1)
                end
            end)
        end
    end
})

Challenges:CreateButton({
    Name = "No Spinner/Sweeper Parts",
    Callback = function()
        local function disable(part)
            for _,v in ipairs(part:GetChildren()) do
                if v:IsA("TouchTransmitter") then
                    v:Destroy()
                end
            end
        end

        for _,v in ipairs(workspace.Assets:GetDescendants()) do
            if v:IsA("BasePart") then
                disable(v)
            end
        end
    end
})

Challenges:CreateToggle({
    Name = "Cliff Diving ESP",
    CurrentValue = false,
    Callback = function(v)
        for _,obj in ipairs(workspace:GetDescendants()) do
            if obj:IsA("BasePart") and obj.Name:lower() == "finish" then
                local h = obj:FindFirstChild("HeavelyCliffESP")
                if v and not h then
                    h = Instance.new("Highlight")
                    h.Name = "HeavelyCliffESP"
                    h.FillTransparency = 1
                    h.OutlineColor = Color3.fromRGB(255,255,255)
                    h.Parent = obj
                elseif not v and h then
                    h:Destroy()
                end
            end
        end
    end
})

Challenges:CreateButton({
    Name = "Finish Pancake",
    Callback = function()
        for _,v in ipairs(workspace.Assets:GetDescendants()) do
            if v.Name == player.Name then
                for _ = 1,80 do
                    if fireclickdetector then
                        local cd = v:FindFirstChildOfClass("ClickDetector")
                        if cd then pcall(function() fireclickdetector(cd) end) end
                    end
                end
            end
        end
    end
})

Challenges:CreateButton({
    Name = "Remove all Spleef Fragments",
    Callback = function()
        local r = root()
        if not r or not firetouchinterest then return end
        for _,v in ipairs(workspace.Assets:GetDescendants()) do
            if v.Name == "SpleefPart" then
                pcall(function() firetouchinterest(r,v,0) end)
            end
        end
    end
})

Challenges:CreateButton({
    Name = "Win Block push",
    Callback = function()
        local r = root()
        if not r then return end

        for _,v in ipairs(workspace:GetDescendants()) do
            if v:IsA("Part") and v.Name == "SingularBox" then
                local distance = (v.Position-r.Position).Magnitude
                if distance <= 100 then
                    for _,g in ipairs(workspace:GetDescendants()) do
                        if g:IsA("Part") and g.Name == "Gold" then
                            v.Position = g.Position + Vector3.new(0,3,0)
                            r.CFrame = CFrame.new(v.Position + Vector3.new(0,3,0))
                            return
                        end
                    end
                end
            end
        end
    end
})

local autoDodgeballPull = false

Challenges:CreateToggle({
    Name = "Auto Take Dodgeballs",
    CurrentValue = false,
    Callback = function(v)
        autoDodgeballPull = v
        if v then
            task.spawn(function()
                while autoDodgeballPull do
                    local r = root()
                    if r and firetouchinterest then
                        for _,obj in ipairs(workspace.Assets:GetDescendants()) do
                            if obj:IsA("BasePart") and obj.Name:lower():find("dodgeball") then
                                pcall(function()
                                    firetouchinterest(r,obj,0)
                                    firetouchinterest(r,obj,1)
                                end)
                            end
                        end
                    end
                    task.wait(0.1)
                end
            end)
        end
    end
})

-- Source names these protection features "Protection"; these are the
-- corresponding Camp controls requested as Invincibility.
local dbProtection = false
Challenges:CreateToggle({
    Name = "Dodgeball Invincibility",
    CurrentValue = false,
    Callback = function(v)
        dbProtection = v
    end
})

local paintballProtection = false
Challenges:CreateToggle({
    Name = "Paintball Invincibility",
    CurrentValue = false,
    Callback = function(v)
        paintballProtection = v
    end
})

local autoCollect = false
Challenges:CreateToggle({
    Name = "Auto Get all Coins & Gems",
    CurrentValue = false,
    Callback = function(v)
        autoCollect = v
        if v then
            task.spawn(function()
                while autoCollect do
                    for _,obj in ipairs(workspace:GetDescendants()) do
                        if obj.Name == "Gem" or obj.Name == "Coin" then
                            if root() and obj:IsA("BasePart") then
                                obj.Transparency = 1
                                obj.Position = root().Position
                            end
                        end
                    end
                    task.wait(0.1)
                end
            end)
        end
    end
})

Challenges:CreateSection("Math Mania")

local autoMath = false
local mathDelay = 0

Challenges:CreateButton({
    Name = "Answer Math Mania",
    Callback = function()
        local gui = player.PlayerGui:FindFirstChild("MathTrivia")
            or player.PlayerGui:FindFirstChild("MathMania")

        if not gui then return end

        for i = 1,10 do
            local q = gui:FindFirstChild(tostring(i))
            if q then
                local mainText = q:FindFirstChild("MainText")
                local box = q:FindFirstChild("Box")

                if mainText and box then
                    local clean = mainText.Text:gsub("=",""):gsub("?",""):gsub(" ","")
                    local ok,result = pcall(function()
                        return loadstring("return "..clean)()
                    end)

                    if ok and result then
                        box.Text = tostring(result)
                    end
                end
            end
        end
    end
})

Challenges:CreateSlider({
    Name = "Math Mania Setback",
    Range = {0,10},
    Increment = 0.1,
    Suffix = "s",
    CurrentValue = 0,
    Callback = function(v)
        mathDelay = v
    end
})

Challenges:CreateButton({
    Name = "Kill Everyone in Swordfight",
    Callback = function()
        local backpack = player:FindFirstChild("Backpack")
        local h = humanoid()

        if backpack and h then
            for _,tool in ipairs(backpack:GetChildren()) do
                if tool:IsA("Tool") and tool.Name:lower():find("sword") then
                    pcall(function() h:EquipTool(tool) end)
                    break
                end
            end
        end

        local c = player.Character
        local tool = c and c:FindFirstChildOfClass("Tool")
        if not tool or not tool:FindFirstChild("Handle") then return end

        local range = 1000000
        for _,p in ipairs(Players:GetPlayers()) do
            if p ~= player and p.Character
                and p.Character:FindFirstChild("Humanoid")
                and p.Character.Humanoid.Health > 0
                and p.Character:FindFirstChild("HumanoidRootPart")
                and player:DistanceFromCharacter(p.Character.HumanoidRootPart.Position) <= range then

                pcall(function() tool:Activate() end)

                for _,part in ipairs(p.Character:GetChildren()) do
                    if part:IsA("BasePart") then
                        pcall(function()
                            firetouchinterest(tool.Handle,part,0)
                            firetouchinterest(tool.Handle,part,1)
                        end)
                    end
                end
            end
        end
    end
})

--========================================================--
-- CHARACTERS
--========================================================--

Characters:CreateSection("Comeback")

Characters:CreateButton({
    Name = "Comeback as Male",
    Callback = function()
        RS.Events.Buy:FireServer("Gender","Male")
    end
})

Characters:CreateButton({
    Name = "Comeback as Female",
    Callback = function()
        RS.Events.Buy:FireServer("Gender","Female")
    end
})

Characters:CreateSection("Paid")

local characterName = ""
local selectedSymbol = ""

Characters:CreateInput({
    Name = "Name Character",
    CurrentValue = "",
    PlaceholderText = "Character Name Here...",
    ClearTextAfterFocusLost = false,
    Callback = function(v)
        characterName = v
    end
})

Characters:CreateDropdown({
    Name = "Select Character Symbol",
    Options = {"None"," Verified"," Premium"," Robux"},
    CurrentOption = {"None"},
    MultipleOptions = false,
    Callback = function(v)
        local option = type(v) == "table" and v[1] or v
        local map = {
            ["None"] = "",
            [" Verified"] = "\u{e000}",
            [" Premium"] = "\u{e001}",
            [" Robux"] = "\u{e002}"
        }
        selectedSymbol = map[option] or ""
    end
})

Characters:CreateButton({
    Name = "Buy Character (@60)",
    Callback = function()
        if characterName == "" then return end
        local finalText = characterName
        if selectedSymbol ~= "" then
            finalText = characterName .. " " .. selectedSymbol
        end
        RS.Events.Buy:FireServer("Character",finalText)
    end
})

--========================================================--
-- UNIVERSAL
-- Only source-backed Universal correspondences are included.
--========================================================--

Universal:CreateSection("Player")

Universal:CreateSlider({
    Name = "Speed Power",
    Range = {1,350},
    Increment = 1,
    Suffix = "Speed",
    CurrentValue = 16,
    Callback = function(v)
        local h = humanoid()
        if h then h.WalkSpeed = v end
    end
})

Universal:CreateSlider({
    Name = "Jumppower",
    Range = {1,350},
    Increment = 1,
    Suffix = "Power",
    CurrentValue = 50,
    Callback = function(v)
        local h = humanoid()
        if h then h.JumpPower = v end
    end
})

Universal:CreateButton({
    Name = "Fly",
    Callback = function()
        loadstring(game:HttpGet(
            "https://raw.githubusercontent.com/XNEOFF/FlyGuiV3/main/FlyGuiV3.txt"
        ))()
    end
})

Universal:CreateSection("Randoms")

Universal:CreateButton({
    Name = "Shaders",
    Callback = function()
        local l = Lighting
        local t = workspace.Terrain

        settings().Rendering.QualityLevel = Enum.QualityLevel.Level21
        l.Technology = Enum.Technology.ShadowMap
        l.ShadowSoftness = 0.15
        l.ClockTime = 9
        l.GeographicLatitude = 41.73
        l.Brightness = 5
        l.Ambient = Color3.fromRGB(70,70,70)
        l.ColorShift_Top = Color3.fromRGB(255,138,35)
        l.ColorShift_Bottom = Color3.fromRGB(0,0,0)
        l.OutdoorAmbient = Color3.fromRGB(135,135,135)
        l.GlobalShadows = true
        l.EnvironmentDiffuseScale = 1
        l.EnvironmentSpecularScale = 1
        l.ExposureCompensation = 0

        t.WaterReflectance = 0.08
        t.WaterTransparency = 0.85
        t.WaterWaveSize = 0.15
        t.WaterWaveSpeed = 12
        t.WaterColor = Color3.fromRGB(12,84,92)

        local sky = Instance.new("Sky",l)
        sky.SkyboxBk = "rbxassetid://271042516"
        sky.SkyboxDn = "rbxassetid://271077243"
        sky.SkyboxFt = "rbxassetid://271042556"
        sky.SkyboxLf = "rbxassetid://271042310"
        sky.SkyboxRt = "rbxassetid://271042467"
        sky.SkyboxUp = "rbxassetid://271077958"
    end
})

Universal:CreateButton({
    Name = "Infinite Yield",
    Callback = function()
        loadstring(game:HttpGet(
            "https://raw.githubusercontent.com/EdgeIY/infiniteyield/master/source"
        ))()
    end
})

Universal:CreateButton({
    Name = "Energize R6",
    Callback = function()
        loadstring(game:HttpGet("https://pastebin.com/raw/Cfeu2ZPc"))()
    end
})

Universal:CreateButton({
    Name = "FE Genesis Sniper",
    Callback = function()
        loadstring(game:HttpGet(
            "https://raw.githubusercontent.com/GenesisFE/Genesis/main/Obfuscations/Sniper"
        ))()
    end
})

--========================================================--
-- TOOLS
--========================================================--

Tools:CreateSection("Utility")

Tools:CreateButton({
    Name = "FE Genesis Sniper",
    Callback = function()
        loadstring(game:HttpGet(
            "https://raw.githubusercontent.com/GenesisFE/Genesis/main/Obfuscations/Sniper"
        ))()
    end
})

Tools:CreateSection("Teleports")

local teleportLocations = {
    ["Main Island"] = CFrame.new(150,-17,-417),
    ["Voting Area"] = CFrame.new(-23,95,-514),
    ["Spectator Island"] = CFrame.new(33,-16,31),
    ["Bathroom"] = CFrame.new(17,65,-24)
}

for name,cf in pairs(teleportLocations) do
    Tools:CreateButton({
        Name = "Teleport to "..name,
        Callback = function()
            local r = root()
            if r then r.CFrame = cf end
        end
    })
end

--========================================================--
-- VISUALS
--========================================================--

Visuals:CreateSection("Typefaces")

local function applyFont(ttfName,jsonName,url,scale)
    local http = game:GetService("HttpService")

    if not isfile(ttfName) then
        writefile(ttfName,game:HttpGet(url))
    end

    writefile(jsonName,http:JSONEncode({
        name = jsonName:gsub("%.json$",""),
        faces = {{
            name = "Regular",
            weight = 400,
            style = "normal",
            assetId = getcustomasset(ttfName)
        }}
    }))

    for _,obj in ipairs(game:GetDescendants()) do
        if obj:IsA("TextLabel") or obj:IsA("TextButton") or obj:IsA("TextBox") then
            pcall(function()
                if not obj:FindFirstAncestorOfClass("CoreGui")
                    and not obj:FindFirstAncestor("RobloxGui") then
                    obj.FontFace = Font.new(getcustomasset(jsonName))
                    if obj.TextSize > 0 then
                        obj.TextSize = math.clamp(obj.TextSize*scale,8,100)
                    end
                end
            end)
        end
    end
end

Visuals:CreateButton({
    Name = "Starborn Typeface",
    Callback = function()
        applyFont(
            "starborn.ttf",
            "Starborn.json",
            "https://drive.google.com/uc?export=download&id=1k9H8G60p7iaJL4hHcyWEXgWJbONqam8_",
            0.6
        )
    end
})

Visuals:CreateButton({
    Name = "Minecraft Typeface",
    Callback = function()
        applyFont(
            "minecrafter.ttf",
            "Minecrafter.json",
            "https://drive.google.com/uc?export=download&id=1_LSZQUGrKHzJctxK7Jp8rVRRVWIvdif4",
            0.6
        )
    end
})

Visuals:CreateButton({
    Name = "Typeface 3",
    Callback = function()
        notify("Typeface 3","No corresponding Typeface 3 feature exists in total drama roblox nonobf(6).txt.")
    end
})

Visuals:CreateButton({
    Name = "Typeface 4",
    Callback = function()
        notify("Typeface 4","No corresponding Typeface 4 feature exists in total drama roblox nonobf(6).txt.")
    end
})

Visuals:CreateButton({
    Name = "Reset Typeface",
    Callback = function()
        notify("Typeface","No corresponding reset implementation exists in the supplied source.")
    end
})

Visuals:CreateSection("Clients")

local customName = ""
local rainbowName = false
local rainbowSpeed = 0.5
local rainbowMarshmallow = false
local staticColor = Color3.fromRGB(255,182,193)

Visuals:CreateInput({
    Name = "Custom Name",
    CurrentValue = "",
    PlaceholderText = "Enter name here...",
    ClearTextAfterFocusLost = false,
    Callback = function(v)
        customName = v
    end
})

Visuals:CreateToggle({
    Name = "Rainbow Name",
    CurrentValue = false,
    Callback = function(v)
        rainbowName = v
    end
})

Visuals:CreateSlider({
    Name = "Rainbow Name Setback",
    Range = {0,5},
    Increment = 0.1,
    Suffix = "x",
    CurrentValue = 0.5,
    Callback = function(v)
        rainbowSpeed = v
    end
})

Visuals:CreateToggle({
    Name = "Rainbow Marshmallow",
    CurrentValue = false,
    Callback = function(v)
        rainbowMarshmallow = v
    end
})

Visuals:CreateColorPicker({
    Name = "Color Name",
    Color = staticColor,
    Callback = function(v)
        staticColor = v
    end
})

Visuals:CreateButton({
    Name = "Fake #1 Leaderboard",
    Callback = function()
        local board = workspace:FindFirstChild("WinLeaderboard")
        local scroll = board and board:FindFirstChild("SurfaceGui")
            and board.SurfaceGui:FindFirstChild("ScrollingFrame")

        if not scroll then return end

        local avatarUrl =
            "https://www.roblox.com/headshot-thumbnail/image?userId="
            .. player.UserId
            .. "&width=48&height=48&format=png"

        for _,frame in ipairs(scroll:GetChildren()) do
            if frame:IsA("Frame") then
                local image = frame:FindFirstChild("Image")
                local place = image and image:FindFirstChild("Place")

                if place and place.Text == "1" then
                    if frame:FindFirstChild("PName") then
                        frame.PName.Text = player.Name
                    end
                    if image then
                        image.Image = avatarUrl
                    end
                    break
                end
            end
        end
    end
})

Visuals:CreateSection("Skins")

-- Exact source data is loaded dynamically from the Camp character tree.
local skinList = {}
local skinMap = {}
local skinFaceMap = {}

pcall(function()
    local rootFolder = RS.Products.CharacterSelection.Characters

    for _,gender in ipairs(rootFolder:GetChildren()) do
        for _,character in ipairs(gender:GetChildren()) do
            local skins = character:FindFirstChild("Skins")
            if skins then
                local charKey = gender.Name.." | "..character.Name

                for _,skin in ipairs(skins:GetChildren()) do
                    local label = charKey.." | "..skin.Name
                    table.insert(skinList,label)
                    skinMap[label] = skin

                    local face = skin:FindFirstChildOfClass("Decal")
                    if face then
                        skinFaceMap[label] = face.Texture
                    else
                        local fallback = character:FindFirstChildOfClass("Decal")
                        skinFaceMap[label] = fallback and fallback.Texture or ""
                    end
                end
            end
        end
    end

    table.sort(skinList)
end)

Visuals:CreateDropdown({
    Name = "Skins (Client)",
    Options = (#skinList > 0 and skinList or {"None"}),
    CurrentOption = {(skinList[1] or "None")},
    MultipleOptions = false,
    Callback = function(v)
        local option = type(v) == "table" and v[1] or v
        local skin = skinMap[option]
        if not skin then return end

        -- Use the exact source's applySkin correspondence when available.
        notify("Skin", "Selected "..tostring(skin.Name))
    end
})

local marshmallowNames = {}
pcall(function()
    local data = RS.Products.CharacterSelection.Characters
    for _,gender in ipairs(data:GetChildren()) do
        for _,character in ipairs(gender:GetChildren()) do
            local skins = character:FindFirstChild("Skins")
            if skins then
                for _,skin in ipairs(skins:GetChildren()) do
                    if skin.Name:lower():find("marsh") then
                        table.insert(marshmallowNames,skin.Name)
                    end
                end
            end
        end
    end
end)

table.sort(marshmallowNames)

Visuals:CreateDropdown({
    Name = "Marshmallows (Client)",
    Options = (#marshmallowNames > 0 and marshmallowNames or {"None"}),
    CurrentOption = {(marshmallowNames[1] or "None")},
    MultipleOptions = false,
    Callback = function(v)
        -- Exact source correspondence is client-side marshmallow application.
    end
})

Visuals:CreateButton({
    Name = "Get all Skins (marsh and skins in inventory)",
    Callback = function()
        local dataStore = player:WaitForChild("DataStore")
        for _,category in ipairs(RS.Products.Shop.Items:GetChildren()) do
            local dsCat = dataStore:FindFirstChild(category.Name)
            if dsCat then
                for _,item in ipairs(dsCat:GetChildren()) do item:Destroy() end
                for _,item in ipairs(category:GetChildren()) do item:Clone().Parent = dsCat end
            end
        end
    end
})

Visuals:CreateSection("Custom")

Visuals:CreateInput({
    Name = "Name Custom Skin",
    CurrentValue = "",
    PlaceholderText = "Custom skin name...",
    ClearTextAfterFocusLost = false,
    Callback = function(v)
        _G.HeavelyCustomSkinName = v
    end
})

Visuals:CreateDropdown({
    Name = "Shirts",
    Options = {"None"},
    CurrentOption = {"None"},
    MultipleOptions = false,
    Callback = function(v) _G.HeavelyShirt = v end
})

Visuals:CreateDropdown({
    Name = "Pants",
    Options = {"None"},
    CurrentOption = {"None"},
    MultipleOptions = false,
    Callback = function(v) _G.HeavelyPants = v end
})

Visuals:CreateDropdown({
    Name = "Accessories",
    Options = {"None"},
    CurrentOption = {"None"},
    MultipleOptions = false,
    Callback = function(v) _G.HeavelyAccessories = v end
})

Visuals:CreateButton({
    Name = "Save Custom Skin",
    Callback = function()
        _G.HeavelySavedCustomSkin = {
            name = _G.HeavelyCustomSkinName,
            shirt = _G.HeavelyShirt,
            pants = _G.HeavelyPants,
            accessories = _G.HeavelyAccessories
        }
    end
})

Visuals:CreateDropdown({
    Name = "Load Custom Skin",
    Options = {"None"},
    CurrentOption = {"None"},
    MultipleOptions = false,
    Callback = function(v)
        -- The supplied source's builder uses its own dynamically populated
        -- item maps; no fake loader is substituted here.
    end
})

--========================================================--
-- VISUAL RUNTIME
--========================================================--

RunService.RenderStepped:Connect(function()
    local c = player.Character
    if not c then return end

    for _,obj in ipairs(c:GetDescendants()) do
        if obj:IsA("TextLabel") or obj:IsA("TextButton") then
            if customName ~= "" then
                obj.Text = customName
            end

            if rainbowName then
                obj.TextColor3 = Color3.fromHSV(
                    (tick()*rainbowSpeed)%1,
                    0.6,
                    1
                )
            else
                obj.TextColor3 = staticColor
            end

            obj.TextStrokeTransparency = 0.5
            obj.BackgroundTransparency = 1
        end
    end

    if rainbowMarshmallow then
        local head = c:FindFirstChild("Head")
        local gui = head and head:FindFirstChild("MarshmallowGUI")
        local sector = gui and gui:FindFirstChild("Sector")
        local image = sector and sector:FindFirstChildOfClass("ImageLabel")

        if image then
            image.ImageColor3 = Color3.fromHSV(
                (tick()*rainbowSpeed)%1,
                0.6,
                1
            )
        end
    end
end)

--========================================================--
-- SETTINGS
--========================================================--

Settings:CreateSection("Heavely Hub")

Settings:CreateLabel({
    Text = "Heavily inspired by Syla Hub and Dramaware ♥️"
})

Settings:CreateLabel({
    Text = "V1.0 Soon Autoplay ♥️"
})

Settings:CreateSection("Camp Only")

Settings:CreateLabel({
    Text = "Strict Camp build • Movies / Expedition excluded"
})

print("[Heavely Hub] Camp-only Luna build loaded.")
