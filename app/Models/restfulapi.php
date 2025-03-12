<?php

namespace App\Models;

use DateTime;
use Illuminate\Database\Eloquent\Model;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Facades\Log;

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
                a.noqe as ref_1 ,
                d.nolpbj as ref_2 ,
                a.id qeid ,
                d.id lpbjid ,
                g.usersap as created_by,
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
                g1.usersap as preq_name,
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
                d.nolpbj as trackingno,
                '01' as assetseq,
                e.asset as assetno,
                1 as assetqty,
                '' as text_item_id,
                '' as text_item_line
            FROM m_qe_hdr a
                LEFT JOIN m_qe_dtl b on b.hdrid = a.id
                LEFT JOIN s_draftqe c on c.id = b.draftid
                LEFT JOIN m_lpbj_hdr d on d.id = a.lpbjid
                LEFT JOIN m_lpbj_dtl e on e.id = c.dtlid
                LEFT JOIN api_article f on f.productcode = e.articlecode
                LEFT JOIN m_users g on g.id = a.created_by
                LEFT JOIN m_users g1 on g1.id = d.created_by
            WHERE a.id = :id
            AND c.ispilih = 1
            AND a.`status` = 11
            ",
            ['id' => $id]
        );

        return $data;
    }

    public function getPR($qeid)
    {
        $getPR = DB::table('api_returnprpo')
            ->select('id', 'prno')
            ->where([
                'qeid' => $qeid,
                'isdeleted' => 0,
                'pono' => '',
            ])->get();

        return $getPR;
    }

    public function insertJson($param)
    {
        $xx = DB::table('api_returnprpo')
            ->select('id')
            ->where([
                'lpbjid' => $param['lpbjid'],
                'qeid' => $param['qeid']
            ])
            ->get();

        // dd($xx);
        if (count($xx) > 0) {
            foreach ($xx as $x) {
                DB::table('api_returnprpo')
                    ->where('id', $x->id)
                    ->update([
                        'modified_by' => session('iduser'),
                        'isdeleted' => 1,
                    ]);
            }
        }

        if ($param['prno'] == '') {
            DB::table('api_returnprpo')
                ->insert([
                    'prno' => $param['prno'],
                    'pono' => $param['pono'],
                    'lpbjid' => $param['lpbjid'],
                    'qeid' => $param['qeid'],
                    'json' => $param['json'],
                    'created_by' => session('iduser'),
                ]);
            return false;
        } else if ($param['param3'] != '') {
            DB::table('api_returnprpo')
                ->where('id', $param['id'])
                ->update([
                    'modified_by' => session('iduser'),
                    'isdeleted' => 1,
                ]);
            DB::table('api_returnprpo')
                ->insert([
                    'prno' => $param['prno'],
                    'pono' => $param['pono'],
                    'lpbjid' => $param['lpbjid'],
                    'qeid' => $param['qeid'],
                    'json' => $param['json'],
                    'created_by' => session('iduser'),
                ]);
            return true;
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
            return true;
        }
    }

    public function statusQe($id)
    {
        $date = new DateTime('now');

        $insertApprove = DB::table('m_lacak')
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
                    'workflow' => 'Gagal_Create_PO'
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

    public function getDataClosed($qeid)
    {
        $data = DB::select(
            "
           SELECT DISTINCT
                a.id as qeid ,
                e.id as lpbjdtlid ,
                d.id as lpbjhdrid ,
                rp.pono
            FROM m_qe_hdr a
                LEFT JOIN m_qe_dtl b on b.hdrid = a.id
                LEFT JOIN s_draftqe c on c.id = b.draftid
                LEFT JOIN m_lpbj_hdr d on d.id = a.lpbjid
                LEFT JOIN m_lpbj_dtl e on e.hdrid = d.id
                LEFT JOIN api_article f on f.productcode = e.articlecode
                LEFT JOIN m_users g on g.id = a.created_by -- userQE
                LEFT JOIN m_users g1 on g1.id = d.created_by -- userLPBJ
                LEFT JOIN api_returnprpo rp ON rp.qeid = a.id AND rp.isdeleted = 0
            WHERE a.`status` = 14
            AND c.ispilih = 1
            AND a.id = :id
            ",
            ['id' => $qeid]
        );

        return $data;
    }

    public function getDataPO($qeid)
    {
        $data = DB::select(
            "
           SELECT DISTINCT
                a.id as qeid ,
                rp.pono
            FROM m_qe_hdr a
                LEFT JOIN m_qe_dtl b on b.hdrid = a.id
                LEFT JOIN s_draftqe c on c.id = b.draftid
                LEFT JOIN m_lpbj_hdr d on d.id = a.lpbjid
                LEFT JOIN m_lpbj_dtl e on e.hdrid = d.id
                LEFT JOIN api_article f on f.productcode = e.articlecode
                LEFT JOIN m_users g on g.id = a.created_by -- userQE
                LEFT JOIN m_users g1 on g1.id = d.created_by -- userLPBJ
                LEFT JOIN api_returnprpo rp ON rp.qeid = a.id AND rp.isdeleted = 0
            WHERE a.`status` = 14
            AND c.ispilih = 1
            AND a.id = :id
            ",
            ['id' => $qeid]
        );

        return $data;
    }

    public function updLPBJdtl($params)
    {
        try {
            $userId = session('iduser');
            $commonUpdateData = [
                'status' => 15,
                'modified_by' => $userId,
                'workflow' => 'LPBJ_CLOSED'
            ];

            DB::beginTransaction(); // Start transaction

            DB::table('m_qe_hdr')
                ->where('id', $params['qeid'])
                ->update($commonUpdateData);

            DB::table('m_lpbj_hdr')
                ->where('id', $params['lpbjhdrid'])
                ->update($commonUpdateData);

            DB::table('m_lpbj_dtl')
                ->where('id', $params['lpbjdtlid'])
                ->update([
                    'isclosed' => 1,
                    'modified_by' => $userId,
                    'filegr' => $params['filegr']
                ]);

            DB::commit(); // Commit transaction
            return true;
        } catch (\Exception $e) {
            DB::rollBack(); // Rollback transaction on error
            // Log the error message
            Log::error('Error updating records: ' . $e->getMessage());
            return false; // Return false to indicate failure
        }
    }

    public function inserttbl($params)
    {
        // dd($params);
        DB::table('api_returncloselpbj')
            ->insert([
                'pono' => $params['nopo'],
                'qeid' => $params['qeid'],
                'json' => $params['res'],
                'created_by' => session('iduser'),
            ]);
        return true;
    }

}
