#pragma once

#include "components/simple_scene.h"
#include "components/transform.h"

namespace m2
{
    class Tema1 : public gfxc::SimpleScene
    {
     public:
         Tema1();
        ~Tema1();

        void Init() override;

     private:
        void CreateFramebuffer(int width, int height);
        
        void InitTable(int scale = 1, glm::vec3 translation = glm::vec3(0, 0, 0));
        void InitVase(float scale = 1, glm::vec3 translation = glm::vec3(0, 0, 0));
        void InitLamp(float scale = 1, glm::vec3 translation = glm::vec3(0, 0, 0));
        void InitTV(int scale, glm::vec3 position);
        
        void FrameStart() override;
        void Update(float deltaTimeSeconds) override;
        void FrameEnd() override;

        void RenderMeshInstanced(Mesh *mesh, Shader *shader, const glm::mat4 &modelMatrix, int instances, int light_view = 0, Texture2D* texture = NULL);

        void OnInputUpdate(float deltaTime, int mods) override;
        void OnKeyPress(int key, int mods) override;
        void OnKeyRelease(int key, int mods) override;
        void OnMouseMove(int mouseX, int mouseY, int deltaX, int deltaY) override;
        void OnMouseBtnPress(int mouseX, int mouseY, int button, int mods) override;
        void OnMouseBtnRelease(int mouseX, int mouseY, int button, int mods) override;
        void OnMouseScroll(int mouseX, int mouseY, int offsetX, int offsetY) override;
        void OnWindowResize(int width, int height) override;

        void LoadShader(const std::string& fileName);
        
        void DrawFramebufferTextures();
        void RenderTextureScreen(Shader* shader, unsigned int textureID);
    protected:
         int scale;

        struct TableLegs {
            float height;
            int no_of_instances;
            glm::vec3 control_points[4];
            float max_rotate;
        };

        // Table info
        struct Table {
            glm::vec3 translation;

            float width;
            float length;
            float height;
            int no_of_instances;
            glm::vec3 control_points[6][4];
            float max_translate[6];

            TableLegs leg;
        };

        std::vector<Table> tables;
        
        // Vase info
        struct RotationTranlation {
            glm::vec3 translation;
            float height;
            int no_of_instances;
            float max_rotate;
            glm::vec3 control_points[4];
        };

        std::vector<RotationTranlation> vases;

        // Lamp info
        struct Lamp {
            RotationTranlation body;
            RotationTranlation head;
        };
        Lamp lamp;

        // Light info
        struct Light {
            glm::vec3 pos;
            glm::vec3 rot;
            
            float near_plane;
            float far_plane;

            int width;
            int height;

            glm::mat4 space_view;
            glm::mat4 space_projection;
        };
        Light light;

        // TV Screen info
        struct TV {
            glm::vec3 position;
            float rotationY;
            std::string name;
            Mesh* body;
        };
        TV tv;

        bool draw_framebuffer_textures = false;
        unsigned int framebuffer_object;
        unsigned int color_texture;
        unsigned int depth_texture;

    };
}   // namespace m2
