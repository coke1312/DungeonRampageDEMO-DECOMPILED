package GameMasterDictionary
{
   import DBGlobals.DBGlobal;
   
   public class GMNpc extends GMActor
   {
      
      public var IsNavigable:Boolean;
      
      public var IsAttackable:Boolean;
      
      public var HasHealthbar:Boolean;
      
      public var UsePetUI:Boolean;
      
      public var IsBoss:Boolean;
      
      public var ActivateSound:String;
      
      public var ActivateVolume:Number;
      
      public var DeactivateSound:String;
      
      public var DeactivateVolume:Number;
      
      public var DefaultHeading:int;
      
      public var DefaultLayer:String;
      
      public var UseFlashRotation:Boolean;
      
      public var PermCorpse:Boolean;
      
      public var ArchwayAlpha:Boolean;
      
      public var ViolentDeathClassName:String;
      
      public var ViolentDeathFilePath:String;
      
      public var BlockingDotProduct:Number;
      
      public var SellCoins:int;
      
      public var AttackRating:uint;
      
      public var DefenseRating:uint;
      
      public var SpeedRating:uint;
      
      public var TileTheme:String;
      
      public var UseTeleportAI:Boolean;
      
      public var ShowHealNumbers:Boolean;
      
      public function GMNpc(param1:Object)
      {
         super(param1);
         if(param1.Ability1 != null)
         {
            Ability |= DBGlobal.mapAbilityMask(param1.Ability1);
         }
         if(param1.Ability2 != null)
         {
            Ability |= DBGlobal.mapAbilityMask(param1.Ability2);
         }
         if(param1.Ability3 != null)
         {
            Ability |= DBGlobal.mapAbilityMask(param1.Ability3);
         }
         if(param1.Ability4 != null)
         {
            Ability |= DBGlobal.mapAbilityMask(param1.Ability4);
         }
         if(param1.Ability5 != null)
         {
            Ability |= DBGlobal.mapAbilityMask(param1.Ability5);
         }
         Weapon1 = param1.Weapon1;
         Weapon2 = param1.Weapon2;
         Weapon3 = param1.Weapon3;
         Weapon4 = param1.Weapon4;
         Weapon5 = param1.Weapon5;
         SellCoins = param1.SellCoin;
         AttackRating = param1.AttackRating;
         DefenseRating = param1.DefenseRating;
         SpeedRating = param1.SpeedRating;
         IsNavigable = param1.IsNavigable == 1;
         if(Constant == "GARLIC_PLACEABLE_L2")
         {
            IsNavigable = true;
         }
         IsAttackable = param1.IsAttackable == 1;
         IsBoss = param1.IsBoss == 1;
         HasHealthbar = param1.HasHealthbar;
         UsePetUI = param1.UsePetUI;
         UseTeleportAI = param1.Aggro_AI_Type == "TELEPORT_AI";
         ActivateSound = param1.ActivateSound;
         ActivateVolume = param1.ActivateVol;
         DeactivateSound = param1.DeactivateSound;
         DeactivateVolume = param1.DeactivateVol;
         DefaultHeading = param1.DefaultHeading;
         DefaultLayer = param1.DefaultLayer;
         TileTheme = param1.TileTheme;
         UseFlashRotation = param1.UseFlashRotation;
         PermCorpse = param1.PermCorpse;
         ArchwayAlpha = param1.ArchwayAlpha;
         ViolentDeathClassName = param1.ViolentDeathClassName;
         ViolentDeathFilePath = param1.ViolentDeathFilePath;
         BlockingDotProduct = param1.BlockingDotProduct;
         ShowHealNumbers = param1.ShowHealNumbers;
      }
      
      public function blocksNatively() : Boolean
      {
         return BlockingDotProduct > -1.1;
      }
   }
}

