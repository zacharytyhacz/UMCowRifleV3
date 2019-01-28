class UMCowProjectile2 extends UT_Grenade;

var bool bCanHitOwner, bHitWater;
var float Count, SmokeRate;
var int NumExtraGrenades;

function BlowUp(vector HitLocation)
{
	HurtRadius(damage, 200, MyDamageType, MomentumTransfer, HitLocation);
	MakeNoise(1.0);
}

simulated function Explosion(vector HitLocation)
{
	local ShockWave s;

	BlowUp(HitLocation);
	if ( Level.NetMode != NM_DedicatedServer )
	{
		spawn(class'UMCowRifleV3.UMBlastMark',,,,rot(16384,0,0));
  		s = spawn(class'ShockWave',,,HitLocation);
		s.RemoteRole = ROLE_None;
	}
 	Destroy();
}

defaultproperties
{
    ImpactSound=Sound'UnrealShare.Cow.injurC2c'
    ExplosionDecal=Class'UMBlastMark'
    Mesh=LodMesh'UnrealShare.NaliCow'
    DrawScale=0.25
}
