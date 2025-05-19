package Events
{
   import flash.display.MovieClip;
   import flash.events.Event;
   
   public class FriendSummaryNewsFeedEvent extends Event
   {
      
      public static const NAME:String = "FRIEND_SUMMARY_NEWS_FEED_MESSAGE_EVENT";
      
      public static var FRIEND_NAME_HIGHLIGHT_COLOR:uint = 65280;
      
      private var mFriendName:String;
      
      private var mIsFriendNameInFront:Boolean;
      
      private var mMessage:String;
      
      private var mPic:MovieClip;
      
      public function FriendSummaryNewsFeedEvent(param1:String, param2:String, param3:MovieClip, param4:String, param5:Boolean = false, param6:Boolean = false, param7:Boolean = false)
      {
         mFriendName = param4;
         mIsFriendNameInFront = param5;
         mMessage = param2;
         mPic = param3;
         super(param1,param6,param7);
      }
      
      public function get friendName() : String
      {
         return mFriendName;
      }
      
      public function get message() : String
      {
         return mMessage;
      }
      
      public function get isFriendNameInFront() : Boolean
      {
         return mIsFriendNameInFront;
      }
      
      public function get pic() : MovieClip
      {
         return mPic;
      }
   }
}

