package Actor.Player.Input.DBMouseEvents
{
   import Actor.ActorGameObject;
   
   public class MouseOutOnActorEvent extends DBMouseEvent
   {
      
      public static const TYPE:String = "MouseOutOnActorEvent";
      
      public function MouseOutOnActorEvent(param1:ActorGameObject, param2:Boolean = false, param3:Boolean = false)
      {
         super("MouseOutOnActorEvent",param1,param2,param3);
      }
   }
}

