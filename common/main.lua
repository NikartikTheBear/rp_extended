RPX = {}

function PrintConsole(str, ...)
    print("^0[^3RPX^0]: " .. str, ...)
end

exports("GetFramework", function()
    return RPX
end)