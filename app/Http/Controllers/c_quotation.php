<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;
use App\Models\m_quotation;
use Illuminate\Support\Facades\Storage;
use App\Http\Controllers\Response;
use Barryvdh\DomPDF\Facade\Pdf;
use Illuminate\Support\Facades\Mail;
use App\Mail\mailPMS;

class c_quotation extends Controller
{
    protected $db;
    public function __construct()
    {
        $this->db = new m_quotation();
    }

    public function index()
    {
        $roleAdmin = [1, 5];

        if (!session('iduser')) {
            return redirect('login')->with('pesan', 'Session anda telah habis, silahkan login kembali.');
        }

        $dataQe = $this->db->getListQe();
        $data = [
            'title' => 'Quotation',
            'dataQe' => $dataQe
        ];

        if (in_array(session('idgroup'), $roleAdmin)) {
            return view('quotation.pengajuan', $data);
        } else {
            return redirect('historyqe');
        }
    }

    public function history()
    {
        if (!session('iduser')) {
            return redirect('login')->with('pesan', 'Session anda telah habis, silahkan login kembali.');
        }

        $dataHistory = $this->db->getListHistory();
        $data = [
            'title' => 'Quotation',
            'dataHistory' => $dataHistory
        ];

        return view('quotation.history', $data);
    }

    public function historyDetail($id)
    {
        if (!session('iduser')) {
            return redirect('login')->with('pesan', 'Session anda telah habis, silahkan login kembali.');
        }

        $dataHeader = $this->db->getHistoryHeader($id)[0];

        session(
            ['cc' => $dataHeader->companycode]
        );

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

        return view('quotation/historyDetail', $data);
    }

    public function historySubdetail($id)
    {
        if (!session('iduser')) {
            return redirect('login')->with('pesan', 'Session anda telah habis, silahkan login kembali.');
        }

        $temp = explode(',', $id);
        $hdrid = $temp[0];
        $vendor = $temp[1];
        $x = [
            'hdrid' => $hdrid,
            'vendor' => $vendor,
        ];

        $draftQe = $this->db->getSubdetail($x);
        $data = [
            'title' => 'Quotation',
            'getDtl' => $draftQe
        ];

        return view('quotation/historySubdetail', $data);
    }

    public function lihatQe($id)
    {
        if (!session('iduser')) {
            return redirect('login')->with('pesan', 'Session anda telah habis, silahkan login kembali.');
        }

        $dataLpbj = $this->db->getLpbj($id);
        session(
            ['cc' => $dataLpbj[0]->companycode]
        );

        $data = [
            'title' => 'Quotation',
            'getLpbj' => $dataLpbj
        ];

        return view('quotation.tambahQe', $data);
    }

    public function draftQe($id)
    {
        if (!session('iduser')) {
            return redirect('login')->with('pesan', 'Session anda telah habis, silahkan login kembali.');
        }

        $data = explode(',', $id);

        foreach ($data as $j) {
            $dataLpbj[] = $this->db->getLpbjDtl($j)[0];
        }

        $hdrid = $dataLpbj[0]->hdrid;
        $dataVendor = $this->db->getVDraft($dataLpbj[0]->dtlid);
        $dataLpbj = $this->db->getLpbj($hdrid)[0];

        $dataDraft = null;
        foreach ($data as $a) {
            $dataDtl[] = $this->db->getLpbjDtl($a)[0];
            $cekData = $this->db->getDraft($a);

            if ($cekData) {
                for ($i = 0; $i < count($cekData); $i++) {
                    $dataDraft[] = $this->db->getDraft($a)[$i];
                }
            }
        }

        $data = [
            'title' => 'Quotation',
            'getLpbj' => $dataLpbj,
            'dataDtl' => $dataDtl,
            'dataDraft' => $dataDraft,
            'dataVendor' => $dataVendor,
            'iddtl' => $data,
        ];

        return view('quotation.draftQe', $data);
    }

    public function draftQeEdit($id)
    {
        if (!session('iduser')) {
            return redirect('login')->with('pesan', 'Session anda telah habis, silahkan login kembali.');
        }

        $temp = explode(',', $id);
        $hdrid = $temp[0];
        $vendor = $temp[1];
        $x = [
            'hdrid' => $hdrid,
            'vendor' => $vendor,
        ];

        $draftQe = $this->db->getDraftEdit($x);
        $dataVendor = $this->db->getVendor()->toArray();
        $dataTax = $this->db->getTax();

        $data = [
            'title' => 'Quotation',
            'getVendor' => $dataVendor,
            'getTax' => $dataTax,
            'getDtl' => $draftQe
        ];

        return view('quotation.editDraftQe', $data);
    }

