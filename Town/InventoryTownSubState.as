package Town
{
   import Brain.Event.EventComponent;
   import Brain.UI.UIButton;
   import Events.DBAccountResponseEvent;
   import Facade.DBFacade;
   import UI.Inventory.UIInventory;
   
   public class InventoryTownSubState extends TownSubState
   {
      
      public static const NAME:String = "InventoryTownSubState";
      
      private var mUIInventory:UIInventory;
      
      private var mEventComponent:EventComponent;
      
      private var mBackButton:UIButton;
      
      private var mStartAtCategoryTab:String = "";
      
      public function InventoryTownSubState(param1:DBFacade, param2:TownStateMachine)
      {
         super(param1,param2,"InventoryTownSubState");
         mEventComponent = new EventComponent(mDBFacade);
      }
      
      override public function destroy() : void
      {
         if(mUIInventory)
         {
            mUIInventory.destroy();
            mUIInventory = null;
         }
         mEventComponent.destroy();
         super.destroy();
      }
      
      override protected function setupState() : void
      {
         super.setupState();
         mUIInventory = new UIInventory(mDBFacade,mTownStateMachine.townHeader);
      }
      
      public function setRevlealedState(param1:uint, param2:uint, param3:Boolean = false) : void
      {
         mUIInventory.setRevealedState(param1,param2,param3);
      }
      
      override public function enterState() : void
      {
         mRoot.addChild(mUIInventory.root);
         super.enterState();
         mTownStateMachine.townHeader.showCloseButton(true);
         if(mStartAtCategoryTab != "")
         {
            mUIInventory.currentTab = mStartAtCategoryTab;
         }
         mEventComponent.addListener("DB_ACCOUNT_INFO_RESPONSE",function(param1:DBAccountResponseEvent):void
         {
            mUIInventory.refresh();
         });
         mUIInventory.refresh(true);
         mUIInventory.animateEntry();
      }
      
      override public function exitState() : void
      {
         mRoot.removeChild(mUIInventory.root);
         mUIInventory.exitState();
         mEventComponent.removeListener("DB_ACCOUNT_INFO_RESPONSE");
         super.exitState();
      }
      
      public function set startAtCategoryTab(param1:String) : void
      {
         mStartAtCategoryTab = param1;
      }
   }
}

