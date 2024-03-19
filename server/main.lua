RegisterNetEvent('pu_billing:server:payment', function(biller, amount, job, billername, billed, buyer)
    local buyer2 = exports.core:GetPlayer(source)
    local buyname = buyer.charinfo.firstname.." ".. buyer.charinfo.lastname
    if not buyer2.Functions.RemoveMoney('bank', amount, job.." "..billername) then
        return exports.core:Notify(source, 'Not enough money', 'error')
    end
    exports['Renewed-Banking']:addAccountMoney(job, amount, billed)
    Wait(100)
    TriggerClientEvent('pu_billing:client:paid', biller.source, job, buyname, amount)
end)

RegisterNetEvent('pu_billing:server:convert', function(sessionid, amount, Job, billername, biller, billed)
TriggerClientEvent('pu_billing:client:sendbill', sessionid, amount, Job, billername, biller, sessionid, billed)
end)

RegisterNetEvent('pu_billing:server:rejected', function(id, name, job)
    TriggerClientEvent('pu_billing:client:rejected', id, name, job)
end)