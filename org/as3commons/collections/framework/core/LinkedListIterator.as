package org.as3commons.collections.framework.core
{
   import org.as3commons.collections.LinkedList;
   import org.as3commons.collections.framework.ILinkedListIterator;
   
   use namespace as3commons_collections;
   
   public class LinkedListIterator extends AbstractLinkedCollectionIterator implements ILinkedListIterator
   {
      
      public function LinkedListIterator(param1:LinkedList)
      {
         super(param1);
      }
      
      public function addBefore(param1:*) : void
      {
         _current = null;
         LinkedList(_collection).as3commons_collections::addNodeBefore_internal(_next,new LinkedNode(param1));
      }
      
      public function get previousItem() : *
      {
         return _next ? (_next.left ? _next.left.item : undefined) : (_collection.size ? _collection.as3commons_collections::lastNode_internal.item : undefined);
      }
      
      public function replace(param1:*) : Boolean
      {
         if(!_current)
         {
            return false;
         }
         if(_current.item === param1)
         {
            return false;
         }
         _current.item = param1;
         return true;
      }
      
      override protected function removeCurrent() : void
      {
         LinkedList(_collection).as3commons_collections::removeNode_internal(_current);
      }
      
      public function addAfter(param1:*) : void
      {
         _current = null;
         if(_next)
         {
            LinkedList(_collection).as3commons_collections::addNodeBefore_internal(_next,new LinkedNode(param1));
            _next = _next.left;
         }
         else
         {
            LinkedList(_collection).as3commons_collections::addNodeBefore_internal(null,new LinkedNode(param1));
            _next = _collection.as3commons_collections::lastNode_internal;
         }
      }
      
      public function get nextItem() : *
      {
         return _next ? _next.item : undefined;
      }
   }
}

