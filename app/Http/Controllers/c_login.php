<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;
use App\Models\m_users;
use Illuminate\Support\Facades\Auth;
<<<<<<< Updated upstream
=======
use Illuminate\Support\Facades\Mail;
use App\Mail\mailPMS;
use Exception;
use Illuminate\Support\Facades\Log;
<<<<<<< Updated upstream
<<<<<<< Updated upstream
>>>>>>> Stashed changes
=======
>>>>>>> Stashed changes
=======
>>>>>>> Stashed changes

class c_login extends Controller
{
    protected $users;

    public function __construct()
    {
        $this->users = new m_users();
    }

    public function index()
    {
        try {
            if (session('iduser')) {
                return redirect('portal');
            } else {
                return view('loginPage/loginForm');
            }
        } catch (Exception $e) {
            Log::error('Error in index: ' . $e->getMessage());
            return redirect('login')->withErrors('An error occurred while loading the page');
        }
    }

    public function cekLogin(Request $params)
    {
        try {
            $user = $params->input('username');
            $pass = $params->input('password');

            $data = [
                'user' => $user,
                'pass' => $pass
            ];

            $cekLogin = $this->users->getUser($data);

<<<<<<< Updated upstream
<<<<<<< Updated upstream
<<<<<<< Updated upstream
        if (count($cekLogin) > 0) {
            $sess = $cekLogin->toArray()[0];

            session([
                'iduser' => $sess->iduser,
                'username' => $sess->username,
                'name' => $sess->name,
                'idgroup' => $sess->idgroup,
                'groupname' => $sess->usergroupname,
                'depname' => $sess->depname,
                'divname' => $sess->divname,
                'email' => $sess->email,
                'emailapprove' => $sess->emailapprove
            ]);
            return redirect('portal');
        } else {
            return redirect('login')->with('pesan', 'Username / Password Salah.');
=======
            if (count($cekLogin) > 0) {
                $sess = end($cekLogin);

                session([
                    'iduser' => $sess->iduser,
                    'username' => $sess->username,
                    'kunci' => $sess->password,
                    'name' => $sess->name,
                    'idgroup' => $sess->idgroup,
                    'groupname' => $sess->usergroupname,
                    'dirname' => $sess->dirname,
                    'depname' => $sess->depname,
                    'divname' => $sess->divname,
                    'email' => $sess->email,
                    'emailapprove' => $sess->emailapprove
                ]);

                if ($sess->isreset === 1 || $sess->password === 'b626ebe3027038962d7acec9ebe4f1bc') {
                    return redirect('cpassword')->with('isreset', 1);
                } else {
                    return redirect('portal');
                }
            } else {
                return redirect('login')->withErrors('Username / Password Salah.');
            }
        } catch (Exception $e) {
            Log::error('Error in cekLogin: ' . $e->getMessage());
            return redirect('login')->withErrors('An error occurred during login');
>>>>>>> Stashed changes
        }
    }

=======
            if (count($cekLogin) > 0) {
                $sess = end($cekLogin);

=======
            if (count($cekLogin) > 0) {
                $sess = end($cekLogin);

>>>>>>> Stashed changes
                session([
                    'iduser' => $sess->iduser,
                    'username' => $sess->username,
                    'kunci' => $sess->password,
                    'name' => $sess->name,
                    'idgroup' => $sess->idgroup,
                    'groupname' => $sess->usergroupname,
                    'dirname' => $sess->dirname,
                    'depname' => $sess->depname,
                    'divname' => $sess->divname,
                    'email' => $sess->email,
                    'emailapprove' => $sess->emailapprove
                ]);

                if ($sess->isreset === 1 || $sess->password === 'b626ebe3027038962d7acec9ebe4f1bc') {
                    return redirect('cpassword')->with('isreset', 1);
                } else {
                    return redirect('portal');
                }
            } else {
                return redirect('login')->withErrors('Username / Password Salah.');
            }
        } catch (Exception $e) {
            Log::error('Error in cekLogin: ' . $e->getMessage());
            return redirect('login')->withErrors('An error occurred during login');
        }
    }

    public function resetPass($username)
    {
        try {
            $cekUser = $this->users->cekUser($username)->first();
            $characters = '0123456789abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ';
            $randomString = '';
            for ($i = 0; $i < 10; $i++) {
                $randomString .= $characters[random_int(0, strlen($characters) - 1)];
            }

            if ($cekUser != null) {
                $data = [
                    'user' => $username,
                    'new' => md5($randomString),
                    'newPass' => $randomString,
                    'isreset' => 1,
                ];

                $uPass = $this->users->updPass($data);

                if ($uPass === 1) {
                    $details = [
                        'subject' => 'Reset Password PMS',
                        'dataBody' => $data,
                        'aksi' => 'ResetPass',
                    ];

                    Mail::to($cekUser->email)->send(new mailPMS($details));

                    return redirect('login')->with('reset', 'Berhasil Reset Password, silahkan cek email anda untuk mendapatkan password baru');
                } else {
                    return redirect('login')->withErrors('Gagal karena masalah internal, silahkan ulangi kembali');
                }
            } else {
                return redirect('login')->withErrors('Gagal Reset Password, cek kembali username anda.');
            }
        } catch (Exception $e) {
            Log::error('Error in resetPass: ' . $e->getMessage());
            return redirect('login')->withErrors('An error occurred while resetting the password');
        }
    }

    public function gantiPass()
    {
        try {
            $data = [
                'user' => session('username'),
                'nama' => session('name'),
            ];

            return view('loginPage.gantiPass', $data);
        } catch (Exception $e) {
            Log::error('Error in gantiPass: ' . $e->getMessage());
            return redirect('portal')->withErrors('An error occurred while loading the change password page');
        }
    }

    public function cPass(Request $params)
    {
        try {
            $user = $params->username;
            $new = md5($params->newPass);

            $old = md5($params->oldPass);
            if ($params->isreset == 1) {
                $old = $params->oldPass;
            }

            $cekUser = $this->users->cekUser($user)->first();

            if ($cekUser->password != $old) {
                return redirect('cpassword')->withErrors('Password anda tidak sesuai');
            } else {
                $data = [
                    'user' => $user,
                    'new' => $new,
                    'isreset' => 0,
                ];

                $uPass = $this->users->updPass($data);

                if ($uPass === 1) {
                    return redirect('portal')->with('pesan', 'Password berhasil diganti');
                } else {
                    return redirect('cpassword')->withErrors('Gagal karena masalah internal, silahkan ulangi kembali');
                }
            }
        } catch (Exception $e) {
            Log::error('Error in cPass: ' . $e->getMessage());
            return redirect('cpassword')->withErrors('An error occurred while changing the password');
        }
    }

>>>>>>> Stashed changes
    public function logout(Request $request)
    {
        try {
            $request->session()->flush();
            return redirect('login');
        } catch (Exception $e) {
            Log::error('Error in logout: ' . $e->getMessage());
            return redirect('portal')->withErrors('An error occurred while logging out');
        }
    }
}
