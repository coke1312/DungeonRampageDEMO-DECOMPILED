package GameMasterDictionary
{
   import DBGlobals.DBGlobal;
   
   public class GMBuff extends GMItem
   {
      
      public var Team:String;
      
      public var Duration:Number;
      
      public var LayerPriority:Number;
      
      public var SwapDisplay:Boolean;
      
      public var Type:String;
      
      public var Ability:uint;
      
      public var DeltaValues:StatVector;
      
      public var Exp:Number;
      
      public var EventExp:Number;
      
      public var Gold:Number;
      
      public var VFX:String;
      
      public var VFXFilepath:String;
      
      public var TintColor:Number;
      
      public var TintAmountF:Number;
      
      public var Description:String;
      
      public var SortLayer:String;
      
      public var BuffFloaterColor:uint;
      
      public var Scale:Number;
      
      public var ScaleStartDelay:Number;
      
      public var ShakeLocalCamera:Boolean;
      
      public var ScaleUpIncrementTime:Number;
      
      public var ScaleUpIncrementScale:Number;
      
      public var ShowInHUD:Boolean;
      
      public var IconSwf:String;
      
      public var IconName:String;
      
      public var DescriptionPercentForEachStack:Number;
      
      public var AttackCooldownMultiplier:Number;
      
      public function GMBuff(param1:Object)
      {
         super(param1);
         Team = param1.Team;
         Duration = param1.Duration;
         LayerPriority = param1.LayerPriority;
         SwapDisplay = param1.SwapDisplay != null;
         Type = param1.BuffType;
         Ability = 0;
         Ability |= DBGlobal.mapAbilityMask(param1.Ability1);
         Ability |= DBGlobal.mapAbilityMask(param1.Ability2);
         Ability |= DBGlobal.mapAbilityMask(param1.Ability3);
         DeltaValues = new StatVector();
         DeltaValues.SetFromJSON(param1);
         Exp = param1.EXP;
         EventExp = param1.EVENT_EXP;
         Gold = param1.Gold ? param1.Gold : 1;
         VFX = param1.VFX;
         VFXFilepath = param1.VFXFilepath ? param1.VFXFilepath : "Resources/Art2D/FX/db_fx_library.swf";
         SortLayer = param1.SortLayer;
         TintColor = -1;
         TintAmountF = 1;
         var _loc2_:String = param1.TintColor;
         if(_loc2_ != null)
         {
            TintColor = parseInt(_loc2_,16);
            TintAmountF = param1.TintAmount;
         }
         Description = param1.Description;
         BuffFloaterColor = param1.BuffFloaterColor;
         Scale = param1.Scale;
         ShakeLocalCamera = param1.ShakeLocalCamera;
         ScaleStartDelay = param1.ScaleUpStartDelay;
         ScaleUpIncrementTime = param1.ScaleUpIncrementTime;
         ScaleUpIncrementScale = param1.ScaleUpIncrementScale;
         ShowInHUD = param1.ShowInHUD;
         IconSwf = param1.IconSwf;
         IconName = param1.IconName;
         DescriptionPercentForEachStack = param1.DescriptionPercentForEachStack ? param1.DescriptionPercentForEachStack : 0;
         AttackCooldownMultiplier = 1;
         if(param1.AttackCooldownMultiplier != null)
         {
            AttackCooldownMultiplier = param1.AttackCooldownMultiplier;
         }
      }
      
      public function getStacksDescription(param1:int) : String
      {
         var _loc2_:Number = DescriptionPercentForEachStack * param1;
         if(_loc2_ > 0)
         {
            return _loc2_.toString() + "%";
         }
         return "";
      }
   }
}

