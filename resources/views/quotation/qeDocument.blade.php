<!DOCTYPE html>
<html lang="en">

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link rel="icon" type="image/x-icon" href="{{ asset('img/logo.png') }}">
    <title>List History {{ $title }}</title>

    <style>
        body {
            font-family: Arial, sans-serif;
            margin: 20px;
        }

        table {
            width: 100%;
            border-collapse: collapse;
            margin-bottom: 10px;
            counter-reset: rowNumber;
        }

        /* table tr>td:first-child {
            counter-increment: rowNumber;
        }

        table tr td:first-child::before {
            content: counter(rowNumber);
        } */

        th,
        td {
            border: 1px solid #ddd;
            padding: 8px;
            text-align: left;
        }

        th {
            background-color: #f2f2f2;
        }

        .center-table {
            margin: 10px auto;
            width: 80%;
        }

        .highlight {
            color: #28a745;
        }

        /* Warna hijau untuk teks yang disorot */
        .vendor-table {
            width: 100%;
            border-collapse: collapse;
            margin-bottom: 10px;
        }

        .vendor-table th,
        .vendor-table td {
            border: 1px solid #ddd;
            padding: 8px;
            text-align: left;
        }

        .vendor-table th {
            background-color: #e9ecef;
        }

        .vendor-title {
            font-size: 1.5em;
            text-align: center;
            margin: 10px 0;
        }

        .merged-cell {
            text-align: center;
            background-color: #e9ecef;
        }
    </style>
</head>

