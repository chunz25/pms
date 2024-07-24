<?php

namespace App\Models;

use DateTime;
use Illuminate\Database\Eloquent\Model;
use Illuminate\Support\Facades\DB;

class m_quotation extends Model
{
    public function getListQe()
    {
        $data = DB::select("
            SELECT DISTINCT
                a.id AS hdrid,
                a.userid AS userid,
                a.status AS statusid,
                c4.name as divname,
                d.name AS STATUS,
                a.nolpbj AS nolpbj,
                a.companycode,
                c3.name AS depname,
                date_format( cast( a.created_at AS DATE ), '%W, %d-%m-%Y' ) AS tglpermintaan,
                a.description AS description,
                a.note AS note,
                a.isqe AS isqe,
                CASE WHEN a.workflow IS NULL THEN d.NAME 
                    ELSE REPLACE ( a.workflow, '_', ' ' ) 
                END workflow,
                a.reason,
                c1.email AS emailpengaju,
                c.nama AS namapengaju 
            FROM m_lpbj_hdr a
                LEFT JOIN m_lpbj_dtl b ON b.hdrid = a.id
                LEFT JOIN m_pegawai c ON c.userid = a.userid
                LEFT JOIN m_users c1 on c1.id = c.userid
                LEFT JOIN m_subseksi c2 on c2.id = c.satkerid
                LEFT JOIN m_department c3 on c3.id = c2.departmentid
                left join m_divisi c4 on c4.id = c2.divisiid
                LEFT JOIN m_status d ON d.id = a.STATUS 
            WHERE a.isdeleted = 0 
                AND b.isdeleted = 0 
                AND a.status = 3 
                AND b.isqe = 0
        ");

        return $data;
    }

    public function getAttach($dtlid, $vendor)
    {
        $data = DB::table('s_draftqe')
            ->select('attachment')
            ->where('dtlid', $dtlid)
            ->where('vendorcode', $vendor)
            ->get();

        return $data;
    }

    public function getPilih($id)
    {
        $data = DB::table('s_draftqe')
            ->select('ispilih')
            ->where('id', $id)
            ->get();

        return $data;
    }

    public function getVendor()
    {
        $data = DB::table('api_vendor')
            ->select('*')
            ->where('companycode', session('cc'))
            ->get();

        return $data;
    }

    public function getTax()
    {
        $data = DB::select("
            select
                a.* ,
                format(a.amount,0)/100 as amt,
                concat(format(a.amount,0),'%') as persen
            from api_tax a
            where a.flag = 1 
        ");

        return $data;
    }

    public function getLpbj($id)
    {
        $data = DB::select("
            SELECT
                a.id AS hdrid,
                b.id AS dtlid,
                a.nolpbj AS nolpbj,
                a.companycode AS companycode,
                c2.name AS depname,
                date_format( cast( a.created_at AS DATE ), '%W, %d-%m-%Y' ) AS tglpermintaan,
                a.description AS description,
                b.articlecode AS articlecode,
                d.productname AS articlename,
                b.remark AS remark,
                b.qty AS qty,
                d.uom AS uom,
                b.sitecode AS sitecode,
                e.name1 AS sitename,
                b.accassign AS accassign,
                b.gl AS gl,
                b.costcenter AS costcenter,
                b.ORDER,
                b.asset AS asset,
                b.keterangan AS keterangan,
                b.gambar AS gambar,
                b.isqe AS isqe 
            FROM
                m_lpbj_hdr a
                LEFT JOIN m_lpbj_dtl b ON b.hdrid = a.id
                LEFT JOIN m_pegawai c ON c.userid = a.userid
                left join m_subseksi c1 on c1.id = c.satkerid
                left join m_department c2 on c2.id = c1.departmentid
                LEFT JOIN api_article d ON d.productcode = b.articlecode
                LEFT JOIN api_site e ON e.sitecode = b.sitecode 
            WHERE a.isdeleted = 0 
                AND b.isdeleted = 0 
                AND b.isqe = 0
                AND a.id = :hdrid
        ", ['hdrid' => $id]);

        return $data;
    }

    public function getLpbjDtl($id)
    {
        $data = DB::select("
            SELECT
                a.id AS hdrid,
                b.id AS dtlid,
                a.nolpbj AS nolpbj,
                a.companycode AS companycode,
                c2.name AS depname,
                date_format( cast( a.created_at AS DATE ), '%W, %d-%m-%Y' ) AS tglpermintaan,
                a.description AS description,
                b.articlecode AS articlecode,
                d.productname AS articlename,
                b.remark AS remark,
                b.qty AS qty,
                d.uom AS uom,
                b.sitecode AS sitecode,
                e.name1 AS sitename,
                b.accassign AS accassign,
                b.gl AS gl,
                b.costcenter AS costcenter,
                b.ORDER,
                b.asset AS asset,
                b.keterangan AS keterangan,
                b.gambar AS gambar,
                b.isqe AS isqe
            FROM m_lpbj_hdr a
                LEFT JOIN m_lpbj_dtl b ON b.hdrid = a.id
                LEFT JOIN m_pegawai c ON c.userid = a.userid
                left join m_subseksi c1 on c1.id = c.satkerid
                left join m_department c2 on c2.id = c1.departmentid
                LEFT JOIN api_article d ON d.productcode = b.articlecode
                LEFT JOIN api_site e ON e.sitecode = b.sitecode 
            WHERE a.isdeleted = 0 
                AND b.isdeleted = 0 
                AND b.isqe = 0
                AND b.id = :dtlid
        ", ['dtlid' => $id]);

        return $data;
    }

    public function getDraftEdit($data)
    {
        $hdrid = $data['hdrid'];
        $vendor = $data['vendor'];

        $data = DB::select("
            SELECT DISTINCT
                a.id,
                a.dtlid,
                b.hdrid ,
                a.vendorcode,
                c.name AS vendorname,
                a.ispilih,
                a.franco ,
                a.ispkp ,
                a.top ,
                d.amount as taxamt ,
                a.term,
                d.tax_code as taxcode ,
                concat(format(d.amount,0),'%') as persen ,
                a.contactperson ,
                a.notelp ,
                a.remark ,
                b.articlecode,
                b.qty,
                a.satuan,
                a.total,
                a.tax,
                a.gtotal,
                a.remarkqa,
                a.attachment,
                a.created_by AS userid 
            FROM s_draftqe a
                LEFT JOIN m_lpbj_dtl b ON b.id = a.dtlid
                LEFT JOIN api_vendor c ON c.suppliercode = a.vendorcode 
                LEFT JOIN api_tax d ON d.tax_code = a.taxcode
            WHERE a.isdeleted = 0 
                AND b.hdrid = :hdrid 
                AND a.vendorcode = :vendor
            ORDER BY a.vendorcode ASC
        ", [
            'hdrid' => $hdrid,
            'vendor' => $vendor
        ]);

        return $data;
    }

    public function getSubdetail($data)
    {
        $hdrid = $data['hdrid'];
        $vendor = $data['vendor'];

        $data = DB::select("
            SELECT DISTINCT
                a.id,
                a.dtlid,
                b.hdrid ,
                a.vendorcode,
                c.name AS vendorname,
                a.ispilih,
                a.franco ,
                a.ispkp ,
                a.top ,
                d.amount as taxamt ,
                a.term,
                d.tax_code as taxcode ,
                concat(format(d.amount,0),'%') as persen ,
                a.contactperson ,
                a.notelp ,
                a.remark ,
                b.articlecode,
                b.qty,
                a.satuan,
                a.total,
                a.tax,
                a.gtotal,
                a.remarkqa,
                a.attachment,
                a.created_by AS userid 
            FROM s_draftqe a
                LEFT JOIN m_lpbj_dtl b ON b.id = a.dtlid
                LEFT JOIN api_vendor c ON c.suppliercode = a.vendorcode 
                LEFT JOIN api_tax d ON d.tax_code = a.taxcode
                LEFT JOIN m_qe_dtl e ON e.draftid = a.id 
            WHERE b.isqe = 1 
                AND e.hdrid = :hdrid 
                AND a.vendorcode = :vendor
            ORDER BY a.vendorcode ASC
        ", [
            'hdrid' => $hdrid,
            'vendor' => $vendor
        ]);

        return $data;
    }

    public function getDraft($id)
    {
        $data = DB::select("
            SELECT DISTINCT
                a.id AS id,
                a.dtlid AS dtlid,
                a.vendorcode AS vendorcode,
                c.NAME AS vendorname,
                a.ispilih AS ispilih,
                b.articlecode AS articlecode,
                b.qty AS qty,
                a.satuan AS satuan,
                a.satuan * b.qty AS total,
                a.tax ,
                a.gtotal ,
                a.remarkqa AS remarkqa,
                a.attachment AS attachment,
                a.created_by AS userid 
            FROM s_draftqe a
                LEFT JOIN m_lpbj_dtl b ON b.id = a.dtlid
                LEFT JOIN api_vendor c ON c.suppliercode = a.vendorcode 
            WHERE a.isdeleted = 0 
            AND a.dtlid = :dtlid
            ORDER BY a.vendorcode ASC
        ", ['dtlid' => $id]);

        return $data;
    }

    public function getVDraft($id)
    {
        $data = DB::select("
            SELECT DISTINCT
                b.hdrid,
                a.vendorcode,
                c.NAME AS vendorname,
                a.ispilih AS ispilih,
                a.attachment
            FROM s_draftqe a
                LEFT JOIN m_lpbj_dtl b ON b.id = a.dtlid
                LEFT JOIN api_vendor c ON c.suppliercode = a.vendorcode 
            WHERE a.isdeleted = 0 
            AND a.dtlid = :dtlid
            ORDER BY a.vendorcode ASC
        ", ['dtlid' => $id]);

        return $data;
    }

    public function insertDraft($params)
    {
        $date = new DateTime('now');
        $dtlid = $params['dtlid'];
        $vendor = $params['vendorcode'];

        $getDraft = DB::select(
            "
            SELECT DISTINCT
                a.dtlid AS dtlid,
                a.vendorcode AS vendorcode
            FROM s_draftqe a
                LEFT JOIN m_lpbj_dtl b ON b.id = a.dtlid
                LEFT JOIN api_vendor c ON c.suppliercode = a.vendorcode
            WHERE a.isdeleted = 0 
            AND a.dtlid = :dtlid
            AND a.vendorcode = :vendor
            ORDER BY a.vendorcode ASC
        ",
            [
                'dtlid' => $dtlid,
                'vendor' => $vendor
            ]
        );

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
                'tax' => $params['pajak'],
                'gtotal' => $params['gtotal'],
                'total' => $params['total'],
                'taxcode' => $params['taxcode'],
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

    public function deleteDraft($id, $vendor)
    {
        $data = DB::table('s_draftqe')
            ->where('vendorcode', $vendor)
            ->where('dtlid', $id)
            ->update([
                'isdeleted' => 1,
                'modified_by' => session('iduser')
            ]);

        return $data;
    }

    public function getListHistory()
    {
        $group = session('idgroup');
        $userid = session('iduser');
        $depname = session('depname');
        $dirname = session('dirname');

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
                a.created_at,
                b.`name` AS statusname,
                CASE WHEN a.workflow IS NULL THEN b.`name` 
                    ELSE REPLACE ( a.workflow, '_', ' ' ) 
                END AS workflow ,
                f.name as depname ,
                c.created_by as userlpbj ,
                h.pono ,
                h.prno
            FROM m_qe_hdr a
                LEFT JOIN m_status b ON b.id = a.`status`
                LEFT JOIN m_lpbj_hdr c ON c.id = a.lpbjid
                LEFT JOIN m_pegawai d on d.userid = c.created_by
                LEFT JOIN m_subseksi e on e.id = d.satkerid
                LEFT JOIN m_department f on f.id = e.departmentid
                LEFT JOIN m_direktorat g on g.id = e.direktoratid
                LEFT JOIN api_returnprpo h on h.qeid = a.id
            WHERE 
                CASE WHEN :group = 12 THEN c.created_by = :userid
                     WHEN :group2 IN (13,14) THEN f.name = :depname
                     WHEN :group3 = 15 THEN g.name = :dirname
                ELSE a.status > 0
                END
        ",
            [
                'group' => $group,
                'userid' => $userid,
                'group2' => $group,
                'depname' => $depname,
                'dirname' => $dirname,
                'group3' => $group,
            ]
        );

        return $data;
    }

    public function getHistoryDetail($id)
    {
        $data = DB::select("        
            SELECT
                a.*
            FROM m_qe_dtl a
            where a.hdrid = :hdrid", ['hdrid' => $id]);

        return $data;
    }

    public function getHistoryHeader($id)
    {
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
                CASE WHEN a.workflow IS NULL THEN b.`name` 
                    ELSE REPLACE ( a.workflow, '_', ' ' ) 
                END AS workflow ,
                j.email as emailpengaju,
                a.reason
            FROM m_qe_hdr a
                LEFT JOIN m_status b ON b.id = a.`status`
                LEFT JOIN m_qe_dtl c ON hdrid = a.id
                LEFT JOIN s_draftqe d ON d.id = c.draftid
                LEFT JOIN m_lpbj_dtl e ON e.id = d.dtlid
                LEFT JOIN m_lpbj_hdr f ON f.id = e.hdrid 
                LEFT JOIN m_pegawai g on g.userid = d.created_by
                LEFT JOIN m_subseksi h on h.id = g.satkerid
                left join m_department i on i.id = h.departmentid
                left join m_users j on j.id = g.userid
            WHERE a.id = :hdrid
        ", ['hdrid' => $id]);

        return $data;
    }

    public function getVendorHeader($id)
    {
        $cc = session('cc');
        $data = DB::select("
            SELECT DISTINCT
                c.id AS hdrid,
                a.vendorcode,
                d.`name` AS vendorname,
                a.ispilih AS pilih,
                a.attachment ,
                format(sum(a.total),0) as total,
                format(sum(a.tax),0) as ppn,
                format(sum(a.gtotal),0) as gtotal,
                a.franco,
                case when a.ispkp = 1 then 'PKP' ELSE 'NON PKP' END as pkp,
                a.term ,
                a.top ,
                a.contactperson ,
                a.notelp,
                case when a.ispilih = 1 then 'x' else '' end as ispilih,
                a.remark
            FROM s_draftqe a
                LEFT JOIN m_qe_dtl b ON b.draftid = a.id
                LEFT JOIN m_qe_hdr c ON c.id = b.hdrid
                left join m_lpbj_dtl e on e.id = a.dtlid
                left join m_lpbj_hdr f on f.id = e.hdrid
                LEFT JOIN api_vendor d ON d.suppliercode = a.vendorcode AND d.companyCode = f.companycode
            WHERE c.id = :hdrid
            AND d.companycode = :compcode
            GROUP BY 
                a.vendorcode, 
                c.id, 
                d.name, 
                a.ispilih, 
                a.attachment, 
                a.franco, 
                a.ispkp,
                a.term,
                a.top,
                a.remark,
                a.contactperson,
                a.notelp
        ", [
            'hdrid' => $id,
            'compcode' => $cc
        ]);

        return $data;
    }

    public function getVendorDetail($vendor, $hdrid)
    {
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
        $depname = session('depname');
        $a = session('idgroup');
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
                left join m_qe_dtl b on b.draftid = a.id
                left join m_qe_hdr c on c.id = b.hdrid
                left join m_status d on d.id = c.`status`
                left join m_pegawai e on e.userid = a.created_by
                left join m_subseksi f on f.id = e.satkerid
                left join m_department g on g.id = f.departmentid
                left join m_lpbj_dtl h on h.id = a.dtlid
                left join m_lpbj_hdr i on i.id = h.hdrid
            WHERE b.isdeleted = 0
            and CASE WHEN :a = 1 THEN c.status < 15
            ELSE c.status = :status
            END
            ",
            [
                'a' => $a,
                'status' => $status
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
                'approve_at' => $date,
                'created_by' => session('iduser'),
                'created_at' => $date,
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
        $data = DB::table('m_qe_hdr')
            ->where('id', $id)
            ->update([
                'status' => $status,
                'reason' => $reason,
                'workflow' => 'Reject_by_' . session('name'),
                'modified_by' => session('iduser')
            ]);

        return $data;
    }
}
