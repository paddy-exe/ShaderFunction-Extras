float sawtooth_wave(float IN, float amplitude, float frequency, float height) {
	return 2.0 * amplitude * ((IN/frequency) - floor((1.0/2.0) + (IN / frequency))) + height;
}

float sine_wave(float IN, float amplitude, float frequency, float phase, float height) {
	return amplitude * sin(2.0 * PI * frequency * IN + phase) + height;
}

float sine_wave_angular(float IN, float amplitude, float __ang_frequency, float phase, float height) {
	return amplitude * sin(__ang_frequency * IN + phase) + height;
}

float square_wave(float IN, float amplitude, float frequency, float height) {
	return amplitude*sign(sin(2.0 * PI * IN * frequency)) + height;
}

float triangle_wave(float IN, float amplitude, float frequency, float height) {
	return 1.0 - amplitude * abs(round(IN / frequency) - (IN / frequency)) + height;
}
