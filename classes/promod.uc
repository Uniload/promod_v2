class promod extends Gameplay.Mutator config(promod_v2) dependsOn(Armor);

const VERSION = "0.0.1";
const MOD_NAME = "promod_v2";

var(Promod) config bool allowCommands;
var(Promod) private bool trocIsOn;
var(Promod) config Array<class<Actor> > DisabledActors;

var(Vehicles) config bool enableFighterPod, enableRover, enableAssaultShip, enableJumpTank;
var(Vehicles) config bool enableRoverGun;

var(BaseDevices) config bool disableBaseRape;
var(BaseDevices) config Array<class<BaseDevice> > BaseRapeProtectedDevices;

var(Player) config class<Gameplay.CombatRole> spawnCombatRole;
var(Player) config float spawnInvincibleDelay;
var(Player) config float heavyKnockbackScale;
var(Player) config int heavyHealth;

// TODO Knife point-blank no dmg fix
var private ClientReplication crInstance;
var private PackReplication prInstance;

replication
{
    //reliable if(Role == ROLE_Authority && (bNetDirty || bNetInitial))
      // ========================= Globals =========================
      reliable if (bNetInitial)
      // Spawn
      crInstance, prInstance

      // ========================= Globals =========================
    ;
}

static function Name getLogName()
{
    return Name("promod_v2");
}

/* @Override */
simulated event PreBeginPlay()
{
    Super.PreBeginPlay();

    ExecuteModifications();
    crInstance = spawn(class'ClientReplication');
    prInstance = spawn(class'PackReplication');
}

/* @Override
event string MutateSpawnLoadoutClass(Character c)
{
    return Super.MutateSpawnLoadoutClass(c);
}
*/

/* @Override */
event string MutateSpawnCombatRoleClass(Character c)
{
    Super.MutateSpawnCombatRoleClass(c);

  //TODO default weapons / ammo per armorClass
    c.team().combatRoleData[0].role.default.armorClass = class'ArmorLight';
    c.team().combatRoleData[1].role.default.armorClass = class'ArmorMedium';
    c.team().combatRoleData[2].role.default.armorClass = class'ArmorHeavy';

    c.team().combatRoleData[2].role.default.armorClass.default.knockbackScale = heavyKnockbackScale;
    c.team().combatRoleData[2].role.default.armorClass.default.health = heavyHealth;

    return "";
}

/* @Override
event MutatePlayerMeshes(out Mesh characterMesh, out class<Jetpack> jetpackClass, out Mesh armsMesh)
{
  Log(characterMesh);
    Super.MutatePlayerMeshes(characterMesh, jetpackClass, armsMesh);
}
*/

/* @Override
 * Does not run on client ever!
 */
