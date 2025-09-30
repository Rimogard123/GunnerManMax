--Unused for now

score = {}

score.score = 0
score.sessionHighest = 0

function score:increment()
    self.score = self.score + 1
end

function score:add(amount)
    self.score = self.score + amount
end

function score:log()
    self.score = math.floor(self.score)
    self.sessionHighest = self.score
end

function score:reset()
    self.score = 0 
end

--Only used to print the score at the end, and sessionHighest does nothing
function score:set(amount)
    self.score = amount
end