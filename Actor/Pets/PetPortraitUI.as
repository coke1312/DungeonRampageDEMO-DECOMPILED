package Actor.Pets
{
   import Account.ItemInfo;
   import Brain.Clock.GameClock;
   import Brain.Event.EventComponent;
   import Brain.Render.MovieClipRenderer;
   import Brain.UI.UIObject;
   import Brain.UI.UIProgressBar;
   import Brain.WorkLoop.LogicalWorkComponent;
   import Brain.WorkLoop.Task;
   import DistributedObjects.NPCGameObject;
   import Events.GameObjectEvent;
   import Events.HpEvent;
   import Facade.DBFacade;
   import Facade.Locale;
   import flash.display.MovieClip;
   
   public class PetPortraitUI extends UIObject
   {
      
      private static const PET_PORTRAIT_ICON_SIZE:uint = 80;
      
      private static const PET_NON_RESPAWNING_DEATH_FADE_OUT_TIME:uint = 2;
      
      private static const PET_RESPAWNS_IN:String = "PET_RESPAWNS_IN";
      
      private var mRespawnTask:Task;
      
      private var mDBFacade:DBFacade;
      
      private var mLogicalWorkComponent:LogicalWorkComponent;
      
      private var mEventComponent:EventComponent;
      
      private var mPetNPCGameObject:NPCGameObject;
      
      private var mNoPetUI:UIObject;
      
      private var mHpBar:UIProgressBar;
      
      private var mCoolDownRenderer:MovieClipRenderer;
      
      private var mCoolDownClipLength:Number;
      
      private var mIsDead:Boolean = false;
      
      public function PetPortraitUI(param1:DBFacade, param2:MovieClip, param3:MovieClip, param4:NPCGameObject)
      {
         super(param1,param2,0,true);
         mDBFacade = param1;
         if(param3)
         {
            mNoPetUI = new UIObject(mDBFacade,param3,0,true);
            if(mNoPetUI.tooltip)
            {
               mNoPetUI.tooltip.title_label.text = Locale.getString("NO_PET_EQUIPPED_TOOLTIP_TITLE");
               mNoPetUI.tooltip.description_label.text = Locale.getString("NO_PET_EQUIPPED_TOOLTIP_DESCRIPTION");
            }
         }
         mLogicalWorkComponent = new LogicalWorkComponent(mDBFacade);
         mEventComponent = new EventComponent(mDBFacade);
         mPetNPCGameObject = param4;
         mRoot.visible = false;
         setupPetUI();
      }
      
      public function get petNPCGameObject() : NPCGameObject
      {
         return mPetNPCGameObject;
      }
      
      private function setupPetUI() : void
      {
         mHpBar = new UIProgressBar(mDBFacade,root.hp.hpBar);
         mRoot.hp_death.visible = false;
         if(mNoPetUI)
         {
            mNoPetUI.visible = false;
         }
         if(mPetNPCGameObject != null)
         {
            mRoot.tooltip.description_label.text = mPetNPCGameObject.gmNpc.Description;
            mRoot.tooltip.title_label.text = mPetNPCGameObject.gmNpc.Name.toUpperCase();
            mEventComponent.addListener(GameObjectEvent.uniqueEvent("HpEvent_HP_UPDATE",mPetNPCGameObject.id),function(param1:HpEvent):void
            {
               setHp(param1.hp,param1.maxHp);
            });
            setHp(mPetNPCGameObject.hitPoints,mPetNPCGameObject.maxHitPoints);
            ItemInfo.loadItemIcon(mPetNPCGameObject.actorData.gMActor.IconSwfFilepath,mPetNPCGameObject.actorData.gMActor.IconName,root.graphic,mDBFacade,80,68);
            if(mNoPetUI)
            {
               mNoPetUI.visible = false;
            }
            mHpBar.visible = true;
            this.visible = true;
         }
         else
         {
            mHpBar.visible = false;
            if(mNoPetUI)
            {
               mNoPetUI.visible = true;
            }
            this.visible = false;
            this.hideTooltip();
         }
         mCoolDownRenderer = new MovieClipRenderer(mDBFacade,root.cooldown);
         mCoolDownRenderer.clip.visible = false;
         mCoolDownClipLength = root.cooldown.totalFrames * mDBFacade.gameClock.tickLength;
      }
      
      private function setHp(param1:uint, param2:uint) : void
      {
         mHpBar.value = param1 / param2;
      }
      
      public function petDeath() : void
      {
         mIsDead = true;
         var _loc1_:Number = mPetNPCGameObject.gmNpc.RespawnT;
         if(_loc1_ > 0)
         {
            handleRespawningPetDeath(_loc1_);
         }
         mPetNPCGameObject = null;
      }
      
      private function handleRespawningPetDeath(param1:Number) : void
      {
         var scopingSolution:PetPortraitUI;
         var respawnTimer:Number = param1;
         ItemInfo.loadItemIcon(mPetNPCGameObject.actorData.gMActor.IconSwfFilepath,mPetNPCGameObject.actorData.gMActor.IconName,root.graphic,mDBFacade,80,68);
         mRoot.hp_death.visible = true;
         scopingSolution = this;
         root.tooltip.title_label.text = mPetNPCGameObject.gmNpc.Name.toUpperCase();
         root.tooltip.description_label.text = Locale.getString("PET_RESPAWNS_IN") + ": " + respawnTimer.toString();
         mCoolDownRenderer.playRate = mCoolDownClipLength / respawnTimer;
         mCoolDownRenderer.clip.visible = true;
         mCoolDownRenderer.play();
         if(mRespawnTask)
         {
            mRespawnTask.destroy();
         }
         mRespawnTask = mLogicalWorkComponent.doEverySeconds(1,function(param1:GameClock):void
         {
            respawnTimer--;
            root.tooltip.description_label.text = Locale.getString("PET_RESPAWNS_IN") + respawnTimer.toString();
            if(respawnTimer == 0)
            {
               if(mRespawnTask)
               {
                  mRespawnTask.destroy();
               }
               mRespawnTask = null;
            }
         });
      }
      
      public function get npcId() : int
      {
         if(mPetNPCGameObject.gmNpc)
         {
            return mPetNPCGameObject.id;
         }
         return -1;
      }
      
      public function get isDead() : Boolean
      {
         return mIsDead;
      }
      
      override public function destroy() : void
      {
         mLogicalWorkComponent.destroy();
         mDBFacade = null;
         mPetNPCGameObject = null;
         if(mRespawnTask)
         {
            mRespawnTask.destroy();
         }
         mRespawnTask = null;
         if(mNoPetUI)
         {
            mNoPetUI.destroy();
         }
         mNoPetUI = null;
         if(mCoolDownRenderer)
         {
            mCoolDownRenderer.destroy();
         }
         mCoolDownRenderer = null;
         mHpBar = null;
         if(mEventComponent != null)
         {
            mEventComponent.destroy();
            mEventComponent = null;
         }
         super.destroy();
      }
   }
}

