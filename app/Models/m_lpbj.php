<?php

namespace App\Models;

use DateTime;
use Illuminate\Database\Eloquent\Model;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Facades\Log;

class m_lpbj extends Model
{
    public function getPegawai($userid)
    {
<<<<<<< Updated upstream
<<<<<<< Updated upstream
<<<<<<< Updated upstream
        $data = DB::table('vw_getpegawai')
            ->select('*')
            ->where('userid', '=', $userid)
            ->get();
=======
=======
>>>>>>> Stashed changes
=======
>>>>>>> Stashed changes
        try {
            $data = DB::table('m_pegawai as a')
                ->select(
                    'a.id AS pegawaiid',
                    'a.userid',
                    'a.satkerid',
                    'f.username AS nik',
                    'a.nama AS name',
                    'c.name AS jabatanname',
                    'b3.name AS unitname',
                    'b2.name AS divname',
                    'b1.name AS depname',
                    'h.usergroupname AS userrole',
                    'f.email'
                )
                ->leftJoin('m_subseksi as b', 'b.id', '=', 'a.satkerid')
                ->leftJoin('m_department as b1', 'b1.id', '=', 'b.departmentid')
                ->leftJoin('m_divisi as b2', 'b2.id', '=', 'b.divisiid')
                ->leftJoin('m_unitkerja as b3', 'b3.id', '=', 'b.unitkerjaid')
                ->leftJoin('m_jabatan as c', 'c.id', '=', 'a.jabatanid')
                ->leftJoin('m_level as d', 'd.id', '=', 'a.levelid')
                ->leftJoin('m_lokasi as e', 'e.id', '=', 'a.lokasiid')
                ->leftJoin('m_users as f', 'f.id', '=', 'a.userid')
                ->leftJoin('m_usergroup as g', 'g.iduser', '=', 'f.id')
                ->leftJoin('m_group as h', 'h.id', '=', 'g.idgroup')
                ->where('a.userid', $userid)
                ->distinct()
                ->get();
<<<<<<< Updated upstream
<<<<<<< Updated upstream
>>>>>>> Stashed changes
=======
>>>>>>> Stashed changes
=======
>>>>>>> Stashed changes

            return $data;
        } catch (\Exception $e) {
            Log::error('Error fetching pegawai: ' . $e->getMessage());
            return null; // or handle it as required
        }
    }

