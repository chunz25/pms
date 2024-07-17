<?php

namespace App\Models;

use DateTime;
use Illuminate\Database\Eloquent\Model;
use Illuminate\Support\Facades\DB;

class m_quotation extends Model
{
    public function getPegawai($userid)
    {
        $data = DB::table('vw_getpegawai')
            ->select('*')
            ->where('userid', '=', $userid)
            ->get();

        return $data;
    }

    public function getDraft()
    {
        $data = DB::table('vw_getdraftqe')
            ->select('*')
            ->get();

        return $data;
    }

    public function getVendor()
    {
        $data = DB::table('api_vendor')
            ->select('*')
            ->get();

        return $data;
    }

    public function getLpbj()
    {
        $data = DB::table('vw_historylpbj')
            ->select('*')
            ->where('statusid', '=', 2)
            ->where('depname', '=', session('depname'))
            ->get();

        return $data;
    }
}
