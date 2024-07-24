<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;
use App\Models\restfulapi;
use Illuminate\Support\Facades\Http;
use Illuminate\Http\Client\RequestException;

class c_apisap extends Controller
{

    protected $db;
    public function __construct()
    {
        $this->db = new restfulapi();
    }
    /**
     * Display a listing of the resource.
     *
     * @return \Illuminate\Http\Response
     */
    public function index()
    {
        $projects = restfulapi::get();

        return response()->json($projects);
    }

    /**
     * Store a newly created resource in storage.
     *
     * @param  \Illuminate\Http\Request  $request
     * @return \Illuminate\Http\Response
     */
    public function store(Request $request)
    {
        $project = new restfulapi();
        $project->name = $request->name;
        $project->description = $request->description;
        $project->save();

        return response()->json($project);
    }

    /**
     * Display the specified resource.
     *
     * @param  int  $id
     * @return \Illuminate\Http\Response
     */
    public function show($id)
    {
        $project = restfulapi::find($id);
        return response()->json($project);
    }

    /**
     * Update the specified resource in storage.
     *
     * @param  \Illuminate\Http\Request  $request
     * @param  int  $id
     * @return \Illuminate\Http\Response
     */
    public function update(Request $request, $id)
    {
        $project = restfulapi::find($id);
        $project->name = $request->name;
        $project->description = $request->description;
        $project->save();

        return response()->json($project);
    }

    /**
     * Remove the specified resource from storage.
     *
     * @param  int  $id
     * @return \Illuminate\Http\Response
     */
    public function destroy($id)
    {
        restfulapi::destroy($id);

        return response()->json(['message' => 'Deleted']);
    }

    public function kirimData(Request $request)
    {
        $data = $request->all();
        $response = Http::post('http://10.140.3.6:8000/sap/ws/pms/prpo?sap-client=400', $data);
        $apiResponse = $response->json();
        return response()->json($apiResponse);
    }

    public function cekapi($id)
    {
        // dd($id);
        $endpoint = 'http://10.140.3.6:8000/sap/ws/pms/prpo?sap-client=400';
        $param1 = $this->db->param1($id)[0];
        $param2 = $this->db->param2($id);
        $preqitem = 10;
        $seq = 1;
        $asset = [];

        foreach ($param2 as $x) {

            if ($x->assetno) {
                $asset = [
                    'seq' => substr('0' . $seq, 0, 2),
                    'asset_no' => $x->assetno,
                    'quantity' => 1
                ];
            }

            $item[] = [
                'preq_item' => ($x->preq_item + $preqitem),
                'pur_group' => 'G01',
                'preq_name' => $x->preq_name,
                'short_text' => $x->short_text,
                'material' => $x->material,
                'plant' => $x->plant,
                'quantity' => $x->quantity,
                'unit' => $x->unit,
                'deliv_date' => $x->deliv_date,
                'preq_price' => $x->preq_price,
                'currency' => 'IDR',
                'acctasscat' => $x->acctasscat,
                'gl_account' => $x->gl_account,
                'costcenter' => $x->costcenter,
                'orderid' => $x->orderid,
                'tax_code' => $x->tax_code,
                'trackingno' => $x->trackingno,
                'asset' => [$asset],
                'text_item' => [
                    [
                        'text_line' => ''
                    ],
                ]
            ];

            $preqitem = $preqitem  + 10;
            // $seq = $seq + 1;
        }

        $txthdr2 = $param1->description;
        $split = str_split($param1->note, 132);
        $txthdr[] = ['text_line' => $txthdr2];

        $i = 0;
        foreach ($split as $a) {
            $txthdr1[] = $a;
            $txthdr[] = [
                'text_line' => $txthdr1[$i]
            ];
            $i++;
        }

        // dd($txthdr);

        $data = [
            'doc_type' => 'ZG',
            'company_code' => $param1->company_code,
            'vendor' => $param1->vendor,
            'doc_date' => $param1->doc_date,
            'ref_1' => $param1->ref_1,
            'created_by' => $param1->created_by,
            'text_header' => [
                $txthdr
            ],
            'item' => $item,
        ];

        // dd($data);

        $response = Http::withBasicAuth('defa', '123123123')->post($endpoint, $data);
        // dd($response);

        $apiResponse = $response->json();
        // dd($apiResponse);

        // return response()->json($apiResponse)->content();
        // dd($apiResponse['returnpr'][0]['message']);

        foreach ($apiResponse['returnpr'] as $x) {
            $msg[] = $x['message'];
        }

        // dd($msg);
        $m = implode(" || ", $msg);
        $prno = $apiResponse['prno'];
        $pono = $apiResponse['pono'];
        $json = response()->json($apiResponse)->content();
        $data = [
            'qeid' => $param1->ref_1,
            'lpbjid' => $param1->ref_2,
            'prno' => $prno,
            'pono' => $pono,
            'json' => $json,
        ];

        $insert = $this->db->insertjson($data);

        if ($insert === 'S') {
            $qeid = $param1->ref_1;
            $lpbjid = $param1->ref_2;

            $this->db->popr($qeid, $lpbjid);

            return redirect('approveqe')->with('pesan', "Data berhasil Create PO dengan PO Number: $prno");
        } else {
            $this->db->statusQe($id);
            return redirect('approveqe')->with('pesan', "Data gagal untuk dibuat PO dengan keterangan: $m");
        }
    }
}
