package Effects
{
   import Actor.ActorGameObject;
   import Brain.AssetRepository.AssetLoadingComponent;
   import Brain.Clock.GameClock;
   import Brain.SceneGraph.SceneGraphComponent;
   import Brain.SceneGraph.SceneGraphManager;
   import Brain.Sound.SoundAsset;
   import Brain.WorkLoop.LogicalWorkComponent;
   import Brain.WorkLoop.Task;
   import Facade.DBFacade;
   import Floor.FloorObject;
   import Sound.DBSoundComponent;
   import flash.geom.Vector3D;
   import org.as3commons.collections.Map;
   import org.as3commons.collections.framework.IMapIterator;
   
   public class EffectManager
   {
      
      private static const OUT_OF_MANA_DISPLAY_TIME:Number = 2;
      
      private var mDBFacade:DBFacade;
      
      private var mManagedEffects:Map;
      
      private var mSoundComponent:DBSoundComponent;
      
      private var mAssetLoadingComponent:AssetLoadingComponent;
      
      private var mSceneGraphComponent:SceneGraphComponent;
      
      private var mLogicalWorkComponent:LogicalWorkComponent;
      
      private var mNotEnoughManaDisplayTask:Task;
      
      public function EffectManager(param1:DBFacade)
      {
         super();
         mDBFacade = param1;
         mManagedEffects = new Map();
         mAssetLoadingComponent = new AssetLoadingComponent(mDBFacade);
         mSceneGraphComponent = new SceneGraphComponent(mDBFacade);
         mSoundComponent = new DBSoundComponent(mDBFacade);
         mLogicalWorkComponent = new LogicalWorkComponent(mDBFacade);
      }
      
      public function playLerpedEffect(param1:String, param2:String, param3:Vector3D, param4:FloorObject = null, param5:ActorGameObject = null, param6:Number = 1, param7:uint = 13369344, param8:Boolean = false, param9:Number = 1, param10:Number = 0, param11:Number = 0, param12:Number = 0, param13:Number = 0, param14:Boolean = false, param15:String = "sorted", param16:Boolean = false, param17:Number = 1, param18:Function = null) : void
      {
         var _loc19_:LerpEffectGameObject = new LerpEffectGameObject(mDBFacade,param1,param2,param17,0,param18,param5,param6,param7);
         _loc19_.view.root.scaleX = _loc19_.view.root.scaleY = _loc19_.view.root.scaleZ = param9;
         _loc19_.position = param4.position.add(param3);
         _loc19_.layer = SceneGraphManager.getLayerFromName(param15);
         _loc19_.view.addToStage();
      }
      
      public function playEffect(param1:String, param2:String, param3:Vector3D, param4:FloorObject = null, param5:Boolean = false, param6:Number = 1, param7:Number = 0, param8:Number = 0, param9:Number = 0, param10:Number = 0, param11:Boolean = false, param12:String = "sorted", param13:Boolean = false, param14:Number = 1, param15:Function = null) : uint
      {
         var effectGameObject:EffectGameObject;
         var pool:EffectPool;
         var swfPath:String = param1;
         var className:String = param2;
         var position:Vector3D = param3;
         var parentObject:FloorObject = param4;
         var behindAvatar:Boolean = param5;
         var scale:Number = param6;
         var rotation:Number = param7;
         var rotationX:Number = param8;
         var rotationY:Number = param9;
         var rotationZ:Number = param10;
         var loop:Boolean = param11;
         var layerName:String = param12;
         var isManaged:Boolean = param13;
         var playRate:Number = param14;
         var assetLoadedCallback:Function = param15;
         if(isManaged)
         {
            effectGameObject = new EffectGameObject(mDBFacade,swfPath,className,playRate,0,assetLoadedCallback);
         }
         else
         {
            effectGameObject = mDBFacade.effectPool.checkout(mDBFacade,swfPath,className,assetLoadedCallback) as EffectGameObject;
         }
         effectGameObject.view.root.scaleX = effectGameObject.view.root.scaleY = effectGameObject.view.root.scaleZ = scale;
         effectGameObject.rotation = rotation;
         effectGameObject.view.rotationX = rotationX;
         effectGameObject.view.rotationY = rotationY;
         effectGameObject.view.rotationZ = rotationZ;
         effectGameObject.position = position;
         if(parentObject)
         {
            if(behindAvatar)
            {
               parentObject.view.root.addChildAt(effectGameObject.view.root,0);
            }
            else
            {
               parentObject.view.root.addChild(effectGameObject.view.root);
            }
         }
         else
         {
            effectGameObject.layer = SceneGraphManager.getLayerFromName(layerName);
            effectGameObject.view.addToStage();
         }
         pool = mDBFacade.effectPool;
         EffectView(effectGameObject.view).play(loop,function():void
         {
            if(!isManaged)
            {
               pool.checkin(effectGameObject);
            }
         });
         if(isManaged)
         {
            mManagedEffects.add(effectGameObject.id,effectGameObject);
         }
         return effectGameObject.id;
      }
      
      public function playSoundEffect(param1:String, param2:String) : void
      {
         var soundSwfPath:String = param1;
         var soundName:String = param2;
         mAssetLoadingComponent.getSoundAsset(soundSwfPath,soundName,function(param1:SoundAsset):void
         {
            mSoundComponent.playSfxOneShot(param1,null);
         });
      }
      
      public function endManagedEffect(param1:uint) : void
      {
         var _loc2_:EffectGameObject = mManagedEffects.itemFor(param1);
         if(_loc2_)
         {
            mManagedEffects.remove(_loc2_);
            _loc2_.destroy();
         }
      }
      
      public function playNotEnoughManaEffects() : void
      {
         if(mNotEnoughManaDisplayTask == null)
         {
            playSoundEffect(DBFacade.buildFullDownloadPath("Resources/Audio/soundEffects.swf"),"OutOfMana");
            mDBFacade.hud.showNotEnoughMana();
            mNotEnoughManaDisplayTask = mLogicalWorkComponent.doLater(2,function(param1:GameClock):void
            {
               mNotEnoughManaDisplayTask = null;
               mDBFacade.hud.hideNotEnoughMana();
            });
         }
      }
      
      public function destroy() : void
      {
         var _loc2_:IMapIterator = null;
         var _loc1_:EffectGameObject = null;
         mDBFacade = null;
         mLogicalWorkComponent.destroy();
         mLogicalWorkComponent = null;
         mAssetLoadingComponent.destroy();
         mAssetLoadingComponent = null;
         mSoundComponent.destroy();
         mSoundComponent = null;
         if(mManagedEffects)
         {
            _loc2_ = mManagedEffects.iterator() as IMapIterator;
            while(_loc2_.hasNext())
            {
               _loc1_ = _loc2_.next();
               _loc1_.destroy();
            }
            mManagedEffects.clear();
            mManagedEffects = null;
         }
         if(mNotEnoughManaDisplayTask)
         {
            mNotEnoughManaDisplayTask.destroy();
            mNotEnoughManaDisplayTask = null;
         }
         if(mSceneGraphComponent)
         {
            mSceneGraphComponent.destroy();
            mSceneGraphComponent = null;
         }
      }
   }
}

