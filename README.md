# 🧠 DermaScan – AI-Based Acne Severity Detection App

DermaScan is a mobile-ready deep learning application that classifies acne severity into **Mild, Moderate, and Severe** using a lightweight CNN model (MobileNetV2). The system is optimized for **on-device inference using TensorFlow Lite**, ensuring privacy and real-time performance.

---

## 🚀 Features

- 📷 Capture or upload skin images
- 🤖 AI-based acne severity classification
- 📊 Outputs severity + confidence score
- 📱 Runs offline using TFLite (no internet required)
- 🔒 Privacy-first (no data leaves device)
- 🌍 Optimized for Indian skin tones

---

## 🧠 Model Details

- Architecture: **MobileNetV2 (Transfer Learning)**
- Input Size: **224 × 224 RGB images**
- Classes:
  - Mild
  - Moderate
  - Severe
- Optimization: **TFLite Quantization**
- Dataset: **DermaCon-IN (Indian dataset)**

---

## 🔁 System Pipeline

**Steps:**
1. Image Capture / Upload  
2. Preprocessing (Resize + Normalize)  
3. Model Inference (MobileNetV2)  
4. Severity Prediction + Confidence  

---

## 🏗️ System Architecture

<img width="797" height="591" alt="image" src="https://github.com/user-attachments/assets/6a4b87a8-e4d0-41b2-95be-e363636f274b" />


The system processes user input locally and returns acne severity without requiring cloud interaction.

---

## 📊 Data Flow Diagrams

### Level 0 DFD
<img width="538" height="494" alt="image" src="https://github.com/user-attachments/assets/0aae6fce-2631-4b8a-ada3-32ab504332a3" />


### Level 1 DFD
<img width="790" height="625" alt="image" src="https://github.com/user-attachments/assets/17b1bbc8-fe39-42c7-ab34-05f66da1d7ca" />


---

## 🔄 Workflow (State Diagram)

<img width="503" height="738" alt="image" src="https://github.com/user-attachments/assets/efe3ca6c-e7a5-4c54-b31c-c36a5f58e7ed" />



---

## 🔧 Modules

- **User Interaction Module** → Capture/upload images  
- **Image Processing Module** → Resize, normalize  
- **Classification Module** → MobileNetV2 prediction  
- **On-Device Inference Module** → TFLite execution  

---

## 🧪 Testing

- ✅ Unit Testing (Preprocessing, Model, TFLite)
- ✅ Integration Testing (End-to-End pipeline)
- ⚡ Real-time performance tested (<2 seconds)

---

## 📱 App Screenshots

### Home Page
*(Image to be added)*

### Upload Section
<img width="300" alt="Upload Page" src="./cropped_Upload page.jpg" />

### Selected Image
<img width="300" alt="Image Used" src="./cropped_image used.jpg" />

### Analyzing Section
<img width="300" alt="Analyzing Page" src="./cropped_analyzing page.jpg" />

### Results Page
<img width="300" alt="Results Page" src="./cropped_results page.jpg" />
---

## 🛠️ Tech Stack

- Python
- TensorFlow / Keras
- TensorFlow Lite
- OpenCV / PIL
- Android Studio
- Google Colab

---

## 👥 Team

- Abhirami Sajith
- Afia Nasumudeen
- Akshara Cheruvatheri
- Alex Mathai Mathews
