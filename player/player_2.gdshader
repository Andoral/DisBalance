shader_type canvas_item;

uniform float _on_health_energy_changed = 0.0;
uniform int _on_element_changed = 0;  // 0 = Darkness, 1 = Light

// Первый целевой цвет (251, 251, 251, 255) и его замены
const vec4 target_color_hair1 = vec4(251.0 / 255.0, 251.0 / 255.0, 251.0 / 255.0, 1.0);
const vec4 target_color_hair1_pos = vec4(1.0, 252.0 / 255.0, 192.0 / 255.0, 251.0 / 255.0);
const vec4 target_color_hair1_neg = vec4(106.0 / 255.0, 26.0 / 255.0, 179.0 / 255.0, 1.0);

// Второй целевой цвет (210, 210, 210, 255) и его замены
const vec4 target_color_hair2 = vec4(210.0 / 255.0, 210.0 / 255.0, 210.0 / 255.0, 1.0);
const vec4 target_color_hair2_pos = vec4(255.0 / 255.0, 219.0 / 255.0, 52.0 / 255.0, 1.0);
const vec4 target_color_hair2_neg = vec4(60.0 / 255.0, 33.0 / 255.0, 85.0 / 255.0, 1.0);

// Допуск для сравнения цветов (чтобы избежать проблем с точностью float)
const float color_tolerance = 0.01;

// Цвета для изменения в зависимости от состояния элемента
const vec4 color_white = vec4(1.0, 1.0, 1.0, 1.0);
const vec4 color_white_dark = vec4(167.0 / 255.0, 134.0 / 255.0, 210.0 / 255.0, 1.0);
const vec4 color_white_light = vec4(255.0 / 255.0, 219.0 / 255.0, 52.0 / 255.0, 1.0);

const vec4 color_gray = vec4(235.0 / 255.0, 235.0 / 255.0, 235.0 / 255.0, 1.0);
const vec4 color_gray_dark = vec4(155.0 / 255.0, 86.0 / 255.0, 219.0 / 255.0, 1.0);
const vec4 color_gray_light = vec4(255.0 / 255.0, 219.0 / 255.0, 32.0 / 255.0, 1.0);

const vec4 color_medium_gray = vec4(1.0, 1.0, 1.0, 1.0);
const vec4 color_medium_gray_dark = vec4(76.0 / 255.0, 35.0 / 255.0, 114.0 / 255.0, 1.0);
const vec4 color_medium_gray_light = vec4(246.0 / 255.0, 232.0 / 255.0, 168.0 / 255.0, 1.0);

void fragment() {
    vec4 tex_color = texture(TEXTURE, UV);
    vec4 new_color = tex_color;

    // Изменяем цвета в зависимости от состояния элемента (Darkness или Light)
    if (abs(tex_color.r - color_white.r) < color_tolerance &&
        abs(tex_color.g - color_white.g) < color_tolerance &&
        abs(tex_color.b - color_white.b) < color_tolerance &&
        abs(tex_color.a - color_white.a) < color_tolerance) {
        
        if (_on_element_changed == 0) {
            new_color = color_white_dark;  // Darkness
        } else if (_on_element_changed == 1) {
            new_color = color_white_light; // Light
        }
    }
    else if (abs(tex_color.r - color_gray.r) < color_tolerance &&
             abs(tex_color.g - color_gray.g) < color_tolerance &&
             abs(tex_color.b - color_gray.b) < color_tolerance &&
             abs(tex_color.a - color_gray.a) < color_tolerance) {
        
        if (_on_element_changed == 0) {
            new_color = color_gray_dark;  // Darkness
        } else if (_on_element_changed == 1) {
            new_color = color_gray_light; // Light
        }
    }
    else if (abs(tex_color.r - color_medium_gray.r) < color_tolerance &&
             abs(tex_color.g - color_medium_gray.g) < color_tolerance &&
             abs(tex_color.b - color_medium_gray.b) < color_tolerance &&
             abs(tex_color.a - color_medium_gray.a) < color_tolerance) {
        
        if (_on_element_changed == 0) {
            new_color = color_medium_gray_dark;  // Darkness
        } else if (_on_element_changed == 1) {
            new_color = color_medium_gray_light; // Light
        }
    }
    
    // Проверяем первый целевой цвет (target_color_hair1)
    if (abs(tex_color.r - target_color_hair1.r) < color_tolerance &&
        abs(tex_color.g - target_color_hair1.g) < color_tolerance &&
        abs(tex_color.b - target_color_hair1.b) < color_tolerance &&
        abs(tex_color.a - target_color_hair1.a) < color_tolerance) {
        
        if (_on_health_energy_changed > 0.0) {
            float factor = _on_health_energy_changed / 100.0;
            new_color = mix(target_color_hair1, target_color_hair1_pos, factor);
        } else if (_on_health_energy_changed < 0.0) {
            float factor = abs(_on_health_energy_changed) / 100.0;
            new_color = mix(target_color_hair1, target_color_hair1_neg, factor);
        }
    }
    
    // Проверяем второй целевой цвет (target_color_hair2)
    else if (abs(tex_color.r - target_color_hair2.r) < color_tolerance &&
             abs(tex_color.g - target_color_hair2.g) < color_tolerance &&
             abs(tex_color.b - target_color_hair2.b) < color_tolerance &&
             abs(tex_color.a - target_color_hair2.a) < color_tolerance) {
        
        if (_on_health_energy_changed > 0.0) {
            float factor = _on_health_energy_changed / 100.0;
            new_color = mix(target_color_hair2, target_color_hair2_pos, factor);
        } else if (_on_health_energy_changed < 0.0) {
            float factor = abs(_on_health_energy_changed) / 100.0;
            new_color = mix(target_color_hair2, target_color_hair2_neg, factor);
        }
    }

    // Устанавливаем итоговый цвет
    COLOR = new_color;
}
