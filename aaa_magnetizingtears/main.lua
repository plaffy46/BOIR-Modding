--[[

Magnetizing Tears : "Make your enemies attractive". Coded by Plaffy46, artwork by XXX

- You can now shoot magnetizing tears. Magneted enemies will physically attract nearby enemies.
- Attraction range is based on your Range stat, attraction force is based on your Shot speed stat.
- There's a (10 + Luck * 2)% chance of firing a magnetizing tear.

]]

local modItem = Isaac.GetItemIdByName("Magnet Tears")--TODO
--local bhEntity = Isaac.GetEntityTypeByName("CP_magnetTears")

local magnetTearsMod = RegisterMod( "Magnet Tears", 1)

local HasMagnetTears = false

--White color TODO
--local magnetTears_costume = Isaac.GetCostumeIdByPath("gfx/characters/costume_magnettears.anm2")--TODO

--[[
local lastRoom
local duration = 180
local maxAffectDistance = 280
local damageAmount = 0

function clamp(val, min, max) 
  if val<min then return min end
  if val>max then return max end
  return val
end

function vmagn(vec)
  return math.sqrt(vec.X*vec.X+vec.Y*vec.Y)
end

function clampMagn(vec, max)
  local l = vmagn(vec)
  if l>max then
    return vec:Normalized():__mul(max)
  end
  return vec
end

function SafeNormalize(vec)
  if vmagn(vec:Normalized())>vmagn(vec) then
    return vec
  end
  return vec:Normalized()
end

]]

--[[function PrepareEntity(ent)
  ent:ToNPC().CanShutDoors = false
  ent:ClearEntityFlags(EntityFlag.FLAG_APPEAR)
  ent:AddEntityFlags(EntityFlag.FLAG_NO_BLOOD_SPLASH)
  ent.EntityCollisionClass = EntityCollisionClass.ENTCOLL_NONE;
  ent.GridCollisionClass =  --[[GridCollisionClass.COLLISION_PIT and 
                            GridCollisionClass.COLLISION_WALL and
                            GridCollisionClass.COLLISION_OBJECT and]]--
                            GridCollisionClass.COLLISION_WALL_EXCEPT_PLAYER
end]]


--[[function magnetTearsMod:PostUpdate()
  local player = Isaac.GetPlayer(0)
  local entities = Isaac.GetRoomEntities()
 
 -- if HasMagnetTears then
  for i=1, # entities do
    if entities[i].Type == EntityType.ENTITY_TEAR or entities[i].Type == EntityType.ENTITY_LASER then --tears and laser?
        local tear = entities[i]
			if tear:GetData().Magnet == nil then
				if math.random(100) < 8 + player.Luck * 2 then
					tear:GetData().Magnet = true
				if entities[i].Type == EntityType.ENTITY_TEAR and entities[i].FrameCount == 1 then --normal tears = sprite change
			
					local sprite = entities[i]:GetSprite()
                --sprite:Load("gfx/placeholder_magnet.anm2", true)
				--OR
				--sprite:AttachSprite("gfx/placeholder_magnet.anm2", true)
	
                sprite:PlayRandom(8)
                sprite.PlaybackSpeed = 2.5
				
			else --laser tears = color change
				tear:SetColor(WhiteColor ,0 ,50, false, false)
          else
            tear:GetData().Magnet = false
          end
        end
		
      end
--]]

--[[OnDamage : Check if an enemy go damaged by one our tears/lasers, and then apply the magneted effect flag if that tear laser has the magnet effect.

--]]

function magnetTearsMod:onDamage(entity, amt, flag, source, countdown)
  if entity:GetData().Magneted then return end
  if entity.Type == EntityType.ENTITY_PLAYER then return end
  local tear = magnetTearsMod.getEntityFromRef(source)
  if tear.Type == EntityType.ENTITY_TEAR then
    
      entity:GetData().Magneted = true
      local succ = Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.PULLING_EFFECT, 0, entity.Position, Vector(0,0), player); succ.Parent = entity;
    end
	
  end
end
	  
