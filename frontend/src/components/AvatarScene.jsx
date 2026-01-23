import { Canvas } from "@react-three/fiber";
import { OrbitControls, useGLTF } from "@react-three/drei";

function AvatarModel() {
    const { scene } = useGLTF("/avatar.glb");

    return (
        <primitive
            object={scene}
            scale={1}
            position={[0, -1.5, 0]} // centers full body
        />
    );
}

export default function AvatarScene() {
    return (
        <Canvas
            camera={{
                position: [0, 1.6, 3.8], // pulled back for full body
                fov: 35,
            }}
            style={{ width: "100%", height: "100%" }}
        >
            {/* Balanced lighting */}
            <ambientLight intensity={0.8} />
            <directionalLight position={[2, 4, 3]} intensity={1.2} />
            <directionalLight position={[-2, 3, 2]} intensity={0.6} />

            <AvatarModel />

            {/* Allow rotation so full body is visible */}
            <OrbitControls
                enableZoom={true}
                enablePan={false}
                minDistance={2.5}
                maxDistance={5}
            />
        </Canvas>
    );
}

useGLTF.preload("/avatar.glb");
