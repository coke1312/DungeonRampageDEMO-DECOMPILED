package Brain.UI
{
   import Brain.Facade.Facade;
   import flash.display.MovieClip;
   import flash.events.MouseEvent;
   import flash.geom.Rectangle;
   
   public class UISliderHandleButton extends UIButton
   {
      
      private var mSliderWidth:Number;
      
      private var mSliderHeight:Number;
      
      private var mOrientation:uint;
      
      private var mSlideCallback:Function;
      
      public function UISliderHandleButton(param1:Facade, param2:MovieClip, param3:uint, param4:Number, param5:Number)
      {
         super(param1,param2);
         mOrientation = param3;
         mSliderWidth = param4;
         mSliderHeight = param5;
      }
      
      override public function destroy() : void
      {
         mSlideCallback = null;
         super.destroy();
      }
      
      public function set slideCallback(param1:Function) : void
      {
         mSlideCallback = param1;
      }
      
      override protected function onPress(param1:MouseEvent) : void
      {
         super.onPress(param1);
         if(mOrientation == 0)
         {
            mRoot.startDrag(false,new Rectangle(0,0,mSliderWidth,0));
         }
         else
         {
            mRoot.startDrag(false,new Rectangle(0,0,0,mSliderHeight));
         }
         mFacade.stageRef.addEventListener("mouseMove",onMouseMove);
      }
      
      override protected function onRelease(param1:MouseEvent) : void
      {
         super.onRelease(param1);
         mFacade.stageRef.removeEventListener("mouseMove",onMouseMove);
      }
      
      override protected function onMouseUp(param1:MouseEvent) : void
      {
         super.onMouseUp(param1);
         mRoot.stopDrag();
         mSlideCallback();
      }
      
      override protected function onMouseMove(param1:MouseEvent) : void
      {
         if(mSlideCallback != null)
         {
            mSlideCallback();
         }
         super.onMouseMove(param1);
      }
   }
}

