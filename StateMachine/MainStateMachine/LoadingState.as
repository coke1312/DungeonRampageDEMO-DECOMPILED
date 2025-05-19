package StateMachine.MainStateMachine
{
   import Account.DBAccountInfo;
   import Account.SteamAccountInfo;
   import Account.StoreServicesController;
   import Brain.AssetRepository.AssetLoader;
   import Brain.AssetRepository.AssetLoadingComponent;
   import Brain.Clock.GameClock;
   import Brain.Event.EventComponent;
   import Brain.Logger.Logger;
   import Brain.StateMachine.State;
   import Config.ConfigFileLoadedEvent;
   import Config.DBConfigManager;
   import Events.DBAccountLoadedEvent;
   import Events.ManagersLoadedEvent;
   import Events.MatchMakerLoadedEvent;
   import Facade.DBFacade;
   import Facade.TrickleCacheLoader;
   
   public class LoadingState extends State
   {
      
      public static const NAME:String = "LoadingState";
      
      protected var mDBFacade:DBFacade;
      
      protected var mEventComponent:EventComponent;
      
      protected var mAssetLoader:AssetLoadingComponent;
      
      protected var mConfigLoaded:Boolean = false;
      
      protected var mTimeLoaded:Boolean = false;
      
      protected var mManagersLoaded:Boolean = false;
      
      protected var mAccountLoaded:Boolean = false;
      
      protected var mTransitionsLoaded:Boolean = false;
      
      protected var mMatchMakerLoaded:Boolean = false;
      
      protected var mSteamInfoLoaded:Boolean = false;
      
      private var mStarteddbAccountInfoLoad:Boolean = false;
      
      protected var mDBAccountInfo:DBAccountInfo;
      
      private var mLoadingStartTime:uint;
      
      public function LoadingState(param1:DBFacade, param2:Function = null)
      {
         super("LoadingState",param2);
         mDBFacade = param1;
      }
      
      override public function enterState() : void
      {
         super.enterState();
         Logger.debug("MAIN STATE MACHINE TRANSITION -- ENTERING LOADING STATE");
         mLoadingStartTime = mDBFacade.gameClock.realTime;
         mEventComponent = new EventComponent(mDBFacade);
         mAssetLoader = new AssetLoadingComponent(mDBFacade);
         AssetLoader.startTrackingLoads(finishedLoadingCache);
         mEventComponent.addListener("ConfigFileLoadedEvent",configLoaded);
         mEventComponent.addListener("ManagersLoadedEvent",managersLoaded);
         mEventComponent.addListener("DB_ACCOUNT_INFO_LOADED",accountLoaded);
         mEventComponent.addListener("MATCH_MAKER_LOADED",matchMakerReady);
         var _loc1_:DBConfigManager = new DBConfigManager(mDBFacade);
         _loc1_.init();
         AssetLoader.stopTrackingLoads();
      }
      
      private function finishedLoadingCache() : void
      {
         Logger.info("finishedLoadingCache");
         mTransitionsLoaded = true;
         checkIfLoadingFinished();
      }
      
      override public function exitState() : void
      {
         mAssetLoader.destroy();
         mAssetLoader = null;
         mEventComponent.destroy();
         mEventComponent = null;
         super.exitState();
         var _loc1_:Number = (mDBFacade.gameClock.realTime - mLoadingStartTime) / 1000;
         mDBFacade.metrics.log("GameLoaded",{"timeSpentSeconds":_loc1_});
         Logger.debug("MAIN STATE MACHINE TRANSITION -- EXIT LOADING STATE");
      }
      
      protected function configLoaded(param1:ConfigFileLoadedEvent) : void
      {
         Logger.info("LoadingState configLoaded");
         mDBFacade.loadingBarTick();
         mConfigLoaded = true;
         SteamAccountInfo.getOrCreateAccount(mDBFacade,steamInfoLoaded);
         TownState.preLoadAssets(mDBFacade);
         TrickleCacheLoader.swfAsset(DBFacade.buildFullDownloadPath("Resources/Art2D/UI/db_UI_loading_screen.swf"),mDBFacade);
         TrickleCacheLoader.swfAsset(DBFacade.buildFullDownloadPath("Resources/Art2D/FX/db_fx_library.swf"),mDBFacade);
         TrickleCacheLoader.swfAsset(DBFacade.buildFullDownloadPath("Resources/Audio/soundEffects.swf"),mDBFacade);
         TrickleCacheLoader.swfAsset(DBFacade.buildFullDownloadPath("Resources/Art2D/UI/db_UI_daily_reward.swf"),mDBFacade);
         TrickleCacheLoader.swfAsset(DBFacade.buildFullDownloadPath("Resources/Art2D/Icons/Items/db_icons_items.swf"),mDBFacade);
         TrickleCacheLoader.swfAsset(DBFacade.buildFullDownloadPath("Resources/Art2D/UI/db_UI_chest_reveal.swf"),mDBFacade);
         mDBFacade.preLoadJson();
         GameClock.startSetWebServerTime();
         StoreServicesController.getWebServerTimestamp(mDBFacade,timeLoaded);
      }
      
      protected function steamInfoLoaded() : void
      {
         Logger.info("mSteamInfoLoaded");
         mDBFacade.loadingBarTick();
         mSteamInfoLoaded = true;
         checkToLoadDBAccountInfo();
         checkIfLoadingFinished();
      }
      
      protected function timeLoaded() : void
      {
         mTimeLoaded = true;
         checkToLoadDBAccountInfo();
         checkIfLoadingFinished();
      }
      
      private function matchMakerReady(param1:MatchMakerLoadedEvent) : void
      {
         Logger.info("matchMakerReady");
         mDBFacade.loadingBarTick();
         mMatchMakerLoaded = true;
         checkIfLoadingFinished();
      }
      
      private function checkToLoadDBAccountInfo() : void
      {
         var _loc1_:DBAccountInfo = null;
         if(mConfigLoaded && mManagersLoaded && !mStarteddbAccountInfoLoad && mSteamInfoLoaded)
         {
            _loc1_ = new DBAccountInfo(mDBFacade);
            _loc1_.getUsersFullAccountInfo();
            mStarteddbAccountInfoLoad = true;
         }
      }
      
      protected function managersLoaded(param1:ManagersLoadedEvent) : void
      {
         Logger.info("managersLoaded");
         mDBFacade.loadingBarTick();
         mManagersLoaded = true;
         checkToLoadDBAccountInfo();
         checkIfLoadingFinished();
      }
      
      protected function accountLoaded(param1:DBAccountLoadedEvent) : void
      {
         Logger.info("accountLoaded");
         mDBFacade.loadingBarTick();
         mAccountLoaded = true;
         mDBAccountInfo = param1.dbAccountInfo;
         checkIfLoadingFinished();
      }
      
      protected function checkIfLoadingFinished() : void
      {
         Logger.info("--->checkIfLoadingFinished  mConfigLoaded:" + mConfigLoaded.toString() + " mManagersLoaded:" + mManagersLoaded.toString() + " mTransitionsLoaded:" + mTransitionsLoaded.toString() + " mMatchMakerLoaded:" + mMatchMakerLoaded.toString() + " mAccountLoaded:" + mAccountLoaded.toString() + " mTimeLoaded:" + mTimeLoaded.toString() + " mSteamInfoLoaded:" + mSteamInfoLoaded.toString());
         if(mConfigLoaded && mManagersLoaded && mAccountLoaded && mTransitionsLoaded && mMatchMakerLoaded && mTimeLoaded)
         {
            mEventComponent.dispatchEvent(new LoadingFinishedEvent(mDBAccountInfo));
         }
         else if(mConfigLoaded && mManagersLoaded && mAccountLoaded && mTransitionsLoaded)
         {
            mDBFacade.powerUpDistributedObjectManager();
         }
      }
   }
}

