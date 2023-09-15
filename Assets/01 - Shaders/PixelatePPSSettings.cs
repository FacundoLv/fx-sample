// Amplify Shader Editor - Visual Shader Editing Tool
// Copyright (c) Amplify Creations, Lda <info@amplify.pt>
#if UNITY_POST_PROCESSING_STACK_V2
using System;
using UnityEngine;
using UnityEngine.Rendering.PostProcessing;

[Serializable]
[PostProcess( typeof( PixelatePPSRenderer ), PostProcessEvent.AfterStack, "Pixelate", true )]
public sealed class PixelatePPSSettings : PostProcessEffectSettings
{
	[Tooltip( "Y" )]
	public FloatParameter _Y = new FloatParameter { value = 500f };
	[Tooltip( "X" )]
	public FloatParameter _X = new FloatParameter { value = 500f };
}

public sealed class PixelatePPSRenderer : PostProcessEffectRenderer<PixelatePPSSettings>
{
	public override void Render( PostProcessRenderContext context )
	{
		var sheet = context.propertySheets.Get( Shader.Find( "Pixelate" ) );
		sheet.properties.SetFloat( "_Y", settings._Y );
		sheet.properties.SetFloat( "_X", settings._X );
		context.command.BlitFullscreenTriangle( context.source, context.destination, sheet, 0 );
	}
}
#endif
