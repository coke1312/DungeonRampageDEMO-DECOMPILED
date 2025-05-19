package Actor.Player.Input.DBMouseEvents
{
   import Actor.ActorGameObject;
   
   public class MouseUpOnActorEvent extends DBMouseEvent
   {
      
      public static const TYPE:String = "MouseUpOnActorEvent";
      
      public function MouseUpOnActorEvent(param1:ActorGameObject, param2:Boolean = false, param3:Boolean = false)
      {
         super("MouseUpOnActorEvent",param1,param2,param3);
      }
   }
}

