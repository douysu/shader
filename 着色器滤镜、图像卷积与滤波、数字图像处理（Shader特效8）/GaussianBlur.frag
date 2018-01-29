#version 400
#extension GL_ARB_separate_shader_objects : enable
#extension GL_ARB_shading_language_420pack : enable
layout (binding = 1) uniform sampler2D sTexture;
layout (location = 0) in vec2 vTextureCoord;
layout (location = 0) out vec4 outColor;
void main() {
    //纹理偏移量单位步进
    const float stStep = 256.0;
    const float scaleFactor = 1.0/209.0;//给出最终求和时的加权因子(为调整亮度)
     //给出卷积内核中各个元素对应像素相对于待处理像素的纹理坐标偏移量
    vec2 offsets[9]=vec2[9](
          vec2(-1.0,-1.0),vec2(0.0,-1.0),vec2(1.0,-1.0),
          vec2(-1.0,0.0),vec2(0.0,0.0),vec2(1.0,0.0),
          vec2(-1.0,1.0),vec2(0.0,1.0),vec2(1.0,1.0)
    );
    //卷积内核中各个位置的值
     float kernelValues[9]=float[9] (
            16.0,26.0,16.0,
            26.0,41.0,26.0,
            16.0,26.0,16.0
     );
     //最终的颜色值
     vec4 sum=vec4(0,0,0,0);
     //颜色求和
     for(int i=0;i<9;i++){
        sum=sum+kernelValues[i]*scaleFactor*texture(sTexture, vTextureCoord+offsets[i]/stStep);
     }
     outColor=sum;
}