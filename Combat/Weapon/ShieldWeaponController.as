package Combat.Weapon
{
   import DistributedObjects.HeroGameObjectOwner;
   import Facade.DBFacade;
   
   public class ShieldWeaponController extends WeaponController
   {
      
      public function ShieldWeaponController(param1:DBFacade, param2:WeaponGameObject, param3:HeroGameObjectOwner)
      {
         super(param1,param2,param3);
      }
      
      override public function onWeaponDown(param1:Boolean = true) : void
      {
         var _loc2_:* = 0;
         if(!mWeaponDownActive)
         {
            _loc2_ = this.getNextAttackId();
            mWeaponDownActive = true;
            attack(_loc2_,false);
         }
      }
      
      override public function onWeaponUp(param1:Boolean = true) : void
      {
         mWeaponDownActive = false;
         stopCurrentTimeline();
      }
      
      override public function canCombo() : Boolean
      {
         return true;
      }
   }
}

