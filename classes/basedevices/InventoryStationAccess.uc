class InventoryStationAccess extends Gameplay.InventoryStationAccess config(promod_v2);

function bool CanBeUsedBy(Pawn user)
{
  // if user is holding the flag do nothing TODO apropriate error message
  if (user.PlayerReplicationInfo.bHasFlag)
    return false;
  return Super.CanBeUsedBy(user);
}

defaultproperties
{
  bAutoConfigGrenades = False
}
