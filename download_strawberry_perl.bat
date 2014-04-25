SET PATH="%~dp0util";%PATH%
curl -o strawberry_perl.msi -L http://strawberryperl.com/download/5.18.2.2/strawberry-perl-5.18.2.2-32bit.msi
msiexec /a strawberry_perl.msi /qn TARGETDIR=%~dp0strawberry_perl
del strawberry_perl.msi
