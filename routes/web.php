<?php

use Illuminate\Support\Facades\Redirect;
use Illuminate\Support\Facades\Route;
use App\Http\Controllers\c_login;
use App\Http\Controllers\c_portal;
use App\Http\Controllers\c_lpbj;
use App\Http\Controllers\c_quotation;
use Illuminate\Support\Facades\Mail;
use App\Mail\mailPMS;

/*
|--------------------------------------------------------------------------
| Web Routes
|--------------------------------------------------------------------------
|
| Here is where you can register web routes for your application. These
| routes are loaded by the RouteServiceProvider within a group which
| contains the "web" middleware group. Now create something great!
|
*/

// Route::get('/', function () {
//     return view('welcome');
// });

Route::get('/', function () {
    return redirect('/login');
});

route::get('login', [c_login::class, 'index'])->name('login.index');
route::post('cekLogin', [c_login::class, 'cekLogin'])->name('login.cekLogin');

route::get('portal', [c_portal::class, 'index'])->name('portal.index');
route::get('logout', [c_login::class, 'logout'])->name('login.logout');

/* LPBJ */
route::get('tempsess/{p}', [c_lpbj::class, 'tempSess'])->name('lpbj.tempSess');
route::get('pengajuanlpbj', [c_lpbj::class, 'index'])->name('lpbj.pengajuan');
route::get('tambaharticle', [c_lpbj::class, 'tambahArticle'])->name('lpbj.tambaharticle');
route::get('historylpbj', [c_lpbj::class, 'history'])->name('lpbj.history');
route::get('historydetaillpbj', [c_lpbj::class, 'historyDetail'])->name('lpbj.historyDetail');
route::get('approvelpbj', [c_lpbj::class, 'approve'])->name('lpbj.approval');
route::get('approvedetaillpbj', [c_lpbj::class, 'approveDetail'])->name('lpbj.approvalDetail');

route::post('draftlpbj', [c_lpbj::class, 'createDraft'])->name('lpbj.createDraft');
route::post('ajukanlpbj', [c_lpbj::class, 'ajukan'])->name('lpbj.ajukan');
route::post('ajukanlpbjedit', [c_lpbj::class, 'ajukanEdit'])->name('lpbj.ajukanEdit');
route::post('setujulpbj', [c_lpbj::class, 'setuju'])->name('lpbj.setuju');
route::post('rejectlpbj', [c_lpbj::class, 'reject'])->name('lpbj.reject');

route::get('editlpbj/{id}', [c_lpbj::class, 'editLpbj'])->name('lpbj.editLpbj');
route::get('cekdraftlpbj/{id}', [c_lpbj::class, 'lihatDraft'])->name('lpbj.lihatDraft');
route::get('deldraftlpbj/{id}', [c_lpbj::class, 'deleteDraft'])->name('lpbj.deleteDraft');
route::get('detaillpbj/{id}', [c_lpbj::class, 'lihatDetail'])->name('lpbj.lihatDetail');
route::get('detailapprovelpbj/{id}', [c_lpbj::class, 'lihatApprove'])->name('lpbj.lihatApprove');

route::get('lpbjedt/{id}', [c_lpbj::class, 'lpbjEdt'])->name('lpbj.lpbjEdt');
route::get('lpbjdel/{id}', [c_lpbj::class, 'lpbjDel'])->name('lpbj.lpbjDel');
/* LPBJ */

/* Quotation */
route::get('pengajuanqe', [c_quotation::class, 'index'])->name('quotation.pengajuan');
route::get('historyqe', [c_quotation::class, 'history'])->name('quotation.history');
route::get('detailqe/{id}', [c_quotation::class, 'historyDetail'])->name('quotation.lihatDetail');
route::get('historydetailqe', [c_quotation::class, 'historyDetail'])->name('quotation.historyDetail');
route::get('detailhistoryqe/{id}', [c_quotation::class, 'detailHistoryQe'])->name('quotation.detailHistoryQe');
route::get('detailhistoryqe', [c_quotation::class, 'detailHistoryQe'])->name('quotation.detailHistoryQe');
route::get('tambahqe/{id}', [c_quotation::class, 'lihatQe'])->name('quotation.lihatQe');
route::get('tambahqe', [c_quotation::class, 'tambahQe'])->name('quotation.tambahQe');
Route::get('pdf/{id}', function ($id) {
    $filename = public_path('uploads/quotation/') . $id;
    return response()->file($filename);
});

route::post('draftqe', [c_quotation::class, 'draftQe'])->name('quotation.draftQe');
route::post('tambahvendor', [c_quotation::class, 'tambahVendor'])->name('quotation.tambahVendor');
route::get('deletedraftqe/{id}', [c_quotation::class, 'deleteVendor'])->name('quotation.deleteVendor');
route::post('insertdraftqe', [c_quotation::class, 'insertDraft'])->name('quotation.insertDraft');
route::post('ajukanqe', [c_quotation::class, 'ajukanQe'])->name('quotation.ajukanQe');
/* Quotation */


Route::get('sendmail', function () {
    $data = [
        'subject' => 'Test NJINK!',
        'dataBody' => 'Test NJINK!',
        'aksi' => 'TestEmail'
    ];

    Mail::to('mochamad.seliratno@electronic-city.co.id')->send(new mailPMS($data));

    dd("Email Berhasil dikirim.");
});

// route::get('email', function(){
//     return view('mail.testemail');
// });
