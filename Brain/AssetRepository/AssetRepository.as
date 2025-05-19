package Brain.AssetRepository
{
   import Brain.Facade.Facade;
   import Brain.Sound.SoundAsset;
   import flash.media.Sound;
   import org.as3commons.collections.Map;
   
   public class AssetRepository
   {
      
      protected static var mAssetCache:AssetCache = new AssetCache();
      
      protected var mPendingLoads:Map = new Map();
      
      protected var mFacade:Facade;
      
      public function AssetRepository(param1:Facade)
      {
         super();
         mFacade = param1;
      }
      
      public function tryCache(param1:AssetLoaderInfo, param2:Function) : Boolean
      {
         var _loc3_:Asset = mAssetCache.itemFor(param1);
         if(_loc3_)
         {
            if(param2 != null)
            {
               param2(_loc3_);
            }
            return true;
         }
         return false;
      }
      
      protected function getAsset(param1:AssetLoaderInfo, param2:Function, param3:Function, param4:Class) : Boolean
      {
         var _loc5_:AssetLoader = null;
         var _loc7_:String = param1.getKey();
         if(tryCache(param1,param2))
         {
            return true;
         }
         var _loc6_:ActiveLoadBase = mPendingLoads.itemFor(_loc7_);
         if(_loc6_ == null)
         {
            _loc5_ = new param4(mFacade,param1,this.executeSuccessCallbacks,this.executeErrorCallbacks);
            _loc6_ = new ActiveLoaderWithLoader(_loc5_,this,param1);
            mPendingLoads.add(_loc7_,_loc6_);
         }
         _loc6_.AddCallback(param2,param3);
         return false;
      }
      
      public function getJsonAsset(param1:AssetLoaderInfo, param2:Function, param3:Function = null) : AssetLoaderInfo
      {
         var _loc4_:Boolean = getAsset(param1,param2,param3,JsonAssetLoader);
         return _loc4_ ? null : param1;
      }
      
      public function getXMLAsset(param1:AssetLoaderInfo, param2:Function, param3:Function = null) : AssetLoaderInfo
      {
         var _loc4_:Boolean = getAsset(param1,param2,param3,XMLAssetLoader);
         return _loc4_ ? null : param1;
      }
      
      public function getByteArrayAsset(param1:AssetLoaderInfo, param2:Function, param3:Function = null) : AssetLoaderInfo
      {
         var _loc4_:Boolean = getAsset(param1,param2,param3,ByteArrayAssetLoader);
         return _loc4_ ? null : param1;
      }
      
      public function getSwfAsset(param1:AssetLoaderInfo, param2:Function, param3:Function = null) : AssetLoaderInfo
      {
         var _loc4_:Boolean = getAsset(param1,param2,param3,SwfAssetLoader);
         return _loc4_ ? null : param1;
      }
      
      public function getImageAsset(param1:AssetLoaderInfo, param2:Function, param3:Function = null) : AssetLoaderInfo
      {
         var _loc4_:Boolean = getAsset(param1,param2,param3,ImageAssetLoader);
         return _loc4_ ? null : param1;
      }
      
      public function getSpriteSheetAsset(param1:Facade, param2:SpriteSheetAssetLoaderInfo, param3:String, param4:Function, param5:Function, param6:Function, param7:String, param8:AssetLoadingComponent = null) : void
      {
         var activeLoad:ActiveLoadBase;
         var swfLoaderInfo:AssetLoaderInfo;
         var loadSpriteSheetFromCache:Function;
         var loadSpriteSheet:Function;
         var trackLoad:ActiveLoaderDependent;
         var facade:Facade = param1;
         var sheetLoaderInfo:SpriteSheetAssetLoaderInfo = param2;
         var bitmapDataName:String = param3;
         var loadedCallback:Function = param4;
         var errorCallback:Function = param5;
         var trickelLoaderCallback:Function = param6;
         var shClassName:String = param7;
         var assetLoadingComponent:AssetLoadingComponent = param8;
         if(tryCache(sheetLoaderInfo,loadedCallback))
         {
            return;
         }
         activeLoad = mPendingLoads.itemFor(sheetLoaderInfo.getKey());
         if(activeLoad != null)
         {
            activeLoad.AddCallback(loadedCallback,errorCallback);
            return;
         }
         swfLoaderInfo = new AssetLoaderInfo(sheetLoaderInfo.getRawAssetPath(),sheetLoaderInfo.useCache);
         loadSpriteSheetFromCache = function(param1:SwfAsset):void
         {
            var _loc2_:SpriteSheetAsset = null;
            if(param1.root.JsonObject && param1.root.JsonObject[shClassName])
            {
               _loc2_ = new SpriteSheetAsset(facade);
               _loc2_.FactoryFromSWf(bitmapDataName.replace(".png",""),param1.root.JsonObject[shClassName],param1);
               mAssetCache.add(sheetLoaderInfo,_loc2_);
               if(loadedCallback != null)
               {
                  loadedCallback(_loc2_);
               }
            }
         };
         if(tryCache(swfLoaderInfo,loadSpriteSheetFromCache))
         {
            return;
         }
         loadSpriteSheet = function(param1:SwfAsset):void
         {
            var _loc2_:SpriteSheetAsset = null;
            if(param1.root.JsonObject && param1.root.JsonObject[shClassName])
            {
               _loc2_ = new SpriteSheetAsset(facade);
               _loc2_.FactoryFromSWf(bitmapDataName.replace(".png",""),param1.root.JsonObject[shClassName],param1);
               mAssetCache.add(sheetLoaderInfo,_loc2_);
               executeSuccessCallbacks(sheetLoaderInfo,_loc2_);
            }
         };
         trackLoad = new ActiveLoaderDependent(this,loadSpriteSheet,sheetLoaderInfo);
         mPendingLoads.add(sheetLoaderInfo.getKey(),trackLoad);
         trackLoad.AddCallback(loadedCallback,errorCallback);
         if(assetLoadingComponent)
         {
            assetLoadingComponent.getSwfAsset(swfLoaderInfo.getRawAssetPath(),trackLoad.successCallback,trackLoad.errorCallback);
         }
         else
         {
            getSwfAsset(swfLoaderInfo,trackLoad.successCallback,trackLoad.errorCallback);
         }
      }
      
      public function getSoundAsset(param1:SoundAssetLoaderInfo, param2:String, param3:Function, param4:Function = null) : void
      {
         var activeLoad:ActiveLoadBase;
         var swfLoaderInfo:AssetLoaderInfo;
         var loadSoundFromCache:Function;
         var loadSound:Function;
         var trackLoad:ActiveLoaderDependent;
         var assetLoaderInfo:SoundAssetLoaderInfo = param1;
         var soundName:String = param2;
         var loadedCallback:Function = param3;
         var errorCallback:Function = param4;
         var cacheKey:String = assetLoaderInfo.getKey();
         if(tryCache(assetLoaderInfo,loadedCallback))
         {
            return;
         }
         activeLoad = mPendingLoads.itemFor(cacheKey);
         if(activeLoad != null)
         {
            activeLoad.AddCallback(loadedCallback,errorCallback);
            return;
         }
         swfLoaderInfo = new AssetLoaderInfo(assetLoaderInfo.getRawAssetPath(),assetLoaderInfo.useCache);
         loadSoundFromCache = function(param1:SwfAsset):void
         {
            var _loc3_:Sound = null;
            var _loc4_:SoundAsset = null;
            var _loc2_:Class = param1.getClass(soundName);
            if(_loc2_)
            {
               _loc3_ = new _loc2_() as Sound;
               _loc4_ = new SoundAsset(_loc3_);
               mAssetCache.add(assetLoaderInfo,_loc4_);
               loadedCallback(_loc4_);
            }
            else if(errorCallback != null)
            {
               errorCallback();
            }
         };
         if(tryCache(swfLoaderInfo,loadSoundFromCache))
         {
            return;
         }
         loadSound = function(param1:SwfAsset):void
         {
            var _loc3_:Sound = null;
            var _loc4_:SoundAsset = null;
            var _loc2_:Class = param1.getClass(soundName);
            if(_loc2_)
            {
               _loc3_ = new _loc2_() as Sound;
               _loc4_ = new SoundAsset(_loc3_);
               executeSuccessCallbacks(assetLoaderInfo,_loc4_);
            }
            else
            {
               executeErrorCallbacks(assetLoaderInfo);
            }
         };
         trackLoad = new ActiveLoaderDependent(this,loadSound,assetLoaderInfo);
         mPendingLoads.add(cacheKey,trackLoad);
         trackLoad.AddCallback(loadedCallback,errorCallback);
         getSwfAsset(swfLoaderInfo,trackLoad.successCallback,trackLoad.errorCallback);
      }
      
      public function getURLSoundAsset(param1:SoundAssetLoaderInfo, param2:Function, param3:Function = null) : AssetLoaderInfo
      {
         var _loc4_:Boolean = getAsset(param1,param2,param3,URLSoundAssetLoader);
         return _loc4_ ? null : param1;
      }
      
      public function removeCallbackFromPendingDownload(param1:String, param2:Function) : Boolean
      {
         var _loc3_:Boolean = false;
         var _loc4_:ActiveLoadBase = mPendingLoads.itemFor(param1);
         if(_loc4_ != null)
         {
            _loc3_ = _loc4_.removeCallback(param2,null);
            if(_loc4_.hasNoCallbacks())
            {
               mPendingLoads.removeKey(param1);
               _loc4_.destroy();
            }
         }
         return _loc3_;
      }
      
      public function removeErrorCallbackFromPendingDownload(param1:String, param2:Function) : Boolean
      {
         var _loc3_:Boolean = false;
         var _loc4_:ActiveLoadBase = mPendingLoads.itemFor(param1);
         if(_loc4_ != null)
         {
            _loc3_ = _loc4_.removeCallback(null,param2);
            if(_loc4_.hasNoCallbacks())
            {
               mPendingLoads.removeKey(param1);
               _loc4_.destroy();
            }
         }
         return _loc3_;
      }
      
      protected function executeSuccessCallbacks(param1:AssetLoaderInfo, param2:Asset) : void
      {
         var _loc4_:String = param1.getKey();
         mAssetCache.add(param1,param2);
         var _loc3_:ActiveLoadBase = mPendingLoads.removeKey(_loc4_);
         if(_loc3_ != null)
         {
            _loc3_.executeSucessCallbacks(param1,param2);
            _loc3_.destroy();
         }
      }
      
      public function executeErrorCallbacks(param1:AssetLoaderInfo) : void
      {
         var _loc2_:ActiveLoadBase = null;
         var _loc3_:String = param1.getKey();
         if(mPendingLoads.hasKey(_loc3_))
         {
            _loc2_ = mPendingLoads.removeKey(_loc3_);
            if(_loc2_ != null)
            {
               _loc2_.executeErrorCallbacks(param1);
               _loc2_.destroy();
            }
         }
      }
      
      public function removeCacheForAllSpriteSheetAssets() : void
      {
         mAssetCache.removeCacheForSpriteSheetAssets();
      }
      
      public function removeFromCache(param1:Asset) : Boolean
      {
         return mAssetCache.remove(param1);
      }
      
      public function destroy() : void
      {
      }
   }
}

