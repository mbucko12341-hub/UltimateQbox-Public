Config = {}

Config.TabletItem = 'gangtablet' -- Item required to open the Gang UI
Config.GiveTabletOnLeaderSet = true -- Automatically give a gangtablet when an admin sets a leader

Config.SprayItem = 'spraycan' -- Item required to tag turf
Config.AllowSprayOutsideTurf = true -- If true, gangs can spray walls anywhere (rewards/rep require being in a turf zone)
Config.TagCooldown = 300 -- Seconds between earning turf points/rep in the same zone (5 mins)
Config.TagDuration = 8000 -- 8 seconds to spray a wall
Config.SprayRemoverItem = 'sprayremover' -- Item required to scrub off sprays
Config.ConsumeRemover = true             -- Remove 1 sprayremover per use
Config.RemoveDuration = 6000             -- 6 seconds to scrub a wall clean
Config.RepPerEnemySprayRemoved = 10      -- Gang Rep awarded for scrubbing a RIVAL gang's spray
Config.SprayRenderDistance = 60.0 -- Distance at which wall PNGs render
Config.MaxInviteDistance = 10.0 -- Max distance to invite a player

-- Leave empty for 100% automatic <gang_id>.png detection!
-- (Any gang with ID 'dockers' will automatically use 'web/sprays/dockers.png')
Config.SprayDesigns = {}


Config.TagCooldown = 10 -- Seconds between earning turf points/rep in the same zone (set to 0 for no cooldown)

-- Rewards & Reputation Points given per successful turf tag
Config.TagRewards = {
    moneyType = 'black_money', -- 'cash', 'bank', or 'black_money'
    minReward = 500,
    maxReward = 1500,
    pointsPerTag = 1,        -- Strips 1% turf control per spray (100 sprays to wipe out a turf)
    repPerEnemyTag = 15,     -- Gang Rep earned when spraying inside ANOTHER gang's territory
    repTakeoverBonus = 100,  -- Extra Gang Rep bonus when your final spray destroys an enemy territory
}

-- Gang Stash Configuration
Config.StashSettings = {
    slots = 75,
    weight = 250000, -- 250kg
    propModel = `prop_ld_int_safe_01`,
    requireOwnedCompound = true,
    allowKeybindOpen = true,
}

-- Default Map Blip Colors matching Qbox gang names
Config.GangColors = {
    ['none'] = 0,       -- White (Unclaimed)
    ['ballas'] = 27,    -- Purple
    ['vagos'] = 46,     -- Yellow
    ['families'] = 2,   -- Green
    ['marabunta'] = 3,  -- Blue
    ['lostmc'] = 1,     -- Red
}

-- Default Territory / Compound Zones
Config.Territories = {
    ['groove_street'] = {
        label = 'Grove Street Compound',
        coords = vec3(105.24, -1940.12, 20.8),
        radius = 110.0,
        defaultOwner = 'families'
    },
    ['rancho_projects'] = {
        label = 'Rancho Projects Compound',
        coords = vec3(430.15, -1565.4, 29.28),
        radius = 120.0,
        defaultOwner = 'vagos'
    },
    ['forum_drive'] = {
        label = 'Forum Drive Compound',
        coords = vec3(-140.5, -1600.2, 35.0),
        radius = 100.0,
        defaultOwner = 'ballas'
    },
    ['fudge_lane'] = {
        label = 'Fudge Lane Compound',
        coords = vec3(1295.4, -1730.8, 53.8),
        radius = 115.0,
        defaultOwner = 'marabunta'
    }
}