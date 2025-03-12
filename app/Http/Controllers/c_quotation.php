<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;
use App\Models\m_quotation;
use Illuminate\Support\Facades\Storage;
use App\Http\Controllers\Response;

class c_quotation extends Controller
{
    protected $db;
    public function __construct()
    {
        $this->db = new m_quotation();
    }

    public function index()
    {
        if (!session('iduser')) {
            return redirect('login')->with('pesan', 'Session anda telah habis, silahkan login kembali.');
        }

        $dataQe = $this->db->getListQe()->toArray();
        $data = [
            'title' => 'Quotation',
            'dataQe' => $dataQe
        ];

        return view('quotation.pengajuan', $data);
    }

    public function history()
    {
        if (!session('iduser')) {
            return redirect('login')->with('pesan', 'Session anda telah habis, silahkan login kembali.');
        }

        $dataHistory = $this->db->getListHistory()->toArray();
        $data = [
            'title' => 'Quotation',
            'dataHistory' => $dataHistory
        ];

        return view('quotation.history', $data);
    }

    public function lihatDetail($id)
    {
        return Redirect('historydetailqe')->with('detailid', $id);
    }

    public function historyDetail($id)
    {
        if (!session('iduser')) {
            return redirect('login')->with('pesan', 'Session anda telah habis, silahkan login kembali.');
        }

        // if (!session('detailid')) {
        //     return redirect('historyqe');
        // }

        $dataDetail = $this->db->getHistoryDetail($id)->toArray();
        $dataHeader = $this->db->getHistoryHeader($id)->toArray()[0];
        $dataVendorHdr = $this->db->getVendorHeader($id)->toArray();
        // $dataVendorDtl = $this->db->getVendorDetail($dataVendorHdr->vendorcode)->toArray();

        foreach ($dataVendorHdr as $x) {
            $vendor = $x->vendorcode;
            $dataVendorDtl[] = $this->db->getVendorDetail($vendor)->toArray();
        }

        // dd($dataVendorDtl);
        $data = [
            'title' => 'Quotation',
            'dataDetail' => $dataDetail,
            'dataHeader' => $dataHeader,
            'dataVendorHdr' => $dataVendorHdr,
            'dataVendorDtl' => $dataVendorDtl
        ];

        // dd($data);

        return view('quotation/historyDetail', $data);
    }

    public function detailHistoryQe($id)
    {
        return view('quotation/historyDetail');
    }

    public function lihatQe($id)
    {
        return redirect('tambahqe')->with('detailid', $id);
    }

    public function tambahQe()
    {
        if (!session('iduser')) {
            return redirect('login')->with('pesan', 'Session anda telah habis, silahkan login kembali.');
        }

        if (!session('detailid')) {
            return redirect('pengajuanqe');
        }

        $dataLpbj = $this->db->getLpbj(session('detailid'))->toArray();

        $data = [
            'title' => 'Quotation',
            'getLpbj' => $dataLpbj
        ];


        return view('quotation.tambahQe', $data);
    }

    public function draftQe(Request $params)
    {
        $id = $params->check;
        $hdrid = $params->nolpbj;

        $dataLpbj = $this->db->getLpbj($hdrid)->toArray()[0];
        $dataVendor = $this->db->getVDraft($id[0])->toArray();
        $dataDraft = null;

        foreach ($id as $a) {
            $dataDtl[] = $this->db->getLpbjDtl($a)->toArray()[0];
            $cekData = $this->db->getDraft($a)->toArray();

            if ($cekData) {
                for ($i = 0; $i < count($cekData); $i++) {
                    $dataDraft[] = $this->db->getDraft($a)->toArray()[$i];
                }
            }
        }

        $data = [
            'title' => 'Quotation',
            'getLpbj' => $dataLpbj,
            'dataDtl' => $dataDtl,
            'dataDraft' => $dataDraft,
            'dataVendor' => $dataVendor,
            'iddtl' => $id
        ];

        // dd($data);

        return view('quotation.draftQe', $data);
    }

    public function tambahVendor(Request $params)
    {
        $id = $params->dtl;
        $dataVendor = $this->db->getVendor()->toArray();
        $dataTax = $this->db->getTax()->toArray();

        foreach ($id as $a) {
            $dataDtl[] = $this->db->getLpbjDtl($a)->toArray()[0];
        }

        $data = [
            'title' => 'Quotation',
            'getVendor' => $dataVendor,
            'getTax' => $dataTax,
            'getDtl' => $dataDtl
        ];

        return view('quotation.tambahVendor', $data);
    }