final class ActiveLoaderWithLoader extends ActiveLoadBase
{
   
   public var mAssetLoader:AssetLoader;
   
   public function ActiveLoaderWithLoader(param1:AssetLoader, param2:AssetRepository, param3:AssetLoaderInfo)
   {
      super(param2,param3);
      this.mAssetLoader = param1;
   }
   
   override public function destroy() : void
   {
      super.destroy();
      mAssetLoader.destroy();
      mAssetLoader = null;
   }
   
   override public function executeSucessCallbacks(param1:AssetLoaderInfo, param2:Asset) : void
   {
      super.executeSucessCallbacks(param1,param2);
   }
}

final class ActiveLoaderDependent extends ActiveLoadBase
{
   
   public var mSuccess:Function;
   
   public function ActiveLoaderDependent(param1:AssetRepository, param2:Function, param3:AssetLoaderInfo)
   {
      super(param1,param3);
      mSuccess = param2;
   }
   
   public function successCallback(param1:Object) : void
   {
      mSuccess(param1);
   }
   
   public function errorCallback() : void
   {
      mAssetRepository.executeErrorCallbacks(mInfo);
   }
   
   override public function destroy() : void
   {
      mSuccess = null;
      mAssetRepository.removeCallbackFromPendingDownload(mInfo.getKey(),successCallback);
      mAssetRepository.removeErrorCallbackFromPendingDownload(mInfo.getKey(),errorCallback);
      super.destroy();
   }
}
