<!DOCTYPE html>
<html lang="en">

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link rel="icon" type="image/x-icon" href="{{ asset('img/logo.png') }}">
    <title>List History {{ $title }}</title>

    {{-- Style CSS --}}
    {{-- Vendor CSS Files --}}
    <link href="{{ asset('css/lpbj/main.css') }}" rel="stylesheet">
    <link href="{{ asset('css/bootstrap.min.css') }}" rel="stylesheet">
    <link href="{{ asset('vendor/bootstrap/css/bootstrap.min.css') }}" rel="stylesheet">
    <link href="{{ asset('vendor/bootstrap-icons/bootstrap-icons.css') }}" rel="stylesheet">
    <link href="{{ asset('vendor/aos/aos.css') }}" rel="stylesheet">
    <link href="{{ asset('vendor/glightbox/css/glightbox.min.css') }}" rel="stylesheet">
    <link href="{{ asset('vendor/swiper/swiper-bundle.min.css') }}" rel="stylesheet">

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
            <img src="{{ asset('img/logo.jpg') }}" alt="" class="img-fluid rounded-circle">
        </div>

        <a class="logo d-flex align-items-center justify-content-center">
            <h1 class="sitename">{{ $title }}</h1>
        </a>

        <nav id="navmenu" class="navmenu">
            <ul>
                @if (substr(session('groupname'), 0, 8) != 'APPROVER')
                    <li><a href="{{ url('/pengajuanlpbj') }}">
                            <i class="bi bi-clipboard2-plus navicon"></i>
                            Pengajuan</a>
                    </li>
                @endif
                <li><a href="{{ url('/historylpbj') }}" class="active"><i
                            class="bi bi-clock-history navicon"></i>History</a>
                </li>
                @if (substr(session('groupname'), 0, 8) == 'APPROVER' || session('groupname') == 'ADMINISTRATOR')
                    <li><a href="{{ url('/approvelpbj') }}"><i
                                class="bi bi-file-earmark-check navicon"></i>Approval</a></li>
                @endif
                <li><a href="{{ url('/portal') }}"><i class="bi bi-backspace navicon"></i>Kembali</a></li>
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
                        <h2 class="mb-1">List History {{ $title }}</h2>
                    </div>
                </div>
                <br>
                <table id="tbList" class="table-responsive-sm table-hover datatable">
                    <thead class="table-primary">
                        <tr>
                            <th>No</th>
                            <th>No LPBJ</th>
                            <th>Departemen</th>
                            <th>Tanggal Permintaan</th>
                            <th>Description</th>
                            <th>Status</th>
                            <th>Reject Reason</th>
                            <th>Detail</th>
                        </tr>
                    </thead>
                    <tbody>
                        @foreach ($dataHistory as $dh)
                            <tr>
                                <td></td>
                                <td>{{ $dh->nolpbj }}</td>
                                <td>{{ $dh->depname }}</td>
                                <td>{{ $dh->tglpermintaan }}</td>
                                <td>{{ $dh->description }}</td>
                                <td>{{ $dh->workflow }}</td>
                                <td>{{ $dh->reason }}</td>
                                <td style="width: 10%"><a href="{{ url("/detaillpbj/$dh->hdrid") }}"
                                        class="btn btn-sm btn-success"><i class="bi bi-search"></i></a>
                                    @if ($dh->status == 'Draft' && $dh->userid == session('iduser'))
                                        <a href="{{ url("/editlpbj/$dh->hdrid") }}" class="btn btn-sm btn-primary"><i
                                                class="bi bi-pencil"></i></a>
                                    @endif
                                </td>
                            </tr>
                        @endforeach
                    </tbody>
                </table>
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
    <script src="{{ asset('js/lpbj/main.js') }}"></script>
    <script src="{{ asset('js/bootstrap.min.js') }}"></script>
    <script src="{{ asset('js/bootstrap.bundle.min.js') }}"></script>
    <script src="{{ asset('vendor/bootstrap/js/bootstrap.bundle.min.js') }}"></script>
    <script src="{{ asset('vendor/php-email-form/validate.js') }}"></script>
    <script src="{{ asset('vendor/aos/aos.js') }}"></script>
    <script src="{{ asset('vendor/typed.js/typed.umd.js') }}"></script>
    <script src="{{ asset('vendor/purecounter/purecounter_vanilla.js') }}"></script>
    <script src="{{ asset('vendor/waypoints/noframework.waypoints.js') }}"></script>
    <script src="{{ asset('vendor/glightbox/js/glightbox.min.js') }}"></script>
    <script src="{{ asset('vendor/imagesloaded/imagesloaded.pkgd.min.js') }}"></script>
    <script src="{{ asset('vendor/isotope-layout/isotope.pkgd.min.js') }}"></script>
    <script src="{{ asset('vendor/swiper/swiper-bundle.min.js') }}"></script>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@4.6.2/dist/js/bootstrap.bundle.min.js"
        integrity="sha384-Fy6S3B9q64WdZWQUiU+q4/2Lc9npb8tCaSX9FK7E8HnRr0Jz8D6OP9dO5Vg3Q9ct" crossorigin="anonymous">
    </script>

    <script type="text/javascript">
        $(document).ready(function() {

            const tbList = new DataTable('#tbList', {
                columnDefs: [{
                    searchable: false,
                    orderable: false,
                    targets: 0
                }],
                order: [
                    [1, 'asc']
                ]
            });
            tbList.on('order.dt search.dt', function() {
                let i = 1;

                tbList.cells(null, 0, {
                        search: 'applied',
                        order: 'applied'
                    })
                    .every(function(cell) {
                        this.data(i++);
                    });
            }).draw();

        });
    </script>

</body>

</html>
