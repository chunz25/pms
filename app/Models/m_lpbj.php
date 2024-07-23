<?php

namespace App\Models;

use DateTime;
use Illuminate\Database\Eloquent\Model;
use Illuminate\Support\Facades\DB;

class m_lpbj extends Model
{
    public function getPegawai($userid)
    {
        $data = DB::select('
            SELECT DISTINCT
                a.id AS pegawaiid,
                a.userid,
                a.satkerid,
                f.username AS nik,
                a.nama AS name,
                c.name AS jabatanname,
                b3.name as unitname,
                b2.name as divname,
                b1.name as depname,
                h.usergroupname AS userrole,
                f.email 
            FROM m_pegawai a
                LEFT JOIN m_subseksi b ON b.id = a.satkerid
                LEFT JOIN m_department b1 ON b1.id = b.departmentid
                LEFT JOIN m_divisi b2 ON b2.id = b.divisiid
                LEFT JOIN m_unitkerja b3 ON b3.id = b.unitkerjaid
                LEFT JOIN m_jabatan c ON c.id = a.jabatanid
                LEFT JOIN m_level d ON d.id = a.levelid
                LEFT JOIN m_lokasi e ON e.id = a.lokasiid
                LEFT JOIN m_users f ON f.id = a.userid
                LEFT JOIN m_usergroup g ON g.iduser = f.id
                LEFT JOIN m_group h ON h.id = g.idgroup
            WHERE a.userid = :userid
        ', ['userid' => $userid]);

        return $data;
    }

    public function getDraft()
    {
        $userid = session('iduser');
        $data = DB::select("
            SELECT
                a.id,
                a.userid,
                a.articlecode,
                b.productname AS articlename,
                a.remark,
                a.qty,
                b.uom,
                a.sitecode,
                c.name1 AS sitename,
                CASE WHEN a.accassign = 'K' THEN 'K - COST CENTER' 
                     WHEN a.accassign = 'A' THEN 'Y - ASSET' 
                END AS accassign,
                a.gl,
                a.costcenter,
                a.order,
                a.asset,
                a.keterangan,
                a.gambar
            FROM s_draftlpbj a
                LEFT JOIN api_article b ON b.productcode = a.articlecode
                LEFT JOIN api_site c ON c.sitecode = a.sitecode 
            WHERE a.isdeleted = 0
                AND a.userid = :userid
        ", ['userid' => $userid]);

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
            ->where('companycode', session('cc'))
            ->get();

        return $data;
    }

    public function getCC()
    {
        $data = DB::table('api_costcenter')
            ->select('*')
            ->where('companycode', session('cc'))
            ->get();

        return $data;
    }

    public function getOrder()
    {
        $data = DB::table('api_order')
            ->select('*')
            ->where('companycode', session('cc'))
            ->get();

        return $data;
    }

    public function getAsset()
    {
        $data = DB::table('api_asset')
            ->select('*')
            ->where('companycode', session('cc'))
            ->where('change_date', '>=', '2024-01-01')
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

    public function deleteDtl($id)
    {
        $data = DB::table('m_lpbj_dtl')
            ->where('id', $id)
            ->update([
                'isdeleted' => 1,
                'modified_by' => session('iduser')
            ]);

        return $data;
    }

    public function cekDraft($id)
    {
        $data = DB::select("
            SELECT
                a.id,
                a.userid,
                a.articlecode,
                b.productname AS articlename,
                a.remark,
                a.qty,
                b.uom,
                a.sitecode,
                c.name1 AS sitename,
                CASE WHEN a.accassign = 'K' THEN 'K - COST CENTER' 
                    WHEN a.accassign = 'A' THEN 'Y - ASSET' 
                END AS accassign,
                a.gl,
                a.costcenter,
                a.order,
                a.asset,
                a.keterangan,
                a.gambar 
            FROM s_draftlpbj a
                LEFT JOIN api_article b ON b.productcode = a.articlecode
                LEFT JOIN api_site c ON c.sitecode = a.sitecode 
            WHERE a.isdeleted = 0
                AND a.id = :id
        ", ['id' => $id]);

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
        // dd($params);
        $data = DB::table('m_lpbj_hdr')
            ->where('id', $params['hdrid'])
            ->update([
                'status' => $params['status'],
                'description' => $params['description'],
                'note' => $params['note'],
                'workflow' => 'Pengajuan_LPBJ_Revisi_by_' . session('name'),
                'reason' => null,
                'modified_by' => session('iduser')
            ]);

        return $data;
    }

    public function getHistory()
    {
        $divname = session('divname');
        $data = DB::select("
            SELECT DISTINCT
                a.id AS hdrid,
                a.userid,
                a.status AS statusid,
                c3.name as divname,
                d.name AS status,
                a.nolpbj,
                a.companycode,
                c2.name as depname,
                date_format( cast( a.created_at AS DATE ), '%W, %d-%m-%Y' ) AS tglpermintaan,
                a.description,
                a.note,
                a.isqe,
                CASE WHEN a.workflow IS NULL THEN d.name 
                    WHEN a.status = 0 THEN d.name
                    ELSE REPLACE ( a.workflow, '_', ' ' ) 
                END workflow,
                a.reason,
                e.email AS emailpengaju,
                c.nama AS namapengaju 
            FROM m_lpbj_hdr a
                LEFT JOIN m_lpbj_dtl b ON b.hdrid = a.id
                LEFT JOIN m_pegawai c ON c.userid = a.userid
                LEFT JOIN m_subseksi c1 ON c1.id = c.satkerid
                LEFT JOIN m_department c2 ON c2.id = c1.departmentid
                LEFT JOIN m_divisi c3 ON c3.id = c1.divisiid
                LEFT JOIN m_status d ON d.id = a.status 
                left join m_users e on e.id = c.userid
            WHERE a.isdeleted = 0 
                AND b.isdeleted = 0
                AND c3.name = :divname
            ", ['divname' => $divname]);

        return $data;
    }

    public function getHistoryHeader($id)
    {
        $data = DB::select("
            SELECT DISTINCT
                a.id AS hdrid,
                a.userid,
                a.status AS statusid,
                h.name as divname,
                d.name AS status,
                a.nolpbj,
                a.companycode,
                f.name as depname,
                date_format( cast( a.created_at AS DATE ), '%W, %d-%m-%Y' ) AS tglpermintaan,
                a.description,
                a.note,
                a.isqe,
                CASE WHEN a.workflow IS NULL THEN d.name 
                    ELSE REPLACE(a.workflow,'_',' ')
                END workflow,
                a.reason,
                g.email AS emailpengaju,
                c.nama AS namapengaju ,
                i1.nama as approval1,
                j1.nama as approval2
            FROM m_lpbj_hdr a
                LEFT JOIN m_lpbj_dtl b ON b.hdrid = a.id
                LEFT JOIN m_pegawai c ON c.userid = a.userid
                LEFT JOIN m_status d ON d.id = a.status 
                left join m_subseksi e on e.id = c.satkerid
                left join m_department f on f.id = e.departmentid
                left join m_users g on g.id = c.userid
                left join m_divisi h on h.id = e.divisiid
                left join m_approver i on i.userid = c.userid
                left join m_pegawai i1 on i1.userid = i.approveid
                left join m_approver j on j.userid = i.approveid
                left join m_pegawai j1 on j1.userid = j.approveid
            WHERE a.isdeleted = 0 
                AND b.isdeleted = 0
                AND a.id = :hdrid
            ", ['hdrid' => $id]);

        return $data;
    }

    public function getApprove($status)
    {
        $depname = session('depname');
        $a = session('idgroup');
        $data = DB::select(
            "
            SELECT DISTINCT
                a.id AS hdrid,
                a.userid,
                a.status AS statusid,
                h.name as divname,
                d.name AS status,
                a.nolpbj,
                a.companycode,
                f.name as depname,
                date_format( cast( a.created_at AS DATE ), '%W, %d-%m-%Y' ) AS tglpermintaan,
                a.description,
                a.note,
                a.isqe,
                CASE WHEN a.workflow IS NULL THEN d.name 
                    ELSE REPLACE(a.workflow,'_',' ')
                END workflow,
                a.reason,
                g.email AS emailpengaju,
                c.nama AS namapengaju 
            FROM
                m_lpbj_hdr a
                LEFT JOIN m_lpbj_dtl b ON b.hdrid = a.id
                LEFT JOIN m_pegawai c ON c.userid = a.userid
                LEFT JOIN m_status d ON d.id = a.status 
                left join m_subseksi e on e.id = c.satkerid
                left join m_department f on f.id = e.departmentid
                left join m_users g on g.id = c.userid
                left join m_divisi h on h.id = e.divisiid
            WHERE a.isdeleted = 0 
                AND b.isdeleted = 0
            AND CASE WHEN :a = 1 THEN f.name LIKE '%'
            ELSE f.name = :depname
            END
            AND CASE WHEN :a1 = 1 THEN a.status < 3
            ELSE a.status = :status
            END ",
            [
                'a' => $a,
                'a1' => $a,
                'depname' => $depname,
                'status' => $status
            ]
        );

        return $data;
    }

    public function getHistoryDetail($id)
    {
        $data = DB::select("
            SELECT
                a.id AS hdrid,
                b.id AS dtlid,
                a.nolpbj,
                a.companycode,
                g.name as depname,
                date_format( cast( a.created_at AS DATE ), '%W, %d-%m-%Y' ) AS tglpermintaan,
                a.description,
                b.articlecode,
                d.productname,
                b.remark,
                b.qty,
                d.uom,
                b.sitecode,
                e.name1 AS sitename,
                b.accassign,
                b.gl,
                b.costcenter,
                b.order,
                b.asset,
                b.keterangan,
                b.gambar,
                b.isqe 
            FROM m_lpbj_hdr a
                LEFT JOIN m_lpbj_dtl b ON b.hdrid = a.id
                LEFT JOIN m_pegawai c ON c.userid = a.userid
                LEFT JOIN api_article d ON d.productcode = b.articlecode
                LEFT JOIN api_site e ON e.sitecode = b.sitecode 
                left join m_subseksi f on f.id = c.satkerid
                left join m_department g on g.id = f.departmentid
            WHERE a.isdeleted = 0 
                AND b.isdeleted = 0
                AND a.id = :hdrid
        ", ['hdrid' => $id]);

        return $data;
    }

    public function getHistoryDetailEdt($id)
    {
        $data = DB::select("
            SELECT
                a.id AS hdrid,
                b.id AS dtlid,
                a.nolpbj,
                a.companycode,
                g.name as depname,
                date_format( cast( a.created_at AS DATE ), '%W, %d-%m-%Y' ) AS tglpermintaan,
                a.description,
                b.articlecode,
                d.productname articlename,
                b.remark,
                b.qty,
                d.uom,
                b.sitecode,
                e.name1 AS sitename,
                b.accassign,
                b.gl,
                b.costcenter,
                b.order,
                b.asset,
                b.keterangan,
                b.gambar,
                b.isqe 
            FROM m_lpbj_hdr a
                LEFT JOIN m_lpbj_dtl b ON b.hdrid = a.id
                LEFT JOIN m_pegawai c ON c.userid = a.userid
                LEFT JOIN api_article d ON d.productcode = b.articlecode
                LEFT JOIN api_site e ON e.sitecode = b.sitecode 
                left join m_subseksi f on f.id = c.satkerid
                left join m_department g on g.id = f.departmentid
            WHERE a.isdeleted = 0 
                AND b.isdeleted = 0
                AND b.id = :dtlid
        ", ['dtlid' => $id]);

        return $data;
    }

    public function insertLpbj($id, $status)
    {
        $data = DB::table('m_lpbj_hdr')
            ->where('id', $id)
            ->update([
                'status' => ($status + 1),
                'workflow' => 'Approved_by_' . session('name'),
                'modified_by' => session('iduser')
            ]);

        return $data;
    }

    public function updateDraftDetail($params)
    {
        $data = DB::table('m_lpbj_dtl')
            ->where('id', $params['dtlid'])
            ->update([
                'articlecode' => $params['articlecode'],
                'remark' => $params['remark'],
                'qty' => $params['qty'],
                'sitecode' => $params['sitecode'],
                'accassign' => $params['accassign'],
                'gl' => $params['gl'],
                'costcenter' => $params['costcenter'],
                'order' => $params['order'],
                'asset' => $params['asset'],
                'keterangan' => $params['keterangan'],
                'gambar' => $params['gambar'],
                'modified_by' => $params['userid'],
            ]);

        return $data;
    }

    public function insertDraftHistory($params)
    {
        $date = new DateTime('now');

        $data = DB::table('m_lpbj_dtl')->insert([
            'hdrid' => $params['hdrid'],
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

    public function rejectLpbj($id, $status, $reason)
    {
        // dd($status);
        $data = DB::table('m_lpbj_hdr')
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
