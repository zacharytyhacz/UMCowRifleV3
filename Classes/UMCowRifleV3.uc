class UMCowRifleV3 expands TournamentWeapon;

#exec MESH IMPORT MESH=NaliCowZ ANIVFILE=MODELS\NaliCow_a.3D DATAFILE=MODELS\NaliCow_d.3D X=0 Y=0 Z=0 ZEROTEX=1
#exec MESH ORIGIN MESH=NaliCowZ X=0 Y=-240 Z=30 YAW=64 ROLL=-64

#exec MESH SEQUENCE MESH=NaliCowZ SEQ=All     STARTFRAME=0    NUMFRAMES=175
#exec MESH SEQUENCE MESH=NaliCowZ SEQ=Breath  STARTFRAME=0    NUMFRAMES=6  RATE=6
#exec MESH SEQUENCE MESH=NaliCowZ SEQ=Chew    STARTFRAME=6    NUMFRAMES=7  RATE=6
#exec MESH SEQUENCE MESH=NaliCowZ SEQ=TakeHit STARTFRAME=16   NUMFRAMES=1
#exec MESH SEQUENCE MESH=NaliCowZ SEQ=Dead    STARTFRAME=13   NUMFRAMES=23 RATE=15
#exec MESH SEQUENCE MESH=NaliCowZ SEQ=Shake   STARTFRAME=36   NUMFRAMES=18 RATE=15
#exec MESH SEQUENCE MESH=NaliCowZ SEQ=Swish   STARTFRAME=54   NUMFRAMES=20 RATE=15
#exec MESH SEQUENCE MESH=NaliCowZ SEQ=Walk    STARTFRAME=74   NUMFRAMES=15 RATE=15
#exec MESH SEQUENCE MESH=NaliCowZ SEQ=TakeHit2 STARTFRAME=89  NUMFRAMES=1
#exec MESH SEQUENCE MESH=NaliCowZ SEQ=Dead2   STARTFRAME=89   NUMFRAMES=13 RATE=15
#exec MESH SEQUENCE MESH=NaliCowZ SEQ=BigHit  STARTFRAME=102  NUMFRAMES=1
#exec MESH SEQUENCE MESH=NaliCowZ SEQ=Dead3   STARTFRAME=102  NUMFRAMES=23 RATE=15
#exec MESH SEQUENCE MESH=NaliCowZ SEQ=Poop 	 STARTFRAME=125  NUMFRAMES=20 RATE=15
#exec MESH SEQUENCE MESH=NaliCowZ SEQ=Root    STARTFRAME=145  NUMFRAMES=20 RATE=15
#exec MESH SEQUENCE MESH=NaliCowZ SEQ=Landed	 STARTFRAME=169  NUMFRAMES=1
#exec MESH SEQUENCE MESH=NaliCowZ SEQ=Run 	 STARTFRAME=165  NUMFRAMES=10 RATE=15

#exec MESHMAP SCALE MESHMAP=NaliCowZ X=0.04 Y=0.04 Z=0.08
#exec MESHMAP SETTEXTURE MESHMAP=NaliCowZ NUM=0 TEXTURE=JCow1

function Projectile ProjectileFire(class<projectile> ProjClass, float ProjSpeed, bool bWarn)
{
	local Vector Start, X,Y,Z;
	local Pawn PawnOwner;

	PawnOwner = Pawn(Owner);
	Owner.MakeNoise(PawnOwner.SoundDampening);
	GetAxes(PawnOwner.ViewRotation,X,Y,Z);
	Start = Owner.Location + CalcDrawOffset() + FireOffset.X * X + FireOffset.Y * Y + (FireOffset.Z - 0) * Z; 
	AdjustedAim = PawnOwner.AdjustAim(ProjSpeed, Start, AimError, True, bWarn);	
	return Spawn(ProjClass,,, Start,AdjustedAim);	
}

function setHand(float Hand)
{
	Super.SetHand(Hand);
	if ( Hand == 1 )
		Mesh = mesh(DynamicLoadObject("UnrealShare.NaliCow", class'Mesh'));
	else
	{
		Mesh = mesh'NaliCowZ';
	}
}

simulated function PlayFiring()
    {
       PlayAnim('Chew', 4.2, 0.05);
       Owner.PlaySound(FireSound, SLOT_None, Pawn(Owner).SoundDampening);
    }

    simulated function PlayAltFiring()
    {
       PlayAnim('Chew', 4.2, 0.05);
       Owner.PlaySound(AltFireSound, SLOT_None, Pawn(Owner).SoundDampening);
    }


    function Fire( float Value )
    {
       if ( AmmoType == None )
       {
          // ammocheck
          GiveAmmo(Pawn(Owner));
       }
       if (AmmoType.UseAmmo(1))
       {
          GotoState('NormalFire');
          bCanClientFire = true;
          bPointing=True;
          ClientAltFire(Value);
          ProjectileFire(ProjectileClass, AltProjectileSpeed, bAltWarnTarget);
       }
    }
   
   state NormalFire
   {
      Begin:
            FinishAnim();
            Finish();
   }


    function AltFire( float Value )
    {
       if ( AmmoType == None )
       {
          GiveAmmo(Pawn(Owner));
       }
       if (AmmoType.UseAmmo(1))
       {
          GotoState('AltFiring');
          bCanClientFire = true;
          bPointing=True;
          ClientAltFire(Value);
          ProjectileFire(AltProjectileClass, AltProjectileSpeed, bAltWarnTarget);
       }
    }
   
   state AltFiring
   {
      Begin:
         FinishAnim();
         Finish();
   }

defaultproperties
{
    AmmoName=Class'UMBeef'
    PickupAmmoCount=250
    bWarnTarget=True
    bAltWarnTarget=True
    bSplashDamage=True
    bRecommendSplashDamage=True
    FireOffset=(X=0.00,Y=-5.00,Z=-5.00),
    ProjectileClass=Class'UMCowProjectile'
    AltProjectileClass=Class'UMCowProjectile2'
    shakemag=350.00
    shaketime=0.20
    shakevert=7.50
    AIRating=0.70
    RefireRate=0.25
    AltRefireRate=0.25
    FireSound=Sound'UnrealShare.Cow.cMoo1c'
    AltFireSound=Sound'UnrealShare.Cow.cMoo2c'
    DeathMessage="%k filled %o with cow shit!"
    AutoSwitchPriority=6
    InventoryGroup=6
    PickupMessage="You got the UM Cow Rifle V3!"
    ItemName="UM Cow Rifle V3!"
    PlayerViewOffset=(X=25.00,Y=-20.00,Z=-30.00),
    PlayerViewMesh=LodMesh'UnrealShare.NaliCow'
    PlayerViewScale=0.75
    BobDamping=0.98
    PickupViewMesh=LodMesh'UnrealShare.NaliCow'
    ThirdPersonMesh=LodMesh'NaliCowZ'
    PickupSound=Sound'UnrealShare.Cow.thumpC'
    Mesh=LodMesh'UnrealShare.NaliCow'
    bNoSmooth=False
    CollisionHeight=10.00
}
