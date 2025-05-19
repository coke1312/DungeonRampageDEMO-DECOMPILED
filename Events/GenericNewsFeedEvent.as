package Events
{
   import flash.events.Event;
   
   public class GenericNewsFeedEvent extends Event
   {
      
      public static const NAME:String = "GENERIC_NEWS_FEED_MESSAGE_EVENT";
      
      private var mMessage:String;
      
      private var mPicSwfLocation:String;
      
      private var mPicSwfClassName:String;
      
      public function GenericNewsFeedEvent(param1:String, param2:String, param3:String = "", param4:String = "", param5:Boolean = false, param6:Boolean = false)
      {
         mMessage = param2;
         mPicSwfLocation = param3;
         mPicSwfClassName = param4;
         super(param1,param5,param6);
      }
      
      public function get message() : String
      {
         return mMessage;
      }
      
      public function get picLocation() : String
      {
         return mPicSwfLocation;
      }
      
      public function get picClassName() : String
      {
         return mPicSwfClassName;
      }
   }
}

