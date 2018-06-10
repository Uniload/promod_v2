class promod extends Gameplay.Mutator config(promod_v2) dependsOn(Armor);

const VERSION = "0.0.1";
const MOD_NAME = "promod_v2";

var(Promod) config bool allowCommands;
var(Promod) private bool trocIsOn;

var(Vehicles) config bool enableFighterPod, enableRover, enableAssaultShip, enableJumpTank;
var(Vehicles) config bool enableRoverGun;

var(BaseDevices) config bool disableBaseTurrets, disableDeployableMines, disableDeployableTurrets;
var(BaseDevices) config bool disableBaseRape;
var(BaseDevices) config Array<class<BaseDevice> > BaseRapeProtectedDevices;

var(Player) config class<Gameplay.CombatRole> spawnCombatRole;
var(Player) config float spawnInvincibleDelay;
var(Player) config float heavyKnockbackScale;
var(Player) config int heavyHealth;

/* @Override */
event PreBeginPlay()
{
  Super.PreBeginPlay();

  LoadConfigVariables();

  ModifyVehicles();
  ModifyMultiplayerStart();
  ModifyFlagThrower();
  ModifyCharacters();
  if (disableBaseTurrets)
    RemoveBaseTurrets();
  if (disableDeployableMines)
    removeDeployableMines();
  if (disableDeployableTurrets)
    removeDeployableTurrets();
  if (disableBaseRape)
    ModifyBaseDevices();
}

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

function RemoveBaseTurrets()
{
  local BaseObjectClasses.BaseTurret turret;
  local BaseObjectClasses.StaticMeshRemovable turretBase;

  foreach AllActors(class'BaseObjectClasses.BaseTurret', turret)
      turret.Destroy();

  foreach AllActors(class'BaseObjectClasses.StaticMeshRemovable', turretBase)
      turretBase.Destroy();
}

function RemoveDeployableMines()
{
  local BaseObjectClasses.BaseDeployableSpawnTurret turretDispenser;

  foreach AllActors(class'BaseObjectClasses.BaseDeployableSpawnTurret', turretDispenser)
    turretDispenser.Destroy();
}

function RemoveDeployableTurrets()
{
  local BaseObjectClasses.BaseDeployableSpawnShockMine mineDispenser;

  foreach AllActors(class'BaseObjectClasses.BaseDeployableSpawnShockMine', mineDispenser)
    mineDispenser.Destroy();
}

function ModifyBaseDevices(optional bool canBeDamaged)
{
  local BaseDevice device;
  local int i;

  Foreach AllActors(class'BaseDevice', device)
    for (i=0; i < BaseRapeProtectedDevices.Length; ++i)
      if(device.IsA(BaseRapeProtectedDevices[i].Name))
			   device.bCanBeDamaged = canBeDamaged;
}

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
  disableBaseTurrets=true
  disableDeployableMines=true
  disableDeployableTurrets=true

  BaseRapeProtectedDevices(1)=class'BaseObjectClasses.BaseCatapult'
  BaseRapeProtectedDevices(2)=class'BaseObjectClasses.BaseDeployableSpawn'
  BaseRapeProtectedDevices(3)=class'BaseObjectClasses.BaseInventoryStation'
  BaseRapeProtectedDevices(4)=class'BaseObjectClasses.BasePowerGenerator'
  BaseRapeProtectedDevices(5)=class'BaseObjectClasses.BaseResupply'
  BaseRapeProtectedDevices(6)=class'BaseObjectClasses.BaseSensor'
  BaseRapeProtectedDevices(7)=class'BaseObjectClasses.BaseTurret'
  BaseRapeProtectedDevices(8)=class'myLevel.catapults'

  spawnCombatRole=class'EquipmentClasses.CombatRoleLight'
  spawnInvincibleDelay=2.500000
  heavyKnockbackScale=1.000000
  heavyHealth=195

  FriendlyName="promod_v2"
  Description="Mutator code: promod_v2.promod"
}
