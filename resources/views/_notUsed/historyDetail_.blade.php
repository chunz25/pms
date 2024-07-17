<!DOCTYPE html>
<html lang="en">

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link rel="icon" type="image/x-icon" href="img/logo.png">
    <title>Portal PMS ECI</title>

    {{-- Style CSS --}}
    <link rel="stylesheet" href="css/portal/portalStyle.css">
    <link href="css/main.css" rel="stylesheet">

    {{-- Vendor CSS Files --}}
    <link href="vendor/bootstrap/css/bootstrap.min.css" rel="stylesheet">
    <link href="vendor/bootstrap-icons/bootstrap-icons.css" rel="stylesheet">
    <link href="vendor/aos/aos.css" rel="stylesheet">
    <link href="vendor/glightbox/css/glightbox.min.css" rel="stylesheet">
    <link href="vendor/swiper/swiper-bundle.min.css" rel="stylesheet">
</head>

<body class="index-page">

    {{-- NavBar --}}
    <header id="header" class="header d-flex align-items-center fixed-top">
        <div class="container-fluid container-xl position-relative d-flex align-items-center">

            <a href="" class="logo d-flex align-items-center me-auto">
                <img src="img/logo.png" alt="">
            </a>

            <nav id="navmenu" class="navmenu">
                <i class="mobile-nav-toggle d-xl-none bi bi-list"></i>
            </nav>
        </div>
    </header>
    {{-- /NavBar --}}

    <main class="main">

        {{-- MenuSection --}}
        <section id="services" class="services section">

            <div class="container section-title" data-aos="fade-up">
                <p>Procurement Management System<br></p>
            </div>

            <div class="container">

                <div class="row gy-4">
                    <div class="col-lg-4 col-md-6" data-aos="fade-up" data-aos-delay="100">
                        <div class="service-item item-cyan position-relative">
                            <i class="bi bi-file-earmark-text icon"></i>
                            <h3>LPBJ</h3>
                            <p>Lembar Permintaan Barang / Jasa</p>
                            <a href="pengajuanlpbj" class="read-more stretched-link"><span>Buat LPBJ</span> <i
                                    class="bi bi-arrow-right"></i></a>
                        </div>
                    </div>

                    <div class="col-lg-4 col-md-6" data-aos="fade-up" data-aos-delay="200">
                        <div class="service-item item-orange position-relative">
                            <i class="bi bi bi-file-earmark-plus icon"></i>
                            <h3>Quotation</h3>
                            <p>Quotation untuk LPBJ yang diajukan</p>
                            <a href="pengajuanqe" class="read-more stretched-link"><span>Buat Quotation</span> <i
                                    class="bi bi-arrow-right"></i></a>
                        </div>
                    </div>


                    <div class="col-lg-4 col-md-6" data-aos="fade-up" data-aos-delay="300">
                        <div class="service-item item-teal position-relative">
                            <i class="bi bi-clipboard-check icon"></i>
                            <h3>Approval</h3>
                            <p>Approval untuk dokumen LPBJ yang diajukan</p>
                            <a href="approval" class="read-more stretched-link"><span>Approve Dokumen</span> <i
                                    class="bi bi-arrow-right"></i></a>
                        </div>
                    </div>
                </div>

            </div>

        </section>
        {{-- /MenuSection --}}

    </main>

    <!-- Scroll Top -->
    <a href="#" id="scroll-top" class="scroll-top d-flex align-items-center justify-content-center"><i
            class="bi bi-arrow-up-short"></i></a>

    <!-- Vendor JS Files -->
    <script src="vendor/bootstrap/js/bootstrap.bundle.min.js"></script>
    <script src="vendor/php-email-form/validate.js"></script>
    <script src="vendor/aos/aos.js"></script>
    <script src="vendor/glightbox/js/glightbox.min.js"></script>
    <script src="vendor/purecounter/purecounter_vanilla.js"></script>
    <script src="vendor/imagesloaded/imagesloaded.pkgd.min.js"></script>
    <script src="vendor/isotope-layout/isotope.pkgd.min.js"></script>
    <script src="vendor/swiper/swiper-bundle.min.js"></script>

    <!-- Main JS File -->
    <script src="js/main.js"></script>

</body>

</html>
