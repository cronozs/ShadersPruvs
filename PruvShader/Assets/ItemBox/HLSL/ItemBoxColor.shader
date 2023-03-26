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

            #include "UnityCG.cginc"

            struct appdata
            {
                float4 vertex : POSITION;
                float2 uv : TEXCOORD0;
            };

            struct v2f
            {
                float2 uv : TEXCOORD0;
                float4 vertex : SV_POSITION;
               
            };

            sampler2D _MainTex;
            sampler2D _RampText;
            float4 _RampText_ST;
            float _SpeedColor;
            float4 _MainTex_ST;
          

            v2f vert (appdata v) //vertex shader
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.uv = TRANSFORM_TEX(v.uv, _MainTex);
                return o;
            }

            fixed4 frag (v2f i) : SV_Target //fragment Shader
            {
                float multlpy = _Time.y * _SpeedColor;
                float4 sampleMain = tex2D(_MainTex, i.uv);
                float addision = multlpy + sampleMain; 
                float2 v2 = float2(addision,0);
                float2 uvTAO = i.uv * float2(1,1) + v2;
                float4 SampleRamp = tex2D(_RampText, uvTAO);
                fixed4 col = SampleRamp;
                return col;
            }
            ENDCG
        }
    }
}
