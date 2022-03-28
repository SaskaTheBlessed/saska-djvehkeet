Keys = {
    ["ESC"] = 322, ["F1"] = 288, ["F2"] = 289, ["F3"] = 170, ["F5"] = 166, ["F6"] = 167, ["F7"] = 168, ["F8"] = 169, ["F9"] = 56, ["F10"] = 57,
    ["~"] = 243, ["1"] = 157, ["2"] = 158, ["3"] = 160, ["4"] = 164, ["5"] = 165, ["6"] = 159, ["7"] = 161, ["8"] = 162, ["9"] = 163, ["-"] = 84, ["="] = 83, ["BACKSPACE"] = 177,
    ["TAB"] = 37, ["Q"] = 44, ["W"] = 32, ["E"] = 38, ["R"] = 45, ["T"] = 245, ["Y"] = 246, ["U"] = 303, ["P"] = 199, ["["] = 39, ["]"] = 40, ["ENTER"] = 18,
    ["CAPS"] = 137, ["A"] = 34, ["S"] = 8, ["D"] = 9, ["F"] = 23, ["G"] = 47, ["H"] = 74, ["K"] = 311, ["L"] = 182,
    ["LEFTSHIFT"] = 21, ["Z"] = 20, ["X"] = 73, ["C"] = 26, ["V"] = 0, ["B"] = 29, ["N"] = 249, ["M"] = 244, [","] = 82, ["."] = 81,
    ["LEFTCTRL"] = 36, ["LEFTALT"] = 19, ["SPACE"] = 22, ["RIGHTCTRL"] = 70,
    ["HOME"] = 213, ["PAGEUP"] = 10, ["PAGEDOWN"] = 11, ["DELETE"] = 178,
    ["LEFT"] = 174, ["RIGHT"] = 175, ["TOP"] = 27, ["DOWN"] = 173,
    ["NENTER"] = 201, ["N4"] = 108, ["N5"] = 60, ["N6"] = 107, ["N+"] = 96, ["N-"] = 97, ["N7"] = 117, ["N8"] = 61, ["N9"] = 118
}

ESX = nil
local menuOpen = false
local wasOpen = false
local lastEntity = nil
local currentAction = nil
local currentData = nil

Citizen.CreateThread(function()
    while ESX == nil do
        TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
        Citizen.Wait(0)
    end

    while ESX.GetPlayerData().job == nil do
        Citizen.Wait(100)
    end

    ESX.PlayerData = ESX.GetPlayerData()
end)

RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(xPlayer)
    while ESX == nil do
        Citizen.Wait(0)
    end
    ESX.PlayerData = xPlayer
    PlayerLoaded = true
end)

RegisterNetEvent('esx:setJob')
AddEventHandler('esx:setJob', function(job)
    ESX.PlayerData.job = job
end)

function distance(object)
    local playerPed = PlayerPedId()
    local lCoords = GetEntityCoords(playerPed)
    local distance  = GetDistanceBetweenCoords(lCoords, object, true)
    return distance
end

RegisterNetEvent('saska-djvehkeet:play_music')
AddEventHandler('saska-djvehkeet:play_music', function(id, object)
    local playerCoords = GetEntityCoords(PlayerPedId())

    if distance(object) < Config.distance then
        SendNUIMessage({
            transactionType = 'playSound',
            transactionData = id
        })

        Citizen.CreateThread(function()
            while true do
                Citizen.Wait(100)
                if distance(object) > Config.distance then
                    SendNUIMessage({
                        transactionType = 'stopSound'
                    })
                    break
                end
            end
        end)
    end
end)

RegisterNetEvent('saska-djvehkeet:stop_music')
AddEventHandler('saska-djvehkeet:stop_music', function(object)
    local playerCoords = GetEntityCoords(PlayerPedId())
    if distance(object) < Config.distance then
        SendNUIMessage({
            transactionType = 'stopSound'
        })
    end
end)

RegisterNetEvent('saska-djvehkeet:setVolume')
AddEventHandler('saska-djvehkeet:setVolume', function(volume, object)
    local playerCoords = GetEntityCoords(PlayerPedId())
    if distance(object) < Config.distance then
        SendNUIMessage({
            transactionType = 'volume',
            transactionData = volume
        })
    end
end)

local paska69 = fJ9rUzIMcZQ


function OpenhifiMenu()
    menuOpen = true
    ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'saska-djvehkeet', {
        title   = 'Musiikintoistojärjestelmä',
        align   = 'right',
        elements = {
            {label = ('Laita Kappale'), value = 'play'},
            {label = ('Äänenvoimakkuus'), value = 'volume'},
            {label = ('Lopeta Kappale'), value = 'stop'}
        }
    }, function(data, menu)
        local playerPed = PlayerPedId()
        local lCoords = GetEntityCoords(playerPed)

       if data.current.value == 'play' then
            play(lCoords)
        elseif data.current.value == 'stop' then
            TriggerServerEvent('saska-djvehkeet:stop_music', lCoords)
            menuOpen = false
            menu.close()
        elseif data.current.value == 'volume' then
            setVolume(lCoords)
        end
    end, function(data, menu)
        menuOpen = false
        menu.close()
    end)
end

function setVolume(coords)
    ESX.UI.Menu.Open('dialog', GetCurrentResourceName(), 'setvolume',
        {
            title = ('Nosta äänenvoimakkuutta'),
        }, function(data, menu)
            local value = tonumber(data.value)
            if value < 0 or value > 100 then
                ESX.ShowNotification('Max volume on 100!')
            else
                TriggerServerEvent('saska-djvehkeet:setVolume', value, coords)
                menu.close()
            end
        end, function(data, menu)
            menu.close()
        end)
end


function play(coords)
    ESX.UI.Menu.Open('dialog', GetCurrentResourceName(), 'play',
        {
            title = ('Laita kappale'),
        }, function(data, menu)
            TriggerServerEvent('saska-djvehkeet:play_music', data.value, coords)
            menu.close()
        end, function(data, menu)
            menu.close()
        end)
end


Citizen.CreateThread(function()

    while true do

        Citizen.Wait(0)

        local playerCoords = GetEntityCoords(PlayerPedId())

     --   for i = 1, #Jobit, 1 do
            if ESX.PlayerData.job and ESX.PlayerData.job.name == 'bahama_mamas' or ESX.PlayerData.job and ESX.PlayerData.job.name == 'yksi' then

            for k,v in pairs(Config.Musamestat) do

				local distance = GetDistanceBetweenCoords(playerCoords, v, true)

				if distance < 5 then

                    DrawMarker(2, v.x, v.y, v.z , 0.0, 0.0, 0.0, 0.0, 0.0, 0.0,0.3, 0.2, 0.15, 51, 255, 243, 100, false, true, 2, false, nil, nil, false)

                    if distance < 1 then

                ESX.ShowHelpNotification('E - Laittaaksesi musiikkia')

            if IsControlJustReleased(0, 38) then

                OpenhifiMenu()

                              --  end

                        end

                    end

                end

            end

        end

    end

end)


function startAnimation(lib,anim)
    ESX.Streaming.RequestAnimDict(lib, function()
        TaskPlayAnim(PlayerPedId(), lib, anim, 8.0, -8.0, -1, 1, 0, false, false, false)
    end)
end