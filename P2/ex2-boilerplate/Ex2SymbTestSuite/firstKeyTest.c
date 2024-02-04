#include <stdlib.h>
#include <stdio.h>
#include "assert.h"
#include "../treetable.h"
#include "klee/klee.h"

int main() {
    TreeTable *table;
    treetable_new(&table);

    TreeTable *table2;
    treetable_new(&table2);

    int key1, key2, key3;
    char *value1, *value2, *value3;


    klee_make_symbolic(&key1, sizeof(key1), "key1");
    klee_make_symbolic(&key2, sizeof(key2), "key2");
    klee_make_symbolic(&key3, sizeof(key3), "key3");
    klee_make_symbolic(&value1, sizeof(value1), "value1");
    klee_make_symbolic(&value2, sizeof(value2), "value2");
    klee_make_symbolic(&value3, sizeof(value3), "value3");
    

    

    // Test adding three key-value pairs
    treetable_add(table, &key1, value1);
    treetable_add(table, &key2, value2);
    treetable_add(table, &key3, value3);

    


    // Test getting the first key
    void* first_key;
    
    enum cc_stat status = treetable_get_first_key(table, &first_key);
    if(status == CC_OK){
    
        int* int_ptr = (int*)first_key; // cast void* to int*
        int dereferenced_value = *int_ptr;
        if (key1 < key2 && key1 < key3) {
            klee_assert(dereferenced_value == key1);
        } else if (key2 < key1 && key2 < key3) {
            klee_assert(dereferenced_value == key2);
        } else if (key3 < key1 && key3 < key2) {
            klee_assert(dereferenced_value == key3);
        }
    }
   
    treetable_destroy(table);




}