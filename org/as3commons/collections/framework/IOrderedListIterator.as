package org.as3commons.collections.framework
{
   public interface IOrderedListIterator extends IListIterator
   {
      
      function addBefore(param1:*) : uint;
      
      function addAfter(param1:*) : uint;
      
      function replace(param1:*) : Boolean;
   }
}

