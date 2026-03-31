const NGROK_URL = "https://cherly-rebellious-fructiferously.ngrok-free.dev"; // 🔁 replace this
export const predictImage = async (imageUri: string) => {
  const formData = new FormData();

  formData.append("file", {
    uri: imageUri,
    name: "photo.jpg",
    type: "image/jpeg",
  } as any);

  const response = await fetch(`${NGROK_URL}/predict`, {
    method: "POST",
    body: formData,
    headers: {
      Accept: "application/json",
      // ❌ DO NOT set Content-Type manually
    },
  });

  const text = await response.text();
  console.log("RAW RESPONSE:", text);

  return JSON.parse(text);
};