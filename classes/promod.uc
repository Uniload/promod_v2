class promod extends Gameplay.Mutator config(promod_v2) dependsOn(Armor);

const VERSION = "0.0.1";
const MOD_NAME = "promod_v2";

var(Promod) config bool allowCommands;
private var(Promod) bool trocIsOn;

var(Vehicles) config bool enableFighterPod, enableRover, enableAssaultShip, enableJumpTank;
var(Vehicles) config bool enableRoverGun;

var(BaseDevices) config bool removeBaseTurrets, removeDeployableMines, removeDeployableTurrets;
var(BaseDevices) config bool disableBaseRape;
var(BaseDevices) config Array<class<BaseDevice>> BaseRapeProtectedDevices;

var(Player) config class<Gameplay.CombatRole> spawnCombatRole;
var(Player) config float spawnInvincibleDelay;
var(Player) config float heavyKnockbackScale;
var(Player) config int heavyHealth;

var(PlayerWeapons) config Array<Armor.QuantityWeapon> LightWeapons, MediumWeapons, HeavyWeapons;

/* @Override */
event PreBeginPlay()
{
  Super.PreBeginPlay();

  LoadConfigVariables();

  ModifyVehicles();
  ModifyMultiplayerStart();
  ModifyFlagThrower();
  ModifyCharacters();
  if (removeBaseTurrets)
    RemoveBaseTurrets();
  if (removeDeployableMines)
    removeDeployableMines();
  if (removeDeployableTurrets)
    removeDeployableTurrets();
  if (disableBaseRape)
    ModifyBaseDevices();
}

/* @Override */
event string MutateSpawnCombatRoleClass(Character c)
{
  Super.MutateSpawnCombatRoleClass(c);

  c.team().combatRoleData[2].role.default.armorClass.default.knockbackScale = heavyKnockbackScale;
	c.team().combatRoleData[2].role.default.armorClass.default.health = heavyHealth;

  c.team().combatRoleData[0].role.default.armorClass.default.AllowedWeapons = LightWeapons;
  c.team().combatRoleData[1].role.default.armorClass.default.AllowedWeapons = MediumWeapons;
  c.team().combatRoleData[2].role.default.armorClass.default.AllowedWeapons = HeavyWeapons;
  return "";
}

/* @Override */
event Actor ReplaceActor(Actor other)
{
  Super.ReplaceActor(other);
  return None;
}

