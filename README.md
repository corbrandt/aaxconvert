# AAX to Opus/MP3/M4B Converter - aaxconvert

## 🎧 About This Script
This is a simple Bash script called **aaxconvert** that converts Audible AAX files into **Opus**, **MP3**, or **M4B** format.
It automatically extracts metadata and saves the file as:
```
Artist - Title.ext (where ext = opus, mp3, or m4b)
```

## ⚠️ Legal Notice
Before using this script, ensure you have the **legal rights** to convert and use the AAX files. 
Do not share or distribute converted audiobooks if doing so violates copyright laws in your country!

---

## 🛠 Prerequisites
Make sure you have the following installed:
- `ffmpeg` (with AAX support)
- `ffprobe` (for metadata extraction)
- A set of **Activation Bytes** (see below)

### Getting Activation Bytes
You can retrieve your Activation Bytes from:
👉 [https://audible-tools.kamsker.at](https://audible-tools.kamsker.at)

Once obtained, these bytes **do not change**, so you only need to set them once in the script.

---

## 🚀 Installation & Setup
1. **Download the script**
   ```bash
   git clone https://github.com/corbrandt/aaxconvert.git
   cd aaxconvert
   ```
2. **Edit the script to add your Activation Bytes**
   ```bash
   nano aaxconvert.sh
   ```
   Find this line and replace it with your Activation Bytes:
   ```bash
   ACTIVATION_BYTES="YOUR_ACTIVATION_BYTES_HERE"
   ```
3. **Make it executable**
   ```bash
   chmod +x aaxconvert.sh
   ```
4. **Move it to a location in your PATH (optional)**
   ```bash
   sudo mv aaxconvert.sh /usr/local/bin/aaxconvert
   ```
   Now, you can run it from anywhere using `aaxconvert` 🎉

---

## 📌 Usage Examples

### 🔹 Basic Conversion (Default: Opus 128k)
```bash
aaxconvert -i audiobook.aax
```
This will create `Author - Title.opus` with a bitrate of 128 kbps.

### 🔹 Convert to MP3 (160 kbps by default)
```bash
aaxconvert -i audiobook.aax -t mp3
```

### 🔹 Convert to M4B (160 kbps by default, optimized for audiobooks)
```bash
aaxconvert -i audiobook.aax -t m4b
```

### 🔹 Custom Bitrate (e.g., 192 kbps MP3)
```bash
aaxconvert -i audiobook.aax -t mp3 -b 192k
```

---

## ⚡️ Power User Tips

### 🔹 Create an Alias for Quick Use
If you don’t want to type the full command every time, add an alias to your `.bashrc` or `.zshrc`:
```bash
alias aax2mp3='aaxconvert -t mp3'
alias aax2opus='aaxconvert -t opus'
alias aax2m4b='aaxconvert -t m4b'
```
Then just run:
```bash
aax2mp3 -i mybook.aax
```

### 🔹 Batch Convert Multiple AAX Files
```bash
for file in *.aax; do aaxconvert -i "$file" -t mp3 -b 192k; done
```

---

## 🤔 Troubleshooting
### "Could not write header" error?
Make sure you’re only extracting the **audio** stream and not a video stream. The script already handles this with `-vn` in `ffmpeg`, but double-check your AAX file.

### Metadata Missing?
Some AAX files **lack metadata**. If this happens, the script defaults to:
```
Unknown Artist - Unknown Title.mp3
```
You can manually rename it afterward.

---

## ❤️ Contributions
Feel free to fork and improve this script! Pull requests are welcome. 😊

---

## 📜 License
This project is licensed under the **MIT License**. Use responsibly!

🎧 Happy Listening!
