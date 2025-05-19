package UI
{
   import Brain.AssetRepository.SwfAsset;
   import Facade.DBFacade;
   import Facade.Locale;
   import flash.desktop.NativeApplication;
   
   public class UIExitPopup extends DBUITwoButtonPopup
   {
      
      protected static const SWF_PATH:String = "Resources/Art2D/UI/db_UI_town.swf";
      
      protected static const POPUP_CLASS_NAME:String = "popup_exit";
      
      public function UIExitPopup(param1:DBFacade)
      {
         var _loc4_:String = null;
         var _loc6_:String = null;
         var _loc2_:String = null;
         var _loc5_:Function = null;
         var _loc8_:String = null;
         var _loc3_:Function = null;
         var _loc7_:Boolean = param1.dbConfigManager.getConfigBoolean("show_wishlist_on_exit_popup",false);
         if(_loc7_)
         {
            _loc4_ = Locale.getString("EXIT_POPUP_TITLE");
            _loc6_ = Locale.getString("EXIT_POPUP_MESSAGE_CALL_TO_ACTION");
            _loc2_ = Locale.getString("EXIT_WISHLIST");
            _loc5_ = wishlistAction;
            _loc8_ = Locale.getString("EXIT_GAME");
            _loc3_ = exitApplicationAction;
         }
         else
         {
            _loc4_ = Locale.getString("EXIT_POPUP_TITLE_CHICKEN_OUT");
            _loc6_ = Locale.getString("EXIT_POPUP_MESSAGE");
            _loc2_ = Locale.getString("EXIT_GAME_GIVE_UP");
            _loc5_ = exitApplicationAction;
            _loc8_ = Locale.getString("EXIT_KEEP_PLAYING");
            _loc3_ = closePopupAction;
         }
         super(param1,_loc4_,_loc6_,_loc2_,_loc5_,_loc8_,_loc3_,true,null);
      }
      
      private function wishlistAction() : void
      {
         mDBFacade.openSteamPage();
      }
      
      private function exitApplicationAction() : void
      {
         NativeApplication.nativeApplication.exit();
      }
      
      private function closePopupAction() : void
      {
         this.destroy();
      }
      
      override protected function setupUI(param1:SwfAsset, param2:String, param3:*, param4:Boolean, param5:Function) : void
      {
         super.setupUI(param1,param2,param3,param4,param5);
      }
      
      override protected function getSwfPath() : String
      {
         return "Resources/Art2D/UI/db_UI_town.swf";
      }
      
      override protected function getClassName() : String
      {
         return "popup_exit";
      }
   }
}

