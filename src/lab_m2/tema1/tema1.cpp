#include "lab_m2/tema1/tema1.h"

#include <vector>
#include <iostream>

using namespace std;
using namespace m2;


/*
 *  To find out more about `FrameStart`, `Update`, `FrameEnd`
 *  and the order in which they are called, see `world.cpp`.
 */


Tema1::Tema1()
{
}


Tema1::~Tema1()
{
}


void Tema1::InitTable(int scale, glm::vec3 translation) {
    Table table;
    
    table.length = 1 * scale;
    table.width = 0.5 * scale;
    table.height = 0.1 * scale;
    translation *= scale;

    table.no_of_instances = 10;
    table.translation = translation;

    int face = 0;
    // First face
    table.control_points[face][0] = glm::vec3(0.0, 0.0, 0.0);
    table.control_points[face][1] = glm::vec3(0.0, table.height / 3, 0.0);
    table.control_points[face][2] = glm::vec3(0.0, 2 * table.height / 3, 0.0);
    table.control_points[face][3] = glm::vec3(0.0, table.height, 0.0);
    table.max_translate[face] = table.width;
    face++;

    // Second face
    table.control_points[face][0] = glm::vec3(table.width, 0.0, 0.0);
    table.control_points[face][1] = glm::vec3(table.width, table.height / 3, 0.0);
    table.control_points[face][2] = glm::vec3(table.width, 2 * table.height / 3, 0.0);
    table.control_points[face][3] = glm::vec3(table.width, table.height, 0.0);
    table.max_translate[face] = table.length;
    face++;

    // Third face
    table.control_points[face][0] = glm::vec3(0.0, 0.0, table.length);
    table.control_points[face][1] = glm::vec3(0.0, table.height / 3, table.length);
    table.control_points[face][2] = glm::vec3(0.0, 2 * table.height / 3, table.length);
    table.control_points[face][3] = glm::vec3(0.0, table.height, table.length);
    table.max_translate[face] = table.width;
    face++;

    // Fourth face
    table.control_points[face][0] = glm::vec3(0.0, 0.0, 0.0);
    table.control_points[face][1] = glm::vec3(0.0, table.height / 3, 0.0);
    table.control_points[face][2] = glm::vec3(0.0, 2 * table.height / 3, 0.0);
    table.control_points[face][3] = glm::vec3(0.0, table.height, 0.0);
    table.max_translate[face] = table.length;
    face++;

    // Bottom face
    table.control_points[face][0] = glm::vec3(0.0, 0.0, 0.0);
    table.control_points[face][1] = glm::vec3(0.0, 0.0, table.length / 3);
    table.control_points[face][2] = glm::vec3(0.0, 0.0, 2 * table.length / 3);
    table.control_points[face][3] = glm::vec3(0.0, 0.0, table.length);
    table.max_translate[face] = table.width;
    face++;

    // Top face
    table.control_points[face][0] = glm::vec3(0.0, table.height, 0.0);
    table.control_points[face][1] = glm::vec3(0.0, table.height, table.length / 3);
    table.control_points[face][2] = glm::vec3(0.0, table.height, 2 * table.length / 3);
    table.control_points[face][3] = glm::vec3(0.0, table.height, table.length);
    table.max_translate[face] = table.width;
    face++;


    table.leg.height = 2.5 * table.height;
    table.leg.no_of_instances = 20;
    table.leg.max_rotate = glm::radians(360.0);

    table.leg.control_points[0] = glm::vec3(0.020 * scale, 0.0, 0.0);
    table.leg.control_points[1] = glm::vec3(0.025 * scale, table.leg.height / 3, 0.0);
    table.leg.control_points[2] = glm::vec3(0.035 * scale, 2 * table.leg.height / 3, 0.0);
    table.leg.control_points[3] = glm::vec3(0.045 * scale, table.leg.height, 0.0);

    // Higher for leg space + ad movement
    for (int i = 0; i < face; i++) {
        for (int j = 0; j < 4; j++) {
            table.control_points[i][j].y += table.leg.height;
            table.control_points[i][j] += translation;
        }
    }

    tables.push_back(table);
}

