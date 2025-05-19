package Brain.UI
{
   import Brain.Facade.Facade;
   import flash.display.MovieClip;
   import flash.events.Event;
   import flash.events.FocusEvent;
   import flash.events.KeyboardEvent;
   import flash.events.MouseEvent;
   import flash.text.TextField;
   
   public class UIInputText extends UIObject
   {
      
      protected var mTextField:TextField;
      
      private var mDefaultText:String;
      
      private var mDefaultTextColor:uint = 8947848;
      
      private var mNormalTextColor:uint = 0;
      
      private var mShowingDefaultText:Boolean = false;
      
      protected var mChangeCallback:Function;
      
      protected var mEnterCallback:Function;
      
      protected var mCancelCallback:Function;
      
      public function UIInputText(param1:Facade, param2:MovieClip)
      {
         mTextField = param2.textField;
         super(param1,param2);
         mTextField.addEventListener("mouseDown",onPress);
         mTextField.addEventListener("change",onChange);
         mTextField.addEventListener("keyDown",onKeyDown);
         mTextField.addEventListener("keyUp",onKeyUp);
         mTextField.addEventListener("focusIn",onFocusIn);
         mTextField.addEventListener("focusOut",onFocusOut);
      }
      
      protected function onPress(param1:MouseEvent) : void
      {
         param1.stopImmediatePropagation();
         mTextField.addEventListener("mouseUp",onRelease);
      }
      
      protected function onRelease(param1:MouseEvent) : void
      {
         param1.stopImmediatePropagation();
         mTextField.removeEventListener("mouseUp",onRelease);
      }
      
      public function set defaultTextColor(param1:uint) : void
      {
         mDefaultTextColor = param1;
         if(mShowingDefaultText)
         {
            mTextField.textColor = mDefaultTextColor;
         }
      }
      
      public function set normalTextColor(param1:uint) : void
      {
         mNormalTextColor = param1;
         if(!mShowingDefaultText)
         {
            mTextField.textColor = mNormalTextColor;
         }
      }
      
      public function set defaultText(param1:String) : void
      {
         mDefaultText = param1;
         mTextField.text = mDefaultText;
         mTextField.textColor = mDefaultTextColor;
         mShowingDefaultText = true;
      }
      
      public function get text() : String
      {
         if(mShowingDefaultText)
         {
            return "";
         }
         return mTextField.text;
      }
      
      public function set text(param1:String) : void
      {
         mTextField.text = param1;
      }
      
      protected function onFocusIn(param1:FocusEvent) : void
      {
         if(mShowingDefaultText)
         {
            this.clear();
            mShowingDefaultText = false;
            mTextField.textColor = mNormalTextColor;
         }
      }
      
      protected function onFocusOut(param1:FocusEvent) : void
      {
      }
      
      public function get textField() : TextField
      {
         return mTextField;
      }
      
      protected function onKeyDown(param1:KeyboardEvent) : void
      {
         if(param1.keyCode == 13 && mEnterCallback != null && !mShowingDefaultText)
         {
            if(mTextField)
            {
               mEnterCallback(mTextField.text);
            }
            param1.stopPropagation();
         }
         else if(param1.keyCode == 27 && mCancelCallback != null)
         {
            mCancelCallback();
            param1.stopPropagation();
         }
         else if(!(param1.ctrlKey && (param1.keyCode == 86 || param1.keyCode == 67 || param1.keyCode == 88)))
         {
            param1.stopPropagation();
         }
      }
      
      protected function onKeyUp(param1:KeyboardEvent) : void
      {
         if(!(param1.ctrlKey && (param1.keyCode == 86 || param1.keyCode == 67 || param1.keyCode == 88)))
         {
            param1.stopPropagation();
         }
      }
      
      protected function onChange(param1:Event) : void
      {
         if(mChangeCallback != null)
         {
            mChangeCallback(mTextField.text);
         }
      }
      
      public function clear() : void
      {
         mTextField.text = "";
         if(mChangeCallback != null)
         {
            mChangeCallback("");
         }
      }
      
      public function set changeCallback(param1:Function) : void
      {
         mChangeCallback = param1;
      }
      
      public function set enterCallback(param1:Function) : void
      {
         mEnterCallback = param1;
      }
      
      public function set cancelCallback(param1:Function) : void
      {
         mCancelCallback = param1;
      }
      
      override public function set enabled(param1:Boolean) : void
      {
         super.enabled = param1;
         mTextField.tabEnabled = param1;
      }
      
      override public function destroy() : void
      {
         super.destroy();
         mTextField.removeEventListener("mouseDown",onPress);
         mTextField.removeEventListener("mouseUp",onRelease);
         mTextField.removeEventListener("change",onChange);
         mTextField.removeEventListener("keyDown",onKeyDown);
         mTextField.removeEventListener("keyUp",onKeyUp);
         mTextField.removeEventListener("focusIn",onFocusIn);
         mTextField.removeEventListener("focusOut",onFocusOut);
         mTextField = null;
         mChangeCallback = null;
         mEnterCallback = null;
         mCancelCallback = null;
      }
   }
}

