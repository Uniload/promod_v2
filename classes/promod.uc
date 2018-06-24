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

// ========================= Weapons =========================

// Chaingun
var(Weapons) config float weaponChaingun_minSpread, weaponChaingun_maxSpread, weaponChaingun_spinPeriod,
                          weaponChaingun_heatPeriod, weaponChaingun_coolDownThreshold,
                          weaponChaingun_speedCooldownFactor, weaponChaingun_projectileVelocity, weaponChaingun_projectileInheritedVelFactor,
                          weaponChaingun_roundsPerSecond, projectileChaingun_damageAmt, projectileChaingun_Knockback;

// ========================= Weapons =========================


replication
{
    // ========================= Weapons =========================

    // Chaingun
    if(Role == ROLE_Authority && (bNetDirty || bNetInitial))
      weaponChaingun_minSpread, weaponChaingun_maxSpread, weaponChaingun_spinPeriod,
      weaponChaingun_heatPeriod, weaponChaingun_coolDownThreshold,
      weaponChaingun_speedCooldownFactor, weaponChaingun_projectileVelocity, weaponChaingun_projectileInheritedVelFactor,
      weaponChaingun_roundsPerSecond, projectileChaingun_damageAmt, projectileChaingun_Knockback;

    // ========================= Weapons =========================
}

// TODO Knife point-blank no dmg fix

/* @Override */
event PreBeginPlay()
{
  Super.PreBeginPlay();

  LoadConfigVariables();

  ModifyWeapons();
  ModifyVehicles();
  ModifyMultiplayerStart();
  ModifyFlagThrower();
  ModifyCharacters();

  DestroyDisabledActors();

  if (disableBaseRape)
    ModifyBaseDevices();

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

/* @Override */
event Actor ReplaceActor(Actor other)
{
  if (other.IsA('WeaponHandGrenade')) {
    return Super.ReplaceActor(other);
  }
  return Super.ReplaceActor(other);
}

/* @Override */
simulated event Mutate(string command, PlayerController sender)
{
  local string ParsedString;

  if (!allowCommands || !sender.AdminManager.bAdmin) return;

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
  Log("Loading config variables...");



  Log("config variables loading completed.");
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
    log(is);
    is.accessClass = class'InventoryStationAccess';
  }
}


// ========================= Weapons =========================
function ModifyWeapons()
{
  ModifyChaingun();
}

function ModifyChaingun()
{
  class'EquipmentClasses.WeaponChaingun'.default.minSpread = weaponChaingun_minSpread;
  class'EquipmentClasses.WeaponChaingun'.default.maxSpread = weaponChaingun_maxSpread;
  class'EquipmentClasses.WeaponChaingun'.default.spinPeriod = weaponChaingun_spinPeriod;
  class'EquipmentClasses.WeaponChaingun'.default.heatPeriod = weaponChaingun_heatPeriod;
  class'EquipmentClasses.WeaponChaingun'.default.coolDownThreshold = weaponChaingun_coolDownThreshold;
  class'EquipmentClasses.WeaponChaingun'.default.speedCooldownFactor = weaponChaingun_speedCooldownFactor;
  class'EquipmentClasses.WeaponChaingun'.default.projectileVelocity = weaponChaingun_projectileVelocity;
  class'EquipmentClasses.WeaponChaingun'.default.projectileInheritedVelFactor = weaponChaingun_projectileInheritedVelFactor;
  class'EquipmentClasses.WeaponChaingun'.default.roundsPerSecond = weaponChaingun_roundsPerSecond;

  class'EquipmentClasses.ChaingunProjectile'.default.damageAmt = projectileChaingun_damageAmt;
  class'EquipmentClasses.ChaingunProjectile'.default.Knockback = projectileChaingun_Knockback;
}
// ========================= Weapons =========================

defaultproperties
{
  allowCommands=true
  trocIsOn=false

  enableFighterPod=true
  enableRover=true
  enableRoverGun=true
  enableAssaultShip=true
  enableJumpTank=true

  disableBaseRape=true

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

  // ========================= Weapons =========================

  // Chaingun
  weaponChaingun_minSpread=1.000000
  weaponChaingun_maxSpread=4.000000
  weaponChaingun_spinPeriod=0.500000
  weaponChaingun_heatPeriod=3.000000
  weaponChaingun_coolDownThreshold=1.700000
  weaponChaingun_speedCooldownFactor=0.000800
  weaponChaingun_projectileVelocity=5500.000000
  weaponChaingun_projectileInheritedVelFactor=1.000000
  weaponChaingun_roundsPerSecond=12.000000

  projectileChaingun_damageAmt=6.000000
  projectileChaingun_Knockback=25000.000000
  // ========================= Weapons =========================
}
