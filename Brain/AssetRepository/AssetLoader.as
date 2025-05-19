package Brain.AssetRepository
{
   import Brain.Clock.GameClock;
   import Brain.Facade.Facade;
   import Brain.Logger.Logger;
   import flash.display.Loader;
   import flash.display.LoaderInfo;
   import flash.events.Event;
   import flash.events.EventDispatcher;
   import flash.events.SecurityErrorEvent;
   import flash.net.URLLoader;
   import flash.net.URLRequest;
   import flash.system.LoaderContext;
   import org.as3commons.collections.Set;
   
   public class AssetLoader
   {
      
      private static var mTrackedLoadsCallback:Function = null;
      
      protected static var mCollectingTrackLoads:Boolean = false;
      
      protected static var mBytesLoaded:uint = 0;
      
      protected static var mBytesTotal:uint = 0;
      
      protected static var mTrackedLoads:Set = new Set();
      
      private static var mloadersets:Vector.<Loader> = new Vector.<Loader>();
      
      protected var mAssetLoaderInfo:AssetLoaderInfo;
      
      protected var mAssetCreatedCallback:Function;
      
      protected var mErrorCallback:Function;
      
      protected var mEventForLoader:EventDispatcher;
      
      protected var mFacade:Facade;
      
      protected var mUseLoader:Boolean;
      
      protected var mURLDataFormat:String;
      
      private var mUrlLoader:URLLoader;
      
      private var mLoader:Loader;
      
      public function AssetLoader(param1:Facade, param2:AssetLoaderInfo, param3:Function, param4:Function = null, param5:Boolean = false, param6:String = "text")
      {
         super();
         mFacade = param1;
         mAssetLoaderInfo = param2;
         mAssetCreatedCallback = param3;
         mErrorCallback = param4;
         mUseLoader = param5;
         mURLDataFormat = param6;
         loadAsset(param1,mAssetLoaderInfo.getRawAssetPath(),mAssetLoaderInfo.useCache);
      }
      
      public static function startTrackingLoads(param1:Function) : void
      {
         if(mCollectingTrackLoads)
         {
            Logger.warn("startTrackingLoads  with \tmCollectingTrackLoads already Active ");
         }
         mCollectingTrackLoads = true;
         mBytesLoaded = 0;
         mBytesTotal = 0;
         if(mTrackedLoads.size)
         {
            mTrackedLoads.clear();
            mloadersets.splice(0,4294967295);
         }
         mTrackedLoadsCallback = param1;
      }
      
      public static function abortTrackingLoads() : void
      {
         mCollectingTrackLoads = false;
         mTrackedLoadsCallback = null;
         mTrackedLoads.clear();
         mloadersets.splice(0,4294967295);
      }
      
      public static function stopTrackingLoads() : void
      {
         if(mCollectingTrackLoads)
         {
            mCollectingTrackLoads = false;
            if(mTrackedLoads.size == 0)
            {
               if(mTrackedLoadsCallback != null)
               {
                  mTrackedLoadsCallback();
               }
            }
         }
      }
      
      public static function get pendingBytesLoaded() : uint
      {
         return mBytesLoaded;
      }
      
      public static function get pendingBytesTotal() : uint
      {
         return mBytesTotal;
      }
      
      public static function updateTrackedLoads() : void
      {
         mBytesLoaded = 0;
         mBytesTotal = 0;
         for each(var _loc1_ in mloadersets)
         {
            mBytesLoaded += _loc1_.contentLoaderInfo.bytesLoaded;
            mBytesTotal += _loc1_.contentLoaderInfo.bytesTotal;
         }
      }
      
      protected static function updateTrackingLoad(param1:String) : void
      {
         var _loc2_:Function = null;
         Logger.info("Loader.updateTrackingLoad: mPendingLoads:" + mTrackedLoads.size.toString() + " mTrackLoads: " + mCollectingTrackLoads.toString());
         if(mTrackedLoads.size > 0)
         {
            mTrackedLoads.remove(param1);
            if(mTrackedLoads.size == 0 && !mCollectingTrackLoads)
            {
               if(mTrackedLoadsCallback != null)
               {
                  _loc2_ = mTrackedLoadsCallback;
                  mTrackedLoadsCallback = null;
                  _loc2_();
               }
            }
         }
      }
      
      protected function buildAsset(param1:Object) : Asset
      {
         Logger.error("Should be overriding buildAsset in the subclasses to build the Asset.");
         return null;
      }
      
      protected function loadAsset(param1:Facade, param2:String, param3:Boolean = true) : void
      {
         var _loc5_:LoaderContext = null;
         var _loc4_:URLRequest = new URLRequest(param2);
         if(param3)
         {
            if(param2.indexOf("?") > 0)
            {
               _loc4_.url += "&v=" + param1.fileVersion(param2);
            }
            else
            {
               _loc4_.url += "?v=" + param1.fileVersion(param2);
            }
         }
         else
         {
            _loc4_.url += "?t=" + new Date().time.toString();
         }
         if(mUseLoader)
         {
            mLoader = new Loader();
            if(mCollectingTrackLoads)
            {
               mTrackedLoads.add(mAssetLoaderInfo.getRawAssetPath());
            }
            Logger.info("Loader.load: " + _loc4_.url + " useCache: " + param3.toString());
            mEventForLoader = mLoader.contentLoaderInfo;
            mEventForLoader.addEventListener("complete",loadComplete);
            mEventForLoader.addEventListener("ioError",handleIOError);
            mEventForLoader.addEventListener("securityError",handleSecurityError);
            _loc5_ = new LoaderContext(true);
            _loc5_.checkPolicyFile = true;
            mLoader.load(_loc4_,_loc5_);
            if(mCollectingTrackLoads)
            {
               mloadersets.push(mLoader);
            }
         }
         else
         {
            mUrlLoader = new URLLoader();
            mEventForLoader = mUrlLoader;
            mEventForLoader.addEventListener("complete",urlLoadComplete);
            mEventForLoader.addEventListener("ioError",handleIOErrorUrl);
            mEventForLoader.addEventListener("securityError",handleSecurityError);
            mUrlLoader.dataFormat = mURLDataFormat;
            if(mCollectingTrackLoads)
            {
               mTrackedLoads.add(mAssetLoaderInfo.getRawAssetPath());
            }
            Logger.info("URLLoader.load: " + _loc4_.url + " useCache: " + param3.toString());
            mUrlLoader.load(_loc4_);
         }
      }
      
      public function getExtension(param1:String) : String
      {
         return param1.substring(param1.lastIndexOf(".") + 1,param1.length);
      }
      
      private function loadComplete(param1:Event) : void
      {
         var _loc2_:Asset = null;
         Logger.info("Loader.loadComplete: " + param1.target.url);
         var _loc3_:Loader = LoaderInfo(param1.target).loader;
         _loc3_.contentLoaderInfo.removeEventListener("complete",loadComplete);
         _loc3_.contentLoaderInfo.removeEventListener("ioError",handleIOError);
         _loc3_.contentLoaderInfo.removeEventListener("securityError",handleSecurityError);
         mLoader = null;
         var _loc4_:AssetLoaderInfo = mAssetLoaderInfo;
         try
         {
            _loc2_ = buildAsset(_loc3_.content);
            mAssetCreatedCallback(mAssetLoaderInfo,_loc2_);
            updateTrackingLoad(_loc4_.getRawAssetPath());
         }
         catch(e:Error)
         {
            Logger.error("Loader.loadComplete error processing: " + mAssetLoaderInfo.getRawAssetPath(),e);
            if(mErrorCallback != null)
            {
               mErrorCallback(mAssetLoaderInfo);
            }
            updateTrackingLoad(_loc4_.getRawAssetPath());
         }
      }
      
      private function urlLoadComplete(param1:Event) : void
      {
         var _loc2_:Asset = null;
         var _loc3_:URLLoader = URLLoader(param1.target);
         Logger.info("Loader.urlLoadComplete: " + mAssetLoaderInfo.getRawAssetPath() + " dataFormat: " + _loc3_.dataFormat);
         _loc3_.removeEventListener("complete",urlLoadComplete);
         _loc3_.removeEventListener("ioError",handleIOError);
         _loc3_.removeEventListener("securityError",handleSecurityError);
         mUrlLoader = null;
         var _loc4_:AssetLoaderInfo = mAssetLoaderInfo;
         try
         {
            _loc2_ = buildAsset(_loc3_.data);
            mAssetCreatedCallback(mAssetLoaderInfo,_loc2_);
            updateTrackingLoad(_loc4_.getRawAssetPath());
         }
         catch(e:Error)
         {
            Logger.error("Loader.urlLoadComplete error processing: " + mAssetLoaderInfo.getRawAssetPath(),e);
            updateTrackingLoad(_loc4_.getRawAssetPath());
            if(mErrorCallback != null)
            {
               mErrorCallback(mAssetLoaderInfo);
            }
         }
      }
      
      private function handleIOError(param1:Event) : void
      {
         var AssetString:String;
         var event:Event = param1;
         var loader:Loader = LoaderInfo(event.target).loader;
         loader.contentLoaderInfo.removeEventListener("complete",loadComplete);
         loader.contentLoaderInfo.removeEventListener("ioError",handleIOError);
         loader.contentLoaderInfo.removeEventListener("securityError",handleSecurityError);
         mLoader = null;
         updateTrackingLoad(mAssetLoaderInfo.getRawAssetPath());
         AssetString = mAssetLoaderInfo.getRawAssetPath();
         mFacade.logicalWorkManager.doLater(0.1,function(param1:GameClock):void
         {
            if(mErrorCallback != null)
            {
               mErrorCallback(mAssetLoaderInfo);
            }
            Logger.error("Loader.handleIOError from path: " + AssetString);
         },false);
      }
      
      private function handleIOErrorUrl(param1:Event) : void
      {
         var event:Event = param1;
         var loader:URLLoader = URLLoader(event.target);
         loader.removeEventListener("complete",loadComplete);
         loader.removeEventListener("ioError",handleIOErrorUrl);
         loader.removeEventListener("securityError",handleSecurityError);
         mUrlLoader = null;
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
      
      private function handleSecurityError(param1:SecurityErrorEvent) : void
      {
         Logger.error("Loader.handleSecurityError from path: " + mAssetLoaderInfo.getRawAssetPath() + ".   " + param1.text);
         var _loc2_:AssetLoaderInfo = mAssetLoaderInfo;
         mLoader = null;
         mUrlLoader = null;
         if(mErrorCallback != null)
         {
            mErrorCallback(mAssetLoaderInfo);
         }
         updateTrackingLoad(_loc2_.getRawAssetPath());
      }
      
      public function destroy() : void
      {
         if(mEventForLoader != null)
         {
            mEventForLoader.removeEventListener("complete",urlLoadComplete);
            mEventForLoader.removeEventListener("ioError",handleIOErrorUrl);
            mEventForLoader.removeEventListener("securityError",handleSecurityError);
            mEventForLoader.removeEventListener("complete",loadComplete);
         }
         if(mUrlLoader != null)
         {
            mUrlLoader.close();
            mUrlLoader = null;
         }
         if(mLoader != null)
         {
            mLoader.close();
            mLoader = null;
         }
         mAssetLoaderInfo = null;
         mFacade = null;
         mErrorCallback = null;
         mAssetCreatedCallback = null;
         mEventForLoader = null;
      }
   }
}

