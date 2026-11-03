# repo  ->  http://numchi.github.io/repo/

Cydia source ที่ GitHub Actions สร้างและ deploy ให้เองทุกครั้งที่ push

## ตั้งค่าครั้งแรก
1. สร้าง GitHub repo ชื่อ `repo` (ต้องชื่อนี้ถึงจะได้ URL .../repo/) ตั้งเป็น Public
2. ใส่ไฟล์ในโฟลเดอร์นี้ทั้งหมดไว้ที่ root ของ repo แล้ว push
3. ใน GitHub: Settings -> Pages -> Build and deployment -> Source เลือก **GitHub Actions**
4. ไปที่แท็บ Actions รอ workflow "Build and Deploy Cydia Repo" รันเสร็จ (สีเขียว)
5. เปิด https://numchi.github.io/repo/ ในเบราว์เซอร์ ควรเห็นหน้ารายการ package

## เพิ่ม / อัปเดต package
1. เอาไฟล์ .deb (จาก artifact ของ datefix-ios8) ไปไว้ในโฟลเดอร์ `debs/`
   (วิธีง่ายสุด: หน้า repo บน GitHub -> debs -> Add file -> Upload files)
2. Commit / push -> Actions จะสร้าง Packages, Packages.bz2, Packages.gz, Release, index.html แล้ว deploy ให้เอง
3. ลบ package: ลบไฟล์ .deb ออกจาก debs/ แล้ว push
- ไฟล์ที่สร้างอัตโนมัติ (Packages ฯลฯ) ไม่ต้อง commit (อยู่ใน .gitignore)
- ไอคอน repo (ไม่บังคับ): วางไฟล์ CydiaIcon.png ขนาด 60x60 ที่ root

## เพิ่ม source ใน Cydia
Cydia -> Sources -> Edit -> Add -> http://numchi.github.io/repo/
