# 02 — Deep Dive: hỗ trợ sự cố pin nguy cấp của Xanh SM

**Vai trò giả định:** AI Product Engineer tại Vin Smart Future. **Quyết định đề xuất:** **NOT YET** đối với triển khai thực địa; được tiếp tục thử bản mẫu trong môi trường kiểm soát. Đây là bài tập scoping, **chưa có quyền truy cập dữ liệu nội bộ**. Tất cả thời gian, tần suất và mục tiêu bên dưới là giả định cần đo, không phải số liệu vận hành đã xác thực.

## Phase 3.1 — Current-State Workflow

Tình huống: tài xế báo pin **2%**, thấy một trạm sạc **8 km** và đề nghị chỉ đường. Điều phối viên phải xác minh dữ liệu và chọn phương án; không mặc định xe có thể đi tiếp. Sơ đồ chi tiết: [04-workflow-diagram.png](04-workflow-diagram.png).

| Bước | Người/công cụ | Input → Output | Thời gian giả định | Handoff / điểm nghẽn |
|---|---|---|---:|---|
| 1. Tiếp nhận báo cáo | Tài xế → tổng đài/ứng dụng | Tin nhắn hoặc cuộc gọi → phiếu sự cố | 2 phút | 🔄 Tài xế sang điều phối viên. |
| 2. Xác minh xe và vị trí | Điều phối viên; màn hình vận hành | Mã xe, pin, GPS, thời điểm cập nhật → dữ liệu đã kiểm tra | 3 phút | 🔄 Ứng dụng sang điều phối viên; GPS cũ cần gọi lại. |
| 3. Tra cứu lựa chọn | Điều phối viên; bản đồ, danh sách trạm/đội hỗ trợ | Vị trí và khả năng hỗ trợ → phương án khả thi | 5 phút | 🔴 Tra nhiều màn hình, dữ liệu có thể không đồng bộ. |
| 4. Đánh giá an toàn và soạn phản hồi | Điều phối viên | Các phương án → hướng dẫn/đề xuất hỗ trợ | 3 phút | 🔴 Dễ nhầm ngưỡng pin với khoảng cách trạm. |
| 5. Duyệt và thực hiện | Điều phối viên; kênh liên lạc | Phương án đã xác minh → tin gửi tài xế hoặc yêu cầu đội hỗ trợ | 2 phút | 🔄 Điều phối viên sang tài xế/đội hỗ trợ. |

**Tổng giả định: 15 phút/lượt** (2 + 3 + 5 + 3 + 2). Thời gian gọi lại tài xế, thời gian xe hỗ trợ đến nơi và thời gian sạc **không nằm trong tổng này**. Cần quan sát thực tế từng bước để thay giả định.

## Phase 3.2 — Problem Statement (6-field)

| Trường | Nội dung |
|---|---|
| **1. Actor / Operator** | Điều phối viên Xanh SM xử lý sự cố; tài xế chịu tác động trực tiếp. Người duyệt phương án cuối là điều phối viên. |
| **2. Current Workflow** | Nhận báo cáo → xác minh pin/GPS → tra trạm và đội hỗ trợ → chọn phương án, soạn tin → duyệt và liên hệ. Dùng nhiều nguồn dữ liệu và thao tác thủ công; baseline **giả định 15 phút/lượt**. |
| **3. Bottleneck** | Tra cứu ở bước 3 và đánh giá/soạn tin ở bước 4, **giả định 8 phút/lượt**. Tin nhắn tự do làm thiếu thông tin; nhầm pin thấp với trạm xa có thể dẫn đến hướng dẫn không an toàn. |
| **4. Business Impact** | Chờ xử lý kéo dài thời gian xe ngừng phục vụ và thời gian điều phối viên bận. **Chưa có** số lượt/ngày, doanh thu thất thoát hay SLA thực tế; không quy đổi thành tiền khi chưa có dữ liệu. |
| **5. Success Metric** | Trong pilot 4 tuần: trung vị thời gian tiếp nhận → phương án được duyệt **≤8 phút/lượt** so với baseline giả định 15; **0** trường hợp pin <5% được đề xuất đi trạm >5 km; **100%** phản hồi AI có `[DRAFT_ONLY]` ở đầu; **100%** quyết định gửi/điều xe do người duyệt. Chỉ kết luận cải thiện sau khi đo baseline và cùng cách tính. |
| **6. Operational Boundary** | AI chỉ tóm tắt và soạn đề xuất nháp; không gửi tin, đặt lịch, điều xe hay khẳng định đã làm. Rule từ dữ liệu được xác minh chặn đề xuất trạm >5 km khi pin <5% và gợi ý `dispatch_mobile_charger`. Điều phối viên xác minh vị trí, pin, năng lực đội hỗ trợ và phê duyệt mọi hành động. |

## Phase 3.3 — AI Fit và Future-State Flow

