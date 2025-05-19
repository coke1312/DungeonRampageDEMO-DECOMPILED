package Actor.Player.Input.DBMouseEvents
{
   import Actor.ActorGameObject;
   
   public class MouseOverOnActorEvent extends DBMouseEvent
   {
      
      public static const TYPE:String = "MouseOverOnActorEvent";
      
      public function MouseOverOnActorEvent(param1:ActorGameObject, param2:Boolean = false, param3:Boolean = false)
      {
         super("MouseOverOnActorEvent",param1,param2,param3);
      }
   }
}

