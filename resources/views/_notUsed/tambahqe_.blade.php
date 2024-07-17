<!DOCTYPE html>
<html lang="en">

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link rel="icon" type="image/x-icon" href="img/logo.png">
    <title>Tambah Quotation</title>

    {{-- Style CSS --}}
    {{-- Vendor CSS Files --}}
    <link href="css/lpbj/main.css" rel="stylesheet">
    <link href="css/bootstrap.min.css" rel="stylesheet">
    <link href="css/dataTables.min.css" rel="stylesheet">
    <link href="vendor/bootstrap/css/bootstrap.min.css" rel="stylesheet">
    <link href="vendor/bootstrap-icons/bootstrap-icons.css" rel="stylesheet">
    <link href="vendor/aos/aos.css" rel="stylesheet">
    <link href="vendor/glightbox/css/glightbox.min.css" rel="stylesheet">
    <link href="vendor/swiper/swiper-bundle.min.css" rel="stylesheet">
    <link href="vendor/boxicons/css/boxicons.min.css" rel="stylesheet">
    <link href="vendor/quill/quill.snow.css" rel="stylesheet">
    <link href="vendor/quill/quill.bubble.css" rel="stylesheet">
    <link href="vendor/remixicon/remixicon.css" rel="stylesheet">
    <link href="https://fonts.googleapis.com/icon?family=Material+Icons" rel="stylesheet">

    <script src="https://cdn.jsdelivr.net/npm/jquery@3.7.0/dist/jquery.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.0.2/dist/js/bootstrap.min.js"></script>
    <link href="https://cdn.datatables.net/1.13.4/css/jquery.dataTables.min.css" rel="stylesheet">
    <script src="https://cdn.datatables.net/1.13.4/js/jquery.dataTables.min.js"></script>
</head>

