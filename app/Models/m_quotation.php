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

    public function getTax()
    {
        $data = DB::table('vw_tax')
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

<<<<<<< Updated upstream
=======
    public function updateDraftQe($params)
    {
        $data = DB::table('s_draftqe')
            ->where('dtlid', $params['dtlid'])
            ->where('vendorcode', $params['vendorcode'])
            ->update([
                'satuan' => $params['satuan'],
                'remarkqa' => $params['remarkqa'],
                'attachment' => $params['attachment'],
                'vendorcode' => $params['vendorcode'],
                'franco' => $params['franco'],
                'ispkp' => $params['ispkp'],
                'term' => $params['term'],
                'top' => $params['top'],
                'contactperson' => $params['contactperson'],
                'notelp' => $params['notelp'],
                'ispilih' => $params['ispilih'],
                'remark' => $params['remark'],
                'tax' => $params['pajak'],
                'gtotal' => $params['gtotal'],
                'total' => $params['total'],
                'taxcode' => $params['taxcode'],
                'modified_by' => session('iduser')
            ]);

        return $data;
    }


    public function updateQeRev($id)
    {
        $userid = session('iduser');
        // dd($id);
        DB::statement("CALL sp_updqehdr($userid,$id)");
        $data = DB::select("
            select DISTINCT
                a.hdrid
            from m_qe_dtl a 
            LEFT JOIN s_draftqe b on b.id = a.draftid
            where dtlid = :dtlid
        ", ['dtlid' => $id]);
        return $data;
    }

    public function attachHdr($id,$file)
    {
        $data = DB::table('m_qe_hdr')
            ->where('id',$id)
            ->update([
                'attach' => $file
            ]);

        return $data;
    }

<<<<<<< Updated upstream
>>>>>>> Stashed changes
=======
>>>>>>> Stashed changes
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
<<<<<<< Updated upstream
        $data = DB::table('vw_historyqe')
            ->select('*')
            ->get();
=======
        $group = session('idgroup');
        $userid = session('iduser');
        $depname = session('depname');
        $divname = session('divname');
        $dirname = session('dirname');

        // dd(session()->all());

        $data = DB::select(
            "
            SELECT DISTINCT
                a.id AS hdrid,
                a.lpbjid,
                c.nolpbj,
                c.description,
                a.noqe,
                a.reason,
                a.`status` AS statusid,
                date_format( cast( a.created_at AS DATE ), '%W, %d-%m-%Y' ) AS created_at,
                b.`name` AS status,
                CASE WHEN a.workflow IS NULL THEN b.`name` 
                    ELSE REPLACE ( a.workflow, '_', ' ' ) 
                END AS workflow ,
                f.name as depname ,
                c.created_by as userlpbj ,
                h.pono ,
                h.prno ,
                a.created_by as userid
            FROM m_qe_hdr a
                LEFT JOIN m_status b ON b.id = a.`status`
                LEFT JOIN m_lpbj_hdr c ON c.id = a.lpbjid
                LEFT JOIN m_pegawai d on d.userid = c.created_by
                LEFT JOIN m_subseksi e on e.id = d.satkerid
                LEFT JOIN m_department f on f.id = e.departmentid
                LEFT JOIN m_direktorat g on g.id = e.direktoratid
                LEFT JOIN api_returnprpo h on h.qeid = a.id AND h.isdeleted = 0
                LEFT JOIN m_divisi i on i.id = e.divisiid
            WHERE a.isdeleted = 0 AND
                CASE WHEN :group IN (4,12) THEN c.created_by = :userid
                     WHEN :group2 IN (3,8,13,14) THEN i.name = :divname
                     WHEN :group3 IN (18) THEN 1 = 1
                     WHEN :group4 IN (15) THEN g.name = :dirname
                ELSE a.status >= 0
                END
        ",
            [
                'group' => $group,
                'userid' => $userid,
                'group2' => $group,
                'divname' => $divname,
                'group3' => $group,
                'group4' => $group,
                'dirname' => $dirname,
            ]
        );
>>>>>>> Stashed changes

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
<<<<<<< Updated upstream
        $data = DB::table('vw_historyqe')
            ->select('*')
            ->where('hdrid', '=', $id)
            ->get();
=======
        $data = DB::select("
            SELECT DISTINCT
                a.id AS hdrid,
                a.lpbjid,
                a.noqe,
                a.reason,
                a.`status` AS statusid,
                a.created_by,
                a.created_at,
                f.companycode,
                i.name as depname ,
                b.`name` AS statusname,
                a.created_at as tglpermintaan ,
                f.description ,
                f.note ,
                f.nolpbj,
                g.nama as namacreated,
                g1.nama as namacreated1,
                CASE WHEN a.workflow IS NULL THEN b.`name` 
                    ELSE REPLACE ( a.workflow, '_', ' ' ) 
                END AS workflow ,
                j.email as emailpengaju,
                a.reason,
                d.remark
            FROM m_qe_hdr a
                LEFT JOIN m_status b ON b.id = a.`status`
                LEFT JOIN m_qe_dtl c ON hdrid = a.id
                LEFT JOIN s_draftqe d ON d.id = c.draftid
                LEFT JOIN m_lpbj_dtl e ON e.id = d.dtlid
                LEFT JOIN m_lpbj_hdr f ON f.id = e.hdrid 
                LEFT JOIN m_pegawai g on g.userid = f.created_by
                LEFT JOIN m_pegawai g1 on g1.userid = a.created_by
                LEFT JOIN m_subseksi h on h.id = g.satkerid
                left join m_department i on i.id = h.departmentid
                left join m_users j on j.id = g.userid
            WHERE a.id = :hdrid
        ", ['hdrid' => $id]);
>>>>>>> Stashed changes

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
<<<<<<< Updated upstream
        $data = DB::table('vw_vendordtl')
            ->select('*')
            ->where('vendorcode', '=', $vendor)
            ->get();
=======
        $data = DB::select("
            SELECT DISTINCT
                c.hdrid,
                a.vendorcode,
                b.articlecode,
                d.productname as articlename ,
                d.uom ,
                Format( b.qty, 0 ) AS qty,
                Format( a.satuan, 0 ) AS satuan,
                format( a.total, 0 ) AS total,
                format( a.tax, 0 ) AS tax,
                format( a.gtotal, 0 ) AS gtotal,
                a.remarkqa,
                b.remark,
                a.attachment ,
                b.costcenter ,
                b.gl,
                b.order,
                b.asset
            FROM s_draftqe a
                LEFT JOIN m_lpbj_dtl b ON b.id = a.dtlid
                LEFT JOIN m_qe_dtl c ON c.draftid = a.id
                LEFT JOIN api_article d ON d.productcode = b.articlecode
            where a.vendorcode = :vendor
            AND c.hdrid = :hdrid
        ", [
            'vendor' => $vendor,
            'hdrid' => $hdrid
        ]);

        return $data;
    }

    public function getApprove($status)
    {
        // dd($status);
        $depname = session('depname');
        $divname = session('divname');
        $dirname = session('dirname');
        $group = session('idgroup');
        $userid = session('iduser');
        $stat = join("','", $status);

        $data = DB::select(
            "
                    select DISTINCT
                        c.id as hdrid ,
                        c.noqe ,
                        d.name as statusname ,
                        c.workflow ,
                        g.name as depname ,
                        c.created_at as tglpermintaan ,
                        i.description ,
                        i.companycode
                    from s_draftqe a
                        LEFT JOIN m_qe_dtl b ON b.draftid = a.id
                        LEFT JOIN m_qe_hdr c ON c.id = b.hdrid
                        LEFT JOIN m_status d ON d.id = c.`status`
                        LEFT JOIN m_lpbj_dtl h ON h.id = a.dtlid
                        LEFT JOIN m_lpbj_hdr i ON i.id = h.hdrid
                        LEFT JOIN m_pegawai e ON e.userid = i.created_by
                        LEFT JOIN m_subseksi f ON f.id = e.satkerid
                        LEFT JOIN m_department g ON g.id = f.departmentid
                        LEFT JOIN m_direktorat j ON j.id = f.direktoratid 
                        LEFT JOIN m_divisi k ON k.id = f.divisiid 
                    WHERE b.isdeleted = 0
                    and CASE WHEN :group = 1 THEN c.status < 11 -- ADMIN
                            WHEN :group2 IN (4,12) THEN i.created_by = :userid -- ADMINDEPT
                            WHEN :group3 IN (3,8,13,14) THEN k.name = :divname -- HEAD1&2
                            WHEN :group4 IN (18) THEN 1 = 1 -- BOD FA 
                            WHEN :group5 IN (15) THEN j.name = :dirname -- BOD 
                        ELSE c.status IN ('$stat')
                        END
                    AND CASE WHEN :group6 = 1 THEN c.status < 11
                            ELSE c.status IN ('$stat')
                        END
            ",
            [
                'group' => $group,
                'group2' => $group,
                'group3' => $group,
                'group4' => $group,
                'group5' => $group,
                'group6' => $group,
                'divname' => $divname,
                'dirname' => $dirname,
                'userid' => $userid,
            ]
        );

        return $data;
    }

    public function setujuQe($id, $status)
    {
        $date = new DateTime('now');

        $insertApprove  = DB::table('m_lacak')
            ->insert([
                'hdrqeid' => $id,
                'statusid' => ($status + 1),
                'approvalid' => session('iduser'),
                'created_by' => session('iduser'),
            ]);

        if ($insertApprove) {
            $data = DB::table('m_qe_hdr')
                ->where('id', $id)
                ->update([
                    'status' => ($status + 1),
                    'approve_by' => session('iduser'),
                    'approve_at' => $date,
                    'modified_by' => session('iduser'),
                    'workflow' => 'Approved_by_' . session('name')
                ]);
        }

        return $data;
    }

    public function getLacak($id)
    {
        $data = DB::select(
            "
            SELECT DISTINCT
                GROUP_CONCAT( CASE WHEN b.statusid = 2 THEN d.nama END ) AS approval1,
                GROUP_CONCAT( CASE WHEN b.statusid = 3 THEN d.nama END ) AS approval2,
                GROUP_CONCAT( CASE WHEN b.statusid = 4 THEN d.nama END ) AS approval3,
                GROUP_CONCAT( CASE WHEN b.statusid = 5 THEN d.nama END ) AS approval4,
                GROUP_CONCAT( CASE WHEN b.statusid = 6 THEN d.nama END ) AS approval5,
                GROUP_CONCAT( CASE WHEN b.statusid = 7 THEN d.nama END ) AS approval6,
                GROUP_CONCAT( CASE WHEN b.statusid = 8 THEN d.nama END ) AS approval7,
                GROUP_CONCAT( CASE WHEN b.statusid = 9 THEN d.nama END ) AS approval8,
                GROUP_CONCAT( CASE WHEN b.statusid = 10 THEN d.nama END ) AS approval9,
                GROUP_CONCAT( CASE WHEN b.statusid = 11 THEN d.nama END ) AS approval10 
            FROM m_qe_hdr a
                LEFT JOIN m_lacak b ON b.hdrqeid = a.id
                LEFT JOIN m_pegawai d ON d.userid = b.approvalid 
            WHERE a.id = :hdrqeid
            ",
            [
                'hdrqeid' => $id,
            ]
        );

        return $data;
    }

    public function rejectQe($id, $status, $reason)
    {
        // dd($status);
        $userid = session('iduser');

        $data = DB::table('m_qe_hdr')
            ->where('id', $id)
            ->update([
                'status' => $status,
                'reason' => $reason,
                'workflow' => 'Reject_by_' . session('name'),
                'modified_by' => session('iduser')
            ]);

        if ($status == 0) {
            $data = DB::statement("CALL sp_rstDraft($id,$userid)");
        }


        return $data;
    }


    public function rstDraft($id)
    {
        $userid = session('iduser');
        $data = DB::statement("CALL sp_rstDraft($id,$userid)");
        return $data;
    }

    public function idDraft($id)
    {
        $data = DB::select(
            "
            SELECT DISTINCT
                c.dtlid
            FROM m_qe_hdr a
            LEFT JOIN m_qe_dtl b on b.hdrid = a.id
            LEFT JOIN s_draftqe c on c.id = b.draftid
            WHERE a.id = :hdrid
            ",
            [
                'hdrid' => $id,
            ]
        );
>>>>>>> Stashed changes

        return $data;
    }
}
