class ArmorHeavy extends EquipmentClasses.ArmorHeavy config(promod_v2);

var(PlayerWeapons) config int spinfusorAmmo,
                              grenadeLauncherAmmo,
                              grapplerAmmo,
                              chaingunAmmo,
                              mortarAmmo,
                              rocketPodAmmo,
                              handGrenadeAmmo;

static function int maxAmmo(class<Weapon> typeClass)
{
	if (!default.bRestrictions)
		return 9999;

  switch (typeClass) {
    case class'EquipmentClasses.WeaponSpinfusor':
      return default.spinfusorAmmo;
    case class'EquipmentClasses.WeaponGrenadeLauncher':
      return default.grenadeLauncherAmmo;
    case class'EquipmentClasses.WeaponGrappler':
      return default.grapplerAmmo;
    case class'EquipmentClasses.WeaponChaingun':
      return default.chaingunAmmo;
    case class'EquipmentClasses.WeaponMortar':
      return default.mortarAmmo;
    case class'EquipmentClasses.WeaponRocketPod':
      return default.rocketPodAmmo;
    default:
      return -1;
  }
}

static function int maxGrenades()
{
	return default.handGrenadeAmmo;
}

defaultproperties
{
  spinfusorAmmo=25
  grenadeLauncherAmmo=20
  grapplerAmmo=7
  chaingunAmmo=300
  mortarAmmo=13
  rocketPodAmmo=96
  handGrenadeAmmo=5
}
