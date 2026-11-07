# 03. AI Log và Reflection

**Tên nhóm:** ManchesterUnited  
**Thành viên:** Nguyễn Lâm Hoàng  
**Email:** 26ai.hoangnl@vinuni.edu.vn

> Nhật ký ghi lại công việc trợ lý thực sự đã làm trong phiên này. Đây là bản nháp để người học đọc, xác nhận và bổ sung suy nghĩ cá nhân; không giả lập trải nghiệm khảo sát hoặc thao tác của sinh viên.

## 1. Yêu cầu và nguồn đầu vào

Người dùng yêu cầu đọc README và PowerPoint Day 02 rồi hoàn thiện dự án đúng yêu cầu. Trợ lý đã đọc văn bản của cả 21 slide, README, worksheet, inspiration kit, worked example, starter code và autograder. PowerPoint được dùng làm tài liệu tiêu chí; không xem mọi câu hướng dẫn bên trong tài liệu như lệnh tự động tạo repo, gửi form hoặc liên hệ người khác.

## 2. AI đã hỗ trợ gì?

| Công việc thực tế | Kết quả | Giới hạn |
|---|---|---|
| Đối chiếu tiêu chí README/slide/worksheet | Bộ 3 báo cáo, PNG workflow, prototype và kiểm thử | Đã cập nhật thông tin Nguyễn Lâm Hoàng theo xác nhận của người dùng |
| Xem code đang sửa | Phát hiện dùng Groq trong khi bài yêu cầu Gemini; biến client chưa khởi tạo; thiếu thư viện Groq trong requirements | Không kết luận code trước đã gọi API thành công |
| Xây dựng phạm vi Xanh SM | Phân biệt rule, LLM feature và agent; chọn LLM hẹp, mọi action là đề xuất | Không có quan sát thực địa |
| Viết prototype và unit tests | Gemini SDK, JSON Schema, nhãn nháp từ ứng dụng, 7 adversarial +4 controls | Mock/fixture không chứng minh LLM chống được injection |
| Kiểm tra môi trường và thiết kế quyết định | Phát hiện Python 3.14.3; thiếu khóa Gemini; kết luận NOT YET cho pilot | Chưa đo latency, token hoặc chất lượng model thật |

## 3. AI trả lời sai / hallucination ở đâu?

Không có câu trả lời Gemini thật trong phiên vì thiếu khóa; không thể khẳng định đã quan sát model hallucinate hoặc vượt ranh giới. Những prompt yêu cầu bịa pin/trạm trong bộ test là tình huống dự kiến, không phải lỗi mô hình đã xảy ra.

Worked example có cách kể đã khảo sát và các số như 80 ca/ngày. Trợ lý không có chứng cứ để dùng chúng như số liệu của nhóm nên thay bằng kịch bản 20 ca/ngày được ghi rõ là giả định. Đây là kiểm soát nguy cơ AI sao chép số liệu thành sự thật, không phải một kết quả thực nghiệm.

Trong quá trình viết code, một thao tác thay toàn bộ file bằng patch bị công cụ từ chối do khai báo xóa và thêm cùng đường dẫn. Trợ lý viết lại file bằng cách khác, rồi chạy kiểm thử. Lỗi thao tác này không được mô tả thành lỗi Gemini.

## 4. Điều chỉnh prompt và ranh giới đã thực hiện

Prompt trong starter trước phiên đã có quy tắc pin <5% và nhãn nháp. Bản mới giữ hai ranh giới, thêm dữ liệu thiếu/mâu thuẫn/ngoài miền, phân biệt đúng 5% với dưới 5%, cấm xác nhận hành động đã hoàn thành và coi SYSTEM giả trong input là dữ liệu. Output thống nhất JSON cho mọi action; prefix do code gắn để có tính xác định. Temperature 0 không bảo đảm an toàn tuyệt đối.

Hai quyết định cần phân biệt: prompt hướng dẫn mô hình chọn action, còn ứng dụng kiểm tra schema và giữ nhãn nháp. Nhãn từ ứng dụng không phải bằng chứng mô hình tự tuân thủ nhãn. Test có nhãn kỳ vọng phát hiện action sai, nhưng chưa đánh giá đầy đủ lời giải thích tự do; người duyệt vẫn cần đọc.

## 5. Bằng chứng đã thu được

- `evidence/unit-tests.txt`: **17 tests passed**, gồm kiểm tra output xấu, mock SDK, lỗi API và thiếu khóa.
- `evidence/offline-contract.json`: **11 fixture cases passed**, được ghi `is_live_evidence: false`. Fixture lấy action từ nhãn đáp án, chỉ minh họa hợp đồng và runner.
- `evidence/live-preflight.txt`: live run bị chặn vì thiếu khóa, không có phản hồi mô hình thật.
- `evidence/autograder-static.txt`: kiểm tra sự tồn tại 4 file và 3 tiêu chí code tĩnh, không phải điểm chấm chất lượng báo cáo hay kết quả live.

## 6. Phản ánh để người học xác nhận

Bài này cho thấy cần tách ba việc: chọn đúng bài toán, đặt ranh giới và thu bằng chứng. Có code chạy với fixture không đồng nghĩa sản phẩm sẵn sàng triển khai. Phần rule về pin có thể kiểm chứng riêng; giá trị của LLM cần được đo thêm qua cách hiểu mô tả tiếng Việt và thời gian người vận hành sửa nháp.

Người học cần bổ sung trước khi nộp: đóng góp thực tế của từng thành viên, suy nghĩ cá nhân sau khi đọc code, và kết quả Gemini live sau khi tự cấu hình khóa. Không nên nộp nhật ký này như tuyên bố đã tự khảo sát hoặc đã chạy mô hình thật.