/* @Override */
simulated event Mutate(string command, PlayerController sender)
{
  local string ParsedString;

  if (!allowCommands || !sender.AdminManager.bAdmin) return;

  if (command ~= "troc") {
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
  // check xStats SetStatSettings()
  // will require all the logic to be simulated
}

function ModifyVehicles()
{
  local Gameplay.VehicleSpawnPoint pad;
  local const class<Gameplay.Vehicle> FIGHTER_POD = class'VehicleClasses.VehiclePod';
  local const class<Gameplay.Vehicle> ROVER_BUGGY = class'VehicleClasses.VehicleBuggy';
  local const class<Gameplay.Vehicle> ASSAULT_SHIP = class'VehicleClasses.VehicleAssaultShip';
  local const class<Gameplay.Vehicle> JUMP_TANK = class'VehicleClasses.VehicleTank';

  foreach AllActors(class'Gameplay.VehicleSpawnPoint', pad)
  {
    switch (pad.vehicleClass) {
      case FIGHTER_POD:
        enableFighterPod ?
          pad.vehicleClass = class'FighterPod' : pad.setSwitchedOn(false);
        break;
      case ROVER_BUGGY:
        if (enableRover) {
          enableRoverGun ?
            pad.vehicleClass = class'RoverBuggyGun' : pad.vehicleClass = class'RoverBuggy';
        }
        else pad.setSwitchedOn(false);
        break;
      case ASSAULT_SHIP:
        enableAssaultShip ?
          pad.vehicleClass = class'AssaultShip' : pad.setSwitchedOn(false);
        break;
      case JUMP_TANK:
        enableJumpTank ?
          pad.vehicleClass = class'JumpTank' : pad.setSwitchedOn(false);
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
	Level.Game.Default.DefaultPlayerClassName = MOD_NAME $ ".promodMultiplayerCharacter";
	Level.Game.DefaultPlayerClassName = MOD_NAME $ ".promodMultiplayerCharacter";
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

function removeDeployableMines();
{
  local BaseObjectClasses.BaseDeployableSpawnTurret turretDispenser;

  foreach AllActors(class'BaseObjectClasses.BaseDeployableSpawnTurret', turretDispenser)
    turretDispenser.Destroy();
}

function removeDeployableTurrets();
{
  local BaseObjectClasses.BaseDeployableSpawnShockMine mineDispenser;

  foreach AllActors(class'BaseObjectClasses.BaseDeployableSpawnShockMine', mineDispenser)
    mineDispenser.Destroy();
}

function ModifyBaseDevices(optional bool canBeDamaged = false)
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
  removeBaseTurrets=true
  removeDeployableMines=true
  removeDeployableTurrets=true
  disableBaseRape=true
  BaseRapeProtectedDevices(1)=class'BaseObjectClasses.BaseCatapult'
  BaseRapeProtectedDevices(2)=class'BaseObjectClasses.BaseDeployableSpawn'
  BaseRapeProtectedDevices(3)=class'BaseObjectClasses.BaseInventoryStation'
  BaseRapeProtectedDevices(4)=class'BaseObjectClasses.BasePowerGenerator'
  BaseRapeProtectedDevices(5)=class'BaseObjectClasses.BaseResupply'
  BaseRapeProtectedDevices(6)=class'BaseObjectClasses.BaseSensor'
  BaseRapeProtectedDevices(7)=class'BaseObjectClasses.BaseTurret'

  spawnCombatRole=class'EquipmentClasses.CombatRoleLight'
  spawnInvincibleDelay=2.500000
  heavyKnockbackScale=1.175000
  heavyHealth=195

  LightWeapons(1)=(typeClass=class'EquipmentClasses.WeaponSpinfusor',quantity=20)
  LightWeapons(2)=(typeClass=class'EquipmentClasses.WeaponSniperRifle',quantity=10)
  LightWeapons(3)=(typeClass=class'EquipmentClasses.WeaponGrenadeLauncher',quantity=15)
  LightWeapons(4)=(typeClass=class'EquipmentClasses.WeaponRocketPod',quantity=42)
  LightWeapons(5)=(typeClass=class'EquipmentClasses.WeaponBlaster')
  LightWeapons(6)=(typeClass=class'EquipmentClasses.WeaponGrappler',quantity=7)
  LightWeapons(7)=(typeClass=class'EquipmentClasses.WeaponBurner')
  LightWeapons(8)=(typeClass=class'EquipmentClasses.WeaponChaingun',quantity=150)

  MediumWeapons(1)=(typeClass=class'EquipmentClasses.WeaponSpinfusor',quantity=22)
  MediumWeapons(2)=(typeClass=class'EquipmentClasses.WeaponBuckler',quantity=1)
  MediumWeapons(3)=(typeClass=class'EquipmentClasses.WeaponGrenadeLauncher',quantity=17)
  MediumWeapons(4)=(typeClass=class'EquipmentClasses.WeaponRocketPod',quantity=72)
  MediumWeapons(5)=(typeClass=class'EquipmentClasses.WeaponBlaster')
  MediumWeapons(6)=(typeClass=class'EquipmentClasses.WeaponGrappler',quantity=7)
  MediumWeapons(7)=(typeClass=class'EquipmentClasses.WeaponBurner')
  MediumWeapons(8)=(typeClass=class'EquipmentClasses.WeaponChaingun',quantity=200)

  HeavyWeapons(1)=(typeClass=class'EquipmentClasses.WeaponSpinfusor',quantity=25)
  HeavyWeapons(2)=(typeClass=class'EquipmentClasses.WeaponMortar',quantity=13)
  HeavyWeapons(3)=(typeClass=class'EquipmentClasses.WeaponGrenadeLauncher',quantity=20)
  HeavyWeapons(4)=(typeClass=class'EquipmentClasses.WeaponRocketPod',quantity=96)
  HeavyWeapons(5)=(typeClass=class'EquipmentClasses.WeaponBlaster')
  HeavyWeapons(6)=(typeClass=class'EquipmentClasses.WeaponGrappler',quantity=7)
  HeavyWeapons(7)=(typeClass=class'EquipmentClasses.WeaponBurner')
  HeavyWeapons(8)=(typeClass=class'EquipmentClasses.WeaponChaingun',quantity=300)

  FriendlyName="promod_v2"
  Description="Mutator code: promod_v2.promod"
}
