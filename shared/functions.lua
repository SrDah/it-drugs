-- ┌─────────────────────────────────────────────┐
-- │ _____                 _   _                 │
-- │|  ___|   _ _ __   ___| |_(_) ___  _ __  ___ │
-- │| |_ | | | | '_ \ / __| __| |/ _ \| '_ \/ __|│
-- │|  _|| |_| | | | | (__| |_| | (_) | | | \__ \│
-- │|_|   \__,_|_| |_|\___|\__|_|\___/|_| |_|___/│
-- └─────────────────────────────────────────────┘

function SendPoliceAlert(coords)
    -- Add You own police alert system here
    local message = 'Drug Dealer spotted at '..coords
    TriggerEvent('chat:addMessage', {
        args = {message}
    })
end

function ShowTextUI(message, options)
    lib.showTextUI(message, {
        position = options.position or "left",
        icon = options.icon or "cannabis",
        color = options.color or "info",
    })
end

function CloseTextUI(message)
    local isOpen, text = lib.isTextUIOpen()
    if isOpen and text == message then
        lib.hideTextUI()
    end
end

function ShowNotification(source, message, type)
    -- Bridge.Functions.Notify(message, type) are the default Framework notifications
    -- You can change this to your own notification systems
    if source ~= nil then -- Server Messages
        if type == 'Error' then
            exports.qbx_core:Notify(source, 'Drogas', 'error', 5000, message)
        elseif type == 'Success' then
            exports.qbx_core:Notify(source, 'Drogas', 'success', 5000, message)
        else
            exports.qbx_core:Notify(source, 'Drogas', 'inform', 5000, message)
        end
    else -- Client Messages
        if type == 'Error' then
            exports.qbx_core:Notify('Drogas', 'error', 5000, message)
        elseif type == 'Success' then
            exports.qbx_core:Notify('Drogas', 'success', 5000, message)
        else
            exports.qbx_core:Notify('Drogas', 'inform', 5000, message)
        end
    end
end

function DrawText3D(x, y, z, text)
    local onScreen, _x, _y = World3dToScreen2d(x, y, z)
    local px, py, pz = table.unpack(GetGameplayCamCoord())
    local dist = GetDistanceBetweenCoords(px, py, pz, x, y, z, 1)
    local scale = (1 / dist) * 2
    local fov = (1 / GetGameplayCamFov()) * 100
    local scale = scale * fov
    if onScreen then
        SetTextScale(0.0, 0.35)
        SetTextFont(4)
        SetTextProportional(1)
        SetTextColour(255, 255, 255, 215)
        SetTextDropshadow(0, 0, 0, 0, 255)
        SetTextEdge(2, 0, 0, 0, 150)
        SetTextDropShadow()
        SetTextOutline()
        SetTextEntry('STRING')
        SetTextCentre(1)
        AddTextComponentString(text)
        DrawText(_x, _y)
    end
end


--- Show a progress bar
---@param progressBarData table
---@return boolean success
function ShowProgressBar(progressBarData)

    if lib.progressBar({
        duration = progressBarData.duration,
        label = progressBarData.label,
        useWhileDead = progressBarData.useWhileDead,
        disable = progressBarData.disable,
        canCancel = progressBarData.canCancel,
        controlDisables = progressBarData.controlDisables,
        anim = progressBarData.anim,
    }) then
        return true
    else
        return false
    end
end

--- Regenerates player food
function FoodRegen()
    print('Food Regen')
    -- QBCore Example
    -- TriggerEvent("QBCore:Server:SetMetaData", "hunger", 40000)
    --TriggerEvent("QBCore:Server:SetMetaData", "thirst", 20000)

    -- ESX Example
    -- TriggerEvent('esx_status:set', 'hunger', 1000000)
    -- TriggerEvent('esx_status:set', 'thirst', 1000000)
end