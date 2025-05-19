package GameMasterDictionary
{
   public class GMSuperStat extends GMItem
   {
      
      public var BaseValues:StatVector;
      
      public var Ability1:String;
      
      public var Ability2:String;
      
      public var Ability3:String;
      
      public var IconName:String;
      
      public var Description:String;
      
      public function GMSuperStat(param1:Object)
      {
         super(param1);
         BaseValues = new StatVector();
         BaseValues.SetFromJSON(param1);
         Ability1 = param1.Ability1;
         Ability2 = param1.Ability2;
         Ability3 = param1.Ability3;
         IconName = param1.IconName;
         Description = param1.Description;
      }
   }
}

