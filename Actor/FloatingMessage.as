package Actor
{
   import Facade.DBFacade;
   import com.greensock.TimelineMax;
   import com.greensock.TweenMax;
   import com.greensock.easing.Quint;
   import flash.display.DisplayObject;
   import flash.display.DisplayObjectContainer;
   import flash.geom.Vector3D;
   
   public class FloatingMessage
   {
      
      public static const DAMAGE_MOVEMENT_TYPE:String = "DAMAGE_MOVEMENT_TYPE";
      
      public static const BUFF_DAMAGE_MOVEMENT_TYPE:String = "BUFF_DAMAGE_MOVEMENT_TYPE";
      
      private static const DEFAULT_DIRECTION:Vector3D = new Vector3D(0,-1,0);
      
      protected var mDBFacade:DBFacade;
      
      protected var mRoot:DisplayObject;
      
      protected var mScaleDampening:Number;
      
      protected var mFinishedCallback:Function;
      
      protected var mFloatSpeed:Number;
      
      protected var mFloatDirection:Vector3D;
      
      protected var mTotalDuration:uint;
      
      protected var mHoldDuration:uint;
      
      protected var mTimelineMax:TimelineMax;
      
      protected var mStartPosition:Vector3D;
      
      protected var mResetPositionAtEnd:Boolean;
      
      public function FloatingMessage(param1:DisplayObject, param2:DBFacade, param3:uint, param4:uint, param5:Number, param6:Number, param7:Vector3D = null, param8:Function = null, param9:String = "DAMAGE_MOVEMENT_TYPE", param10:Boolean = false)
      {
         super();
         mDBFacade = param2;
         mRoot = param1;
         if(mRoot is DisplayObjectContainer)
         {
            DisplayObjectContainer(mRoot).mouseChildren = false;
            DisplayObjectContainer(mRoot).mouseEnabled = false;
         }
         mFinishedCallback = param8;
         mHoldDuration = param3;
         mTotalDuration = param4;
         mScaleDampening = param5;
         mFloatSpeed = param6;
         mFloatDirection = param7 ? param7 : DEFAULT_DIRECTION;
         mResetPositionAtEnd = param10;
         if(mResetPositionAtEnd)
         {
            mStartPosition = new Vector3D(param1.x,param1.y);
         }
         if(param9 == "BUFF_DAMAGE_MOVEMENT_TYPE")
         {
            buffFloaterTween();
         }
         else
         {
            damageFloaterTween();
         }
      }
      
      private function damageFloaterTween() : void
      {
         var dt:Number = mDBFacade.gameClock.tickLength;
         var distance:Number = mFloatSpeed * mTotalDuration * dt;
         var toX:Number = mRoot.x + mFloatDirection.x * distance;
         var toY:Number = mRoot.y + mFloatDirection.y * distance;
         var toScaleX:Number = mRoot.scaleX * mScaleDampening;
         var toScaleY:Number = mRoot.scaleY * mScaleDampening;
         mTimelineMax = new TimelineMax({
            "tweens":[TweenMax.to(mRoot,mTotalDuration * 0.8 * dt,{
               "delay":mHoldDuration * dt,
               "x":toX,
               "y":toY,
               "scaleX":toScaleX,
               "scaleY":toScaleY,
               "ease":Quint.easeOut
            }),TweenMax.to(mRoot,mTotalDuration * 0.2 * dt,{"alpha":0})],
            "align":"sequence",
            "onComplete":function():void
            {
               if(mFinishedCallback != null)
               {
                  mFinishedCallback();
                  mFinishedCallback = null;
               }
               destroy();
            }
         });
      }
      
      private function buffFloaterTween() : void
      {
         var dt:Number = mDBFacade.gameClock.tickLength;
         var distance:Number = mFloatSpeed * mTotalDuration * dt * 2;
         var toX:Number = mRoot.x + mFloatDirection.x * distance;
         var maxY:Number = mRoot.y + mFloatDirection.y * distance * 0.5;
         var minY:Number = maxY - mFloatDirection.y * distance * 0.7;
         var toScaleX:Number = mRoot.scaleX * mScaleDampening;
         var toScaleY:Number = mRoot.scaleY * mScaleDampening;
         var maxYTime:Number = mTotalDuration * dt * 0.1;
         var minYTime:Number = mTotalDuration * dt * 0.7;
         mTimelineMax = new TimelineMax({
            "tweens":[TweenMax.to(mRoot,mTotalDuration * dt,{
               "x":toX,
               "scaleX":toScaleX,
               "scaleY":toScaleY
            }),TweenMax.to(mRoot,mTotalDuration * 0.3 * dt,{
               "delay":mTotalDuration * 0.7 * dt,
               "alpha":0
            }),TweenMax.to(mRoot,maxYTime,{
               "y":maxY,
               "ease":Quint.easeOut
            }),TweenMax.to(mRoot,minYTime,{
               "delay":maxYTime,
               "y":minY,
               "ease":Quint.easeIn
            })],
            "align":"normal",
            "onComplete":function():void
            {
               if(mFinishedCallback != null)
               {
                  mFinishedCallback();
                  mFinishedCallback = null;
               }
               destroy();
            }
         });
      }
      
      public function destroy() : void
      {
         if(mResetPositionAtEnd && mRoot)
         {
            mRoot.x = mStartPosition.x;
            mRoot.y = mStartPosition.y;
         }
         if(mFinishedCallback != null)
         {
            mFinishedCallback();
            mFinishedCallback = null;
         }
         mRoot = null;
         mDBFacade = null;
         if(mTimelineMax)
         {
            mTimelineMax.kill();
            mTimelineMax = null;
         }
      }
   }
}

