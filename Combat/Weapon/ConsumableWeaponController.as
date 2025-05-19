package Combat.Weapon
{
   import DistributedObjects.HeroGameObjectOwner;
   import Facade.DBFacade;
   
   public class ConsumableWeaponController extends WeaponController
   {
      
      private var consumableWeapon:ConsumableWeaponGameObject;
      
      public function ConsumableWeaponController(param1:DBFacade, param2:ConsumableWeaponGameObject, param3:HeroGameObjectOwner)
      {
         super(param1,param2,param3);
         consumableWeapon = param2;
      }
      
      public function consume() : void
      {
         if(consumableWeapon.canExecute() && consumableWeapon.getConsumableAttack() && consumableWeapon.getConsumableCount() > 0)
         {
            attack(consumableWeapon.getConsumableAttack().Id,false,1,consumableWeapon.getConsumableCount() > 1);
            consumableWeapon.consume();
         }
      }
      
      override protected function updateHudCooldown(param1:Boolean) : void
      {
         if(param1)
         {
            mDBFacade.hud.startConsumableCooldown(weapon.slot,mCoolDownTime / 1000);
         }
         else
         {
            mDBFacade.hud.stopConsumableCooldown(weapon.slot);
         }
      }
      
      override public function destroy() : void
      {
         mDBFacade.hud.stopConsumableCooldown(weapon.slot);
      }
   }
}

