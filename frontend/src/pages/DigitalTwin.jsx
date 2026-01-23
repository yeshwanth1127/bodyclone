import AvatarScene from "../components/AvatarScene";
import { useState } from "react";

const icons = [
    { label: "Vitals", emoji: "🫀", mood: "calm" },
    { label: "Reports", emoji: "📄", mood: "focus" },
    { label: "Medication", emoji: "💊", mood: "care" },
    { label: "Consult", emoji: "🩺", mood: "listen" },
];

export default function DigitalTwin() {
    const [avatarMood, setAvatarMood] = useState("calm");

    return (
        <div
            style={{
                height: "100%",
                position: "relative",
                background: "radial-gradient(circle at top, #0f172a, #020617)",
                color: "#e5e7eb",
            }}
        >
            {/* Header */}
            <div
                style={{
                    padding: "18px",
                    textAlign: "center",
                    fontSize: "17px",
                }}
            >
                Digital Health Twin
            </div>

            {/* Avatar */}
            <div style={{ height: "calc(100% - 60px)" }}>
                <AvatarScene mood={avatarMood} />
            </div>

            {/* SIDE ICON DOCK */}
            <div
                style={{
                    position: "absolute",
                    right: 12,
                    top: "50%",
                    transform: "translateY(-50%)",
                    display: "flex",
                    flexDirection: "column",
                    gap: 14,
                    zIndex: 20,
                }}
            >
                {icons.map((item, index) => (
                    <div
                        key={item.label}
                        onClick={() => setAvatarMood(item.mood)}
                        className="side-icon"
                        title={item.label}
                        style={{
                            width: 56,
                            height: 56,
                            borderRadius: 14, // ← soft square edges
                            background:
                                "linear-gradient(145deg, #0f172a, #020617)",
                            display: "flex",
                            alignItems: "center",
                            justifyContent: "center",
                            fontSize: "22px",
                            cursor: "pointer",
                            animation: `float ${3 + index * 0.4}s ease-in-out infinite`,
                            boxShadow:
                                "inset 0 0 0 1px #312e81, 0 6px 18px rgba(0,0,0,0.4)",
                            transition: "all 0.25s ease",
                        }}
                    >
                        {item.emoji}
                    </div>
                ))}
            </div>

            {/* Animations */}
            <style>
                {`
          @keyframes float {
            0%, 100% { transform: translateY(0); }
            50% { transform: translateY(-6px); }
          }

          .side-icon:hover {
            transform: translateY(-6px) scale(1.06);
            box-shadow:
              0 0 18px rgba(124,58,237,0.28),
              inset 0 0 0 1px #7c3aed;
          }
        `}
            </style>
        </div>
    );
}
