class MultiplayerCharacter extends Gameplay.MultiplayerCharacter config(promod_v2);

var config float collisionDamageMultiplier;

simulated event OnMovementCollisionDamage(float damage)
{
  local class<MovementCollisionDamageType> collisionDamageType;

  if (blockMovementDamage)
    return;
  if (level.timeSeconds<lastMovementDamageTime+0.1)
    return;
  if (movement==MovementState_Elevator)
    return;

  collisionDamageType = class'MovementCollisionDamageType';

  if (armorClass!=None && armorClass.default.movementDamageTypeClass!=none)
    collisionDamageType = armorClass.default.movementDamageTypeClass;

  damage *= collisionDamageMultiplier;

  TakeDamage(damage, self, vect(0,0,0), vect(0,0,0), collisionDamageType);
  PlayEffect("MovementCollisionDamage", DamageTag(damage));
  lastMovementDamageTime = level.timeSeconds;
}

defaultproperties
{
  collisionDamageMultiplier=1.000000
}
