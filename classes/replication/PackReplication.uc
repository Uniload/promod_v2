class PackReplication extends Engine.Actor config(promod_v2);

var config float repair_rechargeTimeSeconds;
var config float repair_rampUpTimeSeconds;
var config float repair_deactivatingDuration;
var config float repair_durationSeconds;
var config StaticMesh repair_thirdPersonMesh;
var config float repair_activePeriod;
var config float repair_passivePeriod;
var config float repair_radius;

var config float repair_activeHealthPerPeriod;
var config float repair_activeExtraSelfHealthPerPeriod;
var config float repair_passiveHealthPerPeriod;
var config float repair_accumulationScale;

replication
{
    reliable if (Role == ROLE_Authority)
        repair_rechargeTimeSeconds, repair_rampUpTimeSeconds,
        repair_deactivatingDuration, repair_durationSeconds,
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

/**
 * Corrupts game cache prohibiting the user to join another server
 */
simulated event PostNetReceive()
{
    super.PostNetReceive();
    log("YES BABY PACK REPLICATION");
    class'EquipmentClasses.PackRepair'.default.rechargeTimeSeconds = repair_rechargeTimeSeconds;
    class'EquipmentClasses.PackRepair'.default.rampUpTimeSeconds = repair_rampUpTimeSeconds;
    class'EquipmentClasses.PackRepair'.default.deactivatingDuration = repair_deactivatingDuration;
    class'EquipmentClasses.PackRepair'.default.durationSeconds = repair_durationSeconds;
    class'EquipmentClasses.PackRepair'.default.thirdPersonMesh = repair_thirdPersonMesh;
    class'EquipmentClasses.PackRepair'.default.activePeriod = repair_activePeriod;
    class'EquipmentClasses.PackRepair'.default.passivePeriod = repair_passivePeriod;
    class'EquipmentClasses.PackRepair'.default.radius = repair_radius;
}

defaultproperties
{
    repair_rechargeTimeSeconds  =       12.000000
    repair_rampUpTimeSeconds    =       0.250000
    repair_deactivatingDuration =       0.250000
    repair_durationSeconds      =       15.000000
    repair_thirdPersonMesh      =       StaticMesh'packs.RepairPack'
    repair_activePeriod         =       1.000000
    repair_passivePeriod        =       1.000000
    repair_radius               =       1500
    repair_activeHealthPerPeriod=       13.000000
    repair_activeExtraSelfHealthPerPeriod=1.750000
    repair_passiveHealthPerPeriod=      1.750000
    repair_accumulationScale    =       1.000000

    bNetNotify                  =       True
    NetUpdateFrequency          =       1
    bStatic                     =       False
    bNoDelete                   =       False
    bAlwaysRelevant             =       True
    netPriority                 =       1
}
