class ProjectileBlaster extends EquipmentClasses.ProjectileBlaster config(promod_v2);

/** Remove simulated projectile touch logic from clients */
function ProjectileTouch(Actor Other, vector TouchLocation, vector TouchNormal)
{
  super.ProjectileTouch(Other, TouchLocation, TouchNormal);
}

defaultproperties
{
	bScaleProjectile=true
	initialXDrawScale=0.05
	xDrawScalePerSecond=10.0
	bShouldBounce=true
	bounceTime=0.5
	maxBounces=2
	bounceCount=0
	damageAmt=7
	LifeSpan=3
	StaticMesh=StaticMesh'Weapons.Disc'
	DrawScale3D=(X=0.3,Y=0.3,Z=0.3)
	deathMessage='%s copped it off %s\'s Blaster'
	knockback=15000
	knockbackAliveScale=0
	Skins(0)=Shader'weapons.bulletblastershader'
}
