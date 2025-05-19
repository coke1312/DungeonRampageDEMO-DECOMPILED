package UI.FriendManager.States
{
   import Brain.UI.UIButton;
   import Facade.DBFacade;
   import Town.TownStateMachine;
   import UI.FriendManager.UIFriendManager;
   import flash.display.MovieClip;
   
   public class UIFMState
   {
      
      protected var mDBFacade:DBFacade;
      
      protected var mUIFriendManager:UIFriendManager;
      
      protected var mTownStateMachine:TownStateMachine;
      
      public function UIFMState(param1:DBFacade, param2:UIFriendManager, param3:TownStateMachine)
      {
         super();
         mDBFacade = param1;
         mUIFriendManager = param2;
         mTownStateMachine = param3;
      }
      
      public function enter() : void
      {
      }
      
      public function exit() : void
      {
      }
      
      public function createButton(param1:String, param2:String, param3:int, param4:int, param5:Function) : UIButton
      {
         var _loc7_:Class = mTownStateMachine.getTownAsset(param1);
         var _loc8_:MovieClip = new _loc7_() as MovieClip;
         var _loc6_:UIButton = new UIButton(mDBFacade,_loc8_);
         _loc6_.releaseCallback = param5;
         _loc8_.x = param3;
         _loc8_.y = param4;
         _loc6_.label.text = param2;
         mUIFriendManager.addToUI(_loc6_.root);
         return _loc6_;
      }
   }
}

