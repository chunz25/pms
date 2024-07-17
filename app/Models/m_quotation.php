<?php

namespace App\Models;

use DateTime;
use Illuminate\Database\Eloquent\Model;
use Illuminate\Support\Facades\DB;

class m_quotation extends Model
{
    public function getListQe()
    {
        $data = DB::table('vw_historylpbj as a')
            ->select('a.*')
            ->distinct('*')
            ->leftJoin('vw_historylpbjdtl as b', 'b.hdrid', '=', 'a.hdrid')
            ->where('a.statusid', '=', 3)
            ->where('b.isqe', '=', 0)
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

    public function getLpbj($id)
    {
        $data = DB::table('vw_historylpbjdtl')
            ->select('*')
            ->where('hdrid', '=', $id)
            ->where('isqe', '=', 0)
            ->get();

        return $data;
    }

    public function getLpbjDtl($id)
    {
        $data = DB::table('vw_historylpbjdtl')
            ->select('*')
            ->where('dtlid', '=', $id)
            ->where('isqe', '=', 0)
            ->get();

        return $data;
    }

    public function getDraft($id)
    {
        $data = DB::table('vw_getdraftqe')
            ->select('*')
            ->where('dtlid', '=', $id)
            ->get();

        return $data;
    }

    public function getVDraft($id)
    {
        $data = DB::table('vw_getdraftqe')
            ->select('vendorcode', 'vendorname', 'ispilih')
            ->where('dtlid', '=', $id)
            ->get();

        // dd($data);

        return $data;
    }

    public function insertDraft($params)
    {
        $date = new DateTime('now');

        $getDraft = DB::table('vw_getdraftqe')
            ->select('*')
            ->where('dtlid', '=', $params['dtlid'])
            ->where('vendorcode', '=', $params['vendorcode'])
            ->get();

        // dd(count($getDraft) == 0);

        if (count($getDraft) == 0) {
            $data = DB::table('s_draftqe')->insert([
                'dtlid' => $params['dtlid'],
                'satuan' => $params['satuan'],
                'remarkqa' => $params['remarkqa'],
                'attachment' => $params['attach'],
                'vendorcode' => $params['vendorcode'],
                'franco' => $params['franco'],
                'ispkp' => $params['pkp'],
                'term' => $params['term'],
                'top' => $params['top'],
                'contactperson' => $params['person'],
                'notelp' => $params['telp'],
                'created_at' => $date,
                'created_by' => session('iduser'),
                'ispilih' => $params['pilih'],
                'remark' => $params['remark'],
            ]);
            return $data;
        } else {
            return $getDraft;
        }
    }

    public function updateQe($id)
    {
        $data = DB::table('m_lpbj_dtl')
            ->where('id', $id)
            ->update([
                'isqe' => 1,
                'modified_by' => session('iduser')
            ]);

        return $data;
    }

    public function ajukanQe($id)
    {
        $userid = session('iduser');
        $data = DB::statement("CALL sp_addqehdr($userid,$id)");
        return $data;
    }

    public function ajukanQeDetail($id)
    {
        $userid = session('iduser');
        $data = DB::statement("CALL sp_addqedtl($userid,$id)");
        return $data;
    }

    public function delVendor($id)
    {
        $data = DB::table('s_draftqe')
            ->where('created_by', session('iduser'))
            ->where('vendorcode', $id)
            ->update([
                'isdeleted' => 1,
                'modified_by' => session('iduser')
            ]);

        return $data;
    }

    public function getListHistory()
    {
        $data = DB::table('vw_historyqe')
            ->select('*')
            ->get();

        return $data;
    }

    public function getHistoryDetail($id)
    {
        $data = DB::table('vw_historyqedtl')
            ->select('*')
            ->where('hdrid', '=', $id)
            ->get();

        return $data;
    }

    public function getHistoryHeader($id)
    {
        $data = DB::table('vw_historyqe')
            ->select('*')
            ->where('hdrid', '=', $id)
            ->get();

        return $data;
    }

    public function getVendorHeader($id)
    {
        $data = DB::table('vw_vendorhdr')
            ->select('*')
            ->where('hdrid', '=', $id)
            ->get();

        return $data;
    }

    public function getVendorDetail($vendor)
    {
        $data = DB::table('vw_vendordtl')
            ->select('*')
            ->where('vendorcode', '=', $vendor)
            ->get();

        return $data;
    }
}
