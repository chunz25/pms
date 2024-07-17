-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Generation Time: Jul 17, 2024 at 06:56 AM
-- Server version: 10.4.32-MariaDB
-- PHP Version: 8.0.30

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `pms`
--

DELIMITER $$
--
-- Procedures
--
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_addlpbjhdr` (IN `userid` INT, IN `companycode` VARCHAR(50), IN `description` VARCHAR(50), IN `note` VARCHAR(50))   BEGIN

	INSERT INTO m_lpbj_hdr (nolpbj,companycode,description,userid,note,`status`,isdeleted,created_at,created_by)
	SELECT
		CONCAT(
		'EC01', '/' ,
		REPLACE((select a.depname from vw_getpegawai a where a.userid = userid),' ',''), '/',
		REPLACE(CURRENT_DATE,'-',''),'/',
		RIGHT(concat('0000',(SELECT count(x.id) as cnt from m_lpbj_hdr x WHERE x.userid = userid AND date(x.created_at) = CURRENT_DATE) + 1),4)
		) as nolpbj ,
		companycode,
		description ,
		userid ,
		note ,
		1 as statuslpbj ,
		0 as isdeleted ,
		CURRENT_TIMESTAMP as createat,
		userid as createdby;

	INSERT INTO m_lpbj_dtl (hdrid,articlecode,remark,qty,sitecode,accassign,gl,costcenter,`order`,asset,keterangan,gambar,created_at,created_by)
	SELECT
		(select max(id) from m_lpbj_hdr) as hdrid ,
		a.articlecode ,
		a.remark ,
		a.qty ,
		a.sitecode ,
		a.accassign ,
		a.gl ,
		a.costcenter ,
		a.`order` ,
		a.asset ,
		a.keterangan ,
		a.gambar ,
		CURRENT_TIMESTAMP as createdat ,
		userid
	FROM s_draftlpbj a	
	WHERE a.userid = userid
	and isdeleted = 0	;
	
	UPDATE s_draftlpbj
	SET isdeleted = 1,
			modified_by = userid
	WHERE userid = userid;
	
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_addqedtl` (IN `userid` INT, `dtlid` INT)   BEGIN
	
	INSERT INTO m_qe_dtl(hdrid,draftid,created_at,created_by)
	SELECT
		(SELECT max(id) FROM m_qe_hdr) ,
		a.id as draftid ,
		CURRENT_TIMESTAMP as createdat,
		userid as created_by
	FROM s_draftqe a
	WHERE a.created_by = userid
	AND a.dtlid = dtlid;
	
	UPDATE s_draftqe
	SET isdeleted = 1
	WHERE created_by = userid
	and dtlid = dtlid;
	
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_addqehdr` (IN `userid` INT, `dtlid` INT)   BEGIN
	
	INSERT INTO m_qe_hdr(lpbjid,noqe,status,created_at,created_by)
	SELECT DISTINCT
		c.id as lpbjid ,
		CONCAT(c.nolpbj,'/QE',RIGHT(concat('000',(SELECT count(noqe)+1 from m_qe_hdr WHERE date(created_at) = CURRENT_DATE)),3)) as noqe ,
		1 as status ,
		CURRENT_TIMESTAMP as crated_at ,
		userid as created_by
	FROM s_draftqe a
	left join m_lpbj_dtl b on b.id = a.dtlid
	left join m_lpbj_hdr c on c.id = b.hdrid
	WHERE a.created_by = userid
	AND a.dtlid = dtlid;
	
END$$

DELIMITER ;

-- --------------------------------------------------------

--
-- Table structure for table `api_article`
--

CREATE TABLE `api_article` (
  `id` int(11) NOT NULL,
  `productcode` varchar(255) DEFAULT NULL,
  `productname` varchar(255) DEFAULT NULL,
  `producttype` varchar(255) DEFAULT NULL,
  `brand` varchar(255) DEFAULT NULL,
  `dimension` varchar(255) DEFAULT NULL,
  `uom` varchar(255) DEFAULT NULL,
  `active` varchar(255) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

--
-- Dumping data for table `api_article`
--

INSERT INTO `api_article` (`id`, `productcode`, `productname`, `producttype`, `brand`, `dimension`, `uom`, `active`) VALUES
(8, 'ACCO', 'Acco', 'Non Merchandise', '', '', 'PC', ''),
(9, 'ACRY JDWL HOMDEL', 'ACRYLIC JDWL HOMDEL', 'Non Merchandise', '', '', 'PC', ''),
(10, 'ACRY MOD', 'ACRYLIC MOD', 'Non Merchandise', '', '', 'PC', ''),
(11, 'ACRY POP A4', 'ACRYLIC POP A4', 'Non Merchandise', '', '', 'PC', ''),
(12, 'ACRY POP A5', 'ACRYLIC POP A5', 'Non Merchandise', '', '', 'PC', ''),
(13, 'ACRYLIC PRICETAG M', 'ACRYLIC PriceTag M', 'Non Merchandise', '', '', 'PC', ''),
(14, 'ACRYLIC PRICETAG S', 'ACRYLIC PriceTag S', 'Non Merchandise', '', '', 'PC', ''),
(15, 'ADVANCE', 'ADVANCE', 'Non Merchandise', '', '', 'PC', ''),
(16, 'ALARM DISPLAY HP', 'Alarm Display Live Demo ( Handphone )', 'Non Merchandise', '', '', 'PC', ''),
(17, 'ALARM KAMERA', 'Alarm Pengaman (Kamera)', 'Non Merchandise', '', '', 'PC', ''),
(18, 'ALARM MINI RING', 'Alarm Mini Ring Type', 'Non Merchandise', '', '', 'PC', ''),
(19, 'ALARM TEMPEL', 'Alarm Pengaman (Tempel)', 'Non Merchandise', '', '', 'PC', ''),
(20, 'ALAT PEMADAM API', 'Alat Pemadam Api Ringan ( APAR )', 'Non Merchandise', '', '', 'PC', ''),
(21, 'ALPHARD', 'ALPHARD', 'Non Merchandise', '', '', 'PC', ''),
(22, 'AMPLOP CKLT 25X19', 'Ampolp Coklat 25 x 19 cm', 'Non Merchandise', '', '', 'PC', ''),
(23, 'AMPLOP COKLAT 1/2F', 'Amplop Coklat 1/2 Folio', 'Non Merchandise', '', '', 'PC', ''),
(24, 'AMPLOP COKLAT A3', 'Amplop Coklat A3', 'Non Merchandise', '', '', 'PC', ''),
(25, 'AMPLOP COKLAT F', 'Amplop Coklat Folio', 'Non Merchandise', '', '', 'PC', ''),
(26, 'AMPLOP FOLIO A M', 'Amplop Folio Air Mail', 'Non Merchandise', '', '', 'PC', ''),
(27, 'AMPLOP PUTIH 110', 'Amplop Putih  110', 'Non Merchandise', '', '', 'PC', ''),
(28, 'AMPLOP PUTIH 90', 'Amplop Putih  90', 'Non Merchandise', '', '', 'PC', ''),
(29, 'AMPLOP SURAT', 'AMPLOP SURAT', 'Non Merchandise', '', '', 'PC', ''),
(30, 'AMPLOP SURAT KACA', 'AMPLOP SURAT KACA', 'Non Merchandise', '', '', 'PC', ''),
(31, 'AMPOLP CKT 25.5X14', 'Ampolp Coklat 25.5 x 14 cm', 'Non Merchandise', '', '', 'PC', ''),
(32, 'ASURANSI', 'Asuransi', 'Non Merchandise', '', '', 'PC', ''),
(33, 'AVANZA', 'AVANZA', 'Non Merchandise', '', '', 'PC', ''),
(34, 'BAK STEMPEL NO.1', 'Bak Stempel No.1', 'Non Merchandise', '', '', 'PC', ''),
(35, 'BANNER RAIL', 'BANNER RAIL', 'Non Merchandise', '', '', 'PC', ''),
(36, 'BATERAI  AA', 'Baterai Energizer  “ AA\"', 'Non Merchandise', '', '', 'PC', ''),
(37, 'BATERAI AAA', 'Baterai Energizer  “ AAA “', 'Non Merchandise', '', '', 'PC', ''),
(38, 'BATRAY RECHARGEBLE', 'Baetray Sanyo Rechargeble', 'Non Merchandise', '', '', 'PC', ''),
(39, 'BATRE KKLATR LR 44', 'Baterray Karkulator LR 44', 'Non Merchandise', '', '', 'PC', ''),
(40, 'BATRE KKLATR868L', 'Baterray Karkulator 868 L', 'Non Merchandise', '', '', 'PC', ''),
(41, 'BATRE KKLATRLR1330', 'Baterray Karkulator LR 1330', 'Non Merchandise', '', '', 'PC', ''),
(42, 'BILLBOARD', 'Billboard', 'Non Merchandise', '', '', 'PC', ''),
(43, 'BINDER CLIP 105', 'Binder Clip 105', 'Non Merchandise', '', '', 'PC', ''),
(44, 'BINDER CLIP 107', 'Binder Clip Kecil 107', 'Non Merchandise', '', '', 'PC', ''),
(45, 'BINDER CLIP 111', 'Binder Clip Kecil 111', 'Non Merchandise', '', '', 'PC', ''),
(46, 'BINDER CLIP 115', 'Binder Clip Sedang 115', 'Non Merchandise', '', '', 'PC', ''),
(47, 'BINDER CLIP 155', 'Binder Clip Sedang 155', 'Non Merchandise', '', '', 'PC', ''),
(48, 'BINDER CLIP 200', 'Binder Clip Sedang 200', 'Non Merchandise', '', '', 'PC', ''),
(49, 'BLOCK NOTE NO 15', 'Block Note No 15', 'Non Merchandise', '', '', 'PC', ''),
(50, 'BIAYA INSERTION', 'Biaya Insertion', 'Non Merchandise', '', '', 'PC', ''),
(51, 'BOX FILE', 'Box File', 'Non Merchandise', '', '', 'PC', ''),
(52, 'BOX UNDIAN (ACRY)', 'BOX UNDIAN (ACRYLIC)', 'Non Merchandise', '', '', 'PC', ''),
(53, 'BRANKAS CHUBB', 'Brankas  Chubb Kasteel Size I', 'Non Merchandise', '', '', 'PC', ''),
(54, 'BUKTI POT PPH FINA', 'Bukti Potongan PPh Final Pasal 4 ayat 3', 'Non Merchandise', '', '', 'PC', ''),
(55, 'BUKU EXPD 100LB', 'Buku Exspedisi 100 Lb', 'Non Merchandise', '', '', 'PC', ''),
(56, 'BUKU FOLIO 100 LBR', 'Buku Folio Isi 100 Lbr', 'Non Merchandise', '', '', 'PC', ''),
(57, 'BUKU KWARTO100 LB', 'Buku Kwarto100 Lb', 'Non Merchandise', '', '', 'PC', ''),
(58, 'BUKU TULIS 38 LBR', 'Buku Tulis Isi 38 Lbr', 'Non Merchandise', '', '', 'PC', ''),
(59, 'BUSA HITUNG UANG', 'Busa Hitung Uang', 'Non Merchandise', '', '', 'PC', ''),
(60, 'BUSSINESS FILE', 'Bussiness File Biru', 'Non Merchandise', '', '', 'PC', ''),
(61, 'CAMERA DIGITAL', 'CAMERA DIGITAL', 'Non Merchandise', '', '', 'PC', ''),
(62, 'CANON 88', 'CANON 88', 'Non Merchandise', '', '', 'PC', ''),
(63, 'CANON 98', 'CANON 98', 'Non Merchandise', '', '', 'PC', ''),
(64, 'CANON PIXMA PG-810', 'CANON PIXMA PG - 810', 'Non Merchandise', '', '', 'PC', ''),
(65, 'CANON PIXMA PG811', 'CANON PIXMA PG - 811', 'Non Merchandise', '', '', 'PC', ''),
(66, 'CADDY SET 83122', 'Caddy Set 83122', 'Non Merchandise', '', '', 'PC', ''),
(67, 'CASH BOX', 'Cash Box', 'Non Merchandise', '', '', 'PC', ''),
(68, 'CATALOG', 'Catalog', 'Non Merchandise', '', '', 'PC', ''),
(69, 'CATRIDGE LQ 2180', 'Catridge Printer LQ 2180', 'Non Merchandise', '', '', 'PC', ''),
(70, 'CATRIDGE LX 300', 'Catridge Printer LX 300', 'Non Merchandise', '', '', 'PC', ''),
(71, 'CD CASING', 'CD Casing', 'Non Merchandise', '', '', 'PC', ''),
(72, 'CD-R / 100PCS', 'CD-R / 100pcs', 'Non Merchandise', '', '', 'PC', ''),
(73, 'CD-R / 50PCS', 'CD-R / 50pcs', 'Non Merchandise', '', '', 'PC', ''),
(74, 'CD-RW', 'CD-RW', 'Non Merchandise', '', '', 'PC', ''),
(75, 'CLEAR HOLD KANCING', 'Clear Holder Kancing', 'Non Merchandise', '', '', 'PC', ''),
(76, 'CLEAR HOLDER', 'Clear Holder/Map bening', 'Non Merchandise', '', '', 'PC', ''),
(77, 'COMPUTER FILE 1564', 'Computer File 1564', 'Non Merchandise', '', '', 'PC', ''),
(78, 'CONTAINER BOX', 'CONTAINER BOX', 'Non Merchandise', '', '', 'PC', ''),
(79, 'CONTINOUS A4 1 PLY', 'Continous Form A4 9 1/2X11\'\' 1 Ply', 'Non Merchandise', '', '', 'PC', ''),
(80, 'CONTINOUS A4 2 PLY', 'Continous Form A4 9 1/2X11\'\'/2 2 Ply', 'Non Merchandise', '', '', 'PC', ''),
(81, 'CONTINOUS A4 3 PLY', 'Continous Form A4 9 1/2X11\'\'/2 3 Ply', 'Non Merchandise', '', '', 'PC', ''),
(82, 'CONTINOUS A4 4 PLY', 'Continous Form A4 9 1/2X11\'\'/2 4 Ply', 'Non Merchandise', '', '', 'PC', ''),
(83, 'CONTINUOUS 14 1PLY', 'Continuous Form 14 7/8 X11 1Ply', 'Non Merchandise', '', '', 'PC', ''),
(84, 'CRV', 'CRV', 'Non Merchandise', '', '', 'PC', ''),
(85, 'CSR', 'CSR', 'Non Merchandise', '', '', 'PC', ''),
(86, 'CUST FEEDBACK FORM', 'Customer Feedback Form', 'Non Merchandise', '', '', 'PC', ''),
(87, 'CUTTER BESAR L 500', 'Cutter Besar L 500', 'Non Merchandise', '', '', 'PC', ''),
(88, 'CUTTER KECIL A300', 'Cutter Kecil A300', 'Non Merchandise', '', '', 'PC', ''),
(89, 'CYL PLASTIK BAG L', 'Cylinder plastik bag L', 'Non Merchandise', '', '', 'PC', ''),
(90, 'CYL PLASTIK BAG M', 'Cylinder plastik bag M', 'Non Merchandise', '', '', 'PC', ''),
(91, 'CYL PLASTIK BAG S', 'Cylinder plastik bag S', 'Non Merchandise', '', '', 'PC', ''),
(92, 'DEVIDER ISI 10', 'Devider Isi 10', 'Non Merchandise', '', '', 'PC', ''),
(93, 'DEVIDER ISI 12', 'Devider Isi 12', 'Non Merchandise', '', '', 'PC', ''),
(94, 'DECORATION', 'Decoration', 'Non Merchandise', '', '', 'PC', ''),
(95, 'DETEACHER', 'Deteacher', 'Non Merchandise', '', '', 'PC', ''),
(96, 'DIGITAL MARKETING', 'Digital Marketing', 'Non Merchandise', '', '', 'PC', ''),
(97, 'DISPENSER SANKEN', 'Dispenser Sanken', 'Non Merchandise', '', '', 'PC', ''),
(98, 'DISPENSER TAPE 50', 'Dispenser Tape 50 Besar', 'Non Merchandise', '', '', 'PC', ''),
(99, 'DISPENSER TAPE TD2', 'Dispenser Tape Joyco TD-2', 'Non Merchandise', '', '', 'PC', ''),
(100, 'DISPLAY LOCK', 'Display Lock', 'Non Merchandise', '', '', 'PC', ''),
(101, 'DOC KEEP 20 SHEET', 'Document Keper 20 Sheet Biru', 'Non Merchandise', '', '', 'PC', ''),
(102, 'DOC KEEP 40 SHEET', 'Document Keper 40 Sheet Hitam', 'Non Merchandise', '', '', 'PC', ''),
(103, 'DOC KEEP 60 SHEET', 'Document Keper 60 Sheet Hitam', 'Non Merchandise', '', '', 'PC', ''),
(104, 'DONATION', 'Donation', 'Non Merchandise', '', '', 'PC', ''),
(105, 'DOUBLE TIP 1\"', 'Double tip 1\"', 'Non Merchandise', '', '', 'PC', ''),
(106, 'DOUBLE TIP 1/2\"', 'Double tip 1/2\"', 'Non Merchandise', '', '', 'PC', ''),
(107, 'DOUBLE TIP 2\"', 'Double tip 2\"', 'Non Merchandise', '', '', 'PC', ''),
(108, 'DOUBLE TIP BUSA', 'Double tip Hijau Busa', 'Non Merchandise', '', '', 'PC', ''),
(109, 'DUPLEK', 'Duplek', 'Non Merchandise', '', '', 'PC', ''),
(110, 'DVD - RW', 'DVD - RW', 'Non Merchandise', '', '', 'PC', ''),
(111, 'DVD-R 4.7 GIGA', 'Dvd-R 4.7 Giga', 'Non Merchandise', '', '', 'PC', ''),
(112, 'E-COMMERCE', 'E-Commerce', 'Non Merchandise', '', '', 'PC', ''),
(113, 'EASEL', 'EASEL', 'Non Merchandise', '', '', 'PC', ''),
(114, 'ENTERTAINMENT', 'ENTERTAINMENT', 'Non Merchandise', '', '', 'PC', ''),
(115, 'EPSON C 90/T11/T13', 'EPSON c 90 / T 11 /T 13', 'Non Merchandise', '', '', 'PC', ''),
(116, 'EVENT', 'Event', 'Non Merchandise', '', '', 'PC', ''),
(117, 'EVEREST', 'EVEREST', 'Non Merchandise', '', '', 'PC', ''),
(118, 'EXPND FILE 8810BTX', 'Expanding File 8810 Bantex', 'Non Merchandise', '', '', 'PC', ''),
(119, 'FAKTUR PAJAK', 'FAKTUR PAJAK', 'Non Merchandise', '', '', 'PC', ''),
(120, 'FILLING CAB. HP', 'Filling Cabinet Tempat Penitipan HP', 'Non Merchandise', '', '', 'PC', ''),
(121, 'FILLING CABINET', 'Filling Cabinet', 'Non Merchandise', '', '', 'PC', ''),
(122, 'FILM 136 A', 'Film 136 A', 'Non Merchandise', '', '', 'PC', ''),
(123, 'FILM 55 A', 'Film 55 A', 'Non Merchandise', '', '', 'PC', ''),
(124, 'FILM 93 A', 'Film 93 A', 'Non Merchandise', '', '', 'PC', ''),
(125, 'FILM PANASNC 136A', 'Film Panasonic 136 A', 'Non Merchandise', '', '', 'PC', ''),
(126, 'FILM PANASNC 55 A', 'Film Panasonic 55 A', 'Non Merchandise', '', '', 'PC', ''),
(127, 'FILM PANASNC 93 A', 'Film Panasonic 93 A', 'Non Merchandise', '', '', 'PC', ''),
(128, 'FILM PNSNC KXFC225', 'Film Panasonic KX-FC-225', 'Non Merchandise', '', '', 'PC', ''),
(129, 'FINGER PRINT', 'Finger Print', 'Non Merchandise', '', '', 'PC', ''),
(130, 'FLYER A5', 'Flyer A5', 'Non Merchandise', '', '', 'PC', ''),
(131, 'FORM BLANK', 'FORM BLANK', 'Non Merchandise', '', '', 'PC', ''),
(132, 'FORTUNER', 'FORTUNER', 'Non Merchandise', '', '', 'PC', ''),
(133, 'GUN STAPLER', 'GUN STAPLER', 'Non Merchandise', '', '', 'PC', ''),
(134, 'GUNTING BESAR-LL', 'Gunting Besar-LL', 'Non Merchandise', '', '', 'PC', ''),
(135, 'GUNTING HITAM INEX', 'Gunting Hitam INEX', 'Non Merchandise', '', '', 'PC', ''),
(136, 'GUNTING KECIL-MM', 'Gunting Kecil-MM', 'Non Merchandise', '', '', 'PC', ''),
(137, 'GRAND LIVINA', 'GRAND LIVINA', 'Non Merchandise', '', '', 'PC', ''),
(138, 'HANG MAP FUJITA', 'Hang Map Fujita', 'Non Merchandise', '', '', 'PC', ''),
(139, 'HANGING BANNER', 'Hanging Banner', 'Non Merchandise', '', '', 'PC', ''),
(140, 'HANGING MAP', 'Hanging Map', 'Non Merchandise', '', '', 'PC', ''),
(141, 'HOOK BANNER RAIL', 'HOOK UNTUK BANNER RAIL', 'Non Merchandise', '', '', 'PC', ''),
(142, 'HP 45', 'HP 45', 'Non Merchandise', '', '', 'PC', ''),
(143, 'HP 950', 'HP 950', 'Non Merchandise', '', '', 'PC', ''),
(144, 'HP 951', 'HP 951', 'Non Merchandise', '', '', 'PC', ''),
(145, 'HP 78', 'HP 78', 'Non Merchandise', '', '', 'PC', ''),
(146, 'HT MOTOROLA', 'HT Motorola', 'Non Merchandise', '', '', 'PC', ''),
(147, 'INVOICE KASIR', 'INVOICE KASIR', 'Non Merchandise', '', '', 'PC', ''),
(148, 'INVOICE MANUAL', 'INVOICE MANUAL', 'Non Merchandise', '', '', 'PC', ''),
(149, 'ISI CURTER BESAR', 'Isi Curter Besar', 'Non Merchandise', '', '', 'PC', ''),
(150, 'ISI CURTER KECIL', 'Isi Curter Kecil', 'Non Merchandise', '', '', 'PC', ''),
(151, 'ISI PENSIL 2 B 05', 'Isi Pensil 2 B 05', 'Non Merchandise', '', '', 'PC', ''),
(152, 'ISI PENSIL 2 B 07', 'Isi Pensil 2 B 07', 'Non Merchandise', '', '', 'PC', ''),
(153, 'ISI PENSIL 2 B 2.0', 'Isi Pensil 2 B 2.0', 'Non Merchandise', '', '', 'PC', ''),
(154, 'ISI STEPLES BESAR', 'Isi Steples Besar', 'Non Merchandise', '', '', 'PC', ''),
(155, 'ISI STEPLES KECIL', 'Isi Steples Kecil/Max', 'Non Merchandise', '', '', 'PC', ''),
(156, 'ISI STEPLES NO.10', 'Isi Steples Kecil no.10', 'Non Merchandise', '', '', 'PC', ''),
(157, 'ISOLASI 1 X72', 'Isolasi 1 X72', 'Non Merchandise', '', '', 'PC', ''),
(158, 'ISOLASI 1/2 X72', 'Isolasi 1/2 X72', 'Non Merchandise', '', '', 'PC', ''),
(159, 'ISOLASI KCL 1/2X10', 'Isolasi Kecil 1/2 X 10', 'Non Merchandise', '', '', 'PC', ''),
(160, 'JAM DINDING', 'Jam Dinding', 'Non Merchandise', '', '', 'PC', ''),
(161, 'KARTU STOCK', 'KARTU STOCK', 'Non Merchandise', '', '', 'PC', ''),
(162, 'KABEL ALARM', 'Kabel Alarm', 'Non Merchandise', '', '', 'PC', ''),
(163, 'KALKTR SDC-8530L', 'Karkulator Citizen SDC-8530 L', 'Non Merchandise', '', '', 'PC', ''),
(164, 'KALKTR SDC-868 L', 'Karkulator Citizen SDC-868 L', 'Non Merchandise', '', '', 'PC', ''),
(165, 'KARET GELANG SUPER', 'Karet Gelang Super', 'Non Merchandise', '', '', 'PC', ''),
(166, 'KARTU ABSEN APEL', 'Kartu Absen Apel', 'Non Merchandise', '', '', 'PC', ''),
(167, 'KERTAS A3', 'Kertas A3', 'Non Merchandise', '', '', 'PC', ''),
(168, 'KERTAS A4 70 GR', 'Kertas A4 70 Gr', 'Non Merchandise', '', '', 'PC', ''),
(169, 'KERTAS FAX', 'Kertas Fax', 'Non Merchandise', '', '', 'PC', ''),
(170, 'KERTAS FOTO ISI 20', 'Kertas Foto isi 20', 'Non Merchandise', '', '', 'PC', ''),
(171, 'KERTAS POP A4', 'Kertas Pop A4', 'Non Merchandise', '', '', 'PC', ''),
(172, 'KERTAS POP A5', 'Kertas Pop A5', 'Non Merchandise', '', '', 'PC', ''),
(173, 'KEY BOX', 'Key Box', 'Non Merchandise', '', '', 'PC', ''),
(174, 'KIJANG', 'KIJANG', 'Non Merchandise', '', '', 'PC', ''),
(175, 'KERTAS BUFFALO', 'Kertas Buffalo', 'Non Merchandise', '', '', 'PC', ''),
(176, 'KERTAS BURAM', 'Kertas Buram', 'Non Merchandise', '', '', 'PC', ''),
(177, 'KERTAS CNCRD 80293', 'Kertas Concorde Pink 80293', 'Non Merchandise', '', '', 'PC', ''),
(178, 'KERTAS CNCRD 82501', 'Kertas Concorde Krem 82501', 'Non Merchandise', '', '', 'PC', ''),
(179, 'KERTAS CNCRD 90 GR', 'Kertas Concorde Putih 90 Gr', 'Non Merchandise', '', '', 'PC', ''),
(180, 'KERTAS F4', 'Kertas F4', 'Non Merchandise', '', '', 'PC', ''),
(181, 'KOP SURAT', 'KOP SURAT', 'Non Merchandise', '', '', 'PC', ''),
(182, 'KORAN', 'Koran', 'Non Merchandise', '', '', 'PC', ''),
(183, 'KOSTUM EC MAN', 'KOSTUM EC MAN', 'Non Merchandise', '', '', 'PC', ''),
(184, 'KUNCI GEMBOK', 'Kunci Gembok', 'Non Merchandise', '', '', 'PC', ''),
(185, 'KWITANSI BESAR', 'Kwitansi Besar Sidu', 'Non Merchandise', '', '', 'PC', ''),
(186, 'KWITANSI KECIL', 'Kwitansi Kecil Sidu', 'Non Merchandise', '', '', 'PC', ''),
(187, 'KURSI DIREKSI', 'Kursi Direksi', 'Non Merchandise', '', '', 'PC', ''),
(188, 'KURSI HADAP', 'Kursi Hadap', 'Non Merchandise', '', '', 'PC', ''),
(189, 'KURSI HADAP PANAMA', 'Kursi Hadap Panama Dining Arm Chair', 'Non Merchandise', '', '', 'PC', ''),
(190, 'KURSI MGR CHAIRMAN', 'Kursi Manager Chairman DC-503', 'Non Merchandise', '', '', 'PC', ''),
(191, 'KURSI STAFF BIRU', 'Kursi Staff  Biru', 'Non Merchandise', '', '', 'PC', ''),
(192, 'KURSI STAFF HITAM', 'Kursi Staff  Hitam', 'Non Merchandise', '', '', 'PC', ''),
(193, 'KURSI TUNGGU', 'Kursi Tunggu ( Tanpa Sandaran )', 'Non Merchandise', '', '', 'PC', ''),
(194, 'L 300', 'L 300', 'Non Merchandise', '', '', 'PC', ''),
(195, 'LAB PRICE TAG X_S', 'LABEL HOLDER Price Tag X_S', 'Non Merchandise', '', '', 'PC', ''),
(196, 'LABOUR', 'BIAYA UPAH TENAGA BURUH HARIAN', 'Non Merchandise', '', '', 'PC', ''),
(197, 'LAKBAN BENING BSR', 'Lakban Bening Besar', 'Non Merchandise', '', '', 'PC', ''),
(198, 'LAKBAN COKLAT 2\"', 'lakban coklat 2\"', 'Non Merchandise', '', '', 'PC', ''),
(199, 'LAKBAN HITAM BESAR', 'lakban Hitam Besar', 'Non Merchandise', '', '', 'PC', ''),
(200, 'LAKBAN KERTAS', 'lakban Kertas', 'Non Merchandise', '', '', 'PC', ''),
(201, 'LAPORAN PENJ CASH', 'LAPORAN PENJUALAN CASH', 'Non Merchandise', '', '', 'PC', ''),
(202, 'LEGENDA', 'LEGENDA', 'Non Merchandise', '', '', 'PC', ''),
(203, 'LEM AIBON', 'Lem Aibon', 'Non Merchandise', '', '', 'PC', ''),
(204, 'LEM FOAM', 'Lem Foam', 'Non Merchandise', '', '', 'PC', ''),
(205, 'LEM O GLUE', 'Lem O Glue', 'Non Merchandise', '', '', 'PC', ''),
(206, 'LEM STICK 15GR', 'Lem  Stick Kenko 15gr', 'Non Merchandise', '', '', 'PC', ''),
(207, 'LEMARI ACCESSORIES', 'Lemari tempat Accessories', 'Non Merchandise', '', '', 'PC', ''),
(208, 'LEMARI ARSIP', 'Lemari arsip', 'Non Merchandise', '', '', 'PC', ''),
(209, 'LEMARI BESI KACA', 'LEMARI BESI KACA - SLIDING', 'Non Merchandise', '', '', 'PC', ''),
(210, 'LEXMARK 32', 'LEXMARK 32', 'Non Merchandise', '', '', 'PC', ''),
(211, 'LEXMARK 33', 'LEXMARK 33', 'Non Merchandise', '', '', 'PC', ''),
(212, 'LOKER 8 PINTU', 'Loker Karyawan 8 pintu', 'Non Merchandise', '', '', 'PC', ''),
(213, 'MAP LETTER 6001', 'Map Letter File 6001 Kuning', 'Non Merchandise', '', '', 'PC', ''),
(214, 'MARKETING KIT', 'Marketing Kit', 'Non Merchandise', '', '', 'PC', ''),
(215, 'MEJA 1/2 BIRO', 'Meja 1/2 Biro Abu-abu', 'Non Merchandise', '', '', 'PC', ''),
(216, 'MEJA GBL 21', 'Meja GBL 21 Abu-abu', 'Non Merchandise', '', '', 'PC', ''),
(217, 'MEMO PAD', 'Memo Pad', 'Non Merchandise', '', '', 'PC', ''),
(218, 'MESIN FAX', 'Mesin Fax', 'Non Merchandise', '', '', 'PC', ''),
(219, 'MESIN HITUNG UANG', 'Mesin Hitung Uang', 'Non Merchandise', '', '', 'PC', ''),
(220, 'MIROR/KACA RIAS', 'Miror ( Kaca Rias )', 'Non Merchandise', '', '', 'PC', ''),
(221, 'MONEY DETECTOR', 'Money Detector', 'Non Merchandise', '', '', 'PC', ''),
(222, 'MYSTERY SHOPPER', 'Mystery Shopper', 'Non Merchandise', '', '', 'PC', ''),
(223, 'NAME CARD CASE', 'Name Card Case isi 400', 'Non Merchandise', '', '', 'PC', ''),
(224, 'NAME CARD HOLDER', 'Name Card Holder', 'Non Merchandise', '', '', 'PC', ''),
(225, 'NAME TAG MULTI', 'Name Tag Multi', 'Non Merchandise', '', '', 'PC', ''),
(226, 'NAME TAG VERTIKAL', 'Name Tag Vertikal', 'Non Merchandise', '', '', 'PC', ''),
(227, 'NEON BOX/ROAD SIGN', 'Neon Box/Road Sign', 'Non Merchandise', '', '', 'PC', ''),
(228, 'NEON SIGN', 'Neon sign / Letter Sign', 'Non Merchandise', '', '', 'PC', ''),
(229, 'NEW STORES OPENING', 'New Stores Opening', 'Non Merchandise', '', '', 'PC', ''),
(230, 'NOTA KECIL 1 RNGKP', 'Bon / Nota Kecil 1 Rangkap', 'Non Merchandise', '', '', 'PC', ''),
(231, 'ORDNER A4 145', 'Ordner/Gema A4 1451 Bantex', 'Non Merchandise', '', '', 'PC', ''),
(232, 'ORDNER BANTEX 1465', 'Orner Bantex 1465 Hitam', 'Non Merchandise', '', '', 'PC', ''),
(233, 'ORDNER FOLIO 1466', 'Ordner  folio 1466 Bantex  Hitam', 'Non Merchandise', '', '', 'PC', ''),
(234, 'ORDNER FOLIO KILAT', 'Ordner folio Mengkilat', 'Non Merchandise', '', '', 'PC', ''),
(235, 'ORDNER KWITANSI', 'Ordner kwitansi', 'Non Merchandise', '', '', 'PC', ''),
(236, 'ORDNER/GEMA FOLIO', 'Ordner/Gema folio', 'Non Merchandise', '', '', 'PC', ''),
(237, 'P/S REQUISITION', 'PURCHASE / SERVICE REQUISITION', 'Non Merchandise', '', '', 'PC', ''),
(238, 'PANTHER', 'PANTHER', 'Non Merchandise', '', '', 'PC', ''),
(239, 'PAPAN W/B', 'PAPAN W/B', 'Non Merchandise', '', '', 'PC', ''),
(240, 'PAPAN W/B 60 X 120', 'Papan W/B 60 x 120', 'Non Merchandise', '', '', 'PC', ''),
(241, 'PAPAN W/B 60 X 45', 'Papan W/B 60 X 45', 'Non Merchandise', '', '', 'PC', ''),
(242, 'PAPAN W/B 60 X 90', 'Papan W/B 60 X 90', 'Non Merchandise', '', '', 'PC', ''),
(243, 'PAPAN W/B 90 X 120', 'Papan W/B 90 x 120', 'Non Merchandise', '', '', 'PC', ''),
(244, 'PAYMENT REQUEST', 'PAYMENT REQUEST', 'Non Merchandise', '', '', 'PC', ''),
(245, 'PEMBOLONG BESAR', 'Pembolong Besar/Punch', 'Non Merchandise', '', '', 'PC', ''),
(246, 'PEMBOLONG KECIL', 'Pembolong Kecil/Punch', 'Non Merchandise', '', '', 'PC', ''),
(247, 'PEMINJAMAN KENDRAN', 'PEMINJAMAN KENDARAAN', 'Non Merchandise', '', '', 'PC', ''),
(248, 'PEMOTONG KERTAS', 'Pemotong Kertas', 'Non Merchandise', '', '', 'PC', ''),
(249, 'PENGGARIS BESI 30', 'Penggaris Besi 30 Cm', 'Non Merchandise', '', '', 'PC', ''),
(250, 'PENGGARIS PLSTK 30', 'Penggaris Plastik 30 Cm', 'Non Merchandise', '', '', 'PC', ''),
(251, 'PENGGARIS PLSTK 60', 'Penggaris Plastik 60 Cm', 'Non Merchandise', '', '', 'PC', ''),
(252, 'PENGHANCUR KERTAS', 'PENGHANCUR KERTAS', 'Non Merchandise', '', '', 'PC', ''),
(253, 'PENGHAPUS PENSIL', 'Penghapus pensil', 'Non Merchandise', '', '', 'PC', ''),
(254, 'PENGHAPUS WB BESAR', 'Penghapus W/B besar', 'Non Merchandise', '', '', 'PC', ''),
(255, 'PENSIL 2B BIASA', 'Pensil 2B Biasa', 'Non Merchandise', '', '', 'PC', ''),
(256, 'PENSIL HB BIASA', 'Pensil HB Biasa', 'Non Merchandise', '', '', 'PC', ''),
(257, 'PENSIL MEKANIK', 'Pensil Mekanik', 'Non Merchandise', '', '', 'PC', ''),
(258, 'PERBAIKAN', 'Perbaikan', 'Non Merchandise', '', '', 'PC', ''),
(259, 'PERTNGG JWBAN PDDK', 'PERTANGGUNG JAWAB PERJ. DINAS DALAM KOTA', 'Non Merchandise', '', '', 'PC', ''),
(260, 'PERTNGG JWBAN PDLK', 'PERTANGGUNG JAWAB PERJ. DINAS LUAR KOTA', 'Non Merchandise', '', '', 'PC', ''),
(261, 'PICK LIST', 'PICK LIST', 'Non Merchandise', '', '', 'PC', ''),
(262, 'PIGURA (VISI MISI)', 'Pigura ( Visi Misi )', 'Non Merchandise', '', '', 'PC', ''),
(263, 'PITA AMANO EX 3500', 'Pita Amano Ex 3500', 'Non Merchandise', '', '', 'PC', ''),
(264, 'PITA MESIN TIK', 'Pita Mesin Tik Arori', 'Non Merchandise', '', '', 'PC', ''),
(265, 'PLASTIK 1466BANTEX', 'Plastik 1466 Bantex Isi 25', 'Non Merchandise', '', '', 'PC', ''),
(266, 'PLASTIK 30X40/4 KG', 'Plastik Ukuran 30x40 / 4 Kg', 'Non Merchandise', '', '', 'PC', ''),
(267, 'PLASTIK BAG UK L', 'Plastik Bag uk L', 'Non Merchandise', '', '', 'PC', ''),
(268, 'PLASTIK BAG UK M', 'Plastik Bag uk M', 'Non Merchandise', '', '', 'PC', ''),
(269, 'PLASTIK BAG UK S', 'Plastik Bag uk S', 'Non Merchandise', '', '', 'PC', ''),
(270, 'PLASTIK UKUAN 2 KG', 'Plastik Ukuan 2 Kg', 'Non Merchandise', '', '', 'PC', ''),
(271, 'PLASTIK WRAPPING', 'Plastik Wrapping', 'Non Merchandise', '', '', 'PC', ''),
(272, 'POST IT 654 FLEXY', 'post it 654 flexy 7,5 x 7,5', 'Non Merchandise', '', '', 'PC', ''),
(273, 'POST IT 656 FLEXY', 'post it 656 flexy', 'Non Merchandise', '', '', 'PC', ''),
(274, 'POST IT MARK NOTE', 'post it Mark n Note', 'Non Merchandise', '', '', 'PC', ''),
(275, 'POCKET FILLE A4', 'Pocket File A4  2040 /100', 'Non Merchandise', '', '', 'PC', ''),
(276, 'POCKET FOLIO 2044', 'Pocket Bantex Folio 2044', 'Non Merchandise', '', '', 'PC', ''),
(277, 'POCKET FOLIO 5111', 'Pocket Folio 5111', 'Non Merchandise', '', '', 'PC', ''),
(278, 'POLE SIGN', 'POLE SIGN', 'Non Merchandise', '', '', 'PC', ''),
(279, 'POLYFOAM', 'Polyfoam', 'Non Merchandise', '', '', 'PC', ''),
(280, 'POST IT SIGN HERE', 'Post It Sign Here', 'Non Merchandise', '', '', 'PC', ''),
(281, 'POST IT WARNA/I', 'Post it Warna/I', 'Non Merchandise', '', '', 'PC', ''),
(282, 'POSTER A2', 'Poster A2', 'Non Merchandise', '', '', 'PC', ''),
(283, 'POSTER NEON BOX', 'Poster Neon Box', 'Non Merchandise', '', '', 'PC', ''),
(284, 'PRICE TAG LARGE', 'PVC Magnetic ( Price Tag Large)', 'Non Merchandise', '', '', 'PC', ''),
(285, 'PRICE TAG UK L', 'Kertas Price Tag uk L', 'Non Merchandise', '', '', 'PC', ''),
(286, 'PRICE TAG UK M', 'Kertas Price Tag uk M', 'Non Merchandise', '', '', 'PC', ''),
(287, 'PRICE TAG UK S', 'Kertas Price Tag uk S', 'Non Merchandise', '', '', 'PC', ''),
(288, 'PRICE TAG XTRA S', 'Kertas Price Tag Xtra S', 'Non Merchandise', '', '', 'PC', ''),
(289, 'PRINTING STIKER', 'Printing Stiker', 'Non Merchandise', '', '', 'PC', ''),
(290, 'PRINT SKIN', 'Print Skin', 'Non Merchandise', '', '', 'PC', ''),
(291, 'PRINTER EPSON', 'EPSON L 100 / L 200 / L 210', 'Non Merchandise', '', '', 'PC', ''),
(292, 'PRINTER EPSON 1390', 'EPSON 1390', 'Non Merchandise', '', '', 'PC', ''),
(293, 'PRINTING BUKU', 'Print Buku (Ci/Co, RF,TTK, PJ Cash, PR)', 'Non Merchandise', '', '', 'PC', ''),
(294, 'PRINTING CONTINUS', 'Printing Continuous', 'Non Merchandise', '', '', 'PC', ''),
(295, 'PRINTING KARTON', 'Printing Karton', 'Non Merchandise', '', '', 'PC', ''),
(296, 'PULPEN FASTER C6', 'Pulpen Faster C6 Biru', 'Non Merchandise', '', '', 'PC', ''),
(297, 'PULPEN FASTER C600', 'Pulpen Faster C 600 Biru', 'Non Merchandise', '', '', 'PC', ''),
(298, 'PULPEN JOYKO G PEN', 'Pulpen Joyko Gen Pen', 'Non Merchandise', '', '', 'PC', ''),
(299, 'PULPEN KENKO K-1', 'Pulpen Kenko Biru K-1 0.5', 'Non Merchandise', '', '', 'PC', ''),
(300, 'PULPEN SNOWMAN', 'Pulpen Snowman Hi-Grip V-2', 'Non Merchandise', '', '', 'PC', ''),
(301, 'PULPEN TRIFELO', 'Pulpen Trifelo u/ CC', 'Non Merchandise', '', '', 'PC', ''),
(302, 'PURCHASE ORDER', 'PURCHASE ORDER', 'Non Merchandise', '', '', 'PC', ''),
(303, 'PUSH PIN', 'Push Pin', 'Non Merchandise', '', '', 'PC', ''),
(304, 'PUSH PIN WARNA', 'Push Pin Warna', 'Non Merchandise', '', '', 'PC', ''),
(305, 'RADIO', 'Radio', 'Non Merchandise', '', '', 'PC', ''),
(306, 'RECEIPT FORM', 'RECEIPT FORM', 'Non Merchandise', '', '', 'PC', ''),
(307, 'RECEIVING NOTE', 'RECEIVING NOTE', 'Non Merchandise', '', '', 'PC', ''),
(308, 'REFIL EPSON LQ2180', 'Refil Epson LQ 2180', 'Non Merchandise', '', '', 'PC', ''),
(309, 'REFIL EPSON LX 300', 'Refil Epson Lx 300', 'Non Merchandise', '', '', 'PC', ''),
(310, 'REFILL PULPEN JOYK', 'Refill Pulpen Joyko Gen Pen 0.5', 'Non Merchandise', '', '', 'PC', ''),
(311, 'REFILL PULPEN KENK', 'Refill Pulpen Kenko Biru K-1 0.5', 'Non Merchandise', '', '', 'PC', ''),
(312, 'RENTAL TRUCK', 'BIAYA SEWA TRUCK TAMBAHAN', 'Non Merchandise', '', '', 'PC', ''),
(313, 'RENTAL WAREHOUSE', 'BIAYA SEWA GUDANG', 'Non Merchandise', '', '', 'PC', ''),
(314, 'REP STD ROUND BOX', 'REPAIR STANDING ROUND BOX', 'Non Merchandise', '', '', 'PC', ''),
(315, 'RETRIBUTION FEE', 'BIAYA KEAMANAN LINGKUNGAN GUDANG', 'Non Merchandise', '', '', 'PC', ''),
(316, 'RING SPR BESI 5/16', 'Ring Spiral Besi Putih 5/16', 'Non Merchandise', '', '', 'PC', ''),
(317, 'RING SPRL BESI 1/2', 'Ring Spiral Besi Putih 1/2', 'Non Merchandise', '', '', 'PC', ''),
(318, 'RING SPRL BESI 3/8', 'Ring Spiral Besi Putih 3/8', 'Non Merchandise', '', '', 'PC', ''),
(319, 'ROLL UP / X BANNER', 'X Banner', 'Non Merchandise', '', '', 'PC', ''),
(320, 'ROTARY LIGHT BOX', 'Rotary Light Box', 'Non Merchandise', '', '', 'PC', ''),
(321, 'SERAGAM CC', 'Seragam Customer Care n Tang Top', 'Non Merchandise', '', '', 'PC', ''),
(322, 'SERAGAM HELPER LOG', 'Seragam Helper Logistik', 'Non Merchandise', '', '', 'PC', ''),
(323, 'SEFFTY MIRROR', 'Seffty Mirror 600mm', 'Non Merchandise', '', '', 'PC', ''),
(324, 'SENTER BESAR', 'Senter Besar', 'Non Merchandise', '', '', 'PC', ''),
(325, 'SERAGAM ADMIN', 'Seragam Administrasi', 'Non Merchandise', '', '', 'PC', ''),
(326, 'SERAGAM KARYAWAN', 'Seragam Karyawan ( GPU,KASIR,TESTER )', 'Non Merchandise', '', '', 'PC', ''),
(327, 'SERAGAM LEADER', 'Seragam Leader Cotton Royal Classic', 'Non Merchandise', '', '', 'PC', ''),
(328, 'SERAGAM LOGISTIK', 'Seragam Staff , SPV Logistik', 'Non Merchandise', '', '', 'PC', ''),
(329, 'SERAGAM MAINTENANC', 'Seragam Maintenance', 'Non Merchandise', '', '', 'PC', ''),
(330, 'SERAGAM SPV', 'Seragam SPV  Cotton Royal Classic', 'Non Merchandise', '', '', 'PC', ''),
(331, 'SERAGAM STORE MGR', 'Seragam Store mngr Cotton Royar Classic', 'Non Merchandise', '', '', 'PC', ''),
(332, 'SERUTAN PENSIL KCL', 'Serutan Pensil kecil', 'Non Merchandise', '', '', 'PC', ''),
(333, 'SETORAN PAJAK', 'SETORAN PAJAK', 'Non Merchandise', '', '', 'PC', ''),
(334, 'SEWA LOKASI MEDIA', 'Sewa lokasi media', 'Non Merchandise', '', '', 'PC', ''),
(335, 'SIGNBOARD', 'Signboard', 'Non Merchandise', '', '', 'PC', ''),
(336, 'SLIP GAJI', 'SLIP GAJI', 'Non Merchandise', '', '', 'PC', ''),
(337, 'SOFT BOARD 60X90CM', 'Soft Board 60 x 90 cm', 'Non Merchandise', '', '', 'PC', ''),
(338, 'SOFTBOARD', 'SOFTBOARD', 'Non Merchandise', '', '', 'PC', ''),
(339, 'SPIDOL KCL 12 WARN', 'Spidol Kecil 12 Warna', 'Non Merchandise', '', '', 'PC', ''),
(340, 'SPIDOL KECIL BIRU', 'Spidol Kecil  Biru', 'Non Merchandise', '', '', 'PC', ''),
(341, 'SPIDOL KECIL HIJAU', 'Spidol Kecil  Hijau', 'Non Merchandise', '', '', 'PC', ''),
(342, 'SPIDOL KECIL HITAM', 'Spidol Kecil  Hitam', 'Non Merchandise', '', '', 'PC', ''),
(343, 'SPIDOL KECIL MERAH', 'Spidol Kecil  Merah', 'Non Merchandise', '', '', 'PC', ''),
(344, 'SPIDOL PERMANEN', 'Spidol  Permanen  Hijau', 'Non Merchandise', '', '', 'PC', ''),
(345, 'SPIDOL WHITE BOARD', 'Spidol  White Board Biru', 'Non Merchandise', '', '', 'PC', ''),
(346, 'SPONSORSHIP', 'Sponsorship', 'Non Merchandise', '', '', 'PC', ''),
(347, 'SPT MASA P 23/ 26', 'SPT Masa PPH Pasal 23 Dan/Aatu Pasal 26', 'Non Merchandise', '', '', 'PC', ''),
(348, 'SPT MASA P 4 A 2', 'SPT Masa PPH Final Pasal 4 Ayat 2', 'Non Merchandise', '', '', 'PC', ''),
(349, 'STABILO HIJAU', 'Stabilo Hijau', 'Non Merchandise', '', '', 'PC', ''),
(350, 'STABILO KUNING', 'Stabilo Kuning', 'Non Merchandise', '', '', 'PC', ''),
(351, 'STABILO ORANGE', 'Stabilo Orange', 'Non Merchandise', '', '', 'PC', ''),
(352, 'STABILO PINK', 'Stabilo Pink', 'Non Merchandise', '', '', 'PC', ''),
(353, 'STAMP', 'Stamp Store, Log, CC,Papan Nama,Tray', 'Non Merchandise', '', '', 'PC', ''),
(354, 'STANDING ASHTRAY', 'Standing Ashtray ( 38 x 80 cm )', 'Non Merchandise', '', '', 'PC', ''),
(355, 'STANDING BARRIERS', 'STANDING BARRIERS', 'Non Merchandise', '', '', 'PC', ''),
(356, 'STAPLE KECIL HD 10', 'Staeples kecil HD 10', 'Non Merchandise', '', '', 'PC', ''),
(357, 'STAPLER BSR HD 50', 'Strapler Besar HD 50', 'Non Merchandise', '', '', 'PC', ''),
(358, 'STD POP A4', 'STANDING POP A4', 'Non Merchandise', '', '', 'PC', ''),
(359, 'STD PSTER STAINA 2', 'STANDING POSTER STAINLESS A2', 'Non Merchandise', '', '', 'PC', ''),
(360, 'STEROFOAM', 'Sterofoam', 'Non Merchandise', '', '', 'PC', ''),
(361, 'STICKER', 'Sticker', 'Non Merchandise', '', '', 'PC', ''),
(362, 'STABILO BIRU', 'Stabilo Biru', 'Non Merchandise', '', '', 'PC', ''),
(363, 'STOP MAP 5002', 'Stop Map 5002 Warna Biru', 'Non Merchandise', '', '', 'PC', ''),
(364, 'STOP MAP N ACCO', 'Stop Map n Acco 5001', 'Non Merchandise', '', '', 'PC', ''),
(365, 'STOPMAP BIOLA 5002', 'Stop Map Biola 5002 Warna Biru', 'Non Merchandise', '', '', 'PC', ''),
(366, 'STORE MERCHANDISE', 'Store Merchandise', 'Non Merchandise', '', '', 'PC', ''),
(367, 'STICKER FIFO', 'Sticker Fifo ( Bulan Berjalan )', 'Non Merchandise', '', '', 'PC', ''),
(368, 'STICKER T N J 103', 'Sticker Tom n Jerry 103', 'Non Merchandise', '', '', 'PC', ''),
(369, 'STICKER T N J 110', 'Sticker Tom n Jerry 110', 'Non Merchandise', '', '', 'PC', ''),
(370, 'STICKER T N J 112', 'Sticker Tom n Jerry 112', 'Non Merchandise', '', '', 'PC', ''),
(371, 'STICKER T N J 115', 'Sticker Tom n Jerry 115 Bulat', 'Non Merchandise', '', '', 'PC', ''),
(372, 'STICKER T N J 121', 'Sticker Tom n Jerry 121', 'Non Merchandise', '', '', 'PC', ''),
(373, 'STICKER T N J 125', 'Sticker Tom n Jerry 125', 'Non Merchandise', '', '', 'PC', ''),
(374, 'STICKER T N J 126', 'Sticker Tom n Jerry 126', 'Non Merchandise', '', '', 'PC', ''),
(375, 'STICKER WOBBLER', 'Sticker Wobbler', 'Non Merchandise', '', '', 'PC', ''),
(376, 'STIKER BJ HOME', 'STIKER BJ HOME', 'Non Merchandise', '', '', 'PC', ''),
(377, 'STIKER FIFO', 'STIKER FIFO', 'Non Merchandise', '', '', 'PC', ''),
(378, 'STIKER STOKE TAKE', 'STIKER STOKE TAKE', 'Non Merchandise', '', '', 'PC', ''),
(379, 'STOCKROOM', 'Stockroom', 'Non Merchandise', '', '', 'PC', ''),
(380, 'SUPRA', 'SUPRA', 'Non Merchandise', '', '', 'PC', ''),
(381, 'TALI RAPIAH BESAR', 'Tali Rapiah Besar', 'Non Merchandise', '', '', 'PC', ''),
(382, 'TANDA TERIMA BRNG', 'TANDA TERIMA BARANG', 'Non Merchandise', '', '', 'PC', ''),
(383, 'TANDA TERIMA KASIR', 'TANDA TERIMA KASIR', 'Non Merchandise', '', '', 'PC', ''),
(384, 'TANDA TRMA TRK BRG', 'TANDA TERIMA PENARIKAN BARANG', 'Non Merchandise', '', '', 'PC', ''),
(385, 'TANGGA 3M', 'TANGGA 3M', 'Non Merchandise', '', '', 'PC', ''),
(386, 'TANGGA 5M', 'TANGGA 5M', 'Non Merchandise', '', '', 'PC', ''),
(387, 'TANGGA ALUMIN 2M', 'Tangga Aluminium 2 Meter', 'Non Merchandise', '', '', 'PC', ''),
(388, 'TELEPHONE', 'TELEPHONE', 'Non Merchandise', '', '', 'PC', ''),
(389, 'TEMPAT SAMPAH', 'Tempat Sampah', 'Non Merchandise', '', '', 'PC', ''),
(390, 'TINTA STAMP AUTO', 'Tinta Stamp Automatic Biru', 'Non Merchandise', '', '', 'PC', ''),
(391, 'TINTA STAMP PYRAMI', 'Tinta Stamp Pyramid Biru', 'Non Merchandise', '', '', 'PC', ''),
(392, 'TIP-EX', 'Tip-Ex Correction Pent', 'Non Merchandise', '', '', 'PC', ''),
(393, 'TIP-EX JOYKO', 'Tip-Ex Joyko', 'Non Merchandise', '', '', 'PC', ''),
(394, 'TONER 12 A', 'TONER 12 A', 'Non Merchandise', '', '', 'PC', ''),
(395, 'TONER 15 A', 'TONER 15 A', 'Non Merchandise', '', '', 'PC', ''),
(396, 'TONER 49 A', 'TONER 49 A', 'Non Merchandise', '', '', 'PC', ''),
(397, 'TONER 53 A', 'TONER 53 A', 'Non Merchandise', '', '', 'PC', ''),
(398, 'TONER 85 A', 'TONER 85 A', 'Non Merchandise', '', '', 'PC', ''),
(399, 'TRAFIC BOTON', 'Trafic Boton', 'Non Merchandise', '', '', 'PC', ''),
(400, 'TRAY 2 SUSUN', 'Tray 2 Susun', 'Non Merchandise', '', '', 'PC', ''),
(401, 'TRAY 3 SUSUN', 'Tray 3 Susun', 'Non Merchandise', '', '', 'PC', ''),
(402, 'TRAY EXECUTIVE 703', 'Tray 3 Susun Executive 703', 'Non Merchandise', '', '', 'PC', ''),
(403, 'TRIGONAL CLIP NO 3', 'Trigonal Clip No 3', 'Non Merchandise', '', '', 'PC', ''),
(404, 'TRIGONAL CLIP NO 5', 'Trigonal Clip No 5', 'Non Merchandise', '', '', 'PC', ''),
(405, 'TROLLY BESI 800KG', 'Trolly Besi 800Kg', 'Non Merchandise', '', '', 'PC', ''),
(406, 'TROLLY LIPAT 300KG', 'Trolly Lipat Bobot 300Kg', 'Non Merchandise', '', '', 'PC', ''),
(407, 'TVC', 'Tvc', 'Non Merchandise', '', '', 'PC', ''),
(408, 'WALL SIGN', 'WALL SIGN', 'Non Merchandise', '', '', 'PC', ''),
(409, 'WHITE BOARD', 'White Board', 'Non Merchandise', '', '', 'PC', ''),
(410, 'WIPHONE', 'Wiphone', 'Non Merchandise', '', '', 'PC', '');

-- --------------------------------------------------------

--
-- Table structure for table `api_asset`
--

CREATE TABLE `api_asset` (
  `id` int(11) NOT NULL,
  `companycode` varchar(255) DEFAULT NULL,
  `asset` varchar(255) DEFAULT NULL,
  `description` varchar(255) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

--
-- Dumping data for table `api_asset`
--

INSERT INTO `api_asset` (`id`, `companycode`, `asset`, `description`) VALUES
(1, 'EC01', '100000', 'Alfa Goldland Realty -Alam Sutera (Booking Fee)'),
(2, 'EC01', '200000', 'Asset IT'),
(3, 'EC01', '300000', 'Asset HRGA'),
(4, 'EC01', '400000', 'Asset PRODUCT'),
(5, 'EC01', '500000', 'Asset MNG');

-- --------------------------------------------------------

--
-- Table structure for table `api_costcenter`
--

CREATE TABLE `api_costcenter` (
  `id` int(11) NOT NULL,
  `companycode` varchar(255) DEFAULT NULL,
  `costcenter` varchar(255) DEFAULT NULL,
  `description` varchar(255) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

--
-- Dumping data for table `api_costcenter`
--

INSERT INTO `api_costcenter` (`id`, `companycode`, `costcenter`, `description`) VALUES
(1, 'EC01', 'E008100001', 'FINANCE'),
(2, 'EC01', 'E008100025', 'IT'),
(3, 'EC01', 'E008100067', 'PRODUCT'),
(4, 'EC01', 'E008100029', 'TENANT'),
(5, 'EC01', 'E008100023', 'HR');

-- --------------------------------------------------------

--
-- Table structure for table `api_gl`
--

CREATE TABLE `api_gl` (
  `id` int(11) NOT NULL,
  `companycode` varchar(255) DEFAULT NULL,
  `glaccount` varchar(255) DEFAULT NULL,
  `description` varchar(255) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

--
-- Dumping data for table `api_gl`
--

INSERT INTO `api_gl` (`id`, `companycode`, `glaccount`, `description`) VALUES
(1, 'EC01', '600001', 'Salaries & Wages'),
(2, 'EC01', '2216872', 'test1'),
(3, 'EC01', '12387612', 'test2'),
(4, 'EC01', '9872397', 'test3'),
(5, 'EC01', '378928', 'test4'),
(6, 'EC01', '289010', 'test5');

-- --------------------------------------------------------

--
-- Table structure for table `api_order`
--

CREATE TABLE `api_order` (
  `id` int(11) NOT NULL,
  `companycode` varchar(255) DEFAULT NULL,
  `order` varchar(255) DEFAULT NULL,
  `description` varchar(255) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

--
-- Dumping data for table `api_order`
--

INSERT INTO `api_order` (`id`, `companycode`, `order`, `description`) VALUES
(1, 'EC01', 'MATOS-C5', 'IT MATOS'),
(2, 'EC01', 'ECI-C5', 'ECI MNG'),
(3, 'EC01', 'ELANG-C4', 'ELANG'),
(4, 'EC01', 'HR-C3', 'HRGA'),
(5, 'EC01', 'IT-C5', 'IT ECI');

-- --------------------------------------------------------

--
-- Table structure for table `api_site`
--

CREATE TABLE `api_site` (
  `id` int(11) NOT NULL,
  `companycode` varchar(255) DEFAULT NULL,
  `sitecode` varchar(255) DEFAULT NULL,
  `name1` varchar(255) DEFAULT NULL,
  `name2` varchar(255) DEFAULT NULL,
  `alamat` varchar(255) DEFAULT NULL,
  `prctr` varchar(255) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

--
-- Dumping data for table `api_site`
--

INSERT INTO `api_site` (`id`, `companycode`, `sitecode`, `name1`, `name2`, `alamat`, `prctr`) VALUES
(1, 'EC01', 'DC01', 'CWH KLENDER-JIEP 01', NULL, 'JL. Klender Raya no.25', 'EC0120DC01'),
(2, 'EC01', 'DC02', 'CWH KLENDER-JIEP 02', NULL, 'JL. Klender Raya no.25', 'EC0120DC01'),
(3, 'EC01', 'DC03', 'CWH KLENDER-JIEP 03', NULL, 'JL. Klender Raya no.25', 'EC0120DC01'),
(4, 'EC01', '1000', 'EC - HEAD OFFICE', NULL, 'JL. Klender Raya no.25', 'EC0120DC01'),
(5, 'EC01', '3000', 'EC - DIRECT SALES', NULL, 'JL. Klender Raya no.25', 'EC0120DC01');

-- --------------------------------------------------------

--
-- Table structure for table `api_vendor`
--

CREATE TABLE `api_vendor` (
  `id` int(11) NOT NULL,
  `supplierCode` varchar(30) NOT NULL,
  `companyCode` varchar(20) NOT NULL,
  `name` varchar(100) DEFAULT NULL,
  `address1` varchar(255) DEFAULT NULL,
  `address2` varchar(255) DEFAULT NULL,
  `city` varchar(80) DEFAULT NULL,
  `postalCode` varchar(10) DEFAULT NULL,
  `contactPerson` varchar(100) DEFAULT NULL,
  `phone` varchar(50) DEFAULT NULL,
  `hp1` varchar(50) DEFAULT NULL,
  `hp2` varchar(50) DEFAULT NULL,
  `fax` varchar(50) DEFAULT NULL,
  `npwp` varchar(50) DEFAULT NULL,
  `email` varchar(100) DEFAULT NULL,
  `paymentTerm` int(11) DEFAULT NULL,
  `bankCode` varchar(20) DEFAULT NULL,
  `bankName` varchar(100) DEFAULT NULL,
  `bankBranchCode` varchar(20) DEFAULT NULL,
  `bankBranchName` varchar(100) DEFAULT NULL,
  `bankAccountNo` varchar(50) DEFAULT NULL,
  `status` varchar(20) DEFAULT NULL,
  `paymentTermCd` varchar(20) DEFAULT NULL,
  `dateCreate` date DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

--
-- Dumping data for table `api_vendor`
--

INSERT INTO `api_vendor` (`id`, `supplierCode`, `companyCode`, `name`, `address1`, `address2`, `city`, `postalCode`, `contactPerson`, `phone`, `hp1`, `hp2`, `fax`, `npwp`, `email`, `paymentTerm`, `bankCode`, `bankName`, `bankBranchCode`, `bankBranchName`, `bankAccountNo`, `status`, `paymentTermCd`, `dateCreate`) VALUES
(1, '1000', 'EC01', 'ECI head office', '', '0000022933', '', '', '', '', '', '', '', '', '', 0, '', '', '', '', '', '', '', '2014-10-08'),
(2, '300000', 'EC01', 'AKSARA CHANDRA', 'Jl. E Raya No.32 Cempaka Baru', '0000023127', 'JAKARTA', '10640', '', '08128338941', '', '', '', '', 'aksaraprint@yahoo.com', 14, '', '', '', '', '', '', 'V014', '2014-10-08'),
(3, '300001', 'EC01', 'ASA OUTDOOR PRODUCTION', 'Jl. H Abdul Gani No.82 Kamp. Bulak', '0000023128', 'JAKARTA', '15412', '', '', '', '', '', '', '', 14, '', '', '', '', '', '', 'V014', '2014-10-08'),
(4, '300002', 'EC01', 'BAKTI ARTHA REKSA SEJAHTERA, PT', 'Gd. Site Office Lt. 3', '0000023129', 'JAKARTA', '12190', '', '', '', '', '', '', '', 14, '', '', '', '', '', '', 'V014', '2014-10-08'),
(5, '300003', 'EC01', 'BALI ADPRO ADVERTISING', '37 Jl. Nangka', '0000023130', 'DENPASAR', '', '', '', '', '', '', '02.017.875.2-901.000', '', 14, '', '', '', '', '', '', 'V014', '2014-10-08'),
(6, '300004', 'EC01', 'BALI UNICORN, PT', 'Management office discovery shoppin', '0000023131', 'JAKARTA', '80361', '', '', '', '', '', '', '', 14, '', '', '', '', '', '', 'V014', '2014-10-08'),
(7, '300005', 'EC01', 'NEMO PRODUCTION', '80 Jl.Arsento', '0000023132', 'JAKARTA SELATAN', '15412', '', '', '', '', '', '', '', 14, '', '', '', '', '', '', 'V014', '2014-10-08'),
(8, '300006', 'EC01', 'CV. TITIPAN KILAT', 'Jakarta', '0000023133', 'JAKARTA', '', '', '', '', '', '', '', '', 14, '', '', '', '', '', '', 'V014', '2014-10-08'),
(9, '300007', 'EC01', 'CYBERINDO ADITAMA, PT', 'GD. Manggala Wanabakti Blok IV A/80', '0000023134', 'JAKARTA', '', '', '', '', '', '', '', '', 14, '', '', '', '', '', '', 'V014', '2014-10-08'),
(10, '300008', 'EC01', 'DAITO', 'Jl. Rijasa 1-2 Denpasar', '0000023135', 'BALI', '', '', '', '', '', '', '', '', 14, '', '', '', '', '', '', 'V014', '2014-10-08'),
(11, '300009', 'EC01', 'DANAPATI ABINAYA INVESTAMA, PT', 'Kawasan SCBD Jl. Jend. Sudirman', '0000023136', 'JAKARTA', '12190', '', '', '', '', '', '', '', 14, '', '', '', '', '', '', 'V014', '2014-10-08'),
(12, '300010', 'EC01', 'DANAYASA ARTHATAMA, PT', 'Jl. Jend. Sudirman Kav. 52-53', '0000023137', 'JAKARTA', '', '', '', '', '', '', '01.386.348.5.054.000', '', 14, '', '', '', '', '', '', 'V014', '2014-10-08'),
(13, '300011', 'EC01', 'DELLIS TAILOR', 'Jl. Raya Kepa 3 No.679, Tomang', '0000023138', 'JAKARTA', '11440', '', '', '', '', '', '1234123412341230', '', 14, '', '', '', '', '', '', 'V014', '2014-10-08'),
(14, '300012', 'EC01', 'EXPODIA KARTAYUDA INDONESIA', 'Jl. Jend. R.S. Soekanto No.75AB', '0000023139', 'JAKARTA', '13460', '', '', '', '', '', '1234123412341230', '', 14, '', '', '', '', '', '', 'V014', '2014-10-08'),
(15, '300013', 'EC01', 'GALANG PUTRA DEWATA', 'Jakarta', '0000023140', 'JAKARTA', '', '', '', '', '', '', '1234123412341230', '', 14, '', '', '', '', '', '', 'V014', '2014-10-08'),
(16, '300014', 'EC01', 'GEMILANG SUKSES ABADI', 'Jakarta', '0000023141', 'JAKARTA', '', '', '', '', '', '', '1234123412341230', '', 14, '', '', '', '', '', '', 'V014', '2014-10-08'),
(17, '300015', 'EC01', 'GRAHA BERKAT TRADING', 'Jakarta', '0000023142', 'JAKARTA', '', '', '', '', '', '', '1234123412341230', '', 14, '', '', '', '', '', '', 'V014', '2014-10-08'),
(18, '300016', 'EC01', 'INTISAR PRIMULA, PT', 'Jl. Pemuda No. 103', '0000023143', 'JAKARTA', '', '', '', '', '', '', '1234123412341230', '', 14, '', '', '', '', '', '', 'V014', '2014-10-08'),
(19, '300017', 'EC01', 'MUJUR FURNITURE', 'Jl. KH. Hasyim Ashari No.125', '0000023144', 'JAKARTA', '10150', '', '', '', '', '', '1234123412341230', '', 14, '', '', '', '', '', '', 'V014', '2014-10-08'),
(20, '300018', 'EC01', 'NEO AGA', 'Jl. Pulau Kawe 19', '0000023145', 'JAKARTA', '', '', '', '', '', '', '1234123412341230', '', 14, '', '', '', '', '', '', 'V014', '2014-10-08'),
(21, '300019', 'EC01', 'PT.PARADIGMA DIMENSI MATRA', 'JL.Cirendeu Raya Ruko Baliview Poin', '0000023146', 'JAKARTA', '15419', '', '', '', '', '', '1234123412341230', '', 14, '', '', '', '', '', '', 'V014', '2014-10-08'),
(22, '300020', 'EC01', 'PT. PANDUNEKA SEJAHTERA', 'Gd. Artha Graha KNTS Lot.15', '0000023147', 'JAKARTA', '', '', '', '', '', '', '1234123412341230', '', 14, '', '', '', '', '', '', 'V014', '2014-10-08'),
(23, '300021', 'EC01', 'PANFILA INDOSARI', 'Jakarta', '0000023148', 'JAKARTA', '', '', '', '', '', '', '', '', 14, '', '', '', '', '', '', 'V014', '2014-10-08'),
(24, '300022', 'EC01', 'PARISIEN PRINT', 'Jl. Pantai Kuta II/22 Ancol-Timur', '0000023149', 'JAKARTA', '', '', '', '', '', '', '', '', 14, '', '', '', '', '', '', 'V014', '2014-10-08'),
(25, '300023', 'EC01', 'PD. SUMBER ALAM', 'Jakarta', '0000023150', 'JAKARTA', '', '', '', '', '', '', '', '', 14, '', '', '', '', '', '', 'V014', '2014-10-08'),
(26, '300024', 'EC01', 'PRIMAJAYA ERATAMA', 'Jakarta', '0000023151', 'JAKARTA', '', '', '', '', '', '', '', '', 14, '', '', '', '', '', '', 'V014', '2014-10-08'),
(27, '300025', 'EC01', 'PT. RADIANCE', 'Jl. K.H. Hasyim Ashari No. 50A', '0000023152', 'JAKARTA', '10130', '', '', '', '', '', '', '', 14, '', '', '', '', '', '', 'V014', '2014-10-08'),
(28, '300026', 'EC01', 'SUMBER BERKAT ANUGRAH', '66 Jl.Tamansari Raya', '0000023153', 'JAKARTA BARAT', '', '', '', '', '', '', '02.063.118.0-032.000', '', 14, '', '', '', '', '', '', 'V014', '2014-10-08'),
(29, '300027', 'EC01', 'SUN MOTOR', 'Jl. Teuku Umar No.177', '0000023154', 'JAKARTA', '', '', '', '', '', '', '', '', 14, '', '', '', '', '', '', 'V014', '2014-10-08'),
(30, '300028', 'EC01', 'PT. SUPERMAL KARAWACI', '105 Boulevard Diponegoro 00-00', '0000023155', 'JAKARTA', '', '', '', '', '', '', '', '', 14, '', '', '', '', '', '', 'V014', '2014-10-08'),
(31, '300029', 'EC01', 'SURYA INFOKOM TEKINDO, CV', 'Jl. Suryalaya Raya No.29', '0000023156', 'JAKARTA', '', '', '', '', '', '', '', '', 14, '', '', '', '', '', '', 'V014', '2014-10-08'),
(32, '300030', 'EC01', 'SURYA JAYA', 'JITC Mangga Dua Lt.1 Blok E2 No.38', '0000023157', 'JAKARTA', '14430', '', '', '', '', '', '', '', 14, '', '', '', '', '', '', 'V014', '2014-10-08'),
(33, '300031', 'EC01', 'SWADAYA PANDUARTHA, PT', 'Rukan Artha Gading Niaga Blok C 31-', '0000023158', 'JAKARTA UTARA', '', '', '', '', '', '', '01.738.727.5.073.000', '', 14, '', '', '', '', '', '', 'V014', '2014-10-08'),
(34, '300032', 'EC01', 'TOPCOM MULTIPAP', 'Lt. UG No.27 - 35', '0000023159', 'JAKARTA', '', '', '', '', '', '', '', '', 14, '', '', '', '', '', '', 'V014', '2014-10-08'),
(35, '300033', 'EC01', 'TUNGGUL MAHENDRA JAYA', 'Jl. Kenari II No. 12A', '0000023160', 'JAKARTA', '', '', '', '', '', '', '', '', 14, '', '', '', '', '', '', 'V014', '2014-10-08'),
(36, '300034', 'EC01', 'KRISDIJANTO TANDRADINATA', 'Jl. Kartini No.106 & 112', '0000023161', 'DENPASAR', '', '', '', '', '', '', '04.112.344.9-901.000', '', 14, '', '', '', '', '', '', 'V014', '2014-10-08'),
(37, '300035', 'EC01', 'YASRI PRAMESTI, PT', 'Jakarta', '0000023162', 'JAKARTA', '', '', '', '', '', '', '', '', 14, '', '', '', '', '', '', 'V014', '2014-10-08'),
(38, '300036', 'EC01', 'YAYASAN KARYA CIPTA INDONESIA', 'Kartika Chandra Office  Building 6t', '0000023163', 'JAKARTA', '', '', '', '', '', '', '', '', 14, '', '', '', '', '', '', 'V014', '2014-10-08'),
(39, '300037', 'EC01', 'PUTERA WIDJAJA PERKASA', 'Jakarta', '0000023164', 'JAKARTA', '', '', '', '', '', '', '', '', 14, '', '', '', '', '', '', 'V014', '2014-10-08'),
(40, '300038', 'EC01', 'PT. COPINDO RENANTA', 'Pinus I No. 56 Taman Royal 1 RT.07', '0000023165', 'JAKARTA', '', '', '', '', '', '', '', '', 14, '', '', '', '', '', '', 'V014', '2014-10-08'),
(41, '300039', 'EC01', 'KREATAMA KONSEP SELARAS', '68 Graha Arteri mas', '0000023166', 'JAKARTA', '', '', '', '', '', '', '02.293.431.9-033.000', '', 14, '', '', '', '', '', '', 'V014', '2014-10-08'),
(42, '300040', 'EC01', 'GRAHA KARUNIA TRADING', 'Gedung Electronic City Jl. Jend. Su', '0000023167', 'JAKARTA', '', '', '', '', '', '', '', '', 14, '', '', '', '', '', '', 'V014', '2014-10-08'),
(43, '300041', 'EC01', 'PT JATI PIRANTI SOLUSINDO', 'GD.SONA TOPAS TOWER LT 5', '0000023168', 'JAKARTA', '12920', '', '', '', '', '', '', '', 14, '', '', '', '', '', '', 'V014', '2014-10-08'),
(44, '300042', 'EC01', 'KANTOR AKUNTAN PUBLIK MIRAWATI SENS', 'Intiland Tower Lt.7', '0000023169', 'JAKARTA PUSAT', '10220', '', '', '', '', '', '02.505.018.8-073.000', '', 14, '', '', '', '', '', '', 'V014', '2014-10-08'),
(45, '300045', 'EC01', 'PT.AGUNG MITRAPRAGA', 'Jl. Taman Pegangsaan Indah Blok T/1', '0000023172', 'JAKARTA', '', '', '', '', '', '', '', '', 14, '', '', '', '', '', '', 'V014', '2014-10-08'),
(46, '300046', 'EC01', 'PT. BAYU TERMALINDO UTAMA', 'Jakarta', '0000023173', 'JAKARTA', '', '', '', '', '', '', '', '', 14, '', '', '', '', '', '', 'V014', '2014-10-08'),
(47, '300047', 'EC01', 'PT.BANK NIAGA TBK', 'Jakarta', '0000023174', 'JAKARTA', '', '', '', '', '', '', '', '', 14, '', '', '', '', '', '', 'V014', '2014-10-08'),
(48, '300048', 'EC01', 'KURNIA JAYA ENGINEERING', 'Jakarta', '0000023175', 'JAKARTA', '', '', '', '', '', '', '', '', 14, '', '', '', '', '', '', 'V014', '2014-10-08'),
(49, '300049', 'EC01', 'PT.MITRA INTEGRASI INFORMATIKA', 'Jakarta', '0000023176', 'JAKARTA', '', '', '', '', '', '', '', '', 14, '', '', '', '', '', '', 'V014', '2014-10-08'),
(50, '300050', 'EC01', 'PT. SARANA JAYA DARMA LESTARI', 'Jakarta', '0000023177', 'JAKARTA', '', '', '', '', '', '', '', '', 14, '', '', '', '', '', '', 'V014', '2014-10-08'),
(51, '300051', 'EC01', 'PUMA NEON PRODUCTION', 'JL. Karya III NO.6 Wijaya Kusuma', '0000023178', 'JAKARTA', '11460', '', '', '', '', '', '', '', 14, '', '', '', '', '', '', 'V014', '2014-10-08'),
(52, '300052', 'EC01', 'DATA SCRIP BUSINESS SOLUTIONS', 'Jakarta', '0000023179', 'JAKARTA', '', '', '', '', '', '', '', '', 14, '', '', '', '', '', '', 'V014', '2014-10-08'),
(53, '300053', 'EC01', 'PT. SUPER EXIMSARI', 'Jakarta', '0000023180', 'JAKARTA', '', '', '', '', '', '', '', '', 14, '', '', '', '', '', '', 'V014', '2014-10-08'),
(54, '300054', 'EC01', 'PANCA GARDA UTAMA, PT', 'Jl. Pangeran Tubagus Angke', '0000023181', 'JAKARTA', '', '', '', '', '', '', '', '', 14, '', '', '', '', '', '', 'V014', '2014-10-08'),
(55, '300055', 'EC01', 'MAHAMERU MITRA KREASINDO', 'Jl. Raya Pulogebang No. 99B', '0000023182', 'JAKARTA', '13950', '', '', '', '', '', '', '', 14, '', '', '', '', '', '', 'V014', '2014-10-08'),
(56, '300056', 'EC01', 'PT. SENTRA MEDIA PARIWARA', 'Jl. Duri Kepa Raya No. 78', '0000023183', 'JAKARTA BARAT', '11510', '', '', '', '', '', '01.826.080.2-038.000', '', 14, '', '', '', '', '', '', 'V014', '2014-10-08'),
(57, '300057', 'EC01', 'PT. ISS INDONESIA', 'Graha Simatupang, Menara II Lt. 4', '0000023184', 'JAKARTA', '', '', '', '', '', '', '', '', 14, '', '', '', '', '', '', 'V014', '2014-10-08'),
(58, '300058', 'EC01', 'PURI DIBYA PROPERTY, PT', 'Jl. Karet Kemirimuka', '0000023185', 'JAKARTA', '', '', '', '', '', '', '', '', 14, '', '', '', '', '', '', 'V014', '2014-10-08'),
(59, '300059', 'EC01', 'GEN\'S COLLECTION', 'Jakarta', '0000023186', 'JAKARTA', '', '', '', '', '', '', '', '', 14, '', '', '', '', '', '', 'V014', '2014-10-08'),
(60, '300060', 'EC01', 'BOGOR ANGGANA CENDEKIA, PT', 'Gedung Botani Square', '0000023187', 'JAKARTA', '16127', '', '', '', '', '', '', '', 14, '', '', '', '', '', '', 'V014', '2014-10-08'),
(61, '300061', 'EC01', 'PT PERICOM NUSANTARA (JGN DIPAKE)', 'Glodok Plaza Lt.2 No.E3', '0000023188', 'JAKARTA', '', '', '', '', '', '', '', '', 14, '', '', '', '', '', '', 'V014', '2014-10-08'),
(62, '300062', 'EC01', 'PT. SURYA BHAKTI PERKASA', 'JL.ANGGARA NO.85 KARANG TENGAH', '0000023189', 'JAKARTA', '15157', '', '', '', '', '', '', '', 14, '', '', '', '', '', '', 'V014', '2014-10-08'),
(63, '300063', 'EC01', 'PT. ARTHAGRAHA GENERAL INSURANCE', 'Jakarta', '0000023190', 'JAKARTA', '', '', '', '', '', '', '', '', 14, '', '', '', '', '', '', 'V014', '2014-10-08'),
(64, '300064', 'EC01', 'YAYASAN KASIH BAGI BANGSA', 'Jl. Lingkar Luar Barat RT 003/002', '0000023191', 'JAKARTA', '', '', '', '', '', '', '', '', 14, '', '', '', '', '', '', 'V014', '2014-10-08'),
(65, '300065', 'EC01', 'KANTOR NOTARIS ERIANI,SH', 'jl.kramat raya no 60', '0000023192', 'JAKARTA', '', '', '', '', '', '', '', '', 14, '', '', '', '', '', '', 'V014', '2014-10-08'),
(66, '300066', 'EC01', 'DIRECT SALES,PT', 'Jakarta', '0000023193', 'JAKARTA', '', '', '', '', '', '', '', '', 14, '', '', '', '', '', '', 'V014', '2014-10-08'),
(67, '300067', 'EC01', 'HAWAII SENTOSA ABADI,PT', 'Jakarta', '0000023194', 'JAKARTA', '', '', '', '', '', '', '', '', 14, '', '', '', '', '', '', 'V014', '2014-10-08'),
(68, '300068', 'EC01', 'CV MAHA JAYA', 'Jl. H.A.R Syihab No. 5-B', '0000023195', 'MEDAN', '', '', '', '', '', '', '', '', 14, '', '', '', '', '', '', 'V014', '2014-10-08'),
(69, '300069', 'EC01', 'PT PENTAWIRA CIPTA INDONESIA', 'Jl. Sunter Danau Utara Agung', '0000023196', 'JAKARTA', '', '', '', '', '', '', '', '', 14, '', '', '', '', '', '', 'V014', '2014-10-08'),
(70, '300070', 'EC01', 'PT HANDAL SOLUSITAMA', 'Jl. Jembatan Tiga Raya No. 34', '0000023197', 'JAKARTA', '14440', '', '', '', '', '', '', '', 14, '', '', '', '', '', '', 'V014', '2014-10-08'),
(71, '300071', 'EC01', 'PT. LAUTAN BERLIAN UTAMA MOTOR', 'Jl. Matraman Raya No. 71-73', '0000023198', 'JAKARTA', '', '', '', '', '', '', '', '', 14, '', '', '', '', '', '', 'V014', '2014-10-08'),
(72, '300072', 'EC01', 'PT ASTRA INTERNATIONAL Tbk', 'Jl. Gaya Motor Raya No. 8', '0000023199', 'JAKARTA', '', '', '', '', '', '', '', '', 14, '', '', '', '', '', '', 'V014', '2014-10-08'),
(73, '300073', 'EC01', 'PT INFO CAHAYA HERO', '10-11 Jl. Boulevard Artha Gading Ni', '0000023200', 'JAKARTA UTARA', '', '', '', '', '', '', '02.270.634.5-046.000', '', 14, '', '', '', '', '', '', 'V014', '2014-10-08'),
(74, '300074', 'EC01', 'HENDROPRIYONO AND ASSOCIATES', 'Jl. Jend. Sudirman Kav. 52-53', '0000023201', 'JAKARTA', '', '', '', '', '', '', '02.596.633.4.012.000', '', 14, '', '', '', '', '', '', 'V014', '2014-10-08'),
(75, '300075', 'EC01', 'PT TUNAS RIDEAN TBK', 'Jl. Pecenongan No. 60-62', '0000023202', 'JAKARTA', '', '', '', '', '', '', '', '', 14, '', '', '', '', '', '', 'V014', '2014-10-08'),
(76, '300076', 'EC01', 'PRIJOHANDOJO, BOENTORO & CO.', 'Menara Imperium Lt. 27', '0000023203', 'JAKARTA', '', '', '', '', '', '', '', '', 14, '', '', '', '', '', '', 'V014', '2014-10-08'),
(77, '300077', 'EC01', 'PT.PRIMA KARYA BAHARI', 'Graha Dewi lantai 3', '0000023204', 'JAKARTA', '12140', '', '', '', '', '', '', '', 14, '', '', '', '', '', '', 'V014', '2014-10-08'),
(78, '300078', 'EC01', 'PT KILAP PROPERTINDO', 'Komplek Permata Senayan Blok E-30', '0000023205', 'JAKARTA', '', '', '', '', '', '', '', '', 14, '', '', '', '', '', '', 'V014', '2014-10-08'),
(79, '300079', 'EC01', 'PT. GAVRILA PERKASA', 'Paris Square Blok B No. 31 BSD RT01', '0000023206', 'JAKARTA', '', '', '', '', '', '', '', '', 14, '', '', '', '', '', '', 'V014', '2014-10-08'),
(80, '300080', 'EC01', 'PT.SARANA MUDA MANDIRI', 'Graha Atika Lt. 2', '0000023207', 'JAKARTA', '', '', '', '', '', '', '', '', 14, '', '', '', '', '', '', 'V014', '2014-10-08'),
(81, '300081', 'EC01', 'CITIBANK', 'Jakarta', '0000023208', 'JAKARTA', '', '', '', '', '', '', '', '', 14, '', '', '', '', '', '', 'V014', '2014-10-08'),
(82, '300082', 'EC01', 'ELZA SYARIEF & PARTNERS', 'Jl. Kramat Sentiong 38A', '0000023209', 'JAKARTA', '10450', '', '', '', '', '', '', '', 14, '', '', '', '', '', '', 'V014', '2014-10-08'),
(83, '300083', 'EC01', 'INDRAYANI,SUGIH&PARTNERS', 'Mayapada Tower Lantai 11', '0000023210', 'JAKARTA', '12920', '', '', '', '', '', '', '', 14, '', '', '', '', '', '', 'V014', '2014-10-08'),
(84, '300084', 'EC01', 'FIRST COMPUTINDO', 'Jakarta', '0000023211', 'JAKARTA', '', '', '', '', '', '', '', '', 14, '', '', '', '', '', '', 'V014', '2014-10-08'),
(85, '300085', 'EC01', 'MULTI KOMPUTERINDO MANDIRI', 'Jakarta', '0000023212', 'JAKARTA', '', '', '', '', '', '', '', '', 14, '', '', '', '', '', '', 'V014', '2014-10-08'),
(86, '300086', 'EC01', 'SURYA JAYA', 'Jakarta', '0000023213', 'JAKARTA', '', '', '', '', '', '', '', '', 14, '', '', '', '', '', '', 'V014', '2014-10-08'),
(87, '300087', 'EC01', 'DUA BENUA', 'ITC Blok C33 no3', '0000023214', 'JAKARTA', '', '', '', '', '', '', '', '', 14, '', '', '', '', '', '', 'V014', '2014-10-08'),
(88, '300088', 'EC01', 'MOORE STEPHENS', 'WISMA DARMALA SAKTI,7th FLOOR', '0000023215', 'JAKARTA', '10220', '', '', '', '', '', '', '', 14, '', '', '', '', '', '', 'V014', '2014-10-08'),
(89, '300089', 'EC01', 'WINIE S HADIPROJO', 'Graha Cempaka Mas Rukan Blok C / 16', '0000023216', 'JAKARTA', '10646', '', '', '', '', '', '', '', 14, '', '', '', '', '', '', 'V014', '2014-10-08'),
(90, '300090', 'EC01', 'IVAN TEKNIK', 'Jakarta', '0000023217', 'JAKARTA', '', '', '', '', '', '', '', '', 14, '', '', '', '', '', '', 'V014', '2014-10-08'),
(91, '300091', 'EC01', 'SIEN NIE DRINKING WATER', 'Vila Tanggerang Regency I Blok NB I', '0000023218', 'JAKARTA', '', '', '', '', '', '', '', '', 14, '', '', '', '', '', '', 'V014', '2014-10-08'),
(92, '300043', 'EC01', 'JAYA SENTOSA FURNITURE', 'Jakarta', '0000023170', 'JAKARTA', '', '', '', '', '', '', '', '', 14, '', '', '', '', '', '', 'V014', '2014-10-08'),
(93, '300044', 'EC01', 'BUSINESS NEWS', 'Jl. Abdul Muis No. 70', '0000023171', 'JAKARTA', '10160', '', '', '', '', '', '', '', 14, '', '', '', '', '', '', 'V014', '2014-10-08'),
(94, '300095', 'EC01', 'PD ANUGRAH MAS PERKASA', 'Jakarta', '0000023222', 'JAKARTA', '', '', '', '', '', '', '', '', 14, '', '', '', '', '', '', 'V014', '2014-10-08'),
(95, '300096', 'EC01', 'PT JOBSTREET INDONESIA', 'Gedung Wisma Bumi Putera Lantai 5', '0000023223', 'JAKARTA', '12910', '', '', '', '', '', '02.492.347.6.018.000', '', 14, '', '', '', '', '', '', 'V014', '2014-10-08'),
(96, '300097', 'EC01', 'CV HIKMAH BERSAMA', 'Jakarta', '0000023224', 'JAKARTA', '', '', '', '', '', '', '', '', 14, '', '', '', '', '', '', 'V014', '2014-10-08'),
(97, '300098', 'EC01', 'PT LUCKY SAKTI', 'Jl. Malabar No. 9', '0000023225', 'BANDUNG', '', '', '', '', '', '', '', '', 14, '', '', '', '', '', '', 'V014', '2014-10-08'),
(98, '300099', 'EC01', 'CV PRIMA INDO ADVERTISING', 'Jl. Ir. H. Juanda No. 7 C-D', '0000023226', 'JAKARTA', '', '', '', '', '', '', '', '', 14, '', '', '', '', '', '', 'V014', '2014-10-08'),
(99, '300100', 'EC01', 'PT YOUNG INDONESIA PRATAMA', 'Jl. Joglo raya no 25a kembangan', '0000023227', 'JAKARTA', '', '', '', '', '', '', '', '', 14, '', '', '', '', '', '', 'V014', '2014-10-08'),
(100, '300101', 'EC01', 'PT.KREASINET KOMERSINDO PRATAMA', 'Kelapa Puan Raya blok III B', '0000023228', 'JAKARTA', '14240', '', '', '', '', '', '', '', 14, '', '', '', '', '', '', 'V014', '2014-10-08'),
(101, '300102', 'EC01', 'THE NIELSEN COMPANY INDONESIA', 'Jakarta', '0000023229', 'JAKARTA', '', '', '', '', '', '', '', '', 14, '', '', '', '', '', '', 'V014', '2014-10-08'),
(102, '300103', 'EC01', 'PT ASIAN PACK CHEM', 'Jakarta', '0000023230', 'JAKARTA', '', '', '', '', '', '', '', '', 14, '', '', '', '', '', '', 'V014', '2014-10-08'),
(103, '300104', 'EC01', 'PT BAHANA KAREZA APPRAISAL', 'Jl. Kalibata Tengah No. 51', '0000023231', 'JAKARTA', '', '', '', '', '', '', '', '', 14, '', '', '', '', '', '', 'V014', '2014-10-08'),
(104, '300105', 'EC01', 'PT ANEKA INFOKOM TEKINDO', 'Jl. A.M Sangaji No. 22B', '0000023232', 'JAKARTA', '', '', '', '', '', '', '', '', 14, '', '', '', '', '', '', 'V014', '2014-10-08'),
(105, '300106', 'EC01', 'PT MASADENTA', 'Gd. Parkir Lt II Komp. Benceuy', '0000023233', 'JAKARTA', '', '', '', '', '', '', '', '', 14, '', '', '', '', '', '', 'V014', '2014-10-08'),
(106, '300107', 'EC01', 'PT. JAKARTA MANAJEMEN ESTATINDO', 'Jl. TAMAN PLUIT PUTERI DALAM NO 1', '0000023234', 'JAKARTA', '14450', '', '', '', '', '', '', '', 14, '', '', '', '', '', '', 'V014', '2014-10-08'),
(107, '300108', 'EC01', 'KH NOVA FAISAL,SH Mkn', 'Apart. Istana Sahid ME-7D', '0000023235', 'JAKARTA', '10220', '', '', '', '', '', '', '', 14, '', '', '', '', '', '', 'V014', '2014-10-08'),
(108, '300109', 'EC01', 'PT PROTINDO CIPTA KREASI LESTARI', 'WORLD TRADE CENTER', '0000023236', 'JAKARTA', '12920', '', '', '', '', '', '', '', 14, '', '', '', '', '', '', 'V014', '2014-10-08'),
(109, '300110', 'EC01', 'PT JAKARTA GLOBE MEDIA', 'Gedung Citra Graha Lt. 9', '0000023237', 'JAKARTA', '12950', '', '', '', '', '', '', '', 14, '', '', '', '', '', '', 'V014', '2014-10-08'),
(110, '300111', 'EC01', 'PT RAJASA EXPO CIPTA SARANA', 'JL.TECHNOLOGI 6 NO 11 KOMP BPPT MER', '0000023238', 'JAKARTA', '', '', '', '', '', '', '02.460.264.1.086.000', '', 14, '', '', '', '', '', '', 'V014', '2014-10-08'),
(111, '300112', 'EC01', 'PT HARINDO MITRAGAS UTAMA', 'JL Dr.SAHARJO NO.244B LT 4MENTENG', '0000023239', 'JAKARTA', '12870', '', '', '', '', '', '', '', 14, '', '', '', '', '', '', 'V014', '2014-10-08'),
(112, '300113', 'EC01', 'PT SUMBER SARANA TALENTA', 'JL.buncit raya 41 A', '0000023240', 'JAKARTA', '', '', '', '', '', '', '', '', 14, '', '', '', '', '', '', 'V014', '2014-10-08'),
(113, '300114', 'EC01', 'PT ESGEPE INDONESIA', 'Jl. Kuningan Barat Ged. Cyber', '0000023241', 'JAKARTA', '12710', '', '', '', '', '', '', '', 14, '', '', '', '', '', '', 'V014', '2014-10-08'),
(114, '300115', 'EC01', 'CV TIKA UTAMA ADVERTISING PROMOTION', 'JL ASEM BARIS RAYA 122 RT 009/005', '0000023242', 'JAKARTA', '12830', '', '', '', '', '', '', '', 14, '', '', '', '', '', '', 'V014', '2014-10-08'),
(115, '300116', 'EC01', 'PT MILLENIUM MITRA MOTOR', 'JL. LETJEND SUPRAPTO NO 19', '0000023243', 'JAKARTA', '', '', '', '', '', '', '', '', 14, '', '', '', '', '', '', 'V014', '2014-10-08'),
(116, '300117', 'EC01', 'PT INDOCARE PACIFIC', 'JL.TEBET TIMUR RAYA NO 5', '0000023244', 'JAKARTA', '', '', '', '', '', '', '', '', 14, '', '', '', '', '', '', 'V014', '2014-10-08'),
(117, '300118', 'EC01', 'AUTO MANDIRI', 'JL.RAYA TAJUR NO 10 KOMP BALITVET', '0000023245', 'JAKARTA', '', '', '', '', '', '', '', '', 14, '', '', '', '', '', '', 'V014', '2014-10-08'),
(118, '300119', 'EC01', 'PT HARINDO ENERGY J.O', 'Ruko Inkopal Blok A 60', '0000023246', 'JAKARTA', '', '', '', '', '', '', '', '', 14, '', '', '', '', '', '', 'V014', '2014-10-08'),
(119, '300120', 'EC01', 'PT.REALTA CHAKRADARMA', 'JL.Petojo Melintang No.25 A', '0000023247', 'JAKARTA', '10160', '', '', '', '', '', '', '', 14, '', '', '', '', '', '', 'V014', '2014-10-08'),
(120, '300121', 'EC01', 'SKETSA ART & DESIGN', 'Jl. Galaxi', '0000023248', 'JAKARTA', '', '', '', '', '', '', '', '', 14, '', '', '', '', '', '', 'V014', '2014-10-08'),
(121, '300122', 'EC01', 'PT. SUMBER WARIH SEJAHTERA', 'JL.CINERE RAYA BLOK GNO 29', '0000023249', 'JAKARTA', '', '', '', '', '', '', '', '', 14, '', '', '', '', '', '', 'V014', '2014-10-08'),
(122, '300123', 'EC01', 'CV YEHUDA TALITAKUM', 'Desa Pabuaran kemang', '0000023250', 'JAKARTA', '', '', '', '', '', '', '', '', 14, '', '', '', '', '', '', 'V014', '2014-10-08'),
(123, '300124', 'EC01', 'PT.WADANTRA NILAITAMA', 'Jl. Hayam Wuruk No. 4E', '0000023251', 'JAKARTA', '', '', '', '', '', '', '', '', 14, '', '', '', '', '', '', 'V014', '2014-10-08'),
(124, '300125', 'EC01', 'CV CAKRA ELEKTRICAL 1111', 'JL.Cileduk Raya NO.6 RT07/06', '0000023252', 'JAKARTA', '12230', '', '', '', '', '', '123324434233', '', 14, '', '', '', '', '', '', 'V014', '2014-10-08'),
(125, '300126', 'EC01', 'PT ASRAYA ANADYANI CITRANIRADA', 'Bintaro Pelangi Kav-3/24', '0000023253', 'JAKARTA', '15412', '', '', '', '', '', '123324434233', '', 14, '', '', '', '', '', '', 'V014', '2014-10-08'),
(126, '300127', 'EC01', 'PT CIPTA KARYAMAS SEJATI', 'RUKAN KENCANA NIAGA I-D.1/3.B', '0000023254', 'JAKARTA', '11620', '', '', '', '', '', '123324434233', '', 14, '', '', '', '', '', '', 'V014', '2014-10-08'),
(127, '300128', 'EC01', 'PT MEDIA NETWORK KOMUNIKASI', 'JL. Balikpapan I no.5F', '0000023255', 'JAKARTA', '10130', '', '', '', '', '', '123324434233', '', 14, '', '', '', '', '', '', 'V014', '2014-10-08'),
(128, '300129', 'EC01', 'PT SANTA ROSA INDONESIA', 'Jl.H Mashari Cibinong', '0000023256', 'JAKARTA', '', '', '', '', '', '', '123324434233', '', 14, '', '', '', '', '', '', 'V014', '2014-10-08'),
(129, '300130', 'EC01', 'PT WAHANA WIRAWAN', 'Jakarta', '0000023257', 'JAKARTA', '', '', '', '', '', '', '123324434233', '', 14, '', '', '', '', '', '', 'V014', '2014-10-08'),
(130, '300131', 'EC01', 'HARIAN ANALISA', 'JLN. BALAI KOTA NO 2', '0000023258', 'MEDAN', '', '', '', '', '', '', '', '', 14, '', '', '', '', '', '', 'V014', '2014-10-08'),
(131, '300132', 'EC01', 'MURNI AIR MINUM', 'Jakarta', '0000023259', 'JAKARTA', '', '', '', '', '', '', '', '', 14, '', '', '', '', '', '', 'V014', '2014-10-08'),
(132, '300133', 'EC01', 'PB TAXAND', 'menara imperium 27th floor', '0000023260', 'JAKARTA', '12980', '', '', '', '', '', '', '', 14, '', '', '', '', '', '', 'V014', '2014-10-08'),
(133, '300134', 'EC01', 'PT BUANA NITTANINDO GAS', 'JL.Duri raya no9', '0000023261', 'JAKARTA', '', '', '', '', '', '', '', '', 14, '', '', '', '', '', '', 'V014', '2014-10-08'),
(134, '300135', 'EC01', 'PT ARTHA TELEKOMINDO', 'JL.JEND SUDIRMAN KAV 52-53', '0000023262', 'JAKARTA', '', '', '', '', '', '', '01.614.973.4.062.000', '', 14, '', '', '', '', '', '', 'V014', '2014-10-08'),
(135, '300136', 'EC01', 'PT SELARAS GILANG PRATAMA', 'Kuningan Barat No. 8, Ged. Cyber', '0000023263', 'JAKARTA', '12710', '', '', '', '', '', '', '', 14, '', '', '', '', '', '', 'V014', '2014-10-08'),
(136, '300137', 'EC01', 'PT.ORBIT MEDIA', 'Gd. Femina', '0000023264', 'JAKARTA', '', '', '', '', '', '', '', '', 14, '', '', '', '', '', '', 'V014', '2014-10-08'),
(137, '300138', 'EC01', 'PT. MEDAN NIAGA UTAMA', 'Komp. Plaza Medan Fair Lt. IV', '0000023265', 'MEDAN', '', '', '', '', '', '', '', '', 14, '', '', '', '', '', '', 'V014', '2014-10-08'),
(138, '300139', 'EC01', 'TN.SUYANDEN LIN', 'Jakarta', '0000023266', 'JAKARTA', '', '', '', '', '', '', '', '', 14, '', '', '', '', '', '', 'V014', '2014-10-08'),
(139, '300140', 'EC01', 'ANUGRAH PRIMA, PT', 'Jl. Jend. Gatot Subroto No. 30', '0000023267', 'MEDAN', '', '', '', '', '', '', '', '', 14, '', '', '', '', '', '', 'V014', '2014-10-08'),
(140, '300092', 'EC01', 'PT BROADBAND NETWORK ASIA', 'Jl. Cyber Buiding 1st Floor', '0000023219', 'JAKARTA', '', '', '', '', '', '', '', '', 14, '', '', '', '', '', '', 'V014', '2014-10-08'),
(141, '300093', 'EC01', 'BUMI PERSADA AKTUARIA', 'Jl. RC. Veteran No. 11 G Bintaro', '0000023220', 'JAKARTA', '12330', '', '', '', '', '', '', '', 14, '', '', '', '', '', '', 'V014', '2014-10-08'),
(142, '300094', 'EC01', 'CV. TIRTA AGUNG BAN', 'JL.RAYA PASAR MINGGU NO16', '0000023221', 'JAKARTA', '', '', '', '', '', '', '', '', 14, '', '', '', '', '', '', 'V014', '2014-10-08'),
(143, '300145', 'EC01', 'AUDIOMEDIA NUSANTARA RAYA,PT', 'JL. PULO BUARAN III BLOK F5-6 BPSP', '0000023272', 'JAKARTA', '', '', '', '', '', '', '', '', 14, '', '', '', '', '', '', 'V014', '2014-10-08'),
(144, '300146', 'EC01', 'SWADAYANUSA KENCANA RAHARJA,PT', 'ITC Tower Lt. 10', '0000023273', 'JAKARTA', '', '', '', '', '', '', '', '', 14, '', '', '', '', '', '', 'V014', '2014-10-08'),
(145, '300147', 'EC01', 'PT MULIA SAFETY INDONESIA', 'Jakarta', '0000023274', 'JAKARTA', '', '', '', '', '', '', '', '', 14, '', '', '', '', '', '', 'V014', '2014-10-08'),
(146, '300148', 'EC01', 'PT SOLUSI CORPORINDO TEKNOLOGI', 'JL.Kapuk Kamal raya no 62 E', '0000023275', 'JAKARTA', '', '', '', '', '', '', '', '', 14, '', '', '', '', '', '', 'V014', '2014-10-08'),
(147, '300149', 'EC01', 'PT CIPTA SUKSES MANDIRI', 'JL.Plaza Kenari MAs lantai G blok D', '0000023276', 'JAKARTA', '', '', '', '', '', '', '', '', 14, '', '', '', '', '', '', 'V014', '2014-10-08'),
(148, '300150', 'EC01', 'CV.SAE MULTIFABRIKASI', 'GRAHA MUTIARA BEKASI TIMUR', '0000023277', 'JAKARTA', '', '', '', '', '', '', '', '', 14, '', '', '', '', '', '', 'V014', '2014-10-08'),
(149, '300151', 'EC01', 'PT PAZIA PILLAR MERCYCOM', 'KAWASAN MANGGA DUA SQUARE BLOK G', '0000023278', 'JAKARTA', '', '', '', '', '', '', '', '', 14, '', '', '', '', '', '', 'V014', '2014-10-08'),
(150, '300152', 'EC01', 'PT DWI PATMA GASINDO', 'JL.KREKOT JAYA B2 NO 19', '0000023279', 'JAKARTA', '', '', '', '', '', '', '', '', 14, '', '', '', '', '', '', 'V014', '2014-10-08'),
(151, '300153', 'EC01', 'AMANG SURATMAN', 'Jakarta', '0000023280', 'JAKARTA', '', '', '', '', '', '', '', '', 14, '', '', '', '', '', '', 'V014', '2014-10-08'),
(152, '300154', 'EC01', 'PT PRIMA GEMILANG SAKTI', 'JL.YOS SUDARSO NO 18 RAWABADAK', '0000023281', 'JAKARTA', '14230', '', '', '', '', '', '', '', 14, '', '', '', '', '', '', 'V014', '2014-10-08'),
(153, '300155', 'EC01', 'PT MITRA ARTHA RAYA', 'JL.SUNTER PARADISE A/43', '0000023282', 'JAKARTA', '14350', '', '', '', '', '', '', '', 14, '', '', '', '', '', '', 'V014', '2014-10-08'),
(154, '300156', 'EC01', 'GO GIOK KIONG', 'HARCO MAS MANGGA 2 LT SEMI GROUND', '0000023283', 'JAKARTA', '', '', '', '', '', '', '07.202.299.9-026.000', '', 14, '', '', '', '', '', '', 'V014', '2014-10-08'),
(155, '300157', 'EC01', 'MANDALA STATIONERY', 'Jakarta', '0000023284', 'JAKARTA', '', '', '', '', '', '', '', '', 14, '', '', '', '', '', '', 'V014', '2014-10-08'),
(156, '300158', 'EC01', 'DWI MANDIRI TECHNOLOGY', 'Jakarta', '0000023285', 'JAKARTA', '', '', '', '', '', '', '', '', 14, '', '', '', '', '', '', 'V014', '2014-10-08'),
(157, '300159', 'EC01', 'PT CITRA VAN TITIPAN KILAT', 'Jakarta', '0000023286', 'JAKARTA', '', '', '', '', '', '', '', '', 14, '', '', '', '', '', '', 'V014', '2014-10-08'),
(158, '300160', 'EC01', 'ANEKA JAYA ABADI', 'Jakarta', '0000023287', 'JAKARTA', '', '', '', '', '', '', '', '', 14, '', '', '', '', '', '', 'V014', '2014-10-08'),
(159, '300161', 'EC01', 'PT. TRIKOMINDO KARUNIA UTAMA', 'Harco Elekteonik Mangga II Lantai D', '0000023288', 'JAKARTA', '', '', '', '', '', '', '', '', 14, '', '', '', '', '', '', 'V014', '2014-10-08'),
(160, '300162', 'EC01', 'PT TERANG BULAN', 'Bekasi Hompimpa Family ParkBlok A00', '0000023289', 'JAKARTA', '', '', '', '', '', '', '', '', 14, '', '', '', '', '', '', 'V014', '2014-10-08'),
(161, '300163', 'EC01', 'SEMPURNA PUTRA EXSPRESS', 'Jakarta', '0000023290', 'JAKARTA', '', '', '', '', '', '', '', '', 14, '', '', '', '', '', '', 'V014', '2014-10-08'),
(162, '300164', 'EC01', 'USAHA WISATA MANDIRI', 'Jakarta', '0000023291', 'JAKARTA', '', '', '', '', '', '', '', '', 14, '', '', '', '', '', '', 'V014', '2014-10-08'),
(163, '300165', 'EC01', 'PT ELANG BUANA PERKASA', '12 Jl.Mampang Raya rt001/02', '0000023292', 'JAKARTA SELATAN', '12790', '', '', '', '', '', '02.070.857.4.014.000', '', 14, '', '', '', '', '', '', 'V014', '2014-10-08'),
(164, '300166', 'EC01', 'ANUGRAH ELECTRIC', 'Jakarta', '0000023293', 'JAKARTA', '', '', '', '', '', '', '', '', 14, '', '', '', '', '', '', 'V014', '2014-10-08'),
(165, '300167', 'EC01', 'PT TRUBUS MITRA SWADAYA', 'JL.Mekar Sari Raya RT 01/07', '0000023294', 'JAKARTA', '', '', '', '', '', '', '', '', 14, '', '', '', '', '', '', 'V014', '2014-10-08'),
(166, '300168', 'EC01', 'PT MITRA SARANATAMA SEJAHTERA', 'JL.Bakti no 100', '0000023295', 'JAKARTA', '12560', '', '', '', '', '', '', '', 14, '', '', '', '', '', '', 'V014', '2014-10-08'),
(167, '300169', 'EC01', 'DANAMON', 'Jakarta', '0000023296', 'JAKARTA', '', '', '', '', '', '', '', '', 14, '', '', '', '', '', '', 'V014', '2014-10-08'),
(168, '300170', 'EC01', 'HSBC', 'Jakarta', '0000023297', 'JAKARTA', '', '', '', '', '', '', '', '', 14, '', '', '', '', '', '', 'V014', '2014-10-08'),
(169, '300171', 'EC01', 'PERMATA', 'Jakarta', '0000023298', 'JAKARTA', '', '', '', '', '', '', '', '', 14, '', '', '', '', '', '', 'V014', '2014-10-08'),
(170, '300172', 'EC01', 'PT TRITAMA MULTISINDO LESTARI', 'JL.Tentara Pelajar Permata Senayan', '0000023299', 'JAKARTA', '', '', '', '', '', '', '', '', 14, '', '', '', '', '', '', 'V014', '2014-10-08'),
(171, '300173', 'EC01', 'PT SUARA IRAMA INDAH', 'Menara Imperium lantai P7', '0000023300', 'JAKARTA', '12980', '', '', '', '', '', '', '', 14, '', '', '', '', '', '', 'V014', '2014-10-08'),
(172, '300174', 'EC01', 'UD. ANANDA SERVICE', 'Jakarta', '0000023301', 'JAKARTA', '', '', '', '', '', '', '', '', 14, '', '', '', '', '', '', 'V014', '2014-10-08'),
(173, '300175', 'EC01', 'IVANKA RAMLI SUWANDI', 'Jakarta', '0000023302', 'JAKARTA', '', '', '', '', '', '', '', '', 14, '', '', '', '', '', '', 'V014', '2014-10-08'),
(174, '300176', 'EC01', 'SUBUR SUKSESSINDO', 'Jakarta', '0000023303', 'JAKARTA', '', '', '', '', '', '', '', '', 14, '', '', '', '', '', '', 'V014', '2014-10-08'),
(175, '300177', 'EC01', 'CV KURNIA JAYA TEKNIK', 'Perum Mahkota Indah Blok GC 7 No.7T', '0000023304', 'JAKARTA', '', '', '', '', '', '', '', '', 14, '', '', '', '', '', '', 'V014', '2014-10-08'),
(176, '300178', 'EC01', 'PT REMKA PIONINDO PERKASA', 'JL.Blok C 1 no 1 Pasar Baru', '0000023305', 'JAKARTA', '', '', '', '', '', '', '', '', 14, '', '', '', '', '', '', 'V014', '2014-10-08'),
(177, '300179', 'EC01', 'YVONNE COLLECTION', 'JLN. KEBON RAYA NO.82', '0000023306', 'JAKARTA', '', '', '', '', '', '', '', '', 14, '', '', '', '', '', '', 'V014', '2014-10-08'),
(178, '300180', 'EC01', 'PT KEBUN VISUAL', 'DHARMAWANGA XVII/37C', '0000023307', 'JAKARTA', '', '', '', '', '', '', '', '', 14, '', '', '', '', '', '', 'V014', '2014-10-08'),
(179, '300181', 'EC01', 'UD KARUNIA', 'Jln Kediri, Gang Mandiri 7A', '0000023308', 'JAKARTA', '', '', '', '', '', '', '', '', 14, '', '', '', '', '', '', 'V014', '2014-10-08'),
(180, '300182', 'EC01', 'PT RADIO MUSTIKA ABADI', 'Sarinah BLD 8th floor', '0000023309', 'JAKARTA', '10350', '', '', '', '', '', '', '', 14, '', '', '', '', '', '', 'V014', '2014-10-08'),
(181, '300183', 'EC01', 'PT BITNET KOMUNIKASINDO', 'SCTV Tower - Senayan City Lt. 15', '0000023310', 'JAKARTA', '10270', '', '', '', '', '', '', '', 14, '', '', '', '', '', '', 'V014', '2014-10-08'),
(182, '300184', 'EC01', 'PT ANDALAS TECHNOLOGY', 'Jl. H. Nawi Raya no. 52B', '0000023311', 'JAKARTA', '', '', '', '', '', '', '', '', 14, '', '', '', '', '', '', 'V014', '2014-10-08'),
(183, '300185', 'EC01', 'UNIVERSAL ENGINEERING', 'Jl. Waturenggong no. 21 A', '0000023312', 'JAKARTA', '', '', '', '', '', '', '', '', 14, '', '', '', '', '', '', 'V014', '2014-10-08'),
(184, '300186', 'EC01', 'PT GOLDEN PUTRA MANDIRI', 'Jl. Mangga Dua Raya Komplek Ruko', '0000023313', 'JAKARTA', '', '', '', '', '', '', '', '', 14, '', '', '', '', '', '', 'V014', '2014-10-08'),
(185, '300187', 'EC01', 'CV MAKMUR INTAN LUHUR', 'Jl. Sanjaya II No. 15', '0000023314', 'JAKARTA', '', '', '', '', '', '', '', '', 14, '', '', '', '', '', '', 'V014', '2014-10-08'),
(186, '300188', 'EC01', 'PT.BALI RANADHA TELEVISI', 'JL.KEBO IWA 63A', '0000023315', 'JAKARTA', '', '', '', '', '', '', '', '', 14, '', '', '', '', '', '', 'V014', '2014-10-08'),
(187, '300189', 'EC01', 'MULIADI TANTOWIDJAJA', 'JL.PAPANDAYAN STREET 23TH', '0000023316', 'JAKARTA', '', '', '', '', '', '', '', '', 14, '', '', '', '', '', '', 'V014', '2014-10-08'),
(188, '300141', 'EC01', 'PT. FIRSTWAP', 'Jl. Kapten Tendean No. 34', '0000023268', 'JAKARTA', '', '', '', '', '', '', '', '', 14, '', '', '', '', '', '', 'V014', '2014-10-08'),
(189, '300142', 'EC01', 'CV. ERA KENCANA ART', 'Jl. Umar No. 105 Glugur Darat I', '0000023269', 'MEDAN', '20238', '', '', '', '', '', '', '', 14, '', '', '', '', '', '', 'V014', '2014-10-08'),
(190, '300143', 'EC01', 'PT TIRTA ALPIN M AKMUR', 'Jakarta', '0000023270', 'JAKARTA', '', '', '', '', '', '', '', '', 14, '', '', '', '', '', '', 'V014', '2014-10-08'),
(191, '300144', 'EC01', 'PT GARUDA SECURITY NUSANTARA', 'Jl. Jend. Gatot Subroto Kav. 71-73', '0000023271', 'JAKARTA', '12870', '', '', '', '', '', '', '', 14, '', '', '', '', '', '', 'V014', '2014-10-08'),
(192, '300195', 'EC01', 'PT MICROREKSA INFONET', 'Komplek Roxy Mas Blok E1 No.2', '0000023322', 'JAKARTA', '', '', '', '', '', '', '', '', 14, '', '', '', '', '', '', 'V014', '2014-10-08'),
(193, '300196', 'EC01', 'PRIMACOM MEDIATAMA', 'Roxy Square Lt.1 A6 No. 23/25', '0000023323', 'JAKARTA', '', '', '', '', '', '', '', '', 14, '', '', '', '', '', '', 'V014', '2014-10-08'),
(194, '300197', 'EC01', 'CIPTA BUSANA JAKARTA', '3 Jln Mahoni II blok B5', '0000023324', 'JAKARTA UTARA', '', '', '', '', '', '', '18.165.993.9.045.000', '', 14, '', '', '', '', '', '', 'V014', '2014-10-08'),
(195, '300198', 'EC01', 'PT SUPLINDO KARYA JAYA', 'Harco Mas Mangga Dua Lt.2 No.3', '0000023325', 'JAKARTA', '10730', '', '', '', '', '', '', '', 14, '', '', '', '', '', '', 'V014', '2014-10-08'),
(196, '300199', 'EC01', 'PT INFOPRIMA MITRA SOLUSI', 'Mid Plaza 2, 16th Floor', '0000023326', 'JAKARTA', '', '', '', '', '', '', '', '', 14, '', '', '', '', '', '', 'V014', '2014-10-08'),
(197, '300200', 'EC01', 'PT METROPOLITAN LAND TBK', '5 Jl.HR Rasuna Said X2', '0000023327', 'JAKARTA SELATAN', '12920', '', '', '', '', '', '01.657.313.1.054.000', '', 14, '', '', '', '', '', '', 'V014', '2014-10-08'),
(198, '300201', 'EC01', 'PT LINKIT', 'Menara Utara Jamsostek Lt.24', '0000023328', 'JAKARTA', '12710', '', '', '', '', '', '', '', 14, '', '', '', '', '', '', 'V014', '2014-10-08'),
(199, '300202', 'EC01', 'PT PERKOM INDAH MURNI', 'Mid Plaza 2, 19th floor', '0000023329', 'JAKARTA', '10220', '', '', '', '', '', '', '', 14, '', '', '', '', '', '', 'V014', '2014-10-08'),
(200, '300203', 'EC01', 'PT GRIYA ATRIWIDYA PERSADA', 'Jln Ampera Raya No.123RT001/002', '0000023330', 'JAKARTA', '', '', '', '', '', '', '', '', 14, '', '', '', '', '', '', 'V014', '2014-10-08'),
(201, '300204', 'EC01', 'PT RADIO MUARA ABDINUSA', 'Gedung Sarinah Lt.8', '0000023331', 'JAKARTA', '10350', '', '', '', '', '', '', '', 14, '', '', '', '', '', '', 'V014', '2014-10-08'),
(202, '300205', 'EC01', 'KANTOR HUKUM ELFIAN & PARTNERS', 'Jln. Duren Tiga Raya No.9', '0000023332', 'JAKARTA', '', '', '', '', '', '', '', '', 14, '', '', '', '', '', '', 'V014', '2014-10-08'),
(203, '300206', 'EC01', 'PT INDOCYBER GLOBAL TEKNOLOGY', 'Sampoerna Strategic Square', '0000023333', 'JAKARTA', '12930', '', '', '', '', '', '', '', 14, '', '', '', '', '', '', 'V014', '2014-10-08'),
(204, '300207', 'EC01', 'PT KIMIA YASA', 'Jl. Jababeka 8 Blok K No.6B', '0000023334', 'JAKARTA', '', '', '', '', '', '', '', '', 14, '', '', '', '', '', '', 'V014', '2014-10-08'),
(205, '300208', 'EC01', 'PT STAR INDONESIA', 'Ruko Griya Riatur Indah Bolk B', '0000023335', 'JAKARTA', '', '', '', '', '', '', '', '', 14, '', '', '', '', '', '', 'V014', '2014-10-08'),
(206, '300209', 'EC01', 'PT BOGOR EKSPRES MEDIA', 'Jl. KH. R. Abdullah Bin Muh. Nuh', '0000023336', 'JAKARTA', '', '', '', '', '', '', '', '', 14, '', '', '', '', '', '', 'V014', '2014-10-08'),
(207, '300210', 'EC01', 'YASA MULYA TEKNIK', 'HWI Lindeteves Blok C No.42', '0000023337', 'JAKARTA', '', '', '', '', '', '', '', '', 14, '', '', '', '', '', '', 'V014', '2014-10-08'),
(208, '300211', 'EC01', 'UD TAMI JAYA SAKTI', 'Jln. Topaz Galur Selatan No.4', '0000023338', 'JAKARTA', '10530', '', '', '', '', '', '', '', 14, '', '', '', '', '', '', 'V014', '2014-10-08'),
(209, '300212', 'EC01', 'DENA STAMP', 'Pondok Maharta Blok C6 No.9', '0000023339', 'JAKARTA', '', '', '', '', '', '', '', '', 14, '', '', '', '', '', '', 'V014', '2014-10-08'),
(210, '300213', 'EC01', 'SURYA CIPTA CEMERLANG', 'Jakarta', '0000023340', 'JAKARTA', '', '', '', '', '', '', '', '', 14, '', '', '', '', '', '', 'V014', '2014-10-08'),
(211, '300214', 'EC01', 'PT GANDHI DWIKY RADIO', 'Jl. Mayor Hasibuan No.18', '0000023341', 'JAKARTA', '17113', '', '', '', '', '', '', '', 14, '', '', '', '', '', '', 'V014', '2014-10-08'),
(212, '300215', 'EC01', 'CV SENTRA DUTAMEDIA SEJAHTERA', 'Jln. Cipedes Tengah 97', '0000023342', ' BANDUNG', '', '', '', '', '', '', '', '', 14, '', '', '', '', '', '', 'V014', '2014-10-08'),
(213, '300216', 'EC01', 'PT PROGRESSIVE NETWORKS INDONESIA', 'Plaza Hayam Wuruk Tower Lt.12', '0000023343', 'JAKARTA', '11160', '', '', '', '', '', '', '', 14, '', '', '', '', '', '', 'V014', '2014-10-08'),
(214, '300217', 'EC01', 'PT SUMBER MANDIRI', 'JL.LINDATEVES TRADE CENTRE GA 1', '0000023344', 'JAKARTA', '', '', '', '', '', '', '', '', 14, '', '', '', '', '', '', 'V014', '2014-10-08'),
(215, '300218', 'EC01', 'PT PURA BARUTAMA', 'Jln. AKBP R Agil Kusumadia 203', '0000023345', 'JAKARTA', '', '', '', '', '', '', '', '', 14, '', '', '', '', '', '', 'V014', '2014-10-08'),
(216, '300219', 'EC01', 'PT PANORAMA TIMUR JAYA', 'Jln. Paus No.89D/E Rawamangun', '0000023346', 'JAKARTA', '', '', '', '', '', '', '', '', 14, '', '', '', '', '', '', 'V014', '2014-10-08'),
(217, '300220', 'EC01', 'PT CITRA BALI ADVERTISER', 'Jl. Segara Batu Bolong No. 18', '0000023347', 'JAKARTA', '', '', '', '', '', '', '', '', 14, '', '', '', '', '', '', 'V014', '2014-10-08'),
(218, '300221', 'EC01', 'PT BERCA HARDAYAPERKASA', 'JLn. Abdul Musi No. 62 Petamburan', '0000023348', 'JAKARTA', '10160', '', '', '', '', '', '', '', 14, '', '', '', '', '', '', 'V014', '2014-10-08'),
(219, '300222', 'EC01', 'PERCETAKAN SAM SAM', 'Jln. Jamin Ginting No.129', '0000023349', 'JAKARTA', '', '', '', '', '', '', '', '', 14, '', '', '', '', '', '', 'V014', '2014-10-08'),
(220, '300223', 'EC01', 'PT SENTOSA DIGITAL PRINTING', 'Ruko Sentra Bisnis Blok B8', '0000023350', 'JAKARTA', '', '', '', '', '', '', '', '', 14, '', '', '', '', '', '', 'V014', '2014-10-08'),
(221, '300224', 'EC01', 'AGUNG WIBOWO PHOTOWORKS', 'Sudirman Park Apt Tower A', '0000023351', 'JAKARTA', '', '', '', '', '', '', '', '', 14, '', '', '', '', '', '', 'V014', '2014-10-08'),
(222, '300225', 'EC01', 'PT OASIS WATERS INTERNATIONAL', 'Jln. Rawa Sumur Barat No.1', '0000023352', 'JAKARTA', '', '', '', '', '', '', '', '', 14, '', '', '', '', '', '', 'V014', '2014-10-08'),
(223, '300226', 'EC01', 'PT RADIO INDIKA MILLENIA', 'Gedung Mitra Lt. 9', '0000023353', 'JAKARTA', '12930', '', '', '', '', '', '', '', 14, '', '', '', '', '', '', 'V014', '2014-10-08'),
(224, '300227', 'EC01', 'MUHAMMAD FIRLI LAKONI', 'Jl. Perintis Kemerdekaan LR. Wiragu', '0000023354', 'JAKARTA', '', '', '', '', '', '', '', '', 14, '', '', '', '', '', '', 'V014', '2014-10-08'),
(225, '300228', 'EC01', 'RADHY SABATH SETIAWAN', 'Jl. Kp. Melayu Besar', '0000023355', 'JAKARTA', '', '', '', '', '', '', '', '', 14, '', '', '', '', '', '', 'V014', '2014-10-08'),
(226, '300229', 'EC01', 'PT PARAHITA SANU SETIA', 'Jl. Danau Jempang Blok BII/14', '0000023356', 'JAKARTA', '', '', '', '', '', '', '', '', 14, '', '', '', '', '', '', 'V014', '2014-10-08'),
(227, '300230', 'EC01', 'CV ARKANANTA NITYASA INDONESIA', 'Jln. Haji Miran Blok C No.5', '0000023357', 'JAKARTA', '', '', '', '', '', '', '', '', 14, '', '', '', '', '', '', 'V014', '2014-10-08'),
(228, '300231', 'EC01', 'PT.EC ENTERTAINMENT', 'Jakarta', '0000023358', 'JAKARTA', '', '', '', '', '', '', '', '', 14, '', '', '', '', '', '', 'V014', '2014-10-08'),
(229, '300232', 'EC01', 'PT INTERKONEKSI INTERNET INDONESIA', 'Cyber Building 1st Floor', '0000023359', 'JAKARTA', '12710', '', '', '', '', '', '', '', 14, '', '', '', '', '', '', 'V014', '2014-10-08'),
(230, '300233', 'EC01', 'PT SENTRAKARYA EKAMEGAH', 'Jln. Matraman Raya 140', '0000023360', 'JAKARTA', '', '', '', '', '', '', '', '', 14, '', '', '', '', '', '', 'V014', '2014-10-08'),
(231, '300234', 'EC01', 'PT JUNIOR MOTOR SPORT', 'Jln. Raya Bogor Km.42 No.1', '0000023361', 'JAKARTA', '16916', '', '', '', '', '', '', '', 14, '', '', '', '', '', '', 'V014', '2014-10-08'),
(232, '300235', 'EC01', 'PT.AUTO DAYA KEISINDO', 'JALAN KAPT. TENDEAN NO 8 PELA', '0000023362', 'JAKARTA', '', '', '', '', '', '', '02.160.536.5.062.000', '', 14, '', '', '', '', '', '', 'V014', '2014-10-08'),
(233, '300236', 'EC01', 'PT.HAENES MANDIRI', 'Galur Sari Timur No.18 Utan', '0000023363', 'JAKARTA', '13120', '', '', '', '', '', '', '', 14, '', '', '', '', '', '', 'V014', '2014-10-08'),
(234, '300237', 'EC01', 'PT.ANUGRAH MAJU ABADI', 'Jl. H. M. Said No.132A', '0000023364', 'MEDAN', '', '', '', '', '', '', '', '', 14, '', '', '', '', '', '', 'V014', '2014-10-08'),
(235, '300238', 'EC01', 'CV.CIPTA TEKNIK MANDIRI', 'JL.KAPT RAHMAD BUDIN GG VOLLY LK 01', '0000023365', 'JAKARTA', '', '', '', '', '', '', '', '', 14, '', '', '', '', '', '', 'V014', '2014-10-08'),
(236, '300190', 'EC01', 'PT.AVABANINDO PERKASA', 'PLAZA ASIA 26Th FLOOR', '0000023317', 'JAKARTA', '12190', '', '', '', '', '', '', '', 14, '', '', '', '', '', '', 'V014', '2014-10-08'),
(237, '300191', 'EC01', 'KANTOR NOTARIS ANTONI HALIM', 'Jln. Pelepah Indah Blok LB21/24', '0000023318', 'JAKARTA', '14240', '', '', '', '', '', '', '', 14, '', '', '', '', '', '', 'V014', '2014-10-08'),
(238, '300192', 'EC01', 'PT ARSEN KUSUMA INDONESIA', 'Gedung Cyber Lt.7-704', '0000023319', 'JAKARTA', '12710', '', '', '', '', '', '', '', 14, '', '', '', '', '', '', 'V014', '2014-10-08'),
(239, '300193', 'EC01', 'PT ISTANA KEBAYORAN RAYA MOTOR', 'Jl. R. S. Fatmawati No. 21', '0000023320', 'JAKARTA', '12410', '', '', '', '', '', '', '', 14, '', '', '', '', '', '', 'V014', '2014-10-08'),
(240, '300194', 'EC01', 'PT PERSADA NUSANTARA', 'Jl. Syaridin No. 75', '0000023321', 'JAKARTA', '', '', '', '', '', '', '', '', 14, '', '', '', '', '', '', 'V014', '2014-10-08'),
(241, '300245', 'EC01', 'PT BINA MEDIA TENGGARA', 'Jl. Palmerah Selatan No. 15', '0000023372', 'JAKARTA', '', '', '', '', '', '', '', '', 14, '', '', '', '', '', '', 'V014', '2014-10-08'),
(242, '300246', 'EC01', 'PT JAYA REAL PROPERTY, TBK', 'Bintaro Trade CenterLantai 2 Blok H', '0000023373', 'JAKARTA', '15224', '', '', '', '', '', '', '', 14, '', '', '', '', '', '', 'V014', '2014-10-08'),
(243, '300247', 'EC01', 'PT BERTI INTI GEMILANG', 'Jln. H Saili No. G.11 RT07/06', '0000023374', 'JAKARTA', '', '', '', '', '', '', '', '', 14, '', '', '', '', '', '', 'V014', '2014-10-08'),
(244, '300248', 'EC01', 'PT SUN MOTOR SOLO', 'Jl. Kol Sutarto No. 48', '0000023375', 'JEMBER', '', '', '', '', '', '', '', '', 14, '', '', '', '', '', '', 'V014', '2014-10-08'),
(245, '300249', 'EC01', 'PT SUMATERA BERLIAN MOTORS', 'Jl. Sisingamangaraja Km.7 No.34', '0000023376', 'JAKARTA', '20147', '', '', '', '', '', '', '', 14, '', '', '', '', '', '', 'V014', '2014-10-08'),
(246, '300250', 'EC01', 'PT SOLEFOUND SAKTI', 'Jl. Gading Putih Raya Blok KR 15-17', '0000023377', 'JAKARTA', '14240', '', '', '', '', '', '', '', 14, '', '', '', '', '', '', 'V014', '2014-10-08'),
(247, '300251', 'EC01', 'PT MESA PUBLISHING', 'Plaza Bona Indah Blok A2/A1', '0000023378', 'JAKARTA', '12440', '', '', '', '', '', '', '', 14, '', '', '', '', '', '', 'V014', '2014-10-08'),
(248, '300252', 'EC01', 'THE INDONESIAN CORPORATE COUNSEL AS', 'Mayapada Tower Lt. 19', '0000023379', 'JAKARTA', '', '', '', '', '', '', '', '', 14, '', '', '', '', '', '', 'V014', '2014-10-08'),
(249, '300253', 'EC01', 'PT CITRA MEDIA NUSA PURNAMA', 'Komplek Delta Kedoya', '0000023380', 'JAKARTA', '11520', '', '', '', '', '', '', '', 14, '', '', '', '', '', '', 'V014', '2014-10-08'),
(250, '300254', 'EC01', 'PT GLOBAL PRIME SERVICE', 'Ariobimo Sentral, 10th floor', '0000023381', 'JAKARTA', '12950', '', '', '', '', '', '', '', 14, '', '', '', '', '', '', 'V014', '2014-10-08'),
(251, '300255', 'EC01', 'SANDESH PROMO', 'Jln. Pepaya Komp. HARPERINDO', '0000023382', 'JAKARTA', '', '', '', '', '', '', '', '', 14, '', '', '', '', '', '', 'V014', '2014-10-08'),
(252, '300256', 'EC01', 'PT.LAJU ARTHA PRATAMA', 'JL.TAMAN NYIUR BLOK N/10B RT/RW.001', '0000023383', 'JAKARTA', '14350', '', '', '', '', '', '', '', 14, '', '', '', '', '', '', 'V014', '2014-10-08'),
(253, '300257', 'EC01', 'PT.PRIMA GEMILANG SAKTI', 'JL. ANGGREK NO.23 RT/RW 002/012', '0000023384', 'JAKARTA', '14230', '', '', '', '', '', '', '', 14, '', '', '', '', '', '', 'V014', '2014-10-08'),
(254, '300258', 'EC01', 'CV PUTRA WIRA BUANA', 'Jl. Masjid Al-Barokah No.14', '0000023385', 'JAKARTA', '', '', '', '', '', '', '', '', 14, '', '', '', '', '', '', 'V014', '2014-10-08'),
(255, '300259', 'EC01', 'CV SURYA MANGGALA', 'JL. RAYA JELAMBAR SELATAN NO. 8D', '0000023386', 'JAKARTA', '', '', '', '', '', '', '', '', 14, '', '', '', '', '', '', 'V014', '2014-10-08'),
(256, '300260', 'EC01', 'PT MERCINDO AUTORAMA', 'Jln Mampang Prapatan RayaNo.69-70', '0000023387', 'JAKARTA', '12790', '', '', '', '', '', '', '', 14, '', '', '', '', '', '', 'V014', '2014-10-08'),
(257, '300261', 'EC01', 'PT LG ELECTRONIC INDONESIA', 'Gandaria 8 Office Tower Lantai 29 B', '0000023388', 'JAKARTA', '', '', '', '', '', '', '', '', 14, '', '', '', '', '', '', 'V014', '2014-10-08'),
(258, '300262', 'EC01', 'PT METROPOLITAN KENTJANA TBK', 'Jl. Metro Duta Niaga Blok B-5', '0000023389', 'JAKARTA', '12310', '', '', '', '', '', '', '', 14, '', '', '', '', '', '', 'V014', '2014-10-08'),
(259, '300263', 'EC01', 'CIPTA INDAH STATIONERY', 'WTC Mangga Dua Lt. LG Blok C No. 23', '0000023390', 'JAKARTA', '', '', '', '', '', '', '', '', 14, '', '', '', '', '', '', 'V014', '2014-10-08'),
(260, '300264', 'EC01', 'SINAR CAHAYA ELECTRONIC', 'Jelambar Utama 17', '0000023391', 'JAKARTA', '', '', '', '', '', '', '', '', 14, '', '', '', '', '', '', 'V014', '2014-10-08'),
(261, '300265', 'EC01', 'PT CAISSON DIMENSI', 'Jln. Raya Perjuangan Prisma', '0000023392', 'JAKARTA', '11530', '', '', '', '', '', '', '', 14, '', '', '', '', '', '', 'V014', '2014-10-08'),
(262, '300266', 'EC01', 'YAY.LEMBAGA MANAJEMEN FORMASI', '4B Jl. Sebret', '0000023393', 'JAKARTA SELATAN', '12540', '', '', '', '', '', '01.683.596.9.017.000', '', 14, '', '', '', '', '', '', 'V014', '2014-10-08'),
(263, '300267', 'EC01', 'PROJECTS', 'Grand Village RD/D8', '0000023394', 'JAKARTA', '', '', '', '', '', '', '', '', 14, '', '', '', '', '', '', 'V014', '2014-10-08'),
(264, '300268', 'EC01', 'PT TOTAL COMMUNICATION NUSANTARA', 'Jln. Guntur No. 2ART001/RW001', '0000023395', 'JAKARTA', '12980', '', '', '', '', '', '', '', 14, '', '', '', '', '', '', 'V014', '2014-10-08'),
(265, '300269', 'EC01', 'PT INTISARI KOMPUTINDO', 'Jln. Taman Palem Lestari Blok H/62', '0000023396', 'JAKARTA', '11730', '', '', '', '', '', '', '', 14, '', '', '', '', '', '', 'V014', '2014-10-08'),
(266, '300270', 'EC01', 'PT PARAHITA PRIMA SENTOSA', 'Kawasan Multiguna Blok B No. 10A', '0000023397', 'JAKARTA', '15310', '', '', '', '', '', '02.704.333.0-411.000', '', 14, '', '', '', '', '', '', 'V014', '2014-10-08'),
(267, '300271', 'EC01', 'PT WAHANA MEDIA SELARAS', 'Ruko Griya Permata Blok A1/15', '0000023398', 'JAKARTA', '', '', '', '', '', '', '', '', 14, '', '', '', '', '', '', 'V014', '2014-10-08');
INSERT INTO `api_vendor` (`id`, `supplierCode`, `companyCode`, `name`, `address1`, `address2`, `city`, `postalCode`, `contactPerson`, `phone`, `hp1`, `hp2`, `fax`, `npwp`, `email`, `paymentTerm`, `bankCode`, `bankName`, `bankBranchCode`, `bankBranchName`, `bankAccountNo`, `status`, `paymentTermCd`, `dateCreate`) VALUES
(268, '300272', 'EC01', 'PT BAKRIE SWASAKTI UTAMA', 'Epiwalk Office Suites lt 6 unit A60', '0000023399', 'JAKARTA', '12940', '', '', '', '', '', '01.060.283.7.062.000', '', 14, '', '', '', '', '', '', 'V014', '2014-10-08'),
(269, '300273', 'EC01', 'SUKARJIYO', 'KP. SASAK TIGA RT.003 RW. 005', '0000023400', 'JAKARTA', '', '', '', '', '', '', '', '', 14, '', '', '', '', '', '', 'V014', '2014-10-08'),
(270, '300274', 'EC01', 'PT MITRA KREATIF PERSADA', 'Jl. Bungur besar IV No. 30', '0000023401', 'JAKARTA', '', '', '', '', '', '', '', '', 14, '', '', '', '', '', '', 'V014', '2014-10-08'),
(271, '300275', 'EC01', 'PRIMA PATEN', 'BSD City Tangerang', '0000023402', 'TANGERANG', '15323', '', '', '', '', '', '', '', 14, '', '', '', '', '', '', 'V014', '2014-10-08'),
(272, '300276', 'EC01', 'CV HARIRI', 'Jl. Melanthon Siregar', '0000023403', 'JAKARTA', '', '', '', '', '', '', '', '', 14, '', '', '', '', '', '', 'V014', '2014-10-08'),
(273, '300277', 'EC01', 'PT PANCA PUTRA SOLUSINDO', 'Komplek Mangga Dua Square Blok D', '0000023404', 'JAKARTA', '', '', '', '', '', '', '', '', 14, '', '', '', '', '', '', 'V014', '2014-10-08'),
(274, '300278', 'EC01', 'PT PARANTA ANUGERAH PRIMA', 'Jln. Suryopranoto No. 1-9 Blok A4-7', '0000023405', 'JAKARTA', '10160', '', '', '', '', '', '', '', 14, '', '', '', '', '', '', 'V014', '2014-10-08'),
(275, '300279', 'EC01', 'FERNANDUS BUDI R, IR', 'Jln. Kebon Jeruk Baru Bl. C-2 No. 5', '0000023406', 'JAKARTA', '', '', '', '', '', '', '', '', 14, '', '', '', '', '', '', 'V014', '2014-10-08'),
(276, '300280', 'EC01', 'PT GRAHA MULTIMEDIA NUSANTARA', 'GD Wisma Bakrie Lt.2', '0000023407', 'JAKARTA', '12920', '', '', '', '', '', '', '', 14, '', '', '', '', '', '', 'V014', '2014-10-08'),
(277, '300281', 'EC01', 'PT MEDIA WARTA KENCANA', 'Jl. Jend. A. Yani No.35-49', '0000023408', 'MEDAN', '20111', '', '', '', '', '', '', '', 14, '', '', '', '', '', '', 'V014', '2014-10-08'),
(278, '300282', 'EC01', 'PT CYBERPLUS MEDIA PRATAMA', 'Jl. Delta Barat 12 Blok C No.137', '0000023409', 'JAKARTA', '', '', '', '', '', '', '', '', 14, '', '', '', '', '', '', 'V014', '2014-10-08'),
(279, '300283', 'EC01', 'PIRAMIDA INTICOM', 'Harco Mangga DuaLt. 3 No. 60', '0000023410', 'JAKARTA', '', '', '', '', '', '', '', '', 14, '', '', '', '', '', '', 'V014', '2014-10-08'),
(280, '300284', 'EC01', 'PT VISI INTI SINERGI', 'Jln. Mangga Dua Raya', '0000023411', 'JAKARTA', '10730', '', '', '', '', '', '', '', 14, '', '', '', '', '', '', 'V014', '2014-10-08'),
(281, '300285', 'EC01', 'PT NUSA RAYA CIPTA', 'Gedung Graha Cipta 2nd Floor', '0000023412', 'JAKARTA', '', '', '', '', '', '', '', '', 14, '', '', '', '', '', '', 'V014', '2014-10-08'),
(282, '300286', 'EC01', 'PT VIROS PRIME SOLUTION', 'Jl. Agave Raya Blok A1/7', '0000023413', 'JAKARTA', '11520', '', '', '', '', '', '', '', 14, '', '', '', '', '', '', 'V014', '2014-10-08'),
(283, '300287', 'EC01', 'PT SISTEM PRIMA INFOTEK', 'Rukan Exclusife Blok E No.018', '0000023414', 'JAKARTA', '', '', '', '', '', '', '', '', 14, '', '', '', '', '', '', 'V014', '2014-10-08'),
(284, '300239', 'EC01', 'PT. BINAMITRA MEGAWARNA', 'Jl. Turi No.6 RT.014/RW.003', '0000023366', 'JAKARTA', '', '', '', '', '', '', '02.120.620.6-031.000', '', 14, '', '', '', '', '', '', 'V014', '2014-10-08'),
(285, '300240', 'EC01', 'RAMA MOTOR', 'Jakarta', '0000023367', 'JAKARTA', '', '', '', '', '', '', '', '', 14, '', '', '', '', '', '', 'V014', '2014-10-08'),
(286, '300241', 'EC01', 'DJAYA BERSAMA', 'Jl. Pendawa No.29 Casablanca', '0000023368', 'JAKARTA', '12870', '', '', '', '', '', '', '', 14, '', '', '', '', '', '', 'V014', '2014-10-08'),
(287, '300242', 'EC01', 'PT METROMEDIA ELMEKA ENGINEERING', 'Jl. Mohamad Kahfi I Jagakarsa', '0000023369', 'JAKARTA', '', '', '', '', '', '', '', '', 14, '', '', '', '', '', '', 'V014', '2014-10-08'),
(288, '300243', 'EC01', 'SENFEI ARCHITECT', 'Taman Alfa Indah Blok B6 No.9', '0000023370', 'JAKARTA', '11640', '', '', '', '', '', '', '', 14, '', '', '', '', '', '', 'V014', '2014-10-08'),
(289, '300244', 'EC01', 'PT BANK ARTHA GRAHA INTERNASIONAL T', 'Jl. Jenderal Sudirman Kav. 52-53', '0000023371', 'JAKARTA', '', '', '', '', '', '', '', '', 14, '', '', '', '', '', '', 'V014', '2014-10-08'),
(290, '300295', 'EC01', 'PT BUANA TEKNIK MANDIRI', 'JL.Duri Raya no 9', '0000023422', 'JAKARTA', '', '', '', '', '', '', '', '', 14, '', '', '', '', '', '', 'V014', '2014-10-08'),
(291, '300296', 'EC01', 'PT MAHARDIKA ADIMANUNGGAL', 'Taman Ratu Blok A7/10', '0000023423', 'JAKARTA', '', '', '', '', '', '', '', '', 14, '', '', '', '', '', '', 'V014', '2014-10-08'),
(292, '300297', 'EC01', 'PT CITAS OTIS ELEVATOR', 'Gd. Menara Karya Lt. 28', '0000023424', 'JAKARTA', '12950', '', '', '', '', '', '', '', 14, '', '', '', '', '', '', 'V014', '2014-10-08'),
(293, '300298', 'EC01', 'PT CLASSIC CARPETAMA INDONESIA', 'Jl. Pintu Air Raya No. 22A', '0000023425', 'JAKARTA', '10710', '', '', '', '', '', '', '', 14, '', '', '', '', '', '', 'V014', '2014-10-08'),
(294, '300299', 'EC01', 'PT TRINET PACIFIC INTERNATIONAL', 'Sequis Center Lt. 2', '0000023426', 'JAKARTA', '12190', '', '', '', '', '', '', '', 14, '', '', '', '', '', '', 'V014', '2014-10-08'),
(295, '300300', 'EC01', 'PT BAMBANG DJAJA', 'Jl. Rungkut Industri III/56', '0000023427', 'SURABAYA', '60293', '', '', '', '', '', '', '', 14, '', '', '', '', '', '', 'V014', '2014-10-08'),
(296, '300301', 'EC01', 'PT DANATEL PRATAMA', 'Gd. Artha Graha Lt.31', '0000023428', 'JAKARTA', '12190', '', '', '', '', '', '', '', 14, '', '', '', '', '', '', 'V014', '2014-10-08'),
(297, '300302', 'EC01', 'PT KARSA BUANA LESTARI', 'Wisma KBLJl. Kesehatan IV No. 45A', '0000023429', 'JAKARTA', '12330', '', '', '', '', '', '', '', 14, '', '', '', '', '', '', 'V014', '2014-10-08'),
(298, '300303', 'EC01', 'PT. SUN STAR MOTOR', 'Jl. Gatot Subroto Barat 100', '0000023430', 'JAKARTA', '', '', '', '', '', '', '', '', 14, '', '', '', '', '', '', 'V014', '2014-10-08'),
(299, '300304', 'EC01', 'PT.MULTI NUSANTARA KARYA', 'Jl. Jend. Gatot Subroto No. 30', '0000023431', 'MEDAN', '', '', '', '', '', '', '02.492.960.6.124.001', '', 14, '', '', '', '', '', '', 'V014', '2014-10-08'),
(300, '300305', 'EC01', 'PT INFORMASI TEKNOLOGI INDONESIA', 'Gedung Graha Orange', '0000023432', 'JAKARTA', '', '', '', '', '', '', '', '', 14, '', '', '', '', '', '', 'V014', '2014-10-08'),
(301, '300306', 'EC01', 'PT GRAHA BERKAT ABADI', 'Jl. KH Jainul Arifin No. 33AB', '0000023433', 'JAKARTA', '', '', '', '', '', '', '', '', 14, '', '', '', '', '', '', 'V014', '2014-10-08'),
(302, '300307', 'EC01', 'DUFO FURNITURE', 'Pondok Gede Raya No.18B', '0000023434', 'JAKARTA', '', '', '', '', '', '', '', '', 14, '', '', '', '', '', '', 'V014', '2014-10-08'),
(303, '300308', 'EC01', 'PT ARTDECO INTI KREASI', '29H Jl. Cipinang Muara 2', '0000023435', 'JAKARTA TIMUR', '13430', '', '', '', '', '', '02.127.151.5-008.000', '', 14, '', '', '', '', '', '', 'V014', '2014-10-08'),
(304, '300309', 'EC01', 'PT SURYA DWI INTI', 'Jl. Kalimanggis No. 39', '0000023436', 'JAKARTA', '17435', '', '', '', '', '', '', '', 14, '', '', '', '', '', '', 'V014', '2014-10-08'),
(305, '300310', 'EC01', 'PT MAKMUR RAHARJA', 'Gd. Pwink Center Lt.8', '0000023437', 'JAKARTA', '12790', '', '', '', '', '', '', '', 14, '', '', '', '', '', '', 'V014', '2014-10-08'),
(306, '300311', 'EC01', 'PT KELOLA SUKSES PRADANI', 'Jl. TMP Kalibata No.1Rawajati', '0000023438', 'JAKARTA', '12750', '', '', '', '', '', '', '', 14, '', '', '', '', '', '', 'V014', '2014-10-08'),
(307, '300312', 'EC01', 'PT FAJAR SURYA PERKASA', 'Wisma PENTA Lt. VIJl. Kebon Sirih', '0000023439', 'JAKARTA', '', '', '', '', '', '', '', '', 14, '', '', '', '', '', '', 'V014', '2014-10-08'),
(308, '300313', 'EC01', 'PT GAPURA OMEGA ALPHA LAND', 'Depok MaharajaRangkapan Jaya', '0000023440', 'JAKARTA', '', '', '', '', '', '', '', '', 14, '', '', '', '', '', '', 'V014', '2014-10-08'),
(309, '300314', 'EC01', 'PT HADISURJO PROPERTAMA', 'Jl. Melawai Raya No. 67-68', '0000023441', 'JAKARTA', '', '', '', '', '', '', '', '', 14, '', '', '', '', '', '', 'V014', '2014-10-08'),
(310, '300315', 'EC01', 'ALEXANDER HARTAWAN', 'Jakarta', '0000023442', 'JAKARTA', '', '', '', '', '', '', '', '', 14, '', '', '', '', '', '', 'V014', '2014-10-08'),
(311, '300316', 'EC01', 'PT INDAH PESONA BOGOR', 'jln. Siliwangi No. 123', '0000023443', 'BOGOR', '16142', '', '', '', '', '', '02.059.270.5.404.000', '', 14, '', '', '', '', '', '', 'V014', '2014-10-08'),
(312, '300317', 'EC01', 'PT MULTI NUSANTARA KARYAX', 'Jln. Siliwangi No. 123Sukasari', '0000023444', 'JAKARTA', '16142', '', '', '', '', '', '', '', 14, '', '', '', '', '', '', 'V014', '2014-10-08'),
(313, '300318', 'EC01', 'PT HOME CENTER INDONESIA', 'Jln. Puri Kencana No.1', '0000023445', 'JAKARTA', '11610', '', '', '', '', '', '', '', 14, '', '', '', '', '', '', 'V014', '2014-10-08'),
(314, '300319', 'EC01', 'PT BONET UTAMA', 'Jl. Raya Pajajaran No. 88 F', '0000023446', 'BOGOR', '16153', '', '', '', '', '', '', '', 14, '', '', '', '', '', '', 'V014', '2014-10-08'),
(315, '300320', 'EC01', 'PT SARANA SOLUSINDO INFORMATIKA', 'Kedoya Elok Plaza Blok DC 50', '0000023447', 'JAKARTA', '', '', '', '', '', '', '', '', 14, '', '', '', '', '', '', 'V014', '2014-10-08'),
(316, '300321', 'EC01', 'PT NUSANTARI SENTOSA PRATAMA', 'Gd. Lina Lt.5/510', '0000023448', 'JAKARTA', '12910', '', '', '', '', '', '', '', 14, '', '', '', '', '', '', 'V014', '2014-10-08'),
(317, '300322', 'EC01', 'PT INDONESIA DIGITAL MEDIA', 'Jl. Mede No. 5Utan Kayu Utara', '0000023449', 'JAKARTA', '13120', '', '', '', '', '', '', '', 14, '', '', '', '', '', '', 'V014', '2014-10-08'),
(318, '300323', 'EC01', 'PT SADIKUN NIAGAMAS RAYA', 'Jl. Pinangsia Timur No. 4/A RT004', '0000023450', 'JAKARTA', '', '', '', '', '', '', '', '', 14, '', '', '', '', '', '', 'V014', '2014-10-08'),
(319, '300324', 'EC01', 'PT DWI PUTRA ADITUNGGAL', 'Jl. Panji Semirang No. 27-28', '0000023451', 'JAKARTA', '', '', '', '', '', '', '', '', 14, '', '', '', '', '', '', 'V014', '2014-10-08'),
(320, '300325', 'EC01', 'PT TRI DEWANTARA PERKASA', 'Wisma Nugra Santana 13th Floor', '0000023452', 'JAKARTA', '10220', '', '', '', '', '', '', '', 14, '', '', '', '', '', '', 'V014', '2014-10-08'),
(321, '300326', 'EC01', 'CV HALWAHILWA ADV', 'Jln Raya Bekasi km.23 Rt02/04', '0000023453', 'JAKARTA', '', '', '', '', '', '', '', '', 14, '', '', '', '', '', '', 'V014', '2014-10-08'),
(322, '300327', 'EC01', 'PT SALVO INTERNATIONAL', 'Apartemen Paladian Park Tower S', '0000023454', 'JAKARTA', '', '', '', '', '', '', '', '', 14, '', '', '', '', '', '', 'V014', '2014-10-08'),
(323, '300328', 'EC01', 'PT SARANA MITRA SEMPURNA', 'Komplek Depperindag', '0000023455', 'JAKARTA', '12750', '', '', '', '', '', '', '', 14, '', '', '', '', '', '', 'V014', '2014-10-08'),
(324, '300329', 'EC01', 'PT DISA SINERGI CAKRAWALA', 'jln. Raya No. 12 A RT/RW 001/005', '0000023456', 'JAKARTA', '', '', '', '', '', '', '', '', 14, '', '', '', '', '', '', 'V014', '2014-10-08'),
(325, '300330', 'EC01', 'PT APIX', 'Jl. Biak No. 3 RT002/RW006', '0000023457', 'JAKARTA', '', '', '', '', '', '', '31.238.261.7-028.000', '', 14, '', '', '', '', '', '', 'V014', '2014-10-08'),
(326, '300331', 'EC01', 'PT HIPERNET INDODATA', 'Jl. Latumenten III barat No. 4 RT00', '0000023458', 'JAKARTA', '11460', '', '', '', '', '', '', '', 14, '', '', '', '', '', '', 'V014', '2014-10-08'),
(327, '300332', 'EC01', 'JULIA IRENE TANUBRATA', 'Jl. Cinere Raya RT004 RW008', '0000023459', 'JAKARTA', '', '', '', '', '', '', '', '', 14, '', '', '', '', '', '', 'V014', '2014-10-08'),
(328, '300333', 'EC01', 'PT MITRA SELARAS GRAFIKA', 'Jln. Kebon Kosong No. 53', '0000023460', 'JAKARTA', '', '', '', '', '', '', '', '', 14, '', '', '', '', '', '', 'V014', '2014-10-08'),
(329, '300334', 'EC01', 'PT MAXINDO NETWORK', 'Jl. Marina Raya Rkc Blok H No. 77', '0000023461', 'JAKARTA', '14470', '', '', '', '', '', '', '', 14, '', '', '', '', '', '', 'V014', '2014-10-08'),
(330, '300335', 'EC01', 'PT BERKAH ASIA PACIFIC', 'Jl. Mampang Prapatan Raya No. 32', '0000023462', 'JAKARTA', '', '', '', '', '', '', '', '', 14, '', '', '', '', '', '', 'V014', '2014-10-08'),
(331, '300336', 'EC01', 'PT JESA ARTHA KARYA', 'Rukan Puri TirtaJln. Puri Kencana B', '0000023463', 'JAKARTA', '11610', '', '', '', '', '', '', '', 14, '', '', '', '', '', '', 'V014', '2014-10-08'),
(332, '300288', 'EC01', 'PT ALFA GOLDLAND REALTY', 'Jl. Palmerah Utara No.96B', '0000023415', 'JAKARTA', '', '', '', '', '', '', '', '', 14, '', '', '', '', '', '', 'V014', '2014-10-08'),
(333, '300289', 'EC01', 'PT SERASI AUTORAYA', 'Jl. Mitra Sunter Boulevard Blok C2', '0000023416', 'JAKARTA', '14350', '', '', '', '', '', '', '', 14, '', '', '', '', '', '', 'V014', '2014-10-08'),
(334, '300290', 'EC01', 'PT BENTENG TEGUH PERKASA', 'Jl. Raya Bogor Km. 19 Kramat Jati', '0000023417', 'JAKARTA', '13510', '', '', '', '', '', '', '', 14, '', '', '', '', '', '', 'V014', '2014-10-08'),
(335, '300291', 'EC01', 'CV DUAPULUH DUABELAS', 'Jln. Raya Bekasi KM.18', '0000023418', 'JAKARTA', '', '', '', '', '', '', '', '', 14, '', '', '', '', '', '', 'V014', '2014-10-08'),
(336, '300292', 'EC01', 'PT BERKAT SARANA AIRCON', 'Jl. Taman Sari Raya 66Lt.4', '0000023419', 'JAKARTA', '11150', '', '', '', '', '', '02.566.605.8-032.000', '', 14, '', '', '', '', '', '', 'V014', '2014-10-08'),
(337, '300293', 'EC01', 'PT MANDIRI CIPTA GEMILANG', 'Jl. Komp. Perum Puri Indah RT001', '0000023420', 'JAKARTA', '11610', '', '', '', '', '', '', '', 14, '', '', '', '', '', '', 'V014', '2014-10-08'),
(338, '300294', 'EC01', 'PT ALDEKA SUKSES SEJAHTERA', 'Jln. Patal Senayan 1 No.5 Blok B-17', '0000023421', 'JAKARTA', '', '', '', '', '', '', '', '', 14, '', '', '', '', '', '', 'V014', '2014-10-08'),
(339, '300345', 'EC01', 'PT CIBINONG SQUARE', 'jl. Raya Bogor KM 44 Cibinong', '0000023472', 'JAKARTA', '', '', '', '', '', '', '', '', 14, '', '', '', '', '', '', 'V014', '2014-10-08'),
(340, '300346', 'EC01', 'PT JONATHAN MANDIRI', 'Jl. Daan Mogot, Komp. Aldiron No. D', '0000023473', 'JAKARTA', '11460', '', '', '', '', '', '', '', 14, '', '', '', '', '', '', 'V014', '2014-10-08'),
(341, '300347', 'EC01', 'KJPP. AKSA, NELSON & REKAN', 'Jl. Ciledug Raya Blok A7 No. 7 RT00', '0000023474', 'JAKARTA', '', '', '', '', '', '', '', '', 14, '', '', '', '', '', '', 'V014', '2014-10-08'),
(342, '300348', 'EC01', 'PT INDOINTERNET', 'Jl. Rempoa Raya No. 11 Ciputat', '0000023479', 'JAKARTA', '15412', '', '', '', '', '', '', '', 14, '', '', '', '', '', '', 'V014', '2014-10-08'),
(343, '300349', 'EC01', 'PT MITRA SOLUSI INFOKOM', 'Jl. Kampung Melayu Besar No. 19A', '0000023480', 'JAKARTA', '12840', '', '', '', '', '', '', '', 14, '', '', '', '', '', '', 'V014', '2014-10-08'),
(344, '300350', 'EC01', 'PT JOBS DB INDONESIA', 'Wisma 77, Lantai 6', '0000023481', 'JAKARTA', '11410', '', '', '', '', '', '', '', 14, '', '', '', '', '', '', 'V014', '2014-10-08'),
(345, '300351', 'EC01', 'PT NURBANYU ANUGERAH SEJATI', 'Jl. Raya Mayor Oking Km 3.5', '0000023482', 'JAKARTA', '', '', '', '', '', '', '', '', 14, '', '', '', '', '', '', 'V014', '2014-10-08'),
(346, '300352', 'EC01', 'PT FHIKO INTERIOR', 'Ruko Taman Buah', '0000023483', 'JAKARTA', '15151', '', '', '', '', '', '31.436.787.1.416.000', '', 14, '', '', '', '', '', '', 'V014', '2014-10-08'),
(347, '300353', 'EC01', 'BERDIKARI BERSAMA', 'Jln. I Gusti Ngurah Rai No. 16', '0000023484', 'JAKARTA', '', '', '', '', '', '', '', '', 14, '', '', '', '', '', '', 'V014', '2014-10-08'),
(348, '300354', 'EC01', 'PT RAF KOMUNIKASI', 'Jl. Taman Chrysant 2 Blok N.8/5', '0000023485', 'BANTEN', '', '', '', '', '', '', '31.495.962.8.411.000', '', 14, '', '', '', '', '', '', 'V014', '2014-10-08'),
(349, '300355', 'EC01', 'PT PRESTIGE INDONESIA', 'Wisma 77 Lt. 6', '0000023486', 'JAKARTA', '11410', '', '', '', '', '', '', '', 14, '', '', '', '', '', '', 'V014', '2014-10-08'),
(350, '300356', 'EC01', 'PT. MULTI NUSANTARA KARYA', 'Jl. Raya Bogor Km. 19', '0000023487', 'JAKARTA', '13510', '', '', '', '', '', '', '', 14, '', '', '', '', '', '', 'V014', '2014-10-08'),
(351, '300357', 'EC01', 'CV HIZKIA TIRTA GEMILANG', 'Jl. Jurang Mangu Utama RT001/RW01', '0000023488', 'JAKARTA', '15224', '', '', '', '', '', '', '', 14, '', '', '', '', '', '', 'V014', '2014-10-08'),
(352, '300358', 'EC01', 'PT MAXINDO INTERNATIONAL NUSANTARA', 'Jl. Sutan Iskandar Muda No. 9', '0000023489', 'JAKARTA', '', '', '', '', '', '', '', '', 14, '', '', '', '', '', '', 'V014', '2014-10-08'),
(353, '300359', 'EC01', 'PT BUANA MANDIRI SELARAS', 'Jl. Sunset Road (Sebelah XL)', '0000023490', 'BADUNG,BALI', '80361', '', '', '', '', '', '02.672.147.2.904.001', '', 14, '', '', '', '', '', '', 'V014', '2014-10-08'),
(354, '300360', 'EC01', 'PT MITRASOFT INFONET', 'Niaga Roxy Mas Blok E-2/03', '0000023491', 'JAKARTA', '10150', '', '', '', '', '', '', '', 14, '', '', '', '', '', '', 'V014', '2014-10-08'),
(355, '300361', 'EC01', 'PT INDO NIAGA CEMERELANG', 'Ario Bimo Central 4th floor', '0000023492', 'JAKARTA', '12950', '', '', '', '', '', '', '', 14, '', '', '', '', '', '', 'V014', '2014-10-08'),
(356, '300362', 'EC01', 'PT GUNUNG BINTANG SEMESTA', 'Jln. Danau Sunter Utara Blok J12', '0000023493', 'JAKARTA', '', '', '', '', '', '', '', '', 14, '', '', '', '', '', '', 'V014', '2014-10-08'),
(357, '300363', 'EC01', 'KWOK KIAN SIN', 'Komplek KST D7/4', '0000023494', 'JAKARTA', '', '', '', '', '', '', '', '', 14, '', '', '', '', '', '', 'V014', '2014-10-08'),
(358, '300364', 'EC01', 'PT GRAHA BUANA PRIMA', 'Jl. K. H Hasyim Ashari 125', '0000023495', 'JAKARTA', '10150', '', '', '', '', '', '', '', 14, '', '', '', '', '', '', 'V014', '2014-10-08'),
(359, '300365', 'EC01', 'DIMAS GUNANDA', 'Nologaten No.236A RT.07 RW.02', '0000023496', 'JAKARTA', '', '', '', '', '', '', '', '', 14, '', '', '', '', '', '', 'V014', '2014-10-08'),
(360, '300366', 'EC01', 'PT SUKSES ENERGI PERDANA', 'Jln Raya Meruya Hilir No. 88', '0000023497', 'JAKARTA', '11620', '', '', '', '', '', '', '', 14, '', '', '', '', '', '', 'V014', '2014-10-08'),
(361, '300367', 'EC01', 'TJHEN TEK TJOENG', 'Jakarta', '0000023498', 'JAKARTA', '', '', '', '', '', '', '', '', 14, '', '', '', '', '', '', 'V014', '2014-10-08'),
(362, '300368', 'EC01', 'I KETUT NURJAYA', 'Jl. Warmadewa No.3C Ubung Kaja', '0000023499', 'JAKARTA', '', '', '', '', '', '', '', '', 14, '', '', '', '', '', '', 'V014', '2014-10-08'),
(363, '300369', 'EC01', 'G-NETWORKS', 'Jln Sutoyo 27C', '0000023500', 'BALI', '80112', '', '', '', '', '', '', '', 14, '', '', '', '', '', '', 'V014', '2014-10-08'),
(364, '300370', 'EC01', 'PT DUTA INDAH PRATAMA', 'Jln. Anggrek Nelly Mumi Blok A99', '0000023501', 'JAKARTA', '', '', '', '', '', '', '', '', 14, '', '', '', '', '', '', 'V014', '2014-10-08'),
(365, '300371', 'EC01', 'JAVA MEDIA COMPUTER', 'Rimo Lt.III No.33Jln. Diponegoro 13', '0000023502', 'JAKARTA', '', '', '', '', '', '', '', '', 14, '', '', '', '', '', '', 'V014', '2014-10-08'),
(366, '300372', 'EC01', 'PT ADIJAYA PRATAMA MANDIRI', 'Lt.5 PX Pavillion St. Moritz', '0000023503', 'JAKARTA', '11610', '', '', '', '', '', '', '', 14, '', '', '', '', '', '', 'V014', '2014-10-08'),
(367, '300373', 'EC01', 'BERKAT BERSAUDARA STATIONARY', 'WTC Mangga Dua Lt. 2 Blok A No. 58J', '0000023504', 'JAKARTA', '', '', '', '', '', '', '', '', 14, '', '', '', '', '', '', 'V014', '2014-10-08'),
(368, '300374', 'EC01', 'PT SERVIAM EXCEL INDONESIA', 'Kompleks Duta Merlin Blok B31-32', '0000023505', 'JAKARTA', '', '', '', '', '', '', '', '', 14, '', '', '', '', '', '', 'V014', '2014-10-08'),
(369, '300375', 'EC01', 'PT PRATAMA INDOMITRA KONSULTAN', 'PP Plaza 3rd floor', '0000023506', 'JAKARTA', '', '', '', '', '', '', '', '', 14, '', '', '', '', '', '', 'V014', '2014-10-08'),
(370, '300376', 'EC01', 'PT INDOLOK BAKTI UTAMA', 'Jln. Salemba Raya No. 32', '0000023507', 'JAKARTA', '', '', '', '', '', '', '', '', 14, '', '', '', '', '', '', 'V014', '2014-10-08'),
(371, '300377', 'EC01', 'PT LINK NET Tbk', 'GEDUNG BERITASATU PLAZA LANTAI 4', '0000023508', 'JAKARTA', '12950', '', '', '', '', '', '01.770.114.5.054.000', '', 14, '', '', '', '', '', '', 'V014', '2014-10-08'),
(372, '300378', 'EC01', 'TRANS KOMPUTER', 'Jln. Merak Jingga No. 176', '0000023509', 'JAKARTA', '', '', '', '', '', '', '', '', 14, '', '', '', '', '', '', 'V014', '2014-10-08'),
(373, '300379', 'EC01', 'CV DELTA NIAGA MANDIRI', 'Jl. Irian Jaya Raya Blok IX No. 194', '0000023510', 'JAKARTA', '', '', '', '', '', '', '', '', 14, '', '', '', '', '', '', 'V014', '2014-10-08'),
(374, '300380', 'EC01', 'PT DENKO WAHANA SAKTI', 'Komplek Duta Merlin Blok C 1-3', '0000023511', 'JAKARTA', '10130', '', '', '', '', '', '', '', 14, '', '', '', '', '', '', 'V014', '2014-10-08'),
(375, '300381', 'EC01', 'PT RAMA KOMUNIKA MEDIATAMA', 'Jl. Tebet Utara IVA/10', '0000023512', 'JAKARTA', '', '', '', '', '', '', '', '', 14, '', '', '', '', '', '', 'V014', '2014-10-08'),
(376, '300382', 'EC01', 'PT.PLATBOARD LUTDESINDO', 'JL.Kemuning V Blok M9 Century 2', '0000023513', 'JAKARTA', '', '', '', '', '', '', '', '', 14, '', '', '', '', '', '', 'V014', '2014-10-08'),
(377, '300383', 'EC01', 'PT INDECO PRIMA', 'Jl. Kejaksaan Blok G No. 176', '0000023514', 'JAKARTA', '13430', '', '', '', '', '', '', '', 14, '', '', '', '', '', '', 'V014', '2014-10-08'),
(378, '300384', 'EC01', 'PT EVENTUS SOLUTION', 'Mega Kemayoran Mall Lt. UG Blok B-0', '0000023515', 'JAKARTA', '', '', '', '', '', '', '', '', 14, '', '', '', '', '', '', 'V014', '2014-10-08'),
(379, '300385', 'EC01', 'PT REKARUPA RIDHA KARYA', 'Jln. Taman Lebak Bulus Raya Blok L', '0000023516', 'JAKARTA', '', '', '', '', '', '', '', '', 14, '', '', '', '', '', '', 'V014', '2014-10-08'),
(380, '300337', 'EC01', 'PT CAHAYA ANUGERAH SELARAS', 'Podomoro CityRuko Garden Shopping', '0000023464', 'JAKARTA', '11470', '', '', '', '', '', '', '', 14, '', '', '', '', '', '', 'V014', '2014-10-08'),
(381, '300338', 'EC01', 'INDAH JAYA ABADI', 'ITC Mangga Dua Lt. Dasar', '0000023465', 'JAKARTA', '', '', '', '', '', '', '', '', 14, '', '', '', '', '', '', 'V014', '2014-10-08'),
(382, '300339', 'EC01', 'PT LANCAR SUKSES MANDIRI', 'Jl. Let. Jend Suprapto No. 82', '0000023466', 'JAKARTA', '10540', '', '', '', '', '', '', '', 14, '', '', '', '', '', '', 'V014', '2014-10-08'),
(383, '300340', 'EC01', 'PT TEAM CREATIVE DESIGN', 'Jl. Kelapa Hibrida Raya Blok QJ 9 N', '0000023467', 'JAKARTA', '14240', '', '', '', '', '', '', '', 14, '', '', '', '', '', '', 'V014', '2014-10-08'),
(384, '300341', 'EC01', 'CV KHATULISTIWA PROMO', 'Jln. Raya Mauk KM.01 Sepatan', '0000023468', 'JAKARTA', '15530', '', '', '', '', '', '', '', 14, '', '', '', '', '', '', 'V014', '2014-10-08'),
(385, '300342', 'EC01', 'PT MULTI MEDIA PERSADA ADVERTISING', 'Jl. Tanjung Duren Raya No.542', '0000023469', 'JAKARTA', '', '', '', '', '', '', '', '', 14, '', '', '', '', '', '', 'V014', '2014-10-08'),
(386, '300343', 'EC01', 'PT PELITA SONA SAMPURNA', 'Perum Jatibening Estate C4', '0000023470', 'JAKARTA', '17412', '', '', '', '', '', '', '', 14, '', '', '', '', '', '', 'V014', '2014-10-08'),
(387, '300344', 'EC01', 'RAYAN SUGANDI', 'Jl. Raya Bogor KM 44 Cibinong', '0000023471', 'BOGOR', '', '', '', '', '', '', '', '', 14, '', '', '', '', '', '', 'V014', '2014-10-08'),
(388, '300395', 'EC01', 'PT MORRIGAN SERVICES', 'Sampoerna Strategic SquareTower B', '0000023562', 'JAKARTA', '', '', '', '', '', '', '', '', 14, '', '', '', '', '', '', 'V014', '2014-10-08'),
(389, '300396', 'EC01', 'PT.PLUIT AUTOPLAZA', 'Jakarta', '0000023563', 'JAKARTA', '', '', '', '', '', '', '', '', 14, '', '', '', '', '', '', 'V014', '2014-10-08'),
(390, '300397', 'EC01', 'HIOE THIN TJHONG', 'Bandengan Utara No. 36 BRT 014/RW 0', '0000023568', 'JAKARTA', '', '', '', '', '', '', '', '', 14, '', '', '', '', '', '', 'V014', '2014-10-08'),
(391, '300398', 'EC01', 'PT PHOENIX COMMUNICATIONS', 'Jl. Benda Raya No. 98 A-B', '0000023573', 'JAKARTA', '12560', '', '', '', '', '', '', '', 14, '', '', '', '', '', '', 'V014', '2014-10-08'),
(392, '300399', 'EC01', 'PT REPUBLIKA MEDIA MANDIRI', 'Jln. Warung Buncit Raya No. 37', '0000023578', 'JAKARTA', '12510', '', '', '', '', '', '', '', 14, '', '', '', '', '', '', 'V014', '2014-10-08'),
(393, '300400', 'EC01', 'PT SANWAMAS METAL INDUSTRY', 'Jln. Let. Jen. S. Parman Kav.32-34', '0000023583', 'JAKARTA', '11480', '', '', '', '', '', '', '', 14, '', '', '', '', '', '', 'V014', '2014-10-08'),
(394, '300401', 'EC01', 'PT JAKARTA INDUSTRIAL ESTATE PULOGA', 'JL. PULO BUARAN 3 BLOK V2/V4', '0000023584', 'JAKARTA', '', '', '', '', '', '', '', '', 14, '', '', '', '', '', '', 'V014', '2014-10-08'),
(395, '300402', 'EC01', 'SAIDIN KONTRAKTOR', 'Jl. Bungur RT010 RW06 No, 12', '0000023589', 'JAKARTA', '', '', '', '', '', '', '', '', 14, '', '', '', '', '', '', 'V014', '2014-10-08'),
(396, '300403', 'EC01', 'PT WAHANA SEMESTA BANTEN', 'Gedung Graha Pena Radar', '0000023598', 'JAKARTA', '', '', '', '', '', '', '', '', 14, '', '', '', '', '', '', 'V014', '2014-10-08'),
(397, '300404', 'EC01', 'PT GEOBILLBOARD INDONESIA', 'Taman Alfa Indah Blok D.8/13 RT 05', '0000023599', 'JAKARTA', '11640', '', '', '', '', '', '', '', 14, '', '', '', '', '', '', 'V014', '2014-10-08'),
(398, '300405', 'EC01', 'PT ANEKA SUMBER DAYA ENERGI', 'Jl. Ir. H. Juanda No. 115', '0000023608', 'JAKARTA', '', '', '', '', '', '', '', '', 14, '', '', '', '', '', '', 'V014', '2014-10-08'),
(399, '300406', 'EC01', 'PT GARDA TOTAL SECURITY', 'Jl. Salihara RT 03 RW 01', '0000023613', 'JAKARTA', '', '', '', '', '', '', '', '', 14, '', '', '', '', '', '', 'V014', '2014-10-08'),
(400, '300407', 'EC01', 'PT MEKAS DAVINA ABADI', 'Jakarta', '0000023626', 'JAKARTA', '', '', '', '', '', '', '', '', 14, '', '', '', '', '', '', 'V014', '2014-10-08'),
(401, '300408', 'EC01', 'PT MEDIA NETWORK WAHANA', 'Gd. Sarinah Lt.8', '0000023631', 'JAKARTA', '10350', '', '', '', '', '', '', '', 14, '', '', '', '', '', '', 'V014', '2014-10-08'),
(402, '300409', 'EC01', 'PT WIRA CIPTA SEJAHTERA', 'Patra Office Tower Lt. XVII Ruang 1', '0000023640', 'JAKARTA', '', '', '', '', '', '', '', '', 14, '', '', '', '', '', '', 'V014', '2014-10-08'),
(403, '300410', 'EC01', 'PT SENTRAL LINK SOLUTIONS', 'Tower A - Kompleks Perkantoran LOT1', '0000023641', 'JAKARTA', '12190', '', '', '', '', '', '', '', 14, '', '', '', '', '', '', 'V014', '2014-10-08'),
(404, '300411', 'EC01', 'PT INTI UTAMA DHARMA RE', 'Jl. Cipinang Indah Raya No. 1', '0000023642', 'JAKARTA', '13420', '', '', '', '', '', '', '', 14, '', '', '', '', '', '', 'V014', '2014-10-08'),
(405, '300412', 'EC01', 'PT PANTONPILE CITRATAMA', 'Jl. Kedoya Agave Blok A1 No. 5', '0000023647', 'JAKARTA', '11520', '', '', '', '', '', '', '', 14, '', '', '', '', '', '', 'V014', '2014-10-08'),
(406, '300413', 'EC01', 'PT PANTONPILE KWARTATAMA', 'Jl. Kedoya Agave Blok A1 No. 5', '0000023648', 'JAKARTA', '11520', '', '', '', '', '', '', '', 14, '', '', '', '', '', '', 'V014', '2014-10-08'),
(407, '300414', 'EC01', 'PT DAIHAN CIPTA PRIMA', 'Jl. Veteran No. 27 RT 001 RW 005', '0000023653', 'JAKARTA', '', '', '', '', '', '', '', '', 14, '', '', '', '', '', '', 'V014', '2014-10-08'),
(408, '300415', 'EC01', 'ANDREAS', 'Jl. Jend. Sudirman Komp. BP Blok F2', '0000023662', 'JAKARTA', '', '', '', '', '', '', '', '', 14, '', '', '', '', '', '', 'V014', '2014-10-08'),
(409, '300416', 'EC01', 'RUDIYANTO', 'Jakarta', '0000023667', 'JAKARTA', '', '', '', '', '', '', '', '', 14, '', '', '', '', '', '', 'V014', '2014-10-08'),
(410, '300417', 'EC01', 'PT AETRA AIR JAKARTA', 'Sampoerna Strategic Square', '0000023676', 'JAKARTA', '', '', '', '', '', '', '', '', 14, '', '', '', '', '', '', 'V014', '2014-10-08'),
(411, '300418', 'EC01', 'PT SINAR BERLIAN AUTO GRAHA', 'Jl. Raya Bogor Km 49', '0000023677', 'BOGOR', '16912', '', '', '', '', '', '', '', 14, '', '', '', '', '', '', 'V014', '2014-10-08'),
(412, '300419', 'EC01', 'PT SINAR MUTIARA INDAH', 'Jl. Pinangsia Timur No 4A', '0000023682', 'JAKARTA', '11110', '', '', '', '', '', '', '', 14, '', '', '', '', '', '', 'V014', '2014-10-08'),
(413, '300420', 'EC01', 'PT PANDEGA CITRANIAGA', 'Jl. Jend. Sudirman No. 01', '0000023691', 'BALIKPAPAN', '', '', '', '', '', '', '', '', 14, '', '', '', '', '', '', 'V014', '2014-10-08'),
(414, '300421', 'EC01', 'PT RAFINDO ANUGRAH SUKSES', 'Stadion Lebak BulusBlok DD-05-09', '0000023696', 'JAKARTA', '12440', '', '', '', '', '', '', '', 14, '', '', '', '', '', '', 'V014', '2014-10-08'),
(415, '300422', 'EC01', 'PT KARLIN MASTRINDO', 'Gd. Berca Indonesia Lt. 3 R303', '0000023701', 'JAKARTA', '11480', '', '', '', '', '', '', '', 14, '', '', '', '', '', '', 'V014', '2014-10-08'),
(416, '300423', 'EC01', 'PT DELTA MERLIN DUNIA PROPERTI', 'Madegondo', '0000023706', 'SUKOHARJO', '', '', '', '', '', '', '', '', 14, '', '', '', '', '', '', 'V014', '2014-10-08'),
(417, '300424', 'EC01', 'PT RIYADI REKSASE NUSANTARA', 'Gd. Ariobimo Sentral Lt. 10', '0000023711', 'JAKARTA', '12950', '', '', '', '', '', '', '', 14, '', '', '', '', '', '', 'V014', '2014-10-08'),
(418, '300425', 'EC01', 'PT ISLANDS CIPTA KREASI', 'Jl. Pluit Kencana Raya No. 104 RT 1', '0000023716', 'JAKARTA', '', '', '', '', '', '', '', '', 14, '', '', '', '', '', '', 'V014', '2014-10-08'),
(419, '300426', 'EC01', 'YOHANES', 'Jl. Jend. Sudirman No. 250', '0000023717', 'JAKARTA', '41115', '', '', '', '', '', '', '', 14, '', '', '', '', '', '', 'V014', '2014-10-08'),
(420, '300427', 'EC01', 'PT CUSHMAN & WAKEFIELD INDONESIA', 'Indonesia Stock Exchange Building 2', '0000023718', 'JAKARTA', '12190', '', '', '', '', '', '', '', 14, '', '', '', '', '', '', 'V014', '2014-10-08'),
(421, '300428', 'EC01', 'KJPP IHOT, DOLLAR & RAYMOND', 'Jl. Sultan Iskandar Muda No. 5c', '0000023719', 'JAKARTA', '', '', '', '', '', '', '', '', 14, '', '', '', '', '', '', 'V014', '2014-10-08'),
(422, '300429', 'EC01', 'PT CENERICO SUKSES SENTOSA', '66 Jl.Petir Utama', '0000023724', 'BANTEN', '', '', '', '', '', '', '71.660.517.5.416.000', '', 14, '', '', '', '', '', '', 'V014', '2014-10-08'),
(423, '300430', 'EC01', 'CV TATA SETYA WARDHANA', 'Jl. Lettu. RM Hartono', '0000023725', 'JAKARTA', '', '', '', '', '', '', '02.376.942.5.532.000', '', 14, '', '', '', '', '', '', 'V014', '2014-10-08'),
(424, '300431', 'EC01', 'SITI AMINAH TRIASPUTRI', 'Jakarta', '0000023734', 'JAKARTA', '', '', '', '', '', '', '', '', 14, '', '', '', '', '', '', 'V014', '2014-10-08'),
(425, '300432', 'EC01', 'PT RAMAYANA LESTARI SENTOSA TBK', 'Jl. KH. Wahid Hasyim 220 A-B', '0000023735', 'JAKARTA', '', '', '', '', '', '', '', '', 14, '', '', '', '', '', '', 'V014', '2014-10-08'),
(426, '300433', 'EC01', 'PT JAKARTA INTILAND', 'jl. KH. Wahid Hasyim 220 A-B', '0000023740', 'JAKARTA', '', '', '', '', '', '', '', '', 14, '', '', '', '', '', '', 'V014', '2014-10-08'),
(427, '300434', 'EC01', 'PT DITAMA SUKSES MANDIRI', 'Gd. Bank Panin Pusat Lt. 4', '0000023745', 'JAKARTA', '', '', '', '', '', '', '', '', 14, '', '', '', '', '', '', 'V014', '2014-10-08'),
(428, '300386', 'EC01', 'ANGKASA BALI', 'Jakarta', '0000023517', 'JAKARTA', '', '', '', '', '', '', '', '', 14, '', '', '', '', '', '', 'V014', '2014-10-08'),
(429, '300387', 'EC01', 'PT SEMAR GEMILANG', 'Jln. Desa Simpangan Pertigaan', '0000023518', 'JAKARTA', '', '', '', '', '', '', '', '', 14, '', '', '', '', '', '', 'V014', '2014-10-08'),
(430, '300388', 'EC01', 'PT GRIYAPESONA MENTARI', 'APL Tower Central Park T6Lt.7', '0000023519', 'JAKARTA', '11470', '', '', '', '', '', '', '', 14, '', '', '', '', '', '', 'V014', '2014-10-08'),
(431, '300389', 'EC01', 'JIMMY PRASETYO & REKAN', 'Jl. Batu Ceper IV No. 6ALt. 1-2', '0000023524', 'JAKARTA', '10120', '', '', '', '', '', '', '', 14, '', '', '', '', '', '', 'V014', '2014-10-08'),
(432, '300390', 'EC01', 'PT MULTI NUSANTARA KARYA', 'Jl. Sunset Road,Badung', '0000023533', 'BALI', '80361', '', '', '', '', '', '', '', 14, '', '', '', '', '', '', 'V014', '2014-10-08'),
(433, '300391', 'EC01', 'JAYA MANDIRI', 'Jln. Lesmana Dalam No. 90A', '0000023538', 'JAKARTA', '', '', '', '', '', '', '', '', 14, '', '', '', '', '', '', 'V014', '2014-10-08'),
(434, '300392', 'EC01', 'PT MANDIRI MAJU SENTOSA', 'Jln. Veteran No. 7 Serang', '0000023543', 'BANTEN', '', '', '', '', '', '', '', '', 14, '', '', '', '', '', '', 'V014', '2014-10-08'),
(435, '300393', 'EC01', 'CV BALIBOARD ADVERTISING', 'Jln. By pass Ngurah Rai No. 214', '0000023544', 'JAKARTA', '', '', '', '', '', '', '', '', 14, '', '', '', '', '', '', 'V014', '2014-10-08'),
(436, '300394', 'EC01', 'PT KAHAR DUTA SARANA', 'Jln. Raya Poncol No. 10Susukan', '0000023553', 'JAKARTA', '13750', '', '', '', '', '', '', '', 14, '', '', '', '', '', '', 'V014', '2014-10-08'),
(437, '300445', 'EC01', 'PT AGIES MANDIRI FINE', 'Jl. Kelapa Gading Selatan Blok AH', '0000023816', 'JAKARTA', '', '', '', '', '', '', '', '', 14, '', '', '', '', '', '', 'V014', '2014-10-08'),
(438, '300446', 'EC01', 'KJPP HARI UTOMO DAN REKAN', 'Perkantoran Ciputat Indah Permai', '0000023829', 'JAKARTA', '', '', '', '', '', '', '', '', 14, '', '', '', '', '', '', 'V014', '2014-10-08'),
(439, '300447', 'EC01', 'YUDI YULIANTO', 'Jl. Budi Sari I No. 33RT004 RW005', '0000023842', 'JAKARTA', '', '', '', '', '', '', '', '', 14, '', '', '', '', '', '', 'V014', '2014-10-08'),
(440, '300448', 'EC01', 'CV ZEPPLIN ADVERTISING', '36 Jl. Pusut Buhit', '0000023843', 'MEDAN', '', '', '', '', '', '', '21.083.091.5.113.000', '', 14, '', '', '', '', '', '', 'V014', '2014-10-08'),
(441, '300449', 'EC01', 'CV BALI SURYA ADVERTISING', 'Jl. Mertasari', '0000023848', 'JAKARTA', '', '', '', '', '', '', '02.798.204.0.903.000', '', 14, '', '', '', '', '', '', 'V014', '2014-10-08'),
(442, '300450', 'EC01', 'PT.HARRISMA BUWANA JAYA', 'JL.C.SIMANJUNTAK NO 33/37', '0000023857', 'JAKARTA', '', '', '', '', '', '', '', '', 14, '', '', '', '', '', '', 'V014', '2014-10-08'),
(443, '300451', 'EC01', 'PT SINAR KHARISMA PADJADJARAN', 'Jl. Ir. H. Juanda No. 68', '0000023862', 'JAKARTA', '', '', '', '', '', '', '', '', 14, '', '', '', '', '', '', 'V014', '2014-10-08'),
(444, '300452', 'EC01', 'PT LAKSANA BERKAT ABADI', 'Jl. Raya Dayeuhkolot No. 131', '0000023867', 'JAKARTA', '', '', '', '', '', '', '31.339.447.0-009.001', '', 14, '', '', '', '', '', '', 'V014', '2014-10-08'),
(445, '300453', 'EC01', 'CV GENIO BINTANG UTAMA', 'Jl. Gunung Empat No. 16 RT026', '0000023868', 'JAKARTA', '', '', '', '', '', '', '', '', 14, '', '', '', '', '', '', 'V014', '2014-10-08'),
(446, '300454', 'EC01', 'PT TRISTAR LAND', 'Sona Topas Tower 7th floor', '0000023873', 'JAKARTA', '12920', '', '', '', '', '', '', '', 14, '', '', '', '', '', '', 'V014', '2014-10-08'),
(447, '300455', 'EC01', 'PT TRIKATA ESA KARSA', 'Jl. Wijaya I No. 73Kebayoran Baru', '0000023878', 'JAKARTA', '12170', '', '', '', '', '', '', '', 14, '', '', '', '', '', '', 'V014', '2014-10-08'),
(448, '300456', 'EC01', 'PT WAHANA SEMESTA PASUNDAN', 'Jl. Ahmad Yani No 110 RT 006 RW 002', '0000023883', 'JAKARTA', '', '', '', '', '', '', '', '', 14, '', '', '', '', '', '', 'V014', '2014-10-08'),
(449, '300457', 'EC01', 'CANDRA BUDIYANTO ATMAJA', 'Jl. Kapten Patimura 47 RT 002 RW 01', '0000023892', 'JAKARTA', '', '', '', '', '', '', '', '', 14, '', '', '', '', '', '', 'V014', '2014-10-08'),
(450, '300458', 'EC01', 'PT TRIMATRA INOVASI CEMERLANG', 'Jl. Raya Pulo Gebang No. 99B', '0000023897', 'JAKARTA TIMUR', '13950', '', '', '', '', '', '31.539.397.5-006.000', '', 14, '', '', '', '', '', '', 'V014', '2014-10-08'),
(451, '300459', 'EC01', 'PT KREASI LANCAR ORIENTASI PRIMA', 'Jl. Hj. Jian No. 17', '0000023902', 'JAKARTA', '', '', '', '', '', '', '', '', 14, '', '', '', '', '', '', 'V014', '2014-10-08'),
(452, '300460', 'EC01', 'CV SEJAHTERA MANDIRI', 'Jl. Hayam Wuruk 127 K UG C1-3', '0000023903', 'JAKARTA', '', '', '', '', '', '', '', '', 14, '', '', '', '', '', '', 'V014', '2014-10-08'),
(453, '300461', 'EC01', 'JAUW WALUDIN IWAN', 'Jl. Buaran I Blk L.III/1 RT004/012K', '0000023912', 'JAKARTA', '', '', '', '', '', '', '', '', 14, '', '', '', '', '', '', 'V014', '2014-10-08'),
(454, '300462', 'EC01', 'TUNAS SEJAHTERA', 'Komplek IPB 1 Loji', '0000023921', 'BOGOR', '', '', '', '', '', '', '', '', 14, '', '', '', '', '', '', 'V014', '2014-10-08'),
(455, '300463', 'EC01', 'PT MAHKOTA INTI CITRA', 'Jl. Raya Jatinagor KM. 20', '0000023922', 'BANDUNG', '45363', '', '', '', '', '', '', '', 14, '', '', '', '', '', '', 'V014', '2014-10-08'),
(456, '300464', 'EC01', 'PT DUTA MARGAJAYA PERKASA', 'Jakarta', '0000023923', 'JAKARTA', '', '', '', '', '', '', '', '', 14, '', '', '', '', '', '', 'V014', '2014-10-08'),
(457, '300465', 'EC01', 'PT FOCUS KARYA SELARAS', 'Jl. Meruya Ilir Utara No. 46 RT002', '0000023936', 'JAKARTA', '11620', '', '', '', '', '', '', '', 14, '', '', '', '', '', '', 'V014', '2014-10-08'),
(458, '300466', 'EC01', 'CV TATA SETYA WARDHANA (JGN DIPAKE)', 'Jl. Indra Jaya No. 7', '0000023937', 'JAKARTA', '', '', '', '', '', '', '', '', 14, '', '', '', '', '', '', 'V014', '2014-10-08'),
(459, '300467', 'EC01', 'HUMBERG LIE, SH, SE, MKN', 'Raya Pluit Selatan No. 103', '0000023942', 'JAKARTA', '14450', '', '', '', '', '', '', '', 14, '', '', '', '', '', '', 'V014', '2014-10-08'),
(460, '300468', 'EC01', 'WONG JAYA', 'Karawaci Office Park Blok G No. 5 L', '0000023959', 'JAKARTA', '', '', '', '', '', '', '', '', 14, '', '', '', '', '', '', 'V014', '2014-10-08'),
(461, '300469', 'EC01', 'CV ORANGE', 'Jl. A. Yani No. 6 Gunung Sari Ulu', '0000023964', 'JAKARTA', '', '', '', '', '', '', '', '', 14, '', '', '', '', '', '', 'V014', '2014-10-08'),
(462, '300470', 'EC01', 'PT BUMI KENCANA INDAH', 'Jl. Sriwijaya RT 07 RW 11', '0000023965', 'JAKARTA', '40524', '', '', '', '', '', '', '', 14, '', '', '', '', '', '', 'V014', '2014-10-08'),
(463, '300471', 'EC01', 'PT BAYU BUANA SEMESTA', 'Jl. Asgo II No. 1A Pasar Rebo', '0000023970', 'JAKARTA', '', '', '', '', '', '', '', '', 14, '', '', '', '', '', '', 'V014', '2014-10-08'),
(464, '300472', 'EC01', 'PT MITRA KARISMA MEDIA', 'Jl. Ruko Garden Shopping Arcade', '0000023979', 'JAKARTA', '', '', '', '', '', '', '', '', 14, '', '', '', '', '', '', 'V014', '2014-10-08'),
(465, '300473', 'EC01', 'PT DIMENSI GAGAS PRIMA', 'Jl. Palakali no. 24 RT004/RW004', '0000023984', 'JAKARTA', '', '', '', '', '', '', '', '', 14, '', '', '', '', '', '', 'V014', '2014-10-08'),
(466, '300474', 'EC01', 'PT JAYA TEGUH SEMPURNA', 'Jl. Raya Jatinangor No. 150', '0000023993', 'SUMEDANG', '', '', '', '', '', '', '', '', 14, '', '', '', '', '', '', 'V014', '2014-10-08'),
(467, '300475', 'EC01', 'PT CITRA MEGA', 'Jl. Ekor Kuning Raya No.5Jati', '0000023994', 'JAKARTA', '13220', '', '', '', '', '', '', '', 14, '', '', '', '', '', '', 'V014', '2014-10-08'),
(468, '300476', 'EC01', 'PT SENTRA JASA AKTUARIA', 'Jl. RC Veteran No. 11-B RT/RW 001/0', '0000023999', 'JAKARTA SELATAN', '12330', '', '', '', '', '', '01.996.856.9-013.000', '', 14, '', '', '', '', '', '', 'V014', '2014-10-08'),
(469, '300477', 'EC01', 'ASEP WAHYU DWI CAHYONO', 'Jakarta', '0000024000', 'JAKARTA', '', '', '', '', '', '', '', '', 14, '', '', '', '', '', '', 'V014', '2014-10-08'),
(470, '300478', 'EC01', 'PT TULIP PROMO KARYA', 'Jl. Batu Ampar III No.36 RT012 RW00', '0000024005', 'JAKARTA', '13520', '', '', '', '', '', '', '', 14, '', '', '', '', '', '', 'V014', '2014-10-08'),
(471, '300479', 'EC01', 'PT BANGUN GAGAS KARYATAMA', 'Jl. Kaca D2/7 Kompl. Pondok Jaya', '0000024010', 'JAKARTA', '', '', '', '', '', '', '', '', 14, '', '', '', '', '', '', 'V014', '2014-10-08'),
(472, '300480', 'EC01', 'CV RINO\'S', 'Jl. Mulawarman No. 08', '0000024011', 'BALIKPAPAN', '', '', '', '', '', '', '', '', 14, '', '', '', '', '', '', 'V014', '2014-10-08'),
(473, '300481', 'EC01', 'LENNY FERRY FOE', 'Jl. Waspada Raya No.2 RT012 RW013', '0000024016', 'JAKARTA', '', '', '', '', '', '', '', '', 14, '', '', '', '', '', '', 'V014', '2014-10-08'),
(474, '300482', 'EC01', 'ETTY MUSTAM', 'Jl. Taman Buaran Indah I Blok A 109', '0000024017', 'JAKARTA', '', '', '', '', '', '', '', '', 14, '', '', '', '', '', '', 'V014', '2014-10-08'),
(475, '300483', 'EC01', 'PT MEDIA KOMUNIKA KITA', 'Gedung Graha Pulo Lt. 5', '0000024018', 'JAKARTA', '', '', '', '', '', '', '', '', 14, '', '', '', '', '', '', 'V014', '2014-10-08'),
(476, '300435', 'EC01', 'PT BEKASI EKSPRES MEDIA', 'Ruko Sun City Square Blok A-39', '0000023754', 'JAKARTA', '', '', '', '', '', '', '', '', 14, '', '', '', '', '', '', 'V014', '2014-10-08'),
(477, '300436', 'EC01', 'PT VINOTINDO GRAHASARANA', 'Graha Vivere Mezzanine Floor', '0000023759', 'JAKARTA', '', '', '', '', '', '', '', '', 14, '', '', '', '', '', '', 'V014', '2014-10-08'),
(478, '300437', 'EC01', 'PT MITRA BUANA KOMPUTINDO', 'Gd. Wira Usaha Lt. 8', '0000023760', 'JAKARTA', '12940', '', '', '', '', '', '', '', 14, '', '', '', '', '', '', 'V014', '2014-10-08'),
(479, '300438', 'EC01', 'CV HERSA JAYA MANDIRI', 'Jl. Letjend. S. Parman No.03RT.027', '0000023765', 'JAKARTA', '', '', '', '', '', '', '', '', 14, '', '', '', '', '', '', 'V014', '2014-10-08'),
(480, '300439', 'EC01', 'PT INNOVASI SARANA GRAFINDO', 'Rukan Permata Senayan Blok C-05 RT1', '0000023770', 'JAKARTA', '12210', '', '', '', '', '', '', '', 14, '', '', '', '', '', '', 'V014', '2014-10-08'),
(481, '300440', 'EC01', 'PT KENCANA MEGAH LESTARI', 'Tamini Square, Pinang Ranti', '0000023779', 'MAKASAR', '', '', '', '', '', '', '', '', 14, '', '', '', '', '', '', 'V014', '2014-10-08'),
(482, '300441', 'EC01', 'PT TRIGRIYA HUTAMA', 'Jl. Hanoman Raya Blok C No. 9RT04', '0000023784', 'JAKARTA', '11740', '', '', '', '', '', '', '', 14, '', '', '', '', '', '', 'V014', '2014-10-08'),
(483, '300442', 'EC01', 'CV BUMI FHATA TEKNINDO', 'Bojong Menteng RT002 RW006', '0000023789', 'JAKARTA', '', '', '', '', '', '', '', '', 14, '', '', '', '', '', '', 'V014', '2014-10-08'),
(484, '300443', 'EC01', 'PT FUJI ELEVATOR INDONESIA', 'Jln Asia No. 13/23', '0000023802', 'MEDAN', '20214', '', '', '', '', '', '', '', 14, '', '', '', '', '', '', 'V014', '2014-10-08'),
(485, '300444', 'EC01', 'PT RESTU ANUGRAH WIBAWA', 'Jl. Bypass Ngurah Rai Sanur 494', '0000023815', 'JAKARTA', '', '', '', '', '', '', '', '', 14, '', '', '', '', '', '', 'V014', '2014-10-08'),
(486, '300495', 'EC01', 'CV MAESTRO 90', 'Jl Batu Tulis Raya No. 48 A', '0000024082', 'JAKARTA', '10120', '', '', '', '', '', '', '', 14, '', '', '', '', '', '', 'V014', '2014-10-08'),
(487, '300496', 'EC01', 'SUPERMARKET GENSET', 'Jakarta', '0000024083', 'JAKARTA', '', '', '', '', '', '', '', '', 14, '', '', '', '', '', '', 'V014', '2014-10-08'),
(488, '300497', 'EC01', 'CV CITRA DWIMA TRANSINDO', 'Jl. Pulo Asem No. 5', '0000024096', 'JAKARTA', '', '', '', '', '', '', '', '', 14, '', '', '', '', '', '', 'V014', '2014-10-08'),
(489, '300498', 'EC01', 'BERTHA SURYANTI EFFENDI', 'Jalan Danau Indah Barat Blok A -2 N', '0000024101', 'JAKARTA', '', '', '', '', '', '', '', '', 14, '', '', '', '', '', '', 'V014', '2014-10-08'),
(490, '300499', 'EC01', 'PT VITRYANJAYA BINTANG MUDA', 'Pinang I No. 6 RT.003 RW.001', '0000024102', 'JAKARTA', '', '', '', '', '', '', '', '', 14, '', '', '', '', '', '', 'V014', '2014-10-08'),
(491, '300500', 'EC01', 'CV SURYA PERMATA TEKNIK', 'Komp. Surya Permata Indah Blok A-2', '0000024107', 'JAKARTA', '', '', '', '', '', '', '', '', 14, '', '', '', '', '', '', 'V014', '2014-10-08'),
(492, '300501', 'EC01', 'PT KUSTODIAN SENTRAL EFEK INDONESIA', 'Gedung Bursa Efek Indonesia Tower I', '0000024108', 'JAKARTA', '12190', '', '', '', '', '', '', '', 14, '', '', '', '', '', '', 'V014', '2014-10-08'),
(493, '300502', 'EC01', 'CV FRENTALINDO DE ONE', 'Jl. MT Haryono No. 19 RT060', '0000024113', 'KALIMANTAN TIMUR', '76114', '', '', '', '', '', '03.139.653.4.721.000', '', 14, '', '', '', '', '', '', 'V014', '2014-10-08'),
(494, '300503', 'EC01', 'INDO BHAKTI KARYA', 'KOmplek Pertokoan Roxy Mas E1 Z4', '0000024118', 'JAKARTA', '', '', '', '', '', '', '', '', 14, '', '', '', '', '', '', 'V014', '2014-10-08'),
(495, '300504', 'EC01', 'PT.GAPURA GLASS BRILLIANT', 'JL.WR SUPRATMAN No.154', '0000024119', 'JAKARTA', '', '', '', '', '', '', '', '', 14, '', '', '', '', '', '', 'V014', '2014-10-08'),
(496, '300505', 'EC01', 'PT.GIRI TANGGUH SEJAHTERA', 'JL. RAYA LENTENG AGUNG NO.34 RT 004', '0000024120', 'JAKARTA', '', '', '', '', '', '', '', '', 14, '', '', '', '', '', '', 'V014', '2014-10-08'),
(497, '300506', 'EC01', 'AHMAD SAIPULLAH', 'Kemang Selatan I D No. 19 RT 004', '0000024121', 'JAKARTA', '', '', '', '', '', '', '', '', 14, '', '', '', '', '', '', 'V014', '2014-10-08'),
(498, '300507', 'EC01', 'PT RTI INFOKOM', 'Wisma Antara Lt. 16 ruang 1606', '0000024122', 'JAKARTA', '10110', '', '', '', '', '', '', '', 14, '', '', '', '', '', '', 'V014', '2014-10-08'),
(499, '300508', 'EC01', 'PT WIDYA TAMA LESTARI', 'Jl. Agung Utara XV BLK A-12/18RT001', '0000024123', 'JAKARTA', '', '', '', '', '', '', '', '', 14, '', '', '', '', '', '', 'V014', '2014-10-08'),
(500, '300509', 'EC01', 'PT FRES INDONESIA', 'Jln. Anggrek No. 55', '0000024124', 'JAKARTA', '', '', '', '', '', '', '', '', 14, '', '', '', '', '', '', 'V014', '2014-10-08'),
(501, '300510', 'EC01', 'PT ANGGARA INTERDESIGN', 'Jl. Kembang Raya No. 11 ART 07 RW 0', '0000024125', 'BANDUNG', '', '', '', '', '', '', '', '', 14, '', '', '', '', '', '', 'V014', '2014-10-08'),
(502, '300511', 'EC01', 'CV JAYA PERKASA', 'JAKARTA', '0000024126', 'JAKARTA', '', '', '', '', '', '', '', '', 14, '', '', '', '', '', '', 'V014', '2014-10-08'),
(503, '300512', 'EC01', 'SATU JARI DIGITAL PRINTING', '6-7 Jln. Let. Jend. S. ParmanRT 25', '0000024127', 'BALIKPAPAN', '', '', '', '', '', '', '02.618.136.2.721.000', '', 14, '', '', '', '', '', '', 'V014', '2014-10-08'),
(504, '300513', 'EC01', 'PT.RAJAWALI MEDIATAMA', 'Gedung Menara Kading Indonesia', '0000024128', 'JAKARTA', '', '', '', '', '', '', '', '', 14, '', '', '', '', '', '', 'V014', '2014-10-08'),
(505, '300514', 'EC01', 'PT PLANET ELECTRINDO', 'JL. RAWA GATEL III BLOK S NO.34', '0000024129', 'JAKARTA', '', '', '', '', '', '', '', '', 14, '', '', '', '', '', '', 'V014', '2014-10-08'),
(506, '300515', 'EC01', 'KLIK PRINT STATION', 'Ruko Mutiara Taman Palem Blok C 10', '0000024130', 'JAKARTA', '', '', '', '', '', '', '', '', 14, '', '', '', '', '', '', 'V014', '2014-10-08'),
(507, '300516', 'EC01', 'PT BEJANA KARYA MAJU', 'Permata Harapan Baru Blok S3 No. 2', '0000024131', 'JAKARTA', '', '', '', '', '', '', '', '', 14, '', '', '', '', '', '', 'V014', '2014-10-08'),
(508, '300517', 'EC01', 'PERSEK. KANTOR AKUNTAN PUBLIK DOLI,', 'Jl. Mampamg Prapatan VIII No R. 25B', '0000024132', 'JAKARTA', '', '', '', '', '', '', '', '', 14, '', '', '', '', '', '', 'V014', '2014-10-08'),
(509, '300518', 'EC01', 'PT KOMPAS CYBER MEDIA', 'Jl. Palmerah selatan no.22', '0000024133', 'JAKARTA', '', '', '', '', '', '', '', '', 14, '', '', '', '', '', '', 'V014', '2014-10-08'),
(510, '300519', 'EC01', 'ASTRY NOVITA SUTONO', 'Jl. Delima III No.153 RT 010 RW 003', '0000024134', 'JAKARTA', '', '', '', '', '', '', '', '', 14, '', '', '', '', '', '', 'V014', '2014-10-08'),
(511, '300520', 'EC01', 'YUDI HERMAWAN', 'Jl. Shinta Raya No.64 RT 016 RW 004', '0000024135', 'JAKARTA', '', '', '', '', '', '', '', '', 14, '', '', '', '', '', '', 'V014', '2014-10-08'),
(512, '300521', 'EC01', 'OSKAR MAHENDRA', 'Jl. Lumba lumba II No. 18A RT 001 R', '0000024136', 'JAKARTA', '', '', '', '', '', '', '', '', 14, '', '', '', '', '', '', 'V014', '2014-10-08'),
(513, '300522', 'EC01', 'PT STACOPA RAYA', 'Jln. Daan Mogot KM. 13 No. 70', '0000024137', 'JAKARTA', '', '', '', '', '', '', '', '', 14, '', '', '', '', '', '', 'V014', '2014-10-08'),
(514, '300523', 'EC01', 'PT BERKAT INOVASI MEGAH', 'Jl.danau agung 3 blok e8 no 24', '0000024138', 'JAKARTA', '', '', '', '', '', '', '', '', 14, '', '', '', '', '', '', 'V014', '2014-10-08'),
(515, '300524', 'EC01', 'PT GLOBAL MEDIA UTAMA TEKNOLOGI', 'Jl tubagus angke 99 blok a/1', '0000024139', 'JAKARTA', '', '', '', '', '', '', '', '', 14, '', '', '', '', '', '', 'V014', '2014-10-08'),
(516, '300525', 'EC01', 'PT HL DISPLAY INDONESIA', 'Wisma Korindo Lt. 2', '0000024140', 'JAKARTA', '', '', '', '', '', '', '', '', 14, '', '', '', '', '', '', 'V014', '2014-10-08'),
(517, '300526', 'EC01', 'PT LUMBUNG MAKARYA PARIWARA', 'Jl. Porselen VI No. 21', '0000024141', 'JAKARTA', '13210', '', '', '', '', '', '', '', 14, '', '', '', '', '', '', 'V014', '2014-10-08'),
(518, '300527', 'EC01', 'IVONNE HADISURJO', 'Jl.pejaten barat I no.35', '0000024142', 'JAKARTA', '', '', '', '', '', '', '', '', 14, '', '', '', '', '', '', 'V014', '2014-10-08'),
(519, '300528', 'EC01', 'CV DWITAMA PERKASA', 'Jl Raya Hankam rt 005 rw 009', '0000024143', 'JAKARTA', '17415', '', '', '', '', '', '', '', 14, '', '', '', '', '', '', 'V014', '2014-10-08'),
(520, '300529', 'EC01', 'PT NIKON INDONESIA', 'Wisma 46 Kota BNI LT. 35', '0000024144', 'JAKARTA', '', '', '', '', '', '', '', '', 14, '', '', '', '', '', '', 'V014', '2014-10-08'),
(521, '300530', 'EC01', 'PT MATAHARI PONTIANAK INDAH MALL', 'Jl.Jend Urip S Lt. Basement', '0000024145', 'JAKARTA', '78117', '', '', '', '', '', '', '', 14, '', '', '', '', '', '', 'V014', '2014-10-08'),
(522, '300531', 'EC01', 'PT SUNINDO PRIMALAND', 'Jl. kolonel sutarto no.19', '0000024146', 'SURAKARTA', '', '', '', '', '', '', '', '', 14, '', '', '', '', '', '', 'V014', '2014-10-08'),
(523, '300532', 'EC01', 'PT RAKHELINDO INFODATA', 'Ruko pondok cabe mutiara blok b24', '0000024147', 'JAKARTA', '', '', '', '', '', '', '', '', 14, '', '', '', '', '', '', 'V014', '2014-10-08'),
(524, '300484', 'EC01', 'EICOM INT\'L', 'Jl. Taman Ratu Indah Blok i 5 No. 8', '0000024019', 'JAKARTA', '11520', '', '', '', '', '', '', '', 14, '', '', '', '', '', '', 'V014', '2014-10-08'),
(525, '300485', 'EC01', 'PT LEO ADVERTISING', 'Jl. Kembar Sari No. 3', '0000024028', 'JAKARTA', '', '', '', '', '', '', '', '', 14, '', '', '', '', '', '', 'V014', '2014-10-08'),
(526, '300486', 'EC01', 'CV LINGUIST TRANSLATION SERVICES', 'Jl. Al Mubarok II/50Joglo', '0000024033', 'JAKARTA', '11640', '', '', '', '', '', '', '', 14, '', '', '', '', '', '', 'V014', '2014-10-08'),
(527, '300487', 'EC01', 'ABDUL RAHMAN EFFENDI', 'Jl. Pejaten Raya No. 14RT 006 RW 00', '0000024042', 'JAKARTA', '', '', '', '', '', '', '', '', 14, '', '', '', '', '', '', 'V014', '2014-10-08'),
(528, '300488', 'EC01', 'ERNI TAVIA', 'PGMTA Lt. 1 Blok 8 No. 102', '0000024051', 'JAKARTA', '', '', '', '', '', '', '', '', 14, '', '', '', '', '', '', 'V014', '2014-10-08');
INSERT INTO `api_vendor` (`id`, `supplierCode`, `companyCode`, `name`, `address1`, `address2`, `city`, `postalCode`, `contactPerson`, `phone`, `hp1`, `hp2`, `fax`, `npwp`, `email`, `paymentTerm`, `bankCode`, `bankName`, `bankBranchCode`, `bankBranchName`, `bankAccountNo`, `status`, `paymentTermCd`, `dateCreate`) VALUES
(529, '300489', 'EC01', 'TJEU NIE FUNG', 'Pademangan III Gg. 18 No. 250', '0000024060', 'JAKARTA', '14410', '', '', '', '', '', '', '', 14, '', '', '', '', '', '', 'V014', '2014-10-08'),
(530, '300490', 'EC01', 'CV MAJU JAYA BERSAMA', 'WTC Mangga DUa Lt. LG/B 172', '0000024073', 'JAKARTA', '', '', '', '', '', '', '', '', 14, '', '', '', '', '', '', 'V014', '2014-10-08'),
(531, '300491', 'EC01', 'PT REZEKI KARYA UNGGUL', 'Jl. Melawai Raya No. 22', '0000024074', 'JAKARTA', '12160', '', '', '', '', '', '', '', 14, '', '', '', '', '', '', 'V014', '2014-10-08'),
(532, '300492', 'EC01', 'UD CAHAYA ELEKTRONIK', 'Jl. Komp. BDS Blok O No. 20 RT.103', '0000024075', 'JAKARTA', '', '', '', '', '', '', '', '', 14, '', '', '', '', '', '', 'V014', '2014-10-08'),
(533, '300493', 'EC01', 'PT TAN ENERGY INDONESIA', 'Jln. Dr. Latumenten Kav. 50 Sentra', '0000024080', 'JAKARTA', '11460', '', '', '', '', '', '', '', 14, '', '', '', '', '', '', 'V014', '2014-10-08'),
(534, '300494', 'EC01', 'PT ARSIMEKON TATAGRAHA', 'Jl. Beton No. 85 RT010 RW017', '0000024081', 'JAKARTA', '13210', '', '', '', '', '', '', '', 14, '', '', '', '', '', '', 'V014', '2014-10-08'),
(535, '300545', 'EC01', 'PT SELARAS GAJAH PRATAMA', 'Jl.letda natsir no 58', '0000024160', 'JAKARTA', '', '', '', '', '', '', '', '', 14, '', '', '', '', '', '', 'V014', '2014-10-08'),
(536, '300546', 'EC01', 'CV AUI ADVERTISING', 'Jl.KH. Ahmad Dahlan', '0000024161', 'JAKARTA', '', '', '', '', '', '', '', '', 14, '', '', '', '', '', '', 'V014', '2014-10-08'),
(537, '300547', 'EC01', 'HADIPUTRANTO,HADINOTO & PARTNERS -', 'Gd Bursa Efek Indonesia Tower II', '0000024162', 'JAKARTA', '12190', '', '', '', '', '', '', '', 14, '', '', '', '', '', '', 'V014', '2014-10-08'),
(538, '300548', 'EC01', 'NEW GENS COLLECTION', 'Jl.Pabuaran Raya no 88', '0000024163', 'JAKARTA', '', '', '', '', '', '', '', '', 14, '', '', '', '', '', '', 'V014', '2014-10-08'),
(539, '300549', 'EC01', 'PD SINAR KOTA', 'Jl. Tanjungpura no 143-145', '0000024164', 'PONTIANAK', '', '', '', '', '', '', '', '', 14, '', '', '', '', '', '', 'V014', '2014-10-08'),
(540, '300550', 'EC01', 'TOKO SEMANGAT STATIONERY', 'Jl. Tanjungpura no 104', '0000024165', 'PONTIANAK', '', '', '', '', '', '', '', '', 14, '', '', '', '', '', '', 'V014', '2014-10-08'),
(541, '300551', 'EC01', 'PT OPTIMA TOUR & TRAVEL', 'MT Haryono square city walk Blok B', '0000024170', 'JAKARTA', '13330', '', '', '', '', '', '', '', 14, '', '', '', '', '', '', 'V014', '2014-10-08'),
(542, '300552', 'EC01', 'CV MITRA KARYA GEMILANG', 'Jl. Ters pasirkoja no 261', '0000024175', 'BANDUNG', '', '', '', '', '', '', '', '', 14, '', '', '', '', '', '', 'V014', '2014-10-08'),
(543, '300553', 'EC01', 'PT SOLTIUS INDONESIA', 'APL tower 42th floor suite 6', '0000024176', 'JAKARTA', '11470', '', '', '', '', '', '', '', 14, '', '', '', '', '', '', 'V014', '2014-10-08'),
(544, '300554', 'EC01', 'PT PROSHOP', 'Jl.Teuku umar', '0000024181', 'PONTIANAK', '', '', '', '', '', '', '', '', 14, '', '', '', '', '', '', 'V014', '2014-10-08'),
(545, '300555', 'EC01', 'DEPOT 88', 'Jl.kalibata utara 2 no 87', '0000024186', 'JAKARTA', '', '', '', '', '', '', '', '', 14, '', '', '', '', '', '', 'V014', '2014-10-08'),
(546, '300556', 'EC01', 'CV SRI KRESNO', 'Jl.hayam wuruk no 5a', '0000024191', 'JAKARTA', '', '', '', '', '', '', '', '', 14, '', '', '', '', '', '', 'V014', '2014-10-08'),
(547, '300557', 'EC01', 'PT TRANS MANAGEMENT INDONESIA', 'Jl.Taman margasatwa no 37', '0000024192', 'JAKARTA', '12540', '', '', '', '', '', '', '', 14, '', '', '', '', '', '', 'V014', '2014-10-08'),
(548, '300558', 'EC01', 'PT DATA CENTER INTEGRASI', 'Jl.citarum no 9', '0000024197', 'JAKARTA', '10150', '', '', '', '', '', '', '', 14, '', '', '', '', '', '', 'V014', '2014-10-08'),
(549, '300559', 'EC01', 'PT KARYATUMBUH BERSAMA INDONESIA', 'Cilandak mall', '0000024198', 'JAKARTA', '12560', '', '', '', '', '', '', '', 14, '', '', '', '', '', '', 'V014', '2014-10-08'),
(550, '300560', 'EC01', 'PT TELEKOMUNIKASI INDONESIA TBK', 'Jl.Japati no 1', '0000024207', 'BANDUNG', '40133', '', '', '', '', '', '', '', 14, '', '', '', '', '', '', 'V014', '2014-10-08'),
(551, '300561', 'EC01', 'ELECTRA (S) PTE LTD', '15A DUXTON HILL LEVEL 2', '0000024212', 'SINGAPORE', '89598', '', '', '', '', '', '', '', 14, '', '', '', '', '', '', 'V014', '2014-10-08'),
(552, '300562', 'EC01', 'PT DARMALI NIAGA', 'Jl.HM Suwignyo no 6a/6b', '0000024217', 'PONTIANAK', '', '', '', '', '', '', '', '', 14, '', '', '', '', '', '', 'V014', '2014-10-08'),
(553, '300563', 'EC01', 'GRANT FERGUSON', 'Jakarta', '0000024218', 'JAKARTA', '', '', '', '', '', '', '', '', 14, '', '', '', '', '', '', 'V014', '2014-10-08'),
(554, '300564', 'EC01', 'HERMIN FISILO', 'JAKARTA', '0000024223', 'JAKARTA', '', '', '', '', '', '', '', '', 14, '', '', '', '', '', '', 'V014', '2014-10-08'),
(555, '300565', 'EC01', 'PT ACE HARDWARE INDONESIA TBK', 'Jl.puri kencana no 1 rt 005/002', '0000024228', 'JAKARTA', '11610', '', '', '', '', '', '', '', 14, '', '', '', '', '', '', 'V014', '2014-10-08'),
(556, '300566', 'EC01', 'DENI THANUR, SE., S.H., M.Kn', 'Wisma Bumiputera Lantai M Suite 20', '0000024237', 'JAKARTA', '', '', '', '', '', '', '', '', 14, '', '', '', '', '', '', 'V014', '2014-10-08'),
(557, '300567', 'EC01', 'RUDI SUMANTO', 'Jakarta', '0000024242', 'JAKARTA', '', '', '', '', '', '', '', '', 14, '', '', '', '', '', '', 'V014', '2014-10-08'),
(558, '300568', 'EC01', 'PT.GRIYAPESONA MENTARI (jgn dipake)', 'APL TOWER CENTRAL PARK LT 7', '0000024247', 'JAKARTA', '11470', '', '', '', '', '', '', '', 14, '', '', '', '', '', '', 'V014', '2014-10-08'),
(559, '300569', 'EC01', 'JAVAMEDIA COMPUTER BALI', 'Jl.Diponegoro no 136', '0000024252', 'BALI', '', '', '', '', '', '', '', '', 14, '', '', '', '', '', '', 'V014', '2014-10-08'),
(560, '300570', 'EC01', 'PT SUN STAR MOTOR', 'Jl. Kol sutarto no 19', '0000024257', 'SURAKARTA', '', '', '', '', '', '', '', '', 14, '', '', '', '', '', '', 'V014', '2014-10-08'),
(561, '300571', 'EC01', 'PT DUTA PRIMA  KALBAR', 'Jl. dr.Sutomo no 47', '0000024258', 'JAKARTA', '', '', '', '', '', '', '', '', 14, '', '', '', '', '', '', 'V014', '2014-10-08'),
(562, '300572', 'EC01', 'PT CAHAYA ALAM RAYA', 'Wisma argo manunggal 18th FI', '0000024259', 'JAKARTA', '12930', '', '', '', '', '', '', '', 14, '', '', '', '', '', '', 'V014', '2014-10-08'),
(563, '300573', 'EC01', 'PT SUKSES ANUGRAH NIAGATAMA', 'pondok indah office tower 3 Suite 1', '0000024264', 'JAKARTA', '', '', '', '', '', '', '', '', 14, '', '', '', '', '', '', 'V014', '2014-10-08'),
(564, '300574', 'EC01', 'PT MITRA SUKSES SOLUSINDO', 'Gd. mayapada tower lt 11', '0000024269', 'JAKARTA', '', '', '', '', '', '', '', '', 14, '', '', '', '', '', '', 'V014', '2014-10-08'),
(565, '300575', 'EC01', 'PT ABIGIO ENT', 'Jl.Mampang prapatan raya 106', '0000024270', 'JAKARTA', '', '', '', '', '', '', '', '', 14, '', '', '', '', '', '', 'V014', '2014-10-08'),
(566, '300576', 'EC01', 'CV TUNGGAL JAYA RAYA', 'JL. JEND A. YANI NO.07 RT.55', '0000024275', 'JAKARTA', '', '', '', '', '', '', '', '', 14, '', '', '', '', '', '', 'V014', '2014-10-08'),
(567, '300577', 'EC01', 'EKSAN ARIYADI', 'Jebres tengah rt 02 rw 24', '0000024280', 'SURAKARTA', '', '', '', '', '', '', '', '', 14, '', '', '', '', '', '', 'V014', '2014-10-08'),
(568, '300578', 'EC01', 'PERMADANI KHATULISTIWA NUSANTARA', 'Four Seasons Hotel Jakarta', '0000024281', 'JAKARTA', '12920', '', '', '', '', '', '', '', 14, '', '', '', '', '', '', 'V014', '2014-10-08'),
(569, '300579', 'EC01', 'PT XEPIA PRIMA', 'Gedung Thamrin City Lt 3A blok H1', '0000024282', 'JAKARTA', '', '', '', '', '', '', '', '', 14, '', '', '', '', '', '', 'V014', '2014-10-08'),
(570, '300580', 'EC01', 'YENDIAWAN TOYIP', 'JL.JEND.SUPRAPTO NO.45 TK.05', '0000024283', 'JAKARTA', '', '', '', '', '', '', '', '', 14, '', '', '', '', '', '', 'V014', '2014-10-08'),
(571, '300581', 'EC01', 'PT DWI PRIMA SINERGI', 'Jl.Nusantara raya no 29-31', '0000024296', 'JAKARTA', '', '', '', '', '', '', '', '', 14, '', '', '', '', '', '', 'V014', '2014-10-08'),
(572, '300533', 'EC01', 'EDDYANTO HADISURJO', 'JAKARTA', '0000024148', 'JAKARTA', '', '', '', '', '', '', '', '', 14, '', '', '', '', '', '', 'V014', '2014-10-08'),
(573, '300534', 'EC01', 'SPEED PACKAGE SOLUTION', 'Jakarta', '0000024149', 'JAKARTA', '', '', '', '', '', '', '', '', 14, '', '', '', '', '', '', 'V014', '2014-10-08'),
(574, '300535', 'EC01', 'PT PASAT GURKHA INDONESIA', 'Jl.KH Hasyim ashari no 18B', '0000024150', 'JAKARTA', '', '', '', '', '', '', '', '', 14, '', '', '', '', '', '', 'V014', '2014-10-08'),
(575, '300536', 'EC01', 'CV NABORI PRATAMA', 'Perum graha indah blok Q no 21', '0000024151', 'JAKARTA', '', '', '', '', '', '', '', '', 14, '', '', '', '', '', '', 'V014', '2014-10-08'),
(576, '300537', 'EC01', 'PT MITRA INTI PRIMA', 'Jl.Pinang raya I/6 rt 003 rw 001', '0000024152', 'JAKARTA', '', '', '', '', '', '', '', '', 14, '', '', '', '', '', '', 'V014', '2014-10-08'),
(577, '300538', 'EC01', 'PT FICOMINDO BUANA REGISTRAR', 'Mayapada tower lt 10 suite 02B', '0000024153', 'JAKARTA', '', '', '', '', '', '', '', '', 14, '', '', '', '', '', '', 'V014', '2014-10-08'),
(578, '300539', 'EC01', 'CV BUANA PROMOSI', 'Komplek permata kota blok e-05', '0000024154', 'JAKARTA', '', '', '', '', '', '', '', '', 14, '', '', '', '', '', '', 'V014', '2014-10-08'),
(579, '300540', 'EC01', 'BERKAT MULIA WISATA TOUR & TRAVEL', 'Jl. A.M Sangaji no 38', '0000024155', 'JAKARTA', '10130', '', '', '', '', '', '', '', 14, '', '', '', '', '', '', 'V014', '2014-10-08'),
(580, '300541', 'EC01', 'FAJAR AGUNG INDOCEMERLANG', 'Jl.Raden intan no 61', '0000024156', 'LAMPUNG', '', '', '', '', '', '', '', '', 14, '', '', '', '', '', '', 'V014', '2014-10-08'),
(581, '300542', 'EC01', 'PT ELSIWA RAKATAMA', 'Jl. Asia Baru blok B2 no 44', '0000024157', 'JAKARTA', '11510', '', '', '', '', '', '', '', 14, '', '', '', '', '', '', 'V014', '2014-10-08'),
(582, '300543', 'EC01', 'RUDY SUDJOKO', 'No. 31 JL. U KAMPUNG SLIPI', '0000024158', 'JAKARTA BARAT', '11410', '', '', '', '', '', '05.936.376.2-031.000', '', 14, '', '', '', '', '', '', 'V014', '2014-10-08'),
(583, '300544', 'EC01', 'FINALIS INTI TEKNIK', 'Jl.Kiaracondong no 133', '0000024159', 'BANDUNG', '', '', '', '', '', '', '', '', 14, '', '', '', '', '', '', 'V014', '2014-10-08'),
(584, '300595', 'EC01', 'RAMSES JULIUS TAMBUNAN', 'PONDOK BENDA INDAH BLOK I-1 NO. 03', '0000024338', 'JAKARTA', '', '', '', '', '', '', '', '', 14, '', '', '', '', '', '', 'V014', '2014-10-08'),
(585, '300596', 'EC01', 'UD MEUBEL MODERN', 'Jl jend achmad yani no 179', '0000024339', 'BALIKPAPAN', '', '', '', '', '', '', '', '', 14, '', '', '', '', '', '', 'V014', '2014-10-08'),
(586, '300597', 'EC01', 'PT.BARA INSAN GANESA', 'JL.ASEM II NO.78', '0000024344', 'JAKARTA', '', '', '', '', '', '', '', '', 14, '', '', '', '', '', '', 'V014', '2014-10-08'),
(587, '300598', 'EC01', 'CV DUA MITRA PERKASA', 'Taman sari bukit mutiara', '0000024353', 'JAKARTA', '', '', '', '', '', '', '', '', 14, '', '', '', '', '', '', 'V014', '2014-10-08'),
(588, '300599', 'EC01', 'PT GEMILANG MANUNGGAL', 'Jl.Gambir anom 1 blok G no 6', '0000024354', 'JAKARTA', '', '', '', '', '', '', '', '', 14, '', '', '', '', '', '', 'V014', '2014-10-08'),
(589, '300600', 'EC01', 'ROYAL NEON', 'Jl. Balikpapan raya no.22', '0000024359', 'JAKARTA', '', '', '', '', '', '', '06.669.557.8-029.000', '', 14, '', '', '', '', '', '', 'V014', '2014-10-08'),
(590, '300601', 'EC01', 'PT ANUGRAH SAHABAT JAYA', 'Jl. Gandul raya no.16', '0000024360', 'DEPOK', '', '', '', '', '', '', '', '', 14, '', '', '', '', '', '', 'V014', '2014-10-08'),
(591, '300602', 'EC01', 'ALLEN & OVERY LLP', 'Jakarta', '0000024365', 'JAKARTA', '', '', '', '', '', '', '', '', 14, '', '', '', '', '', '', 'V014', '2014-10-08'),
(592, '300603', 'EC01', 'PT UNITED TRANSWORLD TRADING', 'Jl.Lodan raya', '0000024366', 'JAKARTA', '', '', '', '', '', '', '', '', 14, '', '', '', '', '', '', 'V014', '2014-10-08'),
(593, '300604', 'EC01', 'PT MITRA ANDA SUKSES BERSAMA', 'Jl.MT Haryono no 61-63', '0000024367', 'JAKARTA', '', '', '', '', '', '', '', '', 14, '', '', '', '', '', '', 'V014', '2014-10-08'),
(594, '300605', 'EC01', 'PT SENSCA INDONESIA', 'Jl.Radio dalam raya no 9e Rt 8 Rw 1', '0000024368', 'JAKARTA', '', '', '', '', '', '', '', '', 14, '', '', '', '', '', '', 'V014', '2014-10-08'),
(595, '300606', 'EC01', 'PT HERMES REALTY INDONESIA', 'Jl Wolter Mongonsidi no 45', '0000024377', 'SUMATERA UTARA', '', '', '', '', '', '', '', '', 14, '', '', '', '', '', '', 'V014', '2014-10-08'),
(596, '300607', 'EC01', 'PT DWINDO BERLIAN SAMJAYA', 'Jl.Radin inten II', '0000024378', 'JAKARTA', '', '', '', '', '', '', '', '', 14, '', '', '', '', '', '', 'V014', '2014-10-08'),
(597, '300608', 'EC01', 'PT RETAILINDO TECHNOLOGY', 'Jl.Balikpapan raya no 23', '0000024383', 'JAKARTA', '', '', '', '', '', '', '', '', 14, '', '', '', '', '', '', 'V014', '2014-10-08'),
(598, '300609', 'EC01', 'UNION JAYA', 'Jl.Pintu kecil no 44 (pasar pagi)', '0000024384', 'JAKARTA', '', '', '', '', '', '', '', '', 14, '', '', '', '', '', '', 'V014', '2014-10-08'),
(599, '300610', 'EC01', 'JULI MANAGEMENT', 'Jakarta', '0000024389', 'JAKARTA', '', '', '', '', '', '', '', '', 14, '', '', '', '', '', '', 'V014', '2014-10-08'),
(600, '300611', 'EC01', 'MILLIONAIRES CLUB', 'Jl.Cakalele f/23', '0000024394', 'JAKARTA', '', '', '', '', '', '', '', '', 14, '', '', '', '', '', '', 'V014', '2014-10-08'),
(601, '300612', 'EC01', 'RIZA TAILOR', 'Jl.Kemang selatan i no 4c', '0000024403', 'JAKARTA', '', '', '', '', '', '', '', '', 14, '', '', '', '', '', '', 'V014', '2014-10-08'),
(602, '300613', 'EC01', 'PT WAHANA SEMESTA CIANJUR', 'Jakarta', '0000024404', 'JAKARTA', '', '', '', '', '', '', '', '', 14, '', '', '', '', '', '', 'V014', '2014-10-08'),
(603, '300614', 'EC01', 'CITRATELINDO ABADI', 'Jl.Tanah sereal X no 11', '0000024405', 'JAKARTA', '11210', '', '', '', '', '', '', '', 14, '', '', '', '', '', '', 'V014', '2014-10-08'),
(604, '300615', 'EC01', 'BUKUPEN-A', 'Jl. Ronggowarsito no.18 asolo', '0000024406', 'JAKARTA', '', '', '', '', '', '', '', '', 14, '', '', '', '', '', '', 'V014', '2014-10-08'),
(605, '300616', 'EC01', 'GORILLA SOUND ENFORCEMENT', 'Jl.Swadaya no 36 RT 001 RW 014', '0000024411', 'JAKARTA', '', '', '', '', '', '', '', '', 14, '', '', '', '', '', '', 'V014', '2014-10-08'),
(606, '300617', 'EC01', 'ARI PRAMUNDITO', 'Jakarta', '0000024412', 'JAKARTA', '', '', '', '', '', '', '', '', 14, '', '', '', '', '', '', 'V014', '2014-10-08'),
(607, '300618', 'EC01', 'CV AGGELION', 'Jl. RE. Martadinata Rt.012 No.10', '0000024413', 'JAKARTA', '', '', '', '', '', '', '', '', 14, '', '', '', '', '', '', 'V014', '2014-10-08'),
(608, '300619', 'EC01', 'ULI HERDINANSYAH', 'Jl. Anta Reja no 11 Rt 004/006', '0000024418', 'JAKARTA', '', '', '', '', '', '', '', '', 14, '', '', '', '', '', '', 'V014', '2014-10-08'),
(609, '300620', 'EC01', 'KENCANA INDOLABEL', 'Jl. Cipta Niaga No.6 Amplas/', '0000024423', 'JAKARTA', '', '', '', '', '', '', '', '', 14, '', '', '', '', '', '', 'V014', '2014-10-08'),
(610, '300621', 'EC01', 'IRHASH STUDIO', 'PPU Jl. Mawar A no.54', '0000024428', 'JAKARTA', '', '', '', '', '', '', '', '', 14, '', '', '', '', '', '', 'V014', '2014-10-08'),
(611, '300622', 'EC01', 'PT LE MOESIEK REVOLE', 'Jakarta', '0000024433', 'JAKARTA', '', '', '', '', '', '', '', '', 14, '', '', '', '', '', '', 'V014', '2014-10-08'),
(612, '300623', 'EC01', 'KREASI ICESO', 'Jl.Krt Radjiman Widyodiningrat', '0000024434', 'JAKARTA', '13930', '', '', '', '', '', '', '', 14, '', '', '', '', '', '', 'V014', '2014-10-08'),
(613, '300624', 'EC01', 'BAJA KENCANA', 'Jakarta', '0000024435', 'JAKARTA', '', '', '', '', '', '', '', '', 14, '', '', '', '', '', '', 'V014', '2014-10-08'),
(614, '300625', 'EC01', 'SARLINA WAHYUNI', 'Jakarta', '0000024440', 'JAKARTA', '', '', '', '', '', '', '', '', 14, '', '', '', '', '', '', 'V014', '2014-10-08'),
(615, '300626', 'EC01', 'PT PURNAMA ASRI LESTARI', 'Jalan Pangeran Ratu', '0000024441', 'JAKARTA', '', '', '', '', '', '', '', '', 14, '', '', '', '', '', '', 'V014', '2014-10-08'),
(616, '300627', 'EC01', 'ISTANA KADO BADUT', 'Jakarta', '0000024446', 'JAKARTA', '', '', '', '', '', '', '', '', 14, '', '', '', '', '', '', 'V014', '2014-10-08'),
(617, '300628', 'EC01', 'MAS EDY HALIM', 'Jakarta', '0000024451', 'JAKARTA', '', '', '', '', '', '', '', '', 14, '', '', '', '', '', '', 'V014', '2014-10-08'),
(618, '300629', 'EC01', 'MARIO NOVHA SUSANTO', 'Jakarta', '0000024452', 'JAKARTA', '', '', '', '', '', '', '', '', 14, '', '', '', '', '', '', 'V014', '2014-10-08'),
(619, '300630', 'EC01', 'NASARI TOUR & TRAVEL', 'Jl. Gading bukit indah blok A-3', '0000024453', 'JAKARTA', '14240', '', '', '', '', '', '', '', 14, '', '', '', '', '', '', 'V014', '2014-10-08'),
(620, '300582', 'EC01', 'PT LAMINATECH KREASI SARANA', 'Jl.Letjen S Parman no 6 rt 001', '0000024301', 'JAKARTA', '', '', '', '', '', '', '', '', 14, '', '', '', '', '', '', 'V014', '2014-10-08'),
(621, '300583', 'EC01', 'PT PUSAT BISNIS PONOROGO', 'Gd.Mayapada tower lt 20 no.3', '0000024306', 'JAKARTA', '', '', '', '', '', '', '', '', 14, '', '', '', '', '', '', 'V014', '2014-10-08'),
(622, '300584', 'EC01', 'PT IMPIAN BENGKULU INDAH', 'Jl.Putri Gading Cempaka no 4', '0000024307', 'JAKARTA', '', '', '', '', '', '', '', '', 14, '', '', '', '', '', '', 'V014', '2014-10-08'),
(623, '300585', 'EC01', 'PL.GINTING & REKSODIPUTRO', 'Jl. jend Sudirman kav 52-53', '0000024312', 'JAKARTA', '12190', '', '', '', '', '', '', '', 14, '', '', '', '', '', '', 'V014', '2014-10-08'),
(624, '300586', 'EC01', 'PT KREASI MUSTIKA', 'Jl.Industri km 12,5', '0000024313', 'JAKARTA', '', '', '', '', '', '', '', '', 14, '', '', '', '', '', '', 'V014', '2014-10-08'),
(625, '300587', 'EC01', 'CV NAIRA ABADI', 'Jl.letnan jendral soetoyo no 32', '0000024318', 'JAKARTA', '', '', '', '', '', '', '', '', 14, '', '', '', '', '', '', 'V014', '2014-10-08'),
(626, '300588', 'EC01', 'CV MUNAJAZ CORP', 'Jl.Alamanda raya 1 no 90B', '0000024319', 'BANDUNG', '', '', '', '', '', '', '', '', 14, '', '', '', '', '', '', 'V014', '2014-10-08'),
(627, '300589', 'EC01', 'CV PRIMA JASA GLOBAL', 'Jakarta', '0000024320', 'JAKARTA', '', '', '', '', '', '', '', '', 14, '', '', '', '', '', '', 'V014', '2014-10-08'),
(628, '300590', 'EC01', 'INDOCOOL LAMPUNG', 'Jakarta', '0000024321', 'JAKARTA', '', '', '', '', '', '', '', '', 14, '', '', '', '', '', '', 'V014', '2014-10-08'),
(629, '300591', 'EC01', 'CV. ANUGRAH AVIDHIA', 'JL. JATI NO. 28 ATANJUNG RAYABANDAR', '0000024326', 'JAKARTA', '35128', '', '', '', '', '', '', '', 14, '', '', '', '', '', '', 'V014', '2014-10-08'),
(630, '300592', 'EC01', 'PT. KAPUAS MEDIA GRAFIKA', 'JL. SEI RAYA DALAM NO. 24RT/RW 006', '0000024334', 'JAKARTA', '', '', '', '', '', '', '', '', 14, '', '', '', '', '', '', 'V014', '2014-10-08'),
(631, '300593', 'EC01', 'PT. WAHANA SEMESTA CIKARANG', 'RUKO PASAR CENTRAL BLOK ESC NO. 10', '0000024336', 'JAKARTA', '', '', '', '', '', '', '', '', 14, '', '', '', '', '', '', 'V014', '2014-10-08'),
(632, '300594', 'EC01', 'RANDY INDRA PRADHANA', 'TAMAN KEBUN JERUK Q2 NO. 12A RT 006', '0000024337', 'JAKARTA', '11630', '', '', '', '', '', '', '', 14, '', '', '', '', '', '', 'V014', '2014-10-08'),
(633, '300645', 'EC01', 'PT OPTIMA INTERNUSA SEJAHTERA', 'MT Haryono square', '0000024492', 'JAKARTA', '', '', '', '', '', '', '', '', 14, '', '', '', '', '', '', 'V014', '2014-10-08'),
(634, '300646', 'EC01', 'PT CIPTA KARYA KREATIF', 'Jl. Kh.hasyim ashari No.48 b', '0000024493', 'JAKARTA', '', '', '', '', '', '', '', '', 14, '', '', '', '', '', '', 'V014', '2014-10-08'),
(635, '300647', 'EC01', 'CV AFDHOL JAYA BERSAMA', 'Ruko mutiara marina kav 2D', '0000024502', 'JAKARTA', '', '', '', '', '', '', '', '', 14, '', '', '', '', '', '', 'V014', '2014-10-08'),
(636, '300648', 'EC01', 'PT INLINGUA INTERNATIONAL INDONESIA', 'Grand Rukan puri niaga', '0000024503', 'JAKARTA', '11610', '', '', '', '', '', '', '', 14, '', '', '', '', '', '', 'V014', '2014-10-08'),
(637, '300649', 'EC01', 'CAROLINE NATALIA', 'Jakarta', '0000024504', 'JAKARTA', '', '', '', '', '', '', '', '', 14, '', '', '', '', '', '', 'V014', '2014-10-08'),
(638, '300650', 'EC01', 'CESA', 'Jakarta', '0000024505', 'JAKARTA', '', '', '', '', '', '', '', '', 14, '', '', '', '', '', '', 'V014', '2014-10-08'),
(639, '300651', 'EC01', 'CHEER PRODUCTION', 'Jakarta', '0000024510', 'JAKARTA', '', '', '', '', '', '', '', '', 14, '', '', '', '', '', '', 'V014', '2014-10-08'),
(640, '300652', 'EC01', 'CV TOM WORKSHOP', 'Sangkuriang no 23 rt 03 rw 05', '0000024511', 'JAKARTA', '', '', '', '', '', '', '', '', 14, '', '', '', '', '', '', 'V014', '2014-10-08'),
(641, '300653', 'EC01', 'PT PANDEGA CITRA KELOLA', 'Jl.Jend sudirman no 1 Rt 005', '0000024516', 'BALIKPAPAN', '', '', '', '', '', '', '', '', 14, '', '', '', '', '', '', 'V014', '2014-10-08'),
(642, '300654', 'EC01', 'PT ANTAREJA PRIMA ANTARAN', 'Jl. Ciputat Raya No.99', '0000024517', 'JAKARTA SELATAN', '', '', '', '', '', '', '01.909.630.4-062.000', '', 14, '', '', '', '', '', '', 'V014', '2014-10-08'),
(643, '300655', 'EC01', 'PT GARUDA NUSANTARA KENCANA', 'Centerflik-Boutique office & virtua', '0000024522', 'JAKARTA', '10210', '', '', '', '', '', '', '', 14, '', '', '', '', '', '', 'V014', '2014-10-08'),
(644, '300656', 'EC01', 'PT GAJAHMADA PRATAMA TOURS & TRAVEL', 'Pusat niaga Roxy mas blok D5 no 16', '0000024527', 'JAKARTA', '10150', '', '', '', '', '', '', '', 14, '', '', '', '', '', '', 'V014', '2014-10-08'),
(645, '300657', 'EC01', 'TOKO CENTURY FURNITURE', 'Jl.DI Panjaitan (lepo-lepo)', '0000024528', 'KENDARI', '', '', '', '', '', '', '', '', 14, '', '', '', '', '', '', 'V014', '2014-10-08'),
(646, '300658', 'EC01', 'CV INDO WARNA', 'Muara karang blok F2.B no 77 RT 005', '0000024529', 'JAKARTA', '', '', '', '', '', '', '', '', 14, '', '', '', '', '', '', 'V014', '2014-10-08'),
(647, '300659', 'EC01', 'PT KUALITAS TEKHNOLOGI ASIA', 'Ruko Puri Pritania Blok T-7', '0000024534', 'JAKARTA', '', '', '', '', '', '', '', '', 14, '', '', '', '', '', '', 'V014', '2014-10-08'),
(648, '300660', 'EC01', 'TIRTA WISATA', 'Jl.Kartini XIII no 39', '0000024535', 'JAKARTA', '', '', '', '', '', '', '', '', 14, '', '', '', '', '', '', 'V014', '2014-10-08'),
(649, '300661', 'EC01', 'ALEXANDER TEKNIK', 'Jl.Tirta Buana III F No 354', '0000024536', 'BEKASI', '', '', '', '', '', '', '', '', 14, '', '', '', '', '', '', 'V014', '2014-10-08'),
(650, '300662', 'EC01', 'PT KELOLA SENTRA NIAGA', 'Jl.Pintu utama 1 TMII RT 001 RW 002', '0000024537', 'JAKARTA', '', '', '', '', '', '', '', '', 14, '', '', '', '', '', '', 'V014', '2014-10-08'),
(651, '300663', 'EC01', 'PT WAHANA SEMESTA PEKALONGAN', 'Jl. Binagriya raya B1 No.2', '0000024542', 'JAKARTA', '', '', '', '', '', '', '', '', 14, '', '', '', '', '', '', 'V014', '2014-10-08'),
(652, '300664', 'EC01', 'GARDENA GRAHA UTAMA', 'Jl.KH Wahid hasyim no 8', '0000024543', 'PEKALONGAN', '', '', '', '', '', '', '', '', 14, '', '', '', '', '', '', 'V014', '2014-10-08'),
(653, '300665', 'EC01', 'JAYA NETWORK SOLUTION', 'Harco Mangga Dua', '0000024548', 'JAKARTA', '', '', '', '', '', '', '', '', 14, '', '', '', '', '', '', 'V014', '2014-10-08'),
(654, '300666', 'EC01', 'PT FURNITUR BATAM BINA PERKASA', 'Jl. Raden Fatah No. 4-6', '0000024549', 'BATAM', '', '', '', '', '', '', '', '', 14, '', '', '', '', '', '', 'V014', '2014-10-08'),
(655, '300667', 'EC01', 'PT JASAPIRANTI LINTASNUSA', 'Jl.Ampera Raya,Kancil no 40', '0000024550', 'JAKARTA', '', '', '', '', '', '', '', '', 14, '', '', '', '', '', '', 'V014', '2014-10-08'),
(656, '300668', 'EC01', 'PT MASA KINI MANDIRI', 'Jl.Soekarno Hatta no 108', '0000024555', 'BANDAR LAMPUNG', '', '', '', '', '', '', '', '', 14, '', '', '', '', '', '', 'V014', '2014-10-08'),
(657, '300669', 'EC01', 'ASTRI PUJI LESTARI, S.OS', 'Jakarta', '0000024556', 'JAKARTA', '', '', '', '', '', '', '', '', 14, '', '', '', '', '', '', 'V014', '2014-10-08'),
(658, '300670', 'EC01', 'PT HARAPAN INDOKOMUNIKA', 'Jl. Tentara Pelajar No.45 Rt.06', '0000024561', 'JAKARTA SELATAN', '', '', '', '', '', '', '31.713.955.8-013.000', '', 14, '', '', '', '', '', '', 'V014', '2014-10-08'),
(659, '300671', 'EC01', 'PD WIRA SWAKARSA MEDAN', 'Jakarta', '0000024562', 'JAKARTA', '', '', '', '', '', '', '', '', 14, '', '', '', '', '', '', 'V014', '2014-10-08'),
(660, '300672', 'EC01', 'CV JAYA STAR NINE', 'Ds Kranggan Rt 04 Rw 02', '0000024563', 'JAKARTA', '', '', '', '', '', '', '', '', 14, '', '', '', '', '', '', 'V014', '2014-10-08'),
(661, '300673', 'EC01', 'J & C COMPUTER', 'Harco mangga dua blok B1 no 5', '0000024564', 'JAKARTA', '', '', '', '', '', '', '', '', 14, '', '', '', '', '', '', 'V014', '2014-10-08'),
(662, '300674', 'EC01', 'PT NIAGA ETERNA', 'Komplek Ruko Suri Graha', '0000024569', 'JAKARTA', '', '', '', '', '', '', '', '', 14, '', '', '', '', '', '', 'V014', '2014-10-08'),
(663, '300675', 'EC01', 'PT HENSINDO TAMA', 'Jl.Gajahmada no 22', '0000024574', 'PEKALONGAN', '51119', '', '', '', '', '', '02.878.054.2-502.000', '', 14, '', '', '', '', '', '', 'V014', '2014-10-08'),
(664, '300676', 'EC01', 'CV KHARISMA ABADI', 'Jl.Sam Ratulangi gang mawar II no 1', '0000024575', 'JAKARTA', '', '', '', '', '', '', '', '', 14, '', '', '', '', '', '', 'V014', '2014-10-08'),
(665, '300677', 'EC01', 'CV FADHIL', '99 Jl. Kapten Piere Tendean', '0000024576', 'SULAWESI TENGGARA', '', '', '', '', '', '', '03.021.603.0.811.000', '', 14, '', '', '', '', '', '', 'V014', '2014-10-08'),
(666, '300678', 'EC01', 'PT METROGEMA MEDIA NUSANTARA', 'Jl. Palmerah Barat No.33-37', '0000024581', 'JAKARTA', '', '', '', '', '', '', '', '', 14, '', '', '', '', '', '', 'V014', '2014-10-08'),
(667, '300679', 'EC01', 'PENGELOLA GREEN LAKE SUNTER', 'Jakarta', '0000024594', 'JAKARTA', '', '', '', '', '', '', '', '', 14, '', '', '', '', '', '', 'V014', '2014-10-08'),
(668, '300631', 'EC01', 'EDY DJUNAIDY', 'Jakarta', '0000024454', 'JAKARTA', '', '', '', '', '', '', '', '', 14, '', '', '', '', '', '', 'V014', '2014-10-08'),
(669, '300632', 'EC01', 'PT BUANA SURYA MAKMUR', 'Jakarta', '0000024455', 'JAKARTA', '', '', '', '', '', '', '', '', 14, '', '', '', '', '', '', 'V014', '2014-10-08'),
(670, '300633', 'EC01', 'PARMIN', 'Jl. Rawa bebek Rt.15/Rw.13 No.1', '0000024460', 'JAKARTA', '', '', '', '', '', '', '', '', 14, '', '', '', '', '', '', 'V014', '2014-10-08'),
(671, '300634', 'EC01', 'PT BAGUS TEKNIK', 'Ruko grand mall bekasi blok D22', '0000024461', 'JAKARTA', '17143', '', '', '', '', '', '', '', 14, '', '', '', '', '', '', 'V014', '2014-10-08'),
(672, '300635', 'EC01', 'PT TEGUH METTA INTERNUSA', 'JL.TEUKU UMAR', '0000024466', 'JAKARTA', '', '', '', '', '', '', '', '', 14, '', '', '', '', '', '', 'V014', '2014-10-08'),
(673, '300636', 'EC01', 'CV.VINSOFT', 'Jl. Bahagia No.36', '0000024467', 'MEDAN', '', '', '', '', '', '', '', '', 14, '', '', '', '', '', '', 'V014', '2014-10-08'),
(674, '300637', 'EC01', 'TANDI AGUS PUTRA', 'Jakarta', '0000024468', 'JAKARTA', '', '', '', '', '', '', '', '', 14, '', '', '', '', '', '', 'V014', '2014-10-08'),
(675, '300638', 'EC01', 'CV. DWIJAYA INDAH PLASTIC', 'Jl. Semanan Raya No.51', '0000024469', 'JAKARTA', '', '', '', '', '', '', '', '', 14, '', '', '', '', '', '', 'V014', '2014-10-08'),
(676, '300639', 'EC01', 'PT SURYA PEKALONGAN LESTARI', 'Menara matahari lantai 20', '0000024470', 'JAKARTA', '', '', '', '', '', '', '', '', 14, '', '', '', '', '', '', 'V014', '2014-10-08'),
(677, '300640', 'EC01', 'AMETHYS HOLIDAY', 'Jl.HR Rasuna Said kav B4', '0000024471', 'JAKARTA', '12920', '', '', '', '', '', '', '', 14, '', '', '', '', '', '', 'V014', '2014-10-08'),
(678, '300641', 'EC01', 'MITRA KARSA PRIMA', 'Jl.Raya PKP no 31a', '0000024480', 'JAKARTA', '13730', '', '', '', '', '', '', '', 14, '', '', '', '', '', '', 'V014', '2014-10-08'),
(679, '300642', 'EC01', 'PT SYNNEX METRODATA INDONESIA', 'Gedung APL Tower No.42', '0000024481', 'JAKARTA', '', '', '', '', '', '', '', '', 14, '', '', '', '', '', '', 'V014', '2014-10-08'),
(680, '300643', 'EC01', 'SEVEN ANGELS', 'Jl.A M Sangaji no 38', '0000024490', 'JAKARTA', '', '', '', '', '', '', '', '', 14, '', '', '', '', '', '', 'V014', '2014-10-08'),
(681, '300644', 'EC01', 'PT TREX NUSA WISATA', 'Jl.Bunga cempaka no 32', '0000024491', 'JAKARTA', '20132', '', '', '', '', '', '', '', 14, '', '', '', '', '', '', 'V014', '2014-10-08'),
(682, '300695', 'EC01', 'CV ANKALA RANCA PAWE', 'Jl.DI Panjaitan no 5 Rt 025', '0000024646', 'JAKARTA', '', '', '', '', '', '', '', '', 14, '', '', '', '', '', '', 'V014', '2014-10-08'),
(683, '300696', 'EC01', 'SINAR KEMENANGAN', 'Jakarta', '0000024647', 'JAKARTA', '', '', '', '', '', '', '', '', 14, '', '', '', '', '', '', 'V014', '2014-10-08'),
(684, '300697', 'EC01', 'PT TRIBUN MEDIA GRAFIKA', 'Komplek MCP', '0000024656', 'JAKARTA', '', '', '', '', '', '', '', '', 14, '', '', '', '', '', '', 'V014', '2014-10-08'),
(685, '300698', 'EC01', 'BAYU BUANA TRAVEL', 'Jl.Jend Sudirman kav 52-53', '0000024657', 'JAKARTA', '', '', '', '', '', '', '', '', 14, '', '', '', '', '', '', 'V014', '2014-10-08'),
(686, '300699', 'EC01', 'ASOSIASI EMITEN INDONESIA', 'Gedung permata kuningan lantai 20', '0000024662', 'JAKARTA', '12980', '', '', '', '', '', '', '', 14, '', '', '', '', '', '', 'V014', '2014-10-08'),
(687, '300700', 'EC01', 'GLOW', 'Jl. Aries asri 7 E16/19', '0000024671', 'JAKARTA', '', '', '', '', '', '', '', '', 14, '', '', '', '', '', '', 'V014', '2014-10-08'),
(688, '300701', 'EC01', 'PT SANDIPALA ARTHAPUTRA', 'Jl. Tebet Raya', '0000024672', 'JAKARTA', '', '', '', '', '', '', '', '', 14, '', '', '', '', '', '', 'V014', '2014-10-08'),
(689, '300702', 'EC01', 'PT JAUWHANNES TRACO', 'Jl.Majapahit no 765 km 11', '0000024673', 'SEMARANG', '', '', '', '', '', '', '', '', 14, '', '', '', '', '', '', 'V014', '2014-10-08'),
(690, '300703', 'EC01', 'PT GARUDA MITRA SEJATI', 'Jl.Magelang km 5.8 Rt006 Rw014', '0000024678', 'JAKARTA', '55284', '', '', '', '', '', '', '', 14, '', '', '', '', '', '', 'V014', '2014-10-08'),
(691, '300704', 'EC01', 'PT SECOM INDONESIA', 'Jl.Jend Sudirman Kav 3', '0000024683', 'JAKARTA', '10220', '', '', '', '', '', '01.070.804.8.058.000', '', 14, '', '', '', '', '', '', 'V014', '2014-10-08'),
(692, '300705', 'EC01', 'PT MULTI NUSANTARA KARYA,', 'Jl.Puri Boulevard BLK.U/1 Rt 001', '0000024684', 'JAKARTA', '11610', '', '', '', '', '', '02.492.960.6-086.002', '', 14, '', '', '', '', '', '', 'V014', '2014-10-08'),
(693, '300706', 'EC01', 'PT IVERSON TECHNOLOGY', 'Plaza Chase Lt 9', '0000024685', 'JAKARTA', '12920', '', '', '', '', '', '', '', 14, '', '', '', '', '', '', 'V014', '2014-10-08'),
(694, '300707', 'EC01', 'GA', 'Jakarta', '0000024690', 'JAKARTA', '', '', '', '', '', '', '', '', 14, '', '', '', '', '', '', 'V014', '2014-10-08'),
(695, '300708', 'EC01', 'HRD', 'Jakarta', '0000024695', 'JAKARTA', '', '', '', '', '', '', '', '', 14, '', '', '', '', '', '', 'V014', '2014-10-08'),
(696, '300709', 'EC01', 'PROMOTION', 'Jakarta', '0000024700', 'JAKARTA', '', '', '', '', '', '', '', '', 14, '', '', '', '', '', '', 'V014', '2014-10-08'),
(697, '300710', 'EC01', 'MAINTANANCE', 'Jakarta', '0000024705', 'JAKARTA', '', '', '', '', '', '', '', '', 14, '', '', '', '', '', '', 'V014', '2014-10-08'),
(698, '300711', 'EC01', 'PRODUCT', 'Jakarta', '0000024706', 'JAKARTA', '', '', '', '', '', '', '', '', 14, '', '', '', '', '', '', 'V014', '2014-10-08'),
(699, '300712', 'EC01', 'IT', 'Jakarta', '0000024715', 'JAKARTA', '', '', '', '', '', '', '', '', 14, '', '', '', '', '', '', 'V014', '2014-10-08'),
(700, '300713', 'EC01', 'STORE', 'Jakarta', '0000024724', 'JAKARTA', '', '', '', '', '', '', '', '', 14, '', '', '', '', '', '', 'V014', '2014-10-08'),
(701, '300714', 'EC01', 'LOGISTIK', 'Jakarta', '0000024725', 'JAKARTA', '', '', '', '', '', '', '', '', 14, '', '', '', '', '', '', 'V014', '2014-10-08'),
(702, '300715', 'EC01', 'TENANT', 'Jakarta', '0000024730', 'JAKARTA', '', '', '', '', '', '', '', '', 14, '', '', '', '', '', '', 'V014', '2014-10-08'),
(703, '300716', 'EC01', 'KANTOR PAJAK', 'Jakarta', '0000024735', 'JAKARTA', '', '', '', '', '', '', '', '', 14, '', '', '', '', '', '', 'V014', '2014-10-08'),
(704, '300717', 'EC01', 'SEKRETARIS', 'Jakarta', '0000024736', 'JAKARTA', '', '', '', '', '', '', '', '', 14, '', '', '', '', '', '', 'V014', '2014-10-08'),
(705, '300718', 'EC01', 'LEGAL', 'Jakarta', '0000024741', 'JAKARTA', '', '', '', '', '', '', '', '', 14, '', '', '', '', '', '', 'V014', '2014-10-08'),
(706, '300719', 'EC01', 'FINANCE & ACCOUNTING', 'Jakarta', '0000024742', 'JAKARTA', '', '', '', '', '', '', '', '', 14, '', '', '', '', '', '', 'V014', '2014-10-08'),
(707, '300720', 'EC01', 'PROJECT DITLANTAS', 'Jakarta', '0000024751', 'JAKARTA', '', '', '', '', '', '', '', '', 14, '', '', '', '', '', '', 'V014', '2014-10-08'),
(708, '300721', 'EC01', 'PT.PRO UNION INDO JAYA', 'JL.Raya Serpong KM 10', '0000024752', 'JAKARTA', '', '', '', '', '', '', '', '', 14, '', '', '', '', '', '', 'V014', '2014-10-08'),
(709, '300722', 'EC01', 'PROJECT DITLANTAS II', 'Jakarta', '0000024753', 'JAKARTA', '', '', '', '', '', '', '', '', 14, '', '', '', '', '', '', 'V014', '2014-10-08'),
(710, '300723', 'EC01', 'PT.JALA ARTHA', 'JL. PALAPA II NO. 19', '0000024762', 'JAKARTA', '', '', '', '', '', '', '', '', 14, '', '', '', '', '', '', 'V014', '2014-10-08'),
(711, '300724', 'EC01', 'DIREKSI', 'Jakarta', '0000024767', 'JAKARTA', '', '', '', '', '', '', '', '', 14, '', '', '', '', '', '', 'V014', '2014-10-08'),
(712, '300725', 'EC01', 'WEB E-Commerce', 'Jakarta', '0000024768', 'JAKARTA', '', '', '', '', '', '', '', '', 14, '', '', '', '', '', '', 'V014', '2014-10-08'),
(713, '300726', 'EC01', 'JAVA PRODUCTION', 'Jakarta', '0000024769', 'JAKARTA', '', '', '', '', '', '', '', '', 14, '', '', '', '', '', '', 'V014', '2014-10-08'),
(714, '300727', 'EC01', 'PT TROPHY', 'Jakarta', '0000024770', 'JAKARTA', '', '', '', '', '', '', '', '', 14, '', '', '', '', '', '', 'V014', '2014-10-08'),
(715, '300728', 'EC01', 'CV MEGAH SENTOSA', 'Jl.Jend Sudirman no 906A (Cinde) Pa', '0000024775', 'PALEMBANG', '30129', '', '', '', '', '', '', '', 14, '', '', '', '', '', '', 'V014', '2014-10-08'),
(716, '300680', 'EC01', 'PT OBOR SARANA UTAMA', 'Jl.Kramat IV no 11,', '0000024595', 'JAKARTA', '', '', '', '', '', '', '', '', 14, '', '', '', '', '', '', 'V014', '2014-10-08'),
(717, '300681', 'EC01', 'EUROMONITOR INTERNATIONAL (Asia)Ltd', '60-61 Britton Street London EC1M 5U', '0000024604', 'JAKARTA', '', '', '', '', '', '', '', '', 14, '', '', '', '', '', '', 'V014', '2014-10-08'),
(718, '300682', 'EC01', 'CV AIR PERSADA NUSANTARA', 'Komplek Bumi Inti Persada Blok-M', '0000024609', 'JAKARTA', '', '', '', '', '', '', '', '', 14, '', '', '', '', '', '', 'V014', '2014-10-08'),
(719, '300683', 'EC01', 'PT MEDIA KITA SEJAHTERA', 'Jl.Malik Raya no 50', '0000024614', 'KENDARI', '93111', '', '', '', '', '', '', '', 14, '', '', '', '', '', '', 'V014', '2014-10-08'),
(720, '300684', 'EC01', 'PT ANDALAN NUSANTARA TEKNOLOGI', 'Jl. Jend.Sudirman Kav.32', '0000024615', 'JAKARTA', '', '', '', '', '', '', '', '', 14, '', '', '', '', '', '', 'V014', '2014-10-08'),
(721, '300685', 'EC01', 'TOKO SUMBER SINAR', 'Jl. Kenari Baru Blok C no.14', '0000024620', 'JAKARTA', '', '', '', '', '', '', '', '', 14, '', '', '', '', '', '', 'V014', '2014-10-08'),
(722, '300686', 'EC01', 'CV JAYA SAKTI ADVERTISING', 'Gg sugihwaras no 3 kec Pekalongan', '0000024621', 'JAKARTA', '', '', '', '', '', '', '', '', 14, '', '', '', '', '', '', 'V014', '2014-10-08'),
(723, '300687', 'EC01', 'PT MEKAR ARMADA JAYA', 'Jl.Mayjend Bambang Soegeng No 7', '0000024626', 'JAKARTA', '56172', '', '', '', '', '', '', '', 14, '', '', '', '', '', '', 'V014', '2014-10-08'),
(724, '300688', 'EC01', 'PT ACADEMIA CITRA ABADI', 'Jl.MH Thamrin no 9', '0000024627', 'JAKARTA', '10340', '', '', '', '', '', '', '', 14, '', '', '', '', '', '', 'V014', '2014-10-08'),
(725, '300689', 'EC01', 'CV SINAR WAHYU MEDIA PROMOSI SEMEST', 'Jl.Tawang Sari no 26 Rt 013 Rw 004', '0000024628', 'JAKARTA', '', '', '', '', '', '', '', '', 14, '', '', '', '', '', '', 'V014', '2014-10-08'),
(726, '300690', 'EC01', 'PT MADIUN INTERMEDIA PERS (RADAR MA', 'Jl. Mayjen Panjaitan no 12', '0000024633', 'JAKARTA', '', '', '', '', '', '', '', '', 14, '', '', '', '', '', '', 'V014', '2014-10-08'),
(727, '300691', 'EC01', 'PT MAHKOTA PIRANTI ABADI', 'Jl.Tebet Timur Dalam Raya no 17', '0000024638', 'JAKARTA', '12820', '', '', '', '', '', '', '', 14, '', '', '', '', '', '', 'V014', '2014-10-08'),
(728, '300692', 'EC01', 'TOKO MANGGALAM', 'Ruko Cendana GP 1', '0000024639', 'JAKARTA', '', '', '', '', '', '', '', '', 14, '', '', '', '', '', '', 'V014', '2014-10-08'),
(729, '300693', 'EC01', 'PT MAYURA AGRA YUWANA', 'JL. SELAPARANG NO.78 MAYURA', '0000024640', 'JAKARTA', '', '', '', '', '', '', '', '', 14, '', '', '', '', '', '', 'V014', '2014-10-08'),
(730, '300694', 'EC01', 'PT CAHAYA REZEKI SEMESTA', 'Jl.Krisan Blok B no 21', '0000024641', 'JAKARTA', '', '', '', '', '', '', '', '', 14, '', '', '', '', '', '', 'V014', '2014-10-08'),
(731, '300747', 'EC01', 'TOKO SUMBER SINAR (DELETED)', 'Jl Raya Salemba 2 Psr Kenari Baru', '0004548184', 'JAKARTA', '', '', '021-3909559', '', '', '', '', 'alat2listrik@gmail.com', 14, '', '', '', '', '', '', 'V014', '2014-11-04'),
(732, '300752', 'EC01', 'CV RICH BROTHER ADVERTISING', 'No 15 Jln H Yusuf', '0004550831', 'CILEDUG TANGERANG', '', '', '087883096919', '', '', '', '71.658.219.2.416.000', 'dodiek.husodo@gmail.com', 14, '', '', '', '', '', '', 'V014', '2014-11-06'),
(733, '300753', 'EC01', 'PT MULTI NUSANTARA KARYA.', 'JL POM IX PALEMBANG ICON', '0004552387', 'PALEMBANG', '', '', '', '', '', '', '02.492.960.6.307.002', '', 14, '', '', '', '', '', '', 'V014', '2014-11-07'),
(734, '300754', 'EC01', 'PT MULTI NUSANTARA KARYA\'', '123 JL.SILIWANGI', '0004552388', 'BOGOR', '16142', '', '', '', '', '', '02.492.960.6.404.001', '', 7, '', '', '', '', '', '', 'V007', '2014-11-07'),
(735, '300755', 'EC01', 'CV SINAR WAHYU MEDIA (JGN DIPAKE)', '26 JL.TAWANG SARI', '0004552389', 'MADIUN', '', '', '', '', '', '', '31.443.383.0.621.000', '', 7, '', '', '', '', '', '', 'V007', '2014-11-07'),
(736, '300756', 'EC01', 'DANIEL KRISNADARTA', '3F/354 TIRTA BUANA', '0004552390', 'BEKASI', '', '', '', '', '', '', '', '', 14, '', '', '', '', '', '', 'V014', '2014-11-07'),
(737, '300757', 'EC01', 'PT MULTIPRATAMA INDAH RAYA', '1 JL TENTARA PELAJAR', '0004552391', 'CIREBON', '', '', '', '', '', '', '01.566.492.3.426.001', '', 14, '', '', '', '', '', '', 'V014', '2014-11-07'),
(738, '300758', 'EC01', 'RICH BROTHER ADV (JANGAN DIPAKE)', 'JL.HAJI YUSUF PESONA PALE', '0004552392', '', '', '', '0878 8309 919', '', '', '', '', '', 14, '', '', '', '', '', '', 'V014', '2014-11-07'),
(739, '300759', 'EC01', 'PT LANGGENG MULTI JAYA', '04 JL.RM MOCH KAHFI I', '0004552397', 'JAKARTA SELATAN', '', '', '021-70631149', '', '', '', '02.616.927.6.017.000', '', 14, '', '', '', '', '', '', 'V014', '2014-11-07'),
(740, '300760', 'EC01', 'ASOSIASI PENGUSAHA RITEL INDONESIA', '11 JL MH THAMRIN', '0004562008', 'JAKARTA', '10350', '', '021-3154241', '', '', '', '', '', 14, '', '', '', '', '', '', 'V014', '2014-11-11'),
(741, '300761', 'EC01', 'PERHIMPUNAN PENGHUNI TAMINI SQUARE', 'JL.TAMAN MINI RAYA', '0004562013', 'JAKARTA TIMUR', '13560', '', '', '', '', '', '70.719.603.6.005.000', '', 14, '', '', '', '', '', '', 'V014', '2014-11-11'),
(742, '300762', 'EC01', 'RESTU ELECTRIC', '126 JL.JEND SUDIRMAN RT005/001', '0004562083', 'JAWA TENGAH', '', '', '', '', '', '', '70.818.027.8.513.000', '', 14, '', '', '', '', '', '', 'V014', '2014-11-11'),
(743, '300763', 'EC01', 'PT. REDPOD INDONESIA', 'No 43-45 Jln. Danau Sunter Selatan', '0004565681', 'JAKARTA', '14350', '', '02165835390', '', '', '', '02.489.340.6-002.000', 'steven@redpodgroup.com', 14, '', '', '', '', '', '', 'V014', '2014-11-13'),
(744, '300764', 'EC01', 'PT AIR TANJUNG PERSADA', '79A JL.DESA PUTRA', '0004566805', 'JAKARTA SELATAN', '12640', '', '', '', '', '', '31.290.412.1.017.000', '', 14, '', '', '', '', '', '', 'V014', '2014-11-14'),
(745, '300765', 'EC01', 'PT CITRA BUMI SUMATERA', '773 JL.KOL.H.BARLIAN', '0004566816', 'PALEMBANG', '30152', '', '0711-415262', '', '', '0711-420066', '01.238.192.7.308.000', '', 14, '', '', '', '', '', '', 'V014', '2014-11-14'),
(746, '300766', 'EC01', 'PT. AMANJA MEGA PERSADA', 'No 7 Pusat Niaga Roxy Mas Blok D4', '0004566900', 'JAKARTA', '10150', '', '216308818', '', '', '2163858239', '01.392.752.0-028.000', 'info@amanja.co.id', 14, '', '', '', '', '', '', 'V014', '2014-11-14'),
(747, '300767', 'EC01', 'COORPORATE SECRETARY SALAH', 'JL.JEND SUDIRMAN', '0004575945', 'JAKARTA SELATAN', '', '', '', '', '', '', '', '', 14, '', '', '', '', '', '', 'V014', '2014-11-17'),
(748, '300768', 'EC01', 'CV LINTAS KREASI', '6 JL GAMELAN', '0004577528', 'YOGYAKARTA', '', '', '', '', '', '', '02.645.391.0.541.000', '', 14, '', '', '', '', '', '', 'V014', '2014-11-18'),
(749, '300769', 'EC01', 'PT. CIPTA CITRA MEDIA', 'No 54 Jln. Pramuka Raya', '0004577538', 'JAKARTA TIMUR', '13140', '', '218519295', '', '', '2185901435', '02.835.583.2-001.000', '', 14, '', '', '', '', '', '', 'V014', '2014-11-18'),
(750, '300770', 'EC01', 'PT FAJAR ANDREAS ABADI', '61 JL KERJA BAKTI I', '0004577572', 'JAKARTA TIMUR', '', '', '021-8087763', '', '', '', '02.411.388.8.005.000', '', 14, '', '', '', '', '', '', 'V014', '2014-11-18'),
(751, '300771', 'EC01', 'AGUNG WITJAKSONO', '177 JL KAYU MANIS 1 LAMA', '0004579910', 'JAKARTA TIMUR', '', '', '', '', '', '', '48.793.820.1.001.000', '', 14, '', '', '', '', '', '', 'V014', '2014-11-20'),
(752, '300772', 'EC01', 'CV. SURYA PERMATA TEKNIK', 'BLOK A KOMP. PERMATA INDAH', '0004579936', 'BEKASI', '', '', '085759046643', '', '', '', '02.664.621.6-407.000', 'suryapermatateknikpwk@yahoo.com', 14, '', '', '', '', '', '', 'V014', '2014-11-20'),
(753, '300773', 'EC01', 'PT BUMI SERPONG DAMAI', '1 BSD BOULEVARD BARAT KAVLING OFFIC', '0004581360', 'TANGERANG', '', '', '', '', '', '', '01.374.249.9.054.000', '', 14, '', '', '', '', '', '', 'V014', '2014-11-21'),
(754, '300774', 'EC01', 'COORPORATE SECRETARY', 'JL.JEND SUDIRMAN', '0004589762', '', '', '', '', '', '', '', '', '', 14, '', '', '', '', '', '', 'V014', '2014-11-24'),
(755, '300775', 'EC01', 'DIRECT SALES', '', '0004592398', '', '', '', '', '', '', '', '', '', 14, '', '', '', '', '', '', 'V014', '2014-11-26'),
(756, '300776', 'EC01', 'GRAMICA MULTIDISPLAY', 'No 504 Jln Letjend Soeprapto', '0004592502', 'JAKARTA  PUSAT', '10530', '', '214256935', '', '', '', '', 'gramica_multidisplay@yahoo.com', 14, '', '', '', '', '', '', 'V014', '2014-11-26'),
(757, '300777', 'EC01', 'PT HARRYANTO WISESA SEJATI', '1 JL GUNUNG SAHARI RAYA', '0004604189', 'JAKARTA UTARA', '', '', '021-22620508', '', '', '', '', '', 14, '', '', '', '', '', '', 'V014', '2014-12-01'),
(758, '300778', 'EC01', 'M-BIZ GLOBAL SOLUTIONS GMBH', 'HIRSCHENGRABEN 31,6003,LUZERN', '0004607644', 'SWITZERLAND', '6003', '', '', '', '', '', '', '', 14, '', '', '', '', '', '', 'V014', '2014-12-03'),
(759, '300779', 'EC01', 'PT LAKHSMINDO CIPTA MAKMUR', '8 JL DARMAWANGSA RAYA', '0004607690', 'JAKARTA', '12150', '', '021-7264358', '', '', '021-7264359', '01.623.464.3.016.000', '', 14, '', '', '', '', '', '', 'V014', '2014-12-03'),
(760, '300780', 'EC01', 'PT. HARMONI EMPAT SELARAS', 'No 73 Jl Diklat Pemda Kp Badodon Rt', '0004607701', 'TANGERANG', '', '', '215983812', '', '', '215983811', '31.808.772.3-451.000', '', 14, '', '', '', '', '', '', 'V014', '2014-12-03'),
(761, '300782', 'EC01', 'BUSINESS DEVELOPMENT', 'JL JEND SUDIRMAN KAV 52-53', '0004610709', 'JAKARTA', '', '', '', '', '', '', '', '', 14, '', '', '', '', '', '', 'V014', '2014-12-05'),
(762, '300783', 'EC01', 'SETIA USAHA', 'NO. 131 PS. KENARI LT. DASAR BLOK.', '0004623770', 'JAKARTA PUSAT', '', '', '021-3145008', '', '', '', '', '', 14, '', '', '', '', '', '', 'V014', '2014-12-10'),
(763, '300784', 'EC01', 'CV. ANEKA JAYA', 'Kp. Bantargedang Rt.004 Rw.009', '0004623991', 'BANDUNG JAWA BARAT', '', '', '08122163367', '', '', '', '', 'mashadi3@gmail.com', 14, '', '', '', '', '', '', 'V014', '2014-12-10'),
(764, '300729', 'EC01', 'CV RHEMA ADVERTISING', 'jl.Rimba Kemuning LR Ogan no 735 Rt', '0000024780', 'PALEMBANG', '', '', '', '', '', '', '03.103.642.9.301.000', '', 14, '', '', '', '', '', '', 'V014', '2014-10-08'),
(765, '300730', 'EC01', 'CV SINAR WAHYU MEDIA', 'Jl.Tawang Sari no 26 Rt 013 Rw 004,', '0000024789', 'MADIUN', '', '', '', '', '', '', '', '', 14, '', '', '', '', '', '', 'V014', '2014-10-08'),
(766, '300731', 'EC01', 'CV TOKO PASIFIK LOMBOK', 'Jl. AA Gede murah KR kelebut RT.001', '0000024790', 'MATARAM', '', '', '', '', '', '', '', '', 14, '', '', '', '', '', '', 'V014', '2014-10-08'),
(767, '300732', 'EC01', 'JESEN', 'Jl. Sunter Hijau No.14 jakarta Utar', '0000024795', 'JAKARTA', '', '', '', '', '', '', '', '', 14, '', '', '', '', '', '', 'V014', '2014-10-08'),
(768, '300733', 'EC01', 'SETIAWAN BUDIONO-JOEWIE TEK', 'Jl. Kh.Mansyur No.53, Bendan pekalo', '0000024804', 'PEKALONGAN', '', '', '', '', '', '', '06.077.610.1.502.000', '', 14, '', '', '', '', '', '', 'V014', '2014-10-08'),
(769, '300734', 'EC01', 'PT GRIYA INTI SEJAHTERA INSANI', 'Jl.POM IX No 01 Rt 031/009 Lorok Pa', '0000024809', 'PALEMBANG', '30137', '', '', '', '', '', '', '', 14, '', '', '', '', '', '', 'V014', '2014-10-08'),
(770, '300735', 'EC01', 'PT INDOPACIFIC CEMERLANG', 'Puri Imperium Office Plaza JL.kunin', '0000024814', 'JAKARTA', '', '', '', '', '', '', '', '', 14, '', '', '', '', '', '', 'V014', '2014-10-08'),
(771, '300736', 'EC01', 'PT KARKA ABISATYA MATARAM', 'JL. Gambir No 09, Baciro. Yogyakart', '0000024827', 'YOGYAKARTA', '', '', '', '', '', '', '', '', 14, '', '', '', '', '', '', 'V014', '2014-10-08'),
(772, '300737', 'EC01', 'PT MULIA MAKMUR LESTARI', 'Komplek Rejeki Graha Mas Blok B No', '0000024828', 'BATAM', '', '', '', '', '', '', '', '', 14, '', '', '', '', '', '', 'V014', '2014-10-08'),
(773, '300738', 'EC01', 'PT NATURAL ADVERTISING', 'JL.Letnan Tukiyat Sawitan Kota Mung', '0000024829', 'MAGELANG', '', '', '', '', '', '', '', '', 14, '', '', '', '', '', '', 'V014', '2014-10-08'),
(774, '300739', 'EC01', 'PT PARAMA SPEKTRUM SEJAHTERA', 'Komp.Keb.Baru Mall No.20-21 JL.Keb.', '0000024834', 'JAKARTA', '', '', '', '', '', '', '', '', 14, '', '', '', '', '', '', 'V014', '2014-10-08'),
(775, '300740', 'EC01', 'PT PRO AKTIF MEDIATHAMA', 'Jl. Raya Bekasi Km.21 Ruko Blok B N', '0000024847', 'BEKASI', '', '', '', '', '', '', '', '', 14, '', '', '', '', '', '', 'V014', '2014-10-08'),
(776, '300741', 'EC01', 'PT. MAHLIGAI PUTERI BERLIAN', 'JL.Raya Cibabat No.327 , Cimahi Ban', '0000024848', 'BANDUNG', '40522', '', '', '', '', '', '', '', 14, '', '', '', '', '', '', 'V014', '2014-10-08'),
(777, '300742', 'EC01', 'SATURN ELECTRONIC PART', 'Jl. Asia No.39 Medan', '0000024853', 'MEDAN', '', '', '', '', '', '', '', '', 14, '', '', '', '', '', '', 'V014', '2014-10-08'),
(778, '300743', 'EC01', 'UD ABI NAZILA', '', '0000024858', '', '', '', '', '', '', '', '', '', 14, '', '', '', '', '', '', 'V014', '2014-10-08'),
(779, '300744', 'EC01', 'PT. SEMAR GEMILANG', 'JL. Simpangan, Kampung Cibeber', '0000027607', 'BEKASI', '17836', '', '98610336', '', '', '58907651', '25591595414000', 'susi.muryani@semargemilang.com', 14, '', '', '', '', '', '', 'V014', '2014-10-08'),
(780, '300802', 'EC01', 'CV. SMART INTI MEDIA', 'No 30 Jl. Kanggraksan No. 30', '0005631085', 'CIREBON - JAWA BARAT', '', '', '0231-484409', '', '', '', '31.287.914.1-426.000', 'smarintimedia@gmail.com', 14, '', '', '', '', '', '', 'V014', '2015-01-22'),
(781, '300803', 'EC01', 'PT. KREASI SARANA PRIMA', 'No. 17 Ruko Mutiara Taman Palem Blo', '0005631090', 'JAKARTA BARAT', '11730', '', '54353510', '', '', '54350931', '03.100.311.4-034.000', '', 14, '', '', '', '', '', '', 'V014', '2015-01-22'),
(782, '300807', 'EC01', 'PT JURISA PRIMA', 'No. 120 Jl. Kayu Manis Barat', '0005632225', 'JAKARTA TIMUR', '13130', '', '7543784', '', '', '7535231', '01.495.060.4-001.000', '', 14, '', '', '', '', '', '', 'V014', '2015-01-23'),
(783, '300808', 'EC01', 'PT MANGGALA POSTER INDONESIA', 'No. 26 Jl. Mandala Selatan Tomang', '0005632291', 'JAKARTA', '11440', '', '5683355', '', '', '5632119', '02.881.080.2-036.000', 'yasmaradhana_as@yahoo.com', 14, '', '', '', '', '', '', 'V014', '2015-01-23'),
(784, '300809', 'EC01', 'PT BURSA EFEK INDONESIA', 'GEDUNG BURSA EFEK INDONESIA', '0005646173', 'JAKARTA SELATAN', '12190', '', '', '', '', '', '01.555.670.7.054.000', '', 14, '', '', '', '', '', '', 'V014', '2015-01-30'),
(785, '300810', 'EC01', 'PT. WAHANA SEMESTA CIREBON', 'No. 9 Jl. Perjuangan', '0005653737', 'JAWA BARAT', '', '', '021-5329008', '', '', '', '01.912.903.0.426.000', 'ekos_be@yahoo.com', 14, '', '', '', '', '', '', 'V014', '2015-02-02'),
(786, '300811', 'EC01', 'PT. DWITAMA GEMILANG KREASINDO', 'No. 99 Jl. Raya Pagelarang', '0005654041', 'JAWA BARAT', '', '', '08561573140', '', '', '', '31.710.455.2-432.000', 'jarwo16@yahoo.com', 14, '', '', '', '', '', '', 'V014', '2015-02-02'),
(787, '300812', 'EC01', 'PT ATREUS GLOBAL', 'LT 18 SAMPOERNA STRATEGI SQUARE SOU', '0005655164', '', '12930', '', '', '', '', '', '02.845.143.3.063.000', '', 14, '', '', '', '', '', '', 'V014', '2015-02-05'),
(788, '300813', 'EC01', 'UNIVERSAL ENGIN (JANGAN DIPAKAI)', 'No. 21 A JL. Waturenggong', '0005671047', 'DENPASAR, BALI', '', '', '0361 - 247853', '', '', '0361 - 7484542', '', '', 14, '', '', '', '', '', '', 'V014', '2015-02-12'),
(789, '300814', 'EC01', 'RESTU ELECTRIC (JANGAN DIPAKAI)', 'No. 126 Jl. Jendral Sudirman', '0005671065', 'BATANG, PEKALONGAN', '', '', '081326994441', '', '', '', '', '', 14, '', '', '', '', '', '', 'V014', '2015-02-12'),
(790, '300815', 'EC01', 'PT KAGUM JAYA SAKTI', 'JL.TUPAREV BLOK CANTILAN', '0005682191', 'JAWA BARAT', '', '', '022-2037676', '', '', '022-2037722', '31.259.197.7.426.001', '', 14, '', '', '', '', '', '', 'V014', '2015-02-17'),
(791, '300816', 'EC01', 'CALVIN DIGITAL', 'No. 53 Jl. Kutagara', '0005683238', 'CIREBON', '', '', '', '', '', '', '', '', 14, '', '', '', '', '', '', 'V014', '2015-02-18'),
(792, '300817', 'EC01', 'PURI COMPUTER', '4-B JL. MANGGA BESAR VI UTARA', '0005683247', 'JAKARTA', '11150', '', '021-6599274', '', '', '021-6122867', '', '', 14, '', '', '', '', '', '', 'V014', '2015-02-18');
INSERT INTO `api_vendor` (`id`, `supplierCode`, `companyCode`, `name`, `address1`, `address2`, `city`, `postalCode`, `contactPerson`, `phone`, `hp1`, `hp2`, `fax`, `npwp`, `email`, `paymentTerm`, `bankCode`, `bankName`, `bankBranchCode`, `bankBranchName`, `bankAccountNo`, `status`, `paymentTermCd`, `dateCreate`) VALUES
(793, '300818', 'EC01', 'PT JAVAS CYCLEWERKS INDONESIA', '47C JL.CEMPAKA PUTIH TENGAH II', '0005683492', 'JAKARTA', '', '', '', '', '', '', '', '', 14, '', '', '', '', '', '', 'V014', '2015-02-18'),
(794, '300819', 'EC01', 'PT. MITRASOFT INFONET (JGN DIPAKE)', 'No. 03 Pusat Niaga Roxy Mas Blok E', '0005687710', 'JAKARTA PUSAT', '10150', '', '6326533', '', '', '6326364', '01.770.790.2-028.000', 'info@mitrasoft.co.id', 14, '', '', '', '', '', '', 'V014', '2015-02-20'),
(795, '300820', 'EC01', 'PT. BRAND MEDIA APAAJA', 'NO. 38-39 JL. ASIA AFRIKA PINTU IX', '0005695425', 'JAKARTA PUSAT', '10270', '', '021-57931833', '', '', '', '031568728077000', '', 14, '', '', '', '', '', '', 'V014', '2015-02-23'),
(796, '300821', 'EC01', 'PT PUTRA SUKSES GEMILANG', 'JL KEMANGGISAN RAYA BLOK B 41', '0005695453', 'JAKARTA BARAT', '11480', '', '021-53652073', '', '', '021-53652073', '030935811031000', '', 14, '', '', '', '', '', '', 'V014', '2015-02-23'),
(797, '300822', 'EC01', 'CV JAYA PROTECT', 'NO. 12 JL KARTIKA ASRI BLOK D III', '0005696758', 'PUDAK PAYUNG SEMARANG', '', '', '024-70381633', '', '', '024-76485055', '025831835517000', 'jayaprotect@yahoo.co.id', 14, '', '', '', '', '', '', 'V014', '2015-02-24'),
(798, '300823', 'EC01', 'COMO.COM', '', '0005696806', '', '', '', '', '', '', '', '', '', 14, '', '', '', '', '', '', 'V014', '2015-02-24'),
(799, '300824', 'EC01', 'PT. BUANA NUR ABADI', 'NO. 1 JL. HARSONO RM', '0005708768', 'JAKARTA SELATAN', '', '', '021-78838225', '', '', '021-78838229', '', '', 14, '', '', '', '', '', '', 'V014', '2015-03-02'),
(800, '300825', 'EC01', 'PT BIZZY COMMERCE INDONESIA', 'NO. 1 JL RIAU', '0005708790', 'MENTENG', '10350', '', '021-31909048', '', '', '', '72.830.427.0.076.000', '', 14, '', '', '', '', '', '', 'V014', '2015-03-02'),
(801, '300826', 'EC01', 'PT. PIONEER KREASI', 'NO. 1-9 JL. SURYOPRANOTO', '0005712123', 'JAKARTA PUSAT', '', '', '', '', '', '', '022505382028000', '', 14, '', '', '', '', '', '', 'V014', '2015-03-04'),
(802, '300827', 'EC01', 'PT MITRA PAJAKKU', '26 JL.KEMANGGISAN UTAMA RAYA', '0005714582', 'JAKARTA BARAT', '11480', '', '', '', '', '', '02.398.655.7.031.000', '', 14, '', '', '', '', '', '', 'V014', '2015-03-06'),
(803, '300828', 'EC01', 'PT MANDAU BERLIAN SEJATI', '036 JL.MT HARYONO', '0005724796', 'BALIKPAPAN', '', '', '', '', '', '', '01.408.317.4.725.000', '', 14, '', '', '', '', '', '', 'V014', '2015-03-11'),
(804, '300829', 'EC01', 'MULYANA', 'JAKARTA', '0005724830', 'INDONESIA', '', '', '', '', '', '', '', '', 14, '', '', '', '', '', '', 'V014', '2015-03-11'),
(805, '300830', 'EC01', 'CV VISUALINDO PROMO ADVERTISING', 'No. 16/3 Jl. S. Parman', '0005726938', 'LAMPUNG', '35117', '', '(0721) 241919', '', '', '(0721) 260854', '03.066.002.1-322.000', 'visualindopromo@yahoo.com', 14, '', '', '', '', '', '', 'V014', '2015-03-13'),
(806, '300831', 'EC01', 'PT. PERICOM NUSANTARA', 'Glogok Plaza Lt. III Atas', '0005735774', 'JAKARTA BARAT', '', '', '62203588', '', '', '6009951', '01.659.771.8-032.000', '', 14, '', '', '', '', '', '', 'V014', '2015-03-17'),
(807, '300832', 'EC01', 'PT. TECHPOINT BISNIS SOLUSI', 'No. 27 Tower Everest K2 Unit 01', '0005736147', 'JAKARTA BARAT', '11620', '', '29544301', '', '', '', '02.880.134.8-086.000', 'sri.yani@techpoint.co.id', 14, '', '', '', '', '', '', 'V014', '2015-03-17'),
(808, '300837', 'EC01', 'PT MANDIRI JAYA PERKASA UTAMA', 'Blok G 16 Jl.RE Martadinata ruko pe', '0005751843', 'JAKARTA RAYA', '14420', '', '', '', '', '', '02.101.151.5.044.000', '', 14, '', '', '', '', '', '', 'V014', '2015-03-25'),
(809, '300838', 'EC01', 'CV NAUFAL PRIMA MANDIRI', 'no 1 Jl.Kemajuan', '0005751844', 'JAKARTA SELATAN', '12270', '', '', '', '', '', '01.828.321.8.013.000', '', 14, '', '', '', '', '', '', 'V014', '2015-03-25'),
(810, '300839', 'EC01', 'NARADA PRODUCTION', 'C19 CLUSTER GADING PAMULANG', '0005761920', 'PAMULANG,TANGSEL', '15416', '', '', '', '', '', '54.538.733.4.411.000', '', 14, '', '', '', '', '', '', 'V014', '2015-03-30'),
(811, '300840', 'EC01', 'PT ALTARINDO DURYA KASTARA', '1A Jl.Kelapa Gading V', '0005780798', 'JAKARTA TIMUR', '', '', '', '', '', '', '31.258.394.1.013.000', '', 14, '', '', '', '', '', '', 'V014', '2015-04-08'),
(812, '300785', 'EC01', 'PT. TRIYASA TUNGGA MANDIRI', 'NO. 19 JL. SISINGAMANGARAJA XII', '0004636420', 'MEDAN', '20149', '', '0261-80042013', '', '', '0261-80042013', '317669497122000', '', 14, '', '', '', '', '', '', 'V014', '2014-12-15'),
(813, '300786', 'EC01', 'CV. CANVIL GROUP', 'No 35 Jln. Sentot Alibasya Pembangu', '0004656306', 'LAMPUNG', '35131', '', '0721-7553183', '', '', '', '03.129.620.5.323.000', '', 14, '', '', '', '', '', '', 'V014', '2014-12-22'),
(814, '300787', 'EC01', 'PT. LUMINA MEKAR MULTIMEDIA', 'No 6 Bintara Loka Indah Blok QQ9', '0004656311', 'BEKASI BARAT', '17340', '', '2188967185', '', '', '2188967185', '66.063.526.9-407.000', '', 14, '', '', '', '', '', '', 'V014', '2014-12-22'),
(815, '300788', 'EC01', 'PT ABEO INDONESIA', 'TOTAL BUILDING LT 8', '0004681077', 'JAKARTA BARAT', '', '', '', '', '', '', '70.030.104.7.036.000', '', 14, '', '', '', '', '', '', 'V014', '2014-12-29'),
(816, '300789', 'EC01', 'ANALYST', 'JL.JEND SUDIRMAN KAV-52-53', '0004692658', 'JAKARTA', '', '', '', '', '', '', '', '', 14, '', '', '', '', '', '', 'V014', '2015-01-02'),
(817, '300790', 'EC01', 'CV. TIANG AIRMAS SEJAHTERA', 'NO. 99 B JL. RAYA KALIMALANG', '0004704055', 'DUREN SAWIT - JAKARTA TIM', '', '', '021-8613604', '', '', '021-8613604', '02.867.589.0.008.000', 'tiangairmas_sj@yahoo.com', 14, '', '', '', '', '', '', 'V014', '2015-01-06'),
(818, '300791', 'EC01', 'FEBRIANA LOUW', '72/86 JL SIAM RT 004 RW 04', '0004705463', 'KALIMANTAN BARAT', '', '', '', '', '', '', '', '', 14, '', '', '', '', '', '', 'V014', '2015-01-07'),
(819, '300792', 'EC01', 'PT SRIWIJAYA PROPINDO UTAMA', 'JL.SRIWIJAYA EXS KANTOR BUPATI PUNI', '0004706834', 'MATARAM', '', '', '', '', '', '', '03.108.999.8.911.000', '', 14, '', '', '', '', '', '', 'V014', '2015-01-08'),
(820, '300793', 'EC01', 'CV. QINTANI ADV', 'No 26 Jln. Dr Wahidin', '0004707969', 'CIREBON - JAWA BARAT', '', '', '', '', '', '', '', '', 14, '', '', '', '', '', '', 'V014', '2015-01-09'),
(821, '300794', 'EC01', 'PT PROVICES INDONESIA', 'GEDUNG BAKRIE TOWER LT 80', '0005617839', 'JAKARTA SELATAN', '', '', '', '', '', '', '02.672.153.0.011.000', '', 14, '', '', '', '', '', '', 'V014', '2015-01-14'),
(822, '300795', 'EC01', 'MANTHAN SOFTWARE SERVICES Pte ltd', '40/4 LAVELLE ROAD,BANGALORE', '0005619070', 'INDIA', '560001', '', '', '', '', '', '', '', 14, '', '', '', '', '', '', 'V014', '2015-01-15'),
(823, '300796', 'EC01', 'PT INDOMOBIL TRADA NASIONAL', 'NO. 8 JL MANGGA DUA RAYA', '0005619124', 'JAKARTA UTARA', '14430', '', '', '', '', '021-29986226', '018174920007000', '', 14, '', '', '', '', '', '', 'V014', '2015-01-15'),
(824, '300797', 'EC01', 'UD GRAND HOSANA', 'NO. 2A PROYEK SENEN LT 2 BLOK 1', '0005620257', 'JAKARTA PUSAT', '', '', '', '', '', '', '', '', 14, '', '', '', '', '', '', 'V014', '2015-01-16'),
(825, '300798', 'EC01', 'CV. LINKMEDIA ADVERTISING', 'No. 1 Jl. Majapahit', '0005620277', 'MATARAM - LOMBOK', '', '', '0370 - 646196', '', '', '0370 - 636432', '01.946.599.6-911.000', '', 14, '', '', '', '', '', '', 'V014', '2015-01-16'),
(826, '300799', 'EC01', 'TB JAYA', 'NO. 150 JL PEMUDA', '0005627527', 'MAGELANG JAWA TENGAH', '', '', '', '', '', '', '', '', 14, '', '', '', '', '', '', 'V014', '2015-01-19'),
(827, '300800', 'EC01', 'PT. TRIKARSA SEMPURNA SISTEMINDO', 'No. 10 Jl. Timor', '0005629865', 'JAKARTA PUSAT', '10350', '', '319351663', '', '', '31935226', '02.275.781.9-076.000', 'canab@tri-karsa.com', 14, '', '', '', '', '', '', 'V014', '2015-01-21'),
(828, '300801', 'EC01', 'PT DWI MITRA ANDYOS PERKASA', '3 TAMAN BULASAKTI INDAH BLOK P1', '0005629878', 'BEKASI', '17125', '', '', '', '', '', '02.159.348.8.407.000', '', 14, '', '', '', '', '', '', 'V014', '2015-01-21'),
(829, '300863', 'EC01', 'PT ALIANSI SAKTI', 'Ruko Puri Mutiara Blok A/2', '0005840726', 'JAKARTA UTARA', '', '', '', '', '', '', '01.930.306.4.038.000', '', 14, '', '', '', '', '', '', 'V014', '2015-05-08'),
(830, '300864', 'EC01', 'PT V2 INDONESIA', 'Wisma Dharmala Sakti lt 5', '0005840732', 'JAKARTA PUSAT', '10220', '', '', '', '', '', '02.505.349.7.022.000', '', 14, '', '', '', '', '', '', 'V014', '2015-05-08'),
(831, '300865', 'EC01', 'ANDRI ELECTRONIC', '', '0005840952', '', '', '', '', '', '', '', '', '', 14, '', '', '', '', '', '', 'V014', '2015-05-08'),
(832, '300866', 'EC01', 'CV. WAHYU UTERO SINAR JAYA K', 'NO. 34 JL. BANTARAN I-B', '0005862152', 'KOTA MALANG', '', '', '0341-408408', '', '', '0341-417417', '02.498.784.4-652.000', '', 14, '', '', '', '', '', '', 'V014', '2015-05-18'),
(833, '300867', 'EC01', 'PT WADHE PUTERA NUSANTARA', '123 JL.SILIWANGI RT003/001', '0005866580', 'SUKASARI-BOGOR TIMUR', '16142', '', '', '', '', '', '02.635.891.1.404.001', '', 14, '', '', '', '', '', '', 'V014', '2015-05-21'),
(834, '300868', 'EC01', 'KPRI YUDHA BRAHMA', 'NO. 08 JL. MERDEKA', '0005874062', 'PALEMBANG', '30131', '', '0711-312011', '', '', '', '', '', 14, '', '', '', '', '', '', 'V014', '2015-05-25'),
(835, '300869', 'EC01', 'PT CHITEK INDOLIFT UTAMA', 'NO 56A JL PINANG RANTI 2', '0005874108', 'TAMAN MINI JAKARTA TIMUR', '13560', '', '021-29489059', '', '', '021-80877743', '030635346005000', '', 14, '', '', '', '', '', '', 'V014', '2015-05-25'),
(836, '300870', 'EC01', 'PT. SRIKANDHI NUSANTARA JAYA', 'No. 28 Jl. Pos Pengumben', '0005875173', 'JAKARTA BARAT', '11630', '', '29238290', '', '', '29238289', '03.169.592.7-086.000', 'conact@srikandhi.co.id', 14, '', '', '', '', '', '', 'V014', '2015-05-26'),
(837, '300871', 'EC01', 'PT LINDA HANTA WIJAYA', '263 JL.JEND SUDIRMAN RT002/001', '0005876894', 'KALIMANTAN TIMUR', '', '', '', '', '', '', '01.218.777.9.725.000', '', 14, '', '', '', '', '', '', 'V014', '2015-05-27'),
(838, '300872', 'EC01', 'PT AGRICON PUTRA CITRA OPTIMA', '68 JL.Siliwangi,Lawan Gintung', '0005877032', 'BOGOR', '', '', '', '', '', '', '02.268.831.1.431.000', '', 14, '', '', '', '', '', '', 'V014', '2015-05-27'),
(839, '300873', 'EC01', 'PT LUXINDO ARTHA PERKASA', 'NO 34 JL RAYA JEMBATAN III BLOK 35', '0005880164', 'JAKARTA', '14440', '', '021-662 5088', '', '', '021-668 5809', '018917708041000', 'info@luxindo.net', 14, '', '', '', '', '', '', 'V014', '2015-05-29'),
(840, '300874', 'EC01', 'ANDREAS TEGUH BINTORO', 'JL.KAMBOJA GG.BUDAYA RT007/002', '0005880857', 'JAKARTA TIMUR', '', '', '', '', '', '', '55.801.572.3.009.000', '', 14, '', '', '', '', '', '', 'V014', '2015-05-29'),
(841, '300875', 'EC01', 'RIOTEZA SATRIA RAMADHAN', 'JL.JAMBU RT004 RW005', '0005887158', 'BANTEN', '', '', '', '', '', '', '71.407.350.9.415.000', '', 14, '', '', '', '', '', '', 'V014', '2015-06-01'),
(842, '300876', 'EC01', 'CEMPAKA ESA ROSENDI', '17 JL.SAWO DALAM RT 006/010', '0005887174', 'JAKARTA TIMUR', '', '', '', '', '', '', '72.982.500.0.009.000', '', 14, '', '', '', '', '', '', 'V014', '2015-06-01'),
(843, '300877', 'EC01', 'PT BRAND MEDIA APAAJA', '38-39 STC SENAYAN LT 5', '0005887176', 'JAKARTA PUSAT', '10270', '', '', '', '', '', '03.156.872.8.077.000', '', 14, '', '', '', '', '', '', 'V014', '2015-06-01'),
(844, '300878', 'EC01', 'WIJAYA TEHNIK', 'NO 42 JL PANGERAN MANKUBUMI', '0005891510', '', '', '', '07217160922', '', '', '', '', '', 14, '', '', '', '', '', '', 'V014', '2015-06-03'),
(845, '300879', 'EC01', 'PT. AGHIST PROMOSINDO', 'No. 26 Jl. Tugu Wates RT. 001 RW. 0', '0005901403', 'BOGOR', '16164', '', '0251-8665364', '', '', '0251-8665365', '02.595.138.5.404.000', '', 14, '', '', '', '', '', '', 'V014', '2015-06-08'),
(846, '300880', 'EC01', 'PT TERA ACHIEVER', '16 JL.BUKIT GADING RAYA KOMPLEK PER', '0005902769', 'JAKARTA UTARA', '14240', '', '', '', '', '', '02.983.329.0.043.000', '', 14, '', '', '', '', '', '', 'V014', '2015-06-09'),
(847, '300881', 'EC01', 'FERRY', 'No. 23 Jl. Moch Kahfi Rt.10 Rw.06', '0005902952', 'JAKARTA SELATAN', '', '', '082125613564', '', '', '', '', '', 14, '', '', '', '', '', '', 'V014', '2015-06-09'),
(848, '300882', 'EC01', 'CV. VINSOFT (JGN DIPAKAI)', 'No. 36 Jl. Bahagia', '0005913515', 'MEDAN', '', '', '061 - 7357024', '', '', '', '31.451.558.6-122.000', 'din_calvin@yahoo.com', 14, '', '', '', '', '', '', 'V014', '2015-06-15'),
(849, '300883', 'EC01', 'inue@rt production', 'NO 52 JL MARGONDA RAYA', '0005913547', 'PONDOK CINA DEPOK', '', '', '021-93206800', '', '', '', '', 'inueart@gmail.com', 14, '', '', '', '', '', '', 'V014', '2015-06-15'),
(850, '300884', 'EC01', 'PT AUBADE MAKMUR', '21 JL.BUKIT GADING RAYA', '0005914250', 'JAKARTA UTARA', '', '', '', '', '', '', '03.198.677.1.043.000', '', 14, '', '', '', '', '', '', 'V014', '2015-06-15'),
(851, '300885', 'EC01', 'CORPORATE IMAGE AWARD', 'GADING BUKIT INDAH BLOK M15-16', '0005915042', 'JAKARTA UTARA', '14240', '', '', '', '', '', '', '', 14, '', '', '', '', '', '', 'V014', '2015-06-16'),
(852, '300886', 'EC01', 'PT HOKI BARU INDONESIA', 'NO 76 JL CINERE RAYA BLOK M', '0005915650', 'DEPOK', '16514', '', '021-7540351', '', '', '021-7533564', '316541101412000', '', 14, '', '', '', '', '', '', 'V014', '2015-06-16'),
(853, '300887', 'EC01', 'PT ENPRANA DUTA NUSA', '10 Sentra Industri terpadu PIK', '0005918721', 'JAKARTA UTARA', '', '', '', '', '', '', '', '', 14, '', '', '', '', '', '', 'V014', '2015-06-18'),
(854, '300888', 'EC01', 'PT TOTAL PRIMA SUKSES', '2 JL.CANDI PANGGUNG', '0005919685', 'MALANG', '', '', '', '', '', '', '02.570.674.8.652.000', '', 14, '', '', '', '', '', '', 'V014', '2015-06-19'),
(855, '300889', 'EC01', 'KOPERASI SURYA DAMARDHIKA', '', '0005919686', '', '', '', '', '', '', '', '', '', 14, '', '', '', '', '', '', 'V014', '2015-06-19'),
(856, '300890', 'EC01', 'IWAN SAPUTRA', '8 Jl.Kramat I Rt 009/001', '0005931139', 'JAKARTA SELATAN', '', '', '', '', '', '', '77.684.683.4.013.000', '', 14, '', '', '', '', '', '', 'V014', '2015-06-25'),
(857, '300891', 'EC01', 'ARTLINE COMMUNICATION', 'NO 9E JL PASAR MINGGU RAYA', '0005931605', 'JAKARTA SELATAN', '', '', '021-9119677', '', '', '021-7891833', '', 'info@artlineku.com', 14, '', '', '', '', '', '', 'V014', '2015-06-25'),
(858, '300892', 'EC01', 'PT. B P KEDAULATAN RAKYAT', 'NO. 40-46 JL. P. MANGKUBUMI', '0005941958', 'YOGYAKARTA', '', '', '0274 - 565683', '', '', '0274 - 589191', '011367307541000', '', 14, '', '', '', '', '', '', 'V014', '2015-06-30'),
(859, '300893', 'EC01', 'PT INDOMARCO PRISMATAMA', 'Jl.Terusan Angkasa Blok B2 Kav 1', '0005942106', 'JAKARTA PUSAT', '10610', '', '', '', '', '', '', '', 14, '', '', '', '', '', '', 'V014', '2015-06-30'),
(860, '300841', 'EC01', 'REZA BAJA PERKASA', 'No. 70 Jl. Srengseng Sawah', '0005781008', '', '', '', '085283774691', '', '', '', '', '', 14, '', '', '', '', '', '', 'V014', '2015-04-08'),
(861, '300842', 'EC01', 'PT GADING MURNI', 'NO. 40 JL JAKSA AGUNG SUPRAPTO BLOK', '0005783483', 'MALANG JAWA TIMUR', '', '', '0341-358348', '', '', '0341-333045', '011087434631000', 'gm_mlg@telkom.net', 14, '', '', '', '', '', '', 'V014', '2015-04-10'),
(862, '300843', 'EC01', 'PT BINTANG ASIA PROMOSINDO', '12 SETRAYASA RAYA', '0005792061', 'CIREBON', '', '', '', '', '', '', '31.789.477.2.426.000', '', 14, '', '', '', '', '', '', 'V014', '2015-04-13'),
(863, '300844', 'EC01', 'SABEENA COMPUTER', 'JL MANGGA DUA RAYA', '0005792785', 'JAKARTA PUSAT', '10730', '', '021-62304651', '', '', '021-62304653', '', '', 14, '', '', '', '', '', '', 'V014', '2015-04-13'),
(864, '300845', 'EC01', 'Enterprise Advanced System Intellig', '623 Aljunied Road #07-01', '0005793814', '', '389835', '', '(65) 65474401', '', '', '(65) 67480625', '', '', 14, '', '', '', '', '', '', 'V014', '2015-04-14'),
(865, '300846', 'EC01', 'PT. MALANG POS CEMERLANG', 'NO. 1 JL. SRIWIJAYA', '0005795466', 'MALANG', '65119', '', '', '', '', '', '018407510651000', '', 14, '', '', '', '', '', '', 'V014', '2015-04-15'),
(866, '300847', 'EC01', 'UD WICOM UTAMA', '14 Jl.Tumpang sari', '0005797198', '', '', '', '', '', '', '', '08.413.477.4.914.000', '', 14, '', '', '', '', '', '', 'V014', '2015-04-16'),
(867, '300852', 'EC01', 'PT. INNOVATE CONSULTING', '', '0005798015', '', '', '', '087783075199', '', '', '', '', '', 14, '', '', '', '', '', '', 'V014', '2015-04-17'),
(868, '300853', 'EC01', 'DUTA RENTAL', '3 Jl.DR Saharjo ,Bedeng', '0005805789', 'JAKARTA SELATAN', '', '', '', '', '', '', '', '', 14, '', '', '', '', '', '', 'V014', '2015-04-20'),
(869, '300854', 'EC01', 'PT SEKAWAN CHANDRA ABADI', 'Komplek pertokoan sumur Bandung', '0005807543', 'METRO PUSAT', '', '', '', '', '', '', '01.954.838.7.321.000', '', 14, '', '', '', '', '', '', 'V014', '2015-04-21'),
(870, '300855', 'EC01', 'CV. JAYA CIPTA', 'No. II F Jl. Tanah Abang I', '0005819447', 'JAKARTA PUSAT', '', '', '', '', '', '', '03.293.748.4-028.000', '', 14, '', '', '', '', '', '', 'V014', '2015-04-27'),
(871, '300856', 'EC01', 'PT GITA SWARA LESTARI', '', '0005820085', 'CIREBON', '', '', '', '', '', '', '', '', 14, '', '', '', '', '', '', 'V014', '2015-04-27'),
(872, '300857', 'EC01', 'PERHIMPUNAN PENGHUNI MALL MATOS', '2 JL.VETERAN', '0005834604', '', '65113', '', '', '', '', '', '02.570.484.2.623.000', '', 14, '', '', '', '', '', '', 'V014', '2015-05-04'),
(873, '300858', 'EC01', 'HENNY FETRONIKA', '1A Jl.Komp Yos Sudarso', '0005836177', 'PONTIANAK', '', '', '', '', '', '', '', '', 14, '', '', '', '', '', '', 'V014', '2015-05-05'),
(874, '300859', 'EC01', 'PT INTISAR SOLUZINDO', '103 Jl Pemuda', '0005836802', 'JAKARTA TIMUR', '', '', '', '', '', '', '02.245.563.8.007.000', '', 14, '', '', '', '', '', '', 'V014', '2015-05-05'),
(875, '300860', 'EC01', 'CV. DEWATA KOMPUTER', 'Blok A-53 Kompleks Sudirman Agung', '0005837127', 'BALI', '', '', '(0361) 244997', '', '', '(0361) 255180', '02.017.839.8-904.000', 'info@dewatakomputer.com', 14, '', '', '', '', '', '', 'V014', '2015-05-06'),
(876, '300861', 'EC01', 'WIJAYA TEHNIK', 'NO 8 JL PRAMBANAN BLOK 48', '0005837557', 'BANDAR LAMPUNG', '', '', '085269360677', '', '', '', '16.055.204.832.2.000', '', 14, '', '', '', '', '', '', 'V014', '2015-05-06'),
(877, '300862', 'EC01', 'PT. INDIGLO INTI MANDIRI', 'No. 4/A Jl. Talaud Kel. Cideng, Kec', '0005837723', 'JAKARTA PUSAT', '', '', '63863708', '', '', '', '31.253.465.4.028.000', '', 14, '', '', '', '', '', '', 'V014', '2015-05-06'),
(878, '300916', 'EC01', 'PT NOORINDO SAPTA', 'NO 16 JL. A. YANI RT.08', '0006038160', '', '76122', '', '081320779818', '', '', '0542422783', '', '', 14, '', '', '', '', '', '', 'V014', '2015-08-10'),
(879, '300917', 'EC01', 'PT ASTRA INTERNATIONAL Tbk - TOYOTA', 'KAV 3 JL JENDRAL SUDIRMAN', '0006038460', '', '10220', '', '021-5703325', '', '', '021-5737027', '013025846092000', '', 14, '', '', '', '', '', '', 'V014', '2015-08-10'),
(880, '300918', 'EC01', 'PT KREASINDO CITRA NUSANTARA', 'BLOK F1 NO 3 & 5', '0006043072', 'JAKARTA', '11620', '', '021-58901470', '', '', '021-30067824', '021251061086000', 'marketing.kcn@cbn.net.id', 14, '', '', '', '', '', '', 'V014', '2015-08-13'),
(881, '300922', 'EC01', 'M.ZULFIKAR', '13M jl.Gaperta GG Kencana LK III', '0006056288', 'MEDAN', '', '', '', '', '', '', '', '', 14, '', '', '', '', '', '', 'V014', '2015-08-18'),
(882, '300923', 'EC01', 'DENNY FEBRITA', '28 Jl.Bkatamso Gg Budiman', '0006057286', 'MEDAN', '', '', '', '', '', '', '', '', 14, '', '', '', '', '', '', 'V014', '2015-08-18'),
(883, '300924', 'EC01', 'ASOSIASI E-COMMERCE INDONESIA (idEA', '15F One Pasific Place', '0006059826', 'JAKARTA', '12190', '', '', '', '', '', '', '', 14, '', '', '', '', '', '', 'V014', '2015-08-20'),
(884, '300927', 'EC01', 'PT GEMILANG BERLIAN INDAH', 'Jl.A.Yani II KM 1.2', '0006070540', 'PONTIANAK', '78391', '', '', '', '', '', '01.667.255.2.701.000', '', 14, '', '', '', '', '', '', 'V014', '2015-08-24'),
(885, '300928', 'EC01', 'SITI FIQIH FAUZIAH', '3 Dusun VII Jl.Binjai KM 10', '0006070579', 'SUMATERA UTARA', '', '', '', '', '', '', '', '', 14, '', '', '', '', '', '', 'V014', '2015-08-24'),
(886, '300929', 'EC01', 'PANITIA SERVICE QUALITY', '10-11 Artha Gading Niaga Blok A', '0006072597', 'JAKARTA UTARA', '14240', '', '', '', '', '', '', '', 14, '', '', '', '', '', '', 'V014', '2015-08-26'),
(887, '300930', 'EC01', 'SHAYNA ZUHRIYAH', 'Kp.Rawa Aren Rt002/024', '0006072928', 'BEKASI', '', '', '', '', '', '', '', '', 14, '', '', '', '', '', '', 'V014', '2015-08-26'),
(888, '300931', 'EC01', 'CAECILIA DITHA RAHMANI', '19 Jl.Cisitu Indah VI', '0006072933', 'BANDUNG', '', '', '', '', '', '', '25.224.457.9.423.000', '', 14, '', '', '', '', '', '', 'V014', '2015-08-26'),
(889, '300932', 'EC01', 'DERI PERMANA', 'Jl.Kembang XI Rt005/002', '0006075338', 'JAKARTA PUSAT', '', '', '', '', '', '', '07.614.479.9-023.000', '', 14, '', '', '', '', '', '', 'V014', '2015-08-28'),
(890, '300933', 'EC01', 'BASTIAN LAUWIS', 'Kp.Cibarengkok Rt008/003', '0006075387', 'BOGOR', '', '', '', '', '', '', '06.647.037.8.403.001', '', 14, '', '', '', '', '', '', 'V014', '2015-08-28'),
(891, '300934', 'EC01', 'PT. CIPTA INTI STRATEGI', 'No. 39A GD. ILP CENTER', '0006075868', 'JAKARTA SELATAN', '', '', '7983553', '', '', '7983553', '71.726.438.6-061.000', '', 14, '', '', '', '', '', '', 'V014', '2015-08-28'),
(892, '300935', 'EC01', 'de print', '38 BE Jl.Mangga besar Raya', '0006084026', 'INDONESIA', '11180', '', '', '', '', '', '', '', 14, '', '', '', '', '', '', 'V014', '2015-08-31'),
(893, '300936', 'EC01', 'PT PURIMAS ELOK ASRI', 'Jl.POM IX Palembang Icon', '0006085215', 'PALEMBANG', '', '', '', '', '', '', '', '', 14, '', '', '', '', '', '', 'V014', '2015-09-01'),
(894, '300937', 'EC01', 'TERANG BARU', 'NO 9A JL PANCA USAHA', '0006085430', 'CAKRANEGARA MATARAM LOMBO', '', '', '0370-6172430', '', '', '', '', '', 14, '', '', '', '', '', '', 'V014', '2015-09-01'),
(895, '300938', 'EC01', 'PT. COMUNIKASI SELARAS MANDIRI', 'Blok E2/26 Komp. Roxy Mas', '0006090040', 'JAKARTA PUSAT', '10150', '', '6303803', '', '', '6326554', '02.040.614.6-028.000', '', 14, '', '', '', '', '', '', 'V014', '2015-09-04'),
(896, '300939', 'EC01', 'CV GLOBAL CHEMINDO', '17 Jl.Mayjen Sutoyo', '0006097247', 'JAKARTA TIMUR', '', '', '021-96559493', '', '', '', '', '', 14, '', '', '', '', '', '', 'V014', '2015-09-07'),
(897, '300940', 'EC01', 'BADAN PENANGGULANGAN BENCANA DAERAH', 'NO. 2 JL.KAPTEN TENDEAN', '0006099090', 'BANDAR LAMPUNG', '35116', '', '0721 252741', '', '', '', '', 'blp@yahoo.co.id', 14, '', '', '', '', '', '', 'V014', '2015-09-08'),
(898, '300941', 'EC01', 'CV. WAHANA JAYA', 'NO. 70 JL. SADANG', '0006100289', 'MARGAHAYU TENGAH', '40225', '', '022 5422048', '', '', '', '021615976445000', 'yudha_setia113@yahoo.com', 14, '', '', '', '', '', '', 'V014', '2015-09-09'),
(899, '300942', 'EC01', 'CV. SETIYA BIRU', 'NO.15 JL.CENDANA', '0006101914', 'BOYOLALI', '', '', '08121507428', '', '', '', '', 'yudha_setia113@yahoo.com', 14, '', '', '', '', '', '', 'V014', '2015-09-10'),
(900, '300943', 'EC01', 'PT LUNTO PRIMA MEGAH', '5 GD.MENARA ERA LT 3', '0006103411', 'JAKARTA PUSAT', '', '', '', '', '', '', '01.590.739.7.023.000', '', 14, '', '', '', '', '', '', 'V014', '2015-09-11'),
(901, '300944', 'EC01', 'PT KHARISMA JINGGA KREASI', 'Gedung Tempo Scan Tower lt 32', '0006103531', 'JAKARTA SELATAN', '', '', '', '', '', '', '03.287.322.6.063.000', '', 14, '', '', '', '', '', '', 'V014', '2015-09-11'),
(902, '300945', 'EC01', 'UD. SINAR JAYA ABADI', 'JL.KALIMUTU XX, PEMECUTAN KELOD', '0006110644', 'DENPASAR', '', '', '081237110663', '', '', '', '472332014901000', 'sinarjayaabadibali@gmail.com', 14, '', '', '', '', '', '', 'V014', '2015-09-14'),
(903, '300946', 'EC01', 'CV. TRI KARYA UTAMA', 'NO. 33 JL. KH MANSYUR IV', '0006111483', '', '', '', '0370 648 673', '', '', '', '019453372911000', '', 14, '', '', '', '', '', '', 'V014', '2015-09-15'),
(904, '300947', 'EC01', 'PT. MITRA SARANATAMA SEJAHTERA', 'LOT.#5 JL. DR IDE ANAK AGUNG GDE AG', '0006111647', 'JAKARTA SELATAN', '12950', '', '02178835722', '', '', '', '019681758063000', '', 14, '', '', '', '', '', '', 'V014', '2015-09-15'),
(905, '300948', 'EC01', 'ORBIT ENTERTAINMENT', '', '0006112996', '', '', '', '', '', '', '', '', '', 14, '', '', '', '', '', '', 'V014', '2015-09-16'),
(906, '300949', 'EC01', 'ISTANA KACA', 'NO. 18 JL.RAYA BEKASI KM.17', '0006138792', 'JAKARTA TIMUR', '13250', '', '0214897358-02...', '', '', '0214759952', '', 'helenhermanto@yahoo.com', 14, '', '', '', '', '', '', 'V014', '2015-09-29'),
(907, '300950', 'EC01', 'SURYA TIRTA ENGINEERING', 'NO. 1 JL. LABU', '0006138850', 'JAKARTA BARAT', '', '', '02162309498', '', '', '', '', '', 14, '', '', '', '', '', '', 'V014', '2015-09-29'),
(908, '300897', 'EC01', 'PT METRA DIGITAL MEDIA', '77-81 Jl.RS Fatmawati', '0005959111', 'JAKARTA SELATAN', '12150', '', '', '', '', '', '03.284.216.3.019.000', '', 14, '', '', '', '', '', '', 'V014', '2015-07-08'),
(909, '300898', 'EC01', 'PT TEJA BERLIAN', '144 Jl.Kalijaga', '0005960837', 'CIREBON', '', '', '', '', '', '', '01.457.735.7.426.000', '', 14, '', '', '', '', '', '', 'V014', '2015-07-09'),
(910, '300899', 'EC01', 'CV. METKA AMISHA PRIMA', 'Jl. Murai 1 Bulakbuni Rt.04/03', '0005961099', 'SAWAH CIPUTAT TANGERANG B', '', '', '021-7493339', '', '', '', '', '', 14, '', '', '', '', '', '', 'V014', '2015-07-09'),
(911, '300900', 'EC01', 'X RAY FILM', 'No. 15 A Jl. Tebet Timur', '0005977232', 'JAKARTA SELATAN', '', '', '', '', '', '', '', 'rayfilm.production@gmail.com', 14, '', '', '', '', '', '', 'V014', '2015-07-15'),
(912, '300901', 'EC01', 'HENNY', '1A Jl.Komyos Sudarso', '0006000300', 'PONTIANAK', '', '', '', '', '', '', '', '', 14, '', '', '', '', '', '', 'V014', '2015-07-24'),
(913, '300902', 'EC01', 'IKA NOVALIYANTI', 'Pengasinan Rt 004 Rw 001', '0006000305', 'BEKASI', '', '', '', '', '', '', '77.655.888.4.432.000', '', 14, '', '', '', '', '', '', 'V014', '2015-07-24'),
(914, '300903', 'EC01', 'CV SERVICE MAXIMUM', '3 Puri cilegon Blok A2', '0006000319', 'BANTEN', '', '', '', '', '', '', '', '', 14, '', '', '', '', '', '', 'V014', '2015-07-24'),
(915, '300904', 'EC01', 'IZZI SOUND & MUSIC', '80 Jl.Arsento', '0006000320', 'JAKARTA SELATAN', '15412', '', '', '', '', '', '', '', 14, '', '', '', '', '', '', 'V014', '2015-07-24'),
(916, '300905', 'EC01', 'DIAN FITRIANI', '21 Jl.Al Muhajirin Rt004 Rw 010', '0006000333', 'BANTEN', '', '', '', '', '', '', '64.128.981.4.416.000', '', 14, '', '', '', '', '', '', 'V014', '2015-07-24'),
(917, '300906', 'EC01', 'PT. META DWIGUNA TRANSCORP', 'NO 502 JL BUNCIT RAYA', '0006012191', 'JAKARTA SELATAN', '', '', '021-79160019', '', '', '021-79120738', '021428420016000', '', 14, '', '', '', '', '', '', 'V014', '2015-07-28'),
(918, '300907', 'EC01', 'THE Y PRODUCTION', '', '0006012476', '', '', '', '', '', '', '', '', '', 14, '', '', '', '', '', '', 'V014', '2015-07-28'),
(919, '300908', 'EC01', 'PT HAWA MAS', 'NO 19 JL.SM.RAJA XII KM.11 TAMAN RI', '0006013424', 'MEDAN AMPLAS - MEDAN', '20149', '', '6261-7947062', '', '', '6261-80023343', '314124066122000', 'admin@hawamas.com', 14, '', '', '', '', '', '', 'V014', '2015-07-29'),
(920, '300909', 'EC01', 'CV BARUNA INDONUSA', 'NO 14 KOMPLEKS PERMATA HIJAU BLOK D', '0006013552', 'BATU AJI - BATAM', '', '', '0778391777', '', '', '0778392827', '', 'sales@barunaindonusa.com', 14, '', '', '', '', '', '', 'V014', '2015-07-29'),
(921, '300910', 'EC01', 'PD SINAR KRAKATAU', 'NO 1 JL.RE MARTADINATA KOMP RUKO BL', '0006013895', 'PONTIANAK', '', '', '0561 770395', '', '', '0561770396', '', '', 14, '', '', '', '', '', '', 'V014', '2015-07-29'),
(922, '300911', 'EC01', 'PT MEKA ADIPRATAMA', '7-13 Jl.Puspowarno tengah', '0006015365', 'SEMARANG', '', '', '', '', '', '', '01.594.771.6.511.000', '', 14, '', '', '', '', '', '', 'V014', '2015-07-30'),
(923, '300912', 'EC01', 'NI MADE RUSTIANI', '14 Jl.Tumpang Sari', '0006017169', 'CAKRANEGARA', '', '', '', '', '', '', '08.413.477.4.914.000', '', 14, '', '', '', '', '', '', 'V014', '2015-07-31'),
(924, '300913', 'EC01', 'CV MAHAKARYA WIJAYA', '45 Jl.Kayu tinggi', '0006017795', 'JAKARTA TIMUR', '', '', '', '', '', '', '03.172.113.7.006.000', '', 14, '', '', '', '', '', '', 'V014', '2015-07-31'),
(925, '300914', 'EC01', 'PT NADI DIGITAL INDONESIA', '7 Business park Kebon jeruk Blok I', '0006025506', 'JAKARTA BARAT', '', '', '', '', '', '', '31.808.050.4.086.000', '', 14, '', '', '', '', '', '', 'V014', '2015-08-03'),
(926, '300915', 'EC01', 'FENTY KURNIASARI RETNONINGSIH', 'Josutan Rt 003/002', '0006030317', 'JAWA TENGAH', '', '', '', '', '', '', '24.960.598.1.532.000', '', 14, '', '', '', '', '', '', 'V014', '2015-08-06'),
(927, '300972', 'EC01', 'MOMON JOENG', 'TAMAN ALFA INDAH H 4/13 002/007', '0006222913', 'JAKARTA SELATAN', '', '', '', '', '', '', '', '', 14, '', '', '', '', '', '', 'V014', '2015-11-05'),
(928, '300973', 'EC01', 'MOMON JOENG', 'TAMAN ALFA INDAH H  4/13 002 / 007', '0006222928', 'JAKARTA SELATAN', '', '', '', '', '', '', '', '', 14, '', '', '', '', '', '', 'V014', '2015-11-05'),
(929, '300974', 'EC01', 'PT MARKPLUS INDONESIA', 'EIGHTYEIGHT@KASABLANKA LT 8', '0006233660', 'JAKARTA SELATAN', '', '', '021-57902338', '', '', '021-57951109', '02.286.493.8.062.000', 'marketeers@markplusc.com', 14, '', '', '', '', '', '', 'V014', '2015-11-09'),
(930, '300977', 'EC01', 'CV. JUMADI INTI TEKNIK', 'NO. 32 JL. PANGLIMA POLIM RT.007/RW', '0006249117', 'TANGERANG', '', '', '021-51148006', '', '', '', '', '', 14, '', '', '', '', '', '', 'V014', '2015-11-16'),
(931, '300978', 'EC01', 'ARTON BALLOON', 'NO. 8 TAMAN PONDOK CABE BLOK A-5', '0006249507', 'PONDOK CABE UDIK PAMULANG', '15418', '', '021-7429325', '', '', '021-7429325', '09.667.169.8-036.000', 'artonballoon1@yahoo.co.id', 14, '', '', '', '', '', '', 'V014', '2015-11-16'),
(932, '300979', 'EC01', 'TIRTA AGUNG BAN', 'NO. 16 JL. RAYA PASAR MINGGU', '0006251017', 'JAKARTA SELATAN', '', '', '0217902624', '', '', '0217902624', '', '', 14, '', '', '', '', '', '', 'V014', '2015-11-17'),
(933, '300980', 'EC01', 'AFAN GUNAWAN', '42 UTAN JAYA', '0006254671', 'DEPOK', '', '', '', '', '', '', '', '', 14, '', '', '', '', '', '', 'V014', '2015-11-19'),
(934, '300981', 'EC01', 'PT. METRO ASIA PASIFIK', 'LOT.#5.1 JL. DR. IDE ANAK AGUNG GDE', '0006255741', 'SETIABUDI - JAKSEL', '12950', '', '', '', '', '', '03.301.736.9-063.000', '', 14, '', '', '', '', '', '', 'V014', '2015-11-20'),
(935, '300982', 'EC01', 'PT. GALA JAYA MANDIRI', 'NO. 15-17 JL.NUSA INDAH BARU', '0006270690', 'PONTIANAK BARAT', '78117', '', '0561740407', '', '', '', '017819269701000', '', 14, '', '', '', '', '', '', 'V014', '2015-11-26'),
(936, '300983', 'EC01', 'MAJU JAYA SCALE', 'NO. 9 LTC GLODOK Lt. UG BLOK C-7', '0006272523', 'JAKARTA PUSAT', '', '', '02126071568', '', '', '', '', 'marketing.timbangan@gmail.com', 14, '', '', '', '', '', '', 'V014', '2015-11-27'),
(937, '300984', 'EC01', 'AVADRIANTI SIGRA UTAMI', '16 Jl.Mekar Baru 1', '0006283165', 'TANGERANG SELATAN', '', '', '', '', '', '', '66.609.108.7.411.000', '', 14, '', '', '', '', '', '', 'V014', '2015-11-30'),
(938, '300985', 'EC01', 'PANCA SUNU SETYAJI', 'Jl.Tanah Merdeka', '0006283168', 'JAKARTA TIMUR', '', '', '', '', '', '', '', '', 14, '', '', '', '', '', '', 'V014', '2015-11-30'),
(939, '300986', 'EC01', 'Muhammad Saud', 'Jl.Kayu manis VI', '0006283169', 'JAKARTA TIMUR', '', '', '', '', '', '', '', '', 14, '', '', '', '', '', '', 'V014', '2015-11-30'),
(940, '300987', 'EC01', 'HENDRIYANTO HARIS SPUTRA', '12 Jl.Ikan Mas', '0006287124', 'BOGOR', '', '', '', '', '', '', '', '', 14, '', '', '', '', '', '', 'V014', '2015-12-02'),
(941, '300988', 'EC01', 'PT MAFATI INOVASI TECHNOLOGY', '10A-10F Terbang Layang golf', '0006288175', 'PONDOK CABE UDIK', '', '', '', '', '', '', '31.200.613.3.411.000', '', 14, '', '', '', '', '', '', 'V014', '2015-12-02'),
(942, '300989', 'EC01', 'CREATIVE PRO', '601 Jl. Gajayana gg V', '0006291506', 'MALANG', '', '', '', '', '', '', '', '', 14, '', '', '', '', '', '', 'V014', '2015-12-04'),
(943, '300990', 'EC01', 'PT INDRAPRASTA MULIA TEKNIK', 'No. 100 Kp. Babakan Rawahaur', '0006303077', 'JAWA BARAT', '', '', '', '', '', '', '66.527.063.3-403.000', '', 14, '', '', '', '', '', '', 'V014', '2015-12-08'),
(944, '300991', 'EC01', 'CV SUKSES PERKASA', '7 Jl.Kompl Balikpapan Regency Blom', '0006320584', 'KALIMANTAN TIMUR', '76115', '', '', '', '', '', '03.099.898.3.721.000', '', 14, '', '', '', '', '', '', 'V014', '2015-12-14'),
(945, '300992', 'EC01', 'PT. EVAYUNDA TERANG', 'NO. 55 KAMPUNG KERONCONG', '0006324475', 'KERONCONG KEC JATIUWUNG', '', '', '08158817222', '', '', '', '013547054402000', '', 14, '', '', '', '', '', '', 'V014', '2015-12-16'),
(946, '300993', 'EC01', 'PT. ANDALAN INTI REKATAMA', 'NO. 42 B JL. RADIO DALAM RAYA', '0006328921', 'JAKARTA SELATAN', '', '', '0217399809', '', '', '', '025793704019000', 'ptair@centrin.net.id', 14, '', '', '', '', '', '', 'V014', '2015-12-18'),
(947, '300994', 'EC01', 'MURTI AGUSTUTI', 'Mutihan RT 002/012', '0006366491', 'SURAKARTA', '', '', '', '', '', '', '77.826.074.5.526.000', '', 14, '', '', '', '', '', '', 'V014', '2015-12-28'),
(948, '300995', 'EC01', 'TIMBO SIAHAAN & ASSOCIATES', 'Perkantoran keb.Baru mall lt 3', '0006367958', 'JAKARTA SELATAN', '', '', '', '', '', '', '21.146.898.8.064.000', '', 14, '', '', '', '', '', '', 'V014', '2015-12-28'),
(949, '300996', 'EC01', 'PT. NETSOLUTION', 'NO. 27 GD. SAGUNG SETO JL. PRAMUKA', '0006370420', 'KEL. UTAN KAYU UTARA KEC.', '13120', '', '', '', '', '', '02.995.009.4-003.000', '', 14, '', '', '', '', '', '', 'V014', '2015-12-29'),
(950, '300997', 'EC01', 'PT PENDOPO NIAGA', '01-01 2121 BOULEVARD GAJAH MADA', '0006373836', '', '', '', '', '', '', '', '01.892.046.2.402.000', '', 14, '', '', '', '', '', '', 'V014', '2015-12-30'),
(951, '300998', 'EC01', 'CV LIJID INTIGLASS ART', '43 Jl.Mayjen Sutoyo', '0006373861', 'KALIMANTAN TIMUR', '76122', '', '', '', '', '', '', '', 14, '', '', '', '', '', '', 'V014', '2015-12-30'),
(952, '300999', 'EC01', 'PT ATLAS TRANSINDO RAYA', '22 Jl.Daan Mogot KM 10', '0006393374', 'JAKARTA BARAT', '', '', '', '', '', '', '01.886.781.2.034.000', '', 14, '', '', '', '', '', '', 'V014', '2016-01-04'),
(953, '301000', 'EC01', 'PT RADIO ATTAHIRIYAH', 'LT P7 GEDUNG MENARA IMPERIUM', '0006399704', 'JAKARTA SELATAN', '', '', '', '', '', '', '01.342.062.5.062.000', '', 14, '', '', '', '', '', '', 'V014', '2016-01-07'),
(954, '301001', 'EC01', 'ATI MULYATI', '8 Jl.Siaga Baru III', '0006400393', 'JAKARTA SELATAN', '', '', '', '', '', '', '07.175.660.5.017.000', '', 14, '', '', '', '', '', '', 'V014', '2016-01-07'),
(955, '301002', 'EC01', 'PT AMARA PAMERAN INTERNASIONAL', '2 Jl.Suryopranoto', '0006400885', 'JAKARTA PUSAT', '', '', '', '', '', '', '02.952.262.0.029.000', '', 14, '', '', '', '', '', '', 'V014', '2016-01-07'),
(956, '300951', 'EC01', 'IZZY SOUND & MUSIC', '80 Jl.Arsento', '0006139168', 'JAKARTA SELATAN', '15412', '', '', '', '', '', '', '', 14, '', '', '', '', '', '', 'V014', '2015-09-29'),
(957, '300952', 'EC01', 'JATAKE CENTRAL BATTERY', 'JL. GATOT SUBROTO KM.8', '0006140772', 'TANGERANG', '', '', '02198867214', '', '', '', '', '', 14, '', '', '', '', '', '', 'V014', '2015-09-30'),
(958, '300953', 'EC01', 'UD. BAYU ROZYKARA', 'JL. RAYA PONOROGO', '0006142190', '', '', '', '081359522359', '', '', '', '', '', 14, '', '', '', '', '', '', 'V014', '2015-10-01'),
(959, '300954', 'EC01', 'CV HJR PROMOSINDO', 'NO. 125 JL. SWADAYA IV RT. 005 RW.', '0006143195', 'BEKASI', '', '', '021-86907949', '', '', '021-8656522', '72.966.325.2-432.000', 'samsuarjal@yahoo.com', 14, '', '', '', '', '', '', 'V014', '2015-10-02'),
(960, '300955', 'EC01', 'PERSEK KJPP SUWENDHO RINALDY & REKA', '01-02 Rasuna Office Park', '0006151023', 'JAKARTA SELATAN', '', '', '', '', '', '', '02.993.025.2.018.000', '', 14, '', '', '', '', '', '', 'V014', '2015-10-05'),
(961, '300956', 'EC01', 'FAHRUM NISA', '17 Jl.B Katamso GG Sosial', '0006151255', 'MEDAN', '', '', '', '', '', '', '', '', 14, '', '', '', '', '', '', 'V014', '2015-10-05'),
(962, '300957', 'EC01', 'ARDIAN SYAH PUTRA', 'Dusun III Desa MArindal II', '0006151260', 'DELI SERDANG', '', '', '', '', '', '', '', '', 14, '', '', '', '', '', '', 'V014', '2015-10-05'),
(963, '300958', 'EC01', 'TOTO TRI WIBOWO', 'Jl.Pelita VI', '0006151274', 'MEDAN PERJUANGAN', '', '', '', '', '', '', '', '', 14, '', '', '', '', '', '', 'V014', '2015-10-05'),
(964, '300959', 'EC01', 'RIZKI NOVIKASARI', 'Dusun Kembangan II Rt 015/007', '0006151693', 'JAWA TENGAH', '', '', '', '', '', '', '45.196.522.2.524.000', '', 14, '', '', '', '', '', '', 'V014', '2015-10-06'),
(965, '300960', 'EC01', 'GANANG TRI SUTARYO', 'Kp Wadassari', '0006151694', 'TANGERANG', '', '', '', '', '', '', '59.504.670.7.411.000', '', 14, '', '', '', '', '', '', 'V014', '2015-10-06'),
(966, '300961', 'EC01', 'PT. DUTA DISTRIBUSI SERVISINDO', 'No. 766 B Jl. Rawa Kepa Utama', '0006153583', 'JAKARTA BARAT', '11440', '', '5605757', '', '', '5607575', '31.325.943.4-036.000', 'sales@dutaservisindo.co.id', 14, '', '', '', '', '', '', 'V014', '2015-10-07'),
(967, '300962', 'EC01', 'ISTANA KACA PULO GEBANG', 'NO. 1 JL. RAYA PULO GEBANG', '0006185335', 'JAKARTA TIMUR', '13950', '', '21-68801344', '', '', '', '', '', 14, '', '', '', '', '', '', 'V014', '2015-10-22'),
(968, '300963', 'EC01', 'JAMALUDIN BADIAR', 'NO. 2 JL.PAHLAWAN II BLOK G.25 TAMB', '0006185764', '', '', '', '085283696124', '', '', '', '', 'rintobadiar@rocketmail.com', 14, '', '', '', '', '', '', 'V014', '2015-10-22'),
(969, '300964', 'EC01', 'PT BOSOWA BERLIAN MOTOR', '266 Jl.Urip Sumoharjo', '0006187730', 'MAKASSAR', '', '', '', '', '', '', '01.125.541.1-812.000', '', 14, '', '', '', '', '', '', 'V014', '2015-10-23'),
(970, '300965', 'EC01', 'ACCESSORIES COMPUTER', 'NO. 29 RUKO MEGA LEGENDA B2', '0006197718', 'BATAM - KEPULAUAN RIAU', '29463', '', '0778-459042', '', '', '', '', '', 14, '', '', '', '', '', '', 'V014', '2015-10-26'),
(971, '300966', 'EC01', 'NOERYADI', '109 Kebon Pala', '0006197862', 'CIMAHI TENGAH', '', '', '', '', '', '', '', '', 14, '', '', '', '', '', '', 'V014', '2015-10-26'),
(972, '300967', 'EC01', 'MERTIYANI SRIWANTI S.Sn', '68/210C Gg.H Sirad', '0006197877', 'BANDUNG', '', '', '', '', '', '', '', '', 14, '', '', '', '', '', '', 'V014', '2015-10-26'),
(973, '300968', 'EC01', 'TONO', '', '0006198187', '', '', '', '087889464675', '', '', '', '', '', 14, '', '', '', '', '', '', 'V014', '2015-10-26'),
(974, '300969', 'EC01', 'CV AUTORISET 2000', 'NO.72 JL.SELAPARANG', '0006199738', 'MATARAM', '', '', '0370636499', '', '', '', '019450196914000', '', 14, '', '', '', '', '', '', 'V014', '2015-10-27'),
(975, '300970', 'EC01', 'PT. SRIKANDHI NUSANTARA JAYA', 'NO. 28 JL. POS PENGUMBEN RT.010 / 0', '0006202251', 'JAKARTA BARAT', '11630', '', '02129238290', '', '', '', '031695927086000', 'srikandhi_nusantara_jaya@yahoo.com', 14, '', '', '', '', '', '', 'V014', '2015-10-28'),
(976, '301028', 'EC01', 'PT NUSANTARA CARD SEMESTA', '7 Jl.Brigjen Katamso', '0006469363', 'JAKARTA BARAT', '', '', '02129238290', '', '', '', '01.680.286.0-038.000', 'contact@srikandhi.co.id', 14, '', '', '', '', '', '', 'V014', '2016-02-05'),
(977, '301029', 'EC01', 'PT. METRO SENTRAL GRAPHIA', 'No. 70/70A Jl. Keamanan', '0006480853', 'JAKARTA BARAT', '', '', '6342228', '', '', '', '02.189.522.2-037.000', '', 14, '', '', '', '', '', '', 'V014', '2016-02-09'),
(978, '301030', 'EC01', 'PT. ACCESS MICRO SISTEM', 'No. 14 GD. CENTRALMAS PACIFIC', '0006484721', 'JAKARTA BARAT', '11480', '', '5349380', '', '', '', '03.093.707.2-031.000', '', 14, '', '', '', '', '', '', 'V014', '2016-02-11'),
(979, '301031', 'EC01', 'PT. MEDIATAMA MANDIRI', 'No. 31 S JL. KH. ZAINUL ARIFIN', '0006493448', 'JAKARTA PUSAT', '10130', '', '22520648', '', '', '', '02.191.042.7.029.000', 'marvindo36@yahoo.com', 14, '', '', '', '', '', '', 'V014', '2016-02-15'),
(980, '301032', 'EC01', 'PT INDONESIA MEDIA EXCHANGE', 'Lt 22 menara selatan gedung menara', '0006512085', 'JAKARTA SELATAN', '', '', '', '', '', '', '02.004.652.0-038.000', '', 14, '', '', '', '', '', '', 'V014', '2016-02-23'),
(981, '301033', 'EC01', 'SAHABAT TEKNIK', 'Landungsari 10/24', '0006513662', 'PEKALONGAN', '', '', '085868822332', '', '', '', '', '', 14, '', '', '', '', '', '', 'V014', '2016-02-24'),
(982, '301034', 'EC01', 'PT. TRINAYA TIRTA', 'Blok E Grand Wijaya Center', '0006517100', 'JAKARTA SELATAN', '', '', '72793001', '', '', '72793118', '02.593.520.6-019.000', '', 14, '', '', '', '', '', '', 'V014', '2016-02-26'),
(983, '301037', 'EC01', 'GEN\'S COLLECTION', 'NO.88 JL.PABUARAN RAYA', '0006527711', 'DEPOK', '', '', '08129069332', '', '', '', '', 'komarapandi@rocketmail.com', 14, '', '', '', '', '', '', 'V014', '2016-02-29'),
(984, '301038', 'EC01', 'PT MAJU MOBILINDO', 'NO 81-85 JL DANAU SUNTER UTARA BLOK', '0006531776', 'JAKARTA UTARA', '14350', '', '021-6518000', '', '', '021-6516000', '', 'sinata_frans@yahoo.com', 14, '', '', '', '', '', '', 'V014', '2016-03-02'),
(985, '301039', 'EC01', 'PT LINTAS DATA PRIMA', '1 Darmo Residence', '0006533261', 'BANTUL', '', '', '', '', '', '', '02.961.044.1-543.000', '', 14, '', '', '', '', '', '', 'V014', '2016-03-03'),
(986, '301040', 'EC01', 'PT MANDIRI KREASI BERSAUDARA', '30 Jl.Anggrek Rosliana VII', '0006554144', 'JAKARTA BARAT', '', '', '', '', '', '', '03.093.582.9-031.000', '', 14, '', '', '', '', '', '', 'V014', '2016-03-11'),
(987, '301042', 'EC01', 'PT. ADHIJAYA DHARMA', 'No. 4 Jl. Penyelesaian Tomang III', '0006564633', 'JAKARTA BARAT', '', '', '33181814', '', '', '', '66.612.922.6-086.000', '', 14, '', '', '', '', '', '', 'V014', '2016-03-15'),
(988, '301043', 'EC01', 'TOKO ANGKASA TEKNIK', 'No. 8 Pertokoan Hayam Wuruk Indah', '0006566051', 'JAKARTA BARAT', '11180', '', '6291747', '', '', '6590556', '', '', 14, '', '', '', '', '', '', 'V014', '2016-03-16'),
(989, '301047', 'EC01', 'CAROLINE INGGRID ADITA', '', '0006568147', '', '', '', '', '', '', '', '67.016.259.3-013.000', '', 14, '', '', '', '', '', '', 'V014', '2016-03-17'),
(990, '301048', 'EC01', 'PT. INDONUSA EKA TAMA', 'Kav. No 28 APL. TOWER - CENTRAL PAR', '0006569619', 'JAKARTA BARAT', '11470', '', '29659300', '', '', '', '71.546.683.5-036.000', '', 14, '', '', '', '', '', '', 'V014', '2016-03-18'),
(991, '301049', 'EC01', 'CV. SURYA DINAMIKA', 'NO.18 RUKO PORIS PARADISE B. 12', '0006580625', 'CIPONDOH INDAH,CIPONDOH T', '', '', '', '', '', '', '73.647.411.5-416.000', '', 14, '', '', '', '', '', '', 'V014', '2016-03-22'),
(992, '301050', 'EC01', 'PT DEJAN KREASI UTAMA', '95 Jl.Paninggaran Barat II', '0006581447', 'KEBAYORAN LAMA', '', '', '', '', '', '', '', '', 14, '', '', '', '', '', '', 'V014', '2016-03-23'),
(993, '301051', 'EC01', 'E.KUSPERMANA', '', '0006597745', '', '', '', '', '', '', '', '', '', 14, '', '', '', '', '', '', 'V014', '2016-03-29'),
(994, '301052', 'EC01', 'EKO AUTO RIZKY', '361C Jl. Bhayangkara', '0006597765', 'MEDAN', '', '', '', '', '', '', '', '', 14, '', '', '', '', '', '', 'V014', '2016-03-29'),
(995, '301053', 'EC01', 'BETHANY CHRUCH', '', '0006601644', '', '', '', '', '', '', '', '', '', 14, '', '', '', '', '', '', 'V014', '2016-03-31'),
(996, '301054', 'EC01', 'PT MANTAP LINTAS SAMUDERA', '1 Jl.Raya Cipinang Indah', '0006614416', 'JAKARTA TIMUR', '', '', '', '', '', '', '72.292.987.4-002.000', '', 14, '', '', '', '', '', '', 'V014', '2016-04-06'),
(997, '301055', 'EC01', 'SATRIA AMIPUTRA A,SE,Ak,SH,SS,MM,MA', 'C1-C2 Menara Kuningan Lt 2 suite', '0006614826', 'JAKARTA SELATAN', '', '', '', '', '', '', '', '', 14, '', '', '', '', '', '', 'V014', '2016-04-06'),
(998, '301056', 'EC01', 'SAMUDERA ELECTRONIC', '12 A JL. SERDAM, BUMI BATARA 3B', '0006629951', '', '', '', '08125782656', '', '', '', '153334107701000', '', 14, '', '', '', '', '', '', 'V014', '2016-05-31'),
(999, '301057', 'EC01', 'PT TUNAS RIDEAN Tbk', 'NO 52-53 JL HAYAM WURUK', '0006644788', 'JAKARTA BARAT', '11160', '', '021-628 0450', '', '', '021-629 6179', '', '', 14, '', '', '', '', '', '', 'V014', '2016-04-20'),
(1000, '301058', 'EC01', 'MAJESTY PRINTING', 'No. 44 Jl. Brigjen Slamet Riadi', '0006647645', 'MALANG', '65112', '', '03410369800', '', '', '', '', '', 14, '', '', '', '', '', '', 'V014', '2016-04-22'),
(1001, '301062', 'EC01', 'Drs BAMBANG RAHMADI', '', '0006659122', '', '', '', '', '', '', '', '', '', 14, '', '', '', '', '', '', 'V014', '2016-04-27'),
(1002, '301063', 'EC01', 'TEDDY IRAWAN,SE', '14 Jl.Markisa 7 J.5', '0006661921', 'JAWA BARAT', '', '', '081318500076', '', '', '', '74.309.999.6-412.000', '', 14, '', '', '', '', '', '', 'V014', '2016-04-28'),
(1003, '301064', 'EC01', 'FEBRY SUKMA NURHADI', '9 Griya Gumpang Baru', '0006662011', 'JAWA TENGAH', '', '', '', '', '', '', '70.912.876.3-532.000', '', 14, '', '', '', '', '', '', 'V014', '2016-04-28'),
(1004, '301003', 'EC01', 'ASEP KUNAEPI', 'Dusun Tersana', '0006400919', 'JAWA BARAT', '', '', '', '', '', '', '', '', 14, '', '', '', '', '', '', 'V014', '2016-01-07'),
(1005, '301004', 'EC01', 'ADEL KHARISMAWAN', 'Asrama POLRI Kemayoran', '0006400921', 'JAKARTA PUSAT', '', '', '', '', '', '', '', '', 14, '', '', '', '', '', '', 'V014', '2016-01-07'),
(1006, '301005', 'EC01', 'MUHAMMAD IRWAN', 'Jln Benteng Dusun IX', '0006414238', 'MEDAN', '', '', '', '', '', '', '', '', 14, '', '', '', '', '', '', 'V014', '2016-01-12'),
(1007, '301006', 'EC01', 'PT. eurokars Surya Utama', 'NO 55 JL SULTAN ISKANDAR MUDA', '0006416240', 'ARTERI PONDOK INDAH JAKAR', '', '', '081283078727', '', '', '', '', '', 14, '', '', '', '', '', '', 'V014', '2016-01-13'),
(1008, '301008', 'EC01', 'PT SOLUSI TOTAL KOMPUTINDO', 'NO.72 GD HARCO MAS LT 2', '0006417400', 'JAKARTA', '10730', '', '30004810', '', '', '', '73.757.801.3.026.000', 'Febry Yusuf <yusuffebry@yahoo.com>', 14, '', '', '', '', '', '', 'V014', '2016-01-14'),
(1009, '301012', 'EC01', 'CV. COMCOW CENTRANUSA', 'No. 6 GG Nilam 2', '0006433770', 'PONTIANAK, KALIMANTAN BAR', '', '', '(0561) 730305', '', '', '', '66.640.133.6-701.000', '', 14, '', '', '', '', '', '', 'V014', '2016-01-21'),
(1010, '301013', 'EC01', 'INDONESIAN CORPORATE SECRETARY ASSO', 'SCTV Tower lt 18', '0006447168', 'JAKARTA', '10270', '', '', '', '', '', '', '', 14, '', '', '', '', '', '', 'V014', '2016-01-27'),
(1011, '301014', 'EC01', 'PT MASTER WEB NETWORK', 'GD.Cyber Lt 10', '0006447176', 'JAKARTA SELATAN', '', '', '', '', '', '', '02.160.756.9.014.000', '', 14, '', '', '', '', '', '', 'V014', '2016-01-27'),
(1012, '301015', 'EC01', 'CV CEMERLANG PENTASINDO', '57 Jl.KH Ahmad Dahlan', '0006447219', 'PONTIANAK', '', '', '', '', '', '', '02.527.659.3.701.000', '', 14, '', '', '', '', '', '', 'V014', '2016-01-27'),
(1013, '301016', 'EC01', 'KHAERUL ANAM', 'Blok DUkumire rt 016/008', '0006447777', 'CIREBON', '', '', '', '', '', '', '', '', 14, '', '', '', '', '', '', 'V014', '2016-01-27'),
(1014, '301017', 'EC01', 'DONI BARDIYANA', '01 Jl.Gn Bromo D XVI', '0006447812', 'CIREBON', '', '', '', '', '', '', '', '', 14, '', '', '', '', '', '', 'V014', '2016-01-27'),
(1015, '301018', 'EC01', 'DEVATARU CREATION', '49 Jl.Dr Sutomo Gg Dahlia II', '0006447844', 'CIREBON', '45131', '', '', '', '', '', '', '', 14, '', '', '', '', '', '', 'V014', '2016-01-27'),
(1016, '301019', 'EC01', 'PT. ARCADIA GLOBAL MEDIA', 'VI-C/41 BRATANG GEDE', '0006450684', 'RT.009 RW.007 NGAGEL REJO', '', '', '', '', '', '', '03.046.166.9-609.000', '', 14, '', '', '', '', '', '', 'V014', '2016-01-29'),
(1017, '301020', 'EC01', 'CV. WANGJA BROTHERS', 'BLK A-3 JL. MACAN KUMBANG VII KOMP.', '0006461854', 'RT.40 RW.11 PALEMBANG', '', '', '', '', '', '', '74.004.578.6-307.000', '', 14, '', '', '', '', '', '', 'V014', '2016-02-01'),
(1018, '301021', 'EC01', 'SUDIRMAN ABIDIN', 'Jl.Wijaya Kusuma', '0006463526', 'JAKARTA BARAT', '', '', '', '', '', '', '', '', 14, '', '', '', '', '', '', 'V014', '2016-02-02'),
(1019, '301022', 'EC01', 'HARIYANTO', 'PRM Daon Indah Prima Blok A-06/28', '0006463531', 'TANGERANG', '', '', '', '', '', '', '', '', 14, '', '', '', '', '', '', 'V014', '2016-02-02'),
(1020, '301023', 'EC01', 'MUSTIKA PRODUCTION', 'Kp Cigedogan Rt 49/10', '0006463537', 'JAWA BARAT', '', '', '', '', '', '', '', '', 14, '', '', '', '', '', '', 'V014', '2016-02-02'),
(1021, '301024', 'EC01', 'TOMI TRI MULYA', 'Kp Jagarnaek Rt 025/005', '0006463539', 'JAWA BARAT', '', '', '', '', '', '', '', '', 14, '', '', '', '', '', '', 'V014', '2016-02-02'),
(1022, '301025', 'EC01', 'RHESA GUSTI EKA PUTRA', 'Villa Bogor Indah F-2/1', '0006463550', 'JAWA BARAT', '', '', '', '', '', '', '', '', 14, '', '', '', '', '', '', 'V014', '2016-02-02'),
(1023, '301026', 'EC01', 'EMAN SULAEMAN', 'Kp Tajur Rt 004/003', '0006463555', 'JAWA BARAT', '', '', '', '', '', '', '67.459.456.9.104.000', '', 14, '', '', '', '', '', '', 'V014', '2016-02-02'),
(1024, '301027', 'EC01', 'AGUSTINUS FREDERIKUS HARDOSUWITO H', '16 Jatiraya', '0006465401', 'JAKARTA SELATAN', '', '', '', '', '', '', '24.913.990.3.017.000', '', 14, '', '', '', '', '', '', 'V014', '2016-02-03'),
(1025, '301087', 'EC01', 'caroline ingrid adita', '44 jl. tegal parang selatan iii no', '0006716196', 'JAKARTA SELATAN', '', '', '', '', '', '', '67.016.259.3-013.000', '', 14, '', '', '', '', '', '', 'V014', '2016-05-20'),
(1026, '301088', 'EC01', 'muhammad razi', 'JL. Gomo  no 5', '0006716284', 'MEDAN', '', '', '', '', '', '', 'TANPA NWPWP', '', 14, '', '', '', '', '', '', 'V014', '2016-05-20'),
(1027, '301089', 'EC01', 'dahlan virdana agma', '75 Kampung melayu kampung besar', '0006716297', '', '', '', '', '', '', '', 'TIDAK PUNYA NPWP', '', 14, '', '', '', '', '', '', 'V014', '2016-05-20'),
(1028, '301090', 'EC01', 'Jemingan', 'lr irian lingkungan II', '0006716307', '', '', '', '', '', '', '', 'TIDAK PUNYA NPWP', '', 14, '', '', '', '', '', '', 'V014', '2016-05-20'),
(1029, '301091', 'EC01', 'dendi syahputra', '73 jl. sun yat sen', '0006716308', '', '', '', '', '', '', '', 'TIDAK PUNYA NPWP', '', 14, '', '', '', '', '', '', 'V014', '2016-05-20'),
(1030, '301092', 'EC01', 'dumaria', 'Jl. gatot subroto medan', '0006716318', '', '', '', '', '', '', '', 'TIDAK PUNYA NPWP', '', 14, '', '', '', '', '', '', 'V014', '2016-05-20'),
(1031, '301093', 'EC01', 'rendy petrus h sirait', 'aspol polres pak pak bharat', '0006716332', '', '', '', '', '', '', '', 'TIDAK PUNYA NPWP', '', 14, '', '', '', '', '', '', 'V014', '2016-05-20'),
(1032, '301094', 'EC01', 'ranny ariska', '20 jl blok malang', '0006716467', '', '', '', '', '', '', '', 'TANPA NPWP', '', 14, '', '', '', '', '', '', 'V014', '2016-05-20');
INSERT INTO `api_vendor` (`id`, `supplierCode`, `companyCode`, `name`, `address1`, `address2`, `city`, `postalCode`, `contactPerson`, `phone`, `hp1`, `hp2`, `fax`, `npwp`, `email`, `paymentTerm`, `bankCode`, `bankName`, `bankBranchCode`, `bankBranchName`, `bankAccountNo`, `status`, `paymentTermCd`, `dateCreate`) VALUES
(1033, '301095', 'EC01', 'diah rinayu', 'jl. karya selamat', '0006716668', '', '', '', '', '', '', '', 'TIDAK PUNYA NPWP', '', 14, '', '', '', '', '', '', 'V014', '2016-05-20'),
(1034, '301096', 'EC01', 'wildah safitri', 'kp ciledug', '0006716732', '', '', '', '', '', '', '', 'TIDAK PUNYA NPWP', '', 14, '', '', '', '', '', '', 'V014', '2016-05-20'),
(1035, '301097', 'EC01', 'TRI BUDIARTI', '11 Jl.Ken Arok VII', '0006716762', 'TANGERANG', '', '', '', '', '', '', '', '', 14, '', '', '', '', '', '', 'V014', '2016-05-20'),
(1036, '301098', 'EC01', 'PT ZETA TREE INDONESIA', 'NO 39 JL RAYA PS. MINGGU', '0006723724', 'JAKARTA SELATAN', '', '', '021-781 97699', '', '', '021-791 97699', '75.272.518.4-061.000', 'z3pestindonesia@gmail.com', 14, '', '', '', '', '', '', 'V014', '2016-05-23'),
(1037, '301099', 'EC01', 'CV. RANDU PERDANA', 'NO.IV/6 JL. MERPATI PUTIH RT.05/14', '0006723977', 'MEKARSARI CIMANGGIS DEPOK', '', '', '', '', '', '', '', '', 14, '', '', '', '', '', '', 'V014', '2016-05-23'),
(1038, '301100', 'EC01', 'Haerul Akbar', 'tmn cimanggu poncol', '0006724416', '', '', '', '', '', '', '', 'TANPA NWPWP', '', 14, '', '', '', '', '', '', 'V014', '2016-05-23'),
(1039, '301101', 'EC01', 'dodo widodo', 'JL, adi sucipto GG kapuas', '0006739518', 'KALIMANTAN BARAT', '78381', '', '', '', '', '', '16.769.689.7-701.000', '', 14, '', '', '', '', '', '', 'V014', '2016-05-30'),
(1040, '301102', 'EC01', 'PT. Total Nusa Trans', 'wisma iskandar syah', '0006739651', 'JAKARTA SELATAN', '', '', '', '', '', '', '02.388.315.0-412.000', '', 14, '', '', '', '', '', '', 'V014', '2016-05-30'),
(1041, '301103', 'EC01', 'budiman', 'Tanjung pura GG sutera', '0006740011', '', '', '', '', '', '', '', '14.785.384.0.701.000', '', 14, '', '', '', '', '', '', 'V014', '2016-05-30'),
(1042, '301104', 'EC01', 'nopianto', 'Jl. HRA Rahman tiongkandang 2 no6', '0006740026', '', '', '', '', '', '', '', '66.981.031.3-701.000', '', 14, '', '', '', '', '', '', 'V014', '2016-05-30'),
(1043, '301105', 'EC01', 'reza agustian', 'jl. budi utomo gg mandiriii', '0006740040', '', '', '', '', '', '', '', '16.747.452.7-701.000', '', 14, '', '', '', '', '', '', 'V014', '2016-05-30'),
(1044, '301106', 'EC01', 'martinus enjrisno', 'dusun kedukul', '0006740042', '', '', '', '', '', '', '', 'TIDAK PUNYA NPWP', '', 14, '', '', '', '', '', '', 'V014', '2016-05-30'),
(1045, '301107', 'EC01', 'christian julianto', '7 jl. sulawesi dalam', '0006740057', '', '', '', '', '', '', '', 'TIDAK PUNYA NPWP', '', 14, '', '', '', '', '', '', 'V014', '2016-05-30'),
(1046, '301108', 'EC01', 'adrianur riset', '48 jl timor', '0006740123', '', '', '', '', '', '', '', 'TIDAK PUNYA NPWP', '', 14, '', '', '', '', '', '', 'V014', '2016-05-30'),
(1047, '301109', 'EC01', 'subur ban cimahi', 'Jl. Raya Barat no 536', '0006743325', '', '', '', '', '', '', '', '', '', 0, '', '', '', '', '', '', '', '2016-06-01'),
(1048, '301110', 'EC01', 'JAYA RAK MINIMARKET', 'NO.28 JL. MASJID RT.03/01', '0006745337', 'CIRACAS JAKARTA TIMUR', '', '', '', '', '', '', '', '', 14, '', '', '', '', '', '', 'V014', '2016-06-02'),
(1049, '301111', 'EC01', 'PT. sari melati kencana', '', '0006747172', '', '', '', '', '', '', '', '', '', 14, '', '', '', '', '', '', 'V014', '2016-06-03'),
(1050, '301112', 'EC01', 'FIQI RIZQI AZFAN SADRA', 'BELOK SETU JERU', '0006762896', '', '', '', '', '', '', '', 'TANPA NPWP', '', 14, '', '', '', '', '', '', 'V014', '2016-06-08'),
(1051, '301113', 'EC01', 'MUCHAMAD SAEFUDIN  NARMAN', 'KP PEGAMBIRAN RT 05/010', '0006762913', '', '', '', '', '', '', '', 'TANPA NWPWP', '', 14, '', '', '', '', '', '', 'V014', '2016-06-08'),
(1052, '301065', 'EC01', 'KHUSNUL BASRI', 'Desa AIR APO Dusun III', '0006662058', 'BENGKULU', '', '', '', '', '', '', 'TANPA NPWP', '', 14, '', '', '', '', '', '', 'V014', '2016-04-28'),
(1053, '301066', 'EC01', 'FERRY MASYURI', 'Cangkuang Rt 002/005', '0006662105', 'JAWA BARAT', '', '', '', '', '', '', '', '', 14, '', '', '', '', '', '', 'V014', '2016-04-28'),
(1054, '301067', 'EC01', 'ERWIN LAWENDRA', 'Pandansalas', '0006662110', 'MATARAM', '', '', '', '', '', '', '', '', 14, '', '', '', '', '', '', 'V014', '2016-04-28'),
(1055, '301068', 'EC01', 'PUTRA MANDIRI', 'NO. 39 JALAN SIAGA 2', '0006673085', 'JAKARTA SELATAN', '12510', '', '02199799075', '', '', '', '', 'info.ac@putramandiri.org', 14, '', '', '', '', '', '', 'V014', '2016-05-02'),
(1056, '301069', 'EC01', 'PT. VAZINDO BUMI ERACOMM', 'NO. 23 JL. BAROKAH RT. 003/009', '0006675510', 'LARANGAN UTARA KOTA TANGE', '', '', '', '', '', '021-7324042', '71.679.324.5-416.000', '', 14, '', '', '', '', '', '', 'V014', '2016-05-03'),
(1057, '301070', 'EC01', 'PT. WULANDARI BANGUN LAKSANA', '52 JL. JEND. SUDIRMAN GUNUNG BAHAGI', '0006676777', 'BALIKPAPAN', '76114', '', '', '', '', '', '01.700.858.2-725.000', '', 14, '', '', '', '', '', '', 'V014', '2016-05-04'),
(1058, '301071', 'EC01', 'Achmad Fauzan', 'pondok ungu jl. h trimban', '0006677081', '', '', '', '', '', '', '', '', '', 14, '', '', '', '', '', '', 'V014', '2016-05-04'),
(1059, '301072', 'EC01', 'Achmad jayadi', 'kp pulo kambing rt08/02', '0006677102', 'JAKARTA TIMUR', '', '', '', '', '', '', '', '', 14, '', '', '', '', '', '', 'V014', '2016-05-04'),
(1060, '301073', 'EC01', 'oki viktoria', 'jl. martimbang raya rt03/05', '0006677115', 'JAKARTA SELATAN', '', '', '', '', '', '', '', '', 14, '', '', '', '', '', '', 'V014', '2016-05-04'),
(1061, '301074', 'EC01', 'tities sasmito utoro', 'kp jati rt02/01', '0006677122', '', '', '', '', '', '', '', '', '', 14, '', '', '', '', '', '', 'V014', '2016-05-04'),
(1062, '301075', 'EC01', 'sulfi', 'paburenan  rt03/14', '0006677127', 'BOGOR', '', '', '', '', '', '', '', '', 14, '', '', '', '', '', '', 'V014', '2016-05-04'),
(1063, '301076', 'EC01', 'alvin nurlistiawan', 'kp rawa bebek rt09/10', '0006677137', 'BEKASI', '', '', '', '', '', '', '', '', 14, '', '', '', '', '', '', 'V014', '2016-05-04'),
(1064, '301077', 'EC01', 'ari fani rahmawaty', '3 poltangan ggl', '0006693574', '', '', '', '', '', '', '', '75.069.720.3-018.000', '', 14, '', '', '', '', '', '', 'V014', '2016-05-09'),
(1065, '301078', 'EC01', 'meylan fega', 'ranoyapo', '0006693583', '', '', '', '', '', '', '', '', '', 14, '', '', '', '', '', '', 'V014', '2016-05-09'),
(1066, '301079', 'EC01', 'hendro priyono', 'tanah kusir II', '0006693605', '', '', '', '', '', '', '', '', '', 14, '', '', '', '', '', '', 'V014', '2016-05-09'),
(1067, '301080', 'EC01', 'PT. KALIMANTAN GLOBAL NUSANTARA', '31 JL. INDRAKILLA STRAT III', '0006696384', '', '', '', '', '', '', '', '03.321.767.0-721.000', '', 14, '', '', '', '', '', '', 'V014', '2016-05-10'),
(1068, '301081', 'EC01', 'ud. pradana', 'jl.kihajar dewantoro', '0006696394', '', '', '', '', '', '', '', '55.937.544.9-647.000', '', 14, '', '', '', '', '', '', 'V014', '2016-05-10'),
(1069, '301082', 'EC01', 'Berjaya Ban', 'jl. wahidin no 95 ghi', '0006697228', '', '', '', '4516816', '', '', '', '', '', 14, '', '', '', '', '', '', 'V014', '2016-05-11'),
(1070, '301083', 'EC01', 'TURTLETRONIC', 'JAKARTA UTARA', '0006712533', 'JAKARTA UTARA', '', '', '', '', '', '', '', '', 14, '', '', '', '', '', '', 'V014', '2016-05-18'),
(1071, '301084', 'EC01', 'PT.GLOBAL EDUKASI INFOTAMA SOLUSI', 'GD GRAHA MANDIRI LT.26', '0006714572', 'DKI JAKARTA', '', '', '021-319834125', '', '', '', '71.967.420.2-071.000', '', 14, '', '', '', '', '', '', 'V014', '2016-05-19'),
(1072, '301085', 'EC01', 'MICRO SERVICE', '12 / 10 A JL. Dr Wahidin', '0006715608', 'PEKALONGAN', '', '', '085640223454', '', '', '', '', '', 14, '', '', '', '', '', '', 'V014', '2016-05-20'),
(1073, '301086', 'EC01', 'CV. SATRIA PERSADA', '102 A JL. ADISUCIPTO', '0006715638', 'JAWA TENGAH', '', '', '0271781945', '', '', '', '21.010.503.7-528.000', '', 14, '', '', '', '', '', '', 'V014', '2016-05-20'),
(1074, '301137', 'EC01', 'PT. Pedang berlian', 'Taman Palem lestari', '0006909368', 'JAKARTA BARAT', '', '', '021-22557170/...', '', '', '', '03.100.253.8-034.000', '', 14, '', '', '', '', '', '', 'V014', '2016-08-03'),
(1075, '301138', 'EC01', 'sanusih', 'sawah dalam rt03/05', '0006909433', 'TANGERANG', '', '', '', '', '', '', 'TANPA NPWP', '', 14, '', '', '', '', '', '', 'V014', '2016-08-03'),
(1076, '301139', 'EC01', 'anfa tenda', '23 JL. sepingan asri IX RT.43', '0006911334', 'BALIKPAPAN', '76115', '', '', '', '', '', '', '', 14, '', '', '', '', '', '', 'V014', '2016-08-04'),
(1077, '301140', 'EC01', 'AVE COMP', 'No. 6F Jl. Pisangan Raya', '0006911454', 'BANTEN', '15419', '', '', '', '', '', '', '', 14, '', '', '', '', '', '', 'V014', '2016-08-04'),
(1078, '301141', 'EC01', 'CV. CITRAWEB NUSA INFOMEDIA', 'No. 31 Jl. Petung', '0006911455', 'D.I YOGYAKARTA', '55201', '', '', '', '', '', '', '', 14, '', '', '', '', '', '', 'V014', '2016-08-04'),
(1079, '301142', 'EC01', 'CV. GANIYYA ABADI JAYA', 'PERUM ARUMBA HILL RESIDENCE KAV 10', '0006923000', 'MALANG', '', '', '085755182885', '', '', '', '033362096652000', 'oktavinanta@gmail.com', 14, '', '', '', '', '', '', 'V014', '2016-08-08'),
(1080, '301143', 'EC01', 'PT ROBERT WALTERS INDONESIA', 'GD.WORLD TRADE CENTRE 1 LT 11', '0006924189', 'JAKARTA SELATAN', '', '', '', '', '', '', '31.347.692.1-011.000', '', 14, '', '', '', '', '', '', 'V014', '2016-08-09'),
(1081, '301144', 'EC01', 'FARAH SELFIANI', '95 Jl.Raya Citayam', '0006930386', 'JAWA BARAT', '', '', '', '', '', '', '73.092.741.5.412.000', '', 14, '', '', '', '', '', '', 'V014', '2016-08-12'),
(1082, '301145', 'EC01', 'SOPIAN', 'Cimanggu Bharata', '0006930398', 'JAWA BARAT', '', '', '', '', '', '', '72.277.559.0-404.000', '', 14, '', '', '', '', '', '', 'V014', '2016-08-12'),
(1083, '301146', 'EC01', 'DEDI ARYADI', 'Jl.Parit Pangeran', '0006930409', 'PONTIANAK', '', '', '', '', '', '', '', '', 14, '', '', '', '', '', '', 'V014', '2016-08-12'),
(1084, '301147', 'EC01', 'ABDUL SYUKUR', 'Jl.28 Oktober Gg SidoMukti', '0006930425', 'PONTIANAK', '', '', '', '', '', '', '', '', 14, '', '', '', '', '', '', 'V014', '2016-08-12'),
(1085, '301148', 'EC01', 'FAWAID', 'Jl.Parit Pangeran', '0006930447', 'PONTIANAK', '', '', '', '', '', '', '', '', 14, '', '', '', '', '', '', 'V014', '2016-08-12'),
(1086, '301149', 'EC01', 'ANDRI SAPUTRA', '7 Gg Karet Lestari', '0006930480', 'PONTIANAK', '', '', '', '', '', '', '', '', 14, '', '', '', '', '', '', 'V014', '2016-08-12'),
(1087, '301150', 'EC01', 'SUBALI WIJAYA', '72 Jl.Pak Kasih', '0006930499', 'PONTIANAK', '', '', '', '', '', '', '08.310.337-4.701.000', '', 14, '', '', '', '', '', '', 'V014', '2016-08-12'),
(1088, '301151', 'EC01', 'PT. ABADI TEKNIK SEHATI', 'NO. 5 RUKO MARKET PLACE PR I', '0006930950', 'BEKASI', '17510', '', '02129080164', '', '', '', '210128013435000', 'gusniawana@yahoo.com', 14, '', '', '', '', '', '', 'V014', '2016-08-12'),
(1089, '301152', 'EC01', 'PEMERINTAH KOTA BANDAR (DELETE)', 'NO. 2 JL. KAPTEN TENDEAN', '0006941776', 'LAMPUNG', '35116', '', '0721252741', '', '', '', '', '', 14, '', '', '', '', '', '', 'V014', '2016-08-16'),
(1090, '301153', 'EC01', 'PEMERINTAH KOTA BANDAR LAMPUNG', 'NO. 2 JL. KAPTEN TENDEAN', '0006941787', 'LAMPUNG', '35116', '', '0721252741', '', '', '', '', '', 14, '', '', '', '', '', '', 'V014', '2016-08-16'),
(1091, '301154', 'EC01', 'PEMERINTAH KOTA BANDAR (DELETE)', 'NO. 2 JL. KAPTEN TENDEAN', '0006947239', 'LAMPUNG', '', '', '0721252741', '', '', '', '', '', 14, '', '', '', '', '', '', 'V014', '2016-08-18'),
(1092, '301155', 'EC01', 'PT ALFATH RIZKINDO TEKNIK', 'NO. 73 JL. CILEDUK RAYA', '0006949108', 'JAKARTA SELATAN', '', '', '0217314696', '', '', '', '031010622013000', 'pt.alfathrizkindoteknik@gmail.com', 14, '', '', '', '', '', '', 'V014', '2016-08-19'),
(1093, '301156', 'EC01', 'PT. SEJAHTERA BUANA TRADA', 'NO 173 JL DEWI SARTIKA CAWANG', '0006949491', 'KRAMAT JATI', '13630', '', '021-8008091', '', '', '021-8017333', '', '', 14, '', '', '', '', '', '', 'V014', '2016-08-19'),
(1094, '301157', 'EC01', 'PT KEMBANG GRIYA CAHAYA', 'Perum Metland Transyogi', '0006949810', 'JAWA BARAT', '', '', '', '', '', '', '01.642.694.2.436-002', '', 14, '', '', '', '', '', '', 'V014', '2016-08-19'),
(1095, '301158', 'EC01', 'PT PULAU PULAU MEDIA', '23 Perum Grand Depok City', '0006961866', 'DEPOK', '', '', '', '', '', '', '66.497.921.8.412.000', '', 14, '', '', '', '', '', '', 'V014', '2016-08-24'),
(1096, '301162', 'EC01', 'PT CHANDRA EKAJAYA LOGISTIK', '9 Komplek Bukit Gading Indah Blok J', '0006976824', 'JAKARTA UTARA', '', '', '', '', '', '', '73.981.975.3-043.000', '', 14, '', '', '', '', '', '', 'V014', '2016-08-29'),
(1097, '301163', 'EC01', 'PT. ARTHA PESONA KREASINDO', 'No. 6 KOMPLEK PERGUDANGAN EKAPRIMA', '0006984229', 'TANGERANG', '', '', '', '', '', '', '31.248.656.6-416.000', '', 14, '', '', '', '', '', '', 'V014', '2016-09-02'),
(1098, '301164', 'EC01', 'INTANIA MAYRINA', '1 Jl.Mawar merah I', '0006984314', 'JAWA BARAT', '', '', '', '', '', '', '74.732.841.7-435.000', '', 14, '', '', '', '', '', '', 'V014', '2016-09-02'),
(1099, '301165', 'EC01', 'PT KADATU MEGAH', 'NO.22 JL.Pantai Kuta II Ancol Timur', '0006994899', 'JAKARTA', '14430', '', '021-64713311', '', '', '', '013450564043000', 'kadatu@cbn.net.id', 14, '', '', '', '', '', '', 'V014', '2016-09-06'),
(1100, '301114', 'EC01', 'RICHIE KRESNO', 'lingk wage', '0006762923', '', '', '', '', '', '', '', 'TANPA NWPWP', '', 14, '', '', '', '', '', '', 'V014', '2016-06-08'),
(1101, '301115', 'EC01', 'Lutfiansyah', 'jl. ki ageng tapa blok kebon kunir', '0006762964', '', '', '', '', '', '', '', 'TANPA NWPWP', '', 14, '', '', '', '', '', '', 'V014', '2016-06-08'),
(1102, '301116', 'EC01', 'KANGDANI HANGER', 'JL. MERDEKA LINGKUNGAN CIPAYUNG', '0006764205', 'RT.4/22 KEL. ABADI JAYA D', '', '', '', '', '', '', '', '', 14, '', '', '', '', '', '', 'V014', '2016-06-09'),
(1103, '301117', 'EC01', 'PT. Griya miesejati', '', '0006777290', '', '', '', '', '', '', '', '', '', 14, '', '', '', '', '', '', 'V014', '2016-06-15'),
(1104, '301118', 'EC01', 'CV. SWADESI HARAPAN MASA', 'No. 21 Jl. Gusti Hamzah', '0006779558', 'KALIMANTAN BARAT', '', '', '085345040005', '', '', '', '75.749.428.1-701.000', '', 14, '', '', '', '', '', '', 'V014', '2016-06-16'),
(1105, '301119', 'EC01', 'HOME CREATIVE SOLUTION', 'NO. 68 C JL. RAYA TAMAN MINI PINTU', '0006781285', '', '', '', '02193697382', '', '', '', '', 'eko.saputra@electronic-city.co.id', 14, '', '', '', '', '', '', 'V014', '2016-06-17'),
(1106, '301120', 'EC01', 'JEMBATAN MAS', 'NO. 52 JL. JEMBATAN BATU', '0006781717', 'JAKART BARAT', '', '', '', '', '', '', '', '', 14, '', '', '', '', '', '', 'V014', '2016-06-17'),
(1107, '301121', 'EC01', 'PT. berkat boga sentosa', 'JL. jend sudirman Kav 52-53 lot22', '0006789044', '', '', '', '', '', '', '', '', '', 14, '', '', '', '', '', '', 'V014', '2016-06-20'),
(1108, '301122', 'EC01', 'CV. KARYA SEJAHTERA MANDIRI', 'No. 121 Jl. KESWARI', '0006789188', 'SUMATERA SELATAN', '', '', '', '', '', '', '01.967.952.1-303.000', '', 14, '', '', '', '', '', '', 'V014', '2016-06-20'),
(1109, '301123', 'EC01', 'PT. cahaya megah nusanatara', 'tamini squarq JL. Raya TMII', '0006796491', '', '', '', '', '', '', '', '31.434.856.6-005.000', '', 14, '', '', '', '', '', '', 'V014', '2016-06-24'),
(1110, '301124', 'EC01', 'PT. swa media internasional', '23 Jl. taman tanah abang III', '0006796559', '', '', '', '', '', '', '', '31.572.748.7-028.000', '', 14, '', '', '', '', '', '', 'V014', '2016-06-24'),
(1111, '301125', 'EC01', 'PT. INDAH Jaya Expres', '99 JL. raya bekasi KM18', '0006808529', '', '', '', '', '', '', '', '', '', 14, '', '', '', '', '', '', 'V014', '2016-06-27'),
(1112, '301126', 'EC01', 'PT SANTOSA MITRA KALINDO', '', '0006810494', '', '', '', '', '', '', '', '02.085.946.8-701.000', '', 14, '', '', '', '', '', '', 'V014', '2016-06-28'),
(1113, '301127', 'EC01', 'discovery reports group ltd', '27th floor tesbure centre', '0006812572', '', '000000', '', '085230101280', '', '', '085230101280', '', 'info@discoveryreports.com', 14, '', '', '', '', '', '', 'V014', '2016-06-29'),
(1114, '301128', 'EC01', 'PT. RADAVINDO MAJU MANDIRI', 'NO. 09 JL. IR. H. JUANDA RT.001/06', '0006819391', 'JAWA BARAT', '', '', '', '', '', '', '72.399.071.9-432.000', '', 14, '', '', '', '', '', '', 'V014', '2016-07-01'),
(1115, '301129', 'EC01', 'INDRA AUTO', 'No. 129 Jl. Alianyang', '0006853789', 'PONTIANAK', '', '', '', '', '', '', '16.799.957.2-701.000', '', 14, '', '', '', '', '', '', 'V014', '2016-07-11'),
(1116, '301130', 'EC01', 'indra auto(salah)', '129 jl. alianyang', '0006861338', '', '', '', '', '', '', '', '16.799.957.2-701.000', '', 14, '', '', '', '', '', '', 'V014', '2016-07-14'),
(1117, '301131', 'EC01', 'PT BONATIGA JAYA ABADI', '127A Jl.Jampea Raya', '0006862126', 'JAKARTA UTARA', '14220', '', '', '', '', '', '02.319.436.8.045.000', '', 14, '', '', '', '', '', '', 'V014', '2016-07-15'),
(1118, '301132', 'EC01', 'PT. Nirvana wastu pradana', 'lot 28 ged office 8 LT.33', '0006871475', 'DKI JAKARTA', '', '', '', '', '', '', '75.754.240.2-012.000', 'cecil.a@nirvanadevelopment.com', 14, '', '', '', '', '', '', 'V014', '2016-07-18'),
(1119, '301133', 'EC01', 'CV. MULIA SARI JAYA', 'No. 14 Jl. Abadi', '0006878594', 'KOTA BALIKPAPAN', '', '', '0542-5627531', '', '', '', '02.724.540.6-721.000', '', 14, '', '', '', '', '', '', 'V014', '2016-07-22'),
(1120, '301134', 'EC01', 'POWERBIT INDOTERA', '5 Jl. Intan Ujung', '0006886808', 'JAKARTA SELATAN', '', '', '021-27653130', '', '', '', '', '', 14, '', '', '', '', '', '', 'V014', '2016-07-25'),
(1121, '301135', 'EC01', 'axarva media teknologi', '21 Jl. terusan HR rasuna said', '0006887345', 'DKI JAKARTA', '12710', '', '', '', '', '', '03.250.331.0-014.000', '', 14, '', '', '', '', '', '', 'V014', '2016-07-25'),
(1122, '301136', 'EC01', 'PT TERATAI INDAH SENTOSA', '8 JL.Kyai Caringin Blok A', '0006890055', 'JAKARTA', '10150', '', '021-3806828', '', '', '', '', '', 14, '', '', '', '', '', '', 'V014', '2016-07-26'),
(1123, '301190', 'EC01', 'AGUNG RIFIDA SARAGIH AMD', '140F Jl Selamat Gg Buntu II', '0007089530', 'MEDAN', '', '', '', '', '', '', '', '', 14, '', '', '', '', '', '', 'V014', '2016-10-18'),
(1124, '301191', 'EC01', 'SATRIA RAMADHAN', '19 Jl.Alfalaah II', '0007089532', 'MEDAN', '', '', '', '', '', '', '', '', 14, '', '', '', '', '', '', 'V014', '2016-10-18'),
(1125, '301192', 'EC01', 'MUHAMMAD MAULANA AZHARI', '27 Jl.Sutrisno Gg Damai', '0007089556', 'MEDAN', '', '', '', '', '', '', '', '', 14, '', '', '', '', '', '', 'V014', '2016-10-18'),
(1126, '301197', 'EC01', 'PT TRIYASA SUKSES MAKMUR', 'NO. 16 A JL. TENGKU AMIR HAMZAH', '0007103706', 'SUMATERA UTARA', '20117', '', '06180030402', '', '', '', '719820391124000', 'sales@suksesmakmur.id', 14, '', '', '', '', '', '', 'V014', '2016-10-24'),
(1127, '301198', 'EC01', 'PT. DIKSTRA CIPTA SOLUSI', 'KAV. 88 EIGHTYEIGHT@KASABLANKA OFFI', '0007103975', 'JAKARTA SELATAN', '', '', '', '', '', '', '71.782.120.1-015.000', '', 14, '', '', '', '', '', '', 'V014', '2016-10-24'),
(1128, '301199', 'EC01', 'PT. ABYOR INTERNATIONAL', 'ZONE I WISMA BCA WING A', '0007105870', 'TANGERANG SELATAN', '', '', '', '', '', '', '02.978.513.6-411.000', '', 14, '', '', '', '', '', '', 'V014', '2016-10-25'),
(1129, '301200', 'EC01', 'PT. MITRACO WIRAJAYA PERDANA', 'No. 12A JL. Angke Jaya XIII', '0007106850', 'JAKARTA BARAT', '11330', '', '6308138', '', '', '', '02.293.874.0-033.000', '', 14, '', '', '', '', '', '', 'V014', '2016-10-26'),
(1130, '301201', 'EC01', 'CV. PROTEKINDO MULTI SERVICE', 'NO. 48 JL. RA KARTINI RT. 003 / RW.', '0007110560', 'BEKASI TIMUR', '', '', '02188356099', '', '', '02188358067', '742010606407000', 'protekindoservice@gmail.com', 14, '', '', '', '', '', '', 'V014', '2016-10-28'),
(1131, '301202', 'EC01', 'PT RADIO SWARA MAQEBA ARTATIARA', '23 Jl.Angkatan 45 LRG.harapan I', '0007120363', 'PALEMBANG', '', '', '', '', '', '', '01.238.107.5-307.000', '', 14, '', '', '', '', '', '', 'V014', '2016-10-31'),
(1132, '301203', 'EC01', 'PT RADIO BATAM INDONESIA', 'Jl.Kolonel Soegiono', '0007121130', 'BATAM', '29428', '', '', '', '', '', '02.276.917.8-215.000', '', 14, '', '', '', '', '', '', 'V014', '2016-10-31'),
(1133, '301204', 'EC01', 'PT TRAS MEDIACOM', '23 Jl Menteng UTama Blok F1', '0007121210', 'JAKARTA TIMUR', '', '', '', '', '', '', '', '', 14, '', '', '', '', '', '', 'V014', '2016-10-31'),
(1134, '301205', 'EC01', 'PT MERAH PUTIH KREASI NUSA', 'LT 3 Komp.Perkantoran Selmis Blok I', '0007123060', 'JAKARTA SELATAN', '', '', '', '', '', '', '03.289.682.1-015.000', '', 14, '', '', '', '', '', '', 'V014', '2016-11-01'),
(1135, '301206', 'EC01', 'CV. SINAR SURYA CITRA PRATAMA', 'NO.20A JL. BUDI MULIA RT.12/8', '0007126579', 'PADEMANGAN BARAT', '', '', '', '', '', '', '02.792.379.6-044.000', '', 14, '', '', '', '', '', '', 'V014', '2016-11-03'),
(1136, '301207', 'EC01', 'PT JAKARTA SINAR INTERTRADE', 'Gedung JITC Lt 7', '0007127969', 'JAKARTA UTARA', '', '', '', '', '', '', '01.592.053.1-046.000', '', 14, '', '', '', '', '', '', 'V014', '2016-11-04'),
(1137, '301208', 'EC01', 'KHOLI HENDRA', '10 Jl.Kartini', '0007127998', 'BANDAR LAMPUNG', '', '', '081273540057', '', '', '', '', '', 14, '', '', '', '', '', '', 'V014', '2016-11-04'),
(1138, '301209', 'EC01', 'BAHTIAR', 'KP Waringin Jaya', '0007128795', 'BOGOR', '', '', '', '', '', '', '67.262.583.7-403.000', '', 14, '', '', '', '', '', '', 'V014', '2016-11-04'),
(1139, '301210', 'EC01', 'ABDUL CHALIQ', '', '0007128801', '', '', '', '', '', '', '', '', '', 14, '', '', '', '', '', '', 'V014', '2016-11-04'),
(1140, '301211', 'EC01', 'PT KADEKA PRIMERA MEDIA', 'Gd Setiabudi 2 Lt 2 Suite 207B-C', '0007146064', 'JAKARTA SELATAN', '', '', '', '', '', '', '73.746.546.8.011.000', '', 14, '', '', '', '', '', '', 'V014', '2016-11-11'),
(1141, '301212', 'EC01', 'PT RADIO MEDIAINDAH SUARAHANDALAN', '36 Jl.Sei Petani', '0007146207', 'MEDAN', '', '', '', '', '', '', '02.007.283.1-121.000', '', 14, '', '', '', '', '', '', 'V014', '2016-11-11'),
(1142, '301213', 'EC01', 'PT ASURANSI HARTA AMAN PRATAMA TBK', '9 Jl Balikpapan Raya', '0007146376', 'JAKARTA', '', '', '021-6348760', '', '', '', '', '', 14, '', '', '', '', '', '', 'V014', '2016-11-11'),
(1143, '301214', 'EC01', 'PT. DATASCRIP', 'Kav. 9 JL SELAPARANG B-15', '0007156053', 'KEMAYORAN JAKARTA PUSAT', '10610', '', '021-6544515-8191', '', '', '021-6544811', '013040100073000', 'fazri_asrin@datascrip.co.id/www.datascrip.com', 14, '', '', '', '', '', '', 'V014', '2016-11-14'),
(1144, '301215', 'EC01', 'KURNIA KARYA TEKNIK', '3 Perum Mahkota Indah', '0007158915', 'BEKASI', '', '', '', '', '', '', '', '', 14, '', '', '', '', '', '', 'V014', '2016-11-15'),
(1145, '301217', 'EC01', 'ABRAHAM DINCO', 'Kampung Jembatan', '0007160192', 'JAKARTA TIMUR', '', '', '', '', '', '', '98.495.074.1-002.000', '', 14, '', '', '', '', '', '', 'V014', '2016-11-16'),
(1146, '301222', 'EC01', 'PT. BUDI ISTANA GRAFINDO', 'NO. 44 JL. JEMBATAN BESI II RT.5 RW', '0007175758', 'JEMBATAN BESI TAMBORA JAK', '', '', '', '', '', '', '01.686.168.4-033.000', '', 14, '', '', '', '', '', '', 'V014', '2016-11-22'),
(1147, '301223', 'EC01', 'MOHAMMAD SAFIR MAKKI', '', '0007193828', '', '', '', '', '', '', '', '', '', 14, '', '', '', '', '', '', 'V014', '2016-11-29'),
(1148, '301166', 'EC01', 'PT. HAWACOMM MEDIARTA', 'No. 36 Jl. Tomang Raya', '0007012273', 'JAKARTA BARAT', '11430', '', '081310382965', '', '', '', '03.230.204.4-031.000', '', 14, '', '', '', '', '', '', 'V014', '2016-09-14'),
(1149, '301167', 'EC01', 'YONGKY IRAWAN', '18 Komp Arlin Indah Blk N', '0007013130', 'JAKARTA TIMUR', '', '', '', '', '', '', '09.997.175.6-008.000', '', 14, '', '', '', '', '', '', 'V014', '2016-09-15'),
(1150, '301168', 'EC01', 'SIGMA', 'No. 18 Jl. Mangga Dua Raya', '0007022965', 'JAKARTA PUSAT', '10730', '', '', '', '', '', '', '', 14, '', '', '', '', '', '', 'V014', '2016-09-19'),
(1151, '301169', 'EC01', 'ANDREAS (UD PELITA MOTOR)', '10L Jl.MT Haryono', '0007023121', 'BALIKPAPAN', '', '', '', '', '', '', '06.149.211.2.721.000', '', 14, '', '', '', '', '', '', 'V014', '2016-09-19'),
(1152, '301170', 'EC01', 'PT ALAMUI LOGISTIC', 'Margo Mulyo Indah G-20', '0007023156', 'SURABAYA', '', '', '', '', '', '', '02.346.200.5-604.001', '', 14, '', '', '', '', '', '', 'V014', '2016-09-19'),
(1153, '301171', 'EC01', 'KELIK PURNOMO', 'Sampangan rt 001/003', '0007023798', 'MAGELANG', '', '', '', '', '', '', '', '', 14, '', '', '', '', '', '', 'V014', '2016-09-19'),
(1154, '301172', 'EC01', 'DENY FIRMAN', '', '0007023812', 'JAKARTA', '', '', '', '', '', '', '', '', 14, '', '', '', '', '', '', 'V014', '2016-09-19'),
(1155, '301173', 'EC01', 'PT. TUNAS DWIPA MATRA', 'NO 319 JL. DR SAHARJO', '0007029246', 'TEBET', '12810', '', '021-8357161', '', '', '021-8357162', '', '', 14, '', '', '', '', '', '', 'V014', '2016-09-23'),
(1156, '301174', 'EC01', 'DENI HERNIWAN', '2 Jl.Karang sari I', '0007037456', 'BALI', '', '', '', '', '', '', '', '', 14, '', '', '', '', '', '', 'V014', '2016-09-26'),
(1157, '301175', 'EC01', 'KHOLI HENDRA', '', '0007037457', '', '', '', '082183184456', '', '', '', '', '', 14, '', '', '', '', '', '', 'V014', '2016-09-26'),
(1158, '301176', 'EC01', 'BUKALAPAK', '', '0007039192', 'JAKARTA', '', '', '', '', '', '', '', '', 14, '', '', '', '', '', '', 'V014', '2016-09-27'),
(1159, '301177', 'EC01', 'PT. INTISUKSES MITRA MANDIRI', 'NO. 88 MERUYA ILIR, RUKAN BUSINESS', '0007039978', 'JAKARTA BARAT', '', '', '02130061507', '', '', '', '706906120086000', '', 14, '', '', '', '', '', '', 'V014', '2016-09-27'),
(1160, '301178', 'EC01', 'SUKSES JAYA', 'NO. 2H JL. H. Haris', '0007041229', 'CIMAHI', '', '', '085773611087', '', '', '', '', '', 14, '', '', '', '', '', '', 'V014', '2016-09-28'),
(1161, '301179', 'EC01', 'PANDU TENDA', '', '0007056665', '', '', '', '', '', '', '', '', '', 14, '', '', '', '', '', '', 'V014', '2016-10-04'),
(1162, '301180', 'EC01', 'PT MASS SARANA MOTORAMA', 'Jl.Jend Sudirman kav 8', '0007056971', 'JAKARTA PUSAT', '', '', '', '', '', '', '01.313.172.7-022.000', '', 14, '', '', '', '', '', '', 'V014', '2016-10-04'),
(1163, '301181', 'EC01', 'PT RADIO PILAR NADA MEDIA', '372/418 Jl.Pilang Raya', '0007062654', 'JAWA BARAT', '', '', '', '', '', '', '01.984.777.1-426.000', '', 14, '', '', '', '', '', '', 'V014', '2016-10-07'),
(1164, '301182', 'EC01', 'PT MATAHARI DEPARTMENT STORE TBK', 'Berita satu PLaza Lt 10', '0007062680', 'JAKARTA SELATAN', '', '', '', '', '', '', '01.317.956.9-054.000', '', 14, '', '', '', '', '', '', 'V014', '2016-10-07'),
(1165, '301183', 'EC01', 'PT SATRIA TIRTA UTAMA PERMAI', '26 Jl.AM Sangaji', '0007072921', 'JAKARTA PUSAT', '10130', '', '', '', '', '', '01.635.181.9-029.000', '', 14, '', '', '', '', '', '', 'V014', '2016-10-11'),
(1166, '301184', 'EC01', 'PD. HALINA', 'No. 18C Jl. A Yani', '0007075380', 'CILEGON', '', '', '', '', '', '', '', '', 14, '', '', '', '', '', '', 'V014', '2016-10-12'),
(1167, '301185', 'EC01', 'PT. JUANTO MANDIRI PRATAMA', 'Blok. A1 Pertokoan Bogor Indah Raya', '0007078006', 'BOGOR - JAWA BARAT', '', '', '', '', '', '', '31.482.420.2.404.000', '', 14, '', '', '', '', '', '', 'V014', '2016-10-14'),
(1168, '301186', 'EC01', 'SARIFUDIN', 'BLOK TEMPURAN', '0007089413', 'DEPOK', '', '', '', '', '', '', '', '', 14, '', '', '', '', '', '', 'V014', '2016-10-18'),
(1169, '301187', 'EC01', 'BAGINDA ASANO SE', 'Jl.Beo Indah', '0007089502', 'MEDAN', '', '', '', '', '', '', '', '', 14, '', '', '', '', '', '', 'V014', '2016-10-18'),
(1170, '301188', 'EC01', 'PT RADIO BINTANG MEDIA SWARA', '6 Jl.Menteri Supeno', '0007089518', 'SURAKARTA', '', '', '', '', '', '', '02.304.278.1-526.000', '', 14, '', '', '', '', '', '', 'V014', '2016-10-18'),
(1171, '301189', 'EC01', 'JEFRI H SIDABUTAR', '6 Jl.Setiabudi', '0007089525', 'MEDAN', '', '', '', '', '', '', '', '', 14, '', '', '', '', '', '', 'V014', '2016-10-18'),
(1172, '301249', 'EC01', 'YUDI HERYANTO', '32 Jl.Aneka Warga', '0007255477', 'TANGERANG SELATAN', '', '', '', '', '', '', '45.138.656.9-411.000', '', 14, '', '', '', '', '', '', 'V014', '2016-12-21'),
(1173, '301250', 'EC01', 'CV. PRIMAJAYA TECHNIK', 'NO. 62 JL. AKASIA', '0007256154', 'TANGERANG', '15152', '', '0217335151', '', '', '', '020385530416000', '', 14, '', '', '', '', '', '', 'V014', '2016-12-21'),
(1174, '301251', 'EC01', 'PT. USAHA SARANA ELECTRICAL', 'NO. 6 PERUM ALINDA KENCANA II BLOK', '0007256229', 'BEKASI', '', '', '02188877800', '', '', '', '022714141407000', 'pt_use@yahoo.co.id', 14, '', '', '', '', '', '', 'V014', '2016-12-21'),
(1175, '301252', 'EC01', 'LINTO BADIAR', 'NO. 02 JL. PAHLAWAN II PPM G. 25', '0007261010', 'BEKASI', '', '', '', '', '', '', '738487289435000', '', 14, '', '', '', '', '', '', 'V014', '2016-12-23'),
(1176, '301253', 'EC01', 'PT SATRYA INTI PRATAMA', 'Komp Harperindo B/1', '0007284603', 'TANGERANG SELATAN', '', '', '', '', '', '', '31.824.461.3-411.000', '', 14, '', '', '', '', '', '', 'V014', '2016-12-29'),
(1177, '301254', 'EC01', 'RONI HERMAWAN', 'WARU JAYA', '0007286639', 'PARUNG', '', '', '', '', '', '', '', '', 14, '', '', '', '', '', '', 'V014', '2016-12-30'),
(1178, '301255', 'EC01', 'PT. PENGUIN TRADING', 'NO. 28 JL. KAPUK KAMAL', '0007288187', 'JAKARTA BARAT', '', '', '', '', '', '', '025897075038000', '', 14, '', '', '', '', '', '', 'V014', '2016-12-30'),
(1179, '301256', 'EC01', 'CAN ELECTRONIC INDONESIA', 'No. 3 LTC Jl. Hayam Wuruk 127', '0007302912', 'JAKARTA UTARA', '11180', '', '62320266', '', '', '26071120', '', 'canelectronic.ind@gmail.com', 14, '', '', '', '', '', '', 'V014', '2017-01-03'),
(1180, '301257', 'EC01', 'PT GEOSAFES INDONESIA OPTIMA', '19 Taman JatiSari Permai Blok EB', '0007305914', 'JAWA BARAT', '', '', '', '', '', '', '76.422.075.2-447.000', '', 14, '', '', '', '', '', '', 'V014', '2017-01-04'),
(1181, '301258', 'EC01', 'WANG,IRENA CHRISTAVERLY', '2 GG. Manggis XIV', '0007308586', 'JAKARTA BARAT', '', '', '', '', '', '', '18.225.137.1-036.000', '', 14, '', '', '', '', '', '', 'V014', '2017-01-05'),
(1182, '301259', 'EC01', 'WILFRID HUTAGALUNG', '85 Kalibata Timur', '0007308587', 'JAKARTA SELATAN', '', '', '', '', '', '', '', '', 14, '', '', '', '', '', '', 'V014', '2017-01-05'),
(1183, '301260', 'EC01', 'FRIDERICA WIDYASARI DEWI', '5 Jl. Bromo', '0007308597', 'JAKARTA SELATAN', '12980', '', '', '', '', '', '47.813.377.0-018.000', '', 14, '', '', '', '', '', '', 'V014', '2017-01-05'),
(1184, '301261', 'EC01', 'ROZANA NINGSIH', '21B Jl.Kemang V', '0007308611', 'JAKARTA SELATAN', '', '', '', '', '', '', '76.913.855.3-014.000', '', 14, '', '', '', '', '', '', 'V014', '2017-01-05'),
(1185, '301262', 'EC01', 'FREDERIKA RITA', 'Villa Damai Permai Blok D-5/18', '0007308612', 'KALIMANTAN TIMUR', '', '', '', '', '', '', '08.332.605.8-721.000', '', 14, '', '', '', '', '', '', 'V014', '2017-01-05'),
(1186, '301263', 'EC01', 'ACHMAD MUFIT,SH,MKN', '2 Jl.Camar VI Blok A.I', '0007308626', 'TANGERANG SELATAN', '', '', '', '', '', '', '07.182.183.9-064.000', '', 14, '', '', '', '', '', '', 'V014', '2017-01-05'),
(1187, '301264', 'EC01', 'UBBAY NASRUL,SE', '178 Jl.SEtia Budi', '0007308654', 'MEDAN', '', '', '', '', '', '', '07.382.904.6-111.000', '', 14, '', '', '', '', '', '', 'V014', '2017-01-05'),
(1188, '301265', 'EC01', 'RIYANTO', 'CIRACAS', '0007323075', 'JAKARTA TIMUR', '', '', '082111772020', '', '', '', '49.032.433.2-009.000', '', 14, '', '', '', '', '', '', 'V014', '2017-01-11'),
(1189, '301266', 'EC01', 'PURWAKARTA EXPO 2016', '4B Perum Pesona Ciseureuh Blok J', '0007335082', 'JAWA BARAT', '41117', '', '', '', '', '', '', '', 14, '', '', '', '', '', '', 'V014', '2017-01-16'),
(1190, '301267', 'EC01', 'PT HITACHI MODERN SALES INDONESIA', 'Ruko Rich Palace Shop House', '0007335143', 'JAKARTA BARAT', '', '', '', '', '', '', '', '', 14, '', '', '', '', '', '', 'V014', '2017-01-16'),
(1191, '301268', 'EC01', 'ADITYA PERMANA', '18 JL Al Habsyi', '0007335169', 'JAKARTA PUSAT', '', '', '', '', '', '', '', '', 14, '', '', '', '', '', '', 'V014', '2017-01-16'),
(1192, '301269', 'EC01', 'KHUSNUL BASRI', 'Desa Aip Apo dusun III', '0007335175', 'BENGKULU', '', '', '', '', '', '', '', '', 14, '', '', '', '', '', '', 'V014', '2017-01-16'),
(1193, '301270', 'EC01', 'SILVANI IMANDA PUTRI LONTOH', '9 Komplek DPR', '0007336566', 'JAWA BARAT', '', '', '', '', '', '', '', '', 14, '', '', '', '', '', '', 'V014', '2017-01-17'),
(1194, '301271', 'EC01', 'PT KIRANA CIPTA PROOPERTINDO', 'Gedung Electronic City Lt 2', '0007340891', 'JAKARTA SELATAN', '', '', '', '', '', '', '', '', 14, '', '', '', '', '', '', 'V014', '2017-01-20'),
(1195, '301272', 'EC01', 'BAHTIAR', '7 Jl.Mesjid Al Fajri', '0007353388', 'JAKARTA SELATAN', '', '', '', '', '', '', '71.605.067.9-017.000', '', 14, '', '', '', '', '', '', 'V014', '2017-01-25'),
(1196, '301224', 'EC01', 'PT ABDY SENTRA KREASI', '16 Jl Tebet Barat Dalam raya', '0007194537', 'JAKARTA SELATAN', '12810', '', '', '', '', '', '02.797.072.2-015.000', '', 14, '', '', '', '', '', '', 'V014', '2016-11-29'),
(1197, '301225', 'EC01', 'EDI PURWANTO', '55 Kp Paninggilan', '0007194624', 'TANGERANG', '', '', '', '', '', '', '', '', 14, '', '', '', '', '', '', 'V014', '2016-11-29'),
(1198, '301226', 'EC01', 'PT. WAHANA WIRAWAN', 'KAV. 7 JL RA KARTINI II-S', '0007196775', 'PONDOK PINANG KEBAYORAN L', '12310', '', '021-7654211', '', '', '021-7652232', '', 'joe.nangin@yahoo.co.id', 14, '', '', '', '', '', '', 'V014', '2016-11-30'),
(1199, '301227', 'EC01', 'EDDY RUSTANDI ONG', '27 Jl.Kintamani I', '0007215665', 'JAKARTA UTARA', '', '', '', '', '', '', '06.108.496.8-043.000', '', 14, '', '', '', '', '', '', 'V014', '2016-12-07'),
(1200, '301228', 'EC01', 'ANITA CAROLINA BOKAU', 'Jl.Kebon Kacang XI Blk 5/4/15', '0007215693', 'JAKARTA PUSAT', '', '', '', '', '', '', '', '', 14, '', '', '', '', '', '', 'V014', '2016-12-07'),
(1201, '301229', 'EC01', 'HANY SIANAWATI DJUANDA', 'Kav POLRI Blok A-II/109', '0007215700', 'JAKARTA BARAT', '', '', '', '', '', '', '', '', 14, '', '', '', '', '', '', 'V014', '2016-12-07'),
(1202, '301230', 'EC01', 'DR.SUTJIPTO', '50 Villa Galaxi Blok A1', '0007215730', 'JAWA BARAT', '', '', '', '', '', '', '28.917.378.3-432.000', '', 0, '', '', '', '', '', '', '', '2016-12-07'),
(1203, '301231', 'EC01', 'DENNY ALI', 'A-7/16 Jl.Trapesium III', '0007215748', 'JAKARTA BARAT', '', '', '', '', '', '', '09.122.201.8.035.000', '', 0, '', '', '', '', '', '', '', '2016-12-07'),
(1204, '301232', 'EC01', 'TRIYONO', 'Pondok Timur Mas Blok H5/22', '0007215794', 'JAWA BARAT', '', '', '', '', '', '', '07.299.864.4-432.000', '', 0, '', '', '', '', '', '', '', '2016-12-07'),
(1205, '301233', 'EC01', 'SRI MIRAYATI,ST', 'Perum Sakura Regency Blok S/8', '0007215797', 'JAWA BARAT', '', '', '', '', '', '', '', '', 0, '', '', '', '', '', '', '', '2016-12-07'),
(1206, '301234', 'EC01', 'MURNI', '33 Jl.Danau BAtur', '0007215806', 'SUMATERA UTARA', '', '', '', '', '', '', '', '', 0, '', '', '', '', '', '', '', '2016-12-07'),
(1207, '301235', 'EC01', 'HENDARSYAH', '', '0007215811', 'JAKARTA', '', '', '', '', '', '', '', '', 0, '', '', '', '', '', '', '', '2016-12-07'),
(1208, '301236', 'EC01', 'AGUNG BUDIANTO', 'Dukuh Kalikuning', '0007215838', 'JAWA TENGAH', '57418', '', '', '', '', '', '35.428.666.8-525.000', '', 0, '', '', '', '', '', '', '', '2016-12-07'),
(1209, '301237', 'EC01', 'PUTRI RATNA PERUCHKA', '8 Jl.Rawa Kopi Raya', '0007215925', 'JAWA BARAT', '', '', '', '', '', '', '25.370.733.5-412.000', '', 0, '', '', '', '', '', '', '', '2016-12-07'),
(1210, '301238', 'EC01', 'MUHAMMAD NURYOSO', 'Jl.Teratai V Blok C-11', '0007215926', 'JAKARTA SELATAN', '', '', '', '', '', '', '47.311.062.5-017.000', '', 0, '', '', '', '', '', '', '', '2016-12-07'),
(1211, '301239', 'EC01', 'HJ. ROSITA', 'j 82 Jl.Kramat Lontar', '0007215932', 'JAKARTA PUSAT', '', '', '', '', '', '', '06.177.648.0-023.999', '', 0, '', '', '', '', '', '', '', '2016-12-07'),
(1212, '301240', 'EC01', 'SRI RAHAYU', 'Jl.DN Sidenreng D-II/68', '0007216218', 'JAKARTA PUSAT', '', '', '', '', '', '', '47.314.109.1-077.000', '', 0, '', '', '', '', '', '', '', '2016-12-07'),
(1213, '301241', 'EC01', 'PT GOTRANS LOGISTICS INTERNATIONAL', 'Jl.Raya Bogor KM.29', '0007217727', 'JAKARTA TIMUR', '', '', '', '', '', '', '01.309.155.8-007.000', '', 14, '', '', '', '', '', '', 'V014', '2016-12-08'),
(1214, '301242', 'EC01', 'PT VOLARE NET WORK', '28 Jl.M.Sohor', '0007217892', 'PONTIANAK', '', '', '', '', '', '', '02.373.265.4-701.000', '', 14, '', '', '', '', '', '', 'V014', '2016-12-08'),
(1215, '301243', 'EC01', 'PT PEJATEN JAYA KACA', '14 Jl.Pejaten Raya', '0007219559', 'JAKARTA SELATAN', '', '', '', '', '', '', '02.025.985.9-017.000', '', 14, '', '', '', '', '', '', 'V014', '2016-12-09'),
(1216, '301244', 'EC01', 'BENGKEL RULAIN', 'Jl.Adisucipto KM 15.5', '0007219806', 'PONTIANAK', '', '', '085391888825', '', '', '', '', '', 14, '', '', '', '', '', '', 'V014', '2016-12-09'),
(1217, '301245', 'EC01', 'PT POWERLINE DIESEL INTI PRATAMA', '50 Ruko Paramount Bolsena Gading Se', '0007238845', 'TANGERANG', '', '', '', '', '', '', '71.099.074.8-451.000', '', 14, '', '', '', '', '', '', 'V014', '2016-12-15'),
(1218, '301246', 'EC01', 'CV. Langkah  Jaya', 'Jl. raya kaliabang depan villa', '0007251047', '', '', '', '08129091733', '', '', '', '', '', 14, '', '', '', '', '', '', 'V014', '2016-12-19'),
(1219, '301247', 'EC01', 'ENNRILL TOMMY FEBRIAN', '11 Komp LKBN Anatara 1', '0007253174', 'JAWA BARAT', '', '', '', '', '', '', '57.170.811.4-407.000', '', 14, '', '', '', '', '', '', 'V014', '2016-12-20'),
(1220, '301248', 'EC01', 'JULANTI PANE', '27 Jl.Menteng Wadas Selatan', '0007253179', 'DKI JAKARTA', '', '', '', '', '', '', '09.643.057.4-018.001', '', 14, '', '', '', '', '', '', 'V014', '2016-12-20'),
(1221, '301299', 'EC01', 'PT MARGO MULYO MEGAH', '10 Jl Raya RAgunan', '0007421914', 'JAKARTA SELATAN', '', '', '', '', '', '', '01.797.030.2-017.000', '', 14, '', '', '', '', '', '', 'V014', '2017-02-24'),
(1222, '301300', 'EC01', 'DADANG SUGANDI B ANHAR', '24 Jl Penas IV', '0007431494', 'JAKARTA TIMUR', '', '', '', '', '', '', '', '', 14, '', '', '', '', '', '', 'V014', '2017-02-27'),
(1223, '301301', 'EC01', 'NORMAN SUDARNO', '5 KP Pertanian Selatan', '0007437165', 'JAKARTA TIMUR', '', '', '', '', '', '', '', '', 14, '', '', '', '', '', '', 'V014', '2017-03-02'),
(1224, '301302', 'EC01', 'Toko SUMBER MAS', '94 Jl Gunung Sahari Raya', '0007437178', 'JAKARTA PUSAT', '', '', '', '', '', '', '', '', 14, '', '', '', '', '', '', 'V014', '2017-03-02'),
(1225, '301303', 'EC01', 'HUMBERG LIE', '', '0007467462', 'JAKARTA', '', '', '', '', '', '', '', '', 14, '', '', '', '', '', '', 'V014', '2017-03-13'),
(1226, '301304', 'EC01', 'PT. TRISTAR MAKMUR KARTONINDO', 'No. 5D-E Jl. Meranti 3 Blok L8', '0007472636', 'BEKASI', '', '', '89901602', '', '', '89901477', '02.025.454.6-431.000', '', 14, '', '', '', '', '', '', 'V014', '2017-03-16'),
(1227, '301305', 'EC01', 'CV. AKUSTIK MULTIPRO KOMUNIKA', 'NO. 59 JL. MANGGA BESAR 1 RT.003/00', '0007475122', 'MANGGA BESAR TAMANSARI JA', '', '', '', '', '', '', '03.089.5445-032.000', '', 14, '', '', '', '', '', '', 'V014', '2017-03-17'),
(1228, '301306', 'EC01', 'CV SUKSES MANDIRI TEKNIK', '292 Jl Ramin II Blok A', '0007483879', 'JAWA BARAT', '', '', '', '', '', '', '31.154.345.8-407.000', '', 14, '', '', '', '', '', '', 'V014', '2017-03-20'),
(1229, '301307', 'EC01', 'WINNIE S HADIPRODJOSH SH', '11 Jl Cempaka Putih Tengah 27A', '0007484507', 'JAKARTA PUSAT', '', '', '', '', '', '', '06.348.139.4-024.000', '', 14, '', '', '', '', '', '', 'V014', '2017-03-20'),
(1230, '301308', 'EC01', 'CV. ZONA MULTIMEDIA', 'No. 45 JL. H. RAIS H. RAHMAN, GG BE', '0007485624', 'PONTIANAK, KALIMANTAN BAR', '', '', '085871622588', '', '', '', '03.330.651.5-701.000', 'digitalyesprinting@gmail.com', 14, '', '', '', '', '', '', 'V014', '2017-03-21'),
(1231, '301309', 'EC01', 'WAHYUDI', 'Jl.Kuningan Barat', '0007487300', 'JAKARTA SELATAN', '', '', '', '', '', '', '44.382.392.7-014.000', '', 14, '', '', '', '', '', '', 'V014', '2017-03-22'),
(1232, '301310', 'EC01', 'PT PENGELOLA PUSAT BELANJA', 'Centre Management Office Mall Bassu', '0007487305', 'JAKARTA', '13410', '', '', '', '', '', '', '', 14, '', '', '', '', '', '', 'V014', '2017-03-22'),
(1233, '301311', 'EC01', 'KJPP SUDIONO AWALUDIN & REKAN', '', '0007487312', '', '', '', '', '', '', '', '', '', 14, '', '', '', '', '', '', 'V014', '2017-03-22'),
(1234, '301312', 'EC01', 'MUHAMMAD MARSIS HARRISNANDA', '27 Permata PAmulang blok E 17', '0007489639', 'BANTEN', '', '', '', '', '', '', '73.124.760.7-411.000', '', 14, '', '', '', '', '', '', 'V014', '2017-03-23'),
(1235, 'A0122', 'EC01', 'AUTOACCINDO JAYA, PT', 'JL. CIDENG BARAT NO.7', '0007437593', 'DKI JAKARTA', '10140', '', '216332730', '', '', '6322886', '0013436019073000', 'DEVI.SAGITA@AUTOACCINDO.COM', 30, '', '', '', '', '', '', 'V030', '2017-03-02'),
(1236, 'A0222', 'EC01', 'AKARI INDONESIA. PT', '', '0004552481', '', '', '', '', '', '', '', '', '', 0, '', '', '', '', '', '', '', '2014-11-07'),
(1237, 'A0411', 'EC01', 'SUMBER ELECTRONIC', 'JL.MANGGA DUA ABDAD KOMP. BUMI JAYA', '0002353001', 'JAKARTA', '00000', '', '0216522000', '', '', '0216544458', '', '', 30, '', '', '', '', '', '', 'V030', '2014-10-13'),
(1238, 'A0421', 'EC01', 'AKIRA ELECTRONICS INDONESIA, PT', 'DANAU SUNTER SELATAN BLOK O4/38', '0002353002', 'JAKARTA', '00000', '', '0216522000', '', '', '0216544458', '', '', 30, '', '', '', '', '', '', 'V030', '2014-10-13'),
(1239, 'A0422', 'EC01', 'AKIRA ELECTRONICS INDONESIA. PT', '', '0004552482', '', '', '', '', '', '', '', '', '', 0, '', '', '', '', '', '', '', '2014-11-07'),
(1240, 'A0521', 'EC01', 'ARINDO CITRA GRAHA, PT', 'JL. BALIK PAPAN NO.2C-D', '0002353007', 'JAKARTA PUSAT', '10130', '', '0216321503', '', '', '0216321571', '', 'arindocg@cbn.net.id', 45, '', '', '', '', '', '', 'V045', '2014-10-13'),
(1241, 'A0522', 'EC01', 'ARINDO CITRA GRAHA, PT', 'JL. BALIK PAPAN NO. 2C-D', '0002362961', 'JAKARTA PUSAT', '10130', '', '', '', '', '', '', '', 30, '', '', '', '', '', '', 'V030', '2014-10-13'),
(1242, 'A0621', 'EC01', 'ADITEC CAKRAWIYASA, PT', 'JL.PANJANG NO.70 KEBON JERUK', '0002353008', 'JAKARTA BARAT', '11530', '', '0215355642', '', '', '0215326428', '', 'ekonug13amy@yahoo.com', 30, '', '', '', '', '', '', 'V030', '2014-10-13'),
(1243, 'A0622', 'EC01', 'ADITEC CAKRAWIYASA, PT', 'JL.PANJANG NO.70 KEBON JERUK', '0002362966', 'JAKARTA BARAT', '11530', '', '', '', '', '', '', '', 30, '', '', '', '', '', '', 'V030', '2014-10-13'),
(1244, '301273', 'EC01', 'ADINDA DIAN AMIRANTI', '11 Jl.MAsjid Darussalam', '0007357232', 'BANTEN', '', '', '', '', '', '', '58.994.729.0-411.000', '', 14, '', '', '', '', '', '', 'V014', '2017-01-27'),
(1245, '301274', 'EC01', 'ADANG HIDAYAT', '39A Jl.Gereja', '0007357317', 'JAKARTA SELATAN', '', '', '', '', '', '', '57.419.529.3-016.000', '', 14, '', '', '', '', '', '', 'V014', '2017-01-27'),
(1246, '301275', 'EC01', 'ARY SATRIA RACHMAN RAMLY', 'Jl PAtra Kuningan XI/2', '0007357335', 'JAKARTA SELATAN', '', '', '', '', '', '', '07.560.437.1-063.000', '', 14, '', '', '', '', '', '', 'V014', '2017-01-27'),
(1247, '301276', 'EC01', 'WAHYU MARJAKA', '7 Komp Puri Kartika Blok GII', '0007357348', 'TANGERANG', '', '', '', '', '', '', '58.485.754.4-416.000', '', 14, '', '', '', '', '', '', 'V014', '2017-01-27'),
(1248, '301277', 'EC01', 'H.JUSWANDI KRISTANTO', '16 Jl.Nangka II', '0007357364', 'JAKARTA SELATAN', '', '', '', '', '', '', '06.571.724.1-019.000', '', 14, '', '', '', '', '', '', 'V014', '2017-01-27'),
(1249, '301278', 'EC01', 'PT GARDENA RAMA MAGELANG', '10 Jl.A.YAni', '0007369387', 'MAGELANG', '', '', '', '', '', '', '01.454.667.5-514.000', '', 14, '', '', '', '', '', '', 'V014', '2017-01-31'),
(1250, '301279', 'EC01', 'PT AKITA PRIMA MOBILINDO', 'NO 1 JL RAYA PONDOK CABE BLOK CA', '0007369473', 'PAMULANG TANGERANG', '', '', '0857 7278 7000', '', '', '', '312154420402000', '', 14, '', '', '', '', '', '', 'V014', '2017-01-31'),
(1251, '301280', 'EC01', 'TAN TEK YAM', '27 Jl.Rebana', '0007371374', 'JAWA BARAT', '', '', '', '', '', '', '', '', 14, '', '', '', '', '', '', 'V014', '2017-02-01'),
(1252, '301281', 'EC01', 'ELIA SUSIANTI', '27 Jl.Rebana', '0007371391', 'JAWA BARAT', '', '', '', '', '', '', '', '', 14, '', '', '', '', '', '', 'V014', '2017-02-01'),
(1253, '301282', 'EC01', 'LILY ALIE', 'Surya Utama III Blok H-12', '0007371408', 'JAKARTA BARAT', '', '', '', '', '', '', '', '', 14, '', '', '', '', '', '', 'V014', '2017-02-01'),
(1254, '301283', 'EC01', 'DRA. STEPHANIE LILY I', '17 Jl.Kembang Agung VI Blok F.4', '0007371425', 'JAKARTA BARAT', '', '', '', '', '', '', '06.329.813.7-086.001', '', 14, '', '', '', '', '', '', 'V014', '2017-02-01'),
(1255, '301284', 'EC01', 'Tjin Fui Men', 'Lingkungan BArokah', '0007371438', 'BANTEN', '', '', '', '', '', '', '24.589.086.8-417.000', '', 14, '', '', '', '', '', '', 'V014', '2017-02-01'),
(1256, '301285', 'EC01', 'JEFFRY SETIAWAN', '46 Jl Gading Kirana F1', '0007371449', 'JAKARTA UTARA', '', '', '', '', '', '', '06.108.960.3-043.000', '', 14, '', '', '', '', '', '', 'V014', '2017-02-01'),
(1257, '301286', 'EC01', 'SHIV KUMAR DAVE', '', '0007371479', 'JAKARTA', '', '', '', '', '', '', '', '', 14, '', '', '', '', '', '', 'V014', '2017-02-01'),
(1258, '301287', 'EC01', 'HIU KOK MING', '3 jl.Palembang Raya Blok B7', '0007385866', 'JAWA BARAT', '', '', '', '', '', '', '07.020.434.2-407.000', '', 14, '', '', '', '', '', '', 'V014', '2017-02-07'),
(1259, '301288', 'EC01', 'OBI S', '', '0007387120', 'JAKARTA', '', '', '', '', '', '', '', '', 14, '', '', '', '', '', '', 'V014', '2017-02-08'),
(1260, '301289', 'EC01', 'PT SOLUTIONS GLOBAL KNOWLEDGE INDON', 'The H Tower LT 17 Unit D', '0007389124', 'JAKARTA SELATAN', '', '', '', '', '', '', '03.237.296.3-072.000', '', 14, '', '', '', '', '', '', 'V014', '2017-02-09'),
(1261, '301290', 'EC01', 'CV SAWERIGADING ENTERTAINMENT MANAG', '95C MT Haryono', '0007389148', 'KENDARI', '', '', '', '', '', '', '72.602.605.7-811.000', '', 14, '', '', '', '', '', '', 'V014', '2017-02-09'),
(1262, '301291', 'EC01', 'PT HOSANNA CIPTASEJATI', 'Kompleks Kebon Jeruk Megah', '0007389275', 'JAKARTA', '', '', '', '', '', '', '', '', 14, '', '', '', '', '', '', 'V014', '2017-02-09'),
(1263, '301292', 'EC01', 'PT. MAESTRO JAYA PRATAMA', '19.A JL. KERJA BAKTI RT.06 RW 07', '0007389421', 'JAKARTA TIMUR', '', '', '02180883625', '', '', '', '312893068005000', 'maestrojayapratama@yahoo.co.id', 14, '', '', '', '', '', '', 'V014', '2017-02-09'),
(1264, '301293', 'EC01', 'PT. TIGA ANDALAN CITRA MANDIRI', 'NO. 10 AB JL. RE. MARTADINATA', '0007390785', 'JAKARTA UTARA', '14430', '', '', '', '', '', '03.125.084.8-044.000', '', 14, '', '', '', '', '', '', 'V014', '2017-02-10'),
(1265, '301294', 'EC01', 'SUMARNO SUTANTO', '101B Jl Teratai', '0007415695', 'PEKALONGAN', '', '', '', '', '', '', '', '', 14, '', '', '', '', '', '', 'V014', '2017-02-20'),
(1266, '301295', 'EC01', 'CV PIONEER MITRA TRADING', 'NO.45A PERTOKOAN TAMAN KEDOYA', '0007419155', 'JAKARTA BARAT', '11520', '', '0215801109', '', '', '', '020661831039000', 'pmtgenset@yahoo.co.id', 14, '', '', '', '', '', '', 'V014', '2017-02-22'),
(1267, '301296', 'EC01', 'PT. NEXGEN TEKNOLOGI MANDIRI', 'No. 4 GD. PALMA ONE LT-6, SUITE 699', '0007420674', 'JAKARTA SELATAN', '', '', '29326595', '', '', '', '76.019.991.9-067.000', '', 14, '', '', '', '', '', '', 'V014', '2017-02-23'),
(1268, '301297', 'EC01', 'CV WIN\'S TEKNIK PERSADA', '88 H.Banawula sinapoy', '0007421838', 'SULAWESI TENGGARA', '', '', '', '', '', '', '75.240.813.8-811.000', '', 14, '', '', '', '', '', '', 'V014', '2017-02-24'),
(1269, '301298', 'EC01', 'SUHAEMI', 'Jl Ki Beji', '0007421857', 'BANTEN', '', '', '', '', '', '', '', '', 14, '', '', '', '', '', '', 'V014', '2017-02-24'),
(1270, 'A4122', 'EC01', 'AXINDO INFOTAMA, PT', 'RUKO MEGA GROSIR CEMPAKA MAS BLOK K', '0002363019', 'JAKARTA PUSAT', '10640', '', '', '', '', '', 'PEM-00229/WPJ.06/KP.', '', 30, '', '', '', '', '', '', 'V030', '2014-10-13'),
(1271, 'A4222', 'EC01', 'ASTRO INTERNATIONAL, PT', 'JL. DR. SAHARJO NO. 111, GEDUNG GAJ', '0002363020', 'JAKARTA SELATAN', '12810', '', '', '', '', '', '02.568.055.4-015.000', '', 30, '', '', '', '', '', '', 'V030', '2014-10-13'),
(1272, 'A4242', 'EC01', 'ASTRO INTERNATIONAL, PT', 'JL. DR. SAHARJO NO. 111, GEDUNG GAJ', '0002363025', 'JAKARTA SELATAN', '12810', '', '', '', '', '', '02.560.055.4-015.000', '', 30, '', '', '', '', '', '', 'V030', '2014-10-13'),
(1273, 'A4322', 'EC01', 'ATHERON INTERNATIONAL, PT', 'TAMAN TEKNO H 3/1-2 BSD, SETU TANGE', '0002363030', 'JAKARTA BARAT', '00000', '', '', '', '', '', '02.763.704.0-411.000', '', 30, '', '', '', '', '', '', 'V030', '2014-10-13'),
(1274, 'A4421', 'EC01', 'ALPHA DUNIA ONLINE, PT', 'JL. MANGGA DUA DALAM BLOK J NO.24', '0004475158', 'JAKARTA PUSAT', '10370', '', '216124433', '', '', '216124616', '03.048.267.3-026.000', 'YOSEP77H@GMAIL.COM', 45, '', '', '', '', '', '', 'V045', '2014-10-31'),
(1275, 'A4422', 'EC01', 'ALPHA DUNIA ONLINE, PT', 'JL. MANGGA DUA DALAM BLOK J NO.24,', '0002363035', 'JAKARTA PUSAT', '10370', '', '', '', '', '', '03.048.267.3-026.000', '', 30, '', '', '', '', '', '', 'V030', '2014-10-13'),
(1276, 'A4522', 'EC01', 'ALLEN PAULUS TECH, PT', 'APARTMENT MEDITERANIA CB/ 20B/ FH,', '0004548223', 'JAKARTA UTARA', '14240', '', '818777588', '', '', '', '71.097.571.5-604.000', 'AIRWHEEL.INDO@GMAIL.COM', 45, '', '', '', '', '', '', 'V045', '2014-11-04'),
(1277, 'A4621', 'EC01', 'ARGA MAS LESTARI, PT', 'KOMP GUDANG DIAMOND CIPTA NIAGA', '0004589639', 'SEMARANG', '50175', '', '87877833651', '', '', '2476631899', '31.507.178.7-504.000', 'KOMARU_DDIN@YAHOO.COM', 45, '', '', '', '', '', '', 'V045', '2014-11-24'),
(1278, 'A4622', 'EC01', 'ARGA MAS LESTARI, PT', 'KOMP GUDANG DIAMOND CIPTA NIAGA', '0004589661', 'SEMARANG', '50175', '', '243513820', '', '', '2476631899', '31.507.178.7-504.000', 'KOMARU_DDIN@YAHOO.COM', 45, '', '', '', '', '', '', 'V045', '2014-11-24'),
(1279, 'A4722', 'EC01', 'ARGAN TREE INDONESIA, PT', 'UNIT 1-32 GEDUNG ISTANA PASAR BARU', '0004706797', 'JAKARTA PUSAT', '10710', '', '2193256215', '', '', '65894996', '71.399.062.0-075.000', 'RICOPELAYO01@GMAIL.COM', 45, '', '', '', '', '', '', 'V045', '2015-01-08'),
(1280, 'A4822', 'EC01', 'ACHIEVA TECHNOLOGY INDONESIA,PT', 'NO.27 RUKO BAHAN BANGUNAN BLOK F4', '0006464091', 'JAKARTA', '10730', '', '216125802', '', '', '216125803', '0733626717026000', 'HENDRY.LIM@ACHIEVA.CO.ID', 30, '', '', '', '', '', '', 'V030', '2016-02-02');
INSERT INTO `api_vendor` (`id`, `supplierCode`, `companyCode`, `name`, `address1`, `address2`, `city`, `postalCode`, `contactPerson`, `phone`, `hp1`, `hp2`, `fax`, `npwp`, `email`, `paymentTerm`, `bankCode`, `bankName`, `bankBranchCode`, `bankBranchName`, `bankAccountNo`, `status`, `paymentTermCd`, `dateCreate`) VALUES
(1281, 'A4925', 'EC01', 'ASTRA MULTI FINANCE, PT', 'MENARA FIFI JL.TB SIMATUPANG KAV 15', '0006818146', 'JAKARTA SELATAN', '12440', '', '81284927778', '', '', '2175905599', '01.558.478.2-062.000', 'ANDRI.ADIWIGUNA@FIFRGROUP.ASTRA.CO.ID', 7, '', '', '', '', '', '', 'V007', '2016-07-01'),
(1282, 'A5025', 'EC01', 'AEON CREDIT SERVICE INDONESIA, PT', 'GD PLAZA KUNINGAN MENARA SELATAN', '0006855659', 'JAKARTA SELATAN', '12940', '', '81294162145', '', '', '2152880232', '01.710.923.2-012.000', '', 14, '', '', '', '', '', '', 'V014', '2016-07-12'),
(1283, 'A5121', 'EC01', 'ARCHINDO CITRA INDAH, PT', 'KOMPLEK RUKO NIRWANA SUNTER ASRI', '0007070991', 'JAKARTA UTARA', '14350', '', '2165832462', '', '', '2165832461', '02.380.975.9-048.000', 'CINDY_ACIPTUE@YAHOO.COM', 45, '', '', '', '', '', '', 'V045', '2016-10-10'),
(1284, 'A5222', 'EC01', 'ANEKA KONSEP PRATAMA, PT', 'APARTEMEN CENTRO CITY', '0007156581', 'JAKARTA BARAT', '11730', '', '2129311212', '', '', '213854228', '03.273.945.0-039.000', 'JJ2699@GMAIL.COM', 30, '', '', '', '', '', '', 'V030', '2016-11-14'),
(1285, 'B0121', 'EC01', 'BHAKTI IDOLA TAMA, PT', 'GEDUNG SASTRA GRAHA LT.8 JL. RAYA P', '0002362165', 'JAKARTA BARAT', '00000', '', '0215323808', '', '', '0215333344', '01.859.889.6.038.000', 'bhaktiidolatama_mo@yahoo.com', 45, '', '', '', '', '', '', 'V045', '2014-10-13'),
(1286, 'B0122', 'EC01', 'BHAKTI IDOLA TAMA, PT', 'GEDUNG SASTRA GRAHA LT.8 JL.RAYA PE', '0002363036', 'JAKARTA BARAT', '00000', '', '', '', '', '', '01.859.889.6.038.000', '', 30, '', '', '', '', '', '', 'V030', '2014-10-13'),
(1287, 'B0211', 'EC01', 'SUMBER ELECTRONIC', 'JL. MANGGA DUA ABDAD KOMP. BUMI JAY', '0002362170', 'JAKARTA', '00000', '', '0', '', '', '0216544811', '', '', 30, '', '', '', '', '', '', 'V030', '2014-10-13'),
(1288, 'B0222', 'EC01', 'BENNY GHANDAMA', 'JL. PINANGSIA RAYA GD. GLODOK PLAZA', '0002363041', 'JAKARTA', '00000', '', '', '', '', '', '', '', 30, '', '', '', '', '', '', 'V030', '2014-10-13'),
(1289, 'B0311', 'EC01', 'SUMBER ELECTRONIC', 'JL. MANGGA DUA ABDAD KOMP. BUMI JAY', '0002362175', 'JAKARTA', '00000', '', '08128538005', '', '', '0215362087', '', 'Susan.Sutiono@panasonic-itcomm.com', 30, '', '', '', '', '', '', 'V030', '2014-10-13'),
(1290, 'B0321', 'EC01', 'BERTINCO ANUGRAH PRIMA, PT', 'JL. RAYA PERJUANGAN NO. 21 L-3', '0002362176', 'JAKARTA', '11530', '', '02162301338', '', '', '0215362087', '', 'Susan.Sutiono@panasonic-itcomm.com', 30, '', '', '', '', '', '', 'V030', '2014-10-13'),
(1291, 'B0322', 'EC01', 'BERTINCO ANUGRAH PRIMA, PT', 'JL. RAYA PERJUANGAN NO 21 L-3', '0002363046', 'JAKARTA', '11530', '', '', '', '', '', '', '', 30, '', '', '', '', '', '', 'V030', '2014-10-13'),
(1292, 'A0721', 'EC01', 'SUMBER ELECTRONIC', 'JL SUNTER AGUNG TIMUR IX BLOK N2/11', '0002353013', 'JAKARTA', '14350', '', '0', '', '', '0216517285', '', '', 30, '', '', '', '', '', '', 'V030', '2014-10-13'),
(1293, 'A0722', 'EC01', 'ANEKA WARNA INDAH, PT.', 'JL. DANAU SUNTER TIMUR BLOK IX NO.2', '0002362967', 'JAKARTA UTARA', '14350', '', '', '', '', '', '', '', 30, '', '', '', '', '', '', 'V030', '2014-10-13'),
(1294, 'A0821', 'EC01', 'ARAH JAYA ELEKTRONIC', 'JL PLUIT KARANG JELITA 1 BLOK T4 SE', '0002353018', 'JAKARTA UTARA', '00000', '', '0216670272', '', '', '0216670272', '', 'gunardi.liemer@gmail.com', 45, '', '', '', '', '', '', 'V045', '2014-10-13'),
(1295, 'A0822', 'EC01', 'ARAH JAYA ELEKTRONIC', 'JL PLUIT KARANG JELITA 1 BLOK T4 SE', '0002362972', 'JAKARTA UTARA', '00000', '', '', '', '', '', '', '', 30, '', '', '', '', '', '', 'V030', '2014-10-13'),
(1296, 'A1221', 'EC01', 'SUMBER ELECTRONIC', '', '0002353023', '', '00000', '', '0216522000', '', '', '02165833222', '', '', 30, '', '', '', '', '', '', 'V030', '2014-10-13'),
(1297, 'A1222', 'EC01', 'ACME MULTISUKSES, PT', 'KOMP.GRAHA KENCANA BLOK D1 LT.1 KEB', '0002362977', 'JAKARTA', '11530', '', '', '', '', '', '', '', 30, '', '', '', '', '', '', 'V030', '2014-10-13'),
(1298, 'A1422', 'EC01', 'AGUNG JAYA PRIMA', 'JL. MANGGA DUA MALL NO. 2A JL. ALTE', '0002362982', 'JAKARTA', '10730', '', '', '', '', '', '', '', 30, '', '', '', '', '', '', 'V030', '2014-10-13'),
(1299, 'A1621', 'EC01', 'AKARI INDONESIA', 'JL. ABDUL MUIS NO.6-10', '0002353024', 'JAKARTA PUSAT', '10160', '', '0213510702', '', '', '0216514312', '01.739.639.1-641.000', 'intern-audit2@akari-corp.com', 45, '', '', '', '', '', '', 'V045', '2014-10-13'),
(1300, 'A1622', 'EC01', 'AKARI INDONESIA', 'JL. Raya Waru No.1 Waru Sidoarjo 61', '0002362983', 'SIDOARJO', '61256', '', '', '', '', '', '01.739.639.1-641.000', '', 30, '', '', '', '', '', '', 'V030', '2014-10-13'),
(1301, 'A2121', 'EC01', 'ARTHA SURYA GEMILANG, PT', 'HARCO MANGGA DUA ELECTRONIC Centre', '0002353029', 'JAKARTA', '10730', '', '0216125630', '', '', '0216129636', '', 'arthasurya@centrin.net.id', 30, '', '', '', '', '', '', 'V030', '2014-10-13'),
(1302, 'A2521', 'EC01', 'ADAB ALAM ELECTRONIC,PT', 'CIDENG BARAT 31AA', '0002362138', 'JAKARTA', '10150', '', '0216321946', '', '', '0216321889', '01.305.835.9.028.000', 'wati_advante65@yahoo.co.id', 45, '', '', '', '', '', '', 'V045', '2014-10-13'),
(1303, 'A2522', 'EC01', 'ADAB ALAM ELECTRONIC,PT', 'CIDENG BARAT 31AA', '0002362988', 'JAKARTA', '10150', '', '', '', '', '', '01.305.835.9.028.000', '', 30, '', '', '', '', '', '', 'V030', '2014-10-13'),
(1304, 'A2621', 'EC01', 'ASIA GREENTECH CORPORATION', 'JL.P.JAYAKARTA NO : 27 -29', '0002362143', 'JAKARTA', '11110', '', '02168683038', '', '', '02162317188', '', 'asiagreentech@yahoo.com', 45, '', '', '', '', '', '', 'V045', '2014-10-13'),
(1305, 'A2622', 'EC01', 'ASIA GREENTECH CORPORATION', 'JL.P.JAYAKARTA NO : 27 -29', '0002362993', 'JAKARTA', '11110', '', '', '', '', '', '', '', 30, '', '', '', '', '', '', 'V030', '2014-10-13'),
(1306, 'A2821', 'EC01', 'ASTRINDO SENAYASA, PT', 'RUKO MANGGA DUA SQUARE BLOK G NO 24', '0002362144', 'JAKARTA', '14430', '', '0216121330', '', '', '0216120146', '01.581.366.0-073.000', 'marliana@astrindo.co.id', 45, '', '', '', '', '', '', 'V045', '2014-10-13'),
(1307, 'A2822', 'EC01', 'ASTRINDO SENAYASA, PT', 'RUKO MANGGA DUA SQUARE BLOK G NO 24', '0002362994', 'JAKARTA', '14430', '', '', '', '', '', '01.581.366.0-073.000', '', 30, '', '', '', '', '', '', 'V030', '2014-10-13'),
(1308, 'A3222', 'EC01', 'ANDRI ELECTRONIC', 'JL. KARANG ANYAR RAYA, RUKO KARANG', '0002362999', 'JAKARTA BARAT', '00000', '', '', '', '', '', '', '', 30, '', '', '', '', '', '', 'V030', '2014-10-13'),
(1309, 'A3321', 'EC01', 'ALTA NIKINDO, PT', 'Mangga Dua Square Blok H 1 & 2 Jl.G', '0002604289', 'JAKARTA', '14430', '', '02162312505', '', '', '02162312506', '', 'leo@nikon.co.id', 45, '', '', '', '', '', '', 'V045', '2014-10-14'),
(1310, 'A3322', 'EC01', 'ALTA NIKINDO, PT', 'Mangga Dua Square Blok H 1 & 2 Jl.G', '0002604295', 'JAKARTA', '14430', '', '', '', '', '', '', '', 30, '', '', '', '', '', '', 'V030', '2014-10-14'),
(1311, 'A3422', 'EC01', 'ANEKA WARNA INDAH, PT.', 'JL. SUNTER AGUNG TIMUR IX BLOK N2 N', '0002363008', 'JAKARTA', '14350', '', '', '', '', '', '', '', 30, '', '', '', '', '', '', 'V030', '2014-10-13'),
(1312, 'A3522', 'EC01', 'ACES DIGITAL MULTITRADA, PT', 'JL. BALIKPAPAN RAYA NO. 3C', '0002363009', 'JAKARTA PUSAT', '10160', '', '', '', '', '', '', '', 30, '', '', '', '', '', '', 'V030', '2014-10-13'),
(1313, 'A3721', 'EC01', 'ANUGRAH NIAGATAMA PERKASA, PT', 'HARCO MANGGA DUA I-5', '0002362153', 'JAKARTA PUSAT', '00000', '', '0216124299', '', '', '0216124298', '0030482723026000', 'PT.ANP@HOTMAIL.COM', 30, '', '', '', '', '', '', 'V030', '2014-10-13'),
(1314, 'A3722', 'EC01', 'ANUGRAH NIAGATAMA PERKASA, PT', 'HARCO MANGGA DUA I-5', '0006056652', 'JAKARTA PUSAT', '', '', '216124299', '', '', '', '0030482723026000', 'RICKY@ISOUND-INDONESIA.COM', 30, '', '', '', '', '', '', 'V030', '2015-08-18'),
(1315, 'A3821', 'EC01', 'ANEKSA MAJU PRIMA, PT', 'KOMP. PERKANTORAN TAMAN MERUYA ILIR', '0002362154', 'JAKARTA BARAT', '11620', '', '0215845320', '', '', '0215844966', '31.612.515.2-086.000', 'HENDRIWIDJAJA@ANA-PHOTO.COM', 45, '', '', '', '', '', '', 'V045', '2014-10-13'),
(1316, 'A3822', 'EC01', 'ANEKSA MAJU PRIMA, PT', 'KOMP. PERKANTORAN TAMAN MERUYA ILIR', '0002363014', 'JAKARTA BARAT', '11620', '', '', '', '', '', '31.612.515.2-086.000', '', 30, '', '', '', '', '', '', 'V030', '2014-10-13'),
(1317, 'A3921', 'EC01', 'ANDALAN TEGUH MANDIRI, PT', 'RUKO KETAPANG INDAH BLOK B2/8 JL. Z', '0002362159', 'JAKARTA', '11140', '', '02163858998', '', '', '0216340961', '02.005.865.7-037.000', 'andi.tanudiredja@atmcom.co.id', 45, '', '', '', '', '', '', 'V045', '2014-10-13'),
(1318, 'A4021', 'EC01', 'ASURANSI ASTRA BUANA, PT', 'JL TB SIMATUPANG KAV 15 LEBAK BULUS', '0002362164', 'JAKARTA SELATAN', '12440', '', '', '', '', '0', '01.308.503.0-092.000', '', 45, '', '', '', '', '', '', 'V045', '2014-10-13'),
(1319, 'C1521', 'EC01', 'CONCEPT TWO TECHNOLOGY, PT', 'Jl kesehatan Raya No. 29 Petojo Sel', '0002362234', 'JAKARTA', '10160', '', '-', '', '', '0216500533', '', 'randy@concept2tech.com', 45, '', '', '', '', '', '', 'V045', '2014-10-13'),
(1320, 'C1522', 'EC01', 'CONCEPT TWO TECHNOLOGY, PT', 'Jl kesehatan Raya No. 29 Petojo Sel', '0002363071', 'JAKARTA', '10160', '', '', '', '', '', '', '', 30, '', '', '', '', '', '', 'V030', '2014-10-13'),
(1321, 'C1721', 'EC01', 'CHANGHONG ELECTRIC INDONESIA, PT', 'JL. MANGGA DUA RAYA, KOMPL. AGUNG S', '0002362239', 'JAKARTA', '10730', '', '0216126288', '', '', '0216126208', 'PEM-01102/WPJ.06/KP.', 'SONNY@CHANGHONG.CO.ID', 45, '', '', '', '', '', '', 'V045', '2014-10-13'),
(1322, 'C1722', 'EC01', 'CHANGHONG ELECTRIC INDONESIA, PT', 'JL. MANGGA DUA RAYA, KOMPL. AGUNG S', '0002363076', 'JAKARTA', '10730', '', '', '', '', '', 'PEM-01102/WPJ.06/KP.', '', 30, '', '', '', '', '', '', 'V030', '2014-10-13'),
(1323, 'C1821', 'EC01', 'CENTRAL CIPTA KEMAKMURAN, PT', 'KEDOYA CENTER BLOK B 7-8, JALAN PER', '0002362244', 'JAKARTA', '11530', '', '0215364775', '', '', '0215364777', '01.343.785.0-029.000', 'project_cck@yahoo.co.id', 45, '', '', '', '', '', '', 'V045', '2014-10-13'),
(1324, 'C1822', 'EC01', 'CENTRAL CIPTA KEMAKMURAN, PT', 'KEDOYA CENTER BLOK B 7-8, JALAN PER', '0002363081', 'JAKARTA', '11530', '', '', '', '', '', '01.343.785.0-029.000', '', 30, '', '', '', '', '', '', 'V030', '2014-10-13'),
(1325, 'C1923', 'EC01', 'CITRA NIAGA GEMILANG, PT', 'KOMP. DUTA HARAPAN INDAH', '0005637048', 'JAKARTA UTARA', '14470', '', '2132614253', '', '', '216605570', '02.379.198.1-047.000', 'C_NIAGA@YAHOO.CO.ID', 30, '', '', '', '', '', '', 'V030', '2015-01-26'),
(1326, 'C2021', 'EC01', 'CONER DISTRIBUSI, CV', 'NO.D6 JL.PANGERAN JAYAKARTA BLOK 12', '0005779477', 'JAKARTA PUSAT', '10730', '', '216016581', '', '', '216016578', '03.165.366.0-026.000', 'devi.adelianty@cornerduribution.com', 45, '', '', '', '', '', '', 'V045', '2015-04-07'),
(1327, 'C2022', 'EC01', 'CONER DISTRIBUSI, CV', 'NO.D6 JL.PANGERAN JAYAKARTA', '0005779539', 'JAKARTA PUSAT', '10730', '', '216016581', '', '', '216016578', '03.165.366.0-026.000', 'DEVI.ADELIANTY@CORNERDURIBUTON.COM', 30, '', '', '', '', '', '', 'V030', '2015-04-07'),
(1328, 'C2122', 'EC01', 'CHANNEL HOBBY', 'JL. PINTU KECIL NO.23', '0007420467', 'JAKARTA BARAT', '11230', '', '81533178887', '', '', '216902422', '', 'FANG.WELIF@YAHOO.COM', 30, '', '', '', '', '', '', 'V030', '2017-02-23'),
(1329, 'D0122', 'EC01', 'DINAMIKA ARDIMAS. PT', '', '0004552485', '', '', '', '', '', '', '', '', '', 0, '', '', '', '', '', '', '', '2014-11-07'),
(1330, 'D0221', 'EC01', 'DENPOO MANDIRI UTAMA, PT', 'KOMPLEKS GLODOK PLAZA BLOK B-22 JL.', '0002362248', 'JAKARTA', '11180', '', '0216293366', '', '', '0216009850', '', '', 30, '', '', '', '', '', '', 'V030', '2014-10-13'),
(1331, 'D0222', 'EC01', 'DENPOO MANDIRI UTAMA, PT', 'KOMPLEKS GLODOK PLAZA BLOK B-22 JL.', '0002363082', 'JAKARTA', '11180', '', '', '', '', '', '', '', 30, '', '', '', '', '', '', 'V030', '2014-10-13'),
(1332, 'D0321', 'EC01', 'DATASCRIP, PT', 'JL.SELAPARANG B-15 KAV.9', '0002362250', 'JAKARTA PUSAT', '10610', '', '0216544515', '', '', '0216544811', '0013040100073000', 'handy_gunawan@datascrip.co.id', 45, '', '', '', '', '', '', 'V045', '2014-10-13'),
(1333, 'D0322', 'EC01', 'DATASCRIP, PT', 'JL.SELAPARANG B-15 KAV.9', '0002363087', 'JAKARTA PUSAT', '10610', '', '', '', '', '', '0013040100073000', '', 30, '', '', '', '', '', '', 'V030', '2014-10-13'),
(1334, 'D0621', 'EC01', 'SUMBER ELECTRONIC', 'KOMP.MANGGA DUA ABDAD. JL. BUMI JAY', '0002362255', 'JAKARTA', '00000', '', '0', '', '', '0216456381', '', '', 30, '', '', '', '', '', '', 'V030', '2014-10-13'),
(1335, 'D0622', 'EC01', 'DIGITALINDO PRATAMA, PT', 'JL. GUNUNG SAHARI RAYA KAV.18 LT.6', '0002363092', 'JAKARTA UTARA', '00000', '', '', '', '', '', '', '', 30, '', '', '', '', '', '', 'V030', '2014-10-13'),
(1336, 'D0721', 'EC01', 'DINAMIKA NUSANTARA MANDIRI', 'KOMP. RUKO GADING BUKIT INDAH L/26', '0002362260', '', '00000', '', '0214527999', '', '', '0214527997', '', '', 30, '', '', '', '', '', '', 'V030', '2014-10-13'),
(1337, 'D0821', 'EC01', 'DENPOO MANDIRI INDONESIA, PT', 'Jl. Pluit Putra No.14 Pluit', '0002362261', 'JAKARTA - UTARA', '00000', '', '0216602831', '', '', '0216601782', '0017211731038000', 'yeane@denpooelectronics.com', 45, '', '', '', '', '', '', 'V045', '2014-10-13'),
(1338, 'D0822', 'EC01', 'DENPOO MANDIRI INDONESIA, PT', 'Jl. Pluit Puspa No 14 Pluit', '0002363097', 'JAKARTA - UTARA', '00000', '', '', '', '', '', '0017211731038000', '', 30, '', '', '', '', '', '', 'V030', '2014-10-13'),
(1339, 'D2121', 'EC01', 'DAMAI SEJATI.PT', 'Jl. Raya Perjuangan No. 21, Gd.Sast', '0002362266', 'JAKARTA BARAT', '11530', '', '0215362005', '', '', '0215362087', '0024603367038000', 'endang.sundari@panasonic-itcomm.com', 45, '', '', '', '', '', '', 'V045', '2014-10-13'),
(1340, 'B0421', 'EC01', 'SUMBER ELECTRONIC', 'JL. MANGGA DUA ABDAD KOMP. BUMI JAY', '0002362181', 'JAKARTA', '00000', '', '0', '', '', '0216409600', '', '', 30, '', '', '', '', '', '', 'V030', '2014-10-13'),
(1341, 'B0440', 'EC01', 'EC HO', '', '0006762699', '', '', '', '', '', '', '', '', '', 0, '', '', '', '', '', '', 'V000', '2016-06-08'),
(1342, 'B0522', 'EC01', 'BAKRIE TELECOM. PT', '', '0004552483', '', '', '', '', '', '', '', '', '', 0, '', '', '', '', '', '', '', '2014-11-07'),
(1343, 'B0721', 'EC01', 'SUMBER ELECTRONIC', 'Jl. Mangga Dua Abdad Komp. Bumi Jay', '0002362186', 'JAKARTA', '00000', '', '0', '', '', '0215333344', '', '', 30, '', '', '', '', '', '', 'V030', '2014-10-13'),
(1344, 'B0722', 'EC01', 'BERKAT ANUGERAH PERKASA JAYA. PT', '', '0004552484', '', '', '', '', '', '', '', '', '', 0, '', '', '', '', '', '', '', '2014-11-07'),
(1345, 'B1021', 'EC01', 'BINA USAHA MANDIRI SEJAHTERA, PT', 'JL. P. JAYAKARTA KOMP 141 BLOK B NO', '0002362190', 'JAKARTA PUSAT', '10730', '', '0216409688', '', '', '0216455203', '00213/WP.06/KP0403/2', 'irma.natalia@elecom-asia.com', 30, '', '', '', '', '', '', 'V030', '2014-10-13'),
(1346, 'B1521', 'EC01', 'SUMBER ELECTRONIC', 'JL. MANGGA DUA ABDAD KOMP. BUMI JAY', '0002362192', 'JAKARTA', '00000', '', '0', '', '', '0', '', '', 45, '', '', '', '', '', '', 'V045', '2014-10-13'),
(1347, 'B1721', 'EC01', 'SUMBER ELECTRONIC', 'JL. MANGGA DUA ABDAD KOMP. BUMI JAY', '0002362197', 'JAKARTA', '00000', '', '0215721373', '', '', '0216009850', '', '', 30, '', '', '', '', '', '', 'V030', '2014-10-13'),
(1348, 'B1922', 'EC01', 'BENUA MAS MAKMUR, PT', 'RUKAN GADINGBUKIT INDAH BLOK RB/05', '0002363050', 'JAKARTA UTARA', '14240', '', '', '', '', '', '', '', 30, '', '', '', '', '', '', 'V030', '2014-10-13'),
(1349, 'B2021', 'EC01', 'BERKAT AUTO TRACK SYSTEM, PT', 'JL.AM SANGAJI NO. 38 RT.001 RW.006,', '0002362202', 'JAKARTA PUSAT', '10130', '', '02126538577', '', '', '02163855937', '', 'ardawibowo@autotrack.co.id', 45, '', '', '', '', '', '', 'V045', '2014-10-13'),
(1350, 'B2022', 'EC01', 'BERKAT AUTO TRACK SYSTEM, PT', 'JL. AM SANGAJI NO. 38 RT.001 RW. 00', '0002363056', 'JAKARTA PUSAT', '10130', '', '', '', '', '', '', '', 30, '', '', '', '', '', '', 'V030', '2014-10-13'),
(1351, 'B2221', 'EC01', 'BAKTI DUA SEKAWAN, PT', 'TAMAN PALEM LESTARI BLOK F NO. 68,', '0002604294', 'JAKARTA BARAT', '11730', '', '02168861886', '', '', '0', 'PEM-00008/WPJ.05/KP.', 'mont.nikon@yahoo.com', 45, '', '', '', '', '', '', 'V045', '2014-10-14'),
(1352, 'B2222', 'EC01', 'BAKTI DUA SEKAWAN, PT', 'TAMAN PALEM LESTARI BLOK F NO. 68,', '0002604300', 'JAKARTA BARAT', '11730', '', '', '', '', '', 'PEM-00008/WPJ.05/KP.', '', 30, '', '', '', '', '', '', 'V030', '2014-10-14'),
(1353, 'B2321', 'EC01', 'BSH HOME APPLIANCES, PT', 'APL TOWER, 20TH SUITES 7-9, JL S.PA', '0002362208', 'GROGOL PETAMBURAN-JAK BAR', '11470', '', '02129034474', '', '', '02129034473', '31.517.601.6-036.000', 'agus.soejanto@bhsg.com', 45, '', '', '', '', '', '', 'V045', '2014-10-13'),
(1354, 'B2341', 'EC01', 'BSH HOME APPLIANCES, PT', 'APL TOWER, 20TH SUITES 7-9, JL S.PA', '0002362207', 'GROGOL PETAMBURAN-JAK BAR', '11470', '', '02129034474', '', '', '02129034473', '31.517.601.6-036.000', 'agus.soejanto@bhsg.com', 45, '', '', '', '', '', '', 'V045', '2014-10-13'),
(1355, 'B2342', 'EC01', 'BSH HOME APPLIANCES, PT', 'APL TOWER, 20TH SUITES 7-9', '0006949786', 'JAKARTA BARAT', '11470', '', '02129034474', '', '', '02129034473', '31.517.601.6-036.000', 'agus.soejanto@bhsg.com', 30, '', '', '', '', '', '', 'V030', '2016-08-19'),
(1356, 'B2422', 'EC01', 'BEST FORTUNE INDONESIA, PT', 'RK GRAND ORCHARD SQUARE', '0004575723', '', '14140', '', '2190299923', '', '', '2129069349', '02.880.339.3-045.000', 'SUHENDI@MAIL.PX.CO.TW', 30, '', '', '', '', '', '', 'V030', '2014-11-17'),
(1357, 'B2522', 'EC01', 'BERKAT ANDIJAYA ELEKTRINDO, PT', 'NO.38-39 RUKO ELANG LAUT BOULEVARD', '0006233426', 'JAKARTA', '14460', '', '2129677333', '', '', '', '02.185.858.4-044.000', 'HENDRA.AGUS@PTBERKAT.CO.ID', 30, '', '', '', '', '', '', 'V030', '2015-11-09'),
(1358, 'B2621', 'EC01', 'BROTHER INTERNATIONAL', 'WISMA 46 - KOTA BNI', '0006450706', 'JAKARTA PUSAT', '10220', '', '21-5744477', '', '', '21-5749830', '0025057720073000', 'MOELYAWAN@BROTHER.CO.ID', 45, '', '', '', '', '', '', 'V045', '2016-01-29'),
(1359, 'B2622', 'EC01', 'BROTHER INTERNATIONAL', 'WISMA 46 - KOTA BNI', '0006450742', 'JAKARTA PUSAT', '10220', '', '21-5744477', '', '', '21-5749830', '02.505.772.0-073.000', 'MOELYAWAN@BROTHER.CO.ID', 45, '', '', '', '', '', '', 'V045', '2016-01-29'),
(1360, 'B2722', 'EC01', 'BINTANGMAS PERMAIUTAMA, PT', 'JL.ALAYDRUS NO.29B PETOJO UTARA', '0006658187', 'JAKARTA PUSAT', '10130', '', '216346923-25', '', '', '216324482', '01.330.389.6-029.000', 'BINTANGM@CBN.NET.ID', 30, '', '', '', '', '', '', 'V030', '2016-04-26'),
(1361, 'C0121', 'EC01', 'CITRA KREASI MAKMUR, PT', 'KOMP.SOSIAL RT 004/002 WIJAYA KUSUM', '0002362213', 'JAKARTA BARAT', '00000', '', '0215664790', '', '', '0215682433', '02.038.192.7.038.000', 'kismin@citrakreasi.co.id', 45, '', '', '', '', '', '', 'V045', '2014-10-13'),
(1362, 'C0122', 'EC01', 'CITRA KREASI MAKMUR, PT', 'KOMP.SOSIAL RT 004/002 WIJAYA KUSUM', '0002363061', 'JAKARTA BARAT', '00000', '', '', '', '', '', '02.038.192.7.038.000', '', 30, '', '', '', '', '', '', 'V030', '2014-10-13'),
(1363, 'C0221', 'EC01', 'SUMBER ELECTRONIC', 'JL. MANGGA DUA ABDAD KOMP. BUMI JAY', '0002362218', 'JAKARTA', '00000', '', '0', '', '', '0213500533', '', '', 30, '', '', '', '', '', '', 'V030', '2014-10-13'),
(1364, 'C0621', 'EC01', 'SUMBER ELECTRONIC', 'KOMP.MANGGA DUA ABDAD. JL. BUMI JAY', '0002362223', 'JAKARTA UTARA', '00000', '', '0', '', '', '0', '', '', 30, '', '', '', '', '', '', 'V030', '2014-10-13'),
(1365, 'C0721', 'EC01', 'SUMBER ELECTRONIC', 'Jl. Mangga Dua Raya. Komp Agung Sed', '0002362224', 'JAKARTA', '10730', '', '0216121380', '', '', '0216121191', '', '', 45, '', '', '', '', '', '', 'V045', '2014-10-13'),
(1366, 'C1421', 'EC01', 'COMFORT DISRIBUTION INDONESIA, PT', 'JL.AGUNG PERKASA 8 KAV. K-1 NO. 42-', '0002362229', 'JAKARTA UTARA', '10610', '', '0216519330', '', '', '0216507542', '', '', 30, '', '', '', '', '', '', 'V030', '2014-10-13'),
(1367, 'C1422', 'EC01', 'COMFORT DISRIBUTION INDONESIA, PT', 'JL.AGUNG PERKASA 8 KAV. K-1 NO. 42-', '0002363066', 'JAKARTA UTARA', '10610', '', '', '', '', '', '', '', 30, '', '', '', '', '', '', 'V030', '2014-10-13'),
(1368, 'E0222', 'EC01', 'ENZER ELITRINDO, PT', 'GD. MALL MANGGA DUA LT.II NO.32 JL.', '0002363119', 'JAK-PUS', '00000', '', '', '', '', '', '', '', 30, '', '', '', '', '', '', 'V030', '2014-10-13'),
(1369, 'E0321', 'EC01', 'ELECTROLUX INDONESIA, PT', 'PLZ KUNINGAN MENARA UTARA LT2 JL HR', '0002362287', 'JAKARTA', '12940', '', '0215227099', '', '', '0215227098', '01.547.880.3.056.000', 'evelyn.natashia@electrolux.com', 45, '', '', '', '', '', '', 'V045', '2014-10-13'),
(1370, 'E0322', 'EC01', 'ELECTROLUX INDONESIA, PT', 'PLZ KUNINGAN MENARA UTARA LT2 JL HR', '0002363124', 'JAKARTA', '12940', '', '', '', '', '', '01.547.880.3.056.000', '', 30, '', '', '', '', '', '', 'V030', '2014-10-13'),
(1371, 'E0621', 'EC01', 'ELSON INDAH, PT', 'MANGGA DUA RUKO AGUNG SEDAYU BLOK I', '0002362292', 'JAKARTA', '10120', '', '0216120123', '', '', '0216120137', '', '', 30, '', '', '', '', '', '', 'V030', '2014-10-13'),
(1372, 'E0622', 'EC01', 'ELSON INDAH, PT', 'MANGGA DUA RUKO AGUNG SEDAYU BLOK I', '0002363129', 'JAKARTA', '10120', '', '', '', '', '', '', '', 30, '', '', '', '', '', '', 'V030', '2014-10-13'),
(1373, 'E0821', 'EC01', 'ELECTRONIC-CITY', '', '0002362293', '', '00000', '', '', '', '', '0', '0022254122054000', '', 30, '', '', '', '', '', '', 'V030', '2014-10-13'),
(1374, 'E1422', 'EC01', 'ERA POINT GLOBALINDO, PT', 'PUSAT NIAGA ROXY MAS BLOK D4 HASYIM', '0002363134', 'JAKARTA PUSAT', '10150', '', '', '', '', '', '02.346.147.8-028.000', '', 30, '', '', '', '', '', '', 'V030', '2014-10-13'),
(1375, 'E1921', 'EC01', 'ECS INDO JAYA, PT', 'RUKO MANGGA DUA SQUARE BLOCK E34-37', '0002362298', 'JAKARTA', '14420', '', '02162312893', '', '', '02162313661', '', 'halex@ecsindo.com', 30, '', '', '', '', '', '', 'V030', '2014-10-13'),
(1376, 'E2021', 'EC01', 'EC ENTERTAINMENT', '', '0002362299', '', '00000', '', '', '', '', '', '', '', 45, '', '', '', '', '', '', 'V045', '2014-10-13'),
(1377, 'E2022', 'EC01', 'EC ENTERTAINMENT', '', '0002363135', '', '00000', '', '', '', '', '', '', '', 30, '', '', '', '', '', '', 'V030', '2014-10-13'),
(1378, 'E2321', 'EC01', 'ERAFONE ARTHA RETAILINDO,PT', 'MALL AMBASADOR LT.4 NO.23, JL DR SA', '0002362304', 'JAKARTA SELATAN', '12940', '', '0215760609', '', '', '0215686349', '02.261.661.9.038.000', 'wisnu@erafone.com', 40, '', '', '', '', '', '', 'V040', '2014-10-13'),
(1379, 'E2322', 'EC01', 'ERAFONE ARTHA RETAILINDO,PT', 'MALL AMBASADOR LT.4 No.23,JL.DR.SAT', '0002363140', 'JAKARTA SELATAN', '12940', '', '', '', '', '', '02.261.661.9.038.000', '', 14, '', '', '', '', '', '', 'V014', '2014-10-13'),
(1380, 'E2421', 'EC01', 'EMAX FORTUNE INTERNATIONAL,PT', 'GRAND ITC PERMATA HIJAU KANTO DIAMO', '0002362309', 'JAKARTA SELATAN', '12210', '', '02153663280', '', '', '02153663281', '02.305.843.1-013.000', 'JULIUS@EMAX.CO.ID', 30, '', '', '', '', '', '', 'V030', '2014-10-13'),
(1381, 'E2422', 'EC01', 'EMAX FORTUNE INTERNATIONAL,PT', 'GRAND ITC PERMATA HIJAU KANTO DIAMO', '0002363145', 'JAKARTA SELATAN', '12210', '', '', '', '', '', '02.305.843.1-013.000', '', 30, '', '', '', '', '', '', 'V030', '2014-10-13'),
(1382, 'E2521', 'EC01', 'EURO P2P DIRECT INDO, PT', 'BLOK A 10, KELAPA GADING SQUARE, JL', '0002362314', 'JAKARTA UTARA', '14240', '', '02145869715', '', '', '02145869717', '02.435.591.9-073.000', 'soumik@forbes.co.id', 45, '', '', '', '', '', '', 'V045', '2014-10-13'),
(1383, 'E2522', 'EC01', 'EURO P2P DIRECT INDO, PT', 'BLOK A 10, KELAPA GADING SQUARE, JL', '0002363150', 'JAKARTA UTARA', '14240', '', '', '', '', '', '02.435.591.9-073.000', '', 30, '', '', '', '', '', '', 'V030', '2014-10-13'),
(1384, 'E2621', 'EC01', 'ELITE ASIA MOBILKOM, PT', 'KOMP. LODAN CENTER, LODAN RAYA NO.2', '0002362319', 'JAKARTA UTARA', '14430', '', '', '', '', '0', '03.316.273.6-044.000', '', 45, '', '', '', '', '', '', 'V045', '2014-10-13'),
(1385, 'E2622', 'EC01', 'ELITE ASIA MOBILKOM, PT', 'KOMP. LODAN CENTER, LODAN RAYA NO.2', '0002363155', 'JAKARTA UTARA', '14430', '', '', '', '', '', '03.316.273.6-044.000', '', 30, '', '', '', '', '', '', 'V030', '2014-10-13'),
(1386, 'E2721', 'EC01', 'ELSISCOM PRIMA KARYA, PT', 'JL. HAYAM WURUK NO.27', '0004607682', 'JAKARTA PUSAT', '10210', '', '213456650', '', '', '213457154', '01.402.120.8-073.000', '', 45, '', '', '', '', '', '', 'V045', '2014-12-03'),
(1387, 'E2722', 'EC01', 'ELSISCOM PRIMA KARYA, PT', 'JL. HAYAM WURUK NO.27', '0004607695', 'JAKARTA PUSAT', '10210', '', '213456650', '', '', '213457154', '01.402.120.8-073.000', 'ARPRAMONO@GALVA.CO.ID', 30, '', '', '', '', '', '', 'V030', '2014-12-03'),
(1388, 'F0121', 'EC01', 'SUMBER ELECTRONIC', 'JL. MANGGA DUA ABDAD KOMP. BUMI JAY', '0002362320', 'JAKARTA', '00000', '', '0', '', '', '0217234040', '', '', 45, '', '', '', '', '', '', 'V045', '2014-10-13'),
(1389, 'D2122', 'EC01', 'DAMAI SEJATI.PT', 'Jl. Raya Perjuangan No. 21, Gd.Sast', '0002363102', 'JAKARTA BARAT', '11530', '', '', '', '', '', '0024603367038000', '', 30, '', '', '', '', '', '', 'V030', '2014-10-13'),
(1390, 'D2321', 'EC01', 'DUNIA MARINE INTERNUSA, PT', 'JL. MALAKA 2 NO. 35', '0002362271', 'JAKARTA BARAT', '11230', '', '0216910734', '', '', '0216905615', '01.578.502.5-033.000', 'heny.harahap@jasamarine.co.id', 45, '', '', '', '', '', '', 'V045', '2014-10-13'),
(1391, 'D2322', 'EC01', 'DUNIA MARINE INTERNUSA, PT', 'JL. MALAKA 2 NO. 35', '0002363103', 'JAKARTA BARAT', '11230', '', '', '', '', '', '01.578.502.5-033.000', '', 30, '', '', '', '', '', '', 'V030', '2014-10-13'),
(1392, 'D2422', 'EC01', 'DIAMONDINDO MITRA LESTARI, PT', 'KOMPLEK RUKO HARCO MANGGA DUA BLOK', '0002363108', 'JAKARTA', '10730', '', '', '', '', '', '02.002.187.9-026.000', '', 30, '', '', '', '', '', '', 'V030', '2014-10-13'),
(1393, 'D2521', 'EC01', 'DATA CITRA MANDIRI, PT', 'ERAJAYA TWR (GD. AGRAHA) LT.3', '0002362276', 'JAKARTA BARAT', '11240', '', '0215151119', '', '', '0215150331', '02.435.632.1-036.000', 'heri.purnama@ibox.co.id', 30, '', '', '', '', '', '', 'V030', '2014-10-13'),
(1394, 'D2622', 'EC01', 'DIGITAL INOVASI ASIA, PT', 'JLN. PANGERAN JAYAKARTA KAV 126-129', '0002363113', 'JAKARTA', '10730', '', '', '', '', '', '03.165.399.1-026.000', '', 30, '', '', '', '', '', '', 'V030', '2014-10-13'),
(1395, 'D2721', 'EC01', 'DAIKIN AIRCONDITIONING INDONESIA,PT', 'GEDUNG WISMA KEIAI', '0002362280', 'JAKARTA PUSAT', '10220', '', '', '', '', '0218300578', '31.497.873.5-026.000', '', 45, '', '', '', '', '', '', 'V045', '2014-10-13'),
(1396, 'D2822', 'EC01', 'DUNIA DIGITAL INDONESIA, PT', 'THE CENTRO', '0004475203', 'JAKARTA UTARA', '14460', '', '2130010355', '', '', '2130010362', '03.223.115.1-047.000', 'HYPERSALES@DUNIADIGITALINDONESIA.COM', 30, '', '', '', '', '', '', 'V030', '2014-10-31'),
(1397, 'D2922', 'EC01', 'DUNIA DIGITAL INDONESIA, PT', 'THE CENTRO', '0004475211', 'JAKARTA UTARA', '14460', '', '2130010355', '', '', '2130010362', '03.223.115.1-047.000', 'HYPERSALES@DUNIADIGITALINDONESIA.COM', 30, '', '', '', '', '', '', 'V030', '2014-10-31'),
(1398, 'D3022', 'EC01', 'DELTA INDOTRADA, PT', 'KOMPLEK RUKO ROXY MAS BLOK D2 NO.20', '0004575706', 'JAKARTA PUSAT', '10150', '', '216336767', '', '', '216305035', '02.467.143.0-028.000', 'FRITZ@DELCELL.COM', 45, '', '', '', '', '', '', 'V045', '2014-11-17'),
(1399, 'D3121', 'EC01', 'DONGBU DAEWOO ELECTRONICS', '12TH FL MENARA BANK DANAMON', '0004607647', 'JAKARTA SELATAN', '12950', '', '21-57906322', '', '', '', '03.342.997.8-012.000', 'WINOTO@DWE.CO.KR', 45, '', '', '', '', '', '', 'V045', '2014-12-03'),
(1400, 'D3221', 'EC01', 'DISTRIBUSI SENTRA JAYA,PT', 'JL.PAHLAWAN SERIBU CBD LOT12 A', '0006292507', 'TANGGERANG SELATAN', '15323', '', '888185189', '', '', '', '70.861.537.2-411.000', 'INGGRID.ULAAN@SMARTFREN.COM', 45, '', '', '', '', '', '', 'V045', '2015-12-04'),
(1401, 'D3222', 'EC01', 'DISTRIBUSI SENTRA JAYA, PT', 'NO. 45 JL. H AGUS SALIM', '0004607590', 'JAKARTA PUSAT', '10340', '', '2131922255', '', '', '2131927880', '70.861.537.2-021.000', 'DASMEI.ZILLIWU@SMARTFREN.COM', 30, '', '', '', '', '', '', 'V030', '2014-12-03'),
(1402, 'D3322', 'EC01', 'DAVID ROY INDONESIA, PT', 'NO.100 JL.PANGLIMA POLIM RAYA', '0006150781', 'DKI JAKARTA', '12130', '', '81934145588', '', '', '', '02.296.348.2-019.000', 'AM4.JKT@DRINDONESIA.COM', 30, '', '', '', '', '', '', 'V030', '2015-10-05'),
(1403, 'D3421', 'EC01', 'DWI UTAMA PERKASA, PT', 'JL. GN SAHARI RAYA NO.1', '0007355452', 'JAKARTA', '10730', '', '216007999', '', '', '', '02.791.520.6-044.000', 'TONY.SETIAWAN@HIMAX.CO.ID', 45, '', '', '', '', '', '', 'V045', '2017-01-26'),
(1404, 'D3422', 'EC01', 'DWI UTAMA PERKASA, PT', 'JL. GN SAHARI RAYA NO.1', '0007355522', 'JAKARTA', '10730', '', '216007999', '', '', '', '02.791.520.6-044.000', 'TONY.SETIAWAN@HIMAX.CO.ID', 30, '', '', '', '', '', '', 'V030', '2017-01-26'),
(1405, 'DC01', 'EC01', 'CWH KLENDER-JIEP', '', '0005710189', '', '', '', '', '', '', '', '', '', 0, '', '', '', '', '', '', '', '2015-03-03'),
(1406, 'DC02', 'EC01', 'Cibinong CWH', '', '0000022939', '', '', '', '', '', '', '', '', '', 0, '', '', '', '', '', '', '', '2014-10-08'),
(1407, 'DC03', 'EC01', 'CURUG CWH', '', '0005627547', '', '', '', '', '', '', '', '', '', 0, '', '', '', '', '', '', '', '2015-01-19'),
(1408, 'DC04', 'EC01', 'CWH GATOT SUBROTO BALI', '', '0005809077', '', '', '', '', '', '', '', '', '', 0, '', '', '', '', '', '', '', '2015-04-22'),
(1409, 'DC05', 'EC01', 'PADALARANG CWH', '', '0005627552', '', '', '', '', '', '', '', '', '', 0, '', '', '', '', '', '', '', '2015-01-19'),
(1410, 'DC06', 'EC01', 'CWH BALIKPAPAN', '', '0005808870', '', '', '', '', '', '', '', '', '', 0, '', '', '', '', '', '', '', '2015-04-22'),
(1411, 'DC07', 'EC01', 'CWH SOLO', 'Jl. Sidoluhur No.75 Cemani.', '0005808622', '', '', '', '', '', '', '', '', '', 0, '', '', '', '', '', '', '', '2015-04-22'),
(1412, 'DC08', 'EC01', 'CWH MEDAN', '', '0005808767', '', '', '', '', '', '', '', '', '', 0, '', '', '', '', '', '', '', '2015-04-22'),
(1413, 'DC09', 'EC01', 'CWH PONTIANAK', '', '0005808993', '', '', '', '', '', '', '', '', '', 0, '', '', '', '', '', '', '', '2015-04-22'),
(1414, 'DC10', 'EC01', 'CIREBON CWH', '', '0004707992', '', '', '', '', '', '', '', '', '', 0, '', '', '', '', '', '', '', '2015-01-09'),
(1415, 'DC12', 'EC01', 'LAMPUNG CWH', 'CWH LAMPUNG', '0005710279', '', '', '', '', '', '', '', '', '', 0, '', '', '', '', '', '', '', '2015-03-03'),
(1416, 'E0121', 'EC01', 'ELITRINDO INTERNUSA, PT', 'GD. MALL MANGGA DUA LT. II NO.32 JL', '0002362282', 'JAK-PUS', '00000', '', '0216006580', '', '', '0216125635', '', '', 30, '', '', '', '', '', '', 'V030', '2014-10-13'),
(1417, 'E0122', 'EC01', 'ELITRINDO INTERNUSA, PT', 'GD. MALL MANGGA DUA LT.II NO.32 JL.', '0002363118', 'JAK-PUS', '00000', '', '', '', '', '', '', '', 30, '', '', '', '', '', '', 'V030', '2014-10-13'),
(1418, 'G2521', 'EC01', 'GLOBE SELARAS MANDIRI, PT', 'PUSAT NIAGA ROXY MAS BLOK D4 NO 14,', '0002362403', 'DKI JAKARTA', '10510', '', '0216322555', '', '', '02163858979', 'PEM-00272/WPJ.06/KP.', 'rudi@erapoint.com', 45, '', '', '', '', '', '', 'V045', '2014-10-13'),
(1419, 'G2522', 'EC01', 'GLOBE SELARAS MANDIRI, PT', 'PUSAT NIAGA ROXY MAS BLOK D4 NO 14,', '0002363198', 'DKI JAKARTA', '10510', '', '', '', '', '', 'PEM-00272/WPJ.06/KP.', '', 30, '', '', '', '', '', '', 'V030', '2014-10-13'),
(1420, 'G2542', 'EC01', 'GLOBE SELARAS MANDIRI, PT', 'PUSAT NIAGA ROXY MAS BLOK D4 NO 14,', '0002363203', 'DKI JAKARTA', '10510', '', '', '', '', '', 'PEM-00272/WPJ.06/KP.', '', 30, '', '', '', '', '', '', 'V030', '2014-10-13'),
(1421, 'G2622', 'EC01', 'GOSHEN SWARA INDONESIA, PT', 'JL. MANGGA DUA RAYA', '0004575666', 'JAKARTA PUSAT', '10730', '', '216126286', '', '', '216120843', '02.869.233.3-026.000', 'FRANKY@GOSHEN.CO.ID', 30, '', '', '', '', '', '', 'V030', '2014-11-17'),
(1422, 'G2822', 'EC01', 'GOBEL DHARMA NUSANTARA, PT', 'JL.DEWI SARTIKA NO.14 CAWANG II', '0006059682', 'JAKARTA TIMUR', '13520', '', '218015666', '', '', '218015676', '01.300.702.6.007.000', 'GUNAWAN@GDN.CO.ID', 14, '', '', '', '', '', '', 'V014', '2015-08-20'),
(1423, 'G2921', 'EC01', 'GRAHA KARUNIA TRADING, PT', 'LT.3 GEDUNG ELECTRONIC CITY BINTARO', '0007467349', 'TANGGERANG SELATAN', '15224', '', '21 29045454', '', '', '21 29045444', '02.331.816.5-012.000', 'SERVICE@ELECTRONIC-CITY.CO.ID', 45, '', '', '', '', '', '', 'V045', '2017-03-13'),
(1424, 'G300040', 'EC01', 'GRAHA KARUNIA TRADING', '', '0007336691', '', '', '', '', '', '', '', '', '', 14, '', '', '', '', '', '', 'V014', '2017-01-17'),
(1425, 'G300041', 'EC01', 'GRAHA KARUNIA TRADING', '', '0007400488', '', '', '', '', '', '', '', '', '', 14, '', '', '', '', '', '', 'V014', '2017-02-14'),
(1426, 'H0121', 'EC01', 'HYUNDAI ELECTRONIC IND, PT', 'Jl. Pantai Indah Utara 2', '0002362404', 'JAKARTA', '14460', '', '0215883600', '', '', '0215882760', '', '', 30, '', '', '', '', '', '', 'V030', '2014-10-13'),
(1427, 'H0221', 'EC01', 'HIGIENIS INDONESIA, PT', 'PLAZA PERMATA SUITE TF-04 - MH THAM', '0002362409', 'JAKARTA', '10350', '', '02139835295', '', '', '02139835294', '02.275.417.0.076.000', 'christian@higienis.com', 45, '', '', '', '', '', '', 'V045', '2014-10-13'),
(1428, 'H0222', 'EC01', 'HIGIENIS INDONESIA, PT', 'PLAZA PERMATA SUITE TF-04 - MH THAM', '0002363204', 'JAKARTA', '10350', '', '', '', '', '', '02.275.417.0.076.000', '', 30, '', '', '', '', '', '', 'V030', '2014-10-13'),
(1429, 'H0422', 'EC01', 'HASTA GUNA WIJAYA, PT', 'KOMP RUKO GARDEN D\'BEST FATMAWATI B', '0002363209', 'JAKARTA', '12420', '', '', '', '', '', '', '', 30, '', '', '', '', '', '', 'V030', '2014-10-13'),
(1430, 'H0522', 'EC01', 'HARRISMA AGUNG JAYA, PT', 'WISMA 77 lt. 8 SLIPI JL. S. PARMAN', '0002363213', 'JAKARTA BARAT', '11410', '', '', '', '', '', '', '', 30, '', '', '', '', '', '', 'V030', '2014-10-13'),
(1431, 'H0622', 'EC01', 'ALTAMA SURYA ARSA, PT', 'JL.BANDENGAN UTARA 85A NO.4', '0002363215', 'JAKARTA', '14440', '', '', '', '', '', '', '', 30, '', '', '', '', '', '', 'V030', '2014-10-13'),
(1432, 'H0921', 'EC01', 'HITACHI MODERN SALES INDONESIA, PT', 'RICH PALACE SHOP HOUSE BLOK DL &D2', '0002362414', 'JAKARTA BARAT', '11620', '', '0215307211', '', '', '0215481883', '01.328.671.1.038.000', 'herfan.permana@hmsi-hitachi.co.id', 40, '', '', '', '', '', '', 'V040', '2014-10-13'),
(1433, 'H0922', 'EC01', 'HITACHI MODERN SALES INDONESIA, PT', 'RICH PALACE SHOP HOUSE BLOK DL &D2', '0002363220', 'JAKARTA BARAT', '11620', '', '', '', '', '', '01.328.671.1.038.000', '', 30, '', '', '', '', '', '', 'V030', '2014-10-13'),
(1434, 'H1121', 'EC01', 'HAIER SALES INDONESIA, PT', 'JL DANAU SUNTER BARAT BLOK A III, N', '0002362415', 'DKI JAKARTA', '14350', '', '0216505668', '', '', '0216512556', '01.305.871.4-056.000', 'ferro@haier.co.id', 45, '', '', '', '', '', '', 'V045', '2014-10-13'),
(1435, 'H1222', 'EC01', 'HIT PENTABENUA, PT', 'GANDARIA 8 OFFICE TOWER LT. 7', '0004560155', 'JAKARTA SELATAN', '', '', '2129036581', '', '', '2129036582', '21.106.328.4-013.000', 'YUMIONO@HITCORPORATION.COM', 30, '', '', '', '', '', '', 'V030', '2014-11-10'),
(1436, 'H1321', 'EC01', 'HARTATI BASRIE', 'LINDETEVES TRADE CENTER', '0005672303', 'JAKARTA BARAT', '11180', '', '2162201447', '', '', '', '07.649.337.8-032.001', 'TRASIA_GLOBAL@YAHOO.COM', 30, '', '', '', '', '', '', 'V030', '2015-02-13'),
(1437, 'H1322', 'EC01', 'HARTATI BASRIE', 'LINDETEVES TRADE CENTER', '0005672398', 'JAKARTA BARAT', '11180', '', '2162201447', '', '', '', '07.649.337.8-032.001', 'TRASIA_GLOBAL@YAHOO.COM', 30, '', '', '', '', '', '', 'V030', '2015-02-13'),
(1438, 'F0221', 'EC01', 'FUJIFILM INDONESIA, PT', '88 @ KASABLANKA BUILDING', '0002362325', 'JAKARTA SELATAN', '12870', '', '2121282182', '', '', '2121282183', '03.155.368.8-022.000', 'ricky.felani@fujifilm.com', 45, '', '', '', '', '', '', 'V045', '2014-10-13'),
(1439, 'F0222', 'EC01', 'FUJIFILM INDONESIA, PT', '88 @ KASABLANKA BUILDING', '0002363156', 'JAKARTA SELATAN', '12870', '', '2121282182', '', '', '2121282183', '03.155.368.8-022.000', 'ricky.felani@fujifilm.com', 30, '', '', '', '', '', '', 'V030', '2014-10-13'),
(1440, 'F0321', 'EC01', 'FIT & HEALTH INDONESIA, PT', 'JL, TANAH ABANG 2 / 19', '0002362330', 'JAKARTA PUSAT', '10160', '', '0213808008', '', '', '0213808009', '02.192.773.6-071.000', 'dila.fauzia@goldgym.co.id', 45, '', '', '', '', '', '', 'V045', '2014-10-13'),
(1441, 'F0422', 'EC01', 'FESTINO INDONESIA, PT', 'WISMA 77 LT. 15', '0007141940', 'JAKARTA BARAT', '11410', '', '215363207', '', '', '215363208', '03.271.933.8-031.000', 'STEVEN.TJANDRA@FESTINDO.CO.ID', 30, '', '', '', '', '', '', 'V030', '2016-11-09'),
(1442, 'G0211', 'EC01', 'SUMBER ELECTRONIC', 'JL. MANGGA DUA ABDAD KOMP. BUMI JAY', '0002362334', 'JAKARTA', '00000', '', '0216321946', '', '', '0216231889', '', '', 30, '', '', '', '', '', '', 'V030', '2014-10-13'),
(1443, 'G0221', 'EC01', 'GEMA ALAM CIPTAMANDIR, PT', 'CIDENG BARAT 31AA', '0002362336', 'JAKARTA', '10150', '', '0216321946', '', '', '0216321889', '', '', 30, '', '', '', '', '', '', 'V030', '2014-10-13'),
(1444, 'G0311', 'EC01', 'SUMBER ELECTRONIC', 'JL. MANGGA DUA ABDAD KOMP. BUMI JAY', '0002362341', 'JAKARTA', '00000', '', '0216606063', '', '', '0216606279', '', '', 30, '', '', '', '', '', '', 'V030', '2014-10-13'),
(1445, 'G0321', 'EC01', 'GRAHA BERKAT TRADING', 'GEDUNG SUMBER BERKAT JL. SANGAJI NO', '0002362346', 'JAKARTA PUSAT', '10310', '', '02126538588', '', '', '0218300578', '02.331.815.7.012.000', 'mitha@gb-trading.co.id', 45, '', '', '', '', '', '', 'V045', '2014-10-13'),
(1446, 'G0322', 'EC01', 'GRAHA BERKAT TRADING', 'KOMP.RUKO MITRA BAHARI BLOK E.11-12', '0002363161', 'JAKARTA', '14440', '', '', '', '', '', '', '', 30, '', '', '', '', '', '', 'V030', '2014-10-13'),
(1447, 'G0341', 'EC01', 'GRAHA BERKAT TRADING', 'GEDUNG SUMBER BERKAT JL. SANGAJI NO', '0002362351', 'JAKARTA PUSAT', '10310', '', '02126538588', '', '', '0218300578', '02.331.815.7.012.000', 'mitha@gb-trading.co.id', 45, '', '', '', '', '', '', 'V045', '2014-10-13'),
(1448, 'G0621', 'EC01', 'GALVA TECHNOLOGIES, PT', 'JL.HAYAM WURUK 27', '0002362352', 'JAKARTA PUSAT', '10230', '', '0213456650', '', '', '0213501211', '01.562.264.0.073.000', 'ymagdalena@galva.co.id', 45, '', '', '', '', '', '', 'V045', '2014-10-13'),
(1449, 'G0622', 'EC01', 'GALVA TECHNOLOGIES, PT', 'JL.HAYAM WURUK 27', '0002363166', 'JAKARTA PUSAT', '10230', '', '', '', '', '', '01.562.264.0.073.000', '', 30, '', '', '', '', '', '', 'V030', '2014-10-13'),
(1450, 'G0721', 'EC01', 'GRAHA BERKAT TRADING', 'GEDUNG SUMBER BERKAT JL. SANGAJI NO', '0002362357', 'JAKARTA PUSAT', '10310', '', '02126538588', '', '', '0218300578', '', 'mitha@gb-trading.co.id', 45, '', '', '', '', '', '', 'V045', '2014-10-13'),
(1451, 'G0722', 'EC01', 'GRAHA BERKAT TRADING', 'GEDUNG SUMBER BERKAT JL. SANGAJI NO', '0002362362', 'JAKARTA PUSAT', '10310', '', '02126538588', '', '', '0218300578', '', 'mitha@gb-trading.co.id', 30, '', '', '', '', '', '', 'V030', '2014-10-13'),
(1452, 'G0811', 'EC01', 'SUMBER ELECTRONIC', 'KOMP.MANGGA DUA ABDAD JL. BUMI JAYA', '0002362367', 'JAKARTA UTARA', '00000', '', '0', '', '', '0216293092', '', '', 30, '', '', '', '', '', '', 'V030', '2014-10-13'),
(1453, 'G0821', 'EC01', 'GRAHA BERKAT ABADI', 'KOMP. RUKO MITRA BAHARI BLOK E.11-1', '0002362372', 'JAKARTA', '14440', '', '02151400212', '', '', '0216293092', '', '', 30, '', '', '', '', '', '', 'V030', '2014-10-13'),
(1454, 'G0921', 'EC01', 'GEMBIRA ELEKTRONIK,PD', '', '0002362377', '', '00000', '', '', '', '', '0216293092', '', '', 30, '', '', '', '', '', '', 'V030', '2014-10-13'),
(1455, 'G1021', 'EC01', 'GLOBAL MITRA TEKNOLOGI, PT', 'JL. BATU CEPER IV NO. 6-M', '0002362382', 'JAKARTA PUSAT', '10120', '', '0213456555', '', '', '0213457555', '03.007242.5-074.000', 'nhadi78@gmail.com', 45, '', '', '', '', '', '', 'V045', '2014-10-13'),
(1456, 'G1022', 'EC01', 'GLOBAL MITRA TEKNOLOGI, PT', 'JL. BATU CEPER IV NO. 6-M', '0002363171', 'JAKARTA PUSAT', '10120', '', '', '', '', '', '03.007242.5-074.000', '', 30, '', '', '', '', '', '', 'V030', '2014-10-13'),
(1457, 'G1922', 'EC01', 'GAYA ABADI SEMPURNA, PT', 'KOMPLEK PERMATA GUNUNG SAHARI BLOK', '0002363175', 'JAKARTA', '14420', '', '', '', '', '', '01.679.755.7.402.000', '', 30, '', '', '', '', '', '', 'V030', '2014-10-13'),
(1458, 'G2021', 'EC01', 'GAMES WORKSHOP', 'KOMP RUKO GREEN VILLE BLOK A NO.1', '0002362386', 'JAKARTA BARAT', '00000', '', '0215656013', '', '', '0215662695', '', 'silmatics@yahoo.com', 30, '', '', '', '', '', '', 'V030', '2014-10-13'),
(1459, 'G2022', 'EC01', 'GAMES WORKSHOP', 'KOMP RUKO GREEN VILLE BLOK A NO.1', '0002363177', 'JAKARTA', '00000', '', '', '', '', '', '', '', 14, '', '', '', '', '', '', 'V014', '2014-10-13'),
(1460, 'G2121', 'EC01', 'GARSKIN INDONESIA, PT', 'DARMAWANGSA SQUARE, LANTAI 3 NO. 29', '0002362388', 'JAKARTA', '12160', '', '0217399648', '', '', '02172780849', '02.935.556.7-019.000', 'salesblp@indo.net.id', 45, '', '', '', '', '', '', 'V045', '2014-10-13'),
(1461, 'G2122', 'EC01', 'GARSKIN INDONESIA, PT', 'DARMAWANGSA SQUARE, LANTAI 3 NO. 29', '0002363182', 'JAKARTA', '12160', '', '', '', '', '', '02.935.556.7-019.000', '', 30, '', '', '', '', '', '', 'V030', '2014-10-13'),
(1462, 'G2222', 'EC01', 'GLOBAL TIMURAYA UTAMA, PT', 'JL. ANGGREK NO. 3 C RADIO DALAM', '0002363187', 'JAKARTA SELATAN', '12140', '', '', '', '', '', '02.935.160.8-019.000', '', 30, '', '', '', '', '', '', 'V030', '2014-10-13'),
(1463, 'G2321', 'EC01', 'GLOBAL TELESHOP, PT', 'JL. WARUNG BUNCIT RAYA NO. 151 A DU', '0002362393', 'JAKARTA SELATAN', '12510', '', '0217947888', '', '', '0217990912', '02.506.833.9.054.000', 'tomy@global-apr.com', 30, '', '', '', '', '', '', 'V030', '2014-10-13'),
(1464, 'G2322', 'EC01', 'GLOBAL TELESHOP, PT', 'JL. WARUNG BUNCIT RAYA NO. 151 A DU', '0002363188', 'JAKARTA SELATAN', '12510', '', '', '', '', '', '02.506.833.9.054.000', '', 14, '', '', '', '', '', '', 'V014', '2014-10-13'),
(1465, 'G2421', 'EC01', 'GRAHA RAJAWALI PRATAMA, PT', 'JL. AM SANGAJI NO 38, PETOJO UTARA', '0002362398', 'JAKARTA PUSAT', '10130', '', '02126538588', '', '', '02163854503', '31.356.556.6-029.000', 'francisca.angelina@graha-rajawalipratama', 45, '', '', '', '', '', '', 'V045', '2014-10-13'),
(1466, 'G2422', 'EC01', 'GRAHA RAJAWALI PRATAMA, PT', 'JL. AM SANGAJI NO 38, PETOJO UTARA', '0002363193', 'JAKARTA PUSAT', '10130', '', '', '', '', '', '31.356.556.6-029.000', '', 30, '', '', '', '', '', '', 'V030', '2014-10-13'),
(1467, '302378', 'EC01', 'PT HOLIAWISATA INDAH', 'Inews Tower Lt 8  Jl Kebon Sirih No', '0007504419', '', '', '', '', '', '', '', '', '', 0, '', '', '', '', '', '', '', '2023-02-20'),
(1468, '302379', 'EC01', 'PT TESTER INDONESIA', '', '0007504506', '', '', '', '', '', '', '', '01.123.456-7.891.000', '', 14, '', '', '', '', '', '', 'V014', '2023-04-28'),
(1469, 'A5323', 'EC01', 'ASUR PASAR POLIS', 'JAKARTA', '0007504604', '', '', '', '', '', '', '', '01.111.111.1-011.000', '', 30, '', '', '', '', '', '', 'V030', '2023-06-27'),
(1470, 'S8823', 'EC01', 'SUN TERA', '', '0007504639', 'DKI JAKARTA', '', '', '', '', '', '', '', '', 30, '', '', '', '', '', '', 'V030', '2023-07-05'),
(1471, 'E3323', 'EC01', 'ENERGI INDONESIA BERKARYA, PT', '', '0007504680', 'DKI JAKARTA', '', '', '', '', '', '', '', '', 30, '', '', '', '', '', '', 'V030', '2023-07-07'),
(1472, 'I3121', 'EC01', 'INTI CEMERLANG SELARAS, PT', 'NO.11 RUKO ITC ROXY MAS BLOK C4', '0005784145', 'JAKARTA PUSAT', '10150', '', '2163865226', '', '', '', '03.324.202.5-028.000', 'HAYKONG0S@YAHOO.COM', 45, '', '', '', '', '', '', 'V045', '2015-04-10'),
(1473, 'I3122', 'EC01', 'INTI CEMERLANG SELARAS, PT', 'RUKO ITC ROXY MAS BLOK C4 NO.10-11,', '0002363279', 'JAKARTA', '10150', '', '', '', '', '', '03.324.202.5-028.000', '', 30, '', '', '', '', '', '', 'V030', '2014-10-13'),
(1474, 'I3142', 'EC01', 'INTI CEMERLANG SELARAS, PT', 'RUKO ITC ROXY MAS BLOK C4 NO.10-11,', '0002363284', 'JAKARTA', '10150', '', '', '', '', '', '', '', 30, '', '', '', '', '', '', 'V030', '2014-10-13'),
(1475, 'I3221', 'EC01', 'INDOCOM NIAGA, PT', 'JL. MANGGA XIV NO.6 BLOK L/305A, DU', '0002362463', 'JAKARTA BARAT', '11510', '', '02156944121', '', '', '02156944122', '02.424.079.8-039.000', 'INGGRID@IGSOLUSI.COM', 45, '', '', '', '', '', '', 'V045', '2014-10-13'),
(1476, 'I3222', 'EC01', 'INDOCOM NIAGA, PT', 'JL. MANGGA XIV NO.6 BLOK L/305A, DU', '0002363289', 'JAKARTA BARAT', '11510', '', '', '', '', '', '02.424.079.8-039.000', '', 30, '', '', '', '', '', '', 'V030', '2014-10-13'),
(1477, 'I3322', 'EC01', 'INDO MEGA VISION, PT', 'GEDUNG METRO SUNTER LT.4', '0004548249', 'JAKARTA UTARA', '14350', '', '2165830421', '', '', '2165830422', '02.186.158.8-048.000', 'JUNARDI.HWANG@IMV.CO.ID', 45, '', '', '', '', '', '', 'V045', '2014-11-04'),
(1478, 'I3421', 'EC01', 'INGRAM MICRO INDONESIA, PT', 'WISMA NUGRA SANTANA LT. 9 SUITE 009', '0004548191', 'JAKARTA PUSAT', '10220', '', '215711717', '', '', '215711707', '02.930.659.4-022.000', 'RENNY.ERNY@INGRAMMICRO-ASIA.COM', 45, '', '', '', '', '', '', 'V045', '2014-11-04'),
(1479, 'I3521', 'EC01', 'INGRAM MICRO INDONESIA, PT', 'WISMA NUGRA SANTANA', '0004548235', 'JAKARTA PUSAT', '10220', '', '215711717', '', '', '2130010362', '02.930.659.4-022.000', 'RENNY.ERNY@INGRAMMICRO-ASIA.COM', 45, '', '', '', '', '', '', 'V045', '2014-11-04'),
(1480, 'I3522', 'EC01', 'INGRAM MICRO INDONESIA, PT', 'WISMA NUGRA SANTANA', '0004548257', 'JAKARTA PUSAT', '10220', '', '82113560609', '', '', '215711707', '02.930.659.4-022.000', 'RENNY.ERNY@INGRAMMICRO-ASIA.COM', 45, '', '', '', '', '', '', 'V045', '2014-11-04'),
(1481, 'I3622', 'EC01', 'INTEGRA GLOBAL SOLUSI, PT', 'JLN.MANGGA XIV BLOK L NO.306', '0007058566', 'DKI JAKARTA', '11510', '', '2156943644', '', '', '2156944122', '02.556.091.3-039.000', 'INGGRID@IGSOLUSI.COM', 30, '', '', '', '', '', '', 'V030', '2016-10-05'),
(1482, 'I3721', 'EC01', 'INDOSAT MEGA MEDIA, PT', 'JL.KEBAGUSAN RAYA NO.36', '0007194932', 'JAKARTA SELATAN', '12550', '', '81586602358', '', '', '2178546999', '01.061.147.3-092.000', 'VREDRIEK.SILAEN@INDOSATOOREDOO.COM', 45, '', '', '', '', '', '', 'V045', '2016-11-29'),
(1483, 'I3821', 'EC01', 'INTEGRASI NETWORK PERKASA, PT', 'JL.CIPETE RAYA', '0007467499', 'BEKASI', '17157', '', '21 82731619', '', '', '', '76.147.793.4-433.000', 'MAIL@INTEGRASINNET.COM', 30, '', '', '', '', '', '', 'V030', '2017-03-13'),
(1484, 'J0121', 'EC01', 'JVC INDONESIA, PT', 'GAPURAMAS BUILDING,G FLOOR, JL. LET', '0002362468', 'JAKARTA BARAT', '11420', '', '0215668220', '', '', '0215668219', '000825-0585', '', 30, '', '', '', '', '', '', 'V030', '2014-10-13'),
(1485, 'J0221', 'EC01', 'JOSAN MAJU JAYA, UD', 'APARTEMENT SIMPRUG INDAH SP-01, JL', '0002362473', 'JAKARTA', '00000', '', '0217230586', '', '', '0217230588', '', '', 30, '', '', '', '', '', '', 'V030', '2014-10-13'),
(1486, 'J0321', 'EC01', 'JOHNY', '', '0005726043', '', '', '', '', '', '', '', '', '', 14, '', '', '', '', '', '', 'V014', '2015-03-12'),
(1487, 'J0422', 'EC01', 'JABARTI GARUDA MAKMUR, PT', 'JL.BANGKA RAYA NO. 21', '0006580087', 'JAKARTA SELATAN', '12720', '', '817718820', '', '', '', '03.118.474.0-014.000', 'CARLIN.KAWIDJAJA@BALITAKITA.COM', 30, '', '', '', '', '', '', 'V030', '2016-03-22'),
(1488, 'K0222', 'EC01', 'KAWAN LAMA SEJAHTERA. PT', '', '0004552488', '', '', '', '', '', '', '', '', '', 0, '', '', '', '', '', '', '', '2014-11-07'),
(1489, 'K0322', 'EC01', 'KIRIN GRIYA INDOTAMA, PT', 'JL. GAJAH MADA NO.11 A-B', '0002363290', 'JAKARTA PUSAT', '10130', '', '', '', '', '', '', '', 30, '', '', '', '', '', '', 'V030', '2014-10-13'),
(1490, 'K0421', 'EC01', 'SUMBER ELECTRONIC', 'JL. MANGGA DUA ABDAD KOMP. BUMI JAY', '0002362478', 'JAKARTA', '00000', '', '0216280267', '', '', '0216240233', '', '', 30, '', '', '', '', '', '', 'V030', '2014-10-13'),
(1491, 'H1422', 'EC01', 'HARMONI EMPAT SELARAS, PT', 'JLN. DIKLAT PEMDA NO. 73', '0005927525', 'TANGGERANG', '15810', '', '85929864539', '', '', '215374702', '31.808.772.3-451.000', 'CANDRAYOGI33@YAHOO.CO.ID', 30, '', '', '', '', '', '', 'V030', '2015-06-22'),
(1492, 'H1525', 'EC01', 'HOME CREDIT INDONESIA, PT', 'LT. 8 PLAZA OLEOS', '0006531828', 'JAKARTA SELATAN', '12950', '', '2129539655', '', '', '2122780155', '03.193.870.7-021.000', 'SIEZI.NATASHA@HOMECREDIT.CO.ID', 7, '', '', '', '', '', '', 'V007', '2016-03-02'),
(1493, 'H1621', 'EC01', 'HEWLETT PACKARD INDONESIA, PT', 'GD. PERKANTORAN PRUDENTIAL CENTER', '0006940948', 'JAKARTA SELATAN', '12870', '', '29639999', '', '', '2129626101', '01.070.716.4-058.000', 'SUSANTO.SETIAWAN@HP.COM', 45, '', '', '', '', '', '', 'V045', '2016-08-16'),
(1494, 'H2122', 'EC01', 'HARRISMA AGUNG JAYA, PT', 'TAMAN KEBON JERUK BLOK A4 NO.6 JLN.', '0002363225', 'JAKARTA BARAT', '11650', '', '', '', '', '', '06.663.581.4-086.000', '', 30, '', '', '', '', '', '', 'V030', '2014-10-13'),
(1495, 'I0121', 'EC01', 'INTI MEGA SWARA, PT', 'TAMAN SARI RAYA NO. 66', '0002362420', 'JAKARTA BARAT', '11150', '', '02163855511', '', '', '02163855950', '01.899.741.1-032.000', 'ardan@imsind.co.id', 30, '', '', '', '', '', '', 'V030', '2014-10-13'),
(1496, 'I0122', 'EC01', 'INTI MEGA SWARA, PT', 'TAMAN SARI RAYA NO. 66', '0002363229', 'JAKARTA BARAT', '11150', '', '', '', '', '', '01.899.741.1-032.000', '', 30, '', '', '', '', '', '', 'V030', '2014-10-13'),
(1497, 'I0221', 'EC01', 'ISTANA ARGO KENCANA, PT', 'Jl. Pluit Raya No.19', '0002362425', 'JAKARTA UTARA', '14440', '', '0216626480', '', '', '0216626484', '01.644.974.6.046.000', 'jefry.1@sankencorp.com', 45, '', '', '', '', '', '', 'V045', '2014-10-13'),
(1498, 'I0222', 'EC01', 'ISTANA ARGO KENCANA, PT', 'Jl. Pluit Raya No. 19', '0002363231', 'JAKARTA UTARA', '14440', '', '', '', '', '', '01.644.974.6.046.000', '', 30, '', '', '', '', '', '', 'V030', '2014-10-13'),
(1499, 'I0241', 'EC01', 'ISTANA ARGO KENCANA, PT', 'Jl. Pluit Raya No.19', '0002362430', 'JAKARTA UTARA', '14440', '', '0216626480', '', '', '0216626484', '', 'suryanto@sankencorp.com', 45, '', '', '', '', '', '', 'V045', '2014-10-13'),
(1500, 'I0321', 'EC01', 'INDOMO MULIA, PT', 'JL. PROF.Dr.SATRIO C-4 NO.13', '0002362431', 'JAKARTA SELATAN', '15134', '', '02129969500', '', '', '02129969583', '01.528.853.3.415.000', 'sales.modern@ikomputer.com', 45, '', '', '', '', '', '', 'V045', '2014-10-13');
INSERT INTO `api_vendor` (`id`, `supplierCode`, `companyCode`, `name`, `address1`, `address2`, `city`, `postalCode`, `contactPerson`, `phone`, `hp1`, `hp2`, `fax`, `npwp`, `email`, `paymentTerm`, `bankCode`, `bankName`, `bankBranchCode`, `bankBranchName`, `bankAccountNo`, `status`, `paymentTermCd`, `dateCreate`) VALUES
(1501, 'I0322', 'EC01', 'INDOMO MULIA, PT', 'JL. Prof.Dr.Satrio C-4 No.13', '0002363236', 'JAKARTA', '12950', '', '', '', '', '', '01.528.853.3.415.000', '', 30, '', '', '', '', '', '', 'V030', '2014-10-13'),
(1502, 'I0511', 'EC01', 'SUMBER ELECTRONIC', 'JL. MANGGA DUA ABDAD KOMP. BUMI JAY', '0002362436', 'JAKARTA', '00000', '', '0', '', '', '0216323843', '', '', 30, '', '', '', '', '', '', 'V030', '2014-10-13'),
(1503, 'I0521', 'EC01', 'INDO SUCCESS', 'JL. PASAR GLODOK SELATAN NO.2', '0002362441', 'JAKARTA', '11120', '', '0216593723', '', '', '0216323843', '01.315.856.3.032.000', 'maman@ptisc.com', 45, '', '', '', '', '', '', 'V045', '2014-10-13'),
(1504, 'I0522', 'EC01', 'INDO SUCCESS', 'JL. PASAR GLODOK SELATAN NO.2', '0002363241', 'JAKARTA', '11120', '', '', '', '', '', '01.315.856.3.032.000', '', 30, '', '', '', '', '', '', 'V030', '2014-10-13'),
(1505, 'I0542', 'EC01', 'INDO SUCCESS', 'JL. PASAR GLODOK SELATAN NO.2', '0002363242', 'JAKARTA', '11120', '', '', '', '', '', '', '', 30, '', '', '', '', '', '', 'V030', '2014-10-13'),
(1506, 'I1022', 'EC01', 'INDOSAT. PT', '', '0004552486', '', '', '', '', '', '', '', '', '', 0, '', '', '', '', '', '', '', '2014-11-07'),
(1507, 'I1121', 'EC01', 'SUMBER ELECTRONIC', 'KOMP.MANGGA DUA ABDAD JL.BUMI JAYAK', '0002362446', 'JAKARTA', '00000', '', '0216593723', '', '', '0216323843', '', '', 30, '', '', '', '', '', '', 'V030', '2014-10-13'),
(1508, 'I1222', 'EC01', 'INTERSYS. PT', '', '0004552487', '', '', '', '', '', '', '', '', '', 0, '', '', '', '', '', '', '', '2014-11-07'),
(1509, 'I1422', 'EC01', 'SUMBER ELECTRONIC', '', '0002363247', '', '00000', '', '', '', '', '', '', '', 30, '', '', '', '', '', '', 'V030', '2014-10-13'),
(1510, 'I2321', 'EC01', 'INTERNUSA MANDIRI, PT', 'KOMP.RUKO ROXY MAS BLOK D4 NO.2', '0002362447', 'JAKARTA', '10150', '', '02196673777', '', '', '02163860974', '21.074.791.1.028.000', 'marketing.modernjkt@internusamandiri.com', 45, '', '', '', '', '', '', 'V045', '2014-10-13'),
(1511, 'I2322', 'EC01', 'INTERNUSA MANDIRI, PT', 'KOMP.RUKO ROXY MAS BLOK D4 NO.2', '0002363251', 'JAKARTA', '10150', '', '', '', '', '', '21.074.791.1.028.000', '', 30, '', '', '', '', '', '', 'V030', '2014-10-13'),
(1512, 'I2422', 'EC01', 'INTERNATIONAL TRADING CO.CV', 'Komplek Agung Sedayu Blok H No.24 J', '0002363253', 'JAKARTA', '10730', '', '', '', '', '', '02.530.619.2-026.000', '', 30, '', '', '', '', '', '', 'V030', '2014-10-13'),
(1513, 'I2621', 'EC01', 'INFORMASI TEKNOLOGI INDONESIA, PT', 'GRAHA ORANGE, JL MAMPANG PRAPATAN R', '0002362452', 'JAKARTA SELATAN', '12790', '', '0217940946', '', '', '0217941107', '02.139.745.0-058.000', 'septy.handayani@jatis.com', 45, '', '', '', '', '', '', 'V045', '2014-10-13'),
(1514, 'I2622', 'EC01', 'INFORMASI TEKNOLOGI INDONESIA, PT', 'GRAHA ORANGE, JL MAMPANG PRAPATAN R', '0002363258', 'JAKARTA SELATAN', '12790', '', '', '', '', '', '02.139.745.0-058.000', '', 30, '', '', '', '', '', '', 'V030', '2014-10-13'),
(1515, 'I2721', 'EC01', 'INTER DIGITAL SOLUTIONS, CV', 'JL. DAAN MOGOT KM 13', '0002362457', 'JAKARTA BARAT', '10730', '', '0216597133', '', '', '0216126671', '02.530.336.3-026.000', 'johanes@v-gen.web.id', 45, '', '', '', '', '', '', 'V045', '2014-10-13'),
(1516, 'I2722', 'EC01', 'INTER DIGITAL SOLUTIONS, CV', 'JL. DAAN MOGOT KM 13', '0002363263', 'JAKARTA BARAT', '10730', '', '', '', '', '', '02.530.336.3-026.000', '', 30, '', '', '', '', '', '', 'V030', '2014-10-13'),
(1517, 'I2822', 'EC01', 'ISOUND INDONESIA, PT', 'RUKO HARKO MANGGA DUA I-5', '0002363264', 'DKI JAKARTA', '10730', '', '', '', '', '', '31.813.779.1-026.000', '', 30, '', '', '', '', '', '', 'V030', '2014-10-13'),
(1518, 'I2922', 'EC01', 'ITECH BERKAT UTAMA, PT', 'JL. MANGGA DUA RY BLOK H/18 MANGGA', '0002363269', 'JAKARTA PUSAT', '10730', '', '', '', '', '', 'PEM-00671/WPJ.06/KP.', '', 30, '', '', '', '', '', '', 'V030', '2014-10-13'),
(1519, 'I3021', 'EC01', 'INDOCRAFT MAKMUR, CV', 'DELATINOS, HACIENDA MEXICANA BLOK C', '0002362458', 'TANGERANG SELATAN', '15318', '', '02175883768', '', '', '02175883769', 'PEM- /WPJ.04/KP.06', 'haryanto.sunjaya@rumahflashdisk.com', 45, '', '', '', '', '', '', 'V045', '2014-10-13'),
(1520, 'I3022', 'EC01', 'INDOCRAFT MAKMUR, CV', 'DELATINOS, HACIENDA MEXICANA BLOK C', '0002363274', 'TANGERANG SELATAN', '15318', '', '', '', '', '', 'PEM- /WPJ.04/KP.06', '', 30, '', '', '', '', '', '', 'V030', '2014-10-13'),
(1521, 'M0622', 'EC01', 'MAYER SUKSES JAYA, PT', 'JL.ABDUL RAHMAN SALEH NO.23 JURUMUD', '0002363343', 'TANGERANG', '00000', '', '', '', '', '', '01.900.961.2-036.000', '', 30, '', '', '', '', '', '', 'V030', '2014-10-13'),
(1522, 'M0721', 'EC01', 'MAJU MANDIRI UTAMA, PT', 'JL. KOTA BARU NO.14', '0002362527', 'JAKARTA PUSAT', '00000', '', '02163860972', '', '', '02163860974', '01.324.554.3.073.000', 'alex.kurniawan@majumandiri.com', 30, '', '', '', '', '', '', 'V030', '2014-10-13'),
(1523, 'M0722', 'EC01', 'MAJU MANDIRI UTAMA, PT', 'JL. KOTA BARU NO.14', '0002363348', 'JAKARTA PUSAT', '00000', '', '', '', '', '', '01.324.554.3.073.000', '', 30, '', '', '', '', '', '', 'V030', '2014-10-13'),
(1524, 'M0811', 'EC01', 'SUMBER ELECTRONIC', 'JL.RAYA PERJUANGAN NO.88 GEDUNG GRA', '0002362528', 'JAKARTA', '11530', '', '02153660739', '', '', '02153660723', '', '', 30, '', '', '', '', '', '', 'V030', '2014-10-13'),
(1525, 'M0821', 'EC01', 'MITRA GLOBAL UTAMA INTERNASIONAL', 'BLOK BD RUKO GRAHA KENCANA', '0002362533', 'JAKARTA BARAT', '11530', '', '02153660739', '', '', '0215359060', '0019037993035000', 'elly@acme707.com', 45, '', '', '', '', '', '', 'V045', '2014-10-13'),
(1526, 'M0822', 'EC01', 'MITRA GLOBAL UTAMA INTERNASIONAL', 'BLOK BD RUKO GRAHA KENCANA', '0002363349', 'JAKARTA BARAT', '11530', '', '', '', '', '', '0019037993035000', '', 30, '', '', '', '', '', '', 'V030', '2014-10-13'),
(1527, 'M0921', 'EC01', 'MEGA SUKSES JAYA, PT', 'JL.GUNUNG SAHARI RAYA NO.2 KOMP.MAR', '0002362538', 'JAKARTA PUSAT', '14240', '', '0216411362', '', '', '0216411363', '', 'andry.setiadi@megasuksesjaya.com', 30, '', '', '', '', '', '', 'V030', '2014-10-13'),
(1528, 'M0922', 'EC01', 'MEGA SUKSES JAYA, PT', 'JL. GUNUNG SAHARI RAYA NO.2 KOMP MA', '0002363354', 'JAKARTA PUSAT', '14240', '', '', '', '', '', '02.186.206.5-044.000', '', 30, '', '', '', '', '', '', 'V030', '2014-10-13'),
(1529, 'M1021', 'EC01', 'SUMBER ELECTRONIC', 'KAWASAN CBD PLUIT BLOK S 15-16 JLN.', '0002362543', 'JAKARTA UTARA', '00000', '', '02166675301', '', '', '02166675305', '', '', 30, '', '', '', '', '', '', 'V030', '2014-10-13'),
(1530, 'M1022', 'EC01', 'MITRA USAHA CEMERLANG', 'KAWASAN CBD PLUIT BLOK S 15-16 JLN.', '0002363359', 'JAKARTA UTARA', '00000', '', '', '', '', '', '', '', 30, '', '', '', '', '', '', 'V030', '2014-10-13'),
(1531, 'M1121', 'EC01', 'SUMBER ELECTRONIC', 'JL. MANGGA DUA ABDAD KOMP. BUMI JAY', '0002362544', 'JAKARTA', '00000', '', '0', '', '', '0215494048', '', '', 30, '', '', '', '', '', '', 'V030', '2014-10-13'),
(1532, 'M1122', 'EC01', 'MACINDO SWADESI', 'JL. PERJUANGAN NO.88', '0002363364', 'JAKARTA', '11530', '', '', '', '', '', '', '', 30, '', '', '', '', '', '', 'V030', '2014-10-13'),
(1533, 'M1221', 'EC01', 'MODERN PHOTO, TBK', 'JL. MATRAMAN RAYA NO. 12 LT.4', '0002362549', 'JAKARTA', '13150', '', '', '', '', '0', '', '', 30, '', '', '', '', '', '', 'V030', '2014-10-13'),
(1534, 'M1422', 'EC01', 'MAKMUR SEJAHTERA', 'JL. P. JAYAKARTA 131 BLOK 20-20A', '0002363365', 'JAKARTA', '10730', '', '', '', '', '', '', '', 30, '', '', '', '', '', '', 'V030', '2014-10-13'),
(1535, 'M1622', 'EC01', 'MOBITEL INDONESIA, PT', 'JL. DR. MUWARDI 2 NO. 25 A KEL : GR', '0002363370', 'URAN, JAKARTA BARAT', '11450', '', '', '', '', '', '', '', 30, '', '', '', '', '', '', 'V030', '2014-10-13'),
(1536, 'M1722', 'EC01', 'METRODATA ELECTRONICS, PT', 'JL.JEND SUDIRMAN KAV 29-31 WISMA ME', '0002363375', 'JAKARTA', '12920', '', '', '', '', '', '', '', 21, '', '', '', '', '', '', 'V021', '2014-10-13'),
(1537, 'M1922', 'EC01', 'METROTECH JAYA KOMUNIKA, PT', 'BLUE DOT CENTER BLOK H JL.GELANG BA', '0002363380', 'JAKARTA BARAT', '11440', '', '', '', '', '', '', '', 21, '', '', '', '', '', '', 'V021', '2014-10-13'),
(1538, 'M2022', 'EC01', 'METRODATA E-BISNIS, PT', 'JL.JEND SUDIRMAN KAV 29-31 WISMA ME', '0002363381', 'JAKARTA SELATAN', '12920', '', '', '', '', '', '', '', 30, '', '', '', '', '', '', 'V030', '2014-10-13'),
(1539, 'K0521', 'EC01', 'KENCANA SAKTI, UD', 'JL.RAYA PERJUANGAN NO.21 LT.8', '0002362479', 'JAKARTA', '00000', '', '0215323808', '', '', '0215333344', '', '', 30, '', '', '', '', '', '', 'V030', '2014-10-13'),
(1540, 'K0621', 'EC01', 'KARYA GEMILANG,PT', 'Gg. ANWAR II No. 24 KAMPUNG MELAYU', '0002362484', '', '00000', '', '0215362005', '', '', '0215362033', '', '', 14, '', '', '', '', '', '', 'V014', '2014-10-13'),
(1541, 'K0921', 'EC01', 'SUMBER ELECTRONIC', 'JL.MANGGA DUA ABDAD', '0002362489', 'KOMP.BUMI JAYAKARTA INDAH', '00000', '', '0', '', '', '0216292901', '', '', 30, '', '', '', '', '', '', 'V030', '2014-10-13'),
(1542, 'K1022', 'EC01', 'KOPERASI KARYAWAN MITRA USAHA DINAM', 'WISMA BAKRIE I LT4, JL HR RASUNA SA', '0002363295', 'JAKARTA SELATAN', '12920', '', '', '', '', '', 'PEM-00286/WPJ.04/KP.', '', 30, '', '', '', '', '', '', 'V030', '2014-10-13'),
(1543, 'K1121', 'EC01', 'KUSUMOMEGAH JAYASAKTI, PT', 'JL. SAWAH LIO RAYA NO. 8C', '0002362494', 'JAKARTA BARAT', '11250', '', '0216339360', '', '', '0216335918', '', 'winardi@procom-mart.com', 45, '', '', '', '', '', '', 'V045', '2014-10-13'),
(1544, 'K1122', 'EC01', 'KUSUMOMEGAH JAYASAKTI, PT', 'JL. SAWAH LIO RAYA NO. 8C', '0002363300', 'JAKARTA BARAT', '11250', '', '', '', '', '', '', '', 30, '', '', '', '', '', '', 'V030', '2014-10-13'),
(1545, 'K1221', 'EC01', 'KASINDO GRAHA KENCANA, PT', 'RUKO THE CENTRO METRO BROADWAY', '0002362495', 'JAKARTA', '14440', '', '02130010223', '', '', '02166675305', '', 'donnatjo@kasindo.co.id', 45, '', '', '', '', '', '', 'V045', '2014-10-13'),
(1546, 'K1222', 'EC01', 'KASINDO GRAHA KENCANA, PT', 'RUKO THE CENTRO METRO BROADWAY', '0002363305', 'JAKARTA', '14440', '', '02130010223', '', '', '', '', '', 30, '', '', '', '', '', '', 'V030', '2014-10-13'),
(1547, 'K1322', 'EC01', 'KARCHER, PT', 'SUDIRMAN PARK COMPLEX BLOCK A6-A7,', '0002363309', 'JAKARTA', '10220', '', '', '', '', '', 'PEM-03316/WPJ.04/KP.', '', 30, '', '', '', '', '', '', 'V030', '2014-10-13'),
(1548, 'K1342', 'EC01', 'KARCHER, PT', 'SUDIRMAN PARK COMPLEX BLOCK A6-A7,', '0002363311', 'JAKARTA', '10220', '', '', '', '', '', 'PEM-03316/WPJ.04/KP.', '', 30, '', '', '', '', '', '', 'V030', '2014-10-13'),
(1549, 'K1422', 'EC01', 'KAWAN LAMA INTERNUSA, PT', '1 JL. PURI KENCANA', '0004548063', 'MERUYA', '11610', '', '215824002', '', '', '215824020', '01.660.045.4-038.000', 'GARRY.MARCHO@KAWANLAMAINTERNUSA.COM', 30, '', '', '', '', '', '', 'V030', '2014-11-04'),
(1550, 'K1423', 'EC01', 'KAWAN LAMA INTERNUSA, PT', 'JL. PURI KENCANA', '0007310733', 'MERUYA', '11610', '', '215824002', '', '', '215824020', '01.660.045.4-038.000', 'GARRY.MARCHO@KAWANLAMAINTERNUSA.COM', 30, '', '', '', '', '', '', 'V030', '2017-01-06'),
(1551, 'K1523', 'EC01', 'KAWAN LAMA INTERNUSA, PT', 'JL. PURI KENCANA', '0007353652', 'MERUYA', '11610', '', '215824002', '', '', '215824020', '01.660.045.4-038.000', 'ALEXANDERTW@KAWANLAMAINTERNUSA.COM', 30, '', '', '', '', '', '', 'V030', '2017-01-25'),
(1552, 'L0111', 'EC01', 'SUMBER ELECTRONIC', 'JL. MANGGA DUA ABDAD KOMP. BUMI JAY', '0002362500', 'JAKARTA', '00000', '', '02153660309', '', '', '0215482858', '', '', 30, '', '', '', '', '', '', 'V030', '2014-10-13'),
(1553, 'L0121', 'EC01', 'LG ELECTRONICS INDONESIA, PT', 'GANDARIA 8 OFFICE TOWER LT 31 JLN S', '0002362505', 'KEBAYORAN LAMA, JKT-SEL', '12240', '', '02129304000', '', '', '02129303998', '01.069.323.2-092.000', 'david.nendra@lge.com', 30, '', '', '', '', '', '', 'V030', '2014-10-13'),
(1554, 'L0122', 'EC01', 'LG ELECTRONICS INDONESIA, PT', 'JL. S.PARMAN KAV 77 WISMA 77 LT. 15', '0002363316', 'JAKARTA BARAT', '00000', '', '', '', '', '', '01.069.323.2-092.000', '', 30, '', '', '', '', '', '', 'V030', '2014-10-13'),
(1555, 'L0221', 'EC01', 'SUMBER ELECTRONIC', 'JL. MANGGA DUA ABDAD KOMP. BUMI JAY', '0002362510', 'JAKARTA', '00000', '', '0', '', '', '0216305248', '', '', 30, '', '', '', '', '', '', 'V030', '2014-10-13'),
(1556, 'L0322', 'EC01', 'LUGGAGE DISTRIBUTOR INDONESIA, PT', 'DEPOK TOWN SQUARE UNIT GE.2 NO.7 JL', '0002363317', 'DEPOK', '16424', '', '', '', '', '', '02.461.900.9-412.000', '', 30, '', '', '', '', '', '', 'V030', '2014-10-13'),
(1557, 'L0323', 'EC01', 'LUGGAGE DISTRIBUTOR INDONESIA, PT', 'NO.9 TAMAN TEKNO BDS SEKTOR XI H3', '0007353264', 'TANGGERANG SELATAN', '15314', '', '217563777', '', '', '217566333', '0024619009412000', 'priya@bagscity.co.id', 30, '', '', '', '', '', '', 'V030', '2017-01-25'),
(1558, 'L0421', 'EC01', 'LOA KHE TJAN, TOKO', ' KOMPLEK AGUNG SEDAYU', '0004609082', 'JAKARTA PUSAT', '11120', '', '216121112', '', '', '216126579', '04.207.443.5-037.000', 'LOAKHETJAN@CBN.NET.ID', 45, '', '', '', '', '', '', 'V045', '2014-12-04'),
(1559, 'L0522', 'EC01', 'LYNEA PRIMISIMA, PT', 'NO. 20 KAWASAN RUKO PURI MANSION BL', '0005864438', 'JAKARTA BARAT', '11610', '', '29866860', '', '', '29866861', '01.656.967.5-086.000', 'SUSAN@LYNEA.CO.ID', 30, '', '', '', '', '', '', 'V030', '2015-05-20'),
(1560, 'L0621', 'EC01', 'LENOVO INDONESIA, PT', 'WISMA 46 KOTA BNI LT.19 SUITE 19.05', '0006779984', 'DKI JAKARTA', '10220', '', '2130021000', '', '', '2130021099', '02.930.965.5-022.000', 'NTAN@LENOVO.COM', 45, '', '', '', '', '', '', 'V045', '2016-06-16'),
(1561, 'M0121', 'EC01', 'MULTI ALAM ELOK, PT', 'JL. KH. HASYIM ASHARI 31', '0002362511', 'JAKARTA PUSAT', '00000', '', '02163863429', '', '', '02163863431', '01.363.351.6-028.000', 'hypermae@ymail.com', 45, '', '', '', '', '', '', 'V045', '2014-10-13'),
(1562, 'M0122', 'EC01', 'MULTI ALAM ELOK, PT', 'JL. KH. HASYIM ASHARI 31', '0002363322', 'JAKARTA PUSAT', '00000', '', '', '', '', '', '01.363.351.6-028.000', '', 30, '', '', '', '', '', '', 'V030', '2014-10-13'),
(1563, 'M0221', 'EC01', 'MEGATRAND SEMESTA, PT', 'JL. AM SANGAJI 9 N', '0002362516', 'JAKARTA PUSAT', '10130', '', '0215849211', '', '', '0215849215', '', 'agus@crystal-indonesia.com', 45, '', '', '', '', '', '', 'V045', '2014-10-13'),
(1564, 'M0222', 'EC01', 'MEGATRAND SEMESTA, PT', 'JL. AM SANGAJI 9 N', '0002363327', 'JAKARTA PUSAT', '10130', '', '', '', '', '', '', '', 30, '', '', '', '', '', '', 'V030', '2014-10-13'),
(1565, 'M0322', 'EC01', 'MULTI MAYAKA, PT', 'JL. RAWA GELAM III No.2 KAWASAN IND', '0002363332', 'JAKARTA TIMUR', '13930', '', '', '', '', '', '01.300.571.5-007.000', '', 30, '', '', '', '', '', '', 'V030', '2014-10-13'),
(1566, 'M0412', 'EC01', 'MITRA CASPERTAMA, PT', 'JL. PANGERAN JAYAKARTA 73 HOTEL IBI', '0002363333', 'JAKARTA', '10730', '', '', '', '', '', '', '', 30, '', '', '', '', '', '', 'V030', '2014-10-13'),
(1567, 'M0521', 'EC01', 'MAESTRONIC ABDI KARYA, PT', 'RUKO INKOPAL PLAZA KLP GDNG BLOK C/', '0002362521', 'BARAT RAYA- JAKARTA', '00000', '', '02145851121', '', '', '02145851779', '', '', 30, '', '', '', '', '', '', 'V030', '2014-10-13'),
(1568, 'M0522', 'EC01', 'MAESTRONIC ABDI KARYA, PT', 'RUKO INKOPAL PLAZA KLP GDNG BLOK C/', '0002363338', 'RAYA JAKARTA', '00000', '', '', '', '', '', '', '', 30, '', '', '', '', '', '', 'V030', '2014-10-13'),
(1569, 'M0621', 'EC01', 'MAYER SUKSES JAYA, PT', 'GRAND SLIPI TOWER LT. 10 MNO, JL. S', '0002362522', 'JAKARTA BARAT', '11480', '', '02129021900', '', '', '02129021899', '01.900.961.2-036.000', 'dian.alamsyah@mayersuksesjaya.com', 45, '', '', '', '', '', '', 'V045', '2014-10-13'),
(1570, 'M6521', 'EC01', 'MASPION, PT', 'MASPION PLAZA, JL. GUNUNG SAHARI RA', '0002362597', 'JAKARTA UTARA', '14420', '', '02164701000', '', '', '02164701066', 'PEM-00102/WPJ.19/KP.', 'supermarket@maspionjkt.com', 45, '', '', '', '', '', '', 'V045', '2014-10-13'),
(1571, 'M6621', 'EC01', 'MITSUBISHI ELECTRIC INDONESIA, PT', 'GEDUNG JAYA 11TH FLOOR, JL. MH. THA', '0002362601', 'JAKARTA PUSAT', '10340', '', '-', '', '', '02131923942', '03.256.170.6-021.000', 'Noviriansyah.Farouk@asia.meap.com', 45, '', '', '', '', '', '', 'V045', '2014-10-13'),
(1572, 'M6721', 'EC01', 'MANNA AUDIO, PT', 'KOMP. PERTOKOAN GLODOK JAYA 19', '0004604323', 'JAKARTA BARAT', '11180', '', '216919726', '', '', '216919731', '02.747.478.2-032.000', 'rickysam@bettersound.co.id', 45, '', '', '', '', '', '', 'V045', '2014-12-01'),
(1573, 'M6722', 'EC01', 'MANNA AUDIO, PT', 'KOMP. PERTOKOAN GLODOK JAYA 19, MAN', '0002363446', 'JAKARTA BARAT', '11180', '', '', '', '', '', '02.747.478.2-032.000', '', 30, '', '', '', '', '', '', 'V030', '2014-10-13'),
(1574, 'M6821', 'EC01', 'MY ICON TECHNOLOGY, PT', 'APL TOWER 42ND FLOOR SUITE T7 JL. L', '0002362603', 'JAKARTA', '11470', '', '02129345600', '', '', '02129345606', '0030803290036000', 'ALDRIANO.MEDISE@METRODATA.CO.ID', 45, '', '', '', '', '', '', 'V045', '2014-10-13'),
(1575, 'M6822', 'EC01', 'MY ICON TECHNOLOGY, PT', 'APL TOWER 42ND FLOOR SUITE T7 JL. L', '0002363451', 'JAKARTA', '11470', '', '', '', '', '', '0030803290036000', '', 30, '', '', '', '', '', '', 'V030', '2014-10-13'),
(1576, 'M6922', 'EC01', 'MITRALAYAN MULTI SOLUSI, PT', 'RUKO ITC ROXY MAS', '0004589678', 'JAKARTA PUSAT', '10150', '', '2163866256', '', '', '', '31.246.889.5-028.000', 'L.DARIAN94@GMAIL.COM', 45, '', '', '', '', '', '', 'V045', '2014-11-24'),
(1577, 'M7021', 'EC01', 'MITRA SARANA SUKSES', 'JL. SENTANI RAYA BLOCK C II NO. 8', '0004638608', 'JAKARTA PUSAT', '10720', '', '216414808', '', '', '216414716', '02.344.294.0-026.000', 'M_ARDAN@HOTMAIL.COM', 30, '', '', '', '', '', '', 'V030', '2014-12-16'),
(1578, 'M7022', 'EC01', 'MITRA SARANA SUKSES', 'JL. SENTANI RAYA BLOCK C II NO. 8', '0004638618', 'JAKARTA PUSAT', '10720', '', '216414808', '', '', '216414716', '02.344.294.0-026.000', 'M_ARDAN@HOTMAIL.COM', 30, '', '', '', '', '', '', 'V030', '2014-12-16'),
(1579, 'M7121', 'EC01', 'MEGA DAVIS, PT', 'JALAN KALI BESAR TIMUR NO.27B', '0005766845', 'JAKARTA BARAT', '11110', '', '216904933', '', '', '216906987', '02.379.378.9-037.000', 'hengky_thu@yahoo.com', 45, '', '', '', '', '', '', 'V045', '2015-04-02'),
(1580, 'M7122', 'EC01', 'MEGA DAVIS, PT', 'JALAN KALI BESAR TIMUR NO. 27B', '0005766979', 'JAKARTA BARAT', '11110', '', '216904933', '', '', '216906987', '02.379.378.9-037.000', 'hengky_thu@yahoo.com', 45, '', '', '', '', '', '', 'V045', '2015-04-02'),
(1581, 'M7222', 'EC01', 'MULTI INDOCIPTA NUGRAHA, PT', 'NO. 37 MANGGA DUA SQUARE BLOK D', '0005851047', 'JAKARTA UTARA', '14420', '', '8161960806', '', '', '2129382210', '31.447.149.1-044.000', 'JUNIAWATI99@YAHOO.COM', 30, '', '', '', '', '', '', 'V030', '2015-05-13'),
(1582, 'M7321', 'EC01', 'MITRACO WIRAJAYA PERDANA, PT', 'JL. ANGKE JAYA XIII/11 NO.12A', '0007063033', 'JAKARTA BARAT', '11330', '', '8118835353', '', '', '216321476', '02.293.874.0-033.000', 'RONALDI@CENTROTECHNICA.COM', 45, '', '', '', '', '', '', 'V045', '2016-10-07'),
(1583, 'M7322', 'EC01', 'MITRACO WIRAJAYA PERDANA, PT', 'NO.12A JL. ANGKE JAYA XIII/ 11 RT 0', '0005891551', 'JAKARTA BARAT', '11330', '', '8118835353', '', '', '216321476', '02.293.874.0-033.000', 'RONALDI@CENTROTECHNICA.COM', 30, '', '', '', '', '', '', 'V030', '2015-06-03'),
(1584, 'M7422', 'EC01', 'MDI TRADING, PT', 'JL.TANAH ABANG2 NO.38', '0006100723', 'JAKARTA PUSAT', '10160', '', '818699122', '', '', '213845288', '31.194.644.6-028.000', 'IMELDA@MDIAUDIO.COM', 30, '', '', '', '', '', '', 'V030', '2015-09-09'),
(1585, 'M7522', 'EC01', 'MASTE DAYAA, PT', 'C16-18 JL. PONDOK PINANG CENTER BLO', '0006155223', 'JAKARTA', '12310', '', '8119111244', '', '', '217511121', '01.303.612.4-062.000', 'ELI@HALO-ROBOTICS.COM', 30, '', '', '', '', '', '', 'V030', '2015-10-08'),
(1586, 'M7621', 'EC01', 'MULIA SUKSES JAYA,PT', 'JL. KOMPLEK HARCO MANGGA DUA', '0006376001', 'JAKARTA PUSAT', '10730', '', '2129021900', '', '', '2129021955', '02.273.161.6-026.000', 'FERRY.KURNIAWAN@MAYERSUKSESJAYA.COM', 45, '', '', '', '', '', '', 'V045', '2015-12-31'),
(1587, 'M1522', 'EC01', 'MEKAR JAYA, CV', 'JL. MEKAR MAKMUR II NO.6RT.001/004', '0007503872', '', '', '', '', '', '', '', '21.080.143.7-422.000', '', 30, '', '', '', '', '', '', 'V030', '2022-10-27'),
(1588, 'M2421', 'EC01', 'SUMBER ELECTRONIC', 'Jl. Mangga Dua Abdad Komp. Bumi Jay', '0002362554', 'JAKARTA', '00000', '', '0', '', '', '0214501348', '', '', 30, '', '', '', '', '', '', 'V030', '2014-10-13'),
(1589, 'M2512', 'EC01', 'MITRA KREASI CEMERLANG', 'PECENONGAN RAYA NO 72. RUKO ATAP ME', '0002363386', 'JAKARTA PUSAT', '00000', '', '', '', '', '', '', '', 30, '', '', '', '', '', '', 'V030', '2014-10-13'),
(1590, 'M2521', 'EC01', 'SUMBER ELECTRONIC', 'JL. MANGGA DUA ABDAD KOMP. BUMI JAY', '0002362559', 'JAKARTA', '00000', '', '0', '', '', '0213503537', '', '', 45, '', '', '', '', '', '', 'V045', '2014-10-13'),
(1591, 'M3121', 'EC01', 'SUMBER ELECTRONIC', '', '0002362560', '', '00000', '', '', '', '', '0', '', '', 30, '', '', '', '', '', '', 'V030', '2014-10-13'),
(1592, 'M3622', 'EC01', 'MULTI TEHAKA. PT', '', '0004552489', '', '', '', '', '', '', '', '', '', 0, '', '', '', '', '', '', '', '2014-11-07'),
(1593, 'M3722', 'EC01', 'MEGA MAS MANDIRI, CV', 'JL.KEMENGAN III NO.96', '0002363390', 'JAKARTA', '11120', '', '', '', '', '', '', '', 30, '', '', '', '', '', '', 'V030', '2014-10-13'),
(1594, 'M3922', 'EC01', 'MENZER MASINDO, PT', 'JL. CIDENG TIMUR NO.96', '0002363392', 'JAKARTA', '00000', '', '', '', '', '', '', '', 30, '', '', '', '', '', '', 'V030', '2014-10-13'),
(1595, 'M4022', 'EC01', 'MARIKATAMA KREASI CEMERLANG', 'JL. PECENONGAN NO. 72 RUKO ATAP MER', '0002363397', 'JAKARTA', '10120', '', '', '', '', '', '', '', 30, '', '', '', '', '', '', 'V030', '2014-10-13'),
(1596, 'M4221', 'EC01', 'SUMBER ELECTRONIC', 'KOMP.MANGGA DUA ABDAD. JL BUMI JAYA', '0002362565', 'JAKARTA UTARA', '00000', '', '', '', '', '', '', '', 30, '', '', '', '', '', '', 'V030', '2014-10-13'),
(1597, 'M4321', 'EC01', 'MODERN PUTERA INDONESIA', 'JL.MANGGA BESAR RAYA NO.34', '0002362570', 'JAKARTA BARAT', '00000', '', '0216240808', '', '', '0216298161', '', '', 30, '', '', '', '', '', '', 'V030', '2014-10-13'),
(1598, 'M4522', 'EC01', 'MULTI KONTROL NUSANTARA', 'WISMA BAKRIE LT2 JL. RASUNA SAID KA', '0002363398', 'JAKARTA SELATAN', '00000', '', '', '', '', '', '', '', 21, '', '', '', '', '', '', 'V021', '2014-10-13'),
(1599, 'M4621', 'EC01', 'SUMBER ELECTRONIC', 'JL. MANGGA DUA ABDAD KOMP. BUMI JAY', '0002362571', 'JAKARTA', '00000', '', '0', '', '', '0215494048', '', '', 30, '', '', '', '', '', '', 'V030', '2014-10-13'),
(1600, 'M4725', 'EC01', 'MNC SKYVISION, PT', 'JL. RAYA PANJANG GREEN GARDEN BLOK', '0003978762', 'JAKARTA BARAT', '11520', '', '', '', '', '', '', '', 30, '', '', '', '', '', '', 'V030', '2014-10-15'),
(1601, 'M4921', 'EC01', 'MEGA MITRA SEJATI, PT', 'Jl. Marina Raya Rukan Exclusive D/2', '0002362576', 'JAKARTA', '14470', '', '-', '', '', '02155965960', '', 'kiki@mega.co.id', 30, '', '', '', '', '', '', 'V030', '2014-10-13'),
(1602, 'M4922', 'EC01', 'MEGA MITRA SEJATI, PT', 'Jl. Marina Raya Rukan Exclusive D/2', '0002363403', 'JAKARTA', '14470', '', '', '', '', '', '', '', 30, '', '', '', '', '', '', 'V030', '2014-10-13'),
(1603, 'M5221', 'EC01', 'MULTIFORTUNA SINARDELTA, PT', 'SUDIRMAN PLAZA', '0006763501', 'JAKARTA SELATAN', '12910', '', '8111993350', '', '', '2157937009', '01.589.204.5-038.000', 'NURDIN@MULTIFORTUNA.COM', 45, '', '', '', '', '', '', 'V045', '2016-06-09'),
(1604, 'M5222', 'EC01', 'MULTIFORTUNA SINARDELTA, PT', 'Sudirman Plaza,Plaza marein 8th Flo', '0002363408', '76-78 JAKARTA', '12910', '', '', '', '', '', '01.589.204.5.038.000', '', 30, '', '', '', '', '', '', 'V030', '2014-10-13'),
(1605, 'M5322', 'EC01', 'MAGIC HOMESYS, PT', 'Jl. Plaju / 11 Apt, Citylofts Suite', '0002363413', 'JAKARTA', '10220', '', '', '', '', '', '02.930.094.4.026.000', '', 30, '', '', '', '', '', '', 'V030', '2014-10-13'),
(1606, 'M5621', 'EC01', 'MLW TELECOM, PT', 'Jl. Raya Jembatan Dua No. 16/2', '0002362581', 'JAKARTA UTARA', '14450', '', '0216618222', '', '', '0216600488', '02.379.136.1.041.000', 'devie.djuanita@mlwtelecom.com', 45, '', '', '', '', '', '', 'V045', '2014-10-13'),
(1607, 'M5622', 'EC01', 'MLW TELECOM, PT', 'Jl. Raya Jembatan Dua No. 16/2', '0002363418', 'JAKARTA UTARA', '14450', '', '', '', '', '', '02.379.136.1.041.000', '', 30, '', '', '', '', '', '', 'V030', '2014-10-13'),
(1608, 'M5721', 'EC01', 'MAHLIGAI, PT', 'PP GLODOK PLAZA', '0006708936', '', '11180', '', '8161817956', '', '', '215377142', '02.861.104.4-032.000', 'william.putra@yahoo.com', 30, '', '', '', '', '', '', 'V030', '2016-05-16'),
(1609, 'M5822', 'EC01', 'MULTI SUKSES MANDIRI, PD', 'JLN. JANUR ASRI 2 BLOK QL-4/12, KEL', '0002363419', 'JAKARTA UTARA', '14240', '', '', '', '', '', '21.123.116.2.003.000', '', 30, '', '', '', '', '', '', 'V030', '2014-10-13'),
(1610, 'M5921', 'EC01', 'MIDEA PLANET INDONESIA, PT', 'Menara Imperium 10th Floor Suite D.', '0002362586', 'JAKARTA', '12980', '', '02160239889', '', '', '0216632804', '02.993.310.8-018.000', 'kris@midea.co.id', 45, '', '', '', '', '', '', 'V045', '2014-10-13'),
(1611, 'M5922', 'EC01', 'MIDEA PLANET INDONESIA, PT', 'Menara Imperium 10th Floor Suite D.', '0002363424', 'JAKARTA', '12980', '', '', '', '', '', '02.993.310.8-018.000', '', 30, '', '', '', '', '', '', 'V030', '2014-10-13'),
(1612, 'M6021', 'EC01', 'MY RASCH INDONESIA, PT', 'RUKO PERMATA ANCOL BL L/38 JL. RE M', '0002362587', 'JAKARTA UTARA', '14420', '', '0216455820', '', '', '0216313860', '02.540.906.1-044.000', 'agus9000@ymail.com', 45, '', '', '', '', '', '', 'V045', '2014-10-13'),
(1613, 'M6022', 'EC01', 'MY RASCH INDONESIA, PT', 'RUKO PERMATA ANCOL BL L/38 JL. RE M', '0002363425', 'JAKARTA UTARA', '14420', '', '', '', '', '', '02.540.906.1-044.000', '', 30, '', '', '', '', '', '', 'V030', '2014-10-13'),
(1614, 'M6121', 'EC01', 'MODERN INTERNASIONAL, PT', 'JL. MATRAMAN RAYA NO.12', '0002362592', 'JAKARTA TIMUR', '13150', '', '0212801000', '', '', '0218504921', '01.001.822.4-054.000', 'ngurah@moderninternasional.co.id', 45, '', '', '', '', '', '', 'V045', '2014-10-13'),
(1615, 'M6122', 'EC01', 'MODERN INTERNASIONAL, PT', 'JL. MATRAMAN RAYA NO.12', '0002363430', 'JAKARTA TIMUR', '13150', '', '', '', '', '', '01.001.822.4-054.000', '', 30, '', '', '', '', '', '', 'V030', '2014-10-13'),
(1616, 'M6222', 'EC01', 'METRINDO SUPRA SINATRIA, PT', 'WISMA CORMIC, JL. SURYOPRANOTO NO.1', '0002363435', 'DKI JAKARTA', '10160', '', '', '', '', '', '01.357.979.2-073.000', '', 30, '', '', '', '', '', '', 'V030', '2014-10-13'),
(1617, 'M6225', 'EC01', 'MEGA MEDIA INDONESIA, PT', 'MENARA IMPERIUM LT. 11 SUITE B-1 JL', '0003978761', 'JAKARTA', '12980', '', '021-50229911', '', '', '021-50591911', 'PEM-01555/WPJ.04/KP.', 'denni.muharam@gmail.com', 30, '', '', '', '', '', '', 'V030', '2014-10-15'),
(1618, 'M6322', 'EC01', 'MULTI SARANA PERSADA, PT', 'JL. GEDONG PANJANG NO. 19', '0002363436', 'JAKARTA BARAT', '11240', '', '', '', '', '', '02.379.270.8-033.000', '', 30, '', '', '', '', '', '', 'V030', '2014-10-13'),
(1619, 'M6422', 'EC01', 'MITRA KOMUNIKASI NUSANTARA, PT', 'AXA TOWER 32ND FLOOR, SUITE 03-05,', '0002363441', 'JAKARTA SELATAN', '12940', '', '', '', '', '', '21.046.850.0-028.000', '', 30, '', '', '', '', '', '', 'V030', '2014-10-13'),
(1620, 'O1122', 'EC01', 'OMID HEALTH STYLE, PT', 'JL. KEMANG RAYA NO.69C', '0007503877', 'JAKARTA SELATAN', '12730', '', '', '', '', '', '90.788.163.5-021.000', '', 30, '', '', '', '', '', '', 'V030', '2022-10-27'),
(1621, 'P0421', 'EC01', 'PLANET ELECTRINDO, PT', 'MENARA IMPERIUM LT.10, SUITE A&D, J', '0002362646', 'JAKARTA SELATAN', '12980', '', '0218354111', '', '', '0214610002', '01.837.433.0.046.000', 'ridwankadi@electric.co.id', 45, '', '', '', '', '', '', 'V045', '2014-10-13'),
(1622, 'P0422', 'EC01', 'PLANET ELECTRINDO, PT', 'MENARA IMPERIUM LT.10, SUITE A&D, J', '0002363489', 'JAKARTA SELATN', '12980', '', '', '', '', '', '01.837.433.0.046.000', '', 30, '', '', '', '', '', '', 'V030', '2014-10-13'),
(1623, 'P0621', 'EC01', 'SUMBER ELECTRONIC', 'JL. MANGGA DUA ABDAD KOMP. BUMI JAY', '0002362647', 'JAKARTA', '00000', '', '0', '', '', '0216335918', '', '', 30, '', '', '', '', '', '', 'V030', '2014-10-13'),
(1624, 'P0722', 'EC01', 'PRIMA PRATAMA', 'JL. PANGERAN JAYAKARTA NO. 73A', '0002363494', 'JAKARTA', '10730', '', '', '', '', '', '', '', 30, '', '', '', '', '', '', 'V030', '2014-10-13'),
(1625, 'P0821', 'EC01', 'PANACELL, PT', 'RUKAN EXLUSIVE BLOCK B/56, PANTAI I', '0002362652', 'JAKARTA', '14470', '', '', '', '', '0216450377', '', '', 30, '', '', '', '', '', '', 'V030', '2014-10-13'),
(1626, 'P0822', 'EC01', 'PANACELL, PT', 'RUKAN EXLUSIVE BLOCK B/56, PANTAI I', '0002363499', 'JAKARTA', '14470', '', '', '', '', '', '', '', 30, '', '', '', '', '', '', 'V030', '2014-10-13'),
(1627, 'P0831', 'EC01', 'PANACELL, PT', 'RUKAN EXLUSIVE', '0004475182', 'JAKARTA', '14470', '', '2155965828', '', '', '2155965827', '', 'PANACELL1@YAHOO.COM', 30, '', '', '', '', '', '', 'V030', '2014-10-31'),
(1628, 'P0832', 'EC01', 'PANACELL, PT', 'RUKAN EKSLUSIF', '0004475197', 'PANTAI INDAH KAPUK', '14470', '', '2155965828', '', '', '2155965827', '', 'PANACELL1@YAHOO.COM', 30, '', '', '', '', '', '', 'V030', '2014-10-31'),
(1629, 'P1021', 'EC01', 'SUMBER ELECTRONIC', 'JL. MANGGA DUA ABDAD KOMP. BUMI JAY', '0002362657', 'JAKARTA', '00000', '', '0', '', '', '0213101092', '', '', 30, '', '', '', '', '', '', 'V030', '2014-10-13'),
(1630, 'P1023', 'EC01', 'PERMATA SAKTI PRASADA,PT', 'KOMP. RUKO SACNA BLOK D NO.42', '0005850965', 'JAKARTA UTARA', '14350', '', '216518505', '', '', '216518506', '02.504.566.7-048.000', 'PERMATA@CBN.NET.ID', 30, '', '', '', '', '', '', 'V030', '2015-05-13'),
(1631, 'P1122', 'EC01', 'PANATRONICS, PT', 'JL.SUNTER PARADISE TIMUR RAYA BLOK', '0002363500', 'JAKARTA UTARA', '00000', '', '', '', '', '', '', '', 30, '', '', '', '', '', '', 'V030', '2014-10-13'),
(1632, 'P1412', 'EC01', 'PISOK', 'DANAU SUNTER BARAT BLOK III/38-39', '0002363505', 'JAKARTA UTARA', '00000', '', '', '', '', '', '', '', 30, '', '', '', '', '', '', 'V030', '2014-10-13'),
(1633, 'P1521', 'EC01', 'PISOK +', 'JL. DANAU SUNTER BARAT A3 NO.38-39', '0002362658', 'JAKARTA UTARA', '14350', '', '0216450381', '', '', '0216450377', '', '', 30, '', '', '', '', '', '', 'V030', '2014-10-13'),
(1634, 'P1522', 'EC01', 'PISOK+', '', '0004552490', '', '', '', '', '', '', '', '', '', 0, '', '', '', '', '', '', '', '2014-11-07'),
(1635, 'P1822', 'EC01', 'PACIFICOM GLOBAL SENTOSA,PT', 'Jl. Daan Mogot Raya No.45 C Jakarta', '0002363506', 'JAKARTA', '11460', '', '', '', '', '', '', '', 30, '', '', '', '', '', '', 'V030', '2014-10-13'),
(1636, 'P2021', 'EC01', 'PAZIA PILLAR MERCYCOM, PT', 'RUKAN MANGGA DUA SQUARE BLOK G NO.', '0002362663', 'JAKARTA UTARA', '14430', '', '02162313117', '', '', '02162313116', '02.186.436.8-046.000', 'rahel@paziapm.co.id', 45, '', '', '', '', '', '', 'V045', '2014-10-13'),
(1637, 'M7622', 'EC01', 'MULIA SUKSES JAYA,PT', 'JL. KOMPLEK HARCO MANGGA DUA', '0006265452', 'JAKARTA PUSAT', '10730', '', '29021900', '', '', '29021955', '02.273.161.6-026.000', 'ARI@MAYERSUKSESJAYA.COM', 30, '', '', '', '', '', '', 'V030', '2015-11-23'),
(1638, 'M7721', 'EC01', 'MAJU MAPAN SOLUSINDO, PT', 'RUKO ALAM SUTERA TOWN CENTER', '0006289267', 'TANGERANG', '15326', '', '216129251', '', '', '2162308318', '31.264.210.1-411.000', 'DIOSHANDYAULIA@YAHOO.COM', 45, '', '', '', '', '', '', 'V045', '2015-12-03'),
(1639, 'M7722', 'EC01', 'MAJU MAPAN SOLUSINDO, PT', 'RUKO ALAM SUTERA TOWN CENTER', '0006913366', 'TANGERANG', '15326', '', '216129251', '', '', '2162308318', '31.264.210.1-411.000', 'DIOSHANDYAULIA@YAHOO.COM', 30, '', '', '', '', '', '', 'V030', '2016-08-05'),
(1640, 'M7821', 'EC01', 'METROX MEKANIKA, PT', 'PLAZA KUNINGAN MENERA UTARA', '0006632389', 'JAKARTA SELATAN', '', '', '2129668888-1028', '', '', '', '66.438.865.9-022.000', 'NANANG@E-METROX.COM', 45, '', '', '', '', '', '', 'V045', '2016-04-14'),
(1641, 'M7822', 'EC01', 'METROX MEKANIKA, PT', 'PLAZA KUNINGAN MENARA UTARA 10TH', '0006632402', 'JAKARTA SELATAN', '', '', '2129668888', '', '', '', '66.438.865.9-022.000', 'NANANG@E-METROX.COM', 30, '', '', '', '', '', '', 'V030', '2016-04-14'),
(1642, 'M7922', 'EC01', 'MICROVISION INDONESIA, PT', 'JL.RAJAWALI SELATAN RAYA', '0006875296', 'JAKARTA UTARA', '14410', '', '216412557', '', '', '', '03.048.093.3-044.000', 'PETER@MICROVISION.CO.ID', 30, '', '', '', '', '', '', 'V030', '2016-07-20'),
(1643, 'M8022', 'EC01', 'MITRA UTAMA SEJAHTERA, CV', 'JL. M.A SALMUN', '0007010113', 'BOGOR TENGAH', '', '', '216902424', '', '', '', '31.430.674.7-404.000', 'SALES@CHANNELHOBBY.COM', 30, '', '', '', '', '', '', 'V030', '2016-09-13'),
(1644, 'M8121', 'EC01', 'MICROSOFT INDONESIA,PT', 'GD.BEJ TOWER II LT.18', '0007038080', 'DKI JAKARTA', '12190', '', '817727722', '', '', '2125518100', '01.071.355.0-058.000', 'FRBOEDIM@MICROSOFT.COM', 45, '', '', '', '', '', '', 'V045', '2016-09-26'),
(1645, 'N0221', 'EC01', 'NATIONAL PANASONIC GOBEL, PT', 'JL. DEWI SANTIKA ( CAWANG II )', '0002362608', 'JAKARTA', '13630', '', '', '', '', '', '', '', 30, '', '', '', '', '', '', 'V030', '2014-10-13'),
(1646, 'N0321', 'EC01', 'NATIONAL PANASONIC GOBEL, PT', 'JL.DEWI SANTIKA / CAWANG II', '0002362613', 'JAKARTA', '13630', '', '0218005767', '', '', '0218015716', '', '', 30, '', '', '', '', '', '', 'V030', '2014-10-13'),
(1647, 'N0421', 'EC01', 'SUMBER ELECTRONIC', 'JL. MANGGA DUA ABDAD KOMP. BUMI JAY', '0002362618', 'JAKARTA', '00000', '', '0', '', '', '0216007105', '', '', 30, '', '', '', '', '', '', 'V030', '2014-10-13'),
(1648, 'N0621', 'EC01', 'NIKON INDONESIA, PT', 'WISMA 46 - KOTA BNI 46 LANTAI 35, J', '0002362619', 'DKI JAKARTA', '10220', '', '-', '', '', '0215746363', '03.234.851.8-022.000', 'herry.tan@nikonoa.net', 40, '', '', '', '', '', '', 'V040', '2014-10-13'),
(1649, 'N0622', 'EC01', 'NIKON INDONESIA, PT', 'WISMA 46 - KOTA BNI 46 LANTAI 35, J', '0002363456', 'DKI JAKARTA', '10220', '', '', '', '', '', '03.234.851.8-022.000', '', 30, '', '', '', '', '', '', 'V030', '2014-10-13'),
(1650, 'N0722', 'EC01', 'NEOHAUS INDONESIA, PT', 'JL.PROF.DR.SATRIO KAV.3-5, GDG DBS', '0002363460', 'JAKARTA SELATAN', '12940', '', '', '', '', '', '03.230.377.8-011.000', '', 30, '', '', '', '', '', '', 'V030', '2014-10-13'),
(1651, 'N0821', 'EC01', 'NINGBO TRADE ASIA GLOBAL', 'LINDETEVES TRADE CENTRE LANTAI UG', '0005667031', 'JAKARTA', '11180', '', '2162201447', '', '', '', '07.649.337.8-032.001', 'TRASIA_GLOBAL@YAHOO.COM', 45, '', '', '', '', '', '', 'V045', '2015-02-09'),
(1652, 'N0822', 'EC01', 'NINGBO TRADE ASIA GLOBAL', 'LINDETEVES TRADE CENTER LANTAI UG', '0005667043', 'JAKARTA', '11180', '', '2162201447', '', '', '', '07.649.337.8-032.001', 'TRASIA_GLOBAL@YAHOO.COM', 30, '', '', '', '', '', '', 'V030', '2015-02-09'),
(1653, 'NT012', 'EC01', 'FINANCE & ACCOUNTING ( MIGRATION )', 'JL. JEND SUDIRMAN KAV. 52-53 LOT 22', '0004548069', 'JAKARTA SELATAN', '12190', '', '021-5151177', '', '', '', '', '', 0, '', '', '', '', '', '', '', '2014-11-04'),
(1654, 'O0122', 'EC01', 'OXONE,', 'KOMP.RUKO BANDENGAN INDAH JL.BANDEN', '0002363462', 'JAKARTA UTARA', '00000', '', '', '', '', '', '', '', 30, '', '', '', '', '', '', 'V030', '2014-10-13'),
(1655, 'O0211', 'EC01', 'SUMBER ELECTRONIC', 'JL. MANGGA DUA ABDAD KOMP. BUMI JAY', '0002362624', 'JAKARTA', '00000', '', '0214256438', '', '', '02142883315', '', '', 30, '', '', '', '', '', '', 'V030', '2014-10-13'),
(1656, 'O0221', 'EC01', 'OLYMPUS SERVICE CENTER', 'JL. GUNUNG SAHARI NO.78', '0002362629', 'JAKARTA', '10610', '', '0214256438', '', '', '02142883315', '', 'leo_olympus@yahoo.co.id', 45, '', '', '', '', '', '', 'V045', '2014-10-13'),
(1657, 'O0222', 'EC01', 'OLYMPUS SERVICE CENTER', 'JL. GUNUNG SAHARI NO.78', '0002363467', 'JAKARTA', '10610', '', '', '', '', '', '', '', 30, '', '', '', '', '', '', 'V030', '2014-10-13'),
(1658, 'O0422', 'EC01', 'OGI KARSA CIPTA,PT', 'JL. GUNUNG SAHARI I-36', '0002363472', 'JAKARTA PUSAT', '10410', '', '', '', '', '', '', '', 30, '', '', '', '', '', '', 'V030', '2014-10-13'),
(1659, 'O0521', 'EC01', 'SUMBER ELECTRONIC', 'KOMP.MANGGA DUA ABDAD JL. BUMI JAYA', '0002362630', 'JAKARTA UTARA', '00000', '', '', '', '', '0215220322', '', '', 30, '', '', '', '', '', '', 'V030', '2014-10-13'),
(1660, 'O0622', 'EC01', 'OCTA UTAMA, PT', 'JL.BANDENGAN UTARA 80 BLOK A NO.25', '0002363473', 'JAKARTA UTARA', '00000', '', '', '', '', '', '02.379.449.8.041.000', '', 30, '', '', '', '', '', '', 'V030', '2014-10-13'),
(1661, 'O0721', 'EC01', 'OKESHOP, PT', 'JALAN ABDUL MUIS NO. 24 PETOJO SELA', '0002362635', 'JAKARTA PUSAT', '10160', '', '0213440220', '', '', '02129035222', '21.128.620.8-028.000', 'julius.aditya@oke.com', 30, '', '', '', '', '', '', 'V030', '2014-10-13'),
(1662, 'O0722', 'EC01', 'OKESHOP, PT', 'JALAN ABDUL MUIS NO. 24 PETOJO SELA', '0002363478', 'JAKARTA PUSAT', '10160', '', '', '', '', '', '21.128.620.8-028.000', '', 30, '', '', '', '', '', '', 'V030', '2014-10-13'),
(1663, 'O0821', 'EC01', 'OPTIMA MULTI DIMENSI, PT', 'NO. 78 JL. GUNUNG SAHARI RAYA', '0006428451', 'JAKARTA PUSAT', '10610', '', '21-4227577', '', '', '21-4216506', '72.744.226.1-027.000', '', 45, '', '', '', '', '', '', 'V045', '2016-01-18'),
(1664, 'O0822', 'EC01', 'OPTIMA MULTI DIMENSI, PT', 'NO. 78 JL. GUNUNG SAHARI RAYA', '0006428671', 'JAKARTA PUSAT', '10610', '', '21-4227577', '', '', '21-4216506', '72.744.226.1-027.000', 'MELINA@PERDANA.LINTASDIGITAL.COM', 30, '', '', '', '', '', '', 'V030', '2016-01-18'),
(1665, 'P0121', 'EC01', 'PHILIPS INDONESIA, PT', 'GEDUNG PHILIPS LT.3', '0002362640', 'JAKARTA', '12510', '', '0217940040', '', '', '0217947529', '01.001.756.4-092.000', 'MIRZA.LUTHFI@PHILIPS.COM', 45, '', '', '', '', '', '', 'V045', '2014-10-13'),
(1666, 'P0122', 'EC01', 'PHILIPS INDONESIA. PT', 'JL. BUNCIT RAYA KAV 99', '0004552480', 'JAKARTA', '12510', '', '8128298077', '', '', '217947529', '01.001.756.4-092.000', 'MIRZA.LUTHFI@PHILIPS.COM', 30, '', '', '', '', '', '', 'V030', '2014-11-07'),
(1667, 'P0222', 'EC01', 'PROPINDO SEJAHTERA, PT', 'JL.PROF.DR.LATUMENTEN NO.50 SENTRO', '0002363483', 'LT.2. JAKARTA', '11460', '', '', '', '', '', '', '', 30, '', '', '', '', '', '', 'V030', '2014-10-13'),
(1668, 'P0321', 'EC01', 'PANASONIC GOBEL INDONESIA, PT', 'JL. DEWI SARTIKA (CAWANG II)', '0002362641', 'JAKARTA', '13630', '', '0218005767', '', '', '02180876178', '0010694131092000', 'jefry.tjandra@id.panasonic.com', 39, '', '', '', '', '', '', 'V039', '2014-10-13'),
(1669, 'P0322', 'EC01', 'PANASONIC GOBEL INDONESIA, PT', 'JL. DEWI SARTIKA (CAWANG II)', '0002363484', 'JAKARTA', '13630', '', '', '', '', '', '0010694131092000', '', 30, '', '', '', '', '', '', 'V030', '2014-10-13'),
(1670, 'S0211', 'EC01', 'SUMBER ELECTRONIC', 'Jl. Mangga Dua Abdad Komp. Bumi Jay', '0002362700', 'JAKARTA', '00000', '', '0215225522', '', '', '02151402080', '', '', 30, '', '', '', '', '', '', 'V030', '2014-10-13'),
(1671, 'S0221', 'EC01', 'SAMSUNG ELEC IND, PT', 'TCC BATAVIA TOWER ONE 23RD FLOOR JL', '0002362701', 'JAKARTA', '10220', '', '02129588000', '', '', '02129675080', '01.069.467.7.092.000', 'angga.j@samsung.com', 30, '', '', '', '', '', '', 'V030', '2014-10-13'),
(1672, 'S0222', 'EC01', 'SAMSUNG ELEC IND, PT', 'JL. JEND SUDIRMAN KAV.25 LT.16 SUIT', '0002363570', 'JAKARTA-SELATAN', '00000', '', '', '', '', '', '01.069.467.7.092.000', '', 30, '', '', '', '', '', '', 'V030', '2014-10-13'),
(1673, 'S0321', 'EC01', 'SAMSUNG ELEC IND, PT', 'JL. JEND SUDIRMAN KAV.25 LT.16 SUIT', '0002362766', 'JAKARTA-SELATAN', '00000', '', '0215225522', '', '', '0215225511', '01.069.467.7.092.000', 'a.andreas@samsung.com', 30, '', '', '', '', '', '', 'V030', '2014-10-13'),
(1674, 'S0421', 'EC01', 'SARANA KENCANA MULYA, PT', 'JL. AIPDA K.S TUBUN II/15', '0002362706', 'JAKARTA', '11410', '', '0215346988', '', '', '0215301284', '01.641.644.8.092.000', 'jefry.handoyo@polytron.co.id', 45, '', '', '', '', '', '', 'V045', '2014-10-13'),
(1675, 'S0422', 'EC01', 'SARANA KENCANA MULYA, PT', 'JL. AIPDA K.S TUBUN II/15', '0002363575', 'JAKARTA', '11410', '', '', '', '', '', '01.641.644.8.092.000', '', 30, '', '', '', '', '', '', 'V030', '2014-10-13'),
(1676, 'S0521', 'EC01', 'SHARP ELECTRONICS INDONESIA, PT', 'JL. HARAPAN RAYA LOT LL-1&2', '0002362711', 'KARAWANG', '41361', '', '02146824070', '', '', '02146824061', '01.001.880.2-092.000', 'ferdy_p@seid.sharp-world.com', 45, '', '', '', '', '', '', 'V045', '2014-10-13'),
(1677, 'S0522', 'EC01', 'SHARP ELECTRONICS INDONESIA, PT', 'JL. HARAPAN RAYA LOT LL-1&2', '0002363579', 'KARAWANG', '41361', '', '', '', '', '', '01.001.880.2-092.000', '', 30, '', '', '', '', '', '', 'V030', '2014-10-13'),
(1678, 'S0621', 'EC01', 'SANYO SALES INDONESIA, PT', 'JL. DANAU SUNTER BARAT BLOK A III/3', '0002362712', 'JAKARTA UTARA', '14350', '', '0216505668', '', '', '0216512556', '01.305.871.4.056.000', '', 30, '', '', '', '', '', '', 'V030', '2014-10-13'),
(1679, 'S0622', 'EC01', 'SANYO SALES INDONESIA, PT', 'JL. DANAU SUNTER BARAT BLOK A III N', '0002363581', 'JAKARTA UTARA', '14350', '', '', '', '', '', '01.305.871.4.056.000', '', 30, '', '', '', '', '', '', 'V030', '2014-10-13'),
(1680, 'S0821', 'EC01', 'SETRINDO PRIMA, PT', 'JL.SUNTER AGUNG PODOMORO BLOK.A-3 K', '0002362717', 'JAKARTA UTARA', '14350', '', '0216450381', '', '', '0216450378', '01.743.926.6.046.000', 'ciarli@setrindo.co.id', 45, '', '', '', '', '', '', 'V045', '2014-10-13'),
(1681, 'S0822', 'EC01', 'SETRINDO PRIMA, PT', 'JL.SUNTER AGUNG PODOMORO BLOK.A-3 K', '0002363586', 'JAKARTA UTARA', '14350', '', '', '', '', '', '01.743.926.6.046.000', '', 30, '', '', '', '', '', '', 'V030', '2014-10-13'),
(1682, 'S0921', 'EC01', 'SUMBER ELECTRONIC', 'Jl. Mangga Dua Abdad komp. Bumi Jay', '0002362722', 'JAKARTA', '00000', '', '0', '', '', '0216544811', '', '', 30, '', '', '', '', '', '', 'V030', '2014-10-13'),
(1683, 'S1021', 'EC01', 'SUMBER ELECTRONIC', 'JL. MANGGA DUA ABDAD KOMP. BUMI JAY', '0002362726', 'JAKARTA', '00000', '', '0', '', '', '0216129116', '', '', 30, '', '', '', '', '', '', 'V030', '2014-10-13'),
(1684, 'S1222', 'EC01', 'SINAR ANUGRAH PERKASA', 'JL. PANGERAN JAYAKARTA NO. 115', '0002363591', 'JAKARTA', '10042', '', '', '', '', '', '', '', 30, '', '', '', '', '', '', 'V030', '2014-10-13'),
(1685, 'P2022', 'EC01', 'PAZIA PILLAR MERCYCOM, PT', 'RUKAN MANGGA DUA SQUARE BLOK G NO.', '0002363511', 'JAKARTA UTARA', '14430', '', '', '', '', '', '02.186.436.8-046.000', '', 30, '', '', '', '', '', '', 'V030', '2014-10-13'),
(1686, 'P2321', 'EC01', 'PERDANA INTI PUTRA, PT', 'GUNUNG SAHARI RAYA NO. 78 Lt. 8', '0002362668', 'JAKARTA', '10610', '', '02193338858', '', '', '0214227578', '02.494.515.6.027.000', 'veronica@perdana.lintasdigital.com', 45, '', '', '', '', '', '', 'V045', '2014-10-13'),
(1687, 'P2322', 'EC01', 'PERDANA INTI PUTRA, PT', 'GUNUNG SAHARI RAYA NO. 78 Lt. 8', '0002363516', 'JAKARTA', '10610', '', '', '', '', '', '02.494.515.6.027.000', '', 30, '', '', '', '', '', '', 'V030', '2014-10-13'),
(1688, 'P2422', 'EC01', 'PORTRICH INDONESIA, PT', 'Komp. Ruko Bahan Bangunan blok F5 n', '0002363521', 'JAKARTA PUSAT', '00000', '', '', '', '', '', '', '', 30, '', '', '', '', '', '', 'V030', '2014-10-13'),
(1689, 'P2621', 'EC01', 'PANCA ANUGERAH SUKSES, PT', 'JL. PANGERAN JAYAKARTA KOMP.131 A N', '0002362673', 'JAKARTA', '00000', '', '0216391816', '', '', '0', '', '', 30, '', '', '', '', '', '', 'V030', '2014-10-13'),
(1690, 'P2722', 'EC01', 'PROLINK INTIDATA NUSANTARA. PT', '', '0004552491', '', '', '', '', '', '', '', '', '', 0, '', '', '', '', '', '', '', '2014-11-07'),
(1691, 'P2922', 'EC01', 'PANCA WISESA ADHIKA, PT', 'Jl Cideng Timur No. 56 B', '0002363525', 'JAKARTA PUSAT', '10160', '', '', '', '', '', '', '', 30, '', '', '', '', '', '', 'V030', '2014-10-13'),
(1692, 'P3021', 'EC01', 'PIXEL PERDANA JAYA, PT', 'SuperBlok Mega Kemayoran Kantor Blo', '0002362674', 'JAKARTA', '10610', '', '02126647018', '', '', '02126647020', '02.629.187.2-048.000', 'jonoliu@pixel.co.id', 45, '', '', '', '', '', '', 'V045', '2014-10-13'),
(1693, 'P3022', 'EC01', 'PIXEL PERDANA JAYA, PT', 'SuperBlok Mega Kemayoran Kantor Blo', '0002363527', 'JAKARTA', '10610', '', '', '', '', '', '02.629.187.2-048.000', '', 30, '', '', '', '', '', '', 'V030', '2014-10-13'),
(1694, 'P3121', 'EC01', 'PERSADA CENTRA DIGITAL, PT', 'BG JUNCTION MALL,IT ZONE L1 C-28/29', '0002362679', 'SURABAYA', '00000', '', '-', '', '', '0217990912', '31.211.372.3-614.000', 'sylvia@globalteleshop.co.id', 30, '', '', '', '', '', '', 'V030', '2014-10-13'),
(1695, 'P3122', 'EC01', 'PERSADA CENTRA DIGITAL, PT', 'BG JUNCTION MALL,IT ZONE L1 C-28/29', '0002363532', 'SURABAYA', '00000', '', '', '', '', '', '31.211.372.3-614.000', '', 30, '', '', '', '', '', '', 'V030', '2014-10-13'),
(1696, 'P3222', 'EC01', 'PANCAMAGRAN WISESA, PT', 'JL. CIDENG TIMUR NO. 56A, PETOJO SE', '0002363537', 'DKI JAKARTA', '10160', '', '', '', '', '', '01.357.993.2-028.000', '', 30, '', '', '', '', '', '', 'V030', '2014-10-13'),
(1697, 'P3321', 'EC01', 'POLA MODERA COMPUTA, CV', 'ITC CEMPAKA MAS LT. 4 BLOK I NO. 65', '0002362684', 'JAKARTA PUSAT', '10640', '', '02142902641', '', '', '02142901619', '02.273.466.9-027.000', 'aseannotebook@yahoo.co.id', 45, '', '', '', '', '', '', 'V045', '2014-10-13'),
(1698, 'P3322', 'EC01', 'POLA MODERA COMPUTA, CV', 'ITC CEMPAKA MAS LT. 4 BLOK I NO. 65', '0002363538', 'JAKARTA PUSAT', '10640', '', '', '', '', '', '02.273.466.9-027.000', '', 30, '', '', '', '', '', '', 'V030', '2014-10-13'),
(1699, 'P3422', 'EC01', 'PANORAMA TIMUR JAYA, PT', 'JL. PAUS 89 D-E RAWAMANGUN', '0002363543', 'JAKARTA TIMUR - DKI JAKAR', '13220', '', '', '', '', '', '01.304.666.9-007.000', '', 30, '', '', '', '', '', '', 'V030', '2014-10-13'),
(1700, 'P3522', 'EC01', 'PACIFIC SECURITY TECHNOLOGY, PT', 'JL. PANGERAN JAYAKARTA 72-74, BLOK', '0002363548', 'JAKARTA PUSAT', '10730', '', '', '', '', '', '31.644.659.0-026.000', '', 30, '', '', '', '', '', '', 'V030', '2014-10-13'),
(1701, 'P3622', 'EC01', 'PANCA ANUGRAH WISESA, PT', 'GD. JDC LT. 2 SR 07, JL. GATOT SUBR', '0002363549', 'JAKARTA PUSAT', '11410', '', '', '', '', '', '03.244.224.6-072.000', '', 30, '', '', '', '', '', '', 'V030', '2014-10-13'),
(1702, 'P3722', 'EC01', 'PASIFIK TEKNOLOGI INDONESIA, PT', 'JL. P. JAYAKARTA KV. 123 NO. 26 MAN', '0002363554', 'JAKARTA PUSAT', '10730', '', '', '', '', '', '31.811.472.5-026.000', '', 30, '', '', '', '', '', '', 'V030', '2014-10-13'),
(1703, 'P3821', 'EC01', 'PHILIPS INDONESIA COMERCIAL, PT', 'GEDUNG PHILIPS, JL BUNCIT RAYA KAV', '0002362685', 'JAKARTA SELATAN', '12510', '', '-', '', '', '0217940030', '03.280.630.9-017.000', 'Yongky.Sentosa@philips.com', 45, '', '', '', '', '', '', 'V045', '2014-10-13'),
(1704, 'P3921', 'EC01', 'PARON INDONESIA, PT', 'HARCO MANGGA DUA', '0004607660', 'JAKARTA PUSAT', '', '', '', '', '', '', '03.048.416.6-026.000', 'WARDI@PARON.CO.ID', 45, '', '', '', '', '', '', 'V045', '2014-12-03'),
(1705, 'P3922', 'EC01', 'PARON INDONESIA, PT', 'RUKO HARCO MANGGA DUA', '0004560105', 'JAKARTA PUSAT', '', '', '2195229269', '', '', '', '03.048.416.6-026.000', 'WARDI@PARON.CO.ID', 45, '', '', '', '', '', '', 'V045', '2014-11-10'),
(1706, 'P4021', 'EC01', 'PACIFIC SATELINDO SYSTEM, PT', 'JL. JEMBATAN DUA', '0004638628', 'JAKARTA UTARA', '14450', '', '2166601471', '', '', '2166601933', '02.667.283.2-041.000', 'GOJALISUPIANDI@SKYCOMSATELLITE.COM', 30, '', '', '', '', '', '', 'V030', '2014-12-16'),
(1707, 'P4022', 'EC01', 'PACIFIC SATELINDO SYSTEM, PT', 'JL. JEMBATAN DUA', '0004638635', 'JAKARTA UTARA', '14450', '', '2166601471', '', '', '2166601933', '02.667.283.2-041.000', 'GOJALISUPIANDI@SKYCOMSATELLITE.COM', 30, '', '', '', '', '', '', 'V030', '2014-12-16'),
(1708, 'P4121', 'EC01', 'PRIMA ANEKA SARANA, PT', 'KOMPLEKS RUKO UNION', '0005710230', 'BEKASI', '17550', '', '218973725', '', '', '218973509', '01.875.967.0-413.000', 'HARDI@PA-SARANA.CO.ID', 45, '', '', '', '', '', '', 'V045', '2015-03-03'),
(1709, 'P4122', 'EC01', 'PRIMA ANEKA SARANA, PT', 'KOMPLEKS RUKO UNION', '0005710284', 'BEKASI', '17550', '', '218973725', '', '', '218973509', '01.875.967.0-413.000', 'HARDI@PA-SARANA.CO.ID', 30, '', '', '', '', '', '', 'V030', '2015-03-03'),
(1710, 'R0221', 'EC01', 'RICH INDONESIA, PT', 'JL.JABABEKA XVII-B BLOK U NO.19-H K', '0002362690', 'BEKASI', '17530', '', '02189840305', '', '', '0214204433', '02.530.244.9-414.000', 'info@ptrichindonesia.com', 45, '', '', '', '', '', '', 'V045', '2014-10-13'),
(1711, 'R0222', 'EC01', 'RICH INDONESIA, PT', 'JL.JABABEKA XVII-B BLOK U NO.19-H K', '0006184538', 'BEKASI', '17530', '', '02189840305', '', '', '0214204433', '02.530.244.9-414.000', 'info@ptrichindonesia.com', 30, '', '', '', '', '', '', 'V030', '2015-10-21'),
(1712, 'R0322', 'EC01', 'RAVALINDO MEGAH PERKASA, PT', 'JL. DAAN MOGOT 2 GOLDEN VILLE 88 AB', '0002363559', 'JAKARTA BARAT', '11510', '', '', '', '', '', '03.047.383.9-039.000', '', 30, '', '', '', '', '', '', 'V030', '2014-10-13'),
(1713, 'R0342', 'EC01', 'RAVALINDO MEGAH PERKASA, PT', 'JL. DAAN MOGOT 2 GOLDEN VILLE 88 AB', '0002363564', 'JAKARTA BARAT', '11510', '', '', '', '', '', 'PEM-01993/WPJ.05/KP.', '', 30, '', '', '', '', '', '', 'V030', '2014-10-13'),
(1714, 'R0422', 'EC01', 'RUDY SETIAWAN', 'JL. BOULEVARD BUKIT GADING RAYA', '0004589686', ' JAKARTA UTARA', '14240', '', '2145860530', '', '', '2145860533', '27.555.507.6-024.000', 'ETA_JKT@YAHOO.CO.ID', 45, '', '', '', '', '', '', 'V045', '2014-11-24'),
(1715, 'R0522', 'EC01', 'READBOY INDONESIA, PT', 'ARTHA GADING SENTRA BISNIS', '0006254027', 'JAKARTA', '14240', '', '81291682166', '', '', '214535615', '02.505.955.1.043.000', 'DANDY@READBOY.ID', 30, '', '', '', '', '', '', 'V030', '2015-11-19'),
(1716, 'RFDC', 'EC01', 'Reference DC', '', '0000022940', '', '', '', '', '', '', '', '', '', 0, '', '', '', '', '', '', '', '2014-10-08'),
(1717, 'S0121', 'EC01', 'SONY INDONESIA, PT', 'Jl. HR Rasuna Said Kav. B-6 Lt.1&2', '0002362695', 'JAKARTA', '12910', '', '0215279888', '', '', '0215220325', '0017075748056000', 'Irwan.Tongari@ap.sony.com', 45, '', '', '', '', '', '', 'V045', '2014-10-13'),
(1718, 'S0122', 'EC01', 'SONY INDONESIA, PT', 'WISMA GKBI BUILDING-23RD JL. JEND S', '0002363565', 'JAKARTA', '12940', '', '', '', '', '', '0017075748056000', '', 30, '', '', '', '', '', '', 'V030', '2014-10-13');
INSERT INTO `api_vendor` (`id`, `supplierCode`, `companyCode`, `name`, `address1`, `address2`, `city`, `postalCode`, `contactPerson`, `phone`, `hp1`, `hp2`, `fax`, `npwp`, `email`, `paymentTerm`, `bankCode`, `bankName`, `bankBranchCode`, `bankBranchName`, `bankAccountNo`, `status`, `paymentTermCd`, `dateCreate`) VALUES
(1719, 'I5521', 'EC01', 'INSTANT VENDOR', '', '0007504793', '', '', '', '', '', '', '', '', '', 0, '', '', '', '', '', '', '', '2023-08-08'),
(1720, 'S6321', 'EC01', 'SMART TELECOM, PT', 'JL. H. AGUS SALIM NO. 45 - MENTENG', '0002362819', 'JAKARTA PUSAT', '10340', '', '-', '', '', '02131927880', '01.792.185.9-092.000', 'dasmei.ziliwu@smartfren.com', 45, '', '', '', '', '', '', 'V045', '2014-10-13'),
(1721, 'S6322', 'EC01', 'SMART TELECOM, PT', 'JL. H. AGUS SALIM NO. 45 - MENTENG', '0002363653', 'JAKARTA PUSAT', '10340', '', '', '', '', '', '01.792.185.9-092.000', '', 30, '', '', '', '', '', '', 'V030', '2014-10-13'),
(1722, 'S6422', 'EC01', 'STARKS INTERNATIONAL, PT', 'THE PLAZA SEMANGGI LANTAI 3 NO.31A,', '0002363654', 'JAKARTA SELATAN', '12930', '', '', '', '', '', '03.186.592.6-063.000', '', 30, '', '', '', '', '', '', 'V030', '2014-10-13'),
(1723, 'S6521', 'EC01', 'STAR WORLD INTERNATIONAL, PT', 'JL. KARET SAWAH I / NO. 30 RT. 007', '0002362824', 'JAKARTA SELATAN', '12930', '', '02152905677', '', '', '02152905679', '02.978.699.3-063.000', 'SONDI@GADGETCITI.COM', 45, '', '', '', '', '', '', 'V045', '2014-10-13'),
(1724, 'S6522', 'EC01', 'STAR WORLD INTERNATIONAL, PT', 'JL. KARET SAWAH I / NO. 30 RT. 007', '0002363659', 'JAKARTA SELATAN', '12930', '', '', '', '', '', '02.978.699.3-063.000', '', 30, '', '', '', '', '', '', 'V030', '2014-10-13'),
(1725, 'S6622', 'EC01', 'SIGNIFICA SYNERGY, CV', 'JL. PANGERAN JAYAKARTA RUKO 131 A N', '0002363664', 'JAKARTA', '00000', '', '', '', '', '', '31.474.481.4.125.000', '', 30, '', '', '', '', '', '', 'V030', '2014-10-13'),
(1726, 'S6721', 'EC01', 'SEMANGAT SEJAHTERA BERSAMA, PT', 'JL. KRAN RAYA BLOK B NO 4-7, GUNUNG', '0002362829', 'JAKARTA', '10610', '', '0214260555', '', '', '02142889255', '02.832.502.5-073.000', 'hendra@advanceproduct.com', 45, '', '', '', '', '', '', 'V045', '2014-10-13'),
(1727, 'S6822', 'EC01', 'SARANDRA INDO, PT', 'JL. MANGGA DUA RAYA RUKO GRAND BOUT', '0002363669', 'JAKARTA UTARA', '14430', '', '', '', '', '', '31.528.607.0-044.000', '', 30, '', '', '', '', '', '', 'V030', '2014-10-13'),
(1728, 'S6922', 'EC01', 'SURYA CANDRA, PT', 'KOMP.MARINATAMA BLOK G-3, JL GN SAH', '0002363673', 'JAKARTA UTARA', '14420', '', '', '', '', '', 'PEM-064/WPJ.05/KP.02', '', 30, '', '', '', '', '', '', 'V030', '2014-10-13'),
(1729, 'S7021', 'EC01', 'SWARNA DWIPA ADIGUNA, PT', 'JL. KALI BESAR BARAT NO.34-35 RT007', '0002362830', 'JAKARTA BARAT', '11230', '', '', '', '', '0', 'PEM-01079/WPJ.05/KP.', '', 45, '', '', '', '', '', '', 'V045', '2014-10-13'),
(1730, 'S7022', 'EC01', 'SWARNA DWIPA ADIGUNA, PT', 'JL. KALI BESAR BARAT NO.34-35 RT007', '0002363679', 'JAKARTA BARAT', '11230', '', '', '', '', '', '03.084.651.3-033.000', '', 30, '', '', '', '', '', '', 'V030', '2014-10-13'),
(1731, 'S7041', 'EC01', 'SWARNA DWIPA ADIGUNA, PT', 'JL. KALI BESAR BARAT NO.34-35 RT007', '0002362835', 'JAKARTA BARAT', '11230', '', '', '', '', '0', 'PEM-01079/WPJ.05/KP.', '', 45, '', '', '', '', '', '', 'V045', '2014-10-13'),
(1732, 'S7111', 'EC01', 'SUMBER ELECTRONIC', 'JL. MANGGA DUA ABDAD KOMP. BUMI JAY', '0002352996', 'JAKARTA', '00000', '', '0216000206', '', '', '0216122447', '', '', 0, '', '', '', '', '', '', 'V000', '2014-10-13'),
(1733, 'S7122', 'EC01', 'SUKSES ABADI CEMERLANG, PT', 'RUKO BOUTIQUE BLOK B 20', '0002363680', 'JAKARTA PUSAT', '10630', '', '21-40944839', '', '', '', '70.058.486.5-048.000', '', 30, '', '', '', '', '', '', 'V030', '2014-10-13'),
(1734, 'S1421', 'EC01', 'SUMBER ELECTRONIC', 'JL. MANGGA DUA ABDAD KOMP. BUMI JAY', '0002362728', 'JAKARTA', '00000', '', '0', '', '', '0216128023', '', '', 30, '', '', '', '', '', '', 'V030', '2014-10-13'),
(1735, 'S1521', 'EC01', 'SUMBER ELECTRONIC', 'JL.MANGGA DUA ABDAD KOMP. BUMI JAYA', '0002362733', 'JAKARTA', '00000', '', '0', '', '', '02162312824', '', '', 30, '', '', '', '', '', '', 'V030', '2014-10-13'),
(1736, 'S1621', 'EC01', 'SUMBER ELECTRONIC', 'JL.MANGGA DUA ABDAD KOMP.BUMI JAYAK', '0002362734', 'JAKARTA', '00000', '', '0', '', '', '0213924567', '', '', 14, '', '', '', '', '', '', 'V014', '2014-10-13'),
(1737, 'S1721', 'EC01', 'SUMBER ELECTRONIC', 'Jl. Mangga Dua Abdad Komp. Bumi Jay', '0002362739', 'JAKARTA', '00000', '', '0216122141', '', '', '0216121093', '', '', 21, '', '', '', '', '', '', 'V021', '2014-10-13'),
(1738, 'S1722', 'EC01', 'SENTRAPONSEL CITRA MAKMUR, PT', 'ITC CMPAKA MAS LT.4 BLOK L NO.1055-', '0002363595', 'JAKARTA PUSAT', '00000', '', '', '', '', '', '', '', 21, '', '', '', '', '', '', 'V021', '2014-10-13'),
(1739, 'S1921', 'EC01', 'SUMBER ELECTRONIC', 'JL.MANGGA DUA ABDAD KOMP. BUMI JAYA', '0002362744', 'JAKARTA', '00000', '', '0', '', '', '0215632536', '', '', 30, '', '', '', '', '', '', 'V030', '2014-10-13'),
(1740, 'S2122', 'EC01', 'SANEX TELEKOMUNIKASI IND, PT', 'JL.AGUNG TIMUR X BLOK N1 NO 11-14', '0002363597', 'JAKARTA UTARA', '14350', '', '', '', '', '', '', '', 30, '', '', '', '', '', '', 'V030', '2014-10-13'),
(1741, 'S2221', 'EC01', 'SOERJO FADJAR, PT', 'GD. PINTJOE LT.3 JL. GAJAH MADA 162', '0002362749', 'JAKARTA BARAT', '00000', '', '0216006615', '', '', '0216251834', '', 'rudy@soerjo-fadjar.com', 30, '', '', '', '', '', '', 'V030', '2014-10-13'),
(1742, 'S2222', 'EC01', 'SOERJO FADJAR, PT', 'GD PINTJOE LT.3 JL GAJAH MADA 162C', '0002363602', 'JAKARTA BARAT', '00000', '', '', '', '', '', '01.317.290.3.037.000', '', 30, '', '', '', '', '', '', 'V030', '2014-10-13'),
(1743, 'S2321', 'EC01', 'STAR COSMOS, PT', 'JL. RAYA BUAYA NO. 8 CENGKARENG', '0002362750', 'JAKARTA BARAT', '11740', '', '02154396630', '', '', '0215441166', '0013058839038000', 'modern@starcosmosgroup.com', 45, '', '', '', '', '', '', 'V045', '2014-10-13'),
(1744, 'S2322', 'EC01', 'STAR COSMOS, PT', 'JL. RAYA BUAYA NO. 8 CENGKARENG', '0002363607', 'JAKARTA BARAT', '11740', '', '', '', '', '', '0013058839038000', '', 30, '', '', '', '', '', '', 'V030', '2014-10-13'),
(1745, 'S2611', 'EC01', 'SUMBER ELECTRONIC', 'KOMP.MANGGA DUA ABDAD. JL.BUMI JAYA', '0002362755', 'JAKARTA UTARA', '00000', '', '', '', '', '0', '', '', 30, '', '', '', '', '', '', 'V030', '2014-10-13'),
(1746, 'S2621', 'EC01', 'SUMBER ELECTRONIC', 'JL. Mangga Dua Abdad Komp Bumi Jaya', '0002362760', '', '00000', '', '', '', '', '0', '', '', 30, '', '', '', '', '', '', 'V030', '2014-10-13'),
(1747, 'S2721', 'EC01', 'SUMBER ELECTRONIC', 'KOMP.MANGGA DUA ABDAD JL.BUMI JAYAK', '0002362761', 'JAKARTA UTARA', '00000', '', '0', '', '', '0216254288', '', '', 30, '', '', '', '', '', '', 'V030', '2014-10-13'),
(1748, 'S2922', 'EC01', 'SETRINDO PRIMA, PT', 'JL.SUNTER AGUNG PODOMORO BLOK.A-3 K', '0002363612', 'JAKARTA UTARA', '00000', '', '', '', '', '', '', '', 30, '', '', '', '', '', '', 'V030', '2014-10-13'),
(1749, 'S3121', 'EC01', 'SEJAHTERA ABADI, UD', 'JL. KARTINI NO. 68', '0002362771', 'JAKARTA PUSAT', '00000', '', '0216248346', '', '', '0216394675', '', '', 30, '', '', '', '', '', '', 'V030', '2014-10-13'),
(1750, 'S3921', 'EC01', 'SINAR JAYA CEMERLANG, PT', 'JL.MANGGA DUA RAYA RUKO TEKSTILE BL', '0002362775', 'JAKARTA UTARA', '14430', '', '0216128331', '', '', '0216129116', '', '', 30, '', '', '', '', '', '', 'V030', '2014-10-13'),
(1751, 'S4021', 'EC01', 'SUMBER ELECTRONIC', 'KOMP.MANGGA DUA ABDAB JL.BUMI JAKAR', '0002362777', 'JAKARTA UTARA', '00000', '', '', '', '', '0227218081', '', '', 30, '', '', '', '', '', '', 'V030', '2014-10-13'),
(1752, 'S4221', 'EC01', 'SUMBER ELECTRONIC', 'JL.MANGGA DUA ABDAD KOMP BUMI JAYAK', '0002362782', 'JAKARTA', '00000', '', '0216122141', '', '', '0216121093', '', '', 21, '', '', '', '', '', '', 'V021', '2014-10-13'),
(1753, 'S4321', 'EC01', 'SAHITEL INTERNATIONAL, PT', 'RUKO GASTRA GRAHA J/10, JL RAYA PER', '0002362787', 'JAKARTA - BARAT', '11530', '', '0216323688', '', '', '0215362087', '02.460.337.5.035.000', 'Susan.Sutiono@panasonic-itcomm.com', 30, '', '', '', '', '', '', 'V030', '2014-10-13'),
(1754, 'S4421', 'EC01', 'SUMBER ELECTRONIC', 'JL MANGGA DUA ABDAD KOMP BUMI JAYAK', '0002362792', 'JAKARTA', '00000', '', '0', '', '', '0213924567', '', '', 14, '', '', '', '', '', '', 'V014', '2014-10-13'),
(1755, 'S4522', 'EC01', 'SAHABAT ELECTRONIC, CV', 'Komp. Taman Palem Lestari Blok D10/', '0002363621', 'JAKARTA BARAT', '00000', '', '', '', '', '', '01.995.987.3.034.000', '', 30, '', '', '', '', '', '', 'V030', '2014-10-13'),
(1756, 'S4621', 'EC01', 'SISTECH KHARISMA, PT', 'JL IR H. JUANDA IV NO 3B-C', '0002362797', 'JAKARTA', '10120', '', '0213505668', '', '', '0213807640', '01.323.638.5-073.000', 'ricky_kurniawan@sistech.co.id', 45, '', '', '', '', '', '', 'V045', '2014-10-13'),
(1757, 'S4622', 'EC01', 'SISTECH KHARISMA, PT', 'JL IR H. JUANDA IV NO 3B-C', '0002363626', 'JAKARTA', '10120', '', '', '', '', '', '01.323.638.5-073.000', '', 30, '', '', '', '', '', '', 'V030', '2014-10-13'),
(1758, 'S5022', 'EC01', 'SUPER DISRIBUTION INDONESIA, PT', 'JL.ANGKASA BLOK B.15 KAV 2-3 GDNG M', '0002363631', 'JAKARTA', '10610', '', '', '', '', '', '', '', 30, '', '', '', '', '', '', 'V030', '2014-10-13'),
(1759, 'S5621', 'EC01', 'SELULAR MEDIA INFOTAMA, PT', 'JL. DAAN MOGOT KM 1 NO, 111', '0002362798', 'JAKARTA BARAT', '11460', '', '0215602111', '', '', '02156940111', '02.747.399.0.038.000', 'david.samuel@SelularGroup.com', 45, '', '', '', '', '', '', 'V045', '2014-10-13'),
(1760, 'S5622', 'EC01', 'SELULAR MEDIA INFOTAMA, PT', 'JL. DAAN MOGOT KM 1 NO, 111', '0002363632', 'JAKARTA BARAT', '11460', '', '', '', '', '', '02.747.399.0.038.000', '', 30, '', '', '', '', '', '', 'V030', '2014-10-13'),
(1761, 'S5721', 'EC01', 'SURYA MANGGALA, CV', 'JL. RAYA JELAMBAR SELATAN NO. 8D RT', '0002362803', 'DKI JAKARTA', '11460', '', '-', '', '', '0215657768', '31.254.253.3.036.000', 'kusnadi.jessica@gmail.com', 45, '', '', '', '', '', '', 'V045', '2014-10-13'),
(1762, 'S5722', 'EC01', 'SURYA MANGGALA, CV', 'JL. RAYA JELAMBAR SELATAN NO. 8D RT', '0002363637', 'DKI JAKARTA', '11460', '', '', '', '', '', '31.254.253.3.036.000', '', 30, '', '', '', '', '', '', 'V030', '2014-10-13'),
(1763, 'S5821', 'EC01', 'SUKSES DIGITAL INDONESIA, PT', 'RATU PLAZA SHOPPING MALL LT.1 NO.3', '0002362808', 'JAKARTA PUSAT', '10270', '', '0212700361', '', '', '02172791949', '03.080.230.0.077.000', 'handi@suksesdigital.com', 45, '', '', '', '', '', '', 'V045', '2014-10-13'),
(1764, 'S5822', 'EC01', 'SUKSES DIGITAL INDONESIA, PT', 'RATU PLAZA SHOPPING MALL LT.1 NO.3', '0002363642', 'JAKARTA PUSAT', '10270', '', '', '', '', '', '03.080.230.0.077.000', '', 30, '', '', '', '', '', '', 'V030', '2014-10-13'),
(1765, 'S6121', 'EC01', 'SMARTFREN TELECOM,TBK, PT', 'Jl. H. Agusalim No.45 Menteng - Men', '0002362813', 'JAKARTA', '10340', '', '-', '', '', '02131927880', '02.274.977.4-054.000', 'dasmei.ziliwu@smartfren.com', 45, '', '', '', '', '', '', 'V045', '2014-10-13'),
(1766, 'S6122', 'EC01', 'SMARTFREN TELECOM,TBK, PT', 'Jl. H. Agusalim No.45 Menteng - Men', '0002363647', 'JAKARTA', '10340', '', '', '', '', '', '02.274.977.4-054.000', '', 30, '', '', '', '', '', '', 'V030', '2014-10-13'),
(1767, 'S6221', 'EC01', 'SYNNEX METRODATA INDONESIA, PT', 'APL Tower LT.42 Suite 1-8, Central', '0002362817', 'JAKARTA BARAT', '11470', '', '0215705998', '', '', '0215705988', '0019635663092000', 'alice.setiawati@metrodata.co.id', 40, '', '', '', '', '', '', 'V040', '2014-10-13'),
(1768, 'S6222', 'EC01', 'SYNNEX METRODATA INDONESIA, PT', 'APL Tower LT.42 Suite 1-8, Central', '0002363648', 'JAKARTA BARAT', '11470', '', '', '', '', '', '0019635663092000', '', 30, '', '', '', '', '', '', 'V030', '2014-10-13'),
(1769, 'T2722', 'EC01', 'TELETAMA ARTHA MANDIRI, PT', 'ROXY MAS BLOK C 4 NO 6-7', '0002363717', 'JAKARTA PUSAT', '10150', '', '', '', '', '', '', '', 21, '', '', '', '', '', '', 'V021', '2014-10-13'),
(1770, 'T2921', 'EC01', 'TECHKING ENTERPRISES INDONESIA, PT', 'JL. AM SANGAJI NO. 24', '0002362866', 'JAKARTA PUSAT', '10130', '', '02163856188', '', '', '02163856348', '01.870.151.6.052.000', 'nunu@techking.co.id', 45, '', '', '', '', '', '', 'V045', '2014-10-13'),
(1771, 'T2922', 'EC01', 'TECHKING ENTERPRISES INDONESIA, PT', 'JL. AM SANGAJI NO. 24', '0002363696', 'JAKARTA PUSAT', '10130', '', '', '', '', '', '01.870.151.6.052.000', '', 30, '', '', '', '', '', '', 'V030', '2014-10-13'),
(1772, 'T3022', 'EC01', 'TIPA ARENA CITRA. PT', 'GD.DATASCRIP', '0004552497', 'JAKARTA PUSAT', '10610', '', '216544515', '', '', '216544812', '0013258629027000', 'TANDIONO@DATASCIP.CO.ID', 30, '', '', '', '', '', '', 'V030', '2014-11-07'),
(1773, 'T3122', 'EC01', 'TOP DISTRIBUTION INDONESIA. PT', '', '0004552498', '', '', '', '', '', '', '', '', '', 0, '', '', '', '', '', '', '', '2014-11-07'),
(1774, 'T3522', 'EC01', 'TRIKOMSEL OKE, PT', 'JL. ABDUL MUIS NO 24', '0002363722', '', '00000', '', '', '', '', '', '', '', 30, '', '', '', '', '', '', 'V030', '2014-10-13'),
(1775, 'T3622', 'EC01', 'TRIYASO TELEKOMINDO. PT', '', '0004552499', '', '', '', '', '', '', '', '', '', 0, '', '', '', '', '', '', '', '2014-11-07'),
(1776, 'T3721', 'EC01', 'TIXPRO INFORMATIKA MEGAH, PT', 'RUKO ORION DUSIT NO 20 JL. MANGGA D', '0002362898', 'JAKARTA', '10730', '', '0213005440', '', '', '02130005435', '02.530.270.4-073.000', 'agustinus.cahyadi@tixpromegah.com', 45, '', '', '', '', '', '', 'V045', '2014-10-13'),
(1777, 'T3722', 'EC01', 'TIXPRO INFORMATIKA MEGAH, PT', 'RUKO ORION DUSIT NO 20 JL. MANGGA D', '0002363727', 'JAKARTA', '10730', '', '', '', '', '', '02.530.270.4-073.000', '', 30, '', '', '', '', '', '', 'V030', '2014-10-13'),
(1778, 'T3822', 'EC01', 'TELESINDO SHOP, PT', 'JL. SUKARJO WIRYOPRANOTO NO. 3A KEL', '0002363728', 'JAKARTA BARAT', '11160', '', '', '', '', '', '02.062.808.7-038.000', '', 30, '', '', '', '', '', '', 'V030', '2014-10-13'),
(1779, 'T3921', 'EC01', 'TERA DATA INDONUSA, PT', 'JL MANGA DUA ABDAD KOMP. MANGGA DUA', '0002362903', 'JAKARTA PUSAT', '10730', '', '0216266780', '', '', '0', '02.706.870.9-056.000', 'ERICK.KUSNADI@TERRA.CO.ID', 45, '', '', '', '', '', '', 'V045', '2014-10-13'),
(1780, 'T4021', 'EC01', 'TAMANSARI ADIJAYA, PT', 'GRAHA MAS BLOK C9 JL. RAYA PERJUANG', '0002362908', 'JAKARTA BARAT', '11530', '', '0215301211', '', '', '02153650307', '02.341.822.1-035.000', 'hadi@tamansariadijaya.com', 45, '', '', '', '', '', '', 'V045', '2014-10-13'),
(1781, 'T4022', 'EC01', 'TAMANSARI ADIJAYA, PT', 'GRAHA MAS BLOK C9 JL. RAYA PERJUANG', '0002363733', 'JAKARTA BARAT', '11530', '', '', '', '', '', '02.341.822.1-035.000', '', 30, '', '', '', '', '', '', 'V030', '2014-10-13'),
(1782, 'S7222', 'EC01', 'SELARAS MAKMUR SEJATI, PT', 'JL. PANGERAN JAYAKARTA', '0004595073', 'JAKARTA PUSAT', '10730', '', '216259388', '', '', '216259642', '03.048.268.1-026.000', 'JOE-HANNEZ@YAHOO.COM', 30, '', '', '', '', '', '', 'V030', '2014-11-28'),
(1783, 'S7322', 'EC01', 'SUMBER SINAR SEMESTA, PT', 'GAJAH MADA TOWER LT.20 NO.7', '0004475167', 'JAKARTA PUSAT', '10130', '', '215556818-19', '', '', '215556817', '02.005.886.3-029.000', '', 30, '', '', '', '', '', '', 'V030', '2014-10-31'),
(1784, 'S7422', 'EC01', 'SENTRA SUKSES SOLUSINDO, PT', 'NO. 26-27 JL.AGUNG PERKASA IX BLOK', '0005914192', 'JAKARTA UTARA', '14350', '', '216509156', '', '', '216512073', '03.263.065.9-048.000', 'HENDRY.THALIB@PARA-STAR.COM', 30, '', '', '', '', '', '', 'V030', '2015-06-15'),
(1785, 'S7522', 'EC01', 'SAJUN GLOBAL INDONESIA, PT', 'NO.53C JL.ROA MALAKA UTARA RT.006 R', '0005958357', 'JAKARTA BARAT', '11230', '', '2169837385', '', '', '2169837385', '70.703.081.3-033.000', 'SAJUNGLOBAL@GMAIL.COM', 30, '', '', '', '', '', '', 'V030', '2015-07-08'),
(1786, 'S7622', 'EC01', 'SETIA UTAMA DISTRINDO, PT', 'NO. 4A JL.SUKARJO WIRYOPRANOTO', '0006039587', 'JAKARTA PUSAT', '11160', '', '2129999999', '', '', '', '03.084.828.7-074.000', 'WIDINATA@SUD.CO.ID', 30, '', '', '', '', '', '', 'V030', '2015-08-11'),
(1787, 'S7721', 'EC01', 'STANLEY BLACK & DECKER , PT', 'LT. 31 MENARA STANDARD CHARTERED', '0006138587', 'JAKARTA SELATAN', '11120', '', '81368136602', '', '', '2129379360', '03.306.396.7-037.000', 'DEVI.MAULINA@SBDINC.COM', 45, '', '', '', '', '', '', 'V045', '2015-09-29'),
(1788, 'S7822', 'EC01', 'SURYA CITRA MULTIMEDIA, PT', 'KOMPLEK RUKO ITC ROXY MAS', '0006397616', 'JAKARTA PUSAT', '10150', '', '2163864878', '', '', '', '21.059.361.2-028.000', 'HANDANI.SUTRISNA@SCMINDO.CO.ID', 30, '', '', '', '', '', '', 'V030', '2016-01-06'),
(1789, 'S7922', 'EC01', 'SETAI MODERN ELEKTRONIK, PT', 'JLN. INDUSTRI RAYA III AD NO.3', '0006482733', 'TANGGERANG', '15710', '', '216320900', '', '', '215902218', '70.854.163.6-451.000', 'TANTY.CHANG@SEVERIN.CO.ID', 30, '', '', '', '', '', '', 'V030', '2016-02-10'),
(1790, 'S8021', 'EC01', 'SOLUSI INTI MANUNGGAL, PT', 'GEDUNG KIRANA TWO LT 10A', '0006566063', 'JAKARTA', '14430', '', '81291042370', '', '', '216919731', '73.964.915.0-043.000', 'CHRISTIAN@BETTERSOUND.CO.ID', 45, '', '', '', '', '', '', 'V045', '2016-03-16'),
(1791, 'S8022', 'EC01', 'SOLUSI INTI MANUNGGAL, PT', 'GEDUNG KIRANA TWO LT.10A', '0006566093', 'JAKARTA UTARA', '14430', '', '81291042370', '', '', '216919731', '73.964.915.0-043.000', 'CHRISTIAN@BETTERSOUND.CO.ID', 30, '', '', '', '', '', '', 'V030', '2016-03-16'),
(1792, 'S8122', 'EC01', 'SUKSES PRATAMA JAYA, PT', 'NO.14-15 PUSAT NIAGA ROXY MAS BLOK', '0006580133', 'JAKARTA PUSAT', '10150', '', '216331177', '', '', '2163857008', '01.955.212.4-028.000', 'CS@SUPRAJAYA.COM', 30, '', '', '', '', '', '', 'V030', '2016-03-22'),
(1793, 'S8222', 'EC01', 'SUKMA SINERGI, PT', 'GRAHA PENA LT.1', '0006612627', 'SURABAYA', '60235', '', '318271050', '', '', '318271050', '31.530.608.4-402.000', 'DEDY.ZULKHAIDIR@GMAIL.COM', 30, '', '', '', '', '', '', 'V030', '2016-04-05'),
(1794, 'S8321', 'EC01', 'SINERGI SEMPURNA SOLUSINDO, PT', 'JL. KYAI CARINGIN NO.2A', '0007321319', 'JAKARTA PUSAT', '10150', '', '2134835030', '', '', '213447366', '03.318.803.8-028.000', 'ANNY@SMARTSYSTEMSECURITY.COM', 30, '', '', '', '', '', '', 'V030', '2017-01-10'),
(1795, 'T0111', 'EC01', 'SUMBER ELECTRONIC', 'JL. MANGGA DUA ABDAD KOMP. BUMI JAY', '0002362840', 'JAKARTA', '00000', '', '0216522000', '', '', '0216544458', '', '', 30, '', '', '', '', '', '', 'V030', '2014-10-13'),
(1796, 'T0121', 'EC01', 'TITI INTERNATIONAL', 'Jl. Danau Sunter Selatan Blok O4 No', '0002362845', 'JAKARTA', '14350', '', '0216522000', '', '', '0216544458', '', '', 30, '', '', '', '', '', '', 'V030', '2014-10-13'),
(1797, 'T0221', 'EC01', 'BADAN TOSHIBA VISUAL MEDIA NETWORK', 'Setiabudi Building 2, Lt.6 Suite 60', '0002362846', 'JAKARTA', '12920', '', '0215223880', '', '', '0215223889', '001122334455667788', 'vinsen@tvmi.toshiba.co.id', 45, '', '', '', '', '', '', 'V045', '2014-10-13'),
(1798, 'T0222', 'EC01', 'NAMA SURAT MENYURAT 1', 'Setiabudi Building 2, Lt.6 Suite 60', '0002363685', 'JAKARTA', '12920', '', '', '', '', '', '11223344556677', '', 30, '', '', '', '', '', '', 'V030', '2014-10-13'),
(1799, 'T0321', 'EC01', 'TRIMITRA CAKRALESTARI, PT', 'Komp. Mangga Dua Agung Sedayu Blok', '0002362851', 'JAKARTA', '10730', '', '0216121380', '', '', '0216121379', '', '', 30, '', '', '', '', '', '', 'V030', '2014-10-13'),
(1800, 'T04122', 'EC01', 'TOENG MAKMUR, PT', 'JL. TIDAR NO 84', '0004595176', 'SURABAYA', '60251', '', '2184935325', '', '', '2184935325', '02.009.763.0-614.000', 'ZOJI_JKT@YAHOO.CO.ID', 30, '', '', '', '', '', '', 'V030', '2014-11-28'),
(1801, 'T0521', 'EC01', 'TOP JAYA SARANA UTAMA,PT', 'JL. KALI BESAR BARAT NO.40', '0002362856', 'JAKARTA', '11230', '', '0216915150', '', '', '0216912094', '01.354.540.5-038.000', 'jecky.juwono@topjaya.co.id', 45, '', '', '', '', '', '', 'V045', '2014-10-13'),
(1802, 'T0522', 'EC01', 'TOP JAYA SARANA UTAMA,PT', 'JL. KALI BESAR BARAT NO.40', '0002363690', 'JAKARTA', '11230', '', '', '', '', '', '01.354.540.5-038.000', 'hendro.gultom@topjaya.co.id', 30, '', '', '', '', '', '', 'V030', '2014-10-13'),
(1803, 'T0621', 'EC01', 'SUMBER ELECTRONIC', 'JL. MANGGA DUA ABDAD KOMP. BUMI JAY', '0002362861', 'JAKARTA', '00000', '', '02163856188', '', '', '02163856348', '', '', 30, '', '', '', '', '', '', 'V030', '2014-10-13'),
(1804, 'T0622', 'EC01', 'TECHKING ENTERPRISES INDONESIA, PT', 'JL. AM SANGAJI NO. 24', '0002363695', 'JAKARTA PUSAT', '10130', '', '', '', '', '', '01.870.151.6.052.000', '', 30, '', '', '', '', '', '', 'V030', '2014-10-13'),
(1805, 'T0721', 'EC01', 'TERA COMPUTER SYSTEM, PT', 'JL.MANGGA DUA ABDAD KOMP MANGGA DUA', '0002362867', 'JAKARTA UTARA', '00000', '', '0216255816', '', '', '0216296040', '', '', 14, '', '', '', '', '', '', 'V014', '2014-10-13'),
(1806, 'T0821', 'EC01', 'SUMBER ELECTRONIC', 'JL. Mangga Dua Abdad Komp. Bumi Jay', '0002362872', 'JAKARTA', '00000', '', '0', '', '', '0216594620', '', '', 30, '', '', '', '', '', '', 'V030', '2014-10-13'),
(1807, 'T0921', 'EC01', 'SUMBER ELECTRONIC', 'KOMP.MANGGA DUA ABDAD JL. BUMIN JAY', '0002362877', 'JAKARTA UTARA', '00000', '', '0216289205', '', '', '0216280501', '', '', 30, '', '', '', '', '', '', 'V030', '2014-10-13'),
(1808, 'T1021', 'EC01', 'SUMBER ELECTRONIC', 'JL. MANGGA DUA ABDAD KOMP. BUMI JAY', '0002362882', 'JAKARTA', '00000', '', '0', '', '', '0216504952', '', '', 30, '', '', '', '', '', '', 'V030', '2014-10-13'),
(1809, 'T1121', 'EC01', 'TRITANU', 'JL BATU TULIS RAYA NO.2', '0002362887', 'JAKARTA', '10120', '', '0213457608', '', '', '0213846804', '', '', 30, '', '', '', '', '', '', 'V030', '2014-10-13'),
(1810, 'T1122', 'EC01', 'TRITANU', '', '0004552492', '', '', '', '', '', '', '', '', '', 0, '', '', '', '', '', '', '', '2014-11-07'),
(1811, 'T1221', 'EC01', 'SUMBER ELECTRONIC', 'KOMP.MANGGA DUA ABDAD JL.BUMI JAYAK', '0002362892', 'JAKARTA UTARA', '00000', '', '0', '', '', '0215676013', '', '', 30, '', '', '', '', '', '', 'V030', '2014-10-13'),
(1812, 'T1821', 'EC01', 'TITI INTERNATIONAL', 'JL.DANAU SUNTER SELATAN BLOK 04/38', '0002362897', 'JAKARTA', '14350', '', '0216522000', '', '', '02165833222', '', '', 30, '', '', '', '', '', '', 'V030', '2014-10-13'),
(1813, 'T1822', 'EC01', 'TITI INTERNATIONAL', '', '0002363701', '', '00000', '', '', '', '', '', '', '', 30, '', '', '', '', '', '', 'V030', '2014-10-13'),
(1814, 'T2122', 'EC01', 'TECHKING ENTERPRISES INDONESIA, PT', 'JL. AM SANGAJI NO. 24', '0002363706', 'JAKARTA PUSAT', '10130', '', '', '', '', '', '01.870.151.6.052.000', '', 30, '', '', '', '', '', '', 'V030', '2014-10-13'),
(1815, 'T2221', 'EC01', 'TEJA SEKAWAN. PT', '36 JL. Pangeran Jayakarta 131', '0004548182', 'JAKARTA BARAT', '10730', '', '021-6009189/90', '', '', '', '01.148.458.1-026.001', '', 0, '', '', '', '', '', '', '', '2014-11-04'),
(1816, 'T2222', 'EC01', 'TEJA SEKAWAN, PT', 'Jl,Pangeran Jayakarta 131 A No. 36,', '0002363711', 'JAKARTA BARAT', '10730', '', '', '', '', '', 'PEM-247/WPJ.06/KP.04', '', 45, '', '', '', '', '', '', 'V045', '2014-10-13'),
(1817, 'T2622', 'EC01', 'TRITAMA PERMATA, PT', 'Perumahan Karina Sayang Blok K. 1/9', '0002363716', 'JAKARTA', '00000', '', '', '', '', '', '', '', 30, '', '', '', '', '', '', 'V030', '2014-10-13'),
(1818, 'W0522', 'EC01', 'WAHANA HASIL USAHA, PT', '', '0007419910', '', '', '', '', '', '', '', '', '', 30, '', '', '', '', '', '', 'V030', '2017-02-23'),
(1819, 'W0922', 'EC01', 'WAHANA JAYA SELULAR, PT', 'RUKAN GOLD COAST BLOK B BUKIT GOLF', '0002363782', 'JAKARTA UTARA', '14470', '', '', '', '', '', '03.040.949.4-047.000', '', 30, '', '', '', '', '', '', 'V030', '2014-10-13'),
(1820, 'W1022', 'EC01', 'WELLCOMM RITELINDO PRATAMA, PT', 'APARTEMEN MEDITERANIA', '0004475175', 'JAKARTA BARAT', '15324', '', '2153120699', '', '', '2153120599', '02.691.361.6-411.000', '', 30, '', '', '', '', '', '', 'V030', '2014-10-31'),
(1821, 'W1121', 'EC01', 'WIKO MOBILE INDONESIA, PT', 'NO.26-27 GRAHA SENTRA', '0006015804', 'JAKARTA UTARA', '14350', '', '216505211', '', '', '216505212', '72.928.300.2-048.000', 'SANDY.LIMANTO@WIKOMOBILE.CO.ID', 45, '', '', '', '', '', '', 'V045', '2015-07-30'),
(1822, 'W1122', 'EC01', 'WIKO MOBILE INDONESIA, PT', 'NO.26-27 GRAHA SENTRA', '0006015872', 'JAKARTA UTARA', '14350', '', '216505211', '', '', '216505212', '72.928.300.2-048.000', 'SANDY.LIMANTO@WIKOMOBILE.CO.ID', 30, '', '', '', '', '', '', 'V030', '2015-07-30'),
(1823, 'W1222', 'EC01', 'WAHANA TAMA PERSADA, PT', 'JL. MANGGA DUA ABDAD NO.44', '0007419919', 'JAKARTA PUSAT', '10730', '', '26564275', '', '', '', '70.143.823.6-036.000', 'CHRISIANTI@PTWTP.CO.ID', 30, '', '', '', '', '', '', 'V030', '2017-02-23'),
(1824, 'X0121', 'EC01', 'X-COM MEDIA,CV', 'GREEN GARDEN BLOK B4/11 RT.010/003', '0002362956', 'JAKARTA BARAT', '11520', '', '-', '', '', '0215631555', '0024244782039000', 'Sinar_mutiara@yahoo.com', 30, '', '', '', '', '', '', 'V030', '2014-10-13'),
(1825, 'X0122', 'EC01', 'X-COM MEDIA,CV', 'GREEN GARDEN BLOK B4/11 RT.010/003', '0002363787', 'JAKARTA BARAT', '11520', '', '', '', '', '', '0024244782039000', '', 30, '', '', '', '', '', '', 'V030', '2014-10-13'),
(1826, 'Y0222', 'EC01', 'YU WON LCD, PT', 'Kawasan Industri Modern, Jln Raya I', '0002363792', 'CIKANDE', '42186', '', '', '', '', '', '', '', 30, '', '', '', '', '', '', 'V030', '2014-10-13'),
(1827, 'Y0322', 'EC01', 'YONGMA ELECTRONICS, PT', 'JL. PLAJU NO 11 KEL. KEBON MELATI,', '0002363793', 'JAKARTA PUSAT', '10230', '', '', '', '', '', '03.313.184.8-072.000', '', 30, '', '', '', '', '', '', 'V030', '2014-10-13'),
(1828, '610001', 'EC01', 'SPEKTRA', '', '0007490952', '', '', '', '', '', '', '', '', '', 14, '', '', '', '', '', '', 'V014', '2017-08-25'),
(1829, 'X1113', 'EC01', 'TEST CONSESSI', '', '0007491049', '', '', '', '', '', '', '', '', '', 60, '', '', '', '', '', '', 'V060', '2017-12-29'),
(1830, 'T4121', 'EC01', 'TOENG MAKMUR, PT', 'JL. TIDAR NO 84', '0004617676', 'SURABAYA', '60251', '', '2184935325', '', '', '2184935325', '02.009.763.0-614.000', 'ZOJI_JKT@YAHOO.CO.ID', 45, '', '', '', '', '', '', 'V045', '2014-12-08'),
(1831, 'T4122', 'EC01', 'TOENG MAKMUR, PT', 'JL. TIDAR NO 84', '0004595187', 'SURABAYA', '60251', '', '2184935325', '', '', '2184935325', '02.009.763.0-614.000', 'ZOJI_JKT@YAHOO.CO.ID', 45, '', '', '', '', '', '', 'V045', '2014-11-28'),
(1832, 'T4222', 'EC01', 'TASINDO MANDIRI INDONESIA, PT', 'JL. RAYA SERANG KM. 13,8 CIKUPA', '0004548213', 'TANGERANG', '15710', '', '81318799257', '', '', '215963447', '02.006.169.3-451.000', 'TASINDOMANDIRI@YAHOO.CO.ID', 30, '', '', '', '', '', '', 'V030', '2014-11-04'),
(1833, 'T4322', 'EC01', 'TEG DISTRIBUTION INDONESIA, PT', 'GARDEN SHOPPING ARCADE', '0004560201', 'JAKARTA BARAT', '', '', '2129208999', '', '', '2129208988', '03.324.078.9-036.000', 'DIAN@THEEXPERTS.ASIA', 30, '', '', '', '', '', '', 'V030', '2014-11-10'),
(1834, 'T4423', 'EC01', 'TRIDI MAJU BERSAMA, PT', 'JL. RING RUDAL NO. 47', '0007142299', 'BEKASI', '17414', '', '2122017925', '', '', '2122017925', '03.159.911.1-027.000', 'ELEKBS911@GMAIL.COM', 14, '', '', '', '', '', '', 'V014', '2016-11-09'),
(1835, 'T4523', 'EC01', 'TRIDI MAJU BERSAMA, PT', 'JL. RING RUDAL NO. 47', '0007353700', 'BEKASI', '17414', '', '2122017925', '', '', '2122017925', '0031599111027000', 'ELEKBS911@GMAIL.COM', 14, '', '', '', '', '', '', 'V014', '2017-01-25'),
(1836, 'U0121', 'EC01', 'USAHA SOLUSI ANDALAN, PT', 'JL. AM SANGAJI NO 9-N', '0002362913', 'JAKARTA PUSAT', '10130', '', '0216305220', '', '', '0216305248', '', '', 30, '', '', '', '', '', '', 'V030', '2014-10-13'),
(1837, 'U0122', 'EC01', 'USAHA SOLUSI ANDALAN, PT', 'JL. AM SANGAJI NO 9-N', '0002363734', 'JAKARTA PUSAT', '10130', '', '', '', '', '', '', '', 30, '', '', '', '', '', '', 'V030', '2014-10-13'),
(1838, 'U0222', 'EC01', 'UMA GAIA, PT', 'PLAZA PERMATA JL. MH. THAMRIN NO 57', '0002363739', 'JAKARTA', '10350', '', '', '', '', '', '02.492.667.7-076.000', '', 30, '', '', '', '', '', '', 'V030', '2014-10-13'),
(1839, 'U0322', 'EC01', 'UNI DESIGN, PD', 'JL. BUKIT DURI RAYA NO : 9', '0002363744', 'JAKARTA', '12840', '', '', '', '', '', '', '', 30, '', '', '', '', '', '', 'V030', '2014-10-13'),
(1840, 'U0521', 'EC01', 'URBAN RITEL INTERNASIONAL, PT', 'JL.JEND SUDIRMAN KAV 45-46', '0006085607', 'JAKARTA SELATAN', '', '', '2129930883', '', '', '', '03.284.262.7-063.000', 'JEFFRY@GADGETCITI.COM', 45, '', '', '', '', '', '', 'V045', '2015-09-01'),
(1841, 'U0522', 'EC01', 'URBAN RITEL INTERNASIONAL, PT', 'JL.JEND.SUDIRMAN KAV 45-46', '0006085661', 'JAKARTA SELATAN', '', '', '2129930883', '', '', '', '03.284.262.7-063.000', 'JEFFRY@GADGETCITI.COM', 30, '', '', '', '', '', '', 'V030', '2015-09-01'),
(1842, 'U0621', 'EC01', 'UNILEVER INDONESIA TBK, PT', 'JL.BSD BOULEVARD BARAT', '0007261579', 'TANGGERANG SELATAN', '15345', '', '215262112', '', '', '215263330', '01.001.701.0-092.000', 'MICHAEL.VIANDY@UNILEVER.COM', 45, '', '', '', '', '', '', 'V045', '2016-12-23'),
(1843, 'U0622', 'EC01', 'UNILEVER INDONESIA TBK, PT', 'JL.BSD BOULEVARD BARAT', '0007353276', 'TANGGERANG SELATAN', '15345', '', '215262112', '', '', '215263330', '01.001.701.0-092.000', 'MICHAEL.VIANDY@UNILEVER.COM', 30, '', '', '', '', '', '', 'V030', '2017-01-25'),
(1844, 'V0121', 'EC01', 'VITRON INTERNASIONAL, PT', 'JL. MARGOMULYO PERMAI BLOK Q/15-A', '0002362914', 'SUKOMANUNNGAL-SURABAYA', '00000', '', '02164700970', '', '', '02164700973', '', '', 30, '', '', '', '', '', '', 'V030', '2014-10-13'),
(1845, 'V0221', 'EC01', 'VELINDO JAYA, PT', 'KOMP GOLDEN VILLE 88 DG JL.DAAN MOG', '0002362919', 'JAKARTA', '11510', '', '02156980518', '', '', '02156980428', '', 'oke@velindo.com', 30, '', '', '', '', '', '', 'V030', '2014-10-13'),
(1846, 'V0222', 'EC01', 'VELINDO JAYA, PT', 'KOMPLEKS, GOLDEN VILLE 88 DG, JL DA', '0002363745', 'JAKARTA', '11510', '', '', '', '', '', '', '', 30, '', '', '', '', '', '', 'V030', '2014-10-13'),
(1847, 'V0311', 'EC01', 'SUMBER ELECTRONIC', 'JL. MANGGA DUA ABDAD KOMP. BUMI JAY', '0002362924', 'JAKARTA', '00000', '', '0', '', '', '02165307423', '', '', 30, '', '', '', '', '', '', 'V030', '2014-10-13'),
(1848, 'V0321', 'EC01', 'VOCUZ ELECTRONIC', 'JL. ANGKASA DALAM 2 NO. 9', '0002362925', 'KEMAYORAN', '00000', '', '08567289999', '', '', '0216906987', '', 'hengky_thu@yahoo.com', 45, '', '', '', '', '', '', 'V045', '2014-10-13'),
(1849, 'V0322', 'EC01', 'VOCUZ ELECTRONIC', 'JL. ANGKASA DALAM 2 NO.9', '0002363750', 'KEMAYORAN', '00000', '', '', '', '', '', '', '', 30, '', '', '', '', '', '', 'V030', '2014-10-13'),
(1850, 'V0422', 'EC01', 'VISUAL CENTER MEDIA, PT', 'PURI KENCANA BLOK K7/1F', '0002363755', 'JAKARTA BARAT', '11610', '', '', '', '', '', '02.492.667.7-076.000', '', 30, '', '', '', '', '', '', 'V030', '2014-10-13'),
(1851, 'V0622', 'EC01', 'VISILAND DHARMA SARANA, PT', 'JL. AM. SANGAJI 9F, KEL. PETOJO UTA', '0002363759', 'JAKARTA PUSAT', '10130', '', '', '', '', '', '02.191.209.2-073.000', '', 30, '', '', '', '', '', '', 'V030', '2014-10-13'),
(1852, 'V0722', 'EC01', 'VISUALINDO PRESENTAPRIMA. PT', '', '0004552500', '', '', '', '', '', '', '', '', '', 0, '', '', '', '', '', '', '', '2014-11-07'),
(1853, 'V0822', 'EC01', 'VERVETAMA TECHNOLOGY, PT', 'JL. DAAN MOGOT KM 2 NO. 6AH', '0002363761', 'JAKARTA', '11460', '', '', '', '', '', '02.880.952.3-036.000', '', 30, '', '', '', '', '', '', 'V030', '2014-10-13'),
(1854, 'V0922', 'EC01', 'VITA LESTARI, PT', 'GRAHA MAMPANG LT. 3, JL. MAMPANG PR', '0002363766', 'JAKARTA SELATAN', '12760', '', '', '', '', '', 'PEM-00097/WPJ.04/KP.', '', 30, '', '', '', '', '', '', 'V030', '2014-10-13'),
(1855, 'V1021', 'EC01', 'V2 INDONESIA, PT', '5TH FLOOR INTILAND TOWER, JL.JEND S', '0002362930', 'JAKARTA', '10220', '', '', '', '', '', '02.505.349.7-022.000', '', 45, '', '', '', '', '', '', 'V045', '2014-10-13'),
(1856, 'V1022', 'EC01', 'V2 INDONESIA, PT', '5TH FLOOR INTILAND TOWER, JL.JEND S', '0002363771', 'JAKARTA', '10220', '', '', '', '', '', '02.505.349.7-022.000', '', 30, '', '', '', '', '', '', 'V030', '2014-10-13'),
(1857, 'V1041', 'EC01', 'V2 INDONESIA, PT', '5TH FLOOR INTILAND TOWER, JL.JEND S', '0002362935', 'JAKARTA', '10220', '', '', '', '', '', '02.505.349.7-022.000', '', 45, '', '', '', '', '', '', 'V045', '2014-10-13'),
(1858, 'V1122', 'EC01', 'VITA LESTARI, PT', 'LT. 03 GRAHA MAMPANG', '0004591151', 'JAKARTA SELATAN', '12760', '', '2125675485', '', '', '2125675486', '03.117.604.3-061.000', '', 30, '', '', '', '', '', '', 'V030', '2014-11-25'),
(1859, 'V1132', 'EC01', 'VITA LESTARI. PT', 'Graha Mampang LT. 3', '0004606131', 'JAKARTA SELATAN', '12760', '', '021-25675485', '', '', '', '', '', 30, '', '', '', '', '', '', 'V030', '2014-12-02'),
(1860, 'W0111', 'EC01', 'SUMBER ELECTRONIC', 'Jl. Mangga Dua Abdad Komp. Bumi Jay', '0002362940', 'JAKARTA', '00000', '', '02192920063', '', '', '0216411244', '', '', 30, '', '', '', '', '', '', 'V030', '2014-10-13'),
(1861, 'W0121', 'EC01', 'WAHANA BERSAMA ABADI, PT', 'RUKO PERMATA GUNUNG SAHARI BLOK A/8', '0002362945', 'JAKARTA', '00000', '', '0216453734', '', '', '0216454857', '', '', 30, '', '', '', '', '', '', 'V030', '2014-10-13'),
(1862, 'W0211', 'EC01', 'SUMBER ELECTRONIC', 'JL.MANGGA DUA ABDAD KOMP. BUMI JAYA', '0002362949', 'JAKARTA', '00000', '', '0213866838', '', '', '0213807935', '', '', 30, '', '', '', '', '', '', 'V030', '2014-10-13'),
(1863, 'W0221', 'EC01', 'WAHANA HASIL USAHA, PT', 'JL.MANGGA BESAR RAYA NO.107 BLOK D/', '0002362951', 'JAKARTA', '11170', '', '0213866838', '', '', '02169831032', '02.062.753.5-038.000', 'ningsih.sugito@cbn.net.id', 45, '', '', '', '', '', '', 'V045', '2014-10-13'),
(1864, 'W0222', 'EC01', 'WAHANA HASIL USAHA, PT', 'JL.MANGGA BESAR RAYA NO.107 BLOK D/', '0002363776', 'JAKARTA', '11170', '', '', '', '', '', '02.062.753.5-038.000', '', 30, '', '', '', '', '', '', 'V030', '2014-10-13'),
(1865, 'W0322', 'EC01', 'WARGA MAJU GEMILANG. PT', '', '0004552501', '', '', '', '', '', '', '', '', '', 0, '', '', '', '', '', '', '', '2014-11-07'),
(1866, 'W0422', 'EC01', 'WINER INDO SASTRIA', 'KOMP. PLUIT MALL BLOK NO. 9 JL. PLU', '0002363777', 'JAKARTA', '14440', '', '', '', '', '', '', '', 30, '', '', '', '', '', '', 'V030', '2014-10-13'),
(1867, 'DC14', 'EC01', 'CWH CITEUREP', 'KAMPUNG SABUR RT001/RW006', '0007491707', '', '16810', '', '', '', '', '', '', '', 0, '', '', '', '', '', '', '', '2019-01-25'),
(1868, 'DC13', 'EC01', 'CWH BATAM', 'Kawasan Industri Tunas Bizpark', '0007491361', '', '', '', '', '', '', '', '', '', 0, '', '', '', '', '', '', '', '2019-03-05'),
(1869, 'DC15', 'EC01', 'CWH MAKASSAR', 'Jl. Prof.Ir.Sutami (D/H Toll lama )', '0007491998', '', '', '', '', '', '', '', '', '', 0, '', '', '', '', '', '', '', '2019-03-20'),
(1870, 'DC16', 'EC01', 'CWH PALEMBANG', 'Komplek Pergudangan Skypark', '0007492324', 'PALEMBANG', '', '', '', '', '', '', '', '', 0, '', '', '', '', '', '', '', '2019-07-19'),
(1871, 'DC17', 'EC01', 'CWH UJUNG MENTENG', 'Jalan Raya Bekasi Km.26 No.29', '0007492534', 'JAKARTA TIMUR', '13960', '', '', '', '', '', '', '', 0, '', '', '', '', '', '', '', '2019-09-10'),
(1872, 'B2922', 'EC01', 'BINTANG SWISS INDONESIA, PT', 'JL. JEMBATAN III', '0007494592', 'JAKARTA UTARA', '14440', '', '87777567040', '', '', '', '75.121.634.2-075.000', 'BUDIMANPTBINTANG@GMAIL.COM', 30, '', '', '', '', '', '', 'V030', '2020-04-23'),
(1873, 'B3022', 'EC01', 'BINA JUTAJELITA, PT', 'JL. PEMBANGUNAN II NO. 26', '0007494598', 'JAKARTA PUSAT', '10130', '', '216332827', '', '', '216343105', '01.358.035.2-029.000', 'M.KHAIRUL@KUVINGSINDONESIA.ID', 30, '', '', '', '', '', '', 'V030', '2020-04-23'),
(1874, 'C2422', 'EC01', 'CUCKOO GLOBAL INDONESIA, PT', 'KOMPLEK KELAPA GADING SQUARE', '0007494604', 'JAKARTA UTARA', '14240', '', '2122458212', '', '', '', '0837611029043000', 'RANDY@CUCKOO.CO.ID', 30, '', '', '', '', '', '', 'V030', '2020-04-23'),
(1875, 'F0522', 'EC01', 'FOTILE ELECTRICAL', 'RUKAN EKSKLUSIF BLOK E NO. 32', '0007494622', 'JAKARTA UTARA', '14470', '', '21-22512354', '', '', '21-22570136', '80.755.075.1-047.000', 'DONI@FOTILE.COM', 30, '', '', '', '', '', '', 'V030', '2020-04-27'),
(1876, 'G3022', 'EC01', 'GRAHA ANUGRAH ELEKTRINDO, PT', 'KOMPLEK HARCO MANGGA DUA PLAZA', '0007494630', 'JAKARTA PUSAT', '10730', '', '216001212', '', '', '216001222', '01.934.673.3-046.000', 'TARI@GRAHA-PT.CO.ID', 30, '', '', '', '', '', '', 'V030', '2020-04-27'),
(1877, 'I4022', 'EC01', 'INTEGRITAS DINAMIKA INDONESIA, PT', 'SENTRA INDUSTRI TERPADU TAHAP III', '0007494636', 'JAKARTA UTARA', '14470', '', '2122510902', '', '', '', '0745018267047000', 'FINANCE@ANKERINDONESIA.COM', 30, '', '', '', '', '', '', 'V030', '2020-04-27'),
(1878, 'L0722', 'EC01', 'LINDY TECHNIK INDONESIA, PT', 'KOMPLEK GADING BUKIT INDAH', '0007494644', 'JAKARTA', '14240', '', '89694363835', '', '', '', '81.191.705.3-043.000', 'CHRISTIAN.TAN@LINDY-INDONESIA.ID', 30, '', '', '', '', '', '', 'V030', '2020-04-27'),
(1879, 'B0580', 'EC01', 'EC HO', '', '0007491344', '', '', '', '', '', '', '', '', '', 0, '', '', '', '', '', '', 'V000', '2018-08-10'),
(1880, 'BDC13', 'EC01', 'EC HO', '', '0007491345', '', '', '', '', '', '', '', '', '', 0, '', '', '', '', '', '', 'V000', '2018-08-10'),
(1881, 'D3922', 'EC01', 'DENKA PRATAMA INDONESIA, PT', 'GOLD COAST OFFICE PIK', '0007494717', 'JAKARTA BARAT', '14470', '', '2150110277', '', '', '', '76.041.987.9-026.000', 'ENDRA.B2B@DENKAPRATAMA.CO.ID', 30, '', '', '', '', '', '', 'V030', '2020-04-28'),
(1882, 'O0922', 'EC01', 'OSCAR GLOBAL TELESINDO, PT', 'RUKO THE ELEMENT', '0007494729', 'TANGERANG SELATAN', '15320', '', '2129315069', '', '', '2129315069', '86.335.727.3-411.000', 'DAVID_SUNARYO@OGT.CO.ID', 30, '', '', '', '', '', '', 'V030', '2020-04-28'),
(1883, 'P4222', 'EC01', 'PASSWORD RITEL SISTEM INDONESIA, PT', 'WISMA 77 TOWER 1 15 FLOOR', '0007494739', 'JAKARTA BARAT', '11410', '', '21 5363207', '', '', '21 5363208', '03.093.650.4-031.000', 'SHIRLY.LINAWATY@PASSWORD.CO.ID', 30, '', '', '', '', '', '', 'V030', '2020-04-28'),
(1884, 'S8622', 'EC01', 'SEHAT SECARA ALAMI, PT', 'THE BELLEZZA SHOPPING ARCADE', '0007494745', 'JAKARTA SELATAN', '12210', '', '2125675590', '', '', '', '82.150.681.3-013.000', 'MIA@SESA.ID', 30, '', '', '', '', '', '', 'V030', '2020-04-28'),
(1885, 'S8722', 'EC01', 'SUOAI ELEKTRONIK TEKNIKA, PT', 'BLOK J NO. 35-35A', '0007494756', '', '10730', '', '216121734', '', '', '', '81.213.483.1-044.000', 'ROBBY.EGT.MARVO@GMAIL.COM', 30, '', '', '', '', '', '', 'V030', '2020-04-28'),
(1886, 'T4622', 'EC01', 'TIGA BERLIAN ELECTRIC, PT', 'JL. PULO AYANG II NO.12 CAKUNG', '0007494764', 'JAKARTA TIMUR', '13930', '', '214600137', '', '', '214600139', '02.312.425.8-004.000', '', 30, '', '', '', '', '', '', 'V030', '2020-04-28'),
(1887, 'T5022', 'EC01', 'TRI OMEGA PUTRA, PT', 'RUKAN SEDAYU SQUARE BLOK G NO.10', '0007494854', 'JAKARTA BARAT', '11730', '', '2122557779', '', '', '2122557779', '86.130.744.5-034.000', 'SALES.TRIOMEGAPUTRA@GMAIL.COM', 30, '', '', '', '', '', '', 'V030', '2020-04-29'),
(1888, 'B2822', 'EC01', 'BERVIN INDONESIA, PT', 'KAW. INDUSTRI PT. DWIPAPURI ABADI', '0007494865', 'SUMEDANG', '45364', '', '2287835103', '', '', '22 87835102', '31.591.419.2-445.000', 'ERIK.BERVIN@GMAIL.COM', 30, '', '', '', '', '', '', 'V030', '2020-04-29'),
(1889, 'W1522', 'EC01', 'WANYE INDO PRATAMA, PT', 'KIRANA BOUTIQUE OFFICE BLOK F3/3', '0007494916', 'JAKARTA UTARA', '14240', '', '89670005008', '', '', '', '82.686.931.5-043.000', 'EFENDI@WANYEINDOPRATAMA.CO.ID', 30, '', '', '', '', '', '', 'V030', '2020-04-29'),
(1890, 'T4722', 'EC01', 'TIDAK PAKAI REPOT, PT', 'KAWASAN KOMERSIAL CILANDAK #410', '0007494925', 'JAKARTA SELATAN', '12560', '', '2127806602', '', '', '', '84.192.279.2-017.000', 'FAZAR.RIZKY@THENEWPORT.CO', 30, '', '', '', '', '', '', 'V030', '2020-04-29'),
(1891, 'D4022', 'EC01', 'DCH AURIGA INDONESIA, PT', 'GEDUNG WISMA 76 LT. 2', '0007495582', 'JAKARTA BARAT', '11410', '', '', '', '', '', '03.276.926.7-009.000', '', 0, '', '', '', '', '', '', '', '2020-05-20'),
(1892, 'M9022', 'EC01', 'MESTIKA PERSADA MAKMUR, PT', 'JL. BOULEVARD RAYA KGC/B03', '0007495583', 'JAKARTA UTARA', '14240', '', '', '', '', '', '03.223.188.8-043.000', '', 0, '', '', '', '', '', '', '', '2020-05-20'),
(1893, 'M9121', 'EC01', 'MAJU MUNDUR, PT', 'JL. JAKARTA', '0007497631', 'JAKARTA TIMUR', '13220', '', '', '', '', '', '01.001.000.1-001.000', '', 0, '', '', '', '', '', '', '', '2020-07-27'),
(1894, 'M9131', 'EC01', 'PT MAJU TERUS', '', '0007497639', '', '', '', '', '', '', '', '', '', 0, '', '', '', '', '', '', '', '2020-07-29'),
(1895, 'DC18', 'EC01', 'CWH KENDARI', 'Jl. MT Haryono', '0007497686', 'KENDARI', '93561', '', '', '', '', '', '', '', 0, '', '', '', '', '', '', '', '2020-08-31'),
(1896, 'V1223', 'EC01', 'VIVERE MULTI KREASI, PT', 'JL. LETJEN S. PARMAN NO. 6', '0007501531', '', '11480', '', '', '', '', '', '0020046355073000', '', 14, '', '', '', '', '', '', 'V014', '2020-12-22'),
(1897, 'M9222', 'EC01', 'MAJU BERSAMA, PT', 'Gedung ASD', '0007502752', 'JAKARTA BARAT', '12343', '', '23818482', '', '', '876432464', '28.241.512.5-362.023', 'majubersama123@gmail.com', 30, '', '', '', '', '', '', 'V030', '2021-03-17'),
(1898, 'E3222', 'EC01', 'ELANG CAKRAWALA INTI, PT', 'SCBD LOT22', '0007503162', 'JAKARTA SELATAN', '12190', '', '', '', '', '', '96052.808.1-012.000', '', 30, '', '', '', '', '', '', 'V030', '2021-08-25'),
(1899, 'Y1322', 'EC01', 'YONGMA ELECTRONICS, PT', 'JL. PLAJU NO 11 KEL. KEBON MELATI,', '0007503683', 'JAKARTA PUSAT', '10230', '', '021-022', '', '', '052-053', '03.313.184.8-072.000', 'XXXXXX@GMAIL.COM', 30, '', '', '', '', '', '', 'V030', '2022-05-15'),
(1900, 'Y1323', 'EC01', 'YONGMA ELECTRONICS, PT', 'JL. PLAJU NO 11 KEL. KEBON MELATI,', '0007503684', 'JAKARTA PUSAT', '10230', '', '021-022', '', '', '052-052', '03.313.184.8-072.000', 'xxxxxxx@gmail.com', 30, '', '', '', '', '', '', 'V030', '2022-05-15'),
(1901, 'Y1324', 'EC01', 'YONGMA ELECTRONICS, PT', 'JL. PLAJU NO 11 KEL. KEBON MELATI,', '0007503685', 'JAKARTA PUSAT', '10230', '', '021-022', '', '', '052-053', '03.313.184.8-072.000', 'xxxxxx@gmail.com', 30, '', '', '', '', '', '', 'V030', '2022-05-15'),
(1902, 'Y1325', 'EC01', 'YONGMA ELECTRONICS, PT', 'JL. PLAJU NO 11 KEL. KEBON MELATI,', '0007503686', 'JAKARTA PUSAT', '10230', '', '021-022', '', '', '052-053', '03.313.184.8-072.000', 'xxxx@gmail.com', 30, '', '', '', '', '', '', 'V030', '2022-05-15'),
(1903, 'Y2324', 'EC01', 'YONGMA ELECTRONICS, PT', 'JL. PLAJU NO 11 KEL. KEBON MELATI,', '0007503689', 'JAKARTA PUSAT', '10230', '', '', '', '', '', '03.313.184.8-072.000', '', 30, '', '', '', '', '', '', 'V030', '2022-05-16'),
(1904, 'Y2327', 'EC01', 'YONGMA ELECTRONICS, PT', 'JL. PLAJU NO 11 KEL. KEBON MELATI,', '0007503690', 'JAKARTA PUSAT', '10230', '', '', '', '', '', '03.313.184.8-072.000', '', 30, '', '', '', '', '', '', 'V030', '2022-05-16'),
(1905, 'Y2328', 'EC01', 'YONGMA ELECTRONICS, PT', 'JL. PLAJU NO 11 KEL. KEBON MELATI,', '0007503691', 'JAKARTA PUSAT', '10230', '', '', '', '', '', '03.313.184.8-072.000', '', 30, '', '', '', '', '', '', 'V030', '2022-05-16'),
(1906, 'Y2339', 'EC01', 'YONGMI ELECTRONICS, PT', 'JL. PLAJU NO 11 KEL. KEBON MAWAR, K', '0007503692', 'JAKARTA PUSAT', '10230', '', '', '', '', '', '03.313.184.8-072.000', '', 30, '', '', '', '', '', '', 'V030', '2022-05-16'),
(1907, 'Y2329', 'EC01', 'YONGMA ELECTRONICS, PT', 'JL. PLAJU NO 11 KEL. KEBON MELATI,', '0007503693', 'JAKARTA PUSAT', '10230', '', '', '', '', '', '03.313.184.8-072.000', '', 30, '', '', '', '', '', '', 'V030', '2022-05-16'),
(1908, 'Y2340', 'EC01', 'YONGMI ELECTRONICS, PT', 'JL. PLAJU NO 11 KEL. KEBON MAWAR, K', '0007503694', 'JAKARTA PUSAT', '10230', '', '', '', '', '', '03.313.184.8-072.000', '', 30, '', '', '', '', '', '', 'V030', '2022-05-16'),
(1909, 'Y2330', 'EC01', 'YONGMA ELECTRONICS, PT', 'JL. PLAJU NO 11 KEL. KEBON MELATI,', '0007503695', 'JAKARTA PUSAT', '10230', '', '', '', '', '', '03.313.184.8-072.000', '', 30, '', '', '', '', '', '', 'V030', '2022-05-16'),
(1910, 'Y2336', 'EC01', 'YONGMA ELECTRONICS, PT', 'JL. PLAJU NO 11 KEL. KEBON MELATI,', '0007503696', 'JAKARTA PUSAT', '10230', '', '', '', '', '', '03.313.184.8-072.000', '', 30, '', '', '', '', '', '', 'V030', '2022-05-16'),
(1911, 'Y2341', 'EC01', 'YONGMA ELECTRONICS, PT', 'JL. PLAJU NO 11 KEL. KEBON MELATI,', '0007503697', 'JAKARTA PUSAT', '10230', '', '', '', '', '', '03.313.184.8-072.000', '', 30, '', '', '', '', '', '', 'V030', '2022-05-16'),
(1912, 'Y2344', 'EC01', 'YONGMA ELECTRONICS, PT', 'JL. PLAJU NO 11 KEL. KEBON MELATI,', '0007503698', 'JAKARTA PUSAT', '10230', '', '', '', '', '', '03.313.184.8-072.000', '', 30, '', '', '', '', '', '', 'V030', '2022-05-16'),
(1913, 'Y2351', 'EC01', 'YONGMA ELECTRONICS, PT', 'JL. PLAJU NO 11 KEL. KEBON MELATI,', '0007503699', 'JAKARTA PUSAT', '10230', '', '', '', '', '', '03.313.184.8-072.000', '', 30, '', '', '', '', '', '', 'V030', '2022-05-16'),
(1914, 'Y2347', 'EC01', 'Test 16 Mei', 'Test 16 Mei', '0007503700', '', '', '', '', '', '', '', '', '', 0, '', '', '', '', '', '', '', '2022-05-16'),
(1915, 'Y2348', 'EC01', 'YONGMA ELECTRONICS, PT', 'JL. PLAJU NO 11 KEL. KEBON MELATI,', '0007503701', 'JAKARTA PUSAT', '10230', '', '', '', '', '', '', '', 0, '', '', '', '', '', '', '', '2022-05-16'),
(1916, 'Y2357', 'EC01', 'YONGMA ELECTRONICS, PT', 'JL. PLAJU NO 11 KEL. KEBON MELATI,', '0007503702', 'JAKARTA PUSAT', '10230', '', '', '', '', '', '', '', 0, '', '', '', '', '', '', '', '2022-05-16'),
(1917, 'Y2358', 'EC01', 'YONGMI ELECTRONICS, PT', 'JL. PLAJU NO 11 KEL. KEBON MAWAR, K', '0007503703', 'JAKARTA PUSAT', '10230', '', '', '', '', '', '', '', 0, '', '', '', '', '', '', '', '2022-05-16'),
(1918, 'H2321', 'EC01', 'HISENSE INTERNATIONAL INDONESIA, PT', 'SOHO CAPITAL LT 37 UNIT 05', '0007504944', 'JAKARTA BARAT', '11470', '', '', '', '', '', '', '', 60, '', '', '', '', '', '', 'V060', '2023-10-11'),
(1919, 'ZVTEST01', 'EC01', 'PT VENDOR 01', 'RT01 RW99', '0007505119', 'JAKARTA', '99999', '', '087654321', '', '', '', 'NPWP', 'VENDOR01@MAIL.COM', 45, '', '', '', '', '', '', 'V045', '2023-11-23'),
(1920, 'T5122', 'EC01', 'TES PERCOBAAN NOMOR POKOK', '', '0007505475', '', '', '', '', '', '', '', '0333333333333000', '', 30, '', '', '', '', '', '', 'V030', '2023-12-08'),
(1921, 'T5121', 'EC01', 'TES PERCOBAAN NOMOR POKOK', '', '0007505480', '', '', '', '', '', '', '', '0333333333333000', '', 45, '', '', '', '', '', '', 'V045', '2023-12-08'),
(1922, 'B0880', 'EC01', 'EC HO', '', '0007506032', '', '', '', '', '', '', '', '', '', 0, '', '', '', '', '', '', 'V000', '2024-04-17'),
(1923, 'W1621', 'EC01', 'WORLD INNOVATIVE TELECOMMUNICATION,', 'GEDUNG PERKANTORAN LANDMARK PLUIT J', '0007506210', '', '', '', '', '', '', '', '', '', 21, '', '', '', '', '', '', 'V021', '2024-06-10');

-- --------------------------------------------------------

--
-- Table structure for table `m_approver`
--

CREATE TABLE `m_approver` (
  `userid` int(11) NOT NULL,
  `approveid` int(11) NOT NULL,
  `created_by` int(11) DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `modified_by` int(11) DEFAULT NULL,
  `modified_at` datetime DEFAULT NULL ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

--
-- Dumping data for table `m_approver`
--

INSERT INTO `m_approver` (`userid`, `approveid`, `created_by`, `created_at`, `modified_by`, `modified_at`) VALUES
(1, 1, NULL, NULL, NULL, NULL),
(45, 46, NULL, NULL, NULL, NULL),
(46, 47, NULL, NULL, NULL, NULL),
(47, 48, NULL, NULL, NULL, NULL),
(48, 49, NULL, NULL, NULL, NULL),
(49, 50, NULL, NULL, NULL, NULL),
(50, 51, NULL, NULL, NULL, '2024-07-16 11:41:36'),
(51, 52, NULL, NULL, NULL, NULL),
(52, 53, NULL, NULL, NULL, NULL),
(53, 54, NULL, NULL, NULL, NULL),
(55, 56, NULL, NULL, NULL, '2024-07-16 11:39:55'),
(57, 55, NULL, NULL, NULL, NULL),
(58, 45, NULL, NULL, NULL, NULL),
(59, 55, NULL, NULL, NULL, '2024-07-16 16:46:59'),
(60, 55, NULL, NULL, NULL, '2024-07-16 16:46:59'),
(61, 55, NULL, NULL, NULL, '2024-07-16 16:46:59');

-- --------------------------------------------------------

--
-- Table structure for table `m_department`
--

CREATE TABLE `m_department` (
  `id` int(11) NOT NULL,
  `code` varchar(255) DEFAULT NULL,
  `name` varchar(255) DEFAULT NULL,
  `unitkerjaid` int(11) DEFAULT NULL,
  `direktoratid` int(11) DEFAULT NULL,
  `divisiid` int(11) DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `modified_at` datetime DEFAULT NULL ON UPDATE current_timestamp(),
  `created_by` int(11) DEFAULT NULL,
  `modified_by` int(11) DEFAULT NULL,
  `isaktif` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

--
-- Dumping data for table `m_department`
--

INSERT INTO `m_department` (`id`, `code`, `name`, `unitkerjaid`, `direktoratid`, `divisiid`, `created_at`, `modified_at`, `created_by`, `modified_by`, `isaktif`) VALUES
(1, '01', 'Management', 4, 1, 1, '2024-07-04 13:00:37', '2024-07-06 13:18:06', 1, 1, 1),
(2, '01', 'Corporate Secretary, Legal & Business Development', 4, 2, 2, '2024-07-04 13:00:37', '2024-07-06 13:18:06', 1, 1, 1),
(3, '01', 'Corporate Secretary', 4, 2, 3, '2024-07-04 13:00:37', '2024-07-06 13:18:06', 1, 1, 1),
(4, '01', 'Legal', 4, 2, 4, '2024-07-04 13:00:37', '2024-07-06 13:18:06', 1, 1, 1),
(5, '02', 'Legal Agreement & Trafic Litigation', 4, 2, 4, '2024-07-04 13:00:37', '2024-07-06 13:18:06', 1, 1, 1),
(6, '03', 'Permit & License', 4, 2, 4, '2024-07-04 13:00:37', '2024-07-06 13:18:06', 1, 1, 1),
(7, '04', 'Legal Admin', 4, 2, 4, '2024-07-04 13:00:37', '2024-07-06 13:18:06', 1, 1, 1),
(8, '01', 'Site Development', 4, 2, 5, '2024-07-04 13:00:37', '2024-07-06 13:18:06', 1, 1, 1),
(9, '02', 'Project Development', 4, 2, 5, '2024-07-04 13:00:37', '2024-07-06 13:18:06', 1, 1, 1),
(10, '03', 'Tenant & Site Development', 4, 2, 5, '2024-07-04 13:00:37', '2024-07-06 13:18:06', 1, 1, 1),
(11, '01', 'Asset Management', 4, 2, 6, '2024-07-04 13:00:37', '2024-07-06 13:18:06', 1, 1, 1),
(12, '01', 'Business Development', 4, 2, 7, '2024-07-04 13:00:37', '2024-07-06 13:18:06', 1, 1, 1),
(13, '01', 'HRD, GA & After Sales', 4, 3, 8, '2024-07-04 13:00:37', '2024-07-06 13:18:06', 1, 1, 1),
(14, '01', 'Human Resources', 4, 3, 9, '2024-07-04 13:00:37', '2024-07-06 13:18:06', 1, 1, 1),
(15, '02', 'Human Capital Development', 4, 3, 9, '2024-07-04 13:00:37', '2024-07-06 13:18:06', 1, 1, 1),
(16, '03', 'Sekretariat HRD', 4, 3, 9, '2024-07-04 13:00:37', '2024-07-06 13:18:06', 1, 1, 1),
(17, '01', 'Payroll', 4, 3, 10, '2024-07-04 13:00:37', '2024-07-06 13:18:06', 1, 1, 1),
(18, '01', 'General Affair', 4, 3, 11, '2024-07-04 13:00:37', '2024-07-06 13:18:06', 1, 1, 1),
(19, '02', 'Services & Security', 4, 3, 11, '2024-07-04 13:00:37', '2024-07-06 13:18:06', 1, 1, 1),
(20, '03', 'Equipment & Asset', 4, 3, 11, '2024-07-04 13:00:37', '2024-07-06 13:18:06', 1, 1, 1),
(21, '04', 'Maintenance', 4, 3, 11, '2024-07-04 13:00:37', '2024-07-06 13:18:06', 1, 1, 1),
(22, '05', 'Secretary', 4, 3, 11, '2024-07-04 13:00:37', '2024-07-06 13:18:06', 1, 1, 1),
(23, '01', 'Finance, Accounting & Information Technology', 4, 4, 12, '2024-07-04 13:00:37', '2024-07-06 13:18:06', 1, 1, 1),
(24, '01', 'Finance', 4, 4, 13, '2024-07-04 13:00:37', '2024-07-06 13:18:06', 1, 1, 1),
(25, '02', 'Finance Analyst (Dept)', 4, 4, 13, '2024-07-04 13:00:37', '2024-07-06 13:18:06', 1, 1, 1),
(26, '03', 'Finance (Dept)', 4, 4, 13, '2024-07-04 13:00:37', '2024-07-06 13:18:06', 1, 1, 1),
(27, '04', 'Finance Groceries', 4, 4, 13, '2024-07-04 13:00:37', '2024-07-06 13:18:06', 1, 1, 1),
(28, '01', 'Accounting', 4, 4, 14, '2024-07-04 13:00:37', '2024-07-06 13:18:06', 1, 1, 1),
(29, '02', 'Accounting (Dept)', 4, 4, 14, '2024-07-04 13:00:37', '2024-07-06 13:18:06', 1, 1, 1),
(30, '01', 'Income & Cost Analyst and Inventory', 4, 4, 15, '2024-07-04 13:00:37', '2024-07-06 13:18:06', 1, 1, 1),
(31, '02', 'Inventory Report', 4, 4, 15, '2024-07-04 13:00:37', '2024-07-06 13:18:06', 1, 1, 1),
(32, '03', 'Inventory Stock Take', 4, 4, 15, '2024-07-04 13:00:37', '2024-07-06 13:18:06', 1, 1, 1),
(33, '01', 'Information Technology', 4, 4, 16, '2024-07-04 13:00:37', '2024-07-06 13:18:06', 1, 1, 1),
(34, '02', 'IT Core System', 4, 4, 16, '2024-07-04 13:00:37', '2024-07-06 13:18:06', 1, 1, 1),
(35, '03', 'IT Operations', 4, 4, 16, '2024-07-04 13:00:37', '2024-07-06 13:18:06', 1, 1, 1),
(36, '04', 'IT Groceries', 4, 4, 16, '2024-07-04 13:00:37', '2024-07-06 13:18:06', 1, 1, 1),
(37, '01', 'Merchandising & Marketing', 4, 5, 17, '2024-07-04 13:00:37', '2024-07-06 13:18:06', 1, 1, 1),
(38, '01', 'Merchandising 1', 4, 5, 18, '2024-07-04 13:00:37', '2024-07-06 13:18:06', 1, 1, 1),
(39, '02', 'Product 1', 4, 5, 18, '2024-07-04 13:00:37', '2024-07-06 13:18:06', 1, 1, 1),
(40, '03', 'Product 8 & CBC', 4, 5, 18, '2024-07-04 13:00:37', '2024-07-06 13:18:06', 1, 1, 1),
(41, '04', 'Product 10', 4, 5, 18, '2024-07-04 13:00:37', '2024-07-06 13:18:06', 1, 1, 1),
(42, '01', 'Merchandising 2', 4, 5, 19, '2024-07-04 13:00:37', '2024-07-06 13:18:06', 1, 1, 1),
(43, '02', 'Product 2 & 3', 4, 5, 19, '2024-07-04 13:00:37', '2024-07-06 13:18:06', 1, 1, 1),
(44, '03', 'Product 5', 4, 5, 19, '2024-07-04 13:00:37', '2024-07-06 13:18:06', 1, 1, 1),
(45, '04', 'Product Development', 4, 5, 19, '2024-07-04 13:00:37', '2024-07-06 13:18:06', 1, 1, 1),
(46, '05', 'Product 12 EcoCity', 4, 5, 19, '2024-07-04 13:00:37', '2024-07-06 13:18:06', 1, 1, 1),
(47, '01', 'Product Administration', 4, 5, 20, '2024-07-04 13:00:37', '2024-07-06 13:18:06', 1, 1, 1),
(48, '01', 'Supply & Demand Planning', 4, 5, 21, '2024-07-04 13:00:37', '2024-07-06 13:18:06', 1, 1, 1),
(49, '01', 'Marketing', 4, 5, 22, '2024-07-04 13:00:37', '2024-07-06 13:18:06', 1, 1, 1),
(50, '02', 'Marketing Communication', 4, 5, 22, '2024-07-04 13:00:37', '2024-07-06 13:18:06', 1, 1, 1),
(51, '03', 'Trade Marketing', 4, 5, 22, '2024-07-04 13:00:37', '2024-07-06 13:18:06', 1, 1, 1),
(52, '04', 'CRM & Event', 4, 5, 22, '2024-07-04 13:00:37', '2024-07-06 13:18:06', 1, 1, 1),
(53, '05', 'Bank & Financing, Partnership & Marketing Support', 4, 5, 22, '2024-07-04 13:00:37', '2024-07-06 13:18:06', 1, 1, 1),
(54, '01', 'Retail Sales & Logistic', 4, 6, 23, '2024-07-04 13:00:37', '2024-07-06 13:18:06', 1, 1, 1),
(55, '01', 'Sales Offline', 4, 6, 24, '2024-07-04 13:00:37', '2024-07-06 13:18:06', 1, 1, 1),
(56, '02', 'Sales Operation', 4, 6, 24, '2024-07-04 13:00:37', '2024-07-06 13:18:06', 1, 1, 1),
(57, '01', 'Logistic', 4, 6, 25, '2024-07-04 13:00:37', '2024-07-06 13:18:06', 1, 1, 1),
(58, '02', 'National Logistic Warehouse', 4, 6, 25, '2024-07-04 13:00:37', '2024-07-06 13:18:06', 1, 1, 1),
(59, '01', 'Sales Online', 4, 6, 26, '2024-07-04 13:00:37', '2024-07-06 13:18:06', 1, 1, 1),
(60, '02', 'Product Marketing', 4, 6, 26, '2024-07-04 13:00:37', '2024-07-06 13:18:06', 1, 1, 1),
(61, '03', 'Development', 4, 6, 26, '2024-07-04 13:00:37', '2024-07-06 13:18:06', 1, 1, 1),
(62, '01', 'Wholesales', 4, 7, 27, '2024-07-04 13:00:37', '2024-07-06 13:18:06', 1, 1, 1),
(63, '01', 'Central Purchasing', 4, 7, 28, '2024-07-04 13:00:37', '2024-07-06 13:18:06', 1, 1, 1),
(64, '02', 'Sales', 4, 7, 28, '2024-07-04 13:00:37', '2024-07-06 13:18:06', 1, 1, 1),
(65, '03', 'Administration', 4, 7, 28, '2024-07-04 13:00:37', '2024-07-06 13:18:06', 1, 1, 1),
(66, '04', 'System & Wholesales Market', 4, 7, 28, '2024-07-04 13:00:37', '2024-07-06 13:18:06', 1, 1, 1),
(67, '05', 'Procurement Non Trade', 4, 7, 28, '2024-07-04 13:00:37', '2024-07-06 13:18:06', 1, 1, 1),
(68, '01', 'Wholesales Div', 4, 7, 29, '2024-07-04 13:00:37', '2024-07-06 13:18:06', 1, 1, 1),
(69, '02', 'Merchandising OEM', 4, 7, 29, '2024-07-04 13:00:37', '2024-07-06 13:18:06', 1, 1, 1),
(70, '03', 'Sales & Marketing Communication OEM', 4, 7, 29, '2024-07-04 13:00:37', '2024-07-06 13:18:06', 1, 1, 1),
(71, '04', 'SNDP OEM', 4, 7, 29, '2024-07-04 13:00:37', '2024-07-06 13:18:06', 1, 1, 1),
(72, '01', 'Internal Audit', 4, 8, 30, '2024-07-04 13:00:37', '2024-07-06 13:18:06', 1, 1, 1),
(73, '01', 'After Sales', 5, 9, 31, '2024-07-04 13:00:37', '2024-07-06 13:18:06', 1, 1, 1),
(74, '01', 'After Sales (GKT)', 5, 9, 32, '2024-07-04 13:00:37', '2024-07-06 13:18:06', 1, 1, 1),
(75, '02', 'HR & GA', 5, 9, 32, '2024-07-04 13:00:37', '2024-07-06 13:18:06', 1, 1, 1),
(76, '03', 'Marketing', 5, 9, 32, '2024-07-04 13:00:37', '2024-07-06 13:18:06', 1, 1, 1),
(77, '04', 'Sales & Operational', 5, 9, 32, '2024-07-04 13:00:37', '2024-07-06 13:18:06', 1, 1, 1),
(78, '05', 'Finance & Accounting', 5, 9, 32, '2024-07-04 13:00:37', '2024-07-06 13:18:06', 1, 1, 1),
(79, '06', 'Clean City', 5, 9, 32, '2024-07-04 13:00:37', '2024-07-06 13:18:06', 1, 1, 1),
(80, '01', 'Event & Production', 1, 10, 33, '2024-07-04 13:00:37', '2024-07-06 13:18:06', 1, 1, 1),
(81, '01', 'Event & Marketing', 1, 10, 34, '2024-07-04 13:00:37', '2024-07-06 13:18:06', 1, 1, 1),
(82, '02', 'Creative & Partnership', 1, 10, 34, '2024-07-04 13:00:37', '2024-07-06 13:18:06', 1, 1, 1),
(83, '03', 'Marketing Communication', 1, 10, 34, '2024-07-04 13:00:37', '2024-07-06 13:18:06', 1, 1, 1),
(84, '04', 'Event', 1, 10, 34, '2024-07-04 13:00:37', '2024-07-06 13:18:06', 1, 1, 1),
(85, '05', 'Sekretaris', 1, 10, 34, '2024-07-04 13:00:37', '2024-07-06 13:18:06', 1, 1, 1),
(86, '01', 'Operational', 1, 11, 35, '2024-07-04 13:00:37', '2024-07-06 13:18:06', 1, 1, 1),
(87, '01', 'FAT', 1, 11, 36, '2024-07-04 13:00:37', '2024-07-06 13:18:06', 1, 1, 1),
(88, '02', 'Tax', 1, 11, 36, '2024-07-04 13:00:37', '2024-07-06 13:18:06', 1, 1, 1),
(89, '01', 'Estate Management', 1, 11, 37, '2024-07-04 13:00:37', '2024-07-06 13:18:06', 1, 1, 1),
(90, '02', 'Operational QC', 1, 11, 37, '2024-07-04 13:00:37', '2024-07-06 13:18:06', 1, 1, 1),
(91, '03', 'HRD & GA', 1, 11, 37, '2024-07-04 13:00:37', '2024-07-06 13:18:06', 1, 1, 1),
(92, '04', 'Legal', 1, 11, 37, '2024-07-04 13:00:37', '2024-07-06 13:18:06', 1, 1, 1),
(93, '01', 'Groceries', 2, 12, 38, '2024-07-04 13:00:37', '2024-07-06 13:18:06', 1, 1, 1),
(94, '01', 'Commercial', 2, 12, 39, '2024-07-04 13:00:37', '2024-07-06 13:18:06', 1, 1, 1),
(95, '02', 'Merchandising', 2, 12, 39, '2024-07-04 13:00:37', '2024-07-06 13:18:06', 1, 1, 1),
(96, '03', 'Sales Operation', 2, 12, 39, '2024-07-04 13:00:37', '2024-07-06 13:18:06', 1, 1, 1),
(97, '04', 'Marketing', 2, 12, 39, '2024-07-04 13:00:37', '2024-07-06 13:18:06', 1, 1, 1),
(98, '01', 'FA & IT', 2, 12, 40, '2024-07-04 13:00:37', '2024-07-06 13:18:06', 1, 1, 1),
(99, '02', 'Finance & Accounting', 2, 12, 40, '2024-07-04 13:00:37', '2024-07-06 13:18:06', 1, 1, 1),
(100, '03', 'Information Technology', 2, 12, 40, '2024-07-04 13:00:37', '2024-07-06 13:18:06', 1, 1, 1),
(101, '01', 'Niscaya Raharja Calya', 3, 13, 41, '2024-07-04 13:00:37', '2024-07-06 13:18:06', 1, 1, 1);

-- --------------------------------------------------------

--
-- Table structure for table `m_direktorat`
--

CREATE TABLE `m_direktorat` (
  `id` int(11) NOT NULL,
  `code` varchar(255) DEFAULT NULL,
  `name` varchar(255) DEFAULT NULL,
  `unitkerjaid` int(11) DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `modified_at` datetime DEFAULT NULL ON UPDATE current_timestamp(),
  `created_by` int(11) DEFAULT NULL,
  `modified_by` int(11) DEFAULT NULL,
  `isaktif` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

--
-- Dumping data for table `m_direktorat`
--

INSERT INTO `m_direktorat` (`id`, `code`, `name`, `unitkerjaid`, `created_at`, `modified_at`, `created_by`, `modified_by`, `isaktif`) VALUES
(1, '01', 'Management', 4, '2024-07-04 11:33:24', '2024-07-06 13:15:24', 1, 1, 1),
(2, '02', 'Corporate Secretary, Legal & Business Development', 4, '2024-07-04 11:33:24', '2024-07-06 13:15:24', 1, 1, 1),
(3, '03', 'HRD, GA & After Sales', 4, '2024-07-04 11:33:24', '2024-07-06 13:15:24', 1, 1, 1),
(4, '04', 'Finance, Accounting & Information Technology', 4, '2024-07-04 11:33:24', '2024-07-06 13:15:24', 1, 1, 1),
(5, '05', 'Merchandising & Marketing', 4, '2024-07-04 11:33:24', '2024-07-06 13:15:24', 1, 1, 1),
(6, '06', 'Retail Sales & Logistic', 4, '2024-07-04 11:33:24', '2024-07-06 13:15:24', 1, 1, 1),
(7, '07', 'Wholesales', 4, '2024-07-04 11:33:24', '2024-07-06 13:15:24', 1, 1, 1),
(8, '08', 'Internal Audit', 4, '2024-07-04 11:33:24', '2024-07-06 13:15:24', 1, 1, 1),
(9, '01', 'After Sales', 5, '2024-07-04 11:33:24', '2024-07-06 13:15:24', 1, 1, 1),
(10, '01', 'Event & Production', 1, '2024-07-04 11:33:24', '2024-07-06 13:15:24', 1, 1, 1),
(11, '02', 'Operational', 1, '2024-07-04 11:33:24', '2024-07-06 13:15:24', 1, 1, 1),
(12, '01', 'Groceries', 2, '2024-07-04 11:33:24', '2024-07-06 13:15:24', 1, 1, 1),
(13, '01', 'Niscaya Raharja Calya', 3, '2024-07-04 11:33:24', '2024-07-06 13:15:24', 1, 1, 1);

-- --------------------------------------------------------

--
-- Table structure for table `m_divisi`
--

CREATE TABLE `m_divisi` (
  `id` int(11) NOT NULL,
  `code` varchar(255) DEFAULT NULL,
  `name` varchar(255) DEFAULT NULL,
  `unitkerjaid` int(11) DEFAULT NULL,
  `direktoratid` int(11) DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `modified_at` datetime DEFAULT NULL ON UPDATE current_timestamp(),
  `created_by` int(11) DEFAULT NULL,
  `modified_by` int(11) DEFAULT NULL,
  `isaktif` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

--
-- Dumping data for table `m_divisi`
--

INSERT INTO `m_divisi` (`id`, `code`, `name`, `unitkerjaid`, `direktoratid`, `created_at`, `modified_at`, `created_by`, `modified_by`, `isaktif`) VALUES
(1, '01', 'Management', 4, 1, '2024-07-04 11:40:04', '2024-07-06 13:17:08', 1, 1, 1),
(2, '01', 'Corporate Secretary, Legal & Business Development', 4, 2, '2024-07-04 11:40:04', '2024-07-06 13:17:08', 1, 1, 1),
(3, '02', 'Corporate Secretary', 4, 2, '2024-07-04 11:40:04', '2024-07-06 13:17:08', 1, 1, 1),
(4, '03', 'Legal', 4, 2, '2024-07-04 11:40:04', '2024-07-06 13:17:08', 1, 1, 1),
(5, '04', 'Site Development', 4, 2, '2024-07-04 11:40:04', '2024-07-06 13:17:08', 1, 1, 1),
(6, '05', 'Asset Management', 4, 2, '2024-07-04 11:40:04', '2024-07-06 13:17:08', 1, 1, 1),
(7, '06', 'Business Development', 4, 2, '2024-07-04 11:40:04', '2024-07-06 13:17:08', 1, 1, 1),
(8, '01', 'HRD, GA & After Sales', 4, 3, '2024-07-04 11:40:04', '2024-07-06 13:17:08', 1, 1, 1),
(9, '02', 'Human Resources', 4, 3, '2024-07-04 11:40:04', '2024-07-06 13:17:08', 1, 1, 1),
(10, '03', 'Payroll', 4, 3, '2024-07-04 11:40:04', '2024-07-06 13:17:08', 1, 1, 1),
(11, '04', 'General Affair', 4, 3, '2024-07-04 11:40:04', '2024-07-06 13:17:08', 1, 1, 1),
(12, '01', 'Finance, Accounting & Information Technology', 4, 4, '2024-07-04 11:40:04', '2024-07-06 13:17:08', 1, 1, 1),
(13, '02', 'Finance', 4, 4, '2024-07-04 11:40:04', '2024-07-06 13:17:08', 1, 1, 1),
(14, '03', 'Accounting', 4, 4, '2024-07-04 11:40:04', '2024-07-06 13:17:08', 1, 1, 1),
(15, '04', 'Income & Cost Analyst and Inventory', 4, 4, '2024-07-04 11:40:04', '2024-07-06 13:17:08', 1, 1, 1),
(16, '05', 'Information Technology', 4, 4, '2024-07-04 11:40:04', '2024-07-06 13:17:08', 1, 1, 1),
(17, '01', 'Merchandising & Marketing', 4, 5, '2024-07-04 11:40:04', '2024-07-06 13:17:08', 1, 1, 1),
(18, '02', 'Merchandising 1', 4, 5, '2024-07-04 11:40:04', '2024-07-06 13:17:08', 1, 1, 1),
(19, '03', 'Merchandising 2', 4, 5, '2024-07-04 11:40:04', '2024-07-06 13:17:08', 1, 1, 1),
(20, '04', 'Product Administration', 4, 5, '2024-07-04 11:40:04', '2024-07-06 13:17:08', 1, 1, 1),
(21, '05', 'Supply & Demand Planning', 4, 5, '2024-07-04 11:40:04', '2024-07-06 13:17:08', 1, 1, 1),
(22, '06', 'Marketing', 4, 5, '2024-07-04 11:40:04', '2024-07-06 13:17:08', 1, 1, 1),
(23, '01', 'Retail Sales & Logistic', 4, 6, '2024-07-04 11:40:04', '2024-07-06 13:17:08', 1, 1, 1),
(24, '02', 'Sales Offline', 4, 6, '2024-07-04 11:40:04', '2024-07-06 13:17:08', 1, 1, 1),
(25, '03', 'Logistic', 4, 6, '2024-07-04 11:40:04', '2024-07-06 13:17:08', 1, 1, 1),
(26, '04', 'Sales Online', 4, 6, '2024-07-04 11:40:04', '2024-07-06 13:17:08', 1, 1, 1),
(27, '01', 'Wholesales', 4, 7, '2024-07-04 11:40:04', '2024-07-06 13:17:08', 1, 1, 1),
(28, '02', 'Central Purchasing', 4, 7, '2024-07-04 11:40:04', '2024-07-06 13:17:08', 1, 1, 1),
(29, '03', 'Wholesales Div', 4, 7, '2024-07-04 11:40:04', '2024-07-06 13:17:08', 1, 1, 1),
(30, '01', 'Internal Audit', 4, 8, '2024-07-04 11:40:04', '2024-07-06 13:17:08', 1, 1, 1),
(31, '01', 'After Sales', 5, 9, '2024-07-04 11:40:04', '2024-07-06 13:17:08', 1, 1, 1),
(32, '02', 'After Sales (GKT)', 5, 9, '2024-07-04 11:40:04', '2024-07-06 13:17:08', 1, 1, 1),
(33, '01', 'Event & Production', 1, 10, '2024-07-04 11:40:04', '2024-07-06 13:17:08', 1, 1, 1),
(34, '02', 'Event & Marketing', 1, 10, '2024-07-04 11:40:04', '2024-07-06 13:17:08', 1, 1, 1),
(35, '01', 'Operational', 1, 11, '2024-07-04 11:40:04', '2024-07-06 13:17:08', 1, 1, 1),
(36, '02', 'FAT', 1, 11, '2024-07-04 11:40:04', '2024-07-06 13:17:08', 1, 1, 1),
(37, '03', 'Estate Management', 1, 11, '2024-07-04 11:40:04', '2024-07-06 13:17:08', 1, 1, 1),
(38, '01', 'Groceries', 2, 12, '2024-07-04 11:40:04', '2024-07-06 13:17:08', 1, 1, 1),
(39, '02', 'Commercial', 2, 12, '2024-07-04 11:40:04', '2024-07-06 13:17:08', 1, 1, 1),
(40, '03', 'FA & IT', 2, 12, '2024-07-04 11:40:04', '2024-07-06 13:17:08', 1, 1, 1),
(41, '01', 'Niscaya Raharja Calya', 3, 13, '2024-07-04 11:40:04', '2024-07-06 13:17:08', 1, 1, 1);

-- --------------------------------------------------------

--
-- Table structure for table `m_group`
--

CREATE TABLE `m_group` (
  `id` int(11) NOT NULL,
  `usergroupname` varchar(255) DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `modified_at` datetime DEFAULT NULL ON UPDATE current_timestamp(),
  `created_by` int(11) DEFAULT NULL,
  `modified_by` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

--
-- Dumping data for table `m_group`
--

INSERT INTO `m_group` (`id`, `usergroupname`, `created_at`, `modified_at`, `created_by`, `modified_by`) VALUES
(1, 'ADMINISTRATOR', '2024-07-03 19:33:54', '2024-07-04 13:22:52', 1, 1),
(3, 'APPROVER 1 LPBJ', '2024-07-03 19:33:54', '2024-07-15 17:14:06', 1, 1),
(4, 'ADMIN DEPARTEMEN', '2024-07-03 19:33:54', '2024-07-04 13:22:52', 1, 1),
(5, 'ADMIN PROCUREMENT', '2024-07-03 19:33:54', '2024-07-04 13:22:52', 1, 1),
(8, 'APPROVER 2 LPBJ', NULL, '2024-07-15 17:14:10', NULL, NULL),
(9, 'APPROVER 1 QE', NULL, '2024-07-15 17:14:15', NULL, NULL),
(10, 'APPROVER 2 QE', NULL, '2024-07-15 17:14:19', NULL, NULL),
(11, 'APPROVER 3 QE', NULL, '2024-07-15 17:14:23', NULL, NULL),
(12, 'APPROVER 4 QE', NULL, '2024-07-15 17:14:49', NULL, NULL),
(13, 'APPROVER 5 QE', NULL, '2024-07-15 17:14:51', NULL, NULL),
(14, 'APPROVER 6 QE', NULL, '2024-07-15 17:14:53', NULL, NULL),
(15, 'APPROVER 7 QE', NULL, '2024-07-15 17:14:55', NULL, NULL),
(16, 'APPROVER 8 QE', NULL, '2024-07-15 17:14:57', NULL, NULL),
(17, 'APPROVER 9 QE', NULL, '2024-07-15 17:15:03', NULL, NULL),
(18, 'APPROVER 10 QE', NULL, '2024-07-15 17:15:06', NULL, NULL);

-- --------------------------------------------------------

--
-- Table structure for table `m_jabatan`
--

CREATE TABLE `m_jabatan` (
  `id` int(11) NOT NULL,
  `name` varchar(255) DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `modified_at` datetime DEFAULT NULL ON UPDATE current_timestamp(),
  `created_by` int(11) DEFAULT NULL,
  `modified_by` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

--
-- Dumping data for table `m_jabatan`
--

INSERT INTO `m_jabatan` (`id`, `name`, `created_at`, `modified_at`, `created_by`, `modified_by`) VALUES
(1, 'Admin & CC', '2024-07-03 20:32:16', '2024-07-03 20:32:32', 1, 1),
(2, 'Admin & System', '2024-07-03 20:32:16', '2024-07-03 20:32:32', 1, 1),
(3, 'Admin Buyer', '2024-07-03 20:32:16', '2024-07-03 20:32:32', 1, 1),
(4, 'Admin Direct Sales', '2024-07-03 20:32:16', '2024-07-03 20:32:32', 1, 1),
(5, 'Admin E-Commerce', '2024-07-03 20:32:16', '2024-07-03 20:32:32', 1, 1),
(6, 'Admin Event', '2024-07-03 20:32:16', '2024-07-03 20:32:32', 1, 1),
(7, 'Admin Inventory Stock Take', '2024-07-03 20:32:16', '2024-07-03 20:32:32', 1, 1),
(8, 'Admin Sales Website', '2024-07-03 20:32:16', '2024-07-03 20:32:32', 1, 1),
(9, 'Administrasi', '2024-07-03 20:32:16', '2024-07-03 20:32:32', 1, 1),
(10, 'Administrasi Logistik', '2024-07-03 20:32:16', '2024-07-03 20:32:32', 1, 1),
(11, 'Administrasi Product', '2024-07-03 20:32:16', '2024-07-03 20:32:32', 1, 1),
(12, 'Budget Control & Administrasi', '2024-07-03 20:32:16', '2024-07-03 20:32:32', 1, 1),
(13, 'Codif & Admin', '2024-07-03 20:32:16', '2024-07-03 20:32:32', 1, 1),
(14, 'Estate Admin', '2024-07-03 20:32:16', '2024-07-03 20:32:32', 1, 1),
(15, 'IT Administration Staff', '2024-07-03 20:32:16', '2024-07-03 20:32:32', 1, 1),
(16, 'Maintenance Administration Staff', '2024-07-03 20:32:16', '2024-07-03 20:32:32', 1, 1),
(17, 'Programmer non ABAP', '2024-07-03 20:32:16', '2024-07-03 20:32:32', 1, 1),
(18, 'Server Administrator', '2024-07-03 20:32:16', '2024-07-03 20:32:32', 1, 1);

-- --------------------------------------------------------

--
-- Table structure for table `m_level`
--

CREATE TABLE `m_level` (
  `id` int(11) NOT NULL,
  `name` varchar(255) DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `modified_at` datetime DEFAULT NULL ON UPDATE current_timestamp(),
  `created_by` int(11) DEFAULT NULL,
  `modified_by` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

--
-- Dumping data for table `m_level`
--

INSERT INTO `m_level` (`id`, `name`, `created_at`, `modified_at`, `created_by`, `modified_by`) VALUES
(1, 'Direktur Utama', '2024-07-03 20:24:50', '2024-07-03 20:25:16', 1, 1),
(2, 'Direktur', '2024-07-03 20:24:50', '2024-07-03 20:25:16', 1, 1),
(3, 'Vice President', '2024-07-03 20:24:50', '2024-07-03 20:25:16', 1, 1),
(4, 'Komisaris', '2024-07-03 20:24:50', '2024-07-03 20:25:16', 1, 1),
(5, 'Head of Komite Audit', '2024-07-03 20:24:50', '2024-07-03 20:25:16', 1, 1),
(6, 'General Manager', '2024-07-03 20:24:50', '2024-07-03 20:25:16', 1, 1),
(7, 'Senior Manager', '2024-07-03 20:24:50', '2024-07-03 20:25:16', 1, 1),
(8, 'Manager', '2024-07-03 20:24:50', '2024-07-03 20:25:16', 1, 1),
(9, 'Assistant Manager', '2024-07-03 20:24:50', '2024-07-03 20:25:16', 1, 1),
(10, 'Senior Supervisor', '2024-07-03 20:24:50', '2024-07-03 20:25:16', 1, 1),
(11, 'Supervisor', '2024-07-03 20:24:50', '2024-07-03 20:25:16', 1, 1),
(12, 'Senior Staff', '2024-07-03 20:24:50', '2024-07-03 20:25:16', 1, 1),
(13, 'Staff', '2024-07-03 20:24:50', '2024-07-03 20:25:16', 1, 1),
(14, 'Non Staff', '2024-07-03 20:24:50', '2024-07-03 20:25:16', 1, 1);

-- --------------------------------------------------------

--
-- Table structure for table `m_lokasi`
--

CREATE TABLE `m_lokasi` (
  `id` int(11) NOT NULL,
  `code` varchar(255) DEFAULT NULL,
  `name` varchar(255) DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `modified_at` datetime DEFAULT NULL ON UPDATE current_timestamp(),
  `created_by` int(11) DEFAULT NULL,
  `modified_by` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

--
-- Dumping data for table `m_lokasi`
--

INSERT INTO `m_lokasi` (`id`, `code`, `name`, `created_at`, `modified_at`, `created_by`, `modified_by`) VALUES
(1, '1000', 'ECI HEAD OFFICE', '2024-07-04 13:51:16', '2024-07-04 13:51:24', 1, 1),
(2, '0001', 'SCBD', '2024-07-04 13:51:16', '2024-07-04 13:51:34', 1, 1),
(3, '0010', 'MAG', '2024-07-04 13:51:16', '2024-07-04 13:51:34', 1, 1),
(4, '0030', 'LIPPO MALL PURI', '2024-07-04 13:51:16', '2024-07-04 13:51:34', 1, 1),
(5, '0040', 'BALI', '2024-07-04 13:51:16', '2024-07-04 13:51:34', 1, 1),
(6, '0050', 'KARAWACI', '2024-07-04 13:51:16', '2024-07-04 13:51:34', 1, 1),
(7, '0060', 'DEPOK MARGO', '2024-07-04 13:51:16', '2024-07-04 13:51:34', 1, 1),
(8, '0070', 'BOTANI SQUARE', '2024-07-04 13:51:16', '2024-07-04 13:51:34', 1, 1),
(9, '0080', 'MEDAN', '2024-07-04 13:51:16', '2024-07-04 13:51:34', 1, 1),
(10, '0090', 'REVO TOWN BEKASI', '2024-07-04 13:51:16', '2024-07-04 13:51:34', 1, 1),
(11, '0110', 'BEKASI METMAL', '2024-07-04 13:51:16', '2024-07-04 13:51:35', 1, 1),
(12, '0130', 'KRAMAT JATI', '2024-07-04 13:51:16', '2024-07-04 13:51:35', 1, 1),
(13, '0140', 'LIPPO PLAZA BOGOR', '2024-07-04 13:51:16', '2024-07-04 13:51:35', 1, 1),
(14, '0160', 'CINERE', '2024-07-04 13:51:16', '2024-07-04 13:51:35', 1, 1),
(15, '0170', 'BINTARO', '2024-07-04 13:51:16', '2024-07-04 13:51:35', 1, 1),
(16, '0190', 'TAMINI SQUARE', '2024-07-04 13:51:16', '2024-07-04 13:51:35', 1, 1),
(17, '0220', 'PONDOK INDAH', '2024-07-04 13:51:16', '2024-07-04 13:51:35', 1, 1),
(18, '0230', 'RUKO BUARAN', '2024-07-04 13:51:16', '2024-07-04 13:51:35', 1, 1),
(19, '0240', 'RUKO JUANDA', '2024-07-04 13:51:16', '2024-07-04 13:51:35', 1, 1),
(20, '0250', 'RUKO SUNTER', '2024-07-04 13:51:16', '2024-07-04 13:51:35', 1, 1),
(21, '0260', 'RUKO PEJATEN', '2024-07-04 13:51:16', '2024-07-04 13:51:35', 1, 1),
(22, '0270', 'RUKO PEMUDA', '2024-07-04 13:51:16', '2024-07-04 13:51:35', 1, 1),
(23, '0280', 'RUKO KELAPA GADING', '2024-07-04 13:51:16', '2024-07-04 13:51:35', 1, 1),
(24, '0290', 'RUKO CIKARANG', '2024-07-04 13:51:16', '2024-07-04 13:51:35', 1, 1),
(25, '0300', 'RUKO AMPERA', '2024-07-04 13:51:16', '2024-07-04 13:51:35', 1, 1),
(26, '0620', 'KALIBATA', '2024-07-04 13:51:16', '2024-07-04 13:51:35', 1, 1),
(27, '0320', 'KARTINI LAMPUNG', '2024-07-04 13:51:16', '2024-07-04 13:51:35', 1, 1),
(28, '0330', 'RUKO PONTIANAK', '2024-07-04 13:51:16', '2024-07-04 13:51:35', 1, 1),
(29, '0350', 'RUKO JABABEKA', '2024-07-04 13:51:16', '2024-07-04 13:51:35', 1, 1),
(30, '0370', 'ALAM SUTRA', '2024-07-04 13:51:16', '2024-07-04 13:51:35', 1, 1),
(31, '0630', 'GREEN PRAMUKA', '2024-07-04 13:51:16', '2024-07-04 13:51:35', 1, 1),
(32, '0390', 'RUKO TEBET', '2024-07-04 13:51:16', '2024-07-04 13:51:35', 1, 1),
(33, '0400', 'CIANJUR', '2024-07-04 13:51:16', '2024-07-04 13:51:35', 1, 1),
(34, '0420', 'KENDARI', '2024-07-04 13:51:16', '2024-07-04 13:51:35', 1, 1),
(35, '0430', 'PEKALONGAN', '2024-07-04 13:51:16', '2024-07-04 13:51:35', 1, 1),
(36, '0440', 'BATAM', '2024-07-04 13:51:16', '2024-07-04 13:51:35', 1, 1),
(37, '0450', 'CIPINANG INDAH', '2024-07-04 13:51:16', '2024-07-04 13:51:35', 1, 1),
(38, '0470', 'JOGJA CITY MALL', '2024-07-04 13:51:16', '2024-07-04 13:51:35', 1, 1),
(39, '0480', 'ARMADA TOWN SQUARE', '2024-07-04 13:51:16', '2024-07-04 13:51:35', 1, 1),
(40, '0490', 'PALEMBANG ICON MALL', '2024-07-04 13:51:16', '2024-07-04 13:51:35', 1, 1),
(41, '0510', 'GREEN TERRACE', '2024-07-04 13:51:16', '2024-07-04 13:51:35', 1, 1),
(42, '0520', 'UJUNG MENTENG', '2024-07-04 13:51:16', '2024-07-04 13:51:35', 1, 1),
(43, '0530', 'GRAGE CITY MALL', '2024-07-04 13:51:16', '2024-07-04 13:51:35', 1, 1),
(44, '0540', 'RUKO KAGUM CITY', '2024-07-04 13:51:16', '2024-07-04 13:51:35', 1, 1),
(45, '0550', 'MALANG TOWN SQUARE', '2024-07-04 13:51:16', '2024-07-04 13:51:35', 1, 1),
(46, '0560', 'KEDATON LAMPUNG', '2024-07-04 13:51:16', '2024-07-04 13:51:35', 1, 1),
(47, '0570', 'METLAND CILEUNGSI', '2024-07-04 13:51:16', '2024-07-04 13:51:35', 1, 1),
(48, '5001', 'CIBUBUR', '2024-07-04 13:51:16', '2024-07-04 13:51:35', 1, 1),
(49, '5003', 'DAAN MOGOT', '2024-07-04 13:51:16', '2024-07-04 13:51:35', 1, 1),
(50, '5004', 'PAMULANG', '2024-07-04 13:51:16', '2024-07-04 13:51:35', 1, 1),
(51, '5006', 'SERANG', '2024-07-04 13:51:16', '2024-07-04 13:51:35', 1, 1),
(52, '5007', 'CILEGON', '2024-07-04 13:51:16', '2024-07-04 13:51:35', 1, 1),
(53, '5008', 'GATSU BALI', '2024-07-04 13:51:16', '2024-07-04 13:51:35', 1, 1),
(54, '5011', 'SARI PLAZA', '2024-07-04 13:51:16', '2024-07-04 13:51:35', 1, 1),
(55, '5012', 'PURWAKARTA', '2024-07-04 13:51:16', '2024-07-04 13:51:35', 1, 1),
(56, '5013', 'CIMAHI', '2024-07-04 13:51:16', '2024-07-04 13:51:35', 1, 1),
(57, '5014', 'JATINANGOR', '2024-07-04 13:51:16', '2024-07-04 13:51:35', 1, 1),
(58, '5015', 'BOGOR TRADE MALL', '2024-07-04 13:51:16', '2024-07-04 13:51:35', 1, 1),
(59, '5016', 'MALL CILEGON', '2024-07-04 13:51:16', '2024-07-04 13:51:35', 1, 1),
(60, '8002', 'FO - CIKUPA', '2024-07-04 13:51:16', '2024-07-04 13:51:35', 1, 1),
(61, 'DC01', 'DC - Klender', '2024-07-04 13:51:16', '2024-07-04 13:51:35', 1, 1),
(62, 'DC02', 'DC - Cibinong', '2024-07-04 13:51:16', '2024-07-04 13:51:35', 1, 1),
(63, 'DC03', 'DC - Curug', '2024-07-04 13:51:16', '2024-07-04 13:51:35', 1, 1),
(64, 'DC04', 'DC - Bali Gatsu', '2024-07-04 13:51:16', '2024-07-04 13:51:35', 1, 1),
(65, 'DC05', 'DC - Padalarang', '2024-07-04 13:51:16', '2024-07-04 13:51:35', 1, 1),
(66, 'DC07', 'DC - Magelang', '2024-07-04 13:51:16', '2024-07-04 13:51:35', 1, 1),
(67, 'DC08', 'DC - Medan', '2024-07-04 13:51:16', '2024-07-04 13:51:35', 1, 1),
(68, 'DC10', 'DC - Cirebon', '2024-07-04 13:51:16', '2024-07-04 13:51:35', 1, 1),
(69, 'DC12', 'DC - Lampung', '2024-07-04 13:51:16', '2024-07-04 13:51:35', 1, 1),
(70, 'DC13', 'DC - Batam', '2024-07-04 13:51:16', '2024-07-04 13:51:35', 1, 1),
(71, '0580', 'MEGA MALL BATAM', '2024-07-04 13:51:16', '2024-07-04 13:51:35', 1, 1),
(72, '0590', 'LW PEKANBARU', '2024-07-04 13:51:16', '2024-07-04 13:51:35', 1, 1),
(73, '0610', 'CILEGON CENTER MALL', '2024-07-04 13:51:16', '2024-07-04 13:51:35', 1, 1),
(74, '0600', 'NIPAH MALL MAKASSAR', '2024-07-04 13:51:16', '2024-07-04 13:51:35', 1, 1),
(75, 'DC14', 'DC - Citeureup', '2024-07-04 13:51:16', '2024-07-04 13:51:35', 1, 1),
(76, '0640', 'TANGCITY MALL', '2024-07-04 13:51:16', '2024-07-04 13:51:35', 1, 1),
(77, '0650', 'KOTA KASABLANKA', '2024-07-04 13:51:16', '2024-07-04 13:51:35', 1, 1),
(78, 'DC15', 'DC - Makassar', '2024-07-04 13:51:16', '2024-07-04 13:51:35', 1, 1),
(79, '0660', 'PANAKUKANG', '2024-07-04 13:51:16', '2024-07-04 13:51:35', 1, 1),
(80, 'DC16', 'DC - Palembang', '2024-07-04 13:51:16', '2024-07-04 13:51:35', 1, 1),
(81, '0670', 'CIBINONG CITY MALL', '2024-07-04 13:51:16', '2024-07-04 13:51:35', 1, 1),
(82, '0680', 'OPI MALL PALEMBANG', '2024-07-04 13:51:16', '2024-07-04 13:51:35', 1, 1),
(83, '0690', 'LIPPO MALL CIKARANG', '2024-07-04 13:51:16', '2024-07-04 13:51:35', 1, 1),
(84, '0700', 'BAG KENDARI', '2024-07-04 13:51:16', '2024-07-04 13:51:36', 1, 1),
(85, 'DC18', 'DC - Kendari', '2024-07-04 13:51:16', '2024-07-04 13:51:36', 1, 1),
(86, '0710', 'BAG BOGOR', '2024-07-04 13:51:16', '2024-07-04 13:51:36', 1, 1),
(87, 'DC17', 'DC - Ujung Menteng', '2024-07-04 13:51:16', '2024-07-04 13:51:36', 1, 1),
(88, '0720', 'GAIA BUMI RAYA MALL', '2024-07-04 13:51:16', '2024-07-04 13:51:36', 1, 1),
(89, '0730', 'CITRA RAYA CIKUPA', '2024-07-04 13:51:16', '2024-07-04 13:51:36', 1, 1),
(90, '0740', 'THE PARK SAWANGAN', '2024-07-04 13:51:16', '2024-07-04 13:51:36', 1, 1),
(91, '0750', 'MANADO TOWN SQUARE', '2024-07-04 13:51:16', '2024-07-04 13:51:36', 1, 1),
(92, '0760', 'PASKAL BANDUNG', '2024-07-04 13:51:16', '2024-07-04 13:51:36', 1, 1),
(93, '0800', 'CENTER POINT MEDAN', '2024-07-04 13:51:16', '2024-07-04 13:51:36', 1, 1),
(94, '0770', 'PIK AVENUE', '2024-07-04 13:51:16', '2024-07-04 13:51:36', 1, 1),
(95, '0790', 'GANDARIA CITY', '2024-07-04 13:51:16', '2024-07-04 13:51:36', 1, 1),
(96, '0780', 'MALL TAMAN ANGGREK', '2024-07-04 13:51:16', '2024-07-04 13:51:36', 1, 1),
(97, '0810', 'SPR PLAZA PADANG', '2024-07-04 13:51:16', '2024-07-04 13:51:36', 1, 1),
(98, '0820', 'TUAL MALUKU', '2024-07-04 13:51:16', '2024-07-04 13:51:36', 1, 1),
(99, 'CEE', 'CEE', '2024-07-04 13:51:16', '2024-07-04 13:51:36', 1, 1),
(100, 'GKT', 'GKT', '2024-07-04 13:51:16', '2024-07-04 13:51:36', 1, 1),
(101, 'GCI', 'GCI', '2024-07-04 13:51:16', '2024-07-04 13:51:36', 1, 1),
(102, 'NRC', 'NRC', '2024-07-04 13:51:16', '2024-07-04 13:51:36', 1, 1),
(103, '0830', 'RUKO TEUKU UMAR BALI', '2024-07-04 13:51:16', '2024-07-04 13:51:36', 1, 1),
(104, '1501', 'GROOCERIES CITY ALAM SUTRA', '2024-07-04 13:51:16', '2024-07-04 13:51:36', 1, 1),
(105, '1502', 'GROOCERIES CITY BINTARO', '2024-07-04 13:51:16', '2024-07-04 13:51:36', 1, 1),
(106, '0870', 'PURI INDAH MALL', '2024-07-04 13:51:16', '2024-07-04 13:51:36', 1, 1),
(107, '0880', 'GRAND BATAM MALL', '2024-07-04 13:51:16', '2024-07-04 13:51:36', 1, 1);

-- --------------------------------------------------------

--
-- Table structure for table `m_lpbj_dtl`
--

CREATE TABLE `m_lpbj_dtl` (
  `id` int(11) NOT NULL,
  `hdrid` int(11) DEFAULT NULL,
  `articlecode` varchar(255) DEFAULT NULL,
  `remark` varchar(255) DEFAULT NULL,
  `qty` int(11) DEFAULT NULL,
  `sitecode` varchar(255) DEFAULT NULL,
  `accassign` varchar(255) DEFAULT NULL,
  `gl` varchar(255) DEFAULT NULL,
  `costcenter` varchar(255) DEFAULT NULL,
  `order` varchar(255) DEFAULT NULL,
  `asset` varchar(255) DEFAULT NULL,
  `keterangan` varchar(255) DEFAULT NULL,
  `gambar` varchar(255) DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `modified_at` datetime DEFAULT NULL ON UPDATE current_timestamp(),
  `created_by` int(11) DEFAULT NULL,
  `modified_by` int(11) DEFAULT NULL,
  `isqe` int(11) DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

--
-- Dumping data for table `m_lpbj_dtl`
--

INSERT INTO `m_lpbj_dtl` (`id`, `hdrid`, `articlecode`, `remark`, `qty`, `sitecode`, `accassign`, `gl`, `costcenter`, `order`, `asset`, `keterangan`, `gambar`, `created_at`, `modified_at`, `created_by`, `modified_by`, `isqe`) VALUES
(1, 1, 'ACRY JDWL HOMDEL', 'lalala', 3, '1000', 'K', '600001', 'E008100001', 'MATOS-C5', NULL, 'lalala', NULL, '2024-07-16 15:58:09', '2024-07-16 18:06:01', 1, 58, 1),
(2, 1, 'ADVANCE', 'lilili', 3, '1000', 'K', '378928', 'E008100029', 'HR-C3', NULL, 'lilili', NULL, '2024-07-16 15:58:09', '2024-07-16 18:06:01', 1, 58, 1),
(3, 1, 'ALARM KAMERA', 'hahaha', 2, '1000', 'K', '600001', 'E008100001', 'MATOS-C5', NULL, 'hahaha', NULL, '2024-07-16 15:58:09', '2024-07-16 18:12:51', 1, 58, 1),
(4, 2, 'ACRY JDWL HOMDEL', 'lalala', 3, '1000', 'K', '600001', 'E008100001', 'MATOS-C5', NULL, 'lalala', NULL, '2024-07-16 17:13:20', NULL, 57, NULL, 0),
(5, 2, 'ADVANCE', 'lilili', 3, '1000', 'K', '378928', 'E008100029', 'HR-C3', NULL, 'lilili', NULL, '2024-07-16 17:13:20', NULL, 57, NULL, 0),
(6, 2, 'ALARM KAMERA', 'hahaha', 2, '1000', 'K', '600001', 'E008100001', 'MATOS-C5', NULL, 'hahaha', NULL, '2024-07-16 17:13:20', NULL, 57, NULL, 0),
(7, 3, 'ACRY JDWL HOMDEL', 'blabla', 3, '1000', 'K', '600001', 'E008100001', 'MATOS-C5', NULL, 'lalala', NULL, '2024-07-16 17:14:19', '2024-07-16 19:04:49', 57, 58, 1),
(8, 3, 'ADVANCE', 'lala', 3, '1000', 'K', '378928', 'E008100029', 'HR-C3', NULL, 'lilili', NULL, '2024-07-16 17:14:19', '2024-07-16 19:04:49', 57, 58, 1),
(9, 3, 'ALARM KAMERA', 'hihi', 2, '1000', 'K', '600001', 'E008100001', 'MATOS-C5', NULL, 'hahaha', NULL, '2024-07-16 17:14:19', '2024-07-16 19:04:49', 57, 58, 1);

-- --------------------------------------------------------

--
-- Table structure for table `m_lpbj_hdr`
--

CREATE TABLE `m_lpbj_hdr` (
  `id` int(11) NOT NULL,
  `nolpbj` varchar(255) DEFAULT NULL COMMENT 'companycode/depname/tgl/nourut',
  `companycode` varchar(255) DEFAULT NULL,
  `description` varchar(255) DEFAULT NULL,
  `userid` int(11) DEFAULT NULL,
  `note` varchar(255) DEFAULT NULL,
  `status` int(11) DEFAULT NULL COMMENT '1pengajuan,2approve,3reject',
  `isdeleted` int(11) DEFAULT 0,
  `created_at` datetime DEFAULT NULL,
  `modified_at` datetime DEFAULT NULL ON UPDATE current_timestamp(),
  `created_by` int(11) DEFAULT NULL,
  `modified_by` int(11) DEFAULT NULL,
  `reason` varchar(255) DEFAULT NULL,
  `approve_at` datetime DEFAULT NULL,
  `approve_by` int(11) DEFAULT NULL,
  `isqe` int(11) DEFAULT 0,
  `workflow` varchar(255) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

--
-- Dumping data for table `m_lpbj_hdr`
--

INSERT INTO `m_lpbj_hdr` (`id`, `nolpbj`, `companycode`, `description`, `userid`, `note`, `status`, `isdeleted`, `created_at`, `modified_at`, `created_by`, `modified_by`, `reason`, `approve_at`, `approve_by`, `isqe`, `workflow`) VALUES
(1, 'EC01/ITCoreSystem/20240716/0001', 'EC01', 'hihihi', 1, 'hihihi', 3, 0, '2024-07-16 15:58:09', '2024-07-16 18:20:23', 1, 56, NULL, NULL, NULL, 0, 'Approved_by_APPROVER 2 LPBJ'),
(2, 'EC01/ITCoreSystem/20240716/0001', 'EC01', 'lalalahihi', 57, '', 12, 0, '2024-07-16 17:13:20', '2024-07-16 17:23:55', 57, 55, 'sudah pernah diajukan', NULL, NULL, 0, 'Reject_by_APPROVER 1 LPBJ'),
(3, 'EC01/ITCoreSystem/20240716/0002', 'E013', 'buset', 57, '', 3, 0, '2024-07-16 17:14:19', '2024-07-16 18:30:04', 57, 56, 'test reject after approve', NULL, NULL, 0, 'Reject_by_APPROVER 2 LPBJ');

-- --------------------------------------------------------

--
-- Table structure for table `m_menu`
--

CREATE TABLE `m_menu` (
  `id` int(11) NOT NULL,
  `name` varchar(255) DEFAULT NULL,
  `deskripsi` varchar(255) DEFAULT NULL,
  `linkhref` varchar(255) DEFAULT NULL,
  `icon` varchar(255) DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `created_by` int(11) DEFAULT NULL,
  `modified_at` datetime DEFAULT NULL ON UPDATE current_timestamp(),
  `modified_by` int(11) DEFAULT NULL,
  `color` varchar(255) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

--
-- Dumping data for table `m_menu`
--

INSERT INTO `m_menu` (`id`, `name`, `deskripsi`, `linkhref`, `icon`, `created_at`, `created_by`, `modified_at`, `modified_by`, `color`) VALUES
(1, 'LPBJ', 'Lembar Permintaan Barang / Jasa', 'pengajuanlpbj', 'bi bi-file-earmark-text icon', '2024-07-15 15:11:15', 1, '2024-07-15 15:12:50', NULL, 'item-cyan'),
(2, 'Quotation', 'Quotation untuk LPBJ yang diajukan', 'pengajuanqe', 'bi bi bi-file-earmark-plus icon', '2024-07-15 15:11:15', 1, '2024-07-15 15:12:46', NULL, 'item-orange');

-- --------------------------------------------------------

--
-- Table structure for table `m_pegawai`
--

CREATE TABLE `m_pegawai` (
  `id` int(11) NOT NULL,
  `userid` int(11) DEFAULT NULL,
  `satkerid` int(11) DEFAULT NULL,
  `jabatanid` int(11) DEFAULT NULL,
  `levelid` int(11) DEFAULT NULL,
  `nama` varchar(255) DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `modified_at` datetime DEFAULT NULL ON UPDATE current_timestamp(),
  `created_by` int(11) DEFAULT NULL,
  `modified_by` int(11) DEFAULT NULL,
  `lokasiid` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

--
-- Dumping data for table `m_pegawai`
--

INSERT INTO `m_pegawai` (`id`, `userid`, `satkerid`, `jabatanid`, `levelid`, `nama`, `created_at`, `modified_at`, `created_by`, `modified_by`, `lokasiid`) VALUES
(1, 1, 104, 17, 11, 'MOCHAMAD SELIRATNO', '2024-07-04 14:34:41', '2024-07-04 14:34:49', 1, 1, 1),
(2, 3, 42, 2, 11, 'AGNES NOVITA RANTE PONIPADANG', '2024-07-04 14:34:41', '2024-07-04 14:34:54', 1, 1, 1),
(3, 2, 22, 9, 11, 'DYAH PUSPITA SARI', '2024-07-04 14:34:41', '2024-07-04 14:34:54', 1, 1, 1),
(4, 9, 141, 9, 12, 'KHAIRUNNISA BA MAR', '2024-07-04 14:34:41', '2024-07-04 14:34:55', 1, 1, 1),
(5, 8, 141, 11, 12, 'DINI AGUSTINA', '2024-07-04 14:34:41', '2024-07-04 14:34:55', 1, 1, 1),
(6, 6, 10, 9, 12, 'DENADA ANINDYA DEWI', '2024-07-04 14:34:41', '2024-07-04 14:34:55', 1, 1, 1),
(7, 12, 216, 4, 12, 'MIRA PARA DILA', '2024-07-04 14:34:41', '2024-07-04 14:34:55', 1, 1, 1),
(8, 11, 207, 8, 12, 'MIA AGNESTIA', '2024-07-04 14:34:41', '2024-07-04 14:34:55', 1, 1, 1),
(9, 4, 290, 9, 12, 'ZAHRA ZAHIRAH', '2024-07-04 14:34:41', '2024-07-04 14:34:55', 1, 1, 99),
(10, 5, 307, 9, 12, 'ASEP AHMAD MUHYIDIN', '2024-07-04 14:34:41', '2024-07-04 14:34:55', 1, 1, 99),
(11, 15, 318, 3, 12, 'BELLA RIZKY', '2024-07-04 14:34:41', '2024-07-04 14:34:55', 1, 1, 1),
(12, 13, 232, 9, 12, 'DIAZ NOVITASARI', '2024-07-04 14:34:41', '2024-07-04 14:34:55', 1, 1, 1),
(13, 10, 141, 13, 12, 'FRANKA PUTRA TAMPUBOLON', '2024-07-04 14:34:41', '2024-07-04 14:34:55', 1, 1, 1),
(14, 7, 51, 12, 12, 'MAYA SHEVA', '2024-07-04 14:34:41', '2024-07-04 14:34:55', 1, 1, 1),
(15, 14, 316, 9, 12, 'HENDRAWAN YUDI PUTRANTO', '2024-07-04 14:34:41', '2024-07-04 14:34:55', 1, 1, 1),
(16, 35, 250, 1, 13, 'APRILIA MASLUKHA', '2024-07-04 14:34:41', '2024-07-04 14:34:55', 1, 1, 100),
(17, 43, 251, 1, 13, 'MILA AMALIA', '2024-07-04 14:34:41', '2024-07-04 14:34:55', 1, 1, 100),
(18, 44, 251, 1, 13, 'IIN WIDYA ASTUTI', '2024-07-04 14:34:41', '2024-07-04 14:34:55', 1, 1, 100),
(19, 42, 251, 1, 13, 'REZA SAPUTRA', '2024-07-04 14:34:41', '2024-07-04 14:34:55', 1, 1, 100),
(20, 39, 251, 1, 13, 'RAHMAT WIJAYA', '2024-07-04 14:34:41', '2024-07-04 14:34:55', 1, 1, 100),
(21, 16, 289, 6, 13, 'CHITRA RESDIANA AWALLIYAH', '2024-07-04 14:34:41', '2024-07-04 14:34:55', 1, 1, 99),
(22, 36, 250, 1, 13, 'ELSA DAMAYANTI', '2024-07-04 14:34:41', '2024-07-04 14:34:55', 1, 1, 100),
(23, 29, 314, 3, 13, 'ADELINA YASIRO', '2024-07-04 14:34:41', '2024-07-04 14:34:55', 1, 1, 1),
(24, 30, 250, 1, 13, 'NURMANSYAH', '2024-07-04 14:34:41', '2024-07-04 14:34:55', 1, 1, 100),
(25, 17, 301, 14, 13, 'NOVITA DAMAYANTI', '2024-07-04 14:34:41', '2024-07-04 14:34:55', 1, 1, 99),
(26, 23, 111, 15, 13, 'ANASTASSYA RIZKYTA', '2024-07-04 14:34:41', '2024-07-04 14:34:55', 1, 1, 1),
(27, 28, 219, 4, 13, 'MUHAMMAD RAJA LUMAYANG', '2024-07-04 14:34:41', '2024-07-04 14:34:55', 1, 1, 1),
(28, 27, 216, 4, 13, 'DAFFA ARYA', '2024-07-04 14:34:41', '2024-07-04 14:34:55', 1, 1, 1),
(29, 20, 63, 16, 13, 'MARIA ERSA FERNANDA', '2024-07-04 14:34:41', '2024-07-04 14:34:55', 1, 1, 1),
(30, 37, 250, 1, 13, 'MACHMUD FAUZI', '2024-07-04 14:34:41', '2024-07-04 14:34:55', 1, 1, 100),
(31, 25, 202, 18, 13, 'DWI REDJEKI PRABASWERA', '2024-07-04 14:34:41', '2024-07-04 14:34:55', 1, 1, 1),
(32, 22, 94, 7, 13, 'DESIANA VENY LELA BELLAVISTA BATUBARA', '2024-07-04 14:34:41', '2024-07-04 14:34:55', 1, 1, 1),
(33, 21, 63, 9, 13, 'YOGA PRIHARTANTO', '2024-07-04 14:34:41', '2024-07-04 14:34:55', 1, 1, 1),
(34, 24, 198, 10, 13, 'ANDRIAN', '2024-07-04 14:34:41', '2024-07-04 14:34:55', 1, 1, 1),
(35, 26, 202, 5, 13, 'WULAN SITI ROHIMAH', '2024-07-04 14:34:41', '2024-07-04 14:34:55', 1, 1, 1),
(36, 19, 42, 9, 13, 'MUTIA DINDA CLARA', '2024-07-04 14:34:41', '2024-07-04 14:34:55', 1, 1, 1),
(37, 18, 29, 9, 13, 'ELLEANIS SHAFA', '2024-07-04 14:34:41', '2024-07-04 14:34:55', 1, 1, 1),
(38, 41, 251, 1, 13, 'NENDEN RAHMAWATI', '2024-07-04 14:34:41', '2024-07-04 14:34:55', 1, 1, 100),
(39, 33, 250, 1, 13, 'IIN HAYATI', '2024-07-04 14:34:41', '2024-07-04 14:34:55', 1, 1, 100),
(40, 40, 251, 1, 13, 'NOVIYANTI', '2024-07-04 14:34:41', '2024-07-04 14:34:55', 1, 1, 100),
(41, 32, 250, 1, 13, 'KRISTI ANDRIANI', '2024-07-04 14:34:41', '2024-07-04 14:34:55', 1, 1, 100),
(42, 34, 250, 1, 13, 'FITRI APRIANTI', '2024-07-04 14:34:41', '2024-07-04 14:34:55', 1, 1, 100),
(43, 31, 250, 1, 13, 'KARTIKA KUSUMA DEWI', '2024-07-04 14:34:41', '2024-07-04 14:34:55', 1, 1, 100),
(44, 38, 251, 1, 13, 'RIRI RIANA SARI', '2024-07-04 14:34:41', '2024-07-04 14:34:55', 1, 1, 100),
(45, 45, 22, 1, 8, 'Approver 1 QE', NULL, '2024-07-15 17:22:53', NULL, NULL, 1),
(46, 46, 22, 1, 8, 'Approver 2 QE', NULL, '2024-07-15 17:22:53', NULL, NULL, 1),
(47, 47, 22, 1, 8, 'Approver 3 QE', NULL, '2024-07-15 17:22:53', NULL, NULL, 1),
(48, 48, 22, 1, 8, 'Approver 4 QE', NULL, '2024-07-15 17:22:53', NULL, NULL, 1),
(49, 49, 22, 1, 8, 'Approver 5 QE', NULL, '2024-07-15 17:22:53', NULL, NULL, 1),
(50, 50, 22, 1, 8, 'Approver 6 QE', NULL, '2024-07-15 17:22:53', NULL, NULL, 1),
(51, 51, 22, 1, 8, 'Approver 7 QE', NULL, '2024-07-15 17:22:53', NULL, NULL, 1),
(52, 52, 22, 1, 8, 'Approver 8 QE', NULL, '2024-07-15 17:22:53', NULL, NULL, 1),
(53, 53, 22, 1, 8, 'Approver 9 QE', NULL, '2024-07-15 17:22:53', NULL, NULL, 1),
(54, 54, 22, 1, 8, 'Approver 10 QE', NULL, '2024-07-15 17:22:53', NULL, NULL, 1),
(55, 55, 104, 1, 8, 'Approver 1 LPBJ', NULL, '2024-07-15 17:50:07', NULL, NULL, 1),
(56, 56, 104, 1, 8, 'Approver 2 LPBJ', NULL, '2024-07-15 17:50:07', NULL, NULL, 1),
(57, 57, 104, 2, 11, 'Admin Departemen 1', NULL, '2024-07-16 16:42:49', NULL, NULL, 1),
(58, 58, 104, 2, 11, 'Admin Procurement 1', NULL, '2024-07-16 16:42:50', NULL, NULL, 1),
(59, 59, 141, 11, 12, 'Admin Departemen 2', NULL, '2024-07-16 16:43:53', NULL, NULL, 1),
(60, 60, 10, 9, 12, 'Admin Departemen 3', NULL, '2024-07-16 16:43:53', NULL, NULL, 1),
(61, 61, 216, 4, 12, 'Admin Departemen 4', NULL, '2024-07-16 16:43:53', NULL, NULL, 1);

-- --------------------------------------------------------

--
-- Table structure for table `m_qe_dtl`
--

CREATE TABLE `m_qe_dtl` (
  `id` int(11) NOT NULL,
  `hdrid` int(11) DEFAULT NULL,
  `draftid` int(11) DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `modified_at` datetime DEFAULT NULL ON UPDATE current_timestamp(),
  `created_by` int(11) DEFAULT NULL,
  `modified_by` int(11) DEFAULT NULL,
  `isdeleted` int(11) DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

--
-- Dumping data for table `m_qe_dtl`
--

INSERT INTO `m_qe_dtl` (`id`, `hdrid`, `draftid`, `created_at`, `modified_at`, `created_by`, `modified_by`, `isdeleted`) VALUES
(1, 1, 1, '2024-07-16 18:06:01', NULL, 58, NULL, 0),
(2, 1, 3, '2024-07-16 18:06:01', NULL, 58, NULL, 0),
(3, 1, 5, '2024-07-16 18:06:01', NULL, 58, NULL, 0),
(4, 1, 2, '2024-07-16 18:06:01', NULL, 58, NULL, 0),
(5, 1, 4, '2024-07-16 18:06:01', NULL, 58, NULL, 0),
(6, 1, 6, '2024-07-16 18:06:01', NULL, 58, NULL, 0),
(7, 2, 7, '2024-07-16 18:12:51', NULL, 58, NULL, 0),
(8, 2, 8, '2024-07-16 18:12:51', NULL, 58, NULL, 0),
(9, 2, 9, '2024-07-16 18:12:51', NULL, 58, NULL, 0),
(10, 3, 10, '2024-07-16 19:04:49', NULL, 58, NULL, 0),
(11, 3, 13, '2024-07-16 19:04:49', NULL, 58, NULL, 0),
(12, 3, 16, '2024-07-16 19:04:49', NULL, 58, NULL, 0),
(13, 3, 11, '2024-07-16 19:04:49', NULL, 58, NULL, 0),
(14, 3, 14, '2024-07-16 19:04:49', NULL, 58, NULL, 0),
(15, 3, 17, '2024-07-16 19:04:49', NULL, 58, NULL, 0),
(16, 3, 12, '2024-07-16 19:04:49', NULL, 58, NULL, 0),
(17, 3, 15, '2024-07-16 19:04:49', NULL, 58, NULL, 0),
(18, 3, 18, '2024-07-16 19:04:49', NULL, 58, NULL, 0);

-- --------------------------------------------------------

--
-- Table structure for table `m_qe_hdr`
--

CREATE TABLE `m_qe_hdr` (
  `id` int(11) NOT NULL,
  `lpbjid` int(11) DEFAULT NULL COMMENT 'lpbjhdr',
  `noqe` varchar(255) DEFAULT NULL,
  `status` int(11) DEFAULT NULL COMMENT '1pengajuan,2approve,3reject',
  `reason` varchar(255) DEFAULT NULL,
  `approve_at` datetime DEFAULT NULL,
  `approve_by` int(11) DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `modified_at` datetime DEFAULT NULL ON UPDATE current_timestamp(),
  `created_by` int(11) DEFAULT NULL,
  `modified_by` int(11) DEFAULT NULL,
  `workflow` varchar(255) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

--
-- Dumping data for table `m_qe_hdr`
--

INSERT INTO `m_qe_hdr` (`id`, `lpbjid`, `noqe`, `status`, `reason`, `approve_at`, `approve_by`, `created_at`, `modified_at`, `created_by`, `modified_by`, `workflow`) VALUES
(1, 1, 'EC01/ITCoreSystem/20240716/0001/QE001', 1, NULL, NULL, NULL, '2024-07-16 18:06:01', NULL, 58, NULL, NULL),
(2, 1, 'EC01/ITCoreSystem/20240716/0001/QE002', 1, NULL, NULL, NULL, '2024-07-16 18:12:51', NULL, 58, NULL, NULL),
(3, 3, 'EC01/ITCoreSystem/20240716/0002/QE003', 1, NULL, NULL, NULL, '2024-07-16 19:04:49', NULL, 58, NULL, NULL);

-- --------------------------------------------------------

--
-- Table structure for table `m_seksi`
--

CREATE TABLE `m_seksi` (
  `id` int(11) NOT NULL,
  `code` varchar(255) DEFAULT NULL,
  `name` varchar(255) DEFAULT NULL,
  `unitkerjaid` int(11) DEFAULT NULL,
  `direktoratid` int(11) DEFAULT NULL,
  `divisiid` int(11) DEFAULT NULL,
  `departmentid` int(11) DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `modified_at` datetime DEFAULT NULL ON UPDATE current_timestamp(),
  `created_by` int(11) DEFAULT NULL,
  `modified_by` int(11) DEFAULT NULL,
  `isaktif` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

--
-- Dumping data for table `m_seksi`
--

INSERT INTO `m_seksi` (`id`, `code`, `name`, `unitkerjaid`, `direktoratid`, `divisiid`, `departmentid`, `created_at`, `modified_at`, `created_by`, `modified_by`, `isaktif`) VALUES
(1, '01', 'Management', 4, 1, 1, 1, '2024-07-04 13:12:16', '2024-07-06 13:18:38', 1, 1, 1),
(2, '01', 'Corporate Secretary, Legal & Business Development', 4, 2, 2, 2, '2024-07-04 13:12:16', '2024-07-06 13:18:38', 1, 1, 1),
(3, '01', 'Corporate Secretary', 4, 2, 3, 3, '2024-07-04 13:12:16', '2024-07-06 13:18:38', 1, 1, 1),
(4, '02', 'Corporate Secretary Officer', 4, 2, 3, 3, '2024-07-04 13:12:16', '2024-07-06 13:18:38', 1, 1, 1),
(5, '01', 'Legal', 4, 2, 4, 4, '2024-07-04 13:12:16', '2024-07-06 13:18:38', 1, 1, 1),
(6, '01', 'Legal Agreement & Trafic Litigation', 4, 2, 4, 5, '2024-07-04 13:12:16', '2024-07-06 13:18:38', 1, 1, 1),
(7, '02', 'Legal Agreement & Trafic Litigation Officer', 4, 2, 4, 5, '2024-07-04 13:12:16', '2024-07-06 13:18:38', 1, 1, 1),
(8, '01', 'Permit & License', 4, 2, 4, 6, '2024-07-04 13:12:16', '2024-07-06 13:18:38', 1, 1, 1),
(9, '02', 'Permit & License Officer', 4, 2, 4, 6, '2024-07-04 13:12:16', '2024-07-06 13:18:38', 1, 1, 1),
(10, '01', 'Legal Admin', 4, 2, 4, 7, '2024-07-04 13:12:16', '2024-07-06 13:18:38', 1, 1, 1),
(11, '01', 'Site Development', 4, 2, 5, 8, '2024-07-04 13:12:16', '2024-07-06 13:18:38', 1, 1, 1),
(12, '01', 'Project Development', 4, 2, 5, 9, '2024-07-04 13:12:16', '2024-07-06 13:18:38', 1, 1, 1),
(13, '02', 'Project Development Interior', 4, 2, 5, 9, '2024-07-04 13:12:16', '2024-07-06 13:18:38', 1, 1, 1),
(14, '03', 'Project Development Civil / Mechanical Electrical', 4, 2, 5, 9, '2024-07-04 13:12:16', '2024-07-06 13:18:38', 1, 1, 1),
(15, '04', 'Project Civil (Struktur)', 4, 2, 5, 9, '2024-07-04 13:12:16', '2024-07-06 13:18:38', 1, 1, 1),
(16, '05', 'Cost Control', 4, 2, 5, 9, '2024-07-04 13:12:16', '2024-07-06 13:18:38', 1, 1, 1),
(17, '01', 'Tenant & Site Development', 4, 2, 5, 10, '2024-07-04 13:12:16', '2024-07-06 13:18:38', 1, 1, 1),
(18, '02', 'Tenant', 4, 2, 5, 10, '2024-07-04 13:12:16', '2024-07-06 13:18:38', 1, 1, 1),
(19, '03', 'Site Analyst', 4, 2, 5, 10, '2024-07-04 13:12:16', '2024-07-06 13:18:38', 1, 1, 1),
(20, '04', 'Site Development Administration', 4, 2, 5, 10, '2024-07-04 13:12:16', '2024-07-06 13:18:38', 1, 1, 1),
(21, '01', 'Asset Management', 4, 2, 6, 11, '2024-07-04 13:12:16', '2024-07-06 13:18:38', 1, 1, 1),
(22, '01', 'Business Development', 4, 2, 7, 12, '2024-07-04 13:12:16', '2024-07-06 13:18:38', 1, 1, 1),
(23, '01', 'HRD, GA & After Sales', 4, 3, 8, 13, '2024-07-04 13:12:16', '2024-07-06 13:18:38', 1, 1, 1),
(24, '01', 'Human Resources', 4, 3, 9, 14, '2024-07-04 13:12:16', '2024-07-06 13:18:38', 1, 1, 1),
(25, '01', 'Human Capital Development', 4, 3, 9, 15, '2024-07-04 13:12:16', '2024-07-06 13:18:38', 1, 1, 1),
(26, '02', 'Recruitment', 4, 3, 9, 15, '2024-07-04 13:12:16', '2024-07-06 13:18:38', 1, 1, 1),
(27, '03', 'Training', 4, 3, 9, 15, '2024-07-04 13:12:16', '2024-07-06 13:18:38', 1, 1, 1),
(28, '04', 'Personalia', 4, 3, 9, 15, '2024-07-04 13:12:16', '2024-07-06 13:18:38', 1, 1, 1),
(29, '05', 'Employee Relation', 4, 3, 9, 15, '2024-07-04 13:12:16', '2024-07-06 13:18:38', 1, 1, 1),
(30, '01', 'Sekretariat HRD', 4, 3, 9, 16, '2024-07-04 13:12:16', '2024-07-06 13:18:38', 1, 1, 1),
(31, '02', 'Administrasi HRD', 4, 3, 9, 16, '2024-07-04 13:12:16', '2024-07-06 13:18:38', 1, 1, 1),
(32, '01', 'Payroll', 4, 3, 10, 17, '2024-07-04 13:12:16', '2024-07-06 13:18:38', 1, 1, 1),
(33, '02', 'Payroll Officer', 4, 3, 10, 17, '2024-07-04 13:12:16', '2024-07-06 13:18:38', 1, 1, 1),
(34, '01', 'General Affair', 4, 3, 11, 18, '2024-07-04 13:12:16', '2024-07-06 13:18:38', 1, 1, 1),
(35, '01', 'Services & Security', 4, 3, 11, 19, '2024-07-04 13:12:16', '2024-07-06 13:18:38', 1, 1, 1),
(36, '02', 'K3, Security System Equipment & Parking', 4, 3, 11, 19, '2024-07-04 13:12:16', '2024-07-06 13:18:38', 1, 1, 1),
(37, '03', 'AGP Liason', 4, 3, 11, 19, '2024-07-04 13:12:16', '2024-07-06 13:18:38', 1, 1, 1),
(38, '04', 'HSSE', 4, 3, 11, 19, '2024-07-04 13:12:16', '2024-07-06 13:18:38', 1, 1, 1),
(39, '05', 'Cleaning Service, Office Boy & Budget', 4, 3, 11, 19, '2024-07-04 13:12:16', '2024-07-06 13:18:38', 1, 1, 1),
(40, '01', 'Equipment & Asset', 4, 3, 11, 20, '2024-07-04 13:12:16', '2024-07-06 13:18:38', 1, 1, 1),
(41, '02', 'General Admin & Biztrip Arrangement', 4, 3, 11, 20, '2024-07-04 13:12:16', '2024-07-06 13:18:38', 1, 1, 1),
(42, '03', 'Vehicle Maintenance', 4, 3, 11, 20, '2024-07-04 13:12:16', '2024-07-06 13:18:38', 1, 1, 1),
(43, '04', 'Consumable Supplies, Stock Keeper & Messenger', 4, 3, 11, 20, '2024-07-04 13:12:16', '2024-07-06 13:18:38', 1, 1, 1),
(44, '05', 'Management Asset, Asset Insurance & Driver', 4, 3, 11, 20, '2024-07-04 13:12:16', '2024-07-06 13:18:38', 1, 1, 1),
(45, '01', 'Maintenance', 4, 3, 11, 21, '2024-07-04 13:12:16', '2024-07-06 13:18:38', 1, 1, 1),
(46, '02', 'Preventive & Corrective', 4, 3, 11, 21, '2024-07-04 13:12:16', '2024-07-06 13:18:38', 1, 1, 1),
(47, '03', 'Administrasi Maintenance', 4, 3, 11, 21, '2024-07-04 13:12:16', '2024-07-06 13:18:38', 1, 1, 1),
(48, '01', 'Secretary', 4, 3, 11, 22, '2024-07-04 13:12:16', '2024-07-06 13:18:38', 1, 1, 1),
(49, '02', 'Receptionist', 4, 3, 11, 22, '2024-07-04 13:12:16', '2024-07-06 13:18:38', 1, 1, 1),
(50, '01', 'Finance, Accounting & Information Technology', 4, 4, 12, 23, '2024-07-04 13:12:16', '2024-07-06 13:18:38', 1, 1, 1),
(51, '01', 'Finance', 4, 4, 13, 24, '2024-07-04 13:12:16', '2024-07-06 13:18:38', 1, 1, 1),
(52, '01', 'Finance Analyst (Dept)', 4, 4, 13, 25, '2024-07-04 13:12:16', '2024-07-06 13:18:38', 1, 1, 1),
(53, '02', 'Finance Analyst', 4, 4, 13, 25, '2024-07-04 13:12:16', '2024-07-06 13:18:38', 1, 1, 1),
(54, '01', 'Finance (Dept)', 4, 4, 13, 26, '2024-07-04 13:12:16', '2024-07-06 13:18:38', 1, 1, 1),
(55, '02', 'Finance (Dept 2)', 4, 4, 13, 26, '2024-07-04 13:12:16', '2024-07-06 13:18:38', 1, 1, 1),
(56, '03', 'Debit Note (DN)', 4, 4, 13, 26, '2024-07-04 13:12:16', '2024-07-06 13:18:38', 1, 1, 1),
(57, '04', 'Voucher Control', 4, 4, 13, 26, '2024-07-04 13:12:16', '2024-07-06 13:18:38', 1, 1, 1),
(58, '05', 'Budget Control', 4, 4, 13, 26, '2024-07-04 13:12:16', '2024-07-06 13:18:38', 1, 1, 1),
(59, '01', 'Finance Groceries', 4, 4, 13, 27, '2024-07-04 13:12:16', '2024-07-06 13:18:38', 1, 1, 1),
(60, '01', 'Accounting', 4, 4, 14, 28, '2024-07-04 13:12:16', '2024-07-06 13:18:38', 1, 1, 1),
(61, '01', 'Accounting (Dept)', 4, 4, 14, 29, '2024-07-04 13:12:16', '2024-07-06 13:18:38', 1, 1, 1),
(62, '02', 'Account Payable (AP)', 4, 4, 14, 29, '2024-07-04 13:12:16', '2024-07-06 13:18:38', 1, 1, 1),
(63, '03', 'Account Receivable (AR)', 4, 4, 14, 29, '2024-07-04 13:12:16', '2024-07-06 13:18:38', 1, 1, 1),
(64, '04', 'General Ledger (GL)', 4, 4, 14, 29, '2024-07-04 13:12:16', '2024-07-06 13:18:38', 1, 1, 1),
(65, '05', 'Tax', 4, 4, 14, 29, '2024-07-04 13:12:16', '2024-07-06 13:18:38', 1, 1, 1),
(66, '01', 'Income & Cost Analyst and Inventory', 4, 4, 15, 30, '2024-07-04 13:12:16', '2024-07-06 13:18:38', 1, 1, 1),
(67, '01', 'Inventory Report', 4, 4, 15, 31, '2024-07-04 13:12:16', '2024-07-06 13:18:38', 1, 1, 1),
(68, '01', 'Inventory Stock Take', 4, 4, 15, 32, '2024-07-04 13:12:16', '2024-07-06 13:18:38', 1, 1, 1),
(69, '01', 'Information Technology', 4, 4, 16, 33, '2024-07-04 13:12:16', '2024-07-06 13:18:38', 1, 1, 1),
(70, '01', 'IT Core System', 4, 4, 16, 34, '2024-07-04 13:12:16', '2024-07-06 13:18:38', 1, 1, 1),
(71, '02', 'Business Analyst - SAP FICO', 4, 4, 16, 34, '2024-07-04 13:12:16', '2024-07-06 13:18:38', 1, 1, 1),
(72, '03', 'Business Analyst - SAP Retail', 4, 4, 16, 34, '2024-07-04 13:12:16', '2024-07-06 13:18:38', 1, 1, 1),
(73, '04', 'Business Analyst - POS', 4, 4, 16, 34, '2024-07-04 13:12:16', '2024-07-06 13:18:38', 1, 1, 1),
(74, '05', 'Development', 4, 4, 16, 34, '2024-07-04 13:12:16', '2024-07-06 13:18:38', 1, 1, 1),
(75, '01', 'IT Operations', 4, 4, 16, 35, '2024-07-04 13:12:16', '2024-07-06 13:18:38', 1, 1, 1),
(76, '02', 'IT Specialist', 4, 4, 16, 35, '2024-07-04 13:12:16', '2024-07-06 13:18:38', 1, 1, 1),
(77, '03', 'IT Support', 4, 4, 16, 35, '2024-07-04 13:12:16', '2024-07-06 13:18:38', 1, 1, 1),
(78, '04', 'Tim Ahli', 4, 4, 16, 35, '2024-07-04 13:12:16', '2024-07-06 13:18:38', 1, 1, 1),
(79, '05', 'Data Analyst', 4, 4, 16, 35, '2024-07-04 13:12:16', '2024-07-06 13:18:38', 1, 1, 1),
(80, '01', 'IT Groceries', 4, 4, 16, 36, '2024-07-04 13:12:16', '2024-07-06 13:18:38', 1, 1, 1),
(81, '01', 'Merchandising & Marketing', 4, 5, 17, 37, '2024-07-04 13:12:16', '2024-07-06 13:18:38', 1, 1, 1),
(82, '01', 'Merchandising 1', 4, 5, 18, 38, '2024-07-04 13:12:16', '2024-07-06 13:18:38', 1, 1, 1),
(83, '01', 'Product 1', 4, 5, 18, 39, '2024-07-04 13:12:16', '2024-07-06 13:18:38', 1, 1, 1),
(84, '02', 'Product 1 Audio & TV', 4, 5, 18, 39, '2024-07-04 13:12:16', '2024-07-06 13:18:38', 1, 1, 1),
(85, '01', 'Product 8 & CBC', 4, 5, 18, 40, '2024-07-04 13:12:16', '2024-07-06 13:18:38', 1, 1, 1),
(86, '02', 'Product 8', 4, 5, 18, 40, '2024-07-04 13:12:16', '2024-07-06 13:18:38', 1, 1, 1),
(87, '03', 'Cook & Bake City', 4, 5, 18, 40, '2024-07-04 13:12:16', '2024-07-06 13:18:38', 1, 1, 1),
(88, '01', 'Product 10', 4, 5, 18, 41, '2024-07-04 13:12:16', '2024-07-06 13:18:38', 1, 1, 1),
(89, '01', 'Merchandising 2', 4, 5, 19, 42, '2024-07-04 13:12:16', '2024-07-06 13:18:38', 1, 1, 1),
(90, '01', 'Product 2 & 3', 4, 5, 19, 43, '2024-07-04 13:12:16', '2024-07-06 13:18:38', 1, 1, 1),
(91, '02', 'Product 2', 4, 5, 19, 43, '2024-07-04 13:12:16', '2024-07-06 13:18:38', 1, 1, 1),
(92, '03', 'Product 3', 4, 5, 19, 43, '2024-07-04 13:12:16', '2024-07-06 13:18:38', 1, 1, 1),
(93, '01', 'Product 5', 4, 5, 19, 44, '2024-07-04 13:12:16', '2024-07-06 13:18:38', 1, 1, 1),
(94, '01', 'Product Development', 4, 5, 19, 45, '2024-07-04 13:12:16', '2024-07-06 13:18:38', 1, 1, 1),
(95, '01', 'Product 12 EcoCity', 4, 5, 19, 46, '2024-07-04 13:12:16', '2024-07-06 13:18:38', 1, 1, 1),
(96, '02', 'Product 12', 4, 5, 19, 46, '2024-07-04 13:12:16', '2024-07-06 13:18:38', 1, 1, 1),
(97, '01', 'Product Administration', 4, 5, 20, 47, '2024-07-04 13:12:16', '2024-07-06 13:18:38', 1, 1, 1),
(98, '02', 'Codif & Admin', 4, 5, 20, 47, '2024-07-04 13:12:16', '2024-07-06 13:18:38', 1, 1, 1),
(99, '01', 'Supply & Demand Planning', 4, 5, 21, 48, '2024-07-04 13:12:16', '2024-07-06 13:18:38', 1, 1, 1),
(100, '02', 'Planner', 4, 5, 21, 48, '2024-07-04 13:12:16', '2024-07-06 13:18:38', 1, 1, 1),
(101, '03', 'Admin, Display & Project', 4, 5, 21, 48, '2024-07-04 13:12:16', '2024-07-06 13:18:38', 1, 1, 1),
(102, '01', 'Marketing', 4, 5, 22, 49, '2024-07-04 13:12:16', '2024-07-06 13:18:38', 1, 1, 1),
(103, '01', 'Marketing Communication', 4, 5, 22, 50, '2024-07-04 13:12:16', '2024-07-06 13:18:38', 1, 1, 1),
(104, '02', 'Digital & Brand Activation', 4, 5, 22, 50, '2024-07-04 13:12:16', '2024-07-06 13:18:38', 1, 1, 1),
(105, '03', 'Public Relation', 4, 5, 22, 50, '2024-07-04 13:12:16', '2024-07-06 13:18:38', 1, 1, 1),
(106, '04', 'Graphic, Video & Illustration', 4, 5, 22, 50, '2024-07-04 13:12:16', '2024-07-06 13:18:38', 1, 1, 1),
(107, '01', 'Trade Marketing', 4, 5, 22, 51, '2024-07-04 13:12:16', '2024-07-06 13:18:38', 1, 1, 1),
(108, '02', 'Indoor Outdoor Media', 4, 5, 22, 51, '2024-07-04 13:12:16', '2024-07-06 13:18:38', 1, 1, 1),
(109, '03', 'Visual Merchandising & Inhouse Production', 4, 5, 22, 51, '2024-07-04 13:12:16', '2024-07-06 13:18:38', 1, 1, 1),
(110, '01', 'CRM & Event', 4, 5, 22, 52, '2024-07-04 13:12:16', '2024-07-06 13:18:38', 1, 1, 1),
(111, '02', 'CRM', 4, 5, 22, 52, '2024-07-04 13:12:16', '2024-07-06 13:18:38', 1, 1, 1),
(112, '03', 'Event', 4, 5, 22, 52, '2024-07-04 13:12:16', '2024-07-06 13:18:38', 1, 1, 1),
(113, '04', 'Contact Center', 4, 5, 22, 52, '2024-07-04 13:12:16', '2024-07-06 13:18:38', 1, 1, 1),
(114, '01', 'Bank & Financing, Partnership & Marketing Support', 4, 5, 22, 53, '2024-07-04 13:12:16', '2024-07-06 13:18:38', 1, 1, 1),
(115, '02', 'Bank & Financing', 4, 5, 22, 53, '2024-07-04 13:12:16', '2024-07-06 13:18:38', 1, 1, 1),
(116, '03', 'Marketing Support', 4, 5, 22, 53, '2024-07-04 13:12:16', '2024-07-06 13:18:38', 1, 1, 1),
(117, '01', 'Retail Sales & Logistic', 4, 6, 23, 54, '2024-07-04 13:12:16', '2024-07-06 13:18:38', 1, 1, 1),
(118, '01', 'Sales Offline', 4, 6, 24, 55, '2024-07-04 13:12:16', '2024-07-06 13:18:38', 1, 1, 1),
(119, '01', 'Sales Operation', 4, 6, 24, 56, '2024-07-04 13:12:16', '2024-07-06 13:18:38', 1, 1, 1),
(120, '02', 'Region 1', 4, 6, 24, 56, '2024-07-04 13:12:16', '2024-07-06 13:18:38', 1, 1, 1),
(121, '03', 'Region 2', 4, 6, 24, 56, '2024-07-04 13:12:16', '2024-07-06 13:18:38', 1, 1, 1),
(122, '04', 'Region 3', 4, 6, 24, 56, '2024-07-04 13:12:16', '2024-07-06 13:18:38', 1, 1, 1),
(123, '05', 'Region 4', 4, 6, 24, 56, '2024-07-04 13:12:16', '2024-07-06 13:18:38', 1, 1, 1),
(124, '06', 'Region 5', 4, 6, 24, 56, '2024-07-04 13:12:16', '2024-07-06 13:18:38', 1, 1, 1),
(125, '07', 'Region 6', 4, 6, 24, 56, '2024-07-04 13:12:16', '2024-07-06 13:18:38', 1, 1, 1),
(126, '08', 'Sales Analyst', 4, 6, 24, 56, '2024-07-04 13:12:16', '2024-07-06 13:18:38', 1, 1, 1),
(127, '09', 'SOP & Training', 4, 6, 24, 56, '2024-07-04 13:12:16', '2024-07-06 13:18:38', 1, 1, 1),
(128, '01', 'Logistic', 4, 6, 25, 57, '2024-07-04 13:12:16', '2024-07-06 13:18:38', 1, 1, 1),
(129, '01', 'National Logistic Warehouse', 4, 6, 25, 58, '2024-07-04 13:12:16', '2024-07-06 13:18:38', 1, 1, 1),
(130, '02', 'Logistic DC', 4, 6, 25, 58, '2024-07-04 13:12:16', '2024-07-06 13:18:38', 1, 1, 1),
(131, '03', 'Inventory Control', 4, 6, 25, 58, '2024-07-04 13:12:16', '2024-07-06 13:18:38', 1, 1, 1),
(132, '04', 'Administrasi Logistic', 4, 6, 25, 58, '2024-07-04 13:12:16', '2024-07-06 13:18:38', 1, 1, 1),
(133, '01', 'Sales Online', 4, 6, 26, 59, '2024-07-04 13:12:16', '2024-07-06 13:18:38', 1, 1, 1),
(134, '01', 'Product Marketing', 4, 6, 26, 60, '2024-07-04 13:12:16', '2024-07-06 13:18:38', 1, 1, 1),
(135, '02', 'E-commerce & Marketplace Specialist', 4, 6, 26, 60, '2024-07-04 13:12:16', '2024-07-06 13:18:38', 1, 1, 1),
(136, '03', 'Product Acquistion & New Business', 4, 6, 26, 60, '2024-07-04 13:12:16', '2024-07-06 13:18:38', 1, 1, 1),
(137, '04', 'Performance Marketing Specialist', 4, 6, 26, 60, '2024-07-04 13:12:16', '2024-07-06 13:18:38', 1, 1, 1),
(138, '05', 'Graphic Designer', 4, 6, 26, 60, '2024-07-04 13:12:16', '2024-07-06 13:18:38', 1, 1, 1),
(139, '06', 'Administrasi E-commerce', 4, 6, 26, 60, '2024-07-04 13:12:16', '2024-07-06 13:18:38', 1, 1, 1),
(140, '01', 'Development', 4, 6, 26, 61, '2024-07-04 13:12:16', '2024-07-06 13:18:38', 1, 1, 1),
(141, '02', 'Developer', 4, 6, 26, 61, '2024-07-04 13:12:16', '2024-07-06 13:18:38', 1, 1, 1),
(142, '01', 'Wholesales', 4, 7, 27, 62, '2024-07-04 13:12:16', '2024-07-06 13:18:38', 1, 1, 1),
(143, '01', 'Central Purchasing', 4, 7, 28, 63, '2024-07-04 13:12:16', '2024-07-06 13:18:38', 1, 1, 1),
(144, '01', 'Sales', 4, 7, 28, 64, '2024-07-04 13:12:16', '2024-07-06 13:18:38', 1, 1, 1),
(145, '02', 'Key Account', 4, 7, 28, 64, '2024-07-04 13:12:16', '2024-07-06 13:18:38', 1, 1, 1),
(146, '01', 'Administration', 4, 7, 28, 65, '2024-07-04 13:12:16', '2024-07-06 13:18:38', 1, 1, 1),
(147, '02', 'Sales Support Administration', 4, 7, 28, 65, '2024-07-04 13:12:16', '2024-07-06 13:18:38', 1, 1, 1),
(148, '01', 'System & Wholesales Market', 4, 7, 28, 66, '2024-07-04 13:12:16', '2024-07-06 13:18:38', 1, 1, 1),
(149, '02', 'System & Promotion', 4, 7, 28, 66, '2024-07-04 13:12:16', '2024-07-06 13:18:38', 1, 1, 1),
(150, '03', 'Wholesales Market', 4, 7, 28, 66, '2024-07-04 13:12:16', '2024-07-06 13:18:38', 1, 1, 1),
(151, '01', 'Procurement Non Trade', 4, 7, 28, 67, '2024-07-04 13:12:16', '2024-07-06 13:18:38', 1, 1, 1),
(152, '02', 'Procurement', 4, 7, 28, 67, '2024-07-04 13:12:16', '2024-07-06 13:18:38', 1, 1, 1),
(153, '01', 'Wholesales Div', 4, 7, 29, 68, '2024-07-04 13:12:16', '2024-07-06 13:18:38', 1, 1, 1),
(154, '01', 'Merchandising OEM', 4, 7, 29, 69, '2024-07-04 13:12:16', '2024-07-06 13:18:38', 1, 1, 1),
(155, '02', 'Merchandising Section', 4, 7, 29, 69, '2024-07-04 13:12:16', '2024-07-06 13:18:38', 1, 1, 1),
(156, '01', 'Sales & Marketing Communication OEM', 4, 7, 29, 70, '2024-07-04 13:12:16', '2024-07-06 13:18:38', 1, 1, 1),
(157, '02', 'Sales Section', 4, 7, 29, 70, '2024-07-04 13:12:16', '2024-07-06 13:18:38', 1, 1, 1),
(158, '03', 'Marketing Communication Section', 4, 7, 29, 70, '2024-07-04 13:12:16', '2024-07-06 13:18:38', 1, 1, 1),
(159, '01', 'SNDP OEM', 4, 7, 29, 71, '2024-07-04 13:12:16', '2024-07-06 13:18:38', 1, 1, 1),
(160, '02', 'SNDP', 4, 7, 29, 71, '2024-07-04 13:12:16', '2024-07-06 13:18:38', 1, 1, 1),
(161, '01', 'Internal Audit', 4, 8, 30, 72, '2024-07-04 13:12:16', '2024-07-06 13:18:38', 1, 1, 1),
(162, '02', 'Internal Audit Officer', 4, 8, 30, 72, '2024-07-04 13:12:16', '2024-07-06 13:18:38', 1, 1, 1),
(163, '03', 'SOP Officer', 4, 8, 30, 72, '2024-07-04 13:12:16', '2024-07-06 13:18:38', 1, 1, 1),
(164, '01', 'After Sales', 5, 9, 31, 73, '2024-07-04 13:12:16', '2024-07-06 13:18:38', 1, 1, 1),
(165, '01', 'After Sales (GKT)', 5, 9, 32, 74, '2024-07-04 13:12:16', '2024-07-06 13:18:38', 1, 1, 1),
(166, '01', 'HR & GA', 5, 9, 32, 75, '2024-07-04 13:12:16', '2024-07-06 13:18:38', 1, 1, 1),
(167, '02', 'GA', 5, 9, 32, 75, '2024-07-04 13:12:16', '2024-07-06 13:18:38', 1, 1, 1),
(168, '03', 'Admin & Recruitment', 5, 9, 32, 75, '2024-07-04 13:12:16', '2024-07-06 13:18:38', 1, 1, 1),
(169, '04', 'OB & Messenger', 5, 9, 32, 75, '2024-07-04 13:12:16', '2024-07-06 13:18:38', 1, 1, 1),
(170, '01', 'Marketing', 5, 9, 32, 76, '2024-07-04 13:12:16', '2024-07-06 13:18:38', 1, 1, 1),
(171, '02', 'Admin & CC', 5, 9, 32, 76, '2024-07-04 13:12:16', '2024-07-06 13:18:38', 1, 1, 1),
(172, '01', 'Sales & Operational', 5, 9, 32, 77, '2024-07-04 13:12:16', '2024-07-06 13:18:38', 1, 1, 1),
(173, '02', 'Operation Alam Sutera', 5, 9, 32, 77, '2024-07-04 13:12:16', '2024-07-06 13:18:38', 1, 1, 1),
(174, '03', 'Operation Depok', 5, 9, 32, 77, '2024-07-04 13:12:16', '2024-07-06 13:18:38', 1, 1, 1),
(175, '04', 'Operation Bekasi', 5, 9, 32, 77, '2024-07-04 13:12:16', '2024-07-06 13:18:38', 1, 1, 1),
(176, '05', 'Project', 5, 9, 32, 77, '2024-07-04 13:12:16', '2024-07-06 13:18:38', 1, 1, 1),
(177, '06', 'Operation Bintaro', 5, 9, 32, 77, '2024-07-04 13:12:16', '2024-07-06 13:18:38', 1, 1, 1),
(178, '01', 'Finance & Accounting', 5, 9, 32, 78, '2024-07-04 13:12:16', '2024-07-06 13:18:38', 1, 1, 1),
(179, '02', 'FA', 5, 9, 32, 78, '2024-07-04 13:12:16', '2024-07-06 13:18:38', 1, 1, 1),
(180, '01', 'Clean City', 5, 9, 32, 79, '2024-07-04 13:12:16', '2024-07-06 13:18:38', 1, 1, 1),
(181, '02', 'Office', 5, 9, 32, 79, '2024-07-04 13:12:16', '2024-07-06 13:18:38', 1, 1, 1),
(182, '03', 'Service', 5, 9, 32, 79, '2024-07-04 13:12:16', '2024-07-06 13:18:38', 1, 1, 1),
(183, '01', 'Event & Production', 1, 10, 33, 80, '2024-07-04 13:12:16', '2024-07-06 13:18:38', 1, 1, 1),
(184, '01', 'Event & Marketing', 1, 10, 34, 81, '2024-07-04 13:12:16', '2024-07-06 13:18:38', 1, 1, 1),
(185, '01', 'Creative & Partnership', 1, 10, 34, 82, '2024-07-04 13:12:16', '2024-07-06 13:18:38', 1, 1, 1),
(186, '02', 'Design & Socmed', 1, 10, 34, 82, '2024-07-04 13:12:16', '2024-07-06 13:18:38', 1, 1, 1),
(187, '03', 'Partnership', 1, 10, 34, 82, '2024-07-04 13:12:16', '2024-07-06 13:18:38', 1, 1, 1),
(188, '01', 'Marketing Communication', 1, 10, 34, 83, '2024-07-04 13:12:16', '2024-07-06 13:18:38', 1, 1, 1),
(189, '02', 'Marketing Communication Officer', 1, 10, 34, 83, '2024-07-04 13:12:16', '2024-07-06 13:18:38', 1, 1, 1),
(190, '01', 'Event', 1, 10, 34, 84, '2024-07-04 13:12:16', '2024-07-06 13:18:38', 1, 1, 1),
(191, '02', 'Production', 1, 10, 34, 84, '2024-07-04 13:12:16', '2024-07-06 13:18:38', 1, 1, 1),
(192, '03', 'Logistic', 1, 10, 34, 84, '2024-07-04 13:12:16', '2024-07-06 13:18:38', 1, 1, 1),
(193, '04', 'Talent', 1, 10, 34, 84, '2024-07-04 13:12:16', '2024-07-06 13:18:38', 1, 1, 1),
(194, '05', 'Administrasi', 1, 10, 34, 84, '2024-07-04 13:12:16', '2024-07-06 13:18:38', 1, 1, 1),
(195, '01', 'Sekretaris', 1, 10, 34, 85, '2024-07-04 13:12:16', '2024-07-06 13:18:38', 1, 1, 1),
(196, '01', 'Operational', 1, 11, 35, 86, '2024-07-04 13:12:16', '2024-07-06 13:18:38', 1, 1, 1),
(197, '01', 'FAT', 1, 11, 36, 87, '2024-07-04 13:12:16', '2024-07-06 13:18:38', 1, 1, 1),
(198, '01', 'Tax', 1, 11, 36, 88, '2024-07-04 13:12:16', '2024-07-06 13:18:38', 1, 1, 1),
(199, '02', 'Account Receivable', 1, 11, 36, 88, '2024-07-04 13:12:16', '2024-07-06 13:18:38', 1, 1, 1),
(200, '03', 'Account Payable', 1, 11, 36, 88, '2024-07-04 13:12:16', '2024-07-06 13:18:38', 1, 1, 1),
(201, '01', 'Estate Management', 1, 11, 37, 89, '2024-07-04 13:12:16', '2024-07-06 13:18:38', 1, 1, 1),
(202, '01', 'Operational QC', 1, 11, 37, 90, '2024-07-04 13:12:16', '2024-07-06 13:18:38', 1, 1, 1),
(203, '02', 'Safety K3', 1, 11, 37, 90, '2024-07-04 13:12:16', '2024-07-06 13:18:38', 1, 1, 1),
(204, '03', 'Tenant Relation & Leasing', 1, 11, 37, 90, '2024-07-04 13:12:16', '2024-07-06 13:18:38', 1, 1, 1),
(205, '01', 'HRD & GA', 1, 11, 37, 91, '2024-07-04 13:12:16', '2024-07-06 13:18:38', 1, 1, 1),
(206, '02', 'HRD', 1, 11, 37, 91, '2024-07-04 13:12:16', '2024-07-06 13:18:38', 1, 1, 1),
(207, '03', 'GA Supporting', 1, 11, 37, 91, '2024-07-04 13:12:16', '2024-07-06 13:18:38', 1, 1, 1),
(208, '01', 'Legal', 1, 11, 37, 92, '2024-07-04 13:12:16', '2024-07-06 13:18:38', 1, 1, 1),
(209, '02', 'Legal Officer', 1, 11, 37, 92, '2024-07-04 13:12:16', '2024-07-06 13:18:38', 1, 1, 1),
(210, '01', 'Groceries', 2, 12, 38, 93, '2024-07-04 13:12:16', '2024-07-06 13:18:38', 1, 1, 1),
(211, '01', 'Commercial', 2, 12, 39, 94, '2024-07-04 13:12:16', '2024-07-06 13:18:38', 1, 1, 1),
(212, '01', 'Merchandising', 2, 12, 39, 95, '2024-07-04 13:12:16', '2024-07-06 13:18:38', 1, 1, 1),
(213, '02', 'Non Food', 2, 12, 39, 95, '2024-07-04 13:12:16', '2024-07-06 13:18:38', 1, 1, 1),
(214, '03', 'Dry Food', 2, 12, 39, 95, '2024-07-04 13:12:16', '2024-07-06 13:18:38', 1, 1, 1),
(215, '04', 'Fresh Food', 2, 12, 39, 95, '2024-07-04 13:12:16', '2024-07-06 13:18:38', 1, 1, 1),
(216, '01', 'Sales Operation', 2, 12, 39, 96, '2024-07-04 13:12:16', '2024-07-06 13:18:38', 1, 1, 1),
(217, '02', 'Alam Sutera', 2, 12, 39, 96, '2024-07-04 13:12:16', '2024-07-06 13:18:38', 1, 1, 1),
(218, '03', 'Bintaro', 2, 12, 39, 96, '2024-07-04 13:12:16', '2024-07-06 13:18:38', 1, 1, 1),
(219, '01', 'Marketing', 2, 12, 39, 97, '2024-07-04 13:12:16', '2024-07-06 13:18:38', 1, 1, 1),
(220, '02', 'Desainer', 2, 12, 39, 97, '2024-07-04 13:12:16', '2024-07-06 13:18:38', 1, 1, 1),
(221, '01', 'FA & IT', 2, 12, 40, 98, '2024-07-04 13:12:16', '2024-07-06 13:18:38', 1, 1, 1),
(222, '01', 'Finance & Accounting', 2, 12, 40, 99, '2024-07-04 13:12:16', '2024-07-06 13:18:38', 1, 1, 1),
(223, '02', 'FA', 2, 12, 40, 99, '2024-07-04 13:12:16', '2024-07-06 13:18:38', 1, 1, 1),
(224, '01', 'Information Technology', 2, 12, 40, 100, '2024-07-04 13:12:16', '2024-07-06 13:18:38', 1, 1, 1),
(225, '01', 'Niscaya Raharja Calya', 3, 13, 41, 101, '2024-07-04 13:12:16', '2024-07-06 13:18:38', 1, 1, 1);

-- --------------------------------------------------------

--
-- Table structure for table `m_status`
--

CREATE TABLE `m_status` (
  `id` int(11) NOT NULL,
  `name` varchar(255) DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `created_by` int(11) DEFAULT NULL,
  `modified_at` datetime DEFAULT NULL ON UPDATE current_timestamp(),
  `modified_by` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

--
-- Dumping data for table `m_status`
--

INSERT INTO `m_status` (`id`, `name`, `created_at`, `created_by`, `modified_at`, `modified_by`) VALUES
(1, 'Pengajuan Baru', NULL, NULL, NULL, NULL),
(2, 'Disetujui Approval 1', NULL, NULL, NULL, NULL),
(3, 'Disetujui Approval 2', NULL, NULL, NULL, NULL),
(4, 'Disetujui Approval 3', NULL, NULL, '2024-07-12 20:11:11', NULL),
(5, 'Disetujui Approval 4', NULL, NULL, '2024-07-12 20:11:13', NULL),
(6, 'Disetujui Approval 5', NULL, NULL, '2024-07-12 20:11:14', NULL),
(7, 'Disetujui Approval 6', NULL, NULL, '2024-07-12 20:11:16', NULL),
(8, 'Disetujui Approval 7', NULL, NULL, '2024-07-12 20:11:18', NULL),
(9, 'Disetujui Approval 8', NULL, NULL, '2024-07-12 20:11:21', NULL),
(10, 'Disetujui Approval 9', NULL, NULL, '2024-07-12 20:11:24', NULL),
(11, 'Disetujui Approval 10', NULL, NULL, '2024-07-12 20:11:26', NULL),
(12, 'Ditolak Approval', NULL, NULL, NULL, NULL);

-- --------------------------------------------------------

--
-- Table structure for table `m_subseksi`
--

CREATE TABLE `m_subseksi` (
  `id` int(11) NOT NULL,
  `code` varchar(255) DEFAULT NULL,
  `name` varchar(255) DEFAULT NULL,
  `unitkerjaid` int(11) DEFAULT NULL,
  `direktoratid` int(11) DEFAULT NULL,
  `divisiid` int(11) DEFAULT NULL,
  `departmentid` int(11) DEFAULT NULL,
  `seksiid` int(11) DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `modified_at` datetime DEFAULT NULL ON UPDATE current_timestamp(),
  `created_by` int(11) DEFAULT NULL,
  `modified_by` int(11) DEFAULT NULL,
  `isaktif` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

--
-- Dumping data for table `m_subseksi`
--

INSERT INTO `m_subseksi` (`id`, `code`, `name`, `unitkerjaid`, `direktoratid`, `divisiid`, `departmentid`, `seksiid`, `created_at`, `modified_at`, `created_by`, `modified_by`, `isaktif`) VALUES
(1, '01', 'Management', 4, 1, 1, 1, 1, '2024-07-04 13:17:35', '2024-07-06 13:19:20', 1, 1, 1),
(2, '01', 'Corporate Secretary, Legal & Business Development', 4, 2, 2, 2, 2, '2024-07-04 13:17:35', '2024-07-06 13:19:20', 1, 1, 1),
(3, '01', 'Corporate Secretary', 4, 2, 3, 3, 3, '2024-07-04 13:17:35', '2024-07-06 13:19:20', 1, 1, 1),
(4, '01', 'Corporate Secretary Officer', 4, 2, 3, 3, 4, '2024-07-04 13:17:35', '2024-07-06 13:19:20', 1, 1, 1),
(5, '01', 'Legal', 4, 2, 4, 4, 5, '2024-07-04 13:17:35', '2024-07-06 13:19:20', 1, 1, 1),
(6, '01', 'Legal Agreement & Trafic Litigation', 4, 2, 4, 5, 6, '2024-07-04 13:17:35', '2024-07-06 13:19:20', 1, 1, 1),
(7, '01', 'Legal Agreement & Trafic Litigation Officer', 4, 2, 4, 5, 7, '2024-07-04 13:17:35', '2024-07-06 13:19:20', 1, 1, 1),
(8, '01', 'Permit & License', 4, 2, 4, 6, 8, '2024-07-04 13:17:35', '2024-07-06 13:19:20', 1, 1, 1),
(9, '01', 'Permit & License Officer', 4, 2, 4, 6, 9, '2024-07-04 13:17:35', '2024-07-06 13:19:20', 1, 1, 1),
(10, '01', 'Legal Admin', 4, 2, 4, 7, 10, '2024-07-04 13:17:35', '2024-07-06 13:19:20', 1, 1, 1),
(11, '01', 'Site Development', 4, 2, 5, 8, 11, '2024-07-04 13:17:35', '2024-07-06 13:19:20', 1, 1, 1),
(12, '01', 'Project Development', 4, 2, 5, 9, 12, '2024-07-04 13:17:35', '2024-07-06 13:19:20', 1, 1, 1),
(13, '01', 'Project Development Interior', 4, 2, 5, 9, 13, '2024-07-04 13:17:35', '2024-07-06 13:19:20', 1, 1, 1),
(14, '02', 'Project Development Interior Officer', 4, 2, 5, 9, 13, '2024-07-04 13:17:35', '2024-07-06 13:19:20', 1, 1, 1),
(15, '01', 'Project Development Civil / Mechanical Electrical', 4, 2, 5, 9, 14, '2024-07-04 13:17:35', '2024-07-06 13:19:20', 1, 1, 1),
(16, '02', 'Project Development ME', 4, 2, 5, 9, 14, '2024-07-04 13:17:35', '2024-07-06 13:19:20', 1, 1, 1),
(17, '03', 'Project Development Civil', 4, 2, 5, 9, 14, '2024-07-04 13:17:35', '2024-07-06 13:19:20', 1, 1, 1),
(18, '04', 'Project Development QS', 4, 2, 5, 9, 14, '2024-07-04 13:17:35', '2024-07-06 13:19:20', 1, 1, 1),
(19, '01', 'Project Civil (Struktur)', 4, 2, 5, 9, 15, '2024-07-04 13:17:35', '2024-07-06 13:19:20', 1, 1, 1),
(20, '02', 'Project SA - ME', 4, 2, 5, 9, 15, '2024-07-04 13:17:35', '2024-07-06 13:19:20', 1, 1, 1),
(21, '01', 'Cost Control', 4, 2, 5, 9, 16, '2024-07-04 13:17:35', '2024-07-06 13:19:20', 1, 1, 1),
(22, '02', 'Admin Cost Control', 4, 2, 5, 9, 16, '2024-07-04 13:17:35', '2024-07-06 13:19:20', 1, 1, 1),
(23, '01', 'Tenant & Site Development', 4, 2, 5, 10, 17, '2024-07-04 13:17:35', '2024-07-06 13:19:20', 1, 1, 1),
(24, '01', 'Tenant', 4, 2, 5, 10, 18, '2024-07-04 13:17:35', '2024-07-06 13:19:20', 1, 1, 1),
(25, '02', 'Tenant Officer', 4, 2, 5, 10, 18, '2024-07-04 13:17:35', '2024-07-06 13:19:20', 1, 1, 1),
(26, '01', 'Site Analyst', 4, 2, 5, 10, 19, '2024-07-04 13:17:35', '2024-07-06 13:19:20', 1, 1, 1),
(27, '02', 'Site Analyst Officer', 4, 2, 5, 10, 19, '2024-07-04 13:17:35', '2024-07-06 13:19:20', 1, 1, 1),
(28, '01', 'Site Development Administration', 4, 2, 5, 10, 20, '2024-07-04 13:17:35', '2024-07-06 13:19:20', 1, 1, 1),
(29, '02', 'Site Development Officer', 4, 2, 5, 10, 20, '2024-07-04 13:17:35', '2024-07-06 13:19:20', 1, 1, 1),
(30, '01', 'Asset Management', 4, 2, 6, 11, 21, '2024-07-04 13:17:35', '2024-07-06 13:19:20', 1, 1, 1),
(31, '01', 'Business Development', 4, 2, 7, 12, 22, '2024-07-04 13:17:35', '2024-07-06 13:19:20', 1, 1, 1),
(32, '01', 'HRD, GA & After Sales', 4, 3, 8, 13, 23, '2024-07-04 13:17:35', '2024-07-06 13:19:20', 1, 1, 1),
(33, '01', 'Human Resources', 4, 3, 9, 14, 24, '2024-07-04 13:17:35', '2024-07-06 13:19:20', 1, 1, 1),
(34, '01', 'Human Capital Development', 4, 3, 9, 15, 25, '2024-07-04 13:17:35', '2024-07-06 13:19:20', 1, 1, 1),
(35, '01', 'Recruitment', 4, 3, 9, 15, 26, '2024-07-04 13:17:35', '2024-07-06 13:19:20', 1, 1, 1),
(36, '02', 'Recruitment Officer', 4, 3, 9, 15, 26, '2024-07-04 13:17:35', '2024-07-06 13:19:20', 1, 1, 1),
(37, '01', 'Training', 4, 3, 9, 15, 27, '2024-07-04 13:17:35', '2024-07-06 13:19:20', 1, 1, 1),
(38, '02', 'Training Officer', 4, 3, 9, 15, 27, '2024-07-04 13:17:35', '2024-07-06 13:19:20', 1, 1, 1),
(39, '01', 'Personalia', 4, 3, 9, 15, 28, '2024-07-04 13:17:35', '2024-07-06 13:19:20', 1, 1, 1),
(40, '01', 'Employee Relation', 4, 3, 9, 15, 29, '2024-07-04 13:17:35', '2024-07-06 13:19:20', 1, 1, 1),
(41, '01', 'Sekretariat HRD', 4, 3, 9, 16, 30, '2024-07-04 13:17:35', '2024-07-06 13:19:20', 1, 1, 1),
(42, '01', 'Administrasi HRD', 4, 3, 9, 16, 31, '2024-07-04 13:17:35', '2024-07-06 13:19:20', 1, 1, 1),
(43, '01', 'Payroll', 4, 3, 10, 17, 32, '2024-07-04 13:17:35', '2024-07-06 13:19:20', 1, 1, 1),
(44, '01', 'Payroll Officer', 4, 3, 10, 17, 33, '2024-07-04 13:17:35', '2024-07-06 13:19:20', 1, 1, 1),
(45, '01', 'General Affair', 4, 3, 11, 18, 34, '2024-07-04 13:17:35', '2024-07-06 13:19:20', 1, 1, 1),
(46, '01', 'Services & Security', 4, 3, 11, 19, 35, '2024-07-04 13:17:35', '2024-07-06 13:19:20', 1, 1, 1),
(47, '01', 'K3, Security System Equipment & Parking', 4, 3, 11, 19, 36, '2024-07-04 13:17:35', '2024-07-06 13:19:20', 1, 1, 1),
(48, '02', 'Security, Cleaning Service & Parking', 4, 3, 11, 19, 36, '2024-07-04 13:17:35', '2024-07-06 13:19:20', 1, 1, 1),
(49, '01', 'AGP Liason', 4, 3, 11, 19, 37, '2024-07-04 13:17:35', '2024-07-06 13:19:20', 1, 1, 1),
(50, '01', 'HSSE', 4, 3, 11, 19, 38, '2024-07-04 13:17:35', '2024-07-06 13:19:20', 1, 1, 1),
(51, '01', 'Cleaning Service, Office Boy & Budget', 4, 3, 11, 19, 39, '2024-07-04 13:17:35', '2024-07-06 13:19:20', 1, 1, 1),
(52, '02', 'Office Boy', 4, 3, 11, 19, 39, '2024-07-04 13:17:35', '2024-07-06 13:19:20', 1, 1, 1),
(53, '01', 'Equipment & Asset', 4, 3, 11, 20, 40, '2024-07-04 13:17:35', '2024-07-06 13:19:20', 1, 1, 1),
(54, '01', 'General Admin & Biztrip Arrangement', 4, 3, 11, 20, 41, '2024-07-04 13:17:35', '2024-07-06 13:19:20', 1, 1, 1),
(55, '01', 'Vehicle Maintenance', 4, 3, 11, 20, 42, '2024-07-04 13:17:35', '2024-07-06 13:19:20', 1, 1, 1),
(56, '02', 'Mekanik', 4, 3, 11, 20, 42, '2024-07-04 13:17:35', '2024-07-06 13:19:20', 1, 1, 1),
(57, '01', 'Consumable Supplies, Stock Keeper & Messenger', 4, 3, 11, 20, 43, '2024-07-04 13:17:35', '2024-07-06 13:19:20', 1, 1, 1),
(58, '02', 'Messenger', 4, 3, 11, 20, 43, '2024-07-04 13:17:35', '2024-07-06 13:19:20', 1, 1, 1),
(59, '01', 'Management Asset, Asset Insurance & Driver', 4, 3, 11, 20, 44, '2024-07-04 13:17:35', '2024-07-06 13:19:20', 1, 1, 1),
(60, '02', 'Driver', 4, 3, 11, 20, 44, '2024-07-04 13:17:35', '2024-07-06 13:19:20', 1, 1, 1),
(61, '01', 'Maintenance', 4, 3, 11, 21, 45, '2024-07-04 13:17:35', '2024-07-06 13:19:20', 1, 1, 1),
(62, '01', 'Preventive & Corrective', 4, 3, 11, 21, 46, '2024-07-04 13:17:35', '2024-07-06 13:19:20', 1, 1, 1),
(63, '01', 'Administrasi Maintenance', 4, 3, 11, 21, 47, '2024-07-04 13:17:35', '2024-07-06 13:19:20', 1, 1, 1),
(64, '01', 'Secretary', 4, 3, 11, 22, 48, '2024-07-04 13:17:35', '2024-07-06 13:19:20', 1, 1, 1),
(65, '01', 'Receptionist', 4, 3, 11, 22, 49, '2024-07-04 13:17:35', '2024-07-06 13:19:20', 1, 1, 1),
(66, '01', 'Finance, Accounting & Information Technology', 4, 4, 12, 23, 50, '2024-07-04 13:17:35', '2024-07-06 13:19:20', 1, 1, 1),
(67, '01', 'Finance', 4, 4, 13, 24, 51, '2024-07-04 13:17:35', '2024-07-06 13:19:20', 1, 1, 1),
(68, '01', 'Finance Analyst (Dept)', 4, 4, 13, 25, 52, '2024-07-04 13:17:35', '2024-07-06 13:19:20', 1, 1, 1),
(69, '01', 'Finance Analyst', 4, 4, 13, 25, 53, '2024-07-04 13:17:35', '2024-07-06 13:19:20', 1, 1, 1),
(70, '02', 'Finance Analyst Officer', 4, 4, 13, 25, 53, '2024-07-04 13:17:35', '2024-07-06 13:19:20', 1, 1, 1),
(71, '01', 'Finance (Dept)', 4, 4, 13, 26, 54, '2024-07-04 13:17:35', '2024-07-06 13:19:20', 1, 1, 1),
(72, '01', 'Finance (Dept 2)', 4, 4, 13, 26, 55, '2024-07-04 13:17:35', '2024-07-06 13:19:20', 1, 1, 1),
(73, '02', 'Finance Officer', 4, 4, 13, 26, 55, '2024-07-04 13:17:35', '2024-07-06 13:19:20', 1, 1, 1),
(74, '01', 'Debit Note (DN)', 4, 4, 13, 26, 56, '2024-07-04 13:17:35', '2024-07-06 13:19:20', 1, 1, 1),
(75, '02', 'Debit Note (DN) Officer', 4, 4, 13, 26, 56, '2024-07-04 13:17:35', '2024-07-06 13:19:20', 1, 1, 1),
(76, '01', 'Voucher Control', 4, 4, 13, 26, 57, '2024-07-04 13:17:35', '2024-07-06 13:19:20', 1, 1, 1),
(77, '01', 'Budget Control', 4, 4, 13, 26, 58, '2024-07-04 13:17:35', '2024-07-06 13:19:20', 1, 1, 1),
(78, '02', 'Budget Control Officer', 4, 4, 13, 26, 58, '2024-07-04 13:17:35', '2024-07-06 13:19:20', 1, 1, 1),
(79, '01', 'Finance Groceries', 4, 4, 13, 27, 59, '2024-07-04 13:17:35', '2024-07-06 13:19:20', 1, 1, 1),
(80, '01', 'Accounting', 4, 4, 14, 28, 60, '2024-07-04 13:17:35', '2024-07-06 13:19:20', 1, 1, 1),
(81, '01', 'Accounting (Dept)', 4, 4, 14, 29, 61, '2024-07-04 13:17:35', '2024-07-06 13:19:20', 1, 1, 1),
(82, '01', 'Account Payable (AP)', 4, 4, 14, 29, 62, '2024-07-04 13:17:35', '2024-07-06 13:19:20', 1, 1, 1),
(83, '02', 'Account Payable (AP) Officer', 4, 4, 14, 29, 62, '2024-07-04 13:17:35', '2024-07-06 13:19:20', 1, 1, 1),
(84, '01', 'Account Receivable (AR)', 4, 4, 14, 29, 63, '2024-07-04 13:17:35', '2024-07-06 13:19:20', 1, 1, 1),
(85, '02', 'Account Receivable (AR) Officer', 4, 4, 14, 29, 63, '2024-07-04 13:17:35', '2024-07-06 13:19:20', 1, 1, 1),
(86, '01', 'General Ledger (GL)', 4, 4, 14, 29, 64, '2024-07-04 13:17:35', '2024-07-06 13:19:20', 1, 1, 1),
(87, '02', 'General Ledger (GL) Officer', 4, 4, 14, 29, 64, '2024-07-04 13:17:35', '2024-07-06 13:19:20', 1, 1, 1),
(88, '01', 'Tax', 4, 4, 14, 29, 65, '2024-07-04 13:17:35', '2024-07-06 13:19:20', 1, 1, 1),
(89, '02', 'Tax Officer', 4, 4, 14, 29, 65, '2024-07-04 13:17:35', '2024-07-06 13:19:20', 1, 1, 1),
(90, '01', 'Income & Cost Analyst and Inventory', 4, 4, 15, 30, 66, '2024-07-04 13:17:35', '2024-07-06 13:19:20', 1, 1, 1),
(91, '01', 'Inventory Report', 4, 4, 15, 31, 67, '2024-07-04 13:17:35', '2024-07-06 13:19:20', 1, 1, 1),
(92, '02', 'Inventory Report Officer', 4, 4, 15, 31, 67, '2024-07-04 13:17:35', '2024-07-06 13:19:20', 1, 1, 1),
(93, '01', 'Inventory Stock Take', 4, 4, 15, 32, 68, '2024-07-04 13:17:35', '2024-07-06 13:19:20', 1, 1, 1),
(94, '02', 'Inventory Stock Take Officer', 4, 4, 15, 32, 68, '2024-07-04 13:17:35', '2024-07-06 13:19:20', 1, 1, 1),
(95, '01', 'Information Technology', 4, 4, 16, 33, 69, '2024-07-04 13:17:35', '2024-07-06 13:19:20', 1, 1, 1),
(96, '01', 'IT Core System', 4, 4, 16, 34, 70, '2024-07-04 13:17:35', '2024-07-06 13:19:20', 1, 1, 1),
(97, '01', 'Business Analyst - SAP FICO', 4, 4, 16, 34, 71, '2024-07-04 13:17:35', '2024-07-06 13:19:20', 1, 1, 1),
(98, '02', 'Business Analyst - SAP FICO Support', 4, 4, 16, 34, 71, '2024-07-04 13:17:35', '2024-07-06 13:19:20', 1, 1, 1),
(99, '01', 'Business Analyst - SAP Retail', 4, 4, 16, 34, 72, '2024-07-04 13:17:35', '2024-07-06 13:19:20', 1, 1, 1),
(100, '02', 'Business Analyst - SAP Retail Support', 4, 4, 16, 34, 72, '2024-07-04 13:17:35', '2024-07-06 13:19:20', 1, 1, 1),
(101, '01', 'Business Analyst - POS', 4, 4, 16, 34, 73, '2024-07-04 13:17:35', '2024-07-06 13:19:20', 1, 1, 1),
(102, '02', 'Business Analyst - POS Support', 4, 4, 16, 34, 73, '2024-07-04 13:17:35', '2024-07-06 13:19:20', 1, 1, 1),
(103, '01', 'Development', 4, 4, 16, 34, 74, '2024-07-04 13:17:35', '2024-07-06 13:19:20', 1, 1, 1),
(104, '02', 'Development Support', 4, 4, 16, 34, 74, '2024-07-04 13:17:35', '2024-07-06 13:19:20', 1, 1, 1),
(105, '03', 'Development', 4, 4, 16, 34, 74, '2024-07-04 13:17:35', '2024-07-06 13:19:20', 1, 1, 1),
(106, '01', 'IT Operations', 4, 4, 16, 35, 75, '2024-07-04 13:17:35', '2024-07-06 13:19:20', 1, 1, 1),
(107, '01', 'IT Specialist', 4, 4, 16, 35, 76, '2024-07-04 13:17:35', '2024-07-06 13:19:20', 1, 1, 1),
(108, '02', 'IT Specialist Officer', 4, 4, 16, 35, 76, '2024-07-04 13:17:35', '2024-07-06 13:19:20', 1, 1, 1),
(109, '01', 'IT Support', 4, 4, 16, 35, 77, '2024-07-04 13:17:35', '2024-07-06 13:19:20', 1, 1, 1),
(110, '02', 'IT Support Officer', 4, 4, 16, 35, 77, '2024-07-04 13:17:35', '2024-07-06 13:19:20', 1, 1, 1),
(111, '03', 'Administrasi IT', 4, 4, 16, 35, 77, '2024-07-04 13:17:35', '2024-07-06 13:19:20', 1, 1, 1),
(112, '01', 'Tim Ahli', 4, 4, 16, 35, 78, '2024-07-04 13:17:35', '2024-07-06 13:19:20', 1, 1, 1),
(113, '01', 'Data Analyst', 4, 4, 16, 35, 79, '2024-07-04 13:17:35', '2024-07-06 13:19:20', 1, 1, 1),
(114, '01', 'IT Groceries', 4, 4, 16, 36, 80, '2024-07-04 13:17:35', '2024-07-06 13:19:20', 1, 1, 1),
(115, '01', 'Merchandising & Marketing', 4, 5, 17, 37, 81, '2024-07-04 13:17:35', '2024-07-06 13:19:20', 1, 1, 1),
(116, '01', 'Merchandising 1', 4, 5, 18, 38, 82, '2024-07-04 13:17:35', '2024-07-06 13:19:20', 1, 1, 1),
(117, '01', 'Product 1', 4, 5, 18, 39, 83, '2024-07-04 13:17:35', '2024-07-06 13:19:20', 1, 1, 1),
(118, '01', 'Product 1 Audio & TV', 4, 5, 18, 39, 84, '2024-07-04 13:17:35', '2024-07-06 13:19:20', 1, 1, 1),
(119, '02', 'Product 1 Officer', 4, 5, 18, 39, 84, '2024-07-04 13:17:35', '2024-07-06 13:19:20', 1, 1, 1),
(120, '01', 'Product 8 & CBC', 4, 5, 18, 40, 85, '2024-07-04 13:17:35', '2024-07-06 13:19:20', 1, 1, 1),
(121, '01', 'Product 8', 4, 5, 18, 40, 86, '2024-07-04 13:17:35', '2024-07-06 13:19:20', 1, 1, 1),
(122, '02', 'Product 8 Officer', 4, 5, 18, 40, 86, '2024-07-04 13:17:35', '2024-07-06 13:19:20', 1, 1, 1),
(123, '01', 'Cook & Bake City', 4, 5, 18, 40, 87, '2024-07-04 13:17:35', '2024-07-06 13:19:20', 1, 1, 1),
(124, '02', 'Cook & Bake City Officer', 4, 5, 18, 40, 87, '2024-07-04 13:17:35', '2024-07-06 13:19:20', 1, 1, 1),
(125, '01', 'Product 10', 4, 5, 18, 41, 88, '2024-07-04 13:17:35', '2024-07-06 13:19:20', 1, 1, 1),
(126, '01', 'Merchandising 2', 4, 5, 19, 42, 89, '2024-07-04 13:17:35', '2024-07-06 13:19:20', 1, 1, 1),
(127, '01', 'Product 2 & 3', 4, 5, 19, 43, 90, '2024-07-04 13:17:35', '2024-07-06 13:19:20', 1, 1, 1),
(128, '01', 'Product 2', 4, 5, 19, 43, 91, '2024-07-04 13:17:35', '2024-07-06 13:19:20', 1, 1, 1),
(129, '02', 'Product 2 Officer', 4, 5, 19, 43, 91, '2024-07-04 13:17:35', '2024-07-06 13:19:20', 1, 1, 1),
(130, '01', 'Product 3', 4, 5, 19, 43, 92, '2024-07-04 13:17:35', '2024-07-06 13:19:20', 1, 1, 1),
(131, '02', 'Product 3 Officer', 4, 5, 19, 43, 92, '2024-07-04 13:17:35', '2024-07-06 13:19:20', 1, 1, 1),
(132, '01', 'Product 5', 4, 5, 19, 44, 93, '2024-07-04 13:17:35', '2024-07-06 13:19:20', 1, 1, 1),
(133, '02', 'Product 5 Officer', 4, 5, 19, 44, 93, '2024-07-04 13:17:35', '2024-07-06 13:19:20', 1, 1, 1),
(134, '01', 'Product Development', 4, 5, 19, 45, 94, '2024-07-04 13:17:35', '2024-07-06 13:19:20', 1, 1, 1),
(135, '02', 'Product Development Officer', 4, 5, 19, 45, 94, '2024-07-04 13:17:35', '2024-07-06 13:19:20', 1, 1, 1),
(136, '01', 'Product 12 EcoCity', 4, 5, 19, 46, 95, '2024-07-04 13:17:35', '2024-07-06 13:19:20', 1, 1, 1),
(137, '01', 'Product 12', 4, 5, 19, 46, 96, '2024-07-04 13:17:35', '2024-07-06 13:19:20', 1, 1, 1),
(138, '02', 'Organic', 4, 5, 19, 46, 96, '2024-07-04 13:17:35', '2024-07-06 13:19:20', 1, 1, 1),
(139, '01', 'Product Administration', 4, 5, 20, 47, 97, '2024-07-04 13:17:35', '2024-07-06 13:19:20', 1, 1, 1),
(140, '01', 'Codif & Admin', 4, 5, 20, 47, 98, '2024-07-04 13:17:35', '2024-07-06 13:19:20', 1, 1, 1),
(141, '02', 'Codif & Admin Officer', 4, 5, 20, 47, 98, '2024-07-04 13:17:35', '2024-07-06 13:19:20', 1, 1, 1),
(142, '01', 'Supply & Demand Planning', 4, 5, 21, 48, 99, '2024-07-04 13:17:35', '2024-07-06 13:19:20', 1, 1, 1),
(143, '01', 'Planner', 4, 5, 21, 48, 100, '2024-07-04 13:17:35', '2024-07-06 13:19:20', 1, 1, 1),
(144, '02', 'Planner Product', 4, 5, 21, 48, 100, '2024-07-04 13:17:35', '2024-07-06 13:19:20', 1, 1, 1),
(145, '03', 'Planner Store', 4, 5, 21, 48, 100, '2024-07-04 13:17:35', '2024-07-06 13:19:20', 1, 1, 1),
(146, '01', 'Admin, Display & Project', 4, 5, 21, 48, 101, '2024-07-04 13:17:35', '2024-07-06 13:19:20', 1, 1, 1),
(147, '02', 'Admin PO & STO', 4, 5, 21, 48, 101, '2024-07-04 13:17:35', '2024-07-06 13:19:20', 1, 1, 1),
(148, '01', 'Marketing', 4, 5, 22, 49, 102, '2024-07-04 13:17:35', '2024-07-06 13:19:20', 1, 1, 1),
(149, '01', 'Marketing Communication', 4, 5, 22, 50, 103, '2024-07-04 13:17:35', '2024-07-06 13:19:20', 1, 1, 1),
(150, '01', 'Digital & Brand Activation', 4, 5, 22, 50, 104, '2024-07-04 13:17:35', '2024-07-06 13:19:20', 1, 1, 1),
(151, '02', 'Digital & Social Media', 4, 5, 22, 50, 104, '2024-07-04 13:17:35', '2024-07-06 13:19:20', 1, 1, 1),
(152, '01', 'Public Relation', 4, 5, 22, 50, 105, '2024-07-04 13:17:35', '2024-07-06 13:19:20', 1, 1, 1),
(153, '01', 'Graphic, Video & Illustration', 4, 5, 22, 50, 106, '2024-07-04 13:17:35', '2024-07-06 13:19:20', 1, 1, 1),
(154, '02', 'Graphic Design', 4, 5, 22, 50, 106, '2024-07-04 13:17:35', '2024-07-06 13:19:20', 1, 1, 1),
(155, '01', 'Trade Marketing', 4, 5, 22, 51, 107, '2024-07-04 13:17:35', '2024-07-06 13:19:20', 1, 1, 1),
(156, '01', 'Indoor Outdoor Media', 4, 5, 22, 51, 108, '2024-07-04 13:17:35', '2024-07-06 13:19:20', 1, 1, 1),
(157, '02', 'Indoor Outdoor Media Officer', 4, 5, 22, 51, 108, '2024-07-04 13:17:35', '2024-07-06 13:19:20', 1, 1, 1),
(158, '01', 'Visual Merchandising & Inhouse Production', 4, 5, 22, 51, 109, '2024-07-04 13:17:35', '2024-07-06 13:19:20', 1, 1, 1),
(159, '02', 'Visual Merchandising', 4, 5, 22, 51, 109, '2024-07-04 13:17:35', '2024-07-06 13:19:20', 1, 1, 1),
(160, '03', 'Inhouse Production', 4, 5, 22, 51, 109, '2024-07-04 13:17:35', '2024-07-06 13:19:20', 1, 1, 1),
(161, '01', 'CRM & Event', 4, 5, 22, 52, 110, '2024-07-04 13:17:35', '2024-07-06 13:19:20', 1, 1, 1),
(162, '01', 'CRM', 4, 5, 22, 52, 111, '2024-07-04 13:17:35', '2024-07-06 13:19:20', 1, 1, 1),
(163, '02', 'Data Analyst', 4, 5, 22, 52, 111, '2024-07-04 13:17:35', '2024-07-06 13:19:20', 1, 1, 1),
(164, '03', 'CRM Officer', 4, 5, 22, 52, 111, '2024-07-04 13:17:35', '2024-07-06 13:19:20', 1, 1, 1),
(165, '01', 'Event', 4, 5, 22, 52, 112, '2024-07-04 13:17:35', '2024-07-06 13:19:20', 1, 1, 1),
(166, '02', 'Event Officer', 4, 5, 22, 52, 112, '2024-07-04 13:17:35', '2024-07-06 13:19:20', 1, 1, 1),
(167, '01', 'Contact Center', 4, 5, 22, 52, 113, '2024-07-04 13:17:35', '2024-07-06 13:19:20', 1, 1, 1),
(168, '02', 'Contact Center Officer', 4, 5, 22, 52, 113, '2024-07-04 13:17:35', '2024-07-06 13:19:20', 1, 1, 1),
(169, '01', 'Bank & Financing, Partnership & Marketing Support', 4, 5, 22, 53, 114, '2024-07-04 13:17:35', '2024-07-06 13:19:20', 1, 1, 1),
(170, '01', 'Bank & Financing', 4, 5, 22, 53, 115, '2024-07-04 13:17:35', '2024-07-06 13:19:20', 1, 1, 1),
(171, '02', 'Bank & Financing Officer', 4, 5, 22, 53, 115, '2024-07-04 13:17:35', '2024-07-06 13:19:20', 1, 1, 1),
(172, '01', 'Marketing Support', 4, 5, 22, 53, 116, '2024-07-04 13:17:35', '2024-07-06 13:19:20', 1, 1, 1),
(173, '02', 'Marketing Support Officer', 4, 5, 22, 53, 116, '2024-07-04 13:17:35', '2024-07-06 13:19:20', 1, 1, 1),
(174, '01', 'Retail Sales & Logistic', 4, 6, 23, 54, 117, '2024-07-04 13:17:35', '2024-07-06 13:19:20', 1, 1, 1),
(175, '01', 'Sales Offline', 4, 6, 24, 55, 118, '2024-07-04 13:17:35', '2024-07-06 13:19:20', 1, 1, 1),
(176, '01', 'Sales Operation', 4, 6, 24, 56, 119, '2024-07-04 13:17:35', '2024-07-06 13:19:20', 1, 1, 1),
(177, '01', 'Region 1', 4, 6, 24, 56, 120, '2024-07-04 13:17:35', '2024-07-06 13:19:20', 1, 1, 1),
(178, '02', 'Sales Store', 4, 6, 24, 56, 120, '2024-07-04 13:17:35', '2024-07-06 13:19:20', 1, 1, 1),
(179, '01', 'Region 2', 4, 6, 24, 56, 121, '2024-07-04 13:17:35', '2024-07-06 13:19:20', 1, 1, 1),
(180, '02', 'Sales Store', 4, 6, 24, 56, 121, '2024-07-04 13:17:35', '2024-07-06 13:19:20', 1, 1, 1),
(181, '01', 'Region 3', 4, 6, 24, 56, 122, '2024-07-04 13:17:35', '2024-07-06 13:19:20', 1, 1, 1),
(182, '02', 'Sales Store', 4, 6, 24, 56, 122, '2024-07-04 13:17:35', '2024-07-06 13:19:20', 1, 1, 1),
(183, '01', 'Region 4', 4, 6, 24, 56, 123, '2024-07-04 13:17:35', '2024-07-06 13:19:20', 1, 1, 1),
(184, '02', 'Sales Store', 4, 6, 24, 56, 123, '2024-07-04 13:17:35', '2024-07-06 13:19:20', 1, 1, 1),
(185, '01', 'Region 5', 4, 6, 24, 56, 124, '2024-07-04 13:17:35', '2024-07-06 13:19:20', 1, 1, 1),
(186, '02', 'Sales Store', 4, 6, 24, 56, 124, '2024-07-04 13:17:35', '2024-07-06 13:19:20', 1, 1, 1),
(187, '01', 'Region 6', 4, 6, 24, 56, 125, '2024-07-04 13:17:35', '2024-07-06 13:19:20', 1, 1, 1),
(188, '02', 'Sales Store', 4, 6, 24, 56, 125, '2024-07-04 13:17:35', '2024-07-06 13:19:20', 1, 1, 1),
(189, '01', 'Sales Analyst', 4, 6, 24, 56, 126, '2024-07-04 13:17:35', '2024-07-06 13:19:20', 1, 1, 1),
(190, '01', 'SOP & Training', 4, 6, 24, 56, 127, '2024-07-04 13:17:35', '2024-07-06 13:19:20', 1, 1, 1),
(191, '01', 'Logistic', 4, 6, 25, 57, 128, '2024-07-04 13:17:35', '2024-07-06 13:19:20', 1, 1, 1),
(192, '01', 'National Logistic Warehouse', 4, 6, 25, 58, 129, '2024-07-04 13:17:35', '2024-07-06 13:19:20', 1, 1, 1),
(193, '01', 'Logistic DC', 4, 6, 25, 58, 130, '2024-07-04 13:17:35', '2024-07-06 13:19:20', 1, 1, 1),
(194, '02', 'Warehouse', 4, 6, 25, 58, 130, '2024-07-04 13:17:35', '2024-07-06 13:19:20', 1, 1, 1),
(195, '03', 'Homedel', 4, 6, 25, 58, 130, '2024-07-04 13:17:35', '2024-07-06 13:19:20', 1, 1, 1),
(196, '01', 'Inventory Control', 4, 6, 25, 58, 131, '2024-07-04 13:17:35', '2024-07-06 13:19:20', 1, 1, 1),
(197, '01', 'Administrasi Logistic', 4, 6, 25, 58, 132, '2024-07-04 13:17:35', '2024-07-06 13:19:20', 1, 1, 1),
(198, '02', 'Administrasi Logistic Officer', 4, 6, 25, 58, 132, '2024-07-04 13:17:35', '2024-07-06 13:19:20', 1, 1, 1),
(199, '01', 'Sales Online', 4, 6, 26, 59, 133, '2024-07-04 13:17:35', '2024-07-06 13:19:20', 1, 1, 1),
(200, '01', 'Product Marketing', 4, 6, 26, 60, 134, '2024-07-04 13:17:35', '2024-07-06 13:19:20', 1, 1, 1),
(201, '01', 'E-commerce & Marketplace Specialist', 4, 6, 26, 60, 135, '2024-07-04 13:17:35', '2024-07-06 13:19:20', 1, 1, 1),
(202, '02', 'E-commerce & Marketplace Specialist Officer', 4, 6, 26, 60, 135, '2024-07-04 13:17:35', '2024-07-06 13:19:20', 1, 1, 1),
(203, '01', 'Product Acquistion & New Business', 4, 6, 26, 60, 136, '2024-07-04 13:17:35', '2024-07-06 13:19:20', 1, 1, 1),
(204, '02', 'Product Acquistion & New Business Officer', 4, 6, 26, 60, 136, '2024-07-04 13:17:35', '2024-07-06 13:19:20', 1, 1, 1),
(205, '01', 'Performance Marketing Specialist', 4, 6, 26, 60, 137, '2024-07-04 13:17:35', '2024-07-06 13:19:20', 1, 1, 1),
(206, '01', 'Graphic Designer', 4, 6, 26, 60, 138, '2024-07-04 13:17:35', '2024-07-06 13:19:20', 1, 1, 1),
(207, '01', 'Administrasi E-commerce', 4, 6, 26, 60, 139, '2024-07-04 13:17:35', '2024-07-06 13:19:20', 1, 1, 1),
(208, '01', 'Development', 4, 6, 26, 61, 140, '2024-07-04 13:17:35', '2024-07-06 13:19:20', 1, 1, 1),
(209, '02', 'Developer', 4, 6, 26, 61, 141, '2024-07-04 13:17:35', '2024-07-06 13:19:20', 1, 1, 1),
(210, '01', 'Wholesales', 4, 7, 27, 62, 142, '2024-07-04 13:17:35', '2024-07-06 13:19:20', 1, 1, 1),
(211, '01', 'Central Purchasing', 4, 7, 28, 63, 143, '2024-07-04 13:17:35', '2024-07-06 13:19:20', 1, 1, 1),
(212, '01', 'Sales', 4, 7, 28, 64, 144, '2024-07-04 13:17:35', '2024-07-06 13:19:20', 1, 1, 1),
(213, '01', 'Key Account', 4, 7, 28, 64, 145, '2024-07-04 13:17:35', '2024-07-06 13:19:20', 1, 1, 1),
(214, '02', 'Key Account Officer', 4, 7, 28, 64, 145, '2024-07-04 13:17:35', '2024-07-06 13:19:20', 1, 1, 1),
(215, '01', 'Administration', 4, 7, 28, 65, 146, '2024-07-04 13:17:35', '2024-07-06 13:19:20', 1, 1, 1),
(216, '01', 'Sales Support Administration', 4, 7, 28, 65, 147, '2024-07-04 13:17:35', '2024-07-06 13:19:20', 1, 1, 1),
(217, '02', 'Sales Support Administration Officer', 4, 7, 28, 65, 147, '2024-07-04 13:17:35', '2024-07-06 13:19:20', 1, 1, 1),
(218, '01', 'System & Wholesales Market', 4, 7, 28, 66, 148, '2024-07-04 13:17:35', '2024-07-06 13:19:20', 1, 1, 1),
(219, '01', 'System & Promotion', 4, 7, 28, 66, 149, '2024-07-04 13:17:35', '2024-07-06 13:19:20', 1, 1, 1),
(220, '02', 'System & Promotion Officer', 4, 7, 28, 66, 149, '2024-07-04 13:17:35', '2024-07-06 13:19:20', 1, 1, 1),
(221, '01', 'Wholesales Market', 4, 7, 28, 66, 150, '2024-07-04 13:17:35', '2024-07-06 13:19:20', 1, 1, 1),
(222, '02', 'Wholesales Market Officer', 4, 7, 28, 66, 150, '2024-07-04 13:17:35', '2024-07-06 13:19:20', 1, 1, 1),
(223, '01', 'Procurement Non Trade', 4, 7, 28, 67, 151, '2024-07-04 13:17:35', '2024-07-06 13:19:20', 1, 1, 1),
(224, '01', 'Procurement', 4, 7, 28, 67, 152, '2024-07-04 13:17:35', '2024-07-06 13:19:20', 1, 1, 1),
(225, '02', 'Procurement Officer', 4, 7, 28, 67, 152, '2024-07-04 13:17:35', '2024-07-06 13:19:20', 1, 1, 1),
(226, '01', 'Wholesales Div', 4, 7, 29, 68, 153, '2024-07-04 13:17:35', '2024-07-06 13:19:20', 1, 1, 1),
(227, '01', 'Merchandising OEM', 4, 7, 29, 69, 154, '2024-07-04 13:17:35', '2024-07-06 13:19:20', 1, 1, 1),
(228, '01', 'Merchandising Section', 4, 7, 29, 69, 155, '2024-07-04 13:17:35', '2024-07-06 13:19:20', 1, 1, 1),
(229, '02', 'Merchandize OEM Officer', 4, 7, 29, 69, 155, '2024-07-04 13:17:35', '2024-07-06 13:19:20', 1, 1, 1),
(230, '01', 'Sales & Marketing Communication OEM', 4, 7, 29, 70, 156, '2024-07-04 13:17:35', '2024-07-06 13:19:20', 1, 1, 1),
(231, '01', 'Sales Section', 4, 7, 29, 70, 157, '2024-07-04 13:17:35', '2024-07-06 13:19:20', 1, 1, 1),
(232, '02', 'Sales Officer', 4, 7, 29, 70, 157, '2024-07-04 13:17:35', '2024-07-06 13:19:20', 1, 1, 1),
(233, '01', 'Marketing Communication Section', 4, 7, 29, 70, 158, '2024-07-04 13:17:35', '2024-07-06 13:19:20', 1, 1, 1),
(234, '02', 'Marketing Communication Officer', 4, 7, 29, 70, 158, '2024-07-04 13:17:35', '2024-07-06 13:19:20', 1, 1, 1),
(235, '01', 'SNDP OEM', 4, 7, 29, 71, 159, '2024-07-04 13:17:35', '2024-07-06 13:19:20', 1, 1, 1),
(236, '01', 'SNDP', 4, 7, 29, 71, 160, '2024-07-04 13:17:35', '2024-07-06 13:19:20', 1, 1, 1),
(237, '02', 'SNDP Officer', 4, 7, 29, 71, 160, '2024-07-04 13:17:35', '2024-07-06 13:19:20', 1, 1, 1),
(238, '01', 'Internal Audit', 4, 8, 30, 72, 161, '2024-07-04 13:17:35', '2024-07-06 13:19:20', 1, 1, 1),
(239, '01', 'Internal Audit Officer', 4, 8, 30, 72, 162, '2024-07-04 13:17:35', '2024-07-06 13:19:20', 1, 1, 1),
(240, '01', 'SOP Officer', 4, 8, 30, 72, 163, '2024-07-04 13:17:35', '2024-07-06 13:19:20', 1, 1, 1),
(241, '01', 'After Sales', 5, 9, 31, 73, 164, '2024-07-04 13:17:35', '2024-07-06 13:19:20', 1, 1, 1),
(242, '01', 'After Sales (GKT)', 5, 9, 32, 74, 165, '2024-07-04 13:17:35', '2024-07-06 13:19:20', 1, 1, 1),
(243, '01', 'HR & GA', 5, 9, 32, 75, 166, '2024-07-04 13:17:35', '2024-07-06 13:19:20', 1, 1, 1),
(244, '01', 'GA', 5, 9, 32, 75, 167, '2024-07-04 13:17:35', '2024-07-06 13:19:20', 1, 1, 1),
(245, '02', 'GA Officer', 5, 9, 32, 75, 167, '2024-07-04 13:17:35', '2024-07-06 13:19:20', 1, 1, 1),
(246, '01', 'Admin & Recruitment', 5, 9, 32, 75, 168, '2024-07-04 13:17:35', '2024-07-06 13:19:20', 1, 1, 1),
(247, '01', 'OB & Messenger', 5, 9, 32, 75, 169, '2024-07-04 13:17:35', '2024-07-06 13:19:20', 1, 1, 1),
(248, '01', 'Marketing', 5, 9, 32, 76, 170, '2024-07-04 13:17:35', '2024-07-06 13:19:20', 1, 1, 1),
(249, '01', 'Admin & CC', 5, 9, 32, 76, 171, '2024-07-04 13:17:35', '2024-07-06 13:19:20', 1, 1, 1),
(250, '02', 'Administrasi', 5, 9, 32, 76, 171, '2024-07-04 13:17:35', '2024-07-06 13:19:20', 1, 1, 1),
(251, '03', 'Call Center', 5, 9, 32, 76, 171, '2024-07-04 13:17:35', '2024-07-06 13:19:20', 1, 1, 1),
(252, '01', 'Sales & Operational', 5, 9, 32, 77, 172, '2024-07-04 13:17:35', '2024-07-06 13:19:20', 1, 1, 1),
(253, '01', 'Operation Alam Sutera', 5, 9, 32, 77, 173, '2024-07-04 13:17:35', '2024-07-06 13:19:20', 1, 1, 1),
(254, '02', 'Instalasi', 5, 9, 32, 77, 173, '2024-07-04 13:17:35', '2024-07-06 13:19:20', 1, 1, 1),
(255, '03', 'Service', 5, 9, 32, 77, 173, '2024-07-04 13:17:35', '2024-07-06 13:19:20', 1, 1, 1),
(256, '04', 'Logistic', 5, 9, 32, 77, 173, '2024-07-04 13:17:35', '2024-07-06 13:19:20', 1, 1, 1),
(257, '01', 'Operation Depok', 5, 9, 32, 77, 174, '2024-07-04 13:17:35', '2024-07-06 13:19:20', 1, 1, 1),
(258, '02', 'Instalasi', 5, 9, 32, 77, 174, '2024-07-04 13:17:35', '2024-07-06 13:19:20', 1, 1, 1),
(259, '03', 'Service', 5, 9, 32, 77, 174, '2024-07-04 13:17:35', '2024-07-06 13:19:20', 1, 1, 1),
(260, '04', 'Logistic', 5, 9, 32, 77, 174, '2024-07-04 13:17:35', '2024-07-06 13:19:20', 1, 1, 1),
(261, '01', 'Operation Bekasi', 5, 9, 32, 77, 175, '2024-07-04 13:17:35', '2024-07-06 13:19:20', 1, 1, 1),
(262, '02', 'Instalasi', 5, 9, 32, 77, 175, '2024-07-04 13:17:35', '2024-07-06 13:19:20', 1, 1, 1),
(263, '03', 'Service', 5, 9, 32, 77, 175, '2024-07-04 13:17:35', '2024-07-06 13:19:20', 1, 1, 1),
(264, '04', 'Logistic', 5, 9, 32, 77, 175, '2024-07-04 13:17:35', '2024-07-06 13:19:20', 1, 1, 1),
(265, '01', 'Project', 5, 9, 32, 77, 176, '2024-07-04 13:17:35', '2024-07-06 13:19:20', 1, 1, 1),
(266, '02', 'Project Officer', 5, 9, 32, 77, 176, '2024-07-04 13:17:35', '2024-07-06 13:19:20', 1, 1, 1),
(267, '01', 'Operation Bintaro', 5, 9, 32, 77, 177, '2024-07-04 13:17:35', '2024-07-06 13:19:20', 1, 1, 1),
(268, '02', 'Instalasi', 5, 9, 32, 77, 177, '2024-07-04 13:17:35', '2024-07-06 13:19:20', 1, 1, 1),
(269, '03', 'Service', 5, 9, 32, 77, 177, '2024-07-04 13:17:35', '2024-07-06 13:19:20', 1, 1, 1),
(270, '01', 'Finance & Accounting', 5, 9, 32, 78, 178, '2024-07-04 13:17:35', '2024-07-06 13:19:20', 1, 1, 1),
(271, '01', 'FA', 5, 9, 32, 78, 179, '2024-07-04 13:17:35', '2024-07-06 13:19:20', 1, 1, 1),
(272, '02', 'FA Officer', 5, 9, 32, 78, 179, '2024-07-04 13:17:35', '2024-07-06 13:19:20', 1, 1, 1),
(273, '01', 'Clean City', 5, 9, 32, 79, 180, '2024-07-04 13:17:35', '2024-07-06 13:19:20', 1, 1, 1),
(274, '01', 'Office', 5, 9, 32, 79, 181, '2024-07-04 13:17:35', '2024-07-06 13:19:20', 1, 1, 1),
(275, '01', 'Service', 5, 9, 32, 79, 182, '2024-07-04 13:17:35', '2024-07-06 13:19:20', 1, 1, 1),
(276, '02', 'Teknisi', 5, 9, 32, 79, 182, '2024-07-04 13:17:35', '2024-07-06 13:19:20', 1, 1, 1),
(277, '01', 'Event & Production', 1, 10, 33, 80, 183, '2024-07-04 13:17:35', '2024-07-06 13:19:20', 1, 1, 1),
(278, '01', 'Event & Marketing', 1, 10, 34, 81, 184, '2024-07-04 13:17:35', '2024-07-06 13:19:20', 1, 1, 1),
(279, '01', 'Creative & Partnership', 1, 10, 34, 82, 185, '2024-07-04 13:17:35', '2024-07-06 13:19:20', 1, 1, 1),
(280, '01', 'Design & Socmed', 1, 10, 34, 82, 186, '2024-07-04 13:17:35', '2024-07-06 13:19:20', 1, 1, 1),
(281, '01', 'Partnership', 1, 10, 34, 82, 187, '2024-07-04 13:17:35', '2024-07-06 13:19:20', 1, 1, 1),
(282, '01', 'Marketing Communication', 1, 10, 34, 83, 188, '2024-07-04 13:17:35', '2024-07-06 13:19:20', 1, 1, 1),
(283, '01', 'Marketing Communication Officer', 1, 10, 34, 83, 189, '2024-07-04 13:17:35', '2024-07-06 13:19:20', 1, 1, 1),
(284, '01', 'Event', 1, 10, 34, 84, 190, '2024-07-04 13:17:35', '2024-07-06 13:19:20', 1, 1, 1),
(285, '01', 'Production', 1, 10, 34, 84, 191, '2024-07-04 13:17:35', '2024-07-06 13:19:20', 1, 1, 1),
(286, '02', 'Production Officer', 1, 10, 34, 84, 191, '2024-07-04 13:17:35', '2024-07-06 13:19:20', 1, 1, 1),
(287, '01', 'Logistic', 1, 10, 34, 84, 192, '2024-07-04 13:17:35', '2024-07-06 13:19:20', 1, 1, 1),
(288, '01', 'Talent', 1, 10, 34, 84, 193, '2024-07-04 13:17:35', '2024-07-06 13:19:20', 1, 1, 1),
(289, '01', 'Administrasi', 1, 10, 34, 84, 194, '2024-07-04 13:17:35', '2024-07-06 13:19:20', 1, 1, 1),
(290, '01', 'Sekretaris', 1, 10, 34, 85, 195, '2024-07-04 13:17:35', '2024-07-06 13:19:20', 1, 1, 1),
(291, '01', 'Operational', 1, 11, 35, 86, 196, '2024-07-04 13:17:35', '2024-07-06 13:19:20', 1, 1, 1),
(292, '01', 'FAT', 1, 11, 36, 87, 197, '2024-07-04 13:17:35', '2024-07-06 13:19:20', 1, 1, 1),
(293, '01', 'Tax', 1, 11, 36, 88, 198, '2024-07-04 13:17:35', '2024-07-06 13:19:20', 1, 1, 1),
(294, '01', 'Account Receivable', 1, 11, 36, 88, 199, '2024-07-04 13:17:35', '2024-07-06 13:19:20', 1, 1, 1),
(295, '01', 'Account Payable', 1, 11, 36, 88, 200, '2024-07-04 13:17:35', '2024-07-06 13:19:20', 1, 1, 1),
(296, '01', 'Estate Management', 1, 11, 37, 89, 201, '2024-07-04 13:17:35', '2024-07-06 13:19:20', 1, 1, 1),
(297, '01', 'Operational QC', 1, 11, 37, 90, 202, '2024-07-04 13:17:35', '2024-07-06 13:19:20', 1, 1, 1),
(298, '01', 'Safety K3', 1, 11, 37, 90, 203, '2024-07-04 13:17:35', '2024-07-06 13:19:20', 1, 1, 1),
(299, '02', 'Maintenance', 1, 11, 37, 90, 203, '2024-07-04 13:17:35', '2024-07-06 13:19:20', 1, 1, 1),
(300, '01', 'Tenant Relation & Leasing', 1, 11, 37, 90, 204, '2024-07-04 13:17:35', '2024-07-06 13:19:20', 1, 1, 1),
(301, '02', 'Reception TR', 1, 11, 37, 90, 204, '2024-07-04 13:17:35', '2024-07-06 13:19:20', 1, 1, 1),
(302, '03', 'Leasing', 1, 11, 37, 90, 204, '2024-07-04 13:17:35', '2024-07-06 13:19:20', 1, 1, 1),
(303, '01', 'HRD & GA', 1, 11, 37, 91, 205, '2024-07-04 13:17:35', '2024-07-06 13:19:20', 1, 1, 1),
(304, '01', 'HRD', 1, 11, 37, 91, 206, '2024-07-04 13:17:35', '2024-07-06 13:19:20', 1, 1, 1),
(305, '01', 'GA Supporting', 1, 11, 37, 91, 207, '2024-07-04 13:17:35', '2024-07-06 13:19:20', 1, 1, 1),
(306, '02', 'Purchasing', 1, 11, 37, 91, 207, '2024-07-04 13:17:35', '2024-07-06 13:19:20', 1, 1, 1),
(307, '03', 'Asset', 1, 11, 37, 91, 207, '2024-07-04 13:17:35', '2024-07-06 13:19:20', 1, 1, 1),
(308, '01', 'Legal', 1, 11, 37, 92, 208, '2024-07-04 13:17:35', '2024-07-06 13:19:20', 1, 1, 1),
(309, '01', 'Legal Officer', 1, 11, 37, 92, 209, '2024-07-04 13:17:35', '2024-07-06 13:19:20', 1, 1, 1),
(310, '01', 'Groceries', 2, 12, 38, 93, 210, '2024-07-04 13:17:35', '2024-07-06 13:19:20', 1, 1, 1),
(311, '01', 'Commercial', 2, 12, 39, 94, 211, '2024-07-04 13:17:35', '2024-07-06 13:19:20', 1, 1, 1),
(312, '01', 'Merchandising', 2, 12, 39, 95, 212, '2024-07-04 13:17:35', '2024-07-06 13:19:20', 1, 1, 1),
(313, '01', 'Non Food', 2, 12, 39, 95, 213, '2024-07-04 13:17:35', '2024-07-06 13:19:20', 1, 1, 1),
(314, '02', 'Non Food Officer', 2, 12, 39, 95, 213, '2024-07-04 13:17:35', '2024-07-06 13:19:20', 1, 1, 1),
(315, '01', 'Dry Food', 2, 12, 39, 95, 214, '2024-07-04 13:17:35', '2024-07-06 13:19:20', 1, 1, 1),
(316, '02', 'Dry Food Officer', 2, 12, 39, 95, 214, '2024-07-04 13:17:35', '2024-07-06 13:19:20', 1, 1, 1),
(317, '01', 'Fresh Food', 2, 12, 39, 95, 215, '2024-07-04 13:17:35', '2024-07-06 13:19:20', 1, 1, 1),
(318, '02', 'Fresh Food Officer', 2, 12, 39, 95, 215, '2024-07-04 13:17:35', '2024-07-06 13:19:20', 1, 1, 1),
(319, '01', 'Sales Operation', 2, 12, 39, 96, 216, '2024-07-04 13:17:35', '2024-07-06 13:19:20', 1, 1, 1),
(320, '01', 'Alam Sutera', 2, 12, 39, 96, 217, '2024-07-04 13:17:35', '2024-07-06 13:19:20', 1, 1, 1),
(321, '02', 'Operation', 2, 12, 39, 96, 217, '2024-07-04 13:17:35', '2024-07-06 13:19:20', 1, 1, 1),
(322, '01', 'Bintaro', 2, 12, 39, 96, 218, '2024-07-04 13:17:35', '2024-07-06 13:19:20', 1, 1, 1),
(323, '02', 'Operation', 2, 12, 39, 96, 218, '2024-07-04 13:17:35', '2024-07-06 13:19:20', 1, 1, 1),
(324, '01', 'Marketing', 2, 12, 39, 97, 219, '2024-07-04 13:17:35', '2024-07-06 13:19:20', 1, 1, 1),
(325, '01', 'Desainer', 2, 12, 39, 97, 220, '2024-07-04 13:17:35', '2024-07-06 13:19:20', 1, 1, 1),
(326, '01', 'FA & IT', 2, 12, 40, 98, 221, '2024-07-04 13:17:35', '2024-07-06 13:19:20', 1, 1, 1),
(327, '01', 'Finance & Accounting', 2, 12, 40, 99, 222, '2024-07-04 13:17:35', '2024-07-06 13:19:20', 1, 1, 1),
(328, '01', 'FA', 2, 12, 40, 99, 223, '2024-07-04 13:17:35', '2024-07-06 13:19:20', 1, 1, 1),
(329, '02', 'HR & GA', 2, 12, 40, 99, 223, '2024-07-04 13:17:35', '2024-07-06 13:19:20', 1, 1, 1),
(330, '03', 'Finance', 2, 12, 40, 99, 223, '2024-07-04 13:17:35', '2024-07-06 13:19:20', 1, 1, 1),
(331, '01', 'Information Technology', 2, 12, 40, 100, 224, '2024-07-04 13:17:35', '2024-07-06 13:19:20', 1, 1, 1),
(332, '01', 'Niscaya Raharja Calya', 3, 13, 41, 101, 225, '2024-07-04 13:17:35', '2024-07-06 13:19:20', 1, 1, 1);

-- --------------------------------------------------------

--
-- Table structure for table `m_unitkerja`
--

CREATE TABLE `m_unitkerja` (
  `id` int(11) NOT NULL,
  `code` varchar(255) DEFAULT NULL,
  `name` varchar(255) DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `modified_at` datetime DEFAULT NULL ON UPDATE current_timestamp(),
  `created_by` int(11) DEFAULT NULL,
  `modified_by` int(11) DEFAULT NULL,
  `isaktif` int(11) DEFAULT NULL,
  `companycode` varchar(255) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

--
-- Dumping data for table `m_unitkerja`
--

INSERT INTO `m_unitkerja` (`id`, `code`, `name`, `created_at`, `modified_at`, `created_by`, `modified_by`, `isaktif`, `companycode`) VALUES
(1, '02', 'Creative Event Entertainment', '2024-07-03 20:37:48', '2024-07-06 13:14:25', 1, 1, 1, NULL),
(2, '03', 'Grooceries City Indonesia', '2024-07-03 20:37:48', '2024-07-17 11:06:57', 1, 1, 1, 'G015'),
(3, '05', 'Niscaya Raharja Calya', '2024-07-03 20:37:48', '2024-07-06 13:14:41', 1, 1, 1, NULL),
(4, '01', 'Electronic City Indonesia', '2024-07-03 20:37:48', '2024-07-17 11:06:44', 1, 1, 1, 'EC01'),
(5, '04', 'Graha Karunia Trading', '2024-07-03 20:37:48', '2024-07-06 13:14:40', 1, 1, 1, NULL);

-- --------------------------------------------------------

--
-- Table structure for table `m_usergroup`
--

CREATE TABLE `m_usergroup` (
  `iduser` int(11) NOT NULL,
  `idgroup` int(11) NOT NULL,
  `created_at` datetime DEFAULT NULL,
  `modified_at` datetime DEFAULT NULL ON UPDATE current_timestamp(),
  `created_by` int(11) DEFAULT NULL,
  `modified_by` int(11) DEFAULT NULL,
  `menuid` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

--
-- Dumping data for table `m_usergroup`
--

INSERT INTO `m_usergroup` (`iduser`, `idgroup`, `created_at`, `modified_at`, `created_by`, `modified_by`, `menuid`) VALUES
(1, 1, '2024-07-03 19:35:10', '2024-07-15 15:28:03', 1, 1, 1),
(1, 1, '2024-07-03 19:35:10', '2024-07-15 15:28:03', 1, 1, 2),
(2, 4, '2024-07-03 19:35:10', '2024-07-15 15:28:03', 1, 1, 1),
(3, 4, '2024-07-03 19:35:10', '2024-07-15 15:28:03', 1, 1, 1),
(4, 4, '2024-07-03 19:35:10', '2024-07-15 15:28:03', 1, 1, 1),
(5, 4, '2024-07-03 19:35:10', '2024-07-15 15:28:03', 1, 1, 1),
(6, 4, '2024-07-03 19:35:10', '2024-07-15 15:28:03', 1, 1, 1),
(7, 4, '2024-07-03 19:35:10', '2024-07-15 15:28:03', 1, 1, 1),
(8, 4, '2024-07-03 19:35:10', '2024-07-15 15:28:03', 1, 1, 1),
(9, 4, '2024-07-03 19:35:10', '2024-07-15 15:28:03', 1, 1, 1),
(10, 4, '2024-07-03 19:35:10', '2024-07-15 15:28:03', 1, 1, 1),
(11, 4, '2024-07-03 19:35:10', '2024-07-15 15:28:03', 1, 1, 1),
(12, 4, '2024-07-03 19:35:10', '2024-07-15 15:28:03', 1, 1, 1),
(13, 4, '2024-07-03 19:35:10', '2024-07-15 15:28:03', 1, 1, 1),
(14, 4, '2024-07-03 19:35:10', '2024-07-15 15:28:03', 1, 1, 1),
(15, 4, '2024-07-03 19:35:10', '2024-07-15 15:28:03', 1, 1, 1),
(16, 4, '2024-07-03 19:35:10', '2024-07-15 15:28:03', 1, 1, 1),
(17, 4, '2024-07-03 19:35:10', '2024-07-15 15:28:03', 1, 1, 1),
(18, 4, '2024-07-03 19:35:10', '2024-07-15 15:28:03', 1, 1, 1),
(19, 4, '2024-07-03 19:35:10', '2024-07-15 15:28:03', 1, 1, 1),
(20, 4, '2024-07-03 19:35:10', '2024-07-15 15:28:03', 1, 1, 1),
(21, 4, '2024-07-03 19:35:10', '2024-07-15 15:28:03', 1, 1, 1),
(22, 4, '2024-07-03 19:35:10', '2024-07-15 15:28:03', 1, 1, 1),
(23, 4, '2024-07-03 19:35:10', '2024-07-15 15:28:03', 1, 1, 1),
(24, 4, '2024-07-03 19:35:10', '2024-07-15 15:28:03', 1, 1, 1),
(25, 4, '2024-07-03 19:35:10', '2024-07-15 15:28:03', 1, 1, 1),
(26, 4, '2024-07-03 19:35:10', '2024-07-15 15:28:03', 1, 1, 1),
(27, 4, '2024-07-03 19:35:10', '2024-07-15 15:28:03', 1, 1, 1),
(28, 4, '2024-07-03 19:35:10', '2024-07-15 15:28:03', 1, 1, 1),
(29, 4, '2024-07-03 19:35:10', '2024-07-15 15:28:03', 1, 1, 1),
(30, 4, '2024-07-03 19:35:10', '2024-07-15 15:28:03', 1, 1, 1),
(31, 4, '2024-07-03 19:35:10', '2024-07-15 15:28:03', 1, 1, 1),
(32, 4, '2024-07-03 19:35:10', '2024-07-15 15:28:03', 1, 1, 1),
(33, 4, '2024-07-03 19:35:10', '2024-07-15 15:28:03', 1, 1, 1),
(34, 4, '2024-07-03 19:35:10', '2024-07-15 15:28:03', 1, 1, 1),
(35, 4, '2024-07-03 19:35:10', '2024-07-15 15:28:03', 1, 1, 1),
(36, 4, '2024-07-03 19:35:10', '2024-07-15 15:28:03', 1, 1, 1),
(37, 4, '2024-07-03 19:35:10', '2024-07-15 15:28:03', 1, 1, 1),
(38, 4, '2024-07-03 19:35:10', '2024-07-15 15:28:03', 1, 1, 1),
(39, 4, '2024-07-03 19:35:10', '2024-07-15 15:28:03', 1, 1, 1),
(40, 4, '2024-07-03 19:35:10', '2024-07-15 15:28:03', 1, 1, 1),
(41, 4, '2024-07-03 19:35:10', '2024-07-15 15:28:03', 1, 1, 1),
(42, 4, '2024-07-03 19:35:10', '2024-07-15 15:28:03', 1, 1, 1),
(43, 4, '2024-07-03 19:35:10', '2024-07-15 15:28:03', 1, 1, 1),
(44, 4, '2024-07-03 19:35:10', '2024-07-15 15:28:03', 1, 1, 1),
(45, 9, NULL, '2024-07-16 16:45:52', 1, 1, 2),
(46, 10, NULL, '2024-07-16 16:45:52', 1, 1, 2),
(47, 11, NULL, '2024-07-16 16:45:52', 1, 1, 2),
(48, 12, NULL, '2024-07-16 16:45:52', 1, 1, 2),
(49, 13, NULL, '2024-07-16 16:45:52', 1, 1, 2),
(50, 14, NULL, '2024-07-16 16:45:52', 1, 1, 2),
(51, 15, NULL, '2024-07-16 16:45:52', 1, 1, 2),
(52, 16, NULL, '2024-07-16 16:45:52', 1, 1, 2),
(53, 17, NULL, '2024-07-16 16:45:52', 1, 1, 2),
(54, 18, NULL, '2024-07-16 16:45:52', 1, 1, 2),
(55, 3, NULL, '2024-07-16 16:45:52', 1, 1, 1),
(56, 8, NULL, '2024-07-16 16:45:52', 1, 1, 1),
(57, 4, NULL, '2024-07-16 16:45:52', 1, 1, 1),
(58, 5, NULL, '2024-07-16 16:45:52', 1, 1, 2),
(59, 4, NULL, '2024-07-16 16:45:52', 1, 1, 1),
(60, 4, NULL, '2024-07-16 16:45:52', 1, 1, 1),
(61, 4, NULL, '2024-07-16 16:45:52', 1, 1, 1);

-- --------------------------------------------------------

--
-- Table structure for table `m_userlogs`
--

CREATE TABLE `m_userlogs` (
  `id` int(11) NOT NULL,
  `detail` text DEFAULT NULL,
  `status` int(11) DEFAULT NULL COMMENT '0=gagal, 1=sukses',
  `created_by` int(11) DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `modified_by` int(11) DEFAULT NULL,
  `modified_at` datetime DEFAULT NULL ON UPDATE current_timestamp(),
  `action` varchar(255) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

-- --------------------------------------------------------

--
-- Table structure for table `m_users`
--

CREATE TABLE `m_users` (
  `id` int(11) NOT NULL,
  `username` varchar(255) NOT NULL,
  `password` varchar(255) DEFAULT NULL,
  `isaktif` int(11) DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `modified_at` datetime DEFAULT NULL ON UPDATE current_timestamp(),
  `created_by` int(11) DEFAULT NULL,
  `modified_by` int(11) DEFAULT NULL,
  `email` varchar(255) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

--
-- Dumping data for table `m_users`
--

INSERT INTO `m_users` (`id`, `username`, `password`, `isaktif`, `created_at`, `modified_at`, `created_by`, `modified_by`, `email`) VALUES
(1, '15080236', 'b626ebe3027038962d7acec9ebe4f1bc', 1, '2024-07-03 18:44:00', '2024-07-16 11:25:49', 1, 1, 'mochamad.seliratno@electronic-city.co.id'),
(2, '1202037', 'b626ebe3027038962d7acec9ebe4f1bc', 1, '2024-07-03 18:43:34', '2024-07-16 11:25:49', 1, 1, 'mochamad.seliratno@electronic-city.co.id'),
(3, '16030068', 'b626ebe3027038962d7acec9ebe4f1bc', 1, '2024-07-03 18:43:34', '2024-07-16 11:25:49', 1, 1, 'mochamad.seliratno@electronic-city.co.id'),
(4, '22120298', 'b626ebe3027038962d7acec9ebe4f1bc', 1, '2024-07-03 18:43:34', '2024-07-16 11:25:49', 1, 1, 'mochamad.seliratno@electronic-city.co.id'),
(5, '22120299', 'b626ebe3027038962d7acec9ebe4f1bc', 1, '2024-07-03 18:43:34', '2024-07-16 11:25:49', 1, 1, 'mochamad.seliratno@electronic-city.co.id'),
(6, '20070094', 'b626ebe3027038962d7acec9ebe4f1bc', 1, '2024-07-03 18:43:34', '2024-07-16 11:25:49', 1, 1, 'mochamad.seliratno@electronic-city.co.id'),
(7, '23070161', 'b626ebe3027038962d7acec9ebe4f1bc', 1, '2024-07-03 18:43:34', '2024-07-16 11:25:49', 1, 1, 'mochamad.seliratno@electronic-city.co.id'),
(8, '15050192', 'b626ebe3027038962d7acec9ebe4f1bc', 1, '2024-07-03 18:43:34', '2024-07-16 11:25:49', 1, 1, 'mochamad.seliratno@electronic-city.co.id'),
(9, '14090693', 'b626ebe3027038962d7acec9ebe4f1bc', 1, '2024-07-03 18:43:34', '2024-07-16 11:25:49', 1, 1, 'mochamad.seliratno@electronic-city.co.id'),
(10, '21050097', 'b626ebe3027038962d7acec9ebe4f1bc', 1, '2024-07-03 18:43:34', '2024-07-16 11:25:49', 1, 1, 'mochamad.seliratno@electronic-city.co.id'),
(11, '1301074', 'b626ebe3027038962d7acec9ebe4f1bc', 1, '2024-07-03 18:43:34', '2024-07-16 11:25:49', 1, 1, 'mochamad.seliratno@electronic-city.co.id'),
(12, '21040063', 'b626ebe3027038962d7acec9ebe4f1bc', 1, '2024-07-03 18:43:34', '2024-07-16 11:25:49', 1, 1, 'mochamad.seliratno@electronic-city.co.id'),
(13, '24050089', 'b626ebe3027038962d7acec9ebe4f1bc', 1, '2024-07-03 18:43:34', '2024-07-16 11:25:49', 1, 1, 'mochamad.seliratno@electronic-city.co.id'),
(14, '23080188', 'b626ebe3027038962d7acec9ebe4f1bc', 1, '2024-07-03 18:43:34', '2024-07-16 11:25:49', 1, 1, 'mochamad.seliratno@electronic-city.co.id'),
(15, '24040074', 'b626ebe3027038962d7acec9ebe4f1bc', 1, '2024-07-03 18:43:34', '2024-07-16 11:25:49', 1, 1, 'mochamad.seliratno@electronic-city.co.id'),
(16, '23090225', 'b626ebe3027038962d7acec9ebe4f1bc', 1, '2024-07-03 18:43:34', '2024-07-16 11:25:49', 1, 1, 'mochamad.seliratno@electronic-city.co.id'),
(17, '24010017', 'b626ebe3027038962d7acec9ebe4f1bc', 1, '2024-07-03 18:43:34', '2024-07-16 11:25:49', 1, 1, 'mochamad.seliratno@electronic-city.co.id'),
(18, '23050105', 'b626ebe3027038962d7acec9ebe4f1bc', 1, '2024-07-03 18:43:34', '2024-07-16 11:25:49', 1, 1, 'mochamad.seliratno@electronic-city.co.id'),
(19, '23030034', 'b626ebe3027038962d7acec9ebe4f1bc', 1, '2024-07-03 18:43:34', '2024-07-16 11:25:49', 1, 1, 'mochamad.seliratno@electronic-city.co.id'),
(20, '24040069', 'b626ebe3027038962d7acec9ebe4f1bc', 1, '2024-07-03 18:43:34', '2024-07-16 11:25:49', 1, 1, 'mochamad.seliratno@electronic-city.co.id'),
(21, '18080199', 'b626ebe3027038962d7acec9ebe4f1bc', 1, '2024-07-03 18:43:34', '2024-07-16 11:25:49', 1, 1, 'mochamad.seliratno@electronic-city.co.id'),
(22, '18030057', 'b626ebe3027038962d7acec9ebe4f1bc', 1, '2024-07-03 18:43:34', '2024-07-16 11:25:49', 1, 1, 'mochamad.seliratno@electronic-city.co.id'),
(23, '24020044', 'b626ebe3027038962d7acec9ebe4f1bc', 1, '2024-07-03 18:43:34', '2024-07-16 11:25:49', 1, 1, 'mochamad.seliratno@electronic-city.co.id'),
(24, '19070293', 'b626ebe3027038962d7acec9ebe4f1bc', 1, '2024-07-03 18:43:34', '2024-07-16 11:25:49', 1, 1, 'mochamad.seliratno@electronic-city.co.id'),
(25, '1301004', 'b626ebe3027038962d7acec9ebe4f1bc', 1, '2024-07-03 18:43:34', '2024-07-16 11:25:49', 1, 1, 'mochamad.seliratno@electronic-city.co.id'),
(26, '22050135', 'b626ebe3027038962d7acec9ebe4f1bc', 1, '2024-07-03 18:43:34', '2024-07-16 11:25:49', 1, 1, 'mochamad.seliratno@electronic-city.co.id'),
(27, '24020037', 'b626ebe3027038962d7acec9ebe4f1bc', 1, '2024-07-03 18:43:34', '2024-07-16 11:25:49', 1, 1, 'mochamad.seliratno@electronic-city.co.id'),
(28, '24020036', 'b626ebe3027038962d7acec9ebe4f1bc', 1, '2024-07-03 18:43:34', '2024-07-16 11:25:49', 1, 1, 'mochamad.seliratno@electronic-city.co.id'),
(29, '24010002', 'b626ebe3027038962d7acec9ebe4f1bc', 1, '2024-07-03 18:43:34', '2024-07-16 11:25:49', 1, 1, 'mochamad.seliratno@electronic-city.co.id'),
(30, '24010015', 'b626ebe3027038962d7acec9ebe4f1bc', 1, '2024-07-03 18:43:34', '2024-07-16 11:25:49', 1, 1, 'mochamad.seliratno@electronic-city.co.id'),
(31, '22040111', 'b626ebe3027038962d7acec9ebe4f1bc', 1, '2024-07-03 18:43:34', '2024-07-16 11:25:49', 1, 1, 'mochamad.seliratno@electronic-city.co.id'),
(32, '16070160', 'b626ebe3027038962d7acec9ebe4f1bc', 1, '2024-07-03 18:43:34', '2024-07-16 11:25:49', 1, 1, 'mochamad.seliratno@electronic-city.co.id'),
(33, '1302107', 'b626ebe3027038962d7acec9ebe4f1bc', 1, '2024-07-03 18:43:34', '2024-07-16 11:25:49', 1, 1, 'mochamad.seliratno@electronic-city.co.id'),
(34, '19070256', 'b626ebe3027038962d7acec9ebe4f1bc', 1, '2024-07-03 18:43:34', '2024-07-16 11:25:49', 1, 1, 'mochamad.seliratno@electronic-city.co.id'),
(35, '22120287', 'b626ebe3027038962d7acec9ebe4f1bc', 1, '2024-07-03 18:43:34', '2024-07-16 11:25:49', 1, 1, 'mochamad.seliratno@electronic-city.co.id'),
(36, '23110328', 'b626ebe3027038962d7acec9ebe4f1bc', 1, '2024-07-03 18:43:34', '2024-07-16 11:25:49', 1, 1, 'mochamad.seliratno@electronic-city.co.id'),
(37, '24060156', 'b626ebe3027038962d7acec9ebe4f1bc', 1, '2024-07-03 18:43:34', '2024-07-16 11:25:49', 1, 1, 'mochamad.seliratno@electronic-city.co.id'),
(38, '22060149', 'b626ebe3027038962d7acec9ebe4f1bc', 1, '2024-07-03 18:43:34', '2024-07-16 11:25:49', 1, 1, 'mochamad.seliratno@electronic-city.co.id'),
(39, '23050125', 'b626ebe3027038962d7acec9ebe4f1bc', 1, '2024-07-03 18:43:34', '2024-07-16 11:25:49', 1, 1, 'mochamad.seliratno@electronic-city.co.id'),
(40, '1308767', 'b626ebe3027038962d7acec9ebe4f1bc', 1, '2024-07-03 18:43:34', '2024-07-16 11:25:49', 1, 1, 'mochamad.seliratno@electronic-city.co.id'),
(41, '1211618', 'b626ebe3027038962d7acec9ebe4f1bc', 1, '2024-07-03 18:43:34', '2024-07-16 11:25:49', 1, 1, 'mochamad.seliratno@electronic-city.co.id'),
(42, '23050124', 'b626ebe3027038962d7acec9ebe4f1bc', 1, '2024-07-03 18:43:34', '2024-07-16 11:25:49', 1, 1, 'mochamad.seliratno@electronic-city.co.id'),
(43, '23030041', 'b626ebe3027038962d7acec9ebe4f1bc', 1, '2024-07-03 18:43:34', '2024-07-16 11:25:49', 1, 1, 'mochamad.seliratno@electronic-city.co.id'),
(44, '23030042', 'b626ebe3027038962d7acec9ebe4f1bc', 1, '2024-07-03 18:43:34', '2024-07-16 11:25:49', 1, 1, 'mochamad.seliratno@electronic-city.co.id'),
(45, 'Approver 1 QE', 'b626ebe3027038962d7acec9ebe4f1bc', 1, '2024-07-03 18:43:34', '2024-07-16 11:25:49', 1, 1, 'mochamad.seliratno@electronic-city.co.id'),
(46, 'Approver 2 QE', 'b626ebe3027038962d7acec9ebe4f1bc', 1, '2024-07-03 18:43:34', '2024-07-16 11:25:49', 1, 1, 'mochamad.seliratno@electronic-city.co.id'),
(47, 'Approver 3 QE', 'b626ebe3027038962d7acec9ebe4f1bc', 1, '2024-07-03 18:43:34', '2024-07-16 11:25:49', 1, 1, 'mochamad.seliratno@electronic-city.co.id'),
(48, 'Approver 4 QE', 'b626ebe3027038962d7acec9ebe4f1bc', 1, '2024-07-03 18:43:34', '2024-07-16 11:25:49', 1, 1, 'mochamad.seliratno@electronic-city.co.id'),
(49, 'Approver 5 QE', 'b626ebe3027038962d7acec9ebe4f1bc', 1, '2024-07-03 18:43:34', '2024-07-16 11:25:49', 1, 1, 'mochamad.seliratno@electronic-city.co.id'),
(50, 'Approver 6 QE', 'b626ebe3027038962d7acec9ebe4f1bc', 1, '2024-07-03 18:43:34', '2024-07-16 11:25:49', 1, 1, 'mochamad.seliratno@electronic-city.co.id'),
(51, 'Approver 7 QE', 'b626ebe3027038962d7acec9ebe4f1bc', 1, '2024-07-03 18:43:34', '2024-07-16 11:25:49', 1, 1, 'mochamad.seliratno@electronic-city.co.id'),
(52, 'Approver 8 QE', 'b626ebe3027038962d7acec9ebe4f1bc', 1, '2024-07-03 18:43:34', '2024-07-16 11:25:49', 1, 1, 'mochamad.seliratno@electronic-city.co.id'),
(53, 'Approver 9 QE', 'b626ebe3027038962d7acec9ebe4f1bc', 1, '2024-07-03 18:43:34', '2024-07-16 11:25:49', 1, 1, 'mochamad.seliratno@electronic-city.co.id'),
(54, 'Approver 10 QE', 'b626ebe3027038962d7acec9ebe4f1bc', 1, '2024-07-03 18:43:34', '2024-07-16 11:25:49', 1, 1, 'mochamad.seliratno@electronic-city.co.id'),
(55, 'approver 1 lpbj', 'b626ebe3027038962d7acec9ebe4f1bc', 1, '2024-07-03 18:43:34', '2024-07-16 16:41:15', 1, 1, 'mochamad.seliratno@electronic-city.co.id'),
(56, 'approver 2 lpbj', 'b626ebe3027038962d7acec9ebe4f1bc', 1, '2024-07-03 18:43:34', '2024-07-16 16:41:20', 1, 1, 'mochamad.seliratno@electronic-city.co.id'),
(57, 'admin1lpbj', 'b626ebe3027038962d7acec9ebe4f1bc', 1, '2024-07-03 18:43:34', '2024-07-16 16:39:24', 1, 1, 'mochamad.seliratno@electronic-city.co.id'),
(58, 'admin1proc', 'b626ebe3027038962d7acec9ebe4f1bc', 1, '2024-07-03 18:43:34', '2024-07-16 16:39:29', 1, 1, 'mochamad.seliratno@electronic-city.co.id'),
(59, 'admin2lpbj', 'b626ebe3027038962d7acec9ebe4f1bc', 1, NULL, '2024-07-16 16:42:17', NULL, NULL, 'mochamad.seliratno@electronic-city.co.id'),
(60, 'admin3lpbj', 'b626ebe3027038962d7acec9ebe4f1bc', 1, NULL, '2024-07-16 16:42:17', NULL, NULL, 'mochamad.seliratno@electronic-city.co.id'),
(61, 'admin4lpbj', 'b626ebe3027038962d7acec9ebe4f1bc', 1, NULL, '2024-07-16 16:42:17', NULL, NULL, 'mochamad.seliratno@electronic-city.co.id');

-- --------------------------------------------------------

--
-- Table structure for table `s_draftlpbj`
--

CREATE TABLE `s_draftlpbj` (
  `id` int(11) NOT NULL,
  `userid` int(11) DEFAULT NULL,
  `articlecode` varchar(255) DEFAULT NULL,
  `remark` varchar(255) DEFAULT NULL,
  `qty` int(11) DEFAULT NULL,
  `sitecode` varchar(255) DEFAULT NULL,
  `accassign` varchar(255) DEFAULT NULL,
  `gl` varchar(255) DEFAULT NULL,
  `costcenter` varchar(255) DEFAULT NULL,
  `order` varchar(255) DEFAULT NULL,
  `asset` varchar(255) DEFAULT NULL,
  `keterangan` varchar(255) DEFAULT NULL,
  `gambar` varchar(255) DEFAULT NULL,
  `isdeleted` int(11) DEFAULT 0,
  `created_at` datetime DEFAULT NULL,
  `modified_at` datetime DEFAULT NULL ON UPDATE current_timestamp(),
  `created_by` int(11) DEFAULT NULL,
  `modified_by` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

--
-- Dumping data for table `s_draftlpbj`
--

INSERT INTO `s_draftlpbj` (`id`, `userid`, `articlecode`, `remark`, `qty`, `sitecode`, `accassign`, `gl`, `costcenter`, `order`, `asset`, `keterangan`, `gambar`, `isdeleted`, `created_at`, `modified_at`, `created_by`, `modified_by`) VALUES
(1, 1, 'ACRY JDWL HOMDEL', 'lalala', 3, '1000', 'K', '600001', 'E008100001', 'MATOS-C5', NULL, 'lalala', NULL, 1, '2024-07-16 08:54:30', '2024-07-16 17:13:20', 1, 57),
(2, 1, 'ADVANCE', 'lilili', 3, '1000', 'K', '378928', 'E008100029', 'HR-C3', NULL, 'lilili', NULL, 1, '2024-07-16 08:57:22', '2024-07-16 17:13:20', 1, 57),
(3, 1, 'ALARM KAMERA', 'hahaha', 2, '1000', 'K', '600001', 'E008100001', 'MATOS-C5', NULL, 'hahaha', NULL, 1, '2024-07-16 08:57:55', '2024-07-16 17:13:20', 1, 57),
(4, 57, 'ACRY JDWL HOMDEL', 'lalala', 3, '1000', 'K', '600001', 'E008100001', 'MATOS-C5', NULL, 'lalala', NULL, 1, NULL, '2024-07-16 17:13:20', NULL, 57),
(5, 57, 'ADVANCE', 'lilili', 3, '1000', 'K', '378928', 'E008100029', 'HR-C3', NULL, 'lilili', NULL, 1, NULL, '2024-07-16 17:13:20', NULL, 57),
(6, 57, 'ALARM KAMERA', 'hahaha', 2, '1000', 'K', '600001', 'E008100001', 'MATOS-C5', NULL, 'hahaha', NULL, 1, NULL, '2024-07-16 17:13:20', NULL, 57),
(7, 57, 'ACRY JDWL HOMDEL', 'blabla', 3, '1000', 'K', '600001', 'E008100001', 'MATOS-C5', NULL, 'lalala', NULL, 1, NULL, '2024-07-16 17:14:19', NULL, 57),
(8, 57, 'ADVANCE', 'lala', 3, '1000', 'K', '378928', 'E008100029', 'HR-C3', NULL, 'lilili', NULL, 1, NULL, '2024-07-16 17:14:19', NULL, 57),
(9, 57, 'ALARM KAMERA', 'hihi', 2, '1000', 'K', '600001', 'E008100001', 'MATOS-C5', NULL, 'hahaha', NULL, 1, NULL, '2024-07-16 17:14:19', NULL, 57);

-- --------------------------------------------------------

--
-- Table structure for table `s_draftqe`
--

CREATE TABLE `s_draftqe` (
  `id` int(11) NOT NULL,
  `dtlid` int(11) DEFAULT NULL,
  `satuan` float DEFAULT NULL,
  `remarkqa` varchar(255) DEFAULT NULL,
  `attachment` varchar(255) DEFAULT NULL,
  `vendorcode` varchar(255) DEFAULT NULL,
  `franco` varchar(255) DEFAULT NULL,
  `ispkp` int(11) DEFAULT NULL,
  `term` varchar(255) DEFAULT NULL,
  `top` varchar(255) DEFAULT NULL,
  `contactperson` varchar(255) DEFAULT NULL,
  `notelp` varchar(255) DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `modified_at` datetime DEFAULT NULL ON UPDATE current_timestamp(),
  `created_by` int(11) DEFAULT NULL,
  `modified_by` int(11) DEFAULT NULL,
  `ispilih` int(11) DEFAULT NULL,
  `remark` varchar(255) DEFAULT NULL,
  `isdeleted` int(11) DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

--
-- Dumping data for table `s_draftqe`
--

INSERT INTO `s_draftqe` (`id`, `dtlid`, `satuan`, `remarkqa`, `attachment`, `vendorcode`, `franco`, `ispkp`, `term`, `top`, `contactperson`, `notelp`, `created_at`, `modified_at`, `created_by`, `modified_by`, `ispilih`, `remark`, `isdeleted`) VALUES
(1, 1, 10000, 'lalala', '1_300006.pdf', '300006', 'sadwdawd', 1, 'awdwadwa', 'awdwadwa', 'adwadw', '0823467812651', '2024-07-16 10:42:56', '2024-07-16 18:06:01', 58, NULL, 1, 'hahaha', 1),
(2, 2, 3000, 'asdawdqqwe', '2_300006.pdf', '300006', 'qweqweqwe', 1, 'qweqweqweqwe', 'qweerwewerwr', 'qweqweqweqwe', '89023476273', '2024-07-16 10:42:56', '2024-07-16 18:06:01', 58, NULL, 1, 'hahaha', 1),
(3, 1, 10000, 'QA jkls', '1_300004.pdf', '300004', 'test', 0, 'term', 'test', 'ratno', '085280205295', '2024-07-16 10:58:46', '2024-07-16 18:06:01', 58, NULL, 0, 'Remaektotal', 1),
(4, 2, 20000, 'QA laslkjd', '2_300004.pdf', '300004', 'test', 0, 'term', 'test', 'ratno', '085280205295', '2024-07-16 10:58:46', '2024-07-16 18:06:01', 58, NULL, 0, 'Remaektotal', 1),
(5, 1, 10000, NULL, '1_300005.pdf', '300005', 'teees', 1, 'term tes', 'toptest', 'lalala', '08912367812', '2024-07-16 11:05:53', '2024-07-16 18:06:01', 58, NULL, 0, 'ramerk test', 1),
(6, 2, 12000, NULL, '1_300005.pdf', '300005', 'teees', 1, 'term tes', 'toptest', 'lalala', '08912367812', '2024-07-16 11:05:53', '2024-07-16 18:06:01', 58, NULL, 0, 'ramerk test', 1),
(7, 3, 2500000, 'barang mahal', '1_300008.pdf', '300008', 'testfranco', 1, 'term test', 'top test', 'chunz', '082346782388', '2024-07-16 11:07:38', '2024-07-16 18:12:51', 58, NULL, 1, 'remark tes', 1),
(8, 3, 2400000, 'mahal', '1_300015.pdf', '300015', 'lalala', 1, 'termlala', 'lilili', 'haha', '082346781762', '2024-07-16 11:08:25', '2024-07-16 18:12:51', 58, NULL, 0, 'remakr', 1),
(9, 3, 2499000, 'remarklala', '1_300001.pdf', '300001', 'franco', 1, 'term coba', 'top remark', 'person', '08236781272', '2024-07-16 11:12:37', '2024-07-16 18:12:51', 58, NULL, 0, 'remark', 1),
(10, 7, 15000, 'lalala', '3_1000.pdf', '1000', 'lebihan', 1, 'term', 'top', 'person', '083467287618', '2024-07-16 11:55:08', '2024-07-16 19:04:49', 58, NULL, 1, 'leibh murah', 1),
(11, 8, 12000, 'yeyeye', '3_1000.pdf', '1000', 'lebihan', 1, 'term', 'top', 'person', '083467287618', '2024-07-16 11:55:08', '2024-07-16 19:04:49', 58, NULL, 1, 'leibh murah', 1),
(12, 9, 13000, 'lololo', '3_1000.pdf', '1000', 'lebihan', 1, 'term', 'top', 'person', '083467287618', '2024-07-16 11:55:08', '2024-07-16 19:04:49', 58, NULL, 1, 'leibh murah', 1),
(13, 7, 14900, 'remarkqa1', '3_300047.pdf', '300047', 'franco yes', 1, 'term yes', 'topyes', 'personyes', '08236781267', '2024-07-16 12:00:33', '2024-07-16 19:04:49', 58, NULL, 0, 'grup sama', 1),
(14, 8, 13000, 'remarkqa2', '3_300047.pdf', '300047', 'franco yes', 1, 'term yes', 'topyes', 'personyes', '08236781267', '2024-07-16 12:00:33', '2024-07-16 19:04:49', 58, NULL, 0, 'grup sama', 1),
(15, 9, 12900, 'remarkqa3', '3_300047.pdf', '300047', 'franco yes', 1, 'term yes', 'topyes', 'personyes', '08236781267', '2024-07-16 12:00:33', '2024-07-16 19:04:49', 58, NULL, 0, 'grup sama', 1),
(16, 7, 13000, 'barang lain', '3_300025.pdf', '300025', 'cobain', 1, 'termterm', 'toptop', 'kontak', '0823476828736', '2024-07-16 12:04:04', '2024-07-16 19:04:49', 58, NULL, 0, 'remark murah', 1),
(17, 8, 12000, 'merk abal', '3_300025.pdf', '300025', 'cobain', 1, 'termterm', 'toptop', 'kontak', '0823476828736', '2024-07-16 12:04:04', '2024-07-16 19:04:49', 58, NULL, 0, 'remark murah', 1),
(18, 9, 5000, 'barang kw', '3_300025.pdf', '300025', 'cobain', 1, 'termterm', 'toptop', 'kontak', '0823476828736', '2024-07-16 12:04:04', '2024-07-16 19:04:49', 58, NULL, 0, 'remark murah', 1);

-- --------------------------------------------------------

--
-- Stand-in structure for view `vw_getdraftlpbj`
-- (See below for the actual view)
--
CREATE TABLE `vw_getdraftlpbj` (
`id` int(11)
,`userid` int(11)
,`articlecode` varchar(255)
,`articlename` varchar(255)
,`remark` varchar(255)
,`qty` int(11)
,`uom` varchar(255)
,`sitecode` varchar(255)
,`sitename` varchar(255)
,`accassign` varchar(15)
,`gl` varchar(255)
,`costcenter` varchar(255)
,`order` varchar(255)
,`asset` varchar(255)
,`keterangan` varchar(255)
,`gambar` varchar(255)
);

-- --------------------------------------------------------

--
-- Stand-in structure for view `vw_getdraftqe`
-- (See below for the actual view)
--
CREATE TABLE `vw_getdraftqe` (
`id` int(11)
,`dtlid` int(11)
,`vendorcode` varchar(255)
,`vendorname` varchar(100)
,`ispilih` int(11)
,`articlecode` varchar(255)
,`qty` int(11)
,`satuan` float
,`total` double
,`remarkqa` varchar(255)
,`attachment` varchar(255)
,`userid` int(11)
);

-- --------------------------------------------------------

--
-- Stand-in structure for view `vw_getpegawai`
-- (See below for the actual view)
--
CREATE TABLE `vw_getpegawai` (
`pegawaiid` int(11)
,`userid` int(11)
,`satkerid` int(11)
,`nik` varchar(255)
,`name` varchar(255)
,`jabatanname` varchar(255)
,`unitname` varchar(255)
,`divname` varchar(255)
,`depname` varchar(255)
,`userrole` varchar(255)
,`email` varchar(255)
);

-- --------------------------------------------------------

--
-- Stand-in structure for view `vw_getsatker`
-- (See below for the actual view)
--
CREATE TABLE `vw_getsatker` (
`unitkerjaid` int(11)
,`unitcode` varchar(255)
,`unitname` varchar(255)
,`direktoratid` int(11)
,`dircode` varchar(255)
,`dirname` varchar(255)
,`divisiid` int(11)
,`divcode` varchar(255)
,`divname` varchar(255)
,`departmentid` int(11)
,`depcode` varchar(255)
,`depname` varchar(255)
,`seksiid` int(11)
,`sekcode` varchar(255)
,`sekname` varchar(255)
,`subseksiid` int(11)
,`subcode` varchar(255)
,`subname` varchar(255)
);

-- --------------------------------------------------------

--
-- Stand-in structure for view `vw_getuser`
-- (See below for the actual view)
--
CREATE TABLE `vw_getuser` (
`iduser` int(11)
,`idgroup` int(11)
,`idpegawai` int(11)
,`username` varchar(255)
,`password` varchar(255)
,`password2` varchar(32)
,`name` varchar(255)
,`isaktif` int(11)
,`usergroupname` varchar(255)
,`depname` varchar(255)
,`divname` varchar(255)
,`email` varchar(255)
,`emailapprove` varchar(255)
);

-- --------------------------------------------------------

--
-- Stand-in structure for view `vw_historylpbj`
-- (See below for the actual view)
--
CREATE TABLE `vw_historylpbj` (
`hdrid` int(11)
,`userid` int(11)
,`statusid` int(11)
,`divname` varchar(255)
,`status` varchar(255)
,`nolpbj` varchar(255)
,`companycode` varchar(255)
,`depname` varchar(255)
,`tglpermintaan` varchar(76)
,`description` varchar(255)
,`note` varchar(255)
,`isqe` int(11)
,`workflow` varchar(255)
,`reason` varchar(255)
,`emailpengaju` varchar(255)
,`namapengaju` varchar(255)
);

-- --------------------------------------------------------

--
-- Stand-in structure for view `vw_historylpbjdtl`
-- (See below for the actual view)
--
CREATE TABLE `vw_historylpbjdtl` (
`hdrid` int(11)
,`dtlid` int(11)
,`nolpbj` varchar(255)
,`companycode` varchar(255)
,`depname` varchar(255)
,`tglpermintaan` varchar(76)
,`description` varchar(255)
,`articlecode` varchar(255)
,`articlename` varchar(255)
,`remark` varchar(255)
,`qty` int(11)
,`uom` varchar(255)
,`sitecode` varchar(255)
,`accassign` varchar(255)
,`gl` varchar(255)
,`costcenter` varchar(255)
,`order` varchar(255)
,`asset` varchar(255)
,`keterangan` varchar(255)
,`gambar` varchar(255)
,`isqe` int(11)
);

-- --------------------------------------------------------

--
-- Stand-in structure for view `vw_historyqe`
-- (See below for the actual view)
--
CREATE TABLE `vw_historyqe` (
`hdrid` int(11)
,`lpbjid` int(11)
,`noqe` varchar(255)
,`reason` varchar(255)
,`statusid` int(11)
,`created_at` datetime
,`statusname` varchar(255)
,`workflow` varchar(255)
);

-- --------------------------------------------------------

--
-- Stand-in structure for view `vw_historyqedtl`
-- (See below for the actual view)
--
CREATE TABLE `vw_historyqedtl` (
`id` int(11)
,`hdrid` int(11)
,`draftid` int(11)
,`created_at` datetime
,`modified_at` datetime
,`created_by` int(11)
,`modified_by` int(11)
,`isdeleted` int(11)
);

-- --------------------------------------------------------

--
-- Stand-in structure for view `vw_usermenu`
-- (See below for the actual view)
--
CREATE TABLE `vw_usermenu` (
`userid` int(11)
,`idgroup` int(11)
,`menuid` int(11)
,`username` varchar(255)
,`menuname` varchar(255)
,`deskripsi` varchar(255)
,`linkhref` varchar(255)
,`icon` varchar(255)
,`color` varchar(255)
);

-- --------------------------------------------------------

--
-- Stand-in structure for view `vw_vendordtl`
-- (See below for the actual view)
--
CREATE TABLE `vw_vendordtl` (
`hdrid` int(11)
,`vendorcode` varchar(255)
,`articlecode` varchar(255)
,`qty` int(11)
,`satuan` float
,`total` double
,`remarkqa` varchar(255)
);

-- --------------------------------------------------------

--
-- Stand-in structure for view `vw_vendorhdr`
-- (See below for the actual view)
--
CREATE TABLE `vw_vendorhdr` (
`hdrid` int(11)
,`vendorcode` varchar(255)
,`vendorname` varchar(100)
,`pilih` int(11)
);

-- --------------------------------------------------------

--
-- Structure for view `vw_getdraftlpbj`
--
DROP TABLE IF EXISTS `vw_getdraftlpbj`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `vw_getdraftlpbj`  AS SELECT `a`.`id` AS `id`, `a`.`userid` AS `userid`, `a`.`articlecode` AS `articlecode`, `b`.`productname` AS `articlename`, `a`.`remark` AS `remark`, `a`.`qty` AS `qty`, `b`.`uom` AS `uom`, `a`.`sitecode` AS `sitecode`, `c`.`name1` AS `sitename`, CASE WHEN `a`.`accassign` = 'K' THEN 'K - COST CENTER' WHEN `a`.`accassign` = 'A' THEN 'Y - ASSET' END AS `accassign`, `a`.`gl` AS `gl`, `a`.`costcenter` AS `costcenter`, `a`.`order` AS `order`, `a`.`asset` AS `asset`, `a`.`keterangan` AS `keterangan`, `a`.`gambar` AS `gambar` FROM ((`s_draftlpbj` `a` left join `api_article` `b` on(`b`.`productcode` = `a`.`articlecode`)) left join `api_site` `c` on(`c`.`sitecode` = `a`.`sitecode`)) WHERE `a`.`isdeleted` = 0 ;

-- --------------------------------------------------------

--
-- Structure for view `vw_getdraftqe`
--
DROP TABLE IF EXISTS `vw_getdraftqe`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `vw_getdraftqe`  AS SELECT `a`.`id` AS `id`, `a`.`dtlid` AS `dtlid`, `a`.`vendorcode` AS `vendorcode`, `c`.`name` AS `vendorname`, `a`.`ispilih` AS `ispilih`, `b`.`articlecode` AS `articlecode`, `b`.`qty` AS `qty`, `a`.`satuan` AS `satuan`, `a`.`satuan`* `b`.`qty` AS `total`, `a`.`remarkqa` AS `remarkqa`, `a`.`attachment` AS `attachment`, `a`.`created_by` AS `userid` FROM ((`s_draftqe` `a` left join `m_lpbj_dtl` `b` on(`b`.`id` = `a`.`dtlid`)) left join `api_vendor` `c` on(`c`.`supplierCode` = `a`.`vendorcode`)) WHERE `a`.`isdeleted` = 0 ORDER BY `a`.`vendorcode` ASC ;

-- --------------------------------------------------------

--
-- Structure for view `vw_getpegawai`
--
DROP TABLE IF EXISTS `vw_getpegawai`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `vw_getpegawai`  AS SELECT DISTINCT `a`.`id` AS `pegawaiid`, `a`.`userid` AS `userid`, `a`.`satkerid` AS `satkerid`, `f`.`username` AS `nik`, `a`.`nama` AS `name`, `c`.`name` AS `jabatanname`, `b`.`unitname` AS `unitname`, `b`.`divname` AS `divname`, `b`.`depname` AS `depname`, `h`.`usergroupname` AS `userrole`, `f`.`email` AS `email` FROM (((((((`m_pegawai` `a` left join `vw_getsatker` `b` on(`b`.`subseksiid` = `a`.`satkerid`)) left join `m_jabatan` `c` on(`c`.`id` = `a`.`jabatanid`)) left join `m_level` `d` on(`d`.`id` = `a`.`levelid`)) left join `m_lokasi` `e` on(`e`.`id` = `a`.`lokasiid`)) left join `m_users` `f` on(`f`.`id` = `a`.`userid`)) left join `m_usergroup` `g` on(`g`.`iduser` = `f`.`id`)) left join `m_group` `h` on(`h`.`id` = `g`.`idgroup`)) ;

-- --------------------------------------------------------

--
-- Structure for view `vw_getsatker`
--
DROP TABLE IF EXISTS `vw_getsatker`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `vw_getsatker`  AS SELECT `f`.`unitkerjaid` AS `unitkerjaid`, `a`.`code` AS `unitcode`, `a`.`name` AS `unitname`, `f`.`direktoratid` AS `direktoratid`, `b`.`code` AS `dircode`, `b`.`name` AS `dirname`, `f`.`divisiid` AS `divisiid`, `c`.`code` AS `divcode`, `c`.`name` AS `divname`, `f`.`departmentid` AS `departmentid`, `d`.`code` AS `depcode`, `d`.`name` AS `depname`, `f`.`seksiid` AS `seksiid`, `e`.`code` AS `sekcode`, `e`.`name` AS `sekname`, `f`.`id` AS `subseksiid`, `f`.`code` AS `subcode`, `f`.`name` AS `subname` FROM (((((`m_unitkerja` `a` left join `m_direktorat` `b` on(`b`.`unitkerjaid` = `a`.`id`)) left join `m_divisi` `c` on(`c`.`direktoratid` = `b`.`id`)) left join `m_department` `d` on(`d`.`divisiid` = `c`.`id`)) left join `m_seksi` `e` on(`e`.`departmentid` = `d`.`id`)) left join `m_subseksi` `f` on(`f`.`seksiid` = `e`.`id`)) ;

-- --------------------------------------------------------

--
-- Structure for view `vw_getuser`
--
DROP TABLE IF EXISTS `vw_getuser`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `vw_getuser`  AS SELECT DISTINCT `a`.`id` AS `iduser`, `c`.`id` AS `idgroup`, `d`.`id` AS `idpegawai`, `a`.`username` AS `username`, `a`.`password` AS `password`, md5('chunz') AS `password2`, `d`.`nama` AS `name`, `a`.`isaktif` AS `isaktif`, `c`.`usergroupname` AS `usergroupname`, `e`.`depname` AS `depname`, `e`.`divname` AS `divname`, `a`.`email` AS `email`, `g`.`email` AS `emailapprove` FROM ((((((`m_users` `a` left join `m_usergroup` `b` on(`b`.`iduser` = `a`.`id`)) left join `m_group` `c` on(`c`.`id` = `b`.`idgroup`)) left join `m_pegawai` `d` on(`d`.`userid` = `a`.`id`)) left join `vw_getsatker` `e` on(`e`.`subseksiid` = `d`.`satkerid`)) left join `m_approver` `f` on(`f`.`userid` = `a`.`id`)) left join `m_users` `g` on(`g`.`id` = `f`.`approveid`)) WHERE `a`.`isaktif` = 1 ;

-- --------------------------------------------------------

--
-- Structure for view `vw_historylpbj`
--
DROP TABLE IF EXISTS `vw_historylpbj`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `vw_historylpbj`  AS SELECT DISTINCT `a`.`id` AS `hdrid`, `a`.`userid` AS `userid`, `a`.`status` AS `statusid`, `c`.`divname` AS `divname`, `d`.`name` AS `status`, `a`.`nolpbj` AS `nolpbj`, `a`.`companycode` AS `companycode`, `c`.`depname` AS `depname`, date_format(cast(`a`.`created_at` as date),'%W, %d-%m-%Y') AS `tglpermintaan`, `a`.`description` AS `description`, `a`.`note` AS `note`, `a`.`isqe` AS `isqe`, CASE WHEN `a`.`workflow` is null THEN `d`.`name` ELSE `a`.`workflow` END AS `workflow`, `a`.`reason` AS `reason`, `c`.`email` AS `emailpengaju`, `c`.`name` AS `namapengaju` FROM (((`m_lpbj_hdr` `a` left join `m_lpbj_dtl` `b` on(`b`.`hdrid` = `a`.`id`)) left join `vw_getpegawai` `c` on(`c`.`userid` = `a`.`userid`)) left join `m_status` `d` on(`d`.`id` = `a`.`status`)) WHERE `a`.`isdeleted` = 0 ;

-- --------------------------------------------------------

--
-- Structure for view `vw_historylpbjdtl`
--
DROP TABLE IF EXISTS `vw_historylpbjdtl`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `vw_historylpbjdtl`  AS SELECT `a`.`id` AS `hdrid`, `b`.`id` AS `dtlid`, `a`.`nolpbj` AS `nolpbj`, `a`.`companycode` AS `companycode`, `c`.`depname` AS `depname`, date_format(cast(`a`.`created_at` as date),'%W, %d-%m-%Y') AS `tglpermintaan`, `a`.`description` AS `description`, `b`.`articlecode` AS `articlecode`, `d`.`productname` AS `articlename`, `b`.`remark` AS `remark`, `b`.`qty` AS `qty`, `d`.`uom` AS `uom`, `b`.`sitecode` AS `sitecode`, `b`.`accassign` AS `accassign`, `b`.`gl` AS `gl`, `b`.`costcenter` AS `costcenter`, `b`.`order` AS `order`, `b`.`asset` AS `asset`, `b`.`keterangan` AS `keterangan`, `b`.`gambar` AS `gambar`, `b`.`isqe` AS `isqe` FROM (((`m_lpbj_hdr` `a` left join `m_lpbj_dtl` `b` on(`b`.`hdrid` = `a`.`id`)) left join `vw_getpegawai` `c` on(`c`.`userid` = `a`.`userid`)) left join `api_article` `d` on(`d`.`productcode` = `b`.`articlecode`)) WHERE `a`.`isdeleted` = 0 ;

-- --------------------------------------------------------

--
-- Structure for view `vw_historyqe`
--
DROP TABLE IF EXISTS `vw_historyqe`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `vw_historyqe`  AS SELECT `a`.`id` AS `hdrid`, `a`.`lpbjid` AS `lpbjid`, `a`.`noqe` AS `noqe`, `a`.`reason` AS `reason`, `a`.`status` AS `statusid`, `a`.`created_at` AS `created_at`, `b`.`name` AS `statusname`, CASE WHEN `a`.`workflow` is null THEN `b`.`name` ELSE `a`.`workflow` END AS `workflow` FROM (`m_qe_hdr` `a` left join `m_status` `b` on(`b`.`id` = `a`.`status`)) ;

-- --------------------------------------------------------

--
-- Structure for view `vw_historyqedtl`
--
DROP TABLE IF EXISTS `vw_historyqedtl`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `vw_historyqedtl`  AS SELECT `m_qe_dtl`.`id` AS `id`, `m_qe_dtl`.`hdrid` AS `hdrid`, `m_qe_dtl`.`draftid` AS `draftid`, `m_qe_dtl`.`created_at` AS `created_at`, `m_qe_dtl`.`modified_at` AS `modified_at`, `m_qe_dtl`.`created_by` AS `created_by`, `m_qe_dtl`.`modified_by` AS `modified_by`, `m_qe_dtl`.`isdeleted` AS `isdeleted` FROM `m_qe_dtl` ;

-- --------------------------------------------------------

--
-- Structure for view `vw_usermenu`
--
DROP TABLE IF EXISTS `vw_usermenu`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `vw_usermenu`  AS SELECT `a`.`id` AS `userid`, `b`.`idgroup` AS `idgroup`, `c`.`id` AS `menuid`, `a`.`username` AS `username`, `c`.`name` AS `menuname`, `c`.`deskripsi` AS `deskripsi`, `c`.`linkhref` AS `linkhref`, `c`.`icon` AS `icon`, `c`.`color` AS `color` FROM ((`m_users` `a` left join `m_usergroup` `b` on(`b`.`iduser` = `a`.`id`)) left join `m_menu` `c` on(`c`.`id` = `b`.`menuid`)) ;

-- --------------------------------------------------------

--
-- Structure for view `vw_vendordtl`
--
DROP TABLE IF EXISTS `vw_vendordtl`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `vw_vendordtl`  AS SELECT DISTINCT `c`.`hdrid` AS `hdrid`, `a`.`vendorcode` AS `vendorcode`, `b`.`articlecode` AS `articlecode`, `b`.`qty` AS `qty`, `a`.`satuan` AS `satuan`, `b`.`qty`* `a`.`satuan` AS `total`, `a`.`remarkqa` AS `remarkqa` FROM ((`s_draftqe` `a` left join `m_lpbj_dtl` `b` on(`b`.`id` = `a`.`dtlid`)) left join `m_qe_dtl` `c` on(`c`.`draftid` = `a`.`id`)) ;

-- --------------------------------------------------------

--
-- Structure for view `vw_vendorhdr`
--
DROP TABLE IF EXISTS `vw_vendorhdr`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `vw_vendorhdr`  AS SELECT DISTINCT `c`.`id` AS `hdrid`, `a`.`vendorcode` AS `vendorcode`, `d`.`name` AS `vendorname`, `a`.`ispilih` AS `pilih` FROM (((`s_draftqe` `a` left join `m_qe_dtl` `b` on(`b`.`draftid` = `a`.`id`)) left join `m_qe_hdr` `c` on(`c`.`id` = `b`.`hdrid`)) left join `api_vendor` `d` on(`d`.`supplierCode` = `a`.`vendorcode`)) ;

--
-- Indexes for dumped tables
--

--
-- Indexes for table `api_article`
--
ALTER TABLE `api_article`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `api_asset`
--
ALTER TABLE `api_asset`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `api_costcenter`
--
ALTER TABLE `api_costcenter`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `api_gl`
--
ALTER TABLE `api_gl`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `api_order`
--
ALTER TABLE `api_order`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `api_site`
--
ALTER TABLE `api_site`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `api_vendor`
--
ALTER TABLE `api_vendor`
  ADD PRIMARY KEY (`id`) USING BTREE,
  ADD UNIQUE KEY `Index 2` (`supplierCode`,`companyCode`) USING BTREE;

--
-- Indexes for table `m_approver`
--
ALTER TABLE `m_approver`
  ADD PRIMARY KEY (`userid`,`approveid`);

--
-- Indexes for table `m_department`
--
ALTER TABLE `m_department`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `m_direktorat`
--
ALTER TABLE `m_direktorat`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `m_divisi`
--
ALTER TABLE `m_divisi`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `m_group`
--
ALTER TABLE `m_group`
  ADD PRIMARY KEY (`id`) USING BTREE;

--
-- Indexes for table `m_jabatan`
--
ALTER TABLE `m_jabatan`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `m_level`
--
ALTER TABLE `m_level`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `m_lokasi`
--
ALTER TABLE `m_lokasi`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `m_lpbj_dtl`
--
ALTER TABLE `m_lpbj_dtl`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `m_lpbj_hdr`
--
ALTER TABLE `m_lpbj_hdr`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `m_menu`
--
ALTER TABLE `m_menu`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `m_pegawai`
--
ALTER TABLE `m_pegawai`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `m_qe_dtl`
--
ALTER TABLE `m_qe_dtl`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `m_qe_hdr`
--
ALTER TABLE `m_qe_hdr`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `m_seksi`
--
ALTER TABLE `m_seksi`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `m_status`
--
ALTER TABLE `m_status`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `m_subseksi`
--
ALTER TABLE `m_subseksi`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `m_unitkerja`
--
ALTER TABLE `m_unitkerja`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `m_usergroup`
--
ALTER TABLE `m_usergroup`
  ADD PRIMARY KEY (`iduser`,`idgroup`,`menuid`);

--
-- Indexes for table `m_userlogs`
--
ALTER TABLE `m_userlogs`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `m_users`
--
ALTER TABLE `m_users`
  ADD PRIMARY KEY (`id`) USING BTREE;

--
-- Indexes for table `s_draftlpbj`
--
ALTER TABLE `s_draftlpbj`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `s_draftqe`
--
ALTER TABLE `s_draftqe`
  ADD PRIMARY KEY (`id`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `api_article`
--
ALTER TABLE `api_article`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=411;

--
-- AUTO_INCREMENT for table `api_asset`
--
ALTER TABLE `api_asset`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;

--
-- AUTO_INCREMENT for table `api_costcenter`
--
ALTER TABLE `api_costcenter`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;

--
-- AUTO_INCREMENT for table `api_gl`
--
ALTER TABLE `api_gl`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=7;

--
-- AUTO_INCREMENT for table `api_order`
--
ALTER TABLE `api_order`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;

--
-- AUTO_INCREMENT for table `api_site`
--
ALTER TABLE `api_site`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;

--
-- AUTO_INCREMENT for table `api_vendor`
--
ALTER TABLE `api_vendor`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=1924;

--
-- AUTO_INCREMENT for table `m_department`
--
ALTER TABLE `m_department`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=102;

--
-- AUTO_INCREMENT for table `m_direktorat`
--
ALTER TABLE `m_direktorat`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=14;

--
-- AUTO_INCREMENT for table `m_divisi`
--
ALTER TABLE `m_divisi`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=42;

--
-- AUTO_INCREMENT for table `m_group`
--
ALTER TABLE `m_group`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=19;

--
-- AUTO_INCREMENT for table `m_jabatan`
--
ALTER TABLE `m_jabatan`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=19;

--
-- AUTO_INCREMENT for table `m_level`
--
ALTER TABLE `m_level`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=15;

--
-- AUTO_INCREMENT for table `m_lokasi`
--
ALTER TABLE `m_lokasi`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=108;

--
-- AUTO_INCREMENT for table `m_lpbj_dtl`
--
ALTER TABLE `m_lpbj_dtl`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=10;

--
-- AUTO_INCREMENT for table `m_lpbj_hdr`
--
ALTER TABLE `m_lpbj_hdr`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT for table `m_menu`
--
ALTER TABLE `m_menu`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT for table `m_pegawai`
--
ALTER TABLE `m_pegawai`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=62;

--
-- AUTO_INCREMENT for table `m_qe_dtl`
--
ALTER TABLE `m_qe_dtl`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=19;

--
-- AUTO_INCREMENT for table `m_qe_hdr`
--
ALTER TABLE `m_qe_hdr`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT for table `m_seksi`
--
ALTER TABLE `m_seksi`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=226;

--
-- AUTO_INCREMENT for table `m_status`
--
ALTER TABLE `m_status`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=13;

--
-- AUTO_INCREMENT for table `m_subseksi`
--
ALTER TABLE `m_subseksi`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=333;

--
-- AUTO_INCREMENT for table `m_unitkerja`
--
ALTER TABLE `m_unitkerja`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;

--
-- AUTO_INCREMENT for table `m_userlogs`
--
ALTER TABLE `m_userlogs`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `m_users`
--
ALTER TABLE `m_users`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=62;

--
-- AUTO_INCREMENT for table `s_draftlpbj`
--
ALTER TABLE `s_draftlpbj`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=10;

--
-- AUTO_INCREMENT for table `s_draftqe`
--
ALTER TABLE `s_draftqe`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=19;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
