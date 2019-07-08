ARG SERVERCORE_VERSION

FROM mcr.microsoft.com/windows/servercore:${SERVERCORE_VERSION}

RUN powershell -Command $ErrorActionPreference = 'Stop'; $ProgressPreference = 'SilentlyContinue'; \
    powershell -Command "Set-ExecutionPolicy Bypass -Scope Process -Force; iex ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1'))"

COPY Gemfile 'C:\fluentd\install\Gemfile'
COPY Gemfile.lock 'C:\fluentd\install\Gemfile.lock'
COPY upgrade-gems.ps1 'C:\fluentd\install\upgrade-gems.ps1'

COPY fluent.conf 'C:\etc\fluent\fluent.conf'

RUN choco install -y ruby --version 2.4.2.2 --params "'/InstallDir:C:\'" \
&& choco install -y msys2 --params "'/NoPath /NoUpdate /InstallDir:C:\ruby24\msys64'" \
&& refreshenv \
&& ridk install 2 3 \
&& echo gem: --no-document >> C:\ProgramData\gemrc \
&& gem install bundle -v 0.0.1 \
&& bundle install --gemfile='C:\fluentd\install\Gemfile' \
&& gem sources --clear-all

RUN powershell -Command $ErrorActionPreference = 'Stop'; $ProgressPreference = 'SilentlyContinue'; \
    powershell -Command "del C:\ruby24\lib\ruby\gems\2.4.0\cache\*.gem; Remove-Item -Recurse -Force C:\ProgramData\chocolatey"

CMD ["powershell", "-command", "fluentd"]