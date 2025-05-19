package org.as3commons.collections.framework
{
   public interface IList extends IOrder, IDuplicates
   {
      
      function removeAllAt(param1:uint, param2:uint) : Array;
      
      function add(param1:*) : uint;
      
      function set array(param1:Array) : void;
      
      function lastIndexOf(param1:*) : int;
      
      function itemAt(param1:uint) : *;
      
      function removeAt(param1:uint) : *;
      
      function firstIndexOf(param1:*) : int;
   }
}

