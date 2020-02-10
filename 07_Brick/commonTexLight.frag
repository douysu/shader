#version 400
#extension GL_ARB_separate_shader_objects : enable//开启separate_shader_objects
#extension GL_ARB_shading_language_420pack : enable//开启shading_language_420pack
layout (location = 0) in vec3 vposition;//顶点着色器传入的顶点位置
layout (location = 1) in vec2 mcLongLat;//顶点着色器传入的顶点位置(偏航角，仰角)
layout (location = 0) out vec4 outColor;//输出到渲染管线的片元颜色值
void main(){//主方法
   vec3 bColor=vec3(0.678,0.231,0.129);//砖块的颜色
   vec3 mColor=vec3(0.763,0.657,0.614);//水泥的颜色
   vec3 color;//片元的最终颜色
   //计算当前位于奇数还是偶数行
   int row=int(mod((mcLongLat.y+90.0)/12.0,2.0));
   //计算当前片元是否在此行区域1中的辅助变量
   float ny=mod(mcLongLat.y+90.0,12.0);
   //每行的砖块偏移值，奇数行偏移半个砖块
   float oeoffset=0.0;
   //当前片元是否在此行区域3中的辅助变量
   float nx;
   if(ny>10.0){//位于此行的区域1中
       color=mColor;//采用水泥色着色
   }else{//不位于此行的区域1中
   if(row==1){//若为奇数行则偏移半个砖块
        oeoffset=11.0;
   }
   //计算当前片元是否在此行区域3中的辅助变量
   nx=mod(mcLongLat.x+oeoffset,22.0);
   if(nx>20.0){//不位于此行的区域3中
       color=mColor;
   }else{//位于此行的区域3中
    color=bColor;//采用砖块色着色
    }
   } //将片元的最终颜色传递进渲染管线
     outColor=vec4(color,0);
}
