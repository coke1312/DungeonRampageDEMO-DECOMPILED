package Facade
{
   import Brain.AssetRepository.AssetLoaderInfo;
   import Brain.AssetRepository.JsonAsset;
   import Brain.Logger.Logger;
   
   public class Locale
   {
      
      public static const DEFAULT_NAMETAG:String = "DEFAULT_NAMETAG";
      
      private static var mStringTable:Object;
      
      public function Locale()
      {
         super();
      }
      
      public static function loadStrings(param1:DBFacade, param2:String, param3:Function) : void
      {
         var facade:DBFacade = param1;
         var locale:String = param2;
         var callback:Function = param3;
         var AsstetInfo:AssetLoaderInfo = new AssetLoaderInfo(DBFacade.buildFullDownloadPath("Resources/Locale/" + locale + ".json"),false);
         facade.assetRepository.getJsonAsset(AsstetInfo,function(param1:JsonAsset):void
         {
            Logger.debug("Loaded locale: " + locale);
            mStringTable = param1.json;
            callback();
         });
      }
      
      public static function getString(param1:String) : String
      {
         if(mStringTable == null)
         {
            Logger.warn("You cannot call getString before load has finished: " + param1);
            return param1;
         }
         var _loc2_:String = mStringTable.strings[param1];
         if(_loc2_ == null)
         {
            Logger.warn("Localized string not found: " + param1);
            return "mia:" + param1;
         }
         return _loc2_;
      }
      
      public static function getSubString(param1:String, param2:String) : String
      {
         if(mStringTable == null)
         {
            Logger.warn("You cannot call getSubString before load has finished: " + param1 + " subKey: " + param2);
            return param1;
         }
         var _loc3_:Object = mStringTable.strings[param1];
         if(_loc3_ == null)
         {
            Logger.error("Localized sub string not found: " + param1 + " subKey: " + param2);
            return param1;
         }
         var _loc4_:String = _loc3_[param2];
         if(_loc4_ == null)
         {
            Logger.error("Localized sub string not found: " + param2);
            return param1;
         }
         return _loc4_;
      }
      
      public static function getError(param1:int) : String
      {
         if(mStringTable == null)
         {
            Logger.warn("You cannot call getError before load has finished: " + param1.toString());
            return "Error (" + param1.toString() + ")";
         }
         var _loc2_:String = mStringTable.errors[param1.toString()];
         if(_loc2_ == null)
         {
            Logger.warn("Localized error string not found: " + param1.toString());
            _loc2_ = mStringTable.errors["DEF"];
            if(_loc2_ == null)
            {
               _loc2_ = "Error ";
            }
            _loc2_ += "(" + param1.toString() + ")";
         }
         return _loc2_;
      }
      
      public static function getStringForMastertype(param1:String) : String
      {
         var _loc2_:String = "MASTER_TYPE_" + param1;
         var _loc3_:String = getString(_loc2_);
         if(_loc3_ == _loc2_)
         {
            return param1;
         }
         return _loc2_;
      }
   }
}

