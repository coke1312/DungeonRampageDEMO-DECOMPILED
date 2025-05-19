package UI
{
   import Account.StackableInfo;
   import Brain.AssetRepository.SwfAsset;
   import Brain.UI.UIObject;
   import Facade.DBFacade;
   import GameMasterDictionary.GMStackable;
   import flash.display.MovieClip;
   import org.as3commons.collections.framework.IMapIterator;
   
   public class UIVictoryBoosterPopup extends DBUIPopup
   {
      
      protected static const SWF_PATH:String = "Resources/Art2D/UI/db_UI_score_report.swf";
      
      protected static const POPUP_CLASS_NAME:String = "boosterBonusPopup";
      
      public var expStack:GMStackable;
      
      public var goldStack:GMStackable;
      
      private var mExpObject:UIObject;
      
      private var mGoldObject:UIObject;
      
      public function UIVictoryBoosterPopup(param1:DBFacade, param2:String = "", param3:* = null, param4:Boolean = true, param5:Function = null)
      {
         var _loc6_:StackableInfo = null;
         var _loc7_:GMStackable = null;
         var _loc8_:IMapIterator = param1.dbAccountInfo.inventoryInfo.stackables.iterator() as IMapIterator;
         while(_loc8_.hasNext())
         {
            _loc6_ = _loc8_.next();
            if(_loc6_.isEquipped)
            {
               _loc7_ = _loc6_.gmStackable;
               if(_loc7_.ExpMult > 0)
               {
                  expStack = _loc7_;
               }
               else if(_loc7_.GoldMult > 0)
               {
                  goldStack = _loc7_;
               }
            }
         }
         super(param1,param2,param3,param4,false,param5);
         if(mCurtainActive)
         {
            removeCurtain();
         }
      }
      
      override protected function getSwfPath() : String
      {
         return "Resources/Art2D/UI/db_UI_score_report.swf";
      }
      
      override protected function getClassName() : String
      {
         return "boosterBonusPopup";
      }
      
      override protected function setupUI(param1:SwfAsset, param2:String, param3:*, param4:Boolean, param5:Function) : void
      {
         var swfAsset:SwfAsset = param1;
         var titleText:String = param2;
         var content:* = param3;
         var allowClose:Boolean = param4;
         var closeCallback:Function = param5;
         super.setupUI(swfAsset,titleText,content,allowClose,closeCallback);
         mPopup.visible = false;
         mPopup.potion_slot_A.visible = false;
         mPopup.potion_slot_B.visible = false;
         mPopup.star.visible = false;
         mPopup.coins.visible = false;
         mPopup.text_value_slot_A.visible = false;
         mPopup.text_value_slot_B.visible = false;
         mPopup.text_value_slot_A.text = "";
         mPopup.text_value_slot_B.text = "";
         mAssetLoadingComponent.getSwfAsset(DBFacade.buildFullDownloadPath("Resources/Art2D/Icons/Items/db_icons_items.swf"),function(param1:SwfAsset):void
         {
            setupStackIcons(param1);
         });
      }
      
      protected function setupStackIcons(param1:SwfAsset) : void
      {
         var _loc3_:Class = null;
         var _loc2_:MovieClip = null;
         if(expStack)
         {
            mExpObject = new UIObject(mDBFacade,mPopup.potion_slot_A,105);
            _loc3_ = param1.getClass(expStack.IconName);
            _loc2_ = new _loc3_();
            _loc2_.scaleX = _loc2_.scaleY = 72 / 100;
            _loc2_.y -= 8;
            mExpObject.root.addChild(_loc2_);
            mExpObject.tooltip.title_label.text = expStack.Name.toUpperCase();
            mExpObject.tooltip.description_label.text = expStack.Description;
            mPopup.visible = true;
            mPopup.potion_slot_A.visible = true;
            mPopup.star.visible = true;
            mPopup.text_value_slot_A.visible = true;
         }
         if(goldStack)
         {
            mGoldObject = new UIObject(mDBFacade,mPopup.potion_slot_B);
            _loc3_ = param1.getClass(goldStack.IconName);
            _loc2_ = new _loc3_();
            _loc2_.scaleX = _loc2_.scaleY = 72 / 100;
            _loc2_.y -= 8;
            mGoldObject.root.addChild(_loc2_);
            mGoldObject.tooltip.title_label.text = goldStack.Name.toUpperCase();
            mGoldObject.tooltip.description_label.text = goldStack.Description;
            mPopup.visible = true;
            mPopup.potion_slot_B.visible = true;
            mPopup.coins.visible = true;
            mPopup.text_value_slot_B.visible = true;
         }
      }
      
      public function setExp(param1:int) : void
      {
         mPopup.text_value_slot_A.text = "+" + param1.toString();
      }
      
      public function setGold(param1:int) : void
      {
         mPopup.text_value_slot_B.text = "+" + param1.toString();
      }
      
      override public function destroy() : void
      {
         if(mDBFacade)
         {
            super.destroy();
         }
         if(mExpObject)
         {
            mExpObject.destroy();
            mExpObject = null;
            expStack = null;
         }
         if(mGoldObject)
         {
            mGoldObject.destroy();
            mGoldObject = null;
            goldStack = null;
         }
      }
   }
}

