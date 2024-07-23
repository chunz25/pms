<!DOCTYPE html>
<html lang="en">

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link rel="icon" type="image/x-icon" href="{{ asset('img/logo.png') }}">
    <title>Tambah Quotation</title>

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
                        <h2 class="mb-1">Tambah Quotation</h2>
                    </div>
                </div>
                <br>
                <form class="form-horizontal form-label-left" enctype="multipart/form-data">
                    @csrf
                    <table class="table table-sm table-bordered datatable" id="tbArticle">
                        <thead>
                            <tr>
                                <th class="text-center"><input type="checkbox" id="checkAll">
                                </th>
                                <th>No</th>
                                <th>Product Code</th>
                                <th>Product Name</th>
                                <th>Remark</th>
                                <th>Qty</th>
                                <th>UOM</th>
                            </tr>
                        </thead>
                        <tbody>
                            @foreach ($getLpbj as $a)
                                <tr>
                                    <td class="text-center"><input type="checkbox" name="check[]" id="check"
                                            value="{{ $a->dtlid }}"></td>
                                    <td></td>
                                    <td>{{ $a->articlecode }}</td>
                                    <td>{{ $a->articlename }}</td>
                                    <td>{{ $a->remark }}</td>
                                    <td>{{ $a->qty }}</td>
                                    <td>{{ $a->uom }}</td>
                                </tr>
                            @endforeach
                        </tbody>
                    </table>
                    <br>
                    <div class="modal-footer">
                        <button onclick="window.history.back()" type="button"
                            class="btn btn-secondary mr-2">Kembali</button>
                        <button onclick="validate('check[]')" type="button" class="btn btn-primary">Buat Quotation
                            Evaluation</button>
                </form>
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

                tbArticle.cells(null, 1, {
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

            $("#checkAll").click(function() {
                $('input:checkbox').not(this).prop('checked', this.checked);
            });

        });

        function getCheckedBoxes(chkboxName) {
            var checkboxes = document.getElementsByName(chkboxName);
            var checkboxesChecked = [];
            // loop over them all
            for (var i = 0; i < checkboxes.length; i++) {
                // And stick the checked ones onto an array...
                if (checkboxes[i].checked) {
                    checkboxesChecked.push(checkboxes[i]);
                }
            }
            // Return the array if it is non-empty, or null
            return checkboxesChecked.length > 0 ? checkboxesChecked : null;
        }

        function validate(a) {
            var checkedBoxes = getCheckedBoxes(a);

            if (checkedBoxes == null) {
                alert('Pilih data terlebih dahulu.');
            } else {
                let i = 0;
                let x = [];
                checkedBoxes.forEach(element => {
                    x.push(checkedBoxes[i].value);
                    i++;
                });

                window.location.href = "{{ url('/tempdraft') }}" + "/" + x;
            }
        }
    </script>
</body>

</html>
