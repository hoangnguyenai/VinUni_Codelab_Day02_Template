# 01 — Problem Scan & Quick Problem Cards

> Các con số trong file là **ước tính** dựa trên tài liệu mẫu của giảng viên, chưa phải số đo thực tế.

---

## Phase 1 — SCAN: 5 bài toán

| # | Công ty | Góc nhìn | Mô tả ngắn |
|---|---------|----------|-----------|
| 1 | Xanh SM | Tốn thời gian | Khi tài xế báo hết pin giữa đường, điều phối viên phải tự tra vị trí xe, tìm trạm sạc còn trụ trống đúng loại cổng, rồi soạn tin chỉ đường. Mất khoảng 15 phút mỗi lượt, ước tính 80 sự cố mỗi ngày ở Hà Nội. |
| 2 | Vinhomes | Lặp lại | Cư dân gửi phản ánh (mất nước, hỏng đèn, ồn ào) qua ứng dụng, nhân viên phải đọc từng tin rồi chuyển thủ công đến đúng ban quản lý từng tòa. Việc này lặp lại cả ngày và phản hồi thường chậm đến nửa ngày. |
| 3 | Vinmec | Người khác đang khó chịu | Bác sĩ phàn nàn quá tải vì phải viết tóm tắt hồ sơ xuất viện, mất 20 đến 30 phút mỗi bệnh nhân, lấy mất thời gian khám. |
| 4 | VinFast | AI làm tốt hơn | Khách mô tả lỗi xe bằng tiếng Việt đời thường (ví dụ "đi qua gờ giảm tốc kêu cụp cụp ở bánh trước"), nhân viên tiếp nhận phải tự đoán nhóm lỗi, dễ phân loại sai hoặc rập khuôn. |
| 5 | Xanh SM | Tốn thời gian | Điều phối viên nghe lại ghi âm và đọc ghi chú tài xế để tìm lý do khách hủy chuyến, rất khó nhìn ra quy luật lỗi của hệ thống. |

---

## Phase 2 — QUICK-ASSESS: 3 thẻ bài toán

Ba bài được chọn: **#1 (Xanh SM sự cố hết pin), #2 (Vinhomes phản ánh cư dân), #3 (Vinmec tóm tắt xuất viện).**

### Thẻ #1 — Xanh SM: xử lý sự cố hết pin giữa đường

```text
┌─────────────────────────────────────────────────────────────┐
│ QUICK PROBLEM CARD #1                                       │
│                                                             │
│ Bài toán: Tài xế báo hết pin giữa đường, điều phối viên     │
│ phải tìm trạm sạc phù hợp và soạn tin chỉ đường bằng tay.   │
│ Công ty thành viên: [x] Xanh SM                             │
│                                                             │
│ Ai đang đau? Tài xế (phải chờ lâu), điều phối viên (quá tải)│
│                                                             │
│ Workflow thủ công hiện tại (5 bước):                        │
│   1. Nhận cuộc gọi báo sự cố                                │
│   → 2. Tra vị trí xe trên bản đồ                            │
│   → 3. Tìm trạm sạc còn trụ trống đúng loại cổng            │
│   → 4. Soạn tin chỉ đường gửi tài xế                        │
│   → 5. Gọi xe cứu hộ nếu pin quá thấp                       │
│                                                             │
│ Bước nào tốn nhất? Bước 3 và 4 (⏱ khoảng 10 phút/lượt)     │
│ AI có thể nhảy vào ở bước nào? Bước 3 và 4: tự lấy dữ liệu  │
│ trạm trống và soạn sẵn bản nháp tin nhắn.                   │
│                                                             │
│ Đo thành công bằng gì?                                      │
│ Giảm thời gian xử lý từ 15 phút xuống dưới 3 phút/lượt;     │
│ chỉ đúng trạm, đúng loại cổng sạc ở mức 98% trở lên.        │
│                                                             │
│ Quick Architecture: [x] LLM (mô hình ngôn ngữ soạn bản nháp)│
└─────────────────────────────────────────────────────────────┘
```

### Thẻ #2 — Vinhomes: phân loại và chuyển phản ánh cư dân

```text
┌─────────────────────────────────────────────────────────────┐
│ QUICK PROBLEM CARD #2                                       │
│                                                             │
│ Bài toán: Phản ánh của cư dân trên ứng dụng phải được đọc   │
│ và chuyển thủ công đến đúng ban quản lý, nên phản hồi chậm. │
│ Công ty thành viên: [x] Vinhomes                            │
│                                                             │
│ Ai đang đau? Cư dân (chờ lâu), nhân viên chăm sóc khách     │
│ hàng (đọc và chuyển tin lặp đi lặp lại cả ngày).            │
│                                                             │
│ Workflow thủ công hiện tại (4 bước):                        │
│   1. Cư dân gửi phản ánh trên ứng dụng                      │
│   → 2. Nhân viên đọc và đoán loại vấn đề                    │
│   → 3. Chuyển cho ban quản lý đúng tòa nhà                  │
│   → 4. Ban quản lý xử lý và báo lại cư dân                  │
│                                                             │
│ Bước nào tốn nhất? Bước 2 và 3 (⏱ khoảng 12 giờ chờ phản   │
│ hồi đầu tiên, phần lớn do tin nằm chờ trong hàng đợi)       │
│ AI có thể nhảy vào ở bước nào? Bước 2 và 3: tự phân loại    │
│ và chuyển đúng nơi.                                         │
│                                                             │
│ Đo thành công bằng gì?                                      │
│ Giảm thời gian từ lúc gửi đến lúc có người nhận việc từ     │
│ 12 giờ xuống dưới 30 phút; chuyển đúng ban quản lý ở mức    │
│ 95% trở lên.                                                │
│                                                             │
│ Quick Architecture: [x] Luật cố định trước (từ khóa + loại  │
│ vấn đề), chỉ dùng mô hình ngôn ngữ cho tin khó phân loại    │
└─────────────────────────────────────────────────────────────┘
```

