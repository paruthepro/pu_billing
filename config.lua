Config = {}
Config.Framework = 'qbx' -- Banking method, accepts 'qbx' for Renewed Banking, 'pefcl' for Project Error's PEFCL & 'custom' for your own banking methodology. (Modify the server/transactions.lua)
Config.NotificationLength = 7500 -- Length of time Phone notifications display
Config.NPWD = true -- This is used for adjusting the billing notifications, if set to false will utilise lib.alertDialog instead.