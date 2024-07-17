<!DOCTYPE html>
<html lang="en">

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link rel="icon" type="image/x-icon" href="img/logo.png">
    <title>Create Quotation</title>

    {{-- Style CSS --}}
    {{-- Vendor CSS Files --}}
    <link href="css/lpbj/main.css" rel="stylesheet">
    {{-- <link href="css/lpbj/mainSearch.css" rel="stylesheet"> --}}
    <link href="css/lpbj/articleSearch.css" rel="stylesheet">
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
    <link href="vendor/simple-datatables/style.css" rel="stylesheet">
    <link href="https://fonts.googleapis.com/icon?family=Material+Icons" rel="stylesheet">
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
                        <h2 class="mb-1">Create Quotation</h2>
                    </div>
                </div>
                <br>
                <form class="form-horizontal form-label-left" action="tambahqe" method="post"
                    enctype="multipart/form-data">
                    @csrf
                    <div class="row">
                        <div class="col-sm-4">
                            <label for="noLPBJ">No LPBJ :</label>
                            <input class="form-control" type="text" name="noLPBJ" readonly>
                            <br>
                        </div>
                    </div>
                    <div class="row">
                        <div class="col-sm-4">
                            <label for="descLPBJ">Description :</label>
                            <input class="form-control" type="text" name="descLPBJ" autocomplete="off" readonly>
                            <br>
                        </div>
                    </div>
                    <div class="row">
                        <div class="col-sm-6">
                            <a type="button" class="btn btn-outline-primary btn-sm" href="tambahvendor">
                                Tambah Quotation
                            </a>
                            <br>
                            <br>
                        </div>
                    </div>
                    <br>
                    <div class="row">
                        <h5>Nama Vendor</h5>
                        <table class="table table-bordered">
                            <thead class="table-primary">
                                <tr>
                                    <th>No</th>
                                    <th>Article Code</th>
                                    <th>Qty</th>
                                    <th>Satuan</th>
                                    <th>Total</th>
                                    <th>Remarks QA</th>
                                    <th>Attachment</th>
                                </tr>
                            </thead>
                            <tbody>
                                <tr>
                                    <td>1</td>
                                    <td>article1</td>
                                    <td>8</td>
                                    <td>1000</td>
                                    <td>8000</td>
                                    <td>test remak</td>
                                    <td>file</td>
                                </tr>
                            </tbody>
                        </table>
                        <h5>Nama Vendor</h5>
                        <table class="table table-bordered">
                            <thead class="table-primary">
                                <tr>
                                    <th>No</th>
                                    <th>Article Code</th>
                                    <th>Qty</th>
                                    <th>Satuan</th>
                                    <th>Total</th>
                                    <th>Remarks QA</th>
                                    <th>Attachment</th>
                                </tr>
                            </thead>
                            <tbody>
                                <tr>
                                    <td>1</td>
                                    <td>article1</td>
                                    <td>8</td>
                                    <td>1000</td>
                                    <td>8000</td>
                                    <td>test remak</td>
                                    <td>file</td>
                                </tr>
                                <tr>
                                    <td>2</td>
                                    <td>article1</td>
                                    <td>10</td>
                                    <td>1000</td>
                                    <td>8000</td>
                                    <td>test remak</td>
                                    <td>file</td>
                                </tr>
                            </tbody>
                        </table>
                    </div>
                    <div class="modal-footer">
                        <a href="pengajuanqe" class="btn btn-secondary mr-2">Kembali</a>
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
