package Actor.Player.Input.DBMouseEvents
{
   import Actor.ActorGameObject;
   import flash.events.Event;
   
   public class DBMouseEvent extends Event
   {
      
      protected var mActor:ActorGameObject;
      
      public function DBMouseEvent(param1:String, param2:ActorGameObject, param3:Boolean = false, param4:Boolean = false)
      {
         super(param1,param3,param4);
         mActor = param2;
      }
      
      public function get actor() : ActorGameObject
      {
         return mActor;
      }
   }
}

