import { View, Text, TouchableOpacity, StyleSheet } from "react-native";
import { router } from "expo-router";
import { SafeAreaView } from "react-native-safe-area-context";

export default function HomeScreen() {
  return (
    <SafeAreaView style={styles.safeArea}>
      <View style={styles.container}>
        <View style={styles.card}>
          {/* Header */}
          <Text style={styles.title}>Skin Analyzer</Text>
          <Text style={styles.subtitle}>
            AI-powered skin condition detection
          </Text>

          {/* Divider */}
          <View style={styles.divider} />

          {/* Info Box */}
          <View style={[styles.infoBox, { backgroundColor: "#AED4E6" }]}>
            <Text style={styles.infoText}>
              📋 This app uses a TFLite model to analyze your skin. Please
              ensure good lighting for accurate results.
            </Text>
          </View>

          <View style={styles.spacer} />

          {/* CTA Button */}
          <TouchableOpacity
            style={[styles.button, { backgroundColor: "#7EC8E3" }]}
            onPress={() => router.push("/camera")}
            activeOpacity={0.8}
          >
            <Text style={styles.buttonText}>Get Started →</Text>
          </TouchableOpacity>
        </View>
      </View>
    </SafeAreaView>
  );
}

const styles = StyleSheet.create({
  safeArea: {
    flex: 1,
    backgroundColor: "#E8F4F8",
  },
  container: {
    flex: 1,
    justifyContent: "center",
    alignItems: "center",
    padding: 20,
  },
  card: {
    width: "100%",
    maxWidth: 500,
    backgroundColor: "#fff",
    borderWidth: 2,
    borderColor: "#2D3748",
    padding: 24,
    shadowColor: "#2D3748",
    shadowOffset: { width: 4, height: 4 },
    shadowOpacity: 1,
    shadowRadius: 0,
    elevation: 8,
  },
  title: {
    fontSize: 28,
    fontWeight: "900",
    color: "#2D3748",
    letterSpacing: -0.5,
  },
  subtitle: {
    fontSize: 14,
    color: "#4A5568",
    marginTop: 4,
  },
  divider: {
    height: 2,
    backgroundColor: "#2D3748",
    marginVertical: 20,
  },
  infoBox: {
    padding: 14,
    borderWidth: 2,
    borderColor: "#2D3748",
    shadowColor: "#2D3748",
    shadowOffset: { width: 3, height: 3 },
    shadowOpacity: 1,
    shadowRadius: 0,
    elevation: 4,
  },
  infoText: {
    fontSize: 13,
    color: "#2D3748",
    lineHeight: 20,
  },
  spacer: { height: 24 },
  button: {
    paddingVertical: 14,
    alignItems: "center",
    borderWidth: 2,
    borderColor: "#2D3748",
    shadowColor: "#2D3748",
    shadowOffset: { width: 4, height: 4 },
    shadowOpacity: 1,
    shadowRadius: 0,
    elevation: 6,
  },
  buttonText: {
    fontWeight: "800",
    fontSize: 15,
    color: "#2D3748",
    letterSpacing: 0.5,
  },
});
