package Brain.MouseCursor
{
   import Brain.Facade.Facade;
   import Brain.Logger.Logger;
   import flash.display.MovieClip;
   import flash.events.MouseEvent;
   import flash.ui.Mouse;
   import org.as3commons.collections.Map;
   
   public class MouseCursorManager
   {
      
      private var mCursorTypes:Map;
      
      private var mCurrentCursor:String;
      
      private var mIsTransient:Boolean;
      
      private var mCursorClip:MovieClip;
      
      private var mCursorStack:Array;
      
      private var mFacade:Facade;
      
      private var mNextKey:uint;
      
      private var mDisabled:Boolean;
      
      public function MouseCursorManager(param1:Facade)
      {
         super();
         mFacade = param1;
         mCursorTypes = new Map();
         mNextKey = 1;
         mIsTransient = false;
         mDisabled = false;
         mCursorStack = [];
         registerBuiltInTypes();
         setMouseCursor("auto");
      }
      
      public function set disable(param1:Boolean) : void
      {
         mDisabled = param1;
         if(mDisabled)
         {
            if(mCursorClip)
            {
               mFacade.stageRef.removeEventListener("mouseOver",onMouseOver);
               mFacade.stageRef.removeEventListener("mouseMove",onMouseMove);
               mFacade.stageRef.removeEventListener("mouseOut",onMouseOut);
               mFacade.sceneGraphManager.removeChild(mCursorClip);
            }
            setBuiltInCursor("auto");
         }
      }
      
      private function registerBuiltInTypes() : void
      {
         var _loc1_:CursorType = new CursorType(null,true);
         mCursorTypes.add("arrow",_loc1_);
         mCursorTypes.add("auto",_loc1_);
         mCursorTypes.add("button",_loc1_);
         mCursorTypes.add("hand",_loc1_);
         mCursorTypes.add("ibeam",_loc1_);
      }
      
      public function registerMouseCursor(param1:MovieClip, param2:String, param3:Boolean = false) : void
      {
         var _loc4_:CursorType = null;
         if(!param1)
         {
            Logger.error("Trying to register a mouse cursor with a null MovieClip.");
            return;
         }
         param1.mouseChildren = false;
         param1.mouseEnabled = false;
         if(mCursorTypes.hasKey(param2))
         {
            if(!param3)
            {
               return;
            }
            _loc4_ = mCursorTypes.itemFor(param2);
            _loc4_.isBuiltIn = false;
            _loc4_.root = param1;
            if(param2 == mCurrentCursor)
            {
               setMouseCursor(param2);
            }
         }
         else
         {
            _loc4_ = new CursorType(param1,false);
            mCursorTypes.add(param2,_loc4_);
         }
      }
      
      private function onMouseMove(param1:MouseEvent) : void
      {
         mCursorClip.x = param1.stageX;
         mCursorClip.y = param1.stageY;
         param1.updateAfterEvent();
      }
      
      private function onMouseOver(param1:MouseEvent) : void
      {
         if(mCursorClip)
         {
            mCursorClip.visible = true;
            mFacade.stageRef.removeEventListener("mouseOver",onMouseOver);
         }
      }
      
      private function onMouseOut(param1:MouseEvent) : void
      {
         if(mCursorClip && mCursorClip.visible)
         {
            mCursorClip.visible = false;
            mFacade.stageRef.addEventListener("mouseOver",onMouseOver);
            mFacade.stageRef.removeEventListener("mouseOut",onMouseOut);
         }
      }
      
      private function setBuiltInCursor(param1:String) : void
      {
         Mouse.show();
         Mouse.cursor = param1;
         mCursorClip = null;
      }
      
      private function setCustomCursor(param1:CursorType) : void
      {
         Mouse.hide();
         mCursorClip = param1.root;
         mCursorClip.visible = true;
         mCursorClip.mouseChildren = false;
         mCursorClip.mouseEnabled = false;
         mFacade.sceneGraphManager.addChild(mCursorClip,200);
         param1.root.x = param1.root.stage.mouseX;
         param1.root.y = param1.root.stage.mouseY;
         mFacade.stageRef.addEventListener("mouseMove",onMouseMove);
         mFacade.stageRef.addEventListener("mouseOut",onMouseOut);
      }
      
      public function pushMouseCursor(param1:String, param2:Boolean = false) : uint
      {
         return 0;
      }
      
      public function popMouseCursor(param1:uint = 0) : void
      {
      }
      
      public function setMouseCursor(param1:String) : void
      {
         var _loc2_:* = null;
      }
   }
}

import flash.display.MovieClip;

class CursorType
{
   
   public var isBuiltIn:Boolean;
   
   public var root:MovieClip;
   
   public function CursorType(param1:MovieClip, param2:Boolean)
   {
      super();
      root = param1;
      isBuiltIn = param2;
   }
}
