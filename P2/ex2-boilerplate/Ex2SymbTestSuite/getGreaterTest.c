#include <stdlib.h>
#include <stdio.h>
#include "assert.h"
#include "../treetable.h"
#include "klee/klee.h"

int main() {
    TreeTable *table;
    treetable_new(&table);

    int key1, key2, key3;
    char *value1, *value2, *value3;


    klee_make_symbolic(&key1, sizeof(key1), "key1");
    klee_make_symbolic(&key2, sizeof(key2), "key2");
    klee_make_symbolic(&key3, sizeof(key3), "key3");
    klee_make_symbolic(&value1, sizeof(value1), "value1");
    klee_make_symbolic(&value2, sizeof(value2), "value2");
    klee_make_symbolic(&value3, sizeof(value3), "value3");


    void* greater_key_2;
    enum cc_stat status1 = treetable_get_greater_than(table, &key1, &greater_key_2);
    assert(status1 == CC_ERR_KEY_NOT_FOUND);

    // Test adding three key-value pairs
    treetable_add(table, &key1, value1);
    treetable_add(table, &key2, value2);
    treetable_add(table, &key3, value3);

  

    // Test getting a key greater than key1
    void* greater_key;
    if(key1 < key2 || key1 < key3 ){
        enum cc_stat status = treetable_get_greater_than(table, &key1, &greater_key);
        if(status == CC_OK ){

            int* int_ptr = (int*)greater_key; // cast void* to int*
            int dereferenced_value = *int_ptr;
            assert(dereferenced_value > key1);
        }
    }
    treetable_destroy(table);
}