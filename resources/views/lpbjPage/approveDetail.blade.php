<!DOCTYPE html>
<html lang="en">

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link rel="icon" type="image/x-icon" href="{{ asset('img/logo.png') }}">
    <title>Detail {{ $title }}</title>

    @include('template.style')

    <script src="https://cdn.jsdelivr.net/npm/jquery@3.7.0/dist/jquery.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.0.2/dist/js/bootstrap.min.js"></script>
    <link href="https://cdn.datatables.net/1.13.4/css/jquery.dataTables.min.css" rel="stylesheet">
    <script src="https://cdn.datatables.net/1.13.4/js/jquery.dataTables.min.js"></script>
</head>


<body class="index-page">

    @include('template.tempLpbj')

    <main class="main">
        <section class="about section">
            <div class="container" data-aos="fade-up" data-aos-delay="100">
                {{-- DataUser --}}
                <div class="row gy-4 justify-content-center">
                    <div class="col-lg-12 content">
                        <h2 class="mb-4">Detail LPBJ</h2>
                        <div class="row">
                            <div class="col-lg-6">
                                <ul>
                                    <li><i class="bi bi-chevron-right"></i> <strong>Status LPBJ :</strong>
                                        <span>{{ $dataHeader->workflow }}</span>
                                    </li>
                                    <li><i class="bi bi-chevron-right"></i> <strong>No LPBJ :</strong>
                                        <span>{{ $dataHeader->nolpbj }}</span>
                                    </li>
                                    <li><i class="bi bi-chevron-right"></i> <strong>Company :</strong>
                                        <span>{{ $dataHeader->companycode }}</span>
                                    </li>
                                    <li><i class="bi bi-chevron-right"></i> <strong>Departemen :</strong>
                                        <span>{{ $dataHeader->depname }}</span>
                                    </li>
                                    <li><i class="bi bi-chevron-right"></i> <strong>Tanggal Permintaan :</strong>
                                        <span>{{ $dataHeader->tglpermintaan }}</span>
                                    </li>
                                    <li><i class="bi bi-chevron-right"></i> <strong>Description :</strong>
                                        <span>{{ $dataHeader->description }}</span>
                                    </li>
                                </ul>
                            </div>
                        </div>
                    </div>
                </div>
                {{-- /DataUser --}}
                <hr>
                {{-- FormPengajuan --}}
                <form action="{{ url('/setujulpbj') }}" method="post">
                    @csrf
                    <input name="hdrid" type="text" value="{{ $dataHeader->hdrid }}" hidden>
                    <input name="status" type="text" value="{{ $dataHeader->statusid }}" hidden>
                    <table id="tbhistory" class="table-responsive table-hover datatable">
                        <thead class="table-primary">
                            <tr class="text-center">
                                <th>No</th>
                                <th>Article</th>
                                <th>Remark</th>
                                <th>Qty</th>
                                <th>UoM</th>
                                <th>Store</th>
                                <th>Acc Assignment</th>
                                <th>GL</th>
                                <th>Cost Center</th>
                                <th>Order</th>
                                <th>Asset</th>
                                <th>Keterangan</th>
                                <th class="text-center">Gambar</th>
                            </tr>
                        </thead>
                        <tbody>
                            @foreach ($dataDetail as $dd)
                                <tr>
                                    <td></td>
                                    <td>{{ $dd->articlecode }}</td>
                                    <td>{{ $dd->remark }}</td>
                                    <td>{{ $dd->qty }}</td>
                                    <td>{{ $dd->uom }}</td>
                                    <td>{{ $dd->sitecode }}</td>
                                    <td>{{ $dd->accassign }}</td>
                                    <td>{{ $dd->gl }}</td>
                                    <td>{{ $dd->costcenter }}</td>
                                    <td>{{ $dd->order }}</td>
                                    <td>{{ $dd->asset }}</td>
                                    <td>{{ $dd->keterangan }}</td>
                                    <td><a class="text-blue" type="button" data-bs-toggle="modal"
                                            data-bs-target="#modal{{ $dd->gambar }}">Lihat Gambar</a></td>
                                </tr>
                            @endforeach
                        </tbody>
                    </table>
                    <br>
                    <div class="row">
                        <div class="col-sm-12">
                            <label for="noteLPBJ">Note :</label>
                            <textarea class="form-control" id="noteLPBJ" cols="40" rows="5" readonly>{{ $dataHeader->note }}</textarea>
                            <br>
                        </div>
                    </div>

                    <div class="modal-footer">
                        <a href="approvelpbj" class="btn btn-secondary mr-2">Kembali</a>
                        <button type="submit" class="btn btn-primary mr-2">Setuju</button>
                        <button type="button" class="btn btn-danger mr-2" data-bs-toggle="modal"
                            data-bs-target="#modalReject">Reject</button>
                    </div>
                </form>
                {{-- /FormPengajuan --}}
            </div>
        </section>
    </main>

    {{-- ModalTampilGambar --}}
    @foreach ($dataDetail as $dd)
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
                        <img src="{{ asset("uploads/lpbj/$dd->gambar") }}" class="img-fluid img-thumbnail">
                    </div>
                    <div class="modal-footer">
                        <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Kembali</button>
                    </div>
                </div>
            </div>
        </div>
    @endforeach
    {{-- /ModalTampilGambar --}}

    {{-- ModalReject --}}
    <div class="modal fade" id="modalReject" tabindex="-1" aria-hidden="true">
        <div class="modal-dialog">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title">Alasan Reject</h5>
                    <button type="button" class="close" data-bs-dismiss="modal" aria-label="Close">
                        <span aria-hidden="true">&times;</span>
                    </button>
                </div>
                <form action="{{ url('/rejectlpbj') }}" method="post">
                    @csrf
                    <div class="modal-body text-center">
                        <input name="hdrid" type="text" value="{{ $dataHeader->hdrid }}" hidden>
                        <select name="status" class="form-control mb-2" required>
                            <option value="" hidden disabled selected>Pilih Alasan Reject...</option>
                            <option value="0">Reject for Revision</option>
                            <option value="12">Reject Document</option>
                        </select>
                        <textarea name="reason" cols="60" rows="5" required></textarea>
                    </div>
                    <div class="modal-footer">
                        <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Kembali</button>
                        <button type="submit" class="btn btn-danger">Reject</button>
                    </div>
                </form>
            </div>
        </div>
    </div>
    {{-- /ModalReject --}}

    @include('template.footer')

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

    <script type="text/javascript">
        $(document).ready(function() {

            const tbhistory = new DataTable('#tbhistory', {
                columnDefs: [{
                    searchable: false,
                    orderable: false,
                    targets: 0
                }],
                order: [
                    [1, 'asc']
                ]
            });
            tbhistory.on('order.dt search.dt', function() {
                let i = 1;

                tbhistory.cells(null, 0, {
                        search: 'applied',
                        order: 'applied'
                    })
                    .every(function(cell) {
                        this.data(i++);
                    });
            }).draw();

        });
    </script>
</body>

</html>
