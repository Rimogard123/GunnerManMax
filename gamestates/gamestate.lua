gamestate = {}

gamestate.state = ""

gamestate.states = {
    "menu",
    "ingame",
    "dead"
}

gamestate.changeState = function(state)
    state = state or "menu"
    gamestate.state = state
end

function gamestate.load()
    gamestate.changeState()
end