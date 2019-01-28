class UMCowArena expands Arena;


function bool CheckReplacement(Actor Other, out byte bSuperRelevant)
{
     if ( Other.IsA('Translocator') )
          return true;

     return Super.CheckReplacement( Other, bSuperRelevant );
	
	if ( Other.IsA('Ammo') )
     {
          if ((AmmoString != "") && !Other.IsA(AmmoName))
               ReplaceWith(Other, AmmoString);
          return false;
     }

     bSuperRelevant = 0;
     return true;
}

defaultproperties
{
    WeaponName=UMCowRifleV2
    AmmoName=UMBeef
    WeaponString="UMCowRifleV3.UMCowRifleV3"
    AmmoString="UMCowRifleV3.UMBeef"
    DefaultWeapon=Class'UMCowRifleV3'
}
