# 01 — Problem Scan & Quick Problem Cards
## Phase 1 — SCAN: Danh sách cơ hội

| # | Công ty thành viên | Lens | Bài toán / bottleneck vận hành |
|---|---|---|---|
| 1 | VinFast | Lặp lại | Nhân viên tài chính phải đối chiếu giao dịch sạc từ đối tác với hóa đơn, chuẩn hóa các file khác định dạng và tìm giao dịch thiếu hoặc sai lệch. |
| 2 | Xanh SM | Pain từ người khác | Ghi chú của tài xế và nội dung cuộc gọi về chuyến bị hủy không đồng nhất, khiến đội vận hành khó phân loại nguyên nhân và nhận ra vấn đề lặp lại. |
| 3 | Vinhomes | Tốn thời gian | Phản ánh cư dân cần được đọc, phân loại và chuyển đến đúng bộ phận hoặc tòa nhà; phân loại sai có thể làm chậm xử lý. |
| 4 | Vinmec | Tốn thời gian | Bác sĩ cần tổng hợp dữ liệu từ hồ sơ, xét nghiệm và ghi chú để soạn tóm tắt xuất viện; nội dung đầu ra cần bác sĩ kiểm tra kỹ. |
| 5 | Vinpearl | AI có thể tốt hơn | Đánh giá của khách hàng ở nhiều kênh cần được theo dõi để phát hiện phản ánh cần ưu tiên và các vấn đề dịch vụ lặp lại. |

## Phase 2 — QUICK-ASSESS: Ba Quick Problem Cards

### Quick Problem Card #1 — VinFast: Đối soát giao dịch sạc

- **Bài toán:** Đối chiếu giao dịch sạc do đối tác cung cấp với hóa đơn để tìm giao dịch thiếu hoặc sai lệch.
- **Công ty thành viên:** VinFast
- **Ai đang gặp khó khăn (Actor)?** Nhân viên tài chính/kế toán và nhân viên quản lý dữ liệu sạc.
- **Workflow thủ công hiện tại (giả thuyết cần xác minh):**
  1. Nhận file giao dịch sạc và hóa đơn từ đối tác.
  2. Chuẩn hóa mã giao dịch, thời gian, số tiền và thông tin trạm.
  3. So khớp dữ liệu giữa các nguồn.
  4. Đánh dấu dòng thiếu hoặc chênh lệch.
  5. Liên hệ đối tác và cập nhật kết quả xử lý.
- **Bottleneck:** Chuẩn hóa file khác định dạng và tìm giao dịch ngoại lệ. Ước tính minh họa: `3 nhân viên × 1,5 giờ/ngày × 22 ngày = 99 giờ công/tháng`; cần đo lại bằng dữ liệu thực tế.
- **AI/công nghệ có thể hỗ trợ:** Đối sánh chính xác theo quy tắc với các trường có cấu trúc; lập danh sách ngoại lệ để nhân viên xác minh. Chỉ cân nhắc LLM cho bước đọc hoặc chuẩn hóa nội dung không cấu trúc.
- **Metric đề xuất:** Giảm ít nhất 30% thời gian xử lý so với baseline đo được; đồng thời theo dõi tỷ lệ ghép đúng trên mẫu đã xác minh và tỷ lệ bỏ sót/chọn nhầm ngoại lệ.
- **Quick Architecture:** Ưu tiên **Rule-based** cho đối soát; LLM chỉ là hỗ trợ tùy chọn cho dữ liệu phi cấu trúc.
- **Operational boundary:** Không để mô hình tự xác nhận thanh toán, điều chỉnh sổ sách hoặc đóng ngoại lệ. Nhân viên phải duyệt trước mọi thay đổi tài chính.

### Quick Problem Card #2 — Xanh SM: Phân loại lý do khách hủy chuyến

