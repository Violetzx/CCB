local Suk_UI_InUse = Modding.IsModActive("805cc499-c534-4e0a-bdce-32fb3c53ba38")		-- 不能和 Sukritact's Simple UI Adjustments 一起用

BASE_CityBanner_UpdateRangeStrike = CityBanner.UpdateRangeStrike
local CanCityStrikeButtonRevoke = false

if not Suk_UI_InUse then
	function CityBanner.UpdateRangeStrike(self)

		BASE_CityBanner_UpdateRangeStrike(self)

		local tBanner = self.m_Instance
		
		if tBanner.CityStrike ~= nil then
			if CanCityStrikeButtonRevoke then
				tBanner.CityStrike:SetAnchor("C,B")
				tBanner.CityStrike:SetOffsetVal(0,-6)

				tBanner.CityStrikeButton:SetAnchor("C,B")
				tBanner.CityStrikeButton:SetOffsetVal(0,10)	
			else
				tBanner.CityStrike:SetAnchor("R,C")
				tBanner.CityStrike:SetOffsetVal(-32,0)

				tBanner.CityStrikeButton:SetAnchor("L,C")
				tBanner.CityStrikeButton:SetOffsetVal(6,0)
			end
		end
	end
end

function OnTPT_Settings_Toggle(ParameterId, Value)
	if ParameterId == "CityStrikeButton_Back" then
		CanCityStrikeButtonRevoke = Value
		RefreshPlayerBanners(Game.GetLocalPlayer())
		return
	end
end
LuaEvents.TPT_Settings_Toggle.Add(OnTPT_Settings_Toggle)