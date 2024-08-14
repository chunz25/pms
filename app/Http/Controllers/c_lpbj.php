<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;
use App\Models\m_lpbj;
use DateTime;
use Illuminate\Support\Facades\Date;
use Illuminate\Support\Facades\Storage;
use Illuminate\Support\Facades\Mail;
use App\Mail\mailPMS;
use Barryvdh\DomPDF\Facade\Pdf;

class c_lpbj extends Controller
{

    protected $db;
    public function __construct()
    {
        $this->db = new m_lpbj();
    }

    public function tempSess($params)
    {
        $data = explode(',|,', $params);

        // dd($data);
        if (session()->exists('cc')) {
            session()->forget(['cc', 'jdl', 'note', 'doc']);
        }

        session([
            'cc' => $data[0],
            'jdl' => $data[1],
            'note' => $data[2],
            'doc' => $data[3]
        ]);

        // dd(session()->all());

        return redirect('tambaharticle');
    }

    public function index()
    {
        $role = [1, 3, 4, 8, 12, 13, 14];
        $roleAdmin = [1, 4, 12];

        if (!session('iduser')) {
            return redirect('login')->with('pesan', 'Session anda telah habis, silahkan login kembali.');
        }

        if (!in_array(session('idgroup'), $role)) {
            return redirect('portal');
        }

        $userid = session('iduser');
        $dataPegawai = $this->db->getPegawai($userid)[0];
        $dataDraft = $this->db->getDraft();

        $data = [
            'dataPegawai' => $dataPegawai,
            'dataDraft' => $dataDraft,
            'title' => 'LPBJ'
        ];

        if (in_array(session('idgroup'), $roleAdmin)) {
            return view('lpbjPage/pengajuan', $data);
        } else {
            return redirect('historylpbj');
        }
    }

    public function tambahArticle()
    {
        $role = [1, 3, 4, 8, 12, 13, 14];

        // dd(session()->all());

        if (!session('iduser')) {
            return redirect('login')->with('pesan', 'Session anda telah habis, silahkan login kembali.');
        }

        if (!in_array(session('idgroup'), $role)) {
            return redirect('portal');
        }

        $dataDraft = '';
        if (session('draftid')) {
            $dataDraft = $this->db->cekDraft(session('draftid'))[0];
        }


        $dataArticle = $this->db->getArticle()->toArray();
        $dataSite = $this->db->getSite()->toArray();
        $dataGL = $this->db->getGL()->toArray();
        $dataCC = $this->db->getCC()->toArray();
        $dataOrder = $this->db->getOrder()->toArray();
        $dataAsset = $this->db->getAsset()->toArray();


        $data = [
            'getArticle' => $dataArticle,
            'getSite' => $dataSite,
            'getGL' => $dataGL,
            'getCC' => $dataCC,
            'getOrder' => $dataOrder,
            'getAsset' => $dataAsset,
            'getDraft' => $dataDraft,
            'title' => 'LPBJ',
        ];

        return view('lpbjPage/tambahArticle', $data);
    }

    public function ajukan(Request $params)
    {
        $userid = session('iduser');

        $dokumen = 0;
        if ($params->pilihan == 'doc') {
            $dokumen = 1;
        }

        $data = [
            'userid' => $userid,
            'companycode' => $params->companyCode,
            'description' => htmlspecialchars($params->descLPBJ),
            'note' => htmlspecialchars($params->noteLPBJ),
            'status' => $dokumen
        ];

        $insertHdr = $this->db->insertHdr($data);

        if ($insertHdr) {
            $databody = $this->db->getHistoryHeader($insertHdr);
            $emailapprove = session('emailapprove');

            $details = [
                'subject' => 'Submit LPBJ',
                'dataBody' => $databody,
                'aksi' => 'SubmitLPBJ',
            ];

            if ($dokumen == 1) {
                Mail::to($emailapprove)->send(new mailPMS($details));
            }

            session()->forget(['cc', 'jdl', 'note', 'doc']);
            return redirect('historylpbj');
        } else {
            return redirect('pengajuanlpbj')->with('pesan', 'Gagal mengajukan LPBJ, silahkan ulangi kembali');
        }
    }

