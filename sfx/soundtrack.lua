require("time")
soundtrack = {
    track = "sfx/medium.mp3",

    musicOptions = {
        diffs = {
            ["easy"] = "sfx/easy.mp3",
            ["medium"] = "sfx/medium.mp3",
            ["hard"] = "sfx/hard.ogg"
        }
    }
}

musicOptions = {
    ["easy"] = "sfx/easy.mp3",
    ["medium"] = "sfx/medium.mp3",
    ["hard"] = "sfx/hard.ogg"
}

function soundtrack.changeTrack(newTrack)
    soundtrack.track = musicOptions[newTrack]
end

function soundtrack.play(path, loop)
    --if soundtrack.track then soundtrack.track:stop() end
    path = path or soundtrack.track
    soundtrack.track = love.audio.newSource(path, "stream")
    soundtrack.track:setLooping(loop or true)
    soundtrack.track:play()
end

function soundtrack.stop()
    if soundtrack.track then
        soundtrack.track:stop()
        --soundtrack.track = nil
    end
end