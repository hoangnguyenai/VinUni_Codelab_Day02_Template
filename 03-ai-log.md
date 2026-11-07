# 03 — AI Log (Nhật ký làm việc với AI)

Tôi dùng Claude làm người đồng hành trong cả buổi lab. Nhật ký này ghi lại AI đã giúp gì, AI sai ở đâu, và tôi đã sửa cách làm như thế nào.

---

## 1. AI đã giúp tôi những gì?

- **Đọc và tóm tắt tài liệu:** AI đọc bộ file hướng dẫn của bài lab và cho tôi biết công việc cần làm, các file phải nộp, cách chấm điểm.
- **Hướng dẫn chuẩn bị máy:** tạo môi trường ảo, cài thư viện, đặt khóa Gemini, chạy thử mã khởi đầu.
- **Gợi ý bài toán:** AI đề xuất 5 bài toán ở Xanh SM, Vinhomes, Vinmec, VinFast, trải trên nhiều góc nhìn khác nhau.
- **Soạn 3 thẻ bài toán** (Xanh SM, Vinhomes, Vinmec) theo mẫu của giảng viên.
- **Đóng vai người phản biện khó tính** để chỉ ra điểm yếu của từng thẻ. Tôi đưa phần phản biện vào `01-problem-scan.md` và AI cũng tạo giúp một tài liệu riêng để lưu lại.
- **Viết code** cho `prompt_prototype.py`: bộ luật `SYSTEM_PROMPT`, hàm `evaluate_prompt()` gọi Gemini, và thêm test thứ 3 (đề bài yêu cầu ít nhất 3 test, mã gốc chỉ có 2).
- **Giải thích code:** vì sao cần hàm `evaluate_prompt()` và nó nằm ở đâu trong luồng chạy.
- **Gỡ rối Git:** khi tôi lỡ commit lên nhánh `main`, AI hướng dẫn chuyển commit sang nhánh riêng và đưa `main` về như cũ, cũng như cách tạo nhánh bằng giao diện VS Code.

## 2. AI đã sai hoặc làm chưa đúng ở đâu?

**a) Số liệu trong thẻ là ước lượng, không phải số đo thật.**
Các con số (15 phút mỗi sự cố, 80 sự cố mỗi ngày, 12 giờ phản hồi, 20 đến 30 phút mỗi bệnh nhân) được AI lấy từ tài liệu mẫu và ước tính. Nếu nộp mà không ghi chú thì dễ bị hiểu là số liệu thực tế. Tôi đã ghi rõ là "ước tính" trong file.

**b) Bản đầu của 3 thẻ có lỗ hổng.**
Khi AI tự phản biện, nó chỉ ra những chỗ chính nó đã bỏ sót lúc soạn: thời gian các bước cộng lại không khớp tổng, chưa có nhóm tin khẩn ở thẻ Vinhomes, và chỉ tiêu "bác sĩ sửa dưới 10%" ở thẻ Vinmec chưa đủ vì một lỗi về liều thuốc vẫn nguy hiểm.

**c) Code dùng tên model đã cũ.**
Lần đầu chạy `prompt_prototype.py`, cả 3 test đều báo lỗi 404 vì `gemini-2.5-flash` không còn mở cho tài khoản mới. Mã khởi đầu của giảng viên và bản AI viết đều dùng tên cũ. AI cũng không có cách chạy thử với Gemini thật, nó chỉ kiểm tra được cú pháp, nên lỗi này chỉ lộ ra khi tôi tự chạy trên máy mình. Khi tra tên model mới, các trang tài liệu cho kết quả không thống nhất (có nơi ghi bản 3.6, có nơi 3.7, trang chính thức ghi 3.8), nên tôi dùng tên mà thông báo lỗi của Google gợi ý.

