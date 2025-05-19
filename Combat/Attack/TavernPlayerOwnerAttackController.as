package Combat.Attack
{
   import Actor.Player.HeroView;
   import DistributedObjects.HeroGameObjectOwner;
   import Facade.DBFacade;
   
   public class TavernPlayerOwnerAttackController extends PlayerOwnerAttackController
   {
      
      public function TavernPlayerOwnerAttackController(param1:HeroGameObjectOwner, param2:HeroView, param3:DBFacade)
      {
         super(param1,param2,param3);
      }
      
      override protected function canQueueWeaponDown(param1:PotentialWeaponInputQueueStruct) : Boolean
      {
         return true;
      }
      
      override protected function canQueueWeaponUp(param1:PotentialWeaponInputQueueStruct) : Boolean
      {
         return true;
      }
      
      override protected function tryAttack() : void
      {
         if(mNextWeaponCommand == null)
         {
            return;
         }
         mDistributedPlayerOwner.currentWeaponIndex = mNextWeaponCommand.weaponIndex;
         mNextWeaponCommand = null;
      }
   }
}

