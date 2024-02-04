#include <stdlib.h>
#include <stdio.h>
#include "assert.h"
#include "../treetable.h"
//#include "../treetable.c"

void first_key_test_template(int key1,int key2,int key3, char value1[], char value2[], char value3[]) {
    TreeTable *table;
    treetable_new(&table);
    
    treetable_add(table, &key1, value1);
    treetable_add(table, &key2, value2);
    treetable_add(table, &key3, value3);
    
   
     
    void* out;
    enum cc_stat status = treetable_get_first_key(table, &out);
    int* int_ptr = (int*)out; // cast void* to int*
    int dereferenced_value = *int_ptr;
    if(status == CC_OK){
        if(key1 < key2 && key1 < key3){
            assert(dereferenced_value == key1);
        }
    else if(key2 < key1 && key2 < key3){
        assert(dereferenced_value == key2);
        }
    else if(key3 < key1 && key3 < key2){
        assert(dereferenced_value == key3);
    }
    }
    treetable_destroy(table);
  
}

/**
int main() {

    first_key_test_template(0,0,0,"........","........","........");
    first_key_test_template(0, -2147483648, 0,"........","........","........");
    first_key_test_template(16777216, 16777216, 0,"........","........","........");
    first_key_test_template(-2147483646, -2147483648, 0,"........","........","........");
    first_key_test_template(-2130706432, -2130706432, 0,"........","........","........");
    first_key_test_template(0, 16777216, 0,"........","........","........");
    first_key_test_template(1, 0, 0,"........","........","........");
    first_key_test_template(1, 16777216, 0,"........","........","........");
    first_key_test_template(33554432, 16777216, 0,"........","........","........");
    first_key_test_template(-2013265920, 0, 0,"........","........","........");
    first_key_test_template(2, -2013265920, 0,"........","........","........");
    first_key_test_template(-2147483616, -1073741824, 0,"........","........","........");
    first_key_test_template(-2130706432, 16777216, 0,"........","........","........");


}
**/
