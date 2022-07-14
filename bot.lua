-- wait

repeat wait() until game:IsLoaded() 

-- services

local workspace = game:GetService('Workspace')
local players = game:GetService('Players')

local replicatedstorage = game:GetService('ReplicatedStorage')
local httpservice = game:GetService('HttpService')

local teleportservice = game:GetService('TeleportService')

-- variables

local localplayer = players.LocalPlayer

local character = localplayer.Character
local humanoidrootpart = character.HumanoidRootPart

local chat_events = replicatedstorage.DefaultChatSystemChatEvents

-- wait

repeat wait() until character and humanoidrootpart

-- functions

local function chat(message) 
    chat_events.SayMessageRequest:FireServer(message or '', 'All')
end

function json_decode(string)
    return httpservice:JSONDecode(string)
end

function join_random_server()
    local max_players = nil
    local job_ids = {}
    local response = json_decode(game:HttpGet(
        string.format('https://games.roblox.com/v1/games/%s/servers/Public?sortOrder=Asc&limit=100&cursor=', game.PlaceId)
    ))
    
    for _ = 1, 100, 1 do
        for _, data in pairs(response.data) do
            if data.playing ~= data.maxPlayers then
                max_players = data.maxPlayers
                
                table.insert(job_ids, {
                    ['job_id'] = data.id,
                    ['users'] = data.playing
                })
            end
        end
        
        if response.nextPageCursor ~= nil then 
            response = json_decode(game:HttpGet(
                string.format('https://games.roblox.com/v1/games/%s/servers/Public?sortOrder=Asc&limit=100&cursor=%s', game.PlaceId, response.nextPageCursor)
            )) 
        else 
            break
        end
    end

    teleportservice:TeleportToPlaceInstance(
        game.PlaceId,
        job_ids[math.random(1, #job_ids)].job_id,
        localplayer
    )
end

-- anti-void

workspace.FallenPartsDestroyHeight = 0/0

-- remove seats

for _, part in ipairs(workspace:GetDescendants()) do
    if part:IsA('Seat') then
        part:Destroy()
    end
end

-- chats

success, error_message = pcall(function()
    for _, player in pairs(players:GetPlayers()) do
        player_character = player.Character
        player_humanoidrootpart = player_character:FindFirstChild('HumanoidRootPart')
        
        if player_character and player_humanoidrootpart and player ~= localplayer then 
            humanoidrootpart.CFrame = player_humanoidrootpart.CFrame
            chat('hi')
            
            wait(2.5)
        end
    end
end)

-- loop

repeat wait(1); join_random_server() until nil 
