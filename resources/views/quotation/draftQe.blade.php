<!DOCTYPE html>
<html lang="en">

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link rel="icon" type="image/x-icon" href="img/logo.png">
    <title>Tambah Vendor {{ $title }}</title>

    {{-- Style CSS --}}
    {{-- Vendor CSS Files --}}
    <link href="css/lpbj/main.css" rel="stylesheet">
    <link href="vendor/bootstrap/css/bootstrap.min.css" rel="stylesheet">
    <link href="vendor/bootstrap-icons/bootstrap-icons.css" rel="stylesheet">
    <link href="vendor/aos/aos.css" rel="stylesheet">
    <link href="vendor/glightbox/css/glightbox.min.css" rel="stylesheet">
    <link href="vendor/swiper/swiper-bundle.min.css" rel="stylesheet">

<<<<<<< Updated upstream
    <link href="https://cdn.datatables.net/1.13.4/css/jquery.dataTables.min.css" rel="stylesheet">
    <script src="https://cdn.datatables.net/1.13.4/js/jquery.dataTables.min.js"></script>
=======
    {{-- <link href="https://cdn.datatables.net/1.13.4/css/jquery.dataTables.min.css" rel="stylesheet">
    <script src="https://cdn.datatables.net/1.13.4/js/jquery.dataTables.min.js"></script> --}}
    <script src="https://cdn.jsdelivr.net/npm/jquery@3.7.0/dist/jquery.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.0.2/dist/js/bootstrap.min.js"></script>
>>>>>>> Stashed changes

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
            <h1 class="sitename">{{ $title }}</h1>
        </a>

        <nav id="navmenu" class="navmenu">
            <ul>
                @if (substr(session('groupname'), 0, 8) != 'APPROVER')
                    <li><a href="pengajuanqe" class="active">
                            <i class="bi bi-clipboard2-plus navicon"></i>
                            Pengajuan</a>
                    </li>
                @endif
                <li><a href="historyqe"><i class="bi bi-clock-history navicon"></i>History</a>
                </li>
                @if (substr(session('groupname'), 0, 8) == 'APPROVER' || session('groupname') == 'ADMINISTRATOR')
                    <li><a href="approveqe"><i class="bi bi-file-earmark-check navicon"></i>Approval</a></li>
                @endif
                <li><a href="portal"><i class="bi bi-backspace navicon"></i>Kembali</a></li>
            </ul>
        </nav>
    </header>
    {{-- /NavBar --}}

    <main class="main">
        <section class="about section">
            <div class="container" data-aos="fade-up" data-aos-delay="100">
                <div class="row gy-4 justify-content-center">
                    <div class="col-lg-12 content">
                        <h2 class="mb-4">Vendor QE</h2>
                        <div class="row">
                            <div class="col-lg-6">
                                <ul>
                                    <li><i class="bi bi-chevron-right"></i> <strong>No LPBJ :</strong>
                                        <span>{{ $getLpbj->nolpbj }}</span>
                                    </li>
                                </ul>
                            </div>
                        </div>
                    </div>
                </div>

                <div class="row align-items-end">
                    <div class="col-sm-4 mb-2">
                        <form action="tambahvendor" method="post">
                            @csrf
                            @foreach ($dataDtl as $d)
                                <input type="text" name="dtl[]" value="{{ $d->dtlid }}" hidden>
                                <input type="text" name="hdr[]" value="{{ $d->hdrid }}" hidden>
                            @endforeach
                            <button type="submit" class="btn btn-outline-success">Tambah Vendor</button>
                        </form>
                    </div>
                </div>
                <br>

                {{-- FormPengajuan --}}
<<<<<<< Updated upstream
                <form action="ajukanqe" method="post">
=======
                <form onsubmit="return validasi()" action="{{ url('/ajukanqe') }}" method="post"
                    enctype="multipart/form-data">
                    @csrf
>>>>>>> Stashed changes
                    @foreach ($iddtl as $c)
                        <input type="text" name="dtl[]" id="dtl[]" value="{{ $c }}" hidden>
                    @endforeach
                    @if ($dataDraft)
<<<<<<< Updated upstream
=======
                        <div class="row mb-2">
                            <div class="col-sm-4">
                                {{-- <label>Attachment:</label> --}}
                                <input class="form-control" type="file" accept="application/pdf"
                                    onchange="validate(this.value);" id="attach" name="attach" required>
                            </div>
                        </div>
                        <input type="text" name="statusdoc" id="statusdoc" value="{{ $dataDraft[0]->statusdoc }}"
                            hidden>
