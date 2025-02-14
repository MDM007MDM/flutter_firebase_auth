# โปรเจกต์ Flutter Firebase Authentication

โปรเจกต์นี้เป็นตัวอย่างแอปพลิเคชัน Flutter ที่ใช้ Firebase Authentication ในการจัดการระบบสมาชิกและการยืนยันตัวตนผู้ใช้งาน โดยมีหน้าจอสำหรับ:

*   สร้างบัญชีผู้ใช้ใหม่
*   เข้าสู่ระบบด้วยบัญชีที่มีอยู่
*   ออกจากระบบ
*   รีเซ็ตรหัสผ่านเมื่อลืมรหัสผ่าน
*   แสดงหน้า Home page หลังจากเข้าสู่ระบบสำเร็จ

## คำอธิบายโค้ดแต่ละหน้า (ส่วนที่เกี่ยวข้องกับ Firebase)

### `create_account_screen.dart`

หน้านี้เป็นหน้าจอสำหรับสร้างบัญชีผู้ใช้ใหม่ โดยมีการทำงานหลักที่เกี่ยวข้องกับ Firebase ดังนี้:

*   **`FirebaseAuth.instance.createUserWithEmailAndPassword(email: email, password: password)`:** ฟังก์ชันนี้ใช้ในการสร้างบัญชีผู้ใช้ใหม่ใน Firebase Authentication ด้วยอีเมลและรหัสผ่านที่ผู้ใช้กรอกเข้ามา
*   **การจัดการ `FirebaseAuthException`:** โค้ดมีการดักจับ `FirebaseAuthException` เพื่อจัดการข้อผิดพลาดที่อาจเกิดขึ้นระหว่างการสร้างบัญชี เช่น รหัสผ่านไม่ปลอดภัย, อีเมลซ้ำ, หรืออีเมลไม่ถูกต้อง และแสดงข้อความผิดพลาดให้ผู้ใช้ทราบผ่าน `AlertDialog`
*   **การแสดง `CircularProgressIndicator`:** ในระหว่างที่แอปพลิเคชันกำลังสร้างบัญชีและรอการตอบกลับจาก Firebase จะมีการแสดง `CircularProgressIndicator` เพื่อให้ผู้ใช้ทราบว่าระบบกำลังทำงานอยู่
*   **การแสดง `AlertDialog` สำหรับ Success/Error:** หลังจากสร้างบัญชีสำเร็จ หรือเกิดข้อผิดพลาด จะมีการแสดง `AlertDialog` เพื่อแจ้งผลลัพธ์ให้ผู้ใช้ทราบ

### `forgot_password_screen.dart`

หน้านี้เป็นหน้าจอสำหรับรีเซ็ตรหัสผ่านเมื่อผู้ใช้ลืมรหัสผ่าน โดยมีการทำงานหลักที่เกี่ยวข้องกับ Firebase ดังนี้:

*   **`FirebaseAuth.instance.sendPasswordResetEmail(email: email)`:** ฟังก์ชันนี้ใช้ในการส่งอีเมลรีเซ็ตรหัสผ่านไปยังอีเมลของผู้ใช้ที่ระบุ โดย Firebase จะส่งอีเมลพร้อมลิงก์สำหรับรีเซ็ตรหัสผ่านไปยังอีเมลนั้น
*   **การจัดการ `FirebaseAuthException`:** เช่นเดียวกับหน้า `create_account_screen.dart` โค้ดมีการจัดการ `FirebaseAuthException` เพื่อดักจับข้อผิดพลาดที่อาจเกิดขึ้น เช่น ไม่พบผู้ใช้อีเมลนั้น หรืออีเมลไม่ถูกต้อง และแสดงข้อความผิดพลาดให้ผู้ใช้ทราบ
*   **การแสดง `CircularProgressIndicator`:** แสดงขณะรอการส่งอีเมลรีเซ็ตรหัสผ่าน
*   **การแสดง `AlertDialog` สำหรับ Success/Error:** แจ้งผลลัพธ์ของการส่งอีเมลรีเซ็ตรหัสผ่าน

### `home_screen.dart`

หน้านี้เป็นหน้าจอ Home page ที่แสดงหลังจากผู้ใช้เข้าสู่ระบบสำเร็จ มีการทำงานที่เกี่ยวข้องกับ Firebase ดังนี้:

*   **`FirebaseAuth.instance.currentUser`:** ใช้ในการตรวจสอบว่ามีผู้ใช้ที่เข้าสู่ระบบอยู่ในขณะนั้นหรือไม่ หากมี จะดึงข้อมูลผู้ใช้ปัจจุบันมาแสดงผล เช่น ชื่อผู้ใช้หรืออีเมล
*   **`FirebaseAuth.instance.authStateChanges().listen((User? user) { ... })`:** ใช้ในการตรวจสอบการเปลี่ยนแปลงสถานะการยืนยันตัวตนของผู้ใช้แบบ Realtime เมื่อสถานะการยืนยันตัวตนเปลี่ยนแปลง (เช่น ผู้ใช้เข้าสู่ระบบ หรือออกจากระบบ) จะมีการอัปเดต UI ตามสถานะใหม่
*   **`_signOut()` และ `FirebaseAuth.instance.signOut()`:** ฟังก์ชัน `_signOut()` ใช้ในการออกจากระบบ Firebase Authentication เมื่อผู้ใช้กดปุ่ม "Sign Out" ฟังก์ชัน `FirebaseAuth.instance.signOut()` จะทำการออกจากระบบและเคลียร์ session ของผู้ใช้ออกจากแอป

### `login_screen.dart`

หน้านี้เป็นหน้าจอสำหรับเข้าสู่ระบบด้วยบัญชีผู้ใช้ที่มีอยู่ มีการทำงานหลักที่เกี่ยวข้องกับ Firebase ดังนี้:

*   **`FirebaseAuth.instance.signInWithEmailAndPassword(email: email, password: password)`:** ฟังก์ชันนี้ใช้ในการเข้าสู่ระบบ Firebase Authentication ด้วยอีเมลและรหัสผ่านที่ผู้ใช้กรอกเข้ามา
*   **การจัดการ `FirebaseAuthException`:** ดักจับ `FirebaseAuthException` เพื่อจัดการข้อผิดพลาดที่อาจเกิดขึ้นระหว่างการเข้าสู่ระบบ เช่น ไม่พบผู้ใช้อีเมลนั้น หรือรหัสผ่านไม่ถูกต้อง และแสดงข้อความผิดพลาดให้ผู้ใช้ทราบ
*   **การแสดง `CircularProgressIndicator`:** แสดงขณะรอการตรวจสอบข้อมูลการเข้าสู่ระบบจาก Firebase
*   **การแสดง `AlertDialog` สำหรับ Error:** แจ้งข้อผิดพลาดในการเข้าสู่ระบบ

### `main.dart`

ไฟล์ `main.dart` เป็นจุดเริ่มต้นของแอปพลิเคชัน มีส่วนที่เกี่ยวข้องกับ Firebase ดังนี้:

*   **`await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform)`:** บรรทัดนี้ใช้ในการเริ่มต้น Firebase SDK เมื่อแอปพลิเคชันเริ่มทำงาน ฟังก์ชัน `Firebase.initializeApp()` จะทำการเชื่อมต่อกับ Firebase โปรเจกต์ของคุณ โดยใช้ข้อมูลการตั้งค่าที่อยู่ในไฟล์ `firebase_options.dart` ที่คุณได้ดาวน์โหลดมาจาก Firebase Console
