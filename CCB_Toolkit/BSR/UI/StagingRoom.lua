----------------------------------------------------------------  
-- Staging Room Screen
----------------------------------------------------------------  
include( "InstanceManager" );	--InstanceManager
include( "PlayerSetupLogic" );
include( "NetworkUtilities" );
include( "ButtonUtilities" );
include( "PlayerTargetLogic" );
include( "ChatLogic" );
include( "NetConnectionIconLogic" );
include( "PopupDialog" );
include( "Civ6Common" );
include( "TeamSupport" );

--include( "Poker_Blackjack_21.lua" );

----------------------------------------------------------------  
-- Constants
---------------------------------------------------------------- 
local CountdownTypes = {
	None				= "None",
	Launch				= "Launch",						-- Standard Launch Countdown
	Launch_Instant		= "Launch_Instant",				-- Instant Launch
	WaitForPlayers		= "WaitForPlayers",				-- Used by Matchmaking games after the Ready countdown to try to fill up the game with human players before starting.
	Ready_PlayByCloud	= "Ready_PlayByCloud",
	Ready_MatchMaking	= "Ready_MatchMaking",
};

local TimerTypes = {
	Script 				= "Script",						-- Timer is internally tracked in this script.
	NetworkManager 		= "NetworkManager",				-- Timer is handled by the NetworkManager.  This is synchronized across all the clients in a matchmaking game.
};


----------------------------------------------------------------  
-- Globals
---------------------------------------------------------------- 
local g_TeamBaseRatio = {};
local g_TPT_PlayerDatas = {};		-- 黑名单信息

local TPT_OUTPUT_HEEDER_str = Locale.Lookup("LOC_TPT_OUTPUT_HEEDER");
local TPT_OUTPUT_SUCCESS_NAME_str = Locale.Lookup("LOC_TPT_OUTPUT_SUCCESS_NAME");
local TPT_OUTPUT_SUCCESS_TT_str = Locale.Lookup("LOC_TPT_OUTPUT_SUCCESS_TT");
local TPT_OUTPUT_ERROR_NAME_str = Locale.Lookup("LOC_TPT_OUTPUT_ERROR_NAME");
local TPT_OUTPUT_ERROR_TT_str = Locale.Lookup("LOC_TPT_OUTPUT_ERROR_TT");
local TPT_URL_INSTRUCTIONS_str = Locale.Lookup("LOC_TPT_URL_INSTRUCTIONS");
local TPT_CHECK_ERROR_NAME_str = Locale.Lookup("LOC_TPT_CHECK_ERROR_NAME");
local TPT_OUTPUT_ERROR_TT_str = Locale.Lookup("LOC_TPT_OUTPUT_ERROR_TT");
local TPT_PLAYERDATA_BAN_str = Locale.Lookup("LOC_TPT_PLAYERDATA_BAN");

local m_TPT_Update_TT = {}
TTManager:GetTypeControlTable("TooltipType_TPT_Update", m_TPT_Update_TT)

local m_LeaderStatsIM = InstanceManager:new("LeaderStats_Instance", "BGRoot", Controls.LeaderStatsStack);

local g_PlayerEntries = {};					-- All the current player entries, indexed by playerID.
local g_PlayerRootToPlayerID = {};  -- maps the string name of a player entry's Root control to a playerID.
local g_PlayerReady = {};			-- cached player ready status, indexed by playerID.
local g_PlayerModStatus = {};		-- cached player localized mod status strings.
local g_cachedTeams = {};				-- A cached mapping of PlayerID->TeamID.

local m_playerTarget = { targetType = ChatTargetTypes.CHATTARGET_ALL, targetID = GetNoPlayerTargetID() };
local m_playerTargetEntries = {};
local m_ChatInstances		= {};
local m_infoTabsIM:table = InstanceManager:new("ShellTab", "TopControl", Controls.InfoTabs);
local m_shellTabIM:table = InstanceManager:new("ShellTab", "TopControl", Controls.ShellTabs);
local m_friendsIM = InstanceManager:new( "FriendInstance", "RootContainer", Controls.FriendsStack );
local m_playersIM = InstanceManager:new( "PlayerListEntry", "Root", Controls.PlayerListStack );
local g_GridLinesIM = InstanceManager:new( "HorizontalGridLine", "Control", Controls.GridContainer );
local m_gameSetupParameterIM = InstanceManager:new( "GameSetupParameter", "Root", nil );
local m_kPopupDialog:table;
local m_shownPBCReadyPopup = false;			-- Remote clients in a new PlayByCloud game get a ready-to-go popup when
											-- This variable indicates this popup has already been shown in this instance
											-- of the staging room.
local m_savePBCReadyChoice :boolean = false;	-- Should we save the user's PlayByCloud ready choice when they have decided?
local m_exitReadyWait :boolean = false;		-- Are we waiting on a local player ready change to propagate prior to exiting the match?
local m_numPlayers:number;
local m_teamColors = {};
local m_sessionID :number = FireWireTypes.FIREWIRE_INVALID_ID;

-- Additional Content 
local m_modsIM = InstanceManager:new("AdditionalContentInstance", "Root", Controls.AdditionalContentStack);

-- Reusable tooltip control
local m_CivTooltip:table = {};
ContextPtr:BuildInstanceForControl("CivToolTip", m_CivTooltip, Controls.TooltipContainer);
m_CivTooltip.UniqueIconIM = InstanceManager:new("IconInfoInstance",	"Top", m_CivTooltip.InfoStack);
m_CivTooltip.HeaderIconIM = InstanceManager:new("IconInstance", "Top", m_CivTooltip.InfoStack);
m_CivTooltip.CivHeaderIconIM = InstanceManager:new("CivIconInstance", "Top", m_CivTooltip.InfoStack);
m_CivTooltip.HeaderIM = InstanceManager:new("HeaderInstance", "Top", m_CivTooltip.InfoStack);

-- Game launch blockers
local m_bTeamsValid = true;						-- Are the teams valid for game start?
local g_everyoneConnected = true;				-- Is everyone network connected to the game?
local g_badPlayerForMapSize = false;			-- Are there too many active civs for this map?
local g_notEnoughPlayers = false;				-- Is there at least two players in the game?
local g_everyoneReady = false;					-- Is everyone ready to play?
local g_everyoneModReady = true;				-- Does everyone have the mods for this game?
local g_humanRequiredFilled = true;				-- Are all the human required slots filled by humans?
local g_duplicateLeaders = false;				-- Are there duplicate leaders blocking launch?
												-- Note:  This only applies if No Duplicate Leaders parameter is set.
local g_pbcNewGameCheck = true;					-- In a PlayByCloud game, only the game host can launch a new game.	
local g_pbcMinHumanCheck = true;				-- PlayByCloud matches need at least two human players. 
												-- The game and backend can not handle solo games. 
												-- NOTE: The backend will automatically end started PBC matches that end up 
												-- with a solo human due to quits/kicks. 
local g_matchMakeFullGameCheck = true;			-- In a Matchmaking game, we only game launch during the ready countdown if the game is full of human players.				
local g_viewingGameSummary = true;
local g_hotseatNumHumanPlayers = 0;
local g_hotseatNumAIPlayers = 0;
local g_isBuildingPlayerList = false;

local m_iFirstClosedSlot = -1;					-- Closed slot to show Add player line

local NO_COUNTDOWN = -1;

local m_countdownType :string				= CountdownTypes.None;	-- Which countdown type is active?
local g_fCountdownTimer :number 			= NO_COUNTDOWN;			-- Start game countdown timer.  Set to -1 when not in use.
local g_fCountdownInitialTime :number 		= NO_COUNTDOWN;			-- Initial time for the current countdown.
local g_fCountdownTickSoundTime	:number 	= NO_COUNTDOWN;			-- When was the last time we make a countdown tick sound?
local g_fCountdownReadyButtonTime :number	= NO_COUNTDOWN;			-- When was the last time we updated the ready button countdown time?

-- Defines for the different Countdown Types.
-- CountdownTime - How long does the ready up countdown last in seconds?
-- TickStartTime - How long before the end of the ready countdown time does the ticking start?
local g_CountdownData = {
	[CountdownTypes.Launch]				= { CountdownTime = 10,		TimerType = TimerTypes.Script,				TickStartTime = 10},
	[CountdownTypes.Launch_Instant]		= { CountdownTime = 0,		TimerType = TimerTypes.Script,				TickStartTime = 0},
	[CountdownTypes.WaitForPlayers]		= { CountdownTime = 180,	TimerType = TimerTypes.NetworkManager,		TickStartTime = 10},
	[CountdownTypes.Ready_PlayByCloud]	= { CountdownTime = 600,	TimerType = TimerTypes.Script,				TickStartTime = 10},
	[CountdownTypes.Ready_MatchMaking]	= { CountdownTime = 60,		TimerType = TimerTypes.Script,				TickStartTime = 10},
};

-- hotseatOnly - Only available in hotseat mode.
-- hotseatInProgress = Available for active civs (AI/HUMAN) when loading a hotseat game
-- hotseatAllowed - Allowed in hotseat mode.
local g_slotTypeData = 
{
	{ name ="LOC_SLOTTYPE_OPEN",		tooltip = "LOC_SLOTTYPE_OPEN_TT",		hotseatOnly=false,	slotStatus=SlotStatus.SS_OPEN,		hotseatInProgress = false,		hotseatAllowed=false},
	{ name ="LOC_SLOTTYPE_AI",			tooltip = "LOC_SLOTTYPE_AI_TT",			hotseatOnly=false,	slotStatus=SlotStatus.SS_COMPUTER,	hotseatInProgress = true,		hotseatAllowed=true },
	{ name ="LOC_SLOTTYPE_CLOSED",		tooltip = "LOC_SLOTTYPE_CLOSED_TT",		hotseatOnly=false,	slotStatus=SlotStatus.SS_CLOSED,	hotseatInProgress = false,		hotseatAllowed=true },		
	{ name ="LOC_SLOTTYPE_HUMAN",		tooltip = "LOC_SLOTTYPE_HUMAN_TT",		hotseatOnly=true,	slotStatus=SlotStatus.SS_TAKEN,		hotseatInProgress = true,		hotseatAllowed=true },		
	{ name ="LOC_MP_SWAP_PLAYER",		tooltip = "TXT_KEY_MP_SWAP_BUTTON_TT",	hotseatOnly=false,	slotStatus=-1,						hotseatInProgress = true,		hotseatAllowed=true },		
};

local MAX_EVER_PLAYERS : number = 20; -- hardwired max possible players in multiplayer, determined by how many players --BUDDY: changed from 8
local MIN_EVER_PLAYERS : number = 2;  -- hardwired min possible players in multiplayer, the game does bad things if there aren't at least two players on different teams.
local MAX_SUPPORTED_PLAYERS : number = 20; -- Max number of officially supported players in multiplayer.  You can play with more than this number, but QA hasn't vetted it. -- BUDDY: changed from 8
local g_currentMaxPlayers : number = MAX_EVER_PLAYERS;
local g_currentMinPlayers : number = MIN_EVER_PLAYERS;
	
local PlayerConnectedChatStr = Locale.Lookup( "LOC_MP_PLAYER_CONNECTED_CHAT" );
local PlayerDisconnectedChatStr = Locale.Lookup( "LOC_MP_PLAYER_DISCONNECTED_CHAT" );
local PlayerHostMigratedChatStr = Locale.Lookup( "LOC_MP_PLAYER_HOST_MIGRATED_CHAT" );
local PlayerKickedChatStr = Locale.Lookup( "LOC_MP_PLAYER_KICKED_CHAT" );
local BytesStr = Locale.Lookup( "LOC_BYTES" );
local KilobytesStr = Locale.Lookup( "LOC_KILOBYTES" );
local MegabytesStr = Locale.Lookup( "LOC_MEGABYTES" );
local DefaultHotseatPlayerName = Locale.Lookup( "LOC_HOTSEAT_DEFAULT_PLAYER_NAME" );
local NotReadyStatusStr = Locale.Lookup("LOC_NOT_READY");
local ReadyStatusStr = Locale.Lookup("LOC_READY_LABEL");
local BadMapSizeSlotStatusStr = Locale.Lookup("LOC_INVALID_SLOT_MAP_SIZE");
local BadMapSizeSlotStatusStrTT = Locale.Lookup("LOC_INVALID_SLOT_MAP_SIZE_TT");
local EmptyHumanRequiredSlotStatusStr :string = Locale.Lookup("LOC_INVALID_SLOT_HUMAN_REQUIRED");
local EmptyHumanRequiredSlotStatusStrTT :string = Locale.Lookup("LOC_INVALID_SLOT_HUMAN_REQUIRED_TT");
local UnsupportedText = Locale.Lookup("LOC_READY_UNSUPPORTED");
local UnsupportedTextTT = Locale.Lookup("LOC_READY_UNSUPPORTED_TT");
local downloadPendingStr = Locale.Lookup("LOC_MODS_SUBSCRIPTION_DOWNLOAD_PENDING");
local loadingSaveGameStr = Locale.Lookup("LOC_STAGING_ROOM_LOADING_SAVE");
local gameInProgressGameStr = Locale.Lookup("LOC_STAGING_ROOM_GAME_IN_PROGRESS");

local onlineIconStr = "[ICON_OnlinePip]";
local offlineIconStr = "[ICON_OfflinePip]";

local COLOR_GREEN				:number = UI.GetColorValueFromHexLiteral(0xFF00FF00);
local COLOR_RED					:number = UI.GetColorValueFromHexLiteral(0xFF0000FF);
local ColorString_ModGreen		:string = "[color:ModStatusGreen]";
local PLAYER_LIST_SIZE_DEFAULT	:number = 325;
local PLAYER_LIST_SIZE_HOTSEAT	:number = 535;
local GRID_LINE_WIDTH			:number = 1020;
local GRID_LINE_HEIGHT			:number = 51;
local NUM_COLUMNS				:number = 5;

local TEAM_ICON_SIZE			:number = 38;
local TEAM_ICON_PREFIX			:string = "ICON_TEAM_ICON_";


-------------------------------------------------
-- Localized Constants
-------------------------------------------------
local LOC_FRIENDS:string = Locale.ToUpper(Locale.Lookup("LOC_MULTIPLAYER_FRIENDS"));
local LOC_GAME_SETUP:string = Locale.Lookup("LOC_MULTIPLAYER_GAME_SETUP");
local LOC_GAME_SUMMARY:string = Locale.Lookup("LOC_MULTIPLAYER_GAME_SUMMARY");
local LOC_STAGING_ROOM:string = Locale.ToUpper(Locale.Lookup("LOC_MULTIPLAYER_STAGING_ROOM"));

-- https://github.com/fab13n/metalua/blob/no-dll/src/lib/serialize.lua

local no_identity = { number=1, boolean=1, string=1, ['nil']=1 }

function serialize (x)
   
   local gensym_max =  0  -- index of the gensym() symbol generator
   local seen_once  = { } -- element->true set of elements seen exactly once in the table
   local multiple   = { } -- element->varname set of elements seen more than once
   local nested     = { } -- transient, set of elements currently being traversed
   local nest_points = { }
   local nest_patches = { }
   
   local function gensym()
      gensym_max = gensym_max + 1 ;  return gensym_max
   end

   local function mark_nest_point (parent, k, v)
      local nk, nv = nested[k], nested[v]
      assert (not nk or seen_once[k] or multiple[k])
      assert (not nv or seen_once[v] or multiple[v])
      local mode = (nk and nv and "kv") or (nk and "k") or ("v")
      local parent_np = nest_points [parent]
      local pair = { k, v }
      if not parent_np then parent_np = { }; nest_points [parent] = parent_np end
      parent_np [k], parent_np [v] = nk, nv
      table.insert (nest_patches, { parent, k, v })
      seen_once [parent], multiple [parent]  = nil, true
   end

   local function mark_multiple_occurences (x)
      if no_identity [type(x)] then return end
      if     seen_once [x]     then seen_once [x], multiple [x] = nil, true
      elseif multiple  [x]     then -- pass
      else   seen_once [x] = true end
      
      if type (x) == 'table' then
         nested [x] = true
         for k, v in pairs (x) do
            if nested[k] or nested[v] then mark_nest_point (x, k, v) else
               mark_multiple_occurences (k)
               mark_multiple_occurences (v)
            end
         end
         nested [x] = nil
      end
   end

   local dumped    = { } -- multiply occuring values already dumped in localdefs
   local localdefs = { } -- already dumped local definitions as source code lines

   local dump_val, dump_or_ref_val
         
   function dump_or_ref_val (x)
      if nested[x] then return 'false' end -- placeholder for recursive reference
      if not multiple[x] then return dump_val (x) end
      local var = dumped [x]
      if var then return "_[" .. var .. "]" end -- already referenced
      local val = dump_val(x) -- first occurence, create and register reference
      var = gensym()
      table.insert(localdefs, "_["..var.."]="..val)
      dumped [x] = var
      return "_[" .. var .. "]"
   end

   function dump_val(x)
      local  t = type(x)
      if     x==nil        then return 'nil'
      elseif t=="number"   then return tostring(x)
      elseif t=="string"   then return string.format("%q", x)
      elseif t=="boolean"  then return x and "true" or "false"
      elseif t=="function" then
         return string.format ("loadstring(%q,'@serialized')", string.dump (x))
      elseif t=="table" then

         local acc        = { }
         local idx_dumped = { }
         local np         = nest_points [x]
         for i, v in ipairs(x) do
            if np and np[v] then
               table.insert (acc, 'false') -- placeholder
            else
               table.insert (acc, dump_or_ref_val(v))
            end
            idx_dumped[i] = true
         end
         for k, v in pairs(x) do
            if np and (np[k] or np[v]) then
               --check_multiple(k); check_multiple(v) -- force dumps in localdefs
            elseif not idx_dumped[k] then
               table.insert (acc, "[" .. dump_or_ref_val(k) .. "] = " .. dump_or_ref_val(v))
            end
         end
         return "{ "..table.concat(acc,", ").." }"
      else
         error ("Can't serialize data of type "..t)
      end
   end
          
   local function dump_nest_patches()
      for _, entry in ipairs(nest_patches) do
         local p, k, v = unpack (entry)
         assert (multiple[p])
         local set = dump_or_ref_val (p) .. "[" .. dump_or_ref_val (k) .. "] = " .. 
            dump_or_ref_val (v) .. " -- rec "
         table.insert (localdefs, set)
      end
   end
   
   mark_multiple_occurences (x)
   local toplevel = dump_or_ref_val (x)
   dump_nest_patches()

   if next (localdefs) then
      return "local _={ }\n" ..
         table.concat (localdefs, "\n") .. 
         "\nreturn " .. toplevel
   else
      return "return " .. toplevel
   end
end

function deserialize (x)
	return loadstring(x)()
end

function printTable(t, indent)
    indent = indent or 0

    for k, v in pairs(t) do
        if type(v) == "table" then
            print(string.rep(" ", indent) .. k .. ": {")
            printTable(v, indent + 4)
            print(string.rep(" ", indent) .. "}")
        else
            print(string.rep(" ", indent) .. k .. ": " .. tostring(v))
        end
    end
end

-- ===========================================================================
-- 使用字符串创建组名，并防止玩家在使用的组混乱
-- ===========================================================================
function CreateGroups(str)
	local g = Modding.GetCurrentModGroup();		-- 当前使用的组
	local currentGroup = Modding.GetCurrentModGroup();
	Modding.CreateModGroup(str, currentGroup);
	Modding.SetCurrentModGroup(g);				-- 还原回初始使用的组
