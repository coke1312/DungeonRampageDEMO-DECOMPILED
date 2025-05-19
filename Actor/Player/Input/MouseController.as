package Actor.Player.Input
{
   import Actor.ActorGameObject;
   import Actor.Player.Input.DBMouseEvents.MouseDownOnActorEvent;
   import Actor.Player.Input.DBMouseEvents.MouseOutOnActorEvent;
   import Actor.Player.Input.DBMouseEvents.MouseOverOnActorEvent;
   import Actor.Player.Input.DBMouseEvents.MouseUpOnActorEvent;
   import Brain.Event.EventComponent;
   import Brain.Logger.Logger;
   import DistributedObjects.HeroGameObjectOwner;
   import Facade.DBFacade;
   import flash.events.MouseEvent;
   import flash.geom.Vector3D;
   
   public class MouseController implements IMouseController
   {
      
      protected var mDBFacade:DBFacade;
      
      protected var mHeroGameObjectOwner:HeroGameObjectOwner;
      
      protected var mEventComponent:EventComponent;
      
      protected var mInputVelocity:Vector3D;
      
      protected var mInputHeading:Vector3D;
      
      protected var mMouseDownActorThisFrame:ActorGameObject;
      
      protected var mMouseUpActorThisFrame:ActorGameObject;
      
      protected var mMouseOverActorThisFrame:ActorGameObject;
      
      protected var mMouseOutActorThisFrame:ActorGameObject;
      
      protected var mMouseDownThisFrame:Boolean = false;
      
      protected var mMouseUpThisFrame:Boolean = false;
      
      protected var mMouseDownPosition:Vector3D;
      
      protected var mMouseUpPosition:Vector3D;
      
      protected var mRightMouseDown:Boolean = false;
      
      protected var mMiddleMouseDown:Boolean = false;
      
      protected var mDungeonBusterControlActivatedThisFrame:Boolean = false;
      
      protected var mMouseDownActorPrevious:ActorGameObject;
      
      protected var mMouseUpActorPrevious:ActorGameObject;
      
      protected var mMouseOverActorPrevious:ActorGameObject;
      
      protected var mMouseOutActorPrevious:ActorGameObject;
      
      protected var mActorMousedOver:ActorGameObject;
      
      protected var mPotentialAttacksThisFrame:Array;
      
      private var mCombatDisabled:Boolean;
      
      public function MouseController(param1:DBFacade, param2:HeroGameObjectOwner)
      {
         super();
         mDBFacade = param1;
         mHeroGameObjectOwner = param2;
         mEventComponent = new EventComponent(mDBFacade);
         mPotentialAttacksThisFrame = [];
         mInputVelocity = new Vector3D();
         mCombatDisabled = false;
      }
      
      private function addListeners() : void
      {
         mEventComponent.addListener("MouseDownOnActorEvent",handleMouseDownOnActor);
         mEventComponent.addListener("MouseUpOnActorEvent",handleMouseUpOnActor);
         mEventComponent.addListener("MouseOverOnActorEvent",handleMouseOverOnActor);
         mEventComponent.addListener("MouseOutOnActorEvent",handleMouseOutOnActor);
         mEventComponent.addListener("DungeonBusterControlActivatedEvent",handleDungeonBusterControlActivated);
         mDBFacade.stageRef.addEventListener("mouseDown",handleMouseDown);
         mDBFacade.stageRef.addEventListener("mouseUp",handleMouseUp);
         mDBFacade.stageRef.addEventListener("rightMouseDown",handleRightMouseDown);
         mDBFacade.stageRef.addEventListener("rightMouseUp",handleRightMouseUp);
         mDBFacade.stageRef.addEventListener("middleMouseDown",handleMiddleMouseDown);
         mDBFacade.stageRef.addEventListener("middleMouseUp",handleMiddleMouseUp);
      }
      
      private function removeListeners() : void
      {
         mEventComponent.removeAllListeners();
         mDBFacade.stageRef.removeEventListener("mouseDown",handleMouseDown);
         mDBFacade.stageRef.removeEventListener("mouseUp",handleMouseUp);
         mDBFacade.stageRef.removeEventListener("rightMouseDown",handleRightMouseDown);
         mDBFacade.stageRef.removeEventListener("rightMouseUp",handleRightMouseUp);
         mDBFacade.stageRef.removeEventListener("middleMouseDown",handleMiddleMouseDown);
         mDBFacade.stageRef.removeEventListener("middleMouseUp",handleMiddleMouseUp);
      }
      
      protected function handleMouseDownOnActor(param1:MouseDownOnActorEvent) : void
      {
         mMouseDownActorThisFrame = param1.actor;
      }
      
      protected function handleMouseUpOnActor(param1:MouseUpOnActorEvent) : void
      {
         mMouseUpActorThisFrame = param1.actor;
      }
      
      protected function handleMouseOverOnActor(param1:MouseOverOnActorEvent) : void
      {
         mMouseOverActorThisFrame = param1.actor;
         mActorMousedOver = mMouseOverActorThisFrame;
         if(mMouseOverActorThisFrame.actorView && mActorMousedOver.team != mHeroGameObjectOwner.team)
         {
            mMouseOverActorThisFrame.actorView.mouseOverHighlight();
         }
      }
      
      protected function handleMouseOutOnActor(param1:MouseOutOnActorEvent) : void
      {
         mMouseOutActorThisFrame = param1.actor;
         if(mMouseOutActorThisFrame.actorView && mMouseOutActorThisFrame.team != mHeroGameObjectOwner.team)
         {
            mMouseOutActorThisFrame.actorView.mouseOverUnhighlight();
         }
         if(mActorMousedOver == mMouseOutActorThisFrame)
         {
            mActorMousedOver = null;
         }
      }
      
      private function handleDungeonBusterControlActivated(param1:DungeonBusterControlActivatedEvent) : void
      {
         mDungeonBusterControlActivatedThisFrame = true;
      }
      
      protected function handleMouseUp(param1:MouseEvent) : void
      {
         mMouseUpThisFrame = true;
         mMouseDownPosition = new Vector3D(param1.stageX,param1.stageY);
      }
      
      protected function handleMouseDown(param1:MouseEvent) : void
      {
         mMouseDownThisFrame = true;
         mMouseDownPosition = new Vector3D(param1.stageX,param1.stageY);
      }
      
      protected function handleRightMouseDown(param1:MouseEvent) : void
      {
         mRightMouseDown = true;
      }
      
      protected function handleRightMouseUp(param1:MouseEvent) : void
      {
         mRightMouseDown = false;
      }
      
      protected function handleMiddleMouseDown(param1:MouseEvent) : void
      {
         mMiddleMouseDown = true;
      }
      
      protected function handleMiddleMouseUp(param1:MouseEvent) : void
      {
         mMiddleMouseDown = false;
      }
      
      public function set combatDisabled(param1:Boolean) : void
      {
         mCombatDisabled = param1;
      }
      
      public function perFrameUpCall() : void
      {
         mPotentialAttacksThisFrame.length = 0;
         determineSelection();
         if(!mCombatDisabled)
         {
            determineAttacks();
         }
         determineMotion();
         flushMouseEventVars();
      }
      
      protected function determineMotion() : void
      {
         Logger.error("determineMotion function is meant to be virtual and overriden by the subclasses.");
      }
      
      protected function determineAttacks() : void
      {
         Logger.error("determineAttacks function is meant to be virtual and overriden by the subclasses.");
      }
      
      protected function determineSelection() : void
      {
         Logger.error("determineSelection function is meant to be virtual and overriden by the subclasses.");
      }
      
      private function flushMouseEventVars() : void
      {
         mMouseDownActorPrevious = mMouseDownActorThisFrame;
         mMouseUpActorPrevious = mMouseUpActorThisFrame;
         mMouseOverActorPrevious = mMouseOverActorThisFrame;
         mMouseOutActorPrevious = mMouseOutActorThisFrame;
         mMouseUpActorThisFrame = null;
         mMouseDownActorThisFrame = null;
         mMouseOverActorThisFrame = null;
         mMouseOutActorThisFrame = null;
         mMouseUpThisFrame = false;
         mMouseDownThisFrame = false;
         mDungeonBusterControlActivatedThisFrame = false;
         mMouseUpPosition = new Vector3D();
         mMouseDownPosition = new Vector3D();
      }
      
      public function move(param1:String) : Boolean
      {
         Logger.error("move function is meant to be virtual and overriden by the subclasses.");
         return false;
      }
      
      public function init() : void
      {
         addListeners();
      }
      
      public function stop() : void
      {
         removeListeners();
      }
      
      public function clearMovement() : void
      {
         Logger.error("clearMovement is meant to be virtual and overriden by the subclasses.");
      }
      
      public function get potentialAttacksThisFrame() : Array
      {
         return mPotentialAttacksThisFrame;
      }
      
      public function get inputVelocity() : Vector3D
      {
         return mInputVelocity;
      }
      
      public function get inputHeading() : Vector3D
      {
         return mInputHeading;
      }
      
      public function destroy() : void
      {
         stop();
         mEventComponent.destroy();
         mEventComponent = null;
      }
   }
}

