package org.as3commons.collections.framework.core
{
   public class SortedNode
   {
      
      private static var _order:uint = 0;
      
      public var right:SortedNode;
      
      public var priority:uint;
      
      public var left:SortedNode;
      
      public var parent:SortedNode;
      
      public var order:uint;
      
      public var item:*;
      
      public function SortedNode(param1:*)
      {
         super();
         this.item = param1;
         this.priority = Math.random() * uint.MAX_VALUE;
         this.order = ++_order;
      }
   }
}

