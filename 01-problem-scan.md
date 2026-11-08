# LAB 02 – AI PRODUCT SCOPING (VIN SMART FUTURE)
## 01. Problem Scan & Quick Problem Cards

**Học viên:** Lê Hoàng Quân  
**Vai trò:** Thành viên nhóm  
**Chủ đề Deep Dive cá nhân:** Xanh SM – AI hỗ trợ phát hiện và phân tích bất thường vận hành đội xe điện.

> **Lưu ý về bằng chứng:** Các vấn đề dưới đây là *giả thuyết cơ hội sản phẩm* để thực hành scoping. Quy trình, thời lượng và KPI đều là giả định/đích thử nghiệm, không phải số liệu nội bộ đã được Vingroup hoặc các công ty thành viên xác nhận. Cần khảo sát người sử dụng và đo baseline trước khi lập business case triển khai.

---

## PHASE 1 – SCAN: 5 cơ hội ứng dụng AI

Quét theo 4 lenses của worksheet: **Repetitive**, **Time-consuming**, **AI-upgrade** và **Stakeholder Pain**.

| # | Công ty thành viên | Lens | Bài toán và điểm nghẽn cần xác minh |
|---|---|---|---|
| 1 | **Xanh SM** | Time-consuming; Stakeholder Pain | Nhân viên phải đối chiếu thủ công lịch sử hành trình, pin và log để giải thích cảnh báo bất thường đội xe; việc phân loại ưu tiên có thể chậm và thiếu nhất quán. |
| 2 | **VinFast** | AI-upgrade; Stakeholder Pain | Khách hàng mô tả cảnh báo/sự cố pin bằng ngôn ngữ tự nhiên; nhân viên hỗ trợ cần phân loại tình huống, thu thập thông tin còn thiếu và chuyển đúng tuyến xử lý. |
| 3 | **Vinhomes** | Repetitive; Time-consuming | Nhân viên rà soát hồ sơ pháp lý dự án và các phụ lục theo checklist, đối chiếu ngày hiệu lực, tên dự án và tài liệu thiếu; việc tra cứu thủ công có thể tốn thời gian. |
| 4 | **Vinmec** | Time-consuming | Tổng hợp dữ liệu từ các trường hồ sơ khám chữa bệnh thành bản tóm tắt nháp cho bác sĩ kiểm tra, không để AI đưa ra quyết định điều trị. |
| 5 | **Vinpearl/VinWonders** | AI-upgrade; Stakeholder Pain | Phân loại nội dung phản hồi đa kênh theo chủ đề, mức độ khẩn cấp và chuyển đúng bộ phận; soạn bản nháp phản hồi để nhân viên duyệt. |

**Cách lựa chọn top 3:** Ưu tiên (i) actor và workflow xác định được, (ii) bottleneck có thể đo, (iii) AI bổ sung giá trị so với rule thuần túy, (iv) có thể đặt ranh giới và human-in-the-loop rõ ràng. Chọn **Xanh SM, VinFast, Vinhomes** để viết Quick Cards.

---

## PHASE 2 – QUICK-ASSESS: 3 QUICK PROBLEM CARDS

### QUICK PROBLEM CARD #1 — Xanh SM: Phát hiện bất thường vận hành đội xe

