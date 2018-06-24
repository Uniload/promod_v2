class ProjectileSniperRifle extends EquipmentClasses.ProjectileSniperRifle config(promod_v2);

var config float damageToSensor;

/** Remove simulated projectile touch logic from clients.
 *  Remove snipe damage to sensor.
 */
function ProjectileTouch(Actor Other, vector TouchLocation, vector TouchNormal)
{
  if(BaseObjectClasses.BaseSensor(Other) != None)
		damageAmt = damageToSensor;

  super.ProjectileTouch(Other, TouchLocation, TouchNormal);
}

defaultproperties
{
  SniperSensorDmg=0
  damageAmt=50.000000
  damageTypeClass=Class'ProjectileDamageTypeSniperRifle'
}
