#version 430

layout(lines) in;
layout(triangle_strip, max_vertices = 70) out;

// Uniform properties
uniform mat4 View;
uniform mat4 Projection;
uniform mat4 Model;
uniform vec3 control_p0, control_p1, control_p2, control_p3;
uniform int no_of_instances;
uniform float max_rotate;

// Input
in int instance[2];

// Output
out vec2 texture_coord;
out vec3 world_position;
out vec3 world_normal;

vec3 rotateY(vec3 point, float u)
{
    float x = point.x * cos(u) - point.z * sin(u);
    float z = point.x * sin(u) + point.z * cos(u);
    
    z *= 0.2;
    return vec3(x, point.y, z);
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
    const int NO_OF_GENERATED_POINTS = 10;
    
    int current_instance = instance[0];

    for (int i = 0; i < NO_OF_GENERATED_POINTS - 1; i++) {
        float t1 = float(i) / float(NO_OF_GENERATED_POINTS - 1);
        float t2 = float(i + 1) / float(NO_OF_GENERATED_POINTS - 1);
        float t3 = float(i + 2) / float(NO_OF_GENERATED_POINTS - 1);

        float v1 = float(current_instance) / float(no_of_instances);
        float v2 = float(current_instance + 1) / float(no_of_instances);

        float i_current = float(current_instance);
        float i_next    = float(current_instance + 1);
        float i_next2   = float(current_instance + 2);

        vec3 point_row1_a = rotateY(bezier(t1), max_rotate * i_current / no_of_instances);
        vec3 point_row1_b = rotateY(bezier(t2), max_rotate * i_current / no_of_instances);
        vec3 point_row1_c = rotateY(bezier(t3), max_rotate * i_current / no_of_instances);

        vec3 point_row2_a = rotateY(bezier(t1), max_rotate * i_next / no_of_instances);
        vec3 point_row2_b = rotateY(bezier(t2), max_rotate * i_next / no_of_instances);
        vec3 point_row2_c = rotateY(bezier(t3), max_rotate * i_next / no_of_instances);

        vec3 point_row3_a = rotateY(bezier(t1), max_rotate * i_next2 / no_of_instances);
        vec3 point_row3_b = rotateY(bezier(t2), max_rotate * i_next2 / no_of_instances);

        vec3 green_arrow; 
        vec3 red_arrow;   
        vec3 raw_normal;

        // 1A
        texture_coord = vec2(t1, v1);
        world_position = vec3(Model * vec4(point_row1_a, 1));
        
        green_arrow = normalize(point_row1_b - point_row1_a); // Tangent along curve
        red_arrow   = normalize(point_row2_a - point_row1_a); // Tangent along rotation
        raw_normal = cross(green_arrow, red_arrow);
        // Apply inverse transpose for non-uniform scaling: scale Z back by 1/0.2 = 5.0
        world_normal = normalize(mat3(Model) * vec3(raw_normal.x, raw_normal.y, raw_normal.z * 5.0));

        gl_Position = Projection * View * Model * vec4(point_row1_a, 1);  EmitVertex();
        
        // 1B
        texture_coord = vec2(t2, v1);
        world_position = vec3(Model * vec4(point_row1_b, 1));

        if (i < NO_OF_GENERATED_POINTS - 2) {
            green_arrow = normalize(point_row1_c - point_row1_b);
        } else {
            // Use the previous tangent for the very last point
            green_arrow = normalize(point_row1_b - point_row1_a);
        }
        red_arrow   = normalize(point_row2_b - point_row1_b);
        raw_normal = cross(green_arrow, red_arrow);
        world_normal = normalize(mat3(Model) * vec3(raw_normal.x, raw_normal.y, raw_normal.z * 5.0));

        gl_Position = Projection * View * Model * vec4(point_row1_b, 1);  EmitVertex();

        // 2A
        texture_coord = vec2(t1, v2);
        world_position = vec3(Model * vec4(point_row2_a, 1));

        green_arrow = normalize(point_row2_b - point_row2_a);
        red_arrow   = normalize(point_row3_a - point_row2_a);
        raw_normal = cross(green_arrow, red_arrow);
        world_normal = normalize(mat3(Model) * vec3(raw_normal.x, raw_normal.y, raw_normal.z * 5.0));

        gl_Position = Projection * View * Model * vec4(point_row2_a, 1);  EmitVertex();

        // 2B
        texture_coord = vec2(t2, v2);
        world_position = vec3(Model * vec4(point_row2_b, 1));

        if (i < NO_OF_GENERATED_POINTS - 2) {
            green_arrow = normalize(point_row2_c - point_row2_b);
        } else {
             // Use the previous tangent for the very last point
            green_arrow = normalize(point_row2_b - point_row2_a);
        }
        red_arrow   = normalize(point_row3_b - point_row2_b);
        raw_normal = cross(green_arrow, red_arrow);
        world_normal = normalize(mat3(Model) * vec3(raw_normal.x, raw_normal.y, raw_normal.z * 5.0));

        gl_Position = Projection * View * Model * vec4(point_row2_b, 1);  EmitVertex();

        EndPrimitive();
    }
}