<?php

namespace App\Http\Controllers;

use App\Models\m_users;
use Illuminate\Http\Request;

class c_portal extends Controller
{
    protected $db;
    public function __construct()
    {
        $this->db = new m_users();
    }

    public function index()
    {
        if (!session('iduser')) {
            return redirect('login')->with('pesan', 'Session anda telah habis, silahkan login kembali.');
        }

        session()->forget(['cc', 'jdl', 'note', 'doc']);

        $menu = $this->db->getMenu(session('iduser'));

        $data = [
            'user' => session('username'),
            'nama' => session('name'),
            'getMenu' => $menu
        ];
        return view('portalPage/portalHome', $data);
    }
}
