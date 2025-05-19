package Brain.UI
{
   import Brain.Clock.GameClock;
   import Brain.Facade.Facade;
   import Brain.Logger.Logger;
   import Brain.WorkLoop.DoLater;
   import flash.display.DisplayObject;
   import flash.display.MovieClip;
   import flash.events.MouseEvent;
   import flash.geom.Point;
   import flash.geom.Rectangle;
   import flash.text.TextField;
   
   public class UIObject
   {
      
      private static const DEFAULT_TOOLTIP_DELAY:Number = 0;
      
      private static const DEFAULT_TOOLTIP_LAYER:int = 107;
      
      protected var mEnabled:Boolean = true;
      
      protected var mFacade:Facade;
      
      protected var mRoot:MovieClip;
      
      protected var mTooltip:MovieClip;
      
      protected var mTooltipLabel:TextField;
      
      protected var mTooltipPos:Point = new Point();
      
      protected var mTooltipDelay:Number = 0;
      
      protected var mTooltipTask:DoLater;
      
      protected var mTooltipLayer:Number = 107;
      
      protected var mDontKillMyChildren:Boolean;
      
      protected var mIsParentedToStage:Boolean;
      
      public function UIObject(param1:Facade, param2:MovieClip, param3:int = 0, param4:Boolean = false)
      {
         super();
         mFacade = param1;
         mRoot = param2;
         if(mRoot.hasOwnProperty("tooltip"))
         {
            if(param3 != 0)
            {
               mTooltipLayer = param3;
            }
            this.tooltip = mRoot.tooltip;
         }
         try
         {
            mRoot.UIObject = this;
         }
         catch(errObject:Error)
         {
         }
         this.enabled = true;
         mDontKillMyChildren = param4;
         mIsParentedToStage = false;
      }
      
      public static function scaleToFit(param1:DisplayObject, param2:Number) : void
      {
         param1.scaleX = param1.scaleY = 1;
         var _loc4_:Number = param1.height > param1.width ? param1.height : param1.width;
         var _loc5_:Number = param2 / _loc4_;
         param1.scaleX = param1.scaleY = _loc5_;
         var _loc3_:Rectangle = param1.getBounds(param1);
         param1.x = -(_loc3_.left + _loc3_.width * 0.5);
         param1.y = -(_loc3_.top + _loc3_.height * 0.5);
      }
      
      public function handleDrop(param1:UIObject) : Boolean
      {
         return false;
      }
      
      public function set visible(param1:Boolean) : void
      {
         mRoot.visible = param1;
      }
      
      public function get visible() : Boolean
      {
         return mRoot.visible;
      }
      
      public function get enabled() : Boolean
      {
         return mEnabled;
      }
      
      public function set enabled(param1:Boolean) : void
      {
         mEnabled = param1;
         hideTooltip();
         removeListeners();
         if(mEnabled)
         {
            addListeners();
         }
      }
      
      protected function addListeners() : void
      {
         mRoot.addEventListener("rollOver",onRollOver);
         mRoot.addEventListener("rollOut",onRollOut);
      }
      
      protected function removeListeners() : void
      {
         mRoot.removeEventListener("rollOver",onRollOver);
         mRoot.removeEventListener("rollOut",onRollOut);
      }
      
      protected function onRollOver(param1:MouseEvent) : void
      {
         hideTooltip();
         if(mTooltip)
         {
            if(mTooltipDelay == 0)
            {
               showTooltip();
            }
            else
            {
               mTooltipTask = mFacade.preRenderWorkManager.doLater(mTooltipDelay,showTooltip);
            }
         }
      }
      
      protected function onRollOut(param1:MouseEvent) : void
      {
         hideTooltip();
      }
      
      public function bringToFront() : void
      {
         mRoot.parent.setChildIndex(mRoot,mRoot.parent.numChildren - 1);
      }
      
      public function sendToBack() : void
      {
         mRoot.parent.setChildIndex(mRoot,0);
      }
      
      public function detach() : void
      {
         if(mRoot.parent)
         {
            mRoot.parent.removeChild(mRoot);
         }
      }
      
      public function get root() : MovieClip
      {
         return mRoot;
      }
      
      public function set tooltipPos(param1:Point) : void
      {
         mTooltipPos = param1;
      }
      
      public function setTooltipToBeParentedToStage() : void
      {
         mIsParentedToStage = true;
      }
      
      public function get tooltip() : MovieClip
      {
         return mTooltip;
      }
      
      public function get tooltipLabel() : TextField
      {
         return mTooltipLabel;
      }
      
      public function set tooltip(param1:MovieClip) : void
      {
         setTooltip(param1);
      }
      
      public function setTooltip(param1:*) : void
      {
         hideTooltip();
         if(param1 is MovieClip)
         {
            mTooltip = param1 as MovieClip;
            mTooltipLabel = null;
         }
         else if(param1 is TextField)
         {
            mTooltip = new MovieClip();
            mTooltipLabel = param1 as TextField;
            mTooltip.addChild(mTooltipLabel);
         }
         else if(param1 is String)
         {
            mTooltip = new MovieClip();
            mTooltipLabel = new TextField();
            mTooltipLabel.text = param1 as String;
            mTooltipLabel.autoSize = "center";
            mTooltipLabel.background = true;
            mTooltipLabel.backgroundColor = 0;
            mTooltipLabel.textColor = 16777215;
            mTooltip.addChild(mTooltipLabel);
         }
         else if(param1 == null)
         {
            if(mTooltip && mTooltip.parent)
            {
               mTooltip.parent.removeChild(mTooltip);
            }
            if(mTooltipLabel && mTooltipLabel.parent)
            {
               mTooltipLabel.parent.removeChild(mTooltipLabel);
            }
            mTooltipLabel = null;
            mTooltip = null;
         }
         else
         {
            Logger.error("invalid tooltip type: " + param1.toString());
         }
         if(mTooltip)
         {
            mTooltip.mouseChildren = false;
            mTooltip.mouseEnabled = false;
            this.tooltipPos = new Point(mTooltip.x,mTooltip.y);
            if(mTooltip.parent)
            {
               mTooltip.parent.removeChild(mTooltip);
            }
         }
      }
      
      public function set tooltipDelay(param1:Number) : void
      {
         mTooltipDelay = param1;
      }
      
      protected function hideTooltip() : void
      {
         if(mTooltipTask)
         {
            mTooltipTask.destroy();
         }
         if(mTooltip && mTooltip.parent)
         {
            mTooltip.parent.removeChild(mTooltip);
         }
      }
      
      protected function showTooltip(param1:GameClock = null) : void
      {
         var _loc2_:Point = null;
         if(mTooltip)
         {
            if(!mIsParentedToStage)
            {
               _loc2_ = root.localToGlobal(mTooltipPos);
               mTooltip.x = _loc2_.x;
               mTooltip.y = _loc2_.y;
            }
            else
            {
               mTooltip.x = mTooltipPos.x;
               mTooltip.y = mTooltipPos.y;
            }
            mFacade.sceneGraphManager.addChild(mTooltip,mTooltipLayer);
         }
      }
      
      public function set dontKillMyChildren(param1:Boolean) : void
      {
         mDontKillMyChildren = param1;
      }
      
      public function destroy() : void
      {
         if(mRoot != null)
         {
            if(mRoot.hasOwnProperty("UIObject"))
            {
               mRoot.UIObject = null;
            }
            hideTooltip();
            removeListeners();
            if(!mDontKillMyChildren)
            {
               while(mRoot.numChildren > 0)
               {
                  mRoot.removeChildAt(0);
               }
            }
            mRoot = null;
            mFacade = null;
         }
      }
   }
}