| Trường | Nội dung |
|---|---|
| **Bài toán (1 câu)** | Hỗ trợ nhân viên giám sát phát hiện, ưu tiên và giải thích sơ bộ cảnh báo bất thường từ dữ liệu đội xe điện. |
| **Công ty** | Xanh SM (GSM) |
| **Actor** | Nhân viên giám sát vận hành; điều phối/kỹ thuật xác minh; trưởng ca duyệt các hành động tác động vận hành. |
| **Current workflow (5 bước)** | (1) Nhận dữ liệu/log → (2) tổng hợp, lọc cảnh báo → (3) đối chiếu hành trình, pin và ngữ cảnh → (4) chuyển điều phối/kỹ thuật xác minh → (5) ghi nhận và phê duyệt xử lý. |
| **Bottleneck** | Bước 3 đối chiếu nhiều nguồn thủ công: **9 phút/trường hợp** trong kịch bản mẫu; tổng quy trình **22 phút/trường hợp**. |
| **AI Step** | Sau bước lọc rule, LLM tóm tắt bằng chứng, gợi ý lý do và câu hỏi cần kiểm tra; không tự kết luận vi phạm hay điều xe. |
| **Success metric có số** | POC mục tiêu giảm **median thời gian rà soát từ 22 xuống ≤10 phút/trường hợp**; precision cho ưu tiên cao ≥85% trên tập test có nhãn; 100% quyết định vận hành cần người duyệt. |
| **Quick Architecture** | **Hybrid Rule + LLM + Human-in-the-loop** (không cần Agentic Loop ở giai đoạn đầu). |
| **Ranh giới/Fallback** | AI chỉ đưa đề xuất có chứng cứ; thiếu dữ liệu/API lỗi → chuyển xử lý thủ công; các cảnh báo khẩn cấp đi thẳng theo SOP. |

**Quick assessment:** Phù hợp để phân tích chuyên sâu vì khả năng xây dựng KPI và ranh giới quản trị rủi ro rõ. Tuy nhiên thiếu baseline/dữ liệu xác thực nên quyết định ở báo cáo Deep Dive là **NOT YET cho vận hành thật**, có thể thử POC offline.

### QUICK PROBLEM CARD #2 — VinFast: Phân loại sơ bộ cảnh báo pin và sự cố xe điện

| Trường | Nội dung |
|---|---|
| **Bài toán (1 câu)** | Hỗ trợ nhân viên dịch vụ phân loại ban đầu các yêu cầu về pin/cảnh báo kỹ thuật từ mô tả tự do của khách hàng và thu thập thông tin cần thiết trước khi chuyển tuyến. |
| **Công ty** | VinFast |
| **Actor** | Nhân viên chăm sóc khách hàng/tiếp nhận dịch vụ, nhân sự kỹ thuật được phân quyền; khách hàng là người chịu tác động. |
| **Current workflow (5 bước)** | (1) Khách mô tả hiện tượng → (2) nhân viên ghi lại và hỏi thông tin xe/cảnh báo → (3) tra hướng dẫn/SOP → (4) phân loại khẩn cấp và chuyển kỹ thuật → (5) phản hồi, ghi ticket. |
| **Bottleneck** | Phân loại yêu cầu khi mô tả không rõ và nhiều cách diễn đạt; giả định **8–12 phút/ticket** để tiếp nhận, làm rõ và chuyển tuyến. |
| **AI Step** | LLM trích xuất triệu chứng, đặt câu hỏi còn thiếu, ánh xạ vào nhóm tình huống theo taxonomy đã phê duyệt và tạo **bản nháp ticket**; rule chặn các tình huống an toàn khẩn cấp. |
| **Success metric có số** | POC mục tiêu giảm **median thời gian phân loại từ 10 xuống ≤4 phút/ticket**; ≥90% ticket có đủ trường bắt buộc; recall nhóm sự cố mức khẩn cấp ≥95% trên tập test được chuyên gia gán nhãn. |
| **Quick Architecture** | **Rule + LLM Feature + Human-in-the-loop**; không cho Agent tự điều khiển xe hoặc xác nhận an toàn kỹ thuật. |
| **Ranh giới/Fallback** | Không chẩn đoán xác định, không hướng dẫn thao tác nguy hiểm trên pin cao áp; thiếu bằng chứng → chuyển kỹ thuật; trường hợp có dấu hiệu an toàn nghiêm trọng → kích hoạt SOP của đơn vị. |

**Stress-test câu hỏi:** Liệu rule-only có đủ? Với cảnh báo mã hóa chuẩn, **rule** có thể tốt hơn và ổn định hơn; LLM chỉ bổ sung giá trị cho mô tả tiếng Việt tự do, câu hỏi thiếu dữ liệu và tóm tắt ticket. Cần A/B test Rule-only so với Hybrid trước khi kết luận.