    public function insertDraft(Request $params)
    {
        // dd($params);
        $id = count($params->dtlid);
        $pilih = 0;

        if (isset($params->pilih)) {
            $pilih = 1;
        }

        for ($i = 0; $i < $id; $i++) {
            $dtlid = $params->dtlid[$i];
            $vendorcode = $params->vendorcode;
            $hdrid = $params->nolpbj;

            $filename = '';
            if ($params->hasFile('attach')) {
                $filename = $params->file('attach')->getClientOriginalName();
                $ext = $params->file('attach')->getClientOriginalExtension();
                $uploadpath = $hdrid . '_' . $vendorcode . '.' . $ext;
                $filename = $params->file('attach')->storeAs('quotation', $filename);
                Storage::move($filename, 'quotation/' . $uploadpath);
            }

            $data = [
                'dtlid' => $dtlid,
                'vendorcode' => $vendorcode,
                'pilih' => $pilih,
                'satuan' => $params->satuan[$i],
                'remarkqa' => $params->remarkqa[$i],
                'franco' => $params->franco,
                'pkp' => $params->pkp,
                'term' => $params->term,
                'top' => $params->top,
                'person' => $params->person,
                'telp' => $params->telp,
                'remark' => $params->remark,
                'attach' => $uploadpath
            ];

            $insertData = $this->db->insertDraft($data);
        }

        if ($insertData) {
            return $this->draftQe($params);
        } else {
            return redirect('tambahvendor')->with('pesan', 'Gagal menambahkan data.');
        }
    }

    public function ajukanQe(Request $params)
    {
        $dtlid = $params->dtl;
        $this->db->ajukanQe($dtlid[0]);

<<<<<<< Updated upstream
        foreach ($dtlid as $i) {
            $this->db->ajukanQeDetail($i);
            $this->db->updateQe($i);
        }

        return redirect('pengajuanqe');
=======
        // dd($params);
        // dd($params->hasFile('attachHdr'));
        // dd(session()->all());
        if ($stat === 0) {
            // dd('kesini');
            $d = $this->db->updateQeRev($dtlid[0]);
            // dd($d[0]->hdrid);
            $databody = $this->db->getHistoryHeader($d[0]->hdrid);
            $emailapprove = session('emailapprove');
            $emailpengaju = $databody[0]->emailpengaju;

            $details = [
                'subject' => 'Pengajuan Baru QE Revisi',
                'dataBody' => $databody,
                'aksi' => 'SubmitQE',
            ];

            // dd($details);

            Mail::to($emailapprove)
                ->to($emailpengaju)
                ->send(new mailPMS($details));

            // session()->forget(['sts']);
            return redirect('historyqe');
        } else {
            // dd('kesono');
            $ajukan = $this->db->ajukanQe($dtlid[0]);

            $filename = '';
            if ($params->hasFile('attach')) {
                $filename = $params->file('attach')->getClientOriginalName();
                $ext = $params->file('attach')->getClientOriginalExtension();
                $uploadpath = $ajukan . '_HeaderQe' . '.' . $ext;
                $filename = $params->file('attach')->storeAs('quotation', $filename);
                Storage::move($filename, 'quotation/header/' . $uploadpath);
            }
            // dd($filename);
            $this->db->attachHdr($ajukan,$uploadpath);


            foreach ($dtlid as $i) {
                $this->db->ajukanQeDetail($i);
                $this->db->updateQe($i);
            }

            $databody = $this->db->getHistoryHeader($ajukan);
            $emailapprove = session('emailapprove');
            $emailpengaju = $databody[0]->emailpengaju;

            $details = [
                'subject' => 'Pengajuan Baru QE',
                'dataBody' => $databody,
                'aksi' => 'SubmitQE',
            ];

            // dd($details);

            Mail::to($emailapprove)
                ->to($emailpengaju)
                ->send(new mailPMS($details));

            return redirect('historyqe');
        }
    }

    public function approveQe()
    {
        if (!session('iduser')) {
            return redirect('login')->with('pesan', 'Session anda telah habis, silahkan login kembali.');
        }

        $status = [1];
        if (session('idgroup') == 1) {
            $status = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10];
        }
        if (session('idgroup') == 10) {
            $status = [2];
        }
        if (session('idgroup') == 11) { // Parameter dengan userid karena hanya beliau BOD Procurement
            $status = [3];
        }
        if (in_array(session('idgroup'), [4, 12])) {
            $status = [4];
        }
        if (in_array(session('idgroup'), [3, 13])) {
            $status = [5];
        }
        if (in_array(session('idgroup'), [8, 14])) {
            $status = [6];
        }
        if (in_array(session('idgroup'), [15, 18])) { // Group ID untuk BOD
            $status = [7, 10];
        }
        if (session('idgroup') == 16) {
            $status = [8];
        }
        if (session('idgroup') == 17) {
            $status = [9];
        }

        $dataApprove = $this->db->getApprove($status);

        if ($dataApprove) {
            session([
                'cc' => $dataApprove[0]->companycode,
            ]);
        }

        $data = [
            'dataApprove' => $dataApprove,
            'title' => 'Quotation'
        ];

