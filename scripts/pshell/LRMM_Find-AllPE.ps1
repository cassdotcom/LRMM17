$dataTable = Data {
    ConvertFrom-StringData @'
        thisRev=1
        minPercentPE=95
        LRMM_NetworksPath=\\\\scotia.sgngroup.net\\dfs\\shared\\Syn4.2.3\\TEST AREA\\ac00418\\LRMM17\\data\\LRMM_Networks.csv
'@}
function LRMM_Find-AllPE
{

    $networks = Import-Csv $dataTable.LRMM_NetworksPath

    foreach ( $n in $networks )
    {
        if ( $n.PipeLength -lt 1 )
        {
            Write-Host "missing data for $($n.NUMBER)"
        }
        else
        {
            $percentagePE = (($n.PELength / $n.PipeLength) * 100)
            Write-Host "Percentage PE is $($percentagePE)"

            if ( $percentagePE -ge $dataTable.minPercentPE )
            {
                Write-Host "$($n.NUMBER) is all PE"
                $n.AllPE = "Y"
            }
            else
            {
                $n.AllPE = "N"
            }
        }
    }

    $networks | Export-Csv $dataTable.LRMM_NetworksPath -NoTypeInformation

}
