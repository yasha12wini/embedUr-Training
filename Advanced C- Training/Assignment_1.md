# Assignment 1

## Questions

- [Topic 1: Structures](#topic-1-structures)
- [Topic 2: Pointers](#topic-2-pointers)
- [Topic 3: Arrays](#topic-3-arrays)

---

# Topic 1: Structures

## Question

C program that represents a calendar for a week. Each day has:

- `dayName` (e.g., `"Monday"`)

- `tasks` (array of strings with maximum 3 tasks per day)

### Note

1. Define appropriate structures.

2. Allow the user to input tasks for any day.

3. Display all tasks grouped by the day.

---

## Answer

```c
#include <stdio.h>
#include <string.h>

#define DAYS 7
#define MAX_TASKS 3
#define MAX_LENGTH 100

struct Day {
    char dayName[20];
    char tasks[MAX_TASKS][MAX_LENGTH];
    int taskCount;
};

int main() {

    struct Day week[DAYS] = {
        {"Monday", {}, 0},
        {"Tuesday", {}, 0},
        {"Wednesday", {}, 0},
        {"Thursday", {}, 0},
        {"Friday", {}, 0},
        {"Saturday", {}, 0},
        {"Sunday", {}, 0}
    };

    int numTasks, i, j;

    for(i = 0; i < DAYS; i++) {

        printf("\nEnter number of tasks for %s (Max 3): ",
               week[i].dayName);
        scanf("%d", &numTasks);

        if(numTasks > MAX_TASKS) {
            numTasks = MAX_TASKS;
        }

        week[i].taskCount = numTasks;

        getchar();

        for(j = 0; j < numTasks; j++) {
            printf("Enter task %d: ", j + 1);
            fgets(week[i].tasks[j], MAX_LENGTH, stdin);

            week[i].tasks[j][strcspn(week[i].tasks[j], "\n")] = '\0';
        }
    }

    printf("\n\n===== WEEKLY CALENDAR =====\n");

    for(i = 0; i < DAYS; i++) {

        printf("\n%s:\n", week[i].dayName);

        if(week[i].taskCount == 0) {
            printf("No tasks\n");
        }
        else {
            for(j = 0; j < week[i].taskCount; j++) {
                printf("%d. %s\n", j + 1, week[i].tasks[j]);
            }
        }
    }

    return 0;
}
```

---

# Topic 2: Pointers

## Question

Write a function in C that takes a pointer to an integer array and its size, and then rearranges the array in-place such that all even numbers appear before odd numbers, preserving the original relative order using only pointer arithmetic (no indexing with []).

---

## Answer

```c
#include <stdio.h>

void rearrange(int *arr, int size) {

    int temp[size];
    int *p = arr;
    int *t = temp;
    int i;

    for(i = 0; i < size; i++) {
        if(*(p + i) % 2 == 0) {
            *t = *(p + i);
            t++;
        }
    }

    for(i = 0; i < size; i++) {
        if(*(p + i) % 2 != 0) {
            *t = *(p + i);
            t++;
        }
    }

    for(i = 0; i < size; i++) {
        *(arr + i) = *(temp + i);
    }
}

int main() {

    int arr[] = {5, 2, 7, 8, 1, 4, 9, 6};
    int size = sizeof(arr) / sizeof(arr[0]);
    int i;

    printf("Original Array:\n");

    for(i = 0; i < size; i++) {
        printf("%d ", *(arr + i));
    }

    rearrange(arr, size);

    printf("\n\nRearranged Array:\n");

    for(i = 0; i < size; i++) {
        printf("%d ", *(arr + i));
    }

    return 0;
}
```

---

# Topic 3: Arrays

## Question

You are given a 2D matrix of size n x n where each row and each column is sorted in increasing order. Write a C function to determine whether a given key exists in the matrix using the most efficient approach.

---

## Answer

```c
#include <stdio.h>

int searchMatrix(int matrix[100][100], int n, int key) {

    int row = 0;
    int col = n - 1;

    while(row < n && col >= 0) {

        if(matrix[row][col] == key) {
            return 1;
        }

        else if(matrix[row][col] > key) {
            col--;
        }

        else {
            row++;
        }
    }

    return 0;
}

int main() {

    int matrix[100][100], n, key;
    int i, j;

    printf("Enter size of matrix: ");
    scanf("%d", &n);

    printf("Enter matrix elements:\n");

    for(i = 0; i < n; i++) {
        for(j = 0; j < n; j++) {
            scanf("%d", &matrix[i][j]);
        }
    }

    printf("Enter key to search: ");
    scanf("%d", &key);

    if(searchMatrix(matrix, n, key)) {
        printf("Key found in matrix.\n");
    }
    else {
        printf("Key not found in matrix.\n");
    }

    return 0;
}
```
