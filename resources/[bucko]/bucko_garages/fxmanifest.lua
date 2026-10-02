fx_version 'cerulean'
game 'gta5'

description 'Bucko Garages - Custom Qbox Garage & Admin Tablet'
version '1.0.0'

-- Initialize ox_lib and oxmysql BEFORE qbx_core modules
shared_scripts {
    '@ox_lib/init.lua',
    '@oxmysql/lib/MySQL.lua', -- Added this line!
    '@qbx_core/modules/lib.lua'
}

client_scripts {
    'client/main.lua'
}

server_scripts {
    'server/main.lua'
}

ui_page 'ui/index.html'

files {
    'ui/index.html',
    'ui/style.css',
    'ui/script.js'
}