<!DOCTYPE html>
<html lang="en">

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link rel="icon" type="image/x-icon" href="{{ asset('img/logo.png') }}">
    <title>Pengajuan {{ $title }}</title>

    @include('template.style')

    <script src="https://cdn.jsdelivr.net/npm/jquery@3.7.0/dist/jquery.min.js"></script>

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

    @include('template.tempLpbj')

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
                                <option value="" disabled selected hidden>Status Dokumen</option>
                                <option id="drf" value="drf">Save As Draft</option>
                                <option id="doc" value="doc">Save As Document</option>
                            </select>
                        </div>
                        <div class="col-sm-3 mb-2">
                            <select class="form-control" name="companyCode" id="companyCode" required>
                                <option value="" disabled selected hidden>Company Code</option>
                                <option id="EC01" value="EC01">EC01 - Electronic City</option>
                                <option id="E013" value="E013">E013 - Elang Cakrawala Inti</option>
                                <option id="G015" value="G015">G015 - Groceries City</option>
                            </select>
                        </div>
                        <div class="col-sm-4 mb-2">
                            <input class="form-control" type="text" name="descLPBJ" id="descLPBJ"
                                placeholder="Description" autocomplete="off" required>
                        </div>
                        <div class="col-sm-2 mb-2">
                            <button type="button" onclick="tambahData()" class="btn btn-success">
                                <i class="bi bi-plus-circle"></i>
                                Tambah Data
                            </button>
                        </div>
                    </div>
                    <br>
                    <div class="table-responsive-sm col-sm-12 mb-2">
                        <table class="table table-hover table-bordered">
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
                                        <td style="width: 10%">
                                            {{-- <a href="{{ url("/cekdraftlpbj/$d->id") }}"
                                                class="btn btn-outline-success btn-sm">
                                                <i class="bi bi-search"></i></a> --}}
                                            <a href="{{ url("/deldraftlpbj/$d->id") }}"
                                                class="btn btn-outline-danger btn-sm">
                                                <i class="bi bi-trash"></i></a>
                                        </td>
                                    </tr>
                                @endforeach
                            </tbody>
                        </table>
                    </div>
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

    @include('template.footer')

    {{-- VendorJS --}}
    {{-- MainJS --}}
    <script src="{{ asset('js/lpbj/main.js') }}"></script>
    <script src="{{ asset('js/bootstrap.min.js') }}"></script>
    <script src="{{ asset('vendor/bootstrap/js/bootstrap.bundle.min.js') }}"></script>
    <script src="{{ asset('vendor/aos/aos.js') }}"></script>

    <script type="text/javascript">
        @if (Session::has('pesan'))
            alert("{{ Session::get('pesan') }}");
        @endif

        $("#pengajuan").addClass("active");

        let map = {
            '&': '&amp;',
            '<': '&lt;',
            '>': '&gt;',
            '"': '&quot;',
            "'": '&#039;'
        };
        let sesscc = "{{ session('cc') }}";
        let xx = "{{ session('jdl') }}";
        let sessjdl = xx.replace(/&amp;/g, "&").replace(/&lt;/g, "<").replace(/&gt;/g, ">").replace(/&quot;/g,
            '"').replace(/&#039;/g, "'");
        let x = "{{ session('note') }}";
        let sessnote = x.replace(/&amp;/g, "&").replace(/&lt;/g, "<").replace(/&gt;/g, ">").replace(/&quot;/g,
            '"').replace(/&#039;/g, "'");
        let sessdoc = "{{ session('doc') }}";

        document.getElementById(sesscc).selected = true;
        document.getElementById("descLPBJ").value = sessjdl;
        document.getElementById("noteLPBJ").value = sessnote;
        document.getElementById(sessdoc).selected = true;

        function tambahData() {
            let cc = document.querySelector("#companyCode").value;
            let jdl = document.querySelector("#descLPBJ").value;
            let note = document.querySelector("#noteLPBJ").value;
            let doc = document.querySelector("#pilihan").value;
            let params = cc + ",|," + jdl + ",|," + note + ",|," + doc;

            if (doc == "") {
                alert("Pilih Status Dokumen terlebih dahulu");
            } else if (cc == "") {
                alert("Pilih Company Code terlebih dahulu");
            } else {
                window.location.href = "{{ url('/tempsess') }}" + "/" + params;
            }
        }

    </script>

</body>

</html>
