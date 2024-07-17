<?php

namespace App\Models;

use DateTime;
use Illuminate\Database\Eloquent\Model;
use Illuminate\Support\Facades\DB;

class m_lpbj extends Model
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
        $data = DB::table('vw_getdraftlpbj')
            ->select('*')
            ->where('userid', '=', session('iduser'))
            ->get();

        return $data;
    }

    public function getArticle()
    {
        $data = DB::table('api_article')
            ->select('*')
            ->get();

        return $data;
    }

    public function getSite()
    {
        $data = DB::table('api_site')
            ->select('*')
            ->get();

        return $data;
    }

    public function getGL()
    {
        $data = DB::table('api_gl')
            ->select('*')
            ->get();

        return $data;
    }

    public function getCC()
    {
        $data = DB::table('api_costcenter')
            ->select('*')
            ->get();

        return $data;
    }

    public function getOrder()
    {
        $data = DB::table('api_order')
            ->select('*')
            ->get();

        return $data;
    }

    public function getAsset()
    {
        $data = DB::table('api_asset')
            ->select('*')
            ->get();

        return $data;
    }

    public function insertDraft($params)
    {
        $date = new DateTime('now');

        $data = DB::table('s_draftlpbj')->insert([
            'userid' => $params['userid'],
            'articlecode' => $params['article'],
            'remark' => $params['remark'],
            'qty' => $params['qty'],
            'sitecode' => $params['site'],
            'accassign' => $params['assign'],
            'gl' => $params['gl'],
            'costcenter' => $params['cost'],
            'order' => $params['order'],
            'asset' => $params['asset'],
            'keterangan' => $params['ket'],
            'gambar' => $params['pic'],
            'created_at' => $date,
            'created_by' => $params['userid'],
        ]);

        return $data;
    }

    public function deleteDraft($id)
    {
        $data = DB::table('s_draftlpbj')
            ->where('id', $id)
            ->update([
                'isdeleted' => 1,
                'modified_by' => session('iduser')
            ]);

        return $data;
    }

    public function cekDraft($id)
    {
        $data = DB::table('vw_getdraftlpbj')
            ->select('*')
            ->where('id', '=', $id)
            ->get();

        return $data;
    }

    public function insertHdr($params)
    {
        $userid = $params['userid'];
        $company = $params['companycode'];
        $desc = $params['description'];
        $note = $params['note'];
        $status = $params['status'];

        $data = DB::statement("CALL sp_addlpbjhdr($userid,'$company','$desc','$note','$status')");
        $data = DB::table("m_lpbj_hdr")
            ->max('id');
        return $data;
    }

    public function editHdr($params)
    {
        $userid = $params['userid'];
        $company = $params['companycode'];
        $desc = $params['description'];
        $note = $params['note'];
        $status = $params['status'];

        $data = DB::statement("CALL sp_addlpbjhdr($userid,'$company','$desc','$note','$status')");
        $data = DB::table("m_lpbj_hdr")
            ->max('id');
        return $data;
    }

    public function getHistory()
    {
        $data = DB::table('vw_historylpbj')
            ->select('*')
            ->where('divname', session('divname'))
            ->get();

        return $data;
    }

    public function getHistoryHeader($id)
    {
        $data = DB::table('vw_historylpbj')
            ->select('*')
            ->where('hdrid', '=', $id)
            ->get();

        return $data;
    }

    public function getApprove($status)
    {
        $data = DB::table('vw_historylpbj')
            ->select('*')
            ->where('depname', '=', session('depname'))
            ->where('statusid', $status)
            ->get();

        return $data;
    }

    public function getHistoryDetail($id)
    {
        $data = DB::table('vw_historylpbjdtl')
            ->select('*')
            ->where('hdrid', '=', $id)
            ->get();

        return $data;
    }

    public function insertLpbj($id, $status)
    {
        // dd($status);
        $data = DB::table('m_lpbj_hdr')
            ->where('id', $id)
            ->update([
                'status' => ($status + 1),
                'workflow' => 'Approved_by_' . session('groupname'),
                'modified_by' => session('iduser')
            ]);

        return $data;
    }

    public function rejectLpbj($id, $status, $reason)
    {
        // dd($status);
        $data = DB::table('m_lpbj_hdr')
            ->where('id', $id)
            ->update([
                'status' => $status,
                'reason' => $reason,
                'workflow' => 'Reject_by_' . session('groupname'),
                'modified_by' => session('iduser')
            ]);

        return $data;
    }
}
