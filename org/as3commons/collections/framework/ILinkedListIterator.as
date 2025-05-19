package org.as3commons.collections.framework
{
   public interface ILinkedListIterator extends ICollectionIterator
   {
      
      function addBefore(param1:*) : void;
      
      function replace(param1:*) : Boolean;
      
      function get nextItem() : *;
      
      function get previousItem() : *;
      
      function addAfter(param1:*) : void;
   }
}

