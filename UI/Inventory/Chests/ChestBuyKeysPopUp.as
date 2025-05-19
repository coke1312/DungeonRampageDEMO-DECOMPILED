package UI.Inventory.Chests
{
   import Account.ChestInfo;
   import Brain.AssetRepository.AssetLoadingComponent;
   import Brain.AssetRepository.SwfAsset;
   import Brain.Render.MovieClipRenderer;
   import Brain.SceneGraph.SceneGraphComponent;
   import Brain.UI.UIButton;
   import Facade.DBFacade;
   import Facade.Locale;
   import GameMasterDictionary.GMChest;
   import GameMasterDictionary.GMRarity;
   import UI.UIHud;
   import flash.display.MovieClip;
   
   public class ChestBuyKeysPopUp
   {
      
      private var mDBFacade:DBFacade;
      
      private var mAssetLoadingComponent:AssetLoadingComponent;
      
      private var mSceneGraphComponent:SceneGraphComponent;
      
      private var mRoot:MovieClip;
      
      private var mBuyCoinButton:UIButton;
      
      private var mBuyGemButton:UIButton;
      
      private var mCloseButton:UIButton;
      
      private var mRenderer:MovieClipRenderer;
      
      private var mChestKeySlots:Vector.<ChestKeySlot>;
      
      public function ChestBuyKeysPopUp(param1:DBFacade, param2:AssetLoadingComponent, param3:SceneGraphComponent, param4:SwfAsset, param5:GMChest, param6:Function, param7:Function, param8:Function, param9:Function, param10:Boolean = false)
      {
         var openKeyChestClass:Class;
         var swfPath:String;
         var iconName:String;
         var rarity:GMRarity;
         var bgColoredExists:Boolean;
         var bgSwfPath:String;
         var bgIconName:String;
         var coinCostForChestKey:Number;
         var cashCostForChestKey:Number;
         var i:int;
         var dbFacade:DBFacade = param1;
         var assetLoadingComponent:AssetLoadingComponent = param2;
         var sceneGraphComponent:SceneGraphComponent = param3;
         var swfAsset:SwfAsset = param4;
         var selectedGMChest:GMChest = param5;
         var chestBuyCoinCallback:Function = param6;
         var chestBuyGemCallback:Function = param7;
         var closeKeylessChestPopup:Function = param8;
         var refreshHeroInfoCallback:Function = param9;
         var isFromSummary:Boolean = param10;
         super();
         mDBFacade = dbFacade;
         mAssetLoadingComponent = assetLoadingComponent;
         mSceneGraphComponent = sceneGraphComponent;
         openKeyChestClass = UIHud.isThisAConsumbleChestId(selectedGMChest.Id) ? swfAsset.getClass("popup_itemBox_open") : swfAsset.getClass("popup_chest_keyless");
         mRoot = new openKeyChestClass();
         mRoot.x = 380;
         mRoot.y = 240;
         mRoot.title_label.text = isFromSummary ? Locale.getString("TREASURE_FOUND") : Locale.getString(selectedGMChest.Name);
         if(mRoot.description_label)
         {
            mRoot.description_label.text = Locale.getString("BUY_KEY_TO_OPEN") + selectedGMChest.Rarity + Locale.getString("CHEST_!");
         }
         swfPath = selectedGMChest.IconSwf;
         iconName = selectedGMChest.IconName;
         ChestInfo.loadItemIcon(swfPath,iconName,mRoot.content,mDBFacade,150,150,mAssetLoadingComponent);
         mRoot.content.y = UIHud.isThisAConsumbleChestId(selectedGMChest.Id) ? -6 : -35;
         mRenderer = new MovieClipRenderer(mDBFacade,mRoot.content);
         mRenderer.play(0,true);
         rarity = mDBFacade.gameMaster.rarityByConstant.itemFor(selectedGMChest.Rarity);
         bgColoredExists = rarity.HasColoredBackground;
         bgSwfPath = rarity.BackgroundSwf;
         bgIconName = rarity.BackgroundIcon;
         if(bgColoredExists)
         {
            mAssetLoadingComponent.getSwfAsset(DBFacade.buildFullDownloadPath(bgSwfPath),function(param1:SwfAsset):void
            {
               var _loc3_:MovieClip = null;
               var _loc2_:Class = param1.getClass(bgIconName);
               if(_loc2_)
               {
                  _loc3_ = new _loc2_() as MovieClip;
                  mRoot.content.addChildAt(_loc3_,0);
                  _loc3_.scaleX = _loc3_.scaleY = 1.5;
               }
            });
         }
         coinCostForChestKey = 0;
         cashCostForChestKey = 0;
         i = 0;
         while(i < 6)
         {
            if(mDBFacade.dbAccountInfo.inventoryInfo.keys[i].gmKey.ChestId == selectedGMChest.Id)
            {
               coinCostForChestKey = mDBFacade.dbAccountInfo.inventoryInfo.keys[i].gmKeyOffer.CoinOffer.Price;
               cashCostForChestKey = mDBFacade.dbAccountInfo.inventoryInfo.keys[i].gmKeyOffer.Price;
            }
            ++i;
         }
         mBuyCoinButton = new UIButton(mDBFacade,mRoot.coin_button);
         mBuyCoinButton.releaseCallback = chestBuyCoinCallback(coinCostForChestKey);
         mBuyCoinButton.label.text = coinCostForChestKey.toString();
         mBuyGemButton = new UIButton(mDBFacade,mRoot.gem_button);
         mBuyGemButton.releaseCallback = chestBuyGemCallback(cashCostForChestKey);
         mBuyGemButton.label.text = cashCostForChestKey.toString();
         mCloseButton = new UIButton(mDBFacade,mRoot.close);
         mCloseButton.releaseCallback = closeKeylessChestPopup;
         mRoot.coin_icon.mouseEnabled = false;
         mRoot.coin_icon.mouseChildren = false;
         mRoot.gem_icon.mouseEnabled = false;
         mRoot.gem_icon.mouseChildren = false;
         if(!UIHud.isThisAConsumbleChestId(selectedGMChest.Id))
         {
            createKeySlots(selectedGMChest);
            refreshHeroInfoCallback(mRoot);
         }
         mSceneGraphComponent.addChild(mRoot,105);
      }
      
      private function createKeySlots(param1:GMChest) : void
      {
         var _loc3_:int = 0;
         var _loc2_:MovieClip = null;
         mChestKeySlots = new Vector.<ChestKeySlot>();
         _loc3_ = 0;
         while(_loc3_ < 4)
         {
            _loc2_ = mRoot.getChildByName("slot_" + _loc3_.toString()) as MovieClip;
            mChestKeySlots.push(new ChestKeySlot(mDBFacade,_loc2_,mDBFacade.dbAccountInfo.inventoryInfo.keys[_loc3_],mAssetLoadingComponent));
            if(param1.Id == mChestKeySlots[_loc3_].keyInfo.gmKey.ChestId)
            {
               mChestKeySlots[_loc3_].setSelected(true);
            }
            else
            {
               mChestKeySlots[_loc3_].setSelected(false);
            }
            _loc3_++;
         }
      }
      
      public function get root() : MovieClip
      {
         return mRoot;
      }
      
      public function destroy() : void
      {
         var _loc1_:int = 0;
         mSceneGraphComponent.removeChild(mRoot);
         mDBFacade = null;
         mAssetLoadingComponent = null;
         mBuyCoinButton.destroy();
         mBuyCoinButton = null;
         mBuyGemButton.destroy();
         mBuyGemButton = null;
         mRenderer.destroy();
         mRenderer = null;
         if(mChestKeySlots)
         {
            _loc1_ = 0;
            while(_loc1_ < mChestKeySlots.length)
            {
               mChestKeySlots[_loc1_].destroy();
               _loc1_++;
            }
            mChestKeySlots.splice(0,mChestKeySlots.length);
            mChestKeySlots = null;
         }
         mRoot = null;
      }
   }
}

