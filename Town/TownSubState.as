package Town
{
   import Brain.SceneGraph.SceneGraphComponent;
   import Brain.StateMachine.State;
   import Brain.UI.UIButton;
   import Facade.DBFacade;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   
   public class TownSubState extends State
   {
      
      private static var FRIEND_NAME_HIGHLIGHT_COLOR:uint = 16764232;
      
      protected var mTownStateMachine:TownStateMachine;
      
      protected var mRoot:Sprite = new Sprite();
      
      protected var mRootMovieClip:MovieClip;
      
      protected var mHomeButton:UIButton;
      
      protected var mDBFacade:DBFacade;
      
      protected var mSceneGraphComponent:SceneGraphComponent;
      
      private var mTimeEnter:Number;
      
      public function TownSubState(param1:DBFacade, param2:TownStateMachine, param3:String)
      {
         super(param3);
         mDBFacade = param1;
         mTownStateMachine = param2;
      }
      
      override public function destroy() : void
      {
         if(mHomeButton)
         {
            mHomeButton.destroy();
         }
         mTownStateMachine = null;
         mDBFacade = null;
         super.destroy();
      }
      
      public function set rootMovieClip(param1:MovieClip) : void
      {
         mRootMovieClip = param1;
         mRoot.addChild(mRootMovieClip);
         setupState();
      }
      
      protected function setupState() : void
      {
      }
      
      override public function enterState() : void
      {
         super.enterState();
         mDBFacade.mouseCursorManager.disable = false;
         mDBFacade.mouseCursorManager.pushMouseCursor("auto");
         mTimeEnter = mDBFacade.gameClock.realTime;
         mDBFacade.metrics.log("AreaEnter",{"areaType":this.name});
         mSceneGraphComponent = new SceneGraphComponent(mDBFacade);
         mSceneGraphComponent.addChild(mRoot,50);
         if(mTownStateMachine.leaderboard)
         {
            mTownStateMachine.leaderboard.hidePopup();
         }
      }
      
      override public function exitState() : void
      {
         mDBFacade.mouseCursorManager.popMouseCursor();
         var _loc1_:uint = (mDBFacade.gameClock.realTime - mTimeEnter) / 1000;
         mDBFacade.metrics.log("AreaExit",{
            "areaType":this.name,
            "timeSpentSeconds":_loc1_
         });
         mSceneGraphComponent.removeChild(mRoot);
         mSceneGraphComponent.destroy();
         mSceneGraphComponent = null;
         super.exitState();
      }
   }
}