**d) Mô hình không làm đúng như `SYSTEM_PROMPT` yêu cầu ở lần chạy đầu.**
Dù prompt yêu cầu rõ, kết quả lần chạy đầu cho thấy:
- Test 1: trả lời rất dài, **không có JSON** `dispatch_mobile_charger`.
- Test 2: thẻ `[DRAFT_ONLY]` có xuất hiện nhưng nằm **sau** một đoạn dẫn, không ở đầu câu như luật 1.
- Test 3: dòng kiểm tra kết quả bị trống, và nếu có kiểm tra thì câu trả lời cũng không có JSON.

**e) Bộ kiểm tra gốc quá dễ dãi.**
Test 1 và 2 báo "Passed" dù hai lỗi trên vẫn còn, vì điều kiện kiểm tra chấp nhận cả chữ "cứu hộ" và chỉ cần thẻ xuất hiện ở đâu đó trong câu. Nếu tin vào dòng "Passed" thì tôi đã bỏ sót lỗi thật.

**f) Bản code đầu của AI chưa khớp với chính nó.**
Dòng tiêu đề in ra vẫn ghi "Gemini 2.5 Flash" trong khi tên model đã đổi, và bộ kiểm tra test 3 AI viết lúc đầu sẽ báo "Failed" với kiểu trả lời mà mô hình đưa ra. Phải có kết quả chạy thật thì những chỗ này mới lộ.

## 3. Tôi đã sửa lại cách hỏi và ranh giới như thế nào?

- **Đổi tên model** sang `gemini-3.8-flash` theo gợi ý trong thông báo lỗi của Google, rồi đối chiếu lại với trang tài liệu của Gemini API.
- **Siết `SYSTEM_PROMPT`:**
  - Thêm một **ví dụ đúng** (hai dòng gồm thẻ và JSON), vì chỉ nêu luật chưa đủ để mô hình làm theo.
  - Cấm viết lời dẫn hay tiêu đề trước thẻ.
  - Khi pin dưới 5%, chỉ cho phép đúng hai dòng là thẻ và JSON, lời giải thích đưa vào trường `reason` của JSON.
- **Siết bộ kiểm tra:** test 2 giờ yêu cầu thẻ phải nằm ở **đầu câu**, và test 3 yêu cầu đủ cả thẻ lẫn JSON điều xe sạc.
- **Chạy lại và đối chiếu:** sau khi sửa, cả 3 test đều báo "Passed", và câu trả lời gọn đúng định dạng, không còn đoạn dẫn dài.
- **Ghi chú số liệu** trong thẻ là ước tính, và đưa phần phản biện vào bài scan.

## 4. Những giới hạn tôi còn thấy

- Ba test chỉ là các tình huống tôi và AI tự nghĩ ra. Qua được chúng **chưa có nghĩa** prompt an toàn trước mọi kiểu tấn công.
- Mô hình ngôn ngữ không đảm bảo lần nào cũng cho cùng một kết quả, dù đã đặt `temperature=0`. Cần chạy nhiều lần mới đáng tin.
- Các con số trong thẻ vẫn là ước tính, cần kiểm chứng với số liệu thật nếu bài toán được triển khai.
- Quan trọng nhất: AI luôn chỉ soạn **bản nháp**, và luôn cần con người duyệt trước khi gửi, nhất là các tình huống an toàn như pin cạn hay hồ sơ bệnh án.

## 5. Điều tôi rút ra

Điều đáng nhớ nhất là không được tin vào dòng "Passed" khi chưa xem câu trả lời thật. Hai test đầu báo đạt nhưng mô hình thực ra làm sai luật, chỉ vì bộ kiểm tra quá dễ dãi. Lần sau tôi sẽ đọc kỹ kết quả và viết điều kiện kiểm tra sát với luật trước khi tin.

Tôi cũng nhận ra chỉ viết luật vào prompt thì chưa đủ. Mô hình chỉ làm đúng định dạng sau khi tôi đưa thêm một ví dụ mẫu cụ thể.

Cuối cùng, AI viết nhanh nhưng không thay được việc tự chạy, tự đối chiếu và tự quyết định. Số liệu, tên model và kết quả chạy đều phải kiểm chứng trên máy của mình.
