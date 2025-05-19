package Brain.AssetRepository
{
   import Brain.Component.Component;
   import Brain.Facade.Facade;
   import org.as3commons.collections.Set;
   import org.as3commons.collections.framework.ISetIterator;
   
   public class AssetLoadingComponent extends Component
   {
      
      public var mPendingDownloads:Set;
      
      protected var mTransitionToEmptyFunction:Function;
      
      protected var mAssetRepository:AssetRepository;
      
      public function AssetLoadingComponent(param1:Facade)
      {
         super(param1);
         mAssetRepository = param1.assetRepository;
         mPendingDownloads = new Set();
      }
      
      public function getJsonAsset(param1:String, param2:Function, param3:Function, param4:Boolean = true) : void
      {
         var _loc5_:AssetLoaderInfo = new AssetLoaderInfo(param1,param4);
         if(param4)
         {
            if(mAssetRepository.tryCache(_loc5_,param2))
            {
               return;
            }
         }
         var _loc6_:AssetLoadingTracker = new AssetLoadingTracker(param1,this,param2,param3);
         mAssetRepository.getJsonAsset(_loc5_,_loc6_.successCallback,_loc6_.errorCallback);
      }
      
      public function getXMLAsset(param1:String, param2:Function, param3:Function = null, param4:Boolean = true) : void
      {
         var _loc5_:AssetLoaderInfo = new AssetLoaderInfo(param1,param4);
         if(param4)
         {
            if(mAssetRepository.tryCache(_loc5_,param2))
            {
               return;
            }
         }
         var _loc6_:AssetLoadingTracker = new AssetLoadingTracker(param1,this,param2,param3);
         mAssetRepository.getXMLAsset(_loc5_,_loc6_.successCallback,_loc6_.errorCallback);
      }
      
      public function getByteArrayAsset(param1:String, param2:Function, param3:Function = null, param4:Boolean = true) : void
      {
         var _loc5_:AssetLoaderInfo = new AssetLoaderInfo(param1,param4);
         if(param4)
         {
            if(mAssetRepository.tryCache(_loc5_,param2))
            {
               return;
            }
         }
         var _loc6_:AssetLoadingTracker = new AssetLoadingTracker(param1,this,param2,param3);
         mAssetRepository.getByteArrayAsset(_loc5_,_loc6_.successCallback,_loc6_.errorCallback);
      }
      
      public function getSwfAsset(param1:String, param2:Function, param3:Function = null, param4:Boolean = true) : void
      {
         var _loc5_:AssetLoaderInfo = new AssetLoaderInfo(param1,param4);
         if(param4)
         {
            if(mAssetRepository.tryCache(_loc5_,param2))
            {
               return;
            }
         }
         var _loc6_:AssetLoadingTracker = new AssetLoadingTracker(param1,this,param2,param3);
         mAssetRepository.getSwfAsset(_loc5_,_loc6_.successCallback,_loc6_.errorCallback);
      }
      
      public function getSpriteSheetAsset(param1:String, param2:String, param3:Function, param4:Function, param5:Boolean, param6:Function, param7:String) : void
      {
         var _loc8_:SpriteSheetAssetLoaderInfo = new SpriteSheetAssetLoaderInfo(param1,param2,param7,param5);
         if(param5)
         {
            if(mAssetRepository.tryCache(_loc8_,param3))
            {
               return;
            }
         }
         var _loc9_:AssetLoadingTracker = new AssetLoadingTracker(_loc8_.getKey(),this,param3,param4);
         mAssetRepository.getSpriteSheetAsset(mFacade,_loc8_,param2,_loc9_.successCallback,_loc9_.errorCallback,param6,param7,this);
      }
      
      public function getSoundAsset(param1:String, param2:String, param3:Function, param4:Function = null, param5:Boolean = true) : void
      {
         if(param2 == null)
         {
            return;
         }
         var _loc6_:SoundAssetLoaderInfo = new SoundAssetLoaderInfo(param1,param2,param5);
         if(param5)
         {
            if(mAssetRepository.tryCache(_loc6_,param3))
            {
               return;
            }
         }
         var _loc7_:AssetLoadingTracker = new AssetLoadingTracker(param1,this,param3,param4);
         mAssetRepository.getSoundAsset(_loc6_,param2,_loc7_.successCallback,_loc7_.errorCallback);
      }
      
      public function getURLSoundAsset(param1:String, param2:Function, param3:Function = null, param4:Boolean = true) : void
      {
         var _loc5_:SoundAssetLoaderInfo = new SoundAssetLoaderInfo(param1,"",param4);
         if(param4)
         {
            if(mAssetRepository.tryCache(_loc5_,param2))
            {
               return;
            }
         }
         var _loc6_:AssetLoadingTracker = new AssetLoadingTracker(param1,this,param2,param3);
         mAssetRepository.getURLSoundAsset(_loc5_,_loc6_.successCallback,_loc6_.errorCallback);
      }
      
      public function getImageAsset(param1:String, param2:Function, param3:Function = null, param4:Boolean = true) : void
      {
         var _loc5_:AssetLoaderInfo = new AssetLoaderInfo(param1,param4);
         if(param4)
         {
            if(mAssetRepository.tryCache(_loc5_,param2))
            {
               return;
            }
         }
         var _loc6_:AssetLoadingTracker = new AssetLoadingTracker(param1,this,param2,param3);
         mAssetRepository.getImageAsset(_loc5_,_loc6_.successCallback,_loc6_.errorCallback);
      }
      
      override public function destroy() : void
      {
         var _loc1_:ISetIterator = null;
         mTransitionToEmptyFunction = null;
         _loc1_ = mPendingDownloads.iterator() as ISetIterator;
         while(_loc1_.hasNext())
         {
            RemoveLoader(_loc1_.next() as AssetLoadingTracker);
            _loc1_ = mPendingDownloads.iterator() as ISetIterator;
         }
         mPendingDownloads = null;
         super.destroy();
      }
      
      public function clearAllActive() : void
      {
         var _loc1_:ISetIterator = null;
         mTransitionToEmptyFunction = null;
         _loc1_ = mPendingDownloads.iterator() as ISetIterator;
         while(_loc1_.hasNext())
         {
            RemoveLoader(_loc1_.next() as AssetLoadingTracker);
            _loc1_ = mPendingDownloads.iterator() as ISetIterator;
         }
      }
      
      public function RemoveLoader(param1:AssetLoadingTracker) : void
      {
         mAssetRepository.removeCallbackFromPendingDownload(param1.assetKey,param1.successCallback);
         mAssetRepository.removeErrorCallbackFromPendingDownload(param1.assetKey,param1.errorCallback);
         param1.destroy();
         var _loc2_:Boolean = mPendingDownloads.remove(param1);
         if(_loc2_ && mPendingDownloads.size == 0 && mTransitionToEmptyFunction != null)
         {
            mTransitionToEmptyFunction();
            mTransitionToEmptyFunction = null;
         }
      }
      
      public function setTransitionToEmptyCallback(param1:Function) : void
      {
         if(mPendingDownloads.size == 0 && param1 != null)
         {
            param1();
            mTransitionToEmptyFunction = null;
         }
         else
         {
            mTransitionToEmptyFunction = param1;
         }
      }
   }
}

