<!DOCTYPE html>
<html lang="en">

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link rel="icon" type="image/x-icon" href="{{ asset('img/logo.png') }}">
    <title>Detail Vendor QE</title>

    @include('template.style')

    <link href="{{ asset('css/lpbj/articleSearch.css') }}" rel="stylesheet">

    <link href="https://fonts.googleapis.com/icon?family=Material+Icons" rel="stylesheet">
    <script src="https://cdn.jsdelivr.net/npm/jquery@3.7.0/dist/jquery.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.0.2/dist/js/bootstrap.min.js"></script>
    <link href="https://cdn.datatables.net/1.13.4/css/jquery.dataTables.min.css" rel="stylesheet">
    <script src="https://cdn.datatables.net/1.13.4/js/jquery.dataTables.min.js"></script>
</head>

<body class="index-page">

    @include('template.tempQe')

    <main class="main">
        <section class="about section">
            <div class="container" data-aos="fade-up" data-aos-delay="100">
                <div class="row gy-4 justify-content-center">
                    <div class="col-lg-12 content">
                        <h2 class="mb-1">Detail Vendor Qe</h2>
                    </div>
                </div>
                <br>
                <div class="row">
                    <div class="col-sm-2">
                        <input class="form-control" type="text" id="vendorcode" name="vendorcode"
                            value="{{ $getDtl[0]->vendorcode }}" readonly>
                    </div>
                    <div class="col-sm-4">
                        <input class="form-control" type="text" id="vendorname" name="vendorname"
                            placeholder="Vendor Description" value="{{ $getDtl[0]->vendorname }}" readonly>
                    </div>
                </div>
                <br>
                <div class="form-check form-switch mb-2">
                    <input class="form-check-input" type="checkbox" role="switch" id="pilih" name="pilih"
                        value="{{ $getDtl[0]->ispilih }}" disabled>
                    <label class="form-check-label" for="pilih">Vendor Pilihan</label>
                </div>
                <div class="row mb-2">
                    <div class="col-sm-2">
                        <label>Attachment:</label>
                        <button type="button" class="btn btn-sm btn-outline-success form-control"
                            data-bs-toggle="modal" data-bs-target="#modalFile">
                            <i class="bi bi-filetype-pdf"></i> Lihat File
                        </button>
                    </div>
                </div>
                <div class="row">
                    <div class="col-sm-5">
                        <label>Franco:</label>
                        <input class="form-control" type="text" id="franco" name="franco"
                            value="{{ $getDtl[0]->franco }}" readonly>
                    </div>
                    <div class="col-sm-4">
                        <label>PKP / Non PKP:</label>
                        <select class="form-control" name="pkp" id="pkp" disabled>
                            <option id="pkpyes" value="1">PKP</option>
                            <option id="pkpno" value="0">Non PKP</option>
                        </select>
                    </div>
                </div>
                <br>
                <div class="row">
                    <div class="col-sm-3">
                        <label>Delivery Term:</label>
                        <input class="form-control" type="date" name="term" id="term"
                            min="{{ date('Y-m-d') }}" value="{{ $getDtl[0]->term }}" readonly>
                    </div>
                    <div class="col-sm-2">
                        <label>T.O.P:</label>
                        <input class="form-control" type="text" id="top" name="top"
                            value="{{ $getDtl[0]->top }}" readonly>
                    </div>
                    <div class="col-sm-1">
                        <label>Tax:</label>
                        <input class="form-control" type="text" id="taxname" name="taxname"
                            value="{{ $getDtl[0]->persen }}"readonly>
                    </div>
                </div>
                <br>
                <div class="row">
                    <div class="col-sm-5">
                        <label>Contact Person:</label>
                        <input class="form-control" type="text" id="person" name="person"
                            value="{{ $getDtl[0]->contactperson }}" readonly>
                    </div>
                    <div class="col-sm-5">
                        <label>Phone Number:</label>
                        <input class="form-control" type="text" id="telp" name="telp"
                            value="{{ $getDtl[0]->notelp }}" readonly>
                    </div>
                </div>
                <br>
                <div class="row">
                    <div class="col-sm-5">
                        <label>Remark:</label>
                        <textarea class="form-control" id="remark" name="remark" cols="50" rows="4" readonly>{{ $getDtl[0]->remark }}</textarea>
                    </div>
                </div>
                <hr>
                @foreach ($getDtl as $d)
                    <p>
                    <h4><strong>Article </strong>{{ $d->articlecode }}</h4>
                    </p>
                    <div class="row">
                        <div class="col-sm-4">
                            <label>Article Code:</label>
                            <input class="form-control" type="text" id="articlecode" name="articlecode[]"
                                value="{{ $d->articlecode }}" readonly>
                        </div>
                        <div class="col-sm-2">
                            <label>Qty:</label>
                            <input class="form-control text-right" type="text" id="qty{{ $d->dtlid }}"
                                name="qty[]" value="{{ $d->qty }}" readonly>
                        </div>
                        <div class="col-sm-3">
                            <label>Harga Satuan:</label>
                            <input class="form-control text-right" type="number" id="satuan{{ $d->dtlid }}"
                                name="satuan[]" min="1" value="{{ $d->satuan }}" readonly>
                        </div>
                    </div>
                    <br>
                    <div class="row mb-2">
                        <div class="col-sm-3">
                            <label>Total:</label>
                            <input class="form-control text-right" type="number" id="total{{ $d->dtlid }}"
                                name="total[]" min="1" value="{{ $d->total }}" readonly>
                        </div>
                        <div class="col-sm-3">
                            <label>Tax:</label>
                            <input class="form-control text-right" type="number" id="pajak{{ $d->dtlid }}"
                                name="pajak[]" min="1" value="{{ $d->tax }}" readonly>
                        </div>
                        <div class="col-sm-3">
                            <label>Grand Total:</label>
                            <input class="form-control text-right" type="number" id="gtotal{{ $d->dtlid }}"
                                name="gtotal[]" min="1" value="{{ $d->gtotal }}" readonly>
                        </div>
                    </div>
                    <div class="row">
                        <div class="col-sm-5">
                            <label>Remark QA:</label>
                            <input class="form-control" type="text" name="remarkqa[]"
                                value="{{ $d->remarkqa }}" readonly>
                        </div>
                    </div>
                    <br>
                    <hr>
                @endforeach
                <div class="modal-footer">
                    <a href="javascript:history.back()" class="btn btn-secondary mr-2">Kembali</a>
                </div>

            </div>
        </section>
    </main>

    {{-- ModalTampilFile --}}
    <div class="modal fade" id="modalFile" tabindex="-1" aria-hidden="true">
        <div class="modal-dialog modal-xl">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title">File Attachment</h5>
                </div>
                <div class="modal-body">
                    <embed src="{{ url('/pdf/' . $getDtl[0]->attachment) }}" type="application/pdf" frameBorder="0"
                        height="400px" width="100%"></embed>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Kembali</button>
                </div>
            </div>
        </div>
    </div>
    {{-- /ModalTampilFile --}}

    @include('template.footer')

    {{-- VendorJS --}}
    {{-- MainJS --}}
    <script src="{{ asset('js/lpbj/main.js') }}"></script>
    <script src="{{ asset('js/bootstrap.min.js') }}"></script>
    <script src="{{ asset('vendor/bootstrap/js/bootstrap.bundle.min.js') }}"></script>
    <script src="{{ asset('vendor/aos/aos.js') }}"></script>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@4.6.2/dist/js/bootstrap.bundle.min.js"
        integrity="sha384-Fy6S3B9q64WdZWQUiU+q4/2Lc9npb8tCaSX9FK7E8HnRr0Jz8D6OP9dO5Vg3Q9ct" crossorigin="anonymous">
    </script>

    <script type="text/javascript">
        $("#history").addClass("active");

        let pilih = "{{ $getDtl[0]->ispilih }}";
        let pkp = "{{ $getDtl[0]->ispkp }}";
        let z = '';

        if (pilih == 1) {
            $('#pilih').prop('checked', true);
        }

        if (pkp == 1) {
            let z = 'pkpyes';
            document.getElementById(z).selected = true;
        } else {
            let z = 'pkpno';
            document.getElementById(z).selected = true;
        }
    </script>
</body>

</html>