    public function ajukanEdit(Request $params)
    {
        $hdrid = $params->hdrid;
        $dokumen = 1;

        if ($params->pilihan == 'drf') {
            $dokumen = 0;
        }

        $data = [
            'hdrid' => $hdrid,
            'description' => $params->descLPBJ,
            'note' => $params->noteLPBJ,
            'status' => $dokumen
        ];

        $editHdr = $this->db->editHdr($data);

        if ($editHdr) {
            $databody = $this->db->getHistoryHeader($hdrid);
            $emailapprove = session('emailapprove');

            $details = [
                'subject' => 'Submit LPBJ',
                'dataBody' => $databody,
                'aksi' => 'SubmitLPBJ',
            ];

            if ($dokumen == 1) {
                Mail::to($emailapprove)->send(new mailPMS($details));
            }

            session()->forget(['cc', 'jdl', 'note', 'doc']);
            return redirect('historylpbj');
        } else {
            return redirect('pengajuanlpbj')->with('pesan', 'Gagal mengajukan LPBJ, silahkan ulangi kembali');
        }
    }

    public function createDraft(Request $params)
    {
        $gl = $params->input('glLPBJ');
        $cc = $params->input('costLPBJ');
        $io = $params->input('orderLPBJ');
        $as = $params->input('assetLPBJ');

        $name = 'noimage.jpg';
        if ($params->hasFile('imgLPBJ')) {
            $filename = $params->file('imgLPBJ')->getClientOriginalName();
            $ext = $params->file('imgLPBJ')->getClientOriginalExtension();
            $name = 'LPBJ_' . session('iduser') . '_' . $params->input('artLPBJ');
            $name = preg_replace('/[^A-Za-z0-9\-]/', '_', $name);
            $name = preg_replace('/\s+/', '_', $name);
            $name = $name . '.' . $ext;
            $filename = $params->file('imgLPBJ')->storeAs('lpbj', $filename);
            Storage::move($filename, 'lpbj/' . $name);
        }

        if ($params->input('accLPBJ') == 'K') {
            $as = null;
        } elseif ($params->input('accLPBJ') == 'A') {
            $gl = null;
            $cc = null;
            $io = null;
        }

        $data = [
            'userid' => session('iduser'),
            'article' => $params->input('artLPBJ'),
            'remark' => $params->input('rmkLPBJ'),
            'qty' => $params->input('qtyLPBJ'),
            'site' => $params->input('stcodeLPBJ'),
            'assign' => $params->input('accLPBJ'),
            'gl' => $gl,
            'cost' => $cc,
            'order' => $io,
            'asset' => $as,
            'ket' => $params->input('ketLPBJ'),
            'pic' => $name
        ];

        $insertData = $this->db->insertDraft($data);

        if ($insertData) {
            return redirect('pengajuanlpbj')->with('pesan', 'Data berhasil ditambahkan');
        } else {
            return redirect('tambaharticle')->with('pesan', 'Gagal menambahkan data.');
        }
    }

    public function deleteDraft($id)
    {
        $deleteData = $this->db->deleteDraft($id);

        if ($deleteData) {
            return redirect('pengajuanlpbj')->with('pesan', 'Data berhasil dihapus');
        } else {
            return redirect('pengajuanlpbj')->with('pesan', 'Gagal menghapus data.');
        }
    }

    public function lihatDraft($id)
    {
        return Redirect('tambaharticle')->with('draftid', $id);
    }

    public function history()
    {
        $role = [1, 3, 4, 8, 12, 13, 14];

        if (!session('iduser')) {
            return redirect('login')->with('pesan', 'Session anda telah habis, silahkan login kembali.');
        }

        if (!in_array(session('idgroup'), $role)) {
            return redirect('portal');
        }

        $dataHistory = $this->db->getHistory();
        $data = [
            'dataHistory' => $dataHistory,
            'title' => 'LPBJ'
        ];

        return view('lpbjPage/history', $data);
    }

    public function lihatDetail($id)
    {
        $role = [1, 3, 4, 8, 12, 13, 14];

        if (!session('iduser')) {
            return redirect('login')->with('pesan', 'Session anda telah habis, silahkan login kembali.');
        }

        if (!in_array(session('idgroup'), $role)) {
            return redirect('portal');
        }

        $dataDetail = $this->db->getHistoryDetail($id);
        $dataHeader = $this->db->getHistoryHeader($id)[0];

        $data = [
            'dataDetail' => $dataDetail,
            'dataHeader' => $dataHeader,
            'title' => 'LPBJ'
        ];

        return view('lpbjPage/historyDetail', $data);
    }

