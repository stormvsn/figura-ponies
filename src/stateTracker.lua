require("initValues")


Horn = config:load("Horn")
-- can't do for example `Horn = config:load("Horn") or GetDefaultHorn()` here to detect nil, because false is a valid config value
if Horn == nil then
    Horn = GetDefaultHorn()
end
Wings = config:load("Wings")
if Wings == nil then
    Wings = GetDefaultWings()
end
Magic = config:load("Magic")
if Magic == nil then
    Magic = GetDefaultMagic()
end

---On host, tracks whether this avatar was flying last tick.
---On client, tracks whether this avatar is currently flying.
local isFlying = false

--[[
    Update whether this avatar has a horn. On the host, this also updates the persistent config.
    pings.ToggleHorn can be used to update clients also.
]]

---Update whether this avatar has a horn. On the host, this also updates the persistent config.
---pings.ToggleHorn can be used to update clients also.
---@param state boolean Should avatar have a horn?
function ToggleHorn(state)
    Horn = state
    models.pony.Root.body.neck.head.horn:setVisible(state)
    if host:isHost() then
        config:save("Horn", state)
    end
end

---Update whether this avatar has wings. On the host, this also updates the persistent config.
---pings.ToggleWings can be used to update clients also.
---@param state boolean Should avatar have wings?
function ToggleWings(state)
    Wings = state
    models.pony.Root.body.left_wing:setVisible(state)
    models.pony.Root.body.right_wing:setVisible(state)
    if state then
        models.pony.Root.body.left_wing:setUVPixels(0, 0)
        models.pony.Root.body.right_wing:setUVPixels(0, 0)
    else
        models.pony.Root.body.left_wing:setUVPixels(0, 14)
        models.pony.Root.body.right_wing:setUVPixels(0, 14)
    end
    if host:isHost() then
        config:save("Wings", state)
    end
end

---Update whether this avatar uses telekinesis to hold objects. On the host, this also updates the persistent config.
---pings.ToggleMagic can be used to update clients also.
---@param state boolean Should avatar have a magic aura/use TK?
function ToggleMagic(state)
    Magic = state
    models.pony.Root.right_front_leg.RIGHT_ITEM_PIVOT:setVisible(not state)
    models.pony.Root.left_front_leg.LEFT_ITEM_PIVOT:setVisible(not state)
    if state then -- Magic Aura
        models.pony.Root.left_front_leg:offsetRot(0,0,0)
        models.pony.Root.right_front_leg:offsetRot(0,0,0)
    else
        models.pony.RightArm.RightArm:setVisible(false)
        models.pony.LeftArm.LeftArm:setVisible(false)
        models.pony.Root.body.neck.head.horn_glow:setVisible(false)
    end
    if host:isHost() then
        config:save("Magic", state)
    end
end

---Update whether the avatar is currently flying.
---pings.ToggleFlying can be used to update clients also.
---@param state boolean Is the avatar flying?
function ToggleFlying(state)
    isFlying = state
end

---Get whether the avatar was last seen flying
---@return boolean isFlying Last seen flying status
function FlyingState()
    return isFlying
end

pings.ToggleHorn = ToggleHorn
pings.ToggleWings = ToggleWings
pings.ToggleMagic = ToggleMagic
pings.ToggleFlying = ToggleFlying
ToggleHorn(Horn) --not using the pings here, clients will be updated on entity_init
ToggleWings(Wings)
ToggleMagic(Magic)
ToggleFlying(isFlying)

---Send new values for Horn, Wings, Magic, and isFlying to clients.
---@param hornState boolean Should avatar have a horn?
---@param wingsState boolean Should avatar have wings?
---@param magicState boolean Should avatar have a magic aura/use TK?
---@param flyingState boolean Last seen flying status
function pings.fullUpdate(hornState, wingsState, magicState, flyingState)
    ToggleHorn(hornState)
    ToggleWings(wingsState)
    ToggleMagic(magicState)
    ToggleFlying(flyingState)
end

function events.entity_init()
    pings.fullUpdate(Horn,Wings,Magic,isFlying)
end

if host:isHost() then
    local tick = 0
    -- I could see putting this as part of the TICK event in locomotion instead?
    events.TICK:register(function()
        tick = tick + 1
        if tick > 19 then
            pings.fullUpdate(Horn,Wings,Magic,isFlying)
            tick = 0
        end
    end, "TICK_COUNTER")
end