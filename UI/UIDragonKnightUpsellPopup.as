package UI
{
   import Brain.AssetRepository.SwfAsset;
   import Brain.Logger.Logger;
   import Facade.DBFacade;
   import Facade.Locale;
   import flash.net.URLRequest;
   import flash.net.navigateToURL;
   
   public class UIDragonKnightUpsellPopup extends DBUITwoButtonPopup
   {
      
      private static const DRAGON_KNIGHT_POPUP_SEEN_ATTRIBUTE:String = "dragon_knight_upsell_seen";
      
      private static const DUNGEONS_NEEDED_TO_COMPLETE_BEFORE_DRAGON_KNIGHT_POPUP:uint = 10;
      
      private static var POPUP_CLASS_NAME:String = "popup_dragonKnight";
      
      public function UIDragonKnightUpsellPopup(param1:DBFacade)
      {
         param1.mainStateMachine.showedInvitePopup = true;
         super(param1,Locale.getString("EXIT_POPUP_TITLE"),null,Locale.getString("EXIT_KEEP_PLAYING"),null,"VISIT WEBSITE",rightCallback,true,null);
      }
      
      public static function ShouldDisplayDragonKnightUpsell(param1:DBFacade) : Boolean
      {
         var _loc2_:String = param1.dbAccountInfo.getAttribute("dragon_knight_upsell_seen");
         if(_loc2_ != null && _loc2_ == "true")
         {
            return false;
         }
         if(param1.mainStateMachine.showedInvitePopup)
         {
            return false;
         }
         if(param1.dbAccountInfo.getDungeonsCompleted() > 10)
         {
            return true;
         }
         return false;
      }
      
      override protected function getClassName() : String
      {
         return POPUP_CLASS_NAME;
      }
      
      override protected function setupUI(param1:SwfAsset, param2:String, param3:*, param4:Boolean, param5:Function) : void
      {
         super.setupUI(param1,param2,param3,param4,param5);
      }
      
      private function rightCallback() : void
      {
         Logger.warn("Launching dungeon rampage website");
         var _loc1_:URLRequest = new URLRequest("https://www.dungeonrampage.com/");
         navigateToURL(_loc1_,"_blank");
         setUpsellAsClicked();
      }
      
      private function setUpsellAsClicked() : void
      {
         mDBFacade.dbAccountInfo.alterAttribute("dragon_knight_upsell_seen","true");
      }
      
      override public function destroy() : void
      {
         super.destroy();
      }
   }
}

