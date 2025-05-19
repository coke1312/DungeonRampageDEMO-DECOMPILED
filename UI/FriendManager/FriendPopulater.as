package UI.FriendManager
{
   import Account.FriendInfo;
   import Brain.UI.UIButton;
   import Brain.UI.UIToggleButton;
   import Facade.DBFacade;
   import Town.TownStateMachine;
   import UI.UIPagingPanel;
   import flash.display.DisplayObject;
   import flash.display.MovieClip;
   import flash.geom.Point;
   import org.as3commons.collections.Map;
   
   public class FriendPopulater
   {
      
      public static const TOTAL_IN_ROW:uint = 5;
      
      public static const TOTAL_IN_COL:uint = 3;
      
      public static const FRIEND_POPULATER_POS_X:Number = 370.9;
      
      public static const FRIEND_POPULATER_POS_Y:Number = 363.3;
      
      public static const FRIEND_POPULATER_CLASS:String = "friends_populater";
      
      private var mFriendPopulaterMC:MovieClip;
      
      private var mPagination:UIPagingPanel;
      
      private var mCurrentPage:uint;
      
      private var mTotalPages:uint;
      
      private var mDBFacade:DBFacade;
      
      private var mUIFriendManager:UIFriendManager;
      
      private var mTownStateMachine:TownStateMachine;
      
      private var mListOfFriends:Vector.<FriendInfo>;
      
      private var mListOfFriendSlots:Vector.<MovieClip>;
      
      private var mFriendSelectedToggles:Map;
      
      private var mFriendsSelectedAcrossPages:Map;
      
      private var togglesSelectedArray:Array;
      
      private var mSelectAllButton:UIButton;
      
      private var mSelectNoneButton:UIButton;
      
      public function FriendPopulater(param1:DBFacade, param2:TownStateMachine, param3:Vector.<FriendInfo>, param4:UIFriendManager)
      {
         super();
         mDBFacade = param1;
         mTownStateMachine = param2;
         mListOfFriends = param3;
         mUIFriendManager = param4;
         mListOfFriendSlots = new Vector.<MovieClip>();
         mFriendSelectedToggles = new Map();
         mFriendsSelectedAcrossPages = new Map();
         togglesSelectedArray = [];
         var _loc5_:Class = mTownStateMachine.getTownAsset("friends_populater");
         mFriendPopulaterMC = new _loc5_();
         mFriendPopulaterMC.x = 370.9;
         mFriendPopulaterMC.y = 363.3;
         mUIFriendManager.addToUI(mFriendPopulaterMC);
         createSelectionOptionsUI();
         createPagination();
      }
      
      private function createSelectionOptionsUI() : void
      {
         mFriendPopulaterMC.fm_selection_options.visible = false;
      }
      
      private function createPagination() : void
      {
         mTotalPages = 1 + Math.floor(mListOfFriends.length / (5 * 3));
         mPagination = new UIPagingPanel(mDBFacade,0,mFriendPopulaterMC.pagination_friends,mTownStateMachine.townSwf.getClass("pagination_button"),setCurrentPage);
         setCurrentPage(0);
      }
      
      private function refreshPagination(param1:uint) : void
      {
         mPagination.currentPage = mTotalPages ? Math.min(mTotalPages - 1,param1) : 0;
         mPagination.numPages = mTotalPages;
         mPagination.visible = true;
      }
      
      private function setCurrentPage(param1:uint) : void
      {
         var _loc2_:int = 0;
         mCurrentPage = param1;
         refreshPagination(param1);
         _loc2_ = 0;
         while(_loc2_ < mListOfFriendSlots.length)
         {
            mUIFriendManager.removeFromUI(mListOfFriendSlots[_loc2_]);
            _loc2_++;
         }
         mListOfFriendSlots.splice(0,mListOfFriendSlots.length);
         mFriendSelectedToggles.clear();
         populateUIOnPage(param1);
      }
      
      private function populateFriendSlot(param1:uint, param2:FriendInfo) : void
      {
         var _loc8_:Class = mTownStateMachine.getTownAsset("friend_slot");
         var _loc5_:MovieClip = new _loc8_() as MovieClip;
         var _loc7_:MovieClip = mFriendPopulaterMC.getChildByName("slot_" + param1.toString()) as MovieClip;
         var _loc9_:Point = new Point(mFriendPopulaterMC.x - 370.9,mFriendPopulaterMC.y - 363.3);
         _loc5_.x = _loc7_.localToGlobal(_loc9_).x - _loc5_.width / 2 - 3;
         _loc5_.y = _loc7_.localToGlobal(_loc9_).y - _loc5_.height / 2 - 5;
         _loc5_.friend_name.text = param2.name;
         var _loc3_:Boolean = true;
         if(mDBFacade.isFacebookPlayer)
         {
            _loc3_ = false;
         }
         var _loc4_:DisplayObject = param2.clonePic();
         _loc4_.x = 0;
         _loc4_.y = 5;
         if(_loc3_)
         {
            _loc4_.scaleX = _loc4_.scaleY = 1.05;
            _loc5_.friend_pic.addChild(_loc4_);
            _loc5_.friend_pic.default_pic.visible = false;
         }
         else
         {
            _loc5_.friend_pic.addChild(_loc4_);
            _loc5_.friend_pic.default_pic.visible = false;
         }
         if(mDBFacade.dbAccountInfo.giftExcludeIds.indexOf(param2.excludeId) < 0)
         {
            _loc5_.gift.visible = false;
         }
         else
         {
            _loc5_.gift.visible = true;
         }
         _loc5_.friend_pic.you_online.visible = false;
         _loc5_.friend_pic.friend_offline.visible = false;
         _loc5_.friend_pic.friend_online.visible = false;
         _loc5_.join.visible = false;
         if(param2.isOnline())
         {
            _loc5_.friend_pic.friend_online.visible = false;
         }
         else
         {
            _loc5_.friend_pic.friend_offline.visible = false;
         }
         _loc5_.friend_level.level.text = param2.trophies.toString();
         var _loc6_:Boolean = mFriendsSelectedAcrossPages.hasKey(mCurrentPage * (5 * 3) + param1);
         mFriendSelectedToggles.add(param1,new UIToggleButton(mDBFacade,param1,_loc5_.friends_toggle,_loc6_,changeToggleStatusCallback));
         mUIFriendManager.addToUI(_loc5_);
         mListOfFriendSlots.push(_loc5_);
      }
      
      private function changeToggleStatusCallback(param1:uint, param2:Boolean) : void
      {
         if(mFriendsSelectedAcrossPages.hasKey(mCurrentPage * (5 * 3) + param1))
         {
            mFriendsSelectedAcrossPages.removeKey(mCurrentPage * (5 * 3) + param1);
         }
         else
         {
            mFriendsSelectedAcrossPages.add(mCurrentPage * (5 * 3) + param1,param2);
         }
      }
      
      private function populateUIOnPage(param1:uint) : void
      {
         mListOfFriendSlots.splice(0,mListOfFriendSlots.length);
         var _loc3_:int = 0;
         var _loc4_:int = param1 * (5 * 3);
         var _loc2_:uint = uint(_loc4_ + 5 * 3);
         if(_loc2_ > mListOfFriends.length)
         {
            _loc2_ -= _loc2_ - mListOfFriends.length;
         }
         while(_loc4_ < _loc2_)
         {
            populateFriendSlot(_loc3_,mListOfFriends[_loc4_]);
            _loc4_++;
            _loc3_++;
         }
      }
      
      public function refreshGiftedOnCurrentPage() : void
      {
         var _loc3_:* = null;
         var _loc4_:* = 0;
         var _loc2_:int = mCurrentPage * (5 * 3);
         var _loc1_:int = (mCurrentPage + 1) * (5 * 3) - 1;
         _loc4_ = _loc2_;
         while(_loc4_ < mListOfFriends.length)
         {
            if(_loc4_ > _loc1_)
            {
               break;
            }
            if(mDBFacade.dbAccountInfo.giftExcludeIds.indexOf(mListOfFriends[_loc4_].excludeId) < 0)
            {
               mListOfFriendSlots[_loc4_ - _loc2_].gift.visible = false;
            }
            else
            {
               mListOfFriendSlots[_loc4_ - _loc2_].gift.visible = true;
            }
            _loc4_++;
         }
      }
      
      public function getSelectedToggles() : Array
      {
         togglesSelectedArray = mFriendsSelectedAcrossPages.keysToArray();
         return togglesSelectedArray;
      }
      
      public function destroy() : void
      {
         var _loc2_:UIToggleButton = null;
         mListOfFriends = null;
         mListOfFriendSlots.splice(0,mListOfFriendSlots.length);
         mListOfFriendSlots = null;
         if(mPagination != null)
         {
            mPagination.destroy();
            mPagination = null;
         }
         mUIFriendManager.removeFromUI(mFriendPopulaterMC);
         mFriendPopulaterMC = null;
         mDBFacade = null;
         mUIFriendManager = null;
         var _loc1_:Array = mFriendSelectedToggles.keysToArray();
         for each(var _loc3_ in _loc1_)
         {
            _loc2_ = mFriendSelectedToggles.itemFor(_loc3_);
            _loc2_.destroy();
         }
         mFriendSelectedToggles = null;
         mFriendsSelectedAcrossPages = null;
         togglesSelectedArray = null;
      }
   }
}

