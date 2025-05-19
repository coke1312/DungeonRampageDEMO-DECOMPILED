package Brain.Utils
{
   import Brain.AssetRepository.AssetLoadingComponent;
   import Brain.AssetRepository.JsonAsset;
   import Brain.Facade.Facade;
   import Brain.Logger.Logger;
   import flash.external.ExternalInterface;
   import flash.system.Capabilities;
   
   public class ConfigManager
   {
      
      protected var mFacade:Facade;
      
      protected var mAssetLoadingComponent:AssetLoadingComponent;
      
      public var networkId:Number = 1;
      
      private var mJsonDictionaries:Array = [];
      
      private var mTotalFilePathsToOpen:int;
      
      private var mLoadedFiles:int = 0;
      
      private var mLoadedCallback:Function;
      
      private var mFailureCallback:Function;
      
      private var mIsInError:Boolean;
      
      private var mFilePathsToOpen:Array;
      
      public function ConfigManager(param1:Facade, param2:Array, param3:Function, param4:Function)
      {
         super();
         mIsInError = false;
         mFacade = param1;
         mAssetLoadingComponent = new AssetLoadingComponent(param1);
         mLoadedCallback = param3;
         mFailureCallback = param4;
         mTotalFilePathsToOpen = param2.length;
         mFilePathsToOpen = param2;
      }
      
      public function init() : void
      {
         var _loc1_:Object = null;
         var _loc2_:JsonAsset = null;
         var _loc3_:int = 0;
         if(Capabilities.playerType != "Desktop")
         {
            _loc1_ = ExternalInterface.call("Get_App_Parameters");
            Logger.info("Loading Configs From ExternalInterface = " + _loc1_);
         }
         if(_loc1_ != null)
         {
            Logger.info("Loading Configs From HTML host = " + _loc1_);
            mTotalFilePathsToOpen = 1;
            _loc2_ = new JsonAsset(_loc1_);
            jsonFileLoaded(_loc2_);
         }
         else
         {
            _loc3_ = 0;
            while(_loc3_ < mFilePathsToOpen.length)
            {
               Logger.info("Loading Config " + mFilePathsToOpen[_loc3_]);
               mAssetLoadingComponent.getJsonAsset(mFilePathsToOpen[_loc3_],jsonFileLoaded,wrappedJsonFileFailedCallback(mFilePathsToOpen[_loc3_]),false);
               _loc3_++;
            }
         }
      }
      
      public function isInError() : Boolean
      {
         return mIsInError;
      }
      
      private function wrappedJsonFileFailedCallback(param1:String) : Function
      {
         var path:String = param1;
         return function():void
         {
            jsonFileFailedCallback(path);
         };
      }
      
      private function jsonFileFailedCallback(param1:String) : void
      {
         mIsInError = true;
         if(mFailureCallback != null)
         {
            Logger.warn("Error occurred trying to load config json from path: " + param1);
            mFailureCallback();
         }
         else
         {
            Logger.error("Error occurred trying to load config json from path: " + param1);
         }
      }
      
      private function jsonFileLoaded(param1:JsonAsset) : void
      {
         var _loc2_:* = param1;
         mJsonDictionaries.push(_loc2_.json);
         networkId = getConfigNumber("NetworkId",1);
         Logger.info("App launched from network: " + networkId);
         ++mLoadedFiles;
         if(mTotalFilePathsToOpen == mLoadedFiles)
         {
            finishedLoadingFiles();
         }
      }
      
      private function findValue(param1:String) : *
      {
         var _loc2_:int = 0;
         _loc2_ = 0;
         while(_loc2_ < mJsonDictionaries.length)
         {
            if(mJsonDictionaries[_loc2_][param1] != null)
            {
               return mJsonDictionaries[_loc2_][param1];
            }
            _loc2_++;
         }
         return null;
      }
      
      public function GetValueOrDefault(param1:String, param2:Object) : Object
      {
         var _loc3_:Object = findValue(param1);
         if(_loc3_ != null)
         {
            return _loc3_;
         }
         return param2;
      }
      
      public function getConfigBoolean(param1:String, param2:Boolean) : Boolean
      {
         var _loc3_:Boolean = false;
         var _loc4_:Object = findValue(param1);
         if(_loc4_ != null)
         {
            return _loc4_ as Boolean;
         }
         return param2;
      }
      
      public function getConfigNumber(param1:String, param2:Number) : Number
      {
         var _loc3_:Number = NaN;
         var _loc4_:Object = findValue(param1);
         if(_loc4_ != null)
         {
            return _loc4_ as Number;
         }
         return param2;
      }
      
      public function getConfigString(param1:String, param2:String) : String
      {
         var _loc3_:String = null;
         var _loc4_:Object = findValue(param1);
         if(_loc4_ != null)
         {
            _loc3_ = _loc4_ as String;
            if(_loc3_ != null)
            {
               return _loc3_;
            }
            throw new Error("Config string: " + param1 + " returned a value: " + _loc4_ + " which cannot be converted to a String.");
         }
         return param2;
      }
      
      public function getConfigObject(param1:String, param2:Object) : Object
      {
         return findValue(param1);
      }
      
      protected function finishedLoadingFiles() : void
      {
         if(mLoadedCallback != null)
         {
            mLoadedCallback();
         }
      }
      
      public function destroy() : void
      {
      }
   }
}

