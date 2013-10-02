Shader "Custom/WhiteOkami" {
	Properties {
		_EdgeColor ("Edge Color", Color) = (1, 1, 1, 1)
		_Amount ("Extrude Amount", Float) = 0.0
		_Exponential ("Exponential", Float) = 1.0
		_Gain ("Gain", Float) = 1.0
		_Period ("Period", Float) = 1.0
	}
	SubShader {
		Tags { "RenderType"="Transparent" "Queue"="Transparent" "IgnoreProjector"="True" }
		Cull Front
		ZWrite Off
		ZTest LEqual
		Lighting Off
		Blend SrcAlpha One
		LOD 200
		
		CGINCLUDE
		#include "UnityCG.cginc"
		
		fixed4 _EdgeColor;
		float _Amount;
		float _Exponential;
		float _Gain;
		float _Period;
		
		struct v2f {
			float4 pos : SV_POSITION;
			float4 color : COLOR;
		};
		
		v2f vert(appdata_base v) {
			v2f o;
			float t = _Time.y;
			float4 posLocal = v.vertex + float4(v.normal * _Amount, 0.0);
			float3 viewDir = normalize(ObjSpaceViewDir(v.vertex));
			float view2normal = dot(viewDir, -v.normal);

			float rad = 6.2831853 * frac(t / _Period);
			float f = 0.7 + 0.3 * sin(rad) * cos(3 * rad);
			float power = pow(saturate(view2normal), _Exponential) * _Gain * f;
			
			o.pos = mul(UNITY_MATRIX_MVP, posLocal);
			o.color = _EdgeColor * power;
			return o;
		} 

		fixed4 frag (v2f i) : COLOR {
			fixed4 c = i.color;
			return c;
		}
		ENDCG

		Pass {
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			#pragma fragmentoption ARB_precision_hint_fastest
			ENDCG 
		}			
	} 
	FallBack "Diffuse"
}
