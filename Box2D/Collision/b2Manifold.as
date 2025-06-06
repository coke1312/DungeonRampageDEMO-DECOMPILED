package Box2D.Collision
{
   import Box2D.Common.*;
   import Box2D.Common.Math.*;
   
   use namespace b2internal;
   
   public class b2Manifold
   {
      
      public static const e_circles:int = 1;
      
      public static const e_faceA:int = 2;
      
      public static const e_faceB:int = 4;
      
      public var m_points:Vector.<b2ManifoldPoint>;
      
      public var m_localPlaneNormal:b2Vec2;
      
      public var m_localPoint:b2Vec2;
      
      public var m_type:int;
      
      public var m_pointCount:int = 0;
      
      public function b2Manifold()
      {
         super();
         this.m_points = new Vector.<b2ManifoldPoint>(b2Settings.b2_maxManifoldPoints);
         var _loc1_:int = 0;
         while(_loc1_ < b2Settings.b2_maxManifoldPoints)
         {
            this.m_points[_loc1_] = new b2ManifoldPoint();
            _loc1_++;
         }
         this.m_localPlaneNormal = new b2Vec2();
         this.m_localPoint = new b2Vec2();
      }
      
      public function Reset() : void
      {
         var _loc1_:int = 0;
         while(_loc1_ < b2Settings.b2_maxManifoldPoints)
         {
            (this.m_points[_loc1_] as b2ManifoldPoint).Reset();
            _loc1_++;
         }
         this.m_localPlaneNormal.SetZero();
         this.m_localPoint.SetZero();
         this.m_type = 0;
         this.m_pointCount = 0;
      }
      
      public function Set(param1:b2Manifold) : void
      {
         this.m_pointCount = param1.m_pointCount;
         var _loc2_:int = 0;
         while(_loc2_ < b2Settings.b2_maxManifoldPoints)
         {
            (this.m_points[_loc2_] as b2ManifoldPoint).Set(param1.m_points[_loc2_]);
            _loc2_++;
         }
         this.m_localPlaneNormal.SetV(param1.m_localPlaneNormal);
         this.m_localPoint.SetV(param1.m_localPoint);
         this.m_type = param1.m_type;
      }
      
      public function Copy() : b2Manifold
      {
         var _loc1_:b2Manifold = new b2Manifold();
         _loc1_.Set(this);
         return _loc1_;
      }
   }
}

