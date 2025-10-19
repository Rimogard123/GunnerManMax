-- 1.21111: Megabonk Update
-Built upon projectile class and firing mechanic
    TODO; Additional projectiles and projectile parameters
-Fixed enemies spawning directly on the player

-- 1.1:
-Re-implemented enemy death animation,


-- 1.0.12:
-Fixed score,
    Changed comparison logic for score:log to properly log the session highest. Score also runs independantly from time.time and uses score:add for each enemy survived
    Fixed ingame update loop incrementing score by 1 after sessionhighest is logged
-Added barebones projectile class devoid of movement or proper logic (TODO)

-- 1.0.00:
Created the game,