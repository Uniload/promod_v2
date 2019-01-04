class PackReplication extends Engine.Actor config(promod_v2);

// repair
var config float repair_rechargeTimeSeconds;
var config float repair_rampUpTimeSeconds;
var config float repair_deactivatingDuration;
var config float repair_durationSeconds;
var config float repair_activePeriod;
var config float repair_passivePeriod;
var config float repair_radius;
var config float repair_activeHealthPerPeriod;
var config float repair_activeExtraSelfHealthPerPeriod;
var config float repair_passiveHealthPerPeriod;
var config float repair_accumulationScale;
// energy
var config float energy_rechargeTimeSeconds;
var config float energy_rampUpTimeSeconds;
var config float energy_deactivatingDuration;
var config float energy_durationSeconds;
var config float energy_boostImpulsePerSecond;
var config float energy_rechargeScale;
// shield
var config float shield_rechargeTimeSeconds;
var config float shield_rampUpTimeSeconds;
var config float shield_deactivatingDuration;
var config float shield_durationSeconds;
var config float shield_passiveFractionDamageBlocked;
var config float shield_activeFractionDamageBlocked;
var config Material shield_passiveIdleMaterial;
var config Material shield_activeIdleMaterial;
var config Material shield_passiveHitMaterial;
var config Material shield_activeHitMaterial;
var config float shield_hitStayTime;
// speed
var config float speed_rechargeTimeSeconds;
var config float speed_rampUpTimeSeconds;
var config float speed_deactivatingDuration;
var config float speed_durationSeconds;
var config float speed_refireRateScale;
var config float speed_passiveRefireRateScale;
var config Material speed_passiveMaterial;
var config Material speed_activeMaterial;

replication
{
    reliable if (Role == ROLE_Authority)
        repair_rechargeTimeSeconds, repair_rampUpTimeSeconds,
        repair_deactivatingDuration, repair_durationSeconds,
        repair_activePeriod, repair_passivePeriod, repair_radius,

        energy_rechargeTimeSeconds, energy_rampUpTimeSeconds,
        energy_deactivatingDuration, energy_durationSeconds,

        shield_rechargeTimeSeconds, shield_rampUpTimeSeconds,
        shield_deactivatingDuration, shield_durationSeconds,
        shield_passiveIdleMaterial, shield_activeIdleMaterial,
        shield_passiveHitMaterial, shield_activeHitMaterial,

        speed_rechargeTimeSeconds, speed_rampUpTimeSeconds,
        speed_deactivatingDuration, speed_durationSeconds,
        speed_refireRateScale, speed_passiveRefireRateScale,
        speed_passiveMaterial, speed_activeMaterial

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
    log("pack properties replication", class'promod'.static.getLogName());
    class'EquipmentClasses.PackRepair'.default.rechargeTimeSeconds = repair_rechargeTimeSeconds;
    class'EquipmentClasses.PackRepair'.default.rampUpTimeSeconds = repair_rampUpTimeSeconds;
    class'EquipmentClasses.PackRepair'.default.deactivatingDuration = repair_deactivatingDuration;
    class'EquipmentClasses.PackRepair'.default.durationSeconds = repair_durationSeconds;
    class'EquipmentClasses.PackRepair'.default.activePeriod = repair_activePeriod;
    class'EquipmentClasses.PackRepair'.default.passivePeriod = repair_passivePeriod;
    class'EquipmentClasses.PackRepair'.default.radius = repair_radius;

    class'EquipmentClasses.PackEnergy'.default.rechargeTimeSeconds = energy_rechargeTimeSeconds;
    class'EquipmentClasses.PackEnergy'.default.rampUpTimeSeconds = energy_rampUpTimeSeconds;
    class'EquipmentClasses.PackEnergy'.default.deactivatingDuration = energy_deactivatingDuration;
    class'EquipmentClasses.PackEnergy'.default.durationSeconds = energy_durationSeconds;

    class'EquipmentClasses.PackShield'.default.rechargeTimeSeconds = shield_rechargeTimeSeconds;
    class'EquipmentClasses.PackShield'.default.rampUpTimeSeconds = shield_rampUpTimeSeconds;
    class'EquipmentClasses.PackShield'.default.deactivatingDuration = shield_deactivatingDuration;
    class'EquipmentClasses.PackShield'.default.durationSeconds = shield_durationSeconds;
    class'EquipmentClasses.PackShield'.default.passiveIdleMaterial = shield_passiveIdleMaterial;
    class'EquipmentClasses.PackShield'.default.activeIdleMaterial = shield_activeIdleMaterial;
    class'EquipmentClasses.PackShield'.default.passiveHitMaterial = shield_passiveHitMaterial;
    class'EquipmentClasses.PackShield'.default.activeHitMaterial = shield_activeHitMaterial;

    class'EquipmentClasses.PackSpeed'.default.rechargeTimeSeconds = speed_rechargeTimeSeconds;
    class'EquipmentClasses.PackSpeed'.default.rampUpTimeSeconds = speed_rampUpTimeSeconds;
    class'EquipmentClasses.PackSpeed'.default.deactivatingDuration = speed_deactivatingDuration;
    class'EquipmentClasses.PackSpeed'.default.durationSeconds = speed_durationSeconds;
    class'EquipmentClasses.PackSpeed'.default.refireRateScale = speed_refireRateScale;
    class'EquipmentClasses.PackSpeed'.default.passiveRefireRateScale = speed_passiveRefireRateScale;
    class'EquipmentClasses.PackSpeed'.default.passiveMaterial = speed_passiveMaterial;
    class'EquipmentClasses.PackSpeed'.default.activeMaterial = speed_activeMaterial;
}

