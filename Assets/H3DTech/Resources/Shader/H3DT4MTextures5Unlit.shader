
Shader "H3D/InGame/SceneStaticObjects/T4M/T4M 5 Textures Unlit LM" {
Properties {
    _Splat0 ("Layer1 (RGB)", 2D) = "white" {}
	_Splat1 ("Layer2 (RGB)", 2D) = "white" {}
	_Splat2 ("Layer3 (RGB)", 2D) = "white" {}
	_Splat3 ("Layer4 (RGB)", 2D) = "white" {}
	_Splat4 ("Layer5 (RGB)", 2D) = "white" {}
	_Control ("Control (RGBA)", 2D) = "white" {}
	_Control2 ("Control2 (RGBA)", 2D) = "white" {}
	_MainTex ("Never Used", 2D) = "white" {}
}
SubShader {
	LOD 200
    Pass {

		Tags { "LightMode"="ForwardBase"} 
		
	    CGPROGRAM  
  
        #pragma multi_compile_fwdbase         
        #pragma vertex vert  
        #pragma fragment frag  
        #pragma target 2.0
        #include "H3DFramework.cginc"
		sampler2D _Splat0 ;
		sampler2D _Splat1 ;
		sampler2D _Splat2 ;
		sampler2D _Splat3;
		sampler2D _Splat4;
		sampler2D _Control;
		sampler2D _Control2;

		struct v2f {
			float4  pos : SV_POSITION;
			#ifdef LIGHTMAP_ON
			float2  uv[7] : TEXCOORD0;
			LIGHTING_COORDS(8,9)  
			#endif
			#ifdef LIGHTMAP_OFF
			float2  uv[6] : TEXCOORD0;
			LIGHTING_COORDS(7,8)  
			#endif
		};

		float4 _Splat0_ST;
		float4 _Splat1_ST;
		float4 _Splat2_ST;
		float4 _Splat3_ST;
		float4 _Splat4_ST;
		float4 _Control_ST;
		#ifdef LIGHTMAP_ON
		H3D_LightMap_Declare 
        #endif

		v2f vert (appdata_full  v)
		{
			v2f o;
			o.pos = mul (UNITY_MATRIX_MVP, v.vertex);
			o.uv[0] = TRANSFORM_TEX (v.texcoord, _Splat0);
			o.uv[1] = TRANSFORM_TEX (v.texcoord, _Splat1);
			o.uv[2] = TRANSFORM_TEX (v.texcoord, _Splat2);
			o.uv[3] = TRANSFORM_TEX (v.texcoord, _Splat3);
			o.uv[4] = TRANSFORM_TEX (v.texcoord, _Splat4);
			o.uv[5] = TRANSFORM_TEX (v.texcoord, _Control);
			 #ifdef LIGHTMAP_ON
            	o.uv[6] = v.texcoord1.xy * unity_LightmapST.xy + unity_LightmapST.zw;
            #endif
            TRANSFER_VERTEX_TO_FRAGMENT(o);  
			return o;
		}

		fixed4 frag (v2f i) : COLOR
		{
			fixed4 Mask = tex2D( _Control, i.uv[5].xy );
			fixed2 Mask2 = tex2D( _Control2, i.uv[5].xy ).rg;
			fixed3 lay1 = tex2D( _Splat0, i.uv[0].xy );
			fixed3 lay2 = tex2D( _Splat1, i.uv[1].xy );
			fixed3 lay3 = tex2D( _Splat2, i.uv[2].xy );
			
			
			fixed3 lay4 = tex2D( _Splat3, i.uv[3].xy );
			fixed3 lay5 = tex2D( _Splat4, i.uv[4].xy );
			
			fixed attenuation = LIGHT_ATTENUATION(i);
			
			fixed3 c2;
			c2.xyz = (lay4.xyz * Mask2.r + lay5.xyz * Mask2.g);
				
    		fixed4 c;
			c.xyz = (lay1.xyz * Mask.r + lay2.xyz * Mask.g + lay3.xyz * Mask.b + c2.xyz * Mask.a)*attenuation;
			
			#ifdef LIGHTMAP_ON
           		 c.rgb *= DecodeLightmap(H3D_SAMPLE_TEX2D(unity_Lightmap, i.uv[6]));
            #endif
			c.w = 0;
			return c;
		}
		ENDCG
    }

  }   
 FallBack "H3D/InGame/SceneStaticObjects/SimpleDiffuse (Supports Lightmap)"
} 