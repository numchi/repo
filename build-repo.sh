#!/bin/sh
# สร้างไฟล์ repo จาก .deb ทุกตัวในโฟลเดอร์ debs/
# ต้องมี dpkg-scanpackages (Linux: apt install dpkg-dev | macOS: brew install dpkg)
set -e
cd "$(dirname "$0")"
. ./repo.conf

mkdir -p debs
ls debs/*.deb >/dev/null 2>&1 || { echo "ไม่มีไฟล์ .deb ใน debs/"; exit 1; }

# ถ้ามีหลายเวอร์ชันของ package เดียวกัน เก็บไว้ทั้งหมด (-m)
dpkg-scanpackages -m debs /dev/null > Packages 2>/dev/null
bzip2 -kf Packages
gzip -kf Packages

cat > Release <<REL
Origin: ${REPO_NAME}
Label: ${REPO_NAME}
Suite: stable
Version: 1.0
Codename: ios
Architectures: iphoneos-arm
Components: main
Description: ${REPO_DESC}
REL

# สร้างรายการ package ในหน้าเว็บอัตโนมัติจากไฟล์ Packages
LIST=$(awk -v RS= -F'\n' '
{
  name=""; ver=""; desc=""; id="";
  for (i=1;i<=NF;i++) {
    if ($i ~ /^Name: /)        name=substr($i,7);
    if ($i ~ /^Package: /)     id=substr($i,10);
    if ($i ~ /^Version: /)     ver=substr($i,10);
    if ($i ~ /^Description: /) desc=substr($i,14);
  }
  if (name=="") name=id;
  gsub(/&/,"\\&amp;",name); gsub(/</,"\\&lt;",name);
  gsub(/&/,"\\&amp;",desc); gsub(/</,"\\&lt;",desc);
  printf "<li><b>%s</b> <small>%s</small><br><span>%s</span></li>\n", name, ver, desc;
}' Packages)

cat > index.html <<HTML
<!DOCTYPE html>
<html><head><meta charset="utf-8">
<meta name="viewport" content="width=device-width, initial-scale=1">
<title>${REPO_NAME}</title>
<style>
body{font-family:-apple-system,Helvetica,sans-serif;max-width:560px;margin:0 auto;padding:32px 20px}
a.btn{display:inline-block;background:#007aff;color:#fff;padding:12px 22px;border-radius:10px;text-decoration:none}
ul{list-style:none;padding:0}li{padding:12px 0;border-bottom:1px solid #ddd}
li span{color:#666;font-size:14px}code{background:#eee;padding:2px 6px;border-radius:4px}
</style></head><body>
<h2>${REPO_NAME}</h2>
<p>${REPO_DESC}</p>
<p><a class="btn" href="cydia://url/https://cydia.saurik.com/api/share#?source=${REPO_URL}">Add to Cydia</a></p>
<p>หรือใน Cydia: Sources &rarr; Edit &rarr; Add &rarr; <code>${REPO_URL}</code></p>
<h3>Packages</h3>
<ul>
${LIST}
</ul>
</body></html>
HTML

echo "สร้างเสร็จ: $(grep -c '^Package:' Packages) package"
