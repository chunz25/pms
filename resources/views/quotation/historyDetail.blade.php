<!DOCTYPE html>
<html lang="en">

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link rel="icon" type="image/x-icon" href="{{ asset('img/logo.png') }}">
    <title>Detail Quotation</title>

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
</head>


<body class="index-page">

    {{-- NavBar --}}
    <header id="header" class="header grey-background d-flex flex-column">
        <i class="header-toggle d-xl-none bi bi-list"></i>

        <div class="profile-img">
            <img src="{{ asset('img/logo.jpg') }}" alt="" class="img-fluid rounded-circle">
        </div>

        <a href="#" class="logo d-flex align-items-center justify-content-center">
            <h1 class="sitename">Quotation</h1>
        </a>

        <nav id="navmenu" class="navmenu">
            <ul>
                @if (substr(session('groupname'), 0, 8) != 'APPROVER')
                    <li><a href="{{ url('/pengajuanqe') }}">
                            <i class="bi bi-clipboard2-plus navicon"></i>
                            Pengajuan</a>
                    </li>
                @endif
                <li><a href="{{ url('/historyqe') }}" class="active"><i
                            class="bi bi-clock-history navicon"></i>History</a>
                </li>
                @if (substr(session('groupname'), 0, 8) == 'APPROVER' || session('groupname') == 'ADMINISTRATOR')
                    <li><a href="{{ url('/approveqe') }}"><i class="bi bi-file-earmark-check navicon"></i>Approval</a>
                    </li>
                @endif
                <li><a href="{{ url('/portal') }}"><i class="bi bi-backspace navicon"></i>Kembali</a></li>
            </ul>
        </nav>
    </header>
    {{-- /NavBar --}}

    <main class="main">
        <section class="about section">
            <div class="container" data-aos="fade-up" data-aos-delay="100">
                {{-- DataUser --}}
                <div class="row gy-4 justify-content-center">
                    <div class="col-lg-12 content">
                        <h2 class="mb-4">Detail Quotation</h2>
                        <div class="row">
                            <div class="col-lg-6">
                                <ul>
                                    <li><i class="bi bi-chevron-right"></i> <strong>Status QE :</strong>
                                        <span>{{ $dataHeader->workflow }}</span>
                                    </li>
                                    <li><i class="bi bi-chevron-right"></i> <strong>No QE :</strong>
                                        <span>{{ $dataHeader->noqe }}</span>
                                    </li>
                                    <li><i class="bi bi-chevron-right"></i> <strong>Tanggal Permintaan :</strong>
                                        <span>{{ $dataHeader->created_at }}</span>
                                    </li>
<<<<<<< Updated upstream
<<<<<<< Updated upstream
<<<<<<< Updated upstream
=======
=======
>>>>>>> Stashed changes
=======
>>>>>>> Stashed changes
                                    <li><i class="bi bi-chevron-right"></i> <strong>Description QE :</strong>
                                        <span>{{ $dataHeader->remark }}</span>
                                    </li>
                                    @if ($dataHeader->reason != '')
                                        <li><i class="bi bi-chevron-right"></i> <strong>Alasan Reject :</strong>
                                            <span>{{ $dataHeader->reason }}</span>
                                        </li>
                                    @endif
                                    <a class="btn btn-outline-primary btn-sm mt-2"
                                        href="{{ url("/lihatqedoc/$dataHeader->hdrid") }}">
                                        <i class="bi bi-filetype-pdf"></i> Lihat Dokumen
                                    </a>
                                    <a class="btn btn-outline-danger btn-sm mt-2"
                                        href="{{ url("/cetakqedoc/$dataHeader->hdrid") }}">
                                        <i class="bi bi-filetype-pdf"></i> Print Dokumen
                                    </a>
                                    <button type="button" class="btn btn-outline-success btn-sm mt-2" data-bs-toggle="modal"
                                        data-bs-target="#modalFile">
                                        <i class="bi bi-filetype-pdf"></i> Lihat Lampiran
                                    </button>
                                    @if ($dataHeader->statusid == 14)
                                        <button type="button" class="btn btn-outline-warning btn-sm mt-2"
                                            data-bs-toggle="modal" data-bs-target="#modalClose">
                                            <i class="bi bi-filetype-pdf"></i> Close LPBJ
                                        </button>
                                    @endif
                                    @if ($dataHeader->statusid == 15)
                                        <button type="button" class="btn btn-outline-warning btn-sm mt-2"
                                            data-bs-toggle="modal" data-bs-target="#modalGR">
                                            <i class="bi bi-filetype-pdf"></i> Lihat GR
                                        </button>
                                    @endif
