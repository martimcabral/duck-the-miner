shader_type canvas_item;

uniform float intensity : hint_range(0.0, 1.0) = 1.0;

void fragment() {
    vec4 color = texture(TEXTURE, UV);
    float gray = dot(color.rgb, vec3(0.299, 0.587, 0.114));
    vec3 grayscale = vec3(gray);
    vec3 final_color = mix(color.rgb, grayscale, intensity);
    COLOR = vec4(final_color, color.a);
}
