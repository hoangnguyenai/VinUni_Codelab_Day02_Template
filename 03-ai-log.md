# 03 — AI Log & Reflection

**Vai trò:** AI Product Engineer (bài lab mô phỏng), Vin Smart Future. Nhật ký này ghi lại công việc trong phiên thực hiện bài; **không nhận là đã khảo sát hiện trường hoặc phỏng vấn nhân viên Xanh SM**.

## AI đã hỗ trợ những gì

| Bước | Đầu vào / câu hỏi với AI | Gợi ý hoặc kết quả | Kiểm tra và quyết định của tôi |
|---|---|---|---|
| Scan | Tìm điểm nghẽn ở Xanh SM, Vinhomes, VinFast, Vinpearl bằng 4 lenses của worksheet. | Danh sách 5 bài toán và 3 thẻ đánh giá nhanh. | Chọn bài toán pin nguy cấp vì có ngưỡng và quyền quyết định rõ. Các thời gian và metric đều ghi là giả định. |
| Stress-test ý tưởng | Phản biện như CFO và trưởng vận hành: rule thường giải quyết được phần nào? | Ngưỡng pin và khoảng cách là logic xác định, không cần LLM tự quyết. | Tách rule an toàn khỏi LLM soạn nháp; thêm yêu cầu người duyệt. |
| Prompt prototype | Yêu cầu bản nháp luôn có `[DRAFT_ONLY]`; pin <5% không chỉ trạm >5 km và đề xuất `dispatch_mobile_charger`. | System prompt và ba ca đối kháng, gồm ca giả mạo quyền quản trị. | Chạy script qua Groq, xem trực tiếp phản hồi và trạng thái kiểm tra. |

## Chỗ AI/công cụ đã sai hoặc có thể gây hiểu nhầm

1. **Tên model không khả dụng:** cấu hình ban đầu dùng `llama-3.3-70b-versatile`, nhưng API trả `model_not_found` với khóa hiện có. Tôi không coi đây là lỗi prompt; đã đọc danh sách model mà tài khoản truy cập được và dùng `openai/gpt-oss-20b` cho lần thử tiếp theo.
2. **Bộ kiểm tra quá cứng:** một phản hồi hợp lệ ghi `"action":"dispatch_mobile_charger"` không có dấu cách, nên phép tìm chuỗi cũ báo thất bại. Sau khi xem phản hồi thực, tôi sửa kiểm tra để chấp nhận khoảng trắng tùy ý. Điều này cho thấy nhãn *Failed* từ script cũng phải được kiểm tra lại, không xem là kết luận tuyệt đối.
3. **Ví dụ không phải bằng chứng thực tế:** tài liệu mẫu có thời gian và lượng sự cố cụ thể, nhưng phiên làm bài không có log nội bộ để xác nhận. Tôi dùng số giả định để đặt mục tiêu đo, không trình bày là số liệu của Xanh SM.

## Prompt/ranh giới đã điều chỉnh

- Chuyển từ ý tưởng “AI chọn trạm và gửi hướng dẫn” sang **rule kiểm tra pin/khoảng cách → LLM soạn nháp → điều phối viên duyệt**.
- Nêu rõ AI không được tự gửi tin hay khẳng định đã điều xe; `dispatch_mobile_charger` là **đề xuất để người duyệt**, chưa phải hành động thực.
- Nếu GPS/pin không rõ hoặc cũ, yêu cầu xác minh; không tự bịa vị trí, khoảng cách hoặc khả năng đội hỗ trợ.
- Kiểm tra thẻ ở **đầu phản hồi** thay vì chỉ kiểm tra thẻ xuất hiện ở đâu đó trong văn bản.

## Kết quả thử và giới hạn

Lần chạy API gần nhất với ba đầu vào mẫu: **3/3** phép kiểm tra tự động đạt. Hai ca pin nguy cấp xuất đề xuất `dispatch_mobile_charger`; ca ép bỏ thẻ vẫn bắt đầu bằng `[DRAFT_ONLY]`. Trước đó, ca giả mạo quyền quản trị chỉ nhận lời từ chối chung; tôi đã làm rõ trong system prompt rằng vẫn phải đưa ra đề xuất hỗ trợ đúng quy tắc, rồi chạy lại. Đây chỉ là kiểm tra prompt quy mô nhỏ, chưa đánh giá dữ liệu thực, khả năng gửi sai trong hệ thống, độ ổn định qua nhiều lần chạy hay chi phí.

**Điều tôi rút ra:** AI hữu ích để mở rộng và phản biện lựa chọn sản phẩm, nhưng con số, khả năng truy cập model và kết quả chấm tự động đều phải đối chiếu bằng dữ liệu hoặc chạy thử. Quyết định triển khai là **NOT YET** cho vận hành thật cho đến khi có baseline, log sạch và vòng duyệt của điều phối viên.
