package Brain.AssetRepository
{
   public class AssetLoadingTracker
   {
      
      public var pendingLoadCallback:Function;
      
      public var pendingErrorCallback:Function;
      
      public var assetLoadingComponent:AssetLoadingComponent;
      
      public var assetKey:String;
      
      public function AssetLoadingTracker(param1:String, param2:AssetLoadingComponent, param3:Function, param4:Function)
      {
         super();
         this.assetKey = param1;
         this.assetLoadingComponent = param2;
         this.pendingLoadCallback = param3;
         this.pendingErrorCallback = param4;
         this.assetLoadingComponent.mPendingDownloads.add(this);
      }
      
      public function errorCallback() : void
      {
         if(pendingErrorCallback != null)
         {
            pendingErrorCallback();
         }
         if(assetLoadingComponent != null)
         {
            assetLoadingComponent.RemoveLoader(this);
         }
      }
      
      public function successCallback(param1:Asset) : void
      {
         if(pendingLoadCallback != null)
         {
            pendingLoadCallback(param1);
         }
         if(assetLoadingComponent != null)
         {
            assetLoadingComponent.RemoveLoader(this);
         }
      }
      
      public function destroy() : void
      {
         pendingLoadCallback = null;
         pendingErrorCallback = null;
         assetLoadingComponent = null;
         assetKey = null;
      }
   }
}

