<!DOCTYPE html>
<html lang="en">

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link rel="icon" type="image/x-icon" href="{{ asset('img/logo.png') }}">
    <title>Tambah Vendor {{ $title }}</title>

    @include('template.style')

    <link href="https://cdn.datatables.net/1.13.4/css/jquery.dataTables.min.css" rel="stylesheet">
    <script src="https://cdn.datatables.net/1.13.4/js/jquery.dataTables.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/jquery@3.7.0/dist/jquery.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.0.2/dist/js/bootstrap.min.js"></script>

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

        .pdfobject-container {
            height: 500px;
            border: 1px solid #ccc;
        }
    </style>
</head>

<body class="index-page">

    @include('template.tempQe')

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

                <div class="row align-items-end mb-2">
                    <div class="col-sm-4 mb-2">
                        <form action="{{ url('/tambahvendor') }}" method="post">
                            @csrf
                            @foreach ($dataDtl as $d)
                                <input type="text" name="dtl[]" value="{{ $d->dtlid }}" hidden>
                                <input type="text" name="hdr[]" value="{{ $d->hdrid }}" hidden>
                                <input type="text" name="cc[]" value="{{ $d->companycode }}" hidden>
                            @endforeach
                            <button type="submit" class="btn btn-outline-success">Tambah Vendor</button>
                        </form>
                    </div>
                </div>

                {{-- FormPengajuan --}}
                <form onsubmit="return validasi()" action="{{ url('/ajukanqe') }}" method="post">
                    @csrf
                    @foreach ($iddtl as $c)
                        <input type="text" name="dtl[]" value="{{ $c }}" hidden>
                    @endforeach
                    @if ($dataDraft)
                        @foreach ($dataVendor as $v)
                            <div class="row mb-2">
                                <div class="col-sm-10">
                                    <span>
                                        <strong>{{ $v->vendorname }}</strong>
                                        @if ($v->ispilih == 1)
                                            <i class="bi bi-check2-all navicon"></i>
                                        @endif
                                    </span>
                                </div>
                                <div class="col-sm-2">
                                    <a class="btn btn-sm btn-outline-primary"
                                        href="{{ url("/editdraftqe/$v->hdrid,$v->vendorcode") }}">
                                        <i class="bi bi-pencil"></i>
                                    </a>
                                    <a class="btn btn-sm btn-outline-danger"
                                        href="{{ url("/deletedraftqe/$v->hdrid,$v->vendorcode") }}">
                                        <i class="bi bi-trash"></i>
                                    </a>
                                    <button type="button" class="btn btn-sm btn-outline-success" data-bs-toggle="modal"
                                        data-bs-target="#modalFile{{ $v->vendorcode }}">
                                        <i class="bi bi-filetype-pdf"></i>
                                    </button>
                                </div>
                            </div>
                            <table class="table table-responsive-sm table-hover table-bordered">
                                <thead class="table-primary text-center">
                                    <tr>
                                        <th>No</th>
                                        <th>Article</th>
                                        <th>Qty</th>
                                        <th>Harga Satuan</th>
                                        <th>Harga Total</th>
                                        <th>Tax</th>
                                        <th>Grand Total</th>
                                        <th>Remarks QA</th>
                                    </tr>
                                </thead>
                                <tbody class="text-center">
                                    @foreach ($dataDraft as $d)
                                        @if ($v->vendorname == $d->vendorname)
                                            <tr>
                                                <td></td>
                                                <td>{{ $d->articlecode }}</td>
                                                <td>{{ $d->qty }}</td>
                                                <td>{{ $d->satuan }}</td>
                                                <td>{{ $d->total }}</td>
                                                <td>{{ $d->tax }}</td>
                                                <td>{{ $d->gtotal }}</td>
                                                <td>{{ $d->remarkqa }}</td>
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
                        <a href="javascript: window.history.back()" class="btn btn-secondary mr-2">Kembali</a>
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
    @if ($dataVendor)
        @foreach ($dataVendor as $v)
            <div class="modal fade" id="modalFile{{ $v->vendorcode }}" tabindex="-1" aria-hidden="true">
                <div class="modal-dialog modal-xl">
                    <div class="modal-content">
                        <div class="modal-header">
                            <h5 class="modal-title">File Attachment</h5>
                        </div>
                        <div class="modal-body">
                            <embed src="{{ url("/pdf/$v->attachment") }}" type="application/pdf" frameBorder="0"
                                height="400px" width="100%"></embed>
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

        function validasi() {
            let sumPilih = {{ $sumVendor }};

            if (sumPilih > 1) {
                alert('Vendor pilihan hanya bisa 1');
                return false
            } else if (sumPilih < 1) {
                alert('Vendor pilihan harus ada');
                return false
            } else {
                return true
            }
        }
    </script>

</body>

</html>
