attribute vec2 st;

uniform sampler2D particles;

vec3 convertCoordinate(vec3 lonLatLev) {
	// WGS84 (lon, lat, lev) -> ECEF (x, y, z)
	// see https://en.wikipedia.org/wiki/Geographic_coordinate_conversion#From_geodetic_to_ECEF_coordinates for detail
	vec3 cartesian = vec3(0.0);
	
	// WGS 84 geometric constants 
	float a = 6378137.0; // Semi-major axis 
	float b = 6356752.3142; // Semi-minor axis 
	float e2 = 6.69437999014e-3; // First eccentricity squared
	
	float cosLat = cos(radians(lonLatLev.y));
	float sinLat = sin(radians(lonLatLev.y));
	float cosLon = cos(radians(lonLatLev.x));
	float sinLon = sin(radians(lonLatLev.x));

	float N_Phi = a / sqrt(1.0 - e2 * sinLat * sinLat);
	float h = 0.0;
	
	cartesian.x = (N_Phi + h) * cosLat * cosLon;
	cartesian.y = (N_Phi + h) * cosLat * sinLon;
	cartesian.z = ((b * b) / (a * a) * N_Phi + h) * sinLat;
	return cartesian;
}

void main() {
	vec2 particleIndex = st;
    vec3 particlePosition = texture2D(particles, particleIndex).rgb;
	particlePosition = convertCoordinate(particlePosition);
	
	vec4 cesiumPosition = vec4(particlePosition, 1.0);
	gl_Position = czm_modelViewProjection * cesiumPosition;
	
	gl_PointSize = 2.0;
}