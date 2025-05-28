--TOGGLES--
local toggle = action_wheel:newPage()

toggle:newAction()
:toggled(config:load("Wings"))
:title("Toggle Wings")
:item("minecraft:elytra")
:onToggle(function ()
    pings.ToggleWings(not Wings) end)

toggle:newAction()
:toggled(config:load("Horn"))
:title("Toggle Horn")
:item("minecraft:end_rod")
:onToggle(function () 
    pings.ToggleHorn(not Horn) end)


toggle:newAction()
:toggled(config:load("Magic"))
:title("Toggle Magic")
:item("minecraft:nether_star")
:onToggle(function () 
    pings.ToggleMagic(not Magic) end)

--EMOTES--
local emotes = action_wheel:newPage()

emotes:newAction()
:title("Yee-Haw")
:item("minecraft:lead")
:onLeftClick(function ()
    pings.Yee_Haw()
end)
function pings.Yee_Haw()
    if emote == 1 then
        emote = 0
    else
        emote = 1
    end
end

emotes:newAction()
:title("Sit")
:item("minecraft:oak_stairs")
:onLeftClick(function ()
    pings.sit()
end)
function pings.sit()
    if emote == 2 then
        emote = 0
    else
        emote = 2
    end
end

emotes:newAction()
:title("Dance")
:item("minecraft:music_disc_blocks ")
:onLeftClick(function ()
    pings.dance()
end)
function pings.dance()
    if emote == 3 then
        emote = 0
    else
        emote = 3
    end
end

emotes:newAction()
:title("Spin")
:item("minecraft:nautilus_shell")
:onLeftClick(function ()
    pings.spin()
end)
function pings.spin()
    if emote == 4 then
        emote = 0
    else
        emote = 4
    end
end

emotes:newAction()
:title("Loaf")
:item("minecraft:bread")
:onLeftClick(function ()
    pings.loaf()
end)
function pings.loaf()
    if emote == 5 then
        emote = 0
    else
        emote = 5
    end
end

emotes:newAction()
:title("Gangnam Style")
:item("minecraft:music_disc_stal")
:onLeftClick(function ()
    pings.gStyle()
end)
function pings.gStyle()
    if emote == 6 then
        emote = 0
    else
        emote = 6
    end
end

--ROOT--
local rootPage = action_wheel:newPage()

rootPage:newAction()
:title("Toggles")
:item("minecraft:stone_button")
:onLeftClick(function ()
    action_wheel:setPage(toggle)
end)

rootPage:newAction()
:title("Emotes")
:item("minecraft:jukebox")
:onLeftClick(function ()
    action_wheel:setPage(emotes)
end)


events.TICK:register(function()
    if not action_wheel:isEnabled() then
       action_wheel:setPage(rootPage)
    end
end)

action_wheel:setPage(rootPage)
