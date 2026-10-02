fx_version 'cerulean'
game 'gta5'

author 'Bucko'
description 'Custom Modern City Hall for QBX'
version '1.1.0'

shared_script '@ox_lib/init.lua'
shared_script 'shared/config.lua'

client_script 'client/main.lua'
server_script 'server/main.lua'

ui_page 'html/index.html'

files {
    'html/index.html',
    'html/style.css',
    'html/script.js'
}