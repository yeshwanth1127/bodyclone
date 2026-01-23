export default function PhoneShell({ children }) {
    return (
        <div
            style={{
                width: "390px",
                height: "780px",
                borderRadius: "36px",
                background: "linear-gradient(180deg, #020617, #0f172a)",
                boxShadow:
                    "0 0 0 10px #020617, 0 40px 90px rgba(0,0,0,0.75)",
                overflow: "hidden",
                position: "relative",
            }}
        >
            {/* Notch */}
            <div
                style={{
                    position: "absolute",
                    top: 12,
                    left: "50%",
                    transform: "translateX(-50%)",
                    width: 120,
                    height: 6,
                    borderRadius: 6,
                    backgroundColor: "#1e293b",
                    zIndex: 20,
                }}
            />

            {children}
        </div>
    );
}
