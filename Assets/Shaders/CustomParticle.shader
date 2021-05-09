// Unity built-in shader source. Copyright (c) 2016 Unity Technologies. MIT license (see license.txt)
 
Shader "Particles/Additive Summation" {
Properties {
    _MainTex ("Particle Texture", 2D) = "white" {}
    _Base ("Base", Range(0.0,1.0)) = 1.0
    _Saturation ("Saturation", Range(0.0,100.0)) = 1.0
    _Glow ("Intensity", Range(0.0,10.0)) = 0.0
}
 
Category {
    Tags { "Queue"="Transparent" "IgnoreProjector"="True" "RenderType"="Transparent" "PreviewType"="Plane" }
    Blend SrcAlpha One
    Cull Off Lighting Off ZWrite Off
 
    SubShader {
        Pass {
     
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            #pragma target 2.0
            #pragma multi_compile_particles
 
            #include "UnityCG.cginc"
 
            sampler2D _MainTex;
            fixed _Base;
            fixed _Glow;
            fixed _Saturation;
         
            struct appdata_t {
                float4 vertex : POSITION;
                fixed4 color : COLOR;
                float2 texcoord : TEXCOORD0;
            };
 
            struct v2f {
                float4 vertex : SV_POSITION;
                fixed4 color : COLOR;
                float2 texcoord : TEXCOORD0;
            };
         
            float4 _MainTex_ST;
 
            v2f vert (appdata_t v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                //o.color = v.color;
                //o.color.rgb = pow(v.color.rgb,_pow) + _Glow;
                o.color.rgb = v.color.rgb + _Glow;
                o.color.a = v.color.a;
                o.texcoord = TRANSFORM_TEX(v.texcoord,_MainTex);
                return o;
            }
 
            fixed4 frag (v2f i) : SV_Target
            {
                fixed4 tex = tex2D(_MainTex, i.texcoord);
                fixed4 col = tex;
                col.a *= i.color.a * tex.r * tex.g * tex.b * tex.a;
                col.rgb = (col.rgb * i.color.rgb + col.rgb * _Saturation) * _Base + i.color.rgb * _Saturation;
                return col;
            }
            ENDCG
        }
    }
}
}