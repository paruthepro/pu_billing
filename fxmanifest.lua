fx_version 'cerulean'
game 'gta5'

lua54 'yes'

author 'Paru'
description 'A generic Ox Lib based Billing resource created by Paru.'
version '1.2'

shared_scripts {
    '@qbx_core/modules/playerdata.lua',
	'@ox_lib/init.lua',
	'config.lua'
}

client_scripts {
	'client/main.lua',
}

server_scripts {
	'server/*.lua'
}
