include("GameCapabilities");

local m_HotKey_TPT_AutoRecruitId:number = Input.GetActionId("HotKey_TPT_AutoRecruit");
--local m_HotKey_TPT_RecruitId:number = Input.GetActionId("HotKey_TPT_Recruit");

local IsAuto = false;		-- 自动招募模式

function OnInputActionTriggered(actionId)
	if actionId == m_HotKey_TPT_AutoRecruitId then
		IsAuto = not IsAuto;
		if IsAuto then
			Events.GreatPeoplePointsChanged.Add( OnGreatPeoplePointsChanged );
			OnGreatPeoplePointsChanged()
			Controls.GPA_Icon:SetHide(false)
		else
			Events.GreatPeoplePointsChanged.Remove( OnGreatPeoplePointsChanged );
			Controls.GPA_Icon:SetHide(true)
		end
		UI.PlaySound("Play_MP_Game_Launch_Timer_Beep")
		return
	end

--	if actionId == m_HotKey_TPT_RecruitId then
--		RecruitAllGreatPeople()
--		return
--	end
end

function PopulateData( data:table )
	if data == nil then
		return;
	end
	
	local displayPlayerID :number = Game.GetLocalPlayer();
	if (displayPlayerID == -1) then
		return;
	end
	
	local pGreatPeople	:table  = Game.GetGreatPeople();
	if pGreatPeople == nil then
		return;
	end

	local pTimeline:table = pGreatPeople:GetTimeline()	

	for i,entry in ipairs(pTimeline) do

		local canRecruit = false;
		local recruitCost = entry.Cost;
		local onlyLocalPlayerCanRecruit = true;
		
		if (entry.Individual ~= nil) then
			if (Players[displayPlayerID] ~= nil) then
				canRecruit = pGreatPeople:CanRecruitPerson(displayPlayerID, entry.Individual);
			end
			
			for _, playerID in ipairs(PlayerManager.GetAliveMajorIDs()) do
				if playerID ~= Game.GetLocalPlayer() then
					if pGreatPeople:CanRecruitPerson(playerID, entry.Individual) then
						onlyLocalPlayerCanRecruit = false
					end
				end
			end
		end

		local kPerson:table = {
			IndividualID					= entry.Individual,
			ClassID							= entry.Class,
			CanRecruit						= canRecruit,
			RecruitCost						= recruitCost,
			OnlyLocalPlayerCanRecruit       = onlyLocalPlayerCanRecruit,
		};
		table.insert(data.Timeline, kPerson);
	end

	for classInfo in GameInfo.GreatPersonClasses() do
		local classID = classInfo.Index;
		local pointsTable = {};
		local players = Game.GetPlayers{Major = true, Alive = true};
		for i, player in ipairs(players) do
			local playerPoints = {
				PointsTotal			= player:GetGreatPeoplePoints():GetPointsTotal(classID),
				PlayerID			= player:GetID()
			};
			table.insert(pointsTable, playerPoints);
		end
		table.sort(pointsTable, function(a, b)
			return a.PointsTotal > b.PointsTotal;
		end);
		data.PointsByClass[classID] = pointsTable;
	end
end

function OnRecruitButtonClick( individualID:number )
	local pLocalPlayer = Players[Game.GetLocalPlayer()];
	if (pLocalPlayer ~= nil) then
		local kParameters:table = {};
		kParameters[PlayerOperations.PARAM_GREAT_PERSON_INDIVIDUAL_TYPE] = individualID;
		UI.RequestPlayerOperation(Game.GetLocalPlayer(), PlayerOperations.RECRUIT_GREAT_PERSON, kParameters);
	end
end

-- 自动招募
function OnGreatPeoplePointsChanged( playerID:number )
	local kData :table	= {
		Timeline		= {},
		PointsByClass	= {},
	};

	PopulateData(kData, false);	-- do not use past data
	
	for i, kPerson:table in ipairs(kData.Timeline) do
		if (HasCapability("CAPABILITY_GREAT_PEOPLE_CAN_RECRUIT") and kPerson.CanRecruit and kPerson.RecruitCost ~= nil) then
			if kPerson.OnlyLocalPlayerCanRecruit or kData.PointsByClass[kPerson.ClassID][1].PlayerID == Game.GetLocalPlayer() then
				OnRecruitButtonClick(kPerson.IndividualID)		-- 立即招募
			end
		end
	end	
end

-- 手动招募
function RecruitAllGreatPeople()
	local kData :table	= {
		Timeline		= {},
		PointsByClass	= {},
	};

	PopulateData(kData, false);	-- do not use past data
	
	for i, kPerson:table in ipairs(kData.Timeline) do
		if (HasCapability("CAPABILITY_GREAT_PEOPLE_CAN_RECRUIT") and kPerson.CanRecruit and kPerson.RecruitCost ~= nil) then
			OnRecruitButtonClick(kPerson.IndividualID)		-- 立即招募
		end
	end
end

function LateInitialize()
	local Ctr = ContextPtr:LookUpControl("/InGame/LaunchBar/GreatPeopleButton")
	Controls.GPA_Icon:ChangeParent(Ctr)
end

function Initialize()
--	Events.GreatPeoplePointsChanged.Add( OnGreatPeoplePointsChanged );
	
	Events.InputActionTriggered.Add(OnInputActionTriggered);
	Events.LoadScreenClose.Add(LateInitialize)
end
Initialize();