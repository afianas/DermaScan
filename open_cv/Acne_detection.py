import cv2
import numpy as np
import dlib
import matplotlib.pyplot as plt
import matplotlib.patches as mpatches
import os

# ───────── PATHS ─────────
BASE_DIR = os.path.dirname(os.path.abspath(__file__))
predictor_path = os.path.join(BASE_DIR, "models", "shape_predictor_81_face_landmarks.dat")
image_path = os.path.join(BASE_DIR, "data","acne_mild (2).jpg")  # change here

detector = dlib.get_frontal_face_detector()
predictor = dlib.shape_predictor(predictor_path)


# ───────── NMS ─────────
def nms(boxes, overlap=0.3):
    if len(boxes) == 0:
        return []

    boxes = np.array(boxes)
    x1 = boxes[:,0]
    y1 = boxes[:,1]
    x2 = x1 + boxes[:,2]
    y2 = y1 + boxes[:,3]

    area = (x2-x1)*(y2-y1)
    idxs = area.argsort()[::-1]

    keep = []
    while len(idxs) > 0:
        i = idxs[0]
        keep.append(i)

        xx1 = np.maximum(x1[i], x1[idxs[1:]])
        yy1 = np.maximum(y1[i], y1[idxs[1:]])
        xx2 = np.minimum(x2[i], x2[idxs[1:]])
        yy2 = np.minimum(y2[i], y2[idxs[1:]])

        w = np.maximum(0, xx2-xx1)
        h = np.maximum(0, yy2-yy1)

        overlap_ratio = (w*h)/(area[idxs[1:]]+1e-6)
        idxs = idxs[np.where(overlap_ratio < overlap)[0]+1]

    return boxes[keep]


# ───────── FACE MASK ─────────
def get_skin(img):
    gray = cv2.cvtColor(img, cv2.COLOR_BGR2GRAY)
    faces = detector(gray)

    if len(faces)==0:
        print("No face")
        return None,None,None

    face = faces[0]
    landmarks = predictor(gray, face)

    pts = np.array([[landmarks.part(i).x, landmarks.part(i).y] for i in range(81)])
    hull = cv2.convexHull(pts)

    mask = np.zeros(gray.shape, np.uint8)
    cv2.fillConvexPoly(mask, hull, 255)

    # remove eyes
    for i in range(36,48):
        cv2.circle(mask,(landmarks.part(i).x,landmarks.part(i).y),18,0,-1)

    # remove mouth
    mouth = np.array([[landmarks.part(i).x,landmarks.part(i).y] for i in range(48,68)])
    cv2.fillConvexPoly(mask, cv2.convexHull(mouth), 0)

    skin = cv2.bitwise_and(img,img,mask=mask)

    face_box = (face.left(), face.top(), face.right(), face.bottom())
    return skin, img.copy(), (mask, face_box)


# ───────── ACNE DETECTION ─────────
def detect_acne(skin, original, meta):
    mask, face_box = meta
    fx1,fy1,fx2,fy2 = face_box
    face_area = max((fx2-fx1)*(fy2-fy1),1)

    # 🔹 Convert to grayscale
    gray = cv2.cvtColor(skin, cv2.COLOR_BGR2GRAY)

    # 🔹 Enhance contrast
    gray = cv2.equalizeHist(gray)

    # 🔹 Blob detector setup (KEY FIX)
    params = cv2.SimpleBlobDetector_Params()
    params.filterByArea = True
    params.minArea = 20
    params.maxArea = 500

    params.filterByCircularity = False
    params.filterByConvexity = False
    params.filterByInertia = False

    params.filterByColor = True
    params.blobColor = 255  # bright spots

    detector = cv2.SimpleBlobDetector_create(params)

    # 🔹 Detect blobs
    keypoints = detector.detect(gray)

    count = len(keypoints)

    # 🔹 Draw detections
    for kp in keypoints:
        x = int(kp.pt[0])
        y = int(kp.pt[1])
        r = int(kp.size / 2)

        cv2.circle(original, (x,y), r, (0,0,255), 2)

    # 🔹 Severity (based on count)
    severity = int(np.clip(count / 5, 0, 10))

    return original, count, severity, gray
def run(path):
    img = cv2.imread(path)
    if img is None:
        print("Image not found")
        return

    skin, original, meta = get_skin(img)
    if skin is None:
        return

    result,count,score,mask = detect_acne(skin, original, meta)

    rgb = cv2.cvtColor(result, cv2.COLOR_BGR2RGB)

    label = "Mild" if score<=3 else "Moderate" if score<=6 else "Severe"
    color = "#27ae60" if score<=3 else "#e67e22" if score<=6 else "#e74c3c"

    fig,ax = plt.subplots(1,2,figsize=(14,6))
    fig.patch.set_facecolor("#1a1a2e")

    ax[0].imshow(rgb)
    ax[0].set_title(f"Count={count} | Severity={score} [{label}]", color=color)
    ax[0].axis("off")
    ax[0].legend(handles=[mpatches.Patch(color="#e74c3c", label="Acne")])

    ax[1].imshow(mask, cmap="hot")
    ax[1].set_title("Detection Mask")
    ax[1].axis("off")

    plt.show()


run(image_path)