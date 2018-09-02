minetest.register_on_chat_message(function(name, message)
	if name != minetest.check_player_privs(name, "interact") and (string.match(message, "exit") or string.match(message, "library") or string.match(message, "out") or string.match(message, "build")) then
		minetest.chat_send_player(name, "Please read the rules and find the keyword to exit this place!")
	end
end)