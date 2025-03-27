Name:           app-b
Version:        1.0
Release:        1%{?dist}
Summary:        Application B with OpenSSL 3.0

License:        MIT
Source0:        app_b.c

BuildRequires:  openssl-devel
Requires:       openssl30

%description
Application B using OpenSSL 3.0

%prep
cp %{SOURCE0} app_b.c

%build
gcc -o app_b app_b.c -lssl -lcrypto

%install
mkdir -p %{buildroot}%{_bindir}
install -m 755 app_b %{buildroot}%{_bindir}/app_b

%files
%{_bindir}/app_b

%changelog
* Wed Mar 20 2024 Stepan Illichevskii <still.ru@gmail.com> - 1.0-1
- Initial package
