package DistributedObjects
{
   import Box2D.Collision.Shapes.b2PolygonShape;
   import Box2D.Dynamics.b2Body;
   import Box2D.Dynamics.b2BodyDef;
   import Box2D.Dynamics.b2FixtureDef;
   import Box2D.Dynamics.b2World;
   import Brain.Clock.GameClock;
   import Brain.Event.EventComponent;
   import Brain.GameObject.GameObject;
   import Brain.Logger.Logger;
   import Brain.SceneGraph.SceneGraphComponent;
   import Brain.WorkLoop.LogicalWorkComponent;
   import Brain.WorkLoop.Task;
   import Collision.ContactListener;
   import Collision.DBBox2DVisualizer;
   import Dungeon.NavCollider;
   import Facade.DBFacade;
   import Floor.DungeonModifierHelper;
   import Floor.FloorEndingGui;
   import GameMasterDictionary.GMMapNode;
   import GeneratedCode.DungeonModifier;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.geom.Vector3D;
   
   public class Floor extends GameObject
   {
      
      public static const FLOOR_INTEREST_CLOSURE:String = "FLOOR_INTEREST_CLOSURE";
      
      public static const BOX2D_SCALE:Number = 50;
      
      private static const POSITION_ITERATIONS:uint = 3;
      
      private static const VELOCITY_ITERATIONS:uint = 8;
      
      private var mParentArea:Area;
      
      protected var mB2World:b2World;
      
      protected var mFloorBody:b2Body;
      
      private var mBox2DDebugSprite:Sprite;
      
      private var mBox2DVisualizer:DBBox2DVisualizer;
      
      protected var mLogicalWorkComponent:LogicalWorkComponent;
      
      protected var mDBFacade:DBFacade;
      
      private var mContactListener:ContactListener;
      
      public var pastInitialLoad:Boolean;
      
      private var mFloorEndingGui:FloorEndingGui;
      
      protected var mSceneGraphComponent:SceneGraphComponent;
      
      protected var mEventComponent:EventComponent;
      
      protected var mPhysicsUpdateTask:Task;
      
      private var mActiveDungeonModifiers:Vector.<DungeonModifierHelper>;
      
      protected var mIsADefeat:Boolean = false;
      
      public function Floor(param1:DBFacade, param2:uint = 0)
      {
         var floorBodyDef:b2BodyDef;
         var wantAllCollisions:Boolean;
         var showCombatCollisions:Boolean;
         var showNavCollisions:Boolean;
         var showAStarVisuals:Boolean;
         var dbFacade:DBFacade = param1;
         var remoteId:uint = param2;
         super(dbFacade,remoteId);
         mActiveDungeonModifiers = new Vector.<DungeonModifierHelper>();
         mDBFacade = dbFacade;
         pastInitialLoad = false;
         mLogicalWorkComponent = new LogicalWorkComponent(mDBFacade);
         mB2World = new b2World(NavCollider.convertToB2Vec2(new Vector3D(0,0)),true);
         mContactListener = new ContactListener(mDBFacade);
         mB2World.SetContactListener(mContactListener);
         floorBodyDef = new b2BodyDef();
         floorBodyDef.type = b2Body.b2_staticBody;
         floorBodyDef.allowSleep = true;
         floorBodyDef.position = NavCollider.convertToB2Vec2(new Vector3D(0,0));
         mFloorBody = mB2World.CreateBody(floorBodyDef);
         mFloorBody.SetUserData(this.id);
         buildWalls();
         mPhysicsUpdateTask = mDBFacade.physicsWorkManager.doEveryFrame(update);
         wantAllCollisions = mDBFacade.showCollisions || mDBFacade.dbConfigManager.getConfigBoolean("show_all_colliders",false);
         showCombatCollisions = mDBFacade.showCollisions || mDBFacade.dbConfigManager.getConfigBoolean("show_combat_colliders",false);
         showNavCollisions = mDBFacade.showCollisions || mDBFacade.dbConfigManager.getConfigBoolean("show_navigation_colliders",false);
         showAStarVisuals = mDBFacade.dbConfigManager.getConfigBoolean("show_astar_colliders",false);
         if(wantAllCollisions || showCombatCollisions || showNavCollisions || showAStarVisuals)
         {
            mBox2DVisualizer = new DBBox2DVisualizer(mDBFacade,mB2World,wantAllCollisions,showCombatCollisions,showNavCollisions,showAStarVisuals);
         }
         mSceneGraphComponent = new SceneGraphComponent(mDBFacade);
         mEventComponent = new EventComponent(mDBFacade);
         mEventComponent.addListener(HeroGameObjectOwner.HERO_OWNER_READY,function(param1:Event):void
         {
            floorStart();
         });
         mSceneGraphComponent.fadeIn(1);
      }
      
      protected function buildFloorEndingGui() : void
      {
         mFloorEndingGui = new FloorEndingGui(this,gmMapNode.NodeType,mDBFacade);
      }
      
      public function get activeGMDungeonModifiers() : Vector.<DungeonModifierHelper>
      {
         return mActiveDungeonModifiers;
      }
      
      public function set activeDungeonModifiers(param1:Vector.<DungeonModifier>) : void
      {
         var _loc2_:* = 0;
         _loc2_ = 0;
         while(_loc2_ < param1.length)
         {
            mActiveDungeonModifiers.push(new DungeonModifierHelper(param1[_loc2_].id,param1[_loc2_].new_this_floor == 1,mDBFacade));
            _loc2_++;
         }
      }
      
      public function getCurrentFloorNum() : uint
      {
         return 0;
      }
      
      public function getMaxFloorNum() : uint
      {
         return 0;
      }
      
      public function floorEnding(param1:uint) : void
      {
         mFloorEndingGui.floorEnding(param1);
      }
      
      public function floorFailing(param1:uint) : void
      {
         mFloorEndingGui.floorFailing(param1);
      }
      
      public function victory() : void
      {
         mFloorEndingGui.dungeonVictory();
      }
      
      public function defeat() : void
      {
         mIsADefeat = true;
         mFloorEndingGui.dungeonFailure();
      }
      
      public function floorStart() : void
      {
         mFloorEndingGui.floorStart();
      }
      
      public function get debugVisualizer() : DBBox2DVisualizer
      {
         return mBox2DVisualizer;
      }
      
      public function get box2DWorld() : b2World
      {
         return mB2World;
      }
      
      public function get isADefeat() : Boolean
      {
         return mIsADefeat;
      }
      
      private function update(param1:GameClock) : void
      {
         mB2World.Step(param1.tickLength,8,3);
         mContactListener.processCollisions();
      }
      
      private function buildWalls() : void
      {
         var _loc7_:b2FixtureDef = new b2FixtureDef();
         var _loc8_:b2PolygonShape = new b2PolygonShape();
         _loc8_.SetAsEdge(NavCollider.convertToB2Vec2(new Vector3D(0,0)),NavCollider.convertToB2Vec2(new Vector3D(12 * 900,0)));
         _loc7_.shape = _loc8_;
         var _loc2_:b2FixtureDef = new b2FixtureDef();
         var _loc1_:b2PolygonShape = new b2PolygonShape();
         _loc1_.SetAsEdge(NavCollider.convertToB2Vec2(new Vector3D(0,12 * 900)),NavCollider.convertToB2Vec2(new Vector3D(12 * 900,12 * 900)));
         _loc2_.shape = _loc1_;
         var _loc6_:b2FixtureDef = new b2FixtureDef();
         var _loc3_:b2PolygonShape = new b2PolygonShape();
         _loc3_.SetAsEdge(NavCollider.convertToB2Vec2(new Vector3D(0,0)),NavCollider.convertToB2Vec2(new Vector3D(0,12 * 900)));
         _loc6_.shape = _loc3_;
         var _loc4_:b2FixtureDef = new b2FixtureDef();
         var _loc5_:b2PolygonShape = new b2PolygonShape();
         _loc5_.SetAsEdge(NavCollider.convertToB2Vec2(new Vector3D(12 * 900,0)),NavCollider.convertToB2Vec2(new Vector3D(12 * 900,12 * 900)));
         _loc4_.shape = _loc5_;
         mFloorBody.CreateFixture(_loc7_);
         mFloorBody.CreateFixture(_loc2_);
         mFloorBody.CreateFixture(_loc6_);
         mFloorBody.CreateFixture(_loc4_);
      }
      
      public function SetParentArea(param1:Area) : void
      {
         mParentArea = param1;
      }
      
      public function get parentArea() : Area
      {
         return mParentArea;
      }
      
      override public function destroy() : void
      {
         if(mParentArea)
         {
            mParentArea.FloorIsLeaving(this);
            mParentArea = null;
         }
         if(mBox2DVisualizer)
         {
            mBox2DVisualizer.destroy();
            mBox2DVisualizer = null;
         }
         mFloorEndingGui.destroy();
         mFloorEndingGui = null;
         mDBFacade.hud.hide();
         mEventComponent.destroy();
         mEventComponent = null;
         if(mPhysicsUpdateTask)
         {
            mPhysicsUpdateTask.destroy();
            mPhysicsUpdateTask = null;
         }
         mFloorBody.SetUserData(null);
         mB2World.DestroyBody(mFloorBody);
         mFloorBody = null;
         mB2World = null;
         mLogicalWorkComponent.destroy();
         mLogicalWorkComponent = null;
         mSceneGraphComponent.cleanBackgroundLayer();
         mSceneGraphComponent.destroy();
         mSceneGraphComponent = null;
         mDBFacade = null;
         super.destroy();
      }
      
      public function addCollectedTreasure(param1:uint) : void
      {
         mParentArea.addCollectedTreasure(param1);
      }
      
      public function get treasureCollected() : Vector.<uint>
      {
         return mParentArea.treasureCollected;
      }
      
      public function addCollectedExp(param1:uint) : void
      {
         mParentArea.addCollectedExp(param1);
      }
      
      public function get expCollected() : uint
      {
         return mParentArea.expCollected;
      }
      
      public function get gmMapNode() : GMMapNode
      {
         Logger.error("Should call overriden function");
         return null;
      }
      
      override public function InterestClosure() : void
      {
         pastInitialLoad = true;
         mEventComponent.dispatchEvent(new Event("FLOOR_INTEREST_CLOSURE"));
      }
      
      public function get isInfiniteDungeon() : Boolean
      {
         return false;
      }
   }
}

