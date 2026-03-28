#!/bin/bash
# Adnan Image Studio v2.1 - With Watermark Support

# تثبيت المحركات الضرورية
sudo apt install imagemagick zenity -y &>/dev/null

# واجهة اختيار المجلد
DIR=$(zenity --file-selection --directory --title="اختر مجلد صور المسلسلات او الافلام")
if [ -z "$DIR" ]; then exit; fi

# طلب نص العلامة المائية (مثلا اسم موقعك)
WM_TEXT=$(zenity --entry --title="العلامة المائية" --text="اكتب اسم موقعك او الحقوق (بدون همزات):" --entry-text="CimaMax")
if [ -z "$WM_TEXT" ]; then WM_TEXT="Adnan Studio"; fi

# انشاء مجلد النتائج
OUTPUT_DIR="$DIR/Watermarked_By_Adnan"
mkdir -p "$OUTPUT_DIR"

FILES_COUNT=$(ls "$DIR"/*.{jpg,jpeg,png,JPG,PNG} 2>/dev/null | wc -l)

(
count=0
for img in "$DIR"/*.{jpg,jpeg,png,JPG,PNG}; do
    [ -e "$img" ] || continue
    filename=$(basename "$img")
    
    echo "# جاري الضغط واضافة العلامة لـ: $filename"
    
    # الامر السحري: ضغط الصورة + اضافة نص ابيض شفاف في الزاوية اليمنى السفلية
    convert "$img" -sampling-factor 4:2:0 -strip -quality 85 -interlace JPEG -colorspace sRGB \
    -gravity southeast -pointsize 30 -fill "rgba(255,255,255,0.4)" -annotate +20+20 "$WM_TEXT" \
    "$OUTPUT_DIR/$filename"
    
    count=$((count + 1))
    echo $((count * 100 / FILES_COUNT))
done
) | zenity --progress --title="Adnan Image Studio" --text="جاري معالجة الصور..." --percentage=0 --auto-close

zenity --info --text="تمت العملية! الصور المحمية والمضغوطة جاهزة في:\n$OUTPUT_DIR" --title="اكتمل العمل"
