package Facade
{
   import Account.AccountBonus;
   import Account.DBAccountInfo;
   import Account.FacebookAccountInfo;
   import Account.StoreServices;
   import Brain.AssetRepository.AssetLoadingComponent;
   import Brain.AssetRepository.ImageAsset;
   import Brain.AssetRepository.JsonAsset;
   import Brain.Clock.GameClock;
   import Brain.Facade.Facade;
   import Brain.Logger.Logger;
   import Brain.Render.MovieClipPool;
   import Brain.UI.UIProgressBar;
   import Brain.WorkLoop.LogicalWorkComponent;
   import Brain.WorkLoop.Task;
   import Brain.jsonRPC.JSONRPCService;
   import Combat.Attack.TimelineFactory;
   import Config.ConfigFileLoadedEvent;
   import Config.DBConfigManager;
   import DistributedObjects.DistributedObjectManager;
   import Effects.EffectPool;
   import Events.ManagersLoadedEvent;
   import FacebookAPI.DBFacebookAPIController;
   import GameMasterDictionary.GameMaster;
   import GeneratedCode.InfiniteMapNodeDetail;
   import MagicWords.MagicWordManager;
   import Metrics.MetricsLogger;
   import Metrics.PixelTracker;
   import Sound.DBSoundManager;
   import StateMachine.MainStateMachine.LoadingFinishedEvent;
   import StateMachine.MainStateMachine.MainStateMachine;
   import Town.AdManager;
   import UI.DBUIOneButtonPopup;
   import UI.UIHud;
   import avmplus.getQualifiedClassName;
   import com.amanitadesign.steam.FRESteamWorks;
   import com.maccherone.json.JSON;
   import flash.display.DisplayObject;
   import flash.display.Loader;
   import flash.display.LoaderInfo;
   import flash.display.MovieClip;
   import flash.display.Shape;
   import flash.display.Stage;
   import flash.events.Event;
   import flash.events.FocusEvent;
   import flash.events.IOErrorEvent;
   import flash.events.KeyboardEvent;
   import flash.events.SecurityErrorEvent;
   import flash.external.ExternalInterface;
   import flash.net.URLRequest;
   import flash.net.navigateToURL;
   import flash.profiler.showRedrawRegions;
   import flash.system.Capabilities;
   import flash.system.LoaderContext;
   import flash.system.Security;
   import flash.text.TextField;
   import org.as3commons.collections.Map;
   
   public class DBFacade extends Facade
   {
      
      private static const CLIENT_ERROR_EVENT:String = "CLIENT_ERROR_EVENT";
      
      public static const VALIDATION_REFRESH_TIME:Number = 3600;
      
      private static const ORDER_COMPLETE_EXTERNAL_INTERFACE:String = "orderComplete";
      
      private static var mDownloadRoot:String = "";
      
      public static const NETWORK_FACEBOOK:uint = 1;
      
      public static const NETWORK_KONGREGATE:uint = 2;
      
      public static const NETWORK_DRCOM:uint = 3;
      
      private var LoadingClass:Class = §loading_screen_swf$b31f9ff8857b06fb7b60dbf96800c1dc-678235932§;
      
      private var mInitialLoadingClip:MovieClip;
      
      private var mLoadingBar:UIProgressBar;
      
      private var mLoadingBarIntStatus:Number = 0;
      
      protected var mMainStateMachine:MainStateMachine;
      
      protected var mDBAccountInfo:DBAccountInfo;
      
      protected var mFacebookAccountInfo:FacebookAccountInfo;
      
      protected var mDBConfigManager:DBConfigManager;
      
      protected var mHud:UIHud;
      
      protected var mEffectPool:EffectPool;
      
      protected var mMovieClipPool:MovieClipPool;
      
      protected var mMetricsLogger:MetricsLogger;
      
      protected var mTileLibraryMap:Map;
      
      protected var mLibraryJsonLoaded:Boolean = false;
      
      protected var mTimelineFinishedLoading:Boolean = false;
      
      protected var mTimelineFactory:TimelineFactory;
      
      protected var mGameMasterJsonLoaded:Boolean = false;
      
      protected var mLibraryJson:Array;
      
      protected var mGameMasterJson:Object;
      
      protected var mDBFaceBookAPIController:DBFacebookAPIController;
      
      protected var mAccountBonus:AccountBonus;
      
      public var gameMaster:GameMaster;
      
      protected var mAssetLoader:AssetLoadingComponent;
      
      protected var mMagicWordManager:MagicWordManager;
      
      private var mWebAPIRoot:String;
      
      private var mRPCRoot:String;
      
      private var mSteamAPIRoot:String;
      
      private var mAccountId:uint;
      
      private var mFacebookId:String;
      
      private var mFacebookPlayerId:String;
      
      private var mFacebookThirdPartyId:String;
      
      private var mFacebookApplication:String;
      
      private var mValidationToken:String;
      
      private var mDemographics:Object;
      
      private var mHiddenFocusText:TextField;
      
      public var mDistributedObjectManager:DistributedObjectManager;
      
      public var mCheckedDailyReward:Boolean;
      
      public var mInDailyReward:Boolean;
      
      protected var mTokenRegenTask:Task;
      
      private var mDelayErrors:Array;
      
      private var mLogicalWorkComponent:LogicalWorkComponent;
      
      private var mErrorTask:Task;
      
      private var mKongregate:*;
      
      private var mKongregatePlayerId:String;
      
      private var mSecurityGM:int = 0;
      
      private var mSecurityTL:int = 0;
      
      private var mSecuritySL:int = 0;
      
      protected var mAdManager:AdManager;
      
      public var mSteamworks:FRESteamWorks = new FRESteamWorks();
      
      public var mSteamUserId:String;
      
      public var mSteamAppId:uint = 0;
      
      public var mSteamPersonaName:String;
      
      public var mSteamWebApiAuthTicket:String;
      
      public var mSteamAuthTicketHandle:uint;
      
      public var mUseSteamLogin:Boolean;
      
      public var mAdditionalConfigFilesToLoad:Array = [];
      
      private var mShowCollisions:Boolean = false;
      
      public var NODE_RULES:uint = 0;
      
      private var tKongregateLoader:Loader;
      
      private var stagetwo_init_call_count:uint = 0;
      
      public function DBFacade()
      {
         mWantFramerateEnforcement = true;
         super();
         mTileLibraryMap = new Map();
         mCheckedDailyReward = false;
         mInDailyReward = false;
         if(Capabilities.playerType == "Desktop")
         {
            return;
         }
         Security.loadPolicyFile("https://ak.ssl.dungeonbusters.com/crossdomain.xml");
         Security.allowDomain("http://ak.ssl.dungeonbusters.com");
         Security.allowInsecureDomain("https://ak.ssl.dungeonbusters.com");
         Security.allowDomain("www.youtube.com");
         Security.loadPolicyFile("http://profile.ak.fbcdn.net/crossdomain.xml");
         Security.loadPolicyFile("https://fbstatic-a.akamaihd.net/crossdomain.xml");
         Security.loadPolicyFile("https://fbcdn-profile-a.akamaihd.net/crossdomain.xml");
         Security.loadPolicyFile("https://profile-a.xx.fbcdn.net/crossdomain.xml");
         Security.loadPolicyFile("https://profile-b.xx.fbcdn.net/crossdomain.xml");
         Security.allowDomain("http://profile.ak.fbcdn.net");
         Security.allowInsecureDomain("https://profile.ak.fbcdn.net");
         Security.allowDomain("http://profile-a.xx.fbcdn.net");
         Security.allowInsecureDomain("https://profile-a.xx.fbcdn.net");
         Security.allowDomain("http://profile-a.xx.fbcdn.net/hprofile-snc6/");
         Security.allowInsecureDomain("https://profile-a.xx.fbcdn.net/hprofile-snc6/");
         Security.allowDomain("http://fbcdn-profile-a.akamaihd.net");
         Security.allowInsecureDomain("https://fbcdn-profile-a.akamaihd.net");
         Security.allowDomain("http://fbcdn-profile-a.akamaihd.net/hprofile-ak-snc4/");
         Security.allowInsecureDomain("https://fbcdn-profile-a.akamaihd.net/hprofile-ak-snc4/");
         Security.allowDomain("http://fbcdn-profile-a.akamaihd.net/hprofile-ash4/");
         Security.allowInsecureDomain("https://fbcdn-profile-a.akamaihd.net/hprofile-ash4/");
         Security.allowDomain("http://fbcdn-profile-a.akamaihd.net/hprofile-ak-ash4/");
         Security.allowInsecureDomain("https://fbcdn-profile-a.akamaihd.net/hprofile-ak-ash4/");
         Security.allowDomain("http://fbstatic-a.akamaihd.net");
         Security.allowInsecureDomain("https://fbstatic-a.akamaihd.net");
         Security.allowDomain("http://s-static.ak.facebook.com");
         Security.allowInsecureDomain("https://s-static.ak.facebook.com");
         Security.loadPolicyFile("https://ads.sele.co/crossdomain.xml");
         Security.allowDomain("http://ads.sele.co");
         Security.allowInsecureDomain("https://ads.sele.co");
         Security.loadPolicyFile("https://dungionbusters.webfetti.com/crossdomain.xml");
         Security.allowDomain("https://dungionbusters.webfetti.com");
         killWebSecurity();
      }
      
      public static function get ROOT_DIR_old() : String
      {
         if(!mDownloadRoot)
         {
            Logger.error("Download root ROOT_DIR is not set yet.");
         }
         return mDownloadRoot;
      }
      
      public static function buildFullDownloadPath(param1:String) : String
      {
         if(param1 == "" || param1 == "null")
         {
            Logger.error("Trying to create a path from an empty string");
            return "";
         }
         return mDownloadRoot + param1;
      }
      
      public function killWebSecurity() : void
      {
         Security.allowDomain("*");
      }
      
      public function get showCollisions() : Boolean
      {
         return mShowCollisions;
      }
      
      public function set showCollisions(param1:Boolean) : void
      {
         mShowCollisions = param1;
         mSceneGraphManager.getLayer(40).visible = mShowCollisions;
      }
      
      override public function logCheater(param1:String) : void
      {
         var howICheat:String = param1;
         var requestFunc:Function = JSONRPCService.getFunction("LogCheater",rpcRoot + "store");
         requestFunc(dbAccountInfo.id,validationToken,howICheat,demographics,function():void
         {
         },function(param1:Error):void
         {
         });
      }
      
      public function get highQuality() : Boolean
      {
         return this.quality == "high";
      }
      
      public function set quality(param1:String) : void
      {
         mStageRef.quality = param1;
      }
      
      public function get quality() : String
      {
         return mStageRef.quality.toLowerCase();
      }
      
      private function loadBackground() : void
      {
         var countBackgroundImagesLoaded:int = 0;
         mAssetLoader.getImageAsset(DBFacade.buildFullDownloadPath("Resources/Art2D/background/left.jpg"),function(param1:ImageAsset):void
         {
            var _loc2_:DisplayObject = param1.image;
            var _loc3_:Number = viewHeight / _loc2_.height;
            _loc2_.scaleX = _loc3_;
            _loc2_.scaleY = _loc3_;
            _loc2_.x = -_loc2_.width;
            _loc2_.y = 0;
            addRootDisplayObject(_loc2_,1001);
            countBackgroundImagesLoaded++;
            if(countBackgroundImagesLoaded > 1)
            {
               mStageRef.displayState = "fullScreenInteractive";
            }
         });
         mAssetLoader.getImageAsset(DBFacade.buildFullDownloadPath("Resources/Art2D/background/right.jpg"),function(param1:ImageAsset):void
         {
            var _loc2_:DisplayObject = param1.image;
            var _loc3_:Number = viewHeight / _loc2_.height;
            _loc2_.scaleX = _loc3_;
            _loc2_.scaleY = _loc3_;
            _loc2_.x = viewWidth;
            _loc2_.y = 0;
            addRootDisplayObject(_loc2_,1001);
            countBackgroundImagesLoaded++;
            if(countBackgroundImagesLoaded > 1)
            {
               mStageRef.displayState = "fullScreenInteractive";
            }
         });
      }
      
      private function loadLocale() : void
      {
         var _loc4_:* = null;
         var _loc1_:String = "en_US";
         var _loc5_:* = Capabilities.language;
         if("en" !== _loc5_)
         {
            Logger.warn("Locale (" + Capabilities.language + ") not yet supported. Using default: " + _loc1_);
            _loc4_ = _loc1_;
         }
         else
         {
            _loc4_ = "en_US";
         }
         Logger.debug("System language: " + Capabilities.language);
         var _loc3_:String = mDBConfigManager.getConfigString("locale","");
         var _loc2_:String = _loc3_ ? _loc3_ : _loc4_;
         Logger.debug("Locale selected: " + _loc4_ + " config: " + _loc3_ + " final: " + _loc2_);
         Locale.loadStrings(this,_loc2_,localeAvailable);
         mMagicWordManager = new MagicWordManager(this);
      }
      
      public function createHUD() : void
      {
         if(mHud)
         {
            return;
         }
         mHud = new UIHud(this);
      }
      
      private function computeServerTimeOffset() : void
      {
         var _loc1_:Date = null;
         var _loc2_:String = mDBConfigManager.getConfigString("server_time","");
         if(_loc2_)
         {
            _loc1_ = GameClock.parseW3CDTF(_loc2_);
            GameClock.computeServerTimeOffset(_loc1_);
         }
         Logger.info("server time offset (ms): " + GameClock.serverTimeOffset);
      }
      
      override public function buildEngines() : void
      {
         Logger.info("building engines 0");
         loadBackground();
         Logger.info("building engines 1");
         loadLocale();
         Logger.info("building engines 2");
         computeServerTimeOffset();
         super.buildEngines();
         Logger.info("building engines 3");
         mSoundManager = new DBSoundManager(this);
         var _loc1_:Boolean = mDBConfigManager.getConfigBoolean("show_colliders",false);
         mSceneGraphManager.getLayer(40).visible = _loc1_;
         if(mDBConfigManager.getConfigBoolean("show_redraw_regions",false))
         {
            showRedrawRegions(true,16711680);
         }
         Logger.info("building engines 4");
         this.quality = mDBConfigManager.getConfigString("quality","high");
         mAccountId = mDBConfigManager.getConfigNumber("AccountId",0);
         if(mAccountId == 0)
         {
            Logger.error("AccountId is 0.  Cannot continue without a valid AccountId.");
         }
         Logger.info("building engines 5");
         mDemographics = mDBConfigManager.GetValueOrDefault("Demographics",{});
         mFacebookId = mDBConfigManager.getConfigString("FacebookAppId","");
         mFacebookPlayerId = mDBConfigManager.getConfigString("FacebookPlayerId","");
         mKongregatePlayerId = mDBConfigManager.getConfigString("KongregatePlayerId","");
         Logger.info("building engines 5.1");
         mFacebookThirdPartyId = mDBConfigManager.getConfigString("FacebookThirdPartyId","0");
         mFacebookApplication = mDBConfigManager.getConfigString("FacebookApplication","");
         Logger.info("building engines 6");
         mValidationToken = mDBConfigManager.getConfigString("API_ValidationToken","");
         Logger.info("building engines 7" + mValidationToken);
         if(mValidationToken == "")
         {
            Logger.error("ValidationToken is empty.  Cannot continue without a valid ValidationToken.");
         }
         Logger.info("building engines 8");
         Logger.info("DBFacade: accountId: " + mAccountId.toString() + " facebookId: " + mFacebookId.toString() + " Facebook Player Id:" + mFacebookPlayerId.toString() + " Facebook Application:" + mFacebookApplication.toString());
         mDBFaceBookAPIController = new DBFacebookAPIController(this);
         mFacebookAccountInfo = new FacebookAccountInfo(this);
         mAccountBonus = new AccountBonus(this);
         createTokenRegenTask();
         if(isKongregatePlayer)
         {
            kongregateInit();
         }
         logSystemMetrics();
         NODE_RULES = uint(getSplitTestBoolean("NODE_UNLOCK_GLOBAL",false));
      }
      
      private function kongregateInit() : void
      {
         var request:URLRequest;
         var context:LoaderContext;
         var paramObj:Object = LoaderInfo(stageRef.root.loaderInfo).parameters;
         var apiPath:String = paramObj.kongregate_api_path || "http://www.kongregate.com/flash/API_AS3_Local.swf";
         Security.allowDomain(apiPath);
         Logger.info("Loading Kongregate swf " + apiPath);
         request = new URLRequest(apiPath);
         context = new LoaderContext();
         context.checkPolicyFile = true;
         tKongregateLoader = new Loader();
         tKongregateLoader.contentLoaderInfo.addEventListener("complete",kongregateLoaded);
         tKongregateLoader.contentLoaderInfo.addEventListener("ioError",function(param1:IOErrorEvent):void
         {
            Logger.error("IOErrorEvent: " + param1.toString() + " Data:" + request.data.toString() + " URL:" + apiPath.toString());
         });
         tKongregateLoader.contentLoaderInfo.addEventListener("securityError",function(param1:SecurityErrorEvent):void
         {
            Logger.error("SecurityErrorEvent: " + param1.toString() + " Data:" + request.data.toString() + " URL:" + apiPath.toString());
         });
         tKongregateLoader.load(request,context);
         addRootDisplayObject(tKongregateLoader);
      }
      
      public function kongregateLoaded(param1:Event) : void
      {
         Logger.info("Kongregate swf loaded");
         mKongregate = param1.target.content;
         Logger.info("Connecting to Kongregate");
         if(mKongregate.services == null)
         {
            Logger.info("Kongregate services is null!");
         }
         else
         {
            mKongregate.services.connect();
         }
         removeRootDisplayObject(tKongregateLoader);
         tKongregateLoader = null;
         mKongregate.stats.submit("initialized",1);
      }
      
      public function get kongregateAPI() : *
      {
         return mKongregate;
      }
      
      private function localeAvailable() : void
      {
         Logger.debug("locale available");
      }
      
      private function requestNewValidationToken(param1:GameClock) : void
      {
         var requestFunc:Function;
         var gameClock:GameClock = param1;
         Logger.info("DBFacade: requesting new validation token");
         requestFunc = JSONRPCService.getFunction("token",this.rpcRoot + "account");
         requestFunc(this.dbAccountInfo.id,this.validationToken,function(param1:String):void
         {
            Logger.info("DBFacade: success - new validation token: " + param1);
            mValidationToken = param1;
         },function(param1:Error):void
         {
            Logger.info("DBFacade: requesting new validation token: ERROR:" + param1.toString());
            if(mainStateMachine.currentStateName != "RunState")
            {
               enterSocketErrorState();
            }
            else
            {
               mEventComponent.addListener("CLIENT_EXIT_COMPLETE",enterSocketErrorState);
            }
            removeTokenRegenTask();
         });
      }
      
      private function enterSocketErrorState(param1:Event = null) : void
      {
         mDistributedObjectManager.enterSocketErrorState(100,Locale.getString("FACEBOOK_LOGOUT"));
         mEventComponent.removeListener("CLIENT_EXIT_COMPLETE");
      }
      
      public function createTokenRegenTask() : void
      {
         removeTokenRegenTask();
         mTokenRegenTask = mRealClockWorkManager.doEverySeconds(3600,this.requestNewValidationToken,true);
      }
      
      public function removeTokenRegenTask() : void
      {
         if(mTokenRegenTask)
         {
            mTokenRegenTask.destroy();
            mTokenRegenTask = null;
         }
      }
      
      override public function init(param1:Stage) : void
      {
         super.init(param1);
         this.setupExternalInterfaces();
         this.stageRef.showDefaultContextMenu = false;
         this.stageRef.addEventListener("keyDown",toggleFullscreen);
         createLetterbox();
         mInitialLoadingClip = new LoadingClass();
         mLoadingBar = new UIProgressBar(this,mInitialLoadingClip.loadingBar.loadingBar);
         this.loadingBarTick();
         addRootDisplayObject(mInitialLoadingClip);
         mEventComponent.addListener("enterFrame",this.stagetwo_init);
      }
      
      private function toggleFullscreen(param1:KeyboardEvent) : void
      {
         if(param1.keyCode == 122)
         {
            stageRef.displayState = this.stageRef.displayState == "normal" ? "fullScreenInteractive" : "normal";
         }
         if(param1.keyCode == 27)
         {
            param1.preventDefault();
         }
      }
      
      private function createLetterbox() : void
      {
         var _loc2_:Shape = new Shape();
         _loc2_.graphics.beginFill(1968136);
         var _loc1_:Number = 10000;
         _loc2_.graphics.drawRect(-_loc1_,-_loc1_,_loc1_ + viewWidth + _loc1_,_loc1_);
         _loc2_.graphics.drawRect(-_loc1_,viewHeight,_loc1_ + viewWidth + _loc1_,_loc1_);
         _loc2_.graphics.drawRect(-_loc1_,0,_loc1_,_loc1_);
         _loc2_.graphics.drawRect(viewWidth,0,_loc1_,_loc1_);
         _loc2_.graphics.endFill();
         addRootDisplayObject(_loc2_,1000);
      }
      
      public function stagetwo_init(param1:Event) : void
      {
         stagetwo_init_call_count++;
         if(stagetwo_init_call_count >= 2)
         {
            this.loadingBarTick();
            mEventComponent.removeListener("enterFrame");
            mAssetLoader = new AssetLoadingComponent(this);
            mEventComponent.addListener("LoadingFinishedEvent",architectureLoaded);
            mEventComponent.addListener("ConfigFileLoadedEvent",configLoaded);
            mMainStateMachine = new MainStateMachine(this);
            mMainStateMachine.enterLoadingState();
         }
      }
      
      private function setupExternalInterfaces() : void
      {
         if(ExternalInterface.available)
         {
            ExternalInterface.addCallback("orderComplete",function(param1:String, param2:uint):void
            {
               StoreServices.orderCompleteCallback(this as DBFacade,param1,param2);
            });
            ExternalInterface.addCallback("earnCurrencyCallback",function(param1:Object):void
            {
               if(param1 && param1.vc_amount > 0)
               {
                  mDBAccountInfo.getUsersFullAccountInfo();
               }
               mMetricsLogger.log("FacebookEarnCallback");
            });
            Logger.debug("ExternalInterface setup complete");
         }
         else
         {
            trace("ExternalInterface not available");
         }
      }
      
      protected function configLoaded(param1:ConfigFileLoadedEvent) : void
      {
         this.loadingBarTick();
         mDBConfigManager = param1.dbConfigManager;
         initMetricsLogger();
         Logger.setDebugMessages(dbConfigManager.getConfigBoolean("want_debug_logging",true));
         Logger.setInfoMessages(dbConfigManager.getConfigBoolean("want_info_logging",true));
         mEventComponent.removeListener("ConfigFileLoadedEvent");
         Logger.CustomLoggerString = dbConfigManager.getConfigString("customLoggerString",null);
         mWebAPIRoot = dbConfigManager.getConfigString("API_root","");
         if(mWebAPIRoot == "")
         {
            Logger.fatal("Webservice API root is empty.  Unable to continue.");
         }
         mRPCRoot = dbConfigManager.getConfigString("RPC_root","");
         if(mRPCRoot == "")
         {
            Logger.fatal("RPC root is empty.  Unable to continue.");
         }
         mSteamAPIRoot = dbConfigManager.getConfigString("STEAM_API_root","");
         if(mSteamAPIRoot == "")
         {
            Logger.fatal("Steam API root is empty.  Unable to continue.");
         }
         mUseSteamLogin = dbConfigManager.getConfigBoolean("UseSteamLogin",true);
         if(this.getUserAgent() == "Internet Explorer" && !mDBConfigManager.getConfigBoolean("turn_off_ie_input_hack",false))
         {
            this.setupFocusHack();
         }
         mDownloadRoot = dbConfigManager.getConfigString("download_root","./");
         cacheVersion = mDBConfigManager.getConfigString("CacheVersion","development");
         buildEngines();
      }
      
      private function initMetricsLogger() : void
      {
         mMetricsLogger = new MetricsLogger(this,dbConfigManager.getConfigString("metrics_logging_url",""));
         Logger.errorCallback = loggerErrorCall;
      }
      
      public function preLoadJson() : void
      {
         this.loadingBarTick();
         var _loc3_:String = dbConfigManager.getConfigString("gameMasterPath","Resources/Levels/DB_GameMaster.json");
         var _loc4_:String = buildFullDownloadPath(_loc3_);
         var _loc1_:String = buildFullDownloadPath("Resources/Levels/library_server.json");
         var _loc2_:String = buildFullDownloadPath("Resources/Combat/AttackTimeline.json");
         mAssetLoader.getJsonAsset(_loc4_,gameMasterFinishedLoading,errorLoadingGameMaster);
         mAssetLoader.getJsonAsset(_loc1_,libraryFinishedLoading,errorLoadingLibrary);
         mAssetLoader.getJsonAsset(_loc2_,timelineFinishedLoading,errorLoadingAttackTimeline);
      }
      
      private function errorLoadingGameMaster() : void
      {
         Logger.fatal("Error loading Game Master json.");
      }
      
      private function errorLoadingLibrary() : void
      {
         Logger.fatal("Error loading Server Library json.");
      }
      
      private function errorLoadingAttackTimeline() : void
      {
         Logger.fatal("Error loading Attack Timeline json.");
      }
      
      public function AddTileLibraryJson(param1:String, param2:JsonAsset) : void
      {
         mTileLibraryMap.add(param1,param2.json);
      }
      
      public function getTileLibraryJson(param1:String) : Object
      {
         return mTileLibraryMap.itemFor(param1);
      }
      
      public function get facebookAccountInfo() : FacebookAccountInfo
      {
         return mFacebookAccountInfo;
      }
      
      public function get libraryJson() : Array
      {
         return mLibraryJson;
      }
      
      protected function libraryFinishedLoading(param1:JsonAsset) : void
      {
         Logger.info("libraryFinishedLoading");
         this.loadingBarTick();
         mLibraryJsonLoaded = true;
         var _loc5_:int = 0;
         var _loc4_:int = 0;
         mLibraryJson = param1.json as Array;
         for each(var _loc3_ in param1.json)
         {
            _loc4_ = 0;
            for each(var _loc2_ in _loc3_.navCollisions)
            {
               _loc4_ += GetSecurityValue(_loc2_);
            }
            _loc5_ += _loc4_ % 541;
         }
         mSecuritySL = _loc5_ % 1097;
         checkIfFactoryReadyToLoad();
      }
      
      public function GetSecurityValue(param1:Object) : int
      {
         var _loc2_:int = 0;
         for each(var _loc3_ in param1)
         {
            if(getQualifiedClassName(_loc3_) == "int")
            {
               _loc2_ += Math.abs(int(_loc3_)) % 17 + Math.abs(int(_loc3_)) / 19;
            }
         }
         return _loc2_;
      }
      
      public function get timelineFactory() : TimelineFactory
      {
         return mTimelineFactory;
      }
      
      protected function timelineFinishedLoading(param1:JsonAsset) : void
      {
         Logger.info("timelineFinishedLoading");
         this.loadingBarTick();
         mTimelineFinishedLoading = true;
         mTimelineFactory = new TimelineFactory(this,param1);
         mSecurityTL = mTimelineFactory.securityChecksum;
         checkIfFactoryReadyToLoad();
      }
      
      protected function gameMasterFinishedLoading(param1:JsonAsset) : void
      {
         this.loadingBarTick();
         mGameMasterJson = param1.json;
         gameMaster = new GameMaster(mGameMasterJson,this.splitTests);
         mSecurityGM = gameMaster.securityChecksum;
         mGameMasterJsonLoaded = true;
         var _loc3_:Boolean = false;
         for each(var _loc2_ in mGameMasterJson.Hero)
         {
            if(_loc2_.BaseMove > 250)
            {
               _loc3_ = true;
            }
         }
         if(_loc3_)
         {
            mGameMasterJsonLoaded = false;
            blockCheater();
         }
         checkIfFactoryReadyToLoad();
      }
      
      public function blockCheater() : void
      {
         mLoadingBar.displayErrorMessage("*** Loading Error: A cheat or hack has been detected on your account.\nYou must remove this in order to load and play the game.\nPlease visit http://DungeonRampage.Desk.Com for questions or assistance with this issue. ***");
      }
      
      public function regenerateGameMaster() : void
      {
         if(mGameMasterJsonLoaded)
         {
            gameMaster = new GameMaster(mGameMasterJson,this.splitTests);
         }
      }
      
      protected function checkIfFactoryReadyToLoad() : void
      {
         if(mTimelineFinishedLoading && this.mGameMasterJsonLoaded && this.mLibraryJsonLoaded)
         {
            mEventComponent.dispatchEvent(new ManagersLoadedEvent());
         }
      }
      
      public function get sCode() : int
      {
         return mSecurityGM + mSecurityTL + mSecuritySL;
      }
      
      public function loadingBarTick() : void
      {
         var _loc2_:TextField = null;
         var _loc1_:String = null;
         if(mLoadingBar)
         {
            mLoadingBar.value += 0.06666666666666667;
            mLoadingBarIntStatus++;
            if(mLoadingBar.root.parent as MovieClip && (mLoadingBar.root.parent as MovieClip).loading_text)
            {
               _loc2_ = (mLoadingBar.root.parent as MovieClip).loading_text as TextField;
               _loc1_ = "LOADING " + String.fromCharCode(64 + mLoadingBarIntStatus) + "...";
               Logger.info("loadingBarTick at: " + _loc1_);
               _loc2_.text = _loc1_;
            }
         }
      }
      
      public function powerUpDistributedObjectManager() : void
      {
         var _loc1_:String = null;
         var _loc2_:* = 0;
         Logger.info("*****************Starting powerUpDistributedObjectManager");
         this.loadingBarTick();
         if(mDistributedObjectManager == null)
         {
            _loc1_ = dbConfigManager.getConfigString("GameSocketAddress","");
            if(_loc1_ == "")
            {
               Logger.fatal("GameSocketAddress is empty.  Unable to continue.");
               return;
            }
            _loc2_ = dbConfigManager.getConfigNumber("GameSocketPort",0);
            if(_loc2_ == 0)
            {
               Logger.fatal("GameSocketPort is empty.  Unable to continue.");
               return;
            }
            Security.loadPolicyFile("xmlsocket://" + _loc1_.toString() + ":843");
            mDistributedObjectManager = new DistributedObjectManager(this);
            mDistributedObjectManager.Initialize(_loc1_,_loc2_,validationToken,demographicsJson,accountId,dbConfigManager.networkId,NODE_RULES);
         }
      }
      
      public function warningPopup(param1:String, param2:String) : void
      {
         var _loc3_:DBUIOneButtonPopup = new DBUIOneButtonPopup(this,param1,param2,Locale.getString("OK"),null);
      }
      
      public function errorPopup(param1:String, param2:String) : void
      {
         var _loc3_:DBUIOneButtonPopup = new DBUIOneButtonPopup(this,param1,param2,Locale.getString("OK"),null);
      }
      
      private function getUserAgent() : String
      {
         var _loc2_:String = null;
         var _loc1_:String = null;
         try
         {
            _loc2_ = ExternalInterface.call("window.navigator.userAgent.toString");
            _loc1_ = "[Unknown Browser]";
            if(_loc2_.indexOf("Safari") != -1)
            {
               _loc1_ = "Safari";
            }
            else if(_loc2_.indexOf("Firefox") != -1)
            {
               _loc1_ = "Firefox";
            }
            else if(_loc2_.indexOf("Chrome") != -1)
            {
               _loc1_ = "Chrome";
            }
            else if(_loc2_.indexOf("MSIE") != -1)
            {
               _loc1_ = "Internet Explorer";
            }
            else if(_loc2_.indexOf("Opera") != -1)
            {
               _loc1_ = "Opera";
            }
         }
         catch(e:Error)
         {
            return "[No ExternalInterface]";
         }
         return _loc1_;
      }
      
      private function logSystemMetrics() : void
      {
         var _loc1_:Object = {};
         _loc1_.language = Capabilities.language;
         _loc1_.os = Capabilities.os;
         _loc1_.screenResX = Capabilities.screenResolutionX;
         _loc1_.screenResY = Capabilities.screenResolutionY;
         _loc1_.flashVersion = Capabilities.version;
         _loc1_.browser = this.getUserAgent();
         mMetricsLogger.log("FlashCapabilities",_loc1_);
      }
      
      public function enteringSocketError() : void
      {
         if(mInitialLoadingClip != null)
         {
            removeRootDisplayObject(mInitialLoadingClip);
            mInitialLoadingClip = null;
         }
      }
      
      protected function architectureLoaded(param1:LoadingFinishedEvent) : void
      {
         this.loadingBarTick();
         mDBAccountInfo = param1.dbAccountInfo;
         mDBAccountInfo.checkFriendsHash();
         PixelTracker.returnDAU(this);
         mEventComponent.removeListener("LoadingFinishedEvent");
         mGameClock.initTime();
         this.run();
         mMainStateMachine.start();
         if(mInitialLoadingClip != null)
         {
            removeRootDisplayObject(mInitialLoadingClip);
            mInitialLoadingClip = null;
            mLoadingBar.destroy();
            mLoadingBar = null;
         }
         mMetricsLogger.log("ArchitectureLoaded",{});
      }
      
      public function get dbConfigManager() : DBConfigManager
      {
         return mDBConfigManager;
      }
      
      public function get dbAccountInfo() : DBAccountInfo
      {
         return mDBAccountInfo;
      }
      
      public function set dbAccountInfo(param1:DBAccountInfo) : void
      {
         mDBAccountInfo = param1;
      }
      
      public function get gameMasterJson() : Object
      {
         return mGameMasterJson;
      }
      
      public function get hud() : UIHud
      {
         return mHud;
      }
      
      public function get effectPool() : EffectPool
      {
         if(!mEffectPool)
         {
            mEffectPool = new EffectPool();
         }
         return mEffectPool;
      }
      
      public function get movieClipPool() : MovieClipPool
      {
         if(!mMovieClipPool)
         {
            mMovieClipPool = new MovieClipPool();
         }
         return mMovieClipPool;
      }
      
      public function get mainStateMachine() : MainStateMachine
      {
         return mMainStateMachine;
      }
      
      public function get facebookController() : DBFacebookAPIController
      {
         return mDBFaceBookAPIController;
      }
      
      public function get isFacebookPlayer() : Boolean
      {
         return dbConfigManager.networkId == 1;
      }
      
      public function get isKongregatePlayer() : Boolean
      {
         return dbConfigManager.networkId == 2;
      }
      
      public function get isDRPlayer() : Boolean
      {
         return dbConfigManager.networkId == 3;
      }
      
      public function get accountBonus() : AccountBonus
      {
         return mAccountBonus;
      }
      
      public function get metrics() : MetricsLogger
      {
         return mMetricsLogger;
      }
      
      public function get webServiceAPIRoot() : String
      {
         return mWebAPIRoot;
      }
      
      public function get rpcRoot() : String
      {
         return mRPCRoot;
      }
      
      public function get steamAPIRoot() : String
      {
         return mSteamAPIRoot;
      }
      
      public function get downloadRoot() : String
      {
         return mDownloadRoot;
      }
      
      public function set accountId(param1:uint) : *
      {
         mAccountId = param1;
      }
      
      public function get accountId() : uint
      {
         return mAccountId;
      }
      
      public function get facebookId() : String
      {
         return mFacebookId;
      }
      
      public function get kongregatePlayerId() : String
      {
         return mKongregatePlayerId;
      }
      
      public function get facebookPlayerId() : String
      {
         return mFacebookPlayerId;
      }
      
      public function get facebookThirdPartyId() : String
      {
         return mFacebookThirdPartyId;
      }
      
      public function set facebookThirdPartyId(param1:String) : void
      {
         mFacebookThirdPartyId = param1;
      }
      
      public function get facebookApplication() : String
      {
         return mFacebookApplication;
      }
      
      public function set validationToken(param1:String) : void
      {
         mValidationToken = param1;
      }
      
      public function get validationToken() : String
      {
         return mValidationToken;
      }
      
      public function get demographics() : Object
      {
         return mDemographics;
      }
      
      public function get demographicsJson() : String
      {
         return com.maccherone.json.JSON.encode(mDemographics);
      }
      
      private function _textFocus(param1:FocusEvent) : void
      {
         if(mStageRef.focus)
         {
            if(!(mStageRef.focus is TextField && TextField(mStageRef.focus).type == "input"))
            {
               this.regainFocus();
            }
         }
         else
         {
            this.regainFocus();
         }
      }
      
      private function setupFocusHack() : void
      {
         mHiddenFocusText = new TextField();
         mHiddenFocusText.name = "DBFacade.hiddenFocusText";
         mHiddenFocusText.type = "input";
         mHiddenFocusText.width = 1;
         mHiddenFocusText.height = 1;
         mHiddenFocusText.alpha = 0;
         mHiddenFocusText.mouseEnabled = false;
         mHiddenFocusText.tabEnabled = false;
         addRootDisplayObject(mHiddenFocusText);
         mHiddenFocusText.addEventListener("focusOut",_textFocus);
         this.regainFocus();
      }
      
      public function regainFocus() : void
      {
         mStageRef.focus = mHiddenFocusText ? mHiddenFocusText : mStageRef;
      }
      
      public function loggerErrorCall(param1:String) : void
      {
         var _loc2_:Object = null;
         if(this.metrics && logicalWorkManager != null)
         {
            _loc2_ = {};
            _loc2_.details = param1;
            if(mDelayErrors == null)
            {
               mDelayErrors = [];
            }
            mDelayErrors.push(_loc2_);
            if(mLogicalWorkComponent == null)
            {
               mLogicalWorkComponent = new LogicalWorkComponent(this);
            }
            if(mErrorTask == null)
            {
               mErrorTask = mLogicalWorkComponent.doLater(2,sendErrors);
            }
         }
      }
      
      private function sendErrors(param1:*) : void
      {
         var _loc2_:Array = null;
         mErrorTask = null;
         if(mDelayErrors != null)
         {
            _loc2_ = mDelayErrors;
            mDelayErrors = null;
            param1 = 0;
            while(param1 < _loc2_.length)
            {
               this.metrics.log("CLIENT_ERROR_EVENT",_loc2_[param1]);
               param1++;
            }
         }
      }
      
      public function get splitTests() : Object
      {
         return this.dbConfigManager.GetValueOrDefault("SplitTests",{});
      }
      
      public function getSplitTestNumber(param1:String, param2:Number) : Number
      {
         for each(var _loc3_ in this.splitTests)
         {
            if(_loc3_.name == param1)
            {
               return Number(_loc3_.value);
            }
         }
         Logger.debug("splitTestValueFor test not found: " + param1);
         return param2;
      }
      
      public function getSplitTestBoolean(param1:String, param2:Boolean) : Boolean
      {
         for each(var _loc3_ in this.splitTests)
         {
            if(_loc3_.name == param1)
            {
               Logger.debug("splitTestValueFor " + param1 + ": " + _loc3_.value);
               return _loc3_.value == "true";
            }
         }
         Logger.debug("splitTestValueFor test not found: " + param1);
         return param2;
      }
      
      public function getSplitTestString(param1:String, param2:String) : String
      {
         for each(var _loc3_ in this.splitTests)
         {
            if(_loc3_.name == param1)
            {
               return _loc3_.value;
            }
         }
         Logger.debug("splitTestValueFor test not found: " + param1);
         return param2;
      }
      
      public function receiveDailyRewards() : void
      {
      }
      
      public function getInfiniteDungeonDetailForNodeId(param1:uint) : InfiniteMapNodeDetail
      {
         return mDistributedObjectManager.mMatchMaker.getInfiniteDungeonDetailForNodeId(param1);
      }
      
      public function get adManager() : AdManager
      {
         return mAdManager;
      }
      
      public function set adManager(param1:AdManager) : void
      {
         mAdManager = param1;
      }
      
      public function openSteamPage() : void
      {
         var _loc2_:URLRequest = null;
         var _loc1_:Boolean = Boolean(mSteamworks.isOverlayEnabled());
         var _loc3_:* = stageRef.displayState == "fullScreenInteractive";
         if(_loc1_ && _loc3_)
         {
            Logger.debug("Using activateGameOverlayToStore to open steam page");
            mSteamworks.activateGameOverlayToStore(3053950,0);
         }
         else
         {
            Logger.debug("Using navigateToURL to open steam page because isOverlayEnabled:" + _loc1_ + " isFullscreen:" + _loc3_);
            _loc2_ = new URLRequest("steam://store/3053950");
            navigateToURL(_loc2_,"_blank");
         }
      }
   }
}