>>>>>>> Stashed changes
                        @foreach ($dataVendor as $v)
                            <h4>
                                <strong>{{ $v->vendorname }}</strong>
                                @if ($v->ispilih == 1)
                                    <i class="bi bi-check2-all navicon"></i>
                                @endif
                            </h4>

                            @csrf
                            <table class="table-responsive-sm table-hover table-bordered col-sm-12">
                                <thead class="table-primary text-center">
                                    <tr>
                                        <th>No</th>
                                        <th>Article</th>
                                        <th>Vendor</th>
                                        <th>Qty</th>
                                        <th>Harga Satuan</th>
                                        <th>Harga Total</th>
                                        <th>Remarks QA</th>
                                        <th>Attachment</th>
                                    </tr>
                                </thead>
                                <tbody class="text-center">
                                    @foreach ($dataDraft as $d)
                                        @if ($v->vendorname == $d->vendorname)
                                            <tr>
                                                <td></td>
                                                <td>{{ $d->articlecode }}</td>
                                                <td>{{ $d->vendorname }}</td>
                                                <td>{{ $d->qty }}</td>
                                                <td>{{ $d->satuan }}</td>
                                                <td>{{ $d->total }}</td>
                                                <td>{{ $d->remarkqa }}</td>
                                                <td><a type="button" class="text-center text-blue"
                                                        data-bs-toggle="modal"
                                                        data-bs-target="#modal{{ $d->attachment }}">Lihat File</a></td>
                                            </tr>
                                        @endif
                                    @endforeach
                                </tbody>
                            </table>
                            <br>
                        @endforeach
                    @endif

                    <hr>
                    <div class="modal-footer">
                        <a href="tambahqe" class="btn btn-secondary mr-2">Kembali</a>
                        @if ($dataDraft)
                            <button class="btn btn-primary" type="submit">Ajukan</button>
                        @endif
                    </div>
                </form>
                {{-- /FormPengajuan --}}
            </div>
        </section>
    </main>

    {{-- ModalTampilFile --}}
    @if ($dataDraft)
        @foreach ($dataDraft as $d)
            <div class="modal fade" id="modal{{ $d->attachment }}" tabindex="-1" aria-hidden="true">
                <div class="modal-dialog modal-lg">
                    <div class="modal-content">
                        <div class="modal-header">
                            <h5 class="modal-title">File Attachment</h5>
                            <button type="button" class="close" data-bs-dismiss="modal" aria-label="Close">
                                <span aria-hidden="true">&times;</span>
                            </button>
                        </div>
                        <div class="modal-body">
                            <embed src="pdf/{{ $d->attachment }}" type="application/pdf" frameBorder="0"
                                height="100%" width="100%"></embed>
                        </div>
                        <div class="modal-footer">
                            <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Kembali</button>
                        </div>
                    </div>
                </div>
            </div>
        @endforeach
    @endif
    {{-- /ModalTampilFile --}}

<<<<<<< Updated upstream
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
=======
    {{-- ModalTambahAttach --}}
    {{-- @if ($dataVendor)
        @foreach ($dataVendor as $v)
            <div class="modal fade" id="modalItem" tabindex="-1" aria-hidden="true">
                <div class="modal-dialog modal-md">
                    <div class="modal-content">
                        <div class="modal-header">
                            <h5 class="modal-title">File Attachment</h5>
                        </div>
                        <div class="modal-body">
                            <label class="mb-2">Silahkan tambah document file yang sudah approve.</label>
                            <input class="form-control" type="file" name="qeItem" id="qeItem"
                                accept="application/pdf" onchange="return validasiItem(this.value)" required>
                        </div>
                        <div class="modal-footer">
                            <button type="button" class="btn btn-primary" onclick="return ajukanItem()">Ajukan
                                QE</button>
                            <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Kembali</button>
                        </div>
                    </div>
                </div>
            </div>
        @endforeach
    @endif --}}
    {{-- /ModalTambahAttach --}}

    @include('template.footer')
    {{-- VendorJS --}}
    {{-- MainJS --}}
    <script src="{{ asset('js/lpbj/main.js') }}"></script>
    <script src="{{ asset('js/bootstrap.min.js') }}"></script>
    <script src="{{ asset('js/bootstrap.bundle.min.js') }}"></script>
    <script src="{{ asset('vendor/bootstrap/js/bootstrap.bundle.min.js') }}"></script>
    <script src="{{ asset('vendor/aos/aos.js') }}"></script>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@4.6.2/dist/js/bootstrap.bundle.min.js"
        integrity="sha384-Fy6S3B9q64WdZWQUiU+q4/2Lc9npb8tCaSX9FK7E8HnRr0Jz8D6OP9dO5Vg3Q9ct" crossorigin="anonymous">
    </script>

    <script type="text/javascript">
        $("#pengajuan").addClass("active");

        @if (Session::has('pesan'))
            alert("{{ Session::get('pesan') }}");
        @endif

        function validate(fileName) {
            let a = document.getElementById("attach");
            let ext = new Array("pdf");
            let limit = 1700000;
            let fileext = fileName.split('.').pop().toLowerCase();
            // let aa = document.getElementById("qeItem").files[0];
            // let aaa = document.getElementById("attachHdr");

            if (ext.includes(fileext) && a.files[0].size < limit) {
                // const dataTransfer = new DataTransfer();
                // dataTransfer.items.add(aa);
                // aaa.files = dataTransfer.files;
                return true;
            } else if (!ext.includes(fileext)) {
                a.value = null;
                alert('Format file tidak sesuai');
            } else if (a.files[0].size > limit) {
                a.value = null;
                alert('Maximum ukuran file 1,5Mb');
            }
        }

        // function ajukanItem() {
        //     $('#modalItem').modal('hide');
        //     return true
        // }

        function validasi() {
            let sumPilih = {{ $sumVendor }};

            if (sumPilih > 1) {
                alert('Vendor pilihan hanya bisa 1');
                return false
            } else if (sumPilih < 1) {
                alert('Vendor pilihan harus ada');
                return false
            } else {
                // $('#modalItem').modal('show');
                return true
            }
        }
    </script>
>>>>>>> Stashed changes

</body>

</html>
