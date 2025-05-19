package Events
{
   public class ChatEvent extends GameObjectEvent
   {
      
      public static const INCOMING_CHAT_UPDATE:String = "ChatEvent_INCOMING_CHAT_UPDATE";
      
      public static const OUTGOING_CHAT_UPDATE:String = "ChatEvent_OUTGOING_CHAT_UPDATE";
      
      public var message:String;
      
      public function ChatEvent(param1:String, param2:uint, param3:String, param4:Boolean = false, param5:Boolean = false)
      {
         this.message = param3;
         super(param1,param2,param4,param5);
      }
   }
}

