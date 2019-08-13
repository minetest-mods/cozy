local function freeze(player)
        if minetest.global_exists("player_monoids") then
                player_monoids.speed:add_change(player, 0, "cozy:speed")
                player_monoids.jump:add_change(player, 0, "cozy:jump")
                player_monoids.gravity:add_change(player, 0, "cozy:gravity")
        else
                player:set_physics_override({speed = 0, jump = 0, gravity = 0})
        end
end

local function unfreeze(player)
        if minetest.global_exists("player_monoids") then
                player_monoids.speed:del_change(player, "cozy:speed")
                player_monoids.jump:del_change(player, "cozy:jump")
                player_monoids.gravity:del_change(player, "cozy:gravity")
        else
                player:set_physics_override({speed = 1, jump = 1, gravity = 1})
        end
end

minetest.register_globalstep(function(dtime)
        local players = minetest.get_connected_players()
        for i=1, #players do
                local player = players[i]
                local name = player:get_player_name()
                local control = player:get_player_control()
                if default.player_attached[name] and not player:get_attach() and (
                        control.up == true or
                        control.down == true or
                        control.left == true or
                        control.right == true or
                        control.jump == true
                ) then
                        players[i]:set_eye_offset({x=0, y=0, z=0}, {x=0, y=0, z=0})
                        unfreeze(player)
                        default.player_attached[name] = false
                        default.player_set_animation(players[i], "stand", 30)
                end
        end
end)

minetest.register_chatcommand("sit", {
        description = "Sit down",
        func = function(name)
                local player = minetest.get_player_by_name(name)
                if default.player_attached[name] then
                        player:set_eye_offset({x=0, y=0, z=0}, {x=0, y=0, z=0})
                        unfreeze(player)
                        default.player_attached[name] = false
                        default.player_set_animation(player, "stand", 30)
                else
                        player:set_eye_offset({x=0, y=-7, z=2}, {x=0, y=0, z=0})
                        freeze(player)
                        default.player_attached[name] = true
                        default.player_set_animation(player, "sit", 30)
                end
        end
})

minetest.register_chatcommand("lay", {
        description = "Lay down",
        func = function(name)
                local player = minetest.get_player_by_name(name)
                if default.player_attached[name] then
                        player:set_eye_offset({x=0, y=0, z=0}, {x=0, y=0, z=0})
                        unfreeze(player)
                        default.player_attached[name] = false
                        default.player_set_animation(player, "stand", 30)
                else
                        player:set_eye_offset({x=0, y=-13, z=0}, {x=0, y=0, z=0})
                        freeze(player)
                        default.player_attached[name] = true
                        default.player_set_animation(player, "lay", 0)
                end
        end
})

