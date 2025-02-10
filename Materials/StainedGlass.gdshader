// NOTE: Shader automatically converted from Godot Engine 4.3.stable's StandardMaterial3D.

shader_type spatial;
render_mode blend_mix, depth_draw_always, cull_back, diffuse_burley, specular_schlick_ggx;

uniform vec4 albedo : source_color;
uniform sampler2D texture_albedo : source_color, filter_linear_mipmap, repeat_enable;
uniform float point_size : hint_range(0.1, 128.0, 0.1);

//uniform sampler2D texture_alpha : hint_default_white, filter_linear_mipmap, repeat_enable;

uniform sampler2D texture_ORM : source_color, filter_linear_mipmap, repeat_enable;


uniform float roughness : hint_range(0, 4.0) = 1.25;
//uniform sampler2D texture_metallic : hint_default_white, filter_linear_mipmap, repeat_enable;
//uniform vec4 metallic_texture_channel;
//uniform sampler2D texture_roughness : hint_roughness_g, filter_linear_mipmap, repeat_enable;

uniform float specular : hint_range(0.0, 1.0, 0.01) = 0.5;
uniform float metallic : hint_range(0.0, 1.0, 0.01) = 0.0;

uniform sampler2D texture_refraction : filter_linear_mipmap, repeat_enable;
uniform float refraction : hint_range(-1.0, 1.0, 0.001) = 0.05;
uniform vec4 refraction_texture_channel;
uniform sampler2D screen_texture : hint_screen_texture, repeat_disable, filter_linear_mipmap;

uniform sampler2D texture_normal : hint_roughness_normal, filter_linear_mipmap, repeat_enable;
uniform float normal_scale : hint_range(-16.0, 16.0) = 1.0;

//uniform sampler2D texture_ambient_occlusion : hint_default_white, filter_linear_mipmap, repeat_enable;
//uniform vec4 ao_texture_channel;
uniform float ao_light_affect : hint_range(0.0, 1.0, 0.01) = 1;

uniform sampler2D texture_ColorVar : hint_default_white, filter_linear_mipmap, repeat_enable;
uniform float colorvar : hint_range(0.25, 2.0, 0.001);


uniform float refract_blurry : hint_range(0.0, 1.0, 0.001)=0.75 ;
uniform float color_intesity : hint_range(0.0, 10.0, 0.001)=3;

uniform vec3 uv1_scale = vec3(1,1,0);
uniform vec3 uv1_offset;
uniform vec3 uv2_scale = vec3(1,1,0);
uniform vec3 uv2_offset;

void vertex() {
	UV = UV * uv1_scale.xy + uv1_offset.xy;
}

void fragment() {
	vec2 base_uv = UV;
	//vec4 alpha_tex = texture(texture_alpha, base_uv);
	vec4 albedo_tex = texture(texture_albedo, base_uv);
	vec4 colorvar_tex = texture(texture_ColorVar,base_uv);
	vec4 orm_tex = texture(texture_ORM,base_uv);


	ALBEDO = (albedo.rgb * albedo_tex.rgb) *(colorvar_tex.rgb * colorvar) ;

	//float metallic_tex = dot(texture(texture_metallic, base_uv), metallic_texture_channel);
	//METALLIC = metallic_tex * metallic;
	METALLIC = orm_tex.b * metallic;
	SPECULAR = specular;

	vec4 roughness_texture_channel = vec4(0.0, 1.0, 0.0, 0.0);
	//float roughness_tex = dot(texture(texture_roughness, base_uv), roughness_texture_channel);
	//ROUGHNESS = roughness_tex * roughness;
	ROUGHNESS = orm_tex.g * roughness;

	// Normal Map: Enabled
	NORMAL_MAP = texture(texture_normal, base_uv).rgb;
	NORMAL_MAP_DEPTH = normal_scale;

	// Refraction: Enabled (with normal map texture)
	vec3 unpacked_normal = NORMAL_MAP;
	unpacked_normal.xy = unpacked_normal.xy * 2.0 - 1.0;
	unpacked_normal.z = sqrt(max(0.0, 1.0 - dot(unpacked_normal.xy, unpacked_normal.xy)));
	vec3 ref_normal = normalize(mix(
			NORMAL,
			TANGENT * unpacked_normal.x + BINORMAL * unpacked_normal.y + NORMAL * unpacked_normal.z,
			NORMAL_MAP_DEPTH));
	vec2 ref_ofs = SCREEN_UV - ref_normal.xy * dot(texture(texture_refraction, base_uv), refraction_texture_channel) * refraction;

	//float albedo_alpha = albedo.a * albedo_tex.a;
	float refraction_tex = dot(texture(texture_refraction, base_uv), refraction_texture_channel);

	float refracted_glass = mix(1.0,refract_blurry,refraction_tex);



	float ref_amount = 1.0 - refracted_glass;

	EMISSION += textureLod(screen_texture, ref_ofs, ROUGHNESS * 8.0).rgb * ref_amount * EXPOSURE;


	ALBEDO *= color_intesity - ref_amount;

	//ALBEDO.rgb = mix()



	// Force transparency on the material (required for refraction).
	//vec4 alpha_tex = texture(texture_alpha,base_uv);
	ALPHA = 1.0;

	// Ambient Occlusion: Enabled
	//AO = dot(texture(texture_ambient_occlusion, base_uv), ao_texture_channel);

	AO = orm_tex.r;
	AO_LIGHT_AFFECT = ao_light_affect;
}
