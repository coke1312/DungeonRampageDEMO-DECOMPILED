package Events
{
   public class PlayerIsTypingEvent extends GameObjectEvent
   {
      
      public static const PLAYER_IS_TYPING:String = "PLAYER_IS_TYPING";
      
      public static const PLAYER_CHAT_FOCUS_IN:String = "CHAT_BOX_FOCUS_IN";
      
      public static const PLAYER_CHAT_FOCUS_OUT:String = "CHAT_BOX_FOCUS_OUT";
      
      public var subtype:String;
      
      public function PlayerIsTypingEvent(param1:String, param2:uint, param3:String, param4:Boolean = false, param5:Boolean = false)
      {
         subtype = param3;
         super(param1,param2,param4,param5);
      }
   }
}

