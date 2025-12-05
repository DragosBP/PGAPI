#version 430

layout(lines) in;
layout(triangle_strip, max_vertices = 70) out;

// Uniform properties
uniform mat4 View;
uniform mat4 Projection;
uniform vec3 control_p0, control_p1, control_p2, control_p3;
uniform int no_of_instances;

// TODO(student): Declare any other uniforms here
uniform float max_translate;
uniform int rotate;

// Input
in int instance[2];
in vec3 test_normal[];

// Output
out vec2 texture_coord;
out vec3 world_position;
out vec3 world_normal;


vec3 translateZ(vec3 point, float t)
{
    return vec3(point.x, point.y, point.z + t);
}

vec3 translateX(vec3 point, float t)
{
    return vec3(point.x + t, point.y, point.z);
}


// This function computes B(t) with 4 control points. For a visual example,
// see [1]. For an interactive Javascript example with the exact points in
// this code, see [2].
//
// [1] https://www.desmos.com/calculator/cahqdxeshd
// [2] https://jsfiddle.net/6yuv9htf/
vec3 bezier(float t)
{
    return  control_p0 * pow((1 - t), 3) +
            control_p1 * 3 * t * pow((1 - t), 2) +
            control_p2 * 3 * pow(t, 2) * (1 - t) +
            control_p3 * pow(t, 3);
}


void main()
{
    const int NO_OF_GENERATED_POINTS = 5;

    for (int j = 0; j < no_of_instances; j++) {
        for (int i = 0; i < NO_OF_GENERATED_POINTS - 1; i++) {
            float t1 = float(i) / float(NO_OF_GENERATED_POINTS - 1);
            float t2 = float(i + 1) / float(NO_OF_GENERATED_POINTS - 1);
            float t3 = float(i + 2) / float(NO_OF_GENERATED_POINTS - 1);

            vec3 point_row1_a;
            vec3 point_row1_b;
            vec3 point_row1_c;

            vec3 point_row2_a;
            vec3 point_row2_b;
            vec3 point_row2_c;
            
            vec3 point_row3_a;
            vec3 point_row3_b;

            float v1 = float(j) / float(no_of_instances);
            float v2 = float(j + 1) / float(no_of_instances);

            if (rotate == 1) {
                point_row1_a = translateZ(bezier(t1), max_translate * instance[0] / no_of_instances);
                point_row1_b = translateZ(bezier(t2), max_translate * instance[0] / no_of_instances);
                point_row1_c = translateZ(bezier(t3), max_translate * instance[0] / no_of_instances);
                
                point_row2_a = translateZ(bezier(t1), max_translate * (instance[0] + 1) / no_of_instances);
                point_row2_b = translateZ(bezier(t2), max_translate * (instance[0] + 1) / no_of_instances);
                point_row2_c = translateZ(bezier(t3), max_translate * (instance[0] + 1) / no_of_instances);
                
                point_row3_a = translateZ(bezier(t1), max_translate * (instance[0] + 2) / no_of_instances);
                point_row3_b = translateZ(bezier(t2), max_translate * (instance[0] + 2) / no_of_instances);
            } else {
                point_row1_a = translateX(bezier(t1), max_translate * instance[0] / no_of_instances);
                point_row1_b = translateX(bezier(t2), max_translate * instance[0] / no_of_instances);
                point_row1_c = translateX(bezier(t3), max_translate * instance[0] / no_of_instances);
                
                point_row2_a = translateX(bezier(t1), max_translate * (instance[0] + 1) / no_of_instances);
                point_row2_b = translateX(bezier(t2), max_translate * (instance[0] + 1) / no_of_instances);
                point_row2_c = translateX(bezier(t3), max_translate * (instance[0] + 1) / no_of_instances);
            
                point_row3_a = translateX(bezier(t1), max_translate * (instance[0] + 2) / no_of_instances);
                point_row3_b = translateX(bezier(t2), max_translate * (instance[0] + 2) / no_of_instances);
            }

            vec3 green_arrow;
            vec3 red_arrow;
            
            // 1A
            texture_coord = vec2(t1, v1);
            world_position = point_row1_a;

            green_arrow = normalize(point_row1_b - point_row1_a); // verde
            red_arrow = normalize(point_row2_a - point_row1_a); // rosie
            world_normal = cross(green_arrow, red_arrow);

            gl_Position = Projection * View * vec4(point_row1_a, 1);  EmitVertex();


            // 1B
            texture_coord = vec2(t2, v1);
            world_position = point_row1_b;
            
            green_arrow = normalize(point_row1_c - point_row1_b); // verde
            red_arrow = normalize(point_row2_b - point_row1_b); // rosie
            world_normal = cross(green_arrow, red_arrow);

            gl_Position = Projection * View * vec4(point_row1_b, 1);  EmitVertex();


            // 2A
            texture_coord = vec2(t1, v2);
            world_position = point_row2_a;

            green_arrow = normalize(point_row2_b - point_row2_a); // verde
            red_arrow = normalize(point_row3_a - point_row2_a); // rosie
            world_normal = cross(green_arrow, red_arrow);

            gl_Position = Projection * View * vec4(point_row2_a, 1);  EmitVertex();

            // 2B
            texture_coord = vec2(t2, v2);
            world_position = point_row2_b;

            green_arrow = normalize(point_row2_c - point_row2_b); // verde
            red_arrow = normalize(point_row3_b - point_row2_b); // rosie
            world_normal = cross(green_arrow, red_arrow);

            gl_Position = Projection * View * vec4(point_row2_b, 1);  EmitVertex();

            EndPrimitive();
        }
    }

}
