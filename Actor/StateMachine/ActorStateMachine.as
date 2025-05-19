package Actor.StateMachine
{
   import Actor.ActorGameObject;
   import Actor.ActorView;
   import Brain.StateMachine.StateMachine;
   import Facade.DBFacade;
   
   public class ActorStateMachine extends StateMachine
   {
      
      protected var mDBFacade:DBFacade;
      
      protected var mActorGameObject:ActorGameObject;
      
      protected var mActorView:ActorView;
      
      public function ActorStateMachine(param1:DBFacade, param2:ActorGameObject, param3:ActorView)
      {
         super();
         mDBFacade = param1;
         mActorGameObject = param2;
         mActorView = param3;
      }
      
      override public function destroy() : void
      {
         mActorView = null;
         mActorGameObject = null;
         mDBFacade = null;
         super.destroy();
      }
   }
}

