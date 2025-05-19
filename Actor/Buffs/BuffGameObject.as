package Actor.Buffs
{
   import Actor.ActorGameObject;
   import Actor.ActorView;
   import Facade.DBFacade;
   import Floor.FloorObject;
   import Floor.FloorView;
   import GameMasterDictionary.GMBuff;
   import GameMasterDictionary.StatVector;
   import com.greensock.TimelineMax;
   
   public class BuffGameObject extends FloorObject
   {
      
      protected var mData:GMBuff;
      
      protected var mParentView:ActorView;
      
      private var mBuffView:BuffView;
      
      private var mActorGameObject:ActorGameObject;
      
      public var instanceCount:uint = 1;
      
      public var buffId:uint;
      
      public var swfPath:String = DBFacade.buildFullDownloadPath(mData.VFXFilepath);
      
      public var className:String = mData.VFX;
      
      public var deltaValues:StatVector = mData.DeltaValues;
      
      public var mSortLayer:String = mData.SortLayer;
      
      public var mCameraTweenMax:TimelineMax;
      
      public function BuffGameObject(param1:DBFacade, param2:ActorGameObject, param3:ActorView, param4:uint, param5:uint = 0)
      {
         mActorGameObject = param2;
         mParentView = param3;
         buffId = param4;
         mData = param1.gameMaster.buffById.itemFor(buffId);
         super(param1,param5);
         position = mActorGameObject.position;
      }
      
      override public function destroy() : void
      {
         if(mActorGameObject.isOwner && mData.ShakeLocalCamera)
         {
            this.mDBFacade.camera.removeShakes();
            mCameraTweenMax.kill();
         }
         mData = null;
         mParentView = null;
         if(mBuffView)
         {
            mBuffView.destroy();
         }
         mBuffView = null;
         mActorGameObject = null;
         deltaValues = null;
         super.destroy();
      }
      
      public function get Ability() : uint
      {
         return mData.Ability;
      }
      
      public function get ExpMult() : Number
      {
         return mData.Exp;
      }
      
      public function get EventExpMult() : Number
      {
         return mData.EventExp;
      }
      
      public function get attackCooldownMultiplier() : Number
      {
         return mData.AttackCooldownMultiplier;
      }
      
      public function get GoldMult() : Number
      {
         return mData.Gold;
      }
      
      public function get CanSwapDisplay() : Boolean
      {
         return mData.SwapDisplay;
      }
      
      override protected function buildView() : void
      {
         mBuffView = new BuffView(mDBFacade,this,mParentView,mData.TintColor,mData.TintAmountF,mData.Scale,mData.ScaleStartDelay,mData.ScaleUpIncrementTime,mData.ScaleUpIncrementScale);
         this.view = mBuffView as FloorView;
         if(mActorGameObject.isOwner)
         {
            if(mData.ShakeLocalCamera)
            {
               mCameraTweenMax = this.mDBFacade.camera.shakeX(mData.Duration,10,mData.Duration * 2);
            }
            if(mData.ShowInHUD)
            {
               mBuffView.showInHUD();
            }
         }
      }
      
      public function updateInstanceCountOnHud() : void
      {
         if(mData.ShowInHUD)
         {
            mDBFacade.hud.updateBuffInstance(this);
         }
      }
      
      public function get buffView() : BuffView
      {
         return mBuffView;
      }
      
      public function get buffData() : GMBuff
      {
         return mData;
      }
   }
}

