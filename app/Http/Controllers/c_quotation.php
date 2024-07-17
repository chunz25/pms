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

        foreach ($id as $a) {
            $dataDtl[] = $this->db->getLpbjDtl($a)->toArray()[0];
        }

        $data = [
            'title' => 'Quotation',
            'getVendor' => $dataVendor,
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

        foreach ($dtlid as $i) {
            $this->db->ajukanQeDetail($i);
            $this->db->updateQe($i);
        }

        return redirect('pengajuanqe');
    }
}
