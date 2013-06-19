#ifdef GL_ES
precision mediump float;
precision mediump int;
#endif

#define PROCESSING_TEXTURE_SHADER

uniform sampler2D texture;
uniform sampler2D preblur;
uniform sampler2D postblur;
uniform int blendMode;
uniform mat4 texMatrix;

varying vec4 vertColor;
varying vec4 vertTexCoord;

void main(void) {
  vec4 sum = vec4(0);
  vec2 texcoord = vec2(vertTexCoord[0],vertTexCoord[1]);

  vec4 dst = texture2D(preblur, texcoord); // rendered scene
  vec4 src = texture2D(postblur, texcoord); // glowmap

  if ( blendMode == 0 ) {
    // Additive blending (strong result, high overexposure)
    gl_FragColor = min(src + dst, 1.0);
  } else if ( blendMode == 1 ) {
    // Screen blending (mild result, medium overexposure)
    gl_FragColor = clamp((src + dst) - (src * dst), 0.0, 1.0);
    gl_FragColor.w = 1.0;
    gl_FragColor.w = 1.0;
  } else {
    // Show just the glow map
    gl_FragColor = src;
  }
}