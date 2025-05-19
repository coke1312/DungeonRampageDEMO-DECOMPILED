package Town
{
   import Facade.DBFacade;
   import Metrics.PixelTracker;
   import UI.UIShop;
   
   public class ShopTownSubState extends TownSubState
   {
      
      public static const NAME:String = "ShopTownSubState";
      
      private var mUIShop:UIShop;
      
      private var mStartAtCategoryTab:String = "";
      
      public function ShopTownSubState(param1:DBFacade, param2:TownStateMachine)
      {
         super(param1,param2,"ShopTownSubState");
      }
      
      override public function enterState() : void
      {
         super.enterState();
         if(mUIShop)
         {
            mUIShop.refresh(mStartAtCategoryTab);
            mUIShop.animateEntry();
         }
         mTownStateMachine.townHeader.showCloseButton(true);
         PixelTracker.visitedStore(mDBFacade);
      }
      
      override public function exitState() : void
      {
         mUIShop.processChosenAvatar();
         super.exitState();
      }
      
      override public function destroy() : void
      {
         super.destroy();
         mUIShop.destroy();
         mUIShop = null;
      }
      
      override protected function setupState() : void
      {
         super.setupState();
         mUIShop = new UIShop(mDBFacade,mTownStateMachine.townSwf,mRootMovieClip,mTownStateMachine.townHeader);
      }
      
      public function set startAtCategoryTab(param1:String) : void
      {
         mStartAtCategoryTab = param1;
      }
   }
}

