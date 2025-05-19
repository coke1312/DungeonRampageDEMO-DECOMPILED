package Events
{
   import flash.events.Event;
   
   public class ChatLogEvent extends Event
   {
      
      public static const NAME:String = "CHAT_LOG_EVENT";
      
      private var mMessage:String;
      
      private var mChatLogType:String;
      
      private var mPlayerName:String;
      
      public function ChatLogEvent(param1:String, param2:String, param3:String, param4:String = "", param5:Boolean = false, param6:Boolean = false)
      {
         super(param1,param5,param6);
         mMessage = param2;
         mChatLogType = param3;
         mPlayerName = param4;
      }
      
      public function get chat() : String
      {
         return mMessage;
      }
      
      public function get chatLogType() : String
      {
         return mChatLogType;
      }
      
      public function get playerName() : String
      {
         return mPlayerName;
      }
   }
}

