<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;
use App\Models\m_lpbj;
use Illuminate\Support\Facades\Storage;
use Illuminate\Support\Facades\Mail;
use App\Mail\mailPMS;
<<<<<<< Updated upstream
=======
use Barryvdh\DomPDF\Facade\Pdf;
use PhpOffice\PhpSpreadsheet\IOFactory;
use PhpOffice\PhpSpreadsheet\Spreadsheet;
use Illuminate\Support\Facades\Log;
use PhpOffice\PhpSpreadsheet\Cell\Coordinate;
use PhpOffice\PhpSpreadsheet\Style\Border;
use PhpOffice\PhpSpreadsheet\Style\Fill;
<<<<<<< Updated upstream
>>>>>>> Stashed changes
=======
>>>>>>> Stashed changes

class c_lpbj extends Controller
{

    protected $db;

    /**
     * Helper function to transform the collection to an array.
     *
     * @param mixed $data
     * @return array
     */
    private function getDataArray($data)
    {
        return $data ? $data->toArray() : [];
    }

    public function __construct()
    {
        $this->db = new m_lpbj();
    }

    public function tempSess($params)
    {
        $data = explode('|', $params);

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

        return redirect('tambaharticle');
    }

    public function index()
    {
<<<<<<< Updated upstream
<<<<<<< Updated upstream
        // dd(session()->exists('cc'));
        // dd(session()->all());
        $role = [1, 3, 4, 8];
        $roleAdmin = [1, 4];

        if (!session('iduser')) {
            return redirect('login')->with('pesan', 'Session anda telah habis, silahkan login kembali.');
        }

        if (!in_array(session('idgroup'), $role)) {
            return redirect('portal');
        }

        $userid = session('iduser');
        $dataPegawai = $this->db->getPegawai($userid)->toArray()[0];
        $dataDraft = $this->db->getDraft()->toArray();

        $data = [
            'dataPegawai' => $dataPegawai,
            'dataDraft' => $dataDraft,
            'title' => 'LPBJ'
=======
=======
>>>>>>> Stashed changes
        // Define roles
        $roles = [
            'allowed' => [1, 3, 4, 8, 12, 13, 14],
            'admin' => [1, 4, 12]
<<<<<<< Updated upstream
>>>>>>> Stashed changes
=======
>>>>>>> Stashed changes
        ];

        try {
            // Check for user session
            if (!session('iduser')) {
                return redirect('login')->with('pesan', 'Session anda telah habis, silahkan login kembali.');
            }

            // Check if user group is allowed
            $userGroup = session('idgroup');
            if (!in_array($userGroup, $roles['allowed'])) {
                return redirect('portal');
            }

            // Fetch user data
            $dataPegawai = $this->db->getPegawai(session('iduser'))[0];
            $dataDraft = $this->db->getDraft();

            // Prepare data for the view
            $data = [
                'dataPegawai' => $dataPegawai,
                'dataDraft' => $dataDraft,
                'title' => 'LPBJ'
            ];

            // Return appropriate view based on user group
            return in_array($userGroup, $roles['admin'])
                ? view('lpbjPage/pengajuan', $data)
                : redirect('historylpbj');

        } catch (\Exception $e) {
            // Handle exceptions (logging can be added here)
            return redirect('portal')->with('pesan', 'An error occurred: ' . $e->getMessage());
        }
    }


    public function tambahArticle()
    {
<<<<<<< Updated upstream
<<<<<<< Updated upstream
        // dd(session());
        if (!session('iduser')) {
            return redirect('login')->with('pesan', 'Session anda telah habis, silahkan login kembali.');
        }

        $dataDraft = '';
        if (session('draftid')) {
            $dataDraft = $this->db->cekDraft(session('draftid'))->toArray()[0];
=======
        $roles = [1, 3, 4, 8, 12, 13, 14];
        $dataDraft = '';
=======
        $roles = [1, 3, 4, 8, 12, 13, 14];
        $dataDraft = '';
>>>>>>> Stashed changes

        try {
            // Check for user session
            if (!session('iduser')) {
                return redirect('login')->with('pesan', 'Session anda telah habis, silahkan login kembali.');
            }

            // Check if user group is allowed
            if (!in_array(session('idgroup'), $roles)) {
                return redirect('portal');
            }

            // Retrieve draft data if it exists
            if (session('draftid')) {
                $dataDraft = $this->db->cekDraft(session('draftid'))[0] ?? null;
            }

            // Retrieve all necessary data
            $data = [
                'getArticle' => $this->getDataArray($this->db->getArticle()),
                'getSite' => $this->getDataArray($this->db->getSite()),
                'getGL' => $this->getDataArray($this->db->getGL()),
                'getCC' => $this->getDataArray($this->db->getCC()),
                'getOrder' => $this->getDataArray($this->db->getOrder()),
                'getAsset' => $this->getDataArray($this->db->getAsset()),
                'getDraft' => $dataDraft,
                'title' => 'LPBJ',
            ];

            // Return the view with the data
            return view('lpbjPage/tambahArticle', $data);

        } catch (\Exception $e) {
            // Handle exceptions (log the error or notify the user)
            return redirect('pengajuanlpbj')->with('pesan', 'An error occurred: ' . $e->getMessage());
<<<<<<< Updated upstream
>>>>>>> Stashed changes
=======
>>>>>>> Stashed changes
        }
    }

    public function ajukan(Request $params)
    {
        $userid = session('iduser');
<<<<<<< Updated upstream
<<<<<<< Updated upstream
        $dokumen = 1;
        if (session('doc') == 'drf') {
            $dokumen = 0;
        }
=======

        // Determine the document status
        $dokumen = ($params->pilihan === 'doc') ? 1 : 0;
>>>>>>> Stashed changes

=======

        // Determine the document status
        $dokumen = ($params->pilihan === 'doc') ? 1 : 0;

>>>>>>> Stashed changes
        // Prepare data for header insertion
        $data = [
            'userid' => $userid,
            'companycode' => $params->companyCode,
            'description' => $params->descLPBJ,
            'note' => $params->noteLPBJ,
            'status' => $dokumen
        ];

        try {
            // Insert header data and retrieve the inserted ID
            $insertHdr = $this->db->insertHdr($data);

<<<<<<< Updated upstream
<<<<<<< Updated upstream
        if ($insertHdr) {
            $databody = $this->db->getHistoryHeader($insertHdr)->toArray();
=======
=======
>>>>>>> Stashed changes
            // Check if the header insertion was successful
            if (!$insertHdr) {
                throw new \Exception('Failed to insert header data');
            }

            // Retrieve the body data and prepare email details
            $databody = $this->db->getHistoryHeader($insertHdr);
<<<<<<< Updated upstream
>>>>>>> Stashed changes
=======
>>>>>>> Stashed changes
            $emailapprove = session('emailapprove');
            $details = [
                'subject' => 'Submit LPBJ',
                'dataBody' => $databody,
                'aksi' => 'SubmitLPBJ',
            ];

            // Send email only if the document is required
            if ($dokumen === 1) {
                Mail::to($emailapprove)->send(new mailPMS($details));
            }

            // Clear the session data
            session()->forget(['cc', 'jdl', 'note', 'doc']);

            // Redirect to history page
            return redirect('historylpbj');

        } catch (\Exception $e) {
            // Redirect back with an error message
            return redirect('pengajuanlpbj')->with('pesan', 'LPBJ Submission Error: ' . $e->getMessage());
        }
    }


    public function ajukanEdit(Request $params)
    {
        // dd($params);
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
            $databody = $this->db->getHistoryHeader($hdrid)->toArray();
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
            echo 'gagal cukk';
            // return redirect('pengajuanlpbj')->with('pesan', 'Gagal mengajukan LPBJ, silahkan ulangi kembali');
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
        if (!session('iduser')) {
            return redirect('login')->with('pesan', 'Session anda telah habis, silahkan login kembali.');
        }

        $dataHistory = $this->db->getHistory()->toArray();
        $data = [
            'dataHistory' => $dataHistory,
            'title' => 'LPBJ'
        ];

        return view('lpbjPage/history', $data);
    }

    public function lihatDetail($id)
    {
        return Redirect('historydetaillpbj')->with('detailid', $id);
    }

    public function historyDetail()
    {
        if (!session('iduser')) {
            return redirect('login')->with('pesan', 'Session anda telah habis, silahkan login kembali.');
        }

        if (!session('detailid')) {
            return redirect('historylpbj');
        }

        $dataDetail = $this->db->getHistoryDetail(session('detailid'))->toArray();
        $dataHeader = $this->db->getHistoryHeader(session('detailid'))->toArray()[0];

        $data = [
            'dataDetail' => $dataDetail,
            'dataHeader' => $dataHeader,
            'title' => 'LPBJ'
        ];

        // dd($data);

        return view('lpbjPage/historyDetail', $data);
    }

    public function editLpbj($id)
    {
        if (!session('iduser')) {
            return redirect('login')->with('pesan', 'Session anda telah habis, silahkan login kembali.');
        }

        session()->forget(['jdl', 'note', 'doc']);

        $dataDetail = $this->db->getHistoryDetail($id)->toArray();
        $dataHeader = $this->db->getHistoryHeader($id)->toArray()[0];

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
        // dd($data);

        return view('lpbjPage/editLpbj', $data);
    }

    public function approve()
    {
        if (!session('iduser')) {
            return redirect('login')->with('pesan', 'Session anda telah habis, silahkan login kembali.');
        }

        $status = 1;
        if (session('idgroup') == 8) {
            $status = 2;
        }
        $dataApprove = $this->db->getApprove($status)->toArray();
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
        if (!session('iduser')) {
            return redirect('login')->with('pesan', 'Session anda telah habis, silahkan login kembali.');
        }

        if (!session('detailid')) {
            return redirect('approvelpbj');
        }

        $dataDetail = $this->db->getHistoryDetail(session('detailid'))->toArray();
        $dataHeader = $this->db->getHistoryHeader(session('detailid'))->toArray()[0];

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
            $databody = $this->db->getHistoryHeader($hdrid)->toArray();
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
        $status = 12;

        // dd($params);

        $reject = $this->db->rejectLpbj($hdrid, $status, $reason);

        if ($reject) {
            $databody = $this->db->getHistoryHeader($hdrid)->toArray();
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
        if (!session('iduser')) {
            return redirect('login')->with('pesan', 'Session anda telah habis, silahkan login kembali.');
        }

        $dataDraft = $this->db->getHistoryDetailEdt($id)->toArray()[0];
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

        // dd(session()->all());

        return view('lpbjPage/editDetailLpbj', $data);
    }

    public function lpbjEdtAdd($id)
    {
        if (!session('iduser')) {
            return redirect('login')->with('pesan', 'Session anda telah habis, silahkan login kembali.');
        }

        $dataDraft = $this->db->getHistoryDetail($id)->toArray()[0];
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
        // dd($params);
        $dtlid = $params->dtlid;
        $dataDetail = $this->db->getHistoryDetailEdt($dtlid)->toArray()[0];

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
        // dd($params);
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
        $dataDraft = $this->db->getHistoryDetailEdt($id)->toArray()[0];
        $deleteData = $this->db->deleteDtl($id);

        if ($deleteData) {
            return redirect("editlpbj/$dataDraft->hdrid")->with('pesan', 'Data berhasil dihapus');
        } else {
            return redirect('pengajuanlpbj')->with('pesan', 'Gagal menghapus data.');
        }
    }
<<<<<<< Updated upstream
=======

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

    public function generateReport($userId)
    {
        $divname = session('divname');
        $nama = session('name');
        try {
            // Fetch the data for the report
            $reportData = $this->db->reportPMS($userId);

            // Path to the template file
            $templatePath = public_path('template/reportPMS.xlsx');

            // Load the template spreadsheet
            $spreadsheet = IOFactory::load($templatePath);

            // Assuming you want to fill data starting from a specific cell like A2
            $sheet = $spreadsheet->getActiveSheet();
            $startRow = 8;
            $sheet->setCellValue('C3', $divname);
            $sheet->setCellValue('C4', $nama);
            // Define border style
            $borderStyle = [
                'borders' => [
                    'allBorders' => [
                        'borderStyle' => Border::BORDER_THIN,
                        'color' => ['argb' => 'FF000000'], // Black border color
                    ],
                ],
            ];


            // Populate the spreadsheet with data
            foreach ($reportData as $index => $dataRow) {
                $sheet->setCellValue('B' . $startRow, $dataRow->nolpbj);
                $sheet->setCellValue('C' . $startRow, $dataRow->tgllpbj);
                $sheet->setCellValue('D' . $startRow, $dataRow->description);
                $sheet->setCellValue('E' . $startRow, $dataRow->article);
                $sheet->setCellValue('F' . $startRow, $dataRow->workflowlpbj);
                $sheet->setCellValue('G' . $startRow, $dataRow->pengajuanlpbj);
                $sheet->setCellValue('H' . $startRow, $dataRow->approval1lpbj);
                $sheet->setCellValue('I' . $startRow, $dataRow->approval2lpbj);
                $sheet->setCellValue('K' . $startRow, $dataRow->noqe);
                $sheet->setCellValue('L' . $startRow, $dataRow->tglqe);
                $sheet->setCellValue('M' . $startRow, $dataRow->descqe);
                $sheet->setCellValue('N' . $startRow, $dataRow->vendor);
                $sheet->setCellValue('O' . $startRow, $dataRow->qty);
                $sheet->setCellValue('P' . $startRow, $dataRow->satuan);
                $sheet->setCellValue('Q' . $startRow, $dataRow->tax);
                $sheet->setCellValue('R' . $startRow, $dataRow->gtotal);
                $sheet->setCellValue('S' . $startRow, $dataRow->workflowqe);
                $sheet->setCellValue('T' . $startRow, $dataRow->pengajuanqe);
                $sheet->setCellValue('U' . $startRow, $dataRow->approval1qe);
                $sheet->setCellValue('V' . $startRow, $dataRow->approval2qe);
                $sheet->setCellValue('W' . $startRow, $dataRow->approval3qe);
                $sheet->setCellValue('X' . $startRow, $dataRow->approval4qe);
                $sheet->setCellValue('Y' . $startRow, $dataRow->approval5qe);
                $sheet->setCellValue('Z' . $startRow, $dataRow->approval6qe);
                $sheet->setCellValue('AA' . $startRow, $dataRow->approval7qe);
                $sheet->setCellValue('AB' . $startRow, $dataRow->approval8qe);
                $sheet->setCellValue('AC' . $startRow, $dataRow->approval9qe);
                $sheet->setCellValue('AD' . $startRow, $dataRow->approval10qe);
                $sheet->setCellValue('AF' . $startRow, $dataRow->pono);
                $sheet->setCellValue('AG' . $startRow, $dataRow->tglpo);

                // Apply borders to the populated row
                $sheet->getStyle("B{$startRow}:AG{$startRow}")->applyFromArray($borderStyle);

                $startRow++;
            }

            // Set the response headers for downloading the file
            $fileName = 'Report_' . $nama . '_' . $divname . '_' . date('Ymd') . '.xlsx';

            // Stream the file to the browser
            header('Content-Type: application/vnd.openxmlformats-officedocument.spreadsheetml.sheet');
            header('Content-Disposition: attachment;filename="' . $fileName . '"');
            header('Cache-Control: max-age=0');

            $writer = IOFactory::createWriter($spreadsheet, 'Xlsx');
            $writer->save('php://output'); // Direct download

            exit; // Ensure script termination after download

        } catch (\Exception $e) {
            // Log and handle the exception
            Log::error('Error generating report: ', [
                'userId' => $userId,
                'error' => $e->getMessage(),
                'trace' => $e->getTraceAsString(),
            ]);

            return response()->json([
                'success' => false,
                'message' => 'Failed to generate the report.'
            ], 500);
        }
    }
<<<<<<< Updated upstream
>>>>>>> Stashed changes
=======
>>>>>>> Stashed changes
}
