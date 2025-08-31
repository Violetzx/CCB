-- =================================================================================
-- Import base file
-- =================================================================================
local files = {
    "chatpanel_MPH.lua",
    "ChatPanel.lua",
}

for _, file in ipairs(files) do
    include(file)
    if Initialize then
        print("Loading " .. file .. " as base file");
        break
    end
end

function TPT_LateInitialize()
	Controls.BlackListPanelButton:RegisterCallback(Mouse.eLClick, function() LuaEvents.Open_BlackListOanel() end);
end
TPT_LateInitialize()