<body class="index-page">

    {{-- NavBar --}}
    <header id="header" class="header grey-background d-flex flex-column">
        <i class="header-toggle d-xl-none bi bi-list"></i>

        <div class="profile-img">
            <img src="img/logo.jpg" alt="" class="img-fluid rounded-circle">
        </div>

        <a href="index.html" class="logo d-flex align-items-center justify-content-center">
            <h1 class="sitename">QUOTATION</h1>
        </a>

        <nav id="navmenu" class="navmenu">
            <ul>
                <li><a href="pengajuanqe" class="active"><i class="bi bi-clipboard2-plus navicon"></i>Pengajuan</a>
                </li>
                <li><a href="historyqe"><i class="bi bi-clock-history navicon"></i>History</a></li>
                <li><a href="portal"><i class="bi bi-backspace navicon"></i>Kembali</a></li>
            </ul>
        </nav>
    </header>
    {{-- /NavBar --}}

    <main class="main">
        {{-- FormPengajuan --}}
        <section class="about section">
            <div class="container" data-aos="fade-up" data-aos-delay="100">
                <div class="row gy-4 justify-content-center">
                    <div class="col-lg-12 content">
                        <h2 class="mb-1">Tambah Vendor Quotation</h2>
                    </div>
                </div>
                <br>
                <form class="form-horizontal form-label-left" action="draftqe" method="post"
                    enctype="multipart/form-data">
                    @csrf
                    <div class="row">
                        <div class="col-sm-6">
                            <button type="button" class="btn btn-outline-success btn-sm" data-bs-toggle="modal"
                                data-bs-target="#modalarticle">
                                Pilih Article
                            </button>
                            <br>
                            <br>
                        </div>
                        <div class="row">
                            <table class="table table-bordered" id="tbquotation">
                                <thead class="table-primary">
                                    <tr class="text-center">
                                        <th>No</th>
                                        <th>Article Code</th>
                                        <th>Qty</th>
                                        <th>Satuan</th>
                                        <th>Total</th>
                                        <th>Remarks QA</th>
                                    </tr>
                                </thead>
                                <tbody class="text-center">
                                    <tr>
                                        <td>1</td>
                                        <td>article1</td>
                                        <td><input type="number" disabled></td>
                                        <td><input type="number"></td>
                                        <td><input type="number" disabled></td>
                                        <td><input type="text"></td>
                                    </tr>
                                    <tr>
                                        <td>2</td>
                                        <td>article2</td>
                                        <td><input type="number" disabled></td>
                                        <td><input type="number"></td>
                                        <td><input type="number" disabled></td>
                                        <td><input type="text"></td>
                                    </tr>
                                </tbody>
                            </table>
                        </div>
                    </div>
                    <div class="row">
                        <div class="col-sm-2">
                            <label for="vendorCode">Vendor Code :</label>
                            <input class="form-control" type="text" name="vendorCode"
                                onclick="window.location.href='/carivendor'" required>
                        </div>
                        <div class="col-sm-6">
                            <label for="vendorName">Vendor Name :</label>
                            <input class="form-control" type="text" name="vendorName" autocomplete="off" readonly>
                        </div>
                    </div>
                    <br>
                    <div class="row">
                        <div class="col-sm-2">
                            <label for="totalQE">Total :</label>
                            <input type="text" class="form-control" name="totalQE" disabled>
                        </div>
                        <div class="col-sm-2">
                            <label for="ppnQE">PPN 11% :</label>
                            <input type="text" class="form-control" name="ppnQE" disabled>
                        </div>
                        <div class="col-sm-2">
                            <label for="grandtotalQE">Grand Total :</label>
                            <input type="text" class="form-control" name="grandtotalQE" disabled>
                        </div>
                    </div>
                    <br>
                    <div class="row">
                        <div class="col-sm-2">
                            <label for="franco">Franco :</label>
                            <input class="form-control" type="text" name="franco" autocomplete="off">
                            <br>
                        </div>
                        <div class="col-sm-2">
                            <label for="pkp">PKP/Non PKP :</label>
                            <select class="form-control" name="pkp" id="pkp">
                                <option value="1">PKP</option>
                                <option value="2">Non PKP</option>
                            </select>
                            <br>
                        </div>
                        <div class="col-sm-2">
                            <label for="term">Delivery Term :</label>
                            <input class="form-control" type="text" name="term" autocomplete="off">
                            <br>
                        </div>
                        <div class="col-sm-2">
                            <label for="top">T.O.P :</label>
                            <input class="form-control" type="text" name="top" autocomplete="off">
                            <br>
                        </div>
                    </div>
                    <div class="row">
                        <div class="col-sm-2">
                            <label for="contact">Contact Person :</label>
                            <input class="form-control" type="text" name="contact" autocomplete="off">
                            <br>
                        </div>
                        <div class="col-sm-2">
                            <label for="telp">Phone Number :</label>
                            <input class="form-control" type="text" name="telp" autocomplete="off">
                            <br>
                        </div>
                        <div class="col-sm-2">
                            <label for="pilih">Vendor Pilihan ?</label>
                            <select class="form-control" name="pilih" id="pilih">
                                <option value="0">Tidak</option>
                                <option value="1">Ya</option>
                            </select>
                            <br>
                        </div>
                    </div>
                    <div class="row">
                        <div class="col-sm-4">
                            <label for="remark">Remark :</label>
                            <input class="form-control" type="text" name="remark" autocomplete="off">
                            <br>
                        </div>
                    </div>
                    <div class="row">
                        <div class="col-sm-4">
                            <label for="attach">Attachment :</label>
                            <input class="form-control" type="file" name="attach">
                            <br>
                        </div>
                    </div>
                    <div class="modal-footer">
                        <a href="createqe" class="btn btn-secondary mr-2">Kembali</a>
                        <button type="submit" class="btn btn-primary">Simpan</button>
                    </div>
                </form>

            </div>
            <hr>
        </section>
        {{-- /FormPengajuan --}}
    </main>

    <footer id="footer" class="footer position-relative light-background">
        <div class="container">
            <div class="copyright text-center ">
                <p>© <span>Copyright</span> <strong class="px-1 sitename">Procurement Management System</strong>
                    <span>All Rights
                        Reserved</span>
                </p>
            </div>
        </div>
    </footer>

    {{-- ModalPilihArticle --}}
    <div class="modal fade" id="modalarticle" tabindex="-1" aria-hidden="true">
        <div class="modal-dialog modal-lg">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title" id="exampleModalLabel">Pilih Article</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                </div>
                <form action="./">
                    <div class="modal-body">
                        <table class="table table-bordered">
                            <thead class="table-primary">
                                <tr>
                                    <th class="text-center"><i class="bi bi-check2-square"></i></th>
                                    <th>No</th>
                                    <th>Article Code</th>
                                    <th>Article Name</th>
                                    <th>Remark</th>
                                    <th>Qty</th>
                                    <th>UoM</th>
                                </tr>
                            </thead>
                            <tbody>
                                <tr>
                                    <td class="text-center"><input type="checkbox" name="cek1"></td>
                                    <td>1</td>
                                    <td>articlekode</td>
                                    <td>articlenama</td>
                                    <td>remarkart</td>
                                    <td>123</td>
                                    <td>PC</td>
                                </tr>
                                <tr>
                                    <td class="text-center"><input type="checkbox" name="cek2"></td>
                                    <td>2</td>
                                    <td>articlekode2</td>
                                    <td>articlenama2</td>
                                    <td>remarkart2</td>
                                    <td>1232</td>
                                    <td>PC</td>
                                </tr>
                            </tbody>
                        </table>
                    </div>
                    <div class="modal-footer">
                        <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Batal</button>
                        <button type="submit" class="btn btn-primary">Pilih Article</button>
                    </div>
                </form>
            </div>
        </div>
    </div>
    {{-- /ModalPilihArticle --}}

    {{-- ScrollToTop --}}
    <a href="#" id="scroll-top" class="scroll-top d-flex align-items-center justify-content-center"><i
            class="bi bi-arrow-up-short"></i></a>

    {{-- VendorJS --}}
    {{-- MainJS --}}
    <script src="js/lpbj/main.js"></script>
    <script src="js/bootstrap.min.js"></script>
    <script src="js/bootstrap.bundle.min.js"></script>
    <script src="vendor/bootstrap/js/bootstrap.bundle.min.js"></script>
    <script src="vendor/php-email-form/validate.js"></script>
    <script src="vendor/aos/aos.js"></script>
    <script src="vendor/typed.js/typed.umd.js"></script>
    <script src="vendor/purecounter/purecounter_vanilla.js"></script>
    <script src="vendor/waypoints/noframework.waypoints.js"></script>
    <script src="vendor/glightbox/js/glightbox.min.js"></script>
    <script src="vendor/imagesloaded/imagesloaded.pkgd.min.js"></script>
    <script src="vendor/isotope-layout/isotope.pkgd.min.js"></script>
    <script src="vendor/swiper/swiper-bundle.min.js"></script>
    <script src="vendor/apexcharts/apexcharts.min.js"></script>
    <script src="vendor/chart.js/chart.umd.js"></script>
    <script src="vendor/echarts/echarts.min.js"></script>
    <script src="vendor/quill/quill.js"></script>
    <script src="vendor/simple-datatables/simple-datatables.js"></script>
    <script src="vendor/tinymce/tinymce.min.js"></script>
    <script src="vendor/php-email-form/validate.js"></script>
</body>

</html>
