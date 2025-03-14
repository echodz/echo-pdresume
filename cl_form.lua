local QBCore = exports['qb-core']:GetCoreObject()

local open = false
local PlayerJob = {}

CreateThread(function()
    TriggerEvent("QBCore:GetObject", function(obj) QBCore = obj end)
    while QBCore == nil do
        Wait(100)
        TriggerEvent("QBCore:GetObject", function(obj) QBCore = obj end)
    end

    while QBCore.Functions.GetPlayerData().job == nil do Wait(100) end
    PlayerJob = QBCore.Functions.GetPlayerData().job
end)

RegisterNetEvent('QBCore:Client:OnPlayerLoaded')
AddEventHandler('QBCore:Client:OnPlayerLoaded', function()
    PlayerJob = QBCore.Functions.GetPlayerData().job
end)

RegisterNetEvent('QBCore:Client:OnJobUpdate')
AddEventHandler('QBCore:Client:OnJobUpdate', function(JobInfo)
    PlayerJob = JobInfo
end)

CreateThread(function()
    exports['qb-target']:AddBoxZone('Police_Forms', vector3(442.33, -984.09, 30.69), 0.2, 1, {
        name="Police_Forms",
        heading=0,
        minZ=26.92,
        maxZ=30.92
    }, {
        options = {
            {
                action = function()
                    SetNuiFocus(true, true)
                    TriggerServerEvent("police-froms:client:anim")
                    SendNUIMessage({action = "open-from"})
                end,
                icon = 'fas fa-scroll',
                label = 'Open Forms',
                job = 'all'
            },
        },
        distance = 2.5
    })
end)

local prop = nil
local secondaryprop = nil
RegisterNetEvent('police-froms:client:anim')
AddEventHandler('police-froms:client:anim', function()
    local player = PlayerPedId()
    local ad = "missheistdockssetup1clipboard@base"
                
    local prop_name = 'prop_notepad_01'
    local secondaryprop_name = 'prop_pencil_01'
    
    if DoesEntityExist(player) and not IsEntityDead(player) then 
        loadAnimDict(ad)
        if IsEntityPlayingAnim( player, ad, "base", 3 ) then 
            TaskPlayAnim( player, ad, "exit", 8.0, 1.0, -1, 49, 0, 0, 0, 0 )
            Wait(100)
            ClearPedSecondaryTask(player)
            DetachEntity(prop, 1, 1)
            DeleteObject(prop)
            DetachEntity(secondaryprop, 1, 1)
            DeleteObject(secondaryprop)
        else
            local x,y,z = table.unpack(GetEntityCoords(player))
            prop = CreateObject(GetHashKey(prop_name), x, y, z+0.2,  true,  true, true)
            secondaryprop = CreateObject(GetHashKey(secondaryprop_name), x, y, z+0.2,  true,  true, true)
            AttachEntityToEntity(prop, player, GetPedBoneIndex(player, 18905), 0.1, 0.02, 0.05, 10.0, 0.0, 0.0, true, true, false, true, 1, true)
            AttachEntityToEntity(secondaryprop, player, GetPedBoneIndex(player, 58866), 0.12, 0.0, 0.001, -150.0, 0.0, 0.0, true, true, false, true, 1, true)
            TaskPlayAnim(player, ad, "base", 8.0, 1.0, -1, 49, 0, 0, 0, 0 )
        end 
    end
end)
    
RegisterNUICallback("send", function(data,cb)
    if data.data then
        close()
        TriggerServerEvent("police-froms:server:send", data.data)
    end
end)

RegisterNUICallback("close", function(data,cb)
    close()
end)

function close()
    TaskPlayAnim(PlayerPedId(), "missheistdockssetup1clipboard@base", "exit", 8.0, 1.0, -1, 49, 0, 0, 0, 0 )
    Wait(100)
    ClearPedSecondaryTask(PlayerPedId())
    DetachEntity(prop, 1, 1)
    DeleteObject(prop)
    DetachEntity(secondaryprop, 1, 1)
    DeleteObject(secondaryprop)

    open = false
    SetNuiFocus(false, false)
end

function loadAnimDict(dict)
    while (not HasAnimDictLoaded(dict)) do
        RequestAnimDict(dict)
        Wait(10)
    end
end

function DrawText3Ds(x,y,z, text)
    local onScreen, _x, _y = World3dToScreen2d(x, y, z)
    local p = GetGameplayCamCoords()
    local distance = GetDistanceBetweenCoords(p.x, p.y, p.z, x, y, z, 1)
    local scale = (1 / distance) * 2
    local fov = (1 / GetGameplayCamFov()) * 100
    local scale = scale * fov
    if onScreen then
      SetTextScale(0.30, 0.30)
      SetTextFont(4)
      SetTextProportional(1)
      SetTextColour(255, 255, 255, 215)
      SetTextEntry("STRING")
      SetTextCentre(1)
      AddTextComponentString(text)
      DrawText(_x,_y)
      local factor = (string.len(text)) / 370
      DrawRect(_x,_y+0.0120, factor, 0.026, 41, 11, 41, 68)
    end
end