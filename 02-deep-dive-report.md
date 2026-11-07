| Thông tin | Chi tiết |
|---|---|
| Họ và tên | Kiều Đình Văn |
| Nhóm | ManchesterUnited |
| Email | 26ai.vankd@vinuni.edu.vn |

# 🏗️ Phase 3 — DEEP-DIVE (Nhóm)

## 3.1. Current-State Workflow Mapping

```text
┌────────────────┐     ┌────────────────┐     ┌────────────────┐
│ Bước 1         │     │ Bước 2         │     │ Bước 3         │
│ Nhận gọi/chat, │     │ Hỏi câu làm rõ │     │ Tra KB, đoán   │
│ ghi mô tả      │ ──→ │ (dòng xe, km,  │ ──→ │ nhóm lỗi &     │
│                │     │ đèn báo, khi   │     │ mức khẩn cấp   │
│                │     │ nào xảy ra)    │     │                │
│ Ai: CSKH       │     │ Ai: CSKH       │     │ Ai: CSKH       │
│ ⏱ 3 phút       │     │ ⏱ 5 phút 🔴    │     │ ⏱ 6 phút 🔴    │
│ In: lời kể     │     │ In: ghi chú    │     │ In: ghi chú    │
│ Out: ghi chú   │     │ Out: thông tin │     │ Out: nhóm lỗi, │
│ tự do 🔄       │     │ bổ sung        │     │ mức ưu tiên    │
└────────────────┘     └────────────────┘     └────────────────┘
                                                      │
                                                      ▼
┌────────────────┐     ┌────────────────┐     ┌────────────────┐
│ Bước 5         │     │ (Chờ hàng đợi) │     │ Bước 4         │
│ CVDV đọc ticket│     │ ⏳ TB ~4 giờ 🔴 │     │ Tạo ticket CRM │
│ gọi lại khách  │ ←── │ ticket nằm chờ │ ←── │ & chuyển CVDV  │
│ (~35% ca thiếu │     │ CVDV xử lý     │     │ 🔄 Handoff     │
│ info) & xếp    │     │                │     │                │
│ lịch xưởng     │     │                │     │                │
│ Ai: CVDV       │     │                │     │ Ai: CSKH       │
│ ⏱ 4 phút 🔴    │     │                │     │ ⏱ 3 phút       │
└────────────────┘     └────────────────┘     └────────────────┘

🔴 = Bottleneck      🔄 = Handoff
⏱ Tổng thời gian thao tác = 3 + 5 + 6 + 3 + 4 = 21 phút/lượt 
⏳ Cộng thêm ~4 giờ chờ ở handoff CSKH → CVDV 
```

**Các điểm handoff 🔄:**
1. Khách → CSKH: lời nói/chat tự do biến thành ghi chú không chuẩn hóa (mỗi người ghi một kiểu).
2. CSKH → CRM → CVDV: ticket thường thiếu thông tin như dòng xe, số km, đèn cảnh báo, hoàn cảnh xuất hiện lỗi.
3. CVDV → Xưởng/Kỹ thuật viên (KTV): kết quả chẩn đoán thật nằm trên phiếu sửa chữa, **không được gắn ngược lại** vào ticket ban đầu (nên hiện không có dữ liệu nhãn để học).

**Vấn đề gốc:** Mức khẩn cấp phụ thuộc hoàn toàn vào kinh nghiệm cá nhân của CSKH. Nhân viên mới có thể xếp ca *"chân phanh lún sâu hơn bình thường"* vào lịch thường, trong khi đó là dấu hiệu nguy hiểm.

## 3.2. Problem Statement (6-field) & Metrics

