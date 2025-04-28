#include <stdio.h>

int isprime(int x) {
    if (x <= 1) return 0; // 0 and 1 are not prime
    if (x <= 3) return 1; // 2 and 3 are prime
    if (x % 2 == 0 || x % 3 == 0) return 0; // multiples of 2 and 3 are not prime
    
    for (int i = 5; i * i <= x; i += 6) {
        if (x % i == 0 || x % (i + 2) == 0) return 0;
    }
    
    return 1;
}

void divide(int x, int y, int *quotient, int *remainder) {
    *quotient = x / y;
    *remainder = x % y;
}

int main() {
    int n;
    printf("Enter a natural number n: ");
    scanf("%d", &n);
    
    printf("Prime numbers between 1 and %d:\n", n);
    int primeCount = 0;
    for (int i = 2; i <= n; i++) {
        if (isprime(i)) {
            printf("%d ", i);
            primeCount++;
        }
    }
    
    printf("\nTotal prime numbers between 1 and %d: %d\n", n, primeCount);
    
    return 0;
}