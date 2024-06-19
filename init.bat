@echo off

for /f "delims=" %%i in ('curl -s https://api.github.com/repos/coder/code-server/releases/latest ^| jq -r ".tag_name"') do set CODE_VERSION=%%i
if "%CODE_VERSION:~0,1%"=="v" set CODE_VERSION=%CODE_VERSION:~1%
for /f "delims=" %%i in ('curl -s https://api.github.com/repos/rust-lang/rust-analyzer/releases/latest ^| jq -r ".tag_name"') do set RUST_ANALYZER_VERSION=%%i
for /f "delims=" %%i in ('curl -s https://api.github.com/repos/vadimcn/codelldb/releases/latest ^| jq -r ".tag_name"') do set CODELLDB_VERSION=%%i
if "%CODELLDB_VERSION:~0,1%"=="v" set CODELLDB_VERSION=%CODELLDB_VERSION:~1%

powershell -Command "(Get-Content Dockerfile) -replace 'ARG CODE_VERSION=.*', 'ARG CODE_VERSION=%CODE_VERSION%' | Set-Content Dockerfile"
powershell -Command "(Get-Content Dockerfile) -replace 'ARG RUST_ANALYZER_VERSION=.*', 'ARG RUST_ANALYZER_VERSION=%RUST_ANALYZER_VERSION%' | Set-Content Dockerfile"
powershell -Command "(Get-Content Dockerfile) -replace 'ARG CODELLDB_VERSION=.*', 'ARG CODELLDB_VERSION=%CODELLDB_VERSION%' | Set-Content Dockerfile"