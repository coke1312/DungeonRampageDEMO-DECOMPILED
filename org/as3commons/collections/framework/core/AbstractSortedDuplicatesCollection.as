package org.as3commons.collections.framework.core
{
   import org.as3commons.collections.framework.IComparator;
   import org.as3commons.collections.framework.IDuplicates;
   
   use namespace as3commons_collections;
   
   public class AbstractSortedDuplicatesCollection extends AbstractSortedCollection implements IDuplicates
   {
      
      public function AbstractSortedDuplicatesCollection(param1:IComparator)
      {
         super(param1);
      }
      
      public function removeAll(param1:*) : uint
      {
         var _loc4_:SortedNode = null;
         var _loc2_:SortedNode = firstEqualNode(param1);
         if(!_loc2_)
         {
            return 0;
         }
         var _loc3_:uint = 0;
         while(_loc2_)
         {
            if(_comparator.compare(param1,_loc2_.item))
            {
               break;
            }
            if(_loc2_.item === param1)
            {
               _loc4_ = as3commons_collections::nextNode_internal(_loc2_);
               removeNode(_loc2_);
               _loc2_ = _loc4_;
               _loc3_++;
            }
            else
            {
               _loc2_ = as3commons_collections::nextNode_internal(_loc2_);
            }
         }
         return _loc3_;
      }
      
      public function count(param1:*) : uint
      {
         var _loc2_:SortedNode = firstEqualNode(param1);
         if(!_loc2_)
         {
            return 0;
         }
         var _loc3_:uint = 0;
         if(_loc2_.item === param1)
         {
            _loc3_++;
         }
         _loc2_ = as3commons_collections::nextNode_internal(_loc2_);
         while(_loc2_)
         {
            if(_comparator.compare(param1,_loc2_.item))
            {
               break;
            }
            if(_loc2_.item === param1)
            {
               _loc3_++;
            }
            _loc2_ = as3commons_collections::nextNode_internal(_loc2_);
         }
         return _loc3_;
      }
   }
}

