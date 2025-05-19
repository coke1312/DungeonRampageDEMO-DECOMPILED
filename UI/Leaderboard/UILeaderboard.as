package UI.Leaderboard
{
   import Account.FriendInfo;
   import Brain.AssetRepository.AssetLoadingComponent;
   import Brain.AssetRepository.SwfAsset;
   import Brain.Event.EventComponent;
   import Brain.Render.MovieClipRenderController;
   import Brain.SceneGraph.SceneGraphComponent;
   import Brain.SceneGraph.SceneGraphManager;
   import Brain.UI.UIButton;
   import Brain.WorkLoop.LogicalWorkComponent;
   import Brain.jsonRPC.JSONRPCService;
   import Facade.DBFacade;
   import Facade.Locale;
   import Town.TownStateMachine;
   import UI.DBUIOneButtonPopup;
   import UI.DBUITwoButtonPopup;
   import flash.display.MovieClip;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.text.TextFormat;
   import org.as3commons.collections.Map;
   
   public class UILeaderboard
   {
      
      private static var FRIEND_NAME_HIGHLIGHT_COLOR:uint = 16764232;
      
      public static const LEADERBOARD_INITIALIZED_EVENT_NAME:String = "LEADERBOARD_INITIALIZED_EVENT";
      
      public static const REFRESH_FRIENDS_EVENT_NAME:String = "REFRESH_FRIENDS_EVENT";
      
      public static const REVERSE_FRIEND_SLOT:Boolean = false;
      
      private var mAssetLoadingComponent:AssetLoadingComponent;
      
      private var mSceneGraphComponent:SceneGraphComponent;
      
      private var mLogicalWorkComponent:LogicalWorkComponent;
      
      private var mEventComponent:EventComponent;
      
      private var mDBFacade:DBFacade;
      
      public var townSwf:SwfAsset;
      
      private var mRootMovieClip:MovieClip;
      
      private var mLeaderboard:MovieClip;
      
      private var mOnlinePopup:MovieClip;
      
      private var mOfflinePopup:MovieClip;
      
      private var mMessageFriendButton:UIButton;
      
      private var mRemoveOnlineFriendButton:UIButton;
      
      private var mRemoveOfflineFriendButton:UIButton;
      
      private var mGiftFriendButton:UIButton;
      
      private var mScrollRightButton:UIButton;
      
      private var mScrollLeftButton:UIButton;
      
      private var mScrollPageRightButton:UIButton;
      
      private var mScrollPageLeftButton:UIButton;
      
      private var mFBRemoveFriendPopup:DBUIOneButtonPopup;
      
      private var mDRRemoveFriendPopup:DBUITwoButtonPopup;
      
      private var mFriendSlots:Vector.<LeaderboardFriendSlot>;
      
      private var mInviteFriendSlot:LeaderboardFriendSlot;
      
      private var mInviteFriendButton:UIButton;
      
      private var mOnlineFriends:Vector.<FriendInfo>;
      
      private var mOfflineFriends:Vector.<FriendInfo>;
      
      private var mFriendsLength:uint;
      
      private var mCurrentPopupIndex:uint;
      
      private var mScrollIndex:int = 0;
      
      private var mRefreshLeaderboard:Boolean;
      
      private var mCurrentStateName:String;
      
      private var mStoreCallback:Function;
      
      private var mGetGiftsCallback:Function;
      
      public var initialized:Boolean;
      
      private var mTownStateMachine:TownStateMachine;
      
      private var mFriendManagementButton:UIButton;
      
      private var mAlert:MovieClip;
      
      private var mAlertRenderer:MovieClipRenderController;
      
      public function UILeaderboard(param1:DBFacade, param2:SwfAsset, param3:Function, param4:Function, param5:TownStateMachine)
      {
         super();
         mDBFacade = param1;
         townSwf = param2;
         mRootMovieClip = param2.root;
         mStoreCallback = param3;
         mGetGiftsCallback = param4;
         mFriendSlots = new Vector.<LeaderboardFriendSlot>();
         mOnlineFriends = new Vector.<FriendInfo>();
         mOfflineFriends = new Vector.<FriendInfo>();
         mAssetLoadingComponent = new AssetLoadingComponent(param1);
         mSceneGraphComponent = new SceneGraphComponent(param1);
         mLogicalWorkComponent = new LogicalWorkComponent(param1);
         mEventComponent = new EventComponent(mDBFacade);
         mTownStateMachine = param5;
         mAssetLoadingComponent.getSwfAsset(DBFacade.buildFullDownloadPath("Resources/Art2D/UI/db_UI_leaderboard.swf"),leaderboardLoaded);
      }
      
      public function loadRemoveFriendPopup(param1:FriendInfo) : void
      {
         var tf:TextFormat;
         var info:FriendInfo = param1;
         var mcClass:Class = townSwf.getClass("popup");
         var colorizeStart:uint = uint(Locale.getString("LEADERBOARD_DR_REMOVE_FRIEND_POPUP_DESC_1").length);
         if(info.isDRFriend)
         {
            mDRRemoveFriendPopup = new DBUITwoButtonPopup(mDBFacade,Locale.getString("LEADERBOARD_DR_REMOVE_FRIEND_POPUP_TITLE"),Locale.getString("LEADERBOARD_DR_REMOVE_FRIEND_POPUP_DESC_1") + info.name + Locale.getString("LEADERBOARD_DR_REMOVE_FRIEND_POPUP_DESC_2"),Locale.getString("REMOVE"),function():void
            {
               var _loc2_:Array = [];
               _loc2_.push(info.id);
               var _loc1_:Function = JSONRPCService.getFunction("DRFriendRemove",mDBFacade.rpcRoot + "friendrequests");
               _loc1_(mDBFacade.accountId,_loc2_,mDBFacade.validationToken,mDBFacade.dbAccountInfo.removeFriendCallback);
               mDBFacade.metrics.log("DRFriendRemove",{"friendId":info.id.toString()});
            },Locale.getString("CANCEL"),null);
            tf = new TextFormat();
            tf.color = FRIEND_NAME_HIGHLIGHT_COLOR;
            mDRRemoveFriendPopup.colorizeMessage(tf,colorizeStart,colorizeStart + info.name.length);
         }
         else if(info.facebookId != null && info.facebookId != "")
         {
            mFBRemoveFriendPopup = new DBUIOneButtonPopup(mDBFacade,Locale.getString("LEADERBOARD_FB_REMOVE_FRIEND_POPUP_TITLE"),Locale.getString("LEADERBOARD_FB_REMOVE_FRIEND_POPUP_DESC"),Locale.getString("OK"),null);
         }
         else if(info.kongregateId != null && info.kongregateId != "")
         {
            mFBRemoveFriendPopup = new DBUIOneButtonPopup(mDBFacade,Locale.getString("LEADERBOARD_KG_REMOVE_FRIEND_POPUP_TITLE"),Locale.getString("LEADERBOARD_KG_REMOVE_FRIEND_POPUP_DESC"),Locale.getString("OK"),null);
         }
      }
      
      private function leaderboardLoaded(param1:SwfAsset) : void
      {
         if(!param1)
         {
            return;
         }
         loadOnlinePopup(param1);
         loadOfflinePopup(param1);
         loadLeaderboard(param1);
         setInitialScrollBarStatus();
         initialized = true;
         mEventComponent.dispatchEvent(new Event("LEADERBOARD_INITIALIZED_EVENT"));
         getFriendData();
      }
      
      private function loadOnlinePopup(param1:SwfAsset) : void
      {
         var swfAsset:SwfAsset = param1;
         var mcClass:Class = swfAsset.getClass("DR_leaderboard_online_tooltip");
         mOnlinePopup = new mcClass();
         if(!mOnlinePopup)
         {
            return;
         }
         mRootMovieClip.addChild(mOnlinePopup);
         mOnlinePopup.visible = false;
         mGiftFriendButton = new UIButton(mDBFacade,mOnlinePopup.join_friend);
         mGiftFriendButton.label.text = Locale.getString("LEADERBOARD_GIFT_FRIEND_BUTTON");
         mGiftFriendButton.releaseCallback = function():void
         {
            if(mDBFacade.dbConfigManager.getConfigBoolean("FUFB",false))
            {
               mDBFacade.errorPopup("GIFTING CURRENTLY DISABLED","Sorry for the inconvenience, we are looking into resolving the issue.");
               return;
            }
            if(mStoreCallback != null)
            {
               mStoreCallback();
            }
         };
         mRemoveOnlineFriendButton = new UIButton(mDBFacade,mOnlinePopup.remove_friend);
         mRemoveOnlineFriendButton.label.text = Locale.getString("LEADERBOARD_REMOVE_FRIEND_BUTTON");
         mRemoveOnlineFriendButton.releaseCallback = removeFriends;
         mOnlinePopup.nextassist.mouseEnabled = false;
         mOnlinePopup.nextassist.text = Locale.getString("LEADERBOARD_NEXT_ASSIST");
         mOnlinePopup.nextassist.visible = false;
         mOnlinePopup.assist_time.visible = false;
         mOnlinePopup.addEventListener("rollOver",callStopOnPopupTimeToLiveTask);
         mOnlinePopup.addEventListener("rollOut",hidePopup);
      }
      
      private function loadOfflinePopup(param1:SwfAsset) : void
      {
         var _loc2_:Class = param1.getClass("DR_leaderboard_offline_tooltip");
         mOfflinePopup = new _loc2_();
         if(!mOfflinePopup)
         {
            return;
         }
         mRootMovieClip.addChild(mOfflinePopup);
         mOfflinePopup.visible = false;
         SceneGraphManager.setGrayScaleSaturation(mOfflinePopup.join_friend,10);
         mOfflinePopup.title_label.mouseEnabled = false;
         mOfflinePopup.title_label.text = Locale.getString("LEADERBOARD_OFFLINE_TEXT");
         mOfflinePopup.join_friend.label.mouseEnabled = false;
         mOfflinePopup.join_friend.label.text = Locale.getString("LEADERBOARD_JOIN_FRIEND_BUTTON");
         mOfflinePopup.nextassist.mouseEnabled = false;
         mOfflinePopup.nextassist.text = Locale.getString("LEADERBOARD_NEXT_ASSIST");
         mMessageFriendButton = new UIButton(mDBFacade,mOfflinePopup.message_friend);
         mMessageFriendButton.label.text = Locale.getString("LEADERBOARD_MESSAGE_FRIEND_BUTTON");
         disableMessageFriendButton();
         mRemoveOfflineFriendButton = new UIButton(mDBFacade,mOfflinePopup.remove_friend);
         mRemoveOfflineFriendButton.label.text = Locale.getString("LEADERBOARD_REMOVE_FRIEND_BUTTON");
         mRemoveOfflineFriendButton.releaseCallback = removeFriends;
         mOfflinePopup.nextassist.visible = false;
         mOfflinePopup.assist_time.visible = false;
         mOfflinePopup.addEventListener("rollOver",callStopOnPopupTimeToLiveTask);
         mOfflinePopup.addEventListener("rollOut",hidePopup);
      }
      
      private function loadLeaderboard(param1:SwfAsset) : void
      {
         var swfAsset:SwfAsset = param1;
         var leaderboard:Class = swfAsset.getClass("DR_leaderboard");
         mLeaderboard = new leaderboard();
         mLeaderboard.x = mDBFacade.viewWidth - mLeaderboard.width;
         mLeaderboard.y = mDBFacade.viewHeight - mLeaderboard.height;
         mRootMovieClip.addChild(mLeaderboard);
         mFriendSlots.push(new LeaderboardFriendSlot(mDBFacade,mLeaderboard.slot_0,this,0));
         mFriendSlots.push(new LeaderboardFriendSlot(mDBFacade,mLeaderboard.slot_1,this,1));
         mFriendSlots.push(new LeaderboardFriendSlot(mDBFacade,mLeaderboard.slot_2,this,2));
         mFriendSlots.push(new LeaderboardFriendSlot(mDBFacade,mLeaderboard.slot_3,this,3));
         mFriendSlots.push(new LeaderboardFriendSlot(mDBFacade,mLeaderboard.slot_4,this,4));
         mFriendSlots.push(new LeaderboardFriendSlot(mDBFacade,mLeaderboard.slot_5,this,5));
         mFriendSlots.push(new LeaderboardFriendSlot(mDBFacade,mLeaderboard.slot_6,this,6));
         mInviteFriendButton = new UIButton(mDBFacade,mLeaderboard.invite_friend);
         if(mDBFacade.isFacebookPlayer)
         {
            mInviteFriendButton.releaseCallback = inviteFriendFB;
         }
         else
         {
            mInviteFriendButton.releaseCallback = inviteFriendDR;
         }
         mScrollRightButton = new UIButton(mDBFacade,mLeaderboard.scrollRight);
         mScrollLeftButton = new UIButton(mDBFacade,mLeaderboard.scrollLeft);
         mScrollPageRightButton = new UIButton(mDBFacade,mLeaderboard.scrollPageRight);
         mScrollPageLeftButton = new UIButton(mDBFacade,mLeaderboard.scrollPageLeft);
         mScrollRightButton.releaseCallback = function():void
         {
            scrollLeaderboard(-1);
         };
         mScrollLeftButton.releaseCallback = function():void
         {
            scrollLeaderboard(1);
         };
         mScrollPageRightButton.releaseCallback = function():void
         {
            scrollLeaderboard(-mFriendSlots.length);
         };
         mScrollPageLeftButton.releaseCallback = function():void
         {
            scrollLeaderboard(mFriendSlots.length);
         };
         mDBFacade.dbAccountInfo.getIgnoredFriendData();
         mFriendManagementButton = new UIButton(mDBFacade,mLeaderboard.block_button);
         mFriendManagementButton.releaseCallback = function():void
         {
            mTownStateMachine.enterFriendManagementState();
         };
         mAlert = mLeaderboard.block_button.alert_icon;
         mAlertRenderer = new MovieClipRenderController(mDBFacade,mAlert);
         mAlertRenderer.play(0,true);
         mAlert.visible = false;
      }
      
      public function inviteFriendDR() : void
      {
         hidePopup();
         mDBFacade.metrics.log("InviteLeaderboardClickedDR");
         showDRInvitePopup();
      }
      
      public function inviteFriendFB() : void
      {
         hidePopup();
         if(mDBFacade.dbConfigManager.getConfigBoolean("FUFB",false))
         {
            mDBFacade.errorPopup("INVITE CURRENTLY DISABLED","Sorry for the inconvenience, we are looking into resolving the issue.");
            return;
         }
         mDBFacade.metrics.log("InviteLeaderboardClickedFB");
         mDBFacade.facebookController.genericFriendRequests();
      }
      
      public function showDRInvitePopup() : void
      {
         townStateMachine.setFriendManagementTabCategory(4);
         townStateMachine.enterFriendManagementState();
         townStateMachine.setFriendManagementTabCategory(1);
      }
      
      private function friendDataSuccessCallback() : void
      {
         if(mDBFacade)
         {
            loadFriends();
         }
         if(mEventComponent)
         {
            mEventComponent.addListener("REFRESH_FRIENDS_EVENT",checkToRefreshLeaderboard);
         }
         if(mGetGiftsCallback != null)
         {
            mGetGiftsCallback();
         }
      }
      
      public function getFriendData() : void
      {
         if(mDBFacade.dbAccountInfo.friendInfos.size > 0)
         {
            friendDataSuccessCallback();
            return;
         }
         mDBFacade.dbAccountInfo.getFriendData(friendDataSuccessCallback);
      }
      
      private function populateFriendSlots() : void
      {
         var _loc1_:* = 0;
         var _loc2_:* = 0;
         var _loc4_:uint = 0;
         var _loc3_:uint = 0;
         _loc1_ = 0;
         while(_loc1_ < mFriendSlots.length)
         {
            mFriendSlots[_loc1_].populateSlot(null);
            _loc2_ = uint(_loc1_ + mScrollIndex);
            if(_loc2_ < mOnlineFriends.length)
            {
               mFriendSlots[_loc1_].populateSlot(mOnlineFriends[_loc2_]);
            }
            else if(_loc2_ - mOnlineFriends.length < mOfflineFriends.length)
            {
               mFriendSlots[_loc1_].populateSlot(mOfflineFriends[_loc2_ - mOnlineFriends.length]);
            }
            _loc1_++;
         }
      }
      
      private function scrollLeaderboard(param1:int) : void
      {
         hidePopup();
         mScrollIndex += param1;
         if(mScrollIndex > mFriendsLength - mFriendSlots.length)
         {
            mScrollIndex = mFriendsLength - mFriendSlots.length;
         }
         if(mScrollIndex < 0 || mFriendsLength < mFriendSlots.length)
         {
            mScrollIndex = 0;
         }
         if(true)
         {
            if(mScrollIndex == 0)
            {
               mScrollRightButton.enabled = false;
               mScrollPageRightButton.enabled = false;
            }
            else
            {
               mScrollRightButton.enabled = true;
               mScrollPageRightButton.enabled = true;
            }
            if(mScrollIndex == mFriendsLength - mFriendSlots.length)
            {
               mScrollLeftButton.enabled = false;
               mScrollPageLeftButton.enabled = false;
            }
            else
            {
               mScrollLeftButton.enabled = true;
               mScrollPageLeftButton.enabled = true;
            }
         }
         else
         {
            if(mScrollIndex == 0)
            {
               mScrollLeftButton.enabled = false;
               mScrollPageLeftButton.enabled = false;
            }
            else
            {
               mScrollLeftButton.enabled = true;
               mScrollPageLeftButton.enabled = true;
            }
            if(mScrollIndex == mFriendsLength - mFriendSlots.length)
            {
               mScrollRightButton.enabled = false;
               mScrollPageRightButton.enabled = false;
            }
            else
            {
               mScrollRightButton.enabled = true;
               mScrollPageRightButton.enabled = true;
            }
         }
         populateFriendSlots();
      }
      
      private function loadFriends() : void
      {
         var _loc3_:* = null;
         var _loc2_:FriendInfo = null;
         var _loc4_:Map = mDBFacade.dbAccountInfo.friendInfos;
         var _loc1_:Array = _loc4_.keysToArray();
         mOfflineFriends.splice(0,mOfflineFriends.length);
         mOnlineFriends.splice(0,mOnlineFriends.length);
         for each(var _loc5_ in _loc1_)
         {
            _loc2_ = _loc4_.itemFor(_loc5_);
            if(_loc2_.id == mDBFacade.accountId)
            {
               _loc3_ = _loc2_;
            }
            else if(_loc2_.isOnline())
            {
               mOnlineFriends.push(_loc2_);
            }
            else
            {
               mOfflineFriends.push(_loc2_);
            }
         }
         sortFriends();
         mOnlineFriends.unshift(_loc3_);
         mFriendsLength = mOnlineFriends.length + mOfflineFriends.length;
         if(mFriendsLength <= mFriendSlots.length)
         {
            mScrollLeftButton.enabled = false;
            mScrollPageLeftButton.enabled = false;
         }
         populateFriendSlots();
      }
      
      private function removeFriends() : void
      {
      }
      
      private function sortFriends() : void
      {
         mOnlineFriends.sort(sortBasedOnFriendsHighestAvatarLevel);
         mOfflineFriends.sort(sortBasedOnFriendsHighestAvatarLevel);
      }
      
      private function sortBasedOnFriendsHighestAvatarLevel(param1:FriendInfo, param2:FriendInfo) : int
      {
         if(param1.trophies < param2.trophies)
         {
            return 1;
         }
         return -1;
      }
      
      public function hidePopup(param1:MouseEvent = null) : void
      {
         if(mRefreshLeaderboard)
         {
            refreshLeaderboard();
         }
         if(mOnlinePopup)
         {
            mOnlinePopup.visible = false;
         }
         if(mOfflinePopup)
         {
            mOfflinePopup.visible = false;
         }
      }
      
      public function set alert(param1:Boolean) : void
      {
         mAlert.visible = param1;
      }
      
      public function get onlinePopup() : MovieClip
      {
         return mOnlinePopup;
      }
      
      public function get offlinePopup() : MovieClip
      {
         return mOfflinePopup;
      }
      
      public function get messageFriend() : UIButton
      {
         return mMessageFriendButton;
      }
      
      public function get removeOnlineFriend() : UIButton
      {
         return mRemoveOnlineFriendButton;
      }
      
      public function get removeOfflineFriend() : UIButton
      {
         return mRemoveOfflineFriendButton;
      }
      
      public function get giftFriend() : UIButton
      {
         return mGiftFriendButton;
      }
      
      public function get FBRemoveFriendPopup() : DBUIOneButtonPopup
      {
         return mFBRemoveFriendPopup;
      }
      
      public function setRootMovieClip(param1:MovieClip) : void
      {
         mRootMovieClip = param1;
         if(mOnlinePopup)
         {
            mRootMovieClip.addChild(mOnlinePopup);
         }
         if(mOfflinePopup)
         {
            mRootMovieClip.addChild(mOfflinePopup);
         }
         if(mLeaderboard)
         {
            mRootMovieClip.addChild(mLeaderboard);
         }
      }
      
      public function setInitialScrollBarStatus() : void
      {
         if(true)
         {
            mScrollRightButton.enabled = false;
            mScrollPageRightButton.enabled = false;
         }
         else
         {
            mScrollLeftButton.enabled = false;
            mScrollPageLeftButton.enabled = false;
         }
      }
      
      private function checkToRefreshLeaderboard(param1:Event) : void
      {
         if(mOnlinePopup.visible || mOfflinePopup.visible)
         {
            mRefreshLeaderboard = true;
         }
         else
         {
            refreshLeaderboard();
         }
      }
      
      public function refreshLeaderboard() : void
      {
         mRefreshLeaderboard = false;
         hidePopup();
         loadFriends();
      }
      
      public function set currentPopupIndex(param1:uint) : void
      {
         mCurrentPopupIndex = param1;
      }
      
      public function get currentPopupIndex() : uint
      {
         return mCurrentPopupIndex;
      }
      
      public function get mustRefreshLeaderboard() : Boolean
      {
         return mRefreshLeaderboard;
      }
      
      public function callStopOnPopupTimeToLiveTask(param1:MouseEvent = null) : void
      {
         mFriendSlots[mCurrentPopupIndex].stopPopupTimeToLiveTask();
      }
      
      public function destroy() : void
      {
         initialized = false;
         mDBFacade = null;
         for each(var _loc2_ in mFriendSlots)
         {
            _loc2_.destroy();
            _loc2_ = null;
         }
         if(mInviteFriendSlot)
         {
            mInviteFriendSlot.destroy();
         }
         mInviteFriendSlot = null;
         if(mInviteFriendButton)
         {
            mInviteFriendButton.destroy();
         }
         mInviteFriendButton = null;
         if(mAlertRenderer != null)
         {
            mAlertRenderer.destroy();
         }
         mAlertRenderer = null;
         for each(var _loc3_ in mOnlineFriends)
         {
            _loc3_ = null;
         }
         for each(var _loc1_ in mOfflineFriends)
         {
            _loc1_ = null;
         }
         if(mEventComponent)
         {
            mEventComponent.destroy();
         }
         mEventComponent = null;
         if(mAssetLoadingComponent)
         {
            mAssetLoadingComponent.destroy();
         }
         mAssetLoadingComponent = null;
         if(mSceneGraphComponent)
         {
            mSceneGraphComponent.destroy();
         }
         mSceneGraphComponent = null;
         if(mLogicalWorkComponent)
         {
            mLogicalWorkComponent.destroy();
         }
         mLogicalWorkComponent = null;
         if(mMessageFriendButton)
         {
            mMessageFriendButton.destroy();
         }
         mMessageFriendButton = null;
         if(mRemoveOnlineFriendButton)
         {
            mRemoveOnlineFriendButton.destroy();
         }
         mRemoveOnlineFriendButton = null;
         if(mRemoveOfflineFriendButton)
         {
            mRemoveOfflineFriendButton.destroy();
         }
         mRemoveOfflineFriendButton = null;
         if(mGiftFriendButton)
         {
            mGiftFriendButton.destroy();
         }
         mGiftFriendButton = null;
         if(mScrollRightButton)
         {
            mScrollRightButton.destroy();
         }
         mScrollRightButton = null;
         if(mScrollLeftButton)
         {
            mScrollLeftButton.destroy();
         }
         mScrollLeftButton = null;
         if(mScrollPageRightButton)
         {
            mScrollPageRightButton.destroy();
         }
         mScrollPageRightButton = null;
         if(mScrollPageLeftButton)
         {
            mScrollPageLeftButton.destroy();
         }
         mScrollPageLeftButton = null;
         mRootMovieClip = null;
         mLeaderboard = null;
         mOnlinePopup = null;
         mOfflinePopup = null;
         mStoreCallback = null;
         mGetGiftsCallback = null;
      }
      
      public function set currentStateName(param1:String) : void
      {
         mCurrentStateName = param1;
      }
      
      public function get currentStateName() : String
      {
         return mCurrentStateName;
      }
      
      public function get onlineFriends() : Vector.<FriendInfo>
      {
         return mOnlineFriends;
      }
      
      public function get offlineFriends() : Vector.<FriendInfo>
      {
         return mOfflineFriends;
      }
      
      public function get townStateMachine() : TownStateMachine
      {
         return mTownStateMachine;
      }
      
      public function enableMessageFriendButton() : void
      {
         SceneGraphManager.setGrayScaleSaturation(mOfflinePopup.message_friend,100);
         mOfflinePopup.message_friend.label.mouseEnabled = true;
         mMessageFriendButton.enabled = true;
      }
      
      public function disableMessageFriendButton() : void
      {
         SceneGraphManager.setGrayScaleSaturation(mOfflinePopup.message_friend,10);
         mOfflinePopup.message_friend.label.mouseEnabled = false;
         mMessageFriendButton.enabled = false;
      }
   }
}

