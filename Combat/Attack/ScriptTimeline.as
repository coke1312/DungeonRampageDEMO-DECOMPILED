package Combat.Attack
{
   import Actor.ActorGameObject;
   import Actor.ActorView;
   import Brain.Clock.GameClock;
   import Brain.Logger.Logger;
   import Brain.WorkLoop.LogicalWorkComponent;
   import Brain.WorkLoop.Task;
   import DistributedObjects.DistributedDungeonFloor;
   import Facade.DBFacade;
   import GameMasterDictionary.GMAttack;
   import GeneratedCode.CombatResult;
   import org.as3commons.collections.ArrayList;
   import org.as3commons.collections.LinkedList;
   import org.as3commons.collections.Map;
   import org.as3commons.collections.framework.ILinkedListIterator;
   import org.as3commons.collections.framework.IListIterator;
   import org.as3commons.collections.framework.IMapIterator;
   
   public class ScriptTimeline
   {
      
      protected var mActorGameObject:ActorGameObject;
      
      protected var mTargetActor:ActorGameObject;
      
      protected var mActorView:ActorView;
      
      protected var mScriptJson:Object;
      
      protected var mDBFacade:DBFacade;
      
      protected var mDistributedDungeonFloor:DistributedDungeonFloor;
      
      protected var mTimelineActions:Map;
      
      protected var mFinishedCallback:Function;
      
      protected var mStopCallback:Function;
      
      protected var mPlayHeadTime:Number = 0;
      
      protected var mLastExecutedFrame:int = -1;
      
      protected var mFinishedFrame:int = 0;
      
      protected var mLoop:Boolean;
      
      protected var mHasGoto:Boolean;
      
      protected var mAutoAim:Boolean;
      
      protected var mIsPlaying:Boolean = false;
      
      protected var mIsLooping:Boolean = false;
      
      protected var mTotalFrames:uint;
      
      protected var mLogicalWorkComponent:LogicalWorkComponent;
      
      protected var mPlayTimelineTask:Task;
      
      protected var mCurrentAttackType:uint;
      
      protected var mCurrentGMAttack:GMAttack;
      
      protected var mCurrentCombatResult:CombatResult;
      
      protected var mCurrentAttacker:ActorGameObject;
      
      protected var mPlaySpeed:Number = 1;
      
      private var mContinuousCollisions:ArrayList;
      
      private var mRemovalContinuous:ArrayList;
      
      public var mManagedEffects:ArrayList;
      
      public function ScriptTimeline(param1:ActorGameObject, param2:ActorView, param3:Object, param4:DBFacade, param5:DistributedDungeonFloor)
      {
         super();
         mDBFacade = param4;
         mDistributedDungeonFloor = param5;
         mLogicalWorkComponent = new LogicalWorkComponent(mDBFacade);
         mTimelineActions = new Map();
         mActorView = param2;
         mActorGameObject = param1;
         mScriptJson = param3;
         parseJson(mScriptJson);
         mContinuousCollisions = new ArrayList();
         mRemovalContinuous = new ArrayList();
         mManagedEffects = new ArrayList();
      }
      
      public function set playSpeed(param1:Number) : void
      {
         mPlaySpeed = param1;
      }
      
      public function get playSpeed() : Number
      {
         return mPlaySpeed;
      }
      
      public function getPercentageOfTimelinePlayed() : Number
      {
         return mLastExecutedFrame / mTotalFrames;
      }
      
      public function getTimeRemaining() : Number
      {
         var _loc1_:Number = mTotalFrames - mLastExecutedFrame;
         return _loc1_ * mDBFacade.gameClock.tickLength / playSpeed;
      }
      
      protected function parseJson(param1:Object) : void
      {
         var _loc6_:AttackTimelineAction = null;
         var _loc11_:LinkedList = null;
         var _loc7_:int = 0;
         var _loc5_:Object = null;
         var _loc3_:* = 0;
         var _loc10_:Array = null;
         var _loc8_:* = 0;
         var _loc9_:int = 0;
         var _loc2_:Object = null;
         var _loc12_:Array = param1.frames;
         mTotalFrames = param1.totalFrames;
         var _loc4_:uint = _loc12_.length;
         _loc7_ = 0;
         while(_loc7_ < _loc4_)
         {
            _loc5_ = _loc12_[_loc7_];
            _loc3_ = uint(_loc5_.frame);
            _loc10_ = _loc5_.actions;
            _loc8_ = _loc10_.length;
            _loc11_ = new LinkedList();
            _loc9_ = 0;
            while(_loc9_ < _loc8_)
            {
               _loc2_ = _loc10_[_loc9_] as Object;
               _loc6_ = parseAction(_loc2_);
               if(_loc6_ != null)
               {
                  if(_loc3_ >= param1.totalFrames)
                  {
                     Logger.error("ScriptTimeline.as " + param1.attackName + " action:" + _loc6_ + " at frame:" + _loc3_ + " after last frame:" + (param1.totalFrames - 1));
                  }
                  _loc11_.add(_loc6_);
               }
               _loc9_++;
            }
            mTimelineActions.add(_loc3_,_loc11_);
            _loc7_++;
         }
         mFinishedFrame = param1.totalFrames;
      }
      
      protected function parseAction(param1:Object) : AttackTimelineAction
      {
         mHasGoto = false;
         var _loc3_:String = param1.type as String;
         var _loc2_:AttackTimelineAction = null;
         switch(_loc3_)
         {
            case "attackSound":
               _loc2_ = SoundAttackTimelineAction.buildFromJson(mActorGameObject,mActorView,mDBFacade,param1);
               break;
            case "sound":
               _loc2_ = SoundTimelineAction.buildFromJson(mActorGameObject,mActorView,mDBFacade,param1);
               break;
            case "animFrame":
               _loc2_ = AnimationFrameAttackTimelineAction.buildFromJson(mActorGameObject,mActorView,mDBFacade,param1);
               break;
            case "playAnim":
               _loc2_ = PlayAnimationAttackTimelineAction.buildFromJson(this,mActorGameObject,mActorView,mDBFacade,param1);
               break;
            case "move":
               _loc2_ = MovementAttackTimelineAction.buildFromJson(mActorGameObject,mActorView,mDBFacade,param1);
               break;
            case "runIdleMonitor":
               _loc2_ = RunIdleMonitorTimelineAction.buildFromJson(mActorGameObject,mActorView,mDBFacade,param1);
               break;
            case "goto":
               mHasGoto = true;
               _loc2_ = GotoTimelineAction.buildFromJson(mActorGameObject,mActorView,mDBFacade,param1,gotoFrame);
               break;
            case "knockback":
               _loc2_ = KnockBackTimelineAction.buildFromJson(mActorGameObject,mActorView,mDBFacade);
               break;
            case "shake":
               _loc2_ = CameraShakeTimelineAction.buildFromJson(mActorGameObject,mActorView,mDBFacade,param1);
               break;
            case "effect":
               _loc2_ = PlayEffectTimelineAction.buildFromJson(mActorGameObject,mActorView,mDBFacade,param1);
               break;
            case "color":
               _loc2_ = ColorShiftTimelineAction.buildFromJson(mActorGameObject,mActorView,mDBFacade,param1);
               break;
            case "glow":
               _loc2_ = GlowTimelineAction.buildFromJson(mActorGameObject,mActorView,mDBFacade,param1);
               break;
            case "fadebackground":
               _loc2_ = FadeBackgroundTimelineAction.buildFromJson(mActorGameObject,mActorView,mDBFacade,param1);
               break;
            case "visible":
               _loc2_ = HideTimelineAction.buildFromJson(mActorGameObject,mActorView,mDBFacade,param1);
               break;
            case "hideSpecialEffect":
               _loc2_ = HideSpecialEffectTimelineAction.buildFromJson(mActorGameObject,mActorView,mDBFacade,param1);
               break;
            case "scale":
               _loc2_ = ScaleAttackTimelineAction.buildFromJson(mActorGameObject,mActorView,mDBFacade,param1);
            case "zoom":
            case "timeScale":
            case "circleCollider":
            case "rectangleCollider":
            case "inputType":
            case "sufferImmunity":
               _loc2_ = SufferImmunityTimeLineAction.buildFromJson(mActorGameObject,mActorView,mDBFacade,param1);
               break;
            case "knockbackImmunity":
               _loc2_ = KnockbackImmunityTimeLineAction.buildFromJson(mActorGameObject,mActorView,mDBFacade,param1);
               break;
            case "attemptRevive":
            case "proposeRevive":
            case "spawndoober":
            case "spawnnpc":
            case "invulnerable":
               break;
            case "teleport":
               _loc2_ = TeleportTimelineAction.buildFromJson(mActorGameObject,mActorView,mDBFacade,param1);
               break;
            default:
               if(_loc3_.charAt(0) != "#")
               {
                  Logger.debug("No handle for attack timeline action type: " + _loc3_);
               }
         }
         return _loc2_;
      }
      
      public function set currentAttackType(param1:uint) : void
      {
         mCurrentAttackType = param1;
         mCurrentGMAttack = mDBFacade.gameMaster.attackById.itemFor(param1);
         if(mCurrentGMAttack == null)
         {
            Logger.error("Could not find GMAttack for id: " + param1);
         }
      }
      
      public function get currentGMAttack() : GMAttack
      {
         return mCurrentGMAttack;
      }
      
      public function set currentCombatResult(param1:CombatResult) : void
      {
         mCurrentCombatResult = param1;
         currentAttackType = param1.attack.attackType;
      }
      
      public function set currentAttacker(param1:ActorGameObject) : void
      {
         mCurrentAttacker = param1;
      }
      
      public function get isPlaying() : Boolean
      {
         return mIsPlaying;
      }
      
      public function get loop() : Boolean
      {
         return mLoop || mHasGoto;
      }
      
      public function get autoAim() : Boolean
      {
         return mAutoAim;
      }
      
      public function set autoAim(param1:Boolean) : void
      {
         mAutoAim = param1;
      }
      
      public function play(param1:Number, param2:ActorGameObject, param3:Function = null, param4:Function = null, param5:Boolean = false) : void
      {
         mPlayHeadTime = 0;
         mTargetActor = param2;
         mIsPlaying = true;
         mLoop = param5;
         mPlaySpeed = param1;
         if(mPlayTimelineTask != null)
         {
            mPlayTimelineTask.destroy();
            mPlayTimelineTask == null;
         }
         mFinishedCallback = param3;
         mStopCallback = param4;
         mLastExecutedFrame = -1;
         applyCurrentTimelineValues();
         mPlayTimelineTask = mLogicalWorkComponent.doEveryFrame(update);
         update(mLogicalWorkComponent.gameClock);
      }
      
      protected function applyCurrentTimelineValues() : void
      {
         extractActionToUpdateCurrentValues(mTimelineActions);
      }
      
      protected function extractActionToUpdateCurrentValues(param1:Map) : void
      {
         var _loc4_:LinkedList = null;
         var _loc5_:ILinkedListIterator = null;
         var _loc3_:AttackTimelineAction = null;
         var _loc2_:IMapIterator = param1.iterator() as IMapIterator;
         while(_loc2_.hasNext())
         {
            _loc4_ = _loc2_.next() as LinkedList;
            _loc5_ = _loc4_.iterator() as ILinkedListIterator;
            while(_loc5_.hasNext())
            {
               _loc3_ = _loc5_.next() as AttackTimelineAction;
               updateAction(_loc3_);
            }
         }
      }
      
      protected function updateAction(param1:AttackTimelineAction) : void
      {
         param1.combatResult = mCurrentCombatResult;
         param1.attacker = mCurrentAttacker;
         param1.attackType = mCurrentAttackType;
      }
      
      public function stop() : void
      {
         var _loc1_:* = 0;
         mIsPlaying = false;
         stopAllActions();
         if(mStopCallback != null)
         {
            mStopCallback();
            mStopCallback = null;
         }
         if(mPlayTimelineTask != null)
         {
            mPlayTimelineTask.destroy();
            mPlayTimelineTask = null;
         }
         var _loc2_:IListIterator = mManagedEffects.iterator() as IListIterator;
         while(_loc2_.hasNext())
         {
            _loc1_ = _loc2_.next() as uint;
            mActorGameObject.distributedDungeonFloor.effectManager.endManagedEffect(_loc1_);
         }
         mManagedEffects.clear();
      }
      
      public function stopAndFinish() : void
      {
         if(!mIsPlaying)
         {
            return;
         }
         stop();
         if(mFinishedCallback != null)
         {
            mFinishedCallback();
         }
         else
         {
            Logger.warn("the finished callback on the AttackTimeline was null during a non-loop attack.");
         }
      }
      
      private function stopAllActions() : void
      {
         var _loc4_:LinkedList = null;
         var _loc5_:ILinkedListIterator = null;
         var _loc3_:AttackTimelineAction = null;
         var _loc6_:AttackTimelineAction = null;
         var _loc2_:Array = [];
         var _loc1_:IMapIterator = mTimelineActions.iterator() as IMapIterator;
         while(_loc1_.hasNext())
         {
            _loc4_ = _loc1_.next() as LinkedList;
            _loc5_ = _loc4_.iterator() as ILinkedListIterator;
            while(_loc5_.hasNext())
            {
               _loc3_ = _loc5_.next() as AttackTimelineAction;
               _loc2_.push(_loc3_);
            }
         }
         while(_loc2_.length > 0)
         {
            _loc6_ = _loc2_.pop();
            _loc6_.stop();
         }
      }
      
      private function gotoFrame(param1:int) : void
      {
         mPlayHeadTime = param1;
         mIsLooping = true;
      }
      
      protected function processTimelineFrame(param1:Map, param2:int, param3:GameClock) : void
      {
         var _loc5_:LinkedList = null;
         var _loc6_:ILinkedListIterator = null;
         var _loc4_:AttackTimelineAction = null;
         if(param2 == mLastExecutedFrame && !mIsLooping)
         {
            return;
         }
         if(param1.hasKey(param2))
         {
            _loc5_ = param1.itemFor(param2);
            _loc6_ = _loc5_.iterator() as ILinkedListIterator;
            while(_loc6_.hasNext())
            {
               _loc4_ = _loc6_.next() as AttackTimelineAction;
               _loc4_.execute(this);
            }
         }
      }
      
      protected function update(param1:GameClock) : void
      {
         var _loc3_:* = 0;
         if(mFinishedFrame <= mLastExecutedFrame && mFinishedFrame <= mPlayHeadTime)
         {
            timelineActionsFinished();
            return;
         }
         var _loc2_:uint = uint(mLastExecutedFrame + 1);
         if(mPlayHeadTime < mLastExecutedFrame)
         {
            _loc2_ = mPlayHeadTime - 1;
         }
         _loc3_ = _loc2_;
         while(_loc3_ <= mPlayHeadTime)
         {
            processTimelineActions(_loc3_,param1);
            mLastExecutedFrame = _loc3_;
            _loc3_++;
         }
         updatePlayHead(param1);
      }
      
      protected function updatePlayHead(param1:GameClock) : void
      {
         mPlayHeadTime += mPlaySpeed * param1.timeScale;
      }
      
      protected function processTimelineActions(param1:int, param2:GameClock) : void
      {
         processTimelineFrame(mTimelineActions,param1,param2);
         processContinuousCollision();
      }
      
      protected function timelineActionsFinished() : void
      {
         if(mLoop)
         {
            mPlayHeadTime = 0;
            return;
         }
         stopAndFinish();
      }
      
      public function destroy() : void
      {
         var _loc1_:ILinkedListIterator = null;
         var _loc4_:LinkedList = null;
         var _loc2_:AttackTimelineAction = null;
         mActorGameObject = null;
         mActorView = null;
         mDBFacade = null;
         mDistributedDungeonFloor = null;
         var _loc3_:IMapIterator = mTimelineActions.iterator() as IMapIterator;
         while(_loc3_.hasNext())
         {
            _loc4_ = _loc3_.next();
            _loc1_ = _loc4_.iterator() as ILinkedListIterator;
            while(_loc1_.hasNext())
            {
               _loc2_ = _loc1_.next();
               _loc2_.destroy();
            }
            _loc4_.clear();
         }
         mTimelineActions.clear();
         mTimelineActions = null;
         mFinishedCallback = null;
         mStopCallback = null;
         mLogicalWorkComponent.destroy();
         mLogicalWorkComponent = null;
         if(mPlayTimelineTask)
         {
            mPlayTimelineTask.destroy();
            mPlayTimelineTask = null;
         }
         mCurrentGMAttack = null;
         mCurrentCombatResult = null;
         mCurrentAttacker = null;
         mContinuousCollisions.clear();
         mContinuousCollisions = null;
         mManagedEffects.clear();
         mManagedEffects = null;
      }
      
      public function get attackName() : String
      {
         return mScriptJson.attackName;
      }
      
      public function get currentFrame() : uint
      {
         return mLastExecutedFrame;
      }
      
      public function get targetActor() : ActorGameObject
      {
         return mTargetActor;
      }
      
      public function addContinuousCollision(param1:ColliderTimelineAction) : void
      {
         mContinuousCollisions.add(param1);
      }
      
      public function processContinuousCollision() : void
      {
         var _loc1_:IListIterator = null;
         var _loc2_:ColliderTimelineAction = null;
         if(mContinuousCollisions.size > 0)
         {
            _loc1_ = mContinuousCollisions.iterator() as IListIterator;
            while(_loc1_.hasNext())
            {
               _loc2_ = _loc1_.next() as ColliderTimelineAction;
               if(!_loc2_.perFrameUpCall(this))
               {
                  mRemovalContinuous.add(_loc2_);
               }
            }
            _loc1_ = mRemovalContinuous.iterator() as IListIterator;
            while(_loc1_.hasNext())
            {
               _loc2_ = _loc1_.next() as ColliderTimelineAction;
               mContinuousCollisions.remove(_loc2_);
            }
            mRemovalContinuous.clear();
         }
      }
   }
}

