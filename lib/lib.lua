local lib = {}

lib.distance = function(x1, y1, x2, y2)
    local dx = x2 - x1
    local dy = y2 - y1
    return math.sqrt(dx * dx + dy * dy)
end

lib.lerp = function(A, B, t)
	return A + (B - A) * t
end

lib.randomFloat = function(min, max, precision)
    local scale = 10 ^ precision
    return math.floor((min + math.random() * (max - min)) * scale + 0.5) / scale
end

lib.clamp = function(value, min, max)
    if value > max then
        return max
    elseif value < min then
        return min
    else
        return value
    end
end

lib.sine = function(input, amplitude, frequency, phase)
	-- input: could be time, x, or y (whatever you're basing motion on)
	-- amplitude: how "tall" the wave is (max distance from the center)
	-- frequency: how "fast" the wave cycles (higher = more waves in same space/time)
	-- phase: horizontal offset of the wave (useful for multiple enemies offset)

	-- Convert input to radians for math.sin (expects radians, not degrees)
	-- 2 * π * frequency turns a cycle into a full wave based on frequency
	amplitude = randomFloat(amplitude, amplitude)
	frequency = frequency
	local angle = 2 * math.pi * frequency * input + (phase or 0)

	-- Calculate the sine of the angle and multiply by amplitude to scale it
	return math.sin(angle) * amplitude
end

return lib