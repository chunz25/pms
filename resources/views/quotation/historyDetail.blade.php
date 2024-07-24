<!DOCTYPE html>
<html lang="en">

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link rel="icon" type="image/x-icon" href="{{ asset('img/logo.png') }}">
    <title>Detail Quotation</title>

    @include('template.style')

    <script src="https://cdn.jsdelivr.net/npm/jquery@3.7.0/dist/jquery.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.0.2/dist/js/bootstrap.min.js"></script>
</head>


<body class="index-page">

    @include('template.tempQe')

    <main class="main">
        <section class="about section">
            <div class="container" data-aos="fade-up" data-aos-delay="100">
                {{-- DataUser --}}
                <div class="row gy-4 justify-content-center">
                    <div class="col-lg-12 content">
                        <h2 class="mb-4">Detail Quotation</h2>
                        <div class="row">
                            <div class="col-lg-6">
                                <ul>
                                    <li><i class="bi bi-chevron-right"></i> <strong>Status QE :</strong>
                                        <span>{{ $dataHeader->workflow }}</span>
                                    </li>
                                    <li><i class="bi bi-chevron-right"></i> <strong>No QE :</strong>
                                        <span>{{ $dataHeader->noqe }}</span>
                                    </li>
                                    <li><i class="bi bi-chevron-right"></i> <strong>Tanggal Permintaan :</strong>
                                        <span>{{ $dataHeader->created_at }}</span>
                                    </li>
                                    @if ($dataHeader->reason != '')
                                        <li><i class="bi bi-chevron-right"></i> <strong>Alasan Reject :</strong>
                                            <span>{{ $dataHeader->reason }}</span>
                                        </li>
                                    @endif
                                    <a class="btn btn-outline-primary btn-sm"
                                        href="{{ url("/lihatqedoc/$dataHeader->hdrid") }}">
                                        <i class="bi bi-filetype-pdf"></i> Lihat Dokumen
                                    </a>
                                    <a class="btn btn-outline-danger btn-sm"
                                        href="{{ url("/cetakqedoc/$dataHeader->hdrid") }}">
                                        <i class="bi bi-filetype-pdf"></i> Print Dokumen
                                    </a>
                                </ul>
                            </div>
                        </div>
                    </div>
                </div>
                {{-- /DataUser --}}
                <hr>
                @php
                    $i = 0;
                @endphp
                @foreach ($dataVendorHdr as $vendor)
                    <div class="col-sm-12 align-middle mb-2">
                        <span><strong>{{ $vendor->vendorname }}</strong></span>
                        @if ($vendor->pilih == 1)
                            <strong class="text-primary">Vendor Pilihan User</strong>
                        @endif
                        <a href="{{ url("/subdetailqe/$vendor->hdrid,$vendor->vendorcode") }}"
                            class="btn btn-outline-secondary btn-sm">
                            <i class="bi bi-search"></i>
                        </a>
                    </div>
                    <table class="table-responsive-sm table-hover table-bordered col-sm-12 mb-4">
                        <thead class="table-secondary text-center">
                            <tr>
                                <th>Article</th>
                                <th>Satuan</th>
                                <th>Total</th>
                                <th>Tax</th>
                                <th>Grand Total</th>
                                <th>Remark QA</th>
                            </tr>
                        </thead>
                        <tbody>
                            @foreach ($dataVendorDtl[$i] as $d)
                                <tr>
                                    <td>{{ $d->articlecode }}</td>
                                    <td class="text-right">{{ $d->satuan }}</td>
                                    <td class="text-right">{{ $d->total }}</td>
                                    <td class="text-right">{{ $d->tax }}</td>
                                    <td class="text-right">{{ $d->gtotal }}</td>
                                    <td>{{ $d->remarkqa }}</td>
                                </tr>
                            @endforeach
                        </tbody>
                    </table>
                    @php
                        $i++;
                    @endphp
                @endforeach
                <br>
                <div class="modal-footer">
                    <a href="{{ url('/historyqe') }}" class="btn btn-success">Kembali</a>
                </div>
            </div>
        </section>
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
    </script>

</body>

</html>
