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
        void CreateCubemapFramebuffer(int width, int height);
        unsigned int UploadCubeMapTexture(const std::string &pos_x, const std::string &pos_y, const std::string &pos_z, const std::string& neg_x, const std::string& neg_y, const std::string& neg_z);
        
        void InitTable(int scale = 1, glm::vec3 translation = glm::vec3(0, 0, 0));
        void InitVase(float scale = 1, glm::vec3 translation = glm::vec3(0, 0, 0));
        void InitLamp(float scale = 1, glm::vec3 translation = glm::vec3(0, 0, 0));
        void InitTV(int scale, glm::vec3 position);
        void InitCubemap(int scale, glm::vec3 position);
        
        void FrameStart() override;
        void Update(float deltaTimeSeconds) override;
        void FrameEnd() override;

        void RenderMeshInstanced(Mesh *mesh, Shader *shader, const glm::mat4 &modelMatrix, int instances, int light_view = 0, Texture2D* texture = NULL, int reflect_view = 0);
        
        void RenderObjects(int renderMode, Shader* cubemapShader = nullptr);

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

        // TV info
        struct TV {
            glm::vec3 position;
            float rotationY;
            float length;
            
            RotationTranlation screen;
        };
        TV tv;

        // Cubemap skybox info
        struct Cubemap {
            glm::vec3 position;
            Mesh* body;
            float size;
        };
        Cubemap cubemap;

        bool draw_framebuffer_textures = false;
        unsigned int framebuffer_object;
        unsigned int color_texture;
        unsigned int depth_texture;

        // Debug mode for reflection shader
        int debug_mode = 0;

        // Cubemap info
        unsigned int cubemap_texture_id;
        unsigned int cubemap_framebuffer_object;
        unsigned int cubemap_color_texture;
        unsigned int cubemap_depth_texture;

        // Cubemap rendering matrices (used during cubemap face rendering)
        glm::mat4 cubemapView;
        glm::mat4 cubemapProjection;
        bool isRenderingCubemap = false;

    };
}   // namespace m2
