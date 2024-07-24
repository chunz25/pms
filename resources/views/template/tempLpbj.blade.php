@php
    $approver = ['APPROVER 1 LPBJ', 'APPROVER 2 LPBJ', 'APPROVER 5 QE', 'APPROVER 6 QE'];
    $usergroup = session('groupname');
@endphp

{{-- NavBar --}}
<header id="header" class="header grey-background d-flex flex-column">
    <i class="header-toggle d-xl-none bi bi-list"></i>

    <div class="profile-img">
        <img src="{{ asset('img/logo.jpg') }}" alt="" class="img-fluid rounded-circle">
    </div>

    <a class="logo d-flex align-items-center justify-content-center">
        <h1 class="sitename">{{ $title }}</h1>
    </a>

    <nav id="navmenu" class="navmenu">
        <ul>
            @if (!in_array($usergroup, $approver))
                <li>
                    <a id="pengajuan" href="{{ url('/pengajuanlpbj') }}">
                        <i class="bi bi-clipboard2-plus navicon"></i>
                        Pengajuan
                    </a>
                </li>
            @endif
            <li>
                <a id="history" href="{{ url('/historylpbj') }}">
                    <i class="bi bi-clock-history navicon"></i>
                    History
                </a>
            </li>
            @if (in_array($usergroup, $approver) || $usergroup == 'ADMINISTRATOR')
                <li>
                    <a id="approval" href="{{ url('/approvelpbj') }}">
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
