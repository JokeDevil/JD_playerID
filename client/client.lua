local id = 0
local ShowTag = false
local showTags = true
local seeTags = false
local isDriver = false
local staffTable = { 0 }

RegisterNetEvent('staffTag')
AddEventHandler('staffTag', function(playerID)
	if staffTag then
		staffTag = false
		TriggerEvent('chat:addMessage', {color = { 0, 125, 255},multiline = false,args = {"[JD_PlayerID]", "Staff tag ^*^1Disabled^0"}})
	else
		staffTag = true
		TriggerEvent('chat:addMessage', {color = { 0, 125, 255},multiline = false,args = {"[JD_PlayerID]", "Staff tag ^*^2Enabled^0"}})
	end
end)

RegisterNetEvent('sendStaff')
AddEventHandler('sendStaff', function(_staffTable)
	staffTable = _staffTable
end)


RegisterNetEvent('showTags')
AddEventHandler('showTags', function()
	if showTags then
		showTags = false
		TriggerEvent('chat:addMessage', {color = { 0, 125, 255},multiline = false,args = {"[JD_PlayerID]", "Player tags ^*^1Disabled^0"}})
	else
		showTags =  true
		TriggerEvent('chat:addMessage', {color = { 0, 125, 255},multiline = false,args = {"[JD_PlayerID]", "Player tags ^*^2Enabled^0"}})
	end
end)

RegisterNetEvent('seeTags')
AddEventHandler('seeTags', function()
	if seeTags then
		seeTags = false
		TriggerEvent('chat:addMessage', {color = { 0, 125, 255},multiline = false,args = {"[JD_PlayerID]", "Player tags trough walls ^*^1Disabled^0"}})
	else
		seeTags =  true
		TriggerEvent('chat:addMessage', {color = { 0, 125, 255},multiline = false,args = {"[JD_PlayerID]", "Player tags trough walls ^*^2Enabled^0"}})
	end
end)

function ManageHeadLabels()
	for i = 0, 255 do
		if NetworkIsPlayerActive(i) then
			local iPed = GetPlayerPed(i)
			local lPed = PlayerPedId()
			if iPed ~= lPed then-- EDIT!!!
				if DoesEntityExist(iPed) then
					distance = math.ceil(GetDistanceBetweenCoords(GetEntityCoords(lPed), GetEntityCoords(iPed)))
					if HasEntityClearLosToEntity(iPed, lPed, 17) or seeTags then
						if distance < disPlayerNames and showTags then
							if NetworkIsPlayerTalking(i) then
								headDisplayId = N_0xbfefe3321a3f5015(iPed, "", false, false, "", false )
								SetMpGamerTagAlpha(headDisplayId, 4, 225)							
								SetMpGamerTagVisibility(headDisplayId, 4, true)
							else
								headDisplayId = N_0xbfefe3321a3f5015(iPed, "", false, false, "", false )
								if has_value(staffTable,GetPlayerServerId(i)) then 
									SetMpGamerTagName(headDisplayId,DisplayStaffTag.." "..GetPlayerServerId(i).." | "..GetPlayerName(i))
									SetMpGamerTagColour(headDisplayId, 0, 6)
								else
									SetMpGamerTagColour(headDisplayId, 0, 0)
									SetMpGamerTagName(headDisplayId,GetPlayerServerId(i).." | "..GetPlayerName(i))
								end
								if driverID == GetPlayerServerId(i) then

								else

								end
								SetMpGamerTagVisibility(headDisplayId, 4, false)
								SetMpGamerTagVisibility(headDisplayId, 0, true)
							end
						else
							headDisplayId = N_0xbfefe3321a3f5015(iPed, "", false, false, "", false )
							SetMpGamerTagName(headDisplayId,GetPlayerServerId(i).." | "..GetPlayerName(i))
							SetMpGamerTagVisibility(headDisplayId, 0, false)
							SetMpGamerTagVisibility(headDisplayId, 7, false)
						end
					end
				end
			end
		end
	end
end

function has_value (tab, val)
    for i, v in ipairs (tab) do
        if (v == val) then
            return true
        end
    end
    return false
end


Citizen.CreateThread(function()
	while true do
		ManageHeadLabels()
		Citizen.Wait(0)
	end
end)