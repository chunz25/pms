let sesscc = "{{ session('cc') }}";
let sessjdl = "{{ session('jdl') }}";
let sessnote = "{{ session('note') }}";
let sessdoc = "{{ session('doc') }}";

document.getElementById(sesscc).selected = true;
document.getElementById("descLPBJ").value = sessjdl;
document.getElementById("noteLPBJ").value = sessnote;
document.getElementById(sessdoc).selected = true;

function tambahData() {
    let cc = document.querySelector("#companyCode").value;
    let jdl = document.querySelector("#descLPBJ").value;
    let note = document.querySelector("#noteLPBJ").value;
    let doc = document.querySelector("#pilihan").value;
    let params = cc + "|" + jdl + "|" + note + "|" + doc;

    if (doc == "") {
        alert("Pilih Status Dokumen terlebih dahulu");
    } else if (cc == "") {
        alert("Pilih Company Code terlebih dahulu");
    } else {
        window.location.href = "{{ url('/tempsess') }}" + "/" + params;
    }
}