void Tema1::InitVase(float scale, glm::vec3 translation) {
    RotationTranlation vase;

    vase.height = 0.12 * scale;
    vase.no_of_instances = 20;
    vase.max_rotate = glm::radians(360.0);
    
    vase.translation = translation * scale;
    vase.control_points[0] = glm::vec3(0.018 * scale, 0.0, 0.0);
    vase.control_points[1] = glm::vec3(0.006 * scale, vase.height / 3, 0.0);
    vase.control_points[2] = glm::vec3(0.044 * scale, 2 * vase.height / 3, 0.0);
    vase.control_points[3] = glm::vec3(0.023 * scale, vase.height, 0.0);

    vases.push_back(vase);
}

void Tema1::InitLamp(float scale, glm::vec3 translation) {
    // Body
    lamp.body.height = 0.09 * scale;
    lamp.body.no_of_instances = 20;
    lamp.body.max_rotate = glm::radians(360.0);

    lamp.body.translation = translation * scale;
    lamp.body.control_points[0] = glm::vec3(0.0 * scale, 0.0, 0.0);
    lamp.body.control_points[1] = glm::vec3(0.04 * scale, 0.0, 0.0);
    lamp.body.control_points[2] = glm::vec3(0.005 * scale, -lamp.body.height / 20, 0.0);
    lamp.body.control_points[3] = glm::vec3(0.005 * scale, lamp.body.height, 0.0);

    // Head
    lamp.head.height = lamp.body.height / 2;
    lamp.head.no_of_instances = 20;
    lamp.head.max_rotate = glm::radians(360.0);

    lamp.head.translation = translation * scale;
    lamp.head.translation.y += lamp.body.height;
    
    float deltaY = 0.003 * scale;
    float deltaXZ = 0.004 * scale;
    lamp.head.translation += glm::vec3(-deltaXZ, deltaY, deltaXZ);

    lamp.head.control_points[0] = glm::vec3(0.025 * scale, -lamp.head.height, 0.0);
    lamp.head.control_points[1] = glm::vec3(0.001 * scale, 2 * -lamp.head.height / 3, 0.0);
    lamp.head.control_points[2] = glm::vec3(0.026 * scale, -lamp.head.height / 3, 0.0);
    lamp.head.control_points[3] = glm::vec3(0.0 * scale, 0.0, 0.0);
}

void Tema1::LoadShader(const std::string& name)
{
    std::string shaderPath = PATH_JOIN(window->props.selfDir, SOURCE_PATH::M2, "Tema1", "shaders");
    std::string folder_name = name;
    folder_name[0] = std::tolower(folder_name[0]);

    // Create a shader program for particle system
    {
        Shader* shader = new Shader(name);
        shader->AddShader(PATH_JOIN(shaderPath, "VertexShader.glsl"), GL_VERTEX_SHADER);
        shader->AddShader(PATH_JOIN(shaderPath, folder_name, name + ".GS.glsl"), GL_GEOMETRY_SHADER);
        shader->AddShader(PATH_JOIN(shaderPath, "FragmentShader.glsl"), GL_FRAGMENT_SHADER);

        shader->CreateAndLink();
        shaders[shader->GetName()] = shader;
    }
}

