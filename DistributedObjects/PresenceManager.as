package DistributedObjects
{
   import Brain.Event.EventComponent;
   import Brain.GameObject.GameObject;
   import Events.FriendStatusEvent;
   import Facade.DBFacade;
   import GeneratedCode.IPresenceManager;
   import GeneratedCode.PresenceManagerNetworkComponent;
   import flash.events.Event;
   import org.as3commons.collections.Map;
   
   public class PresenceManager extends GameObject implements IPresenceManager
   {
      
      private static var mInstance:PresenceManager;
      
      private var mDBFacade:DBFacade;
      
      private var mPresence:Map = new Map();
      
      private var mEventComponent:EventComponent;
      
      private var mNetworkComponent:PresenceManagerNetworkComponent;
      
      public function PresenceManager(param1:DBFacade, param2:uint = 0)
      {
         mEventComponent = new EventComponent(param1);
         mDBFacade = param1;
         super(param1,param2);
         mInstance = this;
      }
      
      public static function instance() : PresenceManager
      {
         return mInstance;
      }
      
      public function isOnline(param1:uint) : Boolean
      {
         return mPresence.hasKey(param1);
      }
      
      public function isInDungeon(param1:uint) : Boolean
      {
         return mPresence.hasKey(param1) && mPresence.itemFor(param1) != 0;
      }
      
      public function InDungeonId(param1:uint) : uint
      {
         if(mPresence.hasKey(param1))
         {
            return mPresence.itemFor(param1);
         }
         return 0;
      }
      
      public function setNetworkComponentPresenceManager(param1:PresenceManagerNetworkComponent) : void
      {
         mNetworkComponent = param1;
      }
      
      public function postGenerate() : void
      {
         mDBFacade.mDistributedObjectManager.mPresenceManager = this;
      }
      
      public function friendState(param1:uint, param2:uint, param3:uint) : void
      {
         var _loc4_:* = 0;
         if(param1 == 0)
         {
            if(mPresence.hasKey(param2))
            {
               mPresence.removeKey(param2);
               mEventComponent.dispatchEvent(new FriendStatusEvent("FRIEND_STATUS_EVENT",param2,false));
            }
         }
         else if(!mPresence.hasKey(param2))
         {
            mPresence.add(param2,param3);
            mEventComponent.dispatchEvent(new FriendStatusEvent("FRIEND_STATUS_EVENT",param2,true));
         }
         else
         {
            _loc4_ = mPresence.itemFor(param2);
            if(_loc4_ != param3)
            {
               mPresence.replaceFor(param2,param3);
            }
         }
         mEventComponent.dispatchEvent(new Event("REFRESH_FRIENDS_EVENT"));
      }
      
      public function addFriends(param1:Vector.<uint>) : void
      {
         mNetworkComponent.send_addFriends(param1);
      }
   }
}

