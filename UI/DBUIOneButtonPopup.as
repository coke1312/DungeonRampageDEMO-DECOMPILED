package UI
{
   import Brain.AssetRepository.SwfAsset;
   import Brain.UI.UIButton;
   import DBGlobals.DBGlobal;
   import Facade.DBFacade;
   
   public class DBUIOneButtonPopup extends DBUIPopup
   {
      
      protected var mCenterButton:UIButton;
      
      protected var mCenterCallback:Function;
      
      protected var mCenterText:String;
      
      protected var mClassOverride:String;
      
      protected var mSwfOverride:String;
      
      public function DBUIOneButtonPopup(param1:DBFacade, param2:String, param3:*, param4:String, param5:Function, param6:Boolean = true, param7:Function = null, param8:String = null, param9:String = null)
      {
         mClassOverride = param8;
         mSwfOverride = param9;
         mCenterText = param4;
         mCenterCallback = param5;
         super(param1,param2,param3,param6,true,param7);
      }
      
      override public function destroy() : void
      {
         if(mCenterButton)
         {
            mCenterButton.destroy();
            mCenterButton = null;
         }
         mCenterCallback = null;
         super.destroy();
      }
      
      override protected function setupUI(param1:SwfAsset, param2:String, param3:*, param4:Boolean, param5:Function) : void
      {
         super.setupUI(param1,param2,param3,param4,param5);
         if(mCenterText)
         {
            mPopup.center_button.visible = true;
            mCenterButton = new UIButton(mDBFacade,mPopup.center_button);
            mCenterButton.label.text = mCenterText;
            mCenterButton.releaseCallback = this.centerButtonCallback;
            mCenterButton.rolloverFilter = DBGlobal.UI_ROLLOVER_FILTER;
         }
         else if(mPopup.center_button)
         {
            mPopup.center_button.visible = false;
         }
      }
      
      protected function centerButtonCallback() : void
      {
         this.close(mCenterCallback);
      }
      
      override protected function getClassName() : String
      {
         if(mClassOverride)
         {
            return mClassOverride;
         }
         return "popup";
      }
      
      override protected function getSwfPath() : String
      {
         if(mSwfOverride)
         {
            return mSwfOverride;
         }
         return super.getSwfPath();
      }
   }
}

