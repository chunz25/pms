<!DOCTYPE html>
<html lang="en">

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link rel="icon" type="image/x-icon" href="img/logo.png">
    <title>Pengajuan Quotation</title>

    {{-- Style CSS --}}
    {{-- Vendor CSS Files --}}
    <link href="css/lpbj/main.css" rel="stylesheet">
    <link href="css/bootstrap.min.css" rel="stylesheet">
    <link href="vendor/bootstrap/css/bootstrap.min.css" rel="stylesheet">
    <link href="vendor/bootstrap-icons/bootstrap-icons.css" rel="stylesheet">
    <link href="vendor/aos/aos.css" rel="stylesheet">
    <link href="vendor/glightbox/css/glightbox.min.css" rel="stylesheet">
    <link href="vendor/swiper/swiper-bundle.min.css" rel="stylesheet">

    {{-- <script src="https://cdn.jsdelivr.net/npm/jquery@3.7.0/dist/jquery.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.0.2/dist/js/bootstrap.min.js"></script> --}}
    <link href="https://cdn.datatables.net/1.13.4/css/jquery.dataTables.min.css" rel="stylesheet">
    <script src="https://cdn.datatables.net/1.13.4/js/jquery.dataTables.min.js"></script>

    <style>
        table {
            counter-reset: rowNumber;
        }

        table tr>td:first-child {
            counter-increment: rowNumber;
        }

        table tr td:first-child::before {
            content: counter(rowNumber);
        }
    </style>
</head>

<body class="index-page">

    {{-- NavBar --}}
    <header id="header" class="header grey-background d-flex flex-column">
        <i class="header-toggle d-xl-none bi bi-list"></i>

        <div class="profile-img">
            <img src="img/logo.jpg" alt="" class="img-fluid rounded-circle">
        </div>

        <a href="#" class="logo d-flex align-items-center justify-content-center">
            <h1 class="sitename">Quotation</h1>
        </a>

        <nav id="navmenu" class="navmenu">
            <ul>
                <li><a href="pengajuanqe" class="active"><i class="bi bi-clipboard2-plus navicon"></i>Pengajuan</a>
                </li>
                <li><a href="historyqe"><i class="bi bi-clock-history navicon"></i>History</a></li>
                <li><a href="approveqe"><i class="bi bi-file-earmark-check navicon"></i>Approval</a></li>
                <li><a href="portal"><i class="bi bi-backspace navicon"></i>Kembali</a></li>
            </ul>
        </nav>
    </header>
    {{-- /NavBar --}}

    <main class="main">
        {{-- DataUser --}}
        <section class="about section">
            <div class="container" data-aos="fade-up" data-aos-delay="100">
                <div class="row gy-4 justify-content-center">
                    <div class="col-lg-12 content">
                        <h2 class="mb-4">Pengajuan Quotation</h2>
                        {{-- DataPegawai --}}
                        <div class="row">
                            <div class="col-lg-6">
                                <ul>
                                    <li><i class="bi bi-chevron-right"></i> <strong>NIK :</strong>
                                        <span>{{ $dataPegawai->nik }}</span>
                                    </li>
                                    <li><i class="bi bi-chevron-right"></i> <strong>Nama :</strong>
                                        <span>{{ $dataPegawai->name }}</span>
                                    </li>
                                    <li><i class="bi bi-chevron-right"></i> <strong>Jabatan :</strong>
                                        <span>{{ $dataPegawai->jabatanname }}</span>
                                    </li>
                                </ul>
                            </div>
                            <div class="col-lg-6">
                                <ul>
                                    <li><i class="bi bi-chevron-right"></i> <strong>Unit Kerja :</strong>
                                        <span>{{ $dataPegawai->unitname }}</span>
                                    </li>
                                    <li><i class="bi bi-chevron-right"></i> <strong>Divisi :</strong>
                                        <span>{{ $dataPegawai->divname }}</span>
                                    </li>
                                    <li><i class="bi bi-chevron-right"></i> <strong>Departemen :</strong>
                                        <span>{{ $dataPegawai->depname }}</span>
                                    </li>
                                </ul>
                            </div>
                        </div>
                        {{-- /DataPegawai --}}
                    </div>
                </div>
                <hr>
                {{-- FormPengajuan --}}
                <form action="ajukanqe" method="post">
                    @csrf
                    <div class="row align-items-end">
                        <div class="col-sm-2 mb-2">
                            <a class="btn btn-outline-success" href="tambahqe">Tambah Data</a>
                        </div>
                    </div>
                    <br>

                    @if ($dataDraft)
                        <h5><strong>{{ $dataVendor->vendorname }}</strong></h5>
                        <table class="table-responsive-sm table-hover table-bordered col-sm-12">
                            <thead class="table-primary text-center">
                                <tr>
                                    <th>No</th>
                                    <th>No LPBJ</th>
                                    <th>Description</th>
                                    <th>Article</th>
                                    <th>Qty</th>
                                    <th>Harga</th>
                                    <th>Total</th>
                                    <th>Action</th>
                                </tr>
                            </thead>
                            <tbody class="text-center">
                                @foreach ($dataDraft as $d)
                                    <tr>
                                        <td></td>
                                        <td>{{ $d->nolpbj }}</td>
                                        <td>{{ $d->description }}</td>
                                        <td>{{ $d->articlecode }}</td>
                                        <td>{{ $d->qty }}</td>
                                        <td>{{ $d->satuan }}</td>
                                        <td>{{ $d->total }}</td>
                                        <td style="width: 20%">
                                            <a href="cekdraftqe/{{ $d->id }}"
                                                class="btn btn-outline-success btn-sm">Lihat</a>
                                            <a href="deldraftqe/{{ $d->id }}"
                                                class="btn btn-outline-danger btn-sm">Hapus</a>
                                        </td>
                                    </tr>
                                @endforeach
                            </tbody>
                        </table>
                        <br>
                        <div class="row">
                            <div class="col-md-1 ml-md-auto">
                                <button class="btn btn-primary" type="submit">Ajukan</button>
                            </div>
                        </div>
                    @endif
                </form>
                {{-- /FormPengajuan --}}
            </div>
        </section>
        {{-- /DataUser --}}
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

    {{-- <script src="https://cdn.jsdelivr.net/npm/bootstrap@4.6.2/dist/js/bootstrap.bundle.min.js"
        integrity="sha384-Fy6S3B9q64WdZWQUiU+q4/2Lc9npb8tCaSX9FK7E8HnRr0Jz8D6OP9dO5Vg3Q9ct" crossorigin="anonymous">
    </script> --}}

    <script type="text/javascript">
        $(document).ready(function() {



        });
    </script>

</body>

</html>
