<?php

namespace App\Http\Controllers;

use App\Models\m_users;
use App\Http\Requests\Storem_usersRequest;
use App\Http\Requests\Updatem_usersRequest;

class MUsersController extends Controller
{
    /**
     * Display a listing of the resource.
     *
     * @return \Illuminate\Http\Response
     */
    public function index()
    {
        //
    }

    /**
     * Show the form for creating a new resource.
     *
     * @return \Illuminate\Http\Response
     */
    public function create()
    {
        //
    }

    /**
     * Store a newly created resource in storage.
     *
     * @param  \App\Http\Requests\Storem_usersRequest  $request
     * @return \Illuminate\Http\Response
     */
    public function store(Storem_usersRequest $request)
    {
        //
    }

    /**
     * Display the specified resource.
     *
     * @param  \App\Models\m_users  $m_users
     * @return \Illuminate\Http\Response
     */
    public function show(m_users $m_users)
    {
        //
    }

    /**
     * Show the form for editing the specified resource.
     *
     * @param  \App\Models\m_users  $m_users
     * @return \Illuminate\Http\Response
     */
    public function edit(m_users $m_users)
    {
        //
    }

    /**
     * Update the specified resource in storage.
     *
     * @param  \App\Http\Requests\Updatem_usersRequest  $request
     * @param  \App\Models\m_users  $m_users
     * @return \Illuminate\Http\Response
     */
    public function update(Updatem_usersRequest $request, m_users $m_users)
    {
        //
    }

    /**
     * Remove the specified resource from storage.
     *
     * @param  \App\Models\m_users  $m_users
     * @return \Illuminate\Http\Response
     */
    public function destroy(m_users $m_users)
    {
        //
    }
}
