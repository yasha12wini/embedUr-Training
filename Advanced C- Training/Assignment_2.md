# Advance C Programming – Module 2 Assignment

## Questions (click to jump)

* [1. Multi-threading program with 3 threads](#1-multi-threading-program-with-3-threads)
* [2. Add signal handling + execution flow](#2-add-signal-handling--execution-flow)
* [3. Child process – fork()](#3-child-process--fork)
* [4. Handling common signals](#4-handling-common-signals)
* [5. Exploring different kernel crashes](#5-exploring-different-kernel-crashes)
* [6. Time complexity](#6-time-complexity)
* [7. Locking mechanism – mutex / spinlock](#7-locking-mechanism--mutex--spinlock)

---

# Answers

## 1. Multi-threading program with 3 threads

<a id="1-multi-threading-program-with-3-threads"></a>

### C Program

```c
#include <stdio.h>
#include <pthread.h>
#include <unistd.h>

int N;

int isPrime(int n){
    if(n < 2) return 0;
    for(int i = 2; i * i <= n; i++){
        if(n % i == 0) return 0;
    }
    return 1;
}

void* threadA(void* arg){
    int count = 0, num = 2, sum = 0;

    while(count < N){
        if(isPrime(num)){
            sum += num;
            count++;
        }
        num++;
    }

    printf("Sum of first %d prime numbers = %d\n", N, sum);
    return NULL;
}

void* threadB(void* arg){
    for(int i = 0; i < 50; i++){
        printf("Thread 1 running\n");
        sleep(2);
    }
    return NULL;
}

void* threadC(void* arg){
    for(int i = 0; i < 34; i++){
        printf("Thread 2 running\n");
        sleep(3);
    }
    return NULL;
}

int main(){
    pthread_t t1, t2, t3;

    printf("Enter N: ");
    scanf("%d", &N);

    pthread_create(&t1, NULL, threadA, NULL);
    pthread_create(&t2, NULL, threadB, NULL);
    pthread_create(&t3, NULL, threadC, NULL);

    pthread_join(t1, NULL);
    pthread_join(t2, NULL);
    pthread_join(t3, NULL);

    return 0;
}
```


---

## 2. Add signal handling + execution flow

<a id="2-add-signal-handling--execution-flow"></a>

### Add signal handler

```c
#include <signal.h>

void handler(int sig){
    printf("Signal %d received. Program continues...\n", sig);
}

int main(){
    signal(SIGINT, handler);
    signal(SIGTERM, handler);
}
```

### Flow of execution

1. User enters N
2. Main creates 3 threads
3. Thread A calculates prime sum
4. Thread B prints every 2 sec
5. Thread C prints every 3 sec
6. SIGINT handled without terminating
7. main waits using join

### Time taken

* Thread A → depends on N
* Thread B → 100 sec
* Thread C → about 102 sec
* Total → longest thread decides completion


---

## 3. Child process – fork()

<a id="3-child-process--fork"></a>

### Notes

`fork()` creates a new child process.

* Parent gets child PID
* Child gets 0
* Runs independently

Example:

```c
#include <stdio.h>
#include <unistd.h>

int main(){
    pid_t pid = fork();

    if(pid == 0)
        printf("Child process\n");
    else
        printf("Parent process\n");

    return 0;
}
```


---

## 4. Handling common signals

<a id="4-handling-common-signals"></a>

Common signals:

* `SIGINT` → Ctrl+C
* `SIGTERM` → terminate request
* `SIGKILL` → force kill
* `SIGSEGV` → invalid memory access
* `SIGALRM` → timer expired

Signals are handled using:

```c
signal(SIGINT, handler);
```

---

## 5. Exploring different kernel crashes

<a id="5-exploring-different-kernel-crashes"></a>

### Examples

**Kernel Panic**

* unrecoverable error

**NULL pointer dereference**

* invalid memory access

**Stack overflow**

* recursion exceeds stack

**Deadlock**

* threads wait forever

**Memory corruption**

* overwrite memory

Debug tools:

* dmesg
* logs
* stack trace


---

## 6. Time complexity

<a id="6-time-complexity"></a>

Measures efficiency.

Examples:

* O(1)
* O(log n)
* O(n)
* O(n²)

Prime checking here:

```c
for(i=2;i*i<=n;i++)
```

Complexity ≈ O(√n)


---

## 7. Locking mechanism – mutex / spinlock

<a id="7-locking-mechanism--mutex--spinlock"></a>

### Mutex

Thread sleeps while waiting.

```c
pthread_mutex_lock(&m);
pthread_mutex_unlock(&m);
```

### Spinlock

Thread keeps checking continuously.

```c
pthread_spin_lock(&s);
pthread_spin_unlock(&s);
```

### Difference

| Mutex                | Spinlock   |
| -------------------- | ---------- |
| sleeps               | busy wait  |
| better for long wait | short wait |

