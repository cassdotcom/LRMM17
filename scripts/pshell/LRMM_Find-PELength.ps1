$dataTable = Data {
    ConvertFrom-StringData @'
        thisRev=1
        LRMM_NetworksPath=\\\\scotia.sgngroup.net\\dfs\\shared\\Syn4.2.3\\TEST AREA\\ac00418\\LRMM17\\data\\LRMM_Networks.csv
'@}
function LRMM_Find-PELength
{

    $networks = Import-Csv $dataTable.LRMM_NetworksPath

    foreach ( $n in $networks )
    {
        try
        {
            $pipes = Import-Csv $n.PipeFileA
            $PEPipes = $pipes | where { $_.PipeMaterial -match "PE" }
            $PELength = LRMM_Get-TotalLength -pipes $PEPipes

            $n.PELength = $PELength

            Write-Host "Network $($n.NUMBER) PE Length is $($PELength)m"
        }
        Catch
        {
            Write-Host "Unable to import pipes for $($n.NUMBER)"
            continue
        }
    }

    $networks | Export-Csv $dataTable.LRMM_NetworksPath -NoTypeInformation
}