--[[

Lone Wanderer (Trinket) : "I don't need friends". Coded by Plaffy46, artwork by XXX

- Prevents familiar items from spawning in item pools.
- Gives +1 damage and +1 tears up if you don't currently have familiars.

]]

Pools = {
		["familiar"] = {
			-- The default angel room item pool.. obviously..
			{ id = 33, weight = 1 },
			{ id = 72, weight = 1 },
			{ id = 98, weight = 1 },
			{ id = 101, weight = 1 },
			{ id = 108, weight = 1 },
			{ id = 112, weight = 1 },
			{ id = 124, weight = 1 },
			{ id = 142, weight = 1 },
			{ id = 146, weight = 1 },
			{ id = 156, weight = 1 },
			{ id = 162, weight = 1 },
			{ id = 173, weight = 1 },
			{ id = 178, weight = 1 },
			{ id = 182, weight = 1 },


local modItem = Isaac.GetItemIdByName("Lone Wanderer")--TODO
--local bhEntity = Isaac.GetEntityTypeByName("CP_BlackHole")

local loneWandererMod = RegisterMod( "Lone Wanderer", 1)

local HasLoneWanderer = false
local HasFriends = false



local checks = {
	is_greed_mode = function() return game.Difficulty == Difficulty.DIFFICULTY_GREED end,
	is_greedier_mode = function() return game.Difficulty == Difficulty.DIFFICULTY_GREEDIER end,
	is_collectible = function(e) return e.Type == EntityType.ENTITY_PICKUP and e.Variant == PickupVariant.PICKUP_COLLECTIBLE end,
	is_breakfast = function(e)
		local _is_collectible = e.Type == EntityType.ENTITY_PICKUP and e.Variant == PickupVariant.PICKUP_COLLECTIBLE
		
		if _is_collectible then
			return e.SubType == CollectibleType.COLLECTIBLE_BREAKFAST
		end
		
		return false
	end,
	is_active_item = function(e)
		if tonumber(e) ~= nil then
			for a = 1, #InfiniteItemPool_pools.Items.Actives do
				if e == InfiniteItemPool_pools.Items.Actives[a].id then
					return true
				end
			end
		else
			local _is_collectible = e.Type == EntityType.ENTITY_PICKUP and e.Variant == PickupVariant.PICKUP_COLLECTIBLE
			
			if _is_collectible then
				for a = 1, #InfiniteItemPool_pools.Items.Actives do
					if e.SubType == InfiniteItemPool_pools.Items.Actives[a].id then
						return true
					end
				end
			end
		end
		
		return false
	end,
	has_chaos = function(p) return p:HasCollectible(CollectibleType.COLLECTIBLE_CHAOS) end,
	is_golden_chest = function(e) return e.Type == EntityType.ENTITY_PICKUP and e.Variant == PickupVariant.PICKUP_LOCKEDCHEST end,
	is_red_chest = function(e) return e.Type == EntityType.ENTITY_PICKUP and e.Variant == PickupVariant.PICKUP_REDCHEST end,
	is_stone_chest = function(e) return e.Type == EntityType.ENTITY_PICKUP and e.Variant == PickupVariant.PICKUP_BOMBCHEST end,
	is_angel_room = function() return game:GetRoom():GetType() == RoomType.ROOM_ANGEL end,
	is_devil_room = function() return game:GetRoom():GetType() == RoomType.ROOM_DEVIL end,
	is_challenge_room = function() return game:GetRoom():GetType() == RoomType.ROOM_CHALLENGE end,
	is_dungeon_room = function() return game:GetRoom():GetType() == RoomType.ROOM_DUNGEON end,
	is_shop_room = function() return game:GetRoom():GetType() == RoomType.ROOM_SHOP end,
	is_treasure_room = function() return game:GetRoom():GetType() == RoomType.ROOM_TREASURE end,
	is_boss_rush = function() return game:GetRoom():GetType() == RoomType.ROOM_BOSSRUSH end,
	is_curse_room = function() return game:GetRoom():GetType() == RoomType.ROOM_CURSE end,
	is_secret_room = function() return game:GetRoom():GetType() == RoomType.ROOM_SECRET end,
	is_super_secret_room = function() return game:GetRoom():GetType() == RoomType.ROOM_SUPERSECRET end,
	is_library_room = function() return game:GetRoom():GetType() == RoomType.ROOM_LIBRARY end,
	is_black_market = function() return game:GetRoom():GetType() == RoomType.ROOM_BLACK_MARKET end,
	is_boss_room = function() return game:GetRoom():IsCurrentRoomLastBoss() end,
	check_room = function(room, room_type) return room:GetType() == room_type end,
	compare_rooms = function(room_index, entity_count) return level_room_entities[tostring(room_index)] ~= entity_count end,
	has_no_trinket = function(p) return p:HasTrinket(TrinketType.TRINKET_NO) end



function loneWandererMod:entity_tasks()
	local level = game:GetLevel()
	local level_room_index = level:GetCurrentRoomIndex()
	local entities = Isaac.GetRoomEntities()
	local is_greed_mode = checks.is_greed_mode() or checks.is_greedier_mode()
	
	
	if checks.compare_rooms(level_room_index, #entities) then
		for a = 1, #entities do
			local entity = entities[a]
			
			if checks.is_breakfast(entity) then
				if breakfast_count > 3 then
					if checks.is_angel_room() then
						if is_greed_mode then
							spawn_collectible(get_collectible_from_pool(InfiniteItemPool_pools.Pools["greedAngel"]), entity.Position)
						else
						
						
						
						
loneWandererMod:AddCallback(ModCallbacks.MC_POST_UPDATE, loneWandererMod.entity_tasks)