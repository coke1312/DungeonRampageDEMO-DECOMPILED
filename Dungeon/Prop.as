package Dungeon
{
   import Brain.SceneGraph.SceneGraphManager;
   import DistributedObjects.DistributedDungeonFloor;
   import Facade.DBFacade;
   import Floor.FloorObject;
   import GameMasterDictionary.GMProp;
   import flash.display.MovieClip;
   import flash.geom.Vector3D;
   
   public class Prop extends FloorObject
   {
      
      protected var mPropView:PropView;
      
      private var mAssetClassName:String;
      
      private var mConstant:String;
      
      public function Prop(param1:DBFacade, param2:uint = 0)
      {
         super(param1,param2);
         this.init();
      }
      
      public static function validatePropConstant(param1:Object, param2:DBFacade) : Boolean
      {
         if(param1.constant == null)
         {
            return false;
         }
         var _loc3_:GMProp = param2.gameMaster.propByConstant.itemFor(param1.constant);
         return _loc3_ != null;
      }
      
      public static function parseFromTileJson(param1:Object, param2:Tile, param3:DBFacade) : Prop
      {
         var _loc6_:Number = param2.position.x + (param1.x != null ? param1.x : 0);
         var _loc7_:Number = param2.position.y + (param1.y != null ? param1.y : 0);
         var _loc8_:Vector3D = new Vector3D(_loc6_,_loc7_);
         var _loc5_:Prop = new Prop(param3);
         _loc5_.tile = param2;
         param2.addOwnedFloorObject(_loc5_);
         _loc5_.constant = param1.constant;
         var _loc4_:GMProp = param3.gameMaster.propByConstant.itemFor(_loc5_.constant);
         _loc5_.assetClassName = _loc4_.AssetClassName;
         _loc5_.position = _loc8_;
         _loc5_.mArchwayAlpha = _loc4_.ArchwayAlpha;
         if(param1.scale)
         {
            _loc5_.view.root.scaleX = _loc5_.view.root.scaleY = param1.scale;
         }
         if(param1.flip)
         {
            _loc5_.view.root.scaleX = -_loc5_.view.root.scaleX;
         }
         if(param1.rotation)
         {
            _loc5_.view.root.rotation = param1.rotation;
         }
         var _loc9_:String = param1.layer != null ? param1.layer : "sorted";
         _loc5_.layer = SceneGraphManager.getLayerFromName(_loc9_);
         return _loc5_;
      }
      
      override public function set position(param1:Vector3D) : void
      {
         super.position = param1;
         this.mPropView.position = mPosition;
      }
      
      public function set constant(param1:String) : void
      {
         mConstant = param1;
      }
      
      public function get constant() : String
      {
         return mConstant;
      }
      
      public function set assetClassName(param1:String) : void
      {
         mAssetClassName = param1;
      }
      
      override public function set distributedDungeonFloor(param1:DistributedDungeonFloor) : void
      {
         super.distributedDungeonFloor = param1;
         this.distributedDungeonFloor.dungeonFloorFactory.tileFactory.propFactory.createProp(this.constant,assetLoaded);
      }
      
      override protected function updateTile() : void
      {
      }
      
      protected function assetLoaded(param1:MovieClip) : void
      {
         mPropView.body = param1;
         mPropView.root.name = "PropView_" + this.constant + "_" + this.id;
         if(!mTile.isOnStage)
         {
            this.view.addToStage();
         }
         mTile.expandBounds(this);
         if(!mTile.isOnStage)
         {
            this.view.removeFromStage();
         }
         this.createNavCollisions(this.constant);
      }
      
      override protected function buildView() : void
      {
         mPropView = new PropView(mDBFacade,this);
         view = mPropView;
      }
   }
}

