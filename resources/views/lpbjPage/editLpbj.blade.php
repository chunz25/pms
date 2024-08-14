<!DOCTYPE html>
<html lang="en">

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link rel="icon" type="image/x-icon" href="{{ asset('img/logo.png') }}">
    <title>Edit {{ $title }}</title>

    @include('template.style')

    <script src="https://cdn.jsdelivr.net/npm/jquery@3.7.0/dist/jquery.min.js"></script>
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

    @include('template.tempLpbj')

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
                    <input value="{{ $hdrid }}" type="text" name="hdrid" hidden>
                    <input value="{{ $header->companycode }}" type="text" id="cc" hidden>
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
                            <button type="button" onclick="tambahData({{ $header->hdrid }})"
                                class="btn btn-outline-success">
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
                                        <button type="button" class="btn btn-outline-primary btn-sm"
                                            onclick="lpbjEdt({{ $d->dtlid }})">
                                            <i class="bi bi-pencil"></i>
                                        </button>
                                        <button onclick="lpbjDel({{ $d->dtlid }})" type="button"
                                            class="btn btn-outline-danger btn-sm">
                                            <i class="bi bi-trash"></i>
                                        </button>
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
                        <a href="javascript:history.back()" class="btn btn-secondary mr-2">Kembali</a>
                        <button class="btn btn-primary" type="submit">Submit</button>
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
    <script src="{{ asset('js/bootstrap.bundle.min.js') }}"></script>
    <script src="{{ asset('vendor/bootstrap/js/bootstrap.bundle.min.js') }}"></script>
    <script src="{{ asset('vendor/aos/aos.js') }}"></script>

    <script type="text/javascript">
        $("#history").addClass("active");

        let map = {
            '&': '&amp;',
            '<': '&lt;',
            '>': '&gt;',
            '"': '&quot;',
            "'": '&#039;'
        };

        let xx = "{{ session('jdl') }}";
        let sessjdl = xx.replace(/&amp;/g, "&").replace(/&lt;/g, "<").replace(/&gt;/g, ">").replace(/&quot;/g,
            '"').replace(/&#039;/g, "'");
        let x = "{{ session('note') }}";
        let sessnote = x.replace(/&amp;/g, "&").replace(/&lt;/g, "<").replace(/&gt;/g, ">").replace(/&quot;/g,
            '"').replace(/&#039;/g, "'");

        let sessdoc = "{{ session('doc') }}";
        let sesscc = "{{ session('cc') }}";

        document.getElementById('descLPBJ').value = sessjdl;
        document.getElementById('noteLPBJ').value = sessnote;
        document.getElementById(sessdoc).selected = true;

        function tambahData(a) {
            let jdl = document.querySelector('#descLPBJ').value;
            let cc = document.querySelector('#cc').value;
            let note = document.querySelector('#noteLPBJ').value;
            let doc = document.querySelector('#pilihan').value;
            let params = jdl + '|' + note + '|' + doc + '|' + a + '|' + cc;

            if (doc == '') {
                alert('Pilih Status Dokumen terlebih dahulu');
            } else {
                window.location.href = "{{ url('/tempeditadd') }}" + "/" + params;
            }
        }

        function lpbjEdt(a) {
            let jdl = document.querySelector('#descLPBJ').value;
            let cc = document.querySelector('#cc').value;
            let note = document.querySelector('#noteLPBJ').value;
            let doc = document.querySelector('#pilihan').value;
            let params = jdl + '|' + note + '|' + doc + '|' + a + '|' + cc;

            window.location.href = "{{ url('/tempedit') }}" + "/" + params;

        }

        function lpbjDel(a) {
            let jdl = document.querySelector('#descLPBJ').value;
            let cc = document.querySelector('#cc').value;
            let note = document.querySelector('#noteLPBJ').value;
            let doc = document.querySelector('#pilihan').value;
            let params = jdl + '|' + note + '|' + doc + '|' + a + '|' + cc;

            window.location.href = "{{ url('/tempdel') }}" + "/" + params;

        }
    </script>

</body>

</html>
