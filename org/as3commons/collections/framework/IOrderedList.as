package org.as3commons.collections.framework
{
   public interface IOrderedList extends IList, IInsertionOrder
   {
      
      function addAt(param1:uint, param2:*) : Boolean;
      
      function replaceAt(param1:uint, param2:*) : Boolean;
      
      function addAllAt(param1:uint, param2:Array) : Boolean;
      
      function addLast(param1:*) : void;
      
      function addFirst(param1:*) : void;
   }
}

