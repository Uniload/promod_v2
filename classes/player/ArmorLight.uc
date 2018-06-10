class ArmorLight extends EquipmentClasses.ArmorLight config(promod_v2);

var(PlayerWeapons) config int spinfusorAmmo,
                              grenadeLauncherAmmo,
                              grapplerAmmo,
                              chaingunAmmo,
                              SniperAmmo,
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
    case class'EquipmentClasses.WeaponSniperRifle':
      return default.SniperAmmo;
    case class'EquipmentClasses.WeaponRocketPod':
      return default.rocketPodAmmo;

    default:
      return 0;
  }
}

/**
 *  Called when walking over dropped handGrenades
 */
static function int maxGrenades()
{
	return default.handGrenadeAmmo;
}

defaultproperties
{
  spinfusorAmmo=20
  grenadeLauncherAmmo=15
  grapplerAmmo=7
  chaingunAmmo=150
  SniperAmmo=10
  rocketPodAmmo=42
  handGrenadeAmmo=5
}
