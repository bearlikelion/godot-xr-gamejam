shader_type spatial;
render_mode diffuse_lambert, specular_schlick_ggx;

// Base color and emission
uniform vec4 albedo : source_color = vec4(0.0, 0.0, 0.0, 1.0);
uniform vec4 emission_color : source_color = vec4(1.0, 0.2, 0.1, 1.0);
uniform float emission_strength : hint_range(0.0, 5.0) = 2.0;

// Rim effect
uniform float rim_strength : hint_range(0.0, 5.0) = 1.0;
uniform float rim_width : hint_range(0.0, 1.0) = 0.5;

// Pulse effect
uniform float pulse_speed : hint_range(0.0, 5.0) = 2.0;
uniform float pulse_intensity : hint_range(0.0, 1.0) = 0.3;

// Vertex displacement
uniform float displacement_amount : hint_range(0.0, 0.1) = 0.02;
uniform float displacement_speed : hint_range(0.0, 5.0) = 1.0;

void vertex() {
    // Add subtle vertex displacement
    VERTEX += NORMAL * sin(TIME * displacement_speed + VERTEX.y * 10.0) * displacement_amount;
}

void fragment() {
    // Base color
    ALBEDO = albedo.rgb;
    
    // Calculate rim effect
    float rim = 1.0 - dot(NORMAL, VIEW);
    rim = pow(rim, (1.0 - rim_width) * 10.0);
    
    // Pulsing effect
    float pulse = sin(TIME * pulse_speed) * 0.5 + 0.5;
    pulse = pulse * pulse_intensity + (1.0 - pulse_intensity);
    
    // Combine rim and pulse for emission
    vec3 emission = emission_color.rgb * emission_strength * (rim * rim_strength) * pulse;
    
    // Apply emission
    EMISSION = emission;
    
    // Add some roughness variation
    ROUGHNESS = 0.7 - (rim * 0.3);
    METALLIC = 0.5;
}
