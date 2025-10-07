To play:
- Must have love2d downloaded and saved to C:\Program Files\LOVE
(Or change run.bat filepath to correctly target your lovec.exe in the prefered install location)

Changelog:
-- 1.0.12:
-Fixed score,
Changed comparison logic for score:log to properly log the session highest. Score also runs independantly from time.time and uses score:add for each enemy survived (TODO: rounding error in most cases when getting new session best)
-Re-implemented death animation, (TODO)

-- 1.0.00:
Created the game