package Actor.Player.Input.DBMouseEvents
{
   import Actor.ActorGameObject;
   
   public class MouseDownOnActorEvent extends DBMouseEvent
   {
      
      public static const TYPE:String = "MouseDownOnActorEvent";
      
      public function MouseDownOnActorEvent(param1:ActorGameObject, param2:Boolean = false, param3:Boolean = false)
      {
         super("MouseDownOnActorEvent",param1,param2,param3);
      }
   }
}