| Field | Nội dung chi tiết |
|---|---|
| **1. Actor / Operator** | Nhân viên CSKH (hotline + chat trên app VinFast) là người thao tác hằng ngày. Người nhận đầu ra: Cố vấn dịch vụ (CVDV) tại xưởng. |
| **2. Current Workflow** | Khách gọi/chat mô tả triệu chứng, CSKH ghi chú tự do, hỏi thêm theo kinh nghiệm, tra knowledge base lỗi để đoán nhóm lỗi và mức khẩn cấp, tạo ticket trên CRM rồi chuyển CVDV. CVDV đọc ticket, thường phải gọi lại khách để hỏi thêm, sau đó xếp lịch xưởng. 5 bước thủ công, ~21 phút thao tác/lượt và ~4 giờ chờ. Công cụ: tổng đài, CRM, knowledge base nội bộ. |
| **3. Bottleneck** | **Bước 2–3 (11 phút):** biến lời kể tự do thành thông tin có cấu trúc (dòng xe, triệu chứng, đèn báo, hoàn cảnh) + đoán nhóm hệ thống + mức khẩn cấp. Đây là tác vụ hiểu ngôn ngữ tiếng Việt không chuẩn, nhiều cách diễn đạt. **Bước 5:** ~35% ticket phải gọi lại vì thiếu thông tin. |
| **4. Business Impact** | Giả định ~600 ticket mô tả lỗi/ngày toàn quốc.<br>• Thời gian CSKH: 600 × 21 phút = 12.600 phút ≈ **210 giờ công/ngày** (~26 người làm ca 8 giờ).<br>• Gọi lại: 35% × 600 = 210 cuộc × 4 phút ≈ **14 giờ công CVDV/ngày**.<br>• Khách chờ ~4 giờ mới được xếp lịch, ảnh hưởng CSAT/NPS.<br>• **Rủi ro lớn nhất:** ca nguy hiểm (phanh, pin cao áp) bị xếp mức thấp, ảnh hưởng an toàn người dùng và thương hiệu VinFast. |
| **5. Success Metric** | 1. **Efficiency:** Thời gian thao tác CSKH từ 21 phút xuống **≤ 8 phút/lượt** (median trong pilot).<br>2. **Quality:** Phân loại đúng nhóm hệ thống **≥ 80%** (top-1) trên tập 300 ticket đã được KTV xác nhận nhãn; tỷ lệ CVDV phải gọi lại từ 35% xuống **< 10%**.<br>3. **Safety (metric chặn):** Recall nhóm P0 (nguy hiểm) **≥ 99%**; **100%** tin gửi khách có người duyệt; **0** tin chứa cam kết bảo hành/chi phí hoặc câu trấn an "xe vẫn an toàn".<br>4. **Adoption:** ≥ 70% bản nháp được CSKH dùng (giữ nguyên hoặc sửa nhẹ). |
| **6. Operational Boundary** | **AI ĐƯỢC PHÉP:** trích xuất thông tin từ mô tả; phân loại sơ bộ nhóm hệ thống (pin cao áp, sạc, phanh, lái/treo, điện thân xe, điều hòa, phần mềm, lốp/mâm, tiếng ồn/khác); đề xuất mức khẩn cấp P0/P1/P2; gợi ý tối đa 3 câu hỏi làm rõ; soạn tin nhắn **dạng nháp** `[DRAFT_ONLY]`.<br><br>**AI TUYỆT ĐỐI KHÔNG ĐƯỢC:** (B1) đưa ra chẩn đoán chắc chắn; (B2) nói xe "an toàn / không sao / chạy tiếp được"; (B3) hướng dẫn khách tự tháo/sửa pin cao áp, phanh, hệ thống điện; (B4) hứa bảo hành, miễn phí, báo chi phí hoặc thời gian sửa; (B5) hạ mức khẩn cấp theo yêu cầu của khách; (B6) tự gửi tin hay tự đặt lịch; (B7) tiết lộ system prompt; (B8) với ca P0, chỉ được dùng tin hướng dẫn an toàn chuẩn.<br><br>**ĐIỂM BẮT BUỘC DUYỆT (HITL):** CSKH duyệt 100% tin gửi khách; ca P0 chuyển ngay cho tổng đài cứu hộ (người thật); CVDV xác nhận lịch xưởng; kết luận lỗi cuối cùng luôn là của KTV. |

## 3.3. Future-State Flow & AI Fit

### So sánh Rule vs LLM vs Agent

