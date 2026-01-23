import PhoneShell from "./components/PhoneShell";
import DigitalTwin from "./pages/DigitalTwin";

export default function App() {
  return (
    <div
      style={{
        minHeight: "100vh",
        backgroundColor: "#020617",
        display: "flex",
        alignItems: "center",
        justifyContent: "center",
      }}
    >
      <PhoneShell>
        <DigitalTwin />
      </PhoneShell>
    </div>
  );
}
