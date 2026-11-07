| Thông tin | Chi tiết |
|---|---|
| Họ và tên | Kiều Đình Văn |
| Nhóm | ManchesterUnited |
| Email | 26ai.vankd@vinuni.edu.vn |

# Lab 02 — Worksheet: AI Product Scoping (Vin Smart Future)

> **Bài toán Deep-Dive:** VinFast — Trợ lý phân loại sơ bộ lỗi xe từ mô tả tiếng Việt của khách hàng (VinFast Service Triage Assistant)

---

# 🔍 Phase 1 — SCAN (Cá nhân)

### 📝 List bài toán của tôi:

| # | Subsidiary | Lens | Mô tả ngắn bài toán |
|---|------------|------|---------------------|
| 1 | **VinFast** | AI có thể tốt hơn | Khách mô tả lỗi xe bằng tiếng Việt tự do qua hotline/chat app (VD: *"đi qua gờ giảm tốc kêu cụp cụp ở bánh trước"*). Nhân viên CSKH phải tự đoán nhóm lỗi, mức khẩn cấp và hỏi đi hỏi lại trước khi chuyển cho cố vấn dịch vụ ở xưởng. |
| 2 | **Vinhomes** | Lặp lại | Lễ tân Ban quản lý (BQL) tòa nhà đọc từng phản ánh của cư dân trên App Vinhomes Resident (mất nước, hỏng đèn hành lang, ồn ào...) rồi chuyển tay đến đúng bộ phận kỹ thuật / an ninh / vệ sinh. |
| 3 | **Vinpearl** | Tốn thời gian | Nhân viên Sales đọc email đặt phòng theo đoàn (group booking) của công ty lữ hành (nhiều ngày, nhiều loại phòng, yêu cầu đặc biệt), nhập tay vào hệ thống để kiểm tra quỹ phòng và soạn báo giá. |
| 4 | **Xanh SM** | Pain từ người khác | Tài xế phàn nàn vì ghi chú điểm đón của khách mơ hồ (*"cổng sau tòa S2, chỗ quán phở"*), phải gọi điện hỏi lại, khách chờ lâu rồi hủy chuyến. |
| 5 | **Vinmec** | Pain từ người khác | Tổng đài đặt lịch phải hỏi triệu chứng để chọn chuyên khoa. Chọn sai khoa thì bệnh nhân bị chuyển khoa, mất lượt khám và bác sĩ phàn nàn. |

---

# 🃏 Phase 2 — QUICK-ASSESS (Cá nhân)

Chọn top 3: **#1 (VinFast phân loại lỗi xe), #2 (Vinhomes phản ánh cư dân), #3 (Vinpearl group booking).**

### Card #1 — VinFast: Phân loại sơ bộ lỗi xe từ mô tả của khách

```text
┌─────────────────────────────────────────────────────────────┐
│ QUICK PROBLEM CARD #1                                       │
│                                                             │
│ Bài toán: CSKH VinFast mất nhiều thời gian để biến lời kể   │
│ lỗi xe tự do của khách thành "nhóm lỗi + mức khẩn cấp" trước│
│ khi chuyển cho cố vấn dịch vụ (CVDV) tại xưởng.             │
│ Công ty thành viên: [x] VinFast                             │
│                                                             │
│ Ai đang đau? CSKH (quá tải, phải hỏi nhiều), CVDV (nhận     │
│ ticket thiếu thông tin), Khách (phải kể lại nhiều lần).     │
│                                                             │
│ Workflow thủ công hiện tại (5 bước):                        │
│   1. Nhận cuộc gọi/chat, ghi lại mô tả                      │
│   → 2. Hỏi thêm câu làm rõ theo kinh nghiệm cá nhân         │
│   → 3. Tra knowledge base để đoán nhóm lỗi & mức khẩn cấp   │
│   → 4. Tạo ticket CRM, chuyển CVDV                          │
│   → 5. CVDV gọi lại khách xác nhận & xếp lịch xưởng         │
│                                                             │
│ Bước nào tốn nhất? Bước 2–3 (⏱ 11 phút/lượt) + bước 5 phải  │
│ gọi lại khách ở ~35% ticket do thiếu thông tin           │
│ AI nhảy vào ở bước nào? Bước 2–3: trích xuất thông tin, gợi │
│ ý câu hỏi làm rõ, phân loại sơ bộ, soạn tin nháp.           │
│                                                             │
│ Metric: Giảm thời gian thao tác CSKH từ 21 phút ──> ≤ 8 phút│
│ Tỷ lệ CVDV phải gọi lại: 35% ──> < 10%                      │
│ Không bỏ sót ca nguy hiểm: Recall nhóm P0 ≥ 99%             │
│                                                             │
│ Quick Architecture: [x] LLM Feature (+ Rule guardrail)      │
└─────────────────────────────────────────────────────────────┘
```

### Card #2 — Vinhomes: Phân loại & điều hướng phản ánh cư dân

