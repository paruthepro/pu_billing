RegisterNetEvent('pu_billing:client:bill', function()
    PlayerData = QBX.PlayerData
    local onDuty = PlayerData.job.onduty
    local Job = PlayerData.job.name
    local billername = PlayerData.charinfo.firstname.." "..PlayerData.charinfo.lastname
    if onDuty then
        local input = lib.inputDialog('Billing Portal', {'Session ID', 'Amount'})
        if not input then return end
        json.encode(input)
    TriggerServerEvent('pu_billing:server:convert', input[1], input[2], Job, billername, PlayerData, PlayerData)
    else
        exports.core:Notify('You must be on duty to do that!', 'ban')
    end
end)
RegisterNetEvent('pu_billing:client:sendbill', function(amount, Job, billername, biller, billed, buyer)
    Wait(1000)
    exports["npwd"]:createSystemNotification({
        uniqId = "Pu_billing",
        content = "Do you accept the bill?".." "..(("$"..amount)),
        secondaryTitle = "From".." "..Job,
        keepOpen = true,
        duration = Config.NotificationLength,
        controls = true,
        onConfirm = function()
            TriggerServerEvent('pu_billing:server:payment', biller, amount, Job, billername, billed, buyer)
        end,
        onCancel = function()
          TriggerServerEvent('pu_billing:server:rejected', biller.source, billername, Job)
        end,
      })
end)
RegisterNetEvent('pu_billing:client:rejected', function(name, job)
    Wait(1000)
    exports["npwd"]:createSystemNotification({
        uniqId = "Pu_billing_rejected",
        content = "Bill rejected by".." "..name,
        secondaryTitle = "from".. " ".. job,
        keepOpen = false,
        duration = Config.NotificationLength,
        controls = false,
      })
end)
RegisterNetEvent('pu_billing:client:paid', function(job, name, amount)
    Wait(1000)
    exports["npwd"]:createSystemNotification({
        uniqId = "Pu_billing_paid",
        content = "Bill paid by".." "..name.." ".."at".." "..job.." ".."for".." ".."$"..amount,
        secondaryTitle = "from",
        keepOpen = false,
        duration = Config.NotificationLength,
        controls = false,
      })
end)