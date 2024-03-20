RegisterNetEvent('pu_billing:client:bill', function()
    PlayerData = QBX.PlayerData
    if PlayerData.job.onduty and PlayerData.job.name ~= "unemployed" then
        local input = lib.inputDialog('Billing Portal', {'Session ID', 'Amount'})
        if not input then return end
        TriggerServerEvent('pu_billing:server:sendBill', input[1], input[2])
    else
        exports.qbx_core:Notify('You must be on duty to do that!', 'ban')
    end
end)

RegisterNetEvent('pu_billing:client:receiveBill', function(amount, job, token)
    if Config.Phone == "true" then
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
    elseif Config.Phone == "false" then
        local bill = lib.alertDialog({
            header = 'Billing Portal',
            content = ('Do you accept the bill? ($%s)\n From'.." "..job):format(amount),
            centered = true,
            cancel = true,
            labels = {
                cancel = 'Decline Bill',
                confirm = 'Accept Bill'
            }
        })
        if bill == 'confirm' then
            TriggerServerEvent("pu_billing:server:reply", token, true)
        else
            TriggerServerEvent("pu_billing:server:reply", token, false)
        end
    end
end)

RegisterNetEvent('pu_billing:client:receiveBillResponse', function(accepted, name, job, amount)
    if Config.Phone == "true" then
        exports["npwd"]:createSystemNotification({
            uniqId = accepted and "Pu_billing_paid" or "Pu_billing_rejected",
            content = accepted and ("Bill paid by %s at %s for $%s"):format(name, job, amount) or ("Bill rejected by %s"):format(name),
            secondaryTitle = ("from %s"):format(job),
            keepOpen = false,
            duration = Config.NotificationLength,
            controls = false,
        })
    elseif Config.Phone == "false" then
        if accepted then
            local bill = lib.alertDialog({
                header = 'Billing Portal',
                content = ('The bill sent to %s has been accepted  \n Total Cost: $%s'):format(name, amount),
                centered = true,
                cancel = true,
                labels = {
                    cancel = 'New Bill',
                    confirm = 'Close'
                }
            })
            if bill == 'cancel' then
                TriggerEvent('pu_billing:client:bill')
            end
        else
        local bill = lib.alertDialog({
            header = 'Billing Portal',
            content = ('The bill sent to'.." "..name.." "..'has been cancelled'..'\n Total Cost: '..""..amount):format(amount),
            centered = true,
            cancel = true,
            labels = {
                cancel = 'Rebill',
                confirm = 'Close'
            }
        })
        if bill == 'cancel' then
            TriggerEvent('pu_billing:client:bill')
        end
    end
end
end)