        return view('quotation.approve', $data);
    }

    public function approveQeDetail($id)
    {
        if (!session('iduser')) {
            return redirect('login')->with('pesan', 'Session anda telah habis, silahkan login kembali.');
        }

        $dataHeader = $this->db->getHistoryHeader($id)[0];
        $dataVendorHdr = $this->db->getVendorHeader($id);

        foreach ($dataVendorHdr as $x) {
            $vendor = $x->vendorcode;
            $dataVendorDtl[] = $this->db->getVendorDetail($vendor, $id);
        }

        $data = [
            'title' => 'Quotation',
            'dataHeader' => $dataHeader,
            'dataVendorHdr' => $dataVendorHdr,
            'dataVendorDtl' => $dataVendorDtl
        ];

        // dd($data);

        return view('quotation/approveDetail', $data);
    }

    public function setujuQe($id)
    {
        $dataHeader = $this->db->getHistoryHeader($id)[0];
        
        $status = $dataHeader->statusid;
        $dataHeader = $this->db->setujuQe($id, $status);

        $lastStatus = $this->db->getHistoryHeader($id)[0];
        $lastStatus = $lastStatus->statusid;

        if ($dataHeader) {
            if ($lastStatus == 11) {
                return redirect("kirimdata/$id");
            } else {
                $databody = $this->db->getHistoryHeader($id);
                $emailapprove = session('emailapprove');
                $emailpengaju = $databody[0]->emailpengaju;

                $details = [
                    'subject' => 'Approve QE',
                    'dataBody' => $databody,
                    'aksi' => 'ApproveQE',
                ];

                Mail::to($emailapprove)
                    ->to($emailpengaju)
                    ->send(new mailPMS($details));
                return redirect('approveqe')->with('pesan', 'Berhasil Approve Quotation.');
            }
        } else {
            return redirect('approveqe')->with('pesan', 'Gagal Approve Quotation.');
        }
    }

    public function lihatqedoc($id)
    {
        if (!session('iduser')) {
            return redirect('login')->with('pesan', 'Session anda telah habis, silahkan login kembali.');
        }

        $dataHeader = $this->db->getHistoryHeader($id)[0];
        $dataVendorHdr = $this->db->getVendorHeader($id);
        $lacak = $this->db->getLacak($id)[0];

        // dd($lacak);
        session([
            'cc' => $dataHeader->companycode,
        ]);

        foreach ($dataVendorHdr as $x) {
            $vendor = $x->vendorcode;
            $dataVendorDtl[] = $this->db->getVendorDetail($vendor, $id);
        }

        $data = [
            'title' => 'Quotation',
            'dataHeader' => $dataHeader,
            'dataVendorHdr' => $dataVendorHdr,
            'dataVendorDtl' => $dataVendorDtl,
            'lacak' => $lacak
        ];

        return view('quotation/qeDocument', $data);
    }

    public function cetak($id)
    {
        if (!session('iduser')) {
            return redirect('login')->with('pesan', 'Session anda telah habis, silahkan login kembali.');
        }

        $dataHeader = $this->db->getHistoryHeader($id)[0];
        $dataVendorHdr = $this->db->getVendorHeader($id);
        $lacak = $this->db->getLacak($id)[0];

        // dd($lacak);
        session([
            'cc' => $dataHeader->companycode,
        ]);

        foreach ($dataVendorHdr as $x) {
            $vendor = $x->vendorcode;
            $dataVendorDtl[] = $this->db->getVendorDetail($vendor, $id);
        }

        $data = [
            'title' => 'Quotation',
            'dataHeader' => $dataHeader,
            'dataVendorHdr' => $dataVendorHdr,
            'dataVendorDtl' => $dataVendorDtl,
            'lacak' => $lacak
        ];

        $pdf = PDF::loadView('quotation/qeDocument', $data)->setPaper('a2', 'landscape');;
        return $pdf->stream('PrintQe.pdf');
    }

    public function reject(Request $params)
    {
        $hdrid = $params->hdrid;
        $reason = $params->reason;
        $status = $params->status;

        // dd($params);

        $reject = $this->db->rejectQe($hdrid, $status, $reason);

        if ($reject) {
            $databody = $this->db->getHistoryHeader($hdrid);
            $emailapprove = session('emailapprove');
            $emailpengaju = $databody[0]->emailpengaju;

            $details = [
                'subject' => 'Reject QE',
                'dataBody' => $databody,
                'aksi' => 'RejectQE',
            ];

            Mail::to($emailapprove)
                ->to($emailpengaju)
                ->send(new mailPMS($details));

            return redirect('approveqe')->with('pesan', 'Sukses Reject QE');
        } else {
            return redirect('approveqe')->with('pesan', 'Gagal Reject QE');
        }

        return redirect('approveqe')->with('pesan', 'Sukses Reject QE');
>>>>>>> Stashed changes
    }
}
