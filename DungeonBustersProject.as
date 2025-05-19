package
{
   import Brain.GameEntry;
   import Brain.Logger.Logger;
   import Brain.MouseScrollPlugin.*;
   import Facade.DBFacade;
   import com.amanitadesign.steam.SteamEvent;
   import flash.desktop.NativeApplication;
   import flash.events.ErrorEvent;
   import flash.events.Event;
   import flash.events.InvokeEvent;
   import flash.events.UncaughtErrorEvent;
   
   public class DungeonBustersProject extends GameEntry
   {
      
      protected var mDBFacade:DBFacade;
      
      public function DungeonBustersProject()
      {
         super();
         stage.scaleMode = "showAll";
         stage.quality = "high";
         mDBFacade = new DBFacade();
         mDBFacade.init(this.stage);
         NativeApplication.nativeApplication.addEventListener("invoke",onInvoke);
         MouseWheelEnabler.init(this.stage);
         this.loaderInfo.uncaughtErrorEvents.addEventListener("uncaughtError",function(param1:UncaughtErrorEvent):void
         {
            var _loc2_:String = null;
            var _loc5_:Error = null;
            param1.preventDefault();
            var _loc4_:Boolean = false;
            if(param1.error is Error)
            {
               _loc5_ = param1.error as Error;
               _loc2_ = _loc5_.hasOwnProperty("getStackTrace") ? _loc5_.getStackTrace() : _loc5_.toString();
               if(_loc5_ && _loc5_.name && _loc5_.name.indexOf("LOGGED") == 0)
               {
                  _loc4_ = true;
               }
            }
            else if(param1.error is ErrorEvent)
            {
               _loc2_ = ErrorEvent(param1.error).text;
            }
            else
            {
               _loc2_ = "Unknown error";
            }
            var _loc3_:int = 0;
            if(mDBFacade && mDBFacade.gameClock)
            {
               _loc3_ = mDBFacade.gameClock.gameTime;
            }
            if(!_loc4_)
            {
               Logger.error("UncaughtError: " + _loc2_);
            }
            mDBFacade.loggerErrorCall("UncaughtError: " + _loc2_ + " GameTime: " + _loc3_);
         });
      }
      
      public function onInvoke(param1:InvokeEvent = null) : void
      {
         NativeApplication.nativeApplication.addEventListener("exiting",onExit);
         try
         {
            if(!mDBFacade.mSteamworks.init())
            {
               Logger.warn("STEAMWORKS API is NOT available");
            }
            else
            {
               Logger.info("STEAMWORKS API is available\n");
               mDBFacade.mSteamworks.addEventListener(SteamEvent.STEAM_RESPONSE,onSteamResponse);
               mDBFacade.mSteamUserId = mDBFacade.mSteamworks.getUserID();
               Logger.info("STEAMWORKS User ID: " + mDBFacade.mSteamUserId);
               mDBFacade.mSteamAppId = mDBFacade.mSteamworks.getAppID();
               Logger.info("STEAMWORKS App ID: " + mDBFacade.mSteamAppId);
               mDBFacade.mSteamPersonaName = mDBFacade.mSteamworks.getPersonaName();
               Logger.info("STEAMWORKS Persona name: " + mDBFacade.mSteamPersonaName);
               mDBFacade.mSteamworks.getAuthTicketForWebApi();
            }
         }
         catch(e:Error)
         {
            Logger.warn("*** STEAMWORKS ERROR ***");
            Logger.error(e.message,e);
         }
         if(param1.arguments[0])
         {
            processArgument(param1.arguments[0]);
         }
         if(param1.arguments[1])
         {
            processArgument(param1.arguments[1]);
         }
         if(param1.arguments[2])
         {
            Logger.warn("GBS: Too many command line arguments passed in! Only supports two json files");
         }
      }
      
      private function onSteamResponse(param1:SteamEvent) : void
      {
         switch(int(param1.req_type) - 27)
         {
            case 0:
               Logger.info("[Steam] RESPONSE_OnGetAuthTicketForWebApiResponse: " + param1.response);
               mDBFacade.mSteamWebApiAuthTicket = mDBFacade.mSteamworks.getAuthTicketForWebApiResultHexString();
               mDBFacade.mSteamAuthTicketHandle = mDBFacade.mSteamworks.getAuthTicketForWebApiResultHandle();
         }
      }
      
      private function onExit(param1:Event) : void
      {
         Logger.info("Exiting application, cleaning up Steam");
         mDBFacade.mSteamworks.dispose();
      }
      
      private function processArgument(param1:*) : void
      {
         if(param1)
         {
            if(!endsWith(param1,".json"))
            {
               Logger.fatal("Failed to process command line argument, CLI args must end in .json and be files that live in DBConfiguration");
               trace("GBS: Failed to process command line argument, CLI args must end in .json and be files that live in DBConfiguration");
            }
            else
            {
               mDBFacade.mAdditionalConfigFilesToLoad.push("DBConfiguration/" + param1);
            }
         }
      }
      
      public function endsWith(param1:String, param2:String) : Boolean
      {
         return param2 == param1.substring(param1.length - param2.length);
      }
   }
}

