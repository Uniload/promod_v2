class ProjectileRocketPod extends EquipmentClasses.ProjectileRocketPod config(promod_v2);

/** Remove simulated projectile touch logic from clients */
function ProjectileTouch(Actor Other, vector TouchLocation, vector TouchNormal)
{
  super.ProjectileTouch(Other, TouchLocation, TouchNormal);
}

defaultproperties
{
  damageAmt=20.000000
  radiusDamageAmt=13.000000
}
