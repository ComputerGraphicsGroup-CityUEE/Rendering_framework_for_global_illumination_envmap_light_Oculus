Shader "Custom/Depth_back_7"
{
    SubShader
    {

        Pass
        {
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            #include "UnityCG.cginc"

            struct appdata
            {
                float4 vertex : POSITION;
                float2 texcoord:TEXCOORD0;
            };

            struct v2f
            {
                float4 pos : SV_POSITION;
                
                float2 depth : TEXCOORD2;
                float4 bc : TEXCOORD0;
                float2 uv : TEXCOORD1;
                float3 vert : POSITION1;

            };

            float4 _MainTex_ST;
            uniform float _clipValue;
            uniform float3 _l7;
            uniform float4x4 _gWorldToLightCamera7, _gWorldToLightCamera_back7;
            uniform float farPlane;
            float sfunc(float F, float3 v)
            {
                float ll = length(v);
                return ll - 2.0 * F * ll / (ll + v.z) + F;
            }


            v2f vert(appdata v)
            {
                v2f o;

                o.pos = UnityObjectToClipPos(v.vertex);


                float4 hp = mul(_gWorldToLightCamera_back7, mul(unity_ObjectToWorld, v.vertex));


                o.depth = o.pos.zw;
                o.bc.xyz = v.vertex.xyz;

                hp.z = -hp.z;


                float magnitude = length(hp.xyz);
                float3 dp = hp.xyz / magnitude;

                o.pos.x = dp.x / (dp.z + 1.0);
                o.pos.y = -dp.y / (dp.z + 1.0);

                float focal_length = 0.04;
                //o.pos.z = (sfunc(focal_length, hp.xyz) - .001) / (farPlane - .001);


                o.pos.w = 1.0;




                o.bc.xyz = v.vertex.xyz;
                o.bc.w = hp.z / hp.w;

                o.vert = v.vertex;


                //o.bc = v.vertex;

                return o;

                
            }

            float4 frag(v2f i) : SV_Target
            {

                float3 worldPos = mul(unity_ObjectToWorld, float4(i.vert.xyz, 1.0)).xyz;
                
                float3 ldir = worldPos - _l7;
                float depth = length(ldir)  * _ProjectionParams.w;

                float4 Frag0;

                float PI = 3.14159265358979;
                Frag0 = float4(depth, 1.0, 1.0, 1.0);
                
                float4 kv = PI * depth * float4(1.0, 3.0, 5.0, 7.0);
                Frag0 = (Frag0 + 1.0f) / 2.0f;      
                return Frag0;

                

            }
            ENDCG
        }
    }
}
