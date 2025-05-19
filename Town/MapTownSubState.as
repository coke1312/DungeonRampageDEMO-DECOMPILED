package Town
{
   import Account.FriendInfo;
   import Brain.AssetRepository.AssetLoadingComponent;
   import Brain.Clock.GameClock;
   import Brain.Event.EventComponent;
   import Brain.Render.MovieClipRenderController;
   import Brain.WorkLoop.LogicalWorkComponent;
   import Facade.DBFacade;
   import Facade.Locale;
   import UI.Leaderboard.UILeaderboard;
   import UI.Map.UIMapWorldMap;
   import flash.display.MovieClip;
   import flash.events.Event;
   
   public class MapTownSubState extends TownSubState
   {
      
      public static const SCREENS_PATH:String = "Resources/Art2D/UI/db_UI_screens.swf";
      
      public static const NAME:String = "MapTownSubState";
      
      private var mScreensMovieClip:MovieClip;
      
      private var mWorkComponent:LogicalWorkComponent;
      
      private var mEventComponent:EventComponent;
      
      private var mAssetLoadingComponent:AssetLoadingComponent;
      
      private var mClipRenderController:MovieClipRenderController;
      
      private var mWorldMap:UIMapWorldMap;
      
      private var mUILeaderboard:UILeaderboard;
      
      public function MapTownSubState(param1:DBFacade, param2:TownStateMachine)
      {
         super(param1,param2,"MapTownSubState");
         mAssetLoadingComponent = new AssetLoadingComponent(param1);
      }
      
      override protected function setupState() : void
      {
         super.setupState();
         mWorkComponent = new LogicalWorkComponent(mDBFacade);
         mEventComponent = new EventComponent(mDBFacade);
         mWorldMap = new UIMapWorldMap(mDBFacade,mRootMovieClip,mTownStateMachine.townSwf,mTownStateMachine);
         var _loc8_:Class = mTownStateMachine.townSwf.getClass("cursor_pointer");
         var _loc6_:MovieClip = new _loc8_() as MovieClip;
         mDBFacade.mouseCursorManager.registerMouseCursor(_loc6_,"auto",true);
         var _loc2_:Class = mTownStateMachine.townSwf.getClass("cursor_open");
         var _loc3_:MovieClip = new _loc2_() as MovieClip;
         mDBFacade.mouseCursorManager.registerMouseCursor(_loc3_,"HAND");
         var _loc1_:Class = mTownStateMachine.townSwf.getClass("cursor_fist");
         var _loc4_:MovieClip = new _loc1_() as MovieClip;
         mDBFacade.mouseCursorManager.registerMouseCursor(_loc4_,"DRAG");
         var _loc5_:Class = mTownStateMachine.townSwf.getClass("cursor_point");
         var _loc7_:MovieClip = new _loc5_() as MovieClip;
         mDBFacade.mouseCursorManager.registerMouseCursor(_loc7_,"POINT");
      }
      
      public function animateEntry() : void
      {
         if(mTownStateMachine.townHeader.rootMovieClip != null)
         {
            mTownStateMachine.townHeader.rootMovieClip.visible = false;
            mWorkComponent.doLater(0.20833333333333334,function(param1:GameClock):void
            {
               if(mTownStateMachine)
               {
                  mTownStateMachine.townHeader.animateHeader();
               }
            });
         }
      }
      
      private function initMap() : void
      {
         var tavernCallback:Function = function():void
         {
            mTownStateMachine.enterTavernState(true);
         };
         var inventoryCallback:Function = function():void
         {
            mTownStateMachine.enterInventoryState(true,"POWERUP");
         };
         var shopCallback:Function = function():void
         {
            mTownStateMachine.enterShopState(true,"STUFF");
         };
         mWorldMap.initialize(tavernCallback,inventoryCallback,shopCallback,mTownStateMachine.enterHomeState);
         mDBFacade.mouseCursorManager.pushMouseCursor("HAND");
         mUILeaderboard = mDBFacade.mainStateMachine.leaderboard;
         mUILeaderboard.setRootMovieClip(mRootMovieClip);
         mUILeaderboard.currentStateName = "MapTownSubState";
         mUILeaderboard.hidePopup();
         animateEntry();
         mTownStateMachine.townHeader.showCloseButton(true);
         mTownStateMachine.townHeader.title = Locale.getString("WORLD_MAP_HEADER");
      }
      
      override public function enterState() : void
      {
         super.enterState();
         mEventComponent.addListener(FriendInfo.FRIEND_SCORES_PARSED,function(param1:Event):void
         {
            mWorldMap.deinit();
            initMap();
         });
         if(!mWorkComponent)
         {
            mWorkComponent = new LogicalWorkComponent(mDBFacade);
         }
         initMap();
      }
      
      override public function exitState() : void
      {
         super.exitState();
         mWorldMap.deinit();
         if(mWorkComponent)
         {
            mWorkComponent.destroy();
            mWorkComponent = null;
         }
         if(mClipRenderController)
         {
            mClipRenderController.destroy();
            mClipRenderController = null;
         }
         mEventComponent.removeAllListeners();
      }
   }
}

