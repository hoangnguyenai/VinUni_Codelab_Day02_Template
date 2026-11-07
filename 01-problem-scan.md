# 01. Problem Scan và Quick Problem Cards

**Tên nhóm:** ManchesterUnited  
**Thành viên:** Nguyễn Lâm Hoàng  
**Email:** 26ai.hoangnl@vinuni.edu.vn

> Bài làm theo tình huống giả lập của Lab 02. Chưa khảo sát nhân viên, chưa có log nội bộ. Tất cả thời gian, khối lượng và mục tiêu dưới đây là giả định thiết kế để kiểm chứng, không phải thống kê doanh nghiệp.

## Phase 1. SCAN với 4 lenses

| # | Đơn vị | Lens | Bài toán cụ thể | Cách kiểm chứng |
|---|---|---|---|---|
| 1 | Xanh SM | Tốn thời gian | Điều phối viên tổng hợp báo cáo pin yếu và soạn nháp phương án hỗ trợ tài xế | Đo từng bước trên 30 ca đã ẩn danh |
| 2 | Vinhomes | Lặp lại | Đọc phản ánh cư dân rồi phân loại và chuyển bộ phận xử lý | Gán nhãn kép 100 phản ánh giả lập, sau đó xin dữ liệu thật |
| 3 | Vinpearl | AI-upgrade | Tổng hợp email hỏi phòng đoàn thành danh sách thông tin còn thiếu | So sánh độ đủ thông tin của 50 email mẫu |
| 4 | VinFast | Lặp lại | Đối chiếu số tiền, mã phiên sạc giữa bảng giao dịch và hóa đơn | Thử rule join theo mã phiên trước khi cân nhắc AI |
| 5 | Xanh SM | Stakeholder Pain | Tổng hợp lý do hủy chuyến từ ghi chú khó thống nhất của tài xế | Hai người gán nhãn 100 ghi chú ẩn danh |
| 6 | Vinhomes | Stakeholder Pain | Nhân viên phải đọc nhiều lượt trao đổi mới nắm tình trạng phản ánh chưa giải quyết | Đo thời gian đọc và số thông tin bị bỏ sót |

## Phase 2. Ba Quick Problem Cards

### Card 1. Nháp hỗ trợ sự cố pin cho Xanh SM — lựa chọn deep-dive

- **Actor:** Điều phối viên tiếp nhận ca và tài xế chờ hướng dẫn.
- **Hiện tại (giả định):** Nhận cuộc gọi 2 phút; xác minh pin/GPS 2 phút; kiểm tra phương án trạm hoặc hỗ trợ 5 phút; soạn và kiểm tra tin 5 phút; người có quyền xác nhận phương án và gửi 1 phút. Tổng 15 phút/ca.
- **Bottleneck:** Tìm phương án và viết nháp chiếm 10/15 phút. LLM chỉ hỗ trợ đọc, giải thích và soạn nháp; tra cứu trạm cần nguồn dữ liệu có kiểm chứng.
- **AI hỗ trợ:** Chuyển mô tả tiếng Việt thành đề xuất có cấu trúc; không tự gọi API điều xe hoặc gửi tin.
- **Metric:** Mục tiêu median thời gian từ tiếp nhận tới nháp được duyệt ≤3 phút thay vì giả định 15 phút; 0 ca pin <5% được đề xuất đi tới trạm; 100% đầu ra cần duyệt.
- **Kiến trúc:** Rule cho kiểm tra dữ liệu và ngưỡng pin; LLM feature cho ngôn ngữ. Không dùng agent tự trị.
- **Dữ liệu cần:** Ca ẩn danh, mức pin có thời điểm, GPS, mã trạm, khoảng cách, tình trạng và cổng sạc được xác minh.
- **Rủi ro/fallback:** Dữ liệu sai hoặc không rõ → người điều phối xử lý theo quy trình hiện hành. Chưa chứng minh có dịch vụ sạc di động thực tế; đây là action đề xuất theo đề bài.

### Card 2. Phân loại phản ánh Vinhomes

- **Actor:** Nhân viên tiếp nhận và bộ phận kỹ thuật của tòa nhà.
- **Hiện tại (giả định):** Đọc phản ánh 2 phút; hỏi lại địa điểm 2 phút; phân loại 2 phút; chuyển bộ phận 1 phút. Tổng 7 phút.
- **Bottleneck:** Hiểu nội dung không chuẩn và xác định loại phản ánh, 4 phút/ca.
- **AI hỗ trợ:** Gợi ý nhãn và tóm tắt, người tiếp nhận duyệt; rule chuyển bộ phận dựa trên nhãn và tòa nhà.
- **Metric:** Median ≤3 phút/ca; macro-F1 ≥0,90 trên 100 mẫu được hai người gán nhãn; 100% ca chưa rõ địa điểm phải hỏi lại.
- **Kiến trúc:** LLM feature + rule router; so sánh baseline từ khóa. Không cho AI cam kết thời hạn, thay đổi phí hoặc đóng ticket.
- **Fallback:** Không chắc hoặc ngoài danh mục → hàng chờ người tiếp nhận.

### Card 3. Đối chiếu hóa đơn sạc VinFast

- **Actor:** Nhân viên đối soát kế toán.
- **Hiện tại (giả định):** Xuất hai bảng 5 phút; chuẩn hóa mã phiên 5 phút; đối chiếu 15 phút; lập danh sách lệch 5 phút. Tổng 30 phút/lô 100 dòng.
- **Bottleneck:** Đối chiếu thủ công 15 phút/lô.
- **Giải pháp:** Rule join mã phiên, so sánh số tiền bằng số nguyên VND, phát hiện trùng; chỉ cân nhắc OCR/LLM khi đầu vào phi cấu trúc có nhu cầu được chứng minh.
- **Metric:** Xử lý lô 100 dòng ≤1 phút; phát hiện 100% chênh lệch trên bộ dữ liệu gieo lỗi; không tự sửa chứng từ.
- **Kiến trúc:** Rule, chưa cần LLM/agent.
- **Fallback:** Thiếu mã hoặc nhiều bản ghi trùng → kế toán kiểm tra chứng từ gốc.

## Chọn bài toán

Chọn Card 1 vì phù hợp prototype pin và ranh giới trong slide, cho phép kiểm tra được ngưỡng <5%, định dạng nháp và HITL. Đây là lựa chọn phục vụ lab, chưa phải bằng chứng về ROI cao nhất. Card 2 cần dữ liệu nhãn và xác nhận chủ quy trình. Card 3 nên làm bằng rule trước, tránh chi phí LLM không cần thiết.

**Nguồn:** README.md mục 5–6; 01-worksheet.md Phase 1–2; slide Day 02 trang 4, 15–19. 02-deliverable-example.md chỉ là tham khảo cấu trúc, không dùng số liệu ví dụ như dữ liệu đã khảo sát.
