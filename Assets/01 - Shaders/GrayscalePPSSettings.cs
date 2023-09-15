// Amplify Shader Editor - Visual Shader Editing Tool
// Copyright (c) Amplify Creations, Lda <info@amplify.pt>
#if UNITY_POST_PROCESSING_STACK_V2
using System;
using UnityEngine;
using UnityEngine.Rendering.PostProcessing;

[Serializable]
[PostProcess( typeof( GrayscalePPSRenderer ), PostProcessEvent.AfterStack, "Grayscale", true )]
public sealed class GrayscalePPSSettings : PostProcessEffectSettings
{
	[Tooltip( "Lerp" ), Range (0, 1)]
	public FloatParameter _Lerp = new FloatParameter { value = 0f };
}

public sealed class GrayscalePPSRenderer : PostProcessEffectRenderer<GrayscalePPSSettings>
{
	public override void Render( PostProcessRenderContext context )
	{
		var sheet = context.propertySheets.Get( Shader.Find( "Grayscale" ) );
		sheet.properties.SetFloat( "_Lerp", settings._Lerp );
		context.command.BlitFullscreenTriangle( context.source, context.destination, sheet, 0 );
	}
}
#endif
