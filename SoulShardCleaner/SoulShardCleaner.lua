SoulShardCleanerDB = SoulShardCleanerDB or { limit = 20 }

local frame = CreateFrame("FRAME", "SoulShardCleanerFrame", UIParent)

local SOULSHARD_ID = 6265

frame:RegisterEvent("PLAYER_REGEN_ENABLED")
frame:RegisterEvent("PLAYER_LOGIN")
frame:RegisterEvent("ADDON_LOADED")

frame:SetScript(
    "OnEvent",
    function(self, event, containerId, ...)
        if event == "PLAYER_REGEN_ENABLED" or event == "PLAYER_LOGIN" then
            if UnitAffectingCombat("player") then
                return
            end

            local k = 0
            for i = 4, 0, -1 do
                for j = GetContainerNumSlots(i), 1, -1 do
                    local itemID = GetContainerItemID(i, j)
                    if SOULSHARD_ID == itemID then
                        k = k + 1
                        if k > SoulShardCleanerDB.limit then
                            PickupContainerItem(i, j)
                            DeleteCursorItem()
                        end
                    end
                end
            end
        end

        if event == "ADDON_LOADED" then
            SlashCmdList["SoulShardCleaner"] = HandleSlashCmd
            SLASH_SoulShardCleaner1 = "/ssc"
        end
    end
)

local cmdfuncs = {
    limit = function(v)
        SoulShardCleanerDB.limit = v
        ChatFrame1:AddMessage("SoulShardCleaner limit set to " .. SoulShardCleanerDB.limit, 1, 1, 0)
    end
}

local cmdtbl = {}

function HandleSlashCmd(cmd)
    for k in ipairs(cmdtbl) do
        cmdtbl[k] = nil
    end

    for v in gmatch(cmd, "[^ ]+") do
        tinsert(cmdtbl, v)
    end

    local cb = cmdfuncs[cmdtbl[1]]

    if cb then
        local s = tonumber(cmdtbl[2])
        cb(s)
    else
        ChatFrame1:AddMessage("-- limit <number> | value: " .. SoulShardCleanerDB.limit, 1, 1, 0)
    end
end