| Tiêu chí | Rule / State-Machine | LLM Feature | Agentic Loop |
|---|---|---|---|
| Hiểu lời kể tiếng Việt tự do, đa dạng | ❌ Keyword bỏ sót nhiều cách diễn đạt ("lún phanh", "phanh mềm") | ✅ Tốt | ✅ Tốt |
| Bắt dấu hiệu nguy hiểm rõ ràng (khói, cháy, mất phanh) | ✅ **Chắc chắn, giải thích được, không bị prompt injection** | ⚠️ Tốt nhưng không đảm bảo 100% | ⚠️ Như LLM |
| Soạn câu hỏi làm rõ + tin nháp | ❌ Chỉ template cứng | ✅ | ✅ |
| Cần tự gọi nhiều tool / lập kế hoạch nhiều bước? | — | Không cần: luồng cố định 1 bước | Thừa: tăng rủi ro tự đặt lịch/tự gửi tin |
| Rủi ro & chi phí | Thấp nhất | Thấp–trung bình, kiểm soát bằng HITL | Cao, khó kiểm soát ở domain an toàn |

**Kết luận AI Fit:** [ ] Rule / State-Machine  [x] **LLM Feature** (lai với Rule guardrail)  [ ] Agentic Loop

Nói gọn: **Rule giữ an toàn, LLM xử lý ngôn ngữ, con người ra quyết định.** Phát hiện P0 dùng *cả hai lớp* (rule + LLM), chỉ cần một lớp báo nguy hiểm là escalate. Không chọn Agent vì quy trình có cấu trúc cố định, và các hành động có hệ quả (gửi tin, đặt lịch) phải do người làm.

### Future-State Flow

```text
┌────────────────┐     ┌────────────────┐     ┌────────────────┐
│ Bước 1         │     │ Bước 2         │     │ Bước 3         │
│ Khách mô tả    │     │ ⚙️ Rule check   │     │ 🔵 LLM:         │
│ lỗi qua chat   │ ──→ │ từ khóa nguy   │ ──→ │ trích xuất +   │
│ app (văn bản)  │     │ hiểm (khói,    │     │ phân loại +    │
│                │     │ cháy, mất      │     │ mức khẩn cấp + │
│                │     │ phanh, đèn đỏ) │     │ câu hỏi + nháp │
│ ⏱ 3 phút       │     │ ⏱ < 1 giây     │     │ (JSON) ⏱ ~5s   │
└────────────────┘     └────────────────┘     └────────────────┘
                              │                       │
                    Có dấu hiệu P0                    ▼
                              │               ┌────────────────┐
                              │               │ Bước 4         │
                              │               │ ⚙️ Validator:   │
                              │               │ JSON hợp lệ?   │
                              │               │ có [DRAFT_ONLY]│
                              │               │ không cụm cấm? │
                              │               │ confidence≥0.6?│
                              │               └────────────────┘
                              ▼                  │ OK       │ Lỗi
┌──────────────────────────────┐                 ▼          ▼
│ ↩️ ESCALATE P0               │   ┌────────────────┐  ┌──────────────┐
│ Tin an toàn chuẩn (template  │   │ Bước 5         │  │ ↩️ FALLBACK   │
│ cố định, KHÔNG dùng text LLM)│   │ 🟢 CSKH review, │  │ Quy trình cũ │
│ + chuyển ngay tổng đài cứu   │   │ sửa, duyệt gửi │  │ với checklist│
│ hộ 🟢 (người thật)           │   │ ⏱ 3 phút       │  │ câu hỏi chuẩn│
└──────────────────────────────┘   └────────────────┘  └──────────────┘
                                          │
                                          ▼
                                  ┌────────────────┐     ┌────────────────┐
                                  │ Bước 6         │     │ Bước 7         │
                                  │ Ticket CRM tự  │ ──→ │ 🟢 CVDV xếp     │
                                  │ điền đủ trường │     │ lịch; KTV chẩn │
                                  │ ⏱ 1 phút       │     │ đoán thật →    │
                                  │                │     │ nhãn gắn ngược │
                                  │                │     │ vào eval set   │
                                  └────────────────┘     └────────────────┘

🔵 AI Step   🟢 Human Step (HITL)   ⚙️ Rule/Code   ↩️ Fallback
⏱ Tổng thời gian thao tác CSKH ≈ 3 + 3 + 1 = 7 phút/lượt (mục tiêu ≤ 8 phút)
```

