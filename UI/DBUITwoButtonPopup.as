package UI
{
   import Brain.AssetRepository.SwfAsset;
   import Brain.UI.UIButton;
   import DBGlobals.DBGlobal;
   import Facade.DBFacade;
   
   public class DBUITwoButtonPopup extends DBUIPopup
   {
      
      protected var mLeftButton:UIButton;
      
      protected var mLeftCallback:Function;
      
      protected var mLeftText:String;
      
      protected var mRightButton:UIButton;
      
      protected var mRightCallback:Function;
      
      protected var mRightText:String;
      
      public function DBUITwoButtonPopup(param1:DBFacade, param2:String, param3:*, param4:String, param5:Function, param6:String, param7:Function, param8:Boolean = true, param9:Function = null)
      {
         mLeftText = param4;
         mLeftCallback = param5;
         mRightText = param6;
         mRightCallback = param7;
         super(param1,param2,param3,param8,useCurtain(),param9);
      }
      
      override public function destroy() : void
      {
         if(mLeftButton)
         {
            mLeftButton.destroy();
            mLeftButton = null;
         }
         if(mRightButton)
         {
            mRightButton.destroy();
            mRightButton = null;
         }
         mLeftCallback = null;
         mRightCallback = null;
         super.destroy();
      }
      
      override protected function setupUI(param1:SwfAsset, param2:String, param3:*, param4:Boolean, param5:Function) : void
      {
         var swfAsset:SwfAsset = param1;
         var titleText:String = param2;
         var content:* = param3;
         var allowClose:Boolean = param4;
         var closeCallback:Function = param5;
         super.setupUI(swfAsset,titleText,content,allowClose,closeCallback);
         if(mLeftText)
         {
            mPopup.left_button.visible = true;
            mLeftButton = new UIButton(mDBFacade,mPopup.left_button);
            mLeftButton.rolloverFilter = DBGlobal.UI_ROLLOVER_FILTER;
            mLeftButton.label.text = mLeftText;
            mLeftButton.releaseCallback = function():void
            {
               close(mLeftCallback);
            };
         }
         else
         {
            mPopup.left_button.visible = false;
         }
         if(mRightText)
         {
            mPopup.right_button.visible = true;
            mRightButton = new UIButton(mDBFacade,mPopup.right_button);
            mRightButton.rolloverFilter = DBGlobal.UI_ROLLOVER_FILTER;
            mRightButton.label.text = mRightText;
            mRightButton.releaseCallback = function():void
            {
               close(mRightCallback);
            };
         }
         else
         {
            mPopup.right_button.visible = false;
         }
      }
      
      override protected function getClassName() : String
      {
         return "popup";
      }
   }
}

