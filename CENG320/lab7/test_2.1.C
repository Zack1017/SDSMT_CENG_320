#include <stdio.h>

int main() {
    int week, pennies, nickels, dimes, quarters;
    int total_pennies = 0, total_nickels = 0, total_dimes = 0, total_quarters = 0;
    int total_cents = 0;

    for (week = 1; week <= 4; week++) {
        printf("Enter the number of pennies, nickels, dimes, and quarters for week %d: ", week);
        scanf("%d %d %d %d", &pennies, &nickels, &dimes, &quarters);

        total_pennies += pennies;
        total_nickels += nickels;
        total_dimes += dimes;
        total_quarters += quarters;
    }

    total_cents = total_pennies + 5 * total_nickels + 10 * total_dimes + 25 * total_quarters;
    float total_dollars = total_cents / 100.0;
    float weekly_average = total_dollars / 4;
    float yearly_savings = total_dollars * 52;

    printf("Over four weeks you have collected %d pennies, %d nickels, %d dimes, and %d quarters.\n", 
           total_pennies, total_nickels, total_dimes, total_quarters);
    printf("This comes to $%.2f\n", total_dollars);
    printf("Your weekly average is $%.2f\n", weekly_average);
    printf("Your estimated yearly savings is $%.2f\n", yearly_savings);

    return 0;
}