#version 430

layout(lines) in;
layout(triangle_strip, max_vertices = 70) out;

// Uniform properties
uniform mat4 View;
uniform mat4 Projection;
uniform vec3 control_p0, control_p1, control_p2, control_p3;
uniform int no_of_instances;
uniform float max_translate;
uniform int rotate;
uniform int flip_normal_in;

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

    int current_inst = instance[0];
    float v1 = float(current_inst) / float(no_of_instances);
    float v2 = float(current_inst + 1) / float(no_of_instances);

    for (int i = 0; i < NO_OF_GENERATED_POINTS - 1; i++) {
        float t1 = float(i) / float(NO_OF_GENERATED_POINTS - 1);
        float t2 = float(i + 1) / float(NO_OF_GENERATED_POINTS - 1);
        float t3 = float(i + 2) / float(NO_OF_GENERATED_POINTS - 1);

        vec3 point_row1_a, point_row1_b, point_row1_c;
        vec3 point_row2_a, point_row2_b, point_row2_c;
        vec3 point_row3_a, point_row3_b;

        // Calculate geometry based on Rotation/Translation logic
        if (rotate == 1) {
            point_row1_a = translateZ(bezier(t1), max_translate * current_inst / no_of_instances);
            point_row1_b = translateZ(bezier(t2), max_translate * current_inst / no_of_instances);
            point_row1_c = translateZ(bezier(t3), max_translate * current_inst / no_of_instances);
            
            point_row2_a = translateZ(bezier(t1), max_translate * (current_inst + 1) / no_of_instances);
            point_row2_b = translateZ(bezier(t2), max_translate * (current_inst + 1) / no_of_instances);
            point_row2_c = translateZ(bezier(t3), max_translate * (current_inst + 1) / no_of_instances);
            
            point_row3_a = translateZ(bezier(t1), max_translate * (current_inst + 2) / no_of_instances);
            point_row3_b = translateZ(bezier(t2), max_translate * (current_inst + 2) / no_of_instances);
        } else {
            point_row1_a = translateX(bezier(t1), max_translate * current_inst / no_of_instances);
            point_row1_b = translateX(bezier(t2), max_translate * current_inst / no_of_instances);
            point_row1_c = translateX(bezier(t3), max_translate * current_inst / no_of_instances);
            
            point_row2_a = translateX(bezier(t1), max_translate * (current_inst + 1) / no_of_instances);
            point_row2_b = translateX(bezier(t2), max_translate * (current_inst + 1) / no_of_instances);
            point_row2_c = translateX(bezier(t3), max_translate * (current_inst + 1) / no_of_instances);
        
            point_row3_a = translateX(bezier(t1), max_translate * (current_inst + 2) / no_of_instances);
            point_row3_b = translateX(bezier(t2), max_translate * (current_inst + 2) / no_of_instances);
        }

        vec3 green_arrow;
        vec3 red_arrow;
        
        // 1A
        texture_coord = vec2(t1, v1);
        world_position = point_row1_a;

        green_arrow = normalize(point_row1_b - point_row1_a); 
        red_arrow   = normalize(point_row2_a - point_row1_a); 
        world_normal = normalize(cross(green_arrow, red_arrow)); 
        if (flip_normal_in == 1) {
            world_normal = -world_normal;
        }

        gl_Position = Projection * View * vec4(point_row1_a, 1);  EmitVertex();

        // 1B
        texture_coord = vec2(t2, v1);
        world_position = point_row1_b;
        
        if (i < NO_OF_GENERATED_POINTS - 2) {
            green_arrow = normalize(point_row1_c - point_row1_b);
        } else {
            green_arrow = normalize(point_row1_b - point_row1_a); // Reuse previous slope at the end
        }

        red_arrow   = normalize(point_row2_b - point_row1_b); 
        world_normal = normalize(cross(green_arrow, red_arrow));
        if (flip_normal_in == 1) {
            world_normal = -world_normal;
        }

        gl_Position = Projection * View * vec4(point_row1_b, 1);  EmitVertex();

        // 2A 
        texture_coord = vec2(t1, v2);
        world_position = point_row2_a;

        green_arrow = normalize(point_row2_b - point_row2_a); 
        red_arrow   = normalize(point_row3_a - point_row2_a); 
        world_normal = normalize(cross(green_arrow, red_arrow));
        if (flip_normal_in == 1) {
            world_normal = -world_normal;
        }

        gl_Position = Projection * View * vec4(point_row2_a, 1);  EmitVertex();

        // 2B
        texture_coord = vec2(t2, v2);
        world_position = point_row2_b;

        if (i < NO_OF_GENERATED_POINTS - 2) {
            green_arrow = normalize(point_row2_c - point_row2_b);
        } else {
             green_arrow = normalize(point_row2_b - point_row2_a);
        }

        red_arrow   = normalize(point_row3_b - point_row2_b); 
        world_normal = normalize(cross(green_arrow, red_arrow));
        if (flip_normal_in == 1) {
            world_normal = -world_normal;
        }

        gl_Position = Projection * View * vec4(point_row2_b, 1);  EmitVertex();

        EndPrimitive();
    }
}