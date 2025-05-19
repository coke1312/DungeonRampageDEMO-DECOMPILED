package Facade
{
   import Actor.ActorRenderer;
   import Brain.AssetRepository.AssetLoadingComponent;
   import Brain.AssetRepository.JsonAsset;
   import Brain.AssetRepository.SwfAsset;
   import Brain.Logger.Logger;
   import GameMasterDictionary.GMHero;
   import GameMasterDictionary.GMNpc;
   import GameMasterDictionary.GMSkin;
   import GameMasterDictionary.GMWeaponItem;
   
   public class TrickleCacheLoader
   {
      
      public function TrickleCacheLoader()
      {
         super();
      }
      
      public static function swfAsset(param1:String, param2:DBFacade) : void
      {
         var name:String = param1;
         var dbFacade:DBFacade = param2;
         var trash_AssetLoadingComponent:AssetLoadingComponent = new AssetLoadingComponent(dbFacade);
         trash_AssetLoadingComponent.getSwfAsset(name,function(param1:SwfAsset):void
         {
         });
      }
      
      public static function tilelibrary(param1:String, param2:DBFacade) : void
      {
         var makeCallback:Function;
         var name:String = param1;
         var dbFacade:DBFacade = param2;
         var trash_AssetLoadingComponent:AssetLoadingComponent = new AssetLoadingComponent(dbFacade);
         if(dbFacade.getTileLibraryJson(name) == null)
         {
            makeCallback = function(param1:String):Function
            {
               var path:String = param1;
               return function(param1:JsonAsset):void
               {
                  dbFacade.AddTileLibraryJson(path,param1);
               };
            };
            loadJsonHelperFunction(trash_AssetLoadingComponent,DBFacade.buildFullDownloadPath(name),makeCallback(name));
         }
      }
      
      private static function loadJsonHelperFunction(param1:AssetLoadingComponent, param2:String, param3:Function) : void
      {
         var assetLoader:AssetLoadingComponent = param1;
         var path:String = param2;
         var successCallback:Function = param3;
         assetLoader.getJsonAsset(path,successCallback,function():void
         {
            Logger.error("Unable to load tileLibrary from path: " + path);
         });
      }
      
      public static function loadNPCSpriteSheet(param1:GMNpc, param2:DBFacade, param3:Vector.<String>) : void
      {
         ActorRenderer.cache_loadSpriteSheetAsset(param2,DBFacade.buildFullDownloadPath(param1.SwfFilepath),param1.SpriteHeight,param1.SpriteWidth,param1.AssetType,param3);
      }
      
      public static function loadHeroSpriteSheet(param1:DBFacade, param2:GMSkin, param3:Vector.<String> = null) : void
      {
         if(param3 == null)
         {
            param3 = new Vector.<String>();
         }
         var _loc4_:GMHero = param1.gameMaster.heroByConstant.itemFor(param2.ForHero);
         ActorRenderer.cache_loadSpriteSheetAsset(param1,DBFacade.buildFullDownloadPath(param2.SwfFilepath),param2.SpriteHeight,param2.SpriteWidth,param2.AssetType,param3);
      }
      
      public static function loadHero(param1:DBFacade, param2:uint) : void
      {
         var _loc5_:GMSkin = null;
         var _loc4_:GMSkin = param1.gameMaster.getSkinByType(param2);
         var _loc3_:GMHero = param1.gameMaster.getHeroByConstant(_loc4_.ForHero);
         if(_loc3_.Id == 106 && !param1.gameMaster.isSkinTypeADefaultSkin(_loc4_.Id))
         {
            _loc5_ = param1.gameMaster.getSkinByConstant(_loc3_.DefaultSkin);
            loadHeroSpriteSheet(param1,_loc5_);
         }
         loadHeroSpriteSheet(param1,_loc4_);
      }
      
      public static function swfVector(param1:Vector.<String>, param2:DBFacade) : void
      {
         var _loc4_:* = 0;
         var _loc3_:String = null;
         _loc4_ = 0;
         while(_loc4_ < param1.length)
         {
            _loc3_ = param1[_loc4_];
            swfAsset(_loc3_,param2);
            _loc4_++;
         }
      }
      
      public static function npcVector(param1:Vector.<uint>, param2:DBFacade) : void
      {
         var _loc5_:* = 0;
         var _loc7_:* = 0;
         var _loc3_:GMNpc = null;
         var _loc6_:* = undefined;
         var _loc4_:GMWeaponItem = null;
         _loc5_ = 0;
         while(_loc5_ < param1.length)
         {
            _loc7_ = param1[_loc5_];
            _loc3_ = param2.gameMaster.npcById.itemFor(_loc7_);
            if(_loc3_ != null)
            {
               if(_loc3_.SwfFilepath == null || _loc3_.SwfFilepath == "null")
               {
                  Logger.info("NPC with Costant: " + _loc3_.Constant + " does not contain a SwfFilePath.");
               }
               else
               {
                  _loc6_ = new Vector.<String>();
                  if(_loc3_.Weapon1 && _loc3_.Weapon1.length > 0)
                  {
                     _loc4_ = param2.gameMaster.weaponItemByConstant.itemFor(_loc3_.Weapon1);
                     if(_loc4_ != null)
                     {
                        if(_loc4_.WeaponAestheticList == null)
                        {
                           Logger.error("Unable to find aesthetics for npc weapon: " + _loc3_.Weapon1);
                           return;
                        }
                        _loc6_.push(_loc4_.WeaponAestheticList[0].ModelName);
                     }
                  }
                  loadNPCSpriteSheet(_loc3_,param2,_loc6_);
               }
            }
            else
            {
               trace(" No Npc Found For ",_loc7_);
            }
            _loc5_++;
         }
      }
   }
}

