package DistributedObjects
{
   import Actor.ActorGameObject;
   import Brain.AssetRepository.AssetLoadingComponent;
   import Brain.AssetRepository.SwfAsset;
   import Brain.GameObject.GameObject;
   import Brain.Logger.Logger;
   import Brain.Sound.SoundAsset;
   import Brain.Sound.SoundHandle;
   import Dungeon.DungeonFloorFactory;
   import Dungeon.RectangleNavCollider;
   import Dungeon.Tile;
   import Dungeon.TileGrid;
   import Effects.EffectManager;
   import Events.ActorLifetimeEvent;
   import Facade.DBFacade;
   import Floor.FloorMessageView;
   import Floor.FloorObject;
   import GameMasterDictionary.GMColiseumTier;
   import GameMasterDictionary.GMMapNode;
   import GeneratedCode.DistributedDungeonFloorNetworkComponent;
   import GeneratedCode.DungeonTileUsage;
   import GeneratedCode.IDistributedDungeonFloor;
   import Pathfinding.Astar;
   import Sound.DBSoundComponent;
   import flash.display.MovieClip;
   import flash.events.Event;
   import flash.events.IOErrorEvent;
   import flash.events.KeyboardEvent;
   import flash.events.SecurityErrorEvent;
   import flash.geom.Point;
   import flash.geom.Rectangle;
   import flash.geom.Vector3D;
   import flash.media.Sound;
   import flash.media.SoundLoaderContext;
   import flash.net.URLRequest;
   import org.as3commons.collections.Map;
   import org.as3commons.collections.Set;
   import org.as3commons.collections.framework.ISetIterator;
   
   public class DistributedDungeonFloor extends Floor implements IDistributedDungeonFloor
   {
      
      private static const MUSIC_BUFFER:Number = 1000;
      
      protected var mTileNetworkComponents:Vector.<DungeonTileUsage>;
      
      protected var mTileLibraryPath:String = "uninitialized";
      
      protected var mDungeonFloorFactory:DungeonFloorFactory;
      
      protected var mTileGrid:TileGrid;
      
      public var astarGrids:Astar = new Astar();
      
      private var mActiveOwnerAvatar:HeroGameObjectOwner;
      
      private var mRemoteHeroes:Map;
      
      private var mRemoteActors:Map;
      
      private var mBuildPropReady:Boolean = false;
      
      private var mPostGenerate:Boolean;
      
      private var mFloorObjectsAwaitingDungeonFloor:Set;
      
      private var mColiseumTierConstant:String;
      
      private var mCurrentMapNodeId:uint;
      
      private var mMapNode:GMMapNode;
      
      private var mEffectManager:EffectManager;
      
      private var mBaseLining:uint;
      
      private var mIntroMovieSwfFilePath:String;
      
      private var mIntroMovieAssetClassName:String;
      
      private var mAssetLoadingComponent:AssetLoadingComponent;
      
      private var mCurrentFloorNum:uint;
      
      protected var mDBSoundComponent:DBSoundComponent;
      
      private var mMusicTestSoundHandle:SoundHandle;
      
      public function DistributedDungeonFloor(param1:DBFacade, param2:uint)
      {
         Logger.debug("New  DistributedDungeonFloor******************************");
         mPostGenerate = false;
         super(param1,param2);
         mRemoteHeroes = new Map();
         mRemoteActors = new Map();
         mFloorObjectsAwaitingDungeonFloor = new Set();
         mEffectManager = new EffectManager(mDBFacade);
         mBaseLining = 0;
         mDBSoundComponent = new DBSoundComponent(mDBFacade);
         mAssetLoadingComponent = new AssetLoadingComponent(mDBFacade);
      }
      
      public function set coliseumTierConstant(param1:String) : void
      {
         mColiseumTierConstant = param1;
      }
      
      public function set mapNodeId(param1:uint) : void
      {
         mCurrentMapNodeId = param1;
      }
      
      override public function get isInfiniteDungeon() : Boolean
      {
         return false;
      }
      
      public function getActor(param1:uint) : ActorGameObject
      {
         if(mActiveOwnerAvatar && mActiveOwnerAvatar.id == param1)
         {
            return mActiveOwnerAvatar;
         }
         var _loc2_:ActorGameObject = mRemoteActors.itemFor(param1);
         if(_loc2_)
         {
            return _loc2_;
         }
         _loc2_ = mRemoteHeroes.itemFor(param1);
         if(_loc2_)
         {
            return _loc2_;
         }
         return null;
      }
      
      public function get effectManager() : EffectManager
      {
         return mEffectManager;
      }
      
      public function get numHeroes() : uint
      {
         return 1 + mRemoteHeroes.size;
      }
      
      public function get remoteHeroes() : Map
      {
         return mRemoteHeroes;
      }
      
      public function get remoteActors() : Map
      {
         return mRemoteActors;
      }
      
      public function set remoteHeroes(param1:Map) : void
      {
         mRemoteHeroes = param1;
      }
      
      public function get activeOwnerAvatar() : HeroGameObjectOwner
      {
         return mActiveOwnerAvatar;
      }
      
      public function set activeOwnerAvatar(param1:HeroGameObjectOwner) : void
      {
         mActiveOwnerAvatar = param1;
      }
      
      override public function getCurrentFloorNum() : uint
      {
         return mCurrentFloorNum % 1000 + 1;
      }
      
      override public function getMaxFloorNum() : uint
      {
         return uint(mCurrentFloorNum / 1000);
      }
      
      public function get tileGrid() : TileGrid
      {
         return mTileGrid;
      }
      
      public function setNetworkComponentDistributedDungeonFloor(param1:DistributedDungeonFloorNetworkComponent) : void
      {
      }
      
      public function get dungeonFloorFactory() : DungeonFloorFactory
      {
         return mDungeonFloorFactory;
      }
      
      public function postGenerate() : void
      {
         mPostGenerate = true;
         mDungeonFloorFactory = new DungeonFloorFactory(this,initGridCallback,mDBFacade,mTileLibraryPath);
         astarGrids.Init(this);
         mDungeonFloorFactory.buildDungeonFloor(mTileNetworkComponents,finishedBuildingTiles);
         mMapNode = mDBFacade.gameMaster.getMapNode(mCurrentMapNodeId);
         this.playIntroMovie();
         this.playMusic();
         buildFloorEndingGui();
      }
      
      private function playMusic() : void
      {
         var bgMusic:Sound;
         var req:URLRequest;
         var context:SoundLoaderContext;
         var gmTier:GMColiseumTier = mDBFacade.gameMaster.coliseumTierByConstant.itemFor(mColiseumTierConstant);
         if(gmTier && gmTier.MusicFilepath)
         {
            bgMusic = new Sound();
            req = new URLRequest(DBFacade.buildFullDownloadPath(gmTier.MusicFilepath));
            context = new SoundLoaderContext(1000,true);
            context.checkPolicyFile = true;
            bgMusic.load(req,context);
            bgMusic.addEventListener("complete",function(param1:Event):void
            {
               mDBSoundComponent.playStreamingMusic(bgMusic);
            });
            bgMusic.addEventListener("ioError",function(param1:IOErrorEvent):void
            {
               Logger.error("IOErrorEvent: " + param1.toString() + " Data:" + req.data.toString() + " URL:" + gmTier.MusicFilepath.toString());
            });
            bgMusic.addEventListener("securityError",function(param1:SecurityErrorEvent):void
            {
               Logger.error("SecurityErrorEvent: " + param1.toString() + " Data:" + req.data.toString() + " URL:" + gmTier.MusicFilepath.toString());
            });
         }
      }
      
      public function get coliseumTier() : GMColiseumTier
      {
         return mDBFacade.gameMaster.coliseumTierByConstant.itemFor(mColiseumTierConstant);
      }
      
      public function get completionXp() : uint
      {
         return mMapNode.CompletionXPBonus;
      }
      
      private function initGridCallback(param1:TileGrid) : void
      {
         mTileGrid = param1;
      }
      
      public function tileLibrary(param1:String) : void
      {
         mTileLibraryPath = param1;
      }
      
      public function set introMovieSwfFilePath(param1:String) : void
      {
         Logger.debug("introMovie: swfFilePath: " + param1);
         mIntroMovieSwfFilePath = param1;
      }
      
      public function set introMovieAssetClassName(param1:String) : void
      {
         Logger.debug("introMovie: assetClassName: " + param1);
         mIntroMovieAssetClassName = param1;
      }
      
      public function get currentFloorNum() : uint
      {
         return mCurrentFloorNum;
      }
      
      public function set currentFloorNum(param1:uint) : void
      {
         Logger.debug("introMovie: assetClassName: " + param1);
         mCurrentFloorNum = param1;
      }
      
      private function playIntroMovie() : void
      {
         if(mIntroMovieSwfFilePath && mIntroMovieAssetClassName)
         {
            mAssetLoadingComponent.getSwfAsset(DBFacade.buildFullDownloadPath(mIntroMovieSwfFilePath),function(param1:SwfAsset):void
            {
               var onKeyDown:Function;
               var asset:SwfAsset = param1;
               var movieClass:Class = asset.getClass(mIntroMovieAssetClassName);
               var movie:MovieClip = new movieClass();
               var stopMovie:Function = function(param1:Event = null):void
               {
                  if(movie.currentFrame == movie.totalFrames || param1 == null)
                  {
                     mDBFacade.stageRef.removeEventListener("keyDown",onKeyDown);
                     mDBFacade.removeRootDisplayObject(movie);
                     movie.removeEventListener("enterFrame",stopMovie);
                     mEventComponent.dispatchEvent(new Event("REQUEST_ENTRY_PLAYER_HERO"));
                     movie.stop();
                     mDBFacade.assetRepository.removeFromCache(asset);
                     movie = null;
                  }
               };
               mDBFacade.addRootDisplayObject(movie);
               movie.addEventListener("enterFrame",stopMovie);
               movie.gotoAndPlay(1);
               movie.x = mDBFacade.viewWidth * 0.5;
               movie.y = mDBFacade.viewHeight * 0.5;
               onKeyDown = function(param1:KeyboardEvent):void
               {
                  if(param1.keyCode == 27)
                  {
                     stopMovie();
                  }
               };
               mDBFacade.stageRef.addEventListener("keyDown",onKeyDown);
            });
         }
         else
         {
            mEventComponent.dispatchEvent(new Event("REQUEST_ENTRY_PLAYER_HERO"));
         }
      }
      
      public function show_text(param1:String) : void
      {
         var _loc2_:FloorMessageView = new FloorMessageView(mDBFacade,param1);
      }
      
      public function play_sound(param1:String) : void
      {
         var sound:String = param1;
         mAssetLoadingComponent.getSoundAsset(DBFacade.buildFullDownloadPath("Resources/Audio/soundEffects.swf"),sound,function(param1:SoundAsset):void
         {
            mDBSoundComponent.playOneShot(param1,"sfx");
         });
      }
      
      public function trigger_camera_zoom(param1:Number) : void
      {
         mDBFacade.camera.tweenZoom(1,param1,true);
      }
      
      public function trigger_camera_shake(param1:Number, param2:Number, param3:uint) : void
      {
         mDBFacade.camera.shakeY(param1 / 24,param2,param3);
      }
      
      public function tiles(param1:Vector.<DungeonTileUsage>) : void
      {
         var _loc3_:* = undefined;
         var _loc4_:* = 0;
         var _loc2_:Boolean = false;
         var _loc5_:* = 0;
         if(mPostGenerate)
         {
            _loc3_ = new Vector.<DungeonTileUsage>();
            _loc4_ = 0;
            while(_loc4_ < param1.length)
            {
               _loc2_ = false;
               _loc5_ = 0;
               while(_loc5_ < mTileNetworkComponents.length)
               {
                  if(param1[_loc4_].x == mTileNetworkComponents[_loc5_].x && param1[_loc4_].y == mTileNetworkComponents[_loc5_].y)
                  {
                     _loc2_ = true;
                  }
                  _loc5_++;
               }
               if(!_loc2_)
               {
                  _loc3_.push(param1[_loc4_]);
               }
               _loc4_++;
            }
            mDungeonFloorFactory.buildDungeonFloor(_loc3_,finishedBuildingTiles);
         }
         mTileNetworkComponents = param1;
      }
      
      protected function finishedBuildingTiles(param1:TileGrid) : void
      {
         var _loc3_:FloorObject = null;
         mTileGrid = param1;
         mBuildPropReady = true;
         var _loc2_:ISetIterator = mFloorObjectsAwaitingDungeonFloor.iterator() as ISetIterator;
         while(_loc2_.hasNext())
         {
            _loc3_ = _loc2_.next() as FloorObject;
            _loc3_.distributedDungeonFloor = this;
         }
         mFloorObjectsAwaitingDungeonFloor.clear();
         fillInEmptyTilesWithCollisionVolumes();
      }
      
      private function fillInEmptyTilesWithCollisionVolumes() : void
      {
         var _loc9_:* = 0;
         var _loc5_:* = 0;
         var _loc6_:Tile = null;
         var _loc2_:Number = NaN;
         var _loc1_:Number = NaN;
         var _loc7_:Vector3D = null;
         var _loc11_:Number = NaN;
         var _loc3_:Number = NaN;
         var _loc4_:Vector3D = null;
         var _loc10_:Number = NaN;
         var _loc8_:RectangleNavCollider = null;
         _loc9_ = 0;
         while(_loc9_ < 12)
         {
            _loc5_ = 0;
            while(_loc5_ < 12)
            {
               _loc6_ = mTileGrid.getTileAtIndex(_loc5_,_loc9_);
               if(_loc6_ == null)
               {
                  if(mTileGrid.getEmptyColliderAtIndex(_loc5_,_loc9_) == null)
                  {
                     _loc2_ = 0;
                     _loc1_ = 0;
                     _loc7_ = new Vector3D(_loc2_,_loc1_);
                     _loc11_ = 900 * _loc5_ - 900 * 0.5;
                     _loc3_ = 900 * _loc9_ - 900 * 0.5;
                     _loc4_ = new Vector3D(_loc11_,_loc3_);
                     _loc10_ = 0;
                     _loc8_ = new RectangleNavCollider(mDBFacade,_loc6_,_loc7_,_loc10_,mB2World,900 * 0.5,900 * 0.5);
                     _loc8_.position = _loc4_;
                     mTileGrid.SetEmptyColliderAtIndex(_loc5_,_loc9_,_loc8_);
                  }
               }
               _loc5_++;
            }
            _loc9_++;
         }
      }
      
      override public function destroy() : void
      {
         Logger.debug("destroy DistributedDungeonFloor " + id.toString());
         mEventComponent.dispatchEvent(new Event("DUNGEON_FLOOR_DESTROY"));
         mActiveOwnerAvatar = null;
         if(mDBSoundComponent)
         {
            mDBSoundComponent.destroy();
            mDBSoundComponent = null;
         }
         if(mAssetLoadingComponent)
         {
            mAssetLoadingComponent.destroy();
            mAssetLoadingComponent = null;
         }
         mDungeonFloorFactory.destroy();
         mDungeonFloorFactory = null;
         mRemoteHeroes.clear();
         mRemoteHeroes = null;
         mRemoteActors.clear();
         mRemoteActors = null;
         mFloorObjectsAwaitingDungeonFloor.clear();
         mFloorObjectsAwaitingDungeonFloor = null;
         mTileGrid.destroy();
         mTileGrid = null;
         mEffectManager.destroy();
         mEffectManager = null;
         astarGrids.destroy();
         astarGrids = null;
         super.destroy();
      }
      
      public function isAlive() : Boolean
      {
         return mTileGrid != null;
      }
      
      override public function newNetworkChild(param1:GameObject) : void
      {
         var _loc2_:FloorObject = null;
         if(param1 is HeroGameObjectOwner)
         {
            activeOwnerAvatar = param1 as HeroGameObjectOwner;
         }
         else if(param1 is HeroGameObject)
         {
            remoteHeroes.add(param1.id,param1 as HeroGameObject);
         }
         else if(param1 is ActorGameObject)
         {
            remoteActors.add(param1.id,param1 as ActorGameObject);
            mEventComponent.dispatchEvent(new ActorLifetimeEvent("ACTOR_CREATED",param1.id));
         }
         if(param1 is FloorObject)
         {
            _loc2_ = param1 as FloorObject;
            if(mBuildPropReady)
            {
               _loc2_.distributedDungeonFloor = this;
            }
            else
            {
               mFloorObjectsAwaitingDungeonFloor.add(_loc2_);
            }
         }
      }
      
      public function RemoveNetworkChild(param1:GameObject) : void
      {
         var _loc2_:FloorObject = null;
         if(param1 is HeroGameObjectOwner)
         {
            activeOwnerAvatar = null;
         }
         else if(param1 is HeroGameObject)
         {
            remoteHeroes.removeKey(param1.id);
         }
         else if(param1 is ActorGameObject)
         {
            mRemoteActors.removeKey(param1.id);
            mEventComponent.dispatchEvent(new ActorLifetimeEvent("ACTOR_DESTROYED",param1.id));
         }
         if(param1 is FloorObject)
         {
            _loc2_ = param1 as FloorObject;
            _loc2_.distributedDungeonFloor = null;
         }
      }
      
      public function GetTilesAroundAvatar(param1:Number) : Vector.<Tile>
      {
         var _loc2_:Rectangle = null;
         if(mActiveOwnerAvatar)
         {
            _loc2_ = new Rectangle(mActiveOwnerAvatar.position.x - param1,mActiveOwnerAvatar.position.y - param1,param1 * 2,param1 * 2);
            return mActiveOwnerAvatar.distributedDungeonFloor.tileGrid.getVisibleTiles(_loc2_);
         }
         return new Vector.<Tile>();
      }
      
      public function GetTileIdWhichAvatarIsOn() : String
      {
         var _loc4_:* = 0;
         if(mTileNetworkComponents.length == 0)
         {
            Logger.error("Invalid tile location in getTileNetworkComponentAtLocation");
            return null;
         }
         var _loc2_:int = mActiveOwnerAvatar.position.x;
         var _loc3_:int = mActiveOwnerAvatar.position.y;
         var _loc5_:DungeonTileUsage = mTileNetworkComponents[0];
         var _loc1_:* = getDistanceFromTileUsage(_loc2_,_loc3_,_loc5_);
         var _loc6_:int = 0;
         _loc4_ = 1;
         while(_loc4_ < mTileNetworkComponents.length)
         {
            _loc6_ = getDistanceFromTileUsage(_loc2_,_loc3_,mTileNetworkComponents[_loc4_]);
            if(_loc6_ < _loc1_)
            {
               _loc1_ = _loc6_;
               _loc5_ = mTileNetworkComponents[_loc4_];
            }
            _loc4_++;
         }
         return _loc5_.tileId;
      }
      
      private function getDistanceFromTileUsage(param1:int, param2:int, param3:DungeonTileUsage) : int
      {
         var _loc4_:Point = new Point(param1,param2);
         var _loc5_:Point = new Point(param3.x + 450,param3.y + 450);
         return Point.distance(_loc4_,_loc5_);
      }
      
      public function set baseLining(param1:uint) : void
      {
         mBaseLining = param1;
      }
      
      public function get baseLining() : uint
      {
         return mBaseLining;
      }
      
      override public function get gmMapNode() : GMMapNode
      {
         return mMapNode;
      }
      
      public function isTavern() : Boolean
      {
         return mMapNode.NodeType == "TAVERN";
      }
   }
}

