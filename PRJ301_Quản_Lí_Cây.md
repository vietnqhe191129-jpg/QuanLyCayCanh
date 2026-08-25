# Ý tưởng

### **1\. Thành viên 1: Authentication & Từ điển cây mẫu (System Knowledge)**

* **Chức năng đảm nhận:**  
  * Xây dựng lớp kết nối CSDL `DBContext.java` cho cả nhóm dùng chung.  
  * Đăng ký, Đăng nhập, Đăng xuất, Đổi mật khẩu, Cập nhật thông tin cá nhân.  
  * Quản lý "Từ điển loại cây" (Admin thêm/sửa/xóa các loài cây mẫu: Cây Kim Tiền, Trầu Bà... kèm thông số tưới nước, ánh sáng chuẩn).  
  * Khách/User tra cứu Từ điển loại cây mẫu để tham khảo trước khi trồng.  
* **File đảm nhận:** `UserDAO`, `CategoryDAO`, `LoginServlet`, `RegisterServlet`, `CategoryServlet`, `login.jsp`, `category-list.jsp`...

### **2\. Thành viên 2: Quản lý Vườn cây cá nhân tại nhà (My Home Garden)**

* **Chức năng đảm nhận:**  
  * Thêm cây mới vào nhà (Chọn loại cây từ Danh mục mẫu hoặc tự nhập tên riêng, chọn vị trí đặt: *Ban công, Phòng khách, Sân thượng, Bàn làm việc*...).  
  * Danh sách cây trong nhà: Lọc cây theo vị trí trong nhà, tìm kiếm theo tên.  
  * Sửa thông tin cây (Đổi vị trí, đổi ảnh đại diện cây, cập nhật tình trạng sức khỏe: *Khỏe mạnh, Héo, Sâu bệnh*).  
  * Xóa cây (Do cây chết hoặc cho/tặng).  
* **File đảm nhận:** `UserPlantDAO`, `MyGardenServlet`, `AddPlantServlet`, `EditPlantServlet`, `my-garden.jsp`, `plant-detail.jsp`...

### **3\. Thành viên 3: Lịch chăm sóc & Nhật ký phát triển (Care & Growth)**

* **Chức năng đảm nhận:**  
  * **Lịch chăm sóc:** Thiết lập tần suất chăm sóc cho từng cây (*Tưới nước 2 ngày/lần, Bón phân 15 ngày/lần*).  
  * **Trang nhắc việc hôm nay (Checklist):** Hiển thị danh sách các cây **CẦN TƯỚI/CẦN BÓN PHÂN HÔM NAY**. Bấm nút "Đã tưới" để tự động gia hạn ngày tiếp theo.  
  * **Nhật ký ảnh (Growth Diary):** Đăng ảnh cây theo thời gian (kèm chiều cao, số lá, ghi chú) để xem lại hành trình lớn lên của cây.  
* **File đảm nhận:** `CareScheduleDAO`, `GrowthDiaryDAO`, `TodayTaskServlet`, `CareLogServlet`, `DiaryServlet`, `today-tasks.jsp`, `growth-diary.jsp`...

### **4\. Thành viên 4: Báo cáo sự cố bệnh cây & Quản trị Admin (Report & Admin)**

* **Chức năng đảm nhận:**  
  * **Gửi Báo cáo sự cố (User):** Khi cây bị bệnh/bọ/vàng lá, User chụp ảnh gửi báo cáo nhờ hỗ trợ.  
  * **Xử lý Báo cáo (Admin):** Admin xem hình ảnh sự cố, đưa ra lời khuyên/biện pháp chữa bệnh cho cây.  
  * **Quản lý người dùng (Admin):** Xem danh sách User, khóa/mở khóa tài khoản.  
  * **Thống kê Dashboard (Admin):** Thống kê tổng số cây đang được trồng trong hệ thống, số sự cố chưa xử lý.  
* **File đảm nhận:** `ReportDAO`, `AdminUserDAO`, `ReportServlet`, `AdminDashboardServlet`, `reports.jsp`, `admin-dashboard.jsp`...

### **Database:**

CREATE DATABASE HomePlantDB;  
GO

USE HomePlantDB;  
GO

\-- 1\. BẢNG NGƯỜI DÙNG (Users)  
CREATE TABLE Users (  
    UserID INT IDENTITY(1,1) PRIMARY KEY,  
    Username VARCHAR(50) UNIQUE NOT NULL,  
    Password VARCHAR(255) NOT NULL,  
    FullName NVARCHAR(100) NOT NULL,  
    Email VARCHAR(100) UNIQUE NOT NULL,  
    Phone VARCHAR(15),  
    Role VARCHAR(20) DEFAULT 'USER', \-- 'ADMIN' hoặc 'USER'  
    Status BIT DEFAULT 1,             \-- 1: Hoạt động, 0: Khóa  
    CreatedAt DATETIME DEFAULT GETDATE()  
);

