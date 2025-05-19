package StateMachine.MainStateMachine
{
   import Brain.Logger.Logger;
   import Brain.StateMachine.StateMachine;
   import DBGlobals.DBGlobal;
   import Facade.DBFacade;
   import UI.Leaderboard.UILeaderboard;
   
   public class MainStateMachine extends StateMachine
   {
      
      protected var mLoadingState:LoadingState;
      
      protected var mReloadTownState:ReloadTownState;
      
      protected var mLoadingScreenState:LoadingScreenState;
      
      protected var mTownState:TownState;
      
      protected var mRunState:RunState;
      
      protected var mSocketErrorState:SocketErrorState;
      
      protected var mDBFacade:DBFacade;
      
      private var mLastHeroId:uint;
      
      private var mLastHeroLevel:uint;
      
      private var mShowedInvitePopup:Boolean = false;
      
      private var mShowedHeroUpsellPopup:Boolean = false;
      
      private var mShowedRewardPopup:Boolean = false;
      
      public function MainStateMachine(param1:DBFacade)
      {
         super();
         mDBFacade = param1;
         mLoadingState = new LoadingState(param1);
         mReloadTownState = new ReloadTownState(param1,enterTownState);
         mLoadingScreenState = new LoadingScreenState(param1,enterRunState);
         mTownState = new TownState(param1);
         mRunState = new RunState(param1,enterReloadTownState);
         mSocketErrorState = new SocketErrorState(param1);
      }
      
      public function enterLoadingState() : void
      {
         this.transitionToState(mLoadingState);
      }
      
      public function enterLoadingScreenState(param1:uint = 0, param2:String = "", param3:uint = 0, param4:uint = 0, param5:Boolean = false, param6:Boolean = false) : void
      {
         if(param1 != 0)
         {
            mLoadingScreenState.mapNodeID = param1;
         }
         else if(param3 != 0)
         {
            mLoadingScreenState.friendID = param3;
         }
         else if(param4 != 0)
         {
            mLoadingScreenState.mapID = param4;
         }
         mLoadingScreenState.friendsOnly = param6;
         mLoadingScreenState.nodeType = param2;
         mLoadingScreenState.jumpToMapState = param5;
         this.transitionToState(mLoadingScreenState);
      }
      
      public function start() : void
      {
         if(!mDBFacade.dbAccountInfo.activeAvatarInfo)
         {
            Logger.error("Account has invalid active avatar: accountId: " + mDBFacade.dbAccountInfo.id.toString() + " activeAvatar: " + mDBFacade.dbAccountInfo.activeAvatarId.toString());
            return;
         }
         var _loc1_:* = mDBFacade.dbAccountInfo.inventoryInfo.getEquipedItemsOnAvatar(mDBFacade.dbAccountInfo.activeAvatarInfo.id).length > 0;
         if(_loc1_ && !mDBFacade.dbAccountInfo.dbAccountParams.hasMovementTutorialParam())
         {
            this.enterLoadingScreenState(DBGlobal.TUTORIAL_MAP_NODE_ID,"",0,0,true);
         }
         else
         {
            this.enterTownState();
         }
      }
      
      public function enterTownInventoryState(param1:uint = 0, param2:uint = 0, param3:Boolean = false) : void
      {
         if(this.currentStateName == mTownState.name)
         {
            mTownState.townStateMachine.enterInventoryState(false,"",param1,param2,param3);
         }
         else
         {
            Logger.error("Trying to enter inventory state while not in the town state.");
         }
      }
      
      public function enterTownState(param1:Boolean = false) : void
      {
         if(param1)
         {
            mTownState.jumpToMapState = param1;
         }
         this.transitionToState(mTownState);
      }
      
      public function enterReloadTownState(param1:Boolean = false) : void
      {
         if(mTownState && param1)
         {
            mTownState.jumpToMapState = param1;
         }
         this.transitionToState(mReloadTownState);
      }
      
      public function enterRunState() : void
      {
         mDBFacade.mainStateMachine.markHasHeroLeveledUp();
         this.transitionToState(mRunState);
      }
      
      public function get leaderboard() : UILeaderboard
      {
         return mTownState.leaderboard;
      }
      
      public function enterSocketErrorState(param1:uint, param2:String = "") : void
      {
         this.transitionToState(mSocketErrorState);
         mSocketErrorState.enterReason(param1,param2);
      }
      
      public function markHasHeroLeveledUp() : Boolean
      {
         var _loc1_:Boolean = false;
         if(mLastHeroId && mLastHeroId == mDBFacade.dbAccountInfo.activeAvatarInfo.avatarType && mLastHeroLevel && mLastHeroLevel < mDBFacade.dbAccountInfo.activeAvatarInfo.level)
         {
            _loc1_ = true;
         }
         mLastHeroId = mDBFacade.dbAccountInfo.activeAvatarInfo.avatarType;
         mLastHeroLevel = mDBFacade.dbAccountInfo.activeAvatarInfo.level;
         return _loc1_;
      }
      
      public function set showedHeroUpsellPopup(param1:Boolean) : void
      {
         mShowedHeroUpsellPopup = param1;
      }
      
      public function get showedHeroUpsellPopup() : Boolean
      {
         return mShowedHeroUpsellPopup;
      }
      
      public function set showedInvitePopup(param1:Boolean) : void
      {
         mShowedInvitePopup = param1;
      }
      
      public function get showedInvitePopup() : Boolean
      {
         return mShowedInvitePopup;
      }
      
      public function set showedRewardPopup(param1:Boolean) : void
      {
         mShowedRewardPopup = param1;
      }
      
      public function get showedRewardPopup() : Boolean
      {
         return mShowedRewardPopup;
      }
   }
}

