
$lrmmNetworksPath = "\\scotia.sgngroup.net\dfs\shared\Syn4.2.3\TEST AREA\ac00418\LRMM17\data\LRMM_Networks.csv"


$lrmmNetworks = Import-Csv $lrmmNetworksPath

foreach ( $n in $lrmmNetworks ) 
{

    Write-Host "Processing $($n.NUMBER)"

    $A_ini = "\\scotia.sgngroup.net\dfs\shared\Syn4.2.3\TEST AREA\ac00418\LRMM17\settings\LRMM_A" + $n.LRMMRun + ".ini"
    $PipeFileA = "\\scotia.sgngroup.net\dfs\shared\Syn4.2.3\TEST AREA\ac00418\LRMM17\output\" + $n.TITLE + "_Mains.csv"
    $NodeFileA = "\\scotia.sgngroup.net\dfs\shared\Syn4.2.3\TEST AREA\ac00418\LRMM17\output\" + $n.TITLE + "_Nodes.csv"
    $FlowFileA = "\\scotia.sgngroup.net\dfs\shared\Syn4.2.3\TEST AREA\ac00418\LRMM17\output\" + $n.TITLE + "_Flows.csv"
    $ModelOutA = (Split-Path $n.FY1 -Leaf).Replace(".MDB","_ASP.MDB")

    $n | Add-Member -MemberType NoteProperty -Name "A_ini" -Value $A_ini
    $n | Add-Member -MemberType NoteProperty -Name "PipeFileA" -Value $PipeFileA
    $n | Add-Member -MemberType NoteProperty -Name "NodeFileA" -Value $NodeFileA
    $n | Add-Member -MemberType NoteProperty -Name "FlowFileA" -Value $FlowFileA
    $n | Add-Member -MemberType NoteProperty -Name "ModelOutA" -Value $ModelOutA

}

$lrmmNetworks | Export-Csv $lrmmNetworksPath -NoTypeInformation