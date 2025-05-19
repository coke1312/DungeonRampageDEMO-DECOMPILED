package DistributedObjects
{
   import Brain.GameObject.GameObject;
   import Events.ChatEvent;
   import Events.ChatLogEvent;
   import Events.FriendStatusEvent;
   import Events.PlayerExitEvent;
   import Events.PlayerIsTypingEvent;
   import Facade.DBFacade;
   import GeneratedCode.IPlayerGameObject;
   import GeneratedCode.PlayerGameObjectNetworkComponent;
   import UI.UIChatLog;
   
   public class PlayerGameObject extends GameObject implements IPlayerGameObject
   {
      
      protected var mName:String;
      
      protected var mFacebookHelper:FacebookHelper;
      
      protected var mDBFacade:DBFacade;
      
      public function PlayerGameObject(param1:DBFacade, param2:uint = 0)
      {
         super(param1,param2);
         mDBFacade = param1;
         mFacebookHelper = new FacebookHelper(param1,param2);
         mFacade.eventManager.dispatchEvent(new FriendStatusEvent("FRIEND_DUNGEON_STATUS_EVENT",this.id,true));
      }
      
      public function setNetworkComponentPlayerGameObject(param1:PlayerGameObjectNetworkComponent) : void
      {
      }
      
      public function postGenerate() : void
      {
      }
      
      public function set screenName(param1:String) : void
      {
         mName = param1;
      }
      
      public function get screenName() : String
      {
         return mName;
      }
      
      public function get facebookId() : String
      {
         if(mFacebookHelper)
         {
            return mFacebookHelper.facebookId;
         }
         return "";
      }
      
      public function get isFriend() : Boolean
      {
         return mFacebookHelper.isFriend;
      }
      
      public function Chat(param1:String) : void
      {
         mFacade.eventManager.dispatchEvent(new ChatEvent("ChatEvent_INCOMING_CHAT_UPDATE",id,param1));
         mFacade.eventManager.dispatchEvent(new ChatLogEvent("CHAT_LOG_EVENT",param1,UIChatLog.CHAT_TYPE,mName));
      }
      
      public function ShowPlayerIsTyping(param1:uint) : void
      {
         if(param1)
         {
            mFacade.eventManager.dispatchEvent(new PlayerIsTypingEvent("PLAYER_IS_TYPING",id,"CHAT_BOX_FOCUS_IN"));
         }
         else
         {
            mFacade.eventManager.dispatchEvent(new PlayerIsTypingEvent("PLAYER_IS_TYPING",id,"CHAT_BOX_FOCUS_OUT"));
         }
      }
      
      override public function destroy() : void
      {
         mFacade.eventManager.dispatchEvent(new FriendStatusEvent("FRIEND_DUNGEON_STATUS_EVENT",this.id,false));
         mFacade.eventManager.dispatchEvent(new PlayerExitEvent(id));
         if(mFacebookHelper)
         {
            mFacebookHelper.destroy();
         }
         mFacebookHelper = null;
         mDBFacade = null;
         super.destroy();
      }
      
      public function get basicCurrency() : uint
      {
         return mDBFacade.dbAccountInfo.basicCurrency;
      }
   }
}

import Account.FriendInfo;
import Events.FacebookIdReceivedEvent;
import Facade.DBFacade;

class FacebookHelper
{
   
   private var mFacebookId:String;
   
   private var mIsFriend:Boolean = false;
   
   private var mPlayerId:uint;
   
   private var mDBFacade:DBFacade;
   
   public function FacebookHelper(param1:DBFacade, param2:uint)
   {
      super();
      mDBFacade = param1;
      mPlayerId = param2;
      getFacebookId();
   }
   
   private function getFacebookId() : void
   {
      var friend:FriendInfo;
      if(mDBFacade.dbAccountInfo.id == mPlayerId)
      {
         mFacebookId = mDBFacade.facebookPlayerId;
      }
      else if(mDBFacade.dbAccountInfo.friendInfos.hasKey(mPlayerId))
      {
         mIsFriend = true;
         friend = mDBFacade.dbAccountInfo.friendInfos.itemFor(mPlayerId);
         if(friend)
         {
            mFacebookId = friend.facebookId;
         }
      }
      else
      {
         mDBFacade.dbAccountInfo.getFacebookIdRPC(mPlayerId,function(param1:String):void
         {
            if(param1 != "")
            {
               mDBFacade.eventManager.dispatchEvent(new FacebookIdReceivedEvent("FACEBOOK_ID_RECEIVED_EVENT",mPlayerId,param1));
            }
            mFacebookId = param1;
         });
      }
   }
   
   public function get facebookId() : String
   {
      return mFacebookId;
   }
   
   public function get isFriend() : Boolean
   {
      return mIsFriend;
   }
   
   public function destroy() : void
   {
      mDBFacade = null;
   }
}
