$dataTable = Data {
    ConvertFrom-StringData @'
        thisRev=1
        LRMM_NetworksPath=\\\\scotia.sgngroup.net\\dfs\\shared\\Syn4.2.3\\TEST AREA\\ac00418\\LRMM17\\data\\LRMM_Networks.csv
'@}
function LRMM_Find-TotalLength
{

    $networks = Import-Csv $dataTable.LRMM_NetworksPath

    foreach ( $n in $networks )
    {
        Write-Host "$($n.NUMBER)"
        try
        {
            $pipes = Import-Csv $n.PipeFileA
            $networkLength = LRMM_Get-TotalLength -pipes $pipes

            $n.PipeLength = $networkLength

            Write-Host "Network $($n.NUMBER) is $($networkLength) m"
        }
        Catch
        {
            Write-Host "Unable to import pipes for $($n.NUMBER)"
            continue
        }
    }

    $networks | Export-Csv $dataTable.LRMM_NetworksPath -NoTypeInformation
}