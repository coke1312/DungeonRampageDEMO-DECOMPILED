package FacebookAPI
{
   import Brain.FacebookAPI.FacebookAPIController;
   import Brain.Logger.Logger;
   import Brain.Utils.SplitTestRules;
   import Facade.DBFacade;
   import GameMasterDictionary.GMAchievement;
   import GameMasterDictionary.GMFeedPosts;
   import Metrics.PixelTracker;
   import com.adobe.serialization.json.JSON;
   import com.facebook.graph.Facebook;
   import flash.events.Event;
   import flash.external.ExternalInterface;
   import flash.net.URLLoader;
   import flash.net.URLRequest;
   import flash.net.URLVariables;
   import flash.system.ApplicationDomain;
   import flash.system.LoaderContext;
   
   public class DBFacebookAPIController extends FacebookAPIController
   {
      
      public static const PURCHASE:String = "PURCHASE";
      
      public static const CHEST_UNLOCK:String = "CHEST_UNLOCK";
      
      public static const MAP_NODE_DEFEATED:String = "MAP_NODE_DEFEATED";
      
      public static const LEADERBOARD_OFFLINE_MESSAGE:String = "MESSAGE";
      
      public static const INVITE_FRIEND_REQUEST:String = "INVITE_REQUEST";
      
      public static const SEND_GIFT_REQUEST:String = "SEND_GIFT_REQUEST";
      
      public static const METRICS_PERSONAL_WALL_POST:String = "dbfbwp";
      
      public static const METRICS_FRIEND_WALL_POST:String = "dbfbwf";
      
      public static const COMPLETED_FIRST_DUNGEON_ACHIEVEMENT:uint = 1;
      
      public static const CHARACTER_LEVEL_ACHIEVEMENT_1:uint = 2;
      
      public static const MEDIC_ACHIEVEMENT:uint = 3;
      
      public static const SOCIALITE_ACHIEVEMENT:uint = 4;
      
      public static const BIG_BALLER_ACHIEVEMENT:uint = 5;
      
      public static const DEATH_ACHIEVEMENT:uint = 6;
      
      public static const LEVEL_ACHIEVEMENT_1:uint = 5;
      
      public static const DEATH_ACHIEVEMENT_1:uint = 10;
      
      private const dbFacebook_script_js:XML;
      
      private var mDBFacade:DBFacade;
      
      private var mLeaderBoardFeedPosts:Vector.<GMFeedPosts>;
      
      private var mFriendInvitePosts:Vector.<GMFeedPosts>;
      
      private var mGiftFriendPosts:Vector.<GMFeedPosts>;
      
      private var mLevelUpPostController:DBFacebookLevelUpPostController;
      
      private var mAppURL:String;
      
      private var mFeedLink:String;
      
      private var mThirdPartyId:String = "";
      
      private var mFriendsCallIsRunning:Boolean = false;
      
      public function DBFacebookAPIController(param1:DBFacade)
      {
         var _loc2_:int = 0;
         dbFacebook_script_js = <script>
				<![CDATA[
					function() 
					{
						DBFacebook = 
						{
							debugResults : function(debugData)
							{
								console.log(debugData);
							},			
							getAppURL : function()
							{
								return window.location.href;
							}
						};
					}
				]]>
			</script>;
         mScope = "user_birthday,email,publish_actions";
         super(param1,param1.facebookId);
         mDBFacade = param1;
         if(ExternalInterface.available)
         {
            ExternalInterface.call(dbFacebook_script_js);
            mAppURL = ExternalInterface.call("DBFacebook.getAppURL");
         }
         else
         {
            mAppURL = "./";
         }
         Logger.debug("DBFacebookAPIController: " + mAppURL);
         if(mDBFacade.isFacebookPlayer)
         {
            _loc2_ = int(mAppURL.indexOf("facebook/"));
         }
         else if(mDBFacade.isKongregatePlayer)
         {
            _loc2_ = int(mAppURL.indexOf("kongregate/"));
         }
         else
         {
            _loc2_ = 0;
         }
         if(_loc2_ > 0)
         {
            mAppURL = mAppURL.slice(0,_loc2_);
         }
         Logger.debug("DBFacebookAPIController: " + mAppURL);
         mLeaderBoardFeedPosts = new Vector.<GMFeedPosts>();
         mFriendInvitePosts = new Vector.<GMFeedPosts>();
         mGiftFriendPosts = new Vector.<GMFeedPosts>();
         mLevelUpPostController = new DBFacebookLevelUpPostController(mDBFacade,dbFeedPost);
         mFeedLink = "http://apps.facebook.com/" + mDBFacade.facebookApplication.toString();
      }
      
      public static function getFeedPosts(param1:DBFacade, param2:uint, param3:String) : Vector.<GMFeedPosts>
      {
         var _loc5_:Vector.<GMFeedPosts> = new Vector.<GMFeedPosts>();
         for each(var _loc4_ in param1.gameMaster.FeedPosts)
         {
            if(_loc4_.Category == param3 && _loc4_.IdTrigger == param2)
            {
               _loc5_.push(_loc4_);
            }
         }
         return _loc5_;
      }
      
      public static function earnCredits(param1:DBFacade, param2:Function) : void
      {
         if(!param1.isFacebookPlayer)
         {
            return;
         }
         Logger.debug("earnCredits: " + param1.dbAccountInfo.id.toString());
         var _loc3_:String = param1.facebookController.appUrl + "currencyoffers/inappcurrencyoffers";
         var _loc4_:Object = {
            "action":"earn_currency",
            "product":_loc3_
         };
         if(param1.facebookThirdPartyId == "0")
         {
            param1.facebookController.queryThirdPartyId(callJSEarnCurrency);
         }
         else
         {
            callJSEarnCurrency(param1,param1.facebookThirdPartyId);
         }
      }
      
      private static function callJSEarnCurrency(param1:DBFacade, param2:String) : void
      {
         if(ExternalInterface.available)
         {
            ExternalInterface.call("earnCredits",param2);
         }
      }
      
      public function queryThirdPartyId(param1:Function = null) : void
      {
         var loginCallback:Function;
         var callback:Function = param1;
         if(!mDBFacade.isFacebookPlayer)
         {
            return;
         }
         if(!mAccessToken)
         {
            loginCallback = function():void
            {
               getNewThirdPartyId(callback);
            };
            handleLogin(loginCallback);
         }
         else
         {
            getNewThirdPartyId(callback);
         }
      }
      
      private function getNewThirdPartyId(param1:Function = null) : void
      {
         var callback:Function = param1;
         if(!mDBFacade.isFacebookPlayer)
         {
            return;
         }
         Facebook.api("/me",function(param1:Object, param2:Object):void
         {
            if(param1)
            {
               mThirdPartyId = param1.third_party_id;
               mDBFacade.facebookThirdPartyId = mThirdPartyId;
               if(callback != null)
               {
                  callback(mDBFacade,mThirdPartyId);
               }
            }
            if(param2)
            {
               Logger.debug("failed to get third party id");
            }
         },{"fields":"third_party_id"});
      }
      
      public function getFacebookFriendsHash() : void
      {
         if(mDBFacade.isKongregatePlayer || mDBFacade.isDRPlayer)
         {
            return;
         }
         if(mFriendsCallIsRunning)
         {
            return;
         }
         friendsHash();
      }
      
      private function friendsHash(param1:Boolean = false) : void
      {
         var isRetry:Boolean = param1;
         mFriendsCallIsRunning = true;
         Facebook.api("/me/friends",function(param1:Object, param2:Object):void
         {
            var fbIdArray:Array;
            var fbObject:Object;
            var fbIdString:String;
            var id:String;
            var currentFriendsHash:String;
            var newFriendHash:String;
            var cascade:Boolean;
            var loginCallback:Function;
            var response:Object = param1;
            var fail:Object = param2;
            Logger.debug("Obtained friends from facebook");
            mFriendsCallIsRunning = false;
            if(response)
            {
               fbIdArray = [];
               for each(fbObject in response)
               {
                  fbIdArray.push(fbObject.id);
               }
               fbIdArray.sort();
               fbIdString = "";
               for each(id in fbIdArray)
               {
                  fbIdString = fbIdString.concat(id + ",");
               }
               currentFriendsHash = mDBFacade.dbAccountInfo.currentFacebookFriendsHash;
               newFriendHash = SplitTestRules.getStringHash(fbIdString);
               if(newFriendHash != currentFriendsHash)
               {
                  cascade = false;
                  if(currentFriendsHash == "" || currentFriendsHash == null)
                  {
                     cascade = true;
                  }
                  if(mDBFacade.isFacebookPlayer)
                  {
                     mDBFacade.dbAccountInfo.updateFacebookFriendsRPC(fbIdArray,newFriendHash,cascade);
                  }
                  else if(mDBFacade.isDRPlayer)
                  {
                     mDBFacade.dbAccountInfo.updateDRFriendsRPC(fbIdArray,newFriendHash);
                  }
               }
            }
            else
            {
               Logger.debug("FB /me/friends call failed");
               if(!isRetry)
               {
                  loginCallback = function():void
                  {
                     friendsHash(true);
                  };
                  handleLogin(loginCallback);
               }
            }
         });
      }
      
      public function getKongregateFriendsHash() : void
      {
         var _loc1_:* = mDBFacade.kongregateAPI;
         if(_loc1_.services.isGuest())
         {
            return;
         }
         var _loc2_:Array = [];
         loadKongregateFriendRequest(1,_loc2_);
      }
      
      private function loadKongregateFriendRequest(param1:int, param2:Array) : void
      {
         var urlReq:URLRequest;
         var context:LoaderContext;
         var urlLoader:URLLoader;
         var cb:Function;
         var page:int = param1;
         var friendIdsArray:Array = param2;
         var kongregateAPI:* = mDBFacade.kongregateAPI;
         var urlVars:URLVariables = new URLVariables();
         var userId:String = kongregateAPI.services.getUserId();
         urlVars.user_id = userId;
         urlVars.page_num = page;
         urlVars.friends = true;
         urlReq = new URLRequest("http://api.kongregate.com/api/user_info.json");
         urlReq.data = urlVars;
         urlReq.method = "GET";
         context = new LoaderContext();
         context.checkPolicyFile = true;
         context.applicationDomain = ApplicationDomain.currentDomain;
         urlLoader = new URLLoader(urlReq);
         cb = function(param1:Event):void
         {
            kongregateFriendResponse(param1,friendIdsArray);
         };
         urlLoader.addEventListener("ioError",ioErrorHandler);
         urlLoader.addEventListener("securityError",securityErrorHandler);
         urlLoader.addEventListener("complete",cb);
         urlLoader.load(urlReq);
      }
      
      private function kongregateFriendResponse(param1:Event, param2:Array) : void
      {
         var _loc3_:Object = com.adobe.serialization.json.JSON.decode(param1.target.data as String);
         for each(var _loc4_ in _loc3_.friend_ids)
         {
            param2.push(_loc4_.toString());
         }
         if(_loc3_.page_num < _loc3_.num_pages)
         {
            loadKongregateFriendRequest(_loc3_.page_num + 1,param2);
         }
         else
         {
            buildKongregateFriendsHash(param2);
         }
      }
      
      private function buildKongregateFriendsHash(param1:Array) : void
      {
         var _loc3_:Boolean = false;
         param1.sort();
         var _loc4_:String = "";
         for each(var _loc5_ in param1)
         {
            _loc4_ = _loc4_.concat(_loc5_ + ",");
         }
         var _loc6_:String = mDBFacade.dbAccountInfo.currentKongregateFriendsHash;
         var _loc2_:String = SplitTestRules.getStringHash(_loc4_);
         if(_loc2_ != _loc6_)
         {
            _loc3_ = false;
            if(_loc6_ == "" || _loc6_ == null)
            {
               _loc3_ = true;
            }
            mDBFacade.dbAccountInfo.updateKongregateFriendsRPC(param1,_loc2_,_loc3_);
         }
      }
      
      private function feedResponseCallback(param1:String, param2:Object) : void
      {
         var _loc3_:String = null;
         if(param2)
         {
            _loc3_ = param2.post_id.toString();
            _loc3_ = _loc3_.split("_")[0];
            if(_loc3_ == mDBFacade.facebookPlayerId)
            {
               mDBFacade.metrics.log("WallPostSuccess",{"feed":param1});
            }
            else
            {
               mDBFacade.metrics.log("WallPostSuccess",{
                  "feed":param1,
                  "friendId":_loc3_
               });
            }
            PixelTracker.wallPost(mDBFacade);
         }
         else
         {
            mDBFacade.metrics.log("WallPostCancel",{"feed":param1});
         }
      }
      
      private function giftCallback(param1:Object, param2:uint) : void
      {
         var _loc7_:String = null;
         var _loc9_:Array = null;
         var _loc8_:Array = null;
         var _loc5_:Array = null;
         var _loc4_:String = null;
         var _loc6_:Array = null;
         if(param1)
         {
            _loc7_ = param1.request.toString();
            _loc9_ = param1.to as Array;
            _loc8_ = [];
            _loc5_ = [];
            for each(var _loc3_ in _loc9_)
            {
               _loc4_ = mDBFacade.dbConfigManager.networkId + "_" + _loc7_ + "_" + _loc3_;
               _loc5_.push(_loc4_);
               _loc8_.push(_loc3_);
               mDBFacade.metrics.log("GiftRequest",{
                  "requestId:":_loc4_,
                  "userId":mDBFacade.accountId,
                  "friendId":_loc3_
               });
               PixelTracker.invitedFriend(mDBFacade);
            }
            _loc6_ = mDBFacade.dbAccountInfo.giftExcludeIds;
            mDBFacade.dbAccountInfo.giftExcludeIds = _loc6_.concat(_loc8_);
            mDBFacade.dbAccountInfo.sendGiftData(param2,_loc5_,_loc8_);
            mDBFacade.dbAccountInfo.sendFacebookRequestData(_loc5_,_loc8_);
         }
      }
      
      private function friendRequestCallback(param1:Object) : void
      {
         var _loc5_:String = null;
         var _loc6_:Array = null;
         var _loc4_:Array = null;
         var _loc3_:String = null;
         if(param1)
         {
            _loc5_ = param1.request.toString();
            _loc6_ = param1.to as Array;
            _loc4_ = [];
            for each(var _loc2_ in _loc6_)
            {
               _loc3_ = mDBFacade.dbConfigManager.networkId + "_" + _loc5_ + "_" + _loc2_;
               _loc4_.push(_loc3_);
               mDBFacade.metrics.log("FriendRequest",{
                  "requestId:":_loc3_,
                  "userId":mDBFacade.accountId,
                  "friendId":_loc2_
               });
               PixelTracker.invitedFriend(mDBFacade);
            }
            mDBFacade.dbAccountInfo.sendFacebookRequestData(_loc4_,_loc6_);
         }
      }
      
      public function genericFriendRequests(param1:Boolean = false) : void
      {
         var loginCallback:Function;
         var filters:Array;
         var feedPostData:GMFeedPosts;
         var randomPost:uint;
         var isRetry:Boolean = param1;
         if(!mDBFacade.isFacebookPlayer)
         {
            return;
         }
         Logger.debug("genericFriendRequests: start");
         if(!mAccessToken && !isRetry)
         {
            loginCallback = function():void
            {
               Logger.debug("genericFriendRequests: retry = true");
               genericFriendRequests(true);
            };
            Logger.debug("genericFriendRequests: handleLogin");
            handleLogin(loginCallback);
            return;
         }
         if(mDBFacade.isDRPlayer)
         {
            friendsHash(true);
         }
         filters = ["app_non_users"];
         if(mFriendInvitePosts.length == 0)
         {
            for each(feedPostData in mDBFacade.gameMaster.FeedPosts)
            {
               if(feedPostData.Category == "INVITE_REQUEST")
               {
                  mFriendInvitePosts.push(feedPostData);
               }
            }
         }
         if(mFriendInvitePosts.length > 0)
         {
            randomPost = Math.floor(Math.random() * mFriendInvitePosts.length);
            friendRequests(mFriendInvitePosts[randomPost].FeedCaption,mFriendInvitePosts[randomPost].FeedName,"dialog",friendRequestCallback,filters);
         }
      }
      
      private function dbFeedPost(param1:GMFeedPosts, param2:String = "", param3:String = "", param4:Boolean = false, param5:Object = null) : void
      {
         var loginCallback:Function;
         var feedName:String;
         var key:String;
         var feedCaption:String;
         var feedDescription:String;
         var uriEncoded:String;
         var metricsCampaign:String;
         var metricsFeedLink:String;
         var propertiesObject:Object;
         var actionsObject:Object;
         var picUrl:String;
         var kStr:String;
         var gmFeedPost:GMFeedPosts = param1;
         var receiverId:String = param2;
         var pic:String = param3;
         var isRetry:Boolean = param4;
         var replaceDict:Object = param5;
         if(!mDBFacade.isKongregatePlayer && !mAccessToken && !isRetry)
         {
            loginCallback = function():void
            {
               dbFeedPost(gmFeedPost,receiverId,pic,true);
            };
            handleLogin(loginCallback);
            return;
         }
         if(replaceDict == null)
         {
            replaceDict = {};
         }
         replaceDict["#NAME"] = mDBFacade.dbAccountInfo.name;
         replaceDict["#CHARACTER"] = mDBFacade.dbAccountInfo.activeAvatarInfo.gmHero.Name;
         feedName = "";
         if(gmFeedPost.FeedName)
         {
            feedName = gmFeedPost.FeedName;
            for(key in replaceDict)
            {
               feedName = feedName.replace(key,replaceDict[key]);
            }
         }
         feedCaption = "";
         if(gmFeedPost.FeedCaption)
         {
            feedCaption = gmFeedPost.FeedCaption;
            for(key in replaceDict)
            {
               feedCaption = feedCaption.replace(key,replaceDict[key]);
            }
         }
         feedDescription = " ";
         if(gmFeedPost.FeedDescriptions)
         {
            feedDescription = gmFeedPost.FeedDescriptions;
            for(key in replaceDict)
            {
               feedDescription = feedDescription.replace(key,replaceDict[key]);
            }
         }
         uriEncoded = escape(mFeedLink);
         metricsCampaign = "dbfbwp";
         metricsFeedLink = mAppURL + "track/?anxrc=" + metricsCampaign + "&anxrs=" + mDBFacade.accountId.toString() + "&redirect=" + uriEncoded;
         propertiesObject = null;
         actionsObject = null;
         if(gmFeedPost.FeedActionsName)
         {
            actionsObject = [{
               "name":gmFeedPost.FeedActionsName,
               "link":metricsFeedLink
            }];
         }
         if(pic != "")
         {
            picUrl = mAppURL + pic;
         }
         else
         {
            picUrl = mAppURL + gmFeedPost.FeedImageLink;
         }
         mDBFacade.metrics.log("WallPostPrompt",{"feed":gmFeedPost.Constant});
         if(mDBFacade.isKongregatePlayer)
         {
            kStr = feedDescription;
            if(kStr == " ")
            {
               kStr = feedCaption;
            }
            if(kStr == "")
            {
               kStr = feedName;
            }
            Logger.debug("Calling Kongregate showFeedPostBox");
            mDBFacade.kongregateAPI.services.showFeedPostBox({
               "content":kStr,
               "image_uri":picUrl,
               "kv_params":{}
            });
         }
         else
         {
            Logger.debug("Calling Facebook feedPost");
            feedPost(feedName,feedCaption,feedDescription,metricsFeedLink,picUrl,"dialog",function(param1:Object):void
            {
               feedResponseCallback(gmFeedPost.Constant,param1);
            },receiverId,propertiesObject,actionsObject);
         }
      }
      
      public function askForKeys(param1:String) : void
      {
         if(!mDBFacade.isFacebookPlayer)
         {
            return;
         }
         var _loc2_:GMFeedPosts = mDBFacade.gameMaster.feedPostsByConstant.itemFor(param1);
         if(_loc2_)
         {
            this.dbFeedPost(_loc2_);
         }
      }
      
      public function purchaseFeedPost(param1:uint) : void
      {
         this.categoryFeedPost(param1,"PURCHASE");
      }
      
      public function chestUnlockFeedPost(param1:uint, param2:String, param3:String, param4:String) : void
      {
         this.categoryFeedPost(param1,"CHEST_UNLOCK",param4,{
            "#ITEM":param2,
            "#FULL_ITEM":param3
         });
      }
      
      public function mapNodeDefeatedFeedPost(param1:uint, param2:String) : void
      {
         this.categoryFeedPost(param1,"MAP_NODE_DEFEATED","",{"#NODE":param2});
      }
      
      private function categoryFeedPost(param1:uint, param2:String, param3:String = "", param4:Object = null) : void
      {
         var _loc5_:* = 0;
         if(!param1 || param1 == 0)
         {
            return;
         }
         var _loc6_:Vector.<GMFeedPosts> = getFeedPosts(mDBFacade,param1,param2);
         if(_loc6_.length > 0)
         {
            _loc5_ = Math.floor(Math.random() * _loc6_.length);
            this.dbFeedPost(_loc6_[_loc5_],"",param3,false,param4);
         }
      }
      
      public function leaderboardFeedPostToASingleUser(param1:String) : void
      {
         var _loc3_:* = 0;
         if(mLeaderBoardFeedPosts.length == 0)
         {
            for each(var _loc2_ in mDBFacade.gameMaster.FeedPosts)
            {
               if(_loc2_.Category == "MESSAGE")
               {
                  mLeaderBoardFeedPosts.push(_loc2_);
               }
            }
         }
         if(mLeaderBoardFeedPosts.length > 0)
         {
            _loc3_ = Math.floor(Math.random() * mLeaderBoardFeedPosts.length);
            this.dbFeedPost(mLeaderBoardFeedPosts[_loc3_],param1);
         }
      }
      
      public function sendGiftRequests(param1:String, param2:uint, param3:String = "") : void
      {
         var filters:Array;
         var feedCaption:String;
         var excludeIds:Array;
         var data:Object;
         var feedPostData:GMFeedPosts;
         var randomPost:uint;
         var callback:Function;
         var giftName:String = param1;
         var giftOfferID:uint = param2;
         var facebookIds:String = param3;
         if(!mDBFacade.isFacebookPlayer)
         {
            return;
         }
         filters = ["all","app_non_users","app_users"];
         feedCaption = " ";
         excludeIds = mDBFacade.dbAccountInfo.giftExcludeIds;
         data = {"offerID":giftOfferID};
         if(mGiftFriendPosts.length == 0)
         {
            for each(feedPostData in mDBFacade.gameMaster.FeedPosts)
            {
               if(feedPostData.Category == "SEND_GIFT_REQUEST")
               {
                  mGiftFriendPosts.push(feedPostData);
               }
            }
         }
         Logger.debug("sendGiftRequests: giftFriendPosts count: " + mGiftFriendPosts.length);
         if(mGiftFriendPosts.length > 0)
         {
            randomPost = Math.floor(Math.random() * mGiftFriendPosts.length);
            callback = function(param1:Object):void
            {
               Logger.debug("sendGiftRequests: facebook calling giftCallback.");
               giftCallback(param1,giftOfferID);
            };
            if(mGiftFriendPosts[randomPost].FeedCaption)
            {
               feedCaption = mGiftFriendPosts[randomPost].FeedCaption;
               feedCaption = feedCaption.replace("#NAME",mDBFacade.dbAccountInfo.name);
            }
            friendRequests(feedCaption,mGiftFriendPosts[randomPost].FeedName,"dialog",callback,filters,data,"50",facebookIds,excludeIds);
         }
      }
      
      public function updateGuestAchievement(param1:uint) : void
      {
         if(!mDBFacade.isFacebookPlayer)
         {
            return;
         }
         if(mDBFacade.dbAccountInfo.dbAccountParams.hasAchievement(param1))
         {
            return;
         }
         mDBFacade.dbAccountInfo.dbAccountParams.setAchievement(param1);
         var _loc2_:String = "";
         switch(int(param1) - 1)
         {
            case 0:
               _loc2_ = "ach1";
            case 1:
               _loc2_ = "ach2";
            case 2:
               _loc2_ = "ach3";
            case 3:
               _loc2_ = "ach4";
            case 4:
               _loc2_ = "ach5";
            case 5:
               _loc2_ = "ach6";
         }
         var _loc3_:String = mAppURL + "achievements?ach=" + _loc2_;
         mDBFacade.dbAccountInfo.addAchievement(_loc2_,_loc3_,achievementSuccessCallback);
      }
      
      private function achievementSuccessCallback(param1:String) : void
      {
         var _loc2_:GMAchievement = mDBFacade.gameMaster.achievementsById.itemFor(param1);
         if(!_loc2_)
         {
            return;
         }
         var _loc3_:Object = {
            "accountId":mDBFacade.accountId,
            "facebookId":mDBFacade.facebookId,
            "achievementId":_loc2_.Id,
            "achievementName":_loc2_.Name,
            "achievementPoints":_loc2_.Points
         };
         mDBFacade.metrics.log("AchievementEarned",_loc3_);
      }
      
      private function completeHandler(param1:Event) : void
      {
         Logger.info("Player scores updated Successfully");
      }
      
      private function securityErrorHandler(param1:Event) : void
      {
         Logger.warn("SecurityError on scores logging: " + param1.toString());
      }
      
      private function ioErrorHandler(param1:Event) : void
      {
         Logger.warn("IOError on scores logging: " + param1.toString());
      }
      
      private function get appUrl() : String
      {
         return mAppURL;
      }
      
      public function get thirdPartyId() : String
      {
         return mThirdPartyId;
      }
      
      public function destroy() : void
      {
         mDBFacade = null;
      }
   }
}

