package GameMasterDictionary
{
   public class GMDoober extends GMItem
   {
      
      public var DooberType:String;
      
      public var SharedReward:String;
      
      public var InstantReward:String;
      
      public var ScaleVisual:Number;
      
      public var AssetClassName:String;
      
      public var SwfFilePath:String;
      
      public var PickupSound:String;
      
      public var PickupVolume:Number;
      
      public var Exp:uint;
      
      public var ChestId:uint;
      
      public var Rarity:String;
      
      public var HPPercentage:Number;
      
      public var MPPercentage:Number;
      
      public function GMDoober(param1:Object)
      {
         super(param1);
         DooberType = param1.DooberType;
         SharedReward = param1.SharedReward;
         ScaleVisual = 1;
         if(param1.ScaleVisual)
         {
            ScaleVisual = param1.ScaleVisual;
         }
         InstantReward = param1.InstantReward;
         AssetClassName = param1.AssetClassName;
         SwfFilePath = param1.SwfFilepath;
         PickupSound = param1.PickupSound;
         PickupVolume = param1.PickupVol;
         Exp = param1.Exp;
         ChestId = param1.ChestId;
         Rarity = param1.Rarity;
         HPPercentage = param1.HP_PERCENTAGE;
         MPPercentage = param1.MP_PERCENTAGE;
      }
      
      public function isFood() : Boolean
      {
         return DooberType == "FOOD" || DooberType == "FOOD_COOK" || DooberType == "CHEF_FOOD";
      }
   }
}

