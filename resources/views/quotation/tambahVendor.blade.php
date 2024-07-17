<!DOCTYPE html>
<html lang="en">

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link rel="icon" type="image/x-icon" href="img/logo.png">
    <title>Tambah Vendor QE</title>

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
        {{-- FormPengajuan --}}
        <section class="about section">
            <div class="container" data-aos="fade-up" data-aos-delay="100">
                <div class="row gy-4 justify-content-center">
                    <div class="col-lg-12 content">
                        <h2 class="mb-1">Tambah Vendor Qe</h2>
                    </div>
                </div>
                <br>
                <form class="form-horizontal form-label-left" action="insertdraftqe" method="post"
                    enctype="multipart/form-data">
                    @csrf
                    <div class="row">
                        <div class="col-sm-2">
                            <input class="form-control" type="text" id="vendorcode" name="vendorcode"
                                data-bs-toggle="modal" data-bs-target="#vendorModal" autocomplete="off" required
                                placeholder="Pilih Vendor">
                        </div>
                        <div class="col-sm-4">
                            <input class="form-control" type="text" id="vendorname" name="vendorname"
                                autocomplete="off" required placeholder="Vendor Description" disabled>
                        </div>
                    </div>
                    <br>
                    <div class="form-check form-switch mb-2">
                        <input class="form-check-input" type="checkbox" role="switch" id="pilih" name="pilih"
                            value="1">
                        <label class="form-check-label" for="pilih">Vendor Pilihan</label>
                    </div>
                    <div class="row mb-2">
                        <div class="col-sm-4">
                            <label>Attachment:</label>
                            <input class="form-control" type="file" onchange="validate(this.value);"
                                id="attach" name="attach" required>
                        </div>
                    </div>
                    <div class="row">
                        <div class="col-sm-5">
                            <label>Franco:</label>
                            <input class="form-control" type="text" id="franco" name="franco"
                                autocomplete="off">
                        </div>
                        <div class="col-sm-4">
                            <label>PKP / Non PKP:</label>
                            <select class="form-control" name="pkp" id="pkp" required>
                                <option value="" disabled selected hidden>Pilih Salah Satu</option>
                                <option value="1">PKP</option>
                                <option value="0">Non PKP</option>
                            </select>
                        </div>
                    </div>
                    <br>
                    <div class="row">
                        <div class="col-sm-3">
                            <label>Delivery Term:</label>
                            <input class="form-control" type="date" name="term" id="term"
                                autocomplete="off" min="2024-07-17" onkeydown="return false">
                        </div>
                        <div class="col-sm-2">
                            <label>T.O.P:</label>
                            <input class="form-control" type="text" id="top" name="top"
                                autocomplete="off">
                        </div>
                        <div class="col-sm-1">
                            <label>Tax:</label>
                            <input type="text" id="taxamt" name="taxamt" hidden>
                            <input class="form-control" type="text" id="taxname" name="taxname"
                                onkeydown="return false" data-bs-toggle="modal" data-bs-target="#taxModal"
                                autocomplete="off">
                        </div>
                    </div>
                    <br>
                    <div class="row">
                        <div class="col-sm-5">
                            <label>Contact Person:</label>
                            <input class="form-control" type="text" id="person" name="person"
                                autocomplete="off">
                        </div>
                        <div class="col-sm-5">
                            <label>Phone Number:</label>
                            <input class="form-control" type="text" id="telp" name="telp"
                                autocomplete="off">
                        </div>
                    </div>
                    <br>
                    <div class="row">
                        <div class="col-sm-5">
                            <label>Remark:</label>
                            <input class="form-control" type="text" id="remark" name="remark"
                                autocomplete="off">
                        </div>
                    </div>
                    <hr>
                    @foreach ($getDtl as $d)
                        <p>
                        <h4><strong>Article </strong>{{ $d->articlecode }}</h4>
                        </p>
                        <input type="text" name="dtlid[]" value="{{ $d->dtlid }}" hidden>
                        <input type="text" name="check[]" value="{{ $d->dtlid }}" hidden>
                        <input type="text" name="nolpbj" value="{{ $d->hdrid }}" hidden>
                        <div class="row">
                            <div class="col-sm-4">
                                <label>Article Code:</label>
                                <input class="form-control" type="text" id="articlecode" name="articlecode[]"
                                    value="{{ $d->articlecode }}" disabled>
                            </div>
                            <div class="col-sm-2">
                                <label>Qty:</label>
                                <input class="form-control text-right" type="text" id="qty" name="qty[]"
                                    value="{{ $d->qty }}" disabled>
                            </div>
                            <div class="col-sm-3">
                                <label>Harga Satuan:</label>
                                <input class="form-control text-right" type="number" id="satuan" name="satuan[]"
                                    min="1" onchange="hitungTotal(this.value)" required>
                            </div>
                        </div>
                        <br>
                        <div class="row mb-2">
                            <div class="col-sm-3">
                                <label>Total:</label>
                                <input onkeydown="return false" class="form-control text-right" type="number"
                                    id="total" name="total[]" min="1" readonly>
                            </div>
                            <div class="col-sm-3">
                                <label>Tax:</label>
                                <input onkeydown="return false" class="form-control text-right" type="number"
                                    id="pajak" name="pajak[]" min="1" readonly>
                            </div>
                            <div class="col-sm-3">
                                <label>Grand Total:</label>
                                <input onkeydown="return false" class="form-control text-right" type="number"
                                    id="gtotal" name="gtotal[]" min="1" readonly>
                            </div>
                        </div>
                        <div class="row">
                            <div class="col-sm-5">
                                <label>Remark QA:</label>
                                <input class="form-control" type="text" id="remarkqa" name="remarkqa[]"
                                    autocomplete="off">
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
                    <table class="table table-bordered datatable" id="tbVendor">
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
        }

        function hitungTotal($a) {
            let qty = $('#qty').val();
            let pjk = $('#taxamt').val();
            let total = $a * qty;
            let pajak = total * pjk;
            let gtotal = total + pajak;

            $('#total').val(total);
            $('#pajak').val(pajak);
            $('#gtotal').val(gtotal);
        }

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
