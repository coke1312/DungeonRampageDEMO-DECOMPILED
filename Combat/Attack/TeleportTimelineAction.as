package Combat.Attack
{
   import Actor.ActorGameObject;
   import Actor.ActorView;
   import Brain.Clock.GameClock;
   import Brain.WorkLoop.Task;
   import DistributedObjects.HeroGameObjectOwner;
   import Facade.DBFacade;
   import flash.geom.Vector3D;
   
   public class TeleportTimelineAction extends AttackTimelineAction
   {
      
      public static const TYPE:String = "teleport";
      
      private var mFramesElapsed:uint;
      
      private var mDuration:uint;
      
      private var mMovementTask:Task;
      
      private var mStartPos:Vector3D;
      
      private var mEndPos:Vector3D;
      
      private var mOffset:Vector3D;
      
      public function TeleportTimelineAction(param1:ActorGameObject, param2:ActorView, param3:DBFacade, param4:uint)
      {
         mDuration = param4;
         super(param1,param2,param3);
      }
      
      public static function buildFromJson(param1:ActorGameObject, param2:ActorView, param3:DBFacade, param4:Object) : TeleportTimelineAction
      {
         var _loc5_:Number = Number(param4.duration);
         return new TeleportTimelineAction(param1,param2,param3,_loc5_);
      }
      
      override public function execute(param1:ScriptTimeline) : void
      {
         super.execute(param1);
         if(mFramesElapsed != 0)
         {
            ResetMovement();
         }
         mFramesElapsed = 0;
         if(mMovementTask)
         {
            mMovementTask.destroy();
            mMovementTask = null;
         }
         if(mWorkComponent)
         {
            mMovementTask = mWorkComponent.doEveryFrame(UpdateMovement);
         }
      }
      
      public function initMovementData() : void
      {
         var _loc1_:HeroGameObjectOwner = null;
         if(mDBFacade.gameObjectManager.getReferenceFromId(mActorGameObject.id) is HeroGameObjectOwner)
         {
            _loc1_ = mDBFacade.gameObjectManager.getReferenceFromId(mActorGameObject.id) as HeroGameObjectOwner;
            mStartPos = _loc1_.position;
            mEndPos = _loc1_.mTeleportDestination;
            mOffset = new Vector3D(mEndPos.x - mStartPos.x,mEndPos.y - mStartPos.y);
         }
      }
      
      public function moveHero() : void
      {
         var _loc1_:HeroGameObjectOwner = null;
         if(mDBFacade.gameObjectManager.getReferenceFromId(mActorGameObject.id) is HeroGameObjectOwner)
         {
            _loc1_ = mDBFacade.gameObjectManager.getReferenceFromId(mActorGameObject.id) as HeroGameObjectOwner;
            mStartPos = _loc1_.position;
            _loc1_.moveToTeleDest();
            mEndPos = _loc1_.mTeleportDestination;
            mOffset = new Vector3D(mEndPos.x - mStartPos.x,mEndPos.y - mStartPos.y);
         }
      }
      
      public function stopHeroMovement() : void
      {
         var _loc1_:HeroGameObjectOwner = null;
         if(mDBFacade.gameObjectManager.getReferenceFromId(mActorGameObject.id) is HeroGameObjectOwner)
         {
            _loc1_ = mDBFacade.gameObjectManager.getReferenceFromId(mActorGameObject.id) as HeroGameObjectOwner;
            _loc1_.stopMovement();
         }
      }
      
      public function easeInOutQuad(param1:Number, param2:Number, param3:Number, param4:Number) : Number
      {
         param1 /= param4 / 2;
         if(param1 < 1)
         {
            return param3 / 2 * param1 * param1 + param2;
         }
         param1--;
         return -param3 / 2 * (param1 * (param1 - 2) - 1) + param2;
      }
      
      public function updateView() : void
      {
         var _loc5_:HeroGameObjectOwner = null;
         var _loc4_:Number = NaN;
         var _loc1_:Number = NaN;
         var _loc2_:Vector3D = null;
         var _loc3_:Vector3D = null;
         if(mDBFacade.gameObjectManager.getReferenceFromId(mActorGameObject.id) is HeroGameObjectOwner)
         {
            _loc5_ = mDBFacade.gameObjectManager.getReferenceFromId(mActorGameObject.id) as HeroGameObjectOwner;
            _loc4_ = mFramesElapsed / mDuration;
            _loc4_ = easeInOutQuad(mFramesElapsed,0,1,mDuration);
            _loc1_ = 1 - _loc4_;
            _loc2_ = new Vector3D(mStartPos.x * _loc1_ + mEndPos.x * _loc4_,mStartPos.y * _loc1_ + mEndPos.y * _loc4_);
            _loc5_.placeAt(_loc2_);
            _loc3_ = new Vector3D(mOffset.x * _loc1_,mOffset.y * _loc1_);
            _loc5_.moveBodyTo(_loc3_);
         }
      }
      
      public function UpdateMovement(param1:GameClock) : void
      {
         if(mActorView && mActorView.body)
         {
            ++mFramesElapsed;
            if(mFramesElapsed == 1)
            {
               stopHeroMovement();
               initMovementData();
            }
            else if(mFramesElapsed <= mDuration)
            {
               updateView();
            }
            else if(mFramesElapsed > mDuration)
            {
               ResetMovement();
               return;
            }
            return;
         }
         ResetMovement();
      }
      
      private function ResetMovement() : void
      {
         var _loc1_:HeroGameObjectOwner = null;
         mFramesElapsed = 0;
         if(mActorView && mActorView.body)
         {
         }
         if(mMovementTask)
         {
            mMovementTask.destroy();
            mMovementTask = null;
         }
         if(mDBFacade.gameObjectManager.getReferenceFromId(mActorGameObject.id) is HeroGameObjectOwner)
         {
            _loc1_ = mDBFacade.gameObjectManager.getReferenceFromId(mActorGameObject.id) as HeroGameObjectOwner;
         }
      }
      
      override public function destroy() : void
      {
         if(mMovementTask)
         {
            mMovementTask.destroy();
            mMovementTask = null;
         }
         super.destroy();
      }
   }
}

