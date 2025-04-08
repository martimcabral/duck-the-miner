shader_type canvas_item;

uniform sampler2D screen_texture : hint_screen_texture;
uniform float intensity : hint_range(0.0, 1.0); // 0 = no grayscale, 1 = full grayscale

void fragment() {
    vec4 screen_color = texture(screen_texture, SCREEN_UV);
    float avg = (screen_color.r + screen_color.g + screen_color.b) / 3.0;
    vec3 grayscale = vec3(avg);
    vec3 final_color = mix(screen_color.rgb, grayscale, intensity);
    COLOR = vec4(final_color, screen_color.a);
}