void Tema1::Init()
{
    auto camera = GetSceneCamera();
    camera->SetPositionAndRotation(glm::vec3(0, 1, 1), glm::quat(glm::vec3(-40 * TO_RADIANS, 0, 0)));
    camera->Update();

    scale = 2;

    // Table details
    {
        LoadShader("Table");
        LoadShader("TableLeg");

        TextureManager::LoadTexture(PATH_JOIN(window->props.selfDir, RESOURCE_PATH::TEXTURES), "wood.jpg");

        InitTable(scale, glm::vec3(0, 0, 0));
        InitTable(scale, glm::vec3(1, 0, 0));
    }

    // Vase details
    {
        LoadShader("Vase");

        TextureManager::LoadTexture(PATH_JOIN(window->props.selfDir, RESOURCE_PATH::TEXTURES), "vase.jpg");

        InitVase(scale, glm::vec3(1.25, (tables[0].height + tables[0].leg.height) / scale, 0.25));
        InitVase(scale, glm::vec3(1.25, (tables[0].height + tables[0].leg.height) / scale, 0.75));
    }

    // Lamp details
    {
        LoadShader("Lamp");

        TextureManager::LoadTexture(PATH_JOIN(window->props.selfDir, RESOURCE_PATH::TEXTURES), "white.png");
        TextureManager::LoadTexture(PATH_JOIN(window->props.selfDir, RESOURCE_PATH::TEXTURES), "wood2.jpg");

        InitLamp(scale, glm::vec3(0.25, (tables[0].height + tables[0].leg.height) / scale, 0.85));
    }


    // Light vSource Details
    {
        light.pos = glm::vec3(0.5, 0.5, 0.5) * (float)scale;
        light.rot = glm::normalize(glm::vec3(-1, -1, -1));

        light.near_plane = 0.0001f;
        light.far_plane = 32.0f;
        
        glm::ivec2 resolution = window->GetResolution();
        light.width = 2048;
        light.height = 2048;

        framebuffer_object = 0;
        color_texture = 0;
        depth_texture = 0;

        CreateFramebuffer(light.width, light.height);

        // For testing the light
        Mesh* mesh = new Mesh("sphere");
        mesh->LoadMesh(PATH_JOIN(window->props.selfDir, RESOURCE_PATH::MODELS, "primitives"), "sphere.obj");
        meshes[mesh->GetMeshID()] = mesh;

        std::string shaderPath = PATH_JOIN(window->props.selfDir, SOURCE_PATH::M2, "Tema1", "shaders", "view");
        
        Shader* color = new Shader("ViewColorTexture");
        color->AddShader(PATH_JOIN(shaderPath, "ViewColorTexture.VS.glsl"), GL_VERTEX_SHADER);
        color->AddShader(PATH_JOIN(shaderPath, "ViewColorTexture.FS.glsl"), GL_FRAGMENT_SHADER);
        color->CreateAndLink();
        shaders[color->GetName()] = color;

        Shader* depth = new Shader("ViewDepthTexture");
        depth->AddShader(PATH_JOIN(shaderPath, "ViewDepthTexture.VS.glsl"), GL_VERTEX_SHADER);
        depth->AddShader(PATH_JOIN(shaderPath, "ViewDepthTexture.FS.glsl"), GL_FRAGMENT_SHADER);
        depth->CreateAndLink();
        shaders[depth->GetName()] = depth;
    }

    {
        Mesh* mesh = new Mesh("quad");
        mesh->LoadMesh(PATH_JOIN(window->props.selfDir, RESOURCE_PATH::MODELS, "primitives"), "quad.obj");
        mesh->UseMaterials(false);
        meshes[mesh->GetMeshID()] = mesh;
    }

    {
        vector<VertexFormat> vertices
        {
            VertexFormat(tables[0].control_points[0][0], glm::vec3(0, 1, 1)),
            VertexFormat(tables[0].control_points[0][3], glm::vec3(0, 1, 0))
        };

        vector<unsigned int> indices =
        {
            0, 1
        };

        meshes["surface"] = new Mesh("generated initial surface points");
        meshes["surface"]->InitFromData(vertices, indices);
        meshes["surface"]->SetDrawMode(GL_LINES);
    }
}

void Tema1::CreateFramebuffer(int width, int height) {
    // Generate and bind the framebuffer
    glGenFramebuffers(1, &framebuffer_object);
    glBindFramebuffer(GL_FRAMEBUFFER, framebuffer_object);

    // Generate, bind and initialize the color texture
    glGenTextures(1, &color_texture);
    glBindTexture(GL_TEXTURE_2D, color_texture);
    glTexImage2D(GL_TEXTURE_2D, 0, GL_RGB, width, height, 0, GL_RGB, GL_UNSIGNED_BYTE, NULL);

    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_LINEAR);

    // Bind the color texture to the
    // framebuffer as a color attachment at position 0
    glFramebufferTexture(GL_FRAMEBUFFER, GL_COLOR_ATTACHMENT0, color_texture, 0);

    // Generate, bind and initialize the depth texture
    glGenTextures(1, &depth_texture);
    glBindTexture(GL_TEXTURE_2D, depth_texture);
    glTexImage2D(GL_TEXTURE_2D, 0, GL_DEPTH_COMPONENT32F, width, height, 0, GL_DEPTH_COMPONENT, GL_UNSIGNED_BYTE, 0);

    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_NEAREST);

    // Bind the depth texture to the framebuffer as a depth attachment
    glFramebufferTexture(GL_FRAMEBUFFER, GL_DEPTH_ATTACHMENT, depth_texture, 0);

    // Set the color texture as the draw texture
    std::vector<GLenum> draw_textures;

    draw_textures.push_back(GL_COLOR_ATTACHMENT0);

    glDrawBuffers(draw_textures.size(), &draw_textures[0]);

    // Check the status of the framebuffer
    if (glCheckFramebufferStatus(GL_FRAMEBUFFER) != GL_FRAMEBUFFER_COMPLETE)
        std::cout << "FRAMEBUFFER NOT COMPLETE" << std::endl;

    // Bind the default framebuffer
    glBindFramebuffer(GL_FRAMEBUFFER, 0);
}