<<<<<<< Updated upstream
<<<<<<< Updated upstream
>>>>>>> Stashed changes
=======
>>>>>>> Stashed changes
=======
>>>>>>> Stashed changes
                                </ul>
                            </div>
                        </div>
                    </div>
                </div>
                {{-- /DataUser --}}
                <hr>
                @php
                    $i = 0;
                @endphp
                @foreach ($dataVendorHdr as $vendor)
                    <div class="col-sm-12 align-middle mb-2">
                        <span><strong>{{ $vendor->vendorname }}</strong></span>
                        @if ($vendor->pilih == 1)
                            <span>Vendor Pilihan User</span>
                        @endif
                        <a href="historyqe/{{ $vendor->hdrid }}" class="btn btn-outline-secondary btn-sm">Lihat
                            QE</a>
                    </div>
                    <table class="table-responsive-sm table-hover table-bordered col-sm-12 mb-4">
                        <thead class="table-secondary text-center">
                            <tr>
                                <th>Article</th>
                                <th>Satuan</th>
                                <th>Total</th>
                                <th>Remark QA</th>
                            </tr>
                        </thead>
                        <tbody class="text-center">
                            @foreach ($dataVendorDtl[$i] as $d)
                                <tr>
                                    <td>{{ $d->articlecode }}</td>
                                    <td>{{ $d->satuan }}</td>
                                    <td>{{ $d->total }}</td>
                                    <td>{{ $d->remarkqa }}</td>
                                </tr>
                            @endforeach
                        </tbody>
                    </table>
                    @php
                        $i++;
                    @endphp
                @endforeach
                <br>
                <div class="modal-footer">
                    <a href="historyqe" class="btn btn-success">Kembali</a>
                </div>
            </div>
        </section>
    </main>

<<<<<<< Updated upstream
<<<<<<< Updated upstream
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

    {{-- ModalTampilGambar --}}
    {{-- @foreach ($dataDetail as $dd)
        <div class="modal fade" id="modal{{ $dd->gambar }}" tabindex="-1" aria-hidden="true">
            <div class="modal-dialog">
                <div class="modal-content">
                    <div class="modal-header">
                        <h5 class="modal-title">Gambar</h5>
                        <button type="button" class="close" data-bs-dismiss="modal" aria-label="Close">
                            <span aria-hidden="true">&times;</span>
                        </button>
                    </div>
                    <div class="modal-body">
                        <img src="uploads/lpbj/{{ $dd->gambar }}" class="img-fluid img-thumbnail">
                    </div>
                    <div class="modal-footer">
                        <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Kembali</button>
                    </div>
                </div>
            </div>
        </div>
    @endforeach --}}
    {{-- /ModalTampilGambar --}}

    {{-- ScrollToTop --}}
    <a href="#" id="scroll-top" class="scroll-top d-flex align-items-center justify-content-center"><i
            class="bi bi-arrow-up-short"></i></a>
=======
=======
>>>>>>> Stashed changes
=======
>>>>>>> Stashed changes
    {{-- ModalTampilFile --}}
    <div class="modal fade" id="modalFile" tabindex="-1" aria-hidden="true">
        <div class="modal-dialog modal-xl">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title">File Attachment</h5>
                </div>
                <div class="modal-body">
                    <embed src="{{ url('/lampiran/' . $dataHeader->hdrid) }}" type="application/pdf" frameBorder="0"
                        height="400px" width="100%"></embed>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Kembali</button>
                </div>
            </div>
        </div>
    </div>
    {{-- /ModalTampilFile --}}

    {{-- ModalTampilGR --}}
    <div class="modal fade" id="modalGR" tabindex="-1" aria-hidden="true">
        <div class="modal-dialog modal-xl">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title">File GR</h5>
                </div>
                <div class="modal-body">
                    <embed src="{{ url('/docgr/' . $dataHeader->hdrid) }}" type="application/pdf" frameBorder="0"
                        height="400px" width="100%"></embed>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Kembali</button>
                </div>
            </div>
        </div>
    </div>
    {{-- /ModalTampilGR --}}

    {{-- ModalClosePO --}}
    <div class="modal fade" id="modalClose" tabindex="-1" aria-hidden="true">
        <div class="modal-dialog modal-md">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title">Upload Bukti GR</h5>
                </div>
                <form action="{{ url('/closepo') }}" method="post" onsubmit="return yakin()"
                    enctype="multipart/form-data">
                    @csrf
                    <div class="modal-body">
                        <label>Dokumen Bukti GR:</label>
                        <input type="text" name="qeid" value="{{ $dataHeader->hdrid }}" hidden>
                        <input class="form-control" type="file" accept="application/pdf"
                            onchange="validate(this.value);" id="buktigr" name="buktigr" required>
                    </div>
                    <div class="modal-footer">
                        <button type="submit" class="btn btn-primary">Close LPBJ</button>
                        <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Kembali</button>
                    </div>
                </form>
            </div>
        </div>
    </div>
    {{-- /ModalClosePO --}}

    @include('template.footer')
>>>>>>> Stashed changes

    {{-- VendorJS --}}
    {{-- MainJS --}}
    <script src="{{ asset('js/lpbj/main.js') }}"></script>
    <script src="{{ asset('js/bootstrap.min.js') }}"></script>
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

<<<<<<< Updated upstream
=======
    <script type="text/javascript">
        $("#history").addClass("active");

        function validate(fileName) {
            let a = document.getElementById("buktigr");
            let ext = new Array("pdf");
            let limit = 1700000;
            let fileext = fileName.split('.').pop().toLowerCase();

            if (ext.includes(fileext) && a.files[0].size < limit) {
                return true;
            } else if (!ext.includes(fileext)) {
                a.value = null;
                alert('Format file tidak sesuai');
            } else if (a.files[0].size > limit) {
                a.value = null;
                alert('Maximum ukuran file 1,5Mb');
            }
        }

        function yakin() {
            var result = confirm("Apa anda yakin ingin Close LPBJ?");
            if (result) {
                return true;
            } else {
                return false;
            }
        }
    </script>

>>>>>>> Stashed changes
</body>

</html>
