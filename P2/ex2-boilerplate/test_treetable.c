#include <stdlib.h>
#include <stdio.h>
#include "assert.h"
#include "treetable.h"
#include "treetable.c"

void test_balanced() {
    TreeTable *table;
    treetable_new(&table);

    int key1 = 1, key2 = 2, key3 = 3, key4 = 4, key5 = 5;
    char *value1 = "value1", *value2 = "value2", *value3 = "value3", *value4 = "value4", *value5 = "value5";

    // Test adding five key-value pairs
    treetable_add(table, &key1, value1);
    treetable_add(table, &key2, value2);
    treetable_add(table, &key3, value3);
    treetable_add(table, &key4, value4);
    treetable_add(table, &key5, value5);

    // Test that the tree is balanced
    assert(balanced(table) == 1);

    treetable_destroy(table);
}

void test_unbalanced() {
    TreeTable *table;
    treetable_new(&table);

    int key1 = 1, key2 = 2, key3 = 3, key4 = 4, key5 = 5, key6 = 6, key7 = 7, key8 = 8;
    char *value1 = "value1", *value2 = "value2", *value3 = "value3", *value4 = "value4", *value5 = "value5", *value6 = "value6", *value7 = "value7", *value8 = "value8";

    // Test adding six key-value pairs in a way that makes the tree unbalanced
    treetable_add(table, &key1, value1);
    treetable_add(table, &key2, value2);
    treetable_add(table, &key3, value3);
    treetable_add(table, &key4, value4);
    treetable_add(table, &key5, value5);
    treetable_add(table, &key6, value6);
    treetable_add(table, &key7, value7);

    // Test that the tree is unbalanced
    assert(balanced(table) == 0);

    treetable_destroy(table);
}


void test_sorted() {
    TreeTable *table;
    treetable_new(&table);

    int key1 = 1, key2 = 2, key3 = 3, key4 = 4, key5 = 5;
    char *value1 = "value1", *value2 = "value2", *value3 = "value3", *value4 = "value4", *value5 = "value5";

    // Test adding five key-value pairs in sorted order
    treetable_add(table, &key1, value1);
    treetable_add(table, &key2, value2);
    treetable_add(table, &key3, value3);
    treetable_add(table, &key4, value4);
    treetable_add(table, &key5, value5);

    // Test that the tree is sorted

    assert(sorted(table) == 1);

    treetable_destroy(table);
}

void test_unsorted() {
    TreeTable *table;
    treetable_new(&table);

    int key1 = 1, key2 = 7, key3 = 3, key4 = 4, key5 = 5;
    char *value1 = "value1", *value2 = "value2", *value3 = "value3", *value4 = "value4", *value5 = "value5";

    // Test adding five key-value pairs in unsorted order
    treetable_add(table, &key3, value3);
    treetable_add(table, &key1, value1);
    treetable_add(table, &key5, value5);
    treetable_add(table, &key2, value2);
    treetable_add(table, &key4, value4);

    // Test that the tree is unsorted
    assert(sorted(table) == 0);

    treetable_destroy(table);
}

int main() {
    test_balanced();
    test_unbalanced();
    test_sorted();
    test_unsorted();
    return 0;
}