### Thẻ #3 — Vinmec: soạn tóm tắt hồ sơ xuất viện

```text
┌─────────────────────────────────────────────────────────────┐
│ QUICK PROBLEM CARD #3                                       │
│                                                             │
│ Bài toán: Bác sĩ mất nhiều thời gian viết bản tóm tắt hồ sơ │
│ xuất viện cho từng bệnh nhân.                               │
│ Công ty thành viên: [x] Vinmec                              │
│                                                             │
│ Ai đang đau? Bác sĩ (quá tải), bệnh nhân (chờ giấy tờ lâu). │
│                                                             │
│ Workflow thủ công hiện tại (4 bước):                        │
│   1. Mở bệnh án điện tử, đọc lại toàn bộ quá trình điều trị │
│   → 2. Gom kết quả xét nghiệm và ghi chú                    │
│   → 3. Tự viết bản tóm tắt                                  │
│   → 4. Rà soát và ký                                        │
│                                                             │
│ Bước nào tốn nhất? Bước 1 đến 3 (⏱ khoảng 20 đến 30 phút   │
│ mỗi bệnh nhân)                                              │
│ AI có thể nhảy vào ở bước nào? Bước 1 đến 3: tự trích thông │
│ tin và soạn bản nháp.                                       │
│                                                             │
│ Đo thành công bằng gì?                                      │
│ Giảm thời gian soạn từ 25 phút xuống dưới 8 phút/bệnh nhân; │
│ bác sĩ sửa dưới 10% nội dung bản nháp.                      │
│                                                             │
│ Quick Architecture: [x] LLM (mô hình ngôn ngữ), bắt buộc    │
│ bác sĩ duyệt và ký trước khi gửi                            │
└─────────────────────────────────────────────────────────────┘
```
---


## Quyết định chọn bài

Nếu phải chọn một bài để làm phân tích sâu, nhóm nên chọn **Thẻ #1 (Xanh SM)**:

- Bài toán cụ thể, có số liệu thời gian rõ ràng.
- Luôn có người duyệt trước khi gửi tin, nên rủi ro thấp.
- Phù hợp với mã thử nghiệm của bài lab.

**Thẻ #2** chưa chọn vì nên thử bằng luật cố định trước, có thể không cần AI. **Thẻ #3** chưa chọn vì là lĩnh vực y tế, ranh giới an toàn phải rất chặt và cần thêm dữ liệu, bác sĩ duyệt trước.

## Phản biện 3 thẻ bài toán
### Thẻ #1: Xanh SM (hết pin)
- Số liệu thời gian chưa khớp. Cả quy trình 15 phút, bước 3 và 4 chỉ 10 phút, vậy 5 phút còn lại ở đâu? Chỉ tiêu “dưới 3 phút” cũng chưa nói rõ đo từ lúc nào đến lúc nào.
- Phụ thuộc dữ liệu trạm sạc. Nếu thông tin trụ trống không cập nhật tức thì thì AI chỉ làm tài xế đến sai trạm nhanh hơn.
Dùng mô hình ngôn ngữ chưa đúng chỗ. Tìm trạm trống là tra dữ liệu, làm bằng luật cố định chính xác hơn. Mô hình ngôn ngữ chỉ cần dùng để soạn tin nhắn.
- Thiếu trường hợp nguy hiểm. Xe còn rất ít pin mà gợi ý trạm xa thì xe chết giữa đường. Thẻ chưa nói gì về trường hợp này (đây cũng chính là luật 5% trong bài lab).
### Thẻ #2: Vinhomes (phản ánh cư dân)
- Chưa rõ chậm ở khâu nào. 12 giờ chờ là do nhân viên đọc tin chậm hay do ban quản lý xử lý chậm? AI chỉ sửa được khúc đầu.
- Thiếu tin khẩn. Tin về cháy hoặc rò điện mà bị xếp nhầm vào hàng thường thì hậu quả rất nặng, nhưng thẻ chưa có ngoại lệ nào.
- Chỉ tiêu 95% quá chung. Với tin khẩn thì 95% là chưa đủ, nên tách chỉ tiêu riêng.
### Thẻ #3: Vinmec (tóm tắt xuất viện)
- Đo “bác sĩ sửa dưới 10%” chưa đủ. Một lỗi nhỏ về tên thuốc hay liều dùng vẫn rất nguy hiểm dù chỉ chiếm 1% nội dung. Nên đo theo số lỗi nghiêm trọng, ví dụ bằng 0.
- Dữ liệu bệnh án rất nhạy cảm. Thẻ chưa nói có được gửi sang dịch vụ bên ngoài hay không.
- Bác sĩ có thể duyệt qua loa khi đã quen với bản nháp, thẻ chưa có cách ngăn việc này.
