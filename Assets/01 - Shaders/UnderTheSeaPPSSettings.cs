// Amplify Shader Editor - Visual Shader Editing Tool
// Copyright (c) Amplify Creations, Lda <info@amplify.pt>
#if UNITY_POST_PROCESSING_STACK_V2
using System;
using UnityEngine;
using UnityEngine.Rendering.PostProcessing;

[Serializable]
[PostProcess( typeof( UnderTheSeaPPSRenderer ), PostProcessEvent.AfterStack, "UnderTheSea", true )]
public sealed class UnderTheSeaPPSSettings : PostProcessEffectSettings
{
	[Tooltip( "UTS Tint" )]
	public ColorParameter _UTSTint = new ColorParameter { value = new Color(0f,1f,0.6006253f,0f) };
	[Tooltip( "Flowmap Intensity" )]
	public FloatParameter _FlowmapIntensity = new FloatParameter { value = 0f };
	[Tooltip( "Noise Tiling" )]
	public FloatParameter _NoiseTiling = new FloatParameter { value = 6.49f };
	[Tooltip( "Speed" )]
	public FloatParameter _Speed = new FloatParameter { value = 0.24f };
}

public sealed class UnderTheSeaPPSRenderer : PostProcessEffectRenderer<UnderTheSeaPPSSettings>
{
	public override void Render( PostProcessRenderContext context )
	{
		var sheet = context.propertySheets.Get( Shader.Find( "UnderTheSea" ) );
		sheet.properties.SetColor( "_UTSTint", settings._UTSTint );
		sheet.properties.SetFloat( "_FlowmapIntensity", settings._FlowmapIntensity );
		sheet.properties.SetFloat( "_NoiseTiling", settings._NoiseTiling );
		sheet.properties.SetFloat( "_Speed", settings._Speed );
		context.command.BlitFullscreenTriangle( context.source, context.destination, sheet, 0 );
	}
}
#endif
