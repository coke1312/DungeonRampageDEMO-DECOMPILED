package UI.FriendManager.States
{
   import Account.FriendInfo;
   import Account.StoreServicesController;
   import Brain.Logger.Logger;
   import Brain.UI.UIButton;
   import Brain.jsonRPC.JSONRPCService;
   import Facade.DBFacade;
   import Facade.Locale;
   import Town.TownStateMachine;
   import UI.DBUIOneButtonPopup;
   import UI.FriendManager.FriendPopulater;
   import UI.FriendManager.UIFriendManager;
   
   public class UIFriends extends UIFMState
   {
      
      public static const BUTTON_REMOVE_POS_X:uint = 290;
      
      public static const BUTTON_REMOVE_POS_Y:uint = 545;
      
      public static const BUTTON_GIFT_POS_X:uint = 440;
      
      public static const BUTTON_GIFT_POS_Y:uint = 545;
      
      private var mFriendPopulater:FriendPopulater;
      
      private var mListOfFriends:Vector.<FriendInfo>;
      
      private var mRemoveButton:UIButton;
      
      private var mGiftButton:UIButton;
      
      private var mSelectedDRFriends:Array = [];
      
      private var mSelectedFBFriends:Array = [];
      
      private var mSelectedKGFriends:Array = [];
      
      private var mFBRemoveFriendPopup:DBUIOneButtonPopup;
      
      public function UIFriends(param1:UIFriendManager, param2:DBFacade, param3:TownStateMachine)
      {
         super(param2,param1,param3);
         mListOfFriends = new Vector.<FriendInfo>();
      }
      
      override public function enter() : void
      {
         mUIFriendManager.updateHeading(Locale.getString("FRIEND_MANAGEMENT_HEADING_FRIENDS"));
         mUIFriendManager.updateDescription(Locale.getString("FRIEND_MANAGEMENT_DESCRIPTION_FRIENDS"));
         setupUI();
      }
      
      override public function exit() : void
      {
         mListOfFriends.splice(0,mListOfFriends.length);
         if(mFriendPopulater != null)
         {
            mFriendPopulater.destroy();
            mFriendPopulater = null;
         }
         if(mRemoveButton)
         {
            mRemoveButton.destroy();
            mRemoveButton = null;
         }
         if(mGiftButton)
         {
            mGiftButton.destroy();
            mGiftButton = null;
         }
         mUIFriendManager.clearUI();
      }
      
      private function refresh(param1:Array) : void
      {
         var _loc3_:Boolean = false;
         var _loc4_:* = 0;
         for each(var _loc2_ in param1)
         {
            _loc3_ = false;
            _loc4_ = 0;
            while(_loc4_ < mTownStateMachine.leaderboard.onlineFriends.length)
            {
               if(mTownStateMachine.leaderboard.onlineFriends[_loc4_].id == _loc2_)
               {
                  mTownStateMachine.leaderboard.onlineFriends.splice(_loc4_,1);
                  _loc3_ = true;
                  break;
               }
               _loc4_++;
            }
            if(!_loc3_)
            {
               _loc4_ = 0;
               while(_loc4_ < mTownStateMachine.leaderboard.offlineFriends.length)
               {
                  if(mTownStateMachine.leaderboard.offlineFriends[_loc4_].id == _loc2_)
                  {
                     mTownStateMachine.leaderboard.offlineFriends.splice(_loc4_,1);
                     _loc3_ = true;
                     break;
                  }
                  _loc4_++;
               }
            }
         }
         exit();
         enter();
      }
      
      private function setupUI() : void
      {
         var _loc3_:int = 0;
         var _loc2_:Vector.<FriendInfo> = mTownStateMachine.leaderboard.onlineFriends;
         var _loc1_:Vector.<FriendInfo> = mTownStateMachine.leaderboard.offlineFriends;
         _loc3_ = 0;
         while(_loc3_ < _loc2_.length)
         {
            if(_loc2_[_loc3_].id != mDBFacade.accountId)
            {
               mListOfFriends.push(_loc2_[_loc3_]);
            }
            _loc3_++;
         }
         _loc3_ = 0;
         while(_loc3_ < _loc1_.length)
         {
            mListOfFriends.push(_loc1_[_loc3_]);
            _loc3_++;
         }
         mFriendPopulater = new FriendPopulater(mDBFacade,mTownStateMachine,mListOfFriends,mUIFriendManager);
         mRemoveButton = createButton("friend_management_button_grey",Locale.getString("REMOVE"),290,545,removeButtonCallback);
         mGiftButton = createButton("friend_management_button",Locale.getString("GIFT"),440,545,giftButtonCallback);
      }
      
      private function removeButtonCallback() : void
      {
         var rpcFunc:Function;
         var idx:uint;
         mSelectedDRFriends.splice(0,mSelectedDRFriends.length);
         mSelectedFBFriends.splice(0,mSelectedFBFriends.length);
         mSelectedKGFriends.splice(0,mSelectedKGFriends.length);
         for each(idx in mFriendPopulater.getSelectedToggles())
         {
            if(mListOfFriends[idx].isDRFriend)
            {
               mSelectedDRFriends.push(mListOfFriends[idx].id);
            }
            else if(mListOfFriends[idx].facebookId != null && mListOfFriends[idx].facebookId != "")
            {
               mSelectedFBFriends.push(mListOfFriends[idx].id);
            }
            else if(mListOfFriends[idx].kongregateId != null && mListOfFriends[idx].kongregateId != "")
            {
               mSelectedKGFriends.push(mListOfFriends[idx].id);
            }
         }
         if(mSelectedDRFriends.length > 0)
         {
            rpcFunc = JSONRPCService.getFunction("DRFriendRemove",mDBFacade.rpcRoot + "friendrequests");
            rpcFunc(mDBFacade.accountId,mSelectedDRFriends,mDBFacade.validationToken,function(param1:*):void
            {
               var _loc2_:* = 0;
               refresh(mSelectedDRFriends);
               mDBFacade.dbAccountInfo.removeFriendCallback(param1);
               mTownStateMachine.leaderboard.refreshLeaderboard();
               _loc2_ = 0;
               while(_loc2_ < mSelectedDRFriends.length)
               {
                  mDBFacade.metrics.log("DRFriendRemove",{"friendId":mSelectedDRFriends[_loc2_].toString()});
                  _loc2_++;
               }
            });
         }
         if(mSelectedFBFriends.length > 0)
         {
            mFBRemoveFriendPopup = new DBUIOneButtonPopup(mDBFacade,Locale.getString("LEADERBOARD_FB_REMOVE_FRIEND_POPUP_TITLE"),Locale.getString("LEADERBOARD_FB_REMOVE_FRIEND_POPUP_DESC"),Locale.getString("OK"),null);
         }
         else if(mSelectedKGFriends.length > 0)
         {
            mFBRemoveFriendPopup = new DBUIOneButtonPopup(mDBFacade,Locale.getString("LEADERBOARD_KG_REMOVE_FRIEND_POPUP_TITLE"),Locale.getString("LEADERBOARD_KG_REMOVE_FRIEND_POPUP_DESC"),Locale.getString("OK"),null);
         }
      }
      
      private function giftButtonCallback() : void
      {
         var newFriendsFound:Boolean;
         var idx:uint;
         if(mDBFacade.dbConfigManager.getConfigBoolean("FUFB",false))
         {
            mGiftButton.releaseCallback = function():void
            {
               mDBFacade.errorPopup("GIFTING CURRENTLY DISABLED","Sorry for the inconvenience, we are looking into resolving the issue.");
            };
            return;
         }
         newFriendsFound = false;
         for each(idx in mFriendPopulater.getSelectedToggles())
         {
            if(mDBFacade.dbAccountInfo.giftExcludeIds.indexOf(mListOfFriends[idx].excludeId) < 0)
            {
               newFriendsFound = true;
            }
         }
         if(newFriendsFound)
         {
            StoreServicesController.showGiftPage(mDBFacade,sendGifts);
         }
      }
      
      private function sendGifts(param1:String, param2:uint) : void
      {
         trace("sendGifts");
         if(mDBFacade.isFacebookPlayer)
         {
            trace("  isFacebookPlayer");
            fbGiftFlow(param1,param2);
         }
         else if(mDBFacade.isDRPlayer)
         {
            trace("  isDRPlayer");
            if(mDBFacade.facebookController.accessToken)
            {
               fbGiftFlow(param1,param2);
               trace("    fbGiftFlow");
            }
            else
            {
               drGiftFlow(param1,param2);
               trace("    drGiftFlow");
            }
         }
         else if(mDBFacade.isKongregatePlayer)
         {
            trace("  isKongregatePlayer");
            kongGiftFlow(param1,param2);
         }
         else
         {
            trace("  isNotPlayer");
            Logger.warn("What kind of player are you??? ");
         }
      }
      
      private function fbGiftFlow(param1:String, param2:uint) : void
      {
         trace("fbGiftFlow");
         var _loc3_:Array = [];
         var _loc4_:Array = [];
         for each(var _loc5_ in mFriendPopulater.getSelectedToggles())
         {
            if(mDBFacade.dbAccountInfo.giftExcludeIds.indexOf(mListOfFriends[_loc5_].excludeId) >= 0)
            {
               trace("  giftExcludeIds");
            }
            else if(mListOfFriends[_loc5_].isDRFriend)
            {
               _loc4_.push(_loc5_);
               trace("  isDRFriend");
            }
            else
            {
               _loc3_.push(_loc5_);
               trace("  isFBFriend");
            }
         }
         if(_loc3_.length > 0)
         {
            sendFacebookGift(param1,param2,_loc3_);
            trace("  sendFacebookGift");
         }
         if(_loc4_.length > 0)
         {
            sendDRComGift(param1,param2,_loc4_);
            trace("  sendDRGift");
         }
      }
      
      private function drGiftFlow(param1:String, param2:uint) : void
      {
         var _loc3_:Array = [];
         for each(var _loc4_ in mFriendPopulater.getSelectedToggles())
         {
            if(mDBFacade.dbAccountInfo.giftExcludeIds.indexOf(mListOfFriends[_loc4_].excludeId) < 0)
            {
               _loc3_.push(_loc4_);
            }
         }
         if(_loc3_.length > 0)
         {
            sendDRComGift(param1,param2,_loc3_);
         }
      }
      
      private function kongGiftFlow(param1:String, param2:uint) : void
      {
         var _loc4_:Array = [];
         var _loc3_:Array = [];
         for each(var _loc5_ in mFriendPopulater.getSelectedToggles())
         {
            if(mDBFacade.dbAccountInfo.giftExcludeIds.indexOf(mListOfFriends[_loc5_].excludeId) < 0)
            {
               if(mListOfFriends[_loc5_].isDRFriend)
               {
                  _loc3_.push(_loc5_);
               }
               else
               {
                  _loc4_.push(_loc5_);
               }
            }
         }
         if(_loc4_.length > 0)
         {
            sendKongregateGift(param1,param2,_loc4_);
         }
         if(_loc3_.length > 0)
         {
            sendDRComGift(param1,param2,_loc3_);
         }
      }
      
      private function sendFacebookGift(param1:String, param2:uint, param3:Array) : void
      {
         var _loc4_:Array = [];
         for each(var _loc5_ in param3)
         {
            _loc4_.push(mListOfFriends[_loc5_].facebookId);
         }
         mDBFacade.facebookController.sendGiftRequests(param1,param2,_loc4_.toString());
         mDBFacade.dbAccountInfo.giftExcludeIds = mDBFacade.dbAccountInfo.giftExcludeIds.concat(_loc4_);
         mFriendPopulater.refreshGiftedOnCurrentPage();
      }
      
      private function sendDRComGift(param1:String, param2:uint, param3:Array) : void
      {
         var _loc4_:String = null;
         var _loc5_:String = null;
         var _loc8_:Array = [];
         var _loc7_:Array = [];
         var _loc6_:String = new Date().time.toString();
         for each(var _loc9_ in param3)
         {
            _loc4_ = mListOfFriends[_loc9_].id.toString();
            _loc5_ = "0_" + _loc6_ + "_" + _loc4_;
            _loc7_.push(_loc5_);
            _loc8_.push(_loc4_);
            mDBFacade.metrics.log("DRGiftRequest",{"friendId":_loc4_});
         }
         mDBFacade.dbAccountInfo.giftExcludeIds = mDBFacade.dbAccountInfo.giftExcludeIds.concat(_loc8_);
         mDBFacade.dbAccountInfo.sendGiftData(param2,_loc7_,_loc8_);
         mFriendPopulater.refreshGiftedOnCurrentPage();
      }
      
      private function sendKongregateGift(param1:String, param2:uint, param3:Array) : void
      {
         var _loc4_:String = null;
         var _loc5_:String = null;
         var _loc8_:Array = [];
         var _loc7_:Array = [];
         var _loc6_:String = new Date().time.toString();
         for each(var _loc9_ in param3)
         {
            _loc4_ = mListOfFriends[_loc9_].kongregateId.toString();
            _loc5_ = "0_" + _loc6_ + "_" + _loc4_;
            _loc7_.push(_loc5_);
            _loc8_.push(_loc4_);
            mDBFacade.metrics.log("KGGiftRequest",{"friendId":_loc4_});
         }
         mDBFacade.dbAccountInfo.giftExcludeIds = mDBFacade.dbAccountInfo.giftExcludeIds.concat(_loc8_);
         mDBFacade.dbAccountInfo.sendGiftData(param2,_loc7_,_loc8_);
         mFriendPopulater.refreshGiftedOnCurrentPage();
      }
   }
}

