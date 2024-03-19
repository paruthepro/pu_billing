local waitingBills = {}

RegisterNetEvent("pu_billing:server:sendBill", function(target, amount)
    target = tonumber(target)
    amount = tonumber(amount)
    if not target or target <= 0 then return end
    if target == source then return end
    if not amount or amount <= 0 then return end

    local token = ("%s_%s"):format(target, os.time())
    local player = exports.qbx_core:GetPlayer(source)
    if not player.PlayerData.job.onduty then return end
    local job = player.PlayerData.job.name
    if job == "unemployed" then return end
    
    local targetPlayer = exports.qbx_core:GetPlayer(source)
    local name = ("%s %s"):format(targetPlayer.PlayerData.charinfo.firstname, targetPlayer.PlayerData.charinfo.lastname)
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
            exports.qbx_core:Notify(source, "Not enough money", "error")
            accepted = false
        else
            exports['Renewed-Banking']:handleTransaction(target.PlayerData.citizenid, 'Personal Account'.." / "..target.PlayerData.citizenid, bill.amount, bill.job.." - "..bill.name, bill.job, bill.job, 'withdraw')
            exports['Renewed-Banking']:handleTransaction(bill.job, bill.job, bill.amount, bill.job, bill.name, bill.job, 'deposit')
        end
    end
    TriggerClientEvent("pu_billing:client:receiveBillResponse", bill.from, accepted, bill.name, bill.job, bill.amount)
    waitingBills[token] = nil
end)
