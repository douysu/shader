#version 400
#extension GL_ARB_separate_shader_objects : enable
#extension GL_ARB_shading_language_420pack : enable
layout (push_constant) uniform constantVals {
	mat4 mvp;
} myConstantVals;
layout (std140,set = 0, binding =0 ) uniform bufferVals {//输入的一致块
    float angleSpan;//本帧扭曲总角度
    float yStart;//Y坐标起始点
    float ySpan;//Y坐标总跨度
} myBufferVals;
layout (location = 0) in vec3 pos;//输入的物体坐标系顶点位置
layout (location = 1) in vec2 inTexCoor;//输入的纹理坐标
layout (location = 0) out vec2 outTexCoor;//输出到片元着色器的纹理坐标
out gl_PerVertex {
	vec4 gl_Position;
};
void main() {
   float currAngle= myBufferVals.angleSpan*(pos.y-myBufferVals.yStart)/myBufferVals.ySpan;//计算当前顶点扭动(绕中心点选择)的角度
   vec3 tPosition=pos;
   if(pos.y>myBufferVals.yStart){//若不是最下面一层的顶点则计算扭动后的X、Z坐标
     tPosition.x=(cos(currAngle)*pos.x-sin(currAngle)*pos.z);
     tPosition.z=(sin(currAngle)*pos.x+cos(currAngle)*pos.z);
   }
    outTexCoor = inTexCoor;
    gl_Position = myConstantVals.mvp * vec4(tPosition,1.0);
}