defaultproperties
{
    repair_rechargeTimeSeconds  =       12.000000
    repair_rampUpTimeSeconds    =       0.250000
    repair_deactivatingDuration =       0.250000
    repair_durationSeconds      =       15.000000
    repair_activePeriod         =       1.000000
    repair_passivePeriod        =       1.000000
    repair_radius               =       1500
    repair_activeHealthPerPeriod=       13.000000
    repair_activeExtraSelfHealthPerPeriod=1.750000
    repair_passiveHealthPerPeriod=      1.750000
    repair_accumulationScale    =       1.000000

    energy_rechargeTimeSeconds  =       18.000000
    energy_rampUpTimeSeconds    =       0.250000
    energy_deactivatingDuration =       0.250000
    energy_durationSeconds      =       1.000000
    energy_boostImpulsePerSecond=       75000.000000
    energy_rechargeScale        =       1.155000

    shield_rechargeTimeSeconds  =       16.000000
    shield_rampUpTimeSeconds    =       0.250000
    shield_deactivatingDuration =       0.250000
    shield_durationSeconds      =       3.000000
    shield_passiveFractionDamageBlocked=0.200000
    shield_activeFractionDamageBlocked= 0.750000
    shield_passiveIdleMaterial  =       None
    shield_activeIdleMaterial   =       Shader'FX.ScreenShieldPackPassiveShader'
    shield_passiveHitMaterial   =       Shader'FX.ScreenShieldPackPassiveShader'
    shield_activeHitMaterial    =       Shader'FX.ScreenPackpassiveHitShader'
    shield_hitStayTime          =       0.500000

    speed_rechargeTimeSeconds   =       13.000000
    speed_rampUpTimeSeconds     =       0.250000
    speed_deactivatingDuration  =       0.250000
    speed_durationSeconds       =       2.000000
    speed_refireRateScale       =       1.800000
    speed_passiveRefireRateScale=       1.250000
    speed_passiveMaterial       =       None
    speed_activeMaterial        =       Shader'FX.BucklerShieldShadder'

    bNetNotify                  =       True
    NetUpdateFrequency          =       1
    bStatic                     =       False
    bNoDelete                   =       False
    bAlwaysRelevant             =       True
    netPriority                 =       1
}