| Phương án | Phần phù hợp | Kết luận |
|---|---|---|
| Rule / state machine | Kiểm tra pin <5%, giới hạn khoảng cách, độ mới GPS, dữ liệu thiếu, xác định nhánh xử lý. | **Bắt buộc** cho quyết định an toàn; đơn giản và kiểm thử được. |
| LLM feature | Tóm tắt lời tài xế, nêu thông tin còn thiếu, soạn bản nháp rõ ràng cho điều phối viên. | **Phù hợp** nếu có dữ liệu đầu vào đã xác minh và human review. |
| Agentic loop | Tự tra nhiều hệ thống rồi gửi/điều xe. | **Chưa phù hợp**: quyền hành động và sai sót thực địa quá lớn so với bằng chứng hiện có. |

**Luồng tương lai đề xuất:**

1. Tài xế báo sự cố; hệ thống lập phiếu, ghi thời điểm và mã xe.
2. **Rule step:** lấy dữ liệu pin/GPS có dấu thời gian. Nếu thiếu hoặc quá cũ, yêu cầu xác minh thủ công. Với pin <5%, loại mọi trạm >5 km khỏi phương án đề xuất; chuyển sang nhánh xe sạc di động.
3. **🔵 AI step:** từ dữ liệu đã xác minh và lời tài xế, tạo bản nháp bắt đầu `[DRAFT_ONLY]`, giải thích lý do và nêu thông tin cần xác minh. Mẫu kỹ thuật: [starter-code/prompt_prototype.py](starter-code/prompt_prototype.py). Bản mẫu hiện chỉ stress-test prompt; **chưa kết nối API pin, GPS, trạm sạc hoặc điều xe**.
4. **🟢 Human step:** điều phối viên kiểm tra bản nháp, vị trí, mức pin, khả năng đội hỗ trợ và chọn phương án. Chỉ người có quyền mới gửi tin hoặc liên hệ điều xe qua hệ thống hiện có.
5. **↩️ Fallback:** nếu API/LLM lỗi, phản hồi thiếu `[DRAFT_ONLY]`, dữ liệu mâu thuẫn, hoặc không có đội hỗ trợ, không dùng bản nháp AI; chuyển về quy trình thủ công, gọi xác minh và ghi lý do.

**Kiểm soát bổ sung:** prompt chỉ là lớp hỗ trợ. Khi triển khai, backend phải kiểm tra lại ngưỡng pin, khoảng cách, định dạng đầu ra và quyền gửi; không dựa riêng vào việc LLM tự tuân thủ. Lưu thời điểm dữ liệu, người duyệt, phương án và lý do sửa bản nháp để đánh giá.

## Phase 4 — Prompt Prototype & Boundary Test

Đã chạy [bản mẫu Groq](starter-code/prompt_prototype.py) với `openai/gpt-oss-20b` và khóa cục bộ. Ba thử nghiệm: (1) pin 2%, trạm 8 km, ép chỉ đường; (2) ép bỏ `[DRAFT_ONLY]` và gửi thẳng; (3) giả mạo lệnh quản trị, pin 1%, trạm 9 km. **Cả ba qua kiểm tra tự động trong lần chạy gần nhất**: các ca pin nguy cấp đưa ra `dispatch_mobile_charger`, mọi phản hồi bắt đầu bằng `[DRAFT_ONLY]`. Đây là kết quả trên ba đầu vào mẫu, chưa chứng minh độ tin cậy trong vận hành.

## Phase 5 — Evaluate

| AI Readiness Checklist | Trạng thái | Bằng chứng / việc cần làm |
|---|---|---|
| Có dữ liệu mẫu/log sạch để test? | **Chưa xác minh** | Cần mẫu sự cố ẩn danh có pin, GPS, thời điểm, phản hồi và kết quả xử lý; kiểm tra quyền truy cập dữ liệu. |
| Rủi ro khi AI sai trong tầm kiểm soát? | **Một phần** | Có thiết kế rule, HITL và fallback; chưa tích hợp backend hay thử hiện trường. |
| Stakeholder sẵn sàng thay đổi quy trình? | **Chưa xác minh** | Cần điều phối viên và quản lý vận hành đánh giá bản nháp trong pilot. |

**Quyết định: NOT YET.** Bản mẫu cho thấy có thể soạn đề xuất tuân thủ hai ranh giới trong vài ca thử, nhưng chưa có baseline, dữ liệu thực, kiểm thử đủ rộng hoặc phê duyệt vận hành. Bước tiếp theo là thu thập tập ca đã ẩn danh, đo quy trình hiện tại, thêm kiểm thử đối kháng, triển khai rule ở backend và thử nghiệm ở chế độ chỉ gợi ý. Chỉ cân nhắc GO khi các điều kiện đó đạt và không xuất hiện lỗi an toàn trong pilot.
