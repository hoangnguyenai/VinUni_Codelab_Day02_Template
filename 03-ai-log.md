# 03 — AI Log & Reflection

## 1. AI đã hỗ trợ tôi như thế nào?

Tôi dùng AI như một thought-partner trong Lab 02: AI giúp brainstorm các pain point vận hành thuộc nhiều công ty thành viên Vingroup, sau đó hỗ trợ sắp xếp thành năm ý tưởng SCAN và phát triển ba Quick Problem Cards cho VinFast, Xanh SM và Vinpearl. AI cũng giúp tôi xem xét ai đang gặp khó khăn, workflow giả định, bottleneck, metric có thể đo, lựa chọn giữa rule-based và LLM, cùng các ranh giới cần có người kiểm tra.

Với prototype, AI hỗ trợ xây dựng system prompt cho trợ lý điều phối Xanh SM, quy định nhãn `[DRAFT_ONLY]`, xử lý tình huống pin dưới 5%, định dạng JSON và các ca kiểm thử đối kháng. Tôi chọn OpenRouter làm nhà cung cấp và cấu hình model `openai/gpt-6-luna` trong `starter-code/prompt_prototype.py`.

## 2. AI hoặc prototype đã sai/chưa tốt ở đâu?

- Các con số về số lượng hồ sơ, thời gian xử lý, giờ công và mục tiêu cải thiện trong các thẻ ban đầu là giả định để brainstorm, không phải số liệu nội bộ đã xác minh. Tôi cần đo baseline và xác nhận với người hiểu quy trình trước khi dùng chúng như dữ kiện.
- Lần đầu chạy prototype, tôi dùng OpenRouter API key với Google Gemini SDK nên nhận lỗi `API_KEY_INVALID`. Điều này giúp tôi nhận ra key của OpenRouter không thay thế được Gemini API key khi gọi trực tiếp Google.
- Sau đó API Gemini trả về lỗi model `gemini-2.5-flash` không khả dụng cho tài khoản của tôi. Tôi thử đổi sang model được nêu trong thông báo lỗi, rồi quyết định chuyển prototype sang OpenRouter.
- Một phản hồi thực tế của Gemini đã chọn đúng `dispatch_mobile_charger` khi pin ở mức 2%, nhưng assertion ban đầu vẫn báo lỗi vì chỉ cần thấy chuỗi “8km” là kết luận mô hình đề xuất trạm xa. Trong trường hợp đó, mô hình nhắc 8km để giải thích rằng xe không thể tới trạm an toàn, không phải để khuyến nghị tuyến đường.
- Prompt và assertion chỉ là biện pháp thử nghiệm; chúng không bảo đảm mô hình luôn tuân thủ ranh giới trong mọi tình huống. Prototype không kết nối hệ thống điều phối thật và không thể thực sự gọi xe cứu hộ.

## 3. Tôi đã điều chỉnh như thế nào?

- Ghi rõ các ước tính trong Problem Scan là giả định cần xác minh, thay vì trình bày như số liệu thực tế của Vingroup.
- Cập nhật system prompt để yêu cầu mọi phản hồi bắt đầu bằng `[DRAFT_ONLY]`, trả về JSON, không khẳng định đã gửi tin nhắn hoặc điều phối xe, không bịa dữ liệu, và chọn hành động `dispatch_mobile_charger` khi pin dưới 5%.
- Tôi sửa assertion pin yếu: thay vì cấm mọi lần nhắc khoảng cách 8km, assertion kiểm tra hành động và cấu trúc phản hồi. Như vậy có thể phân biệt lời giải thích an toàn với khuyến nghị nguy hiểm.
- Cấu hình prototype dùng OpenRouter qua biến môi trường `OPENROUTER_API_KEY`, với model mặc định `openai/gpt-6-luna`. API key không được ghi vào mã nguồn.

## 4. Kết quả kiểm thử và việc cần làm tiếp

Các kiểm tra cú pháp Python, mô phỏng request/response OpenRouter, assertion pin yếu với phản hồi mẫu, và các tiêu chí autograder cho system prompt và cấu trúc adversarial tests đã được chạy thành công. Autograder có tiêu chí riêng yêu cầu Gemini SDK; tiêu chí này không tương thích với lựa chọn OpenRouter hiện tại.

Tôi đã quan sát một phản hồi thực tế từ Gemini cho ca pin 2%, trong đó mô hình trả về hành động điều xe sạc di động và giải thích vì sao không thể đi 8km. Tuy nhiên, tôi chưa ghi nhận kết quả chạy thực tế đầy đủ cả ba ca với cấu hình OpenRouter và model `openai/gpt-6-luna`; vì vậy không kết luận rằng toàn bộ kiểm thử OpenRouter đã pass. Bước tiếp theo là chạy đủ các ca với API key OpenRouter của tôi, lưu kết quả thực tế, rồi xem lại mọi phản hồi bị assertion đánh dấu.

## 5. Tự phản ánh

AI giúp tôi đi nhanh từ ý tưởng đến cấu trúc bài và prototype, nhưng tôi vẫn phải kiểm tra giả định, lỗi API, lựa chọn model và logic của assertion. Bài học chính của tôi là không xem đầu ra của AI hoặc kết quả một assertion đơn giản là bằng chứng đầy đủ về độ an toàn. Cần xác minh số liệu với nguồn thực tế, kiểm thử nhiều kiểu đầu vào, và giữ người phụ trách trong vòng phê duyệt trước khi bất kỳ thông tin hoặc hành động nào được gửi ra ngoài.