void Tema1::FrameStart()
{
    // Clears the color buffer (using the previously set color) and depth buffer
    glClearColor(0, 0, 0, 1);
    glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT);

    glm::ivec2 resolution = window->GetResolution();
    // Sets the screen area where to draw
    glViewport(0, 0, resolution.x, resolution.y);
}


void Tema1::RenderMeshInstanced(Mesh *mesh, Shader *shader, const glm::mat4 &modelMatrix, int instances, int light_view, Texture2D* texture)
{
    if (!mesh || !shader || !shader->GetProgramID())
        return;

    // Render an object using the specified shader
    glUseProgram(shader->program);

    // Set shader uniforms for light properties
    GLint loc_light_position = glGetUniformLocation(shader->program, "light_position");
    glUniform3f(loc_light_position, light.pos.x, light.pos.y, light.pos.z);

    GLint loc_light_direction = glGetUniformLocation(shader->program, "light_direction");
    glUniform3f(loc_light_direction, light.rot.x, light.rot.y, light.rot.z);

    // Set eye position (camera position) uniform
    glm::vec3 eyePosition = GetSceneCamera()->m_transform->GetWorldPosition();
    GLint eye_position = glGetUniformLocation(shader->program, "eye_position");
    glUniform3f(eye_position, eyePosition.x, eyePosition.y, eyePosition.z);

    // Bind model matrix
    GLint loc_model_matrix = glGetUniformLocation(shader->program, "Model");
    glUniformMatrix4fv(loc_model_matrix, 1, GL_FALSE, glm::value_ptr(modelMatrix));

    // Bind view matrix
    glm::mat4 viewMatrix = GetSceneCamera()->GetViewMatrix();
    int loc_view_matrix = glGetUniformLocation(shader->program, "View");
    glUniformMatrix4fv(loc_view_matrix, 1, GL_FALSE, glm::value_ptr(viewMatrix));

    // Bind projection matrix
    glm::mat4 projectionMatrix = GetSceneCamera()->GetProjectionMatrix();
    int loc_projection_matrix = glGetUniformLocation(shader->program, "Projection");
    glUniformMatrix4fv(loc_projection_matrix, 1, GL_FALSE, glm::value_ptr(projectionMatrix));

    // Set light space view matrix uniform
    GLint loc_light_space_view = glGetUniformLocation(shader->program, "light_space_view");
    glUniformMatrix4fv(loc_light_space_view, 1, GL_FALSE, glm::value_ptr(light.space_view));

    // Set light space projection matrix uniform
    GLint loc_light_space_projection = glGetUniformLocation(shader->program, "light_space_projection");
    glUniformMatrix4fv(loc_light_space_projection, 1, GL_FALSE, glm::value_ptr(light.space_projection));

    // Set uniform for the far plane of the
    // projection transformation in the light space
    GLint loc_light_space_far_plane = glGetUniformLocation(shader->program, "light_space_far_plane");
    glUniform1f(loc_light_space_far_plane, light.far_plane);

    if (texture)
    {
        glActiveTexture(GL_TEXTURE0);
        glBindTexture(GL_TEXTURE_2D, texture->GetTextureID());
        glUniform1i(glGetUniformLocation(shader->program, "texture_1"), 0);
    }

    glUniform1i(glGetUniformLocation(shader->program, "light_view"), light_view);

    glActiveTexture(GL_TEXTURE1);
    glBindTexture(GL_TEXTURE_2D, depth_texture);
    glUniform1i(glGetUniformLocation(shader->program, "depth_texture"), 1);

    // Draw the object instanced
    glBindVertexArray(mesh->GetBuffers()->m_VAO);
    glDrawElementsInstanced(mesh->GetDrawMode(), static_cast<int>(mesh->indices.size()), GL_UNSIGNED_INT, (void*)0, instances);
}

