#!/bin/bash

# واجهة احترافية لاختيار المجلد
DIR=$(zenity --file-selection --directory --title="اختر المجلد الذي يحتوي على الصور")

if [ -z "$DIR" ]; then exit; fi

# إنشاء مجلد للنتائج لعدم تخريب الأصل
OUTPUT_DIR="$DIR/Optimized_By_Adnan"
mkdir -p "$OUTPUT_DIR"

FILES_COUNT=$(ls "$DIR"/*.{jpg,jpeg,png,JPG,PNG} 2>/dev/null | wc -l)

(
count=0
for img in "$DIR"/*.{jpg,jpeg,png,JPG,PNG}; do
    [ -e "$img" ] || continue
    filename=$(basename "$img")
    
    echo "# جاري معالجة وتحسين: $filename"
    
    # خوارزمية الضغط الذكي: تقليل الحجم، مسح البيانات الزائدة، وتحسين الالوان
    convert "$img" -sampling-factor 4:2:0 -strip -quality 85 -interlace JPEG -colorspace sRGB "$OUTPUT_DIR/$filename"
    
    count=$((count + 1))
    percent=$((count * 100 / FILES_COUNT))
    echo "$percent"
done
) | zenity --progress --title="Adnan Image Studio" --text="بدء المعالجة الذكية..." --percentage=0 --auto-close

zenity --info --text="تمت العملية بنجاح!\nالصور المحسنة موجودة في: $OUTPUT_DIR" --title="اكتمل العمل"
