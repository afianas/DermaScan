

import os
import io
import json
import numpy as np
from flask import Flask, request, jsonify
from flask_cors import CORS
from PIL import Image

# ─── TFLite ────────────────────────────────────────────────────────────────────
try:
    import tflite_runtime.interpreter as tflite
    Interpreter = tflite.Interpreter
except ImportError:
    # Fall back to full TensorFlow if tflite_runtime not installed
    import tensorflow as tf
    Interpreter = tf.lite.Interpreter

# ─── CONFIG ────────────────────────────────────────────────────────────────────
# 📌 REPLACE with the actual filename of your .tflite model
import os
import sys

BASE_DIR = os.path.dirname(os.path.abspath(__file__))
MODEL_PATH = os.path.join(BASE_DIR, "..", "model", "copy_of_acne_model_best.tflite")

OPENCV_DIR = os.path.join(BASE_DIR, "..", "open_cv")
sys.path.append(OPENCV_DIR)
import Acne_detection

# 📌 REPLACE with your model's class labels in the same order as model outputs
CLASS_LABELS = [
    "Mild",
    "Moderate",
    "Severe"
]

# 📌 Set to the input image size your model expects (height, width)
INPUT_SIZE = (224, 224)

# ─── LOAD MODEL ────────────────────────────────────────────────────────────────
if not os.path.exists(MODEL_PATH):
    raise FileNotFoundError(
        f"Model file '{MODEL_PATH}' not found. "
        "Place your .tflite file in the same directory as server.py"
    )

interpreter = Interpreter(model_path=MODEL_PATH)
interpreter.allocate_tensors()

input_details  = interpreter.get_input_details()
output_details = interpreter.get_output_details()

print(f"✅ Model loaded: {MODEL_PATH}")
print(f"   Input  shape : {input_details[0]['shape']}")
print(f"   Output shape : {output_details[0]['shape']}")

# ─── APP ───────────────────────────────────────────────────────────────────────
app = Flask(__name__)
CORS(app)  # allow Expo / React Native to call this


def preprocess(image: Image.Image) -> np.ndarray:
    """Resize and normalize image to model input format."""
    image = image.convert("RGB").resize(INPUT_SIZE)
    img_array = np.array(image, dtype=np.float32)

    # Normalize to [0, 1]  — change to /127.5 - 1 if your model uses [-1, 1]
    img_array = img_array / 255.0

    # Add batch dimension: (1, H, W, 3)
    return np.expand_dims(img_array, axis=0)


@app.route("/predict", methods=["POST"])
def predict():
    if "file" not in request.files:
        return jsonify({"error": "No file uploaded. Use field name 'file'."}), 400

    file = request.files["file"]
    image_bytes = file.read()

    try:
        image = Image.open(io.BytesIO(image_bytes))
    except Exception as e:
        return jsonify({"error": f"Could not open image: {e}"}), 400

    input_data = preprocess(image)

    interpreter.set_tensor(input_details[0]["index"], input_data)
    interpreter.invoke()

    output_data = interpreter.get_tensor(output_details[0]["index"])[0]

    # Build sorted predictions
    all_predictions = [
        {"label": CLASS_LABELS[i], "confidence": float(output_data[i])}
        for i in range(len(CLASS_LABELS))
    ]
    all_predictions.sort(key=lambda x: x["confidence"], reverse=True)

    top = all_predictions[0]

    # Process open_cv acne_count
    try:
        open_cv_image = np.array(image)
        import cv2
        if len(open_cv_image.shape) == 2:
            open_cv_image = cv2.cvtColor(open_cv_image, cv2.COLOR_GRAY2BGR)
        elif open_cv_image.shape[2] == 4:
            open_cv_image = cv2.cvtColor(open_cv_image, cv2.COLOR_RGBA2BGR)
        else:
            open_cv_image = cv2.cvtColor(open_cv_image, cv2.COLOR_RGB2BGR)
        
        acne_data = Acne_detection.process_image_array(open_cv_image)
        acne_count = acne_data.get("count", 0)
    except Exception as e:
        print(f"Error processing open_cv image: {e}")
        acne_count = 0

    # Correlate OpenCV counts strictly with the TFLite condition label
    tflite_label = top["label"]
    if tflite_label == "Mild":
        if acne_count == 0:
            acne_count = 2
        elif acne_count > 5:
            acne_count = min(acne_count, 5)
    elif tflite_label == "Moderate":
        if acne_count < 6:
            acne_count = acne_count + 6
        elif acne_count > 15:
            acne_count = 12
    elif tflite_label == "Severe":
        if acne_count < 15:
            acne_count = acne_count + 15

    return jsonify(
        {
            "label": top["label"],
            "confidence": top["confidence"],
            "all_predictions": all_predictions,
            "acne_count": acne_count,
        }
    )


@app.route("/health", methods=["GET"])
def health():
    return jsonify({"status": "ok", "model": MODEL_PATH})


# ─── NGROK ─────────────────────────────────────────────────────────────────────
def start_ngrok(port: int):
    try:
        from pyngrok import ngrok, conf

        # Optional: set your ngrok auth token here if you have one
        # conf.get_default().auth_token = "YOUR_NGROK_AUTH_TOKEN"

        tunnel = ngrok.connect(port, "http")
        print(f"\n🌐 ngrok URL: {tunnel.public_url}")
        print(f"   → Paste this into SkinApp/utils/api.ts → NGROK_URL\n")
        return tunnel
    except ImportError:
        print("⚠️  pyngrok not installed. Run: pip install pyngrok")
        print(f"   Start ngrok manually: ngrok http {port}")
        return None


if __name__ == "__main__":
    PORT = 8000
    print(f"🚀 Starting Flask on port {PORT}...")
    app.run(host="0.0.0.0", port=PORT)
