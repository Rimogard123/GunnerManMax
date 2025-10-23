-- 2.11:
-Added arrow key movement
-Added 2(two) new enemies
-Once again didn't improve code clarity

-- 2.1: Fun patch
-Made it loads more fun
-other unnoteworthy tweaks

-- 2.0xd1: Gunnerman Max (The sequel)
-Didn't improve code clarity
    No defined globals and improper use of imports
-New gfx courtesy of damiona123@ https://github.com/damiona123/Gunner-Man
-Use of wasd for player controls
-New Infinite terrain generation tm
-Increased overall difficulty and enemies increase on time alive
-Darkened 6 pixels on Player sprite

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