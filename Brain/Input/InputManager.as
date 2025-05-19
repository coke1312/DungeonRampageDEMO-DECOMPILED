package Brain.Input
{
   import Brain.Facade.Facade;
   import Brain.MouseScrollPlugin.CustomMouseWheelEvent;
   import flash.events.Event;
   import flash.events.KeyboardEvent;
   import flash.events.MouseEvent;
   
   public class InputManager
   {
      
      public static const STAGE_KEY_DOWN:String = "STAGE_KEY_DOWN";
      
      public static const STAGE_KEY_UP:String = "STAGE_KEY_UP";
      
      private var mEnabled:Boolean = false;
      
      private var mKeysDown:Vector.<Boolean> = new Vector.<Boolean>(256);
      
      private var mNumberOfKeysDown:int = 0;
      
      private var mKeysPressed:Vector.<int> = new Vector.<int>(256);
      
      private var mKeysReleased:Vector.<int> = new Vector.<int>(256);
      
      private var mNumberOfKeysPressed:int = 0;
      
      private var mNumberOfKeysReleased:int = 0;
      
      private var mMouseWheelDelta:int = 0;
      
      public var lastKey:int;
      
      public var mouseDown:Boolean = false;
      
      public var mouseUp:Boolean = true;
      
      public var mousePressed:Boolean = false;
      
      public var mouseReleased:Boolean = false;
      
      public var mouseWheel:Boolean = false;
      
      private var mFacade:Facade;
      
      public var disableInputs:Boolean;
      
      public function InputManager(param1:Facade)
      {
         super();
         mFacade = param1;
         enable();
      }
      
      public function get mouseWheelDelta() : int
      {
         if(mouseWheel)
         {
            mouseWheel = false;
            return mMouseWheelDelta;
         }
         return 0;
      }
      
      public function get mouseX() : int
      {
         return mFacade.stageRef.mouseX;
      }
      
      public function get mouseY() : int
      {
         return mFacade.stageRef.mouseY;
      }
      
      public function get mouseFlashX() : int
      {
         return mFacade.stageRef.mouseX;
      }
      
      public function get mouseFlashY() : int
      {
         return mFacade.stageRef.mouseY;
      }
      
      public function check(param1:*) : Boolean
      {
         return param1 < 0 ? mNumberOfKeysDown > 0 : mKeysDown[param1];
      }
      
      public function pressed(param1:*) : Boolean
      {
         return param1 < 0 ? mNumberOfKeysPressed : mKeysPressed.indexOf(param1) >= 0;
      }
      
      public function released(param1:*) : Boolean
      {
         return param1 < 0 ? mNumberOfKeysReleased : mKeysReleased.indexOf(param1) >= 0;
      }
      
      protected function enable() : void
      {
         mFacade.stageRef.addEventListener("keyDown",onKeyDown);
         mFacade.stageRef.addEventListener("keyUp",onKeyUp);
         mFacade.stageRef.addEventListener("mouseDown",onMouseDown);
         mFacade.stageRef.addEventListener("mouseUp",onMouseUp);
         mFacade.stageRef.addEventListener("onMove",onMouseWheel);
         mFacade.stageRef.addEventListener("mouseLeave",onMouseLeave);
         mFacade.stageRef.addEventListener("deactivate",onDeactivate);
      }
      
      public function flush() : void
      {
         while(mNumberOfKeysPressed--)
         {
            mKeysPressed[mNumberOfKeysPressed] = -1;
         }
         mNumberOfKeysPressed = 0;
         while(mNumberOfKeysReleased--)
         {
            mKeysReleased[mNumberOfKeysReleased] = -1;
         }
         mNumberOfKeysReleased = 0;
         mousePressed = false;
         mouseReleased = false;
      }
      
      public function clear() : void
      {
         flush();
         var _loc1_:int = int(mKeysDown.length);
         while(_loc1_--)
         {
            mKeysDown[_loc1_] = false;
         }
         mNumberOfKeysDown = 0;
      }
      
      private function onKeyDown(param1:KeyboardEvent = null) : void
      {
         var _loc2_:int = 0;
         if(!disableInputs)
         {
            _loc2_ = int(lastKey = param1.keyCode);
            if(!mKeysDown[_loc2_])
            {
               mKeysDown[_loc2_] = true;
               mNumberOfKeysDown++;
               mKeysPressed[mNumberOfKeysPressed++] = _loc2_;
            }
         }
      }
      
      private function onKeyUp(param1:KeyboardEvent) : void
      {
         var _loc2_:int = 0;
         if(!disableInputs)
         {
            _loc2_ = int(param1.keyCode);
            if(mKeysDown[_loc2_])
            {
               mKeysDown[_loc2_] = false;
               mNumberOfKeysDown--;
               mKeysReleased[mNumberOfKeysReleased++] = _loc2_;
            }
         }
      }
      
      private function onDeactivate(param1:Event) : void
      {
         clear();
      }
      
      private function onMouseLeave(param1:Event) : void
      {
         clear();
      }
      
      public function onMouseDown(param1:MouseEvent) : void
      {
         if(!disableInputs)
         {
            mouseDown = true;
            mouseUp = false;
            mousePressed = true;
         }
      }
      
      public function onMouseUp(param1:MouseEvent) : void
      {
         if(!disableInputs)
         {
            mouseUp = true;
            mouseDown = false;
            mouseReleased = true;
         }
      }
      
      private function onMouseWheel(param1:CustomMouseWheelEvent) : void
      {
         if(!disableInputs)
         {
            mouseWheel = true;
            mMouseWheelDelta = param1.delta;
         }
      }
      
      public function enableControls() : void
      {
         clear();
         disableInputs = false;
      }
      
      public function disableControls() : void
      {
         clear();
         disableInputs = true;
      }
   }
}

