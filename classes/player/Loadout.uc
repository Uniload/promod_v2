class Loadout extends Gameplay.Loadout config(promod_v2);

// equip
// gives the equipment in the loadout to the player
function bool equip(Character c)
{
	local int i;
	local int j;
	local Weapon w;
	local HandGrenade hg;

	c.destroyEquipment();

	for (i = consumableList.Length - 1; i > -1; i--)
	{
		for (j = 0; j < consumableList[i].amount; ++j)
		{
			c.newEquipment(consumableList[i].consumableClass);
		}
	}

  // ADD PACK
	if (packClass != None && packClass != class'CloakPack')
	{
		c.newPack(packClass);
	}

	// ADD WEAPONS
	for (i = 0; i < weaponList.Length; ++i)
	{
		j = c.getMaxAmmo(weaponList[i].weaponClass);

		if (j != -1)
		{
			w = Weapon(c.newEquipment(weaponList[i].weaponClass));
			w.ammoCount = c.getModifiedAmmo(weaponList[i].ammo);

			w.rookMotor = c.motor;    //added line for rookMotor

			// set ammo count if needed
			if (w.ammoCount == 0)
				w.ammoCount = j;
		}
		else
			Log("Warning: weapon in loadout not allowed by armor");
	}

  // ADD GRENADES
	if (grenades.grenadeClass != None)
	{
		hg = c.newGrenades(class'WeaponHandGrenade');

		hg.ammoCount = grenades.ammo;

		if (hg.ammoCount == 0)
		{
			j = c.armorClass.static.maxGrenades();

			if (j != -1)
				hg.ammoCount = j;
			else
				hg.ammoCount = 0;
		}
	}

	return true;
}
