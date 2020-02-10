#version 400
#extension GL_ARB_separate_shader_objects : enable //开启separate_shader_objects
#extension GL_ARB_shading_language_420pack : enable //开启shading_language_420pack
layout (push_constant) uniform constantVals { //推送常量块
    mat4 mvp; //总变换矩阵
} myConstantVals;
layout (std140,set = 0, binding = 0) uniform bufferVals { //一致块
    float ratio; //旋转系数(整体扭动角度因子)
} myBufferVals;
layout (location = 0) in vec3 aPosition; //输入的顶点位置
layout (location = 1) in vec2 inTexCoor; //输入的纹理坐标
layout (location = 0) out vec2 outTexCoor; //输出到片元着色器的纹理坐标
out gl_PerVertex { //输出接口块
    vec4 gl_Position; //内建变量gl_Position
};
void main() {
    float pi = 3.1415926; //圆周率近似值
    float centerX=0.0; //中心点的X 坐标
    float centerY=-15; //中心点的Y 坐标
    float currX = aPosition.x; //当前点的X 坐标
    float currY = aPosition.y; //当前点的Y 坐标
    float spanX = currX - centerX; //当前X 偏移量
    float spanY = currY - centerY; //当前Y 偏移量
    float currRadius = sqrt(spanX * spanX + spanY * spanY); //计算距离
    float currRadians; //当前点与X 轴正方向的夹角
    if(spanX != 0.0){ //一般情况
    currRadians = atan(spanY , spanX);
    }else{ //特殊情况
    currRadians = spanY > 0.0 ? pi/2.0 : 3.0*pi/2.0;
    }
    float resultRadians = currRadians + myBufferVals.ratio*currRadius; //计算出扭曲后的角度
    float resultX = centerX + currRadius * cos(resultRadians); //计算结果点的X 坐标
    float resultY = centerY + currRadius * sin(resultRadians); //计算结果点的Y 坐标
    outTexCoor = inTexCoor; //传输到片元着色器的纹理坐标
    gl_Position = myConstantVals.mvp * vec4(resultX,resultY,0.0,1.0); //计算顶点最终位置
}
