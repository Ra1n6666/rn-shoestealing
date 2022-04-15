local QBCore = nil

Citizen.CreateThread(function()
    TriggerEvent("QBCore:GetObject", function(obj) QBCore = obj end)
end)

RegisterServerEvent('rn-shoestealing:serverShoesSteal')
AddEventHandler('rn-shoestealing:serverShoesSteal', function(TargetSource)
    local Player = QBCore.Functions.GetPlayer(source)
    Player.Functions.AddItem("weapon_shoe", 1, false, false, true)
    TriggerClientEvent('rn-shoestealing:ShoesRemove', TargetSource)
end)