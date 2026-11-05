
shader_type canvas_item;
render_mode light_only;

// --- PARÂMETROS ESTÉTICOS ---
uniform float color_levels : hint_range(2.0, 128.0) = 14.0;
uniform float chromatic_aberration : hint_range(0.0, 0.2) = 0.008;
uniform float blur_amount : hint_range(0.0, 5.0) = 0.0;
uniform float brightness : hint_range(0.5, 3.0) = 1.2;
uniform float saturation : hint_range(0.0, 5.0) = 1.0;

// --- PARÂMETROS DE GLITCH ---
uniform float color_offset_multiplier : hint_range(0.0, 0.2) = 0.004;
uniform float black_offset_multiplier : hint_range(0.0, 0.5) = 0.1;
uniform float color_offset : hint_range(-0.1, 0.1) = 0.005;

// --- ILUMINAÇÃO ---
uniform float light_influence : hint_range(0.0, 1.0) = 1.0;

float noise(vec2 uv, float offset) {
    return (
        fract(sin(dot(uv * offset, vec2(12.9898, 78.233)))
        * 43758.5453) - 0.5
    ) * 2.0;
}

vec3 rgb_to_yuv(vec3 rgb) {
    const mat3 RGB_TO_YUV = mat3(
        vec3(0.299, 0.587, 0.114),
        vec3(-0.14713, -0.28886, 0.436),
        vec3(0.615, -0.51499, -0.10001)
    );
    return rgb * RGB_TO_YUV;
}

vec3 yuv_to_rgb(vec3 yuv) {
    const mat3 YUV_TO_RGB = mat3(
        vec3(1.0, 0.0, 1.13983),
        vec3(1.0, -0.39465, -0.58060),
        vec3(1.0, 2.03211, 0.0)
    );
    return clamp(yuv * YUV_TO_RGB, vec3(0.0), vec3(1.0));
}

void fragment() {
    vec4 tex = texture(TEXTURE, UV);

    if (tex.a <= 0.001) {
        discard;
    }

    float line_logic = floor(UV.y * 487.0);
    vec2 noise_coord = vec2(line_logic, 0.0);

    float x_offset = color_offset
        + noise(noise_coord, TIME) * color_offset_multiplier;

    float black_offset = noise(noise_coord, TIME + 65.0)
        * (black_offset_multiplier * 0.01);

    float red = texture(
        TEXTURE,
        UV + vec2(chromatic_aberration + black_offset, 0.0)
    ).r;

    float green = tex.g;

    float blue = texture(
        TEXTURE,
        UV - vec2(chromatic_aberration - black_offset, 0.0)
    ).b;

    vec3 col = vec3(red, green, blue);

    vec3 shifted = textureLod(
        TEXTURE,
        UV + vec2(x_offset, 0.0),
        blur_amount * 0.25
    ).rgb;

    vec3 yuv_base = rgb_to_yuv(col);
    vec3 yuv_shifted = rgb_to_yuv(shifted);

    col = yuv_to_rgb(
        vec3(yuv_base.x, yuv_shifted.y, yuv_shifted.z)
    );

    float luma = dot(col, vec3(0.299, 0.587, 0.114));
    col = mix(vec3(luma), col, saturation);
    col *= brightness;

    col = floor(col * color_levels + 0.3) / color_levels;
    col = clamp(col, 0.0, 1.0);
    col = mix(col, col * col * (3.0 - 2.0 * col), 0.6);

    COLOR = vec4(col, tex.a);
}

void light() {
    // Preserva a cor processada pelo fragment e modula pela luz.
    vec3 illumination = LIGHT_COLOR.rgb * LIGHT_ENERGY;
    vec3 light_factor = mix(
        vec3(1.0),
        illumination,
        light_influence
    );

    LIGHT = vec4(COLOR.rgb * light_factor, COLOR.a * LIGHT_COLOR.a);
}
