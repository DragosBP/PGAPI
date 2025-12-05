#version 430

layout(lines) in;
layout(triangle_strip, max_vertices = 70) out;

// Uniform properties
uniform mat4 View;
uniform mat4 Projection;
uniform vec3 control_p0, control_p1, control_p2, control_p3;
uniform vec3 translate;
uniform int no_of_instances;
uniform float max_rotate;

// Input
in int instance[2];
in vec3 test_normal[];

// Output
out vec2 texture_coord;
out vec3 world_position;
out vec3 world_normal;

vec3 rotateY(vec3 point, float u)
{
    float x = point.x * cos(u) - point.z *sin(u);
    float z = point.x * sin(u) + point.z *cos(u);
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

        vec3 point_row1_a = rotateY(bezier(t1), max_rotate * i_current / no_of_instances) + translate;
        vec3 point_row1_b = rotateY(bezier(t2), max_rotate * i_current / no_of_instances) + translate;
        vec3 point_row1_c = rotateY(bezier(t3), max_rotate * i_current / no_of_instances) + translate;

        vec3 point_row2_a = rotateY(bezier(t1), max_rotate * i_next / no_of_instances) + translate;
        vec3 point_row2_b = rotateY(bezier(t2), max_rotate * i_next / no_of_instances) + translate;
        vec3 point_row2_c = rotateY(bezier(t3), max_rotate * i_next / no_of_instances) + translate;

        vec3 point_row3_a = rotateY(bezier(t1), max_rotate * i_next2 / no_of_instances) + translate;
        vec3 point_row3_b = rotateY(bezier(t2), max_rotate * i_next2 / no_of_instances) + translate;

        vec3 green_arrow; 
        vec3 red_arrow;   

        // 1A
        texture_coord = vec2(t1, v1);
        world_position = point_row1_a;
        
        green_arrow = normalize(point_row1_b - point_row1_a); // Tangent along curve
        red_arrow   = normalize(point_row2_a - point_row1_a); // Tangent along rotation
        world_normal = normalize(cross(green_arrow, red_arrow));

        gl_Position = Projection * View * vec4(point_row1_a, 1);  EmitVertex();
        
        // 1B
        texture_coord = vec2(t2, v1);
        world_position = point_row1_b;

        green_arrow = normalize(point_row1_c - point_row1_b);
        red_arrow   = normalize(point_row2_b - point_row1_b);
        world_normal = normalize(cross(green_arrow, red_arrow));

        gl_Position = Projection * View * vec4(point_row1_b, 1);  EmitVertex();

        // 2A
        texture_coord = vec2(t1, v2);
        world_position = point_row2_a;

        green_arrow = normalize(point_row2_b - point_row2_a);
        red_arrow   = normalize(point_row3_a - point_row2_a);
        world_normal = normalize(cross(green_arrow, red_arrow));

        gl_Position = Projection * View * vec4(point_row2_a, 1);  EmitVertex();

        // 2B
        texture_coord = vec2(t2, v2);
        world_position = point_row2_b;

        green_arrow = normalize(point_row2_c - point_row2_b);
        red_arrow   = normalize(point_row3_b - point_row2_b);
        world_normal = normalize(cross(green_arrow, red_arrow));

        gl_Position = Projection * View * vec4(point_row2_b, 1);  EmitVertex();

        EndPrimitive();
    }
}