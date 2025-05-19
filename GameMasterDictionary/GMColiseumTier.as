package GameMasterDictionary
{
   public class GMColiseumTier extends GMItem
   {
      
      public var MusicFilepath:String;
      
      public var BonusGold:Number;
      
      public var BonusExp:Number;
      
      public var MinLevel:uint;
      
      public var TotalFloors:uint;
      
      public function GMColiseumTier(param1:Object)
      {
         super(param1);
         MusicFilepath = param1.MusicFilepath;
         BonusGold = param1.Gold;
         BonusExp = param1.Exp;
         MinLevel = param1.MinLevel;
         TotalFloors = param1.MinFloors;
      }
   }
}

