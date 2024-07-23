<!DOCTYPE html>
<html lang="en">

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link rel="icon" type="image/x-icon" href="{{ asset('img/logo.png') }}">
    <title>Document LPBJ</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            margin: 20px;
        }

        .form-grid {
            display: grid;
            grid-template-columns: 1fr;
            gap: 10px;
            margin-bottom: 20px;
        }

        .form-field {
            margin-bottom: 10px;
        }

        .form-field>span:first-child {
            font-weight: bold;
        }

        table {
            width: 100%;
            border-collapse: collapse;
            margin-bottom: 20px;
        }

        th,
        td {
            border: 1px solid #ddd;
            padding: 8px;
            text-align: left;
        }

        th {
            background-color: #f2f2f2;
        }

        textarea {
            width: 100%;
            height: 100px;
        }

        /* Tambahan CSS untuk tabel approval-table */
        .approval-table {
            width: auto;
            /* Sesuaikan lebar tabel */
            border-spacing: 0;
            /* Menghapus jarak antar sel */
            border-collapse: collapse;
            /* Menghapus jarak antar border */
            float: right;
            /* Memindahkan tabel ke sebelah kanan */
            margin-left: 20px;
            /* Jarak kiri dari elemen sebelumnya */
            margin-bottom: 20px;
            /* Jarak bawah tabel */
        }

        .approval-table td {
            padding: 5px;
            /* Jarak dalam sel tabel */
            border: 1px solid #ddd;
            /* Border sel tabel */
        }

        .approval-table tr:nth-child(even) {
            background-color: #f2f2f2;
        }

        /* Warna latar belakang untuk baris genap */
        .approval-table tr:nth-child(odd) {
            background-color: #fff;
        }

        /* Warna latar belakang untuk baris ganjil */
    </style>
</head>

<body>
    @if (Request::segment(1) == 'lihatlpbjdoc')
        <a href="javascript:history.back()">Kembali</a>
        <br>
        <br>
    @endif
    <div class="form-grid">
        <div class="form-field">
            <span>Nomor LPBJ :</span>
            <span>{{ $dataHeader->nolpbj }}</span>
        </div>
        <div class="form-field">
            <span>Company Code:</span>
            <span>{{ $dataHeader->companycode }}</span>
        </div>
        <div class="form-field">
            <span>Departemen :</span>
            <span>{{ $dataHeader->depname }}</span>
        </div>
        <div class="form-field">
            <span>Tanggal Permintaan:</span>
            <span>{{ $dataHeader->tglpermintaan }}</span>
        </div>
        <div class="form-field">
            <span>Description:</span>
            <span>{{ $dataHeader->description }}</span>
        </div>
    </div>

    <table>
        <thead>
            <tr>
                <th>No</th>
                <th>Article</th>
                <th>Article Description</th>
                <th>Remark</th>
                <th>Qty</th>
                <th>UoM</th>
                <th>Store</th>
                <th>Store Description</th>
                <th>Account Assignment</th>
                <th>GL</th>
                <th>Cost Center</th>
                <th>Order</th>
                <th>Asset</th>
                <th>Keterangan</th>
            </tr>
            @for ($i = 0; $i < count($dataDetail); $i++)
                <tr>
                    <td>{{ $i + 1 }}</td>
                    <td>{{ $dataDetail[$i]->articlecode }}</td>
                    <td>{{ $dataDetail[$i]->productname }}</td>
                    <td>{{ $dataDetail[$i]->remark }}</td>
                    <td>{{ $dataDetail[$i]->qty }}</td>
                    <td>{{ $dataDetail[$i]->uom }}</td>
                    <td>{{ $dataDetail[$i]->sitecode }}</td>
                    <td>{{ $dataDetail[$i]->sitename }}</td>
                    <td>{{ $dataDetail[$i]->accassign }}</td>
                    <td>{{ $dataDetail[$i]->gl }}</td>
                    <td>{{ $dataDetail[$i]->costcenter }}</td>
                    <td>{{ $dataDetail[$i]->order }}</td>
                    <td>{{ $dataDetail[$i]->asset }}</td>
                    <td>{{ $dataDetail[$i]->keterangan }}</td>
                </tr>
            @endfor
        </thead>
        <tbody>
            <!-- Table body is intentionally left empty -->
        </tbody>
    </table>

    <div>
        <label><strong>Note :</strong></label>
        <textarea style="font-size: 15px" readonly>{{ $dataHeader->note }}</textarea>
    </div>

    <br>
    <table class="approval-table">
        <tr>
            <td>Created by</td>
            <td>Manager</td>
            <td>GM</td>
        </tr>
        <tr>
            <td style="height: 80px; width: 200px"></td>
            <td style="height: 80px; width: 200px"></td>
            <td style="height: 80px; width: 200px"></td>
        </tr>
        <tr>
            <td style="height: 20px">{{ $dataHeader->namapengaju }}</td>
            <td style="height: 20px">{{ $dataHeader->approval1 }}</td>
            <td style="height: 20px">{{ $dataHeader->approval2 }}</td>
        </tr>
    </table>
</body>

</html>
