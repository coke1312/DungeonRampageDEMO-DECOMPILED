package UI.Map
{
   import Account.MapnodeInfo;
   import Actor.FloatingMessage;
   import Actor.Revealer;
   import Brain.AssetRepository.AssetLoadingComponent;
   import Brain.AssetRepository.SwfAsset;
   import Brain.Clock.GameClock;
   import Brain.Event.EventComponent;
   import Brain.Logger.Logger;
   import Brain.Render.MovieClipRenderController;
   import Brain.SceneGraph.SceneGraphComponent;
   import Brain.UI.UIButton;
   import Brain.UI.UIObject;
   import Brain.UI.UIProgressBar;
   import Brain.Utils.ColorMatrix;
   import Brain.WorkLoop.LogicalWorkComponent;
   import Brain.WorkLoop.Task;
   import Brain.jsonRPC.JSONRPCService;
   import DBGlobals.DBGlobal;
   import DistributedObjects.MatchMaker;
   import Facade.DBFacade;
   import Facade.Locale;
   import GameMasterDictionary.GMHero;
   import GameMasterDictionary.GMMapNode;
   import Town.TownStateMachine;
   import UI.DBUIOneButtonPopup;
   import UI.InfiniteIsland.II_UIMapBattlePopup;
   import flash.display.DisplayObject;
   import flash.display.MovieClip;
   import flash.events.Event;
   import flash.events.KeyboardEvent;
   import flash.events.MouseEvent;
   import flash.events.TimerEvent;
   import flash.geom.Point;
   import flash.geom.Rectangle;
   import flash.utils.Timer;
   import flash.utils.getDefinitionByName;
   import org.as3commons.collections.Map;
   import org.as3commons.collections.Set;
   
   public class UIMapWorldMap
   {
      
      private static const MAX_BOING_MAG:Number = 1.45;
      
      private static const BOING_DECAY:Number = 0.5;
      
      private static const BOING_RATE:Number = 2;
      
      private static const SQUASH_BALANCE:Number = 0.75;
      
      private static const SQUASH_RATE:Number = 0.25;
      
      private static const AVATAR_LERP_SPEED:Number = 12;
      
      private static const AVATAR_ARC_HEIGHT:Number = 30;
      
      private static const CUTSCENE_PATH:String = "Resources/Art2D/UI/animatic0104.swf";
      
      private static const CAMERA_LERP_SPEED:Number = 0.2916666666666667;
      
      private static const CAMERA_CENTER_TIMEOUT:Number = 144;
      
      private static const CAMERA_SPEED_SCALE:Number = 1;
      
      private static const LEADERBOARD_HEIGHT:Number = 90;
      
      private static const DRAG_MESSAGE_TIME:Number = 17;
      
      private static const ROOKIE_LEAGUE:uint = 0;
      
      private static var OPEN_COLOR_MATRIX:ColorMatrix = new ColorMatrix();
      
      private static var CLOSED_COLOR_MATRIX:ColorMatrix = new ColorMatrix();
      
      OPEN_COLOR_MATRIX.adjustBrightness(-20);
      OPEN_COLOR_MATRIX.adjustSaturation(0.75);
      OPEN_COLOR_MATRIX.adjustHue(65);
      CLOSED_COLOR_MATRIX.adjustBrightness(-40);
      CLOSED_COLOR_MATRIX.adjustSaturation(0);
      
      private var mLastKeyboardUpdateFrame:uint = 0;
      
      private var KEYBOARD_FRAME_DELAY_UPDATE:uint = 12;
      
      private var GBS_FORCE_DISABLE_EXTRA_MAPS:Boolean = true;
      
      private var mWorkComponent:LogicalWorkComponent;
      
      private var mEventComponent:EventComponent;
      
      private var mAssetLoadingComponent:AssetLoadingComponent;
      
      private var mSceneGraphComponent:SceneGraphComponent;
      
      private var mDBFacade:DBFacade;
      
      private var mRootMovieClip:MovieClip;
      
      private var mTownSwfAsset:SwfAsset;
      
      private var mMapAvatar:UIMapAvatar;
      
      private var mAvatarList:Array;
      
      private var mAvatarDropShadowList:Array;
      
      private var mSpentKeyMessage:MovieClip;
      
      private var mXPBar:UIProgressBar;
      
      private var mIIBattlePopup:UIMapBattlePopup;
      
      private var mRegularBattlePopup:UIMapBattlePopup;
      
      private var mBattlePopup:UIMapBattlePopup;
      
      private var mWantCinematics:Boolean;
      
      private var mMouseTask:Task;
      
      private var mCameraLerpTask:Task;
      
      private var mFriendFadeTask:Task;
      
      private var mCameraTargetX:Number;
      
      private var mCameraTargetY:Number;
      
      private var mCameraVelocityX:Number;
      
      private var mCameraVelocityY:Number;
      
      private var mOldMouseX:Number;
      
      private var mOldMouseY:Number;
      
      private var mMouseVelocityX:Number;
      
      private var mMouseVelocityY:Number;
      
      private var mCurrentNode:GMMapNode;
      
      private var mNodeQueue:Array;
      
      private var mNodePath:Array;
      
      private var mClosedNodeList:Set;
      
      private var mOpenNodeButtons:Map;
      
      private var mLockedNodeButtons:Map;
      
      private var mMapDragTask:Task;
      
      private var mMapNodeClass:Class;
      
      private var mDragMessageRevealer:Revealer;
      
      private var mDragMessageFloater:FloatingMessage;
      
      private var mChooseDungeonMessage:FloatingMessage;
      
      private var mShowedDragMessage:Boolean;
      
      private var mDidDrag:Boolean;
      
      private var mLeagueNameRevealer:Revealer;
      
      private var mDidKeySpentMessage:Boolean;
      
      private var mUnlockSuccessful:Boolean;
      
      private var mUnlockResponseReceived:Boolean;
      
      private var mRevealer:Revealer;
      
      private var mReturnToMapNode:GMMapNode;
      
      private var mMapWidth:Number;
      
      private var mMapHeight:Number;
      
      private var mReturnToTownButton:UIButton;
      
      private var mReturnToTownCallback:Function;
      
      private var mCurrentLeague:uint = 0;
      
      private var mLeftLeagueButton:UIButton;
      
      private var mRightLeagueButton:UIButton;
      
      protected var mTownStateMachine:TownStateMachine;
      
      private var mEpochCountdownTimer:Timer;
      
      public function UIMapWorldMap(param1:DBFacade, param2:MovieClip, param3:SwfAsset, param4:TownStateMachine)
      {
         super();
         mDBFacade = param1;
         mTownStateMachine = param4;
         mAssetLoadingComponent = new AssetLoadingComponent(param1);
         mSceneGraphComponent = new SceneGraphComponent(mDBFacade);
         mEventComponent = new EventComponent(mDBFacade);
         mWantCinematics = mDBFacade.dbConfigManager.getConfigBoolean("want_story",true);
         mRootMovieClip = param2;
         mTownSwfAsset = param3;
      }
      
      public function initialize(param1:Function, param2:Function, param3:Function, param4:Function) : void
      {
         var tavernCallback:Function = param1;
         var inventoryCallback:Function = param2;
         var shopCallback:Function = param3;
         var townCallback:Function = param4;
         mWorkComponent = new LogicalWorkComponent(mDBFacade);
         var finalLeagueBounds:Rectangle = mRootMovieClip.worldmap.infinite_island_league.getRect(mRootMovieClip.worldmap.infinite_island_league);
         var globalBottomRight:Point = mRootMovieClip.worldmap.infinite_island_league.localToGlobal(finalLeagueBounds.bottomRight);
         mMapWidth = globalBottomRight.x - mRootMovieClip.worldmap.x + 64;
         mMapHeight = mRootMovieClip.worldmap.height;
         mCurrentNode = null;
         mReturnToTownCallback = townCallback;
         var setReturnNode:Function = function(param1:Function):Function
         {
            var callback:Function = param1;
            return function():void
            {
               callback();
               mReturnToMapNode = mCurrentNode;
            };
         };
         mIIBattlePopup = new II_UIMapBattlePopup(mDBFacade,setReturnNode(tavernCallback),setReturnNode(inventoryCallback),setReturnNode(shopCallback),this.battleButtonCallback,"MapBattlePopup");
         mIIBattlePopup.animatePopupOut();
         mRegularBattlePopup = new UIMapBattlePopup(mDBFacade,setReturnNode(tavernCallback),setReturnNode(inventoryCallback),setReturnNode(shopCallback),this.battleButtonCallback,"MapBattlePopup");
         mRegularBattlePopup.animatePopupOut();
         mBattlePopup = mRegularBattlePopup;
         mEventComponent.addListener(MatchMaker.EPOCH_ROLL_OVER_EVENT_NAME,epochRollOverHandler);
         mUnlockResponseReceived = false;
         mUnlockSuccessful = false;
         mDidKeySpentMessage = false;
         mCameraVelocityX = 0;
         mCameraVelocityY = 0;
         mCurrentLeague = 0;
         mMapNodeClass = Object(mRootMovieClip.worldmap.rookie_league.getChildByName("TUTORIAL")).constructor;
         mXPBar = new UIProgressBar(mDBFacade,mRootMovieClip.ui_league.UI_XP.xp_bar);
         mXPBar.dontKillMyChildren = true;
         setXP(mDBFacade.dbAccountInfo.activeAvatarInfo.experience,mDBFacade.dbAccountInfo.activeAvatarInfo.gmHero);
         mRootMovieClip.ui_league.league_01.label.text = Locale.getString("MAP_PAGE_ROOKIE_LEAGUE_LABEL");
         mLeftLeagueButton = new UIButton(mDBFacade,mRootMovieClip.ui_league.shift_left);
         mLeftLeagueButton.releaseCallback = function():void
         {
            var _loc1_:uint = mCurrentLeague;
            mCurrentLeague = mCurrentLeague > 0 ? mCurrentLeague - 1 : 0;
            if(_loc1_ != mCurrentLeague)
            {
               updateCurrentLeague();
            }
         };
         mRightLeagueButton = new UIButton(mDBFacade,mRootMovieClip.ui_league.shift_right);
         mRightLeagueButton.releaseCallback = function():void
         {
            var _loc1_:uint = mCurrentLeague;
            if(_loc1_ != mCurrentLeague)
            {
               updateCurrentLeague();
            }
         };
         mRootMovieClip.worldmap.addEventListener("mouseDown",onMouseDown);
         mDBFacade.dbAccountInfo.activeAvatarInfo.loadHeroIcon(function(param1:MovieClip):void
         {
            UIObject.scaleToFit(param1,40);
            mRootMovieClip.ui_league.ui_avatar.addChild(param1);
         });
         clearMouseEnabledOnWorldmap();
         hideAllMapNodes();
         setupMapNodeButtons();
         if(!mChooseDungeonMessage)
         {
            mWorkComponent.doLater(1,showChooseDungeonMessage);
         }
         if(mReturnToMapNode)
         {
            moveAvatarToNode(mReturnToMapNode)();
            mReturnToMapNode = null;
         }
         mCameraTargetY = -116;
         mRootMovieClip.worldmap.x = mCameraTargetX;
         mRootMovieClip.worldmap.y = mCameraTargetY;
         updateCurrentLeague();
         clampMap();
      }
      
      private function epochRollOverHandler(param1:Event) : void
      {
         if(mBattlePopup == mIIBattlePopup)
         {
            mBattlePopup.animatePopupOut();
            setCurrentNode(mCurrentNode);
            mBattlePopup.animatePopupIn();
         }
      }
      
      private function keyboardCheck(param1:GameClock) : void
      {
         var _loc2_:* = 0;
         if(mDBFacade.inputManager.check(37) && mLastKeyboardUpdateFrame < param1.frame - KEYBOARD_FRAME_DELAY_UPDATE)
         {
            mLastKeyboardUpdateFrame = param1.frame;
            _loc2_ = mCurrentLeague;
            mCurrentLeague = mCurrentLeague > 0 ? mCurrentLeague - 1 : 0;
            if(_loc2_ != mCurrentLeague)
            {
               updateCurrentLeague();
            }
         }
         if(mDBFacade.inputManager.check(39) && mLastKeyboardUpdateFrame < param1.frame - KEYBOARD_FRAME_DELAY_UPDATE)
         {
            mLastKeyboardUpdateFrame = param1.frame;
            _loc2_ = mCurrentLeague;
            if(_loc2_ != mCurrentLeague)
            {
               updateCurrentLeague();
            }
         }
      }
      
      private function popLeagueName(param1:MovieClip) : void
      {
         if(mLeagueNameRevealer)
         {
            mLeagueNameRevealer.destroy();
            mLeagueNameRevealer = null;
         }
         param1.scaleX = 1;
         param1.scaleY = 1;
         param1.alpha = 1;
         mLeagueNameRevealer = new Revealer(param1,mDBFacade,10);
      }
      
      private function updateCurrentLeague(param1:Boolean = true) : void
      {
         var _loc2_:MovieClip = null;
         mRootMovieClip.ui_league.clock.visible = false;
         mRootMovieClip.ui_league.label_new_dungeon.visible = false;
         mRootMovieClip.ui_league.label_timer.visible = false;
         mRootMovieClip.ui_league.ui_avatar.visible = true;
         mRootMovieClip.ui_league.UI_XP.visible = true;
         endEpochCountdown();
         if(GBS_FORCE_DISABLE_EXTRA_MAPS)
         {
            mCurrentLeague = 0;
         }
         mLeftLeagueButton.enabled = false;
         mRightLeagueButton.enabled = false;
         if(GBS_FORCE_DISABLE_EXTRA_MAPS)
         {
            mRightLeagueButton.enabled = false;
         }
         mRootMovieClip.ui_league.league_01.visible = true;
         mRootMovieClip.ui_league.league_02.visible = false;
         mRootMovieClip.ui_league.league_03.visible = false;
         mRootMovieClip.ui_league.league_04.visible = false;
         mRootMovieClip.ui_league.league_05.visible = false;
         centerMapOnClip(mRootMovieClip.worldmap.rookie_league);
         _loc2_ = mRootMovieClip.ui_league.league_01;
         if(param1 && _loc2_)
         {
            popLeagueName(_loc2_);
         }
      }
      
      private function startEpochCountdown() : void
      {
         mEpochCountdownTimer = new Timer(1000);
         mEpochCountdownTimer.addEventListener("timer",tickEpochCountdown);
         tickEpochCountdown(null);
         mEpochCountdownTimer.start();
      }
      
      private function endEpochCountdown() : void
      {
         if(mEpochCountdownTimer != null)
         {
            mEpochCountdownTimer.removeEventListener("timer",tickEpochCountdown);
            mEpochCountdownTimer.stop();
         }
      }
      
      private function tickEpochCountdown(param1:TimerEvent) : void
      {
         var _loc2_:Array = GameClock.getArrayTimeToEpoch();
         var _loc3_:String = "";
         if(_loc2_[4] == 1)
         {
            _loc3_ += _loc2_[4] + " " + Locale.getString("EPOCH_TIMER_WEEK");
         }
         else if(_loc2_[4])
         {
            _loc3_ += _loc2_[4] + " " + Locale.getString("EPOCH_TIMER_WEEKS");
         }
         if(_loc2_[3] == 1)
         {
            _loc3_ += _loc2_[3] + " " + Locale.getString("EPOCH_TIMER_DAY");
         }
         else if(_loc2_[3])
         {
            _loc3_ += _loc2_[3] + " " + Locale.getString("EPOCH_TIMER_DAYS");
         }
         if(_loc2_[4] == 0 && _loc2_[3] == 0)
         {
            _loc3_ = Number(_loc2_[2]) + ":" + zeroPad(_loc2_[1],2) + ":" + zeroPad(_loc2_[0],2);
         }
         mRootMovieClip.ui_league.label_timer.text = _loc3_;
      }
      
      public function zeroPad(param1:int, param2:int) : String
      {
         var _loc3_:String = "" + param1;
         while(_loc3_.length < param2)
         {
            _loc3_ = "0" + _loc3_;
         }
         return _loc3_;
      }
      
      private function setXP(param1:uint, param2:GMHero) : void
      {
         mXPBar.value = param1;
         var _loc5_:uint = param2.getLevelFromExp(param1);
         mRootMovieClip.ui_league.UI_XP.xp_level.text = _loc5_.toString();
         var _loc4_:* = param1;
         var _loc3_:uint = uint(param2.getLevelIndex(param1));
         var _loc7_:uint = uint(_loc3_ > 0 ? param2.getExpFromIndex(_loc3_ - 1) : 0);
         var _loc6_:uint = param2.getExpFromIndex(_loc3_);
         mXPBar.value = (_loc4_ - _loc7_) / (_loc6_ - _loc7_);
      }
      
      public function deinit() : void
      {
         mTownStateMachine = null;
         mDidDrag = false;
         mShowedDragMessage = false;
         endEpochCountdown();
         if(mXPBar)
         {
            mXPBar.destroy();
            mXPBar = null;
         }
         if(mRevealer)
         {
            mRevealer.destroy();
            mRevealer = null;
         }
         if(mLeagueNameRevealer)
         {
            mLeagueNameRevealer.destroy();
            mLeagueNameRevealer = null;
         }
         if(mChooseDungeonMessage)
         {
            mChooseDungeonMessage.destroy();
            mChooseDungeonMessage = null;
         }
         if(mDragMessageRevealer)
         {
            mDragMessageRevealer.destroy();
            mDragMessageRevealer = null;
         }
         if(mDragMessageFloater)
         {
            mDragMessageFloater.destroy();
            mDragMessageFloater = null;
         }
         if(mReturnToTownButton)
         {
            mReturnToTownButton.enabled = false;
            mReturnToTownButton.destroy();
            mReturnToTownButton = null;
         }
         mRootMovieClip.worldmap.removeEventListener("mouseUp",onMouseUp);
         mRootMovieClip.worldmap.removeEventListener("mouseOut",onMouseOut);
         mRootMovieClip.worldmap.removeEventListener("mouseLeave",onMouseOut);
         mRootMovieClip.worldmap.removeEventListener("mouseMove",onDrag);
         mRootMovieClip.worldmap.removeEventListener("mouseOver",onMouseOver);
         mDBFacade.mouseCursorManager.popMouseCursor();
         if(mClosedNodeList)
         {
            mClosedNodeList.clear();
         }
         mNodePath = null;
         mNodeQueue = null;
         if(mIIBattlePopup)
         {
            mIIBattlePopup.destroy();
            mIIBattlePopup = null;
         }
         if(mRegularBattlePopup)
         {
            mRegularBattlePopup.destroy();
            mRegularBattlePopup = null;
         }
         mBattlePopup = null;
         if(mMouseTask)
         {
            mMouseTask.destroy();
            mMouseTask = null;
         }
         if(mCameraLerpTask)
         {
            mCameraLerpTask.destroy();
            mCameraLerpTask = null;
         }
         if(mMapDragTask)
         {
            mMapDragTask.destroy();
            mMapDragTask = null;
         }
         if(mMapAvatar)
         {
            mMapAvatar.destroy(mRootMovieClip.worldmap);
            mMapAvatar = null;
         }
         if(mOpenNodeButtons)
         {
            for each(var _loc1_ in mOpenNodeButtons.toArray())
            {
               _loc1_.enabled = false;
               _loc1_.destroy();
            }
            mOpenNodeButtons.clear();
            mOpenNodeButtons = null;
         }
         if(mMouseTask)
         {
            mMouseTask.destroy();
            mMouseTask = null;
         }
         if(mWorkComponent)
         {
            mWorkComponent.destroy();
            mWorkComponent = null;
         }
         mEventComponent.removeAllListeners();
         if(mDBFacade.dbConfigManager.getConfigBoolean("ALLOW_HACKS_TO_PLAY_MAP_NODE",false))
         {
            tearDownHacksToPlayNode();
         }
      }
      
      private function createPlayerAvatar() : void
      {
         var node:DisplayObject;
         var forceClassCompilation:UIMapAvatarDropMover;
         var mapAvatarClass:Class = mTownSwfAsset.getClass("Branch_map_avatar");
         var avatar:MovieClip = new mapAvatarClass() as MovieClip;
         var avatarDropShadowClass:Class = mTownSwfAsset.getClass("Branch_map_avatar_shadow");
         var avatarDropShadow:MovieClip = new avatarDropShadowClass() as MovieClip;
         mRootMovieClip.worldmap.addChild(avatar);
         mRootMovieClip.worldmap.addChild(avatarDropShadow);
         node = mRootMovieClip.worldmap.rookie_league.getChildByName(mCurrentNode.Constant);
         if(node)
         {
            node.visible = true;
            avatar.join.visible = false;
            avatar.x = node.x;
            avatar.y = node.y - avatar.height / 2;
            avatarDropShadow.x = avatar.x;
            avatarDropShadow.y = avatar.y;
            mDBFacade.dbAccountInfo.activeAvatarInfo.loadHeroIcon(function(param1:MovieClip):void
            {
               avatar.pic.addChild(param1);
            });
            avatarDropShadow.mouseChildren = false;
            avatarDropShadow.mouseEnabled = false;
            avatar.mouseChildren = false;
            avatar.mouseEnabled = false;
            mMapAvatar = new UIMapAvatar(mDBFacade,avatar,avatarDropShadow,Class(getDefinitionByName("UI.Map.UIMapAvatarDropMover")));
         }
      }
      
      private function friendJoinCallback(param1:uint) : Function
      {
         var friendId:uint = param1;
         return function():void
         {
            if(mDBFacade.dbAccountInfo.inventoryInfo.getEquipedItemsOnAvatar(mDBFacade.dbAccountInfo.activeAvatarInfo.id).length == 0)
            {
               mDBFacade.metrics.log("NoWeaponsEquippedWarning");
               mDBFacade.errorPopup("Warning","Cannot enter dungeon with no weapons equipped.");
            }
            else
            {
               mDBFacade.mouseCursorManager.popMouseCursor();
               mDBFacade.mouseCursorManager.disable = true;
               mDBFacade.metrics.log("JoinFriend",{"friendId":friendId});
               mDBFacade.mainStateMachine.enterLoadingScreenState(0,"",friendId,0,true,mBattlePopup.IsPrivate);
            }
         };
      }
      
      private function clearAvatarList() : void
      {
         if(mAvatarList)
         {
            for each(var _loc2_ in mAvatarList)
            {
               mRootMovieClip.worldmap.removeChild(_loc2_);
            }
         }
         if(mAvatarDropShadowList)
         {
            for each(var _loc1_ in mAvatarDropShadowList)
            {
               mRootMovieClip.worldmap.removeChild(_loc1_);
            }
         }
      }
      
      private function sortAvatarList() : void
      {
         var i:uint;
         var avatar_clip:MovieClip;
         var shadow_clip:MovieClip;
         var ysort:Function = function(param1:MovieClip, param2:MovieClip):int
         {
            if(param1.y < param2.y - 15)
            {
               return -1;
            }
            if(param1.y > param2.y + 15)
            {
               return 1;
            }
            return 0;
         };
         mAvatarList.sort(ysort);
         mAvatarDropShadowList.sort(ysort);
         i = 0;
         while(i < mAvatarList.length)
         {
            avatar_clip = mAvatarList[i];
            shadow_clip = mAvatarDropShadowList[i];
            mRootMovieClip.worldmap.addChild(shadow_clip);
            mRootMovieClip.worldmap.addChild(avatar_clip);
            ++i;
         }
      }
      
      private function updateFriends(param1:Event = null) : void
      {
      }
      
      private function cutsceneSwfLoaded(param1:String) : Function
      {
         var className:String = param1;
         return function(param1:SwfAsset):void
         {
            mRootMovieClip.visible = false;
            mBattlePopup.animatePopupOut();
            mSceneGraphComponent.fadeIn(1);
            var _loc2_:MovieClipRenderController = new MovieClipRenderController(mDBFacade,param1.root);
            mSceneGraphComponent.addChild(param1.root,50);
            _loc2_.play(0,false,cutsceneDone(param1.root,_loc2_));
         };
      }
      
      private function cutsceneDone(param1:MovieClip, param2:MovieClipRenderController) : Function
      {
         var clip:MovieClip = param1;
         var movieClipRenderer:MovieClipRenderController = param2;
         return function():void
         {
            mSceneGraphComponent.removeChild(clip);
            mDBFacade.mouseCursorManager.popMouseCursor();
            mDBFacade.mouseCursorManager.disable = true;
            mDBFacade.mainStateMachine.enterLoadingScreenState(mCurrentNode.Id,mCurrentNode.NodeType,0,0,true,mBattlePopup.IsPrivate);
            movieClipRenderer.destroy();
         };
      }
      
      private function killCameraLerp() : void
      {
         if(mCameraLerpTask)
         {
            mCameraLerpTask.destroy();
            mCameraLerpTask = null;
            mCameraVelocityX = 0;
            mCameraVelocityY = 0;
         }
      }
      
      private function centerMapOnClip(param1:MovieClip) : void
      {
         var _loc5_:Rectangle = param1.getRect(param1);
         var _loc2_:Point = param1.localToGlobal(new Point(_loc5_.left + param1.width * 0.5,0));
         var _loc3_:Point = mRootMovieClip.worldmap.localToGlobal(new Point(0,0));
         var _loc4_:Number = _loc2_.x - _loc3_.x;
         mCameraTargetX = mRootMovieClip.stage.stageWidth * 0.5 - _loc4_;
         if(mCameraLerpTask)
         {
            mCameraLerpTask.destroy();
         }
         mCameraVelocityX = 0;
         mCameraVelocityY = 0;
         mCameraLerpTask = mWorkComponent.doEveryFrame(centerCamera);
      }
      
      private function centerCamera(param1:GameClock) : void
      {
         var _loc3_:Number = mCameraTargetX - mRootMovieClip.worldmap.x;
         var _loc4_:Number = mCameraTargetY - mRootMovieClip.worldmap.y;
         var _loc2_:Number = _loc3_ * _loc3_ + _loc4_ * _loc4_;
         mCameraVelocityX = _loc3_ * 0.2916666666666667;
         mRootMovieClip.worldmap.x += mCameraVelocityX;
         clampMap();
         if(_loc2_ < 0.0001)
         {
            mCameraVelocityX = 0;
            mCameraVelocityY = 0;
            killCameraLerp();
         }
      }
      
      private function startSlide() : void
      {
         mRootMovieClip.worldmap.mouseChildren = true;
         if(mMouseTask)
         {
            mMouseTask.destroy();
            mMouseTask = null;
         }
         mMouseTask = mWorkComponent.doEveryFrame(updateSlide);
      }
      
      private function clampMap() : void
      {
         mRootMovieClip.worldmap.x = Math.min(mRootMovieClip.worldmap.x,-13);
         mRootMovieClip.worldmap.x = Math.max(mRootMovieClip.worldmap.x,-mMapWidth + mRootMovieClip.worldmap.stage.stageWidth);
      }
      
      private function updateSlide(param1:GameClock) : void
      {
         var _loc2_:* = 0;
         var _loc3_:Point = null;
         updateDrag(param1);
         var _loc4_:Number = Math.abs(mMouseVelocityX);
         if(mMouseTask)
         {
            mMouseTask.destroy();
            mMouseTask = null;
            _loc2_ = mCurrentLeague;
            if(_loc4_ > 10)
            {
               if(mMouseVelocityX > 0)
               {
                  updateCurrentLeague(_loc2_ != mCurrentLeague);
               }
               else
               {
                  mCurrentLeague = mCurrentLeague > 0 ? mCurrentLeague - 1 : 0;
                  updateCurrentLeague(_loc2_ != mCurrentLeague);
               }
            }
            else
            {
               _loc3_ = mRootMovieClip.worldmap.rookie_league.localToGlobal(new Point(0,0));
               mCurrentLeague = 0;
               updateCurrentLeague(_loc2_ != mCurrentLeague);
            }
         }
      }
      
      private function updateDrag(param1:GameClock) : void
      {
         var _loc2_:Number = mMouseVelocityX * Math.min(0.9,param1.tickLength * 10);
         mRootMovieClip.worldmap.x -= _loc2_;
         mMouseVelocityX -= _loc2_;
         clampMap();
      }
      
      private function onDrag(param1:MouseEvent) : void
      {
         mDidDrag = true;
         killCameraLerp();
         var _loc2_:Number = mOldMouseX - param1.stageX;
         mMouseVelocityX += _loc2_;
         mOldMouseX = param1.stageX;
         mOldMouseY = param1.stageY;
         clampMap();
      }
      
      private function onMouseUp(param1:MouseEvent) : void
      {
         if(mMapDragTask)
         {
            mMapDragTask.destroy();
            mMapDragTask = null;
         }
         mDBFacade.mouseCursorManager.popMouseCursor();
         mRootMovieClip.worldmap.mouseChildren = true;
         mRootMovieClip.worldmap.removeEventListener("mouseUp",onMouseUp);
         mRootMovieClip.worldmap.removeEventListener("mouseOut",onMouseOut);
         mRootMovieClip.worldmap.removeEventListener("mouseLeave",onMouseOut);
         mRootMovieClip.worldmap.removeEventListener("mouseMove",onDrag);
         startSlide();
      }
      
      private function onMouseOut(param1:MouseEvent) : void
      {
         mDBFacade.mouseCursorManager.popMouseCursor();
         mRootMovieClip.worldmap.mouseChildren = true;
         mRootMovieClip.worldmap.removeEventListener("mouseUp",onMouseUp);
         mRootMovieClip.worldmap.removeEventListener("mouseOut",onMouseOut);
         mRootMovieClip.worldmap.removeEventListener("mouseLeave",onMouseOut);
         mRootMovieClip.worldmap.removeEventListener("mouseMove",onDrag);
         mRootMovieClip.worldmap.addEventListener("mouseOver",onMouseOver);
         startSlide();
      }
      
      private function onMouseOver(param1:MouseEvent) : void
      {
         mRootMovieClip.worldmap.removeEventListener("mouseOver",onMouseOver);
         if(param1.buttonDown)
         {
            onMouseDown(param1);
         }
      }
      
      private function onMouseDown(param1:MouseEvent) : void
      {
         mDBFacade.mouseCursorManager.pushMouseCursor("DRAG");
         if(mMouseTask)
         {
            mMouseTask.destroy();
            mMouseTask = null;
         }
         mOldMouseX = param1.stageX;
         mOldMouseY = param1.stageY;
         mMouseVelocityX = 0;
         mMouseVelocityY = 0;
         if(!mMapDragTask)
         {
            mMapDragTask = mWorkComponent.doEveryFrame(updateDrag);
         }
         mRootMovieClip.worldmap.mouseChildren = false;
         if(!GBS_FORCE_DISABLE_EXTRA_MAPS)
         {
            mRootMovieClip.worldmap.addEventListener("mouseMove",onDrag);
         }
         mRootMovieClip.worldmap.addEventListener("mouseUp",onMouseUp);
         mRootMovieClip.worldmap.addEventListener("mouseOut",onMouseOut);
         mRootMovieClip.worldmap.addEventListener("mouseLeave",onMouseOut);
      }
      
      private function isMapNode(param1:Object) : Boolean
      {
         return param1.constructor == mMapNodeClass;
      }
      
      private function clearMouseEnabledOnWorldmap() : void
      {
         var _loc1_:* = 0;
         var _loc2_:MovieClip = null;
         _loc1_ = 0;
         while(_loc1_ < mRootMovieClip.worldmap.numChildren)
         {
            _loc2_ = mRootMovieClip.worldmap.getChildAt(_loc1_) as MovieClip;
            if(_loc2_ && _loc2_ != mRootMovieClip.worldmap.TOWNBUTTON && _loc2_ != mRootMovieClip.worldmap.rookie_league && _loc2_ != mRootMovieClip.worldmap.gladiator_league && _loc2_ != mRootMovieClip.worldmap.grinder_league && _loc2_ != mRootMovieClip.worldmap.heroic_league && _loc2_ != mRootMovieClip.worldmap.infinite_island_league)
            {
               _loc2_.mouseChildren = false;
               _loc2_.mouseEnabled = false;
            }
            _loc1_++;
         }
      }
      
      private function hideAllMapNodes() : void
      {
      }
      
      private function revealCallback(param1:MovieClip) : Function
      {
         var childClip:MovieClip = param1;
         return function(param1:GameClock):void
         {
            var _loc2_:Revealer = null;
            if(childClip)
            {
               childClip.visible = true;
               _loc2_ = new Revealer(childClip,mDBFacade,24);
            }
         };
      }
      
      private function getMapnodeFromCurrentNode1() : MapnodeInfo
      {
         return mDBFacade.dbAccountInfo.inventoryInfo.mapnodes1.itemFor(mCurrentNode.Id);
      }
      
      private function mapNodesOpen(param1:Array, param2:Boolean = false) : Boolean
      {
         var _loc4_:* = 0;
         var _loc3_:GMMapNode = null;
         if(!param1 || !mDBFacade.dbAccountInfo || !mDBFacade.dbAccountInfo.inventoryInfo)
         {
            return false;
         }
         _loc4_ = 0;
         while(_loc4_ < param1.length)
         {
            _loc3_ = param1[_loc4_];
            if(mapNodeOpen(_loc3_,param2))
            {
               return true;
            }
            _loc4_++;
         }
         return false;
      }
      
      private function mapNodeOpen(param1:GMMapNode, param2:Boolean = false) : Boolean
      {
         if(!param1 || !mDBFacade.dbAccountInfo || !mDBFacade.dbAccountInfo.inventoryInfo)
         {
            return false;
         }
         var _loc3_:MapnodeInfo = mDBFacade.dbAccountInfo.inventoryInfo.mapnodes1.itemFor(param1.Id);
         return _loc3_ && (!param2 || _loc3_.MapnodeState == 1 || _loc3_.MapnodeState == 3);
      }
      
      private function mapNodeOpenNotDefeated(param1:GMMapNode) : Boolean
      {
         if(!param1 || !mDBFacade.dbAccountInfo || !mDBFacade.dbAccountInfo.inventoryInfo)
         {
            return false;
         }
         var _loc2_:MapnodeInfo = mDBFacade.dbAccountInfo.inventoryInfo.mapnodes1.itemFor(param1.Id);
         return _loc2_ && _loc2_.MapnodeState == 3;
      }
      
      private function mapNodeLocked(param1:GMMapNode) : Boolean
      {
         if(!param1 || !mDBFacade.dbAccountInfo || !mDBFacade.dbAccountInfo.inventoryInfo)
         {
            return false;
         }
         var _loc2_:MapnodeInfo = mDBFacade.dbAccountInfo.inventoryInfo.mapnodes1.itemFor(param1.Id);
         return _loc2_ == null;
      }
      
      private function getUnlockedNodes() : Array
      {
         return mDBFacade.dbAccountInfo.inventoryInfo.mapnodes1.toArray();
      }
      
      private function hasLockedNextNode(param1:GMMapNode) : Boolean
      {
         for each(var _loc2_ in param1.ChildNodes)
         {
            if(_loc2_)
            {
               if(mapNodeLocked(_loc2_))
               {
                  return true;
               }
            }
         }
         return false;
      }
      
      private function hasUnlockedChild(param1:GMMapNode) : Boolean
      {
         var _loc2_:GMMapNode = null;
         for each(var _loc3_ in param1.RevealNodes)
         {
            if(_loc3_)
            {
               _loc2_ = mDBFacade.gameMaster.mapNodeByConstant.itemFor(_loc3_);
               if(_loc2_ && mapNodeOpen(_loc2_,true))
               {
                  return true;
               }
            }
         }
         return false;
      }
      
      private function isChildNode(param1:GMMapNode, param2:String) : Boolean
      {
         for each(var _loc3_ in param1.ChildNodes)
         {
            if(_loc3_ && _loc3_.Constant == param2)
            {
               return true;
            }
         }
         return false;
      }
      
      private function getClipFromConstant(param1:String) : MovieClip
      {
         var _loc2_:MovieClip = mRootMovieClip.worldmap.rookie_league.getChildByName(param1) as MovieClip;
         if(!_loc2_)
         {
            _loc2_ = mRootMovieClip.worldmap.gladiator_league.getChildByName(param1) as MovieClip;
            if(!_loc2_)
            {
               _loc2_ = mRootMovieClip.worldmap.heroic_league.getChildByName(param1) as MovieClip;
               if(!_loc2_)
               {
                  _loc2_ = mRootMovieClip.worldmap.grinder_league.getChildByName(param1) as MovieClip;
                  if(!_loc2_)
                  {
                     _loc2_ = mRootMovieClip.worldmap.infinite_island_league.getChildByName(param1) as MovieClip;
                     if(!_loc2_)
                     {
                        return null;
                     }
                  }
               }
            }
         }
         return _loc2_;
      }
      
      private function revealChildNodes(param1:GMMapNode) : void
      {
         var _loc3_:GMMapNode = null;
         var _loc2_:MovieClip = null;
         var _loc5_:GMMapNode = null;
         var _loc6_:MovieClip = getClipFromConstant(param1.Constant);
         if(_loc6_ == null)
         {
            return;
         }
         _loc6_.visible = true;
         var _loc7_:Number = 0.15;
         var _loc4_:Boolean = hasUnlockedChild(param1);
         for each(var _loc8_ in param1.RevealNodes)
         {
            if(_loc8_)
            {
               _loc3_ = mDBFacade.gameMaster.mapNodeByConstant.itemFor(_loc8_);
               if(!(_loc3_ && mapNodeOpen(_loc3_,true)))
               {
                  _loc2_ = getClipFromConstant(_loc8_);
                  if(_loc4_)
                  {
                     if(_loc2_)
                     {
                        _loc2_.visible = true;
                     }
                  }
                  else if(_loc2_)
                  {
                     _loc5_ = mDBFacade.gameMaster.mapNodeByConstant.itemFor(_loc2_.name);
                     if(_loc5_ && !_loc5_.AlwaysVisible)
                     {
                        mWorkComponent.doLater(_loc7_,revealCallback(_loc2_));
                        _loc7_ += 0.15;
                     }
                  }
               }
            }
         }
      }
      
      private function initializeLeagueMapNodes(param1:MovieClip, param2:Boolean = false) : void
      {
         var _loc5_:* = 0;
         var _loc3_:MovieClip = null;
         var _loc4_:GMMapNode = null;
         _loc5_ = 0;
         while(_loc5_ < param1.numChildren)
         {
            _loc3_ = param1.getChildAt(_loc5_) as MovieClip;
            if(_loc3_)
            {
               _loc3_.arrow.visible = false;
               _loc3_.arrow.mouseEnabled = false;
               _loc3_.arrow.mouseChildren = false;
               if(_loc3_.defeated && _loc3_.unlocked && _loc3_.locked)
               {
                  _loc3_.defeated.visible = false;
                  _loc3_.unlocked.visible = false;
                  _loc3_.locked.visible = true;
               }
               if(_loc3_.lock)
               {
                  _loc3_.lock.visible = false;
                  _loc3_.lock.mouseEnabled = false;
               }
               if(_loc3_.text_popup && _loc3_.text_popup.title_label)
               {
                  _loc3_.text_popup.visible = false;
                  _loc3_.text_popup.title_label.text = "LOCKED";
               }
               if(_loc3_.label)
               {
                  _loc3_.label.text = "";
               }
               _loc4_ = mDBFacade.gameMaster.mapNodeByConstant.itemFor(_loc3_.name);
               if(_loc4_ == null)
               {
                  Logger.warn("Can\'t find gmMapNode for: " + _loc3_.name);
               }
               else if(!_loc4_.AlwaysVisible)
               {
                  _loc3_.visible = false;
               }
            }
            _loc5_++;
         }
      }
      
      private function initializeAllMapNodes() : void
      {
         var _loc2_:* = 0;
         var _loc1_:MovieClip = null;
         _loc2_ = 0;
         while(_loc2_ < mRootMovieClip.worldmap.numChildren)
         {
            _loc1_ = mRootMovieClip.worldmap.getChildAt(_loc2_) as MovieClip;
            if(_loc1_ && _loc1_.name.search("_unlocked") != -1)
            {
               _loc1_.visible = false;
            }
            _loc2_++;
         }
         initializeLeagueMapNodes(mRootMovieClip.worldmap.rookie_league);
      }
      
      private function initializeOpenMapNodes() : void
      {
         var _loc5_:MapnodeInfo = null;
         var _loc3_:GMMapNode = null;
         var _loc1_:MovieClip = null;
         var _loc6_:* = null;
         var _loc7_:* = null;
         var _loc2_:Array = getUnlockedNodes();
         var _loc4_:uint = 0;
         mCurrentLeague = 0;
         _loc4_ = 0;
         while(_loc4_ < _loc2_.length)
         {
            _loc5_ = _loc2_[_loc4_] as MapnodeInfo;
            _loc3_ = mDBFacade.gameMaster.mapNodeById.itemFor(_loc5_.nodeId);
            if(_loc3_)
            {
               _loc1_ = mRootMovieClip.worldmap.rookie_league.getChildByName(_loc3_.Constant);
               if(_loc1_)
               {
                  if(_loc1_.text_popup && _loc1_.text_popup.title_label && _loc1_.text_popup.description_label)
                  {
                  }
                  _loc1_.visible = true;
                  _loc1_.arrow.visible = false;
                  _loc1_.arrow.mouseEnabled = false;
                  _loc1_.arrow.mouseChildren = false;
                  if(_loc1_.locked)
                  {
                     _loc1_.locked.visible = false;
                  }
                  if(mapNodeOpenNotDefeated(_loc3_))
                  {
                     _loc1_.unlocked.visible = true;
                     revealChildNodes(_loc3_);
                  }
                  else if(mapNodeOpen(_loc3_,true))
                  {
                     if(_loc1_.defeated)
                     {
                        _loc1_.defeated.visible = true;
                     }
                     revealChildNodes(_loc3_);
                  }
                  else if(_loc1_.unlocked)
                  {
                     _loc1_.unlocked.visible = true;
                     if(hasLockedNextNode(_loc3_))
                     {
                        _loc1_.arrow.visible = true;
                        _loc1_.arrow.mouseChildren = false;
                        _loc1_.arrow.mouseEnabled = false;
                     }
                  }
               }
            }
            _loc4_++;
         }
      }
      
      private function createNodeButtonsForLeague(param1:MovieClip) : Boolean
      {
         var _loc5_:* = 0;
         var _loc10_:MovieClip = null;
         var _loc13_:Boolean = false;
         var _loc11_:Boolean = false;
         var _loc3_:GMMapNode = null;
         var _loc9_:MovieClip = null;
         var _loc4_:MovieClipRenderController = null;
         var _loc7_:* = 0;
         var _loc6_:GMMapNode = null;
         var _loc14_:MovieClip = null;
         var _loc8_:UIButton = null;
         var _loc12_:UIButton = null;
         var _loc2_:Boolean = false;
         _loc5_ = 0;
         while(_loc5_ < param1.numChildren)
         {
            _loc10_ = param1.getChildAt(_loc5_) as MovieClip;
            if(_loc10_)
            {
               _loc13_ = false;
               _loc11_ = false;
               _loc3_ = mDBFacade.gameMaster.mapNodeByConstant.itemFor(_loc10_.name);
               if(_loc3_)
               {
                  if(mapNodesOpen(_loc3_.ParentNodes,false))
                  {
                     if(_loc3_.LevelRequirement <= mDBFacade.dbAccountInfo.activeAvatarInfo.level)
                     {
                        if(_loc10_.level_req)
                        {
                           _loc10_.level_req.visible = false;
                        }
                     }
                     else
                     {
                        _loc13_ = true;
                        if(_loc10_.level_req)
                        {
                           _loc10_.level_req.visible = true;
                           _loc10_.level_req.level_label.text = _loc3_.LevelRequirement.toString();
                        }
                        if(_loc10_.text_popup)
                        {
                           _loc10_.text_popup.description_label.text = "You are not high enough level to play this dungeon.";
                        }
                     }
                     if(_loc3_.TrophyRequirement <= mDBFacade.dbAccountInfo.trophies)
                     {
                        if(_loc10_.level_req)
                        {
                           _loc10_.trophy_req_left.visible = false;
                           _loc10_.trophy_req.visible = false;
                        }
                     }
                     else
                     {
                        _loc13_ = true;
                        if(_loc10_.level_req.visible == true)
                        {
                           _loc10_.level_req.visible = false;
                           _loc10_.trophy_req.visible = false;
                           _loc10_.trophy_req_left.visible = true;
                           _loc10_.trophy_req_left.level_label.text = _loc3_.LevelRequirement.toString();
                           _loc10_.trophy_req_left.trophy_label.text = _loc3_.TrophyRequirement.toString();
                           _loc10_.text_popup.description_label.text = "Not high enough level, and not enough trophies.";
                        }
                        else
                        {
                           _loc10_.trophy_req_left.visible = false;
                           _loc10_.trophy_req.visible = true;
                           _loc10_.trophy_req.trophy_label.text = _loc3_.TrophyRequirement.toString();
                           _loc10_.text_popup.description_label.text = "Not enough trophies to play this dungeon.";
                        }
                     }
                     if(_loc13_)
                     {
                        if(_loc10_.lock)
                        {
                           _loc10_.lock.visible = true;
                        }
                        _loc11_ = true;
                     }
                     else if(!mapNodesOpen(_loc3_.ParentNodes,true))
                     {
                        if(_loc10_.lock)
                        {
                           _loc10_.lock.visible = true;
                        }
                        _loc13_ = true;
                     }
                  }
                  else if(_loc10_.level_req && _loc10_.trophy_req)
                  {
                     _loc10_.level_req.visible = false;
                     _loc10_.trophy_req_left.visible = false;
                     _loc10_.trophy_req.visible = false;
                  }
                  if(_loc10_.unlocked.visible == true)
                  {
                     _loc9_ = _loc10_.unlocked;
                     _loc4_ = new MovieClipRenderController(mDBFacade,_loc9_);
                     _loc4_.play(0,true);
                  }
                  else if(_loc10_.defeated.visible == true)
                  {
                     _loc9_ = _loc10_.defeated;
                  }
                  else
                  {
                     _loc13_ = true;
                     _loc9_ = _loc10_.locked;
                  }
                  if(!_loc13_)
                  {
                     _loc2_ = true;
                     _loc7_ = 0;
                     while(_loc7_ < _loc3_.ParentNodes.length)
                     {
                        _loc6_ = _loc3_.ParentNodes[_loc7_];
                        if(_loc6_ && mapNodeOpen(_loc6_,true))
                        {
                           _loc14_ = mRootMovieClip.worldmap.getChildByName(_loc6_.Constant + "_" + _loc3_.Constant + "_unlocked");
                           if(_loc14_)
                           {
                              _loc14_.visible = true;
                              _loc4_ = new MovieClipRenderController(mDBFacade,_loc14_);
                              if(_loc9_ == _loc10_.unlocked)
                              {
                                 _loc4_.play(0,false);
                              }
                              else
                              {
                                 _loc4_.setFrame(_loc14_.totalFrames - 1);
                              }
                           }
                        }
                        _loc7_++;
                     }
                     _loc8_ = new UIButton(mDBFacade,_loc9_);
                     _loc8_.rolloverFilter = DBGlobal.UI_ROLLOVER_FILTER;
                     _loc8_.releaseCallback = moveAvatarToNode(_loc3_);
                     _loc8_.rollOverCursor = "POINT";
                     _loc8_.dontKillMyChildren = true;
                     _loc8_.tooltip = _loc10_.text_popup;
                     mOpenNodeButtons.add(_loc3_.Id,_loc8_);
                  }
                  else
                  {
                     _loc12_ = new UIButton(mDBFacade,_loc9_);
                     if(_loc10_.text_popup && _loc10_.text_popup.description_label)
                     {
                        if(!_loc11_)
                        {
                           _loc10_.text_popup.description_label.text = "Previous dungeon must be defeated first.";
                        }
                        _loc10_.text_popup.visible = true;
                        _loc12_.tooltip = _loc10_.text_popup;
                     }
                     _loc12_.rolloverFilter = DBGlobal.UI_DISABLED_FILTER;
                     _loc12_.releaseCallback = null;
                     _loc12_.rollOverCursor = "POINT";
                     _loc12_.dontKillMyChildren = true;
                     mOpenNodeButtons.add(_loc3_.Id,_loc12_);
                  }
               }
               else
               {
                  Logger.warn("Badly named map node in worldmap: " + _loc10_.name);
               }
            }
            _loc5_++;
         }
         return _loc2_;
      }
      
      private function setupMapNodeButtons() : void
      {
         var _loc1_:* = null;
         mOpenNodeButtons = new Map();
         mLockedNodeButtons = new Map();
         initializeAllMapNodes();
         initializeOpenMapNodes();
         var _loc4_:uint = 0;
         var _loc3_:uint = DBGlobal.TUTORIAL_MAP_NODE_ID;
         var _loc2_:GMMapNode = mDBFacade.gameMaster.mapNodeById.itemFor(_loc3_);
         if(!_loc2_ || !mapNodeOpen(_loc2_) || _loc3_ == 50001)
         {
            _loc3_ = DBGlobal.TUTORIAL_MAP_NODE_ID;
            _loc2_ = mDBFacade.gameMaster.mapNodeById.itemFor(_loc3_);
         }
         createNodeButtonsForLeague(mRootMovieClip.worldmap.rookie_league);
         setCurrentNode(_loc2_);
      }
      
      private function startFriendFader() : void
      {
         if(!mFriendFadeTask)
         {
            mFriendFadeTask = mWorkComponent.doEveryFrame(hideFriendsOnHover);
         }
      }
      
      private function stopFriendFader() : void
      {
         if(mFriendFadeTask)
         {
            mFriendFadeTask.destroy();
            mFriendFadeTask = null;
            if(mAvatarList)
            {
               for each(var _loc1_ in mAvatarList)
               {
                  _loc1_.alpha = 1;
                  MovieClip(_loc1_).join.alpha = 1;
               }
            }
         }
      }
      
      private function hideFriendsOnHover(param1:GameClock) : void
      {
         var _loc2_:Number = NaN;
         var _loc3_:Number = NaN;
         if(mAvatarList)
         {
            for each(var _loc4_ in mAvatarList)
            {
               _loc2_ = Math.abs(_loc4_.x - mRootMovieClip.worldmap.mouseX);
               _loc3_ = Math.abs(_loc4_.y - mRootMovieClip.worldmap.mouseY);
               if(_loc2_ < 60 && _loc3_ < 60)
               {
                  _loc2_ /= 60;
                  _loc3_ /= 60;
                  _loc4_.alpha = Math.sqrt(_loc2_ * _loc2_ + _loc3_ * _loc3_);
               }
               else
               {
                  _loc4_.alpha = 1;
               }
               MovieClip(_loc4_).join.alpha = 1 / Math.max(0.01,_loc4_.alpha);
            }
         }
      }
      
      private function clipFromNodeId(param1:uint) : MovieClip
      {
         var _loc2_:GMMapNode = mDBFacade.gameMaster.mapNodeById.itemFor(param1);
         if(_loc2_)
         {
            return getClipFromConstant(_loc2_.Constant);
         }
         return null;
      }
      
      private function checkTransition() : void
      {
         if(mUnlockResponseReceived && mDidKeySpentMessage)
         {
            if(mUnlockSuccessful)
            {
               mDBFacade.mouseCursorManager.popMouseCursor();
               mDBFacade.mouseCursorManager.disable = true;
               mDBFacade.mainStateMachine.enterLoadingScreenState(mCurrentNode.Id,mCurrentNode.NodeType,0,0,true,mBattlePopup.IsPrivate);
            }
            else
            {
               mBattlePopup.battleButton.enabled = true;
               mUnlockResponseReceived = false;
               mUnlockSuccessful = false;
               mDidKeySpentMessage = false;
            }
         }
      }
      
      private function unlockMapNodeSuccessCallback(param1:*) : void
      {
         mUnlockResponseReceived = true;
         mUnlockSuccessful = true;
         checkTransition();
      }
      
      private function unlockMapNodeFailCallback(param1:Error) : void
      {
         mUnlockResponseReceived = true;
         mUnlockSuccessful = false;
         Logger.error(param1.toString());
         checkTransition();
      }
      
      private function unlockMapNode() : void
      {
         var node:MovieClip;
         var popup:DBUIOneButtonPopup;
         var spentKeyClass:Class;
         var keyCostClip:MovieClip;
         var global_position:Point;
         var floatingMessage:FloatingMessage;
         var unlockMapNodeRPC:Function;
         if(mSpentKeyMessage)
         {
            return;
         }
         node = getClipFromConstant(mCurrentNode.Constant);
         if(!node)
         {
            Logger.error("Attempting to unlock invalid dungeon");
            return;
         }
         if(mCurrentNode.TrophyRequirement > mDBFacade.dbAccountInfo.trophies)
         {
            mDBFacade.metrics.log("NotEnoughTrophiesWarning");
            popup = new DBUIOneButtonPopup(mDBFacade,"STOP IT!","NO! NOT ENOUGH TROPHIES!","OK",null);
            return;
         }
         spentKeyClass = mTownSwfAsset.getClass("Branch_map_spent_key");
         mSpentKeyMessage = new spentKeyClass() as MovieClip;
         keyCostClip = mBattlePopup.keyCostClip;
         global_position = keyCostClip.localToGlobal(new Point(keyCostClip.x,keyCostClip.y));
         mSpentKeyMessage.x = mBattlePopup.battleButton.root.x;
         mSpentKeyMessage.y = mBattlePopup.battleButton.root.y - 40;
         if(mCurrentNode.BasicKeys > mCurrentNode.PremiumKeys)
         {
            mSpentKeyMessage.keyamount.text = mCurrentNode.BasicKeys.toString();
         }
         else
         {
            mSpentKeyMessage.keyamount.text = mCurrentNode.PremiumKeys.toString();
         }
         mBattlePopup.battleButton.enabled = false;
         mWorkComponent.doLater(1,function(param1:GameClock):void
         {
            mBattlePopup.animatePopupOut(true);
         });
         mDBFacade.sceneGraphManager.addChild(mSpentKeyMessage,105);
         floatingMessage = new FloatingMessage(mSpentKeyMessage,mDBFacade,12,64,10,60,null,function():void
         {
            mDBFacade.sceneGraphManager.removeChild(mSpentKeyMessage);
            mDidKeySpentMessage = true;
            checkTransition();
         });
         unlockMapNodeRPC = JSONRPCService.getFunction("UnlockMapNode",mDBFacade.rpcRoot + "worldmap");
         unlockMapNodeSuccessCallback(null);
      }
      
      private function moveAvatarToNode(param1:GMMapNode, param2:Boolean = false, param3:Boolean = false) : Function
      {
         var gmMapNode:GMMapNode = param1;
         var force:Boolean = param2;
         var returningToNodeFromAnotherScreen:Boolean = param3;
         return function():void
         {
            setCurrentNode(gmMapNode);
            if(mapNodeOpen(gmMapNode,false) || mapNodesOpen(gmMapNode.ParentNodes,true))
            {
               mBattlePopup.animatePopupIn();
               return;
            }
            mBattlePopup.animatePopupOut();
         };
      }
      
      private function setCurrentNode(param1:GMMapNode) : void
      {
         mCurrentNode = param1;
         if(mCurrentNode)
         {
            mBattlePopup = mRegularBattlePopup;
            mBattlePopup.currentDungeon = mCurrentNode;
            mBattlePopup.mapNodeOpen = mapNodeOpen(mCurrentNode);
            mBattlePopup.setDungeonDetails();
         }
      }
      
      public function battleButtonCallback() : void
      {
         var _loc2_:DBUIOneButtonPopup = null;
         var _loc1_:DBUIOneButtonPopup = null;
         if(mCurrentNode.LevelRequirement <= mDBFacade.dbAccountInfo.activeAvatarInfo.level)
         {
            if(mCurrentNode.TrophyRequirement > mDBFacade.dbAccountInfo.trophies)
            {
               mDBFacade.metrics.log("NotEnoughTrophiesWarning");
               _loc2_ = new DBUIOneButtonPopup(mDBFacade,"STOP IT!","NO! NOT ENOUGH TROPHIES!","OK",null);
               return;
            }
            if(mapNodeOpen(mCurrentNode))
            {
               mDBFacade.mouseCursorManager.popMouseCursor();
               mDBFacade.mouseCursorManager.disable = true;
               mDBFacade.mainStateMachine.enterLoadingScreenState(mCurrentNode.Id,mCurrentNode.NodeType,0,0,true,mBattlePopup.IsPrivate);
            }
            else
            {
               unlockMapNode();
            }
         }
         else
         {
            _loc1_ = new DBUIOneButtonPopup(mDBFacade,"STOP IT!","NO! NOT HIGH ENOUGH LEVEL!","OK",null);
         }
      }
      
      public function showFloatingMessage(param1:Number, param2:Number, param3:String) : void
      {
         var floatingMessage:FloatingMessage;
         var xPos:Number = param1;
         var yPos:Number = param2;
         var message:String = param3;
         var messageClass:Class = mTownSwfAsset.getClass("floating_text");
         var messageClip:MovieClip = new messageClass() as MovieClip;
         mRootMovieClip.addChild(messageClip);
         messageClip.x = xPos;
         messageClip.y = yPos;
         messageClip.mouseChildren = false;
         messageClip.mouseEnabled = false;
         messageClip.alpha = 0;
         messageClip.label.text = message;
         floatingMessage = new FloatingMessage(messageClip,mDBFacade,25,100,20,30,null,function():void
         {
            mRootMovieClip.removeChild(messageClip);
         });
      }
      
      private function showChooseDungeonMessage(param1:GameClock) : void
      {
         var clock:GameClock = param1;
         var messageClass:Class = mTownSwfAsset.getClass("Branch_choose_dungeon");
         var messageClip:MovieClip = new messageClass() as MovieClip;
         mRootMovieClip.addChild(messageClip);
         messageClip.x = messageClip.stage.stageWidth / 2;
         messageClip.y = messageClip.stage.stageHeight * 0.4;
         messageClip.scaleX = messageClip.scaleY = 1.5;
         messageClip.mouseChildren = false;
         messageClip.mouseEnabled = false;
         messageClip.alpha = 0;
         mRevealer = new Revealer(messageClip,mDBFacade,32,function():void
         {
            mChooseDungeonMessage = new FloatingMessage(messageClip,mDBFacade,32,32,1.35,0,null,function():void
            {
               mChooseDungeonMessage = null;
               mRootMovieClip.removeChild(messageClip);
            });
         },1);
      }
      
      public function set returnToMapNode(param1:GMMapNode) : void
      {
         mReturnToMapNode = param1;
      }
      
      private function buildPathFromSearchNode(param1:SearchNode) : void
      {
         mNodePath = [];
         mNodePath.push(param1.Node);
         while(param1.Parent)
         {
            param1 = param1.Parent;
            if(param1.Parent)
            {
               mNodePath.push(param1.Node);
            }
         }
      }
      
      private function findPathToNode(param1:GMMapNode) : void
      {
         var _loc2_:SearchNode = null;
         if(!param1 || !mCurrentNode || param1 == mCurrentNode)
         {
            return;
         }
         mNodeQueue = [];
         mClosedNodeList = new Set();
         var _loc3_:SearchNode = new SearchNode(mCurrentNode,null);
         mNodeQueue.push(_loc3_);
         while(mNodeQueue.length)
         {
            _loc2_ = mNodeQueue.shift();
            mClosedNodeList.add(_loc2_.Node);
            if(_loc2_.Node == param1)
            {
               buildPathFromSearchNode(_loc2_);
               return;
            }
            addChildrenToQueue(_loc2_);
         }
         Logger.error("Can\'t find path to selected map node.");
      }
      
      private function addChildrenToQueue(param1:SearchNode) : void
      {
         var _loc2_:* = 0;
         var _loc3_:GMMapNode = null;
         _loc2_ = 0;
         while(_loc2_ < param1.Node.ChildNodes.length)
         {
            _loc3_ = param1.Node.ChildNodes[_loc2_];
            if(_loc3_ && !mClosedNodeList.has(_loc3_))
            {
               mNodeQueue.push(new SearchNode(_loc3_,param1));
            }
            _loc2_++;
         }
      }
      
      private function setUpHacksToPlayNode() : void
      {
         mDBFacade.stageRef.addEventListener("keyDown",hackToHandleKeyPressToPlayNode);
      }
      
      private function tearDownHacksToPlayNode() : void
      {
         mDBFacade.stageRef.removeEventListener("keyDown",hackToHandleKeyPressToPlayNode);
      }
      
      private function hackToHandleKeyPressToPlayNode(param1:KeyboardEvent) : void
      {
         switch(int(param1.keyCode) - 69)
         {
            case 0:
               hackToPlayNode(50153);
               break;
            case 12:
               hackToPlayNode(50150);
               break;
            case 13:
               hackToPlayNode(50200);
               break;
            case 18:
               hackToPlayNode(50151);
         }
      }
      
      private function hackToPlayNode(param1:uint) : void
      {
         mDBFacade.mainStateMachine.enterLoadingScreenState(param1,"",0,0,true,false);
      }
   }
}

import GameMasterDictionary.GMMapNode;

class SearchNode
{
   
   public var Node:GMMapNode;
   
   public var Parent:SearchNode;
   
   public function SearchNode(param1:GMMapNode, param2:SearchNode)
   {
      super();
      Node = param1;
      Parent = param2;
   }
}
