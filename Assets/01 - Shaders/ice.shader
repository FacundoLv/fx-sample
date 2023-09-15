// Made with Amplify Shader Editor v1.9.1
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "ice"
{
	Properties
	{
		_Normal("Normal", 2D) = "bump" {}
		_NormalStrength("NormalStrength", Range( 0 , 10)) = 0
		_RefractionScale("RefractionScale", Range( 0 , 0.5)) = 0.15
		_RefractionStrength("RefractionStrength", Range( 0 , 0.5)) = 0
		_Smoothness("Smoothness", Range( 0 , 1)) = 0.5
		_IceVolume("IceVolume", 2D) = "white" {}
		_DepthTexResolution("DepthTexResolution", Float) = 1024
		_InnerDepthFactor("InnerDepthFactor", Range( 0 , 5000)) = 100
		_OuterDepthFactor("OuterDepthFactor", Range( 0 , 1000)) = 100
		_DepthAdjustment("DepthAdjustment", Range( 0 , 10)) = 0
		_InnerColor("InnerColor", Color) = (0.4273318,0.607592,0.9150943,1)
		_RefractColor("RefractColor", Color) = (0.2614364,0.3302659,0.4433962,1)
		_rock_roughness("rock_roughness", 2D) = "white" {}
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "Opaque"  "Queue" = "Transparent+0" "IgnoreProjector" = "True" }
		Cull Back
		GrabPass{ }
		CGPROGRAM
		#include "UnityStandardUtils.cginc"
		#pragma target 3.0
		#if defined(UNITY_STEREO_INSTANCING_ENABLED) || defined(UNITY_STEREO_MULTIVIEW_ENABLED)
		#define ASE_DECLARE_SCREENSPACE_TEXTURE(tex) UNITY_DECLARE_SCREENSPACE_TEXTURE(tex);
		#else
		#define ASE_DECLARE_SCREENSPACE_TEXTURE(tex) UNITY_DECLARE_SCREENSPACE_TEXTURE(tex)
		#endif
		#pragma surface surf Standard keepalpha noshadow exclude_path:deferred 
		struct Input
		{
			float2 uv_texcoord;
			float4 screenPos;
			float3 worldNormal;
			INTERNAL_DATA
			float3 worldPos;
		};

		uniform float _NormalStrength;
		uniform sampler2D _Normal;
		uniform float4 _Normal_ST;
		uniform float _RefractionScale;
		ASE_DECLARE_SCREENSPACE_TEXTURE( _GrabTexture )
		uniform float _RefractionStrength;
		uniform float4 _RefractColor;
		uniform float4 _InnerColor;
		uniform sampler2D _IceVolume;
		uniform float _InnerDepthFactor;
		uniform float _DepthTexResolution;
		uniform float _OuterDepthFactor;
		uniform float _DepthAdjustment;
		uniform sampler2D _rock_roughness;
		uniform float4 _rock_roughness_ST;
		uniform float _Smoothness;


		inline float4 ASE_ComputeGrabScreenPos( float4 pos )
		{
			#if UNITY_UV_STARTS_AT_TOP
			float scale = -1.0;
			#else
			float scale = 1.0;
			#endif
			float4 o = pos;
			o.y = pos.w * 0.5f;
			o.y = ( pos.y - o.y ) * _ProjectionParams.x * scale + o.y;
			return o;
		}


		void surf( Input i , inout SurfaceOutputStandard o )
		{
			float3 appendResult20 = (float3(_NormalStrength , _NormalStrength , 1.0));
			float2 uv_Normal = i.uv_texcoord * _Normal_ST.xy + _Normal_ST.zw;
			float3 tex2DNode3 = UnpackScaleNormal( tex2D( _Normal, uv_Normal ), _RefractionScale );
			o.Normal = ( appendResult20 * tex2DNode3 );
			float4 ase_screenPos = float4( i.screenPos.xyz , i.screenPos.w + 0.00000000001 );
			float4 ase_grabScreenPos = ASE_ComputeGrabScreenPos( ase_screenPos );
			float4 ase_grabScreenPosNorm = ase_grabScreenPos / ase_grabScreenPos.w;
			float3 ase_worldNormal = WorldNormalVector( i, float3( 0, 0, 1 ) );
			float3 ase_vertexNormal = mul( unity_WorldToObject, float4( ase_worldNormal, 0 ) );
			ase_vertexNormal = normalize( ase_vertexNormal );
			float3 appendResult19 = (float3(_RefractionStrength , _RefractionStrength , 1.0));
			float4 screenColor5 = UNITY_SAMPLE_SCREENSPACE_TEXTURE(_GrabTexture,( ase_grabScreenPosNorm + float4( ( tex2DNode3 + ( ase_vertexNormal * appendResult19 ) ) , 0.0 ) ).xy);
			float3 ase_worldPos = i.worldPos;
			float3 ase_worldViewDir = Unity_SafeNormalize( UnityWorldSpaceViewDir( ase_worldPos ) );
			float3 ase_worldTangent = WorldNormalVector( i, float3( 1, 0, 0 ) );
			float3 ase_worldBitangent = WorldNormalVector( i, float3( 0, 1, 0 ) );
			float3x3 ase_worldToTangent = float3x3( ase_worldTangent, ase_worldBitangent, ase_worldNormal );
			float3 ase_tanViewDir = mul( ase_worldToTangent, ase_worldViewDir );
			float3 temp_output_36_0 = reflect( -ase_tanViewDir , tex2DNode3 );
			float2 temp_output_40_0 = (temp_output_36_0).xy;
			float temp_output_41_0 = (temp_output_36_0).z;
			float temp_output_51_0 = ( 1.0 / _DepthTexResolution );
			float4 lerpResult67 = lerp( ( screenColor5 * _RefractColor ) , _InnerColor , (0.0 + (( tex2D( _IceVolume, ( i.uv_texcoord + ( ( temp_output_40_0 * ( _InnerDepthFactor / abs( temp_output_41_0 ) ) ) * temp_output_51_0 ) ) ).r + tex2D( _IceVolume, ( ( i.uv_texcoord * float2( 4,4 ) ) + ( ( temp_output_40_0 * ( _OuterDepthFactor / abs( temp_output_41_0 ) ) ) * temp_output_51_0 ) ) ).r ) - 0.0) * (1.0 - 0.0) / (_DepthAdjustment - 0.0)));
			o.Albedo = lerpResult67.rgb;
			float2 uv_rock_roughness = i.uv_texcoord * _rock_roughness_ST.xy + _rock_roughness_ST.zw;
			float temp_output_91_0 = (1.0 + (_Smoothness - 0.0) * (2.0 - 1.0) / (1.0 - 0.0));
			float clampResult92 = clamp( pow( ( tex2D( _rock_roughness, uv_rock_roughness ).r * temp_output_91_0 ) , temp_output_91_0 ) , 0.0 , 1.0 );
			o.Smoothness = clampResult92;
			o.Alpha = 1;
		}

		ENDCG
	}
	CustomEditor "ASEMaterialInspector"
}
/*ASEBEGIN
Version=19100
Node;AmplifyShaderEditor.CommentaryNode;73;-2976,112;Inherit;False;2206.518;820.6927;Comment;25;51;46;36;35;34;40;41;38;42;44;45;50;33;52;53;54;56;57;60;59;43;55;61;62;63;Depth;1,1,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;72;-2977.015,-704.6226;Inherit;False;1377.217;753.8712;Comment;12;8;5;6;3;16;15;14;7;18;19;65;66;Refaction;1,1,1,1;0;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;0,0;Float;False;True;-1;2;ASEMaterialInspector;0;0;Standard;ice;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;False;False;False;False;False;False;Back;0;False;;0;False;;False;0;False;;0;False;;False;0;Translucent;0.5;True;False;0;False;Opaque;;Transparent;ForwardOnly;12;all;True;True;True;True;0;False;;False;0;False;;255;False;;255;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;False;2;15;10;25;False;0.5;False;0;5;False;;10;False;;0;0;False;;0;False;;0;False;;0;False;;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;True;Relative;0;;-1;-1;-1;-1;0;False;0;0;False;;-1;0;False;;0;0;0;False;0.1;False;;0;False;;False;16;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
Node;AmplifyShaderEditor.SimpleAddOpNode;8;-2111.012,-526.6219;Inherit;False;2;2;0;FLOAT4;0,0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.ScreenColorNode;5;-1983.01,-574.6221;Inherit;False;Global;_GrabScreen0;Grab Screen 0;1;0;Create;True;0;0;0;False;0;False;Object;-1;False;False;False;False;2;0;FLOAT2;0,0;False;1;FLOAT;0;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.GrabScreenPosition;6;-2383.014,-654.6227;Inherit;False;0;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;3;-2655.016,-478.6216;Inherit;True;Property;_Normal;Normal;0;0;Create;True;0;0;0;False;0;False;-1;None;bdab11bd8cbce914a9f5f8effd502b9c;True;0;True;bump;Auto;True;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleAddOpNode;16;-2319.013,-382.6213;Inherit;False;2;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;15;-2495.015,-270.6216;Inherit;False;2;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0.5,0.5,1;False;1;FLOAT3;0
Node;AmplifyShaderEditor.NormalVertexDataNode;14;-2671.016,-270.6216;Inherit;False;0;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.DynamicAppendNode;19;-2615.173,-109.7518;Inherit;False;FLOAT3;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;3;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.ColorNode;65;-2031.011,-350.6214;Inherit;False;Property;_RefractColor;RefractColor;11;0;Create;True;0;0;0;False;0;False;0.2614364,0.3302659,0.4433962,1;0.4316927,0.5741445,0.8396226,1;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;66;-1761.798,-462.6214;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;21;-1056,-256;Inherit;False;Property;_NormalStrength;NormalStrength;1;0;Create;True;0;0;0;False;0;False;0;10;0;10;0;1;FLOAT;0
Node;AmplifyShaderEditor.DynamicAppendNode;20;-784,-256;Inherit;False;FLOAT3;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;3;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;22;-624,-256;Inherit;False;2;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleDivideOpNode;51;-2384,480;Inherit;False;2;0;FLOAT;1;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ReflectOpNode;36;-2608,288;Inherit;False;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,1;False;1;FLOAT3;0
Node;AmplifyShaderEditor.NegateNode;35;-2752,288;Inherit;False;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.ViewDirInputsCoordNode;34;-2928,288;Inherit;False;Tangent;True;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.SwizzleNode;40;-2400,288;Inherit;False;FLOAT2;0;1;2;3;1;0;FLOAT3;0,0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SwizzleNode;41;-2384,384;Inherit;False;FLOAT;2;1;2;3;1;0;FLOAT3;0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;38;-1392,256;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.AbsOpNode;42;-2032,432;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleDivideOpNode;44;-1872,384;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;45;-1744,288;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;50;-1584,352;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SamplerNode;33;-1248,256;Inherit;True;Property;_IceVolume;IceVolume;5;0;Create;True;0;0;0;False;0;False;-1;a9e8d7a1018997d46afef79b266cfc15;a9e8d7a1018997d46afef79b266cfc15;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleAddOpNode;52;-1408,656;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.AbsOpNode;53;-2048,832;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleDivideOpNode;54;-1888,784;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;56;-1760,688;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;57;-1600,752;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SamplerNode;59;-1264,656;Inherit;True;Property;_IceVolume1;IceVolume;5;0;Create;True;0;0;0;False;0;False;-1;a9e8d7a1018997d46afef79b266cfc15;a9e8d7a1018997d46afef79b266cfc15;True;0;False;white;Auto;False;Instance;33;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;43;-2176,352;Inherit;False;Property;_InnerDepthFactor;InnerDepthFactor;7;0;Create;True;0;0;0;False;0;False;100;75;0;5000;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;55;-2192,752;Inherit;False;Property;_OuterDepthFactor;OuterDepthFactor;8;0;Create;True;0;0;0;False;0;False;100;10;0;1000;0;1;FLOAT;0
Node;AmplifyShaderEditor.TexCoordVertexDataNode;61;-1808,544;Inherit;False;0;2;0;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;62;-1600,544;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT2;4,4;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleAddOpNode;63;-928,480;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;69;-704,-96;Inherit;False;Property;_InnerColor;InnerColor;10;0;Create;True;0;0;0;False;0;False;0.4273318,0.607592,0.9150943,1;0.7357156,0.8074945,0.9339623,1;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.LerpOp;67;-304,32;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.TexCoordVertexDataNode;60;-1648,160;Inherit;False;0;2;0;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.WireNode;71;-539.8357,-427.4551;Inherit;False;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.TFHCRemapNode;84;-528,240;Inherit;False;5;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;3;FLOAT;0;False;4;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;85;-759.6975,505.4922;Inherit;False;Property;_DepthAdjustment;DepthAdjustment;9;0;Create;True;0;0;0;False;0;False;0;1.5;0;10;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;18;-2911.015,-110.6217;Inherit;False;Property;_RefractionStrength;RefractionStrength;3;0;Create;True;0;0;0;False;0;False;0;0.1;0;0.5;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;7;-2925.491,-478.6216;Inherit;False;Property;_RefractionScale;RefractionScale;2;0;Create;True;0;0;0;False;0;False;0.15;0.039;0;0.5;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;46;-2576,480;Inherit;False;Property;_DepthTexResolution;DepthTexResolution;6;0;Create;True;0;0;0;False;0;False;1024;1024;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;86;-597.2023,702.4937;Inherit;True;Property;_rock_roughness;rock_roughness;12;0;Create;True;0;0;0;False;0;False;-1;ae5fda87a55b83a4a822ebf30093b85e;ae5fda87a55b83a4a822ebf30093b85e;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;90;-304,704;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;17;-688,896;Inherit;False;Property;_Smoothness;Smoothness;4;0;Create;True;0;0;0;False;0;False;0.5;0.438;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.TFHCRemapNode;91;-416,896;Inherit;False;5;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;3;FLOAT;1;False;4;FLOAT;2;False;1;FLOAT;0
Node;AmplifyShaderEditor.ClampOpNode;92;-1.166455,709.6962;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.PowerNode;89;-160,704;Inherit;False;False;2;0;FLOAT;0;False;1;FLOAT;1;False;1;FLOAT;0
WireConnection;0;0;67;0
WireConnection;0;1;22;0
WireConnection;0;4;92;0
WireConnection;8;0;6;0
WireConnection;8;1;16;0
WireConnection;5;0;8;0
WireConnection;3;5;7;0
WireConnection;16;0;3;0
WireConnection;16;1;15;0
WireConnection;15;0;14;0
WireConnection;15;1;19;0
WireConnection;19;0;18;0
WireConnection;19;1;18;0
WireConnection;66;0;5;0
WireConnection;66;1;65;0
WireConnection;20;0;21;0
WireConnection;20;1;21;0
WireConnection;22;0;20;0
WireConnection;22;1;3;0
WireConnection;51;1;46;0
WireConnection;36;0;35;0
WireConnection;36;1;3;0
WireConnection;35;0;34;0
WireConnection;40;0;36;0
WireConnection;41;0;36;0
WireConnection;38;0;60;0
WireConnection;38;1;50;0
WireConnection;42;0;41;0
WireConnection;44;0;43;0
WireConnection;44;1;42;0
WireConnection;45;0;40;0
WireConnection;45;1;44;0
WireConnection;50;0;45;0
WireConnection;50;1;51;0
WireConnection;33;1;38;0
WireConnection;52;0;62;0
WireConnection;52;1;57;0
WireConnection;53;0;41;0
WireConnection;54;0;55;0
WireConnection;54;1;53;0
WireConnection;56;0;40;0
WireConnection;56;1;54;0
WireConnection;57;0;56;0
WireConnection;57;1;51;0
WireConnection;59;1;52;0
WireConnection;62;0;61;0
WireConnection;63;0;33;1
WireConnection;63;1;59;1
WireConnection;67;0;71;0
WireConnection;67;1;69;0
WireConnection;67;2;84;0
WireConnection;71;0;66;0
WireConnection;84;0;63;0
WireConnection;84;2;85;0
WireConnection;90;0;86;1
WireConnection;90;1;91;0
WireConnection;91;0;17;0
WireConnection;92;0;89;0
WireConnection;89;0;90;0
WireConnection;89;1;91;0
ASEEND*/
//CHKSM=18B80FE59CA90E1D0C280C7FC7528B9B3747FC5F