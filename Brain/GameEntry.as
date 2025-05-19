package Brain
{
   import flash.display.DisplayObject;
   import flash.display.DisplayObjectContainer;
   import flash.display.MovieClip;
   import flash.display.Stage;
   import flash.events.KeyboardEvent;
   import flash.utils.getQualifiedClassName;
   import org.as3commons.collections.Map;
   
   public class GameEntry extends MovieClip
   {
      
      protected var mStageRef:Stage;
      
      public function GameEntry()
      {
         super();
         mStageRef = stage;
         stage.addEventListener("keyDown",this.debugTrace);
      }
      
      protected function debugTrace(param1:KeyboardEvent) : void
      {
         var mc:MovieClip;
         var nodeTypes:Map;
         var recurse:Function;
         var keys:Array;
         var key:String;
         var event:KeyboardEvent = param1;
         if(event.ctrlKey)
         {
            switch(event.charCode)
            {
               case 61:
                  mc.foo;
                  break;
               case 32:
                  nodeTypes = new Map();
                  recurse = function(param1:DisplayObject, param2:int):void
                  {
                     var _loc4_:* = 0;
                     var _loc5_:int = 0;
                     var _loc8_:int = 0;
                     var _loc7_:String = getQualifiedClassName(param1);
                     if(nodeTypes.hasKey(_loc7_))
                     {
                        _loc4_ = nodeTypes.itemFor(_loc7_);
                        nodeTypes.replaceFor(_loc7_,_loc4_ + 1);
                     }
                     else
                     {
                        nodeTypes.add(_loc7_,1);
                     }
                     var _loc3_:String = "";
                     _loc5_ = 0;
                     while(_loc5_ < param2)
                     {
                        _loc3_ += "  ";
                        _loc5_++;
                     }
                     _loc3_ += param1.toString() + " " + param1.name;
                     trace(_loc3_);
                     var _loc6_:DisplayObjectContainer = param1 as DisplayObjectContainer;
                     if(_loc6_)
                     {
                        _loc8_ = 0;
                        while(_loc8_ < _loc6_.numChildren)
                        {
                           recurse(_loc6_.getChildAt(_loc8_),param2 + 1);
                           _loc8_++;
                        }
                     }
                  };
                  trace("======================================================================");
                  trace(" Stage Scene Graph");
                  trace("======================================================================");
                  recurse(stage,0);
                  trace("======================================================================");
                  trace(" Class Counts");
                  trace("======================================================================");
                  keys = nodeTypes.keysToArray();
                  keys.sort(function(param1:String, param2:String):int
                  {
                     return nodeTypes.itemFor(param2) - nodeTypes.itemFor(param1);
                  });
                  for each(key in keys)
                  {
                     trace(nodeTypes.itemFor(key),"\t",key);
                  }
            }
         }
      }
   }
}

