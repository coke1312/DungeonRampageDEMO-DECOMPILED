package Combat.Attack
{
   import Actor.ActorGameObject;
   import Actor.ActorView;
   import Combat.Weapon.WeaponController;
   import Facade.DBFacade;
   
   public class QueueAttackTimelineAction extends AttackTimelineAction
   {
      
      public static const TYPE:String = "queueAttack";
      
      private var mWeaponController:WeaponController;
      
      private var mAttackToQueue:String;
      
      public function QueueAttackTimelineAction(param1:ActorGameObject, param2:ActorView, param3:DBFacade, param4:WeaponController, param5:Object)
      {
         super(param1,param2,param3);
         mWeaponController = param4;
         mAttackToQueue = param5.attackName;
      }
      
      public static function buildFromJson(param1:ActorGameObject, param2:ActorView, param3:DBFacade, param4:WeaponController, param5:Object) : QueueAttackTimelineAction
      {
         if(param1.isOwner)
         {
            return new QueueAttackTimelineAction(param1,param2,param3,param4,param5);
         }
         return null;
      }
      
      override public function execute(param1:ScriptTimeline) : void
      {
         super.execute(param1);
         mWeaponController.queueAttack(mAttackToQueue);
      }
      
      override public function destroy() : void
      {
         mWeaponController = null;
         super.destroy();
      }
   }
}

