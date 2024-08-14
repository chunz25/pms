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
                <p>Berikut Password baru anda:
                </p>
            </div>
            <div>
                <table class="table">
                    <tr>
                        <th>Username</th>
                        <th>New Password</th>
                    </tr>
                    <tr>
                        <td>{{ $dataBody['user'] }}</td>
                        <td>{{ $dataBody['newPass'] }}</td>
                    </tr>
                </table>
            </div>
            <br>
            <div>
                <a href="{{ url('/') }}">Buka Aplikasi</a>
            </div>
        </div>
    </section>
</body>

</html>
