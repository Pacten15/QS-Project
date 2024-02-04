#include <stdlib.h>
#include <stdio.h>
#include "assert.h"
#include "../treetable.h"
//#include "../treetable.c"


void get_test_template(int key1,int key2, char value1, char value2) {
    TreeTable *table;
    treetable_new(&table);

    void* out;
    enum cc_stat status = treetable_get(table, &key1, &out);
    assert(status == CC_ERR_KEY_NOT_FOUND);
    
    // Test adding a single key-value pair
    treetable_add(table, &key1, &value1);
    assert(treetable_contains_key(table, &key1));
    void* value;
    treetable_get(table, &key1, &value);
    char* int_ptr1 = (char*)value; // cast void* to char*
    char dereferenced_value1 = *int_ptr1;
    assert(dereferenced_value1 == value1);

    // Test adding a second key-value pair
    treetable_add(table, &key2, &value2);
    assert(treetable_contains_key(table, &key2));
    treetable_get(table, &key2, &value);
    char* int_ptr2 = (char*)value; // cast void* to char*
    char dereferenced_value2 = *int_ptr2;
    assert(dereferenced_value2 == value2);

    treetable_destroy(table);
}

/**
int main() {

    char dot = '.';
    get_test_template(0,0,dot,dot);
    get_test_template(1,0, dot,dot);
    get_test_template(-2013265920, 0, dot, dot);
  
}
**/