void Tema1::DrawFramebufferTextures()
{
    int screenPosX = window->GetResolution().x - 950;
    int screenPosY = 100;

    int width = 400;
    int height = 400;

    if (color_texture)
    {
        // Render the color texture on the screen
        glViewport(screenPosX, screenPosY, width, height);

        RenderTextureScreen(shaders["ViewColorTexture"], color_texture);
    }

    if (depth_texture)
    {
        // Render the depth texture on the screen
        glViewport(screenPosX + 450, screenPosY, width, height);

        RenderTextureScreen(shaders["ViewDepthTexture"], depth_texture);
    }
}

void Tema1::RenderTextureScreen(Shader* shader, unsigned int textureID)
{
    if (!shader || !shader->GetProgramID())
        return;

    // Render an object using the specified shader and the specified position
    glUseProgram(shader->program);

    // Set uniforms for near and far plane of the
    // projection transformation in the light space
    GLint loc_light_space_near_plane = glGetUniformLocation(shader->program, "light_space_near_plane");
    glUniform1f(loc_light_space_near_plane, light.near_plane);

    GLint loc_light_space_far_plane = glGetUniformLocation(shader->program, "light_space_far_plane");
    glUniform1f(loc_light_space_far_plane, light.far_plane);

    // Set texture uniform
    glActiveTexture(GL_TEXTURE0);
    glBindTexture(GL_TEXTURE_2D, textureID);
    glUniform1i(glGetUniformLocation(shader->program, "texture_1"), 0);

    // Draw the object
    glBindVertexArray(meshes["quad"]->GetBuffers()->m_VAO);
    glDrawElements(meshes["quad"]->GetDrawMode(), static_cast<int>(meshes["quad"]->indices.size()), GL_UNSIGNED_INT, 0);
}

