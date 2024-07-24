<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;
use App\Models\m_users;
use Illuminate\Support\Facades\Auth;

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
                'name' => $sess->name,
                'idgroup' => $sess->idgroup,
                'groupname' => $sess->usergroupname,
                'dirname' => $sess->dirname,
                'depname' => $sess->depname,
                'divname' => $sess->divname,
                'email' => $sess->email,
                'emailapprove' => $sess->emailapprove
            ]);
            return redirect('portal');
        } else {
            return redirect('login')->with('pesan', 'Username / Password Salah.');
        }
    }

    public function logout(Request $request)
    {
        $request->session()->flush();
        return redirect('login');
    }
}
