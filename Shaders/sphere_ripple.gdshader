shader_type spatial;
render_mode diffuse_lambert, specular_schlick_ggx;

// Wave parameters
uniform float wave_height : hint_range(0.0, 2.0) = 0.5;
uniform float wave_speed : hint_range(0.0, 5.0) = 2.0;
uniform float wave_frequency : hint_range(0.0, 20.0) = 10.0;


// Ripple parameters
uniform float ripple_speed : hint_range(0.0, 10.0) = 3.0;
uniform float ripple_frequency : hint_range(0.0, 20.0) = 8.0;
uniform float ripple_amplitude : hint_range(0.0, 1.0) = 0.5;

void vertex() {
    // Calculate base wave
    float wave = sin(VERTEX.x * wave_frequency + TIME * wave_speed) * 
                 sin(VERTEX.z * wave_frequency + TIME * wave_speed);
                 
    // Calculate ripple effect
    float dist = length(VERTEX.xz);
    float ripple = sin(dist * ripple_frequency - TIME * ripple_speed) * ripple_amplitude;
    
    // Combine wave and ripple
    float displacement = wave * wave_height + ripple;
    
    // Apply vertical displacement
    VERTEX.y += displacement;
    
    // Recalculate normals
    NORMAL = normalize(vec3(
        -wave_height * wave_frequency * cos(VERTEX.x * wave_frequency + TIME * wave_speed),
        1.0,
        -wave_height * wave_frequency * cos(VERTEX.z * wave_frequency + TIME * wave_speed)
    ));
}

void fragment() {
    METALLIC = 0.3;
}