class UMCowProjectile extends Projectile;

var float SmokeRate;
var bool bRing,bHitWater,bWaterStart;
var int NumExtraRockets;
var	rockettrail trail;

simulated function Destroyed()
{
	if ( Trail != None )
		Trail.Destroy();
	Super.Destroyed();
}

simulated function PostBeginPlay()
{
}

simulated function Timer()
{
}

auto state Flying
{

	simulated function ZoneChange( Zoneinfo NewZone )
	{
		local waterring w;
		
		if (!NewZone.bWaterZone || bHitWater) Return;

		bHitWater = True;
		if ( Level.NetMode != NM_DedicatedServer )
		{
			w = Spawn(class'WaterRing',,,,rot(16384,0,0));
			w.DrawScale = 0.2;
			w.RemoteRole = ROLE_None;
		}		
		Velocity=0.6*Velocity;
	}

	simulated function ProcessTouch (Actor Other, Vector HitLocation)
	{
		if ( (Other != instigator) && !Other.IsA('Projectile') ) 
			Explode(HitLocation,Normal(HitLocation-Other.Location));
	}

	function BlowUp(vector HitLocation)
	{
		HurtRadius(Damage,300.0, MyDamageType, MomentumTransfer, HitLocation );
		MakeNoise(1.0);
	}

	simulated function Explode(vector HitLocation, vector HitNormal)
	{
		local ShockWave s;

		s = spawn(class'ShockWave',,,HitLocation + HitNormal*16);	
 		s.RemoteRole = ROLE_None;

		BlowUp(HitLocation);

 		Destroy();
	}

	function BeginState()
	{
		local vector Dir;

		Dir = vector(Rotation);
		Velocity = speed * Dir;
		Acceleration = Dir * 50;
		if (Region.Zone.bWaterZone)
		{
			bHitWater = True;
			Velocity=0.6*Velocity;
		}
	}
}

defaultproperties
{
    speed=4000.00
    Damage=80.00
    MomentumTransfer=80000
    MyDamageType=shot
    ImpactSound=Sound'UnrealShare.Eightball.GrenadeFloor'
    ExplosionDecal=Class'UMBlastMark'
    LifeSpan=6.00
    AmbientSound=Sound'UnrealShare.Cow.ambCow'
    Skin=Texture'UnrealShare.Skins.JCow1'
    Mesh=LodMesh'UnrealShare.NaliCow'
    DrawScale=0.25
    AmbientGlow=96
    bUnlit=True
    SoundRadius=14
    SoundVolume=255
    SoundPitch=100
    LightBrightness=255
    LightHue=28
    LightRadius=6
    bBounce=True
    bFixedRotationDir=True
    RotationRate=(Pitch=0,Yaw=0,Roll=80000),
    DesiredRotation=(Pitch=0,Yaw=0,Roll=60000),
}
