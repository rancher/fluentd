ARG SERVERCORE_VERSION
FROM mcr.microsoft.com/windows/servercore:${SERVERCORE_VERSION}

# Download base ruby with devkit
RUN powershell [Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12 ; \
    Invoke-WebRequest https://github.com/oneclick/rubyinstaller2/releases/download/RubyInstaller-2.7.3-1/rubyinstaller-devkit-2.7.3-1-x64.exe -Outfile rubyinstaller.exe

# Install base ruby and initialize devkit
RUN (cmd /c rubyinstaller.exe /verysilent /log=install.log) || (powershell get-content c:/install.log)
RUN powershell -NoLogo -Command $ErrorActionPreference = 'Stop'; $env:PATH = [Environment]::GetEnvironmentVariable('PATH','Machine'); \
    powershell -NoLogo -Command $ErrorActionPreference = 'Stop'; $env:RUBYOPT = [Environment]::GetEnvironmentVariable('RUBYOPT','Machine')

# configure PATH for ruby and msys2
RUN ruby --version

# setup gemfile and gemrc files
COPY Gemfile 'C:\fluentd\install\Gemfile'
COPY Gemfile.lock 'C:\fluentd\install\Gemfile.lock'

# install msys2
RUN ridk install 1
RUN ridk enable

# install gem bundler and configure bundles
RUN powershell -Command $ErrorActionPreference = 'Stop'; \
    "[IO.File]::WriteAllLines('C:\ProgramData\gemrc', 'gem: --no-document')"; \
    gem install bundler --no-doc; \
    bundle config build.certstore_c --with-cflags="-Wno-attributes"; \
    bundle config build.yajl-ruby --with-cflags="-Wno-attributes"; \
    bundle config build.oj --with-cflags="-Wno-attributes"; \
    bundle install --gemfile='C:\fluentd\install\Gemfile'; \
    gem sources --clear-all

# cleanup
RUN powershell -NoLogo -Command $ErrorActionPreference = 'SilentlyContinue'; Remove-Item -Force C:\Ruby27-x64\lib\ruby\gems\2.7.0\cache\*.gem
RUN powershell -NoLogo -Command $ErrorActionPreference = 'SilentlyContinue'; Remove-Item -Force C:\rubyinstaller.exe

COPY upgrade-gems.ps1 'C:\fluentd\install\upgrade-gems.ps1'
COPY fluent.conf 'C:\etc\fluent\fluent.conf'

CMD ["powershell", "-command", "fluentd"]
