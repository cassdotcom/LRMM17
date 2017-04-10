
function LRMM_Generate-INI
{

$lrmmNetworks = Import-Csv "\\scotia.sgngroup.net\dfs\shared\Syn4.2.3\TEST AREA\ac00418\LRMM17\data\LRMM_Networks.csv"
$lrmmLOG = "\\scotia.sgngroup.net\dfs\shared\Syn4.2.3\TEST AREA\ac00418\LRMM17\logs\LRMM_Log.txt"

for ( $i=1; $i -lt 24; $i++ ) {

    Write-Host "$($i)"

    $modelGroup = $lrmmNetworks | where { $_.LRMMRun -eq $i }

    $modelCount = $modelGroup.Count

    $iniLine = @()
    $iniLine2 = @()
    $iniLine3 = @()

    $modelNo = 1
    foreach ( $n in $modelGroup ) {

        # Models in
        $iniLine += "Model$($modelNo)=$($n.FY1)"
        # Model Names
        $iniLine2 += "ModelName$($modelNo)=$($n.TITLE)"
        # Models out
        $modelOutName = (Split-Path $n.FY1 -Leaf).Replace(".MDB","_ASP.MDB")

        $iniLine3 += "ModelOut$($modelNo)=\\scotia.sgngroup.net\dfs\shared\Syn4.2.3\TEST AREA\ac00418\LRMM17\modelsOut\$($modelOutName)"

        $modelNo++
    }

    $outFile = "\\scotia.sgngroup.net\dfs\shared\Syn4.2.3\TEST AREA\ac00418\LRMM17\data\LRMM_A" + $i + ".ini"


    # =====================================================================================================

    $header = @"
    [LOGS]
    script_log_synergee=\\scotia.sgngroup.net\dfs\shared\Syn4.2.3\TEST AREA\ac00418\LRMM17\logs\script_log_synergee_$i
    analysis_log=\\scotia.sgngroup.net\dfs\shared\Syn4.2.3\TEST AREA\ac00418\LRMM17\logs\analysis_log_$i
    script_log=\\scotia.sgngroup.net\dfs\shared\Syn4.2.3\TEST AREA\ac00418\LRMM17\logs\script_log_$i
    validation_log=\\scotia.sgngroup.net\dfs\shared\Syn4.2.3\TEST AREA\ac00418\LRMM17\logs\validation_log_$i
    data_import_log=\\scotia.sgngroup.net\dfs\shared\Syn4.2.3\TEST AREA\ac00418\LRMM17\logs\data_import_log_$i
    data_export_log=\\scotia.sgngroup.net\dfs\shared\Syn4.2.3\TEST AREA\ac00418\LRMM17\logs\data_export_log_$i
    general_log=\\scotia.sgngroup.net\dfs\shared\Syn4.2.3\TEST AREA\ac00418\LRMM17\logs\general_log_$i


    [SUPPLEMENTS]
    workspace=\\sgn\dfs\shared\Syn4.7.1\UsersWorkspaces\ac00418_471\WorkspaceDefaultG.ws.mdb
    warehouse=\\sgn\dfs\shared\Syn4.7.1\UsersWorkspaces\ac00418_471\WarehouseDefaultG.wh.mdb


    [EXCHANGE]
    exchangeFlowCategoriesFile=
    LRMMProfiles=\\scotia.sgngroup.net\dfs\shared\Syn4.2.3\TEST AREA\ac00418\LRMM17\exchange\LRMMProfiles.csv
    LRMMProfilesSettings=\\scotia.sgngroup.net\dfs\shared\Syn4.2.3\TEST AREA\ac00418\LRMM17\settings\ExchangeProfiles.ini
    LRMMProfilesWorksheet="LRMMProfiles"
    LRMMProfilesPointsSettings=\\scotia.sgngroup.net\dfs\shared\Syn4.2.3\TEST AREA\ac00418\LRMM17\settings\ExchangeProfilePoints.ini
    ExportNodesSettings=\\scotia.sgngroup.net\dfs\shared\Syn4.2.3\TEST AREA\ac00418\LRMM17\settings\ExportNodes.ini
    ExportMainsSettings=\\scotia.sgngroup.net\dfs\shared\Syn4.2.3\TEST AREA\ac00418\LRMM17\settings\ExportMains.ini
    ExportFlowsSettings=\\scotia.sgngroup.net\dfs\shared\Syn4.2.3\TEST AREA\ac00418\LRMM17\settings\ExportFlows.ini
    exchangeFilePath=\\scotia.sgngroup.net\dfs\shared\Syn4.2.3\TEST AREA\ac00418\LRMM17\output\
    ImportPotsOff=\\scotia.sgngroup.net\dfs\shared\Syn4.2.3\TEST AREA\ac00418\LRMM17\exchange\LRMMPotsOff.csv
    ImportPotsOffSettings=\\scotia.sgngroup.net\dfs\shared\Syn4.2.3\TEST AREA\ac00418\LRMM17\settings\ImportPotsOff.ini
    ImportPotsOffWorksheet="LRMMPotsOff"


    [MODELDATA]
    number_of_models=$modelCount
    start_at=1

    [MODELNAMES]
"@
    
    $header | Out-File $outFile

    $iniLine | Out-File $outFile -Append
    " " | Out-File $outFile -Append
    "[MODELSIN]" | Out-File $outFile -Append
    $iniLine2 | Out-File $outFile -Append
    " " | Out-File $outFile -Append
    "[MODELSOUT]" | Out-File $outFile -Append
    $iniLine3 | Out-File $outFile -Append

}

}