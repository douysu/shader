#version 400
#extension GL_ARB_separate_shader_objects : enable
#extension GL_ARB_shading_language_420pack : enable
layout (std140,set = 0, binding = 0) uniform bufferVals { //一致块
    vec4 uCamaraLocation;//摄像机位置
    float startAngle;//正弦函数起始角度
} myBufferVals;
layout (binding = 1) uniform sampler2D tCaodi;//传入的草地纹理
layout (binding = 2) uniform sampler2D tXued;//传入的雪地纹理
layout (location = 0) in vec2 inTexCoor;//传入的纹理坐标
layout (location = 1) in float landHeight;//传入的当前顶点的高度（物体坐标系）
layout (location = 2) in vec4 pLocation;//当如的当前顶点位置（世界坐标系）
layout (location = 0) out vec4 outColor;//传给渲染管线的最终片元颜色值
const float slabY=60.0f;//雾平面的高度
const float QFheight=5.0f;//雾平面起伏高度
const float WAngleSpan=12*3.1415926f;//雾的总角度跨度
float tjFogCal(vec4 pLocation){//计算体积雾浓度因子的方法
   float xAngle=pLocation.x/960.0f*WAngleSpan;//计算出顶点X坐标折算出的角度
   float zAngle=pLocation.z/960.0f*WAngleSpan;//计算出顶点Z坐标折算出的角度
   float slabYFactor=sin(xAngle+zAngle+myBufferVals.startAngle)*QFheight;//联合起始角计算出角度和的正弦值
   //求从摄像机到待处理片元的射线参数方程Pc+(Pp-Pc)t与雾平面交点的t值
   float t=(slabY+slabYFactor-myBufferVals.uCamaraLocation.y)/(pLocation.y-myBufferVals.uCamaraLocation.y);
   //有效的t的范围应该在0~1的范围内，若不存在范围内表示待处理片元不在雾平面以下
   if(t>0.0&&t<1.0){//若在有效范围内则
      //求出射线与雾平面的交点坐标
	  float xJD=myBufferVals.uCamaraLocation.x+(pLocation.x-myBufferVals.uCamaraLocation.x)*t;
	  float zJD=myBufferVals.uCamaraLocation.z+(pLocation.z-myBufferVals.uCamaraLocation.z)*t;
	  vec3 locationJD=vec3(xJD,slabY,zJD);
	  float L=distance(locationJD,pLocation.xyz);//求出交点到待处理片元位置的距离
	  float L0=20.0;
	  return L0/(L+L0);//计算体积雾的雾浓度因子
   }else{
      return 1.0f;//若待处理片元不在雾平面以下，则此片元不受雾影响
   }
}
void main() {
    float height1=90;//混合纹理起始高度
    float height2=180;//混合纹理结束高度
    vec4  colorCaodi=textureLod(tCaodi, inTexCoor, 0.0);//采样出草地颜色
    vec4 colorSand=textureLod(tXued, inTexCoor, 0.0);//采样出雪地颜色
    if(landHeight<height1){//绘制草地
    outColor=colorCaodi;
    }else if(landHeight<height2){//绘制混合颜色
    float radio=(landHeight-height1)/(height2-height1);
    outColor=mix(colorSand,colorCaodi,1-radio);
    }else{//绘制雪地
    outColor=colorSand;
    }
    float fogFactor=tjFogCal(pLocation);//计算雾浓度因子
    outColor=fogFactor*outColor+ (1.0-fogFactor)*vec4(0.9765,0.7490,0.0549,0.0); //给此片元最终颜色值
}