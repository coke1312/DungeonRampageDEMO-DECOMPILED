package Combat.Attack
{
   import Actor.ActorGameObject;
   import Actor.ActorView;
   import Combat.Weapon.WeaponController;
   import Facade.DBFacade;
   
   public class CoolDownAttackTimelineAction extends AttackTimelineAction
   {
      
      public static const TYPE:String = "startCooldown";
      
      private var mWeaponController:WeaponController;
      
      public function CoolDownAttackTimelineAction(param1:ActorGameObject, param2:ActorView, param3:DBFacade, param4:WeaponController, param5:Object)
      {
         super(param1,param2,param3);
         mWeaponController = param4;
      }
      
      public static function buildFromJson(param1:ActorGameObject, param2:ActorView, param3:DBFacade, param4:WeaponController, param5:Object) : CoolDownAttackTimelineAction
      {
         if(param1.isOwner)
         {
            return new CoolDownAttackTimelineAction(param1,param2,param3,param4,param5);
         }
         return null;
      }
      
      override public function execute(param1:ScriptTimeline) : void
      {
         super.execute(param1);
         mWeaponController.startCooldown();
      }
      
      override public function destroy() : void
      {
         mWeaponController = null;
         super.destroy();
      }
   }
}

