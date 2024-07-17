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
                <ul>
                    <li class="dropdown">
                        <a href="#">
                            <span>{{ $user . ' | ' . $nama }}</span>
                            <i class="bi bi-chevron-down toggle-dropdown"></i>
                        </a>
                        <ul class="dropdown-menu">
                            {{-- <li><a href="#">Profile</a></li> --}}
                            {{-- <li><a href="#">Change Password</a></li> --}}
                            <li><a href="logout">Logout</a></li>
                        </ul>
                    </li>
                </ul>
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
                <div class="row gy-4 justify-content-md-center">
                    @foreach ($getMenu as $m)
                        <div class="col-lg-auto col-md-4" data-aos="fade-up" data-aos-delay="100">
                            <div class="service-item position-relative {{ $m->color }}">
                                <i class="{{ $m->icon }}"></i>
                                <h3>{{ $m->menuname }}</h3>
                                <p>{{ $m->deskripsi }}</p>
                                <a href="{{ $m->linkhref }}"
                                    class="read-more stretched-link"><span>{{ 'Link ' . $m->menuname }}</span> <i
                                        class="bi bi-arrow-right"></i></a>
                            </div>
                        </div>
                    @endforeach
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