\-- 2\. BẢNG TỪ ĐIỂN LOẠI CÂY MẪU (PlantCategories \- Do Admin quản lý)  
CREATE TABLE PlantCategories (  
    CategoryID INT IDENTITY(1,1) PRIMARY KEY,  
    CategoryName NVARCHAR(100) NOT NULL,  
    ScientificName VARCHAR(100),         \-- Tên khoa học (nếu có)  
    Description NVARCHAR(MAX),  
    DefaultWaterDays INT DEFAULT 2,      \-- Tần suất tưới mặc định (Số ngày/lần)  
    LightRequirement NVARCHAR(100),       \-- Nhu cầu ánh sáng (VD: Nắng trực tiếp, Râm mát)  
    ImageUrl VARCHAR(255)  
);

\-- 3\. BẢNG CÂY TRỒNG TẠI NHÀ CỦA USER (UserPlants)  
CREATE TABLE UserPlants (  
    PlantID INT IDENTITY(1,1) PRIMARY KEY,  
    UserID INT NOT NULL,  
    CategoryID INT NULL,                 \-- Chọn từ thư viện mẫu hoặc để NULL nếu cây lạ  
    CustomName NVARCHAR(100) NOT NULL,   \-- Tên tự đặt (VD: "Kim Tiền Bàn Làm Việc")  
    LocationInHome NVARCHAR(100),        \-- Vị trí trong nhà: Ban công, Phòng khách, Sân thượng...  
    PlantedDate DATE DEFAULT GETDATE(),  \-- Ngày bắt đầu trồng/mua về  
    HealthStatus NVARCHAR(50) DEFAULT N'Khỏe mạnh', \-- 'Khỏe mạnh', 'Cần chăm sóc', 'Sâu bệnh'  
    ImageUrl VARCHAR(255),  
    Note NVARCHAR(MAX),  
    FOREIGN KEY (UserID) REFERENCES Users(UserID) ON DELETE CASCADE,  
    FOREIGN KEY (CategoryID) REFERENCES PlantCategories(CategoryID) ON DELETE SET NULL  
);

\-- 4\. BẢNG THIẾT LẬP LỊCH CHĂM SÓC (CareSchedules)  
CREATE TABLE CareSchedules (  
    ScheduleID INT IDENTITY(1,1) PRIMARY KEY,  
    PlantID INT NOT NULL,  
    ActionType NVARCHAR(50) NOT NULL,   \-- 'Tưới nước', 'Bón phân', 'Cắt tỉa', 'Thay đất'  
    FrequencyDays INT DEFAULT 1,        \-- Số ngày lặp lại (VD: 2 ngày tưới 1 lần)  
    LastPerformed DATETIME DEFAULT GETDATE(), \-- Lần làm gần nhất  
    NextDueDate AS DATEADD(day, FrequencyDays, LastPerformed), \-- Tự động tính ngày tiếp theo  
    FOREIGN KEY (PlantID) REFERENCES UserPlants(PlantID) ON DELETE CASCADE  
);

\-- 5\. BẢNG NHẬT KÝ LỚN LÊN CỦA CÂY (GrowthDiaries)  
CREATE TABLE GrowthDiaries (  
    DiaryID INT IDENTITY(1,1) PRIMARY KEY,  
    PlantID INT NOT NULL,  
    LogDate DATETIME DEFAULT GETDATE(),  
    HeightCm FLOAT NULL,                \-- Chiều cao cây (cm)  
    ImageUrl VARCHAR(255),               \-- Ảnh chụp mốc lớn lên  
    Note NVARCHAR(MAX),                 \-- Ghi chú (VD: "Nay nảy thêm 2 mầm mới")  
    FOREIGN KEY (PlantID) REFERENCES UserPlants(PlantID) ON DELETE CASCADE  
);

\-- 6\. BẢNG BÁO CÁO SỰ CỐ / SÂU BỆNH (PlantReports)  
CREATE TABLE PlantReports (  
    ReportID INT IDENTITY(1,1) PRIMARY KEY,  
    UserID INT NOT NULL,  
    PlantID INT NULL,                   \-- Cây gặp sự cố  
    Title NVARCHAR(200) NOT NULL,       \-- Tiêu đề (VD: "Lá cây bị vàng và rụng hàng loạt")  
    Description NVARCHAR(MAX) NOT NULL, \-- Mô tả chi tiết triệu chứng  
    ImageUrl VARCHAR(255),               \-- Ảnh chụp vết bệnh  
    Status NVARCHAR(50) DEFAULT N'Chờ xử lý', \-- 'Chờ xử lý', 'Đã tư vấn'  
    AdminResponse NVARCHAR(MAX) NULL,   \-- Lời khuyên/chẩn đoán từ Admin  
    CreatedAt DATETIME DEFAULT GETDATE(),  
    FOREIGN KEY (UserID) REFERENCES Users(UserID),  
    FOREIGN KEY (PlantID) REFERENCES UserPlants(PlantID) ON DELETE SET NULL  
);

