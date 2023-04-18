use QLBanHang

--CÂU 1)--
CREATE TRIGGER TRG_NHAP
ON Nhap
FOR INSERT
AS
BEGIN
	DECLARE @masp nchar(10), @manv nvarchar(10)
	DECLARE @sln INT, @dgn FLOAT
	SELECT @masp=masp, @manv=manv, @sln=soluongN, @dgn=dongiaN
	FROM inserted
	IF(NOT EXISTS(SELECT * FROM Sanpham WHERE masp=@masp))
		BEGIN
			RAISERROR (N'Khong ton tai san pham trong danh muc san pham',16,1)
			ROLLBACK TRANSACTION
		END
	ELSE
		IF(NOT EXISTS(SELECT * FROM Nhanvien WHERE manv=@manv))
		BEGIN
			RAISERROR (N'Khong ton tai nhan vien co ma nay',16,1)
			ROLLBACK TRANSACTION
		END
		ELSE
		IF(@sln<=0 or @dgn<=0)
			BEGIN
				RAISERROR(N'Nhap sai soluong hoac dongia',16,1)
				ROLLBACK TRANSACTION
			END
		ELSE
			UPDATE Sanpham SET soluong = soluong + @sln
			FROM Sanpham WHERE masp = @masp
END
--Nhập sai--
insert into nhap values('nh01', 'sp01', 'nv01', '3/7/2018', '0', '1500000')
--Nhập đúng--
insert into nhap values('nh01','sp01','nv01','3/7/2018', '300', '1500000')
select * from nhap
select * from sanpham

--CÂU 2)--


--CÂU 3)--

CREATE TRIGGER XOAPHIEUXUAT ON Xuat
FOR DELETE AS
BEGIN
	UPDATE Sanpham SET soluong=soluong+(SELECT soluongX FROM deleted WHERE masp=Sanpham.masp)
	FROM Sanpham 
	JOIN deleted ON Sanpham.masp=deleted.Masp
END

--CÂU 4)--

CREATE TRIGGER [dbo].[XuatHang123] ON [dbo].[Xuat]
FOR UPDATE AS
BEGIN 
	DECLARE @masp nvarchar(10), @slx int
	SELECT @masp = masp, @slx = soluongX FROM inserted
	UPDATE Sanpham SET soluong = soluong - @slx WHERE masp = @masp
	IF @slx > (SELECT TOP 1 Soluong FROM Sanpham)
	BEGIN
		RAISERROR (N'SO LUONG XUAT CAO HON TON KHO',16,1)
		ROLLBACK TRAN
	END
END

--CÂU 6)--
CREATE TRIGGER XOAPHIEUNHAP ON Nhap
FOR DELETE AS
BEGIN
	UPDATE Sanpham SET soluong=soluong-(SELECT soluongN FROM deleted WHERE masp=Sanpham.masp)
	FROM Sanpham 
	JOIN deleted ON Sanpham.masp=deleted.Masp
END