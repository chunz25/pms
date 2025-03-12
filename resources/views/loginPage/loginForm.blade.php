<!DOCTYPE html>
<html lang="en">

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link rel="stylesheet" href="css/login/loginStyle.css">
    <link href="css/bootstrap.min.css" rel="stylesheet">
    <script src="js/bootstrap.min.js"></script>
    <link rel="icon" type="image/x-icon" href="img/logo.png">
    <title>Login PMS ECI</title>
</head>

<body>
    <section class="vh-100">
        <div class="container-fluid h-custom">
            <div class="row d-flex justify-content-center align-items-center h-100">

                <div class="col-md-9 col-lg-6 col-xl-5">
                    <img src="img/logo.png" class="img-fluid" alt="Sample image">
                </div>

                <div class="col-md-8 col-lg-6 col-xl-4 offset-xl-1">
                    <h1 class="text-secondary mb-4">
                        Procurement Management System
                    </h1>
                    <form method="post" action="/cekLogin">
                        @csrf
                        <!-- Username input -->
                        <div data-mdb-input-init class="form-outline mb-4">
                            <input type="text" name="username" id="username" class="form-control form-control-lg"
                                placeholder="Enter Username" autocomplete="off" required />
                            <label class="form-label">Username</label>
                        </div>

                        <!-- Password input -->
                        <div data-mdb-input-init class="form-outline mb-3">
                            <input type="password" id="password" name="password" class="form-control form-control-lg"
                                placeholder="Enter Password" autocomplete="off" required />
                            <label class="form-label">Password</label>
                        </div>

<<<<<<< Updated upstream
<<<<<<< Updated upstream
<<<<<<< Updated upstream
                        {{-- <span class="text-danger">{{ $pesan }}</span> --}}
                        @if (Session::has('pesan'))
                            <p class="text-danger">
                                {{ Session::get('pesan') }}</p>
=======
=======
>>>>>>> Stashed changes
=======
>>>>>>> Stashed changes
                        <!-- Error display -->
                        @if ($errors->any())
                            <div class="alert alert-danger">
                                {{ $errors->first() }}
                            </div>
<<<<<<< Updated upstream
<<<<<<< Updated upstream
>>>>>>> Stashed changes
=======
>>>>>>> Stashed changes
=======
>>>>>>> Stashed changes
                        @endif

                        <div class="text-left text-lg-start mt-4 pt-2">
                            <button type="submit" class="btn btn-primary btn-lg"
                                style="padding-left: 2.5rem; padding-right: 2.5rem;">Login</button>
                            <a href="forgotPass" class="btn btn-secondary btn-lg">Forgot password?</a>
                        </div>
                    </form>
                </div>
            </div>
        </div>
<<<<<<< Updated upstream
=======

        {{-- modalResetPass --}}
        <div class="modal fade" id="modalForgot" tabindex="-1" aria-hidden="true">
            <div class="modal-dialog" style="width: 300px;">
                <div class="modal-content text-center">
                    <div class="modal-header h5 bg-primary text-white justify-content-center">
                        Password Reset
                    </div>
                    <div class="modal-body px-5">
                        <p class="py-2">
                            Masukkan <strong>Username</strong> anda, password baru akan dikirim melalui <strong>Email
                                Kantor</strong> Anda.
                        </p>
                        <div class="form-outline">
                            <input type="text" name="reset" id="reset" class="form-control my-3 text-center"
                                autocomplete="off" placeholder="Isi Username Anda..." />
                        </div>
                        <button onclick="reset()" class="btn btn-primary w-100 mb-2">
                            Reset Password
                        </button>
                        <button class="btn btn-secondary w-100" data-bs-dismiss="modal">
                            Batal
                        </button>
                    </div>
                </div>
            </div>
        </div>
        {{-- modalResetPass --}}

>>>>>>> Stashed changes
        <div
            class="d-flex flex-column flex-md-row text-center text-md-start justify-content-between py-4 px-4 px-xl-5 bg-primary">
            <div class="text-white mb-3 mb-md-0">
                Copyright © 2024. All rights reserved.
            </div>
        </div>
    </section>
<<<<<<< Updated upstream
<<<<<<< Updated upstream
<<<<<<< Updated upstream
=======
=======
>>>>>>> Stashed changes
=======
>>>>>>> Stashed changes

    <script type="text/javascript">
        @if (Session::has('reset'))
            alert("{{ Session::get('reset') }}");
        @endif

        function reset() {
            let user = $('#reset').val();
            window.location.href = "{{ url('/reset') }}" + "/" + user;
        }
    </script>

>>>>>>> Stashed changes
</body>

</html>
