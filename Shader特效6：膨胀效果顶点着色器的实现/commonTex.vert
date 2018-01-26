#version 400
#extension GL_ARB_separate_shader_objects : enable //开启separate_shader_objects
#extension GL_ARB_shading_language_420pack : enable //开启shading_language_420pack
layout (push_constant) uniform constantVals { //推送常量块
    mat4 mvp; //总变换矩阵
} myConstantVals;
layout (std140,set = 0, binding = 0) uniform bufferVals { //一致块
    float uFatFactor; //吹气膨胀系数
} myBufferVals;
layout (location = 0) in vec3 pos; //输入的顶点位置
layout (location = 1) in vec2 inTexCoor; //输入的纹理坐标
layout (location = 2) in vec3 inNormal; //输入的顶点法向量
layout (location = 0) out vec2 outTexCoor; //输出到片元着色器的纹理坐标
out gl_PerVertex { //输出接口块
    vec4 gl_Position; //内建变量gl_Position
};
void main() {
    outTexCoor = inTexCoor; //输出到片元着色器的纹理坐标
    gl_Position = myConstantVals.mvp* vec4(pos+inNormal*myBufferVals.uFatFactor,1.0); //根据吹气膨胀系数计算顶点最终位置
}