void Tema1::Update(float deltaTimeSeconds)
{
    ClearScreen();
    //glPolygonMode(GL_FRONT_AND_BACK, GL_LINE);


    auto camera = GetSceneCamera();

    glm::vec3 camPosition = camera->m_transform->GetWorldPosition();
    glm::quat camRotation = camera->m_transform->GetWorldRotation();
    auto projectionInfo = camera->GetProjectionInfo();

    for (int step = 0; step < 2; step++) {
        if (step == 0) {
            // Render the scene from the light source view
            camera->SetPosition(light.pos);
            camera->SetRotation(glm::quatLookAt(light.rot, glm::vec3(0, 1, 0)));

            // The spot light source has an angle opening of 90
            // degrees, so a perspective projection is used with
            // a viewing angle of 90 degrees both vertically and
            // horizontally. For this reason, an aspect ratio of
            // 1 is used.
            camera->SetPerspective(90, 1,
                light.near_plane, light.far_plane);

            // Save the view and projection matrix
            light.space_view = camera->GetViewMatrix();
            light.space_projection = camera->GetProjectionMatrix();

            // Bind the framebuffer created before
            // and clear the color and depth textures
            glBindFramebuffer(GL_FRAMEBUFFER, framebuffer_object);
            glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT);


            // Use glViewport to specify the render
            // area whose size (width, height) is the resolution of
            // the textures in the framebuffer
            glViewport(0, 0, light.width, light.height);
        }   
        else {
            // Render the scene from the player's view
            camera->SetPosition(camPosition);
            camera->SetRotation(camRotation);
            camera->SetProjection(projectionInfo);

            // Bind the default framebuffer
            // and clear the color and depth textures
            glBindFramebuffer(GL_FRAMEBUFFER, 0);
            glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT);

            // Use glViewport to specify the render
            // area whose size is the resolution of the window
            glm::ivec2 resolution = window->GetResolution();

            glViewport(0, 0, resolution.x, resolution.y);

            glm::mat4 modelMatrix = glm::mat4(1);
            modelMatrix = glm::translate(modelMatrix, light.pos);
            modelMatrix = glm::scale(modelMatrix, glm::vec3(0.01 * scale));
            RenderMesh(meshes["sphere"], shaders["Simple"], modelMatrix);
        }

        for (auto& table : tables) {
            // Table logic

            // Main body
            Shader* shader = shaders["Table"];
            shader->Use();

            for (int i = 0; i < 6; i++) {
                // Send uniforms to shaders
                glUniform3f(glGetUniformLocation(shader->program, "control_p0"), table.control_points[i][0].x, table.control_points[i][0].y, table.control_points[i][0].z);
                glUniform3f(glGetUniformLocation(shader->program, "control_p1"), table.control_points[i][1].x, table.control_points[i][1].y, table.control_points[i][1].z);
                glUniform3f(glGetUniformLocation(shader->program, "control_p2"), table.control_points[i][2].x, table.control_points[i][2].y, table.control_points[i][2].z);
                glUniform3f(glGetUniformLocation(shader->program, "control_p3"), table.control_points[i][3].x, table.control_points[i][3].y, table.control_points[i][3].z);
                glUniform1f(glGetUniformLocation(shader->program, "max_translate"), table.max_translate[i]);
                glUniform1i(glGetUniformLocation(shader->program, "no_of_instances"), table.no_of_instances);

                int shouldFlip = 0;
                if (i < 4)
                {
                    glUniform1i(glGetUniformLocation(shader->program, "rotate"), i % 2);
                    if (i == 2 || i == 3) shouldFlip = 1;
                }
                else {
                    glUniform1i(glGetUniformLocation(shader->program, "rotate"), 0);
                    if (i == 4) shouldFlip = 1;
                }

               glUniform1i(glGetUniformLocation(shader->program, "flip_normal_in"), shouldFlip);
                Mesh* mesh = meshes["surface"];

                // Draw the object instanced
                RenderMeshInstanced(mesh, shader, glm::mat4(1), table.no_of_instances, step, TextureManager::GetTexture("wood.jpg"));
            }

            // Legs
            shader = shaders["TableLeg"];
            shader->Use();


            for (int i = 0; i < 4; i++) {
                float translateX = (i == 2 || i == 3) ? 4 * table.width / 5 : table.width / 5;
                translateX += table.translation.x;

                float translateZ = (i == 1 || i == 2) ? 4 * table.length / 5 : table.length / 5;
                translateZ += table.translation.z;


                // Send uniforms to shaders
                glUniform3f(glGetUniformLocation(shader->program, "control_p0"), table.leg.control_points[0].x, table.leg.control_points[0].y, table.leg.control_points[0].z);
                glUniform3f(glGetUniformLocation(shader->program, "control_p1"), table.leg.control_points[1].x, table.leg.control_points[1].y, table.leg.control_points[1].z);
                glUniform3f(glGetUniformLocation(shader->program, "control_p2"), table.leg.control_points[2].x, table.leg.control_points[2].y, table.leg.control_points[2].z);
                glUniform3f(glGetUniformLocation(shader->program, "control_p3"), table.leg.control_points[3].x, table.leg.control_points[3].y, table.leg.control_points[3].z);
                glUniform3f(glGetUniformLocation(shader->program, "translate"), translateX, 0.0, translateZ);
                glUniform1f(glGetUniformLocation(shader->program, "max_rotate"), table.leg.max_rotate);
                glUniform1i(glGetUniformLocation(shader->program, "no_of_instances"), table.leg.no_of_instances);


                Mesh* mesh = meshes["surface"];

                // Draw the object instanced
                RenderMeshInstanced(mesh, shader, glm::mat4(1), table.leg.no_of_instances, step, TextureManager::GetTexture("wood.jpg"));
            }
        }


        // Vases
        for (auto& vase : vases) {
            Shader *shader = shaders["Vase"];
            shader->Use();

            // Send uniforms to shaders
            glUniform3f(glGetUniformLocation(shader->program, "control_p0"), vase.control_points[0].x, vase.control_points[0].y, vase.control_points[0].z);
            glUniform3f(glGetUniformLocation(shader->program, "control_p1"), vase.control_points[1].x, vase.control_points[1].y, vase.control_points[1].z);
            glUniform3f(glGetUniformLocation(shader->program, "control_p2"), vase.control_points[2].x, vase.control_points[2].y, vase.control_points[2].z);
            glUniform3f(glGetUniformLocation(shader->program, "control_p3"), vase.control_points[3].x, vase.control_points[3].y, vase.control_points[3].z);
            glUniform3f(glGetUniformLocation(shader->program, "translate"), vase.translation.x, vase.translation.y, vase.translation.z);
            glUniform1f(glGetUniformLocation(shader->program, "max_rotate"), vase.max_rotate);
            glUniform1i(glGetUniformLocation(shader->program, "no_of_instances"), vase.no_of_instances);


            Mesh* mesh = meshes["surface"];

            RenderMeshInstanced(mesh, shader, glm::mat4(1.0f), vase.no_of_instances, step, TextureManager::GetTexture("vase.jpg"));
        }

        // Lamp
        {
            Mesh* mesh = meshes["surface"];

            // Body
            Shader* shader = shaders["Lamp"];
            shader->Use();

            // Send uniforms to shaders
            glUniform3f(glGetUniformLocation(shader->program, "control_p0"), lamp.body.control_points[0].x, lamp.body.control_points[0].y, lamp.body.control_points[0].z);
            glUniform3f(glGetUniformLocation(shader->program, "control_p1"), lamp.body.control_points[1].x, lamp.body.control_points[1].y, lamp.body.control_points[1].z);
            glUniform3f(glGetUniformLocation(shader->program, "control_p2"), lamp.body.control_points[2].x, lamp.body.control_points[2].y, lamp.body.control_points[2].z);
            glUniform3f(glGetUniformLocation(shader->program, "control_p3"), lamp.body.control_points[3].x, lamp.body.control_points[3].y, lamp.body.control_points[3].z);
            glUniform1f(glGetUniformLocation(shader->program, "max_rotate"), lamp.body.max_rotate);
            glUniform1i(glGetUniformLocation(shader->program, "no_of_instances"), lamp.body.no_of_instances);

            glm::mat4 model = glm::mat4(1);
            model = glm::translate(model, lamp.body.translation);

            RenderMeshInstanced(mesh, shader, model, lamp.body.no_of_instances, step, TextureManager::GetTexture("wood2.jpg"));

            // Lamp
            glUniform3f(glGetUniformLocation(shader->program, "control_p0"), lamp.head.control_points[0].x, lamp.head.control_points[0].y, lamp.head.control_points[0].z);
            glUniform3f(glGetUniformLocation(shader->program, "control_p1"), lamp.head.control_points[1].x, lamp.head.control_points[1].y, lamp.head.control_points[1].z);
            glUniform3f(glGetUniformLocation(shader->program, "control_p2"), lamp.head.control_points[2].x, lamp.head.control_points[2].y, lamp.head.control_points[2].z);
            glUniform3f(glGetUniformLocation(shader->program, "control_p3"), lamp.head.control_points[3].x, lamp.head.control_points[3].y, lamp.head.control_points[3].z);
            glUniform1f(glGetUniformLocation(shader->program, "max_rotate"), lamp.head.max_rotate);
            glUniform1i(glGetUniformLocation(shader->program, "no_of_instances"), lamp.head.no_of_instances);

            model = glm::mat4(1);
            model = glm::translate(model, lamp.head.translation);
            model = glm::rotate(model, glm::radians(75.0f), glm::vec3(1, 0, 1));


            RenderMeshInstanced(mesh, shader, model, lamp.head.no_of_instances, step, TextureManager::GetTexture("white.png"));
        }
    }

    if (draw_framebuffer_textures) {
        // Render on the screen the color and depth textures
        // of the previously created framebuffer
        DrawFramebufferTextures();
    }
}


