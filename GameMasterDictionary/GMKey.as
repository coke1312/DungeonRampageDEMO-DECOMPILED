package GameMasterDictionary
{
   public class GMKey
   {
      
      public var OfferId:uint;
      
      public var ChestId:uint;
      
      public function GMKey(param1:Object)
      {
         super();
         OfferId = param1.OfferId;
         ChestId = param1.ChestId;
      }
   }
}

