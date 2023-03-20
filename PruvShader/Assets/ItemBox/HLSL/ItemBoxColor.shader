Shader "Unlit/ItemBoxColor"
{
    //variables que se ven desde el inspector de unity
    Properties
    {
        _MainTex("MainText", 2D) = "white" {}
        _RampText("RampText", 2D) = "white" {}
        _SpeedColor("SpeedColor", Float) = 1
    }
    SubShader
    {
        Tags { "RenderType"="Transparent" } //transparencia
        LOD 100
        Blend SrcAlpha OneMinusSrcAlpha // complement
        Cull Front //render las caras de adentro

        Pass
        {
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            // make fog work
            #pragma multi_compile_fog

            #include "UnityCG.cginc"

            struct appdata
            {
                float4 vertex : POSITION;
                float2 uv : TEXCOORD0;
            };

            struct v2f
            {
                float2 uv : TEXCOORD0;
                UNITY_FOG_COORDS(1)
                float4 vertex : SV_POSITION;
            };

            sampler2D _MainTex;
            sampler2D _RampText;
            float4 _RampText_ST;
            float _SpeedColor;
            float Time_Time;
            float2 _Vector2;
            float4 _MainTex_ST;
            float4 result;
            float2 result2;
            float _Split_A;
            float uv;

            void Multiply(float4 A, float4 B, out float4 Out)
            {
                Out = A * B;
            }

            void Add(float4 A, float4 B, out float4 Out)
            {
                Out = A + B;
            }

            void TilingAndOffset(float2 UV, float2 Tiling, float2 Offset, out float2 Out)
            {
                Out = UV * Tiling + Offset;
            }

            void Branch(float Predicate, float4 True, float4 False, out float4 Out)
            {
                Out = Predicate ? True : False;
            }

            v2f vert (appdata v) //vertex shader
            {
                v2f o;
                uv = float2(0.5,0.5);
                Multiply(_SpeedColor, Time_Time, result);
                Add((_MainTex,uv), result, result);
                _Vector2 = (result,0);
                //TilingAndOffset(0,(1,1),_Vector2, result2)
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.uv = TRANSFORM_TEX(v.uv, _MainTex);
                UNITY_TRANSFER_FOG(o,o.vertex);
                return o;
            }

            fixed4 frag (v2f i) : SV_Target //fragment Shader
            {
                // sample the texture
                fixed4 col = tex2D(_MainTex, i.uv);
                // apply fog
                UNITY_APPLY_FOG(i.fogCoord, col);
                return col;
            }
            ENDCG
        }
    }
}