<body>

    <div class="form-grid">
        @if (Request::segment(1) == 'lihatqedoc')
            <a href="javascript:history.back()">Kembali</a>
            <br>
            <br>
        @endif
        <div class="form-field">
            <strong>Nomor LPBJ: </strong>
            <span>{{ $dataHeader->nolpbj }}</span>
        </div>
        <br>
        <div class="form-field">
            <strong>Nomor QE: </strong>
            <span>{{ $dataHeader->noqe }}</span>
        </div>
    </div>
    <br>

    <table class="table">
        <thead>
            <tr>
                <th rowspan="2">No</th>
                <th rowspan="2">Article</th>
                <th rowspan="2">Article Description</th>
                <th rowspan="2">Remark</th>
                <th rowspan="2">Cost Center</th>
                <th rowspan="2">Order</th>
                <th rowspan="2">GL</th>
                <th rowspan="2">Asset</th>
                <th rowspan="2">Qty</th>
                <th rowspan="2">UoM</th>
                @foreach ($dataVendorHdr as $x)
                    <th colspan="3" class="merged-cell"><a
                            href="{{ url("/pdf/$x->attachment") }}">{{ $x->vendorname }}</a></th>
                @endforeach

            </tr>
            <tr>
                @foreach ($dataVendorHdr as $x)
                    <th class="highlight">Satuan</th>
                    <th class="highlight">Total</th>
                    <th class="highlight">Remarks QA</th>
                @endforeach
            </tr>
            @php
                $i = 0;
            @endphp
            @foreach ($dataVendorDtl[$i] as $x)
                <tr>
                    <td>{{ $i + 1 }}</td>
                    <td>{{ $x->articlecode }}</td>
                    <td>{{ $x->articlename }}</td>
                    <td>{{ $x->remark }}</td>
                    <td>{{ $x->costcenter }}</td>
                    <td>{{ $x->order }}</td>
                    <td>{{ $x->gl }}</td>
                    <td>{{ $x->asset }}</td>
                    <td>{{ $x->qty }}</td>
                    <td>{{ $x->uom }}</td>

                    @php
                        $d = 0;
                    @endphp
                    @foreach ($dataVendorHdr as $z)
                        <td>{{ $dataVendorDtl[$d][$i]->satuan }}</td>
                        <td>{{ $dataVendorDtl[$d][$i]->total }}</td>
                        <td>{{ $dataVendorDtl[$d][$i]->remarkqa }}</td>
                        @php
                            $d++;
                        @endphp
                    @endforeach
                    @php
                        $i++;
                    @endphp
            @endforeach
            </tr>
            <tr>
                <th class="merged-cell" colspan="10">Total</th>
                @foreach ($dataVendorHdr as $x)
                    <td style="text-align: center" colspan="3">{{ $x->total }}</td>
                @endforeach
            </tr>
            <tr>
                <th class="merged-cell" colspan="10">PPN</th>
                @foreach ($dataVendorHdr as $x)
                    <td style="text-align: center" colspan="3">{{ $x->ppn }}</td>
                @endforeach
            </tr>
            <tr>
                <th class="merged-cell" colspan="10">Grand Total</th>
                @foreach ($dataVendorHdr as $x)
                    <td style="text-align: center" colspan="3">{{ $x->gtotal }}</td>
                @endforeach
            </tr>
            <tr style="height: 30px"></tr>
            <tr>
                <th class="merged-cell" colspan="10">Franco</th>
                @foreach ($dataVendorHdr as $x)
                    <td style="text-align: center" colspan="3">{{ $x->franco }}</td>
                @endforeach
            </tr>
            <tr>
                <th class="merged-cell" colspan="10">PKP / Non PKP</th>
                @foreach ($dataVendorHdr as $x)
                    <td style="text-align: center" colspan="3">{{ $x->pkp }}</td>
                @endforeach
            </tr>
            <tr>
                <th class="merged-cell" colspan="10">Delivery Term</th>
                @foreach ($dataVendorHdr as $x)
                    <td style="text-align: center" colspan="3">{{ $x->term }}</td>
                @endforeach
            </tr>
            <tr>
                <th class="merged-cell" colspan="10">T.O.P</th>
                @foreach ($dataVendorHdr as $x)
                    <td style="text-align: center" colspan="3">{{ $x->top }}</td>
                @endforeach
            </tr>
            <tr>
                <th class="merged-cell" colspan="10">Contact Person</th>
                @foreach ($dataVendorHdr as $x)
                    <td style="text-align: center" colspan="3">{{ $x->contactperson }}</td>
                @endforeach
            </tr>
            <tr>
                <th class="merged-cell" colspan="10">Phone No.</th>
                @foreach ($dataVendorHdr as $x)
                    <td style="text-align: center" colspan="3">{{ $x->notelp }}</td>
                @endforeach
            </tr>
            <tr>
                <th class="merged-cell" colspan="10">Vendor Terpilih</th>
                @foreach ($dataVendorHdr as $x)
                    <td style="text-align: center" colspan="3"><strong>{{ $x->ispilih }}</strong></td>
                @endforeach
            </tr>
            <tr>
                <th class="merged-cell" colspan="10">Remark</th>
                @foreach ($dataVendorHdr as $x)
                    <td style="text-align: center" colspan="3">{{ $x->remark }}</td>
                @endforeach
            </tr>
        </thead>
    </table>
    <br>

    <!-- Tabel Persetujuan -->
    <table class="center-table">
        <thead>
            <tr>
                <th>Created by</th>
                <th>Manager Procurement</th>
                <th>Head Procurement</th>
                <th>BOD Procurement</th>
            </tr>
        </thead>
        <thead>
            <tr>
                <td style="height: 70px"></td>
                <td style="height: 70px"></td>
                <td style="height: 70px"></td>
                <td style="height: 70px"></td>
            </tr>
        </thead>
        <thead>
            <tr>
                <th>{{ $dataHeader->namacreated1 }}</th>
                <th>{{ $lacak->approval1 }}</th>
                <th>{{ $lacak->approval2 }}</th>
                <th>{{ $lacak->approval3 }}</th>
            </tr>
        </thead>
    </table>

    <table class="center-table">
        <thead>
            <tr>
                <th>User</th>
                <th>Manager User</th>
                <th>Head User</th>
                <th>BOD User</th>
                <th>FA</th>
                <th>Head FA</th>
                <th>BOD FA</th>
            </tr>
        </thead>
        <thead>
            <tr>
                <td style="height: 70px"></td>
                <td style="height: 70px"></td>
                <td style="height: 70px"></td>
                <td style="height: 70px"></td>
                <td style="height: 70px"></td>
                <td style="height: 70px"></td>
                <td style="height: 70px"></td>
            </tr>
        </thead>
        <thead>
            <tr>
                <th>{{ $lacak->approval4 }}</th>
                <th>{{ $lacak->approval5 }}</th>
                <th>{{ $lacak->approval6 }}</th>
                <th>{{ $lacak->approval7 }}</th>
                <th>{{ $lacak->approval8 }}</th>
                <th>{{ $lacak->approval9 }}</th>
                <th>{{ $lacak->approval10 }}</th>
            </tr>
        </thead>
    </table>
</body>

</html>
