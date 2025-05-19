package Brain.AssetRepository
{
   import Brain.Clock.GameClock;
   import Brain.Facade.Facade;
   import Brain.Logger.Logger;
   import Brain.Sound.SoundAsset;
   import flash.events.Event;
   import flash.events.IOErrorEvent;
   import flash.events.SecurityErrorEvent;
   import flash.media.Sound;
   import flash.net.URLRequest;
   
   public class URLSoundAssetLoader extends AssetLoader
   {
      
      protected var mSoundAsset:SoundAsset;
      
      private var mSound:Sound;
      
      public function URLSoundAssetLoader(param1:Facade, param2:AssetLoaderInfo, param3:Function, param4:Function = null)
      {
         super(param1,param2,param3,param4,false);
      }
      
      override protected function loadAsset(param1:Facade, param2:String, param3:Boolean = true) : void
      {
         var _loc4_:URLRequest = new URLRequest(param2);
         if(param3)
         {
            _loc4_.url += "?v=" + param1.fileVersion(param2);
         }
         else
         {
            _loc4_.url += "?t=" + new Date().getTime().toString();
         }
         mSound = new Sound();
         mSound.load(_loc4_);
         mSound.addEventListener("complete",soundLoadComplete);
         mSound.addEventListener("ioError",soundLoadIOError);
         mSound.addEventListener("securityError",soundLoadSecurityError);
         if(mCollectingTrackLoads)
         {
            mTrackedLoads.add(mAssetLoaderInfo.getRawAssetPath());
         }
      }
      
      protected function soundLoadComplete(param1:Event) : void
      {
         Logger.info("Loader.loadComplete: " + param1.target.url);
         mSoundAsset = new SoundAsset(mSound);
         var _loc2_:Asset = mSoundAsset;
         var _loc3_:AssetLoaderInfo = mAssetLoaderInfo;
         mAssetCreatedCallback(mAssetLoaderInfo,_loc2_);
         updateTrackingLoad(_loc3_.getRawAssetPath());
      }
      
      protected function soundLoadIOError(param1:IOErrorEvent) : void
      {
         var evt:IOErrorEvent = param1;
         updateTrackingLoad(mAssetLoaderInfo.getRawAssetPath());
         if(mFacade.gameClock.frame > 1)
         {
            mFacade.logicalWorkManager.doLater(0.1,function(param1:GameClock):void
            {
               if(mAssetLoaderInfo)
               {
                  Logger.error("Loader.handleIOErrorUrl from path: " + mAssetLoaderInfo.getRawAssetPath());
                  if(mErrorCallback != null)
                  {
                     mErrorCallback(mAssetLoaderInfo);
                  }
               }
            },false);
         }
         else
         {
            Logger.error("Loader.handleIOErrorUrl from path: " + mAssetLoaderInfo.getRawAssetPath());
            if(mErrorCallback != null)
            {
               mErrorCallback(mAssetLoaderInfo);
            }
         }
      }
      
      protected function soundLoadSecurityError(param1:SecurityErrorEvent) : void
      {
         Logger.error("Loader.handleSecurityError from path: " + mAssetLoaderInfo.getRawAssetPath() + ".   " + param1.text);
         var _loc2_:AssetLoaderInfo = mAssetLoaderInfo;
         if(mErrorCallback != null)
         {
            mErrorCallback(mAssetLoaderInfo);
         }
         updateTrackingLoad(_loc2_.getRawAssetPath());
      }
   }
}

