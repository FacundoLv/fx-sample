// Amplify Shader Editor - Visual Shader Editing Tool
// Copyright (c) Amplify Creations, Lda <info@amplify.pt>
#if UNITY_POST_PROCESSING_STACK_V2
using System;
using UnityEngine;
using UnityEngine.Rendering.PostProcessing;

[Serializable]
[PostProcess( typeof( ObraDinnPPSRenderer ), PostProcessEvent.AfterStack, "ObraDinn", true )]
public sealed class ObraDinnPPSSettings : PostProcessEffectSettings
{
	[Tooltip( "Intensity" )]
	public FloatParameter _Intensity = new FloatParameter { value = 0f };
}

public sealed class ObraDinnPPSRenderer : PostProcessEffectRenderer<ObraDinnPPSSettings>
{
	public override void Render( PostProcessRenderContext context )
	{
		var sheet = context.propertySheets.Get( Shader.Find( "ObraDinn" ) );
		sheet.properties.SetFloat( "_Intensity", settings._Intensity );
		context.command.BlitFullscreenTriangle( context.source, context.destination, sheet, 0 );
	}
}
#endif
