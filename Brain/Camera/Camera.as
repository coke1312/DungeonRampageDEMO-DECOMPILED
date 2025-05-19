package Brain.Camera
{
   import Brain.Clock.GameClock;
   import Brain.Facade.Facade;
   import com.greensock.TimelineMax;
   import com.greensock.TweenLite;
   import com.greensock.TweenMax;
   import flash.display.DisplayObject;
   import flash.geom.Matrix;
   import flash.geom.Point;
   import flash.geom.Rectangle;
   import flash.geom.Vector3D;
   
   public class Camera
   {
      
      private var mTargetObject:DisplayObject;
      
      private var mBounds:Rectangle;
      
      private var mMaxZoom:Number = 10;
      
      private var mMinZoom:Number = 0.01;
      
      private var mZoom:Number = 1;
      
      private var mRotation:Number = 0;
      
      private var mTransformDirty:Boolean = false;
      
      private var mRootPosition:Vector3D = new Vector3D();
      
      private var mRootTransform:Matrix = new Matrix();
      
      private var mShakePosition:Vector3D = new Vector3D();
      
      private var mShakeRotation:Number = 0;
      
      private var mBackgroundFader:BackgroundFader;
      
      private var mLetterboxEffect:LetterboxEffect;
      
      private var mDefaultZoom:Number;
      
      private var mTweenZoom:TweenLite;
      
      private var mTweenRotation:TweenLite;
      
      private var mOffset:Point;
      
      private var mYClippingFromBottom:uint;
      
      private var mWantScrollRectCulling:Boolean = false;
      
      private var mFacade:Facade;
      
      public function Camera(param1:Facade, param2:BackgroundFader, param3:LetterboxEffect)
      {
         super();
         mFacade = param1;
         mOffset = new Point();
         mBackgroundFader = param2;
         mLetterboxEffect = param3;
      }
      
      public function destroy() : void
      {
         if(mTweenZoom)
         {
            mTweenZoom.kill();
         }
         if(mTweenRotation)
         {
            mTweenRotation.kill();
         }
         if(mBackgroundFader)
         {
            mBackgroundFader.forceStop();
            mBackgroundFader = null;
         }
         if(mLetterboxEffect)
         {
            mLetterboxEffect.forceStop();
            mLetterboxEffect = null;
         }
         mTargetObject = null;
      }
      
      public function removeShakes() : void
      {
         mShakePosition.x = mShakePosition.y = 0;
         mTransformDirty = false;
      }
      
      public function set bounds(param1:Rectangle) : void
      {
         mBounds = param1;
      }
      
      public function get bounds() : Rectangle
      {
         return mBounds;
      }
      
      public function getDeltaToPoint(param1:Number, param2:Number) : Vector3D
      {
         if(mWantScrollRectCulling)
         {
            return new Vector3D((-param1 - mRootPosition.x) / mZoom,(-param2 - mRootPosition.y) / mZoom);
         }
         return new Vector3D(-param1 - mRootPosition.x,-param2 - mRootPosition.y);
      }
      
      public function centerCameraOnPoint(param1:Vector3D) : void
      {
         var _loc2_:Vector3D = getDeltaToPoint(param1.x,param1.y);
         if(!_loc2_.equals(mRootPosition))
         {
            mRootPosition = _loc2_;
            mTransformDirty = true;
         }
      }
      
      public function update(param1:GameClock = null) : void
      {
         var _loc4_:Number = NaN;
         var _loc2_:Number = NaN;
         var _loc5_:Number = NaN;
         var _loc3_:Number = NaN;
         if(mTransformDirty && mTargetObject)
         {
            mRootTransform.identity();
            if(mWantScrollRectCulling)
            {
               mRootTransform.scale(mZoom,mZoom);
               mRootTransform.rotate((mRotation + _shakeRotation) * 3.141592653589793 / 180);
               mTargetObject.transform.matrix = mRootTransform;
               mTargetObject.x = -mFacade.viewWidth * 0.5;
               mTargetObject.y = -mFacade.viewHeight * 0.5;
               _loc4_ = Math.round(-mRootPosition.x - mFacade.viewWidth / mZoom * 0.5);
               _loc2_ = Math.round(-mRootPosition.y - mFacade.viewHeight / mZoom * 0.5 + mOffset.y / mZoom);
               _loc5_ = Math.round(mFacade.viewWidth / mZoom);
               _loc3_ = Math.round(mFacade.viewHeight / mZoom - mYClippingFromBottom / mZoom);
               mTargetObject.scrollRect = new Rectangle(_loc4_,_loc2_,_loc5_,_loc3_);
            }
            else
            {
               mRootTransform.translate(mRootPosition.x + mOffset.x + mShakePosition.x,mRootPosition.y + mOffset.y + mShakePosition.y);
               mRootTransform.scale(mZoom,mZoom);
               mRootTransform.rotate((mRotation + _shakeRotation) * 3.141592653589793 / 180);
               mTargetObject.transform.matrix = mRootTransform;
            }
            mTransformDirty = false;
         }
      }
      
      public function translateTo(param1:Vector3D) : void
      {
         mRootPosition = param1;
         mTransformDirty = true;
      }
      
      public function translateBy(param1:Number, param2:Number) : void
      {
         mRootPosition.x += param1;
         mRootPosition.y += param2;
         mTransformDirty = true;
      }
      
      public function set targetObject(param1:DisplayObject) : void
      {
         mTargetObject = param1;
      }
      
      public function get targetObject() : DisplayObject
      {
         return mTargetObject;
      }
      
      public function set rotation(param1:Number) : void
      {
         mRotation = param1;
         mTransformDirty = true;
      }
      
      public function get rotation() : Number
      {
         return mRotation;
      }
      
      public function set _shakeRotation(param1:Number) : void
      {
         mShakeRotation = param1;
         mTransformDirty = true;
      }
      
      public function get _shakeRotation() : Number
      {
         return mShakeRotation;
      }
      
      public function set _shakeX(param1:Number) : void
      {
         mShakePosition.x = param1;
         mTransformDirty = true;
      }
      
      public function set _shakeY(param1:Number) : void
      {
         mShakePosition.y = param1;
         mTransformDirty = true;
      }
      
      public function get _shakeX() : Number
      {
         return mShakePosition.x;
      }
      
      public function get _shakeY() : Number
      {
         return mShakePosition.y;
      }
      
      public function tweenRotation(param1:Number, param2:Number) : void
      {
         if(mTweenRotation)
         {
            mTweenRotation.kill();
         }
         mTweenRotation = TweenLite.to(this,param1,{"rotation":param2});
      }
      
      public function set zoom(param1:Number) : void
      {
         param1 = Math.min(mMaxZoom,Math.max(mMinZoom,param1));
         if(mZoom == param1)
         {
            return;
         }
         mZoom = param1;
         mTransformDirty = true;
      }
      
      public function get zoom() : Number
      {
         return mZoom;
      }
      
      public function killTweenZooms() : void
      {
         if(mTweenZoom)
         {
            mTweenZoom.kill();
            mTweenZoom = null;
         }
      }
      
      private function shakeFunction(param1:Function, param2:Number, param3:Number, param4:uint) : TimelineMax
      {
         var _loc6_:Number = NaN;
         var _loc8_:* = 0;
         var _loc7_:TimelineMax = new TimelineMax();
         var _loc5_:Number = param2 / param4;
         _loc8_ = 0;
         while(_loc8_ < param4)
         {
            param3 = -param3;
            _loc6_ = _loc8_ == 0 ? _loc5_ * 0.5 : _loc5_;
            _loc7_.append(param1(_loc6_,param3));
            _loc8_++;
         }
         _loc7_.append(param1(_loc5_ * 0.5,0));
         return _loc7_;
      }
      
      public function shakeRotation(param1:Number, param2:Number, param3:uint) : TimelineMax
      {
         var duration:Number = param1;
         var strength:Number = param2;
         var numShakes:uint = param3;
         var self:Camera = this;
         var createTween:Function = function(param1:Number, param2:Number):TweenMax
         {
            return new TweenMax(self,param1,{
               "_shakeRotation":param2,
               "onUpdate":update
            });
         };
         return this.shakeFunction(createTween,duration,strength,numShakes);
      }
      
      public function shakeX(param1:Number, param2:Number, param3:uint) : TimelineMax
      {
         var duration:Number = param1;
         var strength:Number = param2;
         var numShakes:uint = param3;
         var self:Camera = this;
         var createTween:Function = function(param1:Number, param2:Number):TweenMax
         {
            return new TweenMax(self,param1,{
               "_shakeX":param2,
               "onUpdate":update
            });
         };
         return this.shakeFunction(createTween,duration,strength,numShakes);
      }
      
      public function shakeY(param1:Number, param2:Number, param3:uint) : TimelineMax
      {
         var duration:Number = param1;
         var strength:Number = param2;
         var numShakes:uint = param3;
         var self:Camera = this;
         var createTween:Function = function(param1:Number, param2:Number):TweenMax
         {
            return new TweenMax(self,param1,{
               "_shakeY":param2,
               "onUpdate":update
            });
         };
         return this.shakeFunction(createTween,duration,strength,numShakes);
      }
      
      public function set defaultZoom(param1:Number) : void
      {
         mDefaultZoom = param1;
      }
      
      public function get defaultZoom() : Number
      {
         return mDefaultZoom;
      }
      
      public function tweenToDefaultZoom(param1:Number) : TweenLite
      {
         return tweenZoom(param1,defaultZoom);
      }
      
      public function tweenZoom(param1:Number, param2:Number, param3:Boolean = false) : TweenLite
      {
         if(param3)
         {
            mDefaultZoom = param2;
         }
         killTweenZooms();
         mTweenZoom = TweenMax.to(this,param1,{
            "zoom":param2,
            "onUpdate":update
         });
         return mTweenZoom;
      }
      
      public function fadeBackground(param1:Array, param2:uint, param3:Number, param4:Vector3D, param5:Number) : void
      {
         mBackgroundFader.doFade(param1,param2,param3,param4,param5);
      }
      
      public function doLetterboxEffect(param1:uint, param2:Number, param3:Vector3D, param4:Number) : void
      {
         mLetterboxEffect.doFade(param1,param2,param3,param4);
      }
      
      public function killBackgroundFader() : void
      {
         mBackgroundFader.forceStop();
      }
      
      public function killLetterboxEffect() : void
      {
         mLetterboxEffect.forceStop();
      }
      
      public function get rootPosition() : Vector3D
      {
         return mRootPosition;
      }
      
      public function get visibleRectangle() : Rectangle
      {
         var _loc4_:Number = NaN;
         var _loc5_:Number = NaN;
         var _loc3_:Number = NaN;
         var _loc2_:Number = NaN;
         if(mWantScrollRectCulling)
         {
            _loc4_ = mFacade.viewWidth / mZoom;
            _loc5_ = mFacade.viewHeight / mZoom;
            _loc3_ = -mRootPosition.x - _loc4_ * 0.5 + mOffset.x / mZoom;
            _loc2_ = -mRootPosition.y - _loc5_ * 0.5 + mOffset.y / mZoom;
         }
         else
         {
            _loc3_ = (-mTargetObject.x - mTargetObject.parent.x) / mZoom;
            _loc2_ = (-mTargetObject.y - mTargetObject.parent.y) / mZoom;
            _loc4_ = mFacade.viewWidth / mZoom;
            _loc5_ = mFacade.viewHeight / mZoom;
         }
         return new Rectangle(_loc3_,_loc2_,_loc4_,_loc5_);
      }
      
      public function isPointOnScreen(param1:Vector3D) : Boolean
      {
         return this.visibleRectangle.contains(param1.x,param1.y);
      }
      
      public function get offset() : Point
      {
         return mOffset;
      }
      
      public function set offset(param1:Point) : void
      {
         mOffset = param1;
      }
      
      public function get yCilppingFromBottom() : Number
      {
         return mYClippingFromBottom;
      }
      
      public function set yCilppingFromBottom(param1:Number) : void
      {
         mYClippingFromBottom = param1;
      }
      
      public function forceRedraw() : void
      {
         mTransformDirty = true;
         update(null);
      }
      
      public function getWorldCoordinateFromMouse(param1:Number, param2:Number) : Vector3D
      {
         return new Vector3D(param1 / zoom + visibleRectangle.x,param2 / zoom + visibleRectangle.y);
      }
   }
}

