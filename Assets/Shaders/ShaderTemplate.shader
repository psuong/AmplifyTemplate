Shader /*ase_name*/ "Example/UnlitOutline" /*end*/
{
    Properties
    {
        /*ase_props*/
        _MainColor ("Main Color", Color) = (1, 1, 1, 1)
        _OutlineWidth ("Outline Width", Float) = 1
        _OutlineColor ("Outline Color", Color) = (1, 1, 1, 1)
    }

    SubShader
    {
        Tags { "RenderPipeline" = "UniversalPipeline" "RenderType" = "Opaque" }

        /*ase_pass*/
        Pass
        {
            Name "Outline"
            Tags { "RenderType" = "Transparent" }
            
            Blend One Zero
            Cull Front
            /*ase_stencil*/

            HLSLPROGRAM

            #pragma vertex vert
            #pragma fragment frag
            #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"
            /*ase_pragma*/

            struct VertexInput
            {
                float4 vertex : POSITION;
                float3 normal : NORMAL;
                /*ase_vdata:p=p;n=n*/
            };

            struct VertexOutput
            {
                float4 positionCS : SV_POSITION;
                /*ase_interp:sp=sp.xyzw*/
            };

            CBUFFER_START(UnityPerMaterial)
            float4 _OutlineColor;
            float _OutlineWidth;
            CBUFFER_END
            /*ase_globals*/

            VertexOutput vert(VertexInput v /*ase_vert_input*/)
            {
                VertexOutput output = (VertexOutput)0;
                /*ase_vert_code:v=Vertexinput;o=VertexOutput*/
                float widthValue = /*ase_vert_out:Width;Float*/ 1 /*end*/;
                v.vertex.xyz += v.normal * widthValue * _OutlineWidth;

                VertexPositionInputs vertexInput = GetVertexPositionInputs(v.vertex.xyz);
                output.positionCS = vertexInput.positionCS;
                return output;
            }

            half4 frag(VertexOutput IN /*ase_frag_input*/) : SV_Target
            {
                return _OutlineColor;
            }

            ENDHLSL
        }

        /*ase_pass*/
        Pass
        {
            /*ase_main_pass*/
            Name "Unlit"
            Tags { "RenderType" = "Opaque" "RenderPipeline" = "UniversalRenderPipeline" }
            Cull Back
            /*ase_stencil*/

            HLSLPROGRAM

            #pragma vertex vert
            #pragma fragment frag

            #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"
            /*ase_pragma*/

            struct VertexInput
            {
                float4 positionOS : POSITION;
                float3 normal : NORMAL;
                /*ase_vdata:p=p;n=n*/
            };

            struct VertexOutput
            {
                float4 positionCS : SV_POSITION;
                /*ase_interp:sp=sp.xyz*/
            };

            CBUFFER_START(UnityPerMaterial)
                float4 _MainColor;
            CBUFFER_END
            /*ase_globals*/

            VertexOutput vert(VertexInput v/*ase_vert_input*/)
            {
                VertexOutput output = (VertexOutput)0;
                output.positionCS = TransformObjectToHClip(v.positionOS.xyz);
                return output;
            }

            half4 frag(VertexOutput IN/*ase_frag_input*/) : SV_Target
            {
                return _MainColor;
            }

            ENDHLSL
        }
        /*ase_pass_end*/
    }
    /*ase_lod*/
    CustomEditor "UnityEditor.ShaderGraphUnlitGUI"
    FallBack "Hidden/InternalErrorShader"
}