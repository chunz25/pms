<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;
use App\Models\m_users;
use Illuminate\Support\Facades\Auth;
use Illuminate\Support\Facades\Mail;
use App\Mail\mailPMS;

class c_login extends Controller
{

    protected $users;
    public function __construct()
    {
        $this->users = new m_users();
    }

    public function index()
    {
        if (session('iduser')) {
            return redirect('portal');
        } else {
            return view('loginPage/loginForm');
        }
    }

    public function cekLogin(Request $params)
    {
        $user = $params->input('username');
        $pass = $params->input('password');

        $data = [
            'user' => $user,
            'pass' => $pass
        ];

        $cekLogin = $this->users->getUser($data);

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

            if ($sess->isreset == 1 || $sess->password == 'b626ebe3027038962d7acec9ebe4f1bc') {
                return redirect('cpassword')->with('isreset', 1);
            } else {
                return redirect('portal');
            }
        } else {
            return redirect('login')->with('pesan', 'Username / Password Salah.');
        }
    }

    public function resetPass($username)
    {
        $cekUser = $this->users->cekUser($username)->first();
        $characters = '0123456789abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ';
        $charactersLength = strlen($characters);
        $randomString = '';
        for ($i = 0; $i < 10; $i++) {
            $randomString .= $characters[random_int(0, $charactersLength - 1)];
        }

        if ($cekUser != null) {
            $data = [
                'user' => $username,
                'new' => md5($randomString),
                'newPass' => $randomString,
                'isreset' => 1,
            ];
            // dd($data);

            $uPass = $this->users->updPass($data);

            if ($uPass === 1) {

                $details = [
                    'subject' => 'Reset Password PMS',
                    'dataBody' => $data,
                    'aksi' => 'ResetPass',
                ];

                Mail::to($cekUser->email)->send(new mailPMS($details));
                // dd($details);

                return redirect('login')->with('reset', 'Berhasil Reset Password, silahkan cek email anda untuk mendapatkan password baru');
            } else {
                return redirect('login')->with('pesan', 'Gagal karena masalah internal, silahkan ulangi kembali');
            }
        } else {
            return redirect('login')->with('reset', 'Gagal Reset Password, cek kembali username anda.');
        }
    }

    public function gantiPass()
    {
        $data = [
            'user' => session('username'),
            'nama' => session('name'),
        ];

        return view('loginPage.gantiPass', $data);
    }

    public function cPass(Request $params)
    {
        // dd($params);
        $user = $params->username;
        $new = md5($params->newPass);

        $old = md5($params->oldPass);
        if ($params->isreset == 1) {
            $old = $params->oldPass;
        }

        $cekUser = $this->users->cekUser($user)->first();

        if ($cekUser->password != $old) {
            return redirect('cpassword')->with('pesan', 'Password anda tidak sesuai');
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
                return redirect('cpassword')->with('pesan', 'Gagal karena masalah internal, silahkan ulangi kembali');
            }
        }
    }

    public function logout(Request $request)
    {
        $request->session()->flush();
        return redirect('login');
    }
}
