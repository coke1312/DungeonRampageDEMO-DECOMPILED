package GameMasterDictionary
{
   public class GMBuffColorType
   {
      
      public var Id:uint;
      
      public var ColorHex:uint;
      
      public function GMBuffColorType(param1:Object)
      {
         super();
         Id = param1.Id;
         ColorHex = param1.TextColor;
      }
   }
}

