<!DOCTYPE html>
<html lang="en">

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link rel="icon" type="image/x-icon" href="{{ asset('img/logo.png') }}">
    <title>Ganti Password PMS ECI</title>

    {{-- Style CSS --}}
    <link href="{{ asset('css/main.css') }}" rel="stylesheet">

    {{-- Vendor CSS Files --}}
    <link href="{{ asset('vendor/bootstrap/css/bootstrap.min.css') }}" rel="stylesheet">
    <link href="{{ asset('vendor/bootstrap-icons/bootstrap-icons.css') }}" rel="stylesheet">
    <link href="{{ asset('vendor/aos/aos.css') }}" rel="stylesheet">
    <script src="https://cdn.jsdelivr.net/npm/jquery@3.7.0/dist/jquery.min.js"></script>

</head>

<body class="index-page">

    {{-- NavBar --}}
    <header id="header" class="header d-flex align-items-center fixed-top">
        <div class="container-fluid container-xl position-relative d-flex align-items-center">

            <a href="" class="logo d-flex align-items-center me-auto">
                <img src="{{ asset('img/logo.png') }}" alt="">
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
                            <li><a href="{{ url('/cpassword') }}">Change Password</a></li>
                            <li><a href="{{ url('/logout') }}">Logout</a></li>
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
                <p>Ganti Password PMS<br></p>
            </div>
            <div class="container">
                <div class="row gy-4 justify-content-md-center">
                    <div class="col-lg-6" data-aos="fade-up" data-aos-delay="100">
                        <div class="service-item position-relative item-grey">
                            <form action="{{ url('/cpass') }}" method="post">
                                @csrf
                                <input type="text" name="username" value="{{ $user }}" hidden>
                                <input type="text" name="isreset" value="{{ session('isreset') }}" hidden>
                                <div>
                                    <input class="form-control text-center mb-2" type="password" id="oldPass"
                                        name="oldPass" placeholder="Password Lama..." autocomplete="off">
                                </div>
                                <div>
                                    <input class="form-control text-center mb-2" type="password" id="newPass"
                                        name="newPass" placeholder="Password Baru..." autocomplete="off">
                                </div>
                                <div>
                                    <input class="form-control text-center mb-4" type="password" id="conPass"
                                        placeholder="Konfirmasi Password Baru..." autocomplete="off">
                                </div>

                                <div>
                                    <button class="btn btn-primary" onclick="return validasi();"
                                        type="submit">Simpan</button>
                                    <a href="{{ url('/portal') }}" class="btn btn-warning">Kembali</a>
                                </div>
                            </form>
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
    <script src="{{ asset('vendor/bootstrap/js/bootstrap.bundle.min.js') }}"></script>
    <script src="{{ asset('vendor/aos/aos.js') }}"></script>

    <!-- Main JS File -->
    <script src="{{ asset('js/main.js') }}"></script>

    <script type="text/javascript">
        @if (Session::has('pesan'))
            alert("{{ Session::get('pesan') }}");
        @endif

        @if (Session::has('isreset'))
            $('#oldPass').attr('hidden', true);
            $('#oldPass').val("{{ session('kunci') }}");
        @endif

        function validasi() {
            let op = $('#oldPass').val();
            let np = $('#newPass').val();
            let cp = $('#conPass').val();
            let cur = "{{ session('kunci') }}";

            if (op === '') {
                alert('Password Lama tidak boleh kosong');
                return false;
            } else if (np == op) {
                alert('Password Lama dan Baru tidak boleh sama')
                return false;
            } else if (np == 'pms2024') {
                alert('Jangan gunakan password Default')
                return false;
            } else if (np != cp) {
                alert('Konfirmasi password baru anda tidak sesuai')
                return false;
            } else {
                return true;
            }
        }
    </script>

</body>

</html>