# Luồng chức năng

**1\. Luồng Xác thực & Phân quyền (Auth & Security)**

* **Đăng ký / Đăng nhập:** Người dùng nhập thông tin trên giao diện **\>** Servlet nhận dữ liệu và kiểm tra trong DB **\>** Nếu chính xác, lưu Object `User` vào `HttpSession` **\>** Chuyển hướng về trang tương ứng (`USER` về Vườn cây cá nhân, `ADMIN` về Dashboard).  
* **Bảo mật Route (Filter):** Sử dụng `AuthenticationFilter` để chặn truy cập trái phép. Nếu người dùng chưa đăng nhập nhưng cố tình truy cập URL `/my-garden` hoặc `/admin` **\>** Hệ thống tự động chuyển hướng về trang `login.jsp`.

**2\. Luồng Quản lý Vườn cây cá nhân (Home Garden Flow)**

* **Xem danh sách:** Hiển thị danh sách cây trong nhà **\>** Áp dụng bộ lọc theo **Vị trí** (Ban công, Phòng khách, Sân thượng) hoặc tìm kiếm theo tên cây.  
* **Thêm cây mới:** Chọn loại cây từ Thư viện mẫu (để lấy thông số tưới chuẩn) hoặc Tự nhập tên riêng **\>** Chọn vị trí đặt cây trong nhà **\>** Upload ảnh đại diện cây **\>** Lưu thông tin vào CSDL.  
* **Cập nhật / Xóa:** Đổi vị trí đặt cây, cập nhật tình trạng sức khỏe (*Khỏe mạnh, Sâu bệnh, Héo*) hoặc xóa bỏ khỏi danh sách khi cây chết/cho đi.

**3\. Luồng Lịch chăm sóc & Checklist hàng ngày (Care Schedule & Task Flow)**

* **Cấu hình lịch:** Mỗi cây khi tạo sẽ gắn liền với lịch lặp lại `FrequencyDays` (Ví dụ: Tưới nước 2 ngày/lần).  
* **Danh sách công việc hôm nay (Today Checklist):** Servlet truy vấn danh sách cây có ngày `NextDueDate` nhỏ hơn hoặc bằng ngày hiện tại **\>** Hiển thị danh sách các cây **CẦN TƯỚI HÔM NAY**.  
* **Đánh dấu hoàn thành:** Người dùng tích chọn nút "Đã tưới" **\>** Servlet cập nhật `LastPerformed = GETDATE()` và tự động tính lại `NextDueDate` cho lần kế tiếp.

**4\. Luồng Nhật ký phát triển (Growth Diary Flow)**

* User chọn một cây cụ thể **\>** Nhấn nút "Thêm nhật ký" **\>** Nhập chiều cao, ghi chú và tải ảnh mới nhất **\>** Hệ thống lưu dữ liệu và hiển thị dạng Dòng thời gian (Timeline) quá trình phát triển của cây.

**5\. Luồng Báo cáo sự cố & Tư vấn chữa bệnh (Plant Report Flow)**

* **Gửi sự cố (User):** Khi cây bị bệnh **\>** User tạo Báo cáo (Chọn cây, tải ảnh lá bị bệnh, mô tả triệu chứng) **\>** Hệ thống lưu bản ghi với trạng thái `Chờ xử lý`.  
* **Xử lý sự cố (Admin):** Admin vào danh sách Báo cáo **\>** Xem hình ảnh và triệu chứng **\>** Nhập lời khuyên / phương pháp điều trị **\>** Chuyển trạng thái bản ghi thành `Đã tư vấn`.  
* **Xem kết quả (User):** User nhận thông báo phản hồi từ Admin ngay tại màn hình chi tiết cây.

**6\. Luồng Quản trị Admin (System Admin Flow)**

* **Quản lý Thư viện mẫu:** Thực hiện CRUD các loài cây chuẩn (Cây Kim Tiền, Trầu Bà...) làm dữ liệu gợi ý cho người dùng.  
* **Quản lý User:** Xem danh sách người dùng, thay đổi trạng thái kích hoạt hoặc khóa tài khoản.  
* **Dashboard Thống kê:** Hiển thị các con số tổng quan gồm tổng số User, tổng số cây đang trồng, số lượt tưới trong ngày và số Báo cáo chưa xử lý.

