local QBCore = nil

Citizen.CreateThread(function()
    TriggerEvent("QBCore:GetObject", function(obj) QBCore = obj end)   
end)

Clothing = {}

Clothing.LoadAnimDict = function( dict )
    while ( not HasAnimDictLoaded( dict ) ) do
        RequestAnimDict( dict )
        Citizen.Wait( 5 )
    end
end

local canstealshoe = true
local shoeCooldown = 60000 * 5 -- 5 Minute cooldown for this player
RegisterNetEvent('rn-shoestealing:clientShoesSteal')
AddEventHandler('rn-shoestealing:clientShoesSteal', function()
    if canstealshoe then
        local Player, Distance = QBCore.Functions.GetClosestPlayer()
        if Player ~= -1 and Distance < 2.0 then
            Clothing.LoadAnimDict("random@domestic")
            TaskPlayAnim(PlayerPedId(), "random@domestic", "pickup_low", 5.0, 1.0, 1.0, 48, 0.0, 0, 0, 0)
            Citizen.Wait(1600)
            ClearPedTasks(PlayerPedId())
            local drawable = GetPedDrawableVariation(GetPlayerServerId(Player), 6)
            TriggerServerEvent('rn-shoestealing:serverShoesSteal', GetPlayerServerId(Player))
        end
        canstealshoe = false
        Citizen.Wait(shoeCooldown)
        canstealshoe = true
    else
        QBCore.Functions.Notify('Need to wait before trying to steal their shoes again!', 'error')
    end
end)

RegisterNetEvent('rn-shoestealing:ShoesRemove')
AddEventHandler('rn-shoestealing:ShoesRemove', function()
    local ClothingData = {}
    Clothing.Data[6] = {}
    Clothing.Data[6]["Prop"] = GetPedDrawableVariation(PlayerPedId(), 6)
    Clothing.Data[6]["Texture"] = GetPedTextureVariation(PlayerPedId(), 6)
    Clothing.Data[6]["Palette"] = GetPedPaletteVariation(PlayerPedId(), 6)
    if GetEntityModel(PlayerPedId()) == GetHashKey('mp_f_freemode_01') then
        SetPedComponentVariation(PlayerPedId(), 6, 56, 0, 0)
    else
        SetPedComponentVariation(PlayerPedId(), 6, 83, 0, 0)
    end
end)