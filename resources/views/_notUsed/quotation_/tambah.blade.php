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
        {{-- FormPengajuan --}}
        <section class="about section">
            <div class="container" data-aos="fade-up" data-aos-delay="100">
                <div class="row gy-4 justify-content-center">
                    <div class="col-lg-12 content">
                        <h2 class="mb-1">Tambah Data Quotation</h2>
                    </div>
                </div>
                <br>
                <form class="form-horizontal form-label-left" action="draftqe" method="post"
                    enctype="multipart/form-data">
                    @csrf
                    <div class="row">
                        <div class="col-sm-4">
                            <label>Nomor LPBJ :</label>
                            <input class="form-control" type="text" id="nolpbj" name="nolpbj"
                                placeholder="Pilih LPBJ" required data-bs-toggle="modal" data-bs-target="#lpbjModal"
                                autocomplete="off">

                        </div>
                        <div class="col-sm-4">
                            <label>Description :</label>
                            <input class="form-control" type="text" id="deskripsi" name="deskripsi"
                                placeholder="Description" autocomplete="off" disabled>
                        </div>
                    </div>
                    <br>
                    <table class="table table-bordered datatable" id="tbLpbj">
                        <thead>
                            <tr>
                                <th style="width: 10%">No</th>
                                <th style="width: 20%">Nomor LPBJ</th>
                                <th>Description</th>
                                <th class="text-center" style="width: 20%">Action</th>
                            </tr>
                        </thead>
                        <tbody>
                            @foreach ($getArticle as $a)
                                <tr>
                                    <td style="width: 10%"></td>
                                    <td style="width: 20%">{{ $a->articlecode }}</td>
                                    <td>{{ $a->articlename }}</td>
                                </tr>
                            @endforeach
                        </tbody>
                    </table>
                    <div class="modal-footer">
                        <a href="pengajuanlpbj" class="btn btn-secondary mr-2">Kembali</a>
                        <button type="submit" class="btn btn-primary">Simpan</button>
                    </div>
                </form>
            </div>
            <hr>
        </section>
        {{-- /FormPengajuan --}}
    </main>

    {{-- ArticleModal --}}
    <div class="modal fade" id="lpbjModal" tabindex="-1" aria-hidden="true">
        <div class="modal-dialog modal-lg">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title" id="exampleModalLabel">List LPBJ</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                </div>
                <div class="modal-body">
                    <table class="table table-bordered datatable" id="tbLpbj">
                        <thead>
                            <tr>
                                <th style="width: 10%">No</th>
                                <th style="width: 20%">Nomor LPBJ</th>
                                <th>Description</th>
                                <th class="text-center" style="width: 20%">Action</th>
                            </tr>
                        </thead>
                        <tbody>
                            @foreach ($getLpbj as $a)
                                <tr>
                                    <td style="width: 10%"></td>
                                    <td style="width: 20%">{{ $a->nolpbj }}</td>
                                    <td>{{ $a->description }}</td>
                                    <td class="text-center" style="width: 20%">
                                        <button type="button"
                                            onclick="addLpbj('{{ $a->nolpbj }}','{{ $a->description }}')"
                                            class="btn btn-outline-success btn-sm" data-bs-dismiss="modal">
                                            Pilih
                                        </button>
                                    </td>
                                </tr>
                            @endforeach
                        </tbody>
                    </table>
                </div>
            </div>
        </div>
    </div>
    {{-- /ArticleModal --}}

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
    <script src="vendor/tinymce/tinymce.min.js"></script>
    <script src="vendor/php-email-form/validate.js"></script>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@4.6.2/dist/js/bootstrap.bundle.min.js"
        integrity="sha384-Fy6S3B9q64WdZWQUiU+q4/2Lc9npb8tCaSX9FK7E8HnRr0Jz8D6OP9dO5Vg3Q9ct" crossorigin="anonymous">
    </script>

    <script type="text/javascript">
        $(document).ready(function() {

            const tbLpbj = new DataTable('#tbLpbj', {
                columnDefs: [{
                    searchable: false,
                    orderable: false,
                    targets: 0
                }],
                order: [
                    [1, 'asc']
                ]
            });
            tbLpbj.on('order.dt search.dt', function() {
                let i = 1;

                tbLpbj.cells(null, 0, {
                        search: 'applied',
                        order: 'applied'
                    })
                    .every(function(cell) {
                        this.data(i++);
                    });
            }).draw();

            $.ajaxSetup({
                headers: {
                    'X-CSRF-TOKEN': $('meta[name="csrf-token"]').attr('content')
                }
            });

        });

        function addLpbj(c, n) {
            $('#nolpbj').val(c);
            $('#deskripsi').val(n);
        }
    </script>
</body>

</html>
