package GameMasterDictionary
{
   import Brain.Logger.Logger;
   
   public class GMAttack extends GMItem
   {
      
      public static const g_melee:GMAttack_StateVectorOffsets = new GMAttack_StateVectorOffsets(8,2,5,0);
      
      public static const g_range:GMAttack_StateVectorOffsets = new GMAttack_StateVectorOffsets(9,3,6,1);
      
      public static const g_magic:GMAttack_StateVectorOffsets = new GMAttack_StateVectorOffsets(10,4,7,2);
      
      public var Team:String;
      
      public var WeaponReq:String;
      
      public var AttackType:String;
      
      public var AffectsOthers:Boolean;
      
      public var AffectsProps:Boolean;
      
      public var AffectsSelf:Boolean;
      
      public var Targeting:String;
      
      public var CombatUsage:String;
      
      public var LineOfSightReq:Number;
      
      public var UseAutoAim:Boolean;
      
      public var AttackTimeline:String;
      
      public var DamageMod:Number;
      
      public var StunChance:Number;
      
      public var HitStunDur:Number;
      
      public var InvincibleDur:Number;
      
      public var Knockback:Number;
      
      public var KnockbackDur:Number;
      
      public var AttackSpdF:Number;
      
      public var Range:Number;
      
      public var Defense:Number;
      
      public var Projectile:String;
      
      public var ChargeTime:Number;
      
      public var CooldownLength:Number;
      
      public var LockControls:Number;
      
      public var StrafeControls:Number;
      
      public var HitsPerCollision:Number;
      
      public var MoveAmount:Number;
      
      public var MoveAngle:Number;
      
      public var MoveDuration:Number;
      
      public var AIRechargeT:Number;
      
      public var SwordTrail:String;
      
      public var SwordTrailSizeF:Number;
      
      public var TrailTint:Number;
      
      public var TrailSaturation:Number;
      
      public var HitEffect:String;
      
      public var HitEffectFilepath:String;
      
      public var HitEffectStopRotation:Boolean;
      
      public var HitEffectBehindAvatar:Boolean;
      
      public var HitEffectLerpFilepath:String;
      
      public var HitEffectToLerpToAttacker:String;
      
      public var HitEffectToLerpFromAttacker:String;
      
      public var HitEffectToLerpSpeed:Number;
      
      public var HitEffectToLerpGlowColor:uint;
      
      public var AttackSound:String;
      
      public var AttackVolume:Number;
      
      public var ImpactSound:String;
      
      public var ImpactVolume:Number;
      
      public var Description:String;
      
      public var ComboWindow:Number;
      
      public var RecoveryTime:Number;
      
      public var IconFilepath:String;
      
      public var IconName:String;
      
      public var ManaCost:Number;
      
      public var StatOffsets:GMAttack_StateVectorOffsets;
      
      public var CrowdCost:uint;
      
      public var Unblockable:Boolean;
      
      public var SpawnNPC:String;
      
      public var SetTeleport:Boolean;
      
      public var AttackOnHit:String;
      
      public function GMAttack(param1:Object)
      {
         super(param1);
         Team = param1.Team;
         WeaponReq = param1.WeaponReq;
         AttackType = param1.AttackType;
         Targeting = param1.Targeting;
         AffectsOthers = param1.AffectsOthers;
         AffectsProps = param1.AffectsProps;
         AffectsSelf = param1.AffectsSelf;
         CombatUsage = param1.CombatUsage;
         LineOfSightReq = param1.LineOfSightReq;
         UseAutoAim = param1.UseAutoAim;
         AttackTimeline = param1.AttackTimeline;
         DamageMod = param1.DamageMod;
         StunChance = param1.StunChance;
         HitStunDur = param1.HitStunDur;
         InvincibleDur = param1.InvincibleDur;
         Knockback = param1.Knockback;
         KnockbackDur = param1.KnockbackDur;
         AttackSpdF = param1.AttackSpd;
         Range = param1.Range;
         Defense = param1.Defense;
         Projectile = param1.Projectile;
         ChargeTime = param1.ChargeTime;
         CooldownLength = param1.CooldownLength;
         LockControls = param1.LockControls;
         StrafeControls = param1.StrafeControls;
         HitsPerCollision = param1.HitsPerCollision;
         MoveAmount = param1.MoveAmount;
         MoveAngle = param1.MoveAngle;
         MoveDuration = param1.MoveDuration;
         AIRechargeT = param1.AI_RechargeT;
         SwordTrail = param1.SwordTrail;
         TrailTint = param1.TrailTint;
         TrailSaturation = param1.TrailSaturation / 100 + 1;
         HitEffect = param1.HitEffect;
         HitEffectStopRotation = param1.HitEffectStopRotation;
         HitEffectFilepath = param1.HitEffectFilepath ? param1.HitEffectFilepath : "Resources/Art2D/FX/db_fx_library.swf";
         HitEffectBehindAvatar = param1.HitEffectBehindAvatar ? param1.HitEffectBehindAvatar : false;
         HitEffectLerpFilepath = param1.HitEffectLerpFilepath ? param1.HitEffectLerpFilepath : "Resources/Art2D/FX/db_fx_library.swf";
         HitEffectToLerpToAttacker = param1.HitEffectToLerpToAttacker;
         HitEffectToLerpFromAttacker = param1.HitEffectToLerpFromAttacker;
         HitEffectToLerpSpeed = param1.HitEffectToLerpSpeed;
         HitEffectToLerpGlowColor = param1.HitEffectToLerpGlowColor;
         AttackSound = param1.AttackSound;
         AttackVolume = param1.AttackVol;
         ImpactSound = param1.ImpactSound;
         ImpactVolume = param1.ImpactVol;
         Description = param1.Description;
         ComboWindow = param1.ComboWindow;
         RecoveryTime = param1.RecoveryTime;
         ManaCost = param1.ManaCost;
         IconFilepath = param1.IconFilepath;
         IconName = param1.IconName;
         CrowdCost = param1.CrowdCost;
         Unblockable = param1.Unblockable;
         SpawnNPC = param1.SpawnNPC;
         SetTeleport = param1.SetTeleport;
         AttackOnHit = param1.AttackOnHit;
         switch(AttackType)
         {
            case "MELEE":
               StatOffsets = g_melee;
               break;
            case "SHOOTING":
               StatOffsets = g_range;
               break;
            case "MAGIC":
               StatOffsets = g_magic;
               break;
            case "SUPPORT":
            case "ANIMATION":
               break;
            default:
               Logger.warn("GMAttack: unknown AttackType: " + AttackType);
         }
      }
   }
}

