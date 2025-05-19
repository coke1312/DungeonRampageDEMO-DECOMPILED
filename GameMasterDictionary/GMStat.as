package GameMasterDictionary
{
   public class GMStat extends GMItem
   {
      
      public var StatType:String;
      
      public var Bonus:Number;
      
      public var MaxCap:Number;
      
      public var IconName:String;
      
      public var Description:String;
      
      public function GMStat(param1:Object)
      {
         super(param1);
         StatType = param1.StatType;
         Bonus = param1.Bonus;
         MaxCap = param1.MaxCap;
         IconName = param1.IconName;
         Description = param1.Description;
      }
   }
}

