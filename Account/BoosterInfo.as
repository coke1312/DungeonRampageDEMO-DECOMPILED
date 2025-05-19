package Account
{
   import Brain.Clock.GameClock;
   import Brain.Utils.TimeSpan;
   import Facade.DBFacade;
   import Facade.Locale;
   import GameMasterDictionary.GMBuff;
   import GameMasterDictionary.GMStackable;
   
   public class BoosterInfo extends InventoryBaseInfo
   {
      
      private var mTimestampEnd:String;
      
      private var mGMStackable:GMStackable;
      
      private var mBuff:GMBuff;
      
      public function BoosterInfo(param1:DBFacade, param2:Object)
      {
         super(param1,param2);
         mGMStackable = mDBFacade.gameMaster.stackableById.itemFor(mGMId);
         mBuff = mDBFacade.gameMaster.buffByConstant.itemFor(mGMStackable.Buff);
      }
      
      public function timeStamp() : String
      {
         return mTimestampEnd;
      }
      
      public function get StackInfo() : GMStackable
      {
         return mGMStackable;
      }
      
      public function get BuffInfo() : GMBuff
      {
         return mBuff;
      }
      
      public function getDisplayTimeLeft() : String
      {
         var _loc2_:DBInventoryInfo = mDBFacade.dbAccountInfo.inventoryInfo;
         var _loc1_:Date = _loc2_.dateBooster(this.gmId);
         if(_loc1_ == null)
         {
            return Locale.getString("EXPIRED");
         }
         var _loc3_:TimeSpan = new TimeSpan(_loc1_.time);
         return _loc3_.getTimeBetweenTimeSpanAndNow(true);
      }
      
      public function getEndDate() : Date
      {
         var _loc2_:DBInventoryInfo = mDBFacade.dbAccountInfo.inventoryInfo;
         return _loc2_.dateBooster(this.gmId);
      }
      
      public function getTimeLeft() : Number
      {
         var _loc2_:DBInventoryInfo = mDBFacade.dbAccountInfo.inventoryInfo;
         var _loc1_:Date = _loc2_.dateBooster(this.gmId);
         if(_loc1_ == null)
         {
            return 0;
         }
         return _loc1_.getTime() - GameClock.getWebServerTime();
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
         mTimestampEnd = param1.timestamp_end as String;
         mIsNew = false;
      }
   }
}

