<!DOCTYPE html>
<html lang="en">

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link rel="icon" type="image/x-icon" href="{{ asset('img/logo.png') }}">
    <title>Pengajuan {{ $title }}</title>

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
            <img src="{{ asset('img/logo.jpg') }}" alt="" class="img-fluid rounded-circle">
        </div>

        <a class="logo d-flex align-items-center justify-content-center">
            <h1 class="sitename">{{ $title }}</h1>
        </a>

        <nav id="navmenu" class="navmenu">
            <ul>
                @if (substr(session('groupname'), 0, 8) != 'APPROVER')
                    <li><a href="{{ url('/pengajuanlpbj') }}" class="active">
                            <i class="bi bi-clipboard2-plus navicon"></i>
                            Pengajuan</a>
                    </li>
                @endif
                <li><a href="{{ url('/historylpbj') }}"><i class="bi bi-clock-history navicon"></i>History</a>
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
                        <h2 class="mb-4">Pengajuan {{ $title }}</h2>
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
                                    <li><i class="bi bi-chevron-right"></i> <strong>User Role :</strong>
                                        <span>{{ $dataPegawai->userrole }}</span>
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
                <form action="{{ url('/ajukanlpbj') }}" method="post">
                    @csrf
                    <div class="row">
                        <div class="col-sm-3 mb-2">
                            <select class="form-control" name="pilihan" id="pilihan" required>
                                <option value="" disabled selected hidden>Pilih Status Dokumen...</option>
                                <option id="drf" value="drf">Save As Draft</option>
                                <option id="doc" value="doc">Save As Document</option>
                            </select>
                        </div>
                    </div>
                    <div class="row align-items-end">
                        <div class="col-sm-3 mb-2">
                            <label>Company Code :</label>
                            <select class="form-control" name="companyCode" id="companyCode" required>
                                <option value="" disabled selected hidden>Pilih Company Code...</option>
                                <option id="EC01" value="EC01">EC01 - Electronic City</option>
                                <option id="E013" value="E013">E013 - Elang Cakrawala Inti</option>
                                <option id="G015" value="G015">G015 - Groceries City</option>
                            </select>
                        </div>
                        <div class="col-sm-4 mb-2">
                            <label>Description :</label>
                            <input class="form-control" type="text" name="descLPBJ" id="descLPBJ"
                                placeholder="Isi Sesuai dengan kebutuhan LPBJ" autocomplete="off" required>
                        </div>
                        <div class="col-sm-4 mb-2">
                            <button type="button" onclick="tambahData()" class="btn btn-outline-success">Tambah
                                Data</button>
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
                            @foreach ($dataDraft as $d)
                                <tr>
                                    <td></td>
                                    <td>{{ $d->articlecode }}</td>
                                    <td>{{ $d->remark }}</td>
                                    <td>{{ $d->qty }}</td>
                                    <td>{{ $d->sitecode }}</td>
                                    <td>{{ $d->accassign }}</td>
                                    <td>{{ $d->keterangan }}</td>
                                    <td style="width: 20%">
                                        <a href="{{ url("/cekdraftlpbj/$d->id") }}"
                                            class="btn btn-outline-success btn-sm">
                                            <i class="bi bi-search"></i></a>
                                        <a href="{{ url("/deldraftlpbj/$d->id") }}"
                                            class="btn btn-outline-danger btn-sm">
                                            <i class="bi bi-trash"></i></a>
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
                        @if ($dataDraft)
                            <button class="btn btn-primary" type="submit">Submit</button>
                        @endif
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
        let sesscc = "{{ session('cc') }}";
        let sessjdl = "{{ session('jdl') }}";
        let sessnote = "{{ session('note') }}";
        let sessdoc = "{{ session('doc') }}";

        document.getElementById(sesscc).selected = true;
        document.getElementById('descLPBJ').value = sessjdl;
        document.getElementById('noteLPBJ').value = sessnote;
        document.getElementById(sessdoc).selected = true;

        function tambahData() {
            let cc = document.querySelector('#companyCode').value;
            let jdl = document.querySelector('#descLPBJ').value;
            let note = document.querySelector('#noteLPBJ').value;
            let doc = document.querySelector('#pilihan').value;
            let params = cc + '|' + jdl + '|' + note + '|' + doc;

            if (doc == '') {
                alert('Pilih Status Dokumen terlebih dahulu');
            } else if (cc == '') {
                alert('Pilih Company Code terlebih dahulu');
            } else {
                window.location.href = "{{ url('/tempsess') }}" + "/" + params;
            }

        }
    </script>

</body>

</html>