- **Bài toán:** Tổng hợp lý do khách hủy chuyến từ ghi chú tài xế hoặc nội dung cuộc gọi để nhận diện nguyên nhân phổ biến.
- **Công ty thành viên:** Xanh SM
- **Ai đang gặp khó khăn (Actor)?** Nhân viên vận hành/CSKH; gián tiếp là tài xế và khách hàng.
- **Workflow thủ công hiện tại (giả thuyết cần xác minh):**
  1. Nhận ghi chú hoặc nội dung cuộc gọi liên quan đến chuyến bị hủy.
  2. Đọc nội dung và xác định lý do.
  3. Gán lý do vào nhóm thủ công.
  4. Tổng hợp báo cáo theo ngày hoặc tuần.
  5. Chuyển các vấn đề nổi bật đến bộ phận phụ trách.
- **Bottleneck:** Nội dung ghi chú không thống nhất, có thể thiếu ngữ cảnh hoặc chứa nhiều lý do. Ước tính minh họa: `150 ghi chú/ngày × 2 phút × 22 ngày = 110 giờ công/tháng`; số lượng và thời gian cần được xác minh.
- **AI/công nghệ có thể hỗ trợ:** LLM đề xuất nhãn lý do và tóm tắt xu hướng; nhân viên xem lại trường hợp mơ hồ hoặc không đủ thông tin.
- **Metric đề xuất:** Đạt ít nhất 85% độ chính xác trên tập kiểm thử được gán nhãn bởi người phụ trách; đo thêm chất lượng theo từng nhóm lý do, tỷ lệ “không đủ thông tin” và thời gian tổng hợp báo cáo.
- **Quick Architecture:** **LLM Feature** nếu ghi chú đa dạng và cần hiểu ngữ cảnh; so sánh với bộ quy tắc đơn giản làm baseline trước khi chọn.
- **Operational boundary:** Không suy đoán nguyên nhân khi dữ liệu không đủ; kết quả là gợi ý phân tích, không tự động quy trách nhiệm cho khách hàng hoặc tài xế. Chỉ sử dụng dữ liệu cuộc gọi theo quyền truy cập và quy định riêng tư phù hợp.

### Quick Problem Card #3 — Vinpearl: Phát hiện phản ánh cần ưu tiên trong đánh giá khách hàng

- **Bài toán:** Theo dõi đánh giá khách hàng từ các kênh được phép sử dụng để nhận ra phản ánh cần ưu tiên và vấn đề lặp lại.
- **Công ty thành viên:** Vinpearl
- **Ai đang gặp khó khăn (Actor)?** Quản lý khách sạn, CSKH và nhân viên phụ trách chất lượng dịch vụ.
- **Workflow thủ công hiện tại (giả thuyết cần xác minh):**
  1. Thu thập đánh giá từ các kênh.
  2. Đọc từng đánh giá và xác định nội dung phản ánh.
  3. Phân loại theo chủ đề, địa điểm hoặc mức độ.
  4. Chuyển phản ánh đến bộ phận liên quan.
  5. Tổng hợp xu hướng và theo dõi phản hồi.
- **Bottleneck:** Nhiều đánh giá với cách diễn đạt khác nhau làm chậm việc đọc, phân loại và phát hiện vấn đề lặp lại. Ước tính minh họa: `60 đánh giá/ngày × 2,5 phút × 30 ngày = 75 giờ công/tháng`; cần xác minh khối lượng, thời gian và ngày vận hành.
- **AI/công nghệ có thể hỗ trợ:** LLM phân loại chủ đề, tóm tắt phản ánh lặp lại và đề xuất mức ưu tiên/bộ phận xử lý; nhân viên xác nhận trước khi chuyển.
- **Metric đề xuất:** Đạt ít nhất 90% recall cho nhóm phản ánh được quản lý xác định là cần ưu tiên; đồng thời đo precision, số cảnh báo sai và thời gian từ lúc nhận phản ánh đến lúc được xem xét.
- **Quick Architecture:** **LLM Feature** cho phân loại/tóm tắt ngôn ngữ tự nhiên, kết hợp quy tắc rõ ràng để áp dụng tiêu chí ưu tiên đã được phê duyệt.
- **Operational boundary:** AI chỉ đề xuất nhãn, mức ưu tiên và bản tóm tắt; nhân viên xác nhận trước khi chuyển hoặc phản hồi khách. Không coi nội dung đánh giá là sự việc đã được xác minh.
