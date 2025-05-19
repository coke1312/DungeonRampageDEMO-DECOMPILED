package Account
{
   import Account.II.II_AccountTopScoreInfo;
   import Brain.AssetRepository.AssetLoadingComponent;
   import Brain.AssetRepository.JsonAsset;
   import Brain.Clock.GameClock;
   import Brain.Event.EventComponent;
   import Brain.Logger.Logger;
   import Brain.Utils.Utf8BitArray;
   import Brain.WorkLoop.LogicalWorkComponent;
   import Brain.WorkLoop.Task;
   import Brain.jsonRPC.JSONRPCService;
   import Events.DBAccountLoadedEvent;
   import Events.DBAccountResponseEvent;
   import Events.FriendStatusEvent;
   import Events.TrophiesUpdatedAccountEvent;
   import Facade.DBFacade;
   import Facade.Locale;
   import UI.DBUIPopup;
   import flash.events.Event;
   import flash.system.System;
   import org.as3commons.collections.Map;
   import org.as3commons.collections.framework.IMapIterator;
   
   public class DBAccountInfo
   {
      
      public static const SFX_ATTRIBUTE_KEY:String = "optionsSFXVolume";
      
      public static const MUSIC_ATTRIBUTE_KEY:String = "optionsMusicVolume";
      
      public static const GRAPHICS_QUALITY_ATTRIBUTE_KEY:String = "optionsGraphicsQuality";
      
      public static const HUD_STYLE_ATTRIBUTE_KEY:String = "optionsHudStyle";
      
      private static const DB_ACCOUNT_INFO_SERVICE:String = "dbAccountInfo/accountdetails/";
      
      private static const ONLINE_PRESENCE_NORMAL_REFRESH_TIME:Number = 60;
      
      protected var mDBFacade:DBFacade;
      
      private var mInventory:DBInventoryInfo;
      
      private var mUpdateMessagePopup:DBUIPopup;
      
      private var mActiveAvatar:AvatarInfo;
      
      private var mAttributes:Map;
      
      private var mBasicCurrency:uint;
      
      private var mId:uint;
      
      private var mAccountFlags:uint;
      
      private var mPremiumKeys:uint;
      
      private var mTrophyCount:uint;
      
      private var mName:String;
      
      private var mPremiumCurrency:uint;
      
      private var mInventoryLimitOther:uint;
      
      private var mInventoryLimitWeapons:uint;
      
      private var mFriendsInfo:Map;
      
      private var mGiftsInfo:Map;
      
      private var mGiftExcludeIds:Array;
      
      private var mLastFPSTime:uint;
      
      private var mLastFPSFrame:uint;
      
      private var mFPSLocation:String = "";
      
      private var mCurrentFriendsHash:String;
      
      private var mAccountCreatedDate:String;
      
      protected var mAssetLoadingComponent:AssetLoadingComponent;
      
      protected var mLogicalWorkComponent:LogicalWorkComponent;
      
      protected var mEventComponent:EventComponent;
      
      private var mOnlinePresenceTask:Task;
      
      public var SocketPingMilsecs:int;
      
      private var mErrorPopUp:DBUIPopup;
      
      private var mIgnoredFriendsInfo:Vector.<FriendInfo>;
      
      private var mDBAccountParams:DBAccountParams;
      
      private var mDungeonsCompleted:uint;
      
      private var mCompletedMapnodeMask:Utf8BitArray;
      
      private var mHudStyle:uint = 0;
      
      private var mLocalFriendInfo:FriendInfo;
      
      public function DBAccountInfo(param1:DBFacade)
      {
         super();
         SocketPingMilsecs = -1;
         mDBFacade = param1;
         mAssetLoadingComponent = new AssetLoadingComponent(mDBFacade);
         mLogicalWorkComponent = new LogicalWorkComponent(mDBFacade);
         mAttributes = new Map();
         mFriendsInfo = new Map();
         mGiftsInfo = new Map();
         mInventory = new DBInventoryInfo(mDBFacade,parseResponse,parseError);
         mEventComponent = new EventComponent(mDBFacade);
         mIgnoredFriendsInfo = new Vector.<FriendInfo>();
         mGiftExcludeIds = [];
         mCompletedMapnodeMask = new Utf8BitArray();
         mDBFacade.dbAccountInfo = this;
      }
      
      public function get unequippedWeaponCount() : uint
      {
         return mInventory.unequippedWeaponCount;
      }
      
      public function get activeAvatarId() : uint
      {
         return mActiveAvatar.id;
      }
      
      public function get activeAvatarSkinId() : uint
      {
         return mActiveAvatar.skinId;
      }
      
      public function get stackableCount() : uint
      {
         return mInventory.numStacks;
      }
      
      public function get inventoryLimitWeapons() : uint
      {
         return mInventoryLimitWeapons;
      }
      
      public function get inventoryLimitOther() : uint
      {
         return mInventoryLimitOther;
      }
      
      public function get name() : String
      {
         return mName;
      }
      
      public function get facebookId() : String
      {
         return mDBFacade.facebookPlayerId;
      }
      
      public function get kongregateId() : String
      {
         return mDBFacade.kongregatePlayerId;
      }
      
      public function get inventoryInfo() : DBInventoryInfo
      {
         return mInventory;
      }
      
      public function get id() : uint
      {
         return mId;
      }
      
      public function get currentFacebookFriendsHash() : String
      {
         return mCurrentFriendsHash;
      }
      
      public function get currentKongregateFriendsHash() : String
      {
         return mCurrentFriendsHash;
      }
      
      public function checkFriendsHash() : void
      {
         if(mDBFacade.facebookController)
         {
            mDBFacade.facebookController.getFacebookFriendsHash();
         }
         if(mDBFacade.isKongregatePlayer)
         {
            mDBFacade.facebookController.getKongregateFriendsHash();
         }
      }
      
      public function getUsersFullAccountInfo() : void
      {
         Logger.debug("DBAccountInfo.getUsersFullAccountInfo");
         var _loc1_:uint = mDBFacade.accountId;
         var _loc3_:String = mDBFacade.validationToken;
         var _loc2_:String = mDBFacade.webServiceAPIRoot + "dbAccountInfo/accountdetails/" + _loc1_ + "/" + _loc3_;
         mAssetLoadingComponent.getJsonAsset(_loc2_,parseAccountInfoJson,errorAccountInfoJson,false);
      }
      
      public function getUsersFriendInfo() : void
      {
         var rpcFunc:Function;
         var rpcSuccessCallback:Function;
         Logger.debug("DBAccountInfo.getUsersFriendInfo");
         rpcFunc = JSONRPCService.getFunction("getFriendRecord",mDBFacade.rpcRoot + "leaderboard");
         rpcSuccessCallback = function(param1:*):void
         {
            parseFriendResponse(param1);
         };
         rpcFunc(mDBFacade.accountId,mDBFacade.validationToken,rpcSuccessCallback,parseError);
      }
      
      public function alterAttribute(param1:String, param2:String) : void
      {
         var rpcSuccessCallback:Function;
         var name:String = param1;
         var value:String = param2;
         var rpcFunc:Function = JSONRPCService.getFunction("AlterAttribute",mDBFacade.rpcRoot + "account");
         if(mAttributes.hasKey(name))
         {
            mAttributes.replaceFor(name,value);
         }
         else
         {
            mAttributes.add(name,value);
         }
         rpcSuccessCallback = function(param1:*):void
         {
         };
         rpcFunc(mDBFacade.dbAccountInfo.id,mDBFacade.validationToken,name,value,rpcSuccessCallback,parseError);
      }
      
      public function hasAttribute(param1:String) : Boolean
      {
         return mAttributes.hasKey(param1);
      }
      
      public function getAttribute(param1:String) : String
      {
         return mAttributes.itemFor(param1);
      }
      
      public function get hudStyle() : uint
      {
         return mHudStyle;
      }
      
      public function set hudStyle(param1:uint) : void
      {
         mHudStyle = param1;
      }
      
      public function acceptGift(param1:String, param2:Function, param3:Function = null) : void
      {
         var requestId:String = param1;
         var clearGiftCallback:Function = param2;
         var successCallback:Function = param3;
         var rpcFunc:Function = JSONRPCService.getFunction("AcceptGift",mDBFacade.rpcRoot + "store");
         var rpcSuccessCallback:Function = function(param1:*):void
         {
            if(param1)
            {
               parseResponse(param1);
            }
            if(successCallback != null)
            {
               successCallback();
            }
         };
         rpcFunc(mDBFacade.dbAccountInfo.id,requestId,mDBFacade.validationToken,mDBFacade.demographics,rpcSuccessCallback,parseError);
         mGiftsInfo.removeKey(requestId);
         if(clearGiftCallback != null)
         {
            clearGiftCallback();
         }
      }
      
      public function acceptAllGifts(param1:Function, param2:Function = null) : void
      {
         var clearGiftCallback:Function = param1;
         var successCallback:Function = param2;
         var rpcFunc:Function = JSONRPCService.getFunction("AcceptAllGifts",mDBFacade.rpcRoot + "store");
         var rpcSuccessCallback:Function = function(param1:*):void
         {
            if(param1)
            {
               parseResponse(param1);
            }
            if(successCallback != null)
            {
               successCallback();
            }
         };
         var requestIds:Array = mGiftsInfo.keysToArray();
         if(requestIds.length > 0)
         {
            rpcFunc(mDBFacade.dbAccountInfo.id,requestIds,mDBFacade.validationToken,mDBFacade.demographics,rpcSuccessCallback,parseError);
            mGiftsInfo.clear();
            if(clearGiftCallback != null)
            {
               clearGiftCallback();
            }
         }
      }
      
      public function declineGift(param1:String, param2:Function = null) : void
      {
         var requestId:String = param1;
         var successCallback:Function = param2;
         var rpcFunc:Function = JSONRPCService.getFunction("DeclineGift",mDBFacade.rpcRoot + "store");
         var rpcSuccessCallback:Function = function():void
         {
            mGiftsInfo.removeKey(requestId);
            if(successCallback != null)
            {
               successCallback();
            }
         };
         rpcFunc(mDBFacade.dbAccountInfo.id,requestId,mDBFacade.validationToken,mDBFacade.demographics,rpcSuccessCallback,parseError);
      }
      
      public function sendGiftData(param1:uint, param2:Array, param3:Array, param4:Function = null) : void
      {
         var offerId:uint = param1;
         var requestIds:Array = param2;
         var toIds:Array = param3;
         var successCallback:Function = param4;
         var rpcFunc:Function = JSONRPCService.getFunction("GiftOffer",mDBFacade.rpcRoot + "store");
         var rpcSuccessCallback:Function = function(param1:*):void
         {
            if(successCallback != null)
            {
               successCallback();
            }
         };
         rpcFunc(mDBFacade.dbAccountInfo.id,offerId,mDBFacade.dbConfigManager.networkId,requestIds,toIds,mDBFacade.validationToken,rpcSuccessCallback,parseError);
      }
      
      public function sendFacebookRequestData(param1:Array, param2:Array, param3:Function = null) : void
      {
         var _loc4_:Function = JSONRPCService.getFunction("AppRequests",mDBFacade.rpcRoot + "facebookrequests");
         _loc4_(mDBFacade.dbAccountInfo.id,param1,param2,mDBFacade.validationToken);
      }
      
      public function getGiftData(param1:Function = null) : void
      {
         var successCallback:Function = param1;
         var rpcFunc:Function = JSONRPCService.getFunction("GetAllGifts",mDBFacade.rpcRoot + "store");
         var rpcSuccessCallback:Function = function(param1:*):void
         {
            parseGiftData(param1);
            if(successCallback != null)
            {
               successCallback();
            }
         };
         rpcFunc(mDBFacade.dbAccountInfo.id,mDBFacade.validationToken,rpcSuccessCallback,parseError);
      }
      
      private function parseGiftData(param1:*) : void
      {
         var _loc3_:Array = null;
         var _loc2_:GiftInfo = null;
         var _loc4_:* = 0;
         if(param1)
         {
            if(param1.excludeIds)
            {
               mGiftExcludeIds = param1.excludeIds as Array;
            }
            if(!param1.gifts)
            {
               return;
            }
            _loc3_ = param1.gifts as Array;
            _loc4_ = 0;
            while(_loc4_ < _loc3_.length)
            {
               _loc2_ = new GiftInfo(mDBFacade,_loc3_[_loc4_]);
               if(!mGiftsInfo.has(_loc2_.requestId))
               {
                  mGiftsInfo.add(_loc2_.requestId,_loc2_);
               }
               _loc4_++;
            }
         }
      }
      
      public function addFriendCallback(param1:*) : void
      {
         var _loc2_:Array = null;
         var _loc5_:FriendInfo = null;
         var _loc4_:* = 0;
         var _loc3_:* = 0;
         if(param1)
         {
            _loc2_ = param1 as Array;
            _loc4_ = 0;
            while(_loc4_ < _loc2_.length)
            {
               _loc3_ = _loc2_[_loc4_].account_id as uint;
               if(!mFriendsInfo.hasKey(_loc3_))
               {
                  _loc5_ = new FriendInfo(mDBFacade,_loc2_[_loc4_]);
                  mFriendsInfo.add(_loc5_.id,_loc5_);
               }
               else
               {
                  _loc5_ = mFriendsInfo.itemFor(_loc3_);
                  _loc5_.parseFriendJson(_loc2_[_loc4_]);
               }
               _loc4_++;
            }
         }
         mEventComponent.dispatchEvent(new Event("REFRESH_FRIENDS_EVENT"));
      }
      
      public function removeFriendCallback(param1:*) : void
      {
         var _loc2_:Array = null;
         var _loc5_:* = null;
         var _loc4_:* = 0;
         var _loc3_:* = 0;
         if(param1)
         {
            _loc2_ = param1 as Array;
            _loc4_ = 0;
            while(_loc4_ < _loc2_.length)
            {
               _loc3_ = _loc2_[_loc4_].account_id as uint;
               if(mFriendsInfo.hasKey(_loc3_))
               {
                  mFriendsInfo.removeKey(_loc3_);
               }
               _loc4_++;
            }
         }
         mEventComponent.dispatchEvent(new Event("REFRESH_FRIENDS_EVENT"));
      }
      
      public function isFriend(param1:uint) : Boolean
      {
         if(param1 == 0)
         {
            return false;
         }
         return mFriendsInfo.hasKey(param1);
      }
      
      public function getFriendData(param1:Function) : void
      {
         var successCallback:Function = param1;
         var rpcFunc:Function = JSONRPCService.getFunction("getFriendData",mDBFacade.rpcRoot + "leaderboard");
         var rpcSuccessCallback:Function = function(param1:*):void
         {
            parseFriendData(param1);
            if(successCallback != null)
            {
               successCallback();
            }
            if(mInventory.canShowInfiniteIsland())
            {
               getAllMapnodeScoresRPC(mDBFacade.dbAccountInfo.id);
            }
         };
         rpcFunc(mDBFacade.dbAccountInfo.id,mDBFacade.demographics,mDBFacade.validationToken,rpcSuccessCallback,parseError);
      }
      
      public function refreshFriendData(param1:*) : void
      {
         parseFriendData(param1);
      }
      
      public function getIgnoredFriendData(param1:Function = null) : void
      {
         var rpcFunc:Function;
         var rpcSuccessCallback:Function;
         var successCallback:Function = param1;
         if(mIgnoredFriendsInfo.length > 0)
         {
            return;
         }
         rpcFunc = JSONRPCService.getFunction("getIgnoreFriendData",mDBFacade.rpcRoot + "leaderboard");
         rpcSuccessCallback = function(param1:*):void
         {
            parseIgnoredFriendData(param1);
         };
         rpcFunc(mDBFacade.dbAccountInfo.id,mDBFacade.validationToken,rpcSuccessCallback,parseError);
      }
      
      private function parseIgnoredFriendData(param1:*) : void
      {
         var _loc2_:Array = null;
         var _loc5_:FriendInfo = null;
         var _loc4_:* = 0;
         var _loc3_:* = 0;
         if(param1)
         {
            _loc2_ = param1 as Array;
            _loc4_ = 0;
            while(_loc4_ < _loc2_.length)
            {
               _loc3_ = _loc2_[_loc4_].account_id as uint;
               if(!mFriendsInfo.hasKey(_loc3_))
               {
                  _loc5_ = new FriendInfo(mDBFacade,_loc2_[_loc4_]);
                  mIgnoredFriendsInfo.push(_loc5_);
               }
               else
               {
                  _loc5_ = mIgnoredFriendsInfo[_loc4_];
                  _loc5_.parseFriendJson(_loc2_[_loc4_]);
               }
               _loc4_++;
            }
         }
      }
      
      private function friendlistUpdate(param1:FriendStatusEvent) : void
      {
         var successCallback:Function;
         var event:FriendStatusEvent = param1;
         if(event.status == false || mFriendsInfo.hasKey(event.friendId))
         {
            return;
         }
         successCallback = function():void
         {
            mEventComponent.dispatchEvent(new Event("REFRESH_FRIENDS_EVENT"));
         };
         getFriendData(successCallback);
      }
      
      private function parseFriendData(param1:*, param2:Boolean = false) : void
      {
         var myself:FriendInfo;
         var friendsArray:Array;
         var friendInfo:FriendInfo;
         var i:uint;
         var friendId:uint;
         var friends:* = param1;
         var purge:Boolean = param2;
         var myObject:Object = {
            "account_id":this.mId,
            "name":this.mName,
            "trophies":this.trophies,
            "facebook_id":mDBFacade.facebookPlayerId,
            "kongregate_id":mDBFacade.kongregatePlayerId,
            "status_online":true,
            "in_dungeon":false
         };
         if(purge)
         {
            mFriendsInfo.clear();
         }
         if(!mFriendsInfo.hasKey(this.mId))
         {
            myself = new FriendInfo(mDBFacade,myObject);
            mFriendsInfo.add(myself.id,myself);
         }
         else
         {
            myself = mFriendsInfo.itemFor(this.mId);
            myself.parseFriendJson(myObject);
         }
         mEventComponent.addListener("TrophiesUpdatedAccountEvent",function(param1:TrophiesUpdatedAccountEvent):void
         {
            myself = mFriendsInfo.itemFor(mId);
            myself.trophies = param1.trophyCount;
         });
         mLocalFriendInfo = myself;
         mEventComponent.addListener("FRIEND_STATUS_EVENT",friendlistUpdate);
         if(mDBFacade.facebookController && activeAvatarInfo.level >= 5)
         {
            mDBFacade.facebookController.updateGuestAchievement(2);
         }
         if(friends)
         {
            friendsArray = friends as Array;
            i = 0;
            while(i < friendsArray.length)
            {
               friendId = friendsArray[i].account_id as uint;
               if(!mFriendsInfo.hasKey(friendId))
               {
                  friendInfo = new FriendInfo(mDBFacade,friendsArray[i]);
                  mFriendsInfo.add(friendInfo.id,friendInfo);
               }
               else
               {
                  friendInfo = mFriendsInfo.itemFor(friendId);
                  friendInfo.parseFriendJson(friendsArray[i]);
               }
               ++i;
            }
         }
      }
      
      public function addAchievement(param1:String, param2:String, param3:Function) : void
      {
         var achievementId:String = param1;
         var achievementURL:String = param2;
         var achievementCallback:Function = param3;
         var rpcFunc:Function = JSONRPCService.getFunction("AddAchievement",mDBFacade.rpcRoot + "achievement");
         var successCallback:Function = function(param1:*):void
         {
            achievementCallback(achievementId);
            Logger.info("achievement success");
         };
         var failCallback:Function = function(param1:*):void
         {
         };
         rpcFunc(mDBFacade.accountId,mDBFacade.validationToken,mDBFacade.facebookPlayerId,achievementURL,successCallback,failCallback);
      }
      
      public function setPresenceTask(param1:String) : void
      {
         if(mOnlinePresenceTask)
         {
            mOnlinePresenceTask.destroy();
         }
         SocketPingMilsecs = -1;
         mLastFPSTime = mDBFacade.gameClock.realTime;
         mLastFPSFrame = mDBFacade.gameClock.frame;
         mFPSLocation = param1;
         setOnlinePresence(mDBFacade.gameClock);
         mOnlinePresenceTask = mDBFacade.realClockWorkManager.doEverySeconds(60,setOnlinePresence);
      }
      
      private function setOnlinePresence(param1:GameClock) : void
      {
         var _loc6_:uint = uint(param1.realTime);
         var _loc4_:uint = param1.frame;
         var _loc2_:Number = (_loc6_ - mLastFPSTime) / 1000;
         var _loc5_:int = _loc2_ > 0 ? Math.round((_loc4_ - mLastFPSFrame) / _loc2_) : -1;
         mLastFPSTime = _loc6_;
         mLastFPSFrame = _loc4_;
         var _loc3_:Object = {};
         if(SocketPingMilsecs > 0)
         {
            _loc3_["socketPingMilsecs"] = SocketPingMilsecs;
         }
         _loc3_["memory"] = Math.round(System.totalMemory / 1024 / 1024);
         if(_loc5_ >= 0)
         {
            _loc3_["fps"] = _loc5_;
            _loc3_["fpsLocation"] = mFPSLocation;
         }
         mDBFacade.metrics.log("Presence",_loc3_);
      }
      
      public function getFacebookIdRPC(param1:uint, param2:Function) : void
      {
         var remoteId:uint = param1;
         var successCallback:Function = param2;
         var rpcFunc:Function = JSONRPCService.getFunction("GetFacebookId",mDBFacade.rpcRoot + "account");
         var rpcSuccessCallback:Function = function(param1:String):void
         {
            successCallback(param1);
         };
         rpcFunc(remoteId,id,mDBFacade.validationToken,rpcSuccessCallback,parseError);
      }
      
      public function get basicCurrency() : uint
      {
         return mBasicCurrency;
      }
      
      public function get premiumCurrency() : uint
      {
         return mPremiumCurrency;
      }
      
      public function get trophies() : uint
      {
         return mTrophyCount;
      }
      
      public function hasAllTrophies() : Boolean
      {
         if(mTrophyCount >= 106)
         {
            return true;
         }
         return false;
      }
      
      public function get activeAvatarInfo() : AvatarInfo
      {
         return mActiveAvatar;
      }
      
      public function get highestAvatarLevel() : uint
      {
         return mInventory.highestAvatarLevel;
      }
      
      public function get friendInfos() : Map
      {
         return mFriendsInfo;
      }
      
      public function get gifts() : Map
      {
         return mGiftsInfo;
      }
      
      public function get ignoredFriends() : Vector.<FriendInfo>
      {
         return mIgnoredFriendsInfo;
      }
      
      public function get giftExcludeIds() : Array
      {
         return mGiftExcludeIds;
      }
      
      public function set giftExcludeIds(param1:Array) : void
      {
         mGiftExcludeIds = param1;
      }
      
      public function get accountCreatedDate() : String
      {
         return mAccountCreatedDate;
      }
      
      public function set account_flags(param1:uint) : void
      {
         mAccountFlags = param1;
      }
      
      public function get account_flags() : uint
      {
         return mAccountFlags;
      }
      
      private function errorAccountInfoJson() : void
      {
         mDBFacade.errorPopup(Locale.getString("ERROR"),Locale.getError(100));
      }
      
      private function parseAccountInfoJson(param1:JsonAsset) : void
      {
         Logger.debug("DBAccountInfo.parseAccountInfoJson");
         var _loc2_:Object = param1.json;
         parseResponse(_loc2_);
         mEventComponent.dispatchEvent(new DBAccountLoadedEvent(this));
         if(!mCurrentFriendsHash || mCurrentFriendsHash == "")
         {
            getUsersFriendInfo();
         }
      }
      
      private function parseAttributes(param1:Array) : void
      {
         mAttributes.clear();
         for each(var _loc2_ in param1)
         {
            mAttributes.add(_loc2_.name,_loc2_.value);
         }
      }
      
      private function parseCurrency(param1:Object) : void
      {
         mPremiumCurrency = param1.premium_currency;
         mBasicCurrency = param1.basic_currency;
         mTrophyCount = param1.trophies;
         mEventComponent.dispatchEvent(new CurrencyUpdatedAccountEvent(mBasicCurrency,mPremiumCurrency));
         mEventComponent.dispatchEvent(new TrophiesUpdatedAccountEvent(mTrophyCount));
      }
      
      public function changeActiveAvatarRPC(param1:uint) : void
      {
         var heroType:uint = param1;
         var rpcFunc:Function = JSONRPCService.getFunction("setActiveAvatar",mDBFacade.rpcRoot + "avatarrecord");
         var avatarInfo:AvatarInfo = mInventory.getAvatarInfoForHeroType(heroType);
         if(avatarInfo)
         {
            mActiveAvatar = avatarInfo;
            mUpdateMessagePopup = new DBUIPopup(mDBFacade,Locale.getString("SHOP_UPDATING"),null,false);
            rpcFunc(mDBFacade.validationToken,mDBFacade.dbAccountInfo.id,avatarInfo.id,avatarInfo.skinId,function(param1:*):void
            {
               mUpdateMessagePopup.destroy();
               parseResponse(param1);
            },parseError);
         }
      }
      
      public function getAllMapnodeScoresRPC(param1:uint) : void
      {
         var avatarArray:Array;
         var rpcFunc:Function;
         var requestor:uint = param1;
         if(requestor != mDBFacade.dbAccountInfo.id)
         {
            Logger.debug("getAllMapnodeScoresRPC: requestor not mDBFacade.dbAccountInfo.id...return");
            return;
         }
         if(friendInfos.size == 0)
         {
            Logger.debug("getAllMapnodeScoresRPC: friendInfo not set yet...return");
            return;
         }
         avatarArray = mDBFacade.dbAccountInfo.inventoryInfo.avatars.keysToArray();
         rpcFunc = JSONRPCService.getFunction("getAllMapnodeScores",mDBFacade.rpcRoot + "championsboard");
         rpcFunc(mDBFacade.dbAccountInfo.id,friendInfos.keysToArray(),avatarArray,mDBFacade.validationToken,function(param1:*):void
         {
            parseScoreResponse(param1);
         },parseError);
      }
      
      public function updateFacebookFriendsRPC(param1:Array, param2:String, param3:Boolean) : void
      {
         var friends:Array = param1;
         var newFriendsHash:String = param2;
         var cascade:Boolean = param3;
         var rpcFunc:Function = JSONRPCService.getFunction("updateFBFriends",mDBFacade.rpcRoot + "leaderboard");
         var callback:Function = function(param1:*):void
         {
            mCurrentFriendsHash = newFriendsHash;
            parseFriendData(param1);
            mEventComponent.dispatchEvent(new Event("REFRESH_FRIENDS_EVENT"));
         };
         rpcFunc(mDBFacade.dbAccountInfo.id,mDBFacade.validationToken,friends,newFriendsHash,cascade,callback);
      }
      
      public function updateDRFriendsRPC(param1:Array, param2:String) : void
      {
         var _loc3_:Function = JSONRPCService.getFunction("inviteNewDRFriends",mDBFacade.rpcRoot + "leaderboard");
         mCurrentFriendsHash = param2;
         _loc3_(mDBFacade.dbAccountInfo.id,mDBFacade.validationToken,param1,param2,mDBFacade.dbAccountInfo.name,mDBFacade.dbAccountInfo.trophies,mDBFacade.dbAccountInfo.activeAvatarSkinId,mDBFacade.dbAccountInfo.facebookId);
      }
      
      public function updateKongregateFriendsRPC(param1:Array, param2:String, param3:Boolean) : void
      {
         var friends:Array = param1;
         var newFriendsHash:String = param2;
         var cascade:Boolean = param3;
         var rpcFunc:Function = JSONRPCService.getFunction("updateKongregateFriends",mDBFacade.rpcRoot + "leaderboard");
         var callback:Function = function(param1:*):void
         {
            mCurrentFriendsHash = newFriendsHash;
            parseFriendData(param1);
            mEventComponent.dispatchEvent(new Event("REFRESH_FRIENDS_EVENT"));
         };
         rpcFunc(mDBFacade.dbAccountInfo.id,mDBFacade.validationToken,friends,newFriendsHash,cascade,callback);
      }
      
      public function parseFriendResponse(param1:*, param2:Boolean = true) : void
      {
         if(param1.friends_hash)
         {
            mCurrentFriendsHash = param1.friends_hash as String;
         }
      }
      
      public function parseScoreResponse(param1:Object, param2:Boolean = true) : void
      {
         if(param1 == null)
         {
            Logger.error("Got empty array on parseScoreResponse");
            return;
         }
         var _loc4_:II_AccountTopScoreInfo = new II_AccountTopScoreInfo(param1.top_scores);
         var _loc3_:IMapIterator = friendInfos.iterator() as IMapIterator;
         while(_loc3_.hasNext())
         {
            _loc3_.next();
            _loc3_.current.parseChampionsboardData(_loc4_.accountIdToTopScoreMapnodeInfo.itemFor(_loc3_.current.id));
            if(_loc3_.current.id == mDBFacade.accountId)
            {
               _loc3_.current.parseIIAvatarScoresData(param1.avatar_scores);
            }
         }
      }
      
      public function parseResponse(param1:*, param2:Boolean = true) : void
      {
         if(param1 == null || param1.length <= 0)
         {
            Logger.error("Got empty array on parseResponse");
            return;
         }
         mCompletedMapnodeMask.init(param1.completed_mapnode_mask);
         mAccountFlags = param1.account_flags as uint;
         var _loc3_:int = int(param1.active_avatar);
         mInventory.parseJson(param1);
         mActiveAvatar = mInventory.getAvatarInfoForAvatarInstanceId(_loc3_);
         mEventComponent.dispatchEvent(new Event("ACTIVE_AVATAR_CHANGED_EVENT"));
         parseCurrency(param1);
         if(param1.account_attributes)
         {
            parseAttributes(param1.account_attributes);
         }
         mId = param1.id;
         mName = param1.name;
         mInventoryLimitWeapons = param1.buckets_weapon;
         mInventoryLimitOther = param1.buckets_other;
         mAccountCreatedDate = param1.created as String;
         mDungeonsCompleted = param1.completed_dungeons;
         mDBAccountParams = new DBAccountParams(mDBFacade,this);
         if(param2)
         {
            mEventComponent.dispatchEvent(new DBAccountResponseEvent(this));
         }
      }
      
      public function getCompletedMapnodeMask() : Utf8BitArray
      {
         return mCompletedMapnodeMask;
      }
      
      private function parseError(param1:Error) : void
      {
         if(mErrorPopUp)
         {
            return;
         }
         mErrorPopUp = new DBUIPopup(mDBFacade,"Error getting account info.");
         mLogicalWorkComponent.doLater(1.5,killErrorPopUp);
      }
      
      private function killErrorPopUp(param1:GameClock) : void
      {
         if(mErrorPopUp)
         {
            mErrorPopUp.destroy();
            mErrorPopUp = null;
         }
      }
      
      public function get dbAccountParams() : DBAccountParams
      {
         return mDBAccountParams;
      }
      
      public function incrementCompletedDungeons() : void
      {
         mDungeonsCompleted++;
      }
      
      public function getDungeonsCompleted() : uint
      {
         return mDungeonsCompleted;
      }
      
      public function get localFriendInfo() : FriendInfo
      {
         return mLocalFriendInfo;
      }
   }
}

