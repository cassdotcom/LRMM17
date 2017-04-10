function LRMM_Get-PipeOutFile
{

    $lrmmNetworks = Import-Csv "\\scotia.sgngroup.net\dfs\shared\Syn4.2.3\TEST AREA\ac00418\LRMM17\data\LRMM_Networks.csv"

    
    foreach ( $n in $lrmmNetworks )
    {
        $pipesOutFile = "\\scotia.sgngroup.net\dfs\shared\Syn4.2.3\TEST AREA\ac00418\LRMM17\processed\" + $n.TITLE + "_Mains_Proc.csv"
        
        if ( ! ( Test-Path $pipesOutFile ) )
        {
            Write-Host "MISSING $($n.TITLE)" -ForegroundColor Yellow -BackgroundColor Black
            $n.ProcessedPipeFile = $pipesOutFile
        }
        else
        {
            $n.ProcessedPipeFile = $pipesOutFile
        }
    }

    $lrmmNetworks | Export-Csv "\\scotia.sgngroup.net\dfs\shared\Syn4.2.3\TEST AREA\ac00418\LRMM17\data\LRMM_Networks.csv" -NoTypeInformation
}