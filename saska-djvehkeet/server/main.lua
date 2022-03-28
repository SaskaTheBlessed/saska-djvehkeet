ESX = nil

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

RegisterServerEvent('saska-djvehkeet:play_music')
AddEventHandler('saska-djvehkeet:play_music', function(id, coords)
	local xPlayer = ESX.GetPlayerFromId(source)
	TriggerClientEvent('saska-djvehkeet:play_music', -1, id, coords)
end)

RegisterServerEvent('saska-djvehkeet:stop_music')
AddEventHandler('saska-djvehkeet:stop_music', function(coords)
	local xPlayer = ESX.GetPlayerFromId(source)
	TriggerClientEvent('saska-djvehkeet:stop_music', -1, coords)
end)

RegisterServerEvent('saska-djvehkeet:setVolume')
AddEventHandler('saska-djvehkeet:setVolume', function(volume, coords)
	local xPlayer = ESX.GetPlayerFromId(source)
	TriggerClientEvent('saska-djvehkeet:setVolume', -1, volume, coords)
end)
