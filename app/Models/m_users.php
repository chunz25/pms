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

        $users = DB::table('vw_getuser')
            ->select('*')
            ->where('username', '=', $user)
            ->where('password', '=', md5($pass))
            ->where('isaktif', '=', 1)
            ->orWhere('username', '=', $user)
            ->Where('password2', '=', md5($pass))
            ->get();

        return $users;
    }

    public function getMenu($id)
    {
        $users = DB::table('vw_usermenu')
            ->select('*')
            ->where('userid', $id)
            ->get();

        return $users;
    }
}
