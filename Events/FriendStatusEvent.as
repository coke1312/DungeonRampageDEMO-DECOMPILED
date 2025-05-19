package Events
{
   import flash.events.Event;
   
   public class FriendStatusEvent extends Event
   {
      
      public static const FRIEND_ONLINE_STATUS:String = "FRIEND_STATUS_EVENT";
      
      public static const FRIEND_DUNGEON_STATUS:String = "FRIEND_DUNGEON_STATUS_EVENT";
      
      private var mFriendId:uint;
      
      private var mStatus:Boolean;
      
      public function FriendStatusEvent(param1:String, param2:uint, param3:Boolean, param4:Boolean = false, param5:Boolean = false)
      {
         super(param1,param4,param5);
         mFriendId = param2;
         mStatus = param3;
      }
      
      public function get friendId() : uint
      {
         return mFriendId;
      }
      
      public function get status() : Boolean
      {
         return mStatus;
      }
   }
}

