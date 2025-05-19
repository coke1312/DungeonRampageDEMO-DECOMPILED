package UI.FriendManager
{
   import Brain.AssetRepository.AssetLoadingComponent;
   import Brain.AssetRepository.SwfAsset;
   import Brain.Clock.GameClock;
   import Brain.Logger.Logger;
   import Brain.Render.MovieClipRenderController;
   import Brain.SceneGraph.SceneGraphComponent;
   import Brain.UI.UIButton;
   import Brain.UI.UIRadioButton;
   import Brain.WorkLoop.LogicalWorkComponent;
   import DBGlobals.DBGlobal;
   import Facade.DBFacade;
   import Facade.Locale;
   import Town.TownHeader;
   import Town.TownStateMachine;
   import UI.FriendManager.States.UIBlocked;
   import UI.FriendManager.States.UIFriends;
   import UI.FriendManager.States.UIInvite;
   import UI.FriendManager.States.UIPending;
   import UI.UINewsFeed.UINewsFeedController;
   import flash.display.MovieClip;
   import flash.filters.ColorMatrixFilter;
   import org.as3commons.collections.Map;
   import org.as3commons.collections.framework.IMapIterator;
   
   public class UIFriendManager
   {
      
      public static const STATE_FRIENDS:uint = 1;
      
      public static const STATE_PENDING:uint = 2;
      
      public static const STATE_BLOCKED:uint = 3;
      
      public static const STATE_INVITE:uint = 4;
      
      public static var FRIENDSHIP_MADE:String = "FRIENDSHIP_MADE";
      
      private var mDBFacade:DBFacade;
      
      private var mSceneGraphComponent:SceneGraphComponent;
      
      private var mAssetLoadingComponent:AssetLoadingComponent;
      
      private var mLogicalWorkComponent:LogicalWorkComponent;
      
      private var mRoot:MovieClip;
      
      private var mTownHeader:TownHeader;
      
      private var mSwfAsset:SwfAsset;
      
      public var states:Map;
      
      public var currentState:int = -1;
      
      private var mTabButtons:Map;
      
      private var mStateLayer:MovieClip;
      
      private var mAlert:MovieClip;
      
      private var mAlertRenderer:MovieClipRenderController;
      
      protected var mNewsFeedController:UINewsFeedController;
      
      public function UIFriendManager(param1:DBFacade, param2:TownStateMachine, param3:MovieClip)
      {
         super();
         mDBFacade = param1;
         mSwfAsset = param2.townSwf;
         mTownHeader = param2.townHeader;
         mSceneGraphComponent = new SceneGraphComponent(mDBFacade);
         mAssetLoadingComponent = new AssetLoadingComponent(mDBFacade);
         mLogicalWorkComponent = new LogicalWorkComponent(mDBFacade);
         states = new Map();
         states.add(1,new UIFriends(this,mDBFacade,param2));
         states.add(4,new UIInvite(this,mDBFacade,param2));
         states.add(2,new UIPending(this,mDBFacade,param2));
         states.add(3,new UIBlocked(this,mDBFacade,param2));
         if(!mNewsFeedController)
         {
            mNewsFeedController = new UINewsFeedController(mDBFacade);
         }
         mNewsFeedController.startFeedTask();
         setupUI(param3);
      }
      
      private function setupUI(param1:MovieClip) : void
      {
         var tabButton:UIRadioButton;
         var tabInt:uint;
         var iter:IMapIterator;
         var rootClip:MovieClip = param1;
         mRoot = rootClip;
         mTabButtons = new Map();
         var group:String = "UIFriendsTabGroup";
         mTabButtons.add(1,new UIRadioButton(mDBFacade,mRoot.tab_friends,group));
         mTabButtons.add(4,new UIRadioButton(mDBFacade,mRoot.tab_invite,group));
         mTabButtons.add(2,new UIRadioButton(mDBFacade,mRoot.tab_pending,group));
         mTabButtons.add(3,new UIRadioButton(mDBFacade,mRoot.tab_blocked,group));
         iter = mTabButtons.iterator() as IMapIterator;
         while(iter.hasNext())
         {
            tabButton = iter.next();
            tabInt = iter.key;
            tabButton.label.text = Locale.getString("FRIEND_MANAGEMENT_TAB_" + tabInt.toString());
            tabButton.root.category = tabInt;
            tabButton.root.new_label.visible = false;
            tabButton.releaseCallbackThis = function(param1:UIButton):void
            {
               changeTab(param1 as UIRadioButton);
            };
            tabButton.rolloverFilter = DBGlobal.UI_ROLLOVER_FILTER;
            tabButton.selectedFilter = DBGlobal.UI_SELECTED_FILTER;
         }
         mStateLayer = new MovieClip();
         mRoot.addChild(mStateLayer);
         mAlert = mRoot.tab_pending.alert_icon;
         mAlertRenderer = new MovieClipRenderController(mDBFacade,mAlert);
         mAlertRenderer.play(0,true);
         mAlert.visible = false;
      }
      
      public function enableTabButton(param1:uint) : void
      {
         var _loc2_:UIRadioButton = mTabButtons.itemFor(param1);
         _loc2_.root.filters = [new ColorMatrixFilter()];
         if(param1 == 2)
         {
         }
      }
      
      public function disableTabButton(param1:uint) : void
      {
         var _loc2_:UIRadioButton = mTabButtons.itemFor(param1);
         var _loc3_:Number = 0.212671;
         var _loc5_:Number = 0.71516;
         var _loc4_:Number = 0.072169;
         var _loc6_:Array = [];
         _loc6_ = _loc6_.concat([_loc3_,_loc5_,_loc4_,0,0]);
         _loc6_ = _loc6_.concat([_loc3_,_loc5_,_loc4_,0,0]);
         _loc6_ = _loc6_.concat([_loc3_,_loc5_,_loc4_,0,0]);
         _loc6_ = _loc6_.concat([0,0,0,1,0]);
         _loc2_.root.filters = [new ColorMatrixFilter(_loc6_)];
      }
      
      public function init(param1:uint) : void
      {
         mTabButtons.itemFor(param1).selected = true;
         changeState(param1);
      }
      
      public function animateEntry() : void
      {
         mTownHeader.rootMovieClip.visible = false;
         mLogicalWorkComponent.doLater(0.20833333333333334,function(param1:GameClock):void
         {
            mTownHeader.animateHeader();
         });
      }
      
      public function changeTab(param1:UIRadioButton) : void
      {
         var radioButton:UIRadioButton = param1;
         var wrappedCallBack:Function = function():void
         {
            changeState(radioButton.root.category);
         };
         wrappedCallBack();
      }
      
      public function changeState(param1:uint) : void
      {
         if(currentState == param1)
         {
            return;
         }
         if(currentState > -1)
         {
            states.itemFor(currentState).exit();
         }
         currentState = param1;
         states.itemFor(currentState).enter();
      }
      
      public function updateHeading(param1:String) : void
      {
         mRoot.avatar_heading_text.text = param1;
      }
      
      public function updateDescription(param1:String, param2:Boolean = false) : void
      {
         mRoot.avatar_description_text.text = param1;
         mRoot.avatar_description_text.selectable = param2;
      }
      
      public function cleanUp() : void
      {
         if(currentState > -1)
         {
            states.itemFor(currentState).exit();
            currentState = -1;
         }
      }
      
      public function set alert(param1:Boolean) : void
      {
         mAlert.visible = param1;
      }
      
      public function get root() : MovieClip
      {
         return mRoot;
      }
      
      public function addToUI(param1:MovieClip) : void
      {
         mStateLayer.addChild(param1);
      }
      
      public function removeFromUI(param1:MovieClip) : void
      {
         mStateLayer.removeChild(param1);
      }
      
      public function clearUI() : void
      {
         while(mStateLayer.numChildren > 0)
         {
            mStateLayer.removeChild(mStateLayer.getChildAt(mStateLayer.numChildren - 1));
         }
      }
      
      public function setPendingList(param1:Array) : void
      {
         Logger.debug("setPending");
         if(states.itemFor(2) != null)
         {
            states.itemFor(2).pendingFriendRequests = param1;
         }
      }
      
      public function destroy() : void
      {
         var _loc2_:UIRadioButton = null;
         var _loc1_:IMapIterator = mTabButtons.iterator() as IMapIterator;
         while(_loc1_.hasNext())
         {
            _loc2_ = _loc1_.next();
            _loc2_.destroy();
         }
         mTabButtons.clear();
         mTabButtons = null;
         if(mAlertRenderer != null)
         {
            mAlertRenderer.destroy();
            mAlertRenderer = null;
         }
         cleanUp();
         states = null;
         mDBFacade = null;
         mSwfAsset = null;
         mTownHeader = null;
         mNewsFeedController.stopFeedTask();
         mSceneGraphComponent.destroy();
         mAssetLoadingComponent.destroy();
         mLogicalWorkComponent.destroy();
      }
   }
}

