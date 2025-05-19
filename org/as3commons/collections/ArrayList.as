package org.as3commons.collections
{
   import org.as3commons.collections.framework.IComparator;
   import org.as3commons.collections.framework.IIterator;
   import org.as3commons.collections.framework.IOrderedList;
   import org.as3commons.collections.framework.core.AbstractList;
   import org.as3commons.collections.framework.core.ArrayListIterator;
   import org.as3commons.collections.utils.ArrayUtils;
   
   public class ArrayList extends AbstractList implements IOrderedList
   {
      
      public function ArrayList()
      {
         super();
      }
      
      public function reverse() : Boolean
      {
         if(_array.length < 2)
         {
            return false;
         }
         _array.reverse();
         return true;
      }
      
      public function sort(param1:IComparator) : Boolean
      {
         if(_array.length < 2)
         {
            return false;
         }
         ArrayUtils.mergeSort(_array,param1);
         return true;
      }
      
      public function addAllAt(param1:uint, param2:Array) : Boolean
      {
         if(param1 <= _array.length)
         {
            _array = _array.slice(0,param1).concat(param2).concat(_array.slice(param1));
            return true;
         }
         return false;
      }
      
      public function replaceAt(param1:uint, param2:*) : Boolean
      {
         if(param1 < _array.length)
         {
            if(_array[param1] === param2)
            {
               return false;
            }
            _array[param1] = param2;
            return true;
         }
         return false;
      }
      
      public function addFirst(param1:*) : void
      {
         _array.unshift(param1);
      }
      
      public function addAt(param1:uint, param2:*) : Boolean
      {
         if(param1 <= _array.length)
         {
            _array.splice(param1,0,param2);
            return true;
         }
         return false;
      }
      
      override public function iterator(param1:* = undefined) : IIterator
      {
         var _loc2_:uint = param1 is uint ? param1 : 0;
         return new ArrayListIterator(this,_loc2_);
      }
      
      public function addLast(param1:*) : void
      {
         _array.push(param1);
      }
   }
}

