package Brain.Facade
{
   import Brain.AssetRepository.AssetRepository;
   import Brain.Camera.BackgroundFader;
   import Brain.Camera.Camera;
   import Brain.Camera.LetterboxEffect;
   import Brain.Clock.GameClock;
   import Brain.Event.EventComponent;
   import Brain.Event.EventManager;
   import Brain.GameObject.GameObjectManager;
   import Brain.Input.InputManager;
   import Brain.Logger.Logger;
   import Brain.MouseCursor.MouseCursorManager;
   import Brain.SceneGraph.SceneGraphManager;
   import Brain.Sound.SoundManager;
   import Brain.WorkLoop.WorkLoopManager;
   import flash.display.DisplayObject;
   import flash.display.Stage;
   import flash.events.Event;
   import flash.geom.Vector3D;
   import flash.utils.Dictionary;
   import org.as3commons.collections.Map;
   
   public class Facade
   {
      
      public static const MAX_TICKS_PER_FRAME:int = 5;
      
      public static const FPS:uint = 24;
      
      protected var mElapsedTime:Number = 0;
      
      protected var mStageRef:Stage;
      
      private var mSwfWidth:Number;
      
      private var mSwfHeight:Number;
      
      protected var mSceneGraphManager:SceneGraphManager;
      
      protected var mInputManager:InputManager;
      
      protected var mRealClockWorkManager:WorkLoopManager;
      
      protected var mLogicalWorkManager:WorkLoopManager;
      
      protected var mPhysicsWorkManager:WorkLoopManager;
      
      protected var mPreRenderWorkManager:WorkLoopManager;
      
      protected var mLayerRenderWorkManager:WorkLoopManager;
      
      protected var mGameObjectManager:GameObjectManager;
      
      protected var mEventManager:EventManager;
      
      protected var mSoundManager:SoundManager;
      
      protected var mCamera:Camera;
      
      protected var mAssetRepository:AssetRepository;
      
      protected var mMouseCursorManager:MouseCursorManager;
      
      protected var mGameClock:GameClock;
      
      protected var mRealClock:GameClock;
      
      protected var mEventComponent:EventComponent;
      
      public var cacheVersion:String = "";
      
      public var versions:Object = null;
      
      protected var mAssetRepositoryClass:Class = AssetRepository;
      
      protected var mWantConsole:Boolean = false;
      
      protected var mWantFramerateEnforcement:Boolean = false;
      
      protected var mFrameTimes:Vector.<int>;
      
      protected var mCurrentTime:Number = 0;
      
      private var mSkippingFrame:Boolean = false;
      
      private var mSkippedFrames:int = 0;
      
      private var mCheaterLogMap:Map;
      
      private var mWallClockTimeElapsed:Number = 0;
      
      private var mGameClockTimeElapsed:Number = 0;
      
      private var mTickCounter:int = 0;
      
      private var mCheatCount:int = 0;
      
      private var mTickLength:Number = -1;
      
      private var mChildLayer:Dictionary = new Dictionary(true);
      
      public function Facade()
      {
         super();
         RootFacade = this;
         mFrameTimes = new Vector.<int>();
         mCheaterLogMap = new Map();
      }
      
      public function fileVersion(param1:String) : String
      {
         if(versions == null)
         {
            return cacheVersion;
         }
         var _loc2_:String = param1.indexOf("../../..") == 0 ? param1.substr(8) : param1;
         return versions[_loc2_] == null ? cacheVersion : versions[_loc2_];
      }
      
      public function get stageRef() : Stage
      {
         return mStageRef;
      }
      
      public function get viewWidth() : Number
      {
         return mStageRef.scaleMode == "noScale" ? mStageRef.stageWidth : mSwfWidth;
      }
      
      public function get viewHeight() : Number
      {
         return mStageRef.scaleMode == "noScale" ? mStageRef.stageHeight : mSwfHeight;
      }
      
      public function addRootDisplayObject(param1:DisplayObject, param2:Number = 0) : DisplayObject
      {
         var _loc3_:DisplayObject = null;
         var _loc4_:Number = NaN;
         var _loc5_:Number = mStageRef.numChildren - 1;
         while(_loc5_ >= 0)
         {
            _loc3_ = mStageRef.getChildAt(_loc5_);
            _loc4_ = Number(_loc3_ in mChildLayer ? mChildLayer[_loc3_] : 0);
            if(param2 >= _loc4_)
            {
               break;
            }
            _loc5_--;
         }
         mChildLayer[param1] = param2;
         return mStageRef.addChildAt(param1,_loc5_ + 1);
      }
      
      public function removeRootDisplayObject(param1:DisplayObject) : DisplayObject
      {
         delete mChildLayer[param1];
         return mStageRef.removeChild(param1);
      }
      
      public function get camera() : Camera
      {
         return mCamera;
      }
      
      public function get popupCurtainBlockMouse() : Boolean
      {
         return true;
      }
      
      public function buildEngines() : void
      {
         mSceneGraphManager = new SceneGraphManager(this);
         mGameObjectManager = new GameObjectManager(this);
         mInputManager = new InputManager(this);
         mSoundManager = new SoundManager(this);
         mMouseCursorManager = new MouseCursorManager(this);
      }
      
      public function mainLoop(param1:Event) : void
      {
         var _loc6_:Number = NaN;
         var _loc7_:Number = NaN;
         if(mTickLength == -1)
         {
            mTickLength = mGameClock.tickLength;
         }
         var _loc9_:Number = mGameClock.update();
         mElapsedTime += _loc9_;
         var _loc3_:uint = 0;
         mRealClock.update();
         mRealClock.gameTime = mRealClock.realTime;
         mRealClockWorkManager.update(mRealClock);
         var _loc5_:Boolean = false;
         mSkippingFrame = false;
         var _loc2_:Number = mCurrentTime;
         mCurrentTime = new Date().time;
         var _loc4_:int = mCurrentTime - _loc2_;
         _loc4_ = Math.max(0,_loc4_);
         mWallClockTimeElapsed += _loc4_;
         mGameClockTimeElapsed += _loc9_;
         if(mWallClockTimeElapsed > 1000)
         {
            _loc6_ = mGameClockTimeElapsed * 1000;
            _loc7_ = _loc6_ / mWallClockTimeElapsed;
            if(_loc7_ > 1.1)
            {
               mTickLength = mGameClock.tickLength * _loc7_;
               mCheatCount++;
               if(mCheatCount > 60)
               {
                  iamaCheater("testing_speed_hack_definite");
               }
               else if(mCheatCount > 3)
               {
                  iamaCheater("testing_speed_hack_probable");
               }
            }
            else
            {
               mTickLength = mGameClock.tickLength;
               mCheatCount = 0;
            }
            mGameClockTimeElapsed = 0;
            mWallClockTimeElapsed = 0;
         }
         var _loc8_:Number = -1;
         while(mElapsedTime >= mTickLength && _loc3_ < 5)
         {
            mTickCounter++;
            mLogicalWorkManager.update(mGameClock);
            mPhysicsWorkManager.update(mGameClock);
            mPreRenderWorkManager.update(mGameClock);
            mInputManager.flush();
            mElapsedTime -= mTickLength;
            mGameClock.gameTime += mTickLength * 1000;
            _loc3_++;
         }
         mLayerRenderWorkManager.update(mRealClock);
         if(_loc3_ >= 5)
         {
            mElapsedTime = 0;
         }
      }
      
      public function iamaCheater(param1:String) : void
      {
         if(!mCheaterLogMap.hasKey(param1))
         {
            mCheaterLogMap.add(param1,true);
            logCheater(param1);
         }
      }
      
      public function logCheater(param1:String) : void
      {
      }
      
      public function get skippingFrame() : Boolean
      {
         return mSkippingFrame;
      }
      
      public function init(param1:Stage) : void
      {
         mStageRef = param1;
         mSwfWidth = mStageRef.stageWidth;
         mSwfHeight = mStageRef.stageHeight;
         Logger.init(mStageRef,true);
         mGameClock = new GameClock(1 / 24);
         mRealClock = new GameClock(1 / param1.frameRate);
         mEventManager = new EventManager(this);
         mAssetRepository = new mAssetRepositoryClass(this);
         mRealClockWorkManager = new WorkLoopManager(mRealClock);
         mLogicalWorkManager = new WorkLoopManager(mGameClock);
         mPhysicsWorkManager = new WorkLoopManager(mGameClock);
         mPreRenderWorkManager = new WorkLoopManager(mGameClock);
         mLayerRenderWorkManager = new WorkLoopManager(mGameClock);
         mCamera = new Camera(this,new BackgroundFader(this),new LetterboxEffect(this));
         mEventComponent = new EventComponent(this);
      }
      
      public function run() : void
      {
         mEventComponent.addListener("enterFrame",this.mainLoop);
      }
      
      public function get inputManager() : InputManager
      {
         return mInputManager;
      }
      
      public function get gameClock() : GameClock
      {
         return mGameClock;
      }
      
      public function get realClock() : GameClock
      {
         return mRealClock;
      }
      
      public function get eventManager() : EventManager
      {
         return mEventManager;
      }
      
      public function get gameObjectManager() : GameObjectManager
      {
         return mGameObjectManager;
      }
      
      public function get sceneGraphManager() : SceneGraphManager
      {
         return mSceneGraphManager;
      }
      
      public function get logicalWorkManager() : WorkLoopManager
      {
         return mLogicalWorkManager;
      }
      
      public function get realClockWorkManager() : WorkLoopManager
      {
         return mRealClockWorkManager;
      }
      
      public function get preRenderWorkManager() : WorkLoopManager
      {
         return mPreRenderWorkManager;
      }
      
      public function get physicsWorkManager() : WorkLoopManager
      {
         return mPhysicsWorkManager;
      }
      
      public function get layerRenderWorkManager() : WorkLoopManager
      {
         return mLayerRenderWorkManager;
      }
      
      public function get assetRepository() : AssetRepository
      {
         return mAssetRepository;
      }
      
      public function get soundManager() : SoundManager
      {
         return mSoundManager;
      }
      
      public function get mouseCursorManager() : MouseCursorManager
      {
         return mMouseCursorManager;
      }
      
      public function getWorldCoordinateFromMouse() : Vector3D
      {
         return camera.getWorldCoordinateFromMouse(inputManager.mouseX,inputManager.mouseY);
      }
   }
}

