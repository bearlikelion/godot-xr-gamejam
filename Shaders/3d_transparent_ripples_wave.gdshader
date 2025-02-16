shader_type spatial;
render_mode unshaded;


// Handles the concentric ripples
uniform float frequency: hint_range(0, 15, 0.01) = 4.0;
uniform float amplitude: hint_range(0, 3, 0.1) = 2.0;
uniform float ripple_rate : hint_range(0, 20.0, 1) = 5;
uniform float blending : hint_range(0.0, 1.0, 0.01) = 1.0;

// Handles the waves themselves
uniform float wave_amplitude: hint_range(0.001, 0.1, 0.001) = 0.05;
uniform float wave_frequency: hint_range(0, 15, 0.01) = 4.0;

uniform sampler2D SCREEN_TEXTURE: hint_screen_texture, filter_linear_mipmap, repeat_disable;

vec2 wave(vec2 uv, float time) {
    return vec2(
        uv.x + sin(uv.y * wave_frequency + time) * wave_amplitude,
        uv.y + sin(uv.x * wave_frequency + time) * wave_amplitude
    );
}

void fragment() {
	vec2 screen_pixel_size = 1.0 / VIEWPORT_SIZE;
	vec2 center_position = -1.0 + 2.0 * UV;
	float center_distance = length(center_position);
	
	float ripple = sin(center_distance * -frequency * PI + ripple_rate * TIME) * amplitude / (center_distance + 1.0);
	
	vec2 uv = FRAGCOORD.xy * screen_pixel_size + (center_position/center_distance) * ripple * wave_amplitude;
	vec2 background_wave = wave(uv, TIME);
	vec4 background_texture = texture(SCREEN_TEXTURE, background_wave) * sqrt(amplitude);
	
	ALBEDO = background_texture.rgb;
	ALPHA = blending;
}

// REFERENCE https://godotshaders.com/shader/3d-transparent-ripples-wave/