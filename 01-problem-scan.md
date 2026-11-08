# 01 — Problem Scan & Quick Assess

**Vai trò giả định:** AI Product Engineer, Vin Smart Future. **Phạm vi:** tìm cơ hội tại các đơn vị thành viên và chọn một quy trình đủ hẹp để thử nghiệm. Các thời gian và mục tiêu dưới đây là **giả định lập kế hoạch cho bài lab**, chưa phải dữ liệu được Xanh SM hay đơn vị nào xác nhận.

## Phase 1 — SCAN: 5 điểm nghẽn

| # | Đơn vị | Lens | Bài toán cụ thể | Dữ liệu cần kiểm chứng |
|---|---|---|---|---|
| 1 | Xanh SM | Pain từ người khác; tốn thời gian | Tài xế báo pin dưới 5% trong lúc vận hành; điều phối viên phải đối chiếu vị trí, trạm sạc và phương án hỗ trợ trước khi trả lời. | Số sự cố/ngày, thời gian xử lý, số lần hướng dẫn sai. |
| 2 | Vinhomes | Lặp lại; AI-upgrade | Phản ánh cư dân qua ứng dụng có mô tả tự do, nhân viên phải đọc và chuyển đúng đội phụ trách. | Lượng yêu cầu, tỷ lệ chuyển nhầm, thời gian phân loại. |
| 3 | VinFast | Lặp lại | Nhân viên đối chiếu phiên sạc, hóa đơn và giao dịch thanh toán có mã hoặc số tiền không khớp. | Tỷ lệ không khớp, số phút đối soát mỗi trường hợp. |
| 4 | Vinpearl | Tốn thời gian; AI-upgrade | Nhân viên đọc email đặt phòng đoàn, trích ngày, số phòng và yêu cầu đặc biệt để chuẩn bị báo giá. | Số email/ngày, thời gian trích thông tin, tỷ lệ sửa báo giá. |
| 5 | Xanh SM | Pain từ người khác; lặp lại | Ghi chú tự do của tài xế về điểm đón khó tìm khiến điều phối viên phải hỏi lại và chỉnh điểm đón. | Tỷ lệ đổi điểm đón, thời gian chờ, tỷ lệ hủy chuyến. |

**Ưu tiên sơ bộ:** #1, #2 và #4. #1 có tình huống rõ, ranh giới an toàn đo được và khớp với bản mẫu prompt của lab. Việc chọn này dựa trên độ rõ của bài toán, chưa phải kết luận ROI.

## Phase 2 — QUICK-ASSESS: 3 Problem Cards

### Card 1 — Hỗ trợ tài xế Xanh SM khi pin nguy cấp

| Mục | Nội dung |
|---|---|
| Bài toán | Khi tài xế báo pin dưới 5%, điều phối viên cần đưa ra phương án hỗ trợ an toàn và bản nháp phản hồi nhanh. |
| Actor | Tài xế đang chờ hỗ trợ; điều phối viên chịu trách nhiệm xác minh và duyệt phương án. |
| Quy trình hiện tại | (1) Nhận cuộc gọi/tin nhắn → (2) xác nhận xe, pin, vị trí → (3) tra cứu trạm/đội hỗ trợ → (4) cân nhắc phương án → (5) soạn phản hồi và liên hệ đội hỗ trợ nếu cần. |
| Bước nghẽn | Tra cứu và đối chiếu thông tin ở bước 3–4; **giả định 8 phút/lượt**. |
| AI hỗ trợ | Tóm tắt báo cáo tự do và soạn **bản nháp** đề xuất xe sạc di động nếu pin <5%; điều kiện ngưỡng và khoảng cách do rule kiểm tra. |
| Metric có số | Mục tiêu thử nghiệm: thời gian từ tiếp nhận đến bản nháp được duyệt **15 → ≤8 phút/lượt**; **0** đề xuất đi trạm >5 km khi pin <5%. |
| Quick Architecture | **Rule + LLM feature + human review**. Không dùng agent tự trị. |

### Card 2 — Phân loại phản ánh cư dân Vinhomes

| Mục | Nội dung |
|---|---|
| Bài toán | Tin nhắn cư dân mô tả sự cố bằng ngôn ngữ tự do, cần chuyển đúng đội quản lý tòa nhà. |
| Actor | Nhân viên chăm sóc cư dân và đội kỹ thuật/bảo vệ tiếp nhận. |
| Quy trình hiện tại | (1) Nhận yêu cầu → (2) đọc nội dung → (3) xác định tòa và nhóm sự cố → (4) chuyển bộ phận → (5) sửa tuyến nếu chuyển sai. |
| Bước nghẽn | Đọc và phân loại ở bước 2–3; **giả định 4 phút/yêu cầu**. |
| AI hỗ trợ | Gợi ý nhãn sự cố và tóm tắt; quy tắc cố định chọn tuyến theo tòa, loại sự cố và mức khẩn cấp. |
| Metric có số | Mục tiêu: **≥90%** yêu cầu đúng tuyến ngay lần đầu và giảm thời gian phân loại **4 → ≤2 phút**. |
| Quick Architecture | **Rule + LLM feature**; ca thiếu tòa hoặc có nguy cơ an toàn chuyển người xử lý. |

### Card 3 — Trích thông tin email đặt phòng đoàn Vinpearl

| Mục | Nội dung |
|---|---|
| Bài toán | Email đặt phòng đoàn có nhiều ngày, loại phòng và yêu cầu riêng; nhân viên phải nhập lại để chuẩn bị báo giá. |
| Actor | Nhân viên kinh doanh đặt phòng và người gửi yêu cầu. |
| Quy trình hiện tại | (1) Nhận email → (2) đọc và trích trường → (3) kiểm tra thiếu thông tin → (4) đối chiếu phòng trống → (5) soạn bản nháp báo giá. |
| Bước nghẽn | Trích thông tin và hỏi bổ sung ở bước 2–3; **giả định 10 phút/email**. |
| AI hỗ trợ | Trích ngày, số khách, loại phòng và câu hỏi còn thiếu thành dữ liệu có cấu trúc; nhân viên kiểm tra trước khi báo giá. |
| Metric có số | Mục tiêu: giảm thời gian trích thông tin **10 → ≤4 phút/email**, độ đúng các trường bắt buộc **≥95%**. |
| Quick Architecture | **LLM feature**; hệ thống đặt phòng vẫn là nguồn xác nhận phòng trống/giá. |

## Chọn bài toán để Deep Dive

**Chọn Card 1.** Có ngưỡng quyết định rõ (pin <5%, trạm >5 km), có thể thử bằng prompt đối kháng, và vẫn giữ điều phối viên ở bước duyệt. Card 2 cần biết quy tắc chuyển tuyến từng tòa; Card 3 cần dữ liệu đặt phòng và bảng giá. Cả ba đều cần đo baseline trước khi kết luận hiệu quả.

**Phản biện kiểu CFO/Trưởng vận hành:** (1) Chưa có số sự cố thực nên chưa chứng minh lợi ích kinh tế; (2) pin và vị trí có thể sai hoặc cũ; (3) ngưỡng pin/khoảng cách là logic xác định được, nên rule phải xử lý phần an toàn, không giao cho LLM quyết định. Những điểm này trở thành điều kiện của bản thử nghiệm trong `02-deep-dive-report.md`.