    public function editLpbj($id)
    {
        $role = [1, 3, 4, 8, 12, 13, 14];

        if (!session('iduser')) {
            return redirect('login')->with('pesan', 'Session anda telah habis, silahkan login kembali.');
        }

        if (!in_array(session('idgroup'), $role)) {
            return redirect('portal');
        }

        session()->forget(['jdl', 'note', 'doc']);

        $dataDetail = $this->db->getHistoryDetail($id);
        $dataHeader = $this->db->getHistoryHeader($id)[0];

        session([
            'jdl' => $dataHeader->description,
            'note' => $dataHeader->note,
            'doc' => 'drf',
        ]);

        $data = [
            'title' => 'LPBJ',
            'hdrid' => $id,
            'header' => $dataHeader,
            'detail' => $dataDetail,
        ];

        return view('lpbjPage/editLpbj', $data);
    }

    public function approve()
    {
        $role = [1, 3, 4, 8, 12, 13, 14];

        if (!session('iduser')) {
            return redirect('login')->with('pesan', 'Session anda telah habis, silahkan login kembali.');
        }

        if (!in_array(session('idgroup'), $role)) {
            return redirect('portal');
        }

        $status = 1;
        $arr = [8, 14];
        if (in_array(session('idgroup'), $arr)) {
            $status = 2;
        }

        $dataApprove = $this->db->getApprove($status);
        $data = [
            'dataApprove' => $dataApprove,
            'title' => 'LPBJ'
        ];

        return view('lpbjPage/approve', $data);
    }

    public function lihatApprove($id)
    {
        return Redirect('approvedetaillpbj')->with('detailid', $id);
    }

    public function approveDetail()
    {
        $role = [1, 3, 4, 8, 12, 13, 14];

        if (!session('iduser')) {
            return redirect('login')->with('pesan', 'Session anda telah habis, silahkan login kembali.');
        }

        if (!in_array(session('idgroup'), $role)) {
            return redirect('portal');
        }

        if (!session('detailid')) {
            return redirect('approvelpbj');
        }

        $dataDetail = $this->db->getHistoryDetail(session('detailid'));
        $dataHeader = $this->db->getHistoryHeader(session('detailid'))[0];

        $data = [
            'dataDetail' => $dataDetail,
            'dataHeader' => $dataHeader,
            'title' => 'LPBJ'
        ];

        return view('lpbjPage/approveDetail', $data);
    }

    public function setuju(Request $params)
    {
        $hdrid = $params->input('hdrid');
        $status = $params->input('status');

        $insert = $this->db->insertLpbj($hdrid, $status);

        if ($insert) {
            $databody = $this->db->getHistoryHeader($hdrid);
            $emailapprove = session('emailapprove');
            $emailpengaju = $databody[0]->emailpengaju;

            $details = [
                'subject' => 'Approve LPBJ',
                'dataBody' => $databody,
                'aksi' => 'ApproveLPBJ',
            ];

            Mail::to($emailapprove)
                ->to($emailpengaju)
                ->send(new mailPMS($details));

            return redirect('approvelpbj')->with('pesan', 'Sukses Approve LPBJ');
        } else {
            return redirect('approvelpbj')->with('pesan', 'Gagal Approve LPBJ');
        }
    }

    public function reject(Request $params)
    {
        $hdrid = $params->hdrid;
        $reason = $params->reason;
        $status = $params->status;

        $reject = $this->db->rejectLpbj($hdrid, $status, $reason);

        if ($reject) {
            $databody = $this->db->getHistoryHeader($hdrid);
            $emailapprove = session('emailapprove');
            $emailpengaju = $databody[0]->emailpengaju;

            $details = [
                'subject' => 'Reject LPBJ',
                'dataBody' => $databody,
                'aksi' => 'RejectLPBJ',
            ];

            Mail::to($emailapprove)
                ->to($emailpengaju)
                ->send(new mailPMS($details));

            return redirect('approvelpbj')->with('pesan', 'Sukses Reject LPBJ');
        } else {
            return redirect('approvelpbj')->with('pesan', 'Gagal Reject LPBJ');
        }
    }

