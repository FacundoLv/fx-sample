// Made with Amplify Shader Editor v1.9.1
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "water 1"
{
	Properties
	{
		_Frequency0("Frequency 0", Range( 0 , 2)) = 1
		_Frequency1("Frequency 1", Range( 0 , 2)) = 1
		_Frequency2("Frequency 2", Range( 0 , 2)) = 1
		_Amplitude0("Amplitude 0", Range( 0 , 25)) = 20
		_Amplitude1("Amplitude 1", Range( 0 , 25)) = 20
		_Amplitude2("Amplitude 2", Range( 0 , 25)) = 20
		_xDir("xDir", Range( -1 , 1)) = 0
		_yDir("yDir", Range( -1 , 1)) = 1
		_Depth("Depth", Float) = 1
		_Strength("Strength", Range( 0.01 , 2)) = 0
		_Color0("Color 0", Color) = (0,0,0,0)
		_Color1("Color 1", Color) = (0,0,0,0)
		_water_nml_001("water_nml_001", 2D) = "bump" {}
		_water_nml_002("water_nml_002", 2D) = "bump" {}
		_Smoothness("Smoothness", Range( 0 , 1)) = 1
		_Opacity("Opacity", Range( 0 , 1)) = 1
		_Intensity("Intensity", Range( 0 , 5)) = 0
		_Height("Height", Range( 0 , 5)) = 1
		_Foam("Foam", Range( -1 , 1)) = 0
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "Transparent"  "Queue" = "Transparent+0" "IgnoreProjector" = "True" }
		Cull Back
		CGPROGRAM
		#include "UnityShaderVariables.cginc"
		#include "UnityCG.cginc"
		#pragma target 3.0
		#pragma surface surf Standard alpha:fade keepalpha noshadow vertex:vertexDataFunc 
		struct Input
		{
			float2 uv_texcoord;
			float4 screenPos;
			float3 worldPos;
		};

		uniform float _xDir;
		uniform float _yDir;
		uniform float _Intensity;
		uniform float _Frequency0;
		uniform float _Amplitude0;
		uniform float _Frequency1;
		uniform float _Amplitude1;
		uniform float _Frequency2;
		uniform float _Amplitude2;
		uniform float _Height;
		uniform sampler2D _water_nml_001;
		uniform sampler2D _water_nml_002;
		UNITY_DECLARE_DEPTH_TEXTURE( _CameraDepthTexture );
		uniform float4 _CameraDepthTexture_TexelSize;
		uniform float _Depth;
		uniform float _Strength;
		uniform float4 _Color0;
		uniform float4 _Color1;
		uniform float _Foam;
		uniform float _Smoothness;
		uniform float _Opacity;


		float2 voronoihash76( float2 p )
		{
			
			p = float2( dot( p, float2( 127.1, 311.7 ) ), dot( p, float2( 269.5, 183.3 ) ) );
			return frac( sin( p ) *43758.5453);
		}


		float voronoi76( float2 v, float time, inout float2 id, inout float2 mr, float smoothness, inout float2 smoothId )
		{
			float2 n = floor( v );
			float2 f = frac( v );
			float F1 = 8.0;
			float F2 = 8.0; float2 mg = 0;
			for ( int j = -1; j <= 1; j++ )
			{
				for ( int i = -1; i <= 1; i++ )
			 	{
			 		float2 g = float2( i, j );
			 		float2 o = voronoihash76( n + g );
					o = ( sin( time + o * 6.2831 ) * 0.5 + 0.5 ); float2 r = f - g - o;
					float d = 0.5 * dot( r, r );
			 		if( d<F1 ) {
			 			F2 = F1;
			 			F1 = d; mg = g; mr = r; id = o;
			 		} else if( d<F2 ) {
			 			F2 = d;
			
			 		}
			 	}
			}
			return F1;
		}


		void vertexDataFunc( inout appdata_full v, out Input o )
		{
			UNITY_INITIALIZE_OUTPUT( Input, o );
			float time76 = 0.0;
			float2 voronoiSmoothId76 = 0;
			float2 appendResult84 = (float2(_xDir , _yDir));
			float2 panner103 = ( 0.1 * _Time.y * appendResult84 + v.texcoord.xy);
			float2 coords76 = panner103 * 10.0;
			float2 id76 = 0;
			float2 uv76 = 0;
			float voroi76 = voronoi76( coords76, time76, id76, uv76, 0, voronoiSmoothId76 );
			float dotResult83 = dot( appendResult84 , v.texcoord.xy );
			float mulTime86 = _Time.y * _Frequency0;
			float mulTime66 = _Time.y * _Frequency1;
			float mulTime68 = _Time.y * _Frequency2;
			float3 appendResult93 = (float3(0.0 , ( ( 1.0 - ( pow( ( 1.0 - voroi76 ) , _Intensity ) + (0.0 + (abs( ( sin( ( ( dotResult83 + mulTime86 ) * _Amplitude0 ) ) + sin( ( ( dotResult83 + mulTime66 ) * _Amplitude1 ) ) + sin( ( ( dotResult83 + mulTime68 ) * _Amplitude2 ) ) ) ) - 0.0) * (1.0 - 0.0) / (3.0 - 0.0)) ) ) * _Height ) , 0.0));
			v.vertex.xyz += appendResult93;
			v.vertex.w = 1;
		}

		void surf( Input i , inout SurfaceOutputStandard o )
		{
			float2 temp_cast_0 = (( _Time.y / 10.0 )).xx;
			float2 uv_TexCoord31 = i.uv_texcoord * float2( 25,25 ) + temp_cast_0;
			float2 temp_cast_1 = (( _Time.y / -5.0 )).xx;
			float2 uv_TexCoord32 = i.uv_texcoord * float2( 12.5,12.5 ) + temp_cast_1;
			float4 ase_screenPos = float4( i.screenPos.xyz , i.screenPos.w + 0.00000000001 );
			float4 ase_screenPosNorm = ase_screenPos / ase_screenPos.w;
			ase_screenPosNorm.z = ( UNITY_NEAR_CLIP_VALUE >= 0 ) ? ase_screenPosNorm.z : ase_screenPosNorm.z * 0.5 + 0.5;
			float clampDepth5 = Linear01Depth(SAMPLE_DEPTH_TEXTURE( _CameraDepthTexture, ase_screenPosNorm.xy ));
			float clampResult16 = clamp( ( ( ( clampDepth5 * _ProjectionParams.z ) - ( ase_screenPos.w + _Depth ) ) * _Strength ) , 0.0 , 1.0 );
			float m_depthMask42 = clampResult16;
			float saferPower58 = abs( m_depthMask42 );
			float3 lerpResult39 = lerp( float3(0.5,0.5,1) , ( UnpackNormal( tex2D( _water_nml_001, uv_TexCoord31 ) ) + UnpackNormal( tex2D( _water_nml_002, uv_TexCoord32 ) ) ) , pow( saferPower58 , 2.2 ));
			float3 m_normal110 = lerpResult39;
			o.Normal = m_normal110;
			float4 lerpResult19 = lerp( _Color0 , _Color1 , saturate( m_depthMask42 ));
			float4 color104 = IsGammaSpace() ? float4(1,1,1,1) : float4(1,1,1,1);
			float3 ase_vertex3Pos = mul( unity_WorldToObject, float4( i.worldPos , 1 ) );
			float4 lerpResult105 = lerp( lerpResult19 , color104 , saturate( ( ( ase_vertex3Pos.y + _Foam ) * 10.0 ) ));
			float4 m_albedo107 = lerpResult105;
			o.Albedo = m_albedo107.rgb;
			o.Smoothness = _Smoothness;
			o.Alpha = _Opacity;
		}

		ENDCG
	}
	CustomEditor "ASEMaterialInspector"
}
/*ASEBEGIN
Version=19100
Node;AmplifyShaderEditor.CommentaryNode;109;-3056,128;Inherit;False;1550.556;765.1661;normal;13;38;58;45;39;36;32;31;35;34;33;23;24;110;;1,1,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;106;-3056,-752;Inherit;False;996.1737;822.5493;albedo;13;107;105;100;104;44;102;19;121;122;123;126;18;17;;1,1,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;43;-3056,-1408;Inherit;False;1170;614;Depth mask;12;5;13;8;9;10;7;11;12;15;14;16;42;;1,1,1,1;0;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;0,0;Float;False;True;-1;2;ASEMaterialInspector;0;0;Standard;water 1;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;False;False;False;False;False;False;Back;0;False;;0;False;;False;0;False;;0;False;;False;0;Transparent;0.5;True;False;0;False;Transparent;;Transparent;All;12;all;True;True;True;True;0;False;;False;0;False;;255;False;;255;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;False;2;15;10;25;False;0.5;False;2;5;False;;10;False;;0;0;False;;0;False;;0;False;;0;False;;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;True;Relative;0;;-1;-1;-1;-1;0;False;0;0;False;;-1;0;False;;0;0;0;False;0.1;False;;0;False;;False;16;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
Node;AmplifyShaderEditor.ScreenDepthNode;5;-3008,-1360;Inherit;False;1;True;1;0;FLOAT4;0,0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ProjectionParams;13;-3008,-1264;Inherit;False;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ScreenPosInputsNode;8;-3008,-1104;Float;False;1;False;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.BreakToComponentsNode;9;-2832,-1104;Inherit;False;FLOAT4;1;0;FLOAT4;0,0,0,0;False;16;FLOAT;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT;5;FLOAT;6;FLOAT;7;FLOAT;8;FLOAT;9;FLOAT;10;FLOAT;11;FLOAT;12;FLOAT;13;FLOAT;14;FLOAT;15
Node;AmplifyShaderEditor.SimpleAddOpNode;10;-2704,-1104;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;7;-2784,-1296;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;11;-2848,-912;Inherit;False;Property;_Depth;Depth;8;0;Create;True;0;0;0;False;0;False;1;0.5;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;12;-2560,-1216;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;15;-2560,-1104;Inherit;False;Property;_Strength;Strength;9;0;Create;True;0;0;0;False;0;False;0;0.1;0.01;2;0;1;FLOAT;0
Node;AmplifyShaderEditor.ClampOpNode;16;-2272,-1216;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;42;-2112,-1216;Inherit;False;m_depthMask;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;60;-3145.569,1522.622;Inherit;False;952;694;wave modifiers;18;94;87;86;82;75;74;73;72;71;70;69;68;67;66;65;63;62;61;;1,1,1,1;0;0
Node;AmplifyShaderEditor.RangedFloatNode;61;-3097.569,1586.622;Inherit;False;Property;_Frequency0;Frequency 0;0;0;Create;True;0;0;0;False;0;False;1;0.03;0;2;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;62;-3097.569,1794.622;Inherit;False;Property;_Frequency1;Frequency 1;1;0;Create;True;0;0;0;False;0;False;1;0.15;0;2;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;63;-3097.569,2002.622;Inherit;False;Property;_Frequency2;Frequency 2;2;0;Create;True;0;0;0;False;0;False;1;0.09;0;2;0;1;FLOAT;0
Node;AmplifyShaderEditor.TexCoordVertexDataNode;64;-3551.151,1589.082;Inherit;False;0;2;0;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleAddOpNode;65;-2633.569,1794.622;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleTimeNode;66;-2809.569,1794.622;Inherit;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;67;-2633.569,2002.622;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleTimeNode;68;-2809.569,2002.622;Inherit;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;69;-2777.569,1698.622;Inherit;False;Property;_Amplitude0;Amplitude 0;3;0;Create;True;0;0;0;False;0;False;20;1.7;0;25;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;70;-2777.569,1906.622;Inherit;False;Property;_Amplitude1;Amplitude 1;4;0;Create;True;0;0;0;False;0;False;20;3.8;0;25;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;71;-2777.569,2114.623;Inherit;False;Property;_Amplitude2;Amplitude 2;5;0;Create;True;0;0;0;False;0;False;20;4.5;0;25;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;72;-2489.57,1586.622;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SinOpNode;73;-2345.569,1794.622;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;74;-2489.57,1794.622;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;75;-2489.57,2002.622;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.VoronoiNode;76;-2201.569,1234.622;Inherit;False;0;0;1;0;1;False;1;False;False;False;4;0;FLOAT2;0,0;False;1;FLOAT;0;False;2;FLOAT;10;False;3;FLOAT;0;False;3;FLOAT;0;FLOAT2;1;FLOAT2;2
Node;AmplifyShaderEditor.PowerNode;79;-1865.569,1234.622;Inherit;False;False;2;0;FLOAT;0;False;1;FLOAT;0.5;False;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;81;-2025.569,1234.622;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SinOpNode;82;-2345.569,2002.622;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.DotProductOpNode;83;-3337.569,1586.622;Inherit;False;2;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.DynamicAppendNode;84;-3490.54,1477.082;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.AbsOpNode;85;-2009.569,1762.622;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleTimeNode;86;-2809.569,1586.622;Inherit;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;87;-2633.569,1586.622;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;88;-3785.569,1426.622;Inherit;False;Property;_xDir;xDir;6;0;Create;True;0;0;0;False;0;False;0;-1;-1;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;89;-3785.569,1506.622;Inherit;False;Property;_yDir;yDir;7;0;Create;True;0;0;0;False;0;False;1;0.23;-1;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.TFHCRemapNode;90;-1881.569,1762.622;Inherit;False;5;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;3;False;3;FLOAT;0;False;4;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;92;-2121.57,1762.622;Inherit;False;3;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SinOpNode;94;-2345.569,1586.622;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;95;-2153.569,1394.622;Inherit;False;Property;_Intensity;Intensity;16;0;Create;True;0;0;0;False;0;False;0;1.12;0;5;0;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;19;-2640,-496;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SaturateNode;102;-2816,-352;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;44;-3008,-352;Inherit;False;42;m_depthMask;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;105;-2464,-432;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;107;-2256,-432;Inherit;False;m_albedo;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SamplerNode;24;-2416,528;Inherit;True;Property;_water_nml_002;water_nml_002;13;0;Create;True;0;0;0;False;0;False;-1;ba35e1da3710a9541be20cd8eb1891b7;ba35e1da3710a9541be20cd8eb1891b7;True;0;True;bump;Auto;True;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;23;-2416,336;Inherit;True;Property;_water_nml_001;water_nml_001;12;0;Create;True;0;0;0;False;0;False;-1;b258e1074fc81634db684b2baa13c125;b258e1074fc81634db684b2baa13c125;True;0;True;bump;Auto;True;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleTimeNode;33;-3008,432;Inherit;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleDivideOpNode;34;-2800,336;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;10;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleDivideOpNode;35;-2800,528;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;-5;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;36;-2064,512;Inherit;False;2;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.LerpOp;39;-1904,480;Inherit;False;3;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.GetLocalVarNode;45;-2304,752;Inherit;False;42;m_depthMask;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.PowerNode;58;-2096,752;Inherit;False;True;2;0;FLOAT;0;False;1;FLOAT;2.2;False;1;FLOAT;0
Node;AmplifyShaderEditor.Vector3Node;38;-2304,176;Inherit;False;Constant;_Plainnormal;Plain normal;6;0;Create;True;0;0;0;False;0;False;0.5,0.5,1;0,0,0;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.RegisterLocalVarNode;110;-1744,480;Inherit;False;m_normal;-1;True;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RangedFloatNode;41;-320,176;Inherit;False;Property;_Smoothness;Smoothness;14;0;Create;True;0;0;0;False;0;False;1;0.885;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;46;-320,288;Inherit;False;Property;_Opacity;Opacity;15;0;Create;True;0;0;0;False;0;False;1;0.885;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;104;-2688,-368;Inherit;False;Constant;_Color2;Color 2;20;0;Create;True;0;0;0;False;0;False;1,1,1,1;0,0,0,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;14;-2400,-1216;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;77;-1488,1472;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;78;-1616,1584;Inherit;False;Property;_Height;Height;17;0;Create;True;0;0;0;False;0;False;1;0.73;0;5;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;91;-1328,1472;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;80;-1616,1472;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.PannerNode;103;-2409.57,1234.622;Inherit;False;3;0;FLOAT2;0,0;False;2;FLOAT2;0,0;False;1;FLOAT;0.1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.PosVertexDataNode;123;-2912,-160;Inherit;False;0;0;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;126;-2608,-160;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;10;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;121;-2736,-160;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;122;-2480,-160;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;100;-3008,0;Inherit;False;Property;_Foam;Foam;18;0;Create;True;0;0;0;False;0;False;0;0.03;-1;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.DynamicAppendNode;93;-1168,1456;Inherit;False;FLOAT3;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.GetLocalVarNode;111;-208,80;Inherit;False;110;m_normal;1;0;OBJECT;;False;1;FLOAT3;0
Node;AmplifyShaderEditor.GetLocalVarNode;108;-208,0;Inherit;False;107;m_albedo;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.ColorNode;18;-3008,-528;Inherit;False;Property;_Color1;Color 1;11;0;Create;True;0;0;0;False;0;False;0,0,0,0;0.2313726,0.5803922,0.9254902,1;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ColorNode;17;-3008,-704;Inherit;False;Property;_Color0;Color 0;10;0;Create;True;0;0;0;False;0;False;0,0,0,0;0.145098,0.9176471,0.9333333,1;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.TextureCoordinatesNode;31;-2672,336;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;25,25;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.TextureCoordinatesNode;32;-2672,528;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;12.5,12.5;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
WireConnection;0;0;108;0
WireConnection;0;1;111;0
WireConnection;0;4;41;0
WireConnection;0;9;46;0
WireConnection;0;11;93;0
WireConnection;9;0;8;0
WireConnection;10;0;9;3
WireConnection;10;1;11;0
WireConnection;7;0;5;0
WireConnection;7;1;13;3
WireConnection;12;0;7;0
WireConnection;12;1;10;0
WireConnection;16;0;14;0
WireConnection;42;0;16;0
WireConnection;65;0;83;0
WireConnection;65;1;66;0
WireConnection;66;0;62;0
WireConnection;67;0;83;0
WireConnection;67;1;68;0
WireConnection;68;0;63;0
WireConnection;72;0;87;0
WireConnection;72;1;69;0
WireConnection;73;0;74;0
WireConnection;74;0;65;0
WireConnection;74;1;70;0
WireConnection;75;0;67;0
WireConnection;75;1;71;0
WireConnection;76;0;103;0
WireConnection;79;0;81;0
WireConnection;79;1;95;0
WireConnection;81;0;76;0
WireConnection;82;0;75;0
WireConnection;83;0;84;0
WireConnection;83;1;64;0
WireConnection;84;0;88;0
WireConnection;84;1;89;0
WireConnection;85;0;92;0
WireConnection;86;0;61;0
WireConnection;87;0;83;0
WireConnection;87;1;86;0
WireConnection;90;0;85;0
WireConnection;92;0;94;0
WireConnection;92;1;73;0
WireConnection;92;2;82;0
WireConnection;94;0;72;0
WireConnection;19;0;17;0
WireConnection;19;1;18;0
WireConnection;19;2;102;0
WireConnection;102;0;44;0
WireConnection;105;0;19;0
WireConnection;105;1;104;0
WireConnection;105;2;122;0
WireConnection;107;0;105;0
WireConnection;24;1;32;0
WireConnection;23;1;31;0
WireConnection;34;0;33;0
WireConnection;35;0;33;0
WireConnection;36;0;23;0
WireConnection;36;1;24;0
WireConnection;39;0;38;0
WireConnection;39;1;36;0
WireConnection;39;2;58;0
WireConnection;58;0;45;0
WireConnection;110;0;39;0
WireConnection;14;0;12;0
WireConnection;14;1;15;0
WireConnection;77;0;80;0
WireConnection;91;0;77;0
WireConnection;91;1;78;0
WireConnection;80;0;79;0
WireConnection;80;1;90;0
WireConnection;103;0;64;0
WireConnection;103;2;84;0
WireConnection;126;0;121;0
WireConnection;121;0;123;2
WireConnection;121;1;100;0
WireConnection;122;0;126;0
WireConnection;93;1;91;0
WireConnection;31;1;34;0
WireConnection;32;1;35;0
ASEEND*/
//CHKSM=D6FD7FB82F78C12D963E4248CC7833EF05B2C3BE