package Actor
{
   import Brain.Clock.GameClock;
   import Brain.WorkLoop.PreRenderWorkComponent;
   import Brain.WorkLoop.Task;
   import Brain.WorkLoop.WorkComponent;
   import Facade.DBFacade;
   import flash.geom.Point;
   import flash.geom.Vector3D;
   
   public class MovementController
   {
      
      public static const IDLE_VELOCITY_THRESHOLD:Number = 1;
      
      private static const DEFAULT_SMOOTH_FACTOR:Number = 0.8;
      
      public static const LOCKED_HERO_MOVEMENT_TYPE:String = "locked_hero";
      
      public static const LOCKED_XY_MOVEMENT_TYPE:String = "locked_xy";
      
      public static const LOCKED_R_MOVEMENT_TYPE:String = "locked_r";
      
      public static const LOCKED_MOVEMENT_TYPE:String = "locked";
      
      public static const NORMAL_MOVEMENT_TYPE:String = "normal";
      
      public static const ZERO_VECTOR:Vector3D = new Vector3D();
      
      protected var mTargetPosition:Point = new Point(0,0);
      
      protected var mActorGameObject:ActorGameObject;
      
      protected var mView:ActorView;
      
      protected var mPositionLerpTask:Task;
      
      protected var mMovementType:String = "normal";
      
      protected var mPreRenderWorkComponent:WorkComponent;
      
      protected var mWantSmoothTelemetry:Boolean;
      
      protected var mSmoothFactor:Number = 0.8;
      
      protected var mDBFacade:DBFacade;
      
      public function MovementController(param1:ActorGameObject, param2:ActorView, param3:DBFacade)
      {
         super();
         mDBFacade = param3;
         mView = param2;
         mActorGameObject = param1;
         mPreRenderWorkComponent = new PreRenderWorkComponent(param3);
         mWantSmoothTelemetry = mDBFacade.dbConfigManager.getConfigBoolean("smooth_telemetry",true);
         mSmoothFactor = mDBFacade.dbConfigManager.getConfigNumber("smooth_telemetry_factor",0.8);
      }
      
      public function set movementType(param1:String) : void
      {
         mView.position = mActorGameObject.position;
         mView.heading = mActorGameObject.heading;
         mMovementType = param1;
      }
      
      public function get movementType() : String
      {
         return mMovementType;
      }
      
      public function get canMoveHero() : Boolean
      {
         return mMovementType != "locked_hero";
      }
      
      public function get canMoveXY() : Boolean
      {
         return mMovementType != "locked" && mMovementType != "locked_xy";
      }
      
      public function get canMoveR() : Boolean
      {
         return mMovementType != "locked" && mMovementType != "locked_r";
      }
      
      public function stopLerp() : void
      {
         if(mPositionLerpTask)
         {
            mPositionLerpTask.destroy();
            mPositionLerpTask = null;
         }
      }
      
      public function move(param1:Vector3D, param2:Number) : void
      {
         if(!canMoveXY)
         {
            if(mPositionLerpTask)
            {
               mPositionLerpTask.destroy();
               mPositionLerpTask = null;
            }
         }
         if(mActorGameObject.actorData && mActorGameObject.actorData.isMover)
         {
            if(!mPositionLerpTask)
            {
               mPositionLerpTask = mPreRenderWorkComponent.doEveryFrame(positionLerp);
            }
         }
         else
         {
            mView.position = param1;
            mView.heading = param2;
         }
      }
      
      public function moveBody(param1:Vector3D, param2:Number) : void
      {
         mView.body.x = param1.x;
         mView.body.y = param1.y;
      }
      
      protected function positionLerp(param1:GameClock) : void
      {
         var _loc5_:Vector3D = null;
         var _loc2_:Number = NaN;
         var _loc3_:Number = NaN;
         var _loc4_:Number = (1 - mSmoothFactor) * param1.timeScale;
         if(mWantSmoothTelemetry)
         {
            _loc2_ = mView.position.x * (1 - _loc4_) + mActorGameObject.position.x * _loc4_;
            _loc3_ = mView.position.y * (1 - _loc4_) + mActorGameObject.position.y * _loc4_;
            _loc5_ = new Vector3D(_loc2_,_loc3_);
         }
         else
         {
            _loc5_ = mActorGameObject.position;
         }
         mView.velocity = _loc5_.subtract(mView.position);
         if(mView.velocity.nearEquals(ZERO_VECTOR,1))
         {
            if(mPositionLerpTask)
            {
               mPositionLerpTask.destroy();
               mPositionLerpTask = null;
            }
            mView.heading = mActorGameObject.heading;
            mView.position = mActorGameObject.position;
            mView.velocity.scaleBy(0);
         }
         else
         {
            mView.position = _loc5_;
            if(canMoveR)
            {
               mView.heading = Math.atan2(mView.velocity.y,mView.velocity.x) * 180 / 3.141592653589793;
            }
         }
      }
      
      public function destroy() : void
      {
         if(mPositionLerpTask)
         {
            mPositionLerpTask.destroy();
            mPositionLerpTask = null;
         }
         mPreRenderWorkComponent.destroy();
         mDBFacade = null;
      }
   }
}

