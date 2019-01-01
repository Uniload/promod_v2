class PackReplication extends Engine.Actor config(promod_v2);

var config float repair_rechargeTimeSeconds;
var config float repair_rampUpTimeSeconds;
var config float repair_deactivationDuration;
var config float repair_durationSeconds;
var config StaticMesh repair_thirdPersonMesh;

var config float repair_activePeriod;
var config float repair_passivePeriod;
var config float repair_radius;

replication
{
    reliable if (Role == ROLE_Authority)
        repair_rechargeTimeSeconds, repair_rampUpTimeSeconds,
        repair_deactivationDuration, repair_durationSeconds,
        repair_thirdPersonMesh, repair_activePeriod,
        repair_passivePeriod, repair_radius

        ;
}

simulated event PostBeginPlay()
{
    if (Level.NetMode != NM_Client) {
        SaveConfig();
    }
}

simulated event PostNetReceive()
{
    super.PostNetReceive();
    log("YES BABY PACK REPLICATION");
    class'EquipmentClasses.PackRepair'.default.rechargeTimeSeconds = repair_rechargeTimeSeconds;
}

defaultproperties
{
    repair_rechargeTimeSeconds  =       12.000000
    repair_rampUpTimeSeconds    =       0.250000
    repair_deactivationDuration =       0.250000
    repair_durationSeconds      =       15.000000
    repair_thirdPersonMesh      =       StaticMesh'packs.RepairPack'
    repair_activePeriod         =       1.000000
    repair_passivePeriod        =       1.000000
    repair_radius               =       1500

    bNetNotify                  =       True
    NetUpdateFrequency          =       1
    bStatic                     =       False
    bNoDelete                   =       False
    bAlwaysRelevant             =       True
    netPriority                 =       1
}
