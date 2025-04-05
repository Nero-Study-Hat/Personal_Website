import * as THREE from 'three';

import bgVertexShaderCode from './shaders/bgVertex.glsl';
import bgFragmentShaderCode from './shaders/bgFragment.glsl';

const scene = new THREE.Scene();

const aspect = window.innerWidth / window.innerHeight;
const frustumSize = 1; // Adjust as needed
const camera = new THREE.OrthographicCamera(
    frustumSize * aspect / - 2,
    frustumSize * aspect / 2,
    frustumSize / 2,
    frustumSize / - 2,
    -1000,
    1000
);
camera.position.z = 1; // Position the camera

const renderer = new THREE.WebGLRenderer({
    canvas: document.querySelector('#bg'),
    alpha: false, /* leave background black */
});
renderer.setSize( window.innerWidth, window.innerHeight );

const geometry = new THREE.PlaneGeometry(2, 2); // Size 2x2 to cover the viewport
const material = new THREE.ShaderMaterial({
    // uniforms: {
    //     // 
    // },
    vertexShader: bgVertexShaderCode,
    fragmentShader: bgFragmentShaderCode
})

const quad = new THREE.Mesh( geometry, material );
scene.add( quad );

camera.position.z = 5;

function animate() {
    requestAnimationFrame( animate );
    renderer.render( scene, camera );
}
animate()