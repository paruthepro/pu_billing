RegisterNetEvent('pu_billing:client:bill', function()
    PlayerData = QBX.PlayerData
    local onDuty = PlayerData.job.onduty
    if onDuty then
        local input = lib.inputDialog('Billing Portal', {'Session ID', 'Amount'})
        if not input then return end
        TriggerServerEvent('pu_billing:server:sendBill', input[1], input[2])
    else
        exports.core:Notify('You must be on duty to do that!', 'ban')
    end
end)

RegisterNetEvent('pu_billing:client:receiveBill', function(amount, job, token)
    exports["npwd"]:createSystemNotification({
        uniqId = "Pu_billing",
        content = ("Do you accept the bill? ($%s)"):format(amount),
        secondaryTitle = ("From %s"):format(job),
        keepOpen = true,
        duration = Config.NotificationLength,
        controls = true,
        onConfirm = function()
            TriggerServerEvent("pu_billing:server:reply", token, true)
        end,
        onCancel = function()
          TriggerServerEvent("pu_billing:server:reply", token, false)
        end,
      })
end)

RegisterNetEvent('pu_billing:client:receiveBillResponse', function(accepted, name, job, amount)
    if accepted then
        exports["npwd"]:createSystemNotification({
            uniqId = "Pu_billing_paid",
            content = ("Bill paid by %s at %s for $%s"):format(name, job, amount),
            secondaryTitle = "from",
            keepOpen = false,
            duration = Config.NotificationLength,
            controls = false,
        })
    else
        exports["npwd"]:createSystemNotification({
            uniqId = "Pu_billing_rejected",
            content = ("Bill rejected by %s"):format(name),
            secondaryTitle = ("from %s"):format(job),
            keepOpen = false,
            duration = Config.NotificationLength,
            controls = false,
        })
    end
end)