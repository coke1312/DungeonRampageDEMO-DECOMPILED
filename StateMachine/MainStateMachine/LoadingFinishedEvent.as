package StateMachine.MainStateMachine
{
   import Account.DBAccountInfo;
   import flash.events.Event;
   
   public class LoadingFinishedEvent extends Event
   {
      
      public static const EVENT_NAME:String = "LoadingFinishedEvent";
      
      private var mDBAccountInfo:DBAccountInfo;
      
      public function LoadingFinishedEvent(param1:DBAccountInfo, param2:Boolean = false, param3:Boolean = false)
      {
         super("LoadingFinishedEvent",param2,param3);
         mDBAccountInfo = param1;
      }
      
      public function get dbAccountInfo() : DBAccountInfo
      {
         return mDBAccountInfo;
      }
   }
}

