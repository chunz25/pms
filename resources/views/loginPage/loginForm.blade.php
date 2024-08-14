<!DOCTYPE html>
<html lang="en">

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link rel="icon" type="image/x-icon" href="{{ asset('img/logo.png') }}">
    <title>Login PMS ECI</title>

    <link href="{{ asset('css/login/loginStyle.css') }}" rel="stylesheet">
    <link href="{{ asset('css/bootstrap.min.css') }}" rel="stylesheet">
    <script src="{{ asset('js/bootstrap.min.js') }}"></script>

    <link href="https://fonts.googleapis.com/icon?family=Material+Icons" rel="stylesheet">
    <script src="https://cdn.jsdelivr.net/npm/jquery@3.7.0/dist/jquery.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.0.2/dist/js/bootstrap.min.js"></script>
</head>

<body>
    <section class="vh-100">
        <div class="container-fluid h-custom">
            <div class="row d-flex justify-content-center align-items-center h-100">

                <div class="col-md-9 col-lg-6 col-xl-5">
                    <img src="{{ asset('img/logo.png') }}" class="img-fluid" alt="Sample image">
                </div>

                <div class="col-md-8 col-lg-6 col-xl-4 offset-xl-1">
                    <h1 class="text-secondary mb-4">
                        Procurement Management System
                    </h1>
                    <form method="post" action="{{ url('/cekLogin') }}">
                        @csrf
                        <!-- Username input -->
                        <div data-mdb-input-init class="form-outline mb-4">
                            <input type="text" name ="username" id="username" class="form-control form-control-lg"
                                placeholder="Enter Username" autocomplete="off" required />
                            <label class="form-label">Username</label>
                        </div>

                        <!-- Password input -->
                        <div data-mdb-input-init class="form-outline mb-3">
                            <input type="password" id="password" name ="password" class="form-control form-control-lg"
                                placeholder="Enter Password" autocomplete="off" required />
                            <label class="form-label">Password</label>
                        </div>

                        @if (Session::has('pesan'))
                            <p class="text-danger">
                                {{ Session::get('pesan') }}</p>
                        @endif

                        <div class="text-left text-lg-start mt-4 pt-2">
                            <button type="submit" data-mdb-button-init data-mdb-ripple-init
                                class="btn btn-primary btn-lg"
                                style="padding-left: 2.5rem; padding-right: 2.5rem;">Login</button>
                            <button type="button" class="btn btn-secondary btn-lg" data-bs-toggle="modal"
                                data-bs-target="#modalForgot">Forgot password?</button>
                        </div>
                    </form>
                </div>
            </div>
        </div>

        {{-- modalResetPass --}}
        <div class="modal top fade" id="modalForgot" tabindex="-1" aria-hidden="true" data-mdb-backdrop="true"
            data-mdb-keyboard="true">
            <div class="modal-dialog" style="width: 300px;">
                <div class="modal-content text-center">
                    <div class="modal-header h5 text-white bg-primary justify-content-center">
                        Password Reset
                    </div>
                    <div class="modal-body px-5">
                        <p class="py-2">
                            Masukkan <strong>Username</strong> anda, password baru akan dikirim melalui <strong>Email
                                Kantor</strong> Anda.
                        </p>
                        <div data-mdb-input-init class="form-outline">
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

        <div
            class="d-flex flex-column flex-md-row text-center text-md-start justify-content-between py-4 px-4 px-xl-5 bg-primary">
            <!-- Copyright -->
            <div class="text-white mb-3 mb-md-0">
                Copyright © 2024. All rights reserved.
            </div>
            <!-- Copyright -->
        </div>
    </section>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@4.6.2/dist/js/bootstrap.bundle.min.js"
        integrity="sha384-Fy6S3B9q64WdZWQUiU+q4/2Lc9npb8tCaSX9FK7E8HnRr0Jz8D6OP9dO5Vg3Q9ct" crossorigin="anonymous">
    </script>

    <script type="text/javascript">
        @if (Session::has('reset'))
            alert("{{ Session::get('reset') }}");
        @endif

        function reset() {
            let user = $('#reset').val();

            window.location.href = "{{ url('/reset') }}" + "/" + user;
        }
    </script>

</body>

</html>
