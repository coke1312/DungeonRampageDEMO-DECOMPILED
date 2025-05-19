package Combat.Attack
{
   import Actor.ActorGameObject;
   import Actor.ActorView;
   import Brain.Clock.GameClock;
   import Brain.WorkLoop.Task;
   import Facade.DBFacade;
   import flash.geom.ColorTransform;
   import flash.geom.Vector3D;
   
   public class ColorShiftTimelineAction extends AttackTimelineAction
   {
      
      public static const TYPE:String = "color";
      
      private var mDuration:uint;
      
      private var mColorMul:Vector3D;
      
      private var mColorAdd:Vector3D;
      
      private var mAlphaMul:Number;
      
      private var mAlphaAdd:Number;
      
      private var mOldColorTransform:ColorTransform;
      
      private var mColorTransformTask:Task;
      
      private var mFramesElapsed:uint = 0;
      
      private var mOffsets:ColorTransform;
      
      private var mTransitionDuration:Number;
      
      public function ColorShiftTimelineAction(param1:ActorGameObject, param2:ActorView, param3:DBFacade, param4:uint, param5:Vector3D, param6:Vector3D, param7:Number, param8:Number, param9:Number)
      {
         mDuration = param4;
         mColorMul = new Vector3D(param5.x,param5.y,param5.z);
         mColorAdd = new Vector3D(param6.x,param6.y,param6.z);
         mAlphaMul = param7;
         mAlphaAdd = param8;
         mTransitionDuration = param9;
         super(param1,param2,param3);
         mOldColorTransform = new ColorTransform();
         mOffsets = new ColorTransform();
      }
      
      public static function buildFromJson(param1:ActorGameObject, param2:ActorView, param3:DBFacade, param4:Object) : ColorShiftTimelineAction
      {
         var _loc5_:Number = Number(param4.duration);
         var _loc10_:Vector3D = new Vector3D(param4.filter_r,param4.filter_g,param4.filter_b);
         var _loc7_:Vector3D = new Vector3D(param4.add_r,param4.add_g,param4.add_b);
         var _loc6_:Number = Number(param4.filter_alpha);
         var _loc9_:Number = Number(param4.add_alpha);
         var _loc8_:Number = Number(param4.transitionDur);
         return new ColorShiftTimelineAction(param1,param2,param3,_loc5_,_loc10_,_loc7_,_loc6_,_loc9_,_loc8_);
      }
      
      private function CopyColorTransform(param1:ColorTransform) : ColorTransform
      {
         var _loc2_:ColorTransform = new ColorTransform();
         _loc2_.alphaMultiplier = param1.alphaMultiplier;
         _loc2_.alphaOffset = param1.alphaOffset;
         _loc2_.blueMultiplier = param1.blueMultiplier;
         _loc2_.blueOffset = param1.blueOffset;
         _loc2_.redMultiplier = param1.redMultiplier;
         _loc2_.redOffset = param1.redOffset;
         _loc2_.greenMultiplier = param1.greenMultiplier;
         _loc2_.greenOffset = param1.greenOffset;
         return _loc2_;
      }
      
      private function CalculateColorTransformOffsets(param1:ColorTransform, param2:ColorTransform, param3:Number) : void
      {
         mOffsets.alphaMultiplier = (param2.alphaMultiplier - param1.alphaMultiplier) / param3;
         mOffsets.alphaOffset = (param2.alphaOffset - param1.alphaOffset) / param3;
         mOffsets.blueMultiplier = (param2.blueMultiplier - param1.blueMultiplier) / param3;
         mOffsets.blueOffset = (param2.blueOffset - param1.blueOffset) / param3;
         mOffsets.redMultiplier = (param2.redMultiplier - param1.redMultiplier) / param3;
         mOffsets.redOffset = (param2.redOffset - param1.redOffset) / param3;
         mOffsets.greenMultiplier = (param2.greenMultiplier - param1.greenMultiplier) / param3;
         mOffsets.greenOffset = (param2.greenOffset - param1.greenOffset) / param3;
      }
      
      private function AddColorTransformOffsets() : ColorTransform
      {
         var _loc1_:ColorTransform = new ColorTransform();
         var _loc2_:ColorTransform = mActorView.body.transform.colorTransform;
         _loc1_.alphaMultiplier = _loc2_.alphaMultiplier + mOffsets.alphaMultiplier;
         _loc1_.alphaOffset = _loc2_.alphaOffset + mOffsets.alphaOffset;
         _loc1_.blueMultiplier = _loc2_.blueMultiplier + mOffsets.blueMultiplier;
         _loc1_.blueOffset = _loc2_.blueOffset + mOffsets.blueOffset;
         _loc1_.redMultiplier = _loc2_.redMultiplier + mOffsets.redMultiplier;
         _loc1_.redOffset = _loc2_.redOffset + mOffsets.redOffset;
         _loc1_.greenMultiplier = _loc2_.greenMultiplier + mOffsets.greenMultiplier;
         _loc1_.greenOffset = _loc2_.greenOffset + mOffsets.greenOffset;
         return _loc1_;
      }
      
      private function SubtractColorTransformOffsets() : ColorTransform
      {
         var _loc1_:ColorTransform = new ColorTransform();
         var _loc2_:ColorTransform = mActorView.body.transform.colorTransform;
         _loc1_.alphaMultiplier = _loc2_.alphaMultiplier - mOffsets.alphaMultiplier;
         _loc1_.alphaOffset = _loc2_.alphaOffset - mOffsets.alphaOffset;
         _loc1_.blueMultiplier = _loc2_.blueMultiplier - mOffsets.blueMultiplier;
         _loc1_.blueOffset = _loc2_.blueOffset - mOffsets.blueOffset;
         _loc1_.redMultiplier = _loc2_.redMultiplier - mOffsets.redMultiplier;
         _loc1_.redOffset = _loc2_.redOffset - mOffsets.redOffset;
         _loc1_.greenMultiplier = _loc2_.greenMultiplier - mOffsets.greenMultiplier;
         _loc1_.greenOffset = _loc2_.greenOffset - mOffsets.greenOffset;
         return _loc1_;
      }
      
      override public function execute(param1:ScriptTimeline) : void
      {
         super.execute(param1);
         if(mFramesElapsed != 0)
         {
            ResetColorTransform();
         }
         mFramesElapsed = 0;
         mOldColorTransform = CopyColorTransform(new ColorTransform());
         var _loc2_:ColorTransform = new ColorTransform(mColorMul.x,mColorMul.y,mColorMul.z,mAlphaMul,mColorAdd.x,mColorAdd.y,mColorAdd.z,mAlphaAdd);
         CalculateColorTransformOffsets(mOldColorTransform,_loc2_,mTransitionDuration);
         if(mColorTransformTask)
         {
            mColorTransformTask.destroy();
            mColorTransformTask = null;
         }
         if(mWorkComponent)
         {
            mColorTransformTask = mWorkComponent.doEveryFrame(UpdateColorShift);
         }
      }
      
      public function UpdateColorShift(param1:GameClock) : void
      {
         if(mActorView && mActorView.body)
         {
            ++mFramesElapsed;
            if(mFramesElapsed <= mTransitionDuration)
            {
               mActorView.body.transform.colorTransform = AddColorTransformOffsets();
            }
            else if(mFramesElapsed >= mDuration - mTransitionDuration)
            {
               mActorView.body.transform.colorTransform = SubtractColorTransformOffsets();
            }
            if(mFramesElapsed > mDuration)
            {
               ResetColorTransform();
               return;
            }
            return;
         }
         ResetColorTransform();
      }
      
      private function ResetColorTransform() : void
      {
         mFramesElapsed = 0;
         if(mActorView && mActorView.body)
         {
            mActorView.body.transform.colorTransform = CopyColorTransform(mOldColorTransform);
         }
         if(mColorTransformTask)
         {
            mColorTransformTask.destroy();
            mColorTransformTask = null;
         }
      }
      
      override public function destroy() : void
      {
         if(mColorTransformTask)
         {
            mColorTransformTask.destroy();
            mColorTransformTask = null;
         }
         super.destroy();
      }
   }
}

