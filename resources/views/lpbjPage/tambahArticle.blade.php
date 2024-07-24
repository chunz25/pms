<!DOCTYPE html>
<html lang="en">

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link rel="icon" type="image/x-icon" href="{{ asset('img/logo.png') }}">
    <title>Tambah Article {{ $title }}</title>

    @include('template.style')
    
    <link href="{{ asset('css/lpbj/articleSearch.css') }}" rel="stylesheet">

    <link href="https://fonts.googleapis.com/icon?family=Material+Icons" rel="stylesheet">
    <script src="https://cdn.jsdelivr.net/npm/jquery@3.7.0/dist/jquery.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.0.2/dist/js/bootstrap.min.js"></script>
    <link href="https://cdn.datatables.net/1.13.4/css/jquery.dataTables.min.css" rel="stylesheet">
    <script src="https://cdn.datatables.net/1.13.4/js/jquery.dataTables.min.js"></script>
</head>

<body class="index-page">

    @include('template.tempLpbj')

    <main class="main">
        {{-- FormPengajuan --}}
        <section class="about section">
            <div class="container" data-aos="fade-up" data-aos-delay="100">
                <div class="row gy-4 justify-content-center">
                    <div class="col-lg-12 content">
                        <h2 class="mb-1">Tambah Data {{ $title }}</h2>
                    </div>
                </div>
                <br>
                <form class="form-horizontal form-label-left" action="{{ url('/draftlpbj') }}" method="post"
                    enctype="multipart/form-data">
                    @csrf
                    <div class="row">
                        <div class="col-sm-4">
                            <label for="artLPBJ">Article :</label>
                            @if ($getDraft)
                                <input class="form-control" type="text" value="{{ $getDraft->articlecode }}"
                                    readonly>
                            @else
                                <input class="form-control" type="text" id="artLPBJ" name="artLPBJ"
                                    placeholder="Article Code" required data-bs-toggle="modal"
                                    data-bs-target="#articleModel" autocomplete="off" onkeydown="return false">
                            @endif

                        </div>
                        <div class="col-sm-4">
                            <label for="artdescLPBJ">Article Description :</label>
                            @if ($getDraft)
                                <input class="form-control" type="text" value="{{ $getDraft->articlename }}"
                                    readonly>
                            @else
                                <input class="form-control" type="text" id="artdescLPBJ" name="artdescLPBJ"
                                    placeholder="Article Description" autocomplete="off" readonly>
                            @endif
                        </div>
                    </div>
                    <br>
                    <div class="row">
                        <div class="col-sm-6">
                            <label for="rmkLPBJ">Remark :</label>
                            @if ($getDraft)
                                <input class="form-control" type="text" value="{{ $getDraft->remark }}" readonly>
                            @else
                                <input class="form-control" type="text" name="rmkLPBJ" placeholder="Remark"
                                    autocomplete="off">
                            @endif
                            <br>
                        </div>
                    </div>
                    <div class="row">
                        <div class="col-sm-2">
                            <label for="qtyLPBJ">Quantity :</label>
                            @if ($getDraft)
                                <input class="form-control" type="number" value="{{ $getDraft->qty }}" readonly>
                            @else
                                <input class="form-control" type="number" name="qtyLPBJ" placeholder="Qty"
                                    autocomplete="off" min="1" required>
                            @endif
                            <br>
                        </div>
                        <div class="col-sm-2">
                            <label for="uomLPBJ">UOM :</label>
                            @if ($getDraft)
                                <input class="form-control" type="text" value="{{ $getDraft->uom }}" readonly>
                            @else
                                <input class="form-control" type="text" id="uomLPBJ" id="uomLPBJ" name="uomLPBJ"
                                    placeholder="UOM" readonly>
                            @endif
                            <br>
                        </div>
                    </div>
                    <div class="row">
                        <div class="col-sm-2">
                            <label for="stcodeLPBJ">Store :</label>
                            @if ($getDraft)
                                <input class="form-control" type="text" value="{{ $getDraft->sitecode }}" readonly>
                            @else
                                <input class="form-control" type="text" id="stcodeLPBJ" name="stcodeLPBJ"
                                    placeholder="Store Code" data-bs-toggle="modal" data-bs-target="#siteModal"
                                    autocomplete="off" required onkeydown="return false">
                            @endif
                            <br>
                        </div>
                        <div class="col-sm-4">
                            <label for="stnameLPBJ">Store Description :</label>
                            @if ($getDraft)
                                <input class="form-control" type="text" value="{{ $getDraft->sitename }}"
                                    readonly>
                            @else
                                <input class="form-control" type="text" id="stnameLPBJ" name="stnameLPBJ"
                                    placeholder="Store Name" readonly>
                            @endif
                            <br>
                        </div>
                    </div>
                    <div class="row">
                        <div class="col-sm-6">
                            <label for="accLPBJ">Account Assignment :</label>
                            @if ($getDraft)
                                <input class="form-control" type="text" value="{{ $getDraft->accassign }}"
                                    readonly>
                            @else
                                <select class="form-control" name="accLPBJ" id="accLPBJ" required>
                                    <option value="" disabled selected hidden>Pilih Account Assignment...
                                    </option>
                                    <option value="K">K - COST CENTER</option>
                                    <option value="A">Y - PRE ASSET</option>
                                </select>
                            @endif
                            <br>
                        </div>
                    </div>
                    <div class="row">
                        <div class="col-sm-2" id="gl">
                            <label for="glLPBJ">GL :</label>
                            @if ($getDraft)
                                <input class="form-control" type="text" value="{{ $getDraft->gl }}" readonly>
                            @else
                                <input class="form-control" type="text" id="glLPBJ" name="glLPBJ"
                                    placeholder="GL Number" autocomplete="off" data-bs-toggle="modal"
                                    data-bs-target="#glModal" onkeydown="return false">
                            @endif
                        </div>
                        <div class="col-sm-2" id="cc">
                            <label for="costLPBJ">Cost Center :</label>
                            @if ($getDraft)
                                <input class="form-control" type="text" value="{{ $getDraft->costcenter }}"
                                    readonly>
                            @else
                                <input class="form-control" type="text" id="costLPBJ" name="costLPBJ"
                                    placeholder="Cost Center" autocomplete="off" data-bs-toggle="modal"
                                    data-bs-target="#ccModal" onkeydown="return false">
                            @endif
                        </div>
                        <div class="col-sm-2" id="io">
                            <label for="orderLPBJ">Order :</label>
                            @if ($getDraft)
                                <input class="form-control" type="text" value="{{ $getDraft->order }}" readonly>
                            @else
                                <input class="form-control" type="text" id="orderLPBJ" name="orderLPBJ"
                                    placeholder="Order" autocomplete="off" data-bs-toggle="modal"
                                    data-bs-target="#orderModal" onkeydown="return false">
                            @endif
                        </div>
                        <div class="col-sm-2" id="as">
                            <label for="assetLPBJ">Asset :</label>
                            @if ($getDraft)
                                <input class="form-control" type="text" value="{{ $getDraft->asset }}" readonly>
                            @else
                                <input class="form-control" type="text" id="assetLPBJ" name="assetLPBJ"
                                    placeholder="Kode Asset" autocomplete="off" data-bs-toggle="modal"
                                    data-bs-target="#assetModal" onkeydown="return false">
                            @endif
                        </div>
                    </div>
                    <br>
                    <div class="row">
                        <div class="col-sm-6">
                            <label for="ketLPBJ">Keterangan :</label>
                            @if ($getDraft)
                                <input class="form-control" type="text" value="{{ $getDraft->keterangan }}"
                                    readonly>
                            @else
                                <textarea class="form-control" name="ketLPBJ" cols="40" rows="5" placeholder="Keterangan"
                                    autocomplete="off"></textarea>
                            @endif
                            <br>
                        </div>
                    </div>
                    <div class="row">
                        <div class="col-sm-4">
                            <label for="imgLPBJ">Gambar :</label>
                            @if ($getDraft)
                                @if ($getDraft->gambar)
                                    <img class=" form-control img-thumbnail"
                                        src="{{ asset("uploads/lpbj/$getDraft->gambar") }}">
                                @endif
                            @else
                                <input class="form-control" type="file" name="imgLPBJ" id="imgLPBJ"
                                    autocomplete="off" accept="image/*" onchange="validate(this.value);">
                            @endif
                            <br>
                        </div>
                    </div>
                    <div class="modal-footer">
                        <a href="{{ url('/pengajuanlpbj') }}" class="btn btn-secondary mr-2">Kembali</a>
                        @if (!$getDraft)
                            <button type="submit" class="btn btn-primary">Simpan</button>
                        @endif
                    </div>
                </form>
            </div>
            <hr>
        </section>
        {{-- /FormPengajuan --}}
    </main>

    {{-- ArticleModal --}}
    <div class="modal fade" id="articleModel" tabindex="-1" aria-hidden="true">
        <div class="modal-dialog modal-lg">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title" id="exampleModalLabel">List Article</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                </div>
                <div class="modal-body">
                    <table class="table table-bordered datatable" id="tbArticle">
                        <thead>
                            <tr>
                                <th style="width: 10%">No</th>
                                <th style="width: 20%">Product Code</th>
                                <th>Product Name</th>
                                <th style="width: 10%">UOM</th>
                                <th class="text-center" style="width: 20%">Action</th>
                            </tr>
                        </thead>
                        <tbody>
                            @foreach ($getArticle as $article)
                                <tr>
                                    <td style="width: 10%"></td>
                                    <td style="width: 20%">{{ $article->productcode }}</td>
                                    <td>{{ $article->productname }}</td>
                                    <td style="width: 10%">{{ $article->uom }}</td>
                                    <td class="text-center" style="width: 20%">
                                        <button type="button"
                                            onclick="addArticle('{{ $article->productcode }}','{{ $article->productname }}','{{ $article->uom }}')"
                                            class="btn btn-outline-success btn-sm" data-bs-dismiss="modal">
                                            Pilih Article
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
    {{-- /ArticleModal --}}

    {{-- SiteModal --}}
    <div class="modal fade" id="siteModal" tabindex="-1" aria-hidden="true">
        <div class="modal-dialog modal-lg">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title" id="exampleModalLabel">List Store</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                </div>
                <div class="modal-body">
                    <table class="table table-bordered datatable" id="tbSite">
                        <thead>
                            <tr>
                                <th style="width: 10%">No</th>
                                <th style="width: 20%">Store Code</th>
                                <th>Store Name</th>
                                <th class="text-center" style="width: 20%">Action</th>
                            </tr>
                        </thead>
                        <tbody>
                            @foreach ($getSite as $site)
                                <tr>
                                    <td style="width: 10%"></td>
                                    <td style="width: 20%">{{ $site->sitecode }}</td>
                                    <td>{{ $site->name1 }}</td>
                                    <td class="text-center" style="width: 20%">
                                        <button type="button"
                                            onclick="addSite('{{ $site->sitecode }}','{{ $site->name1 }}')"
                                            class="btn btn-outline-success btn-sm" data-bs-dismiss="modal">
                                            Pilih Store
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
    {{-- /SiteModal --}}

    {{-- GLModal --}}
    <div class="modal fade" id="glModal" tabindex="-1" aria-hidden="true">
        <div class="modal-dialog modal-lg">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title" id="exampleModalLabel">List GL</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                </div>
                <div class="modal-body">
                    <table class="table table-bordered datatable" id="tbGL">
                        <thead>
                            <tr>
                                <th style="width: 10%">No</th>
                                <th style="width: 20%">Company Code</th>
                                <th style="width: 20%">GL Account</th>
                                <th>Description</th>
                                <th class="text-center" style="width: 20%">Action</th>
                            </tr>
                        </thead>
                        <tbody>
                            @foreach ($getGL as $gl)
                                <tr>
                                    <td style="width: 10%"></td>
                                    <td style="width: 20%">{{ $gl->companycode }}</td>
                                    <td style="width: 20%">{{ $gl->glaccount }}</td>
                                    <td>{{ $gl->description }}</td>
                                    <td class="text-center" style="width: 20%">
                                        <button type="button" onclick="addGL('{{ $gl->glaccount }}')"
                                            class="btn btn-outline-success btn-sm" data-bs-dismiss="modal">
                                            Pilih GL
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
    {{-- /GLModal --}}

    {{-- CostCenterModal --}}
    <div class="modal fade" id="ccModal" tabindex="-1" aria-hidden="true">
        <div class="modal-dialog modal-lg">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title" id="exampleModalLabel">List Cost Center</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                </div>
                <div class="modal-body">
                    <table class="table table-bordered datatable" id="tbCC">
                        <thead>
                            <tr>
                                <th style="width: 10%">No</th>
                                <th style="width: 20%">Company Code</th>
                                <th style="width: 20%">Cost Center</th>
                                <th>Description</th>
                                <th class="text-center" style="width: 20%">Action</th>
                            </tr>
                        </thead>
                        <tbody>
                            @foreach ($getCC as $cc)
                                <tr>
                                    <td style="width: 10%"></td>
                                    <td style="width: 20%">{{ $cc->companycode }}</td>
                                    <td style="width: 20%">{{ $cc->costcenter }}</td>
                                    <td>{{ $cc->description }}</td>
                                    <td class="text-center" style="width: 20%">
                                        <button type="button" onclick="addCC('{{ $cc->costcenter }}')"
                                            class="btn btn-outline-success btn-sm" data-bs-dismiss="modal">
                                            Pilih Cost Center
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
    {{-- /CostCenterModal --}}

    {{-- OrderModal --}}
    <div class="modal fade" id="orderModal" tabindex="-1" aria-hidden="true">
        <div class="modal-dialog modal-lg">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title" id="exampleModalLabel">List Internal Order</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                </div>
                <div class="modal-body">
                    <table class="table table-bordered datatable" id="tbOrder">
                        <thead>
                            <tr>
                                <th style="width: 10%">No</th>
                                <th style="width: 20%">Company Code</th>
                                <th style="width: 20%">Internal Order</th>
                                <th>Description</th>
                                <th class="text-center" style="width: 20%">Action</th>
                            </tr>
                        </thead>
                        <tbody>
                            @foreach ($getOrder as $order)
                                <tr>
                                    <td style="width: 10%"></td>
                                    <td style="width: 20%">{{ $order->companycode }}</td>
                                    <td style="width: 20%">{{ $order->order }}</td>
                                    <td>{{ $order->description }}</td>
                                    <td class="text-center" style="width: 20%">
                                        <button type="button" onclick="addOrder('{{ $order->order }}')"
                                            class="btn btn-outline-success btn-sm" data-bs-dismiss="modal">
                                            Pilih Order
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
    {{-- /OrderModal --}}

    {{-- AssetModal --}}
    <div class="modal fade" id="assetModal" tabindex="-1" aria-hidden="true">
        <div class="modal-dialog modal-lg">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title" id="exampleModalLabel">List Asset</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                </div>
                <div class="modal-body">
                    <table class="table table-bordered datatable" id="tbAsset">
                        <thead>
                            <tr>
                                <th style="width: 10%">No</th>
                                <th style="width: 20%">Company Code</th>
                                <th style="width: 20%">Asset</th>
                                <th>Description</th>
                                <th class="text-center" style="width: 20%">Action</th>
                            </tr>
                        </thead>
                        <tbody>
                            @foreach ($getAsset as $asset)
                                <tr>
                                    <td style="width: 10%"></td>
                                    <td style="width: 20%">{{ $asset->companycode }}</td>
                                    <td style="width: 20%">{{ $asset->asset }}</td>
                                    <td>{{ $asset->description }}</td>
                                    <td class="text-center" style="width: 20%">
                                        <button type="button" onclick="addAsset('{{ $asset->asset }}')"
                                            class="btn btn-outline-success btn-sm" data-bs-dismiss="modal">
                                            Pilih Asset
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
    {{-- /AssetModal --}}

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

        $(document).ready(function() {

            const tbArticle = new DataTable('#tbArticle', {
                columnDefs: [{
                    searchable: false,
                    orderable: false,
                    targets: 0
                }],
                order: [
                    [1, 'asc']
                ]
            });
            tbArticle.on('order.dt search.dt', function() {
                let i = 1;

                tbArticle.cells(null, 0, {
                        search: 'applied',
                        order: 'applied'
                    })
                    .every(function(cell) {
                        this.data(i++);
                    });
            }).draw();

            const tbSite = new DataTable('#tbSite', {
                columnDefs: [{
                    searchable: false,
                    orderable: false,
                    targets: 0
                }],
                order: [
                    [1, 'asc']
                ]
            });
            tbSite.on('order.dt search.dt', function() {
                let i = 1;

                tbSite.cells(null, 0, {
                        search: 'applied',
                        order: 'applied'
                    })
                    .every(function(cell) {
                        this.data(i++);
                    });
            }).draw();

            const tbGL = new DataTable('#tbGL', {
                columnDefs: [{
                    searchable: false,
                    orderable: false,
                    targets: 0
                }],
                order: [
                    [1, 'asc']
                ]
            });
            tbGL.on('order.dt search.dt', function() {
                let i = 1;

                tbGL.cells(null, 0, {
                        search: 'applied',
                        order: 'applied'
                    })
                    .every(function(cell) {
                        this.data(i++);
                    });
            }).draw();

            const tbCC = new DataTable('#tbCC', {
                columnDefs: [{
                    searchable: false,
                    orderable: false,
                    targets: 0
                }],
                order: [
                    [1, 'asc']
                ]
            });
            tbCC.on('order.dt search.dt', function() {
                let i = 1;

                tbCC.cells(null, 0, {
                        search: 'applied',
                        order: 'applied'
                    })
                    .every(function(cell) {
                        this.data(i++);
                    });
            }).draw();

            const tbOrder = new DataTable('#tbOrder', {
                columnDefs: [{
                    searchable: false,
                    orderable: false,
                    targets: 0
                }],
                order: [
                    [1, 'asc']
                ]
            });
            tbOrder.on('order.dt search.dt', function() {
                let i = 1;

                tbOrder.cells(null, 0, {
                        search: 'applied',
                        order: 'applied'
                    })
                    .every(function(cell) {
                        this.data(i++);
                    });
            }).draw();

            const tbAsset = new DataTable('#tbAsset', {
                columnDefs: [{
                    searchable: false,
                    orderable: false,
                    targets: 0
                }],
                order: [
                    [1, 'asc']
                ]
            });
            tbAsset.on('order.dt search.dt', function() {
                let i = 1;

                tbAsset.cells(null, 0, {
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

            $('#accLPBJ').change(function() {
                let as = document.getElementById("as");
                let gl = document.getElementById("gl");
                let cc = document.getElementById("cc");
                let io = document.getElementById("io");

                var $option = $(this).find('option:selected');
                if ($option.val() == 'A') {
                    $('#gl').prop("hidden", true);
                    $('#cc').prop("hidden", true);
                    $('#io').prop("hidden", true);
                    $('#as').prop("hidden", false);
                }
                if ($option.val() == 'K') {
                    $('#gl').prop("hidden", false);
                    $('#cc').prop("hidden", false);
                    $('#io').prop("hidden", false);
                    $('#as').prop("hidden", true);
                }
            });

        });

        function addArticle(c, n, u) {
            $('#artLPBJ').val(c);
            $('#artdescLPBJ').val(n);
            $('#uomLPBJ').val(u);
        }

        function addSite(c, n) {
            $('#stcodeLPBJ').val(c);
            $('#stnameLPBJ').val(n);
        }

        function addGL(c) {
            $('#glLPBJ').val(c);
        }

        function addCC(c) {
            $('#costLPBJ').val(c);
        }

        function addOrder(c) {
            $('#orderLPBJ').val(c);
        }

        function addAsset(c) {
            $('#assetLPBJ').val(c);
        }

        function validate(fileName) {
            let a = document.getElementById("imgLPBJ");
            let ext = new Array("jpg", "png", "jpeg", "gif");
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
    </script>
</body>

</html>
