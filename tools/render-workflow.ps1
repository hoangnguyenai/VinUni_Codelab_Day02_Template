# Nhóm: ManchesterUnited. Nguyễn Lâm Hoàng — 26ai.hoangnl@vinuni.edu.vn.
# Sơ đồ nghiệp vụ bằng System.Drawing; chạy từ thư mục gốc repo.
Add-Type -AssemblyName System.Drawing
$bitmap = [System.Drawing.Bitmap]::new(1800, 1940)
$g = [System.Drawing.Graphics]::FromImage($bitmap)
$g.SmoothingMode = 'AntiAlias'
$g.TextRenderingHint = 'AntiAliasGridFit'
$g.Clear([System.Drawing.Color]::FromArgb(246,248,252))
$dark = [System.Drawing.SolidBrush]::new([System.Drawing.Color]::FromArgb(19,39,61))
$blue = [System.Drawing.SolidBrush]::new([System.Drawing.Color]::FromArgb(20,94,150))
$red = [System.Drawing.SolidBrush]::new([System.Drawing.Color]::FromArgb(180,35,45))
$white = [System.Drawing.SolidBrush]::new([System.Drawing.Color]::White)
$font = [System.Drawing.Font]::new('Arial',26)
$small = [System.Drawing.Font]::new('Arial',23)
$bold = [System.Drawing.Font]::new('Arial',29,[System.Drawing.FontStyle]::Bold)
$title = [System.Drawing.Font]::new('Arial',43,[System.Drawing.FontStyle]::Bold)
$pen = [System.Drawing.Pen]::new([System.Drawing.Color]::FromArgb(20,94,150),5)
$pen.EndCap = [System.Drawing.Drawing2D.LineCap]::ArrowAnchor
$g.DrawString('XANH SM / CURRENT-STATE WORKFLOW',$title,$dark,70,45)
$g.DrawString('ManchesterUnited • Nguyễn Lâm Hoàng • 26ai.hoangnl@vinuni.edu.vn',$small,$dark,70,125)
$g.DrawString('Mô hình giả định cho Lab 02. Chưa khảo sát hoặc đo log thực tế.',$font,$blue,70,180)
$steps = @(
    @('01  NHẬN CUỘC GỌI','2 phút','Điều phối viên nhận báo cáo từ tài xế.','Đầu ra: log ca sự cố pin.'),
    @('02  XÁC MINH PIN VÀ VỊ TRÍ','2 phút','Điều phối viên tra bảng định vị, xác minh dữ liệu.','Đầu ra: mức pin, GPS và thời điểm ghi nhận.'),
    @('03  KIỂM TRA PHƯƠNG ÁN','5 phút / NGHẼN','Tra thông tin trạm hoặc nguồn lực hỗ trợ.','Đầu ra: phương án đề xuất có dữ liệu kiểm chứng.'),
    @('04  SOẠN VÀ KIỂM TRA NHÁP','5 phút / NGHẼN','Tổng hợp phương án, kiểm tra lại thông tin.','Đầu ra: nội dung chờ người có quyền duyệt.'),
    @('05  DUYỆT, GỬI VÀ BÀN GIAO','1 phút','Người có quyền xác nhận trên kênh nghiệp vụ.','Đầu ra: tài xế / đơn vị hỗ trợ nhận phương án.')
)
$handoffs = @('H1  Tài xế → điều phối','H2  Hệ thống định vị → điều phối','H3  Bộ phận trạm / hỗ trợ → điều phối','Nội bộ điều phối: rà soát bản nháp','H4  Điều phối → tài xế / đơn vị hỗ trợ')
for ($i=0; $i -lt 5; $i++) {
    $y=315 + $i*280
    $g.FillRectangle($white,70,$y,1660,200)
    $brush=if($i -eq 2 -or $i -eq 3){$red}else{$blue}
    $g.FillRectangle($brush,70,$y,10,200)
    $g.DrawString($steps[$i][0],$bold,$dark,100,($y+18))
    $g.DrawString($steps[$i][1],$bold,$brush,1220,($y+18))
    $g.DrawString($steps[$i][2],$font,$dark,100,($y+80))
    $g.DrawString($steps[$i][3],$font,$dark,100,($y+132))
    $g.DrawString($handoffs[$i],$small,$blue,150,($y-52))
    if($i -lt 4){$g.DrawLine($pen,105,($y+207),105,($y+263))}
}
$g.DrawString('TỔNG GIẢ ĐỊNH: 15 PHÚT / CA',$bold,$dark,70,1755)
$g.DrawString('Hai bước nghẽn: 10 / 15 phút (66,7%).',$font,$red,70,1815)
$g.DrawString('Chưa gồm hàng chờ và thời gian xe hỗ trợ tới nơi. Nguồn: 02-deep-dive-report.md.',$small,$dark,70,1870)
$bitmap.Save((Join-Path (Get-Location) '04-workflow-diagram.png'),[System.Drawing.Imaging.ImageFormat]::Png)
$g.Dispose(); $bitmap.Dispose()

