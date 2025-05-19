package Town
{
   import Brain.AssetRepository.SwfAsset;
   import Brain.StateMachine.StateMachine;
   import Facade.DBFacade;
   import UI.Leaderboard.UILeaderboard;
   import flash.display.MovieClip;
   
   public class TownStateMachine extends StateMachine
   {
      
      private static const TOWN_HOME_CLASS_NAME:String = "UI_town_home";
      
      public static const INVENTORY_CLASS_NAME:String = "DR_UI_town_inventory";
      
      private static const TAVERN_CLASS_NAME:String = "UI_town_tavern";
      
      public static const SHOP_CLASS_NAME:String = "DR_UI_town_shop";
      
      private static const FRIEND_MANAGEMENT_CLASS_NAME:String = "UI_friend_management";
      
      private static const SKILLS_CLASS_NAME:String = "UI_town_skills";
      
      private static const TRAIN_CLASS_NAME:String = "UI_town_train";
      
      private static const MAP_2_1_NAME:String = "Map_2_1";
      
      private var mTownSwfAsset:SwfAsset;
      
      private var mMapSwfAsset:SwfAsset;
      
      private var mHomeState:HomeState;
      
      private var mInventoryState:InventoryTownSubState;
      
      private var mTavernState:TavernTownSubState;
      
      private var mTrainState:TrainTownSubState;
      
      private var mSkillsState:SkillsTownSubState;
      
      private var mShopState:ShopTownSubState;
      
      private var mFriendManagementState:SocialSubState;
      
      private var mMapState:MapTownSubState;
      
      private var mTownHeader:TownHeader;
      
      protected var mUILeaderboard:UILeaderboard;
      
      protected var mDBFacade:DBFacade;
      
      public function TownStateMachine(param1:DBFacade)
      {
         super();
         mDBFacade = param1;
         buildStates();
         mTownHeader = new TownHeader(mDBFacade,this.enterHomeState,this.enterMapState);
      }
      
      override public function destroy() : void
      {
         super.destroy();
         mHomeState.destroy();
         mInventoryState.destroy();
         mTavernState.destroy();
         mShopState.destroy();
         mFriendManagementState.destroy();
         mSkillsState.destroy();
         mTrainState.destroy();
         mMapState.destroy();
         mTownHeader.destroy();
         mUILeaderboard.destroy();
         mHomeState = null;
         mInventoryState = null;
         mTavernState = null;
         mShopState = null;
         mFriendManagementState = null;
         mSkillsState = null;
         mTrainState = null;
         mMapState = null;
         mTownSwfAsset = null;
         mDBFacade = null;
      }
      
      public function setSwfs(param1:SwfAsset, param2:SwfAsset) : void
      {
         mTownSwfAsset = param1;
         mMapSwfAsset = param2;
         setMovieClipsOnStates();
      }
      
      public function get townSwf() : SwfAsset
      {
         return mTownSwfAsset;
      }
      
      public function get townHeader() : TownHeader
      {
         return mTownHeader;
      }
      
      private function setMovieClipsOnStates() : void
      {
         var _loc2_:Class = null;
         var _loc6_:Class = mTownSwfAsset.getClass("UI_town_home");
         mHomeState.rootMovieClip = new _loc6_() as MovieClip;
         var _loc3_:Class = mTownSwfAsset.getClass("UI_town_tavern");
         mTavernState.rootMovieClip = new _loc3_() as MovieClip;
         var _loc1_:Class = mTownSwfAsset.getClass("DR_UI_town_inventory");
         mInventoryState.rootMovieClip = new _loc1_() as MovieClip;
         var _loc8_:Class = mTownSwfAsset.getClass("DR_UI_town_shop");
         mShopState.rootMovieClip = new _loc8_() as MovieClip;
         var _loc7_:Class = mTownSwfAsset.getClass("UI_friend_management");
         mFriendManagementState.rootMovieClip = new _loc7_() as MovieClip;
         var _loc4_:Class = mTownSwfAsset.getClass("UI_town_skills");
         mSkillsState.rootMovieClip = new _loc4_() as MovieClip;
         var _loc5_:Class = mTownSwfAsset.getClass("UI_town_train");
         mTrainState.rootMovieClip = new _loc5_() as MovieClip;
         _loc2_ = mMapSwfAsset.getClass("Map_2_1");
         mMapState.rootMovieClip = new _loc2_() as MovieClip;
         mUILeaderboard = new UILeaderboard(mDBFacade,mTownSwfAsset,callbackToFriendManager,getGifts,this);
      }
      
      private function buildStates() : void
      {
         mHomeState = new HomeState(mDBFacade,this);
         mInventoryState = new InventoryTownSubState(mDBFacade,this);
         mTavernState = new TavernTownSubState(mDBFacade,this);
         mShopState = new ShopTownSubState(mDBFacade,this);
         mFriendManagementState = new SocialSubState(mDBFacade,this);
         mSkillsState = new SkillsTownSubState(mDBFacade,this);
         mTrainState = new TrainTownSubState(mDBFacade,this);
         mMapState = new MapTownSubState(mDBFacade,this);
      }
      
      public function enterHomeState() : void
      {
         mTownHeader.show();
         mTownHeader.showCloseButton(false);
         this.transitionToState(mHomeState);
      }
      
      public function enterInventoryState(param1:Boolean = false, param2:String = "", param3:uint = 0, param4:uint = 0, param5:Boolean = false) : void
      {
         mInventoryState.startAtCategoryTab = param2;
         mTownHeader.jumpToMapState = param1;
         mInventoryState.setRevlealedState(param3,param4,param5);
         this.transitionToState(mInventoryState);
      }
      
      public function enterTavernState(param1:Boolean = false) : void
      {
         mTownHeader.jumpToMapState = param1;
         this.transitionToState(mTavernState);
      }
      
      public function enterTrainState() : void
      {
         this.transitionToState(mTrainState);
      }
      
      public function enterShopState(param1:Boolean = false, param2:String = "") : void
      {
         mShopState.startAtCategoryTab = param2;
         mTownHeader.jumpToMapState = param1;
         this.transitionToState(mShopState);
      }
      
      public function enterFriendManagementState() : void
      {
         this.transitionToState(mFriendManagementState);
      }
      
      public function setFriendManagementTabCategory(param1:uint) : void
      {
         mFriendManagementState.setTabCategory(param1);
      }
      
      public function enterSkillsState() : void
      {
         this.transitionToState(mSkillsState);
      }
      
      public function enterMapState() : void
      {
         this.transitionToState(mMapState);
      }
      
      public function getGifts() : void
      {
         mHomeState.getGifts();
      }
      
      public function get leaderboard() : UILeaderboard
      {
         return mUILeaderboard;
      }
      
      public function getTownAsset(param1:String) : Class
      {
         return mTownSwfAsset.getClass(param1);
      }
      
      public function callbackToFriendManager() : void
      {
         setFriendManagementTabCategory(1);
         enterFriendManagementState();
      }
      
      public function exit() : void
      {
         mTownHeader.hide();
         this.currentState.exitState();
         this.currentState = null;
      }
   }
}

