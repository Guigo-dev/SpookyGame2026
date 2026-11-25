shader_type canvas_item;

void fragment() {
    float distancia = distance(UV, vec2(0.5, 0.5));

    float intensidade = 1.0 - smoothstep(0.0, 0.65, distancia);

    float pulso = 0.75 + sin(TIME * 2.0) * 0.25;

    vec3 vermelho = vec3(0.22, 0.04, 0.04);

    COLOR = vec4(vermelho * intensidade * pulso, 1.0);
}