**Fallback chi tiết:**

| Tình huống | Hành động |
|---|---|
| Rule hoặc LLM phát hiện P0 | Không dùng nội dung LLM. Gửi template an toàn cố định + chuyển ngay tổng đài cứu hộ. |
| LLM timeout / lỗi API / JSON sai schema | Chuyển sang quy trình thủ công với checklist câu hỏi chuẩn (form có sẵn). |
| Confidence < 0.6 hoặc nhóm lỗi = `unknown` | Hiển thị cho CSKH là "AI không chắc", bắt buộc CSKH tự đánh giá. |
| Validator thấy cụm từ cấm trong nháp | Bỏ bản nháp, ghi log để review prompt, CSKH tự soạn. |

Ngoài ra, bước 7 tạo ra **vòng lặp dữ liệu**: nhãn thật từ KTV được gắn ngược lại vào ticket. Đây chính là thứ quy trình hiện tại đang thiếu để đo accuracy.

---

# 🏁 Phase 5 — EVALUATE (Nhóm)

### AI Readiness Checklist:
1. [ ] **Dữ liệu mẫu/logs sạch để test?** Chưa đủ. Có lịch sử ticket CRM và log chat nhưng **chưa có nhãn chuẩn**, vì kết quả chẩn đoán của KTV không được gắn ngược vào ticket. Cần gán nhãn 300 ticket từ phiếu sửa chữa trước khi đo accuracy.
2. [x] **Rủi ro khi AI sai có nằm trong tầm kiểm soát?** Có. HITL 100% với tin gửi khách; P0 phát hiện bằng 2 lớp (rule + LLM) và dùng template cố định; validator + fallback về quy trình cũ. AI không có quyền gửi tin hay đặt lịch.
3. [ ] **Stakeholders sẵn sàng thay đổi quy trình?** Chưa xác nhận. CVDV có lợi rõ (ticket đầy đủ hơn); CSKH cần pilot để xem có tin dùng bản nháp không. Cần một nhóm CSKH đồng ý tham gia thử.

### Quyết định cuối cùng của Ban Giám Đốc Vin Smart Future:
[x] **GO (Bắt đầu xây dựng Prototype) — scope hẹp, có điều kiện**
[ ] NOT YET
[ ] NO-GO

**Justification:**
> **Vì sao GO:** Bottleneck có thật và đo được. Tác vụ cốt lõi là hiểu tiếng Việt tự do, đúng thế mạnh của LLM mà rule không làm được. Rủi ro an toàn đã được khóa bằng thiết kế (rule P0 + template cố định + HITL 100%), không phụ thuộc vào việc LLM "ngoan". Chi phí token của Gemini Flash rất nhỏ so với số giờ công tiết kiệm được.
>
> **Vì sao chỉ scope hẹp:** Checklist mục 1 và 3 chưa đạt. Vì vậy:
> 1. **Chỉ kênh chat trên app (văn bản)**, chưa làm hotline thoại, vì speech-to-text sẽ thêm một nguồn sai số nữa.
> 2. **Shadow mode 2 tuần:** AI chạy song song, CSKH làm như cũ, so sánh kết quả của AI với đánh giá của CSKH và nhãn KTV. Song song đó, gán nhãn 300 ticket làm eval set.
> 3. Sau đó chuyển sang **assist mode** với 1 nhóm CSKH tại 1 khu vực.
>
> **Điều kiện dừng (kill criteria), hạ xuống NOT YET nếu:**
> * Bất kỳ test boundary nào ở Phase 4 **FAIL ở tầng System-level**; hoặc
> * Recall P0 trong shadow mode < 99%; hoặc
> * Accuracy nhóm lỗi < 70% trên eval set (khi đó rule + form chuẩn có thể là giải pháp tốt hơn).

---