--[[function CalculateMagnetForce(ent, bh)
  local sub = bh.Position:__sub(ent.Position)
  local mul = clamp(maxAffectDistance-vmagn(sub), 8, maxAffectDistance)/maxAffectDistance*0.60
  return sub:__mul(mul)
end



 local	entities = Isaac.GetRoomEntities( )
    for i = 1, #entities do
      local properPickup = false
      local mult = 1
      properPickup = entities[i].Type==EntityType.ENTITY_PICKUP and entities[i].Variant~=PickupVariant.PICKUP_COLLECTIBLE
      if properPickup then mult = 0.3 end
      if entities[i].Type==EntityType.ENTITY_PROJECTILE then mult = 0.7 end
      if entities[i].Type==EntityType.ENTITY_PLAYER then
        entities[i]:AddVelocity((npc.Position - entities[i].Position):Normalized()*0.25)
      end
      if entities[i].Type==EntityType.ENTITY_BOMBDROP then
        entities[i]:AddVelocity((npc.Position - entities[i].Position):Normalized()*0.85)
      end
      if entities[ i ]:IsVulnerableEnemy( ) 
      or properPickup
      or entities[i].Type==EntityType.ENTITY_PROJECTILE then
        if entities[i].Mass<60 then
          entities[ i ].Velocity:__mul(0.00001)
          entities[ i ].Velocity = clampMagn(entities[ i ].Velocity, 4)
          entities[i]:AddVelocity(CalculateMagnetTearsForce(entities[i], npc):Rotated(8):__mul(mult))
        end
        local dist = entities[ i ].Position:Distance(npc.Position)
        if dist < 50 and entities[i]:IsVulnerableEnemy() and Game():GetFrameCount()%2==0 then
          entities[i]:TakeDamage(damageAmount, 0, EntityRef(player), 100)
        end
      end
    end


--If player takes damage reset the holding state to false (similair to bobs rotten head)

function magnetTears:Behaviour(npc)
  local player = Isaac.GetPlayer(0)
  --FLYING STATE
  if npc.I2==0 then
    npc.I1 = npc.I1-1
    npc.SpriteOffset = Vector(0, -npc.I1)
    npc.RenderZOffset = npc.I1
    npc.Velocity = npc.V1
    npc.V1 = npc.V1:__mul(0.84)
    npc.Scale = npc.Scale - 0.02
    if npc.I1<=11 then
      npc.I2 = 1
      npc.Velocity = Vector(0,0)
      npc.SpriteOffset = Vector(0, 0)
      Game():SpawnParticles(npc.Position, 43, 1, 0, Color(0.3,0.1,1,1,0,0,0), 0)
      local effect = Isaac.Spawn(effectEntity, 483, 0, npc.Position, Vector(0,0), nil)
      PrepareEntity(effect)
      effect.RenderZOffset = -13999
      effect:GetSprite().PlaybackSpeed = 0.8
      effect:GetSprite():Play("Init", true)
      effect:ToNPC():PlaySound(139, 0.7, 0, false, 0.7) --IMPACT
      effect:ToNPC():PlaySound(311, 0.6, 11, true, 0.4) --LOOP
      npc.EntityRef = effect
      npc.Visible = false
    end
  end
  
  --LANDED STATE
  if npc.I2>=1 then
    local effect = npc.EntityRef
    effect.Color = Color(math.random(), math.random(), math.random(), 1, 0, 0, 0)
    npc.Velocity = Vector(0,0)
    
    effect:ToNPC().Scale = 1.8+math.sin(Game():GetFrameCount()*0.4)*0.15
    if effect:GetSprite():IsFinished("Init") then
      effect:GetSprite():Play("Idle")
    end
    
    local r = 11
    local c = Color(0,0,0,1,0,0,0)
    local p = Vector(math.random(-r*1,r*1), math.random(-r*1,r*1))
    p:Normalize()
    p.Y = p.Y*9
    p.X = p.X*20
    if npc.I2>4 and npc.I2<duration-11 then
      local pos = npc.Position:__add(p)
      local ray = Isaac.Spawn(1000, 597, 0, pos, Vector(0,0), npc)
      local ang = p:GetAngleDegrees()+90
      local reduce = math.abs(p:Normalized():Dot(Vector(0,-1)))*0.45
      ray.SpriteScale = Vector(0.72, 0.79-reduce)
      ray.SpriteRotation = ang
      
      if Game():GetFrameCount()%6 then 
        p = Vector(math.random(-r*4,r*4), math.random(-r*2,r*2))
        Game():SpawnParticles(npc.Position:__add(p), EffectVariant.DARK_BALL_SMOKE_PARTICLE, 1, 5, c, 5) 
      end
      c = Color(0,0,0,1,0,0,0)
      p = Vector(math.random(-r*4,r*4), math.random(-r*2,r*2))
      Game():SpawnParticles(npc.Position:__add(p:__mul(1)), EffectVariant.EMBER_PARTICLE, 1, -3, c, 5) 
    end
    
    if npc.I2==duration-6 then
      effect:GetSprite():Stop()
      effect:GetSprite():SetAnimation("Death")
      effect:GetSprite():Play("Death", true)
      effect:ToNPC():PlaySound(311, 0.0, 0, false, 4) --STOP LOOP
      effect:ToNPC():PlaySound(314, 0.7, 0, false, 1.0) --DEATH
    end
    
    local	entities = Isaac.GetRoomEntities( )
    for i = 1, #entities do
      local properPickup = false
      local mult = 1
      properPickup = entities[i].Type==EntityType.ENTITY_PICKUP and entities[i].Variant~=PickupVariant.PICKUP_COLLECTIBLE
      if properPickup then mult = 0.3 end
      if entities[i].Type==EntityType.ENTITY_PROJECTILE then mult = 0.7 end
      if entities[i].Type==EntityType.ENTITY_PLAYER then
        entities[i]:AddVelocity((npc.Position - entities[i].Position):Normalized()*0.25)
      end
      if entities[i].Type==EntityType.ENTITY_BOMBDROP then
        entities[i]:AddVelocity((npc.Position - entities[i].Position):Normalized()*0.85)
      end
      if entities[ i ]:IsVulnerableEnemy( ) 
      or properPickup
      or entities[i].Type==EntityType.ENTITY_PROJECTILE then
        if entities[i].Mass<60 then
          entities[ i ].Velocity:__mul(0.00001)
          entities[ i ].Velocity = clampMagn(entities[ i ].Velocity, 4)
          entities[i]:AddVelocity(CalculatemagnetTearsForce(entities[i], npc):Rotated(8):__mul(mult))
        end
        local dist = entities[ i ].Position:Distance(npc.Position)
        if dist < 50 and entities[i]:IsVulnerableEnemy() and Game():GetFrameCount()%2==0 then
          entities[i]:TakeDamage(damageAmount, 0, EntityRef(player), 100)
        end
      end
    end
    
    --Rock crushing
    local div = 22
    local width = 32
    local crashStart = math.floor(npc.I2/div) * width
    local crashEnd = crashStart + width
    local gridEntsNum = Game():GetRoom():GetGridSize()
    for i = 1, gridEntsNum do
      local gent = Game():GetRoom():GetGridEntity(i)
      if gent~=nil and gent:ToRock()~=nil and gent.State~=2 then
        local d = (gent.Position - npc.Position):Length()
        if d>crashStart and d<crashEnd then
          if npc.I2%div==div-1 then
            gent:Destroy(true)
          else
            if Game():GetFrameCount()%2==0 then
              Game():SpawnParticles(gent.Position+RandomVector()*3, EffectVariant.DARK_BALL_SMOKE_PARTICLE, 1, 3, Color(0.8,0.8,0.8,1,0,0,0), 1)
            end
          end
        end
      end
    end
    
    npc.I2 = npc.I2 + 1
    if npc.I2>duration then
      npc.EntityRef:Remove()
      npc:Remove()
    end
  end
end
--]]

magnetTears:AddCallback( ModCallbacks.MC_ENTITY_TAKE_DMG, magnetTears.OnDamage, EntityType.ENTITY_PLAYER);