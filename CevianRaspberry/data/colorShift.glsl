//most stuff ripped from http://www.airtightinteractive.com/

#ifdef GL_ES
precision mediump float;
precision mediump int; 
#endif

#define PROCESSING_TEXTURE_SHADER

uniform sampler2D texture;
//uniform vec2 texOffset;
uniform float ammount;
uniform float angle;
uniform vec2 glitchOfs;

uniform float distortion;// = 0.3
uniform float zoom;// = 1

varying vec4 vertTexCoord;
//varying vec4 vertColor;

vec2 radialDistortion(vec2 coord) {
  vec2 cc = coord - 0.5;
  float dist = dot(cc, cc) * distortion;
  return (coord + cc * (1.0 + dist) * dist);
}

vec2 normalizeKaleidoCoord(vec2 coord) {
  if (coord.x > 0.5) coord.x = 1.0 - coord.x;
  if (coord.y < 0.5) coord.y = 1.0 - coord.y;  
  return coord;
}

void main() {
  //old crt effect, https://github.com/matheus23/RuinsOfRevenge/blob/master/src/data/shaders/radial-distortion.fragment
  vec2 uv = radialDistortion(vec2(vertTexCoord.s,vertTexCoord.t));
  uv = 0.5 + (uv-0.5)*zoom;

	//kaleidoskop
  vec2 vUv = glitchOfs+uv;
  vUv.x = mod(vUv.x, 1.0);
  vUv.y = mod(vUv.y, 1.0);
  vUv = normalizeKaleidoCoord(vUv); 

  //rgbshift
  vec2 offset = ammount * vec2( cos(angle), sin(angle));
  
  vec2 uvR = normalizeKaleidoCoord(vUv - offset);
  vec2 uvB = normalizeKaleidoCoord(vUv + offset);
  
  vec4 cr = texture2D(texture, uvR);
  vec4 cga = texture2D(texture, vUv);
  vec4 cb = texture2D(texture, uvB );
  
  vec4 col = vec4(cr.r, cga.g, cb.b, cga.a);
  
 	//scanlines effect 
  float sCount = 1150.0;
	vec2 sc = vec2( sin( uv.y * sCount ), cos( uv.y * sCount ) );
  
	vec3 cResult = col.rgb;
  cResult += col.rgb * vec3( sc.x, sc.y, sc.x ) * 0.050;
	cResult = col.rgb + 0.75 * ( cResult - col.rgb );

	gl_FragColor =  vec4( cResult, col.a );	
}


