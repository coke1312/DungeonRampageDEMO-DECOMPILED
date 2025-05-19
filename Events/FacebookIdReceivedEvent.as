package Events
{
   public class FacebookIdReceivedEvent extends GameObjectEvent
   {
      
      public static const NAME:String = "FACEBOOK_ID_RECEIVED_EVENT";
      
      private var mFacebookId:String;
      
      public function FacebookIdReceivedEvent(param1:String, param2:uint, param3:String, param4:Boolean = false, param5:Boolean = false)
      {
         mFacebookId = param3;
         super(param1,param2,param4,param5);
      }
      
      public function get facebookId() : String
      {
         return mFacebookId;
      }
   }
}

