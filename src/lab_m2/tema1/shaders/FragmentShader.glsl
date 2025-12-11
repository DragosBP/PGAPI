#version 430

// Input
in vec2 texture_coord;
in vec3 world_position;
in vec3 world_normal;

// Uniform properties
uniform sampler2D texture_1;
uniform sampler2D depth_texture;

uniform int light_view;

uniform int reflect_view;
uniform samplerCube texture_cubemap;

uniform vec3 eye_position;
uniform vec3 light_position;
uniform vec3 light_direction;

uniform float light_space_far_plane;

uniform mat4 light_space_view;
uniform mat4 light_space_projection;

// Output
layout(location = 0) out vec4 out_color;

const vec3 KA = vec3 (0.1);            // ambient factor
const vec3 KD = vec3 (0.3);             // diffuse factor
const vec3 KS = vec3 (0.3);             // specular factor
const float SPECULAR_EXPONENT = 40.0;   // specular exponent

const float spot_angle = 45.0;

vec3 PhongLight()
{
    vec3 N = normalize(world_normal);
    vec3 L = normalize(light_position - world_position);

    float dist = distance(light_position, world_position);

    if (dist > light_space_far_plane)
        return vec3(0);

    float att = pow((light_space_far_plane - dist) /
        light_space_far_plane, 2);

    float dot_specular = dot(N, L);
    vec3 specular = vec3(0);
    if (dot_specular > 0)
    {
        vec3 V = normalize(eye_position - world_position);
        vec3 H = normalize(L + V);
        specular = KS * pow(max(dot(N, H), 0), SPECULAR_EXPONENT);
    }

    vec3 diffuse = KD * max(dot_specular, 0);

    return att * (diffuse + specular);
}

float ShadowFactor()
{
    vec4 light_space_pos = light_space_projection * light_space_view * vec4(world_position, 1.0f);
    
    vec3 proj_coords = light_space_pos.xyz / light_space_pos.w;
    
    proj_coords = proj_coords * 0.5 + 0.5;

    if (proj_coords.z > 1.0)
        return 1.0f;

    float current_depth = proj_coords.z;
    float closest_depth = texture(depth_texture, proj_coords.xy).r;

    vec3 normal = normalize(world_normal);
    vec3 light_dir = normalize(light_position - world_position);
    
    float bias = max(0.00001 * (1.0 - dot(normal, light_dir)), 0.000001);

    return (current_depth - bias) < closest_depth ? 1.0f : 0.0f;
}

vec3 SpotLight()
{
    float light_intensity = 10.0f;

    vec3 L = normalize(light_position - world_position);

    float cut_off = radians(spot_angle);
    float spot_light = dot(-L, light_direction);

    if (spot_light > cos(cut_off)) {

        float spot_light_limit = cos(cut_off);
 
        float linear_att = (spot_light - spot_light_limit) / (1.0f - spot_light_limit);
        float light_att_factor = pow(linear_att, 2);

        float shadow = ShadowFactor();

        vec3 light_result = light_att_factor * light_intensity * PhongLight();
        return shadow * light_result + KA;
    }

    return KA;
}

vec3 myReflect()
{
    
    vec3 view_direction = normalize(world_position - eye_position);
    vec3 reflect_direction = reflect(view_direction, normalize(world_normal));
    return texture(texture_cubemap, reflect_direction).rgb;
}

// Debug mode: 0 = normal, 1 = normals, 2 = world_pos, 3 = view_dir, 4 = reflect_dir, 5 = cubemap, 6 = check cubemap
uniform int debug_mode;

void main()
{
    vec4 texture_color = texture(texture_1, texture_coord);
   
   if (texture_color.a < 0.75) {
        discard;
    }
    
    vec3 color = vec3(texture_color);
    int alpha = 1;

    if (light_view == 1) {
        color = color * SpotLight();

        if (reflect_view == 1) {
            vec3 N = normalize(world_normal);
            vec3 view_direction = normalize(world_position - eye_position);
            vec3 reflect_direction = reflect(view_direction, N);

            if (debug_mode == 1) {
                // Show normals (should see color gradients on the TV screen)
                color = N * 0.5 + 0.5;
            } else if (debug_mode == 2) {
                // Show world position
                color = fract(world_position);
            } else if (debug_mode == 3) {
                // Show view direction
                color = view_direction * 0.5 + 0.5;
            } else if (debug_mode == 4) {
                // Show reflect direction
                color = reflect_direction * 0.5 + 0.5;
            } else {
                vec3 cubemap_color = texture(texture_cubemap, reflect_direction).rgb;
                
                if (debug_mode == 5) {
                    color = cubemap_color;
                } else if (debug_mode == 6) {
                    // White if cubemap returns color, black if zero
                    color = vec3(length(cubemap_color) > 0.001 ? 1.0 : 0.0);
                } else {
                    color = cubemap_color;
                }
            }
            alpha = 0;
        }
    }

    out_color = vec4(color, alpha);
}
