local Tunnel = module("vrp","lib/Tunnel")
local Proxy = module("vrp","lib/Proxy")


vRP = Proxy.getInterface("vRP")
vRPclient = Tunnel.getInterface("vRP")

vRPN = {}
Tunnel.bindInterface("brt_identityfarm",vRPN)
Proxy.addInterface("brt_identityfarm",vRPN)
--------------------------------------------------------------------
-- [Webhhok] -------------------------------------------------------
--------------------------------------------------------------------
local webhookbo = "https://discord.com/api/webhooks/775481554154815498/eVzXfNH8d25Yedq4CSVJ7MTrQr1NaT2xjhpB1fRrbDkjxmdO6ejVLJWDTz1dal8trxkn"

function SendWebhookMessage(webhook,message)
	if webhook ~= nil and webhook ~= "" then
		PerformHttpRequest(webhook, function(err, text, headers) end, 'POST', json.encode({content = message}), { ['Content-Type'] = 'application/json' })
	end
end
--------------------------------------------------------------------
-- [Funções] -------------------------------------------------------
--------------------------------------------------------------------
local reward = {250,400} -- Quantia que irá receber

RegisterNetEvent("brt_identityfarm:animationlaptop")
AddEventHandler("brt_identityfarm:animationlaptop", function()
    local user_id = vRP.getUserId(source)
    local source = source
    local ped = GetPlayerPed(source)
    local motivo = vRP.prompt(source,"Motivo:","")
    local oficialid = vRP.getUserIdentity(user_id)
    local identity = vRP.getUserIdentity(parseInt(id))
    TriggerClientEvent("emotes",source,"digitar")
    TriggerClientEvent("progress",source,5000,"Registrando")

    SetTimeout(5000, function()
        vRPclient._stopAnim(source,false)
        TriggerClientEvent("Notify",source,"sucesso","Você registrou o Boletim de Ocorrência! Vá à impressora.")
        -- SendWebhookMessage(webhookbo,"```prolog\n[OFICIAL]: "..user_id.." "..oficialid.name.." "..oficialid.firstname.." \n[==============ADICIONOU UM BOLETIM DE OCORRENCIA==============] \n[MOTIVO]: "..motivo.." "..os.date("\n[Data]: %d/%m/%Y [Hora]: %H:%M:%S").." \r```")
    end)
end)

RegisterNetEvent("brt_identityfarm:animationimpressor")
AddEventHandler("brt_identityfarm:animationimpressor", function()
	local source = source
    local user_id = vRP.getUserId(source)
    TriggerClientEvent("emotes",source,"mexer")
    TriggerClientEvent("progress",source,3000,"Pegando")

    SetTimeout(3000, function()
        vRPclient._stopAnim(source,false)
        vRPclient.playSound(source,"Hack_Success","DLC_HEIST_BIOLAB_PREP_HACKING_SOUNDS")
        vRP.giveInventoryItem(user_id,"boletim",1,true)
    end)
end)

RegisterNetEvent("brt_identityfarm:atendente")
AddEventHandler("brt_identityfarm:atendente", function()
	local source = source
    local user_id = vRP.getUserId(source)
    if vRP.getInventoryItemAmount(user_id,"identidade") >= 1 then
        if vRP.tryGetInventoryItem(user_id,"boletim",1) then
            TriggerClientEvent("emotes",source,"debrucar")
            TriggerClientEvent("progress",source,15000,"Pegando")
            SetTimeout(15000, function()
                vRPclient._stopAnim(source,false)
                vRPclient.playSound(source,"Hack_Success","DLC_HEIST_BIOLAB_PREP_HACKING_SOUNDS")
                vRP.tryGetInventoryItem(user_id,"boletim",1)
                vRP.giveInventoryItem(user_id,"identidade",1,true)
            end)
        else
            TriggerClientEvent("Notify",source,"negado","Você já possui uma identidade")
        end
    else
        TriggerClientEvent("Notify",source,"negado","Você não possui um Boletim")
    end
end)

RegisterNetEvent("brt_identityfarm:receber")
AddEventHandler("brt_identityfarm:receber", function()
	local source = source
    local user_id = vRP.getUserId(source)

    local x,y = table.unpack(reward)
    local rewardValue = math.random(x, y)
    vRP.tryGetInventoryItem(user_id,"identidaderoubada",1)
	vRP.giveInventoryItem(user_id,"dinheirosujo",rewardValue)
	TriggerClientEvent("Notify",source,"sucesso","Você recebeu R$"..rewardValue.." de Dinheiro Sujo!")
end)

function vRPN.checarPermissaoPolicia()
    local source = source
    local user_id = vRP.getUserId(source)
    if vRP.hasPermission(user_id,"policia.permissao") then
        return true
    end
end