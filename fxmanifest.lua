fx_version "cerulean"
lua54 "yes"
game "gta5"

name         "rp_extended"
version      "1.0.0"
description  "A fully immersive framework."
author       "RP Extended"

shared_scripts {
    "@ox_lib/init.lua",
    "config.lua",
    "shared/*.lua",
    "locales/locale.lua",
    "locales/translations/*.lua",
    "common/main.lua",
    "common/modules/*.lua",
}

server_scripts {    
    "@mysql-async/lib/MySQL.lua",
    "bridge/**/server.lua",
    "server/main.lua",
    "server/modules/*.lua",
}

client_scripts {
    "client/main.lua",
    "client/modules/*.lua",
}