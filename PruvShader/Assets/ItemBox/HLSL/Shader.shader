Shader "Unlit/NewUnlitShader"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}
        _Color ("Mian Color", Color) = (1,0,0,1)
    }
    SubShader
    {
        Tags { "RenderType"="Opaque" }

        Pass
        {
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag

            #include "UnityCG.cginc"
            //estructuras
            struct appdata
            {
                float4 vertex : POSITION;
                float2 uv : TEXCOORD0;
            };

            struct v2f
            {
                float2 uv : TEXCOORD0;
                float4 vertex : SV_POSITION;
                float4 color : _color;
            };

            sampler2D _MainTex; //conexion con el texture
            float4 _MainTex_ST;
            float4 _color;

            v2f vert (appdata v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex); //matriz de unbity para ver el shader matris de pocicio, objeto, camara y luz;
                //  o.uv = TRANSFORM_TEX(v.uv, _MainTex);
                o.color = _color;
                return o;
            }

            fixed4 frag(v2f i) : SV_Target
            {
                // sample the texture
                //fixed4 col; //= tex2D(_MainTex, i.uv); //se manda a un vector 4
                //return col;
                return i.color;
            }
            ENDCG
        }
    }
}
