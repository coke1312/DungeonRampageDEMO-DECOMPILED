package Brain.UI
{
   import Brain.Clock.GameClock;
   import Brain.Facade.Facade;
   import Brain.Render.MovieClipRenderController;
   import flash.display.Bitmap;
   import flash.display.BitmapData;
   import flash.display.DisplayObject;
   import flash.display.DisplayObjectContainer;
   import flash.display.MovieClip;
   import flash.events.Event;
   import flash.events.KeyboardEvent;
   import flash.events.MouseEvent;
   import flash.filters.GlowFilter;
   import flash.geom.Point;
   import flash.geom.Rectangle;
   import flash.text.TextField;
   
   public class UIButton extends UIObject
   {
      
      protected static const UP:uint = 0;
      
      protected static const DOWN:uint = 1;
      
      protected static const OVER:uint = 2;
      
      protected static const DISABLED:uint = 3;
      
      protected static const SELECTED:uint = 4;
      
      protected var mUpState:MovieClip;
      
      protected var mDownState:MovieClip;
      
      protected var mOverState:MovieClip;
      
      protected var mDisabledState:MovieClip;
      
      protected var mUpRenderer:MovieClipRenderController;
      
      protected var mDownRenderer:MovieClipRenderController;
      
      protected var mOverRenderer:MovieClipRenderController;
      
      protected var mDisabledRenderer:MovieClipRenderController;
      
      protected var mSelected:Boolean;
      
      protected var mSelectedState:MovieClip;
      
      protected var mSelectedRenderer:MovieClipRenderController;
      
      protected var mHitArea:MovieClip;
      
      protected var mLabel:TextField;
      
      protected var mDraggable:Boolean = false;
      
      private var mDragged:Boolean = false;
      
      protected var mDragStartParent:DisplayObjectContainer;
      
      protected var mDragStartPos:Point;
      
      protected var mStates:Array;
      
      protected var mRenderers:Array;
      
      protected var mRolloverFilter:GlowFilter;
      
      protected var mSelectedFilter:GlowFilter;
      
      protected var mFiltersBeforeRollover:Array;
      
      protected var mMouseDown:Boolean = false;
      
      protected var mPressCallback:Function;
      
      protected var mReleaseCallback:Function;
      
      protected var mDragReleaseCallback:Function;
      
      protected var mEnterCallback:Function;
      
      protected var mPressRollOutCallback:Function;
      
      protected var mRollOverCallback:Function;
      
      protected var mRollOutCallback:Function;
      
      protected var mRollOverCursor:String = "POINT";
      
      protected var mRollOverCursorKey:uint;
      
      protected var mDragBounds:Rectangle;
      
      private var mDisableEventPropogation:Boolean;
      
      public function UIButton(param1:Facade, param2:MovieClip, param3:int = 0, param4:Boolean = true)
      {
         if(param2.hasOwnProperty("theButton"))
         {
            param2 = param2.theButton;
         }
         if(param2.hasOwnProperty("up"))
         {
            mUpState = param2.up;
            mUpState.mouseChildren = false;
            mUpRenderer = new MovieClipRenderController(param1,mUpState);
         }
         if(param2.hasOwnProperty("down"))
         {
            mDownState = param2.down;
            mDownState.mouseChildren = false;
            mDownRenderer = new MovieClipRenderController(param1,mDownState);
         }
         else
         {
            mDownState = mUpState;
            mDownRenderer = mUpRenderer;
         }
         if(param2.hasOwnProperty("over"))
         {
            mOverState = param2.over;
            mOverState.mouseChildren = false;
            mOverRenderer = new MovieClipRenderController(param1,mOverState);
         }
         else
         {
            mOverState = mUpState;
            mOverRenderer = mUpRenderer;
         }
         if(param2.hasOwnProperty("disabled"))
         {
            mDisabledState = param2.disabled;
            mDisabledState.mouseChildren = false;
            mDisabledRenderer = new MovieClipRenderController(param1,mDisabledState);
         }
         else
         {
            mDisabledState = mUpState;
            mDisabledRenderer = mUpRenderer;
         }
         if(param2.hasOwnProperty("selected"))
         {
            mSelectedState = param2.selected;
            mSelectedState.mouseChildren = false;
            mSelectedRenderer = new MovieClipRenderController(param1,mSelectedState);
         }
         else
         {
            mSelectedState = mUpState;
            mSelectedRenderer = mUpRenderer;
         }
         mStates = [mUpState,mDownState,mOverState,mDisabledState,mSelectedState];
         mRenderers = [mUpRenderer,mDownRenderer,mOverRenderer,mDisabledRenderer,mSelectedRenderer];
         if(param2.hasOwnProperty("hit"))
         {
            mHitArea = param2.hit;
            mHitArea.visible = false;
            mHitArea.mouseEnabled = false;
            param2.hitArea = mHitArea;
         }
         if(param2.hasOwnProperty("label"))
         {
            mLabel = param2.label;
            mLabel.mouseEnabled = false;
         }
         super(param1,param2,param3);
         mFiltersBeforeRollover = [];
         mDisableEventPropogation = param4;
      }
      
      public function allowEventPropogation() : void
      {
         mDisableEventPropogation = false;
      }
      
      public function get label() : TextField
      {
         return mLabel;
      }
      
      public function set label(param1:TextField) : void
      {
         mLabel = param1;
         mLabel.mouseEnabled = false;
      }
      
      public function flattenLabelToBitmap() : void
      {
         var _loc1_:BitmapData = new BitmapData(mLabel.width,mLabel.height,true,0);
         _loc1_.draw(mLabel);
         var _loc2_:Bitmap = new Bitmap(_loc1_,"auto",true);
         _loc2_.transform.matrix = mLabel.transform.matrix;
         mLabel.parent.addChild(_loc2_);
         mLabel.parent.removeChild(mLabel);
         mLabel = null;
      }
      
      public function get selected() : Boolean
      {
         return mSelected;
      }
      
      public function set selected(param1:Boolean) : void
      {
         mSelected = param1;
         if(mSelectedFilter)
         {
            mSelectedState.filters = param1 ? [mSelectedFilter] : [];
         }
         this.showState(upState);
      }
      
      public function set rolloverFilter(param1:GlowFilter) : void
      {
         mRolloverFilter = param1;
      }
      
      public function get rolloverFilter() : GlowFilter
      {
         return mRolloverFilter;
      }
      
      public function set selectedFilter(param1:GlowFilter) : void
      {
         mSelectedFilter = param1;
      }
      
      public function get selectedFilter() : GlowFilter
      {
         return mSelectedFilter;
      }
      
      public function set pressCallback(param1:Function) : void
      {
         mPressCallback = param1;
      }
      
      public function set pressCallbackThis(param1:Function) : void
      {
         var value:Function = param1;
         var _this:UIButton = this;
         mPressCallback = function():void
         {
            value(_this);
         };
      }
      
      public function set releaseCallback(param1:Function) : void
      {
         mReleaseCallback = param1;
      }
      
      public function set releaseCallbackThis(param1:Function) : void
      {
         var value:Function = param1;
         var _this:UIButton = this;
         mReleaseCallback = function():void
         {
            value(_this);
         };
      }
      
      public function get releaseCallback() : Function
      {
         return mReleaseCallback;
      }
      
      public function set dragReleaseCallback(param1:Function) : void
      {
         mDragReleaseCallback = param1;
      }
      
      public function get dragReleaseCallback() : Function
      {
         return mDragReleaseCallback;
      }
      
      public function set enterCallback(param1:Function) : void
      {
         mEnterCallback = param1;
      }
      
      public function set pressRollOutCallback(param1:Function) : void
      {
         mPressRollOutCallback = param1;
      }
      
      public function set rollOverCallback(param1:Function) : void
      {
         mRollOverCallback = param1;
      }
      
      public function set rollOutCallback(param1:Function) : void
      {
         mRollOutCallback = param1;
      }
      
      public function get draggable() : Boolean
      {
         return mDraggable;
      }
      
      public function set draggable(param1:Boolean) : void
      {
         mDraggable = param1;
      }
      
      public function set rollOverCursor(param1:String) : void
      {
         mRollOverCursor = param1;
      }
      
      public function click() : void
      {
         onRelease(new MouseEvent("click"));
      }
      
      override protected function addListeners() : void
      {
         super.addListeners();
         mRoot.addEventListener("mouseDown",onPress);
         mRoot.addEventListener("keyDown",onKey);
      }
      
      protected function popRollOverMouseCursor() : void
      {
         if(mRollOverCursor && mRollOverCursorKey > 0)
         {
            mFacade.mouseCursorManager.popMouseCursor(mRollOverCursorKey);
            mRollOverCursorKey = 0;
         }
      }
      
      override protected function removeListeners() : void
      {
         super.removeListeners();
         mRoot.removeEventListener("mouseDown",onPress);
         mRoot.removeEventListener("keyDown",onKey);
         mRoot.removeEventListener("mouseUp",onMouseUp);
         mFacade.stageRef.removeEventListener("mouseUp",onMouseUp);
         mFacade.stageRef.removeEventListener("mouseLeave",onStageMouseLeave);
      }
      
      override public function set enabled(param1:Boolean) : void
      {
         super.enabled = param1;
         mRoot.buttonMode = mEnabled;
         mRoot.tabEnabled = false;
         showState(mEnabled ? upState : 3);
         mMouseDown = false;
         if(!param1)
         {
            if(mRolloverFilter)
            {
               mRoot.filters = mFiltersBeforeRollover;
               mFiltersBeforeRollover = null;
            }
            popRollOverMouseCursor();
         }
      }
      
      override public function destroy() : void
      {
         popRollOverMouseCursor();
         mStates = null;
         for each(var _loc1_ in mRenderers)
         {
            if(_loc1_)
            {
               _loc1_.destroy();
            }
         }
         mRenderers = null;
         mPressCallback = null;
         mReleaseCallback = null;
         mLabel = null;
         mDisabledRenderer = null;
         mDisabledState = null;
         mDownRenderer = null;
         mDownState = null;
         mUpRenderer = null;
         mUpState = null;
         mOverRenderer = null;
         mOverState = null;
         mSelectedRenderer = null;
         mSelectedState = null;
         super.destroy();
      }
      
      protected function showState(param1:uint) : void
      {
         for each(var _loc3_ in mStates)
         {
            if(_loc3_)
            {
               _loc3_.visible = false;
            }
         }
         for each(var _loc2_ in mRenderers)
         {
            if(_loc2_)
            {
               _loc2_.stop();
            }
         }
         if(mStates && mStates[param1])
         {
            mStates[param1].visible = true;
         }
         if(mRenderers && mRenderers[param1])
         {
            mRenderers[param1].play(0,true);
         }
      }
      
      protected function onKey(param1:KeyboardEvent) : void
      {
         param1.stopImmediatePropagation();
         if(param1.keyCode == 13)
         {
            if(mEnterCallback != null)
            {
               mEnterCallback();
            }
         }
      }
      
      protected function onPress(param1:MouseEvent) : void
      {
         if(mDisableEventPropogation)
         {
            param1.stopImmediatePropagation();
         }
         mRoot.addEventListener("mouseUp",onMouseUp);
         mFacade.stageRef.addEventListener("mouseUp",onMouseUp);
         mFacade.stageRef.addEventListener("mouseLeave",onStageMouseLeave);
         if(mDraggable)
         {
            mFacade.stageRef.addEventListener("mouseMove",onMouseMove);
         }
         mMouseDown = true;
         showState(downState);
         if(mDraggable)
         {
            mDragged = false;
         }
         if(mPressCallback != null)
         {
            mPressCallback();
         }
      }
      
      protected function onMouseMove(param1:MouseEvent) : void
      {
         if(mDraggable)
         {
            mFacade.stageRef.removeEventListener("mouseMove",onMouseMove);
            startDrag();
         }
      }
      
      override protected function showTooltip(param1:GameClock = null) : void
      {
         if(mDragged)
         {
            return;
         }
         super.showTooltip(param1);
      }
      
      protected function startDrag() : void
      {
         this.hideTooltip();
         mDragged = true;
         mDragStartPos = new Point(mRoot.x,mRoot.y);
         mDragStartParent = mRoot.parent;
         var _loc1_:Point = mRoot.localToGlobal(new Point(0,0));
         mFacade.sceneGraphManager.addChild(mRoot,75);
         mRoot.x = _loc1_.x;
         mRoot.y = _loc1_.y;
         mRoot.startDrag(false,mDragBounds);
      }
      
      public function set dragBounds(param1:Rectangle) : void
      {
         mDragBounds = param1;
      }
      
      protected function onMouseUp(param1:MouseEvent) : void
      {
         var _loc2_:Boolean = false;
         var _loc4_:DisplayObject = null;
         var _loc5_:MovieClip = null;
         var _loc3_:DisplayObject = null;
         if(mDisableEventPropogation)
         {
            param1.stopImmediatePropagation();
         }
         if(!mRoot)
         {
            return;
         }
         if(mDraggable)
         {
            mFacade.stageRef.removeEventListener("mouseMove",onMouseMove);
         }
         mRoot.removeEventListener("mouseUp",onMouseUp);
         mFacade.stageRef.removeEventListener("mouseUp",onMouseUp);
         mFacade.stageRef.removeEventListener("mouseLeave",onStageMouseLeave);
         if(!mEnabled || !mMouseDown)
         {
            return;
         }
         if(mDraggable && mDragged)
         {
            mDragged = false;
            _loc2_ = false;
            this.stopDrag();
            _loc4_ = mRoot.dropTarget;
            while(_loc4_ != null)
            {
               _loc5_ = _loc4_ as MovieClip;
               if(_loc5_ != null)
               {
                  if(!_loc5_.mouseEnabled)
                  {
                     _loc4_.visible = false;
                     mRoot.startDrag(true);
                     mRoot.stopDrag();
                     _loc4_.visible = true;
                     _loc4_ = mRoot.dropTarget;
                     continue;
                  }
                  if(_loc5_.hasOwnProperty("UIObject"))
                  {
                     if(UIObject(_loc5_.UIObject).handleDrop(this))
                     {
                        _loc2_ = true;
                        break;
                     }
                  }
               }
               _loc4_ = _loc4_.parent;
            }
            if(!_loc2_)
            {
               resetDrag();
            }
            onDragRelease(param1);
         }
         else
         {
            _loc3_ = param1.target as DisplayObject;
            while(_loc3_ != null)
            {
               if(_loc3_ == mRoot)
               {
                  onRelease(param1);
                  return;
               }
               _loc3_ = _loc3_.parent;
            }
            onReleaseOutside(param1);
         }
      }
      
      protected function stopDrag() : void
      {
         mRoot.stopDrag();
      }
      
      protected function resetDrag() : void
      {
         mDragStartParent.addChild(mRoot);
         this.bringToFront();
         mRoot.x = mDragStartPos.x;
         mRoot.y = mDragStartPos.y;
         mDragStartParent = null;
         mDragStartPos = null;
      }
      
      protected function onReleaseOutside(param1:MouseEvent) : void
      {
         mMouseDown = false;
      }
      
      protected function onRelease(param1:MouseEvent) : void
      {
         mMouseDown = false;
         showState(overState);
         if(mReleaseCallback != null)
         {
            mReleaseCallback();
         }
      }
      
      protected function onDragRelease(param1:MouseEvent) : void
      {
         if(!mRoot)
         {
            return;
         }
         mMouseDown = false;
         showState(overState);
         if(mDragReleaseCallback != null)
         {
            mDragReleaseCallback();
         }
      }
      
      override protected function onRollOver(param1:MouseEvent) : void
      {
         super.onRollOver(param1);
         if(mMouseDown)
         {
            showState(downState);
         }
         else
         {
            showState(overState);
         }
         if(mRolloverFilter)
         {
            mFiltersBeforeRollover = mRoot.filters.slice();
            mRoot.filters = [mRolloverFilter];
         }
         if(mRollOverCallback != null)
         {
            mRollOverCallback();
         }
         if(mRollOverCursor)
         {
            mRollOverCursorKey = mFacade.mouseCursorManager.pushMouseCursor(mRollOverCursor,true);
         }
      }
      
      protected function get downState() : uint
      {
         return mSelected ? 4 : 1;
      }
      
      protected function get upState() : uint
      {
         return mSelected ? 4 : 0;
      }
      
      protected function get overState() : uint
      {
         return mSelected ? 4 : 2;
      }
      
      override protected function onRollOut(param1:MouseEvent) : void
      {
         super.onRollOut(param1);
         showState(upState);
         if(mMouseDown)
         {
            if(mPressRollOutCallback != null)
            {
               mPressRollOutCallback();
            }
         }
         if(mRolloverFilter)
         {
            mRoot.filters = mFiltersBeforeRollover;
            mFiltersBeforeRollover = null;
         }
         if(mRollOutCallback != null)
         {
            mRollOutCallback();
         }
         popRollOverMouseCursor();
      }
      
      protected function onStageMouseLeave(param1:Event) : void
      {
         hideTooltip();
         mRoot.removeEventListener("mouseUp",onMouseUp);
         mFacade.stageRef.removeEventListener("mouseUp",onMouseUp);
         mFacade.stageRef.removeEventListener("mouseLeave",onStageMouseLeave);
         showState(upState);
      }
   }
}

