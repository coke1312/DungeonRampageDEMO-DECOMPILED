package Brain.GameObject
{
   import Brain.Facade.Facade;
   import Brain.Logger.Logger;
   
   public class LocalUniqueID extends UniqueID
   {
      
      private static var minId:uint = 1000000;
      
      private static var maxId:uint = 1099999;
      
      private static var cache:uint = 1000000;
      
      public function LocalUniqueID(param1:Facade, param2:GameObject)
      {
         var _loc3_:* = 0;
         var _loc4_:uint = nextCandidate();
         while(_loc3_ == 0)
         {
            if(param1.gameObjectManager.isIdActive(_loc4_))
            {
               _loc4_ = nextCandidate();
            }
            else
            {
               _loc3_ = _loc4_;
            }
         }
         super(param1,_loc3_,param2);
      }
      
      private function nextCandidate() : uint
      {
         cache += 1;
         if(cache > maxId)
         {
            Logger.debug("--------------------------->Wrap **************************************");
            cache = minId;
         }
         return cache;
      }
   }
}

