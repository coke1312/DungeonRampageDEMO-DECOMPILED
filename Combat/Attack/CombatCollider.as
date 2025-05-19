package Combat.Attack
{
   import Actor.ActorGameObject;
   import Box2D.Collision.Shapes.b2Shape;
   import Box2D.Common.Math.b2Transform;
   import Box2D.Dynamics.b2World;
   import Brain.Logger.Logger;
   import Dungeon.NavCollider;
   import Facade.DBFacade;
   import flash.geom.Vector3D;
   
   public class CombatCollider
   {
      
      protected var mDBFacade:DBFacade;
      
      protected var mParentGameObject:ActorGameObject;
      
      protected var mBox2DWorld:b2World;
      
      protected var mB2Shape:b2Shape;
      
      protected var mB2Transform:b2Transform;
      
      public function CombatCollider(param1:DBFacade, param2:ActorGameObject, param3:b2World)
      {
         super();
         mDBFacade = param1;
         mParentGameObject = param2;
         mBox2DWorld = param3;
         buildShape();
      }
      
      public function get shape() : b2Shape
      {
         return mB2Shape;
      }
      
      public function get transform() : b2Transform
      {
         return mB2Transform;
      }
      
      protected function buildShape() : void
      {
         Logger.error("buildShape needs to be overridden by the subclasses.");
      }
      
      public function set position(param1:Vector3D) : void
      {
         mB2Transform.position = NavCollider.convertToB2Vec2(param1);
      }
      
      public function get worldPosition() : Vector3D
      {
         return NavCollider.convertToVector3D(mB2Transform.position);
      }
      
      public function destroy() : void
      {
         mDBFacade = null;
         mParentGameObject = null;
         mBox2DWorld = null;
         mB2Shape = null;
         mB2Transform = null;
      }
   }
}

