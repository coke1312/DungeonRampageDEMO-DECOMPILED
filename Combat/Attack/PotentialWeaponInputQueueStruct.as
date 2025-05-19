package Combat.Attack
{
   import Combat.Weapon.WeaponController;
   
   public class PotentialWeaponInputQueueStruct
   {
      
      private var mWeaponController:WeaponController;
      
      private var mDown:Boolean;
      
      private var mWeaponIndex:uint;
      
      private var mAutoAim:Boolean;
      
      public function PotentialWeaponInputQueueStruct(param1:WeaponController, param2:uint, param3:Boolean, param4:Boolean = true)
      {
         super();
         mWeaponController = param1;
         mWeaponIndex = param2;
         mDown = param3;
         mAutoAim = param4;
      }
      
      public function get down() : Boolean
      {
         return mDown;
      }
      
      public function get weaponController() : WeaponController
      {
         return mWeaponController;
      }
      
      public function get weaponIndex() : uint
      {
         return mWeaponIndex;
      }
      
      public function get autoAim() : Boolean
      {
         return mAutoAim;
      }
   }
}