    public function getDraft()
    {
<<<<<<< Updated upstream
        $data = DB::table('vw_getdraftlpbj')
            ->select('*')
            ->where('userid', '=', session('iduser'))
            ->get();
=======
        $userid = session('iduser');
        try {
            $data = DB::table('s_draftlpbj as a')
                ->select(
                    'a.id',
                    'a.userid',
                    'a.articlecode',
                    'b.productname AS articlename',
                    'a.remark',
                    'a.qty',
                    'b.uom',
                    'a.sitecode',
                    'c.name1 AS sitename',
                    DB::raw("CASE 
                                 WHEN a.accassign = 'K' THEN 'K - COST CENTER' 
                                 WHEN a.accassign = 'A' THEN 'Y - ASSET' 
                                 END AS accassign"),
                    'a.gl',
                    'a.costcenter',
                    'a.order',
                    'a.asset',
                    'a.keterangan',
                    'a.gambar'
                )
                ->leftJoin('api_article as b', 'b.productcode', '=', 'a.articlecode')
                ->leftJoin('api_site as c', 'c.sitecode', '=', 'a.sitecode')
                ->where('a.isdeleted', 0)
                ->where('a.userid', $userid)
                ->get();
<<<<<<< Updated upstream
<<<<<<< Updated upstream
>>>>>>> Stashed changes
=======
>>>>>>> Stashed changes
=======
>>>>>>> Stashed changes

            return $data;
        } catch (\Exception $e) {
            Log::error('Error fetching draft: ' . $e->getMessage());
            return null; // or handle it as required
        }
    }


    public function getArticle()
    {
        try {
            $data = DB::table('api_article')->select('*')->get();
            return $data;
        } catch (\Exception $e) {
            Log::error('Error fetching articles: ' . $e->getMessage());
            return null; // or handle it as required
        }
    }

    public function getSite()
    {
        try {
            $data = DB::table('api_site')->select('*')->get();
            return $data;
        } catch (\Exception $e) {
            Log::error('Error fetching sites: ' . $e->getMessage());
            return null; // or handle it as required
        }
    }

    public function getGL()
    {
<<<<<<< Updated upstream
<<<<<<< Updated upstream
<<<<<<< Updated upstream
        $data = DB::table('api_gl')
            ->select('*')
            ->where('companycode',session('cc'))
            ->get();

        return $data;
=======
=======
>>>>>>> Stashed changes
=======
>>>>>>> Stashed changes
        try {
            $data = DB::table('api_gl')
                ->select('*')
                ->where('companycode', session('cc'))
                ->get();
            return $data;
        } catch (\Exception $e) {
            Log::error('Error fetching GL: ' . $e->getMessage());
            return null; // or handle it as required
        }
<<<<<<< Updated upstream
<<<<<<< Updated upstream
>>>>>>> Stashed changes
=======
>>>>>>> Stashed changes
=======
>>>>>>> Stashed changes
    }

    public function getCC()
    {
<<<<<<< Updated upstream
<<<<<<< Updated upstream
<<<<<<< Updated upstream
        $data = DB::table('api_costcenter')
            ->select('*')
            ->where('companycode',session('cc'))
            ->get();

        return $data;
=======
=======
>>>>>>> Stashed changes
=======
>>>>>>> Stashed changes
        try {
            $data = DB::table('api_costcenter')
                ->select('*')
                ->where('companycode', session('cc'))
                ->get();
            return $data;
        } catch (\Exception $e) {
            Log::error('Error fetching cost centers: ' . $e->getMessage());
            return null; // or handle it as required
        }
<<<<<<< Updated upstream
<<<<<<< Updated upstream
>>>>>>> Stashed changes
=======
>>>>>>> Stashed changes
=======
>>>>>>> Stashed changes
    }

    public function getOrder()
    {
<<<<<<< Updated upstream
<<<<<<< Updated upstream
<<<<<<< Updated upstream
        $data = DB::table('api_order')
            ->select('*')
            ->where('companycode',session('cc'))
            ->get();

        return $data;
=======
=======
>>>>>>> Stashed changes
=======
>>>>>>> Stashed changes
        try {
            $data = DB::table('api_order')
                ->select('*')
                ->where('companycode', session('cc'))
                ->get();
            return $data;
        } catch (\Exception $e) {
            Log::error('Error fetching orders: ' . $e->getMessage());
            return null; // or handle it as required
        }
<<<<<<< Updated upstream
<<<<<<< Updated upstream
>>>>>>> Stashed changes
=======
>>>>>>> Stashed changes
=======
>>>>>>> Stashed changes
    }

    public function getAsset()
    {
<<<<<<< Updated upstream
<<<<<<< Updated upstream
<<<<<<< Updated upstream
        $data = DB::table('api_asset')
            ->select('*')
            ->where('companycode',session('cc'))
            ->get();

        return $data;
=======
=======
>>>>>>> Stashed changes
=======
>>>>>>> Stashed changes
        try {
            $data = DB::table('api_asset')
                ->select('*')
                ->where('companycode', session('cc'))
                ->where('create_date', '>=', '2024-01-01')
                ->get();
            return $data;
        } catch (\Exception $e) {
            Log::error('Error fetching assets: ' . $e->getMessage());
            return null; // or handle it as required
        }
<<<<<<< Updated upstream
<<<<<<< Updated upstream
>>>>>>> Stashed changes
=======
>>>>>>> Stashed changes
=======
>>>>>>> Stashed changes
    }

    public function insertDraft($params)
    {
<<<<<<< Updated upstream
<<<<<<< Updated upstream
<<<<<<< Updated upstream
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
=======
=======
>>>>>>> Stashed changes
=======
>>>>>>> Stashed changes
        try {
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
                'created_by' => $params['userid'],
            ]);
            return $data;
        } catch (\Exception $e) {
            Log::error('Error inserting draft: ' . $e->getMessage());
            return false; // or handle it as required
        }
<<<<<<< Updated upstream
<<<<<<< Updated upstream
>>>>>>> Stashed changes
=======
>>>>>>> Stashed changes
=======
>>>>>>> Stashed changes
    }

    public function deleteDraft($id)
    {
        try {
            $data = DB::table('s_draftlpbj')
                ->where('id', $id)
                ->update([
                    'isdeleted' => 1,
                    'modified_by' => session('iduser')
                ]);
            return $data;
        } catch (\Exception $e) {
            Log::error('Error deleting draft: ' . $e->getMessage());
            return false; // or handle it as required
        }
    }

    public function deleteDtl($id)
    {
        try {
            $data = DB::table('m_lpbj_dtl')
                ->where('id', $id)
                ->update([
                    'isdeleted' => 1,
                    'modified_by' => session('iduser')
                ]);
            return $data;
        } catch (\Exception $e) {
            Log::error('Error deleting detail: ' . $e->getMessage());
            return false; // or handle it as required
        }
    }

    public function cekDraft($id)
    {
<<<<<<< Updated upstream
<<<<<<< Updated upstream
<<<<<<< Updated upstream
        $data = DB::table('vw_getdraftlpbj')
            ->select('*')
            ->where('id', '=', $id)
            ->get();
=======
=======
>>>>>>> Stashed changes
=======
>>>>>>> Stashed changes
        try {
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
<<<<<<< Updated upstream
<<<<<<< Updated upstream
>>>>>>> Stashed changes
=======
>>>>>>> Stashed changes
=======
>>>>>>> Stashed changes

            return $data;
        } catch (\Exception $e) {
            Log::error('Error checking draft: ' . $e->getMessage());
            return null; // or handle it as required
        }
    }

    public function insertHdr($params)
    {
        try {
            $userid = $params['userid'];
            $company = $params['companycode'];
            $desc = $params['description'];
            $note = $params['note'];
            $status = $params['status'];

            $data = DB::statement("CALL sp_addlpbjhdr($userid,'$company','$desc','$note','$status')");
            $maxId = DB::table("m_lpbj_hdr")->max('id');
            return $maxId;
        } catch (\Exception $e) {
            Log::error('Error inserting header: ' . $e->getMessage());
            return null; // or handle it as required
        }
    }

    public function editHdr($params)
    {
<<<<<<< Updated upstream
<<<<<<< Updated upstream
<<<<<<< Updated upstream
        // dd($params);
        $data = DB::table('m_lpbj_hdr')
            ->where('id', $params['hdrid'])
            ->update([
                'status' => $params['status'],
                'description' => $params['description'],
                'note' => $params['note'],
                'modified_by' => session('iduser')
            ]);

        return $data;
=======
=======
>>>>>>> Stashed changes
=======
>>>>>>> Stashed changes
        try {
            $doc = 'Draft';
            if ($params['status'] == '1') {
                $doc = 'Pengajuan_LPBJ_Revisi_by_' . session('name');
            }

            $data = DB::table('m_lpbj_hdr')
                ->where('id', $params['hdrid'])
                ->update([
                    'status' => $params['status'],
                    'description' => $params['description'],
                    'note' => $params['note'],
                    'workflow' => $doc,
                    'reason' => null,
                    'modified_by' => session('iduser')
                ]);

            return $data;
        } catch (\Exception $e) {
            Log::error('Error editing header: ' . $e->getMessage());
            return false; // or handle it as required
        }
<<<<<<< Updated upstream
<<<<<<< Updated upstream
>>>>>>> Stashed changes
=======
>>>>>>> Stashed changes
=======
>>>>>>> Stashed changes
    }

    public function getHistory()
    {
<<<<<<< Updated upstream
        $data = DB::table('vw_historylpbj')
            ->select('*')
            ->where('divname', session('divname'))
            ->get();
=======
        $divname = session('divname');
<<<<<<< Updated upstream
<<<<<<< Updated upstream
>>>>>>> Stashed changes
=======
>>>>>>> Stashed changes
=======
>>>>>>> Stashed changes

        try {
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
                    CASE WHEN d.id = 0 THEN 'Draft'
                        WHEN a.workflow IS NULL THEN d.name 
                        ELSE REPLACE ( a.workflow, '_', ' ' ) 
                    END workflow,
                    a.reason,
                    e.email AS emailpengaju,
                    c.nama AS namapengaju,
                    f.pono,
                    f.prno
                FROM m_lpbj_hdr a
                    LEFT JOIN m_lpbj_dtl b ON b.hdrid = a.id
                    LEFT JOIN m_pegawai c ON c.userid = a.userid
                    LEFT JOIN m_subseksi c1 ON c1.id = c.satkerid
                    LEFT JOIN m_department c2 ON c2.id = c1.departmentid
                    LEFT JOIN m_divisi c3 ON c3.id = c1.divisiid
                    LEFT JOIN m_status d ON d.id = a.status 
                    left join m_users e on e.id = c.userid
                    left join api_returnprpo f on f.lpbjid = a.id AND f.isdeleted = 0
                WHERE a.isdeleted = 0 
                    AND b.isdeleted = 0
                    AND c3.name = :divname
                ", ['divname' => $divname]);

            return $data;

        } catch (\Exception $e) {
            $data = $e->getMessage();
            return $data; // or handle it as required
        }
    }

    public function getHistoryHeader($id)
    {
<<<<<<< Updated upstream
<<<<<<< Updated upstream
<<<<<<< Updated upstream
        $data = DB::table('vw_historylpbj')
            ->select('*')
            ->where('hdrid', '=', $id)
            ->get();
=======
=======
>>>>>>> Stashed changes
=======
>>>>>>> Stashed changes
        try {
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
                    CASE WHEN a.status > 1 THEN i1.nama 
                    ELSE null 
                    END as approval1,
                    CASE WHEN a.status > 2 THEN j1.nama
                    ELSE null
                    END as approval2
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
<<<<<<< Updated upstream
<<<<<<< Updated upstream
>>>>>>> Stashed changes
=======
>>>>>>> Stashed changes
=======
>>>>>>> Stashed changes

            return $data;
        } catch (\Exception $e) {
            Log::error('Error fetching history header: ' . $e->getMessage());
            return null; // or handle it as required
        }
    }

    public function getApprove($status)
    {
<<<<<<< Updated upstream
        $data = DB::table('vw_historylpbj')
            ->select('*')
            ->where('depname', '=', session('depname'))
            ->where('statusid', $status)
            ->get();
=======
        $divname = session('divname');
        $a = session('idgroup');
        try {
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
                ELSE h.name = :divname
                END
                AND CASE WHEN :a1 = 1 THEN a.status < 3
                ELSE a.status = :status
                END ",
                [
                    'a' => $a,
                    'a1' => $a,
                    'divname' => $divname,
                    'status' => $status
                ]
            );
<<<<<<< Updated upstream
<<<<<<< Updated upstream
>>>>>>> Stashed changes
=======
>>>>>>> Stashed changes
=======
>>>>>>> Stashed changes

            return $data;
        } catch (\Exception $e) {
            Log::error('Error fetching approvals: ' . $e->getMessage());
            return null; // or handle it as required
        }
    }

    public function getHistoryDetail($id)
    {
<<<<<<< Updated upstream
<<<<<<< Updated upstream
<<<<<<< Updated upstream
        $data = DB::table('vw_historylpbjdtl')
            ->select('*')
            ->where('hdrid', '=', $id)
            ->get();
=======
=======
>>>>>>> Stashed changes
=======
>>>>>>> Stashed changes
        try {
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
<<<<<<< Updated upstream
<<<<<<< Updated upstream
>>>>>>> Stashed changes
=======
>>>>>>> Stashed changes
=======
>>>>>>> Stashed changes

            return $data;
        } catch (\Exception $e) {
            Log::error('Error fetching history details: ' . $e->getMessage());
            return null; // or handle it as required
        }
    }

    public function getHistoryDetailEdt($id)
    {
<<<<<<< Updated upstream
<<<<<<< Updated upstream
<<<<<<< Updated upstream
        $data = DB::table('vw_historylpbjdtl')
            ->select('*')
            ->where('dtlid', '=', $id)
            ->get();
=======
=======
>>>>>>> Stashed changes
=======
>>>>>>> Stashed changes
        try {
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
<<<<<<< Updated upstream
<<<<<<< Updated upstream
>>>>>>> Stashed changes
=======
>>>>>>> Stashed changes
=======
>>>>>>> Stashed changes

            return $data;
        } catch (\Exception $e) {
            Log::error('Error fetching history detail edit: ' . $e->getMessage());
            return null; // or handle it as required
        }
    }

    public function insertLpbj($id, $status)
    {
<<<<<<< Updated upstream
<<<<<<< Updated upstream
<<<<<<< Updated upstream
        // dd($status);
        $data = DB::table('m_lpbj_hdr')
            ->where('id', $id)
            ->update([
                'status' => ($status + 1),
                'workflow' => 'Approved_by_' . session('name'),
                'modified_by' => session('iduser')
            ]);
=======
=======
>>>>>>> Stashed changes
=======
>>>>>>> Stashed changes
        try {
            $insertApprove = DB::table('m_lacak_lpbj')
                ->insert([
                    'hdrlpbjid' => $id,
                    'statusid' => ($status + 1),
                    'approvalid' => session('iduser'),
                    'created_by' => session('iduser'),
                ]);
<<<<<<< Updated upstream
<<<<<<< Updated upstream
>>>>>>> Stashed changes
=======
>>>>>>> Stashed changes
=======
>>>>>>> Stashed changes

            if ($insertApprove) {
                $data = DB::table('m_lpbj_hdr')
                    ->where('id', $id)
                    ->update([
                        'status' => ($status + 1),
                        'workflow' => 'Approved_by_' . session('name'),
                        'modified_by' => session('iduser')
                    ]);
            }

            return $data;
        } catch (\Exception $e) {
            Log::error('Error inserting LPBJ: ' . $e->getMessage());
            return false; // or handle it as required
        }
    }

    public function updateDraftDetail($params)
    {
<<<<<<< Updated upstream
<<<<<<< Updated upstream
<<<<<<< Updated upstream
        // dd($status);
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
=======
=======
>>>>>>> Stashed changes
=======
>>>>>>> Stashed changes
        try {
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
<<<<<<< Updated upstream
<<<<<<< Updated upstream
>>>>>>> Stashed changes
=======
>>>>>>> Stashed changes
=======
>>>>>>> Stashed changes

            return $data;
        } catch (\Exception $e) {
            Log::error('Error updating draft detail: ' . $e->getMessage());
            return false; // or handle it as required
        }
    }

    public function insertDraftHistory($params)
    {
        try {
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
                'created_by' => $params['userid'],
            ]);

