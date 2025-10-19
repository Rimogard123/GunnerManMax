diffConfig = {}

diffConfig.config = {}

diffConfig.diffs = {
    ["easy"] = {
        baseLerp = 0.04,
        maxEnemies = 3,
        lifetime = 210
    },
    ["medium"] = {
        baseLerp = 0.055,
        maxEnemies = 4,
        lifetime = 140
    },
    ["hard"] = {
        baseLerp = 0.075,
        maxEnemies = 6,
        lifetime = 80
    }
}
diffConfig.values = {
    baseLerp = 0,
    maxEnemies = 0,
    lifetime = 0
}

diffConfig.setConfig = function(diff)
    diff = diff or "medium"
    for k, v in pairs(diffConfig.diffs[diff]) do
        diffConfig.config[k] = v
        print(diffConfig.config[k], v)
    end
    diffConfig.config["diff"] = diff
    print(diffConfig.config["diff"])
end

function diffConfig.load()
    diffConfig.setConfig()
end