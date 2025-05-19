package Account
{
   public class Consumable
   {
      
      public var stackId:uint;
      
      public var stackCount:uint;
      
      public var stackSlot:uint;
      
      public function Consumable(param1:uint, param2:uint, param3:uint)
      {
         super();
         stackId = param2;
         stackCount = param3;
         stackSlot = param1;
      }
   }
}