    public function tempEdit($params)
    {
        $data = explode('|', $params);

        session()->forget(['jdl', 'note', 'doc', 'cc']);

        session([
            'jdl' => $data[0],
            'note' => $data[1],
            'doc' => $data[2],
            'cc' => $data[4]
        ]);

        return redirect("lpbjedt/$data[3]");
    }

    public function tempEditAdd($params)
    {
        $data = explode('|', $params);

        session()->forget(['jdl', 'note', 'doc', 'cc']);

        session([
            'jdl' => $data[0],
            'note' => $data[1],
            'doc' => $data[2],
            'cc' => $data[4]
        ]);

        return redirect("lpbjedtadd/$data[3]");
    }

    public function tempDel($params)
    {
        $data = explode('|', $params);

        session()->forget(['jdl', 'note', 'doc', 'cc']);

        session([
            'jdl' => $data[0],
            'note' => $data[1],
            'doc' => $data[2],
            'cc' => $data[4]
        ]);

        return redirect("lpbjedtdel/$data[3]");
    }

    public function lpbjEdt($id)
    {
        $role = [1, 3, 4, 8, 12, 13, 14];

        if (!session('iduser')) {
            return redirect('login')->with('pesan', 'Session anda telah habis, silahkan login kembali.');
        }

        if (!in_array(session('idgroup'), $role)) {
            return redirect('portal');
        }

        $dataDraft = $this->db->getHistoryDetailEdt($id)[0];
        $dataArticle = $this->db->getArticle()->toArray();
        $dataSite = $this->db->getSite()->toArray();
        $dataGL = $this->db->getGL()->toArray();
        $dataCC = $this->db->getCC()->toArray();
        $dataOrder = $this->db->getOrder()->toArray();
        $dataAsset = $this->db->getAsset()->toArray();

        $data = [
            'getArticle' => $dataArticle,
            'getSite' => $dataSite,
            'getGL' => $dataGL,
            'getCC' => $dataCC,
            'getOrder' => $dataOrder,
            'getAsset' => $dataAsset,
            'getDraft' => $dataDraft,
            'title' => 'LPBJ',
        ];

        return view('lpbjPage/editDetailLpbj', $data);
    }

    public function lpbjEdtAdd($id)
    {
        $role = [1, 3, 4, 8, 12, 13, 14];

        if (!session('iduser')) {
            return redirect('login')->with('pesan', 'Session anda telah habis, silahkan login kembali.');
        }

        if (!in_array(session('idgroup'), $role)) {
            return redirect('portal');
        }

        $dataDraft = $this->db->getHistoryDetail($id)[0];
        $dataArticle = $this->db->getArticle()->toArray();
        $dataSite = $this->db->getSite()->toArray();
        $dataGL = $this->db->getGL()->toArray();
        $dataCC = $this->db->getCC()->toArray();
        $dataOrder = $this->db->getOrder()->toArray();
        $dataAsset = $this->db->getAsset()->toArray();

        $data = [
            'getArticle' => $dataArticle,
            'getSite' => $dataSite,
            'getGL' => $dataGL,
            'getCC' => $dataCC,
            'getOrder' => $dataOrder,
            'getAsset' => $dataAsset,
            'getDraft' => $dataDraft,
            'title' => 'LPBJ',
        ];

        return view('lpbjPage/tambahArticleDraft', $data);
    }

    public function lpbjEdtSave(Request $params)
    {
        $dtlid = $params->dtlid;
        $dataDetail = $this->db->getHistoryDetailEdt($dtlid)[0];

        $name = 'noimage.jpg';
        if ($params->hasFile('imgLPBJ')) {
            $filename = $params->file('imgLPBJ')->getClientOriginalName();
            $ext = $params->file('imgLPBJ')->getClientOriginalExtension();
            $name = 'LPBJ_' . session('iduser') . '_' . $params->artLPBJ;
            $name = preg_replace('/[^A-Za-z0-9\-]/', '_', $name);
            $name = preg_replace('/\s+/', '_', $name);
            $name = $name . '.' . $ext;
            $filename = $params->file('imgLPBJ')->storeAs('lpbj', $filename);
            Storage::move($filename, 'lpbj/' . $name);
        }

        $data = [
            'dtlid' => $dtlid,
            'userid' => session('iduser'),
            'articlecode' => $params->artLPBJ,
            'remark' => $params->rmkLPBJ,
            'qty' => $params->qtyLPBJ,
            'sitecode' => $params->stcodeLPBJ,
            'accassign' => $params->accLPBJ,
            'gl' => $params->glLPBJ,
            'costcenter' => $params->costLPBJ,
            'order' => $params->orderLPBJ,
            'asset' => $params->assetLPBJ,
            'keterangan' => $params->ketLPBJ,
            'gambar' => $name,
        ];

        $updateData = $this->db->updateDraftDetail($data);

        if ($updateData) {
            return redirect("editlpbj/$dataDetail->hdrid");
        } else {
            return redirect('pengajuanlpbj')->with('pesan', 'Gagal mengajukan LPBJ, silahkan ulangi kembali');
        }
    }