end
-- ===========================================================================
-- 输入表和索引，将字符串储存
-- ===========================================================================
function Storage_table(t, title)
	if not title or title == "" then return end;
	local Title = "[size_0][" .. tostring(title) .. "][";
	
	local groups = Modding.GetModGroups();		-- 首先删除原有的表
	for i, v in ipairs(groups) do
		if Title == string.sub(v.Name, 1, #Title) then
			Modding.DeleteModGroup( v.Handle )
		end
	end

	local Para = 1;		-- 当字符超过2000时，储存一部分字符串先;
	local InfoStr = serialize(t)
	for i = 1, #InfoStr, 2000 do
		local iStr = Title .. tostring(Para) .. "]" .. string.sub(InfoStr, i, i + 1999);		-- 截取2000字符串为一组
		Para = Para + 1;
		CreateGroups(iStr)
	end
end
-- ===========================================================================
-- 读取数据
-- ===========================================================================
function Read_tableString(title)
	if not title or title == "" then return end;
	local Title = "[size_0][" .. tostring(title) .. "][";
	local Tstrings = {}
	local tableString = ""
	local groups = Modding.GetModGroups();
	for i, v in ipairs(groups) do
		if Title == string.sub(v.Name, 1, #Title) then
			local Str = string.sub(v.Name, #Title + 1)
			local sp = string.find(Str, "]")
			local Para = tonumber(string.sub(Str, 1, sp - 1))
			Tstrings[Para] = string.sub(Str, sp + 1)
		end
	end
	for i, v in ipairs(Tstrings) do
		tableString = tableString .. v;
	end
	return deserialize(tableString) or {}
end
-- ===========================================================================
-- 清除数据
-- ===========================================================================
function Clear_tableData(title)
	if not title or title == "" then return end;
	local Title = "[size_0][" .. tostring(title) .. "][";
	
	local groups = Modding.GetModGroups();
	for i, v in ipairs(groups) do
		if Title == string.sub(v.Name, 1, #Title) then
			Modding.DeleteModGroup( v.Handle )
		end
	end
end
-- ===========================================================================
function Close()	
    if m_kPopupDialog:IsOpen() then
		m_kPopupDialog:Close();
	end
	LuaEvents.Multiplayer_ExitShell();
end

-- ===========================================================================
--	Input Handler
-- ===========================================================================
function KeyUpHandler( key:number )
	if key == Keys.VK_ESCAPE then
		if not Controls.Main_Poker:IsHidden() then
			Poker_OnClose()
		else
			Close();
		end
		return true;
	end
    return false;
end
function OnInputHandler( pInputStruct:table )
	local uiMsg :number = pInputStruct:GetMessageType();
	if uiMsg == KeyEvents.KeyUp then return KeyUpHandler( pInputStruct:GetKey() ); end	
	return false;
end

----------------------------------------------------------------  
-- Helper Functions
---------------------------------------------------------------- 
function SetCurrentMaxPlayers( newMaxPlayers : number )
	g_currentMaxPlayers = math.min(newMaxPlayers, MAX_EVER_PLAYERS);
end

function SetCurrentMinPlayers( newMinPlayers : number )
	g_currentMinPlayers = math.max(newMinPlayers, MIN_EVER_PLAYERS);
end

-- Could this player slot be displayed on the staging room?  The staging room ignores a lot of possible slots (city states; barbs; player slots exceeding the map size)
function IsDisplayableSlot(playerID :number)
	local pPlayerConfig = PlayerConfigurations[playerID];
	if(pPlayerConfig == nil) then
		return false;
	end

	if(playerID < g_currentMaxPlayers	-- Any slot under the current max player limit is displayable.
		-- Full Civ participants are displayable.
		or (pPlayerConfig:IsParticipant() 
			and pPlayerConfig:GetCivilizationLevelTypeID() == CivilizationLevelTypes.CIVILIZATION_LEVEL_FULL_CIV) ) then
			return true;
	end

	return false;
end

-- Is the cloud match in progress?
function IsCloudInProgress()
	if(not GameConfiguration.IsPlayByCloud()) then
		return false;
	end

	if(GameConfiguration.GetGameState() == GameStateTypes.GAMESTATE_LAUNCHED -- Saved game state is launched.
		-- Has the cloud match blocked player joins?  The game host sets this prior to launching the match.
		-- We check for this becaus the game state will only be set to GAMESTATE_LAUNCHED once the first turn is committed.
		-- We need to count as being inprogress from when the host started to launch the match thru them committing their first turn.
		or Network.IsCloudJoinsBlocked()) then
		return true;
	end

	return false;
end

-- Are we in a launched PlayByCloud match where it is not our turn?
function IsCloudInProgressAndNotTurn()
	if(not IsCloudInProgress()) then
		return false;
	end

	if(Network.IsCloudTurnPlayer()) then
		return false;
	end

	-- If the local player is dead, count as false.  This should result in the CheckForGameStart immediately autolaunching the game so the player can see the endgamemenu.
	local localPlayerID = Network.GetLocalPlayerID();
	if( localPlayerID ~= NetPlayerTypes.INVALID_PLAYERID) then
		local localPlayerConfig = PlayerConfigurations[localPlayerID];
		if(not localPlayerConfig:IsAlive()) then
			return false;
		end
	end

	-- TTP 44083 - It is always the host's turn if the match is "in progress" but the match has not been started.  
	-- This can happen if the game host disconnected from the match right as the launch countdown hit zero.
	if(Network.IsGameHost() and not Network.IsCloudMatchStarted()) then
		return false;
	end

	return true;
end

function IsLaunchCountdownActive()
	if(m_countdownType == CountdownTypes.Launch or m_countdownType == CountdownTypes.Launch_Instant) then
		return true;
	end

	return false;
end

function IsReadyCountdownActive()
	if(m_countdownType == CountdownTypes.Ready_MatchMaking 
		or m_countdownType == CountdownTypes.Ready_PlayByCloud) then
		return true;
	end

	return false;
end

function IsWaitForPlayersCountdownActive()
	if(m_countdownType == CountdownTypes.WaitForPlayers) then
		return true;
	end

	return false;
end

function IsUseReadyCountdown()
	local type = GetReadyCountdownType();
	if(type ~= CountdownTypes.None) then
		return true;
	end

	return false;
end

function GetReadyCountdownType()
	if(GameConfiguration.IsPlayByCloud()) then
		return CountdownTypes.Ready_PlayByCloud;
	elseif(GameConfiguration.IsMatchMaking()) then
		return CountdownTypes.Ready_MatchMaking;
	end
	return CountdownTypes.None;
end	

function IsUseWaitingForPlayersCountdown()
	return GameConfiguration.IsMatchMaking();
end

function GetCountdownTimeRemaining()
	local countdownData :table = g_CountdownData[m_countdownType];
	if(countdownData == nil) then
		return 0;
	end

	if(countdownData.TimerType == TimerTypes.NetworkManager) then
		local sessionTime :number = Network.GetElapsedSessionTime();
		return countdownData.CountdownTime - sessionTime;
	else
		return g_fCountdownTimer;
	end
end


----------------------------------------------------------------  
-- Event Handlers
---------------------------------------------------------------- 
function OnMapMaxMajorPlayersChanged(newMaxPlayers : number)
	if(g_currentMaxPlayers ~= newMaxPlayers) then
		SetCurrentMaxPlayers(newMaxPlayers);
		if(ContextPtr:IsHidden() == false) then
			CheckGameAutoStart();	-- game start can change based on the new max players.
			BuildPlayerList();	-- rebuild player list because several player slots will have changed.
		end
	end
end

function OnMapMinMajorPlayersChanged(newMinPlayers : number)
	if(g_currentMinPlayers ~= newMinPlayers) then
		SetCurrentMinPlayers(newMinPlayers);
		if(ContextPtr:IsHidden() == false) then
			CheckGameAutoStart();	-- game start can change based on the new min players.
		end
	end
end

-------------------------------------------------
-- OnGameConfigChanged
-------------------------------------------------
function OnGameConfigChanged()
	if(ContextPtr:IsHidden() == false) then
		RealizeGameSetup(); -- Rebuild the game settings UI.
		RebuildTeamPulldowns();	-- NoTeams setting might have changed.

		-- PLAYBYCLOUDTODO - Remove PBC special case once ready state changes have been moved to cloud player meta data.
		-- PlayByCloud uses GameConfigChanged to communicate player ready state changes, don't reset ready in that mode.
		if(not GameConfiguration.IsPlayByCloud() and not Automation.IsActive()) then
			SetLocalReady(false);  -- unready so player can acknowledge the new settings.
		end

		-- [TTP 42798] PlayByCloud Only - Ensure local player is ready if match is inprogress.  
		-- Previously players could get stuck unready if they unreadied between the host starting the launch countdown but before the game launch.
		if(IsCloudInProgress()) then
			SetLocalReady(true);
		end

		CheckGameAutoStart();  -- Toggling "No Duplicate Leaders" can affect the autostart.
	end
	OnMapMaxMajorPlayersChanged(MapConfiguration.GetMaxMajorPlayers());	
	OnMapMinMajorPlayersChanged(MapConfiguration.GetMinMajorPlayers());
end

-------------------------------------------------
-- OnPlayerInfoChanged
-------------------------------------------------
function PlayerInfoChanged_SpecificPlayer(playerID)
	-- Targeted update of another player's entry.
	local pPlayerConfig = PlayerConfigurations[playerID];
	if(g_cachedTeams[playerID] ~= pPlayerConfig:GetTeam()) then
		OnTeamChange(playerID, false);
	end

	Controls.PlayerListStack:SortChildren(SortPlayerListStack);
	UpdatePlayerEntry(playerID);
	
	Controls.PlayerListStack:CalculateSize();
	Controls.PlayersScrollPanel:CalculateSize();
end

function OnPlayerInfoChanged(playerID)
	if(ContextPtr:IsHidden() == false) then
		-- Ignore PlayerInfoChanged events for non-displayable player slots.
		if(not IsDisplayableSlot(playerID)) then
			return;
		end

		if(playerID == Network.GetLocalPlayerID()) then
			-- If we are the host and our info changed, we need to locally refresh all the player slots.
			-- We do this because the host's ready status disables/enables pulldowns on all the other player slots.
			if(Network.IsGameHost()) then
				UpdateAllPlayerEntries();
			else
				-- A remote client needs to update the disabled status of all slot type pulldowns if their data was changed.
				-- We do this because readying up disables the slot type pulldown for all players.
				UpdateAllPlayerEntries_SlotTypeDisabled();

				PlayerInfoChanged_SpecificPlayer(playerID);
			end
		else
			PlayerInfoChanged_SpecificPlayer(playerID);
		end

		CheckGameAutoStart();	-- Player might have changed their ready status.
		UpdateReadyButton();
		
		-- Update chat target pulldown.
		PlayerTarget_OnPlayerInfoChanged( playerID, Controls.ChatPull, Controls.ChatEntry, Controls.ChatIcon, m_playerTargetEntries, m_playerTarget, false);
	end
end

function OnUploadCloudPlayerConfigComplete(success :boolean)
	if(m_exitReadyWait == true) then
		m_exitReadyWait = false;
		Close();
	end
end

-------------------------------------------------
-- OnTeamChange
-------------------------------------------------
function OnTeamChange( playerID, isBatchCall )
	local pPlayerConfig = PlayerConfigurations[playerID];
	if(pPlayerConfig ~= nil) then
		local teamID = pPlayerConfig:GetTeam();
		local playerEntry = GetPlayerEntry(playerID);
		local updateOpenEmptyTeam = false;

		-- Check for situations where we might need to update the Open Empty Team slot.
		if( (g_cachedTeams[playerID] ~= nil and GameConfiguration.GetTeamPlayerCount(g_cachedTeams[playerID]) <= 0) -- was last player on old team.
			or (GameConfiguration.GetTeamPlayerCount(teamID) <= 1) ) then -- first player on new team.
			-- this player was the last player on that team.  We might need to create a new empty team.
			updateOpenEmptyTeam = true;
		end
		
		if(g_cachedTeams[playerID] ~= nil 
			and g_cachedTeams[playerID] ~= teamID
			-- Remote clients will receive team changes during the PlayByCloud game launch process if they just wait in the staging room.
			-- That should not unready the player which can mess up the autolaunch process.
			and not IsCloudInProgress()) then 
			-- Reset the player's ready status if they actually changed teams.
			SetLocalReady(false);
		end

		-- cache the player's teamID for the next OnTeamChange.
		g_cachedTeams[playerID] = teamID;
		
		if(not isBatchCall) then
			-- There's some stuff that we have to do it to maintain the player list. 
			-- We intentionally wait to do this if we're in the middle of doing a batch of these updates.
			-- If you're doing a batch of these, call UpdateTeamList(true) when you're done.
			UpdateTeamList(updateOpenEmptyTeam);
		end
	end	
end


-------------------------------------------------
-- OnMultiplayerPingTimesChanged
-------------------------------------------------
function OnMultiplayerPingTimesChanged()
	for playerID, playerEntry in pairs( g_PlayerEntries ) do
		UpdateNetConnectionIcon(playerID, playerEntry.ConnectionStatus, playerEntry.StatusLabel);
		UpdateNetConnectionLabel(playerID, playerEntry.StatusLabel);
	end
end

function OnCloudGameKilled( matchID, success )
	if(success) then
		Close();
	else
		--Show error prompt.
		m_kPopupDialog:Close();
		m_kPopupDialog:AddTitle(  Locale.ToUpper(Locale.Lookup("LOC_MULTIPLAYER_ENDING_GAME_FAIL_TITLE")));
		m_kPopupDialog:AddText(	  Locale.Lookup("LOC_MULTIPLAYER_ENDING_GAME_FAIL"));
		m_kPopupDialog:AddButton( Locale.Lookup("LOC_MULTIPLAYER_ENDING_GAME_FAIL_ACCEPT") );
		m_kPopupDialog:Open();
	end
end

function OnCloudGameQuit( matchID, success )
	if(success) then
		-- On success, close popup and exit the screen
		Close();
	else
		--Show error prompt.
		m_kPopupDialog:Close();
		m_kPopupDialog:AddTitle(  Locale.ToUpper(Locale.Lookup("LOC_MULTIPLAYER_QUITING_GAME_FAIL_TITLE")));
		m_kPopupDialog:AddText(	  Locale.Lookup("LOC_MULTIPLAYER_QUITING_GAME_FAIL"));
		m_kPopupDialog:AddButton( Locale.Lookup("LOC_MULTIPLAYER_QUITING_GAME_FAIL_ACCEPT") );
		m_kPopupDialog:Open();
	end
end

-------------------------------------------------
-- Chat
-------------------------------------------------
function OnMultiplayerChat( fromPlayer, toPlayer, text, eTargetType )
	OnChat(fromPlayer, toPlayer, text, eTargetType, true);
end

function OnChat( fromPlayer, toPlayer, text, eTargetType, playSounds :boolean )
	if(ContextPtr:IsHidden() == false) then
		local pPlayerConfig = PlayerConfigurations[fromPlayer];
		local playerName = Locale.Lookup(pPlayerConfig:GetPlayerName());

		-- Selecting chat text color based on eTargetType	
		local chatColor :string = "[color:ChatMessage_Global]";
		if(eTargetType == ChatTargetTypes.CHATTARGET_TEAM) then
			chatColor = "[color:ChatMessage_Team]";
		elseif(eTargetType == ChatTargetTypes.CHATTARGET_PLAYER) then
			chatColor = "[color:ChatMessage_Whisper]";  
		end
		
		local chatString	= "[color:ChatPlayerName]" .. playerName;

		-- When whispering, include the whisperee's name as well.
		if(eTargetType == ChatTargetTypes.CHATTARGET_PLAYER) then
			local pTargetConfig :table	= PlayerConfigurations[toPlayer];
			if(pTargetConfig ~= nil) then
				local targetName = Locale.Lookup(pTargetConfig:GetPlayerName());
				chatString = chatString .. " [" .. targetName .. "]";
			end
		end

		-- Ensure text parsed properly
		text = ParseChatText(text);

		chatString			= chatString .. ": [ENDCOLOR]" .. chatColor;
		-- Add a space before the [ENDCOLOR] tag to prevent the user from accidentally escaping it
		chatString			= chatString .. text .. " [ENDCOLOR]";

		AddChatEntry( chatString, Controls.ChatStack, m_ChatInstances, Controls.ChatScroll);

		if(playSounds and fromPlayer ~= Network.GetLocalPlayerID()) then
			UI.PlaySound("Play_MP_Chat_Message_Received");
		end
	end
end

-------------------------------------------------
-------------------------------------------------
function SendChat( text )
    if( string.len( text ) > 0 ) then
		-- Parse text for possible chat commands
		local parsedText :string;
		local chatTargetChanged :boolean = false;
		local printHelp :boolean = false;
		parsedText, chatTargetChanged, printHelp = ParseInputChatString(text, m_playerTarget);
		if(chatTargetChanged) then
			ValidatePlayerTarget(m_playerTarget);
			UpdatePlayerTargetPulldown(Controls.ChatPull, m_playerTarget);
			UpdatePlayerTargetEditBox(Controls.ChatEntry, m_playerTarget);
			UpdatePlayerTargetIcon(Controls.ChatIcon, m_playerTarget);
		end

		if(printHelp) then
			ChatPrintHelp(Controls.ChatStack, m_ChatInstances, Controls.ChatScroll);
		end

		if(parsedText ~= "") then
			-- m_playerTarget uses PlayerTargetLogic values and needs to be converted  
			local chatTarget :table ={};
			PlayerTargetToChatTarget(m_playerTarget, chatTarget);
			Network.SendChat( parsedText, chatTarget.targetType, chatTarget.targetID );
			UI.PlaySound("Play_MP_Chat_Message_Sent");
		end
    end
    Controls.ChatEntry:ClearString();
end

-------------------------------------------------
-- ParseChatText - ensures icon tags parsed properly
-------------------------------------------------
function ParseChatText(text)
	startIdx, endIdx = string.find(string.upper(text), "%[ICON_");
	if(startIdx == nil) then
		return text;
	else
		for i = endIdx + 1, string.len(text) do
			character = string.sub(text, i, i);
			if(character=="]") then
				return string.sub(text, 1, i) .. ParseChatText(string.sub(text,i + 1));
			elseif(character==" ") then
				text = string.gsub(text, " ", "]", 1);
				return string.sub(text, 1, i) .. ParseChatText(string.sub(text, i + 1));
			elseif (character=="[") then
				return string.sub(text, 1, i - 1) .. "]" .. ParseChatText(string.sub(text, i));
			end
		end
		return text.."]";
	end
	return text;
end

-------------------------------------------------
-------------------------------------------------

function OnMultplayerPlayerConnected( playerID )
	if( ContextPtr:IsHidden() == false ) then
		OnChat( playerID, -1, PlayerConnectedChatStr, false );
		UI.PlaySound("Play_MP_Player_Connect");
		UpdateFriendsList();

		-- Autoplay Host readies up as soon as the required number of network connections (human or autoplay players) have connected.
		if(Automation.IsActive() and Network.IsGameHost()) then
			local minPlayers = Automation.GetSetParameter("CurrentTest", "MinPlayers", 2);
			local connectedCount = 0;
			if(minPlayers ~= nil) then
				-- Count network connected player slots
				local player_ids = GameConfiguration.GetMultiplayerPlayerIDs();
				for i, iPlayer in ipairs(player_ids) do	
					if(Network.IsPlayerConnected(iPlayer)) then
						connectedCount = connectedCount + 1;
					end
				end

				if(connectedCount >= minPlayers) then
					Automation.Log("HostGame MinPlayers met, host readying up.  MinPlayers=" .. tostring(minPlayers) .. " ConnectedPlayers=" .. tostring(connectedCount));
					SetLocalReady(true);
				end
			end
		end
	end
end

-------------------------------------------------
-------------------------------------------------

function OnMultiplayerPrePlayerDisconnected( playerID )
	if( ContextPtr:IsHidden() == false ) then
		local playerCfg = PlayerConfigurations[playerID];
		if(playerCfg:IsHuman()) then
			if(Network.IsPlayerKicked(playerID)) then
				OnChat( playerID, -1, PlayerKickedChatStr, false );
			else
    			OnChat( playerID, -1, PlayerDisconnectedChatStr, false );
			end
			UI.PlaySound("Play_MP_Player_Disconnect");
			UpdateFriendsList();
		end
	end
end

-------------------------------------------------
-------------------------------------------------

function OnModStatusUpdated(playerID: number, modState : number, bytesDownloaded : number, bytesTotal : number,
							modsRemaining : number, modsRequired : number)
	
	if(modState == 1) then -- MOD_STATE_DOWNLOADING
		local modStatusString = downloadPendingStr;
		modStatusString = modStatusString .. "[NEWLINE][Icon_AdditionalContent]" .. tostring(modsRemaining) .. "/" .. tostring(modsRequired);
		g_PlayerModStatus[playerID] = modStatusString;
	else
		g_PlayerModStatus[playerID] = nil;
	end
	UpdatePlayerEntry(playerID);

	--[[ Prototype Mod Status Progress Bars
	local playerEntry = g_PlayerEntries[playerID];
	if(playerEntry ~= nil) then
		if(modState ~= 1) then
			playerEntry.PlayerModProgressStack:SetHide(true);
		else
			-- MOD_STATE_DOWNLOADING
			playerEntry.PlayerModProgressStack:SetHide(false);

			-- Update Progress Bar
			local progress : number = 0;
			if(bytesTotal > 0) then
				progress = bytesDownloaded / bytesTotal;
			end
			playerEntry.ModProgressBar:SetPercent(progress);

			-- Building Bytes Remaining Label
			if(bytesTotal > 0) then
				local bytesRemainingStr : string = "";
				local modSizeStr : string = BytesStr;
				local bytesDownloadedScaled : number = bytesDownloaded;
				local bytesTotalScaled : number = bytesTotal;
				if(bytesTotal > 1000000) then
					-- Megabytes
					modSizeStr = MegabytesStr;
					bytesDownloadedScaled = bytesDownloadedScaled / 1000000;
					bytesTotalScaled = bytesTotalScaled / 1000000;
				elseif(bytesTotal > 1000) then
					-- kilobytes
					modSizeStr = KilobytesStr;
					bytesDownloadedScaled = bytesDownloadedScaled / 1000;
					bytesTotalScaled = bytesTotalScaled / 1000;
				end
				bytesRemainingStr = string.format("%.02f%s/%.02f%s", bytesDownloadedScaled, modSizeStr, bytesTotalScaled, modSizeStr);
				playerEntry.BytesRemaining:SetText(bytesRemainingStr);
				playerEntry.BytesRemaining:SetHide(false);
			else
				playerEntry.BytesRemaining:SetHide(true);
			end

			-- Bulding ModProgressRemaining Label
			local modProgressStr : string = "";
			modProgressStr = modProgressStr .. " " .. tostring(modsRemaining) .. "/" .. tostring(modsRequired);
			playerEntry.ModProgressRemaining:SetText(modProgressStr);
		end
	end
	--]]
end

-------------------------------------------------
-------------------------------------------------

function OnAbandoned(eReason)
	if (not ContextPtr:IsHidden()) then

		-- We need to CheckLeaveGame before triggering the reason popup because the reason popup hides the staging room
		-- and would block the leave game incorrectly.  This fixes TTP 22192.
		CheckLeaveGame();

		if (eReason == KickReason.KICK_HOST) then
			LuaEvents.MultiplayerPopup( "LOC_GAME_ABANDONED_KICKED", "LOC_GAME_ABANDONED_KICKED_TITLE" );
		elseif (eReason == KickReason.KICK_NO_HOST) then
			LuaEvents.MultiplayerPopup( "LOC_GAME_ABANDONED_HOST_LOSTED", "LOC_GAME_ABANDONED_HOST_LOSTED_TITLE" );
		elseif (eReason == KickReason.KICK_NO_ROOM) then
			LuaEvents.MultiplayerPopup( "LOC_GAME_ABANDONED_ROOM_FULL", "LOC_GAME_ABANDONED_ROOM_FULL_TITLE" );
		elseif (eReason == KickReason.KICK_VERSION_MISMATCH) then
			LuaEvents.MultiplayerPopup( "LOC_GAME_ABANDONED_VERSION_MISMATCH", "LOC_GAME_ABANDONED_VERSION_MISMATCH_TITLE" );
		elseif (eReason == KickReason.KICK_MOD_ERROR) then
			LuaEvents.MultiplayerPopup( "LOC_GAME_ABANDONED_MOD_ERROR", "LOC_GAME_ABANDONED_MOD_ERROR_TITLE" );
		elseif (eReason == KickReason.KICK_MOD_MISSING) then
			local modMissingErrorStr = Modding.GetLastModErrorString();
			LuaEvents.MultiplayerPopup( modMissingErrorStr, "LOC_GAME_ABANDONED_MOD_MISSING_TITLE" );
		elseif (eReason == KickReason.KICK_MATCH_DELETED) then
			LuaEvents.MultiplayerPopup( "LOC_GAME_ABANDONED_MATCH_DELETED", "LOC_GAME_ABANDONED_MATCH_DELETED_TITLE" );
		else
			LuaEvents.MultiplayerPopup( "LOC_GAME_ABANDONED_CONNECTION_LOST", "LOC_GAME_ABANDONED_CONNECTION_LOST_TITLE");
		end
		Close();
	end
end

-------------------------------------------------
-------------------------------------------------

function OnMultiplayerGameLaunchFailed()
	-- Multiplayer game failed for launch for some reason.
	if(not GameConfiguration.IsPlayByCloud()) then
		SetLocalReady(false); -- Unready the local player so they can try it again.
	end

	m_kPopupDialog:Close();	-- clear out the popup incase it is already open.
	m_kPopupDialog:AddTitle(  Locale.ToUpper(Locale.Lookup("LOC_MULTIPLAYER_GAME_LAUNCH_FAILED_TITLE")));
	m_kPopupDialog:AddText(	  Locale.Lookup("LOC_MULTIPLAYER_GAME_LAUNCH_FAILED"));
	m_kPopupDialog:AddButton( Locale.Lookup("LOC_MULTIPLAYER_GAME_LAUNCH_FAILED_ACCEPT"));
	m_kPopupDialog:Open();
end

-------------------------------------------------
-------------------------------------------------

function OnLeaveGameComplete()
	-- We just left the game, we shouldn't be open anymore.
	UIManager:DequeuePopup( ContextPtr );
end

-------------------------------------------------
-------------------------------------------------

function OnBeforeMultiplayerInviteProcessing()
	-- We're about to process a game invite.  Get off the popup stack before we accidently break the invite!
	UIManager:DequeuePopup( ContextPtr );
end


-------------------------------------------------
-------------------------------------------------

function OnMultiplayerHostMigrated( newHostID : number )
	if(ContextPtr:IsHidden() == false) then
		-- If the local machine has become the host, we need to rebuild the UI so host privileges are displayed.
		local localPlayerID = Network.GetLocalPlayerID();
		if(localPlayerID == newHostID) then
			RealizeGameSetup();
			BuildPlayerList();
		end

		OnChat( newHostID, -1, PlayerHostMigratedChatStr, false );
		UI.PlaySound("Play_MP_Host_Migration");
	end
end

----------------------------------------------------------------
-- Button Handlers
----------------------------------------------------------------

-------------------------------------------------
-- OnSlotType
-------------------------------------------------
function OnSlotType( playerID, id )
	--print("playerID: " .. playerID .. " id: " .. id);
	-- NOTE:  This function assumes that the given player slot is not occupied by a player.  We
	--				assume that players having to be kicked before the slot's type can be manually changed.
	local pPlayerConfig = PlayerConfigurations[playerID];
	local pPlayerEntry = g_PlayerEntries[playerID];

	if g_slotTypeData[id].slotStatus == -1 then
		OnSwapButton(playerID);
		return;
	end

	pPlayerConfig:SetSlotStatus(g_slotTypeData[id].slotStatus);

	-- When setting the slot status to a major civ type, some additional data in the player config needs to be set.
	if(g_slotTypeData[id].slotStatus == SlotStatus.SS_TAKEN or g_slotTypeData[id].slotStatus == SlotStatus.SS_COMPUTER) then
		pPlayerConfig:SetMajorCiv();
	end

	Network.BroadcastPlayerInfo(playerID); -- Network the slot status change.
	
	Controls.PlayerListStack:SortChildren(SortPlayerListStack);
	
	m_iFirstClosedSlot = -1;
	UpdateAllPlayerEntries();

	UpdatePlayerEntry(playerID);

	CheckTeamsValid();
	CheckGameAutoStart();

	if g_slotTypeData[id].slotStatus == SlotStatus.SS_CLOSED then
		Controls.PlayerListStack:CalculateSize();
		Controls.PlayersScrollPanel:CalculateSize();
	end
end

-------------------------------------------------
-- OnSwapButton
-------------------------------------------------
function OnSwapButton(playerID)
	-- In this case, playerID is the desired playerID.
	local localPlayerID = Network.GetLocalPlayerID();
	local oldDesiredPlayerID = Network.GetChangePlayerID(localPlayerID);
	local newDesiredPlayerID = playerID;
	if(oldDesiredPlayerID == newDesiredPlayerID) then
		-- player already requested to swap to this player.  Toggle back to no player swap.
		newDesiredPlayerID = NetPlayerTypes.INVALID_PLAYERID;
	end
	Network.RequestPlayerIDChange(newDesiredPlayerID);
end

-------------------------------------------------
-- OnKickButton
-------------------------------------------------
function OnKickButton(playerID)
	-- Kick button was clicked for the given player slot.
	--print("playerID " .. playerID);
	UIManager:PushModal(Controls.ConfirmKick, true);
	local pPlayerConfig = PlayerConfigurations[playerID];
	if pPlayerConfig:GetSlotStatus() == SlotStatus.SS_COMPUTER then
		LuaEvents.SetKickPlayer(playerID, "LOC_SLOTTYPE_AI");
	else
		local playerName = pPlayerConfig:GetPlayerName();
		LuaEvents.SetKickPlayer(playerID, playerName);
	end
end

-------------------------------------------------
-- OnAddPlayer
-------------------------------------------------
function OnAddPlayer(playerID)
	-- Add Player was clicked for the given player slot.
	-- Set this slot to open	
	
	local pPlayerConfig = PlayerConfigurations[playerID];
	local playerName = pPlayerConfig:GetPlayerName();
	m_iFirstClosedSlot = -1;
	
	pPlayerConfig:SetSlotStatus(SlotStatus.SS_OPEN);
	Network.BroadcastPlayerInfo(playerID); -- Network the slot status change.

	Controls.PlayerListStack:SortChildren(SortPlayerListStack);
	UpdateAllPlayerEntries();

	CheckTeamsValid();
	CheckGameAutoStart();

	Controls.PlayerListStack:CalculateSize();
	Controls.PlayersScrollPanel:CalculateSize();
	Resize();	
end

-------------------------------------------------
-- OnPlayerEntryReady
-------------------------------------------------		-- 号码菌：快捷打开添加名单
function OnPlayerEntryReady(playerID)
	-- Every player entry ready button has this callback, but it only does something if this is for the local player.
	local localPlayerID = Network.GetLocalPlayerID();
	if(playerID == localPlayerID) then
		OnReadyButton();
	else
		local pPlayerConfig = PlayerConfigurations[playerID];
		if(pPlayerConfig:IsHuman()) then
			if Controls.NameModGroupPopup:IsHidden() then
				OnOutputButtonCheck()	
				local playerNetworkID = PlayerConfigurations[playerID]:GetNetworkIdentifer();
				Controls.SteamIDInputEditBox:SetText(playerNetworkID);
			else
				Controls.NameModGroupPopup:SetHide(true)
			end
		end
	end
end

-------------------------------------------------
-- OnJoinTeamButton
-------------------------------------------------
function OnTeamPull( playerID :number, teamID :number)
	local playerConfig = PlayerConfigurations[playerID];

	if(playerConfig ~= nil and teamID ~= playerConfig:GetTeam()) then
		playerConfig:SetTeam(teamID);
		Network.BroadcastPlayerInfo(playerID);
		OnTeamChange(playerID, false);
	end

	UpdatePlayerEntry(playerID);
end

-------------------------------------------------
-- OnInviteButton
-------------------------------------------------
function OnInviteButton()
	local pFriends = Network.GetFriends(Network.GetTransportType());
	if pFriends ~= nil then
		pFriends:ActivateInviteOverlay();
	end
end

-------------------------------------------------
-- OnReadyButton
-------------------------------------------------
function OnReadyButton(playerID)
	
	local localPlayerID = Network.GetLocalPlayerID();
	local localPlayerConfig = PlayerConfigurations[localPlayerID];

	if(not IsCloudInProgress()) then -- PlayByCloud match already in progress, don't touch the local ready state.
		SetLocalReady(not localPlayerConfig:GetReady());
	end
	
	-- Clicking the ready button in some situations instant launches the game.
	if(GameConfiguration.IsHotseat() 
		-- Not our turn in an inprogress PlayByCloud match.  Immediately launch game so player can observe current game state.
		-- NOTE: We can only do this if GAMESTATE_LAUNCHED is set. This indicates that the game host has committed the first turn and
		--		GAMESTATE_LAUNCHED is baked into the save state.
		or (IsCloudInProgressAndNotTurn() and GameConfiguration.GetGameState() == GameStateTypes.GAMESTATE_LAUNCHED)) then 
		Network.LaunchGame();
	end
end

-------------------------------------------------
-- OnClickToCopy
-------------------------------------------------
function OnClickToCopy()
	local sText:string = Controls.JoinCodeText:GetText();
	UIManager:SetClipboardString(sText);
end

----------------------------------------------------------------
-- Screen Scripting
----------------------------------------------------------------
function SetLocalReady(newReady)
	local localPlayerID = Network.GetLocalPlayerID();
	local localPlayerConfig = PlayerConfigurations[localPlayerID];

	-- PlayByCloud Only - Disallow unreadying once the match has started.
	if(IsCloudInProgress() and newReady == false) then
		return;
	end

	-- When using a ready countdown, the player can not unready themselves outside of the ready countdown.
	if(IsUseReadyCountdown() 
		and newReady == false
		and not IsReadyCountdownActive()) then
		return;
	end
	
	if(newReady ~= localPlayerConfig:GetReady()) then
		
		if not GameConfiguration.IsHotseat() then
			Controls.ReadyCheck:SetSelected(newReady);
		end

		-- Show ready-to-go popup when a remote client readies up in a fresh PlayByCloud match.
		if(newReady 
			and GameConfiguration.IsPlayByCloud()
			and GameConfiguration.GetGameState() ~= GameStateTypes.GAMESTATE_LAUNCHED
			and not m_shownPBCReadyPopup
			and not m_exitReadyWait) then -- Do not show ready popup if we are exiting due to pressing the back button.
			ShowPBCReadyPopup();
		end

		localPlayerConfig:SetReady(newReady);
		Network.BroadcastPlayerInfo();
		UpdatePlayerEntry(localPlayerID);
		CheckGameAutoStart();
	end
end

function ShowPBCReadyPopup()
	m_shownPBCReadyPopup = true;
	local readyUpBehavior :number = UserConfiguration.GetPlayByCloudClientReadyBehavior();
	if(readyUpBehavior == PlayByCloudReadyBehaviorType.PBC_READY_ASK_ME) then
		m_kPopupDialog:Close();	-- clear out the popup incase it is already open.
		m_kPopupDialog:AddTitle(  Locale.ToUpper(Locale.Lookup("LOC_PLAYBYCLOUD_REMOTE_READY_POPUP_TITLE")));
		m_kPopupDialog:AddText(	  Locale.Lookup("LOC_PLAYBYCLOUD_REMOTE_READY_POPUP_TEXT"));
		m_kPopupDialog:AddCheckBox(Locale.Lookup("LOC_REMEMBER_MY_CHOICE"), false, OnPBCReadySaveChoice);
		m_kPopupDialog:AddButton( Locale.Lookup("LOC_PLAYBYCLOUD_REMOTE_READY_POPUP_OK"), OnPBCReadyOK );
		m_kPopupDialog:AddButton( Locale.Lookup("LOC_PLAYBYCLOUD_REMOTE_READY_POPUP_LOBBY_EXIT"), OnPBCReadyExitGame, nil, nil );
		m_kPopupDialog:Open();
	elseif(readyUpBehavior == PlayByCloudReadyBehaviorType.PBC_READY_EXIT_LOBBY) then
		StartExitGame();
	end

	-- Nothing needs to happen for the PlayByCloudReadyBehaviorType.PBC_READY_DO_NOTHING.  Obviously.

end

function OnPBCReadySaveChoice()
	m_savePBCReadyChoice = true;
end

function OnPBCReadyOK()
	-- OK means do nothing and remain in the staging room.
	if(m_savePBCReadyChoice == true) then
		Options.SetUserOption("Interface", "PlayByCloudClientReadyBehavior", PlayByCloudReadyBehaviorType.PBC_READY_DO_NOTHING);
		Options.SaveOptions();
	end	
end

function OnPBCReadyExitGame()
	if(m_savePBCReadyChoice == true) then
		Options.SetUserOption("Interface", "PlayByCloudClientReadyBehavior", PlayByCloudReadyBehaviorType.PBC_READY_EXIT_LOBBY);
		Options.SaveOptions();
	end	

	StartExitGame();
end

-------------------------------------------------
-- Update Teams valid status
-------------------------------------------------
function CheckTeamsValid()
	m_bTeamsValid = false;
	local noTeamPlayers : boolean = false;
	local teamTest : number = TeamTypes.NO_TEAM;
    
	-- Teams are invalid if all players are on the same team.
	local player_ids = GameConfiguration.GetParticipatingPlayerIDs();
	for i, iPlayer in ipairs(player_ids) do	
		local curPlayerConfig = PlayerConfigurations[iPlayer];
		if( curPlayerConfig:IsParticipant() 
		and curPlayerConfig:GetCivilizationLevelTypeID() == CivilizationLevelTypes.CIVILIZATION_LEVEL_FULL_CIV ) then
			local curTeam : number = curPlayerConfig:GetTeam();
			if(curTeam == TeamTypes.NO_TEAM) then
				-- If someone doesn't have a team, it means that teams are valid.
				m_bTeamsValid = true;
				return;
			elseif(teamTest == TeamTypes.NO_TEAM) then
				teamTest = curTeam;
			elseif(teamTest ~= curTeam) then
				-- people are on different teams.  Teams are valid.
				m_bTeamsValid = true;
				return;
			end
		end
	end
end

-------------------------------------------------
-- CHECK FOR GAME AUTO START
-------------------------------------------------
function CheckGameAutoStart()
	
	-- PlayByCloud Only - Autostart if we are the active turn player.
	if IsCloudInProgress() and Network.IsCloudTurnPlayer() then
		if(not IsLaunchCountdownActive()) then
			-- Reset global blocking variables so the ready button is not dirty from previous sessions.
			ResetAutoStartFlags();				
			SetLocalReady(true);
			StartLaunchCountdown();
		end
	-- Check to see if we should start/stop the multiplayer game.
	
	elseif(not Network.IsPlayerHotJoining(Network.GetLocalPlayerID())
		
		and not IsCloudInProgressAndNotTurn()
		and not Network.IsCloudLaunching()) then -- We should not autostart if we are already launching into a PlayByCloud match.
		local startCountdown = true;
				
		-- Reset global blocking variables because we're going to recalculate them.
		ResetAutoStartFlags();

		-- Count players and check to see if a human player isn't ready.
		local totalPlayers = 0;
		local totalHumans = 0;
		local noDupLeaders = GameConfiguration.GetValue("NO_DUPLICATE_LEADERS");
		local player_ids = GameConfiguration.GetMultiplayerPlayerIDs();		
		
		for i, iPlayer in ipairs(player_ids) do	
			local curPlayerConfig = PlayerConfigurations[iPlayer];
			local curSlotStatus = curPlayerConfig:GetSlotStatus();
			local curIsFullCiv = curPlayerConfig:GetCivilizationLevelTypeID() == CivilizationLevelTypes.CIVILIZATION_LEVEL_FULL_CIV;
			
			if((curSlotStatus == SlotStatus.SS_TAKEN -- Human civ
				or Network.IsPlayerConnected(iPlayer))	-- network connection on this slot, could be an multiplayer autoplay.
				and (curPlayerConfig:IsAlive() or curSlotStatus == SlotStatus.SS_OBSERVER)) then -- Dead players do not block launch countdown.  Observers count as dead but should still block launch to be consistent. 
				if(not curPlayerConfig:GetReady()) then
					print("CheckGameAutoStart: Can't start game because player ".. iPlayer .. " isn't ready");
					startCountdown = false;
					g_everyoneReady = false;
				-- Players are set to ModRrady when have they successfully downloaded and configured all the mods required for this game.
				-- See Network::Manager::OnFinishedGameplayContentConfigure()
				elseif(not curPlayerConfig:GetModReady()) then
					print("CheckGameAutoStart: Can't start game because player ".. iPlayer .. " isn't mod ready");
					startCountdown = false;
					g_everyoneModReady = false;
				end
			
			elseif(curPlayerConfig:IsHumanRequired() == true 
				and GameConfiguration.GetGameState() == GameStateTypes.GAMESTATE_PREGAME) then
				-- If this is a new game, all human required slots need to be filled by a human.  
				-- NOTE: Human required slots do not need to be filled when loading a save.
				startCountdown = false;
				g_humanRequiredFilled = false;
			end
			
			if( (curSlotStatus == SlotStatus.SS_COMPUTER or curSlotStatus == SlotStatus.SS_TAKEN) and curIsFullCiv ) then
				totalPlayers = totalPlayers + 1;
				
				if(curSlotStatus == SlotStatus.SS_TAKEN) then
					totalHumans = totalHumans + 1;
				end

				if(iPlayer >= g_currentMaxPlayers) then
					-- A player is occupying an invalid player slot for this map size.
					print("CheckGameAutoStart: Can't start game because player " .. iPlayer .. " is in an invalid slot for this map size.");
					startCountdown = false;
					g_badPlayerForMapSize = true;
				end

				-- Check for selection error (ownership rules, duplicate leaders, etc)
				local err = GetPlayerParameterError(iPlayer)
				if(err) then
					
					startCountdown = false;
					if(noDupLeaders and err.Id == "InvalidDomainValue" and err.Reason == "LOC_SETUP_ERROR_NO_DUPLICATE_LEADERS") then
						g_duplicateLeaders = true;
					end
				end
			end
		end
		
		-- Check player count
		if(totalPlayers < g_currentMinPlayers) then
			print("CheckGameAutoStart: Can't start game because there are not enough players. " .. totalPlayers .. "/" .. g_currentMinPlayers);
			startCountdown = false;
			g_notEnoughPlayers = true;
		end

		if(GameConfiguration.IsPlayByCloud() 
			and GameConfiguration.GetGameState() ~= GameStateTypes.GAMESTATE_LAUNCHED
			and totalHumans < 2) then
			print("CheckGameAutoStart: Can't start game because two human players are required for PlayByCloud. totalHumans: " .. totalHumans);
			startCountdown = false;
			g_pbcMinHumanCheck = false;
		end

		if(GameConfiguration.IsMatchMaking()
			and GameConfiguration.GetGameState() ~= GameStateTypes.GAMESTATE_LAUNCHED
			and totalHumans < totalPlayers
			and (IsReadyCountdownActive() or IsWaitForPlayersCountdownActive())) then
			print("CheckGameAutoStart: Can't start game because we are still in the Ready/Matchmaking Countdown and we do not have a full game yet. totalHumans: " .. totalHumans .. ", totalPlayers: " .. tostring(totalPlayers));
			startCountdown = false;
			g_matchMakeFullGameCheck = false;
		end

		if(not Network.IsEveryoneConnected()) then
			print("CheckGameAutoStart: Can't start game because players are joining the game.");
			startCountdown = false;
			g_everyoneConnected = false;
		end

		if(not m_bTeamsValid) then
			print("CheckGameAutoStart: Can't start game because all civs are on the same team!");
			startCountdown = false;
		end

		-- Only the host may launch a PlayByCloud match that is not already in progress.
		if(GameConfiguration.IsPlayByCloud()
			and GameConfiguration.GetGameState() ~= GameStateTypes.GAMESTATE_LAUNCHED
			and not Network.IsGameHost()) then
			print("CheckGameAutoStart: Can't start game because remote client can't launch new PlayByCloud game.");
			startCountdown = false;
			g_pbcNewGameCheck = false;
		end

	
		-- Hotseat bypasses the countdown system.
		if not GameConfiguration.IsHotseat() then
			if(startCountdown) then
				-- Everyone has readied up and we can start.
				StartLaunchCountdown();
			else
				-- We can't autostart now, stop the countdown if we started it earlier.
				if(IsLaunchCountdownActive()) then
					StopCountdown();
				end
			end
		end
	end
	UpdateReadyButton();
end

function ResetAutoStartFlags()
	g_everyoneReady = true;
	g_everyoneConnected = true;
	g_badPlayerForMapSize = false;
	g_notEnoughPlayers = false;
	g_everyoneModReady = true;
	g_duplicateLeaders = false;
	g_humanRequiredFilled = true;
	g_pbcNewGameCheck = true;
	g_pbcMinHumanCheck = true;
	g_matchMakeFullGameCheck = true;
end

-------------------------------------------------
-- Leave the Game
-------------------------------------------------
function CheckLeaveGame()
	-- Leave the network session if we're in a state where the staging room should be triggering the exit.
	if not ContextPtr:IsHidden()	-- If the screen is not visible, this exit might be part of a general UI state change (like Multiplayer_ExitShell)
									-- and should not trigger a game exit.
		and Network.IsInSession()	-- Still in a network session.
		and not Network.IsInGameStartedState() then -- Don't trigger leave game if we're being used as an ingame screen. Worldview is handling this instead.
		print("StagingRoom::CheckLeaveGame() leaving the network session.");
		Network.LeaveGame();
	end
end

-- ===========================================================================
--	LUA Event
-- ===========================================================================
function OnHandleExitRequest()
	print("Staging Room -Handle Exit Request");

	CheckLeaveGame();
	Controls.CountdownTimerAnim:ClearAnimCallback();
	
	-- Force close all popups because they are modal and will remain visible even if the screen is hidden
	for _, playerEntry:table in ipairs(g_PlayerEntries) do
		playerEntry.SlotTypePulldown:ForceClose();
		playerEntry.AlternateSlotTypePulldown:ForceClose();
		playerEntry.TeamPullDown:ForceClose();
		playerEntry.PlayerPullDown:ForceClose();
		playerEntry.HandicapPullDown:ForceClose();
	end

	-- Destroy setup parameters.
	HideGameSetup(function()
		-- Reset instances here.
		m_gameSetupParameterIM:ResetInstances();
	end);
	
	-- Destroy individual player parameters.
	ReleasePlayerParameters();

	-- Exit directly to Lobby
	ResetChat();
	UIManager:DequeuePopup( ContextPtr );
end

function GetPlayerEntry(playerID)
	local playerEntry = g_PlayerEntries[playerID];
	if(playerEntry == nil) then
		-- need to create the player entry.
		--print("creating playerEntry for player " .. tostring(playerID));
		playerEntry = m_playersIM:GetInstance();

		--SetupTeamPulldown( playerID, playerEntry.TeamPullDown );

		local civTooltipData : table = {
			InfoStack			= m_CivTooltip.InfoStack,
			InfoScrollPanel		= m_CivTooltip.InfoScrollPanel;
			CivToolTipSlide		= m_CivTooltip.CivToolTipSlide;
			CivToolTipAlpha		= m_CivTooltip.CivToolTipAlpha;
			UniqueIconIM		= m_CivTooltip.UniqueIconIM;		
			HeaderIconIM		= m_CivTooltip.HeaderIconIM;
			CivHeaderIconIM		= m_CivTooltip.CivHeaderIconIM;
			HeaderIM			= m_CivTooltip.HeaderIM;
			HasLeaderPlacard	= false;
		};

		SetupSplitLeaderPulldown(playerID, playerEntry,"PlayerPullDown",nil,nil,civTooltipData);
		SetupTeamPulldown(playerID, playerEntry.TeamPullDown);
		SetupHandicapPulldown(playerID, playerEntry.HandicapPullDown);

		--playerEntry.PlayerCard:RegisterCallback( Mouse.eLClick, OnSwapButton );
		--playerEntry.PlayerCard:SetVoid1(playerID);
		playerEntry.KickButton:RegisterCallback( Mouse.eLClick, OnKickButton );
		playerEntry.KickButton:SetVoid1(playerID);
		playerEntry.AddPlayerButton:RegisterCallback( Mouse.eLClick, OnAddPlayer );
		playerEntry.AddPlayerButton:SetVoid1(playerID);
		--[[ Prototype Mod Status Progress Bars
		playerEntry.PlayerModProgressStack:SetHide(true);
		--]]
		playerEntry.ReadyImage:RegisterCallback( Mouse.eLClick, OnPlayerEntryReady );
		playerEntry.ReadyImage:SetVoid1(playerID);

		g_PlayerEntries[playerID] = playerEntry;
		g_PlayerRootToPlayerID[tostring(playerEntry.Root)] = playerID;

		-- Remember starting ready status.
		local pPlayerConfig = PlayerConfigurations[playerID];
		g_PlayerReady[playerID] = pPlayerConfig:GetReady();

		UpdatePlayerEntry(playerID);

		Controls.PlayerListStack:SortChildren(SortPlayerListStack);
	end

	return playerEntry;
end

-------------------------------------------------
-- PopulateSlotTypePulldown
-------------------------------------------------
function PopulateSlotTypePulldown( pullDown, playerID, slotTypeOptions )
	
	local instanceManager = pullDown["InstanceManager"];
	if not instanceManager then
		instanceManager = PullDownInstanceManager:new("InstanceOne", "Button", pullDown);
		pullDown["InstanceManager"] = instanceManager;
	end
	
	
	instanceManager:ResetInstances();
	pullDown.ItemCount = 0;

	for i, pair in ipairs(slotTypeOptions) do

		local pPlayerConfig = PlayerConfigurations[playerID];
		local playerSlotStatus = pPlayerConfig:GetSlotStatus();

		-- This option is a valid swap player option.
		local showSwapButton = pair.slotStatus == -1 
			and playerSlotStatus ~= SlotStatus.SS_CLOSED -- Can't swap to closed slots.
			and not pPlayerConfig:IsLocked() -- Can't swap to locked slots.
			and not GameConfiguration.IsHotseat() -- no swap option in hotseat.
			and not GameConfiguration.IsPlayByCloud() -- no swap option in PlayByCloud.
			and not GameConfiguration.IsMatchMaking() -- or when matchmaking
			and playerID ~= Network.GetLocalPlayerID();

		-- This option is a valid slot type option.
		local showSlotButton = CheckShowSlotButton(pair, playerID);

		-- Valid state for hotseatOnly flag
		local hotseatOnlyCheck = (GameConfiguration.IsHotseat() and pair.hotseatAllowed) or (not GameConfiguration.IsHotseat() and not pair.hotseatOnly);

		if(	hotseatOnlyCheck 
			and (showSwapButton or showSlotButton))then

			pullDown.ItemCount = pullDown.ItemCount + 1;
			local instance = instanceManager:GetInstance();
			local slotDisplayName = pair.name;
			local slotToolTip = pair.tooltip;

			-- In PlayByCloud OPEN slots are autoflagged as HumanRequired., morph the display name and tooltip.
			if(GameConfiguration.IsPlayByCloud() and pair.slotStatus == SlotStatus.SS_OPEN) then
				slotDisplayName = "LOC_SLOTTYPE_HUMANREQ";
				slotToolTip = "LOC_SLOTTYPE_HUMANREQ_TT";
			end

			instance.Button:LocalizeAndSetText( slotDisplayName );

			if pair.slotStatus == -1 then
				local isHuman = (playerSlotStatus == SlotStatus.SS_TAKEN);
				instance.Button:LocalizeAndSetToolTip(isHuman and "TXT_KEY_MP_SWAP_WITH_PLAYER_BUTTON_TT" or "TXT_KEY_MP_SWAP_BUTTON_TT");
			else
				instance.Button:LocalizeAndSetToolTip( slotToolTip );
			end
			instance.Button:SetVoids( playerID, i );	
		end
	end

	pullDown:CalculateInternals();
	pullDown:RegisterSelectionCallback(OnSlotType);
	pullDown:SetDisabled(pullDown.ItemCount < 1);
end

function CheckShowSlotButton(slotData :table, playerID: number)
	local pPlayerConfig :object = PlayerConfigurations[playerID];
	local playerSlotStatus :number = pPlayerConfig:GetSlotStatus();

	if(slotData.slotStatus == -1) then
		return false;
	end

	
	-- Special conditions for changing slot types for human slots in network games.
	if(playerSlotStatus == SlotStatus.SS_TAKEN and not GameConfiguration.IsHotseat()) then
		-- You can't change human player slots outside of hotseat mode.
		return false;
	end

	-- You can't switch a civilization to open/closed if the game is at the minimum player count.
	if(slotData.slotStatus == SlotStatus.SS_CLOSED or slotData.slotStatus == SlotStatus.SS_OPEN) then
		if(playerSlotStatus == SlotStatus.SS_TAKEN or playerSlotStatus == SlotStatus.SS_COMPUTER) then -- Current SlotType is a civ
			-- In PlayByCloud OPEN slots are autoflagged as HumanRequired.
			-- We allow them to bypass the minimum player count because 
			-- a human player must occupy the slot for the game to launch. 
			if(not GameConfiguration.IsPlayByCloud() or slotData.slotStatus ~= SlotStatus.SS_OPEN) then
				if(GameConfiguration.GetParticipatingPlayerCount() <= g_currentMinPlayers)	 then
					return false;				
				end
			end
		end
	end

	-- Can't change the slot type of locked player slots.
	if(pPlayerConfig:IsLocked()) then
		return false;
	end

	-- Can't change slot type in matchmaded games. 
	if(GameConfiguration.IsMatchMaking()) then
		return false;
	end

	-- Only the host can change non-local slots.
	if(not Network.IsGameHost() and playerID ~= Network.GetLocalPlayerID()) then
		return false;
	end

	-- Can normally only change slot types before the game has started unless this is a option that can be changed mid-game in hotseat.
	if(GameConfiguration.GetGameState() ~= GameStateTypes.GAMESTATE_PREGAME) then
		if(not slotData.hotseatInProgress or not GameConfiguration.IsHotseat()) then
			return false;
		end
	end

	return true;
end

-------------------------------------------------
-- Team Scripting
-------------------------------------------------
function GetTeamCounts( teamCountTable :table )
	for playerID, teamID in pairs(g_cachedTeams) do
		if(teamCountTable[teamID] == nil) then
			teamCountTable[teamID] = 1;
		else
			teamCountTable[teamID] = teamCountTable[teamID] + 1;
		end
	end
end

function AddTeamPulldownEntry( playerID:number, pullDown:table, instanceManager:table, teamID:number, teamName:string )
	
	local instance = instanceManager:GetInstance();
	
	if teamID >= 0 then
		local teamIconName:string = TEAM_ICON_PREFIX .. tostring(teamID);
		instance.ButtonImage:SetSizeVal(TEAM_ICON_SIZE, TEAM_ICON_SIZE);
		instance.ButtonImage:SetIcon(teamIconName, TEAM_ICON_SIZE);
		instance.ButtonImage:SetColor(GetTeamColor(teamID));
	end

	instance.Button:SetVoids( playerID, teamID );
end

function SetupTeamPulldown( playerID:number, pullDown:table )

	local instanceManager = pullDown["InstanceManager"];
	if not instanceManager then
		instanceManager = PullDownInstanceManager:new("InstanceOne", "Button", pullDown);
		pullDown["InstanceManager"] = instanceManager;
	end
	instanceManager:ResetInstances();

	local teamCounts = {};
	GetTeamCounts(teamCounts);

	local pulldownEntries = {};
	local noTeams = GameConfiguration.GetValue("NO_TEAMS");

	-- Always add "None" entry
	local newPulldownEntry:table = {};
	newPulldownEntry.teamID = -1;
	newPulldownEntry.teamName = GameConfiguration.GetTeamName(-1);
	table.insert(pulldownEntries, newPulldownEntry);

	if(not noTeams) then
		for teamID, playerCount in pairs(teamCounts) do
			if teamID ~= -1 then
				newPulldownEntry = {};
				newPulldownEntry.teamID = teamID;
				newPulldownEntry.teamName = GameConfiguration.GetTeamName(teamID);
				table.insert(pulldownEntries, newPulldownEntry);
			end
		end

		-- Add an empty team slot so players can join/create a new team
		local newTeamID :number = 0;
		while(teamCounts[newTeamID] ~= nil) do
			newTeamID = newTeamID + 1;
		end
		local newTeamName : string = tostring(newTeamID);
		newPulldownEntry = {};
		newPulldownEntry.teamID = newTeamID;
		newPulldownEntry.teamName = newTeamName;
		table.insert(pulldownEntries, newPulldownEntry);
	end

	table.sort(pulldownEntries, function(a, b) return a.teamID < b.teamID; end);

	for pullID, curPulldownEntry in ipairs(pulldownEntries) do
		AddTeamPulldownEntry(playerID, pullDown, instanceManager, curPulldownEntry.teamID, curPulldownEntry.teamName);
	end

	pullDown:CalculateInternals();
	pullDown:RegisterSelectionCallback( OnTeamPull );
end

function RebuildTeamPulldowns()
	for playerID, playerEntry in pairs( g_PlayerEntries ) do
		SetupTeamPulldown(playerID, playerEntry.TeamPullDown);
	end
end

function UpdateTeamList(updateOpenEmptyTeam)
	if(updateOpenEmptyTeam) then
		-- Regenerate the team pulldowns to show at least one empty team option so players can create new teams.
		RebuildTeamPulldowns();
	end

	CheckTeamsValid(); -- Check to see if the teams are valid for game start.
	CheckGameAutoStart();

	
	
	Controls.PlayerListStack:CalculateSize();
	Controls.PlayersScrollPanel:CalculateSize();
	Controls.HotseatDeco:SetHide(not GameConfiguration.IsHotseat());
end

-------------------------------------------------
-- UpdatePlayerEntry
-------------------------------------------------
function UpdateAllPlayerEntries()
	for playerID, playerEntry in pairs( g_PlayerEntries ) do
		 UpdatePlayerEntry(playerID);
	end
end

-- Update the disabled state of the slot type pulldown for all players.
function UpdateAllPlayerEntries_SlotTypeDisabled()
	for playerID, playerEntry in pairs( g_PlayerEntries ) do
		 UpdatePlayerEntry_SlotTypeDisabled(playerID);
	end
end

-- Update the disabled state of the slot type pulldown for this player.
function UpdatePlayerEntry_SlotTypeDisabled(playerID)
	local localPlayerID = Network.GetLocalPlayerID();
	local localPlayerConfig = PlayerConfigurations[localPlayerID];
	local playerEntry = g_PlayerEntries[playerID];
	if(playerEntry ~= nil) then

		-- Disable the pulldown if there are no items in it.
		local itemCount = playerEntry.SlotTypePulldown.ItemCount or 0;

		-- The slot type pulldown handles user access permissions internally (See PopulateSlotTypePulldown()).  
		-- However, we need to disable the pulldown entirely if the local player has readied up.
		local bCanChangeSlotType:boolean = not localPlayerConfig:GetReady() 
											and itemCount > 0; -- No available slot type options.

		playerEntry.AlternateSlotTypePulldown:SetDisabled(not bCanChangeSlotType);
		playerEntry.SlotTypePulldown:SetDisabled(not bCanChangeSlotType);
	end
end

function UpdatePlayerEntry(playerID)
	local playerEntry = g_PlayerEntries[playerID];
	if(playerEntry ~= nil) then
		local localPlayerID = Network.GetLocalPlayerID();
		local localPlayerConfig = PlayerConfigurations[localPlayerID];
		local pPlayerConfig = PlayerConfigurations[playerID];
		local slotStatus = pPlayerConfig:GetSlotStatus();
		local isMinorCiv = pPlayerConfig:GetCivilizationLevelTypeID() ~= CivilizationLevelTypes.CIVILIZATION_LEVEL_FULL_CIV;
		local isAlive = pPlayerConfig:IsAlive();
		local isActiveSlot = not isMinorCiv 
			and (slotStatus ~= SlotStatus.SS_CLOSED) 
			and (slotStatus ~= SlotStatus.SS_OPEN) 
			and (slotStatus ~= SlotStatus.SS_OBSERVER)
			-- In PlayByCloud, the local player still gets an active slot even if they are dead.  We do this so that players
			--		can rejoin the match to see the end game screen,
			and (isAlive or (GameConfiguration.IsPlayByCloud() and playerID == localPlayerID));
		local isHotSeat:boolean = GameConfiguration.IsHotseat();
		
		-- Has this game aleady been started?  Hot joining or loading a save game.
		local gameInProgress:boolean = GameConfiguration.GetGameState() ~= GameStateTypes.GAMESTATE_PREGAME;

		-- NOTE: UpdatePlayerEntry() currently only has control over the team player attribute.  Everything else is controlled by 
		--		PlayerConfigurationValuesToUI() and the PlayerSetupLogic.  See CheckExternalEnabled().
		-- Can the local player change this slot's attributes (handicap; civ, etc) at this time?
		local bCanChangePlayerValues = not pPlayerConfig:GetReady()  -- Can't change a slot once that player is ready.
										and not gameInProgress -- Can't change player values once the game has been started.
										and not pPlayerConfig:IsLocked() -- Can't change the values of locked players.
										and (playerID == localPlayerID		-- You can change yourself.
											-- Game host can alter all the non-human slots if they are not ready.
											or (slotStatus ~= SlotStatus.SS_TAKEN and Network.IsGameHost() and not localPlayerConfig:GetReady())
											-- The player has permission to change everything in hotseat.
											or isHotSeat);
		

			
		local isKickable:boolean = Network.IsGameHost()			-- Only the game host may kick
			and (slotStatus == SlotStatus.SS_TAKEN or slotStatus == SlotStatus.SS_OBSERVER)
			and playerID ~= localPlayerID			-- Can't kick yourself
			and not isHotSeat;	-- Can't kick in hotseat, players use the slot type pulldowns instead.

		-- Show player card for human players only during online matches
		local hidePlayerCard:boolean = isHotSeat or slotStatus ~= SlotStatus.SS_TAKEN;
		local showHotseatEdit:boolean = isHotSeat and slotStatus == SlotStatus.SS_TAKEN;
		playerEntry.SlotTypePulldown:SetHide(hidePlayerCard);
		playerEntry.HotseatEditButton:SetHide(not showHotseatEdit);
		playerEntry.AlternateEditButton:SetHide(not hidePlayerCard);
		playerEntry.AlternateSlotTypePulldown:SetHide(not hidePlayerCard);


		local statusText:string = "";
		if slotStatus == SlotStatus.SS_TAKEN then
			local hostID:number = Network.GetGameHostPlayerID();
			statusText = Locale.Lookup(playerID == hostID and "LOC_SLOTLABEL_HOST" or "LOC_SLOTLABEL_PLAYER");
		elseif slotStatus == SlotStatus.SS_COMPUTER then
			statusText = Locale.Lookup("LOC_SLOTLABEL_COMPUTER");
		elseif slotStatus == SlotStatus.SS_OBSERVER then
			local hostID:number = Network.GetGameHostPlayerID();
			statusText = Locale.Lookup(playerID == hostID and "LOC_SLOTLABEL_OBSERVER_HOST" or "LOC_SLOTLABEL_OBSERVER");
		end
		playerEntry.PlayerStatus:SetText(statusText);
		playerEntry.AlternateStatus:SetText(statusText);

		-- Update cached ready status and play sound if player is newly ready.
		if slotStatus == SlotStatus.SS_TAKEN or slotStatus == SlotStatus.SS_OBSERVER then
			local isReady:boolean = pPlayerConfig:GetReady();
			if(isReady ~= g_PlayerReady[playerID]) then
				g_PlayerReady[playerID] = isReady;
				if(isReady == true) then
					UI.PlaySound("Play_MP_Player_Ready");
				end
			end
		end

		-- Update ready icon
		local showStatusLabel = not isHotSeat and slotStatus ~= SlotStatus.SS_OPEN;
		if not isHotSeat then
			if g_PlayerReady[playerID] or slotStatus == SlotStatus.SS_COMPUTER then
				playerEntry.ReadyImage:SetTextureOffsetVal(0,136);
			else
				playerEntry.ReadyImage:SetTextureOffsetVal(0,0);
			end

			-- Update status string
			local statusString = NotReadyStatusStr;
			local statusTTString = "";
			if(slotStatus == SlotStatus.SS_TAKEN 
				and not pPlayerConfig:GetModReady() 
				and g_PlayerModStatus[playerID] ~= nil 
				and g_PlayerModStatus[playerID] ~= "") then
				statusString = g_PlayerModStatus[playerID];
			elseif(playerID >= g_currentMaxPlayers) then
				-- Player is invalid slot for this map size.
				statusString = BadMapSizeSlotStatusStr;
				statusTTString = BadMapSizeSlotStatusStrTT;
			elseif(curSlotStatus == SlotStatus.SS_OPEN
				and pPlayerConfig:IsHumanRequired() == true 
				and GameConfiguration.GetGameState() == GameStateTypes.GAMESTATE_PREGAME) then
				-- Empty human required slot
				statusString = EmptyHumanRequiredSlotStatusStr;
				statusTTString = EmptyHumanRequiredSlotStatusStrTT;
				showStatusLabel = true;
			elseif(g_PlayerReady[playerID] or slotStatus == SlotStatus.SS_COMPUTER) then
				statusString = ReadyStatusStr;
			end

			-- Check to see if we should warning that this player is above MAX_SUPPORTED_PLAYERS.
			local playersBeforeUs = 0;
			for iLoopPlayer = 0, playerID-1, 1 do	
				local loopPlayerConfig = PlayerConfigurations[iLoopPlayer];
				local loopSlotStatus = loopPlayerConfig:GetSlotStatus();
				local loopIsFullCiv = loopPlayerConfig:GetCivilizationLevelTypeID() == CivilizationLevelTypes.CIVILIZATION_LEVEL_FULL_CIV;
				if( (loopSlotStatus == SlotStatus.SS_COMPUTER or loopSlotStatus == SlotStatus.SS_TAKEN) and loopIsFullCiv ) then
					playersBeforeUs = playersBeforeUs + 1;
				end
			end
			if playersBeforeUs >= MAX_SUPPORTED_PLAYERS then
				statusString = statusString .. "[NEWLINE][COLOR_Red]" .. UnsupportedText;
				if statusTTString ~= "" then
					statusTTString = statusTTString .. "[NEWLINE][COLOR_Red]" .. UnsupportedTextTT;
				else
					statusTTString = "[COLOR_Red]" .. UnsupportedTextTT;
				end
			end

			local err = GetPlayerParameterError(playerID)
			if(err) then
				local reason = err.Reason or "LOC_SETUP_PLAYER_PARAMETER_ERROR";
				statusString = statusString .. "[NEWLINE][COLOR_Red]" .. Locale.Lookup(reason) .. "[ENDCOLOR]";
			end

			playerEntry.StatusLabel:SetText(statusString);
			playerEntry.StatusLabel:SetToolTipString(statusTTString);
		end
		playerEntry.StatusLabel:SetHide(not showStatusLabel);

		if playerID == localPlayerID then
			playerEntry.YouIndicatorLine:SetHide(false);
		else
			playerEntry.YouIndicatorLine:SetHide(true);
		end

		playerEntry.AddPlayerButton:SetHide(true);
		-- Available actions vary if the slot has an active player in it
		if(isActiveSlot) then
			playerEntry.Root:SetHide(false);
			playerEntry.PlayerPullDown:SetHide(false);
			playerEntry.ReadyImage:SetHide(isHotSeat);
			playerEntry.TeamPullDown:SetHide(false);
			playerEntry.HandicapPullDown:SetHide(false);
			playerEntry.KickButton:SetHide(not isKickable);
		else
			if(playerID >= g_currentMaxPlayers) then
				-- inactive slot is invalid for the current map size, hide it.
				playerEntry.Root:SetHide(true);
			elseif slotStatus == SlotStatus.SS_CLOSED then
				
				if (m_iFirstClosedSlot == -1 or m_iFirstClosedSlot == playerID) 
				and Network.IsGameHost() 
				and not localPlayerConfig:GetReady()			-- Hide when the host is ready (to be consistent with the player slot behavior)
				and not gameInProgress 
				and not IsLaunchCountdownActive()				-- Don't show Add Player button while in the launch countdown.
				and not GameConfiguration.IsMatchMaking() then	-- Players can't change number of slots when matchmaking.
					m_iFirstClosedSlot = playerID;
					playerEntry.AddPlayerButton:SetHide(false);
					playerEntry.Root:SetHide(false);
				else
					playerEntry.Root:SetHide(true);
				end
			elseif slotStatus == SlotStatus.SS_OBSERVER and Network.IsPlayerConnected(playerID) then
				playerEntry.Root:SetHide(false);
				playerEntry.PlayerPullDown:SetHide(true);
				playerEntry.TeamPullDown:SetHide(true);
				playerEntry.ReadyImage:SetHide(false);
				playerEntry.HandicapPullDown:SetHide(true);
				playerEntry.KickButton:SetHide(not isKickable);
			else 
				if(gameInProgress
					-- Explicitedly always hide city states.  
					-- In PlayByCloud, the host uploads the player configuration data for city states after the gamecore resolution for new games,
					-- but this happens prior to setting the gamestate to launched in the save file during the first end turn commit.
					or (slotStatus == SlotStatus.SS_COMPUTER and isMinorCiv)) then
					-- Hide inactive slots for games in progress
					playerEntry.Root:SetHide(true);
				else
					-- Inactive slots are visible in the pregame.
					playerEntry.Root:SetHide(false);
					playerEntry.PlayerPullDown:SetHide(true);
					playerEntry.TeamPullDown:SetHide(true);
					playerEntry.ReadyImage:SetHide(true);
					playerEntry.HandicapPullDown:SetHide(true);
					playerEntry.KickButton:SetHide(true);
				end
			end
		end

		--[[ Prototype Mod Status Progress Bars
		-- Hide the player's mod progress if they are mod ready.
		-- This is how the mod progress is hidden once mod downloads are completed.
		if(pPlayerConfig:GetModReady()) then
			playerEntry.PlayerModProgressStack:SetHide(true);
		end
		--]]

		PopulateSlotTypePulldown( playerEntry.AlternateSlotTypePulldown, playerID, g_slotTypeData );
		PopulateSlotTypePulldown(playerEntry.SlotTypePulldown, playerID, g_slotTypeData);
		UpdatePlayerEntry_SlotTypeDisabled(playerID);

		if(isActiveSlot) then
			PlayerConfigurationValuesToUI(playerID); -- Update player configuration pulldown values.

            local parameters = GetPlayerParameters(playerID);
            if(parameters == nil) then
                parameters = CreatePlayerParameters(playerID);
            end

			if parameters.Parameters ~= nil then
				local parameter = parameters.Parameters["PlayerLeader"];

				local leaderType = parameter.Value.Value;
				local icons = GetPlayerIcons(parameter.Value.Domain, parameter.Value.Value);


				local playerColor = icons.PlayerColor;
				local civIcon = playerEntry["CivIcon"];
                local civIconBG = playerEntry["IconBG"];
                local colorControl = playerEntry["ColorPullDown"];
                local civWarnIcon = playerEntry["WarnIcon"];
				colorControl:SetHide(false);	

				civIconBG:SetHide(true);
                civIcon:SetHide(true);
                if (parameter.Value.Value ~= "RANDOM" and parameter.Value.Value ~= "RANDOM_POOL1" and parameter.Value.Value ~= "RANDOM_POOL2") then
                    local colorAlternate = parameters.Parameters["PlayerColorAlternate"] or 0;
        			local backColor, frontColor = UI.GetPlayerColorValues(playerColor, colorAlternate.Value);
					
					if(backColor and frontColor and backColor ~= 0 and frontColor ~= 0) then
						civIcon:SetIcon(icons.CivIcon);
        				civIcon:SetColor(frontColor);
						civIconBG:SetColor(backColor);

						civIconBG:SetHide(false);
						civIcon:SetHide(false);
	        				
						local itemCount = 0;
						if bCanChangePlayerValues then
							local colorInstanceManager = colorControl["InstanceManager"];
							if not colorInstanceManager then
								colorInstanceManager = PullDownInstanceManager:new( "InstanceOne", "Button", colorControl );
								colorControl["InstanceManager"] = colorInstanceManager;
							end

							colorInstanceManager:ResetInstances();
							for j=0, 3, 1 do					
								local backColor, frontColor = UI.GetPlayerColorValues(playerColor, j);
								if(backColor and frontColor and backColor ~= 0 and frontColor ~= 0) then
									local colorEntry = colorInstanceManager:GetInstance();
									itemCount = itemCount + 1;
	
									colorEntry.CivIcon:SetIcon(icons.CivIcon);
									colorEntry.CivIcon:SetColor(frontColor);
									colorEntry.IconBG:SetColor(backColor);
									colorEntry.Button:SetToolTipString(nil);
									colorEntry.Button:RegisterCallback(Mouse.eLClick, function()
										
										-- Update collision check color
										local primary, secondary = UI.GetPlayerColorValues(playerColor, j);
										m_teamColors[playerID] = {primary, secondary}

										local colorParameter = parameters.Parameters["PlayerColorAlternate"];
										parameters:SetParameterValue(colorParameter, j);
									end);
								end           
							end
						end

						colorControl:CalculateInternals();
						colorControl:SetDisabled(not bCanChangePlayerValues or itemCount == 0 or itemCount == 1);
					
						-- update what color we are for collision checks
						m_teamColors[playerID] = { backColor, frontColor};

						local myTeam = m_teamColors[playerID];
                        local bShowWarning = false;
						for k,v in pairs(m_teamColors) do
							if(k ~= playerID) then
								 if( myTeam and v and UI.ArePlayerColorsConflicting( v, myTeam ) ) then
                                    bShowWarning = true;
                                end
							end
						end
                        civWarnIcon:SetHide(not bShowWarning);
    					if bShowWarning == true then
    						civWarnIcon:LocalizeAndSetToolTip("LOC_SETUP_PLAYER_COLOR_COLLISION");
    					else
    						civWarnIcon:SetToolTipString(nil);
    					end
					end
                end
			end
		else
			local colorControl = playerEntry["ColorPullDown"];
			colorControl:SetHide(true);	
        end
		
		-- TeamPullDown is not controlled by PlayerConfigurationValuesToUI and is set manually.
		local noTeams = GameConfiguration.GetValue("NO_TEAMS");
		playerEntry.TeamPullDown:SetDisabled(not bCanChangePlayerValues or noTeams);
		local teamID:number = pPlayerConfig:GetTeam();
		-- If the game is in progress and this player is on a team by themselves, display it as if they are on no team.
		-- We do this to be consistent with the ingame UI.
		if(gameInProgress and GameConfiguration.GetTeamPlayerCount(teamID) <= 1) then
			teamID = TeamTypes.NO_TEAM;
		end
		if teamID >= 0 then
			-- Adjust the texture offset based on the selected team
			local teamIconName:string = TEAM_ICON_PREFIX .. tostring(teamID);
			playerEntry.ButtonSelectedTeam:SetSizeVal(TEAM_ICON_SIZE, TEAM_ICON_SIZE);
			playerEntry.ButtonSelectedTeam:SetIcon(teamIconName, TEAM_ICON_SIZE);
			playerEntry.ButtonSelectedTeam:SetColor(GetTeamColor(teamID));
			playerEntry.ButtonSelectedTeam:SetHide(false);
			playerEntry.ButtonNoTeam:SetHide(true);
		else
			playerEntry.ButtonSelectedTeam:SetHide(true);
			playerEntry.ButtonNoTeam:SetHide(false);
		end

		-- NOTE: order matters. you MUST call this after all other setup and before resize as hotseat will hide/show manipulate elements specific to that mode.
		if(isHotSeat) then
			UpdatePlayerEntry_Hotseat(playerID);		
		end

		-- Slot name toggles based on slotstatus.
		-- Update AFTER hotseat checks as hot seat checks may upate nickname.
		playerEntry.PlayerName:LocalizeAndSetText(pPlayerConfig:GetSlotName()); 
		playerEntry.AlternateName:LocalizeAndSetText(pPlayerConfig:GetSlotName()); 

		-- Update online pip status for human slots.
		if(pPlayerConfig:IsHuman()) then
			local iconStr = onlineIconStr;
			if(not Network.IsPlayerConnected(playerID)) then
				iconStr = offlineIconStr;
			end
			playerEntry.ConnectionStatus:SetText(iconStr);
		end
		
	else
		print("PlayerEntry not found for playerID(" .. tostring(playerID) .. ").");
	end
	OnCheckPlayerData(playerID)		-- 号码菌 刷新名单
end

function UpdatePlayerEntry_Hotseat(playerID)
	if(GameConfiguration.IsHotseat()) then
		local playerEntry = g_PlayerEntries[playerID];
		if(playerEntry ~= nil) then
			local localPlayerID = Network.GetLocalPlayerID();
			local pLocalPlayerConfig = PlayerConfigurations[localPlayerID];
			local pPlayerConfig = PlayerConfigurations[playerID];
			local slotStatus = pPlayerConfig:GetSlotStatus();

			g_hotseatNumHumanPlayers = 0;
			g_hotseatNumAIPlayers = 0;
			local player_ids = GameConfiguration.GetMultiplayerPlayerIDs();
			for i, iPlayer in ipairs(player_ids) do	
				local curPlayerConfig = PlayerConfigurations[iPlayer];
				local curSlotStatus = curPlayerConfig:GetSlotStatus();
				
				print("UpdatePlayerEntry_Hotseat: playerID=" .. iPlayer .. ", SlotStatus=" .. curSlotStatus);	
				if(curSlotStatus == SlotStatus.SS_TAKEN) then 
					g_hotseatNumHumanPlayers = g_hotseatNumHumanPlayers + 1;
				elseif(curSlotStatus == SlotStatus.SS_COMPUTER) then
					g_hotseatNumAIPlayers = g_hotseatNumAIPlayers + 1;
				end
			end
			print("UpdatePlayerEntry_Hotseat: g_hotseatNumHumanPlayers=" .. g_hotseatNumHumanPlayers .. ", g_hotseatNumAIPlayers=" .. g_hotseatNumAIPlayers);	

			if(slotStatus == SlotStatus.SS_TAKEN) then
				local nickName = pPlayerConfig:GetNickName();
				if(nickName == nil or #nickName == 0) then
					pPlayerConfig:SetHotseatName(DefaultHotseatPlayerName .. " " .. g_hotseatNumHumanPlayers);
				end
			end

			if(not g_isBuildingPlayerList and GameConfiguration.IsHotseat() and (slotStatus == SlotStatus.SS_TAKEN or slotStatus == SlotStatus.SS_COMPUTER)) then
				UpdateAllDefaultPlayerNames();
			end

			playerEntry.KickButton:SetHide(true);
			--[[ Prototype Mod Status Progress Bars
			playerEntry.PlayerModProgressStack:SetHide(true);
			--]]

			playerEntry.HotseatEditButton:RegisterCallback(Mouse.eLClick, function()
				UIManager:PushModal(Controls.EditHotseatPlayer, true);
				LuaEvents.StagingRoom_SetPlayerID(playerID);
			end);
		end
	end
end

-- ===========================================================================
function UpdateAllDefaultPlayerNames()
	local humanDefaultPlayerNameConfigs :table = {};
	local humanDefaultPlayerNameEntries :table = {};
	local numHumanPlayers :number = 0;
	local kPlayerIDs :table = GameConfiguration.GetMultiplayerPlayerIDs();

	for i, iPlayer in ipairs(kPlayerIDs) do
		local pCurPlayerConfig	:object = PlayerConfigurations[iPlayer];
		local pCurPlayerEntry	:object = g_PlayerEntries[iPlayer];
		local slotStatus		:number = pCurPlayerConfig:GetSlotStatus();
		
		-- Case where multiple times on one machine it appeared a config could exist
		-- for a taken player but no player object?
		local isSafeToReferencePlayer:boolean = true;
		if pCurPlayerEntry==nil and (slotStatus == SlotStatus.SS_TAKEN) then
			isSafeToReferencePlayer = false;
			UI.DataError("Mismatch player config/entry for player #"..tostring(iPlayer)..". SlotStatus: "..tostring(slotStatus));
		end
		
		if isSafeToReferencePlayer and (slotStatus == SlotStatus.SS_TAKEN) then
			local strRegEx = "^" .. DefaultHotseatPlayerName .. " %d+$"
			print(strRegEx .. " " .. pCurPlayerConfig:GetNickName());
			local isDefaultPlayerName = string.match(pCurPlayerConfig:GetNickName(), strRegEx);
			if(isDefaultPlayerName ~= nil) then
				humanDefaultPlayerNameConfigs[#humanDefaultPlayerNameConfigs+1] = pCurPlayerConfig;
				humanDefaultPlayerNameEntries[#humanDefaultPlayerNameEntries+1] = pCurPlayerEntry;
			end
		end
	end

	for i, v in ipairs(humanDefaultPlayerNameConfigs) do
		local playerConfig = humanDefaultPlayerNameConfigs[i];
		local playerEntry = humanDefaultPlayerNameEntries[i];
		playerConfig:SetHotseatName(DefaultHotseatPlayerName .. " " .. i);
		playerEntry.PlayerName:LocalizeAndSetText(playerConfig:GetNickName()); 
		playerEntry.AlternateName:LocalizeAndSetText(playerConfig:GetNickName());
	end

end

-------------------------------------------------
-- SortPlayerListStack
-------------------------------------------------
function SortPlayerListStack(a, b)
	-- a and b are the Root controls of the PlayerListEntry we are sorting.
	local playerIDA = g_PlayerRootToPlayerID[tostring(a)];
	local playerIDB = g_PlayerRootToPlayerID[tostring(b)];
	if(playerIDA ~= nil and playerIDB ~= nil) then
		local playerConfigA = PlayerConfigurations[playerIDA];
		local playerConfigB = PlayerConfigurations[playerIDB];

		-- push closed slots to the bottom
		if(playerConfigA:GetSlotStatus() == SlotStatus.SS_CLOSED) then
			return false;
		elseif(playerConfigB:GetSlotStatus() == SlotStatus.SS_CLOSED) then
			return true;
		end

		-- Finally, sort by playerID value.
		return playerIDA < playerIDB;
	elseif (playerIDA ~= nil and playerIDB == nil) then
		-- nil entries should be at the end of the list.
		return true;
	elseif(playerIDA == nil and playerIDB ~= nil) then
		-- nil entries should be at the end of the list.
		return false;
	else
		return tostring(a) < tostring(b);				
	end	
end

function UpdateReadyButton_Hotseat()
	if(GameConfiguration.IsHotseat()) then
		if(g_hotseatNumHumanPlayers == 0) then
			Controls.StartLabel:SetText(Locale.ToUpper(Locale.Lookup("LOC_READY_BLOCKED_HOTSEAT_NO_HUMAN_PLAYERS")));
			Controls.ReadyButton:SetText("");
			Controls.ReadyButton:LocalizeAndSetToolTip("LOC_READY_BLOCKED_HOTSEAT_NO_HUMAN_PLAYERS_TT");
			Controls.ReadyButton:SetDisabled(true);
		elseif(g_hotseatNumHumanPlayers + g_hotseatNumAIPlayers < 2) then
			Controls.StartLabel:SetText(Locale.ToUpper(Locale.Lookup("LOC_READY_BLOCKED_NOT_ENOUGH_PLAYERS")));
			Controls.ReadyButton:SetText("");
			Controls.ReadyButton:LocalizeAndSetToolTip("LOC_READY_BLOCKED_NOT_ENOUGH_PLAYERS_TT");
			Controls.ReadyButton:SetDisabled(true);
		elseif(not m_bTeamsValid) then
			Controls.StartLabel:SetText(Locale.ToUpper(Locale.Lookup("LOC_READY_BLOCKED_HOTSEAT_INVALID_TEAMS")));
			Controls.ReadyButton:SetText("");
			Controls.ReadyButton:LocalizeAndSetToolTip("LOC_READY_BLOCKED_HOTSEAT_INVALID_TEAMS_TT");
			Controls.ReadyButton:SetDisabled(true);
		elseif(g_badPlayerForMapSize) then
			Controls.StartLabel:LocalizeAndSetText("LOC_READY_BLOCKED_PLAYER_MAP_SIZE");
			Controls.ReadyButton:SetText("");
			Controls.ReadyButton:LocalizeAndSetToolTip( "LOC_READY_BLOCKED_PLAYER_MAP_SIZE_TT", g_currentMaxPlayers);
			Controls.ReadyButton:SetDisabled(true);
		elseif(g_duplicateLeaders) then
			Controls.StartLabel:SetText(Locale.ToUpper(Locale.Lookup("LOC_SETUP_ERROR_NO_DUPLICATE_LEADERS")));
			Controls.ReadyButton:SetText("");
			Controls.ReadyButton:LocalizeAndSetToolTip("LOC_SETUP_ERROR_NO_DUPLICATE_LEADERS");
			Controls.ReadyButton:SetDisabled(true);
		else
			Controls.StartLabel:SetText(Locale.ToUpper(Locale.Lookup("LOC_START_GAME")));
			Controls.ReadyButton:SetText("");
			Controls.ReadyButton:LocalizeAndSetToolTip("");
			Controls.ReadyButton:SetDisabled(false);
		end
	end
end

function UpdateReadyButton()
	local localPlayerID = Network.GetLocalPlayerID();
	local localPlayerConfig = PlayerConfigurations[localPlayerID];

	if(GameConfiguration.IsHotseat()) then
		UpdateReadyButton_Hotseat();
		return;
	end

	local localPlayerEntry = GetPlayerEntry(localPlayerID);
	local localPlayerButton = localPlayerEntry.ReadyImage;
	if(m_countdownType ~= CountdownTypes.None) then
		local startLabel :string = Locale.ToUpper(Locale.Lookup("LOC_GAMESTART_COUNTDOWN_FORMAT"));  -- Defaults to COUNTDOWN_LAUNCH
		local toolTip :string = "";
		if(IsReadyCountdownActive()) then
			startLabel = Locale.ToUpper(Locale.Lookup("LOC_READY_COUNTDOWN_FORMAT"));
			toolTip = Locale.Lookup("LOC_READY_COUNTDOWN_TT");
		elseif(IsWaitForPlayersCountdownActive()) then
			startLabel = Locale.ToUpper(Locale.Lookup("LOC_WAITING_FOR_PLAYERS_COUNTDOWN_FORMAT"));
			toolTip = Locale.Lookup("LOC_WAITING_FOR_PLAYERS_COUNTDOWN_TT");
		end

		local timeRemaining :number = GetCountdownTimeRemaining();
		local intTime :number = math.floor(timeRemaining);
		Controls.StartLabel:SetText( startLabel );
		Controls.ReadyButton:LocalizeAndSetText(  intTime );
		Controls.ReadyButton:LocalizeAndSetToolTip( toolTip );
		Controls.ReadyCheck:LocalizeAndSetToolTip( toolTip );
		localPlayerButton:LocalizeAndSetToolTip( toolTip );
	elseif(IsCloudInProgressAndNotTurn()) then
		Controls.StartLabel:SetText( Locale.ToUpper(Locale.Lookup( "LOC_START_WAITING_FOR_TURN" )));
		Controls.ReadyButton:SetText("");
		Controls.ReadyButton:LocalizeAndSetToolTip( "LOC_START_WAITING_FOR_TURN_TT" );
		Controls.ReadyCheck:LocalizeAndSetToolTip( "LOC_START_WAITING_FOR_TURN_TT" );
		localPlayerButton:LocalizeAndSetToolTip( "LOC_START_WAITING_FOR_TURN_TT" );
	elseif(not g_everyoneReady) then
		-- Local player hasn't readied up yet, just show "Ready"
		Controls.StartLabel:SetText( Locale.ToUpper(Locale.Lookup( "LOC_ARE_YOU_READY" )));
		Controls.ReadyButton:SetText("");
		Controls.ReadyButton:LocalizeAndSetToolTip( "" );
		Controls.ReadyCheck:LocalizeAndSetToolTip( "" );
		localPlayerButton:LocalizeAndSetToolTip( "" );
	-- Local player is ready, show why we're not in the countdown yet!
	elseif(not g_everyoneConnected) then
		-- Waiting for a player to finish connecting to the game.
		Controls.StartLabel:SetText( Locale.ToUpper(Locale.Lookup("LOC_READY_BLOCKED_PLAYERS_CONNECTING")));

		local waitingForJoinersTooltip : string = Locale.Lookup("LOC_READY_BLOCKED_PLAYERS_CONNECTING_TT");
		local player_ids = GameConfiguration.GetMultiplayerPlayerIDs();
		for i, iPlayer in ipairs(player_ids) do	
			local curPlayerConfig = PlayerConfigurations[iPlayer];
			local curSlotStatus = curPlayerConfig:GetSlotStatus();
			if(curSlotStatus == SlotStatus.SS_TAKEN and not Network.IsPlayerConnected(playerID)) then
				waitingForJoinersTooltip = waitingForJoinersTooltip .. "[NEWLINE]" .. "(" .. Locale.Lookup(curPlayerConfig:GetPlayerName()) .. ") ";
			end
		end
		Controls.ReadyButton:SetToolTipString( waitingForJoinersTooltip );
		Controls.ReadyCheck:SetToolTipString( waitingForJoinersTooltip );
		localPlayerButton:SetToolTipString( waitingForJoinersTooltip );
	elseif(g_notEnoughPlayers) then
		Controls.StartLabel:LocalizeAndSetText("LOC_READY_BLOCKED_NOT_ENOUGH_PLAYERS");
		Controls.ReadyButton:LocalizeAndSetToolTip( "LOC_READY_BLOCKED_NOT_ENOUGH_PLAYERS_TT");
		Controls.ReadyCheck:LocalizeAndSetToolTip( "LOC_READY_BLOCKED_NOT_ENOUGH_PLAYERS_TT");
		localPlayerButton:LocalizeAndSetToolTip( "LOC_READY_BLOCKED_NOT_ENOUGH_PLAYERS_TT");
	elseif(not m_bTeamsValid) then
		Controls.StartLabel:LocalizeAndSetText("LOC_READY_BLOCKED_TEAMS_INVALID");
		Controls.ReadyButton:LocalizeAndSetToolTip( "LOC_READY_BLOCKED_TEAMS_INVALID_TT" );
		Controls.ReadyCheck:LocalizeAndSetToolTip( "LOC_READY_BLOCKED_TEAMS_INVALID_TT" );
		localPlayerButton:LocalizeAndSetToolTip( "LOC_READY_BLOCKED_TEAMS_INVALID_TT" );
	elseif(g_badPlayerForMapSize) then
		Controls.StartLabel:LocalizeAndSetText("LOC_READY_BLOCKED_PLAYER_MAP_SIZE");
		Controls.ReadyButton:LocalizeAndSetToolTip( "LOC_READY_BLOCKED_PLAYER_MAP_SIZE_TT", g_currentMaxPlayers);
		Controls.ReadyCheck:LocalizeAndSetToolTip( "LOC_READY_BLOCKED_PLAYER_MAP_SIZE_TT", g_currentMaxPlayers);
		localPlayerButton:LocalizeAndSetToolTip( "LOC_READY_BLOCKED_PLAYER_MAP_SIZE_TT", g_currentMaxPlayers);
	elseif(not g_everyoneModReady) then
		-- A player doesn't have the mods required for this game.
		Controls.StartLabel:LocalizeAndSetText("LOC_READY_BLOCKED_PLAYERS_NOT_MOD_READY");

		local waitingForModReadyTooltip : string = Locale.Lookup("LOC_READY_BLOCKED_PLAYERS_NOT_MOD_READY");
		local player_ids = GameConfiguration.GetMultiplayerPlayerIDs();
		for i, iPlayer in ipairs(player_ids) do	
			local curPlayerConfig = PlayerConfigurations[iPlayer];
			local curSlotStatus = curPlayerConfig:GetSlotStatus();
			if(curSlotStatus == SlotStatus.SS_TAKEN and not curPlayerConfig:GetModReady()) then
				waitingForModReadyTooltip = waitingForModReadyTooltip .. "[NEWLINE]" .. "(" .. Locale.Lookup(curPlayerConfig:GetPlayerName()) .. ") ";
			end
		end
		Controls.ReadyButton:SetToolTipString( waitingForModReadyTooltip );
		Controls.ReadyCheck:SetToolTipString( waitingForModReadyTooltip );
		localPlayerButton:SetToolTipString( waitingForModReadyTooltip );
	elseif(g_duplicateLeaders) then
		Controls.StartLabel:LocalizeAndSetText("LOC_SETUP_ERROR_NO_DUPLICATE_LEADERS");
		Controls.ReadyButton:LocalizeAndSetToolTip("LOC_SETUP_ERROR_NO_DUPLICATE_LEADERS");
		Controls.ReadyCheck:LocalizeAndSetToolTip( "LOC_SETUP_ERROR_NO_DUPLICATE_LEADERS");
		localPlayerButton:LocalizeAndSetToolTip( "LOC_SETUP_ERROR_NO_DUPLICATE_LEADERS");
	elseif(not g_humanRequiredFilled) then
		Controls.StartLabel:LocalizeAndSetText("LOC_SETUP_ERROR_HUMANS_REQUIRED");
		Controls.ReadyButton:LocalizeAndSetToolTip("LOC_SETUP_ERROR_HUMANS_REQUIRED_TT");
		Controls.ReadyCheck:LocalizeAndSetToolTip( "LOC_SETUP_ERROR_HUMANS_REQUIRED_TT");
		localPlayerButton:LocalizeAndSetToolTip( "LOC_SETUP_ERROR_HUMANS_REQUIRED");
	elseif(not g_pbcNewGameCheck) then
		Controls.StartLabel:LocalizeAndSetText("LOC_SETUP_ERROR_PLAYBYCLOUD_REMOTE_READY");
		Controls.ReadyButton:LocalizeAndSetToolTip("LOC_SETUP_ERROR_PLAYBYCLOUD_REMOTE_READY_TT");
		Controls.ReadyCheck:LocalizeAndSetToolTip( "LOC_SETUP_ERROR_PLAYBYCLOUD_REMOTE_READY_TT");
		localPlayerButton:LocalizeAndSetToolTip("LOC_SETUP_ERROR_PLAYBYCLOUD_REMOTE_READY");	
	elseif(not g_pbcMinHumanCheck) then
		Controls.StartLabel:LocalizeAndSetText("LOC_READY_BLOCKED_NOT_ENOUGH_HUMANS");
		Controls.ReadyButton:LocalizeAndSetToolTip("LOC_READY_BLOCKED_NOT_ENOUGH_HUMANS_TT");
		Controls.ReadyCheck:LocalizeAndSetToolTip( "LOC_READY_BLOCKED_NOT_ENOUGH_HUMANS_TT");
		localPlayerButton:LocalizeAndSetToolTip("LOC_READY_BLOCKED_NOT_ENOUGH_HUMANS");			
	end

	local errorReason;
	local game_err = GetGameParametersError();
	if(game_err) then
		errorReason = game_err.Reason or "LOC_SETUP_PARAMETER_ERROR";
	end

	local player_ids = GameConfiguration.GetMultiplayerPlayerIDs();
	for i, iPlayer in ipairs(player_ids) do	
		-- Check for selection error (ownership rules, duplicate leaders, etc)
		local err = GetPlayerParameterError(iPlayer)
		if(err) then
			errorReason = err.Reason or "LOC_SETUP_PLAYER_PARAMETER_ERROR"
		end
	end
	-- Block ready up when there is a civ ownership issue.  
	-- We have to do this because ownership is not communicated to the host.
	if(errorReason) then
		Controls.StartLabel:SetText("[COLOR_RED]" .. Locale.Lookup(errorReason) .. "[ENDCOLOR]");
		Controls.ReadyButton:SetDisabled(true)
		Controls.ReadyCheck:SetDisabled(true);
		localPlayerButton:SetDisabled(true);
	else
		Controls.ReadyButton:SetDisabled(false);
		Controls.ReadyCheck:SetDisabled(false);
		localPlayerButton:SetDisabled(false);
	end
end

-------------------------------------------------
-- Start Game Launch Countdown
-------------------------------------------------
function StartCountdown(countdownType :string)
	if(m_countdownType == countdownType) then
		return;
	end

	local countdownData = g_CountdownData[countdownType];
	if(countdownData == nil) then
		print("ERROR: missing countdownData for type " .. tostring(countdownType));
		return;
	end

	print("Starting Countdown Type " .. tostring(countdownType));
	m_countdownType = countdownType;

	if(countdownData.TimerType == TimerTypes.Script) then
		g_fCountdownTimer = countdownData.CountdownTime;
	else
		g_fCountdownTimer = NO_COUNTDOWN;
	end

	g_fCountdownTickSoundTime = countdownData.TickStartTime;
	g_fCountdownInitialTime = countdownData.CountdownTime;
	g_fCountdownReadyButtonTime = countdownData.CountdownTime;

	Controls.CountdownTimerAnim:RegisterAnimCallback( OnUpdateTimers );

	-- Update m_iFirstClosedSlot's player slot so it will hide the Add Player button if needed for this countdown type.
	if(m_iFirstClosedSlot ~= -1) then
		UpdatePlayerEntry(m_iFirstClosedSlot);
	end
	
	ShowHideReadyButtons();
end

function StartLaunchCountdown()
	--print("StartLaunchCountdown");
	local gameState = GameConfiguration.GetGameState();
	-- In progress PlayByCloud games and matchmaking games launch instantly.
	if((GameConfiguration.IsPlayByCloud() and gameState == GameStateTypes.GAMESTATE_LAUNCHED)
		or GameConfiguration.IsMatchMaking()) then
		-- Joining a PlayByCloud game already in progress has a much faster countdown to be less annoying.
		StartCountdown(CountdownTypes.Launch_Instant);
	else
		StartCountdown(CountdownTypes.Launch);
	end
end

function StartReadyCountdown()
	StartCountdown(GetReadyCountdownType());
end

-------------------------------------------------
-- Stop Launch Countdown
-------------------------------------------------
function StopCountdown()
	if(m_countdownType ~= CountdownTypes.None) then
		print("Stopping Countdown. m_countdownType=" .. tostring(m_countdownType));
	end

	Controls.TurnTimerMeter:SetPercent(0);
	m_countdownType = CountdownTypes.None;	
	g_fCountdownTimer = NO_COUNTDOWN;
	g_fCountdownInitialTime = NO_COUNTDOWN;
	UpdateReadyButton();

	-- Update m_iFirstClosedSlot's player slot so it will show the Add Player button.
	if(m_iFirstClosedSlot ~= -1) then
		UpdatePlayerEntry(m_iFirstClosedSlot);
	end

	ShowHideReadyButtons();
	
	Controls.CountdownTimerAnim:ClearAnimCallback();	
end

-------------------------------------------------
-- BuildPlayerList
-------------------------------------------------
function BuildPlayerList()
	ReleasePlayerParameters(); -- Release all the player parameters so they do not have zombie references to the entries we are now wiping.
	g_isBuildingPlayerList = true;
	-- Clear previous data.
	g_PlayerEntries = {};
	g_PlayerRootToPlayerID = {};
	g_cachedTeams = {};
	m_playersIM:ResetInstances();
	m_iFirstClosedSlot = -1;
	local numPlayers:number = 0;

	-- Create a player slot for every current participant and available player slot for the players.
	local player_ids = GameConfiguration.GetMultiplayerPlayerIDs();
	for i, iPlayer in ipairs(player_ids) do	
		local pPlayerConfig = PlayerConfigurations[iPlayer];
		if(pPlayerConfig ~= nil
			and IsDisplayableSlot(iPlayer)) then
			if(GameConfiguration.IsHotseat()) then
				local nickName = pPlayerConfig:GetNickName();
				if(nickName == nil or #nickName == 0) then
					pPlayerConfig:SetHotseatName(DefaultHotseatPlayerName .. " " .. iPlayer + 1);
				end
			end
            m_teamColors[numPlayers] = nil;
            -- Trigger a fake OnTeamChange on every active player slot to automagically create required PlayerEntry/TeamEntry
			OnTeamChange(iPlayer, true);
			numPlayers = numPlayers + 1;
            m_numPlayers = numPlayers;
		end	
	end

	UpdateTeamList(true);

	SetupGridLines(numPlayers - 1);

	g_isBuildingPlayerList = false;
end

-- ===========================================================================
-- Adjust vertical grid lines
-- ===========================================================================
function RealizeGridSize()
	Controls.PlayerListStack:CalculateSize();
	Controls.PlayersScrollPanel:CalculateSize();

	local gridLineHeight:number = math.max(Controls.PlayerListStack:GetSizeY(), Controls.PlayersScrollPanel:GetSizeY());
	for i = 1, NUM_COLUMNS do
		Controls["GridLine_" .. i]:SetEndY(gridLineHeight);
	end
	
	Controls.GridContainer:SetSizeY(gridLineHeight);
end

-------------------------------------------------
-- ResetChat
-------------------------------------------------
function ResetChat()
	m_ChatInstances = {}
	Controls.ChatStack:DestroyAllChildren();
	ChatPrintHelpHint(Controls.ChatStack, m_ChatInstances, Controls.ChatScroll);
end

-------------------------------------------------
--	Should only be ticking if there are timers active.
-------------------------------------------------
function OnUpdateTimers( uiControl:table, fProgress:number )

	local fDTime:number = UIManager:GetLastTimeDelta();

	if(m_countdownType == CountdownTypes.None) then
		Controls.CountdownTimerAnim:ClearAnimCallback();
	else
		UpdateCountdownTimeRemaining();
		local timeRemaining :number = GetCountdownTimeRemaining();
		Controls.TurnTimerMeter:SetPercent(timeRemaining / g_fCountdownInitialTime);
		if( IsLaunchCountdownActive() and not Network.IsEveryoneConnected() ) then
			-- not all players are connected anymore.  This is probably due to a player join in progress.
			StopCountdown();
		elseif( timeRemaining <= 0 ) then
			local stopCountdown = true;
			local checkForStart = false;
			if( IsLaunchCountdownActive() ) then
				-- Timer elapsed, launch the game if we're the netsession host.
				if(Network.IsNetSessionHost()) then
					Network.LaunchGame();
				end
			elseif( IsReadyCountdownActive() ) then
				-- Force ready the local player
				SetLocalReady(true);

				if(IsUseWaitingForPlayersCountdown()) then
					-- Transition to the Waiting For Players countdown.
					StartCountdown(CountdownTypes.WaitForPlayers);
					stopCountdown = false;
				end
			elseif( IsWaitForPlayersCountdownActive() ) then
				-- After stopping the countdown, recheck for start.  This should trigger the launch countdown because all players should be past their ready countdowns.
				checkForStart = true;			
			end

			if(stopCountdown == true) then
				StopCountdown();
			end

			if(checkForStart == true) then
				CheckGameAutoStart();
			end
		else
			-- Update countdown tick sound.
			if( timeRemaining < g_fCountdownTickSoundTime) then
				g_fCountdownTickSoundTime = g_fCountdownTickSoundTime-1; -- set countdown tick for next second.
				UI.PlaySound("Play_MP_Game_Launch_Timer_Beep");
			end

			-- Update countdown ready button.
			if( timeRemaining < g_fCountdownReadyButtonTime) then
				g_fCountdownReadyButtonTime = g_fCountdownReadyButtonTime-1; -- set countdown tick for next second.
				UpdateReadyButton();
			end
		end
	end
end

function UpdateCountdownTimeRemaining()
	local countdownData :table = g_CountdownData[m_countdownType];
	if(countdownData == nil) then
		print("ERROR: missing countdown data!");
		return;
	end

	if(countdownData.TimerType == TimerTypes.NetworkManager) then
		-- Network Manager timer updates itself.
		return;
	end

	local fDTime:number = UIManager:GetLastTimeDelta();
	g_fCountdownTimer = g_fCountdownTimer - fDTime;
end

-------------------------------------------------
-------------------------------------------------
function OnShow()
	-- Fetch g_currentMaxPlayers because it might be stale due to loading a save.
	g_currentMaxPlayers = math.min(MapConfiguration.GetMaxMajorPlayers(), 20); -- BUDDY: changed from 12 
	m_shownPBCReadyPopup = false;
	m_exitReadyWait = false;

	local networkSessionID:number = Network.GetSessionID();
	if m_sessionID ~= networkSessionID then
		-- This is a fresh session.
		m_sessionID = networkSessionID;

		StopCountdown();

		-- When using the ready countdown mode, start the ready countdown if the player is not already readied up.
		-- If the player is already readied up, we just don't allow them to unready.
		local localPlayerID :number = Network.GetLocalPlayerID();
		local localPlayerConfig :table = PlayerConfigurations[localPlayerID];
		if(IsUseReadyCountdown() 
			and localPlayerConfig ~= nil
			and localPlayerConfig:GetReady() == false) then
			StartReadyCountdown();
		end
	end

	InitializeReadyUI();
	ShowHideInviteButton();	
	ShowHideTopLeftButtons();
	
	ShowHideTPTButtons();		-- 号码菌：是否显示按钮
	
	RealizeGameSetup();
	BuildPlayerList();
	PopulateTargetPull(Controls.ChatPull, Controls.ChatEntry, Controls.ChatIcon, m_playerTargetEntries, m_playerTarget, false, OnChatPulldownChanged);
	ShowHideChatPanel();

	local pFriends = Network.GetFriends();
	if (pFriends ~= nil) then
		pFriends:SetRichPresence("civPresence", Network.IsGameHost() and "LOC_PRESENCE_HOSTING_GAME" or "LOC_PRESENCE_IN_STAGING_ROOM");
	end

	UpdateFriendsList();
	RealizeInfoTabs();
	RealizeGridSize();

	-- Forgive me universe!
	Controls.ReadyButton:SetOffsetY(isHotSeat and -16 or -18);

	if(Automation.IsActive()) then
		if(not Network.IsGameHost()) then
			-- Remote clients ready up immediately.
			SetLocalReady(true);
		else
			local minPlayers = Automation.GetSetParameter("CurrentTest", "MinPlayers", 2);
			if (minPlayers ~= nil) then
				-- See if we are going to be the only one in the game, set ourselves ready. 
				if (minPlayers == 1) then
					Automation.Log("HostGame MinPlayers==1, host readying up.");
					SetLocalReady(true);
				end
			end
		end
	end
end


function OnChatPulldownChanged(newTargetType :number, newTargetID :number)
	local textControl:table = Controls.ChatPull:GetButton():GetTextControl();
	local text:string = textControl:GetText();
	Controls.ChatPull:SetToolTipString(text);
end

-------------------------------------------------
-------------------------------------------------
function InitializeReadyUI()
	-- Set initial ready check state.  This might be dirty from a previous staging room.
	local localPlayerID = Network.GetLocalPlayerID();
	local localPlayerConfig = PlayerConfigurations[localPlayerID];

	if(IsCloudInProgressAndNotTurn()) then
		-- Show the ready check as unselected while in an inprogress PlayByCloud match where it is not our turn.  
		-- Clicking the ready button will instant launch the match so the player can observe the current game state.
		Controls.ReadyCheck:SetSelected(false);
	else
		Controls.ReadyCheck:SetSelected(localPlayerConfig:GetReady());
	end

	-- Hotseat doesn't use the readying mechanic (countdown; ready background elements; ready column). 
	local isHotSeat:boolean = GameConfiguration.IsHotseat();
	Controls.LargeCompassDeco:SetHide(isHotSeat);
	Controls.TurnTimerBG:SetHide(isHotSeat);
	Controls.TurnTimerMeter:SetHide(isHotSeat);
	Controls.TurnTimerHotseatBG:SetHide(not isHotSeat);
	Controls.ReadyColumnLabel:SetHide(isHotSeat);

	ShowHideReadyButtons();
end

-------------------------------------------------
-------------------------------------------------
function ShowHideInviteButton()
	local canInvite :boolean = CanInviteFriends(true);
	Controls.InviteButton:SetHide( not canInvite );
end

-------------------------------------------------
-------------------------------------------------
function ShowHideTopLeftButtons()
	local showEndGame :boolean = GameConfiguration.IsPlayByCloud() and Network.IsGameHost();
	local showQuitGame : boolean = GameConfiguration.IsPlayByCloud();

	Controls.EndGameButton:SetHide( not showEndGame);
	Controls.QuitGameButton:SetHide( not showQuitGame);

	Controls.LeftTopButtonStack:CalculateSize();	
end

-------------------------------------------------
-------------------------------------------------
function ShowHideReadyButtons()
	-- show ready button when in not in a countdown or hotseat.
	local showReadyCheck = not GameConfiguration.IsHotseat() and (m_countdownType == CountdownTypes.None);
	Controls.ReadyCheckContainer:SetHide(not showReadyCheck);
	Controls.ReadyButtonContainer:SetHide(showReadyCheck);
end

-------------------------------------------------
-------------------------------------------------
function ShowHideChatPanel()
	if(GameConfiguration.IsHotseat() or not UI.HasFeature("Chat") or GameConfiguration.IsPlayByCloud()) then
		Controls.ChatContainer:SetHide(true);
	else
		Controls.ChatContainer:SetHide(false);
	end
	--Controls.TwinPanelStack:CalculateSize();
end

-------------------------------------------------------------------------------
-- Setup Player Interface
-- This gets or creates player parameters for a given player id.
-- It then appends a driver to the setup parameter to control a visual 
-- representation of the parameter
-------------------------------------------------------------------------------
function SetupSplitLeaderPulldown(playerId:number, instance:table, pulldownControlName:string, civIconControlName, leaderIconControlName, tooltipControls:table)
	local parameters = GetPlayerParameters(playerId);
	if(parameters == nil) then
		parameters = CreatePlayerParameters(playerId);
	end

	-- Need to save our master tooltip controls so that we can update them if we hop into advanced setup and then go back to basic setup
	if (tooltipControls.HasLeaderPlacard) then
		m_tooltipControls = {};
		m_tooltipControls = tooltipControls;
	end

	-- Defaults
	if(leaderIconControlName == nil) then
		leaderIconControlName = "LeaderIcon";
	end
		
	local control = instance[pulldownControlName];
	local leaderIcon = instance[leaderIconControlName];
	local civIcon = instance["CivIcon"];
	local civIconBG = instance["IconBG"];
	local civWarnIcon = instance["WarnIcon"];
    local scrollText = instance["ScrollText"];
	local instanceManager = control["InstanceManager"];
	if not instanceManager then
		instanceManager = PullDownInstanceManager:new( "InstanceOne", "Button", control );
		control["InstanceManager"] = instanceManager;
	end

	local colorControl = instance["ColorPullDown"];
	local colorInstanceManager = colorControl["InstanceManager"];
	if not colorInstanceManager then
		colorInstanceManager = PullDownInstanceManager:new( "InstanceOne", "Button", colorControl );
		colorControl["InstanceManager"] = colorInstanceManager;
	end
    colorControl:SetDisabled(true);

	local controls = parameters.Controls["PlayerLeader"];
	if(controls == nil) then
		controls = {};
		parameters.Controls["PlayerLeader"] = controls;
	end

	m_currentInfo = {										
		CivilizationIcon = "ICON_CIVILIZATION_UNKNOWN",
		LeaderIcon = "ICON_LEADER_DEFAULT",
		CivilizationName = "LOC_RANDOM_CIVILIZATION",
		LeaderName = "LOC_RANDOM_LEADER"
	};

	civWarnIcon:SetHide(true);
	civIconBG:SetHide(true);

	table.insert(controls, {
		UpdateValue = function(v)
			local button = control:GetButton();

			if(v == nil) then
				button:LocalizeAndSetText("LOC_SETUP_ERROR_INVALID_OPTION");
				button:ClearCallback(Mouse.eMouseEnter);
				button:ClearCallback(Mouse.eMouseExit);
			else
				local caption = v.Name;
				if(v.Invalid) then
					local err = v.InvalidReason or "LOC_SETUP_ERROR_INVALID_OPTION";
					caption = caption .. "[NEWLINE][COLOR_RED](" .. Locale.Lookup(err) .. ")[ENDCOLOR]";
				end

				if(scrollText ~= nil) then
					scrollText:SetText(caption);
				else
					button:SetText(caption);
				end
				
				local icons = GetPlayerIcons(v.Domain, v.Value);
				local playerColor = icons.PlayerColor or "";
				if(leaderIcon) then
					leaderIcon:SetIcon(icons.LeaderIcon);
				end

				if(not tooltipControls.HasLeaderPlacard) then
					-- Upvalues
					local info;
					local domain = v.Domain;
					local value = v.Value;
					button:RegisterCallback( Mouse.eMouseEnter, function() 
						if(info == nil) then info = GetPlayerInfo(domain, value, playerId); end
						DisplayCivLeaderToolTip(info, tooltipControls, false); 
					end);
					
					button:RegisterCallback( Mouse.eMouseExit, function() 
						if(info == nil) then info = GetPlayerInfo(domain, value, playerId); end
						DisplayCivLeaderToolTip(info, tooltipControls, true); 
					end);
				end

				local primaryColor, secondaryColor = UI.GetPlayerColorValues(playerColor, 0);
				if v.Value == "RANDOM" or v.Value == "RANDOM_POOL1" or v.Value == "RANDOM_POOL2" or primaryColor == nil then
					civIconBG:SetHide(true);
					civIcon:SetHide(true);
					civWarnIcon:SetHide(true);
                    colorControl:SetDisabled(true);
				else

					local colorCount = 0;
					for j=0, 3, 1 do
						local backColor, frontColor = UI.GetPlayerColorValues(playerColor, j);
						if(backColor and frontColor and backColor ~= 0 and frontColor ~= 0) then
							colorCount = colorCount + 1;
						end
					end

					local notExternalEnabled = not CheckExternalEnabled(playerId, true, true, nil);
					colorControl:SetDisabled(notExternalEnabled or colorCount == 0 or colorCount == 1);

                    -- also update collision check color
                    -- Color collision checking.
					local myTeam = m_teamColors[playerId];
					local bShowWarning = false;
					for k , v in pairs(m_teamColors) do
						if(k ~= playerId) then
							if( myTeam and v and myTeam[1] == v[1] and myTeam[2] == v[2] ) then
								bShowWarning = true;
							end
						end
					end
					civWarnIcon:SetHide(not bShowWarning);
    				if bShowWarning == true then
    					civWarnIcon:LocalizeAndSetToolTip("LOC_SETUP_PLAYER_COLOR_COLLISION");
    				else
    					civWarnIcon:SetToolTipString(nil);
    				end	
                end
			end		
		end,
		UpdateValues = function(values)
			instanceManager:ResetInstances();
            local iIteratedPlayerID = 0;

			-- Avoid creating call back for each value.
			local hasPlacard = tooltipControls.HasLeaderPlacard;
			local OnMouseExit = function()
				DisplayCivLeaderToolTip(m_currentInfo, tooltipControls, not hasPlacard);
			end;

			for i,v in ipairs(values) do
				local icons = GetPlayerIcons(v.Domain, v.Value);
				local playerColor = icons.PlayerColor;

				local entry = instanceManager:GetInstance();
				
				local caption = v.Name;
				if(v.Invalid) then 
					local err = v.InvalidReason or "LOC_SETUP_ERROR_INVALID_OPTION";
					caption = caption .. "[NEWLINE][COLOR_RED](" .. Locale.Lookup(err) .. ")[ENDCOLOR]";
				end

				if(entry.ScrollText ~= nil) then
					entry.ScrollText:SetText(caption);
				else
					entry.Button:SetText(caption);
				end
				entry.LeaderIcon:SetIcon(icons.LeaderIcon);
				
				-- Upvalues
				local info;
				local domain = v.Domain;
				local value = v.Value;
				
				entry.Button:RegisterCallback( Mouse.eMouseEnter, function() 
					if(info == nil) then info = GetPlayerInfo(domain, value, playerId); end
					DisplayCivLeaderToolTip(info, tooltipControls, false);
				 end);

				entry.Button:RegisterCallback( Mouse.eMouseExit,OnMouseExit);
				entry.Button:SetToolTipString(nil);			

				entry.Button:RegisterCallback(Mouse.eLClick, function()
					if(info == nil) then info = GetPlayerInfo(domain, value); end

					--  if the user picked random, hide the civ icon again
					local primaryColor, secondaryColor = UI.GetPlayerColorValues(playerColor, 0);
					 m_teamColors[playerId] = {primaryColor, secondaryColor};

                    -- set default alternate color to the primary
					local colorParameter = parameters.Parameters["PlayerColorAlternate"]; 
					parameters:SetParameterValue(colorParameter, 0);

                    -- set the team
                    local leaderParameter = parameters.Parameters["PlayerLeader"];
					parameters:SetParameterValue(leaderParameter, v);

					if(playerId == 0) then
						m_currentInfo = info;
					end
				end);
			end
			control:CalculateInternals();
		end,
		SetEnabled = function(enabled, parameter)
			local notExternalEnabled = not CheckExternalEnabled(playerId, enabled, true, parameter);
			local singleOrEmpty = #parameter.Values <= 1;

            control:SetDisabled(notExternalEnabled or singleOrEmpty);
		end,
	--	SetVisible = function(visible)
	--		control:SetHide(not visible);
	--	end
	});
end

-- ===========================================================================
function OnGameSetupTabClicked()
	UIManager:DequeuePopup( ContextPtr );
end

-- ===========================================================================

function RealizeShellTabs()
	m_shellTabIM:ResetInstances();

	local gameSetup:table = m_shellTabIM:GetInstance();
	gameSetup.Button:SetText(LOC_GAME_SETUP);
	gameSetup.SelectedButton:SetText(LOC_GAME_SETUP);
	gameSetup.Selected:SetHide(true);
	gameSetup.Button:RegisterCallback( Mouse.eLClick, OnGameSetupTabClicked );

	AutoSizeGridButton(gameSetup.Button,250,32,10,"H");
	AutoSizeGridButton(gameSetup.SelectedButton,250,32,20,"H");
	gameSetup.TopControl:SetSizeX(gameSetup.Button:GetSizeX());

	local stagingRoom:table = m_shellTabIM:GetInstance();
	stagingRoom.Button:SetText(LOC_STAGING_ROOM);
	stagingRoom.SelectedButton:SetText(LOC_STAGING_ROOM);
	stagingRoom.Button:SetDisabled(not Network.IsInSession());
	stagingRoom.Selected:SetHide(false);

	AutoSizeGridButton(stagingRoom.Button,250,32,20,"H");
	AutoSizeGridButton(stagingRoom.SelectedButton,250,32,20,"H");
	stagingRoom.TopControl:SetSizeX(stagingRoom.Button:GetSizeX());
	
	Controls.ShellTabs:CalculateSize();
end

-- ===========================================================================
function OnGameSummaryTabClicked()
	-- TODO
end

function OnFriendsTabClicked()
	-- TODO
end

-- ===========================================================================
function BuildGameSetupParameter(o, parameter)

	local parent = GetControlStack(parameter.GroupId);
	local control;
	
	-- If there is no parent, don't visualize the control.  This is most likely a player parameter.
	if(parent == nil or not parameter.Visible) then
		return;
	end;

	
	local c = m_gameSetupParameterIM:GetInstance();		
	c.Root:ChangeParent(parent);

	-- Store the root control, NOT the instance table.
	g_SortingMap[tostring(c.Root)] = parameter;		
			
	c.Label:SetText(parameter.Name);
	c.Value:SetText(parameter.DefaultValue);
	c.Root:SetToolTipString(parameter.Description);

	control = {
		Control = c,
		UpdateValue = function(value, p)
			local t:string = type(value);
			if(p.Array) then
				local valueText;

				if (parameter.UxHint ~= nil and parameter.UxHint == "InvertSelection") then
					valueText = Locale.Lookup("LOC_SELECTION_EVERYTHING");
				else
					valueText = Locale.Lookup("LOC_SELECTION_NOTHING");
				end

				if(t == "table") then
					local count = #value;
					if (parameter.UxHint ~= nil and parameter.UxHint == "InvertSelection") then
						if(count == 0) then
							valueText = Locale.Lookup("LOC_SELECTION_EVERYTHING");
						elseif(count == #p.Values) then
							valueText = Locale.Lookup("LOC_SELECTION_NOTHING");
						else
							valueText = Locale.Lookup("LOC_SELECTION_CUSTOM", #p.Values-count);
						end
					else
						if(count == 0) then
							valueText = Locale.Lookup("LOC_SELECTION_NOTHING");
						elseif(count == #p.Values) then
							valueText = Locale.Lookup("LOC_SELECTION_EVERYTHING");
						else
							valueText = Locale.Lookup("LOC_SELECTION_CUSTOM", count);
						end
					end
				end
				c.Value:SetText(valueText);
				c.Value:SetToolTipString(parameter.Description);
			else
				if t == "table" then
					c.Value:SetText(value.Name);
				elseif t == "boolean" then
					c.Value:SetText(Locale.Lookup(value and "LOC_MULTIPLAYER_TRUE" or "LOC_MULTIPLAYER_FALSE"));
				else
					c.Value:SetText(tostring(value));
				end
			end			
		end,
		SetVisible = function(visible)
			c.Root:SetHide(not visible);
		end,
		Destroy = function()
			g_StringParameterManager:ReleaseInstance(c);
		end,
	};

	o.Controls[parameter.ParameterId] = control;
end

function RealizeGameSetup()
	BuildGameState();

	m_gameSetupParameterIM:ResetInstances();
	BuildGameSetup(BuildGameSetupParameter);

	BuildAdditionalContent();
	UpdateAllMods()
end


-- ===========================================================================
--	Can join codes be used in the current lobby system?
-- ===========================================================================
function ShowJoinCode()
	local pbcMode			:boolean = GameConfiguration.IsPlayByCloud() and (GameConfiguration.GetGameState() == GameStateTypes.GAMESTATE_LOAD_PREGAME or GameConfiguration.GetGameState() == GameStateTypes.GAMESTATE_PREGAME);
	local crossPlayMode		:boolean = (Network.GetTransportType() == TransportType.TRANSPORT_EOS);
	local eosAllowed		:boolean = (Network.GetNetworkPlatform() == NetworkPlatform.NETWORK_PLATFORM_EOS) and GameConfiguration.IsInternetMultiplayer();
	return pbcMode or crossPlayMode or eosAllowed;
end

-- ===========================================================================
function BuildGameState()
	-- Indicate that this game is for loading a save or already in progress.
	local gameState = GameConfiguration.GetGameState();
	if(gameState ~= GameStateTypes.GAMESTATE_PREGAME) then
		local gameModeStr : string;

		if(gameState == GameStateTypes.GAMESTATE_LOAD_PREGAME) then
			-- in the pregame for loading a save
			gameModeStr = loadingSaveGameStr;
		else
			-- standard game in progress
			gameModeStr = gameInProgressGameStr;
		end
		Controls.GameStateText:SetHide(false);
		Controls.GameStateText:SetText(gameModeStr);
	else
		Controls.GameStateText:SetHide(true);
	end

	-- A 'join code' is a short string that can be sent through the MP system
	-- to allow other players to connect to the same session of the game.
	-- Originally only for PBC but added to support other MP game types.
	local joinCode :string = Network.GetJoinCode();
	Controls.JoinCodeRoot:SetHide( ShowJoinCode()==false );
	if joinCode ~= nil and joinCode ~= "" then
		Controls.JoinCodeText:SetText(joinCode);
	else
		Controls.JoinCodeText:SetText("---");			-- Better than showing nothing?
	end

	Controls.AdditionalContentStack:CalculateSize();
	Controls.ParametersScrollPanel:CalculateSize();
end

-- ===========================================================================
function BuildAdditionalContent()
	m_modsIM:ResetInstances();

	local enabledMods = GameConfiguration.GetEnabledMods();
	for _, curMod in ipairs(enabledMods) do
		local modControl = m_modsIM:GetInstance();
		local modTitleStr : string = curMod.Title;

		-- Color unofficial mods to call them out.
		if(not curMod.Official) then
			modTitleStr = ColorString_ModGreen .. modTitleStr .. "[ENDCOLOR]";
		end
		modControl.ModTitle:SetText(modTitleStr);
	end

	Controls.AdditionalContentStack:CalculateSize();
	Controls.ParametersScrollPanel:CalculateSize();
end

-- ===========================================================================
function RealizeInfoTabs()
	m_infoTabsIM:ResetInstances();
	local friends:table;
	local gameSummary:table

	gameSummary = m_infoTabsIM:GetInstance();
	gameSummary.Button:SetText(LOC_GAME_SUMMARY);
	gameSummary.SelectedButton:SetText(LOC_GAME_SUMMARY);
	gameSummary.Selected:SetHide(not g_viewingGameSummary);

	gameSummary.Button:RegisterCallback(Mouse.eLClick, function()
		g_viewingGameSummary = true;
		Controls.Friends:SetHide(true);
		friends.Selected:SetHide(true);
		gameSummary.Selected:SetHide(false);
		Controls.ParametersScrollPanel:SetHide(false);
	end);

	AutoSizeGridButton(gameSummary.Button,200,32,10,"H");
	AutoSizeGridButton(gameSummary.SelectedButton,200,32,20,"H");
	gameSummary.TopControl:SetSizeX(gameSummary.Button:GetSizeX());

	if not GameConfiguration.IsHotseat() then
		friends = m_infoTabsIM:GetInstance();
		friends.Button:SetText(LOC_FRIENDS);
		friends.SelectedButton:SetText(LOC_FRIENDS);
		friends.Selected:SetHide(g_viewingGameSummary);
		friends.Button:SetDisabled(not Network.IsInSession());
		friends.Button:RegisterCallback( Mouse.eLClick, function()
			g_viewingGameSummary = false;
			Controls.Friends:SetHide(false);
			friends.Selected:SetHide(false);
			gameSummary.Selected:SetHide(true);
			Controls.ParametersScrollPanel:SetHide(true);
			UpdateFriendsList();
		end );

		AutoSizeGridButton(friends.Button,200,32,20,"H");
		AutoSizeGridButton(friends.SelectedButton,200,32,20,"H");
		friends.TopControl:SetSizeX(friends.Button:GetSizeX());
	end

	Controls.InfoTabs:CalculateSize();
end

-------------------------------------------------
function UpdateFriendsList()

	if ContextPtr:IsHidden() or GameConfiguration.IsHotseat() then
		Controls.InfoContainer:SetHide(true);
		return;
	end

	m_friendsIM:ResetInstances();
	Controls.InfoContainer:SetHide(false);
	local friends:table = GetFriendsList();
	local bCanInvite:boolean = CanInviteFriends(false) and Network.HasSingleFriendInvite();

	-- DEBUG
	--for i = 1, 19 do
	-- /DEBUG
	for _, friend in pairs(friends) do
		local instance:table = m_friendsIM:GetInstance();

		-- Build the dropdown for the friend list
		local friendActions:table = {};
		BuildFriendActionList(friendActions, bCanInvite and not IsFriendInGame(friend));

		-- end build
		local friendPlayingCiv:boolean = friend.PlayingCiv; -- cache value to ensure it's available in callback function

		PopulateFriendsInstance(instance, friend, friendActions, 
			function(friendID, actionType) 
				if actionType == "invite" then
					local statusText:string = friendPlayingCiv and "LOC_PRESENCE_INVITED_ONLINE" or "LOC_PRESENCE_INVITED_OFFLINE";
					instance.PlayerStatus:LocalizeAndSetText(statusText);
				end
			end
		);

	end
	-- DEBUG
	--end
	-- /DEBUG

	Controls.FriendsStack:CalculateSize();
	Controls.FriendsScrollPanel:CalculateSize();
	Controls.FriendsScrollPanel:GetScrollBar():SetAndCall(0);

	if Controls.FriendsScrollPanel:GetScrollBar():IsHidden() then
		Controls.FriendsScrollPanel:SetOffsetX(8);
	else
		Controls.FriendsScrollPanel:SetOffsetX(3);
	end

	if table.count(friends) == 0 then
		Controls.InviteButton:SetAnchor("C,C");
		Controls.InviteButton:SetOffsetY(0);
	else
		Controls.InviteButton:SetAnchor("C,B");
		Controls.InviteButton:SetOffsetY(27);
	end
end

function IsFriendInGame(friend:table)
	local player_ids = GameConfiguration.GetParticipatingPlayerIDs();
	for i, iPlayer in ipairs(player_ids) do	
		local curPlayerConfig = PlayerConfigurations[iPlayer];
		local steamID = curPlayerConfig:GetNetworkIdentifer();
		if( steamID ~= nil and steamID == friend.ID and Network.IsPlayerConnected(iPlayer) ) then
			return true;
		end
	end
	return fasle;
end

-------------------------------------------------
function SetupGridLines(numPlayers:number)
	g_GridLinesIM:ResetInstances();
	RealizeGridSize();
	local nextY:number = GRID_LINE_HEIGHT;
	local gridSize:number = Controls.GridContainer:GetSizeY();
	local numLines:number = math.max(numPlayers, gridSize / GRID_LINE_HEIGHT);
	for i:number = 1, numLines do
		g_GridLinesIM:GetInstance().Control:SetOffsetY(nextY);
		nextY = nextY + GRID_LINE_HEIGHT;
	end
end

-------------------------------------------------
-------------------------------------------------
function OnInit(isReload:boolean)
	if isReload then
		LuaEvents.GameDebug_GetValues( "StagingRoom" );
	end
end

function OnShutdown()
	-- Cache values for hotloading...
	LuaEvents.GameDebug_AddValue("StagingRoom", "isHidden", ContextPtr:IsHidden());
end

function OnGameDebugReturn( context:string, contextTable:table )
	if context == "StagingRoom" and contextTable["isHidden"] == false then
		if ContextPtr:IsHidden() then
			ContextPtr:SetHide(false);
		else
			OnShow();
		end
	end	
end

-- ===========================================================================
--	LUA Event
--	Show the screen
-- ===========================================================================
function OnRaise(resetChat:boolean)
	-- Make sure HostGame screen is on the stack
	LuaEvents.StagingRoom_EnsureHostGame();

	UIManager:QueuePopup( ContextPtr, PopupPriority.Current );
end

-- ===========================================================================
function Resize()
	local screenX, screenY:number = UIManager:GetScreenSizeVal();
	Controls.MainWindow:SetSizeY(screenY-( Controls.LogoContainer:GetSizeY()-Controls.LogoContainer:GetOffsetY() ));
	local window = Controls.MainWindow:GetSizeY() - Controls.TopPanel:GetSizeY();
	Controls.ChatContainer:SetSizeY(window/2 -80)
	Controls.PrimaryStackGrid:SetSizeY(window-Controls.ChatContainer:GetSizeY() -75 )
	Controls.InfoContainer:SetSizeY(window/2 -80)
	Controls.PrimaryPanelStack:CalculateSize()
	RealizeGridSize();
end

-- ===========================================================================
function OnUpdateUI( type:number, tag:string, iData1:number, iData2:number, strData1:string )   
  if type == SystemUpdateUI.ScreenResize then
	Resize();
  end
end

-- ===========================================================================
function StartExitGame()
	if(GetReadyCountdownType() == CountdownTypes.Ready_PlayByCloud) then
		-- If we are using the PlayByCloud ready countdown, the local player needs to be set to ready before they can leave.
		-- If we are not ready, we set ready and wait for that change to propagate to the backend.
		local localPlayerID :number = Network.GetLocalPlayerID();
		local localPlayerConfig :table = PlayerConfigurations[localPlayerID];
		if(localPlayerConfig:GetReady() == false) then
			m_exitReadyWait = true;
			SetLocalReady(true);

			-- Next step will be in OnUploadCloudPlayerConfigComplete.
			return;
		end
	end

	Close();
end

-- ===========================================================================
function OnEndGame_Start()
	Network.CloudKillGame();

	-- Show killing game popup
	m_kPopupDialog:Close(); -- clear out the popup incase it is already open.
	m_kPopupDialog:AddTitle(  Locale.ToUpper(Locale.Lookup("LOC_MULTIPLAYER_ENDING_GAME_TITLE")));
	m_kPopupDialog:AddText(	  Locale.Lookup("LOC_MULTIPLAYER_ENDING_GAME_PROMPT"));
	m_kPopupDialog:Open();

	-- Next step is in OnCloudGameKilled.
end

function OnQuitGame_Start()
	Network.CloudQuitGame();

	-- Show killing game popup
	m_kPopupDialog:Close(); -- clear out the popup incase it is already open.
	m_kPopupDialog:AddTitle(  Locale.ToUpper(Locale.Lookup("LOC_MULTIPLAYER_QUITING_GAME_TITLE")));
	m_kPopupDialog:AddText(	  Locale.Lookup("LOC_MULTIPLAYER_QUITING_GAME_PROMPT"));
	m_kPopupDialog:Open();

	-- Next step is in OnCloudGameQuit.
end

function OnExitGameAskAreYouSure()
	if(GameConfiguration.IsPlayByCloud()) then
		-- PlayByCloud immediately exits to streamline the process and avoid confusion with the popup text.
		StartExitGame();
		return;
	end

	m_kPopupDialog:Close();	-- clear out the popup incase it is already open.
	m_kPopupDialog:AddTitle(  Locale.ToUpper(Locale.Lookup("LOC_GAME_MENU_QUIT_TITLE")));
	m_kPopupDialog:AddText(	  Locale.Lookup("LOC_GAME_MENU_QUIT_WARNING"));
	m_kPopupDialog:AddButton( Locale.Lookup("LOC_COMMON_DIALOG_NO_BUTTON_CAPTION"), nil );
	m_kPopupDialog:AddButton( Locale.Lookup("LOC_COMMON_DIALOG_YES_BUTTON_CAPTION"), StartExitGame, nil, nil, "PopupButtonInstanceRed" );
	m_kPopupDialog:Open();
end

function OnEndGameAskAreYouSure()
	m_kPopupDialog:Close(); -- clear out the popup incase it is already open.
	m_kPopupDialog:AddTitle(  Locale.ToUpper(Locale.Lookup("LOC_GAME_MENU_END_GAME_TITLE")));
	m_kPopupDialog:AddText(	  Locale.Lookup("LOC_GAME_MENU_END_GAME_WARNING"));
	m_kPopupDialog:AddButton( Locale.Lookup("LOC_COMMON_DIALOG_NO_BUTTON_CAPTION"), nil );
	m_kPopupDialog:AddButton( Locale.Lookup("LOC_COMMON_DIALOG_YES_BUTTON_CAPTION"), OnEndGame_Start, nil, nil, "PopupButtonInstanceRed" );
	m_kPopupDialog:Open();
end

function OnQuitGameAskAreYouSure()
	m_kPopupDialog:Close(); -- clear out the popup incase it is already open.
	m_kPopupDialog:AddTitle(  Locale.ToUpper(Locale.Lookup("LOC_GAME_MENU_QUIT_GAME_TITLE")));
	m_kPopupDialog:AddText(	  Locale.Lookup("LOC_GAME_MENU_QUIT_GAME_WARNING"));
	m_kPopupDialog:AddButton( Locale.Lookup("LOC_COMMON_DIALOG_NO_BUTTON_CAPTION"), nil );
	m_kPopupDialog:AddButton( Locale.Lookup("LOC_COMMON_DIALOG_YES_BUTTON_CAPTION"), OnQuitGame_Start, nil, nil, "PopupButtonInstanceRed" );
	m_kPopupDialog:Open();
end


-- ===========================================================================
function GetInviteTT()
	if( Network.GetNetworkPlatform() == NetworkPlatform.NETWORK_PLATFORM_EOS ) then
		return Locale.Lookup("LOC_EPIC_INVITE_BUTTON_TT");
	end

	return Locale.Lookup("LOC_INVITE_BUTTON_TT");
end
-- =====================================================================
-- 输出玩家信息到剪贴板
-- =====================================================================
function OnOutputButton()
	local TextCopy = Locale.Lookup("{1_Time : datetime full}", os.time()).."\n";
	TextCopy = TextCopy..TPT_OUTPUT_HEEDER_str.."\n";
	local player_ids = GameConfiguration.GetMultiplayerPlayerIDs();
	for _, iPlayerID in ipairs(player_ids) do
		local playerEntry = g_PlayerEntries[iPlayerID];
		local playerNetworkID = PlayerConfigurations[iPlayerID]:GetNetworkIdentifer();
		local pPlayerConfig = PlayerConfigurations[iPlayerID];
		local playerName = Locale.Lookup(pPlayerConfig:GetPlayerName());
		if(pPlayerConfig:IsHuman()) then
			TextCopy = TextCopy.."\n"..playerName.."\t"..playerNetworkID;
			if(string.len(playerNetworkID) == 17 or string.len(playerNetworkID) == 32) then
				playerEntry.StatusLabel:SetText( TPT_OUTPUT_SUCCESS_NAME_str );
				playerEntry.StatusLabel:SetToolTipString( TPT_OUTPUT_SUCCESS_TT_str..playerNetworkID )
			else
				playerEntry.StatusLabel:SetText( TPT_OUTPUT_ERROR_NAME_str );
				playerEntry.StatusLabel:SetToolTipString( TPT_OUTPUT_ERROR_TT_str )
			end
		end
	end
	
	UIManager:SetClipboardString(TextCopy)		-- 复制到剪贴板(长度无限)
--	print("	-------------------------------成功粘贴到剪贴板-------------------------------")
--	print(TextCopy)
--	print("	----------------------------------------------------------------------------")
end
--[[
Network.GetTransportType()
跨平台 4
互联网 2
局域网 1
热坐模式 0
云端游戏 0
]]
function ShowHideTPTButtons()
	Controls.OutputButton:SetHide(Network.GetTransportType() == 0)
	Controls.CloseAIButton:SetHide(Network.GetTransportType() == 0) -- 对热坐模式和云端模式隐藏
end
-- =====================================================================
-- 添加黑名单玩家界面
-- =====================================================================
function OnOutputButtonCheck()		--检测玩家
    UI.PlaySound("Play_UI_Click");
    
	Controls.DescInputEditBox:SetText("");
	Controls.SteamIDInputEditBox:SetText("");

	Controls.CreateModGroupButton:SetDisabled(true);

	Controls.NameModGroupPopup:SetHide(false);
	Controls.NameModGroupPopupAlpha:SetToBeginning();
	Controls.NameModGroupPopupAlpha:Play();
	Controls.NameModGroupPopupSlide:SetToBeginning();
	Controls.NameModGroupPopupSlide:Play();
	
	Controls.SteamIDInputEditBox:TakeFocus();	
end
-- =====================================================================
-- 申请玩家标记页面
-- =====================================================================
function OnOutputButtonPlayerRequest()		-- 申请玩家标记
    UI.PlaySound("Play_UI_Click");
	local playerNetworkID = PlayerConfigurations[Network.GetLocalPlayerID()]:GetNetworkIdentifer();
	    
	Controls.PlayerRequestConfirmButton:SetDisabled(true);

	Controls.PlayerRequestDescInputEditBox:SetText("");    
	Controls.PlayerRequestNameInputEditBox:SetText("");
	Controls.PlayerRequestSteamIDInputEditBox:SetText(playerNetworkID);

	Controls.PlayerRequestPopup:SetHide(false);
	Controls.PlayerRequestPopupAlpha:SetToBeginning();
	Controls.PlayerRequestPopupAlpha:Play();
	Controls.PlayerRequestPopupSlide:SetToBeginning();
	Controls.PlayerRequestPopupSlide:Play();
	
	Controls.PlayerRequestSteamIDInputEditBox:TakeFocus();	
end
-- =====================================================================
-- 拆分字符串成表
-- =====================================================================
function split(str,reps)
    local resultStrList = {}
    string.gsub(str,'[^'..reps..']+',function (w)
        table.insert(resultStrList,w)
    end)
    return resultStrList
end
-- =====================================================================
-- 关闭所有电脑和空位
-- =====================================================================
function OnCloseAIButtonL()
	if Network.GetLocalPlayerID() ~= Network.GetGameHostPlayerID() then
		return
	end
	local player_ids = GameConfiguration.GetMultiplayerPlayerIDs();
	for _, iPlayerID in ipairs(player_ids) do
		local pPlayerConfig = PlayerConfigurations[iPlayerID];
		if not pPlayerConfig:IsHuman() then
			pPlayerConfig:SetSlotStatus(SlotStatus.SS_CLOSED);
			Network.BroadcastPlayerInfo(iPlayerID)
		end
	end
	Controls.PlayerListStack:CalculateSize();
	Controls.PlayersScrollPanel:CalculateSize();
end
-- =====================================================================
-- 打开空位
-- =====================================================================
function OnCloseAIButtonR()
    UI.PlaySound("Play_UI_Click");
	if Network.GetLocalPlayerID() ~= Network.GetGameHostPlayerID() then
		return
	end
	for iPlayerID = 0, 17 do
		local pPlayerConfig = PlayerConfigurations[iPlayerID];
		if not pPlayerConfig:IsHuman() then
			m_iFirstClosedSlot = -1;
			pPlayerConfig:SetSlotStatus(SlotStatus.SS_OPEN);
			Network.BroadcastPlayerInfo(iPlayerID); -- Network the slot status change.
		end
	end
	Controls.PlayerListStack:SortChildren(SortPlayerListStack);
	UpdateAllPlayerEntries();

	CheckTeamsValid();
	CheckGameAutoStart();

	Controls.PlayerListStack:CalculateSize();
	Controls.PlayersScrollPanel:CalculateSize();
	Resize();
end
-- =====================================================================
-- 玩家计数显示
-- =====================================================================
function OnAmountChanged()
	local Amount = 0
	local player_ids = GameConfiguration.GetMultiplayerPlayerIDs();
	for _, iPlayerID in ipairs(player_ids) do
		local pPlayerConfig = PlayerConfigurations[iPlayerID];
		if pPlayerConfig:IsHuman() then
			Amount = Amount + 1
		end
	end
	local AmountText = "[icon_Global] "..Amount;
	Controls.Amount:LocalizeAndSetText(AmountText);
end
-- =====================================================================
-- 打开网页链接
-- 使用说明书
-- =====================================================================
function OnTeamPVPHelpButton()
	local url = TPT_URL_INSTRUCTIONS_str;
	Steam.ActivateGameOverlayToUrl(url)
end
-- =====================================================================
-- 检查并为该玩家添加标记
-- =====================================================================
function OnCheckPlayerData(playerID)
	if playerID then		-- 有id输入
		local playerEntry = g_PlayerEntries[playerID];
		playerEntry.StatusLabel:SetToolTipType(nil)
		if playerEntry.StatusLabel:GetText() ~= NotReadyStatusStr and playerEntry.StatusLabel:GetText() ~= ReadyStatusStr and playerEntry.StatusLabel:GetText() ~= Locale.Lookup( "LOC_MP_PLAYER_CONNECTED_SUMMARY" ) then		-- 只有在就绪和未就绪时，替换文本
			return
		end
		local pPlayerConfig = PlayerConfigurations[playerID];
		if( pPlayerConfig:IsHuman() ) then		-- 判断人类
			local playerNetworkID = pPlayerConfig:GetNetworkIdentifer();		-- 获取steamID
			if(string.len(playerNetworkID) ~= 17 and string.len(playerNetworkID) ~= 32) then		-- 无法获取ID时
				playerEntry.StatusLabel:SetText( TPT_CHECK_ERROR_NAME_str );
				playerEntry.StatusLabel:SetToolTipString( TPT_OUTPUT_ERROR_TT_str )
				return
			end	
			for i,kData in ipairs(g_TPT_PlayerDatas) do
				if playerNetworkID == kData.SteamID then		-- SteamID匹配
					local kPlayerIsHidden = PlayerConfigurations[playerID]:GetValue("HiddenPkayerInfo") == "T" and true or false
					if ((kData.Type == "Admin" or kData.Type == "Normal" or kData.Type == "Honor") and kPlayerIsHidden) or not (kData.Type == "Admin" or kData.Type == "Normal" or kData.Type == "Honor") then
						SetStatusLabelbySteamID(kData,playerEntry)
					end
					break
				end
			end
		end
	end
end
-- =====================================================================
-- 将字符串转化为时间戳
-- =====================================================================
function str2time(timeStr)
    local Y = string.sub(timeStr,1,4)
    local M = string.sub(timeStr,6,7)
    local D = string.sub(timeStr,9,10)
    return os.time({year=Y,month=M,day=D,hour=0,min=0,sec=0})
end
-- =====================================================================
-- 是否允许显示？
-- 根据起始时间判断
-- =====================================================================
function DateAllow(kData)
	if not kData then
		return false
	end
	
	local Allow = true
	
	if kData.Start_Date and kData.Start_Date ~= "" then
		if str2time(kData.Start_Date) > os.time() then
			Allow = false
		end
	end
	if kData.End_Date and kData.End_Date ~= "" then
		if str2time(kData.End_Date) < os.time() then
			Allow = false
		end
	end
	return Allow
end
-- =====================================================================
-- 设置玩家标记的显示
-- =====================================================================
function SetStatusLabelbySteamID(kData,playerEntry)
	if DateAllow( kData ) then
		if kData.Icon and kData.Icon ~= "" then
			playerEntry.StatusLabel:SetText( kData.Icon )
		end
		if kData.ToolTipType and kData.ToolTipType ~= "" then
			playerEntry.StatusLabel:SetToolTipType(kData.ToolTipType)
		else
			if kData.Desc and kData.Desc ~= "" then
				playerEntry.StatusLabel:SetToolTipString( kData.Desc )
			end
		end
	end
end
-- =====================================================================
-- 刷新玩家标记的数据
-- =====================================================================
function RefreshPlayerData()
	g_TPT_PlayerDatas = {};		-- 清空
	local PlayerDatas = DB.ConfigurationQuery("SELECT * FROM TPT_PlayerData");

	if PlayerDatas then
		for i,kData in ipairs(PlayerDatas) do
			table.insert(g_TPT_PlayerDatas, kData)
		end
	elseif GameInfo.TPT_PlayerData then
		for kData in GameInfo.TPT_PlayerData() do
			table.insert(g_TPT_PlayerDatas, kData)
		end
	end
	local t = Read_tableString("TPTplayerData")
	for i, v in pairs(t) do
		local data :table = {
			SteamID = v.SteamID,
			Name = "",
			Icon = "[Icon_Exclamation]不良记录",
			Desc = v.Desc,
			Start_Date = "",
			End_Date = "",
		};
		for i,kData in ipairs(g_TPT_PlayerDatas) do		-- 排除重复的
			if kData.SteamID == data.SteamID then
				table.remove(g_TPT_PlayerDatas,i)
				break
			end
		end
		table.insert(g_TPT_PlayerDatas, data)
	end
end
-- =====================================================================
-- 分段储存数据到"组名"
-- =====================================================================
function StorageData( isteamID	,	idesc	,	itype	)
	local HasStorage = Read_tableString("TPTplayerData")
	local NewData :table = {
		SteamID = isteamID,
		Desc = idesc
	};
	for i,kData in ipairs(HasStorage) do
		if kData.SteamID == isteamID then
			table.remove(HasStorage,i)		-- 排除重复的
			break
		end
	end
	table.insert(HasStorage, NewData)		-- 存入表
	Storage_table(HasStorage, "TPTplayerData")
	RefreshPlayerData()
end
-- =====================================================================
-- 本地记录的所有steamID
-- =====================================================================
function GetLocalSteamIDsData()
	local g_localSteamIDs = {}
	local t = Read_tableString("TPTplayerData")
	for i, v in pairs(t) do
		table.insert(g_localSteamIDs, v.SteamID)
	end
	return g_localSteamIDs
end
-- =====================================================================
-- 移除标记的黑名单玩家
-- =====================================================================
function RemoveDataSteamID(RemoveID)
	local HasStorage = Read_tableString("TPTplayerData")
	for i,kData in ipairs(HasStorage) do
		if kData.SteamID == RemoveID then
			table.remove(HasStorage,i)		-- 排除重复的
			break
		end
	end
	Storage_table(HasStorage, "TPTplayerData")
	RefreshPlayerData()
end

function SetUp_TPT_Buttons()
	Controls.CloseAIButton:SetDisabled(not Network.IsGameHost())
end
-- =====================================================================
-- 随机分队
-- 生成平衡的楼层分组
-- =====================================================================
function TPT_GetRandonTeam(PlayerIDs)
--	print("#PlayerIDs=", #PlayerIDs)
	local Base = {}
	local PlayerNum = #PlayerIDs
	
	for i, v in ipairs(PlayerIDs) do
		Base[i] = v
	end
	local RandonTeam = {}
    for _, v in ipairs(Base) do
        RandonTeam[v] = false
    end
    
    if PlayerNum <= 1 then
		return RandonTeam
    end
    
    local HalfFloor = PlayerNum / 2;
	local count = math.ceil( HalfFloor )
	
	for i = 1,count do
		local num = math.random(1, #Base)
		local playerID = table.remove(Base, num)
        RandonTeam[playerID] = true
	end
	
	local FloorA = 0
	local FloorB = 0
	for i, v in pairs(PlayerIDs) do
		if RandonTeam[v] then
			FloorA = FloorA + (i + HalfFloor) ^ -1
		else
			FloorB = FloorB + (i + HalfFloor) ^ -1
		end
	end
	local Ratio = math.max(FloorA, FloorB) / math.min(FloorA, FloorB);
	
	local iBaseRatio = g_TeamBaseRatio[PlayerNum] + (g_TeamBaseRatio[PlayerNum] - 1) * 0.1		-- 允许差距 10% ？
	
	if Ratio > iBaseRatio then		-- 随便写的权衡公式
		return TPT_GetRandonTeam(PlayerIDs)
	end
	return RandonTeam
end
-- =====================================================================
-- 生成基础评分
-- 按照121212分队时，作为基础分队标准
-- =====================================================================
function GetBaseRatio(playerNum)
	local TeamA = 0
	local TeamB = 0
	local IsA = true
	for i = 1, playerNum do
		if IsA then
			TeamA = TeamA + (i + playerNum / 2) ^ -1
		else
			TeamB = TeamB + (i + playerNum / 2) ^ -1
		end
		IsA = not IsA
	end
	return math.max(TeamA, TeamB) / math.min(TeamA, TeamB)
end

function CreatTeamBaseRatio()
	for i = 2, 64, 2 do
		g_TeamBaseRatio[i] = GetBaseRatio(i)
	end
    for i = 3, 63, 2 do
        g_TeamBaseRatio[i] = (g_TeamBaseRatio[i-1] + g_TeamBaseRatio[i+1]) / 2
    end
end
-- =====================================================================
-- 随机分队
-- =====================================================================
function OnRandomTeamButtonL()
	if Network.GetLocalPlayerID() ~= Network.GetGameHostPlayerID() then
		return
	end
	-- local TeamID_A = 2*math.random(1,6) - 1
	-- local TeamID_B = 2*math.random(1,5)
	local TeamID_A = 1
	local TeamID_B = 2
	local Participant_player_ids = {}
	local player_ids = GameConfiguration.GetMultiplayerPlayerIDs();
	
	for _, iPlayerID in ipairs(player_ids) do
		PlayerConfigurations[iPlayerID]:SetTeam( -1 )
		Network.BroadcastPlayerInfo(iPlayerID); 
	end	
	
	for _, iPlayerID in ipairs(player_ids) do
		if PlayerConfigurations[iPlayerID]:IsParticipant() then
			if PlayerConfigurations[iPlayerID]:GetLeaderTypeName() ~= "LEADER_SPECTATOR" then		-- 观察者无队伍
				table.insert(Participant_player_ids,iPlayerID)		-- 所有玩家ID
			end
		end
	end
	
	local RandonTeam = TPT_GetRandonTeam(Participant_player_ids)
	
	for _, iPlayerID in ipairs(Participant_player_ids) do
		PlayerConfigurations[iPlayerID]:SetTeam( RandonTeam[iPlayerID] and TeamID_A or TeamID_B )
		Network.BroadcastPlayerInfo(iPlayerID);
	end
end
-- =====================================================================
-- 顺序分队
-- =====================================================================
function OnRandomTeamButtonR()
	UI.PlaySound("Play_UI_Click");
	if Network.GetLocalPlayerID() ~= Network.GetGameHostPlayerID() then
		return
	end
	local TeamID_A = 2*math.random(1,6) - 1
	local TeamID_B = 2*math.random(1,5)
	local player_ids = GameConfiguration.GetMultiplayerPlayerIDs();
	for _, iPlayerID in ipairs(player_ids) do
		PlayerConfigurations[iPlayerID]:SetTeam( -1 )		-- 先刷新一遍，清除其他玩家状态
		Network.BroadcastPlayerInfo(iPlayerID); 
	end
	
	local TeamA = true;
	for _, iPlayerID in ipairs(player_ids) do
		if PlayerConfigurations[iPlayerID]:IsParticipant() then
			if PlayerConfigurations[iPlayerID]:GetLeaderTypeName() ~= "LEADER_SPECTATOR" then
				PlayerConfigurations[iPlayerID]:SetTeam( TeamA and TeamID_A or TeamID_B )
				TeamA = not TeamA
			end
			Network.BroadcastPlayerInfo(iPlayerID); 			
		end
	end
end
-- =====================================================================
-- 领袖使用统计数据
-- =====================================================================
function OnLeaderStatsOpen()
	Controls.LeaderStatsSlideAnim:SetHide(false)
	Controls.LeaderStatsSlideAnim:SetSpeed(1);
	Controls.LeaderStatsSlideAnim:SetToBeginning();
	Controls.LeaderStatsSlideAnim:Play();
end

function OnLeaderStatsClose()
	Controls.LeaderStatsSlideAnim:SetSpeed(3);
	Controls.LeaderStatsSlideAnim:Reverse();
end

function CreatLeaderStatsInstance()
	local t = Read_tableString("CivStats")
	if not t.Civs then return end;
	local Total = 0
	local Data = {}
	local max = 1
	for i, v in pairs(t.Civs) do
		local info_query = "SELECT * from Players where LeaderType = ?";
		local leaderType = "LEADER_" .. i
		local idata = DB.ConfigurationQuery(info_query, leaderType);
		local Loc_Name = ""
		if idata[1] then
			Loc_Name = idata[1].LeaderName;
		end
		local leadername = Locale.Lookup(Loc_Name)
--		print(Loc_Name, leadername)
		if Loc_Name and leadername ~= Loc_Name then
			if v > max then
				max = v
			end
			Total = Total + v;
			local idata = {
				Num = v,
				Leader = leadername,
				LeaderType = leaderType,
			}
			table.insert(Data, idata)
		end
	end
	table.sort(Data, function(a,b)
		return a.Num > b.Num
	end)
	for i, v in pairs(Data) do
--		print("数据：", i, v.Leader, v.Num, v.LeaderType)
		tInstance = m_LeaderStatsIM:GetInstance()
		tInstance.LeaderIcon_Label:SetText(v.Leader)
		tInstance.StatsPercent_Label:SetText(tonumber(Round(v.Num / Total, 3)*100) .. "%")
		tInstance.StatsAmountBar:SetPercent( v.Num / max )
		tInstance.StatsLeaderIcon:SetTexture(IconManager:FindIconAtlas("ICON_" .. v.LeaderType, 45));
		tInstance.BGRoot:SetToolTipString( Locale.Lookup("LOC_BSR_STATS_BUTTON_TT",v.Num) )
		tInstance.Settings_Box:RegisterCallback( Mouse.eLClick, OnClearLeaderStatsAskAreYouSure );
	end	
end

function OnClearLeaderStatsAskAreYouSure()
	m_kPopupDialog:Close(); -- clear out the popup incase it is already open.
	m_kPopupDialog:AddTitle(  Locale.ToUpper(Locale.Lookup("LOC_CLEAR_LEADER_STATS_TITLE")));
	m_kPopupDialog:AddText(	  Locale.Lookup("LOC_CLEAR_LEADER_STATS_WARNING"));
	m_kPopupDialog:AddButton( Locale.Lookup("LOC_COMMON_DIALOG_NO_BUTTON_CAPTION"), nil );
	m_kPopupDialog:AddButton( Locale.Lookup("LOC_COMMON_DIALOG_YES_BUTTON_CAPTION"), OnClearLeaderStatsData, nil, nil, "PopupButtonInstanceRed" );
	m_kPopupDialog:Open();
end

function OnClearLeaderStatsData()
	Clear_tableData("CivStats")
	CreatLeaderStatsInstance()
	Controls.LeaderStatsStack:DestroyAllChildren()
end
-- =====================================================================
-- 获取更新内容文本
-- =====================================================================
function Get_TPT_Update_Text()
	local g_TPT_Update = {};
	local LOC_Base = "LOC_TEAM_PVP_TOOLS_UPDATE_"
	for i = 1, 100 do
		local loc_UpdateStr = LOC_Base..i
		if Locale.Lookup(loc_UpdateStr) ~= loc_UpdateStr then
			table.insert(g_TPT_Update, Locale.Lookup(loc_UpdateStr))
		else
			break
		end
	end
	return g_TPT_Update
end
-- =====================================================================
-- 生成更新内容ToolTip
-- =====================================================================
function Creat_TPT_Update()
	local TPT_Update_Text = Get_TPT_Update_Text()
	
	if m_TPT_Update_TT.IM == nil then
		m_TPT_Update_TT.IM = InstanceManager:new("TPT_UpdateInstance", "BG", m_TPT_Update_TT.TPT_Update_Stack)
	end
	
	m_TPT_Update_TT.IM:ResetInstances()
	
	for i, iUpdateText in ipairs(TPT_Update_Text) do
		local tInstance = m_TPT_Update_TT.IM:GetAllocatedInstance(i)
		if not tInstance then
			tInstance = m_TPT_Update_TT.IM:GetInstance()
		end
		tInstance.SerialNumber:SetText(i)
		tInstance.UpdateText:SetText(iUpdateText)
		tInstance.BGStack:CalculateSize()
	end
end
-- =====================================================================
-- 打开自动下载的模组网页
-- =====================================================================
function OnModCheckButton()
	local EnabledMods = GameConfiguration.GetEnabledMods();
	local SubscribedMods = Modding.GetSubscriptions();
	local InstalledMods = Modding.GetInstalledMods();
	local HasUnSubscribe = false
	for _, curMod in ipairs(InstalledMods) do
		if not curMod.Official then	-- 非官方物品
			for _, InUseMod in ipairs(EnabledMods) do		
				if curMod.Id == InUseMod.Id then		-- 房间中在使用的
					local IsSubscribed = false
					for _, item in ipairs(SubscribedMods) do
						if curMod.SubscriptionId == item then		-- 排除已经订阅的物品
							IsSubscribed = true
						end
					end
					if not IsSubscribed then		-- 不在订阅物品范围内
						local url = "https://steamcommunity.com/sharedfiles/filedetails/?id=" .. tostring(curMod.SubscriptionId)
						Steam.ActivateGameOverlayToUrl(url)
						HasUnSubscribe = true
					end
				end
			end
		end
	end
	if not HasUnSubscribe then
		Network.SendChat("所有模组均已订阅", -2, Network.GetLocalPlayerID())
	end
end
-- =====================================================================
-- 检测是否有高危模组
-- =====================================================================
function ShowModCheckTip()
--	print("开始检测")
	local EnabledMods = GameConfiguration.GetEnabledMods();
	local SubscribedMods = Modding.GetSubscriptions();
	local InstalledMods = Modding.GetInstalledMods();
	for _, curMod in ipairs(InstalledMods) do
		if not curMod.Official then	-- 非官方物品
			for _, InUseMod in ipairs(EnabledMods) do
				if curMod.Id == InUseMod.Id then		-- 房间中在使用的
					local IsSubscribed = false
					for _, item in ipairs(SubscribedMods) do
						if curMod.SubscriptionId == item then		-- 排除已经订阅的物品
							IsSubscribed = true
						end
					end
					if not IsSubscribed then		-- 不在订阅物品范围内
						if curMod.SubscriptionId and curMod.SubscriptionId ~= "" then
							if tonumber(v.SubscriptionId) > 3240000000 then		-- 比较新的模组
								Controls.ModCheckTip:SetHide(false);
								Network.SendChat("有未订阅模组，可点击模组检测", -2, Network.GetLocalPlayerID())
								break
							end
						end
					end
				end
			end
		end
	end
end
-- =====================================================================
-- 无限文明配置
-- =====================================================================
function OnFreeChooseAbilityCivilizationButton_L()
	local Text = "无限文明:"
	Text = Text .. GameConfiguration.GetValue("CONFIG_INFINITE_FREE_LA") .. "-";
	Text = Text .. GameConfiguration.GetValue("CONFIG_INFINITE_FREE_LU") .. "-";
	Text = Text .. GameConfiguration.GetValue("CONFIG_INFINITE_FREE_SBF") .. "-";
	Text = Text .. GameConfiguration.GetValue("CONFIG_INFINITE_FREE_SBF_T") .. "-";
	Text = Text .. GameConfiguration.GetValue("CONFIG_INFINITE_FREE_SBR") .. "-";
	Text = Text .. GameConfiguration.GetValue("CONFIG_INFINITE_FREE_SBR_T") .. "-";
	Text = Text .. GameConfiguration.GetValue("CONFIG_INFINITE_FREE_SB_R") .. "-";
	Text = Text .. GameConfiguration.GetValue("CONFIG_INFINITE_FREE_SB_R_T") .. "-";
	Text = Text .. GameConfiguration.GetValue("CONFIG_INFINITE_FREE_SBT") .. "-";
	Text = Text .. GameConfiguration.GetValue("CONFIG_INFINITE_FREE_SBT_T") .. "-";
	Text = Text .. GameConfiguration.GetValue("CONFIG_INFINITE_FREE_UA") .. "-";
	Text = Text .. GameConfiguration.GetValue("CONFIG_INFINITE_FREE_UB") .. "-";
	Text = Text .. GameConfiguration.GetValue("CONFIG_INFINITE_FREE_UD") .. "-";
	Text = Text .. GameConfiguration.GetValue("CONFIG_INFINITE_FREE_UI") .. "-";
	Text = Text .. GameConfiguration.GetValue("CONFIG_INFINITE_FREE_UU") .. ":";
	print("测试数据：", Text)
	UIManager:SetClipboardString(Text)
	
	Storage_table(Text, "FCAC")
end

function OnFreeChooseAbilityCivilizationButton_R()
	local text = Read_tableString("FCAC")
	if text and text ~= "" then
		Network.SendChat(text, -2, -1)
	end
end

function OnFreeChooseAbilityCivilizationSetUpRaise()
	local enabledMods = GameConfiguration.GetEnabledMods();
	local CanHide = true
	for _, curMod in ipairs(enabledMods) do
		if not curMod.Official then
			if curMod.Id == "7f48c646-56e1-495c-a6b5-eb95ec24bb2b" then
				CanHide = false
				break
			end
		end
	end
	Controls.FreeChooseAbilityCivilizationButton:SetHide(CanHide)
	
	if Network.GetLocalPlayerID() == Network.GetGameHostPlayerID() then
		if CanHide then
			Events.MultiplayerChat.Remove( OnMultiplayerChat_FreeChooseAbilityCivilization );
		else
			Events.MultiplayerChat.Add( OnMultiplayerChat_FreeChooseAbilityCivilization );
		end
	end
end

function OnMultiplayerChat_FreeChooseAbilityCivilization( fromPlayer, toPlayer, text, eTargetType )
	if toPlayer ~= -1 then
		return
	end
	if (string.sub(text, 1, 13) == "无限文明:" and string.sub(text, -1) == ":") then

		local CivText = string.sub(text, 14, -2);
		local Data = split(CivText, "-")
		if Data and #Data == 15 then
			local LeaderType = PlayerConfigurations[fromPlayer]:GetLeaderTypeName() or ""
			print(string.sub(LeaderType, 1, 21))
			if string.sub(LeaderType, 1, 15) == "LEADER_INFINITE" then
				local LeaderIndex = string.sub(LeaderType, 16, 17)
				GameConfiguration.SetValue("CONFIG_INFINITE" .. LeaderIndex .. "_FREE_LA", Data[1]);
				GameConfiguration.SetValue("CONFIG_INFINITE" .. LeaderIndex .. "_FREE_LU", Data[2]);
				GameConfiguration.SetValue("CONFIG_INFINITE" .. LeaderIndex .. "_FREE_SBF", Data[3]);
				GameConfiguration.SetValue("CONFIG_INFINITE" .. LeaderIndex .. "_FREE_SBF_T", Data[4]);
				GameConfiguration.SetValue("CONFIG_INFINITE" .. LeaderIndex .. "_FREE_SBR", Data[5]);
				GameConfiguration.SetValue("CONFIG_INFINITE" .. LeaderIndex .. "_FREE_SBR_T", Data[6]);
				GameConfiguration.SetValue("CONFIG_INFINITE" .. LeaderIndex .. "_FREE_SB_R", Data[7]);
				GameConfiguration.SetValue("CONFIG_INFINITE" .. LeaderIndex .. "_FREE_SB_R_T", Data[8]);
				GameConfiguration.SetValue("CONFIG_INFINITE" .. LeaderIndex .. "_FREE_SBT", Data[9]);
				GameConfiguration.SetValue("CONFIG_INFINITE" .. LeaderIndex .. "_FREE_SBT_T", Data[10]);
				GameConfiguration.SetValue("CONFIG_INFINITE" .. LeaderIndex .. "_FREE_UA", Data[11]);
				GameConfiguration.SetValue("CONFIG_INFINITE" .. LeaderIndex .. "_FREE_UB", Data[12]);
				GameConfiguration.SetValue("CONFIG_INFINITE" .. LeaderIndex .. "_FREE_UD", Data[13]);
				GameConfiguration.SetValue("CONFIG_INFINITE" .. LeaderIndex .. "_FREE_UI", Data[14]);
				GameConfiguration.SetValue("CONFIG_INFINITE" .. LeaderIndex .. "_FREE_UU", Data[15]);
				Network.BroadcastGameConfig()
			end
		end
	end
end
-- =====================================================================
-- 改名按钮
-- =====================================================================
function OnSettingNameButton()
	Controls.ChangeNameEditBox:SetText("");
	
	Controls.ChangeNameConfirmButton:SetDisabled(true);

	Controls.ChangeNamePopup:SetHide(false);
	Controls.ChangeNamePopupAlpha:SetToBeginning();
	Controls.ChangeNamePopupAlpha:Play();
	Controls.ChangeNamePopupSlide:SetToBeginning();
	Controls.ChangeNamePopupSlide:Play();
	
	Controls.ChangeNameEditBox:TakeFocus();
end

function OnSettingName_CancelButton()
	Controls.ChangeNamePopup:SetHide(true);
end

function OnChangeName_ConfirmButton()
	local str=Controls.ChangeNameEditBox:GetText();
	LuaEvents.JoiningRoom_ShowStagingRoom.Add(function() str=nil end)
	if str ~= nil then
		Options.SetUserOption("Multiplayer", "LANPlayerName", str);
		Options.SaveOptions();
		StartExitGame();
--		local localPlayerID = Network.GetLocalPlayerID();
--		PlayerConfigurations[localPlayerID]:SetValue("NICK_NAME",str);
--		Network.BroadcastPlayerInfo(localPlayerID);

--		local function TPT_ChangeNICKName(playerID)
--			if str == nil or str == "" then
--				Events.PlayerInfoChanged.Remove(TPT_ChangeNICKName)
--				return
--			end
--			local LPlayerID = Network.GetLocalPlayerID();
--			if str ~= nil and str ~= "" then
--				if PlayerConfigurations[LPlayerID]:GetNickName() ~= str then
--					PlayerConfigurations[LPlayerID]:SetValue("NICK_NAME",str);
--					Network.BroadcastPlayerInfo(LPlayerID);
--				end
--			end
--		end
		
--		Events.PlayerInfoChanged.Add( TPT_ChangeNICKName )
	end
	Controls.ChangeNamePopup:SetHide(true);
end

function OnChangeNameEditBox()
	Controls.ChangeNameConfirmButton:SetDisabled(Controls.ChangeNameEditBox:GetText()=="")
end

local IsHiddenPlayerInfo_STR = "T"

function OnPlayerInfoChanged_HiddenPlayerInfo(PlayerID)
	local localPlayerID = Network.GetLocalPlayerID();
	if localPlayerID == PlayerID then
		local Local_IsHiddenPlayerInfo_STR = PlayerConfigurations[localPlayerID]:GetValue("HiddenPkayerInfo") == "T" and "T" or "F"
		if Local_IsHiddenPlayerInfo_STR ~= IsHiddenPlayerInfo_STR then
			PlayerConfigurations[localPlayerID]:SetValue("HiddenPkayerInfo",IsHiddenPlayerInfo_STR);
			Network.BroadcastPlayerInfo(localPlayerID);
		end
	end
end

function SetUpHiddenPlayerInfoCheck()
	IsHiddenPlayerInfo_STR = Read_tableString("Setting_HiddenPlayerInfo") == "F" and "F" or "T"
	Controls.HiddenPlayerInfoCheck:SetCheck(IsHiddenPlayerInfo_STR ~= "F")
	
	local localPlayerID = Network.GetLocalPlayerID();
	PlayerConfigurations[localPlayerID]:SetValue("HiddenPkayerInfo",IsHiddenPlayerInfo_STR);
	Network.BroadcastPlayerInfo(localPlayerID);
	
	Events.PlayerInfoChanged.Add(OnPlayerInfoChanged_HiddenPlayerInfo);
end

function OnHiddenPlayerInfoCheck()
	IsHiddenPlayerInfo_STR = IsHiddenPlayerInfo_STR == "F" and "T" or "F"
	print("Testdata",IsHiddenPlayerInfo_STR)
	Controls.HiddenPlayerInfoCheck:SetCheck(IsHiddenPlayerInfo_STR ~= "F")
	Storage_table(IsHiddenPlayerInfo_STR, "Setting_HiddenPlayerInfo")

	local localPlayerID = Network.GetLocalPlayerID();
	PlayerConfigurations[localPlayerID]:SetValue("HiddenPkayerInfo",IsHiddenPlayerInfo_STR);
	Network.BroadcastPlayerInfo(localPlayerID);
end


-- =====================================================================
-- 北方大陆宣传图
-- =====================================================================
--function OnNorthernContinentButton_L()
--	local url = "https://steamcommunity.com/sharedfiles/filedetails/?id=3270047371";
--	Steam.ActivateGameOverlayToUrl(url)
--end

--function OnRingContinentButton_L()
--	local url = "https://steamcommunity.com/sharedfiles/filedetails/?id=3288497469";
--	Steam.ActivateGameOverlayToUrl(url)
--end

--function OnFarmAndExpansionButton_L()
--	local url = "https://steamcommunity.com/workshop/filedetails/?id=3311703966";
--	Steam.ActivateGameOverlayToUrl(url)
--end

--function SetUpQQ_Lianjing()
--	Controls.QQ_LIANJING_Button:SetHide(str2time("2024-09-09") < os.time());
--end

--function SetUpQQ_QingTian()
--	Controls.QQ_QingTian_1_Button:SetHide(str2time("2024-10-01") < os.time());
--	Controls.QQ_QingTian_2_Button:SetHide(str2time("2024-10-01") < os.time());
--	Controls.QQ_QingTian_3_Button:SetHide(str2time("2024-10-01") < os.time());
--end
--[[
function SetUp_ChaoRenBei()
	Controls.ChaoRenBeiButton:SetHide(str2time("2024-12-24") < os.time());		-- 2个月
end

function OnExperimentalButton()
	local url = "https://steamcommunity.com/workshop/filedetails/?id=3354496702";
	Steam.ActivateGameOverlayToUrl(url)
end

function SetUp_ZHUQ()
	Controls.ZHUQUEButton:SetHide(str2time("2024-11-22") < os.time());		-- 7天
end

function OnZHUQUEButton()
	local url1 = "https://steamcommunity.com/workshop/filedetails/?id=3344660262";
	local url2 = "https://docs.qq.com/pdf/DQ2FNcGtQelRDWGtT";
	Steam.ActivateGameOverlayToUrl(url1)
	Steam.ActivateGameOverlayToUrl(url2)
end

function SetUpQQ_Lianjing_AD()
	Controls.LianJing_AD_Button:SetHide(str2time("2025-05-26") < os.time());
end
]]
--function OnCharlemagneButton()
--	local url = "https://steamcommunity.com/sharedfiles/filedetails/?id=3454504490";
--	Steam.ActivateGameOverlayToUrl(url)
--	Modding.UpdateSubscription(3456066520)
--end

--function OnPantheon_AD_Button()
--	local url = "https://steamcommunity.com/sharedfiles/filedetails/?id=3459461632";
--	Steam.ActivateGameOverlayToUrl(url)
--	Modding.UpdateSubscription(3465337776)
--end

--function OnFlat_Balanced_AD_Button()
--	local url = "https://steamcommunity.com/sharedfiles/filedetails/?id=3468618560";
--	Steam.ActivateGameOverlayToUrl(url)
--	Modding.UpdateSubscription(3468064947)
--end

function OnTeamPVPMap_AD_Button()
	local url = "https://steamcommunity.com/sharedfiles/filedetails/?id=3477985097";
	Steam.ActivateGameOverlayToUrl(url)
--	Modding.UpdateSubscription(3477107453)
end

function SetUpQQ_LianjingCup_AD()
	-- Controls.LianJingCup_AD_Button:SetHide(str2time("2025-06-25") < os.time());
end

function SetUpQQ_yueCup_AD()
	-- Controls.yue_AD_Button:SetHide(str2time("2025-08-23") < os.time());
end

function SetUpQQ_Lianjing_5th_AD()
	-- Controls.LianJing_5th_Button:SetHide(str2time("2025-09-29") < os.time());
end

function OnLianJing_5th_Button()
	-- local url = "https://steamcommunity.com/sharedfiles/filedetails/?id=3523409763";
	-- Steam.ActivateGameOverlayToUrl(url)
	-- Modding.UpdateSubscription(3523409763)
end
-- =====================================================================
-- 更新所有启用模组
-- =====================================================================
function UpdateAllMods()
	local enabledMods = GameConfiguration.GetEnabledMods();
	local mods = Modding.GetInstalledMods();
	for _, curMod in ipairs(enabledMods) do
		if not curMod.Official then		-- 非官方包
			for i,v in ipairs(mods) do
				if curMod.Id == v.Id then
					if v.SubscriptionId and v.SubscriptionId ~= "" then
						Modding.UpdateSubscription(v.SubscriptionId);		-- 更新
					end
					break
				end
			end
		end
	end
end

function CheakPlayerRequestInput()
	local SteamIDstr = Controls.PlayerRequestSteamIDInputEditBox:GetText();
	local Namestr = Controls.PlayerRequestNameInputEditBox:GetText();
	local Descstr = Controls.PlayerRequestDescInputEditBox:GetText();
	
	Controls.PlayerRequestConfirmButton:SetDisabled((SteamIDstr == nil or #SteamIDstr ~= 17 or not tonumber(SteamIDstr)) or not Namestr or not Descstr );	-- 必须是17位id输入
end
-- ===========================================================================
--	Initialize screen
-- ===========================================================================
function Initialize()
	m_kPopupDialog = PopupDialog:new( "StagingRoom" );
	
	SetCurrentMaxPlayers(MapConfiguration.GetMaxMajorPlayers());
	SetCurrentMinPlayers(MapConfiguration.GetMinMajorPlayers());
	Events.SystemUpdateUI.Add(OnUpdateUI);
	ContextPtr:SetInitHandler(OnInit);
	ContextPtr:SetShutdown(OnShutdown);
	ContextPtr:SetInputHandler( OnInputHandler, true );
	ContextPtr:SetShowHandler(OnShow);
	Controls.BackButton:RegisterCallback( Mouse.eLClick, OnExitGameAskAreYouSure );
	Controls.BackButton:RegisterCallback( Mouse.eMouseEnter, function() UI.PlaySound("Main_Menu_Mouse_Over"); end);
	Controls.ChatEntry:RegisterCommitCallback( SendChat );
	Controls.InviteButton:RegisterCallback( Mouse.eLClick, OnInviteButton );
	Controls.InviteButton:RegisterCallback( Mouse.eMouseEnter, function() UI.PlaySound("Main_Menu_Mouse_Over"); end);
	Controls.EndGameButton:RegisterCallback( Mouse.eLClick, OnEndGameAskAreYouSure );
	Controls.EndGameButton:RegisterCallback( Mouse.eMouseEnter, function() UI.PlaySound("Main_Menu_Mouse_Over"); end);	
	Controls.QuitGameButton:RegisterCallback( Mouse.eLClick, OnQuitGameAskAreYouSure );
	Controls.QuitGameButton:RegisterCallback( Mouse.eMouseEnter, function() UI.PlaySound("Main_Menu_Mouse_Over"); end);	
	Controls.ReadyButton:RegisterCallback( Mouse.eLClick, OnReadyButton );
	Controls.ReadyButton:RegisterCallback( Mouse.eMouseEnter, function() UI.PlaySound("Main_Menu_Mouse_Over"); end);
	Controls.ReadyCheck:RegisterCallback( Mouse.eLClick, OnReadyButton );
	Controls.ReadyCheck:RegisterCallback( Mouse.eMouseEnter, function() UI.PlaySound("Main_Menu_Mouse_Over"); end);
	Controls.JoinCodeText:RegisterCallback( Mouse.eLClick, OnClickToCopy );
--!! ---------------------------------------
	Controls.OutputButton:RegisterCallback( Mouse.eLClick, OnOutputButton );
	Controls.OutputButton:RegisterCallback( Mouse.eRClick, OnOutputButtonCheck );
	Controls.OutputButton:RegisterCallback( Mouse.eMClick, OnOutputButtonPlayerRequest );
	Controls.OutputButton:RegisterCallback( Mouse.eMouseEnter, function() UI.PlaySound("Main_Menu_Mouse_Over"); end);
	Controls.OutputButton:RegisterCallback( Mouse.eMouseExit, function() Controls.PlayerRequestTip:SetHide(true); end);	
	
	Controls.CloseAIButton:RegisterCallback( Mouse.eLClick, OnCloseAIButtonL );
	Controls.CloseAIButton:RegisterCallback( Mouse.eRClick, OnCloseAIButtonR );
	Controls.CloseAIButton:RegisterCallback( Mouse.eMouseEnter, function() UI.PlaySound("Main_Menu_Mouse_Over"); end);

	Controls.TeamPVPHelpButton:RegisterCallback( Mouse.eLClick, OnTeamPVPHelpButton );
	Controls.TeamPVPHelpButton:RegisterCallback( Mouse.eMouseEnter, function() UI.PlaySound("Main_Menu_Mouse_Over"); end);
	
	Controls.RandomTeamButton:RegisterCallback( Mouse.eLClick, OnRandomTeamButtonL );
	Controls.RandomTeamButton:RegisterCallback( Mouse.eRClick, OnRandomTeamButtonR );
	Controls.RandomTeamButton:RegisterCallback( Mouse.eMouseEnter, function() UI.PlaySound("Main_Menu_Mouse_Over"); end);
	Controls.RandomTeamButton:RegisterCallback( Mouse.eMouseExit, function() Controls.RandomTeamTip:SetHide(true); end);	

	Controls.SettingNameButton:RegisterCallback( Mouse.eLClick, OnSettingNameButton );
	Controls.SettingNameButton:RegisterCallback( Mouse.eMouseEnter, function() UI.PlaySound("Main_Menu_Mouse_Over"); end);
	Controls.ChangeNameCancelButton:RegisterCallback( Mouse.eLClick, OnSettingName_CancelButton );
	Controls.ChangeNameConfirmButton:RegisterCallback( Mouse.eLClick, OnChangeName_ConfirmButton );
	Controls.ChangeNameEditBox:RegisterStringChangedCallback( OnChangeNameEditBox )
	Controls.HiddenPlayerInfoCheck:RegisterCallback(Mouse.eLClick, OnHiddenPlayerInfoCheck);
	LuaEvents.JoiningRoom_ShowStagingRoom.Add(SetUpHiddenPlayerInfoCheck)
	
	-- Controls.LeaderStatsButton:RegisterCallback( Mouse.eLClick, OnLeaderStatsOpen );
	-- Controls.LeaderStatsButton:RegisterCallback( Mouse.eMouseEnter, function() UI.PlaySound("Main_Menu_Mouse_Over"); end);

	Controls.Header_CloseButton:RegisterCallback( Mouse.eLClick, OnLeaderStatsClose );

	Controls.ModCheckButton:RegisterCallback( Mouse.eLClick, OnModCheckButton );
	Controls.ModCheckButton:RegisterCallback( Mouse.eMouseEnter, function() UI.PlaySound("Main_Menu_Mouse_Over"); end);
	Controls.ModCheckButton:RegisterCallback( Mouse.eMouseExit, function() Controls.ModCheckTip:SetHide(true); end);

	Controls.FreeChooseAbilityCivilizationButton:RegisterCallback( Mouse.eLClick, OnFreeChooseAbilityCivilizationButton_L );
	Controls.FreeChooseAbilityCivilizationButton:RegisterCallback( Mouse.eRClick, OnFreeChooseAbilityCivilizationButton_R );
	Controls.FreeChooseAbilityCivilizationButton:RegisterCallback( Mouse.eMouseEnter, function() UI.PlaySound("Main_Menu_Mouse_Over"); end);

--	Controls.CharlemagneButton:RegisterCallback( Mouse.eLClick, OnCharlemagneButton );
--	Controls.CharlemagneButton:RegisterCallback( Mouse.eMouseEnter, function() UI.PlaySound("Main_Menu_Mouse_Over"); end);

--	Controls.Pantheon_AD_Button:RegisterCallback( Mouse.eLClick, OnPantheon_AD_Button );
--	Controls.Pantheon_AD_Button:RegisterCallback( Mouse.eMouseEnter, function() UI.PlaySound("Main_Menu_Mouse_Over"); end);

--	Controls.Flat_Balanced_AD_Button:RegisterCallback( Mouse.eLClick, OnFlat_Balanced_AD_Button );
--	Controls.Flat_Balanced_AD_Button:RegisterCallback( Mouse.eMouseEnter, function() UI.PlaySound("Main_Menu_Mouse_Over"); end);

	-- Controls.TeamPVPMap_AD_Button:RegisterCallback( Mouse.eLClick, OnTeamPVPMap_AD_Button );
	-- Controls.TeamPVPMap_AD_Button:RegisterCallback( Mouse.eMouseEnter, function() UI.PlaySound("Main_Menu_Mouse_Over"); end);

	-- Controls.LianJing_5th_Button:RegisterCallback( Mouse.eLClick, OnLianJing_5th_Button );
	-- Controls.LianJing_5th_Button:RegisterCallback( Mouse.eMouseEnter, function() UI.PlaySound("Main_Menu_Mouse_Over"); end);
	
--	Controls.NorthernContinentButton:RegisterCallback( Mouse.eLClick, OnNorthernContinentButton_L );
--	Controls.NorthernContinentButton:RegisterCallback( Mouse.eMouseEnter, function() UI.PlaySound("Main_Menu_Mouse_Over"); end);

--	Controls.RingContinentButton:RegisterCallback( Mouse.eLClick, OnRingContinentButton_L );
--	Controls.RingContinentButton:RegisterCallback( Mouse.eMouseEnter, function() UI.PlaySound("Main_Menu_Mouse_Over"); end);

--	Controls.FarmAndExpansionButton:RegisterCallback( Mouse.eLClick, OnFarmAndExpansionButton_L );
--	Controls.FarmAndExpansionButton:RegisterCallback( Mouse.eMouseEnter, function() UI.PlaySound("Main_Menu_Mouse_Over"); end);

--	Controls.ExperimentalButton:RegisterCallback( Mouse.eLClick, OnExperimentalButton );
--	Controls.ExperimentalButton:RegisterCallback( Mouse.eMouseEnter, function() UI.PlaySound("Main_Menu_Mouse_Over"); end);

--	Controls.ZHUQUEButton:RegisterCallback( Mouse.eLClick, OnZHUQUEButton );
--	Controls.ZHUQUEButton:RegisterCallback( Mouse.eMouseEnter, function() UI.PlaySound("Main_Menu_Mouse_Over"); end);

	Events.PlayerInfoChanged.Add(OnAmountChanged);
	Events.PlayerInfoChanged.Add(SetUp_TPT_Buttons);
	Events.MultiplayerJoinGameComplete.Add( ShowModCheckTip );
	
	LuaEvents.JoiningRoom_ShowStagingRoom.Add( OnFreeChooseAbilityCivilizationSetUpRaise );

	-- LuaEvents.JoiningRoom_ShowStagingRoom.Add(SetUpQQ_Lianjing_5th_AD);	
	-- LuaEvents.JoiningRoom_ShowStagingRoom.Add(SetUpQQ_yueCup_AD);	
--	LuaEvents.JoiningRoom_ShowStagingRoom.Add(SetUpQQ_LianjingCup_AD);	
--	LuaEvents.JoiningRoom_ShowStagingRoom.Add(SetUpQQ_Lianjing_AD);
--	LuaEvents.JoiningRoom_ShowStagingRoom.Add(SetUpQQ_Lianjing);
--	LuaEvents.JoiningRoom_ShowStagingRoom.Add(SetUpQQ_QingTian);

--	LuaEvents.JoiningRoom_ShowStagingRoom.Add(SetUp_ChaoRenBei);
--	LuaEvents.JoiningRoom_ShowStagingRoom.Add(SetUp_ZHUQ);
--------------------------------------------
	Controls.CancelBindingButton:RegisterCallback(Mouse.eLClick, function()
		Controls.NameModGroupPopup:SetHide(true);
	end);
	
	Controls.PlayerRequestCancelButton:RegisterCallback(Mouse.eLClick, function()
		Controls.PlayerRequestPopup:SetHide(true);
	end);	

	Controls.SteamIDInputEditBox:RegisterStringChangedCallback(function()
		local str = Controls.SteamIDInputEditBox:GetText();
		if str and #str > 17 then		-- 粘贴时超长，自动截取
			str = string.sub(str,1,17)
			Controls.SteamIDInputEditBox:SetText(str);
		end
		
		Controls.CreateModGroupButton:SetDisabled(str == nil or #str ~= 17 or not tonumber(str) );	-- 必须是17位id输入
		
		Controls.RemoveGroupButton:SetHide(str == nil or #str ~= 17 or not tonumber(str))
		Controls.SteamHomePageButton:SetHide(str == nil or #str ~= 17 or not tonumber(str))
		if str and #str == 17 then
			local ShowRemoveButton = false
			local steamIds :table = GetLocalSteamIDsData()
			for i, SteamID in ipairs(steamIds) do
				if SteamID == str then
					ShowRemoveButton = true
				end
			end
			Controls.RemoveGroupButton:SetHide(not ShowRemoveButton)
		end
	end);
	
	Controls.CreateModGroupButton:RegisterCallback(Mouse.eLClick, function()
		Controls.NameModGroupPopup:SetHide(true);
		local SteamID = Controls.SteamIDInputEditBox:GetText();
		local Desc = Controls.DescInputEditBox:GetText();
		StorageData(SteamID,Desc,"Ban")
		UpdateAllPlayerEntries()
	end);
	
	Controls.RemoveGroupButton:RegisterCallback(Mouse.eLClick, function()
		Controls.NameModGroupPopup:SetHide(true);
		local SteamID = Controls.SteamIDInputEditBox:GetText();
		RemoveDataSteamID( SteamID )
		UpdateAllPlayerEntries()
	end);	
	
	Controls.SteamHomePageButton:RegisterCallback(Mouse.eLClick, function()
		local str = Controls.SteamIDInputEditBox:GetText();
		local url = "https://steamcommunity.com/profiles/"..str;
		Steam.ActivateGameOverlayToUrl(url)
	end);	

	Controls.PlayerRequestSteamIDInputEditBox:RegisterStringChangedCallback(function()
		local str = Controls.PlayerRequestSteamIDInputEditBox:GetText();
		if str and #str > 17 then		-- 粘贴时超长，自动截取
			str = string.sub(str,1,17)
			Controls.PlayerRequestSteamIDInputEditBox:SetText(str);
		end
		CheakPlayerRequestInput()
	end);
	Controls.PlayerRequestNameInputEditBox:RegisterStringChangedCallback(CheakPlayerRequestInput)
	Controls.PlayerRequestDescInputEditBox:RegisterStringChangedCallback(function()
		CheakPlayerRequestInput()
		local Descstr = Controls.PlayerRequestDescInputEditBox:GetText();
		if Descstr and Descstr ~= "" then
			Controls.PlayerRequestDescInputEditBox:SetToolTipString(Descstr)
		end
	end);
	
	Controls.PlayerRequestConfirmButton:RegisterCallback(Mouse.eLClick, function()
		local SteamIDstr = Controls.PlayerRequestSteamIDInputEditBox:GetText();
		local Namestr = Controls.PlayerRequestNameInputEditBox:GetText();
		local Descstr = Controls.PlayerRequestDescInputEditBox:GetText();
		
		local Outputstr = "\t\t(\""..SteamIDstr.."\",\t\t\""..Namestr.."\",\t\t\t\t\t\t\t\"Normal\",\t\t\t\""..Descstr.."\"),";
		UIManager:SetClipboardString(Outputstr)
		Controls.PlayerRequestPopup:SetHide(true);
	end);	
	
--------------------------------------------
	Controls.InviteButton:SetToolTipString(GetInviteTT());

	Events.MapMaxMajorPlayersChanged.Add(OnMapMaxMajorPlayersChanged); 
	Events.MapMinMajorPlayersChanged.Add(OnMapMinMajorPlayersChanged);
	Events.MultiplayerPrePlayerDisconnected.Add( OnMultiplayerPrePlayerDisconnected );
	Events.GameConfigChanged.Add(OnGameConfigChanged);
	Events.PlayerInfoChanged.Add(OnPlayerInfoChanged);

	Events.UploadCloudPlayerConfigComplete.Add(OnUploadCloudPlayerConfigComplete);
	Events.ModStatusUpdated.Add(OnModStatusUpdated);
	Events.MultiplayerChat.Add( OnMultiplayerChat );
	Events.MultiplayerGameAbandoned.Add( OnAbandoned );
	Events.MultiplayerGameLaunchFailed.Add( OnMultiplayerGameLaunchFailed );
	Events.LeaveGameComplete.Add( OnLeaveGameComplete );
	Events.BeforeMultiplayerInviteProcessing.Add( OnBeforeMultiplayerInviteProcessing );
	Events.MultiplayerHostMigrated.Add( OnMultiplayerHostMigrated );
	Events.MultiplayerPlayerConnected.Add( OnMultplayerPlayerConnected );
	Events.MultiplayerPingTimesChanged.Add(OnMultiplayerPingTimesChanged);
	Events.SteamFriendsStatusUpdated.Add( UpdateFriendsList );
	Events.SteamFriendsPresenceUpdated.Add( UpdateFriendsList );
	Events.CloudGameKilled.Add(OnCloudGameKilled);
	Events.CloudGameQuit.Add(OnCloudGameQuit);

	LuaEvents.GameDebug_Return.Add(OnGameDebugReturn);
	LuaEvents.HostGame_ShowStagingRoom.Add( OnRaise );
	LuaEvents.JoiningRoom_ShowStagingRoom.Add( OnRaise );
	LuaEvents.EditHotseatPlayer_UpdatePlayer.Add(UpdatePlayerEntry);
	LuaEvents.Multiplayer_ExitShell.Add( OnHandleExitRequest );

	Controls.TitleLabel:SetText(Locale.ToUpper(Locale.Lookup("LOC_MULTIPLAYER_STAGING_ROOM")));
	ResizeButtonToText(Controls.BackButton);
	ResizeButtonToText(Controls.EndGameButton);
	ResizeButtonToText(Controls.QuitGameButton);
	RealizeShellTabs();
	RealizeInfoTabs();
	SetupGridLines(0);
	Resize();
------------------------------------------------
	RefreshPlayerData()		-- 初始化表
	CreatTeamBaseRatio()
	Creat_TPT_Update()
	
	CreatLeaderStatsInstance()
end
Initialize();

-- ========================================================================
-- 扑克游戏
-- ========================================================================

-- ====================================================
-- 全局变量
-- ====================================================
local m_LaunchButtonInstance = {};		-- 打开按钮
local m_HandCardsIM:table = InstanceManager:new("HandCardInstance", "Content", Controls.CardStack);		-- 手牌
local m_DeclarerHandCardsIM:table = InstanceManager:new("HandCardInstance", "Content", Controls.DeclarerCardStack);		-- 庄家手牌
local m_ProgressLabelIM = InstanceManager:new("ProgressInstance", "Content", Controls.ProgressLabelsStack);		-- 游戏进度文本
local m_OtherPlayerGoldIM = InstanceManager:new("OtherPlayerGoldInstance", "Content", Controls.OtherPlayerGoldStack);		-- 游戏进度文本

local m_Card_pools = {}		-- 总牌库
local m_Hand_PokeCard_Data = {}		-- 玩家手牌
local m_Declarer_Hand_PokeCard_Data = {}		-- 庄家手牌

local m_Bet = 0		-- 赌注金额
local m_Win = false		-- 上一把赢了？
local m_InProgress = false		-- 游戏进行中

local GOLD_Balanced_Cache = {}		-- 用于校验玩家信息是否发生改变
local m_NoCashLimit = true		-- 20金币 无下注现金限制

local m_Gold = 0		-- 玩家虚拟筹码

local CallbackDict = {};				-- 计时器移除
local AuxiliaryTiming = {};			-- 计时器时间
local ATnum = 0;						-- 计时器ID

local First_Poker = true
-- ====================================================
-- 常数
-- ====================================================
local HAND_CARD_PANDDING = 4;		-- 手牌基础间隔

local IMG_POLICYCARD_BY_ROWIDX :table = {};						-- 卡牌花色贴图
	IMG_POLICYCARD_BY_ROWIDX["H"] = "Governments_MilitaryCard";
	IMG_POLICYCARD_BY_ROWIDX["D"] = "Governments_EconomicCard";
	IMG_POLICYCARD_BY_ROWIDX["C"] = "Governments_DiplomacyCard";
	IMG_POLICYCARD_BY_ROWIDX["S"] = "Governments_WildcardCard";
	
local CardTypes = {};		-- 卡牌花色
	CardTypes[1] = "H";		-- 红心：Heart
	CardTypes[2] = "D";		-- 方块：Diamond
	CardTypes[3] = "C";		-- 草花：Club
	CardTypes[4] = "S";		-- 黑桃：Spade
	
local CardNum = {};			-- 卡牌数字
	CardNum[1] = "A";
	CardNum[2] = "2";
	CardNum[3] = "3";
	CardNum[4] = "4";
	CardNum[5] = "5";
	CardNum[6] = "6";
	CardNum[7] = "7";
	CardNum[8] = "8";
	CardNum[9] = "9";
	CardNum[10] = "10";
	CardNum[11] = "J";
	CardNum[12] = "Q";
	CardNum[13] = "K";
	
local Sound_Bet = "Purchase_With_Gold";		-- 下注声音
local Sound_Lose = "Confirm_Production";	-- 失败声音
local Sound_Win = "UI_Unlock_Government";	-- 胜利声音

local LOC_PBJ_DEALER_WIN_NAMEstr = Locale.Lookup("LOC_PBJ_DEALER_WIN_NAME");
local LOC_PBJ_PUSH_NAMEstr = Locale.Lookup("LOC_PBJ_PUSH_NAME");
local LOC_PBJ_PLAYER_WIN_NAMEstr = Locale.Lookup("LOC_PBJ_PLAYER_WIN_NAME");
local LOC_PBJ_DEALER_BUST_NAMEstr = Locale.Lookup("LOC_PBJ_DEALER_BUST_NAME");
local LOC_PBJ_DEALER_HIT_NAMEstr = Locale.Lookup("LOC_PBJ_DEALER_HIT_NAME");
local LOC_PBJ_SHOW_DEALER_CARD_NAMEstr = Locale.Lookup("LOC_PBJ_SHOW_DEALER_CARD_NAME");
local LOC_PBJ_PLAYER_BUST_NAMEstr = Locale.Lookup("LOC_PBJ_PLAYER_BUST_NAME");
local LOC_PBJ_BUST_NAMEstr = Locale.Lookup("LOC_PBJ_BUST_NAME");
local LOC_PBJ_PLAYERTURN_NAMEstr = Locale.Lookup("LOC_PBJ_PLAYERTURN_NAME");
local LOC_PBJ_DEALER_FIRST_HIT_NAMEstr = Locale.Lookup("LOC_PBJ_DEALER_FIRST_HIT_NAME");
local LOC_PBJ_BET_WAGER_NAMEstr = Locale.Lookup("LOC_PBJ_BET_WAGER_NAME");
local LOC_PBJ_BET_DOUBLE_BASE_BUTTON_NAMEstr = Locale.Lookup("LOC_PBJ_BET_DOUBLE_BASE_BUTTON_NAME");

-- ====================================================
-- 开关面板
-- ====================================================
function Poker_OnOpen()
	UI.PlaySound("UI_Screen_Open")
	Controls.Main_Poker:SetHide(false);
	if not m_InProgress then		-- 不在游戏进行中则刷新
		Restart()
	end
	if First_Poker then
		First_Poker = false
		Network.SendChat("正在游玩21点",-2,-1)
	end
end

function Poker_OnClose()
	UI.PlaySound("UI_Screen_Close")
	Controls.Main_Poker:SetHide(true);
end

-- ====================================================
-- 重新开始按钮
-- ====================================================
function Restart()
--	print("重新开始")
	-- 移除计时任务
	RemoveAllTimer()
	
--	if m_Gold >= 3000000 then
--		m_Gold = 0
--		GoldBalanced(0)
--		AddProgressLabel("金币数量异常，已清空")
--	end
	
	local _, Date = GetstorageGold()
--	print("重开——获取时间",os.time(), Date)
	if not Date or Date <= 0 then
		GoldBalanced(460, true)		-- 登录奖励
		AddProgressLabel("[ICON_Goldlarge]+460   来自首次登录奖励")
	elseif os.time() > Date + 86400 then		-- 24小时
		GoldBalanced(420, true)		-- 24小时
		AddProgressLabel("[ICON_Goldlarge]+420   来自24小时签到奖励")
	elseif os.time() > Date + 21600 then
		GoldBalanced(380, true)		-- 6小时
		AddProgressLabel("[ICON_Goldlarge]+380   来自6小时签到奖励")
	elseif os.time() > Date + 3600 then
		GoldBalanced(320, true)		-- 1小时
		AddProgressLabel("[ICON_Goldlarge]+320   来自1小时签到奖励")
	end

	RefreshOtherPlayerGold()		-- 刷新其他玩家金币

	-- 重置变量
	if m_InProgress then
		m_Bet = 0
		m_Win = false
	end

	m_Card_pools = Getshuffle()
	m_Hand_PokeCard_Data = {}
	m_Declarer_Hand_PokeCard_Data = {}
	m_InProgress = false
	-- 重置UI
	Controls.StandButton:SetDisabled(true)
	Controls.HITButton:SetDisabled(true)
	Controls.BetButtons:SetHide(false)
	
	RefreshGoldPanel()

	Controls.Bet_Double_Label:SetText( m_Win and (LOC_PBJ_BET_DOUBLE_BASE_BUTTON_NAMEstr .. "(" .. tostring(math.min(2 * m_Bet, 1000000)) .. ")") or LOC_PBJ_BET_DOUBLE_BASE_BUTTON_NAMEstr )		-- 翻倍下注按钮
	Controls.Bet_Double_Button:SetSizeX(Controls.Bet_Double_Label:GetSizeX() + 20)
end
-- ====================================================
-- 下注按钮响应
-- ====================================================
function OnBet(Num)
	m_InProgress = true		-- 游戏进行标志

	UI.PlaySound( Sound_Bet )
	-- 初始化UI
	Controls.TotalNumLabel:SetText("")
	Controls.DeclarerTotalNumLabel:SetText("")
	
	Controls.CardStack:DestroyAllChildren();
	Controls.CardStack:SetStackPadding(HAND_CARD_PANDDING)
	Controls.CardStack:CalculateSize();
	
	Controls.DeclarerCardStack:DestroyAllChildren();
	Controls.DeclarerCardStack:SetStackPadding(HAND_CARD_PANDDING)
	Controls.DeclarerCardStack:CalculateSize();

	if Num == -1 then		-- 翻倍按钮
		m_Bet = math.min(2 * m_Bet, 1000000)
	else
		m_Bet = Num;
	end
	GoldBalanced(-1 * m_Bet)
	AddProgressLabel( LOC_PBJ_BET_WAGER_NAMEstr .. tostring(-1 * m_Bet))		-- 进度文本提示

	Controls.Bet_20_Button:SetDisabled(true)			-- 所有下注按钮失效
	Controls.Bet_100_Button:SetDisabled(true)
	Controls.Bet_500_Button:SetDisabled(true)
	Controls.Bet_Double_Button:SetDisabled(true)

	AddTimer(60, DeclarerStart, false, nil, nil, false, true)		-- 延迟一会儿，庄家发牌初始化
end
-- ====================================================
-- 庄家初始化		要2张牌
-- ====================================================
function DeclarerStart()
	table.insert(m_Declarer_Hand_PokeCard_Data, table.remove(m_Card_pools, math.random(#m_Card_pools)))		-- 从牌库中抽走一张
	if #m_Declarer_Hand_PokeCard_Data == 1 then		-- 第一次抽牌
		table.insert(m_Declarer_Hand_PokeCard_Data, table.remove(m_Card_pools, math.random(#m_Card_pools)))
		AddProgressLabel(LOC_PBJ_DEALER_FIRST_HIT_NAMEstr)
		AddTimer(90, RealizeDeclarerHandCards, false, nil, {m_Declarer_Hand_PokeCard_Data, false}, true, true)
	else
		AddTimer(90, RealizeDeclarerHandCards, false, nil, {m_Declarer_Hand_PokeCard_Data, true}, true, true)
	end
end
-- ====================================================
-- 显示庄家卡牌UI
-- ====================================================
function RealizeDeclarerHandCards(Data, CanShow)
	UI.PlaySound("UI_Policies_Card_Drop");
	Controls.DeclarerCardStack:DestroyAllChildren()		-- 重置
	for i, v in pairs(Data) do
		local tControl = m_DeclarerHandCardsIM:GetInstance();
		if not(i == 1 and #Data == 2 and not CanShow) then		-- 不是第一张牌才显示花色和点数
			local Controls_Img = tControl.BG:GetChildren()		-- 替换花色
			
			for i, iCtr in pairs(Controls_Img) do
				iCtr:SetTexture(IMG_POLICYCARD_BY_ROWIDX[v.Type])
			end

			tControl.NumLabel1:SetText(CardNum[v.Num])			-- 显示点数
			tControl.NumLabel2:SetText(CardNum[v.Num])
		end
	end
	Controls.DeclarerCardStack:CalculateSize();

	local MaxSize = Controls.HandCardBG:GetSizeX() - 100;
	local sizeDiff = Controls.DeclarerCardStack:GetSizeX();			-- 尺寸过长修正：重叠
	if sizeDiff > MaxSize then
		local stackPaddingBalanced = math.max(math.floor((MaxSize - sizeDiff)/(#Data - 1)), -50)
		Controls.DeclarerCardStack:SetStackPadding(Controls.DeclarerCardStack:GetStackPadding() + stackPaddingBalanced)
	end
		
	local TotalNum = GetPointcombo(Data)				-- 收集所有可能点数
	local BestNum = GetBestPoint(TotalNum)
	
	if #Data == 2 and not CanShow then		-- 庄家盖牌时不显示
		Controls.DeclarerTotalNumLabel:SetText("?")
	else
		local NumText = ""		-- 点数提示文字
		if BestNum < 21 then						-- 庄家只显示一个数字，不显示全部结果
			NumText = tostring(BestNum)
		elseif BestNum == 21 then
			NumText = "[COLOR_Civ6Green]" .. tostring(BestNum) .. "[ENDCOLOR]";
		else
			NumText = "[COLOR:ResMilitaryLabelCS]" .. tostring(BestNum) .. "[ENDCOLOR]  " .. LOC_PBJ_BUST_NAMEstr;
		end
		Controls.DeclarerTotalNumLabel:SetText(NumText)
	end

	if #Data == 2 and not CanShow then
		AddTimer(120, AddProgressLabel, false, nil, LOC_PBJ_PLAYERTURN_NAMEstr, false, true)
		AddTimer(300, OnHITButton, false, nil, nil, false, true)		-- 如果是庄家初始化完成，则自动为玩家抽2张牌
	end
end
-- ====================================================
-- 叫牌，然后刷新手牌
-- ====================================================
function OnHITButton()
	table.insert(m_Hand_PokeCard_Data, table.remove(m_Card_pools, math.random(#m_Card_pools)))
	
	if #m_Hand_PokeCard_Data == 1 then
		table.insert(m_Hand_PokeCard_Data, table.remove(m_Card_pools, math.random(#m_Card_pools)))
	end

	RealizeHandCards(m_Hand_PokeCard_Data)		-- 显示手牌
end
-- ====================================================
-- 显示玩家手牌 UI
-- ====================================================
function RealizeHandCards(Data)
	UI.PlaySound("UI_Policies_Card_Drop");
	
	Controls.CardStack:DestroyAllChildren()
	for i, v in ipairs(Data) do
		local tControl = m_HandCardsIM:GetInstance();
		local Controls_Img = tControl.BG:GetChildren()
		
		for i, iCtr in pairs(Controls_Img) do
			iCtr:SetTexture(IMG_POLICYCARD_BY_ROWIDX[v.Type])
		end
		tControl.NumLabel1:SetText(CardNum[v.Num])
		tControl.NumLabel2:SetText(CardNum[v.Num])
	end

	Controls.CardStack:CalculateSize();

	local MaxSize = Controls.HandCardBG:GetSizeX() - 100;
	local sizeDiff = Controls.CardStack:GetSizeX();					-- 如果卡牌过多，则调整卡牌间距
	if sizeDiff > MaxSize then
		local stackPaddingBalanced = math.max(math.floor((MaxSize - sizeDiff)/(#Data - 1)), -50)
		Controls.CardStack:SetStackPadding(Controls.CardStack:GetStackPadding() + stackPaddingBalanced)
	end	
	
	local TotalNum = GetPointcombo(Data)				-- 收集所有可能点数
	local BestNum = GetBestPoint(TotalNum)

	local NumText = ""		-- 点数提示文字
	for i, v in ipairs(TotalNum) do
		local nText = ""
		if v <= BestNum then		-- 只显示最优数字和最小数字
			if v < 21 then
				nText = tostring(v)
			elseif v == 21 then
				nText = "[COLOR_Civ6Green]" .. tostring(v) .. "[ENDCOLOR]";
			else
				nText = "[COLOR:ResMilitaryLabelCS]" .. tostring(v) .. "[ENDCOLOR]";
			end
			
			if NumText == "" then
				NumText = NumText .. nText;
			else
				NumText = NumText .. " [ICON_RANGE_LARGE] " .. nText;		-- 间隔符号
			end
		end
	end

	if BestNum > 21 then
		NumText = NumText .. "  " .. LOC_PBJ_BUST_NAMEstr;
		AddProgressLabel( LOC_PBJ_PLAYER_BUST_NAMEstr )
		m_Win = false
		m_InProgress = false
		UI.PlaySound( Sound_Lose )
		AddTimer(60, Restart, false, nil, nil, false, true)
	elseif BestNum == 21 then
		NumText = "[COLOR_Civ6Green]21[ENDCOLOR]";
	end
	Controls.TotalNumLabel:SetText(NumText)

	Controls.HITButton:SetDisabled(BestNum >= 21)	-- 允许继续时才能要牌
	Controls.StandButton:SetDisabled(BestNum > 21)		-- 玩家爆牌后不可停牌
end
-- ====================================================
-- 停牌，然后庄家发牌
-- ====================================================
function OnStandButton()
	Controls.HITButton:SetDisabled(true)
	Controls.StandButton:SetDisabled(true)

	local TotalNum = GetPointcombo(m_Hand_PokeCard_Data)	-- 停牌后只显示最佳点数
	local BestNum = GetBestPoint(TotalNum)
	local NumStr = tostring(BestNum)
	if BestNum > 21 then
		NumStr = "[COLOR:ResMilitaryLabelCS]" .. NumStr .. "[ENDCOLOR]";
	elseif BestNum == 21 then
		NumStr = "[COLOR_Civ6Green]" .. NumStr .. "[ENDCOLOR]";
	end
	Controls.TotalNumLabel:SetText(NumStr)

	AddProgressLabel( LOC_PBJ_SHOW_DEALER_CARD_NAMEstr )
	AddTimer(30, RealizeDeclarerHandCards, false, nil, {m_Declarer_Hand_PokeCard_Data; true}, true, true)
	AddTimer(40, DeclarerLogicLoop, false, nil, nil, false, true)			-- 进入庄家循环
end
-- ====================================================
-- 庄家逻辑循环
-- ====================================================
function DeclarerLogicLoop()		-- 庄家行为循环
	--print("庄家循环")
	local DeclarerTotalNum = GetPointcombo(m_Declarer_Hand_PokeCard_Data)		-- 收集所有可能点数
	local DeclarerBestNum = GetBestPoint(DeclarerTotalNum)			-- 最优数字
	local DeclarerMin = math.min(unpack(DeclarerTotalNum))		-- 庄家最小值

	local PlayerTotalNum = GetPointcombo(m_Hand_PokeCard_Data)
	local PlayerBestNum = GetBestPoint(PlayerTotalNum)
	if DeclarerBestNum >= 17 then
		if DeclarerBestNum < PlayerBestNum and DeclarerMin < 17 then		-- 如果庄家现有点数小于玩家，但是有A,最小点数小于17，庄家再继续抽牌
			DeclarerStart()
			AddProgressLabel( LOC_PBJ_DEALER_HIT_NAMEstr )
			AddTimer(240, DeclarerLogicLoop, false, nil, nil, false, false)
		else
			AddTimer(120, DeclarerStop, false, nil, {DeclarerBestNum; PlayerBestNum}, true, false)
		end
	else
		DeclarerStart()
		AddProgressLabel( LOC_PBJ_DEALER_HIT_NAMEstr )
		AddTimer(240, DeclarerLogicLoop, false, nil, nil, false, false)
	end
end
-- ====================================================
-- 结算环节
-- ====================================================
function DeclarerStop(DeclarerBestNum, PlayerBestNum)		-- 庄家停牌了
	m_Win = false;
	if m_InProgress then
		if DeclarerBestNum > 21 then
			AddProgressLabel( LOC_PBJ_DEALER_BUST_NAMEstr )
			AddProgressLabel("[icon_goldlarge]+" .. tostring(2 * m_Bet))
			GoldBalanced(2 * m_Bet)
			UI.PlaySound( Sound_Win )
			m_Win = true;
		else
			if PlayerBestNum > DeclarerBestNum then		-- 玩家点数大于庄家
				AddProgressLabel( LOC_PBJ_PLAYER_WIN_NAMEstr )
				AddProgressLabel("[icon_goldlarge]+" .. tostring(2 * m_Bet))
				GoldBalanced(2 * m_Bet)
				UI.PlaySound( Sound_Win )
				m_Win = true;
			elseif PlayerBestNum == DeclarerBestNum then
				AddProgressLabel( LOC_PBJ_PUSH_NAMEstr )
				AddProgressLabel("[icon_goldlarge]+" .. tostring(m_Bet))
				GoldBalanced(m_Bet)
				UI.PlaySound( Sound_Win )
			elseif PlayerBestNum < DeclarerBestNum then		-- 玩家点数小于于庄家
				AddProgressLabel( LOC_PBJ_DEALER_WIN_NAMEstr )
				UI.PlaySound( Sound_Lose )
			end
		end
	else
		RemoveAllTimer()			-- 错误循环
	end
	m_InProgress = false
	AddTimer(60, Restart, false, nil, nil, false, false)
end

-- ====================================================
-- 添加游戏进度文本
-- ====================================================
function AddProgressLabel(str)
	local iControl = m_ProgressLabelIM:GetInstance();
	iControl.DeclarerLogicLabel:SetText(str)
	
	local Size_Y = Controls.ProgressLabelsStack:GetSizeY()
	local Size_Y_Max = Controls.ProgressList:GetSizeY()
	
	local Labels = Controls.ProgressLabelsStack:GetChildren();
	if Size_Y >= Size_Y_Max - 25 then		-- 限制文本数量
		for i, iLabel in ipairs(Labels) do
			Controls.ProgressLabelsStack:DestroyChild(iLabel)
			break
		end
	end

	Controls.ProgressLabelsStack:CalculateSize();
end

-- =============================================
-- 获取全部组合数字
-- =============================================
function GetPointcombo(Data)
	local TotalNum = {}
	for i, v in ipairs(Data) do
		if #TotalNum == 0 then		-- 还没有数字？				-- A 可以作为1或者11
			if v.Num == 1 then
				table.insert(TotalNum, 1)
				table.insert(TotalNum, 11)
			elseif v.Num <= 10 then
				table.insert(TotalNum, v.Num)
			else
				table.insert(TotalNum, 10)
			end
		else					-- 已经有数字了
			if v.Num == 1 then
				local NewNum = {}
				for i, n in ipairs(TotalNum) do
					table.insert(NewNum, TotalNum[i] + 1)
					table.insert(NewNum, TotalNum[i] + 11)
				end
				TotalNum = NewNum
			elseif v.Num <= 10 then
				for i, n in ipairs(TotalNum) do
					TotalNum[i] = TotalNum[i] + v.Num
				end
			else
				for i, n in ipairs(TotalNum) do
					TotalNum[i] = TotalNum[i] + 10
				end
			end
		end	
	end
	TotalNum = Unique(TotalNum, true)
	
	return TotalNum
end

-- =============================================
-- 获取最优数字
-- =============================================
function GetBestPoint(Numbers:table)
	if Numbers == nil then
		return -1
	end
	local BestPoint = math.min(unpack(Numbers))
	for i, v in pairs(Numbers) do
		if v <= 21 and v > BestPoint then
			BestPoint = v
		end
	end
	return BestPoint
end

-- =============================================
-- 刷新金币
-- =============================================
function RefreshGoldPanel()
	goldBalance = m_Gold
	Controls.YieldPerTurn:SetText( Locale.ToNumber(goldBalance, "#,###.#;- #,###.#") );

	if not m_InProgress then
		Controls.Bet_20_Button:SetDisabled(goldBalance < 20 and not m_NoCashLimit)
		Controls.Bet_100_Button:SetDisabled(goldBalance < 100 and not m_NoCashLimit)
		Controls.Bet_500_Button:SetDisabled(goldBalance < 500)
		Controls.Bet_Double_Button:SetDisabled(not m_Win or (goldBalance < math.min(2 * m_Bet, 1000000)) and not m_NoCashLimit)
	end
end
-- ====================================================
-- 洗牌：获取随机顺序卡池
-- ====================================================
function Getshuffle()
	local Cards = {}
	for i = 1, 4 do			-- 一共4副卡牌
		for j = 1, 13 do		-- 一副牌13钟
			for k = 1, 4 do			-- 4种花色
				local idata = {
					Num = j,
					Type = CardTypes[k],
				}
				table.insert(Cards, idata)			
			end
		end
	end

	for i = 1, #Cards do		-- 洗牌
		local randN = math.random(1, #Cards + 1 - i)
		Cards[randN], Cards[#Cards + 1 - i] = Cards[#Cards + 1 - i], Cards[randN];
	end

	return Cards
end

-- ====================================================
-- 去重复		(表， 是否重置连续序号)
-- ====================================================
function Unique(t, bArray)
    local check = {}
    local n = {}
    local idx = 1
    for k, v in pairs(t) do
        if not check[v] then
            if bArray then
                n[idx] = v
                idx = idx + 1
            else
                n[k] = v
            end
            check[v] = true
        end
    end
    return n
end

-- ====================================================
-- 拆分字符串
-- ====================================================
--function split(str,reps)
--    local resultStrList = {}
--    string.gsub(str,'[^'..reps..']+',function (w)
--        table.insert(resultStrList,w)
--    end)
--    return resultStrList
--end

-- ====================================================
-- 定时器
-- ====================================================
function AddTimer(TimeInSeconds, callbackFunc, loop, FuncID, Values, Needunpack, Replace)
    ATnum = ATnum + 1;
    -- 如果loop为nil
    loop = loop or false;
    local num = tonumber(FuncID);
    -- 如果FuncID为数值字符串且大于0是整数
    if num and num > 0 and math.floor(num) == num then
        FuncID = "New_" ..ATnum;
    end
    -- 如果FuncID发生重复
    if CallbackDict[FuncID] ~= nil then
        if Replace then
            CallbackDict[FuncID]()
        else
            FuncID = ATnum;
        end
    end
    -- 如果FuncID为nil
    FuncID = FuncID or ATnum;
    AuxiliaryTiming[FuncID] = TimeInSeconds;

    -- callbackFunc插入到定时循环中
--    function CreateLoopFunc()
--        return function()
--            AuxiliaryTiming[FuncID] = AuxiliaryTiming[FuncID] - 1;
--            if AuxiliaryTiming[FuncID] <= 0 then
--                callbackFunc(Values);
--				if type(Values) == "table" and Needunpack then
--					callbackFunc(unpack(Values));
--				else
--					callbackFunc(Values);
--				end
--                AuxiliaryTiming[FuncID] = TimeInSeconds;
--            end
--        end
--    end

    -- callbackFunc插入到延时触发中
    function CreateFunc()
        return function()
            AuxiliaryTiming[FuncID] = AuxiliaryTiming[FuncID] - 1;
            if AuxiliaryTiming[FuncID] <= 0 then
--                callbackFunc(Values);
				if type(Values) == "table" and Needunpack then
					callbackFunc(unpack(Values));
				else
					callbackFunc(Values);
				end
				if CallbackDict[FuncID] ~= nil then
					CallbackDict[FuncID]()
				end
            end
        end
    end

--    local func = loop and CreateLoopFunc() or CreateFunc();
    local func = CreateFunc();
    Events.GameCoreEventPublishComplete.Add(func);
    
    -- 直接构造好对应的关闭循环的函数，亦或者提前关闭延迟的函数以免找不到对应func
    CallbackDict[FuncID] = function()
        Events.GameCoreEventPublishComplete.Remove(func);
        CallbackDict[FuncID] = nil;
        AuxiliaryTiming[FuncID] = nil;
    end
    return ATnum;
end

function RemoveAllTimer()
	for i, v in pairs(CallbackDict) do
		if CallbackDict[i] then
			CallbackDict[i]()
		end
	end
end

-- =======================================================================
-- 多人游戏时，玩家信息改变修改数据
-- =======================================================================
function GoldBalanced(Num, Reset)
	if Reset then
		m_Gold = math.max(m_Gold, 0)
	end
	m_Gold = m_Gold + Num				-- 多人游戏时，将自己的得分分享出去
	local playerID = Network.GetLocalPlayerID();
	PlayerConfigurations[playerID]:SetValue("Poke_Gold", tostring( os.time() ) .. "_" .. tostring(m_Gold));
	Network.BroadcastPlayerInfo(playerID);
	
	RefreshGoldPanel()
	SetstorageGold(Reset)
end

-- =======================================================================
-- 多人游戏时，玩家信息改变修改数据
-- =======================================================================
function Poker_OnPlayerInfoChanged(playerID)
	AddTimer(5, Poker_OnPlayerInfoChanged_Refresh, false, "InfoChanged", playerID, false, true)
end

function Poker_OnPlayerInfoChanged_Refresh(playerID)
--	print("玩家数据变化", PlayerConfigurations[playerID]:GetValue("Poke_Gold"))
	if playerID == Network.GetLocalPlayerID() then		-- 只用于刷新其他玩家的金币
		return
	end
	if not PlayerConfigurations[playerID]:IsHuman() then
		return
	end;

	local ValueStr = PlayerConfigurations[playerID]:GetValue("Poke_Gold");
	if ValueStr == nil or ValueStr == "" then
		return
	end;

	local tValues = split(ValueStr, "_")		-- 拆分字符串成表格
	if tValues[1] ~= GOLD_Balanced_Cache[playerID] then				-- 校验
		RefreshOtherPlayerGold()
	end

	GOLD_Balanced_Cache[playerID] = tValues[1]
end
-- =======================================================================
-- 刷新多人模式下其他玩家的金币
-- =======================================================================
function RefreshOtherPlayerGold()
	Controls.OtherPlayerGoldStack:DestroyAllChildren()
	
	local OtherPlayerInfo = {}
	
	local player_ids = GameConfiguration.GetMultiplayerPlayerIDs();
	for _, iPlayerID in ipairs(player_ids) do
		if iPlayerID ~= Network.GetLocalPlayerID() then		--  仅记录其他玩家	
			local pPlayerConfig = PlayerConfigurations[iPlayerID];
			if pPlayerConfig:IsHuman() then
				local ValueStr = pPlayerConfig:GetValue("Poke_Gold");
				if ValueStr ~= nil and ValueStr ~= "" then
					local tValues = split(ValueStr, "_")		-- 拆分字符串成表格
					local kdata = {
						PlayerName = Locale.Lookup(pPlayerConfig:GetPlayerName()),
						playerGold = tonumber(tValues[2]) or 0,
					}
					table.insert(OtherPlayerInfo, kdata)
				end
			end
		end
	end

	for i, idata in ipairs(OtherPlayerInfo) do
		local iControl = m_OtherPlayerGoldIM:GetInstance();
		iControl.Player_Name:SetText(idata.PlayerName)
		iControl.YieldGold:SetText( Locale.ToNumber(idata.playerGold, "#,###.#;- #,###.#") )
	end
	Controls.OtherPlayerGoldStack:CalculateSize();
end

-- =======================================================================
-- 初始化校验数据
-- =======================================================================
function Initialize_GOLD_Balanced_Cache()
	local player_ids = GameConfiguration.GetMultiplayerPlayerIDs();
	for _, iPlayerID in ipairs(player_ids) do
		if iPlayerID ~= Network.GetLocalPlayerID() then		--  仅记录其他玩家
			local pPlayerConfig = PlayerConfigurations[iPlayerID];
			if pPlayerConfig:IsHuman() then
				local ValueStr = PlayerConfigurations[iPlayerID]:GetValue("Poke_Gold");
				if ValueStr ~= nil and ValueStr ~= "" then
					local tValues = split(ValueStr, "_")		-- 拆分字符串成表格
					GOLD_Balanced_Cache[iPlayerID] = tValues[1]
				end
			end
		end
	end
end

-- =======================================================================
-- 投注无限制选项
-- =======================================================================
--function OnNoCashLimitCheck()
--	m_NoCashLimit = not m_NoCashLimit;
--	Controls.NoCashLimitCheck:SetCheck(m_NoCashLimit)
--	UI.PlaySound("Tech_Tray_Slide_Open");

--	if not m_InProgress then		-- 不在游戏进行中则刷新
--		Restart()
--	end
--end

-- =======================================================================
-- 永久储存玩家筹码信息
-- =======================================================================
function SetstorageGold(newdate)		-- 如果是签到奖励，则要更新日期，否则用旧日期
	local _, olddate = GetstorageGold();
	olddate = olddate or os.time()
	local t = {
		date = os.time(),		-- 储存时间
		Gold = m_Gold,			-- 金币数量
	}
	
	if not newdate then		-- 需要重置上次登录时间
		if olddate and olddate > 0 then		-- 存在正确的日期
			t.date = olddate
		end
	end

	Storage_table(t, "BlackJackGold")
end

function GetstorageGold()		-- 读取存储的信息
	local t = Read_tableString("BlackJackGold");
	local Gold =  t.Gold or 0
	local Date =  t.date or 0
	return Gold, Date
end
-- =======================================================================
-- 延迟初始化，加载UI部分
-- =======================================================================
function Poker_LateInitialize()
--	print("玩家加入房间")
	local Gold_s, _ = GetstorageGold()
	m_Gold = Gold_s		-- 加载数据
	First_Poker = true

	local playerID = Network.GetLocalPlayerID();
	PlayerConfigurations[playerID]:SetValue("Poke_Gold", tostring( os.clock() ) .. "_" .. tostring(m_Gold));
	Network.BroadcastPlayerInfo(playerID);

	local m_screenWidth, m_screenHeight = Controls.Main_Poker:GetSizeVal();
--	print("屏幕大小：", m_screenWidth, m_screenHeight)

	if m_screenWidth < 1920 then
		Controls.OperateButtons:SetAnchor("R,C");
		Controls.OperateButtons:SetOffsetX(28)
	end
	
	if m_screenHeight < 1080 then
		Controls.HandCardBG:SetAnchor("C,B");
		Controls.HandCardBG:SetOffsetY(20)
		
		Controls.ProgressList:SetAnchor("C,T");
		Controls.ProgressList:SetOffsetY(380)
		Controls.ProgressList:SetSizeY(m_screenHeight - 790)
		
		Controls.CardStack:SetAnchor("C,B");
		Controls.CardStack:SetOffsetY(46)

		Controls.TotalNumLabel:SetAnchor("C,B");
		Controls.TotalNumLabel:SetOffsetY(295)
		
		Controls.DeclarerCardStack:SetAnchor("C,T");
		Controls.DeclarerCardStack:SetOffsetY(100)

		Controls.DeclarerTotalNumLabel:SetAnchor("C,T");
		Controls.DeclarerTotalNumLabel:SetOffsetY(340)

		Controls.BetButtons:SetAnchor("C,B");
		Controls.BetButtons:SetOffsetY(350)
	end
	
	RefreshGoldPanel()
	Restart()
end

-- =======================================================================
-- 初始化
-- =======================================================================
function Poker_Initialize()
	m_Gold = GetstorageGold();		-- 获取储存的金币
--	print("初始化信息", GetstorageGold())
	LuaEvents.Multiplayer_ExitShell.Add( Restart );
	Events.MultiplayerJoinGameComplete.Add( Initialize_GOLD_Balanced_Cache );		-- 每次加入房间获取所有人的分数

	Events.MultiplayerJoinGameComplete.Add( Poker_LateInitialize );

	Events.PlayerInfoChanged.Add(Poker_OnPlayerInfoChanged);

	LuaEvents.Open_Poke_Blackjack.Add(Poker_OnOpen)			-- 留给其他文件的开关接口
	LuaEvents.Close_Poke_Blackjack.Add(Poker_OnClose)

	Controls.CloseButton:RegisterCallback( Mouse.eLClick, Poker_OnClose);			-- 关闭面板按钮
	Controls.CloseButton:RegisterCallback( Mouse.eMouseEnter, function() UI.PlaySound("Main_Menu_Mouse_Over") end );
	
	Controls.HITButton:RegisterCallback( Mouse.eLClick, OnHITButton);		-- 玩家要牌按钮
	Controls.HITButton:RegisterCallback( Mouse.eMouseEnter, function() UI.PlaySound("Main_Menu_Mouse_Over") end );
	
	Controls.StandButton:RegisterCallback( Mouse.eLClick, OnStandButton);		-- 玩家停牌按钮
	Controls.StandButton:RegisterCallback( Mouse.eMouseEnter, function() UI.PlaySound("Main_Menu_Mouse_Over") end );
	
	Controls.RestartButton:RegisterCallback( Mouse.eLClick, Restart);			-- 重新开始下一把
	Controls.RestartButton:RegisterCallback( Mouse.eMouseEnter, function() UI.PlaySound("Main_Menu_Mouse_Over") end );
	
	Controls.Bet_20_Button:SetVoid1(20)
	Controls.Bet_20_Button:RegisterCallback( Mouse.eLClick, OnBet);			-- 下注
	Controls.Bet_20_Button:RegisterCallback( Mouse.eMouseEnter, function() UI.PlaySound("Main_Menu_Mouse_Over") end );

	Controls.Bet_100_Button:SetVoid1(100)
	Controls.Bet_100_Button:RegisterCallback( Mouse.eLClick, OnBet);			-- 下注
	Controls.Bet_100_Button:RegisterCallback( Mouse.eMouseEnter, function() UI.PlaySound("Main_Menu_Mouse_Over") end );

	Controls.Bet_500_Button:SetVoid1(500)
	Controls.Bet_500_Button:RegisterCallback( Mouse.eLClick, OnBet);			-- 下注
	Controls.Bet_500_Button:RegisterCallback( Mouse.eMouseEnter, function() UI.PlaySound("Main_Menu_Mouse_Over") end );

	Controls.Bet_Double_Button:SetVoid1(-1)
	Controls.Bet_Double_Button:RegisterCallback( Mouse.eLClick, OnBet);			-- 下注
	Controls.Bet_Double_Button:RegisterCallback( Mouse.eMouseEnter, function() UI.PlaySound("Main_Menu_Mouse_Over") end );
	
	-- Controls.PokerOpenButton:RegisterCallback(Mouse.eLClick, Poker_OnOpen);		-- 打开按钮
	-- Controls.PokerOpenButton:RegisterCallback( Mouse.eMouseEnter, function() UI.PlaySound("Main_Menu_Mouse_Over") end );

--	Controls.NoCashLimitCheck:RegisterCallback(Mouse.eLClick, OnNoCashLimitCheck);
end
-- if Controls.PokerOpenButton ~= nil then
-- 	Poker_Initialize()
-- end