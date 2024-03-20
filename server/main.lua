local waitingBills = {}
RegisterNetEvent("pu_billing:server:sendBill", function(target, amount)
    target = tonumber(target)
    amount = tonumber(amount)
    if not target or target <= 0 then return end
    if target == source then return end
    if not amount or amount <= 0 then return end

    local token = ("%s_%s"):format(target, os.time())
    local player = exports.qbx_core:GetPlayer(source) -- Modify this for your own framework (if QBX leave it)
    if not player.PlayerData.job.onduty then return end -- Modify this for your own framework (if QBX leave it)
    local job = player.PlayerData.job.name -- Modify this for your own framework (if QBX leave it)
    if job == "unemployed" then return end
    
    local targetPlayer = exports.qbx_core:GetPlayer(source) -- Modify this for your own framework
    local name = ("%s %s"):format(targetPlayer.PlayerData.charinfo.firstname, targetPlayer.PlayerData.charinfo.lastname) -- Modify this for your own framework (if QBX/QB leave it)
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
        local target = exports.qbx_core:GetPlayer(source) -- Modify this for your own framework (if QBX leave it)
        local targetBalance = target.Functions.GetMoney('bank') -- Modify this for your own framework (if QBX/QB leave it)
        if targetBalance < bill.amount then
            exports.qbx_core:Notify(source, "Not enough money", "error") -- Modify this for your own notifications (if QBX leave it)
            accepted = false
        else
            if Config.Framework == 'qbx' then
                exports['Renewed-Banking']:handleTransaction(target.PlayerData.citizenid, 'Personal Account'.." / "..target.PlayerData.citizenid, bill.amount, bill.job.." - "..bill.name, bill.job, bill.job, 'withdraw')
                target.Functions.RemoveMoney('bank', bill.amount)
                exports['Renewed-Banking']:handleTransaction(bill.job, bill.job, bill.amount, bill.job.."-"..target.PlayerData.charinfo.firstname.." "..target.PlayerData.charinfo.lastname, target.PlayerData.charinfo.firstname.." "..target.PlayerData.charinfo.lastname, bill.job, 'deposit')
                exports['Renewed-Banking']:addAccountMoney(bill.job, bill.amount)
            elseif Config.Framework == 'pefcl' then
                if not exports.pefcl:removeBankBalance(target, { amount = bill.amount, message = bill.job.." - "..bill.name }) then return end
                exports.pefcl:addBankBalance(bill.job, { amount = bill.amount, message = bill.job.." - "..target.PlayerData.charinfo.firstname.." "..target.PlayerData.charinfo.lastname })
            elseif Config.Framework == 'custom' then
                BankingTransactions(bill)
            end
        end
    end
    TriggerClientEvent("pu_billing:client:receiveBillResponse", bill.from, accepted, bill.name, bill.job, bill.amount)
    waitingBills[token] = nil
end)
