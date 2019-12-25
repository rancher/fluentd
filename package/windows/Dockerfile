ARG SERVERCORE_VERSION

FROM mcr.microsoft.com/windows/servercore:${SERVERCORE_VERSION}

RUN powershell -Command "Set-ExecutionPolicy Bypass -Scope Process -Force; iex ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1'))"

COPY Gemfile 'C:\fluentd\install\Gemfile'
COPY Gemfile.lock 'C:\fluentd\install\Gemfile.lock'
COPY upgrade-gems.ps1 'C:\fluentd\install\upgrade-gems.ps1'

COPY fluent.conf 'C:\etc\fluent\fluent.conf'

RUN choco install -y ruby --version 2.6.5.1 --params "'/InstallDir:C:\ruby26'" \
&& choco install -y msys2 --params "'/NoPath /NoUpdate /InstallDir:C:\ruby26\msys64'"
RUN refreshenv \
&& ridk install 2 3 \
&& echo gem: --no-document >> C:\ProgramData\gemrc \
&& gem install cool.io -v 1.5.4 --platform ruby \
&& gem install bundler \
&& bundle install --gemfile='C:\fluentd\install\Gemfile' \
&& gem sources --clear-all

RUN powershell -Command "Remove-Item -Force C:\ruby26\lib\ruby\gems\2.6.0\cache\*.gem; Remove-Item -Recurse -Force 'C:\ProgramData\chocolatey'"

CMD ["powershell", "-command", "fluentd"]