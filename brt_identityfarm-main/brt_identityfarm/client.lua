local Tunnel = module("vrp","lib/Tunnel")
local Proxy = module("vrp","lib/Proxy")

vSERVER = Tunnel.getInterface("brt_identityfarm")

brt = {}
Tunnel.bindInterface("brt_identityfarm", brt)

vRP = Proxy.getInterface("vRP")
vRPclient = Proxy.getInterface("vRP")
----------------------------------------------------------------------
-- [Locais] ----------------------------------------------------------
----------------------------------------------------------------------
local laptop = {441.92,-978.95,30.68} -- Onde o policial irá registrar o Boletim de Ocorrência
local impressora = {441.18,-975.62,30.68} -- Onde o policial irá pegar a impressão do Boletim de Ocorrência
local atendente = {-929.78,-2039.83,9.40} -- Onde o player irá pegar a segunda via
local casinha = {-319.88,-1389.65,36.50} -- Onde o player irá vender as identidades roubadas

local lapitopi = 0
----------------------------------------------------------------------
-- [Função 1] --------------------------------------------------------
----------------------------------------------------------------------
Citizen.CreateThread(function()
    while true do
        local idle = 500
        local source = source
        local user_id = vRP.getUserId(source)
        local distance = GetDistanceBetweenCoords(GetEntityCoords(PlayerPedId()),laptop[1],laptop[2],laptop[3],true)
        local distance2 = GetDistanceBetweenCoords(GetEntityCoords(PlayerPedId()),impressora[1],impressora[2],impressora[3],true)
        if lapitopi == 0 then
            if distance <= 3 then
                idle = 5
                DrawMarker(21, laptop[1], laptop[2], laptop[3]-0.5, 0, 0, 0, 180.0, 0, 0, 0.4, 0.4, 0.4, 0, 255, 255, 150, 0, 0, 0, 1)
                if distance <= 1 then
                    idle = 5
                    text3D(laptop[1], laptop[2], laptop[3]+0.5, '~o~[E] ~w~PARA REGISTRAR O ~r~Boletim')
                    if IsControlJustPressed(0, 38) and vSERVER.checarPermissaoPolicia() then
                        TriggerServerEvent("brt_identityfarm:animationlaptop")
                        lapitopi = 1
                    end
                end
            end
        elseif lapitopi == 1 then
            if distance2 <= 3 then
                idle = 5
                DrawMarker(21, impressora[1], impressora[2], impressora[3]-0.5, 0, 0, 0, 180.0, 0, 0, 0.4, 0.4, 0.4, 0, 255, 255, 150, 0, 0, 0, 1)
                if distance2 <= 1 then
                    idle = 5
                    text3D(impressora[1], impressora[2], impressora[3]+0.5, '~o~[E] ~w~PARA PEGAR O ~r~Boletim')
                    if IsControlJustPressed(0, 38) and vSERVER.checarPermissaoPolicia() then
                        TriggerServerEvent("brt_identityfarm:animationimpressor")
                        lapitopi = 0
                    end
                end
            end
        end
        Citizen.Wait(idle)
    end
end)

Citizen.CreateThread(function()
    while true do
        local victtin = 500
        local source = source
        local user_id = vRP.getUserId(source)
        local distance3 = GetDistanceBetweenCoords(GetEntityCoords(PlayerPedId()),atendente[1],atendente[2],atendente[3],true)
        if distance3 <= 3 then
            victtin = 5
            DrawMarker(21, atendente[1], atendente[2], atendente[3]-0.5, 0, 0, 0, 180.0, 0, 0, 0.4, 0.4, 0.4, 0, 255, 255, 150, 0, 0, 0, 1)
            if distance3 <= 1 then
                victtin = 5
                text3D(atendente[1], atendente[2], atendente[3]+0.5, '~o~[E] ~w~PARA RETIRAR A ~b~Segunda via')
                if IsControlJustPressed(0, 38) then
                    TriggerServerEvent("brt_identityfarm:atendente")
                end
            end
        end
        Citizen.Wait(victtin)
    end
end)

Citizen.CreateThread(function()
    while true do
        local victtin = 500
        local source = source
        local user_id = vRP.getUserId(source)
        local distance4 = GetDistanceBetweenCoords(GetEntityCoords(PlayerPedId()),casinha[1],casinha[2],casinha[3],true)
        if distance4 <= 3 then
            victtin = 5
            DrawMarker(21, casinha[1], casinha[2], casinha[3]-0.5, 0, 0, 0, 180.0, 0, 0, 0.4, 0.4, 0.4, 0, 255, 255, 150, 0, 0, 0, 1)
            if distance4 <= 1 then
                victtin = 5
                text3D(casinha[1], casinha[2], casinha[3]+0.5, '~o~[E] ~w~PARA VENDER A ~b~Identidade Roubada')
                if IsControlJustPressed(0, 38) then
                    TriggerServerEvent("brt_identityfarm:receber")
                end
            end
        end
        Citizen.Wait(victtin)
    end
end)

function text3D(x,y,z,text)
	local onScreen,_x,_y = World3dToScreen2d(x,y,z)

	SetTextFont(4)
	SetTextScale(0.35,0.35)
	SetTextColour(255,255,255,150)
	SetTextEntry("STRING")
	SetTextCentre(1)
	AddTextComponentString(text)
	DrawText(_x,_y)
	local factor = (string.len(text))/370
	DrawRect(_x,_y+0.0125,0.01+factor,0.03,0,0,0,80)
end