package Brain.UI
{
   import Brain.Facade.Facade;
   import flash.display.MovieClip;
   import flash.text.TextField;
   
   public class UIPopup extends UIObject
   {
      
      public static const YES:uint = 1;
      
      public static const NO:uint = 2;
      
      public static const OK:uint = 4;
      
      public static const CANCEL:uint = 8;
      
      protected var mButtonFlags:uint = 4;
      
      protected var mModal:Boolean = true;
      
      protected var mCurtainActive:Boolean = false;
      
      protected var mCloseCallback:Function;
      
      protected var mText:String = "";
      
      protected var mTextField:TextField;
      
      protected var mYesButton:UIButton;
      
      protected var mNoButton:UIButton;
      
      protected var mOkButton:UIButton;
      
      protected var mCancelButton:UIButton;
      
      public function UIPopup(param1:Facade)
      {
         var _loc2_:MovieClip = new MovieClip();
         super(param1,_loc2_);
         if(mModal)
         {
            makeCurtain();
         }
         mFacade.sceneGraphManager.addChild(mRoot,105);
      }
      
      public static function show(param1:Facade, param2:String = "", param3:uint = 4, param4:Boolean = true, param5:Function = null) : UIPopup
      {
         var _loc6_:UIPopup = new UIPopup(param1);
         _loc6_.mText = param2;
         _loc6_.mButtonFlags = param3;
         _loc6_.mModal = param4;
         _loc6_.mCloseCallback = param5;
         return _loc6_;
      }
      
      override public function destroy() : void
      {
         removeCurtain();
      }
      
      public function set callback(param1:Function) : void
      {
         mCloseCallback = param1;
      }
      
      protected function makeCurtain() : void
      {
         if(!mCurtainActive)
         {
            mFacade.sceneGraphManager.showPopupCurtain();
            mCurtainActive = true;
         }
      }
      
      protected function removeCurtain() : void
      {
         if(mCurtainActive)
         {
            mFacade.sceneGraphManager.removePopupCurtain();
            mCurtainActive = false;
         }
      }
      
      protected function setupUI(param1:Class) : void
      {
         var popupClass:Class = param1;
         var popup:MovieClip = new popupClass();
         mRoot.addChild(popup);
         mTextField = TextField(popup.popupText);
         mTextField.text = mText;
         mYesButton = new UIButton(mFacade,popup.yesButton);
         mNoButton = new UIButton(mFacade,popup.noButton);
         mOkButton = new UIButton(mFacade,popup.okButton);
         mCancelButton = new UIButton(mFacade,popup.cancelButton);
         mYesButton.label.text = "Yes";
         mNoButton.label.text = "No";
         mOkButton.label.text = "OK";
         mCancelButton.label.text = "Cancel";
         mYesButton.releaseCallback = function():void
         {
            onClose(1);
         };
         mNoButton.releaseCallback = function():void
         {
            onClose(2);
         };
         mOkButton.releaseCallback = function():void
         {
            onClose(4);
         };
         mCancelButton.releaseCallback = function():void
         {
            onClose(8);
         };
         mYesButton.root.visible = (mButtonFlags & 1) != 0;
         mNoButton.root.visible = (mButtonFlags & 2) != 0;
         mOkButton.root.visible = (mButtonFlags & 4) != 0;
         mCancelButton.root.visible = (mButtonFlags & 8) != 0;
      }
      
      protected function onClose(param1:uint) : void
      {
         if(mCloseCallback != null)
         {
            mCloseCallback(param1);
         }
         this.destroy();
      }
   }
}

