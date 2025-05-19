package Events
{
   import flash.events.Event;
   
   public class FriendshipEvent extends Event
   {
      
      public var id:uint;
      
      public function FriendshipEvent(param1:String, param2:uint, param3:Boolean = false, param4:Boolean = false)
      {
         super(param1,param3,param4);
         this.id = param2;
      }
   }
}