void Tema1::FrameEnd()
{
    DrawCoordinateSystem();
}


/*
 *  These are callback functions. To find more about callbacks and
 *  how they behave, see `input_controller.h`.
 */


void Tema1::OnInputUpdate(float deltaTime, int mods)
{
    // Treat continuous update based on input

    // You can move the control points around by using the dedicated key,
    // in combination with Ctrl, Shift, or both.
    float delta = deltaTime;
    auto keyMaps = std::vector<std::pair<glm::vec3 &, uint32_t>>
    {
        { lamp.head.control_points[0], GLFW_KEY_1},
        { lamp.head.control_points[1], GLFW_KEY_2 },
        { lamp.head.control_points[2], GLFW_KEY_3 },
        { lamp.head.control_points[3], GLFW_KEY_4 }
    };

    for (const auto &k : keyMaps)
    {
        if (window->KeyHold(k.second))
        {
            if (mods & GLFW_MOD_SHIFT && mods & GLFW_MOD_CONTROL)
            {
                k.first.y -= delta / 10;
            }
            else if (mods & GLFW_MOD_SHIFT && mods & GLFW_MOD_ALT) 
            {
                k.first.z -= delta / 10;
            }
            else if (mods & GLFW_MOD_ALT)
            {
                k.first.z += delta / 10;
            }
            else if (mods & GLFW_MOD_CONTROL)
            {
                k.first.y += delta / 10;
            }
            else if (mods & GLFW_MOD_SHIFT)
            {
                k.first.x -= delta / 10;
            }
            else
            {
                k.first.x += delta / 10;
            }

            std::cout << glm::vec2(lamp.head.control_points[0]);
            std::cout << glm::vec2(lamp.head.control_points[1]);
            std::cout << glm::vec2(lamp.head.control_points[2]);
            std::cout << glm::vec2(lamp.head.control_points[3]) << "\n";
        }
    }

    float moveSpeed = scale * 0.20f;
    float rotateSpeed = 1.5f;

    if (!window->MouseHold(GLFW_MOUSE_BUTTON_RIGHT))
    {
        glm::vec3 up = glm::vec3(0, 1, 0);
        glm::vec3 right = GetSceneCamera()->m_transform->GetLocalOXVector();
        glm::vec3 forward = GetSceneCamera()->m_transform->GetLocalOZVector();
        forward = glm::normalize(glm::vec3(forward.x, 0, forward.z));

        if (window->KeyHold(GLFW_KEY_W)) light.pos -= forward * deltaTime * moveSpeed;
        if (window->KeyHold(GLFW_KEY_A)) light.pos -= right * deltaTime * moveSpeed;
        if (window->KeyHold(GLFW_KEY_S)) light.pos += forward * deltaTime * moveSpeed;
        if (window->KeyHold(GLFW_KEY_D)) light.pos += right * deltaTime * moveSpeed;

        if (window->KeyHold(GLFW_KEY_E)) light.pos += up * deltaTime * moveSpeed;
        if (window->KeyHold(GLFW_KEY_Q)) light.pos -= up * deltaTime * moveSpeed;

        if (window->KeyHold(GLFW_KEY_R)) {
            glm::mat4 rotMatrix = glm::rotate(glm::mat4(1.0f), deltaTime * rotateSpeed, glm::vec3(0, 1, 0));
            light.rot = glm::vec3(rotMatrix * glm::vec4(light.rot, 0.0f));
        }

        if (window->KeyHold(GLFW_KEY_F)) {
            glm::mat4 rotMatrix = glm::rotate(glm::mat4(1.0f), -deltaTime * rotateSpeed, glm::vec3(0, 1, 0));
            light.rot = glm::vec3(rotMatrix * glm::vec4(light.rot, 0.0f));
        }

        light.rot = glm::normalize(light.rot);
    }

}


void Tema1::OnKeyPress(int key, int mods)
{
    if (key == GLFW_KEY_P) {
        lamp.head.no_of_instances++;
    }
    if (key == GLFW_KEY_O && lamp.head.no_of_instances > 1) {
        lamp.head.no_of_instances--;
    }
    if (key == GLFW_KEY_F1) {
        draw_framebuffer_textures = !draw_framebuffer_textures;
    }
}


void Tema1::OnKeyRelease(int key, int mods)
{
    // Add key release event
}


void Tema1::OnMouseMove(int mouseX, int mouseY, int deltaX, int deltaY)
{
    // Add mouse move event
}


void Tema1::OnMouseBtnPress(int mouseX, int mouseY, int button, int mods)
{
    // Add mouse button press event
}


void Tema1::OnMouseBtnRelease(int mouseX, int mouseY, int button, int mods)
{
    // Add mouse button release event
}


void Tema1::OnMouseScroll(int mouseX, int mouseY, int offsetX, int offsetY)
{
    // Treat mouse scroll event
}


void Tema1::OnWindowResize(int width, int height)
{
    // Treat window resize event
}
