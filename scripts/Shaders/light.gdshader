shader_type canvas_item;

uniform vec2 light_position; // Position of the light source (in 2D space)
uniform vec3 light_color = vec3(1.0, 1.0, 1.0); // Color of the light (no type hint)
uniform float light_intensity : hint_range(0.0, 100.0) = 1.0; // Intensity of the light
uniform float light_radius : hint_range(0.0, 100.0) = 50.0; // Radius in which the light has an effect

void fragment() {
    // Calculate the distance from the pixel to the light (in 2D space)
    float dist = length(light_position - FRAGCOORD.xy);
    
    // Calculate the falloff based on the distance
    float attenuation = 1.0 / (dist * dist + 1.0); // You can adjust the falloff formula for more realistic results

    // Apply light intensity, color, and attenuation
    vec3 light_effect = light_color * light_intensity * attenuation;
    
    // If the light is within the radius, apply the lighting effect, otherwise make it black
    if (dist > light_radius) {
        discard;
    }

    // Final color, modulating with the light effect
    vec4 base_color = texture(TEXTURE, UV);
    vec3 final_color = base_color.rgb + light_effect;

    // Output the final fragment color
    COLOR = vec4(final_color, 1.0);
}
