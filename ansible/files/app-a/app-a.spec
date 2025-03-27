Name:           app-a
Version:        1.0
Release:        1%{?dist}
Summary:        Application A with OpenSSL 1.1.1

License:        MIT
Source0:        app_a.c

BuildRequires:  openssl-devel
Requires:       openssl11

%description
Application A using OpenSSL 1.1.1

%prep
cp %{SOURCE0} app_a.c

%build
gcc -o app_a app_a.c -lssl -lcrypto

%install
mkdir -p %{buildroot}%{_bindir}
install -m 755 app_a %{buildroot}%{_bindir}/app_a

%files
%{_bindir}/app_a

%changelog
* Wed Mar 20 2024 Stepan Illichevskii <still.ru@gmail.com> - 1.0-1
- Initial package
