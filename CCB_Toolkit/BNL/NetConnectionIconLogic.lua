-------------------------------------------------
-- Network Connection Logic
-- 
-- Common scripting logic used for updating player network connection status.
-- IE, network connection icons, labels, etc.
-------------------------------------------------
-- Connection Icon Strings
local PlayerConnectedStr = Locale.Lookup( "LOC_MP_PLAYER_CONNECTED" );
local PlayerConnectingStr = Locale.Lookup( "LOC_MP_PLAYER_CONNECTING" );
local PlayerNotConnectedStr = Locale.Lookup( "LOC_MP_PLAYER_NOTCONNECTED" );
local PlayerNotModReadyStr = Locale.Lookup( "LOC_MP_PLAYER_NOT_MOD_READY" );
local PlayerResyncingStr = Locale.Lookup( "LOC_MP_PLAYER_RESYNCING" );

-- Connection Label Strings.
local PlayerConnectedSummaryStr = Locale.Lookup( "LOC_MP_PLAYER_CONNECTED_SUMMARY" );
local PlayerConnectingSummaryStr = Locale.Lookup( "LOC_MP_PLAYER_CONNECTING_SUMMARY" );
local PlayerNotConnectedSummaryStr = Locale.Lookup( "LOC_MP_PLAYER_NOTCONNECTED_SUMMARY" );
local PlayerNotModReadySummaryStr = Locale.Lookup( "LOC_MP_PLAYER_NOT_MOD_READY_SUMMARY" );
local PlayerResyncingSummaryStr = Locale.Lookup( "LOC_MP_PLAYER_RESYNCING_SUMMARY" );

-- Ping Time Strings
local secondsStr = Locale.Lookup( "LOC_TIME_SECONDS" );
local millisecondsStr = Locale.Lookup( "LOC_TIME_MILLISECONDS" );

local PING_GREAT	= 100; -- [Milliseconds] Player's ping is considered to be great (green) if under this number.
local PING_OK		= 200; -- [Milliseconds] Player's ping is considered to be ok (yellow) if under this number.

----------------------------------------------------------------
-- UpdateNetConnectionIcon
-- Remember to call UpdateNetConnectionIcon when...
-- * Creating a new icon.
-- * For all icons on a MultiplayerPingTimesChanged event.
----------------------------------------------------------------
function UpdateNetConnectionIcon(playerID :number, connectIcon)
	-- Update network connection status
	local pPlayerConfig = PlayerConfigurations[playerID];
	local slotStatus = pPlayerConfig:GetSlotStatus();
	
	if(slotStatus == SlotStatus.SS_TAKEN or slotStatus == SlotStatus.SS_OBSERVER) then
		-- build ping string
		local iPingTime = Network.GetPingTime( playerID );
		
		local pingStr = "";
		if(playerID ~= Network.GetLocalPlayerID()) then
			if (iPingTime < 1000) then
				pingStr = " " .. tostring(iPingTime) .. millisecondsStr;
			else
				pingStr = " " .. tostring(iPingTime/1000) .. secondsStr;
			end
		end
		connectIcon:SetHide(false);
		if(Network.IsPlayerHotJoining(playerID)) then
			-- Player is hot joining.
			connectIcon:SetString("[ICON_HotjoiningPip]");
			connectIcon:SetToolTipString( PlayerConnectingStr ..  pingStr);
		elseif(Network.IsPlayerConnected(playerID)) then
			if(not pPlayerConfig:GetModReady()) then
				-- Player is not mod ready yet
				connectIcon:SetString("[ICON_NotModReadyPip]");
				connectIcon:SetToolTipString( PlayerNotModReadyStr .. pingStr );
			elseif(Network.IsPlayerResyncing(playerID)) then
				connectIcon:SetString("[ICON_ResyncingPip]");
				connectIcon:SetToolTipString( PlayerResyncingStr .. pingStr );
			else
				-- fully connected
				-- icon changes based on ping time and pause state.
				if(pPlayerConfig:GetWantsPause()) then
					if(iPingTime <= 1 and playerID ~= Network.GetLocalPlayerID()) then				--!! 如果小于等于1，则黑灯
						connectIcon:SetString("[ICON_OfflinePip]");
					elseif(iPingTime < PING_GREAT) then -- green
						connectIcon:SetString("[ICON_PausedGreenPingPip]");
					elseif(iPingTime < PING_OK) then -- yellow
						connectIcon:SetString("[ICON_PausedYellowPingPig]");
					else -- red
						connectIcon:SetString("[ICON_PausedRedPingPig]");
					end
				else
					if(iPingTime <= 1 and playerID ~= Network.GetLocalPlayerID()) then		--!! 如果小于等于1，则黑灯
						connectIcon:SetString("[ICON_OfflinePip]");
					elseif(iPingTime < PING_GREAT) then -- green
						connectIcon:SetString("[ICON_OnlineGreenPingPip]");
					elseif(iPingTime < PING_OK) then -- yellow
						connectIcon:SetString("[ICON_OnlineYellowPingPig]");
					else -- red
						connectIcon:SetString("[ICON_OnlineRedPingPig]");
					end
				end	
				
				connectIcon:SetToolTipString( PlayerConnectedStr .. pingStr );
			end
		else
			-- Not connected
			connectIcon:SetString("[ICON_OfflinePip]");
			connectIcon:SetToolTipString( PlayerNotConnectedStr );		
		end		
  else
		connectIcon:SetHide(true);
  end
end

----------------------------------------------------------------
-- UpdateNetConnectionLabel
-- Remember to call UpdateNetConnectionLabel when...
-- * Creating a network connection label.
----------------------------------------------------------------
function UpdateNetConnectionLabel(playerID :number, connectLabel :table)
	-- Update network connection status
	local pPlayerConfig = PlayerConfigurations[playerID];
	local slotStatus = pPlayerConfig:GetSlotStatus();
	if(slotStatus == SlotStatus.SS_TAKEN or slotStatus == SlotStatus.SS_OBSERVER) then
		local statusString :string;
		local tooltipString :string;
		if(Network.IsPlayerHotJoining(playerID)) then
			-- Player is hot joining.
			statusString = PlayerConnectingSummaryStr;
			tooltipString = PlayerConnectingStr;
		elseif(Network.IsPlayerConnected(playerID)) then
			if(not pPlayerConfig:GetModReady()) then
				statusString = PlayerNotModReadySummaryStr;
				tooltipString = PlayerNotModReadyStr;
			elseif(Network.IsPlayerResyncing(playerID)) then
				statusString = PlayerResyncingSummaryStr;
				tooltipString = PlayerResyncingStr;
			else
				-- Player is fully connected.
				statusString = PlayerConnectedSummaryStr;
				tooltipString = PlayerConnectedStr;
			end
		else
			-- Not connected
			statusString = PlayerNotConnectedSummaryStr;
			tooltipString = PlayerNotConnectedStr;
		end	
		
		connectLabel:SetText(statusString);
		connectLabel:SetToolTipString(tooltipString);
	end
end