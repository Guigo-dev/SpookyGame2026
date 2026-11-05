
shader_type canvas_item;
render_mode unshaded;

uniform float radius = 2000.0;
uniform float softness : hint_range(0.0, 100.0) = 12.0;
uniform vec2 center = vec2(0.5, 0.5);

void fragment() {
    vec2 screen_size = 1.0 / SCREEN_PIXEL_SIZE;
    vec2 difference = (SCREEN_UV - center) * screen_size;

    float distance_to_center = length(difference);

    float alpha = smoothstep(
        radius - softness,
        radius,
        distance_to_center
    );

    COLOR = vec4(0.0, 0.0, 0.0, alpha);
}