    public function updateDraftQe(Request $params)
    {
        $temp = implode(',', $params->dtlid);
        $dtlid = $params->dtlid;
        $hdrid = $params->hdrid;
        $vendorcode = $params->vendorcode;
        $attach = $this->db->getAttach($dtlid[0], $vendorcode);
        $file = public_path('uploads/quotation' . $attach[0]->attachment);
        $filename = $params->file('attach')->getClientOriginalName();
        $pilih = 0;

        if (isset($params->pilih)) {
            $pilih = 1;
        }

        if ($filename === $attach[0]->attachment) {
            $ext = $params->file('attach')->getClientOriginalExtension();
            $uploadpath = $hdrid . '_' . $vendorcode . '.' . $ext;
            Storage::move($file, 'quotation/' . $uploadpath);
        } else {
            $filename = $params->file('attach')->getClientOriginalName();
            $ext = $params->file('attach')->getClientOriginalExtension();
            $uploadpath = $hdrid . '_' . $vendorcode . '.' . $ext;
            $filename = $params->file('attach')->storeAs('quotation', $filename);
            Storage::move($filename, 'quotation/' . $uploadpath);
        }

        $i = 0;
        foreach ($dtlid as $x) {
            $dataParams = [
                'dtlid' => $x,
                'vendorcode' => $vendorcode,
                'ispilih' => $pilih,
                'franco' => $params->franco,
                'ispkp' => $params->pkp,
                'term' => $params->term,
                'top' => $params->top,
                'taxcode' => $params->taxcode,
                'contactperson' => $params->person,
                'notelp' => $params->telp,
                'remark' => $params->remark,
                'satuan' => $params->satuan[$i],
                'total' => $params->total[$i],
                'pajak' => $params->pajak[$i],
                'gtotal' => $params->gtotal[$i],
                'remarkqa' => $params->remarkqa[$i],
                'attachment' => $uploadpath
            ];

            $this->db->updateDraftQe($dataParams);
            $i++;
        }

        return redirect("tempdraft/$temp")->with('pesan', 'Berhasil update data');
    }

    public function draftQeDel($id)
    {
        $data = explode(',', $id);
        $hdrid = $data[0];
        $vendorCode = $data[1];

        $x = [
            'hdrid' => $hdrid,
            'vendor' => $vendorCode,
        ];

        $draftQe = $this->db->getDraftEdit($x);

        $id = [];
        foreach ($draftQe as $x) {
            $dtlid = $x->dtlid;
            $vendor = $x->vendorcode;
            $id[] = $dtlid;

            $deleteData = $this->db->deleteDraft($dtlid, $vendor);
        }

        $temp = implode(',', $id);

        if ($deleteData) {
            return redirect("tempdraft/$temp")->with('pesan', 'Data berhasil dihapus');
        } else {
            return redirect('pengajuanlpbj')->with('pesan', 'Gagal menghapus data.');
        }
    }

    public function tambahVendor(Request $params)
    {
        if (!session('iduser')) {
            return redirect('login')->with('pesan', 'Session anda telah habis, silahkan login kembali.');
        }

        $id = $params->dtl;
        $dataVendor = $this->db->getVendor()->toArray();
        $dataTax = $this->db->getTax();

        foreach ($id as $a) {
            $dataDtl[] = $this->db->getLpbjDtl($a)[0];
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
        $temp = implode(',', $params->dtlid);
        $pilih = 0;

        // dd($temp);

        if (isset($params->pilih)) {
            $pilih = 1;
        }

        for ($i = 0; $i < $id; $i++) {
            $dtlid = $params->dtlid[$i];
            $vendorcode = $params->vendorcode;
            $hdrid = $params->hdrid;

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
                'attach' => $uploadpath,
                'pajak' => $params->pajak[$i],
                'gtotal' => $params->gtotal[$i],
                'total' => $params->total[$i],
                'taxcode' => $params->total[$i],
            ];

            $insertData = $this->db->insertDraft($data);
        }

        if ($insertData) {
            return redirect("tempdraft/$temp");
        } else {
            return redirect('tambahvendor')->with('pesan', 'Gagal menambahkan data.');
        }
    }

    public function ajukanQe(Request $params)
    {
        // dd($params);
        $dtlid = $params->dtl;
        $this->db->ajukanQe($dtlid[0]);

        foreach ($dtlid as $i) {
            $this->db->ajukanQeDetail($i);
            $this->db->updateQe($i);
        }

        return redirect('historyqe');
    }

    public function approveQe()
    {
        if (!session('iduser')) {
            return redirect('login')->with('pesan', 'Session anda telah habis, silahkan login kembali.');
        }

        $status = 1;
        if (session('idgroup') == 10) {
            $status = 2;
        }
        if (session('idgroup') == 11) {
            $status = 3;
        }
        if (session('idgroup') == 12 || session('idgroup') == 4) {
            $status = 4;
        }
        if (session('idgroup') == 13 || session('idgroup') == 3) {
            $status = 5;
        }
        if (session('idgroup') == 14 || session('idgroup') == 8) {
            $status = 6;
        }
        if (session('idgroup') == 15) {
            $status = 7;
        }
        if (session('idgroup') == 16) {
            $status = 8;
        }
        if (session('idgroup') == 17) {
            $status = 9;
        }
        if (session('idgroup') == 18) {
            $status = 10;
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

        return view('quotation/approveDetail', $data);
    }

    public function setujuQe($id)
    {
        $dataHeader = $this->db->getHistoryHeader($id)[0];

        $status = $dataHeader->statusid;
        $dataHeader = $this->db->setujuQe($id, $status);

        return redirect('approveqe')->with('pesan', 'Berhasil Approve Quotation.');
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

        // if ($reject) {
        //     $databody = $this->db->getHistoryHeader($hdrid);
        //     $emailapprove = session('emailapprove');
        //     $emailpengaju = $databody[0]->emailpengaju;

        //     $details = [
        //         'subject' => 'Reject LPBJ',
        //         'dataBody' => $databody,
        //         'aksi' => 'RejectLPBJ',
        //     ];

        //     Mail::to($emailapprove)
        //         ->to($emailpengaju)
        //         ->send(new mailPMS($details));

        //     return redirect('approveqe')->with('pesan', 'Sukses Reject LPBJ');
        // } else {
        //     return redirect('approveqe')->with('pesan', 'Gagal Reject LPBJ');
        // }

        return redirect('approveqe')->with('pesan', 'Sukses Reject LPBJ');
    }
}
