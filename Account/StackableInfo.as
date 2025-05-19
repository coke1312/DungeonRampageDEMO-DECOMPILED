package Account
{
   import Facade.DBFacade;
   import GameMasterDictionary.GMStackable;
   
   public class StackableInfo extends InventoryBaseInfo
   {
      
      private var mCount:uint;
      
      private var mGMStackable:GMStackable;
      
      private var mConsumableSlot:int = -1;
      
      public function StackableInfo(param1:DBFacade, param2:Object, param3:GMStackable = null)
      {
         if(param2 == null)
         {
            mDBFacade = param1;
            mGMStackable = param3;
         }
         else
         {
            super(param1,param2);
            mGMStackable = mDBFacade.gameMaster.stackableById.itemFor(mGMId);
         }
         mGMInventoryBase = mGMStackable;
      }
      
      public function get gmStackable() : GMStackable
      {
         return mGMStackable;
      }
      
      override public function get isEquipped() : Boolean
      {
         return this.gmStackable && mConsumableSlot != -1 && this.gmStackable.AccountBooster == false;
      }
      
      public function get equipSlot() : int
      {
         return mConsumableSlot;
      }
      
      public function get count() : uint
      {
         return mCount;
      }
      
      public function set count(param1:uint) : void
      {
         mCount = param1;
      }
      
      override protected function parseJson(param1:Object) : void
      {
         if(param1 == null)
         {
            return;
         }
         mGMId = param1.stack_id as uint;
         mAccountId = param1.account_id as uint;
         mDatabaseId = param1.id as uint;
         mCount = param1.count as uint;
         mIsNew = false;
         mConsumableSlot = -1;
      }
      
      public function setPropertiesAsConsumable(param1:uint, param2:uint, param3:uint) : void
      {
         mGMId = param1;
         mAccountId = 0;
         mDatabaseId = 0;
         mCount = param3;
         mConsumableSlot = param2;
         mIsNew = false;
      }
      
      public function setConsumableSlot(param1:uint) : void
      {
         mConsumableSlot = param1;
      }
      
      override public function get hasColoredBackground() : Boolean
      {
         return false;
      }
      
      override public function get backgroundIconName() : String
      {
         return "";
      }
      
      override public function get backgroundSwfPath() : String
      {
         return "";
      }
      
      override public function hasGMPropertySetup() : Boolean
      {
         return mGMStackable != null;
      }
      
      public function get consumableSlot() : int
      {
         return mConsumableSlot;
      }
   }
}

