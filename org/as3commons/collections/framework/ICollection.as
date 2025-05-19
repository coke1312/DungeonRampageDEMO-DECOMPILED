package org.as3commons.collections.framework
{
   public interface ICollection extends IIterable
   {
      
      function get size() : uint;
      
      function remove(param1:*) : Boolean;
      
      function has(param1:*) : Boolean;
      
      function clear() : Boolean;
      
      function toArray() : Array;
   }
}

