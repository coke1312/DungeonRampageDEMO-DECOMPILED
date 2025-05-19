package Account
{
   import Brain.Logger.Logger;
   import Facade.DBFacade;
   import com.greensock.TweenMax;
   import com.maccherone.json.JSON;
   import flash.events.Event;
   import flash.events.HTTPStatusEvent;
   import flash.net.URLLoader;
   import flash.net.URLRequest;
   import flash.net.URLRequestHeader;
   
   public class SteamAccountInfo
   {
      
      public static const steamRetryDelay:Number = 0.25;
      
      public static const maxSteamRetries:Number = 120;
      
      public static var steamRetries:int = 0;
      
      public function SteamAccountInfo()
      {
         super();
      }
      
      public static function getOrCreateAccount(param1:DBFacade, param2:Function) : void
      {
         var dbFacade:DBFacade = param1;
         var successCallback:Function = param2;
         if(!dbFacade.mUseSteamLogin)
         {
            Logger.info("Skipping logging into Steam.");
            successCallback();
            return;
         }
         spinWaitOnSteamTokenReceived(dbFacade,function():void
         {
            SteamAccountInfo.getOrCreateAccountAfterSteamTokenReceived(dbFacade,successCallback);
         });
      }
      
      public static function spinWaitOnSteamTokenReceived(param1:DBFacade, param2:Function) : void
      {
         var dbFacade:DBFacade = param1;
         var successCallback:Function = param2;
         if(dbFacade.mSteamWebApiAuthTicket)
         {
            successCallback();
         }
         else
         {
            if(steamRetries >= 120)
            {
               Logger.fatal("Steam login ticket not received from Steam SDK after 120 attempts. Aborting.");
            }
            steamRetries++;
            Logger.info("Steam login ticket not received yet from Steam SDK, waiting another 0.25 seconds. [" + steamRetries + "/" + 120 + "]");
            TweenMax.delayedCall(0.25,function():void
            {
               spinWaitOnSteamTokenReceived(dbFacade,successCallback);
            });
         }
      }
      
      public static function getOrCreateAccountAfterSteamTokenReceived(param1:DBFacade, param2:Function) : void
      {
         var apiPath:String;
         var request:URLRequest;
         var jsonHeader:URLRequestHeader;
         var requestObject:Object;
         var requestJsonString:String;
         var urlLoader:URLLoader;
         var responseStatusCode:int;
         var dbFacade:DBFacade = param1;
         var successCallback:Function = param2;
         Logger.info("Logging into server with id " + dbFacade.mSteamUserId + " and persona name " + dbFacade.mSteamPersonaName + " for app id " + dbFacade.mSteamAppId);
         if(!dbFacade.mSteamUserId || !dbFacade.mSteamPersonaName || dbFacade.mSteamAppId == 0)
         {
            Logger.fatal("Failed to get user\'s data from Steam. Maybe Steam is not running?");
         }
         apiPath = dbFacade.steamAPIRoot + "login/" + dbFacade.mSteamUserId;
         request = new URLRequest(apiPath);
         request.method = "PUT";
         jsonHeader = new URLRequestHeader("Content-type","application/json");
         request.requestHeaders.push(jsonHeader);
         requestObject = {
            "steamUserId":dbFacade.mSteamUserId,
            "steamUserPersonaName":dbFacade.mSteamPersonaName,
            "steamWebApiAuthTicket":dbFacade.mSteamWebApiAuthTicket,
            "requestingSteamAppId":dbFacade.mSteamAppId
         };
         requestJsonString = com.maccherone.json.JSON.encode(requestObject);
         request.data = requestJsonString;
         urlLoader = new URLLoader();
         responseStatusCode = 0;
         urlLoader.addEventListener("httpStatus",function(param1:HTTPStatusEvent):void
         {
            responseStatusCode = param1.status;
         });
         urlLoader.addEventListener("ioError",function(param1:Event):void
         {
            var _loc2_:String = "[" + responseStatusCode + "] Error Logging into Dungeon Rampage Server with Steam Login. HTTP Error: " + responseStatusCode + "; IOError: " + param1.toString();
            if(param1.target && param1.target.data)
            {
               _loc2_ += "; Response: " + param1.target.data;
            }
            if(dbFacade.mainStateMachine)
            {
               if(responseStatusCode == 0)
               {
                  dbFacade.mainStateMachine.enterSocketErrorState(1503);
               }
               else
               {
                  dbFacade.mainStateMachine.enterSocketErrorState(1500,responseStatusCode.toString());
               }
               Logger.error(_loc2_);
            }
            else
            {
               Logger.fatal(_loc2_);
            }
         });
         urlLoader.addEventListener("securityError",function(param1:Event):void
         {
            Logger.fatal("SecurityError on connecting to Internal Steam API: " + param1.toString());
         });
         urlLoader.addEventListener("complete",function(param1:Event):void
         {
            var _loc2_:Object = com.maccherone.json.JSON.decode(param1.target.data);
            dbFacade.accountId = _loc2_.playerId;
            Logger.info("[Steam] Steam account number is " + SteamIdConverter.convertSteamID64ToAccountId(dbFacade.mSteamUserId) + " and shorter id is https://s.team/p/" + SteamIdConverter.convertSteamID64ToSteamHex(dbFacade.mSteamUserId) + " which reverses to " + SteamIdConverter.convertSteamHexToSteamID64(SteamIdConverter.convertSteamID64ToSteamHex(dbFacade.mSteamUserId)));
            dbFacade.validationToken = _loc2_.playerToken;
            Logger.info("[Steam] Cancelling Auth token now that it is used");
            dbFacade.mSteamworks.cancelAuthTicket(dbFacade.mSteamAuthTicketHandle);
            successCallback();
         });
         urlLoader.load(request);
      }
   }
}

