#version 400
#extension GL_ARB_separate_shader_objects : enable
#extension GL_ARB_shading_language_420pack : enable
layout (push_constant) uniform constantVals {
	mat4 mvp;
} myConstantVals;
layout (std140,set = 0, binding = 0) uniform bufferVals {
    float uBfb;
} myBufferVals;
layout (location = 0) in vec3 aPosition;
layout (location = 1) in vec3 bPosition;
layout (location = 2) in vec3 cPosition;
layout (location = 3) in vec2 inTexCoor;

layout (location = 0) out vec2 outTexCoor;
out gl_PerVertex { 
	vec4 gl_Position;
};
void main() {
    vec3 tPosition;//融合后的结果顶点
    if(myBufferVals.uBfb<=1.0)//若融合比例小于等于1，则需要执行的是1、2号关键帧的融合
    {
       	tPosition=mix(aPosition,bPosition,myBufferVals.uBfb);
    }else//若融合比例大于1，则需要执行的是2、3号关键帧的融合
    {
       	tPosition=mix(bPosition,cPosition,myBufferVals.uBfb-1.0);
     }
    outTexCoor = inTexCoor;
    gl_Position = myConstantVals.mvp * vec4(tPosition,1.0);
}
