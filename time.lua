time = {
    time = 0
}

function time:increment()
    self.time = self.time + 1
end

function time:reset()
    self.time = 0
end