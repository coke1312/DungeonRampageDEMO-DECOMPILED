package Events
{
   import Account.DBAccountInfo;
   import flash.events.Event;
   
   public class DBAccountLoadedEvent extends Event
   {
      
      public static const EVENT_NAME:String = "DB_ACCOUNT_INFO_LOADED";
      
      protected var mDBAccountInfo:DBAccountInfo;
      
      public function DBAccountLoadedEvent(param1:DBAccountInfo, param2:Boolean = false, param3:Boolean = false)
      {
         super("DB_ACCOUNT_INFO_LOADED",param2,param3);
         mDBAccountInfo = param1;
      }
      
      public function get dbAccountInfo() : DBAccountInfo
      {
         return mDBAccountInfo;
      }
   }
}

