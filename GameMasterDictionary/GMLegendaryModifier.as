package GameMasterDictionary
{
   public class GMLegendaryModifier extends GMItem
   {
      
      public var IconName:String;
      
      public var Description:String;
      
      public function GMLegendaryModifier(param1:Object)
      {
         super(param1);
         IconName = param1.IconName;
         Description = param1.Description;
      }
   }
}

