oh-my-posh init pwsh --config "$env:POSH_THEMES_PATH\tos-term.omp.json" | Invoke-Expression
Import-Module -Name Terminal-Icons
Import-Module -Name modern-unix-win
Import-Module -Name PSFzf

Set-PSReadlineOption –HistorySavePath ~\History.txt
Set-PsFzfOption -PSReadlineChordProvider 'Ctrl+t' -PSReadlineChordReverseHistory 'Ctrl+r'

function which ($command) {
   Get-Command -Name $command -ErrorAction SilentlyContinue | 
   Select-Object -ExpandProperty Path -ErrorAction SilentlyContinue
}
