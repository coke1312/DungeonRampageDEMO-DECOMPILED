package com.greensock.plugins
{
   import com.greensock.*;
   import com.greensock.core.*;
   import flash.display.*;
   import flash.geom.ColorTransform;
   import flash.geom.Transform;
   
   public class TintPlugin extends TweenPlugin
   {
      
      public static const API:Number = 1;
      
      protected static var _props:Array = ["redMultiplier","greenMultiplier","blueMultiplier","alphaMultiplier","redOffset","greenOffset","blueOffset","alphaOffset"];
      
      protected var _ct:ColorTransform;
      
      protected var _transform:Transform;
      
      protected var _ignoreAlpha:Boolean;
      
      public function TintPlugin()
      {
         super();
         this.propName = "tint";
         this.overwriteProps = ["tint"];
      }
      
      override public function onInitTween(param1:Object, param2:*, param3:TweenLite) : Boolean
      {
         if(!(param1 is DisplayObject))
         {
            return false;
         }
         var _loc4_:ColorTransform = new ColorTransform();
         if(param2 != null && param3.vars.removeTint != true)
         {
            _loc4_.color = uint(param2);
         }
         _ignoreAlpha = true;
         _transform = DisplayObject(param1).transform;
         init(_transform.colorTransform,_loc4_);
         return true;
      }
      
      override public function set changeFactor(param1:Number) : void
      {
         var _loc2_:ColorTransform = null;
         updateTweens(param1);
         if(_transform)
         {
            if(_ignoreAlpha)
            {
               _loc2_ = _transform.colorTransform;
               _ct.alphaMultiplier = _loc2_.alphaMultiplier;
               _ct.alphaOffset = _loc2_.alphaOffset;
            }
            _transform.colorTransform = _ct;
         }
      }
      
      public function init(param1:ColorTransform, param2:ColorTransform) : void
      {
         var _loc4_:String = null;
         _ct = param1;
         var _loc3_:int = int(_props.length);
         var _loc5_:int = int(_tweens.length);
         while(_loc3_--)
         {
            _loc4_ = _props[_loc3_];
            if(_ct[_loc4_] != param2[_loc4_])
            {
               var _loc6_:*;
               _tweens[_loc6_ = _loc5_++] = new PropTween(_ct,_loc4_,_ct[_loc4_],param2[_loc4_] - _ct[_loc4_],"tint",false);
            }
         }
      }
   }
}

