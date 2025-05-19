package Pathfinding
{
   import Box2D.Collision.Shapes.b2CircleShape;
   import Box2D.Collision.Shapes.b2Shape;
   import Box2D.Collision.b2AABB;
   import Box2D.Common.Math.b2Transform;
   import Box2D.Common.Math.b2Vec2;
   import Box2D.Common.b2Color;
   import Box2D.Dynamics.b2Body;
   import Box2D.Dynamics.b2Fixture;
   import Brain.Logger.Logger;
   import DistributedObjects.DistributedDungeonFloor;
   import Dungeon.NavCollider;
   import Dungeon.Tile;
   import flash.geom.Vector3D;
   
   public class Astar
   {
      
      public var Nodes:Vector.<AstarGridNode>;
      
      public var TotalGridCount:uint;
      
      public var TotalGridCountPerTile:uint;
      
      private var mDistributedDungeonFloor:DistributedDungeonFloor;
      
      private var mOpenList:PriorityQueue;
      
      private var mUniquePassKey:uint;
      
      private var mConsideredNodeCount:uint;
      
      private var mAnswerPath:Vector.<uint>;
      
      private var mClosestGrid:AstarGridNode;
      
      public var pickedClosestGrid:Boolean;
      
      public var heroCollisionRadius:Number;
      
      public var goalPoint:Vector3D;
      
      private var mCollFixture:b2Fixture = null;
      
      public function Astar()
      {
         var _loc1_:* = 0;
         super();
         TotalGridCount = 216 * 216;
         TotalGridCountPerTile = 18 * 18;
         Nodes = new Vector.<AstarGridNode>();
         mUniquePassKey = 0;
         _loc1_ = 0;
         while(_loc1_ < TotalGridCount)
         {
            Nodes[_loc1_] = null;
            _loc1_++;
         }
         mOpenList = new PriorityQueue();
         mAnswerPath = new Vector.<uint>();
      }
      
      public function Init(param1:DistributedDungeonFloor) : void
      {
         var _loc3_:* = 0;
         var _loc2_:* = 0;
         var _loc4_:Tile = null;
         mDistributedDungeonFloor = param1;
         _loc3_ = 0;
         while(_loc3_ < 12)
         {
            _loc2_ = 0;
            while(_loc2_ < 12)
            {
               _loc4_ = mDistributedDungeonFloor.tileGrid.getTileAtIndex(_loc2_,_loc3_);
               if(_loc4_ != null)
               {
                  InitTileAstarGrids(_loc2_,_loc3_);
               }
               _loc2_++;
            }
            _loc3_++;
         }
      }
      
      public function InitTileAstarGrids(param1:uint, param2:uint) : void
      {
         var _loc3_:* = 0;
         var _loc6_:Tile = mDistributedDungeonFloor.tileGrid.getTileAtIndex(param1,param2);
         if(_loc6_ == null)
         {
            Logger.error("sent in the wrong tile position: " + param1 + "," + param2);
            return;
         }
         var _loc5_:uint = 0;
         var _loc7_:uint = 0;
         var _loc4_:uint = param2 * 18;
         while(_loc4_ < (param2 + 1) * 18)
         {
            _loc3_ = param1 * 18;
            while(_loc3_ < (param1 + 1) * 18)
            {
               _loc5_ = _loc3_ + _loc4_ * 216;
               Nodes[_loc5_] = new AstarGridNode(_loc5_);
               _loc7_++;
               _loc3_++;
            }
            _loc4_++;
         }
      }
      
      public function destroy() : void
      {
         var _loc1_:* = 0;
         mDistributedDungeonFloor = null;
         _loc1_ = 0;
         while(_loc1_ < TotalGridCount)
         {
            if(Nodes[_loc1_] != null)
            {
               Nodes[_loc1_].destroy();
               Nodes[_loc1_] = null;
            }
            _loc1_++;
         }
         mOpenList = null;
         mAnswerPath = null;
      }
      
      public function set HeroCollisionRadius(param1:Number) : void
      {
         heroCollisionRadius = param1;
      }
      
      public function get answerPath() : Vector.<uint>
      {
         var _loc2_:Vector.<uint> = new Vector.<uint>();
         for each(var _loc1_ in mAnswerPath)
         {
            _loc2_.push(_loc1_);
         }
         return _loc2_.reverse();
      }
      
      public function GetAstarGrid(param1:Vector3D) : uint
      {
         var _loc2_:uint = param1.x / 50;
         var _loc3_:uint = param1.y / 50;
         return _loc2_ + _loc3_ * 216;
      }
      
      public function GetAstarGridCenter(param1:Vector3D) : Vector3D
      {
         var _loc3_:uint = param1.x / 50;
         var _loc4_:uint = param1.y / 50;
         var _loc2_:Vector3D = new Vector3D();
         _loc2_.x = _loc3_ * 50 + 50 / 2;
         _loc2_.y = _loc4_ * 50 + 50 / 2;
         return _loc2_;
      }
      
      public function GetEuclideanDistance(param1:Vector3D, param2:Vector3D) : Number
      {
         return Math.sqrt(Math.pow(param1.x - param2.x,2) + Math.pow(param1.y - param2.y,2));
      }
      
      public function GetManhattanDistance(param1:Vector3D, param2:Vector3D) : Number
      {
         return Math.abs(param1.x - param2.x) + Math.abs(param1.y - param2.y);
      }
      
      public function IsGridLegalAABB(param1:AstarGridNode) : Boolean
      {
         var collided:Boolean;
         var fixture:b2Fixture;
         var grid:AstarGridNode = param1;
         var CollisionCallback:* = function(param1:b2Fixture):void
         {
            var _loc2_:b2Shape = param1.GetShape();
            if(param1.GetBody().GetType() == b2Body.b2_staticBody)
            {
               mCollFixture = param1;
               collided = true;
            }
         };
         var gridCenter:b2Vec2 = NavCollider.convertToB2Vec2(grid.Center);
         var halfDimension:Number = 0.5;
         var aabb:b2AABB = new b2AABB();
         aabb.lowerBound.Set(gridCenter.x - halfDimension,gridCenter.y - halfDimension);
         aabb.upperBound.Set(gridCenter.x + halfDimension,gridCenter.y + halfDimension);
         collided = false;
         mDistributedDungeonFloor.box2DWorld.QueryAABB(CollisionCallback,aabb);
         return !collided;
      }
      
      public function IsGridLegalCircle(param1:AstarGridNode) : Boolean
      {
         var collided:Boolean;
         var fixture:b2Fixture;
         var grid:AstarGridNode = param1;
         var CollisionCallback:* = function(param1:b2Fixture):void
         {
            var _loc2_:b2Shape = param1.GetShape();
            if(param1.GetBody().GetType() == b2Body.b2_staticBody)
            {
               collided = true;
               mCollFixture = param1;
            }
         };
         var gridCenter:b2Vec2 = NavCollider.convertToB2Vec2(grid.Center);
         var circle:b2CircleShape = new b2CircleShape(heroCollisionRadius);
         var transform:b2Transform = new b2Transform();
         transform.position = gridCenter;
         collided = false;
         mDistributedDungeonFloor.box2DWorld.QueryShape(CollisionCallback,circle,transform);
         return !collided;
      }
      
      public function LineOfSight(param1:Vector3D, param2:Vector3D) : Boolean
      {
         var _loc3_:b2Vec2 = NavCollider.convertToB2Vec2(param1);
         var _loc4_:b2Vec2 = NavCollider.convertToB2Vec2(param2);
         mCollFixture = mDistributedDungeonFloor.box2DWorld.RayCastOne(_loc3_,_loc4_);
         if(mCollFixture)
         {
            Logger.info("no line of sight between " + param1 + " and " + param2);
            return false;
         }
         return true;
      }
      
      public function Search(param1:Vector3D, param2:Vector3D) : void
      {
         var _loc7_:b2Transform = null;
         mClosestGrid = null;
         mAnswerPath.splice(0,mAnswerPath.length);
         mOpenList.splice(0);
         mConsideredNodeCount = 0;
         mUniquePassKey++;
         pickedClosestGrid = false;
         var _loc4_:Vector3D = GetAstarGridCenter(param1);
         var _loc3_:Vector3D = GetAstarGridCenter(param2);
         var _loc8_:uint = GetAstarGrid(param1);
         var _loc5_:uint = GetAstarGrid(param2);
         goalPoint = param2;
         var _loc6_:Boolean = AstarWorker(_loc8_,_loc5_);
         if(_loc6_)
         {
            ReconstructPath(_loc5_,_loc8_);
         }
         else if(mClosestGrid != null)
         {
            pickedClosestGrid = true;
            ReconstructPath(mClosestGrid.Id,_loc8_);
         }
         if(mDistributedDungeonFloor.debugVisualizer != null)
         {
            _loc7_ = new b2Transform();
            _loc7_.position = NavCollider.convertToB2Vec2(_loc4_);
            mDistributedDungeonFloor.debugVisualizer.makeAGridCircle(_loc7_,new b2Color(1,0,0));
            _loc7_ = new b2Transform();
            _loc7_.position = NavCollider.convertToB2Vec2(_loc3_);
            mDistributedDungeonFloor.debugVisualizer.makeAGridCircle(_loc7_,new b2Color(1,0,0));
            for each(var _loc9_ in mAnswerPath)
            {
               if(!(_loc9_ == _loc8_ || _loc9_ == _loc5_))
               {
                  _loc7_ = new b2Transform();
                  _loc7_.position = NavCollider.convertToB2Vec2(Nodes[_loc9_].Center);
                  mDistributedDungeonFloor.debugVisualizer.makeAGridCircle(_loc7_,new b2Color(0,0,1));
               }
            }
         }
      }
      
      public function AstarWorker(param1:uint, param2:uint) : Boolean
      {
         var _loc9_:AstarGridNode = null;
         var _loc3_:AstarGridNode = null;
         var _loc5_:Boolean = false;
         var _loc6_:Number = NaN;
         var _loc4_:AstarGridNode = Nodes[param1];
         var _loc11_:AstarGridNode = Nodes[param2];
         if(_loc4_ == null)
         {
            Logger.info("startGridIdx: " + param1 + " is invalid");
            return false;
         }
         if(_loc11_ == null)
         {
            Logger.info("goalGridIdx: " + param2 + " is invalid");
            return false;
         }
         param2 = _loc11_.Id;
         var _loc7_:Number = GetManhattanDistance(_loc4_.Center,goalPoint);
         _loc4_.g = 0;
         _loc4_.h = _loc7_;
         _loc4_.f = _loc7_;
         mOpenList.push(_loc4_);
         var _loc10_:* = _loc7_;
         mClosestGrid = _loc4_;
         while(mOpenList.length > 0)
         {
            _loc9_ = mOpenList.front();
            if(_loc9_.Id == param2)
            {
               return true;
            }
            mOpenList.pop();
            _loc9_.visited = mUniquePassKey;
            for each(var _loc8_ in _loc9_.Neighbors)
            {
               _loc3_ = Nodes[_loc8_];
               if(_loc3_ != null)
               {
                  if(_loc3_.visited != mUniquePassKey)
                  {
                     _loc5_ = false;
                     _loc6_ = _loc9_.g + _loc9_.costToNeighbor(_loc3_.Id);
                     if(!mOpenList.contains(_loc3_))
                     {
                        if(_loc3_.Id == param2)
                        {
                        }
                        if(!IsGridLegalCircle(_loc3_))
                        {
                           _loc3_.visited = mUniquePassKey;
                           continue;
                        }
                        if(_loc6_ < 850)
                        {
                           _loc5_ = true;
                        }
                     }
                     else if(_loc6_ < _loc3_.g)
                     {
                        _loc5_ = true;
                     }
                     if(_loc5_)
                     {
                        mConsideredNodeCount++;
                        _loc3_.g = _loc6_;
                        _loc3_.h = GetManhattanDistance(_loc3_.Center,goalPoint);
                        _loc3_.f = _loc3_.g + _loc3_.h;
                        _loc3_.Parent = _loc9_.Id;
                        mOpenList.push(_loc3_);
                        if(_loc3_.h < _loc10_)
                        {
                           _loc10_ = _loc3_.h;
                           mClosestGrid = _loc3_;
                        }
                     }
                  }
               }
            }
         }
         return false;
      }
      
      public function ReconstructPath(param1:uint, param2:uint) : void
      {
         var _loc3_:* = param1;
         mAnswerPath.push(_loc3_);
         while(_loc3_ != param2)
         {
            _loc3_ = Nodes[_loc3_].Parent;
            mAnswerPath.push(_loc3_);
         }
      }
      
      public function DrawAstarGridsInTile(param1:uint) : void
      {
         var _loc4_:b2Transform = null;
         var _loc5_:* = 0;
         var _loc6_:* = 0;
         var _loc7_:* = 0;
         var _loc8_:* = 0;
         var _loc2_:* = 0;
         var _loc3_:* = 0;
         var _loc9_:* = 0;
         if(mDistributedDungeonFloor.debugVisualizer != null)
         {
            _loc4_ = new b2Transform();
            _loc5_ = uint(param1 % 12) * 900;
            _loc6_ = uint(param1 / 12) * 900;
            _loc7_ = _loc5_ / 50;
            _loc8_ = _loc6_ / 50;
            _loc2_ = _loc7_;
            while(_loc2_ < _loc7_ + 18)
            {
               _loc3_ = _loc8_;
               while(_loc3_ < _loc8_ + 18)
               {
                  _loc9_ = _loc2_ + _loc3_ * 216;
                  _loc4_.position = NavCollider.convertToB2Vec2(Nodes[_loc9_].Center);
                  mDistributedDungeonFloor.debugVisualizer.makeAGridRectangle(_loc4_,new b2Color(0.5,0.5,0.5));
                  _loc3_++;
               }
               _loc2_++;
            }
         }
      }
   }
}

