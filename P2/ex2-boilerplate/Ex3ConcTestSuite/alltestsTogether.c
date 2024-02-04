#include <stdlib.h>
#include <stdio.h>
#include "assert.h"
#include "../treetable.h"
#include "../treetable.c"
#include "addTest.c"
#include "getTest.c"
#include "getGreaterTest.c"
#include "firstKeyTest.c"

int main()
{
    char dot = '.';
    add_test_template(0, 0, dot, dot);
    add_test_template(1, 0, dot, dot);
    add_test_template(-2013265920, 0, dot, dot);
    first_key_test_template(0, 0, 0, "........", "........", "........");
    first_key_test_template(0, -2147483648, 0, "........", "........", "........");
    first_key_test_template(16777216, 16777216, 0, "........", "........", "........");
    first_key_test_template(-2147483646, -2147483648, 0, "........", "........", "........");
    first_key_test_template(-2130706432, -2130706432, 0, "........", "........", "........");
    first_key_test_template(0, 16777216, 0, "........", "........", "........");
    first_key_test_template(1, 0, 0, "........", "........", "........");
    first_key_test_template(1, 16777216, 0, "........", "........", "........");
    first_key_test_template(33554432, 16777216, 0, "........", "........", "........");
    first_key_test_template(-2013265920, 0, 0, "........", "........", "........");
    first_key_test_template(2, -2013265920, 0, "........", "........", "........");
    first_key_test_template(-2147483616, -1073741824, 0, "........", "........", "........");
    first_key_test_template(-2130706432, 16777216, 0, "........", "........", "........");
    get_test_template(0, 0, dot, dot);
    get_test_template(1, 0, dot, dot);
    get_test_template(-2013265920, 0, dot, dot);
    get_greater_test_template(0, 0, 0, "........", "........", "........");
    get_greater_test_template(0, -2147483648, 0, "........", "........", "........");
    get_greater_test_template(16777216, 16777216, 0, "........", "........", "........");
    get_greater_test_template(1, 0, 0, "........", "........", "........");
    get_greater_test_template(-2147483646, -2147483648, 0, "........", "........", "........");
    get_greater_test_template(-2130706432, -2130706432, 0, "........", "........", "........");
    get_greater_test_template(33554432, 16777216, 0, "........", "........", "........");
    get_greater_test_template(0, 16777216, 0, "........", "........", "........");
    get_greater_test_template(2, -2013265920, 0, "........", "........", "........");
    get_greater_test_template(1, 16777216, 0, "........", "........", "........");
    get_greater_test_template(-2013265920, 0, 0, "........", "........", "........");
    get_greater_test_template(-2147483616, -1073741824, 0, "........", "........", "........");
    get_greater_test_template(-2130706432, 16777216, 0, "........", "........", "........");
}
