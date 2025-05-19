package Actor.StateMachine
{
   import Actor.ActorGameObject;
   import Actor.ActorView;
   import Brain.StateMachine.State;
   import Facade.DBFacade;
   
   public class ActorState extends State
   {
      
      protected var mDBFacade:DBFacade;
      
      protected var mActorGameObject:ActorGameObject;
      
      protected var mActorView:ActorView;
      
      public function ActorState(param1:DBFacade, param2:ActorGameObject, param3:ActorView, param4:String, param5:Function = null)
      {
         super(param4,param5);
         mDBFacade = param1;
         mActorGameObject = param2;
         mActorView = param3;
      }
      
      override public function destroy() : void
      {
         mDBFacade = null;
         mActorGameObject = null;
         mActorView = null;
         super.destroy();
      }
   }
}