    public function lpbjEdtAddArt(Request $params)
    {
        $gl = $params->input('glLPBJ');
        $cc = $params->input('costLPBJ');
        $io = $params->input('orderLPBJ');
        $as = $params->input('assetLPBJ');

        $name = 'noimage.jpg';
        if ($params->hasFile('imgLPBJ')) {
            $filename = $params->file('imgLPBJ')->getClientOriginalName();
            $ext = $params->file('imgLPBJ')->getClientOriginalExtension();
            $name = 'LPBJ_' . session('iduser') . '_' . $params->input('artLPBJ');
            $name = preg_replace('/[^A-Za-z0-9\-]/', '_', $name);
            $name = preg_replace('/\s+/', '_', $name);
            $name = $name . '.' . $ext;
            $filename = $params->file('imgLPBJ')->storeAs('lpbj', $filename);
            Storage::move($filename, 'lpbj/' . $name);
        }

        if ($params->input('accLPBJ') == 'K') {
            $as = null;
        } elseif ($params->input('accLPBJ') == 'A') {
            $gl = null;
            $cc = null;
            $io = null;
        }

        $data = [
            'hdrid' => $params->hdrid,
            'userid' => session('iduser'),
            'article' => $params->input('artLPBJ'),
            'remark' => $params->input('rmkLPBJ'),
            'qty' => $params->input('qtyLPBJ'),
            'site' => $params->input('stcodeLPBJ'),
            'assign' => $params->input('accLPBJ'),
            'gl' => $gl,
            'cost' => $cc,
            'order' => $io,
            'asset' => $as,
            'ket' => $params->input('ketLPBJ'),
            'pic' => $name
        ];

        $insertData = $this->db->insertDraftHistory($data);

        if ($insertData) {
            return redirect("editlpbj/$params->hdrid");
        } else {
            return redirect('tambaharticle')->with('pesan', 'Gagal menambahkan data.');
        }
    }

    public function lpbjEdtDel($id)
    {
        $dataDraft = $this->db->getHistoryDetailEdt($id)[0];
        $deleteData = $this->db->deleteDtl($id);

        if ($deleteData) {
            return redirect("editlpbj/$dataDraft->hdrid")->with('pesan', 'Data berhasil dihapus');
        } else {
            return redirect('pengajuanlpbj')->with('pesan', 'Gagal menghapus data.');
        }
    }

    public function lihatDoc($id)
    {
        if (!session('iduser')) {
            return redirect('login')->with('pesan', 'Session anda telah habis, silahkan login kembali.');
        }

        $dataHeader = $this->db->getHistoryHeader($id)[0];
        $dataDetail = $this->db->getHistoryDetail($id);

        $data = [
            'title' => 'Quotation',
            'dataHeader' => $dataHeader,
            'dataDetail' => $dataDetail,
        ];

        return view('lpbjPage.lihatDoc', $data);
    }

    public function cetak($id)
    {
        if (!session('iduser')) {
            return redirect('login')->with('pesan', 'Session anda telah habis, silahkan login kembali.');
        }

        $dataHeader = $this->db->getHistoryHeader($id)[0];
        $dataDetail = $this->db->getHistoryDetail($id);

        $data = [
            'title' => 'Quotation',
            'dataHeader' => $dataHeader,
            'dataDetail' => $dataDetail,
        ];

        $pdf = PDF::loadView('lpbjPage.lihatDoc', $data)->setPaper('a3', 'landscape');
        return $pdf->stream('PrintLpbj.pdf');
    }
}
