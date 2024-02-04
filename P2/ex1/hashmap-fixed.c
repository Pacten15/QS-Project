/* Copyright (C) 2014  Richard Wiedenhöft <richard.wiedenhoeft@gmail.com>
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 * THE SOFTWARE.
 */

#include "hashmap.h"
#include <assert.h>
#include <string.h>

unsigned long int hashmap_fnv1a(void *data, unsigned long int len) {
  unsigned char *p = (unsigned char *)data;
  unsigned long int h = 2166136261UL;
  unsigned long int i;

  for (i = 0; i < len; i++) {
    h = (h ^ p[i]) * 16777619;
  }

  return h;
}

int hashmap_hash(char *str, int max_hash) {
  unsigned long int fnv1a_hash = hashmap_fnv1a((void *)str, strlen(str));
  int hash = (int)(fnv1a_hash % (max_hash + 1));
  return hash;
}

struct hashmap_s {
  int size;
  struct hashmap_field *fields;
};

struct hashmap_field {
  int size;
  struct hashmap_entry *entries;
};

struct hashmap_entry {
  char *key;
  void *val;
  size_t len;
};

hashmap_t hashmap_new(int size) {
    hashmap_t map = (hashmap_t)malloc(sizeof(struct hashmap_s));

    /*Fix 1*/
    if(!map){
        return NULL;
    }
    struct hashmap_field *fields =
        (struct hashmap_field *)malloc(sizeof(struct hashmap_field) * size);

    if (!fields) {
      free(map);
      /*Fix 1*/
      return NULL;
    }


    for (int i = 0; i < size; i++) {
      struct hashmap_field *field = &fields[i];
      field->size = 0;
      field->entries = NULL;
    }

    /*Bug-1*/
    map->size = size;
    map->fields = fields;

    return map;
}

void hashmap_free(hashmap_t map) {
  for (int i = 0; i < map->size; i++) {
    struct hashmap_field *field = map->fields + i;
    if (field->entries != 0) {
      int j;
      for (j = 0; j < field->size; j++) {
        struct hashmap_entry *entry = field->entries + j;
        free(entry->key);
        free(entry->val);
      }
      free(field->entries);
    }
  }
  free(map->fields);
  free(map);
}

void hashmap_set(hashmap_t map, char *key, void *value, size_t length) {
  /*Fix 7*/
  if(map == NULL) {
    return;
  }
  
  int hash = hashmap_hash(key, map->size - 1);
  
  struct hashmap_field *field = map->fields + hash;
  struct hashmap_entry *entry ;
  int i;
  for (i = 0; i < field->size; i++) {
    entry = field->entries + i;
    if (strcmp(entry->key, key) == 0) {
      free(entry->val);
      goto set_val;
    }
  } 
  if (value == NULL) {
    return;
  }
  field->size++;
  struct hashmap_entry *entries = (struct hashmap_entry *)malloc(field->size * sizeof(struct hashmap_entry));

  memcpy(entries, field->entries,
          (field->size - 1) * sizeof(struct hashmap_entry));


  
  entry = &entries[field->size - 1];

  /*Bug 4*/
  /*Fix 4*/
  entry->key = (char *)malloc(strlen(key) + 1);
  /*Fix 7*/
  if( entry->key != NULL){
    /*Bug 7*/
    strcpy(entry->key, key);
  }
  
  field->entries = entries;

  set_val:
    if (value != NULL) {
      /*Bug 9*/
      void *val = malloc(length);
      entry->val = memcpy(val, value, length);
      entry->len = length;
      /*Fix 9*/
      free(val);
      
    } else {
      /*Bug 8*/
      free(entry->key);
      /*Fix 8*/
      entry->len = 0;
      field->size--;
      if (entry != (field->entries + field->size)) {
        memcpy((void *)entry, (void *)(field->entries + field->size),
              sizeof(struct hashmap_entry));
      }
      field->entries = realloc((void *)field->entries,
                              field->size * sizeof(struct hashmap_entry));
    }
    
}


void *hashmap_get(hashmap_t map, char *key) {
  int hash = hashmap_hash(key, map->size - 1);
  struct hashmap_field *field = map->fields + hash;
  struct hashmap_entry *entry;

  int i;
  for (i = 0; i < field->size; i++) {
    entry = field->entries + i;
    if (strcmp(entry->key, key) == 0) {
      void *val = malloc(entry->len);
      /*Fixes 3*/
      if(val != NULL){
        /*Bug 3*/ /*Bug 2*/
        memcpy(val, entry->val, entry->len);
        /*Fix 2*/
        return val;
      }
    }
  }
  return NULL;
}

int main() {
  hashmap_t map = hashmap_new(8);

  char *key = "42";
  int value = 42;
  /*Bug 6*/
  hashmap_set(map, key, &value, sizeof(int));
  /*Bug 5*/
  int *ret = (int *)hashmap_get(map, key);
  /*Fix 5*/
  if(ret) {
    assert(*ret == value);
    free(ret);
  }
  
  

  hashmap_free(map);
  return 0;
}