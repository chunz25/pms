<!DOCTYPE html>
<html lang="en">

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link rel="icon" type="image/x-icon" href="img/logo.png">
    <title>List LPBJ</title>

    {{-- Style CSS --}}
    {{-- Vendor CSS Files --}}
    <link href="css/lpbj/main.css" rel="stylesheet">
    <link href="vendor/bootstrap/css/bootstrap.min.css" rel="stylesheet">
    <link href="vendor/bootstrap-icons/bootstrap-icons.css" rel="stylesheet">
    <link href="vendor/boxicons/css/boxicons.min.css" rel="stylesheet">
    <link href="vendor/quill/quill.snow.css" rel="stylesheet">
    <link href="vendor/quill/quill.bubble.css" rel="stylesheet">
    <link href="vendor/remixicon/remixicon.css" rel="stylesheet">

    <script src="https://cdn.jsdelivr.net/npm/jquery@3.7.0/dist/jquery.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.0.2/dist/js/bootstrap.min.js"></script>
    <link href="https://cdn.datatables.net/1.13.4/css/jquery.dataTables.min.css" rel="stylesheet">
    <script src="https://cdn.datatables.net/1.13.4/js/jquery.dataTables.min.js"></script>
</head>

<body>

    {{-- NavBar --}}
    <header id="header" class="header grey-background d-flex flex-column">
        <i class="header-toggle d-xl-none bi bi-list"></i>

        <div class="profile-img">
            <img src="img/logo.jpg" alt="" class="img-fluid rounded-circle">
        </div>

        <a href="index.html" class="logo d-flex align-items-center justify-content-center">
            <h1 class="sitename">QUOTATION</h1>
        </a>

        <nav id="navmenu" class="navmenu">
            <ul>
                <li><a href="pengajuanqe" class="active"><i class="bi bi-clipboard2-plus navicon"></i>Pengajuan</a>
                </li>
                <li><a href="historyqe"><i class="bi bi-clock-history navicon"></i>History</a></li>
                <li><a href="portal"><i class="bi bi-backspace navicon"></i>Kembali</a></li>
            </ul>
        </nav>
    </header>
    {{-- /NavBar --}}

    <main id="main" class="main">
        <section class="section">
            <h2>List LPBJ</h2>
            <div class="row">
                <div class="col-lg-12">
                    <div class="card">
                        <div class="card-body">
                            <table class="table datatable table-hover" id="tbArticle">
                                <thead>
                                    <tr>
                                        <th>No</th>
                                        <th>Nomor LPBJ</th>
                                        <th>Departemen</th>
                                        <th>Tanggal Permintaan</th>
                                        <th>Description</th>
                                        <th>Action</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <tr>
                                        <td></td>
                                        <td>EC01/BUSDEV/24062024/0001</td>
                                        <td>BUSDEV</td>
                                        <td>Senin, 24-06-2024</td>
                                        <td>Pembangunan taman</td>
                                        <td><a href="createqe" class="btn btn-outline-primary btn-sm">Buat QE</a></td>
                                    </tr>
                                    <tr>
                                        <td></td>
                                        <td>EC01/MARKOM/24062024/0001</td>
                                        <td>MARKOM</td>
                                        <td>Senin, 24-06-2024</td>
                                        <td>Pembelian stiker</td>
                                        <td><a href="createqe" class="btn btn-outline-primary btn-sm">Buat QE</a></td>
                                    </tr>
                                </tbody>
                            </table>
                        </div>
                    </div>
                </div>
            </div>
        </section>
    </main>

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

    <!-- Vendor JS Files -->
    <script src="vendor/apexcharts/apexcharts.min.js"></script>
    <script src="vendor/bootstrap/js/bootstrap.bundle.min.js"></script>
    <script src="vendor/chart.js/chart.umd.js"></script>
    <script src="vendor/echarts/echarts.min.js"></script>
    <script src="vendor/quill/quill.js"></script>
    <script src="vendor/tinymce/tinymce.min.js"></script>
    <script src="vendor/php-email-form/validate.js"></script>


    <!-- Template Main JS File -->
    <script src="js/lpbj/mainSearch.js"></script>
    {{-- <script src="https://cdn.jsdelivr.net/npm/jquery@3.5.1/dist/jquery.slim.min.js"
        integrity="sha384-DfXdz2htPH0lsSSs5nCTpuj/zy4C+OGpamoFVy38MVBnE+IbbVYUew+OrCXaRkfj" crossorigin="anonymous">
    </script> --}}
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@4.6.2/dist/js/bootstrap.bundle.min.js"
        integrity="sha384-Fy6S3B9q64WdZWQUiU+q4/2Lc9npb8tCaSX9FK7E8HnRr0Jz8D6OP9dO5Vg3Q9ct" crossorigin="anonymous">
    </script>

    <script type="text/javascript">
        $(document).ready(function() {

            const table = new DataTable('#tbArticle', {
                columnDefs: [{
                    searchable: false,
                    orderable: false,
                    targets: 0
                }],
                order: [
                    [1, 'asc']
                ]
            });

            table.on('order.dt search.dt', function() {
                    let i = 1;

                    table.cells(null, 0, {
                            search: 'applied',
                            order: 'applied'
                        })
                        .every(function(cell) {
                            this.data(i++);
                        });
                })
                .draw();

            $.ajaxSetup({
                headers: {
                    'X-CSRF-TOKEN': $('meta[name="csrf-token"]').attr('content')
                }
            });

            // $('#tbArticle').DataTable({
            //     processing: true,
            //     serverSide: true,
            //     ajax: "{{ url('tbArticle') }}",
            //     columns: [{
            //             data: 'id',
            //             name: 'id'
            //         },
            //         {
            //             data: 'articlecode',
            //             name: 'articlecode'
            //         },
            //         {
            //             data: 'articlename',
            //             name: 'articlename'
            //         },
            //         {
            //             data: 'uom',
            //             name: 'uom'
            //         },
            //         {
            //             data: 'action',
            //             name: 'action',
            //             orderable: false
            //         },
            //     ],
            //     order: [
            //         [0, 'desc']
            //     ]
            // });
        });

        function addFunc(articlecode) {
            if (confirm("Tambah Article ini?") == true) {
                var id = id;
                // ajax
                $.ajax({
                    type: "POST",
                    url: "{{ url('delete') }}",
                    data: {
                        id: id
                    },
                    dataType: 'json',
                    success: function(res) {
                        var oTable = $('#ajax-crud-datatable').dataTable();
                        oTable.fnDraw(false);
                    }
                });
            }
        }
    </script>

</body>

</html>
