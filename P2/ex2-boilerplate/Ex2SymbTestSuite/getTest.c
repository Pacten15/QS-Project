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
    
    void* out;
    enum cc_stat status = treetable_get(table, &key1, &out);
    assert(status == CC_ERR_KEY_NOT_FOUND);

    // Test adding a single key-value pair and getting his value
    treetable_add(table, &key1, &value1);
    assert(treetable_contains_key(table, &key1));
    void* value;
    treetable_get(table, &key1, &value);
    char* int_ptr1 = (char*)value; // cast void* to char*
    char dereferenced_value1 = *int_ptr1;
    assert(dereferenced_value1 == value1);

    // Test adding a second key-value pair and getting his value
    treetable_add(table, &key2, &value2);
    assert(treetable_contains_key(table, &key2));
    treetable_get(table, &key2, &value);
    char* int_ptr2 = (char*)value; // cast void* to char*
    char dereferenced_value2 = *int_ptr2;
    assert(dereferenced_value2 == value2);

    treetable_destroy(table);
}