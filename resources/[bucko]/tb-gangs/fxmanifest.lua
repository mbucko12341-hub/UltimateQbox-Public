fx_version 'cerulean'
game 'gta5'
lua54 'yes'

name 'tb-gangs'
description 'Advanced Gang, Turf, Reputation & 3D Graffiti System for Qbox'
version '2.0.0'

ui_page 'web/index.html'

shared_scripts {
    '@ox_lib/init.lua',
    '@qbx_core/modules/lib.lua',
    'config.lua'
}

client_scripts {
    '@qbx_core/modules/playerdata.lua',
    'client/main.lua',
    'client/turfs.lua',
    'client/sprays.lua',
    'client/stashes.lua',
    'client/admin.lua'
}

server_scripts {
    '@oxmysql/lib/MySQL.lua',
    'server/main.lua',
    'server/turfs.lua',
    'server/sprays.lua',
    'server/stashes.lua',
    'server/admin.lua'
}

files {
    'web/index.html',
    'web/style.css',
    'web/script.js',
    'web/sprays/*.png'
}