<<<<<<< Updated upstream
<<<<<<< Updated upstream
<<<<<<< Updated upstream
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
=======
=======
>>>>>>> Stashed changes
=======
>>>>>>> Stashed changes
            return $data;
        } catch (\Exception $e) {
            Log::error('Error inserting draft history: ' . $e->getMessage());
            return false; // or handle it as required
        }
<<<<<<< Updated upstream
<<<<<<< Updated upstream
>>>>>>> Stashed changes
=======
>>>>>>> Stashed changes
=======
>>>>>>> Stashed changes
    }

    public function rejectLpbj($id, $status, $reason)
    {
<<<<<<< Updated upstream
<<<<<<< Updated upstream
<<<<<<< Updated upstream
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
=======
        try {
            $data = DB::table('m_lpbj_hdr')
                ->where('id', $id)
                ->update([
                    'status' => $status,
                    'reason' => $reason,
                    'workflow' => 'Reject_by_' . session('name'),
                    'modified_by' => session('iduser')
                ]);

=======
        try {
            $data = DB::table('m_lpbj_hdr')
                ->where('id', $id)
                ->update([
                    'status' => $status,
                    'reason' => $reason,
                    'workflow' => 'Reject_by_' . session('name'),
                    'modified_by' => session('iduser')
                ]);

>>>>>>> Stashed changes
=======
        try {
            $data = DB::table('m_lpbj_hdr')
                ->where('id', $id)
                ->update([
                    'status' => $status,
                    'reason' => $reason,
                    'workflow' => 'Reject_by_' . session('name'),
                    'modified_by' => session('iduser')
                ]);

>>>>>>> Stashed changes
            if ($status == 0) {
                $nolpbj = DB::table('m_lpbj_hdr')->select('nolpbj')->where('id', $id)->get();

                $data = DB::table('m_rejection')->insert([
                    'nolpbj' => $nolpbj[0]->nolpbj,
                    'statusname' => 'Reject_by_' . session('name'),
                    'reason' => $reason,
                    'created_by' => session('iduser'),
                ]);
            }

            return $data;
        } catch (\Exception $e) {
            Log::error('Error rejecting LPBJ: ' . $e->getMessage());
            return false; // or handle it as required
        }
<<<<<<< Updated upstream
<<<<<<< Updated upstream
>>>>>>> Stashed changes
=======
>>>>>>> Stashed changes
=======
>>>>>>> Stashed changes
    }

    public function reportPMS($userId)
    {

        try {
            // Use query builder for better readability and maintainability
            $data = DB::table('m_lpbj_hdr as a')
                ->select([
                    'a.nolpbj',
                    DB::raw('CAST(a.created_at as date) AS tgllpbj'),
                    'a.description',
                    DB::raw('concat(d.productcode,\' - \', b.remark) as article'),
                    DB::raw('CASE WHEN a.status = 0 THEN NULL ELSE a.created_at END AS pengajuanlpbj'),
                    'c.created_at as approval1lpbj',
                    'c1.created_at as approval2lpbj',
                    'g.noqe',
                    DB::raw('CAST(g.created_at as date) AS tglqe'),
                    'e.remark as descqe',
                    DB::raw('concat(h.supplierCode, \' - \', h.name) as vendor'),
                    DB::raw('CASE WHEN g.noqe IS NULL THEN NULL ELSE b.qty END AS qty'),
                    'e.satuan',
                    'e.tax',
                    'e.gtotal',
                    'g.created_at as pengajuanqe',
                    'i.created_at as approval1qe',
                    'i1.created_at as approval2qe',
                    'i2.created_at as approval3qe',
                    'i3.created_at as approval4qe',
                    'i4.created_at as approval5qe',
                    'i5.created_at as approval6qe',
                    'i6.created_at as approval7qe',
                    'i7.created_at as approval8qe',
                    'i8.created_at as approval9qe',
                    'i9.created_at as approval10qe',
                    'j.pono',
                    'j.prno',
                    DB::raw('CAST(j.created_at as date) AS tglpo'),
                    DB::raw("CASE WHEN a.workflow IS NULL THEN k.name ELSE REPLACE ( a.workflow, '_', ' ' ) END workflowlpbj"),
                    DB::raw("CASE WHEN g.workflow IS NULL THEN k1.name ELSE REPLACE ( a.workflow, '_', ' ' ) END workflowqe")
                ])
                ->leftJoin('m_lpbj_dtl as b', 'b.hdrid', '=', 'a.id')
                ->leftJoin('m_lacak_lpbj as c', function ($join) {
                    $join->on('c.hdrlpbjid', '=', 'a.id')
                        ->where('c.statusid', '=', 2);
                })
                ->leftJoin('m_lacak_lpbj as c1', function ($join) {
                    $join->on('c1.hdrlpbjid', '=', 'a.id')
                        ->where('c1.statusid', '=', 3);
                })
                ->leftJoin('api_article as d', 'd.productcode', '=', 'b.articlecode')
                ->leftJoin('s_draftqe as e', 'e.dtlid', '=', 'b.id')
                ->leftJoin('m_qe_dtl as f', 'f.draftid', '=', 'e.id')
                ->leftJoin('m_qe_hdr as g', 'g.id', '=', 'f.hdrid')
                ->leftJoin('api_vendor as h', 'h.supplierCode', '=', 'e.vendorcode')
                ->leftJoin('m_lacak as i', function ($join) {
                    $join->on('i.hdrqeid', '=', 'g.id')
                        ->where('i.statusid', '=', 2);
                })
                ->leftJoin('m_lacak as i1', function ($join) {
                    $join->on('i1.hdrqeid', '=', 'g.id')
                        ->where('i1.statusid', '=', 3);
                })
                ->leftJoin('m_lacak as i2', function ($join) {
                    $join->on('i2.hdrqeid', '=', 'g.id')
                        ->where('i2.statusid', '=', 4);
                })
                ->leftJoin('m_lacak as i3', function ($join) {
                    $join->on('i3.hdrqeid', '=', 'g.id')
                        ->where('i3.statusid', '=', 5);
                })
                ->leftJoin('m_lacak as i4', function ($join) {
                    $join->on('i4.hdrqeid', '=', 'g.id')
                        ->where('i4.statusid', '=', 6);
                })
                ->leftJoin('m_lacak as i5', function ($join) {
                    $join->on('i5.hdrqeid', '=', 'g.id')
                        ->where('i5.statusid', '=', 7);
                })
                ->leftJoin('m_lacak as i6', function ($join) {
                    $join->on('i6.hdrqeid', '=', 'g.id')
                        ->where('i6.statusid', '=', 8);
                })
                ->leftJoin('m_lacak as i7', function ($join) {
                    $join->on('i7.hdrqeid', '=', 'g.id')
                        ->where('i7.statusid', '=', 9);
                })
                ->leftJoin('m_lacak as i8', function ($join) {
                    $join->on('i8.hdrqeid', '=', 'g.id')
                        ->where('i8.statusid', '=', 10);
                })
                ->leftJoin('m_lacak as i9', function ($join) {
                    $join->on('i9.hdrqeid', '=', 'g.id')
                        ->where('i9.statusid', '=', 11);
                })
                ->leftJoin('api_returnprpo as j', 'j.qeid', '=', 'g.id')
                ->leftJoin('m_status as k', 'k.id', '=', 'a.status')
                ->leftJoin('m_status as k1', 'k1.id', '=', 'g.status')
                // ->where('a.status', '>', 0)
                ->where('a.isdeleted', 0)
                ->where('b.created_by', $userId)
                ->orderBy('a.nolpbj') // Ordering by nolpbj
                ->distinct()
                ->get();

            return $data;

        } catch (\Exception $e) {
            // Logs additional details for easier debugging
            Log::error('Error in reportPMS: ', [
                'userId' => $userId,
                'error' => $e->getMessage(),
                'trace' => $e->getTraceAsString(),
            ]);

            return null; // Handle the error as needed
        }
    }

}
