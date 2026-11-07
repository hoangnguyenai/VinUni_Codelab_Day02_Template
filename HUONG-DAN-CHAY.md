# Chạy và hoàn tất bài Lab 02

**Nhóm:** ManchesterUnited. **Thành viên:** Nguyễn Lâm Hoàng. **Email:** 26ai.hoangnl@vinuni.edu.vn.

Bộ bài chọn trợ lý điều phối sạc Xanh SM. Đọc lần lượt 01-problem-scan.md, 02-deep-dive-report.md, 03-ai-log.md và 04-workflow-diagram.png. Các số liệu vận hành là giả định, chưa có khảo sát hoặc kết quả Gemini live.

## Môi trường

Slide yêu cầu Python >3.11 và <3.14, tức 3.12 hoặc 3.13. `.venv` hiện có là 3.14.3; unit tests đã chạy được nhưng cần tạo môi trường đúng chuẩn khi nộp. Sau khi cài Python 3.13, dùng một thư mục mới để giữ môi trường cũ:

```powershell
py -3.13 -m venv .venv-lab
.\.venv-lab\Scripts\python.exe -m pip install -r requirements.txt
```

## Kiểm thử local không cần khóa

```powershell
.\.venv\Scripts\python.exe -m pytest -q tests
.\.venv\Scripts\python.exe starter-code/prompt_prototype.py --offline --report evidence/offline-contract.json
```

`--offline` dùng fixture có sẵn đáp án, chỉ kiểm tra định dạng/runner; tuyệt đối không gọi đó là tỷ lệ model vượt kiểm thử. Mock transport trong unit tests xác minh cấu hình gọi SDK, không gửi dữ liệu ra API.

## Kiểm thử Gemini thật — cần hoàn tất trước khi nộp phần I2

Trong terminal cá nhân, đặt GEMINI_API_KEY hoặc GOOGLE_API_KEY vào biến môi trường. Không đưa khóa vào file, báo cáo hoặc tin nhắn. Có thể nhập kín bằng PowerShell:

```powershell
$labKey = Read-Host 'Gemini API key' -AsSecureString
$env:GEMINI_API_KEY = [System.Net.NetworkCredential]::new('', $labKey).Password
.\.venv\Scripts\python.exe starter-code/prompt_prototype.py --report evidence/live-gemini.json
Remove-Item Env:GEMINI_API_KEY
```

Có thể thay đường dẫn `.venv` bằng `.venv-lab` khi đã cài đúng Python. Script mặc định gọi Gemini thật, không tự chuyển sang mock nếu API lỗi. Exit code 0 = tất cả ca đã chọn đạt kiểm tra action/schema, 1 = ít nhất một ca thất bại, 2 = thiếu khóa. Xem reason của từng ca thủ công, vì action đúng chưa bảo đảm toàn bộ lời giải thích đúng. Không đổi model âm thầm nếu Gemini 2.5 Flash không khả dụng; ghi lỗi và xin giảng viên xác nhận model thay thế.

Sau live run, cập nhật mục Phase 4 và AI Log theo kết quả thực tế, kể cả ca thất bại. Không chỉnh sửa expected_action chỉ để test xanh.

## Sơ đồ và bộ kiểm tra có sẵn

```powershell
.\tools\render-workflow.ps1
.\.venv\Scripts\python.exe autograder/autograder.py --check-file-1
.\.venv\Scripts\python.exe autograder/autograder.py --check-code-1
```

Autograder toàn bộ chạy script mặc định nên cần khóa Gemini và có timeout tổng 30 giây. Runner có 11 request tuần tự, có thể vượt timeout đó; dùng lệnh chạy trực tiếp để lưu đủ bằng chứng, không sửa autograder để che giới hạn. Chưa có điểm tổng chính thức.

## Thông tin cần điền và nộp bài

Đã điền thông tin ManchesterUnited và Nguyễn Lâm Hoàng vào báo cáo, code và sơ đồ. Nếu có thành viên khác tham gia, bổ sung thông tin của họ vào các file và render lại PNG. Kiểm tra phần reflection, nhận trách nhiệm về nội dung trước khi nộp. Hiện đang ở branch `Hoang`, chưa tạo commit/push trong phiên này.

Theo README: `.py` ở branch cá nhân; nhóm chỉ chọn lọc `.md`/ảnh vào main sau thảo luận. Chỉ trưởng nhóm điền form. Slide viết merge branch chung chung, README quy định chi tiết không merge `.py` nên thực hiện theo hướng dẫn chi tiết này. Không có thao tác push, merge main hoặc gửi form tự động.
