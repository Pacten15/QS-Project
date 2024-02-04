#include <stdlib.h>
#include <stdio.h>
#include "assert.h"
#include "../treetable.h"
//#include "../treetable.c"




void add_test_template(int key1,int key2, char value1, char value2) {
    TreeTable *table;
    treetable_new(&table);

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

/**

int main() {

    char dot = '.';
    add_test_template(0,0,dot,dot);
    add_test_template(1,0,dot,dot);
    add_test_template(-2013265920, 0, dot, dot);
}
**/



