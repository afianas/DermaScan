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

<img width="700" alt="System Architecture" src="https://github.com/user-attachments/assets/6a4b87a8-e4d0-41b2-95be-e363636f274b" />


The system processes user input locally and returns acne severity without requiring cloud interaction.

---

## 📊 Data Flow Diagrams

### Level 0 DFD
<img width="500" alt="Level 0 DFD" src="https://github.com/user-attachments/assets/0aae6fce-2631-4b8a-ada3-32ab504332a3" />


### Level 1 DFD
<img width="700" alt="Level 1 DFD" src="https://github.com/user-attachments/assets/17b1bbc8-fe39-42c7-ab34-05f66da1d7ca" />


---

## 🔄 Workflow (State Diagram)

<img width="450" alt="Workflow" src="https://github.com/user-attachments/assets/efe3ca6c-e7a5-4c54-b31c-c36a5f58e7ed" />



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

## 📱 Screenshots

<div align="center">
  <table>
    <tr>
      <td align="center"><b>🏠 Home</b></td>
      <td align="center"><b>📤 Upload</b></td>
      <td align="center"><b>🖼️ Selected</b></td>
      <td align="center"><b>⚙️ Analyzing</b></td>
      <td align="center"><b>📊 Results</b></td>
    </tr>
    <tr>
      <td><img src="./home_page.jpg" width="150" alt="Home Page" /></td>
      <td><img src="./cropped_Upload page.jpg" width="150" alt="Upload Section" /></td>
      <td><img src="./cropped_image used.jpg" width="150" alt="Selected Image" /></td>
      <td><img src="./cropped_analyzing page.jpg" width="150" alt="Analyzing" /></td>
      <td><img src="./cropped_results page.jpg" width="150" alt="Results" /></td>
    </tr>
  </table>
</div>


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
