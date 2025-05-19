package Events
{
   import flash.events.Event;
   
   public class GameObjectEvent extends Event
   {
      
      public var id:uint;
      
      public function GameObjectEvent(param1:String, param2:uint, param3:Boolean = false, param4:Boolean = false)
      {
         this.id = param2;
         super(uniqueEvent(param1,param2),param3,param4);
      }
      
      public static function uniqueEvent(param1:String, param2:uint) : String
      {
         return param1 + "_" + param2.toString();
      }
   }
}

