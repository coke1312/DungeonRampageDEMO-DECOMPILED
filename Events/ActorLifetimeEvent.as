package Events
{
   import flash.events.Event;
   
   public class ActorLifetimeEvent extends Event
   {
      
      public static const ACTOR_CREATE_EVENT:String = "ACTOR_CREATED";
      
      public static const ACTOR_DESTROY_EVENT:String = "ACTOR_DESTROYED";
      
      private var mActorId:uint;
      
      public function ActorLifetimeEvent(param1:String, param2:uint, param3:Boolean = false, param4:Boolean = false)
      {
         super(param1,param3,param4);
         mActorId = param2;
      }
      
      public function get actorId() : uint
      {
         return mActorId;
      }
   }
}

