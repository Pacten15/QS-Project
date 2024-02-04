#include <stdlib.h>
#include <stdio.h>
#include "assert.h"
#include "../treetable.h"
//#include "../treetable.c"


void get_greater_test_template(int key1,int key2,int key3, char value1[], char value2[], char value3[]) {
    TreeTable *table;
    treetable_new(&table);

    void* greater_key_2;
    enum cc_stat status1 = treetable_get_greater_than(table, &key1, &greater_key_2);
    assert(status1 == CC_ERR_KEY_NOT_FOUND);

    
    treetable_add(table, &key1, value1);
    treetable_add(table, &key2, value2);
    treetable_add(table, &key3, value3);
    
   
     
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


/*
int main() {
    get_greater_test_template(0,0,0,"........","........","........");
    get_greater_test_template(0,-2147483648,0,"........","........","........");
    get_greater_test_template(16777216,16777216,0,"........","........","........");
    get_greater_test_template(1,0,0,"........","........","........");
    get_greater_test_template(-2147483646,-2147483648,0,"........","........","........");
    get_greater_test_template(-2130706432,-2130706432,0,"........","........","........");
    get_greater_test_template(33554432,16777216,0,"........","........","........");
    get_greater_test_template(0,16777216,0,"........","........","........");
    get_greater_test_template(2,-2013265920,0,"........","........","........");
    get_greater_test_template(1,16777216,0,"........","........","........");
    get_greater_test_template(-2013265920,0,0,"........","........","........");
    get_greater_test_template(-2147483616,-1073741824,0,"........","........","........");
    get_greater_test_template(-2130706432,16777216,0,"........","........","........");

}
*/
