package GameMasterDictionary
{
   public class GMProjectile extends GMItem
   {
      
      public var ClassType:String;
      
      public var Element:String;
      
      public var FlightPattern:String;
      
      public var Range:Number;
      
      public var CollisionSize:Number;
      
      public var HitsPerActor:Number;
      
      public var HitRecurDelay:Number;
      
      public var MaxCollisions:uint;
      
      public var NoGenerations:Boolean;
      
      public var ProjSpeedF:Number;
      
      public var RotationSpeedF:Number;
      
      public var Proj_AOE:Number;
      
      public var OnImpactNPC:String;
      
      public var OnDeathNPC:String;
      
      public var OnImpactVFX:String;
      
      public var NumChains:uint;
      
      public var ChainDist:Number;
      
      public var CyclicChains:Boolean;
      
      public var NumBranches:uint;
      
      public var HomingDistWeight:Number;
      
      public var HomingAngleWeight:Number;
      
      public var SteeringRate:Number;
      
      public var Lifetime:uint;
      
      public var SwfFilepath:String;
      
      public var ImpactSound:String;
      
      public var ImpactVolume:Number;
      
      public var NoFade:Boolean;
      
      public var IgnoreWalls:Boolean;
      
      public var Tint:Number;
      
      public var Saturation:Number;
      
      public var TrailTint:Number;
      
      public var TrailSaturation:Number;
      
      public var ProjModel:String;
      
      public var IgnoreGlow:Boolean;
      
      public function GMProjectile(param1:Object)
      {
         super(param1);
         ClassType = param1.ClassType;
         Element = param1.Element;
         FlightPattern = param1.FlightPattern;
         Range = param1.Range;
         CollisionSize = param1.CollisionSize;
         HitsPerActor = param1.HitsPerActor;
         MaxCollisions = param1.MaxCollisions;
         HitRecurDelay = param1.HitRecurDelay;
         NoGenerations = param1.NoGenerations;
         ProjSpeedF = param1.ProjSpeed;
         RotationSpeedF = param1.RotationSpeed;
         Proj_AOE = param1.Proj_AOE;
         OnImpactNPC = param1.OnImpactNPC;
         OnImpactVFX = param1.OnImpactVFX;
         OnDeathNPC = param1.OnDeathNPC;
         NumChains = param1.NumChains;
         ChainDist = param1.ChainDist;
         CyclicChains = param1.CyclicChains;
         NumBranches = param1.NumBranches;
         HomingDistWeight = param1.hasOwnProperty("HomingDistWeight") ? param1.HomingDistWeight : 1;
         HomingAngleWeight = param1.hasOwnProperty("HomingAngleWeight") ? param1.HomingAngleWeight : 1;
         SteeringRate = param1.hasOwnProperty("SteeringRate") ? param1.SteeringRate : 1;
         Lifetime = param1.hasOwnProperty("Lifetime") ? Number(param1.Lifetime) * 1000 : 1000;
         NoFade = param1.hasOwnProperty("NoFade") ? Boolean(param1.NoFade) : false;
         IgnoreWalls = param1.hasOwnProperty("IgnoreWalls") ? true : false;
         Tint = param1.Tint;
         Saturation = param1.Saturation / 100 + 1;
         TrailTint = param1.TrailTint;
         TrailSaturation = param1.TrailSaturation / 100 + 1;
         ProjModel = param1.ProjModel;
         SwfFilepath = param1.SwfFilepath;
         ImpactSound = param1.ImpactSound;
         ImpactVolume = param1.ImpactVol;
         IgnoreGlow = param1.IgnoreGlow;
      }
   }
}

