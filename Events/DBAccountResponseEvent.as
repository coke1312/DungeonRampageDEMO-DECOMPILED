package Events
{
   import Account.DBAccountInfo;
   import flash.events.Event;
   
   public class DBAccountResponseEvent extends Event
   {
      
      public static const EVENT_NAME:String = "DB_ACCOUNT_INFO_RESPONSE";
      
      protected var mDBAccountInfo:DBAccountInfo;
      
      public function DBAccountResponseEvent(param1:DBAccountInfo, param2:Boolean = false, param3:Boolean = false)
      {
         super("DB_ACCOUNT_INFO_RESPONSE",param2,param3);
         mDBAccountInfo = param1;
         if(param1.inventoryInfo.canShowInfiniteIsland())
         {
            param1.getAllMapnodeScoresRPC(mDBAccountInfo.id);
         }
      }
      
      public function get dbAccountInfo() : DBAccountInfo
      {
         return mDBAccountInfo;
      }
   }
}

