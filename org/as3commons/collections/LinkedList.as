package org.as3commons.collections
{
   import org.as3commons.collections.framework.IIterator;
   import org.as3commons.collections.framework.ILinkedList;
   import org.as3commons.collections.framework.core.AbstractLinkedDuplicatesCollection;
   import org.as3commons.collections.framework.core.LinkedListIterator;
   import org.as3commons.collections.framework.core.LinkedNode;
   import org.as3commons.collections.framework.core.as3commons_collections;
   
   use namespace as3commons_collections;
   
   public class LinkedList extends AbstractLinkedDuplicatesCollection implements ILinkedList
   {
      
      public function LinkedList()
      {
         super();
      }
      
      override public function iterator(param1:* = undefined) : IIterator
      {
         return new LinkedListIterator(this);
      }
      
      public function addFirst(param1:*) : void
      {
         addNodeFirst(new LinkedNode(param1));
      }
      
      public function addLast(param1:*) : void
      {
         addNodeLast(new LinkedNode(param1));
      }
      
      public function add(param1:*) : void
      {
         addNodeLast(new LinkedNode(param1));
      }
      
      as3commons_collections function addNodeBefore_internal(param1:LinkedNode, param2:LinkedNode) : void
      {
         addNodeBefore(param1,param2);
      }
      
      as3commons_collections function removeNode_internal(param1:LinkedNode) : void
      {
         removeNode(param1);
      }
   }
}

