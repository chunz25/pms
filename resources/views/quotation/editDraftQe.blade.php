<!DOCTYPE html>
<html lang="en">

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link rel="icon" type="image/x-icon" href="{{ asset('img/logo.png') }}">
    <title>Edit Vendor QE</title>

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
        {{-- FormPengajuan --}}
        <section class="about section">
            <div class="container" data-aos="fade-up" data-aos-delay="100">
                <div class="row gy-4 justify-content-center">
                    <div class="col-lg-12 content">
                        <h2 class="mb-1">Edit Vendor Qe</h2>
                    </div>
                </div>
                <br>
                <form class="form-horizontal form-label-left" action="{{ url('/updatedraftqe') }}" method="post"
                    enctype="multipart/form-data">
                    @csrf
                    <input type="text" name="hdrid" value="{{ $getDtl[0]->hdrid }}" hidden>
                    <div class="row">
                        <div class="col-sm-2">
                            <input class="form-control" type="text" id="vendorcode" name="vendorcode"
                                data-bs-toggle="modal" data-bs-target="#vendorModal" autocomplete="off" required
                                value="{{ $getDtl[0]->vendorcode }}" readonly>
                        </div>
                        <div class="col-sm-4">
                            <input class="form-control" type="text" id="vendorname" name="vendorname"
                                autocomplete="off" required placeholder="Vendor Description"
                                value="{{ $getDtl[0]->vendorname }}" readonly>
                        </div>
                    </div>
                    <br>
                    <div class="form-check form-switch mb-2">
                        <input class="form-check-input" type="checkbox" role="switch" id="pilih" name="pilih"
                            value="{{ $getDtl[0]->ispilih }}">
                        <label class="form-check-label" for="pilih">Vendor Pilihan</label>
                    </div>
                    <div class="row mb-2">
                        <div class="col-sm-4">
                            <label>Attachment:</label>
                            <input class="form-control" type="file" accept="application/pdf"
                                onchange="validate(this.value);" id="attach" name="attach" required>
                        </div>
                    </div>
                    <div class="row">
                        <div class="col-sm-5">
                            <label>Franco:</label>
                            <input class="form-control" type="text" id="franco" name="franco"
                                autocomplete="off" value="{{ $getDtl[0]->franco }}" required>
                        </div>
                        <div class="col-sm-4">
                            <label>PKP / Non PKP:</label>
                            <select class="form-control" name="pkp" id="pkp" required>
                                <option value="" disabled hidden>Pilih Salah Satu</option>
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
                                autocomplete="off" min="{{ date('Y-m-d') }}" value="{{ $getDtl[0]->term }}"
                                onkeydown="return false" required>
                        </div>
                        <div class="col-sm-2">
                            <label>T.O.P:</label>
                            <input class="form-control" type="text" id="top" name="top"
                                autocomplete="off" value="{{ $getDtl[0]->top }}">
                        </div>
                        <div class="col-sm-1">
                            <label>Tax:</label>
                            <input type="text" id="taxamt" name="taxamt" value="{{ $getDtl[0]->taxamt }}"
                                hidden>
                            <input type="text" id="taxcode" name="taxcode" value="{{ $getDtl[0]->taxcode }}"
                                hidden>
                            <input class="form-control" type="text" id="taxname" name="taxname"
                                value="{{ $getDtl[0]->persen }}" onkeydown="return false" data-bs-toggle="modal"
                                data-bs-target="#taxModal" autocomplete="off" required>
                        </div>
                    </div>
                    <br>
                    <div class="row">
                        <div class="col-sm-5">
                            <label>Contact Person:</label>
                            <input class="form-control" type="text" id="person" name="person"
                                value="{{ $getDtl[0]->contactperson }}" autocomplete="off">
                        </div>
                        <div class="col-sm-5">
                            <label>Phone Number:</label>
                            <input class="form-control" type="text" id="telp" name="telp"
                                value="{{ $getDtl[0]->notelp }}" autocomplete="off">
                        </div>
                    </div>
                    <br>
                    <div class="row">
                        <div class="col-sm-5">
                            <label>Remark:</label>
                            <textarea class="form-control" id="remark" name="remark" autocomplete="off" cols="50" rows="4">{{ $getDtl[0]->remark }}</textarea>
                        </div>
                    </div>
                    <hr>
                    @foreach ($getDtl as $d)
                        <p>
                        <h4><strong>Article </strong>{{ $d->articlecode }}</h4>
                        </p>
                        <input type="text" name="dtlid[]" value="{{ $d->dtlid }}" hidden>
                        <div class="row">
                            <div class="col-sm-4">
                                <label>Article Code:</label>
                                <input class="form-control" type="text" id="articlecode" name="articlecode[]"
                                    value="{{ $d->articlecode }}" disabled>
                            </div>
                            <div class="col-sm-2">
                                <label>Qty:</label>
                                <input class="form-control text-right" type="text" id="qty{{ $d->dtlid }}"
                                    name="qty[]" value="{{ $d->qty }}" disabled>
                            </div>
                            <div class="col-sm-3">
                                <label>Harga Satuan:</label>
                                <input class="form-control text-right" type="number" id="satuan{{ $d->dtlid }}"
                                    name="satuan[]" min="1" value="{{ $d->satuan }}"
                                    onkeyup="hitungTotal{{ $d->dtlid }}(this.value)" required>
                            </div>
                        </div>
                        <br>
                        <div class="row mb-2">
                            <div class="col-sm-3">
                                <label>Total:</label>
                                <input onkeydown="return false" class="form-control text-right" type="number"
                                    id="total{{ $d->dtlid }}" name="total[]" min="1"
                                    value="{{ $d->total }}" readonly>
                            </div>
                            <div class="col-sm-3">
                                <label>Tax:</label>
                                <input onkeydown="return false" class="form-control text-right" type="number"
                                    id="pajak{{ $d->dtlid }}" name="pajak[]" min="1"
                                    value="{{ $d->tax }}" readonly>
                            </div>
                            <div class="col-sm-3">
                                <label>Grand Total:</label>
                                <input onkeydown="return false" class="form-control text-right" type="number"
                                    id="gtotal{{ $d->dtlid }}" name="gtotal[]" min="1"
                                    value="{{ $d->gtotal }}" readonly>
                            </div>
                        </div>
                        <div class="row">
                            <div class="col-sm-5">
                                <label>Remark QA:</label>
                                <input class="form-control" type="text" name="remarkqa[]"
                                    value="{{ $d->remarkqa }}" autocomplete="off">
                            </div>
                        </div>
                        <br>
                        <hr>
                    @endforeach
                    <div class="modal-footer">
                        <a href="javascript:history.back()" class="btn btn-secondary mr-2">Kembali</a>
                        <button class="btn btn-primary" type="submit">Simpan</button>
                    </div>
                </form>
            </div>
        </section>
        {{-- /FormPengajuan --}}
    </main>

    {{-- TaxModal --}}
    <div class="modal fade" id="taxModal" tabindex="-1" aria-hidden="true">
        <div class="modal-dialog modal-lg">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title" id="exampleModalLabel">List Vendor</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                </div>
                <div class="modal-body">
                    <table class="table table-bordered datatable" id="tbTax">
                        <thead>
                            <tr>
                                <th style="width: 10%">No</th>
                                <th style="width: 20%">Tax Code</th>
                                <th>Tax Name</th>
                                <th>Tax Amount</th>
                                <th class="text-center" style="width: 20%">Action</th>
                            </tr>
                        </thead>
                        <tbody>
                            @foreach ($getTax as $t)
                                <tr>
                                    <td style="width: 10%"></td>
                                    <td style="width: 20%">{{ $t->tax_code }}</td>
                                    <td>{{ $t->tax_name }}</td>
                                    <td>{{ $t->persen }}</td>
                                    <td class="text-center" style="width: 20%">
                                        <button type="button"
                                            onclick="addTax('{{ $t->persen }}','{{ $t->amt }}')"
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
    {{-- /TaxModal --}}

    {{-- VendorModal --}}
    <div class="modal fade" id="vendorModal" tabindex="-1" aria-hidden="true">
        <div class="modal-dialog modal-lg">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title" id="exampleModalLabel">List Vendor</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                </div>
                <div class="modal-body">
                    <table class="table table-bordered datatable" id="tbVendor">
                        <thead>
                            <tr>
                                <th style="width: 10%">No</th>
                                <th style="width: 20%">Vendor Code</th>
                                <th>Vendor Name</th>
                                <th class="text-center" style="width: 20%">Action</th>
                            </tr>
                        </thead>
                        <tbody>
                            @foreach ($getVendor as $v)
                                <tr>
                                    <td style="width: 10%"></td>
                                    <td style="width: 20%">{{ $v->supplierCode }}</td>
                                    <td>{{ $v->name }}</td>
                                    <td class="text-center" style="width: 20%">
                                        <button type="button"
                                            onclick="addVendor('{{ $v->supplierCode }}','{{ $v->name }}')"
                                            class="btn btn-outline-success btn-sm" data-bs-dismiss="modal">
                                            Pilih Vendor
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
    {{-- /VendorModal --}}

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
        $("#pengajuan").addClass("active");

        let pilih = "{{ $getDtl[0]->ispilih }}";
        let pkp = "{{ $getDtl[0]->ispkp }}";
        let a = document.getElementById("attach");
        let z = '';
        let attach = new File(['test'], "{{ $getDtl[0]->attachment }}", {
            type: 'application/pdf'
        });

        const dataTransfer = new DataTransfer();
        dataTransfer.items.add(attach);
        a.files = dataTransfer.files;

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

        $(document).ready(function() {

            const tbVendor = new DataTable('#tbVendor', {
                columnDefs: [{
                    searchable: false,
                    orderable: false,
                    targets: 0
                }],
                order: [
                    [1, 'asc']
                ]
            });
            tbVendor.on('order.dt search.dt', function() {
                let i = 1;

                tbVendor.cells(null, 0, {
                        search: 'applied',
                        order: 'applied'
                    })
                    .every(function(cell) {
                        this.data(i++);
                    });
            }).draw();

            const tbTax = new DataTable('#tbTax', {
                columnDefs: [{
                    searchable: false,
                    orderable: false,
                    targets: 0
                }],
                order: [
                    [1, 'asc']
                ]
            });
            tbTax.on('order.dt search.dt', function() {
                let i = 1;

                tbTax.cells(null, 0, {
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

        function addVendor(c, n) {
            $('#vendorcode').val(c);
            $('#vendorname').val(n);
        }

        function addTax(c, n) {
            $('#taxname').val(c);
            $('#taxamt').val(n);

            @foreach ($getDtl as $d)
                $("#satuan{{ $d->dtlid }}").val('');
                $("#total{{ $d->dtlid }}").val('');
                $("#pajak{{ $d->dtlid }}").val('');
                $("#gtotal{{ $d->dtlid }}").val('');
            @endforeach
        }

        @foreach ($getDtl as $d)
            function hitungTotal{{ $d->dtlid }}($a) {
                let qty = $('#qty{{ $d->dtlid }}').val();
                let pjk = $('#taxamt').val();
                let total = $a * qty;
                let pajak = total * pjk;
                let gtotal = total + pajak;

                $('#total{{ $d->dtlid }}').val(total);
                $('#pajak{{ $d->dtlid }}').val(pajak);
                $('#gtotal{{ $d->dtlid }}').val(gtotal);
            }
        @endforeach

        function validate(fileName) {
            let a = document.getElementById("attach");
            let ext = new Array("pdf");
            let limit = 1700000;
            let fileext = fileName.split('.').pop().toLowerCase();

            // console.log(a.files[0].size);
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
    </script>
</body>

</html>