### QUICK PROBLEM CARD #3 — Vinhomes: Rà soát checklist hồ sơ pháp lý dự án

| Trường | Nội dung |
|---|---|
| **Bài toán (1 câu)** | Hỗ trợ nhân viên dự án tìm tài liệu còn thiếu, trích dẫn điều khoản và phát hiện mâu thuẫn sơ bộ giữa các hồ sơ pháp lý theo checklist đã cấu hình. |
| **Công ty** | Vinhomes |
| **Actor** | Chuyên viên pháp chế/quản lý dự án và bộ phận thẩm định; quản lý có thẩm quyền phê duyệt kết luận. |
| **Current workflow (5 bước)** | (1) Tiếp nhận danh mục tài liệu → (2) kiểm tra định dạng/phiên bản → (3) đọc và đối chiếu nội dung với checklist → (4) lập danh sách thiếu/mâu thuẫn → (5) pháp chế thẩm tra và xác nhận kết quả. |
| **Bottleneck** | Tra cứu chéo văn bản, điều khoản, ngày hiệu lực, tên chủ thể và phiên bản phụ lục; giả định **90 phút/bộ hồ sơ** ở bước rà soát sơ bộ. |
| **AI Step** | OCR + trích xuất thông tin; rule kiểm tra trường bắt buộc; LLM/RAG tìm đoạn liên quan và tạo bảng đối chiếu có trang/điều khoản nguồn để chuyên viên xem lại. |
| **Success metric có số** | POC mục tiêu giảm **median thời gian rà soát sơ bộ từ 90 xuống ≤45 phút/bộ**; recall phát hiện tài liệu thiếu ≥95%; ≥95% nhận định AI có trích dẫn kiểm tra được trên bộ dữ liệu thử nghiệm. |
| **Quick Architecture** | **OCR + Rule + LLM/RAG + Human-in-the-loop**; Agentic Loop không cần thiết trong POC. |
| **Ranh giới/Fallback** | Không kết luận dự án đủ điều kiện pháp lý hay thay ý kiến tư vấn pháp luật; không tự sửa hồ sơ gốc; tài liệu mờ/không đủ → gắn cờ kiểm tra thủ công. |

**Stress-test câu hỏi:** Nếu hồ sơ đã ở dạng biểu mẫu có cấu trúc, checklist bằng rule có thể rẻ và đáng tin cậy hơn; LLM/RAG chỉ cần cho phần tài liệu dài, cấu trúc không đồng nhất hoặc tìm chứng cứ ngữ nghĩa. Dữ liệu pháp lý phải phân quyền và bảo vệ bí mật nội bộ.

---

## KẾT LUẬN LỰA CHỌN

**Chọn Card #1 (Xanh SM)** làm đề tài `02-deep-dive-report.md` vì gắn với năng lực phân tích vận hành và quản trị rủi ro, có thể mô tả workflow 5 bước, handoff, bottleneck và KPI đo được. Hai Card còn lại là phương án dự phòng/so sánh; chưa đủ dữ liệu thực tế để khẳng định tính khả thi triển khai.

**Tính nhất quán với sản phẩm khác:**

- `02-deep-dive-report.md`: Deep Dive về phát hiện/phân tích bất thường Xanh SM, 22 → ≤10 phút và quyết định NOT YET cho vận hành thực tế.
- `04-workflow-diagram.png`: Current-state 5 bước, tổng 22 phút (giả định), bottleneck 9 phút.
- `starter-code/prompt_prototype.py`: Kiểm thử ranh giới an toàn trên tình huống pin khẩn cấp của Xanh SM theo template giảng viên; đây là **sub-case minh họa**, không đồng nghĩa đã triển khai toàn bộ hệ thống phát hiện bất thường.

**Bước xác minh tiếp theo:** Phỏng vấn owner nghiệp vụ, thu log được cấp phép/ẩn danh, đo baseline, xây dựng nhãn kiểm thử và so sánh Rule-only với Hybrid Rule + LLM.
