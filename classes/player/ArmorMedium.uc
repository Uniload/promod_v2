class ArmorMedium extends EquipmentClasses.ArmorMedium config(promod_v2);

var(PlayerWeapons) config int spinfusorAmmo,
                              grenadeLauncherAmmo,
                              grapplerAmmo,
                              chaingunAmmo,
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
    case class'EquipmentClasses.WeaponBuckler':
      return 1;
    case class'EquipmentClasses.WeaponRocketPod':
      return default.rocketPodAmmo;

    default:
      return 0;
  }
}

static function int maxGrenades()
{
	return default.handGrenadeAmmo;
}

defaultproperties
{
  spinfusorAmmo=22
  grenadeLauncherAmmo=17
  grapplerAmmo=7
  chaingunAmmo=200
  rocketPodAmmo=72
  handGrenadeAmmo=5
}
