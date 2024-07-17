<!DOCTYPE html>
<html lang="en">

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <meta http-equiv="X-UA-Compatible" content="ie=edge">
    <title>Email LPBJ</title>
    <style>
        table {
            border: 1px solid #b3adad;
            border-collapse: collapse;
            padding: 5px;
        }

        table th {
            border: 1px solid #b3adad;
            padding: 5px;
            background: #f0f0f0;
            color: #313030;
        }

        table td {
            border: 1px solid #b3adad;
            padding: 5px;
            background: #ffffff;
            color: #313030;
        }
    </style>
</head>

<body>
    <section>
        <div>
            <div>
                <h5>Dear bapak/ibu,</h5>
                <p>FYI , Berikut list LPBJ pada Proses Pengajuan LPBJ yang di ajukan oleh
                    <strong>{{ $dataBody[0]->namapengaju }}</strong> di Procurement
                    Management System :
                </p>
            </div>
            <div>
                <table class="table">
                    <tr>
                        <th>No LPBJ</th>
                        <th>Departemen</th>
                        <th>Tanggal Permintaan</th>
                        <th>Deskripsi</th>
                        <th>Workflow</th>
                    </tr>
                    @foreach ($dataBody as $a)
                        <tr>
                            <td>{{ $a->nolpbj }}</td>
                            <td>{{ $a->depname }}</td>
                            <td>{{ $a->tglpermintaan }}</td>
                            <td>{{ $a->description }}</td>
                            <td>{{ $a->workflow }}</td>
                        </tr>
                    @endforeach
                </table>
            </div>
            <div>
                <p>Mohon untuk segera di proses.</p>
                <a href="{{ url('') }}">Buka Aplikasi</a>
            </div>
        </div>
    </section>
</body>

</html>
