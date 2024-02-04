#include <stdlib.h>
#include <stdio.h>
#include "assert.h"
#include "../treetable.h"
#include "klee/klee.h"

int main() {
    TreeTable *table;
    treetable_new(&table);

    int key1, key2;
    char value1, value2;

    klee_make_symbolic(&key1, sizeof(key1), "key1");
    klee_make_symbolic(&key2, sizeof(key2), "key2");
    klee_make_symbolic(&value1, sizeof(value1), "value1");
    klee_make_symbolic(&value2, sizeof(value2), "value2");


    // Test adding three key-value pairs
    enum cc_stat status1 = treetable_add(table, &key1, &value1);
    enum cc_stat status2 = treetable_add(table, &key2, &value2);

    if( status1 == CC_OK && status2 == CC_OK){
        assert(treetable_contains_key(table, &key1));
        assert(treetable_contains_key(table, &key2));
        assert(treetable_contains_value(table, &value2) >= 1);     
    }
    

    treetable_destroy(table);
}