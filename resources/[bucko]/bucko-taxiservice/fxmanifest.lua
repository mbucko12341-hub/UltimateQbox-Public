fx_version 'cerulean'
game 'gta5'

description 'Bucko AI Taxi Service'
version '1.0.0'

shared_scripts {
    '@ox_lib/init.lua',
}

client_scripts {
    'client.lua'
}

server_scripts {
    'server.lua'
}

ui_page 'ui/index.html'

files {
    'ui/index.html',
    'ui/style.css',
    'ui/script.js',
    'ui/images/*.png' -- This line tells FiveM to load all PNGs in the images folder
}

dependencies {
    'qbx_core',
    'ox_target',
    'ox_lib'
}