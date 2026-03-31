import {
  View,
  Text,
  Image,
  ScrollView,
  TouchableOpacity,
  StyleSheet,
} from "react-native";
import { useLocalSearchParams, router } from "expo-router";
import { SafeAreaView } from "react-native-safe-area-context";

export default function ResultScreen() {
  const params = useLocalSearchParams<{
    imageUri: string;
    label: string;
    confidence: string;
    acneCount: string;
  }>();

  const { imageUri, label, confidence, acneCount } = params;
  const confidencePercent = (parseFloat(confidence ?? "0") * 100).toFixed(1);
  const count = parseInt(acneCount ?? "0", 10);

  return (
    <SafeAreaView style={styles.safeArea}>
      <ScrollView contentContainerStyle={styles.container}>
        <View style={styles.card}>
          {/* Header */}
          <View style={styles.headerRow}>
            <Text style={styles.headerTitle}>Analysis Result</Text>
            <TouchableOpacity
              onPress={() => router.push("/camera")}
              style={styles.closeBtn}
            >
              <Text style={styles.closeText}>✕</Text>
            </TouchableOpacity>
          </View>

          <View style={styles.spacer} />

          {/* Image Preview */}
          {imageUri ? (
            <View style={styles.imageBox}>
              <Image
                source={{ uri: imageUri }}
                style={styles.image}
                resizeMode="cover"
              />
            </View>
          ) : null}

          <View style={styles.spacer} />

          {/* TFLite Model Result (PRIORITIZED) */}
          <View style={[styles.infoBox, { backgroundColor: "#AED4E6" }]}>
            <Text style={styles.tagText}>TFLITE VISION MODEL</Text>
            <Text style={styles.resultLabel}>Detected Condition</Text>
            <Text style={styles.resultValue}>{label ?? "Unknown"}</Text>
            
            <View style={styles.barContainer}>
              <View style={styles.barBackground}>
                <View
                  style={[
                    styles.barFill,
                    { width: `${Math.min(parseFloat(confidencePercent), 100)}%` },
                  ]}
                />
              </View>
              <Text style={styles.barLabel}>{confidencePercent}% Confident</Text>
            </View>
          </View>

          <View style={styles.spacer} />

          {/* OpenCV Result (SECONDARY) */}
          <View style={[styles.infoBox, { backgroundColor: "#7EC8E3" }]}>
            <Text style={styles.tagText}>OPENCV ANALYSIS</Text>
            <Text style={styles.resultLabel}>Acne Count</Text>
            <View style={styles.acneCountRow}>
              <Text style={styles.acneValue}>{count}</Text>
              <Text style={styles.acneSubValue}> spots detected</Text>
            </View>
          </View>

          <View style={styles.spacer} />

          {/* Disclaimer */}
          <View style={[styles.infoBox, { backgroundColor: "#E8F4F8", padding: 14 }]}>
            <Text style={styles.infoText}>
              ⚠️ This result is for informational purposes only. Please consult
              a dermatologist for a proper diagnosis.
            </Text>
          </View>

          <View style={styles.spacer} />

          {/* Try Again */}
          <TouchableOpacity
            style={[styles.button, { backgroundColor: "#7EC8E3" }]}
            onPress={() => router.push("/camera")}
            activeOpacity={0.8}
          >
            <Text style={styles.buttonText}>Scan Another Image</Text>
          </TouchableOpacity>
        </View>
      </ScrollView>
    </SafeAreaView>
  );
}

const styles = StyleSheet.create({
  safeArea: { flex: 1, backgroundColor: "#E8F4F8" },
  container: {
    flexGrow: 1,
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
  headerRow: {
    flexDirection: "row",
    justifyContent: "space-between",
    alignItems: "center",
  },
  headerTitle: { fontSize: 24, fontWeight: "900", color: "#2D3748", letterSpacing: -0.5 },
  closeBtn: {
    padding: 6,
    borderWidth: 2,
    borderColor: "#2D3748",
    backgroundColor: "#fff",
    shadowColor: "#2D3748",
    shadowOffset: { width: 3, height: 3 },
    shadowOpacity: 1,
    shadowRadius: 0,
    elevation: 4,
  },
  closeText: { fontSize: 13, fontWeight: "700", color: "#2D3748" },
  spacer: { height: 20 },
  imageBox: {
    height: 180,
    borderWidth: 2,
    borderColor: "#2D3748",
    overflow: "hidden",
    shadowColor: "#2D3748",
    shadowOffset: { width: 3, height: 3 },
    shadowOpacity: 1,
    shadowRadius: 0,
    elevation: 4,
  },
  image: { width: "100%", height: "100%" },
  infoBox: {
    padding: 16,
    borderWidth: 2,
    borderColor: "#2D3748",
    shadowColor: "#2D3748",
    shadowOffset: { width: 3, height: 3 },
    shadowOpacity: 1,
    shadowRadius: 0,
    elevation: 4,
  },
  tagText: {
    fontSize: 10,
    fontWeight: "900",
    color: "#2D3748",
    marginBottom: 8,
    letterSpacing: 0.5,
  },
  resultLabel: { fontSize: 13, fontWeight: "700", color: "#4A5568" },
  resultValue: {
    fontSize: 28,
    fontWeight: "900",
    color: "#2D3748",
    marginTop: 2,
    letterSpacing: -0.5,
  },
  acneCountRow: {
    flexDirection: "row",
    alignItems: "baseline",
    marginTop: 2,
  },
  acneValue: {
    fontSize: 28,
    fontWeight: "900",
    color: "#2D3748",
    letterSpacing: -0.5,
  },
  acneSubValue: {
    fontSize: 15,
    fontWeight: "700",
    color: "#4A5568",
    marginLeft: 4,
  },
  barContainer: { marginTop: 12 },
  barBackground: {
    height: 10,
    backgroundColor: "#fff",
    borderWidth: 2,
    borderColor: "#2D3748",
    overflow: "hidden",
  },
  barFill: {
    height: "100%",
    backgroundColor: "#2D3748",
  },
  barLabel: {
    fontSize: 12,
    color: "#2D3748",
    marginTop: 6,
    fontWeight: "800",
  },
  infoText: {
    fontSize: 13,
    color: "#2D3748",
    lineHeight: 20,
    fontWeight: "600",
  },
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
    fontWeight: "900",
    fontSize: 15,
    color: "#2D3748",
    letterSpacing: 0.5,
  },
});
