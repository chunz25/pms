<?php

namespace App\Http\Controllers;

use App\Models\m_quotation;

class c_quotation extends Controller
{
    protected $db;
    public function __construct()
    {
        $this->db = new m_quotation();
    }

    public function index()
    {
        if (!session('iduser')) {
            return redirect('login')->with('pesan', 'Session anda telah habis, silahkan login kembali.');
        }

        $userid = session('iduser');
        $dataPegawai = $this->db->getPegawai($userid)->toArray()[0];
        $dataDraft = $this->db->getDraft()->toArray();

        $data = [
            'dataPegawai' => $dataPegawai,
            'dataDraft' => $dataDraft
        ];

        return view('quotation/pengajuan', $data);
    }

    public function tambahQe()
    {
        if (!session('iduser')) {
            return redirect('login')->with('pesan', 'Session anda telah habis, silahkan login kembali.');
        }

        $dataDraft = '';
        if (session('draftid')) {
            $dataDraft = $this->db->cekDraft(session('draftid'))->toArray()[0];
        }


        $dataLpbj = $this->db->getLpbj()->toArray();
        $dataVendor = $this->db->getVendor()->toArray();


        $data = [
            'getLpbj' => $dataLpbj,
            'getVendor' => $dataVendor,
            'dataDraft' => $dataDraft
        ];

        return view('quotation/tambah', $data);
    }
}
