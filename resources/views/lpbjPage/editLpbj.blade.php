<!DOCTYPE html>
<html lang="en">

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link rel="icon" type="image/x-icon" href="{{ asset('img/logo.png') }}">
    <title>Edit {{ $title }}</title>

    {{-- Style CSS --}}
    {{-- Vendor CSS Files --}}
    <link href="{{ asset('css/lpbj/main.css') }}" rel="stylesheet">
    <link href="{{ asset('css/bootstrap.min.css') }}" rel="stylesheet">
    <link href="{{ asset('vendor/bootstrap/css/bootstrap.min.css') }}" rel="stylesheet">
    <link href="{{ asset('vendor/bootstrap-icons/bootstrap-icons.css') }}" rel="stylesheet">
    <link href="{{ asset('vendor/aos/aos.css') }}" rel="stylesheet">
    <link href="{{ asset('vendor/glightbox/css/glightbox.min.css') }}" rel="stylesheet">
    <link href="{{ asset('vendor/swiper/swiper-bundle.min.css') }}" rel="stylesheet">

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
            <img src="{{ asset('img/logo.png') }}" alt="" class="img-fluid rounded-circle">
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
        {{-- DataUser --}}
        <section class="about section">
            <div class="container" data-aos="fade-up" data-aos-delay="100">
                <div class="row gy-4 justify-content-center">
                    <div class="col-lg-12 content">
                        <h2 class="mb-4">Edit {{ $title }}</h2>
                        {{-- DataPegawai --}}
                        <div class="row">
                            <div class="col-lg-6">
                                <ul>
                                    <li><i class="bi bi-chevron-right"></i> <strong>No LPBJ :</strong>
                                        <span>{{ $header->nolpbj }}</span>
                                    </li>
                                    <li><i class="bi bi-chevron-right"></i> <strong>Company Code :</strong>
                                        <span>{{ $header->companycode }}</span>
                                    </li>
                                    <li><i class="bi bi-chevron-right"></i> <strong>Tanggal Permintaan :</strong>
                                        <span>{{ $header->tglpermintaan }}</span>
                                    </li>
                                </ul>
                            </div>
                        </div>
                        {{-- /DataPegawai --}}
                    </div>
                </div>
                <hr>
                {{-- FormPengajuan --}}
                <form action="{{ url('/ajukanlpbjedit') }}" method="post">
                    @csrf
                    <input {{ $hdrid }} type="text" hidden>
                    <div class="row align-items-end">
                        <div class="col-sm-3 mb-2">
                            <label>Status Dokumen:</label>
                            <select class="form-control" name="pilihan" id="pilihan" required>
                                <option value="" disabled selected hidden>Pilih Status Dokumen...</option>
                                <option id="drf" value="drf">Save As Draft</option>
                                <option id="doc" value="doc">Save As Document</option>
                            </select>
                        </div>
                        <div class="col-sm-4 mb-2">
                            <label>Description :</label>
                            <input class="form-control" type="text" name="descLPBJ" id="descLPBJ"
                                placeholder="Isi Sesuai dengan kebutuhan LPBJ" autocomplete="off" required>
                        </div>
                        <div class="col-sm-4 mb-2">
                            <button type="button" onclick="tambahData()" class="btn btn-outline-success">
                                Tambah Data
                            </button>
                        </div>
                    </div>
                    <br>
                    <table class="table-responsive-sm table-hover table-bordered col-sm-12">
                        <thead class="table-primary text-center">
                            <tr>
                                <th>No</th>
                                <th>Article</th>
                                <th>Remark</th>
                                <th>Qty</th>
                                <th>Store</th>
                                <th>Acc Assign</th>
                                <th>Keterangan</th>
                                <th>Action</th>
                            </tr>
                        </thead>
                        <tbody class="text-center">
                            @foreach ($detail as $d)
                                <tr>
                                    <td></td>
                                    <td>{{ $d->articlecode }}</td>
                                    <td>{{ $d->remark }}</td>
                                    <td>{{ $d->qty }}</td>
                                    <td>{{ $d->sitecode }}</td>
                                    <td>{{ $d->accassign }}</td>
                                    <td>{{ $d->keterangan }}</td>
                                    <td style="width: 10%">
                                        <a href="{{ url("/lpbjedt/$d->dtlid") }}"
                                            class="btn btn-outline-primary btn-sm">
                                            <i class="bi bi-pencil"></i>
                                        </a>
                                        <a href="{{ url("/lpbjdel/$d->dtlid") }}"
                                            class="btn btn-outline-danger btn-sm">
                                            <i class="bi bi-trash"></i>
                                        </a>
                                    </td>
                                </tr>
                            @endforeach
                        </tbody>
                    </table>
                    <br>
                    <div class="row">
                        <div class="col-sm-12">
                            <label for="noteLPBJ">Note :</label>
                            <textarea class="form-control" name="noteLPBJ" id="noteLPBJ" cols="40" rows="5"
                                placeholder="Catatan untuk LPBJ" autocomplete="off"></textarea>
                            <br>
                        </div>
                    </div>
                    <div class="modal-footer">
                        <button class="btn btn-primary" type="submit">Submit</button>
                    </div>
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

    <script type="text/javascript">
        let sessjdl = "{{ session('jdl') }}";
        let sessnote = "{{ session('note') }}";
        let sessdoc = "{{ session('doc') }}";

        document.getElementById('descLPBJ').value = sessjdl;
        document.getElementById('noteLPBJ').value = sessnote;
        document.getElementById(sessdoc).selected = true;

        function tambahData() {
            let jdl = document.querySelector('#descLPBJ').value;
            let note = document.querySelector('#noteLPBJ').value;
            let doc = document.querySelector('#pilihan').value;
            let params = jdl + '|' + note + '|' + doc;

            if (doc == '') {
                alert('Pilih Status Dokumen terlebih dahulu');
            } else {
                window.location.href = "{{ url('/tempedit') }}" + "/" + params;
            }

        }
    </script>

</body>

</html>
