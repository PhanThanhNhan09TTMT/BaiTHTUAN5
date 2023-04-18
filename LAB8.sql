use QLBanHang
--C헧 1)--
CREATE PROCEDURE THEMMOINHANVIEN(@manv nchar(10), @tennv nvarchar(20), @gioitinh nvarchar(10), @diachi nvarchar(20),
@sodt nvarchar(10), @email nvarchar(20), @phong nvarchar(30), @Flag int)
AS
	IF @gioitinh IN('NAM', 'NU')
	BEGIN
	IF @Flag = 0
BEGIN
		INSERT INTO Nhanvien(manv, Tennv, Gioitinh, Diachi, Sodt, email, Phong)
			VALUES (@manv, @tennv, @gioitinh, @diachi, @sodt, @email, @phong)
END
ELSE 
BEGIN
		UPDATE Nhanvien SET Tennv = @tennv, Gioitinh = @gioitinh, Diachi = @diachi, Sodt = @sodt, email = @email, Phong = @phong
		WHERE manv = @manv
END
		RAISERROR(N' 1 ', 16,1)
END
	ELSE 
BEGIN
		RAISERROR(N' 0 ',16,1)
		ROLLBACK TRAN
END

--C헧 2)--
CREATE PROCEDURE THEMMOISANPHAM(@masp nvarchar(10), @tensp nvarchar(20), @tenhang nvarchar(20), @soluong int, 
@mausac nvarchar(10), @giaban money,  @donvitinh nvarchar(10), @mota nvarchar(30), @flag int)
AS
	IF @flag = 0
	BEGIN
	IF @tenhang NOT IN (SELECT mahangsx FROM Sanpham )
BEGIN
		RAISERROR (N' 1 ',16,1)
		ROLLBACK TRAN
END
	IF @soluong < 0 
BEGIN
		RAISERROR (N' 2 ',16,1)
		ROLLBACK TRAN
END
	IF @tenhang IN (SELECT mahangsx FROM Sanpham) AND @soluong > 0
BEGIN
		INSERT INTO Sanpham(masp, mahangsx, tensp, soluong, mausac, giaban, donvitinh, mota)
		VALUES(@masp, @tenhang, @tensp, @soluong, @mausac, @giaban, @donvitinh, @mota)
		RAISERROR (N' 0 ',16,1)
END
END
	ELSE
BEGIN
	IF @tenhang NOT IN (SELECT mahangsx FROM Sanpham )
BEGIN
		RAISERROR (N' 1 ',16,1)
		ROLLBACK TRAN
END
	IF @soluong < 0 
BEGIN
		RAISERROR (N' 2 ',16,1)
		ROLLBACK TRAN
END
	ELSE
BEGIN
		UPDATE Sanpham SET mahangsx = @tenhang, tensp = @tensp, soluong = @soluong, mausac = @mausac, giaban = @giaban, donvitinh = @donvitinh, mota = @mota
		WHERE masp = @masp
		RAISERROR (N' 0 ',16,1)
END
END

--C헧 3)--
CREATE PROCEDURE XOANHANVIEN (@manv nvarchar(10))
AS
	IF @manv IN (SELECT Manv FROM Nhanvien)
BEGIN
	DELETE FROM Nhanvien WHERE manv = @manv
	DELETE FROM Nhap WHERE manv = @manv
	DELETE FROM Xuat WHERE manv = @manv
	RAISERROR(N' 0 ',16,1)
END
	ELSE 
BEGIN
	RAISERROR (N' 1 ',16,1)
	ROLLBACK TRAN
END

--C헧 4)--


--C헧 5)--
CREATE PROCEDURE NHAPLIEU(@mahangsx nvarchar(10), @tenhang nvarchar(20), @diachi nvarchar(20), @sodt nvarchar(10), @email nvarchar(20))
AS 
	IF @tenhang NOT IN (SELECT Tenhang FROM Hangsx)
BEGIN
	RAISERROR (N'Ma loi 0',16,1)
END
	ELSE 
BEGIN
	RAISERROR (N'Ma loi 1',16,1)
	ROLLBACK TRAN
END
