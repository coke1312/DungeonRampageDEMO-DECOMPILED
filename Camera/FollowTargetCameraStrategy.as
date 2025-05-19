package Camera
{
   import Brain.Camera.Camera;
   import Brain.Camera.CameraStrategy;
   import Brain.Clock.GameClock;
   import Brain.Facade.Facade;
   import Brain.WorkLoop.Task;
   import Brain.WorkLoop.WorkComponent;
   import flash.display.Sprite;
   import flash.geom.Vector3D;
   
   public class FollowTargetCameraStrategy extends CameraStrategy
   {
      
      private var mFacade:Facade;
      
      private var mTarget:Sprite;
      
      private var mUpdateTask:Task;
      
      private var mCameraVel:Vector3D = new Vector3D();
      
      private var mForce:Number = 4;
      
      private var mMaxSpeed:Number = 20.833333333333332;
      
      public function FollowTargetCameraStrategy(param1:Camera, param2:Sprite)
      {
         mTarget = param2;
         super(param1);
      }
      
      override public function destroy() : void
      {
         stop();
         super.destroy();
         mTarget = null;
         mFacade = null;
      }
      
      override public function start(param1:WorkComponent) : void
      {
         if(mUpdateTask)
         {
            mUpdateTask.destroy();
         }
         mUpdateTask = param1.doEveryFrame(update);
      }
      
      override public function stop() : void
      {
         if(mUpdateTask)
         {
            mUpdateTask.destroy();
            mUpdateTask = null;
         }
      }
      
      private function update(param1:GameClock) : void
      {
         mCameraVel = mCamera.getDeltaToPoint(mTarget.x,mTarget.y);
         if(mCameraVel.lengthSquared > 0.5)
         {
            mCamera.translateBy(mCameraVel.x,mCameraVel.y);
         }
         mCamera.update(param1);
      }
      
      public function changeTarget(param1:Sprite) : void
      {
         mTarget = param1;
      }
   }
}

