<?php

namespace App\Models;

use DateTime;
use Illuminate\Database\Eloquent\Model;
use Illuminate\Support\Facades\DB;

class restfulapi extends Model
{
    public function param1($id)
    {
        $data = DB::select(
            "
            SELECT DISTINCT
                'ZG' as doc_type ,
                d.companycode as company_code ,
                c.vendorcode as vendor ,
                DATE_FORMAT(a.modified_at,'%Y-%m-%d') as doc_date ,
                a.id as ref_1 ,
                d.id as ref_2 ,
                g.username as created_by,
                d.description ,
                d.note
            FROM m_qe_hdr a
                LEFT JOIN m_qe_dtl b on b.hdrid = a.id
                LEFT JOIN s_draftqe c on c.id = b.draftid
                LEFT JOIN m_lpbj_hdr d on d.id = a.lpbjid
                LEFT JOIN m_lpbj_dtl e on e.hdrid = d.id
                LEFT JOIN api_article f on f.productcode = e.articlecode
                LEFT JOIN m_users g on g.id = a.created_by -- userQE
                LEFT JOIN m_users g1 on g1.id = d.created_by -- userLPBJ
            WHERE a.`status` = 11
            AND c.ispilih = 1
            AND a.id = :id
            ",
            ['id' => $id]
        );

        return $data;
    }
    public function param2($id)
    {
        $data = DB::select(
            "
            SELECT DISTINCT
                0 as preq_item,
                'G01' as pur_group,
                g1.username as preq_name,
                e.remark as short_text,
                e.articlecode as material,
                e.sitecode as plant,
                e.qty as quantity,
                f.uom as unit,
                c.term as deliv_date,
                c.satuan as preq_price,
                'IDR' as currency ,
                e.accassign as acctasscat,
                e.gl as gl_account,
                e.costcenter as costcenter,
                e.`order` as orderid,
                c.taxcode as tax_code,
                d.id as trackingno,
                '01' as assetseq,
                e.asset as assetno,
                1 as assetqty,
                '' as text_item_id,
                '' as text_item_line
            FROM m_qe_hdr a
                LEFT JOIN m_qe_dtl b on b.hdrid = a.id
                LEFT JOIN m_lpbj_hdr d on d.id = a.lpbjid
                LEFT JOIN m_lpbj_dtl e on e.hdrid = d.id
                LEFT JOIN s_draftqe c on c.dtlid = e.id
                LEFT JOIN api_article f on f.productcode = e.articlecode
                LEFT JOIN m_users g on g.id = a.created_by
                LEFT JOIN m_users g1 on g1.id = d.created_by
            WHERE a.`status` = 11
            AND c.ispilih = 1
            AND a.id = :id
            ",
            ['id' => $id]
        );

        return $data;
    }

    public function insertJson($param)
    {
        if ($param['prno'] == '') {
            return "E";
        } else {
            DB::table('api_returnprpo')
                ->insert([
                    'prno' => $param['prno'],
                    'pono' => $param['pono'],
                    'lpbjid' => $param['lpbjid'],
                    'qeid' => $param['qeid'],
                    'json' => $param['json'],
                    'created_by' => session('iduser'),
                ]);
            return "S";
        }
    }

    public function statusQe($id)
    {
        $date = new DateTime('now');

        $insertApprove  = DB::table('m_lacak')
            ->where([
                'hdrqeid' => $id,
                'statusid' => 11,
                'approvalid' => session('iduser'),
            ])->delete();

        if ($insertApprove) {
            $data = DB::table('m_qe_hdr')
                ->where('id', $id)
                ->update([
                    'status' => 10,
                    'approve_by' => session('iduser'),
                    'approve_at' => $date,
                    'modified_by' => session('iduser'),
                    'workflow' => 'Approved_by_' . session('name')
                ]);
        }

        return $data;
    }

    public function popr($qeid, $lpbjid)
    {
        DB::table('m_lpbj_hdr')
            ->where('id', $lpbjid)
            ->update([
                'status' => 14,
                'modified_by' => session('iduser'),
                'workflow' => 'Dokumen telah Terbentuk PO / PR'
            ]);

        DB::table('m_qe_hdr')
            ->where('id', $qeid)
            ->update([
                'status' => 14,
                'modified_by' => session('iduser'),
                'workflow' => 'Dokumen telah Terbentuk PO / PR'
            ]);

        return;
    }
}
