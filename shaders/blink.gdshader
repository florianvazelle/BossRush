//https://godotshaders.com/shader/blinking-bomb-countdown/
shader_type spatial;

uniform bool hit = false;
uniform float end_time = 5.0; //length of animation in seconds
uniform float start_freq : hint_range(0.0, 1.0, 0.05) = 1; //how fast the flashing will be at start of animation
uniform float end_freq : hint_range(1.0, 20.0, 0.5) = 10; //how fast it will be in the end
uniform vec3 flash_color : source_color = vec3(1.0);
uniform float blink_length : hint_range(0.0, 1.0) = 0.5;
uniform float blink_speed : hint_range(0.0, 20.0) = 2.0;

void fragment() {
	float phase = blink_speed * PI * (start_freq * TIME + (end_freq - start_freq) / (2.0 * end_time));
	float wave = sin(phase);
	float blink_wave = wave * (1.0 / blink_length) - (1.0 / blink_length) + 1.0;

	if (hit && blink_wave > 0.0) {
    	vec3 colorMix = mix(ALBEDO, flash_color.rgb, blink_wave);
    	ALBEDO = colorMix;
		ALPHA = 1.0;
	} else {
		ALBEDO = ALBEDO;
		ALPHA = 0.0;
	}
}
