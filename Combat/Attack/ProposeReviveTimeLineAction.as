package Combat.Attack
{
   import Actor.ActorGameObject;
   import Actor.ActorView;
   import DistributedObjects.HeroGameObjectOwner;
   import Facade.DBFacade;
   
   public class ProposeReviveTimeLineAction extends AttackTimelineAction
   {
      
      public static const TYPE:String = "proposeRevive";
      
      public function ProposeReviveTimeLineAction(param1:ActorGameObject, param2:ActorView, param3:DBFacade)
      {
         super(param1,param2,param3);
      }
      
      public static function buildFromJson(param1:ActorGameObject, param2:ActorView, param3:DBFacade, param4:Object) : ProposeReviveTimeLineAction
      {
         return new ProposeReviveTimeLineAction(param1,param2,param3);
      }
      
      override public function execute(param1:ScriptTimeline) : void
      {
         super.execute(param1);
         var _loc2_:HeroGameObjectOwner = mActorGameObject as HeroGameObjectOwner;
         if(_loc2_)
         {
            _loc2_.proposeRevive();
         }
      }
   }
}

