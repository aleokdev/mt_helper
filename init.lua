-- Array of what triggers what. Here's the syntax:
-- "priv that the user has to have", {"words that the", "player must say", "to trigger the message"}, "message triggered when conditions are met"
-- Additionally, if you want the message to trigger when an user DOESN'T have a priv, put a ! before the first argument, like this: "!priv"
triggers = {{"!interact", {"exit", "library", "out", "build"},"Please read the rules and find the keyword to exit this place!"}}

local function checkForKeywordsInMessage(msg, keywords)
	for ii,keyword in ipairs(keywords) do
		if string.match(msg, keyword) then
			return true
		end
	end
	return false
end

minetest.register_on_chat_message(function(name, message)
	local player = minetest.get_player_by_name(name) -- Get player by name

	if player:get_attribute("help_msgs_switch") == nil then -- If the help switch is nil, turn it on
		player:set_attribute("help_msgs_switch", "on")
	end
	if player:get_attribute("help_msgs_switch") == "on" then -- Show help messages if switch is on
		for i=1,#triggers,1 do
			triggerPriv = triggers[i][1]
			keywords = triggers[i][2]
			messageToSay = triggers[i][3]
			if triggerPriv:sub(1,1) == "!" then -- Check if triggerPriv starts with !
				if not minetest.check_player_privs(name, triggerPriv:sub(2,#triggerPriv)) and checkForKeywordsInMessage(message, keywords) then
					minetest.chat_send_player(name, messageToSay)
				end
			else
				if minetest.check_player_privs(name, triggerPriv) and checkForKeywordsInMessage(message,keywords) then
					minetest.chat_send_player(name, messageToSay)
				end
			end
		end
	end
end)

minetest.register_chatcommand("helpmsgs", {
	params = "",
	description = "Toggle help messages on or off.",
	func = function(name,param)
			local player = minetest.get_player_by_name(name)
			if player:get_attribute("help_msgs_switch") == nil then -- If the help switch is nil, turn it on
				player:set_attribute("help_msgs_switch", "on")
			end
			player:set_attribute("help_msgs_switch", player:get_attribute("help_msgs_switch")=="on" and "off" or "on") -- Toggle the help switch
			return true, "Help messages turned " .. player:get_attribute("help_msgs_switch") .. " successfully!"
	end,
})