event Actor ReplaceActor(Actor other)
{
    switch (true) {
        case other.IsA('RepairPack'):
            RepairPack(other).activePeriod = prInstance.repair_activePeriod;
            RepairPack(other).passivePeriod = prInstance.repair_passivePeriod;
            RepairPack(other).radius = prInstance.repair_radius;
            RepairPack(other).deactivatingDuration = prInstance.repair_deactivatingDuration;
            RepairPack(other).durationSeconds = prInstance.repair_durationSeconds;
            RepairPack(other).rampUpTimeSeconds = prInstance.repair_rampUpTimeSeconds;
            RepairPack(other).rechargeTimeSeconds = prInstance.repair_rechargeTimeSeconds;
            RepairPack(other).activeHealthPerPeriod = prInstance.repair_activeHealthPerPeriod;
            RepairPack(other).activeExtraSelfHealthPerPeriod = prInstance.repair_activeExtraSelfHealthPerPeriod;
            RepairPack(other).passiveHealthPerPeriod = prInstance.repair_passiveHealthPerPeriod;
            RepairPack(other).accumulationScale = prInstance.repair_accumulationScale;
            return Super.ReplaceActor(other);

        case other.IsA('EnergyPack'):
            EnergyPack(other).deactivatingDuration = prInstance.energy_deactivatingDuration;
            EnergyPack(other).durationSeconds = prInstance.energy_durationSeconds;
            EnergyPack(other).rampUpTimeSeconds = prInstance.energy_rampUpTimeSeconds;
            EnergyPack(other).rechargeTimeSeconds = prInstance.energy_rechargeTimeSeconds;
            EnergyPack(other).boostImpulsePerSecond = prInstance.energy_boostImpulsePerSecond;
            EnergyPack(other).rechargeScale = prInstance.energy_rechargeScale;
            return Super.ReplaceActor(other);

        case other.IsA('ShieldPack'):
            ShieldPack(other).deactivatingDuration = prInstance.shield_deactivatingDuration;
            ShieldPack(other).durationSeconds = prInstance.shield_durationSeconds;
            ShieldPack(other).rampUpTimeSeconds = prInstance.shield_rampUpTimeSeconds;
            ShieldPack(other).rechargeTimeSeconds = prInstance.shield_rechargeTimeSeconds;
            ShieldPack(other).passiveFractionDamageBlocked = prInstance.shield_passiveFractionDamageBlocked;
            ShieldPack(other).activeFractionDamageBlocked = prInstance.shield_activeFractionDamageBlocked;
            ShieldPack(other).passiveIdleMaterial = prInstance.shield_passiveIdleMaterial;
            ShieldPack(other).activeIdleMaterial = prInstance.shield_activeIdleMaterial;
            ShieldPack(other).passiveHitMaterial = prInstance.shield_passiveHitMaterial;
            ShieldPack(other).activeHitMaterial = prInstance.shield_activeHitMaterial;
            ShieldPack(other).hitStayTime = prInstance.shield_hitStayTime;
            return Super.ReplaceActor(other);

        case other.IsA('SpeedPack'):
            SpeedPack(other).deactivatingDuration = prInstance.speed_deactivatingDuration;
            SpeedPack(other).durationSeconds = prInstance.speed_durationSeconds;
            SpeedPack(other).rampUpTimeSeconds = prInstance.speed_rampUpTimeSeconds;
            SpeedPack(other).rechargeTimeSeconds = prInstance.speed_rechargeTimeSeconds;
            SpeedPack(other).refireRateScale = prInstance.speed_refireRateScale;
            SpeedPack(other).passiveRefireRateScale = prInstance.speed_passiveRefireRateScale;
            SpeedPack(other).passiveMaterial = prInstance.speed_passiveMaterial;
            SpeedPack(other).activeMaterial = prInstance.speed_activeMaterial;
            return Super.ReplaceActor(other);

        default:
            return Super.ReplaceActor(other);
    }
}

/* @Override */
simulated event Mutate(string command, PlayerController sender)
{
    local string ParsedString;

    //if (!allowCommands || !sender.AdminManager.bAdmin) return;

    if (command ~= "reload") {
        LoadConfigVariables();
    }
    else if (command ~= "troc") {
        if (trocIsOn)
        {
            trocIsOn = false;
        }
        else
        {
            trocIsOn = true;
        }
    }
    else if (command ~= "baseRape") {
        disableBaseRape = !disableBaseRape;
        ModifyBaseDevices(disableBaseRape);
    }
}

simulated function LoadConfigVariables()
{
    Log("Loading config variables...", class'promod'.static.getLogName());
    Log("config variables loading completed.", class'promod'.static.getLogName());
}

simulated function ExecuteModifications()
{
    Log("ExecuteModifications start", class'promod'.static.getLogName());
    LoadConfigVariables();

    ModifyVehicles();
    ModifyMultiplayerStart();
    ModifyFlagThrower();
    ModifyCharacters();

    DestroyDisabledActors();

    if (disableBaseRape)
        ModifyBaseDevices();
    Log("ExecuteModifications end", class'promod'.static.getLogName());
}

function ModifyVehicles()
{
    local Gameplay.VehicleSpawnPoint pad;

    foreach AllActors(class'Gameplay.VehicleSpawnPoint', pad)
    {
        switch (pad.vehicleClass) {

            case class'VehicleClasses.VehiclePod':
                if (enableFighterPod)
                    pad.vehicleClass = class'FighterPod';
                else pad.setSwitchedOn(false);
                break;

            case class'VehicleClasses.VehicleBuggy':
                if (enableRover) {
                    if (enableRoverGun)
                        pad.vehicleClass = class'RoverBuggyGun';
                    else pad.vehicleClass = class'RoverBuggy';
                } else pad.setSwitchedOn(false);
                break;

            case class'VehicleClasses.VehicleAssaultShip':
                if (enableAssaultShip)
                    pad.vehicleClass = class'AssaultShip';
                else pad.setSwitchedOn(false);
                break;

            case class'VehicleClasses.VehicleTank':
                if (enableJumpTank)
                    pad.vehicleClass = class'JumpTank';
                else pad.setSwitchedOn(false);
                break;
        }
    }
}

