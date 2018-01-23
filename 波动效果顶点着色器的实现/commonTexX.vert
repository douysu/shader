#version 400
#extension GL_ARB_separate_shader_objects : enable
#extension GL_ARB_shading_language_420pack : enable
layout (push_constant) uniform constantVals {
	mat4 mvp;
} myConstantVals;
layout (std140,set = 0, binding =0 ) uniform bufferVals {//输入的一致块
  float uWidthSpan;//横向长度总跨度
  float uStartAngle;//起始角度
} myBufferVals;
layout (location = 0) in vec3 pos;//传入的物体坐标系顶点位置
layout (location = 1) in vec2 inTexCoor;//传入的纹理坐标
layout (location = 0) out vec2 outTexCoor;//传到片元着色器的顶点位置
out gl_PerVertex {
	vec4 gl_Position;
};
void main() {
	float angleSpanH=4.0*3.14159265;//横向角度总跨度，用于进行X距离与角度的换算
	float startX=-myBufferVals.uWidthSpan/2.0;//起始X坐标(即最左侧顶点的X坐标)
	float currAngle=myBufferVals.uStartAngle+((pos.x-startX)/myBufferVals.uWidthSpan)*angleSpanH;
	float tz=sin(currAngle)*0.5;//通过正弦函数求出当前点的Z坐标
    outTexCoor = inTexCoor;
    gl_Position = myConstantVals.mvp * vec4(pos.x,pos.y,tz,1.0);//计算顶点最终位置
}
