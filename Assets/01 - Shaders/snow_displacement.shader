// Made with Amplify Shader Editor v1.9.1
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "snow_displacement"
{
	Properties
	{
		_NoiseScale("NoiseScale", Range( 1 , 40)) = 0
		_Offset("Offset", Range( 0.1 , 3)) = 0
		_NormalTiling("NormalTiling", Range( 1 , 100)) = 0
		_NormalStrength("NormalStrength", Range( 0 , 1)) = 0
		_SnowNormal("SnowNormal", 2D) = "bump" {}
		_snow_rt("snow_rt", 2D) = "white" {}
		_softsquare_mask("softsquare_mask", 2D) = "white" {}
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "Opaque"  "Queue" = "Geometry+0" }
		Cull Back
		CGPROGRAM
		#pragma target 3.0
		#pragma surface surf Standard keepalpha addshadow fullforwardshadows vertex:vertexDataFunc 
		struct Input
		{
			float2 uv_texcoord;
		};

		uniform sampler2D _snow_rt;
		uniform float4 _snow_rt_ST;
		uniform float _NoiseScale;
		uniform float _Offset;
		uniform sampler2D _softsquare_mask;
		uniform float4 _softsquare_mask_ST;
		uniform float _NormalStrength;
		uniform sampler2D _SnowNormal;
		uniform float _NormalTiling;


		float3 mod2D289( float3 x ) { return x - floor( x * ( 1.0 / 289.0 ) ) * 289.0; }

		float2 mod2D289( float2 x ) { return x - floor( x * ( 1.0 / 289.0 ) ) * 289.0; }

		float3 permute( float3 x ) { return mod2D289( ( ( x * 34.0 ) + 1.0 ) * x ); }

		float snoise( float2 v )
		{
			const float4 C = float4( 0.211324865405187, 0.366025403784439, -0.577350269189626, 0.024390243902439 );
			float2 i = floor( v + dot( v, C.yy ) );
			float2 x0 = v - i + dot( i, C.xx );
			float2 i1;
			i1 = ( x0.x > x0.y ) ? float2( 1.0, 0.0 ) : float2( 0.0, 1.0 );
			float4 x12 = x0.xyxy + C.xxzz;
			x12.xy -= i1;
			i = mod2D289( i );
			float3 p = permute( permute( i.y + float3( 0.0, i1.y, 1.0 ) ) + i.x + float3( 0.0, i1.x, 1.0 ) );
			float3 m = max( 0.5 - float3( dot( x0, x0 ), dot( x12.xy, x12.xy ), dot( x12.zw, x12.zw ) ), 0.0 );
			m = m * m;
			m = m * m;
			float3 x = 2.0 * frac( p * C.www ) - 1.0;
			float3 h = abs( x ) - 0.5;
			float3 ox = floor( x + 0.5 );
			float3 a0 = x - ox;
			m *= 1.79284291400159 - 0.85373472095314 * ( a0 * a0 + h * h );
			float3 g;
			g.x = a0.x * x0.x + h.x * x0.y;
			g.yz = a0.yz * x12.xz + h.yz * x12.yw;
			return 130.0 * dot( m, g );
		}


		void vertexDataFunc( inout appdata_full v, out Input o )
		{
			UNITY_INITIALIZE_OUTPUT( Input, o );
			float2 uv_snow_rt = v.texcoord * _snow_rt_ST.xy + _snow_rt_ST.zw;
			float3 ase_objectScale = float3( length( unity_ObjectToWorld[ 0 ].xyz ), length( unity_ObjectToWorld[ 1 ].xyz ), length( unity_ObjectToWorld[ 2 ].xyz ) );
			float2 appendResult24 = (float2(ase_objectScale.x , ase_objectScale.z));
			float2 uv_TexCoord36 = v.texcoord.xy * appendResult24;
			float simplePerlin2D6 = snoise( uv_TexCoord36*_NoiseScale );
			simplePerlin2D6 = simplePerlin2D6*0.5 + 0.5;
			float temp_output_12_0 = ( ( ( 1.0 - tex2Dlod( _snow_rt, float4( uv_snow_rt, 0, 0.0) ).g ) + simplePerlin2D6 ) * _Offset );
			float3 appendResult10 = (float3(0.0 , temp_output_12_0 , 0.0));
			float2 uv_softsquare_mask = v.texcoord * _softsquare_mask_ST.xy + _softsquare_mask_ST.zw;
			float4 tex2DNode42 = tex2Dlod( _softsquare_mask, float4( uv_softsquare_mask, 0, 0.0) );
			float3 lerpResult41 = lerp( float3( 0,0,0 ) , appendResult10 , tex2DNode42.r);
			v.vertex.xyz += lerpResult41;
			v.vertex.w = 1;
		}

		void surf( Input i , inout SurfaceOutputStandard o )
		{
			float4 appendResult33 = (float4(_NormalStrength , _NormalStrength , 1.0 , 0.0));
			float3 ase_objectScale = float3( length( unity_ObjectToWorld[ 0 ].xyz ), length( unity_ObjectToWorld[ 1 ].xyz ), length( unity_ObjectToWorld[ 2 ].xyz ) );
			float2 appendResult24 = (float2(ase_objectScale.x , ase_objectScale.z));
			float2 uv_TexCoord22 = i.uv_texcoord * ( _NormalTiling * appendResult24 );
			float2 uv_softsquare_mask = i.uv_texcoord * _softsquare_mask_ST.xy + _softsquare_mask_ST.zw;
			float4 tex2DNode42 = tex2D( _softsquare_mask, uv_softsquare_mask );
			float4 lerpResult44 = lerp( ( appendResult33 * float4( UnpackNormal( tex2D( _SnowNormal, uv_TexCoord22 ) ) , 0.0 ) ) , float4( float3(0,0,1) , 0.0 ) , ( 1.0 - tex2DNode42.r ));
			o.Normal = lerpResult44.xyz;
			float4 color45 = IsGammaSpace() ? float4(0,0,0,1) : float4(0,0,0,1);
			float2 uv_snow_rt = i.uv_texcoord * _snow_rt_ST.xy + _snow_rt_ST.zw;
			float2 uv_TexCoord36 = i.uv_texcoord * appendResult24;
			float simplePerlin2D6 = snoise( uv_TexCoord36*_NoiseScale );
			simplePerlin2D6 = simplePerlin2D6*0.5 + 0.5;
			float temp_output_12_0 = ( ( ( 1.0 - tex2D( _snow_rt, uv_snow_rt ).g ) + simplePerlin2D6 ) * _Offset );
			float clampResult35 = clamp( temp_output_12_0 , 0.0 , 0.65 );
			float4 temp_cast_3 = (clampResult35).xxxx;
			float4 lerpResult43 = lerp( color45 , temp_cast_3 , tex2DNode42.r);
			o.Albedo = lerpResult43.rgb;
			o.Alpha = 1;
		}

		ENDCG
	}
	Fallback "Diffuse"
	CustomEditor "ASEMaterialInspector"
}
/*ASEBEGIN
Version=19100
Node;AmplifyShaderEditor.NoiseGeneratorNode;6;-679.0642,194.8256;Inherit;False;Simplex2D;True;False;2;0;FLOAT2;0,0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;16;-896,0;Inherit;True;Property;_snow_rt;snow_rt;5;0;Create;True;0;0;0;False;0;False;-1;None;374d12706d4b06548a3eaa117d9ccd89;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.OneMinusNode;17;-607.7838,75.50673;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;15;-455.1998,105.1758;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;22;-773.7427,-236.3762;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.DynamicAppendNode;24;-1061.743,-156.3762;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.ObjectScaleNode;19;-1237.743,-156.3762;Inherit;False;False;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;26;-917.7427,-236.3762;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RangedFloatNode;27;-1205.743,-268.3762;Inherit;False;Property;_NormalTiling;NormalTiling;2;0;Create;True;0;0;0;False;0;False;0;25;1;100;0;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;21;-549.7427,-236.3762;Inherit;True;Property;_SnowNormal;SnowNormal;4;0;Create;True;0;0;0;False;0;False;-1;03b4e59b7eb7ec848a0fecac33d64ee1;3ae36bf0d8d58a8469ab369bcc6c791b;True;0;True;bump;Auto;True;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;8;-976,320;Inherit;False;Property;_NoiseScale;NoiseScale;0;0;Create;True;0;0;0;False;0;False;0;8;1;40;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;13;-608,320;Inherit;False;Property;_Offset;Offset;1;0;Create;True;0;0;0;False;0;False;0;0.35;0.1;3;0;1;FLOAT;0
Node;AmplifyShaderEditor.DynamicAppendNode;33;-394.1334,-384;Inherit;False;FLOAT4;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.RangedFloatNode;34;-560,-320;Inherit;False;Constant;_Float0;Float 0;6;0;Create;True;0;0;0;False;0;False;1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;31;-704,-400;Inherit;False;Property;_NormalStrength;NormalStrength;3;0;Create;True;0;0;0;False;0;False;0;0.35;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;28;-240,-320;Inherit;False;2;2;0;FLOAT4;0,0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;36;-917.5285,193.8428;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.DynamicAppendNode;10;-160,192;Inherit;False;FLOAT3;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.ClampOpNode;35;-169.0095,67.49524;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0.65;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;12;-320,192;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;37;293.1374,2.400946;Float;False;True;-1;2;ASEMaterialInspector;0;0;Standard;snow_displacement;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;Back;0;False;;0;False;;False;0;False;;0;False;;False;0;Opaque;0.5;True;True;0;False;Opaque;;Geometry;All;12;all;True;True;True;True;0;False;;False;0;False;;255;False;;255;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;False;2;15;10;25;False;0.5;True;0;0;False;;0;False;;0;0;False;;0;False;;0;False;;0;False;;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;True;Relative;0;;-1;-1;-1;-1;0;False;0;0;False;;-1;0;False;;0;0;0;False;0.1;False;;0;False;;False;16;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
Node;AmplifyShaderEditor.ColorNode;45;-224,-112;Inherit;False;Constant;_Color0;Color 0;7;0;Create;True;0;0;0;False;0;False;0,0,0,1;0,0,0,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.LerpOp;44;112,144;Inherit;False;3;0;FLOAT4;0,0,0,0;False;1;FLOAT4;0,0,0,0;False;2;FLOAT;0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.LerpOp;43;112,0;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.LerpOp;41;112,288;Inherit;False;3;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.Vector3Node;47;-192,448;Inherit;False;Constant;_Plainnormal;Plain normal;7;0;Create;True;0;0;0;False;0;False;0,0,1;0,0,0;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.SamplerNode;42;-321.6833,702.3168;Inherit;True;Property;_softsquare_mask;softsquare_mask;6;0;Create;True;0;0;0;False;0;False;-1;955638cd15e44f947af7251d4991121c;955638cd15e44f947af7251d4991121c;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.OneMinusNode;46;-193.6832,608;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
WireConnection;6;0;36;0
WireConnection;6;1;8;0
WireConnection;17;0;16;2
WireConnection;15;0;17;0
WireConnection;15;1;6;0
WireConnection;22;0;26;0
WireConnection;24;0;19;1
WireConnection;24;1;19;3
WireConnection;26;0;27;0
WireConnection;26;1;24;0
WireConnection;21;1;22;0
WireConnection;33;0;31;0
WireConnection;33;1;31;0
WireConnection;33;2;34;0
WireConnection;28;0;33;0
WireConnection;28;1;21;0
WireConnection;36;0;24;0
WireConnection;10;1;12;0
WireConnection;35;0;12;0
WireConnection;12;0;15;0
WireConnection;12;1;13;0
WireConnection;37;0;43;0
WireConnection;37;1;44;0
WireConnection;37;11;41;0
WireConnection;44;0;28;0
WireConnection;44;1;47;0
WireConnection;44;2;46;0
WireConnection;43;0;45;0
WireConnection;43;1;35;0
WireConnection;43;2;42;1
WireConnection;41;1;10;0
WireConnection;41;2;42;1
WireConnection;46;0;42;1
ASEEND*/
//CHKSM=8D60A168CDA4FCC0CE172CA970738654AC17A785