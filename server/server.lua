local staffTag = false
local staffTable = { 0 }

--print(table.unpack(staffTable))

RegisterCommand("staff", function(source, args, rawCommand)
    if IsPlayerAceAllowed(source, "jd.staff") then
        -- Add player to Staff table
        TriggerClientEvent("staffTag", source, source)
        if has_value(staffTable, source) then
            removebyKey(staffTable, source)
        else
            table.insert(staffTable, source)
        end
        --print(table.unpack(staffTable))
        TriggerClientEvent("sendStaff", -1, staffTable)
    else
        TriggerClientEvent('chat:addMessage', source, {color = { 0, 125, 255},multiline = false, args = {"[JD_PlayerID]", "You're ^*^1Not^0^r allowed to use this command!"}})
    end
end)

function has_value (tab, val)
    for i, v in ipairs (tab) do
        if (v == val) then
            return true
        end
    end
    return false
end

function removebyKey(tab, val)
    for i, v in ipairs (tab) do 
        if (v == val) then
          tab[i] = nil
        end
    end
end

AddEventHandler('playerDropped', function (reason)
    print("Player" .. GetPlayerName(source) .. "removed from staff table (Reason: " .. reason .. ")")
    removebyKey(staffTable, source)
  end)

RegisterCommand("seeTags", function(source, args, rawCommand)
    if IsPlayerAceAllowed(source, "jd.staff") then
        TriggerClientEvent("seeTags", source)
    else
        TriggerClientEvent('chat:addMessage', source, {color = { 0, 125, 255},multiline = false, args = {"[JD_PlayerID]", "You're ^*^1Not^0^r allowed to use this command!"}})
    end
end)

RegisterCommand("showTags", function(source, args, rawCommand)
    TriggerClientEvent("showTags", source)
end)

-- version check
Citizen.CreateThread(
	function()
		local vRaw = LoadResourceFile(GetCurrentResourceName(), 'version.json')
		if vRaw and Config.versionCheck then
			local v = json.decode(vRaw)
			PerformHttpRequest(
				'https://raw.githubusercontent.com/JokeDevil/JD_playerID/master/version.json',
				function(code, res, headers)
					if code == 200 then
						local rv = json.decode(res)
						if rv.version ~= v.version then
							print(
								([[^1
-------------------------------------------------------
JD_playerID
UPDATE: %s AVAILABLE
CHANGELOG: %s
-------------------------------------------------------
^0]]):format(
									rv.version,
									rv.changelog
								)
							)
						end
					else
						print('^1JD_playerID unable to check version^0')
					end
				end,
				'GET'
			)
		end
	end
)