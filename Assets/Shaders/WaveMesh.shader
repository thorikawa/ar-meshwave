Shader "Custom/WaveMesh"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}
        _Intensity ("Color Intensity", float) = 1.0
        _CycleLength ("Cycle length", float) = 1.0
        _Speed ("Speed", float) = 1
        _Width ("Line Width", Range(0.0, 1.0)) = 0.2
        _MaxAlpha ("Max Alpha", Range(0.0, 1.0)) = 0.8
        _NumOfSplits ("Number of texture splits", float) = 7.0
    }
    SubShader
    {
        Tags { "RenderType"="Transparent" "Queue" = "Transparent" }
        Blend SrcAlpha OneMinusSrcAlpha

        LOD 100

        Pass
        {
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag

            #include "UnityCG.cginc"

            struct appdata
            {
                float4 vertex : POSITION;
                float2 uv : TEXCOORD0;
            };

            struct v2f
            {
                float2 uv : TEXCOORD0;
                float3 worldPos : TEXCOORD1;
                float4 vertex : SV_POSITION;
            };

            sampler2D _MainTex;
            float4 _MainTex_ST;
            float _Intensity;
            float _CycleLength;
            float _Speed;
            float _Width;
            float _MaxAlpha;
            float _NumOfSplits;

            v2f vert (appdata v)
            {
                v2f o;
                o.worldPos = mul (unity_ObjectToWorld, v.vertex);
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.uv = TRANSFORM_TEX(v.uv, _MainTex);
                return o;
            }

            float4 frag (v2f i) : SV_Target
            {
                float phase = (-i.worldPos.z + _Speed * _Time.y) / _CycleLength;
                float colorValue = frac(phase);
                float alphaValue = frac(phase * _NumOfSplits);
                float4 col = _Intensity * tex2D(_MainTex, float2(0.5, colorValue));
                float alpha = (1.0 - step(_Width, alphaValue)) * _MaxAlpha;
                col.a = alpha;
                return col;
            }
            ENDCG
        }
    }
}
