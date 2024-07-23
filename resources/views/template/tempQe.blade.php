@php
    $usercek = [1, 5];
    $usergroup = session('idgroup');
@endphp

{{-- NavBar --}}
<header id="header" class="header grey-background d-flex flex-column">
    <i class="header-toggle d-xl-none bi bi-list"></i>

    <div class="profile-img">
        <img src="{{ asset('img/logo.jpg') }}" alt="" class="img-fluid rounded-circle">
    </div>

    <a href="#" class="logo d-flex align-items-center justify-content-center">
        <h1 class="sitename">{{ $title }}</h1>
    </a>

    <nav id="navmenu" class="navmenu">
        <ul>
            @if (in_array($usergroup, $usercek))
                <li>
                    <a href="{{ url('/pengajuanqe') }}">
                        <i class="bi bi-clipboard2-plus navicon"></i>
                        Pengajuan
                    </a>
                </li>
            @endif
            <li>
                <a href="{{ url('/historyqe') }}">
                    <i class="bi bi-clock-history navicon"></i>
                    History
                </a>
            </li>
            @if ($usergroup != 5)
                <li>
                    <a href="{{ url('/approveqe') }}">
                        <i class="bi bi-file-earmark-check navicon"></i>
                        Approval
                    </a>
                </li>
            @endif
            <li>
                <a href="{{ url('/portal') }}">
                    <i class="bi bi-backspace navicon"></i>
                    Kembali ke Menu
                </a>
            </li>
        </ul>
    </nav>
</header>
{{-- /NavBar --}}
