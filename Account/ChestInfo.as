package Account
{
   import Brain.AssetRepository.AssetLoadingComponent;
   import Brain.AssetRepository.SwfAsset;
   import Brain.Logger.Logger;
   import Facade.DBFacade;
   import GameMasterDictionary.GMChest;
   import GameMasterDictionary.GMRarity;
   import flash.display.DisplayObjectContainer;
   import flash.display.MovieClip;
   
   public class ChestInfo extends InventoryBaseInfo
   {
      
      private var mGMChestData:GMChest;
      
      private var mIsFromDungeonSummary:Boolean;
      
      public function ChestInfo(param1:DBFacade, param2:Object)
      {
         super(param1,param2);
         mIsFromDungeonSummary = false;
         if(param2 == null)
         {
            return;
         }
         mGMChestData = mDBFacade.gameMaster.chestsById.itemFor(mGMId);
         if(mGMChestData == null)
         {
            Logger.error("GMChest is null cannot find item for ID: " + mGMId);
         }
         else
         {
            mGMChestInfo = mGMChestData;
         }
      }
      
      public static function loadItemIcon(param1:String, param2:String, param3:DisplayObjectContainer, param4:DBFacade, param5:uint, param6:uint, param7:AssetLoadingComponent = null) : void
      {
         var swfPath:String = param1;
         var iconName:String = param2;
         var container:DisplayObjectContainer = param3;
         var dbFacade:DBFacade = param4;
         var desiredSize:uint = param5;
         var iconsNativeSize:uint = param6;
         var assetLoadingComponent:AssetLoadingComponent = param7;
         var destroyAssetLoaderOnCompletion:Boolean = false;
         if(assetLoadingComponent == null)
         {
            assetLoadingComponent = new AssetLoadingComponent(dbFacade);
            destroyAssetLoaderOnCompletion = true;
         }
         if(swfPath == null || swfPath == "")
         {
            Logger.error("swfPath provided to ItemInfo::loadItemIcon is empty or null.");
         }
         assetLoadingComponent.getSwfAsset(DBFacade.buildFullDownloadPath(swfPath),function(param1:SwfAsset):void
         {
            var _loc3_:Class = param1.getClass(iconName);
            if(_loc3_ == null)
            {
               Logger.error("Unable to get iconClass for iconName: " + iconName);
               return;
            }
            var _loc2_:MovieClip = new _loc3_();
            _loc2_.scaleX = _loc2_.scaleY = desiredSize / iconsNativeSize;
            container.addChild(_loc2_);
            if(destroyAssetLoaderOnCompletion)
            {
               assetLoadingComponent.destroy();
            }
         });
      }
      
      public static function loadItemIconFromId(param1:uint, param2:DisplayObjectContainer, param3:DBFacade, param4:uint, param5:uint, param6:AssetLoadingComponent = null) : void
      {
         var _loc7_:GMChest = param3.gameMaster.chestsById.itemFor(param1);
         loadItemIcon(_loc7_.IconSwf,_loc7_.IconName,param2,param3,param4,param5,param6);
      }
      
      override public function get iconScale() : Number
      {
         return 120;
      }
      
      override protected function parseJson(param1:Object) : void
      {
         if(param1 == null)
         {
            return;
         }
         mGMId = param1.chest_id as uint;
         mDatabaseId = param1.id as uint;
         mIsNew = false;
      }
      
      public function setParams(param1:uint) : void
      {
         mDatabaseId = param1;
         mGMId = mDBFacade.gameMaster.dooberById.itemFor(mDatabaseId).ChestId;
         mGMChestData = mDBFacade.gameMaster.chestsById.itemFor(mGMId);
         if(mGMChestData == null)
         {
            Logger.error("GMChest (setParams) is null cannot find item for ID: " + mGMId);
         }
         mGMChestInfo = mGMChestData;
      }
      
      public function isFromDungeonSummary() : Boolean
      {
         return mIsFromDungeonSummary;
      }
      
      public function setFromDungeonSummary() : void
      {
         mIsFromDungeonSummary = true;
      }
      
      override public function get uiSwfFilepath() : String
      {
         return mGMChestData.IconSwf;
      }
      
      override public function get iconName() : String
      {
         return mGMChestData.IconName;
      }
      
      override public function get hasColoredBackground() : Boolean
      {
         var _loc1_:GMRarity = mDBFacade.gameMaster.rarityByConstant.itemFor(mGMChestData.Rarity);
         return _loc1_ != null ? _loc1_.HasColoredBackground : false;
      }
      
      override public function get backgroundIconName() : String
      {
         var _loc1_:GMRarity = mDBFacade.gameMaster.rarityByConstant.itemFor(mGMChestData.Rarity);
         return _loc1_ != null ? _loc1_.BackgroundIcon : "";
      }
      
      override public function get backgroundSwfPath() : String
      {
         var _loc1_:GMRarity = mDBFacade.gameMaster.rarityByConstant.itemFor(mGMChestData.Rarity);
         return _loc1_ != null ? _loc1_.BackgroundSwf : "";
      }
      
      override public function get Name() : String
      {
         return mGMChestData.Name;
      }
      
      public function get rarity() : String
      {
         return mGMChestData.Rarity;
      }
      
      override public function get needsRenderer() : Boolean
      {
         return true;
      }
   }
}

