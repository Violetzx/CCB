local m_PendingGoodyHut = nil
local firstCivicBoosted = nil;
local firstTechBoosted = nil;

function ShowWorldViewText()
	if m_PendingGoodyHut ~= nil then
		Game.AddWorldViewText(0, m_PendingGoodyHut.InfoText, m_PendingGoodyHut.PlotX, m_PendingGoodyHut.PlotY);
		m_PendingGoodyHut = nil
	end
end

function OnUnitTriggerGoodyHut(playerId:number, unitId:number, goodyHutType:number)
    if playerId ~= Game.GetLocalPlayer() then
        return;
    end
    
	m_PendingGoodyHut = nil
	
    local unit:object = UnitManager.GetUnit(playerId, unitId);
    if unit ~= nil then
        local row = GameInfo.GoodyHutSubTypes[goodyHutType];
        if row ~= nil then
			local modifierId = GameInfo.GoodyHutSubTypes[row.SubTypeGoodyHut].ModifierID
			if modifierId == "GOODY_SCIENCE_GRANT_ONE_TECH"
			or modifierId == "GOODY_SCIENCE_GRANT_ONE_TECH_BOOST"
			or modifierId == "GOODY_SCIENCE_GRANT_TWO_TECH_BOOSTS"
			or modifierId == "GOODY_CULTURE_GRANT_ONE_CIVIC_BOOST"
			or modifierId == "GOODY_CULTURE_GRANT_TWO_CIVIC_BOOSTS" then
				m_PendingGoodyHut = {
					PlotX = unit:GetX(),
					PlotY = unit:GetY(),
					ModifierId = modifierId,
					InfoText = nil,
				};
			end
        end
    end
end

function OnResearchCompleted(playerId, techIndex)
    if playerId ~= Game.GetLocalPlayer() or m_PendingGoodyHut == nil then
        return;
    end
    
    if m_PendingGoodyHut.ModifierId == "GOODY_SCIENCE_GRANT_ONE_TECH" then
		local techName = GameInfo.Technologies[techIndex].Name;
		local Text = "[COLOR_FLOAT_SCIENCE]"..Locale.Lookup(techName);
		m_PendingGoodyHut.InfoText = Locale.Lookup("LOC_NOTIFICATION_TECH_DISCOVERED_MESSAGE", Text)
		
		ShowWorldViewText()
    end
end

function OnTechBoostTriggered(playerId, boostedTech)
    if playerId ~= Game.GetLocalPlayer() or m_PendingGoodyHut == nil then
        return;
    end
    
    local techName = Locale.Lookup(GameInfo.Technologies[boostedTech].Name);
    
	if m_PendingGoodyHut.ModifierId == "GOODY_SCIENCE_GRANT_ONE_TECH_BOOST" then
		
		local Text = "[NEWLINE][ICON_TechBoosted][COLOR_FLOAT_SCIENCE]" .. techName;
		m_PendingGoodyHut.InfoText = Locale.Lookup("LOC_NOTIFICATION_TECH_BOOST_SUMMARY", Text)
		
		ShowWorldViewText()
	elseif m_PendingGoodyHut.ModifierId == "GOODY_SCIENCE_GRANT_TWO_TECH_BOOSTS" then
		if firstTechBoosted == nil then
			firstTechBoosted = boostedTech;
			m_PendingGoodyHut.InfoText = "[NEWLINE][ICON_TechBoosted][COLOR_FLOAT_SCIENCE]" .. techName;
		else
			local Text = m_PendingGoodyHut.InfoText .. "&" .. techName;
			m_PendingGoodyHut.InfoText = Locale.Lookup("LOC_NOTIFICATION_TECH_BOOST_SUMMARY", Text)
			firstTechBoosted = nil;
			
			ShowWorldViewText()
		end
	end
end

function OnCivicBoostTriggered(playerId, boostedCivic)
    if playerId ~= Game.GetLocalPlayer() or m_PendingGoodyHut == nil then
        return;
    end
    
    local civicName = Locale.Lookup(GameInfo.Civics[boostedCivic].Name);
	
	if m_PendingGoodyHut.ModifierId == "GOODY_CULTURE_GRANT_ONE_CIVIC_BOOST" then
		local Text = "[NEWLINE][ICON_CivicBoosted][COLOR_FLOAT_CULTURE]" .. civicName;
		m_PendingGoodyHut.InfoText = Locale.Lookup("LOC_NOTIFICATION_CIVIC_BOOST_SUMMARY", Text)
		
		ShowWorldViewText()
	elseif m_PendingGoodyHut.ModifierId == "GOODY_CULTURE_GRANT_TWO_CIVIC_BOOSTS" then
		if firstCivicBoosted == nil then
			firstCivicBoosted = boostedCivic
			m_PendingGoodyHut.InfoText = "[NEWLINE][ICON_CivicBoosted][COLOR_FLOAT_CULTURE]" .. civicName;
		else
			local Text = m_PendingGoodyHut.InfoText .. "&" .. civicName;
			m_PendingGoodyHut.InfoText = Locale.Lookup("LOC_NOTIFICATION_CIVIC_BOOST_SUMMARY", Text)
			
			ShowWorldViewText()
		end
	end
end

function Initialize()
	if GameConfiguration.IsAnyMultiplayer() then
		GameEvents.UnitTriggerGoodyHut.Add(OnUnitTriggerGoodyHut);
		Events.CivicBoostTriggered.Add(OnCivicBoostTriggered);
		Events.TechBoostTriggered.Add(OnTechBoostTriggered);
		Events.ResearchCompleted.Add(OnResearchCompleted);
	end
end
Initialize();