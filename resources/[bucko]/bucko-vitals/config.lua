Config = {}

-- This resource is a passive bridge: it listens for the same 'hospital:server:*'
-- events that qb-ambulancejob already fires when a player goes into laststand or
-- dies, so qb-ambulancejob itself never needs to be modified.

Config.ReviveInterval = 360 -- Must match qb-ambulancejob's Config.ReviveInterval (client/config.lua)
Config.MinimumRevive = 300  -- Must match qb-ambulancejob's Config.MinimumRevive

Config.Radius = 15.0        -- How close (in meters) a player needs to be to see the vitals UI
Config.UpdateInterval = 0   -- Ms between position refreshes while at least one downed player is visible (0 = every frame)
Config.IdleInterval = 500   -- Ms between checks while no downed players are visible nearby
