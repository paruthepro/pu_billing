local waitingBills = {}

RegisterNetEvent("pu_billing:server:sendBill", function(target, amount)
    local token = ("%s_%s"):format(target, os.time())
    local player = exports.qbx_core:GetPlayer(source)
    local job = player.PlayerData.job.name
    local targetPlayer = exports.qbx_core:GetPlayer(source)
    local name = targetPlayer.PlayerData.charinfo.firstname.." "..targetPlayer.PlayerData.charinfo.lastname
    waitingBills[token] = {
        amount = amount,
        from = source,
        to = target,
        job = job,
        name = name
    }
    TriggerClientEvent("pu_billing:client:receiveBill", target, amount, job, token)
end)

RegisterNetEvent("pu_billing:server:reply", function(token, accepted)
    local bill = waitingBills[token]
    if not bill then return end
    if accepted then
        local target = exports.qbx_core:GetPlayer(source)
        local targetBalance = target.Functions.GetMoney('bank')
        if targetBalance < bill.amount then
            exports.core:Notify(source, "Not enough money", "error")
            accepted = false
        else
            target.Functions.RemoveMoney("bank", bill.amount, bill.job)
            exports["Renewed-Banking"]:addAccountMoney(bill.job, bill.amount)
        end
    end
    TriggerClientEvent("pu_billing:client:receiveBillResponse", bill.from, accepted, bill.name, bill.job, bill.amount)
    waitingBills[token] = nil
end)