function ModifyMultiplayerStart()
{
    local Gameplay.MultiplayerStart MPstart;

    foreach AllActors(class'Gameplay.MultiplayerStart', MPstart)
    {
        MPstart.combatRole = spawnCombatRole;
        MPstart.invincibleDelay  = spawnInvincibleDelay;
    }
}

function ModifyFlagThrower()
{
    local GameClasses.CaptureFlagImperial ImpFlag;
    local GameClasses.CaptureFlagBeagle BEFlag;
    local GameClasses.CaptureFlagPhoenix PnxFlag;

    foreach AllActors(class'GameClasses.CaptureFlagImperial', ImpFlag)
        ImpFlag.carriedObjectClass = class'FlagThrowerImperial';

    foreach AllActors(class'GameClasses.CaptureFlagBeagle', BEFlag)
        BEFlag.carriedObjectClass = class'FlagThrowerBeagle';

    foreach AllActors(class'GameClasses.CaptureFlagPhoenix', PnxFlag)
        PnxFlag.carriedObjectClass = class'FlagThrowerPhoenix';
}

function ModifyCharacters()
{
    Level.Game.Default.DefaultPlayerClassName = MOD_NAME $ ".MultiplayerCharacter";
    Level.Game.DefaultPlayerClassName = MOD_NAME $ ".MultiplayerCharacter";
}

function DestroyDisabledActors()
{
    local Actor actor;
    local int i;

    for (i=0; i < DisabledActors.Length; ++i) {
        foreach ChildActors(DisabledActors[i], actor)
            actor.Destroy();

        foreach AllActors(DisabledActors[i], actor)
            actor.Destroy();
    }
}

function ModifyBaseDevices(optional bool canBeDamaged)
{
    local BaseDevice device;
    local int i;

    foreach AllActors(class'BaseDevice', device)
        for (i=0; i < BaseRapeProtectedDevices.Length; ++i)
            if(device.IsA(BaseRapeProtectedDevices[i].Name) || Left(device.Name, 8) == "catapult")
                device.bCanBeDamaged = canBeDamaged;
}

function ModifyInventoryStations()
{
    local InventoryStation is;

    foreach AllActors(class'InventoryStation', is)
    {
        // TODO fix inventory invalid armor bug
        log(is, class'promod'.static.getLogName());
        is.accessClass = class'InventoryStationAccess';
    }
}

defaultproperties
{
    Role=ROLE_Authority
    bNetNotify=true
    bAlwaysRelevant=false
    bOnlyDirtyReplication=false
    NetUpdateFrequency=1
    netPriority=20

    allowCommands=true
    trocIsOn=false

    enableFighterPod=true
    enableRover=true
    enableRoverGun=true
    enableAssaultShip=true
    enableJumpTank=true

    disableBaseRape=true

    crInstance=None

    BaseRapeProtectedDevices(0)=class'BaseObjectClasses.BaseCatapult'
    BaseRapeProtectedDevices(1)=class'BaseObjectClasses.BaseDeployableSpawn'
    BaseRapeProtectedDevices(2)=class'BaseObjectClasses.BaseInventoryStation'
    BaseRapeProtectedDevices(3)=class'BaseObjectClasses.BasePowerGenerator'
    BaseRapeProtectedDevices(4)=class'BaseObjectClasses.BaseResupply'
    BaseRapeProtectedDevices(5)=class'BaseObjectClasses.BaseSensor'
    BaseRapeProtectedDevices(6)=class'BaseObjectClasses.BaseTurret'

    DisabledActors(0)=class'BaseObjectClasses.BaseDeployableSpawnTurret'
    DisabledActors(1)=class'BaseObjectClasses.BaseTurret'
    DisabledActors(2)=class'BaseObjectClasses.StaticMeshRemovable'
    DisabledActors(3)=class'BaseObjectClasses.BaseDeployableSpawnShockMine'

    spawnCombatRole=class'EquipmentClasses.CombatRoleLight'
    spawnInvincibleDelay=2.500000
    heavyKnockbackScale=1.000000
    heavyHealth=195

    FriendlyName="promod_v2"
    Description="Mutator code: promod_v2.promod"
}
