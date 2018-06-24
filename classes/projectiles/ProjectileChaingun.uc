class ProjectileChaingun extends EquipmentClasses.ProjectileChaingun config(promod_v2);

/** Remove simulated projectile touch logic from clients */
function ProjectileTouch(Actor Other, vector TouchLocation, vector TouchNormal)
{
  super.ProjectileTouch(Other, TouchLocation, TouchNormal);
}

defaultproperties
{
  damageTypeClass=Class'DamageTypeChaingun'
}
