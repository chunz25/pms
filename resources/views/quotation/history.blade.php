<!DOCTYPE html>
<html lang="en">

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link rel="icon" type="image/x-icon" href="{{ asset('img/logo.png') }}">
    <title>List History Quotation</title>

    @include('template.style')

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
                        <h2 class="mb-1">List History {{ $title }}</h2>
                    </div>
                </div>
                <br>
                <div class="col-sm-12">
                    <table id="tbList" class="table table-responsive table-hover datatable">
                        <thead class="table-primary">
                            <tr>
                                <th>No</th>
                                <th>No LPBJ</th>
                                <th>Description</th>
                                <th>No QE</th>
                                <th>Status</th>
                                <th>Tanggal Permintaan</th>
                                <th>No PO</th>
                                <th>Detail</th>
                            </tr>
                        </thead>
                        <tbody>
                            @foreach ($dataHistory as $dh)
                                <tr>
                                    <td></td>
                                    <td>{{ $dh->nolpbj }}</td>
                                    <td>{{ $dh->description }}</td>
                                    <td>{{ $dh->noqe }}</td>
                                    <td>{{ $dh->statusname }}</td>
                                    <td>{{ $dh->created_at }}</td>
                                    <td>{{ $dh->pono }}</td>
                                    <td>
                                        <a href="{{ url("/detailqe/$dh->hdrid") }}" class="btn btn-sm btn-success">
                                            <i class="bi bi-search"></i>
                                        </a>
                                    </td>
                                </tr>
                            @endforeach
                        </tbody>
                    </table>
                </div>
            </div>
            <hr>
        </section>
        {{-- /FormPengajuan --}}

    </main>

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

        $(document).ready(function() {

            const tbList = new DataTable('#tbList', {
                columnDefs: [{
                    searchable: false,
                    orderable: false,
                    targets: 0
                }],
                order: [
                    [1, 'asc']
                ]
            });
            tbList.on('order.dt search.dt', function() {
                let i = 1;

                tbList.cells(null, 0, {
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
