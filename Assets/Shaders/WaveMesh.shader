Shader "Custom/WaveMesh"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}
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
                float alphaPhase = -8.0 * i.worldPos.z + 8.0 * _Time.y;
                float colorValue = frac(alphaPhase * (1.0 / (12.0 * 3.141592)));
                float alphaWaveValue = 0.5 * (sin(alphaPhase) + 1.0);
                fixed4 col = 2.5 * tex2D(_MainTex, float2(0.5, colorValue));
                float alpha = step(0.9, alphaWaveValue);
                col.a = alpha;
                return col;
            }
            ENDCG
        }
    }
}
