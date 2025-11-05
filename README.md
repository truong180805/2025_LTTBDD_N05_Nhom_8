# 🎯 Mini Habit Challenge  
**Ứng dụng Theo dõi Thói quen**

Chào mừng bạn đến với **Mini Habit Challenge**!  
Đây là một ứng dụng di động đa nền tảng (iOS & Android) được xây dựng bằng **Flutter**, giúp người dùng xây dựng và theo dõi các **thói quen tích cực** mỗi ngày.  

> 🧩 **Ghi chú:** Đây là dự án *Bài tập lớn* cho học phần **Lập trình cho Thiết bị Di động (CSE702027)** tại **Trường Đại học Phenikaa**.

---

## 👨‍🏫 Thông tin chung
- **Giảng viên hướng dẫn:** Nguyễn Xuân Quế  
- **Sinh viên thực hiện:** Nguyễn Văn Trường  
- **Mã sinh viên:** 23010371  
- **Trường:** Đại học Phenikaa – Khoa Công nghệ Thông tin  

---

## 📑 Mục lục
1. ✨ [Tính năng chính](#-tính-năng-chính)    
2. 🛠️ [Công nghệ & Kiến trúc](#️-công-nghệ--kiến-trúc)  
3. 🚀 [Cách chạy dự án](#-cách-chạy-dự-án)  
4. ⚠️ [Giới hạn của dự án](#️-giới-hạn-của-dự-án)  
5. 👨‍💻 [Tác giả](#-tác-giả)  

---

## ✨ Tính năng chính

Ứng dụng cho phép người dùng **quản lý và theo dõi các mục tiêu/thói quen** một cách trực quan, tạo động lực mỗi ngày:

### 🧠 Quản lý Thói quen
- Tạo **2 loại thói quen**:
  - **Hàng ngày:** lặp lại vô hạn.
  - **Thử thách:** có giới hạn số ngày.  
- Hủy hoặc xóa thói quen (kèm **Dialog xác nhận**).

### 📅 Theo dõi Tiến độ
- **Tick nhanh**: Đánh dấu hoàn thành ngay trên màn hình chính.  
- **Lịch tương tác:** Tích hợp `table_calendar` để xem và chỉnh sửa tiến độ của các ngày trong quá khứ hoặc tương lai.  
- **Tính chuỗi (Streak):** Tự động tính và hiển thị số ngày hoàn thành liên tiếp 🔥.

### 🎉 Phản hồi & Động lực
- **Màn hình Chúc mừng:** Hiệu ứng **pháo hoa (confetti)** tự động kích hoạt khi hoàn thành một “Thử thách”.  
- **Banner Động lực:** Hiển thị ảnh truyền cảm hứng ở màn hình chính và hồ sơ.

### 📊 Thống kê Chi tiết
- Bộ lọc 3 tab: **Tổng quan**, **Hàng ngày**, **Thử thách**.  
- Biểu đồ tròn `CircularPercentIndicator` thể hiện **tiến độ hôm nay**.  
- Hiển thị riêng danh sách các **thử thách đã hoàn thành**.

### 🧍 Tùy chỉnh & Cá nhân hóa
- **Đa ngôn ngữ:** Hỗ trợ **Tiếng Việt (mặc định)** và **Tiếng Anh** (qua `l10n`).  
- **Chế độ sáng/tối:** Hỗ trợ 3 chế độ (Light / Dark / System) với **Material 3** tùy chỉnh.  
- **Hồ sơ người dùng:** Nhập & lưu tạm thời **Tên, Ngày sinh, Cân nặng, Chiều cao**.  
- **Menu trượt (Drawer)** tiện lợi.  
- **Chức năng “Reset ứng dụng”** để xóa toàn bộ dữ liệu.

---


## 🛠️ Công nghệ & Kiến trúc

Dự án được xây dựng theo **kiến trúc quản lý trạng thái tập trung (Centralized State Management)** nhằm tách biệt **logic nghiệp vụ** và **giao diện**.

### 🔧 Công nghệ
- **Framework:** Flutter (Material 3)  
- **Ngôn ngữ:** Dart  

### 🧩 Kiến trúc Provider
Ứng dụng sử dụng `MultiProvider` tại `main.dart` để cung cấp 3 **Provider chính**:

| Provider | Chức năng |
|-----------|------------|
| 🧠 `HabitProvider` | Quản lý logic nghiệp vụ (thêm, xóa, tick, xử lý hoàn thành) |
| ⚙️ `SettingsProvider` | Quản lý `ThemeMode` và `Locale` |
| 👤 `ProfileProvider` | Quản lý dữ liệu hồ sơ người dùng |

### 💾 Cấu trúc dữ liệu
- `Habit.completionLog` sử dụng **Map<DateTime, bool>** thay vì **List<bool>**.  
  👉 Giúp tương thích với `TableCalendar` và tính toán **chuỗi streak** chính xác.

### 📦 Thư viện (Packages) chính
| Tên | Chức năng |
|-----|------------|
| `google_fonts` | Tùy chỉnh font chữ Poppins |
| `intl`, `flutter_localizations` | Hỗ trợ đa ngôn ngữ (i18n) |
| `table_calendar` | Hiển thị & tương tác với lịch |
| `percent_indicator` | Biểu đồ tròn, thanh tiến độ |
| `confetti` | Hiệu ứng pháo hoa khi hoàn thành thử thách |

---

## 🚀 Cách chạy dự án

1. **Clone repo**
   ```bash
   git clone [ĐƯỜNG_DẪN_REPO_CỦA_BẠN]
   ```
2. **Di chuyển vào thư mục**
   ```bash
   cd [TÊN_THƯ_MỤC_DỰ_ÁN]
   ```
3. **Cài đặt dependencies**
   ```bash
   flutter pub get
   ```
4. **Chạy ứng dụng**
   ```bash
   flutter run
   ```
> 💡 Đảm bảo bạn đã có máy ảo Android/iOS đang chạy hoặc thiết bị thật được kết nối.

---

## ⚠️ Giới hạn của dự án

Vì là bài tập lớn nên một số tính năng chưa được triển khai đầy đủ:

- ❌ **Lưu trữ dữ liệu vĩnh viễn:** Dữ liệu (thói quen, hồ sơ, cài đặt) chỉ lưu tạm thời trong `Provider`. Mất khi tắt ứng dụng.  
- 🔔 **Thông báo (Notification):** Giao diện có chọn “Giờ nhắc nhở” nhưng logic `flutter_local_notifications` chưa được triển khai.

---

## 👨‍💻 Tác giả
- **Sinh viên thực hiện:** Nguyễn Văn Trường  
- **Mã sinh viên:** 23010371  
- **Giảng viên hướng dẫn:** Nguyễn Xuân Quế  
- **Trường:** Đại học Phenikaa – Trường Công nghệ Thông tin  

---

📘 *Cảm ơn bạn đã quan tâm đến dự án Mini Habit Challenge! Nếu thấy hữu ích, hãy để lại ⭐️ cho repo nhé!*  
