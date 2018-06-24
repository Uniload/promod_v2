class ProjectileMortar extends EquipmentClasses.ProjectileMortar config(promod_v2);

/** Remove simulated projectile touch logic from clients */
function ProjectileTouch(Actor Other, vector TouchLocation, vector TouchNormal)
{
  super.ProjectileTouch(Other, TouchLocation, TouchNormal);
}

// TODO TEST THIS
/** Remove projectile catapult bug */
simulated function bool projectileTouchProcessing(
  Actor Other,
  vector TouchLocation,
  vector TouchNormal
) {
	if (Other.IsA('BaseCatapult') || Other.IsA('DeployedCatapult'))
		return false;

	return super.projectileTouchProcessing(Other, TouchLocation, TouchNormal);
}

defaultproperties
{
  LifeSpan=11.000000
}
