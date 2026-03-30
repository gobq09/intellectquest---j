shader_type canvas_item;

uniform sampler2D noise_texture : repeat_enable;
uniform vec2 speed = vec2(0.05, 0.02);
uniform float density : hint_range(0.0, 1.0) = 0.5;
uniform vec4 shadow_color : source_color = vec4(0.0, 0.0, 0.0, 0.3);

void fragment() {
    // Scroll the noise over time
    vec2 uv_offset = TIME * speed;
    float noise_val = texture(noise_texture, UV + uv_offset).r;
    
    // Apply threshold to create distinct "cloud" shapes
    float shadow_mask = smoothstep(density, density + 0.1, noise_val);
    
    // Output the shadow color multiplied by the mask
    COLOR = vec4(shadow_color.rgb, shadow_mask * shadow_color.a);
}