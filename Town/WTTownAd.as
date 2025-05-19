package Town
{
   import Brain.Clock.GameClock;
   import Brain.Logger.Logger;
   import Brain.jsonRPC.JSONRPCService;
   import Facade.DBFacade;
   import com.wildtangent.WildTangentAPI;
   import flash.display.MovieClip;
   
   public class WTTownAd implements ITownAdProvider
   {
      
      private static const TOWN_AD_X:int = 612;
      
      private static const TOWN_AD_Y:int = 276;
      
      private static const MIN_AD_AVATAR_LEVEL_DFLT:int = -1;
      
      private static const WT_RESHOW_TIMER:int = 300000;
      
      private static const WT_PARTNER:String = "rebelentertainment";
      
      private static const WT_SITE:String = "dungeonrampage_v1";
      
      private static const WT_GAME:String = "dungeonrampage";
      
      private static var lastRedeemTime:Number = 0;
      
      private var mWildTangentAPI:WildTangentAPI = null;
      
      private var mDBFacade:DBFacade;
      
      private var mTownClip:MovieClip;
      
      private var mTownStateMachine:TownStateMachine;
      
      private var wtResponseObject:Object = {};
      
      private var wtRedeemObject:Object = {};
      
      private var wtPromoBase:String = "promoId";
      
      private var wtLastPromoCtr:int = 0;
      
      private var wtPromoCtr:int = 1;
      
      private var mResponseCallback:Function = null;
      
      private var mResetCallback:Function = null;
      
      private var mInitialized:Boolean = false;
      
      public function WTTownAd(param1:DBFacade, param2:MovieClip, param3:TownStateMachine)
      {
         super();
         mDBFacade = param1;
         mTownStateMachine = param3;
         Logger.debug("Initializing WT API");
         mWildTangentAPI = new WildTangentAPI();
         mWildTangentAPI.gameName = "dungeonrampage";
         mWildTangentAPI.partnerName = "rebelentertainment";
         mWildTangentAPI.siteName = "dungeonrampage_v1";
         mWildTangentAPI.userId = String(mDBFacade.dbAccountInfo.id);
         mWildTangentAPI.BrandBoost.closed = closedWT;
         mWildTangentAPI.BrandBoost.handlePromo = WildTangentResponse;
         mWildTangentAPI.Vex.redeemCode = redeemCodeWT;
         assignTownClip(param2);
         addWildTangentAPI();
         mInitialized = true;
      }
      
      public function destroy() : void
      {
         Logger.debug("Destroying WT API");
         mInitialized = false;
         if(mWildTangentAPI)
         {
            mTownClip.removeChild(mWildTangentAPI);
         }
         mWildTangentAPI = null;
         mResponseCallback = null;
         mResetCallback = null;
      }
      
      public function assignTownClip(param1:MovieClip) : void
      {
         Logger.debug("AssignTownClip WT API");
         mTownClip = param1;
      }
      
      public function addWildTangentAPI() : void
      {
         Logger.debug("addWildTangentAPI WT API");
         mTownClip.addChildAt(mWildTangentAPI,0);
      }
      
      public function removeWildTangentAPI() : void
      {
         Logger.debug("removeWildTangentAPI WT API");
         if(mWildTangentAPI)
         {
            mTownClip.removeChild(mWildTangentAPI);
         }
      }
      
      public function CheckForAds(param1:Function) : void
      {
         var _loc2_:Boolean = true;
         if(wtLastPromoCtr == wtPromoCtr)
         {
            Logger.debug("WT CheckForAds already has a promo pending; return");
            return;
         }
         if(lastRedeemTime + 300000 > GameClock.getWebServerDate().valueOf())
         {
            Logger.debug("WT CheckForAds returning to wait for a new promo");
            param1(false);
            mResponseCallback = null;
            return;
         }
         mResponseCallback = param1;
         wtLastPromoCtr = wtPromoCtr;
         var _loc3_:String = wtPromoBase + String(wtPromoCtr);
         Logger.debug("WT Checking for promo " + _loc3_);
         mWildTangentAPI.BrandBoost.getPromo({"promoName":_loc3_});
      }
      
      public function WildTangentResponse(param1:Object) : void
      {
         Logger.debug("WT Promo Available = " + param1.available);
         if(param1 == wtResponseObject)
         {
            Logger.debug("WT Promo called with same obj as last");
         }
         if(mResponseCallback != null)
         {
            Logger.debug("WT Promo Response Callback");
            mResponseCallback(param1.available);
         }
         if(param1.available)
         {
            wtResponseObject = param1;
            removeWildTangentAPI();
         }
      }
      
      public function SetResetCallback(param1:Function) : void
      {
         mResetCallback = param1;
      }
      
      public function ShowingAdButton() : void
      {
         mDBFacade.metrics.log("WtTownButton");
         Logger.debug("WT Ad set up");
      }
      
      public function ShowAdPlayer() : void
      {
         if(wtResponseObject == null)
         {
            Logger.info("wtResponseObject is null");
            return;
         }
         Logger.debug("Launching WT Ad: " + wtResponseObject.available + "," + wtResponseObject.itemKey + "," + wtResponseObject.promoName);
         mDBFacade.metrics.log("WtBrandBoostLaunch");
         mWildTangentAPI.BrandBoost.launch(wtResponseObject);
      }
      
      public function closedWT(param1:Object) : void
      {
         Logger.debug("Closed WT Ad with reason=" + param1.reason);
         switch(param1.reason)
         {
            case "redeemed":
               adRedeemedWT();
               mDBFacade.metrics.log("WtBrandBoostRedeem");
               break;
            case "abandon":
               mDBFacade.metrics.log("WtBrandBoostAbandon");
               break;
            case "buy_item":
               adBuyItemWT();
               mDBFacade.metrics.log("WtBrandBoostToShop");
         }
      }
      
      public function adBuyItemWT() : void
      {
         Logger.debug("WT causing enter shop state");
         mDBFacade.dbAccountInfo.getUsersFullAccountInfo();
         mTownStateMachine.enterShopState();
      }
      
      public function adRedeemedWT() : void
      {
         Logger.debug("WT causing ad UI invisible");
         mDBFacade.dbAccountInfo.getUsersFullAccountInfo();
      }
      
      public function redeemCodeWT(param1:Object) : void
      {
         lastRedeemTime = GameClock.getWebServerDate().valueOf();
         Logger.debug("Calling WT redeem RPC");
         wtRedeemObject = param1;
         var _loc2_:Function = JSONRPCService.getFunction("CodeRedemption",mDBFacade.rpcRoot + "wildtangent");
         _loc2_(mDBFacade.dbAccountInfo.id,mDBFacade.dbAccountInfo.activeAvatarId,param1.vexCode,mDBFacade.validationToken,mDBFacade.demographics,redeemSuccessWT,redeemErrorWT);
      }
      
      public function redeemSuccessWT(param1:*) : void
      {
         Logger.debug("WT redeem success");
         mWildTangentAPI.Vex.redemptionComplete(wtRedeemObject);
         wtPromoCtr += 1;
         mResetCallback(0);
      }
      
      public function redeemErrorWT(param1:Error) : void
      {
         Logger.debug("WT redeem error");
         mWildTangentAPI.Vex.redemptionComplete(wtRedeemObject);
         wtPromoCtr += 1;
         mResetCallback();
      }
   }
}