```text
┌─────────────────────────────────────────────────────────────┐
│ QUICK PROBLEM CARD #2                                       │
│                                                             │
│ Bài toán: Phản ánh của cư dân trên App Resident được lễ tân │
│ BQL đọc và chuyển tay, dồn ứ ngoài giờ hành chính.          │
│ Công ty thành viên: [x] Vinhomes                            │
│                                                             │
│ Ai đang đau? Lễ tân BQL (lặp lại), cư dân (chờ phản hồi).   │
│                                                             │
│ Workflow thủ công hiện tại (4 bước):                        │
│   1. Cư dân gửi phản ánh qua App                            │
│   → 2. Lễ tân đọc, xác định loại sự cố + tòa/căn            │
│   → 3. Chuyển bộ phận kỹ thuật/an ninh/vệ sinh qua Zalo     │
│   → 4. Theo dõi & phản hồi cư dân                           │
│                                                             │
│ Bước nào tốn nhất? Bước 2–3 (⏱ ~5 phút/phản ánh, nhưng trễ  │
│ 8–12 giờ khi rơi vào ban đêm/cuối tuần)                  │
│ AI nhảy vào ở bước nào? Bước 2: phân loại + trích vị trí.   │
│                                                             │
│ Metric: Thời gian từ lúc gửi đến khi chuyển đúng bộ phận:   │
│ ~8 giờ ──> < 15 phút; route đúng ≥ 90%.                     │
│                                                             │
│ Quick Architecture: [x] Rule (form có dropdown loại sự cố)  │
│                     LLM chỉ cho phần văn bản tự do          │
└─────────────────────────────────────────────────────────────┘
```

### Card #3 — Vinpearl: Đọc email group booking & soạn nháp lệnh book

```text
┌─────────────────────────────────────────────────────────────┐
│ QUICK PROBLEM CARD #3                                       │
│                                                             │
│ Bài toán: Sales Vinpearl nhập tay yêu cầu từ email đặt phòng│
│ theo đoàn để kiểm tra quỹ phòng và soạn báo giá.            │
│ Công ty thành viên: [x] Khác: Vinpearl                      │
│                                                             │
│ Ai đang đau? Nhân viên Sales/Reservation; đối tác lữ hành   │
│ (chờ báo giá lâu, dễ chuyển sang khách sạn khác).           │
│                                                             │
│ Workflow thủ công hiện tại (5 bước):                        │
│   1. Nhận email (kèm PDF/Excel)                             │
│   → 2. Đọc, tách yêu cầu: ngày, số phòng từng loại, ăn uống │
│   → 3. Kiểm tra quỹ phòng trên PMS                          │
│   → 4. Soạn báo giá/xác nhận                                │
│   → 5. Trưởng nhóm duyệt giá                                │
│                                                             │
│ Bước nào tốn nhất? Bước 2–3 (⏱ ~25 phút/email)           │
│ AI nhảy vào ở bước nào? Bước 2: trích xuất ra JSON có cấu   │
│ trúc; bước 3 sau này gọi API PMS.                           │
│                                                             │
│ Metric: Thời gian xử lý 40 phút ──> < 10 phút/email;        │
│ trích xuất đúng ≥ 95% số trường.                            │
│                                                             │
│ Quick Architecture: [x] LLM (trích xuất) — Agent để sau     │
└─────────────────────────────────────────────────────────────┘
```

---

# 🗳️ Quyết định lựa chọn

Chọn **Card #1 — VinFast: Phân loại sơ bộ lỗi xe** để Deep-Dive.

**Lý do chọn:**
* Đầu vào là **ngôn ngữ tự do, rất đa dạng** (cùng một lỗi khách tả bằng "kêu cụp cụp", "lục cục", "rung lắc"...). Rule keyword không bao hết được, nên đây đúng là chỗ LLM có lợi thế.
* Có yếu tố **an toàn**: nhân viên mới dễ đánh giá thấp ca nguy hiểm (phanh, pin cao áp). Đây vừa là giá trị lớn, vừa buộc nhóm phải thiết kế ranh giới chặt, đúng trọng tâm của lab.
* HITL dễ chèn vào: CSKH vẫn là người gửi tin, AI chỉ soạn nháp.

**Lý do loại các card khác:**
* **Card #2 (Vinhomes):** Theo nguyên tắc *Problem First, AI Second*, chỉ cần bắt cư dân chọn loại sự cố trong form (dropdown) cộng rule route theo tòa là có thể giải phần lớn bài toán với chi phí thấp hơn nhiều. Nên làm rule trước, đo xem phần văn bản tự do còn lại bao nhiêu rồi mới cân nhắc LLM.
* **Card #3 (Vinpearl):** Phụ thuộc vào quyền truy cập API PMS (chưa chắc có), và nếu báo giá sai thì rủi ro tài chính trực tiếp. Cần gom email mẫu và làm rõ tích hợp trước.

---