import {
  View,
  Text,
  TouchableOpacity,
  Image,
  StyleSheet,
  Alert,
  ActivityIndicator,
} from "react-native";
import { useState } from "react";
import * as ImagePicker from "expo-image-picker";
import { router } from "expo-router";
import { SafeAreaView } from "react-native-safe-area-context";
import { predictImage } from "../utils/api";

export default function CameraScreen() {
  const [selectedImage, setSelectedImage] = useState<string | null>(null);
  const [loading, setLoading] = useState(false);

  const openCamera = async () => {
    const { status } = await ImagePicker.requestCameraPermissionsAsync();
    if (status !== "granted") {
      Alert.alert("Permission Denied", "Camera access is required.");
      return;
    }

    const result = await ImagePicker.launchCameraAsync({
      mediaTypes: ImagePicker.MediaTypeOptions.Images,
      allowsEditing: true,
      quality: 0.8,
    });

    if (!result.canceled && result.assets[0]) {
      const uri = result.assets[0].uri;
      setSelectedImage(uri);
      await runAnalysis(uri);
    }
  };

  const openGallery = async () => {
    const { status } =
      await ImagePicker.requestMediaLibraryPermissionsAsync();
    if (status !== "granted") {
      Alert.alert("Permission Denied", "Gallery access is required.");
      return;
    }

    const result = await ImagePicker.launchImageLibraryAsync({
      mediaTypes: ImagePicker.MediaTypeOptions.Images,
      allowsEditing: true,
      quality: 0.8,
    });

    if (!result.canceled && result.assets[0]) {
      const uri = result.assets[0].uri;
      setSelectedImage(uri);
      await runAnalysis(uri);
    }
  };

  const runAnalysis = async (uri: string) => {
    setLoading(true);
    try {
      const result = await predictImage(uri);
      router.push({
        pathname: "/result",
        params: {
          imageUri: uri,
          label: result.label,
          confidence: result.confidence.toString(),
          allPredictions: JSON.stringify(result.all_predictions ?? []),
          acneCount: result.acne_count?.toString() || "0",
        },
      });
    } catch (error: any) {
      Alert.alert(
        "Analysis Failed",
        error.message || "Could not connect to server. Is ngrok running?"
      );
    } finally {
      setLoading(false);
    }
  };

  return (
    <SafeAreaView style={styles.safeArea}>
      <View style={styles.container}>
        <View style={styles.card}>
          {/* Header */}
          <View style={styles.headerRow}>
            <Text style={styles.headerTitle}>Capture Your Face</Text>
            <TouchableOpacity
              onPress={() => router.back()}
              style={styles.closeBtn}
            >
              <Text style={styles.closeText}>✕</Text>
            </TouchableOpacity>
          </View>

          <View style={styles.spacer} />

          {/* Preview Box */}
          <View style={[styles.previewBox, { backgroundColor: "#AED4E6" }]}>
            {loading ? (
              <View style={styles.loadingContainer}>
                <ActivityIndicator size="large" color="#2D3748" />
                <Text style={styles.loadingText}>Analyzing...</Text>
              </View>
            ) : selectedImage ? (
              <Image
                source={{ uri: selectedImage }}
                style={styles.previewImage}
                resizeMode="cover"
              />
            ) : (
              <Text style={styles.noImageText}>No Image Selected</Text>
            )}
          </View>

          <View style={styles.spacer} />

          {/* Action Buttons */}
          <View style={styles.buttonRow}>
            <TouchableOpacity
              style={[
                styles.actionButton,
                { backgroundColor: "#7EC8E3", flex: 1 },
              ]}
              onPress={openCamera}
              disabled={loading}
              activeOpacity={0.8}
            >
              <Text style={styles.actionButtonText}>📷  Start Camera</Text>
            </TouchableOpacity>

            <View style={{ width: 10 }} />

            <TouchableOpacity
              style={[styles.actionButton, { flex: 1 }]}
              onPress={openGallery}
              disabled={loading}
              activeOpacity={0.8}
            >
              <Text style={styles.actionButtonText}>🖼  Upload Image</Text>
            </TouchableOpacity>
          </View>

          <View style={{ height: 15 }} />

          {/* Tip box */}
          <View style={[styles.tipBox, { backgroundColor: "#D6DEE8" }]}>
            <Text style={styles.tipText}>
              Ensure your face is well-lit and clearly visible
            </Text>
          </View>
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
    padding: 20,
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
  headerTitle: {
    fontSize: 16,
    fontWeight: "800",
    color: "#2D3748",
  },
  closeBtn: {
    padding: 6,
    borderWidth: 2,
    borderColor: "#2D3748",
    shadowColor: "#2D3748",
    shadowOffset: { width: 3, height: 3 },
    shadowOpacity: 1,
    shadowRadius: 0,
    elevation: 4,
    backgroundColor: "#fff",
  },
  closeText: {
    fontSize: 13,
    fontWeight: "700",
    color: "#2D3748",
  },
  spacer: { height: 20 },
  previewBox: {
    height: 220,
    width: "100%",
    borderWidth: 2,
    borderColor: "#2D3748",
    shadowColor: "#2D3748",
    shadowOffset: { width: 3, height: 3 },
    shadowOpacity: 1,
    shadowRadius: 0,
    elevation: 4,
    justifyContent: "center",
    alignItems: "center",
    overflow: "hidden",
  },
  previewImage: {
    width: "100%",
    height: "100%",
  },
  noImageText: {
    color: "#2D3748",
    fontWeight: "600",
    fontSize: 14,
  },
  loadingContainer: {
    alignItems: "center",
    gap: 10,
  },
  loadingText: {
    color: "#2D3748",
    fontWeight: "700",
    marginTop: 8,
  },
  buttonRow: {
    flexDirection: "row",
  },
  actionButton: {
    paddingVertical: 12,
    alignItems: "center",
    borderWidth: 2,
    borderColor: "#2D3748",
    shadowColor: "#2D3748",
    shadowOffset: { width: 3, height: 3 },
    shadowOpacity: 1,
    shadowRadius: 0,
    elevation: 4,
    backgroundColor: "#fff",
  },
  actionButtonText: {
    fontSize: 13,
    fontWeight: "700",
    color: "#2D3748",
  },
  tipBox: {
    padding: 10,
    borderWidth: 2,
    borderColor: "#2D3748",
    shadowColor: "#2D3748",
    shadowOffset: { width: 3, height: 3 },
    shadowOpacity: 1,
    shadowRadius: 0,
    elevation: 4,
  },
  tipText: {
    textAlign: "center",
    fontSize: 12,
    color: "#2D3748",
    fontWeight: "500",
  },
});
